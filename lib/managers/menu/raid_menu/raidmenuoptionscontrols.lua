RaidMenuOptionsControls = RaidMenuOptionsControls or class(RaidGuiBase)

function RaidMenuOptionsControls:init(ws, fullscreen_ws, node, component_name)
	RaidMenuOptionsControls.super.init(self, ws, fullscreen_ws, node, component_name)
end

function RaidMenuOptionsControls:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_controls_subtitle")
end

function RaidMenuOptionsControls:_layout()
	RaidMenuOptionsControls.super._layout(self)
	self:_layout_controls()
	self:_load_controls_values()
	self._progress_bar_menu_camera_sensitivity_horizontal:set_selected(true)
	self:bind_controller_inputs()
end

function RaidMenuOptionsControls:close()
	managers.savefile:save_setting(true)
	RaidMenuOptionsControls.super.close(self)
end

function RaidMenuOptionsControls:_layout_controls()
	local start_x = 0
	local start_y = 320
	local default_width = 512
	local second_x = 704

	RaidMenuOptionsControls.SLIDER_PADDING = RaidGuiBase.PADDING + 24

	local previous_params

	previous_params = {
		name = "btn_keybinding",
		on_click_callback = callback(self, self, "on_click_options_controls_keybinds_button"),
		on_menu_move = {
			down = "slider_look_sensitivity_horizontal",
			up = "default_controls",
		},
		text = utf8.to_upper(managers.localization:text("menu_options_controls_keybinds_button")),
		x = start_x,
		y = start_y - 128,
	}
	self._btn_keybinding = self._root_panel:long_tertiary_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_controls_look_sensitivity_horizontal")),
		name = "slider_look_sensitivity_horizontal",
		on_menu_move = {
			down = "slider_look_sensitivity_vertical",
			up = previous_params.name,
		},
		on_value_change_callback = callback(self, self, "on_value_change_camera_sensitivity_horizontal"),
		value_format = "%02d%%",
		value_step = 1,
		x = start_x,
		y = start_y,
	}
	self._progress_bar_menu_camera_sensitivity_horizontal = self._root_panel:slider(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_controls_look_sensitivity_vertical")),
		name = "slider_look_sensitivity_vertical",
		on_menu_move = {
			down = "slider_aiming_sensitivity_horizontal",
			up = previous_params.name,
		},
		on_value_change_callback = callback(self, self, "on_value_change_camera_sensitivity_vertical"),
		value_format = "%02d%%",
		value_step = 1,
		x = start_x,
		y = previous_params.y + (self._progress_bar_menu_camera_sensitivity_horizontal._double_height and RaidMenuOptionsControls.SLIDER_PADDING or RaidGuiBase.PADDING),
	}
	self._progress_bar_menu_camera_sensitivity_vertical = self._root_panel:slider(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_controls_aiming_sensitivity_horizontal")),
		name = "slider_aiming_sensitivity_horizontal",
		on_menu_move = {
			down = "slider_aiming_sensitivity_vertical",
			up = previous_params.name,
		},
		on_value_change_callback = callback(self, self, "on_value_change_camera_zoom_sensitivity_horizontal"),
		value_format = "%02d%%",
		value_step = 1,
		x = start_x,
		y = previous_params.y + (self._progress_bar_menu_camera_sensitivity_vertical._double_height and RaidMenuOptionsControls.SLIDER_PADDING or RaidGuiBase.PADDING),
	}
	self._progress_bar_menu_camera_zoom_sensitivity_horizontal = self._root_panel:slider(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_controls_aiming_sensitivity_vertical")),
		name = "slider_aiming_sensitivity_vertical",
		on_menu_move = {
			down = "separate_aiming_settings",
			up = previous_params.name,
		},
		on_value_change_callback = callback(self, self, "on_value_change_camera_zoom_sensitivity_vertical"),
		value_format = "%02d%%",
		value_step = 1,
		x = start_x,
		y = previous_params.y + (self._progress_bar_menu_camera_zoom_sensitivity_horizontal._double_height and RaidMenuOptionsControls.SLIDER_PADDING or RaidGuiBase.PADDING),
	}
	self._progress_bar_menu_camera_zoom_sensitivity_vertical = self._root_panel:slider(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_separate_aiming_settings")),
		name = "separate_aiming_settings",
		on_click_callback = callback(self, self, "on_click_toggle_zoom_sensitivity"),
		on_menu_move = {
			down = "inverted_y_axis",
			up = previous_params.name,
		},
		w = default_width,
		x = start_x,
		y = previous_params.y + (self._progress_bar_menu_camera_zoom_sensitivity_vertical._double_height and RaidMenuOptionsControls.SLIDER_PADDING or RaidGuiBase.PADDING),
	}
	self._toggle_menu_toggle_zoom_sensitivity = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_inverted_y_axis")),
		name = "inverted_y_axis",
		on_click_callback = callback(self, self, "on_click_toggle_invert_camera_vertically"),
		on_menu_move = {
			down = "hold_to_aim",
			up = previous_params.name,
		},
		w = default_width,
		x = start_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_invert_camera_vertically = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_hold_to_aim")),
		name = "hold_to_aim",
		on_click_callback = callback(self, self, "on_click_toggle_hold_to_steelsight"),
		on_menu_move = {
			down = "hold_to_run",
			up = previous_params.name,
		},
		w = default_width,
		x = start_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_hold_to_steelsight = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_hold_to_run")),
		name = "hold_to_run",
		on_click_callback = callback(self, self, "on_click_toggle_hold_to_run"),
		on_menu_move = {
			down = "hold_to_crouch",
			up = previous_params.name,
		},
		w = default_width,
		x = start_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_hold_to_run = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_hold_to_crouch")),
		name = "hold_to_crouch",
		on_click_callback = callback(self, self, "on_click_toggle_hold_to_duck"),
		on_menu_move = {
			down = "hold_to_wheel",
			up = previous_params.name,
		},
		w = default_width,
		x = start_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_hold_to_duck = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = managers.localization:to_upper_text("menu_options_hold_to_wheel"),
		name = "hold_to_wheel",
		on_click_callback = callback(self, self, "on_click_toggle_hold_to_wheel"),
		on_menu_move = {
			down = "weapon_autofire",
			up = previous_params.name,
		},
		w = default_width,
		x = start_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_hold_to_wheel = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = managers.localization:to_upper_text("menu_options_weapon_autofire"),
		name = "weapon_autofire",
		on_click_callback = callback(self, self, "on_click_toggle_weapon_autofire"),
		on_menu_move = {
			down = "controller_sticky_aim",
			up = previous_params.name,
		},
		w = default_width,
		x = start_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_weapon_autofire = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_controller_sticky_aim")),
		name = "controller_sticky_aim",
		on_click_callback = callback(self, self, "on_click_toggle_controller_sticky_aim"),
		on_menu_move = {
			down = "controller_vibration",
			up = previous_params.name,
		},
		w = default_width,
		x = second_x,
		y = start_y,
	}
	self._toggle_menu_controller_sticky_aim = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_controller_vibration")),
		name = "controller_vibration",
		on_click_callback = callback(self, self, "on_click_toggle_controller_vibration"),
		on_menu_move = {
			down = "controller_aim_assist",
			up = previous_params.name,
		},
		w = default_width,
		x = second_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_controller_vibration = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_controller_aim_assist")),
		name = "controller_aim_assist",
		on_click_callback = callback(self, self, "on_click_toggle_controller_aim_assist"),
		on_menu_move = {
			down = "controller_southpaw",
			up = previous_params.name,
		},
		w = default_width,
		x = second_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_controller_aim_assist = self._root_panel:toggle_button(previous_params)
	previous_params = {
		description = utf8.to_upper(managers.localization:text("menu_options_controller_southpaw")),
		name = "controller_southpaw",
		on_click_callback = callback(self, self, "on_click_toggle_controller_southpaw"),
		on_menu_move = {
			down = "default_controls",
			up = previous_params.name,
		},
		w = default_width,
		x = second_x,
		y = previous_params.y + RaidGuiBase.PADDING,
	}
	self._toggle_menu_controller_southpaw = self._root_panel:toggle_button(previous_params)

	local default_controls_params = {
		layer = RaidGuiBase.FOREGROUND_LAYER,
		name = "default_controls",
		on_click_callback = callback(self, self, "on_click_default_controls"),
		on_menu_move = {
			down = "btn_keybinding",
			up = previous_params.name,
		},
		text = utf8.to_upper(managers.localization:text("menu_options_controls_default")),
		x = 1472,
		y = 832,
	}

	self._default_controls_button = self._root_panel:long_secondary_button(default_controls_params)

	self:_modify_controller_layout()

	if managers.raid_menu:is_pc_controller() then
		self._default_controls_button:show()
	else
		self._default_controls_button:hide()
	end
