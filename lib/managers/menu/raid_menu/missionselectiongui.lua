MissionSelectionGui = MissionSelectionGui or class(RaidGuiBase)
MissionSelectionGui.BACKGROUND_PAPER_COLOR = Color("cccccc")
MissionSelectionGui.BACKGROUND_PAPER_ALPHA = 0.7
MissionSelectionGui.BACKGROUND_PAPER_ROTATION = 5
MissionSelectionGui.BACKGROUND_PAPER_SCALE = 0.9
MissionSelectionGui.FOREGROUND_PAPER_COLOR = Color("ffffff")
MissionSelectionGui.SECONDARY_PAPER_PADDING_LEFT = -4
MissionSelectionGui.PAPER_STAMP_ICON = "icon_paper_stamp"
MissionSelectionGui.PAPER_STAMP_ICON_CONSUMABLE = "icon_paper_stamp_consumable"

function MissionSelectionGui:init(ws, fullscreen_ws, node, component_name)
	self._settings_selected = {}
	self._selected_column = "left"
	self._selected_tab = "left"

	MissionSelectionGui.super.init(self, ws, fullscreen_ws, node, component_name)
end

function MissionSelectionGui:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_missions_screen_name")

	self._settings_selected.difficulty = Global.player_manager.game_settings_difficulty
	self._settings_selected.permission = Global.game_settings.permission
	self._settings_selected.drop_in_allowed = Global.game_settings.drop_in_allowed
	self._settings_selected.team_ai = Global.game_settings.team_ai
	self._settings_selected.auto_kick = Global.game_settings.auto_kick
end

function MissionSelectionGui:close()
	self._primary_paper:stop()
	self._secondary_paper:stop()
	self._soe_emblem:stop()
	self:_stop_mission_briefing_audio()
	MissionSelectionGui.super.close(self)
end

function MissionSelectionGui:_layout()
	MissionSelectionGui.super._layout(self)
	self:_layout_lists()
	self:_layout_raid_wrapper_panel()

	if Global.game_settings.single_player then
		self:_layout_settings_offline()
	else
		self:_layout_settings()
	end

	self:_layout_primary_paper()
	self:_layout_info_buttons()
	self:_layout_secondary_paper()
	self:_layout_start_button()
	self:_layout_delete_button()
	self._intel_image_grid:select(1)
	self:_select_raids_tab()
	self:bind_controller_inputs()

	if managers.controller:is_xbox_controller_present() and not managers.menu:is_pc_controller() then
		self._raid_start_button:hide()
		self._save_delete_button:hide()
	end
end

function MissionSelectionGui:_layout_lists()
	local list_panel_params = {
		h = 640,
		layer = 1,
		name = "list_panel",
		w = 300,
		x = 0,
		y = 96,
	}

	self._list_panel = self._root_panel:panel(list_panel_params)

	local list_tabs_params = {
		name = "list_tabs",
		tab_align = "center",
		x = 0,
		y = 0,
		on_click_callback = callback(self, self, "_on_mission_type_changed"),
		tabs_params = {
			{
				callback_param = "raids",
				name = "tab_raid",
				text = self:translate("menu_mission_selected_mission_type_raid", true),
			},
		},
	}

	self._list_tabs = self._list_panel:tabs(list_tabs_params)

	local raid_list_scrollable_area_params = {
		name = "raid_list_scrollable_area",
		scroll_step = 35,
		x = 0,
		h = self._list_panel:h() - self._list_tabs:h(),
		w = self._list_panel:w(),
		y = self._list_tabs:h(),
	}

	self._raid_list_panel = self._list_panel:scrollable_area(raid_list_scrollable_area_params)

	local raid_list_params = {
		name = "raid_list",
		selection_enabled = true,
		x = 0,
		y = 0,
		data_source_callback = callback(self, self, "_raid_list_data_source"),
		item_class = RaidGUIControlListItemIcon,
		on_item_clicked_callback = callback(self, self, "_on_raid_clicked"),
		on_item_double_clicked_callback = callback(self, self, "_on_mission_list_double_clicked"),
		on_item_selected_callback = callback(self, self, "_on_raid_selected"),
		on_menu_move = {
			right = "info_button",
		},
		scrollable_area_ref = self._raid_list_panel,
		w = self._raid_list_panel:w(),
	}

	self._raid_list = self._raid_list_panel:get_panel():list(raid_list_params)

	self._raid_list_panel:setup_scroll_area()
	self:_layout_slot_list()
end

function MissionSelectionGui:_layout_slot_list()
	if self._slot_list_panel then
		self._slot_list_panel:clear()
	else
		local slot_list_panel_params = {
			name = "slot_list_panel",
			x = 0,
			h = self._list_panel:h() - self._list_tabs:h(),
			w = self._list_panel:w(),
			y = self._list_tabs:h(),
		}

		self._slot_list_panel = self._list_panel:panel(slot_list_panel_params)

		self._slot_list_panel:set_alpha(0)
		self._slot_list_panel:set_visible(false)
	end

	local slot_list_params = {
		name = "slot_list",
		selection_enabled = true,
		x = 0,
		y = 0,
		data_source_callback = callback(self, self, "_slot_list_data_source"),
		h = self._slot_list_panel:h(),
		item_class = RaidGUIControlListItemIcon,
		on_item_clicked_callback = callback(self, self, "_on_slot_clicked"),
		on_item_double_clicked_callback = callback(self, self, "_on_slot_double_clicked"),
		on_item_selected_callback = callback(self, self, "_on_slot_selected"),
		on_menu_move = {
			right = "info_button",
		},
		w = self._slot_list_panel:w(),
	}

	self._slot_list = self._slot_list_panel:list(slot_list_params)
end

function MissionSelectionGui:_layout_raid_wrapper_panel()
	local raid_wrapper_panel_params = {
		name = "raid_wrapper_panel",
		x = 0,
		y = 0,
		h = self._root_panel:h(),
		w = self._root_panel:w(),
	}

	self._raid_panel = self._root_panel:panel(raid_wrapper_panel_params)
end

