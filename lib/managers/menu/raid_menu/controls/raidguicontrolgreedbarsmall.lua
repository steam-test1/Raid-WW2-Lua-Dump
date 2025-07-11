RaidGUIControlGreedBarSmall = RaidGUIControlGreedBarSmall or class(RaidGUIControl)
RaidGUIControlGreedBarSmall.WIDTH = 192
RaidGUIControlGreedBarSmall.HEIGHT = 96
RaidGUIControlGreedBarSmall.LOOT_ICON = "rewards_extra_loot_small"
RaidGUIControlGreedBarSmall.LOOT_ICON_CENTER_X = 32
RaidGUIControlGreedBarSmall.LOOT_TITLE_STRING = "menu_save_info_loot_title"
RaidGUIControlGreedBarSmall.LOOT_TITLE_H = 64
RaidGUIControlGreedBarSmall.LOOT_TITLE_FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlGreedBarSmall.LOOT_TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_32
RaidGUIControlGreedBarSmall.LOOT_TITLE_COLOR = tweak_data.gui.colors.raid_dirty_white
RaidGUIControlGreedBarSmall.LOOT_BAR_PANEL_W = 128
RaidGUIControlGreedBarSmall.LOOT_BAR_PANEL_H = 32
RaidGUIControlGreedBarSmall.LOOT_BAR_PANEL_CENTER_Y = 64
RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_L = "loot_meter_parts_l"
RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_M = "loot_meter_parts_m"
RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_R = "loot_meter_parts_r"
RaidGUIControlGreedBarSmall.LOOT_BAR_W = 96
RaidGUIControlGreedBarSmall.LOOT_BAR_COLOR = tweak_data.gui.colors.raid_dark_grey
RaidGUIControlGreedBarSmall.LOOT_BAR_FOREGROUND_COLOR = tweak_data.gui.colors.raid_gold

function RaidGUIControlGreedBarSmall:init(parent, params)
	RaidGUIControlGreedBarSmall.super.init(self, parent, params)
	self:_create_panel()
	self:_create_loot_icon()
	self:_create_loot_title()
	self:_create_loot_bar()
	self:_fit_size()
end

function RaidGUIControlGreedBarSmall:_create_panel()
	local panel_params = {
		h = RaidGUIControlGreedBarSmall.HEIGHT,
		name = "greed_bar_small",
		w = RaidGUIControlGreedBarSmall.WIDTH,
		x = self._params.x or 0,
		y = self._params.y or 0,
	}

	self._object = self._panel:panel(panel_params)
end

function RaidGUIControlGreedBarSmall:_create_loot_icon()
	local loot_icon_params = {
		halign = "left",
		name = "loot_icon",
		texture = tweak_data.gui.icons[RaidGUIControlGreedBarSmall.LOOT_ICON].texture,
		texture_rect = tweak_data.gui.icons[RaidGUIControlGreedBarSmall.LOOT_ICON].texture_rect,
		valign = "center",
	}

	self._loot_icon = self._object:bitmap(loot_icon_params)

	self._loot_icon:set_center_x(RaidGUIControlGreedBarSmall.LOOT_ICON_CENTER_X)
	self._loot_icon:set_center_y(self._object:h() / 2)
end

function RaidGUIControlGreedBarSmall:_create_loot_title()
	local loot_title_params = {
		align = "center",
		color = RaidGUIControlGreedBarSmall.LOOT_TITLE_COLOR,
		font = RaidGUIControlGreedBarSmall.LOOT_TITLE_FONT,
		font_size = RaidGUIControlGreedBarSmall.LOOT_TITLE_FONT_SIZE,
		h = RaidGUIControlGreedBarSmall.LOOT_TITLE_H,
		halign = "left",
		name = "loot_title",
		text = self:translate(RaidGUIControlGreedBarSmall.LOOT_TITLE_STRING, true),
		valign = "center",
		vertical = "center",
	}

	self._title = self._object:text(loot_title_params)

	local _, _, w, _ = self._title:text_rect()

	self._title:set_w(w)
end

function RaidGUIControlGreedBarSmall:_create_loot_bar()
	local loot_bar_panel_params = {
		h = RaidGUIControlGreedBarSmall.LOOT_BAR_PANEL_H,
		halign = "left",
		name = "loot_bar_panel",
		valign = "center",
		w = RaidGUIControlGreedBarSmall.LOOT_BAR_PANEL_W,
	}

	self._loot_bar_panel = self._object:panel(loot_bar_panel_params)

	self._loot_bar_panel:set_center_y(RaidGUIControlGreedBarSmall.LOOT_BAR_PANEL_CENTER_Y)

	local loot_bar_background_params = {
		center = RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_M,
		color = RaidGUIControlGreedBarSmall.LOOT_BAR_COLOR,
		layer = 1,
		left = RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_L,
		name = "loot_bar_background",
		right = RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_R,
		w = RaidGUIControlGreedBarSmall.LOOT_BAR_W,
	}

	self._loot_bar_background = self._loot_bar_panel:three_cut_bitmap(loot_bar_background_params)

	self._loot_bar_background:set_center_x(self._loot_bar_panel:w() / 2)
	self._loot_bar_background:set_center_y(self._loot_bar_panel:h() / 2)

	local loot_bar_progress_panel_params = {
		h = self._loot_bar_background:h(),
		layer = self._loot_bar_background:layer() + 1,
		name = "loot_bar_progress_panel",
		w = RaidGUIControlGreedBarSmall.LOOT_BAR_W,
	}

	self._loot_bar_progress_panel = self._loot_bar_panel:panel(loot_bar_progress_panel_params)

	self._loot_bar_progress_panel:set_x(self._loot_bar_background:x())
	self._loot_bar_progress_panel:set_center_y(self._loot_bar_background:center_y())

	local loot_bar_foreground_params = {
		center = RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_M,
		color = RaidGUIControlGreedBarSmall.LOOT_BAR_FOREGROUND_COLOR,
		left = RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_L,
		name = "loot_bar_foreground",
		right = RaidGUIControlGreedBarSmall.LOOT_BAR_ICON_R,
		w = RaidGUIControlGreedBarSmall.LOOT_BAR_W,
	}
	local loot_bar_foreground = self._loot_bar_progress_panel:three_cut_bitmap(loot_bar_foreground_params)
end

function RaidGUIControlGreedBarSmall:_fit_size()
	if self._title:w() > self._loot_bar_background:w() then
		self._title:set_x(64)
		self._loot_bar_panel:set_center_x(self._title:center_x())
	else
		self._loot_bar_panel:set_x(64)
		self._title:set_center_x(self._loot_bar_panel:center_x())
	end

	local larger_width = math.max(self._title:w(), self._loot_bar_background:w())

	if larger_width + 64 > self._object:w() then
		self._object:set_w(larger_width + 64)
	end
end

function RaidGUIControlGreedBarSmall:set_data_from_manager()
	local progress = managers.greed:current_loot_counter() / managers.greed:loot_needed_for_gold_bar()

	self._loot_bar_progress_panel:set_w(self._loot_bar_background:w() * progress)
	self._loot_bar_progress_panel:set_x(self._loot_bar_background:x())
	self._loot_bar_progress_panel:set_center_y(self._loot_bar_background:center_y())
end
