RaidMenuOptionsInterface = RaidMenuOptionsInterface or class(RaidGuiBase)

function RaidMenuOptionsInterface:init(ws, fullscreen_ws, node, component_name)
	RaidMenuOptionsInterface.super.init(self, ws, fullscreen_ws, node, component_name)
end

function RaidMenuOptionsInterface:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_interface_subtitle")
end

function RaidMenuOptionsInterface:_layout()
	RaidMenuOptionsInterface.super._layout(self)
	self:_layout_menu()
	self:_load_menu_values()
	self:bind_controller_inputs()
end

function RaidMenuOptionsInterface:close()
	managers.savefile:save_setting(true)
	RaidMenuOptionsInterface.super.close(self)
end

function RaidMenuOptionsInterface:_layout_menu()
	local start_x = 0
	local start_y = 270
	local default_width = 576
	local previous_panel

	previous_panel = {
		description = managers.localization:to_upper_text("menu_options_video_subtitle"),
		name = "subtitle",
		on_click_callback = callback(self, self, "on_click_subtitle"),
		on_menu_move = {
			down = "objective_reminder",
			up = "default_interface",
		},
		w = default_width,
		x = start_x,
		y = start_y,
	}
	self._toggle_menu_subtitle = self._root_panel:toggle_button(previous_panel)

	self._toggle_menu_subtitle:set_selected(true)

	previous_panel = {
		description = managers.localization:to_upper_text("menu_objective_reminder"),
		name = "objective_reminder",
		on_click_callback = callback(self, self, "on_click_objective_reminders"),
		on_menu_move = {
			down = "warcry_ready_indicator",
			up = previous_panel.name,
		},
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING,
	}
	self._toggle_objective_reminders = self._root_panel:toggle_button(previous_panel)
	previous_panel = {
		description = managers.localization:to_upper_text("menu_warcry_ready_indicator"),
		name = "warcry_ready_indicator",
		on_click_callback = callback(self, self, "on_click_warcry_ready_indicator"),
		on_menu_move = {
			down = "skip_cinematics",
			up = previous_panel.name,
		},
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING,
	}
	self._toggle_warcry_ready_indicator = self._root_panel:toggle_button(previous_panel)
	previous_panel = {
		description = managers.localization:to_upper_text("menu_skip_cinematics"),
		name = "skip_cinematics",
		on_click_callback = callback(self, self, "on_click_skip_cinematics"),
		on_menu_move = {
			down = "capitalize_names",
			up = previous_panel.name,
		},
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING,
	}
	self._toggle_skip_cinematics = self._root_panel:toggle_button(previous_panel)
	previous_panel = {
		description = managers.localization:to_upper_text("menu_capitalize_names"),
		name = "capitalize_names",
		on_click_callback = callback(self, self, "on_click_capitalize_names"),
		on_menu_move = {
			down = "hud_special_weapon_panels",
			up = previous_panel.name,
		},
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING * 2,
	}
	self._toggle_capitalize_names = self._root_panel:toggle_button(previous_panel)
	previous_panel = {
		description = managers.localization:to_upper_text("menu_options_video_hud_special_weapon_panels"),
		name = "hud_special_weapon_panels",
		on_click_callback = callback(self, self, "on_click_hud_special_weapon_panels"),
		on_menu_move = {
			down = "throwable_contours",
			up = previous_panel.name,
		},
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_hud_special_weapon_panels = self._root_panel:toggle_button(previous_panel)
	previous_panel = {
		description = managers.localization:to_upper_text("menu_throwable_contours"),
		name = "throwable_contours",
		on_click_callback = callback(self, self, "on_click_throwable_contours"),
		on_menu_move = {
			down = "hud_crosshairs",
			up = previous_panel.name,
		},
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING,
	}
	self._toggle_throwable_contours = self._root_panel:toggle_button(previous_panel)
	previous_panel = {
		description = managers.localization:to_upper_text("menu_options_video_hud_crosshairs"),
		name = "hud_crosshairs",
		on_click_callback = callback(self, self, "on_click_hud_crosshairs"),
		on_menu_move = {
			down = "hit_confirm_indicator",
			up = previous_panel.name,
		},
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_hud_crosshairs = self._root_panel:toggle_button(previous_panel)
	previous_panel = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_hit_confirm_indicator"),
		description = managers.localization:to_upper_text("menu_options_video_hit_confirm_indicator"),
		name = "hit_confirm_indicator",
		on_item_selected_callback = callback(self, self, "on_click_hit_indicator"),
		on_menu_move = {
			down = "motion_dot",
			up = previous_panel.name,
		},
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING,
	}
	self._stepper_menu_hit_indicator = self._root_panel:stepper(previous_panel)
	previous_panel = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_motion_dot"),
		description = managers.localization:to_upper_text("menu_options_video_motion_dot"),
		name = "motion_dot",
		on_item_selected_callback = callback(self, self, "on_click_motion_dot"),
		on_menu_move = {
			down = "motion_dot_size",
			up = previous_panel.name,
		},
		stepper_w = 280,
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING * 2,
	}
	self._stepper_menu_motion_dot = self._root_panel:stepper(previous_panel)
	previous_panel = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_motion_dot_size"),
		description = managers.localization:to_upper_text("menu_options_video_motion_dot_size"),
		name = "motion_dot_size",
		on_item_selected_callback = callback(self, self, "on_click_motion_dot_size"),
		on_menu_move = {
			down = "default_interface",
			up = previous_panel.name,
		},
		stepper_w = 280,
		w = default_width,
		x = start_x,
		y = previous_panel.y + RaidGuiBase.PADDING,
	}
	self._stepper_menu_motion_dot_size = self._root_panel:stepper(previous_panel)
	self._default_settings_button = self._root_panel:long_secondary_button({
		layer = RaidGuiBase.FOREGROUND_LAYER,
		name = "default_interface",
		on_click_callback = callback(self, self, "on_click_default_interface"),
		on_menu_move = {
			down = "subtitle",
			up = previous_panel.name,
		},
		text = managers.localization:to_upper_text("menu_options_controls_default"),
		x = 1472,
		y = 832,
	})

	if managers.raid_menu:is_pc_controller() then
		self._default_settings_button:show()
	else
		self._default_settings_button:hide()
	end
