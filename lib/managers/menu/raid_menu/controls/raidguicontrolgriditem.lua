RaidGUIControlGridItem = RaidGUIControlGridItem or class(RaidGUIControl)
RaidGUIControlGridItem.SELECT_TRINGLE_SIZE = 30
RaidGUIControlGridItem.LAYER_OBJECT = 30
RaidGUIControlGridItem.LAYER_ICON = 10
RaidGUIControlGridItem.LAYER_SELECTOR = 20
RaidGUIControlGridItem.LAYER_TRIANGE = 15
RaidGUIControlGridItem.STATUS_OWNED_OR_PURCHASED = "grid_item_status_owned_or_purchased"
RaidGUIControlGridItem.STATUS_LOCKED = "grid_item_status_locked"
RaidGUIControlGridItem.STATUS_PURCHASABLE = "grid_item_status_purchasable"
RaidGUIControlGridItem.STATUS_NOT_ENOUGHT_RESOURCES = "grid_item_status_not_enought_resources"
RaidGUIControlGridItem.STATUS_LOCKED_DLC = "grid_item_status_locked_dlc"

function RaidGUIControlGridItem:init(parent, params, item_data, grid_params)
	RaidGUIControlGridItem.super.init(self, parent, params)

	self._item_data = item_data
	self._object = self._panel:panel({
		h = params.selected_marker_h,
		layer = 0,
		name = "panel_grid_item",
		w = params.selected_marker_w,
		x = params.x,
		y = params.y,
	}, true)
	self._selected = false
	self._locked = false

	if self._params and self._params.item_clicked_callback then
		self._on_click_callback = self._params.item_clicked_callback
	end

	if self._params and self._params.item_double_clicked_callback then
		self._on_double_click_callback = self._params.item_double_clicked_callback
	end

	if self._params and self._params.item_selected_callback then
		self._on_selected_callback = self._params.item_selected_callback
	end

	self._params.selected_marker_w = params.selected_marker_w or params.item_w or self._panel:w()
	self._params.selected_marker_h = params.selected_marker_h or params.item_h or self._panel:h()
	self._params.item_w = params.item_w or self._panel:w()
	self._params.item_h = params.item_h or self._panel:h()
	self._name = "grid_item"

	local background_panel_params = {
		h = self._params.selected_marker_h,
		layer = 1,
		visible = false,
		w = self._params.selected_marker_w,
		x = 0,
		y = 0,
	}
	local background_rect_params = {
		color = tweak_data.gui.colors.raid_grey:with_alpha(0.3),
		h = self._params.selected_marker_h,
		layer = 2,
		w = self._params.selected_marker_w,
		x = 0,
		y = 0,
	}

	self._select_background_panel = self._object:panel(background_panel_params)
	self._select_background = self._select_background_panel:rect(background_rect_params)
	self._triangle_markers_panel = self._object:panel(background_panel_params)

	self:_layout_triangles()
	self:_layout_grid_item_icon(params)
	self:_layout_locks()
	self:_toggle_visibility_status_icons()

	if self._item_data.breadcrumb then
		self:_layout_breadcrumb()
	end
end

function RaidGUIControlGridItem:_layout_grid_item_icon(params)
	local image_coord_x = (params.selected_marker_w - params.item_w) / 2
	local image_coord_y = (params.selected_marker_h - params.item_h) / 2

	self._grid_item_icon = self._object:image({
		h = params.item_h,
		layer = 100,
		name = "grid_item_icon",
		texture = self._item_data[self._params.grid_item_icon],
		w = params.item_w,
		x = image_coord_x,
		y = image_coord_y,
	})
end

