GlobalStateFilterElement = GlobalStateFilterElement or class(MissionElement)
GlobalStateFilterElement.STATES = {
	"set",
	"cleared",
	"value",
}

function GlobalStateFilterElement:init(unit)
	GlobalStateFilterElement.super.init(self, unit)

	self._hed.flag = ""
	self._hed.state = ""
	self._hed.check_type = ""

	table.insert(self._save_values, "flag")
	table.insert(self._save_values, "state")
	table.insert(self._save_values, "check_type")
	table.insert(self._save_values, "value")

	self._flags = tweak_data.operations:get_all_mission_flags()

	table.sort(self._flags)
end

function GlobalStateFilterElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "flag", self._flags, "Select a flag to test")
	self:_build_value_combobox(panel, panel_sizer, "state", GlobalStateFilterElement.STATES, "What state of the flag to test")

	local check_type_options = {
		"equal",
		"not_equal",
		"less_than",
		"greater_than",
		"less_or_equal",
		"greater_or_equal",
	}

	self:_build_value_combobox(panel, panel_sizer, "check_type", check_type_options, "Select which check operation to perform")

	local value_sizer = EWS:BoxSizer("HORIZONTAL")

	panel_sizer:add(value_sizer, 0, 0, "EXPAND")

	local value_name = EWS:StaticText(panel, "Value:", 0, "")

	value_sizer:add(value_name, 1, 0, "ALIGN_CENTER_VERTICAL")

	local value = EWS:TextCtrl(panel, self._hed.value, "", "TE_PROCESS_ENTER")

	value_sizer:add(value, 2, 0, "ALIGN_CENTER_VERTICAL")
	value:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		ctrlr = value,
		value = "value",
	})
	value:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		ctrlr = value,
		value = "value",
	})

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:realize()
	panel_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	self:_add_help_text("This filter element will execute depending on the filter conditions for the chosen flag.\nSet and Cleared are equal to True and False.\n'Check Type' option only applies to flags that use number values!")
end
