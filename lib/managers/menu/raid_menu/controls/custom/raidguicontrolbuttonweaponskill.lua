RaidGUIControlButtonWeaponSkill = RaidGUIControlButtonWeaponSkill or class(RaidGUIControlButton)
RaidGUIControlButtonWeaponSkill.STATE_NORMAL = "state_normal"
RaidGUIControlButtonWeaponSkill.STATE_CHALLENGE_ACTIVE = "state_challenge_active"
RaidGUIControlButtonWeaponSkill.STATE_SELECTED = "state_selected"
RaidGUIControlButtonWeaponSkill.STATE_ACTIVE = "state_active"
RaidGUIControlButtonWeaponSkill.STATE_BLOCKED = "state_blocked"
RaidGUIControlButtonWeaponSkill.STATE_UNAVAILABLE = "state_unavailable"
RaidGUIControlButtonWeaponSkill.STATE_HOVER = "state_hover"
RaidGUIControlButtonWeaponSkill.STATE_INVISIBLE = "state_invisible"
RaidGUIControlButtonWeaponSkill.TIER_MARKER_X = 33
RaidGUIControlButtonWeaponSkill.TIER_MARKER_Y = 46
RaidGUIControlButtonWeaponSkill.ICON = "wpn_skill_blank"
RaidGUIControlButtonWeaponSkill.ICON_SELECTED = "wpn_skill_selected"
RaidGUIControlButtonWeaponSkill.ICON_UNKNOWN = "wpn_skill_unknown"
RaidGUIControlButtonWeaponSkill.ICON_LOCKED = "wpn_skill_locked"
RaidGUIControlButtonWeaponSkill.ICON_PART_APPEND = "_part"
RaidGUIControlButtonWeaponSkill.ROMAN_NUMERALS = {
	"I",
	"II",
	"III",
	"IV",
	"V",
}
RaidGUIControlButtonWeaponSkill.SELECTOR_TRIANGLE_W = 16
RaidGUIControlButtonWeaponSkill.SELECTOR_TRIANGLE_H = 16
RaidGUIControlButtonWeaponSkill.SELECTOR_SIZE_EXTENSION = 12

function RaidGUIControlButtonWeaponSkill:init(parent, params, tier_number, line_object, left_button)
	self:_init_state_data()

	self._state = params.state or RaidGUIControlButtonWeaponSkill.STATE_NORMAL
	self._line_object = line_object

	local tier_marker_params = clone(params)

	tier_marker_params.x = params.x + RaidGUIControlButtonWeaponSkill.TIER_MARKER_X
	tier_marker_params.y = params.y + RaidGUIControlButtonWeaponSkill.TIER_MARKER_Y
	tier_marker_params.font = tweak_data.gui.fonts.din_compressed
	tier_marker_params.font_size = tweak_data.gui.font_sizes.size_16
	tier_marker_params.text = self:translate("menu_weapons_stats_tier_abbreviation", true) .. RaidGUIControlButtonWeaponSkill.ROMAN_NUMERALS[tier_number]

	local icon = RaidGUIControlButtonWeaponSkill.ICON_LOCKED

	params.texture = tweak_data.gui.icons[icon].texture
	params.texture_rect = tweak_data.gui.icons[icon].texture_rect
	self._on_selected_weapon_skill_callback = params.on_selected_weapon_skill_callback
	self._on_unselected_weapon_skill_callback = params.on_unselected_weapon_skill_callback
	self._get_available_points_callback = params.get_available_points_callback
	self._on_click_weapon_skill_callback = params.on_click_weapon_skill_callback
	self._toggle_select_item_callback = params.toggle_select_item_callback

	local new_params = clone(params)

	new_params.w = new_params.w + 2 * RaidGUIControlButtonWeaponSkill.SELECTOR_SIZE_EXTENSION
	new_params.h = new_params.h + 2 * RaidGUIControlButtonWeaponSkill.SELECTOR_SIZE_EXTENSION

	RaidGUIControlButtonWeaponSkill.super.init(self, parent, new_params)

	if left_button then
		left_button:set_right_button(self)
	end

	self._object_image:set_x(RaidGUIControlButtonWeaponSkill.SELECTOR_SIZE_EXTENSION)
	self._object_image:set_y(RaidGUIControlButtonWeaponSkill.SELECTOR_SIZE_EXTENSION)
	self._object_image:set_w(params.w)
	self._object_image:set_h(params.h)
	self:_create_selector()
