HUDTabWeaponChallenge = HUDTabWeaponChallenge or class()
HUDTabWeaponChallenge.WIDTH = 384
HUDTabWeaponChallenge.HEIGHT = 256
HUDTabWeaponChallenge.RIGHT_SIDE_X = 64
HUDTabWeaponChallenge.TITLE_Y = 32
HUDTabWeaponChallenge.TITLE_H = 64
HUDTabWeaponChallenge.TITLE_FONT = tweak_data.gui.fonts.din_compressed
HUDTabWeaponChallenge.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDTabWeaponChallenge.TITLE_COLOR = tweak_data.gui.colors.raid_dirty_white
HUDTabWeaponChallenge.DESCRIPTION_FONT = tweak_data.gui.fonts.lato
HUDTabWeaponChallenge.DESCRIPTION_FONT_SIZE = tweak_data.gui.font_sizes.size_20
HUDTabWeaponChallenge.DESCRIPTION_COLOR = Color("b8b8b8")
HUDTabWeaponChallenge.ANIMATION_MOVE_X_DISTANCE = 30
HUDTabWeaponChallenge.INDEX_BULLET_INACTIVE_ICON = "bullet_empty"
HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON = "bullet_active"
HUDTabWeaponChallenge.INDEX_BULLET_PANEL_W = 96
HUDTabWeaponChallenge.INDEX_BULLET_PADDING = 5

function HUDTabWeaponChallenge:init(panel)
	self:_create_panel(panel)
	self:_create_inner_panel()
	self:_create_index_bullet_panel()
	self:_create_title()
	self:_create_tier_label()
	self:_create_icon()
	self:_create_description()
	self:_create_progress_bar()
end

function HUDTabWeaponChallenge:_create_panel(panel)
	local panel_params = {
		h = HUDTabWeaponChallenge.HEIGHT,
		halign = "left",
		name = "weapon_challenge_panel",
		valign = "bottom",
		w = HUDTabWeaponChallenge.WIDTH + HUDTabWeaponChallenge.ANIMATION_MOVE_X_DISTANCE,
	}

	self._object = panel:panel(panel_params)
	self._initial_x_position = self._object:x()
end

function HUDTabWeaponChallenge:_create_inner_panel()
	local inner_panel_params = {
		halign = "grow",
		name = "weapon_challenge_inner_panel",
		valign = "grow",
		w = self._object:w() - HUDTabWeaponChallenge.ANIMATION_MOVE_X_DISTANCE,
	}

	self._inner_panel = self._object:panel(inner_panel_params)
end

function HUDTabWeaponChallenge:_create_index_bullet_panel()
	local index_bullet_panel_params = {
		h = 32,
		halign = "right",
		name = "index_bullet_panel",
		valign = "top",
		w = HUDTabWeaponChallenge.INDEX_BULLET_PANEL_W,
	}

	self._index_bullet_panel = self._object:panel(index_bullet_panel_params)

	self._index_bullet_panel:set_right(self._object:w() - HUDTabWeaponChallenge.ANIMATION_MOVE_X_DISTANCE)
end

function HUDTabWeaponChallenge:_create_title()
	local title_params = {
		align = "left",
		color = HUDTabWeaponChallenge.TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabWeaponChallenge.TITLE_FONT, HUDTabWeaponChallenge.TITLE_FONT_SIZE),
		font_size = HUDTabWeaponChallenge.TITLE_FONT_SIZE,
		h = HUDTabWeaponChallenge.TITLE_H,
		name = "weapon_challenge_title",
		text = "INCREASE ACCURACY",
		vertical = "center",
		w = self._inner_panel:w() - HUDTabWeaponChallenge.RIGHT_SIDE_X,
		x = HUDTabWeaponChallenge.RIGHT_SIDE_X,
		y = HUDTabWeaponChallenge.TITLE_Y,
	}

	self._title = self._inner_panel:text(title_params)
end