function MissionSelectionGui:_layout_settings()
	Application:trace("[MissionSelectionGui:_layout_settings]")

	local settings_panel_params = {
		h = 352,
		layer = 1,
		name = "settings_panel",
		w = 480,
		x = 0,
		y = 192,
	}

	self._settings_panel = self._raid_panel:panel(settings_panel_params)

	self._settings_panel:set_x(self._raid_panel:w() - self._settings_panel:w())

	local difficulty_stepper_params = {
		name = "difficulty_stepper",
		x = 0,
		y = 0,
		data_source_callback = callback(self, self, "data_source_difficulty_stepper"),
		description = self:translate("menu_difficulty_title", true),
		on_item_selected_callback = callback(self, self, "_on_difficulty_selected"),
		on_menu_move = {
			down = "permission_stepper",
			left = "audio_button",
			up = "auto_kick_checkbox",
		},
	}

	self._difficulty_stepper = self._settings_panel:stepper(difficulty_stepper_params)

	self._difficulty_stepper:set_value_and_render(Global.player_manager.game_settings_difficulty, true)

	local permission_stepper_params = {
		name = "permission_stepper",
		x = 0,
		data_source_callback = callback(self, self, "data_source_permission_stepper"),
		description = self:translate("menu_permission_title", true),
		on_item_selected_callback = callback(self, self, "_on_permission_selected"),
		on_menu_move = {
			down = "drop_in_checkbox",
			left = "audio_button",
			up = "difficulty_stepper",
		},
		y = self._difficulty_stepper:y() + self._difficulty_stepper:h() + 32,
	}

	self._permission_stepper = self._settings_panel:stepper(permission_stepper_params)

	self._permission_stepper:set_value_and_render(Global.game_settings.permission, true)

	local drop_in_checkbox_params = {
		name = "drop_in_checkbox",
		value = true,
		x = 0,
		description = self:translate("menu_allow_drop_in_title", true),
		on_click_callback = callback(self, self, "_on_toggle_drop_in"),
		on_menu_move = {
			down = "team_ai_checkbox",
			left = "audio_button",
			up = "permission_stepper",
		},
		y = self._permission_stepper:y() + self._permission_stepper:h() + 32,
	}

	self._drop_in_checkbox = self._settings_panel:toggle_button(drop_in_checkbox_params)

	self._drop_in_checkbox:set_value_and_render(Global.game_settings.drop_in_allowed)

	local team_ai_checkbox_params = {
		name = "team_ai_checkbox",
		value = true,
		x = 0,
		description = self:translate("menu_play_with_team_ai_title", true),
		on_click_callback = callback(self, self, "_on_toggle_team_ai"),
		on_menu_move = {
			down = "auto_kick_checkbox",
			left = "audio_button",
			up = "drop_in_checkbox",
		},
		y = self._drop_in_checkbox:y() + self._drop_in_checkbox:h() + 32,
	}

	self._team_ai_checkbox = self._settings_panel:toggle_button(team_ai_checkbox_params)

	self._team_ai_checkbox:set_value_and_render(Global.game_settings.team_ai, true)

	local auto_kick_checkbox_params = {
		name = "auto_kick_checkbox",
		value = true,
		x = 0,
		description = self:translate("menu_auto_kick_cheaters_title", true),
		on_click_callback = callback(self, self, "_on_toggle_auto_kick"),
		on_menu_move = {
			down = "difficulty_stepper",
			left = "audio_button",
			up = "team_ai_checkbox",
		},
		y = self._team_ai_checkbox:y() + self._team_ai_checkbox:h() + 32,
	}

	self._auto_kick_checkbox = self._settings_panel:toggle_button(auto_kick_checkbox_params)

	self._auto_kick_checkbox:set_value_and_render(Global.game_settings.auto_kick, true)
end

function MissionSelectionGui:_layout_settings_offline()
	Application:trace("[MissionSelectionGui:_layout_settings_offline]")

	local settings_panel_params = {
		h = 352,
		layer = 1,
		name = "settings_panel",
		w = 480,
		x = 0,
		y = 192,
	}

	self._settings_panel = self._raid_panel:panel(settings_panel_params)

	self._settings_panel:set_x(self._raid_panel:w() - self._settings_panel:w())

	local difficulty_stepper_params = {
		name = "difficulty_stepper",
		x = 0,
		y = 0,
		data_source_callback = callback(self, self, "data_source_difficulty_stepper"),
		description = self:translate("menu_difficulty_title", true),
		on_item_selected_callback = callback(self, self, "_on_difficulty_selected"),
		on_menu_move = {
			down = "team_ai_checkbox",
			left = "audio_button",
		},
	}

	self._difficulty_stepper = self._settings_panel:stepper(difficulty_stepper_params)

	self._difficulty_stepper:set_value_and_render(Global.player_manager.game_settings_difficulty, true)

	local team_ai_checkbox_params = {
		name = "team_ai_checkbox",
		value = true,
		x = 0,
		description = self:translate("menu_play_with_team_ai_title", true),
		on_click_callback = callback(self, self, "_on_toggle_team_ai"),
		on_menu_move = {
			left = "audio_button",
			up = "difficulty_stepper",
		},
		y = self._difficulty_stepper:y() + self._difficulty_stepper:h() + 32,
	}

	self._team_ai_checkbox = self._settings_panel:toggle_button(team_ai_checkbox_params)

	self._team_ai_checkbox:set_value_and_render(Global.game_settings.team_ai, true)
end

function MissionSelectionGui:_layout_primary_paper()
	local paper_image = "menu_paper"
	local soe_emblem_image = "icon_paper_stamp"
	local primary_paper_panel_params = {
		h = 768,
		name = "primary_paper_panel",
		w = 524,
		x = 580,
		y = 117,
		layer = RaidGuiBase.FOREGROUND_LAYER + 150,
	}

	self._primary_paper_panel = self._root_panel:panel(primary_paper_panel_params)

	local primary_paper_params = {
		name = "primary_paper",
		x = 0,
		y = 0,
		h = self._primary_paper_panel:h(),
		texture = tweak_data.gui.images[paper_image].texture,
		texture_rect = tweak_data.gui.images[paper_image].texture_rect,
		w = self._primary_paper_panel:w(),
	}

	self._primary_paper = self._primary_paper_panel:bitmap(primary_paper_params)

	local soe_emblem_params = {
		name = "soe_emblem",
		x = 384,
		y = 22,
		layer = self._primary_paper:layer() + 1,
		texture = tweak_data.gui.icons[soe_emblem_image].texture,
		texture_rect = tweak_data.gui.icons[soe_emblem_image].texture_rect,
	}

	self._soe_emblem = self._primary_paper_panel:bitmap(soe_emblem_params)

	local subtitle_params = {
		name = "primary_paper_subtitle",
		text = "",
		x = 38,
		y = 42,
		color = tweak_data.gui.colors.raid_dark_grey,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.extra_small,
		layer = self._primary_paper:layer() + 1,
	}

	self._primary_paper_subtitle = self._primary_paper_panel:label(subtitle_params)

	local title_params = {
		name = "primary_paper_title",
		text = "",
		x = 38,
		y = 68,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.large,
		layer = self._primary_paper:layer() + 1,
	}

	self._primary_paper_title = self._primary_paper_panel:label(title_params)

	local separator_params = {
		h = 2,
		name = "primary_paper_separator",
		w = 350,
		x = 34,
		y = 123,
		color = tweak_data.gui.colors.raid_black,
		layer = self._primary_paper:layer() + 1,
	}

	self._primary_paper_separator = self._primary_paper_panel:rect(separator_params)

	self:_layout_raid_description()
	self:_layout_intel_image_grid()
	self:_layout_operation_progress_text()
	self:_layout_operation_list()
end

function MissionSelectionGui:_layout_raid_description()
	local mission_description_params = {
		h = 528,
		name = "mission_descripton",
		text = "",
		w = 432,
		wrap = true,
		x = 38,
		y = 136,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.paragraph,
		layer = self._primary_paper_panel:layer() + 1,
	}

	self._mission_description = self._primary_paper_panel:label(mission_description_params)

	self._mission_description:set_visible(false)

	self._active_primary_paper_control = self._mission_description
end

function MissionSelectionGui:_layout_operation_progress_text()
	local operation_progress_panel_params = {
		h = 490,
		name = "operation_progress_panel",
		w = 440,
		x = self._primary_paper_title:x(),
		y = self._mission_description:y(),
	}

	self._operation_progress_panel = self._primary_paper_panel:panel(operation_progress_panel_params)

	local operation_progress_params = {
		name = "operation_progress",
		operation = "clear_skies",
		x = 0,
		y = 0,
		h = self._operation_progress_panel:h(),
		w = self._operation_progress_panel:w(),
	}

	self._operation_progress = self._operation_progress_panel:create_custom_control(RaidGUIControlOperationProgress, operation_progress_params)

	self._operation_progress:set_alpha(0)
	self._operation_progress:set_visible(false)
end

