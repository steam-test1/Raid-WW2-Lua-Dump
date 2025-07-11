RaidGUIControlCharacterDescription = RaidGUIControlCharacterDescription or class(RaidGUIControl)
RaidGUIControlCharacterDescription.MODE_SELECTION = "mode_selection"
RaidGUIControlCharacterDescription.MODE_CUSTOMIZATION = "mode_customization"
RaidGUIControlCharacterDescription.COMMON_ALPHA = 0.95

function RaidGUIControlCharacterDescription:init(parent, params, item_data)
	RaidGUIControlCharacterDescription.super.init(self, parent, params, item_data)

	self._data = item_data
	self._mode = self._params.mode or RaidGUIControlCharacterDescription.MODE_SELECTION

	self:_layout()
end

function RaidGUIControlCharacterDescription:_layout()
	self._object = self._panel:panel({
		h = self._params.h,
		name = "character_info_panel",
		w = self._params.w,
		x = self._params.x,
		y = self._params.y,
	})

	local padding = 16
	local padded_width = self._object:w() - padding * 2
	local object_bg_params = {
		h = self._object:h(),
		layer = -1,
		name = "object_bg",
		texture = tweak_data.gui.icons.paper_mission_book.texture,
		texture_rect = tweak_data.gui.icons.paper_mission_book.texture_rect,
		w = self._object:w() + 8,
		x = -4,
		y = 0,
	}

	self._object_bg = self._object:image(object_bg_params)

	local object_bg_params2 = {
		color = Color(0.7, 0.7, 0.7),
		h = self._object:h(),
		layer = -2,
		name = "object_bg",
		rotation = 2 + math.random(4),
		texture = tweak_data.gui.icons.paper_mission_book.texture,
		texture_rect = tweak_data.gui.icons.paper_mission_book.texture_rect,
		w = self._object:w() + 8,
		x = -4,
		y = 0,
	}

	self._object_bg2 = self._object:image(object_bg_params2)

	local step_quad = self._object:w() / 4
	local text_rect = tweak_data.gui.icons.ico_class_recon.texture_rect

	self._class_icon = self._object:image({
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		h = text_rect[4],
		name = "class_icon",
		texture = tweak_data.gui.icons.ico_class_recon.texture,
		texture_rect = tweak_data.gui.icons.ico_class_recon.texture_rect,
		visible = false,
		w = text_rect[3],
		x = 32,
		y = 32,
	})

	self._class_icon:set_center_x(step_quad)

	self._class_label = self._object:label({
		align = "center",
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 32,
		name = "class_label",
		text = "",
		vertical = "center",
		w = 134,
		x = 0,
		y = 96,
	})

	self._class_label:set_center_x(step_quad)

	self._nation_flag_icon = self._object:image({
		alpha = 0.85,
		h = 64,
		name = "nation_flag_icon",
		texture = tweak_data.gui.icons.ico_flag_empty.texture,
		texture_rect = tweak_data.gui.icons.ico_flag_empty.texture_rect,
		visible = false,
		w = 96,
		x = 144,
		y = 32,
	})

	self._nation_flag_icon:set_center_x(step_quad * 2)

	self._nation_flag_label = self._object:label({
		align = "center",
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 32,
		name = "nation_flag_label",
		text = "",
		vertical = "center",
		w = 104,
		x = 144,
		y = 96,
	})

	self._nation_flag_label:set_center_x(step_quad * 2)

	self._level_amount_level = self._object:label({
		align = "center",
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_52,
		h = 64,
		name = "level_amount_level",
		text = "",
		vertical = "center",
		w = 64,
		x = 280,
		y = 32,
	})

	self._level_amount_level:set_center_x(step_quad * 3)

	self._level_label = self._object:label({
		align = "center",
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 32,
		name = "level_label",
		text = "",
		vertical = "center",
		w = 72,
		x = 280,
		y = 96,
	})

	self._level_label:set_center_x(step_quad * 3)

	self._profile_name_label = self._object:label({
		align = "center",
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_dark_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_38,
		h = 41,
		name = "profile_name_label",
		text = "PROFILE NAME",
		w = 356,
		x = 1376,
		y = self._level_label:bottom() + 2,
	})

	self._profile_name_label:set_center_x(self._object:w() / 2)

	self._character_name_label = self._object:label({
		align = "center",
		alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 32,
		name = "character_name_label",
		text = "RAIDER",
		w = 356,
		x = 1376,
		y = self._profile_name_label:bottom() - 4,
	})

	self._character_name_label:set_center_x(self._object:w() / 2)

	if self._mode == RaidGUIControlCharacterDescription.MODE_SELECTION then
		self._description_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.lato,
			font_size = tweak_data.gui.font_sizes.size_20,
			h = 268,
			name = "description_label",
			text = self:translate("skill_class_recon_desc", false),
			vertical = "top",
			w = padded_width,
			wrap = true,
			x = padding,
			y = self._character_name_label:bottom() + 8,
		})
		self._skills_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
			h = 32,
			name = "profile_name_label",
			text = self:translate("menu_skills", true),
			y = self._description_label:bottom() + 2,
		})

		self._profile_name_label:set_center_x(self._object:w() / 2)

		self._skills_panel = self._object:panel({
			name = "skills_breakdown",
			w = padded_width,
			x = padding,
			y = self._skills_label:bottom(),
		})

		local y_stats = self._object:h() - 144
		local y_stats_label = y_stats + 48
		local x_stats_step = self._object:w() / 5

		self._health_amount_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_52,
			h = 64,
			name = "health_amount_label",
			text = "",
			vertical = "center",
			w = 100,
			x = 0,
			y = y_stats,
		})
		self._health_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
			h = 64,
			name = "health_label",
			text = "",
			vertical = "center",
			w = 100,
			x = 0,
			y = y_stats_label,
		})
		self._speed_amount_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_52,
			h = 64,
			name = "speed_amount_label",
			text = "",
			vertical = "center",
			w = 100,
			x = 160,
			y = y_stats,
		})
		self._speed_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
			h = 64,
			name = "speed_label",
			text = "",
			vertical = "center",
			w = 100,
			x = 160,
			y = y_stats_label,
		})
		self._stamina_amount_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_52,
			h = 64,
			name = "stamina_amount_label",
			text = "",
			vertical = "center",
			w = 100,
			x = 320,
			y = y_stats,
		})
		self._stamina_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
			h = 64,
			name = "stamina_label",
			text = "",
			vertical = "center",
			w = 100,
			x = 320,
			y = y_stats_label,
		})
		self._carry_weight_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_52,
			h = 64,
			name = "carry_weight_label",
			text = "",
			vertical = "center",
			w = 100,
			x = 320,
			y = y_stats,
		})
		self._carry_label = self._object:label({
			align = "center",
			alpha = RaidGUIControlCharacterDescription.COMMON_ALPHA,
			color = tweak_data.gui.colors.raid_black,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.size_24,
			h = 64,
			name = "carry_label",
			text = "",
			vertical = "center",
			w = 100,
			x = 320,
			y = y_stats_label,
		})

		self._health_amount_label:set_center_x(x_stats_step)
		self._health_label:set_center_x(x_stats_step)
		self._speed_label:set_center_x(x_stats_step * 2)
		self._speed_amount_label:set_center_x(x_stats_step * 2)
		self._stamina_label:set_center_x(x_stats_step * 3)
		self._stamina_amount_label:set_center_x(x_stats_step * 3)
		self._carry_weight_label:set_center_x(x_stats_step * 4)
		self._carry_label:set_center_x(x_stats_step * 4)
	end
