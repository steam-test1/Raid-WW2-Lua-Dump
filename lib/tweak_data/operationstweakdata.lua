OperationsTweakData = OperationsTweakData or class()
OperationsTweakData.JOB_TYPE_RAID = 1
OperationsTweakData.JOB_TYPE_OPERATION = 2
OperationsTweakData.PROGRESSION_GROUP_SHORT = "short"
OperationsTweakData.PROGRESSION_GROUP_STANDARD = "standard"
OperationsTweakData.PROGRESSION_GROUP_INITIAL_LONG = "initial_long"
OperationsTweakData.PROGRESSION_GROUP_INITIAL_MEDIUM = "initial_medium"
OperationsTweakData.PROGRESSION_GROUP_INITIAL_SHORT = "initial_short"
OperationsTweakData.PROGRESSION_GROUPS = {
	OperationsTweakData.PROGRESSION_GROUP_INITIAL_LONG,
	OperationsTweakData.PROGRESSION_GROUP_INITIAL_MEDIUM,
	OperationsTweakData.PROGRESSION_GROUP_INITIAL_SHORT,
	OperationsTweakData.PROGRESSION_GROUP_SHORT,
	OperationsTweakData.PROGRESSION_GROUP_STANDARD,
}
OperationsTweakData.RAID_NOT_STEALTHABLE = "whisper_info_starts_loud"
OperationsTweakData.RAID_STARTS_STEALTHABLE = "whisper_info_starts_stealth"
OperationsTweakData.RAID_MOSTLY_STEALTHABLE = "whisper_info_mostly_stealthable"
OperationsTweakData.RAID_COMPLETELY_STEALTHABLE = "whisper_info_completely_stealthable"
OperationsTweakData.IN_LOBBY = "in_lobby"
OperationsTweakData.STATE_ZONE_MISSION_SELECTED = "system_zone_mission_selected"
OperationsTweakData.STATE_LOCATION_MISSION_SELECTED = "system_location_mission_selected"
OperationsTweakData.ENTRY_POINT_LEVEL = "streaming_level"

function OperationsTweakData:init()
	self.missions = {}

	self:_init_loading_screens()
	self:_init_regions()
	self:_init_raids()
	self:_init_operations()
	self:_init_progression_data()
	self:_init_consumable_missions_data()
	self:_init_bounty_data()
end

function OperationsTweakData:_init_regions()
	self.regions = {
		"germany",
		"france",
		"africa",
	}
end

function OperationsTweakData:_init_progression_data()
	self.progression = {}
	self.progression.initially_unlocked_difficulty = TweakData.DIFFICULTY_3
	self.progression.bounty_locked_below_difficulty = TweakData.DIFFICULTY_3
	self.progression.unlock_cycles = 6
	self.progression.regular_unlock_cycle_duration = 420
	self.progression.final_unlock_cycle_duration = 1000
	self.progression.operations_unlock_level = 10
	self.progression.initial_mission_unlock_blueprint = {
		OperationsTweakData.PROGRESSION_GROUP_INITIAL_LONG,
		OperationsTweakData.PROGRESSION_GROUP_INITIAL_MEDIUM,
		OperationsTweakData.PROGRESSION_GROUP_INITIAL_SHORT,
		OperationsTweakData.PROGRESSION_GROUP_INITIAL_SHORT,
	}
	self.progression.regular_mission_unlock_blueprint = {
		OperationsTweakData.PROGRESSION_GROUP_STANDARD,
		OperationsTweakData.PROGRESSION_GROUP_SHORT,
		OperationsTweakData.PROGRESSION_GROUP_SHORT,
	}
	self.progression.mission_groups = {}

	for index, group in pairs(OperationsTweakData.PROGRESSION_GROUPS) do
		self.progression.mission_groups[group] = {}

		for mission_name, mission_data in pairs(self.missions) do
			if mission_data.progression_groups then
				for j = 1, #mission_data.progression_groups do
					if mission_data.progression_groups[j] == group then
						table.insert(self.progression.mission_groups[group], mission_name)

						break
					end
				end
			end
		end
	end
end

function OperationsTweakData:_init_consumable_missions_data()
	self.consumable_missions = {}
	self.consumable_missions.base_document_spawn_chance = {
		0.15,
		0.2,
		0.25,
		0.3,
	}
	self.consumable_missions.spawn_chance_modifier_increase = 0.1
end

function OperationsTweakData:_init_bounty_data()
	self.bounty_data = {}
	self.bounty_data.job_potential = {
		bunker_test = true,
		clear_skies_flakturm = true,
		clear_skies_gold_rush = true,
		clear_skies_radio_defense = true,
		convoy = true,
		flakturm = true,
		forest_bunker = true,
		ger_bridge = true,
		gold_rush = true,
		hunters = true,
		kelly = true,
		oper_flamable_bridge = true,
		oper_flamable_castle = true,
		radio_defense = true,
		settlement = true,
		silo = true,
		spies_test = true,
		tnd = true,
		train_yard = true,
	}
	self.bounty_data.possible_jobs = table.map_keys(self.bounty_data.job_potential)
end

function OperationsTweakData:_init_loading_screens()
	self._loading_screens = {}
	self._loading_screens.generic = {}
	self._loading_screens.generic.image = "loading_raid_ww2"
	self._loading_screens.generic.text = "loading_generic"
	self._loading_screens.city = {}
	self._loading_screens.city.image = "loading_raid_ww2"
	self._loading_screens.city.text = "loading_german_city"
	self._loading_screens.camp_church = {}
	self._loading_screens.camp_church.image = "loading_raid_ww2"
	self._loading_screens.camp_church.text = "loading_camp"
	self._loading_screens.tutorial = {}
	self._loading_screens.tutorial.image = "loading_raid_ww2"
	self._loading_screens.tutorial.text = "loading_tutorial"
	self._loading_screens.flakturm = {}
	self._loading_screens.flakturm.image = "loading_flak"
	self._loading_screens.flakturm.text = "loading_flaktower"
	self._loading_screens.train_yard = {}
	self._loading_screens.train_yard.image = "loading_raid_ww2"
	self._loading_screens.train_yard.text = "loading_trainyard"
	self._loading_screens.gold_rush = {}
	self._loading_screens.gold_rush.image = "loading_raid_ww2"
	self._loading_screens.gold_rush.text = "loading_treasury"
	self._loading_screens.bridge = {}
	self._loading_screens.bridge.image = "loading_raid_ww2"
	self._loading_screens.bridge.text = "loading_bridge"
	self._loading_screens.castle = {}
	self._loading_screens.castle.image = "loading_raid_ww2"
	self._loading_screens.castle.text = "loading_castle"
	self._loading_screens.radio_defense = {}
	self._loading_screens.radio_defense.image = "loading_raid_ww2"
	self._loading_screens.radio_defense.text = "loading_radio_defense"
	self._loading_screens.gold_rush_oper_01 = {}
	self._loading_screens.gold_rush_oper_01.image = "loading_screens_02"
	self._loading_screens.gold_rush_oper_01.text = "loading_treasury_operation_clear_skies"
	self._loading_screens.radio_defense_oper_01 = {}
	self._loading_screens.radio_defense_oper_01.image = "loading_screens_04"
	self._loading_screens.radio_defense_oper_01.text = "loading_radio_defense_operation_clear_skies"
	self._loading_screens.train_yard_oper_01 = {}
	self._loading_screens.train_yard_oper_01.image = "loading_screens_06"
	self._loading_screens.train_yard_oper_01.text = "loading_trainyard_operation_clear_skies"
	self._loading_screens.flakturm_oper_01 = {}
	self._loading_screens.flakturm_oper_01.image = "loading_screens_07"
	self._loading_screens.flakturm_oper_01.text = "loading_flaktower_operation_clearskies"
	self._loading_screens.bridge_oper_02 = {}
	self._loading_screens.bridge_oper_02.image = "loading_screens_06"
	self._loading_screens.bridge_oper_02.text = "loading_bridge_operation_02"
	self._loading_screens.castle_oper_02 = {}
	self._loading_screens.castle_oper_02.image = "loading_screens_07"
	self._loading_screens.castle_oper_02.text = "loading_castle_operation_02"
	self._loading_screens.forest_gumpy = {}
	self._loading_screens.forest_gumpy.image = "loading_screens_07"
	self._loading_screens.forest_gumpy.text = "loading_castle_operation_02"
	self._loading_screens.bunker_test = {}
	self._loading_screens.bunker_test.image = "loading_screens_07"
	self._loading_screens.bunker_test.text = "loading_bridge"
	self._loading_screens.tnd = {}
	self._loading_screens.tnd.image = "loading_screens_07"
	self._loading_screens.tnd.text = "loading_bridge"
	self._loading_screens.hunters = {}
	self._loading_screens.hunters.image = "loading_screens_07"
	self._loading_screens.hunters.text = "loading_bridge"
	self._loading_screens.convoy = {}
	self._loading_screens.convoy.image = "loading_screens_07"
	self._loading_screens.convoy.text = "loading_bridge"
	self._loading_screens.spies_test = {}
	self._loading_screens.spies_test.image = "loading_screens_07"
	self._loading_screens.spies_test.text = "loading_bridge"
	self._loading_screens.sto = {}
	self._loading_screens.sto.image = "loading_screens_07"
	self._loading_screens.sto.text = "loading_bridge"
	self._loading_screens.silo = {}
	self._loading_screens.silo.image = "loading_screens_07"
	self._loading_screens.silo.text = "loading_bridge"
	self._loading_screens.kelly = {}
	self._loading_screens.kelly.image = "loading_screens_07"
	self._loading_screens.kelly.text = "menu_kelly_loading_desc"
	self._loading_screens.forest_bunker = {}
	self._loading_screens.forest_bunker.image = "loading_screens_07"
	self._loading_screens.forest_bunker.text = "forest_bunker_loading"
end

function OperationsTweakData:get_camp_goto_objective_id(job_id)
	job_id = tostring(job_id)

	local job_data = self.missions[job_id]

	if job_data then
		if job_data.camp_objective_id then
			return job_data.camp_objective_id
		else
			return "obj_camp_goto_raid_" .. job_id
		end
	else
		Application:warn("[OperationsTweakData:get_camp_goto_objective_id] job_data was nil, job_id", job_id)

		return "obj_camp_goto_raid"
	end
end

