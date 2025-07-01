RaidGUIControlCardSuggestedLarge = RaidGUIControlCardSuggestedLarge or class(RaidGUIControl)
RaidGUIControlCardSuggestedLarge.ICON_PADDING = 20
RaidGUIControlCardSuggestedLarge.ICON_WIDTH = 32
RaidGUIControlCardSuggestedLarge.SELECT_TRINGLE_SIZE = 30

function RaidGUIControlCardSuggestedLarge:init(parent, params, item_data, grid_params)
	RaidGUIControlCardSuggestedLarge.super.init(self, parent, params, item_data, grid_params)

	self._item_data = item_data
	self._grid_params = grid_params
	self._object = self._panel:panel({
		h = self._params.selected_marker_h,
		layer = self._parent:layer() + 10,
		name = "suggested_card_large_object_panel_" .. self._name,
		w = self._params.selected_marker_w,
		x = self._params.x,
		y = self._params.y,
	})

	if self._grid_params and self._grid_params.on_click_callback then
		self._on_click_callback = self._grid_params.on_click_callback
	end

	if self._params and self._params.item_selected_callback then
		self._item_selected_callback = self._params.item_selected_callback
	end

	self._sound_source = SoundDevice:create_source("challenge_card")
end

function RaidGUIControlCardSuggestedLarge:get_data()
	return self._item_data
end

function RaidGUIControlCardSuggestedLarge:update()
	return
end

