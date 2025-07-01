SkillTreeTweakData = SkillTreeTweakData or class()
SkillTreeTweakData.CLASS_RECON = "recon"
SkillTreeTweakData.CLASS_ASSAULT = "assault"
SkillTreeTweakData.CLASS_INFILTRATOR = "infiltrator"
SkillTreeTweakData.CLASS_DEMOLITIONS = "demolitions"
SkillTreeTweakData.STARTING_SUBCLASS_LEVEL = 5

function SkillTreeTweakData:init(tweak_data)
	self:_init_classes(tweak_data)
	self:_init_skill_list()

	self.skill_trees = {}

	self:_init_recon_skill_tree()
	self:_init_assault_skill_tree()
	self:_init_infiltrator_skill_tree()
	self:_init_demolitions_skill_tree()

	self.automatic_unlock_progressions = {}
	self.default_weapons = {}

	self:_init_recon_unlock_progression()
	self:_init_assault_unlock_progression()
	self:_init_infiltrator_unlock_progression()
	self:_init_demolitions_unlock_progression()
	self:_create_class_warcry_data()
end

function SkillTreeTweakData:_create_class_warcry_data()
	self.class_warcry_data = {}

	for class_name, class_data in pairs(self.classes) do
		self.class_warcry_data[class_name] = {}

		for level, skilltree_data in pairs(self.skill_trees[class_name]) do
			for _, skill_data in pairs(skilltree_data) do
				local aquires_field = self.skills[skill_data.skill_name].acquires

				for _, acquires_item in pairs(aquires_field) do
					if acquires_item.warcry then
						self.class_warcry_data[class_name] = acquires_item.warcry
					end
				end
			end
		end
	end
end

function SkillTreeTweakData:_init_classes(tweak_data)
	self.classes = {}
	self.base_classes = {
		"recon",
		"assault",
		"infiltrator",
		"demolitions",
	}
	self.icon_texture = "ui/main_menu/textures/class_stats_icons"
	self.icon_size_width = 128
	self.icon_size_height = 96
	self.classes.recon = {
		default_natioanlity = "british",
		desc_id = "skill_class_recon_desc",
		name = "recon",
		name_id = "skill_class_recon_name",
		icon = {
			x = 0,
			y = 0,
		},
		icon_data = tweak_data.gui.icons.ico_class_recon,
		icon_texture_rect_mission_join = {
			0,
			512,
			64,
			64,
		},
		stats = {
			health = 12,
			speed = 162,
			stamina = 68,
		},
	}
	self.classes.recon.subclasses = {
		"scout",
		"sniper",
	}
	self.classes.recon.subclasses.scout = {
		desc_id = "skill_class_scout_desc",
		name = "scout",
		name_id = "skill_class_scout_name",
		icon = {
			x = 256,
			y = 0,
		},
	}
	self.classes.recon.subclasses.sniper = {
		desc_id = "skill_class_sniper_desc",
		name = "sniper",
		name_id = "skill_class_sniper_name",
		icon = {
			x = 128,
			y = 0,
		},
	}
	self.classes.assault = {
		default_natioanlity = "american",
		desc_id = "skill_class_assault_desc",
		name = "assault",
		name_id = "skill_class_assault_name",
		icon = {
			x = 384,
			y = 0,
		},
		icon_data = tweak_data.gui.icons.ico_class_assault,
		icon_texture_rect_mission_join = {
			192,
			512,
			64,
			64,
		},
		stats = {
			health = 13,
			speed = 163,
			stamina = 69,
		},
	}
	self.classes.assault.subclasses = {
		"rifleman",
		"sentry",
	}
	self.classes.assault.subclasses.rifleman = {
		desc_id = "skill_class_rifleman_desc",
		name = "rifleman",
		name_id = "skill_class_rifleman_name",
		icon = {
			x = 640,
			y = 0,
		},
	}
	self.classes.assault.subclasses.sentry = {
		desc_id = "skill_class_sentry_desc",
		name = "sentry",
		name_id = "skill_class_sentry_name",
		icon = {
			x = 512,
			y = 0,
		},
	}
	self.classes.demolitions = {
		default_natioanlity = "german",
		desc_id = "skill_class_demolitions_desc",
		name = "demolitions",
		name_id = "skill_class_demolitions_name",
		icon = {
			x = 0,
			y = 96,
		},
		icon_data = tweak_data.gui.icons.ico_class_demolitions,
		icon_texture_rect_mission_join = {
			384,
			512,
			64,
			64,
		},
		stats = {
			health = 14,
			speed = 164,
			stamina = 70,
		},
	}
	self.classes.demolitions.subclasses = {
		"sapper",
		"grenadier",
	}
	self.classes.demolitions.subclasses.sapper = {
		desc_id = "skill_class_sapper_desc",
		name = "sapper",
		name_id = "skill_class_sapper_name",
		icon = {
			x = 256,
			y = 96,
		},
	}
	self.classes.demolitions.subclasses.grenadier = {
		desc_id = "skill_class_grenadier_desc",
		name = "grenadier",
		name_id = "skill_class_grenadier_name",
		icon = {
			x = 128,
			y = 96,
		},
	}
	self.classes.infiltrator = {
		default_natioanlity = "russian",
		desc_id = "skill_class_infiltrator_desc",
		name = "infiltrator",
		name_id = "skill_class_infiltrator_name",
		icon = {
			x = 0,
			y = 96,
		},
		icon_data = tweak_data.gui.icons.ico_class_infiltrator,
		icon_texture_rect_mission_join = {
			384,
			512,
			64,
			64,
		},
		stats = {
			health = 15,
			speed = 165,
			stamina = 71,
		},
	}
end

