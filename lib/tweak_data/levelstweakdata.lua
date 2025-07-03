LevelsTweakData = LevelsTweakData or class()

function LevelsTweakData:init()
	self.altitude_difference_limit = 300
	self.streaming_level = {
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/streaming_level",
	}
	self.camp = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/germany_camp",
	}
	self.tutorial = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/zone_germany_tutorial",
	}
	self.flakturm = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/flakturm",
	}
	self.gold_rush = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/gold_rush",
	}
	self.reichsbank_streets = {
		world_name = "instances/level_specific/reichsbank/streets_ending01",
	}
	self.train_yard = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/train_yard",
	}
	self.ger_bridge = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/bridge",
	}
	self.radio_defense = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/radio_defense",
	}
	self.settlement = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/castle",
	}
	self.forest_gumpy = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/forest_gumpy",
	}
	self.zone_germany_park = {
		load_env = true,
		low_poly = "",
		map = {
			default = {
				base_icon = "map_ico_camp",
				base_location = {
					x = -200,
					y = -2850,
				},
				panel_shape = {
					h = 710,
					w = 885,
					x = 105,
					y = 220,
				},
				pin_scale = 0.5,
				texture = "map_zone_germany",
				world_borders = {
					down = -28846,
					left = -29736,
					right = 34700,
					up = 23122,
				},
			},
		},
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/zone_germany_park",
	}
	self.zone_germany_destroyed = {
		load_env = true,
		low_poly = "",
		map = self.zone_germany_park.map,
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/zone_germany_destroyed",
	}
	self.zone_germany_destroyed_fuel = {
		load_env = true,
		low_poly = "",
		map = self.zone_germany_park.map,
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/zone_germany_destroyed_fuel",
	}
	self.zone_germany_roundabout = {
		load_env = true,
		low_poly = "",
		map = self.zone_germany_park.map,
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/zone_germany_roundabout",
	}
	self.zone_germany_roundabout_fuel = {
		load_env = true,
		low_poly = "",
		map = self.zone_germany_park.map,
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/zone_germany_roundabout_fuel",
	}
	self.bunker_test = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/bunker_test",
	}
	self.tnd = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/tnd",
	}
	self.hunters = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/hunters",
	}
	self.convoy = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/convoy",
	}
	self.spies_test = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/spies_test_layout",
	}
	self.sto = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "vanilla/sto",
	}
	self.silo = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "upg_002/silo/silo_start",
	}
	self.silo_mid_v1 = {
		world_name = "upg_002/silo/silo_mid_v1",
	}
	self.silo_mid_v2 = {
		world_name = "upg_002/silo/silo_mid_v2",
	}
	self.silo_end = {
		world_name = "upg_002/silo/silo_end",
	}
	self.kelly = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "upg_003/kelly",
	}
	self.fury_railway = {
		load_env = true,
		low_poly = "",
		package = {
			"packages/zone_germany",
		},
		world_name = "upg_005/fury_railway",
	}
	self.forest_bunker = {
		load_env = true,
		low_poly = "",
		map = {
			bunker = {
				panel_shape = {
					h = 472,
					w = 750,
					x = 140,
					y = 312,
				},
				pin_scale = 0.8,
				texture = "map_forest_bunker_int",
				world_borders = {
					down = 900,
					left = -6000,
					right = -1400,
					up = 4030,
				},
			},
			default = {
				base_icon = "map_ico_bunker",
				base_location = {
					x = -3600,
					y = 2500,
				},
				panel_shape = {
					h = 635,
					w = 790,
					x = 135,
					y = 240,
				},
				pin_scale = 0.5,
				texture = "map_forest_bunker",
				world_borders = {
					down = -11900,
					left = -16000,
					right = 16900,
					up = 14400,
				},
			},
		},
		package = {
			"packages/zone_germany",
		},
		world_name = "upg_fb/forest_bunker",
	}
	self._level_index = {
		"streaming_level",
		"germany_zone",
		"zone_germany",
		"flakturm",
		"gold_rush",
		"train_yard",
		"ger_bridge",
		"radio_defense",
		"settlement",
		"forest_gumpy",
		"tutorial",
		"bunker_test",
		"tnd",
		"hunters",
		"convoy",
		"spies_test",
		"sto",
		"silo",
		"kelly",
		"fury_railway",
		"forest_bunker",
	}
end

function LevelsTweakData:get_level_index()
	return self._level_index
