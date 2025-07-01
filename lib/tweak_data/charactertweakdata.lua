CharacterTweakData = CharacterTweakData or class()
CharacterTweakData.ENEMY_TYPE_SOLDIER = "soldier"
CharacterTweakData.ENEMY_TYPE_PARATROOPER = "paratrooper"
CharacterTweakData.ENEMY_TYPE_ELITE = "elite"
CharacterTweakData.ENEMY_TYPE_OFFICER = "officer"
CharacterTweakData.ENEMY_TYPE_FLAMER = "flamer"
CharacterTweakData.SPECIAL_UNIT_TYPES = {
	commander = true,
	flamer = true,
}
CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER = "flamer"
CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER = "commander"
CharacterTweakData.SPECIAL_UNIT_TYPE_SNIPER = "sniper"
CharacterTweakData.SPECIAL_UNIT_TYPE_SPOTTER = "spotter"

function CharacterTweakData:init(tweak_data)
	self:_create_table_structure()

	self._enemies_list = {}
	self.flashbang_multiplier = 1

	local presets = self:_presets(tweak_data)

	self.presets = presets

	self:_init_npc_loadouts(tweak_data)
	self:_init_dismemberment_data()
	self:_init_char_buff_gear()
	self:_init_german_commander(presets)
	self:_init_german_og_commander(presets)
	self:_init_german_officer(presets)
	self:_init_german_grunt_light(presets)
	self:_init_german_grunt_mid(presets)
	self:_init_german_grunt_heavy(presets)
	self:_init_german_light(presets)
	self:_init_german_heavy(presets)
	self:_init_german_gasmask(presets)
	self:_init_german_commander_backup(presets)
	self:_init_german_fallschirmjager_light(presets)
	self:_init_german_fallschirmjager_heavy(presets)
	self:_init_german_waffen_ss(presets)
	self:_init_german_gebirgsjager_light(presets)
	self:_init_german_gebirgsjager_heavy(presets)
	self:_init_german_flamer(presets)
	self:_init_german_sniper(presets)
	self:_init_german_spotter(presets)
	self:_init_soviet_nkvd_int_security_captain(presets)
	self:_init_soviet_nkvd_int_security_captain_b(presets)
	self:_init_british(presets)
	self:_init_russian(presets)
	self:_init_german(presets)
	self:_init_american(presets)
	self:_init_civilian(presets)
	self:_init_escort(presets)
	self:_init_upd_fb(presets)
end

function CharacterTweakData:set_difficulty(diff_index)
	Application:debug("[CharacterTweakData] Setting Difficulty Index: '" .. tostring(diff_index) .. "'!")

	if diff_index == 1 then
		self:_set_difficulty_1()
	elseif diff_index == 2 then
		self:_set_difficulty_2()
	elseif diff_index == 3 then
		self:_set_difficulty_3()
	elseif diff_index == 4 then
		self:_set_difficulty_4()
	end
end

