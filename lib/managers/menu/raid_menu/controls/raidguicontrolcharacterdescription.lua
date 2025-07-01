RaidGUIControlCharacterDescription = RaidGUIControlCharacterDescription or class(RaidGUIControl)
RaidGUIControlCharacterDescription.MODE_SELECTION = "mode_selection"
RaidGUIControlCharacterDescription.MODE_CUSTOMIZATION = "mode_customization"

function RaidGUIControlCharacterDescription:init(parent, params, item_data)
	RaidGUIControlCharacterDescription.super.init(self, parent, params, item_data)

	self._data = item_data
	self._mode = self._params.mode or RaidGUIControlCharacterDescription.MODE_SELECTION

	self:_layout()
end

function RaidGUIControlCharacterDescription:_layout()
	self._object = self._panel:panel({
		name = "character_info_panel",
		h = self._params.h,
		w = self._params.w,
		x = self._params.x,
		y = self._params.y,
	})

	local text_rect = tweak_data.gui.icons.ico_class_recon.texture_rect

	self._class_icon = self._object:image({
		name = "class_icon",
		visible = false,
		x = 32,
		y = 32,
		h = text_rect[4],
		texture = tweak_data.gui.icons.ico_class_recon.texture,
		texture_rect = tweak_data.gui.icons.ico_class_recon.texture_rect,
		w = text_rect[3],
	})
	self._class_label = self._object:label({
		align = "center",
		h = 32,
		name = "class_label",
		text = "",
		vertical = "center",
		w = 134,
		x = 0,
		y = 96,
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
	})
	self._nation_flag_icon = self._object:image({
		h = 64,
		name = "nation_flag_icon",
		visible = false,
		w = 96,
		x = 144,
		y = 32,
		texture = tweak_data.gui.icons.ico_flag_empty.texture,
		texture_rect = tweak_data.gui.icons.ico_flag_empty.texture_rect,
	})
	self._nation_flag_label = self._object:label({
		align = "center",
		h = 32,
		name = "nation_flag_label",
		text = "",
		vertical = "center",
		w = 104,
		x = 144,
		y = 96,
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
	})
	self._level_amount_level = self._object:label({
		align = "center",
		h = 64,
		name = "level_amount_level",
		text = "",
		vertical = "center",
		w = 64,
		x = 280,
		y = 32,
		color = tweak_data.gui.colors.raid_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_52,
	})
	self._level_label = self._object:label({
		align = "center",
		h = 32,
		name = "level_label",
		text = "",
		vertical = "center",
		w = 72,
		x = 280,
		y = 96,
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
	})

	if self._mode == RaidGUIControlCharacterDescription.MODE_SELECTION then
		self._description_label = self._object:label({
			align = "left",
			h = 224,
			name = "description_label",
			vertical = "top",
			w = 354,
			wrap = true,
			x = 0,
			y = 160,
			color = tweak_data.gui.colors.raid_grey,
			font = tweak_data.gui.fonts.lato,
			font_size = tweak_data.gui.font_sizes.size_20,
			text = self:translate("skill_class_recon_desc", false),
		})
		self._health_amount_label = self._object:label({
			align = "center",
			h = 64,
			name = "health_amount_label",
			text = "",
			vertical = "center",
			w = 64,
			x = 8,
			y = 398,
			color = tweak_data.gui.colors.raid_white,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_52,
		})
		self._health_label = self._object:label({
			align = "center",
			h = 32,
			name = "health_label",
			text = "",
			vertical = "center",
			w = 64,
			x = 8,
			y = 462,
			color = tweak_data.gui.colors.raid_grey,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
		})
		self._speed_amount_label = self._object:label({
			align = "center",
			h = 64,
			name = "speed_amount_label",
			text = "",
			vertical = "center",
			w = 96,
			x = 128,
			y = 398,
			color = tweak_data.gui.colors.raid_white,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_52,
		})
		self._speed_label = self._object:label({
			align = "center",
			h = 32,
			name = "speed_label",
			text = "",
			vertical = "center",
			w = 96,
			x = 128,
			y = 462,
			color = tweak_data.gui.colors.raid_grey,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
		})
		self._stamina_amount_label = self._object:label({
			align = "center",
			h = 64,
			name = "stamina_amount_label",
			text = "",
			vertical = "center",
			w = 96,
			x = 254,
			y = 398,
			color = tweak_data.gui.colors.raid_white,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_52,
		})
		self._stamina_label = self._object:label({
			align = "center",
			h = 32,
			name = "stamina_label",
			text = "",
			vertical = "center",
			w = 68,
			x = 270,
			y = 462,
			color = tweak_data.gui.colors.raid_grey,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
		})
		self._warcries_label = self._object:label({
			align = "left",
			h = 32,
			name = "warcries_label",
			text = "",
			vertical = "center",
			w = 96,
			x = 0,
			y = 528,
			color = Color("b8b8b8"),
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.small,
		})
		self._warcry_icon = self._object:image({
			h = 64,
			name = "warcry_icon",
			w = 64,
			x = 0,
			y = 576,
			texture = tweak_data.gui.icons.ico_flag_empty.texture,
			texture_rect = tweak_data.gui.icons.ico_flag_empty.texture_rect,
		})
		self._warcry_name_label = self._object:label({
			align = "left",
			h = 32,
			name = "warcry_name_label",
			text = "",
			vertical = "center",
			w = 242,
			x = 79,
			y = 528,
			color = Color("d0d0d0"),
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.small,
		})
		self._warcry_description_label = self._object:label({
			align = "left",
			name = "warcry_description_label",
			text = "",
			vertical = "top",
			wrap = true,
			x = 79,
			y = 570,
			color = Color("737373"),
			font = tweak_data.gui.fonts.lato,
			font_size = tweak_data.gui.font_sizes.size_18,
			h = self._object:h() - 570,
			w = self._object:w() - 79,
		})
	end
