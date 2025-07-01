HUDTabScreen = HUDTabScreen or class()
HUDTabScreen.X_PADDING = 10
HUDTabScreen.Y_PADDING = 10
HUDTabScreen.BACKGROUND_IMAGE = "secondary_menu"
HUDTabScreen.PROFILE_INFO_W = 384
HUDTabScreen.PROFILE_INFO_H = 160
HUDTabScreen.PROFILE_INFO_BOTTOM_OFFSET = 64
HUDTabScreen.PROFILE_NAME_FONT = tweak_data.gui.fonts.din_compressed
HUDTabScreen.PROFILE_NAME_FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDTabScreen.PROFILE_LEVEL_FONT_SIZE = tweak_data.gui.font_sizes.menu_list
HUDTabScreen.PROFILE_LEVEL_RIGHT_OFFSET = 22
HUDTabScreen.TIMER_W = 512
HUDTabScreen.TIMER_H = 64
HUDTabScreen.TIMER_FONT = tweak_data.gui.fonts.din_compressed
HUDTabScreen.TIMER_FONT_SIZE = tweak_data.gui.font_sizes.size_56
HUDTabScreen.TIMER_Y = 0
HUDTabScreen.TIMER_ICON = "ico_time"
HUDTabScreen.TIMER_ICON_TEXT_DISTANCE = 25
HUDTabScreen.TIMER_PADDING_LEFT = 32
HUDTabScreen.DIFFICULTY_H = 64
HUDTabScreen.DIFFICULTY_FONT = tweak_data.gui.fonts.din_compressed
HUDTabScreen.DIFFICULTY_FONT_SIZE = tweak_data.gui.font_sizes.size_56
HUDTabScreen.DIFFICULTY_Y = 0
HUDTabScreen.DIFFICULTY_ICON_TEXT_DISTANCE = 10
HUDTabScreen.MISSION_INFO_Y = 8
HUDTabScreen.MISSION_INFO_W = 640
HUDTabScreen.MISSION_INFO_H = 64
HUDTabScreen.MISSION_INFO_TEXT_X = 74
HUDTabScreen.MISSION_INFO_TEXT_Y = -2
HUDTabScreen.MISSION_INFO_TEXT_FONT = tweak_data.gui.fonts.din_compressed
HUDTabScreen.MISSION_INFO_TEXT_FONT_SIZE = tweak_data.gui.font_sizes.size_56
HUDTabScreen.MISSION_INFO_TEXT_COLOR = tweak_data.gui.colors.raid_red
HUDTabScreen.LOOT_INFO_W = 416
HUDTabScreen.LOOT_INFO_H = 96
HUDTabScreen.LOOT_INFO_BOTTOM_OFFSET = 134
HUDTabScreen.LOOT_INFO_FONT = tweak_data.gui.fonts.din_compressed
HUDTabScreen.LOOT_INFO_TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDTabScreen.LOOT_INFO_VALUE_FONT_SIZE = tweak_data.gui.font_sizes.size_52
HUDTabScreen.LOOT_INFO_RIBBON_Y = 768
HUDTabScreen.LOOT_INFO_RIBBON_ICON = "rwd_stats_bg"
HUDTabScreen.LOOT_INFO_RIBBON_ICON_CENTER_FROM_RIGHT = 320
HUDTabScreen.LOOT_INFO_RIBBON_CENTER_Y = 800
HUDTabScreen.CARD_INFO_X = 0
HUDTabScreen.CARD_INFO_Y = 103
HUDTabScreen.CARD_INFO_W = 384
HUDTabScreen.CARD_INFO_H = 608
HUDTabScreen.CARD_INFO_TITLE_FONT = tweak_data.gui.fonts.din_compressed
HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDTabScreen.CARD_INFO_TITLE_COLOR = Color.white
HUDTabScreen.CARD_INFO_FAILED_TITLE_COLOR = tweak_data.gui.colors.raid_red
HUDTabScreen.NO_CARD_ICON = "card_pass"
HUDTabScreen.NO_CARD_TEXT_Y = 256
HUDTabScreen.NO_CARD_TEXT_FONT = tweak_data.gui.fonts.lato
HUDTabScreen.NO_CARD_TEXT_FONT_SIZE = tweak_data.gui.font_sizes.size_20
HUDTabScreen.CARD_Y = 64
HUDTabScreen.CARD_W = 168
HUDTabScreen.OBJECTIVES_INFO_Y = 96
HUDTabScreen.NEXT_CHALLENGE_QUEUE_ID = "tab_screen_show_next_challenge"
HUDTabScreen.NEXT_CHALLENGE_DELAY = 4

function HUDTabScreen:init(fullscreen_hud, hud)
	self:_create_background(fullscreen_hud)
	self:_create_map(fullscreen_hud)
	self:_create_panel(hud)
	self:_create_mission_info()
	self:_create_timer()
	self:_create_difficulty()
	self:_create_card_info()
	self:_create_profile_info()
	self:_create_weapon_challenge_info()
	self:_create_loot_info()
	self:_create_objectives_info(hud)
