HUDCardDetails = HUDCardDetails or class()
HUDCardDetails.CARD_H = 234
HUDCardDetails.BONUS_ICON = "ico_bonus"
HUDCardDetails.BONUS_Y = 256
HUDCardDetails.BONUS_H = 64
HUDCardDetails.MALUS_ICON = "ico_malus"
HUDCardDetails.MALUS_Y = 332
HUDCardDetails.MALUS_H = 64
HUDCardDetails.EFFECT_DISTANCE = 12
HUDCardDetails.TEXT_X = 75
HUDCardDetails.TEXT_FONT = tweak_data.gui.fonts.lato
HUDCardDetails.TEXT_FONT_SIZE = tweak_data.gui.font_sizes.size_20

function HUDCardDetails:init(panel, params)
	self._params = params

	self:_create_panel(panel, params)
	self:_create_card()
	self:_create_bonus()
	self:_create_malus()
end

function HUDCardDetails:_create_panel(panel, params)
	local panel_params = {
		h = params.h or panel:h(),
		name = "card_details_panel",
		w = params.w or panel:w(),
		x = params.x or 0,
		y = params.y or 0,
	}

	self._object = panel:panel(panel_params)
end

function HUDCardDetails:_create_card()
	local card_panel_params = {
		h = HUDCardDetails.CARD_H,
		is_root_panel = true,
		name = "card_panel",
		visible = true,
		w = self._object:w(),
		x = 0,
		y = 0,
	}

	self._card_panel = RaidGUIPanel:new(self._object, card_panel_params)

	local card_params = {
		card_image_params = {
			h = self._params.card_image_params.h,
			w = self._params.card_image_params.w,
		},
		name = "card",
		panel = self._card_panel,
	}

	self._preview_card = self._card_panel:create_custom_control(RaidGUIControlCardBase, card_params)
end

function HUDCardDetails:_create_bonus()
	local bonus_panel_params = {
		h = HUDCardDetails.BONUS_H,
		name = "bonus_panel",
		w = self._object:w(),
		x = 0,
		y = HUDCardDetails.BONUS_Y,
	}

	self._bonus_panel = self._object:panel(bonus_panel_params)

	local bonus_icon_params = {
		name = "bonus_icon",
		texture = tweak_data.gui.icons[HUDCardDetails.BONUS_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDCardDetails.BONUS_ICON].texture_rect,
		valign = "top",
	}

	self._bonus_icon = self._bonus_panel:bitmap(bonus_icon_params)

	local bonus_text_params = {
		align = "left",
		font = tweak_data.gui:get_font_path(HUDCardDetails.TEXT_FONT, HUDCardDetails.TEXT_FONT_SIZE),
		font_size = HUDCardDetails.TEXT_FONT_SIZE,
		h = self._bonus_panel:h() - 4,
		name = "bonus_text",
		text = "",
		valign = "scale",
		vertical = "top",
		w = self._bonus_panel:w() - HUDCardDetails.TEXT_X,
		wrap = true,
		x = HUDCardDetails.TEXT_X,
		y = 4,
	}

	self._bonus_text = self._bonus_panel:text(bonus_text_params)
end

function HUDCardDetails:_create_malus()
	local malus_panel_params = {
		h = HUDCardDetails.MALUS_H,
		name = "malus_panel",
		w = self._object:w(),
		x = 0,
		y = HUDCardDetails.MALUS_Y,
	}

	self._malus_panel = self._object:panel(malus_panel_params)

	local malus_icon_params = {
		name = "malus_icon",
		texture = tweak_data.gui.icons[HUDCardDetails.MALUS_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDCardDetails.MALUS_ICON].texture_rect,
		valign = "top",
	}

	self._malus_icon = self._malus_panel:bitmap(malus_icon_params)

	local malus_text_params = {
		align = "left",
		font = tweak_data.gui:get_font_path(HUDCardDetails.TEXT_FONT, HUDCardDetails.TEXT_FONT_SIZE),
		font_size = HUDCardDetails.TEXT_FONT_SIZE,
		h = self._malus_panel:h() - 4,
		name = "malus_text",
		text = "",
		valign = "scale",
		vertical = "top",
		w = self._malus_panel:w() - HUDCardDetails.TEXT_X,
		wrap = true,
		x = HUDCardDetails.TEXT_X,
		y = 4,
	}

	self._malus_text = self._malus_panel:text(malus_text_params)
end

function HUDCardDetails:set_card_details(card)
	self._preview_card:set_card(card)

	if card and card.effects then
		local bonus_description, malus_description = managers.challenge_cards:get_card_description(card)

		self._bonus_text:set_text(bonus_description)
		self._malus_text:set_text(malus_description)

		local effect_y = HUDCardDetails.BONUS_Y

		if bonus_description == "" then
			self._bonus_icon:hide()
		else
			self._bonus_icon:show()

			local _, _, _, h = self._bonus_text:text_rect()

			self._bonus_text:set_h(h)
			self._bonus_panel:set_y(effect_y)
			self._bonus_panel:set_h(math.max(self._bonus_text:h(), self._bonus_icon:h()))

			effect_y = effect_y + self._bonus_panel:h() + HUDCardDetails.EFFECT_DISTANCE
		end

		if malus_description == "" then
			self._malus_icon:hide()
		else
			self._malus_icon:show()

			local _, _, _, h = self._malus_text:text_rect()

			self._malus_text:set_h(h)
			self._malus_panel:set_y(effect_y)
			self._malus_panel:set_h(math.max(self._malus_text:h(), self._malus_icon:h()))
		end
	else
		Application:warn("[HUDCardDetails:set_card_details] Missing effects to get details!", card and card.effects)
	end
end
