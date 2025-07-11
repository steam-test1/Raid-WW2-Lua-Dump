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
HUDTabScreen.MISSION_INFO_Y = 0
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
HUDTabScreen.LOOT_INFO_TITLE_FONT_SIZE = tweak_data.gui.font_sizes.extra_small
HUDTabScreen.LOOT_INFO_TITLE_COLOR = tweak_data.gui.colors.raid_grey_effects
HUDTabScreen.LOOT_INFO_VALUE_FONT_SIZE = tweak_data.gui.font_sizes.size_32
HUDTabScreen.LOOT_INFO_VALUE_COLOR = tweak_data.gui.colors.raid_dirty_white
HUDTabScreen.LOOT_INFO_RIBBON_Y = 768
HUDTabScreen.LOOT_INFO_RIBBON_ICON = "rwd_stats_bg"
HUDTabScreen.LOOT_INFO_RIBBON_ICON_CENTER_FROM_RIGHT = 320
HUDTabScreen.LOOT_INFO_RIBBON_CENTER_Y = 800
HUDTabScreen.CARD_INFO_X = 0
HUDTabScreen.CARD_INFO_Y = 128
HUDTabScreen.CARD_INFO_W = 384
HUDTabScreen.CARD_INFO_H = 608
HUDTabScreen.CARD_INFO_TITLE_FONT = tweak_data.gui.fonts.din_compressed
HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDTabScreen.CARD_INFO_TITLE_COLOR = tweak_data.gui.colors.raid_dirty_white
HUDTabScreen.CARD_INFO_FAILED_TITLE_COLOR = tweak_data.gui.colors.raid_red
HUDTabScreen.NO_CARD_ICON = "card_pass"
HUDTabScreen.NO_CARD_TEXT_Y = 272
HUDTabScreen.NO_CARD_TEXT_FONT = tweak_data.gui.fonts.lato
HUDTabScreen.NO_CARD_TEXT_FONT_SIZE = tweak_data.gui.font_sizes.size_20
HUDTabScreen.CARD_Y = 48
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
	self:_create_progression_timer()
	self:_create_card_info()
	self:_create_profile_info()
	self:_create_weapon_challenge_info()
	self:_create_loot_info()
	self:_create_greed_bar()
	self:_create_objectives_info(hud)
	self:set_current_greed_amount(managers.greed:current_loot_counter())
end

function HUDTabScreen:_create_background(fullscreen_hud)
	local background_params = {
		alpha = 0.9,
		color = tweak_data.gui.colors.raid_black,
		h = fullscreen_hud.panel:h(),
		halign = "scale",
		layer = tweak_data.gui.TAB_SCREEN_LAYER,
		name = "tab_screen_background",
		valign = "scale",
		visible = false,
		w = fullscreen_hud.panel:w(),
		x = 0,
		y = 0,
	}

	self._background = fullscreen_hud.panel:rect(background_params)
end

function HUDTabScreen:_create_background_image()
	return
end

function HUDTabScreen:_create_map(fullscreen_hud)
	local map_params = {
		layer = self._background:layer() + 1,
		name = "tab_map",
	}

	self._map = HUDMapTab:new(fullscreen_hud.panel, map_params)
end

function HUDTabScreen:_create_panel(hud)
	local panel_params = {
		h = hud.panel:h(),
		halign = "scale",
		layer = tweak_data.gui.TAB_SCREEN_LAYER + 5,
		name = "tab_screen",
		valign = "scale",
		visible = false,
		w = hud.panel:w(),
		x = 0,
		y = 0,
	}

	self._object = hud.panel:panel(panel_params)
end

