MissionJoinGui = MissionJoinGui or class(RaidGuiBase)
MissionJoinGui.FILTER_WIDTH = 470
MissionJoinGui.FILTER_HEIGHT = 20
MissionJoinGui.FILTER_BUTTON_W = 20
MissionJoinGui.FILTER_BUTTON_H = 20
MissionJoinGui.FILTER_STEPPER_W = 260
MissionJoinGui.FILTER_FONT_SIZE = 19
MissionJoinGui.SERVER_TABLE_ROW_HEIGHT = 42

function MissionJoinGui:init(ws, fullscreen_ws, node, component_name)
	MissionJoinGui.super.init(self, ws, fullscreen_ws, node, component_name)
end

function MissionJoinGui:close()
	MissionJoinGui.super.close(self)
	managers.network.matchmake:register_callback("search_lobby", nil)
	managers.savefile:save_setting()
	self:_remove_active_controls()
end

function MissionJoinGui:_set_initial_data()
	self.filters = {}
	self._tweak_data = tweak_data.gui.server_browser
	self._max_active_server_jobs = self._tweak_data.max_active_server_jobs
	self._active_jobs = {}
	self._active_server_jobs = {}
	self._server_list_rendered = false
	self._filters_active = false
	self._gui_jobs = {}
end

function MissionJoinGui:_layout()
	MissionJoinGui.super._layout(self)

	self._list_panel = self._root_panel:panel({
		h = 816,
		name = "list_panel",
		w = 1216,
		x = 0,
		y = 0,
	})
	self._game_description_panel = self._root_panel:panel({
		h = 736,
		name = "list_panel",
		visible = true,
		w = 480,
		x = 1248,
		y = 64,
	})
	self._filters_panel = self._root_panel:panel({
		h = 736,
		name = "list_panel",
		visible = false,
		w = 480,
		x = 1248,
		y = 64,
	})
	self._footer_buttons_panel = self._root_panel:panel({
		h = 64,
		name = "list_panel",
		w = 1728,
		x = 0,
		y = 832,
	})

	self:_layout_filters()
	self:_layout_server_list_table()
	self:_layout_game_description()
	self:_layout_footer_buttons()
	self:_set_additional_layout()
	self:_update_active_controls()
	self._table_servers:set_selected(true)
	self:_render_filters()
	self:on_click_apply_filters_button()
	self:bind_controller_inputs()
end

function MissionJoinGui:_layout_filters()
	self._friends_only_button = self._filters_panel:toggle_button({
		button_h = self.FILTER_BUTTON_H,
		button_w = self.FILTER_BUTTON_W,
		description = self:translate("menu_mission_join_filters_friends_only", true),
		font_size = self.FILTER_FONT_SIZE,
		h = self.FILTER_HEIGHT,
		name = "friends_only_button",
		on_click_callback = callback(self, self, "on_click_friends_only_button"),
		on_menu_move = {
			down = "in_camp_servers_only",
			up = "mission_filter_stepper",
		},
		w = self.FILTER_WIDTH,
		y = 32,
	})
	self._in_camp_servers_only = self._filters_panel:toggle_button({
		button_h = self.FILTER_BUTTON_H,
		button_w = self.FILTER_BUTTON_W,
		description = self:translate("menu_mission_join_filters_in_camp_servers_only", true),
		font_size = self.FILTER_FONT_SIZE,
		h = self.FILTER_HEIGHT,
		name = "in_camp_servers_only",
		on_click_callback = callback(self, self, "on_click_camp_only_button"),
		on_menu_move = {
			down = "distance_filter_stepper",
			up = "friends_only_button",
		},
		w = self.FILTER_WIDTH,
		y = self._friends_only_button:y() + 50,
	})
	self._distance_filter_stepper = self._filters_panel:stepper({
		arrow_color = tweak_data.gui.colors.raid_red,
		button_h = self.FILTER_BUTTON_H,
		button_w = self.FILTER_BUTTON_W,
		color = tweak_data.gui.colors.raid_red,
		data_source_callback = callback(self, self, "data_source_distance_filter_stepper"),
		description = self:translate("menu_mission_join_filters_distance_filter", true),
		font_size = self.FILTER_FONT_SIZE,
		h = self.FILTER_HEIGHT,
		name = "distance_filter_stepper",
		on_item_selected_callback = callback(self, self, "on_click_distance_filter"),
		on_menu_move = {
			down = "difficulty_filter_stepper",
			up = "in_camp_servers_only",
		},
		stepper_w = self.FILTER_STEPPER_W,
		w = self.FILTER_WIDTH,
		y = self._in_camp_servers_only:y() + 50,
	})
	self._difficulty_filter_stepper = self._filters_panel:stepper({
		arrow_color = tweak_data.gui.colors.raid_red,
		button_h = self.FILTER_BUTTON_H,
		button_w = self.FILTER_BUTTON_W,
		color = tweak_data.gui.colors.raid_red,
		data_source_callback = callback(self, self, "data_source_difficulty_filter_stepper"),
		description = self:translate("menu_mission_join_filters_difficulty_filter", true),
		font_size = self.FILTER_FONT_SIZE,
		h = self.FILTER_HEIGHT,
		name = "difficulty_filter_stepper",
		on_item_selected_callback = callback(self, self, "on_click_difficuty_filter"),
		on_menu_move = {
			down = "mission_filter_stepper",
			up = "distance_filter_stepper",
		},
		stepper_w = self.FILTER_STEPPER_W,
		w = self.FILTER_WIDTH,
		y = self._distance_filter_stepper:y() + 50,
	})
	self._mission_filter_stepper = self._filters_panel:stepper({
		arrow_color = tweak_data.gui.colors.raid_red,
		button_h = self.FILTER_BUTTON_H,
		button_w = self.FILTER_BUTTON_W,
		color = tweak_data.gui.colors.raid_red,
		data_source_callback = callback(self, self, "data_source_mission_filter_stepper"),
		description = self:translate("menu_mission_join_filters_mission_filter", true),
		font_size = self.FILTER_FONT_SIZE,
		h = self.FILTER_HEIGHT,
		name = "mission_filter_stepper",
		on_menu_move = {
			down = "friends_only_button",
			up = "difficulty_filter_stepper",
		},
		stepper_w = self.FILTER_STEPPER_W,
		w = self.FILTER_WIDTH,
		y = self._difficulty_filter_stepper:y() + 50,
	})
end

