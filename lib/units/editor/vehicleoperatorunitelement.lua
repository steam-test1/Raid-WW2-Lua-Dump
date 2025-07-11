VehicleOperatorUnitElement = VehicleOperatorUnitElement or class(MissionElement)
VehicleOperatorUnitElement.ACTIONS = {
	"none",
	"lock",
	"unlock",
	"secure",
	"break_down",
	"destroy_explode",
	"repair",
	"damage",
	"activate",
	"deactivate",
	"block",
	"kick",
	"disable_loot_interaction",
	"enable_loot_interaction",
	"disable_accepting_loot",
	"enable_accepting_loot",
	"disable_securing_loot",
	"enable_securing_loot",
	"enable_map_waypoint",
	"disable_map_waypoint",
	"enable_hud_waypoint",
	"disable_hud_waypoint",
}
VehicleOperatorUnitElement.LINK_VALUES = {
	{
		layer = "Statics",
		output = true,
		table_value = "elements",
		type = "operator",
	},
}

function VehicleOperatorUnitElement:init(unit)
	VehicleOperatorUnitElement.super.init(self, unit)

	self._hed.operation = "none"
	self._hed.damage = "0"
	self._hed.elements = {}

	table.insert(self._save_values, "use_instigator")
	table.insert(self._save_values, "operation")
	table.insert(self._save_values, "damage")
	table.insert(self._save_values, "elements")

	self._actions = VehicleOperatorUnitElement.ACTIONS
end

function VehicleOperatorUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = managers.slot:get_mask("vehicles"),
		ray_type = "body",
		sample = true,
	})

	if ray and ray.unit then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function VehicleOperatorUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function VehicleOperatorUnitElement:update_editing()
	local ray = managers.editor:unit_by_raycast({
		mask = managers.slot:get_mask("vehicles"),
		ray_type = "body",
		sample = true,
	})

	if ray and ray.unit then
		local sequences = managers.sequence:get_sequence_list(ray.unit:name())

		if #sequences > 0 then
			Application:draw(ray.unit, 0, 1, 0)
		end
	end
end

function VehicleOperatorUnitElement:draw_links_unselected(...)
	VehicleOperatorUnitElement.super.draw_links_unselected(self, ...)

	for _, id in ipairs(self._hed.elements) do
		local unit = managers.editor:unit_with_id(id)

		if alive(unit) then
			local params = {
				b = 0.5,
				from_unit = unit,
				g = 0,
				r = 0,
				to_unit = self._unit,
			}

			if unit and self._unit and self:_should_draw_link(unit, self._unit) then
				self:_draw_link(params)
			end

			Application:draw(unit, 0, 0, 0.5)
		end
	end
end

function VehicleOperatorUnitElement:draw_links_selected(t, dt, selected_unit, all_units)
	VehicleOperatorUnitElement.super.draw_links_selected(self, t, dt, selected_unit, all_units)

	for _, id in ipairs(self._hed.elements) do
		local unit = managers.editor:unit_with_id(id)
		local params = {
			b = 0.5,
			from_unit = self._unit,
			g = 0,
			r = 0,
			to_unit = unit,
		}

		if unit and self._unit and self:_should_draw_link(selected_unit, unit) then
			self:_draw_link(params)
			Application:draw(unit, 0.25, 1, 0.25)
		end
	end
end

function VehicleOperatorUnitElement:add_unit_list_btn()
	local script = self._unit:mission_element_data().script

	local function f(unit)
		if not unit or not unit:mission_element_data() or unit:mission_element_data().script ~= script then
			return
		end

		local id = unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			return false
		end

		return managers.editor:layer("Mission"):category_map()[unit:type():s()] or managers.editor:unit_in_layer(unit) == managers.editor:layer("Statics")
	end

	local dialog = SelectUnitByNameModal:new("Add Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		table.insert(self._hed.elements, id)
	end
end

function VehicleOperatorUnitElement:remove_unit_list_btn()
	local function f(unit)
		return table.contains(self._hed.elements, unit:unit_data().unit_id)
	end

	local dialog = SelectUnitByNameModal:new("Remove Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		table.delete(self._hed.elements, id)
	end
end

function VehicleOperatorUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "operation", self._actions, "Select an operation for the selected elements")
	self:_build_value_number(panel, panel_sizer, "damage", {
		floats = 0,
		min = 1,
	}, "Specify the amount of damage.")

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_UNIT_LIST", "Add unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "add_unit_list_btn"), nil)
	toolbar:add_tool("REMOVE_UNIT_LIST", "Remove unit from unit list", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("REMOVE_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "remove_unit_list_btn"), nil)
	toolbar:realize()
	panel_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	self:_build_value_checkbox(panel, panel_sizer, "use_instigator")
	self:_add_help_text("Choose an operation to perform on the selected elements. An element might not have the selected operation implemented and will then generate error when executed.")
end
