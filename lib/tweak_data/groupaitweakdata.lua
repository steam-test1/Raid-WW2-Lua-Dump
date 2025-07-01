require("lib/tweak_data/group_ai/GroupAIRaidTweakData")
require("lib/tweak_data/group_ai/GroupAIStreetTweakData")

GroupAITweakData = GroupAITweakData or class()

function GroupAITweakData:init(tweak_data)
	local difficulty = Global.game_settings and Global.game_settings.difficulty or Global.DEFAULT_DIFFICULTY
	local difficulty_index = tweak_data:difficulty_to_index(difficulty)

	print("[GroupAITweakData:init] difficulty", difficulty, "difficulty_index", difficulty_index)

	self.ai_tick_rate_loud = 80
	self.ai_tick_rate_stealth = 100

	self:_read_mission_preset(tweak_data)
	self:_create_table_structure()
	self:_init_task_data(difficulty_index)

	if not self.besiege then
		self.besiege = GroupAIRaidTweakData:new(difficulty_index)
		self.raid = GroupAIRaidTweakData:new(difficulty_index)
		self.street = GroupAIStreetTweakData:new(difficulty_index)
	else
		self.besiege:init(difficulty_index)
		self.raid:init(difficulty_index)
		self.street:init(difficulty_index)
	end

	self:_init_chatter_data()
	self:_init_unit_categories(difficulty_index)
	self:_init_enemy_spawn_groups(difficulty_index)

	self.commander_backup_groups = {
		"commander_squad",
		"ss_flankers",
		"ss_rifle_range",
		"ss_chargers",
	}
end

function GroupAITweakData:_init_chatter_data()
	self.enemy_chatter = {}
	self.enemy_chatter.spotted_player = {
		duration = {
			1,
			2,
		},
		group_min = 1,
		interval = {
			7,
			10,
		},
		max_nr = 1,
		queue = "spotted_player",
		radius = 3500,
	}
	self.enemy_chatter.aggressive = {
		duration = {
			1,
			2,
		},
		group_min = 1,
		interval = {
			0.75,
			1.5,
		},
		max_nr = 1,
		queue = "aggressive",
		radius = 3500,
	}
	self.enemy_chatter.retreat = {
		duration = {
			1,
			2,
		},
		group_min = 1,
		interval = {
			0.75,
			1.5,
		},
		max_nr = 1,
		queue = "retreat",
		radius = 3500,
	}
	self.enemy_chatter.follow_me = {
		duration = {
			1,
			2,
		},
		group_min = 1,
		interval = {
			0.75,
			1.5,
		},
		max_nr = 1,
		queue = "follow_me",
		radius = 3500,
	}
	self.enemy_chatter.clear = {
		duration = {
			1,
			2,
		},
		group_min = 1,
		interval = {
			0.75,
			1.5,
		},
		max_nr = 1,
		queue = "clear",
		radius = 3500,
	}
	self.enemy_chatter.go_go = {
		duration = {
			1,
			2,
		},
		group_min = 1,
		interval = {
			0.75,
			1.5,
		},
		max_nr = 1,
		queue = "go_go",
		radius = 3500,
	}
	self.enemy_chatter.ready = {
		duration = {
			1,
			2,
		},
		group_min = 1,
		interval = {
			0.75,
			1.5,
		},
		max_nr = 1,
		queue = "ready",
		radius = 3500,
	}
	self.enemy_chatter.smoke = {
		duration = {
			0,
			0,
		},
		group_min = 2,
		interval = {
			0,
			0,
		},
		max_nr = 1,
		queue = "smoke",
		radius = 3500,
	}
	self.enemy_chatter.incomming_flamer = {
		duration = {
			60,
			60,
		},
		group_min = 1,
		interval = {
			0.5,
			1,
		},
		max_nr = 1,
		queue = "incomming_flamer",
		radius = 4000,
	}
	self.enemy_chatter.incomming_commander = {
		duration = {
			60,
			60,
		},
		group_min = 1,
		interval = {
			0.5,
			1,
		},
		max_nr = 1,
		queue = "incomming_commander",
		radius = 4000,
	}