end

function RaidGUIControlCharacterDescription:_recreate_skills(skills_applied)
	self._skills_panel:clear()

	local skill_types = {
		SkillTreeTweakData.TYPE_WARCRY,
		SkillTreeTweakData.TYPE_BOOSTS,
		SkillTreeTweakData.TYPE_TALENT,
	}
	local icon_size = 42
	local padding = 4
	local last_icon

	for slot_type, idx in ipairs(skill_types) do
		if skills_applied[idx] then
			for id, skill in pairs(skills_applied[idx]) do
				local skill_tweak = tweak_data.skilltree.skills[id]

				if skill.active then
					local tag_color = tweak_data.skilltree.skill_category_colors[slot_type]
					local icon = tweak_data.skilltree:get_skill_icon_tiered(id)
					local x = last_icon and last_icon:right() or 0
					local gui_skill = tweak_data.gui:get_full_gui_data(icon)

					last_icon = self._skills_panel:image({
						color = tag_color,
						h = icon_size,
						name = "object_bg",
						texture = gui_skill.texture,
						texture_rect = gui_skill.texture_rect,
						w = icon_size,
						x = x + padding,
					})
				end
			end
		end
	end

	if last_icon then
		self._skills_panel:set_w(last_icon:right())
		self._skills_panel:set_center_x(self._object:w() / 2)
	end