function RaidGUIControlGridItem:_layout_locks()
	self._item_status_resource_icon = self._object:image({
		color = tweak_data.gui.colors.gold_orange,
		layer = 200,
		name = "grid_item_resource_icon",
		texture = tweak_data.gui.icons.gold_amount_footer.texture,
		texture_rect = tweak_data.gui.icons.gold_amount_footer.texture_rect,
	})

	self._item_status_resource_icon:set_right(self._grid_item_icon:right() - 14)
	self._item_status_resource_icon:set_bottom(self._grid_item_icon:bottom() - 14)

	self._item_status_lock_icon = self._object:image({
		layer = 200,
		name = "grid_item_lock_icon",
		texture = tweak_data.gui.icons.ico_locker.texture,
		texture_rect = tweak_data.gui.icons.ico_locker.texture_rect,
	})

	self._item_status_lock_icon:set_right(self._grid_item_icon:right() - 14)
	self._item_status_lock_icon:set_bottom(self._grid_item_icon:bottom() - 14)

	self._item_status_dlc_lock = self._object:image({
		layer = 200,
		name = "grid_item_dlc_lock_icon",
		texture = tweak_data.gui.icons.ico_dlc.texture,
		texture_rect = tweak_data.gui.icons.ico_dlc.texture_rect,
	})

	self._item_status_dlc_lock:set_right(self._grid_item_icon:right() - 14)
	self._item_status_dlc_lock:set_bottom(self._grid_item_icon:bottom() - 14)
end

function RaidGUIControlGridItem:_layout_triangles()
	self._top_marker_triangle = self._triangle_markers_panel:image({
		color = tweak_data.gui.colors.gold_orange,
		h = RaidGUIControlGridItem.SELECT_TRINGLE_SIZE,
		layer = RaidGUIControlGridItem.LAYER_TRIANGE,
		texture = tweak_data.gui.icons.ico_sel_rect_top_left_white.texture,
		texture_rect = tweak_data.gui.icons.ico_sel_rect_top_left_white.texture_rect,
		w = RaidGUIControlGridItem.SELECT_TRINGLE_SIZE,
		x = 0,
		y = 0,
	})
	self._bottom_marker_triangle = self._triangle_markers_panel:image({
		color = tweak_data.gui.colors.gold_orange,
		h = RaidGUIControlGridItem.SELECT_TRINGLE_SIZE,
		layer = 2,
		texture = tweak_data.gui.icons.ico_sel_rect_bottom_right_white.texture,
		texture_rect = tweak_data.gui.icons.ico_sel_rect_bottom_right_white.texture_rect,
		w = RaidGUIControlGridItem.SELECT_TRINGLE_SIZE,
		x = self._triangle_markers_panel:w() - RaidGUIControlGridItem.SELECT_TRINGLE_SIZE,
		y = self._triangle_markers_panel:h() - RaidGUIControlGridItem.SELECT_TRINGLE_SIZE,
	})
end

function RaidGUIControlGridItem:_layout_breadcrumb()
	local breadcrumb_params = {
		category = self._item_data.breadcrumb.category,
		identifiers = self._item_data.breadcrumb.identifiers,
		layer = self._grid_item_icon:layer() + 1,
		padding = 10,
	}

	self._breadcrumb = self._object:breadcrumb(breadcrumb_params)

	self._breadcrumb:set_right(self._object:w())
	self._breadcrumb:set_y(0)
end

function RaidGUIControlGridItem:_toggle_visibility_status_icons()
	if self._item_data.status == RaidGUIControlGridItem.STATUS_OWNED_OR_PURCHASED then
		self._grid_item_icon:set_color(Color(1, 1, 1))
	else
		local v = 0.33

		self._grid_item_icon:set_color(Color(v, v, v))
	end

	if self._item_data.status == RaidGUIControlGridItem.STATUS_OWNED_OR_PURCHASED then
		self:_toggle_visibility_status_owned_unlocked()
	elseif self._item_data.status == RaidGUIControlGridItem.STATUS_LOCKED then
		self:_toggle_visibility_status_locked()
	elseif self._item_data.status == RaidGUIControlGridItem.STATUS_PURCHASABLE then
		self:_toggle_visibility_status_purchasable()
	elseif self._item_data.status == RaidGUIControlGridItem.STATUS_NOT_ENOUGHT_RESOURCES then
		self:_toggle_visibility_status_not_enough_resources()
	elseif self._item_data.status == RaidGUIControlGridItem.STATUS_LOCKED_DLC then
		self:_toggle_visibility_status_locked_dlc()
	end
