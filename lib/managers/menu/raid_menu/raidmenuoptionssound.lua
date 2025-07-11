RaidMenuOptionsSound = RaidMenuOptionsSound or class(RaidGuiBase)

function RaidMenuOptionsSound:init(ws, fullscreen_ws, node, component_name)
	RaidMenuOptionsSound.super.init(self, ws, fullscreen_ws, node, component_name)
end

function RaidMenuOptionsSound:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_sound_subtitle")
end

function RaidMenuOptionsSound:_layout()
	RaidMenuOptionsSound.super._layout(self)
	self:_layout_sound()
	self:_load_sound_values()
	self._progress_bar_menu_master_volume:set_selected(true)
	self:bind_controller_inputs()
end

function RaidMenuOptionsSound:close()
	managers.savefile:save_setting(true)
	RaidMenuOptionsSound.super.close(self)
end

function RaidMenuOptionsSound:_layout_sound()
	local start_x = 0
	local start_y = 320
	local default_width = 512
	local master_params = {
		description = utf8.to_upper(managers.localization:text("menu_master_volume")),
		name = "slider_master",
		on_menu_move = {
			down = "slider_music",
			up = "tinnitus",
		},
		on_value_change_callback = callback(self, self, "on_value_change_master_volume"),
		value = 100,
		value_format = "%02d%%",
		x = start_x,
		y = start_y,
	}

	self._progress_bar_menu_master_volume = self._root_panel:slider(master_params)

	local music_params = {
		description = utf8.to_upper(managers.localization:text("menu_music_volume")),
		name = "slider_music",
		on_menu_move = {
			down = "slider_sfx",
			up = "slider_master",
		},
		on_value_change_callback = callback(self, self, "on_value_change_music_volume"),
		value = 100,
		value_format = "%02d%%",
		x = start_x,
		y = master_params.y + RaidGuiBase.PADDING,
	}

	self._progress_bar_menu_music_volume = self._root_panel:slider(music_params)

	local sfx_params = {
		description = utf8.to_upper(managers.localization:text("menu_sfx_volume")),
		name = "slider_sfx",
		on_menu_move = {
			down = "slider_voice_over",
			up = "slider_music",
		},
		on_value_change_callback = callback(self, self, "on_value_change_sfx_volume"),
		value = 100,
		value_format = "%02d%%",
		x = start_x,
		y = music_params.y + RaidGuiBase.PADDING,
	}

	self._progress_bar_menu_sfx_volume = self._root_panel:slider(sfx_params)

	local voice_over_params = {
		description = utf8.to_upper(managers.localization:text("menu_voice_over_volume")),
		name = "slider_voice_over",
		on_menu_move = {
			down = "slider_voice_chat",
			up = "slider_sfx",
		},
		on_value_change_callback = callback(self, self, "on_value_change_voice_over_volume"),
		value = 100,
		value_format = "%02d%%",
		x = start_x,
		y = sfx_params.y + RaidGuiBase.PADDING,
	}

	self._progress_bar_menu_voice_over_volume = self._root_panel:slider(voice_over_params)

	local voice_chat_params = {
		description = utf8.to_upper(managers.localization:text("menu_voice_volume")),
		name = "slider_voice_chat",
		on_menu_move = {
			down = "use_voice_chat",
			up = "slider_voice_over",
		},
		on_value_change_callback = callback(self, self, "on_value_change_voice_volume"),
		value = 100,
		value_format = "%02d%%",
		x = start_x,
		y = voice_over_params.y + RaidGuiBase.PADDING,
	}

	self._progress_bar_menu_voice_volume = self._root_panel:slider(voice_chat_params)

	local use_voice_chat_params = {
		description = utf8.to_upper(managers.localization:text("menu_voicechat_toggle")),
		name = "use_voice_chat",
		on_click_callback = callback(self, self, "on_click_voice_chat"),
		on_menu_move = {
			down = "push_to_talk",
			up = "slider_voice_chat",
		},
		w = default_width,
		x = start_x,
		y = voice_chat_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_voicechat_toggle = self._root_panel:toggle_button(use_voice_chat_params)

	local push_to_talk_params = {
		description = utf8.to_upper(managers.localization:text("menu_push_to_talk_toggle")),
		name = "push_to_talk",
		on_click_callback = callback(self, self, "on_click_push_to_talk"),
		on_menu_move = {
			down = "tinnitus",
			up = "use_voice_chat",
		},
		w = default_width,
		x = start_x,
		y = use_voice_chat_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_push_to_talk_toggle = self._root_panel:toggle_button(push_to_talk_params)

	local tinnitus_params = {
		description = utf8.to_upper(managers.localization:text("menu_tinnitus_toggle")),
		name = "tinnitus",
		on_click_callback = callback(self, self, "on_click_tinnitus"),
		on_menu_move = {
			down = "slider_master",
			up = "push_to_talk",
		},
		w = default_width,
		x = start_x,
		y = push_to_talk_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_tinnitus_toggle = self._root_panel:toggle_button(tinnitus_params)
end

function RaidMenuOptionsSound:_load_sound_values()
	local master_volume = math.clamp(managers.user:get_setting("master_volume"), 0, 100)
	local music_volume = math.clamp(managers.user:get_setting("music_volume"), 0, 100)
	local sfx_volume = math.clamp(managers.user:get_setting("sfx_volume"), 0, 100)
	local voice_volume = math.clamp(managers.user:get_setting("voice_volume"), 0, 1)
	local voice_over_volume = math.clamp(managers.user:get_setting("voice_over_volume"), 0, 100)
	local push_to_talk = managers.user:get_setting("push_to_talk")
	local tinnitus_sound_enabled = managers.user:get_setting("tinnitus_sound_enabled")

	self._progress_bar_menu_master_volume:set_value(master_volume)
	self._progress_bar_menu_voice_over_volume:set_value(voice_over_volume)
	self._progress_bar_menu_music_volume:set_value(music_volume)
	self._progress_bar_menu_sfx_volume:set_value(sfx_volume)
	self._progress_bar_menu_voice_volume:set_value(voice_volume * 100)

	local voice_chat = managers.user:get_setting("voice_chat")

	self._toggle_menu_voicechat_toggle:set_value_and_render(voice_chat)
	self._toggle_menu_push_to_talk_toggle:set_value_and_render(push_to_talk)
	self._toggle_menu_tinnitus_toggle:set_value_and_render(tinnitus_sound_enabled)
end

function RaidMenuOptionsSound:on_value_change_master_volume()
	local master_volume = math.clamp(self._progress_bar_menu_master_volume:get_value(), 0, 100)

	managers.menu:active_menu().callback_handler:set_master_volume_raid(master_volume)
end

function RaidMenuOptionsSound:on_value_change_music_volume()
	local music_volume = math.clamp(self._progress_bar_menu_music_volume:get_value(), 0, 100)

	managers.menu:active_menu().callback_handler:set_music_volume_raid(music_volume)
end

function RaidMenuOptionsSound:on_value_change_sfx_volume()
	local sfx_volume = math.clamp(self._progress_bar_menu_sfx_volume:get_value(), 0, 100)

	managers.menu:active_menu().callback_handler:set_sfx_volume_raid(sfx_volume)
end

function RaidMenuOptionsSound:on_value_change_voice_over_volume()
	local voice_over_volume = math.clamp(self._progress_bar_menu_voice_over_volume:get_value(), 0, 100)

	managers.menu:active_menu().callback_handler:set_voice_over_volume_raid(voice_over_volume)
end

function RaidMenuOptionsSound:on_value_change_voice_volume()
	local voice_volume = math.clamp(self._progress_bar_menu_voice_volume:get_value(), 0, 100)

	managers.menu:active_menu().callback_handler:set_voice_volume_raid(voice_volume)
end

function RaidMenuOptionsSound:on_click_voice_chat()
	local voice_chat = self._toggle_menu_voicechat_toggle:get_value()

	managers.menu:active_menu().callback_handler:toggle_voicechat_raid(voice_chat)
	managers.network.voice_chat:update_settings()
end

function RaidMenuOptionsSound:on_click_push_to_talk()
	local push_to_talk = self._toggle_menu_push_to_talk_toggle:get_value()

	managers.menu:active_menu().callback_handler:toggle_push_to_talk_raid(push_to_talk)
	managers.network.voice_chat:update_settings()
end

function RaidMenuOptionsSound:on_click_tinnitus()
	local tinnitus = self._toggle_menu_tinnitus_toggle:get_value()

	managers.menu:active_menu().callback_handler:toggle_tinnitus_raid(tinnitus)
end

function RaidMenuOptionsSound:bind_controller_inputs()
	local legend = {
		controller = {
			"menu_legend_back",
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
