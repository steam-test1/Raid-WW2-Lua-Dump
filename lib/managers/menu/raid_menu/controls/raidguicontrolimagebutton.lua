RaidGUIControlImageButton = RaidGUIControlImageButton or class(RaidGUIControlImage)

function RaidGUIControlImageButton:init(parent, params)
	RaidGUIControlImageButton.super.init(self, parent, params)

	if not params.on_click_callback then
		Application:error("[RaidGUIControlImageButton:init] On click callback not specified for image button: ", params.name)
	end

	self._data = {
		value = params.value,
	}
	self._pointer_type = "link"
	self._on_click_callback = params.on_click_callback
	self._color = params.color or Color.red
	self._highlight_color = params.highlight_color or Color.red

	self:_create_highlight_image()

	self._highlight_texture = params.highlight_texture
	self._highlight_texture_rect = params.highlight_texture_rect
	self._w = self._object:w()
	self._h = self._object:h()

	self:highlight_off()
end

function RaidGUIControlImageButton:_create_highlight_image()
	self._highlight_texture = self._params.highlight_texture
	self._highlight_texture_rect = self._params.highlight_texture_rect

	if not self._highlight_texture then
		return
	end

	self._highlight_image_params = clone(self.params)
	self._highlight_image_params.texture = self._highlight_texture
	self._highlight_image_params.texture_rect = self._highlight_texture_rect
	self._highlight_image_params.color = self._highlight_color or Color.red
	self._highlight_image = self._panel:bitmap(params)
end

function RaidGUIControlImageButton:highlight_on()
	if self._highlight_image then
		self._object:hide()
		self._highlight_image:show()
	else
		self._object:stop()

		if self._highlight_color ~= self._color then
			self._object:animate(callback(self, self, "_animate_highlight_on"))
		end
	end
end

function RaidGUIControlImageButton:highlight_off()
	if self._highlight_image then
		self._object:show()
		self._highlight_image:hide()
	else
		self._object:stop()

		if self._highlight_color ~= self._color then
			self._object:animate(callback(self, self, "_animate_highlight_off"))
		end
	end
end

function RaidGUIControlImageButton:on_mouse_pressed(button)
	if self._active_click_animation then
		self._object:stop(self._active_click_animation)
	end

	self._active_click_animation = self._object:animate(callback(self, self, "_animate_press"))
end

function RaidGUIControlImageButton:mouse_released(o, button, x, y)
	self:on_mouse_released(button)

	return true
end

function RaidGUIControlImageButton:on_mouse_released(button)
	if self._active_click_animation then
		self._object:stop(self._active_click_animation)
	end

	self._active_click_animation = self._object:animate(callback(self, self, "_animate_release"))

	self._on_click_callback(button, self, self._data)
end

function RaidGUIControlImageButton:_animate_highlight_on()
	local starting_r = self._object:color().r
	local current_state = (starting_r - self._color.r) / (self._highlight_color.r - self._color.r)
	local duration = 0.2
	local t = duration - (1 - current_state) * duration

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local border_r = Easing.quartic_out(t, self._color.r, self._highlight_color.r - self._color.r, duration)
		local border_g = Easing.quartic_out(t, self._color.g, self._highlight_color.g - self._color.g, duration)
		local border_b = Easing.quartic_out(t, self._color.b, self._highlight_color.b - self._color.b, duration)

		self._object:set_color(Color(border_r, border_g, border_b))
	end

	self._object:set_color(self._highlight_color)
end

function RaidGUIControlImageButton:_animate_highlight_off()
	local starting_r = self._object:color().r
	local current_state = (starting_r - self._color.r) / (self._highlight_color.r - self._color.r)
	local duration = 0.2
	local t = duration - current_state * duration

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local border_r = Easing.quartic_out(t, self._highlight_color.r, self._color.r - self._highlight_color.r, duration)
		local border_g = Easing.quartic_out(t, self._highlight_color.g, self._color.g - self._highlight_color.g, duration)
		local border_b = Easing.quartic_out(t, self._highlight_color.b, self._color.b - self._highlight_color.b, duration)

		self._object:set_color(Color(border_r, border_g, border_b))
	end

	self._object:set_color(self._color)
end

function RaidGUIControlImageButton:_animate_press()
	local t = 0
	local original_w = self._w
	local original_h = self._h
	local starting_scale = self._object:w() / original_w
	local duration = 0.25 * ((starting_scale - 0.9) / 0.1)
	local center_x, center_y = self._object:center()

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local scale = Easing.quartic_out(t, starting_scale, 0.9 - starting_scale, duration)

		self._object:set_w(original_w * scale)
		self._object:set_h(original_h * scale)
		self._object:set_center(center_x, center_y)
	end

	self._object:set_w(original_w * 0.9)
	self._object:set_h(original_h * 0.9)
	self._object:set_center(center_x, center_y)
end

function RaidGUIControlImageButton:_animate_release()
	local t = 0
	local duration = 0.25
	local target_w = self._w
	local target_h = self._h
	local center_x, center_y = self._object:center()

	self._object:set_w(target_w * 0.9)
	self._object:set_h(target_h * 0.9)
	self._object:set_center(center_x, center_y)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local scale = Easing.quartic_out(t, 0.9, 0.1, duration)

		self._object:set_w(target_w * scale)
		self._object:set_h(target_h * scale)
		self._object:set_center(center_x, center_y)
	end

	self._object:set_w(target_w)
	self._object:set_h(target_h)
	self._object:set_center(center_x, center_y)
end