end

function RaidGUIControlCharacterDescription:set_data(data)
	if data.profile_name then
		self._profile_name_label:set_text(data.profile_name)
	end

	if data.nationality then
		self._character_name_label:set_text(self:translate("menu_" .. data.nationality, true))
	end

	local class_icon_data = tweak_data.gui.icons["ico_class_" .. data.class_name] or tweak_data.gui.icons.ico_flag_empty

	self._class_icon:set_image(class_icon_data.texture)
	self._class_icon:set_texture_rect(class_icon_data.texture_rect)
	self._class_icon:set_visible(true)
	self._class_label:set_text(self:translate(tweak_data.skilltree.classes[data.class_name].name_id, true))

	local nation_flag_data = tweak_data.gui.icons["ico_flag_" .. data.nationality] or tweak_data.gui.icons.ico_flag_empty

	self._nation_flag_icon:set_image(nation_flag_data.texture)
	self._nation_flag_icon:set_texture_rect(nation_flag_data.texture_rect)
	self._nation_flag_icon:set_visible(true)
	self._nation_flag_label:set_text(utf8.to_upper(managers.localization:text("nationality_" .. data.nationality)))
	self._level_amount_level:set_text(data.level)
	self._level_label:set_text(self:translate("select_character_level_label", true))

	if self._mode == RaidGUIControlCharacterDescription.MODE_SELECTION then
		self:_recreate_skills(data.skill_tree)

		local class_description = self:translate(tweak_data.skilltree.classes[data.class_name].desc_id, false) or ""

		self._description_label:set_text(class_description)

		local health_amount = data.character_stats and data.character_stats.health or 0

		self._health_amount_label:set_text(string.format("%.0f", health_amount))
		self._health_label:set_text(self:translate("character_stats_health_label", true))

		local _, _, w, _ = self._health_label:text_rect()

		self._health_label:set_w(w)
		self._health_label:set_center_x(self._health_amount_label:x() + self._health_amount_label:w() / 2)

		local speed_amount = data.character_stats and data.character_stats.speed_walk or 0

		self._speed_amount_label:set_text(string.format("%.0f", speed_amount))
		self._speed_label:set_text(self:translate("character_stats_speed_walk_label", true))

		local stamina_amount = data.character_stats and data.character_stats.stamina or 0

		self._stamina_amount_label:set_text(string.format("%.0f", stamina_amount))
		self._stamina_label:set_text(self:translate("character_stats_stamina_label", true))

		local carry_limit = data.character_stats and data.character_stats.carry_limit or 0

		self._carry_weight_label:set_text(carry_limit)
		self._carry_label:set_text(self:translate("character_stats_carry_limit_label", true))
	end
end