function HUDTabScreen:_create_card_info()
	local card_info_panel_params = {
		h = HUDTabScreen.CARD_INFO_H,
		halign = "left",
		name = "card_info_panel",
		valign = "top",
		w = HUDTabScreen.CARD_INFO_W,
		x = HUDTabScreen.CARD_INFO_X,
		y = HUDTabScreen.CARD_INFO_Y,
	}

	self._card_info_panel = self._object:panel(card_info_panel_params)

	local empty_card_panel_params = {
		h = self._card_info_panel:h(),
		halign = "scale",
		name = "empty_card_panel",
		valign = "scale",
		w = self._card_info_panel:w(),
		x = 0,
		y = 0,
	}

	self._empty_card_panel = self._card_info_panel:panel(empty_card_panel_params)

	local empty_card_title_params = {
		align = "left",
		color = HUDTabScreen.CARD_INFO_TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.CARD_INFO_TITLE_FONT, HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE),
		font_size = HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE,
		h = 32,
		name = "empty_card_title",
		text = utf8.to_upper(managers.localization:text("hud_empty_challenge_card_title")),
		vertical = "center",
		w = self._empty_card_panel:w(),
		x = 0,
		y = 0,
	}
	local empty_card_title = self._empty_card_panel:text(empty_card_title_params)
	local empty_slot_texture = tweak_data.gui.icons.cc_empty_slot_small
	local empty_card_image_params = {
		h = HUDTabScreen.CARD_H,
		name = "empty_card_image",
		texture = empty_slot_texture.texture,
		texture_rect = empty_slot_texture.texture_rect,
		w = HUDTabScreen.CARD_W,
		x = 0,
		y = HUDTabScreen.CARD_Y,
	}
	local empty_card_image = self._empty_card_panel:bitmap(empty_card_image_params)
	local empty_card_text_params = {
		align = "left",
		color = HUDTabScreen.CARD_INFO_TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.NO_CARD_TEXT_FONT, HUDTabScreen.NO_CARD_TEXT_FONT_SIZE),
		font_size = HUDTabScreen.NO_CARD_TEXT_FONT_SIZE,
		h = self._empty_card_panel:h() - HUDTabScreen.NO_CARD_TEXT_Y - HUDTabScreen.CARD_Y,
		halign = "scale",
		name = "empty_card_text",
		text = managers.localization:text("hud_no_challenge_card_text"),
		valign = "scale",
		vertical = "top",
		w = self._empty_card_panel:w(),
		wrap = true,
		x = empty_card_image:x() + 5,
		y = HUDTabScreen.NO_CARD_TEXT_Y + HUDTabScreen.CARD_Y,
	}
	local empty_card_text = self._empty_card_panel:text(empty_card_text_params)
	local active_card_panel_params = {
		h = self._card_info_panel:h(),
		halign = "scale",
		name = "active_card_panel",
		valign = "scale",
		w = self._card_info_panel:w(),
		x = 0,
		y = 0,
	}

	self._active_card_panel = self._card_info_panel:panel(active_card_panel_params)

	local active_card_title_params = {
		align = "left",
		color = HUDTabScreen.CARD_INFO_TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.CARD_INFO_TITLE_FONT, HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE),
		font_size = HUDTabScreen.CARD_INFO_TITLE_FONT_SIZE,
		h = 32,
		name = "active_card_title",
		text = utf8.to_upper(managers.localization:text("hud_active_challenge_card_title")),
		vertical = "center",
		w = self._active_card_panel:w(),
		x = 0,
		y = 0,
	}
	local active_card_title = self._active_card_panel:text(active_card_title_params)
	local active_card_params = {
		card_image_params = {
			h = HUDTabScreen.CARD_H,
			w = HUDTabScreen.CARD_W,
		},
		h = self._active_card_panel:h() - HUDTabScreen.CARD_Y,
		name = "active_card_details",
		w = self._active_card_panel:w(),
		x = 0,
		y = HUDTabScreen.CARD_Y,
	}

	self._active_card = HUDCardDetails:new(self._active_card_panel, active_card_params)
end

