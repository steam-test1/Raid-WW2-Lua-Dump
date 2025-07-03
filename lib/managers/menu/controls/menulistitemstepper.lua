MenuListItemStepper = MenuListItemStepper or class(MenuListItem)
MenuListItemStepper.HEIGHT = 46
MenuListItemStepper.NAME_FONT_SIZE = tweak_data.gui.font_sizes.large
MenuListItemStepper.CONTROL_W = 240
MenuListItemStepper.CONTROL_H = 32
MenuListItemStepper.CONTROL_FONT = tweak_data.gui.fonts.din_compressed
MenuListItemStepper.CONTROL_FONT_SIZE = tweak_data.gui.font_sizes.medium
MenuListItemStepper.CONTROL_ACTIVE_COLOR = tweak_data.gui.colors.raid_black
MenuListItemStepper.BUTTON_ICON_LEFT = "hslider_arrow_left_base"
MenuListItemStepper.BUTTON_ICON_RIGHT = "hslider_arrow_right_base"
MenuListItemStepper.BUTTON_COLOR = tweak_data.gui.colors.raid_grey
MenuListItemStepper.BUTTON_HIGHLIGHT_COLOR = tweak_data.gui.colors.raid_red

function MenuListItemStepper:init(parent, params, data)
	data.value = data.value
	self._on_value_changed_callback = data.on_value_changed_callback or params.on_value_changed_callback
	self._data_source_callback = data.data_source_callback

	MenuListItemToggle.super.init(self, parent, params, data)
end

function MenuListItemStepper:_layout(params, item_data)
	MenuListItemStepper.super._layout(self, params, item_data)

	local panel_w = item_data.control_w or self.CONTROL_W
	local panel_h = item_data.CONTROL_H or self.CONTROL_H
	local font = item_data.control_font or self.CONTROL_FONT
	local font_size = item_data.control_font_size or self.CONTROL_FONT_SIZE

	self._stepper_panel = self._object:panel({
		h = panel_h,
		layer = self._background:layer() + 50,
		name = "stepper_panel",
		w = panel_w,
	})

	self._stepper_panel:set_right(self._object:w() - self.NAME_X)
	self._stepper_panel:set_center_y(self._object:h() / 2)

	local gui_left = tweak_data.gui:get_full_gui_data(self.BUTTON_ICON_LEFT)

	self._arrow_left = self._stepper_panel:image_button({
		color = self.BUTTON_COLOR,
		highlight_color = self.BUTTON_HIGHLIGHT_COLOR,
		name = "left_arrow",
		on_click_callback = callback(self, self, "on_left_arrow_clicked"),
		texture = gui_left.texture,
		texture_rect = gui_left.texture_rect,
	})

	local gui_right = tweak_data.gui:get_full_gui_data(self.BUTTON_ICON_RIGHT)

	self._arrow_right = self._stepper_panel:image_button({
		color = self.BUTTON_COLOR,
		highlight_color = self.BUTTON_HIGHLIGHT_COLOR,
		name = "arrow_right",
		on_click_callback = callback(self, self, "on_right_arrow_clicked"),
		texture = gui_right.texture,
		texture_rect = gui_right.texture_rect,
	})

	self._arrow_right:set_right(self._stepper_panel:w())

	local label_w = self._stepper_panel:w() - self._arrow_left:w() - self._arrow_right:w()

	self._value_label = self._stepper_panel:text({
		align = "center",
		color = self.TEXT_COLOR,
		font = font,
		font_size = font_size,
		name = "value_label",
		text = "VALUE",
		vertical = "center",
		w = label_w,
		x = self._arrow_left:right(),
	})

	self:refresh_data()
end

function MenuListItemStepper:set_value(value, skip_animation)
	if not self._stepper_data then
		return
	end

	for item_index, item_data in ipairs(self._stepper_data) do
		if value == item_data.value then
			return self:_select_item(item_index, skip_animation)
		end
	end

	self:_select_item(1, true)
end

function MenuListItemStepper:get_value()
	return self._data and self._data.value
end

function MenuListItemStepper:selected_item()
	return self._stepper_data[self._value_index]
end