function CharacterTweakData:_init_npc_loadouts(tweak_data)
	self.npc_loadouts = {}
	self.npc_loadouts.ger_handgun = {
		german_grunt_light_kar98 = nil,
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
	self.npc_loadouts.ger_rifle = {
		german_grunt_light_kar98 = nil,
		normal = nil,
		primary = Idstring("units/vanilla/weapons/wpn_npc_ger_k98/wpn_npc_ger_k98"),
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
	self.npc_loadouts.ger_assault_rifle = {
		german_grunt_light_kar98 = nil,
		normal = nil,
		primary = Idstring("units/vanilla/weapons/wpn_npc_ger_stg44/wpn_npc_ger_stg44"),
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
	self.npc_loadouts.ger_smg = {
		german_grunt_light_kar98 = nil,
		normal = nil,
		primary = Idstring("units/vanilla/weapons/wpn_npc_ger_mp38/wpn_npc_ger_mp38"),
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
	self.npc_loadouts.ger_shotgun = {
		german_grunt_light_kar98 = nil,
		normal = nil,
		primary = Idstring("units/vanilla/weapons/wpn_npc_ger_geco/wpn_npc_ger_geco"),
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
	self.npc_loadouts.unarmed = {
		german_grunt_light_kar98 = nil,
		normal = nil,
	}
	self.npc_loadouts.special_commander = {
		german_grunt_light_kar98 = nil,
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger_fancy"),
	}
	self.npc_loadouts.special_flamethrower = {
		german_grunt_light_kar98 = nil,
		primary = Idstring("units/vanilla/weapons/wpn_npc_spc_m42_flammenwerfer/wpn_npc_spc_m42_flammenwerfer"),
	}
	self.npc_loadouts.special_sniper = {
		german_grunt_light_kar98 = nil,
		primary = Idstring("units/vanilla/weapons/wpn_npc_ger_k98/wpn_npc_ger_k98_sniper"),
	}
	self.npc_loadouts.special_spotter = {
		german_grunt_light_kar98 = nil,
		primary = Idstring("units/vanilla/weapons/wpn_npc_binocular/wpn_npc_binocular"),
	}
end

function CharacterTweakData:_init_british(presets)
	self.british = {
		HEALTH_INIT = 400,
		access = "teamAI1",
		always_face_enemy = true,
		crouch_move = false,
		damage = presets.gang_member_damage,
		detection = presets.detection.gang_member,
		dodge = presets.dodge.athletic,
		flammable = false,
		move_speed = presets.move_speed.teamai,
		no_run_stop = true,
		speech_prefix = "brit",
		vision = presets.vision.easy,
		weapon = deep_clone(presets.weapon.gang_member),
	}
	self.british.loadout = {
		primary = Idstring("units/vanilla/weapons/wpn_npc_usa_garand/wpn_npc_usa_garand"),
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
end

function CharacterTweakData:_init_russian(presets)
	self.russian = clone(self.british)
	self.russian.speech_prefix = "russ"
	self.russian.access = "teamAI2"
	self.russian.loadout = {
		primary = Idstring("units/vanilla/weapons/wpn_npc_smg_thompson/wpn_npc_smg_thompson"),
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
end

function CharacterTweakData:_init_german(presets)
	self.german = clone(self.british)
	self.german.speech_prefix = "germ"
	self.german.access = "teamAI3"
	self.german.loadout = {
		primary = Idstring("units/vanilla/weapons/wpn_npc_smg_thompson/wpn_npc_smg_thompson"),
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
end

function CharacterTweakData:_init_american(presets)
	self.american = clone(self.british)
	self.american.speech_prefix = "amer"
	self.american.access = "teamAI4"
	self.american.loadout = {
		primary = Idstring("units/vanilla/weapons/wpn_npc_usa_garand/wpn_npc_usa_garand"),
		secondary = Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
	}
end

function CharacterTweakData:_init_civilian(presets)
	self.civilian = {
		experience = {},
	}
	self.civilian.detection = presets.detection.civilian
	self.civilian.HEALTH_INIT = 0.9
	self.civilian.headshot_dmg_mul = 1
	self.civilian.move_speed = presets.move_speed.civ_fast
	self.civilian.flee_type = "escape"
	self.civilian.scare_max = {
		10,
		20,
	}
	self.civilian.scare_shot = 1
	self.civilian.scare_intimidate = -5
	self.civilian.submission_max = {
		60,
		120,
	}
	self.civilian.submission_intimidate = 120
	self.civilian.run_away_delay = {
		5,
		20,
	}
	self.civilian.damage = presets.hurt_severities.no_hurts
	self.civilian.ecm_hurts = {}
	self.civilian.speech_prefix_p1 = "cm"
	self.civilian.speech_prefix_count = 2
	self.civilian.access = "civ_male"
	self.civilian.intimidateable = true
	self.civilian.challenges = {
		type = "civilians",
	}
	self.civilian.calls_in = true
	self.civilian.vision = presets.vision.civilian
	self.civilian_female = deep_clone(self.civilian)
	self.civilian_female.speech_prefix_p1 = "cf"
	self.civilian_female.speech_prefix_count = 5
	self.civilian_female.female = true
	self.civilian_female.access = "civ_female"
	self.civilian_female.vision = presets.vision.civilian
end

function CharacterTweakData:_init_dismemberment_data()
	self.dismemberment_data = {}

	local dismembers = {}

	dismembers[Idstring("head"):key()] = "dismember_head"
	dismembers[Idstring("body"):key()] = "dismember_body_top"
	dismembers[Idstring("hit_Head"):key()] = "dismember_head"
	dismembers[Idstring("hit_Body"):key()] = "dismember_body_top"
	dismembers[Idstring("hit_RightUpLeg"):key()] = "dismember_r_upper_leg"
	dismembers[Idstring("hit_LeftUpLeg"):key()] = "dismember_l_upper_leg"
	dismembers[Idstring("hit_RightArm"):key()] = "dismember_r_upper_arm"
	dismembers[Idstring("hit_LeftArm"):key()] = "dismember_l_upper_arm"
	dismembers[Idstring("hit_RightForeArm"):key()] = "dismember_r_lower_arm"
	dismembers[Idstring("hit_LeftForeArm"):key()] = "dismember_l_lower_arm"
	dismembers[Idstring("hit_RightLeg"):key()] = "dismember_r_lower_leg"
	dismembers[Idstring("hit_LeftLeg"):key()] = "dismember_l_lower_leg"
	dismembers[Idstring("rag_Head"):key()] = "dismember_head"
	dismembers[Idstring("rag_RightUpLeg"):key()] = "dismember_r_upper_leg"
	dismembers[Idstring("rag_LeftUpLeg"):key()] = "dismember_l_upper_leg"
	dismembers[Idstring("rag_RightArm"):key()] = "dismember_r_upper_arm"
	dismembers[Idstring("rag_LeftArm"):key()] = "dismember_l_upper_arm"
	dismembers[Idstring("rag_RightForeArm"):key()] = "dismember_r_lower_arm"
	dismembers[Idstring("rag_LeftForeArm"):key()] = "dismember_l_lower_arm"
	dismembers[Idstring("rag_RightLeg"):key()] = "dismember_r_lower_leg"
	dismembers[Idstring("rag_LeftLeg"):key()] = "dismember_l_lower_leg"
	self.dismemberment_data.dismembers = dismembers

	local blood_decal_data = {}

	blood_decal_data.dismember_head = {
		0,
		0.357,
		14,
	}
	blood_decal_data.dismember_body_top = {
		2,
		2,
		30,
	}
	blood_decal_data.dismember_r_upper_leg = {
		-0.098,
		-0.069,
		13.688,
	}
	blood_decal_data.dismember_l_upper_leg = {
		0.098,
		-0.069,
		13.688,
	}
	blood_decal_data.dismember_r_lower_leg = {
		-0.114,
		-0.358,
		25.55,
	}
	blood_decal_data.dismember_l_lower_leg = {
		0.114,
		-0.358,
		25.55,
	}
	blood_decal_data.dismember_r_upper_arm = {
		-0.19,
		0.311,
		14,
	}
	blood_decal_data.dismember_l_upper_arm = {
		0.19,
		0.311,
		14,
	}
	blood_decal_data.dismember_r_lower_arm = {
		-0.327,
		0.22,
		13.69,
	}
	blood_decal_data.dismember_l_lower_arm = {
		0.327,
		0.22,
		13.69,
	}
	self.dismemberment_data.blood_decal_data = blood_decal_data
end

function CharacterTweakData:_init_char_buff_gear()
	self.char_buff_gear = {
		pumkin_heads = {},
	}

	local pumpkin_heads = {
		items = {
			Head = {
				"units/upd_candy/characters/props/pumpkin_mask/pumpkin_mask",
			},
		},
		run_char_seqs = {
			"detach_hat_no_debris",
		},
	}

	self.char_buff_gear.pumkin_heads = {
		german_black_waffen_sentry_gasmask = pumpkin_heads,
		german_black_waffen_sentry_gasmask_commander = pumpkin_heads,
		german_black_waffen_sentry_gasmask_commander_shotgun = pumpkin_heads,
		german_black_waffen_sentry_gasmask_shotgun = pumpkin_heads,
		german_black_waffen_sentry_heavy = pumpkin_heads,
		german_black_waffen_sentry_heavy_commander = pumpkin_heads,
		german_black_waffen_sentry_heavy_commander_kar98 = pumpkin_heads,
		german_black_waffen_sentry_heavy_commander_shotgun = pumpkin_heads,
		german_black_waffen_sentry_heavy_kar98 = pumpkin_heads,
		german_black_waffen_sentry_heavy_shotgun = pumpkin_heads,
		german_black_waffen_sentry_light = pumpkin_heads,
		german_black_waffen_sentry_light_kar98 = pumpkin_heads,
		german_black_waffen_sentry_light_shotgun = pumpkin_heads,
		german_fallschirmjager_heavy = pumpkin_heads,
		german_fallschirmjager_heavy_kar98 = pumpkin_heads,
		german_fallschirmjager_heavy_mp38 = pumpkin_heads,
		german_fallschirmjager_heavy_shotgun = pumpkin_heads,
		german_fallschirmjager_light = pumpkin_heads,
		german_fallschirmjager_light_kar98 = pumpkin_heads,
		german_fallschirmjager_light_mp38 = pumpkin_heads,
		german_fallschirmjager_light_shotgun = pumpkin_heads,
		german_gasmask = pumpkin_heads,
		german_gasmask_commander_backup = pumpkin_heads,
		german_gasmask_commander_backup_shotgun = pumpkin_heads,
		german_gasmask_shotgun = pumpkin_heads,
		german_gebirgsjager_heavy = pumpkin_heads,
		german_gebirgsjager_heavy_kar98 = pumpkin_heads,
		german_gebirgsjager_heavy_mp38 = pumpkin_heads,
		german_gebirgsjager_heavy_shotgun = pumpkin_heads,
		german_gebirgsjager_light = pumpkin_heads,
		german_gebirgsjager_light_kar98 = pumpkin_heads,
		german_gebirgsjager_light_mp38 = pumpkin_heads,
		german_gebirgsjager_light_shotgun = pumpkin_heads,
		german_grunt_heavy = pumpkin_heads,
		german_grunt_heavy_kar98 = pumpkin_heads,
		german_grunt_heavy_mp38 = pumpkin_heads,
		german_grunt_heavy_shotgun = pumpkin_heads,
		german_grunt_light = pumpkin_heads,
		german_grunt_light_kar98 = pumpkin_heads,
		german_grunt_light_mp38 = pumpkin_heads,
		german_grunt_light_shotgun = pumpkin_heads,
		german_grunt_mid = pumpkin_heads,
		german_grunt_mid_kar98 = pumpkin_heads,
		german_grunt_mid_mp38 = pumpkin_heads,
		german_grunt_mid_shotgun = pumpkin_heads,
		german_heavy = pumpkin_heads,
		german_heavy_commander_backup = pumpkin_heads,
		german_heavy_commander_backup_kar98 = pumpkin_heads,
		german_heavy_commander_backup_shotgun = pumpkin_heads,
		german_heavy_kar98 = pumpkin_heads,
		german_heavy_mp38 = pumpkin_heads,
		german_heavy_shotgun = pumpkin_heads,
		german_light = pumpkin_heads,
		german_light_commander_backup = pumpkin_heads,
		german_light_commander_backup_kar98 = pumpkin_heads,
		german_light_commander_backup_shotgun = pumpkin_heads,
		german_light_kar98 = pumpkin_heads,
		german_light_shotgun = pumpkin_heads,
		german_waffen_ss = pumpkin_heads,
		german_waffen_ss_kar98 = pumpkin_heads,
		german_waffen_ss_shotgun = pumpkin_heads,
	}
	self.char_buff_gear.pumkin_heads.german_commander = {
		items = {
			Head = {
				"units/upd_candy/characters/props/pumpkin_mask/pumpkin_mask_commander_1",
			},
		},
		run_char_seqs = {
			"detach_hat_no_debris",
		},
	}
	self.char_buff_gear.pumkin_heads.german_officer = {
		items = {
			Head = {
				"units/upd_candy/characters/props/pumpkin_mask/pumpkin_mask_commander_1",
			},
		},
		run_char_seqs = {
			"detach_hat_no_debris",
		},
	}
	self.char_buff_gear.pumkin_heads.german_og_commander = {
		items = {
			Head = {
				"units/upd_candy/characters/props/pumpkin_mask/pumpkin_mask_commander_2",
			},
		},
		run_char_seqs = {
			"detach_hat_no_debris",
		},
	}
	self.char_buff_gear.pumkin_heads.german_flamer = {
		items = {
			Head = {
				"units/upd_candy/characters/props/pumpkin_mask/pumpkin_mask_flamer",
			},
		},
		run_char_seqs = {},
	}
end

function CharacterTweakData:_init_german_grunt_light(presets)
	self.german_grunt_light = deep_clone(presets.base)
	self.german_grunt_light.experience = {}
	self.german_grunt_light.weapon = presets.weapon.normal
	self.german_grunt_light.detection = presets.detection.normal
	self.german_grunt_light.vision = presets.vision.easy
	self.german_grunt_light.HEALTH_INIT = 80
	self.german_grunt_light.BASE_HEALTH_INIT = 80
	self.german_grunt_light.headshot_dmg_mul = 1
	self.german_grunt_light.move_speed = presets.move_speed.fast
	self.german_grunt_light.suppression = presets.suppression.easy
	self.german_grunt_light.ecm_vulnerability = 1
	self.german_grunt_light.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_grunt_light.speech_prefix_p1 = "ger"
	self.german_grunt_light.speech_prefix_p2 = "soldier"
	self.german_grunt_light.speech_prefix_count = 4
	self.german_grunt_light.access = "swat"
	self.german_grunt_light.silent_priority_shout = "shout_loud_soldier"
	self.german_grunt_light.dodge = presets.dodge.poor
	self.german_grunt_light.deathguard = false
	self.german_grunt_light.chatter = presets.enemy_chatter.regular
	self.german_grunt_light.steal_loot = false
	self.german_grunt_light.loot_table = "easy_enemy"
	self.german_grunt_light.type = CharacterTweakData.ENEMY_TYPE_SOLDIER
	self.german_grunt_light.carry_tweak_corpse = "german_grunt_light_body"
	self.german_grunt_light.loadout = self.npc_loadouts.ger_handgun
	self.german_grunt_light_mp38 = clone(self.german_grunt_light)
	self.german_grunt_light_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_grunt_light_kar98 = clone(self.german_grunt_light)
	self.german_grunt_light_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_grunt_light_stg44 = clone(self.german_grunt_light)
	self.german_grunt_light_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_grunt_light_shotgun = clone(self.german_grunt_light)
	self.german_grunt_light_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_grunt_light")
	table.insert(self._enemies_list, "german_grunt_light_mp38")
	table.insert(self._enemies_list, "german_grunt_light_kar98")
	table.insert(self._enemies_list, "german_grunt_light_stg44")
	table.insert(self._enemies_list, "german_grunt_light_shotgun")
end

function CharacterTweakData:_init_german_grunt_mid(presets)
	self.german_grunt_mid = deep_clone(presets.base)
	self.german_grunt_mid.experience = {}
	self.german_grunt_mid.weapon = presets.weapon.normal
	self.german_grunt_mid.detection = presets.detection.normal
	self.german_grunt_mid.vision = presets.vision.easy
	self.german_grunt_mid.HEALTH_INIT = 120
	self.german_grunt_mid.BASE_HEALTH_INIT = 120
	self.german_grunt_mid.headshot_dmg_mul = 1
	self.german_grunt_mid.move_speed = presets.move_speed.normal
	self.german_grunt_mid.suppression = presets.suppression.easy
	self.german_grunt_mid.ecm_vulnerability = 1
	self.german_grunt_mid.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_grunt_mid.speech_prefix_p1 = "ger"
	self.german_grunt_mid.speech_prefix_p2 = "soldier"
	self.german_grunt_mid.speech_prefix_count = 4
	self.german_grunt_mid.access = "swat"
	self.german_grunt_mid.silent_priority_shout = "shout_loud_soldier"
	self.german_grunt_mid.dodge = presets.dodge.average
	self.german_grunt_mid.deathguard = false
	self.german_grunt_mid.chatter = presets.enemy_chatter.regular
	self.german_grunt_mid.steal_loot = false
	self.german_grunt_mid.loot_table = "easy_enemy"
	self.german_grunt_mid.type = CharacterTweakData.ENEMY_TYPE_SOLDIER
	self.german_grunt_mid.carry_tweak_corpse = "german_grunt_mid_body"
	self.german_grunt_mid.loadout = self.npc_loadouts.ger_handgun
	self.german_grunt_mid_mp38 = clone(self.german_grunt_mid)
	self.german_grunt_mid_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_grunt_mid_kar98 = clone(self.german_grunt_mid)
	self.german_grunt_mid_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_grunt_mid_stg44 = clone(self.german_grunt_mid)
	self.german_grunt_mid_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_grunt_mid_shotgun = clone(self.german_grunt_mid)
	self.german_grunt_mid_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_grunt_mid")
	table.insert(self._enemies_list, "german_grunt_mid_mp38")
	table.insert(self._enemies_list, "german_grunt_mid_kar98")
	table.insert(self._enemies_list, "german_grunt_mid_stg44")
	table.insert(self._enemies_list, "german_grunt_mid_shotgun")
end

function CharacterTweakData:_init_german_grunt_heavy(presets)
	self.german_grunt_heavy = deep_clone(presets.base)
	self.german_grunt_heavy.experience = {}
	self.german_grunt_heavy.weapon = presets.weapon.normal
	self.german_grunt_heavy.detection = presets.detection.normal
	self.german_grunt_heavy.vision = presets.vision.easy
	self.german_grunt_heavy.HEALTH_INIT = 160
	self.german_grunt_heavy.BASE_HEALTH_INIT = 160
	self.german_grunt_heavy.headshot_dmg_mul = 0.8
	self.german_grunt_heavy.headshot_helmet = true
	self.german_grunt_heavy.move_speed = presets.move_speed.normal
	self.german_grunt_heavy.crouch_move = false
	self.german_grunt_heavy.suppression = presets.suppression.easy
	self.german_grunt_heavy.ecm_vulnerability = 1
	self.german_grunt_heavy.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_grunt_heavy.speech_prefix_p1 = "ger"
	self.german_grunt_heavy.speech_prefix_p2 = "soldier"
	self.german_grunt_heavy.speech_prefix_count = 4
	self.german_grunt_heavy.access = "swat"
	self.german_grunt_heavy.silent_priority_shout = "shout_loud_soldier"
	self.german_grunt_heavy.dodge = presets.dodge.heavy
	self.german_grunt_heavy.deathguard = false
	self.german_grunt_heavy.chatter = presets.enemy_chatter.regular
	self.german_grunt_heavy.steal_loot = false
	self.german_grunt_heavy.loot_table = "normal_enemy"
	self.german_grunt_heavy.type = CharacterTweakData.ENEMY_TYPE_SOLDIER
	self.german_grunt_heavy.carry_tweak_corpse = "german_grunt_heavy_body"
	self.german_grunt_heavy.loadout = self.npc_loadouts.ger_handgun
	self.german_grunt_heavy_mp38 = clone(self.german_grunt_heavy)
	self.german_grunt_heavy_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_grunt_heavy_kar98 = clone(self.german_grunt_heavy)
	self.german_grunt_heavy_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_grunt_heavy_stg44 = clone(self.german_grunt_heavy)
	self.german_grunt_heavy_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_grunt_heavy_shotgun = clone(self.german_grunt_heavy)
	self.german_grunt_heavy_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_grunt_heavy")
	table.insert(self._enemies_list, "german_grunt_heavy_mp38")
	table.insert(self._enemies_list, "german_grunt_heavy_kar98")
	table.insert(self._enemies_list, "german_grunt_heavy_stg44")
	table.insert(self._enemies_list, "german_grunt_heavy_shotgun")
end

function CharacterTweakData:_init_german_gebirgsjager_light(presets)
	self.german_gebirgsjager_light = deep_clone(presets.base)
	self.german_gebirgsjager_light.experience = {}
	self.german_gebirgsjager_light.weapon = presets.weapon.good
	self.german_gebirgsjager_light.detection = presets.detection.normal
	self.german_gebirgsjager_light.vision = presets.vision.normal
	self.german_gebirgsjager_light.HEALTH_INIT = 160
	self.german_gebirgsjager_light.BASE_HEALTH_INIT = 160
	self.german_gebirgsjager_light.headshot_dmg_mul = 1
	self.german_gebirgsjager_light.move_speed = presets.move_speed.fast
	self.german_gebirgsjager_light.suppression = presets.suppression.hard_def
	self.german_gebirgsjager_light.ecm_vulnerability = 1
	self.german_gebirgsjager_light.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_gebirgsjager_light.speech_prefix_p1 = "ger"
	self.german_gebirgsjager_light.speech_prefix_p2 = "paratrooper"
	self.german_gebirgsjager_light.speech_prefix_count = 4
	self.german_gebirgsjager_light.access = "swat"
	self.german_gebirgsjager_light.silent_priority_shout = "shout_loud_paratrooper"
	self.german_gebirgsjager_light.dodge = presets.dodge.athletic
	self.german_gebirgsjager_light.deathguard = false
	self.german_gebirgsjager_light.chatter = presets.enemy_chatter.regular
	self.german_gebirgsjager_light.steal_loot = false
	self.german_gebirgsjager_light.loot_table = "normal_enemy"
	self.german_gebirgsjager_light.type = CharacterTweakData.ENEMY_TYPE_PARATROOPER
	self.german_gebirgsjager_light.carry_tweak_corpse = "german_gebirgsjager_light_body"
	self.german_gebirgsjager_light.loadout = self.npc_loadouts.ger_handgun
	self.german_gebirgsjager_light_mp38 = clone(self.german_gebirgsjager_light)
	self.german_gebirgsjager_light_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_gebirgsjager_light_kar98 = clone(self.german_gebirgsjager_light)
	self.german_gebirgsjager_light_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_gebirgsjager_light_stg44 = clone(self.german_gebirgsjager_light)
	self.german_gebirgsjager_light_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_gebirgsjager_light_shotgun = clone(self.german_gebirgsjager_light)
	self.german_gebirgsjager_light_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_gebirgsjager_light")
	table.insert(self._enemies_list, "german_gebirgsjager_light_mp38")
	table.insert(self._enemies_list, "german_gebirgsjager_light_kar98")
	table.insert(self._enemies_list, "german_gebirgsjager_light_stg44")
	table.insert(self._enemies_list, "german_gebirgsjager_light_shotgun")
end

function CharacterTweakData:_init_german_gebirgsjager_heavy(presets)
	self.german_gebirgsjager_heavy = deep_clone(presets.base)
	self.german_gebirgsjager_heavy.experience = {}
	self.german_gebirgsjager_heavy.weapon = presets.weapon.good
	self.german_gebirgsjager_heavy.detection = presets.detection.normal
	self.german_gebirgsjager_heavy.vision = presets.vision.normal
	self.german_gebirgsjager_heavy.HEALTH_INIT = 210
	self.german_gebirgsjager_heavy.BASE_HEALTH_INIT = 210
	self.german_gebirgsjager_heavy.headshot_dmg_mul = 0.8
	self.german_gebirgsjager_heavy.headshot_helmet = true
	self.german_gebirgsjager_heavy.move_speed = presets.move_speed.normal
	self.german_gebirgsjager_heavy.crouch_move = false
	self.german_gebirgsjager_heavy.suppression = presets.suppression.hard_def
	self.german_gebirgsjager_heavy.ecm_vulnerability = 1
	self.german_gebirgsjager_heavy.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_gebirgsjager_heavy.speech_prefix_p1 = "ger"
	self.german_gebirgsjager_heavy.speech_prefix_p2 = "paratrooper"
	self.german_gebirgsjager_heavy.speech_prefix_count = 4
	self.german_gebirgsjager_heavy.access = "swat"
	self.german_gebirgsjager_heavy.silent_priority_shout = "shout_loud_paratrooper"
	self.german_gebirgsjager_heavy.dodge = presets.dodge.heavy
	self.german_gebirgsjager_heavy.deathguard = false
	self.german_gebirgsjager_heavy.chatter = presets.enemy_chatter.regular
	self.german_gebirgsjager_heavy.steal_loot = false
	self.german_gebirgsjager_heavy.loot_table = "normal_enemy"
	self.german_gebirgsjager_heavy.type = CharacterTweakData.ENEMY_TYPE_PARATROOPER
	self.german_gebirgsjager_heavy.carry_tweak_corpse = "german_gebirgsjager_heavy_body"
	self.german_gebirgsjager_heavy.loadout = self.npc_loadouts.ger_handgun
	self.german_gebirgsjager_heavy_mp38 = clone(self.german_gebirgsjager_heavy)
	self.german_gebirgsjager_heavy_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_gebirgsjager_heavy_kar98 = clone(self.german_gebirgsjager_heavy)
	self.german_gebirgsjager_heavy_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_gebirgsjager_heavy_stg44 = clone(self.german_gebirgsjager_heavy)
	self.german_gebirgsjager_heavy_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_gebirgsjager_heavy_shotgun = clone(self.german_gebirgsjager_heavy)
	self.german_gebirgsjager_heavy_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_gebirgsjager_heavy")
	table.insert(self._enemies_list, "german_gebirgsjager_heavy_mp38")
	table.insert(self._enemies_list, "german_gebirgsjager_heavy_kar98")
	table.insert(self._enemies_list, "german_gebirgsjager_heavy_stg44")
	table.insert(self._enemies_list, "german_gebirgsjager_heavy_shotgun")
end

function CharacterTweakData:_init_german_light(presets)
	self.german_light = deep_clone(presets.base)
	self.german_light.experience = {}
	self.german_light.weapon = presets.weapon.insane
	self.german_light.detection = presets.detection.normal
	self.german_light.vision = presets.vision.normal
	self.german_light.HEALTH_INIT = 160
	self.german_light.BASE_HEALTH_INIT = 160
	self.german_light.headshot_dmg_mul = 1
	self.german_light.move_speed = presets.move_speed.fast
	self.german_light.suppression = presets.suppression.hard_agg
	self.german_light.ecm_vulnerability = 1
	self.german_light.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_light.speech_prefix_p1 = "ger"
	self.german_light.speech_prefix_p2 = "elite"
	self.german_light.speech_prefix_count = 4
	self.german_light.access = "swat"
	self.german_light.silent_priority_shout = "shout_loud_soldier"
	self.german_light.dodge = presets.dodge.athletic
	self.german_light.deathguard = true
	self.german_light.chatter = presets.enemy_chatter.regular
	self.german_light.steal_loot = false
	self.german_light.loot_table = "hard_enemy"
	self.german_light.type = CharacterTweakData.ENEMY_TYPE_ELITE
	self.german_light.carry_tweak_corpse = "german_black_waffen_sentry_light_body"
	self.german_light.loadout = self.npc_loadouts.ger_handgun
	self.german_light_mp38 = clone(self.german_light)
	self.german_light_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_light_kar98 = clone(self.german_light)
	self.german_light_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_light_stg44 = clone(self.german_light)
	self.german_light_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_light_shotgun = clone(self.german_light)
	self.german_light_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_light")
	table.insert(self._enemies_list, "german_light_mp38")
	table.insert(self._enemies_list, "german_light_kar98")
	table.insert(self._enemies_list, "german_light_stg44")
	table.insert(self._enemies_list, "german_light_shotgun")
end

function CharacterTweakData:_init_german_heavy(presets)
	self.german_heavy = deep_clone(presets.base)
	self.german_heavy.experience = {}
	self.german_heavy.weapon = presets.weapon.insane
	self.german_heavy.detection = presets.detection.normal
	self.german_heavy.vision = presets.vision.normal
	self.german_heavy.HEALTH_INIT = 210
	self.german_heavy.BASE_HEALTH_INIT = 210
	self.german_heavy.headshot_dmg_mul = 0.8
	self.german_heavy.headshot_helmet = true
	self.german_heavy.move_speed = presets.move_speed.normal
	self.german_heavy.crouch_move = false
	self.german_heavy.suppression = presets.suppression.hard_agg
	self.german_heavy.ecm_vulnerability = 1
	self.german_heavy.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_heavy.speech_prefix_p1 = "ger"
	self.german_heavy.speech_prefix_p2 = "elite"
	self.german_heavy.speech_prefix_count = 4
	self.german_heavy.access = "swat"
	self.german_heavy.silent_priority_shout = "shout_loud_soldier"
	self.german_heavy.dodge = presets.dodge.heavy
	self.german_heavy.deathguard = true
	self.german_heavy.chatter = presets.enemy_chatter.regular
	self.german_heavy.steal_loot = false
	self.german_heavy.loot_table = "elite_enemy"
	self.german_heavy.type = CharacterTweakData.ENEMY_TYPE_ELITE
	self.german_heavy.carry_tweak_corpse = "german_black_waffen_sentry_heavy_body"
	self.german_heavy.loadout = self.npc_loadouts.ger_handgun
	self.german_heavy_mp38 = clone(self.german_heavy)
	self.german_heavy_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_heavy_kar98 = clone(self.german_heavy)
	self.german_heavy_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_heavy_stg44 = clone(self.german_heavy)
	self.german_heavy_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_heavy_shotgun = clone(self.german_heavy)
	self.german_heavy_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_heavy")
	table.insert(self._enemies_list, "german_heavy_mp38")
	table.insert(self._enemies_list, "german_heavy_kar98")
	table.insert(self._enemies_list, "german_heavy_stg44")
	table.insert(self._enemies_list, "german_heavy_shotgun")
end

function CharacterTweakData:_init_german_fallschirmjager_light(presets)
	self.german_fallschirmjager_light = deep_clone(presets.base)
	self.german_fallschirmjager_light.experience = {}
	self.german_fallschirmjager_light.weapon = presets.weapon.expert
	self.german_fallschirmjager_light.detection = presets.detection.normal
	self.german_fallschirmjager_light.vision = presets.vision.hard
	self.german_fallschirmjager_light.HEALTH_INIT = 160
	self.german_fallschirmjager_light.BASE_HEALTH_INIT = 160
	self.german_fallschirmjager_light.headshot_dmg_mul = 1
	self.german_fallschirmjager_light.move_speed = presets.move_speed.fast
	self.german_fallschirmjager_light.suppression = presets.suppression.hard_def
	self.german_fallschirmjager_light.ecm_vulnerability = 1
	self.german_fallschirmjager_light.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_fallschirmjager_light.speech_prefix_p1 = "ger"
	self.german_fallschirmjager_light.speech_prefix_p2 = "paratrooper"
	self.german_fallschirmjager_light.speech_prefix_count = 4
	self.german_fallschirmjager_light.access = "swat"
	self.german_fallschirmjager_light.silent_priority_shout = "shout_loud_paratrooper"
	self.german_fallschirmjager_light.dodge = presets.dodge.athletic
	self.german_fallschirmjager_light.deathguard = true
	self.german_fallschirmjager_light.chatter = presets.enemy_chatter.regular
	self.german_fallschirmjager_light.steal_loot = false
	self.german_fallschirmjager_light.loot_table = "hard_enemy"
	self.german_fallschirmjager_light.type = CharacterTweakData.ENEMY_TYPE_PARATROOPER
	self.german_fallschirmjager_light.carry_tweak_corpse = "german_fallschirmjager_light_body"
	self.german_fallschirmjager_light.loadout = self.npc_loadouts.ger_handgun
	self.german_fallschirmjager_light_mp38 = clone(self.german_fallschirmjager_light)
	self.german_fallschirmjager_light_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_fallschirmjager_light_kar98 = clone(self.german_fallschirmjager_light)
	self.german_fallschirmjager_light_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_fallschirmjager_light_stg44 = clone(self.german_fallschirmjager_light)
	self.german_fallschirmjager_light_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_fallschirmjager_light_shotgun = clone(self.german_fallschirmjager_light)
	self.german_fallschirmjager_light_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_fallschirmjager_light")
	table.insert(self._enemies_list, "german_fallschirmjager_light_mp38")
	table.insert(self._enemies_list, "german_fallschirmjager_light_kar98")
	table.insert(self._enemies_list, "german_fallschirmjager_light_stg44")
	table.insert(self._enemies_list, "german_fallschirmjager_light_shotgun")
end

function CharacterTweakData:_init_german_fallschirmjager_heavy(presets)
	self.german_fallschirmjager_heavy = deep_clone(presets.base)
	self.german_fallschirmjager_heavy.experience = {}
	self.german_fallschirmjager_heavy.weapon = presets.weapon.expert
	self.german_fallschirmjager_heavy.detection = presets.detection.normal
	self.german_fallschirmjager_heavy.vision = presets.vision.hard
	self.german_fallschirmjager_heavy.HEALTH_INIT = 210
	self.german_fallschirmjager_heavy.BASE_HEALTH_INIT = 210
	self.german_fallschirmjager_heavy.headshot_dmg_mul = 0.8
	self.german_fallschirmjager_heavy.headshot_helmet = true
	self.german_fallschirmjager_heavy.move_speed = presets.move_speed.normal
	self.german_fallschirmjager_heavy.crouch_move = false
	self.german_fallschirmjager_heavy.suppression = presets.suppression.hard_def
	self.german_fallschirmjager_heavy.ecm_vulnerability = 1
	self.german_fallschirmjager_heavy.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_fallschirmjager_heavy.speech_prefix_p1 = "ger"
	self.german_fallschirmjager_heavy.speech_prefix_p2 = "paratrooper"
	self.german_fallschirmjager_heavy.speech_prefix_count = 4
	self.german_fallschirmjager_heavy.access = "swat"
	self.german_fallschirmjager_heavy.silent_priority_shout = "shout_loud_paratrooper"
	self.german_fallschirmjager_heavy.dodge = presets.dodge.heavy
	self.german_fallschirmjager_heavy.deathguard = false
	self.german_fallschirmjager_heavy.chatter = presets.enemy_chatter.regular
	self.german_fallschirmjager_heavy.steal_loot = false
	self.german_fallschirmjager_heavy.loot_table = "hard_enemy"
	self.german_fallschirmjager_heavy.type = CharacterTweakData.ENEMY_TYPE_PARATROOPER
	self.german_fallschirmjager_heavy.carry_tweak_corpse = "german_fallschirmjager_heavy_body"
	self.german_fallschirmjager_heavy.loadout = self.npc_loadouts.ger_handgun
	self.german_fallschirmjager_heavy_mp38 = clone(self.german_fallschirmjager_heavy)
	self.german_fallschirmjager_heavy_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_fallschirmjager_heavy_kar98 = clone(self.german_fallschirmjager_heavy)
	self.german_fallschirmjager_heavy_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_fallschirmjager_heavy_stg44 = clone(self.german_fallschirmjager_heavy)
	self.german_fallschirmjager_heavy_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_fallschirmjager_heavy_shotgun = clone(self.german_fallschirmjager_heavy)
	self.german_fallschirmjager_heavy_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_fallschirmjager_heavy")
	table.insert(self._enemies_list, "german_fallschirmjager_heavy_mp38")
	table.insert(self._enemies_list, "german_fallschirmjager_heavy_kar98")
	table.insert(self._enemies_list, "german_fallschirmjager_heavy_stg44")
	table.insert(self._enemies_list, "german_fallschirmjager_heavy_shotgun")
end

function CharacterTweakData:_init_german_gasmask(presets)
	self.german_gasmask = deep_clone(presets.base)
	self.german_gasmask.experience = {}
	self.german_gasmask.weapon = presets.weapon.expert
	self.german_gasmask.detection = presets.detection.normal
	self.german_gasmask.vision = presets.vision.hard
	self.german_gasmask.HEALTH_INIT = 210
	self.german_gasmask.BASE_HEALTH_INIT = 210
	self.german_gasmask.headshot_dmg_mul = 0.8
	self.german_gasmask.headshot_helmet = true
	self.german_gasmask.move_speed = presets.move_speed.normal
	self.german_gasmask.crouch_move = false
	self.german_gasmask.suppression = presets.suppression.hard_agg
	self.german_gasmask.ecm_vulnerability = 1
	self.german_gasmask.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_gasmask.speech_prefix_p1 = "ger"
	self.german_gasmask.speech_prefix_p2 = "elite"
	self.german_gasmask.speech_prefix_count = 4
	self.german_gasmask.access = "swat"
	self.german_gasmask.silent_priority_shout = "shout_loud_soldier"
	self.german_gasmask.dodge = presets.dodge.average
	self.german_gasmask.deathguard = true
	self.german_gasmask.chatter = presets.enemy_chatter.regular
	self.german_gasmask.steal_loot = false
	self.german_gasmask.loot_table = "elite_enemy"
	self.german_gasmask.type = CharacterTweakData.ENEMY_TYPE_ELITE
	self.german_gasmask.carry_tweak_corpse = "german_black_waffen_sentry_gasmask_body"
	self.german_gasmask.loadout = self.npc_loadouts.ger_handgun
	self.german_gasmask_mp38 = clone(self.german_gasmask)
	self.german_gasmask_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_gasmask_kar98 = clone(self.german_gasmask)
	self.german_gasmask_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_gasmask_stg44 = clone(self.german_gasmask)
	self.german_gasmask_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_gasmask_shotgun = clone(self.german_gasmask)
	self.german_gasmask_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_gasmask")
	table.insert(self._enemies_list, "german_gasmask_mp38")
	table.insert(self._enemies_list, "german_gasmask_kar98")
	table.insert(self._enemies_list, "german_gasmask_stg44")
	table.insert(self._enemies_list, "german_gasmask_shotgun")
end

function CharacterTweakData:_init_german_commander_backup(presets)
	self.german_light_commander_backup = clone(self.german_light)
	self.german_light_commander_backup.carry_tweak_corpse = "german_black_waffen_sentry_light_commander_body"

	table.insert(self._enemies_list, "german_light_commander_backup")

	self.german_light_commander_backup_mp38 = clone(self.german_light_mp38)
	self.german_light_commander_backup_mp38.carry_tweak_corpse = "german_black_waffen_sentry_light_commander_body"

	table.insert(self._enemies_list, "german_light_commander_backup_mp38")

	self.german_light_commander_backup_kar98 = clone(self.german_light_kar98)
	self.german_light_commander_backup_kar98.carry_tweak_corpse = "german_black_waffen_sentry_light_commander_body"

	table.insert(self._enemies_list, "german_light_commander_backup_kar98")

	self.german_light_commander_backup_stg44 = clone(self.german_light_stg44)
	self.german_light_commander_backup_stg44.carry_tweak_corpse = "german_black_waffen_sentry_light_commander_body"

	table.insert(self._enemies_list, "german_light_commander_backup_stg44")

	self.german_light_commander_backup_shotgun = clone(self.german_light_shotgun)
	self.german_light_commander_backup_shotgun.carry_tweak_corpse = "german_black_waffen_sentry_light_commander_body"

	table.insert(self._enemies_list, "german_light_commander_backup_shotgun")

	self.german_heavy_commander_backup = clone(self.german_heavy)
	self.german_heavy_commander_backup.carry_tweak_corpse = "german_black_waffen_sentry_heavy_commander_body"

	table.insert(self._enemies_list, "german_heavy_commander_backup")

	self.german_heavy_commander_backup_mp38 = clone(self.german_heavy_mp38)
	self.german_heavy_commander_backup_mp38.carry_tweak_corpse = "german_black_waffen_sentry_heavy_commander_body"

	table.insert(self._enemies_list, "german_heavy_commander_backup_mp38")

	self.german_heavy_commander_backup_kar98 = clone(self.german_heavy_kar98)
	self.german_heavy_commander_backup_kar98.carry_tweak_corpse = "german_black_waffen_sentry_heavy_commander_body"

	table.insert(self._enemies_list, "german_heavy_commander_backup_kar98")

	self.german_heavy_commander_backup_stg44 = clone(self.german_heavy_stg44)
	self.german_heavy_commander_backup_stg44.carry_tweak_corpse = "german_black_waffen_sentry_heavy_commander_body"

	table.insert(self._enemies_list, "german_heavy_commander_backup_stg44")

	self.german_heavy_commander_backup_shotgun = clone(self.german_heavy_shotgun)
	self.german_heavy_commander_backup_shotgun.carry_tweak_corpse = "german_black_waffen_sentry_heavy_commander_body"

	table.insert(self._enemies_list, "german_heavy_commander_backup_shotgun")
end

function CharacterTweakData:_init_german_waffen_ss(presets)
	self.german_waffen_ss = deep_clone(presets.base)
	self.german_waffen_ss.experience = {}
	self.german_waffen_ss.weapon = presets.weapon.insane
	self.german_waffen_ss.detection = presets.detection.normal
	self.german_waffen_ss.vision = presets.vision.hard
	self.german_waffen_ss.HEALTH_INIT = 210
	self.german_waffen_ss.BASE_HEALTH_INIT = 210
	self.german_waffen_ss.headshot_dmg_mul = 1
	self.german_waffen_ss.move_speed = presets.move_speed.fast
	self.german_waffen_ss.crouch_move = false
	self.german_waffen_ss.suppression = presets.suppression.hard_def
	self.german_waffen_ss.ecm_vulnerability = 1
	self.german_waffen_ss.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_waffen_ss.speech_prefix_p1 = "ger"
	self.german_waffen_ss.speech_prefix_p2 = "paratrooper"
	self.german_waffen_ss.speech_prefix_count = 4
	self.german_waffen_ss.access = "swat"
	self.german_waffen_ss.silent_priority_shout = "shout_loud_soldier"
	self.german_waffen_ss.dodge = presets.dodge.average
	self.german_waffen_ss.deathguard = false
	self.german_waffen_ss.chatter = presets.enemy_chatter.regular
	self.german_waffen_ss.steal_loot = false
	self.german_waffen_ss.loot_table = "elite_enemy"
	self.german_waffen_ss.type = CharacterTweakData.ENEMY_TYPE_PARATROOPER
	self.german_waffen_ss.carry_tweak_corpse = "german_fallschirmjager_heavy_body"
	self.german_waffen_ss.loadout = self.npc_loadouts.ger_handgun
	self.german_waffen_ss_mp38 = clone(self.german_waffen_ss)
	self.german_waffen_ss_mp38.loadout = self.npc_loadouts.ger_smg
	self.german_waffen_ss_kar98 = clone(self.german_waffen_ss)
	self.german_waffen_ss_kar98.loadout = self.npc_loadouts.ger_rifle
	self.german_waffen_ss_stg44 = clone(self.german_waffen_ss)
	self.german_waffen_ss_stg44.loadout = self.npc_loadouts.ger_assault_rifle
	self.german_waffen_ss_shotgun = clone(self.german_waffen_ss)
	self.german_waffen_ss_shotgun.loadout = self.npc_loadouts.ger_shotgun

	table.insert(self._enemies_list, "german_waffen_ss")
	table.insert(self._enemies_list, "german_waffen_ss_mp38")
	table.insert(self._enemies_list, "german_waffen_ss_kar98")
	table.insert(self._enemies_list, "german_waffen_ss_stg44")
	table.insert(self._enemies_list, "german_waffen_ss_shotgun")
end

function CharacterTweakData:_init_german_commander(presets)
	self.german_commander = deep_clone(presets.base)
	self.german_commander.experience = {}
	self.german_commander.weapon = presets.weapon.expert
	self.german_commander.detection = presets.detection.normal
	self.german_commander.vision = presets.vision.commander
	self.german_commander.HEALTH_INIT = 400
	self.german_commander.BASE_HEALTH_INIT = 400
	self.german_commander.headshot_dmg_mul = 1
	self.german_commander.move_speed = presets.move_speed.very_fast
	self.german_commander.suppression = presets.suppression.no_supress
	self.german_commander.ecm_vulnerability = 1
	self.german_commander.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_commander.speech_prefix_p1 = "ger"
	self.german_commander.speech_prefix_p2 = "officer"
	self.german_commander.speech_prefix_count = 4
	self.german_commander.access = "fbi"
	self.german_commander.silent_priority_shout = "shout_loud_officer"
	self.german_commander.priority_shout = "shout_loud_officer"
	self.german_commander.priority_waypoint = "waypoint_special_mark_officer"
	self.german_commander.announce_incomming = "incomming_commander"
	self.german_commander.dodge = presets.dodge.athletic
	self.german_commander.deathguard = true
	self.german_commander.chatter = presets.enemy_chatter.special
	self.german_commander.steal_loot = false
	self.german_commander.loot_table = "special_enemy"
	self.german_commander.type = CharacterTweakData.ENEMY_TYPE_OFFICER
	self.german_commander.is_special = true
	self.german_commander.special_type = CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER
	self.german_commander.carry_tweak_corpse = "german_commander_body"
	self.german_commander.gear = {
		items = {
			Spine2 = {
				"units/vanilla/characters/props/prop_backpack_radio/prop_backpack_radio",
			},
		},
		run_char_seqs = {},
	}
	self.german_commander.loadout = self.npc_loadouts.special_commander

	table.insert(self._enemies_list, "german_commander")
end

function CharacterTweakData:_init_german_og_commander(presets)
	self.german_og_commander = deep_clone(presets.base)
	self.german_og_commander.experience = {}
	self.german_og_commander.weapon = presets.weapon.expert
	self.german_og_commander.detection = presets.detection.normal
	self.german_og_commander.vision = presets.vision.commander
	self.german_og_commander.HEALTH_INIT = 400
	self.german_og_commander.BASE_HEALTH_INIT = 400
	self.german_og_commander.headshot_dmg_mul = 1
	self.german_og_commander.move_speed = presets.move_speed.very_fast
	self.german_og_commander.suppression = presets.suppression.no_supress
	self.german_og_commander.ecm_vulnerability = 1
	self.german_og_commander.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_og_commander.speech_prefix_p1 = "ger"
	self.german_og_commander.speech_prefix_p2 = "officer"
	self.german_og_commander.speech_prefix_count = 4
	self.german_og_commander.access = "fbi"
	self.german_og_commander.silent_priority_shout = "shout_loud_officer"
	self.german_og_commander.priority_shout = "shout_loud_officer"
	self.german_og_commander.priority_waypoint = "waypoint_special_mark_officer"
	self.german_og_commander.announce_incomming = "incomming_commander"
	self.german_og_commander.dodge = presets.dodge.athletic
	self.german_og_commander.deathguard = true
	self.german_og_commander.chatter = presets.enemy_chatter.special
	self.german_og_commander.steal_loot = false
	self.german_og_commander.loot_table = "special_enemy"
	self.german_og_commander.type = CharacterTweakData.ENEMY_TYPE_OFFICER
	self.german_og_commander.is_special = true
	self.german_og_commander.special_type = CharacterTweakData.SPECIAL_UNIT_TYPE_COMMANDER
	self.german_og_commander.carry_tweak_corpse = "german_og_commander_body"
	self.german_og_commander.gear = {
		items = {
			Spine2 = {
				"units/vanilla/characters/props/prop_backpack_radio/prop_backpack_radio",
			},
		},
		run_char_seqs = {},
	}
	self.german_og_commander.loadout = self.npc_loadouts.special_commander

	table.insert(self._enemies_list, "german_og_commander")
end

function CharacterTweakData:_init_german_officer(presets)
	self.german_officer = deep_clone(presets.base)
	self.german_officer.experience = {}
	self.german_officer.weapon = presets.weapon.expert
	self.german_officer.detection = presets.detection.normal
	self.german_officer.vision = presets.vision.commander
	self.german_officer.HEALTH_INIT = 400
	self.german_officer.BASE_HEALTH_INIT = 400
	self.german_officer.headshot_dmg_mul = 1
	self.german_officer.move_speed = presets.move_speed.very_fast
	self.german_officer.suppression = presets.suppression.no_supress
	self.german_officer.ecm_vulnerability = 1
	self.german_officer.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_officer.speech_prefix_p1 = "ger"
	self.german_officer.speech_prefix_p2 = "officer"
	self.german_officer.speech_prefix_count = 4
	self.german_officer.access = "fbi"
	self.german_officer.silent_priority_shout = "shout_loud_officer"
	self.german_officer.priority_waypoint = "waypoint_special_mark_officer"
	self.german_officer.dodge = presets.dodge.athletic
	self.german_officer.deathguard = true
	self.german_officer.chatter = presets.enemy_chatter.special
	self.german_officer.steal_loot = false
	self.german_officer.loot_table = "special_enemy"
	self.german_officer.type = CharacterTweakData.ENEMY_TYPE_OFFICER
	self.german_officer.carry_tweak_corpse = "german_commander_body"
	self.german_officer.loadout = self.npc_loadouts.special_commander

	table.insert(self._enemies_list, "german_officer")
end

function CharacterTweakData:_init_soviet_nkvd_int_security_captain(presets)
	self.soviet_nkvd_int_security_captain = deep_clone(presets.base)
	self.soviet_nkvd_int_security_captain.experience = {}
	self.soviet_nkvd_int_security_captain.weapon = presets.weapon.expert
	self.soviet_nkvd_int_security_captain.detection = presets.detection.normal
	self.soviet_nkvd_int_security_captain.vision = presets.vision.commander
	self.soviet_nkvd_int_security_captain.HEALTH_INIT = 100
	self.soviet_nkvd_int_security_captain.BASE_HEALTH_INIT = 100
	self.soviet_nkvd_int_security_captain.headshot_dmg_mul = 1
	self.soviet_nkvd_int_security_captain.move_speed = presets.move_speed.very_fast
	self.soviet_nkvd_int_security_captain.suppression = presets.suppression.no_supress
	self.soviet_nkvd_int_security_captain.ecm_vulnerability = 1
	self.soviet_nkvd_int_security_captain.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.soviet_nkvd_int_security_captain.speech_prefix_p1 = "ger"
	self.soviet_nkvd_int_security_captain.speech_prefix_p2 = "officer"
	self.soviet_nkvd_int_security_captain.speech_prefix_count = 4
	self.soviet_nkvd_int_security_captain.access = "swat"
	self.soviet_nkvd_int_security_captain.silent_priority_shout = "shout_loud_soldier"
	self.soviet_nkvd_int_security_captain.dodge = presets.dodge.athletic
	self.soviet_nkvd_int_security_captain.deathguard = true
	self.soviet_nkvd_int_security_captain.chatter = presets.enemy_chatter.no_chatter
	self.soviet_nkvd_int_security_captain.steal_loot = false
	self.soviet_nkvd_int_security_captain.loot_table = "special_enemy"
	self.soviet_nkvd_int_security_captain.type = CharacterTweakData.ENEMY_TYPE_OFFICER
	self.soviet_nkvd_int_security_captain.carry_tweak_corpse = "soviet_nkvd_int_security_captain_body"
	self.soviet_nkvd_int_security_captain.loadout = self.npc_loadouts.unarmed

	table.insert(self._enemies_list, "soviet_nkvd_int_security_captain")
end

function CharacterTweakData:_init_soviet_nkvd_int_security_captain_b(presets)
	self.soviet_nkvd_int_security_captain_b = deep_clone(self.soviet_nkvd_int_security_captain)
	self.soviet_nkvd_int_security_captain_b.speech_prefix_p1 = "ger"
	self.soviet_nkvd_int_security_captain_b.speech_prefix_p2 = "officer"
	self.soviet_nkvd_int_security_captain_b.speech_prefix_count = 4

	table.insert(self._enemies_list, "soviet_nkvd_int_security_captain_b")
end

function CharacterTweakData:_init_german_flamer(presets)
	self.german_flamer = deep_clone(presets.base)
	self.german_flamer.experience = {}
	self.german_flamer.detection = presets.detection.flamer
	self.german_flamer.vision = presets.vision.easy
	self.german_flamer.HEALTH_INIT = 1
	self.german_flamer.headshot_dmg_mul = 0.8
	self.german_flamer.headshot_helmet = true
	self.german_flamer.friendly_fire_dmg_mul = 0.5
	self.german_flamer.dodge = presets.dodge.poor
	self.german_flamer.allowed_stances = {
		cbt = true,
	}
	self.german_flamer.allowed_poses = {
		stand = true,
	}
	self.german_flamer.always_face_enemy = true
	self.german_flamer.move_speed = presets.move_speed.super_slow
	self.german_flamer.crouch_move = false
	self.german_flamer.no_run_start = true
	self.german_flamer.no_run_stop = true
	self.german_flamer.loot_table = "flamer_enemy"
	self.german_flamer.priority_shout = "shout_loud_flamer"
	self.german_flamer.priority_waypoint = "waypoint_special_mark_flamer"
	self.german_flamer.deathguard = true
	self.german_flamer.no_equip_anim = true
	self.german_flamer.never_strafe = true
	self.german_flamer.wall_fwd_offset = 100
	self.german_flamer.calls_in = nil
	self.german_flamer.damage.explosion_damage_mul = 0.665
	self.german_flamer.damage.fire_damage_mul = 0.011
	self.german_flamer.critical_hits.damage_mul = 1.2
	self.german_flamer.damage.hurt_severity = deep_clone(presets.hurt_severities.no_hurts)
	self.german_flamer.damage.hurt_severity.explosion = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.1,
				none = 1,
			},
			{
				explode = 0.5,
				health_limit = 0.5,
				none = 0.5,
			},
			{
				explode = 1,
			},
		},
	}
	self.german_flamer.damage.ignore_knockdown = true
	self.german_flamer.use_animation_on_fire_damage = false
	self.german_flamer.flammable = true
	self.german_flamer.loadout = self.npc_loadouts.special_flamethrower
	self.german_flamer.weapon = {}

	local max_range = 1200

	self.german_flamer.weapon.ak47 = {}
	self.german_flamer.weapon.ak47.aim_delay = {
		0.05,
		0.1,
	}
	self.german_flamer.weapon.ak47.focus_delay = 7
	self.german_flamer.weapon.ak47.focus_dis = 200
	self.german_flamer.weapon.ak47.spread = 15
	self.german_flamer.weapon.ak47.miss_dis = max_range - 100
	self.german_flamer.weapon.ak47.RELOAD_SPEED = 1
	self.german_flamer.weapon.ak47.melee_speed = 1
	self.german_flamer.weapon.ak47.melee_dmg = 2
	self.german_flamer.weapon.ak47.melee_retry_delay = {
		1,
		2,
	}
	self.german_flamer.weapon.ak47.max_range = max_range
	self.german_flamer.weapon.ak47.additional_weapon_stats = {
		cooldown_duration = 0.76,
		shooting_duration = 2.5,
	}
	self.german_flamer.weapon.ak47.range = {
		close = 300,
		far = 500,
		optimal = 400,
	}
	self.german_flamer.weapon.ak47.autofire_rounds = {
		25,
		50,
	}
	self.german_flamer.weapon.ak47.FALLOFF = {
		{
			acc = {
				1,
				1,
			},
			dmg_mul = 2,
			mode = {
				0,
				2,
				4,
				10,
			},
			r = 400,
			recoil = {
				0,
				0,
			},
		},
		{
			acc = {
				1,
				1,
			},
			dmg_mul = 0.5,
			mode = {
				0,
				2,
				4,
				10,
			},
			r = 1000,
			recoil = {
				0,
				0,
			},
		},
		{
			acc = {
				1,
				1,
			},
			dmg_mul = 0.25,
			mode = {
				0,
				2,
				4,
				10,
			},
			r = max_range,
			recoil = {
				0,
				0,
			},
		},
	}
	self.german_flamer.weapon.ak47.SUPPRESSION_ACC_CHANCE = 1

	self:_process_weapon_usage_table(self.german_flamer.weapon)

	self.german_flamer.throwable = {
		cooldown = 30,
		projectile_id = "flamer_incendiary",
		throw_chance = 0.15,
	}
	self.german_flamer.speech_prefix_p1 = "ger"
	self.german_flamer.speech_prefix_p2 = "flamer"
	self.german_flamer.speech_prefix_count = 4
	self.german_flamer.access = "tank"
	self.german_flamer.chatter = presets.enemy_chatter.special
	self.german_flamer.announce_incomming = "incomming_flamer"
	self.german_flamer.steal_loot = nil
	self.german_flamer.use_animation_on_fire_damage = false
	self.german_flamer.type = CharacterTweakData.ENEMY_TYPE_FLAMER
	self.german_flamer.dismemberment_enabled = false
	self.german_flamer.is_special = true
	self.german_flamer.special_type = CharacterTweakData.SPECIAL_UNIT_TYPE_FLAMER
	self.german_flamer.dont_modify_weapon_usage = true
end

function CharacterTweakData:_init_german_sniper(presets)
	self.german_sniper = deep_clone(presets.base)
	self.german_sniper.experience = {}
	self.german_sniper.detection = presets.detection.sniper
	self.german_sniper.vision = presets.vision.easy
	self.german_sniper.HEALTH_INIT = 80
	self.german_sniper.BASE_HEALTH_INIT = 80
	self.german_sniper.headshot_dmg_mul = 4
	self.german_sniper.allowed_stances = {
		cbt = true,
	}
	self.german_sniper.move_speed = presets.move_speed.normal
	self.german_sniper.suppression = presets.suppression.easy
	self.german_sniper.loot_table = "normal_enemy"
	self.german_sniper.ecm_vulnerability = 0
	self.german_sniper.ecm_hurts = {
		ears = {
			max_duration = 9,
			min_duration = 7,
		},
	}
	self.german_sniper.priority_shout = "shout_loud_sniper"
	self.german_sniper.priority_waypoint = "waypoint_special_mark_sniper"
	self.german_sniper.deathguard = false
	self.german_sniper.no_equip_anim = true
	self.german_sniper.wall_fwd_offset = 100
	self.german_sniper.damage.explosion_damage_mul = 1
	self.german_sniper.calls_in = nil
	self.german_sniper.allowed_poses = {
		stand = true,
	}
	self.german_sniper.always_face_enemy = true
	self.german_sniper.crouch_move = true
	self.german_sniper.use_animation_on_fire_damage = true
	self.german_sniper.flammable = true
	self.german_sniper.weapon = presets.weapon.sniper

	self:_process_weapon_usage_table(self.german_sniper.weapon)

	self.german_sniper.dont_modify_weapon_usage = true
	self.german_sniper.speech_prefix_p1 = "ger"
	self.german_sniper.speech_prefix_p2 = "elite"
	self.german_sniper.speech_prefix_count = 4
	self.german_sniper.access = "sniper"
	self.german_sniper.chatter = presets.enemy_chatter.no_chatter
	self.german_sniper.announce_incomming = "incomming_sniper"
	self.german_sniper.dodge = presets.dodge.athletic
	self.german_sniper.steal_loot = nil
	self.german_sniper.use_animation_on_fire_damage = false
	self.german_sniper.type = CharacterTweakData.ENEMY_TYPE_ELITE
	self.german_sniper.dismemberment_enabled = false
	self.german_sniper.is_special = true
	self.german_sniper.special_type = CharacterTweakData.SPECIAL_UNIT_TYPE_SNIPER
	self.german_sniper.damage.hurt_severity = deep_clone(presets.hurt_severities.base)
	self.german_sniper.damage.hurt_severity.bullet = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.01,
				none = 1,
			},
			{
				health_limit = 0.3,
				heavy = 0,
				light = 0,
				moderate = 0,
				none = 1,
			},
			{
				health_limit = 0.6,
				heavy = 0,
				light = 0,
				moderate = 0,
				none = 1,
			},
			{
				health_limit = 0.9,
				heavy = 0,
				light = 0,
				moderate = 0,
				none = 1,
			},
			{
				heavy = 0,
				light = 0,
				moderate = 0,
				none = 1,
			},
		},
	}
	self.german_sniper.loadout = self.npc_loadouts.special_sniper

	table.insert(self._enemies_list, "german_sniper")
end

function CharacterTweakData:_init_german_spotter(presets)
	self.german_spotter = deep_clone(presets.base)
	self.german_spotter.experience = {}
	self.german_spotter.weapon = presets.weapon.expert
	self.german_spotter.detection = presets.detection.normal
	self.german_spotter.vision = presets.vision.spotter
	self.german_spotter.HEALTH_INIT = 80
	self.german_spotter.BASE_HEALTH_INIT = 80
	self.german_spotter.headshot_dmg_mul = 4
	self.german_spotter.move_speed = presets.move_speed.slow
	self.german_spotter.crouch_move = false
	self.german_spotter.suppression = presets.suppression.hard_agg
	self.german_spotter.ecm_vulnerability = 1
	self.german_spotter.ecm_hurts = {
		ears = {
			max_duration = 10,
			min_duration = 8,
		},
	}
	self.german_spotter.speech_prefix_p1 = "ger"
	self.german_spotter.speech_prefix_p2 = "elite"
	self.german_spotter.speech_prefix_count = 4
	self.german_spotter.access = "sniper"
	self.german_spotter.silent_priority_shout = "f37"
	self.german_spotter.priority_shout = "shout_loud_spotter"
	self.german_spotter.priority_waypoint = "waypoint_special_mark_spotter"
	self.german_spotter.dodge = presets.dodge.poor
	self.german_spotter.deathguard = false
	self.german_spotter.chatter = presets.enemy_chatter.special
	self.german_spotter.steal_loot = false
	self.german_spotter.loot_table = "normal_enemy"
	self.german_spotter.type = CharacterTweakData.ENEMY_TYPE_ELITE
	self.german_spotter.damage.hurt_severity = deep_clone(presets.hurt_severities.base)
	self.german_spotter.damage.hurt_severity.bullet = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.01,
				none = 1,
			},
			{
				health_limit = 0.3,
				heavy = 0,
				light = 0,
				moderate = 0,
				none = 1,
			},
			{
				health_limit = 0.6,
				heavy = 0,
				light = 0,
				moderate = 0,
				none = 1,
			},
			{
				health_limit = 0.9,
				heavy = 0,
				light = 0,
				moderate = 0,
				none = 1,
			},
			{
				heavy = 0,
				light = 0,
				moderate = 0,
				none = 1,
			},
		},
	}
	self.german_spotter.loadout = self.npc_loadouts.special_spotter
	self.german_spotter.dismemberment_enabled = false
	self.german_spotter.is_special = true
	self.german_spotter.special_type = CharacterTweakData.SPECIAL_UNIT_TYPE_SPOTTER
	self.german_spotter.dont_modify_weapon_usage = true

	table.insert(self._enemies_list, "german_spotter")
