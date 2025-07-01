GroupAIRaidTweakData = GroupAIRaidTweakData or class()

function GroupAIRaidTweakData:init(difficulty_index)
	Application:debug("[GroupAITweakData:init] Mode: Raid, difficulty_index", difficulty_index)

	self.regroup = {}
	self.assault = {
		force = {},
	}
	self.reenforce = {}
	self.recon = {}
	self.rescue = {}
	self.cloaker = {}
	self.max_spawning_distance = 15000
	self.min_spawning_distance = 700
	self.max_spawning_height_diff = 1440000
	self.max_distance_to_player = 100000000
	self.recurring_group_SO = {
		recurring_spawn_1 = {
			interval = {
				30,
				60,
			},
		},
	}
	self.regroup.duration = {
		15,
		15,
		15,
	}
	self.assault = {}
	self.assault.anticipation_duration = {
		{
			15,
			1,
		},
		{
			15,
			1,
		},
		{
			15,
			1,
		},
	}
	self.assault.build_duration = 15
	self.assault.sustain_duration_min = {
		100,
		120,
		140,
	}
	self.assault.sustain_duration_max = {
		120,
		140,
		160,
	}
	self.assault.sustain_duration_balance_mul = {
		1,
		1.1,
		1.15,
		1.25,
	}
	self.assault.fade_duration = 10
	self.assault.enemy_low_limit = 7
	self.assault.task_timeout = 20
	self.assault.drama_timeout = 35

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

	self.assault.hostage_hesitation_delay = {
		0,
		0,
		0,
	}
	self.assault.force = {
		8,
		12,
		15,
		18,
	}
	self.assault.force_pool = {
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
		self.assault.force_pool_balance_mul = {
			0.9,
			1,
			1.17,
			1.32,
		}
		self.assault.push_delay = {
			6.5,
			4.5,
			3.5,
			3,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.assault.force_balance_mul = {
			1,
			1.13,
			1.28,
			1.4,
		}
		self.assault.force_pool_balance_mul = {
			1,
			1.13,
			1.28,
			1.4,
		}
		self.assault.push_delay = {
			6.5,
			4.5,
			3.5,
			3,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.assault.force_balance_mul = {
			1.04,
			1.14,
			1.33,
			1.55,
		}
		self.assault.force_pool_balance_mul = {
			1.04,
			1.14,
			1.33,
			1.55,
		}
		self.assault.push_delay = {
			6.25,
			4.25,
			3.25,
			2.75,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.assault.force_balance_mul = {
			1.07,
			1.16,
			1.4,
			1.7,
		}
		self.assault.force_pool_balance_mul = {
			1.07,
			1.16,
			1.4,
			1.7,
		}
		self.assault.push_delay = {
			6,
			4,
			3,
			2.5,
		}
	end

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.assault.groups = {
			gerbish_chargers = {
				40,
				75,
				75,
			},
			gerbish_flankers = {
				30,
				75,
				75,
			},
			gerbish_rifle_range = {
				30,
				40,
				30,
			},
			grunt_chargers = {
				75,
				80,
				0,
			},
			grunt_flankers = {
				75,
				75,
				75,
			},
			grunt_support_range = {
				40,
				40,
				40,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.assault.groups = {
			commander_squad = {
				0,
				25,
				35,
			},
			commanders = {
				0,
				2,
				3,
			},
			flamethrower = {
				1,
				2,
				4,
			},
			gerbish_chargers = {
				40,
				75,
				75,
			},
			gerbish_flankers = {
				30,
				75,
				75,
			},
			gerbish_rifle_range = {
				30,
				40,
				30,
			},
			grunt_chargers = {
				75,
				80,
				0,
			},
			grunt_flankers = {
				75,
				75,
				75,
			},
			grunt_support_range = {
				40,
				40,
				40,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.assault.groups = {
			commander_squad = {
				30,
				45,
				60,
			},
			commanders = {
				1,
				4,
				6,
			},
			fallschirm_charge = {
				30,
				75,
				75,
			},
			fallschirm_flankers = {
				0,
				75,
				75,
			},
			fallschirm_support = {
				0,
				40,
				40,
			},
			flamethrower = {
				5,
				8,
				10,
			},
			gerbish_chargers = {
				75,
				75,
				30,
			},
			gerbish_flankers = {
				75,
				75,
				30,
			},
			gerbish_rifle_range = {
				40,
				40,
				20,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.assault.groups = {
			commander_squad = {
				60,
				70,
				80,
			},
			commanders = {
				2,
				6,
				8,
			},
			fallschirm_charge = {
				75,
				75,
				40,
			},
			fallschirm_flankers = {
				75,
				75,
				40,
			},
			fallschirm_support = {
				40,
				40,
				30,
			},
			flamethrower = {
				8,
				10,
				13,
			},
			ss_chargers = {
				30,
				75,
				75,
			},
			ss_flankers = {
				30,
				75,
				75,
			},
			ss_rifle_range = {
				0,
				40,
				75,
			},
		}
	end

	self.reenforce.interval = {
		10,
		15,
		20,
		30,
	}

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.reenforce.groups = {
			gerbish_chargers = {
				30,
				30,
				30,
			},
			gerbish_flankers = {
				20,
				20,
				20,
			},
			gerbish_rifle_range = {
				20,
				20,
				20,
			},
			grunt_chargers = {
				50,
				50,
				50,
			},
			grunt_flankers = {
				40,
				40,
				40,
			},
			grunt_support_range = {
				40,
				40,
				40,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.reenforce.groups = {
			gerbish_chargers = {
				50,
				50,
				50,
			},
			gerbish_flankers = {
				40,
				40,
				40,
			},
			gerbish_rifle_range = {
				40,
				40,
				40,
			},
			grunt_chargers = {
				30,
				30,
				30,
			},
			grunt_flankers = {
				20,
				20,
				20,
			},
			grunt_support_range = {
				20,
				20,
				20,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.reenforce.groups = {
			fallschirm_charge = {
				50,
				50,
				50,
			},
			fallschirm_flankers = {
				40,
				40,
				40,
			},
			fallschirm_support = {
				40,
				40,
				40,
			},
			gerbish_chargers = {
				30,
				30,
				30,
			},
			gerbish_flankers = {
				20,
				20,
				20,
			},
			gerbish_rifle_range = {
				20,
				20,
				20,
			},
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.reenforce.groups = {
			fallschirm_charge = {
				30,
				30,
				30,
			},
			fallschirm_flankers = {
				20,
				20,
				20,
			},
			fallschirm_support = {
				20,
				20,
				20,
			},
			ss_chargers = {
				50,
				50,
				50,
			},
			ss_flankers = {
				40,
				40,
				40,
			},
			ss_rifle_range = {
				40,
				40,
				40,
			},
		}
	end

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