end

function LevelsTweakData:get_index_from_world_name(world_name)
	for index, level_id in ipairs(self._level_index) do
		local entry = self[level_id]

		if entry and world_name == entry.world_name then
			return index
		end
	end
end

function LevelsTweakData:get_index_from_level_id(level_id)
	for index, entry_name in ipairs(self._level_index) do
		if entry_name == level_id then
			return index
		end
	end
end

function LevelsTweakData:get_level_id_from_index(index)
	return self._level_index[index]
end

function LevelsTweakData:get_level_id_from_world_name(world_name)
	for _, level_id in ipairs(self._level_index) do
		local entry = self[level_id]

		if entry and world_name == entry.world_name then
			return level_id
		end
	end
end

function LevelsTweakData:get_world_name_from_level_id(level_id)
	local entry = self[level_id]

	return entry and entry.world_name
end

function LevelsTweakData:get_world_name_from_index(index)
	local level_id = self._level_index[index]

	return level_id and self:get_world_name_from_level_id(level_id)
end

function LevelsTweakData:requires_dlc(level_id)
	local entry = self[level_id]

	return entry and entry.dlc
end

function LevelsTweakData:requires_dlc_by_index(index)
	local level_id = self._level_index[index]

	return level_id and self:requires_dlc(level_id)
end

function LevelsTweakData:get_default_team_ID(type)
	local entry = self[Global.level_data.level_id]
	local default_team = entry and entry.default_teams and entry.default_teams[type]

	if default_team then
		if entry.teams[default_team] then
			return default_team
		end

		debug_pause("[LevelsTweakData:get_default_player_team_ID] Team not defined ", default_team, "in", Global.level_data.level_id)
	end

	if type == "player" then
		return "criminal1"
	elseif type == "combatant" then
		return "law1"
	elseif type == "non_combatant" then
		return "neutral1"
	else
		return "mobster1"
	end
end

function LevelsTweakData:get_team_setup()
	local lvl_tweak

	if Application:editor() and managers.editor then
		lvl_tweak = self[managers.editor:layer("Level Settings"):get_setting("simulation_level_id")]
	else
		lvl_tweak = Global.level_data and Global.level_data.level_id and self[Global.level_data.level_id]
	end

	local teams = lvl_tweak and lvl_tweak.teams

	if teams then
		teams = deep_clone(teams)
	else
		teams = {
			converted_enemy = {
				foes = {
					law1 = true,
					mobster1 = true,
				},
			},
			criminal1 = {
				foes = {
					law1 = true,
					mobster1 = true,
				},
			},
			hacked_turret = {
				foes = {
					law1 = true,
					mobster1 = true,
				},
			},
			law1 = {
				foes = {
					converted_enemy = true,
					criminal1 = true,
					mobster1 = true,
				},
			},
			mobster1 = {
				foes = {
					converted_enemy = true,
					criminal1 = true,
					law1 = true,
				},
			},
			neutral1 = {
				foes = {},
			},
		}

		for id, team in pairs(teams) do
			team.id = id
		end
	end

	return teams
end

function LevelsTweakData:get_default_team_IDs()
	local lvl_tweak

	if Application:editor() and managers.editor then
		lvl_tweak = self[managers.editor:layer("Level Settings"):get_setting("simulation_level_id")]
	else
		lvl_tweak = Global.level_data and Global.level_data.level_id and self[Global.level_data.level_id]
	end

	local default_team_IDs = lvl_tweak and lvl_tweak.default_teams

	default_team_IDs = default_team_IDs or {
		combatant = self:get_default_team_ID("combatant"),
		gangster = self:get_default_team_ID("gangster"),
		non_combatant = self:get_default_team_ID("non_combatant"),
		player = self:get_default_team_ID("player"),
	}

	return default_team_IDs
end

function LevelsTweakData:get_team_names_indexed()
	local teams_index = self._teams_index

	if not teams_index then
		teams_index = {}

		local teams = self:get_team_setup()

		for team_id, team_data in pairs(teams) do
			table.insert(teams_index, team_id)
		end

		table.sort(teams_index)

		self._teams_index = teams_index
	end

	return teams_index
end

function LevelsTweakData:get_team_index(team_id)
	local teams_index = self:get_team_names_indexed()

	for index, test_team_id in ipairs(teams_index) do
		if team_id == test_team_id then
			return index
		end
	end
end
