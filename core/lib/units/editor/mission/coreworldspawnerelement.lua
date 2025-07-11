CoreWorldEventUnitElement = CoreWorldEventUnitElement or class(MissionElement)

function CoreWorldEventUnitElement:init(type, ...)
	CoreWorldEventUnitElement.super.init(self, ...)

	self._type = type
	self._guis = {}
	self._hed.event_list = {}

	table.insert(self._save_values, "event_list")
end

function CoreWorldEventUnitElement:layer_finished(...)
	CoreWorldEventUnitElement.super.layer_finished(self, ...)
end

function CoreWorldEventUnitElement:selected()
	InstanceEventUnitElement.super.selected(self)
end

function CoreWorldEventUnitElement:update_selected(t, dt)
	local script_name = self._unit:mission_element_data().script

	for _, data in ipairs(self._hed.event_list) do
		self:_draw_world_link(t, dt, data.world_name, script_name)
	end
end

function CoreWorldEventUnitElement:update_editing(t, dt)
	return
end

function CoreWorldEventUnitElement:_draw_world_link(t, dt, world_name, script_name)
	local r, g, b = self:get_link_color()

	if self._type == "input" then
		Application:draw_arrow(self._unit:position(), managers.worldcollection:get_world_position(world_name, script_name), r, g, b, 0.2)
	else
		Application:draw_arrow(managers.worldcollection:get_world_position(world_name, script_name), self._unit:position(), r, g, b, 0.2)
	end
end

function CoreWorldEventUnitElement:_world_name_raycast()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if not ray or not ray.unit then
		return nil
	end

	local world_name

	if ray.unit:mission_element_data() and ray.unit:mission_element_data().element_class == "ElementWorldPoint" then
		world_name = ray.unit:unit_data().name_id
	end

	return world_name
end

function CoreWorldEventUnitElement:on_world_changed_name(old_name, new_name)
	for _, data in ipairs(self._hed.event_list) do
		if data.world_name == old_name then
			data.world_name = new_name
		end
	end

	for _, data in ipairs(self._guis) do
		if data.world_name == old_name then
			data.world_name = new_name

			data.world_name_ctrlr:set_label(new_name)
		end
	end
end

function CoreWorldEventUnitElement:on_world_deleted(name)
	local clone_guis = clone(self._guis)

	for i, event_list_data in ipairs(clone(self._hed.event_list)) do
		if event_list_data.world_name == name then
			self:remove_entry(event_list_data)
		end
	end
end

function CoreWorldEventUnitElement:_get_events(world_name)
	local id = self._type == "input" and "ElementWorldInput" or "ElementWorldOutput"

	return managers.worldcollection:get_mission_elements_from_script(world_name, id)
end

function CoreWorldEventUnitElement:_set_world_by_raycast()
	local world_name = self:_world_name_raycast()

	if world_name then
		self:_add_world_by_name(world_name)
	end
end

function CoreWorldEventUnitElement:_add_world_by_name(world_name)
	local world = managers.worldcollection:world_names()[self._unit:mission_element_data().script][world_name].world
	local events = self:_get_events(world)
	local event_list_data = {
		event = events[1],
		world_name = world_name,
	}

	table.insert(self._hed.event_list, event_list_data)
	self:_add_world_gui(world_name, events, event_list_data)
end

