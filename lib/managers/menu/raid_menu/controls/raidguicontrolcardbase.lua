RaidGUIControlCardBase = RaidGUIControlCardBase or class(RaidGUIControl)
RaidGUIControlCardBase.TITLE_FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlCardBase.TITLE_TEXT_SIZE = 20
RaidGUIControlCardBase.TITLE_PADDING = 0.08
RaidGUIControlCardBase.TITLE_Y = 0.86
RaidGUIControlCardBase.TITLE_CENTER_Y = 0.92
RaidGUIControlCardBase.TITLE_H = 0.11
RaidGUIControlCardBase.TITLE_COLOR = tweak_data.gui.colors.raid_white
RaidGUIControlCardBase.DESCRIPTION_Y = 0.6494
RaidGUIControlCardBase.DESCRIPTION_H = 0.15
RaidGUIControlCardBase.DESCRIPTION_TEXT_SIZE = 14
RaidGUIControlCardBase.XP_BONUS_X = 0.03
RaidGUIControlCardBase.XP_BONUS_Y = 0.015
RaidGUIControlCardBase.XP_BONUS_W = 0.3394
RaidGUIControlCardBase.XP_BONUS_H = 0.09
RaidGUIControlCardBase.XP_BONUS_FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlCardBase.XP_BONUS_FONT_SIZE = tweak_data.gui.font_sizes.size_46
RaidGUIControlCardBase.XP_BONUS_LABEL_FONT_SIZE = RaidGUIControlCardBase.XP_BONUS_FONT_SIZE * 0.5
RaidGUIControlCardBase.ICON_H = 0.12
RaidGUIControlCardBase.ICON_RIGHT_PADDING = 0.0627
RaidGUIControlCardBase.ICON_DOWN_PADDING = 0.0482
RaidGUIControlCardBase.ICON_LEFT_PADDING = 0.085
RaidGUIControlCardBase.ICON_TOP_PADDING = 0.045
RaidGUIControlCardBase.ICON_DISTANCE = 0

