MissionSelectionGui = MissionSelectionGui or class(RaidGuiBase)
MissionSelectionGui.BACKGROUND_PAPER_COLOR = Color("cccccc")
MissionSelectionGui.BACKGROUND_PAPER_ALPHA = 0.7
MissionSelectionGui.BACKGROUND_PAPER_ROTATION = 5
MissionSelectionGui.BACKGROUND_PAPER_SCALE = 0.9
MissionSelectionGui.FOREGROUND_PAPER_COLOR = Color("ffffff")
MissionSelectionGui.SECONDARY_PAPER_PADDING_LEFT = -4
MissionSelectionGui.PAPER_STAMP_ICON = "icon_paper_stamp"
MissionSelectionGui.PAPER_STAMP_ICON_CONSUMABLE = "icon_paper_stamp_consumable"
MissionSelectionGui.PAPER_STAMP_ICON_OPERATION = "icon_paper_stamp_consumable_ver002"
MissionSelectionGui.SETTINGS_PADDING = 32
MissionSelectionGui.DISPLAY_FIRST = "first"
MissionSelectionGui.DISPLAY_SECOND = "second"
MissionSelectionGui.COLUMN_MISSIONS = 1
MissionSelectionGui.COLUMN_INFO = 2
MissionSelectionGui.COLUMN_SETTINGS = 3

function MissionSelectionGui:init(ws, fullscreen_ws, node, component_name)
	self._settings_selected = {}
	self._selected_column = MissionSelectionGui.COLUMN_MISSIONS
	self._selected_tab = "left"
	self._current_display = MissionSelectionGui.DISPLAY_FIRST

	if managers.progression:mission_progression_completion_pending() then
		managers.progression:complete_mission_progression()
	end

	MissionSelectionGui.super.init(self, ws, fullscreen_ws, node, component_name)

	self._controller_list = {}

	for index = 1, managers.controller:get_wrapper_count() do
		local con = managers.controller:create_controller("boot_" .. index, index, false)

		con:enable()

		self._controller_list[index] = con
	end

	managers.controller:add_hotswap_callback("mission_selection_gui", callback(self, self, "on_controller_hotswap"))

	local just_unlocked_raid = managers.progression:clear_last_unlocked_raid()

	if just_unlocked_raid then
		self._raid_list:select_item_by_value(just_unlocked_raid)
	end

	if managers.raid_job:selected_job() then
		local selected_job = managers.raid_job:selected_job()

		self._raid_list:select_item_by_value(selected_job.job_id)
		self._difficulty_stepper:set_value_and_render(Global.game_settings.difficulty, true)
	end
end

function MissionSelectionGui:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_missions_screen_name")

	self._settings_selected.difficulty = Global.player_manager.game_settings_difficulty
	self._settings_selected.permission = Global.game_settings.permission
	self._settings_selected.drop_in_allowed = Global.game_settings.drop_in_allowed
	self._settings_selected.team_ai = Global.game_settings.selected_team_ai
	self._bounty_completed = managers.raid_job:is_bounty_completed()
end

function MissionSelectionGui:close()
	self._primary_paper:stop()
	self._secondary_paper:stop()
	self._soe_emblem:stop()

	if self._controller_list then
		for _, controller in ipairs(self._controller_list) do
			controller:destroy()
		end
	end

	self:_stop_mission_briefing_audio()
	MissionSelectionGui.super.close(self)
end

function MissionSelectionGui:_layout()
	MissionSelectionGui.super._layout(self)
	self:_layout_lists()
	self:_layout_raid_wrapper_panel()
	self:_layout_right_panel()

	if Global.game_settings.single_player then
		self:_layout_settings_offline()
	else
		self:_layout_settings()
	end

	if managers.event_system:is_event_active() then
		local event_data = managers.event_system:active_event_data()

		if event_data.card_id then
			self:_layout_event()
		end
	end

	self:_layout_mission_card()
	self:_layout_operation_tutorialization()
	self:_layout_difficulty_warning()
	self:_layout_primary_paper()
	self:_layout_info_buttons()
	self:_layout_secondary_paper()
	self:_layout_folder_front_page()
	self:_layout_start_button()
	self:_layout_start_disabled_message()
	self:_layout_delete_button()

	if not managers.progression:mission_progression_completed() then
		self:_layout_progression_unlock_timer()
	end

	self:_create_video_panels()
	self._intel_image_grid:select(1)
	self:_select_raids_tab()

	if managers.controller:is_using_controller() then
		self._raid_start_button:hide()
		self._save_delete_button:hide()
	end

	self:_check_difficulty_warning()

	if self._selected_job_data and self._selected_job_data.bounty and self._bounty_completed then
		self:_bind_locked_raid_controller_inputs()
	else
		self:bind_controller_inputs()
	end

	self:_check_consumables_achievement()
end

function MissionSelectionGui:_layout_lists()
	local list_panel_params = {
		h = 690,
		layer = 1,
		name = "list_panel",
		w = 448,
		y = 78,
	}

	self._list_panel = self._root_panel:panel(list_panel_params)

	local primary_lists_panel_params = {
		name = "primary_lists_panel",
	}

	self._primary_lists_panel = self._list_panel:panel(primary_lists_panel_params)

	local list_tabs_params = {
		name = "list_tabs",
		on_click_callback = callback(self, self, "_on_mission_type_changed"),
		tab_align = "center",
		tabs_params = {
			{
				breadcrumb = {
					category = BreadcrumbManager.CATEGORY_CONSUMABLE_MISSION,
				},
				callback_param = "raids",
				name = "tab_raid",
				text = self:translate("menu_mission_selected_mission_type_raid", true),
			},
			{
				breadcrumb = {
					category = BreadcrumbManager.CATEGORY_OPERATIONS,
				},
				callback_param = "operations",
				name = "tab_operation",
				text = self:translate("menu_mission_selected_mission_type_operation", true),
			},
		},
		x = 3,
	}

	list_tabs_params.tab_width = (self._primary_lists_panel:w() - 2 * list_tabs_params.x) / #list_tabs_params.tabs_params
	self._list_tabs = self._primary_lists_panel:tabs(list_tabs_params)
	self._current_mission_type = "raids"

	local raid_list_scrollable_area_params = {
		h = self._primary_lists_panel:h() - self._list_tabs:h(),
		name = "raid_list_scrollable_area",
		scroll_step = 35,
		w = self._primary_lists_panel:w(),
		y = self._list_tabs:h(),
	}

	self._raid_list_panel = self._primary_lists_panel:scrollable_area(raid_list_scrollable_area_params)

	local raid_list_params = {
		data_source_callback = callback(self, self, "_raid_list_data_source"),
		item_class = RaidGUIControlListItemRaids,
		loop_items = true,
		name = "raid_list",
		on_item_clicked_callback = callback(self, self, "_on_raid_clicked"),
		on_item_double_clicked_callback = callback(self, self, "_on_mission_list_double_clicked"),
		on_item_selected_callback = callback(self, self, "_on_raid_selected"),
		on_mouse_click_sound_event = "menu_enter",
		on_mouse_over_sound_event = "highlight",
		padding_top = 2,
		scrollable_area_ref = self._raid_list_panel,
		selection_enabled = true,
		vertical_spacing = 2,
		w = self._raid_list_panel:w(),
	}

	self._raid_list = self._raid_list_panel:get_panel():list(raid_list_params)

	self._raid_list_panel:setup_scroll_area()
	self:_layout_slot_list()
	self:_layout_operations_list()
end

function MissionSelectionGui:_layout_slot_list()
	if self._slot_list_panel then
		self._slot_list_panel:clear()
	else
		local slot_list_panel_params = {
			h = self._primary_lists_panel:h() - self._list_tabs:h(),
			name = "slot_list_panel",
			w = self._primary_lists_panel:w(),
			x = 0,
			y = self._list_tabs:h(),
		}

		self._slot_list_panel = self._list_panel:panel(slot_list_panel_params)

		self._slot_list_panel:set_alpha(0)
		self._slot_list_panel:set_visible(false)
	end

	self._slot_list = self._slot_list_panel:list({
		data_source_callback = callback(self, self, "_slot_list_data_source"),
		h = self._slot_list_panel:h(),
		item_class = RaidGUIControlListItemSaveSlots,
		loop_items = true,
		name = "slot_list",
		on_item_clicked_callback = callback(self, self, "_on_slot_clicked"),
		on_item_double_clicked_callback = callback(self, self, "_on_slot_double_clicked"),
		on_item_selected_callback = callback(self, self, "_on_slot_selected"),
		on_mouse_click_sound_event = "menu_enter",
		on_mouse_over_sound_event = "highlight",
		padding_top = 2,
		selection_enabled = true,
		vertical_spacing = 2,
		w = self._slot_list_panel:w(),
	})
end

function MissionSelectionGui:_layout_operations_list()
	self._operations_list_panel = self._list_panel:scrollable_area({
		h = self._list_panel:h() - self._list_tabs:h(),
		name = "operations_list_panel",
		scroll_step = 35,
		y = self._list_tabs:h(),
	})

	self._operations_list_panel:set_visible(false)

	self._new_operation_list = self._operations_list_panel:get_panel():list({
		data_source_callback = callback(self, self, "_operation_list_data_source"),
		item_class = RaidGUIControlListItemOperations,
		loop_items = true,
		name = "operation_list",
		on_item_clicked_callback = callback(self, self, "_on_operation_selected"),
		on_item_double_clicked_callback = callback(self, self, "_on_mission_list_double_clicked"),
		on_item_selected_callback = callback(self, self, "_on_operation_selected"),
		on_mouse_click_sound_event = "menu_enter",
		on_mouse_over_sound_event = "highlight",
		padding_top = 2,
		scrollable_area_ref = self._operations_list_panel,
		selected_callback = callback(self, self, "_on_operation_list_selected"),
		selection_enabled = true,
		unselected_callback = callback(self, self, "_on_operation_list_unselected"),
		vertical_spacing = 2,
	})

	self._operations_list_panel:setup_scroll_area()
end

function MissionSelectionGui:_layout_raid_wrapper_panel()
	local raid_wrapper_panel_params = {
		h = self._root_panel:h(),
		name = "raid_wrapper_panel",
		w = self._root_panel:w(),
		x = 0,
		y = 0,
	}

	self._raid_panel = self._root_panel:panel(raid_wrapper_panel_params)
end

function MissionSelectionGui:_layout_right_panel()
	self._right_panel = self._root_panel:panel({
		h = 600,
		layer = 1,
		name = "right_panel",
		w = 480,
		y = 192,
	})

	self._right_panel:set_x(self._root_panel:w() - self._right_panel:w())
end