function CoreWorldEventUnitElement:_add_world_gui(world_name, events, event_list_data)
	local panel = self._panel
	local panel_sizer = self._panel_sizer
	local h_sizer = EWS:BoxSizer("HORIZONTAL")

	panel_sizer:add(h_sizer, 0, 1, "EXPAND,LEFT")

	local world_name_ctrlr = EWS:StaticText(panel, "" .. world_name, 0, "ALIGN_LEFT")

	h_sizer:add(world_name_ctrlr, 2, 1, "LEFT,ALIGN_CENTER_VERTICAL")

	local events_params = {
		ctrlr_proportions = 2,
		name_proportions = 0,
		options = events,
		panel = panel,
		sizer = h_sizer,
		sizer_proportions = 2,
		sorted = true,
		tooltip = "Select an event from the combobox",
		value = event_list_data.event,
	}
	local event = CoreEws.combobox(events_params)
	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("SELECT", "Remove", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("SELECT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "remove_entry"), event_list_data)
	toolbar:realize()
	table.insert(self._guis, {
		event = event,
		name_ctrlr = events_params.name_ctrlr,
		toolbar = toolbar,
		world_name = world_name,
		world_name_ctrlr = world_name_ctrlr,
	})
	h_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	event:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_on_gui_set_event_data"), event_list_data)
	panel:layout()
end

function CoreWorldEventUnitElement:_on_gui_set_event_data(event_list_data)
	local guis = self:_get_guis_by_event_list_data(event_list_data)
	local event = guis.event:get_value()

	event_list_data.event = event
end

function CoreWorldEventUnitElement:_get_guis_by_event_list_data(event_list_data)
	for i, entry in pairs(clone(self._hed.event_list)) do
		if entry == event_list_data then
			return self._guis[i]
		end
	end
end

function CoreWorldEventUnitElement:remove_entry(event_list_data)
	local function _remove_guis(guis)
		if guis then
			guis.world_name_ctrlr:destroy()
			guis.event:destroy()

			if guis.name_ctrlr then
				guis.name_ctrlr:destroy()
			end

			guis.toolbar:destroy()
			table.delete(self._guis, guis)
			self._panel:layout()
		end
	end

	for i, entry in pairs(clone(self._hed.event_list)) do
		if entry == event_list_data then
			table.remove(self._hed.event_list, i)
			_remove_guis(self._guis[i])

			break
		end
	end
end

function CoreWorldEventUnitElement:destroy_panel(...)
	CoreWorldEventUnitElement.super.destroy_panel(self, ...)
end

function CoreWorldEventUnitElement:_on_gui_select_world_list()
	local settings = {}

	settings.list_style = "LC_REPORT,LC_NO_HEADER,LC_SORT_ASCENDING"

	local script_name = self._unit:mission_element_data().script
	local names = managers.worldcollection:world_name_ids(script_name)
	local title = "Select " .. script_name .. "'s worlds"
	local dialog = SelectNameModal:new(title, names, settings)

	if dialog:cancelled() then
		return
	end

	for _, instance_name in ipairs(dialog:_selected_item_assets()) do
		self:_add_world_by_name(instance_name)
	end
end

function CoreWorldEventUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local btn_toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	btn_toolbar:add_tool("SELECT_UNIT_LIST", "Select unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	btn_toolbar:connect("SELECT_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_on_gui_select_world_list"), nil)
	btn_toolbar:realize()
	panel_sizer:add(btn_toolbar, 0, 1, "EXPAND,LEFT")

	for _, data in pairs(clone(self._hed.event_list)) do
		local world = managers.worldcollection:world_names()[self._unit:mission_element_data().script][data.world_name].world
		local events = self:_get_events(world)

		self:_add_world_gui(data.world_name, events, data)
	end
end

function CoreWorldEventUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "_set_world_by_raycast"))
end

CoreWorldInputEventUnitElement = CoreWorldInputEventUnitElement or class(CoreWorldEventUnitElement)

function CoreWorldInputEventUnitElement:init(...)
	CoreWorldInputEventUnitElement.super.init(self, "input", ...)
end

CoreWorldOutputEventUnitElement = CoreWorldOutputEventUnitElement or class(CoreWorldEventUnitElement)

function CoreWorldOutputEventUnitElement:init(...)
	CoreWorldOutputEventUnitElement.super.init(self, "output", ...)
end

CoreWorldInputUnitElement = CoreWorldInputUnitElement or class(MissionElement)

function CoreWorldInputUnitElement:init(...)
	CoreWorldInputUnitElement.super.init(self, ...)

	self._hed.event = "none"

	table.insert(self._save_values, "event")
end

function CoreWorldInputUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local event = EWS:TextCtrl(panel, self._hed.event, "", "TE_PROCESS_ENTER")

	panel_sizer:add(event, 0, 0, "EXPAND")
	event:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		ctrlr = event,
		value = "event",
	})
	event:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		ctrlr = event,
		value = "event",
	})
end

CoreWorldOutputUnitElement = CoreWorldOutputUnitElement or class(MissionElement)

function CoreWorldOutputUnitElement:init(...)
	CoreWorldOutputUnitElement.super.init(self, ...)

	self._hed.event = "none"

	table.insert(self._save_values, "event")
end

function CoreWorldOutputUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local event = EWS:TextCtrl(panel, self._hed.event, "", "TE_PROCESS_ENTER")

	panel_sizer:add(event, 0, 0, "EXPAND")
	event:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		ctrlr = event,
		value = "event",
	})
	event:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		ctrlr = event,
		value = "event",
	})
end

CoreWorldSpawnerElement = CoreWorldSpawnerElement or class(MissionElement)

