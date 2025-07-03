MenuListItemToggle = MenuListItemToggle or class(MenuListItem)
MenuListItemToggle.HEIGHT = 46
MenuListItemToggle.NAME_FONT_SIZE = tweak_data.gui.font_sizes.large
MenuListItemToggle.CONTROL_W = 240
MenuListItemToggle.CONTROL_H = 32
MenuListItemToggle.CONTROL_ICON = "btn_secondary_192"
MenuListItemToggle.CONTROL_FONT = tweak_data.gui.fonts.din_compressed
MenuListItemToggle.CONTROL_FONT_SIZE = tweak_data.gui.font_sizes.medium
MenuListItemToggle.CONTROL_ACTIVE_COLOR = tweak_data.gui.colors.raid_black
MenuListItemToggle.PRESSED_SCALE = 0.9

function MenuListItemToggle:init(parent, params, data)
	data.value = data.value or false
	self._on_value_changed_callback = data.on_value_changed_callback or params.on_value_changed_callback

	MenuListItemToggle.super.init(self, parent, params, data)
end

function MenuListItemToggle:_layout(params, item_data)
	MenuListItemToggle.super._layout(self, params, item_data)

	local panel_w = item_data.control_w or self.CONTROL_W
	local panel_h = item_data.CONTROL_H or self.CONTROL_H

	self._item_w = panel_w / 2

	local font = item_data.control_font or self.CONTROL_FONT
	local font_size = item_data.control_font_size or self.CONTROL_FONT_SIZE
	local on_text = item_data.on_text or "ON"
	local off_text = item_data.off_text or "OFF"

	self._toggle_panel = self._object:panel({
		h = panel_h,
		layer = self._background:layer() + 50,
		name = "toggle_panel",
		w = panel_w,
	})

	self._toggle_panel:set_right(self._object:w() - self.NAME_X)
	self._toggle_panel:set_center_y(self._object:h() / 2)

	local gui_selected = tweak_data.gui:get_full_gui_data(self.CONTROL_ICON)

	self._active_background = self._toggle_panel:bitmap({
		color = self.TEXT_COLOR,
		h = self._toggle_panel:h(),
		name = "gold_icon",
		texture = gui_selected.texture,
		texture_rect = gui_selected.texture_rect,
		w = self._item_w,
	})
	self._off_label = self._toggle_panel:label({
		align = "center",
		color = self:is_value_off() and self.CONTROL_ACTIVE_COLOR or self.TEXT_COLOR,
		font = font,
		font_size = font_size,
		layer = self._active_background:layer() + 1,
		name = "off_label",
		text = off_text,
		vertical = "center",
		w = self._item_w,
	})
	self._on_label = self._toggle_panel:label({
		align = "center",
		color = self:is_value_on() and self.CONTROL_ACTIVE_COLOR or self.TEXT_COLOR,
		font = font,
		font_size = font_size,
		layer = self._active_background:layer() + 1,
		name = "on_label",
		text = on_text,
		vertical = "center",
		w = self._item_w,
	})

	self._on_label:set_right(self._toggle_panel:w())

	if self:is_value_on() then
		self._active_background:set_center_x(self._on_label:center_x())
	end
end

function MenuListItemToggle:set_value(value)
	if self._data.value == value then
		return
	end

	self._data.value = value

	self._toggle_panel:stop()
	self._toggle_panel:animate(callback(self, self, "_animate_activate"))
	managers.menu_component:post_event("highlight")

	if self._on_value_changed_callback then
		self._on_value_changed_callback(self._data)
	end
end

function MenuListItemToggle:get_value()
	return self._data and self._data.value or false
end

function MenuListItemToggle:get_on_value()
	return self._data and self._data.on_value or true
end

function MenuListItemToggle:get_off_value()
	return self._data and self._data.off_value or false
end

function MenuListItemToggle:is_value_on()
	return self:get_value() == self:get_on_value()
end

function MenuListItemToggle:is_value_off()
	return self:get_value() == self:get_off_value()
end

function MenuListItemToggle:mouse_pressed(o, button, x, y)
	if not self._enabled then
		return
	end

	local result = MenuListItemToggle.super.mouse_pressed(self, o, button, x, y)

	if button == Idstring("0") and self:inside(x, y) then
		self._active_background:stop()
		self._active_background:animate(callback(self, self, "_animate_pressed", true))
	end

	return result
end

function MenuListItemToggle:mouse_released(o, button, x, y)
	if not self._enabled then
		return
	end

	local result = MenuListItemToggle.super.mouse_released(self, o, button, x, y)

	if button == Idstring("0") and self:inside(x, y) then
		self._active_background:stop()
		self._active_background:animate(callback(self, self, "_animate_pressed", false))
	end

	return result
end

function MenuListItemToggle:move_left()
	if not self:is_selected() then
		return false
	end

	self:set_value(self:get_off_value())

	return true
end

function MenuListItemToggle:move_right()
	if not self:is_selected() then
		return false
	end

	self:set_value(self:get_on_value())

	return true
end

function MenuListItemToggle:activate()
	if self:is_value_off() then
		self._data.value = self:get_on_value()
	else
		self._data.value = self:get_off_value()
	end

	self._toggle_panel:stop()
	self._toggle_panel:animate(callback(self, self, "_animate_activate"))

	if self._on_value_changed_callback then
		self._on_value_changed_callback(self._data)
	end

	return MenuListItemToggle.super.activate(self)
end

function MenuListItemToggle:_animate_select()
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
		self._active_background:set_color(current_color)
	end

	self._background:set_alpha(1)
	self._name_panel:set_x(self.NAME_X * 2)
	self._name_label:set_color(highlight_color)
	self._active_background:set_color(highlight_color)
end

function MenuListItemToggle:_animate_unselect()
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
		self._active_background:set_color(current_color)
	end

	self._background:hide()
	self._background:set_alpha(0)
	self._name_panel:set_x(self.NAME_X)
	self._name_label:set_color(normal_color)
	self._active_background:set_color(normal_color)
end

function MenuListItemToggle:_animate_activate()
	local duration = 0.12
	local t = 0
	local start_x = self._active_background:center_x()
	local target_x = self:is_value_on() and self._on_label:center_x() or self._off_label:center_x()
	local off_color = self:is_value_on() and self.TEXT_COLOR or self.CONTROL_ACTIVE_COLOR
	local on_color = self:is_value_on() and self.CONTROL_ACTIVE_COLOR or self.TEXT_COLOR

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local progress = Easing.quadratic_out(t, 0, 1, duration)
		local current_x = math.lerp(start_x, target_x, progress)

		self._active_background:set_center_x(current_x)
		self._off_label:set_color(math.lerp(on_color, off_color, progress))
		self._on_label:set_color(math.lerp(off_color, on_color, progress))
	end

	self._active_background:set_center_x(target_x)
end

function MenuListItemToggle:_animate_pressed(pressed, object)
	local t = 0
	local original_w = self._item_w
	local original_h = self._toggle_panel:h()
	local start_scale = object:w() / original_w
	local target_scale = pressed and self.PRESSED_SCALE or 1
	local duration = 0.18 * ((start_scale - self.PRESSED_SCALE) / (1 - self.PRESSED_SCALE))
	local center_x, center_y

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt
		center_x, center_y = object:center()

		local progress = Easing.quartic_out(t, 0, 1, duration)
		local scale = math.lerp(start_scale, target_scale, progress)

		object:set_size(original_w * scale, original_h * scale)
		object:set_center(center_x, center_y)
	end

	center_x, center_y = object:center()

	object:set_size(original_w * target_scale, original_h * target_scale)
	object:set_center(center_x, center_y)
end