end

function RaidGUIControlButtonWeaponSkill:_create_selector()
	local selector_panel_params = {
		alpha = 0,
		h = self._object:h(),
		halign = "scale",
		name = "selector_panel",
		valign = "scale",
		w = self._object:w(),
		x = 0,
		y = 0,
	}

	self._selector_panel = self._object:panel(selector_panel_params)

	local selector_background_params = {
		alpha = 0,
		halign = "scale",
		layer = -10,
		name = "selector_background",
		texture = tweak_data.gui.icons[RaidGUIControlButtonWeaponSkill.ICON_SELECTED].texture,
		texture_rect = tweak_data.gui.icons[RaidGUIControlButtonWeaponSkill.ICON_SELECTED].texture_rect,
		valign = "scale",
		x = 0,
		y = 0,
	}

	self._selector_rect = self._selector_panel:image(selector_background_params)

	self._selector_rect:set_center_x(self._object:w() / 2)
	self._selector_rect:set_center_y(self._object:h() / 2)

	local selector_triangle_up_params = {
		alpha = 0,
		h = RaidGUIControlButtonWeaponSkill.SELECTOR_TRIANGLE_H,
		halign = "left",
		name = "selector_triangle_up",
		texture = tweak_data.gui.icons.ico_sel_rect_top_left.texture,
		texture_rect = tweak_data.gui.icons.ico_sel_rect_top_left.texture_rect,
		valign = "top",
		w = RaidGUIControlButtonWeaponSkill.SELECTOR_TRIANGLE_W,
		x = 0,
		y = 0,
	}

	self._selector_triangle_up = self._selector_panel:image(selector_triangle_up_params)

	local selector_triangle_down_params = {
		alpha = 0,
		h = RaidGUIControlButtonWeaponSkill.SELECTOR_TRIANGLE_H,
		halign = "right",
		name = "selector_triangle_down",
		texture = tweak_data.gui.icons.ico_sel_rect_bottom_right.texture,
		texture_rect = tweak_data.gui.icons.ico_sel_rect_bottom_right.texture_rect,
		valign = "bottom",
		w = RaidGUIControlButtonWeaponSkill.SELECTOR_TRIANGLE_W,
		x = self._selector_panel:w() - RaidGUIControlButtonWeaponSkill.SELECTOR_TRIANGLE_W,
		y = self._selector_panel:h() - RaidGUIControlButtonWeaponSkill.SELECTOR_TRIANGLE_H,
	}

	self._selector_triangle_down = self._selector_panel:image(selector_triangle_down_params)
end

function RaidGUIControlButtonWeaponSkill:set_right_button(button)
	self._right_button = button
end