end

function RaidMenuOptionsControls:_modify_controller_layout()
	self._toggle_menu_controller_vibration:show()
	self._toggle_menu_controller_aim_assist:show()
	self._toggle_menu_controller_southpaw:show()
	self._toggle_menu_controller_sticky_aim:show()

	if not managers.raid_menu:is_pc_controller() or IS_CONSOLE then
		self._btn_keybinding:set_text(self:translate("menu_options_controls_controller_mapping", true))
	end
end

function RaidMenuOptionsControls:on_click_toggle_controller_vibration()
	local value = self._toggle_menu_controller_vibration:get_value()

	managers.menu:active_menu().callback_handler:toggle_rumble(value)
end

function RaidMenuOptionsControls:on_click_toggle_controller_aim_assist()
	local value = self._toggle_menu_controller_aim_assist:get_value()

	managers.menu:active_menu().callback_handler:toggle_aim_assist(value)
end

function RaidMenuOptionsControls:on_click_toggle_controller_sticky_aim(item)
	local value = self._toggle_menu_controller_sticky_aim:get_value()

	managers.menu:active_menu().callback_handler:toggle_sticky_aim(value)
end

function RaidMenuOptionsControls:on_click_toggle_controller_southpaw()
	local value = self._toggle_menu_controller_southpaw:get_value()

	managers.menu:active_menu().callback_handler:toggle_southpaw(value)
