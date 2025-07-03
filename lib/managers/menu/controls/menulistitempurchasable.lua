MenuListItemPurchasable = MenuListItemPurchasable or class(MenuListItem)
MenuListItemPurchasable.PURCHASE_COLOR = tweak_data.gui.colors.raid_gold
MenuListItemPurchasable.PURCHASE_VALUE_FONT = tweak_data.gui.fonts.din_compressed
MenuListItemPurchasable.PURCHASE_VALUE_FONT_SIZE = tweak_data.gui.font_sizes.subtitle

function MenuListItemPurchasable:init(parent, params, data)
	MenuListItemPurchasable.super.init(self, parent, params, data)

	if data.unlocked == false then
		if data.gold_price then
			self:_layout_purchasable(data)
		else
			self:_layout_locked(data)
		end
	end
end

function MenuListItemPurchasable:_layout_locked(item_data)
	item_data.separator_highlight_color = self.TEXT_HIGHLIGHT_COLOR
	self._locked_panel = self._object:panel({
		layer = self._background:layer() + 5,
		name = "gold_panel",
		w = 25,
	})

	self._locked_panel:set_right(self._object:w() - self.NAME_X)

	local ico_locker = tweak_data.gui:get_full_gui_data("ico_locker")

	self._locked_icon = self._locked_panel:image({
		color = self.TEXT_COLOR,
		h = 25,
		name = "gold_icon",
		texture = ico_locker.texture,
		texture_rect = ico_locker.texture_rect,
		w = 25,
	})

	self._locked_icon:set_center_y(self._locked_panel:h() / 2)
end

function MenuListItemPurchasable:_layout_purchasable(item_data)
	item_data.separator_highlight_color = self.PURCHASE_COLOR
	self._gold_panel = self._object:panel({
		layer = self._background:layer() + 5,
		name = "gold_panel",
		w = 25,
	})

	self._gold_panel:set_right(self._object:w() - self.NAME_X)

	local gold_amount_footer = tweak_data.gui:get_full_gui_data("gold_amount_footer")

	self._gold_icon = self._gold_panel:image({
		color = self.PURCHASE_COLOR,
		h = 25,
		name = "gold_icon",
		texture = gold_amount_footer.texture,
		texture_rect = gold_amount_footer.texture_rect,
		w = 25,
	})

	self._gold_icon:set_center_y(self._gold_panel:h() / 2)

	local gold_price = managers.gold_economy:gold_string(item_data.gold_price or 0)

	self._gold_value_label = self._gold_panel:label({
		color = self.PURCHASE_COLOR,
		fit_text = true,
		font = self.PURCHASE_VALUE_FONT,
		font_size = self.PURCHASE_VALUE_FONT_SIZE,
		name = "profile_name_label",
		text = gold_price,
		vertical = "center",
	})

	self._gold_value_label:set_left(self._gold_icon:right() + 2)
	self._gold_value_label:set_center_y(self._gold_panel:h() / 2)
end

function MenuListItemPurchasable:_animate_select()
	local duration = 0.12
	local t = self._background:alpha() * duration

	self._background:show()

	local normal_color = self._data.unlocked == false and self.TEXT_DISABLED_COLOR or self.TEXT_COLOR
	local highlight_color = self._data.separator_highlight_color or self.TEXT_HIGHLIGHT_COLOR

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local progress = Easing.quadratic_out(t, 0, 1, duration)

		self._background:set_alpha(progress)

		if self._gold_panel then
			local current_w = math.lerp(self._gold_icon:w(), self._gold_value_label:right(), progress)

			self._gold_panel:set_w(current_w)
			self._gold_panel:set_right(self._object:w() - self.NAME_X)
			self._gold_value_label:set_alpha(progress)
		end

		local current_x = self.NAME_X * (progress + 1)
		local current_color = math.lerp(normal_color, highlight_color, progress)

		self._name_panel:set_x(current_x)
		self._name_label:set_color(current_color)
	end

	self._background:set_alpha(1)

	if self._gold_panel then
		self._gold_panel:set_w(self._gold_value_label:right())
		self._gold_panel:set_right(self._object:w() - self.NAME_X)
		self._gold_value_label:set_alpha(1)
	end

	self._name_panel:set_x(self.NAME_X * 2)
	self._name_label:set_color(highlight_color)
end

function MenuListItemPurchasable:_animate_unselect()
	local duration = 0.12
	local t = (1 - self._background:alpha()) * duration
	local normal_color = self._data.unlocked == false and self.TEXT_DISABLED_COLOR or self.TEXT_COLOR
	local highlight_color = self._data.separator_highlight_color or self.TEXT_HIGHLIGHT_COLOR

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local progress = Easing.quadratic_out(t, 1, -1, duration)

		self._background:set_alpha(progress)

		if self._gold_icon then
			local current_w = math.lerp(self._gold_icon:w(), self._gold_value_label:right(), progress)

			self._gold_panel:set_w(current_w)
			self._gold_panel:set_right(self._object:w() - self.NAME_X)
			self._gold_value_label:set_alpha(progress)
		end

		local current_x = self.NAME_X * (progress + 1)
		local current_color = math.lerp(normal_color, highlight_color, progress)

		self._name_panel:set_x(current_x)
		self._name_label:set_color(current_color)
	end

	self._background:hide()
	self._background:set_alpha(0)

	if self._gold_panel then
		self._gold_panel:set_w(self._gold_icon:w())
		self._gold_panel:set_right(self._object:w() - self.NAME_X)
		self._gold_value_label:set_alpha(0)
	end

	self._name_panel:set_x(self.NAME_X)
	self._name_label:set_color(normal_color)
end
