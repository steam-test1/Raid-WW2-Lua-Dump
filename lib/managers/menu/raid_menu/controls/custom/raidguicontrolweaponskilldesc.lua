RaidGUIControlWeaponSkillDesc = RaidGUIControlWeaponSkillDesc or class(RaidGUIControl)
RaidGUIControlWeaponSkillDesc.CONTENT_W = 352
RaidGUIControlWeaponSkillDesc.BUTTON_SPACING = 96
RaidGUIControlWeaponSkillDesc.BUTTON_Y = 23
RaidGUIControlWeaponSkillDesc.BUTTON_HEIGHT = 54
RaidGUIControlWeaponSkillDesc.BUTTON_WIDTH = 40
RaidGUIControlWeaponSkillDesc.LINE_START_X = 36
RaidGUIControlWeaponSkillDesc.LINE_STRIDE = 96
RaidGUIControlWeaponSkillDesc.LINE_Y = 45
RaidGUIControlWeaponSkillDesc.LINE_LENGTH = 64
RaidGUIControlWeaponSkillDesc.LINE_THICKNESS = 3
RaidGUIControlWeaponSkillDesc.STATUS_COLOR = Color("878787")
RaidGUIControlWeaponSkillDesc.CHALLENGE_LOCKED_TEXT = "menu_weapon_challenge_locked"
RaidGUIControlWeaponSkillDesc.CHALLENGE_IN_PROGRESS_TEXT = "menu_weapon_challenge_in_progress"
RaidGUIControlWeaponSkillDesc.CHALLENGE_COMPLETED_TEXT = "menu_weapon_challenge_completed"
RaidGUIControlWeaponSkillDesc.CHALLENGE_LOCKED_DESCRIPTION = "weapon_skill_challenge_locked"

function RaidGUIControlWeaponSkillDesc:init(parent, params)
	RaidGUIControlWeaponSkillDesc.super.init(self, parent, params)

	self._object = self._panel:panel(params)

	self:_create_labels()
	self:_create_progress_bar()
end

function RaidGUIControlWeaponSkillDesc:set_weapon_skill(skill_data)
	local skill = skill_data.value
	local skill_info = tweak_data.weapon_skills.skills[skill.skill_name]
	local name_id = skill_info.name_id

	self._name_label:set_text(self:translate(name_id, true) .. " " .. self:translate("menu_inventory_tier", true) .. " " .. RaidGUIControlButtonWeaponSkill.ROMAN_NUMERALS[skill.tier])

	local desc_id = skill_info.desc_id
	local done_id = ""

	self._desc_label:set_text(self:translate(desc_id, false))

	local challenge, count, target, min_range, max_range

	if skill.challenge_id then
		challenge = managers.challenge:get_challenge(ChallengeManager.CATEGORY_WEAPON_UPGRADE, skill.challenge_id)

		local tasks = challenge:tasks()

		desc_id = skill.challenge_briefing_id or tasks[1]:briefing_id() or desc_id
		done_id = skill.challenge_done_text_id or tasks[1]:done_text_id() or done_id
		count = tasks[1]:current_count()
		target = tasks[1]:target()
		min_range = math.round(tasks[1]:min_range() / 100)
		max_range = math.round(tasks[1]:max_range() / 100)
	end

	self._challenge_locked_label:set_visible(false)
	self._desc_label:set_visible(true)

	if not skill.challenge_unlocked or not managers.weapon_skills:is_weapon_tier_unlocked(skill.weapon_id, skill.tier) then
		self._status_label:set_text(self:translate(RaidGUIControlWeaponSkillDesc.CHALLENGE_LOCKED_TEXT, true))

		local level_needed, class = managers.weapon_skills:get_character_level_needed_for_tier(skill.weapon_id, skill.tier)
		local challenge_locked_text

		if class then
			challenge_locked_text = managers.localization:text("weapon_skill_challenge_unlocked_level_different_class", {
				CLASS = class,
				LEVEL = level_needed,
				TIER = skill.tier,
			})
		else
			challenge_locked_text = managers.localization:text("weapon_skill_challenge_unlocked_level", {
				LEVEL = level_needed,
				TIER = skill.tier,
			})
		end

		self._challenge_locked_label:set_text(utf8.to_upper(challenge_locked_text))

		local _, _, _, h = self._challenge_locked_label:text_rect()

		self._challenge_locked_label:set_h(h)
		self._challenge_locked_label:set_visible(true)
		self._desc_label:set_visible(false)

		local description_text = managers.localization:text(RaidGUIControlWeaponSkillDesc.CHALLENGE_LOCKED_DESCRIPTION, {
			TIER = skill_data.i_tier,
		})

		self._desc_label:set_text(description_text)
		self._progress_bar_panel:set_visible(false)
	elseif skill.challenge_unlocked and not managers.challenge:get_challenge(ChallengeManager.CATEGORY_WEAPON_UPGRADE, skill.challenge_id):completed() then
		self._status_label:set_text(self:translate(RaidGUIControlWeaponSkillDesc.CHALLENGE_IN_PROGRESS_TEXT, true))

		local range = max_range > 0 and max_range or min_range

		self._desc_label:set_text(managers.localization:text(desc_id, {
			AMOUNT = target,
			RANGE = range,
			WEAPON = self:translate(tweak_data.weapon[skill.weapon_id].name_id),
		}))
		self._progress_bar_panel:set_visible(true)
		self:set_progress(count, target)
	elseif managers.challenge:get_challenge(ChallengeManager.CATEGORY_WEAPON_UPGRADE, skill.challenge_id):completed() then
		local range = max_range > 0 and max_range or min_range

		self._status_label:set_text(self:translate(RaidGUIControlWeaponSkillDesc.CHALLENGE_COMPLETED_TEXT, true))
		self._desc_label:set_text(managers.localization:text(done_id, {
			AMOUNT = target,
			RANGE = range,
			WEAPON = self:translate(tweak_data.weapon[skill.weapon_id].name_id),
		}))
		self._progress_bar_panel:set_visible(true)
		self:set_progress(count, target)
	end