end

local access_type_walk_only = {
	walk = true,
}
local access_type_all = {
	acrobatic = true,
	walk = true,
}

function GroupAITweakData:_init_unit_categories(difficulty_index)
	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.special_unit_spawn_limits = {
			commander = 0,
			flamer = 0,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.special_unit_spawn_limits = {
			commander = 1,
			flamer = 1,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.special_unit_spawn_limits = {
			commander = 1,
			flamer = 2,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.special_unit_spawn_limits = {
			commander = 1,
			flamer = 3,
		}
	end

	self.unit_categories = {}

	self:_init_unit_categories_german(difficulty_index)
end

function GroupAITweakData:_init_unit_categories_german(difficulty_index)
	self.unit_categories.german = {}
	self.unit_categories.german.german_grunt_light = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_light/german_grunt_light"),
		},
	}
	self.unit_categories.german.german_grunt_light_mp38 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_light/german_grunt_light_mp38"),
		},
	}
	self.unit_categories.german.german_grunt_light_kar98 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_light/german_grunt_light_kar98"),
		},
	}
	self.unit_categories.german.german_grunt_light_shotgun = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_light/german_grunt_light_shotgun"),
		},
	}
	self.unit_categories.german.german_grunt_mid = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_mid/german_grunt_mid"),
		},
	}
	self.unit_categories.german.german_grunt_mid_mp38 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_mid/german_grunt_mid_mp38"),
		},
	}
	self.unit_categories.german.german_grunt_mid_kar98 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_mid/german_grunt_mid_kar98"),
		},
	}
	self.unit_categories.german.german_grunt_mid_shotgun = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_mid/german_grunt_mid_shotgun"),
		},
	}
	self.unit_categories.german.german_grunt_heavy = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_heavy/german_grunt_heavy"),
		},
	}
	self.unit_categories.german.german_grunt_heavy_mp38 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_heavy/german_grunt_heavy_mp38"),
		},
	}
	self.unit_categories.german.german_grunt_heavy_kar98 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_heavy/german_grunt_heavy_kar98"),
		},
	}
	self.unit_categories.german.german_grunt_heavy_shotgun = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_grunt_heavy/german_grunt_heavy_shotgun"),
		},
	}
	self.unit_categories.german.german_light = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_light/german_black_waffen_sentry_light"),
		},
	}
	self.unit_categories.german.german_light_kar98 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_light/german_black_waffen_sentry_light_kar98"),
		},
	}
	self.unit_categories.german.german_light_shotgun = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_light/german_black_waffen_sentry_light_shotgun"),
		},
	}
	self.unit_categories.german.german_heavy = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_heavy/german_black_waffen_sentry_heavy"),
		},
	}
	self.unit_categories.german.german_heavy_kar98 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_heavy/german_black_waffen_sentry_heavy_kar98"),
		},
	}
	self.unit_categories.german.german_heavy_shotgun = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_heavy/german_black_waffen_sentry_heavy_shotgun"),
		},
	}
	self.unit_categories.german.german_gasmask = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_gasmask/german_black_waffen_sentry_gasmask"),
		},
	}
	self.unit_categories.german.german_gasmask_shotgun = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_gasmask/german_black_waffen_sentry_gasmask_shotgun"),
		},
	}
	self.unit_categories.german.german_gebirgsjager_light = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_gebirgsjager_light/german_gebirgsjager_light"),
		},
	}
	self.unit_categories.german.german_gebirgsjager_light_mp38 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_gebirgsjager_light/german_gebirgsjager_light_mp38"),
		},
	}
	self.unit_categories.german.german_gebirgsjager_light_kar98 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_gebirgsjager_light/german_gebirgsjager_light_kar98"),
		},
	}
	self.unit_categories.german.german_gebirgsjager_light_shotgun = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_gebirgsjager_light/german_gebirgsjager_light_shotgun"),
		},
	}
	self.unit_categories.german.german_gebirgsjager_heavy = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_gebirgsjager_heavy/german_gebirgsjager_heavy"),
		},
	}
	self.unit_categories.german.german_gebirgsjager_heavy_mp38 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_gebirgsjager_heavy/german_gebirgsjager_heavy_mp38"),
		},
	}
	self.unit_categories.german.german_gebirgsjager_heavy_kar98 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_gebirgsjager_heavy/german_gebirgsjager_heavy_kar98"),
		},
	}
	self.unit_categories.german.german_gebirgsjager_heavy_shotgun = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_gebirgsjager_heavy/german_gebirgsjager_heavy_shotgun"),
		},
	}
	self.unit_categories.german.german_fallschirmjager_heavy = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_fallschirmjager_heavy/german_fallschirmjager_heavy"),
		},
	}
	self.unit_categories.german.german_fallschirmjager_heavy_mp38 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_fallschirmjager_heavy/german_fallschirmjager_heavy_mp38"),
		},
	}
	self.unit_categories.german.german_fallschirmjager_heavy_kar98 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_fallschirmjager_heavy/german_fallschirmjager_heavy_kar98"),
		},
	}
	self.unit_categories.german.german_fallschirmjager_heavy_shotgun = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_fallschirmjager_heavy/german_fallschirmjager_heavy_shotgun"),
		},
	}
	self.unit_categories.german.german_fallschirmjager_light = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_fallschirmjager_light/german_fallschirmjager_light"),
		},
	}
	self.unit_categories.german.german_fallschirmjager_light_mp38 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_fallschirmjager_light/german_fallschirmjager_light_mp38"),
		},
	}
	self.unit_categories.german.german_fallschirmjager_light_kar98 = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_fallschirmjager_light/german_fallschirmjager_light_kar98"),
		},
	}
	self.unit_categories.german.german_fallschirmjager_light_shotgun = {
		access = access_type_all,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_fallschirmjager_light/german_fallschirmjager_light_shotgun"),
		},
	}
	self.unit_categories.german.german_flamethrower = {
		access = access_type_walk_only,
		special_type = "flamer",
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_flamer/german_flamer"),
		},
	}
	self.unit_categories.german.german_commander = {
		access = access_type_walk_only,
		special_type = "commander",
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_commander/german_commander"),
		},
	}
	self.unit_categories.german.german_gasmask_commander_backup = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_gasmask_commander/german_black_waffen_sentry_gasmask_commander"),
		},
	}
	self.unit_categories.german.german_gasmask_commander_backup_shotgun = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_gasmask_commander/german_black_waffen_sentry_gasmask_commander_shotgun"),
		},
	}
	self.unit_categories.german.german_heavy_commander_backup = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_heavy_commander/german_black_waffen_sentry_heavy_commander"),
		},
	}
	self.unit_categories.german.german_heavy_commander_backup_kar98 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_heavy_commander/german_black_waffen_sentry_heavy_commander_kar98"),
		},
	}
	self.unit_categories.german.german_heavy_commander_backup_shotgun = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_heavy_commander/german_black_waffen_sentry_heavy_commander_shotgun"),
		},
	}
	self.unit_categories.german.german_light_commander_backup = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_light_commander/german_black_waffen_sentry_light_commander"),
		},
	}
	self.unit_categories.german.german_light_commander_backup_kar98 = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_light_commander/german_black_waffen_sentry_light_commander_kar98"),
		},
	}
	self.unit_categories.german.german_light_commander_backup_shotgun = {
		access = access_type_walk_only,
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_black_waffen_sentry_light_commander/german_black_waffen_sentry_light_commander_shotgun"),
		},
	}
	self.unit_categories.german.german_og_commander = {
		access = access_type_walk_only,
		special_type = "commander",
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_og_commander/german_og_commander"),
		},
	}
	self.unit_categories.german.german_officer = {
		access = access_type_walk_only,
		special_type = "officer",
		units = {
			Idstring("units/vanilla/characters/enemies/models/german_commander/german_commander"),
		},
	}
