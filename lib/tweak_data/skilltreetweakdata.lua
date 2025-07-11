SkillTreeTweakData = SkillTreeTweakData or class()
SkillTreeTweakData.CLASS_RECON = "recon"
SkillTreeTweakData.CLASS_ASSAULT = "assault"
SkillTreeTweakData.CLASS_INFILTRATOR = "infiltrator"
SkillTreeTweakData.CLASS_DEMOLITIONS = "demolitions"
SkillTreeTweakData.TYPE_WARCRY = 1
SkillTreeTweakData.TYPE_BOOSTS = 2
SkillTreeTweakData.TYPE_TALENT = 3
SkillTreeTweakData.TYPE_WEAPON = 4
SkillTreeTweakData.TYPE_UNLOCKS = 5
SkillTreeTweakData.TYPE_TRANSLATIONS = {}
SkillTreeTweakData.TYPE_TRANSLATIONS[SkillTreeTweakData.TYPE_WARCRY] = "warcry"
SkillTreeTweakData.TYPE_TRANSLATIONS[SkillTreeTweakData.TYPE_BOOSTS] = "boost"
SkillTreeTweakData.TYPE_TRANSLATIONS[SkillTreeTweakData.TYPE_TALENT] = "talent"
SkillTreeTweakData.TYPE_TRANSLATIONS[SkillTreeTweakData.TYPE_WEAPON] = "weapon"
SkillTreeTweakData.TYPE_TRANSLATIONS[SkillTreeTweakData.TYPE_UNLOCKS] = "unlock"
SkillTreeTweakData._EXP_REQS = {
	{
		17500,
		20000,
		23500,
		27000,
	},
	{
		60000,
		70000,
		80000,
		90000,
	},
}
SkillTreeTweakData._GOLD_REQS = {
	10,
	350,
}
SkillTreeTweakData._GOLD_REQ_RAMPUP = {
	0,
	0,
	0.3,
	1,
}

function SkillTreeTweakData:init(tweak_data)
	self.skill_warcry_tiers = {
		[1] = 0,
	}
	self.skill_boost_tiers = {
		[1] = 0,
	}
	self.skill_talent_tiers = {
		0,
		0,
		5,
		10,
		15,
		20,
		30,
		40,
	}
	self.skill_category_colors = {
		tweak_data.gui.colors.raid_skill_warcry,
		tweak_data.gui.colors.raid_skill_boost,
		tweak_data.gui.colors.raid_skill_talent,
	}
	self.migration_reward = 22
	self.exp_overlevel_penalty = {
		max = 0.85,
		min = 0.1,
	}
	self.skill_profiles = {
		0,
		0,
		20,
		40,
		80,
		120,
		240,
		480,
	}

	self:_init_classes(tweak_data)
	self:_init_skill_list()

	self.class_warcry_data = {
		[SkillTreeTweakData.CLASS_RECON] = {
			"sharpshooter",
			"silver_bullet",
		},
		[SkillTreeTweakData.CLASS_ASSAULT] = {
			"berserk",
			"sentry",
		},
		[SkillTreeTweakData.CLASS_INFILTRATOR] = {
			"ghost",
			"pain_train",
		},
		[SkillTreeTweakData.CLASS_DEMOLITIONS] = {
			"clustertruck",
			"scorched_earth",
		},
	}
	self.automatic_unlock_progressions = {}
	self.default_weapons = {}

	self:_init_recon_unlock_progression()
	self:_init_assault_unlock_progression()
	self:_init_infiltrator_unlock_progression()
	self:_init_demolitions_unlock_progression()
end

function SkillTreeTweakData:_init_classes(tweak_data)
	self.base_classes = {
		SkillTreeTweakData.CLASS_RECON,
		SkillTreeTweakData.CLASS_ASSAULT,
		SkillTreeTweakData.CLASS_INFILTRATOR,
		SkillTreeTweakData.CLASS_DEMOLITIONS,
	}
	self.classes = {}
	self.classes.recon = {
		default_natioanlity = "british",
		desc_id = "skill_class_recon_desc",
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
		name = "recon",
		name_id = "skill_class_recon_name",
		stats = {
			health = 12,
			speed = 162,
			stamina = 68,
		},
	}
	self.classes.assault = {
		default_natioanlity = "american",
		desc_id = "skill_class_assault_desc",
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
		name = "assault",
		name_id = "skill_class_assault_name",
		stats = {
			health = 13,
			speed = 163,
			stamina = 69,
		},
	}
	self.classes.demolitions = {
		default_natioanlity = "german",
		desc_id = "skill_class_demolitions_desc",
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
		name = "demolitions",
		name_id = "skill_class_demolitions_name",
		stats = {
			health = 14,
			speed = 164,
			stamina = 70,
		},
	}
	self.classes.infiltrator = {
		default_natioanlity = "russian",
		desc_id = "skill_class_infiltrator_desc",
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
		name = "infiltrator",
		name_id = "skill_class_infiltrator_name",
		stats = {
			health = 15,
			speed = 165,
			stamina = 71,
		},
	}
end

function SkillTreeTweakData:get_skills_organised(class_id)
	local t = {}

	t[SkillTreeTweakData.TYPE_WARCRY] = {}
	t[SkillTreeTweakData.TYPE_BOOSTS] = {}
	t[SkillTreeTweakData.TYPE_TALENT] = {}
	t[SkillTreeTweakData.TYPE_WEAPON] = {}
	t[SkillTreeTweakData.TYPE_UNLOCKS] = {}

	for id, skill_data in pairs(self.skills) do
		local class_lock = skill_data.class_lock

		if (not class_lock or table.contains(class_lock, class_id)) and skill_data.upgrades_type and t[skill_data.upgrades_type] then
			t[skill_data.upgrades_type][id] = skill_data
		end
	end

	return t
end

function SkillTreeTweakData:_init_skill_list()
	self.skills = {}

	self:_init_skill_list_warcries()
	self:_init_skill_list_boosts()
	self:_init_skill_list_talents()
	self:_init_skill_list_weapons()

	for skill_id, skill_data in pairs(self.skills) do
		if self:is_skill_levelable(skill_id) then
			local multi = skill_data.value_multiplier or 1

			if not skill_data.exp_requirements then
				skill_data.exp_requirements = self.get_skill_exp_requirements(skill_data.level_required or 1, multi)
			end

			if not skill_data.gold_requirements then
				skill_data.gold_requirements = self.get_skill_gold_requirements(skill_data.level_required or 1, multi)
			end
		end
	end
end

function SkillTreeTweakData:is_skill_levelable(skill_id)
	local skill_data = self.skills[skill_id]

	if skill_data and skill_data.upgrades_type then
		return skill_data.upgrades_type == SkillTreeTweakData.TYPE_WARCRY or skill_data.upgrades_type == SkillTreeTweakData.TYPE_BOOSTS or skill_data.upgrades_type == SkillTreeTweakData.TYPE_TALENT
	end

	return false
end

