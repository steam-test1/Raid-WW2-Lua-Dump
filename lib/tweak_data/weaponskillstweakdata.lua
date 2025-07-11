WeaponSkillsTweakData = WeaponSkillsTweakData or class()
WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE = "increase_damage"
WeaponSkillsTweakData.SKILL_DECREASE_RECOIL = "decrease_recoil"
WeaponSkillsTweakData.SKILL_FASTER_RELOAD = "faster_reload"
WeaponSkillsTweakData.SKILL_FASTER_ADS = "faster_ads"
WeaponSkillsTweakData.SKILL_FASTER_ROF = "faster_rof"
WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD = "tighter_spread"
WeaponSkillsTweakData.SKILL_WIDER_SPREAD = "wider_spread"
WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE = "increase_magazine"
WeaponSkillsTweakData.MAX_SKILLS_IN_TIER = 4
WeaponSkillsTweakData.MAX_TIERS = 4

function WeaponSkillsTweakData:init(tweak_data)
	self.skills = {}
	self.skill_trees = {}

	self:_init_skills()
	self:_init_m1911_skill_tree(tweak_data)
	self:_init_c96_skill_tree(tweak_data)
	self:_init_thompson_skill_tree(tweak_data)
	self:_init_mp38_skill_tree(tweak_data)
	self:_init_sterling_skill_tree(tweak_data)
	self:_init_sten_skill_tree(tweak_data)
	self:_init_m1903_skill_tree(tweak_data)
	self:_init_mosin_skill_tree(tweak_data)
	self:_init_garand_skill_tree(tweak_data)
	self:_init_garand_golden_skill_tree(tweak_data)
	self:_init_m1918_skill_tree(tweak_data)
	self:_init_mg42_skill_tree(tweak_data)
	self:_init_mp44_skill_tree(tweak_data)
	self:_init_m1912_skill_tree(tweak_data)
	self:_init_carbine_skill_tree(tweak_data)
	self:_init_webley_skill_tree(tweak_data)
	self:_init_geco_skill_tree(tweak_data)
	self:_init_dp28_skill_tree(tweak_data)
	self:_init_tt33_skill_tree(tweak_data)
	self:_init_ithaca_skill_tree(tweak_data)
	self:_init_kar_98k_skill_tree(tweak_data)
	self:_init_bren_skill_tree(tweak_data)
	self:_init_lee_enfield_skill_tree(tweak_data)
	self:_init_browning_skill_tree(tweak_data)
	self:_init_welrod_skill_tree(tweak_data)
	self:_init_shotty_skill_tree(tweak_data)
	self:_init_georg_skill_tree(tweak_data)
	self:_init_reedem_xp_values()
end