function HUDTabWeaponChallenge:_create_tier_label()
	local tier_label_params = {
		align = "left",
		color = HUDTabWeaponChallenge.TITLE_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabWeaponChallenge.TITLE_FONT, HUDTabWeaponChallenge.TITLE_FONT_SIZE),
		font_size = HUDTabWeaponChallenge.TITLE_FONT_SIZE,
		h = HUDTabWeaponChallenge.TITLE_H,
		name = "weapon_challenge_tier",
		text = "TI",
		vertical = "center",
		y = HUDTabWeaponChallenge.TITLE_Y,
	}

	self._tier = self._inner_panel:text(tier_label_params)
end

function HUDTabWeaponChallenge:_create_icon()
	local default_icon = "wpn_skill_accuracy"
	local icon_params = {
		name = "weapon_challenge_icon",
		texture = tweak_data.gui.icons[default_icon].texture,
		texture_rect = tweak_data.gui.icons[default_icon].texture_rect,
		y = HUDTabWeaponChallenge.TITLE_Y + HUDTabWeaponChallenge.TITLE_H,
	}

	self._icon = self._inner_panel:bitmap(icon_params)
end

function HUDTabWeaponChallenge:_create_description()
	local description_params = {
		color = HUDTabWeaponChallenge.DESCRIPTION_COLOR,
		font = tweak_data.gui:get_font_path(HUDTabWeaponChallenge.DESCRIPTION_FONT, HUDTabWeaponChallenge.DESCRIPTION_FONT_SIZE),
		font_size = HUDTabWeaponChallenge.DESCRIPTION_FONT_SIZE,
		name = "weapon_challenge_description",
		text = "Bla bla bla bla",
		w = self._inner_panel:w() - HUDTabWeaponChallenge.RIGHT_SIDE_X,
		wrap = true,
		x = HUDTabWeaponChallenge.RIGHT_SIDE_X,
		y = HUDTabWeaponChallenge.TITLE_Y + HUDTabWeaponChallenge.TITLE_H,
	}

	self._description = self._inner_panel:text(description_params)
end

function HUDTabWeaponChallenge:_create_progress_bar()
	local texture_center = "slider_large_center"
	local texture_left = "slider_large_left"
	local texture_right = "slider_large_right"
	local progress_bar_panel_params = {
		h = tweak_data.gui:icon_h(texture_center),
		is_root_panel = true,
		name = "weapon_challenge_progress_bar_panel",
		vertical = "bottom",
		w = self._inner_panel:w(),
		x = 0,
	}

	self._progress_bar_panel = RaidGUIPanel:new(self._inner_panel, progress_bar_panel_params)

	self._progress_bar_panel:set_center_y(self._inner_panel:h() - 32)

	local progress_bar_background_params = {
		center = texture_center,
		color = Color.white:with_alpha(0.5),
		h = tweak_data.gui:icon_h(texture_center),
		layer = 1,
		left = texture_left,
		name = "weapon_challenge_progress_bar_background",
		right = texture_right,
		w = self._progress_bar_panel:w(),
	}
	local progress_bar_background = self._progress_bar_panel:three_cut_bitmap(progress_bar_background_params)
	local progress_bar_foreground_panel_params = {
		h = self._progress_bar_panel:h(),
		halign = "scale",
		layer = 2,
		name = "weapon_challenge_progress_bar_foreground_panel",
		valign = "scale",
		w = self._progress_bar_panel:w(),
		x = 0,
		y = 0,
	}

	self._progress_bar_foreground_panel = self._progress_bar_panel:panel(progress_bar_foreground_panel_params)

	local progress_bar_background_params = {
		center = texture_center,
		color = tweak_data.gui.colors.raid_red,
		h = tweak_data.gui:icon_h(texture_center),
		left = texture_left,
		name = "weapon_challenge_progress_bar_background",
		right = texture_right,
		w = self._progress_bar_panel:w(),
	}
	local progress_bar_background = self._progress_bar_foreground_panel:three_cut_bitmap(progress_bar_background_params)
	local progress_bar_text_params = {
		align = "center",
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = self._progress_bar_panel:h(),
		layer = 5,
		name = "weapon_challenge_progress_bar_text",
		text = "123/456",
		vertical = "center",
		w = self._progress_bar_panel:w(),
		x = 0,
		y = -2,
	}

	self._progress_text = self._progress_bar_panel:label(progress_bar_text_params)
