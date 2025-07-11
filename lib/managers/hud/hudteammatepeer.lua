HUDTeammatePeer = HUDTeammatePeer or class(HUDTeammateBase)
HUDTeammatePeer.PADDING_DOWN = 10
HUDTeammatePeer.DEFAULT_X = 0
HUDTeammatePeer.DEFAULT_W = 384
HUDTeammatePeer.DEFAULT_H = 84
HUDTeammatePeer.LEFT_PANEL_X = 0
HUDTeammatePeer.LEFT_PANEL_Y = 0
HUDTeammatePeer.LEFT_PANEL_W = 84
HUDTeammatePeer.WARCRY_BG_ICON = "player_panel_warcry_bg"
HUDTeammatePeer.WARCRY_BAR_ICON = "warcry_bar_fill"
HUDTeammatePeer.WARCRY_BAR_COLORS = tweak_data.gui.colors.player_warcry_colors
HUDTeammatePeer.WARCRY_INACTIVE_COLOR = tweak_data.gui.colors.warcry_inactive
HUDTeammatePeer.WARCRY_ACTIVE_COLOR = tweak_data.gui.colors.warcry_active
HUDTeammatePeer.TIMER_BG_ICON = "player_panel_teammate_downed_bg"
HUDTeammatePeer.TIMER_BAR_ICON = "teammate_circle_fill_medium"
HUDTeammatePeer.TIMER_FONT = "din_compressed_outlined_42"
HUDTeammatePeer.TIMER_FONT_SIZE = 42
HUDTeammatePeer.INTERACTION_METER_BG = "player_panel_interaction_teammate_bg"
HUDTeammatePeer.INTERACTION_METER_FILL = "teammate_interact_fill_large"
HUDTeammatePeer.RIGHT_PANEL_X = 96
HUDTeammatePeer.RIGHT_PANEL_Y = 0
HUDTeammatePeer.PLAYER_NAME_H = 30
HUDTeammatePeer.PLAYER_NAME_FONT = "din_compressed_outlined_22"
HUDTeammatePeer.PLAYER_NAME_FONT_SIZE = 22
HUDTeammatePeer.PLAYER_LEVEL_Y = 4
HUDTeammatePeer.PLAYER_LEVEL_W = 24
HUDTeammatePeer.PLAYER_LEVEL_H = 16
HUDTeammatePeer.PLAYER_LEVEL_FONT = "din_compressed_outlined_22"
HUDTeammatePeer.PLAYER_LEVEL_FONT_SIZE = 20
HUDTeammatePeer.PLAYER_HEALTH_H = 10
HUDTeammatePeer.PLAYER_HEALTH_BG_ICON = "backgrounds_health_bg"
HUDTeammatePeer.PLAYER_HEALTH_COLORS = tweak_data.gui.colors.player_health_colors
HUDTeammatePeer.EQUIPMENT_H = 37
HUDTeammatePeer.EQUIPMENT_PADDING = 6
HUDTeammatePeer.MOUNTED_WEAPON_ICON = "player_panel_status_mounted_weapon"
HUDTeammatePeer.LOCKPICK_ICON = "player_panel_status_lockpick"
HUDTeammatePeer.DEAD_ICON = "player_panel_status_dead_ai"
HUDTeammatePeer.HOST_ICON = "player_panel_host_indicator"
HUDTeammatePeer.DOWN_ICON = "player_panel_lives_indicator_"
HUDTeammatePeer.STATES = {
	{
		control = "dead_icon",
		hidden = {
			"warcry_panel",
		},
		id = "dead",
	},
	{
		control = "timer_panel",
		hidden = {
			"warcry_panel",
		},
		id = "downed",
	},
	{
		control = "interaction_meter_panel",
		id = "interaction",
	},
	{
		control = "carry_icon",
		hidden = {
			"warcry_panel",
		},
		id = "carry",
	},
	{
		control = "special_interaction_icon",
		id = "special_interaction",
	},
	{
		control = "mounted_weapon_icon",
		id = "mounted_weapon",
	},
	{
		control = "warcry_icon",
		id = "warcry",
	},
	{
		control = "nationality_icon",
		id = "normal",
	},
}
HUDTeammatePeer.CHAT_ICON_SPEAKING = "voice_chat_talking_icon"
HUDTeammatePeer.CHAT_ICON_MUTED = "voice_chat_muted_icon"
HUDTeammatePeer.CHAT_PANEL_W = 30