function HUDTabScreen:_create_profile_info()
	local profile_info_panel_params = {
		h = HUDTabScreen.PROFILE_INFO_H,
		halign = "left",
		name = "profile_info_panel",
		valign = "bottom",
		visible = false,
		w = HUDTabScreen.PROFILE_INFO_W,
		y = self._object:h() - HUDTabScreen.PROFILE_INFO_BOTTOM_OFFSET - HUDTabScreen.PROFILE_INFO_H,
	}

	self._profile_info_panel = self._object:panel(profile_info_panel_params)

	local profile_name_params = {
		align = "left",
		font = tweak_data.gui:get_font_path(HUDTabScreen.PROFILE_NAME_FONT, HUDTabScreen.PROFILE_NAME_FONT_SIZE),
		font_size = HUDTabScreen.PROFILE_NAME_FONT_SIZE,
		h = 32,
		name = "profile_name",
		text = "",
		vertical = "bottom",
		w = self._profile_info_panel:w(),
		x = 0,
		y = 0,
	}
	local profile_name = self._profile_info_panel:text(profile_name_params)
	local details_panel_params = {
		h = self._profile_info_panel:h() - 64,
		is_root_panel = true,
		name = "profile_details_panel",
		y = 64,
	}
	local profile_details_panel = RaidGUIPanel:new(self._profile_info_panel, details_panel_params)
	local class_info_icon_params = {
		color = tweak_data.gui.colors.raid_grey,
		h = profile_details_panel:h(),
		icon = "player_panel_class_assault",
		icon_color = Color.white,
		icon_h = tweak_data.gui:icon_h("player_panel_class_assault"),
		name = "class_icon",
		text = utf8.to_upper(managers.localization:text("skill_class_assault_name")),
		text_size = tweak_data.gui.font_sizes.size_24,
		top_offset_y = (64 - tweak_data.gui:icon_h("player_panel_class_assault")) / 2,
		w = 96,
	}

	self._class_icon = profile_details_panel:info_icon(class_info_icon_params)

	local placeholder_nationality = "british"
	local nationality_info_icon_params = {
		color = tweak_data.gui.colors.raid_grey,
		h = profile_details_panel:h(),
		icon = "ico_flag_" .. placeholder_nationality,
		icon_color = Color.white,
		icon_h = tweak_data.gui:icon_h("ico_flag_" .. placeholder_nationality),
		name = "nationality_icon",
		text = utf8.to_upper(managers.localization:text("nationality_" .. placeholder_nationality)),
		text_size = tweak_data.gui.font_sizes.size_24,
		w = 96,
	}

	self._nationality_icon = profile_details_panel:info_icon(nationality_info_icon_params)

	self._nationality_icon:set_center_x(profile_details_panel:w() / 2)

	local level_info_icon_params = {
		h = profile_details_panel:h() - 7,
		name = "level_text",
		text = utf8.to_upper(managers.localization:text("hud_level")),
		text_color = tweak_data.gui.colors.raid_grey,
		text_size = tweak_data.gui.font_sizes.size_24,
		title = "6",
		title_color = tweak_data.gui.colors.raid_white,
		title_h = 64,
		title_size = HUDTabScreen.PROFILE_LEVEL_FONT_SIZE,
		w = 96,
		y = 7,
	}

	self._level_text = profile_details_panel:info_icon(level_info_icon_params)

	self._level_text:set_center_x(320)

	local class_icon_params = {
		name = "class_icon",
		texture = tweak_data.gui.icons.player_panel_class_assault.texture,
		texture_rect = tweak_data.gui.icons.player_panel_class_assault.texture_rect,
		visible = false,
	}
	local class_icon = self._profile_info_panel:bitmap(class_icon_params)

	class_icon:set_bottom(self._profile_info_panel:h() + 3)

	local initial_nationality_icon = "player_panel_nationality_british"
	local nationality_icon_params = {
		name = "nationality_icon",
		texture = tweak_data.gui.icons[initial_nationality_icon].texture,
		texture_rect = tweak_data.gui.icons[initial_nationality_icon].texture_rect,
		visible = false,
	}
	local nationality_icon = self._profile_info_panel:bitmap(nationality_icon_params)

	nationality_icon:set_bottom(self._profile_info_panel:h() + 3)
	nationality_icon:set_center_x(self._profile_info_panel:w() / 2 + 3)

	local level_text_params = {
		align = "center",
		font = tweak_data.gui:get_font_path(HUDTabScreen.PROFILE_NAME_FONT, HUDTabScreen.PROFILE_LEVEL_FONT_SIZE),
		font_size = HUDTabScreen.PROFILE_LEVEL_FONT_SIZE,
		h = 40,
		name = "level_text",
		text = "6",
		vertical = "bottom",
		visible = false,
		w = 40,
	}
	local level_text = self._profile_info_panel:text(level_text_params)

	level_text:set_bottom(self._profile_info_panel:h() - 3)
	level_text:set_center_x(self._profile_info_panel:w() - HUDTabScreen.PROFILE_LEVEL_RIGHT_OFFSET)

	local profile_info_panel_params = {
		h = HUDTabScreen.PROFILE_INFO_H,
		halign = "left",
		name = "profile_info_panel",
		valign = "bottom",
		visible = false,
		w = HUDTabScreen.PROFILE_INFO_W,
		y = self._object:h() - HUDTabScreen.PROFILE_INFO_BOTTOM_OFFSET - HUDTabScreen.PROFILE_INFO_H,
	}

	self._profile_info_panel = self._object:panel(profile_info_panel_params)

	local profile_name_params = {
		align = "left",
		font = tweak_data.gui:get_font_path(HUDTabScreen.PROFILE_NAME_FONT, HUDTabScreen.PROFILE_NAME_FONT_SIZE),
		font_size = HUDTabScreen.PROFILE_NAME_FONT_SIZE,
		h = 32,
		name = "profile_name",
		text = "",
		vertical = "bottom",
		w = self._profile_info_panel:w(),
		x = 0,
		y = 0,
	}
	local profile_name = self._profile_info_panel:text(profile_name_params)
	local details_panel_params = {
		h = self._profile_info_panel:h() - 64,
		is_root_panel = true,
		name = "profile_details_panel",
		y = 64,
	}
	local profile_details_panel = RaidGUIPanel:new(self._profile_info_panel, details_panel_params)
	local class_info_icon_params = {
		color = tweak_data.gui.colors.raid_grey,
		h = profile_details_panel:h(),
		icon = "player_panel_class_assault",
		icon_color = Color.white,
		icon_h = tweak_data.gui:icon_h("player_panel_class_assault"),
		name = "class_icon",
		text = utf8.to_upper(managers.localization:text("skill_class_assault_name")),
		text_size = tweak_data.gui.font_sizes.size_24,
		top_offset_y = (64 - tweak_data.gui:icon_h("player_panel_class_assault")) / 2,
		w = 96,
	}

	self._class_icon = profile_details_panel:info_icon(class_info_icon_params)

	local placeholder_nationality = "british"
	local nationality_info_icon_params = {
		color = tweak_data.gui.colors.raid_grey,
		h = profile_details_panel:h(),
		icon = "ico_flag_" .. placeholder_nationality,
		icon_color = Color.white,
		icon_h = tweak_data.gui:icon_h("ico_flag_" .. placeholder_nationality),
		name = "nationality_icon",
		text = utf8.to_upper(managers.localization:text("nationality_" .. placeholder_nationality)),
		text_size = tweak_data.gui.font_sizes.size_24,
		w = 96,
	}

	self._nationality_icon = profile_details_panel:info_icon(nationality_info_icon_params)

	self._nationality_icon:set_center_x(profile_details_panel:w() / 2)

	local level_info_icon_params = {
		h = profile_details_panel:h() - 7,
		name = "level_text",
		text = utf8.to_upper(managers.localization:text("hud_level")),
		text_color = tweak_data.gui.colors.raid_grey,
		text_size = tweak_data.gui.font_sizes.size_24,
		title = "6",
		title_color = tweak_data.gui.colors.raid_white,
		title_h = 64,
		title_size = HUDTabScreen.PROFILE_LEVEL_FONT_SIZE,
		w = 96,
		y = 7,
	}

	self._level_text = profile_details_panel:info_icon(level_info_icon_params)

	self._level_text:set_center_x(320)

	local class_icon_params = {
		name = "class_icon",
		texture = tweak_data.gui.icons.player_panel_class_assault.texture,
		texture_rect = tweak_data.gui.icons.player_panel_class_assault.texture_rect,
		visible = false,
	}
	local class_icon = self._profile_info_panel:bitmap(class_icon_params)

	class_icon:set_bottom(self._profile_info_panel:h() + 3)

	local initial_nationality_icon = "player_panel_nationality_british"
	local nationality_icon_params = {
		name = "nationality_icon",
		texture = tweak_data.gui.icons[initial_nationality_icon].texture,
		texture_rect = tweak_data.gui.icons[initial_nationality_icon].texture_rect,
		visible = false,
	}
	local nationality_icon = self._profile_info_panel:bitmap(nationality_icon_params)

	nationality_icon:set_bottom(self._profile_info_panel:h() + 3)
	nationality_icon:set_center_x(self._profile_info_panel:w() / 2 + 3)

	local level_text_params = {
		align = "center",
		font = tweak_data.gui:get_font_path(HUDTabScreen.PROFILE_NAME_FONT, HUDTabScreen.PROFILE_LEVEL_FONT_SIZE),
		font_size = HUDTabScreen.PROFILE_LEVEL_FONT_SIZE,
		h = 40,
		name = "level_text",
		text = "6",
		vertical = "bottom",
		visible = false,
		w = 40,
	}
	local level_text = self._profile_info_panel:text(level_text_params)

	level_text:set_bottom(self._profile_info_panel:h() - 3)
	level_text:set_center_x(self._profile_info_panel:w() - HUDTabScreen.PROFILE_LEVEL_RIGHT_OFFSET)