end

function HUDTabScreen:_create_background(fullscreen_hud)
	local background_params = {
		alpha = 0.95,
		halign = "scale",
		name = "tab_screen_background",
		valign = "scale",
		visible = false,
		x = 0,
		y = 0,
		h = fullscreen_hud.panel:h(),
		layer = tweak_data.gui.TAB_SCREEN_LAYER,
		texture = tweak_data.gui.backgrounds[HUDTabScreen.BACKGROUND_IMAGE].texture,
		texture_rect = tweak_data.gui.backgrounds[HUDTabScreen.BACKGROUND_IMAGE].texture_rect,
		w = fullscreen_hud.panel:w(),
	}

	self._background = fullscreen_hud.panel:bitmap(background_params)
end

function HUDTabScreen:_create_background_image()
	if self._background_image then
		self._background_image:parent():remove(self._background_image)

		self._background_image = nil
	end

	local background_image

	if managers.raid_job:is_camp_loaded() then
		background_image = tweak_data.operations.missions.camp.tab_background_image
	else
		local current_job = managers.raid_job:current_job()

		if current_job then
			if current_job.job_type == OperationsTweakData.JOB_TYPE_RAID then
				background_image = tweak_data.operations.missions[current_job.job_id].tab_background_image
			else
				local current_event = current_job.events_index[current_job.current_event]
				local event_data = tweak_data.operations.missions[current_job.job_id].events[current_event]

				background_image = event_data.tab_background_image
			end
		end
	end

	if not background_image then
		return
	end

	local fullscreen_panel = self._background:parent()
	local background_image_params = {
		halign = "scale",
		name = "tab_screen_background_image",
		valign = "scale",
		layer = self._background:layer() + 1,
		texture = background_image,
	}

	self._background_image = fullscreen_panel:bitmap(background_image_params)

	self._background_image:set_center_x(fullscreen_panel:w() / 2)
	self._background_image:set_center_y(fullscreen_panel:h() / 2)
end

function HUDTabScreen:_create_map(fullscreen_hud)
	local map_params = {
		name = "tab_map",
		layer = self._background:layer() + 1,
	}

	self._map = HUDMapTab:new(fullscreen_hud.panel, map_params)
end

function HUDTabScreen:_create_panel(hud)
	local panel_params = {
		halign = "scale",
		name = "tab_screen",
		valign = "scale",
		visible = false,
		x = 0,
		y = 0,
		h = hud.panel:h(),
		layer = tweak_data.gui.TAB_SCREEN_LAYER + 5,
		w = hud.panel:w(),
	}

	self._object = hud.panel:panel(panel_params)
end

function HUDTabScreen:_create_card_info()
	local card_info_panel_params = {
		halign = "left",
		name = "card_info_panel",
		valign = "top",
		h = HUDTabScreen.CARD_INFO_H,
		w = HUDTabScreen.CARD_INFO_W,
		x = HUDTabScreen.CARD_INFO_X,
		y = HUDTabScreen.CARD_INFO_Y,
	}

	self._card_info_panel = self._object:panel(card_info_panel_params)

	local empty_card_panel_params = {
		halign = "scale",
		name = "empty_card_panel",
		valign = "scale",
		x = 0,
		y = 0,
		h = self._card_info_panel:h(),
		w = self._card_info_panel:w(),
	}

	self._empty_card_panel = self._card_info_panel:panel(empty_card_panel_params)

	local empty_card_title_params = {
		align = "left",
		h = 32,
		name = "empty_card_title",
		vertical = "center",
		x = 0,
		y = 0,
		color = HUDTabScreen.CARD_INFO_TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.CARD_INFO_TITLE_FONT, HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE),
		font_size = HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE,
		text = utf8.to_upper(managers.localization:text("hud_empty_challenge_card_title")),
		w = self._empty_card_panel:w(),
	}
	local empty_card_title = self._empty_card_panel:text(empty_card_title_params)
	local empty_slot_texture = tweak_data.gui.icons.cc_empty_slot_small
	local empty_card_image_params = {
		name = "empty_card_image",
		x = 0,
		h = tweak_data.gui:icon_h(HUDTabScreen.NO_CARD_ICON) / tweak_data.gui:icon_w(HUDTabScreen.NO_CARD_ICON) * HUDTabScreen.CARD_W,
		texture = empty_slot_texture.texture,
		texture_rect = empty_slot_texture.texture_rect,
		w = HUDTabScreen.CARD_W,
		y = HUDTabScreen.CARD_Y,
	}
	local empty_card_image = self._empty_card_panel:bitmap(empty_card_image_params)
	local empty_card_text_params = {
		align = "left",
		halign = "scale",
		name = "empty_card_text",
		valign = "scale",
		vertical = "top",
		wrap = true,
		font = tweak_data.gui:get_font_path(HUDTabScreen.NO_CARD_TEXT_FONT, HUDTabScreen.NO_CARD_TEXT_FONT_SIZE),
		font_size = HUDTabScreen.NO_CARD_TEXT_FONT_SIZE,
		h = self._empty_card_panel:h() - HUDTabScreen.NO_CARD_TEXT_Y - HUDTabScreen.CARD_Y,
		text = managers.localization:text("hud_no_challenge_card_text"),
		w = self._empty_card_panel:w(),
		x = empty_card_image:x() + 5,
		y = HUDTabScreen.NO_CARD_TEXT_Y + HUDTabScreen.CARD_Y,
	}
	local empty_card_text = self._empty_card_panel:text(empty_card_text_params)
	local active_card_panel_params = {
		halign = "scale",
		name = "active_card_panel",
		valign = "scale",
		x = 0,
		y = 0,
		h = self._card_info_panel:h(),
		w = self._card_info_panel:w(),
	}

	self._active_card_panel = self._card_info_panel:panel(active_card_panel_params)

	local active_card_title_params = {
		align = "left",
		h = 32,
		name = "active_card_title",
		vertical = "center",
		x = 0,
		y = 0,
		color = HUDTabScreen.CARD_INFO_TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.CARD_INFO_TITLE_FONT, HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE),
		font_size = HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE,
		text = utf8.to_upper(managers.localization:text("hud_active_challenge_card_title")),
		w = self._active_card_panel:w(),
	}
	local active_card_title = self._active_card_panel:text(active_card_title_params)
	local active_card_params = {
		name = "active_card_details",
		x = 0,
		card_image_params = {
			h = tweak_data.gui:icon_h(HUDTabScreen.NO_CARD_ICON) / tweak_data.gui:icon_w(HUDTabScreen.NO_CARD_ICON) * HUDTabScreen.CARD_W,
			w = HUDTabScreen.CARD_W,
		},
		h = self._active_card_panel:h() - HUDTabScreen.CARD_Y,
		w = self._active_card_panel:w(),
		y = HUDTabScreen.CARD_Y,
	}

	self._active_card = HUDCardDetails:new(self._active_card_panel, active_card_params)
