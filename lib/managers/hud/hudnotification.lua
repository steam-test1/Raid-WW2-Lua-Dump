HUDNotification = HUDNotification or class()
HUDNotificationCardFail = HUDNotificationCardFail or class(HUDNotification)
HUDNotificationProgress = HUDNotificationProgress or class(HUDNotification)
HUDNotificationIcon = HUDNotificationIcon or class(HUDNotification)
HUDNotification.GENERIC = "generic"
HUDNotification.ICON = "icon"
HUDNotification.CARD_FAIL = "card_fail"
HUDNotification.WEAPON_CHALLENGE = "weapon_challenge"
HUDNotification.ANIMATION_MOVE_X_DISTANCE = 30
HUDNotification.DEFAULT_DISTANCE_FROM_BOTTOM = 130

function HUDNotification.create(notification_data)
	if not notification_data.notification_type or notification_data.notification_type == HUDNotification.GENERIC then
		return HUDNotification:new(notification_data)
	elseif notification_data.notification_type == HUDNotification.ICON then
		return HUDNotificationIcon:new(notification_data)
	elseif notification_data.notification_type == HUDNotification.CARD_FAIL then
		return HUDNotificationCardFail:new(notification_data)
	elseif notification_data.notification_type == HUDNotification.WEAPON_CHALLENGE then
		return HUDNotificationWeaponChallenge:new(notification_data)
	end
end

function HUDNotification:init(notification_data)
	self._hud = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_panel = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT).panel:root()
	self._safe_rect_offset = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT).panel:x()
	self._font_size = 24
	self._font = tweak_data.gui.fonts.din_compressed_outlined_24
	self._panel_shape_x = 1344
	self._panel_shape_y = 728
	self._panel_shape_h = 84
	self._panel_shape_w = 384

	local padding = 0.2

	self._object = self._hud_panel:panel({
		layer = 100,
		name = "notification_panel",
		visible = true,
		h = self._panel_shape_h,
		w = self._panel_shape_w,
		x = self._panel_shape_x,
		y = self._panel_shape_y,
	})
	self._bg_texture = self._object:bitmap({
		layer = 1,
		name = "bg_texture",
		x = 0,
		y = 0,
		h = self._panel_shape_h,
		texture = tweak_data.gui.icons.backgrounds_chat_bg.texture,
		texture_rect = tweak_data.gui.icons.backgrounds_chat_bg.texture_rect,
		w = self._panel_shape_w,
	})

	self._bg_texture:set_y(self._object:h() - self._panel_shape_h)

	local notification_text = notification_data.text

	if notification_data.prompt then
		notification_text = notification_text .. "\n" .. notification_data.prompt
	end

	self._text = self._object:text({
		align = "center",
		halign = "scale",
		layer = 2,
		name = "text",
		valign = "scale",
		vertical = "center",
		wrap = true,
		font = self._font,
		font_size = self._font_size,
		text = notification_text,
	})

	self._text:set_x(self._object:h() * padding * 0.5)
	self._text:set_y(self._object:h() * padding * 0.5)
	self._text:set_w(self._object:w() - self._object:h() * padding)
	self._text:set_h(self._object:h() * (1 - padding))

	self._initial_right_x = self._object:right()

	self._object:animate(callback(self, self, "_animate_show"))

	self._progress = 0
end

function HUDNotification:hide()
	self._object:animate(callback(self, self, "_animate_hide"))
end

function HUDNotification:cancel_execution()
	self._object:animate(callback(self, self, "_animate_cancel"))
end

function HUDNotification:execute()
	self._object:stop()
	self._object:animate(callback(self, self, "_animate_hide"))
end

function HUDNotification:destroy()
	self._object:stop()
	self._object:parent():remove(self._object)
end

function HUDNotification:update_data(data)
	if data.text and self._text then
		self._text:set_text(data.text)
	end
end

function HUDNotification:set_progress(progress)
	local scale = 1 - 0.15 * progress

	self._object:stop()
	self._object:set_size(self._panel_shape_w * scale, self._panel_shape_h * scale)
	self._object:set_x(self._panel_shape_x + self._panel_shape_w * (1 - scale) * 0.5)
	self._object:set_y(self._panel_shape_y + self._panel_shape_h * (1 - scale) * 0.5)
	self._text:set_font_size(self._font_size * scale)

	self._progress = progress
