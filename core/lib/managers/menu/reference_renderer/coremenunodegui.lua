core:module("CoreMenuNodeGui")
core:import("CoreUnit")

NodeGui = NodeGui or class()

function NodeGui:init(node, layer, parameters)
	self.node = node
	self.name = node:parameters().name
	self.font = "core/fonts/diesel"
	self.font_size = 28
	self.topic_font_size = 48
	self.spacing = 2
	self.height_padding = 0

	local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()

	self.ws = managers.gui_data:create_saferect_workspace()
	self._item_panel_parent = self.ws:panel():panel({
		name = "item_panel_parent",
	})
	self.item_panel = self._item_panel_parent:panel({
		name = "item_panel",
	})
	self.safe_rect_panel = self.ws:panel():panel({
		name = "safe_rect_panel",
	})

	self.ws:show()

	self.layers = {}
	self.layers.first = layer
	self.layers.background = layer
	self.layers.marker = layer + 1
	self.layers.items = layer + 2
	self.layers.last = self.layers.items
	self.localize_strings = true
	self.row_item_color = self.row_item_color or Color(1, 0.5529411764705883, 0.6901960784313725, 0.8274509803921568)
	self.row_item_hightlight_color = self.row_item_hightlight_color or Color(1, 0.5529411764705883, 0.6901960784313725, 0.8274509803921568)
	self.row_item_disabled_text_color = self.row_item_disabled_text_color or Color(1, 0.5, 0.5, 0.5)

	if parameters then
		for param_name, param_value in pairs(parameters) do
			self[param_name] = param_value
		end
	end

	if self.texture then
		self.texture.layer = self.layers.background
		self.texture = self.ws:panel():bitmap(self.texture)

		self.texture:set_visible(true)
	end

	self:_setup_panels(node)

	self.row_items = {}

	self:_setup_item_rows(node)
end

function NodeGui:item_panel_parent()
	return self._item_panel_parent
end

function NodeGui:_setup_panels(node)
	return
end

function NodeGui:_setup_item_rows(node)
	local items = node:items()
	local items_count = #items
	local i = 0

	for _, item in pairs(items) do
		if item:visible() then
			item:parameters().gui_node = self

			local item_name = item:parameters().name
			local item_text = "menu item missing 'text_id'"

			if item:parameters().no_text then
				item_text = nil
			end

			local help_text
			local params = item:parameters()

			if params.text_id then
				if self.localize_strings and params.localize ~= false and params.localize ~= "false" then
					item_text = managers.localization:text(params.text_id)
				else
					item_text = params.text_id
				end
			end

			if params.help_id then
				if self.localize_strings and params.localize_help ~= false and params.localize_help ~= "false" then
					help_text = managers.localization:text(params.help_id)
				else
					help_text = params.help_id
				end
			end

			local row_item = {}

			table.insert(self.row_items, row_item)

			row_item.item = item
			row_item.node = node
			row_item.node_gui = self
			row_item.type = item._type
			row_item.name = item_name
			row_item.position = {
				x = 0,
				y = self.safe_rect_panel:h() - (self.font_size * (i + 1) + self.spacing * (i + 1)),
			}
			row_item.color = params.color or self.row_item_color
			row_item.row_item_color = params.row_item_color
			row_item.hightlight_color = params.hightlight_color
			row_item.disabled_color = params.disabled_color or self.row_item_disabled_text_color
			row_item.marker_color = params.marker_color or self.marker_color
			row_item.marker_disabled_color = params.marker_disabled_color or self.marker_disabled_color
			row_item.font = params.font or self.font
			row_item.font_size = params.font_size or self.font_size
			row_item.text = item_text
			row_item.help_text = help_text
			row_item.align = params.align or self.align or "left"
			row_item.halign = params.halign or self.halign or "left"
			row_item.vertical = params.vertical or self.vertical or "center"
			row_item.to_upper = params.to_upper == nil and self.to_upper or params.to_upper or false
			row_item.color_ranges = params.color_ranges or self.color_ranges or nil

			self:_create_menu_item(row_item)
			self:reload_item(item)

			i = i + 1
		end
	end

	self:_setup_size()
	self:scroll_setup()
	self:_set_item_positions()

	self._highlighted_item = nil
end