function WeaponSkillsTweakData:_init_skills()
	self.skills[WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE] = {
		desc_id = "weapon_skill_increase_damage_desc",
		icon = "wpn_skill_damage",
		name_id = "weapon_skill_increase_damage_name",
	}
	self.skills[WeaponSkillsTweakData.SKILL_FASTER_ROF] = {
		desc_id = "weapon_skill_increase_firerate_desc",
		icon = "wpn_skill_damage",
		name_id = "weapon_skill_increase_firerate_name",
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
	self.skills[WeaponSkillsTweakData.SKILL_WIDER_SPREAD] = {
		desc_id = "weapon_skill_wider_spread_desc",
		icon = "wpn_skill_spread",
		name_id = "weapon_skill_wider_spread_name",
	}
	self.skills[WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE] = {
		desc_id = "weapon_skill_increase_magazine_desc",
		icon = "wpn_skill_mag_size",
		name_id = "weapon_skill_increase_magazine_name",
	}
end

function WeaponSkillsTweakData:_init_m1911_skill_tree(tweak_data)
	self.skill_trees.m1911 = {}
	self.skill_trees.m1911[1] = {}
	self.skill_trees.m1911[1][4] = {
		{
			challenge_tasks = {
				tweak_data.challenge.tighter_spread_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
			weapon_parts = {
				"wpn_fps_pis_m1911_ns_cutts",
			},
		},
	}
	self.skill_trees.m1911[1][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.increase_magazine_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
			weapon_parts = {
				"wpn_fps_pis_m1911_m_extended",
			},
		},
	}
	self.skill_trees.m1911[1][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.kill_enemies_hipfire_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.m1911[1][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.kill_enemies_basic_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.m1911[2] = {}
	self.skill_trees.m1911[2][4] = {
		{
			challenge_tasks = {
				tweak_data.challenge.tighter_spread_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_m1911_fg_tommy",
			},
		},
	}
	self.skill_trees.m1911[2][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.increase_magazine_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_m1911_m_banana",
			},
		},
	}
	self.skill_trees.m1911[2][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.kill_enemies_hipfire_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_m1911_s_wooden",
			},
		},
	}
	self.skill_trees.m1911[2][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.kill_enemies_basic_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.m1911[3] = {}
	self.skill_trees.m1911[3][4] = {
		{
			challenge_tasks = {
				tweak_data.challenge.tighter_spread_hard,
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 3,
		},
	}
	self.skill_trees.m1911[3][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.increase_magazine_hard,
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 3,
		},
	}
	self.skill_trees.m1911[3][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.kill_enemies_hipfire_hard,
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
		},
	}
	self.skill_trees.m1911[3][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.kill_enemies_basic_hard,
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.m1911.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_c96_skill_tree(tweak_data)
	self.skill_trees.c96 = {}
	self.skill_trees.c96[1] = {}
	self.skill_trees.c96[1][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.c96_kill_enemies_basic_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
			weapon_parts = {
				"wpn_fps_pis_c96_b_long",
			},
		},
	}
	self.skill_trees.c96[1][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.c96_kill_enemies_hipfire_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.c96[1][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.c96_increase_magazine_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
			weapon_parts = {
				"wpn_fps_pis_c96_m_extended",
			},
		},
	}
	self.skill_trees.c96[2] = {}
	self.skill_trees.c96[2][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.c96_kill_enemies_basic_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_c96_b_long_finned",
			},
		},
	}
	self.skill_trees.c96[2][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.c96_kill_enemies_hipfire_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_c96_s_wooden",
			},
		},
	}
	self.skill_trees.c96[2][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.c96_increase_magazine_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_c96_m_long",
			},
		},
	}
	self.skill_trees.c96[2][4] = {
		{
			challenge_tasks = {
				tweak_data.challenge.c96_tighter_spread_medium,
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
		},
	}
	self.skill_trees.c96.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_webley_skill_tree(tweak_data)
	self.skill_trees.webley = {}
	self.skill_trees.webley[1] = {}
	self.skill_trees.webley[1][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.webley_kill_enemies_basic_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.webley[1][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.webley_kill_enemies_headshot_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
		},
	}
	self.skill_trees.webley[2] = {}
	self.skill_trees.webley[2][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.webley_kill_enemies_basic_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.webley[2][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.webley_kill_enemies_headshot_medium,
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
		},
	}
	self.skill_trees.webley[2][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.webley_kill_enemies_hipfire_hard,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
		},
	}
	self.skill_trees.webley.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_geco_skill_tree(tweak_data)
	self.skill_trees.geco = {}
	self.skill_trees.geco[1] = {}
	self.skill_trees.geco[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 75,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 5,
		},
	}
	self.skill_trees.geco[2] = {}
	self.skill_trees.geco[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						40,
						70,
						90,
					},
					target = 100,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 6,
			weapon_parts = {
				"wpn_fps_sho_geco_b_short",
			},
		},
	}
	self.skill_trees.geco[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.geco[3] = {}
	self.skill_trees.geco[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						50,
						80,
						110,
					},
					target = 130,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 7,
		},
	}
	self.skill_trees.geco[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
						800,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.geco[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					target = 595,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
			weapon_parts = {
				"wpn_fps_sho_geco_s_cheek_rest",
			},
		},
	}
	self.skill_trees.geco[4] = {}
	self.skill_trees.geco[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_within_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_within_range_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						max_range = 500,
					},
					reminders = {
						10,
						25,
					},
					target = 40,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 8,
		},
	}
	self.skill_trees.geco[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			challenge_tasks = {
				{
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						10,
						20,
					},
					target = 30,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 4,
		},
	}
	self.skill_trees.geco[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
					},
					target = 400,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 4,
		},
	}
	self.skill_trees.geco.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"demolitions_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_dp28_skill_tree(tweak_data)
	self.skill_trees.dp28 = {}
	self.skill_trees.dp28[1] = {}
	self.skill_trees.dp28[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_lmg_dp28_s_light",
			},
		},
	}
	self.skill_trees.dp28[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.dp28[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
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
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_lmg_dp28_g_standard",
			},
		},
	}
	self.skill_trees.dp28[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.dp28[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_lmg_dp28_bipod",
			},
		},
	}
	self.skill_trees.dp28[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 4,
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

function WeaponSkillsTweakData:_init_tt33_skill_tree(tweak_data)
	self.skill_trees.tt33 = {}
	self.skill_trees.tt33[1] = {}
	self.skill_trees.tt33[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						60,
						125,
						185,
						225,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.tt33[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						10,
						20,
					},
					target = 25,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
		},
	}
	self.skill_trees.tt33[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						70,
						130,
					},
					target = 175,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
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
			challenge_tasks = {
				{
					reminders = {
						70,
						130,
						200,
						270,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.tt33[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						10,
						20,
						30,
					},
					target = 35,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_tt33_g_wooden",
			},
		},
	}
	self.skill_trees.tt33[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						90,
						180,
					},
					target = 230,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_tt33_m_long",
			},
		},
	}
	self.skill_trees.tt33[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						30,
						60,
						90,
						130,
					},
					target = 165,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
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