function MissionSelectionGui:_layout_settings()
	Application:trace("[MissionSelectionGui:_layout_settings]")

	self._settings_controls = {}

	local difficulty_stepper_params = {
		data_source_callback = callback(self, self, "data_source_difficulty_stepper"),
		description = self:translate("menu_difficulty_title", true),
		name = "difficulty",
		on_item_selected_callback = callback(self, self, "_on_difficulty_selected"),
		on_menu_move = {
			down = "permission",
		},
	}

	self._difficulty_stepper = self._right_panel:stepper(difficulty_stepper_params)

	self._difficulty_stepper:set_value_and_render(Global.player_manager.game_settings_difficulty, true)
	table.insert(self._settings_controls, self._difficulty_stepper)

	local permission_stepper_params = {
		data_source_callback = callback(self, self, "data_source_permission_stepper"),
		description = self:translate("menu_permission_title", true),
		name = "permission",
		on_item_selected_callback = callback(self, self, "_on_permission_selected"),
		on_menu_move = {
			down = "drop_in_checkbox",
			up = "difficulty",
		},
		y = self._difficulty_stepper:y() + self._difficulty_stepper:h() + MissionSelectionGui.SETTINGS_PADDING,
	}

	self._permission_stepper = self._right_panel:stepper(permission_stepper_params)

	self._permission_stepper:set_value_and_render(Global.game_settings.permission, true)
	table.insert(self._settings_controls, self._permission_stepper)

	local drop_in_checkbox_params = {
		description = self:translate("menu_allow_drop_in_title", true),
		name = "drop_in_checkbox",
		on_click_callback = callback(self, self, "_on_toggle_drop_in"),
		on_menu_move = {
			down = "team_ai_checkbox",
			up = "permission",
		},
		value = true,
		y = self._permission_stepper:y() + self._permission_stepper:h() + MissionSelectionGui.SETTINGS_PADDING,
	}

	self._drop_in_checkbox = self._right_panel:toggle_button(drop_in_checkbox_params)

	self._drop_in_checkbox:set_value_and_render(Global.game_settings.drop_in_allowed)
	table.insert(self._settings_controls, self._drop_in_checkbox)

	local team_ai_checkbox_params = {
		description = self:translate("menu_play_with_team_ai_title", true),
		name = "team_ai_checkbox",
		on_click_callback = callback(self, self, "_on_toggle_team_ai"),
		on_menu_move = {
			up = "drop_in_checkbox",
		},
		value = true,
		y = self._drop_in_checkbox:y() + self._drop_in_checkbox:h() + MissionSelectionGui.SETTINGS_PADDING,
	}

	self._team_ai_checkbox = self._right_panel:toggle_button(team_ai_checkbox_params)

	self._team_ai_checkbox:set_value_and_render(Global.game_settings.selected_team_ai, true)
	table.insert(self._settings_controls, self._team_ai_checkbox)
end

function MissionSelectionGui:_layout_event()
	local event_name = managers.event_system:active_event()

	self._event_display = self._right_panel:create_custom_control(RaidGUIControlEventDisplay, {
		name = "special_event_display",
		on_menu_move = {
			up = "team_ai_checkbox",
		},
	})

	self._event_display:set_bottom(self._right_panel:h())
	self._event_display:set_event(event_name)

	self._team_ai_checkbox._on_menu_move.down = "special_event_display"
end

function MissionSelectionGui:_layout_operation_tutorialization()
	self._operation_tutorialization_panel = self._root_panel:panel({
		alpha = 0,
		h = self._right_panel:h(),
		name = "operation_tutorialization",
		w = self._right_panel:w(),
		x = self._right_panel:x(),
		y = self._right_panel:y(),
	})
	self._operation_tutorialization_title = self._operation_tutorialization_panel:label({
		color = tweak_data.gui.colors.raid_dirty_white,
		fit_text = true,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_38,
		halign = "left",
		text = self:translate("operations_tutorialization_title", true),
	})
	self._operation_tutorialization_desc = self._operation_tutorialization_panel:text({
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_20,
		halign = "left",
		text = self:translate("operations_tutorialization_description", false),
		wrap = true,
		y = self._operation_tutorialization_title:bottom() + 24,
	})
end

function MissionSelectionGui:_layout_settings_offline()
	Application:trace("[MissionSelectionGui:_layout_settings_offline]")

	self._settings_controls = {}

	local difficulty_stepper_params = {
		data_source_callback = callback(self, self, "data_source_difficulty_stepper"),
		description = self:translate("menu_difficulty_title", true),
		name = "difficulty",
		on_item_selected_callback = callback(self, self, "_on_difficulty_selected"),
		on_menu_move = {
			down = "team_ai_checkbox",
		},
	}

	self._difficulty_stepper = self._right_panel:stepper(difficulty_stepper_params)

	self._difficulty_stepper:set_value_and_render(Global.player_manager.game_settings_difficulty, true)
	table.insert(self._settings_controls, self._difficulty_stepper)

	local team_ai_checkbox_params = {
		description = self:translate("menu_play_with_team_ai_title", true),
		name = "team_ai_checkbox",
		on_click_callback = callback(self, self, "_on_toggle_team_ai"),
		on_menu_move = {
			up = "difficulty",
		},
		value = true,
		y = self._difficulty_stepper:y() + self._difficulty_stepper:h() + MissionSelectionGui.SETTINGS_PADDING,
	}

	self._team_ai_checkbox = self._right_panel:toggle_button(team_ai_checkbox_params)

	self._team_ai_checkbox:set_value_and_render(Global.game_settings.team_ai, true)
	table.insert(self._settings_controls, self._team_ai_checkbox)
end

function MissionSelectionGui:_layout_difficulty_warning()
	local difficulty_warning_panel_params = {
		name = "difficulty_warning_panel",
	}

	self._difficulty_warning_panel = self._right_panel:panel(difficulty_warning_panel_params)

	self._difficulty_warning_panel:set_y(self._difficulty_stepper:bottom())

	local difficulty_warning_text_params = {
		align = "left",
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_20,
		name = "difficulty_warning_text",
		text = "Bla bla bla",
		vertical = "top",
		w = self._difficulty_warning_panel:w() - self._difficulty_stepper:label_x(),
		wrap = true,
		x = self._difficulty_stepper:label_x(),
	}

	self._difficulty_warning = self._difficulty_warning_panel:text(difficulty_warning_text_params)

	self._difficulty_warning:set_bottom(0)
end

function MissionSelectionGui:_layout_folder_front_page()
	local front_page_panel_params = {
		alpha = 0,
		h = self._root_panel:h(),
		halign = "center",
		layer = self._primary_paper_panel:layer() + 1000,
		name = "front_page_panel",
		valign = "scale",
		w = 704,
	}

	self._front_page_panel = self._root_panel:panel(front_page_panel_params)

	self._front_page_panel:set_center_x(self._primary_paper_panel:center_x())

	local front_page_params = {
		halign = "center",
		name = "front_page_image",
		texture = tweak_data.gui.icons.folder_mission.texture,
		texture_rect = tweak_data.gui.icons.folder_mission.texture_rect,
		valign = "center",
	}

	self._front_page_image = self._front_page_panel:bitmap(front_page_params)

	self._front_page_image:set_center_x(self._front_page_panel:w() / 2)
	self._front_page_image:set_center_y(self._front_page_panel:h() / 2 + 10)

	self._current_front_page_image = "folder_mission"

	local front_page_content_panel_params = {
		alpha = 0,
		name = "front_page_content_panel",
	}

	self._front_page_content_panel = self._front_page_panel:panel(front_page_content_panel_params)

	local front_page_icon_params = {
		alpha = 0.9,
		blend_mode = "normal",
		halign = "center",
		layer = self._front_page_image:layer() + 1,
		name = "front_page_icon",
		texture = tweak_data.gui.icons.xp_events_mission_raid_railyard.texture,
		texture_rect = tweak_data.gui.icons.xp_events_mission_raid_railyard.texture_rect,
		valign = "center",
	}

	self._front_page_icon = self._front_page_content_panel:bitmap(front_page_icon_params)

	self._front_page_icon:set_center_x(self._front_page_panel:w() / 2)
	self._front_page_icon:set_center_y(self._front_page_image:center_y() - 42)

	local front_page_title_params = {
		align = "center",
		alpha = 0.9,
		blend_mode = "normal",
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.title,
		h = 80,
		layer = self._front_page_icon:layer(),
		name = "front_page_title",
		text = "TITLENAMEUNSET",
		vertical = "center",
		w = 448,
	}

	self._front_page_title = self._front_page_content_panel:text(front_page_title_params)

	self._front_page_title:set_center_x(self._front_page_image:center_x())
	self._front_page_title:set_center_y(self._front_page_image:center_y() + 238)
end

function MissionSelectionGui:_layout_primary_paper()
	local paper_image = "menu_paper"
	local soe_emblem_image = "icon_paper_stamp"
	local primary_paper_panel_params = {
		h = 768,
		layer = RaidGuiBase.FOREGROUND_LAYER + 150,
		name = "primary_paper_panel",
		w = 524,
		x = 580,
		y = 117,
	}

	self._primary_paper_panel = self._root_panel:panel(primary_paper_panel_params)

	local primary_paper_params = {
		h = self._primary_paper_panel:h(),
		name = "primary_paper",
		texture = tweak_data.gui.images[paper_image].texture,
		texture_rect = tweak_data.gui.images[paper_image].texture_rect,
		w = self._primary_paper_panel:w(),
		x = 0,
		y = 0,
	}

	self._primary_paper = self._primary_paper_panel:bitmap(primary_paper_params)

	local soe_emblem_params = {
		layer = self._primary_paper:layer() + 1,
		name = "soe_emblem",
		texture = tweak_data.gui.icons[soe_emblem_image].texture,
		texture_rect = tweak_data.gui.icons[soe_emblem_image].texture_rect,
		x = 384,
		y = 22,
	}

	self._soe_emblem = self._primary_paper_panel:bitmap(soe_emblem_params)

	local mission_icon_params = {
		color = tweak_data.gui.colors.raid_black,
		layer = self._primary_paper:layer() + 1,
		name = "mission_icon",
		texture = tweak_data.gui.icons[soe_emblem_image].texture,
		texture_rect = tweak_data.gui.icons[soe_emblem_image].texture_rect,
		x = 32,
		y = 44,
	}

	self._primary_paper_mission_icon = self._primary_paper_panel:bitmap(mission_icon_params)

	local title_params = {
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		layer = self._primary_paper:layer() + 1,
		name = "primary_paper_title",
		text = "",
		x = 112,
		y = 44,
	}

	self._primary_paper_title = self._primary_paper_panel:label(title_params)

	local subtitle_params = {
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.extra_small,
		layer = self._primary_paper:layer() + 1,
		name = "primary_paper_title",
		text = "",
		x = 112,
		y = 78,
	}

	self._primary_paper_subtitle = self._primary_paper_panel:label(subtitle_params)

	local mission_difficulty_params = {
		amount = tweak_data:number_of_difficulties(),
		fill_color = tweak_data.gui.colors.raid_black,
		name = "mission_difficulty",
		unavailable_color = tweak_data.gui.colors.raid_dark_grey,
		x = 112,
		y = 78,
	}

	self._primary_paper_difficulty_indicator = self._primary_paper_panel:create_custom_control(RaidGuiControlDifficultyStars, mission_difficulty_params)

	local separator_params = {
		color = tweak_data.gui.colors.raid_black,
		h = 2,
		layer = self._primary_paper:layer() + 1,
		name = "primary_paper_separator",
		w = 350,
		x = 34,
		y = 123,
	}

	self._primary_paper_separator = self._primary_paper_panel:rect(separator_params)

	self:_layout_raid_description()
	self:_layout_intel_image_grid()
	self:_layout_operation_progress_text()
	self:_layout_operation_list()
end

function MissionSelectionGui:_layout_raid_description()
	local mission_description_params = {
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.paragraph,
		h = 528,
		layer = self._primary_paper_panel:layer() + 1,
		name = "mission_descripton",
		text = "",
		w = 432,
		wrap = true,
		x = 38,
		y = 136,
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
		x = self._primary_paper_mission_icon:x(),
		y = self._mission_description:y(),
	}

	self._operation_progress_panel = self._primary_paper_panel:panel(operation_progress_panel_params)

	local operation_progress_params = {
		h = self._operation_progress_panel:h(),
		name = "operation_progress",
		operation = "clear_skies",
		w = self._operation_progress_panel:w(),
		x = 0,
		y = 0,
	}

	self._operation_progress = self._operation_progress_panel:create_custom_control(RaidGUIControlOperationProgress, operation_progress_params)

	self._operation_progress:set_alpha(0)
	self._operation_progress:set_visible(false)
end

