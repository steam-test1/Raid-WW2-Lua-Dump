ProgressBarGuiObject = ProgressBarGuiObject or class()

function ProgressBarGuiObject:init(panel, config)
	self._panel = panel
	self._width = 288
	self._height = 8
	self._x = self._panel:w() / 2
	self._y = self._panel:h() / 2 + 191
	self._progress_bar_bg = self._panel:bitmap({
		h = self._height,
		layer = 2,
		name = "progress_bar_bg",
		texture = tweak_data.gui.icons.interaction_hold_meter_bg.texture,
		texture_rect = tweak_data.gui.icons.interaction_hold_meter_bg.texture_rect,
		visible = false,
		w = self._width,
		x = self._x - self._width / 2,
		y = self._y - self._width / 2,
	})
	self._progress_bar = self._panel:rect({
		color = tweak_data.gui.colors.interaction_bar,
		layer = 3,
		name = "progress_bar",
		x = self._x - self._width / 2,
		y = self._y - self._height / 2,
	})

	if config ~= nil and config.description then
		self:_create_description(config.description)
	end
end

function ProgressBarGuiObject:_create_description(description)
	self._description = self._panel:text({
		align = "center",
		font = tweak_data.gui.fonts.din_compressed_outlined_24,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 32,
		name = "progress_bar_description",
		text = description,
		valign = "bottom",
		w = 256,
	})

	self._description:set_center_x(self._progress_bar_bg:center_x())
	self._description:set_bottom(self._y - 10)
end

function ProgressBarGuiObject:set_progress(current, total)
	if not self._progress_bar then
		return
	end

	local progress = current / total

	self._progress_bar:set_width(progress * self._width)
end

function ProgressBarGuiObject:show(description)
	if description then
		self:_create_description(description)
	end

	self._progress_bar_bg:animate(callback(self, self, "_animate_interaction_start"), 0.25)
	self._progress_bar:animate(callback(self, self, "_animate_interaction_start"), 0.25)
end

function ProgressBarGuiObject:hide(complete)
	if complete then
		self._progress_bar_bg:animate(callback(self, self, "_animate_interaction_complete"))
		self._progress_bar:animate(callback(self, self, "_animate_interaction_complete"))
	else
		self._progress_bar_bg:animate(callback(self, self, "_animate_interaction_cancel"), 0.15)
		self._progress_bar:animate(callback(self, self, "_animate_interaction_cancel"), 0.15)
	end

	if self._description then
		self._panel:remove(self._description)

		self._description = nil
	end

	if self._progress_bar then
		self._progress_bar_bg:stop()
		self._progress_bar:stop()
		self._progress_bar_bg:set_h(0)
		self._progress_bar:set_w(0)
		self._progress_bar:set_h(0)
	end
end

function ProgressBarGuiObject:animate_progress(duration)
	self._auto_animation = self._progress_bar:animate(callback(self, self, "_animate_interaction_duration"), duration)
end

function ProgressBarGuiObject:set_position(x, y)
	if not self._progress_bar then
		return
	end

	self._progress_bar_bg:set_center(x, y)
	self._progress_bar:set_center(x, y)

	if self._description then
		self._description:set_center_x(self._progress_bar_bg:center_x())
		self._description:set_bottom(self._progress_bar_bg:y() - 10)
	end

	self._x = x
	self._y = y
end

function ProgressBarGuiObject:set_x(x)
	if not self._progress_bar then
		return
	end

	self._progress_bar_bg:set_x(x)
	self._progress_bar:set_x(x)

	if self._description then
		self._description:set_center_x(self._progress_bar_bg:center_x())
		self._description:set_bottom(self._progress_bar_bg:y() - 10)
	end

	self._x = x
end

function ProgressBarGuiObject:set_top(y)
	if not self._progress_bar then
		return
	end

	self._progress_bar_bg:set_top(y)
	self._progress_bar:set_top(y)

	if self._description then
		self._description:set_center_x(self._progress_bar_bg:center_x())
		self._description:set_bottom(self._progress_bar_bg:y() - 10)
	end

	self._y = y + self._height / 2
end

function ProgressBarGuiObject:set_bottom(y)
	if not self._progress_bar then
		return
	end

	self._progress_bar_bg:set_bottom(y)
	self._progress_bar:set_bottom(y)

	if self._description then
		self._description:set_center_x(self._progress_bar_bg:center_x())
		self._description:set_bottom(self._progress_bar_bg:y() - 10)
	end

	self._y = y - self._height / 2
end

function ProgressBarGuiObject:set_center_y(y)
	if not self._progress_bar then
		return
	end

	self._progress_bar_bg:set_center_y(y)
	self._progress_bar:set_center_y(y)

	if self._description then
		self._description:set_center_x(self._progress_bar_bg:center_x())
		self._description:set_bottom(self._progress_bar_bg:y() - 10)
	end

	self._y = y
end

function ProgressBarGuiObject:set_layer(layer)
	if not self._progress_bar then
		return
	end

	self._progress_bar_bg:set_layer(layer)
	self._progress_bar:set_layer(layer + 1)
end

function ProgressBarGuiObject:width()
	return self._width
end

function ProgressBarGuiObject:height()
	return self._height
end

function ProgressBarGuiObject:layer()
	return self._progress_bar_bg:layer()
end

function ProgressBarGuiObject:remove()
	if not self._progress_bar then
		return
	end

	self._panel:remove(self._progress_bar_bg)
	self._panel:remove(self._progress_bar)

	if self._description then
		self._panel:remove(self._description)

		self._description = nil
	end
end

function ProgressBarGuiObject:_animate_interaction_start(progress_bar, duration)
	local t = 0

	progress_bar:set_visible(true)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_height = Easing.quintic_out(t, 0, self._height, duration)

		progress_bar:set_height(current_height)
		progress_bar:set_y(self._y - current_height / 2)
	end

	progress_bar:set_height(self._height)
end

function ProgressBarGuiObject:_animate_interaction_cancel(progress_bar, duration)
	local t = 0
	local start_height = progress_bar:h()

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_height = Easing.quintic_out(t, start_height, -start_height, duration)

		progress_bar:set_height(current_height)
		progress_bar:set_y(self._y - current_height / 2)
	end

	progress_bar:set_height(0)
	progress_bar:set_visible(false)
end

function ProgressBarGuiObject:_animate_interaction_complete(progress_bar)
	local duration = 0.3
	local t = 0

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_width = Easing.quintic_out(t, self._width, -self._width, duration)

		progress_bar:set_width(current_width)
		progress_bar:set_right(self._x + self._width / 2)
	end

	progress_bar:set_width(0)
	progress_bar:set_visible(false)
end

function ProgressBarGuiObject:_animate_interaction_duration(progress_bar, duration)
	local t = 0

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local progress = t / duration

		progress_bar:set_width(progress * self._width)
		progress_bar:set_left(self._x - self._width / 2)
	end

	progress_bar:set_width(self._width)
end
