RaidGUIControlIntelRaidPersonel = RaidGUIControlIntelRaidPersonel or class(RaidGUIControl)

function RaidGUIControlIntelRaidPersonel:init(parent, params)
	RaidGUIControlIntelRaidPersonel.super.init(self, parent, params)

	self._object = self._panel:panel(self._params)
	self._category_name = "raid_personnel"

	self:_layout()
end

function RaidGUIControlIntelRaidPersonel:_layout()
	self._bg_image = self._object:bitmap({
		x = 0,
		y = 0,
		h = tweak_data.gui.icons.intel_table_personnel_folder.texture_rect[4],
		layer = self._object:layer() + 1,
		texture = tweak_data.gui.icons.intel_table_personnel_folder.texture,
		texture_rect = tweak_data.gui.icons.intel_table_personnel_folder.texture_rect,
		w = tweak_data.gui.icons.intel_table_personnel_folder.texture_rect[3],
	})
	self._title_name = self._object:text({
		align = "left",
		h = 32,
		text = "",
		vertical = "center",
		w = 384,
		x = 608,
		y = 128,
		color = tweak_data.gui.colors.chat_border,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_32,
		layer = self._object:layer() + 2,
	})
	self._real_name = self._object:text({
		align = "left",
		h = 32,
		text = "",
		vertical = "center",
		w = 384,
		x = 608,
		y = 160,
		color = tweak_data.gui.colors.chat_border,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_18,
		layer = self._object:layer() + 2,
	})
	self._former_rank = self._object:text({
		align = "left",
		h = 32,
		text = "",
		vertical = "center",
		w = 384,
		x = 608,
		y = 192,
		color = tweak_data.gui.colors.chat_border,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_18,
		layer = self._object:layer() + 2,
	})
	self._notes_title = self._object:text({
		align = "left",
		text = "",
		vertical = "top",
		w = 384,
		wrap = true,
		x = 608,
		y = 256,
		color = tweak_data.gui.colors.chat_border,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_20,
		layer = self._object:layer() + 2,
	})

	local scrollable_area_notes_params = {
		h = 384,
		name = "scrollable_area_notes",
		scroll_step = 19,
		scrollbar_width = 3,
		w = 384,
		x = 608,
		y = 288,
		layer = self._object:layer() + 2,
	}

	self._scrollable_area_notes = self._object:scrollable_area(scrollable_area_notes_params)

	local content_panel_params = {
		w = 380,
		x = 0,
		y = 0,
		layer = self._object:layer() + 2,
	}

	self._content_panel = self._scrollable_area_notes:get_panel():panel(content_panel_params)

	self._scrollable_area_notes:setup_scroll_area()

	self._notes = self._content_panel:text({
		align = "left",
		text = "",
		vertical = "top",
		w = 380,
		wrap = true,
		x = 0,
		y = 0,
		color = tweak_data.gui.colors.chat_border,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_20,
		layer = self._object:layer() + 2,
	})
	self._profile_photo = self._object:bitmap({
		h = 448,
		w = 320,
		x = 96,
		y = 160,
		layer = self._object:layer() + 2,
		texture = tweak_data.gui.icons.intel_table_personnel_img_rivet.texture,
		texture_rect = tweak_data.gui.icons.intel_table_personnel_img_rivet.texture_rect,
	})
end

function RaidGUIControlIntelRaidPersonel:set_data(item_value)
	self._data = tweak_data.intel:get_item_data(self._category_name, item_value)

	self._title_name:set_text(self:translate(self._data.header_name_id, true))
	self._real_name:set_text(self:translate("personnel_heading_real_name", true) .. self:translate(self._data.real_name_id, true))
	self._former_rank:set_text(self:translate("personnel_heading_rank", true) .. self:translate(self._data.rank_id, true))
	self._notes_title:set_text(self:translate("personnel_heading_mrs_whites_notes", true))
	self._notes:set_text(self:translate(self._data.notes_id, false))

	local x1, y1, w1, h1 = self._notes:text_rect()

	self._notes:set_h(h1)
	self._content_panel:set_h(h1)
	self._scrollable_area_notes:setup_scroll_area()
	self._profile_photo:set_image(self._data.texture)
	self._profile_photo:set_texture_rect(unpack(self._data.texture_rect))
end

function RaidGUIControlIntelRaidPersonel:get_data()
	return self._data
end