function SkillTreeTweakData:_init_skill_list()
	self.skills = {}
	self.skills.skill_empty_placeholder = {
		desc_id = "skill_empty_placeholder_desc",
		icon = "skill_warcry_placeholder",
		icon_large = "skill_warcry_placeholder",
		name_id = "skill_empty_placeholder_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.skill_empty_placeholder_garand = {
		desc_id = "skill_empty_placeholder_desc",
		name_id = "skill_empty_placeholder_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"garand",
		},
	}
	self.skills.warcry_level_increase = {
		desc_id = "skill_warcry_level_increase_desc",
		icon = "skill_warcry_placeholder",
		icon_large = "skill_warcry_placeholder",
		name_id = "skill_warcry_level_increase_name",
		acquires = {
			{
				warcry_level = 1,
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.warcry_sharpshooter = {
		desc_id = "skill_warcry_sharpshooter_desc",
		icon = "skills_warcry_recon_sharpshooter",
		icon_large = "skills_warcry_recon_sharpshooter_large",
		name_id = "skill_warcry_sharpshooter_name",
		acquires = {
			{
				warcry = "sharpshooter",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_can_use_scope",
			"player_highlight_enemy",
		},
	}
	self.skills.warcry_sharpshooter_level_increase = {
		desc_id = "skill_warcry_level_increase_desc",
		icon = "skills_warcry_recon_sharpshooter",
		icon_large = "skills_warcry_recon_sharpshooter_large",
		name_id = "skill_warcry_level_increase_name",
		acquires = {
			{
				warcry_level = 1,
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.warcry_berserk = {
		desc_id = "skill_warcry_berserk_desc",
		icon = "skills_warcry_assault_berserk",
		icon_large = "skills_warcry_assault_berserk_large",
		name_id = "skill_warcry_berserk_name",
		acquires = {
			{
				warcry = "berserk",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_highlight_enemy",
		},
	}
	self.skills.warcry_berserk_level_increase = {
		desc_id = "skill_warcry_level_increase_desc",
		icon = "skills_warcry_assault_berserk",
		icon_large = "skills_warcry_assault_berserk_large",
		name_id = "skill_warcry_level_increase_name",
		acquires = {
			{
				warcry_level = 1,
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.warcry_ghost = {
		desc_id = "skill_warcry_ghost_desc",
		icon = "skills_warcry_infilitrator_invisibility",
		icon_large = "skills_warcry_infilitrator_invisibility_large",
		name_id = "skill_warcry_ghost_name",
		acquires = {
			{
				warcry = "ghost",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_highlight_enemy",
		},
	}
	self.skills.warcry_ghost_level_increase = {
		desc_id = "skill_warcry_level_increase_desc",
		icon = "skills_warcry_infilitrator_invisibility",
		icon_large = "skills_warcry_infilitrator_invisibility_large",
		name_id = "skill_warcry_level_increase_name",
		acquires = {
			{
				warcry_level = 1,
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.warcry_clustertruck = {
		desc_id = "skill_warcry_clustertruck_desc",
		icon = "skills_warcry_demolition_cluster_truck",
		icon_large = "skills_warcry_demolition_cluster_truck_large",
		name_id = "skill_warcry_clustertruck_name",
		acquires = {
			{
				warcry = "clustertruck",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_highlight_enemy",
		},
	}
	self.skills.warcry_clustertruck_level_increase = {
		desc_id = "skill_warcry_level_increase_desc",
		icon = "skills_warcry_demolition_cluster_truck",
		icon_large = "skills_warcry_demolition_cluster_truck_large",
		name_id = "skill_warcry_level_increase_name",
		acquires = {
			{
				warcry_level = 1,
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.warcry_duration_1 = {
		desc_id = "skill_warcry_duration_increase_desc",
		icon = "warcry_common_upgrade_duration_lvl1",
		icon_large = "skills_warcry_common_upgrade_duration_lvl1_large",
		name_id = "skill_warcry_duration_increase_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_duration_1",
		},
	}
	self.skills.warcry_duration_2 = {
		desc_id = "skill_warcry_duration_increase_desc",
		icon = "warcry_common_upgrade_duration_lvl2",
		icon_large = "skills_warcry_common_upgrade_duration_lvl2_large",
		name_id = "skill_warcry_duration_increase_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_duration_2",
		},
	}
	self.skills.warcry_duration_3 = {
		desc_id = "skill_warcry_duration_increase_desc",
		icon = "warcry_common_upgrade_duration_lvl3",
		icon_large = "skills_warcry_common_upgrade_duration_lvl3_large",
		name_id = "skill_warcry_duration_increase_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_duration_3",
		},
	}
	self.skills.warcry_duration_4 = {
		desc_id = "skill_warcry_duration_increase_desc",
		icon = "warcry_common_upgrade_duration_lvl4",
		icon_large = "skills_warcry_common_upgrade_duration_lvl4_large",
		name_id = "skill_warcry_duration_increase_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_duration_4",
		},
	}
	self.skills.warcry_team_damage_buff_1 = {
		desc_id = "skill_warcry_team_damage_buff_desc",
		icon = "warcry_recon_sharpshooter_upgrade_increased_damage",
		icon_large = "skills_warcry_recon_sharpshooter_upgrade_increased_damage_large",
		name_id = "skill_warcry_team_damage_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_damage_buff_bonus_1",
		},
	}
	self.skills.warcry_team_damage_buff_2 = {
		desc_id = "skill_warcry_team_damage_buff_desc",
		icon = "warcry_recon_sharpshooter_upgrade_increased_damage",
		icon_large = "skills_warcry_recon_sharpshooter_upgrade_increased_damage_large",
		name_id = "skill_warcry_team_damage_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_damage_buff_bonus_2",
		},
	}
	self.skills.warcry_team_damage_buff_3 = {
		desc_id = "skill_warcry_team_damage_buff_desc",
		icon = "warcry_recon_sharpshooter_upgrade_increased_damage",
		icon_large = "skills_warcry_recon_sharpshooter_upgrade_increased_damage_large",
		name_id = "skill_warcry_team_damage_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_damage_buff_bonus_3",
		},
	}
	self.skills.warcry_team_damage_buff_4 = {
		desc_id = "skill_warcry_team_damage_buff_desc",
		icon = "warcry_recon_sharpshooter_upgrade_increased_damage",
		icon_large = "skills_warcry_recon_sharpshooter_upgrade_increased_damage_large",
		name_id = "skill_warcry_team_damage_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_damage_buff_bonus_4",
		},
	}
	self.skills.warcry_headshot_multiplier_bonus_1 = {
		desc_id = "skill_warcry_headshot_bonus_desc",
		icon = "warcry_recon_sharpshooter_upgrade_headshot",
		icon_large = "skills_warcry_recon_sharpshooter_upgrade_headshot_large",
		name_id = "skill_warcry_headshot_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_headshot_multiplier_bonus_1",
		},
	}
	self.skills.warcry_headshot_multiplier_bonus_2 = {
		desc_id = "skill_warcry_headshot_bonus_desc",
		icon = "warcry_recon_sharpshooter_upgrade_headshot",
		icon_large = "skills_warcry_recon_sharpshooter_upgrade_headshot_large",
		name_id = "skill_warcry_headshot_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_headshot_multiplier_bonus_2",
		},
	}
	self.skills.warcry_long_range_multiplier_bonus_1 = {
		desc_id = "skill_warcry_long_range_bonus_desc",
		icon = "warcry_recon_sharpshooter_upgrade_long_range",
		icon_large = "skills_warcry_recon_sharpshooter_upgrade_long_range_large",
		name_id = "skill_warcry_long_range_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_long_range_multiplier_bonus_1",
		},
	}
	self.skills.warcry_long_range_multiplier_bonus_2 = {
		desc_id = "skill_warcry_long_range_bonus_desc",
		icon = "warcry_recon_sharpshooter_upgrade_long_range",
		icon_large = "skills_warcry_recon_sharpshooter_upgrade_long_range_large",
		name_id = "skill_warcry_long_range_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_long_range_multiplier_bonus_2",
		},
	}
	self.skills.warcry_team_heal_buff_1 = {
		desc_id = "skill_warcry_team_heal_buff_desc",
		icon = "warcry_assault_berserk_upgrade_increased_team_heal",
		icon_large = "skills_warcry_assault_berserk_upgrade_increased_team_heal_large",
		name_id = "skill_warcry_team_heal_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_team_heal_bonus_1",
		},
	}
	self.skills.warcry_team_heal_buff_2 = {
		desc_id = "skill_warcry_team_heal_buff_desc",
		icon = "warcry_assault_berserk_upgrade_increased_team_heal",
		icon_large = "skills_warcry_assault_berserk_upgrade_increased_team_heal_large",
		name_id = "skill_warcry_team_heal_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_team_heal_bonus_2",
		},
	}
	self.skills.warcry_team_heal_buff_3 = {
		desc_id = "skill_warcry_team_heal_buff_desc",
		icon = "warcry_assault_berserk_upgrade_increased_team_heal",
		icon_large = "skills_warcry_assault_berserk_upgrade_increased_team_heal_large",
		name_id = "skill_warcry_team_heal_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_team_heal_bonus_3",
		},
	}
	self.skills.warcry_team_heal_buff_4 = {
		desc_id = "skill_warcry_team_heal_buff_desc",
		icon = "warcry_assault_berserk_upgrade_increased_team_heal",
		icon_large = "skills_warcry_assault_berserk_upgrade_increased_team_heal_large",
		name_id = "skill_warcry_team_heal_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_team_heal_bonus_4",
		},
	}
	self.skills.warcry_dismemberment_multiplier_bonus_1 = {
		desc_id = "skill_warcry_dismemberment_bonus_desc",
		icon = "warcry_assault_berserk_upgrade_dismemberment",
		icon_large = "skills_warcry_assault_berserk_upgrade_dismemberment_large",
		name_id = "skill_warcry_dismemberment_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_dismemberment_multiplier_bonus_1",
		},
	}
	self.skills.warcry_dismemberment_multiplier_bonus_2 = {
		desc_id = "skill_warcry_dismemberment_bonus_desc",
		icon = "warcry_assault_berserk_upgrade_dismemberment",
		icon_large = "skills_warcry_assault_berserk_upgrade_dismemberment_large",
		name_id = "skill_warcry_dismemberment_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_dismemberment_multiplier_bonus_2",
		},
	}
	self.skills.warcry_low_health_multiplier_bonus_1 = {
		desc_id = "skill_warcry_low_health_bonus_desc",
		icon = "warcry_assault_berserk_upgrade_low_health",
		icon_large = "skills_warcry_assault_berserk_upgrade_low_health_large",
		name_id = "skill_warcry_low_health_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_low_health_multiplier_bonus_1",
		},
	}
	self.skills.warcry_low_health_multiplier_bonus_2 = {
		desc_id = "skill_warcry_low_health_bonus_desc",
		icon = "warcry_assault_berserk_upgrade_low_health",
		icon_large = "skills_warcry_assault_berserk_upgrade_low_health_large",
		name_id = "skill_warcry_low_health_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_low_health_multiplier_bonus_2",
		},
	}
	self.skills.warcry_team_movement_speed_buff_1 = {
		desc_id = "skill_warcry_team_movement_speed_buff_desc",
		icon = "warcry_insurgent_untouchable_upgrade_increased_move_speed",
		icon_large = "skills_warcry_insurgent_untouchable_upgrade_increased_move_speed_large",
		name_id = "skill_warcry_team_movement_speed_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_movement_speed_bonus_1",
		},
	}
	self.skills.warcry_team_movement_speed_buff_2 = {
		desc_id = "skill_warcry_team_movement_speed_buff_desc",
		icon = "warcry_insurgent_untouchable_upgrade_increased_move_speed",
		icon_large = "skills_warcry_insurgent_untouchable_upgrade_increased_move_speed_large",
		name_id = "skill_warcry_team_movement_speed_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_movement_speed_bonus_2",
		},
	}
	self.skills.warcry_team_movement_speed_buff_3 = {
		desc_id = "skill_warcry_team_movement_speed_buff_desc",
		icon = "warcry_insurgent_untouchable_upgrade_increased_move_speed",
		icon_large = "skills_warcry_insurgent_untouchable_upgrade_increased_move_speed_large",
		name_id = "skill_warcry_team_movement_speed_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_movement_speed_bonus_3",
		},
	}
	self.skills.warcry_team_movement_speed_buff_4 = {
		desc_id = "skill_warcry_team_movement_speed_buff_desc",
		icon = "warcry_insurgent_untouchable_upgrade_increased_move_speed",
		icon_large = "skills_warcry_insurgent_untouchable_upgrade_increased_move_speed_large",
		name_id = "skill_warcry_team_movement_speed_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_movement_speed_bonus_4",
		},
	}
	self.skills.warcry_melee_multiplier_bonus_1 = {
		desc_id = "skill_warcry_melee_bonus_desc",
		icon = "warcry_insurgent_untouchable_upgrade_melee",
		icon_large = "skills_warcry_insurgent_untouchable_upgrade_melee_large",
		name_id = "skill_warcry_melee_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_melee_multiplier_bonus_1",
		},
	}
	self.skills.warcry_melee_multiplier_bonus_2 = {
		desc_id = "skill_warcry_melee_bonus_desc",
		icon = "warcry_insurgent_untouchable_upgrade_melee",
		icon_large = "skills_warcry_insurgent_untouchable_upgrade_melee_large",
		name_id = "skill_warcry_melee_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_melee_multiplier_bonus_2",
		},
	}
	self.skills.warcry_short_range_multiplier_bonus_1 = {
		desc_id = "skill_warcry_short_range_bonus_desc",
		icon = "warcry_insurgent_untouchable_short_range_bonus",
		icon_large = "skills_warcry_insurgent_untouchable_short_range_bonus_large",
		name_id = "skill_warcry_short_range_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_short_range_multiplier_bonus_1",
		},
	}
	self.skills.warcry_short_range_multiplier_bonus_2 = {
		desc_id = "skill_warcry_short_range_bonus_desc",
		icon = "warcry_insurgent_untouchable_short_range_bonus",
		icon_large = "skills_warcry_insurgent_untouchable_short_range_bonus_large",
		name_id = "skill_warcry_short_range_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_short_range_multiplier_bonus_2",
		},
	}
	self.skills.warcry_team_damage_reduction_buff_1 = {
		desc_id = "skill_warcry_team_damage_reduction_buff_desc",
		icon = "warcry_demolition_cluster_truck_damage_resist",
		icon_large = "skills_warcry_demolition_cluster_truck_damage_resist_large",
		name_id = "skill_warcry_team_damage_reduction_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_damage_reduction_bonus_on_activate_1",
		},
	}
	self.skills.warcry_team_damage_reduction_buff_2 = {
		desc_id = "skill_warcry_team_damage_reduction_buff_desc",
		icon = "warcry_demolition_cluster_truck_damage_resist",
		icon_large = "skills_warcry_demolition_cluster_truck_damage_resist_large",
		name_id = "skill_warcry_team_damage_reduction_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_damage_reduction_bonus_on_activate_2",
		},
	}
	self.skills.warcry_team_damage_reduction_buff_3 = {
		desc_id = "skill_warcry_team_damage_reduction_buff_desc",
		icon = "warcry_demolition_cluster_truck_damage_resist",
		icon_large = "skills_warcry_demolition_cluster_truck_damage_resist_large",
		name_id = "skill_warcry_team_damage_reduction_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_damage_reduction_bonus_on_activate_3",
		},
	}
	self.skills.warcry_team_damage_reduction_buff_4 = {
		desc_id = "skill_warcry_team_damage_reduction_buff_desc",
		icon = "warcry_demolition_cluster_truck_damage_resist",
		icon_large = "skills_warcry_demolition_cluster_truck_damage_resist_large",
		name_id = "skill_warcry_team_damage_reduction_buff_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_team_damage_reduction_bonus_on_activate_4",
		},
	}
	self.skills.warcry_explosion_multiplier_bonus_1 = {
		desc_id = "skill_warcry_explosion_bonus_desc",
		icon = "warcry_demolition_cluster_truck_granade",
		icon_large = "skills_warcry_demolition_cluster_truck_granade_large",
		name_id = "skill_warcry_explosion_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_explosions_multiplier_bonus_1",
		},
	}
	self.skills.warcry_explosion_multiplier_bonus_2 = {
		desc_id = "skill_warcry_explosion_bonus_desc",
		icon = "warcry_demolition_cluster_truck_granade",
		icon_large = "skills_warcry_demolition_cluster_truck_granade_large",
		name_id = "skill_warcry_explosion_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_explosions_multiplier_bonus_2",
		},
	}
	self.skills.warcry_killstreak_multiplier_bonus_1 = {
		desc_id = "skill_warcry_killstreak_bonus_desc",
		icon = "warcry_demolition_cluster_truck_kill_streak",
		icon_large = "skills_warcry_demolition_cluster_truck_kill_streak_large",
		name_id = "skill_warcry_killstreak_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_killstreak_multiplier_bonus_1",
		},
	}
	self.skills.warcry_killstreak_multiplier_bonus_2 = {
		desc_id = "skill_warcry_killstreak_bonus_desc",
		icon = "warcry_demolition_cluster_truck_kill_streak",
		icon_large = "skills_warcry_demolition_cluster_truck_kill_streak_large",
		name_id = "skill_warcry_killstreak_bonus_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"warcry_player_killstreak_multiplier_bonus_2",
		},
	}
	self.skills.subclass_to_scout = {
		desc_id = "skill_subclass_to_scout_desc",
		name_id = "skill_subclass_to_scout_name",
		acquires = {
			{
				subclass = "scout",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_highlight_enemy",
		},
	}
	self.skills.subclass_to_rifleman = {
		desc_id = "skill_subclass_to_rifleman_desc",
		name_id = "skill_subclass_to_rifleman_name",
		acquires = {
			{
				subclass = "rifleman",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.subclass_to_sentry = {
		desc_id = "skill_subclass_to_sentry_desc",
		name_id = "skill_subclass_to_sentry_name",
		acquires = {
			{
				subclass = "sentry",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.subclass_to_sapper = {
		desc_id = "skill_subclass_to_sapper_desc",
		name_id = "skill_subclass_to_sapper_name",
		acquires = {
			{
				subclass = "sapper",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.subclass_to_grenadier = {
		desc_id = "skill_subclass_to_grenadier_desc",
		name_id = "skill_subclass_to_grenadier_name",
		acquires = {
			{
				subclass = "grenadier",
			},
		},
		icon_xy = {
			1,
			1,
		},
		upgrades = {},
	}
	self.skills.undetectable_by_spotters = {
		desc_id = "skill_undetectable_by_spotters_desc",
		name_id = "skill_undetectable_by_spotters_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_undetectable_by_spotters",
		},
	}
	self.skills.player_critical_hit_chance_1 = {
		desc_id = "skill_player_critical_hit_chance_desc",
		icon = "skills_dealing_damage_critical_chance",
		icon_large = "skills_dealing_damage_critical_chance_large",
		name_id = "skill_player_critical_hit_chance_name",
		stat_desc_id = "skill_player_critical_hit_chance_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_critical_hit_chance_1",
		},
	}
	self.skills.player_critical_hit_chance_2 = {
		desc_id = "skill_player_critical_hit_chance_desc",
		icon = "skills_dealing_damage_critical_chance",
		icon_large = "skills_dealing_damage_critical_chance_large",
		name_id = "skill_player_critical_hit_chance_name",
		stat_desc_id = "skill_player_critical_hit_chance_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_critical_hit_chance_2",
		},
	}
	self.skills.player_critical_hit_chance_3 = {
		desc_id = "skill_player_critical_hit_chance_desc",
		icon = "skills_dealing_damage_critical_chance",
		icon_large = "skills_dealing_damage_critical_chance_large",
		name_id = "skill_player_critical_hit_chance_name",
		stat_desc_id = "skill_player_critical_hit_chance_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_critical_hit_chance_3",
		},
	}
	self.skills.player_critical_hit_chance_4 = {
		desc_id = "skill_player_critical_hit_chance_desc",
		icon = "skills_dealing_damage_critical_chance",
		icon_large = "skills_dealing_damage_critical_chance_large",
		name_id = "skill_player_critical_hit_chance_name",
		stat_desc_id = "skill_player_critical_hit_chance_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_critical_hit_chance_4",
		},
	}
	self.skills.stamina_multiplier_1 = {
		desc_id = "skill_stamina_multiplier_desc",
		icon = "skills_navigation_stamina_reserve",
		icon_large = "skills_navigation_stamina_reserve_large",
		name_id = "skill_stamina_multiplier_name",
		stat_desc_id = "skill_stamina_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_stamina_multiplier_1",
		},
	}
	self.skills.stamina_multiplier_2 = {
		desc_id = "skill_stamina_multiplier_desc",
		icon = "skills_navigation_stamina_reserve",
		icon_large = "skills_navigation_stamina_reserve_large",
		name_id = "skill_stamina_multiplier_name",
		stat_desc_id = "skill_stamina_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_stamina_multiplier_2",
		},
	}
	self.skills.stamina_multiplier_3 = {
		desc_id = "skill_stamina_multiplier_desc",
		icon = "skills_navigation_stamina_reserve",
		icon_large = "skills_navigation_stamina_reserve_large",
		name_id = "skill_stamina_multiplier_name",
		stat_desc_id = "skill_stamina_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_stamina_multiplier_3",
		},
	}
	self.skills.stamina_multiplier_4 = {
		desc_id = "skill_stamina_multiplier_desc",
		icon = "skills_navigation_stamina_reserve",
		icon_large = "skills_navigation_stamina_reserve_large",
		name_id = "skill_stamina_multiplier_name",
		stat_desc_id = "skill_stamina_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_stamina_multiplier_4",
		},
	}
	self.skills.stamina_regeneration_increase_1 = {
		desc_id = "skill_stamina_regeneration_increase_desc",
		icon = "skills_navigation_stamina_regeneration",
		icon_large = "skills_navigation_stamina_regeneration_large",
		name_id = "skill_stamina_regeneration_increase_name",
		stat_desc_id = "skill_stamina_regeneration_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_stamina_regeneration_increase_1",
		},
	}
	self.skills.stamina_regeneration_increase_2 = {
		desc_id = "skill_stamina_regeneration_increase_desc",
		icon = "skills_navigation_stamina_regeneration",
		icon_large = "skills_navigation_stamina_regeneration_large",
		name_id = "skill_stamina_regeneration_increase_name",
		stat_desc_id = "skill_stamina_regeneration_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_stamina_regeneration_increase_2",
		},
	}
	self.skills.stamina_regeneration_increase_3 = {
		desc_id = "skill_stamina_regeneration_increase_desc",
		icon = "skills_navigation_stamina_regeneration",
		icon_large = "skills_navigation_stamina_regeneration_large",
		name_id = "skill_stamina_regeneration_increase_name",
		stat_desc_id = "skill_stamina_regeneration_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_stamina_regeneration_increase_3",
		},
	}
	self.skills.stamina_regeneration_increase_4 = {
		desc_id = "skill_stamina_regeneration_increase_desc",
		icon = "skills_navigation_stamina_regeneration",
		icon_large = "skills_navigation_stamina_regeneration_large",
		name_id = "skill_stamina_regeneration_increase_name",
		stat_desc_id = "skill_stamina_regeneration_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_stamina_regeneration_increase_4",
		},
	}
	self.skills.max_health_multiplier_1 = {
		desc_id = "skill_max_health_multiplier_desc",
		icon = "skills_soaking_damage_increased_health",
		icon_large = "skills_soaking_damage_increased_health_large",
		name_id = "skill_max_health_multiplier_name",
		stat_desc_id = "skill_max_health_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_max_health_multiplier_1",
		},
	}
	self.skills.max_health_multiplier_2 = {
		desc_id = "skill_max_health_multiplier_desc",
		icon = "skills_soaking_damage_increased_health",
		icon_large = "skills_soaking_damage_increased_health_large",
		name_id = "skill_max_health_multiplier_name",
		stat_desc_id = "skill_max_health_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_max_health_multiplier_2",
		},
	}
	self.skills.max_health_multiplier_3 = {
		desc_id = "skill_max_health_multiplier_desc",
		icon = "skills_soaking_damage_increased_health",
		icon_large = "skills_soaking_damage_increased_health_large",
		name_id = "skill_max_health_multiplier_name",
		stat_desc_id = "skill_max_health_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_max_health_multiplier_3",
		},
	}
	self.skills.max_health_multiplier_4 = {
		desc_id = "skill_max_health_multiplier_desc",
		icon = "skills_soaking_damage_increased_health",
		icon_large = "skills_soaking_damage_increased_health_large",
		name_id = "skill_max_health_multiplier_name",
		stat_desc_id = "skill_max_health_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_max_health_multiplier_4",
		},
	}
	self.skills.pick_up_ammo_multiplier_1 = {
		desc_id = "skill_pick_up_ammo_multiplier_desc",
		icon = "skills_interaction_extra_ammo_pickups",
		icon_large = "skills_interaction_extra_ammo_pickups_large",
		name_id = "skill_pick_up_ammo_multiplier_name",
		stat_desc_id = "skill_pick_up_ammo_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_ammo_multiplier_1",
		},
	}
	self.skills.pick_up_ammo_multiplier_2 = {
		desc_id = "skill_pick_up_ammo_multiplier_desc",
		icon = "skills_interaction_extra_ammo_pickups",
		icon_large = "skills_interaction_extra_ammo_pickups_large",
		name_id = "skill_pick_up_ammo_multiplier_name",
		stat_desc_id = "skill_pick_up_ammo_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_ammo_multiplier_2",
		},
	}
	self.skills.pick_up_ammo_multiplier_3 = {
		desc_id = "skill_pick_up_ammo_multiplier_desc",
		icon = "skills_interaction_extra_ammo_pickups",
		icon_large = "skills_interaction_extra_ammo_pickups_large",
		name_id = "skill_pick_up_ammo_multiplier_name",
		stat_desc_id = "skill_pick_up_ammo_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_ammo_multiplier_3",
		},
	}
	self.skills.pick_up_ammo_multiplier_4 = {
		desc_id = "skill_pick_up_ammo_multiplier_desc",
		icon = "skills_interaction_extra_ammo_pickups",
		icon_large = "skills_interaction_extra_ammo_pickups_large",
		name_id = "skill_pick_up_ammo_multiplier_name",
		stat_desc_id = "skill_pick_up_ammo_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_ammo_multiplier_4",
		},
	}
	self.skills.pick_up_health_multiplier_mg42 = {
		desc_id = "skill_pick_up_health_multiplier_1_desc",
		name_id = "skill_pick_up_health_multiplier_1_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_health_multiplier_1",
			"mg42",
		},
	}
	self.skills.pick_up_health_multiplier_1 = {
		desc_id = "skill_pick_up_health_multiplier_desc",
		icon = "skills_interaction_extra_health_pickups",
		icon_large = "skills_interaction_extra_health_pickups_large",
		name_id = "skill_pick_up_health_multiplier_name",
		stat_desc_id = "skill_pick_up_health_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_health_multiplier_1",
		},
	}
	self.skills.pick_up_health_multiplier_2 = {
		desc_id = "skill_pick_up_health_multiplier_desc",
		icon = "skills_interaction_extra_health_pickups",
		icon_large = "skills_interaction_extra_health_pickups_large",
		name_id = "skill_pick_up_health_multiplier_name",
		stat_desc_id = "skill_pick_up_health_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_health_multiplier_2",
		},
	}
	self.skills.pick_up_health_multiplier_3 = {
		desc_id = "skill_pick_up_health_multiplier_desc",
		icon = "skills_interaction_extra_health_pickups",
		icon_large = "skills_interaction_extra_health_pickups_large",
		name_id = "skill_pick_up_health_multiplier_name",
		stat_desc_id = "skill_pick_up_health_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_health_multiplier_3",
		},
	}
	self.skills.pick_up_health_multiplier_4 = {
		desc_id = "skill_pick_up_health_multiplier_desc",
		icon = "skills_interaction_extra_health_pickups",
		icon_large = "skills_interaction_extra_health_pickups_large",
		name_id = "skill_pick_up_health_multiplier_name",
		stat_desc_id = "skill_pick_up_health_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_pick_up_health_multiplier_4",
		},
	}
	self.skills.primary_ammo_capacity_increase_1 = {
		desc_id = "skill_ammo_capacity_increase_desc",
		icon = "skills_special_skills_increase_prim_ammo_capacity",
		icon_large = "skills_special_skills_increase_prim_ammo_capacity_large",
		name_id = "skill_ammo_capacity_increase_name",
		stat_desc_id = "skill_ammo_capacity_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_primary_ammo_increase_1",
		},
	}
	self.skills.primary_ammo_capacity_increase_2 = {
		desc_id = "skill_ammo_capacity_increase_desc",
		icon = "skills_special_skills_increase_prim_ammo_capacity",
		icon_large = "skills_special_skills_increase_prim_ammo_capacity_large",
		name_id = "skill_ammo_capacity_increase_name",
		stat_desc_id = "skill_ammo_capacity_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_primary_ammo_increase_2",
		},
	}
	self.skills.primary_ammo_capacity_increase_3 = {
		desc_id = "skill_ammo_capacity_increase_desc",
		icon = "skills_special_skills_increase_prim_ammo_capacity",
		icon_large = "skills_special_skills_increase_prim_ammo_capacity_large",
		name_id = "skill_ammo_capacity_increase_name",
		stat_desc_id = "skill_ammo_capacity_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_primary_ammo_increase_3",
		},
	}
	self.skills.primary_ammo_capacity_increase_4 = {
		desc_id = "skill_ammo_capacity_increase_desc",
		icon = "skills_special_skills_increase_prim_ammo_capacity",
		icon_large = "skills_special_skills_increase_prim_ammo_capacity_large",
		name_id = "skill_ammo_capacity_increase_name",
		stat_desc_id = "skill_ammo_capacity_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_primary_ammo_increase_4",
		},
	}
	self.skills.secondary_ammo_capacity_increase_1 = {
		desc_id = "skill_secondary_ammo_capacity_increase_desc",
		icon = "skills_special_skills_increase_sec_ammo_capacity",
		icon_large = "skills_special_skills_increase_sec_ammo_capacity_large",
		name_id = "skill_secondary_ammo_capacity_increase_name",
		stat_desc_id = "skill_secondary_ammo_capacity_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_secondary_ammo_increase_1",
		},
	}
	self.skills.secondary_ammo_capacity_increase_2 = {
		desc_id = "skill_secondary_ammo_capacity_increase_desc",
		icon = "skills_special_skills_increase_sec_ammo_capacity",
		icon_large = "skills_special_skills_increase_sec_ammo_capacity_large",
		name_id = "skill_secondary_ammo_capacity_increase_name",
		stat_desc_id = "skill_secondary_ammo_capacity_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_secondary_ammo_increase_2",
		},
	}
	self.skills.secondary_ammo_capacity_increase_3 = {
		desc_id = "skill_secondary_ammo_capacity_increase_desc",
		icon = "skills_special_skills_increase_sec_ammo_capacity",
		icon_large = "skills_special_skills_increase_sec_ammo_capacity_large",
		name_id = "skill_secondary_ammo_capacity_increase_name",
		stat_desc_id = "skill_secondary_ammo_capacity_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_secondary_ammo_increase_3",
		},
	}
	self.skills.secondary_ammo_capacity_increase_4 = {
		desc_id = "skill_secondary_ammo_capacity_increase_desc",
		icon = "skills_special_skills_increase_sec_ammo_capacity",
		icon_large = "skills_special_skills_increase_sec_ammo_capacity_large",
		name_id = "skill_secondary_ammo_capacity_increase_name",
		stat_desc_id = "skill_secondary_ammo_capacity_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_secondary_ammo_increase_4",
		},
	}
	self.skills.reload_speed_multiplier_1 = {
		desc_id = "skill_reload_speed_multiplier_desc",
		icon = "skills_general_faster_reload",
		icon_large = "skills_general_faster_reload_large",
		name_id = "skill_reload_speed_multiplier_name",
		stat_desc_id = "skill_reload_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"primary_weapon_reload_speed_multiplier_1",
			"secondary_weapon_reload_speed_multiplier_1",
		},
	}
	self.skills.reload_speed_multiplier_2 = {
		desc_id = "skill_reload_speed_multiplier_desc",
		icon = "skills_general_faster_reload",
		icon_large = "skills_general_faster_reload_large",
		name_id = "skill_reload_speed_multiplier_name",
		stat_desc_id = "skill_reload_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"primary_weapon_reload_speed_multiplier_2",
			"secondary_weapon_reload_speed_multiplier_2",
		},
	}
	self.skills.reload_speed_multiplier_3 = {
		desc_id = "skill_reload_speed_multiplier_desc",
		icon = "skills_general_faster_reload",
		icon_large = "skills_general_faster_reload_large",
		name_id = "skill_reload_speed_multiplier_name",
		stat_desc_id = "skill_reload_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"primary_weapon_reload_speed_multiplier_3",
			"secondary_weapon_reload_speed_multiplier_3",
		},
	}
	self.skills.reload_speed_multiplier_4 = {
		desc_id = "skill_reload_speed_multiplier_desc",
		icon = "skills_general_faster_reload",
		icon_large = "skills_general_faster_reload_large",
		name_id = "skill_reload_speed_multiplier_name",
		stat_desc_id = "skill_reload_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"primary_weapon_reload_speed_multiplier_4",
			"secondary_weapon_reload_speed_multiplier_4",
		},
	}
	self.skills.increase_general_speed_1 = {
		desc_id = "skill_increase_general_speed_desc",
		icon = "skills_general_speed",
		icon_large = "skills_general_speed_large",
		name_id = "skill_increase_general_speed_name",
		stat_desc_id = "skill_increase_general_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_all_movement_speed_increase_1",
		},
	}
	self.skills.increase_general_speed_2 = {
		desc_id = "skill_increase_general_speed_desc",
		icon = "skills_general_speed",
		icon_large = "skills_general_speed_large",
		name_id = "skill_increase_general_speed_name",
		stat_desc_id = "skill_increase_general_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_all_movement_speed_increase_2",
		},
	}
	self.skills.increase_general_speed_3 = {
		desc_id = "skill_increase_general_speed_desc",
		icon = "skills_general_speed",
		icon_large = "skills_general_speed_large",
		name_id = "skill_increase_general_speed_name",
		stat_desc_id = "skill_increase_general_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_all_movement_speed_increase_3",
		},
	}
	self.skills.increase_general_speed_4 = {
		desc_id = "skill_increase_general_speed_desc",
		icon = "skills_general_speed",
		icon_large = "skills_general_speed_large",
		name_id = "skill_increase_general_speed_name",
		stat_desc_id = "skill_increase_general_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_all_movement_speed_increase_4",
		},
	}
	self.skills.increase_run_speed_1 = {
		desc_id = "skill_increase_run_speed_desc",
		icon = "skills_navigation_increase_run_speed",
		icon_large = "skills_navigation_increase_run_speed_large",
		name_id = "skill_increase_run_speed_name",
		stat_desc_id = "skill_increase_run_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_run_speed_increase_1",
		},
	}
	self.skills.increase_run_speed_2 = {
		desc_id = "skill_increase_run_speed_desc",
		icon = "skills_navigation_increase_run_speed",
		icon_large = "skills_navigation_increase_run_speed_large",
		name_id = "skill_increase_run_speed_name",
		stat_desc_id = "skill_increase_run_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_run_speed_increase_2",
		},
	}
	self.skills.increase_run_speed_3 = {
		desc_id = "skill_increase_run_speed_desc",
		icon = "skills_navigation_increase_run_speed",
		icon_large = "skills_navigation_increase_run_speed_large",
		name_id = "skill_increase_run_speed_name",
		stat_desc_id = "skill_increase_run_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_run_speed_increase_3",
		},
	}
	self.skills.increase_run_speed_4 = {
		desc_id = "skill_increase_run_speed_desc",
		icon = "skills_navigation_increase_run_speed",
		icon_large = "skills_navigation_increase_run_speed_large",
		name_id = "skill_increase_run_speed_name",
		stat_desc_id = "skill_increase_run_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_run_speed_increase_4",
		},
	}
	self.skills.increase_crouch_speed_1 = {
		desc_id = "skill_increase_crouch_speed_desc",
		icon = "skills_navigation_increase_crouch_speed",
		icon_large = "skills_navigation_increase_crouch_speed_large",
		name_id = "skill_increase_crouch_speed_name",
		stat_desc_id = "skill_increase_crouch_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_crouch_speed_increase_1",
		},
	}
	self.skills.increase_crouch_speed_2 = {
		desc_id = "skill_increase_crouch_speed_desc",
		icon = "skills_navigation_increase_crouch_speed",
		icon_large = "skills_navigation_increase_crouch_speed_large",
		name_id = "skill_increase_crouch_speed_name",
		stat_desc_id = "skill_increase_crouch_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_crouch_speed_increase_2",
		},
	}
	self.skills.increase_crouch_speed_3 = {
		desc_id = "skill_increase_crouch_speed_desc",
		icon = "skills_navigation_increase_crouch_speed",
		icon_large = "skills_navigation_increase_crouch_speed_large",
		name_id = "skill_increase_crouch_speed_name",
		stat_desc_id = "skill_increase_crouch_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_crouch_speed_increase_3",
		},
	}
	self.skills.increase_crouch_speed_4 = {
		desc_id = "skill_increase_crouch_speed_desc",
		icon = "skills_navigation_increase_crouch_speed",
		icon_large = "skills_navigation_increase_crouch_speed_large",
		name_id = "skill_increase_crouch_speed_name",
		stat_desc_id = "skill_increase_crouch_speed_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_crouch_speed_increase_4",
		},
	}
	self.skills.carry_penalty_decrease_1 = {
		desc_id = "skill_carry_penalty_decrease_desc",
		icon = "skills_navigation_move_faster_bags",
		icon_large = "skills_navigation_move_faster_bags_large",
		name_id = "skill_carry_penalty_decrease_name",
		stat_desc_id = "skill_carry_penalty_decrease_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_carry_penalty_decrease_1",
		},
	}
	self.skills.carry_penalty_decrease_2 = {
		desc_id = "skill_carry_penalty_decrease_desc",
		icon = "skills_navigation_move_faster_bags",
		icon_large = "skills_navigation_move_faster_bags_large",
		name_id = "skill_carry_penalty_decrease_name",
		stat_desc_id = "skill_carry_penalty_decrease_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_carry_penalty_decrease_2",
		},
	}
	self.skills.carry_penalty_decrease_3 = {
		desc_id = "skill_carry_penalty_decrease_desc",
		icon = "skills_navigation_move_faster_bags",
		icon_large = "skills_navigation_move_faster_bags_large",
		name_id = "skill_carry_penalty_decrease_name",
		stat_desc_id = "skill_carry_penalty_decrease_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_carry_penalty_decrease_3",
		},
	}
	self.skills.carry_penalty_decrease_4 = {
		desc_id = "skill_carry_penalty_decrease_desc",
		icon = "skills_navigation_move_faster_bags",
		icon_large = "skills_navigation_move_faster_bags_large",
		name_id = "skill_carry_penalty_decrease_name",
		stat_desc_id = "skill_carry_penalty_decrease_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_carry_penalty_decrease_4",
		},
	}
	self.skills.running_damage_reduction_1 = {
		desc_id = "skill_running_damage_reduction_desc",
		icon = "skills_soaking_damage_less_sprinting",
		icon_large = "skills_soaking_damage_less_sprinting_large",
		name_id = "skill_running_damage_reduction_name",
		stat_desc_id = "skill_running_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_running_damage_reduction_1",
		},
	}
	self.skills.running_damage_reduction_2 = {
		desc_id = "skill_running_damage_reduction_desc",
		icon = "skills_soaking_damage_less_sprinting",
		icon_large = "skills_soaking_damage_less_sprinting_large",
		name_id = "skill_running_damage_reduction_name",
		stat_desc_id = "skill_running_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_running_damage_reduction_2",
		},
	}
	self.skills.running_damage_reduction_3 = {
		desc_id = "skill_running_damage_reduction_desc",
		icon = "skills_soaking_damage_less_sprinting",
		icon_large = "skills_soaking_damage_less_sprinting_large",
		name_id = "skill_running_damage_reduction_name",
		stat_desc_id = "skill_running_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_running_damage_reduction_3",
		},
	}
	self.skills.running_damage_reduction_4 = {
		desc_id = "skill_running_damage_reduction_desc",
		icon = "skills_soaking_damage_less_sprinting",
		icon_large = "skills_soaking_damage_less_sprinting_large",
		name_id = "skill_running_damage_reduction_name",
		stat_desc_id = "skill_running_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_running_damage_reduction_4",
		},
	}
	self.skills.crouching_damage_reduction_1 = {
		desc_id = "skill_crouching_damage_reduction_desc",
		icon = "skills_soaking_damage_less_while_crouch",
		icon_large = "skills_soaking_damage_less_while_crouch_large",
		name_id = "skill_crouching_damage_reduction_name",
		stat_desc_id = "skill_crouching_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_crouching_damage_reduction_1",
		},
	}
	self.skills.crouching_damage_reduction_2 = {
		desc_id = "skill_crouching_damage_reduction_desc",
		icon = "skills_soaking_damage_less_while_crouch",
		icon_large = "skills_soaking_damage_less_while_crouch_large",
		name_id = "skill_crouching_damage_reduction_name",
		stat_desc_id = "skill_crouching_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_crouching_damage_reduction_2",
		},
	}
	self.skills.crouching_damage_reduction_3 = {
		desc_id = "skill_crouching_damage_reduction_desc",
		icon = "skills_soaking_damage_less_while_crouch",
		icon_large = "skills_soaking_damage_less_while_crouch_large",
		name_id = "skill_crouching_damage_reduction_name",
		stat_desc_id = "skill_crouching_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_crouching_damage_reduction_3",
		},
	}
	self.skills.crouching_damage_reduction_4 = {
		desc_id = "skill_crouching_damage_reduction_desc",
		icon = "skills_soaking_damage_less_while_crouch",
		icon_large = "skills_soaking_damage_less_while_crouch_large",
		name_id = "skill_crouching_damage_reduction_name",
		stat_desc_id = "skill_crouching_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_crouching_damage_reduction_4",
		},
	}
	self.skills.interacting_damage_reduction_1 = {
		desc_id = "skill_interacting_damage_reduction_desc",
		icon = "skills_interaction_less_damage_interact",
		icon_large = "skills_interaction_less_damage_interact_large",
		name_id = "skill_interacting_damage_reduction_name",
		stat_desc_id = "skill_interacting_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_interacting_damage_reduction_1",
		},
	}
	self.skills.interacting_damage_reduction_2 = {
		desc_id = "skill_interacting_damage_reduction_desc",
		icon = "skills_interaction_less_damage_interact",
		icon_large = "skills_interaction_less_damage_interact_large",
		name_id = "skill_interacting_damage_reduction_name",
		stat_desc_id = "skill_interacting_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_interacting_damage_reduction_2",
		},
	}
	self.skills.interacting_damage_reduction_3 = {
		desc_id = "skill_interacting_damage_reduction_desc",
		icon = "skills_interaction_less_damage_interact",
		icon_large = "skills_interaction_less_damage_interact_large",
		name_id = "skill_interacting_damage_reduction_name",
		stat_desc_id = "skill_interacting_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_interacting_damage_reduction_3",
		},
	}
	self.skills.interacting_damage_reduction_4 = {
		desc_id = "skill_interacting_damage_reduction_desc",
		icon = "skills_interaction_less_damage_interact",
		icon_large = "skills_interaction_less_damage_interact_large",
		name_id = "skill_interacting_damage_reduction_name",
		stat_desc_id = "skill_interacting_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_interacting_damage_reduction_4",
		},
	}
	self.skills.bullet_damage_reduction_1 = {
		desc_id = "skill_bullet_damage_reduction_desc",
		icon = "skills_general_resist",
		icon_large = "skills_general_resist_large",
		name_id = "skill_bullet_damage_reduction_name",
		stat_desc_id = "skill_bullet_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_bullet_damage_reduction_1",
		},
	}
	self.skills.bullet_damage_reduction_2 = {
		desc_id = "skill_bullet_damage_reduction_desc",
		icon = "skills_general_resist",
		icon_large = "skills_general_resist_large",
		name_id = "skill_bullet_damage_reduction_name",
		stat_desc_id = "skill_bullet_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_bullet_damage_reduction_2",
		},
	}
	self.skills.bullet_damage_reduction_3 = {
		desc_id = "skill_bullet_damage_reduction_desc",
		icon = "skills_general_resist",
		icon_large = "skills_general_resist_large",
		name_id = "skill_bullet_damage_reduction_name",
		stat_desc_id = "skill_bullet_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_bullet_damage_reduction_3",
		},
	}
	self.skills.bullet_damage_reduction_4 = {
		desc_id = "skill_bullet_damage_reduction_desc",
		icon = "skills_general_resist",
		icon_large = "skills_general_resist_large",
		name_id = "skill_bullet_damage_reduction_name",
		stat_desc_id = "skill_bullet_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_bullet_damage_reduction_4",
		},
	}
	self.skills.melee_damage_reduction_1 = {
		desc_id = "skill_melee_damage_reduction_desc",
		icon = "skills_soaking_damage_less_melee",
		icon_large = "skills_soaking_damage_less_melee_large",
		name_id = "skill_melee_damage_reduction_name",
		stat_desc_id = "skill_melee_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_melee_damage_reduction_1",
		},
	}
	self.skills.melee_damage_reduction_2 = {
		desc_id = "skill_melee_damage_reduction_desc",
		icon = "skills_soaking_damage_less_melee",
		icon_large = "skills_soaking_damage_less_melee_large",
		name_id = "skill_melee_damage_reduction_name",
		stat_desc_id = "skill_melee_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_melee_damage_reduction_2",
		},
	}
	self.skills.melee_damage_reduction_3 = {
		desc_id = "skill_melee_damage_reduction_desc",
		icon = "skills_soaking_damage_less_melee",
		icon_large = "skills_soaking_damage_less_melee_large",
		name_id = "skill_melee_damage_reduction_name",
		stat_desc_id = "skill_melee_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_melee_damage_reduction_3",
		},
	}
	self.skills.melee_damage_reduction_4 = {
		desc_id = "skill_melee_damage_reduction_desc",
		icon = "skills_soaking_damage_less_melee",
		icon_large = "skills_soaking_damage_less_melee_large",
		name_id = "skill_melee_damage_reduction_name",
		stat_desc_id = "skill_melee_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_melee_damage_reduction_4",
		},
	}
	self.skills.headshot_damage_multiplier_1 = {
		desc_id = "skill_headshot_damage_multiplier_desc",
		icon = "skills_dealing_damage_headshot_multiplier",
		icon_large = "skills_dealing_damage_headshot_multiplier_large",
		name_id = "skill_headshot_damage_multiplier_name",
		stat_desc_id = "skill_headshot_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_headshot_damage_multiplier_1",
		},
	}
	self.skills.headshot_damage_multiplier_2 = {
		desc_id = "skill_headshot_damage_multiplier_desc",
		icon = "skills_dealing_damage_headshot_multiplier",
		icon_large = "skills_dealing_damage_headshot_multiplier_large",
		name_id = "skill_headshot_damage_multiplier_name",
		stat_desc_id = "skill_headshot_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_headshot_damage_multiplier_2",
		},
	}
	self.skills.headshot_damage_multiplier_3 = {
		desc_id = "skill_headshot_damage_multiplier_desc",
		icon = "skills_dealing_damage_headshot_multiplier",
		icon_large = "skills_dealing_damage_headshot_multiplier_large",
		name_id = "skill_headshot_damage_multiplier_name",
		stat_desc_id = "skill_headshot_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_headshot_damage_multiplier_3",
		},
	}
	self.skills.headshot_damage_multiplier_4 = {
		desc_id = "skill_headshot_damage_multiplier_desc",
		icon = "skills_dealing_damage_headshot_multiplier",
		icon_large = "skills_dealing_damage_headshot_multiplier_large",
		name_id = "skill_headshot_damage_multiplier_name",
		stat_desc_id = "skill_headshot_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_headshot_damage_multiplier_4",
		},
	}
	self.skills.melee_damage_multiplier_1 = {
		desc_id = "skill_melee_damage_multiplier_desc",
		icon = "skills_dealing_damage_melee_multiplier",
		icon_large = "skills_dealing_damage_melee_multiplier_large",
		name_id = "skill_melee_damage_multiplier_name",
		stat_desc_id = "skill_melee_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_melee_damage_multiplier_1",
		},
	}
	self.skills.melee_damage_multiplier_2 = {
		desc_id = "skill_melee_damage_multiplier_desc",
		icon = "skills_dealing_damage_melee_multiplier",
		icon_large = "skills_dealing_damage_melee_multiplier_large",
		name_id = "skill_melee_damage_multiplier_name",
		stat_desc_id = "skill_melee_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_melee_damage_multiplier_2",
		},
	}
	self.skills.melee_damage_multiplier_3 = {
		desc_id = "skill_melee_damage_multiplier_desc",
		icon = "skills_dealing_damage_melee_multiplier",
		icon_large = "skills_dealing_damage_melee_multiplier_large",
		name_id = "skill_melee_damage_multiplier_name",
		stat_desc_id = "skill_melee_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_melee_damage_multiplier_3",
		},
	}
	self.skills.highlight_enemy_damage_bonus_1 = {
		desc_id = "skill_highlight_enemy_damage_bonus_desc",
		icon = "skills_dealing_damage_tagged_enemies",
		icon_large = "skills_dealing_damage_tagged_enemies_large",
		name_id = "skill_highlight_enemy_damage_bonus_name",
		stat_desc_id = "skill_highlight_enemy_damage_bonus_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_highlight_enemy_damage_bonus_1",
		},
	}
	self.skills.highlight_enemy_damage_bonus_2 = {
		desc_id = "skill_highlight_enemy_damage_bonus_desc",
		icon = "skills_dealing_damage_tagged_enemies",
		icon_large = "skills_dealing_damage_tagged_enemies_large",
		name_id = "skill_highlight_enemy_damage_bonus_name",
		stat_desc_id = "skill_highlight_enemy_damage_bonus_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_highlight_enemy_damage_bonus_2",
		},
	}
	self.skills.highlight_enemy_damage_bonus_3 = {
		desc_id = "skill_highlight_enemy_damage_bonus_desc",
		icon = "skills_dealing_damage_tagged_enemies",
		icon_large = "skills_dealing_damage_tagged_enemies_large",
		name_id = "skill_highlight_enemy_damage_bonus_name",
		stat_desc_id = "skill_highlight_enemy_damage_bonus_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_highlight_enemy_damage_bonus_3",
		},
	}
	self.skills.highlight_enemy_damage_bonus_4 = {
		desc_id = "skill_highlight_enemy_damage_bonus_desc",
		icon = "skills_dealing_damage_tagged_enemies",
		icon_large = "skills_dealing_damage_tagged_enemies_large",
		name_id = "skill_highlight_enemy_damage_bonus_name",
		stat_desc_id = "skill_highlight_enemy_damage_bonus_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_highlight_enemy_damage_bonus_4",
		},
	}
	self.skills.on_hit_flinch_reduction_1 = {
		desc_id = "skill_on_hit_flinch_reduction_desc",
		icon = "skills_weapons_reduce_flinch_when_hit",
		icon_large = "skills_weapons_reduce_flinch_when_hit_large",
		name_id = "skill_on_hit_flinch_reduction_name",
		stat_desc_id = "skill_on_hit_flinch_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_on_hit_flinch_reduction_1",
		},
	}
	self.skills.on_hit_flinch_reduction_2 = {
		desc_id = "skill_on_hit_flinch_reduction_desc",
		icon = "skills_weapons_reduce_flinch_when_hit",
		icon_large = "skills_weapons_reduce_flinch_when_hit_large",
		name_id = "skill_on_hit_flinch_reduction_name",
		stat_desc_id = "skill_on_hit_flinch_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_on_hit_flinch_reduction_2",
		},
	}
	self.skills.on_hit_flinch_reduction_3 = {
		desc_id = "skill_on_hit_flinch_reduction_desc",
		icon = "skills_weapons_reduce_flinch_when_hit",
		icon_large = "skills_weapons_reduce_flinch_when_hit_large",
		name_id = "skill_on_hit_flinch_reduction_name",
		stat_desc_id = "skill_on_hit_flinch_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_on_hit_flinch_reduction_3",
		},
	}
	self.skills.on_hit_flinch_reduction_4 = {
		desc_id = "skill_on_hit_flinch_reduction_desc",
		icon = "skills_weapons_reduce_flinch_when_hit",
		icon_large = "skills_weapons_reduce_flinch_when_hit_large",
		name_id = "skill_on_hit_flinch_reduction_name",
		stat_desc_id = "skill_on_hit_flinch_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_on_hit_flinch_reduction_4",
		},
	}
	self.skills.swap_speed_multiplier_1 = {
		desc_id = "skill_swap_speed_multiplier_desc",
		icon = "skills_weapons_switch_faster",
		icon_large = "skills_weapons_switch_faster_large",
		name_id = "skill_swap_speed_multiplier_name",
		stat_desc_id = "skill_swap_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_swap_speed_multiplier_1",
		},
	}
	self.skills.swap_speed_multiplier_2 = {
		desc_id = "skill_swap_speed_multiplier_desc",
		icon = "skills_weapons_switch_faster",
		icon_large = "skills_weapons_switch_faster_large",
		name_id = "skill_swap_speed_multiplier_name",
		stat_desc_id = "skill_swap_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_swap_speed_multiplier_2",
		},
	}
	self.skills.swap_speed_multiplier_3 = {
		desc_id = "skill_swap_speed_multiplier_desc",
		icon = "skills_weapons_switch_faster",
		icon_large = "skills_weapons_switch_faster_large",
		name_id = "skill_swap_speed_multiplier_name",
		stat_desc_id = "skill_swap_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_swap_speed_multiplier_3",
		},
	}
	self.skills.swap_speed_multiplier_4 = {
		desc_id = "skill_swap_speed_multiplier_desc",
		icon = "skills_weapons_switch_faster",
		icon_large = "skills_weapons_switch_faster_large",
		name_id = "skill_swap_speed_multiplier_name",
		stat_desc_id = "skill_swap_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_swap_speed_multiplier_4",
		},
	}
	self.skills.ready_weapon_speed_multiplier_1 = {
		desc_id = "skill_ready_weapon_speed_multiplier_desc",
		icon = "skills_weapons_ready_faster_after_sprint",
		icon_large = "skills_weapons_ready_faster_after_sprint_large",
		name_id = "skill_ready_weapon_speed_multiplier_name",
		stat_desc_id = "skill_ready_weapon_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_ready_weapon_speed_multiplier_1",
		},
	}
	self.skills.ready_weapon_speed_multiplier_2 = {
		desc_id = "skill_ready_weapon_speed_multiplier_desc",
		icon = "skills_weapons_ready_faster_after_sprint",
		icon_large = "skills_weapons_ready_faster_after_sprint_large",
		name_id = "skill_ready_weapon_speed_multiplier_name",
		stat_desc_id = "skill_ready_weapon_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_ready_weapon_speed_multiplier_2",
		},
	}
	self.skills.ready_weapon_speed_multiplier_3 = {
		desc_id = "skill_ready_weapon_speed_multiplier_desc",
		icon = "skills_weapons_ready_faster_after_sprint",
		icon_large = "skills_weapons_ready_faster_after_sprint_large",
		name_id = "skill_ready_weapon_speed_multiplier_name",
		stat_desc_id = "skill_ready_weapon_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_ready_weapon_speed_multiplier_3",
		},
	}
	self.skills.ready_weapon_speed_multiplier_4 = {
		desc_id = "skill_ready_weapon_speed_multiplier_desc",
		icon = "skills_weapons_ready_faster_after_sprint",
		icon_large = "skills_weapons_ready_faster_after_sprint_large",
		name_id = "skill_ready_weapon_speed_multiplier_name",
		stat_desc_id = "skill_ready_weapon_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_ready_weapon_speed_multiplier_4",
		},
	}
	self.skills.wheel_hotspot_increase_1 = {
		desc_id = "skill_wheel_hotspot_increase_desc",
		icon = "skills_interaction_wheel_hotspots_larger",
		icon_large = "skills_interaction_wheel_hotspots_larger_large",
		name_id = "skill_wheel_hotspot_increase_name",
		stat_desc_id = "skill_wheel_hotspot_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_hotspot_increase_1",
		},
	}
	self.skills.wheel_hotspot_increase_2 = {
		desc_id = "skill_wheel_hotspot_increase_desc",
		icon = "skills_interaction_wheel_hotspots_larger",
		icon_large = "skills_interaction_wheel_hotspots_larger_large",
		name_id = "skill_wheel_hotspot_increase_name",
		stat_desc_id = "skill_wheel_hotspot_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_hotspot_increase_2",
		},
	}
	self.skills.wheel_hotspot_increase_3 = {
		desc_id = "skill_wheel_hotspot_increase_desc",
		icon = "skills_interaction_wheel_hotspots_larger",
		icon_large = "skills_interaction_wheel_hotspots_larger_large",
		name_id = "skill_wheel_hotspot_increase_name",
		stat_desc_id = "skill_wheel_hotspot_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_hotspot_increase_3",
		},
	}
	self.skills.wheel_hotspot_increase_4 = {
		desc_id = "skill_wheel_hotspot_increase_desc",
		icon = "skills_interaction_wheel_hotspots_larger",
		icon_large = "skills_interaction_wheel_hotspots_larger_large",
		name_id = "skill_wheel_hotspot_increase_name",
		stat_desc_id = "skill_wheel_hotspot_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_hotspot_increase_4",
		},
	}
	self.skills.wheel_rotation_speed_increase_1 = {
		desc_id = "skill_wheel_rotation_speed_increase_desc",
		icon = "skills_interaction_wheels_turn_faster",
		icon_large = "skills_interaction_wheels_turn_faster_large",
		name_id = "skill_wheel_rotation_speed_increase_name",
		stat_desc_id = "skill_wheel_rotation_speed_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_rotation_speed_increase_1",
		},
	}
	self.skills.wheel_rotation_speed_increase_2 = {
		desc_id = "skill_wheel_rotation_speed_increase_desc",
		icon = "skills_interaction_wheels_turn_faster",
		icon_large = "skills_interaction_wheels_turn_faster_large",
		name_id = "skill_wheel_rotation_speed_increase_name",
		stat_desc_id = "skill_wheel_rotation_speed_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_rotation_speed_increase_2",
		},
	}
	self.skills.wheel_rotation_speed_increase_3 = {
		desc_id = "skill_wheel_rotation_speed_increase_desc",
		icon = "skills_interaction_wheels_turn_faster",
		icon_large = "skills_interaction_wheels_turn_faster_large",
		name_id = "skill_wheel_rotation_speed_increase_name",
		stat_desc_id = "skill_wheel_rotation_speed_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_rotation_speed_increase_3",
		},
	}
	self.skills.wheel_rotation_speed_increase_4 = {
		desc_id = "skill_wheel_rotation_speed_increase_desc",
		icon = "skills_interaction_wheels_turn_faster",
		icon_large = "skills_interaction_wheels_turn_faster_large",
		name_id = "skill_wheel_rotation_speed_increase_name",
		stat_desc_id = "skill_wheel_rotation_speed_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_rotation_speed_increase_4",
		},
	}
	self.skills.wheel_amount_decrease_1 = {
		desc_id = "skill_wheel_amount_decrease_desc",
		icon = "skills_interaction_one_fewer_wheel",
		icon_large = "skills_interaction_one_fewer_wheel_large",
		name_id = "skill_wheel_amount_decrease_name",
		stat_desc_id = "skill_wheel_amount_decrease_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_amount_decrease_1",
		},
	}
	self.skills.wheel_amount_decrease_2 = {
		desc_id = "skill_wheel_amount_decrease_desc",
		icon = "skills_interaction_one_fewer_wheel",
		icon_large = "skills_interaction_one_fewer_wheel_large",
		name_id = "skill_wheel_amount_decrease_name",
		stat_desc_id = "skill_wheel_amount_decrease_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_wheel_amount_decrease_2",
		},
	}
	self.skills.weapon_tier_unlocked_2 = {
		desc_id = "skill_weapon_tier_unlocked_2_desc",
		icon = "skills_weapon_tier_2",
		icon_large = "skills_weapon_tier_2_large",
		name_id = "skill_weapon_tier_unlocked_2_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_weapon_tier_unlocked_2",
		},
	}
	self.skills.weapon_tier_unlocked_3 = {
		desc_id = "skill_weapon_tier_unlocked_3_desc",
		icon = "skills_weapon_tier_3",
		icon_large = "skills_weapon_tier_3_large",
		name_id = "skill_weapon_tier_unlocked_3_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_weapon_tier_unlocked_3",
		},
	}
	self.skills.weapon_tier_unlocked_4 = {
		desc_id = "skill_weapon_tier_unlocked_4_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4_large",
		name_id = "skill_weapon_tier_unlocked_4_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_weapon_tier_unlocked_4",
		},
	}
	self.skills.recon_tier_4_unlocked = {
		desc_id = "skill_recon_tier_4_unlocked_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4_large",
		name_id = "skill_recon_tier_4_unlocked_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_recon_tier_4_unlocked",
		},
	}
	self.skills.assault_tier_4_unlocked = {
		desc_id = "skill_assault_tier_4_unlocked_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4_large",
		name_id = "skill_assault_tier_4_unlocked_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_assault_tier_4_unlocked",
		},
	}
	self.skills.infiltrator_tier_4_unlocked = {
		desc_id = "skill_infiltrator_tier_4_unlocked_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4_large",
		name_id = "skill_infiltrator_tier_4_unlocked_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_infiltrator_tier_4_unlocked",
		},
	}
	self.skills.demolitions_tier_4_unlocked = {
		desc_id = "skill_demolitions_tier_4_unlocked_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4_large",
		name_id = "skill_demolitions_tier_4_unlocked_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_demolitions_tier_4_unlocked",
		},
	}
	self.skills.weapon_unlock_springfield = {
		desc_id = "skill_weapon_unlock_springfield_desc",
		name_id = "skill_weapon_unlock_springfield_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"m1903",
		},
	}
	self.skills.weapon_unlock_m1911 = {
		desc_id = "skill_weapon_unlock_m1911_desc",
		name_id = "skill_weapon_unlock_m1911_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"m1911",
		},
	}
	self.skills.weapon_unlock_c96 = {
		desc_id = "skill_weapon_unlock_c96_desc",
		name_id = "skill_weapon_unlock_c96_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"c96",
		},
	}
	self.skills.weapon_unlock_webley = {
		desc_id = "skill_weapon_unlock_webley_desc",
		name_id = "skill_weapon_unlock_webley_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"webley",
		},
	}
	self.skills.weapon_unlock_sten = {
		desc_id = "skill_weapon_unlock_sten_desc",
		name_id = "skill_weapon_unlock_sten_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"sten",
		},
	}
	self.skills.weapon_unlock_mp38 = {
		desc_id = "skill_weapon_unlock_mp38_desc",
		name_id = "skill_weapon_unlock_mp38_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"mp38",
		},
	}
	self.skills.weapon_unlock_thompson = {
		desc_id = "skill_weapon_unlock_thompson_desc",
		name_id = "skill_weapon_unlock_thompson_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"thompson",
		},
	}
	self.skills.weapon_unlock_garand = {
		desc_id = "skill_weapon_unlock_garand_desc",
		name_id = "skill_weapon_unlock_garand_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"garand",
		},
	}
	self.skills.weapon_unlock_garand_golden = {
		desc_id = "skill_weapon_unlock_garand_golden_desc",
		name_id = "skill_weapon_unlock_garand_golden_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"garand_golden",
		},
	}
	self.skills.weapon_unlock_winchester = {
		desc_id = "skill_weapon_unlock_winchester_desc",
		name_id = "skill_weapon_unlock_winchester_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"m1912",
		},
	}
	self.skills.weapon_unlock_sterling = {
		desc_id = "skill_weapon_unlock_sterling_desc",
		name_id = "skill_weapon_unlock_sterling_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"sterling",
		},
	}
	self.skills.weapon_unlock_bar = {
		desc_id = "skill_weapon_unlock_bar_desc",
		name_id = "skill_weapon_unlock_bar_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"m1918",
		},
	}
	self.skills.weapon_unlock_mp44 = {
		desc_id = "skill_weapon_unlock_mp44_desc",
		name_id = "skill_weapon_unlock_mp44_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"mp44",
		},
	}
	self.skills.weapon_unlock_mosin = {
		desc_id = "skill_weapon_unlock_mosin_desc",
		name_id = "skill_weapon_unlock_mosin_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"mosin",
		},
	}
	self.skills.weapon_unlock_carbine = {
		desc_id = "skill_weapon_unlock_carbine_desc",
		name_id = "skill_weapon_unlock_carbine_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"carbine",
		},
	}
	self.skills.weapon_unlock_mg42 = {
		desc_id = "skill_weapon_unlock_mg42_desc",
		name_id = "skill_weapon_unlock_mg42_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"mg42",
		},
	}
	self.skills.weapon_unlock_geco = {
		desc_id = "skill_weapon_unlock_geco_desc",
		name_id = "skill_weapon_unlock_geco_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"geco",
		},
	}
	self.skills.pistol_damage_multiplier_1 = {
		desc_id = "skill_pistol_damage_multiplier_desc",
		icon = "skills_dealing_damage_pistol_multiplier",
		icon_large = "skills_dealing_damage_pistol_multiplier_large",
		name_id = "skill_pistol_damage_multiplier_name",
		stat_desc_id = "skill_pistol_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"pistol_damage_multiplier_1",
		},
	}
	self.skills.pistol_damage_multiplier_2 = {
		desc_id = "skill_pistol_damage_multiplier_desc",
		icon = "skills_dealing_damage_pistol_multiplier",
		icon_large = "skills_dealing_damage_pistol_multiplier_large",
		name_id = "skill_pistol_damage_multiplier_name",
		stat_desc_id = "skill_pistol_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"pistol_damage_multiplier_2",
		},
	}
	self.skills.shotgun_damage_multiplier_1 = {
		desc_id = "skill_shotgun_damage_multiplier_desc",
		icon = "skills_dealing_damage_shotgun_multiplier",
		icon_large = "skills_dealing_damage_shotgun_multiplier_large",
		name_id = "skill_shotgun_damage_multiplier_name",
		stat_desc_id = "skill_shotgun_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"shotgun_damage_multiplier_1",
		},
	}
	self.skills.shotgun_damage_multiplier_2 = {
		desc_id = "skill_shotgun_damage_multiplier_desc",
		icon = "skills_dealing_damage_shotgun_multiplier",
		icon_large = "skills_dealing_damage_shotgun_multiplier_large",
		name_id = "skill_shotgun_damage_multiplier_name",
		stat_desc_id = "skill_shotgun_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"shotgun_damage_multiplier_2",
		},
	}
	self.skills.shotgun_damage_multiplier_3 = {
		desc_id = "skill_shotgun_damage_multiplier_desc",
		icon = "skills_dealing_damage_shotgun_multiplier",
		icon_large = "skills_dealing_damage_shotgun_multiplier_large",
		name_id = "skill_shotgun_damage_multiplier_name",
		stat_desc_id = "skill_shotgun_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"shotgun_damage_multiplier_3",
		},
	}
	self.skills.smg_damage_multiplier_1 = {
		desc_id = "skill_smg_damage_multiplier_desc",
		icon = "skills_dealing_damage_smg_multiplier",
		icon_large = "skills_dealing_damage_smg_multiplier_large",
		name_id = "skill_smg_damage_multiplier_name",
		stat_desc_id = "skill_smg_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"smg_damage_multiplier_1",
		},
	}
	self.skills.smg_damage_multiplier_2 = {
		desc_id = "skill_smg_damage_multiplier_desc",
		icon = "skills_dealing_damage_smg_multiplier",
		icon_large = "skills_dealing_damage_smg_multiplier_large",
		name_id = "skill_smg_damage_multiplier_name",
		stat_desc_id = "skill_smg_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"smg_damage_multiplier_2",
		},
	}
	self.skills.smg_damage_multiplier_3 = {
		desc_id = "skill_smg_damage_multiplier_desc",
		icon = "skills_dealing_damage_smg_multiplier",
		icon_large = "skills_dealing_damage_smg_multiplier_large",
		name_id = "skill_smg_damage_multiplier_name",
		stat_desc_id = "skill_smg_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"smg_damage_multiplier_3",
		},
	}
	self.skills.assault_rifle_damage_multiplier_1 = {
		desc_id = "skill_assault_rifle_damage_multiplier_desc",
		icon = "skills_dealing_damage_assault_rifle_multiplier",
		icon_large = "skills_dealing_damage_assault_rifle_multiplier_large",
		name_id = "skill_assault_rifle_damage_multiplier_name",
		stat_desc_id = "skill_assault_rifle_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"assault_rifle_damage_multiplier_1",
		},
	}
	self.skills.assault_rifle_damage_multiplier_2 = {
		desc_id = "skill_assault_rifle_damage_multiplier_desc",
		icon = "skills_dealing_damage_assault_rifle_multiplier",
		icon_large = "skills_dealing_damage_assault_rifle_multiplier_large",
		name_id = "skill_assault_rifle_damage_multiplier_name",
		stat_desc_id = "skill_assault_rifle_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"assault_rifle_damage_multiplier_2",
		},
	}
	self.skills.assault_rifle_damage_multiplier_3 = {
		desc_id = "skill_assault_rifle_damage_multiplier_desc",
		icon = "skills_dealing_damage_assault_rifle_multiplier",
		icon_large = "skills_dealing_damage_assault_rifle_multiplier_large",
		name_id = "skill_assault_rifle_damage_multiplier_name",
		stat_desc_id = "skill_assault_rifle_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"assault_rifle_damage_multiplier_3",
		},
	}
	self.skills.lmg_damage_multiplier_1 = {
		desc_id = "skill_lmg_damage_multiplier_desc",
		icon = "skills_dealing_damage_heavy_multiplier",
		icon_large = "skills_dealing_damage_heavy_multiplier_large",
		name_id = "skill_lmg_damage_multiplier_name",
		stat_desc_id = "skill_lmg_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"lmg_damage_multiplier_1",
		},
	}
	self.skills.lmg_damage_multiplier_2 = {
		desc_id = "skill_lmg_damage_multiplier_desc",
		icon = "skills_dealing_damage_heavy_multiplier",
		icon_large = "skills_dealing_damage_heavy_multiplier_large",
		name_id = "skill_lmg_damage_multiplier_name",
		stat_desc_id = "skill_lmg_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"lmg_damage_multiplier_2",
		},
	}
	self.skills.lmg_damage_multiplier_3 = {
		desc_id = "skill_lmg_damage_multiplier_desc",
		icon = "skills_dealing_damage_heavy_multiplier",
		icon_large = "skills_dealing_damage_heavy_multiplier_large",
		name_id = "skill_lmg_damage_multiplier_name",
		stat_desc_id = "skill_lmg_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"lmg_damage_multiplier_3",
		},
	}
	self.skills.sniper_damage_multiplier_1 = {
		desc_id = "skill_sniper_damage_multiplier_desc",
		icon = "skills_dealing_damage_snp_multiplier",
		icon_large = "skills_dealing_damage_snp_multiplier_large",
		name_id = "skill_sniper_damage_multiplier_name",
		stat_desc_id = "skill_sniper_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"snp_damage_multiplier_1",
		},
	}
	self.skills.sniper_damage_multiplier_2 = {
		desc_id = "skill_sniper_damage_multiplier_desc",
		icon = "skills_dealing_damage_snp_multiplier",
		icon_large = "skills_dealing_damage_snp_multiplier_large",
		name_id = "skill_sniper_damage_multiplier_name",
		stat_desc_id = "skill_sniper_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"snp_damage_multiplier_2",
		},
	}
	self.skills.sniper_damage_multiplier_3 = {
		desc_id = "skill_sniper_damage_multiplier_desc",
		icon = "skills_dealing_damage_snp_multiplier",
		icon_large = "skills_dealing_damage_snp_multiplier_large",
		name_id = "skill_sniper_damage_multiplier_name",
		stat_desc_id = "skill_sniper_damage_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"snp_damage_multiplier_3",
		},
	}
	self.skills.grenade_quantity_1 = {
		desc_id = "skill_grenade_quantity_desc",
		icon = "skills_weapons_carry_extra_granade",
		icon_large = "skills_weapons_carry_extra_granade_large",
		name_id = "skill_grenade_quantity_name",
		stat_desc_id = "skill_grenade_quantity_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_m24_quantity_1",
		},
	}
	self.skills.grenade_quantity_2 = {
		desc_id = "skill_grenade_quantity_desc",
		icon = "skills_weapons_carry_extra_granade",
		icon_large = "skills_weapons_carry_extra_granade_large",
		name_id = "skill_grenade_quantity_name",
		stat_desc_id = "skill_grenade_quantity_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_m24_quantity_2",
		},
	}
	self.skills.turret_reduced_overheat_1 = {
		desc_id = "skill_turret_reduced_overheat_desc",
		icon = "skills_special_skills_mounted_guns_overheat",
		icon_large = "skills_special_skills_mounted_guns_overheat_large",
		name_id = "skill_turret_reduced_overheat_name",
		stat_desc_id = "skill_turret_reduced_overheat_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_turret_m2_overheat_reduction_1",
			"player_turret_flakvierling_overheat_reduction_1",
		},
	}
	self.skills.turret_reduced_overheat_2 = {
		desc_id = "skill_turret_reduced_overheat_desc",
		icon = "skills_special_skills_mounted_guns_overheat",
		icon_large = "skills_special_skills_mounted_guns_overheat_large",
		name_id = "skill_turret_reduced_overheat_name",
		stat_desc_id = "skill_turret_reduced_overheat_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_turret_m2_overheat_reduction_2",
			"player_turret_flakvierling_overheat_reduction_2",
		},
	}
	self.skills.turret_reduced_overheat_3 = {
		desc_id = "skill_turret_reduced_overheat_desc",
		icon = "skills_special_skills_mounted_guns_overheat",
		icon_large = "skills_special_skills_mounted_guns_overheat_large",
		name_id = "skill_turret_reduced_overheat_name",
		stat_desc_id = "skill_turret_reduced_overheat_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_turret_m2_overheat_reduction_3",
			"player_turret_flakvierling_overheat_reduction_3",
		},
	}
	self.skills.turret_reduced_overheat_4 = {
		desc_id = "skill_turret_reduced_overheat_desc",
		icon = "skills_special_skills_mounted_guns_overheat",
		icon_large = "skills_special_skills_mounted_guns_overheat_large",
		name_id = "skill_turret_reduced_overheat_name",
		stat_desc_id = "skill_turret_reduced_overheat_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_turret_m2_overheat_reduction_4",
			"player_turret_flakvierling_overheat_reduction_4",
		},
	}
	self.skills.revived_damage_reduction_1 = {
		desc_id = "skill_revived_damage_reduction_desc",
		icon = "skills_soaking_damage_less_after_revive",
		icon_large = "skills_soaking_damage_less_after_revive_large",
		name_id = "skill_revived_damage_reduction_name",
		stat_desc_id = "skill_revived_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"temporary_on_revived_damage_reduction_1",
		},
	}
	self.skills.revived_damage_reduction_2 = {
		desc_id = "skill_revived_damage_reduction_desc",
		icon = "skills_soaking_damage_less_after_revive",
		icon_large = "skills_soaking_damage_less_after_revive_large",
		name_id = "skill_revived_damage_reduction_name",
		stat_desc_id = "skill_revived_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"temporary_on_revived_damage_reduction_2",
		},
	}
	self.skills.revived_damage_reduction_3 = {
		desc_id = "skill_revived_damage_reduction_desc",
		icon = "skills_soaking_damage_less_after_revive",
		icon_large = "skills_soaking_damage_less_after_revive_large",
		name_id = "skill_revived_damage_reduction_name",
		stat_desc_id = "skill_revived_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"temporary_on_revived_damage_reduction_3",
		},
	}
	self.skills.revived_damage_reduction_4 = {
		desc_id = "skill_revived_damage_reduction_desc",
		icon = "skills_soaking_damage_less_after_revive",
		icon_large = "skills_soaking_damage_less_after_revive_large",
		name_id = "skill_revived_damage_reduction_name",
		stat_desc_id = "skill_revived_damage_reduction_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"temporary_on_revived_damage_reduction_4",
		},
	}
	self.skills.bleedout_timer_increase_1 = {
		desc_id = "skill_bleedout_timer_increase_desc",
		icon = "skills_soaking_damage_increase_bleedout_time",
		icon_large = "skills_soaking_damage_increase_bleedout_time_large",
		name_id = "skill_bleedout_timer_increase_name",
		stat_desc_id = "skill_bleedout_timer_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_bleedout_timer_increase_1",
		},
	}
	self.skills.bleedout_timer_increase_2 = {
		desc_id = "skill_bleedout_timer_increase_desc",
		icon = "skills_soaking_damage_increase_bleedout_time",
		icon_large = "skills_soaking_damage_increase_bleedout_time_large",
		name_id = "skill_bleedout_timer_increase_name",
		stat_desc_id = "skill_bleedout_timer_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_bleedout_timer_increase_2",
		},
	}
	self.skills.bleedout_timer_increase_3 = {
		desc_id = "skill_bleedout_timer_increase_desc",
		icon = "skills_soaking_damage_increase_bleedout_time",
		icon_large = "skills_soaking_damage_increase_bleedout_time_large",
		name_id = "skill_bleedout_timer_increase_name",
		stat_desc_id = "skill_bleedout_timer_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_bleedout_timer_increase_3",
		},
	}
	self.skills.bleedout_timer_increase_4 = {
		desc_id = "skill_bleedout_timer_increase_desc",
		icon = "skills_soaking_damage_increase_bleedout_time",
		icon_large = "skills_soaking_damage_increase_bleedout_time_large",
		name_id = "skill_bleedout_timer_increase_name",
		stat_desc_id = "skill_bleedout_timer_increase_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_bleedout_timer_increase_4",
		},
	}
	self.skills.revive_interaction_speed_multiplier_1 = {
		desc_id = "skill_revive_interaction_speed_multiplier_desc",
		icon = "skills_interaction_revive_teammates_faster",
		icon_large = "skills_interaction_revive_teammates_faster_large",
		name_id = "skill_revive_interaction_speed_multiplier_name",
		stat_desc_id = "skill_revive_interaction_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_revive_interaction_speed_multiplier_1",
		},
	}
	self.skills.revive_interaction_speed_multiplier_2 = {
		desc_id = "skill_revive_interaction_speed_multiplier_desc",
		icon = "skills_interaction_revive_teammates_faster",
		icon_large = "skills_interaction_revive_teammates_faster_large",
		name_id = "skill_revive_interaction_speed_multiplier_name",
		stat_desc_id = "skill_revive_interaction_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_revive_interaction_speed_multiplier_2",
		},
	}
	self.skills.revive_interaction_speed_multiplier_3 = {
		desc_id = "skill_revive_interaction_speed_multiplier_desc",
		icon = "skills_interaction_revive_teammates_faster",
		icon_large = "skills_interaction_revive_teammates_faster_large",
		name_id = "skill_revive_interaction_speed_multiplier_name",
		stat_desc_id = "skill_revive_interaction_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_revive_interaction_speed_multiplier_3",
		},
	}
	self.skills.revive_interaction_speed_multiplier_4 = {
		desc_id = "skill_revive_interaction_speed_multiplier_desc",
		icon = "skills_interaction_revive_teammates_faster",
		icon_large = "skills_interaction_revive_teammates_faster_large",
		name_id = "skill_revive_interaction_speed_multiplier_name",
		stat_desc_id = "skill_revive_interaction_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_revive_interaction_speed_multiplier_4",
		},
	}
	self.skills.general_interaction_speed_multiplier_1 = {
		desc_id = "skill_general_interaction_speed_multiplier_desc",
		icon = "skills_general_faster_interaction",
		icon_large = "skills_general_faster_interaction_large",
		name_id = "skill_general_interaction_speed_multiplier_name",
		stat_desc_id = "skill_general_interaction_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_general_interaction_timer_multiplier_1",
		},
	}
	self.skills.general_interaction_speed_multiplier_2 = {
		desc_id = "skill_general_interaction_speed_multiplier_desc",
		icon = "skills_general_faster_interaction",
		icon_large = "skills_general_faster_interaction_large",
		name_id = "skill_general_interaction_speed_multiplier_name",
		stat_desc_id = "skill_general_interaction_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_general_interaction_timer_multiplier_2",
		},
	}
	self.skills.general_interaction_speed_multiplier_3 = {
		desc_id = "skill_general_interaction_speed_multiplier_desc",
		icon = "skills_general_faster_interaction",
		icon_large = "skills_general_faster_interaction_large",
		name_id = "skill_general_interaction_speed_multiplier_name",
		stat_desc_id = "skill_general_interaction_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_general_interaction_timer_multiplier_3",
		},
	}
	self.skills.general_interaction_speed_multiplier_4 = {
		desc_id = "skill_general_interaction_speed_multiplier_desc",
		icon = "skills_general_faster_interaction",
		icon_large = "skills_general_faster_interaction_large",
		name_id = "skill_general_interaction_speed_multiplier_name",
		stat_desc_id = "skill_general_interaction_speed_multiplier_stat_line",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"interaction_general_interaction_timer_multiplier_4",
		},
	}
	self.skills.long_dis_revive_1 = {
		desc_id = "skill_long_dis_revive_1_desc",
		icon = "skills_special_skills_revive_range_teammates",
		icon_large = "skills_special_skills_revive_range_teammates_large",
		name_id = "skill_long_dis_revive_1_name",
		acquires = {},
		icon_xy = {
			1,
			1,
		},
		upgrades = {
			"player_long_dis_revive_1",
		},
	}