function NodeGui:_insert_row_item(item, node, i)
	if item:visible() then
		item:parameters().gui_node = self

		local item_name = item:parameters().name
		local item_text = "menu item missing 'text_id'"
		local help_text
		local params = item:parameters()

		if params.text_id then
			if self.localize_strings and params.localize ~= false and params.localize ~= "false" then
				item_text = managers.localization:text(params.text_id)
			else
				item_text = params.text_id
			end
		end

		if params.help_id then
			if self.localize_strings and params.localize_help ~= false and params.localize_help ~= "false" then
				help_text = managers.localization:text(params.help_id)
			else
				help_text = params.help_id
			end
		end

		local row_item = {}

		table.insert(self.row_items, i, row_item)

		row_item.item = item
		row_item.node = node
		row_item.type = item._type
		row_item.name = item_name
		row_item.position = {
			x = 0,
			y = self.font_size * i + self.spacing * (i - 1),
		}
		row_item.color = params.color or self.row_item_color
		row_item.row_item_color = params.row_item_color
		row_item.hightlight_color = params.hightlight_color
		row_item.disabled_color = params.disabled_color or self.row_item_disabled_text_color
		row_item.font = self.font
		row_item.text = item_text
		row_item.help_text = help_text
		row_item.align = params.align or self.align or "left"
		row_item.halign = params.halign or self.halign or "left"
		row_item.vertical = params.vertical or self.vertical or "center"
		row_item.to_upper = params.to_upper or false
		row_item.color_ranges = params.color_ranges or self.color_ranges or nil

		self:_create_menu_item(row_item)
		self:reload_item(item)
	end
end

function NodeGui:_delete_row_item(item)
	for i, row_item in ipairs(self.row_items) do
		if row_item.item == item then
			local delete_row_item = table.remove(self.row_items, i)

			if alive(row_item.gui_panel) then
				item:on_delete_row_item(row_item)
				self.item_panel:remove(row_item.gui_panel)
			end

			return
		end
	end
end

function NodeGui:refresh_gui(node)
	self:_clear_gui()
	self:_setup_item_rows(node)
end

function NodeGui:_clear_gui()
	local to = #self.row_items

	for i = 1, to do
		local row_item = self.row_items[i]

		if alive(row_item.gui_panel) then
			row_item.gui_panel:parent():remove(row_item.gui_panel)

			row_item.gui_panel = nil
		end

		if alive(row_item.gui_info_panel) then
			self.safe_rect_panel:remove(row_item.gui_info_panel)
		end

		if alive(row_item.icon) then
			row_item.icon:parent():remove(row_item.icon)
		end

		self.row_items[i] = nil
	end

	self.row_items = {}
end

function NodeGui:close()
	Overlay:gui():destroy_workspace(self.ws)

	self.ws = nil
end

function NodeGui:layer()
	return self.layers.last
end

function NodeGui:set_visible(visible)
	if visible then
		self.ws:show()
	else
		self.ws:hide()
	end
end

function NodeGui:reload_item(item)
	local type = item:type()

	if type == "" then
		self:_reload_item(item)
	end

	if type == "toggle" then
		-- block empty
	end

	if type == "slider" then
		-- block empty
	end
end

function NodeGui:_reload_item(item)
	local row_item = self:row_item(item)
	local params = item:parameters()

	if params.text_id then
		if self.localize_strings and params.localize ~= false and params.localize ~= "false" then
			item_text = managers.localization:text(params.text_id)
		else
			item_text = params.text_id
		end
	end

	if row_item then
		row_item.text = item_text

		if row_item.gui_panel.set_text then
			row_item.gui_panel:set_text(row_item.to_upper and utf8.to_upper(row_item.text) or row_item.text)
			row_item.gui_panel:set_color(row_item.color)
		end
	end
end

function NodeGui:_create_menu_item(row_item)
	return
end

