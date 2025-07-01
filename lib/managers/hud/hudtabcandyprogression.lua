HUDTabCandyProgression = HUDTabCandyProgression or class()
HUDTabCandyProgression.Y = 20
HUDTabCandyProgression.WIDTH = 384
HUDTabCandyProgression.HEIGHT = 608
HUDTabCandyProgression.CARD_Y = 48
HUDTabCandyProgression.CARD_H = 234
HUDTabCandyProgression.TITLE_FONT = tweak_data.gui.fonts.din_compressed
HUDTabCandyProgression.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDTabCandyProgression.TITLE_COLOR = tweak_data.gui.colors.raid_dirty_white
HUDTabCandyProgression.TIER_TITLE_Y = 290
HUDTabCandyProgression.TIER_TITLE_FONT = tweak_data.gui.fonts.din_compressed
HUDTabCandyProgression.TIER_TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDTabCandyProgression.TIER_TITLE_COLOR = tweak_data.gui.colors.raid_dirty_white
HUDTabCandyProgression.PROGRESS_BAR_Y = 290
HUDTabCandyProgression.PROGRESS_BAR_W = 168
HUDTabCandyProgression.PROGRESS_BAR_H = 26
HUDTabCandyProgression.PROGRESS_BAR_BOTTOM_Y = 16
HUDTabCandyProgression.PROGRESS_IMAGE_LEFT = "candy_progress_left"
HUDTabCandyProgression.PROGRESS_IMAGE_CENTER = "candy_progress_center"
HUDTabCandyProgression.PROGRESS_IMAGE_RIGHT = "candy_progress_right"
HUDTabCandyProgression.PROGRESS_IMAGE_OVERLAY = "candy_progress_overlay"
HUDTabCandyProgression.DEBUFF_TITLE_Y = 340
HUDTabCandyProgression.DEBUFF_W = 216
HUDTabCandyProgression.DEBUFF_TITLE_FONT = tweak_data.gui.fonts.lato
HUDTabCandyProgression.DEBUFF_TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_18
HUDTabCandyProgression.DEBUFF_TITLE_COLOR = tweak_data.gui.colors.raid_light_grey

function HUDTabCandyProgression:init(panel, params)
	self._panel = panel

	self:_create_panel(panel, params)
	self:_create_card()
	self:_create_progress_bar()
	self:_create_tier_info()
	self:set_data(params)
end

function HUDTabCandyProgression:destroy()
	if self._panel:child("hud_tab_candy_progress") then
		self._panel:remove(self._object)
	end
end

function HUDTabCandyProgression:_create_panel(panel, params)
	self._object = panel:panel({
		h = self.HEIGHT,
		halign = "right",
		layer = params.layer or panel:layer(),
		name = "hud_tab_candy_progress",
		valign = "bottom",
		w = self.WIDTH,
		x = params.x or 0,
		y = params.y or self.Y,
	})
end

function HUDTabCandyProgression:_create_card()
	local title = self._object:text({
		color = self.TITLE_COLOR,
		font = tweak_data.gui:get_font_path(self.TITLE_FONT, self.TITLE_FONT_SIZE),
		font_size = self.TITLE_FONT_SIZE,
		name = "candy_progression_title",
		text = managers.localization:to_upper_text("hud_active_event_details"),
	})

	self._card_panel = RaidGUIPanel:new(self._object, {
		h = self.CARD_H,
		is_root_panel = true,
		layer = 3,
		name = "candy_progress_bar_panel",
		vertical = "bottom",
		w = self.PROGRESS_BAR_W,
		y = self.CARD_Y,
	})
	self._card = self._card_panel:create_custom_control(RaidGUIControlCardBase, {
		card_image_params = {
			h = self.CARD_H,
			w = self.PROGRESS_BAR_W,
		},
		name = "card",
		panel = self._card_panel,
	})
end