function MissionSelectionGui:_layout_operation_list()
	local operation_list_panel_params = {
		h = 448,
		layer = self._primary_paper_panel:layer() + 1,
		name = "operation_list_panel",
		w = 432,
		x = 31,
		y = 136,
	}

	self._operation_list_panel = self._primary_paper_panel:panel(operation_list_panel_params)

	local operation_list_params = {
		data_source_callback = callback(self, self, "_operation_list_data_source"),
		h = self._operation_list_panel:h(),
		item_class = RaidGUIControlListItemIconDescription,
		item_params = {
			icon_color = Color.black,
		},
		name = "operation_list",
		on_item_clicked_callback = callback(self, self, "_on_operation_selected"),
		on_item_double_clicked_callback = callback(self, self, "_on_mission_list_double_clicked"),
		on_item_selected_callback = callback(self, self, "_on_operation_selected"),
		on_menu_move = {
			down = "info_button",
		},
		selected_callback = callback(self, self, "_on_operation_list_selected"),
		selection_enabled = true,
		unselected_callback = callback(self, self, "_on_operation_list_unselected"),
		w = self._operation_list_panel:w(),
	}

	self._operation_list = self._operation_list_panel:list_active(operation_list_params)

	self._operation_list:set_alpha(0)
	self._operation_list:set_visible(false)
end

function MissionSelectionGui:_layout_intel_image_grid()
	local intel_image_grid_params = {
		layer = self._primary_paper_panel:layer() + 1,
		name = "intel_image_grid",
		on_click_callback = callback(self, self, "_on_intel_image_selected"),
		on_menu_move = {
			down = "intel_button",
		},
		x = 10,
		y = 128,
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
		layer = self._primary_paper_panel:layer() + 1,
		name = "info_buttons_panel",
		w = self._primary_paper_panel:w() * 0.85,
		x = self._primary_paper_title:x(),
		y = 0,
	}

	self._info_buttons_panel = self._primary_paper_panel:panel(info_buttons_panel_params)

	self._info_buttons_panel:set_center_x(math.floor(self._primary_paper_panel:w() / 2))
	self._info_buttons_panel:set_y(self._primary_paper_panel:h() - self._info_buttons_panel:h() - 16)

	local info_button_params = {
		active = true,
		icon = "ico_info",
		name = "info_button",
		on_click_callback = callback(self, self, "_on_info_clicked"),
		on_menu_move = {
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
		layer = RaidGuiBase.FOREGROUND_LAYER,
		name = "secondary_paper_panel",
		w = 524,
		x = 580,
		y = 118,
	}

	self._secondary_paper_panel = self._root_panel:panel(secondary_paper_panel_params)

	local secondary_paper_params = {
		h = self._secondary_paper_panel:h(),
		name = "secondary_paper",
		texture = tweak_data.gui.images[paper_image].texture,
		texture_rect = tweak_data.gui.images[paper_image].texture_rect,
		w = self._secondary_paper_panel:w(),
		x = 0,
		y = 0,
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
		h = self._secondary_paper_panel:h(),
		layer = self._secondary_paper_panel:layer() + 1,
		name = "save_info",
		w = self._secondary_paper_panel:w(),
		x = 0,
		y = 0,
	}

	self._save_info = self._secondary_paper_panel:create_custom_control(RaidGUIControlSaveInfo, save_info_params)
end

function MissionSelectionGui:_layout_start_button()
	local raid_start_button_params = {
		layer = 1,
		name = "raid_start_button",
		on_click_callback = callback(self, self, "_on_start_button_click"),
		text = self:translate("menu_start_button_title", true),
		x = 6,
		y = self._right_panel:y() + self._right_panel:h() + 248,
	}

	self._raid_start_button = self._raid_panel:short_primary_button(raid_start_button_params)

	self._raid_start_button:set_center_y(864)

	if not Network:is_server() then
		self._raid_start_button:set_visible(false)

		local client_message_params = {
			color = tweak_data.gui.colors.raid_red,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_32,
			name = "client_message",
			text = self:translate("menu_only_host_can_start_missions", true),
		}
		local client_message = self._raid_panel:label(client_message_params)
		local _, _, _, h = client_message:text_rect()

		client_message:set_h(h)
		client_message:set_center_y(self._raid_start_button:center_y())
	end
end

function MissionSelectionGui:_layout_start_disabled_message()
	local start_disabled_message_params = {
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		h = 96,
		name = "start_disabled_message",
		text = "",
		vertical = "center",
		visible = false,
		w = self._list_panel:w(),
	}

	self._start_disabled_message = self._raid_panel:text(start_disabled_message_params)

	self._start_disabled_message:set_center_y(self._raid_start_button:center_y())
end

function MissionSelectionGui:_layout_delete_button()
	local save_delete_button_params = {
		layer = 1,
		name = "save_delete_button",
		on_click_callback = callback(self, self, "_on_delete_button_click"),
		text = self:translate("menu_delete_save_button_title", true),
		x = 6,
		y = self._right_panel:y() + self._right_panel:h() + 248,
	}

	self._save_delete_button = self._raid_panel:short_secondary_button(save_delete_button_params)

	self._save_delete_button:set_x(self._raid_list:x() + self._raid_list:w() - self._raid_start_button:x() - self._save_delete_button:w())
	self._save_delete_button:hide()
	self._save_delete_button:set_center_y(self._raid_start_button:center_y())
end

function MissionSelectionGui:_layout_progression_unlock_timer()
	local progression_timer_panel_params = {
		h = 64,
		halign = "right",
		name = "progression_timer_panel",
		valign = "top",
	}

	self._progression_timer_panel = self._raid_panel:panel(progression_timer_panel_params)

	local progression_timer_icon_params = {
		color = tweak_data.gui.colors.raid_dirty_white,
		halign = "left",
		name = "progression_timer_icon",
		texture = tweak_data.gui.icons.missions_raids_category_menu.texture,
		texture_rect = tweak_data.gui.icons.missions_raids_category_menu.texture_rect,
		valign = "center",
	}
	local progression_timer_icon = self._progression_timer_panel:bitmap(progression_timer_icon_params)

	progression_timer_icon:set_center_y(self._progression_timer_panel:h() / 2)

	local is_final_unlock_cycle = managers.progression:at_final_unlock_cycle()
	local timer_title_params = {
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		h = 32,
		halign = "left",
		name = "progression_timer_title",
		text = self:translate(is_final_unlock_cycle and "raid_final_raids_in_title" or "raid_next_raid_in_title", true),
		vertical = "center",
		x = 64,
	}
	local timer_title = self._progression_timer_panel:text(timer_title_params)
	local timer_description_params = {
		color = tweak_data.gui.colors.raid_grey_effects,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_20,
		h = 32,
		halign = "left",
		name = "progression_timer_description",
		text = self:translate(is_final_unlock_cycle and "raid_final_raids_in_description" or "raid_next_raid_in_description", true),
		vertical = "center",
		x = 64,
	}
	local timer_description = self._progression_timer_panel:text(timer_description_params)

	timer_description:set_bottom(self._progression_timer_panel:h())

	local timer_params = {
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		h = 32,
		halign = "right",
		horizontal = "right",
		name = "timer",
		text = "",
		vertical = "center",
	}
	local timer = self._progression_timer_panel:text(timer_params)
	local remaining_time = math.floor(managers.progression:time_until_next_unlock())
	local text

	if remaining_time <= 0 then
		text = "...NOW!"
	else
		local hours = math.floor(remaining_time / 3600)

		remaining_time = remaining_time - hours * 3600

		local minutes = math.floor(remaining_time / 60)

		remaining_time = remaining_time - minutes * 60

		local seconds = math.round(remaining_time)

		text = hours > 0 and string.format("%02d", hours) .. ":" or ""
		text = text .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds)
	end

	timer:set_text(text)

	local _, _, w, _ = timer:text_rect()

	timer:set_w(w)
	timer:set_right(self._progression_timer_panel:w())

	local _, _, w, _ = timer_title:text_rect()

	timer_title:set_w(w)

	local _, _, w, _ = timer_description:text_rect()

	timer_description:set_w(w)

	local panel_w = math.max(timer_title:w() + 32 + timer:w(), timer_description:w()) + 64

	self._progression_timer_panel:set_w(math.max(panel_w, self._right_panel:w() - 8))
	self._progression_timer_panel:set_right(self._raid_panel:w())
end

function MissionSelectionGui:_create_video_panels()
	self._fullscreen_ws = managers.gui_data:create_fullscreen_16_9_workspace()
	self._full_panel = self._fullscreen_ws:panel()
	self._safe_rect_workspace = Overlay:gui():create_screen_workspace()

	managers.gui_data:layout_workspace(self._safe_rect_workspace)

	self._safe_panel = self._safe_rect_workspace:panel()
end

function MissionSelectionGui:_play_operations_intro_video()
	local operations_intro_video = "movies/vanilla/operation_briefings/03_operation_brief_op-c3_v004"
	local operations_intro_video_id = tweak_data.intel:get_control_video_by_path(operations_intro_video)

	if operations_intro_video_id then
		managers.unlock:unlock({
			identifier = UnlockManager.CATEGORY_CONTROL_ARCHIVE,
			slot = UnlockManager.SLOT_PROFILE,
		}, {
			operations_intro_video_id,
		})
	end

	local video_panel_params = {
		is_root_panel = true,
		layer = 100,
	}

	self._video_panel = RaidGUIPanel:new(self._full_panel, video_panel_params)

	local video_panel_background_params = {
		color = Color.black,
		halign = "scale",
		layer = 1,
		name = "video_background",
		valign = "scale",
	}
	local video_panel_background = self._video_panel:rect(video_panel_background_params)
	local video_params = {
		layer = 2,
		video = operations_intro_video,
		width = self._video_panel:w(),
	}

	self._control_briefing_video = self._video_panel:video(video_params)

	self._control_briefing_video:set_h(self._video_panel:w() * (self._control_briefing_video:video_height() / self._control_briefing_video:video_width()))
	self._control_briefing_video:set_center_y(self._video_panel:h() / 2)

	self._playing_briefing_video = true

	local press_any_key_text = managers.controller:is_using_controller() and "press_any_key_to_skip_controller" or "press_any_key_to_skip"
	local press_any_key_params = {
		alpha = 0,
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.din_compressed, tweak_data.gui.font_sizes.size_32),
		font_size = tweak_data.gui.font_sizes.size_32,
		layer = self._control_briefing_video:layer() + 100,
		name = "press_any_key_prompt",
		text = utf8.to_upper(managers.localization:text(press_any_key_text)),
	}
	local press_any_key_prompt = self._safe_panel:text(press_any_key_params)
	local _, _, w, h = press_any_key_prompt:text_rect()

	press_any_key_prompt:set_w(w)
	press_any_key_prompt:set_h(h)
	press_any_key_prompt:set_right(self._safe_panel:w() - 50)
	press_any_key_prompt:set_bottom(self._safe_panel:h() - 50)
	press_any_key_prompt:animate(callback(self, self, "_animate_show_press_any_key_prompt"))
	managers.menu_component:post_event("menu_volume_set")
	managers.music:stop()
	self._control_briefing_video:set_selected(true)
	self._root_panel:hide()
	self._root_panel:set_x(-3000)
	self._root_panel:set_y(3000)
	managers.raid_menu:register_on_escape_callback(callback(self, self, "_destroy_operations_intro_video"))
end

function MissionSelectionGui:_animate_show_press_any_key_prompt(prompt)
	local duration = 0.7
	local t = 0

	wait(3)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 0.85, duration)

		prompt:set_alpha(current_alpha)
	end

	prompt:set_alpha(0.85)
end

function MissionSelectionGui:_animate_change_press_any_key_prompt(prompt)
	local fade_out_duration = 0.25
	local t = (1 - prompt:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0.85, -0.85, fade_out_duration)

		prompt:set_alpha(current_alpha)
	end

	prompt:set_alpha(0)

	local press_any_key_text = managers.controller:is_using_controller() and "press_any_key_to_skip_controller" or "press_any_key_to_skip"

	prompt:set_text(utf8.to_upper(managers.localization:text(press_any_key_text)))

	local _, _, w, h = prompt:text_rect()

	prompt:set_w(w)
	prompt:set_h(h)
	prompt:set_right(self._safe_panel:w() - 50)

	local fade_in_duration = 0.25

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 0.85, fade_in_duration)

		prompt:set_alpha(current_alpha)
	end

	prompt:set_alpha(0.85)
end