function RaidGUIControlButtonWeaponSkill:set_skill(weapon_id, skill, skill_data, left_skill, unlocked, i_tier, i_skill)
	self._unlocked = unlocked

	if not skill then
		self:hide()

		if self._line_object then
			self._line_object:hide()
		end

		return
	else
		self:show()

		if self._line_object then
			self._line_object:show()
		end

		self._name = "weapon_skill_button_" .. skill.skill_name .. "_" .. i_tier .. "_" .. i_skill
	end

	if self._line_object then
		if not left_skill then
			self._line_object:hide()
		else
			self._line_object:show()
		end
	end

	local is_pending_challenge_active = (left_skill and left_skill.active or not left_skill) and skill.challenge_unlocked and not managers.challenge:get_challenge(ChallengeManager.CATEGORY_WEAPON_UPGRADE, skill.challenge_id):completed()
	local icon = skill_data.icon or RaidGUIControlButtonWeaponSkill.ICON_UNKNOWN

	if not self._unlocked or left_skill and not left_skill.active then
		icon = RaidGUIControlButtonWeaponSkill.ICON_LOCKED
	end

	if skill.weapon_parts and #skill.weapon_parts > 0 then
		icon = icon .. RaidGUIControlButtonWeaponSkill.ICON_PART_APPEND
	end

	local texture = tweak_data.gui.icons[icon]

	self._object_image:set_image(texture.texture)
	self._object_image:set_texture_rect(unpack(texture.texture_rect))

	local function gun_parts_invis()
		if skill.weapon_parts then
			for _, v in ipairs(skill.weapon_parts) do
				if managers.weapon_skills:get_hide_cosmetic_part(skill.weapon_id, v) then
					return true
				end
			end
		end

		return false
	end

	local invisible = false

	if skill.active then
		if gun_parts_invis() then
			invisible = true

			self:set_state(RaidGUIControlButtonWeaponSkill.STATE_INVISIBLE)
		else
			self:set_state(RaidGUIControlButtonWeaponSkill.STATE_ACTIVE)
		end
	elseif self._unlocked and left_skill and (managers.challenge:get_challenge(ChallengeManager.CATEGORY_WEAPON_UPGRADE, left_skill.challenge_id):completed() == false or managers.challenge:get_challenge(ChallengeManager.CATEGORY_WEAPON_UPGRADE, left_skill.challenge_id):completed() == true and not left_skill.active) then
		self:set_state(RaidGUIControlButtonWeaponSkill.STATE_BLOCKED)
	elseif not self._unlocked or left_skill and not left_skill.active then
		self:set_state(RaidGUIControlButtonWeaponSkill.STATE_UNAVAILABLE)
	elseif is_pending_challenge_active then
		self:set_state(RaidGUIControlButtonWeaponSkill.STATE_CHALLENGE_ACTIVE)
	else
		self:set_state(RaidGUIControlButtonWeaponSkill.STATE_NORMAL)
	end

	self._data = {
		i_skill = i_skill,
		i_tier = i_tier,
		invisible = invisible,
		value = skill,
	}

	self:highlight_off()
	self:_layout_breadcrumb(weapon_id, i_tier, i_skill)
end

function RaidGUIControlButtonWeaponSkill:_layout_breadcrumb(weapon_id, i_tier, i_skill)
	if self._breadcrumb then
		self._breadcrumb:close()
		self._object:remove(self._breadcrumb)

		self._breadcrumb = nil
	end

	local weapon_selection_index = tweak_data.weapon[weapon_id].use_data.selection_index
	local weapon_category = managers.weapon_inventory:get_weapon_category_name_by_bm_category_id(weapon_selection_index)
	local breadcrumb_params = {
		category = BreadcrumbManager.CATEGORY_WEAPON_UPGRADE,
		identifiers = {
			weapon_category,
			weapon_id,
			i_tier,
			i_skill,
		},
		layer = self._object_image:layer() + 1,
		padding = 3,
	}

	self._breadcrumb = self._object:breadcrumb(breadcrumb_params)

	self._breadcrumb:set_right(self._object:w())
	self._breadcrumb:set_y(0)
end

function RaidGUIControlButtonWeaponSkill:select_skill(dont_trigger_selected_callback)
	self._mouse_inside = true

	self:highlight_on()

	if not dont_trigger_selected_callback then
		self._on_selected_weapon_skill_callback(self, self._data)
	end
end

function RaidGUIControlButtonWeaponSkill:unselect_skill()
	self._mouse_inside = false

	self:highlight_off()
	self._on_unselected_weapon_skill_callback(self, self._data)
end