end

function HUDTabScreen:_create_profile_info()
	local profile_info_panel_params = {
		halign = "left",
		name = "profile_info_panel",
		valign = "bottom",
		visible = false,
		h = HUDTabScreen.PROFILE_INFO_H,
		w = HUDTabScreen.PROFILE_INFO_W,
		y = self._object:h() - HUDTabScreen.PROFILE_INFO_BOTTOM_OFFSET - HUDTabScreen.PROFILE_INFO_H,
	}

	self._profile_info_panel = self._object:panel(profile_info_panel_params)

	local profile_name_params = {
		align = "left",
		h = 32,
		name = "profile_name",
		text = "",
		vertical = "bottom",
		x = 0,
		y = 0,
		font = tweak_data.gui:get_font_path(HUDTabScreen.PROFILE_NAME_FONT, HUDTabScreen.PROFILE_NAME_FONT_SIZE),
		font_size = HUDTabScreen.PROFILE_NAME_FONT_SIZE,
		w = self._profile_info_panel:w(),
	}
	local profile_name = self._profile_info_panel:text(profile_name_params)
	local details_panel_params = {
		is_root_panel = true,
		name = "profile_details_panel",
		y = 64,
		h = self._profile_info_panel:h() - 64,
	}
	local profile_details_panel = RaidGUIPanel:new(self._profile_info_panel, details_panel_params)
	local class_info_icon_params = {
		icon = "player_panel_class_assault",
		name = "class_icon",
		w = 96,
		color = tweak_data.gui.colors.raid_grey,
		h = profile_details_panel:h(),
		icon_color = Color.white,
		icon_h = tweak_data.gui:icon_h("player_panel_class_assault"),
		text = utf8.to_upper(managers.localization:text("skill_class_assault_name")),
		text_size = tweak_data.gui.font_sizes.size_24,
		top_offset_y = (64 - tweak_data.gui:icon_h("player_panel_class_assault")) / 2,
	}

	self._class_icon = profile_details_panel:info_icon(class_info_icon_params)

	local placeholder_nationality = "british"
	local nationality_info_icon_params = {
		name = "nationality_icon",
		w = 96,
		color = tweak_data.gui.colors.raid_grey,
		h = profile_details_panel:h(),
		icon = "ico_flag_" .. placeholder_nationality,
		icon_color = Color.white,
		icon_h = tweak_data.gui:icon_h("ico_flag_" .. placeholder_nationality),
		text = utf8.to_upper(managers.localization:text("nationality_" .. placeholder_nationality)),
		text_size = tweak_data.gui.font_sizes.size_24,
	}

	self._nationality_icon = profile_details_panel:info_icon(nationality_info_icon_params)

	self._nationality_icon:set_center_x(profile_details_panel:w() / 2)

	local level_info_icon_params = {
		name = "level_text",
		title = "6",
		title_h = 64,
		w = 96,
		y = 7,
		h = profile_details_panel:h() - 7,
		text = utf8.to_upper(managers.localization:text("hud_level")),
		text_color = tweak_data.gui.colors.raid_grey,
		text_size = tweak_data.gui.font_sizes.size_24,
		title_color = tweak_data.gui.colors.raid_white,
		title_size = HUDTabScreen.PROFILE_LEVEL_FONT_SIZE,
	}

	self._level_text = profile_details_panel:info_icon(level_info_icon_params)

	self._level_text:set_center_x(320)

	local class_icon_params = {
		name = "class_icon",
		visible = false,
		texture = tweak_data.gui.icons.player_panel_class_assault.texture,
		texture_rect = tweak_data.gui.icons.player_panel_class_assault.texture_rect,
	}
	local class_icon = self._profile_info_panel:bitmap(class_icon_params)

	class_icon:set_bottom(self._profile_info_panel:h() + 3)

	local initial_nationality_icon = "player_panel_nationality_british"
	local nationality_icon_params = {
		name = "nationality_icon",
		visible = false,
		texture = tweak_data.gui.icons[initial_nationality_icon].texture,
		texture_rect = tweak_data.gui.icons[initial_nationality_icon].texture_rect,
	}
	local nationality_icon = self._profile_info_panel:bitmap(nationality_icon_params)

	nationality_icon:set_bottom(self._profile_info_panel:h() + 3)
	nationality_icon:set_center_x(self._profile_info_panel:w() / 2 + 3)

	local level_text_params = {
		align = "center",
		h = 40,
		name = "level_text",
		text = "6",
		vertical = "bottom",
		visible = false,
		w = 40,
		font = tweak_data.gui:get_font_path(HUDTabScreen.PROFILE_NAME_FONT, HUDTabScreen.PROFILE_LEVEL_FONT_SIZE),
		font_size = HUDTabScreen.PROFILE_LEVEL_FONT_SIZE,
	}
	local level_text = self._profile_info_panel:text(level_text_params)

	level_text:set_bottom(self._profile_info_panel:h() - 3)
	level_text:set_center_x(self._profile_info_panel:w() - HUDTabScreen.PROFILE_LEVEL_RIGHT_OFFSET)
