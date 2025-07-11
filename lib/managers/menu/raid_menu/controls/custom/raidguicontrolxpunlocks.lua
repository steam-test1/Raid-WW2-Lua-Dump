RaidGUIControlXPSkillSet = RaidGUIControlXPSkillSet or class(RaidGUIControl)
RaidGUIControlXPSkillSet.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_76
RaidGUIControlXPSkillSet.TITLE_COLOR = tweak_data.gui.colors.raid_red
RaidGUIControlXPSkillSet.FLAVOR_TEXT_FONT_SIZE = tweak_data.gui.font_sizes.size_32
RaidGUIControlXPSkillSet.FLAVOR_TEXT_COLOR = tweak_data.gui.colors.raid_white
RaidGUIControlXPSkillSet.TEXT_H = 79
RaidGUIControlXPSkillSet.FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlXPSkillSet.SINGLE_ICON_CENTER_Y = 208
RaidGUIControlXPSkillSet.ICON_CENTER_Y = 208
RaidGUIControlXPSkillSet.DOUBLE_ICON_SCALE = 0.8
RaidGUIControlXPSkillSet.DOUBLE_ICON_DISTANCE = 444
RaidGUIControlXPSkillSet.TRIPLE_ICON_SCALE = 0.6
RaidGUIControlXPSkillSet.TRIPLE_ICON_DISTANCE = 260

function RaidGUIControlXPSkillSet:init(parent)
	self:_create_panel(parent)
	self:_create_content_panel()
	self:_create_icon_panel()
	self:_create_text()
end

function RaidGUIControlXPSkillSet:_create_panel(parent)
	local panel_params = {
		halign = "scale",
		name = "skill_set_unlock_panel",
		valign = "scale",
		visible = false,
	}

	self._object = parent:panel(panel_params)
end

function RaidGUIControlXPSkillSet:_create_content_panel()
	local panel_params = {
		alpha = 0,
		halign = "scale",
		name = "content_panel",
		valign = "scale",
	}

	self._content_panel = self._object:panel(panel_params)
end

function RaidGUIControlXPSkillSet:_create_icon_panel()
	local icon_panel_params = {
		halign = "scale",
		name = "icon_panel",
		valign = "scale",
	}

	self._icon_panel = self._content_panel:panel(icon_panel_params)
end

function RaidGUIControlXPSkillSet:_create_text()
	local title_text_params = {
		align = "center",
		color = RaidGUIControlXPSkillSet.TITLE_COLOR,
		font = RaidGUIControlXPSkillSet.FONT,
		font_size = RaidGUIControlXPSkillSet.TITLE_FONT_SIZE,
		h = RaidGUIControlXPSkillSet.TEXT_H,
		name = "skill_set_unlock_title_text",
		text = utf8.to_upper(managers.localization:text("menu_skill_set_unlocked", {
			LEVEL = tostring(1),
		})),
		vertical = "center",
	}
	local title = self._content_panel:text(title_text_params)
	local _, _, w, _ = title:text_rect()

	title:set_w(w)
	title:set_bottom(self._content_panel:h())
	title:set_center_x(self._content_panel:w() / 2)

	local flavor_text_params = {
		align = "center",
		color = RaidGUIControlXPSkillSet.FLAVOR_TEXT_COLOR,
		font = RaidGUIControlXPSkillSet.FONT,
		font_size = RaidGUIControlXPSkillSet.FLAVOR_TEXT_FONT_SIZE,
		h = RaidGUIControlXPSkillSet.TEXT_H,
		name = "skill_set_unlock_flavor_text",
		text = self:translate("menu_congratulations", true),
		vertical = "center",
	}
	local flavor_text = self._content_panel:text(flavor_text_params)
	local _, _, w, _ = flavor_text:text_rect()

	flavor_text:set_w(w)
	flavor_text:set_bottom(title:y())
	flavor_text:set_x(title:x())
end