function HUDTabCandyProgression:_create_progress_bar()
	self._progress_bar_panel = RaidGUIPanel:new(self._object, {
		h = self.PROGRESS_BAR_H,
		is_root_panel = true,
		layer = 3,
		name = "candy_progress_bar_panel",
		vertical = "bottom",
		w = self.PROGRESS_BAR_W,
		y = self.PROGRESS_BAR_Y,
	})

	self._progress_bar_panel:three_cut_bitmap({
		alpha = 0.5,
		center = self.PROGRESS_IMAGE_CENTER,
		h = self._progress_bar_panel:h(),
		layer = 1,
		left = self.PROGRESS_IMAGE_LEFT,
		name = "candy_progress_bar_background",
		right = self.PROGRESS_IMAGE_RIGHT,
		w = self._progress_bar_panel:w(),
	})

	self._progress_bar_foreground_panel = self._progress_bar_panel:panel({
		h = self._progress_bar_panel:h(),
		halign = "scale",
		layer = 2,
		name = "candy_progress_bar_foreground_panel",
		valign = "scale",
		w = 0,
	})

	local progress_bar = self._progress_bar_foreground_panel:three_cut_bitmap({
		center = self.PROGRESS_IMAGE_CENTER,
		color = tweak_data.gui.colors.progress_orange,
		h = self._progress_bar_panel:h(),
		left = self.PROGRESS_IMAGE_LEFT,
		name = "candy_progress_bar_background",
		right = self.PROGRESS_IMAGE_RIGHT,
		w = self._progress_bar_panel:w(),
	})
	local icon_data = tweak_data.gui:get_full_gui_data(self.PROGRESS_IMAGE_OVERLAY)

	icon_data.texture_rect[3] = self._progress_bar_panel:w() * 0.55
	self._progress_bar_overlay = self._progress_bar_foreground_panel:bitmap({
		alpha = 0.3,
		blend_mode = "add",
		color = tweak_data.gui.colors.raid_dark_red,
		h = self._progress_bar_panel:h(),
		layer = progress_bar:layer() + 5,
		name = "candy_progress_bar_background",
		texture = icon_data.texture,
		texture_rect = icon_data.texture_rect,
		w = self._progress_bar_panel:w(),
		wrap_mode = "wrap",
	})
end

function HUDTabCandyProgression:_create_tier_info()
	local font = tweak_data.gui:get_font_path(self.TIER_TITLE_FONT, self.TIER_TITLE_FONT_SIZE)
	local tier = 1

	self._tier_title = self._object:text({
		align = "center",
		color = self.SUBTITLE_COLOR,
		font = font,
		font_size = self.TIER_TITLE_FONT_SIZE,
		layer = self._progress_bar_panel:layer() + 5,
		name = "tier_title",
		text = "TIER",
		w = self.PROGRESS_BAR_W,
		y = self.TIER_TITLE_Y,
	})
	self._malus_effects_panel = self._object:panel({
		h = 0,
		name = "malus_effects_panel",
		w = self.DEBUFF_W,
		x = self._card_panel:right(),
		y = self._card_panel:y(),
	})
end

function HUDTabCandyProgression:set_data(data)
	if data.progress then
		self._progress_bar_foreground_panel:set_w(self._progress_bar_panel:w() * data.progress)
	end

	if data.card then
		self._card:set_card(data.card)
	end

	if data.tier then
		if data.tier < 1 then
			self._tier_title:set_visible(false)
		else
			local tier_text = managers.localization:to_upper_text("menu_inventory_tier") .. " " .. RaidGUIControlWeaponSkills.ROMAN_NUMERALS[data.tier]

			self._tier_title:set_text(tier_text)
			self._tier_title:set_visible(true)
		end

		local xp_bonus = (tweak_data:get_value("experience_manager", "sugar_high_bonus") - 1) * 100
		local xp_text = xp_bonus * data.tier .. "%"

		self._card:set_xp_bonus(xp_text)
	end

	if data.malus_effect then
		local y = self._malus_effects_panel:h()
		local icon_data = tweak_data.gui:get_full_gui_data(data.malus_effect.icon)
		local malus_icon = self._malus_effects_panel:bitmap({
			h = 28,
			name = "malus_icon_" .. data.malus_effect.name,
			texture = icon_data.texture,
			texture_rect = icon_data.texture_rect,
			w = 28,
			y = y + 2,
		})
		local malus_text = self._malus_effects_panel:text({
			color = self.DEBUFF_TITLE_COLOR,
			font = tweak_data.gui:get_font_path(self.DEBUFF_TITLE_FONT, self.DEBUFF_TITLE_FONT_SIZE),
			font_size = self.DEBUFF_TITLE_FONT_SIZE,
			name = "malus_text_" .. data.malus_effect.name,
			text = managers.localization:text(data.malus_effect.desc_id, data.malus_effect.desc_params),
			w = self._malus_effects_panel:w() - malus_icon:w(),
			word_wrap = true,
			wrap = true,
			x = malus_icon:right() + 4,
			y = y,
		})
		local _, _, w, h = malus_text:text_rect()

		malus_text:set_size(w, h)

		y = y + h + 8

		self._malus_effects_panel:set_h(y)
	end
end