end

function RaidGUIControlGridItem:_toggle_visibility_status_owned_unlocked()
	if self._item_status_resource_icon then
		self._item_status_resource_icon:hide()
	end

	if self._item_status_lock_icon then
		self._item_status_lock_icon:hide()
	end

	if self._item_status_dlc_lock then
		self._item_status_dlc_lock:hide()
	end
end

function RaidGUIControlGridItem:_toggle_visibility_status_locked()
	if self._item_status_resource_icon then
		self._item_status_resource_icon:hide()
	end

	if self._item_status_lock_icon then
		self._item_status_lock_icon:show()
	end

	if self._item_status_dlc_lock then
		self._item_status_dlc_lock:hide()
	end
end

function RaidGUIControlGridItem:_toggle_visibility_status_purchasable()
	if self._item_status_resource_icon then
		self._item_status_resource_icon:show()
	end

	if self._item_status_lock_icon then
		self._item_status_lock_icon:hide()
	end

	if self._item_status_dlc_lock then
		self._item_status_dlc_lock:hide()
	end
end

function RaidGUIControlGridItem:_toggle_visibility_status_not_enough_resources()
	if self._item_status_resource_icon then
		self._item_status_resource_icon:show()
	end

	if self._item_status_lock_icon then
		self._item_status_lock_icon:hide()
	end

	if self._item_status_dlc_lock then
		self._item_status_dlc_lock:hide()
	end
end

function RaidGUIControlGridItem:_toggle_visibility_status_locked_dlc()
	if self._item_status_resource_icon then
		self._item_status_resource_icon:hide()
	end

	if self._item_status_lock_icon then
		self._item_status_lock_icon:hide()
	end

	if self._item_status_dlc_lock then
		self._item_status_dlc_lock:show()
	end
end

function RaidGUIControlGridItem:get_data()
	return self._item_data
end

function RaidGUIControlGridItem:mouse_released(o, button, x, y)
	self:on_mouse_released(button)

	return true
end

function RaidGUIControlGridItem:on_mouse_released(button)
	if self._on_click_callback then
		self._on_click_callback(self._item_data, self._params.key_value_field)
	end
end

function RaidGUIControlGridItem:mouse_double_click(o, button, x, y)
	self:on_mouse_double_click(button)

	return true
end

function RaidGUIControlGridItem:on_mouse_double_click(button)
	if self._on_double_click_callback then
		self._on_double_click_callback(self._item_data, self._params.key_value_field)
	end
end

function RaidGUIControlGridItem:selected()
	return self._selected
end

function RaidGUIControlGridItem:select(dont_fire_selected_callback)
	self._selected = true

	self:select_on()

	if self._item_data.breadcrumb then
		managers.breadcrumb:remove_breadcrumb(self._item_data.breadcrumb.category, self._item_data.breadcrumb.identifiers)
	end

	if self._on_selected_callback and not dont_fire_selected_callback then
		self._on_selected_callback(self._params.item_idx, self._item_data)
	end
end

function RaidGUIControlGridItem:unselect()
	self._selected = false

	self:select_off()
end

function RaidGUIControlGridItem:select_on()
	self._select_background_panel:show()
	self._triangle_markers_panel:show()
end

function RaidGUIControlGridItem:select_off()
	self._select_background_panel:hide()
	self._triangle_markers_panel:hide()
end

function RaidGUIControlGridItem:confirm_pressed()
	self:on_mouse_released(nil)
end

function RaidGUIControlGridItem:on_mouse_over(x, y)
	RaidGUIControlGridItem.super.on_mouse_over(self, x, y)

	if self._params.hover_selects and self._on_click_callback then
		self._on_click_callback(self._item_data, self._params.key_value_field)
	end
end