function RaidGUIControlCardBase:init(parent, params, item_data, grid_params)
	RaidGUIControlCardBase.super.init(self, parent, params)

	self._card_panel = nil

	local card = "ra_on_the_scrounge"

	self._grid_params = grid_params
	self._item_data = item_data

	if params.panel then
		self._card_panel = params.panel
	else
		local card_rarity = tweak_data.challenge_cards:get_card_by_key_name(card).rarity
		local card_rect = tweak_data.challenge_cards.rarity_definition[card_rarity].texture_rect

		self._card_panel = self._panel:panel({
			h = params.item_h or self._panel:h(),
			halign = "center",
			name = "card_panel",
			valign = "center",
			w = params.item_w or self._panel:h() * (card_rect[3] / card_rect[4]),
			x = params.x or 0,
			y = params.y or 0,
		})
	end

	self._object = self._card_panel

	local card_data = tweak_data.challenge_cards:get_card_by_key_name(card)
	local card_texture = tweak_data.challenge_cards.challenge_card_texture_path .. (card_data.texture or "cc_raid_common_on_the_scrounge_hud")
	local card_texture_rect = tweak_data.challenge_cards.challenge_card_texture_rect
	local cip = self._params.card_image_params
	local card_rect = {
		h = cip and cip.h or self._card_panel:h(),
		w = cip and cip.w or self._card_panel:w(),
		x = cip and cip.x or 0,
		y = cip and cip.y or 0,
	}

	self._card_image = self._card_panel:bitmap({
		h = card_rect.h or self._card_panel:h(),
		layer = 100,
		name = "card_image",
		texture = card_texture,
		texture_rect = card_texture_rect,
		w = card_rect.w or self._card_panel:w(),
		x = card_rect.x or 0,
		y = card_rect.y or 0,
	})

	local title_h = self._card_image:h() * RaidGUIControlCardBase.TITLE_H
	local title_font_size = math.ceil(RaidGUIControlCardBase.TITLE_TEXT_SIZE * (self._card_image:h() / 255))

	self._card_title = self._card_panel:label({
		align = "center",
		color = self.TITLE_COLOR,
		font = RaidGUIControlCardBase.TITLE_FONT,
		font_size = title_font_size,
		h = title_h,
		layer = self._card_image:layer() + 10,
		name = "card_title",
		text = utf8.to_upper(tweak_data.challenge_cards:get_card_by_key_name(card).name),
		vertical = "center",
		w = self._card_image:w() * (1 - 2 * RaidGUIControlCardBase.TITLE_PADDING),
		wrap = true,
		x = self._card_image:x() + self._card_image:w() * RaidGUIControlCardBase.TITLE_PADDING,
	})

	self._card_title:set_center_y(self._card_image:y() + self._card_image:h() * RaidGUIControlCardBase.TITLE_CENTER_Y)

	local _, _, w, h = self._card_title:text_rect()

	if title_h < h then
		self:_refit_card_title_text(title_font_size)
	end

	local params_card_description = {
		align = "left",
		color = Color.black,
		font = RaidGUIControlCardBase.TITLE_FONT,
		font_size = math.ceil(RaidGUIControlCardBase.DESCRIPTION_TEXT_SIZE * (self._card_image:h() / 255)),
		layer = self._card_image:layer() + 1,
		name = "card_description",
		text = tweak_data.challenge_cards:get_card_by_key_name(card).description,
		visible = false,
		wrap = true,
	}

	self._card_description = self._card_panel:label(params_card_description)

	local params_xp_bonus = {
		align = "center",
		color = tweak_data.gui.colors.raid_white,
		font = RaidGUIControlCardBase.XP_BONUS_FONT,
		font_size = math.ceil(RaidGUIControlCardBase.XP_BONUS_FONT_SIZE * self._card_image:h() * 0.0015),
		h = self._card_image:h() * RaidGUIControlCardBase.XP_BONUS_H,
		layer = self._card_image:layer() + 1,
		name = "xp_bonus",
		text = tostring(tweak_data.challenge_cards:get_card_by_key_name(card).bonus_xp),
		vertical = "center",
		w = self._card_image:w() * RaidGUIControlCardBase.XP_BONUS_W,
		y = self._card_image:y() + self._card_image:h() * RaidGUIControlCardBase.XP_BONUS_Y,
	}

	self._xp_bonus = self._card_panel:label(params_xp_bonus)

	local card_rarity = card_data.rarity
	local rarity_definitions_icon = tweak_data.challenge_cards.rarity_definition[card_rarity].texture_gui
	local card_rarity_h = self._card_image:h() * RaidGUIControlCardBase.ICON_H
	local card_rarity_w = card_rarity_h * (rarity_definitions_icon.texture_rect[3] / rarity_definitions_icon.texture_rect[4])

	self._card_rarity_icon = self._card_panel:image({
		h = card_rarity_h,
		layer = self._card_image:layer() + 1,
		name = "card_rarity_icon",
		texture = rarity_definitions_icon.texture,
		texture_rect = rarity_definitions_icon.texture_rect,
		w = card_rarity_w,
		x = self._card_image:w() - card_rarity_w - self._card_image:w() * RaidGUIControlCardBase.ICON_LEFT_PADDING,
		y = self._card_image:h() * RaidGUIControlCardBase.ICON_TOP_PADDING,
	})

	local card_type = card_data.card_type or "card_type_none"
	local type_definitions_icon = tweak_data.challenge_cards.type_definition[card_type].texture_gui
	local card_type_h = card_rarity_h
	local card_type_w = card_type_h * (type_definitions_icon.texture_rect[3] / type_definitions_icon.texture_rect[4])

	self._card_type_icon = self._card_panel:image({
		h = card_type_h,
		layer = self._card_image:layer() + 1,
		name = "card_type_icon",
		texture = type_definitions_icon.texture,
		texture_rect = type_definitions_icon.texture_rect,
		w = card_type_w,
		x = self._card_image:w() * RaidGUIControlCardBase.ICON_LEFT_PADDING,
		y = self._card_image:h() * RaidGUIControlCardBase.ICON_TOP_PADDING,
	})

	if self._params and self._params.item_clicked_callback then
		self._on_click_callback = self._params.item_clicked_callback
	end

	if self._params and self._params.item_selected_callback then
		self._on_selected_callback = self._params.item_selected_callback
	end

	local image_size_multiplier = self._card_image:w() / tweak_data.challenge_cards.challenge_card_texture_rect[3]

	image_size_multiplier = image_size_multiplier * 1.75
	self._card_stackable_image = self._object:bitmap({
		h = self._card_image:h(),
		layer = self._card_image:layer() - 1,
		texture = tweak_data.challenge_cards.challenge_card_stackable_2_texture_path,
		texture_rect = tweak_data.challenge_cards.challenge_card_stackable_2_texture_rect,
		visible = false,
		w = self._card_image:w(),
	})

	self._card_stackable_image:set_center(self._card_image:center())

	self._card_amount_background = self._card_panel:image({
		h = tweak_data.gui.icons.card_counter_bg_large.texture_rect[4] * image_size_multiplier,
		layer = self._card_image:layer() + 1,
		name = "card_amount_background",
		texture = tweak_data.gui.icons.card_counter_bg_large.texture,
		texture_rect = tweak_data.gui.icons.card_counter_bg_large.texture_rect,
		visible = false,
		w = tweak_data.gui.icons.card_counter_bg_large.texture_rect[3] * image_size_multiplier,
		x = self._card_image:w() * 0.145,
		y = self._card_image:h() * 0.7,
	})
	self._card_amount_label = self._card_panel:label({
		align = "center",
		font_size = self._card_amount_background:h() * 0.8,
		h = self._card_amount_background:h(),
		layer = self._card_amount_background:layer() + 1,
		name = "card_amount_label",
		text = "??x",
		vertical = "center",
		visible = false,
		w = self._card_amount_background:w() * 0.9,
		x = self._card_amount_background:x(),
		y = self._card_amount_background:y(),
	})

	self._card_panel:set_visible(false)
