OperationsTweakData = OperationsTweakData or class()
OperationsTweakData.JOB_TYPE_RAID = 1
OperationsTweakData.JOB_TYPE_OPERATION = 2
OperationsTweakData.IN_LOBBY = "in_lobby"
OperationsTweakData.STATE_ZONE_MISSION_SELECTED = "system_zone_mission_selected"
OperationsTweakData.STATE_LOCATION_MISSION_SELECTED = "system_location_mission_selected"
OperationsTweakData.ENTRY_POINT_LEVEL = "streaming_level"

function OperationsTweakData:init()
	self.missions = {}
	self.HEAT_OTHER_JOBS_RATIO = 0.3
	self.ABSOLUTE_ZERO_JOBS_HEATS_OTHERS = false
	self.HEATED_MAX_XP_MUL = 1.15
	self.FREEZING_MAX_XP_MUL = 0.7
	self.DEFAULT_HEAT = {
		other_jobs = 5,
		this_job = -5,
	}
	self.MAX_JOBS_IN_CONTAINERS = {
		6,
		18,
		24,
		false,
		12,
		4,
		1,
	}

	self:_init_loading_screens()
	self:_init_regions()
	self:_init_raids()
	self:_init_operations()
	self:_init_consumable_missions_data()
end

function OperationsTweakData:_init_regions()
	self.regions = {
		"germany",
		"france",
		"africa",
	}
end

function OperationsTweakData:_init_consumable_missions_data()
	self.consumable_missions = {}
	self.consumable_missions.base_document_spawn_chance = {
		0.2,
		0.2,
		0.2,
		0.2,
	}
	self.consumable_missions.spawn_chance_modifier_increase = 0.1
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
	self._loading_screens.bridge = {}
	self._loading_screens.bridge.image = "loading_raid_ww2"
	self._loading_screens.bridge.text = "loading_bridge"
	self._loading_screens.tnd = {}
	self._loading_screens.tnd.image = "loading_screens_07"
	self._loading_screens.tnd.text = "loading_bridge"
	self._loading_screens.hunters = {}
	self._loading_screens.hunters.image = "loading_screens_07"
	self._loading_screens.hunters.text = "loading_bridge"
end