end

function RaidGUIControlWeaponSkillDesc:_create_labels()
	local params_name_label = {
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_38,
		h = 38,
		name = self._params.name .. "_name_label",
		text = "UNKNOWN SKILL NAME",
		x = 0,
		y = 0,
	}

	self._name_label = self._object:label(params_name_label)

	local params_status_label = {
		align = "left",
		color = RaidGUIControlWeaponSkillDesc.STATUS_COLOR,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 32,
		name = self._params.name .. "_status_label",
		text = "lol",
		vertical = "bottom",
		w = RaidGUIControlWeaponSkillDesc.CONTENT_W,
		x = 0,
		y = 32,
	}

	self._status_label = self._object:label(params_status_label)

	local params_desc_label = {
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_20,
		h = 100,
		name = self._params.name .. "_desc_label",
		text = "Unknown skill description. Lorem ipsum glupsum tumsum. Kajaznam kolko ovog stane u tri linije mozda jos malo a mozda i ne.",
		w = RaidGUIControlWeaponSkillDesc.CONTENT_W,
		word_wrap = true,
		wrap = true,
		x = 0,
		y = 96,
	}

	self._desc_label = self._object:label(params_desc_label)

	local tier_unlocks_at_level_label_params = {
		align = "left",
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		h = 58,
		layer = 1,
		name = "cant_equip_explenation_label",
		text = "",
		visible = false,
		w = RaidGUIControlWeaponSkillDesc.CONTENT_W,
		wrap = true,
		x = 0,
		y = self._desc_label:y(),
	}

	self._challenge_locked_label = self._object:label(tier_unlocks_at_level_label_params)
end

function RaidGUIControlWeaponSkillDesc:_create_progress_bar()
	local progress_bar_panel_params = {
		h = 32,
		name = self._params.name .. "_progress_bar_panel",
		vertical = "bottom",
		w = RaidGUIControlWeaponSkillDesc.CONTENT_W,
		x = 0,
	}

	self._progress_bar_panel = self._object:panel(progress_bar_panel_params)

	self._progress_bar_panel:set_bottom(self._object:h())

	local texture_center = "slider_large_center"
	local texture_left = "slider_large_left"
	local texture_right = "slider_large_right"
	local progress_bar_background_params = {
		center = texture_center,
		color = Color.white:with_alpha(0.5),
		h = tweak_data.gui:icon_h(texture_center),
		layer = 1,
		left = texture_left,
		name = self._params.name .. "_progress_bar_background",
		right = texture_right,
		w = self._progress_bar_panel:w(),
	}
	local progress_bar_background = self._progress_bar_panel:three_cut_bitmap(progress_bar_background_params)
	local progress_bar_foreground_panel_params = {
		h = self._progress_bar_panel:h(),
		halign = "scale",
		layer = 2,
		name = self._params.name .. "_progress_bar_foreground_panel",
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
		name = self._params.name .. "_progress_bar_background",
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
		name = self._params.name .. "_progress_bar_text",
		text = "123/456",
		vertical = "center",
		w = self._progress_bar_panel:w(),
		x = 0,
		y = -2,
	}

	self._progress_text = self._progress_bar_panel:label(progress_bar_text_params)
end

function RaidGUIControlWeaponSkillDesc:set_progress(count, target)
	self._progress_bar_foreground_panel:set_w(self._progress_bar_panel:w() * (count / target))

	if count ~= target then
		self._progress_text:set_text(tostring(count) .. "/" .. tostring(target))
	else
		self._progress_text:set_text(utf8.to_upper(managers.localization:text("menu_weapon_challenge_completed")))
	end
end

function RaidGUIControlWeaponSkillDesc:on_click_weapon_skill_button()
	return
end

function RaidGUIControlWeaponSkillDesc:on_mouse_enter_weapon_skill_button()
	return
end

function RaidGUIControlWeaponSkillDesc:on_mouse_exit_weapon_skill_button()
	return
end