end

function HUDTabScreen:_create_weapon_challenge_info()
	self._weapon_challenge_info = HUDTabWeaponChallenge:new(self._object)

	self._weapon_challenge_info:set_bottom(926)
end

function HUDTabScreen:_create_timer()
	local timer_panel_params = {
		h = HUDTabScreen.TIMER_H,
		halign = "right",
		name = "timer_panel",
		valign = "top",
	}

	self._timer_panel = self._object:panel(timer_panel_params)

	self._timer_panel:set_right(self._object:w())

	local timer_params = {
		align = "right",
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui:get_font_path(HUDTabScreen.TIMER_FONT, HUDTabScreen.TIMER_FONT_SIZE),
		font_size = HUDTabScreen.TIMER_FONT_SIZE,
		h = HUDTabScreen.TIMER_H,
		name = "timer",
		text = "00:00",
		vertical = "top",
		w = HUDTabScreen.TIMER_W,
		y = HUDTabScreen.TIMER_Y,
	}

	self._timer = self._timer_panel:text(timer_params)

	self._timer:set_right(self._timer_panel:w())

	local timer_icon_params = {
		halign = "left",
		name = "timer_icon",
		texture = tweak_data.gui.icons[HUDTabScreen.TIMER_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTabScreen.TIMER_ICON].texture_rect,
		valign = "center",
	}
	local timer_icon = self._timer_panel:bitmap(timer_icon_params)

	timer_icon:set_center_y(self._timer_panel:h() / 2)

	self._last_set_time = 0

	self:set_time(0)
end

