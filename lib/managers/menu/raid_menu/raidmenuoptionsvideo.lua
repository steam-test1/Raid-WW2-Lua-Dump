RaidMenuOptionsVideo = RaidMenuOptionsVideo or class(RaidGuiBase)

function RaidMenuOptionsVideo:init(ws, fullscreen_ws, node, component_name)
	RaidMenuOptionsVideo.super.init(self, ws, fullscreen_ws, node, component_name)
end

function RaidMenuOptionsVideo:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_video_subtitle")
end

function RaidMenuOptionsVideo:_layout()
	RaidMenuOptionsVideo.super._layout(self)
	self:_layout_video()
	self:_load_video_values()
	self._stepper_menu_resolution:set_selected(true)
	self:bind_controller_inputs()
end

function RaidMenuOptionsVideo:close()
	self:_save_video_values()

	Global.savefile_manager.setting_changed = true

	managers.savefile:save_setting(true)
	RaidMenuOptionsVideo.super.close(self)
end

function RaidMenuOptionsVideo:_layout_video()
	local start_x = 0
	local start_y = 320
	local default_width = 512
	local btn_advanced_options = {
		name = "btn_advanced_options",
		on_click_callback = callback(self, self, "on_click_options_video_advanced_button"),
		on_menu_move = {
			down = "stepper_menu_resolution",
		},
		text = utf8.to_upper(managers.localization:text("menu_options_video_advanced_button")),
		w = default_width,
		x = start_x,
		y = start_y - 128,
	}

	self._btn_advanced_options = self._root_panel:long_tertiary_button(btn_advanced_options)

	local stepper_menu_resolution = {
		name = "stepper_menu_resolution",
		data_source_callback = callback(self, self, "data_source_stepper_menu_resolution"),
		description = utf8.to_upper(managers.localization:text("menu_options_video_resolution")),
		on_item_selected_callback = callback(self, self, "on_item_selected_stepper_menu_resolution"),
		on_menu_move = {
			down = "stepper_menu_refresh_rate",
			up = "btn_advanced_options",
		},
		w = default_width,
		x = start_x,
		y = start_y,
	}

	self._stepper_menu_resolution = self._root_panel:stepper(stepper_menu_resolution)

	self._stepper_menu_resolution:set_value_and_render({
		is_equal = function(self, check_x_y)
			if check_x_y.x == self.x and check_x_y.y == self.y then
				return true
			else
				return false
			end
		end,
		x = RenderSettings.resolution.x,
		y = RenderSettings.resolution.y,
	}, false)

	local apply_resolution = {
		name = "apply_resolution",
		layer = RaidGuiBase.FOREGROUND_LAYER,
		on_click_callback = callback(self, self, "on_click_apply_resolution_refresh_rate"),
		text = utf8.to_upper(managers.localization:text("menu_button_apply_resolution_refresh_rate")),
		x = self._stepper_menu_resolution:w() + RaidGuiBase.PADDING,
		y = self._stepper_menu_resolution:y(),
	}

	self._root_panel:small_button(apply_resolution)

	local stepper_menu_refresh_rate = {
		name = "stepper_menu_refresh_rate",
		data_source_callback = callback(self, self, "data_source_stepper_menu_refresh_rate"),
		description = utf8.to_upper(managers.localization:text("menu_options_video_refresh_rate")),
		on_item_selected_callback = callback(self, self, "on_item_selected_refresh_rate"),
		on_menu_move = {
			down = "fullscreen",
			up = "stepper_menu_resolution",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_resolution.y + RaidGuiBase.PADDING,
	}

	self._stepper_menu_refresh_rate = self._root_panel:stepper(stepper_menu_refresh_rate)

	local fullscreen = {
		name = "fullscreen",
		description = utf8.to_upper(managers.localization:text("menu_options_video_fullscreen")),
		on_click_callback = callback(self, self, "on_click_fullscreen"),
		on_menu_move = {
			down = "subtitle",
			up = "stepper_menu_refresh_rate",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_refresh_rate.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_fullscreen = self._root_panel:toggle_button(fullscreen)

	local subtitle = {
		name = "subtitle",
		description = utf8.to_upper(managers.localization:text("menu_options_video_subtitle")),
		on_click_callback = callback(self, self, "on_click_subtitle"),
		on_menu_move = {
			down = "hit_confirm_indicator",
			up = "fullscreen",
		},
		w = default_width,
		x = start_x,
		y = fullscreen.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_subtitle = self._root_panel:toggle_button(subtitle)

	local hit_confirm_indicator = {
		name = "hit_confirm_indicator",
		description = utf8.to_upper(managers.localization:text("menu_options_video_hit_confirm_indicator")),
		on_click_callback = callback(self, self, "on_click_hit_indicator"),
		on_menu_move = {
			down = "use_camera_accel",
			up = "subtitle",
		},
		w = default_width,
		x = start_x,
		y = subtitle.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_hit_indicator = self._root_panel:toggle_button(hit_confirm_indicator)

	local use_camera_accel = {
		name = "use_camera_accel",
		description = utf8.to_upper(managers.localization:text("menu_options_video_use_camera_accel")),
		on_click_callback = callback(self, self, "on_click_headbob"),
		on_menu_move = {
			down = "effect_quality",
			up = "hit_confirm_indicator",
		},
		w = default_width,
		x = start_x,
		y = hit_confirm_indicator.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_headbob = self._root_panel:toggle_button(use_camera_accel)

	local effect_quality = {
		name = "effect_quality",
		value_format = "%02d%%",
		description = utf8.to_upper(managers.localization:text("menu_options_video_effect_quality")),
		on_menu_move = {
			down = "progress_bar_menu_brightness",
			up = "use_camera_accel",
		},
		on_value_change_callback = callback(self, self, "on_value_change_effect_quality"),
		x = start_x,
		y = use_camera_accel.y + RaidGuiBase.PADDING,
	}

	self._progress_bar_menu_effect_quality = self._root_panel:slider(effect_quality)

	local progress_bar_menu_brightness_params = {
		name = "progress_bar_menu_brightness",
		value = 0,
		value_format = "%02d%%",
		description = utf8.to_upper(managers.localization:text("menu_options_video_brightness")),
		on_menu_move = {
			up = "effect_quality",
		},
		on_value_change_callback = callback(self, self, "on_value_change_brightness"),
		x = start_x,
		y = effect_quality.y + RaidGuiBase.PADDING,
	}

	self._progress_bar_menu_brightness = self._root_panel:slider(progress_bar_menu_brightness_params)

	if managers.viewport:is_fullscreen() then
		self._progress_bar_menu_brightness:show()
	else
		self._progress_bar_menu_brightness:hide()
	end

	local default_video_params = {
		name = "default_video",
		x = 1472,
		y = 832,
		layer = RaidGuiBase.FOREGROUND_LAYER,
		on_click_callback = callback(self, self, "on_click_default_video"),
		text = utf8.to_upper(managers.localization:text("menu_options_controls_default")),
	}

	self._default_video_button = self._root_panel:long_secondary_button(default_video_params)

	if managers.raid_menu:is_pc_controller() then
		self._default_video_button:show()
	else
		self._default_video_button:hide()
	end
end

function gcd(a, b)
	if b == 0 then
		return a
	end

	return gcd(b, a % b)
end

function RaidMenuOptionsVideo:data_source_stepper_menu_resolution()
	local temp_resolutions = {}

	for _, res in ipairs(RenderSettings.modes) do
		table.insert(temp_resolutions, res)
	end

	table.sort(temp_resolutions)

	local resolutions = {}

	for _, resolution in ipairs(temp_resolutions) do
		self:_add_distinct_resolution(resolution, resolutions)
	end

	local result = {}

	for _, resolution in ipairs(resolutions) do
		table.insert(result, {
			info = resolution.x .. " x " .. resolution.y,
			text = resolution.x .. " x " .. resolution.y,
			value = resolution,
		})
	end

	return result
end

function RaidMenuOptionsVideo:on_item_selected_options_video_advanced_button()
	return
end

function RaidMenuOptionsVideo:on_item_selected_stepper_menu_resolution()
	self._stepper_menu_refresh_rate:refresh_data(true)
end

function RaidMenuOptionsVideo:_add_distinct_resolution(res, resolutions)
	if #resolutions == 0 then
		table.insert(resolutions, {
			x = res.x,
			y = res.y,
		})
	else
		local last_added_resolution = resolutions[#resolutions]

		if last_added_resolution.x ~= res.x or last_added_resolution.y ~= res.y then
			table.insert(resolutions, {
				x = res.x,
				y = res.y,
			})
		end
	end
end

function RaidMenuOptionsVideo:_get_refresh_rates_for_resolution(resolution)
	local temp_resolutions = {}

	for _, res in ipairs(RenderSettings.modes) do
		table.insert(temp_resolutions, res)
	end

	table.sort(temp_resolutions)

	local result = {}

	for _, res in ipairs(temp_resolutions) do
		if res.x == resolution.x and res.y == resolution.y then
			table.insert(result, {
				info = res.z .. " Hz",
				text = res.z .. " Hz",
				value = res.z,
			})
		end
	end

	return result
end

function RaidMenuOptionsVideo:data_source_stepper_menu_refresh_rate()
	local current_resolution = self._stepper_menu_resolution:get_value()

	return self:_get_refresh_rates_for_resolution(current_resolution)
end

function RaidMenuOptionsVideo:on_item_selected_refresh_rate()
	return
end

function RaidMenuOptionsVideo:on_click_apply_resolution_refresh_rate()
	local selected_resolution = self._stepper_menu_resolution:get_value()
	local selected_refresh_rate = self._stepper_menu_refresh_rate:get_value()
	local resolution = Vector3(selected_resolution.x, selected_resolution.y, selected_refresh_rate)

	managers.menu:active_menu().callback_handler:change_resolution_raid(resolution)
end

function RaidMenuOptionsVideo:on_value_change_effect_quality()
	local effect_quality = self._progress_bar_menu_effect_quality:get_value() / 100

	managers.menu:active_menu().callback_handler:set_effect_quality_raid(effect_quality)
end

function RaidMenuOptionsVideo:on_value_change_brightness()
	local brightness = self._progress_bar_menu_brightness:get_value() / 100 + 0.5

	managers.menu:active_menu().callback_handler:set_brightness_raid(brightness)
end

function RaidMenuOptionsVideo:on_click_fullscreen()
	local is_fullscreen = self._toggle_menu_fullscreen:get_value()

	managers.menu:active_menu().callback_handler:toggle_fullscreen_raid(is_fullscreen, callback(self, self, "fullscreen_toggled_callback"))
	self:on_value_change_brightness()

	if managers.viewport:is_fullscreen() then
		self._progress_bar_menu_brightness:show()
	else
		self._progress_bar_menu_brightness:hide()
	end
end

function RaidMenuOptionsVideo:on_click_default_video()
	local callback_function = callback(self, self, "callback_default_video")
	local params = {
		callback = function()
			managers.user:reset_video_setting_map()
			self:_load_video_values()
			callback_function()
		end,
		message = managers.localization:text("dialog_reset_video_message"),
		title = managers.localization:text("dialog_reset_video_title"),
	}

	managers.menu:show_option_dialog(params)
end

function RaidMenuOptionsVideo:_get_default_resolution()
	local default_resolution = Vector3(tweak_data.gui.base_resolution.x, tweak_data.gui.base_resolution.y, tweak_data.gui.base_resolution.z)
	local supported_resolutions = self:data_source_stepper_menu_resolution()
	local resolution = supported_resolutions[1]

	for _, res in ipairs(supported_resolutions) do
		if res.value.x <= default_resolution.x then
			local refresh_rates = self:_get_refresh_rates_for_resolution({
				x = res.value.x,
				y = res.value.y,
			})

			resolution = Vector3(res.value.x, res.value.y, refresh_rates[#refresh_rates].value)
		end
	end

	return resolution
end

function RaidMenuOptionsVideo:callback_default_video()
	managers.menu:active_menu().callback_handler:set_fullscreen_default_raid_no_dialog()

	local resolution = self:_get_default_resolution()

	managers.menu:active_menu().callback_handler:set_resolution_default_raid_no_dialog(resolution)
	managers.menu:active_menu().callback_handler:_refresh_brightness()
	self._stepper_menu_resolution:set_value_and_render({
		is_equal = function(self, check_x_y)
			if check_x_y.x == self.x and check_x_y.y == self.y then
				return true
			else
				return false
			end
		end,
		x = resolution.x,
		y = resolution.y,
	})
	self._stepper_menu_refresh_rate:set_value_and_render(resolution.z)
	self._toggle_menu_fullscreen:set_value_and_render(true)
	self._progress_bar_menu_brightness:show()
end

function RaidMenuOptionsVideo:fullscreen_toggled_callback()
	self:_reload_video_and_adv_video_options()
end

function RaidMenuOptionsVideo:_reload_video_and_adv_video_options()
	self:_load_video_values()
end

function RaidMenuOptionsVideo:_load_video_values()
	local resolution = RenderSettings.resolution
	local is_fullscreen = managers.viewport:is_fullscreen()
	local subtitle = managers.user:get_setting("subtitle")
	local hit_indicator = managers.user:get_setting("hit_indicator")
	local objective_reminder = managers.user:get_setting("objective_reminder")
	local use_headbob = managers.user:get_setting("use_headbob")
	local effect_quality = managers.user:get_setting("effect_quality")
	local brightness = managers.user:get_setting("brightness")

	self._stepper_menu_resolution:set_value_and_render({
		is_equal = function(self, check_x_y)
			if check_x_y.x == self.x and check_x_y.y == self.y then
				return true
			else
				return false
			end
		end,
		x = resolution.x,
		y = resolution.y,
	}, true)
	self._stepper_menu_refresh_rate:set_value_and_render(resolution.z, true)
	self._toggle_menu_fullscreen:set_value_and_render(is_fullscreen)
	self._toggle_menu_subtitle:set_value_and_render(subtitle)
	self._toggle_menu_hit_indicator:set_value_and_render(hit_indicator)
	self._toggle_menu_headbob:set_value_and_render(use_headbob)
	self._progress_bar_menu_effect_quality:set_value(effect_quality * 100)
	self._progress_bar_menu_brightness:set_value((brightness - 0.5) * 100)
end

function RaidMenuOptionsVideo:_save_video_values()
	self:on_click_subtitle()
	self:on_click_hit_indicator()
	self:on_click_headbob()
	self:on_value_change_brightness()
end

function RaidMenuOptionsVideo:on_click_subtitle()
	local subtitle = self._toggle_menu_subtitle:get_value()

	managers.menu:active_menu().callback_handler:toggle_subtitle_raid(subtitle)
end

function RaidMenuOptionsVideo:on_click_hit_indicator()
	local hit_indicator = self._toggle_menu_hit_indicator:get_value()

	managers.menu:active_menu().callback_handler:toggle_hit_indicator_raid(hit_indicator)
end

function RaidMenuOptionsVideo:on_click_headbob()
	local use_headbob = self._toggle_menu_headbob:get_value()

	managers.menu:active_menu().callback_handler:toggle_headbob_raid(use_headbob)
end

function RaidMenuOptionsVideo:on_click_options_video_advanced_button()
	managers.raid_menu:open_menu("raid_menu_options_video_advanced")
end

function RaidMenuOptionsVideo:bind_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "on_click_default_video"),
			key = Idstring("menu_controller_face_left"),
		},
		{
			callback = callback(self, self, "on_click_apply_resolution_refresh_rate"),
			key = Idstring("menu_controller_face_top"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_options_video_resolution",
			"menu_options_controls_default_controller",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	self:set_legend(legend)
end

function RaidMenuOptionsVideo:_apply_video_resolution()
	Application:trace("RaidMenuOptionsVideo:_apply_vidoe_resolution")
	self:on_click_apply_resolution_refresh_rate()

	return true, nil
end