function RaidGUIControlXPSkillSet:set_level(level)
	local title = self._content_panel:child("skill_set_unlock_title_text")

	title:set_text(utf8.to_upper(managers.localization:text("menu_skill_set_unlocked", {
		LEVEL = tostring(level),
	})))

	local _, _, w, _ = title:text_rect()

	title:set_w(w)
	title:set_bottom(self._content_panel:h())
	title:set_center_x(self._content_panel:w() / 2)

	local flavor_text = self._content_panel:child("skill_set_unlock_flavor_text")

	flavor_text:set_bottom(title:y())
	flavor_text:set_x(title:x())

	local character_class = managers.skilltree:get_character_profile_class()
	local skills_organised = tweak_data.skilltree:get_skills_organised(character_class)
	local level_skills = {}

	for type, entries in ipairs(skills_organised) do
		for skill_id, skill in pairs(entries) do
			if skill.level_required and skill.level_required == level then
				level_skills[skill_id] = skill
			end
		end
	end

	if next(level_skills) then
		self._content_panel:get_engine_panel():stop()
		self._content_panel:get_engine_panel():animate(callback(self, self, "_animate_skill_change"), level_skills)
	end
end

function RaidGUIControlXPSkillSet:_create_icons(skills)
	local icons = {}

	for skill_id, skill in pairs(skills) do
		if #icons >= 3 then
			break
		end

		local icon_id = tweak_data.skilltree:get_skill_icon_tiered(skill_id)
		local gui_data = tweak_data.gui:get_full_gui_data(icon_id)
		local icon = self._icon_panel:bitmap({
			blend_mode = "add",
			color = tweak_data.gui.colors.raid_white,
			name = "skill_" .. tostring(skill.name_id) .. "_icon",
			texture = gui_data.texture,
			texture_rect = gui_data.texture_rect,
		})

		table.insert(icons, icon)
	end

	if #icons == 1 then
		icons[1]:set_center_x(self._icon_panel:w() / 2)
		icons[1]:set_center_y(self.ICON_CENTER_Y)
	elseif #icons == 2 then
		icons[1]:set_w(icons[1]:w() * self.DOUBLE_ICON_SCALE)
		icons[1]:set_h(icons[1]:h() * self.DOUBLE_ICON_SCALE)
		icons[1]:set_center_x(self._icon_panel:w() / 2 - self.DOUBLE_ICON_DISTANCE / 2)
		icons[1]:set_center_y(self.ICON_CENTER_Y)
		icons[2]:set_w(icons[2]:w() * self.DOUBLE_ICON_SCALE)
		icons[2]:set_h(icons[2]:h() * self.DOUBLE_ICON_SCALE)
		icons[2]:set_center_x(self._icon_panel:w() / 2 + self.DOUBLE_ICON_DISTANCE / 2)
		icons[2]:set_center_y(self.ICON_CENTER_Y)
	elseif #icons == 3 then
		icons[1]:set_w(icons[1]:w() * self.TRIPLE_ICON_SCALE)
		icons[1]:set_h(icons[1]:h() * self.TRIPLE_ICON_SCALE)
		icons[1]:set_center_x(self._icon_panel:w() / 2 - self.TRIPLE_ICON_DISTANCE)
		icons[1]:set_center_y(self.ICON_CENTER_Y)
		icons[2]:set_w(icons[2]:w() * self.TRIPLE_ICON_SCALE)
		icons[2]:set_h(icons[2]:h() * self.TRIPLE_ICON_SCALE)
		icons[2]:set_center_x(self._icon_panel:w() / 2)
		icons[2]:set_center_y(self.ICON_CENTER_Y)
		icons[3]:set_w(icons[3]:w() * self.TRIPLE_ICON_SCALE)
		icons[3]:set_h(icons[3]:h() * self.TRIPLE_ICON_SCALE)
		icons[3]:set_center_x(self._icon_panel:w() / 2 + self.TRIPLE_ICON_DISTANCE)
		icons[3]:set_center_y(self.ICON_CENTER_Y)
	end
end

function RaidGUIControlXPSkillSet:_animate_skill_change(panel, skills)
	local fade_out_duration = 0.25
	local fade_in_duration = 0.3
	local t = (1 - self._content_panel:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 1, -1, fade_out_duration)

		self._content_panel:set_alpha(current_alpha)
	end

	self._content_panel:set_alpha(0)
	self._icon_panel:clear()
	self:_create_icons(skills)

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 1, fade_in_duration)

		self._content_panel:set_alpha(current_alpha)
	end

	self._content_panel:set_alpha(1)
end