function HUDTeammatePeer:init(i, teammates_panel)
	self._id = i
	self._equipment = {}
	self._states = HUDTeammatePeer.STATES
	self._displayed_state = self._states[#self._states]
	self._active_states = {}

	self:_add_active_state(self._displayed_state.id)
	self:_create_panel(teammates_panel)
	self:_create_left_panel()
	self:_create_status_panel()
	self:_create_nationality_icon()
	self:_create_dead_icon()
	self:_create_carry_icon()
	self:_create_special_interaction_icon()
	self:_create_mounted_weapon_icon()
	self:_create_warcry_bar()
	self:_create_timer()
	self:_create_interaction_meter()
	self:_create_host_indicator()
	self:_create_right_panel()
	self:_create_player_name()
	self:_create_player_level()
	self:_create_player_health()
	self:_create_equipment_panel()
	self:_create_voice_chat_indicator()

	self._status_icon = self._nationality_icon
end

function HUDTeammatePeer:_create_panel(teammates_panel)
	local panel_params = {
		h = HUDTeammatePeer.DEFAULT_H,
		halign = "left",
		layer = tweak_data.gui.PLAYER_PANELS_LAYER,
		valign = "top",
		w = HUDTeammatePeer.DEFAULT_W,
		x = HUDTeammatePeer.DEFAULT_X,
		y = 0,
	}

	self._object = teammates_panel:panel(panel_params)
end

function HUDTeammatePeer:_create_left_panel()
	local left_panel_params = {
		h = self._object:h(),
		name = "left_panel",
		w = HUDTeammatePeer.LEFT_PANEL_W,
		x = HUDTeammatePeer.LEFT_PANEL_X,
		y = HUDTeammatePeer.LEFT_PANEL_Y,
	}

	self._left_panel = self._object:panel(left_panel_params)
end

function HUDTeammatePeer:_create_status_panel()
	local status_panel_params = {
		h = self._left_panel:h(),
		name = "status_panel",
		w = self._left_panel:w(),
		x = 0,
		y = 0,
	}

	self._status_panel = self._left_panel:panel(status_panel_params)
end

function HUDTeammatePeer:_create_warcry_bar()
	local warcry_panel_params = {
		h = self._left_panel:h(),
		name = "warcry_panel",
		w = self._left_panel:w(),
	}
	local warcry_panel = self._left_panel:panel(warcry_panel_params)
	local warcry_background_params = {
		halign = "center",
		name = "warcry_background",
		texture = tweak_data.gui.icons[HUDTeammatePeer.WARCRY_BG_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.WARCRY_BG_ICON].texture_rect,
		valign = "center",
	}
	local warcry_background = warcry_panel:bitmap(warcry_background_params)

	warcry_background:set_center_x(warcry_panel:w() / 2)
	warcry_background:set_center_y(warcry_panel:h() / 2)

	local warcry_bar_params = {
		color = HUDTeammatePeer.WARCRY_INACTIVE_COLOR,
		h = tweak_data.gui:icon_h(HUDTeammatePeer.WARCRY_BAR_ICON),
		halign = "center",
		layer = warcry_background:layer() + 1,
		name = "warcry_bar",
		render_template = "VertexColorTexturedRadial",
		texture = tweak_data.gui.icons[HUDTeammatePeer.WARCRY_BAR_ICON].texture,
		texture_rect = {
			tweak_data.gui:icon_w(HUDTeammatePeer.WARCRY_BAR_ICON),
			0,
			-tweak_data.gui:icon_w(HUDTeammatePeer.WARCRY_BAR_ICON),
			tweak_data.gui:icon_h(HUDTeammatePeer.WARCRY_BAR_ICON),
		},
		valign = "center",
		w = tweak_data.gui:icon_w(HUDTeammatePeer.WARCRY_BAR_ICON),
	}

	self._warcry_bar = warcry_panel:bitmap(warcry_bar_params)

	self._warcry_bar:set_center_x(warcry_panel:w() / 2)
	self._warcry_bar:set_center_y(warcry_panel:h() / 2)
	self._warcry_bar:set_position_z(0)
	self:set_active_warcry("sharpshooter")
end

function HUDTeammatePeer:_create_nationality_icon()
	local nationality = "german"
	local nationality_icon = "player_panel_nationality_" .. tostring(nationality)
	local nationality_icon_params = {
		halign = "center",
		name = "nationality_icon",
		texture = tweak_data.gui.icons[nationality_icon].texture,
		texture_rect = tweak_data.gui.icons[nationality_icon].texture_rect,
		valign = "center",
	}

	self._nationality_icon = self._status_panel:bitmap(nationality_icon_params)

	self._nationality_icon:set_center_x(self._status_panel:w() / 2)
	self._nationality_icon:set_center_y(self._status_panel:h() / 2)
end

function HUDTeammatePeer:_create_dead_icon()
	local dead_icon_params = {
		alpha = 0,
		halign = "center",
		name = "dead_icon",
		texture = tweak_data.gui.icons[HUDTeammatePeer.DEAD_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.DEAD_ICON].texture_rect,
		valign = "center",
	}

	self._dead_icon = self._status_panel:bitmap(dead_icon_params)

	self._dead_icon:set_center_x(self._status_panel:w() / 2)
	self._dead_icon:set_center_y(self._status_panel:h() / 2)
end

function HUDTeammatePeer:_create_carry_icon()
	local temp_carry_icon = "carry_alive"
	local carry_icon_params = {
		alpha = 0,
		halign = "center",
		name = "carry_icon",
		texture = tweak_data.gui.icons[temp_carry_icon].texture,
		texture_rect = tweak_data.gui.icons[temp_carry_icon].texture_rect,
		valign = "center",
	}

	self._carry_icon = self._status_panel:bitmap(carry_icon_params)

	self._carry_icon:set_center_x(self._status_panel:w() / 2)
	self._carry_icon:set_center_y(self._status_panel:h() / 2)
end

function HUDTeammatePeer:_create_special_interaction_icon()
	local gui_icon = tweak_data.gui:get_full_gui_data(HUDNameLabel.LOCKPICK_ICON)

	self._special_interaction_icon = self._status_panel:bitmap({
		alpha = 0,
		halign = "center",
		name = "special_interaction_icon",
		texture = gui_icon.texture,
		texture_rect = gui_icon.texture_rect,
		valign = "center",
	})

	self._special_interaction_icon:set_center(self._status_panel:w() / 2, self._status_panel:h() / 2)
end

function HUDTeammatePeer:_create_mounted_weapon_icon()
	local mounted_weapon_icon_params = {
		alpha = 0,
		halign = "center",
		name = "mounted_weapon_icon",
		texture = tweak_data.gui.icons[HUDTeammatePeer.MOUNTED_WEAPON_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.MOUNTED_WEAPON_ICON].texture_rect,
		valign = "center",
	}

	self._mounted_weapon_icon = self._status_panel:bitmap(mounted_weapon_icon_params)

	self._mounted_weapon_icon:set_center_x(self._status_panel:w() / 2)
	self._mounted_weapon_icon:set_center_y(self._status_panel:h() / 2)
end

function HUDTeammatePeer:_create_timer()
	local timer_panel_params = {
		alpha = 0,
		h = self._left_panel:h(),
		layer = 5,
		name = "timer_panel",
		w = self._left_panel:w(),
		x = self._left_panel:x(),
		y = self._left_panel:y(),
	}

	self._timer_panel = self._status_panel:panel(timer_panel_params)

	local timer_background_params = {
		halign = "center",
		layer = 1,
		name = "timer_background",
		texture = tweak_data.gui.icons[HUDTeammatePeer.TIMER_BG_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.TIMER_BG_ICON].texture_rect,
		valign = "center",
	}
	local timer_background = self._timer_panel:bitmap(timer_background_params)

	timer_background:set_center_x(self._timer_panel:w() / 2)
	timer_background:set_center_y(self._timer_panel:h() / 2)

	local timer_bar_params = {
		h = tweak_data.gui:icon_h(HUDTeammatePeer.TIMER_BAR_ICON),
		halign = "center",
		layer = 2,
		name = "timer_bar",
		render_template = "VertexColorTexturedRadial",
		texture = tweak_data.gui.icons[HUDTeammatePeer.TIMER_BAR_ICON].texture,
		texture_rect = {
			tweak_data.gui:icon_w(HUDTeammatePeer.TIMER_BAR_ICON),
			0,
			-tweak_data.gui:icon_w(HUDTeammatePeer.TIMER_BAR_ICON),
			tweak_data.gui:icon_h(HUDTeammatePeer.TIMER_BAR_ICON),
		},
		valign = "center",
		w = tweak_data.gui:icon_w(HUDTeammatePeer.TIMER_BAR_ICON),
	}

	self._timer_bar = self._timer_panel:bitmap(timer_bar_params)

	self._timer_bar:set_center_x(self._timer_panel:w() / 2)
	self._timer_bar:set_center_y(self._timer_panel:h() / 2)

	self._timer_text = self._timer_panel:text({
		align = "center",
		font = tweak_data.gui.fonts[HUDTeammatePeer.TIMER_FONT],
		font_size = HUDTeammatePeer.TIMER_FONT_SIZE,
		h = self._timer_panel:h(),
		layer = 3,
		name = "timer_text",
		text = "37",
		vertical = "center",
		w = self._timer_panel:w(),
	})

	local _, _, _, h = self._timer_text:text_rect()

	self._timer_text:set_h(h)
	self._timer_text:set_center_y(self._timer_panel:h() / 2 - 3)
end

function HUDTeammatePeer:_create_interaction_meter()
	local interaction_meter_panel_params = {
		alpha = 0,
		halign = "left",
		layer = 4,
		name = "interaction_meter_panel",
		valign = "center",
	}

	self._interaction_meter_panel = self._status_panel:panel(interaction_meter_panel_params)

	local interaction_meter_background_params = {
		halign = "scale",
		layer = 1,
		name = "interaction_meter_background",
		texture = tweak_data.gui.icons[HUDTeammatePeer.INTERACTION_METER_BG].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.INTERACTION_METER_BG].texture_rect,
		valign = "scale",
	}
	local interaction_meter_background = self._interaction_meter_panel:bitmap(interaction_meter_background_params)

	interaction_meter_background:set_center_x(self._interaction_meter_panel:w() / 2)
	interaction_meter_background:set_center_y(self._interaction_meter_panel:h() / 2)

	local interaction_meter_params = {
		color = tweak_data.gui.colors.teammate_interaction_bar,
		h = tweak_data.gui:icon_h(HUDTeammatePeer.INTERACTION_METER_FILL),
		halign = "scale",
		layer = 2,
		name = "interaction_meter",
		render_template = "VertexColorTexturedRadial",
		texture = tweak_data.gui.icons[HUDTeammatePeer.INTERACTION_METER_FILL].texture,
		texture_rect = {
			tweak_data.gui:icon_w(HUDTeammatePeer.INTERACTION_METER_FILL),
			0,
			-tweak_data.gui:icon_w(HUDTeammatePeer.INTERACTION_METER_FILL),
			tweak_data.gui:icon_h(HUDTeammatePeer.INTERACTION_METER_FILL),
		},
		valign = "scale",
		w = tweak_data.gui:icon_w(HUDTeammatePeer.INTERACTION_METER_FILL),
	}

	self._interaction_meter = self._interaction_meter_panel:bitmap(interaction_meter_params)

	self._interaction_meter:set_center_x(self._interaction_meter_panel:w() / 2)
	self._interaction_meter:set_center_y(self._interaction_meter_panel:h() / 2)