end

function RaidGUIControlCharacterDescription:set_data(data)
	local class_icon_data = tweak_data.gui.icons["ico_class_" .. data.class_name] or tweak_data.gui.icons.ico_flag_empty

	self._class_icon:set_image(class_icon_data.texture)
	self._class_icon:set_texture_rect(class_icon_data.texture_rect)
	self._class_icon:set_visible(true)
	self._class_label:set_text(self:translate(tweak_data.skilltree.classes[data.class_name].name_id, true))

	local nation_flag_data = tweak_data.gui.icons["ico_flag_" .. data.nationality] or tweak_data.gui.icons.ico_flag_empty

	self._nation_flag_icon:set_image(nation_flag_data.texture)
	self._nation_flag_icon:set_texture_rect(nation_flag_data.texture_rect)
	self._nation_flag_icon:set_visible(true)
	self._nation_flag_label:set_text(utf8.to_upper(managers.localization:text("nationality_" .. data.nationality)))
	self._level_amount_level:set_text(data.level)
	self._level_label:set_text(self:translate("select_character_level_label", true))

	if self._mode == RaidGUIControlCharacterDescription.MODE_SELECTION then
		local class_description = self:translate(tweak_data.skilltree.classes[data.class_name].desc_id, false) or ""

		self._description_label:set_text(class_description)

		local health_amount = data.character_stats and data.character_stats.health.base or 0

		self._health_amount_label:set_text(string.format("%.0f", health_amount))
		self._health_label:set_text(self:translate("select_character_health_label", true))

		local _, _, w, _ = self._health_label:text_rect()

		self._health_label:set_w(w)
		self._health_label:set_center_x(self._health_amount_label:x() + self._health_amount_label:w() / 2)

		local speed_amount = data.character_stats and data.character_stats.speed.base or 0

		self._speed_amount_label:set_text(string.format("%.0f", speed_amount))
		self._speed_label:set_text(self:translate("select_character_speed_label", true))

		local stamina_amount = data.character_stats and data.character_stats.stamina.base or 0

		self._stamina_amount_label:set_text(string.format("%.0f", stamina_amount))
		self._stamina_label:set_text(self:translate("select_character_stamina_label", true))
		self._warcries_label:set_text(self:translate("select_character_warcries_label", true))

		local _, _, w, _ = self._warcries_label:text_rect()

		self._warcries_label:set_w(w)

		local warcry_name_id = tweak_data.skilltree.class_warcry_data[data.class_name]
		local warcry_name = self:translate(tweak_data.warcry[warcry_name_id].name_id, true)
		local warcry_desc = self:translate(tweak_data.warcry[warcry_name_id].desc_id, false)
		local warcry_menu_icon_name = tweak_data.warcry[warcry_name_id].menu_icon
		local warcry_icon_data = tweak_data.gui.icons[warcry_menu_icon_name]

		self._warcry_description_label:set_text(warcry_desc)
		self._warcry_icon:set_image(warcry_icon_data.texture)
		self._warcry_icon:set_texture_rect(warcry_icon_data.texture_rect)
		self._warcry_name_label:set_text(warcry_name)

		local _, _, w, _ = self._warcry_name_label:text_rect()

		self._warcry_name_label:set_w(w)
		self._warcry_name_label:set_x(self._warcries_label:x() + self._warcries_label:w() + 5)
	end
end