end

function CharacterTweakData:_init_escort(presets)
	self.escort = deep_clone(self.civilian)
	self.escort.HEALTH_INIT = 5
	self.escort.is_escort = true
	self.escort.escort_idle_talk = true
	self.escort.outline_on_discover = true
	self.escort.calls_in = nil
	self.escort.escort_safe_dist = 800
	self.escort.escort_scared_dist = 220
	self.escort.intimidateable = false
	self.escort.damage = presets.base.damage
end

function CharacterTweakData:_init_upd_fb(presets)
	self.fb_german_commander = deep_clone(self.german_commander)
	self.fb_german_commander.move_speed = presets.move_speed.very_fast
	self.fb_german_commander.dodge = presets.dodge.poor
	self.fb_german_commander.allowed_poses = {
		stand = true,
	}
	self.fb_german_commander.speech_prefix_p1 = "ger"
	self.fb_german_commander.speech_prefix_p2 = "fb_commander"
	self.fb_german_commander.speech_prefix_count = 1
	self.fb_german_commander.chatter = presets.enemy_chatter.no_chatter
	self.fb_german_commander.crouch_move = false
	self.fb_german_commander.gear = nil
	self.fb_german_commander.silent_priority_shout = nil
	self.fb_german_commander.priority_shout = nil
	self.fb_german_commander_boss = deep_clone(self.fb_german_commander)
	self.fb_german_commander_boss.HEALTH_INIT = 2500
	self.fb_german_commander_boss.BASE_HEALTH_INIT = 2500
	self.fb_german_commander_boss.headshot_dmg_mul = 0.8
	self.fb_german_commander_boss.headshot_helmet = true
	self.fb_german_commander_boss.damage.hurt_severity = deep_clone(presets.hurt_severities.no_hurts)
	self.fb_german_commander_boss.damage.hurt_severity.explosion = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.3,
				none = 1,
			},
			{
				explode = 0.1,
				health_limit = 0.7,
				none = 0.7,
			},
			{
				explode = 0.5,
				none = 0.5,
			},
		},
	}
	self.fb_german_commander_boss.gear = self.german_commander.gear

	table.insert(self._enemies_list, "fb_german_commander_boss")
