core:module("CoreMenuItemToggle")
core:import("CoreMenuItem")
core:import("CoreMenuItemOption")

ItemToggle = ItemToggle or class(CoreMenuItem.Item)
ItemToggle.TYPE = "toggle"

function ItemToggle:init(data_node, parameters)
	CoreMenuItem.Item.init(self, data_node, parameters)

	self._type = "toggle"

	local params = self._parameters

	self.options = {}
	self.selected = 1

	if data_node then
		for _, c in ipairs(data_node) do
			local type = c._meta

			if type == "option" then
				local option = CoreMenuItemOption.ItemOption:new(c)

				self:add_option(option)
			end
		end
	end
end

function ItemToggle:add_option(option)
	table.insert(self.options, option)
end

function ItemToggle:toggle()
	if not self._enabled then
		return
	end

	self.selected = self.selected + 1

	if self.selected > #self.options then
		self.selected = 1
	end

	self:dirty()
end

function ItemToggle:toggle_back()
	if not self._enabled then
		return
	end

	self.selected = self.selected - 1

	if self.selected <= 0 then
		self.selected = #self.options
	end

	self:dirty()
end

function ItemToggle:selected_option()
	return self.options[self.selected]
end

function ItemToggle:value()
	local value = ""
	local selected_option = self:selected_option()

	if selected_option then
		value = selected_option:parameters().value
	end

	return value
end

function ItemToggle:set_value(value)
	for i, option in ipairs(self.options) do
		if option:parameters().value == value then
			self.selected = i

			break
		end
	end

	self:dirty()
end

function ItemToggle:setup_gui(node, row_item)
	row_item.gui_panel = node.item_panel:panel({
		w = managers.menu:get_menu_item_width(),
	})
	row_item.gui_text = node._text_item_part(node, row_item, row_item.gui_panel, node._right_align(node))

	row_item.gui_text:set_text(row_item.to_upper and utf8.to_upper(row_item.text) or row_item.text)

	row_item.background_image = managers.menu:create_menu_item_background(node.item_panel, 10, 0, managers.menu:get_menu_item_width(), node.layers.items - 1)

	if self:parameter("title_id") then
		row_item.gui_title = node._text_item_part(node, row_item, row_item.gui_panel, node._right_align(node), "right")

		row_item.gui_title:set_text(managers.localization:text(self:parameter("title_id")))
	end

	if not self:enabled() then
		row_item.color = row_item.disabled_color

		row_item.gui_text:set_color(row_item.color)
		row_item.gui_text:set_alpha(0.75)
	else
		row_item.gui_text:set_alpha(1)
	end

	if self:selected_option():parameters().text_id then
		row_item.gui_option = node._text_item_part(node, row_item, row_item.gui_panel, node._left_align(node))

		row_item.gui_option:set_align(row_item.align)
	end

	if self:selected_option():parameters().icon then
		row_item.gui_icon = row_item.gui_panel:bitmap({
			blend_mode = node.row_item_blend_mode,
			layer = node.layers.items,
			texture = self:selected_option():parameters().icon,
			texture_rect = {
				0,
				0,
				24,
				24,
			},
			x = 0,
			y = 0,
		})

		row_item.gui_icon:set_color(row_item.disabled_color)
	end

	return true
end

local xl_pad = 64