function HUDTabScreen:_create_progression_timer()
	local progression_timer_panel_params = {
		h = 64,
		halign = "right",
		name = "progression_timer_panel",
		valign = "top",
	}

	self._progression_timer_panel = self._object:panel(progression_timer_panel_params)

	self._progression_timer_panel:set_right(self._timer_panel:x())

	local separator_params = {
		color = tweak_data.gui.colors.raid_dark_grey,
		h = 52,
		halign = "right",
		valign = "center",
		w = 2,
	}
	local separator = self._progression_timer_panel:rect(separator_params)

	separator:set_center_x(self._progression_timer_panel:w() - 48)
	separator:set_center_y(self._progression_timer_panel:h() / 2)

	local content_panel_params = {
		halign = "left",
		name = "progression_timer_content_panel",
		valign = "center",
		x = 30,
	}

	self._progression_timer_content_panel = self._progression_timer_panel:panel(content_panel_params)

	local progression_timer_icon_params = {
		color = tweak_data.gui.colors.raid_dirty_white,
		halign = "left",
		name = "progression_timer_icon",
		texture = tweak_data.gui.icons.missions_raids_category_menu.texture,
		texture_rect = tweak_data.gui.icons.missions_raids_category_menu.texture_rect,
		valign = "center",
	}
	local progression_timer_icon = self._progression_timer_content_panel:bitmap(progression_timer_icon_params)

	progression_timer_icon:set_center_y(self._progression_timer_content_panel:h() / 2)

	local is_final_unlock_cycle = managers.progression:at_final_unlock_cycle()
	local timer_title_params = {
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.din_compressed, tweak_data.gui.font_sizes.small),
		font_size = tweak_data.gui.font_sizes.small,
		h = 32,
		halign = "left",
		name = "progression_timer_title",
		text = utf8.to_upper(managers.localization:text(is_final_unlock_cycle and "raid_final_raids_in_title" or "raid_next_raid_in_title")),
		vertical = "center",
		x = 70,
	}
	local timer_title = self._progression_timer_content_panel:text(timer_title_params)
	local timer_description_params = {
		color = tweak_data.gui.colors.raid_grey_effects,
		font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.din_compressed, tweak_data.gui.font_sizes.size_20),
		font_size = tweak_data.gui.font_sizes.size_20,
		h = 32,
		halign = "left",
		name = "progression_timer_description",
		text = utf8.to_upper(managers.localization:text(is_final_unlock_cycle and "raid_final_raids_in_description" or "raid_next_raid_in_description")),
		vertical = "center",
		x = 70,
	}
	local timer_description = self._progression_timer_content_panel:text(timer_description_params)

	timer_description:set_bottom(self._progression_timer_content_panel:h())

	local timer_params = {
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.din_compressed, tweak_data.gui.font_sizes.small),
		font_size = tweak_data.gui.font_sizes.small,
		h = 32,
		halign = "right",
		horizontal = "right",
		name = "progression_timer_timer",
		text = "",
		vertical = "center",
	}
	local timer = self._progression_timer_content_panel:text(timer_params)
end

function HUDTabScreen:_create_mission_info()
	local mission_info_panel_params = {
		h = HUDTabScreen.MISSION_INFO_H,
		name = "mission_info_panel",
		w = HUDTabScreen.MISSION_INFO_W,
		y = HUDTabScreen.MISSION_INFO_Y,
	}

	self._mission_info_panel = self._object:panel(mission_info_panel_params)

	local temp_mission = "clear_skies"
	local temp_mission_icon = tweak_data.operations:mission_data(temp_mission).icon_menu
	local temp_mission_name = tweak_data.operations:mission_data(temp_mission).name_id
	local mission_icon_params = {
		name = "mission_icon",
		texture = tweak_data.gui.icons[temp_mission_icon].texture,
		texture_rect = tweak_data.gui.icons[temp_mission_icon].texture_rect,
		x = 0,
		y = 0,
	}
	local mission_icon = self._mission_info_panel:bitmap(mission_icon_params)

	mission_icon:set_center_y(self._mission_info_panel:h() / 2)

	local mission_name_params = {
		align = "left",
		color = HUDTabScreen.MISSION_INFO_TEXT_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.MISSION_INFO_TEXT_FONT, HUDTabScreen.MISSION_INFO_TEXT_FONT_SIZE),
		font_size = HUDTabScreen.MISSION_INFO_TEXT_FONT_SIZE,
		h = self._mission_info_panel:h(),
		name = "mission_name",
		text = utf8.to_upper(managers.localization:text(temp_mission_name)),
		vertical = "center",
		w = self._mission_info_panel:w() - HUDTabScreen.MISSION_INFO_TEXT_X,
		x = HUDTabScreen.MISSION_INFO_TEXT_X,
		y = HUDTabScreen.MISSION_INFO_TEXT_Y,
	}
	local mission_name_text = self._mission_info_panel:text(mission_name_params)
	local mission_name_small_params = {
		align = "left",
		color = HUDTabScreen.MISSION_INFO_TEXT_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.MISSION_INFO_TEXT_FONT, tweak_data.gui.font_sizes.small),
		font_size = tweak_data.gui.font_sizes.small,
		h = 32,
		name = "mission_name_small",
		text = utf8.to_upper(managers.localization:text(temp_mission_name)),
		vertical = "center",
		visible = false,
		w = self._mission_info_panel:w() - HUDTabScreen.MISSION_INFO_TEXT_X,
		x = HUDTabScreen.MISSION_INFO_TEXT_X,
		y = 0,
	}
	local mission_name_small_text = self._mission_info_panel:text(mission_name_small_params)
	local difficulty_params = {
		amount = tweak_data:number_of_difficulties(),
		name = "mission_difficulty",
	}

	self._difficulty_indicator = RaidGuiControlDifficultyStars:new(self._mission_info_panel, difficulty_params)

	self._difficulty_indicator:set_x(mission_name_small_text:x())
	self._difficulty_indicator:set_center_y(48)

	local current_difficulty = tweak_data:difficulty_to_index(Global.game_settings.difficulty)

	self._difficulty_indicator:set_active_difficulty(current_difficulty)