end

function CharacterTweakData:_presets(tweak_data)
	local presets = {}

	presets.hurt_severities = {}
	presets.hurt_severities.no_hurts = {
		bullet = {
			health_reference = 1,
			zones = {
				{
					none = 1,
				},
			},
		},
		explosion = {
			health_reference = 1,
			zones = {
				{
					none = 1,
				},
			},
		},
		fire = {
			health_reference = 1,
			zones = {
				{
					none = 1,
				},
			},
		},
		melee = {
			health_reference = 1,
			zones = {
				{
					none = 1,
				},
			},
		},
		poison = {
			health_reference = 1,
			zones = {
				{
					none = 1,
				},
			},
		},
	}
	presets.hurt_severities.only_explosion_hurts = deep_clone(presets.hurt_severities.no_hurts)
	presets.hurt_severities.only_explosion_hurts.explosion = {
		health_reference = 1,
		zones = {
			{
				explode = 1,
			},
		},
	}
	presets.hurt_severities.base = {
		bullet = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.01,
					none = 1,
				},
				{
					health_limit = 0.3,
					heavy = 0.05,
					light = 0.7,
					moderate = 0.05,
					none = 0.2,
				},
				{
					health_limit = 0.6,
					heavy = 0.2,
					light = 0.4,
					moderate = 0.4,
				},
				{
					health_limit = 0.9,
					heavy = 0.6,
					light = 0.2,
					moderate = 0.2,
				},
				{
					heavy = 1,
					light = 0,
					moderate = 0,
				},
			},
		},
		explosion = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.01,
					none = 1,
				},
				{
					health_limit = 0.2,
					heavy = 0.4,
					none = 0.6,
				},
				{
					explode = 0.4,
					health_limit = 0.5,
					heavy = 0.6,
				},
				{
					explode = 0.8,
					heavy = 0.2,
				},
			},
		},
		fire = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.01,
					none = 1,
				},
				{
					fire = 1,
				},
			},
		},
		melee = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.01,
					none = 1,
				},
				{
					health_limit = 0.3,
					heavy = 0,
					light = 0.7,
					moderate = 0,
					none = 0.3,
				},
				{
					health_limit = 0.8,
					heavy = 0,
					light = 1,
					moderate = 0,
				},
				{
					health_limit = 0.9,
					heavy = 0.2,
					light = 0.6,
					moderate = 0.2,
				},
				{
					heavy = 9,
					light = 0,
					moderate = 0,
				},
			},
		},
		poison = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.01,
					none = 1,
				},
				{
					none = 0,
					poison = 1,
				},
			},
		},
	}
	presets.base = {}
	presets.base.HEALTH_INIT = 2.5
	presets.base.headshot_dmg_mul = 1
	presets.base.SPEED_WALK = {
		cbt = 160,
		hos = 180,
		ntl = 120,
		pnc = 160,
	}
	presets.base.SPEED_RUN = 370
	presets.base.crouch_move = true
	presets.base.shooting_death = true
	presets.base.suspicious = true
	presets.base.submission_max = {
		45,
		60,
	}
	presets.base.submission_intimidate = 15
	presets.base.speech_prefix = "po"
	presets.base.speech_prefix_count = 1
	presets.base.use_radio = nil
	presets.base.dodge = nil
	presets.base.challenges = {
		type = "law",
	}
	presets.base.calls_in = true
	presets.base.dead_body_drop_sound = "body_fall"
	presets.base.shout_radius = 260
	presets.base.shout_radius_difficulty = {
		200,
		500,
		1000,
		1200,
	}
	presets.base.kill_shout_chance = 0
	presets.base.experience = {}
	presets.base.critical_hits = {}
	presets.base.critical_hits.damage_mul = 1.5
	presets.base.damage = {}
	presets.base.damage.hurt_severity = presets.hurt_severities.base
	presets.base.damage.death_severity = 0.75
	presets.base.damage.explosion_damage_mul = 1
	presets.base.dismemberment_enabled = true
	presets.gang_member_damage = {
		DISTANCE_IS_AWAY = 1000000,
		DOWNED_TIME = tweak_data.player.damage.DOWNED_TIME,
		HEALTH_INIT = 100,
		MIN_DAMAGE_INTERVAL = 0.25,
		REGENERATE_RATIO = 0.09,
		REGENERATE_TIME = 1,
		REGENERATE_TIME_AWAY = 2,
		TASED_TIME = tweak_data.player.damage.TASED_TIME,
		explosion_damage_mul = 0.8,
		fire_damage_mul = 0.6,
		hurt_severity = presets.hurt_severities.only_explosion_hurts,
		reviving_damage_mul = 0.75,
	}

	local shotgun_aim_delay = {
		2,
		4,
	}
	local rifle_aim_delay = {
		1.5,
		3,
	}
	local smg_aim_delay = {
		0.5,
		1,
	}
	local pistol_aim_delay = {
		0.1,
		0.3,
	}

	presets.weapon = {}
	presets.weapon.normal = {
		ger_geco_npc = {},
		ger_kar98_npc = {},
		ger_luger_npc = {},
		ger_mp38_npc = {},
		ger_stg44_npc = {},
		usa_garand_npc = {},
		usa_m1911_npc = {},
		usa_thomspon_npc = {},
	}
	presets.weapon.normal.usa_garand_npc.aim_delay = rifle_aim_delay
	presets.weapon.normal.usa_garand_npc.focus_delay = 10
	presets.weapon.normal.usa_garand_npc.focus_dis = 200
	presets.weapon.normal.usa_garand_npc.spread = 20
	presets.weapon.normal.usa_garand_npc.miss_dis = 40
	presets.weapon.normal.usa_garand_npc.RELOAD_SPEED = 0.8
	presets.weapon.normal.usa_garand_npc.melee_speed = 1
	presets.weapon.normal.usa_garand_npc.melee_dmg = 2
	presets.weapon.normal.usa_garand_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.normal.usa_garand_npc.range = {
		close = 1000,
		far = 5000,
		optimal = 3500,
	}
	presets.weapon.normal.usa_garand_npc.autofire_rounds = {
		3,
		6,
	}
	presets.weapon.normal.usa_garand_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 100,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.4,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.2,
				0.8,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.2,
				0.5,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.4,
				1.2,
			},
		},
		{
			acc = {
				0.01,
				0.35,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				1.5,
				3,
			},
		},
	}
	presets.weapon.normal.usa_m1911_npc.aim_delay = pistol_aim_delay
	presets.weapon.normal.usa_m1911_npc.focus_delay = 10
	presets.weapon.normal.usa_m1911_npc.focus_dis = 200
	presets.weapon.normal.usa_m1911_npc.spread = 20
	presets.weapon.normal.usa_m1911_npc.miss_dis = 50
	presets.weapon.normal.usa_m1911_npc.RELOAD_SPEED = 0.8
	presets.weapon.normal.usa_m1911_npc.melee_speed = 1
	presets.weapon.normal.usa_m1911_npc.melee_dmg = 2
	presets.weapon.normal.usa_m1911_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.normal.usa_m1911_npc.range = {
		close = 1000,
		far = 5000,
		optimal = 3500,
	}
	presets.weapon.normal.usa_m1911_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 100,
			recoil = {
				0.15,
				0.25,
			},
		},
		{
			acc = {
				0.4,
				0.85,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 500,
			recoil = {
				0.15,
				0.25,
			},
		},
		{
			acc = {
				0.375,
				0.55,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				0.15,
				0.3,
			},
		},
		{
			acc = {
				0.25,
				0.45,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.3,
				0.7,
			},
		},
		{
			acc = {
				0.01,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				0.4,
				1,
			},
		},
	}
	presets.weapon.normal.usa_thomspon_npc.aim_delay = smg_aim_delay
	presets.weapon.normal.usa_thomspon_npc.focus_delay = 10
	presets.weapon.normal.usa_thomspon_npc.focus_dis = 200
	presets.weapon.normal.usa_thomspon_npc.spread = 15
	presets.weapon.normal.usa_thomspon_npc.miss_dis = 20
	presets.weapon.normal.usa_thomspon_npc.RELOAD_SPEED = 0.8
	presets.weapon.normal.usa_thomspon_npc.melee_speed = 1
	presets.weapon.normal.usa_thomspon_npc.melee_dmg = 2
	presets.weapon.normal.usa_thomspon_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.normal.usa_thomspon_npc.range = {
		close = 1000,
		far = 5000,
		optimal = 3500,
	}
	presets.weapon.normal.usa_thomspon_npc.autofire_rounds = {
		3,
		6,
	}
	presets.weapon.normal.usa_thomspon_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 1,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 100,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.4,
				0.9,
			},
			dmg_mul = 1,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 500,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.2,
				0.8,
			},
			dmg_mul = 1,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 1000,
			recoil = {
				0.3,
				0.4,
			},
		},
		{
			acc = {
				0.1,
				0.45,
			},
			dmg_mul = 1,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 2000,
			recoil = {
				0.3,
				0.4,
			},
		},
		{
			acc = {
				0.1,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				1,
				3,
				2,
				0,
			},
			r = 3000,
			recoil = {
				0.5,
				0.6,
			},
		},
	}
	presets.weapon.normal.ger_kar98_npc.aim_delay = rifle_aim_delay
	presets.weapon.normal.ger_kar98_npc.focus_delay = 2
	presets.weapon.normal.ger_kar98_npc.focus_dis = 200
	presets.weapon.normal.ger_kar98_npc.spread = 20
	presets.weapon.normal.ger_kar98_npc.miss_dis = 40
	presets.weapon.normal.ger_kar98_npc.RELOAD_SPEED = 0.8
	presets.weapon.normal.ger_kar98_npc.melee_speed = 1
	presets.weapon.normal.ger_kar98_npc.melee_dmg = 5
	presets.weapon.normal.ger_kar98_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.normal.ger_kar98_npc.range = {
		close = 2400,
		far = 6000,
		optimal = 3500,
	}
	presets.weapon.normal.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.3,
				0.7,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1600,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.1,
				0.7,
			},
			dmg_mul = 1.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.035,
				0.55,
			},
			dmg_mul = 0.25,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 4000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.035,
				0.25,
			},
			dmg_mul = 0.1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 5000,
			recoil = {
				0.35,
				0.75,
			},
		},
	}
	presets.weapon.normal.ger_luger_npc.aim_delay = pistol_aim_delay
	presets.weapon.normal.ger_luger_npc.focus_delay = 2
	presets.weapon.normal.ger_luger_npc.focus_dis = 200
	presets.weapon.normal.ger_luger_npc.spread = 20
	presets.weapon.normal.ger_luger_npc.miss_dis = 50
	presets.weapon.normal.ger_luger_npc.RELOAD_SPEED = 1
	presets.weapon.normal.ger_luger_npc.melee_speed = 1
	presets.weapon.normal.ger_luger_npc.melee_dmg = 5
	presets.weapon.normal.ger_luger_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.normal.ger_luger_npc.range = {
		close = 600,
		far = 2200,
		optimal = 1200,
	}
	presets.weapon.normal.ger_luger_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.8,
			},
			dmg_mul = 1.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 800,
			recoil = {
				0.65,
				0.75,
			},
		},
		{
			acc = {
				0.2,
				0.7,
			},
			dmg_mul = 0.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1500,
			recoil = {
				0.65,
				0.8,
			},
		},
		{
			acc = {
				0.05,
				0.55,
			},
			dmg_mul = 0.25,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.8,
				1.2,
			},
		},
		{
			acc = {
				0.05,
				0.25,
			},
			dmg_mul = 0,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2500,
			recoil = {
				0.9,
				1.5,
			},
		},
	}
	presets.weapon.normal.ger_mp38_npc.aim_delay = smg_aim_delay
	presets.weapon.normal.ger_mp38_npc.focus_delay = 2
	presets.weapon.normal.ger_mp38_npc.focus_dis = 200
	presets.weapon.normal.ger_mp38_npc.spread = 35
	presets.weapon.normal.ger_mp38_npc.miss_dis = 20
	presets.weapon.normal.ger_mp38_npc.RELOAD_SPEED = 0.8
	presets.weapon.normal.ger_mp38_npc.melee_speed = 1
	presets.weapon.normal.ger_mp38_npc.melee_dmg = 5
	presets.weapon.normal.ger_mp38_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.normal.ger_mp38_npc.range = {
		close = 1000,
		far = 2400,
		optimal = 2200,
	}
	presets.weapon.normal.ger_mp38_npc.autofire_rounds = {
		3,
		6,
	}
	presets.weapon.normal.ger_mp38_npc.FALLOFF = {
		{
			acc = {
				0.4,
				0.7,
			},
			dmg_mul = 1.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 1400,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.2,
				0.7,
			},
			dmg_mul = 0.5,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 2000,
			recoil = {
				0.3,
				0.4,
			},
		},
		{
			acc = {
				0.05,
				0.55,
			},
			dmg_mul = 0.25,
			mode = {
				1,
				3,
				2,
				0,
			},
			r = 2500,
			recoil = {
				0.5,
				0.6,
			},
		},
		{
			acc = {
				0.05,
				0.25,
			},
			dmg_mul = 0,
			mode = {
				1,
				3,
				2,
				0,
			},
			r = 3000,
			recoil = {
				0.5,
				0.6,
			},
		},
	}
	presets.weapon.normal.ger_stg44_npc.aim_delay = rifle_aim_delay
	presets.weapon.normal.ger_stg44_npc.focus_delay = 4
	presets.weapon.normal.ger_stg44_npc.focus_dis = 200
	presets.weapon.normal.ger_stg44_npc.spread = 20
	presets.weapon.normal.ger_stg44_npc.miss_dis = 40
	presets.weapon.normal.ger_stg44_npc.RELOAD_SPEED = 0.8
	presets.weapon.normal.ger_stg44_npc.melee_speed = 1
	presets.weapon.normal.ger_stg44_npc.melee_dmg = 5
	presets.weapon.normal.ger_stg44_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.normal.ger_stg44_npc.range = {
		close = 1200,
		far = 2600,
		optimal = 2400,
	}
	presets.weapon.normal.ger_stg44_npc.autofire_rounds = {
		3,
		6,
	}
	presets.weapon.normal.ger_stg44_npc.FALLOFF = {
		{
			acc = {
				0.4,
				0.7,
			},
			dmg_mul = 1,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 1800,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.2,
				0.7,
			},
			dmg_mul = 0.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 2500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.05,
				0.55,
			},
			dmg_mul = 0.25,
			mode = {
				3,
				1,
				1,
				0,
			},
			r = 3000,
			recoil = {
				1.5,
				3,
			},
		},
		{
			acc = {
				0.05,
				0.25,
			},
			dmg_mul = 0,
			mode = {
				3,
				1,
				1,
				0,
			},
			r = 4000,
			recoil = {
				1.5,
				3,
			},
		},
	}
	presets.weapon.normal.ger_geco_npc.aim_delay = shotgun_aim_delay
	presets.weapon.normal.ger_geco_npc.focus_delay = 4
	presets.weapon.normal.ger_geco_npc.focus_dis = 200
	presets.weapon.normal.ger_geco_npc.spread = 15
	presets.weapon.normal.ger_geco_npc.miss_dis = 20
	presets.weapon.normal.ger_geco_npc.RELOAD_SPEED = 0.8
	presets.weapon.normal.ger_geco_npc.melee_speed = 1
	presets.weapon.normal.ger_geco_npc.melee_dmg = 5
	presets.weapon.normal.ger_geco_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.normal.ger_geco_npc.range = {
		close = 600,
		far = 1000,
		optimal = 800,
	}
	presets.weapon.normal.ger_geco_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.7,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 600,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.2,
				0.7,
			},
			dmg_mul = 0.3,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.05,
				0.55,
			},
			dmg_mul = 0.25,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1200,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.05,
				0.25,
			},
			dmg_mul = 0,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				1.5,
				2,
			},
		},
	}
	presets.weapon.normal.ger_geco_npc.SUPPRESSION_ACC_CHANCE = 0.25
	presets.weapon.good = {
		ger_geco_npc = {},
		ger_kar98_npc = {},
		ger_luger_npc = {},
		ger_mp38_npc = {},
		ger_stg44_npc = {},
		usa_garand_npc = {},
		usa_m1911_npc = {},
		usa_thomspon_npc = {},
	}
	presets.weapon.good.usa_garand_npc.aim_delay = rifle_aim_delay
	presets.weapon.good.usa_garand_npc.focus_delay = 2
	presets.weapon.good.usa_garand_npc.focus_dis = 200
	presets.weapon.good.usa_garand_npc.spread = 20
	presets.weapon.good.usa_garand_npc.miss_dis = 40
	presets.weapon.good.usa_garand_npc.RELOAD_SPEED = 1
	presets.weapon.good.usa_garand_npc.melee_speed = 1
	presets.weapon.good.usa_garand_npc.melee_dmg = 2
	presets.weapon.good.usa_garand_npc.melee_retry_delay = presets.weapon.normal.usa_garand_npc.melee_retry_delay
	presets.weapon.good.usa_garand_npc.range = {
		close = 1000,
		far = 5000,
		optimal = 3500,
	}
	presets.weapon.good.usa_garand_npc.autofire_rounds = presets.weapon.normal.usa_garand_npc.autofire_rounds
	presets.weapon.good.usa_garand_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 100,
			recoil = {
				0.4,
				0.8,
			},
		},
		{
			acc = {
				0.4,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.2,
				0.8,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.2,
				0.5,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.4,
				1.2,
			},
		},
		{
			acc = {
				0.01,
				0.35,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				1.5,
				3,
			},
		},
	}
	presets.weapon.good.usa_m1911_npc.aim_delay = pistol_aim_delay
	presets.weapon.good.usa_m1911_npc.focus_delay = 2
	presets.weapon.good.usa_m1911_npc.focus_dis = 200
	presets.weapon.good.usa_m1911_npc.spread = 20
	presets.weapon.good.usa_m1911_npc.miss_dis = 50
	presets.weapon.good.usa_m1911_npc.RELOAD_SPEED = 1
	presets.weapon.good.usa_m1911_npc.melee_speed = presets.weapon.normal.usa_m1911_npc.melee_speed
	presets.weapon.good.usa_m1911_npc.melee_dmg = presets.weapon.normal.usa_m1911_npc.melee_dmg
	presets.weapon.good.usa_m1911_npc.melee_retry_delay = presets.weapon.normal.usa_m1911_npc.melee_retry_delay
	presets.weapon.good.usa_m1911_npc.range = presets.weapon.normal.usa_m1911_npc.range
	presets.weapon.good.usa_m1911_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 100,
			recoil = {
				0.15,
				0.25,
			},
		},
		{
			acc = {
				0.5,
				0.85,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 500,
			recoil = {
				0.15,
				0.25,
			},
		},
		{
			acc = {
				0.375,
				0.55,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				0.15,
				0.4,
			},
		},
		{
			acc = {
				0.25,
				0.45,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.4,
				0.9,
			},
		},
		{
			acc = {
				0.01,
				0.35,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				0.4,
				1,
			},
		},
	}
	presets.weapon.good.usa_thomspon_npc.aim_delay = smg_aim_delay
	presets.weapon.good.usa_thomspon_npc.focus_delay = 2
	presets.weapon.good.usa_thomspon_npc.focus_dis = 200
	presets.weapon.good.usa_thomspon_npc.spread = 15
	presets.weapon.good.usa_thomspon_npc.miss_dis = 10
	presets.weapon.good.usa_thomspon_npc.RELOAD_SPEED = 1
	presets.weapon.good.usa_thomspon_npc.melee_speed = presets.weapon.normal.usa_thomspon_npc.melee_speed
	presets.weapon.good.usa_thomspon_npc.melee_dmg = 5
	presets.weapon.good.usa_thomspon_npc.melee_retry_delay = presets.weapon.normal.usa_thomspon_npc.melee_retry_delay
	presets.weapon.good.usa_thomspon_npc.range = presets.weapon.normal.usa_thomspon_npc.range
	presets.weapon.good.usa_thomspon_npc.autofire_rounds = presets.weapon.normal.usa_thomspon_npc.autofire_rounds
	presets.weapon.good.usa_thomspon_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 100,
			recoil = {
				0.1,
				0.25,
			},
		},
		{
			acc = {
				0.4,
				0.95,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 500,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.2,
				0.75,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 1000,
			recoil = {
				0.35,
				0.5,
			},
		},
		{
			acc = {
				0.1,
				0.45,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 2000,
			recoil = {
				0.35,
				0.6,
			},
		},
		{
			acc = {
				0.1,
				0.35,
			},
			dmg_mul = 2,
			mode = {
				1,
				3,
				2,
				0,
			},
			r = 3000,
			recoil = {
				0.5,
				0.6,
			},
		},
	}
	presets.weapon.good.ger_kar98_npc.aim_delay = rifle_aim_delay
	presets.weapon.good.ger_kar98_npc.focus_delay = 3
	presets.weapon.good.ger_kar98_npc.focus_dis = 200
	presets.weapon.good.ger_kar98_npc.spread = 20
	presets.weapon.good.ger_kar98_npc.miss_dis = 40
	presets.weapon.good.ger_kar98_npc.RELOAD_SPEED = 1
	presets.weapon.good.ger_kar98_npc.melee_speed = 1
	presets.weapon.good.ger_kar98_npc.melee_dmg = 5
	presets.weapon.good.ger_kar98_npc.melee_retry_delay = presets.weapon.normal.ger_kar98_npc.melee_retry_delay
	presets.weapon.good.ger_kar98_npc.range = {
		close = 2400,
		far = 4500,
		optimal = 3500,
	}
	presets.weapon.good.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1600,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.35,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2300,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.1,
				0.65,
			},
			dmg_mul = 0.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.035,
				0.35,
			},
			dmg_mul = 0,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 4000,
			recoil = {
				0.35,
				0.75,
			},
		},
	}
	presets.weapon.good.ger_luger_npc.aim_delay = pistol_aim_delay
	presets.weapon.good.ger_luger_npc.focus_delay = 3
	presets.weapon.good.ger_luger_npc.focus_dis = 200
	presets.weapon.good.ger_luger_npc.spread = 20
	presets.weapon.good.ger_luger_npc.miss_dis = 50
	presets.weapon.good.ger_luger_npc.RELOAD_SPEED = 1.2
	presets.weapon.good.ger_luger_npc.melee_speed = presets.weapon.normal.ger_luger_npc.melee_speed
	presets.weapon.good.ger_luger_npc.melee_dmg = 5
	presets.weapon.good.ger_luger_npc.melee_retry_delay = presets.weapon.normal.ger_luger_npc.melee_retry_delay
	presets.weapon.good.ger_luger_npc.range = {
		close = 600,
		far = 2200,
		optimal = 1200,
	}
	presets.weapon.good.ger_luger_npc.FALLOFF = {
		{
			acc = {
				0.8,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 800,
			recoil = {
				0.45,
				0.5,
			},
		},
		{
			acc = {
				0.4,
				0.9,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1500,
			recoil = {
				0.45,
				0.65,
			},
		},
		{
			acc = {
				0.15,
				0.65,
			},
			dmg_mul = 0.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.55,
				0.95,
			},
		},
		{
			acc = {
				0.05,
				0.35,
			},
			dmg_mul = 0,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2500,
			recoil = {
				0.65,
				1.25,
			},
		},
	}
	presets.weapon.good.ger_mp38_npc.aim_delay = smg_aim_delay
	presets.weapon.good.ger_mp38_npc.focus_delay = 3
	presets.weapon.good.ger_mp38_npc.focus_dis = 200
	presets.weapon.good.ger_mp38_npc.spread = 15
	presets.weapon.good.ger_mp38_npc.miss_dis = 10
	presets.weapon.good.ger_mp38_npc.RELOAD_SPEED = 1
	presets.weapon.good.ger_mp38_npc.melee_speed = presets.weapon.normal.ger_mp38_npc.melee_speed
	presets.weapon.good.ger_mp38_npc.melee_dmg = 5
	presets.weapon.good.ger_mp38_npc.melee_retry_delay = presets.weapon.normal.ger_mp38_npc.melee_retry_delay
	presets.weapon.good.ger_mp38_npc.range = {
		close = 1000,
		far = 2500,
		optimal = 2200,
	}
	presets.weapon.good.ger_mp38_npc.autofire_rounds = presets.weapon.normal.ger_mp38_npc.autofire_rounds
	presets.weapon.good.ger_mp38_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 1400,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.4,
				0.9,
			},
			dmg_mul = 1,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 2000,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.15,
				0.65,
			},
			dmg_mul = 0.5,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 2500,
			recoil = {
				0.3,
				0.4,
			},
		},
		{
			acc = {
				0.05,
				0.35,
			},
			dmg_mul = 0,
			mode = {
				1,
				3,
				2,
				0,
			},
			r = 3500,
			recoil = {
				0.5,
				0.6,
			},
		},
	}
	presets.weapon.good.ger_stg44_npc.aim_delay = rifle_aim_delay
	presets.weapon.good.ger_stg44_npc.focus_delay = 3
	presets.weapon.good.ger_stg44_npc.focus_dis = 200
	presets.weapon.good.ger_stg44_npc.spread = 20
	presets.weapon.good.ger_stg44_npc.miss_dis = 40
	presets.weapon.good.ger_stg44_npc.RELOAD_SPEED = 1
	presets.weapon.good.ger_stg44_npc.melee_speed = 1
	presets.weapon.good.ger_stg44_npc.melee_dmg = 5
	presets.weapon.good.ger_stg44_npc.melee_retry_delay = presets.weapon.normal.ger_stg44_npc.melee_retry_delay
	presets.weapon.good.ger_stg44_npc.range = {
		close = 1200,
		far = 2600,
		optimal = 2400,
	}
	presets.weapon.good.ger_stg44_npc.autofire_rounds = presets.weapon.normal.ger_stg44_npc.autofire_rounds
	presets.weapon.good.ger_stg44_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 1800,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.4,
				0.9,
			},
			dmg_mul = 1,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 2500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.15,
				0.65,
			},
			dmg_mul = 0.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 3000,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.05,
				0.35,
			},
			dmg_mul = 0,
			mode = {
				3,
				1,
				1,
				0,
			},
			r = 3500,
			recoil = {
				1.5,
				3,
			},
		},
	}
	presets.weapon.good.ger_geco_npc.aim_delay = shotgun_aim_delay
	presets.weapon.good.ger_geco_npc.focus_delay = 3
	presets.weapon.good.ger_geco_npc.focus_dis = 200
	presets.weapon.good.ger_geco_npc.spread = 15
	presets.weapon.good.ger_geco_npc.miss_dis = 20
	presets.weapon.good.ger_geco_npc.RELOAD_SPEED = 1
	presets.weapon.good.ger_geco_npc.melee_speed = 1
	presets.weapon.good.ger_geco_npc.melee_dmg = 5
	presets.weapon.good.ger_geco_npc.melee_retry_delay = presets.weapon.normal.ger_geco_npc.melee_retry_delay
	presets.weapon.good.ger_geco_npc.range = {
		close = 600,
		far = 2000,
		optimal = 1200,
	}
	presets.weapon.good.ger_geco_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 600,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.4,
				0.9,
			},
			dmg_mul = 0.7,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.15,
				0.65,
			},
			dmg_mul = 0.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1500,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.05,
				0.25,
			},
			dmg_mul = 0,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				1.5,
				2,
			},
		},
	}
	presets.weapon.good.ger_geco_npc.SUPPRESSION_ACC_CHANCE = 0.3
	presets.weapon.expert = {
		ger_geco_npc = {},
		ger_kar98_npc = {},
		ger_luger_npc = {},
		ger_mp38_npc = {},
		ger_stg44_npc = {},
		usa_garand_npc = {},
		usa_m1911_npc = {},
		usa_thomspon_npc = {},
	}
	presets.weapon.expert.usa_garand_npc.aim_delay = rifle_aim_delay
	presets.weapon.expert.usa_garand_npc.focus_delay = 2
	presets.weapon.expert.usa_garand_npc.focus_dis = 200
	presets.weapon.expert.usa_garand_npc.spread = 20
	presets.weapon.expert.usa_garand_npc.miss_dis = 40
	presets.weapon.expert.usa_garand_npc.RELOAD_SPEED = 1.4
	presets.weapon.expert.usa_garand_npc.melee_speed = 1
	presets.weapon.expert.usa_garand_npc.melee_dmg = 2
	presets.weapon.expert.usa_garand_npc.melee_retry_delay = presets.weapon.normal.usa_garand_npc.melee_retry_delay
	presets.weapon.expert.usa_garand_npc.range = {
		close = 1000,
		far = 5000,
		optimal = 3500,
	}
	presets.weapon.expert.usa_garand_npc.autofire_rounds = presets.weapon.normal.usa_garand_npc.autofire_rounds
	presets.weapon.expert.usa_garand_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 100,
			recoil = {
				0.4,
				0.8,
			},
		},
		{
			acc = {
				0.55,
				0.95,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.525,
				0.8,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.5,
				0.7,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.4,
				1.2,
			},
		},
		{
			acc = {
				0.2,
				0.4,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				1.5,
				3,
			},
		},
	}
	presets.weapon.expert.usa_m1911_npc.aim_delay = pistol_aim_delay
	presets.weapon.expert.usa_m1911_npc.focus_delay = 2
	presets.weapon.expert.usa_m1911_npc.focus_dis = 200
	presets.weapon.expert.usa_m1911_npc.spread = 20
	presets.weapon.expert.usa_m1911_npc.miss_dis = 50
	presets.weapon.expert.usa_m1911_npc.RELOAD_SPEED = 1.4
	presets.weapon.expert.usa_m1911_npc.melee_speed = presets.weapon.normal.usa_m1911_npc.melee_speed
	presets.weapon.expert.usa_m1911_npc.melee_dmg = 2
	presets.weapon.expert.usa_m1911_npc.melee_retry_delay = presets.weapon.normal.usa_m1911_npc.melee_retry_delay
	presets.weapon.expert.usa_m1911_npc.range = presets.weapon.normal.usa_m1911_npc.range
	presets.weapon.expert.usa_m1911_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 100,
			recoil = {
				0.15,
				0.25,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				1,
				0,
			},
			r = 500,
			recoil = {
				0.15,
				0.3,
			},
		},
		{
			acc = {
				0.4,
				0.65,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				1,
				0,
			},
			r = 1000,
			recoil = {
				0.15,
				0.3,
			},
		},
		{
			acc = {
				0.3,
				0.5,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.4,
				0.9,
			},
		},
		{
			acc = {
				0.1,
				0.25,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				0.4,
				1.4,
			},
		},
	}
	presets.weapon.expert.usa_thomspon_npc.aim_delay = smg_aim_delay
	presets.weapon.expert.usa_thomspon_npc.focus_delay = 2
	presets.weapon.expert.usa_thomspon_npc.focus_dis = 200
	presets.weapon.expert.usa_thomspon_npc.spread = 15
	presets.weapon.expert.usa_thomspon_npc.miss_dis = 10
	presets.weapon.expert.usa_thomspon_npc.RELOAD_SPEED = 1.4
	presets.weapon.expert.usa_thomspon_npc.melee_speed = presets.weapon.normal.usa_thomspon_npc.melee_speed
	presets.weapon.expert.usa_thomspon_npc.melee_dmg = 10
	presets.weapon.expert.usa_thomspon_npc.melee_retry_delay = presets.weapon.normal.usa_thomspon_npc.melee_retry_delay
	presets.weapon.expert.usa_thomspon_npc.range = presets.weapon.normal.usa_thomspon_npc.range
	presets.weapon.expert.usa_thomspon_npc.autofire_rounds = presets.weapon.normal.usa_thomspon_npc.autofire_rounds
	presets.weapon.expert.usa_thomspon_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.95,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 100,
			recoil = {
				0.1,
				0.25,
			},
		},
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 500,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.4,
				0.65,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 1000,
			recoil = {
				0.35,
				0.5,
			},
		},
		{
			acc = {
				0.4,
				0.6,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 2000,
			recoil = {
				0.35,
				0.7,
			},
		},
		{
			acc = {
				0.2,
				0.35,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				3,
				2,
				0,
			},
			r = 3000,
			recoil = {
				0.5,
				1.5,
			},
		},
	}
	presets.weapon.expert.ger_kar98_npc.aim_delay = rifle_aim_delay
	presets.weapon.expert.ger_kar98_npc.focus_delay = 2
	presets.weapon.expert.ger_kar98_npc.focus_dis = 200
	presets.weapon.expert.ger_kar98_npc.spread = 20
	presets.weapon.expert.ger_kar98_npc.miss_dis = 40
	presets.weapon.expert.ger_kar98_npc.RELOAD_SPEED = 1.1
	presets.weapon.expert.ger_kar98_npc.melee_speed = 1
	presets.weapon.expert.ger_kar98_npc.melee_dmg = 10
	presets.weapon.expert.ger_kar98_npc.melee_retry_delay = presets.weapon.normal.ger_kar98_npc.melee_retry_delay
	presets.weapon.expert.ger_kar98_npc.range = {
		close = 1400,
		far = 3000,
		optimal = 2600,
	}
	presets.weapon.expert.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 4,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1600,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.4,
				0.9,
			},
			dmg_mul = 3,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2300,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.1,
				0.65,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.035,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3500,
			recoil = {
				0.35,
				0.75,
			},
		},
	}
	presets.weapon.expert.ger_luger_npc.aim_delay = pistol_aim_delay
	presets.weapon.expert.ger_luger_npc.focus_delay = 2
	presets.weapon.expert.ger_luger_npc.focus_dis = 200
	presets.weapon.expert.ger_luger_npc.spread = 20
	presets.weapon.expert.ger_luger_npc.miss_dis = 50
	presets.weapon.expert.ger_luger_npc.RELOAD_SPEED = 1.3
	presets.weapon.expert.ger_luger_npc.melee_speed = presets.weapon.normal.ger_luger_npc.melee_speed
	presets.weapon.expert.ger_luger_npc.melee_dmg = 10
	presets.weapon.expert.ger_luger_npc.melee_retry_delay = presets.weapon.normal.ger_luger_npc.melee_retry_delay
	presets.weapon.expert.ger_luger_npc.range = {
		close = 600,
		far = 2200,
		optimal = 1200,
	}
	presets.weapon.expert.ger_luger_npc.FALLOFF = {
		{
			acc = {
				0.8,
				0.9,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 800,
			recoil = {
				0.35,
				0.4,
			},
		},
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 3,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1500,
			recoil = {
				0.35,
				0.55,
			},
		},
		{
			acc = {
				0.15,
				0.65,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.45,
				0.85,
			},
		},
		{
			acc = {
				0.05,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2500,
			recoil = {
				0.55,
				1.15,
			},
		},
	}
	presets.weapon.expert.ger_mp38_npc.aim_delay = smg_aim_delay
	presets.weapon.expert.ger_mp38_npc.focus_delay = 2
	presets.weapon.expert.ger_mp38_npc.focus_dis = 200
	presets.weapon.expert.ger_mp38_npc.spread = 15
	presets.weapon.expert.ger_mp38_npc.miss_dis = 10
	presets.weapon.expert.ger_mp38_npc.RELOAD_SPEED = 1.1
	presets.weapon.expert.ger_mp38_npc.melee_speed = presets.weapon.normal.ger_mp38_npc.melee_speed
	presets.weapon.expert.ger_mp38_npc.melee_dmg = 10
	presets.weapon.expert.ger_mp38_npc.melee_retry_delay = presets.weapon.normal.ger_mp38_npc.melee_retry_delay
	presets.weapon.expert.ger_mp38_npc.range = {
		close = 1000,
		far = 1400,
		optimal = 1200,
	}
	presets.weapon.expert.ger_mp38_npc.autofire_rounds = presets.weapon.normal.ger_mp38_npc.autofire_rounds
	presets.weapon.expert.ger_mp38_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 4,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 1400,
			recoil = {
				0.1,
				0.25,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 3,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 2000,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.15,
				0.65,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 2500,
			recoil = {
				0.35,
				0.5,
			},
		},
		{
			acc = {
				0.05,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 3000,
			recoil = {
				0.35,
				0.7,
			},
		},
	}
	presets.weapon.expert.ger_stg44_npc.aim_delay = rifle_aim_delay
	presets.weapon.expert.ger_stg44_npc.focus_delay = 2
	presets.weapon.expert.ger_stg44_npc.focus_dis = 200
	presets.weapon.expert.ger_stg44_npc.spread = 20
	presets.weapon.expert.ger_stg44_npc.miss_dis = 40
	presets.weapon.expert.ger_stg44_npc.RELOAD_SPEED = 1.1
	presets.weapon.expert.ger_stg44_npc.melee_speed = 1
	presets.weapon.expert.ger_stg44_npc.melee_dmg = 10
	presets.weapon.expert.ger_stg44_npc.melee_retry_delay = presets.weapon.normal.ger_stg44_npc.melee_retry_delay
	presets.weapon.expert.ger_stg44_npc.range = {
		close = 1200,
		far = 3200,
		optimal = 2400,
	}
	presets.weapon.expert.ger_stg44_npc.autofire_rounds = presets.weapon.normal.ger_stg44_npc.autofire_rounds
	presets.weapon.expert.ger_stg44_npc.FALLOFF = {
		{
			acc = {
				0.6,
				0.9,
			},
			dmg_mul = 5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 1800,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 3,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 2500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.15,
				0.65,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 3000,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.05,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				3,
				1,
				1,
				0,
			},
			r = 3500,
			recoil = {
				1.5,
				3,
			},
		},
	}
	presets.weapon.expert.ger_geco_npc.aim_delay = shotgun_aim_delay
	presets.weapon.expert.ger_geco_npc.focus_delay = 2
	presets.weapon.expert.ger_geco_npc.focus_dis = 200
	presets.weapon.expert.ger_geco_npc.spread = 15
	presets.weapon.expert.ger_geco_npc.miss_dis = 20
	presets.weapon.expert.ger_geco_npc.RELOAD_SPEED = 1.1
	presets.weapon.expert.ger_geco_npc.melee_speed = 1
	presets.weapon.expert.ger_geco_npc.melee_dmg = 10
	presets.weapon.expert.ger_geco_npc.melee_retry_delay = presets.weapon.normal.ger_geco_npc.melee_retry_delay
	presets.weapon.expert.ger_geco_npc.range = {
		close = 600,
		far = 1000,
		optimal = 900,
	}
	presets.weapon.expert.ger_geco_npc.FALLOFF = {
		{
			acc = {
				0.8,
				0.9,
			},
			dmg_mul = 5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 600,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.15,
				0.65,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1500,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.05,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				1.5,
				2,
			},
		},
	}
	presets.weapon.expert.ger_geco_npc.SUPPRESSION_ACC_CHANCE = 0.35
	presets.weapon.insane = {
		ger_geco_npc = {},
		ger_kar98_npc = {},
		ger_luger_npc = {},
		ger_mp38_npc = {},
		ger_stg44_npc = {},
		usa_garand_npc = {},
		usa_m1911_npc = {},
		usa_thomspon_npc = {},
	}
	presets.weapon.insane.usa_garand_npc.aim_delay = rifle_aim_delay
	presets.weapon.insane.usa_garand_npc.focus_delay = 2
	presets.weapon.insane.usa_garand_npc.focus_dis = 200
	presets.weapon.insane.usa_garand_npc.spread = 20
	presets.weapon.insane.usa_garand_npc.miss_dis = 40
	presets.weapon.insane.usa_garand_npc.RELOAD_SPEED = 1.4
	presets.weapon.insane.usa_garand_npc.melee_speed = 1
	presets.weapon.insane.usa_garand_npc.melee_dmg = 2
	presets.weapon.insane.usa_garand_npc.melee_retry_delay = presets.weapon.normal.usa_garand_npc.melee_retry_delay
	presets.weapon.insane.usa_garand_npc.range = {
		close = 1000,
		far = 5000,
		optimal = 3000,
	}
	presets.weapon.insane.usa_garand_npc.autofire_rounds = presets.weapon.normal.usa_garand_npc.autofire_rounds
	presets.weapon.insane.usa_garand_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 100,
			recoil = {
				0.4,
				0.8,
			},
		},
		{
			acc = {
				0.7,
				0.95,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.5,
				0.8,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.5,
				0.7,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.4,
				1.2,
			},
		},
		{
			acc = {
				0.3,
				0.4,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				1.5,
				3,
			},
		},
	}
	presets.weapon.insane.usa_m1911_npc.aim_delay = pistol_aim_delay
	presets.weapon.insane.usa_m1911_npc.focus_delay = 2
	presets.weapon.insane.usa_m1911_npc.focus_dis = 200
	presets.weapon.insane.usa_m1911_npc.spread = 20
	presets.weapon.insane.usa_m1911_npc.miss_dis = 50
	presets.weapon.insane.usa_m1911_npc.RELOAD_SPEED = 1.4
	presets.weapon.insane.usa_m1911_npc.melee_speed = presets.weapon.normal.usa_m1911_npc.melee_speed
	presets.weapon.insane.usa_m1911_npc.melee_dmg = 2
	presets.weapon.insane.usa_m1911_npc.melee_retry_delay = presets.weapon.normal.usa_m1911_npc.melee_retry_delay
	presets.weapon.insane.usa_m1911_npc.range = presets.weapon.normal.usa_m1911_npc.range
	presets.weapon.insane.usa_m1911_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 100,
			recoil = {
				0.15,
				0.25,
			},
		},
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				1,
				0,
			},
			r = 500,
			recoil = {
				0.15,
				0.3,
			},
		},
		{
			acc = {
				0.5,
				0.65,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				1,
				0,
			},
			r = 1000,
			recoil = {
				0.15,
				0.3,
			},
		},
		{
			acc = {
				0.5,
				0.5,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.4,
				0.9,
			},
		},
		{
			acc = {
				0.3,
				0.25,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				0.4,
				1.4,
			},
		},
	}
	presets.weapon.insane.usa_thomspon_npc.aim_delay = smg_aim_delay
	presets.weapon.insane.usa_thomspon_npc.focus_delay = 2
	presets.weapon.insane.usa_thomspon_npc.focus_dis = 200
	presets.weapon.insane.usa_thomspon_npc.spread = 15
	presets.weapon.insane.usa_thomspon_npc.miss_dis = 10
	presets.weapon.insane.usa_thomspon_npc.RELOAD_SPEED = 1.4
	presets.weapon.insane.usa_thomspon_npc.melee_speed = presets.weapon.normal.usa_thomspon_npc.melee_speed
	presets.weapon.insane.usa_thomspon_npc.melee_dmg = 10
	presets.weapon.insane.usa_thomspon_npc.melee_retry_delay = presets.weapon.normal.usa_thomspon_npc.melee_retry_delay
	presets.weapon.insane.usa_thomspon_npc.range = presets.weapon.normal.usa_thomspon_npc.range
	presets.weapon.insane.usa_thomspon_npc.autofire_rounds = presets.weapon.normal.usa_thomspon_npc.autofire_rounds
	presets.weapon.insane.usa_thomspon_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.95,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 100,
			recoil = {
				0.1,
				0.25,
			},
		},
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 500,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.5,
				0.65,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 1000,
			recoil = {
				0.35,
				0.5,
			},
		},
		{
			acc = {
				0.5,
				0.6,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 2000,
			recoil = {
				0.35,
				0.7,
			},
		},
		{
			acc = {
				0.3,
				0.35,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				3,
				2,
				0,
			},
			r = 3000,
			recoil = {
				0.5,
				1.5,
			},
		},
	}
	presets.weapon.insane.ger_kar98_npc.aim_delay = rifle_aim_delay
	presets.weapon.insane.ger_kar98_npc.focus_delay = 2
	presets.weapon.insane.ger_kar98_npc.focus_dis = 200
	presets.weapon.insane.ger_kar98_npc.spread = 20
	presets.weapon.insane.ger_kar98_npc.miss_dis = 40
	presets.weapon.insane.ger_kar98_npc.RELOAD_SPEED = 1.2
	presets.weapon.insane.ger_kar98_npc.melee_speed = 1
	presets.weapon.insane.ger_kar98_npc.melee_dmg = 10
	presets.weapon.insane.ger_kar98_npc.melee_retry_delay = presets.weapon.normal.ger_kar98_npc.melee_retry_delay
	presets.weapon.insane.ger_kar98_npc.range = {
		close = 1400,
		far = 5000,
		optimal = 3600,
	}
	presets.weapon.insane.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1600,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2300,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.25,
				0.65,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.15,
				0.35,
			},
			dmg_mul = 1.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 3500,
			recoil = {
				0.35,
				0.75,
			},
		},
	}
	presets.weapon.insane.ger_luger_npc.aim_delay = pistol_aim_delay
	presets.weapon.insane.ger_luger_npc.focus_delay = 1
	presets.weapon.insane.ger_luger_npc.focus_dis = 200
	presets.weapon.insane.ger_luger_npc.spread = 20
	presets.weapon.insane.ger_luger_npc.miss_dis = 50
	presets.weapon.insane.ger_luger_npc.RELOAD_SPEED = 1.4
	presets.weapon.insane.ger_luger_npc.melee_speed = presets.weapon.normal.ger_luger_npc.melee_speed
	presets.weapon.insane.ger_luger_npc.melee_dmg = 10
	presets.weapon.insane.ger_luger_npc.melee_retry_delay = presets.weapon.normal.ger_luger_npc.melee_retry_delay
	presets.weapon.insane.ger_luger_npc.range = {
		close = 600,
		far = 1200,
		optimal = 800,
	}
	presets.weapon.insane.ger_luger_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 4,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 800,
			recoil = {
				0.25,
				0.3,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 3,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1500,
			recoil = {
				0.25,
				0.45,
			},
		},
		{
			acc = {
				0.25,
				0.65,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.35,
				0.75,
			},
		},
		{
			acc = {
				0.15,
				0.35,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2500,
			recoil = {
				0.45,
				1.05,
			},
		},
	}
	presets.weapon.insane.ger_mp38_npc.aim_delay = smg_aim_delay
	presets.weapon.insane.ger_mp38_npc.focus_delay = 2
	presets.weapon.insane.ger_mp38_npc.focus_dis = 200
	presets.weapon.insane.ger_mp38_npc.spread = 15
	presets.weapon.insane.ger_mp38_npc.miss_dis = 10
	presets.weapon.insane.ger_mp38_npc.RELOAD_SPEED = 1.2
	presets.weapon.insane.ger_mp38_npc.melee_speed = presets.weapon.normal.ger_mp38_npc.melee_speed
	presets.weapon.insane.ger_mp38_npc.melee_dmg = 10
	presets.weapon.insane.ger_mp38_npc.melee_retry_delay = presets.weapon.normal.ger_mp38_npc.melee_retry_delay
	presets.weapon.insane.ger_mp38_npc.range = {
		close = 1000,
		far = 3400,
		optimal = 2200,
	}
	presets.weapon.insane.ger_mp38_npc.autofire_rounds = presets.weapon.normal.ger_mp38_npc.autofire_rounds
	presets.weapon.insane.ger_mp38_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 4.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 1400,
			recoil = {
				0.1,
				0.25,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 3.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 2000,
			recoil = {
				0.1,
				0.3,
			},
		},
		{
			acc = {
				0.25,
				0.65,
			},
			dmg_mul = 3,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 2500,
			recoil = {
				0.35,
				0.5,
			},
		},
		{
			acc = {
				0.15,
				0.35,
			},
			dmg_mul = 2,
			mode = {
				0,
				3,
				3,
				0,
			},
			r = 3000,
			recoil = {
				0.35,
				0.7,
			},
		},
	}
	presets.weapon.insane.ger_stg44_npc.aim_delay = rifle_aim_delay
	presets.weapon.insane.ger_stg44_npc.focus_delay = 2
	presets.weapon.insane.ger_stg44_npc.focus_dis = 200
	presets.weapon.insane.ger_stg44_npc.spread = 20
	presets.weapon.insane.ger_stg44_npc.miss_dis = 40
	presets.weapon.insane.ger_stg44_npc.RELOAD_SPEED = 1.2
	presets.weapon.insane.ger_stg44_npc.melee_speed = 1
	presets.weapon.insane.ger_stg44_npc.melee_dmg = 10
	presets.weapon.insane.ger_stg44_npc.melee_retry_delay = presets.weapon.normal.ger_stg44_npc.melee_retry_delay
	presets.weapon.insane.ger_stg44_npc.range = {
		close = 1200,
		far = 3600,
		optimal = 2400,
	}
	presets.weapon.insane.ger_stg44_npc.autofire_rounds = presets.weapon.normal.ger_stg44_npc.autofire_rounds
	presets.weapon.insane.ger_stg44_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.9,
			},
			dmg_mul = 4,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 1800,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 3.5,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 2500,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.25,
				0.65,
			},
			dmg_mul = 3,
			mode = {
				0,
				3,
				3,
				1,
			},
			r = 3000,
			recoil = {
				0.45,
				0.8,
			},
		},
		{
			acc = {
				0.15,
				0.35,
			},
			dmg_mul = 2,
			mode = {
				3,
				1,
				1,
				0,
			},
			r = 3500,
			recoil = {
				1.5,
				3,
			},
		},
	}
	presets.weapon.insane.ger_geco_npc.aim_delay = shotgun_aim_delay
	presets.weapon.insane.ger_geco_npc.focus_delay = 2
	presets.weapon.insane.ger_geco_npc.focus_dis = 200
	presets.weapon.insane.ger_geco_npc.spread = 15
	presets.weapon.insane.ger_geco_npc.miss_dis = 20
	presets.weapon.insane.ger_geco_npc.RELOAD_SPEED = 1.2
	presets.weapon.insane.ger_geco_npc.melee_speed = 1
	presets.weapon.insane.ger_geco_npc.melee_dmg = 10
	presets.weapon.insane.ger_geco_npc.melee_retry_delay = presets.weapon.normal.ger_geco_npc.melee_retry_delay
	presets.weapon.insane.ger_geco_npc.range = {
		close = 600,
		far = 1000,
		optimal = 800,
	}
	presets.weapon.insane.ger_geco_npc.FALLOFF = {
		{
			acc = {
				0.9,
				1,
			},
			dmg_mul = 5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 600,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.25,
				0.65,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1500,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.15,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				1.5,
				2,
			},
		},
	}
	presets.weapon.insane.ger_geco_npc.SUPPRESSION_ACC_CHANCE = 0.4
	presets.weapon.sniper = {
		ger_kar98_npc = {},
	}
	presets.weapon.sniper.ger_kar98_npc.aim_delay = {
		5,
		5,
	}
	presets.weapon.sniper.ger_kar98_npc.focus_delay = 2.5
	presets.weapon.sniper.ger_kar98_npc.focus_dis = 15000
	presets.weapon.sniper.ger_kar98_npc.spread = 30
	presets.weapon.sniper.ger_kar98_npc.miss_dis = 250
	presets.weapon.sniper.ger_kar98_npc.RELOAD_SPEED = 1
	presets.weapon.sniper.ger_kar98_npc.melee_speed = presets.weapon.normal.ger_kar98_npc.melee_speed
	presets.weapon.sniper.ger_kar98_npc.melee_dmg = presets.weapon.normal.ger_kar98_npc.melee_dmg
	presets.weapon.sniper.ger_kar98_npc.melee_retry_delay = presets.weapon.normal.ger_kar98_npc.melee_retry_delay
	presets.weapon.sniper.ger_kar98_npc.range = {
		close = 15000,
		far = 80000,
		optimal = 40000,
	}
	presets.weapon.sniper.ger_kar98_npc.use_laser = true
	presets.weapon.sniper.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.8,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				5,
				6,
			},
		},
		{
			acc = {
				0.4,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 15000,
			recoil = {
				8,
				10,
			},
		},
		{
			acc = {
				0.1,
				0.75,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 40000,
			recoil = {
				8,
				10,
			},
		},
		{
			acc = {
				0,
				0.25,
			},
			dmg_mul = 1.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 80000,
			recoil = {
				8,
				10,
			},
		},
	}
	presets.weapon.sniper.ger_kar98_npc.SUPPRESSION_ACC_CHANCE = 0.25
	presets.weapon.gang_member = {
		ger_luger_npc = {},
		ger_mp38_npc = {},
		ger_stg44_npc = {},
		thompson_npc = {},
		usa_garand_npc = {},
		usa_m1911_npc = {},
		usa_m1912_npc = {},
	}
	presets.weapon.gang_member.ger_luger_npc.aim_delay = pistol_aim_delay
	presets.weapon.gang_member.ger_luger_npc.focus_delay = 1
	presets.weapon.gang_member.ger_luger_npc.focus_dis = 2000
	presets.weapon.gang_member.ger_luger_npc.spread = 25
	presets.weapon.gang_member.ger_luger_npc.miss_dis = 20
	presets.weapon.gang_member.ger_luger_npc.RELOAD_SPEED = 1.5
	presets.weapon.gang_member.ger_luger_npc.melee_speed = 3
	presets.weapon.gang_member.ger_luger_npc.melee_dmg = 2
	presets.weapon.gang_member.ger_luger_npc.melee_retry_delay = presets.weapon.normal.ger_luger_npc.melee_retry_delay
	presets.weapon.gang_member.ger_luger_npc.range = presets.weapon.normal.ger_luger_npc.range
	presets.weapon.gang_member.ger_luger_npc.FALLOFF = {
		{
			acc = {
				0.7,
				0.8,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 300,
			recoil = {
				0.25,
				0.45,
			},
		},
		{
			acc = {
				0.1,
				0.6,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.25,
				2,
			},
		},
		{
			acc = {
				0,
				0.15,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 10000,
			recoil = {
				2,
				3,
			},
		},
	}
	presets.weapon.gang_member.ger_mp38_npc.aim_delay = smg_aim_delay
	presets.weapon.gang_member.ger_mp38_npc.focus_delay = 3
	presets.weapon.gang_member.ger_mp38_npc.focus_dis = 3000
	presets.weapon.gang_member.ger_mp38_npc.spread = 25
	presets.weapon.gang_member.ger_mp38_npc.miss_dis = 10
	presets.weapon.gang_member.ger_mp38_npc.RELOAD_SPEED = 1
	presets.weapon.gang_member.ger_mp38_npc.melee_speed = 2
	presets.weapon.gang_member.ger_mp38_npc.melee_dmg = 2
	presets.weapon.gang_member.ger_mp38_npc.melee_retry_delay = presets.weapon.normal.ger_mp38_npc.melee_retry_delay
	presets.weapon.gang_member.ger_mp38_npc.range = {
		close = 1500,
		far = 6000,
		optimal = 2500,
	}
	presets.weapon.gang_member.ger_mp38_npc.autofire_rounds = presets.weapon.normal.ger_mp38_npc.autofire_rounds
	presets.weapon.gang_member.ger_mp38_npc.FALLOFF = {
		{
			acc = {
				0.7,
				1,
			},
			dmg_mul = 3.5,
			mode = {
				0.1,
				0.3,
				4,
				7,
			},
			r = 300,
			recoil = {
				0.25,
				0.45,
			},
		},
		{
			acc = {
				0.1,
				0.6,
			},
			dmg_mul = 0.5,
			mode = {
				2,
				2,
				5,
				8,
			},
			r = 2000,
			recoil = {
				0.25,
				2,
			},
		},
		{
			acc = {
				0,
				0.15,
			},
			dmg_mul = 0.5,
			mode = {
				2,
				1,
				1,
				0.01,
			},
			r = 10000,
			recoil = {
				2,
				3,
			},
		},
	}
	presets.weapon.gang_member.ger_stg44_npc.aim_delay = rifle_aim_delay
	presets.weapon.gang_member.ger_stg44_npc.focus_delay = 1
	presets.weapon.gang_member.ger_stg44_npc.focus_dis = 3000
	presets.weapon.gang_member.ger_stg44_npc.spread = 25
	presets.weapon.gang_member.ger_stg44_npc.miss_dis = 10
	presets.weapon.gang_member.ger_stg44_npc.RELOAD_SPEED = 1
	presets.weapon.gang_member.ger_stg44_npc.melee_speed = 2
	presets.weapon.gang_member.ger_stg44_npc.melee_dmg = 2
	presets.weapon.gang_member.ger_stg44_npc.melee_retry_delay = presets.weapon.normal.ger_stg44_npc.melee_retry_delay
	presets.weapon.gang_member.ger_stg44_npc.range = {
		close = 1500,
		far = 6000,
		optimal = 2500,
	}
	presets.weapon.gang_member.ger_stg44_npc.autofire_rounds = presets.weapon.normal.ger_stg44_npc.autofire_rounds
	presets.weapon.gang_member.ger_stg44_npc.FALLOFF = {
		{
			acc = {
				0.7,
				1,
			},
			dmg_mul = 3.5,
			mode = {
				0.1,
				0.3,
				4,
				7,
			},
			r = 300,
			recoil = {
				0.25,
				0.45,
			},
		},
		{
			acc = {
				0.1,
				0.6,
			},
			dmg_mul = 0.5,
			mode = {
				2,
				2,
				5,
				8,
			},
			r = 2000,
			recoil = {
				0.25,
				2,
			},
		},
		{
			acc = {
				0,
				0.15,
			},
			dmg_mul = 0.5,
			mode = {
				2,
				1,
				1,
				0.01,
			},
			r = 10000,
			recoil = {
				2,
				3,
			},
		},
	}
	presets.weapon.gang_member.usa_garand_npc.aim_delay = rifle_aim_delay
	presets.weapon.gang_member.usa_garand_npc.focus_delay = 0.15
	presets.weapon.gang_member.usa_garand_npc.focus_dis = 3000
	presets.weapon.gang_member.usa_garand_npc.spread = 9
	presets.weapon.gang_member.usa_garand_npc.miss_dis = 0
	presets.weapon.gang_member.usa_garand_npc.RELOAD_SPEED = 1
	presets.weapon.gang_member.usa_garand_npc.melee_speed = 2
	presets.weapon.gang_member.usa_garand_npc.melee_dmg = 2
	presets.weapon.gang_member.usa_garand_npc.melee_retry_delay = presets.weapon.normal.usa_garand_npc.melee_retry_delay
	presets.weapon.gang_member.usa_garand_npc.range = {
		close = 1500,
		far = 8000,
		optimal = 3500,
	}
	presets.weapon.gang_member.usa_garand_npc.autofire_rounds = presets.weapon.normal.usa_garand_npc.autofire_rounds
	presets.weapon.gang_member.usa_garand_npc.FALLOFF = {
		{
			acc = {
				0.9,
				1,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 300,
			recoil = {
				0.15,
				0.25,
			},
		},
		{
			acc = {
				0.9,
				1,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.35,
				0.5,
			},
		},
		{
			acc = {
				0.9,
				1,
			},
			dmg_mul = 0.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 10000,
			recoil = {
				0.6,
				1,
			},
		},
	}
	presets.weapon.gang_member.usa_m1911_npc.aim_delay = pistol_aim_delay
	presets.weapon.gang_member.usa_m1911_npc.focus_delay = 0.25
	presets.weapon.gang_member.usa_m1911_npc.focus_dis = 2000
	presets.weapon.gang_member.usa_m1911_npc.spread = 1
	presets.weapon.gang_member.usa_m1911_npc.miss_dis = 0
	presets.weapon.gang_member.usa_m1911_npc.RELOAD_SPEED = 1.5
	presets.weapon.gang_member.usa_m1911_npc.melee_speed = 3
	presets.weapon.gang_member.usa_m1911_npc.melee_dmg = 2
	presets.weapon.gang_member.usa_m1911_npc.melee_retry_delay = presets.weapon.normal.usa_m1911_npc.melee_retry_delay
	presets.weapon.gang_member.usa_m1911_npc.range = presets.weapon.normal.usa_m1911_npc.range
	presets.weapon.gang_member.usa_m1911_npc.FALLOFF = {
		{
			acc = {
				0.7,
				1,
			},
			dmg_mul = 4,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 300,
			recoil = {
				0.25,
				0.45,
			},
		},
		{
			acc = {
				0.7,
				1,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				0.25,
				2,
			},
		},
		{
			acc = {
				0.7,
				1,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 10000,
			recoil = {
				2,
				3,
			},
		},
	}
	presets.weapon.gang_member.usa_m1912_npc.aim_delay = shotgun_aim_delay
	presets.weapon.gang_member.usa_m1912_npc.focus_delay = 2
	presets.weapon.gang_member.usa_m1912_npc.focus_dis = 200
	presets.weapon.gang_member.usa_m1912_npc.spread = 15
	presets.weapon.gang_member.usa_m1912_npc.miss_dis = 20
	presets.weapon.gang_member.usa_m1912_npc.RELOAD_SPEED = 1.3
	presets.weapon.gang_member.usa_m1912_npc.melee_speed = 1
	presets.weapon.gang_member.usa_m1912_npc.melee_dmg = 2
	presets.weapon.gang_member.usa_m1912_npc.melee_retry_delay = presets.weapon.gang_member.usa_garand_npc.melee_retry_delay
	presets.weapon.gang_member.usa_m1912_npc.range = {
		close = 600,
		far = 1000,
		optimal = 800,
	}
	presets.weapon.gang_member.usa_m1912_npc.FALLOFF = {
		{
			acc = {
				0.9,
				1,
			},
			dmg_mul = 5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 600,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.5,
				0.9,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.25,
				0.65,
			},
			dmg_mul = 2,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1500,
			recoil = {
				1.5,
				2,
			},
		},
		{
			acc = {
				0.15,
				0.35,
			},
			dmg_mul = 1,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 2000,
			recoil = {
				1.5,
				2,
			},
		},
	}
	presets.weapon.gang_member.thompson_npc.aim_delay = smg_aim_delay
	presets.weapon.gang_member.thompson_npc.focus_delay = 0.1
	presets.weapon.gang_member.thompson_npc.focus_dis = 3000
	presets.weapon.gang_member.thompson_npc.spread = 2
	presets.weapon.gang_member.thompson_npc.miss_dis = 0
	presets.weapon.gang_member.thompson_npc.RELOAD_SPEED = 1
	presets.weapon.gang_member.thompson_npc.melee_speed = 2
	presets.weapon.gang_member.thompson_npc.melee_dmg = 2
	presets.weapon.gang_member.thompson_npc.melee_retry_delay = {
		1,
		2,
	}
	presets.weapon.gang_member.thompson_npc.range = {
		close = 1000,
		far = 6000,
		optimal = 2000,
	}
	presets.weapon.gang_member.thompson_npc.autofire_rounds = {
		10,
		20,
	}
	presets.weapon.gang_member.thompson_npc.FALLOFF = {
		{
			acc = {
				0.9,
				1,
			},
			dmg_mul = 1,
			mode = {
				0.1,
				0.3,
				4,
				7,
			},
			r = 300,
			recoil = {
				0.25,
				0.45,
			},
		},
		{
			acc = {
				0.9,
				1,
			},
			dmg_mul = 0.5,
			mode = {
				2,
				2,
				5,
				8,
			},
			r = 2000,
			recoil = {
				0.25,
				1,
			},
		},
		{
			acc = {
				0.9,
				1,
			},
			dmg_mul = 0.25,
			mode = {
				2,
				1,
				1,
				0.01,
			},
			r = 10000,
			recoil = {
				1,
				2,
			},
		},
	}
	presets.vision = {}
	presets.vision.easy = {
		combat = {},
		idle = {},
	}
	presets.vision.easy.idle = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "easy",
	}
	presets.vision.easy.idle.cone_1.angle = 160
	presets.vision.easy.idle.cone_1.distance = 500
	presets.vision.easy.idle.cone_1.speed_mul = 1.75
	presets.vision.easy.idle.cone_2.angle = 50
	presets.vision.easy.idle.cone_2.distance = 1550
	presets.vision.easy.idle.cone_2.speed_mul = 2.2
	presets.vision.easy.idle.cone_3.angle = 110
	presets.vision.easy.idle.cone_3.distance = 3000
	presets.vision.easy.idle.cone_3.speed_mul = 7
	presets.vision.easy.combat = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "easy-cbt",
	}
	presets.vision.easy.combat.detection_delay = 2
	presets.vision.easy.combat.cone_1.angle = 210
	presets.vision.easy.combat.cone_1.distance = 2000
	presets.vision.easy.combat.cone_1.speed_mul = 0.5
	presets.vision.easy.combat.cone_2.angle = 210
	presets.vision.easy.combat.cone_2.distance = 2000
	presets.vision.easy.combat.cone_2.speed_mul = 0.5
	presets.vision.easy.combat.cone_3.angle = 210
	presets.vision.easy.combat.cone_3.distance = 2000
	presets.vision.easy.combat.cone_3.speed_mul = 0.5
	presets.vision.normal = {
		combat = {},
		idle = {},
	}
	presets.vision.normal.idle = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "normal",
	}
	presets.vision.normal.idle.cone_1.angle = 170
	presets.vision.normal.idle.cone_1.distance = 500
	presets.vision.normal.idle.cone_1.speed_mul = 1.75
	presets.vision.normal.idle.cone_2.angle = 60
	presets.vision.normal.idle.cone_2.distance = 1550
	presets.vision.normal.idle.cone_2.speed_mul = 2
	presets.vision.normal.idle.cone_3.angle = 120
	presets.vision.normal.idle.cone_3.distance = 3000
	presets.vision.normal.idle.cone_3.speed_mul = 7
	presets.vision.normal.combat = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "normal-cbt",
	}
	presets.vision.normal.combat.detection_delay = 1
	presets.vision.normal.combat.cone_1.angle = 210
	presets.vision.normal.combat.cone_1.distance = 3000
	presets.vision.normal.combat.cone_1.speed_mul = 0.5
	presets.vision.normal.combat.cone_2.angle = 210
	presets.vision.normal.combat.cone_2.distance = 3000
	presets.vision.normal.combat.cone_2.speed_mul = 0.5
	presets.vision.normal.combat.cone_3.angle = 210
	presets.vision.normal.combat.cone_3.distance = 3000
	presets.vision.normal.combat.cone_3.speed_mul = 0.5
	presets.vision.hard = {
		combat = {},
		idle = {},
	}
	presets.vision.hard.idle = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "hard",
	}
	presets.vision.hard.idle.cone_1.angle = 180
	presets.vision.hard.idle.cone_1.distance = 500
	presets.vision.hard.idle.cone_1.speed_mul = 1.75
	presets.vision.hard.idle.cone_2.angle = 70
	presets.vision.hard.idle.cone_2.distance = 1550
	presets.vision.hard.idle.cone_2.speed_mul = 2
	presets.vision.hard.idle.cone_3.angle = 130
	presets.vision.hard.idle.cone_3.distance = 3000
	presets.vision.hard.idle.cone_3.speed_mul = 7
	presets.vision.hard.combat = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "hard-cbt",
	}
	presets.vision.hard.combat.detection_delay = 0.5
	presets.vision.hard.combat.cone_1.angle = 210
	presets.vision.hard.combat.cone_1.distance = 3500
	presets.vision.hard.combat.cone_1.speed_mul = 0.3
	presets.vision.hard.combat.cone_2.angle = 220
	presets.vision.hard.combat.cone_2.distance = 3500
	presets.vision.hard.combat.cone_2.speed_mul = 0.3
	presets.vision.hard.combat.cone_3.angle = 240
	presets.vision.hard.combat.cone_3.distance = 3500
	presets.vision.hard.combat.cone_3.speed_mul = 0.3
	presets.vision.commander = {
		combat = {},
		idle = {},
	}
	presets.vision.commander.idle = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "commander",
	}
	presets.vision.commander.idle.cone_1.angle = 180
	presets.vision.commander.idle.cone_1.distance = 600
	presets.vision.commander.idle.cone_1.speed_mul = 1
	presets.vision.commander.idle.cone_2.angle = 80
	presets.vision.commander.idle.cone_2.distance = 1650
	presets.vision.commander.idle.cone_2.speed_mul = 1.5
	presets.vision.commander.idle.cone_3.angle = 130
	presets.vision.commander.idle.cone_3.distance = 3400
	presets.vision.commander.idle.cone_3.speed_mul = 5
	presets.vision.commander.combat = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "commander-cbt",
	}
	presets.vision.commander.combat.cone_1.angle = 280
	presets.vision.commander.combat.cone_1.distance = 2500
	presets.vision.commander.combat.cone_1.speed_mul = 0.5
	presets.vision.commander.combat.cone_2.angle = 280
	presets.vision.commander.combat.cone_2.distance = 2500
	presets.vision.commander.combat.cone_2.speed_mul = 0.5
	presets.vision.commander.combat.cone_3.angle = 280
	presets.vision.commander.combat.cone_3.distance = 2500
	presets.vision.commander.combat.cone_3.speed_mul = 0.5
	presets.vision.special_forces = {
		combat = {},
		idle = {},
	}
	presets.vision.special_forces.idle = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "special_forces",
	}
	presets.vision.special_forces.idle.cone_1.angle = 160
	presets.vision.special_forces.idle.cone_1.distance = 500
	presets.vision.special_forces.idle.cone_1.speed_mul = 1.25
	presets.vision.special_forces.idle.cone_2.angle = 50
	presets.vision.special_forces.idle.cone_2.distance = 1550
	presets.vision.special_forces.idle.cone_2.speed_mul = 1.8
	presets.vision.special_forces.idle.cone_3.angle = 110
	presets.vision.special_forces.idle.cone_3.distance = 3000
	presets.vision.special_forces.idle.cone_3.speed_mul = 7
	presets.vision.special_forces.combat = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "special_forces-cbt",
	}
	presets.vision.special_forces.combat.cone_1.angle = 280
	presets.vision.special_forces.combat.cone_1.distance = 5200
	presets.vision.special_forces.combat.cone_1.speed_mul = 0.25
	presets.vision.special_forces.combat.cone_2.angle = 380
	presets.vision.special_forces.combat.cone_2.distance = 5200
	presets.vision.special_forces.combat.cone_2.speed_mul = 0.25
	presets.vision.special_forces.combat.cone_3.angle = 280
	presets.vision.special_forces.combat.cone_3.distance = 5200
	presets.vision.special_forces.combat.cone_3.speed_mul = 0.25
	presets.vision.civilian = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "civilian",
	}
	presets.vision.civilian.cone_1.angle = 30
	presets.vision.civilian.cone_1.distance = 3200
	presets.vision.civilian.cone_1.speed_mul = 4
	presets.vision.civilian.cone_2.angle = 75
	presets.vision.civilian.cone_2.distance = 2500
	presets.vision.civilian.cone_2.speed_mul = 2
	presets.vision.civilian.cone_3.angle = 210
	presets.vision.civilian.cone_3.distance = 800
	presets.vision.civilian.cone_3.speed_mul = 0.5
	presets.detection = {}
	presets.detection.normal = {
		combat = {},
		guard = {},
		idle = {},
		ntl = {},
		recon = {},
	}
	presets.detection.normal.idle.dis_max = 10000
	presets.detection.normal.idle.angle_max = 120
	presets.detection.normal.idle.delay = {
		0,
		0,
	}
	presets.detection.normal.idle.use_uncover_range = true
	presets.detection.normal.idle.search_for_player = true
	presets.detection.normal.idle.avoid_suppressive_firing = true
	presets.detection.normal.idle.name = "normal.idle"
	presets.detection.normal.combat.dis_max = 10000
	presets.detection.normal.combat.angle_max = 120
	presets.detection.normal.combat.delay = {
		0,
		0,
	}
	presets.detection.normal.combat.use_uncover_range = true
	presets.detection.normal.combat.name = "normal.combat"
	presets.detection.normal.recon.dis_max = 10000
	presets.detection.normal.recon.angle_max = 120
	presets.detection.normal.recon.delay = {
		0,
		0,
	}
	presets.detection.normal.recon.use_uncover_range = true
	presets.detection.normal.recon.search_for_player = true
	presets.detection.normal.recon.avoid_suppressive_firing = true
	presets.detection.normal.recon.name = "normal.recon"
	presets.detection.normal.guard.dis_max = 10000
	presets.detection.normal.guard.angle_max = 120
	presets.detection.normal.guard.delay = {
		0,
		0,
	}
	presets.detection.normal.guard.search_for_player = true
	presets.detection.normal.guard.avoid_suppressive_firing = true
	presets.detection.normal.guard.name = "normal.guard"
	presets.detection.normal.ntl.dis_max = 4000
	presets.detection.normal.ntl.angle_max = 60
	presets.detection.normal.ntl.delay = {
		0.2,
		2,
	}
	presets.detection.normal.ntl.use_uncover_range = true
	presets.detection.normal.ntl.search_for_player = true
	presets.detection.normal.ntl.avoid_suppressive_firing = true
	presets.detection.normal.ntl.name = "normal.ntl"
	presets.detection.flamer = deep_clone(presets.detection.normal)
	presets.detection.flamer.idle.avoid_suppressive_firing = true
	presets.detection.flamer.combat.avoid_suppressive_firing = true
	presets.detection.flamer.recon.avoid_suppressive_firing = true
	presets.detection.flamer.guard.avoid_suppressive_firing = true
	presets.detection.flamer.ntl.avoid_suppressive_firing = true
	presets.detection.guard = {
		combat = {},
		guard = {},
		idle = {},
		ntl = {},
		recon = {},
	}
	presets.detection.guard.idle.dis_max = 10000
	presets.detection.guard.idle.angle_max = 120
	presets.detection.guard.idle.delay = {
		0,
		0,
	}
	presets.detection.guard.idle.use_uncover_range = true
	presets.detection.guard.idle.search_for_player = true
	presets.detection.guard.idle.name = "guard.idle"
	presets.detection.guard.combat.dis_max = 10000
	presets.detection.guard.combat.angle_max = 120
	presets.detection.guard.combat.delay = {
		0,
		0,
	}
	presets.detection.guard.combat.use_uncover_range = true
	presets.detection.guard.combat.name = "guard.combat"
	presets.detection.guard.recon.dis_max = 10000
	presets.detection.guard.recon.angle_max = 120
	presets.detection.guard.recon.delay = {
		0,
		0,
	}
	presets.detection.guard.recon.use_uncover_range = true
	presets.detection.guard.recon.search_for_player = true
	presets.detection.guard.recon.name = "guard.recon"
	presets.detection.guard.guard.dis_max = 10000
	presets.detection.guard.guard.angle_max = 120
	presets.detection.guard.guard.delay = {
		0,
		0,
	}
	presets.detection.guard.ntl = presets.detection.normal.ntl
	presets.detection.sniper = {
		combat = {},
		guard = {},
		idle = {},
		ntl = {},
		recon = {},
	}
	presets.detection.sniper.idle.dis_max = 40000
	presets.detection.sniper.idle.angle_max = 120
	presets.detection.sniper.idle.delay = {
		0.5,
		1,
	}
	presets.detection.sniper.idle.use_uncover_range = true
	presets.detection.sniper.idle.avoid_suppressive_firing = true
	presets.detection.sniper.combat.dis_max = 40000
	presets.detection.sniper.combat.angle_max = 120
	presets.detection.sniper.combat.delay = {
		2,
		3,
	}
	presets.detection.sniper.combat.use_uncover_range = true
	presets.detection.sniper.combat.avoid_suppressive_firing = true
	presets.detection.sniper.recon.dis_max = 40000
	presets.detection.sniper.recon.angle_max = 120
	presets.detection.sniper.recon.delay = {
		0.5,
		1,
	}
	presets.detection.sniper.recon.use_uncover_range = true
	presets.detection.sniper.recon.avoid_suppressive_firing = true
	presets.detection.sniper.guard.dis_max = 40000
	presets.detection.sniper.guard.angle_max = 150
	presets.detection.sniper.guard.delay = {
		1,
		2,
	}
	presets.detection.sniper.ntl = presets.detection.normal.ntl
	presets.vision.spotter = {
		combat = {},
		idle = {},
	}
	presets.vision.spotter.combat = {
		cone_1 = {},
		cone_2 = {},
		cone_3 = {},
		name = "spotter",
	}
	presets.vision.spotter.combat.cone_1.angle = 280
	presets.vision.spotter.combat.cone_1.distance = 4000
	presets.vision.spotter.combat.cone_1.speed_mul = 2
	presets.vision.spotter.combat.cone_2.angle = 280
	presets.vision.spotter.combat.cone_2.distance = 6000
	presets.vision.spotter.combat.cone_2.speed_mul = 4
	presets.vision.spotter.combat.cone_3.angle = 280
	presets.vision.spotter.combat.cone_3.distance = 8000
	presets.vision.spotter.combat.cone_3.speed_mul = 6
	presets.vision.spotter.idle = deep_clone(presets.vision.spotter.combat)
	presets.detection.gang_member = {
		combat = {},
		guard = {},
		idle = {},
		ntl = {},
		recon = {},
	}
	presets.detection.gang_member.idle.dis_max = 11000
	presets.detection.gang_member.idle.angle_max = 180
	presets.detection.gang_member.idle.delay = {
		0.1,
		0.25,
	}
	presets.detection.gang_member.idle.use_uncover_range = true
	presets.detection.gang_member.combat.dis_max = 10000
	presets.detection.gang_member.combat.angle_max = 200
	presets.detection.gang_member.combat.delay = {
		0,
		0,
	}
	presets.detection.gang_member.combat.use_uncover_range = true
	presets.detection.gang_member.recon.dis_max = 10000
	presets.detection.gang_member.recon.angle_max = 180
	presets.detection.gang_member.recon.delay = {
		0,
		0,
	}
	presets.detection.gang_member.recon.use_uncover_range = true
	presets.detection.gang_member.guard.dis_max = 10000
	presets.detection.gang_member.guard.angle_max = 180
	presets.detection.gang_member.guard.delay = {
		0,
		0,
	}
	presets.detection.gang_member.ntl = presets.detection.normal.ntl

	self:_process_weapon_usage_table(presets.weapon.normal)
	self:_process_weapon_usage_table(presets.weapon.good)
	self:_process_weapon_usage_table(presets.weapon.expert)
	self:_process_weapon_usage_table(presets.weapon.insane)
	self:_process_weapon_usage_table(presets.weapon.sniper)
	self:_process_weapon_usage_table(presets.weapon.gang_member)

	presets.detection.civilian = {
		cbt = {},
		ntl = {},
	}
	presets.detection.civilian.cbt.dis_max = 700
	presets.detection.civilian.cbt.angle_max = 120
	presets.detection.civilian.cbt.delay = {
		0,
		0,
	}
	presets.detection.civilian.cbt.use_uncover_range = true
	presets.detection.civilian.ntl.dis_max = 2000
	presets.detection.civilian.ntl.angle_max = 60
	presets.detection.civilian.ntl.delay = {
		0.2,
		3,
	}
	presets.dodge = {
		athletic = {
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {
						0,
						0,
					},
					variations = {
						roll = {
							chance = 1,
							timeout = {
								3,
								4,
							},
						},
						side_step = {
							chance = 5,
							shoot_accuracy = 0.5,
							shoot_chance = 0.8,
							timeout = {
								1,
								3,
							},
						},
					},
				},
				preemptive = {
					chance = 0.35,
					check_timeout = {
						2,
						3,
					},
					variations = {
						roll = {
							chance = 1,
							timeout = {
								3,
								4,
							},
						},
						side_step = {
							chance = 3,
							shoot_accuracy = 0.7,
							shoot_chance = 1,
							timeout = {
								1,
								2,
							},
						},
					},
				},
				scared = {
					chance = 0.4,
					check_timeout = {
						1,
						2,
					},
					variations = {
						dive = {
							chance = 0,
							timeout = {
								3,
								5,
							},
						},
						roll = {
							chance = 3,
							timeout = {
								3,
								5,
							},
						},
						side_step = {
							chance = 5,
							shoot_accuracy = 0.4,
							shoot_chance = 0.5,
							timeout = {
								1,
								2,
							},
						},
					},
				},
			},
			speed = 1.3,
		},
		average = {
			occasions = {
				hit = {
					chance = 0.35,
					check_timeout = {
						0,
						0,
					},
					variations = {
						roll = {
							chance = 1,
							timeout = {
								4,
								8,
							},
						},
						side_step = {
							chance = 4,
							timeout = {
								2,
								3,
							},
						},
					},
				},
				preemptive = {
					chance = 0.5,
					check_timeout = {
						1,
						3,
					},
					variations = {
						roll = {
							chance = 1,
							timeout = {
								4,
								8,
							},
						},
						side_step = {
							chance = 4,
							timeout = {
								2,
								3,
							},
						},
					},
				},
				scared = {
					chance = 0.4,
					check_timeout = {
						4,
						7,
					},
					variations = {
						dive = {
							chance = 5,
							timeout = {
								5,
								8,
							},
						},
						roll = {
							chance = 1,
							timeout = {
								8,
								10,
							},
						},
					},
				},
			},
			speed = 1,
		},
		heavy = {
			occasions = {
				hit = {
					chance = 0.75,
					check_timeout = {
						0,
						0,
					},
					variations = {
						roll = {
							chance = 0,
							timeout = {
								8,
								10,
							},
						},
						side_step = {
							chance = 9,
							shoot_accuracy = 0.5,
							shoot_chance = 0.8,
							timeout = {
								0,
								7,
							},
						},
					},
				},
				preemptive = {
					chance = 0.5,
					check_timeout = {
						1,
						2,
					},
					variations = {
						side_step = {
							chance = 9,
							shoot_accuracy = 0.7,
							shoot_chance = 0.8,
							timeout = {
								1,
								7,
							},
						},
					},
				},
				scared = {
					chance = 0.8,
					check_timeout = {
						1,
						2,
					},
					variations = {
						dive = {
							chance = 4,
							timeout = {
								8,
								10,
							},
						},
						roll = {
							chance = 2,
							timeout = {
								8,
								10,
							},
						},
						side_step = {
							chance = 5,
							shoot_accuracy = 0.4,
							shoot_chance = 0.5,
							timeout = {
								1,
								2,
							},
						},
					},
				},
			},
			speed = 1,
		},
		ninja = {
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {
						0,
						3,
					},
					variations = {
						roll = {
							chance = 1,
							timeout = {
								1.2,
								2,
							},
						},
						side_step = {
							chance = 3,
							shoot_accuracy = 0.7,
							shoot_chance = 1,
							timeout = {
								1,
								2,
							},
						},
						wheel = {
							chance = 2,
							timeout = {
								1.2,
								2,
							},
						},
					},
				},
				preemptive = {
					chance = 0.6,
					check_timeout = {
						0,
						3,
					},
					variations = {
						roll = {
							chance = 1,
							timeout = {
								1.2,
								2,
							},
						},
						side_step = {
							chance = 3,
							shoot_accuracy = 0.8,
							shoot_chance = 1,
							timeout = {
								1,
								2,
							},
						},
						wheel = {
							chance = 2,
							timeout = {
								1.2,
								2,
							},
						},
					},
				},
				scared = {
					chance = 0.9,
					check_timeout = {
						0,
						3,
					},
					variations = {
						dive = {
							chance = 0,
							timeout = {
								1.2,
								2,
							},
						},
						roll = {
							chance = 3,
							timeout = {
								1.2,
								2,
							},
						},
						side_step = {
							chance = 5,
							shoot_accuracy = 0.6,
							shoot_chance = 0.8,
							timeout = {
								1,
								2,
							},
						},
						wheel = {
							chance = 3,
							timeout = {
								1.2,
								2,
							},
						},
					},
				},
			},
			speed = 1.6,
		},
		poor = {
			occasions = {
				hit = {
					chance = 0.1,
					check_timeout = {
						100,
						100,
					},
					variations = {
						side_step = {
							chance = 1,
							timeout = {
								2,
								3,
							},
						},
					},
				},
				preemptive = {
					chance = 0.5,
					check_timeout = {
						3,
						5,
					},
					variations = {
						side_step = {
							chance = 1,
							timeout = {
								3,
								5,
							},
						},
					},
				},
				scared = {
					chance = 0.5,
					check_timeout = {
						3,
						5,
					},
					variations = {
						side_step = {
							chance = 1,
							timeout = {
								3,
								5,
							},
						},
					},
				},
			},
			speed = 0.9,
		},
	}

	for preset_name, preset_data in pairs(presets.dodge) do
		for reason_name, reason_data in pairs(preset_data.occasions) do
			local total_w = 0

			for variation_name, variation_data in pairs(reason_data.variations) do
				total_w = total_w + variation_data.chance
			end

			if total_w > 0 then
				for variation_name, variation_data in pairs(reason_data.variations) do
					variation_data.chance = variation_data.chance / total_w
				end
			end
		end
	end

	presets.move_speed = {
		civ_fast = {
			crouch = {
				run = {
					cbt = {
						bwd = 260,
						fwd = 312,
						strafe = 245,
					},
					hos = {
						bwd = 260,
						fwd = 312,
						strafe = 245,
					},
				},
				walk = {
					cbt = {
						bwd = 163,
						fwd = 174,
						strafe = 160,
					},
					hos = {
						bwd = 163,
						fwd = 174,
						strafe = 160,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 230,
						fwd = 500,
						strafe = 250,
					},
					hos = {
						bwd = 230,
						fwd = 500,
						strafe = 192,
					},
				},
				walk = {
					cbt = {
						bwd = 160,
						fwd = 210,
						strafe = 175,
					},
					hos = {
						bwd = 160,
						fwd = 210,
						strafe = 190,
					},
					ntl = {
						bwd = 100,
						fwd = 150,
						strafe = 120,
					},
				},
			},
		},
		fast = {
			crouch = {
				run = {
					cbt = {
						bwd = 255,
						fwd = 312,
						strafe = 270,
					},
					hos = {
						bwd = 255,
						fwd = 330,
						strafe = 280,
					},
				},
				walk = {
					cbt = {
						bwd = 170,
						fwd = 235,
						strafe = 180,
					},
					hos = {
						bwd = 170,
						fwd = 235,
						strafe = 180,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 280,
						fwd = 450,
						strafe = 285,
					},
					hos = {
						bwd = 280,
						fwd = 625,
						strafe = 315,
					},
				},
				walk = {
					cbt = {
						bwd = 185,
						fwd = 270,
						strafe = 215,
					},
					hos = {
						bwd = 185,
						fwd = 270,
						strafe = 215,
					},
					ntl = {
						bwd = 110,
						fwd = 150,
						strafe = 120,
					},
				},
			},
		},
		lightning = {
			crouch = {
				run = {
					cbt = {
						bwd = 280,
						fwd = 412,
						strafe = 300,
					},
					hos = {
						bwd = 250,
						fwd = 420,
						strafe = 300,
					},
				},
				walk = {
					cbt = {
						bwd = 190,
						fwd = 255,
						strafe = 190,
					},
					hos = {
						bwd = 190,
						fwd = 245,
						strafe = 210,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 320,
						fwd = 750,
						strafe = 380,
					},
					hos = {
						bwd = 350,
						fwd = 800,
						strafe = 400,
					},
				},
				walk = {
					cbt = {
						bwd = 215,
						fwd = 285,
						strafe = 225,
					},
					hos = {
						bwd = 215,
						fwd = 285,
						strafe = 225,
					},
					ntl = {
						bwd = 110,
						fwd = 150,
						strafe = 120,
					},
				},
			},
		},
		normal = {
			crouch = {
				run = {
					cbt = {
						bwd = 235,
						fwd = 350,
						strafe = 260,
					},
					hos = {
						bwd = 235,
						fwd = 310,
						strafe = 260,
					},
				},
				walk = {
					cbt = {
						bwd = 160,
						fwd = 210,
						strafe = 170,
					},
					hos = {
						bwd = 160,
						fwd = 210,
						strafe = 170,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 255,
						fwd = 400,
						strafe = 250,
					},
					hos = {
						bwd = 255,
						fwd = 450,
						strafe = 290,
					},
				},
				walk = {
					cbt = {
						bwd = 170,
						fwd = 220,
						strafe = 190,
					},
					hos = {
						bwd = 170,
						fwd = 220,
						strafe = 190,
					},
					ntl = {
						bwd = 100,
						fwd = 150,
						strafe = 120,
					},
				},
			},
		},
		slow = {
			crouch = {
				run = {
					cbt = {
						bwd = 155,
						fwd = 360,
						strafe = 140,
					},
					hos = {
						bwd = 150,
						fwd = 360,
						strafe = 140,
					},
				},
				walk = {
					cbt = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					hos = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 155,
						fwd = 360,
						strafe = 150,
					},
					hos = {
						bwd = 135,
						fwd = 360,
						strafe = 150,
					},
				},
				walk = {
					cbt = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					hos = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					ntl = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
				},
			},
		},
		super_slow = {
			crouch = {
				run = {
					cbt = {
						bwd = 125,
						fwd = 144,
						strafe = 100,
					},
					hos = {
						bwd = 113,
						fwd = 144,
						strafe = 130,
					},
				},
				walk = {
					cbt = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					hos = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 125,
						fwd = 144,
						strafe = 100,
					},
					hos = {
						bwd = 113,
						fwd = 144,
						strafe = 140,
					},
				},
				walk = {
					cbt = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					hos = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					ntl = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
				},
			},
		},
		teamai = {
			crouch = {
				run = {
					cbt = {
						bwd = 268,
						fwd = 312,
						strafe = 282,
					},
					hos = {
						bwd = 268,
						fwd = 350,
						strafe = 282,
					},
				},
				walk = {
					cbt = {
						bwd = 190,
						fwd = 255,
						strafe = 190,
					},
					hos = {
						bwd = 190,
						fwd = 245,
						strafe = 210,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 300,
						fwd = 475,
						strafe = 325,
					},
					hos = {
						bwd = 325,
						fwd = 580,
						strafe = 340,
					},
				},
				walk = {
					cbt = {
						bwd = 215,
						fwd = 285,
						strafe = 225,
					},
					hos = {
						bwd = 215,
						fwd = 285,
						strafe = 225,
					},
					ntl = {
						bwd = 120,
						fwd = 145,
						strafe = 120,
					},
				},
			},
		},
		very_fast = {
			crouch = {
				run = {
					cbt = {
						bwd = 268,
						fwd = 312,
						strafe = 282,
					},
					hos = {
						bwd = 268,
						fwd = 350,
						strafe = 282,
					},
				},
				walk = {
					cbt = {
						bwd = 190,
						fwd = 255,
						strafe = 190,
					},
					hos = {
						bwd = 190,
						fwd = 245,
						strafe = 210,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 300,
						fwd = 475,
						strafe = 325,
					},
					hos = {
						bwd = 325,
						fwd = 670,
						strafe = 340,
					},
				},
				walk = {
					cbt = {
						bwd = 215,
						fwd = 285,
						strafe = 225,
					},
					hos = {
						bwd = 215,
						fwd = 285,
						strafe = 225,
					},
					ntl = {
						bwd = 110,
						fwd = 150,
						strafe = 120,
					},
				},
			},
		},
		very_slow = {
			crouch = {
				run = {
					cbt = {
						bwd = 170,
						fwd = 216,
						strafe = 180,
					},
					hos = {
						bwd = 170,
						fwd = 216,
						strafe = 180,
					},
				},
				walk = {
					cbt = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					hos = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
				},
			},
			stand = {
				run = {
					cbt = {
						bwd = 170,
						fwd = 216,
						strafe = 180,
					},
					hos = {
						bwd = 170,
						fwd = 216,
						strafe = 180,
					},
				},
				walk = {
					cbt = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					hos = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
					ntl = {
						bwd = 113,
						fwd = 144,
						strafe = 120,
					},
				},
			},
		},
	}

	for _, poses in pairs(presets.move_speed) do
		for _, hastes in pairs(poses) do
			hastes.run.ntl = hastes.run.hos
		end

		poses.crouch.walk.ntl = poses.crouch.walk.hos
		poses.crouch.run.ntl = poses.crouch.run.hos
		poses.stand.run.ntl = poses.stand.run.hos
		poses.panic = poses.stand
	end

	presets.suppression = {
		easy = {
			brown_point = {
				3,
				5,
			},
			duration = {
				10,
				15,
			},
			panic_chance_mul = 1,
			react_point = {
				0,
				2,
			},
		},
		hard_agg = {
			brown_point = {
				5,
				6,
			},
			duration = {
				5,
				8,
			},
			panic_chance_mul = 0.7,
			react_point = {
				2,
				5,
			},
		},
		hard_def = {
			brown_point = {
				5,
				6,
			},
			duration = {
				5,
				10,
			},
			panic_chance_mul = 0.7,
			react_point = {
				0,
				2,
			},
		},
		no_supress = {
			brown_point = {
				400,
				500,
			},
			duration = {
				0.1,
				0.15,
			},
			panic_chance_mul = 0,
			react_point = {
				100,
				200,
			},
		},
	}
	presets.enemy_chatter = {
		no_chatter = {},
		regular = {
			aggressive = true,
			clear = true,
			contact = true,
			follow_me = true,
			go_go = true,
			incomming_commander = true,
			incomming_flamer = true,
			ready = true,
			retreat = true,
			smoke = true,
			suppress = true,
		},
		special = {
			aggressive = true,
			clear = true,
			contact = true,
			follow_me = true,
			go_go = true,
			ready = true,
			suppress = true,
		},
	}

	return presets