function MissionSelectionGui:_layout_operation_list()
	local operation_list_panel_params = {
		h = 448,
		name = "operation_list_panel",
		w = 432,
		x = 31,
		y = 136,
		layer = self._primary_paper_panel:layer() + 1,
	}

	self._operation_list_panel = self._primary_paper_panel:panel(operation_list_panel_params)

	local operation_list_params = {
		name = "operation_list",
		selection_enabled = true,
		x = 0,
		y = 0,
		data_source_callback = callback(self, self, "_operation_list_data_source"),
		h = self._operation_list_panel:h(),
		item_class = RaidGUIControlListItemIconDescription,
		item_params = {
			icon_color = Color.black,
		},
		on_item_clicked_callback = callback(self, self, "_on_operation_selected"),
		on_item_double_clicked_callback = callback(self, self, "_on_mission_list_double_clicked"),
		on_item_selected_callback = callback(self, self, "_on_operation_selected"),
		on_menu_move = {
			down = "info_button",
			left = "list_tabs",
			right = "difficulty_stepper",
		},
		selected_callback = callback(self, self, "_on_operation_list_selected"),
		unselected_callback = callback(self, self, "_on_operation_list_unselected"),
		w = self._operation_list_panel:w(),
	}

	self._operation_list = self._operation_list_panel:list_active(operation_list_params)

	self._operation_list:set_alpha(0)
	self._operation_list:set_visible(false)
end

function MissionSelectionGui:_layout_intel_image_grid()
	local intel_image_grid_params = {
		name = "intel_image_grid",
		x = 10,
		y = 128,
		layer = self._primary_paper_panel:layer() + 1,
		on_click_callback = callback(self, self, "_on_intel_image_selected"),
		on_menu_move = {
			down = "intel_button",
			left = "list_tabs",
			up = "operation_list",
		},
	}

	self._intel_image_grid = self._primary_paper_panel:create_custom_control(RaidGUIControlIntelImageGrid, intel_image_grid_params)

	self._intel_image_grid:set_alpha(0)
	self._intel_image_grid:set_visible(false)
end

function MissionSelectionGui:_on_intel_image_selected(image_index, image_data)
	self._intel_image_details:set_image(image_data.photo, image_data.title_id, image_data.description_id)
end

function MissionSelectionGui:_layout_info_buttons()
	local wrapper_panel_padding = 10
	local info_buttons_panel_params = {
		h = 96,
		name = "info_buttons_panel",
		y = 0,
		layer = self._primary_paper_panel:layer() + 1,
		w = self._primary_paper_panel:w() * 0.85,
		x = self._primary_paper_title:x(),
	}

	self._info_buttons_panel = self._primary_paper_panel:panel(info_buttons_panel_params)

	self._info_buttons_panel:set_center_x(self._primary_paper_panel:w() / 2)
	self._info_buttons_panel:set_y(self._primary_paper_panel:h() - self._info_buttons_panel:h() - 16)

	local info_button_params = {
		active = true,
		icon = "ico_info",
		name = "info_button",
		on_click_callback = callback(self, self, "_on_info_clicked"),
		on_menu_move = {
			left = "list_tabs",
			right = "intel_button",
			up = "intel_image_grid",
		},
		text = self:translate("menu_info_button_title", true),
		x = wrapper_panel_padding,
	}

	self._info_button = self._info_buttons_panel:info_button(info_button_params)

	self._info_button:set_center_y(self._info_buttons_panel:h() / 2)
	self._info_button:set_x(0)

	local intel_button_params = {
		icon = "ico_intel",
		name = "intel_button",
		on_click_callback = callback(self, self, "_on_intel_clicked"),
		on_menu_move = {
			left = "info_button",
			right = "audio_button",
			up = "intel_image_grid",
		},
		text = self:translate("menu_intel_button_title", true),
	}

	self._intel_button = self._info_buttons_panel:info_button(intel_button_params)

	self._intel_button:set_center_y(self._info_buttons_panel:h() / 2)
	self._intel_button:set_center_x(130 + self._info_button:center_x())

	local audio_button_params = {
		auto_deactivate = true,
		icon = "ico_play_audio",
		name = "audio_button",
		on_click_callback = callback(self, self, "_on_audio_clicked"),
		on_menu_move = {
			left = "intel_button",
			right = "difficulty_stepper",
			up = "intel_image_grid",
		},
		text = self:translate("menu_audio_button_title", true),
	}

	self._audio_button = self._info_buttons_panel:info_button(audio_button_params)

	self._audio_button:set_center_y(self._info_buttons_panel:h() / 2)
	self._audio_button:set_center_x(260 + self._info_button:center_x())
end

function MissionSelectionGui:_layout_secondary_paper()
	local paper_image = "menu_paper"
	local soe_emblem_image = "icon_paper_stamp"
	local secondary_paper_panel_params = {
		h = 768,
		name = "secondary_paper_panel",
		w = 524,
		x = 580,
		y = 118,
		layer = RaidGuiBase.FOREGROUND_LAYER,
	}

	self._secondary_paper_panel = self._root_panel:panel(secondary_paper_panel_params)

	local secondary_paper_params = {
		name = "secondary_paper",
		x = 0,
		y = 0,
		h = self._secondary_paper_panel:h(),
		texture = tweak_data.gui.images[paper_image].texture,
		texture_rect = tweak_data.gui.images[paper_image].texture_rect,
		w = self._secondary_paper_panel:w(),
	}

	self._secondary_paper = self._secondary_paper_panel:bitmap(secondary_paper_params)

	self:_layout_secondary_intel()
	self:_layout_secondary_save_info()
	self._secondary_paper_panel:set_x(self._primary_paper_panel:x())
	self._secondary_paper_panel:set_rotation(MissionSelectionGui.BACKGROUND_PAPER_ROTATION)
	self._secondary_paper_panel:set_w(self._primary_paper_panel:w() * MissionSelectionGui.BACKGROUND_PAPER_SCALE)
	self._secondary_paper_panel:set_h(self._primary_paper_panel:h() * MissionSelectionGui.BACKGROUND_PAPER_SCALE)
	self._secondary_paper:set_color(MissionSelectionGui.BACKGROUND_PAPER_COLOR)
	self._secondary_paper_panel:set_alpha(MissionSelectionGui.BACKGROUND_PAPER_ALPHA)

	self._secondary_paper_shown = false
	self._paper_animation_t = 0
end

function MissionSelectionGui:_layout_secondary_intel()
	local intel_image_details_params = {
		name = "intel_image_details",
		x = 35,
		y = 144,
	}

	self._intel_image_details = self._secondary_paper_panel:create_custom_control(RaidGUIControlIntelImageDetails, intel_image_details_params)
	self._active_secondary_paper_control = self._intel_image_details
end

function MissionSelectionGui:_layout_secondary_save_info()
	local save_info_params = {
		name = "save_info",
		x = 0,
		y = 0,
		h = self._secondary_paper_panel:h(),
		layer = self._secondary_paper_panel:layer() + 1,
		w = self._secondary_paper_panel:w(),
	}

	self._save_info = self._secondary_paper_panel:create_custom_control(RaidGUIControlSaveInfo, save_info_params)
end

function MissionSelectionGui:_layout_start_button()
	local raid_start_button_params = {
		layer = 1,
		name = "raid_start_button",
		x = 6,
		on_click_callback = callback(self, self, "_on_start_button_click"),
		text = self:translate("menu_start_button_title", true),
		y = self._settings_panel:y() + self._settings_panel:h() + 248,
	}

	self._raid_start_button = self._raid_panel:short_primary_button(raid_start_button_params)

	if not Network:is_server() then
		self._raid_start_button:set_visible(false)

		local client_message_params = {
			name = "client_message",
			color = tweak_data.gui.colors.raid_red,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_32,
			text = self:translate("menu_only_host_can_start_missions", true),
		}
		local client_message = self._raid_panel:label(client_message_params)
		local _, _, _, h = client_message:text_rect()

		client_message:set_h(h)
		client_message:set_center_y(self._raid_start_button:center_y())
	end