end

function RaidMenuOptionsControls:on_click_options_controls_keybinds_button()
	if managers.raid_menu:is_pc_controller() then
		managers.raid_menu:open_menu("raid_menu_options_controls_keybinds")
	else
		managers.raid_menu:open_menu("raid_menu_options_controller_mapping")
	end
end

function RaidMenuOptionsControls:on_value_change_camera_sensitivity_horizontal()
	local camera_sensitivity_percentage = math.clamp(self._progress_bar_menu_camera_sensitivity_horizontal:get_value(), 0, 100)
	local camera_sensitivity = camera_sensitivity_percentage / 100 * (tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) + tweak_data.player.camera.MIN_SENSITIVITY

	managers.menu:active_menu().callback_handler:set_camera_sensitivity_x_raid(camera_sensitivity)

	local camera_sensitivity_separate = self._toggle_menu_toggle_zoom_sensitivity:get_value()

	if not camera_sensitivity_separate then
		self._progress_bar_menu_camera_sensitivity_vertical:set_value(camera_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_sensitivity_y_raid(camera_sensitivity)
		self._progress_bar_menu_camera_zoom_sensitivity_horizontal:set_value(camera_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_zoom_sensitivity_x_raid(camera_sensitivity)
		self._progress_bar_menu_camera_zoom_sensitivity_vertical:set_value(camera_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_zoom_sensitivity_y_raid(camera_sensitivity)
	end
end

function RaidMenuOptionsControls:on_value_change_camera_sensitivity_vertical()
	local camera_sensitivity_percentage = math.clamp(self._progress_bar_menu_camera_sensitivity_vertical:get_value(), 0, 100)
	local camera_sensitivity_separate = self._toggle_menu_toggle_zoom_sensitivity:get_value()
	local camera_sensitivity = camera_sensitivity_percentage / 100 * (tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) + tweak_data.player.camera.MIN_SENSITIVITY

	managers.menu:active_menu().callback_handler:set_camera_sensitivity_y_raid(camera_sensitivity)

	if not camera_sensitivity_separate then
		self._progress_bar_menu_camera_sensitivity_horizontal:set_value(camera_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_sensitivity_x_raid(camera_sensitivity)
		self._progress_bar_menu_camera_zoom_sensitivity_horizontal:set_value(camera_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_zoom_sensitivity_x_raid(camera_sensitivity)
		self._progress_bar_menu_camera_zoom_sensitivity_vertical:set_value(camera_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_zoom_sensitivity_y_raid(camera_sensitivity)
	end
end

function RaidMenuOptionsControls:on_value_change_camera_zoom_sensitivity_horizontal()
	local camera_zoom_sensitivity_percentage = math.clamp(self._progress_bar_menu_camera_zoom_sensitivity_horizontal:get_value(), 0, 100)
	local camera_sensitivity_separate = self._toggle_menu_toggle_zoom_sensitivity:get_value()
	local camera_zoom_sensitivity = camera_zoom_sensitivity_percentage / 100 * (tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) + tweak_data.player.camera.MIN_SENSITIVITY

	managers.menu:active_menu().callback_handler:set_camera_zoom_sensitivity_x_raid(camera_zoom_sensitivity)

	if not camera_sensitivity_separate then
		self._progress_bar_menu_camera_sensitivity_horizontal:set_value(camera_zoom_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_sensitivity_x_raid(camera_zoom_sensitivity)
		self._progress_bar_menu_camera_sensitivity_vertical:set_value(camera_zoom_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_sensitivity_y_raid(camera_zoom_sensitivity)
		self._progress_bar_menu_camera_zoom_sensitivity_vertical:set_value(camera_zoom_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_zoom_sensitivity_y_raid(camera_zoom_sensitivity)
	end
end

function RaidMenuOptionsControls:on_value_change_camera_zoom_sensitivity_vertical()
	local camera_zoom_sensitivity_percentage = math.clamp(self._progress_bar_menu_camera_zoom_sensitivity_vertical:get_value(), 0, 100)
	local camera_sensitivity_separate = self._toggle_menu_toggle_zoom_sensitivity:get_value()
	local camera_zoom_sensitivity = camera_zoom_sensitivity_percentage / 100 * (tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) + tweak_data.player.camera.MIN_SENSITIVITY

	managers.menu:active_menu().callback_handler:set_camera_zoom_sensitivity_y_raid(camera_zoom_sensitivity)

	if not camera_sensitivity_separate then
		self._progress_bar_menu_camera_sensitivity_horizontal:set_value(camera_zoom_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_sensitivity_x_raid(camera_zoom_sensitivity)
		self._progress_bar_menu_camera_sensitivity_vertical:set_value(camera_zoom_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_sensitivity_y_raid(camera_zoom_sensitivity)
		self._progress_bar_menu_camera_zoom_sensitivity_horizontal:set_value(camera_zoom_sensitivity_percentage)
		managers.menu:active_menu().callback_handler:set_camera_zoom_sensitivity_x_raid(camera_zoom_sensitivity)
	end
end

function RaidMenuOptionsControls:on_click_toggle_zoom_sensitivity()
	local camera_sensitivity_separate = self._toggle_menu_toggle_zoom_sensitivity:get_value()

	managers.menu:active_menu().callback_handler:toggle_camera_sensitivity_separate_raid(camera_sensitivity_separate)
end

function RaidMenuOptionsControls:on_click_toggle_invert_camera_vertically()
	local invert_camera_y = self._toggle_menu_invert_camera_vertically:get_value()

	managers.menu:active_menu().callback_handler:invert_camera_vertically_raid(invert_camera_y)
end

function RaidMenuOptionsControls:on_click_toggle_hold_to_steelsight()
	local hold_to_steelsight = self._toggle_menu_hold_to_steelsight:get_value()

	managers.menu:active_menu().callback_handler:hold_to_steelsight_raid(hold_to_steelsight)
end

function RaidMenuOptionsControls:on_click_toggle_hold_to_run()
	local hold_to_run = self._toggle_menu_hold_to_run:get_value()

	managers.menu:active_menu().callback_handler:hold_to_run_raid(hold_to_run)
end

function RaidMenuOptionsControls:on_click_toggle_hold_to_duck()
	local hold_to_duck = self._toggle_menu_hold_to_duck:get_value()

	managers.menu:active_menu().callback_handler:hold_to_duck_raid(hold_to_duck)
end

function RaidMenuOptionsControls:on_click_toggle_hold_to_wheel()
	local hold_to_wheel = self._toggle_menu_hold_to_wheel:get_value()

	managers.menu:active_menu().callback_handler:hold_to_wheel_raid(hold_to_wheel)
end

function RaidMenuOptionsControls:on_click_toggle_weapon_autofire()
	local weapon_autofire = self._toggle_menu_weapon_autofire:get_value()

	managers.menu:active_menu().callback_handler:weapon_autofire_raid(weapon_autofire)
end

function RaidMenuOptionsControls:on_click_default_controls()
	managers.menu:show_option_dialog({
		callback = function()
			managers.user:reset_setting_map("controls")
			self:_load_controls_values()
		end,
		message = managers.localization:text("dialog_reset_controls_message"),
		title = managers.localization:text("dialog_reset_controls_title"),
	})
end

function RaidMenuOptionsControls:_load_controls_values()
	local camera_sensitivity_x = math.clamp(managers.user:get_setting("camera_sensitivity_x"), 0, 100)
	local camera_sensitivity_y = math.clamp(managers.user:get_setting("camera_sensitivity_y"), 0, 100)
	local camera_zoom_sensitivity_x = math.clamp(managers.user:get_setting("camera_zoom_sensitivity_x"), 0, 100)
	local camera_zoom_sensitivity_y = math.clamp(managers.user:get_setting("camera_zoom_sensitivity_y"), 0, 100)
	local camera_sensitivity_separate = managers.user:get_setting("camera_sensitivity_separate")
	local invert_camera_y = managers.user:get_setting("invert_camera_y")
	local hold_to_steelsight = managers.user:get_setting("hold_to_steelsight")
	local hold_to_run = managers.user:get_setting("hold_to_run")
	local hold_to_duck = managers.user:get_setting("hold_to_duck")
	local hold_to_wheel = managers.user:get_setting("hold_to_wheel")
	local weapon_autofire = managers.user:get_setting("weapon_autofire")
	local rumble = managers.user:get_setting("rumble")
	local aim_assist = managers.user:get_setting("aim_assist")
	local southpaw = managers.user:get_setting("southpaw")
	local sticky_aim = managers.user:get_setting("sticky_aim")
	local set_camera_sensitivity_x = (camera_sensitivity_x - tweak_data.player.camera.MIN_SENSITIVITY) / (tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 100
	local set_camera_sensitivity_y = (camera_sensitivity_y - tweak_data.player.camera.MIN_SENSITIVITY) / (tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 100

	self._progress_bar_menu_camera_sensitivity_horizontal:set_value(set_camera_sensitivity_x)
	self._progress_bar_menu_camera_sensitivity_vertical:set_value(set_camera_sensitivity_y)

	local set_camera_zoom_sensitivity_x = (camera_zoom_sensitivity_x - tweak_data.player.camera.MIN_SENSITIVITY) / (tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 100
	local set_camera_zoom_sensitivity_y = (camera_zoom_sensitivity_y - tweak_data.player.camera.MIN_SENSITIVITY) / (tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 100

	self._progress_bar_menu_camera_zoom_sensitivity_horizontal:set_value(set_camera_zoom_sensitivity_x)
	self._progress_bar_menu_camera_zoom_sensitivity_vertical:set_value(set_camera_zoom_sensitivity_y)
	self._toggle_menu_toggle_zoom_sensitivity:set_value_and_render(camera_sensitivity_separate)
	self._toggle_menu_invert_camera_vertically:set_value_and_render(invert_camera_y)
	self._toggle_menu_hold_to_steelsight:set_value_and_render(hold_to_steelsight)
	self._toggle_menu_hold_to_run:set_value_and_render(hold_to_run)
	self._toggle_menu_hold_to_duck:set_value_and_render(hold_to_duck)
	self._toggle_menu_hold_to_wheel:set_value_and_render(hold_to_wheel)
	self._toggle_menu_weapon_autofire:set_value_and_render(weapon_autofire)
	self._toggle_menu_controller_vibration:set_value_and_render(rumble)
	self._toggle_menu_controller_aim_assist:set_value_and_render(aim_assist)
	self._toggle_menu_controller_southpaw:set_value_and_render(southpaw)
	self._toggle_menu_controller_sticky_aim:set_value_and_render(sticky_aim)
end

function RaidMenuOptionsControls:bind_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "on_click_default_controls"),
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
				callback = callback(self, self, "_on_legend_pc_back", nil),
				key = "footer_back",
			},
		},
	}

	self:set_legend(legend)
end