end

function HUDTeammatePeer:_create_host_indicator()
	local warcry_panel = self._left_panel:child("warcry_panel")
	local warcry_background = warcry_panel:child("warcry_background")
	local host_indicator_params = {
		alpha = 0,
		layer = 30,
		name = "host_indicator",
		texture = tweak_data.gui.icons[HUDTeammatePeer.HOST_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.HOST_ICON].texture_rect,
	}
	local host_indicator = self._left_panel:bitmap(host_indicator_params)

	host_indicator:set_right(warcry_panel:x() + warcry_background:x() + warcry_background:w() - 4)
	host_indicator:set_bottom(warcry_panel:y() + warcry_background:y() + warcry_background:h() - 4)
end

function HUDTeammatePeer:_create_voice_chat_indicator()
	local voice_chat_panel_params = {
		h = HUDTeammatePeer.CHAT_PANEL_W,
		layer = 30,
		name = " voice_chat_panel",
		w = HUDTeammatePeer.CHAT_PANEL_W,
	}

	self._voice_chat_panel = self._right_panel:panel(voice_chat_panel_params)

	local chat_indicator_params_speaking = {
		alpha = 0,
		name = "chat_indicator_speaking",
		texture = tweak_data.gui.icons[HUDTeammatePeer.CHAT_ICON_SPEAKING].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.CHAT_ICON_SPEAKING].texture_rect,
	}

	self._chat_indicator_speaking = self._voice_chat_panel:bitmap(chat_indicator_params_speaking)

	local chat_indicator_params_muted = {
		alpha = 0,
		name = "chat_indicator_muted",
		texture = tweak_data.gui.icons[HUDTeammatePeer.CHAT_ICON_MUTED].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.CHAT_ICON_MUTED].texture_rect,
	}

	self._chat_indicator_muted = self._voice_chat_panel:bitmap(chat_indicator_params_muted)
