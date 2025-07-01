CampCustomizationTweakData = CampCustomizationTweakData or class()
CampCustomizationTweakData.VERSION = 2

function CampCustomizationTweakData:init()
	self:_setup_camp_assets()
	self:_setup_default_camp_list()
end

function CampCustomizationTweakData:_setup_camp_assets()
	self.camp_upgrades_automatic = {}
	self.camp_upgrades_automatic.gold_pile = {
		gold = {
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10,
			15,
			20,
			30,
			50,
			75,
			100,
			125,
			150,
			175,
			200,
			250,
			300,
			350,
			400,
			450,
			500,
			550,
			600,
			650,
			700,
			750,
			800,
			850,
			900,
			950,
			1000,
			1100,
			1200,
			1300,
			1400,
			1500,
			1600,
			1700,
			1800,
			1900,
			2000,
			2200,
			2400,
			2600,
			2800,
			3000,
			3500,
			4000,
			4500,
			5000,
			5500,
			6000,
			6500,
			7000,
			7500,
			8000,
			8500,
			9000,
			9500,
			10000,
			11000,
			12000,
			13000,
			14000,
			15000,
			16000,
			17000,
			18000,
			19000,
			20000,
			22000,
			24000,
			26000,
			28000,
			30000,
			35000,
			40000,
			45000,
			50000,
			70000,
			100000,
			150000,
			250000,
		},
	}
	self.camp_upgrades = {}
	self.camp_upgrades.golden_bomb = {
		purchasable = true,
		levels = {
			{
				description_id = "golden_bomb_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_bomb/bomb_l02_hud",
				name_id = "golden_bomb_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_bomb/level_1/props_camp_bomb_level_01_shop",
			},
			{
				description_id = "golden_bomb_lvl_2_desc_id",
				gold_price = 1000,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_bomb/bomb_l02_hud",
				name_id = "golden_bomb_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_bomb/level_2/props_camp_bomb_level_02_shop",
			},
		},
	}
	self.camp_upgrades.golden_toilet = {
		purchasable = true,
		levels = {
			{
				description_id = "golden_toilet_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_camp_toilet/toilet_l02_hud",
				name_id = "golden_toilet_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_camp_toilet/level_01/props_camp_toilet_level_01_shop",
				scene_unit_rotation = Rotation(180, 0, 0),
			},
			{
				description_id = "golden_toilet_lvl_2_desc_id",
				gold_price = 250,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_camp_toilet/toilet_l02_hud",
				name_id = "golden_toilet_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_camp_toilet/level_02/props_camp_toilet_level_02_shop",
				scene_unit_rotation = Rotation(180, 0, 0),
			},
		},
	}
	self.camp_upgrades.mission_table = {
		purchasable = true,
		levels = {
			{
				description_id = "mission_table_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_mission/table_missions_l02_hud",
				name_id = "mission_table_lvl_1_desc_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_mission/level_1/props_table_mission_level_01_shop",
			},
			{
				description_id = "mission_table_lvl_2_desc_id",
				gold_price = 500,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_mission/table_missions_l02_hud",
				name_id = "mission_table_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_mission/level_2/props_table_mission_level_02_shop",
			},
		},
	}
	self.camp_upgrades.weapons_table = {
		purchasable = true,
		levels = {
			{
				description_id = "weapons_table_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_weapon_upgrades/table_weapons_hud",
				name_id = "weapons_table_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_weapon_upgrades/level_1/props_table_weapon_upgrades_level_01_shop",
				scene_unit_rotation = Rotation(90, 0, 0),
			},
			{
				description_id = "weapons_table_lvl_2_desc_id",
				gold_price = 500,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_weapon_upgrades/table_weapons_hud",
				name_id = "weapons_table_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_weapon_upgrades/level_2/props_table_weapon_upgrades_level_02_shop",
				scene_unit_rotation = Rotation(90, 0, 0),
			},
		},
	}
	self.camp_upgrades.skill_table = {
		purchasable = true,
		levels = {
			{
				description_id = "skill_table_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_skills/table_skills_l02_hud",
				name_id = "skill_table_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_skills/level_1/props_table_skills_level_01_shop",
			},
			{
				description_id = "skill_table_lvl_2_desc_id",
				gold_price = 500,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_skills/table_skills_l02_hud",
				name_id = "skill_table_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_skills/level_2/props_table_skills_level_02_shop",
			},
		},
	}
	self.camp_upgrades.character_table = {
		purchasable = true,
		levels = {
			{
				description_id = "char_table_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_caracter_creation/table_character_customization_l02_hud",
				name_id = "char_table_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_caracter_creation/level_1/props_table_caracter_creation_level_01_shop",
				scene_unit_rotation = Rotation(90, 0, 0),
			},
			{
				description_id = "char_table_lvl_2_desc_id",
				gold_price = 500,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_caracter_creation/table_character_customization_l02_hud",
				name_id = "char_table_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_caracter_creation/level_2/props_table_caracter_creation_level_02_shop",
				scene_unit_rotation = Rotation(90, 0, 0),
			},
		},
	}
	self.camp_upgrades.card_table = {
		purchasable = true,
		levels = {
			{
				description_id = "card_table_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_challenge_cards/table_cards_l02_hud",
				name_id = "card_table_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_challenge_cards/level_1/props_card_table_level_01_shop",
			},
			{
				description_id = "card_table_lvl_2_desc_id",
				gold_price = 500,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_challenge_cards/table_cards_l02_hud",
				name_id = "card_table_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_challenge_cards/level_2/props_card_table_level_02_shop",
			},
		},
	}
	self.camp_upgrades.radio_table = {
		purchasable = true,
		levels = {
			{
				description_id = "radio_table_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_radio/table_servers_l02_hud",
				name_id = "radio_table_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_radio/level_1/props_table_radio_level_01_shop",
				scene_unit_rotation = Rotation(90, 0, 0),
			},
			{
				description_id = "radio_table_lvl_2_desc_id",
				gold_price = 500,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_table_radio/table_servers_l02_hud",
				name_id = "radio_table_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_table_radio/level_2/props_table_radio_level_02_shop",
				scene_unit_rotation = Rotation(90, 0, 0),
			},
		},
	}
	self.camp_upgrades.large_picture_1 = {
		purchasable = true,
		levels = {
			{
				description_id = "large_picture_lvl_1_desc_id",
				gold_price = 100,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_painting_medium_01/painting_medium_01_l02_hud",
				name_id = "large_picture_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_painting_medium_01/level_1/props_painting_medium_01_level_01_shop",
			},
		},
	}
	self.camp_upgrades.large_picture_2 = {
		purchasable = true,
		levels = {
			{
				description_id = "large_picture_lvl_2_desc_id",
				gold_price = 150,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_painting_medium_02/painting_medium_02_l02_hud",
				name_id = "large_picture_lvl_2_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_painting_medium_02/level_1/props_painting_medium_02_level_01_shop",
			},
		},
	}
	self.camp_upgrades.piano = {
		purchasable = true,
		levels = {
			{
				description_id = "piano_lvl_1_desc_id",
				gold_price = 0,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_camp_piano/piano_l02_hud",
				name_id = "piano_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_camp_piano/level_1/props_camp_piano_level_01_shop",
				scene_unit_rotation = Rotation(0, 0, 0),
			},
			{
				description_id = "piano_lvl_1_desc_id",
				gold_price = 250,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_camp_piano/piano_l02_hud",
				name_id = "piano_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_camp_piano/level_1/props_camp_piano_level_01_shop",
				scene_unit_rotation = Rotation(0, 0, 0),
			},
		},
	}
	self.camp_upgrades.rug = {
		purchasable = true,
		levels = {
			{
				description_id = "rug_lvl_1_desc_id",
				gold_price = 100,
				grid_icon = "units/vanilla/props/props_camp_upgrades/props_camp_carpet/carpet_l02_hud",
				name_id = "rug_lvl_1_name_id",
				scene_unit = "units/vanilla/props/props_camp_upgrades/props_camp_carpet/level_1/props_camp_carpet_level_01_shop",
				scene_unit_rotation = Rotation(180, 0, 0),
			},
		},
	}
end

function CampCustomizationTweakData:_setup_default_camp_list()
	self.default_camp = {
		{
			upgrade = "gold_pile",
		},
		{
			level = 1,
			upgrade = "golden_bomb",
		},
		{
			level = 1,
			upgrade = "golden_toilet",
		},
		{
			level = 1,
			upgrade = "mission_table",
		},
		{
			level = 1,
			upgrade = "weapons_table",
		},
		{
			level = 1,
			upgrade = "skill_table",
		},
		{
			level = 1,
			upgrade = "character_table",
		},
		{
			level = 1,
			upgrade = "card_table",
		},
		{
			level = 1,
			upgrade = "radio_table",
		},
		{
			level = 0,
			upgrade = "large_picture_1",
		},
		{
			level = 0,
			upgrade = "large_picture_2",
		},
		{
			level = 1,
			upgrade = "piano",
		},
		{
			level = 0,
			upgrade = "rug",
		},
	}
end