function RaidGUIControlButtonWeaponSkill:set_state(state)
	Application:trace("[RaidGUIControlButtonWeaponSkill:set_state] state ", state)

	if not self._unlocked and state ~= RaidGUIControlButtonWeaponSkill.STATE_UNAVAILABLE then
		return
	end

	self._state = state

	local color = self._state_data[self._state].highlight_off

	self:set_param_value("color", color)
	self:set_param_value("texture_color", color)

	local highlight_color = self._state_data[self._state].highlight_on

	self:set_param_value("highlight_color", highlight_color)
	self:set_param_value("texture_highlight_color", highlight_color)
	self:highlight_off()
	self._selector_panel:set_alpha(self._state_data[state].show_selector_panel_alpha)
	self._selector_rect:set_alpha(0)
	self._selector_triangle_up:set_alpha(self._state_data[state].show_selector_triangles_alpha)
	self._selector_triangle_down:set_alpha(self._state_data[state].show_selector_triangles_alpha)
end

function RaidGUIControlButtonWeaponSkill:_init_state_data()
	self._state_data = {}
	self._state_data[RaidGUIControlButtonWeaponSkill.STATE_NORMAL] = {
		highlight_off = tweak_data.gui.colors.raid_light_gold,
		highlight_on = tweak_data.gui.colors.raid_light_gold,
		show_selector_panel_alpha = 1,
		show_selector_triangles_alpha = 0,
	}
	self._state_data[RaidGUIControlButtonWeaponSkill.STATE_CHALLENGE_ACTIVE] = {
		highlight_off = tweak_data.gui.colors.raid_white,
		highlight_on = tweak_data.gui.colors.raid_white,
		show_selector_panel_alpha = 1,
		show_selector_triangles_alpha = 0,
	}
	self._state_data[RaidGUIControlButtonWeaponSkill.STATE_BLOCKED] = {
		highlight_off = tweak_data.gui.colors.raid_dark_grey,
		highlight_on = tweak_data.gui.colors.raid_dark_grey,
		show_selector_panel_alpha = 1,
		show_selector_triangles_alpha = 0,
	}
	self._state_data[RaidGUIControlButtonWeaponSkill.STATE_SELECTED] = {
		highlight_off = tweak_data.gui.colors.raid_red,
		highlight_on = tweak_data.gui.colors.raid_red,
		show_selector_panel_alpha = 1,
		show_selector_triangles_alpha = 1,
	}
	self._state_data[RaidGUIControlButtonWeaponSkill.STATE_ACTIVE] = {
		highlight_off = tweak_data.gui.colors.raid_red,
		highlight_on = tweak_data.gui.colors.raid_red,
		show_selector_panel_alpha = 1,
		show_selector_triangles_alpha = 0,
	}
	self._state_data[RaidGUIControlButtonWeaponSkill.STATE_INVISIBLE] = {
		highlight_off = tweak_data.gui.colors.raid_brown_red,
		highlight_on = tweak_data.gui.colors.raid_brown_red,
		show_selector_panel_alpha = 1,
		show_selector_triangles_alpha = 0,
	}
	self._state_data[RaidGUIControlButtonWeaponSkill.STATE_UNAVAILABLE] = {
		highlight_off = tweak_data.gui.colors.raid_dark_grey,
		highlight_on = tweak_data.gui.colors.raid_dark_grey,
		show_selector_panel_alpha = 0,
		show_selector_triangles_alpha = 0,
	}
end

function RaidGUIControlButtonWeaponSkill:get_state()
	return self._state
end

function RaidGUIControlButtonWeaponSkill:get_data()
	return self._data
end

function RaidGUIControlButtonWeaponSkill:is_invisible()
	return self._data.invisible == true
end

function RaidGUIControlButtonWeaponSkill:highlight_on()
	local color = self._state_data[self._state].highlight_on

	self._object_image:set_color(color)

	if self._line_object and not self:is_invisible() then
		self._line_object:set_color(color)
	end

	managers.menu_component:post_event("weapon_increase")
	self:show_hover_selector()
end

function RaidGUIControlButtonWeaponSkill:highlight_off()
	local color = self._state_data[self._state].highlight_off

	self._object_image:set_color(color)

	if self._line_object and not self:is_invisible() then
		self._line_object:set_color(color)
	end

	self:hide_hover_selector()
