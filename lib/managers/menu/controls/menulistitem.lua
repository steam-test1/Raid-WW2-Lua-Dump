MenuListItem = MenuListItem or class(RaidGUIControl)

require("lib/managers/menu/controls/MenuListItemPurchasable")
require("lib/managers/menu/controls/MenuListItemToggle")
require("lib/managers/menu/controls/MenuListItemSlider")
require("lib/managers/menu/controls/MenuListItemStepper")

MenuListItem.HEIGHT = 64
MenuListItem.BACKGROUND_LEFT = "list_item_background_left"
MenuListItem.BACKGROUND_CENTER = "list_item_background_center"
MenuListItem.BACKGROUND_RIGHT = "list_item_background_right"
MenuListItem.BACKGROUND_COLOR = tweak_data.gui.colors.grid_item_grey
MenuListItem.NAME_X = 16
MenuListItem.NAME_Y = 8
MenuListItem.NAME_FONT = tweak_data.gui.fonts.din_compressed
MenuListItem.NAME_FONT_SIZE = tweak_data.gui.font_sizes.size_38
MenuListItem.TEXT_COLOR = tweak_data.gui.colors.raid_grey
MenuListItem.TEXT_HIGHLIGHT_COLOR = tweak_data.gui.colors.raid_white
MenuListItem.TEXT_DISABLED_COLOR = tweak_data.gui.colors.raid_dark_grey

function MenuListItem:init(parent, params, data)
	MenuListItem.super.init(self, parent, params)

	self._on_click_list_callback = params.on_click_callback
	self._on_click_callback = data.on_click_callback
	self._on_item_selected_callback = data.on_item_selected_callback or params.on_item_selected_callback
	self._data = data

	self:_layout_panel(params)
	self:_layout(params, data)

	if self._data.breadcrumb then
		self:_layout_breadcrumb()
	end

	self:set_enabled(data.enabled == nil and true or data.enabled)
end

function MenuListItem:_layout_panel(params)
	self._object = self._panel:panel({
		h = params.h or self.HEIGHT,
		name = "list_item",
		w = params.w,
		x = params.x,
		y = params.y,
	})
end

function MenuListItem:_layout_breadcrumb()
	self._breadcrumb = self._object:breadcrumb({
		category = self._data.breadcrumb.category,
		identifiers = self._data.breadcrumb.identifiers,
		layer = self._background:layer() + 10,
	})

	self._breadcrumb:set_right(self._object:w() + self.NAME_X)
	self._breadcrumb:set_center_y(self._object:h() / 2)
end

function MenuListItem:_layout(params, item_data)
	self._background = self._object:three_cut_bitmap({
		alpha = 0,
		center = self.BACKGROUND_CENTER,
		color = self.BACKGROUND_COLOR,
		h = self._object:h(),
		left = self.BACKGROUND_LEFT,
		name = "background",
		right = self.BACKGROUND_RIGHT,
		visible = false,
		w = self._object:w(),
	})
	self._name_panel = self._object:panel({
		layer = self._background:layer() + 4,
		name = "name_panel",
		x = self.NAME_X,
	})
	self._name_label = self._name_panel:label({
		color = self.TEXT_COLOR,
		font = item_data.font or params.item_font or self.NAME_FONT,
		font_size = item_data.font_size or params.item_font_size or self.NAME_FONT_SIZE,
		name = "name_label",
		text = item_data.title or item_data.value,
		vertical = "center",
	})
end

function MenuListItem:data()
	return self._data
end

function MenuListItem:set_enabled(enabled)
	self._enabled = enabled

	local color = self._enabled and self.TEXT_COLOR or self.TEXT_DISABLED_COLOR

	self._name_label:set_color(color)
end

function MenuListItem:highlight_on()
	if not self._enabled then
		return
	end

	if not self._highlighted then
		if self._data.breadcrumb then
			managers.breadcrumb:remove_breadcrumb(self._data.breadcrumb.category, self._data.breadcrumb.identifiers)
		end

		self._object:stop()
		self._object:animate(callback(self, self, "_animate_select"))

		self._highlighted = true
	end

	if not self._played_mouse_over_sound then
		managers.menu_component:post_event("highlight")

		self._played_mouse_over_sound = true
	end
end

function MenuListItem:highlight_off()
	if self._highlighted then
		self._object:stop()
		self._object:animate(callback(self, self, "_animate_unselect"))

		self._highlighted = nil
	end

	self._played_mouse_over_sound = nil
end

function MenuListItem:highlighted()
	return self._highlighted
end

function MenuListItem:_animate_select()
	local duration = 0.12
	local t = self._background:alpha() * duration

	self._background:show()

	local normal_color = self._enabled and self.TEXT_COLOR or self.TEXT_DISABLED_COLOR
	local highlight_color = self._data.separator_highlight_color or self.TEXT_HIGHLIGHT_COLOR

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local progress = Easing.quadratic_out(t, 0, 1, duration)

		self._background:set_alpha(progress)

		local current_x = self.NAME_X * (progress + 1)
		local current_color = math.lerp(normal_color, highlight_color, progress)

		self._name_panel:set_x(current_x)
		self._name_label:set_color(current_color)
	end

	self._background:set_alpha(1)
	self._name_panel:set_x(self.NAME_X * 2)
	self._name_label:set_color(highlight_color)
end

function MenuListItem:_animate_unselect()
	local duration = 0.12
	local t = (1 - self._background:alpha()) * duration
	local normal_color = self._enabled and self.TEXT_COLOR or self.TEXT_DISABLED_COLOR
	local highlight_color = self._data.separator_highlight_color or self.TEXT_HIGHLIGHT_COLOR

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local progress = Easing.quadratic_out(t, 1, -1, duration)

		self._background:set_alpha(progress)

		local current_x = self.NAME_X * (progress + 1)
		local current_color = math.lerp(normal_color, highlight_color, progress)

		self._name_panel:set_x(current_x)
		self._name_label:set_color(current_color)
	end

	self._background:hide()
	self._background:set_alpha(0)
	self._name_panel:set_x(self.NAME_X)
	self._name_label:set_color(normal_color)
end

function MenuListItem:on_mouse_released(button)
	return self:activate()
end

function MenuListItem:confirm_pressed()
	if not self._selected then
		return false
	end

	return self:activate()
end

function MenuListItem:activate()
	if self._on_click_list_callback then
		self._on_click_list_callback(nil, self, self._data, true)
	end

	if self._on_click_callback then
		self._on_click_callback(self._data)
	end

	return false
end

function MenuListItem:select(dont_trigger_selected_callback)
	if not self._enabled or self._selected then
		return
	end

	self._selected = true

	self:highlight_on()

	if self._on_item_selected_callback and not dont_trigger_selected_callback then
		self._on_item_selected_callback(self, self._data)
	end
end

function MenuListItem:unselect()
	if self._selected then
		self._selected = false

		self:highlight_off()
	end
end

function MenuListItem:selected()
	return self._selected
end
