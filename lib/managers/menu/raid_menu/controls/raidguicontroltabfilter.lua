RaidGUIControlTabFilter = RaidGUIControlTabFilter or class(RaidGUIControl)
RaidGUIControlTabFilter.PADDING = 16
RaidGUIControlTabFilter.BOTTOM_LINE_NORMAL_HEIGHT = 2
RaidGUIControlTabFilter.BOTTOM_LINE_ACTIVE_HEIGHT = 5
RaidGUIControlTabFilter.DIVIDER_WIDTH = 2
RaidGUIControlTabFilter.DIVIDER_HEIGHT = 14

function RaidGUIControlTabFilter:init(parent, params)
	RaidGUIControlTabFilter.super.init(self, parent, params)

	self._object = parent:panel({
		h = params.h,
		layer = parent:layer() + 1,
		name = "tab_panel_" .. self._name,
		w = params.w,
		x = params.x,
		y = params.y,
	})
	self._tab_label = self._object:label({
		align = "center",
		vertical = "center",
		x = 0,
		y = 0,
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.extra_small,
		h = params.h,
		layer = self._object:layer() + 1,
		name = "tab_control_label_" .. self._name,
		text = params.text,
		w = params.w,
	})
	self._callback_param = params.callback_param
	self._tab_select_callback = params.tab_select_callback
	self._selected = false
end

function RaidGUIControlTabFilter:needs_divider()
	return true
end

function RaidGUIControlTabFilter:needs_bottom_line()
	return false
end

function RaidGUIControlTabFilter:set_divider()
	self._divider = self._object:rect({
		color = tweak_data.gui.colors.raid_grey,
		h = RaidGUIControlTabFilter.DIVIDER_HEIGHT,
		w = RaidGUIControlTabFilter.DIVIDER_WIDTH,
		x = self._tab_label:right() - RaidGUIControlTabFilter.DIVIDER_WIDTH / 2,
		y = (self._params.h - RaidGUIControlTabFilter.DIVIDER_HEIGHT) / 2,
	})
end

function RaidGUIControlTabFilter:get_callback_param()
	return self._callback_param
end

function RaidGUIControlTabFilter:highlight_on()
	return
end

function RaidGUIControlTabFilter:highlight_off()
	return
end

function RaidGUIControlTabFilter:select()
	self._tab_label:set_color(tweak_data.gui.colors.raid_white)

	self._selected = true
end

function RaidGUIControlTabFilter:unselect()
	self._tab_label:set_color(tweak_data.gui.colors.raid_grey)

	self._selected = false
end

function RaidGUIControlTabFilter:mouse_released(o, button, x, y)
	self:on_mouse_released(button, x, y)

	return true
end

function RaidGUIControlTabFilter:on_mouse_released(button, x, y)
	if self._params.tab_select_callback then
		self._params.tab_select_callback(self._params.tab_idx, self._callback_param)
	end

	return true
end