end

function MissionSelectionGui:_layout_delete_button()
	local save_delete_button_params = {
		layer = 1,
		name = "save_delete_button",
		x = 6,
		on_click_callback = callback(self, self, "_on_delete_button_click"),
		text = self:translate("menu_delete_save_button_title", true),
		y = self._settings_panel:y() + self._settings_panel:h() + 248,
	}

	self._save_delete_button = self._raid_panel:short_secondary_button(save_delete_button_params)

	self._save_delete_button:set_x(self._raid_list:x() + self._raid_list:w() - self._raid_start_button:x() - self._save_delete_button:w())
	self._save_delete_button:hide()
end

function MissionSelectionGui:_on_mission_type_changed(mission_type)
	if mission_type == "raids" then
		self:_select_raids_tab()
	else
		self:_select_operations_tab()
	end
end

function MissionSelectionGui:_select_raids_tab()
	self._selected_save_slot = nil
	self._continue_slot_selected = nil

	self._slot_list:set_selected(false)
	self._raid_list:set_selected(true)
	self._save_delete_button:animate_hide()
	self._raid_list_panel:set_visible(true)
	self._raid_list_panel:set_alpha(1)
	self._slot_list_panel:set_visible(false)
	self._slot_list_panel:set_alpha(0)
	self:_bind_raid_controller_inputs()
end

function MissionSelectionGui:_select_operations_tab()
	self._raid_list:set_selected(false)
	self._slot_list:set_selected(true)
	self._raid_list_panel:set_visible(false)
	self._raid_list_panel:set_alpha(0)
	self._slot_list_panel:set_visible(true)
	self._slot_list_panel:set_alpha(1)
end

function MissionSelectionGui:_select_raid(raid)
	return
end

function MissionSelectionGui:_on_start_button_click()
	managers.challenge_cards:remove_active_challenge_card()

	if self._selected_job_id then
		self:_start_job(self._selected_job_id)
	elseif self._continue_slot_selected then
		self:_continue_operation()
	end
end

function MissionSelectionGui:_on_delete_button_click()
	local selected_job = managers.raid_job:get_save_slots()[self._continue_slot_selected].current_job
	local current_job = managers.raid_job:current_job()

	if current_job and current_job.job_type == OperationsTweakData.JOB_TYPE_OPERATION and managers.raid_job:get_current_save_slot() == self._selected_save_slot then
		managers.menu:show_deleting_current_operation_save_dialog()
	else
		local params = {}

		params.yes_callback = callback(self, self, "on_save_slot_delete_confirmed")

		managers.menu:show_save_slot_delete_confirm_dialog(params)
	end
end

function MissionSelectionGui:on_save_slot_delete_confirmed()
	if self._continue_slot_selected then
		managers.raid_job:delete_save(self._continue_slot_selected)
		self._slot_list:refresh_data()

		local slot_to_select = self._continue_slot_selected

		self._raid_list:set_selected(false)
		self._slot_list:set_selected(true)
		self._slot_list:click_item(slot_to_select)
		self:_on_empty_slot_selected()
	end
end

function MissionSelectionGui:_select_save_slot(slot)
	return
end

function MissionSelectionGui:_on_raid_clicked(raid_data)
	if self._selected_job_id and self._selected_job_id == raid_data.value then
		return
	end

	if not self._selected_job_id or self._selected_job_id ~= raid_data.value then
		self:_stop_mission_briefing_audio()
	end

	self._selected_job_id = raid_data.value
	self._selected_new_operation_index = nil

	local raid_tweak_data = tweak_data.operations.missions[raid_data.value]

	if raid_tweak_data.consumable then
		self._primary_paper_subtitle:set_text(self:translate("menu_mission_selected_mission_type_consumable", true))
	else
		self._primary_paper_subtitle:set_text(self:translate("menu_mission_selected_mission_type_raid", true))
	end

	self._primary_paper_title:set_text(self:translate(raid_tweak_data.name_id, true))

	local stamp_texture = tweak_data.gui.icons[MissionSelectionGui.PAPER_STAMP_ICON]

	if raid_tweak_data.consumable then
		stamp_texture = tweak_data.gui.icons[MissionSelectionGui.PAPER_STAMP_ICON_CONSUMABLE]
	end

	self._soe_emblem:set_image(stamp_texture.texture)
	self._soe_emblem:set_texture_rect(unpack(stamp_texture.texture_rect))
	self._info_button:set_active(true)
	self._intel_button:set_active(false)
	self._audio_button:set_active(false)
	self._info_button:enable()
	self._intel_button:enable()

	if raid_tweak_data.consumable then
		self._audio_button:hide()
	else
		self._audio_button:show()
		self._audio_button:enable()
	end

	self:_on_info_clicked(nil, true)
	self._intel_image_grid:clear_selection()
	self:_stop_mission_briefing_audio()

	local short_audio_briefing_id = raid_tweak_data.short_audio_briefing_id

	if short_audio_briefing_id then
		managers.queued_tasks:queue("play_short_audio_briefing", self.play_short_audio_briefing, self, short_audio_briefing_id, 1, nil)
	end
end

function MissionSelectionGui:play_short_audio_briefing(briefing_id)
	self._briefing_audio = managers.menu_component:post_event(briefing_id)
end

function MissionSelectionGui:_on_raid_selected(raid_data)
	self:_on_raid_clicked(raid_data)
end

function MissionSelectionGui:_on_mission_list_double_clicked(raid_data)
	self:_on_start_button_click()
end

function MissionSelectionGui:_on_slot_double_clicked(slot_data)
	local current_save_slots = managers.raid_job:get_save_slots()

	if current_save_slots[slot_data.value] then
		self:_on_start_button_click()
	end
end

function MissionSelectionGui:_on_operation_selected(operation_data)
	self._selected_new_operation_index = operation_data.index
	self._selected_job_id = operation_data.value

	self._operation_list:activate_item_by_value(operation_data.value)

	local operation_tweak_data = tweak_data.operations:mission_data(operation_data.value)

	self:_stop_mission_briefing_audio()

	if operation_tweak_data.short_audio_briefing_id then
		local audio_briefing_id = operation_tweak_data.short_audio_briefing_id

		managers.queued_tasks:queue("play_short_audio_briefing", self.play_short_audio_briefing, self, audio_briefing_id, 1, nil)
	end
end

function MissionSelectionGui:_on_operation_list_selected()
	self:_bind_operation_list_controller_inputs()
end

function MissionSelectionGui:_on_operation_list_unselected()
	self:_bind_empty_slot_controller_inputs()
end

function MissionSelectionGui:_on_slot_clicked(slot_data)
	self._primary_paper_subtitle:set_text(self:translate("menu_mission_selected_mission_type_operation", true))

	if self._selected_save_slot == slot_data.value then
		return
	end

	self:_stop_mission_briefing_audio()

	self._selected_save_slot = slot_data.value

	local save_slots = managers.raid_job:get_save_slots()

	if save_slots[self._selected_save_slot] then
		self:_on_save_selected()
	else
		self:_on_empty_slot_selected()
	end
end

function MissionSelectionGui:_on_slot_selected(slot_data)
	self:_on_slot_clicked(slot_data)
end

function MissionSelectionGui:set_current_slot_progress_report()
	local save_slots = managers.raid_job:get_save_slots()
	local selected_job = save_slots[self._selected_save_slot].current_job

	self._operation_progress:set_operation(selected_job.job_id)
	self._operation_progress:set_event_index(selected_job.events_index)
	self._operation_progress:set_number_drawn(selected_job.current_event)