function MissionJoinGui:_layout_server_list_table()
	self._servers_title_label = self._list_panel:label({
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.title,
		h = 69,
		name = "servers_title_label",
		text = utf8.to_upper(managers.localization:text("menu_mission_join_server_list_title")),
		vertical = "top",
		w = 320,
	})
	self._server_list_scrollable_area = self._list_panel:scrollable_area({
		h = 720,
		name = "servers_table_scrollable_area",
		scroll_step = 35,
		w = 1216,
		y = 96,
	})
	self._params_servers_table = {
		loop_items = true,
		name = "servers_table",
		on_selected_callback = callback(self, self, "bind_controller_inputs"),
		scrollable_area_ref = self._server_list_scrollable_area,
		table_params = {
			columns = {
				{
					align = "left",
					cell_class = RaidGUIControlTableCell,
					color = tweak_data.gui.colors.raid_grey,
					header_padding = 32,
					header_text = self:translate("menu_mission_join_server_list_columns_mission_type", true),
					highlight_color = tweak_data.gui.colors.raid_white,
					on_cell_click_callback = callback(self, self, "on_cell_click_servers_table"),
					padding = 32,
					selected_color = tweak_data.gui.colors.raid_red,
					vertical = "center",
					w = 480,
				},
				{
					align = "left",
					cell_class = RaidGUIControlTableCell,
					color = tweak_data.gui.colors.raid_grey,
					header_padding = 0,
					header_text = self:translate("menu_mission_join_server_list_columns_difficulty", true),
					highlight_color = tweak_data.gui.colors.raid_white,
					on_cell_click_callback = callback(self, self, "on_cell_click_servers_table"),
					padding = 0,
					selected_color = tweak_data.gui.colors.raid_red,
					vertical = "center",
					w = 224,
				},
				{
					align = "left",
					cell_class = RaidGUIControlTableCell,
					color = tweak_data.gui.colors.raid_grey,
					header_padding = 0,
					header_text = self:translate("menu_mission_join_server_list_columns_host_name", true),
					highlight_color = tweak_data.gui.colors.raid_white,
					on_cell_click_callback = callback(self, self, "on_cell_click_servers_table"),
					padding = 0,
					selected_color = tweak_data.gui.colors.raid_red,
					vertical = "center",
					w = 352,
				},
				{
					align = "left",
					cell_class = RaidGUIControlTableCell,
					color = tweak_data.gui.colors.raid_grey,
					header_padding = 0,
					header_text = self:translate("menu_mission_join_server_list_columns_players", true),
					highlight_color = tweak_data.gui.colors.raid_white,
					on_cell_click_callback = callback(self, self, "on_cell_click_servers_table"),
					padding = 0,
					selected_color = tweak_data.gui.colors.raid_red,
					vertical = "center",
					w = 144,
				},
			},
			data_source_callback = callback(self, self, "data_source_servers_table"),
			header_params = {
				font = tweak_data.gui.fonts.din_compressed,
				font_size = tweak_data.gui.font_sizes.small,
				header_height = 32,
				text_color = tweak_data.gui.colors.raid_white,
			},
			row_params = {
				color = tweak_data.gui.colors.raid_grey,
				font = tweak_data.gui.fonts.din_compressed,
				font_size = tweak_data.gui.font_sizes.extra_small,
				height = MissionJoinGui.SERVER_TABLE_ROW_HEIGHT,
				highlight_color = tweak_data.gui.colors.raid_white,
				on_row_click_callback = callback(self, self, "on_row_clicked_servers_table"),
				on_row_double_clicked_callback = callback(self, self, "on_row_double_clicked_servers_table"),
				on_row_select_callback = callback(self, self, "on_row_selected_servers_table"),
				row_background_color = tweak_data.gui.colors.raid_white:with_alpha(0),
				row_highlight_background_color = tweak_data.gui.colors.raid_white:with_alpha(0.1),
				row_selected_background_color = tweak_data.gui.colors.raid_white:with_alpha(0.1),
				selected_color = tweak_data.gui.colors.raid_red,
				spacing = 0,
			},
		},
		use_row_dividers = true,
		use_selector_mark = true,
		w = self._server_list_scrollable_area:w(),
	}

	if IS_XB1 then
		self._params_servers_table.on_menu_move = {
			right = "player_description_1",
		}
	end

	self._table_servers = self._server_list_scrollable_area:get_panel():table(self._params_servers_table)

	self._server_list_scrollable_area:setup_scroll_area()
end

function MissionJoinGui:_layout_game_description()
	local desc_mission_icon_name = tweak_data.operations.missions.flakturm.icon_menu
	local desc_mission_icon = {
		texture = tweak_data.gui.icons[desc_mission_icon_name].texture,
		texture_rect = tweak_data.gui.icons[desc_mission_icon_name].texture_rect,
	}

	self._desc_mission_icon = self._game_description_panel:bitmap({
		texture = desc_mission_icon.texture,
		texture_rect = desc_mission_icon.texture_rect,
		visible = false,
		x = 0,
		y = 0,
	})
	self._desc_mission_name = self._game_description_panel:label({
		align = "left",
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.menu_list,
		h = 96,
		text = "FLAKTURM",
		vertical = "center",
		visible = false,
		w = 400,
		x = 80,
		y = 0,
	})
	self._desc_mission_name_small = self._game_description_panel:label({
		align = "left",
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		h = 32,
		text = "FLAKTURM",
		vertical = "center",
		visible = false,
		w = 400,
		x = 80,
		y = 0,
	})

	local difficulty_params = {
		amount = tweak_data:number_of_difficulties(),
		name = "mission_difficulty",
	}

	self._server_difficulty_indicator = RaidGuiControlDifficultyStars:new(self._game_description_panel, difficulty_params)

	self._server_difficulty_indicator:set_x(80)

	self._desc_xp_amount = self._game_description_panel:label({
		align = "right",
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.extra_small,
		h = 32,
		text = "1000 XP",
		vertical = "center",
		visible = false,
		w = 240,
		x = 240,
		y = 96,
	})
	self._player_info_panel = self._game_description_panel:panel({
		h = 288,
		name = "player_info_panel",
		w = 480,
		x = 0,
		y = 160,
	})
	self._player_controls = {}

	for counter = 1, 3 do
		local player_description_params = {
			h = 96,
			name = "player_description_" .. tostring(counter),
			w = 480,
			x = 0,
			y = (counter - 1) * 96,
		}

		if IS_XB1 then
			player_description_params.on_menu_move = {
				down = "player_description_" .. tostring(counter % 3 + 1),
				left = "servers_table",
				up = "player_description_" .. tostring(counter > 1 and counter - 1 or 3),
			}
			player_description_params.on_selected_callback = callback(self, self, "bind_controller_inputs_player_description")
		end

		local player_control = self._player_info_panel:create_custom_control(RaidGUIControlServerPlayerDescription, player_description_params)

		player_control:set_data(nil)
		table.insert(self._player_controls, player_control)
	end

	self._desc_challenge_card_panel = self._game_description_panel:panel({
		h = 224,
		visible = false,
		w = 480,
		x = 0,
		y = 512,
	})
	self.desc_challenge_card_icon = self._desc_challenge_card_panel:bitmap({
		h = 138,
		texture = tweak_data.challenge_cards.rarity_definition.loot_rarity_common.texture_path,
		texture_rect = tweak_data.challenge_cards.rarity_definition.loot_rarity_common.texture_rect,
		w = 96,
		x = 0,
		y = 64,
	})
	self._desc_challenge_card_name = self._desc_challenge_card_panel:label({
		align = "left",
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		h = 64,
		text = "SWITCH HITLER",
		vertical = "center",
		w = 384,
		x = 0,
		y = 0,
	})

	local desc_challenge_card_rarity_icon = tweak_data.gui.icons.loot_rarity_uncommon

	self._desc_challenge_card_rarity_icon = self._desc_challenge_card_panel:bitmap({
		h = 32,
		texture = desc_challenge_card_rarity_icon.texture,
		texture_rect = desc_challenge_card_rarity_icon.texture_rect,
		w = 32,
		x = 384,
		y = 16,
	})
	self._desc_challenge_card_xp = self._desc_challenge_card_panel:label({
		align = "right",
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 64,
		text = "X1.5",
		vertical = "center",
		w = 64,
		x = 416,
		y = 0,
	})
	self._desc_challenge_card_name_on_card = self._desc_challenge_card_panel:label({
		align = "center",
		color = tweak_data.gui.colors.raid_dirty_white,
		font = RaidGUIControlCardBase.TITLE_FONT,
		font_size = math.ceil(RaidGUIControlCardBase.TITLE_TEXT_SIZE * (self.desc_challenge_card_icon:h() / 255)),
		h = self.desc_challenge_card_icon:h() * RaidGUIControlCardBase.TITLE_H,
		text = "SWITCH HITLER",
		vertical = "center",
		w = self.desc_challenge_card_icon:w() * (1 - 2 * RaidGUIControlCardBase.TITLE_PADDING),
		wrap = true,
		x = self.desc_challenge_card_icon:x() + self.desc_challenge_card_icon:w() * RaidGUIControlCardBase.TITLE_PADDING,
		y = self.desc_challenge_card_icon:y() + self.desc_challenge_card_icon:h() * RaidGUIControlCardBase.TITLE_Y,
	})

	local desc_challenge_card_rarity_icon = tweak_data.gui.icons.loot_rarity_uncommon
	local card_rarity_icon_texture = desc_challenge_card_rarity_icon.texture
	local card_rarity_icon_texture_rect = desc_challenge_card_rarity_icon.texture_rect
	local card_rarity_h = self.desc_challenge_card_icon:h() * RaidGUIControlCardBase.ICON_H
	local card_rarity_w = card_rarity_h * (card_rarity_icon_texture_rect[3] / card_rarity_icon_texture_rect[4])

	self._desc_challenge_card_rarity_icon_on_card = self._desc_challenge_card_panel:bitmap({
		h = card_rarity_h,
		texture = desc_challenge_card_rarity_icon.texture,
		texture_rect = desc_challenge_card_rarity_icon.texture_rect,
		w = card_rarity_w,
		x = self.desc_challenge_card_icon:w() - card_rarity_w - self.desc_challenge_card_icon:w() * RaidGUIControlCardBase.ICON_LEFT_PADDING,
		y = self.desc_challenge_card_icon:y() + self.desc_challenge_card_icon:h() * RaidGUIControlCardBase.ICON_TOP_PADDING,
	})

	local card_type = tweak_data.gui.icons.ico_raid
	local card_type_h = card_rarity_h
	local card_type_w = card_type_h * (card_type.texture_rect[3] / card_type.texture_rect[4])
	local params_card_type = {
		h = card_type_h,
		layer = self.desc_challenge_card_icon:layer() + 1,
		name = "card_type_icon",
		texture = card_type.texture,
		texture_rect = card_type.texture_rect,
		w = card_type_w,
		x = self.desc_challenge_card_icon:w() * RaidGUIControlCardBase.ICON_LEFT_PADDING,
		y = self.desc_challenge_card_icon:y() + self.desc_challenge_card_icon:h() * RaidGUIControlCardBase.ICON_TOP_PADDING,
	}

	self._desc_challenge_card_type_icon_on_card = self._desc_challenge_card_panel:image(params_card_type)
	self._desc_challenge_card_xp_on_card = self._desc_challenge_card_panel:label({
		align = "center",
		color = tweak_data.gui.colors.raid_dirty_white,
		font = RaidGUIControlCardBase.XP_BONUS_FONT,
		font_size = math.ceil(RaidGUIControlCardBase.XP_BONUS_FONT_SIZE * self.desc_challenge_card_icon:w() * 0.002),
		h = self.desc_challenge_card_icon:h() * RaidGUIControlCardBase.XP_BONUS_H,
		text = "X1.5",
		vertical = "center",
		w = self.desc_challenge_card_icon:w() * RaidGUIControlCardBase.XP_BONUS_W,
		x = 0,
		y = self.desc_challenge_card_icon:y() + self.desc_challenge_card_icon:h() * RaidGUIControlCardBase.XP_BONUS_Y,
	})
	self._desc_challenge_card_bonus = self._desc_challenge_card_panel:label({
		align = "left",
		color = tweak_data.gui.colors.raid_grey_effects,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_18,
		h = 64,
		text = "+ shooting your secondary weapon fills up your primary ammo",
		vertical = "top",
		w = 352,
		wrap = true,
		x = 128,
		y = 64,
	})
	self._desc_challenge_card_malus = self._desc_challenge_card_panel:label({
		align = "left",
		color = tweak_data.gui.colors.raid_grey_effects,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_18,
		h = 64,
		text = "- shooting your primary weapon consumes both primary and secondary ammo",
		vertical = "top",
		w = 352,
		wrap = true,
		x = 128,
		y = 128,
	})