end

function HUDNotification:get_progress()
	return self._progress
end

function HUDNotification:set_full_progress()
	self._progress = 1

	self._object:stop()
	self._object:animate(callback(self, self, "_animate_full_progress"))
end

function HUDNotificationCardFail:init(notification_data)
	self._hud = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_panel = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT).panel:root()
	self._safe_rect_offset = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT).panel:x()
	self._font = tweak_data.gui.fonts.din_compressed_outlined_24
	self._font_size = 24
	self._panel_shape_x = 1344
	self._panel_shape_y = 362
	self._panel_shape_w = 384
	self._panel_shape_h = 432

	local params_root_panel = {
		is_root_panel = true,
		layer = 100,
		name = "notification_panel",
		visible = true,
		h = self._panel_shape_h,
		w = self._panel_shape_w,
		x = self._panel_shape_x,
		y = self._panel_shape_y,
	}

	self._object = RaidGUIPanel:new(self._hud_panel, params_root_panel)

	local padding = 0.1

	self._bg_texture = self._object:bitmap({
		layer = 1,
		name = "bg_texture",
		h = self._panel_shape_h,
		texture = tweak_data.gui.icons.backgrounds_chat_bg.texture,
		texture_rect = tweak_data.gui.icons.backgrounds_chat_bg.texture_rect,
		w = self._panel_shape_w,
	})

	self._bg_texture:set_y(self._object:h() - self._bg_texture:h())
	self._bg_texture:set_x(0)

	self._card = tweak_data.challenge_cards:get_card_by_key_name(notification_data.card)
	self._card_name = managers.localization:text(self._card.name)
	self._card_fail_text = managers.localization:text("hud_challenge_card_failed", {
		CARD = string.upper(self._card_name),
	})
	self._card_rarity = managers.challenge_cards:get_active_card()
	self._upper_text = self._object:text({
		align = "right",
		halign = "scale",
		layer = 2,
		name = "card_fail_text",
		valign = "scale",
		vertical = "center",
		wrap = true,
		font = self._font,
		font_size = self._font_size,
		text = self._card_fail_text,
	})

	self._upper_text:set_x(32)
	self._upper_text:set_h(96)
	self._upper_text:set_y(0)
	self._upper_text:set_w(self._panel_shape_w - 64)

	local card_params = {
		item_h = 248,
		item_w = 184,
		name = "player_card",
		x = 168,
		y = 96,
	}

	self._card_control = self._object:create_custom_control(RaidGUIControlCardBase, card_params)

	self._card_control:set_card(self._card)

	local prompt_text = notification_data.prompt

	self._text = self._object:text({
		align = "right",
		halign = "scale",
		layer = 2,
		name = "text",
		valign = "scale",
		vertical = "center",
		wrap = true,
		font = self._font,
		font_size = self._font_size,
		text = prompt_text,
	})

	self._text:set_x(32)
	self._text:set_y(self._object:h() - 96)
	self._text:set_w(self._object:w() - 64)
	self._text:set_h(96)

	self._initial_right_x = self._object:right()

	self._object:animate(callback(self, self, "_animate_show"))

	self._progress = 0
end

function HUDNotificationCardFail:hide()
	self._object:animate(callback(self, self, "_animate_hide"))
end

function HUDNotificationCardFail:destroy()
	self._object:stop()
	self._object:clear()

	self = nil
end

function HUDNotificationIcon:init()
	Application:error("HUDNotificationIcon has not been implemented yet!")
end

