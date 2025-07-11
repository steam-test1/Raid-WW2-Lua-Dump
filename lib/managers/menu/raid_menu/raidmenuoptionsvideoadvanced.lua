RaidMenuOptionsVideoAdvanced = RaidMenuOptionsVideoAdvanced or class(RaidGuiBase)

function RaidMenuOptionsVideoAdvanced:init(ws, fullscreen_ws, node, component_name)
	Application:trace("RaidMenuOptionsVideoAdvanced:init: ", inspect(ws))
	RaidMenuOptionsVideoAdvanced.super.init(self, ws, fullscreen_ws, node, component_name)

	if game_state_machine:current_state()._name ~= "menu_main" then
		managers.raid_menu:hide_background()
	end
end

function RaidMenuOptionsVideoAdvanced:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_video_advanced_subtitle")
end

function RaidMenuOptionsVideoAdvanced:_layout()
	RaidMenuOptionsVideoAdvanced.super._layout(self)
	self:_layout_video_advanced()
	self:_load_advanced_video_values()
	self._toggle_menu_toggle_ssao:set_selected(true)
	self:bind_controller_inputs()
end

function RaidMenuOptionsVideoAdvanced:close()
	managers.savefile:save_setting(true)
	RaidMenuOptionsVideoAdvanced.super.close(self)
end

function RaidMenuOptionsVideoAdvanced:_load_advanced_video_values()
	local dof_setting = managers.user:get_setting("dof_setting") == "standard" and true or false
	local ssao_setting = managers.user:get_setting("ssao_setting") == "standard" and true or false
	local use_parallax = managers.user:get_setting("use_parallax")
	local motion_blur_setting = managers.user:get_setting("motion_blur_setting") == "standard" and true or false
	local vls_setting = managers.user:get_setting("vls_setting") == "standard" and true or false
	local vsync = RenderSettings.v_sync
	local buffer_count = RenderSettings.buffer_count
	local vsync_value

	vsync_value = not vsync and "OFF" or buffer_count == 1 and "DOUBLE_BUFFER" or "TRIPLE_BUFFER"

	local corpse_limit = managers.user:get_setting("corpse_limit")
	local corpse_limit_value = math.remap(corpse_limit, tweak_data.corpse_limit.min, tweak_data.corpse_limit.max, 0, 100)
	local detail_distance = managers.user:get_setting("detail_distance")
	local AA_setting = managers.user:get_setting("AA_setting")
	local texture_quality_default = RenderSettings.texture_quality_default
	local shadow_quality_default = RenderSettings.shadow_quality_default
	local max_anisotropy = RenderSettings.max_anisotropy
	local video_animation_lod = managers.user:get_setting("video_animation_lod")
	local fps_cap = managers.user:get_setting("fps_cap")
	local colorblind_setting = managers.user:get_setting("colorblind_setting")

	self._toggle_menu_toggle_dof:set_value_and_render(dof_setting, true)
	self._toggle_menu_toggle_ssao:set_value_and_render(ssao_setting, true)
	self._toggle_menu_toggle_parallax:set_value_and_render(use_parallax, true)
	self._toggle_menu_toggle_motion_blur:set_value_and_render(motion_blur_setting, true)
	self._toggle_menu_toggle_volumetric_light_scattering:set_value_and_render(vls_setting, true)
	self._progress_bar_menu_detail_distance:set_value(detail_distance * 100, true)
	self._progress_bar_menu_corpse_limit:set_value(corpse_limit_value, true)
	self._stepper_menu_antialias:set_value_and_render(AA_setting, true)
	self._stepper_menu_texture_quality:set_value_and_render(texture_quality_default, true)
	self._stepper_menu_shadow_quality:set_value_and_render(shadow_quality_default, true)
	self._stepper_menu_anisotropic:set_value_and_render(max_anisotropy, true)
	self._stepper_menu_anim_lod:set_value_and_render(video_animation_lod, true)
	self._stepper_menu_fps_limit:set_value_and_render(fps_cap, true)
	self._stepper_menu_colorblind_setting:set_value_and_render(colorblind_setting, true)
	self._stepper_menu_toggle_vsync:set_value_and_render(vsync_value, true)
end

