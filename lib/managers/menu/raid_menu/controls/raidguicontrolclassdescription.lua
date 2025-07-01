RaidGUIControlClassDescription = RaidGUIControlClassDescription or class(RaidGUIControl)
RaidGUIControlClassDescription.CLASS_DESCRIPTION_DEFAULT_Y = 82
RaidGUIControlClassDescription.CLASS_DESCRIPTION_DEFAULT_H = 160
RaidGUIControlClassDescription.CLASS_STATS_DEFAULT_Y = 286
RaidGUIControlClassDescription.WARCRY_DEFAULT_Y = 386
RaidGUIControlClassDescription.WARCRY_DEFAULT_H = 64
RaidGUIControlClassDescription.PERSONAL_BUFF_DEFAULT_Y = 470

function RaidGUIControlClassDescription:init(parent, params, item_data)
	RaidGUIControlClassDescription.super.init(self, parent, params, item_data)

	self._data = item_data

	self:_layout()
end

function RaidGUIControlClassDescription:_layout()
	self._object = self._panel:panel({
		name = "character_info_panel",
		h = self._params.h,
		w = self._params.w,
		x = self._params.x,
		y = self._params.y,
	})

	local padding = 16
	local padded_width = self._object:w() - padding * 2
	local object_bg_params = {
		layer = -1,
		name = "object_bg",
		x = -4,
		y = 0,
		h = self._object:h(),
		texture = tweak_data.gui.icons.paper_mission_book.texture,
		texture_rect = tweak_data.gui.icons.paper_mission_book.texture_rect,
		w = self._object:w() + 8,
	}

	self._object_bg = self._object:image(object_bg_params)

	local object_bg_params2 = {
		layer = -2,
		name = "object_bg",
		x = -4,
		y = 0,
		color = Color(0.7, 0.7, 0.7),
		h = self._object:h(),
		rotation = 2 + math.random(4),
		texture = tweak_data.gui.icons.paper_mission_book.texture,
		texture_rect = tweak_data.gui.icons.paper_mission_book.texture_rect,
		w = self._object:w() + 8,
	}

	self._object_bg2 = self._object:image(object_bg_params2)

	local class_icon_data = tweak_data.gui.icons.ico_class_recon or tweak_data.gui.icons.ico_flag_empty
	local text_rect = class_icon_data.texture_rect

	self._class_icon = self._object:image({
		align = "center",
		name = "class_icon",
		y = 24,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		h = text_rect[4],
		texture = class_icon_data.texture,
		texture_rect = text_rect,
		w = text_rect[3],
		x = padding,
	})
	self._class_label = self._object:label({
		align = "center",
		h = 42,
		name = "class_label",
		text = "CLASSNAME",
		w = 224,
		x = 0,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.menu_list,
		y = self._class_icon:bottom() - 8,
	})

	self._class_label:set_w(self._object:w() - self._class_label:x())

	self._description_label = self._object:label({
		align = "center",
		h = 128,
		name = "description_label",
		vertical = "top",
		wrap = true,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_20,
		text = self:translate("skill_class_recon_desc", false),
		w = padded_width,
		x = padding,
		y = self._class_label:bottom() + 32,
	})

	local y_stats = RaidGUIControlClassDescription.CLASS_STATS_DEFAULT_Y
	local y_stats_label = y_stats + 64
	local x_stats_step = self._object:w() / 4

	self._health_amount_label = self._object:label({
		align = "center",
		h = 64,
		name = "health_amount_label",
		text = "",
		vertical = "center",
		w = 100,
		x = 0,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_52,
		y = y_stats,
	})
	self._health_label = self._object:label({
		align = "center",
		h = 32,
		name = "health_label",
		text = "",
		vertical = "center",
		w = 100,
		x = 0,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		y = y_stats_label,
	})
	self._speed_amount_label = self._object:label({
		align = "center",
		h = 64,
		name = "speed_amount_label",
		text = "",
		vertical = "center",
		w = 100,
		x = 160,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_52,
		y = y_stats,
	})
	self._speed_label = self._object:label({
		align = "center",
		h = 32,
		name = "speed_label",
		text = "",
		vertical = "center",
		w = 100,
		x = 160,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		y = y_stats_label,
	})
	self._stamina_amount_label = self._object:label({
		align = "center",
		h = 64,
		name = "stamina_amount_label",
		text = "",
		vertical = "center",
		w = 100,
		x = 320,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_52,
		y = y_stats,
	})
	self._stamina_label = self._object:label({
		align = "center",
		h = 32,
		name = "stamina_label",
		text = "",
		vertical = "center",
		w = 100,
		x = 320,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		y = y_stats_label,
	})

	self._health_amount_label:set_center_x(x_stats_step)
	self._health_label:set_center_x(x_stats_step)
	self._speed_label:set_center_x(x_stats_step * 2)
	self._speed_amount_label:set_center_x(x_stats_step * 2)
	self._stamina_label:set_center_x(x_stats_step * 3)
	self._stamina_amount_label:set_center_x(x_stats_step * 3)

	local y_warcry = RaidGUIControlClassDescription.WARCRY_DEFAULT_Y

	self._warcry_icon = self._object:image({
		name = "warcry_icon",
		x = 0,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_dark_red,
		texture = tweak_data.gui.icons.warcry_sharpshooter.texture,
		texture_rect = tweak_data.gui.icons.warcry_sharpshooter.texture_rect,
		y = y_warcry,
	})

	self._warcry_icon:set_center_x(self._object:w() / 2)

	local _, c_y = self._warcry_icon:center()

	self._warcry_name_label = self._object:label({
		align = "left",
		h = 32,
		name = "warcry_name_label",
		text = "WARCRYNAME",
		w = 242,
		x = 0,
		y = 0,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_32,
	})

	self._warcry_name_label:set_center_y(c_y + 4)

	self._warcries_label = self._object:label({
		align = "right",
		h = 32,
		name = "warcries_label",
		w = 96,
		x = 0,
		y = 0,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_32,
		text = self:translate("select_character_warcries_label", true),
	})

	self._warcries_label:set_center_y(c_y + 4)

	local _, _, w, _ = self._warcries_label:text_rect()

	self._warcries_label:set_w(w)
	self._warcries_label:set_right(self._warcry_icon:left() - 4)

	local _, _, w, _ = self._warcry_name_label:text_rect()

	self._warcry_name_label:set_w(w)
	self._warcry_name_label:set_left(self._warcry_icon:right() + 4)

	self._warcry_description_short = self._object:label({
		align = "center",
		h = 24,
		name = "warcry_description_short",
		text = "",
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		w = padded_width,
		x = padding,
		y = self._warcry_icon:bottom() + 32,
	})
	self._warcry_description_label = self._object:label({
		align = "center",
		h = 64,
		name = "warcry_description_label",
		text = "",
		vertical = "top",
		wrap = true,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_18,
		w = padded_width,
		x = padding,
		y = self._warcry_description_short:bottom() + 8,
	})
	self._warcry_team_buff_description_short = self._object:label({
		align = "center",
		h = 24,
		name = "warcry_description_team_short_label",
		text = "",
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		w = padded_width,
		x = padding,
		y = self._warcry_description_label:bottom() + 24,
	})
	self._warcry_team_buff_description = self._object:label({
		align = "center",
		h = 120,
		name = "warcry_description_team_label",
		text = "",
		vertical = "top",
		wrap = true,
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_18,
		w = padded_width,
		x = padding,
		y = self._warcry_team_buff_description_short:bottom() + 8,
	})
