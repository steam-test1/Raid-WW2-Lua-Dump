RaidGUIControlIntelBulletin = RaidGUIControlIntelBulletin or class(RaidGUIControl)

function RaidGUIControlIntelBulletin:init(parent, params)
	RaidGUIControlIntelBulletin.super.init(self, parent, params)

	self._object = self._panel:panel(self._params)
	self._category_name = "bulletins"

	self:_layout()
end

function RaidGUIControlIntelBulletin:_layout()
	self._bg_image = self._object:bitmap({
		h = tweak_data.gui.icons.intel_table_newspapers.texture_rect[4],
		layer = self._object:layer() + 1,
		texture = tweak_data.gui.icons.intel_table_newspapers.texture,
		texture_rect = tweak_data.gui.icons.intel_table_newspapers.texture_rect,
		w = tweak_data.gui.icons.intel_table_newspapers.texture_rect[3],
		x = 0,
		y = 0,
	})
	self._update_date = self._object:text({
		align = "left",
		color = tweak_data.gui.colors.intel_newspapers_text,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_20,
		h = 32,
		layer = self._object:layer() + 2,
		text = "",
		vertical = "center",
		w = 192,
		x = 96,
		y = 112,
	})
	self._update_person = self._object:text({
		align = "right",
		color = tweak_data.gui.colors.intel_newspapers_text,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_20,
		h = 32,
		layer = self._object:layer() + 2,
		text = "",
		vertical = "center",
		w = 192,
		x = 96,
		y = 112,
	})

	self._update_person:set_right(self._object:w() - 128)

	local content_panel_scrollable_area_params = {
		h = 512,
		layer = self._object:layer() + 2,
		name = "content_panel_scrollable_area",
		scroll_step = 19,
		scrollbar_width = 10,
		w = 576,
		x = 256,
		y = 208,
	}

	self.content_panel_scrollable_area = self._object:scrollable_area(content_panel_scrollable_area_params)

	local content_panel_params = {
		h = 512,
		layer = self._object:layer() + 2,
		w = 572,
		x = 0,
		y = 0,
	}

	self._content_panel = self.content_panel_scrollable_area:get_panel():panel(content_panel_params)
	self._title = self._content_panel:text({
		align = "center",
		color = tweak_data.gui.colors.chat_border,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_56,
		layer = self._object:layer() + 2,
		text = "",
		vertical = "center",
		w = self._content_panel:w(),
		wrap = true,
		x = 0,
		y = 0,
	})
	self._text = self._content_panel:text({
		align = "left",
		color = tweak_data.gui.colors.chat_border,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_20,
		layer = self._object:layer() + 2,
		text = "",
		vertical = "top",
		w = self._content_panel:w(),
		wrap = true,
		x = 0,
		y = 0,
	})
	self._title_image = self._content_panel:bitmap({
		h = 288,
		layer = self._object:layer() + 2,
		texture = tweak_data.gui.icons.intel_table_newspapers.texture,
		texture_rect = tweak_data.gui.icons.intel_table_newspapers.texture_rect,
		w = 512,
		x = 32,
		y = 0,
	})
end

function RaidGUIControlIntelBulletin:set_data(item_value)
	self._data = tweak_data.intel:get_item_data(self._category_name, item_value)

	local text_top_coord = 0
	local content_panel_height = 0

	self._update_date:set_text(self._data.update_date)
	self._update_person:set_text(self._data.update_person)
	self._title:set_text(self:translate(self._data.title, true))
	self._text:set_text(self:translate(self._data.text, false))

	local x1, y1, w1, h1 = self._title:text_rect()

	self._title:set_h(h1)

	text_top_coord = self._title:bottom()
	content_panel_height = content_panel_height + self._title:h()

	if self._data.texture and self._data.texture_rect then
		self._title_image:show()
		self._title_image:set_y(self._title:bottom() + 32)
		self._title_image:set_image(self._data.texture)
		self._title_image:set_texture_rect(unpack(self._data.texture_rect))

		content_panel_height = content_panel_height + self._title_image:h() + 64
		text_top_coord = self._title_image:bottom() + 32
	else
		self._title_image:hide()

		text_top_coord = self._title:bottom()
	end

	local x2, y2, w2, h2 = self._text:text_rect()

	self._text:set_h(h2)

	content_panel_height = content_panel_height + self._text:h()

	self._text:set_y(text_top_coord)
	self._content_panel:set_h(content_panel_height)
	self.content_panel_scrollable_area:setup_scroll_area()
end

function RaidGUIControlIntelBulletin:get_data()
	return self._data
end