RaidGUIControlXPDoubleUnlock = RaidGUIControlXPDoubleUnlock or class(RaidGUIControl)
RaidGUIControlXPDoubleUnlock.TITLE_CENTER_Y = 144
RaidGUIControlXPDoubleUnlock.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_76
RaidGUIControlXPDoubleUnlock.TITLE_COLOR = tweak_data.gui.colors.raid_red
RaidGUIControlXPDoubleUnlock.SUBTITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_56
RaidGUIControlXPDoubleUnlock.SUBTITLE_COLOR = tweak_data.gui.colors.raid_red
RaidGUIControlXPDoubleUnlock.FLAVOR_TEXT_FONT_SIZE = tweak_data.gui.font_sizes.size_32
RaidGUIControlXPDoubleUnlock.FLAVOR_TEXT_COLOR = tweak_data.gui.colors.raid_white
RaidGUIControlXPDoubleUnlock.TEXT_H = 79
RaidGUIControlXPDoubleUnlock.FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlXPDoubleUnlock.CONTENT_PANELS_Y = 192
RaidGUIControlXPDoubleUnlock.CONTENT_PANELS_H = 320
RaidGUIControlXPDoubleUnlock.ICON_CENTER_Y = 128
RaidGUIControlXPDoubleUnlock.SINGLE_ICON_SCALE = 0.6
RaidGUIControlXPDoubleUnlock.DOUBLE_ICON_SCALE = 0.43
RaidGUIControlXPDoubleUnlock.DOUBLE_ICON_DISTANCE = 184
RaidGUIControlXPDoubleUnlock.TRIPLE_ICON_SCALE = 0.33
RaidGUIControlXPDoubleUnlock.TRIPLE_ICON_DISTANCE = 148

function RaidGUIControlXPDoubleUnlock:init(parent)
	self:_create_panel(parent)
	self:_create_skill_panel()
	self:_create_weapon_panel()
	self:_create_title_text()
end

function RaidGUIControlXPDoubleUnlock:_create_panel(parent)
	local panel_params = {
		halign = "scale",
		name = "skill_set_unlock_panel",
		valign = "scale",
		visible = false,
	}

	self._object = parent:panel(panel_params)
end

function RaidGUIControlXPDoubleUnlock:_create_weapon_panel()
	local weapon_panel_params = {
		alpha = 0,
		h = RaidGUIControlXPDoubleUnlock.CONTENT_PANELS_H,
		halign = "scale",
		name = "weapon_panel",
		valign = "scale",
		w = self._object:w() / 2,
		y = RaidGUIControlXPDoubleUnlock.CONTENT_PANELS_Y,
	}

	self._weapon_panel = self._object:panel(weapon_panel_params)

	local weapon_icon_panel_params = {
		halign = "scale",
		name = "weapon_icon_panel",
		valign = "scale",
	}

	self._weapon_icon_panel = self._weapon_panel:panel(weapon_icon_panel_params)

	local weapon_name_params = {
		align = "center",
		color = RaidGUIControlXPDoubleUnlock.SUBTITLE_COLOR,
		font = RaidGUIControlXPDoubleUnlock.FONT,
		font_size = RaidGUIControlXPDoubleUnlock.SUBTITLE_FONT_SIZE,
		h = RaidGUIControlXPDoubleUnlock.TEXT_H,
		name = "weapon_name",
		text = "",
		vertical = "center",
	}

	self._weapon_name = self._weapon_panel:text(weapon_name_params)

	self._weapon_name:set_center_x(self._weapon_panel:w() / 2)
	self._weapon_name:set_bottom(self._weapon_panel:h())
end

function RaidGUIControlXPDoubleUnlock:_create_skill_panel()
	local skill_panel_params = {
		alpha = 0,
		h = RaidGUIControlXPDoubleUnlock.CONTENT_PANELS_H,
		halign = "scale",
		name = "skill_panel",
		valign = "scale",
		w = self._object:w() / 2,
		x = self._object:w() / 2,
		y = RaidGUIControlXPDoubleUnlock.CONTENT_PANELS_Y,
	}

	self._skill_panel = self._object:panel(skill_panel_params)

	local skill_icon_panel_params = {
		halign = "scale",
		name = "skill_icon_panel",
		valign = "scale",
	}

	self._skill_icon_panel = self._skill_panel:panel(skill_icon_panel_params)

	local skill_set_title_params = {
		align = "center",
		color = RaidGUIControlXPDoubleUnlock.SUBTITLE_COLOR,
		font = RaidGUIControlXPDoubleUnlock.FONT,
		font_size = RaidGUIControlXPDoubleUnlock.SUBTITLE_FONT_SIZE,
		h = RaidGUIControlXPDoubleUnlock.TEXT_H,
		name = "skill_set_title",
		text = "",
		vertical = "center",
	}

	self._skill_set_title = self._skill_panel:text(skill_set_title_params)

	self._skill_set_title:set_center_x(self._skill_panel:w() / 2)
	self._skill_set_title:set_bottom(self._skill_panel:h())