function NodeGui:_reposition_items(highlighted_row_item)
	local safe_rect = managers.viewport:get_safe_rect_pixels()
	local dy = 0

	if highlighted_row_item then
		if highlighted_row_item.item:parameters().back or highlighted_row_item.item:parameters().pd2_corner then
			return
		end

		local prev_item, first_item
		local num_dividers_top = 0

		for i = 1, #self.row_items do
			first_item = self.row_items[i]

			if first_item.type ~= "divider" and not first_item.item:parameters().back and not first_item.item:parameters().pd2_corner then
				break
			elseif first_item.type == "divider" then
				num_dividers_top = num_dividers_top + 1
			end
		end

		local first = first_item.gui_panel == highlighted_row_item.gui_panel
		local last_item
		local num_dividers_bottom = 0

		for i = #self.row_items, 1, -1 do
			last_item = self.row_items[i]

			if last_item.type ~= "divider" and not last_item.item:parameters().back and not last_item.item:parameters().pd2_corner then
				break
			elseif last_item.type == "divider" then
				num_dividers_bottom = num_dividers_bottom + 1
			end
		end

		local last = last_item.gui_panel == highlighted_row_item.gui_panel
		local prev_item, next_item

		for i, row_item in ipairs(self.row_items) do
			if row_item.gui_panel == highlighted_row_item.gui_panel then
				if not first then
					for index = i - 1, 1, -1 do
						row_item = self.row_items[index]

						if row_item.type ~= "divider" and not row_item.item:parameters().back and not row_item.item:parameters().pd2_corner then
							prev_item = row_item

							break
						end
					end
				end

				if not last then
					for index = i + 1, #self.row_items do
						row_item = self.row_items[index]

						if row_item.type ~= "divider" and not row_item.item:parameters().back and not row_item.item:parameters().pd2_corner then
							next_item = row_item

							break
						end
					end
				end

				break
			end
		end

		local h = highlighted_row_item.item:get_h(highlighted_row_item, self) or highlighted_row_item.gui_panel:h()
		local offset = first and h * num_dividers_top or last and h * num_dividers_bottom or h

		offset = offset + self.height_padding

		if self._item_panel_parent:world_y() > highlighted_row_item.gui_panel:world_y() - (offset + (prev_item and math.abs(prev_item.gui_panel:y() - highlighted_row_item.gui_panel:y()) - h or 0)) then
			if prev_item then
				offset = offset + math.abs(prev_item.gui_panel:y() - highlighted_row_item.gui_panel:y()) - h
			end

			dy = -(highlighted_row_item.gui_panel:world_y() - self._item_panel_parent:world_y() - offset)
		elseif self._item_panel_parent:world_y() + self._item_panel_parent:h() < highlighted_row_item.gui_panel:world_y() + highlighted_row_item.gui_panel:h() + (offset + (next_item and math.abs(next_item.gui_panel:y() - highlighted_row_item.gui_panel:y()) - h or 0)) then
			if next_item then
				offset = offset + math.abs(next_item.gui_panel:y() - highlighted_row_item.gui_panel:y()) - h
			end

			dy = -(highlighted_row_item.gui_panel:world_y() + highlighted_row_item.gui_panel:h() - (self._item_panel_parent:world_y() + self._item_panel_parent:h()) + offset)
		end

		local old_dy = self._scroll_data.dy_left
		local is_same_dir = math.abs(old_dy) > 0 and (math.sign(dy) == math.sign(old_dy) or dy == 0)

		if is_same_dir then
			local within_view = math.within(highlighted_row_item.gui_panel:world_y(), self._item_panel_parent:world_y(), self._item_panel_parent:world_y() + self._item_panel_parent:h())

			if within_view then
				dy = math.max(math.abs(old_dy), math.abs(dy)) * math.sign(old_dy)
			end
		end
	end

	self:scroll_start(dy)
end

function NodeGui:scroll_setup()
	self._scroll_data = {}
	self._scroll_data.max_scroll_duration = 0.5
	self._scroll_data.scroll_speed = (self.font_size + self.spacing * 2) / 0.1
	self._scroll_data.dy_total = 0
	self._scroll_data.dy_left = 0
end

function NodeGui:scroll_start(dy)
	local speed = self._scroll_data.scroll_speed

	if speed > 0 and math.abs(dy / speed) > self._scroll_data.max_scroll_duration then
		speed = math.abs(dy) / self._scroll_data.max_scroll_duration
	end

	self._scroll_data.speed = speed
	self._scroll_data.dy_total = dy
	self._scroll_data.dy_left = dy

	self:scroll_update(TimerManager:main():delta_time())
end

function NodeGui:scroll_update(dt)
	local dy_left = self._scroll_data.dy_left

	if dy_left ~= 0 then
		local speed = self._scroll_data.speed
		local dy

		if speed <= 0 then
			dy = dy_left
		else
			dy = math.lerp(0, dy_left, math.clamp(math.sign(dy_left) * speed * dt / dy_left, 0, 1))
		end

		self._scroll_data.dy_left = self._scroll_data.dy_left - dy

		if self._item_panel_y and self._item_panel_y.target then
			self._item_panel_y.target = self._item_panel_y.target + dy

			self.item_panel:move(0, dy)
		else
			self.item_panel:move(0, dy)
		end

		return true
	end