end

function MissionJoinGui:_layout_footer_buttons()
	self._join_button = self._footer_buttons_panel:short_primary_button({
		name = "join_button",
		on_click_callback = callback(self, self, "on_click_join_button"),
		on_menu_move = {
			left = "friends_only_button",
			up = "servers_table",
		},
		text = self:translate("menu_mission_join_join", true),
	})
	self._apply_filters_button = self._footer_buttons_panel:short_secondary_button({
		align = "center",
		color = Color.black,
		h = 28,
		highlight_color = Color.white,
		name = "apply_filters_button",
		on_click_callback = callback(self, self, "on_click_apply_filters_button"),
		text = self:translate("menu_mission_join_filters_apply", true),
		texture_color = tweak_data.gui.colors.raid_red,
		texture_highlight_color = tweak_data.gui.colors.raid_red,
		vertical = "center",
		w = 128,
		x = 1280,
	})
	self._show_filters_button = self._footer_buttons_panel:short_tertiary_button({
		align = "center",
		color = Color.black,
		h = 28,
		highlight_color = Color.white,
		name = "show_filters_button",
		on_click_callback = callback(self, self, "on_click_show_filters_button"),
		text = self:translate("menu_mission_join_filters_show", true),
		texture_color = tweak_data.gui.colors.raid_red,
		texture_highlight_color = tweak_data.gui.colors.raid_red,
		vertical = "center",
		w = 128,
		x = 1536,
	})
	self._online_users_count = self._footer_buttons_panel:label({
		align = "left",
		color = tweak_data.gui.colors.raid_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.large,
		h = 64,
		name = "online_users_count",
		text = "",
		vertical = "center",
		w = 320,
		x = 960,
	})
end

function MissionJoinGui:_set_additional_layout()
	self._join_button:set_center_y(self._footer_buttons_panel:h() / 2)
	self._apply_filters_button:set_center_y(self._footer_buttons_panel:h() / 2)
	self._show_filters_button:set_center_y(self._footer_buttons_panel:h() / 2)
	self._desc_mission_icon:set_center_y(58)
	self._desc_mission_name_small:set_center_y(self._desc_mission_icon:center_y() - 14)
	self._server_difficulty_indicator:set_center_y(self._desc_mission_icon:center_y() + 14)
	self._desc_xp_amount:set_center_y(self._server_difficulty_indicator:center_y())
end

function MissionJoinGui:on_click_friends_only_button()
	local friends_only = self._friends_only_button:get_value()

	managers.user:set_setting("server_filter_friends_only", friends_only)
	managers.network.matchmake:set_search_friends_only(friends_only)
end

function MissionJoinGui:on_click_camp_only_button()
	local camp_only = self._in_camp_servers_only:get_value()
	local state = camp_only and 1 or -1

	managers.user:set_setting("server_filter_camp_only", camp_only)
	managers.network.matchmake:add_lobby_filter("state", state, "equal")
end

function MissionJoinGui:on_click_distance_filter()
	local distance_filter = self._distance_filter_stepper:get_value()

	managers.user:set_setting("server_filter_distance", distance_filter)
end

function MissionJoinGui:on_click_difficuty_filter()
	local difficulty_filter = self._difficulty_filter_stepper:get_value()

	managers.user:set_setting("server_filter_difficulty", difficulty_filter)
end

function MissionJoinGui:on_row_clicked_servers_table(row_data, row_index)
	self:_select_server_list_item(row_data[5].value)
end

function MissionJoinGui:on_row_double_clicked_servers_table(row_data, row_index)
	Application:trace("[MissionJoinGui:on_row_double_clicked_servers_table]", inspect(row_data), row_index)
	self:_select_server_list_item(row_data[5].value)
	self:_join_game()
end

function MissionJoinGui:on_row_selected_servers_table(row_data, row_index)
	self:_select_server_list_item(row_data[5].value)
end

function MissionJoinGui:on_cell_click_servers_table(data)
	self:_select_server_list_item(self._selected_row_data[5].value)
end

function MissionJoinGui:data_source_servers_table()
	local missions = {}

	if not self._gui_jobs then
		self._gui_jobs = {}
	end

	local mission_data

	for key, value in pairs(self._gui_jobs) do
		if utf8.to_lower(value.level_id) == OperationsTweakData.IN_LOBBY or utf8.to_lower(value.level_id) == OperationsTweakData.ENTRY_POINT_LEVEL then
			mission_data = {
				info = value.level_name,
				text = self:translate(tweak_data.operations.missions.camp.name_id, true),
				value = value.room_id,
			}
		elseif utf8.to_upper(value.job_name) == RaidJobManager.SINGLE_MISSION_TYPE_NAME then
			mission_data = {
				info = value.level_name,
				text = utf8.to_upper(value.level_name),
				value = value.room_id,
			}
		elseif value.progress ~= nil then
			mission_data = {
				info = value.level_name,
				text = utf8.to_upper(value.job_name .. " " .. value.progress .. ": " .. value.level_name),
				value = value.room_id,
			}
		else
			mission_data = {
				info = value.level_name,
				text = utf8.to_upper(value.job_name .. " " .. "WRONG PROGRESS" .. ": " .. value.level_name),
				value = value.room_id,
			}
		end

		local host_name = value.host_name

		if managers.user:get_setting("capitalize_names") then
			host_name = utf8.to_upper(host_name)
		end

		table.insert(missions, {
			mission_data,
			{
				info = value.difficulty,
				text = utf8.to_upper(value.difficulty),
				value = value.room_id,
			},
			{
				info = value.host_name,
				text = host_name,
				value = value.room_id,
			},
			{
				info = value.num_plrs .. "",
				text = value.num_plrs .. "",
				value = value.room_id,
			},
			{
				value = value,
			},
		})
	end

	return missions