function MissionSelectionGui:on_controller_hotswap()
	local press_any_key_prompt = self._safe_panel:child("press_any_key_prompt")

	if press_any_key_prompt then
		press_any_key_prompt:stop()
		press_any_key_prompt:animate(callback(self, self, "_animate_change_press_any_key_prompt"))
	end
end

function MissionSelectionGui:update(t, dt)
	if self._playing_briefing_video and (self:is_playing() and self:is_skipped() or not self:is_playing()) then
		self:_destroy_operations_intro_video()
	end
end

function MissionSelectionGui:_destroy_operations_intro_video()
	self._control_briefing_video:destroy()

	if self._video_panel:engine_panel_alive() then
		self._video_panel:remove(self._control_briefing_video)
		self._video_panel:remove_background()
		self._video_panel:remove(self._video_panel:child("video_background"))
		self._video_panel:remove(self._video_panel:child("disclaimer"))
	end

	self._control_briefing_video = nil
	self._video_panel = nil
	self._playing_briefing_video = false

	if alive(self._safe_panel) then
		self._safe_panel:child("press_any_key_prompt"):stop()
		self._safe_panel:remove(self._safe_panel:child("press_any_key_prompt"))
	end

	self:_finish_video()

	return true
end

function MissionSelectionGui:is_playing()
	if alive(self._control_briefing_video) then
		return self._control_briefing_video:loop_count() < 1
	else
		return false
	end
end

function MissionSelectionGui:is_skipped()
	for _, controller in ipairs(self._controller_list) do
		if controller:get_any_input_released() then
			return true
		end
	end

	return false
end

function MissionSelectionGui:_finish_video()
	managers.menu_component:post_event("menu_volume_reset")
	managers.music:stop()
	managers.music:post_event(MusicManager.CAMP_MUSIC, true)
	self._root_panel:set_x(0)
	self._root_panel:set_y(0)
	self._root_panel:show()
	managers.raid_menu:register_on_escape_callback(nil)
end

function MissionSelectionGui:_on_mission_type_changed(mission_type)
	self._current_mission_type = mission_type

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

	if self._event_display then
		self._event_display:set_visible(true)
	end
end

function MissionSelectionGui:_select_operations_tab()
	self._selected_job_id = nil
	self._selected_job_data = nil

	self._raid_list:set_selected(false)
	self._slot_list:set_selected(true)
	self._raid_list_panel:set_visible(false)
	self._raid_list_panel:set_alpha(0)
	self._slot_list_panel:set_visible(true)
	self._slot_list_panel:set_alpha(1)

	if self._event_display then
		self._event_display:set_visible(false)
	end

	self:_set_settings_enabled(false)
	self._active_card_panel:hide()
end

function MissionSelectionGui:_select_raid(raid)
	return
end

function MissionSelectionGui:_on_start_button_click()
	managers.challenge_cards:remove_active_challenge_card()

	if self._selected_job_id then
		self:_start_job(self._selected_job_id, self._selected_job_data)
	elseif self._continue_slot_selected then
		self:_continue_operation()
	else
		self:_display_second_screen()
	end
end

function MissionSelectionGui:_on_delete_button_click()
	local selected_job = managers.raid_job:get_save_slots()[self._continue_slot_selected].current_job
	local current_job = managers.raid_job:current_job()

	if current_job and current_job.job_type == OperationsTweakData.JOB_TYPE_OPERATION and managers.raid_job:get_current_save_slot() == self._selected_save_slot and Network:is_server() then
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

function MissionSelectionGui:_set_settings_enabled(enabled)
	for _, setting_control in ipairs(self._settings_controls) do
		setting_control:set_visible(enabled)
	end
end

function MissionSelectionGui:_on_raid_clicked(raid_data)
	local mission_data = raid_data.mission_data or tweak_data.operations:mission_data(raid_data.value)

	if self._selected_job_data and self._selected_job_data == mission_data then
		return
	end

	self:_stop_mission_briefing_audio()

	local difficulty_available, difficulty_completed = managers.progression:get_mission_progression(mission_data.job_type, raid_data.value)

	if difficulty_available and difficulty_available < tweak_data:difficulty_to_index(self._difficulty_stepper:get_value()) then
		self._difficulty_stepper:set_value_and_render(tweak_data:index_to_difficulty(difficulty_available), true)
		self:_check_difficulty_warning()
	end

	self._operation_tutorialization_panel:get_engine_panel():stop()
	self._operation_tutorialization_panel:get_engine_panel():animate(callback(self, self, "_animate_hide_operation_tutorialization"))

	self._selected_job_id = raid_data.value
	self._selected_job_data = mission_data

	self:_update_soe_stamp(self._selected_job_id)

	self._selected_new_operation_index = nil

	if mission_data.bounty then
		if self._bounty_completed then
			if Network:is_server() then
				self._start_disabled_message:set_text(self:translate("bounty_locked_progression", true))
				self._start_disabled_message:set_visible(true)
				self._raid_start_button:set_visible(false)
			end

			self:_on_locked_bounty_clicked()

			return
		end
	else
		local unlocked = managers.progression:mission_unlocked(mission_data.job_type, self._selected_job_id)

		unlocked = unlocked or mission_data.debug
		unlocked = unlocked or mission_data.consumable

		if not unlocked then
			if Network:is_server() then
				self._start_disabled_message:set_text(self:translate("raid_locked_progression", true))
				self._start_disabled_message:set_visible(true)
				self._raid_start_button:set_visible(false)
			end

			self:_on_locked_raid_clicked()

			return
		end
	end

	if Network:is_server() then
		self._start_disabled_message:set_visible(false)
		self._raid_start_button:set_visible(true)
	end

	self:set_difficulty_stepper_data(difficulty_available, difficulty_completed)
	self:bind_controller_inputs()

	local icon_data = tweak_data.gui:get_full_gui_data(mission_data.icon_menu)

	self._primary_paper_mission_icon:set_image(icon_data.texture)
	self._primary_paper_mission_icon:set_texture_rect(unpack(icon_data.texture_rect))
	self._primary_paper_mission_icon:set_w(tweak_data.gui:icon_w(mission_data.icon_menu))
	self._primary_paper_mission_icon:set_h(tweak_data.gui:icon_h(mission_data.icon_menu))
	self._primary_paper_title:set_text(self:translate(mission_data.name_id, true))

	if mission_data.consumable then
		self._primary_paper_subtitle:set_visible(true)
		self._primary_paper_subtitle:set_text(self:translate("menu_mission_selected_mission_type_consumable", true))
		self._primary_paper_difficulty_indicator:set_visible(false)
	elseif difficulty_available and difficulty_completed then
		self._primary_paper_subtitle:set_visible(false)
		self._primary_paper_difficulty_indicator:set_visible(true)
		self._primary_paper_difficulty_indicator:set_progress(difficulty_available, difficulty_completed)
	end

	self:_update_information_buttons(true, true, not mission_data.consumable)
	self:_on_info_clicked(nil, true)
	self._intel_image_grid:clear_selection()

	if mission_data.active_card then
		print("[BOUNTY]", inspect(mission_data.active_card))
		self._active_card_details:set_card_details(mission_data.active_card, false)
		self._active_card_details:set_control_mode(RaidGUIControlCardDetails.MODE_VIEW_ONLY)
		self._active_card_panel:show()
	else
		self._active_card_panel:hide()
	end

	self:_stop_mission_briefing_audio()

	local short_audio_briefing_id = mission_data.short_audio_briefing_id

	if short_audio_briefing_id then
		managers.queued_tasks:queue("play_short_audio_briefing", self.play_short_audio_briefing, self, short_audio_briefing_id, 1, nil)
	end
end

function MissionSelectionGui:play_short_audio_briefing(briefing_id)
	if briefing_id and briefing_id ~= "" then
		self._briefing_audio = managers.menu_component:post_event(briefing_id)
	end
end

function MissionSelectionGui:_on_raid_selected(raid_data)
	self:_on_raid_clicked(raid_data)
end

function MissionSelectionGui:_on_mission_list_double_clicked(raid_data)
	if not Network:is_server() then
		return
	end

	local mission_availble = false

	if raid_data.consumable then
		mission_availble = managers.consumable_missions:is_mission_unlocked(raid_data.value)
	elseif raid_data.bounty then
		mission_availble = not self._bounty_completed
	else
		local mission_tweak = tweak_data.operations:mission_data(raid_data.value)
		local job_type = mission_tweak.job_type
		local difficulty_available = managers.progression:get_mission_progression(job_type, raid_data.value)
		local current_difficulty = tweak_data:difficulty_to_index(self._difficulty_stepper:get_value())

		mission_availble = managers.progression:mission_unlocked(job_type, raid_data.value) and current_difficulty <= difficulty_available or mission_tweak.debug
	end

	if mission_availble then
		self:_on_start_button_click()
	end
end

function MissionSelectionGui:_on_slot_double_clicked(slot_data)
	if not managers.progression:operations_unlocked() or not Network:is_server() then
		return
	end

	local current_save_slots = managers.raid_job:get_save_slots()

	if current_save_slots[slot_data.value] then
		self:_on_start_button_click()
	else
		self:_display_second_screen()
	end
end

function MissionSelectionGui:_display_second_screen()
	self._current_display = MissionSelectionGui.DISPLAY_SECOND
	self._selected_column = MissionSelectionGui.COLUMN_MISSIONS

	self._primary_lists_panel:hide()
	self._list_tabs:set_enabled(false)
	self._raid_list:hide()
	self._slot_list:hide()
	self._new_operation_list:refresh_data()
	self._new_operation_list:set_selected(true)
	self._new_operation_list:select_item_by_index(1, true)
	self._operations_list_panel:setup_scroll_area()
	self._operations_list_panel:show()
	self._slot_list:set_selected(false)
	self:_unselect_middle_column()
	self:_unselect_right_column()

	local info_button_menu_move = {
		right = "intel_button",
		up = "intel_image_grid",
	}

	self._info_button:set_menu_move_controls(info_button_menu_move)

	self._selected_save_slot = nil

	self._operation_tutorialization_panel:get_engine_panel():stop()
	self._operation_tutorialization_panel:get_engine_panel():animate(callback(self, self, "_animate_hide_operation_tutorialization"))
	managers.raid_menu:register_on_escape_callback(callback(self, self, "back_pressed"))

	return true, nil
end

function MissionSelectionGui:_display_first_screen()
	self._current_display = MissionSelectionGui.DISPLAY_FIRST
	self._selected_column = MissionSelectionGui.COLUMN_MISSIONS

	self._primary_lists_panel:show()
	self._list_tabs:set_enabled(true)
	self._raid_list:show()
	self._slot_list:show()
	self._operations_list_panel:hide()
	self._new_operation_list:set_selected(false)
	self._slot_list:set_selected(true)
	self:_unselect_middle_column()
	self:_unselect_right_column()

	local info_button_menu_move = {
		right = "intel_button",
		up = "intel_image_grid",
	}

	self._info_button:set_menu_move_controls(info_button_menu_move)
	managers.raid_menu:register_on_escape_callback(nil)

	return true, nil
end

