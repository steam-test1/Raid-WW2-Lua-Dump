AchievementTweakData = AchievementTweakData or class()

function AchievementTweakData:init(tweak_data)
	self:_init_experience_awards()
	self:_init_mission_awards()
end

function AchievementTweakData:_init_experience_awards()
	self.experience = {
		{
			id = "ach_reach_level_2",
			level = 2,
		},
		{
			id = "ach_reach_level_5",
			level = 5,
		},
		{
			id = "ach_reach_level_10",
			level = 10,
		},
		{
			id = "ach_reach_level_20",
			level = 20,
		},
		{
			id = "ach_reach_level_30",
			level = 30,
		},
		{
			id = "ach_reach_level_40",
			level = 40,
		},
	}
end

function AchievementTweakData:_init_mission_awards()
	local very_hard = 4

	self.missions = {}
	self.missions.clear_skies = {
		{
			difficulty = very_hard,
			id = "ach_clear_skies_hardest",
		},
		{
			id = "ach_clear_skies_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
		{
			difficulty = very_hard,
			id = "ach_clear_skies_hardest_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
	}
	self.missions.oper_flamable = {
		{
			difficulty = very_hard,
			id = "ach_burn_hardest",
		},
		{
			id = "ach_burn_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
		{
			difficulty = very_hard,
			id = "ach_burn_hardest_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
	}
	self.missions.random_short = {
		{
			difficulty = very_hard,
			id = "ach_random_short_hardest",
		},
		{
			id = "ach_random_short_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
		{
			difficulty = very_hard,
			id = "ach_random_short_hardest_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
	}
	self.missions.random_medium = {
		{
			difficulty = very_hard,
			id = "ach_random_medium_hardest",
		},
		{
			id = "ach_random_medium_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
		{
			difficulty = very_hard,
			id = "ach_random_medium_hardest_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
	}
	self.missions.random_long = {
		{
			difficulty = very_hard,
			id = "ach_random_long_hardest",
		},
		{
			id = "ach_random_long_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
		{
			difficulty = very_hard,
			id = "ach_random_long_hardest_no_bleedout",
			no_bleedout = true,
			num_peers = 2,
		},
	}
	self.missions.flakturm = {
		{
			difficulty = very_hard,
			id = "ach_flak_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_flak",
		},
	}
	self.missions.settlement = {
		{
			difficulty = very_hard,
			id = "ach_castle_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_castle",
		},
	}
	self.missions.train_yard = {
		{
			difficulty = very_hard,
			id = "ach_trainyard_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_trainyard",
		},
	}
	self.missions.gold_rush = {
		{
			difficulty = very_hard,
			id = "ach_bank_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_bank",
		},
	}
	self.missions.radio_defense = {
		{
			difficulty = very_hard,
			id = "ach_radiodefence_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_radiodefence",
		},
	}
	self.missions.ger_bridge = {
		{
			difficulty = very_hard,
			id = "ach_bridge_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_bridge",
		},
	}
	self.missions.hunters = {
		{
			difficulty = very_hard,
			id = "ach_hunters_hardest",
		},
		{
			id = "ach_hunters_stealth",
			stealth = true,
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_hunters",
		},
	}
	self.missions.tnd = {
		{
			difficulty = very_hard,
			id = "ach_tank_depot_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_tank_depot",
		},
	}
	self.missions.bunker_test = {
		{
			difficulty = very_hard,
			id = "ach_bunkers_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_bunkers",
		},
	}
	self.missions.convoy = {
		{
			difficulty = very_hard,
			id = "ach_sommelier_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_sommelier",
		},
	}
	self.missions.spies_test = {
		{
			difficulty = very_hard,
			id = "ach_airfield_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_airfield",
		},
	}
	self.missions.silo = {
		{
			difficulty = very_hard,
			id = "ach_silo_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_silo",
		},
	}
	self.missions.kelly = {
		{
			difficulty = very_hard,
			id = "ach_kelly_hardest",
		},
		{
			id = "ach_kelly_stealth",
			stealth = true,
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_kelly",
		},
	}
	self.missions.sto = {
		{
			difficulty = very_hard,
			id = "ach_gallery_hardest",
		},
		{
			id = "ach_gallery_stealth",
			stealth = true,
		},
	}
	self.missions.forest_gumpy = {
		{
			difficulty = very_hard,
			id = "ach_forest_convoy_hardest",
		},
	}
	self.missions.fury_railway = {
		{
			difficulty = very_hard,
			id = "ach_fury_railway_hardest",
		},
	}
	self.missions.forest_bunker = {
		{
			difficulty = very_hard,
			id = "ach_forest_bunker_hardest",
		},
		{
			all_dogtags = true,
			id = "ach_bring_them_home_forest_bunker",
		},
	}
end