function RaidMenuOptionsVideoAdvanced:_layout_video_advanced()
	local start_x = 0
	local start_y = 320
	local default_width = 512
	local toggle_menu_toggle_ssao_params = {
		description = utf8.to_upper(managers.localization:text("menu_toggle_ssao")),
		name = "toggle_menu_toggle_ssao",
		on_click_callback = callback(self, self, "on_click_toggle_ssao"),
		on_menu_move = {
			down = "toggle_menu_toggle_parallax",
		},
		w = default_width,
		x = start_x,
		y = start_y,
	}

	self._toggle_menu_toggle_ssao = self._root_panel:toggle_button(toggle_menu_toggle_ssao_params)

	local toggle_menu_toggle_parallax_params = {
		description = utf8.to_upper(managers.localization:text("menu_toggle_parallax")),
		name = "toggle_menu_toggle_parallax",
		on_click_callback = callback(self, self, "on_click_toggle_parallax"),
		on_menu_move = {
			down = "toggle_menu_toggle_motion_blur",
			up = "toggle_menu_toggle_ssao",
		},
		w = default_width,
		x = start_x,
		y = toggle_menu_toggle_ssao_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_toggle_parallax = self._root_panel:toggle_button(toggle_menu_toggle_parallax_params)

	local toggle_menu_toggle_motion_blur_params = {
		description = utf8.to_upper(managers.localization:text("menu_toggle_motion_blur")),
		name = "toggle_menu_toggle_motion_blur",
		on_click_callback = callback(self, self, "on_click_toggle_motion_blur"),
		on_menu_move = {
			down = "toggle_menu_toggle_dof",
			up = "toggle_menu_toggle_parallax",
		},
		w = default_width,
		x = start_x,
		y = toggle_menu_toggle_parallax_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_toggle_motion_blur = self._root_panel:toggle_button(toggle_menu_toggle_motion_blur_params)

	local toggle_menu_toggle_dof_params = {
		description = utf8.to_upper(managers.localization:text("menu_toggle_dof")),
		name = "toggle_menu_toggle_dof",
		on_click_callback = callback(self, self, "on_click_toggle_dof"),
		on_menu_move = {
			down = "toggle_menu_toggle_volumetric_light_scattering",
			up = "toggle_menu_toggle_motion_blur",
		},
		w = default_width,
		x = start_x,
		y = toggle_menu_toggle_motion_blur_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_toggle_dof = self._root_panel:toggle_button(toggle_menu_toggle_dof_params)

	local toggle_menu_toggle_volumetric_light_scattering_params = {
		description = utf8.to_upper(managers.localization:text("menu_toggle_volumetric_light_scattering")),
		name = "toggle_menu_toggle_volumetric_light_scattering",
		on_click_callback = callback(self, self, "on_click_toggle_volumetric_light_scattering"),
		on_menu_move = {
			down = "progress_bar_menu_detail_distance",
			up = "toggle_menu_toggle_dof",
		},
		w = default_width,
		x = start_x,
		y = toggle_menu_toggle_dof_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_toggle_volumetric_light_scattering = self._root_panel:toggle_button(toggle_menu_toggle_volumetric_light_scattering_params)

	local progress_bar_menu_detail_distance_params = {
		description = utf8.to_upper(managers.localization:text("menu_detail_distance")),
		name = "progress_bar_menu_detail_distance",
		on_menu_move = {
			down = "progress_bar_menu_corpse_limit",
			up = "toggle_menu_toggle_volumetric_light_scattering",
		},
		on_value_change_callback = callback(self, self, "on_value_change_detail_distance"),
		value_format = "%02d%%",
		x = start_x,
		y = toggle_menu_toggle_volumetric_light_scattering_params.y + RaidGuiBase.PADDING,
	}

	self._progress_bar_menu_detail_distance = self._root_panel:slider(progress_bar_menu_detail_distance_params)

	local progress_bar_menu_corpse_limit_params = {
		description = managers.localization:to_upper_text("menu_corpse_limit"),
		max_display_value = tweak_data.corpse_limit.max,
		min_display_value = tweak_data.corpse_limit.min,
		name = "progress_bar_menu_corpse_limit",
		on_menu_move = {
			down = "stepper_menu_antialias",
			up = "progress_bar_menu_detail_distance",
		},
		on_value_change_callback = callback(self, self, "on_value_change_corpse_limit"),
		x = start_x,
		y = progress_bar_menu_detail_distance_params.y + RaidGuiBase.PADDING,
	}

	self._progress_bar_menu_corpse_limit = self._root_panel:slider(progress_bar_menu_corpse_limit_params)
	start_x = 704

	local stepper_menu_antialias_params = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_antialias"),
		description = utf8.to_upper(managers.localization:text("menu_options_video_advanced_antialias")),
		name = "stepper_menu_antialias",
		on_item_selected_callback = callback(self, self, "on_item_selected_antialias"),
		on_menu_move = {
			down = "stepper_menu_texture_quality",
			up = "progress_bar_menu_corpse_limit",
		},
		w = default_width,
		x = start_x,
		y = start_y,
	}

	self._stepper_menu_antialias = self._root_panel:stepper(stepper_menu_antialias_params)

	local stepper_menu_texture_quality_params = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_texture_quality"),
		description = utf8.to_upper(managers.localization:text("menu_texture_quality")),
		name = "stepper_menu_texture_quality",
		on_item_selected_callback = callback(self, self, "on_item_selected_texture_quality"),
		on_menu_move = {
			down = "stepper_menu_shadow_quality",
			up = "stepper_menu_antialias",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_antialias_params.y + RaidGuiBase.PADDING,
	}

	self._stepper_menu_texture_quality = self._root_panel:stepper(stepper_menu_texture_quality_params)

	local stepper_menu_shadow_quality_params = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_shadow_quality"),
		description = utf8.to_upper(managers.localization:text("menu_shadow_quality")),
		name = "stepper_menu_shadow_quality",
		on_item_selected_callback = callback(self, self, "on_item_selected_shadow_quality"),
		on_menu_move = {
			down = "stepper_menu_anisotropic",
			up = "stepper_menu_texture_quality",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_texture_quality_params.y + RaidGuiBase.PADDING,
	}

	self._stepper_menu_shadow_quality = self._root_panel:stepper(stepper_menu_shadow_quality_params)

	local stepper_menu_anisotropic_params = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_anisotropic"),
		description = utf8.to_upper(managers.localization:text("menu_options_video_advanced_anisotropic")),
		name = "stepper_menu_anisotropic",
		on_item_selected_callback = callback(self, self, "on_item_selected_anisotropic"),
		on_menu_move = {
			down = "stepper_menu_anim_lod",
			up = "stepper_menu_shadow_quality",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_shadow_quality_params.y + RaidGuiBase.PADDING,
	}

	self._stepper_menu_anisotropic = self._root_panel:stepper(stepper_menu_anisotropic_params)

	local stepper_menu_anim_lod_params = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_anim_lod"),
		description = utf8.to_upper(managers.localization:text("menu_anim_lod")),
		name = "stepper_menu_anim_lod",
		on_item_selected_callback = callback(self, self, "on_item_selected_anim_lod"),
		on_menu_move = {
			down = "stepper_menu_fps_limit",
			up = "stepper_menu_anisotropic",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_anisotropic_params.y + RaidGuiBase.PADDING,
	}

	self._stepper_menu_anim_lod = self._root_panel:stepper(stepper_menu_anim_lod_params)

	local stepper_menu_fps_limit_params = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_fps_limit"),
		description = utf8.to_upper(managers.localization:text("menu_fps_limit")),
		name = "stepper_menu_fps_limit",
		on_item_selected_callback = callback(self, self, "on_item_selected_fps_limit"),
		on_menu_move = {
			down = "stepper_menu_colorblind_setting",
			up = "stepper_menu_anim_lod",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_anim_lod_params.y + RaidGuiBase.PADDING,
	}

	self._stepper_menu_fps_limit = self._root_panel:stepper(stepper_menu_fps_limit_params)

	local stepper_menu_colorblind_setting_params = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_colorblind_setting"),
		description = utf8.to_upper(managers.localization:text("menu_colorblind_setting")),
		name = "stepper_menu_colorblind_setting",
		on_item_selected_callback = callback(self, self, "on_item_selected_colorblind_setting"),
		on_menu_move = {
			down = "label_menu_vsync",
			up = "stepper_menu_fps_limit",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_fps_limit_params.y + RaidGuiBase.PADDING,
	}

	self._stepper_menu_colorblind_setting = self._root_panel:stepper(stepper_menu_colorblind_setting_params)

	local _stepper_menu_toggle_vsync_params = {
		data_source_callback = callback(self, self, "data_source_stepper_menu_vsync"),
		description = utf8.to_upper(managers.localization:text("menu_options_video_advanced_vsync")),
		name = "label_menu_vsync",
		on_item_selected_callback = callback(self, self, "on_item_selected_vsync"),
		on_menu_move = {
			up = "stepper_menu_colorblind_setting",
		},
		w = default_width,
		x = start_x,
		y = stepper_menu_colorblind_setting_params.y + RaidGuiBase.PADDING,
	}

	self._stepper_menu_toggle_vsync = self._root_panel:stepper(_stepper_menu_toggle_vsync_params)

	local default_advanced_video_params = {
		layer = RaidGuiBase.FOREGROUND_LAYER,
		name = "default_advanced_video",
		on_click_callback = callback(self, self, "on_click_default_advanced_video"),
		text = utf8.to_upper(managers.localization:text("menu_options_controls_default")),
		x = 1472,
		y = 832,
	}

	self._default_advanced_video_button = self._root_panel:long_secondary_button(default_advanced_video_params)

	if managers.raid_menu:is_pc_controller() then
		self._default_advanced_video_button:show()
	else
		self._default_advanced_video_button:hide()
	end
end

function RaidMenuOptionsVideoAdvanced:on_click_toggle_ssao()
	local ssao_setting = self._toggle_menu_toggle_ssao:get_value()

	managers.menu:active_menu().callback_handler:toggle_ssao_setting_raid(ssao_setting)
end

function RaidMenuOptionsVideoAdvanced:on_click_toggle_parallax()
	local use_parallax = self._toggle_menu_toggle_parallax:get_value()

	managers.menu:active_menu().callback_handler:set_use_parallax_raid(use_parallax)
end

function RaidMenuOptionsVideoAdvanced:on_click_toggle_motion_blur()
	local motion_blur_setting = self._toggle_menu_toggle_motion_blur:get_value()

	managers.menu:active_menu().callback_handler:toggle_motion_blur_setting_raid(motion_blur_setting)
end

function RaidMenuOptionsVideoAdvanced:on_click_toggle_dof()
	local dof_setting = self._toggle_menu_toggle_dof:get_value()

	managers.menu:active_menu().callback_handler:toggle_dof_setting_raid(dof_setting)
end

function RaidMenuOptionsVideoAdvanced:on_click_toggle_volumetric_light_scattering()
	local vls_setting = self._toggle_menu_toggle_volumetric_light_scattering:get_value()

	managers.menu:active_menu().callback_handler:toggle_volumetric_light_scattering_setting_raid(vls_setting)
end

function RaidMenuOptionsVideoAdvanced:on_value_change_detail_distance()
	local detail_distance = self._progress_bar_menu_detail_distance:get_value() / 100

	managers.menu:active_menu().callback_handler:set_detail_distance_raid(detail_distance)
end

function RaidMenuOptionsVideoAdvanced:on_value_change_corpse_limit()
	local corpse_limit = self._progress_bar_menu_corpse_limit:get_value()
	local corpse_limit_value = math.remap(corpse_limit, 0, 100, tweak_data.corpse_limit.min, tweak_data.corpse_limit.max)

	managers.menu:active_menu().callback_handler:set_corpse_limit_raid(corpse_limit_value)
end

function RaidMenuOptionsVideoAdvanced:on_item_selected_vsync()
	local vsync_value = self._stepper_menu_toggle_vsync:get_value()

	if vsync_value == "OFF" then
		managers.menu:active_menu().callback_handler:toggle_vsync_raid(false, 1)
	elseif vsync_value == "DOUBLE_BUFFER" then
		managers.menu:active_menu().callback_handler:toggle_vsync_raid(true, 1)
	else
		managers.menu:active_menu().callback_handler:toggle_vsync_raid(true, 2)
	end
end

function RaidMenuOptionsVideoAdvanced:data_source_stepper_menu_vsync()
	local result = {}

	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_vsync_quality_off")),
		text = utf8.to_upper(managers.localization:text("menu_vsync_quality_off")),
		value = "OFF",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_vsync_quality_db")),
		text = utf8.to_upper(managers.localization:text("menu_vsync_quality_db")),
		value = "DOUBLE_BUFFER",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_vsync_quality_tb")),
		selected = true,
		text = utf8.to_upper(managers.localization:text("menu_vsync_quality_tb")),
		value = "TRIPLE_BUFFER",
	})

	return result
end

function RaidMenuOptionsVideoAdvanced:on_item_selected_antialias()
	local AA_setting = self._stepper_menu_antialias:get_value()

	managers.menu:active_menu().callback_handler:choice_choose_anti_alias_raid(AA_setting)
end

function RaidMenuOptionsVideoAdvanced:data_source_stepper_menu_antialias()
	local result = {}

	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_AA_quality_off")),
		text = utf8.to_upper(managers.localization:text("menu_AA_quality_off")),
		value = "OFF",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_AA_quality_fxaa")),
		text = utf8.to_upper(managers.localization:text("menu_AA_quality_fxaa")),
		value = "FXAA",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_AA_quality_smaa")),
		selected = true,
		text = utf8.to_upper(managers.localization:text("menu_AA_quality_smaa")),
		value = "SMAA",
	})

	return result
