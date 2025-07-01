RaidGUIControlDialogTest = RaidGUIControlDialogTest or class(RaidGUIControl)

function RaidGUIControlDialogTest:init(parent, params)
	RaidGUIControlDialogTest.super.init(self, parent, params)

	self._yes_callback = self._params.yes_callback
	self._no_callback = self._params.no_callback
	self._object = self._panel:panel({
		name = "dialog_panel",
		x = 0,
		y = 0,
		h = self._panel:h(),
		layer = self._panel:layer() + 100,
		w = self._panel:w(),
	})
	self._background = self._object:rect({
		name = "background",
		x = 0,
		y = 0,
		color = tweak_data.gui.colors.raid_black:with_alpha(0.9),
		h = self._object:h(),
		w = self._object:w(),
	})

	local center_x, center_y = self._object:center()

	self._title_label = self._object:label({
		align = "center",
		h = 32,
		name = "dialog_title",
		vertical = "center",
		visible = false,
		w = 576,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.dialg_title,
		text = self:translate("character_creation_create_title", true),
		x = center_x,
		y = center_y - 82,
	})

	self._title_label:set_center_x(center_x)
	self._title_label:set_visible(true)

	self._input_box = self._object:input_field({
		h = 48,
		name = "input_field",
		visible = false,
		w = 430,
		ws = self._params.ws,
		x = center_x,
		y = center_y,
	})

	self._input_box:set_center_x(center_x)
	self._input_box:set_center_y(center_y)
	self._input_box:set_visible(true)

	self._yes_button = self._object:short_primary_button({
		name = "yes_button",
		on_click_callback = self._yes_callback,
		text = self:translate("yes", true),
		x = center_x,
		y = center_y + 112,
	})

	self._yes_button:set_x(self._input_box:x())
	self._yes_button:set_visible(true)

	self._no_button = self._object:short_secondary_button({
		name = "no_button",
		on_click_callback = self._no_callback,
		text = self:translate("no", true),
		x = center_x,
		y = center_y + 112,
	})

	self._no_button:set_x(self._input_box:x() + self._input_box:w() - self._no_button:w())
	self._no_button:set_visible(true)
end

function RaidGUIControlDialogTest:get_new_profile_name()
	return self._input_box:get_text()
end

function RaidGUIControlDialogTest:confirm_pressed()
	return true
end
