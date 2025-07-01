RaidGUIControlNineCutBitmap = RaidGUIControlNineCutBitmap or class(RaidGUIControl)
RaidGUIControlNineCutBitmap.CORNER_SIZE = 32

function RaidGUIControlNineCutBitmap:init(parent, params)
	RaidGUIControlNineCutBitmap.super.init(self, parent, params)

	self._params.corner_size = self._params.corner_size or RaidGUIControlNineCutBitmap.CORNER_SIZE

	if not self._params.icon then
		Application:error("[RaidGUIControlNineCutBitmap:init] Icon not specified for the nine cut bitmap control: ", self._params.name)

		return
	end

	self:_create_panel()
	self:_layout_parts()
end

function RaidGUIControlNineCutBitmap:_create_panel()
	local panel_params = clone(self._params)

	panel_params.name = panel_params.name .. "_nine_cut_bitmap"
	panel_params.layer = self._panel:layer()
	panel_params.w = self._params.w or self._params.corner_size * 3
	panel_params.h = self._params.h or self._params.corner_size * 3
	self._slider_panel = self._panel:panel(panel_params)
	self._object = self._slider_panel
end

function RaidGUIControlNineCutBitmap:_layout_parts()
	local corner_size = self._params.corner_size
	local top_left_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_top_left")

	self._top_left = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = corner_size,
		name = self._name .. "_top_left",
		render_template = self._params.render_template,
		texture = top_left_icon.texture,
		texture_rect = top_left_icon.texture_rect,
		w = corner_size,
	})

	local top_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_top")

	self._top = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = corner_size,
		name = self._name .. "_top",
		render_template = self._params.render_template,
		texture = top_icon.texture,
		texture_rect = top_icon.texture_rect,
		w = self._object:w() - corner_size * 2,
		x = corner_size,
	})

	local top_right_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_top_right")

	self._top_right = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = corner_size,
		name = self._name .. "_top_right",
		render_template = self._params.render_template,
		texture = top_right_icon.texture,
		texture_rect = top_right_icon.texture_rect,
		w = corner_size,
		x = self._object:w() - corner_size,
	})

	local left_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_left")

	self._left = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = self._object:h() - corner_size * 2,
		name = self._name .. "_left",
		render_template = self._params.render_template,
		texture = left_icon.texture,
		texture_rect = left_icon.texture_rect,
		w = corner_size,
		y = corner_size,
	})

	local center_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_center")

	self._center = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = self._object:h() - corner_size * 2,
		name = self._name .. "_center",
		render_template = self._params.render_template,
		texture = center_icon.texture,
		texture_rect = center_icon.texture_rect,
		w = self._object:w() - corner_size * 2,
		x = corner_size,
		y = corner_size,
	})

	local right_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_right")

	self._right = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = self._object:h() - corner_size * 2,
		name = self._name .. "_right",
		render_template = self._params.render_template,
		texture = right_icon.texture,
		texture_rect = right_icon.texture_rect,
		w = corner_size,
		x = self._object:w() - corner_size,
		y = corner_size,
	})

	local bottom_left_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_bottom_left")

	self._bottom_left = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = corner_size,
		name = self._name .. "_bottom_left",
		render_template = self._params.render_template,
		texture = bottom_left_icon.texture,
		texture_rect = bottom_left_icon.texture_rect,
		w = corner_size,
		y = self._object:h() - corner_size,
	})

	local bottom_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_bottom")

	self._bottom = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = corner_size,
		name = self._name .. "_bottom",
		render_template = self._params.render_template,
		texture = bottom_icon.texture,
		texture_rect = bottom_icon.texture_rect,
		w = self._object:w() - corner_size * 2,
		x = corner_size,
		y = self._object:h() - corner_size,
	})

	local bottom_right_icon = tweak_data.gui:get_full_gui_data(self._params.icon .. "_bottom_right")

	self._bottom_right = self._object:bitmap({
		alpha = self._params.alpha,
		color = self._params.color,
		h = corner_size,
		name = self._name .. "_bottom_right",
		render_template = self._params.render_template,
		texture = bottom_right_icon.texture,
		texture_rect = bottom_right_icon.texture_rect,
		w = corner_size,
		x = self._object:w() - corner_size,
		y = self._object:h() - corner_size,
	})
end

function RaidGUIControlNineCutBitmap:set_color(color)
	self._top_left:set_color(color)
	self._top:set_color(color)
	self._top_right:set_color(color)
	self._left:set_color(color)
	self._center:set_color(color)
	self._right:set_color(color)
	self._bottom_left:set_color(color)
	self._bottom:set_color(color)
	self._bottom_right:set_color(color)
end

function RaidGUIControlNineCutBitmap:color()
	return self._left:color()
end

function RaidGUIControlNineCutBitmap:set_size(w, h)
	self:set_w(w)
	self:set_h(h)
end

function RaidGUIControlNineCutBitmap:set_w(w)
	w = math.max(w, self._params.corner_size * 2)

	local inner_w = w - self._params.corner_size * 2

	self._object:set_w(w)
	self._top:set_w(inner_w)
	self._center:set_w(inner_w)
	self._bottom:set_w(inner_w)
	self._top_right:set_x(w - self._params.corner_size)
	self._right:set_x(w - self._params.corner_size)
	self._bottom_right:set_x(w - self._params.corner_size)
end

function RaidGUIControlNineCutBitmap:set_h(h)
	h = math.max(h, self._params.corner_size * 2)

	local inner_h = h - self._params.corner_size * 2

	self._object:set_h(h)
	self._left:set_h(inner_h)
	self._center:set_h(inner_h)
	self._right:set_h(inner_h)
	self._bottom_left:set_y(h - self._params.corner_size)
	self._bottom:set_y(h - self._params.corner_size)
	self._bottom_right:set_y(h - self._params.corner_size)
end

function RaidGUIControlNineCutBitmap:mouse_released(o, button, x, y)
	return false
end