end

function HUDTeammatePeer:show_chat_indicator(chat_indicator_name)
	local chat_indicator

	if chat_indicator_name == "chat_indicator_speaking" then
		chat_indicator = self._chat_indicator_speaking
	elseif chat_indicator_name == "chat_indicator_muted" then
		chat_indicator = self._chat_indicator_muted
	end

	if chat_indicator then
		chat_indicator:set_alpha(1)
	end
end

function HUDTeammatePeer:hide_chat_indicator(chat_indicator_name)
	local chat_indicator

	if chat_indicator_name == "chat_indicator_speaking" then
		chat_indicator = self._chat_indicator_speaking
	elseif chat_indicator_name == "chat_indicator_muted" then
		chat_indicator = self._chat_indicator_muted
	end

	if chat_indicator then
		chat_indicator:set_alpha(0)
	end
end

function HUDTeammatePeer:_create_right_panel()
	local right_panel_params = {
		h = self._object:h(),
		name = "right_panel",
		w = self._object:w() - HUDTeammatePeer.RIGHT_PANEL_X,
		x = HUDTeammatePeer.RIGHT_PANEL_X,
		y = HUDTeammatePeer.RIGHT_PANEL_Y,
	}

	self._right_panel = self._object:panel(right_panel_params)
end

function HUDTeammatePeer:_create_player_name()
	local player_name_params = {
		align = "left",
		font = tweak_data.gui.fonts[HUDTeammatePeer.PLAYER_NAME_FONT],
		font_size = HUDTeammatePeer.PLAYER_NAME_FONT_SIZE,
		h = HUDTeammatePeer.PLAYER_NAME_H,
		name = "player_name",
		text = "",
		vertical = "center",
		w = self._right_panel:w() - HUDTeammatePeer.PLAYER_LEVEL_W - HUDTeammatePeer.CHAT_PANEL_W,
		x = 0,
		y = -2,
	}

	self._player_name = self._right_panel:text(player_name_params)