end

function SkillTreeTweakData:_init_recon_skill_tree()
	self.skill_trees.recon = {}
	self.skill_trees.recon[1] = {
		{
			skill_name = "warcry_sharpshooter",
		},
	}
	self.skill_trees.recon[2] = {
		{
			skill_name = "swap_speed_multiplier_1",
		},
		{
			skill_name = "turret_reduced_overheat_1",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_1",
		},
	}
	self.skill_trees.recon[3] = {
		{
			skill_name = "stamina_multiplier_1",
		},
		{
			skill_name = "stamina_regeneration_increase_1",
		},
		{
			skill_name = "carry_penalty_decrease_1",
		},
	}
	self.skill_trees.recon[4] = {
		{
			skill_name = "increase_general_speed_1",
		},
		{
			skill_name = "increase_run_speed_1",
		},
		{
			skill_name = "increase_crouch_speed_1",
		},
	}
	self.skill_trees.recon[5] = {
		{
			skill_name = "warcry_team_damage_buff_1",
		},
		{
			skill_name = "warcry_long_range_multiplier_bonus_1",
		},
		{
			skill_name = "warcry_duration_1",
		},
	}
	self.skill_trees.recon[6] = {
		{
			skill_name = "player_critical_hit_chance_1",
		},
		{
			skill_name = "headshot_damage_multiplier_1",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_1",
		},
	}
	self.skill_trees.recon[7] = {
		{
			skill_name = "running_damage_reduction_1",
		},
		{
			skill_name = "crouching_damage_reduction_1",
		},
		{
			skill_name = "revive_interaction_speed_multiplier_1",
		},
	}
	self.skill_trees.recon[8] = {
		{
			skill_name = "primary_ammo_capacity_increase_1",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_1",
		},
		{
			skill_name = "pick_up_ammo_multiplier_1",
		},
	}
	self.skill_trees.recon[9] = {
		{
			skill_name = "wheel_hotspot_increase_1",
		},
		{
			skill_name = "wheel_rotation_speed_increase_1",
		},
		{
			skill_name = "general_interaction_speed_multiplier_1",
		},
	}
	self.skill_trees.recon[10] = {
		{
			skill_name = "warcry_sharpshooter_level_increase",
		},
	}
	self.skill_trees.recon[11] = {
		{
			skill_name = "max_health_multiplier_1",
		},
		{
			skill_name = "pick_up_health_multiplier_1",
		},
		{
			skill_name = "bleedout_timer_increase_1",
		},
	}
	self.skill_trees.recon[12] = {
		{
			skill_name = "reload_speed_multiplier_1",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_2",
		},
		{
			skill_name = "on_hit_flinch_reduction_1",
		},
	}
	self.skill_trees.recon[13] = {
		{
			skill_name = "increase_general_speed_2",
		},
		{
			skill_name = "increase_run_speed_2",
		},
		{
			skill_name = "increase_crouch_speed_2",
		},
	}
	self.skill_trees.recon[14] = {
		{
			skill_name = "player_critical_hit_chance_2",
		},
		{
			skill_name = "headshot_damage_multiplier_2",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_2",
		},
	}
	self.skill_trees.recon[15] = {
		{
			skill_name = "warcry_team_damage_buff_2",
		},
		{
			skill_name = "warcry_headshot_multiplier_bonus_1",
		},
		{
			skill_name = "warcry_duration_2",
		},
	}
	self.skill_trees.recon[16] = {
		{
			skill_name = "stamina_multiplier_2",
		},
		{
			skill_name = "crouching_damage_reduction_2",
		},
		{
			skill_name = "revived_damage_reduction_1",
		},
	}
	self.skill_trees.recon[17] = {
		{
			skill_name = "sniper_damage_multiplier_1",
		},
		{
			skill_name = "assault_rifle_damage_multiplier_1",
		},
		{
			skill_name = "pistol_damage_multiplier_1",
		},
	}
	self.skill_trees.recon[18] = {
		{
			skill_name = "primary_ammo_capacity_increase_2",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_2",
		},
		{
			skill_name = "revive_interaction_speed_multiplier_2",
		},
	}
	self.skill_trees.recon[19] = {
		{
			skill_name = "interacting_damage_reduction_1",
		},
		{
			skill_name = "bullet_damage_reduction_1",
		},
		{
			skill_name = "melee_damage_reduction_1",
		},
	}
	self.skill_trees.recon[20] = {
		{
			skill_name = "warcry_sharpshooter_level_increase",
		},
	}
	self.skill_trees.recon[21] = {
		{
			skill_name = "reload_speed_multiplier_2",
		},
		{
			skill_name = "pick_up_ammo_multiplier_2",
		},
		{
			skill_name = "general_interaction_speed_multiplier_2",
		},
	}
	self.skill_trees.recon[22] = {
		{
			skill_name = "stamina_regeneration_increase_2",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_3",
		},
		{
			skill_name = "carry_penalty_decrease_2",
		},
	}
	self.skill_trees.recon[23] = {
		{
			skill_name = "swap_speed_multiplier_2",
		},
		{
			skill_name = "melee_damage_multiplier_1",
		},
		{
			skill_name = "running_damage_reduction_2",
		},
	}
	self.skill_trees.recon[24] = {
		{
			skill_name = "wheel_hotspot_increase_2",
		},
		{
			skill_name = "crouching_damage_reduction_3",
		},
		{
			skill_name = "increase_crouch_speed_3",
		},
	}
	self.skill_trees.recon[25] = {
		{
			skill_name = "warcry_team_damage_buff_3",
		},
		{
			skill_name = "warcry_long_range_multiplier_bonus_2",
		},
		{
			skill_name = "warcry_duration_3",
		},
	}
	self.skill_trees.recon[26] = {
		{
			skill_name = "stamina_multiplier_3",
		},
		{
			skill_name = "headshot_damage_multiplier_3",
		},
		{
			skill_name = "on_hit_flinch_reduction_2",
		},
	}
	self.skill_trees.recon[27] = {
		{
			skill_name = "increase_general_speed_3",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_3",
		},
		{
			skill_name = "revive_interaction_speed_multiplier_3",
		},
	}
	self.skill_trees.recon[28] = {
		{
			skill_name = "primary_ammo_capacity_increase_3",
		},
		{
			skill_name = "sniper_damage_multiplier_2",
		},
		{
			skill_name = "increase_run_speed_3",
		},
	}
	self.skill_trees.recon[29] = {
		{
			skill_name = "reload_speed_multiplier_3",
		},
		{
			skill_name = "player_critical_hit_chance_3",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_3",
		},
	}
	self.skill_trees.recon[30] = {
		{
			skill_name = "warcry_sharpshooter_level_increase",
		},
	}
	self.skill_trees.recon[31] = {
		{
			skill_name = "max_health_multiplier_2",
		},
		{
			skill_name = "smg_damage_multiplier_1",
		},
		{
			skill_name = "pick_up_health_multiplier_2",
		},
	}
	self.skill_trees.recon[32] = {
		{
			skill_name = "interacting_damage_reduction_2",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_4",
		},
		{
			skill_name = "bleedout_timer_increase_2",
		},
	}
	self.skill_trees.recon[33] = {
		{
			skill_name = "wheel_rotation_speed_increase_2",
		},
		{
			skill_name = "revived_damage_reduction_2",
		},
		{
			skill_name = "increase_crouch_speed_4",
		},
	}
	self.skill_trees.recon[34] = {
		{
			skill_name = "headshot_damage_multiplier_4",
		},
		{
			skill_name = "crouching_damage_reduction_4",
		},
		{
			skill_name = "pick_up_ammo_multiplier_3",
		},
	}
	self.skill_trees.recon[35] = {
		{
			skill_name = "warcry_team_damage_buff_4",
		},
		{
			skill_name = "warcry_headshot_multiplier_bonus_2",
		},
		{
			skill_name = "warcry_duration_4",
		},
	}
	self.skill_trees.recon[36] = {
		{
			skill_name = "melee_damage_reduction_2",
		},
		{
			skill_name = "on_hit_flinch_reduction_3",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_4",
		},
	}
	self.skill_trees.recon[37] = {
		{
			skill_name = "reload_speed_multiplier_4",
		},
		{
			skill_name = "assault_rifle_damage_multiplier_2",
		},
		{
			skill_name = "running_damage_reduction_3",
		},
	}
	self.skill_trees.recon[38] = {
		{
			skill_name = "stamina_multiplier_4",
		},
		{
			skill_name = "primary_ammo_capacity_increase_4",
		},
		{
			skill_name = "revive_interaction_speed_multiplier_4",
		},
	}
	self.skill_trees.recon[39] = {
		{
			skill_name = "turret_reduced_overheat_2",
		},
		{
			skill_name = "sniper_damage_multiplier_3",
		},
		{
			skill_name = "bullet_damage_reduction_2",
		},
	}
	self.skill_trees.recon[40] = {
		{
			skill_name = "warcry_sharpshooter_level_increase",
		},
	}
