LevelsTweakData = LevelsTweakData or class()

function LevelsTweakData:init()
	self.altitude_difference_limit = 300
	self.editor_level = "zone_germany_park"
	self.streaming_level = {}
	self.streaming_level.name_id = "menu_stream"
	self.streaming_level.world_name = "vanilla/streaming_level"
	self.streaming_level.cube = "cube_apply_heist_bank"
	self.camp = {}
	self.camp.name_id = "menu_camp_hl"
	self.camp.briefing_id = "menu_germany_desc"
	self.camp.world_name = "vanilla/germany_camp"
	self.camp.cube = "cube_apply_heist_bank"
	self.tutorial = {}
	self.tutorial.name_id = "menu_tutorial_hl"
	self.tutorial.briefing_id = "menu_tutorial_briefing"
	self.tutorial.world_name = "vanilla/zone_germany_tutorial"
	self.tutorial.predefined_world = "tutorial"
	self.tutorial.package = {
		"packages/zone_germany",
	}
	self.tutorial.cube = "cube_apply_heist_bank"
	self.flakturm = {}
	self.flakturm.name_id = "menu_ger_miss_01_hl"
	self.flakturm.briefing_id = "menu_ger_miss_01_desc"
	self.flakturm.world_name = "vanilla/flakturm"
	self.flakturm.predefined_world = "germany_flakturm"
	self.flakturm.cube = "cube_apply_heist_bank"
	self.hunters = {}
	self.hunters.name_id = "hunters"
	self.hunters.briefing_id = "hunters_briefing"
	self.hunters.world_name = "vanilla/hunters"
	self.hunters.predefined_world = "hunters"
	self.hunters.cube = "cube_apply_heist_bank"
	self.train_yard = {}
	self.train_yard.name_id = "menu_ger_miss_04_hl"
	self.train_yard.briefing_id = "menu_ger_miss_04_desc"
	self.train_yard.world_name = "vanilla/train_yard"
	self.train_yard.predefined_world = "germany_train_yard"
	self.train_yard.cube = "cube_apply_heist_bank"
	self.ger_bridge = {}
	self.ger_bridge.name_id = "menu_ger_bridge_00_hl"
	self.ger_bridge.briefing_id = "menu_ger_bridge_00_desc"
	self.ger_bridge.world_name = "vanilla/bridge"
	self.ger_bridge.predefined_world = "germany_bridge"
	self.ger_bridge.cube = "cube_apply_heist_bank"
	self.tnd = {}
	self.tnd.name_id = "tnd"
	self.tnd.briefing_id = "tnd_briefing"
	self.tnd.world_name = "vanilla/tnd"
	self.tnd.cube = "cube_apply_heist_bank"
	self.tnd.predefined_world = "tnd"
	self._level_index = {
		"streaming_level",
		"flakturm",
		"ger_bridge",
		"tutorial",
		"tnd",
		"hunters",
		"train_yard",
	}
	self.escape_levels = {}
end

function LevelsTweakData:get_level_index()
	return self._level_index
end

function LevelsTweakData:get_world_name_from_index(index)
	if not self._level_index[index] then
		return
	end

	return self[self._level_index[index]].world_name
end

function LevelsTweakData:get_level_name_from_index(index)
	return self._level_index[index]
end

function LevelsTweakData:get_index_from_world_name(world_name)
	for index, entry_name in ipairs(self._level_index) do
		if world_name == self[entry_name].world_name then
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

function LevelsTweakData:requires_dlc(level_id)
	return self[level_id].dlc
end

function LevelsTweakData:requires_dlc_by_index(index)
	return self[self._level_index[index]].dlc
end

function LevelsTweakData:get_level_name_from_world_name(world_name)
	for _, entry_name in ipairs(self._level_index) do
		if world_name == self[entry_name].world_name then
			return entry_name
		end
	end
end

function LevelsTweakData:get_localized_level_name_from_world_name(world_name)
	for _, entry_name in ipairs(self._level_index) do
		if world_name == self[entry_name].world_name then
			return managers.localization:text(self[entry_name].name_id)
		end
	end
end

function LevelsTweakData:get_localized_level_name_from_level_id(level_id)
	for _, entry_name in ipairs(self._level_index) do
		if level_id == entry_name then
			return managers.localization:text(self[entry_name].name_id)
		end
	end
end

function LevelsTweakData:get_default_team_ID(type)
	local lvl_tweak = self[Global.level_data.level_id]

	if lvl_tweak and lvl_tweak.default_teams and lvl_tweak.default_teams[type] then
		if lvl_tweak.teams[lvl_tweak.default_teams[type]] then
			return lvl_tweak.default_teams[type]
		else
			debug_pause("[LevelsTweakData:get_default_player_team_ID] Team not defined ", lvl_tweak.default_teams[type], "in", Global.level_data.level_id)
		end
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