end

function RaidMenuOptionsVideoAdvanced:on_item_selected_texture_quality()
	local texture_quality_default = self._stepper_menu_texture_quality:get_value()

	managers.menu:active_menu().callback_handler:choice_choose_texture_quality_raid(texture_quality_default)
end

function RaidMenuOptionsVideoAdvanced:data_source_stepper_menu_texture_quality()
	local result = {}

	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_very_low")),
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_very_low")),
		value = "very low",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_low")),
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_low")),
		value = "low",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_medium")),
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_medium")),
		value = "medium",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_high")),
		selected = true,
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_high")),
		value = "high",
	})

	return result
end

function RaidMenuOptionsVideoAdvanced:on_item_selected_shadow_quality()
	local shadow_quality_default = self._stepper_menu_shadow_quality:get_value()

	managers.menu:active_menu().callback_handler:choice_choose_shadow_quality_raid(shadow_quality_default)
end

function RaidMenuOptionsVideoAdvanced:data_source_stepper_menu_shadow_quality()
	local result = {}

	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_very_low")),
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_very_low")),
		value = "very low",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_low")),
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_low")),
		value = "low",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_medium")),
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_medium")),
		value = "medium",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_high")),
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_high")),
		value = "high",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_texture_quality_very_high")),
		selected = true,
		text = utf8.to_upper(managers.localization:text("menu_texture_quality_very_high")),
		value = "very high",
	})

	return result