function RaidGUIControlCardSuggestedLarge:set_card(card_data)
	self._item_data = card_data
	self._item_data.peer_id = self._params.peer_id

	if self._item_data.peer_id and managers.network:session():all_peers()[self._item_data.peer_id] then
		local peer_name = managers.network:session():all_peers()[self._item_data.peer_id]:name()

		self._item_data.peer_name = peer_name
	end

	self._object:clear()

	local card_texture = tweak_data.challenge_cards.challenge_card_texture_path .. (card_data.texture or "cc_raid_common_on_the_scrounge_hud")
	local card_texture_rect = tweak_data.challenge_cards.challenge_card_texture_rect
	local card_x = math.floor((self._params.selected_marker_w - self._params.item_width) / 2)
	local card_y = 32

	self._challenge_card_panel = self._object:panel({
		h = self._params.item_height,
		layer = self._object:layer() + 1,
		name = "suggested_card_panel_card_" .. self._name,
		w = self._params.item_width,
		x = card_x,
		y = card_y,
	})
	self._select_marker_panel = self._object:panel({
		h = self._object:h(),
		layer = self._object:layer(),
		name = "select_marker_panel_" .. self._name,
		visible = false,
		w = self._object:w(),
		x = 0,
		y = 0,
	})
	self._select_marker_rect = self._select_marker_panel:rect({
		color = tweak_data.gui.colors.raid_select_card_background,
		h = self._object:h(),
		name = "select_marker_rect_" .. self._name,
		w = self._object:w(),
		x = 0,
		y = 0,
	})
	self._top_select_triangle = self._select_marker_panel:image({
		h = RaidGUIControlCardSuggestedLarge.SELECT_TRINGLE_SIZE,
		texture = tweak_data.gui.icons.ico_sel_rect_top_left.texture,
		texture_rect = tweak_data.gui.icons.ico_sel_rect_top_left.texture_rect,
		w = RaidGUIControlCardSuggestedLarge.SELECT_TRINGLE_SIZE,
		x = 0,
		y = 0,
	})
	self._bottom_select_triangle = self._select_marker_panel:image({
		h = RaidGUIControlCardSuggestedLarge.SELECT_TRINGLE_SIZE,
		texture = tweak_data.gui.icons.ico_sel_rect_bottom_right.texture,
		texture_rect = tweak_data.gui.icons.ico_sel_rect_bottom_right.texture_rect,
		w = RaidGUIControlCardSuggestedLarge.SELECT_TRINGLE_SIZE,
		x = self._select_marker_panel:w() - RaidGUIControlCardSuggestedLarge.SELECT_TRINGLE_SIZE,
		y = self._select_marker_panel:h() - RaidGUIControlCardSuggestedLarge.SELECT_TRINGLE_SIZE,
	})
	self._card_image = self._challenge_card_panel:bitmap({
		h = self._challenge_card_panel:h(),
		layer = self._select_marker_panel:layer() + 1,
		name = "suggested_card_image_" .. self._name,
		texture = card_texture,
		texture_rect = card_texture_rect,
		w = self._challenge_card_panel:w(),
	})

	local card_type = self._item_data.card_type or "card_type_none"
	local type_definitions_icon = tweak_data.challenge_cards.type_definition[card_type].texture_gui

	self._type_icon = self._challenge_card_panel:image({
		h = RaidGUIControlCardSuggestedLarge.ICON_WIDTH,
		layer = self._card_image:layer() + 1,
		name = "suggested_card_type_icon_" .. self._name,
		texture = type_definitions_icon.texture,
		texture_rect = type_definitions_icon.texture_rect,
		w = RaidGUIControlCardSuggestedLarge.ICON_WIDTH,
		x = RaidGUIControlCardSuggestedLarge.ICON_PADDING,
		y = RaidGUIControlCardSuggestedLarge.ICON_PADDING - 3,
	})

	local card_rarity = self._item_data.rarity
	local rarity_definitions_icon = tweak_data.challenge_cards.rarity_definition[card_rarity].texture_gui

	self._rarity_icon = self._challenge_card_panel:image({
		h = RaidGUIControlCardSuggestedLarge.ICON_WIDTH,
		layer = self._card_image:layer() + 1,
		name = "suggested_card_rarity_icon_" .. self._name,
		texture = rarity_definitions_icon.texture,
		texture_rect = rarity_definitions_icon.texture_rect,
		w = RaidGUIControlCardSuggestedLarge.ICON_WIDTH,
		x = self._challenge_card_panel:w() - RaidGUIControlCardSuggestedLarge.ICON_PADDING - RaidGUIControlCardSuggestedLarge.ICON_WIDTH,
		y = RaidGUIControlCardSuggestedLarge.ICON_PADDING - 3,
	})

	if not self._item_data.title_in_texture then
		local title_h = self._card_image:h() * RaidGUIControlCardBase.TITLE_H
		local title_font_size = tweak_data.gui.font_sizes.medium

		self._card_title = self._challenge_card_panel:label({
			align = "center",
			font = tweak_data.gui.fonts.din_compressed,
			font_size = title_font_size,
			h = title_h,
			layer = self._card_image:layer() + 1,
			name = "suggested_card_title_" .. self._name,
			text = self:translate(self._item_data.name, true),
			vertical = "center",
			w = self._card_image:w() * (1 - 2 * RaidGUIControlCardBase.TITLE_PADDING),
			wrap = true,
			x = self._card_image:x() + self._card_image:w() * RaidGUIControlCardBase.TITLE_PADDING,
			y = self._card_image:y() + self._card_image:h() * RaidGUIControlCardBase.TITLE_Y,
		})

		local _, _, w, h = self._card_title:text_rect()

		if title_h < h then
			self:_refit_card_title_text(title_font_size)
		end
	end

	local params_xp_bonus = {
		align = "center",
		color = tweak_data.gui.colors.raid_white,
		font = RaidGUIControlCardBase.XP_BONUS_FONT,
		font_size = math.ceil(RaidGUIControlCardBase.XP_BONUS_FONT_SIZE * self._card_image:w() * 0.002),
		h = self._card_image:h() * RaidGUIControlCardBase.XP_BONUS_H,
		layer = self._card_image:layer() + 1,
		name = "xp_bonus",
		text = "",
		vertical = "center",
		w = self._card_image:w() * RaidGUIControlCardBase.XP_BONUS_W,
		x = 0,
		y = self._card_image:y() + self._card_image:h() * RaidGUIControlCardBase.XP_BONUS_Y,
	}

	self._xp_bonus = self._challenge_card_panel:label(params_xp_bonus)

	local bonus_xp_reward = managers.challenge_cards:get_card_xp_label(self._item_data.key_name)

	self._xp_bonus:set_text(bonus_xp_reward)

	local x1, y1, w1, h1 = self._xp_bonus:text_rect()

	self._xp_bonus:set_w(w1)
	self._xp_bonus:set_h(h1)
	self._xp_bonus:set_center_x(self._card_image:w() / 2)

	local bonus_description, malus_description = managers.challenge_cards:get_card_description(self._item_data)

	if bonus_description and bonus_description ~= "" then
		self._bonus_image = self._object:image({
			h = 64,
			layer = self._challenge_card_panel:layer() + 1,
			name = "suggested_card_bonus_image_" .. self._name,
			texture = tweak_data.gui.icons.ico_bonus.texture,
			texture_rect = tweak_data.gui.icons.ico_bonus.texture_rect,
			w = 64,
			x = self._challenge_card_panel:x(),
			y = self._challenge_card_panel:y() + self._challenge_card_panel:h() + 32,
		})
		self._bonus_label = self._object:label({
			align = "left",
			color = tweak_data.gui.colors.raid_grey,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.small,
			h = 64,
			layer = self._challenge_card_panel:layer() + 1,
			name = "suggested_card_bonus_label_" .. self._name,
			text = bonus_description,
			vertical = "top",
			w = self._challenge_card_panel:w() - self._bonus_image:w() - 10,
			wrap = true,
			x = self._bonus_image:x() + self._bonus_image:w() + 10,
			y = self._bonus_image:y(),
		})
	end

	if malus_description and malus_description ~= "" then
		self._malus_image = self._object:image({
			h = 64,
			layer = self._challenge_card_panel:layer() + 1,
			name = "suggested_card_malus_image_" .. self._name,
			texture = tweak_data.gui.icons.ico_malus.texture,
			texture_rect = tweak_data.gui.icons.ico_malus.texture_rect,
			w = 64,
			x = self._challenge_card_panel:x(),
			y = self._challenge_card_panel:y() + self._challenge_card_panel:h() + 112,
		})
		self._malus_label = self._object:label({
			align = "left",
			color = tweak_data.gui.colors.raid_grey,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.small,
			h = 64,
			layer = self._challenge_card_panel:layer() + 1,
			name = "suggested_card_malus_label_" .. self._name,
			text = malus_description,
			vertical = "top",
			w = self._challenge_card_panel:w() - self._malus_image:w() - 10,
			wrap = true,
			x = self._malus_image:x() + self._malus_image:w() + 10,
			y = self._malus_image:y(),
		})
	end

	self._peer_name_label = self._object:label({
		align = "right",
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		h = 30,
		layer = self._challenge_card_panel:layer() + 1,
		name = "suggested_card_malus_label_" .. self._name,
		text = utf8.to_upper(self._item_data.peer_name),
		w = self._card_image:w(),
		x = 10,
		y = self._object:h() - 64,
	})

	self._peer_name_label:set_right(self._challenge_card_panel:right())

	if self._item_data and self._item_data.key_name == ChallengeCardsManager.CARD_PASS_KEY_NAME then
		self:_show_pass_card_controls()
	end

	self:_set_visible_selected_marker(false)
