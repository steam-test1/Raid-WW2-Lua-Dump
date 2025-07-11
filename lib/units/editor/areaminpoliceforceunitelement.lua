AreaMinPoliceForceUnitElement = AreaMinPoliceForceUnitElement or class(MissionElement)

function AreaMinPoliceForceUnitElement:init(unit)
	AreaMinPoliceForceUnitElement.super.init(self, unit)

	self._hed.amount = 1

	table.insert(self._save_values, "amount")
end

function AreaMinPoliceForceUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local amount_params = {
		ctrlr_proportions = 2,
		floats = 0,
		min = 0,
		name = "Amount:",
		name_proportions = 1,
		panel = panel,
		sizer = panel_sizer,
		tooltip = "Set amount of enemy forces in area. Use 0 to define dynamic spawn area for \"street\" GroupAI.",
		value = self._hed.amount,
	}
	local amount_points = CoreEWS.number_controller(amount_params)

	amount_points:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		ctrlr = amount_points,
		value = "amount",
	})
	amount_points:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		ctrlr = amount_points,
		value = "amount",
	})
end