end

function RaidGUIControlXPDoubleUnlock:_create_title_text()
	local title_text_params = {
		align = "center",
		color = RaidGUIControlXPDoubleUnlock.TITLE_COLOR,
		font = RaidGUIControlXPDoubleUnlock.FONT,
		font_size = RaidGUIControlXPDoubleUnlock.TITLE_FONT_SIZE,
		h = RaidGUIControlXPDoubleUnlock.TEXT_H,
		name = "skill_set_unlock_title_text",
		text = self:translate("menu_double_unlock", true),
		vertical = "center",
	}
	local title = self._object:text(title_text_params)
	local _, _, w, _ = title:text_rect()

	title:set_w(w)
	title:set_center_y(RaidGUIControlXPDoubleUnlock.TITLE_CENTER_Y)
	title:set_center_x(self._object:w() / 2)

	local flavor_text_params = {
		align = "center",
		color = RaidGUIControlXPDoubleUnlock.FLAVOR_TEXT_COLOR,
		font = RaidGUIControlXPDoubleUnlock.FONT,
		font_size = RaidGUIControlXPDoubleUnlock.FLAVOR_TEXT_FONT_SIZE,
		h = RaidGUIControlXPDoubleUnlock.TEXT_H,
		name = "skill_set_unlock_flavor_text",
		text = self:translate("menu_congratulations", true),
		vertical = "center",
	}
	local flavor_text = self._object:text(flavor_text_params)
	local _, _, w, _ = flavor_text:text_rect()

	flavor_text:set_w(w)
	flavor_text:set_bottom(title:y())
	flavor_text:set_x(title:x())
end

function RaidGUIControlXPDoubleUnlock:set_level(level)
	self._skill_set_title:set_text(utf8.to_upper(managers.localization:text("menu_skill_set_title", {
		LEVEL = tostring(level),
	})))

	local character_class = managers.skilltree:get_character_profile_class()
	local skills_organised = tweak_data.skilltree:get_skills_organised(character_class)
	local level_skills = {}

	for type, entries in ipairs(skills_organised) do
		for skill_id, skill in pairs(entries) do
			if skill.level_required and skill.level_required == level then
				level_skills[skill_id] = skill
			end
		end
	end

	if next(level_skills) then
		self._skill_panel:get_engine_panel():stop()
		self._skill_panel:get_engine_panel():animate(callback(self, self, "_animate_skill_change"), level_skills)
	end

	local weapon_unlock_progression = tweak_data.skilltree.automatic_unlock_progressions[character_class]

	if weapon_unlock_progression[level] and weapon_unlock_progression[level].weapons then
		self._weapon_panel:get_engine_panel():stop()
		self._weapon_panel:get_engine_panel():animate(callback(self, self, "_animate_weapon_change"), weapon_unlock_progression[level])
	end
end