function CoreWorldSpawnerElement:init(unit)
	CoreWorldSpawnerElement.super.init(self, unit)

	self._hed.world = ""

	table.insert(self._save_values, "state")
	table.insert(self._save_values, "world")
end

function CoreWorldSpawnerElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local worlds = self:_get_worlds()

	self:_build_value_combobox(panel, panel_sizer, "world", worlds, "Select a world from the combobox")
	self:_add_help_text("Please select a world to be loaded from the combobox above!\nOn execution or operation type \"spawn\" this point will spawn the selected world at its position.")
end

function CoreWorldSpawnerElement:_get_worlds()
	local t = {
		"",
	}

	for level_id, data in pairs(_G.tweak_data.levels) do
		if type(data) == "table" and data.world_name then
			table.insert(t, level_id)
		end
	end

	table.sort(t)

	return t
end

function CoreWorldSpawnerElement:set_element_data(...)
	CoreWorldSpawnerElement.super.set_element_data(self, ...)
	self:_change_world()
end

function CoreWorldSpawnerElement:post_init()
	CoreWorldSpawnerElement.super.post_init(self)
	managers.worldcollection:register_editor_position(self._unit:unit_data().name_id, self._unit:mission_element_data().script, self._unit:position())
	self:_change_world()
end

local IDS_RP_WORLDS = Idstring("rp_worlds")

function CoreWorldSpawnerElement:_change_world()
	self:_delete_low_poly_unit()

	local world_meta_data = _G.tweak_data.levels[self._hed.world]

	if world_meta_data then
		if world_meta_data.low_poly and world_meta_data.low_poly ~= "" then
			self._low_poly_unit = CoreUnit.safe_spawn_unit(world_meta_data.low_poly, self._unit:position(), self._unit:rotation())

			self._unit:link(IDS_RP_WORLDS, self._low_poly_unit)
		end

		managers.worldcollection:register_editor_name(self._unit:unit_data().name_id, self._unit:mission_element_data().script, self._hed.world)
	else
		self._hed.world = nil

		managers.worldcollection:register_editor_name(self._unit:unit_data().name_id, self._unit:mission_element_data().script, nil)
	end
end

function CoreWorldSpawnerElement:_delete_low_poly_unit()
	if alive(self._low_poly_unit) then
		World:delete_unit(self._low_poly_unit)

		self._low_poly_unit = nil
	end
end

function CoreWorldSpawnerElement:_set_vis_low_poly_unit(state)
	if self._low_poly_unit then
		self._low_poly_unit:set_visible(state)
	end
end

function CoreWorldSpawnerElement:destroy()
	self:_delete_low_poly_unit()
	CoreWorldSpawnerElement.super.destroy(self)
end

function CoreWorldSpawnerElement:set_disabled()
	self:_set_vis_low_poly_unit(false)
	CoreWorldSpawnerElement.super.set_disabled(self)
end

function CoreWorldSpawnerElement:set_enabled()
	self:_set_vis_low_poly_unit(true)
	CoreWorldSpawnerElement.super.set_enabled(self)
end

function CoreWorldSpawnerElement:on_name_changed(old_name, new_name)
	Application:debug("[CoreWorldSpawnerElement:on_name_changed]", old_name, new_name)

	local mission_element_data = self._unit:mission_element_data()
	local script_name = mission_element_data.script
	local mission_units = managers.editor:layer("Mission"):get_created_unit_by_pattern({
		"func_world_input_event",
		"func_world_output_event",
		"func_world_point",
		"func_world_set_params",
	})

	for _, mission_unit in ipairs(mission_units) do
		if mission_unit:mission_element().on_world_changed_name then
			mission_unit:mission_element():on_world_changed_name(script_name, old_name, new_name)
		elseif mission_element_data.world == old_name then
			self._hed.world = new_name
		end
	end

	managers.worldcollection:on_editor_changed_name(script_name, old_name, new_name)
end

function CoreWorldSpawnerElement:on_world_deleted()
	Application:debug("[CoreWorldSpawnerElement:on_world_deleted()]")

	local editor_name = self._unit:unit_data().name_id
	local script_name = self._unit:unit_data().script
	local mission_units = managers.editor:layer("Mission"):get_created_unit_by_pattern({
		"func_world_input_event",
		"func_world_output_event",
		"func_world_set_params",
	})

	for _, mission_unit in ipairs(mission_units) do
		if mission_unit:mission_element().on_world_deleted then
			mission_unit:mission_element():on_world_deleted(editor_name)
		end
	end

	managers.worldcollection:unregister_editor_name(editor_name, script_name)
end