end

function MissionJoinGui:_update_active_controls()
	local active_controls = managers.menu_component._active_controls

	if self._table_servers then
		active_controls[self._table_servers._name] = {}
		active_controls[self._table_servers._name][self._table_servers._name] = self._table_servers
	end
end

function MissionJoinGui:_remove_active_controls()
	local active_controls = managers.menu_component._active_controls

	if self._table_servers then
		active_controls[self._table_servers._name] = {}
	end
end

function MissionJoinGui:data_source_distance_filter_stepper()
	local result = {}

	table.insert(result, {
		info = "Close",
		text = self:translate("menu_dist_filter_close", true),
		value = 0,
	})
	table.insert(result, {
		info = "Far",
		text = self:translate("menu_dist_filter_far", true),
		value = 2,
	})
	table.insert(result, {
		info = "Worldwide",
		text = self:translate("menu_dist_filter_worldwide", true),
		value = 3,
	})

	return result
end

function MissionJoinGui:data_source_difficulty_filter_stepper()
	local result = {}

	if tweak_data.difficulties then
		table.insert(result, {
			info = "Any",
			text = self:translate("menu_any", true),
			value = 0,
		})

		for diff_index, diff_name in pairs(tweak_data.difficulties) do
			table.insert(result, {
				info = diff_name,
				text = self:translate("menu_" .. diff_name, true),
				value = diff_index,
			})
		end
	end

	return result
end

function MissionJoinGui:data_source_mission_filter_stepper()
	local result = {}

	table.insert(result, {
		info = "Any",
		text = self:translate("menu_any", true),
		value = -1,
	})

	for _, mission_name_id in pairs(tweak_data.operations:get_raids_index()) do
		local mission_data = tweak_data.operations:mission_data(mission_name_id)
		local mission_name = self:translate(mission_data.name_id, true)

		table.insert(result, {
			text = mission_name,
			value = mission_name_id,
		})
	end

	for _, mission_name_id in pairs(tweak_data.operations:get_operations_index()) do
		local mission_data = tweak_data.operations:mission_data(mission_name_id)
		local mission_name = self:translate(mission_data.name_id, true)

		table.insert(result, {
			text = mission_name,
			value = mission_name_id,
		})
	end

	return result
end

function MissionJoinGui:on_click_apply_filters_button()
	self:_refresh_server_list()
end

function MissionJoinGui:on_click_show_filters_button()
	self._filters_panel:set_visible(not self._filters_panel:visible())

	if self._selected_row_data then
		self._game_description_panel:set_visible(not self._filters_panel:visible())
	end
end

function MissionJoinGui:on_click_join_button()
	Application:trace("[MissionJoinGui:on_click_join_button]")
	self:_join_game()
end

function MissionJoinGui:_refresh_server_list()
	self._apply_filters_button:hide()

	local user = managers.user
	local maximum_servers = managers.network.matchmake:get_lobby_return_count()
	local friends_only = user:get_setting("server_filter_friends_only")
	local camp_only = user:get_setting("server_filter_camp_only") and 1 or -1
	local distance_filter = user:get_setting("server_filter_distance")
	local difficulty_filter = user:get_setting("server_filter_difficulty")
	local mission_filter = self._mission_filter_stepper:get_value()

	managers.network.matchmake:set_lobby_return_count(maximum_servers)
	managers.network.matchmake:set_distance_filter(distance_filter)
	managers.network.matchmake:set_difficulty_filter(difficulty_filter)
	managers.network.matchmake:add_lobby_filter("job_id", mission_filter, "equal")
	managers.network.matchmake:add_lobby_filter("state", camp_only, "equal")

	self._selected_row_data = nil

	self:_find_online_games(friends_only)
end

function MissionJoinGui:_select_server_list_item(data_value)
	self:_select_game_from_list()
	self:_set_game_description_data(data_value)
end

function MissionJoinGui:_render_filters()
	local user = managers.user

	self._friends_only_button:set_value_and_render(user:get_setting("server_filter_friends_only"))
	self._in_camp_servers_only:set_value_and_render(user:get_setting("server_filter_camp_only"))
	self._distance_filter_stepper:select_item_by_value(user:get_setting("server_filter_distance"))
	self._difficulty_filter_stepper:select_item_by_value(user:get_setting("server_filter_difficulty"))
	self._mission_filter_stepper:select_item_by_value(managers.network.matchmake:get_lobby_filter("job_id"))
end

function MissionJoinGui:_join_game()
	local selected_row = self._table_servers:get_selected_row()

	if not selected_row or not selected_row:get_data() then
		return
	end

	local data = selected_row:get_data()
	local steam_player_id = data[4].value

	managers.network.matchmake:join_server_with_check(steam_player_id)
end

function MissionJoinGui:_select_game_from_list()
	local selected_row = self._table_servers:get_selected_row()

	if not selected_row then
		return
	end

	self._selected_row_data = selected_row:get_data()
end