end

function RaidGUIControlCardBase:_refit_card_title_text(original_font_size)
	local font_sizes = {}

	for index, size in pairs(tweak_data.gui.font_sizes) do
		if size < original_font_size then
			table.insert(font_sizes, size)
		end
	end

	table.sort(font_sizes)

	for i = #font_sizes, 1, -1 do
		self._card_title:set_font_size(font_sizes[i])

		local _, _, w, h = self._card_title:text_rect()

		if h <= self._card_title:h() and w <= self._card_title:w() then
			break
		end
	end
end

function RaidGUIControlCardBase:get_data()
	return self._item_data
end

function RaidGUIControlCardBase:set_card(card_data, is_inventory_item)
	self._item_data = card_data

	if not self._item_data then
		return
	end

	local empty_slot_texture = tweak_data.gui.icons.cc_empty_slot_small
	local card_texture = empty_slot_texture.texture
	local card_texture_rect = empty_slot_texture.texture_rect

	if not self._item_data.title_in_texture then
		self._card_title:set_text(self:translate(self._item_data.name, true))

		local title_font_size = math.ceil(RaidGUIControlCardBase.TITLE_TEXT_SIZE * (self._card_image:h() / 255))

		self._card_title:set_font_size(title_font_size)

		local _, _, w, h = self._card_title:text_rect()

		if h > self._card_title:h() then
			self:_refit_card_title_text(title_font_size)
		end

		self._card_title:show()
		self._card_title:set_color(self._item_data.text_color or self.TITLE_COLOR)
	else
		self._card_title:set_text("")
		self._card_title:hide()
	end

	self._card_description:set_text("")
	self._card_description:hide()

	local bonus_xp_reward = managers.challenge_cards:get_card_xp_label(self._item_data.key_name)

	self._xp_bonus:set_text(tostring(bonus_xp_reward) .. " ")

	local x1, y1, w1, h1 = self._xp_bonus:text_rect()

	self._xp_bonus:set_w(w1)
	self._xp_bonus:set_h(h1)
	self._xp_bonus:set_center_x(self._card_image:center_x())
	self._xp_bonus:set_color(self._item_data.text_color or self.TITLE_COLOR)

	if self._item_data.card_category == ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER then
		self._xp_bonus:set_visible(false)
	else
		self._xp_bonus:set_visible(true)
	end

	if self._item_data.key_name ~= ChallengeCardsManager.CARD_PASS_KEY_NAME then
		local card_rarity = self._item_data.rarity
		local rarity_definitions = tweak_data.challenge_cards.rarity_definition[card_rarity]
		local rarity_definitions_icon = rarity_definitions.texture_gui_dirty

		if self._item_data.texture then
			card_texture = rarity_definitions.texture .. "/" .. self._item_data.texture
			card_texture_rect = rarity_definitions.texture_rect
		end

		if rarity_definitions_icon then
			self._card_rarity_icon:set_image(rarity_definitions_icon.texture)
			self._card_rarity_icon:set_texture_rect(rarity_definitions_icon.texture_rect)
			self._card_rarity_icon:show()
		else
			self._card_rarity_icon:hide()
			Application:error("[RaidGUIControlCardDetails:set_card]", self._item_data.key_name, "is missing rarity icons!")
		end

		local card_type = self._item_data.card_type
		local type_definitions_icon = tweak_data.challenge_cards.type_definition[card_type].texture_gui_dirty

		if type_definitions_icon then
			self._card_type_icon:set_image(type_definitions_icon.texture)
			self._card_type_icon:set_texture_rect(type_definitions_icon.texture_rect)
			self._card_type_icon:show()
		else
			self._card_type_icon:hide()
			Application:warn("[RaidGUIControlCardDetails:set_card]", self._item_data.key_name, "is missing rarity icons!")
		end
	else
		self._card_rarity_icon:hide()
		self._card_type_icon:hide()
		self._card_title:hide()
	end

	self:set_card_image(card_texture, card_texture_rect)
	self._card_image:show()

	if is_inventory_item then
		if self._item_data.steam_instances then
			local stack_amount = 0

			for steam_inst_id, steam_data in pairs(card_data.steam_instances) do
				stack_amount = stack_amount + (steam_data.stack_amount or 1)
			end

			self:set_card_stack_amount(stack_amount)
		else
			self:set_card_stack_amount(0)
		end
	end

	self._card_panel:set_visible(true)