end

function HUDTabScreen:_create_weapon_challenge_info()
	self._weapon_challenge_info = HUDTabWeaponChallenge:new(self._object)

	self._weapon_challenge_info:set_bottom(878)
end

function HUDTabScreen:_create_timer()
	local timer_panel_params = {
		halign = "right",
		name = "timer_panel",
		valign = "top",
		h = HUDTabScreen.TIMER_H,
	}

	self._timer_panel = self._object:panel(timer_panel_params)

	self._timer_panel:set_right(self._object:w())

	local timer_params = {
		align = "right",
		name = "timer",
		text = "00:00",
		vertical = "top",
		font = tweak_data.gui:get_font_path(HUDTabScreen.TIMER_FONT, HUDTabScreen.TIMER_FONT_SIZE),
		font_size = HUDTabScreen.TIMER_FONT_SIZE,
		h = HUDTabScreen.TIMER_H,
		w = HUDTabScreen.TIMER_W,
		y = HUDTabScreen.TIMER_Y,
	}

	self._timer = self._timer_panel:text(timer_params)

	self._timer:set_right(self._timer_panel:w())

	local timer_icon_params = {
		halign = "left",
		name = "timer_icon",
		valign = "center",
		texture = tweak_data.gui.icons[HUDTabScreen.TIMER_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTabScreen.TIMER_ICON].texture_rect,
	}
	local timer_icon = self._timer_panel:bitmap(timer_icon_params)

	timer_icon:set_center_y(self._timer_panel:h() / 2)

	self._last_set_time = 0

	self:set_time(0)
end

function HUDTabScreen:_create_difficulty()
	local difficulty_panel_params = {
		halign = "right",
		name = "difficulty_panel",
		valign = "top",
		h = HUDTabScreen.DIFFICULTY_H,
	}

	self._difficulty_panel = self._object:panel(difficulty_panel_params)

	local difficulty = Global.game_settings.difficulty or Global.DEFAULT_DIFFICULTY
	local difficulty_params = {
		align = "right",
		name = "difficulty",
		vertical = "top",
		font = tweak_data.gui:get_font_path(HUDTabScreen.DIFFICULTY_FONT, HUDTabScreen.DIFFICULTY_FONT_SIZE),
		font_size = HUDTabScreen.DIFFICULTY_FONT_SIZE,
		h = HUDTabScreen.DIFFICULTY_H,
		text = utf8.to_upper(managers.localization:text("menu_" .. difficulty)),
		y = HUDTabScreen.DIFFICULTY_Y,
	}

	self._difficulty = self._difficulty_panel:text(difficulty_params)

	self._difficulty:set_right(self._difficulty_panel:w())

	local difficulty_icon_params = {
		halign = "left",
		name = "difficulty_icon",
		valign = "center",
		texture = tweak_data.gui.icons[difficulty].texture,
		texture_rect = tweak_data.gui.icons[difficulty].texture_rect,
	}
	local difficulty_icon = self._difficulty_panel:bitmap(difficulty_icon_params)

	difficulty_icon:set_center_y(self._difficulty_panel:h() / 2)
	self:set_difficulty(difficulty)