function WeaponSkillsTweakData:_init_georg_skill_tree(tweak_data)
	self.skill_trees.georg = {}
	self.skill_trees.georg[1] = {}
	self.skill_trees.georg[1][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.georg_kill_enemies_basic_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.georg[1][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.georg_kill_enemies_headshot_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
		},
	}
	self.skill_trees.georg[1][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.georg_kill_enemies_hipfire_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.georg[2] = {}
	self.skill_trees.georg[2][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.georg_kill_enemies_basic_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.georg[2][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.georg_kill_enemies_headshot_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_georg_barrel_long",
			},
		},
	}
	self.skill_trees.georg[2][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.georg_kill_enemies_hipfire_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_pis_georg_stock_wooden",
			},
		},
	}
	self.skill_trees.georg[2][4] = {
		{
			challenge_tasks = {
				tweak_data.challenge.georg_increase_magazine_hard,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 6,
		},
	}
	self.skill_trees.georg.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_thompson_skill_tree(tweak_data)
	self.skill_trees.thompson = {}
	self.skill_trees.thompson[1] = {}
	self.skill_trees.thompson[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.thompson[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.thompson[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						450,
						900,
					},
					target = 500,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
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
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.thompson[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
		},
	}
	self.skill_trees.thompson[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 2,
			weapon_parts = {
				"wpn_fps_smg_thompson_m_standard",
			},
		},
	}
	self.skill_trees.thompson[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
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
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
						800,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.thompson[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					target = 425,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
			weapon_parts = {
				"wpn_fps_smg_thompson_ns_cutts",
			},
		},
	}
	self.skill_trees.thompson[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 845,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 4,
			weapon_parts = {
				"wpn_fps_smg_thompson_m_standard_double",
			},
		},
	}
	self.skill_trees.thompson[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						40,
						70,
						100,
					},
					target = 115,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 3,
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
			challenge_tasks = {
				{
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					target = 15,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 4,
		},
	}
	self.skill_trees.thompson[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
						hip_fire = true,
					},
					reminders = {
						3,
						7,
						11,
					},
					target = 15,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 4,
			weapon_parts = {
				"wpn_fps_smg_thompson_b_m1928",
			},
		},
	}
	self.skill_trees.thompson[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_steelsight_kill_briefing",
			challenge_done_text_id = "weapon_skill_steelsight_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						steelsight = true,
					},
					reminders = {
						15,
						25,
						40,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 5,
			weapon_parts = {
				"wpn_fps_smg_thompson_m_drum",
			},
		},
	}
	self.skill_trees.thompson[4][4] = {
		{
			challenge_briefing_id = "weapon_skill_kill_specials_briefing",
			challenge_done_text_id = "weapon_skill_kill_specials_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
							CharacterTweakData.SPECIAL_UNIT_TYPE_SNIPER,
							CharacterTweakData.SPECIAL_UNIT_TYPE_SPOTTER,
						},
					},
					reminders = {
						10,
						25,
					},
					target = 35,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 4,
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
		"infiltrator_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_mp38_skill_tree(tweak_data)
	self.skill_trees.mp38 = {}
	self.skill_trees.mp38[1] = {}
	self.skill_trees.mp38[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.mp38[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_smg_mp38_dh_curved",
			},
		},
	}
	self.skill_trees.mp38[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
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
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.mp38[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_smg_mp38_s_wooden",
			},
		},
	}
	self.skill_trees.mp38[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_smg_mp38_b_fluted",
			},
		},
	}
	self.skill_trees.mp38[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 4,
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

function WeaponSkillsTweakData:_init_sterling_skill_tree(tweak_data)
	self.skill_trees.sterling = {}
	self.skill_trees.sterling[1] = {}
	self.skill_trees.sterling[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
		},
	}
	self.skill_trees.sterling[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
					},
					target = 500,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
			weapon_parts = {
				"wpn_fps_smg_sterling_m_long",
			},
		},
	}
	self.skill_trees.sterling[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.sterling[2] = {}
	self.skill_trees.sterling[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_smg_sterling_b_long",
			},
		},
	}
	self.skill_trees.sterling[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 5,
			weapon_parts = {
				"wpn_fps_smg_sterling_m_long_double",
			},
		},
	}
	self.skill_trees.sterling[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
		},
	}
	self.skill_trees.sterling[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.sterling.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_sten_skill_tree(tweak_data)
	self.skill_trees.sten = {}
	self.skill_trees.sten[1] = {}
	self.skill_trees.sten[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_smg_sten_s_wooden",
			},
		},
	}
	self.skill_trees.sten[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.sten[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
			weapon_parts = {
				"wpn_fps_smg_sten_body_mk3",
			},
		},
	}
	self.skill_trees.sten[1][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
					},
					target = 500,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
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
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_smg_sten_ns_slanted",
			},
		},
	}
	self.skill_trees.sten[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.sten[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_smg_sten_fg_wooden",
			},
		},
	}
	self.skill_trees.sten[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 2,
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
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					target = 425,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
			weapon_parts = {
				"wpn_fps_smg_sten_g_wooden",
			},
		},
	}
	self.skill_trees.sten[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
						800,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.sten[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						40,
						70,
						100,
					},
					target = 115,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 3,
			weapon_parts = {
				"wpn_fps_smg_sten_o_lee_enfield",
			},
		},
	}
	self.skill_trees.sten[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 845,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 3,
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
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
						hip_fire = true,
					},
					reminders = {
						3,
						7,
						11,
					},
					target = 15,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 4,
		},
	}
	self.skill_trees.sten[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			challenge_tasks = {
				{
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					target = 15,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 4,
		},
	}
	self.skill_trees.sten[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_kill_specials_briefing",
			challenge_done_text_id = "weapon_skill_kill_specials_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
							CharacterTweakData.SPECIAL_UNIT_TYPE_SNIPER,
							CharacterTweakData.SPECIAL_UNIT_TYPE_SPOTTER,
						},
					},
					reminders = {
						10,
						25,
					},
					target = 30,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 4,
			weapon_parts = {
				"wpn_fps_smg_sten_body_mk3_vented",
			},
		},
	}
	self.skill_trees.sten[4][4] = {
		{
			challenge_briefing_id = "weapon_skill_steelsight_kill_briefing",
			challenge_done_text_id = "weapon_skill_steelsight_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						steelsight = true,
					},
					reminders = {
						15,
						25,
						40,
					},
					target = 45,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 4,
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

function WeaponSkillsTweakData:_init_m1903_skill_tree(tweak_data)
	self.skill_trees.m1903 = {}
	self.skill_trees.m1903[1] = {}
	self.skill_trees.m1903[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
					},
					target = 175,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_m1903_body_type_c",
			},
		},
	}
	self.skill_trees.m1903[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_m1903_o_scope",
			},
		},
	}
	self.skill_trees.m1903[2] = {}
	self.skill_trees.m1903[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					target = 230,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_m1903_s_cheek_rest",
			},
		},
	}
	self.skill_trees.m1903[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						15,
						35,
						50,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_m1903_ns_mclean",
			},
		},
	}
	self.skill_trees.m1903[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.m1903[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						250,
						400,
					},
					target = 550,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
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

function WeaponSkillsTweakData:_init_kar_98k_skill_tree(tweak_data)
	self.skill_trees.kar_98k = {}
	self.skill_trees.kar_98k[1] = {}
	self.skill_trees.kar_98k[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
					},
					target = 175,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_body_grip",
			},
		},
	}
	self.skill_trees.kar_98k[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_o_scope",
			},
		},
	}
	self.skill_trees.kar_98k[2] = {}
	self.skill_trees.kar_98k[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					target = 230,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_pad_big",
			},
		},
	}
	self.skill_trees.kar_98k[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						15,
						35,
						50,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_b_long",
			},
		},
	}
	self.skill_trees.kar_98k[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						250,
						400,
					},
					target = 550,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_kar_98k_m_extended",
			},
		},
	}
	self.skill_trees.kar_98k[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.kar_98k.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_lee_enfield_skill_tree(tweak_data)
	self.skill_trees.lee_enfield = {}
	self.skill_trees.lee_enfield[1] = {}
	self.skill_trees.lee_enfield[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
					},
					target = 175,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_cheek_rest",
			},
		},
	}
	self.skill_trees.lee_enfield[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_o_scope",
			},
		},
	}
	self.skill_trees.lee_enfield[2] = {}
	self.skill_trees.lee_enfield[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					target = 230,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_pad_buffered",
			},
		},
	}
	self.skill_trees.lee_enfield[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						15,
						35,
						50,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_b_long",
			},
		},
	}
	self.skill_trees.lee_enfield[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						250,
						400,
					},
					target = 550,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_m_extended",
			},
		},
	}
	self.skill_trees.lee_enfield[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_lee_enfield_ns_coned",
			},
		},
	}
	self.skill_trees.lee_enfield.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_mosin_skill_tree(tweak_data)
	self.skill_trees.mosin = {}
	self.skill_trees.mosin[1] = {}
	self.skill_trees.mosin[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
					},
					target = 175,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_mosin_body_grip",
			},
		},
	}
	self.skill_trees.mosin[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
			weapon_parts = {
				"wpn_fps_snp_mosin_o_scope",
			},
		},
	}
	self.skill_trees.mosin[2] = {}
	self.skill_trees.mosin[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					target = 230,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_mosin_body_target",
			},
		},
	}
	self.skill_trees.mosin[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						15,
						35,
						50,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_snp_mosin_b_long",
			},
		},
	}
	self.skill_trees.mosin[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.mosin.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_garand_skill_tree(tweak_data)
	self.skill_trees.garand = {}
	self.skill_trees.garand[1] = {}
	self.skill_trees.garand[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.garand[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
					},
					target = 175,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
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
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.garand[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
						200,
					},
					target = 230,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
		},
	}
	self.skill_trees.garand[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						15,
						35,
						50,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
		},
	}
	self.skill_trees.garand[3] = {}
	self.skill_trees.garand[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
						800,
					},
					target = 850,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.garand[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
						250,
					},
					target = 300,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
		},
	}
	self.skill_trees.garand[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 3,
			weapon_parts = {
				"wpn_fps_ass_garand_ns_conical",
			},
		},
	}
	self.skill_trees.garand[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						620,
					},
					target = 710,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
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
			challenge_tasks = {
				{
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					target = 15,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 4,
		},
	}
	self.skill_trees.garand[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshots_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_headshots_beyond_range_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
						min_range = 1000,
					},
					reminders = {
						100,
						200,
						300,
					},
					target = 385,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 4,
			weapon_parts = {
				"wpn_fps_ass_garand_b_tanker",
			},
		},
	}
	self.skill_trees.garand[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_kill_specials_briefing",
			challenge_done_text_id = "weapon_skill_kill_specials_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
							CharacterTweakData.SPECIAL_UNIT_TYPE_SNIPER,
							CharacterTweakData.SPECIAL_UNIT_TYPE_SPOTTER,
						},
					},
					reminders = {
						10,
						25,
					},
					target = 35,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 4,
			weapon_parts = {
				"wpn_fps_ass_garand_s_folding",
			},
		},
	}
	self.skill_trees.garand[4][4] = {
		{
			challenge_briefing_id = "weapon_skill_steelsight_kill_briefing",
			challenge_done_text_id = "weapon_skill_steelsight_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						steelsight = true,
					},
					reminders = {
						15,
						25,
						40,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 8,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 2,
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

function WeaponSkillsTweakData:_init_garand_golden_skill_tree(tweak_data)
	self.skill_trees.garand_golden = {}
	self.skill_trees.garand_golden[1] = {}
	self.skill_trees.garand_golden[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.garand_golden[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
					},
					target = 175,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
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
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.garand_golden[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						100,
						250,
						400,
						450,
					},
					target = 300,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
		},
	}
	self.skill_trees.garand_golden[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						15,
						35,
						50,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
		},
	}
	self.skill_trees.garand_golden[3] = {}
	self.skill_trees.garand_golden[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
						800,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.garand_golden[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_beyond_range_briefing",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						min_range = 1000,
					},
					reminders = {
						50,
						100,
						150,
						250,
					},
					target = 300,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
		},
	}
	self.skill_trees.garand_golden[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 3,
			weapon_parts = {
				"wpn_fps_ass_garand_golden_ns_conical",
			},
		},
	}
	self.skill_trees.garand_golden[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						620,
					},
					target = 710,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
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
			challenge_tasks = {
				{
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					target = 15,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 4,
		},
	}
	self.skill_trees.garand_golden[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshots_beyond_range_briefing",
			challenge_done_text_id = "weapon_skill_headshots_beyond_range_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
						min_range = 1000,
					},
					reminders = {
						100,
						200,
						300,
					},
					target = 385,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 4,
			weapon_parts = {
				"wpn_fps_ass_garand_golden_b_tanker",
			},
		},
	}
	self.skill_trees.garand_golden[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_kill_specials_briefing",
			challenge_done_text_id = "weapon_skill_kill_specials_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER,
							CharacterTweakData.SPECIAL_UNIT_TYPE_SNIPER,
							CharacterTweakData.SPECIAL_UNIT_TYPE_SPOTTER,
						},
					},
					reminders = {
						10,
						25,
					},
					target = 35,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 4,
			weapon_parts = {
				"wpn_fps_ass_garand_s_folding",
			},
		},
	}
	self.skill_trees.garand_golden[4][4] = {
		{
			challenge_briefing_id = "weapon_skill_steelsight_kill_briefing",
			challenge_done_text_id = "weapon_skill_steelsight_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						steelsight = true,
					},
					reminders = {
						15,
						25,
						40,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 8,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 2,
			weapon_parts = {
				"wpn_fps_ass_garand_m_bar_extended",
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

function WeaponSkillsTweakData:_init_m1918_skill_tree(tweak_data)
	self.skill_trees.m1918 = {}
	self.skill_trees.m1918[1] = {}
	self.skill_trees.m1918[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_lmg_m1918_ns_cutts",
			},
		},
	}
	self.skill_trees.m1918[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.m1918[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
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
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_lmg_m1918_carry_handle",
			},
		},
	}
	self.skill_trees.m1918[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.m1918[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_lmg_m1918_bipod",
			},
		},
	}
	self.skill_trees.m1918[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 4,
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

function WeaponSkillsTweakData:_init_bren_skill_tree(tweak_data)
	self.skill_trees.bren = {}
	self.skill_trees.bren[1] = {}
	self.skill_trees.bren[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_lmg_bren_bipod",
			},
		},
	}
	self.skill_trees.bren[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.bren[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
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
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_lmg_bren_pad_buffered",
			},
		},
	}
	self.skill_trees.bren[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
			weapon_parts = {
				"wpn_fps_lmg_bren_ns_brake",
			},
		},
	}
	self.skill_trees.bren[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_lmg_bren_support",
			},
		},
	}
	self.skill_trees.bren[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 4,
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

function WeaponSkillsTweakData:_init_mg42_skill_tree(tweak_data)
	self.skill_trees.mg42 = {}
	self.skill_trees.mg42[1] = {}
	self.skill_trees.mg42[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.mg42[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 65,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
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
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_lmg_mg42_dh_mg34",
			},
		},
	}
	self.skill_trees.mg42[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
		},
	}
	self.skill_trees.mg42[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.mg42[3] = {}
	self.skill_trees.mg42[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					target = 425,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
			weapon_parts = {
				"wpn_fps_lmg_mg42_bipod",
			},
		},
	}
	self.skill_trees.mg42[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						40,
						70,
						100,
					},
					target = 115,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 3,
		},
	}
	self.skill_trees.mg42[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
						800,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.mg42[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 845,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 6,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 5,
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

function WeaponSkillsTweakData:_init_mp44_skill_tree(tweak_data)
	self.skill_trees.mp44 = {}
	self.skill_trees.mp44[1] = {}
	self.skill_trees.mp44[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.mp44[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 1,
			weapon_parts = {
				"wpn_fps_ass_mp44_m_short_double",
			},
		},
	}
	self.skill_trees.mp44[1][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.mp44[2] = {}
	self.skill_trees.mp44[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.mp44[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 4,
			weapon_parts = {
				"wpn_fps_ass_mp44_m_standard_double",
			},
		},
	}
	self.skill_trees.mp44[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
		},
	}
	self.skill_trees.mp44[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						20,
						40,
						60,
					},
					target = 85,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
			weapon_parts = {
				"wpn_fps_ass_mp44_o_scope",
			},
		},
	}
	self.skill_trees.mp44.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_m1912_skill_tree(tweak_data)
	self.skill_trees.m1912 = {}
	self.skill_trees.m1912[1] = {}
	self.skill_trees.m1912[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 350,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
			weapon_parts = {
				"wpn_fps_sho_m1912_s_cheek_rest",
			},
		},
	}
	self.skill_trees.m1912[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 75,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 5,
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
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						250,
						330,
						400,
					},
					target = 455,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_sho_m1912_ns_cutts",
			},
		},
	}
	self.skill_trees.m1912[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						40,
						70,
						90,
					},
					target = 100,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 6,
			weapon_parts = {
				"wpn_fps_sho_m1912_b_long",
			},
		},
	}
	self.skill_trees.m1912[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.m1912[3] = {}
	self.skill_trees.m1912[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					target = 595,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
			weapon_parts = {
				"wpn_fps_sho_m1912_s_pad",
			},
		},
	}
	self.skill_trees.m1912[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						50,
						80,
						110,
					},
					target = 130,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 7,
			weapon_parts = {
				"wpn_fps_sho_m1912_b_short",
			},
		},
	}
	self.skill_trees.m1912[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
						800,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.m1912[4] = {}
	self.skill_trees.m1912[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
					},
					target = 400,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 4,
			weapon_parts = {
				"wpn_fps_sho_m1912_s_pistol_grip",
			},
		},
	}
	self.skill_trees.m1912[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_within_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_within_range_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						max_range = 500,
					},
					reminders = {
						10,
						25,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 8,
			weapon_parts = {
				"wpn_fps_sho_m1912_b_heat_shield",
			},
		},
	}
	self.skill_trees.m1912[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			challenge_tasks = {
				{
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					target = 15,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 4,
		},
	}
	self.skill_trees.m1912.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"demolitions_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_ithaca_skill_tree(tweak_data)
	self.skill_trees.ithaca = {}
	self.skill_trees.ithaca[1] = {}
	self.skill_trees.ithaca[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 350,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.ithaca[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 75,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 5,
		},
	}
	self.skill_trees.ithaca[2] = {}
	self.skill_trees.ithaca[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						250,
						400,
						450,
					},
					target = 455,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_sho_ithaca_ns_brake",
			},
		},
	}
	self.skill_trees.ithaca[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						40,
						70,
						90,
					},
					target = 130,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 6,
		},
	}
	self.skill_trees.ithaca[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						100,
						250,
						400,
						575,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.ithaca[3] = {}
	self.skill_trees.ithaca[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					target = 595,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
			weapon_parts = {
				"wpn_fps_sho_ithaca_s_cheek_rest",
			},
		},
	}
	self.skill_trees.ithaca[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						50,
						100,
						130,
					},
					target = 150,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 7,
			weapon_parts = {
				"wpn_fps_sho_ithaca_b_reinforced",
			},
		},
	}
	self.skill_trees.ithaca[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						100,
						300,
						600,
						800,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.ithaca[4] = {}
	self.skill_trees.ithaca[4][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
					},
					target = 400,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 4,
			weapon_parts = {
				"wpn_fps_sho_ithaca_s_pistol_grip",
			},
		},
	}
	self.skill_trees.ithaca[4][2] = {
		{
			challenge_briefing_id = "weapon_skill_kill_within_range_briefing",
			challenge_done_text_id = "weapon_skill_kill_within_range_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						max_range = 500,
					},
					reminders = {
						10,
						25,
					},
					target = 50,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 8,
			weapon_parts = {
				"wpn_fps_sho_ithaca_b_heat_shield",
			},
		},
	}
	self.skill_trees.ithaca[4][3] = {
		{
			challenge_briefing_id = "weapon_skill_kill_flamers_briefing",
			challenge_done_text_id = "weapon_skill_kill_flamers_completed",
			challenge_tasks = {
				{
					modifiers = {
						enemy_type = {
							CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER,
						},
					},
					reminders = {
						5,
						10,
					},
					target = 15,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 4,
		},
	}
	self.skill_trees.ithaca.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"demolitions_tier_4_unlocked",
	}
end

function WeaponSkillsTweakData:_init_browning_skill_tree(tweak_data)
	self.skill_trees.browning = {}
	self.skill_trees.browning[1] = {}
	self.skill_trees.browning[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						80,
						160,
						220,
					},
					target = 350,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 1,
		},
	}
	self.skill_trees.browning[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						25,
						40,
					},
					target = 75,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 5,
		},
	}
	self.skill_trees.browning[2] = {}
	self.skill_trees.browning[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						250,
						300,
						400,
					},
					target = 455,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
			weapon_parts = {
				"wpn_fps_sho_browning_s_grip",
			},
		},
	}
	self.skill_trees.browning[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						40,
						70,
						90,
					},
					target = 100,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 6,
		},
	}
	self.skill_trees.browning[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						100,
						200,
						300,
						500,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.browning[2][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						100,
						200,
						350,
					},
					target = 455,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 6,
			weapon_parts = {
				"wpn_fps_sho_browning_m_extended",
			},
		},
	}
	self.skill_trees.browning[3] = {}
	self.skill_trees.browning[3][1] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						200,
						400,
						600,
						700,
					},
					target = 590,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
			weapon_parts = {
				"wpn_fps_sho_browning_pad_big",
			},
		},
	}
	self.skill_trees.browning[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						50,
						80,
						100,
					},
					target = 130,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 7,
			weapon_parts = {
				"wpn_fps_sho_browning_b_reinforced",
			},
		},
	}
	self.skill_trees.browning[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						100,
						250,
						500,
						750,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.browning[3][4] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						100,
						200,
						400,
					},
					target = 590,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 7,
			weapon_parts = {
				"wpn_fps_sho_browning_m_long",
			},
		},
	}
	self.skill_trees.browning.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_welrod_skill_tree(tweak_data)
	self.skill_trees.welrod = {}
	self.skill_trees.welrod[1] = {}
	self.skill_trees.welrod[1][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.welrod_kill_enemies_basic_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.welrod[1][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.welrod_kill_enemies_headshot_easy,
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 1,
		},
	}
	self.skill_trees.welrod[2] = {}
	self.skill_trees.welrod[2][1] = {
		{
			challenge_tasks = {
				tweak_data.challenge.welrod_kill_enemies_basic_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.welrod[2][2] = {
		{
			challenge_tasks = {
				tweak_data.challenge.welrod_kill_enemies_headshot_medium,
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 2,
		},
	}
	self.skill_trees.welrod[2][3] = {
		{
			challenge_tasks = {
				tweak_data.challenge.welrod_kill_enemies_hipfire_medium,
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
		},
	}
	self.skill_trees.welrod.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_shotty_skill_tree(tweak_data)
	self.skill_trees.shotty = {}
	self.skill_trees.shotty[1] = {}
	self.skill_trees.shotty[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						60,
						125,
						185,
						225,
					},
					target = 250,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
		},
	}
	self.skill_trees.shotty[1][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						10,
						20,
					},
					target = 25,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 5,
		},
	}
	self.skill_trees.shotty[2] = {}
	self.skill_trees.shotty[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						70,
						120,
						200,
						290,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
		},
	}
	self.skill_trees.shotty[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_headshot_kill_briefing",
			challenge_done_text_id = "weapon_skill_headshot_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						headshot = true,
					},
					reminders = {
						10,
						20,
						30,
					},
					target = 35,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 3,
			skill_name = WeaponSkillsTweakData.SKILL_TIGHTER_SPREAD,
			value = 6,
		},
	}
	self.skill_trees.shotty[2][3] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						30,
						60,
						90,
						130,
					},
					target = 165,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
		},
	}
	self.skill_trees.shotty.tier_unlock = {
		"weapon_tier_unlocked",
		"weapon_tier_unlocked",
	}