end

function RaidMenuOptionsVideoAdvanced:on_item_selected_anisotropic()
	local max_anisotropy = self._stepper_menu_anisotropic:get_value()

	managers.menu:active_menu().callback_handler:choice_choose_anisotropic_raid(max_anisotropy)
end

function RaidMenuOptionsVideoAdvanced:data_source_stepper_menu_anisotropic()
	local result = {}

	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_anisotropic_1")),
		text = utf8.to_upper(managers.localization:text("menu_anisotropic_1")),
		value = 1,
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_anisotropic_2")),
		text = utf8.to_upper(managers.localization:text("menu_anisotropic_2")),
		value = 2,
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_anisotropic_4")),
		text = utf8.to_upper(managers.localization:text("menu_anisotropic_4")),
		value = 4,
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_anisotropic_8")),
		text = utf8.to_upper(managers.localization:text("menu_anisotropic_8")),
		value = 8,
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_anisotropic_16")),
		selected = true,
		text = utf8.to_upper(managers.localization:text("menu_anisotropic_16")),
		value = 16,
	})

	return result
end

function RaidMenuOptionsVideoAdvanced:on_item_selected_anim_lod()
	local video_animation_lod = self._stepper_menu_anim_lod:get_value()

	managers.menu:active_menu().callback_handler:choice_choose_anim_lod_raid(video_animation_lod)