end

function HUDTabScreen:_create_mission_info()
	local mission_info_panel_params = {
		name = "mission_info_panel",
		h = HUDTabScreen.MISSION_INFO_H,
		w = HUDTabScreen.MISSION_INFO_W,
		y = HUDTabScreen.MISSION_INFO_Y,
	}

	self._mission_info_panel = self._object:panel(mission_info_panel_params)

	local temp_mission = "flakturm"
	local temp_mission_icon = tweak_data.operations:mission_data(temp_mission).icon_menu
	local temp_mission_name = tweak_data.operations:mission_data(temp_mission).name_id
	local mission_icon_params = {
		name = "mission_icon",
		x = 0,
		y = 0,
		texture = tweak_data.gui.icons[temp_mission_icon].texture,
		texture_rect = tweak_data.gui.icons[temp_mission_icon].texture_rect,
	}
	local mission_icon = self._mission_info_panel:bitmap(mission_icon_params)

	mission_icon:set_center_y(self._mission_info_panel:h() / 2)

	local mission_name_params = {
		align = "left",
		name = "mission_name",
		vertical = "center",
		color = HUDTabScreen.MISSION_INFO_TEXT_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.MISSION_INFO_TEXT_FONT, HUDTabScreen.MISSION_INFO_TEXT_FONT_SIZE),
		font_size = HUDTabScreen.MISSION_INFO_TEXT_FONT_SIZE,
		h = self._mission_info_panel:h(),
		text = utf8.to_upper(managers.localization:text(temp_mission_name)),
		w = self._mission_info_panel:w() - HUDTabScreen.MISSION_INFO_TEXT_X,
		x = HUDTabScreen.MISSION_INFO_TEXT_X,
		y = HUDTabScreen.MISSION_INFO_TEXT_Y,
	}
	local mission_name_text = self._mission_info_panel:text(mission_name_params)
end

function HUDTabScreen:_create_loot_info()
	local fullscreen_panel = self._background:parent()
	local loot_info_panel_params = {
		halign = "right",
		name = "loot_info_panel",
		valign = "bottom",
		visible = false,
		h = tweak_data.gui:icon_h(HUDTabScreen.LOOT_INFO_RIBBON_ICON),
		layer = tweak_data.gui.TAB_SCREEN_LAYER + 10,
		w = tweak_data.gui:icon_w(HUDTabScreen.LOOT_INFO_RIBBON_ICON),
	}

	self._loot_info_panel = fullscreen_panel:panel(loot_info_panel_params)

	self._loot_info_panel:set_right(fullscreen_panel:w())
	self._loot_info_panel:set_bottom(fullscreen_panel:h() - HUDTabScreen.LOOT_INFO_BOTTOM_OFFSET)

	local loot_ribbon_params = {
		name = "loot_ribbon",
		texture = tweak_data.gui.icons[HUDTabScreen.LOOT_INFO_RIBBON_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTabScreen.LOOT_INFO_RIBBON_ICON].texture_rect,
	}
	local loot_ribbon = self._loot_info_panel:bitmap(loot_ribbon_params)
	local total_loot_panel_params = {
		h = 128,
		halign = "right",
		name = "total_loot_panel",
		valign = "center",
	}
	local total_loot_panel = self._loot_info_panel:panel(total_loot_panel_params)

	total_loot_panel:set_center_y(self._loot_info_panel:h() / 2)

	local total_loot_params = {
		align = "center",
		layer = 1,
		name = "total_loot",
		text = "0000",
		vertical = "center",
		font = tweak_data.gui:get_font_path(HUDTabScreen.LOOT_INFO_FONT, HUDTabScreen.LOOT_INFO_VALUE_FONT_SIZE),
		font_size = HUDTabScreen.LOOT_INFO_VALUE_FONT_SIZE,
	}

	self._total_loot = total_loot_panel:text(total_loot_params)

	local total_loot_title_params = {
		align = "center",
		layer = 1,
		name = "total_loot_title",
		vertical = "center",
		font = tweak_data.gui:get_font_path(HUDTabScreen.LOOT_INFO_FONT, HUDTabScreen.LOOT_INFO_TITLE_FONT_SIZE),
		font_size = HUDTabScreen.LOOT_INFO_TITLE_FONT_SIZE,
		text = utf8.to_upper(managers.localization:text("menu_loot_screen_total_loot")),
	}
	local total_loot_title = total_loot_panel:text(total_loot_title_params)
	local acquired_loot_panel_params = {
		h = 128,
		halign = "right",
		name = "acquired_loot_panel",
		valign = "center",
	}
	local acquired_loot_panel = self._loot_info_panel:panel(acquired_loot_panel_params)

	acquired_loot_panel:set_center_y(self._loot_info_panel:h() / 2)

	local acquired_loot_params = {
		align = "center",
		layer = 1,
		name = "acquired_loot",
		text = "0000",
		vertical = "center",
		font = tweak_data.gui:get_font_path(HUDTabScreen.LOOT_INFO_FONT, HUDTabScreen.LOOT_INFO_VALUE_FONT_SIZE),
		font_size = HUDTabScreen.LOOT_INFO_VALUE_FONT_SIZE,
	}

	self._acquired_loot = acquired_loot_panel:text(acquired_loot_params)

	self._acquired_loot:set_center_y(48)

	local acquired_loot_title_params = {
		align = "center",
		layer = 1,
		name = "acquired_loot_title",
		vertical = "center",
		font = tweak_data.gui:get_font_path(HUDTabScreen.LOOT_INFO_FONT, HUDTabScreen.LOOT_INFO_TITLE_FONT_SIZE),
		font_size = HUDTabScreen.LOOT_INFO_TITLE_FONT_SIZE,
		text = utf8.to_upper(managers.localization:text("menu_loot_screen_acquired_loot")),
	}
	local acquired_loot_title = acquired_loot_panel:text(acquired_loot_title_params)

	self._loot_picked_up = 0
	self._loot_total = 0

	self:_refresh_loot_info()