end

function HUDTeammatePeer:_create_player_level()
	local player_level_params = {
		align = "right",
		font = tweak_data.gui.fonts[HUDTeammatePeer.PLAYER_LEVEL_FONT],
		font_size = HUDTeammatePeer.PLAYER_LEVEL_FONT_SIZE,
		h = HUDTeammatePeer.PLAYER_LEVEL_H,
		name = "player_level",
		text = "",
		vertical = "center",
		w = HUDTeammatePeer.PLAYER_LEVEL_W,
		x = self._right_panel:w() - HUDTeammatePeer.PLAYER_LEVEL_W,
		y = HUDTeammatePeer.PLAYER_LEVEL_Y,
	}

	self._player_level = self._right_panel:text(player_level_params)

	local current_level = managers.experience:current_level()

	if current_level then
		self._player_level:set_text(current_level)
	end
end

function HUDTeammatePeer:_create_player_health()
	local health_panel_params = {
		h = HUDTeammatePeer.PLAYER_HEALTH_H,
		name = "health_panel",
		w = self._right_panel:w(),
		x = 0,
		y = self._right_panel:h() / 2 - HUDTeammatePeer.PLAYER_HEALTH_H,
	}
	local health_panel = self._right_panel:panel(health_panel_params)
	local health_background_params = {
		halign = "center",
		name = "health_background",
		texture = tweak_data.gui.icons[HUDTeammatePeer.PLAYER_HEALTH_BG_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePeer.PLAYER_HEALTH_BG_ICON].texture_rect,
		valign = "center",
	}
	local health_background = health_panel:bitmap(health_background_params)

	health_background:set_center_x(health_panel:w() / 2)
	health_background:set_center_y(health_panel:h() / 2)

	local health_bar_params = {
		color = tweak_data.gui.colors.progress_75,
		h = health_background:h() - 2,
		layer = health_background:layer() + 1,
		name = "health_bar",
		w = health_background:w() - 2,
	}

	self._health_bar = health_panel:rect(health_bar_params)

	self._health_bar:set_center_x(health_panel:w() / 2)
	self._health_bar:set_center_y(health_panel:h() / 2)

	self._full_health_bar_w = self._health_bar:w()
end

function HUDTeammatePeer:_create_equipment_panel()
	local equipment_panel_params = {
		h = HUDTeammatePeer.EQUIPMENT_H,
		name = "equipment_panel",
		w = self._right_panel:w(),
		x = 0,
		y = self._right_panel:h() / 2,
	}

	self._equipment_panel = self._right_panel:panel(equipment_panel_params)
end

function HUDTeammatePeer:padding_down()
	return HUDTeammatePeer.PADDING_DOWN
end

function HUDTeammatePeer:refresh()
	local name = self._name

	if managers.user:get_setting("capitalize_names") then
		name = utf8.to_upper(name)
	end

	self._player_name:set_text(name)
end