end

function RaidMenuOptionsVideoAdvanced:data_source_stepper_menu_anim_lod()
	local result = {}

	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_anim_lod_1")),
		text = utf8.to_upper(managers.localization:text("menu_anim_lod_1")),
		value = 1,
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_anim_lod_2")),
		text = utf8.to_upper(managers.localization:text("menu_anim_lod_2")),
		value = 2,
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_anim_lod_3")),
		selected = true,
		text = utf8.to_upper(managers.localization:text("menu_anim_lod_3")),
		value = 3,
	})

	return result
end

function RaidMenuOptionsVideoAdvanced:on_item_selected_fps_limit()
	local fps_cap = self._stepper_menu_fps_limit:get_value()

	managers.menu:active_menu().callback_handler:choice_fps_cap_raid(fps_cap)
end

function RaidMenuOptionsVideoAdvanced:data_source_stepper_menu_fps_limit()
	local result = {}

	table.insert(result, {
		info = "24",
		text = "24",
		value = 24,
	})
	table.insert(result, {
		info = "30",
		text = "30",
		value = 30,
	})
	table.insert(result, {
		info = "45",
		text = "45",
		value = 45,
	})
	table.insert(result, {
		info = "60",
		text = "60",
		value = 60,
	})
	table.insert(result, {
		info = "75",
		text = "75",
		value = 75,
	})
	table.insert(result, {
		info = "90",
		text = "90",
		value = 90,
	})
	table.insert(result, {
		info = "105",
		text = "105",
		value = 105,
	})
	table.insert(result, {
		info = "120",
		text = "120",
		value = 120,
	})
	table.insert(result, {
		info = "135",
		selected = true,
		text = "135",
		value = 135,
	})
	table.insert(result, {
		info = "144",
		text = "144",
		value = 144,
	})
	table.insert(result, {
		info = "165",
		text = "165",
		value = 165,
	})
	table.insert(result, {
		info = "240",
		text = "240",
		value = 240,
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_fps_unlimited")),
		text = utf8.to_upper(managers.localization:text("menu_fps_unlimited")),
		value = 600,
	})

	return result
