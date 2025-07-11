FilterUnitElement = FilterUnitElement or class(MissionElement)

function FilterUnitElement:init(unit)
	FilterUnitElement.super.init(self, unit)

	self._hed.difficulty_normal = true
	self._hed.difficulty_hard = true
	self._hed.difficulty_overkill = true
	self._hed.difficulty_overkill_145 = true
	self._hed.player_1 = true
	self._hed.player_2 = true
	self._hed.player_3 = true
	self._hed.player_4 = true
	self._hed.platform_win32 = true
	self._hed.platform_console = true
	self._hed.mode_assault = true
	self._hed.mode_control = true
	self._hed.alarm_on = true
	self._hed.alarm_off = true

	table.insert(self._save_values, "difficulty_normal")
	table.insert(self._save_values, "difficulty_hard")
	table.insert(self._save_values, "difficulty_overkill")
	table.insert(self._save_values, "difficulty_overkill_145")
	table.insert(self._save_values, "player_1")
	table.insert(self._save_values, "player_2")
	table.insert(self._save_values, "player_3")
	table.insert(self._save_values, "player_4")
	table.insert(self._save_values, "platform_win32")
	table.insert(self._save_values, "platform_console")
	table.insert(self._save_values, "mode_assault")
	table.insert(self._save_values, "mode_control")
	table.insert(self._save_values, "alarm_on")
	table.insert(self._save_values, "alarm_off")
end

function FilterUnitElement:post_init(...)
	FilterUnitElement.super.post_init(self, ...)
	self:_check_convertion()
end

function FilterUnitElement:_check_convertion()
	return
end

function FilterUnitElement:_build_panel(panel, panel_sizer)
	self:_check_convertion()
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local h_sizer = EWS:BoxSizer("HORIZONTAL")

	panel_sizer:add(h_sizer, 0, 0, "EXPAND")

	local h2_sizer = EWS:BoxSizer("HORIZONTAL")

	panel_sizer:add(h2_sizer, 0, 0, "EXPAND")

	local difficulty_sizer = EWS:StaticBoxSizer(panel, "VERTICAL", "Difficulty")

	h_sizer:add(difficulty_sizer, 1, 0, "EXPAND")

	local difficulty_normal = EWS:CheckBox(panel, "Easy", "")

	difficulty_normal:set_value(self._hed.difficulty_normal)
	difficulty_normal:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = difficulty_normal,
		value = "difficulty_normal",
	})
	difficulty_sizer:add(difficulty_normal, 0, 0, "EXPAND")

	local difficulty_hard = EWS:CheckBox(panel, "Normal", "")

	difficulty_hard:set_value(self._hed.difficulty_hard)
	difficulty_hard:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = difficulty_hard,
		value = "difficulty_hard",
	})
	difficulty_sizer:add(difficulty_hard, 0, 0, "EXPAND")

	local difficulty_overkill = EWS:CheckBox(panel, "Hard", "")

	difficulty_overkill:set_value(self._hed.difficulty_overkill)
	difficulty_overkill:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = difficulty_overkill,
		value = "difficulty_overkill",
	})
	difficulty_sizer:add(difficulty_overkill, 0, 0, "EXPAND")

	local difficulty_overkill_145 = EWS:CheckBox(panel, "V.Hard", "")

	difficulty_overkill_145:set_value(self._hed.difficulty_overkill_145)
	difficulty_overkill_145:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = difficulty_overkill_145,
		value = "difficulty_overkill_145",
	})
	difficulty_sizer:add(difficulty_overkill_145, 0, 0, "EXPAND")

	local players_sizer = EWS:StaticBoxSizer(panel, "VERTICAL", "Players")

	h_sizer:add(players_sizer, 1, 0, "EXPAND")

	local player_1 = EWS:CheckBox(panel, "One Player", "")

	player_1:set_value(self._hed.player_1)
	player_1:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = player_1,
		value = "player_1",
	})
	players_sizer:add(player_1, 0, 0, "EXPAND")

	local player_2 = EWS:CheckBox(panel, "Two Players", "")

	player_2:set_value(self._hed.player_2)
	player_2:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = player_2,
		value = "player_2",
	})
	players_sizer:add(player_2, 0, 0, "EXPAND")

	local player_3 = EWS:CheckBox(panel, "Three Players", "")

	player_3:set_value(self._hed.player_3)
	player_3:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = player_3,
		value = "player_3",
	})
	players_sizer:add(player_3, 0, 0, "EXPAND")

	local player_4 = EWS:CheckBox(panel, "Four Players", "")

	player_4:set_value(self._hed.player_4)
	player_4:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = player_4,
		value = "player_4",
	})
	players_sizer:add(player_4, 0, 0, "EXPAND")

	local platform_sizer = EWS:StaticBoxSizer(panel, "VERTICAL", "Platform")

	h_sizer:add(platform_sizer, 1, 0, "EXPAND")

	local platform_win32 = EWS:CheckBox(panel, "Win32", "")

	platform_win32:set_value(self._hed.platform_win32)
	platform_win32:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = platform_win32,
		value = "platform_win32",
	})
	platform_sizer:add(platform_win32, 0, 0, "EXPAND")

	local platform_console = EWS:CheckBox(panel, "Console", "")

	platform_console:set_value(self._hed.platform_console)
	platform_console:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = platform_console,
		value = "platform_console",
	})
	platform_sizer:add(platform_console, 0, 0, "EXPAND")

	local mode_sizer = EWS:StaticBoxSizer(panel, "VERTICAL", "Mode")

	h_sizer:add(mode_sizer, 1, 0, "EXPAND")

	local mode_control = EWS:CheckBox(panel, "Control", "")

	mode_control:set_value(self._hed.mode_control == nil and true or self._hed.mode_control)
	mode_control:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = mode_control,
		value = "mode_control",
	})
	mode_sizer:add(mode_control, 0, 0, "EXPAND")

	local mode_assault = EWS:CheckBox(panel, "Assault", "")

	mode_assault:set_value(self._hed.mode_assault == nil and true or self._hed.mode_assault)
	mode_assault:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = mode_assault,
		value = "mode_assault",
	})
	mode_sizer:add(mode_assault, 0, 0, "EXPAND")

	local alarm_sizer = EWS:StaticBoxSizer(panel, "VERTICAL", "Alarm")

	h2_sizer:add(alarm_sizer, 1, 0, "EXPAND")

	local alarm_on = EWS:CheckBox(panel, "Alarmed", "")

	alarm_on:set_value(self._hed.alarm_on == nil and true or self._hed.alarm_on)
	alarm_on:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = alarm_on,
		value = "alarm_on",
	})
	alarm_sizer:add(alarm_on, 0, 0, "EXPAND")

	local alarm_off = EWS:CheckBox(panel, "Unalarmed", "")

	alarm_off:set_value(self._hed.alarm_off == nil and true or self._hed.alarm_off)
	alarm_off:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = alarm_off,
		value = "alarm_off",
	})
	alarm_sizer:add(alarm_off, 0, 0, "EXPAND")
end