function MissionJoinGui:_set_game_description_data(data)
	local in_camp = data.level_id == "camp"

	if data.level_id == OperationsTweakData.IN_LOBBY then
		data.level_id = "camp"
		in_camp = true
	end

	if data.job_id and data.level_id then
		local desc_mission_icon_name

		if data.mission_type == tostring(OperationsTweakData.JOB_TYPE_RAID) or in_camp then
			desc_mission_icon_name = tweak_data.operations.missions[data.level_id] and tweak_data.operations.missions[data.level_id].icon_menu
		elseif data.mission_type == tostring(OperationsTweakData.JOB_TYPE_OPERATION) then
			desc_mission_icon_name = tweak_data.operations.missions[data.job_id] and tweak_data.operations.missions[data.job_id].icon_menu
		end

		if desc_mission_icon_name then
			local desc_mission_icon = {
				texture = tweak_data.gui.icons[desc_mission_icon_name].texture,
				texture_rect = tweak_data.gui.icons[desc_mission_icon_name].texture_rect,
			}

			self._desc_mission_icon:set_image(desc_mission_icon.texture, unpack(desc_mission_icon.texture_rect))
			self._desc_mission_icon:set_w(desc_mission_icon.texture_rect[3])
			self._desc_mission_icon:set_h(desc_mission_icon.texture_rect[4])
			self._desc_mission_icon:show()
		else
			self._desc_mission_icon:hide()
		end
	else
		self._desc_mission_icon:hide()
	end

	if data.job_id and data.level_id then
		if in_camp then
			self._desc_mission_name:set_text(self:translate(tweak_data.operations.missions[data.level_id].name_id, true))
			self._desc_mission_name:show()
			self._desc_mission_name_small:hide()
			self._server_difficulty_indicator:hide()
		else
			local level_name = ""

			if data.mission_type == tostring(OperationsTweakData.JOB_TYPE_RAID) then
				level_name = tweak_data.operations.missions[data.level_id] and self:translate(tweak_data.operations.missions[data.level_id].name_id, true)
			elseif data.mission_type == tostring(OperationsTweakData.JOB_TYPE_OPERATION) then
				level_name = self:translate(tweak_data.operations.missions[data.job_id].name_id, true) .. " " .. data.progress .. ": " .. self:translate(tweak_data.operations.missions[data.job_id].events[data.level_id].name_id, true)
			end

			self._desc_mission_name_small:set_text(level_name)
			self._server_difficulty_indicator:set_active_difficulty(data.difficulty_id)
			self._desc_mission_name_small:show()
			self._server_difficulty_indicator:show()
			self._desc_mission_name:hide()
		end
	else
		self._desc_mission_name:hide()
	end

	local level_xp_amount = 0

	if tostring(data.mission_type) == tostring(OperationsTweakData.JOB_TYPE_RAID) then
		if data.level_id then
			level_xp_amount = tweak_data.operations.missions[data.level_id] and tweak_data.operations.missions[data.level_id].xp
		else
			level_xp_amount = 0
		end
	elseif tostring(data.mission_type) == tostring(OperationsTweakData.JOB_TYPE_OPERATION) then
		if data.job_id ~= nil and data.job_id ~= 0 and tweak_data.operations.missions[data.job_id] ~= nil then
			level_xp_amount = tweak_data.operations.missions[data.job_id].xp
		end
	elseif tostring(data.mission_type) == OperationsTweakData.IN_LOBBY then
		-- block empty
	end

	if level_xp_amount and level_xp_amount > 0 then
		self._desc_xp_amount:set_text(level_xp_amount .. " XP")
		self._desc_xp_amount:show()
	else
		self._desc_xp_amount:hide()
	end

	if self._player_controls then
		for _, player_description_control in pairs(self._player_controls) do
			player_description_control:hide()
		end
	end

	local control_counter = 1

	for peer_counter = 1, 4 do
		local control_data = data["players_info_" .. peer_counter]

		if control_data ~= NetworkMatchMakingSTEAM.EMPTY_PLAYER_INFO then
			if not self._player_controls[control_counter] then
				break
			end

			if control_data ~= "value_pending" then
				self._player_controls[control_counter]:set_data(control_data)
				self._player_controls[control_counter]:set_host(peer_counter == 1)

				control_counter = control_counter + 1
			end
		end
	end

	if IS_XB1 then
		for i = 1, control_counter do
			if not self._player_controls[i] then
				break
			end

			local on_menu_move = {
				down = "player_description_" .. tostring(i % control_counter + 1),
				left = "servers_table",
				up = "player_description_" .. tostring(i > 1 and i - 1 or control_counter),
			}

			self._player_controls[i]:set_menu_move_controls(on_menu_move)
		end
	end

	local card_split = string.split(data.challenge_card, ",")
	local card_key_name = card_split[1]
	local card_data

	if card_key_name == "bounty_card" then
		local seed = card_split[2]

		card_data = managers.challenge_cards:generate_bounty_card(seed)

		math.randomseed()
	elseif card_key_name ~= "empty" then
		card_data = tweak_data.challenge_cards.cards[card_key_name]
	end

	Application:info("[MissionJoinGui] PLAYER CARD KEY NAME '" .. tostring(card_key_name) .. "'")

	if card_data then
		self._desc_challenge_card_panel:show()
		self.desc_challenge_card_icon:set_image(tweak_data.challenge_cards.challenge_card_texture_path .. card_data.texture, unpack(tweak_data.challenge_cards.challenge_card_texture_rect))
		self.desc_challenge_card_icon:show()
		self._desc_challenge_card_name:set_text(self:translate(card_data.name, true))

		local bonus_xp_reward = managers.challenge_cards:get_card_xp_label(card_key_name)

		self._desc_challenge_card_xp:set_text(bonus_xp_reward)

		local x1, y1, w1, h1 = self._desc_challenge_card_xp:text_rect()

		self._desc_challenge_card_xp:set_w(w1)
		self._desc_challenge_card_xp:set_right(self._game_description_panel:w())

		local desc_challenge_card_rarity_icon = tweak_data.challenge_cards.rarity_definition[card_data.rarity].texture_gui

		if desc_challenge_card_rarity_icon then
			self._desc_challenge_card_rarity_icon:set_image(desc_challenge_card_rarity_icon.texture, unpack(desc_challenge_card_rarity_icon.texture_rect))
			self._desc_challenge_card_rarity_icon:set_right(self._desc_challenge_card_xp:x() - 12)
			self._desc_challenge_card_rarity_icon:show()
			self._desc_challenge_card_rarity_icon_on_card:set_image(desc_challenge_card_rarity_icon.texture, unpack(desc_challenge_card_rarity_icon.texture_rect))
		end

		if not card_data.title_in_texture then
			self._desc_challenge_card_name_on_card:set_text(self:translate(card_data.name, true))
			self._desc_challenge_card_name_on_card:set_color(card_data.text_color or RaidGUIControlCardBase.TITLE_COLOR)
		else
			self._desc_challenge_card_name_on_card:set_text("")
		end

		local bonus_xp_reward = managers.challenge_cards:get_card_xp_label(card_key_name)

		self._desc_challenge_card_xp_on_card:set_text(bonus_xp_reward)

		local x1, y1, w1, h1 = self._desc_challenge_card_xp_on_card:text_rect()

		self._desc_challenge_card_xp_on_card:set_w(w1)
		self._desc_challenge_card_xp_on_card:set_h(h1)
		self._desc_challenge_card_xp_on_card:set_center_x(self.desc_challenge_card_icon:w() / 2)
		self._desc_challenge_card_xp_on_card:set_color(card_data.text_color or RaidGUIControlCardBase.TITLE_COLOR)

		local type_definition = tweak_data.challenge_cards.type_definition[card_data.card_type].texture_gui

		self._desc_challenge_card_type_icon_on_card:set_image(type_definition.texture)
		self._desc_challenge_card_type_icon_on_card:set_texture_rect(type_definition.texture_rect or tweak_data.challenge_cards.challenge_card_texture_rect)

		local bonus_description, malus_description = managers.challenge_cards:get_card_description(card_key_name)
		local card_effect_y = 64

		if bonus_description and bonus_description ~= "" then
			self._desc_challenge_card_bonus:set_text("+ " .. bonus_description)

			local _, _, _, h = self._desc_challenge_card_bonus:text_rect()

			self._desc_challenge_card_bonus:set_h(h)

			card_effect_y = card_effect_y + h
		else
			self._desc_challenge_card_bonus:set_text("")
		end

		if malus_description and malus_description ~= "" then
			self._desc_challenge_card_malus:set_text("- " .. malus_description)

			local _, _, _, h = self._desc_challenge_card_malus:text_rect()

			self._desc_challenge_card_malus:set_h(h)
			self._desc_challenge_card_malus:set_y(card_effect_y)
		else
			self._desc_challenge_card_malus:set_text("")
		end
	else
		self._desc_challenge_card_panel:hide()
		self._desc_challenge_card_name:set_text("")
		self._desc_challenge_card_rarity_icon:hide()
		self._desc_challenge_card_xp:set_text("")
		self.desc_challenge_card_icon:hide()
		self._desc_challenge_card_bonus:set_text("")
		self._desc_challenge_card_malus:set_text("")
	end
end

local is_win32 = IS_PC
local is_xb1 = IS_XB1
local is_ps4 = IS_PS4

function MissionJoinGui:_find_online_games(friends_only)
	if is_win32 then
		self:_find_online_games_win32(friends_only)
	elseif is_ps4 then
		self:_find_online_games_ps4(friends_only)
	elseif is_xb1 then
		self:_find_online_games_xb1(friends_only)
	else
		Application:error("[MissionJoinGui] Unknown gaming platform trying to find online games!")
	end
end