end

function NodeGui:wheel_scroll_start(dy)
	local speed = 30

	if dy > 0 then
		local dist = self.item_panel:world_y() - self._item_panel_parent:world_y()

		if not (math.round(self.item_panel:world_y()) - self._item_panel_parent:world_y() < 0) then
			return self.item_panel:h() > self._item_panel_parent:h()
		end

		speed = math.min(speed, math.abs(dist))
	else
		local dist = self.item_panel:world_bottom() - self._item_panel_parent:world_bottom()

		if math.round(self.item_panel:world_bottom()) - self._item_panel_parent:world_bottom() < 4 then
			return self.item_panel:h() > self._item_panel_parent:h()
		end

		speed = math.min(speed, math.abs(dist))
	end

	self:scroll_start(speed * dy)

	return true
end

function NodeGui:highlight_item(item, mouse_over)
	if not item then
		return
	end

	local item_name = item:parameters().name
	local row_item = self:row_item(item)

	self:_highlight_row_item(row_item, mouse_over)
	self:_reposition_items(row_item)

	self._highlighted_item = item
end

function NodeGui:_highlight_row_item(row_item, mouse_over)
	if row_item then
		row_item.highlighted = true
		row_item.color = row_item.item:enabled() and (row_item.hightlight_color or self.row_item_hightlight_color) or row_item.disabled_color

		row_item.gui_panel:set_color(row_item.color)
	end
end

function NodeGui:fade_item(item)
	local item_name = item:parameters().name
	local row_item = self:row_item(item)

	self:_fade_row_item(row_item)
end

function NodeGui:_fade_row_item(row_item)
	if row_item then
		row_item.highlighted = false
		row_item.color = row_item.item:enabled() and (row_item.row_item_color or self.row_item_color) or row_item.disabled_color

		row_item.gui_panel:set_color(row_item.color)
	end
end

function NodeGui:row_item(item)
	local item_name = item:parameters().name

	for _, row_item in ipairs(self.row_items) do
		if row_item.name == item_name then
			return row_item
		end
	end

	return nil
end

function NodeGui:row_item_by_name(item_name)
	for _, row_item in ipairs(self.row_items) do
		if row_item.name == item_name then
			return row_item
		end
	end

	return nil
end

function NodeGui:update(t, dt)
	local scrolled = self:scroll_update(dt)

	if self._item_panel_y and not scrolled then
		if self._item_panel_y.target and self.item_panel:center_y() ~= self._item_panel_y.target then
			self._item_panel_y.current = math.lerp(self.item_panel:center_y(), self._item_panel_y.target, dt * 10)

			self.item_panel:set_center_y(self._item_panel_y.current)
		end
	elseif scrolled and self._item_panel_y and self._item_panel_y.target and self.item_panel:center_y() ~= self._item_panel_y.target then
		self._item_panel_y.current = math.lerp(self.item_panel:center_y(), self._item_panel_y.target, dt * 10)
	end
end

function NodeGui:_get_node_padding()
	local menu_node_padding = 0

	menu_node_padding = 30

	return menu_node_padding
end

function NodeGui:_get_node_background_width()
	local bg_width = self.item_panel:w()

	bg_width = bg_width * 0.4

	return bg_width
end

function NodeGui:_set_icon_position(row_item)
	if alive(row_item.icon) and row_item.icon then
		row_item.icon:set_left(self:_get_node_background_width() - row_item.icon:w() * 1.5)
		row_item.icon:set_center_y(row_item.gui_panel:center_y())
		row_item.icon:set_color(row_item.gui_panel:color())
	end
end

function NodeGui:_item_panel_height()
	local height = self.height_padding * 2

	for _, row_item in pairs(self.row_items) do
		if not row_item.item:parameters().back and not row_item.item:parameters().pd2_corner then
			local x, y, w, h = row_item.gui_panel:shape()

			height = height + h + self.spacing
		end
	end

	local node_padding = self:_get_node_padding()

	height = height + 2 * node_padding

	return height
end

