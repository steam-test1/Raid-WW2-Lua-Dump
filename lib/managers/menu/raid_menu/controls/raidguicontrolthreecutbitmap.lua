RaidGUIControlThreeCutBitmap = RaidGUIControlThreeCutBitmap or class(RaidGUIControl)
RaidGUIControlThreeCutBitmap.HEIGHT = 32

function RaidGUIControlThreeCutBitmap:init(parent, params)
	RaidGUIControlThreeCutBitmap.super.init(self, parent, params)

	if not self._params.left or not self._params.center or not self._params.right then
		Application:error("[RaidGUIControlThreeCutBitmap:init] One or more textures not specified for the three cut bitmap control: ", self._params.name)

		return
	end

	self:_create_panel()
	self:_layout_parts()
end

function RaidGUIControlThreeCutBitmap:_create_panel()
	local three_cut_params = clone(self._params)

	three_cut_params.name = three_cut_params.name .. "_three_cut_bitmap"
	three_cut_params.layer = three_cut_params.layer or self._panel:layer()
	three_cut_params.h = self._params.h or self.HEIGHT
	self._object = self._panel:panel(three_cut_params)
end

function RaidGUIControlThreeCutBitmap:_layout_parts()
	local gui_left = tweak_data.gui:get_full_gui_data(self._params.left)
	local gui_center = tweak_data.gui:get_full_gui_data(self._params.center)
	local gui_right = tweak_data.gui:get_full_gui_data(self._params.right)
	local item_h = self._params.h
	local left_texture_rect = {
		gui_left.texture_rect[1],
		gui_left.texture_rect[2],
		gui_left.texture_rect[3] - 1,
		gui_left.texture_rect[4],
	}

	self._left = self._object:bitmap({
		color = self._params.color or Color.white,
		h = item_h,
		name = "left",
		texture = gui_left.texture,
		texture_rect = left_texture_rect,
		w = left_texture_rect[3],
	})

	local right_texture_rect = {
		gui_right.texture_rect[1] + 1,
		gui_right.texture_rect[2],
		gui_right.texture_rect[3] - 1,
		gui_right.texture_rect[4],
	}

	self._right = self._object:bitmap({
		color = self._params.color or Color.white,
		h = item_h,
		name = "right",
		texture = gui_right.texture,
		texture_rect = right_texture_rect,
		w = right_texture_rect[3],
	})

	self._right:set_right(self._object:w())

	local center_texture_rect = {
		gui_center.texture_rect[1] + 2,
		gui_center.texture_rect[2],
		gui_center.texture_rect[3] - 4,
		gui_center.texture_rect[4],
	}

	self._center = self._object:bitmap({
		color = self._params.color or Color.white,
		h = item_h,
		name = "center",
		texture = gui_center.texture,
		texture_rect = center_texture_rect,
		w = self._object:w() - self._left:w() - self._right:w(),
		x = self._left:w(),
	})

	if not item_h then
		local h = self:h()

		self._object:set_h(h)
	end

	self._left:set_center_y(self._object:h() / 2)
	self._center:set_center_y(self._object:h() / 2)
	self._right:set_center_y(self._object:h() / 2)
end

function RaidGUIControlThreeCutBitmap:set_color(color)
	self._left:set_color(color)
	self._center:set_color(color)
	self._right:set_color(color)
end

function RaidGUIControlThreeCutBitmap:color()
	return self._left:color()
end

function RaidGUIControlThreeCutBitmap:set_w(w)
	self._object:set_w(w)

	local center_w = math.ceil(w - self._left:w() - self._right:w())

	center_w = math.max(center_w, 0)

	self._center:set_x(self._left:right())
	self._center:set_w(center_w)
	self._right:set_right(self._object:w())
end

function RaidGUIControlThreeCutBitmap:mouse_released(o, button, x, y)
	return false
end

function RaidGUIControlThreeCutBitmap:h()
	return math.max(self._left:h(), self._center:h(), self._right:h())
end