function OperationsTweakData:_init_raids()
	self._raids_index = {
		"flakturm",
		"hunters",
		"ger_bridge",
		"tnd",
		"train_yard",
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
	self.missions.camp.tab_background_image = "ui/hud/backgrounds/tab_screen_bg_camp_hud"
	self.missions.tutorial = {}
	self.missions.tutorial.name_id = "menu_tutorial_hl"
	self.missions.tutorial.level_id = "tutorial"
	self.missions.tutorial.briefing_id = "menu_tutorial_desc"
	self.missions.tutorial.audio_briefing_id = "flakturm_briefing_long"
	self.missions.tutorial.short_audio_briefing_id = "flakturm_brief_short"
	self.missions.tutorial.music_id = "camp"
	self.missions.tutorial.region = "germany"
	self.missions.tutorial.xp = 1000
	self.missions.tutorial.stealth_bonus = 1.5
	self.missions.tutorial.start_in_stealth = true
	self.missions.tutorial.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.tutorial.mission_flag = "level_tutorial"
	self.missions.tutorial.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.tutorial.icon_menu = "missions_tutorial"
	self.missions.tutorial.icon_hud = "miissions_raid_flaktower"
	self.missions.tutorial.excluded_continents = {
		"operation",
	}
	self.missions.tutorial.tab_background_image = "ui/hud/backgrounds/tab_screen_bg_raid_flak_hud"
	self.missions.tutorial.loading = {
		image = "raid_loading_tutorial",
		text = "loading_tutorial",
	}
	self.missions.tutorial.photos = {
		{
			description_id = "flak_mission_photo_1_description",
			photo = "intel_flak_01",
			title_id = "flak_mission_photo_1_title",
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
	self.missions.flakturm.xp = 1000
	self.missions.flakturm.stealth_bonus = 1.5
	self.missions.flakturm.start_in_stealth = true
	self.missions.flakturm.dogtags_min = 32
	self.missions.flakturm.dogtags_max = 37
	self.missions.flakturm.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.flakturm.mission_flag = "level_raid_flakturm"
	self.missions.flakturm.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.flakturm.icon_menu = "missions_raid_flaktower_menu"
	self.missions.flakturm.icon_hud = "miissions_raid_flaktower"
	self.missions.flakturm.excluded_continents = {
		"operation",
	}
	self.missions.flakturm.tab_background_image = "ui/hud/backgrounds/tab_screen_bg_raid_flak_hud"
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
	self.missions.train_yard = {}
	self.missions.train_yard.name_id = "menu_ger_miss_05_hl"
	self.missions.train_yard.level_id = "train_yard"
	self.missions.train_yard.briefing_id = "menu_ger_miss_05_desc"
	self.missions.train_yard.audio_briefing_id = "trainyard_briefing_long"
	self.missions.train_yard.short_audio_briefing_id = "trainyard_brief_short"
	self.missions.train_yard.region = "germany"
	self.missions.train_yard.music_id = "train_yard"
	self.missions.train_yard.start_in_stealth = true
	self.missions.train_yard.xp = 1000
	self.missions.train_yard.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.train_yard.mission_flag = "level_raid_train_yard"
	self.missions.train_yard.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.train_yard.icon_menu = "mission_raid_railyard_menu"
	self.missions.train_yard.icon_hud = "mission_raid_railyard"
	self.missions.train_yard.tab_background_image = "ui/hud/backgrounds/tab_screen_bg_raid_railyard_hud"
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
	self.missions.ger_bridge = {}
	self.missions.ger_bridge.name_id = "menu_ger_bridge_00_hl"
	self.missions.ger_bridge.level_id = "ger_bridge"
	self.missions.ger_bridge.briefing_id = "menu_ger_bridge_00_hl_desc"
	self.missions.ger_bridge.audio_briefing_id = "bridge_briefing_long"
	self.missions.ger_bridge.short_audio_briefing_id = "bridge_brief_short"
	self.missions.ger_bridge.region = "germany"
	self.missions.ger_bridge.music_id = "ger_bridge"
	self.missions.ger_bridge.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.ger_bridge.mission_flag = "level_raid_bridge"
	self.missions.ger_bridge.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.ger_bridge.xp = 1000
	self.missions.ger_bridge.dogtags_min = 28
	self.missions.ger_bridge.dogtags_max = 34
	self.missions.ger_bridge.icon_menu = "missions_raid_bridge_menu"
	self.missions.ger_bridge.icon_hud = "missions_raid_bridge"
	self.missions.ger_bridge.tab_background_image = "ui/hud/backgrounds/tab_screen_bg_raid_bridge_hud"
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
	self.missions.tnd = {}
	self.missions.tnd.name_id = "menu_tnd_hl"
	self.missions.tnd.level_id = "tnd"
	self.missions.tnd.briefing_id = "menu_tnd_desc"
	self.missions.tnd.audio_briefing_id = "mrs_white_tank_depot_brief_long"
	self.missions.tnd.short_audio_briefing_id = "mrs_white_tank_depot_briefing_short"
	self.missions.tnd.music_id = "castle"
	self.missions.tnd.region = "germany"
	self.missions.tnd.xp = 1000
	self.missions.tnd.stealth_bonus = 1.5
	self.missions.tnd.dogtags_min = 30
	self.missions.tnd.dogtags_max = 37
	self.missions.tnd.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.tnd.mission_flag = "level_raid_tnd"
	self.missions.tnd.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.tnd.icon_menu = "missions_tank_depot"
	self.missions.tnd.icon_hud = "missions_raid_flaktower"
	self.missions.tnd.tab_background_image = "ui/hud/backgrounds/tab_screen_bg_raid_flak_hud"
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
	self.missions.hunters.xp = 1000
	self.missions.hunters.stealth_bonus = 1.5
	self.missions.hunters.dogtags_min = 30
	self.missions.hunters.dogtags_max = 37
	self.missions.hunters.mission_state = OperationsTweakData.STATE_LOCATION_MISSION_SELECTED
	self.missions.hunters.mission_flag = "level_raid_hunters"
	self.missions.hunters.job_type = OperationsTweakData.JOB_TYPE_RAID
	self.missions.hunters.icon_menu = "missions_hunters"
	self.missions.hunters.icon_hud = "missions_raid_flaktower"
	self.missions.hunters.tab_background_image = "ui/hud/backgrounds/tab_screen_bg_raid_flak_hud"
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
			description_id = "hunters_mission_photo_3_description",
			photo = "intel_hunters_03",
			title_id = "hunters_mission_photo_3_title",
		},
		{
			description_id = "hunters_mission_photo_4_description",
			photo = "intel_hunters_04",
			title_id = "hunters_mission_photo_4_title",
		},
	}
end

function OperationsTweakData:_init_operations()
	self._operations_index = {}
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
		return self._loading_screens[level]
	end
end

function OperationsTweakData:mission_data(mission_id)
	if not mission_id or not self.missions[mission_id] then
		return
	end

	local res = deep_clone(self.missions[mission_id])

	res.job_id = mission_id

	return res
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

function OperationsTweakData:randomize_operation(operation_id)
	local operation = self.missions[operation_id]
	local template = operation.events_index_template
	local calculated_index = {}

	for _, value in ipairs(template) do
		local index = math.floor(math.rand(#value)) + 1

		table.insert(calculated_index, value[index])
	end

	operation.events_index = calculated_index

	Application:debug("[OperationsTweakData:randomize_operation]", operation_id, inspect(calculated_index))
end

function OperationsTweakData:get_operation_indexes_delimited(operation_id)
	return table.concat(self.missions[operation_id].events_index, "|")
end

function OperationsTweakData:set_operation_indexes_delimited(operation_id, delimited_string)
	self.missions[operation_id].events_index = string.split(delimited_string, "|")
end