end

function CharacterTweakData:_create_table_structure()
	self.weap_ids = {
		"m42_flammenwerfer",
		"panzerfaust_60",
		"ger_kar98_npc",
		"sniper_kar98_npc",
		"spotting_optics_npc",
		"ger_mp38_npc",
		"ger_luger_npc",
		"ger_luger_fancy_npc",
		"ger_luger_npc_invisible",
		"ger_stg44_npc",
		"usa_garand_npc",
		"usa_m1911_npc",
		"usa_m1912_npc",
		"thompson_npc",
		"ger_geco_npc",
	}
	self.weap_unit_names = {
		Idstring("units/vanilla/weapons/wpn_npc_spc_m42_flammenwerfer/wpn_npc_spc_m42_flammenwerfer"),
		Idstring("units/temp/weapons/wpn_npc_spc_panzerfaust_60/wpn_npc_spc_panzerfaust_60"),
		Idstring("units/vanilla/weapons/wpn_npc_ger_k98/wpn_npc_ger_k98"),
		Idstring("units/vanilla/weapons/wpn_npc_ger_k98/wpn_npc_ger_k98_sniper"),
		Idstring("units/vanilla/weapons/wpn_npc_binocular/wpn_npc_binocular"),
		Idstring("units/vanilla/weapons/wpn_npc_ger_mp38/wpn_npc_ger_mp38"),
		Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger"),
		Idstring("units/vanilla/weapons/wpn_npc_ger_luger/wpn_npc_ger_luger_fancy"),
		Idstring("units/vanilla/weapons/wpn_npc_ger_stg44/wpn_npc_ger_stg44"),
		Idstring("units/vanilla/weapons/wpn_npc_usa_garand/wpn_npc_usa_garand"),
		Idstring("units/vanilla/weapons/wpn_npc_usa_m1911/wpn_npc_usa_m1911"),
		Idstring("units/vanilla/weapons/wpn_npc_usa_m1912/wpn_npc_usa_m1912"),
		Idstring("units/vanilla/weapons/wpn_npc_smg_thompson/wpn_npc_smg_thompson"),
		Idstring("units/vanilla/weapons/wpn_npc_ger_geco/wpn_npc_ger_geco"),
		Idstring("units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24_husk"),
		Idstring("units/vanilla/weapons/wpn_fps_decoy_coin_peace/wpn_decoy_coin_peace_husk"),
		Idstring("units/vanilla/weapons/wpn_fps_gre_mills/wpn_fps_gre_mills_husk"),
		Idstring("units/vanilla/weapons/wpn_fps_gre_d343/wpn_fps_gre_d343_husk"),
		Idstring("units/upd_001/weapons/wpn_fps_gre_concrete/wpn_fps_gre_concrete_husk"),
		Idstring("units/upd_021/weapons/wpn_fps_gre_betty/wpn_fps_gre_betty_husk"),
		Idstring("units/upd_candy/weapons/gre_gold_bar/wpn_tps_gre_gold_bar"),
		Idstring("units/upd_blaze/weapons/gre_thermite/wpn_tps_gre_thermite"),
		Idstring("units/upd_blaze/weapons/gre_anti_tank/wpn_tps_gre_anti_tank"),
		Idstring("units/vanilla/weapons/wpn_third_mel_m3_knife/wpn_third_mel_m3_knife"),
		Idstring("units/vanilla/weapons/wpn_third_mel_robbins_dudley_trench_push_dagger/wpn_third_mel_robbins_dudley_trench_push_dagger"),
		Idstring("units/vanilla/weapons/wpn_third_mel_german_brass_knuckles/wpn_third_mel_german_brass_knuckles"),
		Idstring("units/vanilla/weapons/wpn_third_mel_lockwood_brothers_push_dagger/wpn_third_mel_lockwood_brothers_push_dagger"),
		Idstring("units/vanilla/weapons/wpn_third_mel_bc41_knuckle_knife/wpn_third_mel_bc41_knuckle_knife"),
		Idstring("units/vanilla/weapons/wpn_third_mel_km_dagger/wpn_third_mel_km_dagger"),
		Idstring("units/vanilla/weapons/wpn_third_mel_marching_mace/wpn_third_mel_marching_mace"),
		Idstring("units/event_001_halloween/weapons/wpn_third_mel_lc14b/wpn_third_mel_lc14b"),
	}
	self.hack_weap_unit_names = {}
	self.hack_weap_unit_names[Idstring("units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24_hand"):key()] = Idstring("units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24_husk")
	self.hack_weap_unit_names[Idstring("units/vanilla/weapons/wpn_fps_mel_m3_knife/wpn_fps_mel_m3_knife"):key()] = Idstring("units/vanilla/weapons/wpn_third_mel_m3_knife/wpn_third_mel_m3_knife")
	self.hack_weap_unit_names[Idstring("units/vanilla/weapons/wpn_fps_mel_robbins_dudley_trench_push_dagger/wpn_fps_mel_robbins_dudley_trench_push_dagger"):key()] = Idstring("units/vanilla/weapons/wpn_third_mel_robbins_dudley_trench_push_dagger/wpn_third_mel_robbins_dudley_trench_push_dagger")
	self.hack_weap_unit_names[Idstring("units/vanilla/weapons/wpn_fps_mel_german_brass_knuckles/wpn_fps_mel_german_brass_knuckles"):key()] = Idstring("units/vanilla/weapons/wpn_third_mel_german_brass_knuckles/wpn_third_mel_german_brass_knuckles")
	self.hack_weap_unit_names[Idstring("units/vanilla/weapons/wpn_fps_mel_lockwood_brothers_push_dagger/wpn_fps_mel_lockwood_brothers_push_dagger"):key()] = Idstring("units/vanilla/weapons/wpn_third_mel_lockwood_brothers_push_dagger/wpn_third_mel_lockwood_brothers_push_dagger")
	self.hack_weap_unit_names[Idstring("units/vanilla/weapons/wpn_fps_mel_bc41_knuckle_knife/wpn_fps_mel_bc41_knuckle_knife"):key()] = Idstring("units/vanilla/weapons/wpn_third_mel_bc41_knuckle_knife/wpn_third_mel_bc41_knuckle_knife")
	self.hack_weap_unit_names[Idstring("units/vanilla/weapons/wpn_fps_km_dagger/wpn_fps_km_dagger"):key()] = Idstring("units/vanilla/weapons/wpn_third_mel_km_dagger/wpn_third_mel_km_dagger")
	self.hack_weap_unit_names[Idstring("units/vanilla/weapons/wpn_fps_marching_mace/wpn_fps_marching_mace"):key()] = Idstring("units/vanilla/weapons/wpn_third_mel_marching_mace/wpn_third_mel_marching_mace")
	self.hack_weap_unit_names[Idstring("units/event_001_halloween/weapons/wpn_fps_lc14b/wpn_fps_lc14b"):key()] = Idstring("units/event_001_halloween/weapons/wpn_third_mel_lc14b/wpn_third_mel_lc14b")