end

function HUDTabScreen:_create_objectives_info(hud)
	self._objectives = HUDObjectivesTab:new(self._object)

	self._objectives:set_x(self._object:w() - self._objectives:w())
	self._objectives:set_y(HUDTabScreen.OBJECTIVES_INFO_Y)
end

function HUDTabScreen:get_objectives_control()
	return self._objectives
end

function HUDTabScreen:_refresh_mission_info()
	local mission_icon, mission_name

	if managers.raid_job:is_camp_loaded() then
		mission_icon = tweak_data.operations.missions.camp.icon_hud
		mission_name = tweak_data.operations.missions.camp.name_id
	else
		local current_job = managers.raid_job:current_job()

		if not current_job then
			self._mission_info_panel:set_visible(false)

			return
		end

		local job_id = current_job.job_id

		if current_job.job_type == OperationsTweakData.JOB_TYPE_RAID or current_job.job_type == OperationsTweakData.JOB_TYPE_OPERATION and managers.raid_job:is_camp_loaded() then
			mission_icon = current_job.icon_menu
			mission_name = current_job.name_id
		elseif current_job.job_type == OperationsTweakData.JOB_TYPE_OPERATION and not managers.raid_job:is_camp_loaded() then
			local current_event_id = current_job.events_index[current_job.current_event]
			local current_event_data = current_job.events[current_event_id]

			mission_icon = current_event_data.icon_menu
			mission_name = current_event_data.name_id
		end
	end

	self._mission_info_panel:set_visible(true)
	self._mission_info_panel:child("mission_icon"):set_image(tweak_data.gui.icons[mission_icon].texture)
	self._mission_info_panel:child("mission_icon"):set_texture_rect(unpack(tweak_data.gui.icons[mission_icon].texture_rect))
	self._mission_info_panel:child("mission_name"):set_text(utf8.to_upper(managers.localization:text(mission_name)))
end

function HUDTabScreen:_refresh_profile_info()
	local profile_name = managers.network:session():local_peer():name()

	self._profile_info_panel:child("profile_name"):set_text(utf8.to_upper(profile_name))

	local class = managers.skilltree:get_character_profile_class()

	self._class_icon:set_icon("player_panel_class_" .. tostring(class))
	self._class_icon:set_text("skill_class_" .. class .. "_name", {
		color = tweak_data.gui.colors.raid_grey,
	})

	local nationality = managers.player:get_character_profile_nation()

	self._nationality_icon:set_icon("ico_flag_" .. nationality, {
		icon_h = tweak_data.gui:icon_h("ico_flag_" .. nationality),
	})
	self._nationality_icon:set_text("nationality_" .. nationality, {
		color = tweak_data.gui.colors.raid_grey,
	})

	local player_level = managers.experience:current_level()

	self._level_text:set_title(tostring(player_level), {
		color = tweak_data.gui.colors.raid_white,
		font_size = HUDTabScreen.PROFILE_LEVEL_FONT_SIZE,
	})
end

function HUDTabScreen:_refresh_loot_info()
	local current_job = managers.raid_job:current_job()

	if not current_job then
		self._loot_info_panel:set_visible(false)

		return
	end

	self._loot_picked_up = managers.lootdrop:picked_up_current_leg()
	self._loot_total = managers.lootdrop:loot_spawned_current_leg()

	self._acquired_loot:set_text(self._loot_picked_up)
	self._total_loot:set_text(self._loot_total)
	self:_fit_loot_info()

	if self._shown == true then
		self._loot_info_panel:set_visible(true)
	end
end

