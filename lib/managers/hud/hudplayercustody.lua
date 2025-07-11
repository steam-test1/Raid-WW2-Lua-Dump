HUDPlayerCustody = HUDPlayerCustody or class()
HUDPlayerCustody.SPECTATOR_PANEL_W = 520
HUDPlayerCustody.SPECTATOR_PANEL_H = 72
HUDPlayerCustody.SPECTATOR_TEXT = "hud_spectator_prompt_current"
HUDPlayerCustody.SPECTATOR_TEXT_FONT = tweak_data.gui.fonts.din_compressed_outlined_38
HUDPlayerCustody.SPECTATOR_TEXT_FONT_SIZE = tweak_data.gui.font_sizes.dialg_title
HUDPlayerCustody.SPECTATOR_BACKGROUND = "backgrounds_chat_bg"
HUDPlayerCustody.SPECTATOR_BACKGROUND_H = 44
HUDPlayerCustody.BUTTON_PROMPT_TEXT_FONT = tweak_data.gui.fonts.din_compressed_outlined_24
HUDPlayerCustody.BUTTON_PROMPT_TEXT_FONT_SIZE = tweak_data.gui.font_sizes.extra_small
HUDPlayerCustody.BUTTON_PROMPT_TEXT_COLOR = tweak_data.gui.colors.raid_white
HUDPlayerCustody.BUTTON_PROMPT_CYCLE = "hud_spectator_prompt_cycle"

function HUDPlayerCustody:init(hud)
	self._hud = hud
	self._hud_panel = hud.panel
	self._last_respawn_type_is_ai_trade = false

	if self._hud_panel:child("custody_panel") then
		self._hud_panel:remove(self._hud_panel:child("custody_panel"))
	end

	local custody_panel = self._hud_panel:panel({
		halign = "grow",
		name = "custody_panel",
		valign = "grow",
	})
	local timer_message_params = {
		align = "center",
		font = tweak_data.gui.fonts.din_compressed_outlined_24,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 40,
		name = "timer_msg",
		text = "custodddddy in",
		vertical = "center",
		w = 400,
	}
	local timer_msg = custody_panel:text(timer_message_params)

	timer_msg:set_text(utf8.to_upper(managers.localization:text("hud_respawning_in")))

	local _, _, w, h = timer_msg:text_rect()

	timer_msg:set_h(h)
	timer_msg:set_x(math.round(self._hud_panel:center_x() - timer_msg:w() / 2))
	timer_msg:set_y(28)

	local timer_params = {
		align = "center",
		font = tweak_data.gui.fonts.din_compressed_outlined_42,
		font_size = tweak_data.gui.font_sizes.menu_list,
		h = 32,
		name = "timer",
		text = "00:00",
		vertical = "bottom",
		w = custody_panel:w(),
	}
	local timer = custody_panel:text(timer_params)
	local _, _, w, h = timer:text_rect()

	timer:set_h(h)
	timer:set_y(math.round(timer_msg:bottom() - 6))
	timer:set_center_x(self._hud_panel:center_x())

	self._timer = timer
	self._last_time = -1
	self._last_trade_delay_time = -1
end

function HUDPlayerCustody:set_spectator_info(unit)
	if not self._spectator_panel then
		self:_create_spectator_info(self._hud_panel:child("custody_panel"))
	end

	if alive(unit) then
		local nick_name = unit:base():nick_name()

		if managers.user:get_setting("capitalize_names") then
			nick_name = utf8.to_upper(nick_name)
		end

		self._spectator_text:set_text(nick_name)
		self._spectator_panel:set_visible(true)
		self:_refresh_button_prompt()
	else
		self._spectator_panel:set_visible(false)
	end
end

