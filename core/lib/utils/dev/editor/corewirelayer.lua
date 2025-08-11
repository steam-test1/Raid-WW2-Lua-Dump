core:module("CoreWireLayer")
core:import("CoreLayer")
core:import("CoreEditorSave")
core:import("CoreTable")
core:import("CoreMath")
core:import("CoreEws")

WireLayer = WireLayer or class(CoreLayer.Layer)

local WIRE_DOT_DRAW_RADIUS = 15
local GRAB_OFF = 0
local GRAB_START = 1
local GRAB_END = 2

function WireLayer:init(owner, save_name, units_vector, slot_mask)
	WireLayer.super.init(self, owner, save_name or "wires")

	self._current_pos = Vector3(0, 0, 0)
	self._current_rot = Rotation()
	self._ctrlrs = {}

	self:load_unit_map_from_vector(units_vector or {
		"wire",
	})

	self._unit_name = ""
	self._target_name = Idstring("a_target")
	self._middle_name = Idstring("a_bender")
	self._slot_mask = managers.slot:get_mask(slot_mask or "wires")
	self._grab = false
	self._grab_type = GRAB_OFF
end

function WireLayer:save()
	for _, unit in ipairs(self._created_units) do
		local target = unit:get_object(self._target_name)
		local t_pos = math.vector_to_string(target:position())
		local t_rot = target:rotation()
		local wire_data = {
			slack = unit:wire_data().slack,
			target_pos = target:position(),
			target_rot = target:rotation(),
		}
		local t = {
			continent = unit:unit_data().continent and unit:unit_data().continent:name(),
			data = {
				unit_data = CoreEditorSave.save_data_table(unit),
				wire_data = wire_data,
			},
			entry = self._save_name,
		}

		self:_add_project_unit_save_data(unit, t.data)
		managers.editor:add_save_data(t)
		managers.editor:add_to_world_package({
			category = "units",
			continent = unit:unit_data().continent,
			name = unit:name():s(),
		})
	end
end

function WireLayer:update_unit_settings()
	WireLayer.super.update_unit_settings(self)

	if self._selected_unit then
		CoreEws.change_slider_and_number_value(self._slack_params, self._selected_unit:wire_data().slack)
	else
		CoreEws.change_slider_and_number_value(self._slack_params, 0)
	end
end

function WireLayer:spawn_unit()
	if self._grab then
		return
	end

	if not self._creating_wire then
		self:clear_selected_units()

		local unit = self:do_spawn_unit(self._unit_name, self._current_pos, self._current_rot)

		if self._selected_unit then
			self._creating_wire = true

			self._selected_unit:orientation_object():set_position(self._current_pos)
			self._selected_unit:get_object(self._target_name):set_position(self._current_pos)

			self._selected_point = nil
		end

		self:_on_new_wire_placed_start(unit)
	else
		self._creating_wire = false
		self._selected_point = self._selected_unit:get_object(self._target_name)

		self:_on_new_wire_placed_end(self._selected_unit)
	end
end

function WireLayer:set_select_unit(unit)
	WireLayer.super.set_select_unit(self, unit)

	self._selected_point = nil

	if self._selected_unit then
		self._selected_point = self._selected_unit:get_object(self._target_name)
	end
end

function WireLayer:delete_selected_unit()
	if self._selected_unit then
		for _, unit in ipairs(CoreTable.clone(self._selected_units)) do
			self:delete_unit(unit)
		end
	end
end

function WireLayer:delete_unit(unit)
	WireLayer.super.delete_unit(self, unit)

	self._creating_wire = nil
	self._selected_point = nil
end

function WireLayer:grab_point()
	if self._selected_unit then
		self._grab = true
		self._grab_type = self:_is_start_point_closest() and GRAB_START or GRAB_END

		if self._grab_type == GRAB_START then
			self._selected_point_old_position = self._selected_point:position()
			self._selected_point_old_rotation = self._selected_point:rotation()

			self:_on_grab_wire(self._selected_unit, self._selected_point)
		end
	end
end