end

function SkillTreeTweakData:_init_assault_skill_tree()
	self.skill_trees.assault = {}
	self.skill_trees.assault[1] = {
		{
			skill_name = "warcry_berserk",
		},
	}
	self.skill_trees.assault[2] = {
		{
			skill_name = "swap_speed_multiplier_1",
		},
		{
			skill_name = "turret_reduced_overheat_1",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_1",
		},
	}
	self.skill_trees.assault[3] = {
		{
			skill_name = "melee_damage_reduction_1",
		},
		{
			skill_name = "interacting_damage_reduction_1",
		},
		{
			skill_name = "revived_damage_reduction_1",
		},
	}
	self.skill_trees.assault[4] = {
		{
			skill_name = "max_health_multiplier_1",
		},
		{
			skill_name = "pick_up_health_multiplier_1",
		},
		{
			skill_name = "bleedout_timer_increase_1",
		},
	}
	self.skill_trees.assault[5] = {
		{
			skill_name = "warcry_team_heal_buff_1",
		},
		{
			skill_name = "warcry_low_health_multiplier_bonus_1",
		},
		{
			skill_name = "warcry_duration_1",
		},
	}
	self.skill_trees.assault[6] = {
		{
			skill_name = "stamina_multiplier_1",
		},
		{
			skill_name = "stamina_regeneration_increase_1",
		},
		{
			skill_name = "carry_penalty_decrease_1",
		},
	}
	self.skill_trees.assault[7] = {
		{
			skill_name = "bullet_damage_reduction_1",
		},
		{
			skill_name = "crouching_damage_reduction_1",
		},
		{
			skill_name = "running_damage_reduction_1",
		},
	}
	self.skill_trees.assault[8] = {
		{
			skill_name = "player_critical_hit_chance_1",
		},
		{
			skill_name = "headshot_damage_multiplier_1",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_1",
		},
	}
	self.skill_trees.assault[9] = {
		{
			skill_name = "wheel_hotspot_increase_1",
		},
		{
			skill_name = "wheel_rotation_speed_increase_1",
		},
		{
			skill_name = "general_interaction_speed_multiplier_1",
		},
	}
	self.skill_trees.assault[10] = {
		{
			skill_name = "warcry_berserk_level_increase",
		},
	}
	self.skill_trees.assault[11] = {
		{
			skill_name = "primary_ammo_capacity_increase_1",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_1",
		},
		{
			skill_name = "pick_up_ammo_multiplier_1",
		},
	}
	self.skill_trees.assault[12] = {
		{
			skill_name = "max_health_multiplier_2",
		},
		{
			skill_name = "pick_up_health_multiplier_2",
		},
		{
			skill_name = "bleedout_timer_increase_2",
		},
	}
	self.skill_trees.assault[13] = {
		{
			skill_name = "reload_speed_multiplier_1",
		},
		{
			skill_name = "turret_reduced_overheat_2",
		},
		{
			skill_name = "on_hit_flinch_reduction_1",
		},
	}
	self.skill_trees.assault[14] = {
		{
			skill_name = "increase_general_speed_1",
		},
		{
			skill_name = "increase_run_speed_1",
		},
		{
			skill_name = "increase_crouch_speed_1",
		},
	}
	self.skill_trees.assault[15] = {
		{
			skill_name = "warcry_team_heal_buff_2",
		},
		{
			skill_name = "warcry_dismemberment_multiplier_bonus_1",
		},
		{
			skill_name = "warcry_duration_2",
		},
	}
	self.skill_trees.assault[16] = {
		{
			skill_name = "bullet_damage_reduction_2",
		},
		{
			skill_name = "crouching_damage_reduction_2",
		},
		{
			skill_name = "revived_damage_reduction_2",
		},
	}
	self.skill_trees.assault[17] = {
		{
			skill_name = "assault_rifle_damage_multiplier_1",
		},
		{
			skill_name = "smg_damage_multiplier_1",
		},
		{
			skill_name = "lmg_damage_multiplier_1",
		},
	}
	self.skill_trees.assault[18] = {
		{
			skill_name = "player_critical_hit_chance_2",
		},
		{
			skill_name = "melee_damage_multiplier_1",
		},
		{
			skill_name = "on_hit_flinch_reduction_2",
		},
	}
	self.skill_trees.assault[19] = {
		{
			skill_name = "revive_interaction_speed_multiplier_1",
		},
		{
			skill_name = "stamina_regeneration_increase_2",
		},
		{
			skill_name = "carry_penalty_decrease_2",
		},
	}
	self.skill_trees.assault[20] = {
		{
			skill_name = "warcry_berserk_level_increase",
		},
	}
	self.skill_trees.assault[21] = {
		{
			skill_name = "melee_damage_reduction_2",
		},
		{
			skill_name = "headshot_damage_multiplier_2",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_2",
		},
	}
	self.skill_trees.assault[22] = {
		{
			skill_name = "turret_reduced_overheat_3",
		},
		{
			skill_name = "pick_up_health_multiplier_3",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_2",
		},
	}
	self.skill_trees.assault[23] = {
		{
			skill_name = "max_health_multiplier_3",
		},
		{
			skill_name = "increase_crouch_speed_2",
		},
		{
			skill_name = "crouching_damage_reduction_3",
		},
	}
	self.skill_trees.assault[24] = {
		{
			skill_name = "swap_speed_multiplier_2",
		},
		{
			skill_name = "revived_damage_reduction_3",
		},
		{
			skill_name = "bleedout_timer_increase_3",
		},
	}
	self.skill_trees.assault[25] = {
		{
			skill_name = "warcry_team_heal_buff_3",
		},
		{
			skill_name = "warcry_low_health_multiplier_bonus_2",
		},
		{
			skill_name = "warcry_duration_3",
		},
	}
	self.skill_trees.assault[26] = {
		{
			skill_name = "stamina_multiplier_2",
		},
		{
			skill_name = "increase_run_speed_2",
		},
		{
			skill_name = "running_damage_reduction_2",
		},
	}
	self.skill_trees.assault[27] = {
		{
			skill_name = "bullet_damage_reduction_3",
		},
		{
			skill_name = "assault_rifle_damage_multiplier_2",
		},
		{
			skill_name = "primary_ammo_capacity_increase_2",
		},
	}
	self.skill_trees.assault[28] = {
		{
			skill_name = "player_critical_hit_chance_3",
		},
		{
			skill_name = "reload_speed_multiplier_2",
		},
		{
			skill_name = "turret_reduced_overheat_4",
		},
	}
	self.skill_trees.assault[29] = {
		{
			skill_name = "wheel_hotspot_increase_2",
		},
		{
			skill_name = "stamina_regeneration_increase_3",
		},
		{
			skill_name = "on_hit_flinch_reduction_3",
		},
	}
	self.skill_trees.assault[30] = {
		{
			skill_name = "warcry_berserk_level_increase",
		},
	}
	self.skill_trees.assault[31] = {
		{
			skill_name = "pick_up_ammo_multiplier_2",
		},
		{
			skill_name = "wheel_rotation_speed_increase_2",
		},
		{
			skill_name = "melee_damage_multiplier_2",
		},
	}
	self.skill_trees.assault[32] = {
		{
			skill_name = "max_health_multiplier_4",
		},
		{
			skill_name = "smg_damage_multiplier_2",
		},
		{
			skill_name = "grenade_quantity_1",
		},
	}
	self.skill_trees.assault[33] = {
		{
			skill_name = "general_interaction_speed_multiplier_2",
		},
		{
			skill_name = "pick_up_health_multiplier_4",
		},
		{
			skill_name = "carry_penalty_decrease_3",
		},
	}
	self.skill_trees.assault[34] = {
		{
			skill_name = "revive_interaction_speed_multiplier_2",
		},
		{
			skill_name = "revived_damage_reduction_4",
		},
		{
			skill_name = "bleedout_timer_increase_4",
		},
	}
	self.skill_trees.assault[35] = {
		{
			skill_name = "warcry_team_heal_buff_4",
		},
		{
			skill_name = "warcry_dismemberment_multiplier_bonus_2",
		},
		{
			skill_name = "warcry_duration_4",
		},
	}
	self.skill_trees.assault[36] = {
		{
			skill_name = "bullet_damage_reduction_4",
		},
		{
			skill_name = "lmg_damage_multiplier_2",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_2",
		},
	}
	self.skill_trees.assault[37] = {
		{
			skill_name = "melee_damage_reduction_3",
		},
		{
			skill_name = "headshot_damage_multiplier_3",
		},
		{
			skill_name = "on_hit_flinch_reduction_4",
		},
	}
	self.skill_trees.assault[38] = {
		{
			skill_name = "player_critical_hit_chance_4",
		},
		{
			skill_name = "assault_rifle_damage_multiplier_3",
		},
		{
			skill_name = "interacting_damage_reduction_2",
		},
	}
	self.skill_trees.assault[39] = {
		{
			skill_name = "highlight_enemy_damage_bonus_3",
		},
		{
			skill_name = "increase_general_speed_2",
		},
		{
			skill_name = "reload_speed_multiplier_3",
		},
	}
	self.skill_trees.assault[40] = {
		{
			skill_name = "warcry_berserk_level_increase",
		},
	}