end

function RaidMenuOptionsVideoAdvanced:data_source_stepper_menu_colorblind_setting()
	local result = {}

	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_colorblind_setting_off")),
		text = utf8.to_upper(managers.localization:text("menu_colorblind_setting_off")),
		value = "off",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_colorblind_setting_protanope")),
		text = utf8.to_upper(managers.localization:text("menu_colorblind_setting_protanope")),
		value = "protanope",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_colorblind_setting_deuteranope")),
		text = utf8.to_upper(managers.localization:text("menu_colorblind_setting_deuteranope")),
		value = "deuteranope",
	})
	table.insert(result, {
		info = utf8.to_upper(managers.localization:text("menu_colorblind_setting_tritanope")),
		text = utf8.to_upper(managers.localization:text("menu_colorblind_setting_tritanope")),
		value = "tritanope",
	})

	return result
end

function RaidMenuOptionsVideoAdvanced:on_click_default_advanced_video()
	managers.menu:show_option_dialog({
		callback = function()
			managers.user:reset_setting_map("video_advanced")

			RenderSettings.texture_quality_default = "high"
			RenderSettings.shadow_quality_default = "high"
			RenderSettings.max_anisotropy = 16
			RenderSettings.v_sync = false

			self:_load_advanced_video_values()

			if IS_PC then
				managers.menu:active_menu().callback_handler:apply_and_save_render_settings()
				managers.menu:active_menu().callback_handler:_refresh_brightness()
			end
		end,
		message = managers.localization:text("dialog_reset_advanced_video_message"),
		title = managers.localization:text("dialog_reset_advanced_video_title"),
	})
end

function RaidMenuOptionsVideoAdvanced:on_item_selected_colorblind_setting()
	local colorblind_setting = self._stepper_menu_colorblind_setting:get_value()

	managers.menu:active_menu().callback_handler:choice_choose_cb_mode_raid(colorblind_setting)
end

function RaidMenuOptionsVideoAdvanced:bind_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "on_click_default_advanced_video"),
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