function SkillTreeTweakData:_init_skill_list_warcries()
	self.skills.warcry_sharpshooter = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
		},
		default_unlocked = true,
		desc_id = "skill_warcry_sharpshooter_desc",
		icon = "skills_warcry_sharpshooter",
		name_id = "skill_warcry_sharpshooter_name",
		upgrades = {
			{},
			{},
			{},
			{},
		},
		upgrades_desc = {
			"skill_warcry_sharpshooter_stat_line_1",
			"skill_warcry_sharpshooter_stat_line_2",
			"skill_warcry_sharpshooter_stat_line_3",
			"skill_warcry_sharpshooter_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WARCRY,
		value_multiplier = 2,
		warcry_id = "sharpshooter",
	}
	self.skills.warcry_silver_bullet = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
		},
		desc_id = "skill_warcry_silver_bullet_desc",
		icon = "skills_warcry_silver_bullet",
		info_id = "skill_warcry_silver_bullet_info",
		level_required = 10,
		name_id = "skill_warcry_silver_bullet_name",
		upgrades = {
			{},
			{},
			{},
			{},
		},
		upgrades_desc = {
			"skill_warcry_silver_bullet_stat_line_1",
			"skill_warcry_silver_bullet_stat_line_2",
			"skill_warcry_silver_bullet_stat_line_3",
			"skill_warcry_silver_bullet_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WARCRY,
		value_multiplier = 2,
		warcry_id = "silver_bullet",
	}
	self.skills.warcry_berserk = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
		},
		default_unlocked = true,
		desc_id = "skill_warcry_berserk_desc",
		icon = "skills_warcry_berserk",
		name_id = "skill_warcry_berserk_name",
		upgrades = {
			{},
			{},
			{},
			{},
		},
		upgrades_desc = {
			"skill_warcry_berserk_stat_line_1",
			"skill_warcry_berserk_stat_line_2",
			"skill_warcry_berserk_stat_line_3",
			"skill_warcry_berserk_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WARCRY,
		value_multiplier = 2,
		warcry_id = "berserk",
	}
	self.skills.warcry_sentry = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
		},
		desc_id = "skill_warcry_sentry_desc",
		icon = "skills_warcry_sentry",
		info_id = "skill_warcry_sentry_info",
		level_required = 10,
		name_id = "skill_warcry_sentry_name",
		upgrades = {
			{},
			{},
			{},
			{},
		},
		upgrades_desc = {
			"skill_warcry_sentry_stat_line_1",
			"skill_warcry_sentry_stat_line_2",
			"skill_warcry_sentry_stat_line_3",
			"skill_warcry_sentry_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WARCRY,
		value_multiplier = 2,
		warcry_id = "sentry",
	}
	self.skills.warcry_ghost = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		default_unlocked = true,
		desc_id = "skill_warcry_ghost_desc",
		icon = "skills_warcry_ghost",
		name_id = "skill_warcry_ghost_name",
		upgrades = {
			{},
			{},
			{},
			{},
		},
		upgrades_desc = {
			"skill_warcry_ghost_stat_line_1",
			"skill_warcry_ghost_stat_line_2",
			"skill_warcry_ghost_stat_line_3",
			"skill_warcry_ghost_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WARCRY,
		value_multiplier = 2,
		warcry_id = "ghost",
	}
	self.skills.warcry_pain_train = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		desc_id = "skill_warcry_pain_train_desc",
		icon = "skills_warcry_pain_train",
		info_id = "skill_warcry_pain_train_info",
		level_required = 10,
		name_id = "skill_warcry_pain_train_name",
		upgrades = {
			{},
			{
				"warcry_player_charge_activation_threshold",
			},
			{},
			{},
		},
		upgrades_desc = {
			"skill_warcry_pain_train_stat_line_1",
			"skill_warcry_pain_train_stat_line_2",
			"skill_warcry_pain_train_stat_line_3",
			"skill_warcry_pain_train_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WARCRY,
		value_multiplier = 2,
		warcry_id = "pain_train",
	}
	self.skills.warcry_clustertruck = {
		class_lock = {
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		default_unlocked = true,
		desc_id = "skill_warcry_clustertruck_desc",
		icon = "skills_warcry_clustertruck",
		name_id = "skill_warcry_clustertruck_name",
		upgrades = {
			{},
			{
				"warcry_player_grenade_refill_amounts_1",
			},
			{},
			{
				"warcry_player_grenade_refill_amounts_2",
			},
		},
		upgrades_desc = {
			"skill_warcry_clustertruck_stat_line_1",
			"skill_warcry_clustertruck_stat_line_2",
			"skill_warcry_clustertruck_stat_line_3",
			"skill_warcry_clustertruck_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WARCRY,
		value_multiplier = 2,
		warcry_id = "clustertruck",
	}
	self.skills.scorched_earth = {
		class_lock = {
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_warcry_scorched_earth_desc",
		icon = "skills_warcry_scorched_earth",
		level_required = 10,
		name_id = "skill_warcry_scorched_earth_name",
		upgrades = {
			{},
			{},
			{
				"warcry_player_grenade_refill_amounts_2",
				"warcry_player_grenade_refill_amounts_1",
			},
			{},
		},
		upgrades_desc = {
			"skill_warcry_scorched_earth_stat_line_1",
			"skill_warcry_scorched_earth_stat_line_2",
			"skill_warcry_scorched_earth_stat_line_3",
			"skill_warcry_scorched_earth_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WARCRY,
		value_multiplier = 2,
		warcry_id = "scorched_earth",
	}
end

function SkillTreeTweakData:_init_skill_list_boosts()
	self.skills.boost_nothing = {
		desc_id = "skill_boost_nothing_desc",
		icon = "skills_boost_nothing",
		info_id = "status_effect_nothing_info",
		level_required = 40,
		name_id = "skill_boost_nothing_name",
		upgrades = {
			{
				"player_greed_loot_bonus_1",
				"player_midas_gold_bar_quantity",
			},
			{
				"player_greed_loot_bonus_2",
			},
			{
				"player_greed_loot_bonus_3",
			},
			{
				"player_greed_loot_bonus_4",
			},
		},
		upgrades_desc = {
			"skill_boost_nothing_stat_line_1",
			"skill_boost_nothing_stat_line_2",
			"skill_boost_nothing_stat_line_3",
			"skill_boost_nothing_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_BOOSTS,
		value_multiplier = 2,
	}
	self.skills.box_o_choc = {
		desc_id = "skill_box_o_choc_desc",
		icon = "skills_box_o_choc",
		level_required = 5,
		name_id = "skill_box_o_choc_name",
		upgrades = {
			{
				"player_box_o_choc_low_health_regen_multiplier",
			},
			{},
			{},
			{
				"player_box_o_choc_health_regen_timer_multiplier",
			},
		},
		upgrades_desc = {
			"skill_box_o_choc_stat_line_1",
			"skill_box_o_choc_stat_line_2",
			"skill_box_o_choc_stat_line_3",
			"skill_box_o_choc_stat_line_4",
		},
		upgrades_team_buff = {
			{
				"warcry_team_health_regeneration_1",
			},
			{
				"warcry_team_health_regeneration_2",
			},
			{
				"warcry_team_health_regeneration_3",
			},
			{
				"warcry_team_health_regeneration_4",
			},
		},
		upgrades_team_buff_icon = "status_effect_health_regen",
		upgrades_type = SkillTreeTweakData.TYPE_BOOSTS,
		value_multiplier = 0.8,
	}
	self.skills.sprinter = {
		desc_id = "skill_sprinter_desc",
		icon = "skills_sprinter",
		level_required = 5,
		name_id = "skill_sprinter_name",
		upgrades = {
			{
				"player_sprinter_running_detection_multiplier",
			},
			{},
			{},
			{
				"player_sprinter_run_speed_increase",
			},
		},
		upgrades_desc = {
			"skill_sprinter_stat_line_1",
			"skill_sprinter_stat_line_2",
			"skill_sprinter_stat_line_3",
			"skill_sprinter_stat_line_4",
		},
		upgrades_team_buff = {
			{
				"warcry_team_movement_speed_multiplier_1",
			},
			{
				"warcry_team_movement_speed_multiplier_2",
			},
			{
				"warcry_team_movement_speed_multiplier_3",
			},
			{
				"warcry_team_movement_speed_multiplier_4",
			},
		},
		upgrades_team_buff_icon = "status_effect_movement_speed",
		upgrades_type = SkillTreeTweakData.TYPE_BOOSTS,
		value_multiplier = 0.8,
	}
	self.skills.painkiller = {
		desc_id = "skill_painkiller_desc",
		icon = "skills_painkiller",
		level_required = 10,
		name_id = "skill_painkiller_name",
		upgrades = {
			{
				"player_painkiller_fire_damage_reduction",
				"player_painkiller_explosive_damage_reduction",
			},
			{},
			{},
			{
				"player_painkiller_damage_interval_multiplier",
			},
		},
		upgrades_desc = {
			"skill_painkiller_stat_line_1",
			"skill_painkiller_stat_line_2",
			"skill_painkiller_stat_line_3",
			"skill_painkiller_stat_line_4",
		},
		upgrades_team_buff = {
			{
				"warcry_team_damage_reduction_multiplier_1",
			},
			{
				"warcry_team_damage_reduction_multiplier_2",
			},
			{
				"warcry_team_damage_reduction_multiplier_3",
			},
			{
				"warcry_team_damage_reduction_multiplier_4",
			},
		},
		upgrades_team_buff_icon = "status_effect_damage_resistance",
		upgrades_type = SkillTreeTweakData.TYPE_BOOSTS,
		value_multiplier = 0.7,
	}
	self.skills.cache_basket = {
		desc_id = "skill_cache_basket_desc",
		icon = "skills_cache_basket",
		level_required = 10,
		name_id = "skill_cache_basket_name",
		upgrades = {
			{
				"player_cache_basket_pick_up_ammo_multiplier",
			},
			{},
			{},
			{
				"player_cache_basket_ammo_total_increase",
			},
		},
		upgrades_desc = {
			"skill_cache_basket_stat_line_1",
			"skill_cache_basket_stat_line_2",
			"skill_cache_basket_stat_line_3",
			"skill_cache_basket_stat_line_4",
		},
		upgrades_team_buff = {
			{
				"warcry_team_ammo_regeneration_1",
			},
			{
				"warcry_team_ammo_regeneration_2",
			},
			{
				"warcry_team_ammo_regeneration_3",
			},
			{
				"warcry_team_ammo_regeneration_4",
			},
		},
		upgrades_team_buff_icon = "status_effect_ammo_regeneration",
		upgrades_type = SkillTreeTweakData.TYPE_BOOSTS,
		value_multiplier = 0.7,
	}
	self.skills.critbrain = {
		desc_id = "skill_critbrain_desc",
		icon = "skills_critbrain",
		level_required = 10,
		name_id = "skill_critbrain_name",
		upgrades = {
			{
				"player_critbrain_critical_hit_chance",
			},
			{},
			{},
			{
				"player_critbrain_critical_hit_damage",
			},
		},
		upgrades_desc = {
			"skill_critbrain_stat_line_1",
			"skill_critbrain_stat_line_2",
			"skill_critbrain_stat_line_3",
			"skill_critbrain_stat_line_4",
		},
		upgrades_team_buff = {
			{
				"warcry_team_critical_hit_chance_1",
			},
			{
				"warcry_team_critical_hit_chance_2",
			},
			{
				"warcry_team_critical_hit_chance_3",
			},
			{
				"warcry_team_critical_hit_chance_4",
			},
		},
		upgrades_team_buff_icon = "status_effect_crit_chances",
		upgrades_type = SkillTreeTweakData.TYPE_BOOSTS,
		value_multiplier = 0.7,
	}
end

function SkillTreeTweakData:_init_skill_list_talents()
	self.skills.gunner = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
			SkillTreeTweakData.CLASS_INFILTRATOR,
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_gunner_desc",
		icon = "skills_gunner",
		name_id = "skill_gunner_name",
		purchase_group = {
			"gunner",
			"gunner_pro",
		},
		upgrades = {
			{
				"player_gunner_turret_m2_overheat_reduction_1",
				"player_gunner_turret_flakvierling_overheat_reduction_1",
			},
			{
				"player_gunner_turret_camera_speed_multiplier",
			},
			{
				"player_gunner_damage_reduction_1",
			},
			{
				"player_gunner_turret_damage_multiplier_1",
			},
		},
		upgrades_desc = {
			"skill_gunner_stat_line_1",
			"skill_gunner_stat_line_2",
			"skill_gunner_stat_line_3",
			"skill_gunner_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.locksmith = {
		desc_id = "skill_locksmith_desc",
		icon = "skills_locksmith",
		name_id = "skill_locksmith_name",
		upgrades = {
			{
				"interaction_locksmith_wheel_hotspot_increase",
				"interaction_locksmith_wheel_rotation_speed_increase",
			},
			{
				"player_locksmith_lockpicking_damage_reduction",
			},
			{
				"interaction_locksmith_wheel_amount_decrease",
			},
			{
				"interaction_locksmith_failure_rotation_speed_decrease",
			},
		},
		upgrades_desc = {
			"skill_locksmith_stat_line_1",
			"skill_locksmith_stat_line_2",
			"skill_locksmith_stat_line_3",
			"skill_locksmith_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.strong_back = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_strong_back_desc",
		icon = "skills_strong_back",
		name_id = "skill_strong_back_name",
		purchase_group = {
			"strong_back",
			"strong_back_assault",
			"strong_back_recon",
		},
		upgrades = {
			{
				"interaction_strongback_carry_pickup_multiplier",
			},
			{
				"carry_strongback_weight_increase_2",
				"carry_strongback_weight_increase_1",
			},
			{
				"carry_strongback_throw_distance_multiplier",
			},
			{
				"carry_strongback_heavy_penalty_decrease",
			},
		},
		upgrades_desc = {
			"skill_strong_back_stat_line_1",
			"skill_strong_back_stat_line_2",
			"skill_strong_back_stat_line_3",
			"skill_strong_back_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.strong_back_assault = deep_clone(self.skills.strong_back)
	self.skills.strong_back_assault.class_lock = {
		SkillTreeTweakData.CLASS_ASSAULT,
	}
	self.skills.strong_back_assault.upgrades[2] = {
		"carry_strongback_weight_increase_1",
	}
	self.skills.strong_back_recon = deep_clone(self.skills.strong_back)
	self.skills.strong_back_recon.class_lock = {
		SkillTreeTweakData.CLASS_RECON,
	}
	self.skills.strong_back_recon.upgrades[2] = {
		"carry_strongback_weight_increase_3",
		"carry_strongback_weight_increase_2",
		"carry_strongback_weight_increase_1",
	}
	self.skills.fleetfoot = {
		desc_id = "skill_fleetfoot_desc",
		icon = "skills_fleetfoot",
		name_id = "skill_fleetfoot_name",
		upgrades = {
			{
				"player_fleetfoot_movement_speed_multiplier",
			},
			{
				"player_fleetfoot_silent_fall",
			},
			{
				"player_fleetfoot_fall_damage_reduction",
			},
			{
				"player_fleetfoot_critical_movement_speed_multiplier",
			},
		},
		upgrades_desc = {
			"skill_fleetfoot_stat_line_1",
			"skill_fleetfoot_stat_line_2",
			"skill_fleetfoot_stat_line_3",
			"skill_fleetfoot_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.focus = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
			SkillTreeTweakData.CLASS_RECON,
		},
		desc_id = "skill_focus_desc",
		icon = "skills_focus",
		level_required = 3,
		name_id = "skill_focus_name",
		upgrades = {
			{
				"player_focus_interaction_damage_reduction",
			},
			{
				"player_focus_vehicle_damage_reduction",
			},
			{
				"player_focus_steelsight_damage_reduction",
			},
			{
				"player_focus_steelsight_normal_movement_speed",
			},
		},
		upgrades_desc = {
			"skill_focus_stat_line_1",
			"skill_focus_stat_line_2",
			"skill_focus_stat_line_3",
			"skill_focus_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.handyman = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		desc_id = "skill_handyman_desc",
		icon = "skills_handyman",
		level_required = 3,
		name_id = "skill_handyman_name",
		upgrades = {
			{
				"interaction_handyman_generic_speed_multiplier",
			},
			{
				"interaction_handyman_rewire_speed_multipler",
			},
			{
				"interaction_handyman_vehicle_speed_multipler",
			},
			{
				"temporary_handyman_interaction_boost",
			},
		},
		upgrades_desc = {
			"skill_handyman_stat_line_1",
			"skill_handyman_stat_line_2",
			"skill_handyman_stat_line_3",
			"skill_handyman_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.do_die = {
		class_lock = {
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_do_die_desc",
		icon = "skills_do_die",
		level_required = 3,
		name_id = "skill_do_die_name",
		upgrades = {
			{
				"player_do_die_melee_repeat_multiplier",
			},
			{
				"player_do_die_melee_warcry_fill_multiplier",
			},
			{
				"player_do_die_melee_running_charge",
			},
			{
				"temporary_do_die_melee_speed_multiplier",
			},
		},
		upgrades_desc = {
			"skill_do_die_stat_line_1",
			"skill_do_die_stat_line_2",
			"skill_do_die_stat_line_3",
			"skill_do_die_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.medic = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
			SkillTreeTweakData.CLASS_ASSAULT,
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_medic_desc",
		icon = "skills_medic",
		level_required = 3,
		name_id = "skill_medic_name",
		purchase_group = {
			"medic",
			"medic_pro",
		},
		upgrades = {
			{
				"player_medic_pick_up_health_multiplier_1",
			},
			{
				"player_medic_attention_weight_reduction_1",
			},
			{
				"interaction_medic_revive_speed_multiplier_1",
			},
			{
				"player_medic_health_share_team_1",
			},
		},
		upgrades_desc = {
			"skill_medic_stat_line_1",
			"skill_medic_stat_line_2",
			"skill_medic_stat_line_3",
			"skill_medic_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.medic_pro = deep_clone(self.skills.medic)
	self.skills.medic_pro.name_id = "skill_medic_pro_name"
	self.skills.medic_pro.level_required = 8
	self.skills.medic_pro.class_lock = {
		SkillTreeTweakData.CLASS_INFILTRATOR,
	}
	self.skills.medic_pro.upgrades = {
		{
			"player_medic_pick_up_health_multiplier_2",
		},
		{
			"player_medic_attention_weight_reduction_2",
		},
		{
			"interaction_medic_revive_speed_multiplier_2",
		},
		{
			"player_medic_health_share_team_2",
		},
	}
	self.skills.holdbarred = {
		desc_id = "skill_holdbarred_desc",
		icon = "skills_holdbarred",
		level_required = 3,
		name_id = "skill_holdbarred_name",
		upgrades = {
			{
				"player_holdbarred_melee_speed_multiplier",
			},
			{
				"player_holdbarred_melee_charge_multiplier",
			},
			{
				"player_holdbarred_melee_knockdown_multiplier",
			},
			{
				"player_holdbarred_melee_kill_panic_chance",
			},
		},
		upgrades_desc = {
			"skill_holdbarred_stat_line_1",
			"skill_holdbarred_stat_line_2",
			"skill_holdbarred_stat_line_3",
			"skill_holdbarred_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.steadiness = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
		},
		desc_id = "skill_steadiness_desc",
		icon = "skills_steadiness",
		level_required = 8,
		name_id = "skill_steadiness_name",
		upgrades = {
			{
				"snp_steelsight_hit_flinch_reduction",
				"snp_steelsight_movement_speed_multiplier",
			},
			{
				"player_steadiness_headshot_warcry_fill_multiplier",
			},
			{
				"player_steadiness_weapon_sway_decrease",
			},
			{
				"snp_steelsight_fire_rate_multiplier",
			},
		},
		upgrades_desc = {
			"skill_steadiness_stat_line_1",
			"skill_steadiness_stat_line_2",
			"skill_steadiness_stat_line_3",
			"skill_steadiness_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.high_dive = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
		},
		desc_id = "skill_high_dive_desc",
		icon = "skills_high_dive",
		info_id = "skill_high_dive_info",
		level_required = 8,
		name_id = "skill_high_dive_name",
		upgrades = {
			{
				"player_high_dive_ground_slam_1",
				"player_high_dive_gravity_multiplier_1",
			},
			{
				"player_high_dive_gravity_multiplier_2",
			},
			{
				"temporary_high_dive_enemy_knockdown",
			},
			{
				"player_high_dive_ground_slam_2",
			},
		},
		upgrades_desc = {
			"skill_high_dive_stat_line_1",
			"skill_high_dive_stat_line_2",
			"skill_high_dive_stat_line_3",
			"skill_high_dive_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.gunner_pro = deep_clone(self.skills.gunner)
	self.skills.gunner_pro.name_id = "skill_gunner_pro_name"
	self.skills.gunner_pro.class_lock = {
		SkillTreeTweakData.CLASS_ASSAULT,
	}
	self.skills.gunner_pro.upgrades = {
		{
			"player_gunner_turret_m2_overheat_reduction_2",
			"player_gunner_turret_flakvierling_overheat_reduction_2",
		},
		{
			"player_gunner_turret_camera_speed_multiplier",
		},
		{
			"player_gunner_damage_reduction_2",
		},
		{
			"player_gunner_turret_damage_multiplier_2",
		},
	}
	self.skills.helpcry = {
		desc_id = "skill_helpcry_desc",
		icon = "skills_helpcry",
		info_id = "skill_helpcry_info",
		level_required = 8,
		name_id = "skill_helpcry_name",
		upgrades = {
			{
				"player_helpcry_warcry_auto_fill_1",
				"player_helpcry_warcry_fill_multiplier",
			},
			{
				"player_helpcry_warcry_duration_multiplier",
			},
			{
				"player_helpcry_warcry_downed_reduction",
			},
			{
				"player_helpcry_warcry_auto_fill_2",
			},
		},
		upgrades_desc = {
			"skill_helpcry_stat_line_1",
			"skill_helpcry_stat_line_2",
			"skill_helpcry_stat_line_3",
			"skill_helpcry_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.fitness_freak = {
		desc_id = "skill_fitness_freak_desc",
		icon = "skills_fitness_freak",
		level_required = 8,
		name_id = "skill_fitness_freak_name",
		upgrades = {
			{
				"player_fitness_stamina_threshold_decrease",
			},
			{
				"player_fitness_stamina_regeneration_increase",
			},
			{
				"player_fitness_stamina_multiplier",
			},
			{
				"player_fitness_can_free_run",
			},
		},
		upgrades_desc = {
			"skill_fitness_freak_stat_line_1",
			"skill_fitness_freak_stat_line_2",
			"skill_fitness_freak_stat_line_3",
			"skill_fitness_freak_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.clipazines_assault = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
		},
		desc_id = "skill_clipazines_desc",
		icon = "skills_clipazines",
		level_required = 16,
		name_id = "skill_clipazines_name",
		purchase_group = {
			"clipazines_assault",
			"clipazines_recon",
			"clipazines_insurgent",
			"clipazines_demo",
		},
		upgrades = {
			{
				"weapon_clipazines_empty_reload_speed_multiplier",
			},
			{
				"player_clipazines_pick_up_ammo_multiplier",
			},
			{
				"assault_rifle_clipazines_magazine_upgrade",
				"lmg_clipazines_magazine_upgrade",
			},
			{
				"weapon_clipazines_reload_full_magazine",
			},
		},
		upgrades_desc = {
			"skill_clipazines_stat_line_1",
			"skill_clipazines_stat_line_2",
			"skill_clipazines_stat_line_3",
			"skill_clipazines_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.clipazines_recon = deep_clone(self.skills.clipazines_assault)
	self.skills.clipazines_recon.name_id = "skill_clipazines_recon_name"
	self.skills.clipazines_recon.level_required = 13
	self.skills.clipazines_recon.class_lock = {
		SkillTreeTweakData.CLASS_RECON,
	}
	self.skills.clipazines_recon.upgrades_desc[3] = "skill_clipazines_recon_stat_line_3"
	self.skills.clipazines_recon.upgrades_desc[4] = "skill_clipazines_hybrid_stat_line_4"
	self.skills.clipazines_recon.upgrades[3] = {
		"snp_clipazines_magazine_upgrade",
		"smg_clipazines_magazine_upgrade",
	}
	self.skills.clipazines_recon.upgrades[4] = {
		"weapon_clipazines_reload_hybrid_rounds",
	}
	self.skills.clipazines_insurgent = deep_clone(self.skills.clipazines_assault)
	self.skills.clipazines_insurgent.name_id = "skill_clipazines_insurgent_name"
	self.skills.clipazines_insurgent.level_required = 3
	self.skills.clipazines_insurgent.class_lock = {
		SkillTreeTweakData.CLASS_INFILTRATOR,
	}
	self.skills.clipazines_insurgent.upgrades_desc[3] = "skill_clipazines_insurgent_stat_line_3"
	self.skills.clipazines_insurgent.upgrades[3] = {
		"smg_clipazines_magazine_upgrade",
		"pistol_clipazines_magazine_upgrade",
	}
	self.skills.clipazines_demo = deep_clone(self.skills.clipazines_recon)
	self.skills.clipazines_demo.name_id = "skill_clipazines_demo_name"
	self.skills.clipazines_demo.level_required = 24
	self.skills.clipazines_demo.class_lock = {
		SkillTreeTweakData.CLASS_DEMOLITIONS,
	}
	self.skills.clipazines_demo.upgrades_desc[3] = "skill_clipazines_demo_stat_line_3"
	self.skills.clipazines_demo.upgrades[3] = {
		"shotgun_clipazines_magazine_upgrade",
		"lmg_clipazines_magazine_upgrade",
	}
	self.skills.duck_and_cover = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		desc_id = "skill_duck_and_cover_desc",
		icon = "skills_duck_and_cover",
		level_required = 13,
		name_id = "skill_duck_and_cover_name",
		upgrades = {
			{
				"player_dac_stamina_regen_delay_multiplier",
			},
			{
				"player_dac_jump_stamina_drain_reduction",
			},
			{
				"carry_dac_stamina_consumption_reduction",
			},
			{
				"player_dac_stamina_regeneration_on_kill",
			},
		},
		upgrades_desc = {
			"skill_duck_and_cover_stat_line_1",
			"skill_duck_and_cover_stat_line_2",
			"skill_duck_and_cover_stat_line_3",
			"skill_duck_and_cover_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.saboteur = {
		class_lock = {
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_saboteur_desc",
		icon = "skills_saboteur",
		level_required = 13,
		name_id = "skill_saboteur_name",
		upgrades = {
			{
				"interaction_saboteur_dynamite_speed_multiplier",
			},
			{
				"interaction_saboteur_fuse_hotspot_increase",
			},
			{
				"carry_saboteur_shell_weight_multiplier",
			},
			{
				"interaction_saboteur_boobytrap_turret",
			},
		},
		upgrades_desc = {
			"skill_saboteur_stat_line_1",
			"skill_saboteur_stat_line_2",
			"skill_saboteur_stat_line_3",
			"skill_saboteur_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.predator = {
		desc_id = "skill_predator_desc",
		icon = "skills_predator",
		level_required = 13,
		name_id = "skill_predator_name",
		upgrades = {
			{
				"carry_predator_corpse_weight_multiplier",
			},
			{
				"interaction_predator_corpse_speed_multiplier",
			},
			{
				"player_predator_surprise_kill_leeway_multiplier",
			},
			{
				"player_predator_surprise_knockdown",
			},
		},
		upgrades_desc = {
			"skill_predator_stat_line_1",
			"skill_predator_stat_line_2",
			"skill_predator_stat_line_3",
			"skill_predator_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.perseverance = {
		desc_id = "skill_perseverance_desc",
		icon = "skills_perseverance",
		info_id = "skill_perseverance_info",
		level_required = 13,
		name_id = "skill_perseverance_name",
		upgrades = {
			{
				"player_perseverance_prolong_life_1",
			},
			{
				"player_perseverance_killshot_timer_increase",
			},
			{
				"player_perseverance_prolong_life_2",
			},
			{
				"interaction_perseverance_allowed_interaction",
			},
		},
		upgrades_desc = {
			"skill_perseverance_stat_line_1",
			"skill_perseverance_stat_line_2",
			"skill_perseverance_stat_line_3",
			"skill_perseverance_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.opportunist = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_opportunist_desc",
		icon = "skills_opportunist",
		level_required = 16,
		name_id = "skill_opportunist_name",
		upgrades = {
			{
				"player_opportunist_pick_up_health_to_ammo",
			},
			{
				"player_opportunist_pick_up_ammo_to_health",
			},
			{
				"player_opportunist_pick_up_grenade_to_ammo",
				"player_opportunist_pick_up_grenade_to_health",
			},
			{
				"player_opportunist_pick_up_supplies_to_warcry",
			},
		},
		upgrades_desc = {
			"skill_opportunist_stat_line_1",
			"skill_opportunist_stat_line_2",
			"skill_opportunist_stat_line_3",
			"skill_opportunist_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.boxer = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		desc_id = "skill_boxer_desc",
		icon = "skills_boxer",
		level_required = 16,
		name_id = "skill_boxer_name",
		upgrades = {
			{
				"player_boxer_melee_damage_reduction",
			},
			{
				"player_boxer_melee_warcry_fill_multiplier",
			},
			{
				"player_boxer_melee_damage_multiplier",
			},
			{
				"player_boxer_melee_headshots",
			},
		},
		upgrades_desc = {
			"skill_boxer_stat_line_1",
			"skill_boxer_stat_line_2",
			"skill_boxer_stat_line_3",
			"skill_boxer_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.scuttler = {
		desc_id = "skill_scuttler_desc",
		icon = "skills_scuttler",
		level_required = 16,
		name_id = "skill_scuttler_name",
		upgrades = {
			{
				"player_scuttler_crouch_speed_increase",
			},
			{
				"player_scuttler_crouch_spread_multiplier",
			},
			{
				"player_scuttler_stamina_regeneration_increase",
			},
			{
				"carry_scuttler_crouch_penalty_decrease",
			},
		},
		upgrades_desc = {
			"skill_scuttler_stat_line_1",
			"skill_scuttler_stat_line_2",
			"skill_scuttler_stat_line_3",
			"skill_scuttler_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.grenadier = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
			SkillTreeTweakData.CLASS_ASSAULT,
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		desc_id = "skill_grenadier_desc",
		icon = "skills_grenadier",
		info_id = "skill_grenadier_info",
		level_required = 16,
		name_id = "skill_grenadier_name",
		purchase_group = {
			"grenadier",
			"grenadier_pro",
		},
		upgrades = {
			{
				"player_grenadier_grenade_quantity_1",
			},
			{
				"player_grenadier_explosive_damage_reduction_1",
			},
			{
				"player_grenadier_explosive_warcry_fill_multiplier_1",
			},
			{
				"player_grenadier_grenade_radius_multiplier_1",
			},
		},
		upgrades_desc = {
			"skill_grenadier_stat_line_1",
			"skill_grenadier_stat_line_2",
			"skill_grenadier_stat_line_3",
			"skill_grenadier_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.grenadier_pro = deep_clone(self.skills.grenadier)
	self.skills.grenadier_pro.name_id = "skill_grenadier_pro_name"
	self.skills.grenadier_pro.class_lock = {
		SkillTreeTweakData.CLASS_DEMOLITIONS,
	}
	self.skills.grenadier_pro.upgrades = {
		{
			"player_grenadier_grenade_quantity_2",
		},
		{
			"player_grenadier_explosive_damage_reduction_2",
		},
		{
			"player_grenadier_explosive_warcry_fill_multiplier_2",
		},
		{
			"player_grenadier_grenade_radius_multiplier_2",
		},
	}
	self.skills.pack_mule = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
		},
		desc_id = "skill_pack_mule_desc",
		icon = "skills_pack_mule",
		level_required = 20,
		name_id = "skill_pack_mule_name",
		upgrades = {
			{
				"player_pack_mule_ammo_total_increase",
			},
			{
				"player_pack_mule_equipment_quantity",
			},
			{
				"carry_pack_mule_weight_increase",
			},
			{
				"player_pack_mule_ammo_share_team",
			},
		},
		upgrades_desc = {
			"skill_pack_mule_stat_line_1",
			"skill_pack_mule_stat_line_2",
			"skill_pack_mule_stat_line_3",
			"skill_pack_mule_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.leaded = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		desc_id = "skill_leaded_desc",
		icon = "skills_leaded",
		level_required = 20,
		name_id = "skill_leaded_name",
		upgrades = {
			{
				"player_leaded_ammo_sponge_1",
				"player_leaded_damage_reduction_1",
			},
			{
				"player_leaded_magazine_refill",
			},
			{
				"player_leaded_ammo_sponge_2",
			},
			{
				"player_leaded_damage_reduction_2",
			},
		},
		upgrades_desc = {
			"skill_leaded_stat_line_1",
			"skill_leaded_stat_line_2",
			"skill_leaded_stat_line_3",
			"skill_leaded_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.fragstone = {
		class_lock = {
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_fragstone_desc",
		icon = "skills_fragstone",
		level_required = 20,
		name_id = "skill_fragstone_name",
		upgrades = {
			{
				"player_fragstone_downed_martyrdom_1",
			},
			{
				"player_fragstone_grenades_when_downed",
			},
			{
				"player_fragstone_downed_martyrdom_2",
			},
			{
				"player_fragstone_martyrdom_no_consumption",
			},
		},
		upgrades_desc = {
			"skill_fragstone_stat_line_1",
			"skill_fragstone_stat_line_2",
			"skill_fragstone_stat_line_3",
			"skill_fragstone_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.pickpocket = {
		desc_id = "skill_pickpocket_desc",
		icon = "skills_pickpocket",
		info_id = "skill_pickpocket_info",
		level_required = 20,
		name_id = "skill_pickpocket_name",
		upgrades = {
			{
				"temporary_pickpocket_melee_ammo_steal",
			},
			{
				"player_pickpocket_melee_health_steal",
			},
			{
				"player_pickpocket_uncover_detection",
			},
			{
				"interaction_pickpocket_greed_steal",
			},
		},
		upgrades_desc = {
			"skill_pickpocket_stat_line_1",
			"skill_pickpocket_stat_line_2",
			"skill_pickpocket_stat_line_3",
			"skill_pickpocket_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.fast_hands = {
		desc_id = "skill_fast_hands_desc",
		icon = "skills_fast_hands",
		level_required = 20,
		name_id = "skill_fast_hands_name",
		upgrades = {
			{
				"player_fasthand_enter_steelsight_speed_multiplier",
			},
			{
				"player_fasthand_climb_speed_increase",
				"player_fasthand_mantle_speed_increase",
			},
			{
				"player_fasthand_swap_speed_multiplier",
			},
			{
				"weapon_fasthand_reload_speed_multiplier",
			},
		},
		upgrades_desc = {
			"skill_fast_hands_stat_line_1",
			"skill_fast_hands_stat_line_2",
			"skill_fast_hands_stat_line_3",
			"skill_fast_hands_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.farsighted = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
		},
		desc_id = "skill_farsighted_desc",
		icon = "skills_farsighted",
		info_id = "skill_farsighted_info",
		level_required = 24,
		name_id = "skill_farsighted_name",
		upgrades = {
			{
				"primary_weapon_farsighted_long_range_damage_multiplier",
			},
			{
				"player_farsighted_steelsight_fov_multiplier",
			},
			{
				"player_farsighted_long_range_warcry_fill_multiplier",
			},
			{
				"player_farsighted_long_range_critical_hit_chance",
			},
		},
		upgrades_desc = {
			"skill_farsighted_stat_line_1",
			"skill_farsighted_stat_line_2",
			"skill_farsighted_stat_line_3",
			"skill_farsighted_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.bellhop = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
		},
		desc_id = "skill_bellhop_desc",
		icon = "skills_bellhop",
		level_required = 24,
		name_id = "skill_bellhop_name",
		upgrades = {
			{
				"player_bellhop_weight_increase_off_primary",
			},
			{
				"player_bellhop_carry_stamina_consume_slower_1",
			},
			{
				"player_bellhop_weight_penalty_removal_melees",
				"player_bellhop_weight_penalty_removal_throwables",
			},
			{
				"player_bellhop_carry_stamina_consume_slower_2",
			},
		},
		upgrades_desc = {
			"skill_bellhop_stat_line_1",
			"skill_bellhop_stat_line_2",
			"skill_bellhop_stat_line_3",
			"skill_bellhop_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.agile = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		desc_id = "skill_agile_desc",
		icon = "skills_agile",
		level_required = 24,
		name_id = "skill_agile_name",
		upgrades = {
			{
				"player_agile_ready_weapon_speed_multiplier",
			},
			{
				"player_agile_moving_spread_multiplier",
			},
			{
				"player_agile_running_damage_reduction",
			},
			{
				"player_agile_run_and_reload",
			},
		},
		upgrades_desc = {
			"skill_agile_stat_line_1",
			"skill_agile_stat_line_2",
			"skill_agile_stat_line_3",
			"skill_agile_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.marshal = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
			SkillTreeTweakData.CLASS_ASSAULT,
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_marshal_desc",
		icon = "skills_marshal",
		info_id = "skill_marshal_info",
		level_required = 24,
		name_id = "skill_marshal_name",
		purchase_group = {
			"marshal",
			"marshal_pro",
		},
		upgrades = {
			{
				"player_marshal_max_multiplier_stacks",
				"pistol_marshal_stacking_reload_speed_multiplier",
				"player_marshal_stack_decay_timer_1",
			},
			{
				"player_marshal_stacking_melee_damage_1",
			},
			{
				"player_marshal_stack_decay_timer_2",
			},
			{
				"pistol_marshal_stacking_damage_multiplier_1",
			},
		},
		upgrades_desc = {
			"skill_marshal_stat_line_1",
			"skill_marshal_stat_line_2",
			"skill_marshal_stat_line_3",
			"skill_marshal_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.marshal_pro = deep_clone(self.skills.marshal)
	self.skills.marshal_pro.name_id = "skill_marshal_pro_name"
	self.skills.marshal_pro.class_lock = {
		SkillTreeTweakData.CLASS_RECON,
	}
	self.skills.marshal_pro.upgrades[2] = {
		"player_marshal_stacking_melee_damage_2",
		"player_marshal_stacking_melee_damage_1",
	}
	self.skills.marshal_pro.upgrades[4] = {
		"pistol_marshal_stacking_damage_multiplier_2",
		"pistol_marshal_stacking_damage_multiplier_1",
	}
	self.skills.anatomist = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
		},
		desc_id = "skill_anatomist_desc",
		icon = "skills_anatomist",
		level_required = 28,
		name_id = "skill_anatomist_name",
		upgrades = {
			{
				"primary_weapon_anatomist_bodyshot_damage_multiplier",
			},
			{
				"secondary_weapon_anatomist_headshot_damage_multiplier",
			},
			{
				"snp_anatomist_critical_hit_chance",
				"smg_anatomist_critical_hit_chance",
			},
			{
				"weapon_anatomist_legshot_knockdown",
			},
		},
		upgrades_desc = {
			"skill_anatomist_stat_line_1",
			"skill_anatomist_stat_line_2",
			"skill_anatomist_stat_line_3",
			"skill_anatomist_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.rally = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
		},
		desc_id = "skill_rally_desc",
		icon = "skills_rally",
		info_id = "skill_rally_info",
		level_required = 28,
		name_id = "skill_rally_name",
		upgrades = {
			{
				"player_rally_recoverable_damage_ratio_1",
				"player_rally_recoverable_health_1",
				"player_rally_low_health_regen_multiplier",
			},
			{
				"player_rally_recovery_headshot_multiplier",
			},
			{
				"player_rally_recoverable_health_2",
			},
			{
				"player_rally_recoverable_damage_ratio_2",
			},
		},
		upgrades_desc = {
			"skill_rally_stat_line_1",
			"skill_rally_stat_line_2",
			"skill_rally_stat_line_3",
			"skill_rally_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.sapper = {
		class_lock = {
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_sapper_desc",
		icon = "skills_sapper",
		level_required = 28,
		name_id = "skill_sapper_name",
		upgrades = {
			{
				"player_sapper_mine_quantity",
			},
			{
				"interaction_sapper_crowbar_speed_multiplier",
			},
			{
				"interaction_sapper_lockpick_crate_bypass",
			},
			{
				"player_sapper_tank_disabler",
				"player_sapper_tank_disabler_cooldown",
			},
		},
		upgrades_desc = {
			"skill_sapper_stat_line_1",
			"skill_sapper_stat_line_2",
			"skill_sapper_stat_line_3",
			"skill_sapper_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.revenant = {
		desc_id = "skill_revenant_desc",
		icon = "skills_revenant",
		level_required = 28,
		name_id = "skill_revenant_name",
		upgrades = {
			{
				"player_revenant_additional_life",
				"player_revenant_bleedout_timer_reduction",
			},
			{
				"player_revenant_steelsight_when_downed",
			},
			{
				"temporary_revenant_revived_damage_reduction",
			},
			{
				"temporary_revenant_revived_critical_hit_chance",
				"player_revenant_downed_critical_hit_chance",
			},
		},
		upgrades_desc = {
			"skill_revenant_stat_line_1",
			"skill_revenant_stat_line_2",
			"skill_revenant_stat_line_3",
			"skill_revenant_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.big_game = {
		class_lock = {
			SkillTreeTweakData.CLASS_RECON,
		},
		desc_id = "skill_big_game_desc",
		icon = "skills_big_game",
		level_required = 30,
		name_id = "skill_big_game_name",
		upgrades = {
			{
				"player_big_game_retrigger_time",
				"player_big_game_special_sense_1",
			},
			{
				"player_big_game_highlight_enemy_multiplier",
			},
			{
				"player_big_game_special_sense_2",
			},
			{
				"temporary_big_game_special_health_regen",
			},
		},
		upgrades_desc = {
			"skill_big_game_stat_line_1",
			"skill_big_game_stat_line_2",
			"skill_big_game_stat_line_3",
			"skill_big_game_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.brutality = {
		class_lock = {
			SkillTreeTweakData.CLASS_ASSAULT,
		},
		desc_id = "skill_brutality_desc",
		icon = "skills_brutality",
		level_required = 30,
		name_id = "skill_brutality_name",
		upgrades = {
			{
				"player_brutality_dismemberment_warcry_fill_multiplier",
			},
			{
				"player_brutality_single_critical_hit_chance",
			},
			{
				"player_brutality_single_dismember_chance",
			},
			{
				"temporary_brutality_dismember_critical_hit_chance",
			},
		},
		upgrades_desc = {
			"skill_brutality_stat_line_1",
			"skill_brutality_stat_line_2",
			"skill_brutality_stat_line_3",
			"skill_brutality_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.toughness = {
		class_lock = {
			SkillTreeTweakData.CLASS_INFILTRATOR,
		},
		desc_id = "skill_toughness_desc",
		icon = "skills_toughness",
		level_required = 30,
		name_id = "skill_toughness_name",
		upgrades = {
			{
				"player_toughness_low_health_regen_limit_multiplier",
			},
			{
				"player_toughness_low_health_warcry_fill_multiplier",
			},
			{
				"player_toughness_critical_damage_reduction",
			},
			{
				"player_toughness_death_defiant",
			},
		},
		upgrades_desc = {
			"skill_toughness_stat_line_1",
			"skill_toughness_stat_line_2",
			"skill_toughness_stat_line_3",
			"skill_toughness_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
	self.skills.blammfu = {
		class_lock = {
			SkillTreeTweakData.CLASS_DEMOLITIONS,
		},
		desc_id = "skill_blammfu_desc",
		icon = "skills_blammfu",
		level_required = 30,
		name_id = "skill_blammfu_name",
		upgrades = {
			{
				"player_blammfu_explosive_grenade_melee_1",
			},
			{
				"grenade_swap_speed_multiplier",
			},
			{
				"player_blammfu_grenade_player_damage_reduction",
			},
			{
				"player_blammfu_explosive_grenade_melee_2",
			},
		},
		upgrades_desc = {
			"skill_blammfu_stat_line_1",
			"skill_blammfu_stat_line_2",
			"skill_blammfu_stat_line_3",
			"skill_blammfu_stat_line_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_TALENT,
	}
end

function SkillTreeTweakData:_init_skill_list_weapons()
	self.skills.weapon_tier_unlocked_2 = {
		acquires = {},
		desc_id = "skill_weapon_tier_unlocked_2_desc",
		icon = "skills_weapon_tier_2",
		icon_large = "skills_weapon_tier_2",
		name_id = "skill_weapon_tier_unlocked_2_name",
		upgrades = {
			"player_weapon_tier_unlocked_2",
		},
		upgrades_type = SkillTreeTweakData.TYPE_UNLOCKS,
	}
	self.skills.weapon_tier_unlocked_3 = {
		acquires = {},
		desc_id = "skill_weapon_tier_unlocked_3_desc",
		icon = "skills_weapon_tier_3",
		icon_large = "skills_weapon_tier_3",
		name_id = "skill_weapon_tier_unlocked_3_name",
		upgrades = {
			"player_weapon_tier_unlocked_3",
		},
		upgrades_type = SkillTreeTweakData.TYPE_UNLOCKS,
	}
	self.skills.weapon_tier_unlocked_4 = {
		acquires = {},
		desc_id = "skill_weapon_tier_unlocked_4_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4",
		name_id = "skill_weapon_tier_unlocked_4_name",
		upgrades = {
			"player_weapon_tier_unlocked_4",
		},
		upgrades_type = SkillTreeTweakData.TYPE_UNLOCKS,
	}
	self.skills.recon_tier_4_unlocked = {
		acquires = {},
		desc_id = "skill_recon_tier_4_unlocked_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4",
		name_id = "skill_recon_tier_4_unlocked_name",
		upgrades = {
			"player_recon_tier_4_unlocked",
		},
		upgrades_type = SkillTreeTweakData.TYPE_UNLOCKS,
	}
	self.skills.assault_tier_4_unlocked = {
		acquires = {},
		desc_id = "skill_assault_tier_4_unlocked_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4",
		name_id = "skill_assault_tier_4_unlocked_name",
		upgrades = {
			"player_assault_tier_4_unlocked",
		},
		upgrades_type = SkillTreeTweakData.TYPE_UNLOCKS,
	}
	self.skills.infiltrator_tier_4_unlocked = {
		acquires = {},
		desc_id = "skill_infiltrator_tier_4_unlocked_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4",
		name_id = "skill_infiltrator_tier_4_unlocked_name",
		upgrades = {
			"player_infiltrator_tier_4_unlocked",
		},
		upgrades_type = SkillTreeTweakData.TYPE_UNLOCKS,
	}
	self.skills.demolitions_tier_4_unlocked = {
		acquires = {},
		desc_id = "skill_demolitions_tier_4_unlocked_desc",
		icon = "skills_weapon_tier_4",
		icon_large = "skills_weapon_tier_4",
		name_id = "skill_demolitions_tier_4_unlocked_name",
		upgrades = {
			"player_demolitions_tier_4_unlocked",
		},
		upgrades_type = SkillTreeTweakData.TYPE_UNLOCKS,
	}
	self.skills.weapon_unlock_springfield = {
		acquires = {},
		desc_id = "skill_weapon_unlock_springfield_desc",
		name_id = "skill_weapon_unlock_springfield_name",
		upgrades = {
			"m1903",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_m1911 = {
		acquires = {},
		desc_id = "skill_weapon_unlock_m1911_desc",
		name_id = "skill_weapon_unlock_m1911_name",
		upgrades = {
			"m1911",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_c96 = {
		acquires = {},
		desc_id = "skill_weapon_unlock_c96_desc",
		name_id = "skill_weapon_unlock_c96_name",
		upgrades = {
			"c96",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_webley = {
		acquires = {},
		desc_id = "skill_weapon_unlock_webley_desc",
		name_id = "skill_weapon_unlock_webley_name",
		upgrades = {
			"webley",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_sten = {
		acquires = {},
		desc_id = "skill_weapon_unlock_sten_desc",
		name_id = "skill_weapon_unlock_sten_name",
		upgrades = {
			"sten",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_mp38 = {
		acquires = {},
		desc_id = "skill_weapon_unlock_mp38_desc",
		name_id = "skill_weapon_unlock_mp38_name",
		upgrades = {
			"mp38",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_thompson = {
		acquires = {},
		desc_id = "skill_weapon_unlock_thompson_desc",
		name_id = "skill_weapon_unlock_thompson_name",
		upgrades = {
			"thompson",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_garand = {
		acquires = {},
		desc_id = "skill_weapon_unlock_garand_desc",
		name_id = "skill_weapon_unlock_garand_name",
		upgrades = {
			"garand",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_winchester = {
		acquires = {},
		desc_id = "skill_weapon_unlock_winchester_desc",
		name_id = "skill_weapon_unlock_winchester_name",
		upgrades = {
			"m1912",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_sterling = {
		acquires = {},
		desc_id = "skill_weapon_unlock_sterling_desc",
		name_id = "skill_weapon_unlock_sterling_name",
		upgrades = {
			"sterling",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_bar = {
		acquires = {},
		desc_id = "skill_weapon_unlock_bar_desc",
		name_id = "skill_weapon_unlock_bar_name",
		upgrades = {
			"m1918",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_mp44 = {
		acquires = {},
		desc_id = "skill_weapon_unlock_mp44_desc",
		name_id = "skill_weapon_unlock_mp44_name",
		upgrades = {
			"mp44",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_mosin = {
		acquires = {},
		desc_id = "skill_weapon_unlock_mosin_desc",
		name_id = "skill_weapon_unlock_mosin_name",
		upgrades = {
			"mosin",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_carbine = {
		acquires = {},
		desc_id = "skill_weapon_unlock_carbine_desc",
		name_id = "skill_weapon_unlock_carbine_name",
		upgrades = {
			"carbine",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_mg42 = {
		acquires = {},
		desc_id = "skill_weapon_unlock_mg42_desc",
		name_id = "skill_weapon_unlock_mg42_name",
		upgrades = {
			"mg42",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_geco = {
		acquires = {},
		desc_id = "skill_weapon_unlock_geco_desc",
		name_id = "skill_weapon_unlock_geco_name",
		upgrades = {
			"geco",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_grenade_concrete = {
		acquires = {},
		desc_id = "skill_weapon_unlock_grenade_concrete_desc",
		name_id = "skill_weapon_unlock_grenade_concrete_name",
		upgrades = {
			"concrete",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_grenade_d343 = {
		acquires = {},
		desc_id = "skill_weapon_unlock_grenade_d343_desc",
		name_id = "skill_weapon_unlock_grenade_d343_name",
		upgrades = {
			"d343",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_grenade_mills = {
		acquires = {},
		desc_id = "skill_weapon_unlock_grenade_mills_desc",
		name_id = "skill_weapon_unlock_grenade_mills_name",
		upgrades = {
			"mills",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_decoy_coin = {
		acquires = {},
		desc_id = "skill_weapon_unlock_decoy_coin_desc",
		name_id = "skill_weapon_unlock_decoy_coin_name",
		upgrades = {
			"decoy_coin",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_grenade_betty = {
		acquires = {},
		desc_id = "skill_weapon_unlock_grenade_betty_desc",
		name_id = "skill_weapon_unlock_grenade_betty_name",
		upgrades = {
			"betty",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_grenade_gold_bar = {
		acquires = {},
		desc_id = "skill_weapon_unlock_grenade_gold_bar_desc",
		name_id = "skill_weapon_unlock_grenade_gold_bar_name",
		upgrades = {
			"gold_bar",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_dp28 = {
		acquires = {},
		desc_id = "skill_weapon_unlock_dp28_desc",
		name_id = "skill_weapon_unlock_dp28_name",
		upgrades = {
			"dp28",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_bren = {
		acquires = {},
		desc_id = "skill_weapon_unlock_bren_desc",
		name_id = "skill_weapon_unlock_bren_name",
		upgrades = {
			"bren",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_tt33 = {
		acquires = {},
		desc_id = "skill_weapon_unlock_tt33_desc",
		name_id = "skill_weapon_unlock_tt33_name",
		upgrades = {
			"tt33",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_georg = {
		acquires = {},
		desc_id = "skill_weapon_unlock_georg_desc",
		name_id = "skill_weapon_unlock_georg_name",
		upgrades = {
			"georg",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_kar_98k = {
		acquires = {},
		desc_id = "skill_weapon_unlock_kar_98k_desc",
		name_id = "skill_weapon_unlock_kar_98k_name",
		upgrades = {
			"kar_98k",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_lee_enfield = {
		acquires = {},
		desc_id = "skill_weapon_unlock_lee_enfield_desc",
		name_id = "skill_weapon_unlock_lee_enfield_name",
		upgrades = {
			"lee_enfield",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_ithaca = {
		acquires = {},
		desc_id = "skill_weapon_unlock_ithaca_desc",
		name_id = "skill_weapon_unlock_ithaca_name",
		upgrades = {
			"ithaca",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_browning = {
		acquires = {},
		desc_id = "skill_weapon_unlock_browning_desc",
		name_id = "skill_weapon_unlock_browning_name",
		upgrades = {
			"browning",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_welrod = {
		acquires = {},
		desc_id = "skill_weapon_unlock_welrod_desc",
		name_id = "skill_weapon_unlock_welrod_name",
		upgrades = {
			"welrod",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
	self.skills.weapon_unlock_shotty = {
		acquires = {},
		desc_id = "skill_weapon_unlock_shotty_desc",
		name_id = "skill_weapon_unlock_shotty_name",
		upgrades = {
			"shotty",
		},
		upgrades_type = SkillTreeTweakData.TYPE_WEAPON,
	}
end

function SkillTreeTweakData:get_weapon_unlock_levels()
	local t = {}

	for class_name, class_unlock_data in pairs(self.automatic_unlock_progressions) do
		for level, unlock_data in pairs(class_unlock_data) do
			if unlock_data.weapons then
				for _, weapon_unlock in pairs(unlock_data.weapons) do
					for _, upgrade in ipairs(self.skills[weapon_unlock].upgrades) do
						if not t[upgrade] then
							t[upgrade] = {}
						end

						t[upgrade][class_name] = level
					end
				end
			end
		end
	end

	return t
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
	self.automatic_unlock_progressions.recon = {
		{
			weapons = {
				"weapon_unlock_springfield",
				"weapon_unlock_carbine",
				"weapon_unlock_c96",
			},
		},
		[3] = {
			weapons = {
				"weapon_unlock_sten",
			},
		},
		[5] = {
			weapons = {
				"weapon_unlock_tt33",
			},
		},
		[7] = {
			weapons = {
				"weapon_unlock_decoy_coin",
			},
		},
		[8] = {
			weapons = {
				"weapon_unlock_grenade_concrete",
			},
		},
		[9] = {
			weapons = {
				"weapon_unlock_welrod",
			},
		},
		[10] = {
			weapons = {
				"weapon_unlock_kar_98k",
			},
		},
		[11] = {
			weapons = {
				"weapon_unlock_shotty",
			},
		},
		[12] = {
			weapons = {
				"weapon_unlock_grenade_betty",
			},
		},
		[13] = {
			weapons = {
				"weapon_unlock_garand",
			},
		},
		[15] = {
			unlocks = {
				"weapon_tier_unlocked_2",
			},
			weapons = {
				"weapon_unlock_thompson",
				"weapon_unlock_grenade_gold_bar",
			},
		},
		[18] = {
			weapons = {
				"weapon_unlock_webley",
			},
		},
		[21] = {
			weapons = {
				"weapon_unlock_grenade_d343",
			},
		},
		[22] = {
			weapons = {
				"weapon_unlock_georg",
			},
		},
		[23] = {
			weapons = {
				"weapon_unlock_mosin",
			},
		},
		[25] = {
			unlocks = {
				"weapon_tier_unlocked_3",
			},
			weapons = {
				"weapon_unlock_mp38",
			},
		},
		[30] = {
			weapons = {
				"weapon_unlock_m1911",
			},
		},
		[31] = {
			weapons = {
				"weapon_unlock_grenade_mills",
			},
		},
		[33] = {
			weapons = {
				"weapon_unlock_lee_enfield",
			},
		},
		[35] = {
			unlocks = {
				"recon_tier_4_unlocked",
				"assault_tier_4_unlocked",
				"infiltrator_tier_4_unlocked",
				"demolitions_tier_4_unlocked",
			},
		},
		[38] = {
			weapons = {
				"weapon_unlock_sterling",
			},
		},
		[40] = {
			weapons = {
				"weapon_unlock_mp44",
			},
		},
	}
	self.default_weapons.recon = {}
	self.default_weapons.recon.primary = "m1903"
	self.default_weapons.recon.secondary = "c96"
end

function SkillTreeTweakData:_init_assault_unlock_progression()
	self.automatic_unlock_progressions.assault = {
		{
			weapons = {
				"weapon_unlock_carbine",
				"weapon_unlock_sten",
				"weapon_unlock_c96",
			},
		},
		[3] = {
			weapons = {
				"weapon_unlock_bar",
			},
		},
		[5] = {
			weapons = {
				"weapon_unlock_tt33",
			},
		},
		[8] = {
			weapons = {
				"weapon_unlock_grenade_concrete",
			},
		},
		[10] = {
			weapons = {
				"weapon_unlock_garand",
				"weapon_unlock_grenade_gold_bar",
			},
		},
		[11] = {
			weapons = {
				"weapon_unlock_thompson",
			},
		},
		[15] = {
			unlocks = {
				"weapon_tier_unlocked_2",
			},
			weapons = {
				"weapon_unlock_dp28",
				"weapon_unlock_decoy_coin",
			},
		},
		[17] = {
			weapons = {
				"weapon_unlock_webley",
			},
		},
		[19] = {
			weapons = {
				"weapon_unlock_shotty",
			},
		},
		[20] = {
			weapons = {
				"weapon_unlock_grenade_betty",
			},
		},
		[21] = {
			weapons = {
				"weapon_unlock_grenade_d343",
			},
		},
		[22] = {
			weapons = {
				"weapon_unlock_welrod",
			},
		},
		[24] = {
			weapons = {
				"weapon_unlock_georg",
			},
		},
		[25] = {
			unlocks = {
				"weapon_tier_unlocked_3",
			},
			weapons = {
				"weapon_unlock_bren",
			},
		},
		[28] = {
			weapons = {
				"weapon_unlock_mp38",
			},
		},
		[30] = {
			weapons = {
				"weapon_unlock_m1911",
			},
		},
		[31] = {
			weapons = {
				"weapon_unlock_grenade_mills",
			},
		},
		[33] = {
			weapons = {
				"weapon_unlock_mp44",
			},
		},
		[35] = {
			unlocks = {
				"recon_tier_4_unlocked",
				"assault_tier_4_unlocked",
				"infiltrator_tier_4_unlocked",
				"demolitions_tier_4_unlocked",
			},
		},
		[38] = {
			weapons = {
				"weapon_unlock_mg42",
			},
		},
		[40] = {
			weapons = {
				"weapon_unlock_sterling",
			},
		},
	}
	self.default_weapons.assault = {}
	self.default_weapons.assault.primary = "carbine"
	self.default_weapons.assault.secondary = "c96"
end

function SkillTreeTweakData:_init_infiltrator_unlock_progression()
	self.automatic_unlock_progressions.infiltrator = {
		{
			weapons = {
				"weapon_unlock_sten",
				"weapon_unlock_winchester",
				"weapon_unlock_c96",
			},
		},
		[3] = {
			weapons = {
				"weapon_unlock_carbine",
			},
		},
		[5] = {
			weapons = {
				"weapon_unlock_tt33",
			},
		},
		[7] = {
			weapons = {
				"weapon_unlock_grenade_concrete",
			},
		},
		[10] = {
			weapons = {
				"weapon_unlock_thompson",
			},
		},
		[11] = {
			weapons = {
				"weapon_unlock_shotty",
				"weapon_unlock_decoy_coin",
			},
		},
		[13] = {
			weapons = {
				"weapon_unlock_geco",
			},
		},
		[15] = {
			unlocks = {
				"weapon_tier_unlocked_2",
			},
			weapons = {
				"weapon_unlock_garand",
				"weapon_unlock_grenade_gold_bar",
			},
		},
		[16] = {
			weapons = {
				"weapon_unlock_welrod",
			},
		},
		[18] = {
			weapons = {
				"weapon_unlock_webley",
			},
		},
		[20] = {
			weapons = {
				"weapon_unlock_grenade_d343",
				"weapon_unlock_grenade_betty",
			},
		},
		[21] = {
			weapons = {
				"weapon_unlock_georg",
			},
		},
		[23] = {
			weapons = {
				"weapon_unlock_mp38",
			},
		},
		[25] = {
			unlocks = {
				"weapon_tier_unlocked_3",
			},
		},
		[28] = {
			weapons = {
				"weapon_unlock_ithaca",
			},
		},
		[30] = {
			weapons = {
				"weapon_unlock_m1911",
			},
		},
		[31] = {
			weapons = {
				"weapon_unlock_grenade_mills",
			},
		},
		[33] = {
			weapons = {
				"weapon_unlock_sterling",
			},
		},
		[35] = {
			unlocks = {
				"recon_tier_4_unlocked",
				"assault_tier_4_unlocked",
				"infiltrator_tier_4_unlocked",
				"demolitions_tier_4_unlocked",
			},
		},
		[38] = {
			weapons = {
				"weapon_unlock_mp44",
			},
		},
		[40] = {
			weapons = {
				"weapon_unlock_browning",
			},
		},
	}
	self.default_weapons.infiltrator = {}
	self.default_weapons.infiltrator.primary = "sten"
	self.default_weapons.infiltrator.secondary = "c96"
end

function SkillTreeTweakData:_init_demolitions_unlock_progression()
	self.automatic_unlock_progressions.demolitions = {
		{
			weapons = {
				"weapon_unlock_winchester",
				"weapon_unlock_bar",
				"weapon_unlock_c96",
			},
		},
		[3] = {
			weapons = {
				"weapon_unlock_carbine",
			},
		},
		[5] = {
			weapons = {
				"weapon_unlock_tt33",
			},
		},
		[6] = {
			weapons = {
				"weapon_unlock_grenade_concrete",
			},
		},
		[8] = {
			weapons = {
				"weapon_unlock_shotty",
			},
		},
		[10] = {
			weapons = {
				"weapon_unlock_geco",
				"weapon_unlock_grenade_betty",
			},
		},
		[12] = {
			weapons = {
				"weapon_unlock_grenade_gold_bar",
			},
		},
		[13] = {
			weapons = {
				"weapon_unlock_dp28",
			},
		},
		[15] = {
			unlocks = {
				"weapon_tier_unlocked_2",
			},
			weapons = {
				"weapon_unlock_garand",
				"weapon_unlock_decoy_coin",
			},
		},
		[18] = {
			weapons = {
				"weapon_unlock_webley",
			},
		},
		[19] = {
			weapons = {
				"weapon_unlock_grenade_d343",
			},
		},
		[23] = {
			weapons = {
				"weapon_unlock_ithaca",
				"weapon_unlock_welrod",
			},
		},
		[24] = {
			weapons = {
				"weapon_unlock_georg",
			},
		},
		[25] = {
			unlocks = {
				"weapon_tier_unlocked_3",
			},
		},
		[28] = {
			weapons = {
				"weapon_unlock_bren",
			},
		},
		[30] = {
			weapons = {
				"weapon_unlock_m1911",
			},
		},
		[31] = {
			weapons = {
				"weapon_unlock_grenade_mills",
			},
		},
		[33] = {
			weapons = {
				"weapon_unlock_browning",
			},
		},
		[35] = {
			unlocks = {
				"recon_tier_4_unlocked",
				"assault_tier_4_unlocked",
				"infiltrator_tier_4_unlocked",
				"demolitions_tier_4_unlocked",
			},
		},
		[38] = {
			weapons = {
				"weapon_unlock_mp44",
			},
		},
		[40] = {
			weapons = {
				"weapon_unlock_mg42",
			},
		},
	}
	self.default_weapons.demolitions = {}
	self.default_weapons.demolitions.primary = "m1912"
	self.default_weapons.demolitions.secondary = "c96"
end

function SkillTreeTweakData.get_skill_exp_requirements(level, multi)
	local reqs = {}

	for i = 1, 4 do
		local a = SkillTreeTweakData._EXP_REQS[1][i]

		if level > 1 then
			local b = SkillTreeTweakData._EXP_REQS[2][i]
			local c = math.lerp(a, b, level / 40)

			table.insert(reqs, math.round(c * multi, 100))
		else
			table.insert(reqs, math.round(a * multi, 100))
		end
	end

	return reqs
end

function SkillTreeTweakData.get_skill_gold_requirements(level, multi)
	local cost = 0
	local a = SkillTreeTweakData._GOLD_REQS[1]

	if level > 1 then
		local b = SkillTreeTweakData._GOLD_REQS[2]
		local rampup = math.bezier(SkillTreeTweakData._GOLD_REQ_RAMPUP, level / 40)
		local c = math.lerp(a, b, rampup)

		cost = c * multi
	else
		cost = a * multi
	end

	local lowest = 10

	return math.max(lowest, math.round(cost, lowest))
end

function SkillTreeTweakData:get_skill_icon_tiered(id)
	if not self.skills[id] then
		return "skill_slot_unlocked"
	end

	local icons = self.skills[id].icon

	if type(icons) == "table" then
		local current_tier = managers.skilltree:get_skill_tier(id)

		return icons[math.clamp(current_tier, 1, #icons)]
	else
		return icons
	end
end