end

function SkillTreeTweakData:_init_infiltrator_skill_tree()
	self.skill_trees.infiltrator = {}
	self.skill_trees.infiltrator[1] = {
		{
			skill_name = "warcry_ghost",
		},
	}
	self.skill_trees.infiltrator[2] = {
		{
			skill_name = "swap_speed_multiplier_1",
		},
		{
			skill_name = "turret_reduced_overheat_1",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_1",
		},
	}
	self.skill_trees.infiltrator[3] = {
		{
			skill_name = "melee_damage_reduction_1",
		},
		{
			skill_name = "running_damage_reduction_1",
		},
		{
			skill_name = "interacting_damage_reduction_1",
		},
	}
	self.skill_trees.infiltrator[4] = {
		{
			skill_name = "increase_general_speed_1",
		},
		{
			skill_name = "increase_run_speed_1",
		},
		{
			skill_name = "increase_crouch_speed_1",
		},
	}
	self.skill_trees.infiltrator[5] = {
		{
			skill_name = "warcry_team_movement_speed_buff_1",
		},
		{
			skill_name = "warcry_short_range_multiplier_bonus_1",
		},
		{
			skill_name = "warcry_duration_1",
		},
	}
	self.skill_trees.infiltrator[6] = {
		{
			skill_name = "stamina_multiplier_1",
		},
		{
			skill_name = "stamina_regeneration_increase_1",
		},
		{
			skill_name = "carry_penalty_decrease_1",
		},
	}
	self.skill_trees.infiltrator[7] = {
		{
			skill_name = "wheel_hotspot_increase_1",
		},
		{
			skill_name = "wheel_rotation_speed_increase_1",
		},
		{
			skill_name = "general_interaction_speed_multiplier_1",
		},
	}
	self.skill_trees.infiltrator[8] = {
		{
			skill_name = "primary_ammo_capacity_increase_1",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_1",
		},
		{
			skill_name = "pick_up_ammo_multiplier_1",
		},
	}
	self.skill_trees.infiltrator[9] = {
		{
			skill_name = "max_health_multiplier_1",
		},
		{
			skill_name = "pick_up_health_multiplier_1",
		},
		{
			skill_name = "bleedout_timer_increase_1",
		},
	}
	self.skill_trees.infiltrator[10] = {
		{
			skill_name = "warcry_ghost_level_increase",
		},
	}
	self.skill_trees.infiltrator[11] = {
		{
			skill_name = "player_critical_hit_chance_1",
		},
		{
			skill_name = "headshot_damage_multiplier_1",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_1",
		},
	}
	self.skill_trees.infiltrator[12] = {
		{
			skill_name = "increase_general_speed_2",
		},
		{
			skill_name = "increase_run_speed_2",
		},
		{
			skill_name = "increase_crouch_speed_2",
		},
	}
	self.skill_trees.infiltrator[13] = {
		{
			skill_name = "melee_damage_reduction_2",
		},
		{
			skill_name = "running_damage_reduction_2",
		},
		{
			skill_name = "revived_damage_reduction_1",
		},
	}
	self.skill_trees.infiltrator[14] = {
		{
			skill_name = "reload_speed_multiplier_1",
		},
		{
			skill_name = "swap_speed_multiplier_2",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_2",
		},
	}
	self.skill_trees.infiltrator[15] = {
		{
			skill_name = "warcry_team_movement_speed_buff_2",
		},
		{
			skill_name = "warcry_melee_multiplier_bonus_1",
		},
		{
			skill_name = "warcry_duration_2",
		},
	}
	self.skill_trees.infiltrator[16] = {
		{
			skill_name = "stamina_regeneration_increase_2",
		},
		{
			skill_name = "on_hit_flinch_reduction_1",
		},
		{
			skill_name = "revive_interaction_speed_multiplier_1",
		},
	}
	self.skill_trees.infiltrator[17] = {
		{
			skill_name = "smg_damage_multiplier_1",
		},
		{
			skill_name = "melee_damage_multiplier_1",
		},
		{
			skill_name = "pistol_damage_multiplier_1",
		},
	}
	self.skill_trees.infiltrator[18] = {
		{
			skill_name = "wheel_hotspot_increase_2",
		},
		{
			skill_name = "wheel_rotation_speed_increase_2",
		},
		{
			skill_name = "general_interaction_speed_multiplier_2",
		},
	}
	self.skill_trees.infiltrator[19] = {
		{
			skill_name = "interacting_damage_reduction_2",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_2",
		},
		{
			skill_name = "pick_up_health_multiplier_2",
		},
	}
	self.skill_trees.infiltrator[20] = {
		{
			skill_name = "warcry_ghost_level_increase",
		},
	}
	self.skill_trees.infiltrator[21] = {
		{
			skill_name = "bullet_damage_reduction_1",
		},
		{
			skill_name = "shotgun_damage_multiplier_1",
		},
		{
			skill_name = "carry_penalty_decrease_2",
		},
	}
	self.skill_trees.infiltrator[22] = {
		{
			skill_name = "melee_damage_reduction_3",
		},
		{
			skill_name = "turret_reduced_overheat_2",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_2",
		},
	}
	self.skill_trees.infiltrator[23] = {
		{
			skill_name = "increase_general_speed_3",
		},
		{
			skill_name = "pistol_damage_multiplier_2",
		},
		{
			skill_name = "revived_damage_reduction_2",
		},
	}
	self.skill_trees.infiltrator[24] = {
		{
			skill_name = "stamina_regeneration_increase_3",
		},
		{
			skill_name = "increase_run_speed_3",
		},
		{
			skill_name = "running_damage_reduction_3",
		},
	}
	self.skill_trees.infiltrator[25] = {
		{
			skill_name = "warcry_team_movement_speed_buff_3",
		},
		{
			skill_name = "warcry_short_range_multiplier_bonus_2",
		},
		{
			skill_name = "warcry_duration_3",
		},
	}
	self.skill_trees.infiltrator[26] = {
		{
			skill_name = "crouching_damage_reduction_1",
		},
		{
			skill_name = "melee_damage_multiplier_2",
		},
		{
			skill_name = "increase_crouch_speed_3",
		},
	}
	self.skill_trees.infiltrator[27] = {
		{
			skill_name = "smg_damage_multiplier_2",
		},
		{
			skill_name = "max_health_multiplier_2",
		},
		{
			skill_name = "pick_up_ammo_multiplier_2",
		},
	}
	self.skill_trees.infiltrator[28] = {
		{
			skill_name = "stamina_multiplier_2",
		},
		{
			skill_name = "swap_speed_multiplier_3",
		},
		{
			skill_name = "general_interaction_speed_multiplier_3",
		},
	}
	self.skill_trees.infiltrator[29] = {
		{
			skill_name = "wheel_hotspot_increase_3",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_3",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_3",
		},
	}
	self.skill_trees.infiltrator[30] = {
		{
			skill_name = "warcry_ghost_level_increase",
		},
	}
	self.skill_trees.infiltrator[31] = {
		{
			skill_name = "reload_speed_multiplier_2",
		},
		{
			skill_name = "wheel_rotation_speed_increase_3",
		},
		{
			skill_name = "pick_up_health_multiplier_3",
		},
	}
	self.skill_trees.infiltrator[32] = {
		{
			skill_name = "player_critical_hit_chance_2",
		},
		{
			skill_name = "shotgun_damage_multiplier_2",
		},
		{
			skill_name = "wheel_amount_decrease_1",
		},
	}
	self.skill_trees.infiltrator[33] = {
		{
			skill_name = "stamina_regeneration_increase_4",
		},
		{
			skill_name = "increase_run_speed_4",
		},
		{
			skill_name = "running_damage_reduction_4",
		},
	}
	self.skill_trees.infiltrator[34] = {
		{
			skill_name = "increase_general_speed_4",
		},
		{
			skill_name = "headshot_damage_multiplier_2",
		},
		{
			skill_name = "revived_damage_reduction_3",
		},
	}
	self.skill_trees.infiltrator[35] = {
		{
			skill_name = "warcry_team_movement_speed_buff_4",
		},
		{
			skill_name = "warcry_melee_multiplier_bonus_2",
		},
		{
			skill_name = "warcry_duration_4",
		},
	}
	self.skill_trees.infiltrator[36] = {
		{
			skill_name = "melee_damage_reduction_4",
		},
		{
			skill_name = "melee_damage_multiplier_3",
		},
		{
			skill_name = "revive_interaction_speed_multiplier_2",
		},
	}
	self.skill_trees.infiltrator[37] = {
		{
			skill_name = "bleedout_timer_increase_2",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_4",
		},
		{
			skill_name = "interacting_damage_reduction_3",
		},
	}
	self.skill_trees.infiltrator[38] = {
		{
			skill_name = "crouching_damage_reduction_2",
		},
		{
			skill_name = "on_hit_flinch_reduction_2",
		},
		{
			skill_name = "assault_rifle_damage_multiplier_1",
		},
	}
	self.skill_trees.infiltrator[39] = {
		{
			skill_name = "smg_damage_multiplier_3",
		},
		{
			skill_name = "primary_ammo_capacity_increase_2",
		},
		{
			skill_name = "bullet_damage_reduction_2",
		},
	}
	self.skill_trees.infiltrator[40] = {
		{
			skill_name = "warcry_ghost_level_increase",
		},
	}