end

function GroupAITweakData:_init_enemy_spawn_groups(difficulty_index)
	self._tactics = {
		close_assault = {
			"charge",
			"ranged_fire",
			"deathguard",
		},
		close_assault_flank = {
			"charge",
			"flank",
			"ranged_fire",
			"deathguard",
		},
		close_assault_grenade = {
			"charge",
		},
		close_assault_grenade_flank = {
			"charge",
			"flank",
		},
		close_assault_supprise = {
			"flank",
		},
		commander = {
			"flank",
		},
		defend = {
			"flank",
			"ranged_fire",
		},
		fallschirm_chargers = {
			"provide_coverfire",
			"provide_support",
		},
		fallschirm_flankers = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
			"flank",
		},
		fallschirm_support = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
		},
		flamethrower = {
			"charge",
			"flank",
		},
		flanker = {
			"flank",
		},
		gerbish_chargers = {
			"provide_coverfire",
			"provide_support",
		},
		gerbish_flankers = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
		},
		gerbish_rifle_range = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
		},
		grunt_chargers = {
			"provide_coverfire",
			"provide_support",
		},
		grunt_flankers = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
		},
		grunt_support_range = {
			"ranged_fire",
			"provide_coverfire",
		},
		ranged_fire = {
			"ranged_fire",
		},
		sniper = {
			"ranged_fire",
		},
		ss_chargers = {
			"provide_coverfire",
			"provide_support",
		},
		ss_flankers = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
			"flank",
		},
		ss_rifle_range = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
		},
	}
	self.enemy_spawn_groups = {}

	self:_init_enemy_spawn_groups_german(difficulty_index)