function HUDTabScreen:_fit_loot_info()
	local total_loot_panel = self._loot_info_panel:child("total_loot_panel")
	local total_loot_title = total_loot_panel:child("total_loot_title")
	local _, _, w, h = self._total_loot:text_rect()

	self._total_loot:set_w(w)
	self._total_loot:set_h(h)

	local _, _, w, h = total_loot_title:text_rect()

	total_loot_title:set_w(w)
	total_loot_title:set_h(h)

	local total_loot_panel_w = 0

	if self._total_loot:w() > total_loot_title:w() then
		total_loot_panel_w = self._total_loot:w()
	else
		total_loot_panel_w = total_loot_title:w()
	end

	total_loot_panel:set_w(total_loot_panel_w)
	self._total_loot:set_center_x(total_loot_panel:w() / 2)
	self._total_loot:set_center_y(48)
	total_loot_title:set_center_x(total_loot_panel:w() / 2)
	total_loot_title:set_center_y(96)

	local acquired_loot_panel = self._loot_info_panel:child("acquired_loot_panel")
	local acquired_loot_title = acquired_loot_panel:child("acquired_loot_title")
	local _, _, w, h = self._acquired_loot:text_rect()

	self._acquired_loot:set_w(w)
	self._acquired_loot:set_h(h)

	local _, _, w, h = acquired_loot_title:text_rect()

	acquired_loot_title:set_w(w)
	acquired_loot_title:set_h(h)

	local acquired_loot_panel_w = 0

	if self._acquired_loot:w() > acquired_loot_title:w() then
		acquired_loot_panel_w = self._acquired_loot:w()
	else
		acquired_loot_panel_w = acquired_loot_title:w()
	end

	acquired_loot_panel:set_w(acquired_loot_panel_w)
	self._acquired_loot:set_center_x(acquired_loot_panel:w() / 2)
	self._acquired_loot:set_center_y(48)
	acquired_loot_title:set_center_x(acquired_loot_panel:w() / 2)
	acquired_loot_title:set_center_y(96)
	total_loot_panel:set_right(self._loot_info_panel:w() - 96)
	acquired_loot_panel:set_right(total_loot_panel:x() - 32)
end

function HUDTabScreen:set_loot_picked_up(amount)
	self._loot_picked_up = amount

	self:_refresh_loot_info()
end

function HUDTabScreen:set_loot_total(amount)
	self._loot_total = amount

	self:_refresh_loot_info()
end

function HUDTabScreen:set_time(time)
	if math.floor(time) < self._last_set_time then
		return
	end

	self._last_set_time = time
	time = math.floor(time)

	local hours = math.floor(time / 3600)

	time = time - hours * 3600

	local minutes = math.floor(time / 60)

	time = time - minutes * 60

	local seconds = math.round(time)
	local text = hours > 0 and string.format("%02d", hours) .. ":" or ""
	local text = text .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds)

	self._timer:set_text(text)

	local _, _, w, _ = self._timer:text_rect()

	self._timer_panel:set_w(w + HUDTabScreen.TIMER_ICON_TEXT_DISTANCE + self._timer_panel:child("timer_icon"):w())
	self._timer_panel:set_right(self._object:w())
	self._timer:set_w(w)
	self._timer:set_right(self._timer_panel:w())

	if self._difficulty_panel then
		self._difficulty_panel:set_right(self._timer_panel:x() - HUDTabScreen.TIMER_PADDING_LEFT)
	end
end

function HUDTabScreen:set_difficulty(difficulty)
	if difficulty == self._current_difficulty then
		return
	end

	self._difficulty:set_text(utf8.to_upper(managers.localization:text("menu_" .. difficulty)))

	local image = tweak_data.gui.icons[difficulty]

	self._difficulty_panel:child("difficulty_icon"):set_image(image.texture, unpack(image.texture_rect))

	local _, _, w, _ = self._difficulty:text_rect()

	self._difficulty_panel:set_w(w + HUDTabScreen.DIFFICULTY_ICON_TEXT_DISTANCE + self._difficulty_panel:child("difficulty_icon"):w())
	self._difficulty_panel:set_right(self._timer_panel:x() - HUDTabScreen.TIMER_PADDING_LEFT)
	self._difficulty:set_w(w)
	self._difficulty:set_right(self._difficulty_panel:w())

	self._current_difficulty = difficulty
end

function HUDTabScreen:_refresh_card_info()
	local active_card = managers.challenge_cards:get_active_card()

	if not active_card then
		self._empty_card_panel:set_visible(true)
		self._active_card_panel:set_visible(false)
	else
		self._empty_card_panel:set_visible(false)
		self._active_card_panel:set_visible(true)
		self._active_card:set_card(active_card)

		local active_card_title = self._active_card_panel:child("active_card_title")

		if active_card.status == ChallengeCardsManager.CARD_STATUS_FAILED then
			active_card_title:set_text(utf8.to_upper(managers.localization:text("hud_active_challenge_card_failed_title")))
			active_card_title:set_color(HUDTabScreen.CARD_INFO_FAILED_TITLE_COLOR)
		else
			active_card_title:set_text(utf8.to_upper(managers.localization:text("hud_active_challenge_card_title")))
			active_card_title:set_color(HUDTabScreen.CARD_INFO_TITLE_COLOR)
		end
	end