function MissionSelectionGui:_on_operation_selected(operation_data)
	local mission_id

	if operation_data.free_play then
		mission_id = operation_data.mission_id
	else
		self._selected_new_operation_index = operation_data.index
		mission_id = operation_data.value
	end

	local mission_data = operation_data.mission_data or tweak_data.operations:mission_data(mission_id)

	self._selected_job_id = mission_id
	self._selected_job_data = mission_data

	self:_update_soe_stamp(self._selected_job_id)
	self:_prepare_intel_image_for_selected_job()
	self._front_page_title:stop()
	self._front_page_title:animate(callback(self, self, "_animate_hide_front_page"))

	if self._secondary_paper_shown then
		self._secondary_paper:stop()
		self._secondary_paper:animate(callback(self, self, "_animate_hide_secondary_paper"))
	end

	local show_intel = self._intel_image_grid:num_photos() > 0

	self:_on_info_clicked(nil, true)
	self:_update_information_buttons(true, show_intel, true)
	self:_set_settings_enabled(true)

	local operation_tweak_data = tweak_data.operations:mission_data(mission_id)
	local icon_data = tweak_data.gui:get_full_gui_data(operation_tweak_data.icon_menu)

	self._primary_paper_mission_icon:set_image(icon_data.texture)
	self._primary_paper_mission_icon:set_texture_rect(unpack(icon_data.texture_rect))
	self._primary_paper_mission_icon:set_w(tweak_data.gui:icon_w(operation_tweak_data.icon_menu))
	self._primary_paper_mission_icon:set_h(tweak_data.gui:icon_h(operation_tweak_data.icon_menu))
	self._primary_paper_title:set_text(self:translate(operation_tweak_data.name_id, true))

	if self._selected_job_id ~= mission_id then
		self:_stop_mission_briefing_audio()

		if operation_tweak_data.short_audio_briefing_id then
			local audio_briefing_id = operation_tweak_data.short_audio_briefing_id

			managers.queued_tasks:queue("play_short_audio_briefing", self.play_short_audio_briefing, self, audio_briefing_id, 1, nil)
		end
	end

	if not operation_data.free_play then
		local difficulty_available, difficulty_completed = managers.progression:get_mission_progression(OperationsTweakData.JOB_TYPE_OPERATION, operation_data.value)

		self:set_difficulty_stepper_data(difficulty_available, difficulty_completed)
		self._primary_paper_subtitle:set_visible(false)
		self._primary_paper_difficulty_indicator:set_visible(true)
		self._primary_paper_difficulty_indicator:set_progress(difficulty_available, difficulty_completed)
	end
end

function MissionSelectionGui:_update_soe_stamp(job_id)
	if not self._soe_emblem then
		Application:error("[MissionSelectionGui:_update_soe_stamp] self._soe_emblem does not exist")

		return
	end

	local mis_tweak_data = tweak_data.operations.missions[job_id]

	if not mis_tweak_data then
		Application:error("[MissionSelectionGui:_update_soe_stamp] Mission id does not exist in operation tweakdata", job_id)

		return
	end

	local stamp_texture

	if mis_tweak_data.consumable then
		stamp_texture = tweak_data.gui.icons[MissionSelectionGui.PAPER_STAMP_ICON_CONSUMABLE]
	elseif mis_tweak_data.job_type == OperationsTweakData.JOB_TYPE_OPERATION then
		stamp_texture = tweak_data.gui.icons[MissionSelectionGui.PAPER_STAMP_ICON_OPERATION]
	else
		stamp_texture = tweak_data.gui.icons[MissionSelectionGui.PAPER_STAMP_ICON]
	end

	self._soe_emblem:set_image(stamp_texture.texture)
	self._soe_emblem:set_texture_rect(unpack(stamp_texture.texture_rect))
end

function MissionSelectionGui:_on_operation_list_selected()
	self:_bind_operation_list_controller_inputs()
end

function MissionSelectionGui:_on_operation_list_unselected()
	self:_bind_empty_slot_controller_inputs()
end

function MissionSelectionGui:_on_slot_clicked(slot_data)
	if self._selected_save_slot == slot_data.value then
		return
	end

	self:_update_information_buttons(true, true, true)
	self:_stop_mission_briefing_audio()

	self._selected_save_slot = slot_data.value

	self._operation_tutorialization_panel:get_engine_panel():stop()
	self._operation_tutorialization_panel:get_engine_panel():animate(callback(self, self, "_animate_hide_operation_tutorialization"))
	self:_set_settings_enabled(false)

	if managers.progression:operations_state() == ProgressionManager.OPERATIONS_STATE_LOCKED then
		if Network:is_server() then
			local message_text = utf8.to_upper(managers.localization:text("operations_locked_progression", {
				LEVEL = tostring(tweak_data.operations.progression.operations_unlock_level),
			}))

			self._start_disabled_message:set_text(message_text)
			self._start_disabled_message:set_visible(true)
			self._raid_start_button:set_visible(false)
		end

		self._selected_job_id = nil
		self._selected_new_operation_index = nil
		self._continue_slot_selected = nil

		self._front_page_icon:stop()
		self._front_page_icon:animate(callback(self, self, "_animate_change_front_page_data"), "op_blank_hd", "xp_events_missions_operations_category", "menu_mission_selected_mission_type_operation", "folder_mission_op", tweak_data.gui.colors.raid_light_gold)
		self._front_page_title:stop()
		self._front_page_title:animate(callback(self, self, "_animate_show_front_page"))
		self._operation_tutorialization_panel:get_engine_panel():stop()
		self._operation_tutorialization_panel:get_engine_panel():animate(callback(self, self, "_animate_show_operation_tutorialization"))
		self:_bind_locked_raid_controller_inputs()
	else
		if managers.progression:operations_state() == ProgressionManager.OPERATIONS_STATE_PENDING then
			local delay = 0.1

			if managers.controller:is_using_controller() then
				delay = 0.2
			end

			local skip_cinematics = managers.user:get_setting("skip_cinematics")

			if not skip_cinematics then
				managers.queued_tasks:queue("mission_screen_play_operation_intro_video", self._play_operations_intro_video, self, nil, delay, nil)
			end

			managers.progression:set_operations_state(ProgressionManager.OPERATIONS_STATE_UNLOCKED)
		end

		local save_slots = managers.raid_job:get_save_slots()

		if save_slots[self._selected_save_slot] then
			self:_on_save_selected()
		elseif slot_data.free_play then
			self:_on_free_play_selected()
		else
			self:_on_empty_slot_selected()
		end

		if Network:is_server() then
			self._start_disabled_message:set_visible(false)
			self._raid_start_button:set_visible(true)
			self._raid_start_button:enable()
		end
	end
end

function MissionSelectionGui:_on_slot_selected(slot_data)
	self:_on_slot_clicked(slot_data)
end

function MissionSelectionGui:set_current_slot_progress_report()
	local save_slots = managers.raid_job:get_save_slots()

	if not self._selected_save_slot or not save_slots[self._selected_save_slot] then
		return
	end

	local selected_job = save_slots[self._selected_save_slot].current_job
	local event_index = selected_job.events_index[selected_job.current_event]
	local event_data = selected_job.events[event_index]

	self._operation_progress:set_event(event_data)
end

function MissionSelectionGui:_on_save_selected()
	self._selected_job_id = nil
	self._selected_new_operation_index = nil
	self._free_play_selected = nil
	self._continue_slot_selected = self._selected_save_slot

	local current_slot_data = managers.raid_job:get_save_slots()[self._continue_slot_selected]
	local current_job = current_slot_data.current_job
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

	local operation_tweak_data = tweak_data.operations:mission_data(current_job.job_id)

	self._primary_paper_mission_icon:set_image(tweak_data.gui.icons[operation_tweak_data.icon_menu].texture)
	self._primary_paper_mission_icon:set_texture_rect(unpack(tweak_data.gui.icons[operation_tweak_data.icon_menu].texture_rect))
	self._primary_paper_mission_icon:set_w(tweak_data.gui:icon_w(operation_tweak_data.icon_menu))
	self._primary_paper_mission_icon:set_h(tweak_data.gui:icon_h(operation_tweak_data.icon_menu))
	self:_update_soe_stamp(current_job.job_id)

	local difficulty = tweak_data:difficulty_to_index(current_slot_data.difficulty)

	self._primary_paper_subtitle:set_visible(false)
	self._primary_paper_difficulty_indicator:set_visible(true)
	self._primary_paper_difficulty_indicator:set_active_difficulty(difficulty)

	if managers.raid_menu:is_pc_controller() and Network:is_server() then
		self._save_delete_button:animate_show()
	else
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

	local slot_list_move_controls = {
		right = "info_button",
	}

	self._slot_list:set_menu_move_controls(slot_list_move_controls)
end

function MissionSelectionGui:_on_free_play_selected()
	self._continue_slot_selected = nil
	self._selected_job_id = nil
	self._selected_new_operation_index = nil
	self._free_play_selected = true

	self._save_delete_button:animate_hide()
	self._front_page_icon:stop()
	self._front_page_icon:animate(callback(self, self, "_animate_change_front_page_data"), "op_free_play_hd", "menu_free_play_slot_title", "folder_mission", tweak_data.gui.colors.raid_light_red)
	self._front_page_title:stop()
	self._front_page_title:animate(callback(self, self, "_animate_show_front_page"))

	if self._secondary_paper_shown then
		self._secondary_paper:stop()
		self._secondary_paper:animate(callback(self, self, "_animate_hide_secondary_paper"))
	end

	self._operation_tutorialization_panel:get_engine_panel():stop()
	self._operation_tutorialization_panel:get_engine_panel():animate(callback(self, self, "_animate_show_operation_tutorialization"))
	self._operation_tutorialization_title:set_text(self:translate("free_play_tutorialization_title", true))
	self._operation_tutorialization_desc:set_text(self:translate("free_play_tutorialization_description", false))

	local slot_list_move_controls = {}

	self._slot_list:set_menu_move_controls(slot_list_move_controls)
	self:_bind_empty_slot_controller_inputs()
end

function MissionSelectionGui:_on_empty_slot_selected()
	self._continue_slot_selected = nil
	self._selected_job_id = nil
	self._free_play_selected = nil

	self._save_delete_button:animate_hide()
	self._front_page_icon:stop()
	self._front_page_icon:animate(callback(self, self, "_animate_change_front_page_data"), "op_blank_hd", "menu_mission_selected_mission_type_operation", "folder_mission_op", tweak_data.gui.colors.raid_light_gold)
	self._front_page_title:stop()
	self._front_page_title:animate(callback(self, self, "_animate_show_front_page"))

	if self._secondary_paper_shown then
		self._secondary_paper:stop()
		self._secondary_paper:animate(callback(self, self, "_animate_hide_secondary_paper"))
	end

	self._operation_tutorialization_panel:get_engine_panel():stop()
	self._operation_tutorialization_panel:get_engine_panel():animate(callback(self, self, "_animate_show_operation_tutorialization"))
	self._operation_tutorialization_title:set_text(self:translate("operations_tutorialization_title", true))
	self._operation_tutorialization_desc:set_text(self:translate("operations_tutorialization_description", false))

	local slot_list_move_controls = {}

	self._slot_list:set_menu_move_controls(slot_list_move_controls)
	self:_bind_empty_slot_controller_inputs()
end

function MissionSelectionGui:_on_locked_raid_clicked()
	self._info_button:disable()
	self._intel_button:disable()
	self._audio_button:disable()
	self._secondary_paper:stop()
	self._secondary_paper:animate(callback(self, self, "_animate_hide_secondary_paper"))
	self._front_page_title:stop()
	self._front_page_title:animate(callback(self, self, "_animate_show_front_page"))

	local raid_data = tweak_data.operations:mission_data(self._selected_job_id)

	self._front_page_icon:stop()
	self._front_page_icon:animate(callback(self, self, "_animate_change_front_page_data"), raid_data.icon_menu_big, raid_data.name_id, "folder_mission", tweak_data.gui.colors.raid_light_red)
	self._difficulty_warning_panel:get_engine_panel():stop()
	self._difficulty_warning_panel:get_engine_panel():animate(callback(self, self, "_animate_slide_out_difficulty_warning_message"))
	self:_set_settings_enabled(false)
	self:_bind_locked_raid_controller_inputs()
end

function MissionSelectionGui:_on_locked_bounty_clicked()
	self._info_button:disable()
	self._intel_button:disable()
	self._audio_button:disable()
	self._secondary_paper:stop()
	self._secondary_paper:animate(callback(self, self, "_animate_hide_secondary_paper"))
	self._front_page_title:stop()
	self._front_page_title:animate(callback(self, self, "_animate_show_front_page"))
	self._front_page_icon:stop()
	self._front_page_icon:animate(callback(self, self, "_animate_change_front_page_data"), "xp_events_missions_raid_bounty", "menu_mission_selected_mission_type_bounty_raid", "folder_mission", tweak_data.gui.colors.raid_light_red)
	self._difficulty_warning_panel:get_engine_panel():stop()
	self._difficulty_warning_panel:get_engine_panel():animate(callback(self, self, "_animate_slide_out_difficulty_warning_message"))
	self:_set_settings_enabled(false)
	self:_bind_locked_raid_controller_inputs()