end

function RaidGUIControlButtonWeaponSkill:show_hover_selector()
	if self._selector_panel then
		local alpha = self._unlocked and 0.75 or 0.4

		self._selector_panel:set_alpha(alpha)
		self._selector_rect:set_alpha(alpha)
	end
end

function RaidGUIControlButtonWeaponSkill:hide_hover_selector()
	if self._selector_panel then
		self._selector_rect:set_alpha(0)
	end
end

function RaidGUIControlButtonWeaponSkill:on_mouse_released(button)
	if (self._state == RaidGUIControlButtonWeaponSkill.STATE_ACTIVE or self._state == RaidGUIControlButtonWeaponSkill.STATE_INVISIBLE) and self._data.value.active then
		if self:is_invisible() then
			self._data.invisible = false

			self:set_state(RaidGUIControlButtonWeaponSkill.STATE_ACTIVE)
			Application:trace("[RaidGUIControlWeaponSkillRow:set_weapon_skill] STATE_ACTIVE")
		else
			self._data.invisible = true

			self:set_state(RaidGUIControlButtonWeaponSkill.STATE_INVISIBLE)
			Application:trace("[RaidGUIControlWeaponSkillRow:set_weapon_skill] STATE_INVISIBLE")
		end

		if self._data.value and self._data.value.weapon_id and self._data.value.weapon_parts then
			managers.weapon_skills:set_hide_cosmetic_parts(self._data.value.weapon_id, self._data.value.weapon_parts, self:is_invisible())
		end

		managers.menu_component:post_event("weapon_increase")
		self._on_selected_weapon_skill_callback(self, self._data)
	elseif self._state == RaidGUIControlButtonWeaponSkill.STATE_SELECTED then
		self:set_state(RaidGUIControlButtonWeaponSkill.STATE_NORMAL)
		managers.menu_component:post_event("weapon_upgrade_deselect")
	elseif self._state == RaidGUIControlButtonWeaponSkill.STATE_NORMAL then
		self:set_state(RaidGUIControlButtonWeaponSkill.STATE_SELECTED)
		managers.menu_component:post_event("weapon_upgrade_select")
	elseif self._state == RaidGUIControlButtonWeaponSkill.STATE_UNAVAILABLE then
		return
	end

	if self._on_click_weapon_skill_callback then
		self._on_click_weapon_skill_callback(self, self._data)
	end

	self:show_hover_selector()
end

function RaidGUIControlButtonWeaponSkill:on_mouse_pressed(button)
	return
end

function RaidGUIControlButtonWeaponSkill:mouse_moved(o, x, y)
	if self:inside(x, y) then
		if not self._mouse_inside then
			self:on_mouse_over(x, y)
		end

		self:on_mouse_moved(o, x, y)

		return true, self._pointer_type
	end

	if self._mouse_inside then
		self:on_mouse_out(x, y)
	end

	return false
end

function RaidGUIControlButtonWeaponSkill:propagating_skill_deallocating()
	if self._state == RaidGUIControlButtonWeaponSkill.STATE_SELECTED then
		self:set_state(RaidGUIControlButtonWeaponSkill.STATE_NORMAL)
		self._on_click_weapon_skill_callback(self, self._data)
	end

	self:set_state(RaidGUIControlButtonWeaponSkill.STATE_UNAVAILABLE)

	if self._right_button then
		self._right_button:propagating_skill_deallocating()
	end

	self:_get_available_points_callback()
end

function RaidGUIControlButtonWeaponSkill:on_mouse_over(x, y)
	self._mouse_inside = true

	self._toggle_select_item_callback(true, self._data.i_skill, self._data.i_tier)
end

function RaidGUIControlButtonWeaponSkill:on_mouse_out(x, y)
	self._mouse_inside = false

	managers.menu_component:post_event("weapon_decrease")
	self._toggle_select_item_callback(false, self._data.i_skill, self._data.i_tier)
end