function RaidGUIControlXPDoubleUnlock:_create_skill_icons(skills)
	local icons = {}

	for skill_id, skill in pairs(skills) do
		if #icons >= 3 then
			break
		end

		local icon_id = tweak_data.skilltree:get_skill_icon_tiered(skill_id)
		local gui_data = tweak_data.gui:get_full_gui_data(icon_id)
		local icon = self._skill_icon_panel:bitmap({
			blend_mode = "add",
			color = tweak_data.gui.colors.raid_white,
			name = "skill_" .. tostring(skill.name_id) .. "_icon",
			texture = gui_data.texture,
			texture_rect = gui_data.texture_rect,
		})

		table.insert(icons, icon)
	end

	if #icons == 1 then
		icons[1]:set_w(icons[1]:w() * self.SINGLE_ICON_SCALE)
		icons[1]:set_h(icons[1]:h() * self.SINGLE_ICON_SCALE)
		icons[1]:set_center_x(self._skill_icon_panel:w() / 2)
		icons[1]:set_center_y(self.ICON_CENTER_Y)
	elseif #icons == 2 then
		icons[1]:set_w(icons[1]:w() * self.DOUBLE_ICON_SCALE)
		icons[1]:set_h(icons[1]:h() * self.DOUBLE_ICON_SCALE)
		icons[1]:set_center_x(self._skill_icon_panel:w() / 2 - self.DOUBLE_ICON_DISTANCE / 2)
		icons[1]:set_center_y(self.ICON_CENTER_Y)
		icons[2]:set_w(icons[2]:w() * self.DOUBLE_ICON_SCALE)
		icons[2]:set_h(icons[2]:h() * self.DOUBLE_ICON_SCALE)
		icons[2]:set_center_x(self._skill_icon_panel:w() / 2 + self.DOUBLE_ICON_DISTANCE / 2)
		icons[2]:set_center_y(self.ICON_CENTER_Y)
	elseif #icons == 3 then
		icons[1]:set_w(icons[1]:w() * self.TRIPLE_ICON_SCALE)
		icons[1]:set_h(icons[1]:h() * self.TRIPLE_ICON_SCALE)
		icons[1]:set_center_x(self._skill_icon_panel:w() / 2 - self.TRIPLE_ICON_DISTANCE)
		icons[1]:set_center_y(self.ICON_CENTER_Y)
		icons[2]:set_w(icons[2]:w() * self.TRIPLE_ICON_SCALE)
		icons[2]:set_h(icons[2]:h() * self.TRIPLE_ICON_SCALE)
		icons[2]:set_center_x(self._skill_icon_panel:w() / 2)
		icons[2]:set_center_y(self.ICON_CENTER_Y)
		icons[3]:set_w(icons[3]:w() * self.TRIPLE_ICON_SCALE)
		icons[3]:set_h(icons[3]:h() * self.TRIPLE_ICON_SCALE)
		icons[3]:set_center_x(self._skill_icon_panel:w() / 2 + self.TRIPLE_ICON_DISTANCE)
		icons[3]:set_center_y(self.ICON_CENTER_Y)
	end
end

function RaidGUIControlXPDoubleUnlock:_create_weapon_icons(weapon_unlocks)
	local weapon_skill_unlock = weapon_unlocks.weapons[1]
	local weapon_tweak_data = tweak_data.weapon[tweak_data.skilltree.skills[weapon_skill_unlock].upgrades[1]]
	local gui_data = tweak_data.gui:get_full_gui_data(weapon_tweak_data.gui.icon_large)
	local icon = self._weapon_icon_panel:bitmap({
		name = "weapon_icon",
		texture = gui_data.texture,
		texture_rect = gui_data.texture_rect,
	})

	icon:set_center(self._weapon_icon_panel:w() / 2, self.ICON_CENTER_Y)
	self._weapon_name:set_text(self:translate(weapon_tweak_data.name_id, true))

	local _, _, w, _ = self._weapon_name:text_rect()

	if w > self._weapon_name:w() then
		self:_refit_title_text(self._weapon_name, self._weapon_name:font_size())
	end
end

function RaidGUIControlXPDoubleUnlock:_animate_skill_change(skill_panel, skills)
	local fade_out_duration = 0.25
	local fade_in_duration = 0.3
	local t = (1 - self._skill_panel:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 1, -1, fade_out_duration)

		self._skill_panel:set_alpha(current_alpha)
	end

	self._skill_panel:set_alpha(0)
	self._skill_icon_panel:clear()
	self:_create_skill_icons(skills)

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 1, fade_in_duration)

		self._skill_panel:set_alpha(current_alpha)
	end

	self._skill_panel:set_alpha(1)
end

function RaidGUIControlXPDoubleUnlock:_animate_weapon_change(weapon_panel, weapon_unlocks)
	local fade_out_duration = 0.25
	local fade_in_duration = 0.3
	local t = (1 - self._weapon_panel:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 1, -1, fade_out_duration)

		self._weapon_panel:set_alpha(current_alpha)
	end

	self._weapon_panel:set_alpha(0)
	self._weapon_icon_panel:clear()
	self:_create_weapon_icons(weapon_unlocks)

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 1, fade_in_duration)

		self._weapon_panel:set_alpha(current_alpha)
	end

	self._weapon_panel:set_alpha(1)
end

function RaidGUIControlXPDoubleUnlock:_refit_title_text(title_control, original_font_size)
	local font_sizes = {}

	for index, size in pairs(tweak_data.gui.font_sizes) do
		if size < original_font_size then
			table.insert(font_sizes, size)
		end
	end

	table.sort(font_sizes)

	for i = #font_sizes, 1, -1 do
		title_control:set_font_size(font_sizes[i])

		local _, _, w, h = title_control:text_rect()

		if h <= title_control:h() and w <= title_control:w() then
			break
		end
	end
end