end

function MissionSelectionGui:_on_info_clicked(secondary_paper_callback, force)
	if self._info_button:active() and force ~= true then
		return
	end

	if self._selected_job_id then
		self._front_page_title:stop()
		self._front_page_title:animate(callback(self, self, "_animate_hide_front_page"))

		if self._secondary_paper_shown then
			self._secondary_paper:stop()
			self._secondary_paper:animate(callback(self, self, "_animate_hide_secondary_paper"))
		end

		local description_id = self._selected_job_data.progress_text_id or self._selected_job_data.briefing_id
		local description_text = self:translate(description_id)

		if self._selected_job_data.stealth_description then
			description_text = description_text .. "\n\n" .. self:translate(self._selected_job_data.stealth_description)
		end

		local clbk = callback(self._mission_description, self._mission_description, "set_text", description_text)

		self._primary_paper:stop()
		self._primary_paper:animate(callback(self, self, "_animate_change_primary_paper_control"), clbk, self._mission_description)

		if self._list_tabs._items[self._list_tabs._selected_item_idx]._name ~= "tab_operation" then
			self:_set_settings_enabled(true)
		end

		self._info_button:set_active(true)
		self._intel_button:set_active(false)
		self._audio_button:set_active(false)
	elseif self._continue_slot_selected then
		self._front_page_title:stop()
		self._front_page_title:animate(callback(self, self, "_animate_hide_front_page"))

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

		if first_n_missions then
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
		mission = self._selected_job_id or save_data.job_id,
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

	if audio_briefing_id and audio_briefing_id ~= "" then
		self._briefing_audio = managers.menu_component:post_event(audio_briefing_id)
	end
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
	self:_check_difficulty_warning()
end

function MissionSelectionGui:data_source_difficulty_stepper()
	local difficulties = {}

	table.insert(difficulties, {
		info = "difficulty_1",
		text = self:translate("menu_difficulty_1", true),
		value = "difficulty_1",
	})
	table.insert(difficulties, {
		info = "difficulty_2",
		text = self:translate("menu_difficulty_2", true),
		value = "difficulty_2",
	})
	table.insert(difficulties, {
		info = "difficulty_3",
		text = self:translate("menu_difficulty_3", true),
		value = "difficulty_3",
	})
	table.insert(difficulties, {
		info = "difficulty_4",
		text = self:translate("menu_difficulty_4", true),
		value = "difficulty_4",
	})

	return difficulties
end

function MissionSelectionGui:set_difficulty_stepper_data(difficulty_available, difficulty_completed)
	difficulty_available = difficulty_available or tweak_data:number_of_difficulties()
	difficulty_completed = difficulty_completed or 0

	local difficulties = {}

	for i = 1, tweak_data:number_of_difficulties() do
		local difficulty_available = i <= difficulty_available

		table.insert(difficulties, difficulty_available)
	end

	self._difficulty_stepper:set_disabled_items(difficulties)
	self:_check_difficulty_warning()
end

function MissionSelectionGui:_check_difficulty_warning()
	if self._selected_job_id and tweak_data.operations.missions[self._selected_job_id].consumable then
		self._difficulty_warning_panel:get_engine_panel():stop()
		self._difficulty_warning_panel:get_engine_panel():animate(callback(self, self, "_animate_slide_out_difficulty_warning_message"))
		self._raid_start_button:enable()
		self._difficulty_warning:stop()
		self._difficulty_warning:animate(callback(self, self, "_animate_hide_difficulty_warning_message"))
		Application:info("[MissionSelectionGui:_check_difficulty_warning] consumable mission, dont care, hiding")

		return
	end

	if not self._selected_job_id or not managers.progression:mission_unlocked(tweak_data.operations.missions[self._selected_job_id].job_type, self._selected_job_id) then
		Application:info("[MissionSelectionGui:_check_difficulty_warning] not unlocked, do nothing")

		return
	end

	local difficulty_available, difficulty_completed = managers.progression:get_mission_progression(tweak_data.operations.missions[self._selected_job_id].job_type, self._selected_job_id)
	local difficulty = tweak_data:difficulty_to_index(self._difficulty_stepper:get_value())
	local req_progress = difficulty_available < difficulty

	if req_progress then
		local message = managers.localization:text("raid_difficulty_warning", {
			NEEDED_DIFFICULTY = managers.localization:text("menu_difficulty_" .. tostring(difficulty - 1)),
			TARGET_DIFFICULTY = managers.localization:text("menu_difficulty_" .. tostring(difficulty)),
		})

		self._difficulty_warning_panel:get_engine_panel():stop()
		self._difficulty_warning_panel:get_engine_panel():animate(callback(self, self, "_animate_slide_in_difficulty_warning_message"), message)
		self._raid_start_button:disable()
		self._difficulty_warning:stop()
		self._difficulty_warning:animate(callback(self, self, "_animate_set_difficulty_warning_message"), message)

		if self._current_mission_type == "raids" then
			self:_bind_locked_raid_controller_inputs()
		elseif self._current_mission_type == "operations" and self._current_display == MissionSelectionGui.DISPLAY_SECOND then
			self:_bind_locked_operation_list_controller_inputs()
		elseif self._current_mission_type == "operations" and self._current_display == MissionSelectionGui.DISPLAY_FIRST then
			self:_bind_operation_list_controller_inputs()
		end
	else
		self._difficulty_warning_panel:get_engine_panel():stop()
		self._difficulty_warning_panel:get_engine_panel():animate(callback(self, self, "_animate_slide_out_difficulty_warning_message"))
		self._raid_start_button:enable()
		self._difficulty_warning:stop()
		self._difficulty_warning:animate(callback(self, self, "_animate_hide_difficulty_warning_message"))

		if self._current_mission_type == "raids" then
			self:_bind_raid_controller_inputs()
		elseif self._current_mission_type == "operations" then
			self:_bind_operation_list_controller_inputs()
		end
	end
end

function MissionSelectionGui:_animate_set_difficulty_warning_message(o, message)
	local fade_out_duration = 0.2
	local t = (1 - self._difficulty_warning:alpha()) * fade_out_duration

	if self._difficulty_warning:text() ~= message then
		while t < fade_out_duration do
			local dt = coroutine.yield()

			t = t + dt

			local current_alpha = Easing.quartic_in_out(t, 1, -1, fade_out_duration)

			self._difficulty_warning:set_alpha(current_alpha)
		end

		self._difficulty_warning:set_alpha(0)
		self._difficulty_warning:set_text(message)

		local _, _, _, h = self._difficulty_warning:text_rect()

		self._difficulty_warning:set_h(h)
	end

	local fade_in_duration = 0.2

	t = self._difficulty_warning:alpha() * fade_in_duration

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 1, fade_in_duration)

		self._difficulty_warning:set_alpha(current_alpha)
	end

	self._difficulty_warning:set_alpha(1)
end

function MissionSelectionGui:_animate_hide_difficulty_warning_message(o)
	local fade_out_duration = 0.2
	local t = (1 - self._difficulty_warning:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 1, -1, fade_out_duration)

		self._difficulty_warning:set_alpha(current_alpha)
	end

	self._difficulty_warning:set_alpha(0)
end

function MissionSelectionGui:_animate_slide_in_difficulty_warning_message(o, message)
	local slide_duration = 0.4

	self._difficulty_warning_slide_animation_t = self._difficulty_warning_slide_animation_t or 0

	local t = self._difficulty_warning_slide_animation_t * slide_duration
	local current_warning_text = self._difficulty_warning:text()

	self._difficulty_warning:set_text(message)

	local _, _, _, warning_text_h = self._difficulty_warning:text_rect()

	self._difficulty_warning:set_text(current_warning_text)

	local difficulty_control_index = table.index_of(self._settings_controls, self._difficulty_stepper)

	while t < slide_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_warning_bottom = Easing.quartic_in_out(t, 0, MissionSelectionGui.SETTINGS_PADDING + warning_text_h, slide_duration)

		self._difficulty_warning:set_bottom(current_warning_bottom)

		for index, control in pairs(self._settings_controls) do
			if control ~= self._difficulty_stepper and control:y() > self._difficulty_stepper:y() then
				local control_default_y = self._difficulty_stepper:bottom() + (index - difficulty_control_index) * (MissionSelectionGui.SETTINGS_PADDING + 32) - 32
				local current_control_y = Easing.quartic_in_out(t, control_default_y, warning_text_h + 32, slide_duration)

				control:set_y(current_control_y)
			end
		end

		self._difficulty_warning_slide_animation_t = t / slide_duration
	end

	self._difficulty_warning_slide_animation_t = 1
end

function MissionSelectionGui:_animate_slide_out_difficulty_warning_message(o)
	local slide_duration = 0.4

	self._difficulty_warning_slide_animation_t = self._difficulty_warning_slide_animation_t or 0

	local t = (1 - self._difficulty_warning_slide_animation_t) * slide_duration
	local _, _, _, warning_text_h = self._difficulty_warning:text_rect()
	local difficulty_control_index = table.index_of(self._settings_controls, self._difficulty_stepper)

	while t < slide_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_warning_bottom = Easing.quartic_in_out(t, MissionSelectionGui.SETTINGS_PADDING + warning_text_h, -(MissionSelectionGui.SETTINGS_PADDING + warning_text_h), slide_duration)

		self._difficulty_warning:set_bottom(current_warning_bottom)

		for index, control in pairs(self._settings_controls) do
			if control ~= self._difficulty_stepper and control:y() > self._difficulty_stepper:y() then
				local control_default_y = self._difficulty_stepper:bottom() + (index - difficulty_control_index) * (MissionSelectionGui.SETTINGS_PADDING + 32) - 32
				local current_control_y = Easing.quartic_in_out(t, control_default_y + warning_text_h + 32, -warning_text_h - 32, slide_duration)

				control:set_y(current_control_y)
			end
		end

		self._difficulty_warning_slide_animation_t = t / slide_duration
	end

	self._difficulty_warning_slide_animation_t = 0
end

function MissionSelectionGui:_on_permission_selected(data)
	return
end

function MissionSelectionGui:data_source_permission_stepper()
	local permissions = {}

	table.insert(permissions, {
		info = "public",
		text = self:translate("menu_permission_public", true),
		value = "public",
	})
	table.insert(permissions, {
		info = "friends_only",
		text = self:translate("menu_permission_friends", true),
		value = "friends_only",
	})
	table.insert(permissions, {
		info = "private",
		text = self:translate("menu_permission_private", true),
		value = "private",
	})

	return permissions
end

function MissionSelectionGui:_on_toggle_drop_in(button, control, value)
	return
end

function MissionSelectionGui:_on_toggle_team_ai(button, control, value)
	return
end

function MissionSelectionGui:_on_toggle_vote_kick(button, control, value)
	if Network:is_client() then
		return
	end

	if value then
		Global.game_settings.kick_option = 2
	else
		Global.game_settings.kick_option = 1
	end

	managers.vote:sync_server_kick_option_with_peers()
end