function HUDPlayerCustody:_create_spectator_info(parent)
	self._spectator_panel = parent:panel({
		h = HUDPlayerCustody.SPECTATOR_PANEL_H,
		halign = "left",
		name = "spectator_panel",
		valign = "bottom",
		w = HUDPlayerCustody.SPECTATOR_PANEL_W,
	})

	self._spectator_panel:set_center_x(parent:w() / 2)
	self._spectator_panel:set_bottom(parent:h() - 25)

	local spectator_background = self._spectator_panel:bitmap({
		h = HUDPlayerCustody.SPECTATOR_BACKGROUND_H,
		name = "spectator_background",
		texture = tweak_data.gui.icons[HUDPlayerCustody.SPECTATOR_BACKGROUND].texture,
		texture_rect = tweak_data.gui.icons[HUDPlayerCustody.SPECTATOR_BACKGROUND].texture_rect,
		w = HUDPlayerCustody.SPECTATOR_PANEL_W,
	})

	self._spectator_text = self._spectator_panel:text({
		align = "center",
		font = HUDPlayerCustody.SPECTATOR_TEXT_FONT,
		font_size = HUDPlayerCustody.SPECTATOR_TEXT_FONT_SIZE,
		h = HUDPlayerCustody.SPECTATOR_BACKGROUND_H,
		halign = "center",
		layer = spectator_background:layer() + 1,
		name = "spectator_text",
		text = "SPECTATING",
		valign = "center",
		vertical = "center",
	})
	self._button_prompt = self._spectator_panel:text({
		align = "center",
		color = HUDPlayerCustody.BUTTON_PROMPT_TEXT_COLOR,
		font = HUDPlayerCustody.BUTTON_PROMPT_TEXT_FONT,
		font_size = HUDPlayerCustody.BUTTON_PROMPT_TEXT_FONT_SIZE,
		halign = "center",
		name = "prompt_previous",
		text = "",
		valign = "center",
		vertical = "bottom",
	})

	self:_refresh_button_prompt()
end

function HUDPlayerCustody:_refresh_button_prompt()
	local btn_macros

	if managers.controller:is_using_controller() then
		btn_macros = {
			BTN_LEFT = managers.localization:get_default_macros().BTN_PRIMARY,
			BTN_RIGHT = managers.localization:get_default_macros().BTN_SECONDARY,
		}
	else
		btn_macros = {
			BTN_LEFT = managers.localization:btn_macro("left"),
			BTN_RIGHT = managers.localization:btn_macro("right"),
		}
	end

	local prompt_text = managers.localization:text(HUDPlayerCustody.BUTTON_PROMPT_CYCLE, btn_macros)

	self._button_prompt:set_text(utf8.to_upper(prompt_text))
end

function HUDPlayerCustody:set_pumpkin_challenge()
	local top_text = utf8.to_upper(managers.localization:text("card_ra_season_of_resurrection_name_id"))

	self._hud_panel:child("custody_panel"):child("timer_msg"):set_text(top_text)

	local bottom_text = utf8.to_upper(managers.localization:text("hud_pumpkin_revive_tutorial"))

	self._timer:set_text(bottom_text)
end

function HUDPlayerCustody:set_timer_visibility(visible)
	self._hud_panel:child("custody_panel"):child("timer_msg"):set_text(utf8.to_upper(managers.localization:text("hud_respawning_in")))
	self._timer:set_visible(visible)
	self._hud_panel:child("custody_panel"):child("timer_msg"):set_visible(visible)
end

function HUDPlayerCustody:set_respawn_time(time)
	if math.floor(time) == math.floor(self._last_time) then
		return
	end

	self._last_time = time

	local time_text = self:_get_time_text(time)

	self._timer:set_text(utf8.to_upper(tostring(time_text)))
end

function HUDPlayerCustody:_get_time_text(time)
	time = math.max(math.floor(time), 0)

	local minutes = math.floor(time / 60)

	time = time - minutes * 60

	local seconds = math.round(time)
	local text = ""

	return text .. (minutes < 10 and "0" .. minutes or minutes) .. ":" .. (seconds < 10 and "0" .. seconds or seconds)
end

function HUDPlayerCustody:_animate_text_pulse(text)
	local t = 0

	while true do
		local dt = coroutine.yield()

		t = t + dt

		local alpha = 0.5 + math.abs((math.sin(t * 360 * 0.5))) / 2

		text:set_alpha(alpha)
	end
end

function HUDPlayerCustody:set_respawn_type(is_ai_trade)
	if self._last_respawn_type_is_ai_trade ~= is_ai_trade then
		local text = utf8.to_upper(managers.localization:text(is_ai_trade and "hud_ai_traded_in" or "hud_respawning_in"))

		self._hud_panel:child("custody_panel"):child("timer_msg"):set_text(text)

		self._last_respawn_type_is_ai_trade = is_ai_trade
	end
end