function MissionJoinGui:_find_online_games_win32(friends_only)
	local function f(info)
		managers.network.matchmake:search_lobby_done()

		local room_list = info.room_list
		local attribute_list = info.attribute_list
		local dead_list = {}

		for id, _ in pairs(self._active_server_jobs) do
			dead_list[id] = true
		end

		for i, room in ipairs(room_list) do
			local host_name = tostring(room.owner_name)
			local attributes_numbers = attribute_list[i].numbers

			if managers.network.matchmake:is_server_ok(friends_only, room.owner_id, attributes_numbers) then
				dead_list[room.room_id] = nil

				local job_id = attributes_numbers[14]
				local job_name = ""
				local level_id = attributes_numbers[1]
				local level_name = ""
				local difficulty_id = attributes_numbers[2]
				local difficulty = self:translate(tweak_data:get_difficulty_string_name_from_index(difficulty_id), true)
				local kick_option = attributes_numbers[8]
				local job_plan = attributes_numbers[10]
				local state = attributes_numbers[4]
				local state_string_id = tweak_data:index_to_server_state(state)
				local state_name = state_string_id and managers.localization:text("menu_lobby_server_state_" .. state_string_id) or "UNKNOWN"
				local num_plrs = attributes_numbers[5]
				local challenge_card = attributes_numbers[12]
				local players_info = attributes_numbers[13]
				local progress = attributes_numbers[15]
				local mission_type = attributes_numbers[16]
				local players_info_1 = attributes_numbers[17]
				local players_info_2 = attributes_numbers[18]
				local players_info_3 = attributes_numbers[19]
				local players_info_4 = attributes_numbers[20]

				if challenge_card == "nocards" or challenge_card == "" or challenge_card == "value_pending" then
					challenge_card = ""
				end

				if players_info == "value_pending" then
					players_info = ""
				end

				if progress == "value_pending" then
					progress = ""
				end

				if mission_type == "value_pending" then
					mission_type = ""
				end

				if level_id == OperationsTweakData.IN_LOBBY then
					level_name = self:translate("menu_mission_select_in_lobby")
					job_name = self:translate("menu_mission_select_in_lobby")
				elseif tonumber(mission_type) == OperationsTweakData.JOB_TYPE_OPERATION then
					level_name = ""
					job_name = ""

					local operation_data = tweak_data.operations.missions[job_id]

					if operation_data and operation_data.events and operation_data.events[level_id] then
						level_name = self:translate(operation_data.events[level_id].name_id)
						job_name = self:translate(operation_data.name_id)
					end
				elseif tonumber(mission_type) == OperationsTweakData.JOB_TYPE_RAID then
					local mission_data = tweak_data.operations.missions[job_id]

					level_name = ""

					if mission_data and mission_data.name_id then
						level_name = self:translate(mission_data.name_id)
					end

					job_name = self:translate("menu_mission_selected_mission_type_raid")
				end

				local relation = Steam:friend_relationship(room.owner_id)
				local is_friend = relation == "friend"

				if level_name == "" or job_name == "" then
					dead_list[room.room_id] = true
				else
					local job_data = {
						challenge_card = challenge_card,
						custom_text = room.custom_text,
						difficulty = difficulty,
						difficulty_id = difficulty_id,
						host_name = host_name,
						id = room.room_id,
						is_friend = is_friend,
						job_id = job_id,
						job_name = job_name,
						job_plan = job_plan,
						kick_option = kick_option,
						level_id = level_id,
						level_name = level_name,
						mission_type = mission_type,
						num_plrs = num_plrs,
						players_info = players_info,
						players_info_1 = players_info_1,
						players_info_2 = players_info_2,
						players_info_3 = players_info_3,
						players_info_4 = players_info_4,
						progress = progress,
						room_id = room.room_id,
						state = state,
						state_name = state_name,
						xuid = room.xuid,
					}

					if not self._active_server_jobs[room.room_id] then
						if table.size(self._active_jobs) + table.size(self._active_server_jobs) < self._tweak_data.total_active_jobs and table.size(self._active_server_jobs) < self._max_active_server_jobs then
							self._active_server_jobs[room.room_id] = {
								added = false,
								alive_time = 0,
							}

							self:add_gui_job(job_data)
						end
					else
						self:update_gui_job(job_data)
					end
				end
			end
		end

		for id, _ in pairs(dead_list) do
			self._active_server_jobs[id] = nil

			self:remove_gui_job(id)
		end

		if self._table_servers and self._table_servers:is_alive() then
			self._table_servers:refresh_data()
			self._server_list_scrollable_area:setup_scroll_area()
			self._table_servers:select_table_row_by_row_idx(1)
			self:_select_game_from_list()

			if self._selected_row_data then
				self:_set_game_description_data(self._selected_row_data[5].value)
				self._game_description_panel:show()
				self._filters_panel:hide()
				self:_filters_set_selected_server_table()
			else
				self._game_description_panel:hide()
				self._filters_panel:show()
				self:_filters_set_selected_filters()
			end
		end

		self._apply_filters_button:show()
	end

	managers.network.matchmake:register_callback("search_lobby", f)
	managers.network.matchmake:search_lobby(friends_only)

	local function usrs_f(success, amount)
		print("usrs_f", success, amount)

		if success then
			self:set_players_online(amount)
		end
	end

	if is_win32 then
		Steam:sa_handler():concurrent_users_callback(usrs_f)
		Steam:sa_handler():get_concurrent_users()
	end
end