function MissionSelectionGui:_raid_list_data_source()
	local raid_list = {}
	local consumable_list = {}
	local non_consumable_list = {}
	local debug_list = {}

	if managers.progression:mission_progression_completed() then
		local mission_name = managers.raid_job:bounty_job_name()
		local mission_data = deep_clone(managers.raid_job:bounty_job_data())
		local item_text = self:translate(mission_data.name_id)

		table.insert(raid_list, {
			bounty = true,
			breadcrumb = {
				category = BreadcrumbManager.CATEGORY_NEW_RAID,
				identifiers = {
					mission_name,
				},
			},
			icon = tweak_data.gui:get_full_gui_data("missions_raid_bounty_menu"),
			mission_data = mission_data,
			selected_color = tweak_data.gui.colors.raid_gold,
			text = item_text,
			unlocked = not self._bounty_completed,
			value = mission_name,
		})
	end

	for raid_index, mission_name in pairs(tweak_data.operations:get_raids_index()) do
		local mission_data = tweak_data.operations:mission_data(mission_name)

		if mission_data then
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
						consumable = true,
						icon = item_icon,
						selected_color = tweak_data.gui.colors.raid_gold,
						text = item_text,
						unlocked = true,
						value = mission_name,
					})
				end
			else
				table.insert(mission_data.debug and debug_list or non_consumable_list, {
					breadcrumb = {
						category = BreadcrumbManager.CATEGORY_NEW_RAID,
						identifiers = {
							mission_name,
						},
					},
					color = tweak_data.gui.colors.raid_white,
					debug = mission_data.debug,
					icon = item_icon,
					index = raid_index,
					selected_color = tweak_data.gui.colors.raid_red,
					text = item_text,
					unlocked = mission_data.debug or managers.progression:mission_unlocked(mission_data.job_type, mission_name),
					value = mission_name,
				})
			end
		else
			Application:error("[MissionSelectionGui:_raid_list_data_source] mission_name", mission_name, "does not exist as a mission data!")
		end
	end

	table.sort(non_consumable_list, function(l, r)
		if l.unlocked and not l.debug and not r.unlocked then
			return true
		elseif not l.unlocked and r.unlocked and not r.debug then
			return false
		end

		return l.index < r.index and not l.debug
	end)

	for _, mission in pairs(consumable_list) do
		table.insert(raid_list, mission)
	end

	for _, mission in pairs(non_consumable_list) do
		table.insert(raid_list, mission)
	end

	for _, mission in pairs(debug_list) do
		table.insert(raid_list, mission)
	end

	return raid_list
end

function MissionSelectionGui:_operation_list_data_source()
	local operation_list = {}

	if self._free_play_selected then
		for _, mission_name in ipairs(tweak_data.operations:get_operations_index()) do
			local mission_data = tweak_data.operations:mission_data(mission_name)

			if mission_data.allow_free_play then
				for _, events in ipairs(mission_data.events_index_template) do
					local event_id = events[math.random(1, #events)]
					local event_data = mission_data.events[event_id]

					event_data.job_id = event_data.mission_id

					local item_title = self:translate(event_data.name_id)
					local item_description = self:translate(event_data.progress_text_id)
					local item_icon = tweak_data.gui:get_full_gui_data(event_data.icon_menu)

					table.insert(operation_list, {
						description = item_description,
						free_play = true,
						icon = item_icon,
						mission_data = event_data,
						mission_id = event_data.mission_id,
						title = item_title,
						value = mission_name,
					})
				end
			end
		end
	else
		for index, mission_name in pairs(tweak_data.operations:get_operations_index()) do
			local mission_data = tweak_data.operations:mission_data(mission_name)
			local item_title = self:translate(mission_data.name_id)
			local item_description = self:translate(mission_data.briefing_id)
			local item_icon = tweak_data.gui:get_full_gui_data(mission_data.icon_menu)

			table.insert(operation_list, {
				description = item_description,
				icon = item_icon,
				index = index,
				mission_data = mission_data,
				title = item_title,
				value = mission_name,
			})
		end
	end

	return operation_list
end

function MissionSelectionGui:_slot_list_data_source()
	local current_save_slots = managers.raid_job:get_save_slots()
	local slot_list = {}
	local free_play_slot = {
		free_play = true,
		icon = tweak_data.gui:get_full_gui_data("op_free_play_lq"),
		selected_color = tweak_data.gui.colors.raid_gold,
		text = self:translate("menu_free_play_slot_title"),
		unlocked = true,
		value = 0,
	}

	table.insert(slot_list, free_play_slot)

	for i = 1, 5 do
		local current_slot = {
			value = i,
		}

		if current_save_slots[i] then
			local current_job = current_save_slots[i].current_job
			local total_events = #current_job.events_index
			local current_event = math.clamp(current_job.current_event, 1, total_events)
			local mission_progress_fraction = " (" .. current_event .. "/" .. total_events .. ")"
			local mission_data = tweak_data.operations:mission_data(current_job.job_id)
			local title_text = self:translate(mission_data.name_id) .. mission_progress_fraction

			current_slot.text = title_text
			current_slot.icon = tweak_data.gui:get_full_gui_data(mission_data.icon_menu)
			current_slot.difficulty = current_save_slots[i].difficulty
			current_slot.mission_data = mission_data
			current_slot.unlocked = true
		else
			current_slot.text = self:translate("menu_empty_save_slot_title")
			current_slot.icon = tweak_data.gui:get_full_gui_data("op_empty_slot_lq")
			current_slot.empty = true
		end

		table.insert(slot_list, current_slot)
	end

	return slot_list
end

function MissionSelectionGui:_continue_operation()
	if self._continue_slot_selected then
		managers.raid_job:continue_operation(self._continue_slot_selected)
	end

	managers.raid_menu:close_all_menus()
	managers.menu:input_enabled(false)
end

function MissionSelectionGui:_start_job(job_id, job_data)
	Application:info("[MissionSelectionGui] _start_job", job_id)

	job_data = job_data or tweak_data.operations.missions[job_id]

	local difficulty = self._difficulty_stepper:get_value()
	local team_ai = self._team_ai_checkbox:get_value()
	local event_enabled = self._event_display and self._event_display:get_value()

	if job_data.job_type == OperationsTweakData.JOB_TYPE_OPERATION then
		event_enabled = false
	end

	local permission = Global.DEFAULT_PERMISSION
	local drop_in_allowed = true

	tweak_data:set_difficulty(difficulty)

	Global.game_settings.team_ai = team_ai
	Global.game_settings.selected_team_ai = team_ai
	Global.player_manager.game_settings_team_ai = team_ai
	Global.player_manager.game_settings_difficulty = difficulty
	Global.game_settings.event_enabled = event_enabled

	if not Global.game_settings.single_player then
		permission = self._permission_stepper:get_value()
		drop_in_allowed = self._drop_in_checkbox:get_value()
		Global.game_settings.permission = permission
		Global.game_settings.drop_in_allowed = drop_in_allowed
		Global.player_manager.game_settings_permission = permission
		Global.player_manager.game_settings_drop_in_allowed = drop_in_allowed
	end

	if Network:is_server() then
		managers.network:session():chk_server_joinable_state()
		managers.network:update_matchmake_attributes()

		if event_enabled then
			managers.event_system:activate_current_event()
		end

		if self._settings_selected.difficulty ~= Global.game_settings.difficulty or self._settings_selected.permission ~= Global.game_settings.permission or self._settings_selected.drop_in_allowed ~= Global.game_settings.drop_in_allowed or self._settings_selected.team_ai ~= Global.game_settings.team_ai then
			managers.savefile:save_game(managers.savefile:get_save_progress_slot())
		end
	end

	managers.raid_job._next_event_index = nil

	managers.raid_job:set_selected_job(job_id, job_data)
	managers.raid_menu:close_all_menus()
end

function MissionSelectionGui:_select_mission(job_id)
	Application:info("[MissionSelectionGui] _select_mission", job_id, "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")

	self._selected_job_id = job_id

	local job_data = tweak_data.operations:mission_data(job_id)
	local description = managers.localization:text(job_data.briefing_id)
	local mission_title = managers.localization:text("menu_mission_selected_title")
end

function MissionSelectionGui:_select_slot(slot)
	self._selected_operation_save_slot = slot
end

function MissionSelectionGui:_animate_change_primary_paper_control(control, mid_callback, new_active_control)
	local fade_out_duration = 0.2
	local t

	if self._active_primary_paper_control then
		t = (1 - self._active_primary_paper_control:alpha()) * fade_out_duration
	else
		t = 0
	end

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

	t = self._active_primary_paper_control:alpha() * fade_out_duration

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

		self._right_panel:set_alpha(setting_alpha)

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

	self._right_panel:set_alpha(0)
	self._right_panel:set_visible(false)
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

	self._right_panel:set_visible(true)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local setting_alpha = Easing.cubic_in_out(t, 0, 1, duration)

		self._right_panel:set_alpha(setting_alpha)

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

	self._right_panel:set_alpha(1)
	self._secondary_paper_panel:set_x(self._primary_paper_panel:x())
	self._secondary_paper_panel:set_rotation(MissionSelectionGui.BACKGROUND_PAPER_ROTATION)
	self._secondary_paper_panel:set_w(self._primary_paper_panel:w() * MissionSelectionGui.BACKGROUND_PAPER_SCALE)
	self._secondary_paper_panel:set_h(self._primary_paper_panel:h() * MissionSelectionGui.BACKGROUND_PAPER_SCALE)
	self._secondary_paper:set_color(MissionSelectionGui.BACKGROUND_PAPER_COLOR)
	self._secondary_paper_panel:set_alpha(MissionSelectionGui.BACKGROUND_PAPER_ALPHA)

	self._paper_animation_t = 0
end

function MissionSelectionGui:_animate_show_front_page(o)
	self._front_page_movement_t = self._front_page_movement_t or 0

	local fade_in_duration = 0.4
	local t = self._front_page_movement_t * fade_in_duration

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_out(t, 0, 1, fade_in_duration / 2)

		self._front_page_panel:set_alpha(current_alpha)

		local papers_alpha = Easing.quartic_in(t, 1, -1, fade_in_duration)

		self._primary_paper_panel:set_alpha(papers_alpha)
		self._secondary_paper_panel:set_alpha(papers_alpha)

		local current_offset = Easing.quartic_out(t, -65, 65, fade_in_duration)

		self._front_page_panel:set_y(current_offset)

		local current_rotation = Easing.quartic_out(t, -6, 6, fade_in_duration)

		self._front_page_panel:set_rotation(current_rotation)

		self._front_page_movement_t = t / fade_in_duration
	end

	self._primary_paper_panel:set_alpha(0)
	self._secondary_paper_panel:set_alpha(0)
	self._front_page_panel:set_alpha(1)

	self._front_page_movement_t = 1
end

function MissionSelectionGui:_animate_hide_front_page(o)
	self._front_page_movement_t = self._front_page_movement_t or 0

	local fade_out_duration = 0.45
	local t = (1 - self._front_page_movement_t) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quadratic_in(t, 1, -1, fade_out_duration / 2)

		self._front_page_panel:set_alpha(current_alpha)

		local papers_alpha = Easing.quartic_out(t, 0, 1, fade_out_duration / 2)

		self._primary_paper_panel:set_alpha(papers_alpha)
		self._secondary_paper_panel:set_alpha(papers_alpha)

		local current_offset = Easing.quartic_out(t, 0, -65, fade_out_duration)

		self._front_page_panel:set_y(current_offset)

		local current_rotation = Easing.quartic_out(t, 0, -6, fade_out_duration)

		self._front_page_panel:set_rotation(current_rotation)

		self._front_page_movement_t = 1 - t / fade_out_duration
	end

	self._primary_paper_panel:set_alpha(1)
	self._secondary_paper_panel:set_alpha(1)
	self._front_page_panel:set_alpha(0)
	self._front_page_content_panel:set_alpha(0)

	self._front_page_movement_t = 0
end

function MissionSelectionGui:_animate_change_front_page_data(o, icon, text_id, folder_image, text_color, x_offset)
	local fade_out_duration = 0.2
	local t = (1 - self._front_page_content_panel:alpha()) * fade_out_duration
	local changing_front_page_image = false

	x_offset = x_offset or 0

	if self._front_page_icon_id ~= icon or self._front_page_text_id ~= text_id or folder_image ~= self._current_front_page_image then
		while t < fade_out_duration do
			local dt = coroutine.yield()

			t = t + dt

			local current_alpha = Easing.quartic_in_out(t, 1, -1, fade_out_duration)

			self._front_page_content_panel:set_alpha(current_alpha)

			if folder_image and folder_image ~= self._current_front_page_image then
				self._front_page_image:set_alpha(current_alpha)
			end
		end

		self._front_page_content_panel:set_alpha(0)

		if folder_image ~= self._current_front_page_image then
			self._front_page_image:set_alpha(0)

			local texture_rect = tweak_data.gui.icons[folder_image].texture_rect

			self._front_page_image:set_image(tweak_data.gui.icons[folder_image].texture)
			self._front_page_image:set_texture_rect(unpack(texture_rect))
			self._front_page_image:set_w(texture_rect[3])
			self._front_page_image:set_h(texture_rect[4])

			self._current_front_page_image = folder_image
			changing_front_page_image = true
		end

		if icon then
			self._front_page_icon:set_image(tweak_data.gui.icons[icon].texture)
			self._front_page_icon:set_texture_rect(unpack(tweak_data.gui.icons[icon].texture_rect))

			self._front_page_icon_id = icon
		end

		self._front_page_title:set_text(self:translate(text_id, true))
		self:_fit_front_page_title()

		if text_color then
			self._front_page_title:set_color(text_color)
			self._front_page_icon:set_color(text_color)
		end

		self._front_page_text_id = text_id
	end

	local front_page_rotation = self._front_page_content_panel:rotation()

	self._front_page_content_panel:set_rotation(0)
	self._front_page_icon:set_center_x(self._front_page_panel:w() / 2 + x_offset)
	self._front_page_title:set_center_x(self._front_page_icon:center_x())
	self._front_page_content_panel:set_rotation(front_page_rotation)

	t = self._front_page_content_panel:alpha() * fade_out_duration

	local fade_in_duration = 0.2

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 1, fade_in_duration)

		self._front_page_content_panel:set_alpha(current_alpha)

		if changing_front_page_image then
			self._front_page_image:set_alpha(current_alpha)
		end
	end

	self._front_page_content_panel:set_alpha(1)
	self._front_page_image:set_alpha(1)
end

function MissionSelectionGui:_fit_front_page_title()
	local default_font_size = tweak_data.gui.font_sizes.title
	local font_sizes = {}

	for index, size in pairs(tweak_data.gui.font_sizes) do
		if size <= default_font_size then
			table.insert(font_sizes, size)
		end
	end

	table.sort(font_sizes)

	for i = #font_sizes, 1, -1 do
		self._front_page_title:set_font_size(font_sizes[i])

		local _, _, w, _ = self._front_page_title:text_rect()

		if w <= self._front_page_title:w() then
			break
		end
	end
end

function MissionSelectionGui:_animate_show_operation_tutorialization(panel)
	local fade_out_duration = 0.15
	local t = (1 - self._right_panel:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 1, -1, fade_out_duration)

		self._right_panel:set_alpha(current_alpha)
	end

	self._right_panel:set_alpha(0)
	self._right_panel:set_visible(false)

	local fade_in_duration = 0.15

	t = panel:alpha() * fade_in_duration

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 1, fade_out_duration)

		panel:set_alpha(current_alpha)
	end

	panel:set_alpha(1)