function ItemToggle:reload(row_item, node)
	if not row_item then
		return
	end

	local safe_rect = managers.gui_data:scaled_size()

	row_item.gui_text:set_color(row_item.color)
	row_item.gui_text:set_font_size(node.font_size)

	local x, y, w, h = row_item.gui_text:text_rect()

	row_item.gui_text:set_height(h)
	row_item.gui_panel:set_height(managers.menu.MENU_ITEM_HEIGHT)
	row_item.gui_panel:set_width(safe_rect.width - node._mid_align(node))

	local node_padding = node._mid_align(node)

	if node:_get_node_padding() > 0 then
		node_padding = node:_get_node_padding()
	end

	if row_item.gui_option then
		row_item.gui_option:set_font_size(node.font_size)
		row_item.gui_option:set_width(node._left_align(node) - row_item.gui_panel:x())
		row_item.gui_option:set_right(node._left_align(node) - row_item.gui_panel:x())
		row_item.gui_option:set_height(h)
	end

	row_item.gui_text:set_width(safe_rect.width / 2)

	if row_item.align == "right" then
		row_item.gui_text:set_right(row_item.gui_panel:w())
	else
		row_item.gui_text:set_left(0)
	end

	if row_item.gui_icon then
		row_item.gui_icon:set_w(h)
		row_item.gui_icon:set_h(h)

		if self:parameters().icon_by_text then
			if row_item.align == "right" then
				row_item.gui_icon:set_right(row_item.gui_panel:w())
				row_item.gui_text:set_right(row_item.gui_icon:left())
			else
				row_item.gui_icon:set_left(node._right_align(node) - row_item.gui_panel:x() + (self:parameters().expand_value or 0))
				row_item.gui_text:set_left(row_item.gui_icon:right())
			end
		elseif row_item.align == "right" then
			row_item.gui_icon:set_left(node._right_align(node) - row_item.gui_panel:x() + (self:parameters().expand_value or 0))
		else
			row_item.gui_icon:set_right(row_item.gui_panel:w())
		end
	end

	if row_item.gui_title then
		row_item.gui_title:set_font_size(node.font_size)
		row_item.gui_title:set_height(h)

		if row_item.gui_icon then
			row_item.gui_title:set_right(row_item.gui_icon:left() - node._align_line_padding * 2)
		else
			row_item.gui_title:set_right(node._left_align(node))
		end
	end

	if row_item.gui_info_panel then
		node._align_info_panel(node, row_item)
	end

	if row_item.gui_option then
		if node.localize_strings and self:selected_option():parameters().localize ~= false then
			row_item.option_text = managers.localization:text(self:selected_option():parameters().text_id)
		else
			row_item.option_text = self:selected_option():parameters().text_id
		end

		row_item.gui_option:set_text(row_item.option_text)
	end

	self:_set_toggle_item_image(row_item)

	return true
end

function ItemToggle:_set_toggle_item_image(row_item)
	if self:selected_option():parameters().icon then
		if row_item.highlighted and self:selected_option():parameters().s_icon then
			local x = self:selected_option():parameters().s_x
			local y = self:selected_option():parameters().s_y
			local w = self:selected_option():parameters().s_w
			local h = self:selected_option():parameters().s_h

			row_item.gui_icon:set_image(self:selected_option():parameters().s_icon, x, y, w, h)
		else
			local x = self:selected_option():parameters().x
			local y = self:selected_option():parameters().y
			local w = self:selected_option():parameters().w
			local h = self:selected_option():parameters().h

			row_item.gui_icon:set_image(self:selected_option():parameters().icon, x, y, w, h)
		end

		if self:enabled() then
			row_item.gui_icon:set_color(row_item.color or Color.white)
			row_item.gui_icon:set_alpha(1)
		else
			row_item.gui_icon:set_color(row_item.disabled_color)
			row_item.gui_icon:set_alpha(0.75)
		end
	end
end

function ItemToggle:highlight_row_item(node, row_item, mouse_over)
	row_item.gui_text:set_color(row_item.color)
	row_item.gui_text:set_font(Idstring("ui/fonts/pf_din_text_comp_pro_medium_20"))

	row_item.highlighted = true

	self:_set_toggle_item_image(row_item)

	if row_item.gui_option then
		row_item.gui_option:set_color(row_item.color)
	end

	if row_item.gui_info_panel then
		row_item.gui_info_panel:set_visible(true)
	end

	return true
end

function ItemToggle:fade_row_item(node, row_item)
	row_item.gui_text:set_color(row_item.color)
	row_item.gui_text:set_font(Idstring("ui/fonts/pf_din_text_comp_pro_medium_20"))

	row_item.highlighted = nil

	self:_set_toggle_item_image(row_item)

	if row_item.gui_option then
		row_item.gui_option:set_color(row_item.color)
	end

	if row_item.gui_info_panel then
		row_item.gui_info_panel:set_visible(false)
	end

	if self:info_panel() == "lobby_campaign" then
		node._fade_lobby_campaign(node, row_item)
	end

	return true
end
