RaidGUIControlListItem = RaidGUIControlListItem or class(RaidGUIControl)
RaidGUIControlListItem.LABEL_FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlListItem.LABEL_FONT_SIZE = tweak_data.gui.font_sizes.menu_list

function RaidGUIControlListItem:init(parent, params, data)
	RaidGUIControlListItem.super.init(self, parent, params)

	if not params.on_click_callback then
		Application:error("[RaidGUIControlListItem:init] On click callback not specified for list item: ", params.name)
	end

	self._on_click_callback = params.on_click_callback
	self._on_double_click_callback = params.on_double_click_callback
	self._on_item_selected_callback = params.on_item_selected_callback
	self._data = data
	self._object = self._panel:panel({
		h = params.h,
		name = "list_item_" .. self._name,
		w = params.w,
		x = params.x,
		y = params.y,
	})
	self._item_label = self._object:label({
		color = params.color or tweak_data.gui.colors.raid_white,
		font = self._params.item_font or self.LABEL_FONT,
		font_size = self._params.item_font_size or self.LABEL_FONT_SIZE,
		h = params.h,
		name = "list_item_label_" .. self._name,
		text = data.text,
		vertical = "center",
		w = params.w,
		x = 32,
	})
	self._item_background = self._object:rect({
		color = tweak_data.gui.colors.raid_list_background,
		h = params.h - 2,
		name = "list_item_back_" .. self._name,
		visible = false,
		w = params.w,
		x = 0,
		y = 1,
	})
	self._item_highlight_marker = self._object:rect({
		color = tweak_data.gui.colors.raid_red,
		h = params.h - 2,
		name = "list_item_highlight_" .. self._name,
		visible = false,
		w = 3,
		x = 0,
		y = 1,
	})

	if params and params.use_unlocked and self._data and self._data.value and not self._data.value.unlocked then
		self._on_click_callback = nil
		self._on_double_click_callback = nil

		RaidGUIControlListItem.super.disable(self, params.color:with_alpha(0.3))
	end

	if self._data.breadcrumb then
		self:_layout_breadcrumb()
	end

	self._mouse_over_sound = params.on_mouse_over_sound_event
	self._click_sound = params.on_mouse_click_sound_event
	self._selectable = self._data.selectable
	self._selected = false

	self:highlight_off()
end

function RaidGUIControlListItem:_layout_breadcrumb()
	self._breadcrumb = self._object:breadcrumb(self._data.breadcrumb)

	self._breadcrumb:set_right(self._object:w())
	self._breadcrumb:set_center_y(self._object:h() / 2)
end

function RaidGUIControlListItem:on_mouse_released(button)
	if self._on_click_callback then
		self._on_click_callback(button, self, self._data)
	end

	if self._data.breadcrumb then
		managers.breadcrumb:remove_breadcrumb(self._data.breadcrumb.category, self._data.breadcrumb.identifiers)
	end
end

function RaidGUIControlListItem:selected()
	return self._selected
end

function RaidGUIControlListItem:select(dont_trigger_selected_callback)
	self._selected = true

	self:highlight_on()

	if alive(self._item_highlight_marker) then
		self._item_highlight_marker:show()
	end

	if self._on_item_selected_callback and not dont_trigger_selected_callback then
		self._on_item_selected_callback(self, self._data)
	end

	if self._data.breadcrumb then
		managers.breadcrumb:remove_breadcrumb(self._data.breadcrumb.category, self._data.breadcrumb.identifiers)
	end
end

function RaidGUIControlListItem:unfocus()
	self:unselect(true)
end

function RaidGUIControlListItem:unselect(force)
	self._selected = false

	self:highlight_off(force)

	if alive(self._item_highlight_marker) then
		self._item_highlight_marker:hide()
	end
end

function RaidGUIControlListItem:data()
	return self._data
end

function RaidGUIControlListItem:highlight_on()
	if alive(self._item_background) then
		self._item_background:show()
	end

	if self._params.on_mouse_over_sound_event then
		managers.menu_component:post_event(self._params.on_mouse_over_sound_event)
	end
end

function RaidGUIControlListItem:highlight_off(force)
	if (force or not self._selected) and alive(self._item_background) then
		self._item_background:hide()
	end
end

function RaidGUIControlListItem:confirm_pressed(button)
	if self._selected then
		if self._on_click_callback then
			self:unselect()
			self._on_click_callback(button, self, self._data, true)

			return true
		end

		if self._params.list_item_selected_callback then
			self:unselect()
			self._params.list_item_selected_callback(self._name)

			return true
		end
	end
end