function HUDTeammatePeer:reset_state()
	self._equipment_panel:clear()

	self._equipment = {}

	self._status_panel:child(self._displayed_state.control):set_alpha(0)
	self:set_warcry_ready(false)

	self._displayed_state = self._states[#self._states]
	self._active_states = {}

	self:_add_active_state(self._displayed_state.id)
	self._status_panel:child(self._displayed_state.control):set_alpha(1)
	self._left_panel:child("warcry_panel"):set_alpha(1)
end

function HUDTeammatePeer:set_character_data(data)
	if data.nationality then
		local nationality_icon = "player_panel_nationality_" .. tostring(data.nationality)

		self._nationality_icon:set_image(tweak_data.gui.icons[nationality_icon].texture)
		self._nationality_icon:set_texture_rect(unpack(tweak_data.gui.icons[nationality_icon].texture_rect))
	end

	if data.character_level then
		self._player_level:set_text(data.character_level)
	end
end

function HUDTeammatePeer:set_health(data)
	local health_percentage = math.clamp(data.current / data.total, 0, 1)

	self._health_bar:set_w(health_percentage * self._full_health_bar_w)
	self._health_bar:set_color(GuiTweakData.get_color_for_percentage(HUDTeammatePeer.PLAYER_HEALTH_COLORS, health_percentage))
end

function HUDTeammatePeer:set_active_warcry(warcry)
	if alive(self._warcry_icon) then
		self._warcry_icon:stop()
		self._status_panel:remove(self._warcry_icon)
	end

	local warcry_icon_name = tweak_data.warcry[warcry].hud_icon
	local warcry_icon_params = {
		alpha = self._active_states.warcry and 1 or 0,
		halign = "center",
		name = "warcry_icon",
		texture = tweak_data.gui.icons[warcry_icon_name].texture,
		texture_rect = tweak_data.gui.icons[warcry_icon_name].texture_rect,
		valign = "center",
	}

	self._warcry_icon = self._status_panel:bitmap(warcry_icon_params)

	self._warcry_icon:set_center_x(self._status_panel:w() / 2)
	self._warcry_icon:set_center_y(self._status_panel:h() / 2)
end

function HUDTeammatePeer:set_warcry_meter_fill(data)
	self._warcry_bar:set_position_z(data.current / data.total)

	if data.current / data.total >= 1 then
		self:set_warcry_ready(true)
	end
end

function HUDTeammatePeer:go_into_bleedout()
	HUDTeammatePeer.super.go_into_bleedout(self)
	self:deactivate_warcry()
end

function HUDTeammatePeer:activate_warcry(duration)
	self._warcry_bar:stop()
	self._warcry_bar:animate(callback(self, self, "_animate_warcry_active"), duration)
end

function HUDTeammatePeer:deactivate_warcry()
	if alive(self._warcry_icon) then
		self._warcry_icon:stop()
		self._warcry_icon:animate(callback(self, self, "_animate_warcry_not_ready"))
	end

	self._warcry_bar:stop()
	self._warcry_bar:set_position_z(0)
	self:_remove_active_state("warcry")
end

function HUDTeammatePeer:set_warcry_ready(value)
	if value == self:has_active_state("warcry") then
		return
	end

	if alive(self._warcry_icon) then
		self._warcry_icon:stop()

		if value == true then
			self._warcry_icon:animate(callback(self, self, "_animate_warcry_ready"))
			self:_add_active_state("warcry")
		else
			self._warcry_icon:animate(callback(self, self, "_animate_warcry_not_ready"))
			self:_remove_active_state("warcry")
		end
	end
end

function HUDTeammatePeer:set_name(name)
	self._name = name

	if managers.user:get_setting("capitalize_names") then
		name = utf8.to_upper(name)
	end

	self._player_name:set_text(name)

	local name_w = select(3, self._player_name:text_rect())
	local chat_x = math.min(name_w, self._player_name:w())

	self._voice_chat_panel:set_left(self._player_name:x() + chat_x)
	self._voice_chat_panel:set_top(self._player_name:y())
end

function HUDTeammatePeer:set_nationality(nationality)
	local nationality_icon = "player_panel_nationality_" .. tostring(nationality)

	self._nationality_icon:set_image(tweak_data.gui.icons[nationality_icon].texture)
	self._nationality_icon:set_texture_rect(unpack(tweak_data.gui.icons[nationality_icon].texture_rect))
end

function HUDTeammatePeer:set_level(level)
	self._player_level:set_text(level)
end

function HUDTeammatePeer:set_cheater(state)
	return
end

function HUDTeammatePeer:set_carry_info(carry_id)
	local carry_tweak_data = tweak_data.carry[carry_id]

	if carry_tweak_data and carry_tweak_data.hud_icon then
		self._carry_icon:set_image(tweak_data.gui.icons[carry_tweak_data.hud_icon].texture)
		self._carry_icon:set_texture_rect(unpack(tweak_data.gui.icons[carry_tweak_data.hud_icon].texture_rect))
		self._carry_icon:set_center_x(self._status_panel:w() / 2)
		self._carry_icon:set_center_y(self._status_panel:h() / 2)
		self:_add_active_state("carry")
	else
		Application:debug("[HUDTeammatePeer] set_carry_info(): no tweak data or HUD icon for item " .. tostring(carry_id))
	end
end

function HUDTeammatePeer:remove_carry_info()
	self:_remove_active_state("carry")
end

function HUDTeammatePeer:show_turret_icon()
	self:_add_active_state("mounted_weapon")
end

function HUDTeammatePeer:hide_turret_icon()
	self:_remove_active_state("mounted_weapon")
end

function HUDTeammatePeer:show_special_interaction_icon(interaction_type)
	local minigame_icon = tweak_data.interaction.minigame_icons[interaction_type]

	if minigame_icon then
		local gui_icon = tweak_data.gui:get_full_gui_data(minigame_icon)

		self._special_interaction_icon:set_image(gui_icon.texture)
		self._special_interaction_icon:set_texture_rect(unpack(gui_icon.texture_rect))
		self._special_interaction_icon:set_center(self._status_panel:w() / 2, self._status_panel:h() / 2)
		self:_add_active_state("special_interaction")
	end
end

function HUDTeammatePeer:hide_special_interaction_icon()
	self:_remove_active_state("special_interaction")
end

function HUDTeammatePeer:show_host_indicator()
	local host_indicator = self._left_panel:child("host_indicator")

	host_indicator:stop()
	host_indicator:animate(callback(self, self, "_animate_show_host_indicator"))
end

function HUDTeammatePeer:hide_host_indicator()
	local host_indicator = self._left_panel:child("host_indicator")

	host_indicator:stop()
	host_indicator:animate(callback(self, self, "_animate_hide_host_indicator"))
end

function HUDTeammatePeer:add_special_equipment(data)
	local existing_equipment

	for i = 1, #self._equipment do
		if self._equipment[i]:id() == data.id then
			existing_equipment = self._equipment[i]

			break
		end
	end

	if existing_equipment then
		local new_amount = data and data.amount or 1

		existing_equipment:set_amount(existing_equipment:amount() + new_amount)
	else
		local equipment = HUDEquipment:new(self._equipment_panel, data.icon, data.id, data.amount)

		table.insert(self._equipment, equipment)
		self:_layout_special_equipment()
	end
end

function HUDTeammatePeer:remove_special_equipment(id)
	for i = #self._equipment, 1, -1 do
		if self._equipment[i]:id() == id then
			self._equipment[i]:destroy()
			table.remove(self._equipment, i)

			break
		end
	end

	self:_layout_special_equipment()
end

function HUDTeammatePeer:set_special_equipment_amount(equipment_id, amount)
	for i = 1, #self._equipment do
		if self._equipment[i]:id() == equipment_id then
			self._equipment[i]:set_amount(amount)
		end
	end
end

function HUDTeammatePeer:clear_special_equipment()
	self._equipment_panel:clear()

	self._equipment = {}
end

function HUDTeammatePeer:_layout_special_equipment()
	local x = 0

	for i = 1, #self._equipment do
		self._equipment[i]:set_x(x)

		x = x + self._equipment[i]:w() + HUDTeammatePeer.EQUIPMENT_PADDING
	end
end

function HUDTeammatePeer:set_condition(icon_data, text)
	if icon_data == self._state then
		return
	end

	if icon_data == "mugshot_in_custody" then
		self:set_warcry_ready(false)
	end

	self._state = icon_data
end

function HUDTeammatePeer:start_interact(timer)
	self:_add_active_state("interaction")
	self._interaction_meter:stop()
	self._interaction_meter:animate(callback(self, self, "_animate_interact"), timer)
end

function HUDTeammatePeer:cancel_interact()
	self:_remove_active_state("interaction")
	self._interaction_meter:stop()
	self._interaction_meter:animate(callback(self, self, "_animate_cancel_interact"))
end

function HUDTeammatePeer:complete_interact()
	self:_remove_active_state("interaction")
	self._interaction_meter:stop()
	self._interaction_meter:animate(callback(self, self, "_animate_complete_interact"))
end

function HUDTeammatePeer:_animate_interact(interact_image, duration)
	local t = 0

	self._interaction_meter:set_position_z(0)
	self._interaction_meter:set_rotation(0)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_progress = Easing.linear(t, 0, 1, duration)

		self._interaction_meter:set_position_z(current_progress)
	end

	self._interaction_meter:set_position_z(1)
end

function HUDTeammatePeer:_animate_cancel_interact()
	local duration = 0.2
	local t = (1 - self._interaction_meter:position_z()) * duration

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_progress = Easing.linear(t, 1, -1, duration)

		self._interaction_meter:set_position_z(current_progress)
	end

	self._interaction_meter:set_position_z(0)
end

function HUDTeammatePeer:_animate_complete_interact()
	local size_decrease_duration = 0.18
	local duration = 0.2
	local t = 0

	self._interaction_meter:set_position_z(1)
	self._interaction_meter:set_rotation(0)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_progress = Easing.linear(t, 1, -1, duration)

		self._interaction_meter:set_position_z(current_progress)

		local current_rotation = Easing.linear(t, 360, -360, duration)

		self._interaction_meter:set_rotation(current_rotation)
	end

	self._interaction_meter:set_position_z(0)
	self._interaction_meter:set_rotation(0)
end

function HUDTeammatePeer:_animate_warcry_active(warcry_bar, duration)
	local t = duration

	while t > 0 do
		local dt = coroutine.yield()

		t = t - dt

		warcry_bar:set_position_z(t / duration)
	end

	warcry_bar:set_position_z(0)
end

function HUDTeammatePeer:_animate_warcry_ready()
	local duration = 0.15
	local t = 0

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_r = Easing.quartic_out(t, HUDTeammatePeer.WARCRY_INACTIVE_COLOR.r, HUDTeammatePeer.WARCRY_ACTIVE_COLOR.r - HUDTeammatePeer.WARCRY_INACTIVE_COLOR.r, duration)
		local current_g = Easing.quartic_out(t, HUDTeammatePeer.WARCRY_INACTIVE_COLOR.g, HUDTeammatePeer.WARCRY_ACTIVE_COLOR.g - HUDTeammatePeer.WARCRY_INACTIVE_COLOR.g, duration)
		local current_b = Easing.quartic_out(t, HUDTeammatePeer.WARCRY_INACTIVE_COLOR.b, HUDTeammatePeer.WARCRY_ACTIVE_COLOR.b - HUDTeammatePeer.WARCRY_INACTIVE_COLOR.b, duration)

		self._warcry_icon:set_color(Color(current_r, current_g, current_b))
		self._warcry_bar:set_color(Color(current_r, current_g, current_b))
	end

	self._warcry_icon:set_color(HUDTeammatePlayer.WARCRY_ACTIVE_COLOR)
	self._warcry_bar:set_color(HUDTeammatePlayer.WARCRY_ACTIVE_COLOR)
end

function HUDTeammatePeer:_animate_warcry_not_ready()
	local duration = 0.15
	local t = 0

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_r = Easing.quartic_out(t, HUDTeammatePeer.WARCRY_ACTIVE_COLOR.r, HUDTeammatePeer.WARCRY_INACTIVE_COLOR.r - HUDTeammatePeer.WARCRY_ACTIVE_COLOR.r, duration)
		local current_g = Easing.quartic_out(t, HUDTeammatePeer.WARCRY_ACTIVE_COLOR.g, HUDTeammatePeer.WARCRY_INACTIVE_COLOR.g - HUDTeammatePeer.WARCRY_ACTIVE_COLOR.g, duration)
		local current_b = Easing.quartic_out(t, HUDTeammatePeer.WARCRY_ACTIVE_COLOR.b, HUDTeammatePeer.WARCRY_INACTIVE_COLOR.b - HUDTeammatePeer.WARCRY_ACTIVE_COLOR.b, duration)

		self._warcry_icon:set_color(Color(current_r, current_g, current_b))
		self._warcry_bar:set_color(Color(current_r, current_g, current_b))
	end

	self._warcry_icon:set_color(HUDTeammatePlayer.WARCRY_INACTIVE_COLOR)
	self._warcry_bar:set_color(HUDTeammatePlayer.WARCRY_INACTIVE_COLOR)
end

function HUDTeammatePeer:_animate_show_host_indicator(host_indicator)
	local duration = 0.15
	local t = host_indicator:alpha() * duration

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 1, duration)

		host_indicator:set_alpha(current_alpha)
	end

	host_indicator:set_alpha(1)
end

function HUDTeammatePeer:_animate_hide_host_indicator(host_indicator)
	local duration = 0.15
	local t = (1 - host_indicator:alpha()) * duration

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 1, -1, duration)

		host_indicator:set_alpha(current_alpha)
	end

	host_indicator:set_alpha(0)
end
