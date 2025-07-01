RaidGUIControlNationalityDescription = RaidGUIControlNationalityDescription or class(RaidGUIControl)
RaidGUIControlNationalityDescription.PREFERRED_NATIONALITY_LABEL_DEFAULT_Y = 242

function RaidGUIControlNationalityDescription:init(parent, params, item_data)
	RaidGUIControlNationalityDescription.super.init(self, parent, params, item_data)

	self._data = item_data

	self:_layout()
end

function RaidGUIControlNationalityDescription:_layout()
	self._object = self._panel:panel({
		name = "character_info_panel",
		h = self._params.h,
		w = self._params.w,
		x = self._params.x,
		y = self._params.y,
	})

	local tex_rect = tweak_data.gui.icons.character_creation_nationality_british.texture_rect

	self._nation_icon = self._object:image({
		name = "nation_icon",
		x = 0,
		y = 5,
		h = tex_rect[4],
		texture = tweak_data.gui.icons.character_creation_nationality_british.texture,
		texture_rect = tex_rect,
		w = tex_rect[3],
	})
	self._character_name_label = self._object:label({
		h = 42,
		name = "character_name_label",
		w = 224,
		x = 64,
		y = 8,
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.menu_list,
		text = utf8.to_upper("Stirling"),
	})
	self._backstory_label = self._object:label({
		align = "left",
		h = 128,
		name = "backstory_label",
		vertical = "top",
		w = 416,
		wrap = true,
		x = 0,
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_20,
		text = self:translate("character_profile_creation_british_description", false),
		y = self._character_name_label:bottom() + 32,
	})
	self._prefered_nationality_label = self._object:label({
		h = 32,
		name = "preferred_nationality",
		w = 320,
		x = 0,
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_32,
		text = self:translate("character_creation_preferred_nationality", true),
		y = RaidGUIControlNationalityDescription.PREFERRED_NATIONALITY_LABEL_DEFAULT_Y,
	})
	self._disclaimer_label = self._object:label({
		align = "left",
		h = 320,
		name = "preferred_nationality_disclaimer",
		vertical = "top",
		w = 416,
		wrap = true,
		x = 0,
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_20,
		text = self:translate("character_creation_preferred_nationality_disclaimer", false),
		y = self._prefered_nationality_label:bottom() + 32,
	})
end

function RaidGUIControlNationalityDescription:set_data(data)
	local nation_icon_data = tweak_data.gui.icons["character_creation_nationality_" .. data.nationality] or tweak_data.gui.icons.ico_flag_empty

	self._nation_icon:set_image(nation_icon_data.texture)
	self._nation_icon:set_texture_rect(nation_icon_data.texture_rect)
	self._nation_icon:set_visible(true)
	self._character_name_label:set_text(self:translate("menu_" .. data.nationality, true))

	local backstory_text = self:translate("character_profile_creation_" .. data.nationality .. "_description", false) or ""

	self._backstory_label:set_text(backstory_text)

	local _, _, _, h = self._backstory_label:text_rect()

	self._backstory_label:set_h(h)
	self._prefered_nationality_label:set_y(math.max(RaidGUIControlNationalityDescription.PREFERRED_NATIONALITY_LABEL_DEFAULT_Y, self._backstory_label:bottom() + 32))
	self._disclaimer_label:set_y(self._prefered_nationality_label:bottom() + 32)
end