HUDNotificationWeaponChallenge = HUDNotificationWeaponChallenge or class(HUDNotification)
HUDNotificationWeaponChallenge.Y = 544
HUDNotificationWeaponChallenge.WIDTH = 384
HUDNotificationWeaponChallenge.HEIGHT = 224
HUDNotificationWeaponChallenge.BACKGROUND_IMAGE = "backgrounds_chat_bg"
HUDNotificationWeaponChallenge.RIGHT_SIDE_X = 64
HUDNotificationWeaponChallenge.PADDING_RIGHT = 32
HUDNotificationWeaponChallenge.TITLE_Y = 28
HUDNotificationWeaponChallenge.TITLE_H = 32
HUDNotificationWeaponChallenge.TITLE_FONT = tweak_data.gui.fonts.din_compressed
HUDNotificationWeaponChallenge.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDNotificationWeaponChallenge.TITLE_COLOR = tweak_data.gui.colors.raid_dirty_white
HUDNotificationWeaponChallenge.TITLE_DISTANCE_FROM_DESCRIPTION = 12
HUDNotificationWeaponChallenge.DESCRIPTION_Y = 80
HUDNotificationWeaponChallenge.DESCRIPTION_FONT = tweak_data.gui.fonts.lato
HUDNotificationWeaponChallenge.DESCRIPTION_FONT_SIZE = tweak_data.gui.font_sizes.size_20
HUDNotificationWeaponChallenge.DESCRIPTION_COLOR = Color("b8b8b8")
HUDNotificationWeaponChallenge.DESCRIPTION_DISTANCE_FROM_PROGRESS_BAR = 23
HUDNotificationWeaponChallenge.PROGRESS_BAR_DISTANCE_FROM_BOTTOM = 32

function HUDNotificationWeaponChallenge:init(notification_data)
	self:_create_panel()
	self:_create_title()
	self:_create_tier_label()
	self:_create_icon()
	self:_create_description()
	self:_create_progress_bar()

	if notification_data.challenge then
		self:_set_challenge(notification_data.challenge)
	end

	self._object:animate(callback(self, self, "_animate_show"))

	self._progress = 0
end

function HUDNotificationWeaponChallenge:_create_panel()
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	local hud_panel = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT).panel:root()
	local panel_params = {
		name = "notification_weapon_challenge",
		visible = true,
		h = HUDNotificationWeaponChallenge.HEIGHT,
		w = HUDNotificationWeaponChallenge.WIDTH,
		y = HUDNotificationWeaponChallenge.Y,
	}

	self._object = hud.panel:panel(panel_params)

	self._object:set_right(hud.panel:w())

	self._initial_right_x = self._object:right()

	local background_params = {
		halign = "scale",
		valign = "scale",
		h = self._object:h(),
		texture = tweak_data.gui.icons[HUDNotificationWeaponChallenge.BACKGROUND_IMAGE].texture,
		texture_rect = tweak_data.gui.icons[HUDNotificationWeaponChallenge.BACKGROUND_IMAGE].texture_rect,
		w = self._object:w(),
	}

	self._object:bitmap(background_params)
end

function HUDNotificationWeaponChallenge:_create_title()
	local title_params = {
		align = "left",
		layer = 3,
		name = "notification_weapon_challenge_title",
		text = "INCREASE ACCURACY",
		vertical = "center",
		color = HUDNotificationWeaponChallenge.TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDNotificationWeaponChallenge.TITLE_FONT, HUDNotificationWeaponChallenge.TITLE_FONT_SIZE),
		font_size = HUDNotificationWeaponChallenge.TITLE_FONT_SIZE,
		h = HUDNotificationWeaponChallenge.TITLE_H,
		w = self._object:w() - HUDNotificationWeaponChallenge.RIGHT_SIDE_X,
		x = HUDNotificationWeaponChallenge.RIGHT_SIDE_X,
		y = HUDNotificationWeaponChallenge.TITLE_Y,
	}

	self._title = self._object:text(title_params)
end

function HUDNotificationWeaponChallenge:_create_tier_label()
	local tier_label_params = {
		align = "left",
		layer = 3,
		name = "weapon_challenge_tier",
		text = "TI",
		vertical = "center",
		color = HUDNotificationWeaponChallenge.TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDNotificationWeaponChallenge.TITLE_FONT, HUDNotificationWeaponChallenge.TITLE_FONT_SIZE),
		font_size = HUDNotificationWeaponChallenge.TITLE_FONT_SIZE,
		h = HUDNotificationWeaponChallenge.TITLE_H,
		y = HUDNotificationWeaponChallenge.TITLE_Y,
	}

	self._tier = self._object:text(tier_label_params)
end

function HUDNotificationWeaponChallenge:_create_icon()
	local default_icon = "wpn_skill_accuracy"
	local icon_params = {
		layer = 3,
		name = "weapon_challenge_icon",
		texture = tweak_data.gui.icons[default_icon].texture,
		texture_rect = tweak_data.gui.icons[default_icon].texture_rect,
		y = HUDNotificationWeaponChallenge.DESCRIPTION_Y,
	}

	self._icon = self._object:bitmap(icon_params)