end

function HUDTabScreen:_create_loot_info()
	local loot_panel_params = {
		h = 96,
		halign = "right",
		layer = tweak_data.gui.TAB_SCREEN_LAYER + 10,
		name = "loot_info_panel",
		valing = "bottom",
		visible = false,
		w = 416,
	}

	self._loot_info_panel = self._object:panel(loot_panel_params)

	self._loot_info_panel:set_right(self._object:w())
	self._loot_info_panel:set_bottom(self._object:h())

	local dog_tag_panel_params = {
		h = 96,
		halign = "left",
		name = "dog_tag_panel",
		valign = "bottom",
		visible = false,
		w = 224,
	}

	self._dog_tag_panel = self._loot_info_panel:panel(dog_tag_panel_params)

	local dog_tag_icon_params = {
		name = "dog_tag_icon",
		texture = tweak_data.gui.icons.rewards_dog_tags_small.texture,
		texture_rect = tweak_data.gui.icons.rewards_dog_tags_small.texture_rect,
	}
	local dog_tag_icon = self._dog_tag_panel:bitmap(dog_tag_icon_params)

	dog_tag_icon:set_center_x(48)
	dog_tag_icon:set_center_y(self._dog_tag_panel:h() / 2)

	local dog_tag_amount_params = {
		align = "center",
		color = HUDTabScreen.LOOT_INFO_VALUE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.LOOT_INFO_FONT, HUDTabScreen.LOOT_INFO_VALUE_FONT_SIZE),
		font_size = HUDTabScreen.LOOT_INFO_VALUE_FONT_SIZE,
		h = 64,
		name = "dog_tag_amount",
		text = "0 / 0",
		vertical = "center",
		w = 160,
	}

	self._dog_tag_amount = self._dog_tag_panel:text(dog_tag_amount_params)

	self._dog_tag_amount:set_center_x(144)
	self._dog_tag_amount:set_center_y(32)

	local dog_tag_title_params = {
		align = "center",
		color = HUDTabScreen.LOOT_INFO_TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabScreen.LOOT_INFO_FONT, HUDTabScreen.LOOT_INFO_TITLE_FONT_SIZE),
		font_size = HUDTabScreen.LOOT_INFO_TITLE_FONT_SIZE,
		h = 32,
		name = "dog_tag_title",
		text = utf8.to_upper(managers.localization:text("hud_dog_tags")),
		vertical = "center",
		w = 128,
	}
	local dog_tag_title = self._dog_tag_panel:text(dog_tag_title_params)

	dog_tag_title:set_center_x(144)
	dog_tag_title:set_center_y(64)

	self._loot_picked_up = 0
	self._loot_total = 0

	self:_refresh_loot_info()
end

function HUDTabScreen:_create_greed_bar()
	self._greed_bar = HUDTabGreedBar:new(self._loot_info_panel, {})

	self._greed_bar:set_right(self._loot_info_panel:w())
end

function HUDTabScreen:on_greed_loot_picked_up(old_progress, new_progress)
	self._greed_bar:change_progress(old_progress, new_progress)
end

function HUDTabScreen:set_current_greed_amount(amount)
	self._greed_bar:set_current_greed_amount(amount)
end