end

function GroupAITweakData:_init_enemy_spawn_groups_german(difficulty_index)
	self.enemy_spawn_groups.german = {}

	local amount_one = {
		1,
		1,
	}
	local amount_four = {
		4,
		4,
	}
	local amount_easy = {
		2,
		2,
	}
	local amount_norm = {
		2,
		3,
	}
	local amount_hard = {
		2,
		3,
	}
	local amount_vhrd = {
		3,
		3,
	}

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.grunt_chargers = {
			amount = amount_easy,
			spawn = {
				{
					amount_max = 1,
					amount_min = 0,
					freq = 1,
					rank = 3,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light_shotgun",
				},
				{
					amount_max = 2,
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light_mp38",
				},
				{
					amount_min = 0,
					freq = 3,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.grunt_chargers = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 1,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_mid",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light_mp38",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_mid_shotgun",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.grunt_chargers = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_mid_shotgun",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_mid",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_heavy",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.grunt_chargers = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_heavy_shotgun",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_heavy",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_heavy_mp38",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.grunt_flankers = {
			amount = amount_easy,
			spawn = {
				{
					amount_max = 1,
					amount_min = 0,
					freq = 1,
					rank = 3,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_heavy",
				},
				{
					amount_max = 2,
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_mid_mp38",
				},
				{
					amount_min = 0,
					freq = 4,
					rank = 1,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_light_mp38",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.grunt_flankers = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_heavy",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_heavy_mp38",
				},
				{
					amount_min = 0,
					freq = 3,
					rank = 1,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_mid_mp38",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.grunt_flankers = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_mid_shotgun",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_mid",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_heavy",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.grunt_flankers = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_mid",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_flankers,
					unit = "german_grunt_mid_mp38",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_heavy_shotgun",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.grunt_support_range = {
			amount = amount_easy,
			spawn = {
				{
					amount_max = 1,
					amount_min = 0,
					freq = 4,
					rank = 1,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_light_kar98",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 3,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_mid",
				},
				{
					amount_max = 1,
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_mid_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.grunt_support_range = {
			amount = amount_norm,
			spawn = {
				{
					amount_max = 1,
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_light_kar98",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_mid",
				},
				{
					amount_max = 1,
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_mid_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.grunt_support_range = {
			amount = amount_hard,
			spawn = {
				{
					amount_max = 1,
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_light_kar98",
				},
				{
					amount_max = 1,
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_mid_kar98",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_heavy",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.grunt_support_range = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_max = 2,
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_heavy_kar98",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_mid",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_support_range,
					unit = "german_grunt_heavy",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.gerbish_chargers = {
			amount = amount_easy,
			spawn = {
				{
					amount_max = 2,
					amount_min = 1,
					freq = 1,
					rank = 3,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_light",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light_shotgun",
				},
				{
					amount_min = 0,
					freq = 3,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.gerbish_chargers = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_light",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_light_shotgun",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_light_mp38",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.gerbish_chargers = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_heavy_mp38",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_heavy_shotgun",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_light",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.gerbish_chargers = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_heavy",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_gebirgsjager_heavy_shotgun",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.gerbish_rifle_range = {
			amount = amount_easy,
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_heavy",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_grunt_light_kar98",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_grunt_mid_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.gerbish_rifle_range = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_heavy_kar98",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_light_kar98",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_heavy",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.gerbish_rifle_range = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_heavy_kar98",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_heavy",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_light_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.gerbish_rifle_range = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 2,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_heavy",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_gebirgsjager_heavy_kar98",
				},
			},
		}
	end

	self.enemy_spawn_groups.german.gerbish_flankers = {
		amount = amount_easy,
		spawn = {},
	}

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		table.insert(self.enemy_spawn_groups.german.gerbish_flankers.spawn, {
			{
				amount_max = 1,
				freq = 1,
				rank = 3,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_grunt_heavy",
			},
			{
				amount_max = 2,
				freq = 2,
				rank = 2,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_light_mp38",
			},
			{
				amount_min = 2,
				freq = 5,
				rank = 1,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_grunt_light_mp38",
			},
		})
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		table.insert(self.enemy_spawn_groups.german.gerbish_flankers.spawn, {
			{
				amount_min = 0,
				freq = 1,
				rank = 2,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_heavy_mp38",
			},
			{
				amount_min = 0,
				freq = 2,
				rank = 1,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_light_mp38",
			},
			{
				amount_min = 0,
				freq = 2,
				rank = 1,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_grunt_light_mp38",
			},
		})
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		table.insert(self.enemy_spawn_groups.german.gerbish_flankers.spawn, {
			{
				amount_min = 0,
				freq = 1,
				rank = 1,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_light_mp38",
			},
			{
				amount_min = 0,
				freq = 2,
				rank = 2,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_heavy_mp38",
			},
			{
				amount_min = 0,
				freq = 2,
				rank = 1,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_heavy",
			},
		})
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		table.insert(self.enemy_spawn_groups.german.gerbish_flankers.spawn, {
			{
				amount_min = 2,
				freq = 1,
				rank = 2,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_heavy",
			},
			{
				amount_min = 1,
				freq = 2,
				rank = 1,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_heavy_shotgun",
			},
			{
				amount_min = 1,
				freq = 2,
				rank = 1,
				tactics = self._tactics.gerbish_flankers,
				unit = "german_gebirgsjager_heavy_kar98",
			},
		})
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.fallschirm_charge = {
			amount = amount_easy,
			spawn = {
				{
					amount_min = 2,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_light",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light_shotgun",
				},
				{
					amount_min = 1,
					freq = 3,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.fallschirm_charge = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 2,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_light_shotgun",
				},
				{
					amount_min = 2,
					freq = 3,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_light",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_mid_shotgun",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.fallschirm_charge = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_light_shotgun",
				},
				{
					amount_min = 0,
					freq = 3,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_light",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_heavy_shotgun",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.fallschirm_charge = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_heavy_shotgun",
				},
				{
					amount_min = 1,
					freq = 3,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_heavy",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_fallschirmjager_light_shotgun",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.fallschirm_support = {
			amount = amount_easy,
			spawn = {
				{
					amount_min = 2,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_light",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_grunt_light_kar98",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_grunt_light",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.fallschirm_support = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 2,
					freq = 3,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_light",
				},
				{
					amount_min = 2,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_light_kar98",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_grunt_mid_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.fallschirm_support = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_light_kar98",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_heavy_kar98",
				},
				{
					amount_min = 0,
					freq = 3,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_heavy",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.fallschirm_support = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_heavy",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_light_kar98",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_fallschirmjager_heavy_kar98",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.fallschirm_flankers = {
			amount = amount_easy,
			spawn = {
				{
					amount_min = 2,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_light",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_grunt_light",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_grunt_light_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.fallschirm_flankers = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 3,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_light_mp38",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_heavy_mp38",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_heavy",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.fallschirm_flankers = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_light_mp38",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_heavy",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_heavy_mp38",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.fallschirm_flankers = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 0,
					freq = 2,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_heavy_mp38",
				},
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_heavy",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_fallschirmjager_light_mp38",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.ss_chargers = {
			amount = amount_easy,
			spawn = {
				{
					amount_min = 2,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_light_shotgun",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.ss_chargers = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 2,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_shotgun",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_grunt_mid_shotgun",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.ss_chargers = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 2,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_shotgun",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_heavy_shotgun",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.ss_chargers = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 0,
					freq = 2,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_shotgun",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_heavy_shotgun",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.ss_rifle_range = {
			amount = amount_easy,
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_light",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_grunt_light",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_grunt_light_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.ss_rifle_range = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 2,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_light",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_light_kar98",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_heavy_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.ss_rifle_range = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 2,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_light",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_light_kar98",
				},
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_heavy_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.ss_rifle_range = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 1,
					freq = 3,
					rank = 2,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_heavy",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_light_kar98",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_rifle_range,
					unit = "german_heavy_kar98",
				},
			},
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.ss_flankers = {
			amount = amount_easy,
			spawn = {
				{
					amount_min = 1,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_light",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_grunt_light_kar98",
				},
				{
					amount_min = 2,
					freq = 2,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_grunt_light",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.ss_flankers = {
			amount = amount_norm,
			spawn = {
				{
					amount_min = 4,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_light",
				},
				{
					amount_min = 1,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_grunt_light_mp38",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.ss_flankers = {
			amount = amount_hard,
			spawn = {
				{
					amount_min = 3,
					freq = 2,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_light",
				},
				{
					amount_min = 2,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_grunt_heavy",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.ss_flankers = {
			amount = amount_vhrd,
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_light",
				},
				{
					amount_min = 0,
					freq = 1,
					rank = 2,
					tactics = self._tactics.gerbish_flankers,
					unit = "german_heavy",
				},
			},
		}
	end

	self.enemy_spawn_groups.german.flamethrower = {
		amount = amount_one,
		spawn = {
			{
				amount_max = 1,
				amount_min = 1,
				freq = 1,
				rank = 2,
				tactics = self._tactics.flamethrower,
				unit = "german_flamethrower",
			},
		},
	}
	self.enemy_spawn_groups.german.commanders = {
		amount = amount_one,
		spawn = {},
	}

	if difficulty_index <= TweakData.DIFFICULTY_3 then
		table.insert(self.enemy_spawn_groups.german.commanders.spawn, {
			amount_max = 1,
			amount_min = 1,
			freq = 1,
			rank = 2,
			tactics = self._tactics.commander,
			unit = "german_commander",
		})
	else
		table.insert(self.enemy_spawn_groups.german.commanders.spawn, {
			amount_max = 1,
			amount_min = 1,
			freq = 1,
			rank = 2,
			tactics = self._tactics.commander,
			unit = "german_og_commander",
		})
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.enemy_spawn_groups.german.commander_squad = {
			amount = amount_easy,
			spawn = {
				{
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_commander_backup",
				},
				{
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_commander_backup_shotgun",
				},
				{
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_commander_backup_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.enemy_spawn_groups.german.commander_squad = {
			amount = amount_easy,
			spawn = {
				{
					freq = 2,
					rank = 2,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_commander_backup",
				},
				{
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_commander_backup_shotgun",
				},
				{
					freq = 1,
					rank = 1,
					tactics = self._tactics.grunt_chargers,
					unit = "german_light_commander_backup_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.enemy_spawn_groups.german.commander_squad = {
			amount = amount_norm,
			spawn = {
				{
					freq = 2,
					rank = 2,
					tactics = self._tactics.gerbish_chargers,
					unit = "german_heavy_commander_backup",
				},
				{
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_chargers,
					unit = "german_heavy_commander_backup_shotgun",
				},
				{
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_chargers,
					unit = "german_heavy_commander_backup_kar98",
				},
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.enemy_spawn_groups.german.commander_squad = {
			amount = amount_norm,
			spawn = {
				{
					freq = 3,
					rank = 2,
					tactics = self._tactics.gerbish_chargers,
					unit = "german_gasmask_commander_backup",
				},
				{
					freq = 1,
					rank = 1,
					tactics = self._tactics.gerbish_chargers,
					unit = "german_gasmask_commander_backup_shotgun",
				},
			},
		}
	end

	self.enemy_spawn_groups.german.recon_grunt_chargers = {
		amount = amount_hard,
		spawn = {
			{
				amount_min = 2,
				freq = 2,
				rank = 2,
				tactics = self._tactics.grunt_chargers,
				unit = "german_grunt_light",
			},
			{
				amount_min = 0,
				freq = 2,
				rank = 1,
				tactics = self._tactics.grunt_chargers,
				unit = "german_grunt_mid",
			},
		},
	}
	self.enemy_spawn_groups.german.recon_grunt_flankers = {
		amount = amount_hard,
		spawn = {
			{
				amount_min = 2,
				freq = 2,
				rank = 2,
				tactics = self._tactics.grunt_chargers,
				unit = "german_grunt_light",
			},
			{
				amount_min = 0,
				freq = 2,
				rank = 1,
				tactics = self._tactics.grunt_chargers,
				unit = "german_grunt_mid",
			},
		},
	}
	self.enemy_spawn_groups.german.recon_grunt_support_range = {
		amount = amount_hard,
		spawn = {
			{
				amount_min = 2,
				freq = 2,
				rank = 2,
				tactics = self._tactics.grunt_chargers,
				unit = "german_grunt_light",
			},
			{
				amount_min = 0,
				freq = 2,
				rank = 1,
				tactics = self._tactics.grunt_chargers,
				unit = "german_grunt_mid",
			},
		},
	}
end

function GroupAITweakData:_init_task_data(difficulty_index, difficulty)
	self.difficulty_curve_points = {
		0.5,
		0.75,
		1,
	}
	self.smoke_and_flash_grenade_timeout = {
		10,
		20,
	}
	self.smoke_grenade_lifetime = 7.5
	self.flash_grenade_lifetime = 7.5
	self.optimal_trade_distance = {
		0,
		0,
	}
	self.bain_assault_praise_limits = {
		1,
		3,
	}
	self.phalanx.minions.min_count = 4
	self.phalanx.minions.amount = 10
	self.phalanx.minions.distance = 100
	self.phalanx.vip.health_ratio_flee = 0.2
	self.phalanx.vip.damage_reduction = {
		increase = 0.05,
		increase_intervall = 5,
		max = 0.5,
		start = 0.1,
	}
	self.phalanx.check_spawn_intervall = 120
	self.phalanx.chance_increase_intervall = 120

	if difficulty_index == TweakData.DIFFICULTY_3 then
		self.phalanx.spawn_chance = {
			decrease = 0.7,
			increase = 0.05,
			max = 1,
			respawn_delay = 300000,
			start = 0,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.phalanx.spawn_chance = {
			decrease = 0.7,
			increase = 0.09,
			max = 1,
			respawn_delay = 300000,
			start = 0.01,
		}
	else
		self.phalanx.spawn_chance = {
			decrease = 0,
			increase = 0,
			max = 0,
			respawn_delay = 120,
			start = 0,
		}
	end
end

function GroupAITweakData:_read_mission_preset(tweak_data)
	if not Global.game_settings then
		return
	end

	local lvl_tweak_data = tweak_data.levels[Global.game_settings.level_id]

	self._mission_preset = lvl_tweak_data.group_ai_preset
end

function GroupAITweakData:_create_table_structure()
	self.enemy_spawn_groups = {}
	self.phalanx = {
		minions = {},
		spawn_chance = {},
		vip = {},
	}
end