end

function RaidGUIControlCardSuggestedLarge:_refit_card_title_text(original_font_size)
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

function RaidGUIControlCardSuggestedLarge:_show_pass_card_controls()
	local empty_slot_texture = tweak_data.gui.icons.cc_empty_slot_small

	self._card_image:set_image(empty_slot_texture.texture)
	self._card_image:set_texture_rect(unpack(empty_slot_texture.texture_rect))
	self._type_icon:set_visible(false)

	if self._rarity_icon then
		self._rarity_icon:set_visible(false)
	end

	self._card_title:set_visible(false)
	self._xp_bonus:set_visible(false)

	if self._item_data.key_name ~= ChallengeCardsManager.CARD_PASS_KEY_NAME then
		self._bonus_image:set_visible(false)
		self._malus_image:set_visible(false)
		self._bonus_label:set_visible(false)
		self._malus_label:set_visible(false)
	else
		local peer_name_label = self._object:label({
			align = "center",
			color = tweak_data.gui.colors.dirty_white,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_32,
			h = 32,
			layer = self._challenge_card_panel:layer() + 1,
			name = "peer_name",
			text = utf8.to_upper(self._item_data.peer_name),
			w = self._object:w(),
			x = 0,
			y = self._object:h() - 192,
		})

		self._object:label({
			align = "center",
			color = tweak_data.gui.colors.raid_grey,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
			h = 24,
			layer = self._challenge_card_panel:layer() + 1,
			name = "didnt_select_card_label",
			text = self:translate("menu_didnt_select_a_card", true),
			w = self._object:w(),
			x = 0,
			y = peer_name_label:bottom() + 16,
		})
	end
end

function RaidGUIControlCardSuggestedLarge:_set_visible_selected_marker(flag)
	self._select_marker_panel:set_visible(flag)
end

function RaidGUIControlCardSuggestedLarge:select()
	self._selected = true

	if self._select_marker_panel then
		self:_set_visible_selected_marker(true)
	end
end

function RaidGUIControlCardSuggestedLarge:unselect()
	self._selected = false

	if self._select_marker_panel then
		self:_set_visible_selected_marker(false)
	end
end

function RaidGUIControlCardSuggestedLarge:selected()
	return self._selected
end

function RaidGUIControlCardSuggestedLarge:mouse_released(o, button, x, y)
	self:on_mouse_released(button, x, y)
end

function RaidGUIControlCardSuggestedLarge:on_mouse_released(button, x, y)
	local is_host = Network:is_server()

	if not self._item_data or not is_host then
		return true
	end

	if self._item_selected_callback then
		self._item_selected_callback(self._params.item_idx)
	end

	if self._on_click_callback then
		local item_data = clone(self._item_data)

		if not self:selected() then
			item_data = nil
		end

		self._on_click_callback(item_data)
	end

	self._sound_source:post_event("challenge_card_select")

	return true
end

function RaidGUIControlCardSuggestedLarge:on_mouse_over(x, y)
	RaidGUIControlCardSuggestedLarge.super.on_mouse_over(self, x, y)
	self._sound_source:post_event("card_mouse_over")
end

function RaidGUIControlCardSuggestedLarge:close()
	return
end