function WireLayer:release_grab_point()
	if self._grab then
		if self._grab_type == GRAB_START and self._selected_point and self._selected_point_old_position and self._selected_point_old_rotation then
			self._selected_point:set_position(self._selected_point_old_position)
			self._selected_point:set_rotation(self._selected_point_old_rotation)

			self._selected_point_old_position = nil
			self._selected_point_old_rotation = nil

			self:set_midpoint()
		end

		self._grab = false
		self._grab_type = GRAB_OFF

		self:_on_grab_wire_placed(self._selected_unit, self._selected_point)
	end
end

function WireLayer:_is_start_point_closest()
	if self._selected_unit then
		local pos_start = self._selected_unit:position()
		local pos_end = self._selected_unit:get_object(self._target_name):position()
		local dist_start = mvector3.distance(self._current_pos, pos_start)
		local dist_end = mvector3.distance(self._current_pos, pos_end)

		return dist_start < dist_end
	end

	return nil
end

function WireLayer:update(t, dt)
	WireLayer.super.update(self, t, dt)

	local ray = self._owner:select_unit_by_raycast(self._slot_mask)

	if ray then
		Application:draw_sphere(ray.position, 100, 1, 0, 0)
	end

	local p1 = self._owner:get_cursor_look_point(0)
	local p2 = self._owner:get_cursor_look_point(25000)
	local ray = World:raycast(p1, p2, nil, 1, 11, 15, 20, 21, 24, 35, 38)

	if ray then
		self._current_pos = ray.position

		local u_rot = Rotation()
		local z = ray.normal
		local x = (u_rot:x() - z * z:dot(u_rot:x())):normalized()
		local y = z:cross(x)
		local rot = Rotation(x, y, z)

		self._current_rot = rot
	end

	for _, unit in ipairs(self._selected_units) do
		if alive(unit) then
			local co = unit:get_object(Idstring("co_cable"))

			if co then
				Application:draw(co, 1, 1, 1)
			end
		end
	end

	local start_is_closest = self:_is_start_point_closest()

	if not self._grab then
		Application:draw_sphere(self._current_pos, WIRE_DOT_DRAW_RADIUS, 0, 1, 0)
	end

	if self._selected_unit then
		local co = self._selected_unit:get_object(Idstring("co_cable"))

		if co then
			Application:draw(co, 0, 1, 0)
		end

		Application:draw_sphere(self._selected_unit:position(), WIRE_DOT_DRAW_RADIUS, 1, 1, 1)

		if self._creating_wire or self._grab_type == GRAB_END then
			local dot = self._current_rot:y():dot(self._selected_unit:rotation():y())

			dot = (dot - 1) / -2
			self._current_rot = self._current_rot * Rotation(180 * dot, 0, 0)
		end

		Application:draw_sphere(self._selected_unit:get_object(self._middle_name):position(), WIRE_DOT_DRAW_RADIUS, 0, 0, 1)

		if self._creating_wire then
			local s_pos = self._selected_unit:orientation_object():position()

			self._selected_unit:get_object(self._target_name):set_position(self._current_pos)
			self._selected_unit:get_object(self._target_name):set_rotation(self._current_rot)
			self:set_midpoint()
		end
	end

	if self._selected_point then
		Application:draw_sphere(self._selected_point:position(), WIRE_DOT_DRAW_RADIUS, 1, 1, 0)

		if self._grab then
			if self._grab_type == GRAB_END then
				self._selected_point:set_position(self._current_pos)
				self._selected_point:set_rotation(self._current_rot)
			elseif self._grab_type == GRAB_START then
				self._selected_unit:set_position(self._current_pos)
				self._selected_unit:set_rotation(self._current_rot)
			end

			self:set_midpoint()
		end

		local pos_start = self._selected_unit:position()
		local pos_end = self._selected_point:position()
		local pos_middle = (pos_start + pos_end) / 2
		local pos_middle_obj = self._selected_unit:get_object(self._middle_name):position()

		Application:draw_line(pos_start, pos_end, 1, 0.5, 0.5)
		Application:draw_line(pos_start, pos_middle_obj, 0.5, 1, 0.5)
		Application:draw_line(pos_end, pos_middle_obj, 0.5, 1, 0.5)
		Application:draw_line(pos_middle, pos_middle_obj, 0.5, 0.5, 1)

		if start_is_closest ~= nil then
			if start_is_closest then
				Application:draw_line(self._current_pos, pos_start, 0.5, 0.5, 0.5)
			else
				Application:draw_line(self._current_pos, pos_end, 0.5, 0.5, 0.25)
			end
		end

		Application:draw_rotation(pos_start, self._selected_unit:rotation())
		Application:draw_rotation(pos_end, self._selected_point:rotation())
	end

	Application:draw_rotation(self._current_pos, self._current_rot)