end

function MissionSelectionGui:_on_save_selected()
	self._selected_job_id = nil
	self._selected_new_operation_index = nil
	self._continue_slot_selected = self._selected_save_slot

	local current_job = managers.raid_job:get_save_slots()[self._continue_slot_selected].current_job
	local name_id = current_job.name_id
	local total_events = #current_job.events_index
	local current_event = math.clamp(current_job.current_event, 1, total_events)
	local mission_progress_fraction = " (" .. current_event .. "/" .. total_events .. ")"
	local title_text = self:translate(name_id, true) .. mission_progress_fraction

	self._primary_paper_title:set_text(title_text)

	if managers.raid_menu:is_pc_controller() then
		self._save_delete_button:animate_show()
	elseif not Network:is_server() then
		self._save_delete_button:hide()
	end

	self._info_button:set_active(true)
	self._intel_button:set_active(false)
	self._audio_button:set_active(false)
	self._info_button:enable()
	self._intel_button:enable()
	self._audio_button:enable()
	self:_on_info_clicked(nil, true)
	self._intel_image_grid:clear_selection()
	self:_bind_save_slot_controller_inputs()
end

function MissionSelectionGui:_on_empty_slot_selected()
	self._continue_slot_selected = nil

	self._save_delete_button:animate_hide()
	self._primary_paper_title:set_text(self:translate("menu_list_title", true))
	self._info_button:set_active(true)
	self._intel_button:set_active(false)
	self._audio_button:set_active(false)
	self._info_button:enable()
	self._intel_button:enable()
	self._audio_button:enable()

	if self._secondary_paper_shown then
		self._secondary_paper:stop()
		self._secondary_paper:animate(callback(self, self, "_animate_hide_secondary_paper"))
	end

	if self._active_primary_paper_control ~= self._operation_list then
		local active_item = self._operation_list:get_active_item_index() or 1

		self._operation_list:activate_item_by_index(active_item)
		self._operation_list._list_items[active_item]:on_mouse_released(Idstring("0"))
		self._primary_paper:stop()
		self._primary_paper:animate(callback(self, self, "_animate_change_primary_paper_control"), nil, self._operation_list)
	end

	self:_bind_empty_slot_controller_inputs()
end

function MissionSelectionGui:_on_info_clicked(secondary_paper_callback, force)
	if self._info_button:active() and force ~= true then
		return
	end

	if self._selected_job_id then
		if self._secondary_paper_shown then
			self._secondary_paper:stop()
			self._secondary_paper:animate(callback(self, self, "_animate_hide_secondary_paper"))
		end

		if self._list_tabs._items[self._list_tabs._selected_item_idx]._name == "tab_operation" then
			self._operation_list:click_item(self._selected_new_operation_index)
			self._primary_paper:stop()
			self._primary_paper:animate(callback(self, self, "_animate_change_primary_paper_control"), nil, self._operation_list)
		else
			local clbk = callback(self._mission_description, self._mission_description, "set_text", self:translate(tweak_data.operations.missions[self._selected_job_id].briefing_id))

			self._primary_paper:stop()
			self._primary_paper:animate(callback(self, self, "_animate_change_primary_paper_control"), clbk, self._mission_description)
		end

		self._info_button:set_active(true)
		self._intel_button:set_active(false)
		self._audio_button:set_active(false)
	elseif self._continue_slot_selected then
		if not self._secondary_paper_shown then
			self:_hide_all_secondary_panels()
			self._save_info:set_alpha(1)
			self._save_info:set_visible(true)
			self._save_info:set_save_info(self._continue_slot_selected)

			self._active_secondary_paper_control = self._save_info

			self._secondary_paper:stop()
			self._secondary_paper:animate(callback(self, self, "_animate_show_secondary_paper"))
		else
			local clbk = callback(self._save_info, self._save_info, "set_save_info", self._continue_slot_selected)

			self._soe_emblem:stop()
			self._soe_emblem:animate(callback(self, self, "_animate_change_secondary_paper_control"), clbk, self._save_info)
		end

		self._primary_paper:stop()
		self._primary_paper:animate(callback(self, self, "_animate_change_primary_paper_control"), callback(self, self, "set_current_slot_progress_report"), self._operation_progress)
		self._info_button:set_active(true)
		self._intel_button:set_active(false)
		self._audio_button:set_active(false)
		self._info_button:enable()
		self._intel_button:enable()
		self._audio_button:enable()
	end
end

function MissionSelectionGui:_prepare_intel_image_for_selected_job()
	if self._selected_job_id then
		local first_n_missions

		if self._list_tabs._items[self._list_tabs._selected_item_idx]._name == "tab_operation" then
			first_n_missions = 1
		end

		self._intel_image_grid:set_data({
			image_selected = 1,
			mission = self._selected_job_id,
			only_first_n_events = first_n_missions,
		})
	elseif self._continue_slot_selected then
		local save_slots = managers.raid_job:get_save_slots()
		local save_data = save_slots[self._continue_slot_selected].current_job

		self._intel_image_grid:set_data({
			save_data.current_event,
			image_selected = 1,
			mission = save_data.job_id,
			save_data = save_data,
		})
	end
end

function MissionSelectionGui:_prepare_intel_image_for_selected_save(...)
	return
end

function MissionSelectionGui:_on_intel_clicked()
	if self._intel_button:active() then
		return
	end

	local save_data

	if not self._secondary_paper_shown then
		self:_hide_all_secondary_panels()
		self._intel_image_details:set_alpha(1)
		self._intel_image_details:set_visible(true)

		self._active_secondary_paper_control = self._intel_image_details

		self:_prepare_intel_image_for_selected_job()
		self._secondary_paper:stop()
		self._secondary_paper:animate(callback(self, self, "_animate_show_secondary_paper"))
	else
		local clbk = callback(self, self, "_prepare_intel_image_for_selected_job")

		self._soe_emblem:stop()
		self._soe_emblem:animate(callback(self, self, "_animate_change_secondary_paper_control"), clbk, self._intel_image_details)
	end

	if self._continue_slot_selected then
		save_data = managers.raid_job:get_save_slots()[self._continue_slot_selected].current_job
	end

	local first_n_missions

	if self._list_tabs._items[self._list_tabs._selected_item_idx]._name == "tab_operation" and self._selected_job_id and not self._continue_slot_selected then
		first_n_missions = 1
	end

	local clbk = callback(self._intel_image_grid, self._intel_image_grid, "set_data", {
		mission = self._selected_job_id or managers.raid_job:get_save_slots()[self._continue_slot_selected].current_job.job_id,
		only_first_n_events = first_n_missions,
		save_data = save_data,
	})

	self._primary_paper:stop()
	self._primary_paper:animate(callback(self, self, "_animate_change_primary_paper_control"), clbk, self._intel_image_grid)
	self._info_button:set_active(false)
	self._intel_button:set_active(true)
	self._audio_button:set_active(false)
end

function MissionSelectionGui:_on_audio_clicked()
	local job_id = self._selected_job_id

	if not job_id then
		local save_slots = managers.raid_job:get_save_slots()

		job_id = save_slots[self._continue_slot_selected].current_job.job_id
	end

	local audio_briefing_id = tweak_data.operations.missions[job_id].audio_briefing_id

	self:_stop_mission_briefing_audio()

	self._briefing_button_sfx = managers.menu_component:post_event("mrs_white_mission_briefing_button")
	self._briefing_audio = managers.menu_component:post_event(audio_briefing_id)