end

function HUDTabWeaponChallenge:set_challenges(challenges)
	self._challenges = challenges

	self:_create_challenge_bullets()
	self:set_challenge(1)
end

function HUDTabWeaponChallenge:_create_challenge_bullets()
	self._index_bullet_panel:clear()

	self._active_bullets = {}
	self._inactive_bullets = {}

	for i = #self._challenges, 1, -1 do
		local inactive_bullet_params = {
			layer = self._index_bullet_panel:layer() + 1,
			texture = tweak_data.gui.icons[HUDTabWeaponChallenge.INDEX_BULLET_INACTIVE_ICON].texture,
			texture_rect = tweak_data.gui.icons[HUDTabWeaponChallenge.INDEX_BULLET_INACTIVE_ICON].texture_rect,
			x = self._index_bullet_panel:w() - tweak_data.gui:icon_w(HUDTabWeaponChallenge.INDEX_BULLET_INACTIVE_ICON) * i - HUDTabWeaponChallenge.INDEX_BULLET_PADDING * (i - 1),
			y = self._index_bullet_panel:h() / 2 - tweak_data.gui:icon_h(HUDTabWeaponChallenge.INDEX_BULLET_INACTIVE_ICON) / 2,
		}
		local inactive_bullet = self._index_bullet_panel:bitmap(inactive_bullet_params)

		table.insert(self._inactive_bullets, inactive_bullet)

		local active_bullet_params = {
			alpha = 0,
			layer = inactive_bullet:layer() + 1,
			texture = tweak_data.gui.icons[HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON].texture,
			texture_rect = tweak_data.gui.icons[HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON].texture_rect,
		}
		local active_bullet = self._index_bullet_panel:bitmap(active_bullet_params)

		active_bullet:set_center(inactive_bullet:center())
		table.insert(self._active_bullets, active_bullet)
	end
end

function HUDTabWeaponChallenge:set_challenge(index, animate)
	if self._currently_shown_challenge == index then
		animate = false
	end

	if animate then
		self._object:stop()
		self._object:animate(callback(self, self, "_animate_data_change"), index)
	else
		self:_set_challenge(index)

		for index, bullet in pairs(self._active_bullets) do
			bullet:set_alpha(0)
		end

		self._active_bullets[index]:set_alpha(1)
	end
end

function HUDTabWeaponChallenge:_set_challenge(challenge_index)
	local challenge, count, target, min_range, max_range, briefing_id
	local challenge_data = self._challenges[challenge_index]

	if challenge_data.challenge_id then
		challenge = managers.challenge:get_challenge(ChallengeManager.CATEGORY_WEAPON_UPGRADE, challenge_data.challenge_id)

		local tasks = challenge:tasks()

		briefing_id = tasks[1]:briefing_id()
		count = tasks[1]:current_count()
		target = tasks[1]:target()
		min_range = math.round(tasks[1]:min_range() / 100)
		max_range = math.round(tasks[1]:max_range() / 100)
	end

	briefing_id = briefing_id or challenge_data.challenge_briefing_id

	local skill_tweak_data = tweak_data.weapon_skills.skills[challenge_data.skill_name]

	self._title:set_text(utf8.to_upper(managers.localization:text(skill_tweak_data.name_id)))

	local range = max_range > 0 and max_range or min_range

	self._description:set_text(managers.localization:text(briefing_id, {
		AMOUNT = target,
		RANGE = range,
		WEAPON = managers.localization:text(tweak_data.weapon[challenge_data.weapon_id].name_id),
	}))

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
	else
		progress_text = utf8.to_upper(managers.localization:text("menu_weapon_challenge_completed"))
	end

	self._progress_text:set_text(progress_text)

	self._currently_shown_challenge = challenge_index
end