function HUDTabScreen:reset_greed_indicator()
	self._greed_bar:reset_state()
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
	local control_mission_name = self._mission_info_panel:child("mission_name")
	local control_mission_name_small = self._mission_info_panel:child("mission_name_small")

	if managers.raid_job:is_camp_loaded() then
		mission_icon = tweak_data.operations.missions.camp.icon_hud
		mission_name = tweak_data.operations.missions.camp.name_id

		control_mission_name_small:set_text(utf8.to_upper(managers.localization:text(mission_name)))

		local current_difficulty = tweak_data:difficulty_to_index(Global.game_settings.difficulty)

		self._difficulty_indicator:set_active_difficulty(current_difficulty)

		self._current_difficulty = current_difficulty

		control_mission_name:set_visible(false)
		control_mission_name_small:set_visible(true)
		self._difficulty_indicator:set_visible(true)
	else
		local current_job = managers.raid_job:current_job()

		if not current_job then
			self._mission_info_panel:set_visible(false)

			return
		end

		local job_id = current_job.job_id

		if current_job.job_type == OperationsTweakData.JOB_TYPE_RAID or current_job.job_type == OperationsTweakData.JOB_TYPE_OPERATION and managers.raid_job:is_camp_loaded() then
			mission_icon = current_job.icon_menu
			mission_name = utf8.to_upper(managers.localization:text(current_job.name_id))
		elseif current_job.job_type == OperationsTweakData.JOB_TYPE_OPERATION and not managers.raid_job:is_camp_loaded() then
			local current_event_id = current_job.events_index[current_job.current_event]
			local current_event_data = current_job.events[current_event_id]

			mission_icon = current_event_data.icon_menu
			mission_name = utf8.to_upper(managers.localization:text(current_job.name_id)) .. " " .. tostring(current_job.current_event) .. "/" .. tostring(#current_job.events_index) .. ": " .. utf8.to_upper(managers.localization:text(current_event_data.name_id))
		end

		control_mission_name_small:set_text(mission_name)

		local current_difficulty = tweak_data:difficulty_to_index(Global.game_settings.difficulty)

		self._difficulty_indicator:set_active_difficulty(current_difficulty)

		self._current_difficulty = current_difficulty

		control_mission_name:set_visible(false)
		control_mission_name_small:set_visible(true)
		self._difficulty_indicator:set_visible(true)
	end

	self._mission_info_panel:set_visible(true)
	self._mission_info_panel:child("mission_icon"):set_image(tweak_data.gui.icons[mission_icon].texture)
	self._mission_info_panel:child("mission_icon"):set_texture_rect(unpack(tweak_data.gui.icons[mission_icon].texture_rect))
end

function HUDTabScreen:_refresh_profile_info()
	local profile_name = managers.network:session():local_peer():name()

	if managers.user:get_setting("capitalize_names") then
		profile_name = utf8.to_upper(profile_name)
	end

	self._profile_info_panel:child("profile_name"):set_text(profile_name)

	local class = managers.skilltree:get_character_profile_class()

	self._class_icon:set_icon("player_panel_class_" .. tostring(class))
	self._class_icon:set_text("skill_class_" .. tostring(class) .. "_name", {
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

	self._loot_info_panel:set_visible(true)

	if not current_job then
		self._dog_tag_panel:set_visible(false)

		return
	end

	self._loot_picked_up = managers.lootdrop:picked_up_current_leg()
	self._loot_total = managers.lootdrop:loot_spawned_current_leg()

	self._dog_tag_amount:set_text(tostring(self._loot_picked_up) .. " / " .. tostring(self._loot_total))

	if self._shown == true then
		self._dog_tag_panel:set_visible(true)
	end
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
end

function HUDTabScreen:reset_time()
	self._last_set_time = 0

	self:set_time(0)
end

function HUDTabScreen:_refresh_card_info()
	if self._event_panel then
		self._empty_card_panel:set_visible(false)
		self._active_card_panel:set_visible(false)

		return
	end

	local active_card = managers.challenge_cards:get_active_card()

	if not active_card then
		self._empty_card_panel:set_visible(true)
		self._active_card_panel:set_visible(false)
	else
		self._empty_card_panel:set_visible(false)
		self._active_card_panel:set_visible(true)
		self._active_card:set_card_details(active_card)

		local active_card_title = self._active_card_panel:child("active_card_title")

		if active_card.status == ChallengeCardsManager.CARD_STATUS_FAILED then
			active_card_title:set_text(managers.localization:to_upper_text("hud_active_challenge_card_failed_title"))
			active_card_title:set_color(self.CARD_INFO_FAILED_TITLE_COLOR)
		elseif active_card.card_type == ChallengeCardsTweakData.CARD_TYPE_BOUNTY then
			active_card_title:set_text(managers.localization:to_upper_text("hud_active_bounty_card_title"))
			active_card_title:set_color(self.CARD_INFO_TITLE_COLOR)
		else
			active_card_title:set_text(managers.localization:to_upper_text("hud_active_challenge_card_title"))
			active_card_title:set_color(self.CARD_INFO_TITLE_COLOR)
		end
	end
end

function HUDTabScreen:register_event_panel(control_class, params)
	if self._event_panel then
		self:remove_event_panel()
	end

	self._event_panel = control_class:new(self._card_info_panel, params)

	self:_refresh_card_info()
end

function HUDTabScreen:remove_event_panel()
	if self._event_panel then
		self._event_panel:destroy()

		self._event_panel = nil

		self:_refresh_card_info()
	end
end

function HUDTabScreen:set_event_panel_data(data)
	if self._event_panel then
		self._event_panel:set_data(data)
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
	self._progression_timer_shown = not managers.progression:mission_progression_completed() and managers.raid_job:played_tutorial()

	self._progression_timer_panel:set_visible(self._progression_timer_shown)

	if self._progression_timer_shown and not self._animating_cycle_completed then
		self:_layout_progression()
	end

	managers.hud:add_updator("tab", callback(self, self, "update"))

	self._shown = true

	self:_refresh_profile_info()
	self:_refresh_mission_info()
	self:_refresh_loot_info()
	self:_refresh_card_info()
	self:_refresh_weapon_challenge_info()

	if self:_current_level_has_map() then
		self._map:show()
	end

	self._background:set_visible(true)
	self._object:set_visible(true)

	if self._grid_panel then
		self._grid_panel:set_visible(true)
	end
end

function HUDTabScreen:_layout_progression()
	local is_final_unlock_cycle = managers.progression:at_final_unlock_cycle()
	local cycle_completed = managers.progression:have_pending_missions_to_unlock()
	local progression_completion_pending = managers.progression:mission_progression_completion_pending()
	local timer_control = self._progression_timer_content_panel:child("progression_timer_timer")
	local title_color = tweak_data.gui.colors.raid_dirty_white

	if not cycle_completed and not progression_completion_pending then
		self:_set_progress_timer_value()
		timer_control:set_visible(true)
	else
		timer_control:set_w(0)
		timer_control:set_visible(false)

		title_color = HUDTabScreen.MISSION_INFO_TEXT_COLOR
	end

	local title_text = "raid_next_raid_in_title"
	local description_text = "raid_next_raid_in_description"
	local timer_title = self._progression_timer_content_panel:child("progression_timer_title")
	local timer_description = self._progression_timer_content_panel:child("progression_timer_description")

	if is_final_unlock_cycle then
		if progression_completion_pending then
			title_text = "raid_final_unlocked_title"
			description_text = "raid_next_unlocked_description"
		else
			title_text = "raid_final_raids_in_title"
			description_text = "raid_final_raids_in_description"
		end
	elseif cycle_completed then
		title_text = "raid_next_unlocked_title"
		description_text = "raid_next_unlocked_description"
	end

	timer_title:set_text(utf8.to_upper(managers.localization:text(title_text)))
	timer_title:set_color(title_color)

	local _, _, w, _ = timer_title:text_rect()

	timer_title:set_w(w)
	timer_description:set_text(utf8.to_upper(managers.localization:text(description_text)))

	local _, _, w, _ = timer_description:text_rect()

	timer_description:set_w(w)

	local content_panel_w = timer_title:x() + math.max(timer_title:w() + timer_control:w() + 64, timer_description:w())

	self._progression_timer_content_panel:set_w(content_panel_w)
	self._progression_timer_panel:set_w(self._progression_timer_content_panel:w() + 126)

	if is_final_unlock_cycle or cycle_completed then
		self._progression_timer_panel:set_right(self._timer_panel:x())
	end
end

function HUDTabScreen:_set_progress_timer_value()
	local timer_control = self._progression_timer_content_panel:child("progression_timer_timer")
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

	timer_control:set_text(text)

	local _, _, w, _ = timer_control:text_rect()

	timer_control:set_w(w)
	timer_control:set_right(self._progression_timer_content_panel:w())
	self._progression_timer_panel:set_right(self._timer_panel:x())
end

function HUDTabScreen:update()
	self._loot_info_panel:set_bottom(self._background:parent():h() - HUDTabScreen.LOOT_INFO_BOTTOM_OFFSET)

	if self._progression_timer_shown and not managers.progression:have_pending_missions_to_unlock() then
		self:_set_progress_timer_value()
	end

	self._map:update()
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

function HUDTabScreen:set_map_location(location_id)
	self._map:set_location(location_id)
end

function HUDTabScreen:clear_map(location_id)
	self._map:clear(location_id)
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

function HUDTabScreen:on_progression_cycle_completed()
	self._progression_timer_content_panel:stop()
	self._progression_timer_content_panel:animate(callback(self, self, "animate_progression_cycle_completed"))
end

function HUDTabScreen:animate_progression_cycle_completed()
	self._animating_cycle_completed = true

	local fade_out_duration = 0.35
	local t = (1 - self._progression_timer_content_panel:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in(t, 1, -1, fade_out_duration)

		self._progression_timer_content_panel:set_alpha(current_alpha)

		local current_x = Easing.quartic_in(t, 30, -30, fade_out_duration)

		self._progression_timer_content_panel:set_x(current_x)
	end

	self._progression_timer_content_panel:set_alpha(0)
	self._progression_timer_content_panel:set_x(0)
	self:_layout_progression()

	local fade_in_duration = 0.35

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_out(t, 0, 1, fade_in_duration)

		self._progression_timer_content_panel:set_alpha(current_alpha)

		local current_x = Easing.quartic_out(t, 0, 30, fade_in_duration)

		self._progression_timer_content_panel:set_x(current_x)
	end

	self._progression_timer_content_panel:set_alpha(1)
	self._progression_timer_content_panel:set_x(30)

	self._animating_cycle_completed = false
end
