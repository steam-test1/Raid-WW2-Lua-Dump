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
	self:_init_c96_skill_tree()
	self:_init_thompson_skill_tree()
	self:_init_sten_skill_tree()
	self:_init_m1903_skill_tree()
	self:_init_garand_skill_tree()
	self:_init_m1918_skill_tree()
	self:_init_m1912_skill_tree()
	self:_init_carbine_skill_tree()
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
					target = 500,
					reminders = {
						250,
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
	self.skill_trees.m1911[1][1] = {
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
	self.skill_trees.m1911[2] = {}
	self.skill_trees.m1911[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 2,
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
					target = 1000,
					reminders = {
						400,
						800,
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
					target = 500,
					modifiers = {
						hip_fire = true,
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
					target = 1000,
					reminders = {
						250,
						500,
						750,
						900,
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
					target = 150,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						130,
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
					target = 1500,
					reminders = {
						500,
						1000,
						1300,
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
					target = 750,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						200,
						400,
						600,
						700,
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
			value = 7,
			challenge_tasks = {
				{
					target = 1500,
					reminders = {
						375,
						750,
						1125,
						1400,
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
	self.skill_trees.c96[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 1,
			value = 1,
			challenge_tasks = {
				{
					target = 500,
					reminders = {
						250,
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
			value = 3,
			challenge_tasks = {
				{
					target = 1000,
					reminders = {
						250,
						500,
						750,
						900,
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
					target = 500,
					modifiers = {
						hip_fire = true,
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
					target = 1000,
					reminders = {
						400,
						800,
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
			value = 1,
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
		},
	}
	self.skill_trees.c96.tier_unlock = {
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
					target = 1200,
					reminders = {
						400,
						1000,
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
					target = 1000,
					reminders = {
						250,
						500,
						750,
						900,
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
					target = 500,
					modifiers = {
						hip_fire = true,
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
	self.skill_trees.thompson[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 3,
			value = 2,
			challenge_tasks = {
				{
					target = 2400,
					reminders = {
						500,
						1000,
						2000,
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
			value = 1,
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
					target = 1500,
					reminders = {
						375,
						750,
						1125,
						1400,
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
					target = 750,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						200,
						400,
						600,
						700,
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
					target = 3600,
					reminders = {
						800,
						2000,
						3200,
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
			value = 2,
			challenge_tasks = {
				{
					target = 150,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						130,
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
	self.skill_trees.thompson[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 100,
					modifiers = {
						headshot = true,
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						50,
						80,
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
					target = 250,
					modifiers = {
						last_round_in_magazine = true,
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
			value = 3,
			challenge_tasks = {
				{
					target = 50,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						20,
						40,
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
					target = 1200,
					reminders = {
						400,
						1000,
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
					target = 500,
					modifiers = {
						hip_fire = true,
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
					target = 1000,
					reminders = {
						250,
						500,
						750,
						900,
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
					target = 2400,
					reminders = {
						500,
						1000,
						2000,
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
					target = 750,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						200,
						400,
						600,
						700,
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
					target = 1500,
					reminders = {
						375,
						750,
						1125,
						1400,
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
					target = 150,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						130,
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
					target = 3600,
					reminders = {
						800,
						2000,
						3200,
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
					target = 100,
					modifiers = {
						headshot = true,
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						50,
						80,
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
	self.skill_trees.sten[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_ss_briefing",
			challenge_done_text_id = "weapon_skill_headshot_ss_completed",
			cost = 1,
			value = 4,
			challenge_tasks = {
				{
					target = 50,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						20,
						40,
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
					target = 250,
					modifiers = {
						last_round_in_magazine = true,
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
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 500,
					modifiers = {
						hip_fire = true,
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
				"wpn_fps_snp_m1903_ns_mclean",
			},
		},
	}
	self.skill_trees.m1903[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			cost = 3,
			value = 1,
			challenge_tasks = {
				{
					target = 1000,
					reminders = {
						250,
						500,
						750,
						900,
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
					target = 500,
					reminders = {
						250,
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
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
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
					target = 1000,
					reminders = {
						250,
						500,
						750,
						900,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 2,
			value = 2,
			challenge_tasks = {
				{
					target = 500,
					modifiers = {
						hip_fire = true,
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
	self.skill_trees.garand[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			cost = 2,
			value = 1,
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
					target = 1500,
					reminders = {
						375,
						750,
						1125,
						1400,
					},
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
		},
	}
	self.skill_trees.garand[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			cost = 4,
			value = 3,
			challenge_tasks = {
				{
					target = 750,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						200,
						400,
						600,
						700,
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
			value = 2,
			challenge_tasks = {
				{
					target = 150,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						130,
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
					target = 1500,
					reminders = {
						500,
						1000,
						1300,
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
	self.skill_trees.garand[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			cost = 6,
			value = 4,
			challenge_tasks = {
				{
					target = 100,
					modifiers = {
						headshot = true,
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						50,
						80,
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
			value = 3,
			challenge_tasks = {
				{
					target = 50,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						20,
						40,
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
					target = 250,
					modifiers = {
						last_round_in_magazine = true,
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
					target = 500,
					modifiers = {
						hip_fire = true,
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
					target = 1000,
					reminders = {
						250,
						500,
						750,
						900,
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
					target = 2400,
					reminders = {
						500,
						1000,
						2000,
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
				"wpn_fps_sho_m1912_s_cheek_rest",
			},
		},
	}
	self.skill_trees.m1912[1][2] = {
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
					target = 500,
					modifiers = {
						hip_fire = true,
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
			value = 2,
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
			value = 1,
			challenge_tasks = {
				{
					target = 1000,
					reminders = {
						250,
						500,
						750,
						900,
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
					target = 750,
					modifiers = {
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						200,
						400,
						600,
						700,
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
			value = 3,
			challenge_tasks = {
				{
					target = 150,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						50,
						100,
						130,
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
			value = 2,
			challenge_tasks = {
				{
					target = 1500,
					reminders = {
						375,
						750,
						1125,
						1400,
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
					target = 100,
					modifiers = {
						headshot = true,
						hip_fire = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
					},
					reminders = {
						20,
						50,
						80,
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
			value = 4,
			challenge_tasks = {
				{
					target = 50,
					modifiers = {
						headshot = true,
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
						},
					},
					reminders = {
						20,
						40,
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
			value = 3,
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
	self.skill_trees.m1912.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"demolitions_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_carbine_skill_tree()
	self.skill_trees.carbine = {}
	self.skill_trees.carbine[1] = {}
	self.skill_trees.carbine[1][1] = {
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
				"wpn_fps_ass_carbine_body_wooden",
			},
		},
	}
	self.skill_trees.carbine[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			cost = 4,
			value = 4,
			challenge_tasks = {
				{
					target = 3750,
					reminders = {
						500,
						1500,
						3000,
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
	}
end

function WeaponSkillsTweakData:_init_reedem_xp_values()
	self.weapon_point_reedemed_xp = 50
end
