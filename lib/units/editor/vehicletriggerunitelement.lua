VehicleTriggerUnitElement = VehicleTriggerUnitElement or class(MissionElement)
VehicleTriggerUnitElement.LINK_VALUES = {
	{
		layer = "Statics",
		output = true,
		table_value = "elements",
		type = "operator",
	},
}
VehicleTriggerUnitElement.ON_ENTER = "on_enter"
VehicleTriggerUnitElement.ON_EXIT = "on_exit"
VehicleTriggerUnitElement.ON_ALL_INSIDE = "on_all_inside"
VehicleTriggerUnitElement.ON_SPAWN = "on_spawn"
VehicleTriggerUnitElement.ON_DESPAWN = "on_despawn"
VehicleTriggerUnitElement.ON_LOOT_ADDED = "on_loot_added"
VehicleTriggerUnitElement.ON_LOOT_REMOVED = "on_loot_removed"
VehicleTriggerUnitElement.events = {
	VehicleTriggerUnitElement.ON_ENTER,
	VehicleTriggerUnitElement.ON_EXIT,
	VehicleTriggerUnitElement.ON_ALL_INSIDE,
	VehicleTriggerUnitElement.ON_SPAWN,
	VehicleTriggerUnitElement.ON_DESPAWN,
	VehicleTriggerUnitElement.ON_LOOT_ADDED,
	VehicleTriggerUnitElement.ON_LOOT_REMOVED,
}

function VehicleTriggerUnitElement:init(unit)
	Application:debug("VehicleTriggerUnitElement:init")
	VehicleTriggerUnitElement.super.init(self, unit)

	self._hed.trigger_times = 1
	self._hed.event = VehicleTriggerUnitElement.ON_ENTER
	self._hed.elements = {}

	table.insert(self._save_values, "event")
	table.insert(self._save_values, "elements")
end

function VehicleTriggerUnitElement:_build_panel(panel, panel_sizer)
	Application:debug("VehicleTriggerUnitElement:_build_panel")
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "event", VehicleTriggerUnitElement.events, "Select an event from the combobox")

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_UNIT_LIST", "Add unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "add_unit_list_btn"), nil)
	toolbar:add_tool("REMOVE_UNIT_LIST", "Remove unit from unit list", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("REMOVE_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "remove_unit_list_btn"), nil)
	toolbar:realize()
	panel_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	self:_add_help_text("Set the vehicle event the element should trigger on.")
end

VehicleTriggerUnitElement.add_element = VehicleOperatorUnitElement.add_element
VehicleTriggerUnitElement.add_triggers = VehicleOperatorUnitElement.add_triggers
VehicleTriggerUnitElement.draw_links_unselected = VehicleOperatorUnitElement.draw_links_unselected
VehicleTriggerUnitElement.draw_links_selected = VehicleOperatorUnitElement.draw_links_selected
VehicleTriggerUnitElement.add_unit_list_btn = VehicleOperatorUnitElement.add_unit_list_btn
VehicleTriggerUnitElement.remove_unit_list_btn = VehicleOperatorUnitElement.remove_unit_list_btn