function MissionJoinGui:_find_online_games_xb1(friends_only)
	if managers.network.matchmake:searching_lobbys() then
		self._refresh_server_t = Application:time() + 5

		return
	end

	Application:trace("[MissionJoinGui:_find_online_games_win32]")

	local function f(info)
		managers.network.matchmake:search_lobby_done()

		local room_list = info.room_list
		local attribute_list = info.attribute_list
		local dead_list = {}

		for id, _ in pairs(self._active_server_jobs) do
			dead_list[id] = true
		end

		for i, room in ipairs(room_list) do
			local name_str = tostring(room.owner_name)
			local attributes_numbers = attribute_list[i].numbers

			Application:trace("attributes_numbers ", inspect(attributes_numbers))

			if managers.network.matchmake:is_server_ok(friends_only, room.owner_id, attributes_numbers) then
				dead_list[room.room_id] = nil

				local host_name = name_str
				local mission_type = attributes_numbers[16]
				local job_id = tweak_data.operations:get_operation_name_from_index(attributes_numbers[14])
				local level_id = OperationsTweakData.IN_LOBBY

				if mission_type == OperationsTweakData.JOB_TYPE_OPERATION then
					level_id = tweak_data.operations:get_raid_id_from_raid_index(job_id, attributes_numbers[1])
				elseif mission_type == OperationsTweakData.JOB_TYPE_RAID then
					level_id = tweak_data.operations:get_raid_name_from_index(attributes_numbers[1])
				end

				local name_id = ""
				local level_name = ""
				local difficulty_id = attributes_numbers[2]
				local difficulty = self:translate(tweak_data:get_difficulty_string_name_from_index(difficulty_id), true)
				local job_name = ""
				local kick_option = attributes_numbers[8]
				local job_plan = attributes_numbers[10]
				local state_string_id = tweak_data:index_to_server_state(attributes_numbers[4])
				local state_name = state_string_id and managers.localization:text("menu_lobby_server_state_" .. state_string_id) or "UNKNOWN"
				local state = attributes_numbers[4]
				local num_plrs = attributes_numbers[5]
				local permission = attributes_numbers[3]
				local challenge_card = attributes_numbers[12]
				local game_version = attributes_numbers[13]
				local progress = attributes_numbers[15]
				local players_info_1 = attributes_numbers[17]
				local players_info_2 = attributes_numbers[18]
				local players_info_3 = attributes_numbers[19]
				local players_info_4 = attributes_numbers[20]

				if challenge_card == "nocards" or challenge_card == "" or challenge_card == "value_pending" then
					challenge_card = ""
				end

				local players_info = 0

				if players_info == "value_pending" then
					players_info = ""
				end

				if progress == "value_pending" then
					progress = ""
				end

				if mission_type == "value_pending" then
					mission_type = ""
				end

				if level_id == OperationsTweakData.IN_LOBBY then
					level_name = self:translate("menu_mission_select_in_lobby")
					job_name = self:translate("menu_mission_select_in_lobby")
				elseif tonumber(mission_type) == OperationsTweakData.JOB_TYPE_OPERATION then
					level_name = ""
					job_name = ""

					local operation_data = tweak_data.operations.missions[job_id]

					if operation_data and operation_data.events and operation_data.events[level_id] then
						level_name = self:translate(tweak_data.operations.missions[job_id].events[level_id].name_id)
						job_name = self:translate(tweak_data.operations.missions[job_id].name_id)
					else
						level_name = "N/A"
						job_name = "N/A"

						if level_id ~= nil and job_id ~= nil then
							Application:error("Level '" .. level_id .. "' can't be found in operation '" .. job_id .. "'.")
						end
					end
				elseif tonumber(mission_type) == OperationsTweakData.JOB_TYPE_RAID then
					local mission_data = tweak_data.operations.missions[level_id]

					level_name = ""

					if mission_data and mission_data.name_id then
						level_name = self:translate(tweak_data.operations.missions[level_id].name_id)
					end

					job_name = self:translate("menu_mission_selected_mission_type_raid")
				end

				local is_friend = false

				if is_win32 and Steam:logged_on() and Steam:friends() then
					for _, friend in ipairs(Steam:friends()) do
						if friend:id() == room.owner_id then
							is_friend = true

							break
						end
					end
				end

				name_id = name_id or "unknown"

				if name_id then
					if not self._active_server_jobs[room.room_id] then
						if table.size(self._active_jobs) + table.size(self._active_server_jobs) < self._tweak_data.total_active_jobs and table.size(self._active_server_jobs) < self._max_active_server_jobs then
							self._active_server_jobs[room.room_id] = {
								added = false,
								alive_time = 0,
							}

							self:add_gui_job({
								challenge_card = challenge_card,
								custom_text = room.custom_text,
								difficulty = difficulty,
								difficulty_id = difficulty_id,
								host_name = host_name,
								id = room.room_id,
								info = room.info,
								is_friend = is_friend,
								job_id = job_id,
								job_name = job_name,
								job_plan = job_plan,
								kick_option = kick_option,
								level_id = level_id,
								level_name = level_name,
								mission_type = mission_type,
								num_plrs = num_plrs,
								players_info = players_info,
								players_info_1 = players_info_1,
								players_info_2 = players_info_2,
								players_info_3 = players_info_3,
								players_info_4 = players_info_4,
								progress = progress,
								room_id = room.room_id,
								state = state,
								state_name = state_name,
								xuid = room.xuid,
							})
						end
					else
						self:update_gui_job({
							challenge_card = challenge_card,
							custom_text = room.custom_text,
							difficulty = difficulty,
							difficulty_id = difficulty_id,
							host_name = host_name,
							id = room.room_id,
							info = room.info,
							is_friend = is_friend,
							job_id = job_id,
							job_name = job_name,
							job_plan = job_plan,
							kick_option = kick_option,
							level_id = level_id,
							level_name = level_name,
							mission_type = mission_type,
							num_plrs = num_plrs,
							players_info = players_info,
							players_info_1 = players_info_1,
							players_info_2 = players_info_2,
							players_info_3 = players_info_3,
							players_info_4 = players_info_4,
							progress = progress,
							room_id = room.room_id,
							state = state,
							state_name = state_name,
							xuid = room.xuid,
						})
					end
				end
			end
		end

		for id, _ in pairs(dead_list) do
			self._active_server_jobs[id] = nil

			self:remove_gui_job(id)
		end

		if self._table_servers then
			self._table_servers:refresh_data()
			self._server_list_scrollable_area:setup_scroll_area()
			self._table_servers:select_table_row_by_row_idx(1)
			self:_select_game_from_list()

			if self._selected_row_data then
				self:_set_game_description_data(self._selected_row_data[5].value)
				self._game_description_panel:show()
				self._filters_panel:hide()
				self:_filters_set_selected_server_table()
			else
				self._game_description_panel:hide()
				self._filters_panel:show()
				self:_filters_set_selected_filters()
			end
		end
	end

	managers.network.matchmake:register_callback("search_lobby", f)
	managers.network.matchmake:search_lobby(friends_only)

	local function usrs_f(success, amount)
		print("usrs_f", success, amount)

		if success then
			self:set_players_online(amount)
		end
	end

	if is_win32 then
		Steam:sa_handler():concurrent_users_callback(usrs_f)
		Steam:sa_handler():get_concurrent_users()
	end
end

