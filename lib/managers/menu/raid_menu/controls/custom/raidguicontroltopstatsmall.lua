RaidGUIControlTopStatSmall = RaidGUIControlTopStatSmall or class(RaidGUIControl)
RaidGUIControlTopStatSmall.WIDTH = 320
RaidGUIControlTopStatSmall.HEIGHT = 64
RaidGUIControlTopStatSmall.STAT_NAME_H = 32
RaidGUIControlTopStatSmall.STAT_NAME_COLOR = tweak_data.gui.colors.raid_grey
RaidGUIControlTopStatSmall.STAT_NAME_FONT_SIZE = tweak_data.gui.font_sizes.size_24
RaidGUIControlTopStatSmall.PLAYER_NAME_H = 32
RaidGUIControlTopStatSmall.PLAYER_NAME_COLOR = tweak_data.gui.colors.raid_white
RaidGUIControlTopStatSmall.PLAYER_NAME_FONT_SIZE = tweak_data.gui.font_sizes.small
RaidGUIControlTopStatSmall.FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlTopStatSmall.ICON_SIZE = 64

function RaidGUIControlTopStatSmall:init(parent, params)
	RaidGUIControlTopStatSmall.super.init(self, parent, params)

	if not params then
		Application:error("[RaidGUIControlTopStatSmall:init] Parameters not specified for RaidGUIControlTopStatSmall", params.name)

		return
	end

	self:_create_panel()
	self:_create_stat_info()
end

function RaidGUIControlTopStatSmall:close()
	return
end

function RaidGUIControlTopStatSmall:_create_panel()
	local control_params = clone(self._params)

	control_params.w = RaidGUIControlTopStatSmall.WIDTH
	control_params.h = RaidGUIControlTopStatSmall.HEIGHT
	control_params.name = control_params.name .. "_top_stat_small_panel"
	control_params.layer = self._panel:layer() + 1
	self._control_panel = self._panel:panel(control_params)
	self._object = self._control_panel
end

function RaidGUIControlTopStatSmall:_create_stat_info()
	local player_name_params = {
		align = "right",
		color = RaidGUIControlTopStatSmall.PLAYER_NAME_COLOR,
		font = RaidGUIControlTopStatSmall.FONT,
		font_size = RaidGUIControlTopStatSmall.PLAYER_NAME_FONT_SIZE,
		h = RaidGUIControlTopStatSmall.PLAYER_NAME_H,
		layer = 1,
		name = "player_name_label",
		text = "PLAYER NAME",
		vertical = "center",
		w = self._object:w() - RaidGUIControlTopStatSmall.ICON_SIZE,
		x = RaidGUIControlTopStatSmall.ICON_SIZE,
		y = -3,
	}

	self._player_name_label = self._object:label(player_name_params)

	local stat_name_params = {
		align = "right",
		color = RaidGUIControlTopStatSmall.STAT_NAME_COLOR,
		font = RaidGUIControlTopStatSmall.FONT,
		font_size = RaidGUIControlTopStatSmall.STAT_NAME_FONT_SIZE,
		h = RaidGUIControlTopStatSmall.STAT_NAME_H,
		layer = 3,
		name = "stat_name_label",
		text = "Most things done well",
		vertical = "center",
		w = self._object:w(),
		word_wrap = true,
		wrap = true,
	}

	self._stat_name_label = self._object:label(stat_name_params)

	self._stat_name_label:set_y(self._player_name_label:y() + self._player_name_label:h())
end

function RaidGUIControlTopStatSmall:set_data(data)
	local name = data.player_nickname

	if managers.user:get_setting("capitalize_names") then
		name = utf8.to_upper(name)
	end

	self._player_name_label:set_text(name)
	self._stat_name_label:set_text(self:translate(data.stat, true))

	local icon_params = {
		h = RaidGUIControlTopStatSmall.ICON_SIZE,
		name = "stat_icon",
		texture = tweak_data.gui.icons[data.icon].texture,
		texture_rect = tweak_data.gui.icons[data.icon].texture_rect,
		w = RaidGUIControlTopStatSmall.ICON_SIZE,
	}

	self._stat_icon = self._object:bitmap(icon_params)
end