function OperationsTweakData:_init_raids()
	self._raids_index = {
		"sto",
		"forest_gumpy",
		"fury_railway",
		"hunters",
		"tnd",
		"bunker_test",
		"convoy",
		"spies_test",
		"settlement",
		"radio_defense",
		"train_yard",
		"ger_bridge",
		"flakturm",
		"gold_rush",
		"silo",
		"kelly",
		"forest_bunker",
	}
	self.dogtag_types = {
		large = {
			diff_bonus = 3,
			max = 22,
			min = 16,
		},
		medium = {
			diff_bonus = 2,
			max = 20,
			min = 15,
		},
		small = {
			diff_bonus = 1,
			max = 18,
			min = 14,
		},
	}
	self.missions.streaming_level = {}
	self.missions.streaming_level.name_id = "menu_stream"
	self.missions.streaming_level.level_id = "streaming_level"
	self.missions.camp = {}
	self.missions.camp.name_id = "menu_camp_hl"
	self.missions.camp.level_id = "camp"
	self.missions.camp.briefing_id = "menu_germany_desc"
	self.missions.camp.audio_briefing_id = "menu_enter"
	self.missions.camp.music_id = "camp"
	self.missions.camp.region = "germany"
	self.missions.camp.xp = 0
	self.missions.camp.no_dynamic_objective = true
	self.missions.camp.icon_menu = "missions_camp"
	self.missions.camp.icon_hud = "mission_camp"
	self.missions.camp.loading = {
		image = "camp_loading_screen",
		text = "loading_camp",
	}
	self.missions.camp.loading_success = {
		image = "success_loading_screen_01",
	}
	self.missions.camp.loading_fail = {
		image = "fail_loading_screen_01",
	}
	self.missions.camp.excluded_continents = {}
	self.missions.tutorial = {}
	self.missions.tutorial.name_id = "menu_tutorial_hl"
	self.missions.tutorial.level_id = "tutorial"
	self.missions.tutorial.briefing_id = "menu_tutorial_desc"
	self.missions.tutorial.audio_briefing_id = "flakturm_briefing_long"
	self.missions.tutorial.short_audio_briefing_id = "flakturm_brief_short"
	self.missions.tutorial.music_id = "camp"
	self.missions.tutorial.region = "germany"
	self.missions.tutorial.xp = 0
	self.missions.tutorial.no_dynamic_objective = true
	self.missions.tutorial.debug = true
	self.missions.tutorial.start_in_stealth = true
	self.missions.tutorial.stealth_description = OperationsTweakData.RAID_NOT_STEALTHABLE
	self.missions.tutorial.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.tutorial.mission_flag = "level_tutorial"
	self.missions.tutorial.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.tutorial.icon_menu = "missions_tutorial"
	self.missions.tutorial.icon_hud = "miissions_raid_flaktower"
	self.missions.tutorial.loading = {
		image = "raid_loading_tutorial",
		text = "loading_tutorial",
	}
	self.missions.tutorial.photos = {
		{
			description_id = "forest_mission_photo_1_description",
			photo = "intel_forest_01",
			title_id = "forest_mission_photo_1_title",
		},
		{
			description_id = "forest_mission_photo_2_description",
			photo = "intel_forest_02",
			title_id = "forest_mission_photo_2_title",
		},
		{
			description_id = "forest_mission_photo_3_description",
			photo = "intel_forest_03",
			title_id = "forest_mission_photo_3_title",
		},
		{
			description_id = "forest_mission_photo_4_description",
			photo = "intel_forest_04",
			title_id = "forest_mission_photo_4_title",
		},
	}
	self.missions.flakturm = {}
	self.missions.flakturm.name_id = "menu_ger_miss_01_hl"
	self.missions.flakturm.level_id = "flakturm"
	self.missions.flakturm.briefing_id = "menu_ger_miss_01_desc"
	self.missions.flakturm.audio_briefing_id = "flakturm_briefing_long"
	self.missions.flakturm.short_audio_briefing_id = "flakturm_brief_short"
	self.missions.flakturm.music_id = "flakturm"
	self.missions.flakturm.region = "germany"
	self.missions.flakturm.xp = 5800
	self.missions.flakturm.start_in_stealth = true
	self.missions.flakturm.stealth_description = OperationsTweakData.RAID_MOSTLY_STEALTHABLE
	self.missions.flakturm.dogtags = self.dogtag_types.medium
	self.missions.flakturm.trophy = {
		position = "snap_01",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_flaktower",
	}
	self.missions.flakturm.greed_items = {
		max = 1500,
		min = 1200,
	}
	self.missions.flakturm.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.flakturm.mission_flag = "level_raid_flakturm"
	self.missions.flakturm.bounty_filters = {
		forbid_buffs = {
			BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
			BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
		},
	}
	self.missions.flakturm.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.flakturm.progression_groups = {
		OperationsTweakData.PROGRESSION_GROUP_INITIAL_LONG,
		OperationsTweakData.PROGRESSION_GROUP_STANDARD,
	}
	self.missions.flakturm.icon_menu_big = "xp_events_missions_raid_flaktower"
	self.missions.flakturm.icon_menu = "missions_raid_flaktower_menu"
	self.missions.flakturm.icon_hud = "miissions_raid_flaktower"
	self.missions.flakturm.excluded_continents = {
		"operation",
	}
	self.missions.flakturm.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_b2_assassination_v004",
	}
	self.missions.flakturm.loading = {
		image = "loading_flak",
		text = "menu_ger_miss_01_loading_desc",
	}
	self.missions.flakturm.photos = {
		{
			description_id = "flak_mission_photo_1_description",
			photo = "intel_flak_01",
			title_id = "flak_mission_photo_1_title",
		},
		{
			description_id = "flak_mission_photo_2_description",
			photo = "intel_flak_02",
			title_id = "flak_mission_photo_2_title",
		},
		{
			description_id = "flak_mission_photo_3_description",
			photo = "intel_flak_03",
			title_id = "flak_mission_photo_3_title",
		},
		{
			description_id = "flak_mission_photo_4_description",
			photo = "intel_flak_04",
			title_id = "flak_mission_photo_4_title",
		},
		{
			description_id = "flak_mission_photo_5_description",
			photo = "intel_flak_05",
			title_id = "flak_mission_photo_5_title",
		},
		{
			description_id = "flak_mission_photo_6_description",
			photo = "intel_flak_06",
			title_id = "flak_mission_photo_6_title",
		},
	}
	self.missions.gold_rush = {}
	self.missions.gold_rush.name_id = "menu_ger_miss_03_ld_hl"
	self.missions.gold_rush.level_id = "gold_rush"
	self.missions.gold_rush.camp_objective_id = "obj_camp_goto_raid_reichsbank"
	self.missions.gold_rush.briefing_id = "menu_ger_miss_03_ld_desc"
	self.missions.gold_rush.audio_briefing_id = "bank_briefing_long"
	self.missions.gold_rush.short_audio_briefing_id = "bank_brief_short"
	self.missions.gold_rush.region = "germany"
	self.missions.gold_rush.music_id = "reichsbank"
	self.missions.gold_rush.stealth_description = OperationsTweakData.RAID_NOT_STEALTHABLE
	self.missions.gold_rush.xp = 4000
	self.missions.gold_rush.dogtags = self.dogtag_types.small
	self.missions.gold_rush.trophy = {
		position = "snap_02",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_bank",
	}
	self.missions.gold_rush.greed_items = {
		max = 500,
		min = 300,
	}
	self.missions.gold_rush.sub_worlds_spawned = 1
	self.missions.gold_rush.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.gold_rush.mission_flag = "level_raid_gold_rush"
	self.missions.gold_rush.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.gold_rush.progression_groups = {
		OperationsTweakData.PROGRESSION_GROUP_STANDARD,
	}
	self.missions.gold_rush.forbids_random = {
		"clear_skies_gold_rush",
	}
	self.missions.gold_rush.icon_menu_big = "xp_events_missions_raid_bank"
	self.missions.gold_rush.icon_menu = "missions_raid_bank_menu"
	self.missions.gold_rush.icon_hud = "mission_raid_railyard"
	self.missions.gold_rush.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_b4_steal-valuables_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_a2_cause-carnage_v005",
		"movies/vanilla/mission_briefings/02_mission_brief_b1_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_b5_steal-valuables_cause-carnage_v004",
	}
	self.missions.gold_rush.loading = {
		image = "loading_bank",
		text = "menu_ger_miss_03_ld_loading_desc",
	}
	self.missions.gold_rush.photos = {
		{
			description_id = "treasury_mission_photo_1_description",
			photo = "intel_bank_01",
			title_id = "treasury_mission_photo_1_title",
		},
		{
			description_id = "treasury_mission_photo_2_description",
			photo = "intel_bank_02",
			title_id = "treasury_mission_photo_2_title",
		},
		{
			description_id = "treasury_mission_photo_3_description",
			photo = "intel_bank_03",
			title_id = "treasury_mission_photo_3_title",
		},
		{
			description_id = "treasury_mission_photo_4_description",
			photo = "intel_bank_04",
			title_id = "treasury_mission_photo_4_title",
		},
	}
	self.missions.train_yard = {}
	self.missions.train_yard.name_id = "menu_ger_miss_05_hl"
	self.missions.train_yard.level_id = "train_yard"
	self.missions.train_yard.briefing_id = "menu_ger_miss_05_desc"
	self.missions.train_yard.audio_briefing_id = "trainyard_briefing_long"
	self.missions.train_yard.short_audio_briefing_id = "trainyard_brief_short"
	self.missions.train_yard.region = "germany"
	self.missions.train_yard.music_id = "train_yard"
	self.missions.train_yard.start_in_stealth = true
	self.missions.train_yard.stealth_description = OperationsTweakData.RAID_MOSTLY_STEALTHABLE
	self.missions.train_yard.xp = 5000
	self.missions.train_yard.bounty_filters = {
		forbid_buffs = {
			BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
			BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
		},
	}
	self.missions.train_yard.dogtags = self.dogtag_types.large
	self.missions.train_yard.trophy = {
		position = "snap_03",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_railyard",
	}
	self.missions.train_yard.greed_items = {
		max = 1600,
		min = 1000,
	}
	self.missions.train_yard.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.train_yard.mission_flag = "level_raid_train_yard"
	self.missions.train_yard.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.train_yard.progression_groups = {
		self.PROGRESSION_GROUP_INITIAL_MEDIUM,
		self.PROGRESSION_GROUP_STANDARD,
	}
	self.missions.train_yard.icon_menu_big = "xp_events_mission_raid_railyard"
	self.missions.train_yard.icon_menu = "mission_raid_railyard_menu"
	self.missions.train_yard.icon_hud = "mission_raid_railyard"
	self.missions.train_yard.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_b4_steal-valuables_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_a2_cause-carnage_v005",
		"movies/vanilla/mission_briefings/02_mission_brief_b1_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_b5_steal-valuables_cause-carnage_v004",
	}
	self.missions.train_yard.loading = {
		image = "loading_trainyard",
		text = "menu_ger_miss_05_loading_desc",
	}
	self.missions.train_yard.photos = {
		{
			description_id = "rail_yard_mission_photo_1_description",
			photo = "intel_train_01",
			title_id = "rail_yard_mission_photo_1_title",
		},
		{
			description_id = "rail_yard_mission_photo_2_description",
			photo = "intel_train_02",
			title_id = "rail_yard_mission_photo_2_title",
		},
		{
			description_id = "rail_yard_mission_photo_4_description",
			photo = "intel_train_04",
			title_id = "rail_yard_mission_photo_4_title",
		},
		{
			description_id = "rail_yard_mission_photo_5_description",
			photo = "intel_train_05",
			title_id = "rail_yard_mission_photo_5_title",
		},
	}
	self.missions.radio_defense = {}
	self.missions.radio_defense.name_id = "menu_afr_miss_04_hl"
	self.missions.radio_defense.level_id = "radio_defense"
	self.missions.radio_defense.briefing_id = "menu_afr_miss_04_desc"
	self.missions.radio_defense.audio_briefing_id = "radio_briefing_long"
	self.missions.radio_defense.short_audio_briefing_id = "radio_brief_short"
	self.missions.radio_defense.region = "germany"
	self.missions.radio_defense.music_id = "radio_defense"
	self.missions.radio_defense.xp = 4500
	self.missions.radio_defense.bounty_filters = {
		forbid_buffs = {
			BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
			BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
		},
	}
	self.missions.radio_defense.start_in_stealth = true
	self.missions.radio_defense.stealth_description = OperationsTweakData.RAID_MOSTLY_STEALTHABLE
	self.missions.radio_defense.dogtags = self.dogtag_types.medium
	self.missions.radio_defense.trophy = {
		position = "snap_24",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_radio",
	}
	self.missions.radio_defense.greed_items = {
		max = 1800,
		min = 1200,
	}
	self.missions.radio_defense.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.radio_defense.mission_flag = "level_raid_radio_defense"
	self.missions.radio_defense.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.radio_defense.progression_groups = {
		OperationsTweakData.PROGRESSION_GROUP_STANDARD,
	}
	self.missions.radio_defense.icon_menu_big = "xp_events_missions_raid_radio"
	self.missions.radio_defense.icon_menu = "missions_raid_radio_menu"
	self.missions.radio_defense.icon_hud = "missions_raid_radio"
	self.missions.radio_defense.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_a5_rescue_v005",
	}
	self.missions.radio_defense.loading = {
		image = "loading_radio",
		text = "menu_afr_miss_04_loading_desc",
	}
	self.missions.radio_defense.photos = {
		{
			description_id = "radio_base_mission_photo_1_description",
			photo = "intel_radio_01",
			title_id = "radio_base_mission_photo_1_title",
		},
		{
			description_id = "radio_base_mission_photo_2_description",
			photo = "intel_radio_02",
			title_id = "radio_base_mission_photo_2_title",
		},
		{
			description_id = "radio_base_mission_photo_3_description",
			photo = "intel_radio_03",
			title_id = "radio_base_mission_photo_3_title",
		},
		{
			description_id = "radio_base_mission_photo_4_description",
			photo = "intel_radio_04",
			title_id = "radio_base_mission_photo_4_title",
		},
		{
			description_id = "radio_base_mission_photo_5_description",
			photo = "intel_radio_05",
			title_id = "radio_base_mission_photo_5_title",
		},
	}
	self.missions.ger_bridge = {}
	self.missions.ger_bridge.name_id = "menu_ger_bridge_00_hl"
	self.missions.ger_bridge.level_id = "ger_bridge"
	self.missions.ger_bridge.briefing_id = "menu_ger_bridge_00_hl_desc"
	self.missions.ger_bridge.audio_briefing_id = "bridge_briefing_long"
	self.missions.ger_bridge.short_audio_briefing_id = "bridge_brief_short"
	self.missions.ger_bridge.region = "germany"
	self.missions.ger_bridge.music_id = "ger_bridge"
	self.missions.ger_bridge.mission_state = self.STATE_LOCATION_MISSION_SELECTED
	self.missions.ger_bridge.stealth_description = self.RAID_NOT_STEALTHABLE
	self.missions.ger_bridge.mission_flag = "level_raid_bridge"
	self.missions.ger_bridge.job_type = self.JOB_TYPE_RAID
	self.missions.ger_bridge.progression_groups = {
		self.PROGRESSION_GROUP_INITIAL_MEDIUM,
		self.PROGRESSION_GROUP_STANDARD,
	}
	self.missions.ger_bridge.xp = 3600
	self.missions.ger_bridge.dogtags = self.dogtag_types.small
	self.missions.ger_bridge.trophy = {
		position = "snap_23",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_bridge",
	}
	self.missions.ger_bridge.icon_menu_big = "xp_events_missions_raid_bridge"
	self.missions.ger_bridge.greed_items = {
		max = 800,
		min = 600,
	}
	self.missions.ger_bridge.icon_menu = "missions_raid_bridge_menu"
	self.missions.ger_bridge.icon_hud = "missions_raid_bridge"
	self.missions.ger_bridge.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_a1_demolition_v005",
	}
	self.missions.ger_bridge.loading = {
		image = "loading_bridge",
		text = "menu_ger_bridge_00_hl_loading_desc",
	}
	self.missions.ger_bridge.excluded_continents = {
		"operation",
	}
	self.missions.ger_bridge.photos = {
		{
			description_id = "bridge_mission_photo_1_description",
			photo = "intel_bridge_01",
			title_id = "bridge_mission_photo_1_title",
		},
		{
			description_id = "bridge_mission_photo_2_description",
			photo = "intel_bridge_02",
			title_id = "bridge_mission_photo_2_title",
		},
		{
			description_id = "bridge_mission_photo_3_description",
			photo = "intel_bridge_03",
			title_id = "bridge_mission_photo_3_title",
		},
		{
			description_id = "bridge_mission_photo_4_description",
			photo = "intel_bridge_04",
			title_id = "bridge_mission_photo_4_title",
		},
		{
			description_id = "bridge_mission_photo_5_description",
			photo = "intel_bridge_05",
			title_id = "bridge_mission_photo_5_title",
		},
	}
	self.missions.settlement = {}
	self.missions.settlement.name_id = "menu_afr_miss_05_hl"
	self.missions.settlement.level_id = "settlement"
	self.missions.settlement.briefing_id = "menu_afr_miss_05_desc"
	self.missions.settlement.audio_briefing_id = "castle_briefing_long"
	self.missions.settlement.short_audio_briefing_id = "castle_brief_short"
	self.missions.settlement.region = "germany"
	self.missions.settlement.music_id = "castle"
	self.missions.settlement.stealth_description = self.RAID_NOT_STEALTHABLE
	self.missions.settlement.xp = 5000
	self.missions.settlement.bounty_filters = {
		forbid_buffs = {
			BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
			BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
		},
	}
	self.missions.settlement.dogtags = self.dogtag_types.large
	self.missions.settlement.trophy = {
		position = "snap_22",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_castle",
	}
	self.missions.settlement.greed_items = {
		max = 1800,
		min = 1200,
	}
	self.missions.settlement.mission_state = self.STATE_LOCATION_MISSION_SELECTED
	self.missions.settlement.mission_flag = "level_raid_castle"
	self.missions.settlement.job_type = self.JOB_TYPE_RAID
	self.missions.settlement.progression_groups = {
		self.PROGRESSION_GROUP_INITIAL_LONG,
		self.PROGRESSION_GROUP_STANDARD,
	}
	self.missions.settlement.icon_menu_big = "xp_events_missions_raid_castle"
	self.missions.settlement.icon_menu = "missions_raid_castle_menu"
	self.missions.settlement.icon_hud = "missions_raid_castle"
	self.missions.settlement.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_b4_steal-valuables_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_a2_cause-carnage_v005",
		"movies/vanilla/mission_briefings/02_mission_brief_b1_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_b5_steal-valuables_cause-carnage_v004",
	}
	self.missions.settlement.loading = {
		image = "loading_castle",
		text = "menu_afr_miss_05_loading_desc",
	}
	self.missions.settlement.photos = {
		{
			description_id = "castle_mission_photo_1_description",
			photo = "intel_castle_01",
			title_id = "castle_mission_photo_1_title",
		},
		{
			description_id = "castle_mission_photo_2_description",
			photo = "intel_castle_02",
			title_id = "castle_mission_photo_2_title",
		},
		{
			description_id = "castle_mission_photo_3_description",
			photo = "intel_castle_03",
			title_id = "castle_mission_photo_3_title",
		},
		{
			description_id = "castle_mission_photo_4_description",
			photo = "intel_castle_05",
			title_id = "castle_mission_photo_4_title",
		},
		{
			description_id = "castle_mission_photo_5_description",
			photo = "intel_castle_04",
			title_id = "castle_mission_photo_5_title",
		},
	}
	self.missions.forest_gumpy = {}
	self.missions.forest_gumpy.name_id = "menu_forest_gumpy_hl"
	self.missions.forest_gumpy.level_id = "forest_gumpy"
	self.missions.forest_gumpy.briefing_id = "menu_forest_gumpy_hl_desc"
	self.missions.forest_gumpy.camp_objective_id = "obj_camp_goto_consumable_forest"
	self.missions.forest_gumpy.audio_briefing_id = ""
	self.missions.forest_gumpy.short_audio_briefing_id = ""
	self.missions.forest_gumpy.region = "germany"
	self.missions.forest_gumpy.music_id = "forest_gumpy"
	self.missions.forest_gumpy.stealth_description = OperationsTweakData.RAID_NOT_STEALTHABLE
	self.missions.forest_gumpy.xp = 3200
	self.missions.forest_gumpy.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.forest_gumpy.mission_flag = "level_raid_forest_gumpy"
	self.missions.forest_gumpy.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.forest_gumpy.consumable = true
	self.missions.forest_gumpy.icon_menu_big = "xp_events_missions_consumable_forest"
	self.missions.forest_gumpy.icon_menu = "missions_menu_consumable_forest"
	self.missions.forest_gumpy.icon_hud = "missions_menu_consumable_forest"
	self.missions.forest_gumpy.loading = {
		image = "raid_loading_forest",
		text = "menu_forest_gumpy_hl_loading_desc",
	}
	self.missions.forest_gumpy.photos = {
		{
			description_id = "forest_mission_photo_1_description",
			photo = "intel_forest_01",
			title_id = "forest_mission_photo_1_title",
		},
		{
			description_id = "forest_mission_photo_2_description",
			photo = "intel_forest_02",
			title_id = "forest_mission_photo_2_title",
		},
		{
			description_id = "forest_mission_photo_3_description",
			photo = "intel_forest_03",
			title_id = "forest_mission_photo_3_title",
		},
		{
			description_id = "forest_mission_photo_4_description",
			photo = "intel_forest_04",
			title_id = "forest_mission_photo_4_title",
		},
	}
	self.missions.bunker_test = {}
	self.missions.bunker_test.name_id = "menu_bunker_test_hl"
	self.missions.bunker_test.level_id = "bunker_test"
	self.missions.bunker_test.camp_objective_id = "obj_camp_goto_raid_bunker"
	self.missions.bunker_test.briefing_id = "menu_bunker_test_desc"
	self.missions.bunker_test.audio_briefing_id = "mrs_white_bunkers_brief_long"
	self.missions.bunker_test.short_audio_briefing_id = "mrs_white_bunkers_briefing_short"
	self.missions.bunker_test.music_id = "random"
	self.missions.bunker_test.region = "germany"
	self.missions.bunker_test.xp = 3000
	self.missions.bunker_test.dogtags = self.dogtag_types.small
	self.missions.bunker_test.trophy = {
		position = "snap_08",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_bunker",
	}
	self.missions.bunker_test.greed_items = {
		max = 900,
		min = 600,
	}
	self.missions.bunker_test.mission_state = self.STATE_LOCATION_MISSION_SELECTED
	self.missions.bunker_test.mission_flag = "level_raid_bunker_test"
	self.missions.bunker_test.job_type = self.JOB_TYPE_RAID
	self.missions.bunker_test.progression_groups = {
		self.PROGRESSION_GROUP_INITIAL_SHORT,
		self.PROGRESSION_GROUP_SHORT,
	}
	self.missions.bunker_test.icon_menu_big = "xp_events_missions_bunkers"
	self.missions.bunker_test.icon_menu = "missions_bunkers"
	self.missions.bunker_test.icon_hud = "missions_raid_flaktower"
	self.missions.bunker_test.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_b4_steal-valuables_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_a2_cause-carnage_v005",
		"movies/vanilla/mission_briefings/02_mission_brief_b1_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_b5_steal-valuables_cause-carnage_v004",
	}
	self.missions.bunker_test.loading = {
		image = "raid_loading_bunkers",
		text = "loading_bunker_test",
	}
	self.missions.bunker_test.start_in_stealth = true
	self.missions.bunker_test.stealth_description = self.RAID_STARTS_STEALTHABLE
	self.missions.bunker_test.photos = {
		{
			description_id = "bunker_mission_photo_1_description",
			photo = "intel_bunkers_05",
			title_id = "bunker_mission_photo_1_title",
		},
		{
			description_id = "bunker_mission_photo_2_description",
			photo = "intel_bunkers_04",
			title_id = "bunker_mission_photo_2_title",
		},
		{
			description_id = "bunker_mission_photo_3_description",
			photo = "intel_bunkers_01",
			title_id = "bunker_mission_photo_3_title",
		},
		{
			description_id = "bunker_mission_photo_4_description",
			photo = "intel_bunkers_02",
			title_id = "bunker_mission_photo_4_title",
		},
	}
	self.missions.tnd = {}
	self.missions.tnd.name_id = "menu_tnd_hl"
	self.missions.tnd.level_id = "tnd"
	self.missions.tnd.briefing_id = "menu_tnd_desc"
	self.missions.tnd.audio_briefing_id = "mrs_white_tank_depot_brief_long"
	self.missions.tnd.short_audio_briefing_id = "mrs_white_tank_depot_briefing_short"
	self.missions.tnd.music_id = "castle"
	self.missions.tnd.region = "germany"
	self.missions.tnd.stealth_description = OperationsTweakData.RAID_MOSTLY_STEALTHABLE
	self.missions.tnd.xp = 2500
	self.missions.tnd.dogtags = self.dogtag_types.small
	self.missions.tnd.trophy = {
		position = "snap_13",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_tank",
	}
	self.missions.tnd.greed_items = {
		max = 900,
		min = 600,
	}
	self.missions.tnd.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.tnd.mission_flag = "level_raid_tnd"
	self.missions.tnd.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.tnd.progression_groups = {
		OperationsTweakData.PROGRESSION_GROUP_SHORT,
	}
	self.missions.tnd.icon_menu_big = "xp_events_missions_tank_depot"
	self.missions.tnd.icon_menu = "missions_tank_depot"
	self.missions.tnd.icon_hud = "missions_raid_flaktower"
	self.missions.tnd.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_b4_steal-valuables_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_a2_cause-carnage_v005",
		"movies/vanilla/mission_briefings/02_mission_brief_b1_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_b5_steal-valuables_cause-carnage_v004",
	}
	self.missions.tnd.loading = {
		image = "raid_loading_tank_depot",
		text = "loading_tnd",
	}
	self.missions.tnd.photos = {
		{
			description_id = "tank_depot_mission_photo_1_description",
			photo = "intel_tank_depot_05",
			title_id = "tank_depot_mission_photo_1_title",
		},
		{
			description_id = "tank_depot_mission_photo_2_description",
			photo = "intel_tank_depot_01",
			title_id = "tank_depot_mission_photo_2_title",
		},
		{
			description_id = "tank_depot_mission_photo_3_description",
			photo = "intel_tank_depot_03",
			title_id = "tank_depot_mission_photo_3_title",
		},
		{
			description_id = "tank_depot_mission_photo_4_description",
			photo = "intel_tank_depot_02",
			title_id = "tank_depot_mission_photo_4_title",
		},
	}
	self.missions.hunters = {}
	self.missions.hunters.name_id = "menu_hunters_hl"
	self.missions.hunters.level_id = "hunters"
	self.missions.hunters.briefing_id = "menu_hunters_desc"
	self.missions.hunters.audio_briefing_id = "mrs_white_hunters_brief_long"
	self.missions.hunters.short_audio_briefing_id = "mrs_white_hunters_briefing_short"
	self.missions.hunters.music_id = "radio_defense"
	self.missions.hunters.region = "germany"
	self.missions.hunters.stealth_description = self.RAID_COMPLETELY_STEALTHABLE
	self.missions.hunters.xp = 2500
	self.missions.hunters.bounty_filters = {
		forbid_buffs = {
			BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
			BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
		},
	}
	self.missions.hunters.dogtags = self.dogtag_types.medium
	self.missions.hunters.trophy = {
		position = "snap_06",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_hunters",
	}
	self.missions.hunters.greed_items = {
		max = 2400,
		min = 1700,
	}
	self.missions.hunters.mission_state = self.STATE_LOCATION_MISSION_SELECTED
	self.missions.hunters.mission_flag = "level_raid_hunters"
	self.missions.hunters.job_type = self.JOB_TYPE_RAID
	self.missions.hunters.progression_groups = {
		self.PROGRESSION_GROUP_SHORT,
	}
	self.missions.hunters.icon_menu_big = "xp_events_missions_hunters"
	self.missions.hunters.icon_menu = "missions_hunters"
	self.missions.hunters.icon_hud = "missions_raid_flaktower"
	self.missions.hunters.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_b4_steal-valuables_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_a2_cause-carnage_v005",
		"movies/vanilla/mission_briefings/02_mission_brief_b1_cause-carnage_v004",
		"movies/vanilla/mission_briefings/02_mission_brief_b5_steal-valuables_cause-carnage_v004",
	}
	self.missions.hunters.loading = {
		image = "raid_loading_hunters",
		text = "loading_hunters",
	}
	self.missions.hunters.start_in_stealth = true
	self.missions.hunters.photos = {
		{
			description_id = "hunters_mission_photo_1_description",
			photo = "intel_hunters_01",
			title_id = "hunters_mission_photo_1_title",
		},
		{
			description_id = "hunters_mission_photo_2_description",
			photo = "intel_hunters_02",
			title_id = "hunters_mission_photo_2_title",
		},
		{
			description_id = "hunters_mission_photo_4_description",
			photo = "intel_hunters_04",
			title_id = "hunters_mission_photo_4_title",
		},
	}
	self.missions.convoy = {}
	self.missions.convoy.name_id = "menu_convoy_hl"
	self.missions.convoy.level_id = "convoy"
	self.missions.convoy.briefing_id = "menu_convoy_desc"
	self.missions.convoy.audio_briefing_id = "mrs_white_convoys_brief_long"
	self.missions.convoy.short_audio_briefing_id = "mrs_white_convoys_briefing_short"
	self.missions.convoy.music_id = "random"
	self.missions.convoy.region = "germany"
	self.missions.convoy.stealth_description = OperationsTweakData.RAID_MOSTLY_STEALTHABLE
	self.missions.convoy.xp = 2500
	self.missions.convoy.dogtags = self.dogtag_types.small
	self.missions.convoy.trophy = {
		position = "snap_09",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_convoy",
	}
	self.missions.convoy.greed_items = {
		max = 400,
		min = 300,
	}
	self.missions.convoy.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.convoy.mission_flag = "level_raid_convoy"
	self.missions.convoy.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.convoy.progression_groups = {
		OperationsTweakData.PROGRESSION_GROUP_SHORT,
	}
	self.missions.convoy.icon_menu_big = "xp_events_missions_convoy"
	self.missions.convoy.icon_menu = "missions_convoy"
	self.missions.convoy.icon_hud = "missions_raid_flaktower"
	self.missions.convoy.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_a3_ambush_v005",
	}
	self.missions.convoy.loading = {
		image = "raid_loading_convoy",
		text = "loading_convoy",
	}
	self.missions.convoy.photos = {
		{
			description_id = "convoy_mission_photo_1_description",
			photo = "intel_convoy_01",
			title_id = "convoy_mission_photo_1_title",
		},
		{
			description_id = "convoy_mission_photo_2_description",
			photo = "intel_convoy_03",
			title_id = "convoy_mission_photo_2_title",
		},
		{
			description_id = "convoy_mission_photo_3_description",
			photo = "intel_convoy_02",
			title_id = "convoy_mission_photo_3_title",
		},
		{
			description_id = "convoy_mission_photo_4_description",
			photo = "intel_convoy_04",
			title_id = "convoy_mission_photo_4_title",
		},
	}
	self.missions.spies_test = {}
	self.missions.spies_test.name_id = "menu_spies_test_hl"
	self.missions.spies_test.level_id = "spies_test"
	self.missions.spies_test.camp_objective_id = "obj_camp_goto_raid_spies"
	self.missions.spies_test.briefing_id = "menu_spies_test_desc"
	self.missions.spies_test.audio_briefing_id = "mrs_white_spies_brief_long"
	self.missions.spies_test.short_audio_briefing_id = "mrs_white_spies_briefing_short"
	self.missions.spies_test.music_id = "random"
	self.missions.spies_test.region = "germany"
	self.missions.spies_test.stealth_description = OperationsTweakData.RAID_MOSTLY_STEALTHABLE
	self.missions.spies_test.xp = 3000
	self.missions.spies_test.bounty_filters = {
		forbid_buffs = {
			BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
			BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
		},
	}
	self.missions.spies_test.dogtags = self.dogtag_types.medium
	self.missions.spies_test.trophy = {
		position = "snap_19",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_spies",
	}
	self.missions.spies_test.greed_items = {
		max = 950,
		min = 750,
	}
	self.missions.spies_test.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.spies_test.mission_flag = "level_raid_spies_test"
	self.missions.spies_test.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.spies_test.progression_groups = {
		self.PROGRESSION_GROUP_INITIAL_SHORT,
		self.PROGRESSION_GROUP_SHORT,
	}
	self.missions.spies_test.icon_menu_big = "xp_events_missions_spies"
	self.missions.spies_test.icon_menu = "missions_spies"
	self.missions.spies_test.icon_hud = "missions_raid_flaktower"
	self.missions.spies_test.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_b3_steal-intel_v004",
	}
	self.missions.spies_test.loading = {
		image = "raid_loading_spies",
		text = "loading_spies_test",
	}
	self.missions.spies_test.start_in_stealth = true
	self.missions.spies_test.photos = {
		{
			description_id = "spies_mission_photo_1_description",
			photo = "intel_spies_05",
			title_id = "spies_mission_photo_1_title",
		},
		{
			description_id = "spies_mission_photo_2_description",
			photo = "intel_spies_02",
			title_id = "spies_mission_photo_2_title",
		},
		{
			description_id = "spies_mission_photo_3_description",
			photo = "intel_spies_03",
			title_id = "spies_mission_photo_3_title",
		},
		{
			description_id = "spies_mission_photo_4_description",
			photo = "intel_spies_04",
			title_id = "spies_mission_photo_4_title",
		},
	}
	self.missions.sto = {}
	self.missions.sto.name_id = "menu_sto_hl"
	self.missions.sto.level_id = "sto"
	self.missions.sto.briefing_id = "menu_sto_desc"
	self.missions.sto.camp_objective_id = "obj_camp_goto_consumable_sto"
	self.missions.sto.audio_briefing_id = ""
	self.missions.sto.short_audio_briefing_id = ""
	self.missions.sto.music_id = "random"
	self.missions.sto.region = "germany"
	self.missions.sto.stealth_description = OperationsTweakData.RAID_COMPLETELY_STEALTHABLE
	self.missions.sto.xp = 2500
	self.missions.sto.consumable = true
	self.missions.sto.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.sto.mission_flag = "level_raid_sto"
	self.missions.sto.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.sto.icon_menu_big = "xp_events_missions_art_storage"
	self.missions.sto.icon_menu = "missions_art_storage"
	self.missions.sto.icon_hud = "missions_raid_flaktower"
	self.missions.sto.loading = {
		image = "raid_loading_art_storage",
		text = "loading_sto",
	}
	self.missions.sto.start_in_stealth = true
	self.missions.sto.photos = {
		{
			description_id = "art_storage_mission_photo_1_description",
			photo = "intel_art_storage_01",
			title_id = "art_storage_mission_photo_1_title",
		},
		{
			description_id = "art_storage_mission_photo_2_description",
			photo = "intel_art_storage_02",
			title_id = "art_storage_mission_photo_2_title",
		},
		{
			description_id = "art_storage_mission_photo_3_description",
			photo = "intel_art_storage_03",
			title_id = "art_storage_mission_photo_3_title",
		},
		{
			description_id = "art_storage_mission_photo_4_description",
			photo = "intel_art_storage_05",
			title_id = "art_storage_mission_photo_4_title",
		},
	}
	self.missions.silo = {}
	self.missions.silo.name_id = "menu_silo_hl"
	self.missions.silo.level_id = "silo"
	self.missions.silo.briefing_id = "menu_silo_desc"
	self.missions.silo.sub_worlds_spawned = 2
	self.missions.silo.audio_briefing_id = "mrs_white_silo_brief_long"
	self.missions.silo.short_audio_briefing_id = "mrs_white_silo_brief_short"
	self.missions.silo.music_id = "random"
	self.missions.silo.region = "germany"
	self.missions.silo.stealth_description = OperationsTweakData.RAID_STARTS_STEALTHABLE
	self.missions.silo.dogtags = self.dogtag_types.medium
	self.missions.silo.trophy = {
		position = "snap_17",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_silo",
	}
	self.missions.silo.greed_items = {
		max = 950,
		min = 750,
	}
	self.missions.silo.xp = 5500
	self.missions.silo.bounty_filters = {
		forbid_buffs = {
			BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
			BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
		},
	}
	self.missions.silo.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.silo.mission_flag = "level_raid_silo"
	self.missions.silo.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.silo.progression_groups = {
		OperationsTweakData.PROGRESSION_GROUP_STANDARD,
	}
	self.missions.silo.icon_menu_big = "xp_events_missions_silo"
	self.missions.silo.icon_menu = "missions_silo"
	self.missions.silo.icon_hud = "missions_silo"
	self.missions.silo.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_a2_cause-carnage_v005",
		"movies/vanilla/mission_briefings/02_mission_brief_b1_cause-carnage_v004",
	}
	self.missions.silo.loading = {
		image = "loading_silo",
		text = "menu_silo_loading_desc",
	}
	self.missions.silo.photos = {
		{
			description_id = "silo_mission_photo_1_description",
			photo = "intel_silo_01",
			title_id = "silo_mission_photo_1_title",
		},
		{
			description_id = "silo_mission_photo_2_description",
			photo = "intel_silo_02",
			title_id = "silo_mission_photo_2_title",
		},
		{
			description_id = "silo_mission_photo_3_description",
			photo = "intel_silo_03",
			title_id = "silo_mission_photo_3_title",
		},
		{
			description_id = "silo_mission_photo_4_description",
			photo = "intel_silo_04",
			title_id = "silo_mission_photo_4_title",
		},
		{
			description_id = "silo_mission_photo_5_description",
			photo = "intel_silo_05",
			title_id = "silo_mission_photo_5_title",
		},
	}
	self.missions.kelly = {}
	self.missions.kelly.name_id = "menu_kelly_hl"
	self.missions.kelly.level_id = "kelly"
	self.missions.kelly.briefing_id = "menu_kelly_desc"
	self.missions.kelly.audio_briefing_id = "mrs_white_kelly_brief_long"
	self.missions.kelly.short_audio_briefing_id = "mrs_white_kelly_brief_short"
	self.missions.kelly.music_id = "random"
	self.missions.kelly.region = "germany"
	self.missions.kelly.stealth_description = OperationsTweakData.RAID_COMPLETELY_STEALTHABLE
	self.missions.kelly.dogtags = self.dogtag_types.medium
	self.missions.kelly.xp = 3200
	self.missions.kelly.greed_items = {
		max = 400,
		min = 200,
	}
	self.missions.kelly.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.kelly.mission_flag = "level_raid_kelly"
	self.missions.kelly.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.kelly.progression_groups = {
		OperationsTweakData.PROGRESSION_GROUP_STANDARD,
	}
	self.missions.kelly.icon_menu_big = "xp_events_missions_kelly"
	self.missions.kelly.icon_menu = "missions_kelly"
	self.missions.kelly.icon_hud = "missions_raid_flaktower"
	self.missions.kelly.control_brief_video = {
		"movies/vanilla/mission_briefings/02_mission_brief_a2_cause-carnage_v005",
		"movies/vanilla/mission_briefings/02_mission_brief_b1_cause-carnage_v004",
	}
	self.missions.kelly.start_in_stealth = true
	self.missions.kelly.loading = {
		image = "loading_kelly",
		text = "menu_kelly_loading_desc",
	}
	self.missions.kelly.photos = {
		{
			description_id = "kelly_mission_photo_1_description",
			photo = "intel_kelly_01",
			title_id = "kelly_mission_photo_1_title",
		},
		{
			description_id = "kelly_mission_photo_2_description",
			photo = "intel_kelly_02",
			title_id = "kelly_mission_photo_2_title",
		},
		{
			description_id = "kelly_mission_photo_3_description",
			photo = "intel_kelly_03",
			title_id = "kelly_mission_photo_3_title",
		},
		{
			description_id = "kelly_mission_photo_4_description",
			photo = "intel_kelly_04",
			title_id = "kelly_mission_photo_4_title",
		},
	}
	self.missions.fury_railway = {}
	self.missions.fury_railway.level_id = "fury_railway"
	self.missions.fury_railway.name_id = "menu_fury_railway_name"
	self.missions.fury_railway.briefing_id = "menu_fury_railway_desc"
	self.missions.fury_railway.audio_briefing_id = ""
	self.missions.fury_railway.short_audio_briefing_id = ""
	self.missions.fury_railway.music_id = "forest_gumpy"
	self.missions.fury_railway.region = "germany"
	self.missions.fury_railway.camp_objective_id = "obj_camp_goto_outlaw_fury_railway"
	self.missions.fury_railway.stealth_description = OperationsTweakData.RAID_STARTS_STEALTHABLE
	self.missions.fury_railway.xp = 2500
	self.missions.fury_railway.consumable = true
	self.missions.fury_railway.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.fury_railway.mission_flag = "level_raid_fury_railway"
	self.missions.fury_railway.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.fury_railway.icon_menu = "missions_fury_railway"
	self.missions.fury_railway.icon_hud = "missions_consumable_fury_railway"
	self.missions.fury_railway.loading = {
		image = "loading_fury_railway",
		text = "loading_fury_railway_text",
	}
	self.missions.fury_railway.start_in_stealth = true
	self.missions.fury_railway.photos = {
		{
			description_id = "fury_railway_mission_photo_1_description",
			photo = "intel_fury_railway_01",
			title_id = "fury_railway_mission_photo_1_title",
		},
		{
			description_id = "fury_railway_mission_photo_2_description",
			photo = "intel_fury_railway_02",
			title_id = "fury_railway_mission_photo_2_title",
		},
		{
			description_id = "fury_railway_mission_photo_3_description",
			photo = "intel_fury_railway_03",
			title_id = "fury_railway_mission_photo_3_title",
		},
		{
			description_id = "fury_railway_mission_photo_4_description",
			photo = "intel_fury_railway_04",
			title_id = "fury_railway_mission_photo_4_title",
		},
	}
	self.missions.forest_bunker = {
		audio_briefing_id = "mrs_white_fb_briefing_long",
		briefing_id = "forest_bunker_briefing",
		dogtags = self.dogtag_types.medium,
		greed_items = {
			max = 1500,
			min = 1200,
		},
		icon_hud = "missions_forest_bunker",
		icon_menu = "missions_forest_bunker",
		icon_menu_big = "xp_events_missions_forest_bunker",
		job_type = self.JOB_TYPE_RAID,
		level_id = "forest_bunker",
		loading = {
			image = "forest_bunker_loading_screen",
			text = "forest_bunker_loading",
		},
		mission_flag = "level_raid_forest_bunker",
		mission_state = self.STATE_LOCATION_MISSION_SELECTED,
		music_id = "random",
		name_id = "forest_bunker",
		photos = {
			{
				description_id = "forest_bunker_mission_photo_1_description",
				photo = "intel_forest_bunker_01",
				title_id = "forest_bunker_mission_photo_1_title",
			},
			{
				description_id = "forest_bunker_mission_photo_2_description",
				photo = "intel_forest_bunker_02",
				title_id = "forest_bunker_mission_photo_2_title",
			},
			{
				description_id = "forest_bunker_mission_photo_3_description",
				photo = "intel_forest_bunker_03",
				title_id = "forest_bunker_mission_photo_3_title",
			},
			{
				description_id = "forest_bunker_mission_photo_4_description",
				photo = "intel_forest_bunker_04",
				title_id = "forest_bunker_mission_photo_4_title",
			},
		},
		progression_groups = {
			self.PROGRESSION_GROUP_STANDARD,
		},
		region = "germany",
		short_audio_briefing_id = "mrs_white_fb_briefing_short",
		start_in_stealth = true,
		stealth_description = self.RAID_STARTS_STEALTHABLE,
		xp = 4400,
	}