end

function SkillTreeTweakData:_init_demolitions_skill_tree()
	self.skill_trees.demolitions = {}
	self.skill_trees.demolitions[1] = {
		{
			skill_name = "warcry_clustertruck",
		},
	}
	self.skill_trees.demolitions[2] = {
		{
			skill_name = "swap_speed_multiplier_1",
		},
		{
			skill_name = "turret_reduced_overheat_1",
		},
		{
			skill_name = "ready_weapon_speed_multiplier_1",
		},
	}
	self.skill_trees.demolitions[3] = {
		{
			skill_name = "wheel_hotspot_increase_1",
		},
		{
			skill_name = "wheel_rotation_speed_increase_1",
		},
		{
			skill_name = "general_interaction_speed_multiplier_1",
		},
	}
	self.skill_trees.demolitions[4] = {
		{
			skill_name = "stamina_multiplier_1",
		},
		{
			skill_name = "stamina_regeneration_increase_1",
		},
		{
			skill_name = "carry_penalty_decrease_1",
		},
	}
	self.skill_trees.demolitions[5] = {
		{
			skill_name = "warcry_team_damage_reduction_buff_1",
		},
		{
			skill_name = "warcry_explosion_multiplier_bonus_1",
		},
		{
			skill_name = "warcry_duration_1",
		},
	}
	self.skill_trees.demolitions[6] = {
		{
			skill_name = "max_health_multiplier_1",
		},
		{
			skill_name = "pick_up_health_multiplier_1",
		},
		{
			skill_name = "bleedout_timer_increase_1",
		},
	}
	self.skill_trees.demolitions[7] = {
		{
			skill_name = "melee_damage_reduction_1",
		},
		{
			skill_name = "interacting_damage_reduction_1",
		},
		{
			skill_name = "revived_damage_reduction_1",
		},
	}
	self.skill_trees.demolitions[8] = {
		{
			skill_name = "primary_ammo_capacity_increase_1",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_1",
		},
		{
			skill_name = "pick_up_ammo_multiplier_1",
		},
	}
	self.skill_trees.demolitions[9] = {
		{
			skill_name = "player_critical_hit_chance_1",
		},
		{
			skill_name = "headshot_damage_multiplier_1",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_1",
		},
	}
	self.skill_trees.demolitions[10] = {
		{
			skill_name = "warcry_clustertruck_level_increase",
		},
	}
	self.skill_trees.demolitions[11] = {
		{
			skill_name = "bullet_damage_reduction_1",
		},
		{
			skill_name = "crouching_damage_reduction_1",
		},
		{
			skill_name = "running_damage_reduction_1",
		},
	}
	self.skill_trees.demolitions[12] = {
		{
			skill_name = "wheel_hotspot_increase_2",
		},
		{
			skill_name = "wheel_rotation_speed_increase_2",
		},
		{
			skill_name = "general_interaction_speed_multiplier_2",
		},
	}
	self.skill_trees.demolitions[13] = {
		{
			skill_name = "increase_general_speed_1",
		},
		{
			skill_name = "increase_run_speed_1",
		},
		{
			skill_name = "increase_crouch_speed_1",
		},
	}
	self.skill_trees.demolitions[14] = {
		{
			skill_name = "reload_speed_multiplier_1",
		},
		{
			skill_name = "swap_speed_multiplier_2",
		},
		{
			skill_name = "revive_interaction_speed_multiplier_1",
		},
	}
	self.skill_trees.demolitions[15] = {
		{
			skill_name = "warcry_team_damage_reduction_buff_2",
		},
		{
			skill_name = "warcry_killstreak_multiplier_bonus_1",
		},
		{
			skill_name = "warcry_duration_2",
		},
	}
	self.skill_trees.demolitions[16] = {
		{
			skill_name = "wheel_amount_decrease_1",
		},
		{
			skill_name = "on_hit_flinch_reduction_1",
		},
		{
			skill_name = "turret_reduced_overheat_2",
		},
	}
	self.skill_trees.demolitions[17] = {
		{
			skill_name = "shotgun_damage_multiplier_1",
		},
		{
			skill_name = "lmg_damage_multiplier_1",
		},
		{
			skill_name = "assault_rifle_damage_multiplier_1",
		},
	}
	self.skill_trees.demolitions[18] = {
		{
			skill_name = "stamina_multiplier_2",
		},
		{
			skill_name = "max_health_multiplier_2",
		},
		{
			skill_name = "bleedout_timer_increase_2",
		},
	}
	self.skill_trees.demolitions[19] = {
		{
			skill_name = "pick_up_ammo_multiplier_2",
		},
		{
			skill_name = "interacting_damage_reduction_2",
		},
		{
			skill_name = "carry_penalty_decrease_2",
		},
	}
	self.skill_trees.demolitions[20] = {
		{
			skill_name = "warcry_clustertruck_level_increase",
		},
	}
	self.skill_trees.demolitions[21] = {
		{
			skill_name = "grenade_quantity_1",
		},
		{
			skill_name = "headshot_damage_multiplier_2",
		},
		{
			skill_name = "secondary_ammo_capacity_increase_2",
		},
	}
	self.skill_trees.demolitions[22] = {
		{
			skill_name = "ready_weapon_speed_multiplier_2",
		},
		{
			skill_name = "wheel_rotation_speed_increase_3",
		},
		{
			skill_name = "turret_reduced_overheat_3",
		},
	}
	self.skill_trees.demolitions[23] = {
		{
			skill_name = "wheel_hotspot_increase_3",
		},
		{
			skill_name = "bullet_damage_reduction_2",
		},
		{
			skill_name = "highlight_enemy_damage_bonus_2",
		},
	}
	self.skill_trees.demolitions[24] = {
		{
			skill_name = "primary_ammo_capacity_increase_2",
		},
		{
			skill_name = "revive_interaction_speed_multiplier_2",
		},
		{
			skill_name = "general_interaction_speed_multiplier_3",
		},
	}
	self.skill_trees.demolitions[25] = {
		{
			skill_name = "warcry_team_damage_reduction_buff_3",
		},
		{
			skill_name = "warcry_explosion_multiplier_bonus_2",
		},
		{
			skill_name = "warcry_duration_3",
		},
	}
	self.skill_trees.demolitions[26] = {
		{
			skill_name = "melee_damage_reduction_2",
		},
		{
			skill_name = "swap_speed_multiplier_3",
		},
		{
			skill_name = "carry_penalty_decrease_3",
		},
	}
	self.skill_trees.demolitions[27] = {
		{
			skill_name = "shotgun_damage_multiplier_2",
		},
		{
			skill_name = "pick_up_health_multiplier_2",
		},
		{
			skill_name = "interacting_damage_reduction_3",
		},
	}
	self.skill_trees.demolitions[28] = {
		{
			skill_name = "pick_up_ammo_multiplier_3",
		},
		{
			skill_name = "lmg_damage_multiplier_2",
		},
		{
			skill_name = "increase_general_speed_2",
		},
	}
	self.skill_trees.demolitions[29] = {
		{
			skill_name = "stamina_regeneration_increase_2",
		},
		{
			skill_name = "increase_run_speed_2",
		},
		{
			skill_name = "running_damage_reduction_2",
		},
	}
	self.skill_trees.demolitions[30] = {
		{
			skill_name = "warcry_clustertruck_level_increase",
		},
	}
	self.skill_trees.demolitions[31] = {
		{
			skill_name = "stamina_multiplier_3",
		},
		{
			skill_name = "increase_crouch_speed_2",
		},
		{
			skill_name = "crouching_damage_reduction_2",
		},
	}
	self.skill_trees.demolitions[32] = {
		{
			skill_name = "revived_damage_reduction_2",
		},
		{
			skill_name = "wheel_rotation_speed_increase_4",
		},
		{
			skill_name = "bleedout_timer_increase_3",
		},
	}
	self.skill_trees.demolitions[33] = {
		{
			skill_name = "wheel_hotspot_increase_4",
		},
		{
			skill_name = "max_health_multiplier_3",
		},
		{
			skill_name = "assault_rifle_damage_multiplier_2",
		},
	}
	self.skill_trees.demolitions[34] = {
		{
			skill_name = "revive_interaction_speed_multiplier_3",
		},
		{
			skill_name = "swap_speed_multiplier_4",
		},
		{
			skill_name = "general_interaction_speed_multiplier_4",
		},
	}
	self.skill_trees.demolitions[35] = {
		{
			skill_name = "warcry_team_damage_reduction_buff_4",
		},
		{
			skill_name = "warcry_killstreak_multiplier_bonus_2",
		},
		{
			skill_name = "warcry_duration_4",
		},
	}
	self.skill_trees.demolitions[36] = {
		{
			skill_name = "grenade_quantity_2",
		},
		{
			skill_name = "bullet_damage_reduction_3",
		},
		{
			skill_name = "reload_speed_multiplier_2",
		},
	}
	self.skill_trees.demolitions[37] = {
		{
			skill_name = "on_hit_flinch_reduction_2",
		},
		{
			skill_name = "interacting_damage_reduction_4",
		},
		{
			skill_name = "carry_penalty_decrease_4",
		},
	}
	self.skill_trees.demolitions[38] = {
		{
			skill_name = "shotgun_damage_multiplier_3",
		},
		{
			skill_name = "pick_up_ammo_multiplier_4",
		},
		{
			skill_name = "player_critical_hit_chance_2",
		},
	}
	self.skill_trees.demolitions[39] = {
		{
			skill_name = "primary_ammo_capacity_increase_3",
		},
		{
			skill_name = "lmg_damage_multiplier_3",
		},
		{
			skill_name = "wheel_amount_decrease_2",
		},
	}
	self.skill_trees.demolitions[40] = {
		{
			skill_name = "warcry_clustertruck_level_increase",
		},
	}