function MissionJoinGui:_find_online_games_ps4(friends_only)
	if managers.network.matchmake:searching_lobbys() then
		self._refresh_server_t = Application:time() + 5

		return
	end

	local function f(info)
		managers.network.matchmake:search_lobby_done()

		local room_list = info.room_list
		local attribute_list = info.attribute_list
		local dead_list = {}

		for id, _ in pairs(self._active_server_jobs) do
			dead_list[id] = true
		end

		Application:trace("room_list ", inspect(info))

		if room_list then
			for i, room in ipairs(room_list) do
				Application:trace("room ", inspect(room))

				local name_str = tostring(room.owner_id)
				local attributes_numbers = attribute_list[i].numbers
				local attributes_strings = attribute_list[i].strings

				Application:trace("attributes_numbers ", inspect(attributes_numbers))
				Application:trace("attributes_strings ", inspect(attributes_strings))

				if managers.network.matchmake:is_server_ok(friends_only, room.owner_id, attributes_numbers) then
					local lroom_Id = tostring(room.room_id)

					dead_list[lroom_Id] = nil

					local host_name = name_str
					local mission_type = attributes_numbers[NetworkMatchMakingPSN.MISSION_TYPE]
					local job_id = tweak_data.operations:get_operation_name_from_index(attributes_numbers[NetworkMatchMakingPSN.JOB_INDEX])
					local level_id = OperationsTweakData.IN_LOBBY

					if mission_type == OperationsTweakData.JOB_TYPE_OPERATION then
						level_id = tweak_data.operations:get_raid_id_from_raid_index(job_id, attributes_numbers[NetworkMatchMakingPSN.LEVEL_INDEX])
					elseif mission_type == OperationsTweakData.JOB_TYPE_RAID then
						level_id = tweak_data.operations:get_raid_name_from_index(attributes_numbers[NetworkMatchMakingPSN.LEVEL_INDEX])
					end

					local name_id = ""
					local level_name = ""
					local difficulty_id = attributes_numbers[NetworkMatchMakingPSN.DIFFICULTY_ID]
					local difficulty = self:translate(tweak_data:get_difficulty_string_name_from_index(difficulty_id), true)
					local job_name = ""
					local kick_option = attributes_numbers[8]
					local job_plan = attributes_numbers[10]
					local state_string_id = tweak_data:index_to_server_state(attributes_numbers[NetworkMatchMakingPSN.STATE_ID])
					local state_name = state_string_id and managers.localization:text("menu_lobby_server_state_" .. state_string_id) or "UNKNOWN"
					local state = attributes_numbers[NetworkMatchMakingPSN.STATE_ID]
					local num_plrs = attributes_numbers[NetworkMatchMakingPSN.NUMBER_OF_PLAYERS]
					local challenge_card = ""
					local players_info = ""
					local progress = ""
					local players_info_1 = "-,-,-,-"
					local players_info_2 = "-,-,-,-"
					local players_info_3 = "-,-,-,-"
					local players_info_4 = "-,-,-,-"

					if attributes_strings then
						local S1 = attributes_strings[1] ~= "Empty" and string.split(attributes_strings[1], ";") or {
							"",
							"",
						}

						challenge_card = S1[1] or ""
						progress = S1[2] or ""

						local S2 = attributes_strings[2] ~= "Empty" and string.split(attributes_strings[2], ";") or {
							"-,-,-,-",
							"-,-,-,-",
							"-,-,-,-",
							"-,-,-,-",
						}

						players_info_1 = S2[1] or "-,-,-,-"
						players_info_2 = S2[2] or "-,-,-,-"
						players_info_3 = S2[3] or "-,-,-,-"
						players_info_4 = S2[4] or "-,-,-,-"
					end

					if challenge_card == "nocards" or challenge_card == "" or challenge_card == "value_pending" then
						challenge_card = ""
					end

					if players_info == "value_pending" then
						players_info = ""
					end

					if progress == "value_pending" then
						progress = ""
					end

					if mission_type == "value_pending" then
						mission_type = ""
					end

					if level_id == OperationsTweakData.IN_LOBBY then
						level_name = self:translate("menu_mission_select_in_lobby")
						job_name = self:translate("menu_mission_select_in_lobby")
					elseif tonumber(mission_type) == OperationsTweakData.JOB_TYPE_OPERATION then
						level_name = ""
						job_name = ""

						local operation_data = tweak_data.operations.missions[job_id]

						if operation_data and operation_data.events and operation_data.events[level_id] then
							level_name = self:translate(tweak_data.operations.missions[job_id].events[level_id].name_id)
							job_name = self:translate(tweak_data.operations.missions[job_id].name_id)
						else
							level_name = "N/A"
							job_name = "N/A"

							if level_id ~= nil and job_id ~= nil then
								Application:error("Level '" .. level_id .. "' can't be found in operation '" .. job_id .. "'.")
							end
						end
					elseif tonumber(mission_type) == OperationsTweakData.JOB_TYPE_RAID then
						local mission_data = tweak_data.operations.missions[level_id]

						level_name = ""

						if mission_data and mission_data.name_id then
							level_name = self:translate(tweak_data.operations.missions[level_id].name_id)
						end

						job_name = self:translate("menu_mission_selected_mission_type_raid")
					end

					local is_friend = false

					if is_win32 and Steam:logged_on() and Steam:friends() then
						for _, friend in ipairs(Steam:friends()) do
							if friend:id() == room.owner_id then
								is_friend = true

								break
							end
						end
					end

					name_id = name_id or "unknown"

					if name_id then
						if not self._active_server_jobs[lroom_Id] then
							if table.size(self._active_jobs) + table.size(self._active_server_jobs) < self._tweak_data.total_active_jobs and table.size(self._active_server_jobs) < self._max_active_server_jobs then
								self._active_server_jobs[lroom_Id] = {
									added = false,
									alive_time = 0,
								}

								self:add_gui_job({
									challenge_card = challenge_card,
									custom_text = room.custom_text,
									difficulty = difficulty,
									difficulty_id = difficulty_id,
									host_name = host_name,
									id = lroom_Id,
									info = room.info,
									is_friend = is_friend,
									job_id = job_id,
									job_name = job_name,
									job_plan = job_plan,
									kick_option = kick_option,
									level_id = level_id,
									level_name = level_name,
									mission_type = mission_type,
									num_plrs = num_plrs,
									players_info = players_info,
									players_info_1 = players_info_1,
									players_info_2 = players_info_2,
									players_info_3 = players_info_3,
									players_info_4 = players_info_4,
									progress = progress,
									room_id = room.room_id,
									state = state,
									state_name = state_name,
									xuid = room.xuid,
								})
							end
						else
							self:update_gui_job({
								challenge_card = challenge_card,
								custom_text = room.custom_text,
								difficulty = difficulty,
								difficulty_id = difficulty_id,
								host_name = host_name,
								id = lroom_Id,
								info = room.info,
								is_friend = is_friend,
								job_id = job_id,
								job_name = job_name,
								job_plan = job_plan,
								kick_option = kick_option,
								level_id = level_id,
								level_name = level_name,
								mission_type = mission_type,
								num_plrs = num_plrs,
								players_info = players_info,
								players_info_1 = players_info_1,
								players_info_2 = players_info_2,
								players_info_3 = players_info_3,
								players_info_4 = players_info_4,
								progress = progress,
								room_id = room.room_id,
								state = state,
								state_name = state_name,
								xuid = room.xuid,
							})
						end
					end
				end
			end
		end

		for id, _ in pairs(dead_list) do
			self._active_server_jobs[id] = nil

			self:remove_gui_job(id)
		end

		if self._table_servers then
			self._table_servers:refresh_data()
			self._server_list_scrollable_area:setup_scroll_area()
			self._table_servers:select_table_row_by_row_idx(1)
			self:_select_game_from_list()

			if self._selected_row_data then
				self:_set_game_description_data(self._selected_row_data[5].value)
				self._game_description_panel:show()
				self._filters_panel:hide()
				self:_filters_set_selected_server_table()
			else
				self._game_description_panel:hide()
				self._filters_panel:show()
			end
		end
	end

	managers.network.matchmake:register_callback("search_lobby", f)
	managers.network.matchmake:start_search_lobbys(friends_only)

	local function usrs_f(success, amount)
		print("usrs_f", success, amount)

		if success then
			self:set_players_online(amount)
		end
	end
end

function MissionJoinGui:add_gui_job(data)
	self._gui_jobs[data.id] = data
end

function MissionJoinGui:update_gui_job(data)
	self._gui_jobs[data.id] = data
end

function MissionJoinGui:remove_gui_job(id)
	self._gui_jobs[id] = nil
end

function MissionJoinGui:set_players_online(amount)
	if self._online_users_count and self._online_users_count:is_alive() then
		self._online_users_count:set_text(self:translate("menu_mission_join_users_online_count", true) .. " " .. amount)
	end
end

function MissionJoinGui:_filters_set_selected_server_table()
	self._filters_active = false

	self._friends_only_button:set_selected(false)
	self._in_camp_servers_only:set_selected(false)
	self._distance_filter_stepper:set_selected(false)
	self._difficulty_filter_stepper:set_selected(false)
	self._mission_filter_stepper:set_selected(false)

	for i = 1, #self._player_controls do
		self._player_controls[i]:set_selected(false)
	end

	self._table_servers:set_selected(true)
end

function MissionJoinGui:_filters_set_selected_filters()
	self._filters_active = true

	self._friends_only_button:set_selected(true)
	self._in_camp_servers_only:set_selected(false)
	self._distance_filter_stepper:set_selected(false)
	self._difficulty_filter_stepper:set_selected(false)
	self._mission_filter_stepper:set_selected(false)

	for i = 1, #self._player_controls do
		self._player_controls[i]:set_selected(false)
	end

	self._table_servers:set_selected(false)
end

function MissionJoinGui:bind_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "_on_refresh"),
			key = Idstring("menu_controller_face_top"),
		},
		{
			callback = callback(self, self, "_on_filter"),
			key = Idstring("menu_controller_face_left"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_mission_join_refresh",
			"menu_legend_mission_join_filter",
			"menu_legend_mission_join_join",
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

function MissionJoinGui:bind_controller_inputs_no_join()
	local bindings = {
		{
			callback = callback(self, self, "_on_refresh"),
			key = Idstring("menu_controller_face_top"),
		},
		{
			callback = callback(self, self, "_on_filter"),
			key = Idstring("menu_controller_face_left"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_mission_join_refresh",
			"menu_legend_mission_join_filter",
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

function MissionJoinGui:bind_controller_inputs_player_description()
	local bindings = {
		{
			callback = callback(self, self, "_on_refresh"),
			key = Idstring("menu_controller_face_top"),
		},
		{
			callback = callback(self, self, "_on_filter"),
			key = Idstring("menu_controller_face_left"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_mission_join_refresh",
			"menu_legend_mission_join_filter",
			{
				translated_text = managers.localization:get_default_macros().BTN_A .. " " .. self:translate("menu_gamercard_widget_label", true),
			},
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

function MissionJoinGui:_on_refresh()
	self:on_click_apply_filters_button()
	self:bind_controller_inputs()

	return true, nil
end

function MissionJoinGui:_on_filter()
	local server_table_selected = self._table_servers:is_selected()
	local have_any_servers = false

	for index, job_data in pairs(self._gui_jobs) do
		have_any_servers = true

		break
	end

	if not self._filters_active or not have_any_servers then
		self:_filters_set_selected_filters()
		self:bind_controller_inputs_no_join()
	else
		self:_filters_set_selected_server_table()
		self:bind_controller_inputs()
	end

	self:on_click_show_filters_button()

	return true, nil
end

function MissionJoinGui:confirm_pressed()
	Application:trace("[MissionJoinGui:confirm_pressed]")

	local server_table_selected = self._table_servers:is_selected()

	if server_table_selected then
		self:on_click_join_button()
	else
		MissionJoinGui.super.confirm_pressed(self)
	end
end

function MissionJoinGui:back_pressed()
	Application:trace("[MissionJoinGui:back_pressed]")
	managers.raid_menu:on_escape()
end