end

function CharacterTweakData:_process_weapon_usage_table(weap_usage_table)
	for _, weap_id in ipairs(self.weap_ids) do
		local usage_data = weap_usage_table[weap_id]

		if usage_data and usage_data.FALLOFF then
			for i_range, range_data in ipairs(usage_data.FALLOFF) do
				local modes = range_data.mode
				local total = 0

				for i_firemode, value in ipairs(modes) do
					total = total + value
				end

				local prev_value

				for i_firemode, value in ipairs(modes) do
					prev_value = (prev_value or 0) + value / total
					modes[i_firemode] = prev_value
				end
			end
		end
	end
end

function CharacterTweakData:_set_difficulty_1()
	self:_multiply_all_hp(1)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 1)
	self:_multiply_weapon_delay(self.presets.weapon.good, 1)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 1)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 3)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 1)

	self.presets.gang_member_damage.HEALTH_INIT = 100
	self.escort.HEALTH_INIT = 80
	self.flashbang_multiplier = 1

	self:_set_characters_weapon_preset("normal")

	self.presets.weapon.sniper.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.8,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				5,
				6,
			},
		},
		{
			acc = {
				0.4,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 15000,
			recoil = {
				8,
				10,
			},
		},
		{
			acc = {
				0.1,
				0.75,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 40000,
			recoil = {
				8,
				10,
			},
		},
		{
			acc = {
				0,
				0.25,
			},
			dmg_mul = 1.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 80000,
			recoil = {
				8,
				10,
			},
		},
	}
	self.german_flamer.HEALTH_INIT = 1600
	self.german_flamer.throwable.throw_chance = 0
	self.german_flamer.throwable.cooldown = 40
	self.german_flamer.move_speed = self.presets.move_speed.super_slow
end

function CharacterTweakData:_set_difficulty_2()
	self:_multiply_all_hp(1.2)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 1)
	self:_multiply_weapon_delay(self.presets.weapon.good, 1)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 1)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 3)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 1)

	self.presets.gang_member_damage.HEALTH_INIT = 100
	self.escort.HEALTH_INIT = 100
	self.flashbang_multiplier = 1.25

	self:_set_characters_weapon_preset("good")

	self.presets.weapon.sniper.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.8,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				5,
				6,
			},
		},
		{
			acc = {
				0.4,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 15000,
			recoil = {
				5,
				8,
			},
		},
		{
			acc = {
				0.1,
				0.75,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 40000,
			recoil = {
				6,
				9,
			},
		},
		{
			acc = {
				0,
				0.25,
			},
			dmg_mul = 1.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 80000,
			recoil = {
				7,
				10,
			},
		},
	}
	self.german_flamer.HEALTH_INIT = 2000
	self.german_flamer.throwable.throw_chance = 0.15
	self.german_flamer.throwable.cooldown = 30
	self.german_flamer.move_speed = self.presets.move_speed.super_slow
end

function CharacterTweakData:_set_difficulty_3()
	self:_multiply_all_hp(1.4)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0.9)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0.9)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0.9)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 3)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0.9)

	self.presets.gang_member_damage.HEALTH_INIT = 125
	self.escort.HEALTH_INIT = 120
	self.flashbang_multiplier = 1.5

	self:_set_characters_weapon_preset("expert")

	self.presets.weapon.sniper.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.8,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				5,
				6,
			},
		},
		{
			acc = {
				0.4,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 15000,
			recoil = {
				6,
				7,
			},
		},
		{
			acc = {
				0.1,
				0.75,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 40000,
			recoil = {
				7,
				8,
			},
		},
		{
			acc = {
				0,
				0.25,
			},
			dmg_mul = 1.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 80000,
			recoil = {
				8,
				9,
			},
		},
	}
	self.german_flamer.HEALTH_INIT = 2200
	self.german_flamer.throwable.throw_chance = 0.2
	self.german_flamer.throwable.cooldown = 22
	self.german_flamer.move_speed = self.presets.move_speed.very_slow
end

function CharacterTweakData:_set_difficulty_4()
	self:_multiply_all_hp(1.55)
	self:_multiply_all_speeds(2, 2.1)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0.8)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0.8)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0.8)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 3)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0.8)

	self.presets.gang_member_damage.HEALTH_INIT = 150
	self.escort.HEALTH_INIT = 140
	self.flashbang_multiplier = 1.75

	self:_set_characters_weapon_preset("insane")

	self.presets.weapon.sniper.ger_kar98_npc.FALLOFF = {
		{
			acc = {
				0.8,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 1000,
			recoil = {
				5,
				6,
			},
		},
		{
			acc = {
				0.4,
				0.95,
			},
			dmg_mul = 3.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 15000,
			recoil = {
				5,
				6,
			},
		},
		{
			acc = {
				0.1,
				0.75,
			},
			dmg_mul = 2.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 40000,
			recoil = {
				6,
				7,
			},
		},
		{
			acc = {
				0,
				0.25,
			},
			dmg_mul = 1.5,
			mode = {
				1,
				0,
				0,
				0,
			},
			r = 80000,
			recoil = {
				7,
				8,
			},
		},
	}
	self.german_flamer.HEALTH_INIT = 2600
	self.german_flamer.throwable.throw_chance = 0.28
	self.german_flamer.throwable.cooldown = 15
	self.german_flamer.move_speed = self.presets.move_speed.very_slow
end

function CharacterTweakData:_multiply_weapon_delay(weap_usage_table, mul)
	for _, weap_id in ipairs(self.weap_ids) do
		local usage_data = weap_usage_table[weap_id]

		if usage_data and usage_data.focus_delay then
			usage_data.focus_delay = usage_data.focus_delay * mul
		end
	end
end

function CharacterTweakData:_multiply_all_hp(hp_mul)
	for _, name in ipairs(self._enemies_list) do
		self[name].HEALTH_INIT = self[name].BASE_HEALTH_INIT * hp_mul
	end
end

function CharacterTweakData:_multiply_all_speeds(walk_mul, run_mul)
	for _, name in ipairs(self._enemies_list) do
		local speed_table = self[name].SPEED_WALK

		speed_table.hos = speed_table.hos * walk_mul
		speed_table.cbt = speed_table.cbt * walk_mul

		local sprint_speed = self[name].SPEED_RUN

		sprint_speed = sprint_speed * run_mul
	end
end

function CharacterTweakData:_set_characters_weapon_preset(preset)
	for _, name in ipairs(self._enemies_list) do
		if self[name].dont_modify_weapon_usage then
			Application:debug("[CharacterTweakData:_set_characters_weapon_preset] Skipping " .. tostring(name))
		else
			self[name].weapon = self.presets.weapon[preset]
		end
	end
end

function CharacterTweakData:character_map()
	local char_map = {
		raidww2 = {
			list = {
				"german_black_waffen_sentry_light",
				"german_black_waffen_sentry_heavy",
				"german_black_waffen_sentry_gasmask",
				"german_black_waffen_sentry_light_commander",
				"german_black_waffen_sentry_heavy_commander",
				"german_black_waffen_sentry_gasmask_commander",
				"german_waffen_ss",
				"german_commander",
				"german_og_commander",
				"german_officer",
				"german_flamer",
				"german_sniper",
				"german_fallschirmjager_light",
				"german_fallschirmjager_heavy",
				"german_gebirgsjager_light",
				"german_gebirgsjager_heavy",
				"german_grunt_light",
				"german_grunt_mid",
				"german_grunt_heavy",
				"soviet_nkvd_int_security_captain",
				"soviet_nkvd_int_security_captain_b",
				"male_spy",
				"female_spy",
				"soviet_nightwitch_01",
				"soviet_nightwitch_02",
				"german_sommilier",
			},
			path = "units/vanilla/characters/enemies/models/",
		},
		upd_fb = {
			list = {
				"fb_german_commander_boss",
				"fb_german_commander",
			},
			path = "units/upd_fb/characters/enemies/models/",
		},
	}

	return char_map
end

function CharacterTweakData:get_special_enemies()
	local special_enemies = {}

	return special_enemies
end