function MenuListItemStepper:_select_item(index, skip_animation)
	local item = self._stepper_data[index]

	if not item then
		return
	end

	local previous_index = self._value_index
	local text = item.text or managers.localization:to_upper_text(item.text_id)
	local disabled = item.disabled

	self._value_index = index
	self._data.value = item.value

	self._arrow_left:set_visible(index > 1)
	self._arrow_right:set_visible(index < #self._stepper_data)

	if skip_animation then
		self._value_label:set_text(text)
	else
		local anim_data = {
			disabled = disabled,
			previous = previous_index and previous_index > self._value_index,
			text = text,
		}

		self._value_label:stop()
		self._value_label:animate(callback(self, self, "_animate_activate"), anim_data)
	end
end

function MenuListItemStepper:_delete_items()
	self._stepper_data = {}

	self._value_label:set_text("")
	self._arrow_left:set_visible(false)
	self._arrow_right:set_visible(false)
end

function MenuListItemStepper:refresh_data()
	self:_delete_items()

	if self._data_source_callback then
		self._stepper_data = self._data_source_callback()

		self:set_value(self._data.value, true)
	end
end

function MenuListItemStepper:stepper_data()
	return self._stepper_data
end

function MenuListItemStepper:set_enabled(enabled)
	self._enabled = enabled

	self._arrow_left:set_enabled(enabled)
	self._arrow_right:set_enabled(enabled)

	local color = self._enabled and self.TEXT_COLOR or self.TEXT_DISABLED_COLOR

	self._name_label:set_color(color)
	self._value_label:set_color(color)
end

function MenuListItemStepper:activate()
	return false
end

function MenuListItemStepper:on_left_arrow_clicked()
	if not self._enabled then
		return
	end

	if not self._stepper_data or not self._value_index then
		return
	end

	if self._value_index <= 1 then
		return
	end

	local index = self._value_index - 1

	self:_select_item(index)
	managers.menu_component:post_event("highlight")

	if self._on_value_changed_callback then
		self._on_value_changed_callback(self._data)
	end
end

function MenuListItemStepper:on_right_arrow_clicked()
	if not self._enabled then
		return
	end

	if not self._stepper_data or not self._value_index then
		return
	end

	if self._value_index >= #self._stepper_data then
		return
	end

	local index = self._value_index + 1

	self:_select_item(index)
	managers.menu_component:post_event("highlight")

	if self._on_value_changed_callback then
		self._on_value_changed_callback(self._data)
	end
end

function MenuListItemStepper:move_left()
	if self:is_selected() then
		self:on_left_arrow_clicked()

		return true
	end
end

function MenuListItemStepper:move_right()
	if self:is_selected() then
		self:on_right_arrow_clicked()

		return true
	end
end

function MenuListItemStepper:_animate_select()
	local duration = 0.12
	local t = self._background:alpha() * duration

	self._background:show()

	local normal_color = self._enabled and self.TEXT_COLOR or self.TEXT_DISABLED_COLOR
	local highlight_color = self._enabled and (self._data.separator_highlight_color or self.TEXT_HIGHLIGHT_COLOR) or self.TEXT_DISABLED_COLOR

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local progress = Easing.quadratic_out(t, 0, 1, duration)

		self._background:set_alpha(progress)

		local current_x = self.NAME_X * (progress + 1)
		local current_color = math.lerp(normal_color, highlight_color, progress)

		self._name_panel:set_x(current_x)
		self._name_label:set_color(current_color)
		self._value_label:set_color(current_color)
	end

	self._background:set_alpha(1)
	self._name_panel:set_x(self.NAME_X * 2)
	self._name_label:set_color(highlight_color)
	self._value_label:set_color(highlight_color)
end

function MenuListItemStepper:_animate_unselect()
	local duration = 0.12
	local t = (1 - self._background:alpha()) * duration
	local normal_color = self._enabled and self.TEXT_COLOR or self.TEXT_DISABLED_COLOR
	local highlight_color = self._enabled and (self._data.separator_highlight_color or self.TEXT_HIGHLIGHT_COLOR) or self.TEXT_DISABLED_COLOR

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local progress = Easing.quadratic_out(t, 1, -1, duration)

		self._background:set_alpha(progress)

		local current_x = self.NAME_X * (progress + 1)
		local current_color = math.lerp(normal_color, highlight_color, progress)

		self._name_panel:set_x(current_x)
		self._name_label:set_color(current_color)
		self._value_label:set_color(current_color)
	end

	self._background:hide()
	self._background:set_alpha(0)
	self._name_panel:set_x(self.NAME_X)
	self._name_label:set_color(normal_color)
	self._value_label:set_color(normal_color)
end

function MenuListItemStepper:_animate_activate(object, data)
	local starting_alpha = self._value_label:alpha()
	local duration = 0.13
	local t = duration - starting_alpha * duration
	local text = data.text
	local label_color = data.disabled and self.TEXT_COLOR_DISABLED or self.TEXT_HIGHLIGHT_COLOR
	local center_x = self._stepper_panel:w() / 2
	local move_pos = self._arrow_left:w()
	local target_x = data.previous and -move_pos or move_pos

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local alpha = Easing.quartic_in(t, 1, -1, duration)

		self._value_label:set_alpha(alpha)

		local current_x = math.lerp(target_x, 0, alpha)

		self._value_label:set_center_x(center_x - current_x)
	end

	self._value_label:set_alpha(0)
	self._value_label:set_text(text)
	self._value_label:set_color(label_color)

	t = 0

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local alpha = Easing.quartic_out(t, 0, 1, duration)

		self._value_label:set_alpha(alpha)

		local current_x = math.lerp(target_x, 0, alpha)

		self._value_label:set_center_x(center_x + current_x)
	end

	self._value_label:set_alpha(1)
	self._value_label:set_center_x(center_x)
end