end

function HUDNotificationWeaponChallenge:_create_description()
	local description_params = {
		layer = 3,
		name = "weapon_challenge_description",
		text = "Bla bla bla bla",
		wrap = true,
		color = HUDNotificationWeaponChallenge.DESCRIPTION_COLOR,
		font = tweak_data.gui:get_font_path(HUDNotificationWeaponChallenge.DESCRIPTION_FONT, HUDNotificationWeaponChallenge.DESCRIPTION_FONT_SIZE),
		font_size = HUDNotificationWeaponChallenge.DESCRIPTION_FONT_SIZE,
		w = self._object:w() - HUDNotificationWeaponChallenge.RIGHT_SIDE_X - HUDNotificationWeaponChallenge.PADDING_RIGHT,
		x = HUDNotificationWeaponChallenge.RIGHT_SIDE_X,
		y = HUDNotificationWeaponChallenge.DESCRIPTION_Y,
	}

	self._description = self._object:text(description_params)
end

function HUDNotificationWeaponChallenge:_create_progress_bar()
	local texture_center = "slider_large_center"
	local texture_left = "slider_large_left"
	local texture_right = "slider_large_right"
	local progress_bar_panel_params = {
		is_root_panel = true,
		layer = 3,
		name = "weapon_challenge_progress_bar_panel",
		vertical = "bottom",
		x = 0,
		h = tweak_data.gui:icon_h(texture_center),
		w = self._object:w(),
	}

	self._progress_bar_panel = RaidGUIPanel:new(self._object, progress_bar_panel_params)

	self._progress_bar_panel:set_bottom(self._object:h() - HUDNotificationWeaponChallenge.PROGRESS_BAR_DISTANCE_FROM_BOTTOM)

	local progress_bar_background_params = {
		layer = 1,
		name = "weapon_challenge_progress_bar_background",
		center = texture_center,
		color = Color.white:with_alpha(0.5),
		h = tweak_data.gui:icon_h(texture_center),
		left = texture_left,
		right = texture_right,
		w = self._progress_bar_panel:w(),
	}
	local progress_bar_background = self._progress_bar_panel:three_cut_bitmap(progress_bar_background_params)
	local progress_bar_foreground_panel_params = {
		halign = "scale",
		layer = 2,
		name = "weapon_challenge_progress_bar_foreground_panel",
		valign = "scale",
		x = 0,
		y = 0,
		h = self._progress_bar_panel:h(),
		w = self._progress_bar_panel:w(),
	}

	self._progress_bar_foreground_panel = self._progress_bar_panel:panel(progress_bar_foreground_panel_params)

	local progress_bar_background_params = {
		name = "weapon_challenge_progress_bar_background",
		center = texture_center,
		color = tweak_data.gui.colors.raid_red,
		h = tweak_data.gui:icon_h(texture_center),
		left = texture_left,
		right = texture_right,
		w = self._progress_bar_panel:w(),
	}
	local progress_bar_background = self._progress_bar_foreground_panel:three_cut_bitmap(progress_bar_background_params)
	local progress_bar_text_params = {
		align = "center",
		layer = 5,
		name = "weapon_challenge_progress_bar_text",
		text = "123/456",
		vertical = "center",
		x = 0,
		y = -2,
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = self._progress_bar_panel:h(),
		w = self._progress_bar_panel:w(),
	}

	self._progress_text = self._progress_bar_panel:label(progress_bar_text_params)
end

