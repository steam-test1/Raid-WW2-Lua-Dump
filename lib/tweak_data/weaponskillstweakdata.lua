WeaponSkillsTweakData = WeaponSkillsTweakData or class()
WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE = "increase_damage"
WeaponSkillsTweakData.SKILL_DECREASE_RECOIL = "decrease_recoil"
WeaponSkillsTweakData.SKILL_FASTER_RELOAD = "faster_reload"
WeaponSkillsTweakData.SKILL_FASTER_ADS = "faster_ads"
WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD = "tighter_spread"
WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE = "increase_magazine"
WeaponSkillsTweakData.MAX_SKILLS_IN_TIER = 4
WeaponSkillsTweakData.MAX_TIERS = 4

function WeaponSkillsTweakData:init()
	self.skills = {}
	self.skill_trees = {}

	self:_init_skills()
	self:_init_m1911_skill_tree()
	self:_init_c96_skill_tree()
	self:_init_thompson_skill_tree()
	self:_init_mp38_skill_tree()
	self:_init_sterling_skill_tree()
	self:_init_sten_skill_tree()
	self:_init_m1903_skill_tree()
	self:_init_mosin_skill_tree()
	self:_init_garand_skill_tree()
	self:_init_garand_golden_skill_tree()
	self:_init_m1918_skill_tree()
	self:_init_mg42_skill_tree()
	self:_init_mp44_skill_tree()
	self:_init_m1912_skill_tree()
	self:_init_carbine_skill_tree()
	self:_init_webley_skill_tree()
	self:_init_geco_skill_tree()
	self:_init_dp28_skill_tree()
	self:_init_tt33_skill_tree()
	self:_init_kar_98k_skill_tree()
	self:_init_bren_skill_tree()
	self:_init_lee_enfield_skill_tree()
	self:_init_shotty_skill_tree()
	self:_init_reedem_xp_values()
end

function WeaponSkillsTweakData:_init_skills()
	self.skills[WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE] = {
		desc_id = "weapon_skill_increase_damage_desc",
		icon = "wpn_skill_damage",
		name_id = "weapon_skill_increase_damage_name",
	}
	self.skills[WeaponSkillsTweakData.SKILL_DECREASE_RECOIL] = {
		desc_id = "weapon_skill_decrease_recoil_desc",
		icon = "wpn_skill_stability",
		name_id = "weapon_skill_decrease_recoil_name",
	}
	self.skills[WeaponSkillsTweakData.SKILL_FASTER_RELOAD] = {
		desc_id = "weapon_skill_faster_reload_desc",
		icon = "wpn_skill_blank",
		name_id = "weapon_skill_faster_reload_name",
	}
	self.skills[WeaponSkillsTweakData.SKILL_FASTER_ADS] = {
		desc_id = "weapon_skill_faster_ads_desc",
		icon = "wpn_skill_blank",
		name_id = "weapon_skill_faster_ads_name",
	}
	self.skills[WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD] = {
		desc_id = "weapon_skill_tighter_spread_desc",
		icon = "wpn_skill_accuracy",
		name_id = "weapon_skill_tighter_spread_name",
	}
	self.skills[WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE] = {
		desc_id = "weapon_skill_increase_magazine_desc",
		icon = "wpn_skill_mag_size",
		name_id = "weapon_skill_increase_magazine_name",
	}
end