end

function HUDTabScreen:_refresh_weapon_challenge_info()
	if not managers.player:player_unit() then
		self._weapon_challenge_info:hide()
		self._profile_info_panel:set_visible(true)

		return
	end

	local equipped_weapon_slot = managers.player:player_unit():inventory():equipped_selection()

	if equipped_weapon_slot == PlayerInventory.SLOT_1 or equipped_weapon_slot == PlayerInventory.SLOT_2 then
		local equipped_weapon = managers.player:player_unit():inventory():equipped_unit():base():get_name_id()

		self._active_weapon_challenges = managers.weapon_skills:get_active_weapon_challenges_for_weapon(equipped_weapon)

		if self._active_weapon_challenges then
			self._weapon_challenge_info:set_challenges(self._active_weapon_challenges)

			self._currently_displayed_weapon_challenge = math.floor(Application:time() / HUDTabScreen.NEXT_CHALLENGE_DELAY) % #self._active_weapon_challenges

			local time_until_next_challenge = HUDTabScreen.NEXT_CHALLENGE_DELAY - (Application:time() - math.floor(Application:time() / HUDTabScreen.NEXT_CHALLENGE_DELAY) * HUDTabScreen.NEXT_CHALLENGE_DELAY)

			self:show_next_weapon_challenge(true, time_until_next_challenge)
			self._weapon_challenge_info:show()
			self._profile_info_panel:set_visible(false)

			return
		end
	end

	self._weapon_challenge_info:hide()
	self._profile_info_panel:set_visible(true)
end

function HUDTabScreen:show_next_weapon_challenge(dont_animate, next_delay)
	self._currently_displayed_weapon_challenge = self._currently_displayed_weapon_challenge % #self._active_weapon_challenges + 1

	self._weapon_challenge_info:set_challenge(self._currently_displayed_weapon_challenge, not dont_animate)

	if #self._active_weapon_challenges > 1 then
		managers.queued_tasks:queue(HUDTabScreen.NEXT_CHALLENGE_QUEUE_ID, self.show_next_weapon_challenge, self, nil, next_delay or HUDTabScreen.NEXT_CHALLENGE_DELAY, nil)
	end
end

function HUDTabScreen:show()
	managers.hud:add_updator("tab", callback(self, self, "update"))

	self._shown = true

	self:_refresh_profile_info()
	self:_refresh_mission_info()
	self:_refresh_loot_info()
	self:_refresh_card_info()
	self:_refresh_weapon_challenge_info()
	self:set_difficulty(Global.game_settings.difficulty)

	local current_level = self:_get_current_player_level()

	if self:_current_level_has_map() then
		self._map:show()
	end

	self._background:set_visible(true)
	self._object:set_visible(true)

	if self._grid_panel then
		self._grid_panel:set_visible(true)
	end
end

function HUDTabScreen:update()
	self._loot_info_panel:set_bottom(self._background:parent():h() - HUDTabScreen.LOOT_INFO_BOTTOM_OFFSET)
end

function HUDTabScreen:hide()
	managers.hud:remove_updator("tab")

	self._shown = false

	self._background:set_visible(false)
	self._loot_info_panel:set_visible(false)
	self._object:set_visible(false)
	self._map:hide()
	managers.queued_tasks:unqueue(HUDTabScreen.NEXT_CHALLENGE_QUEUE_ID)

	if self._grid_panel then
		self._grid_panel:set_visible(false)
	end
end

function HUDTabScreen:refresh_peers()
	self._map:refresh_peers()
end

function HUDTabScreen:add_waypoint(waypoint_data)
	self._map:add_waypoint(waypoint_data)
end

function HUDTabScreen:remove_waypoint(id)
	self._map:remove_waypoint(id)
end

function HUDTabScreen:peer_enter_vehicle(peer_id)
	self._map:peer_enter_vehicle(peer_id)
end

function HUDTabScreen:peer_exit_vehicle(peer_id)
	self._map:peer_exit_vehicle(peer_id)
end

function HUDTabScreen:is_shown()
	return self._object:visible()
end

function HUDTabScreen:_current_level_has_map()
	local player_world = self:_get_current_player_level()

	if player_world and tweak_data.levels[player_world].map then
		return true
	end

	return false
end

function HUDTabScreen:_get_current_player_level()
	local current_job = managers.raid_job:current_job()

	if not current_job or managers.raid_job:is_camp_loaded() then
		return nil
	end

	if current_job.job_type == OperationsTweakData.JOB_TYPE_OPERATION then
		local current_event_id = current_job.events_index[current_job.current_event]
		local current_event = current_job.events[current_event_id]

		return current_event.level_id
	elseif current_job.job_type == OperationsTweakData.JOB_TYPE_RAID then
		return current_job.level_id
	end

	return nil
end