function HUDNotificationWeaponChallenge:_set_challenge(challenge_data)
	local challenge, count, target

	if challenge_data.challenge_id then
		challenge = managers.challenge:get_challenge(ChallengeManager.CATEGORY_WEAPON_UPGRADE, challenge_data.challenge_id)

		local tasks = challenge:tasks()

		count = tasks[1]:current_count()
		target = tasks[1]:target()
	end

	local skill_tweak_data = tweak_data.weapon_skills.skills[challenge_data.skill_name]

	self._title:set_text(utf8.to_upper(managers.localization:text(skill_tweak_data.name_id)))

	local tier_text = utf8.to_upper(managers.localization:text("menu_weapons_stats_tier_abbreviation")) .. RaidGUIControlWeaponSkills.ROMAN_NUMERALS[challenge_data.tier]

	self._tier:set_text(tier_text)

	local _, _, w, _ = self._tier:text_rect()

	self._tier:set_w(w)
	self._tier:set_center_x(self._icon:center_x())

	local icon = tweak_data.gui.icons[skill_tweak_data.icon]

	self._icon:set_image(icon.texture, unpack(icon.texture_rect))
	self._progress_bar_foreground_panel:set_w(self._progress_bar_panel:w() * (count / target))

	local progress_text

	if count ~= target then
		progress_text = tostring(count) .. "/" .. tostring(target)

		self._description:set_text(managers.localization:text(challenge_data.challenge_briefing_id, {
			AMOUNT = target,
			WEAPON = managers.localization:text(tweak_data.weapon[challenge_data.weapon_id].name_id),
		}))
	else
		progress_text = utf8.to_upper(managers.localization:text("menu_weapon_challenge_completed"))

		self._description:set_text(managers.localization:text(challenge_data.challenge_done_text_id, {
			AMOUNT = target,
			WEAPON = managers.localization:text(tweak_data.weapon[challenge_data.weapon_id].name_id),
		}))
	end

	self._progress_text:set_text(progress_text)
	self:_fit_size()
end

function HUDNotificationWeaponChallenge:_fit_size()
	local notification_height = HUDNotificationWeaponChallenge.PROGRESS_BAR_DISTANCE_FROM_BOTTOM

	notification_height = notification_height + self._progress_bar_panel:h()

	local _, _, _, h = self._description:text_rect()

	h = math.max(h, self._icon:h())

	self._description:set_h(h)

	notification_height = notification_height + HUDNotificationWeaponChallenge.DESCRIPTION_DISTANCE_FROM_PROGRESS_BAR + h
	notification_height = notification_height + HUDNotificationWeaponChallenge.TITLE_DISTANCE_FROM_DESCRIPTION + self._title:h() + HUDNotificationWeaponChallenge.TITLE_Y

	self._object:set_h(notification_height)
	self._progress_bar_panel:set_bottom(self._object:h() - HUDNotificationWeaponChallenge.PROGRESS_BAR_DISTANCE_FROM_BOTTOM)
	self._description:set_bottom(self._progress_bar_panel:y() - HUDNotificationWeaponChallenge.DESCRIPTION_DISTANCE_FROM_PROGRESS_BAR)
	self._icon:set_y(self._description:y() + 2)
	self._title:set_bottom(self._description:y() - HUDNotificationWeaponChallenge.TITLE_DISTANCE_FROM_DESCRIPTION)
	self._tier:set_center_y(self._title:center_y())
	self._object:set_bottom(self._object:parent():h() - HUDNotification.DEFAULT_DISTANCE_FROM_BOTTOM)
end

function HUDNotification:_animate_show(panel)
	panel:set_alpha(0)

	local t = 0

	while t < 0.75 do
		local dt = coroutine.yield()

		t = t + dt

		if t >= 0.3 and t < 0.7 then
			local curr_alpha = Easing.quintic_in_out(t - 0.3, 0, 1, 0.4)

			panel:set_alpha(curr_alpha)

			local current_x_offset = -(1 - curr_alpha) * HUDNotification.ANIMATION_MOVE_X_DISTANCE

			self._object:set_right(self._initial_right_x + current_x_offset)
		end
	end

	panel:set_alpha(1)
	self._object:set_right(self._initial_right_x)
end

function HUDNotification:_animate_full_progress()
	local t = 0
	local starting_scale = self._object:w() / self._panel_shape_w

	while t < 0.1 do
		local dt = coroutine.yield()

		t = t + dt

		local scale = self:_ease_out_quint(t, starting_scale, 0.75 - starting_scale, 0.1)

		self._object:set_size(self._panel_shape_w * scale, self._panel_shape_h * scale)
		self._object:set_x(self._panel_shape_x + self._panel_shape_w * (1 - scale) * 0.5)
		self._object:set_y(self._panel_shape_y + self._panel_shape_h * (1 - scale) * 0.5)
		self._text:set_font_size(self._font_size * scale)
	end
end