function NodeGui:_set_item_positions()
	local total_height = self:_item_panel_height()
	local current_y = self.height_padding
	local current_item_height = 0
	local scaled_size = managers.gui_data:scaled_size()
	local node_padding = self:_get_node_padding()

	for _, row_item in pairs(self.row_items) do
		if not row_item.item:parameters().back then
			local shift_right = 650

			row_item.position.x = shift_right + 20

			row_item.gui_panel:set_x(row_item.position.x)

			row_item.position.y = current_y

			row_item.gui_panel:set_y(row_item.position.y + node_padding)

			if row_item.background_image then
				row_item.background_image:set_x(shift_right)
				row_item.background_image:set_y(row_item.position.y + node_padding)
			end

			if row_item.current_of_total then
				row_item.current_of_total:set_w(200)
				row_item.current_of_total:set_center_y(row_item.gui_panel:center_y())
				row_item.current_of_total:set_right(row_item.gui_panel:right() - self._align_line_padding)
			end

			row_item.item:on_item_position(row_item, self)
			self:_set_icon_position(row_item)

			local x, y, w, h = row_item.gui_panel:shape()

			current_item_height = h + self.spacing
			current_y = current_y + current_item_height

			if row_item.item:parameters() and row_item.item:parameters().force_x then
				row_item.gui_panel:set_x(tonumber(row_item.item:parameters().force_x))
			end

			if row_item.item:parameters() and row_item.item:parameters().force_y then
				row_item.gui_panel:set_y(tonumber(row_item.item:parameters().force_y))
			end
		end
	end

	for _, row_item in pairs(self.row_items) do
		if not row_item.item:parameters().back and not row_item.item:parameters().pd2_corner then
			row_item.item:on_item_positions_done(row_item, self)
		end
	end
end

function NodeGui:resolution_changed()
	self:_setup_size()
	self:_set_item_positions()
	self:highlight_item(self._highlighted_item)
end

function NodeGui:_setup_item_panel_parent(safe_rect)
	self._item_panel_parent:set_shape(safe_rect.x, safe_rect.y, safe_rect.width, safe_rect.height)
end

function NodeGui:_set_width_and_height(safe_rect)
	self.width = safe_rect.width
	self.height = safe_rect.height
end

function NodeGui:_setup_item_panel(safe_rect, res)
	local item_panel_offset = safe_rect.height * 0.5 - #self.row_items * 0.5 * (self.font_size + self.spacing)

	if item_panel_offset < 0 then
		item_panel_offset = 0
	end

	self.item_panel:set_w(safe_rect.width)
end

function NodeGui:_scaled_size()
	return managers.gui_data:scaled_size()
end

function NodeGui:_setup_size()
	local safe_rect = managers.viewport:get_safe_rect_pixels()
	local scaled_size = managers.gui_data:scaled_size()
	local res = RenderSettings.resolution

	managers.gui_data:layout_workspace(self.ws)
	self:_setup_item_panel_parent(scaled_size)
	self:_set_width_and_height(scaled_size)
	self:_setup_item_panel(scaled_size, res)

	if self.texture then
		self.texture:set_width(res.x)
		self.texture:set_height(res.x / 2)
		self.texture:set_center_x(safe_rect.x + safe_rect.width / 2)
		self.texture:set_center_y(safe_rect.y + safe_rect.height / 2)
	end

	self.safe_rect_panel:set_shape(scaled_size.x, scaled_size.y, scaled_size.width, scaled_size.height)

	for _, row_item in pairs(self.row_items) do
		if row_item.item:parameters().back then
			row_item.gui_panel:set_w(24)
			row_item.gui_panel:set_h(24)
			row_item.gui_panel:set_right(self:_mid_align())
			row_item.unselected:set_h(64 * row_item.gui_panel:h() / 32)
			row_item.unselected:set_center_y(row_item.gui_panel:h() / 2)
			row_item.selected:set_shape(row_item.unselected:shape())
			row_item.arrow_selected:set_size(row_item.gui_panel:w(), row_item.gui_panel:h())
			row_item.arrow_unselected:set_size(row_item.gui_panel:w(), row_item.gui_panel:h())

			break
		end
	end
end

function NodeGui:mouse_pressed(button, x, y)
	if self.item_panel:inside(x, y) and self._item_panel_parent:inside(x, y) and x > self:_mid_align() then
		if button == Idstring("mouse wheel down") then
			return self:wheel_scroll_start(-1)
		elseif button == Idstring("mouse wheel up") then
			return self:wheel_scroll_start(1)
		end
	end
end