end

function RaidMenuOptionsInterface:data_source_stepper_menu_hit_confirm_indicator()
	local tb = {}

	for i = 1, #tweak_data.hit_indicator_modes do
		table.insert(tb, {
			info = "menu_options_video_hit_indicator_mode_" .. tostring(i),
			text_id = "menu_options_video_hit_indicator_mode_" .. tostring(i),
			value = i,
		})
	end

	return tb
end

function RaidMenuOptionsInterface:data_source_toggle_menu_hud_crosshairs()
	local tb = {}

	for i, v in {
		"on",
		"off",
	} do
		table.insert(tb, {
			info = "menu_options_video_hud_crosshairs_mode_" .. tostring(v),
			text_id = "menu_options_video_hud_crosshairs_mode_" .. tostring(v),
			value = i,
		})
	end

	return tb
end

function RaidMenuOptionsInterface:data_source_stepper_menu_motion_dot()
	local tb = {}

	for i = 1, #tweak_data.motion_dot_modes do
		table.insert(tb, {
			info = "menu_options_video_motion_dot_mode_" .. tostring(i),
			text_id = "menu_options_video_motion_dot_mode_" .. tostring(i),
			value = i,
		})
	end

	return tb
end

function RaidMenuOptionsInterface:data_source_stepper_menu_motion_dot_size()
	local tb = {}

	for i = 1, #tweak_data.motion_dot_modes do
		table.insert(tb, {
			info = "menu_options_video_motion_dot_size_" .. tostring(i),
			text_id = "menu_options_video_motion_dot_size_" .. tostring(i),
			value = i,
		})
	end

	return tb
end

function RaidMenuOptionsInterface:_load_menu_values()
	local objective_reminder = managers.user:get_setting("objective_reminder")

	self._toggle_objective_reminders:set_value_and_render(objective_reminder, true)

	local skip_cinematics = managers.user:get_setting("skip_cinematics")

	self._toggle_skip_cinematics:set_value_and_render(skip_cinematics, true)

	local capitalize_names = managers.user:get_setting("capitalize_names")

	self._toggle_capitalize_names:set_value_and_render(capitalize_names, true)

	local warcry_ready_indicator = managers.user:get_setting("warcry_ready_indicator")

	self._toggle_warcry_ready_indicator:set_value_and_render(warcry_ready_indicator, true)

	local subtitle = managers.user:get_setting("subtitles")

	self._toggle_menu_subtitle:set_value_and_render(subtitle, true)

	local hud_special_weapon_panels = managers.user:get_setting("hud_special_weapon_panels")

	self._toggle_menu_hud_special_weapon_panels:set_value_and_render(hud_special_weapon_panels, true)

	local throwable_contours = managers.user:get_setting("throwable_contours")

	self._toggle_throwable_contours:set_value_and_render(throwable_contours, true)

	local hud_crosshairs = managers.user:get_setting("hud_crosshairs")

	self._toggle_menu_hud_crosshairs:set_value_and_render(hud_crosshairs, true)

	local motion_dot = managers.user:get_setting("motion_dot")

	self._stepper_menu_motion_dot:set_value_and_render(motion_dot, true)

	local motion_dot_size = managers.user:get_setting("motion_dot_size")

	self._stepper_menu_motion_dot_size:set_value_and_render(motion_dot_size, true)
	self._stepper_menu_motion_dot_size:set_enabled(motion_dot > 1)

	local hit_indicator = managers.user:get_setting("hit_indicator")

	if type(hit_indicator) == "boolean" and HUDHitConfirm then
		hit_indicator = hit_indicator and HUDHitConfirm.MODE_ON or HUDHitConfirm.MODE_OFF
	end

	self._stepper_menu_hit_indicator:set_value_and_render(hit_indicator, true)
