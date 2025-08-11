GroupAIRaidTweakData = GroupAIRaidTweakData or class()

function GroupAIRaidTweakData:init(difficulty_index)
	Application:debug("[GroupAITweakData:init] Mode: Raid, difficulty_index", difficulty_index)

	self.max_spawning_distance = 15000
	self.min_spawning_distance = 700
	self.max_spawning_height_diff = 1440000
	self.max_distance_to_player = 100000000
	self.max_important_distance = 9000000
	self.spawn_camp_added_delay = {
		20,
		15,
		10,
	}
	self.spawn_camp_distance = 700
	self.spawn_camp_z_distance = 300
	self.regroup = {
		duration = 15,
	}
	self.recurring_group_SO = {
		recurring_spawn_1 = {
			interval = {
				30,
				60,
			},
		},
	}

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.special_unit_spawn_limits = {
			commander = 0,
			flamer = 0,
		}
		self.special_unit_cooldowns = {
			commander = {
				0,
				0,
				0,
			},
			flamer = {
				0,
				0,
				0,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.special_unit_spawn_limits = {
			commander = 1,
			flamer = 1,
		}
		self.special_unit_cooldowns = {
			commander = {
				300,
				270,
				240,
			},
			flamer = {
				140,
				120,
				120,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.special_unit_spawn_limits = {
			commander = 1,
			flamer = 2,
		}
		self.special_unit_cooldowns = {
			commander = {
				180,
				150,
				120,
			},
			flamer = {
				120,
				90,
				65,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.special_unit_spawn_limits = {
			commander = 1,
			flamer = 3,
		}
		self.special_unit_cooldowns = {
			commander = {
				150,
				130,
				100,
			},
			flamer = {
				80,
				60,
				45,
			},
		}
	end

	self.assault = {}
	self.assault.anticipation_duration = 15
	self.assault.build_duration = 30
	self.assault.sustain_duration_min = {
		100,
		120,
		140,
	}
	self.assault.sustain_duration_max = {
		120,
		150,
		180,
	}
	self.assault.sustain_duration_balance_mul = {
		1,
		1.1,
		1.15,
		1.25,
	}
	self.assault.fade_duration = 10
	self.assault.fade_enemy_limit = 7
	self.assault.fade_task_timeout = 10
	self.assault.fade_drama_timeout = 20

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.assault.delay = {
			30,
			30,
			28,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.assault.delay = {
			30,
			28,
			25,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.assault.delay = {
			27,
			23,
			20,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.assault.delay = {
			25,
			20,
			15,
		}
	end

	self.assault.retarget_chance = 0.5
	self.assault.retarget_chance_mul = 0.42
	self.assault.force = {
		10,
		13,
		16,
		18,
	}
	self.assault.spawn_pool = {
		55,
		60,
		68,
		74,
	}

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.assault.force_balance_mul = {
			0.9,
			1,
			1.17,
			1.32,
		}
		self.assault.spawn_pool_balance_mul = {
			0.9,
			1,
			1.17,
			1.32,
		}
		self.assault.charge_delay = {
			3,
			3,
			2,
			1,
		}
		self.assault.push_delay = {
			10,
			8,
			5,
			5,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.assault.force_balance_mul = {
			1,
			1.13,
			1.28,
			1.4,
		}
		self.assault.spawn_pool_balance_mul = {
			1,
			1.13,
			1.28,
			1.4,
		}
		self.assault.charge_delay = {
			2,
			2,
			1,
			0,
		}
		self.assault.push_delay = {
			10,
			8,
			5,
			4,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.assault.force_balance_mul = {
			1.05,
			1.14,
			1.33,
			1.55,
		}
		self.assault.spawn_pool_balance_mul = {
			1.04,
			1.14,
			1.33,
			1.55,
		}
		self.assault.charge_delay = {
			2,
			2,
			1,
			0,
		}
		self.assault.push_delay = {
			8,
			6,
			5,
			4,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.assault.force_balance_mul = {
			1.08,
			1.2,
			1.4,
			1.6,
		}
		self.assault.spawn_pool_balance_mul = {
			1.07,
			1.17,
			1.4,
			1.6,
		}
		self.assault.charge_delay = {
			2,
			2,
			0,
			0,
		}
		self.assault.push_delay = {
			7,
			5,
			3,
			3,
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.assault.groups = {
			gerbish_chargers = {
				25,
				40,
				65,
			},
			gerbish_flankers = {
				25,
				36,
				54,
			},
			gerbish_rifle_range = {
				15,
				23,
				30,
			},
			grunt_chargers = {
				50,
				65,
				0,
			},
			grunt_flankers = {
				30,
				27,
				20,
			},
			grunt_support_range = {
				30,
				22,
				18,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.assault.groups = {
			commanders = {
				0,
				2,
				3,
			},
			flamethrower = {
				3,
				4,
				5,
			},
			gerbish_chargers = {
				25,
				40,
				65,
			},
			gerbish_flankers = {
				25,
				36,
				54,
			},
			gerbish_rifle_range = {
				15,
				23,
				30,
			},
			grunt_chargers = {
				50,
				65,
				0,
			},
			grunt_flankers = {
				30,
				27,
				20,
			},
			grunt_support_range = {
				30,
				22,
				18,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.assault.groups = {
			commanders = {
				2,
				4,
				6,
			},
			fallschirm_charge = {
				25,
				40,
				65,
			},
			fallschirm_flankers = {
				15,
				32,
				54,
			},
			fallschirm_support = {
				15,
				25,
				30,
			},
			flamethrower = {
				4,
				5,
				8,
			},
			gerbish_chargers = {
				50,
				42,
				20,
			},
			gerbish_flankers = {
				30,
				27,
				20,
			},
			gerbish_rifle_range = {
				30,
				22,
				18,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.assault.groups = {
			commanders = {
				3,
				5,
				6,
			},
			fallschirm_charge = {
				38,
				45,
				50,
			},
			fallschirm_flankers = {
				38,
				45,
				50,
			},
			fallschirm_support = {
				35,
				37,
				40,
			},
			flamethrower = {
				4,
				5,
				8,
			},
			gerbish_chargers = {
				20,
				14,
				11,
			},
			gerbish_flankers = {
				18,
				14,
				11,
			},
		}
	end

	self.assault.group_overrides = {}

	if difficulty_index == TweakData.DIFFICULTY_2 then
		self.assault.group_overrides.commander = {
			commander_squad = {
				38,
				44,
				50,
			},
			commanders = {
				0,
				0,
				0,
			},
			flamethrower = {
				2,
				3,
				5,
			},
			gerbish_chargers = {
				0,
				0,
			},
			gerbish_flankers = {
				25,
				36,
				54,
			},
			gerbish_rifle_range = {
				15,
				23,
				30,
			},
			grunt_chargers = {
				0,
				0,
			},
			grunt_flankers = {
				0,
				0,
			},
			grunt_support_range = {
				0,
				0,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.assault.group_overrides.commander = {
			commander_squad = {
				38,
				44,
				50,
			},
			commanders = {
				0,
				0,
				0,
			},
			fallschirm_charge = {
				0,
				0,
			},
			fallschirm_flankers = {
				25,
				36,
				54,
			},
			fallschirm_support = {
				15,
				23,
				30,
			},
			flamethrower = {
				2,
				3,
				6,
			},
			gerbish_chargers = {
				0,
				0,
			},
			gerbish_flankers = {
				0,
				0,
			},
			gerbish_rifle_range = {
				0,
				0,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.assault.group_overrides.commander = {
			commander_squad = {
				38,
				44,
				50,
			},
			commanders = {
				0,
				0,
			},
			fallschirm_charge = {
				0,
				0,
			},
			fallschirm_flankers = {
				0,
				0,
			},
			fallschirm_support = {
				0,
				0,
			},
			flamethrower = {
				2,
				4,
				7,
			},
			gerbish_chargers = {
				0,
				0,
			},
			gerbish_flankers = {
				0,
				0,
			},
			ss_flankers = {
				25,
				36,
				54,
			},
			ss_rifle_range = {
				15,
				23,
				30,
			},
		}
	end

	self.reenforce = {}
	self.reenforce.interval = {
		10,
		15,
		20,
		30,
	}

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.reenforce.groups = {
			grunt_reenforcer = {
				50,
				50,
				50,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.reenforce.groups = {
			grunt_reenforcer = {
				50,
				50,
				50,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.reenforce.groups = {
			gerbish_reenforcer = {
				40,
				50,
				50,
			},
			grunt_reenforcer = {
				30,
				20,
				10,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.reenforce.groups = {
			fallschirm_reenforcer = {
				40,
				50,
				50,
			},
			gerbish_reenforcer = {
				30,
				25,
				10,
			},
			grunt_reenforcer = {
				10,
				5,
				5,
			},
		}
	end

	self.recon = {}
	self.recon.interval = {
		5,
		5,
		5,
	}
	self.recon.interval_variation = 40
	self.recon.force = {
		2,
		4,
		6,
	}

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.recon.groups = {
			grunt_chargers = {
				10,
				10,
				10,
			},
			grunt_flankers = {
				10,
				10,
				10,
			},
			grunt_support_range = {
				10,
				10,
				10,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.recon.groups = {
			grunt_chargers = {
				10,
				10,
				10,
			},
			grunt_flankers = {
				10,
				10,
				10,
			},
			grunt_support_range = {
				10,
				10,
				10,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.recon.groups = {
			gerbish_chargers = {
				10,
				10,
				10,
			},
			gerbish_flankers = {
				10,
				10,
				10,
			},
			gerbish_rifle_range = {
				10,
				10,
				10,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.recon.groups = {
			fallschirm_charge = {
				10,
				10,
				10,
			},
			fallschirm_flankers = {
				10,
				10,
				10,
			},
			fallschirm_support = {
				10,
				10,
				10,
			},
		}
	end
end