end

function OperationsTweakData:_init_operations()
	self._operations_index = {
		"clear_skies",
		"oper_flamable",
		"random_short",
		"random_medium",
		"random_long",
	}
	self.missions.clear_skies = {}
	self.missions.clear_skies.name_id = "menu_ger_oper_01_hl"
	self.missions.clear_skies.briefing_id = "menu_ger_oper_01_desc"
	self.missions.clear_skies.camp_objective_id = "obj_camp_goto_op_1"
	self.missions.clear_skies.audio_briefing_id = "mrs_white_cs_op_mr1_brief_long"
	self.missions.clear_skies.short_audio_briefing_id = "mrs_white_cs_op_mr1_brief_long"
	self.missions.clear_skies.region = "germany"
	self.missions.clear_skies.xp = 11000
	self.missions.clear_skies.trophy = {
		position = "snap_05",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_operation_clear_sky",
	}
	self.missions.clear_skies.job_type = OperationsTweakData.JOB_TYPE_OPERATION
	self.missions.clear_skies.icon_menu = "op_clear_skies_lq"
	self.missions.clear_skies.icon_hud = "op_clear_skies_hd"
	self.missions.clear_skies.allow_free_play = true
	self.missions.clear_skies.events = {}
	self.missions.clear_skies.loading = {
		image = "raid_loading_clear_skies_00",
		text = "menu_ger_oper_01",
	}
	self.missions.clear_skies.photos = {
		{
			description_id = "clear_skies_mission_photo_1_description",
			photo = "intel_clear_skies_01",
			title_id = "clear_skies_mission_photo_1_title",
		},
		{
			description_id = "clear_skies_mission_photo_2_description",
			photo = "intel_clear_skies_02",
			title_id = "clear_skies_mission_photo_2_title",
		},
		{
			description_id = "clear_skies_mission_photo_3_description",
			photo = "intel_clear_skies_03",
			title_id = "clear_skies_mission_photo_3_title",
		},
		{
			description_id = "clear_skies_mission_photo_4_description",
			photo = "intel_clear_skies_04",
			title_id = "clear_skies_mission_photo_4_title",
		},
		{
			description_id = "clear_skies_mission_photo_5_description",
			photo = "intel_clear_skies_05",
			title_id = "clear_skies_mission_photo_5_title",
		},
		{
			description_id = "clear_skies_mission_photo_6_description",
			photo = "intel_clear_skies_06",
			title_id = "clear_skies_mission_photo_6_title",
		},
		{
			description_id = "clear_skies_mission_photo_7_description",
			photo = "intel_clear_skies_07",
			title_id = "clear_skies_mission_photo_7_title",
		},
		{
			description_id = "clear_skies_mission_photo_8_description",
			photo = "intel_clear_skies_08",
			title_id = "clear_skies_mission_photo_8_title",
		},
	}
	self.missions.clear_skies_mini_raid_1_park = {
		audio_briefing_id = "mrs_white_cs_op_mr1_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_clear_sky_01",
		excluded_continents = {
			"operation1mission2",
			"operation1mission3",
			"operation2mission1",
			"operation2mission2",
		},
		forbids_random = {
			"clear_skies_mini_raid_1_destroyed",
			"clear_skies_mini_raid_1_roundabout",
		},
		icon_menu = "missions_operation_clear_skies_menu_1",
		icon_menu_big = "xp_events_missions_operation_clear_skies_1",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_park",
		loading = {
			image = "raid_loading_clear_skies_01",
			text = "menu_ger_oper_01_event_1_loading_text",
		},
		mission_flag = "level_operation_01_mission_01",
		mission_id = "clear_skies_mini_raid_1_park",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_01_event_1_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_1_description",
				photo = "intel_clear_skies_01",
				title_id = "clear_skies_mission_photo_1_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_1_progress_text",
		progress_title_id = "menu_ger_oper_01_event_1_progress_title",
		xp = 2200,
	}
	self.missions.clear_skies.events.mini_raid_1_park = self.missions.clear_skies_mini_raid_1_park
	self.missions.clear_skies_mini_raid_1_destroyed = {
		audio_briefing_id = "mrs_white_cs_op_mr1_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_clear_sky_01",
		excluded_continents = {
			"operation1mission2",
			"operation1mission3",
			"operation2mission1",
			"operation2mission2",
		},
		forbids_random = {
			"clear_skies_mini_raid_1_park",
			"clear_skies_mini_raid_1_roundabout",
		},
		icon_menu = "missions_operation_clear_skies_menu_1",
		icon_menu_big = "xp_events_missions_operation_clear_skies_1",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_destroyed",
		loading = {
			image = "raid_loading_clear_skies_01",
			text = "menu_ger_oper_01_event_1_loading_text",
		},
		mission_flag = "level_operation_01_mission_01",
		mission_id = "clear_skies_mini_raid_1_destroyed",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_01_event_1_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_1_description",
				photo = "intel_clear_skies_01",
				title_id = "clear_skies_mission_photo_1_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_1_progress_text",
		progress_title_id = "menu_ger_oper_01_event_1_progress_title",
		xp = 2200,
	}
	self.missions.clear_skies.events.mini_raid_1_destroyed = self.missions.clear_skies_mini_raid_1_destroyed
	self.missions.clear_skies_mini_raid_1_roundabout = {
		audio_briefing_id = "mrs_white_cs_op_mr1_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_clear_sky_01",
		excluded_continents = {
			"operation1mission2",
			"operation1mission3",
			"operation2mission1",
			"operation2mission2",
			"raid_brnvct",
		},
		forbids_random = {
			"clear_skies_mini_raid_1_park",
			"clear_skies_mini_raid_1_destroyed",
		},
		icon_menu = "missions_operation_clear_skies_menu_1",
		icon_menu_big = "xp_events_missions_operation_clear_skies_1",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_roundabout",
		loading = {
			image = "raid_loading_clear_skies_01",
			text = "menu_ger_oper_01_event_1_loading_text",
		},
		mission_flag = "level_operation_01_mission_01",
		mission_id = "clear_skies_mini_raid_1_roundabout",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_01_event_1_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_1_description",
				photo = "intel_clear_skies_01",
				title_id = "clear_skies_mission_photo_1_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_1_progress_text",
		progress_title_id = "menu_ger_oper_01_event_1_progress_title",
		xp = 2200,
	}
	self.missions.clear_skies.events.mini_raid_1_roundabout = self.missions.clear_skies_mini_raid_1_roundabout
	self.missions.clear_skies_gold_rush = {
		audio_briefing_id = "mrs_white_bank_op_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_clear_sky_02",
		dogtags = self.dogtag_types.medium,
		icon_menu = "missions_operation_clear_skies_menu_2",
		icon_menu_big = "xp_events_missions_operation_clear_skies_2",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "gold_rush",
		loading = {
			image = "raid_loading_clear_skies_02",
			text = "menu_ger_oper_01_event_2_loading_text",
		},
		mission_flag = "level_operation_01_mission_02",
		mission_id = "clear_skies_gold_rush",
		mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED,
		music_id = "reichsbank",
		name_id = "menu_ger_oper_01_event_2_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_2_description",
				photo = "intel_clear_skies_02",
				title_id = "clear_skies_mission_photo_2_title",
			},
			{
				description_id = "clear_skies_mission_photo_3_description",
				photo = "intel_clear_skies_03",
				title_id = "clear_skies_mission_photo_3_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_2_progress_text",
		progress_title_id = "menu_ger_oper_01_event_2_progress_title",
		start_in_stealth = true,
		xp = 3200,
	}
	self.missions.clear_skies.events.gold_rush = self.missions.clear_skies_gold_rush
	self.missions.clear_skies_mini_raid_2_park = {
		audio_briefing_id = "mrs_white_cs_op_mr2_briefing_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_clear_sky_03",
		excluded_continents = {
			"operation1mission1",
			"operation1mission3",
			"operation2mission1",
			"operation2mission2",
		},
		forbids_random = {
			"clear_skies_mini_raid_2_destroyed",
		},
		icon_menu = "missions_operation_clear_skies_menu_3",
		icon_menu_big = "xp_events_missions_operation_clear_skies_3",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_park",
		loading = {
			image = "raid_loading_clear_skies_03",
			text = "menu_ger_oper_01_event_3_loading_text",
		},
		mission_flag = "level_operation_01_mission_03",
		mission_id = "clear_skies_mini_raid_2_park",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_01_event_3_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_4_description",
				photo = "intel_clear_skies_04",
				title_id = "clear_skies_mission_photo_4_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_3_progress_text",
		progress_title_id = "menu_ger_oper_01_event_3_progress_title",
		xp = 2600,
	}
	self.missions.clear_skies.events.mini_raid_2_park = self.missions.clear_skies_mini_raid_2_park
	self.missions.clear_skies_mini_raid_2_destroyed = {
		audio_briefing_id = "mrs_white_cs_op_mr2_briefing_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_clear_sky_03",
		excluded_continents = {
			"operation1mission1",
			"operation1mission3",
			"operation2mission1",
			"operation2mission2",
		},
		forbids_random = {
			"clear_skies_mini_raid_2_park",
		},
		icon_menu = "missions_operation_clear_skies_menu_3",
		icon_menu_big = "xp_events_missions_operation_clear_skies_3",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_destroyed",
		loading = {
			image = "raid_loading_clear_skies_03",
			text = "menu_ger_oper_01_event_3_loading_text",
		},
		mission_flag = "level_operation_01_mission_03",
		mission_id = "clear_skies_mini_raid_2_destroyed",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_01_event_3_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_4_description",
				photo = "intel_clear_skies_04",
				title_id = "clear_skies_mission_photo_4_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_3_progress_text",
		progress_title_id = "menu_ger_oper_01_event_3_progress_title",
		xp = 2600,
	}
	self.missions.clear_skies.events.mini_raid_2_destroyed = self.missions.clear_skies_mini_raid_2_destroyed
	self.missions.clear_skies_radio_defense = {
		audio_briefing_id = "mrs_white_radio_op_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_clear_sky_04",
		dogtags = self.dogtag_types.medium,
		icon_menu = "missions_operation_clear_skies_menu_4",
		icon_menu_big = "xp_events_missions_operation_clear_skies_4",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "radio_defense",
		loading = {
			image = "raid_loading_clear_skies_04",
			text = "menu_ger_oper_01_event_4_loading_text",
		},
		mission_flag = "level_operation_01_mission_04",
		mission_id = "clear_skies_radio_defense",
		mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED,
		music_id = "radio_defense",
		name_id = "menu_ger_oper_01_event_4_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_5_description",
				photo = "intel_clear_skies_05",
				title_id = "clear_skies_mission_photo_5_title",
			},
			{
				description_id = "clear_skies_mission_photo_6_description",
				photo = "intel_clear_skies_06",
				title_id = "clear_skies_mission_photo_6_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_4_progress_text",
		progress_title_id = "menu_ger_oper_01_event_4_progress_title",
		start_in_stealth = true,
		xp = 3200,
	}
	self.missions.clear_skies.events.radio_defense = self.missions.clear_skies_radio_defense
	self.missions.clear_skies_railyard = {
		audio_briefing_id = "mrs_white_trainyard_op_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_clear_sky_05",
		dogtags = {
			diff_bonus = 1,
			max = 10,
			min = 6,
		},
		icon_menu = "missions_operation_clear_skies_menu_5",
		icon_menu_big = "xp_events_missions_operation_clear_skies_5",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "train_yard",
		loading = {
			image = "raid_loading_clear_skies_05",
			text = "menu_ger_oper_01_event_6_loading_text",
		},
		mission_flag = "level_operation_01_mission_06",
		mission_id = "clear_skies_railyard",
		mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED,
		music_id = "train_yard",
		name_id = "menu_ger_oper_01_event_6_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_7_description",
				photo = "intel_clear_skies_07",
				title_id = "clear_skies_mission_photo_7_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_6_progress_text",
		progress_title_id = "menu_ger_oper_01_event_6_progress_title",
		xp = 1500,
	}
	self.missions.clear_skies.events.railyard = self.missions.clear_skies_railyard
	self.missions.clear_skies_flakturm = {
		audio_briefing_id = "mrs_white_flakturm_op_brief_long",
		camp_objective_id = "obj_camp_goto_oper_clear_sky_06",
		dogtags = self.dogtag_types.large,
		excluded_continents = {
			"world",
		},
		forbids_random = {
			"flakturm",
		},
		icon_menu = "missions_operation_clear_skies_menu_6",
		icon_menu_big = "xp_events_missions_operation_clear_skies_6",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "flakturm",
		loading = {
			image = "raid_loading_clear_skies_06",
			text = "menu_ger_oper_01_event_7_loading_text",
		},
		mission_flag = "level_operation_01_mission_07",
		mission_id = "clear_skies_flakturm",
		mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED,
		music_id = "flakturm",
		name_id = "menu_ger_oper_01_event_7_name",
		photos = {
			{
				description_id = "clear_skies_mission_photo_8_description",
				photo = "intel_clear_skies_08",
				title_id = "clear_skies_mission_photo_8_title",
			},
		},
		progress_text_id = "menu_ger_oper_01_event_7_progress_text",
		progress_title_id = "menu_ger_oper_01_event_7_progress_title",
		start_in_stealth = true,
		xp = 3600,
	}
	self.missions.clear_skies.events.flakturm = self.missions.clear_skies_flakturm
	self.missions.clear_skies.events_index_template = {
		{
			"mini_raid_1_park",
			"mini_raid_1_destroyed",
			"mini_raid_1_roundabout",
		},
		{
			"gold_rush",
		},
		{
			"mini_raid_2_park",
			"mini_raid_2_destroyed",
		},
		{
			"radio_defense",
		},
		{
			"railyard",
		},
		{
			"flakturm",
		},
	}
	self.missions.oper_flamable = {}
	self.missions.oper_flamable.name_id = "menu_ger_oper_02_hl"
	self.missions.oper_flamable.briefing_id = "menu_ger_oper_02_desc"
	self.missions.oper_flamable.camp_objective_id = "obj_camp_goto_op_2"
	self.missions.oper_flamable.audio_briefing_id = "mrs_white_or_mr1_brief_long"
	self.missions.oper_flamable.short_audio_briefing_id = "mrs_white_or_mr1_brief_long"
	self.missions.oper_flamable.region = "germany"
	self.missions.oper_flamable.xp = 10000
	self.missions.oper_flamable.trophy = {
		position = "snap_18",
		unit = "units/vanilla/props/props_camp_upgrades/props_camp_trophy_case/props_trophy_operation_rhinegold",
	}
	self.missions.oper_flamable.job_type = OperationsTweakData.JOB_TYPE_OPERATION
	self.missions.oper_flamable.icon_menu = "op_rhinegold_lq"
	self.missions.oper_flamable.icon_hud = "op_rhinegold_hd"
	self.missions.oper_flamable.allow_free_play = true
	self.missions.oper_flamable.events = {}
	self.missions.oper_flamable.loading = {
		image = "loading_rhinegold_00",
		text = "menu_ger_oper_rhinegold",
	}
	self.missions.oper_flamable.photos = {
		{
			description_id = "rhinegold_mission_photo_1_description",
			photo = "intel_rhinegold_01",
			title_id = "rhinegold_mission_photo_1_title",
		},
		{
			description_id = "rhinegold_mission_photo_2_description",
			photo = "intel_rhinegold_02",
			title_id = "rhinegold_mission_photo_2_title",
		},
		{
			description_id = "rhinegold_mission_photo_3_description",
			photo = "intel_rhinegold_03",
			title_id = "rhinegold_mission_photo_3_title",
		},
		{
			description_id = "rhinegold_mission_photo_4_description",
			photo = "intel_rhinegold_04",
			title_id = "rhinegold_mission_photo_4_title",
		},
		{
			description_id = "rhinegold_mission_photo_5_description",
			photo = "intel_rhinegold_05",
			title_id = "rhinegold_mission_photo_5_title",
		},
	}
	self.missions.oper_flamable_mini_raid_1_park = {
		audio_briefing_id = "mrs_white_or_mr1_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_rhinegold_01",
		excluded_continents = {
			"operation1mission1",
			"operation1mission2",
			"operation1mission3",
			"operation2mission2",
		},
		forbids_random = {
			"oper_flamable_mini_raid_1_destroyed",
			"oper_flamable_mini_raid_1_roundabout",
		},
		icon_menu = "missions_operation_rhinegold_menu_1",
		icon_menu_big = "xp_events_missions_operation_rhinegold_1",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_park",
		loading = {
			image = "loading_rhinegold_01",
			text = "menu_ger_oper_rhinegold_event_1_loading_text",
		},
		mission_flag = "level_operation_02_mission_01",
		mission_id = "oper_flamable_mini_raid_1_park",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_02_event_1_name",
		photos = {
			{
				description_id = "rhinegold_mission_photo_1_description",
				photo = "intel_rhinegold_01",
				title_id = "rhinegold_mission_photo_1_title",
			},
		},
		progress_text_id = "menu_ger_oper_rhinegold_event_1_progress_text",
		progress_title_id = "menu_ger_oper_rhinegold_event_1_progress_title",
		xp = 2400,
	}
	self.missions.oper_flamable.events.mini_raid_1_park = self.missions.oper_flamable_mini_raid_1_park
	self.missions.oper_flamable_mini_raid_1_destroyed = {
		audio_briefing_id = "mrs_white_or_mr1_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_rhinegold_01",
		excluded_continents = {
			"operation1mission1",
			"operation1mission2",
			"operation1mission3",
			"operation2mission2",
		},
		forbids_random = {
			"oper_flamable_mini_raid_1_park",
			"oper_flamable_mini_raid_1_roundabout",
		},
		icon_menu = "missions_operation_rhinegold_menu_1",
		icon_menu_big = "xp_events_missions_operation_rhinegold_1",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_destroyed",
		loading = {
			image = "loading_rhinegold_01",
			text = "menu_ger_oper_rhinegold_event_1_loading_text",
		},
		mission_flag = "level_operation_02_mission_01",
		mission_id = "oper_flamable_mini_raid_1_destroyed",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_02_event_1_name",
		photos = {
			{
				description_id = "rhinegold_mission_photo_1_description",
				photo = "intel_rhinegold_01",
				title_id = "rhinegold_mission_photo_1_title",
			},
		},
		progress_text_id = "menu_ger_oper_rhinegold_event_1_progress_text",
		progress_title_id = "menu_ger_oper_rhinegold_event_1_progress_title",
		xp = 2400,
	}
	self.missions.oper_flamable.events.mini_raid_1_destroyed = self.missions.oper_flamable_mini_raid_1_destroyed
	self.missions.oper_flamable_mini_raid_1_roundabout = {
		audio_briefing_id = "mrs_white_or_mr1_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_rhinegold_01",
		excluded_continents = {
			"operation1mission1",
			"operation1mission2",
			"operation1mission3",
			"operation2mission2",
			"raid_brnvct",
		},
		forbids_random = {
			"oper_flamable_mini_raid_1_park",
			"oper_flamable_mini_raid_1_destroyed",
		},
		icon_menu = "missions_operation_rhinegold_menu_1",
		icon_menu_big = "xp_events_missions_operation_rhinegold_1",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_roundabout",
		loading = {
			image = "loading_rhinegold_01",
			text = "menu_ger_oper_rhinegold_event_1_loading_text",
		},
		mission_flag = "level_operation_02_mission_01",
		mission_id = "oper_flamable_mini_raid_1_roundabout",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_02_event_1_name",
		photos = {
			{
				description_id = "rhinegold_mission_photo_1_description",
				photo = "intel_rhinegold_01",
				title_id = "rhinegold_mission_photo_1_title",
			},
		},
		progress_text_id = "menu_ger_oper_rhinegold_event_1_progress_text",
		progress_title_id = "menu_ger_oper_rhinegold_event_1_progress_title",
		xp = 2400,
	}
	self.missions.oper_flamable.events.mini_raid_1_roundabout = self.missions.oper_flamable_mini_raid_1_roundabout
	self.missions.oper_flamable_mini_raid_2_destroyed = {
		audio_briefing_id = "mrs_white_or_mr2_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_rhinegold_02",
		excluded_continents = {
			"operation1mission1",
			"operation1mission2",
			"operation1mission3",
			"operation2mission1",
		},
		forbids_random = {
			"oper_flamable_mini_raid_2_roundabout",
		},
		icon_menu = "missions_operation_rhinegold_menu_2",
		icon_menu_big = "xp_events_missions_operation_rhinegold_2",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_destroyed_fuel",
		loading = {
			image = "loading_rhinegold_02",
			text = "menu_ger_oper_rhinegold_event_2_loading_text",
		},
		mission_flag = "level_operation_02_mission_02",
		mission_id = "oper_flamable_mini_raid_2_destroyed",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_02_event_2_name",
		photos = {
			{
				description_id = "rhinegold_mission_photo_2_description",
				photo = "intel_rhinegold_02",
				title_id = "rhinegold_mission_photo_2_title",
			},
			{
				description_id = "rhinegold_mission_photo_3_description",
				photo = "intel_rhinegold_03",
				title_id = "rhinegold_mission_photo_3_title",
			},
			{
				description_id = "rhinegold_mission_photo_4_description",
				photo = "intel_rhinegold_04",
				title_id = "rhinegold_mission_photo_4_title",
			},
		},
		progress_text_id = "menu_ger_oper_rhinegold_event_2_progress_text",
		progress_title_id = "menu_ger_oper_rhinegold_event_2_progress_title",
		xp = 2200,
	}
	self.missions.oper_flamable.events.mini_raid_2_destroyed = self.missions.oper_flamable_mini_raid_2_destroyed
	self.missions.oper_flamable_mini_raid_2_roundabout = {
		audio_briefing_id = "mrs_white_or_mr2_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_rhinegold_02",
		excluded_continents = {
			"operation1mission1",
			"operation1mission2",
			"operation1mission3",
			"operation2mission1",
		},
		forbids_random = {
			"oper_flamable_mini_raid_2_destroyed",
		},
		icon_menu = "missions_operation_rhinegold_menu_2",
		icon_menu_big = "xp_events_missions_operation_rhinegold_2",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "zone_germany_roundabout_fuel",
		loading = {
			image = "loading_rhinegold_02",
			text = "menu_ger_oper_rhinegold_event_2_loading_text",
		},
		mission_flag = "level_operation_02_mission_02",
		mission_id = "oper_flamable_mini_raid_2_roundabout",
		mission_state = OperationsTweakData.STATE_ZONE_MISSION_SELECTED,
		music_id = "random",
		name_id = "menu_ger_oper_02_event_2_name",
		photos = {
			{
				description_id = "rhinegold_mission_photo_2_description",
				photo = "intel_rhinegold_02",
				title_id = "rhinegold_mission_photo_2_title",
			},
			{
				description_id = "rhinegold_mission_photo_3_description",
				photo = "intel_rhinegold_03",
				title_id = "rhinegold_mission_photo_3_title",
			},
			{
				description_id = "rhinegold_mission_photo_4_description",
				photo = "intel_rhinegold_04",
				title_id = "rhinegold_mission_photo_4_title",
			},
		},
		progress_text_id = "menu_ger_oper_rhinegold_event_2_progress_text",
		progress_title_id = "menu_ger_oper_rhinegold_event_2_progress_title",
		xp = 2200,
	}
	self.missions.oper_flamable.events.mini_raid_2_roundabout = self.missions.oper_flamable_mini_raid_2_roundabout
	self.missions.oper_flamable_bridge = {
		audio_briefing_id = "mrs_white_bridge_op_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_rhinegold_03",
		dogtags = self.dogtag_types.medium,
		forbids_random = {
			"ger_bridge",
		},
		icon_menu = "missions_operation_rhinegold_menu_3",
		icon_menu_big = "xp_events_missions_operation_rhinegold_3",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "ger_bridge",
		loading = {
			image = "loading_rhinegold_03",
			text = "menu_ger_oper_rhinegold_event_3_loading_text",
		},
		mission_flag = "level_operation_02_mission_03",
		mission_id = "oper_flamable_bridge",
		mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED,
		music_id = "ger_bridge",
		name_id = "menu_ger_oper_02_event_3_name",
		photos = {
			{
				description_id = "rhinegold_mission_photo_5_description",
				photo = "intel_rhinegold_05",
				title_id = "rhinegold_mission_photo_5_title",
			},
		},
		progress_text_id = "menu_ger_oper_rhinegold_event_3_progress_text",
		progress_title_id = "menu_ger_oper_rhinegold_event_3_progress_title",
		xp = 2400,
	}
	self.missions.oper_flamable.events.bridge = self.missions.oper_flamable_bridge
	self.missions.oper_flamable_castle = {
		audio_briefing_id = "mrs_white_castle_op_brief_long",
		bounty_filters = {
			forbid_buffs = {
				BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
				BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
		},
		camp_objective_id = "obj_camp_goto_oper_rhinegold_04",
		dogtags = self.dogtag_types.large,
		forbids_random = {
			"settlement",
		},
		icon_menu = "missions_operation_rhinegold_menu_4",
		icon_menu_big = "xp_events_missions_operation_rhinegold_4",
		job_type = OperationsTweakData.JOB_TYPE_RAID,
		level_id = "settlement",
		loading = {
			image = "loading_rhinegold_04",
			text = "menu_ger_oper_rhinegold_event_4_loading_text",
		},
		mission_flag = "level_operation_02_mission_04",
		mission_id = "oper_flamable_castle",
		mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED,
		music_id = "castle",
		name_id = "menu_ger_oper_02_event_4_name",
		progress_text_id = "menu_ger_oper_rhinegold_event_4_progress_text",
		progress_title_id = "menu_ger_oper_rhinegold_event_4_progress_title",
		start_in_stealth = true,
		xp = 4000,
	}
	self.missions.oper_flamable.events.castle = self.missions.oper_flamable_castle
	self.missions.oper_flamable.events_index_template = {
		{
			"mini_raid_1_park",
			"mini_raid_1_destroyed",
			"mini_raid_1_roundabout",
		},
		{
			"mini_raid_2_destroyed",
			"mini_raid_2_roundabout",
		},
		{
			"bridge",
		},
		{
			"castle",
		},
	}

	local function events_from_template(data)
		local events = {}

		for _, template in ipairs(data) do
			for _, job_id in ipairs(template) do
				local job_data = self.missions[job_id]

				if job_data then
					events[job_id] = deep_clone(job_data)
					events[job_id].mission_id = job_id
				end
			end
		end

		return events
	end

	local random_events_intel = {
		"spies_test",
		"spies_test",
		"bunker_test",
		"bunker_test",
		"hunters",
		"hunters",
		"settlement",
		"settlement",
		"radio_defense",
		"convoy",
		"convoy",
		"clear_skies_gold_rush",
		"clear_skies_gold_rush",
		"clear_skies_mini_raid_1_park",
		"clear_skies_mini_raid_1_destroyed",
		"clear_skies_mini_raid_1_roundabout",
		"oper_flamable_mini_raid_1_park",
		"oper_flamable_mini_raid_1_destroyed",
		"oper_flamable_mini_raid_1_roundabout",
	}
	local random_events_padding = {
		"radio_defense",
		"clear_skies_radio_defense",
		"clear_skies_gold_rush",
		"settlement",
		"tnd",
		"hunters",
		"convoy",
		"oper_flamable_bridge",
		"clear_skies_mini_raid_2_park",
		"clear_skies_mini_raid_2_destroyed",
		"spies_test",
		"bunker_test",
	}
	local random_events_reward = {
		"forest_gumpy",
		"fury_railway",
		"sto",
		"gold_rush",
		"kelly",
		"ger_bridge",
	}
	local random_events_finale = {
		"forest_bunker",
		"train_yard",
		"silo",
		"flakturm",
		"clear_skies_flakturm",
		"settlement",
		"oper_flamable_castle",
	}

	self.missions.random_short = {
		briefing_id = "menu_ger_op_random_short_desc",
		camp_objective_id = "obj_camp_goto_op_random_short",
		icon_hud = "op_random_short_hd",
		icon_menu = "op_random_short_lq",
		job_type = OperationsTweakData.JOB_TYPE_OPERATION,
		loading = {
			image = "loading_rhinegold_00",
			text = "menu_ger_oper_rhinegold",
		},
		name_id = "menu_ger_op_random_short_hl",
		photos = {
			{
				description_id = "random_mission_photo_1_description",
				photo = "intel_random_operation_01",
				title_id = "random_mission_photo_1_title",
			},
			{
				description_id = "random_mission_photo_2_description",
				photo = "intel_random_operation_02",
				title_id = "random_mission_photo_2_title",
			},
		},
		region = "germany",
		xp = 500,
	}
	self.missions.random_short.events_index_template = {
		random_events_padding,
		random_events_finale,
	}
	self.missions.random_short.events = events_from_template(self.missions.random_short.events_index_template)
	self.missions.random_medium = deep_clone(self.missions.random_short)
	self.missions.random_medium.name_id = "menu_ger_op_random_medium_hl"
	self.missions.random_medium.briefing_id = "menu_ger_op_random_medium_desc"
	self.missions.random_medium.camp_objective_id = "obj_camp_goto_op_random_medium"
	self.missions.random_medium.xp = 1800
	self.missions.random_medium.icon_hud = "op_random_medium_hd"
	self.missions.random_medium.icon_menu = "op_random_medium_lq"
	self.missions.random_medium.photos = {
		{
			description_id = "random_mission_photo_1_description",
			photo = "intel_random_operation_01",
			title_id = "random_mission_photo_1_title",
		},
		{
			description_id = "random_mission_photo_1_description",
			photo = "intel_random_operation_01",
			title_id = "random_mission_photo_1_title",
		},
		{
			description_id = "random_mission_photo_3_description",
			photo = "intel_random_operation_03",
			title_id = "random_mission_photo_3_title",
		},
		{
			description_id = "random_mission_photo_2_description",
			photo = "intel_random_operation_02",
			title_id = "random_mission_photo_2_title",
		},
	}
	self.missions.random_medium.events_index_template = {
		random_events_intel,
		random_events_padding,
		random_events_reward,
		random_events_finale,
	}
	self.missions.random_medium.events = events_from_template(self.missions.random_medium.events_index_template)
	self.missions.random_long = deep_clone(self.missions.random_short)
	self.missions.random_long.name_id = "menu_ger_op_random_long_hl"
	self.missions.random_long.briefing_id = "menu_ger_op_random_long_desc"
	self.missions.random_long.camp_objective_id = "obj_camp_goto_op_random_long"
	self.missions.random_long.xp = 3000
	self.missions.random_long.icon_hud = "op_random_long_hd"
	self.missions.random_long.icon_menu = "op_random_long_lq"
	self.missions.random_long.photos = {
		{
			description_id = "random_mission_photo_1_description",
			photo = "intel_random_operation_01",
			title_id = "random_mission_photo_1_title",
		},
		{
			description_id = "random_mission_photo_1_description",
			photo = "intel_random_operation_01",
			title_id = "random_mission_photo_1_title",
		},
		{
			description_id = "random_mission_photo_3_description",
			photo = "intel_random_operation_03",
			title_id = "random_mission_photo_3_title",
		},
		{
			description_id = "random_mission_photo_1_description",
			photo = "intel_random_operation_01",
			title_id = "random_mission_photo_1_title",
		},
		{
			description_id = "random_mission_photo_3_description",
			photo = "intel_random_operation_03",
			title_id = "random_mission_photo_3_title",
		},
		{
			description_id = "random_mission_photo_2_description",
			photo = "intel_random_operation_02",
			title_id = "random_mission_photo_2_title",
		},
	}
	self.missions.random_long.events_index_template = {
		random_events_intel,
		random_events_padding,
		random_events_reward,
		random_events_padding,
		random_events_reward,
		random_events_finale,
	}
	self.missions.random_long.events = events_from_template(self.missions.random_long.events_index_template)
end

function OperationsTweakData:get_all_loading_screens()
	return self._loading_screens
end

function OperationsTweakData:get_loading_screen(level)
	local level = self._loading_screens[level]

	if level.success and managers.raid_job:current_job() then
		if managers.raid_job:stage_success() then
			return self._loading_screens[level].success
		else
			return self._loading_screens[level].fail
		end
	else
		return self._loading_screens[level] or self._loading_screens.generic
	end
end

function OperationsTweakData:mission_data(mission_id)
	if not mission_id or not self.missions[mission_id] then
		Application:error("[OperationsTweakData:mission_data] There was no mission id or no missions for the id:", mission_id)

		return
	end

	local mission_data = deep_clone(self.missions[mission_id])

	mission_data.job_id = mission_id

	return mission_data
end

function OperationsTweakData:get_raids_index()
	return self._raids_index
end

function OperationsTweakData:get_operations_index()
	return self._operations_index
end

function OperationsTweakData:get_index_from_raid_id(raid_id)
	for index, entry_name in ipairs(self._raids_index) do
		if entry_name == raid_id then
			return index
		end
	end

	return 0
end

function OperationsTweakData:get_index_from_operation_id(raid_id)
	for index, entry_name in ipairs(self._operations_index) do
		if entry_name == raid_id then
			return index
		end
	end

	return 0
end

function OperationsTweakData:get_region_index_from_name(region_name)
	for index, reg_name in ipairs(self.regions) do
		if region_name == reg_name then
			return index
		end
	end

	return 0
end

function OperationsTweakData:get_raid_name_from_index(index)
	return self._raids_index[index]
end

function OperationsTweakData:get_operation_name_from_index(index)
	return self._operations_index[index]
end

function OperationsTweakData:randomize_operation(operation_id, operation_data)
	operation_data = operation_data or self.missions[operation_id]

	local template = operation_data.events_index_template
	local calculated_index = {}
	local already_picked = {}

	for _, value in ipairs(template) do
		local picked = false

		while not picked do
			local index = math.floor(math.rand(#value)) + 1
			local mission_id = value[index]

			if not already_picked[mission_id] then
				already_picked[mission_id] = true

				table.insert(calculated_index, mission_id)

				local mission_data = operation_data.events[mission_id]

				if mission_data and mission_data.forbids_random then
					for _, forbid_id in ipairs(mission_data.forbids_random) do
						already_picked[forbid_id] = true
					end
				end

				picked = true
			end
		end
	end

	operation_data.events_index = calculated_index

	Application:debug("[OperationsTweakData:randomize_operation]", operation_id, inspect(calculated_index))
end

function OperationsTweakData:get_raid_id_from_raid_index(operation_id, raid_index)
	local operation = self.missions[operation_id]

	if operation ~= nil then
		local template = operation.events_index_template
		local rows = #template
		local i = math.floor(raid_index / rows) + 1
		local j = raid_index % rows + 1

		return template[i][j]
	end

	return ""
end

function OperationsTweakData:get_raid_index_from_raid_id(operation_id, raid_id)
	local operation = self.missions[operation_id]

	if operation ~= nil then
		local template = operation.events_index_template
		local rows = #template

		for i, value_i in ipairs(template) do
			for j, value_j in ipairs(value_i) do
				if value_j == raid_id then
					local index = (i - 1) * rows + (j - 1)

					return index
				end
			end
		end
	end

	return 0
end

function OperationsTweakData:get_operation_indexes_delimited(mission_id, mission_data)
	local events_index = (mission_data or self.missions[mission_id]).events_index

	return table.concat(events_index, "|")
end

function OperationsTweakData:set_operation_indexes_delimited(mission_id, delimited_string)
	self.missions[mission_id].events_index = string.split(delimited_string, "|")
end

function OperationsTweakData:get_all_consumable_raids()
	local raids = self:get_raids_index()
	local consumable_missions = {}

	for i, raid in pairs(raids) do
		if tweak_data.operations.missions[raid].consumable then
			table.insert(consumable_missions, raid)
		end
	end

	Application:debug("[OperationsTweakData] get_all_consumable_raids, Found:", #consumable_missions)

	return consumable_missions
end

function OperationsTweakData:get_random_consumable_raid()
	local consumable_missions = self:get_all_consumable_raids()
	local chosen_consumable_id = consumable_missions[math.random(1, #consumable_missions)]

	Application:debug("[OperationsTweakData:get_random_consumable_raid]", chosen_consumable_id)

	return chosen_consumable_id
end

function OperationsTweakData:get_random_unowned_consumable_raid()
	local consumable_missions = {}
	local all_consumables = self:get_all_consumable_raids()

	for i, v in ipairs(all_consumables) do
		if not Global.consumable_missions_manager.inventory[v] then
			table.insert(consumable_missions, v)
		end
	end

	local chosen_consumable_id = consumable_missions[math.random(1, #consumable_missions)]

	Application:debug("[OperationsTweakData:get_random_unowned_consumable_raid]", chosen_consumable_id)

	return chosen_consumable_id
end

function OperationsTweakData:get_all_mission_flags()
	local mission_flags = {}

	for _, mission in pairs(self.missions) do
		local flag = mission.mission_flag

		if flag and not table.contains(mission_flags, flag) then
			table.insert(mission_flags, flag)
		end
	end

	return mission_flags
end