function HUDNotification:_animate_execute()
	local t = 0

	if self._progress < 1 then
		while t < 0.025 do
			local dt = coroutine.yield()

			t = t + dt

			local scale = self:_linear(t, 1, -0.1, 0.025)

			self._object:set_size(self._panel_shape_w * scale, self._panel_shape_h * scale)
			self._object:set_x(self._panel_shape_x + self._panel_shape_w * (1 - scale) * 0.5)
			self._object:set_y(self._panel_shape_y + self._panel_shape_h * (1 - scale) * 0.5)
			self._text:set_font_size(self._font_size * scale)
		end
	end

	self._object:set_size(self._panel_shape_w * 0.6, self._panel_shape_h * 0.6)
	self._object:set_x(self._panel_shape_x + self._panel_shape_w * 0.4 * 0.5)
	self._object:set_y(self._panel_shape_y + self._panel_shape_h * 0.4 * 0.5)
	self._text:set_font_size(self._font_size * 0.6)
	wait(0.03)

	t = 0

	while t < 0.5 do
		local dt = coroutine.yield()

		t = t + dt

		local scale = self:_ease_out_quint(t, 0.6, 0.6, 0.5)

		self._object:set_size(self._panel_shape_w * scale, self._panel_shape_h * scale)
		self._object:set_x(self._panel_shape_x + self._panel_shape_w * (1 - scale) * 0.5)
		self._object:set_y(self._panel_shape_y + self._panel_shape_h * (1 - scale) * 0.5)
		self._text:set_font_size(self._font_size * scale)

		if t >= 0.1 then
			local alpha = self:_ease_out_quint(t - 0.1, 1, -1, 0.3)

			self._object:set_alpha(alpha)
		end
	end

	self._object:set_alpha(0)
	self._hud_panel:remove(self._object)
	managers.queued_tasks:queue("notification_done", managers.notification.notification_done, managers.notification, nil, 0.1, nil, true)
end

function HUDNotification:_animate_cancel()
	local t = 0
	local starting_progress = self._progress

	while t < 0.1 do
		local dt = coroutine.yield()

		t = t + dt

		local progress = self:_ease_out_quint(t, starting_progress, -starting_progress, 0.1)
		local scale = 1 - 0.2 * progress

		self._object:set_size(self._panel_shape_w * scale, self._panel_shape_h * scale)
		self._object:set_x(self._panel_shape_x + self._panel_shape_w * (1 - scale) * 0.5)
		self._object:set_y(self._panel_shape_y + self._panel_shape_h * (1 - scale) * 0.5)
		self._text:set_font_size(self._font_size * scale)

		self._progress = progress
	end

	self._object:set_size(self._panel_shape_w, self._panel_shape_h)

	self._progress = 0

	if managers.notification._delayed_hide then
		managers.queued_tasks:queue("hide_current_notification", managers.notification.hide_current_notification, managers.notification, nil, 0.1, nil, true)
	end
end

function HUDNotification:_animate_hide(panel)
	local t = 0

	while t < 0.75 do
		local dt = coroutine.yield()

		t = t + dt

		if t >= 0.1 and t < 0.6 then
			local curr_alpha = Easing.quintic_in_out(t - 0.1, 1, -1, 0.5)

			panel:set_alpha(curr_alpha)

			local current_x_offset = -(1 - curr_alpha) * HUDNotification.ANIMATION_MOVE_X_DISTANCE

			self._object:set_right(self._initial_right_x + current_x_offset)
		end
	end

	panel:set_alpha(0)
	self:destroy()
	managers.queued_tasks:queue("notification_done", managers.notification.notification_done, managers.notification, nil, 0.1, nil, true)
end

function HUDNotification:_ease_in_quint(t, starting_value, change, duration)
	if duration <= t then
		return starting_value + change
	end

	t = t / duration

	return change * t * t * t * t * t + starting_value
end

function HUDNotification:_ease_out_quint(t, starting_value, change, duration)
	if duration <= t then
		return starting_value + change
	end

	t = t / duration
	t = t - 1

	return change * (t * t * t * t * t + 1) + starting_value
end

function HUDNotification:_ease_in_out_quint(t, starting_value, change, duration)
	if duration <= t then
		return starting_value + change
	end

	t = t / (duration / 2)

	if t < 1 then
		return change / 2 * t * t * t * t * t + starting_value
	end

	t = t - 2

	return change / 2 * (t * t * t * t * t + 2) + starting_value
end

function HUDNotification:_linear(t, starting_value, change, duration)
	if duration <= t then
		return starting_value + change
	end

	return change * t / duration + starting_value
end