end

function MissionSelectionGui:_stop_mission_briefing_audio()
	managers.queued_tasks:unqueue("play_short_audio_briefing")

	if alive(self._briefing_button_sfx) then
		self._briefing_button_sfx:stop()

		self._briefing_button_sfx = nil
	end

	if alive(self._briefing_audio) then
		self._briefing_audio:stop()

		self._briefing_audio = nil
	end
end

function MissionSelectionGui:_hide_all_secondary_panels()
	self._intel_image_details:set_alpha(0)
	self._intel_image_details:set_visible(false)
	self._save_info:set_alpha(0)
	self._save_info:set_visible(false)
end

function MissionSelectionGui:_on_difficulty_selected(data)
	return
end

function MissionSelectionGui:data_source_difficulty_stepper()
	local difficulties = {}

	table.insert(difficulties, {
		info = "difficulty_1",
		value = "difficulty_1",
		text = self:translate("menu_difficulty_1", true),
	})
	table.insert(difficulties, {
		info = "difficulty_2",
		value = "difficulty_2",
		text = self:translate("menu_difficulty_2", true),
	})
	table.insert(difficulties, {
		info = "difficulty_3",
		value = "difficulty_3",
		text = self:translate("menu_difficulty_3", true),
	})
	table.insert(difficulties, {
		info = "difficulty_4",
		value = "difficulty_4",
		text = self:translate("menu_difficulty_4", true),
	})

	return difficulties
end

function MissionSelectionGui:_on_permission_selected(data)
	return
end

function MissionSelectionGui:data_source_permission_stepper()
	local permissions = {}

	table.insert(permissions, {
		info = "public",
		value = "public",
		text = self:translate("menu_permission_public", true),
	})
	table.insert(permissions, {
		info = "friends_only",
		value = "friends_only",
		text = self:translate("menu_permission_friends", true),
	})
	table.insert(permissions, {
		info = "private",
		value = "private",
		text = self:translate("menu_permission_private", true),
	})

	return permissions
end

function MissionSelectionGui:_on_toggle_drop_in(button, control, value)
	return
end

function MissionSelectionGui:_on_toggle_team_ai(button, control, value)
	return
end

function MissionSelectionGui:_on_toggle_auto_kick(button, control, value)
	return
end

function MissionSelectionGui:_raid_list_data_source()
	local non_consumable_list = {}
	local consumable_list = {}

	for _, mission_name in pairs(tweak_data.operations:get_raids_index()) do
		local mission_data = tweak_data.operations:mission_data(mission_name)
		local item_text = self:translate(mission_data.name_id)
		local item_icon_name = mission_data.icon_menu
		local item_icon = {
			texture = tweak_data.gui.icons[item_icon_name].texture,
			texture_rect = tweak_data.gui.icons[item_icon_name].texture_rect,
		}

		if mission_data.consumable then
			if managers.consumable_missions:is_mission_unlocked(mission_name) then
				table.insert(consumable_list, {
					breadcrumb = {
						category = BreadcrumbManager.CATEGORY_CONSUMABLE_MISSION,
						identifiers = {
							mission_name,
						},
					},
					color = tweak_data.gui.colors.raid_gold,
					icon = item_icon,
					selected_color = tweak_data.gui.colors.raid_gold,
					text = item_text,
					value = mission_name,
				})
			end
		else
			table.insert(non_consumable_list, {
				color = tweak_data.gui.colors.raid_white,
				icon = item_icon,
				selected_color = tweak_data.gui.colors.raid_red,
				text = item_text,
				value = mission_name,
			})
		end
	end

	local raid_list = consumable_list

	for _, mission in pairs(non_consumable_list) do
		table.insert(raid_list, mission)
	end

	return raid_list
end

function MissionSelectionGui:_operation_list_data_source()
	local operation_list = {}

	for index, mission_name in pairs(tweak_data.operations:get_operations_index()) do
		local operation_tweak_data = tweak_data.operations:mission_data(mission_name)
		local item_title = self:translate(operation_tweak_data.name_id)
		local item_description = self:translate(operation_tweak_data.briefing_id)
		local item_icon_name = operation_tweak_data.icon_menu
		local item_icon = {
			texture = tweak_data.gui.icons[item_icon_name].texture,
			texture_rect = tweak_data.gui.icons[item_icon_name].texture_rect,
		}

		table.insert(operation_list, {
			description = item_description,
			icon = item_icon,
			index = index,
			title = item_title,
			value = mission_name,
		})
	end

	if #operation_list >= 1 then
		-- block empty
	end

	return operation_list
end

function MissionSelectionGui:_slot_list_data_source()
	local current_save_slots = managers.raid_job:get_save_slots()
	local slot_list = {}

	for i = 1, 5 do
		local current_slot = {}

		current_slot.value = i

		if current_save_slots[i] then
			current_slot.text = self:translate(current_save_slots[i].current_job.name_id)

			local icon_name = tweak_data.operations:mission_data(current_save_slots[i].current_job.job_id).icon_menu

			current_slot.icon = {
				texture = tweak_data.gui.icons[icon_name].texture,
				texture_rect = tweak_data.gui.icons[icon_name].texture_rect,
			}
		else
			current_slot.text = self:translate("menu_empty_save_slot_title")

			local icon_name = "missions_operation_empty_slot_menu"

			current_slot.icon = {
				texture = tweak_data.gui.icons[icon_name].texture,
				texture_rect = tweak_data.gui.icons[icon_name].texture_rect,
			}
		end

		table.insert(slot_list, current_slot)
	end

	return slot_list
end

function MissionSelectionGui:_continue_operation()
	if self._continue_slot_selected then
		managers.raid_job:continue_operation(self._continue_slot_selected)
	end

	local save_slot = managers.raid_job:get_save_slots()[self._continue_slot_selected]

	if save_slot.difficulty then
		tweak_data:set_difficulty(save_slot.difficulty)
	end

	managers.raid_menu:close_all_menus()
	managers.menu:input_enabled(false)
end

function MissionSelectionGui:_start_job(job_id)
	local difficulty = self._difficulty_stepper:get_value()
	local team_ai = self._team_ai_checkbox:get_value()
	local permission = Global.DEFAULT_PERMISSION
	local drop_in_allowed = true
	local auto_kick = true

	tweak_data:set_difficulty(difficulty)

	Global.game_settings.team_ai = team_ai
	Global.player_manager.game_settings_difficulty = difficulty
	Global.player_manager.game_settings_team_ai = team_ai

	if not Global.game_settings.single_player then
		permission = self._permission_stepper:get_value()
		drop_in_allowed = self._drop_in_checkbox:get_value()
		auto_kick = self._auto_kick_checkbox:get_value()
		Global.game_settings.permission = permission
		Global.game_settings.drop_in_allowed = drop_in_allowed
		Global.game_settings.auto_kick = auto_kick
		Global.player_manager.game_settings_permission = permission
		Global.player_manager.game_settings_drop_in_allowed = drop_in_allowed
		Global.player_manager.game_settings_auto_kick = auto_kick
	end

	if Network:is_server() then
		managers.network:session():chk_server_joinable_state()
		managers.network:update_matchmake_attributes()

		if self._settings_selected.difficulty ~= Global.game_settings.difficulty or self._settings_selected.permission ~= Global.game_settings.permission or self._settings_selected.drop_in_allowed ~= Global.game_settings.drop_in_allowed or self._settings_selected.team_ai ~= Global.game_settings.team_ai or self._settings_selected.auto_kick ~= Global.game_settings.auto_kick then
			managers.savefile:save_game(managers.savefile:get_save_progress_slot())
		end
	end

	managers.raid_job:set_selected_job(job_id)
	managers.raid_menu:close_all_menus()