function HUDTabWeaponChallenge:set_x(x)
	self._object:set_x(x)

	self._initial_x_position = self._object:x()
end

function HUDTabWeaponChallenge:set_y(y)
	self._object:set_y(y)
end

function HUDTabWeaponChallenge:set_bottom(y)
	self._object:set_bottom(y)
end

function HUDTabWeaponChallenge:set_top(y)
	self._object:set_top(y)
end

function HUDTabWeaponChallenge:set_left(x)
	self._object:set_left(x)

	self._initial_x_position = self._object:x()
end

function HUDTabWeaponChallenge:set_right(x)
	self._object:set_right(x)

	self._initial_x_position = self._object:x()
end

function HUDTabWeaponChallenge:set_center_x(x)
	self._object:set_center_x(x)

	self._initial_x_position = self._object:x()
end

function HUDTabWeaponChallenge:set_center_y(y)
	self._object:set_center_y(y)
end

function HUDTabWeaponChallenge:show()
	self._object:set_visible(true)
end

function HUDTabWeaponChallenge:hide()
	self._object:set_visible(false)
end

function HUDTabWeaponChallenge:_animate_data_change(panel, challenge_data)
	local fade_out_duration = 0.3
	local fade_in_duration = 0.3
	local t = (1 - self._inner_panel:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in(t, 1, -1, fade_out_duration)

		self._inner_panel:set_alpha(current_alpha)
		self._active_bullets[self._currently_shown_challenge]:set_w(current_alpha * tweak_data.gui:icon_w(HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON))
		self._active_bullets[self._currently_shown_challenge]:set_h(current_alpha * tweak_data.gui:icon_h(HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON))
		self._active_bullets[self._currently_shown_challenge]:set_center(self._inactive_bullets[self._currently_shown_challenge]:center())

		local current_position = Easing.quartic_in(t, 0, HUDTabWeaponChallenge.ANIMATION_MOVE_X_DISTANCE, fade_out_duration)

		current_position = math.round(current_position)

		self._inner_panel:set_x(current_position)
	end

	self._inner_panel:set_alpha(0)
	self._inner_panel:set_x(HUDTabWeaponChallenge.ANIMATION_MOVE_X_DISTANCE)
	self._active_bullets[self._currently_shown_challenge]:set_alpha(0)
	self._active_bullets[self._currently_shown_challenge]:set_w(tweak_data.gui:icon_w(HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON))
	self._active_bullets[self._currently_shown_challenge]:set_h(tweak_data.gui:icon_h(HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON))
	self._active_bullets[self._currently_shown_challenge]:set_center(self._inactive_bullets[self._currently_shown_challenge]:center())
	self:_set_challenge(challenge_data)
	self._active_bullets[self._currently_shown_challenge]:set_alpha(1)
	self._active_bullets[self._currently_shown_challenge]:set_w(0)
	self._active_bullets[self._currently_shown_challenge]:set_h(0)
	self._active_bullets[self._currently_shown_challenge]:set_center(self._inactive_bullets[self._currently_shown_challenge]:center())
	wait(0.2)

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_out(t, 0, 1, fade_in_duration)

		self._inner_panel:set_alpha(current_alpha)
		self._active_bullets[self._currently_shown_challenge]:set_w(current_alpha * tweak_data.gui:icon_w(HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON))
		self._active_bullets[self._currently_shown_challenge]:set_h(current_alpha * tweak_data.gui:icon_h(HUDTabWeaponChallenge.INDEX_BULLET_ACTIVE_ICON))
		self._active_bullets[self._currently_shown_challenge]:set_center(self._inactive_bullets[self._currently_shown_challenge]:center())

		local current_position = Easing.quartic_out(t, HUDTabWeaponChallenge.ANIMATION_MOVE_X_DISTANCE, -HUDTabWeaponChallenge.ANIMATION_MOVE_X_DISTANCE, fade_in_duration)

		current_position = math.round(current_position)

		self._inner_panel:set_x(current_position)
	end

	self._inner_panel:set_alpha(1)
	self._inner_panel:set_x(0)
end