end

function RaidGUIControlCardBase:set_card_stack_amount(stack_amount)
	if stack_amount >= 1 then
		self._card_amount_label:set_text(tostring(stack_amount) .. "x")
		self._card_amount_label:show()
		self._card_amount_background:show()

		local stacking_texture, stacking_texture_rect = managers.challenge_cards:get_cards_stacking_texture(self._item_data)

		if stacking_texture and stacking_texture_rect then
			self._card_stackable_image:set_image(stacking_texture, unpack(stacking_texture_rect))
			self._card_stackable_image:set_visible(true)
		end

		self._card_image:set_color(Color.white)
		self._object:set_alpha(1)
	else
		self._card_amount_label:set_text("")
		self._card_amount_label:hide()
		self._card_amount_background:hide()
		self._card_stackable_image:hide()
		self._card_image:set_color(Color(0.33, 0.33, 0.33))
		self._object:set_alpha(0.5)
	end
end

function RaidGUIControlCardBase:set_card_image(texture, texture_rect)
	self._card_image:set_image(texture)
	self._card_image:set_texture_rect(unpack(texture_rect))
end

function RaidGUIControlCardBase:set_title(title)
	self._card_title:set_text(title)
end

function RaidGUIControlCardBase:set_description(description)
	self._card_description:set_text(description)
end

function RaidGUIControlCardBase:set_xp_bonus(xp_bonus)
	self._xp_bonus:set_text(xp_bonus)
end

function RaidGUIControlCardBase:set_color(color)
	self._card_title:set_color(color)
	self._xp_bonus:set_color(color)
end

function RaidGUIControlCardBase:set_title_visible(flag)
	self._card_title:set_visible(flag)
end

function RaidGUIControlCardBase:set_description_visible(flag)
	self._card_description:set_visible(flag)
end

function RaidGUIControlCardBase:set_xp_bonus_visible(flag)
	self._xp_bonus:set_visible(flag)
end

function RaidGUIControlCardBase:set_rarity_icon_visible(flag)
	self._card_type_icon:set_visible(flag)
end

function RaidGUIControlCardBase:set_type_icon_visible(flag)
	self._card_rarity_icon:set_visible(flag)
end

function RaidGUIControlCardBase:set_visible(flag)
	self._card_image:set_visible(flag)
	self:set_title_visible(flag)
	self:set_rarity_icon_visible(flag)
	self:set_type_icon_visible(flag)
end

function RaidGUIControlCardBase:show_card_only()
	self._card_image:set_visible(true)
	self:set_title_visible(false)
	self:set_xp_bonus_visible(false)
	self:set_rarity_icon_visible(false)
	self:set_type_icon_visible(false)
end

function RaidGUIControlCardBase:mouse_released(o, button, x, y)
	self:on_mouse_released(button, x, y)

	return true
end

function RaidGUIControlCardBase:on_mouse_released(button, x, y)
	if self._on_click_callback then
		self._on_click_callback(button, self, self._item_data)
	end
end

function RaidGUIControlCardBase:selected()
	return self._selected
end

function RaidGUIControlCardBase:select()
	self._selected = true
end

function RaidGUIControlCardBase:unselect()
	self._selected = false
end

function RaidGUIControlCardBase:w()
	return self._card_image:w()
end

function RaidGUIControlCardBase:h()
	return self._card_image:h()
end

function RaidGUIControlCardBase:left()
	return self._card_image:x()
end

function RaidGUIControlCardBase:right()
	return self:left() + self:w()
end

function RaidGUIControlCardBase:set_center_x(x)
	self._object:set_center_x(x)
end