end

function RaidMenuOptionsInterface:on_click_subtitle()
	local subtitle = self._toggle_menu_subtitle:get_value()

	managers.menu:active_menu().callback_handler:toggle_subtitle_raid(subtitle)
end

function RaidMenuOptionsInterface:on_click_objective_reminders()
	local reminders = self._toggle_objective_reminders:get_value()

	managers.menu:active_menu().callback_handler:toggle_objective_reminder_raid(reminders)
end

function RaidMenuOptionsInterface:on_click_warcry_ready_indicator()
	local warcry_ready_indicator = self._toggle_warcry_ready_indicator:get_value()

	managers.menu:active_menu().callback_handler:toggle_warcry_ready_indicator_raid(warcry_ready_indicator)
end

function RaidMenuOptionsInterface:on_click_skip_cinematics()
	local skip_cinematics = self._toggle_skip_cinematics:get_value()

	managers.menu:active_menu().callback_handler:toggle_skip_cinematics_raid(skip_cinematics)
end

function RaidMenuOptionsInterface:on_click_capitalize_names()
	local capitalize_names = self._toggle_capitalize_names:get_value()

	managers.menu:active_menu().callback_handler:toggle_capitalize_names_raid(capitalize_names)
end

function RaidMenuOptionsInterface:on_click_hit_indicator()
	local hit_indicator = self._stepper_menu_hit_indicator:get_value()

	managers.menu:active_menu().callback_handler:set_hit_indicator_raid(hit_indicator)
end

function RaidMenuOptionsInterface:on_click_hud_crosshairs()
	local value = self._toggle_menu_hud_crosshairs:get_value()

	managers.menu:active_menu().callback_handler:set_hud_crosshairs_raid(value)
end

function RaidMenuOptionsInterface:on_click_hud_special_weapon_panels()
	local value = self._toggle_menu_hud_special_weapon_panels:get_value()

	managers.menu:active_menu().callback_handler:toggle_hud_special_weapon_panels(value)
end

function RaidMenuOptionsInterface:on_click_throwable_contours()
	local value = self._toggle_throwable_contours:get_value()

	managers.user:set_setting("throwable_contours", value)
end

function RaidMenuOptionsInterface:on_click_motion_dot()
	local value = self._stepper_menu_motion_dot:get_value()

	self._stepper_menu_motion_dot_size:set_enabled(value > 1)
	managers.menu:active_menu().callback_handler:set_motion_dot_raid(value)
end

function RaidMenuOptionsInterface:on_click_motion_dot_size()
	local value = self._stepper_menu_motion_dot_size:get_value()

	managers.menu:active_menu().callback_handler:set_motion_dot_size_raid(value)
end

function RaidMenuOptionsInterface:on_click_default_interface()
	local params = {
		callback = callback(self, self, "_callback_default_settings"),
		message = managers.localization:text("dialog_reset_interface_message"),
		title = managers.localization:text("dialog_reset_interface_title"),
	}

	managers.menu:show_option_dialog(params)
end

function RaidMenuOptionsInterface:_callback_default_settings()
	managers.user:reset_setting_map("interface")
	self:_load_menu_values()
end

function RaidMenuOptionsInterface:bind_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "on_click_default_interface"),
			key = Idstring("menu_controller_face_left"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_options_controls_default_controller",
		},
		keyboard = {
			{
				callback = callback(self, self, "_on_legend_pc_back"),
				key = "footer_back",
			},
		},
	}

	self:set_legend(legend)
end