end

function MissionSelectionGui:_select_mission(job_id)
	self._selected_job_id = job_id

	local job_data = tweak_data.operations:mission_data(job_id)
	local description = managers.localization:text(job_data.briefing_id)
	local mission_title = managers.localization:text("menu_mission_selected_title")

	self._selected_job_id = job_id
end

function MissionSelectionGui:_select_slot(slot)
	self._selected_operation_save_slot = slot
end

function MissionSelectionGui:_animate_change_primary_paper_control(control, mid_callback, new_active_control)
	local fade_out_duration = 0.2
	local t = (1 - self._active_primary_paper_control:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local alpha = Easing.cubic_in_out(t, 1, -1, fade_out_duration)

		self._active_primary_paper_control:set_alpha(alpha)
	end

	self._active_primary_paper_control:set_alpha(0)
	self._active_primary_paper_control:set_visible(false)

	if mid_callback then
		mid_callback()
	end

	self._active_primary_paper_control = new_active_control

	self._active_primary_paper_control:set_visible(true)

	local fade_in_duration = 0.25

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local alpha = Easing.cubic_in_out(t, 0, 1, fade_in_duration)

		self._active_primary_paper_control:set_alpha(alpha)
	end

	self._active_primary_paper_control:set_alpha(1)
end

function MissionSelectionGui:_animate_change_secondary_paper_control(control, mid_callback, new_active_control)
	local fade_out_duration = 0.2
	local t = (1 - self._active_secondary_paper_control:alpha()) * fade_out_duration
	local old_control = self._active_secondary_paper_control

	self._active_secondary_paper_control = new_active_control

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local alpha = Easing.cubic_in_out(t, 1, -1, fade_out_duration)

		old_control:set_alpha(alpha)
	end

	old_control:set_alpha(0)
	old_control:set_visible(false)

	if mid_callback then
		mid_callback()
	end

	self._active_secondary_paper_control:set_visible(true)

	local fade_in_duration = 0.25

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local alpha = Easing.cubic_in_out(t, 0, 1, fade_in_duration)

		self._active_secondary_paper_control:set_alpha(alpha)
	end

	self._active_secondary_paper_control:set_alpha(1)
end

function MissionSelectionGui:_animate_show_secondary_paper()
	local duration = 0.5
	local t = self._paper_animation_t * duration

	self._difficulty_stepper:set_selectable(false)

	self._secondary_paper_shown = true

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local setting_alpha = Easing.cubic_in_out(t, 1, -1, duration)

		self._settings_panel:set_alpha(setting_alpha)

		local alpha = Easing.cubic_in_out(t, MissionSelectionGui.BACKGROUND_PAPER_ALPHA, 1 - MissionSelectionGui.BACKGROUND_PAPER_ALPHA, duration)
		local color_r = Easing.cubic_in_out(t, MissionSelectionGui.BACKGROUND_PAPER_COLOR.r, MissionSelectionGui.FOREGROUND_PAPER_COLOR.r - MissionSelectionGui.BACKGROUND_PAPER_COLOR.r, duration)
		local color_g = Easing.cubic_in_out(t, MissionSelectionGui.BACKGROUND_PAPER_COLOR.g, MissionSelectionGui.FOREGROUND_PAPER_COLOR.g - MissionSelectionGui.BACKGROUND_PAPER_COLOR.g, duration)
		local color_b = Easing.cubic_in_out(t, MissionSelectionGui.BACKGROUND_PAPER_COLOR.b, MissionSelectionGui.FOREGROUND_PAPER_COLOR.b - MissionSelectionGui.BACKGROUND_PAPER_COLOR.b, duration)

		self._secondary_paper:set_color(Color(color_r, color_g, color_b))
		self._secondary_paper_panel:set_alpha(alpha)

		local scale = Easing.cubic_in_out(t, MissionSelectionGui.BACKGROUND_PAPER_SCALE, 1 - MissionSelectionGui.BACKGROUND_PAPER_SCALE, duration)

		self._secondary_paper_panel:set_w(self._primary_paper_panel:w() * scale)
		self._secondary_paper_panel:set_h(self._primary_paper_panel:h() * scale)

		local rotation = Easing.cubic_in_out(t, MissionSelectionGui.BACKGROUND_PAPER_ROTATION, -MissionSelectionGui.BACKGROUND_PAPER_ROTATION, duration)

		self._secondary_paper_panel:set_rotation(rotation)

		local x = Easing.cubic_in_out(t, self._primary_paper_panel:x(), self._primary_paper_panel:w() + MissionSelectionGui.SECONDARY_PAPER_PADDING_LEFT, duration)

		self._secondary_paper_panel:set_x(x)

		self._paper_animation_t = t / duration
	end

	self._settings_panel:set_alpha(0)
	self._settings_panel:set_visible(false)
	self._secondary_paper_panel:set_x(self._primary_paper_panel:x() + self._primary_paper_panel:w() + MissionSelectionGui.SECONDARY_PAPER_PADDING_LEFT)
	self._secondary_paper_panel:set_rotation(0)
	self._secondary_paper_panel:set_w(self._primary_paper_panel:w())
	self._secondary_paper_panel:set_h(self._primary_paper_panel:h())
	self._secondary_paper:set_color(MissionSelectionGui.FOREGROUND_PAPER_COLOR)
	self._secondary_paper_panel:set_alpha(1)

	self._paper_animation_t = 1
end

function MissionSelectionGui:_animate_hide_secondary_paper()
	local duration = 0.5
	local t = (1 - self._paper_animation_t) * duration

	self._difficulty_stepper:set_selectable(true)

	self._secondary_paper_shown = false

	self._settings_panel:set_visible(true)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local setting_alpha = Easing.cubic_in_out(t, 0, 1, duration)

		self._settings_panel:set_alpha(setting_alpha)

		local alpha = Easing.cubic_in_out(t, 1, MissionSelectionGui.BACKGROUND_PAPER_ALPHA - 1, duration)
		local color_r = Easing.cubic_in_out(t, MissionSelectionGui.FOREGROUND_PAPER_COLOR.r, MissionSelectionGui.BACKGROUND_PAPER_COLOR.r - MissionSelectionGui.FOREGROUND_PAPER_COLOR.r, duration)
		local color_g = Easing.cubic_in_out(t, MissionSelectionGui.FOREGROUND_PAPER_COLOR.g, MissionSelectionGui.BACKGROUND_PAPER_COLOR.g - MissionSelectionGui.FOREGROUND_PAPER_COLOR.g, duration)
		local color_b = Easing.cubic_in_out(t, MissionSelectionGui.FOREGROUND_PAPER_COLOR.b, MissionSelectionGui.BACKGROUND_PAPER_COLOR.b - MissionSelectionGui.FOREGROUND_PAPER_COLOR.b, duration)

		self._secondary_paper:set_color(Color(color_r, color_g, color_b))
		self._secondary_paper_panel:set_alpha(alpha)

		local scale = Easing.cubic_in_out(t, 1, MissionSelectionGui.BACKGROUND_PAPER_SCALE - 1, duration)

		self._secondary_paper_panel:set_w(self._primary_paper_panel:w() * scale)
		self._secondary_paper_panel:set_h(self._primary_paper_panel:h() * scale)

		local rotation = Easing.cubic_in_out(t, 0, MissionSelectionGui.BACKGROUND_PAPER_ROTATION, duration)

		self._secondary_paper_panel:set_rotation(rotation)

		local x = Easing.cubic_in_out(t, self._primary_paper_panel:x() + self._primary_paper_panel:w() + MissionSelectionGui.SECONDARY_PAPER_PADDING_LEFT, -self._primary_paper_panel:w() - MissionSelectionGui.SECONDARY_PAPER_PADDING_LEFT, duration)

		self._secondary_paper_panel:set_x(x)

		self._paper_animation_t = 1 - t / duration
	end

	self._settings_panel:set_alpha(1)
	self._secondary_paper_panel:set_x(self._primary_paper_panel:x())
	self._secondary_paper_panel:set_rotation(MissionSelectionGui.BACKGROUND_PAPER_ROTATION)
	self._secondary_paper_panel:set_w(self._primary_paper_panel:w() * MissionSelectionGui.BACKGROUND_PAPER_SCALE)
	self._secondary_paper_panel:set_h(self._primary_paper_panel:h() * MissionSelectionGui.BACKGROUND_PAPER_SCALE)
	self._secondary_paper:set_color(MissionSelectionGui.BACKGROUND_PAPER_COLOR)
	self._secondary_paper_panel:set_alpha(MissionSelectionGui.BACKGROUND_PAPER_ALPHA)

	self._paper_animation_t = 0
end

function MissionSelectionGui:special_btn_pressed_old(...)
	local button_pressed = select(1, ...)

	if not button_pressed then
		return
	end

	if button_pressed == Idstring("trigger_right") then
		if not self._secondary_paper_shown then
			self._difficulty_stepper:set_selected(true)
			self._list_tabs:set_selected(false)
			self._raid_list:set_selected(false)
			self._slot_list:set_selected(false)
		end
	elseif button_pressed == Idstring("trigger_left") then
		self:_unselect_right_column()
		self._list_tabs:set_selected(true)
	elseif button_pressed == Idstring("menu_tab_right") or button_pressed == Idstring("menu_tab_left") then
		self:_unselect_right_column()
	elseif button_pressed == Idstring("menu_mission_selection_start") then
		self:_on_start_button_click()
	end
end

function MissionSelectionGui:back_pressed()
	managers.raid_menu:on_escape()
end

function MissionSelectionGui:_unselect_right_column()
	self._difficulty_stepper:set_selected(false)
	self._team_ai_checkbox:set_selected(false)

	if not Global.game_settings.single_player then
		self._permission_stepper:set_selected(false)
		self._drop_in_checkbox:set_selected(false)
		self._auto_kick_checkbox:set_selected(false)
	end
end

function MissionSelectionGui:_unselect_middle_column()
	self._info_button:set_selected(false)
	self._intel_button:set_selected(false)
	self._audio_button:set_selected(false)
	self._intel_image_grid:set_selected(false)
end

function MissionSelectionGui:bind_controller_inputs()
	self:_bind_raid_controller_inputs()
end

function MissionSelectionGui:_bind_raid_controller_inputs()
	local bindings = {}

	if Network:is_server() then
		table.insert(bindings, {
			callback = callback(self, self, "_on_start_raid"),
			key = Idstring("menu_controller_face_top"),
		})
	end

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	if Network:is_server() then
		table.insert(legend.controller, "menu_legend_mission_start_raid")
	end

	self:set_legend(legend)
end

function MissionSelectionGui:_bind_save_slot_controller_inputs()
	local bindings = {
		{
			label = "",
			callback = callback(self, self, "_on_list_tabs_left"),
			key = Idstring("menu_controller_shoulder_left"),
		},
		{
			callback = callback(self, self, "_on_list_tabs_right"),
			key = Idstring("menu_controller_shoulder_right"),
		},
		{
			callback = callback(self, self, "_on_delete_save"),
			key = Idstring("menu_controller_face_left"),
		},
	}

	if Network:is_server() then
		table.insert(bindings, {
			callback = callback(self, self, "_on_continue_save"),
			key = Idstring("menu_controller_face_top"),
		})
	end

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_mission_raids",
			"menu_legend_mission_operations",
			"menu_legend_delete",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	if Network:is_server() then
		table.insert(legend.controller, "menu_legend_mission_continue_save")
	end

	self:set_legend(legend)
end

function MissionSelectionGui:_bind_empty_slot_controller_inputs()
	local bindings = {
		{
			label = "",
			callback = callback(self, self, "_on_list_tabs_left"),
			key = Idstring("menu_controller_shoulder_left"),
		},
		{
			callback = callback(self, self, "_on_list_tabs_right"),
			key = Idstring("menu_controller_shoulder_right"),
		},
	}

	if Network:is_server() then
		table.insert(bindings, {
			callback = callback(self, self, "_on_start_operation"),
			key = Idstring("menu_controller_face_top"),
		})
	end

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_mission_raids",
			"menu_legend_mission_operations",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	if Network:is_server() then
		table.insert(legend.controller, "menu_legend_mission_start_operation")
	end

	self:set_legend(legend)
end

function MissionSelectionGui:_bind_operation_list_controller_inputs()
	local bindings = {
		{
			label = "",
			callback = callback(self, self, "_on_list_tabs_left"),
			key = Idstring("menu_controller_shoulder_left"),
		},
		{
			callback = callback(self, self, "_on_list_tabs_right"),
			key = Idstring("menu_controller_shoulder_right"),
		},
	}

	if Network:is_server() then
		table.insert(bindings, {
			callback = callback(self, self, "_on_start_operation"),
			key = Idstring("menu_controller_face_top"),
		})
	end

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_mission_raids",
			"menu_legend_mission_operations",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	table.insert(legend.controller, {
		translated_text = managers.localization:get_default_macros().BTN_A .. " " .. self:translate("menu_select_operation", true),
	})

	if Network:is_server() then
		table.insert(legend.controller, "menu_legend_mission_start_operation")
	end

	self:set_legend(legend)
end

function MissionSelectionGui:_on_list_tabs_left()
	if self._selected_tab == "left" then
		return
	end

	self:_unselect_right_column()
	self:_unselect_middle_column()
	self._list_tabs:_move_left()

	self._selected_column = "left"
	self._selected_tab = "left"

	return true, nil
end

function MissionSelectionGui:_on_list_tabs_right()
	if self._selected_tab == "right" then
		return
	end

	self:_unselect_right_column()
	self:_unselect_middle_column()
	self._list_tabs:_move_right()

	self._selected_column = "left"
	self._selected_tab = "right"

	return true, nil
end

function MissionSelectionGui:_on_column_left()
	if self._selected_column == "left" then
		return true, nil
	end

	self:_unselect_right_column()
	self._list_tabs:set_selected(true)

	self._selected_column = "left"

	return true, nil
end

function MissionSelectionGui:_on_column_right()
	if self._selected_column == "right" then
		return true, nil
	end

	self:_unselect_right_column()

	if not self._secondary_paper_shown then
		self._difficulty_stepper:set_selected(true)
		self._list_tabs:set_selected(false)
		self._raid_list:set_selected(false)
		self._slot_list:set_selected(false)
	end

	self._selected_column = "right"

	return true, nil
end

function MissionSelectionGui:_on_start_raid()
	self:_on_start_button_click()

	return true, nil
end

function MissionSelectionGui:_on_delete_save()
	self:_on_delete_button_click()

	return true, nil
end

function MissionSelectionGui:_on_continue_save()
	self:_on_start_button_click()

	return true, nil
end

function MissionSelectionGui:_on_next_operation()
	self._operation_list:select_next_row()
end

function MissionSelectionGui:_on_start_operation()
	self:_on_start_button_click()

	return true, nil
end

function MissionSelectionGui:_on_select_confirm()
	self:_on_start_button_click()

	return true, nil
end