end

function WireLayer:_on_new_wire_placed_start(unit)
	print("_on_new_wire_placed_start", unit)
end

function WireLayer:_on_new_wire_placed_end(unit)
	print("_on_new_wire_placed_end", unit)
end

function WireLayer:_on_grab_wire(unit, point_obj)
	print("_on_grab_wire", unit)
end

function WireLayer:_on_grab_wire_placed(unit, point_obj)
	print("_on_grab_wire_placed", unit)
end

function WireLayer:build_panel(notebook)
	cat_print("editor", "WireLayer:build_panel")

	self._ews_triggers = {}
	self._ews_panel = EWS:Panel(notebook, "", "TAB_TRAVERSAL")
	self._main_sizer = EWS:BoxSizer("HORIZONTAL")

	self._ews_panel:set_sizer(self._main_sizer)

	self._sizer = EWS:BoxSizer("VERTICAL")

	self:build_name_id()
	self._sizer:add(self:build_units(), 1, 0, "EXPAND")

	local slack_sizer = EWS:BoxSizer("VERTICAL")

	self._sizer:add(slack_sizer, 1, 0, "EXPAND")

	local slack_params = {
		ctrlr_proportions = 4,
		floats = 0,
		max = 2500,
		min = 0,
		name = "Slack:",
		name_proportions = 1,
		number_ctrlr_proportions = 1,
		panel = self._ews_panel,
		sizer = slack_sizer,
		slider_ctrlr_proportions = 3,
		value = 0,
	}

	CoreEws.slider_and_number_controller(slack_params)
	slack_params.slider_ctrlr:connect("EVT_SCROLL_THUMBTRACK", callback(self, self, "change_slack"), nil)
	slack_params.slider_ctrlr:connect("EVT_SCROLL_CHANGED", callback(self, self, "change_slack"), nil)
	slack_params.number_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "change_slack"), nil)
	slack_params.number_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "change_slack"), nil)

	self._slack_params = slack_params

	self._main_sizer:add(self._sizer, 1, 0, "EXPAND")

	return self._ews_panel
end

function WireLayer:change_slack(wire_slack)
	if self._selected_unit then
		self._selected_unit:wire_data().slack = self._slack_params.value

		self:set_midpoint()
	end
end

function WireLayer:set_midpoint()
	if self._selected_unit then
		self._selected_unit:set_moving()
		CoreMath.wire_set_midpoint(self._selected_unit, self._selected_unit:orientation_object():name(), self._target_name, self._middle_name)
	end
end

function WireLayer:deselect()
	WireLayer.super.deselect(self)
end

function WireLayer:clear()
	WireLayer.super.clear(self)

	self._selected_point = nil
end

function WireLayer:get_help(text)
	local t = "\t"
	local n = "\n"

	text = text .. "Select unit:     Click left mouse button on either attach point" .. n
	text = text .. "Create unit:     Click right mouse button (once the spawn, twice to attach target position)" .. n
	text = text .. "Grab point:      Click extra mouse button to grab a wire end (Nearest selected is grabbed)" .. n
	text = text .. "Remove unit:     Press delete"

	return text
end

function WireLayer:add_triggers()
	WireLayer.super.add_triggers(self)

	local vc = self._editor_data.virtual_controller

	vc:add_trigger(Idstring("destroy"), callback(self, self, "delete_selected_unit"))
	vc:add_trigger(Idstring("rmb"), callback(self, self, "spawn_unit"))
	vc:add_trigger(Idstring("emb"), callback(self, self, "grab_point"))
	vc:add_release_trigger(Idstring("emb"), callback(self, self, "release_grab_point"))

	for k, cb in pairs(self._ews_triggers) do
		vc:add_trigger(Idstring(k), cb)
	end
end

function WireLayer:deactivate()
	WireLayer.super.deactivate(self)
	WireLayer.super.deselect(self)
end

function WireLayer:clear_triggers()
	self._editor_data.virtual_controller:clear_triggers()
end