end

function MissionSelectionGui:_animate_hide_operation_tutorialization(panel)
	local fade_out_duration = 0.15
	local t = (1 - panel:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 1, -1, fade_out_duration)

		panel:set_alpha(current_alpha)
	end

	panel:set_alpha(0)
	self._right_panel:set_visible(true)

	local fade_in_duration = 0.15

	t = self._right_panel:alpha() * fade_in_duration

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 1, fade_out_duration)

		self._right_panel:set_alpha(current_alpha)
	end

	self._right_panel:set_alpha(1)
end

function MissionSelectionGui:back_pressed()
	if self._current_display == MissionSelectionGui.DISPLAY_FIRST then
		if managers.controller:is_using_controller() then
			managers.raid_menu:register_on_escape_callback(nil)
			managers.raid_menu:on_escape()
		end
	else
		managers.raid_menu:register_on_escape_callback(nil)
		self:_display_first_screen()

		return true, nil
	end
end

function MissionSelectionGui:_unselect_left_column()
	self._raid_list:set_selected(false)
	self._new_operation_list:set_selected(false)
	self._list_tabs:set_selected(false)
end

function MissionSelectionGui:_unselect_middle_column()
	self._info_button:set_selected(false)
	self._intel_button:set_selected(false)
	self._audio_button:set_selected(false)
	self._intel_image_grid:set_selected(false)
end

function MissionSelectionGui:_unselect_right_column()
	self._difficulty_stepper:set_selected(false)
	self._team_ai_checkbox:set_selected(false)

	if not Global.game_settings.single_player then
		self._permission_stepper:set_selected(false)
		self._drop_in_checkbox:set_selected(false)
	end
end

function MissionSelectionGui:bind_controller_inputs()
	self:_bind_raid_controller_inputs()
end

function MissionSelectionGui:_bind_raid_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "_on_list_tabs_left"),
			key = Idstring("menu_controller_shoulder_left"),
			label = "",
		},
		{
			callback = callback(self, self, "_on_list_tabs_right"),
			key = Idstring("menu_controller_shoulder_right"),
		},
		{
			callback = callback(self, self, "_on_column_left"),
			key = Idstring("menu_controller_trigger_left"),
		},
		{
			callback = callback(self, self, "_on_column_right"),
			key = Idstring("menu_controller_trigger_right"),
		},
	}

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
			"menu_legend_mission_raids",
			"menu_legend_mission_operations",
			"menu_legend_mission_column",
		},
		keyboard = {
			{
				callback = callback(self, self, "_on_legend_pc_back", nil),
				key = "footer_back",
			},
		},
	}

	if Network:is_server() then
		table.insert(legend.controller, "menu_legend_mission_start_raid")
	end

	self:set_legend(legend)
end

function MissionSelectionGui:_bind_locked_raid_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "_on_list_tabs_left"),
			key = Idstring("menu_controller_shoulder_left"),
			label = "",
		},
		{
			callback = callback(self, self, "_on_list_tabs_right"),
			key = Idstring("menu_controller_shoulder_right"),
		},
		{
			callback = callback(self, self, "_on_column_left"),
			key = Idstring("menu_controller_trigger_left"),
		},
		{
			callback = callback(self, self, "_on_column_right"),
			key = Idstring("menu_controller_trigger_right"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_mission_raids",
			"menu_legend_mission_operations",
			"menu_legend_mission_column",
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

function MissionSelectionGui:_bind_save_slot_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "_on_list_tabs_left"),
			key = Idstring("menu_controller_shoulder_left"),
			label = "",
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
				callback = callback(self, self, "_on_legend_pc_back", nil),
				key = "footer_back",
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
			callback = callback(self, self, "_on_list_tabs_left"),
			key = Idstring("menu_controller_shoulder_left"),
			label = "",
		},
		{
			callback = callback(self, self, "_on_list_tabs_right"),
			key = Idstring("menu_controller_shoulder_right"),
		},
		{
			callback = callback(self, self, "_on_column_left"),
			key = Idstring("menu_controller_trigger_left"),
		},
		{
			callback = callback(self, self, "_on_column_right"),
			key = Idstring("menu_controller_trigger_right"),
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
			"menu_legend_mission_column",
		},
		keyboard = {
			{
				callback = callback(self, self, "_on_legend_pc_back", nil),
				key = "footer_back",
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
			callback = callback(self, self, "_on_column_left"),
			key = Idstring("menu_controller_trigger_left"),
		},
		{
			callback = callback(self, self, "_on_column_right"),
			key = Idstring("menu_controller_trigger_right"),
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
			"menu_legend_mission_column",
		},
		keyboard = {
			{
				callback = callback(self, self, "_on_legend_pc_back", nil),
				key = "footer_back",
			},
		},
	}

	if Network:is_server() then
		table.insert(legend.controller, "menu_legend_mission_start_operation")
	end

	self:set_legend(legend)
end

function MissionSelectionGui:_bind_locked_operation_list_controller_inputs()
	local bindings = {}

	self:set_controller_bindings(bindings, true)

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

function MissionSelectionGui:_on_list_tabs_left()
	if self._selected_tab == "left" or not self._list_tabs:enabled() then
		return
	end

	self:_unselect_right_column()
	self:_unselect_middle_column()
	self._list_tabs:_move_left()

	self._selected_column = MissionSelectionGui.COLUMN_MISSIONS
	self._selected_tab = "left"

	return true
end

function MissionSelectionGui:_on_list_tabs_right()
	if self._selected_tab == "right" or not self._list_tabs:enabled() then
		return
	end

	self:_unselect_right_column()
	self:_unselect_middle_column()
	self._list_tabs:_move_right()

	self._selected_column = MissionSelectionGui.COLUMN_MISSIONS
	self._selected_tab = "right"

	return true
end

function MissionSelectionGui:_on_column_left()
	if self._selected_column == MissionSelectionGui.COLUMN_MISSIONS then
		return true
	end

	self._selected_column = self._selected_column - 1

	if self._selected_column == MissionSelectionGui.COLUMN_MISSIONS then
		self:_unselect_middle_column()

		if self._selected_tab == "right" then
			self._new_operation_list:set_selected(true)
		else
			self._list_tabs:set_selected(true)
		end
	elseif self._selected_column == MissionSelectionGui.COLUMN_INFO then
		self:_unselect_right_column()
		self._info_button:set_selected(true)
	end

	return true
end

function MissionSelectionGui:_on_column_right()
	if self._selected_column == MissionSelectionGui.COLUMN_SETTINGS then
		return true
	end

	if self._selected_tab == "right" and self._current_display == MissionSelectionGui.DISPLAY_FIRST then
		return
	end

	self._selected_column = self._selected_column + 1

	if self._selected_column == MissionSelectionGui.COLUMN_INFO then
		self:_unselect_left_column()
		self._info_button:set_selected(true)
	elseif self._selected_column == MissionSelectionGui.COLUMN_SETTINGS and not self._secondary_paper_shown then
		self:_unselect_middle_column()
		self._difficulty_stepper:set_selected(true)
	end

	return true
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

function MissionSelectionGui:_check_consumables_achievement()
	if managers.consumable_missions:is_all_missions_unlocked() then
		managers.achievment:award("outlaw_librarian")
	end
end

function MissionSelectionGui:_update_information_buttons(show_info, show_intel, show_audio)
	local icons_list = {}

	if show_info ~= nil then
		if show_info == true then
			self._info_button:enable()
			self._info_button:show()
			table.insert(icons_list, self._info_button)
		else
			self._info_button:set_active(false)
			self._info_button:disable()
			self._info_button:hide()
		end
	end

	if show_intel ~= nil then
		if show_intel == true then
			self._intel_button:enable()
			self._intel_button:show()
			table.insert(icons_list, self._intel_button)
		else
			self._intel_button:set_active(false)
			self._intel_button:disable()
			self._intel_button:hide()
		end
	end

	if show_audio ~= nil then
		if show_audio == true then
			self._audio_button:enable()
			self._audio_button:show()
			table.insert(icons_list, self._audio_button)
		else
			self._audio_button:set_active(false)
			self._audio_button:disable()
			self._audio_button:hide()
		end
	end

	local x = self._info_buttons_panel:w() / (#icons_list + 1)

	for i, v in ipairs(icons_list) do
		v:set_center_x(x * i)
	end
end

function MissionSelectionGui:_layout_mission_card()
	self._effects_list = {}
	self._active_card_panel = self._right_panel:panel({
		name = "card_panel",
		visible = false,
	})

	local width = 190
	local height = width * 1.4
	local card_y = self._right_panel:h() - height

	self._active_card_details = self._active_card_panel:create_custom_control(RaidGUIControlCardDetails, {
		card_h = height,
		card_w = width,
		card_x = 0,
		card_y = 0,
		h = height,
		info_padding = 8,
		name = "card_details",
		show_rarity = false,
		show_type = false,
		show_xp = false,
		visible = true,
		w = self._right_panel:w(),
		y = card_y,
	})

	self._active_card_details:set_card_details("empty")
	self._active_card_details:set_control_mode(RaidGUIControlCardDetails.MODE_VIEW_ONLY)
end