end

function WeaponSkillsTweakData:_init_carbine_skill_tree(tweak_data)
	self.skill_trees.carbine = {}
	self.skill_trees.carbine[1] = {}
	self.skill_trees.carbine[1][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						125,
						250,
						375,
						450,
					},
					target = 500,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 1,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 1,
			weapon_parts = {
				"wpn_fps_ass_carbine_b_medium",
			},
		},
	}
	self.skill_trees.carbine[2] = {}
	self.skill_trees.carbine[2][1] = {
		{
			challenge_briefing_id = "weapon_skill_generic_kill_briefing",
			challenge_done_text_id = "weapon_skill_generic_kill_completed",
			challenge_tasks = {
				{
					reminders = {
						150,
						350,
						450,
						600,
					},
					target = 650,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 2,
			weapon_parts = {
				"wpn_fps_ass_carbine_b_standard",
			},
		},
	}
	self.skill_trees.carbine[2][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						70,
						120,
						230,
						300,
					},
					target = 325,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 2,
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
			challenge_tasks = {
				{
					reminders = {
						200,
						400,
						600,
						800,
					},
					target = 845,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_DAMAGE,
			value = 3,
		},
	}
	self.skill_trees.carbine[3][2] = {
		{
			challenge_briefing_id = "weapon_skill_hip_fire_kill_briefing",
			challenge_done_text_id = "weapon_skill_hip_fire_kill_completed",
			challenge_tasks = {
				{
					modifiers = {
						damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET,
						hip_fire = true,
					},
					reminders = {
						100,
						200,
						300,
						400,
					},
					target = 425,
					type = ChallengeTweakData.TASK_KILL_ENEMIES,
				},
			},
			cost = 2,
			skill_name = WeaponSkillsTweakData.SKILL_DECREASE_RECOIL,
			value = 3,
		},
	}
	self.skill_trees.carbine[3][3] = {
		{
			challenge_briefing_id = "weapon_skill_collect_ammo_briefing",
			challenge_done_text_id = "weapon_skill_collect_ammo_completed",
			challenge_tasks = {
				{
					reminders = {
						200,
						450,
						650,
					},
					target = 845,
					type = ChallengeTweakData.TASK_COLLECT_AMMO,
				},
			},
			cost = 4,
			skill_name = WeaponSkillsTweakData.SKILL_INCREASE_MAGAZINE,
			value = 3,
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