end

function SkillTreeTweakData:get_weapon_unlock_levels()
	local ret = {}

	for class_name, class_unlock_data in pairs(self.automatic_unlock_progressions) do
		for level, unlock_data in pairs(class_unlock_data) do
			if unlock_data.weapons then
				for _, weapon_unlock in pairs(unlock_data.weapons) do
					for _, upgrade in ipairs(self.skills[weapon_unlock].upgrades) do
						if not ret[upgrade] then
							ret[upgrade] = {}
						end

						ret[upgrade][class_name] = level
					end
				end
			end
		end
	end

	return ret
end

function SkillTreeTweakData:get_weapon_unlock_level(weapon_id, class_name)
	for level, unlock_data in pairs(self.automatic_unlock_progressions[class_name]) do
		if unlock_data.weapons then
			for _, weapon_unlock in pairs(unlock_data.weapons) do
				for _, upgrade in ipairs(self.skills[weapon_unlock].upgrades) do
					if upgrade == weapon_id then
						return level
					end
				end
			end
		end
	end

	return nil
end

function SkillTreeTweakData:_init_recon_unlock_progression()
	self.automatic_unlock_progressions.recon = {}
	self.automatic_unlock_progressions.recon[1] = {
		weapons = {
			"weapon_unlock_springfield",
			"weapon_unlock_carbine",
			"weapon_unlock_c96",
		},
	}
	self.automatic_unlock_progressions.recon[3] = {
		weapons = {
			"weapon_unlock_sten",
		},
	}
	self.automatic_unlock_progressions.recon[13] = {
		weapons = {
			"weapon_unlock_garand",
			"weapon_unlock_garand_golden",
		},
	}
	self.automatic_unlock_progressions.recon[15] = {
		unlocks = {
			"weapon_tier_unlocked_2",
		},
		weapons = {
			"weapon_unlock_thompson",
		},
	}
	self.automatic_unlock_progressions.recon[18] = {
		weapons = {
			"weapon_unlock_webley",
		},
	}
	self.automatic_unlock_progressions.recon[23] = {
		weapons = {
			"weapon_unlock_mosin",
		},
	}
	self.automatic_unlock_progressions.recon[25] = {
		unlocks = {
			"weapon_tier_unlocked_3",
		},
		weapons = {
			"weapon_unlock_mp38",
		},
	}
	self.automatic_unlock_progressions.recon[30] = {
		weapons = {
			"weapon_unlock_m1911",
		},
	}
	self.automatic_unlock_progressions.recon[35] = {
		unlocks = {
			"recon_tier_4_unlocked",
		},
	}
	self.automatic_unlock_progressions.recon[38] = {
		weapons = {
			"weapon_unlock_sterling",
		},
	}
	self.automatic_unlock_progressions.recon[40] = {
		weapons = {
			"weapon_unlock_mp44",
		},
	}
	self.default_weapons.recon = {}
	self.default_weapons.recon.primary = "m1903"
	self.default_weapons.recon.secondary = "c96"