end

function RaidGUIControlClassDescription:set_data(data)
	local class_icon_data = tweak_data.gui.icons["ico_class_" .. data.class_name] or tweak_data.gui.icons.ico_flag_empty

	self._class_icon:set_image(class_icon_data.texture)
	self._class_icon:set_texture_rect(class_icon_data.texture_rect)
	self._class_icon:set_visible(true)
	self._class_icon:set_center_x(self._object:w() / 2)
	self._class_label:set_text(self:translate(tweak_data.skilltree.classes[data.class_name].name_id, true))
	self._class_label:set_center_x(self._object:w() / 2)

	local class_description = self:translate(tweak_data.skilltree.classes[data.class_name].desc_id, false) or ""

	self._description_label:set_text(class_description)

	local _, _, _, h = self._description_label:text_rect()

	self._description_label:set_h(h)

	local description_extra_h = 0

	if h > RaidGUIControlClassDescription.CLASS_DESCRIPTION_DEFAULT_H then
		description_extra_h = h - RaidGUIControlClassDescription.CLASS_DESCRIPTION_DEFAULT_H
	end

	local health_amount = data.class_stats and data.class_stats.health.base or 0

	self._health_amount_label:set_text(string.format("%.0f", health_amount))
	self._health_label:set_text(self:translate("select_character_health_label", true))
	self._health_amount_label:set_y(RaidGUIControlClassDescription.CLASS_STATS_DEFAULT_Y + description_extra_h)
	self._health_label:set_y(self._health_amount_label:bottom() - 12)

	local speed_amount = data.class_stats and data.class_stats.speed.base or 0

	self._speed_amount_label:set_text(string.format("%.0f", speed_amount))

	local _, _, w, _ = self._speed_amount_label:text_rect()

	self._speed_label:set_text(self:translate("select_character_speed_label", true))

	local _, _, w, _ = self._speed_label:text_rect()

	self._speed_amount_label:set_y(RaidGUIControlClassDescription.CLASS_STATS_DEFAULT_Y + description_extra_h)
	self._speed_label:set_y(self._speed_amount_label:bottom() - 12)

	local stamina_amount = data.class_stats and data.class_stats.stamina.base or 0

	self._stamina_amount_label:set_text(string.format("%.0f", stamina_amount))

	local _, _, w, _ = self._stamina_amount_label:text_rect()

	self._stamina_label:set_text(self:translate("select_character_stamina_label", true))

	if self._stamina_label:w() > self._stamina_amount_label:w() then
		self._stamina_amount_label:set_center_x(self._stamina_label:center_x())
	else
		self._stamina_label:set_center_x(self._stamina_amount_label:center_x())
	end

	self._stamina_amount_label:set_y(RaidGUIControlClassDescription.CLASS_STATS_DEFAULT_Y + description_extra_h)
	self._stamina_label:set_y(self._stamina_amount_label:bottom() - 12)

	local warcry_name_id = tweak_data.skilltree.class_warcry_data[data.class_name]
	local warcry_name = self:translate(tweak_data.warcry[warcry_name_id].name_id, true)
	local warcry_desc = self:translate(tweak_data.warcry[warcry_name_id].desc_self_id, false)
	local warcry_menu_icon_name = tweak_data.warcry[warcry_name_id].menu_icon
	local warcry_icon_data = tweak_data.gui.icons[warcry_menu_icon_name]

	self._warcry_description_label:set_text(warcry_desc)

	local _, _, _, h = self._warcry_description_label:text_rect()

	self._warcry_description_label:set_h(h)
	self._warcry_icon:set_image(warcry_icon_data.texture)
	self._warcry_icon:set_texture_rect(warcry_icon_data.texture_rect)
	self._warcry_icon:set_center_y(RaidGUIControlClassDescription.WARCRY_DEFAULT_Y + RaidGUIControlClassDescription.WARCRY_DEFAULT_H / 2 + description_extra_h)
	self._warcry_name_label:set_text(warcry_name)

	local _, _, w, _ = self._warcry_name_label:text_rect()

	self._warcry_name_label:set_w(w)
	self._warcry_description_short:set_text(self:translate(tweak_data.warcry[warcry_name_id].desc_short_id, true))
	self._warcry_team_buff_description_short:set_text(self:translate(tweak_data.warcry[warcry_name_id].desc_team_short_id, true))
	self._warcry_team_buff_description:set_text(self:translate(tweak_data.warcry[warcry_name_id].desc_team_id, false))

	local team_buff_y = math.max(RaidGUIControlClassDescription.PERSONAL_BUFF_DEFAULT_Y, self._warcry_description_label:bottom() + 32)

	self._warcry_team_buff_description_short:set_y(team_buff_y)
	self._warcry_team_buff_description:set_y(self._warcry_team_buff_description_short:bottom() + 24)
	self._warcry_description_short:set_y(RaidGUIControlClassDescription.PERSONAL_BUFF_DEFAULT_Y + description_extra_h)
	self._warcry_description_label:set_y(self._warcry_description_short:bottom() + 8)
	self._warcry_team_buff_description_short:set_y(self._warcry_description_label:bottom() + 24)
	self._warcry_team_buff_description:set_y(self._warcry_team_buff_description_short:bottom() + 8)
end