function WeaponSkillsTweakData:_init_m1911_skill_tree()
	self.skill_trees.m1911 = {}
	self.skill_trees.m1911[1] = {}
	self.skill_trees.m1911[1][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 25,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						10,
						20,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_pis_m1911_ns_cutts",
			},
		},
	}
	self.skill_trees.m1911[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					reminders = {
						100,
						150,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_pis_m1911_m_extended",
			},
		},
	}
	self.skill_trees.m1911[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 125,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						40,
						70,
						100,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.m1911[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					reminders = {
						60,
						125,
						180,
						225,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1911[2] = {}
	self.skill_trees.m1911[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 35,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						15,
						25,
						30,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_pis_m1911_fg_tommy",
			},
		},
	}
	self.skill_trees.m1911[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 230,
					reminders = {
						200,
						400,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_pis_m1911_m_banana",
			},
		},
	}
	self.skill_trees.m1911[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 165,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						125,
						150,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_pis_m1911_s_wooden",
			},
		},
	}
	self.skill_trees.m1911[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					reminders = {
						50,
						100,
						200,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1911[3] = {}
	self.skill_trees.m1911[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 3,
			challenge_tasks = {
				{
					target = 45,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						15,
						25,
						35,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_pis_m1911_fg_tommy",
			},
		},
	}
	self.skill_trees.m1911[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 3,
			value = 5,
			challenge_tasks = {
				{
					target = 300,
					reminders = {
						100,
						200,
						250,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_pis_m1911_m_banana",
			},
		},
	}
	self.skill_trees.m1911[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 3,
			value = 3,
			challenge_tasks = {
				{
					target = 215,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_pis_m1911_s_wooden",
			},
		},
	}
	self.skill_trees.m1911[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 7,
			value = 3,
			challenge_tasks = {
				{
					target = 425,
					reminders = {
						100,
						200,
						300,
						400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1911.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_c96_skill_tree()
	self.skill_trees.c96 = {}
	self.skill_trees.c96[1] = {}
	self.skill_trees.c96[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					reminders = {
						60,
						125,
						180,
						225,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			weapon_parts = {
				"wpn_fps_pis_c96_b_long",
			},
		},
	}
	self.skill_trees.c96[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 125,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						40,
						70,
						100,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.c96[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					reminders = {
						100,
						150,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_pis_c96_m_extended",
			},
		},
	}
	self.skill_trees.c96[2] = {}
	self.skill_trees.c96[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					reminders = {
						100,
						200,
						250,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			weapon_parts = {
				"wpn_fps_pis_c96_b_long_finned",
			},
		},
	}
	self.skill_trees.c96[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 165,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						60,
						100,
						130,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_pis_c96_s_wooden",
			},
		},
	}
	self.skill_trees.c96[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 230,
					reminders = {
						100,
						200,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_pis_c96_m_long",
			},
		},
	}
	self.skill_trees.c96[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 35,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						10,
						20,
						30,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.c96.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_webley_skill_tree()
	self.skill_trees.webley = {}
	self.skill_trees.webley[1] = {}
	self.skill_trees.webley[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					reminders = {
						60,
						125,
						185,
						225,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.webley[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 25,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						10,
						20,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.webley[2] = {}
	self.skill_trees.webley[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					reminders = {
						100,
						170,
						260,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.webley[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 35,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						10,
						20,
						30,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.webley[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 165,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						30,
						60,
						90,
						130,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.webley.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_geco_skill_tree()
	self.skill_trees.geco = {}
	self.skill_trees.geco[1] = {}
	self.skill_trees.geco[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 5,
			challenge_tasks = {
				{
					target = 75,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.geco[2] = {}
	self.skill_trees.geco[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 6,
			challenge_tasks = {
				{
					target = 100,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						40,
						70,
						90,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_sho_geco_b_short",
			},
		},
	}
	self.skill_trees.geco[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.geco[3] = {}
	self.skill_trees.geco[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 4,
			value = 7,
			challenge_tasks = {
				{
					target = 130,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						80,
						110,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.geco[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
						800,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.geco[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 3,
			value = 3,
			challenge_tasks = {
				{
					target = 595,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_sho_geco_s_cheek_rest",
			},
		},
	}
	self.skill_trees.geco[4] = {}
	self.skill_trees.geco[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_ss_briefing",
			challenge_done_text_id = "weapon_skill_headshot_ss_completed",
			value = 8,
			challenge_tasks = {
				{
					target = 165,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						50,
						110,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.geco[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			cost = 4,
			value = 4,
			challenge_tasks = {
				{
					target = 30,
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						10,
						20,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.geco[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			cost = 3,
			value = 4,
			challenge_tasks = {
				{
					target = 770,
					modifiers = {
						headshot = true,
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.geco.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"demolitions_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_dp28_skill_tree()
	self.skill_trees.dp28 = {}
	self.skill_trees.dp28[1] = {}
	self.skill_trees.dp28[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_lmg_dp28_s_light",
			},
		},
	}
	self.skill_trees.dp28[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.dp28[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_lmg_dp28_b_coned",
			},
		},
	}
	self.skill_trees.dp28[2] = {}
	self.skill_trees.dp28[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_lmg_dp28_g_standard",
			},
		},
	}
	self.skill_trees.dp28[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.dp28[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_lmg_dp28_bipod",
			},
		},
	}
	self.skill_trees.dp28[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_lmg_dp28_m_extended",
				"wpn_fps_lmg_dp28_m_casing_ext",
				"wpn_fps_lmg_dp28_o_extended",
			},
		},
	}
	self.skill_trees.dp28.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_tt33_skill_tree()
	self.skill_trees.tt33 = {}
	self.skill_trees.tt33[1] = {}
	self.skill_trees.tt33[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					reminders = {
						60,
						125,
						185,
						225,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.tt33[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 25,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						10,
						20,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.tt33[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					reminders = {
						70,
						130,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_pis_tt33_m_extended",
			},
		},
	}
	self.skill_trees.tt33[2] = {}
	self.skill_trees.tt33[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					reminders = {
						70,
						130,
						200,
						270,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.tt33[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 35,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						10,
						20,
						30,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_pis_tt33_g_wooden",
			},
		},
	}
	self.skill_trees.tt33[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 230,
					reminders = {
						90,
						180,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_pis_tt33_m_long",
			},
		},
	}
	self.skill_trees.tt33[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 165,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						30,
						60,
						90,
						130,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_pis_tt33_ns_brake",
			},
		},
	}
	self.skill_trees.tt33.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_thompson_skill_tree()
	self.skill_trees.thompson = {}
	self.skill_trees.thompson[1] = {}
	self.skill_trees.thompson[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.thompson[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.thompson[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						450,
						900,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_thompson_m_short_double",
			},
		},
	}
	self.skill_trees.thompson[2] = {}
	self.skill_trees.thompson[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.thompson[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.thompson[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_thompson_m_standard",
			},
		},
	}
	self.skill_trees.thompson[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_thompson_fg_m1928",
			},
		},
	}
	self.skill_trees.thompson[3] = {}
	self.skill_trees.thompson[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
						800,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.thompson[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 425,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_smg_thompson_ns_cutts",
			},
		},
	}
	self.skill_trees.thompson[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_thompson_m_standard_double",
			},
		},
	}
	self.skill_trees.thompson[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 6,
			value = 3,
			challenge_tasks = {
				{
					target = 115,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						40,
						70,
						100,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_thompson_body_m1928",
				"wpn_fps_smg_thompson_dh_m1928",
			},
		},
	}
	self.skill_trees.thompson[4] = {}
	self.skill_trees.thompson[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			cost = 4,
			value = 4,
			challenge_tasks = {
				{
					target = 15,
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.thompson[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			cost = 4,
			value = 4,
			challenge_tasks = {
				{
					target = 15,
					modifiers = {
						headshot = true,
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						3,
						7,
						11,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_smg_thompson_b_m1928",
			},
		},
	}
	self.skill_trees.thompson[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_last_round_kill_briefing",
			challenge_done_text_id = "weapon_skill_last_round_kill_completed",
			cost = 6,
			value = 5,
			challenge_tasks = {
				{
					target = 20,
					modifiers = {
						last_round_in_magazine = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						5,
						10,
						15,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_thompson_m_drum",
			},
		},
	}
	self.skill_trees.thompson[4][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_ss_briefing",
			challenge_done_text_id = "weapon_skill_headshot_ss_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 10,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						3,
						9,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_thompson_o_m1928",
			},
		},
	}
	self.skill_trees.thompson.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"infiltrator_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_mp38_skill_tree()
	self.skill_trees.mp38 = {}
	self.skill_trees.mp38[1] = {}
	self.skill_trees.mp38[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.mp38[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_smg_mp38_dh_curved",
			},
		},
	}
	self.skill_trees.mp38[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_mp38_b_compensated",
			},
		},
	}
	self.skill_trees.mp38[2] = {}
	self.skill_trees.mp38[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.mp38[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_smg_mp38_s_wooden",
			},
		},
	}
	self.skill_trees.mp38[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_mp38_b_fluted",
			},
		},
	}
	self.skill_trees.mp38[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 5,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_mp38_m_standard_double",
			},
		},
	}
	self.skill_trees.mp38.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_sterling_skill_tree()
	self.skill_trees.sterling = {}
	self.skill_trees.sterling[1] = {}
	self.skill_trees.sterling[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.sterling[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						200,
						400,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_sterling_m_long",
			},
		},
	}
	self.skill_trees.sterling[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.sterling[2] = {}
	self.skill_trees.sterling[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_sterling_b_long",
			},
		},
	}
	self.skill_trees.sterling[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 5,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_sterling_m_long_double",
			},
		},
	}
	self.skill_trees.sterling[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.sterling[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.sterling.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_sten_skill_tree()
	self.skill_trees.sten = {}
	self.skill_trees.sten[1] = {}
	self.skill_trees.sten[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_smg_sten_s_wooden",
			},
		},
	}
	self.skill_trees.sten[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.sten[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_sten_body_mk3",
			},
		},
	}
	self.skill_trees.sten[1][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						200,
						400,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_sten_m_standard",
			},
		},
	}
	self.skill_trees.sten[2] = {}
	self.skill_trees.sten[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_smg_sten_ns_slanted",
			},
		},
	}
	self.skill_trees.sten[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.sten[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_sten_fg_wooden",
			},
		},
	}
	self.skill_trees.sten[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_sten_m_standard_double",
			},
		},
	}
	self.skill_trees.sten[3] = {}
	self.skill_trees.sten[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 3,
			challenge_tasks = {
				{
					target = 425,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_smg_sten_g_wooden",
			},
		},
	}
	self.skill_trees.sten[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
						800,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.sten[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 3,
			challenge_tasks = {
				{
					target = 115,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						40,
						70,
						100,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_sten_o_lee_enfield",
			},
		},
	}
	self.skill_trees.sten[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 3,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_sten_m_long",
			},
		},
	}
	self.skill_trees.sten[4] = {}
	self.skill_trees.sten[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			cost = 1,
			value = 4,
			challenge_tasks = {
				{
					target = 15,
					modifiers = {
						headshot = true,
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						3,
						7,
						11,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.sten[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			cost = 1,
			value = 4,
			challenge_tasks = {
				{
					target = 15,
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.sten[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_ss_briefing",
			challenge_done_text_id = "weapon_skill_headshot_ss_completed",
			cost = 1,
			value = 4,
			challenge_tasks = {
				{
					target = 10,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						3,
						9,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_smg_sten_body_mk3_vented",
			},
		},
	}
	self.skill_trees.sten[4][4] = {
		{
			challenge_briefing_id = "weapon_skill_last_round_kill_briefing",
			challenge_done_text_id = "weapon_skill_last_round_kill_completed",
			cost = 6,
			value = 5,
			challenge_tasks = {
				{
					target = 20,
					modifiers = {
						last_round_in_magazine = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						5,
						10,
						15,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_smg_sten_m_long_double",
			},
		},
	}
	self.skill_trees.sten.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"infiltrator_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_m1903_skill_tree()
	self.skill_trees.m1903 = {}
	self.skill_trees.m1903[1] = {}
	self.skill_trees.m1903[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_snp_m1903_body_type_c",
			},
		},
	}
	self.skill_trees.m1903[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 50,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.m1903[2] = {}
	self.skill_trees.m1903[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 230,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_snp_m1903_s_cheek_rest",
			},
		},
	}
	self.skill_trees.m1903[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						15,
						35,
						50,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_snp_m1903_ns_mclean",
			},
		},
	}
	self.skill_trees.m1903[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1903[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 3,
			value = 1,
			challenge_tasks = {
				{
					target = 550,
					reminders = {
						250,
						400,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_snp_m1903_m_extended",
			},
		},
	}
	self.skill_trees.m1903.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_kar_98k_skill_tree()
	self.skill_trees.kar_98k = {}
	self.skill_trees.kar_98k[1] = {}
	self.skill_trees.kar_98k[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_body_grip",
			},
		},
	}
	self.skill_trees.kar_98k[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 50,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.kar_98k[2] = {}
	self.skill_trees.kar_98k[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 230,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_pad_big",
			},
		},
	}
	self.skill_trees.kar_98k[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						15,
						35,
						50,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_b_long",
			},
		},
	}
	self.skill_trees.kar_98k[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 3,
			value = 1,
			challenge_tasks = {
				{
					target = 550,
					reminders = {
						250,
						400,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_m_extended",
			},
		},
	}
	self.skill_trees.kar_98k[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.kar_98k.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_lee_enfield_skill_tree()
	self.skill_trees.lee_enfield = {}
	self.skill_trees.lee_enfield[1] = {}
	self.skill_trees.lee_enfield[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_cheek_rest",
			},
		},
	}
	self.skill_trees.lee_enfield[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 50,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_ns_coned",
			},
		},
	}
	self.skill_trees.lee_enfield[2] = {}
	self.skill_trees.lee_enfield[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 230,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_pad_buffered",
			},
		},
	}
	self.skill_trees.lee_enfield[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						15,
						35,
						50,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_b_long",
			},
		},
	}
	self.skill_trees.lee_enfield[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 3,
			value = 1,
			challenge_tasks = {
				{
					target = 550,
					reminders = {
						250,
						400,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_m_extended",
			},
		},
	}
	self.skill_trees.lee_enfield[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.lee_enfield.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_mosin_skill_tree()
	self.skill_trees.mosin = {}
	self.skill_trees.mosin[1] = {}
	self.skill_trees.mosin[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_snp_mosin_body_grip",
			},
		},
	}
	self.skill_trees.mosin[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 50,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.mosin[2] = {}
	self.skill_trees.mosin[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 230,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_snp_mosin_body_target",
			},
		},
	}
	self.skill_trees.mosin[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						15,
						35,
						50,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_snp_mosin_b_long",
			},
		},
	}
	self.skill_trees.mosin[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.mosin.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_garand_skill_tree()
	self.skill_trees.garand = {}
	self.skill_trees.garand[1] = {}
	self.skill_trees.garand[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_ass_garand_s_cheek_rest",
			},
		},
	}
	self.skill_trees.garand[2] = {}
	self.skill_trees.garand[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 230,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.garand[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						15,
						35,
						50,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.garand[3] = {}
	self.skill_trees.garand[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 3,
			value = 3,
			challenge_tasks = {
				{
					target = 850,
					reminders = {
						200,
						400,
						600,
						800,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 300,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
						250,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.garand[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_ass_garand_ns_conical",
			},
		},
	}
	self.skill_trees.garand[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 1,
			challenge_tasks = {
				{
					target = 710,
					reminders = {
						200,
						400,
						620,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_ass_garand_m_bar_standard",
			},
		},
	}
	self.skill_trees.garand[4] = {}
	self.skill_trees.garand[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 15,
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshots_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_headshots_beyond_range_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 385,
					modifiers = {
						headshot = true,
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						200,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_ass_garand_b_tanker",
			},
		},
	}
	self.skill_trees.garand[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_ss_briefing",
			challenge_done_text_id = "weapon_skill_headshot_ss_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 10,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						3,
						9,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_ass_garand_s_folding",
			},
		},
	}
	self.skill_trees.garand[4][4] = {
		{
			challenge_briefing_id = "weapon_skill_last_round_kill_briefing",
			challenge_done_text_id = "weapon_skill_last_round_kill_completed",
			cost = 8,
			value = 2,
			challenge_tasks = {
				{
					target = 20,
					modifiers = {
						last_round_in_magazine = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						5,
						10,
						15,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_ass_garand_m_bar_extended",
			},
		},
	}
	self.skill_trees.garand.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"assault_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_garand_golden_skill_tree()
	self.skill_trees.garand_golden = {}
	self.skill_trees.garand_golden[1] = {}
	self.skill_trees.garand_golden[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand_golden[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 175,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_ass_garand_s_cheek_rest",
			},
		},
	}
	self.skill_trees.garand_golden[2] = {}
	self.skill_trees.garand_golden[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand_golden[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 300,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						250,
						400,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.garand_golden[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						15,
						35,
						50,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.garand_golden[3] = {}
	self.skill_trees.garand_golden[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 3,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
						800,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand_golden[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 300,
					modifiers = {
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						150,
						250,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.garand_golden[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_ass_garand_golden_ns_conical",
			},
		},
	}
	self.skill_trees.garand_golden[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 1,
			challenge_tasks = {
				{
					target = 710,
					reminders = {
						200,
						400,
						620,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_ass_garand_golden_m_bar_standard",
			},
		},
	}
	self.skill_trees.garand_golden[4] = {}
	self.skill_trees.garand_golden[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 15,
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand_golden[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshots_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_headshots_beyond_range_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 385,
					modifiers = {
						headshot = true,
						min_range = 1000,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						200,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_ass_garand_golden_b_tanker",
			},
		},
	}
	self.skill_trees.garand_golden[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_ss_briefing",
			challenge_done_text_id = "weapon_skill_headshot_ss_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 10,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						3,
						9,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_ass_garand_golden_s_folding",
			},
		},
	}
	self.skill_trees.garand_golden[4][4] = {
		{
			challenge_briefing_id = "weapon_skill_last_round_kill_briefing",
			challenge_done_text_id = "weapon_skill_last_round_kill_completed",
			cost = 8,
			value = 2,
			challenge_tasks = {
				{
					target = 20,
					modifiers = {
						last_round_in_magazine = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						5,
						10,
						15,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_ass_garand_golden_m_bar_extended",
			},
		},
	}
	self.skill_trees.garand_golden.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"assault_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_m1918_skill_tree()
	self.skill_trees.m1918 = {}
	self.skill_trees.m1918[1] = {}
	self.skill_trees.m1918[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_lmg_m1918_ns_cutts",
			},
		},
	}
	self.skill_trees.m1918[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1918[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_lmg_m1918_g_monitor",
			},
		},
	}
	self.skill_trees.m1918[2] = {}
	self.skill_trees.m1918[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_lmg_m1918_carry_handle",
			},
		},
	}
	self.skill_trees.m1918[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1918[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_lmg_m1918_bipod",
			},
		},
	}
	self.skill_trees.m1918[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_lmg_m1918_m_extended",
			},
		},
	}
	self.skill_trees.m1918.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_bren_skill_tree()
	self.skill_trees.bren = {}
	self.skill_trees.bren[1] = {}
	self.skill_trees.bren[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_lmg_bren_bipod",
			},
		},
	}
	self.skill_trees.bren[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.bren[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_lmg_bren_b_long",
			},
		},
	}
	self.skill_trees.bren[2] = {}
	self.skill_trees.bren[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_lmg_bren_pad_buffered",
			},
		},
	}
	self.skill_trees.bren[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			weapon_parts = {
				"wpn_fps_lmg_bren_ns_brake",
			},
		},
	}
	self.skill_trees.bren[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_lmg_bren_support",
			},
		},
	}
	self.skill_trees.bren[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_lmg_bren_m_extended",
			},
		},
	}
	self.skill_trees.bren.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_mg42_skill_tree()
	self.skill_trees.mg42 = {}
	self.skill_trees.mg42[1] = {}
	self.skill_trees.mg42[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.mg42[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 65,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_lmg_mg42_b_mg34",
				"wpn_fps_lmg_mg42_n34",
			},
		},
	}
	self.skill_trees.mg42[2] = {}
	self.skill_trees.mg42[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_lmg_mg42_dh_mg34",
			},
		},
	}
	self.skill_trees.mg42[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.mg42[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.mg42[3] = {}
	self.skill_trees.mg42[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 3,
			value = 3,
			challenge_tasks = {
				{
					target = 425,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_lmg_mg42_bipod",
			},
		},
	}
	self.skill_trees.mg42[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 115,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						40,
						70,
						100,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.mg42[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
						800,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.mg42[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 6,
			value = 5,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_lmg_mg42_m_double",
				"wpn_fps_lmg_mg42_lid_mg34",
			},
		},
	}
	self.skill_trees.mg42.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_mp44_skill_tree()
	self.skill_trees.mp44 = {}
	self.skill_trees.mp44[1] = {}
	self.skill_trees.mp44[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.mp44[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 2,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						150,
						350,
						450,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_ass_mp44_m_short_double",
			},
		},
	}
	self.skill_trees.mp44[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.mp44[2] = {}
	self.skill_trees.mp44[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.mp44[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 4,
			value = 4,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						200,
						400,
						600,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_ass_mp44_m_standard_double",
			},
		},
	}
	self.skill_trees.mp44[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.mp44[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 85,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						40,
						60,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.mp44.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_m1912_skill_tree()
	self.skill_trees.m1912 = {}
	self.skill_trees.m1912[1] = {}
	self.skill_trees.m1912[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 350,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						80,
						160,
						220,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_sho_m1912_s_cheek_rest",
			},
		},
	}
	self.skill_trees.m1912[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 5,
			challenge_tasks = {
				{
					target = 75,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						25,
						40,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_sho_m1912_fg_long",
			},
		},
	}
	self.skill_trees.m1912[2] = {}
	self.skill_trees.m1912[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 455,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						250,
						330,
						400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_sho_m1912_ns_cutts",
			},
		},
	}
	self.skill_trees.m1912[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 6,
			challenge_tasks = {
				{
					target = 100,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						40,
						70,
						90,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_sho_m1912_b_long",
			},
		},
	}
	self.skill_trees.m1912[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1912[3] = {}
	self.skill_trees.m1912[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 3,
			value = 3,
			challenge_tasks = {
				{
					target = 595,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_sho_m1912_s_pad",
			},
		},
	}
	self.skill_trees.m1912[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 4,
			value = 7,
			challenge_tasks = {
				{
					target = 130,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						80,
						110,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_sho_m1912_b_short",
			},
		},
	}
	self.skill_trees.m1912[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
						800,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1912[4] = {}
	self.skill_trees.m1912[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			cost = 3,
			value = 4,
			challenge_tasks = {
				{
					target = 15,
					modifiers = {
						headshot = true,
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						3,
						7,
						11,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_sho_m1912_s_pistol_grip",
			},
		},
	}
	self.skill_trees.m1912[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_ss_briefing",
			challenge_done_text_id = "weapon_skill_headshot_ss_completed",
			cost = 4,
			value = 8,
			challenge_tasks = {
				{
					target = 10,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						3,
						9,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			weapon_parts = {
				"wpn_fps_sho_m1912_b_heat_shield",
			},
		},
	}
	self.skill_trees.m1912[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			cost = 4,
			value = 4,
			challenge_tasks = {
				{
					target = 15,
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.m1912.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"demolitions_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_shotty_skill_tree()
	self.skill_trees.shotty = {}
	self.skill_trees.shotty[1] = {}
	self.skill_trees.shotty[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 250,
					reminders = {
						60,
						125,
						185,
						225,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.shotty[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 25,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						10,
						20,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.shotty[2] = {}
	self.skill_trees.shotty[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					reminders = {
						70,
						120,
						200,
						290,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.shotty[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 35,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						10,
						20,
						30,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
		},
	}
	self.skill_trees.shotty[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 165,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						30,
						60,
						90,
						130,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.shotty.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_carbine_skill_tree()
	self.skill_trees.carbine = {}
	self.skill_trees.carbine[1] = {}
	self.skill_trees.carbine[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						125,
						250,
						375,
						450,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.carbine[2] = {}
	self.skill_trees.carbine[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 650,
					reminders = {
						150,
						350,
						450,
						600,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.carbine[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 325,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			weapon_parts = {
				"wpn_fps_ass_carbine_body_wooden",
			},
		},
	}
	self.skill_trees.carbine[3] = {}
	self.skill_trees.carbine[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						400,
						600,
						800,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.carbine[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 3,
			challenge_tasks = {
				{
					target = 425,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
		},
	}
	self.skill_trees.carbine[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 845,
					reminders = {
						200,
						450,
						650,
					},
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			weapon_parts = {
				"wpn_fps_ass_carbine_m_extended",
			},
		},
	}
	self.skill_trees.carbine.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_reedem_xp_values()
	self.weapon_point_reedemed_xp = 50
end