end

function SkillTreeTweakData:_init_assault_unlock_progression()
	self.automatic_unlock_progressions.assault = {}
	self.automatic_unlock_progressions.assault[1] = {
		weapons = {
			"weapon_unlock_carbine",
			"weapon_unlock_sten",
			"weapon_unlock_c96",
		},
	}
	self.automatic_unlock_progressions.assault[3] = {
		weapons = {
			"weapon_unlock_bar",
		},
	}
	self.automatic_unlock_progressions.assault[10] = {
		weapons = {
			"weapon_unlock_garand",
			"weapon_unlock_garand_golden",
		},
	}
	self.automatic_unlock_progressions.assault[13] = {
		weapons = {
			"weapon_unlock_thompson",
		},
	}
	self.automatic_unlock_progressions.assault[15] = {
		unlocks = {
			"weapon_tier_unlocked_2",
		},
	}
	self.automatic_unlock_progressions.assault[18] = {
		weapons = {
			"weapon_unlock_webley",
		},
	}
	self.automatic_unlock_progressions.assault[25] = {
		unlocks = {
			"weapon_tier_unlocked_3",
		},
	}
	self.automatic_unlock_progressions.assault[28] = {
		weapons = {
			"weapon_unlock_mp38",
		},
	}
	self.automatic_unlock_progressions.assault[30] = {
		weapons = {
			"weapon_unlock_m1911",
		},
	}
	self.automatic_unlock_progressions.assault[33] = {
		weapons = {
			"weapon_unlock_mp44",
		},
	}
	self.automatic_unlock_progressions.assault[35] = {
		unlocks = {
			"assault_tier_4_unlocked",
		},
	}
	self.automatic_unlock_progressions.assault[38] = {
		weapons = {
			"weapon_unlock_mg42",
		},
	}
	self.automatic_unlock_progressions.assault[40] = {
		weapons = {
			"weapon_unlock_sterling",
		},
	}
	self.default_weapons.assault = {}
	self.default_weapons.assault.primary = "carbine"
	self.default_weapons.assault.secondary = "c96"
end

function SkillTreeTweakData:_init_infiltrator_unlock_progression()
	self.automatic_unlock_progressions.infiltrator = {}
	self.automatic_unlock_progressions.infiltrator[1] = {
		weapons = {
			"weapon_unlock_sten",
			"weapon_unlock_winchester",
			"weapon_unlock_c96",
		},
	}
	self.automatic_unlock_progressions.infiltrator[3] = {
		weapons = {
			"weapon_unlock_carbine",
		},
	}
	self.automatic_unlock_progressions.infiltrator[10] = {
		weapons = {
			"weapon_unlock_thompson",
		},
	}
	self.automatic_unlock_progressions.infiltrator[13] = {
		weapons = {
			"weapon_unlock_geco",
		},
	}
	self.automatic_unlock_progressions.infiltrator[15] = {
		unlocks = {
			"weapon_tier_unlocked_2",
		},
		weapons = {
			"weapon_unlock_garand",
			"weapon_unlock_garand_golden",
		},
	}
	self.automatic_unlock_progressions.infiltrator[18] = {
		weapons = {
			"weapon_unlock_webley",
		},
	}
	self.automatic_unlock_progressions.infiltrator[23] = {
		weapons = {
			"weapon_unlock_mp38",
		},
	}
	self.automatic_unlock_progressions.infiltrator[25] = {
		unlocks = {
			"weapon_tier_unlocked_3",
		},
	}
	self.automatic_unlock_progressions.infiltrator[30] = {
		weapons = {
			"weapon_unlock_m1911",
		},
	}
	self.automatic_unlock_progressions.infiltrator[33] = {
		weapons = {
			"weapon_unlock_sterling",
		},
	}
	self.automatic_unlock_progressions.infiltrator[35] = {
		unlocks = {
			"infiltrator_tier_4_unlocked",
		},
	}
	self.automatic_unlock_progressions.infiltrator[38] = {
		weapons = {
			"weapon_unlock_mp44",
		},
	}
	self.default_weapons.infiltrator = {}
	self.default_weapons.infiltrator.primary = "sten"
	self.default_weapons.infiltrator.secondary = "c96"
end

function SkillTreeTweakData:_init_demolitions_unlock_progression()
	self.automatic_unlock_progressions.demolitions = {}
	self.automatic_unlock_progressions.demolitions[1] = {
		weapons = {
			"weapon_unlock_winchester",
			"weapon_unlock_bar",
			"weapon_unlock_c96",
		},
	}
	self.automatic_unlock_progressions.demolitions[3] = {
		weapons = {
			"weapon_unlock_carbine",
		},
	}
	self.automatic_unlock_progressions.demolitions[10] = {
		weapons = {
			"weapon_unlock_geco",
		},
	}
	self.automatic_unlock_progressions.demolitions[15] = {
		unlocks = {
			"weapon_tier_unlocked_2",
		},
		weapons = {
			"weapon_unlock_garand",
			"weapon_unlock_garand_golden",
		},
	}
	self.automatic_unlock_progressions.demolitions[18] = {
		weapons = {
			"weapon_unlock_webley",
		},
	}
	self.automatic_unlock_progressions.demolitions[25] = {
		unlocks = {
			"weapon_tier_unlocked_3",
		},
	}
	self.automatic_unlock_progressions.demolitions[30] = {
		weapons = {
			"weapon_unlock_m1911",
		},
	}
	self.automatic_unlock_progressions.demolitions[35] = {
		unlocks = {
			"demolitions_tier_4_unlocked",
		},
	}
	self.automatic_unlock_progressions.demolitions[38] = {
		weapons = {
			"weapon_unlock_mp44",
		},
	}
	self.automatic_unlock_progressions.demolitions[40] = {
		weapons = {
			"weapon_unlock_mg42",
		},
	}
	self.default_weapons.demolitions = {}
	self.default_weapons.demolitions.primary = "m1912"
	self.default_weapons.demolitions.secondary = "c96"
end
