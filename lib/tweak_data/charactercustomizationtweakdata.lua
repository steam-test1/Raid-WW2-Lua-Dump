CharacterCustomizationTweakData = CharacterCustomizationTweakData or class()
CharacterCustomizationTweakData.NATIONALITY_AMERICAN = "american"
CharacterCustomizationTweakData.NATIONALITY_GERMAN = "german"
CharacterCustomizationTweakData.NATIONALITY_BRITISH = "british"
CharacterCustomizationTweakData.NATIONALITY_RUSSIAN = "russian"
CharacterCustomizationTweakData.SKILL_TRACK_RECON = "recon"
CharacterCustomizationTweakData.SKILL_TRACK_ASSAULT = "assault"
CharacterCustomizationTweakData.SKILL_TRACK_DEMOLITION = "demolition"
CharacterCustomizationTweakData.PART_TYPE_HEAD = "character_customization_type_head"
CharacterCustomizationTweakData.PART_TYPE_UPPER = "character_customization_type_upper"
CharacterCustomizationTweakData.PART_TYPE_LOWER = "character_customization_type_lower"
CharacterCustomizationTweakData.CRIMINAL_MENU_SELECT_UNIT = "units/vanilla/characters/players/criminal_empty/criminal_empty_menu"
CharacterCustomizationTweakData.PART_LENGTH_SHORT = "length_short"
CharacterCustomizationTweakData.PART_LENGTH_LONG = "length_long"

function CharacterCustomizationTweakData:init()
	self:initialization()

	self.nationality_index = {
		"american",
		"german",
		"british",
		"russian",
	}
	self.body_part_index = {
		"head",
		"upper",
		"lower",
	}
	self.customization_animation_idle_loop = "character_customization_standing_loop"
	self.customization_animations = {
		"character_customization_clap",
		"character_customization_posing",
		"character_customization_salut",
		"character_customization_shadowboxing",
		"character_customization_your_done",
		"character_customization_adjust_collar",
		"character_customization_adjust_sleves",
		"character_customization_polish_boots",
		"character_customization_stretch_arms",
		"character_customization_stretch_legs",
		"character_customization_brush",
		"character_customization_wave_camera",
	}
end

function CharacterCustomizationTweakData:initialization()
	self.customizations = {}
	self.customizations.american_default_head = {}
	self.customizations.american_default_head.name = "character_customization_american_default_name_head"
	self.customizations.american_default_head.description = "character_customization_american_default_desc_head"
	self.customizations.american_default_head.part_type = CharacterCustomizationTweakData.PART_TYPE_HEAD
	self.customizations.american_default_head.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_AMERICAN,
	}
	self.customizations.american_default_head.path = "units/vanilla/characters/players/usa/head/player_usa_head_002/player_usa_head_002"
	self.customizations.american_default_head.path_icon = "ui/temp/customization_temp_df"
	self.customizations.american_default_head.redeem_xp = 0
	self.customizations.american_default_head.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.american_default_upper = {}
	self.customizations.american_default_upper.name = "character_customization_american_default_name_upper"
	self.customizations.american_default_upper.description = "character_customization_american_default_desc_upper"
	self.customizations.american_default_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.american_default_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_AMERICAN,
	}
	self.customizations.american_default_upper.path = "units/vanilla/characters/players/usa/upper/tanker_001/npc_criminal_usa_tanker_001_upper"
	self.customizations.american_default_upper.path_icon = "units/vanilla/characters/players/usa/upper/tanker_001/player_usa_tanker_001_upper_hud"
	self.customizations.american_default_upper.path_fps_hands = "units/vanilla/characters/players/usa/fp/tanker_001/player_usa_tanker_001_fp"
	self.customizations.american_default_upper.redeem_xp = 0
	self.customizations.american_default_upper.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.american_default_upper.length = CharacterCustomizationTweakData.PART_LENGTH_SHORT
	self.customizations.american_default_lower = {}
	self.customizations.american_default_lower.name = "character_customization_american_default_name_lower"
	self.customizations.american_default_lower.description = "character_customization_american_default_desc_lower"
	self.customizations.american_default_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.american_default_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_AMERICAN,
	}
	self.customizations.american_default_lower.path_long = "units/vanilla/characters/players/usa/lower/tanker_001/npc_criminal_usa_tanker_001_lower"
	self.customizations.american_default_lower.path_short = "units/vanilla/characters/players/usa/lower/tanker_001/npc_criminal_usa_tanker_001_lower_short"
	self.customizations.american_default_lower.path_icon = "units/vanilla/characters/players/usa/lower/tanker_001/player_usa_tanker_001_lower_hud"
	self.customizations.american_default_lower.redeem_xp = 0
	self.customizations.american_default_lower.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.german_default_head = {}
	self.customizations.german_default_head.name = "character_customization_german_default_name_head"
	self.customizations.german_default_head.description = "character_customization_german_default_desc_head"
	self.customizations.german_default_head.part_type = CharacterCustomizationTweakData.PART_TYPE_HEAD
	self.customizations.german_default_head.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_GERMAN,
	}
	self.customizations.german_default_head.path = "units/vanilla/characters/players/german/head/player_german_head_002/player_german_head_002"
	self.customizations.german_default_head.path_icon = "ui/temp/customization_temp_df"
	self.customizations.german_default_head.redeem_xp = 0
	self.customizations.german_default_head.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.german_default_upper = {}
	self.customizations.german_default_upper.name = "character_customization_german_default_name_upper"
	self.customizations.german_default_upper.description = "character_customization_german_default_desc_upper"
	self.customizations.german_default_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.german_default_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_GERMAN,
	}
	self.customizations.german_default_upper.path = "units/vanilla/characters/players/german/upper/default_002/player_german_default_002_upper"
	self.customizations.german_default_upper.path_icon = "units/vanilla/characters/players/german/upper/default_002/player_german_default_002_upper_hud"
	self.customizations.german_default_upper.path_fps_hands = "units/vanilla/characters/players/german/fp/default_002/player_german_default_002_fp"
	self.customizations.german_default_upper.redeem_xp = 0
	self.customizations.german_default_upper.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.german_default_upper.length = CharacterCustomizationTweakData.PART_LENGTH_LONG
	self.customizations.german_default_lower = {}
	self.customizations.german_default_lower.name = "character_customization_german_default_name_lower"
	self.customizations.german_default_lower.description = "character_customization_german_default_desc_lower"
	self.customizations.german_default_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.german_default_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_GERMAN,
	}
	self.customizations.german_default_lower.path_long = "units/vanilla/characters/players/german/lower/default_002/player_german_default_002_lower"
	self.customizations.german_default_lower.path_short = "units/vanilla/characters/players/german/lower/default_002/player_german_default_002_lower_short"
	self.customizations.german_default_lower.path_icon = "units/vanilla/characters/players/german/lower/default_002/player_german_default_002_lower_hud"
	self.customizations.german_default_lower.redeem_xp = 0
	self.customizations.german_default_lower.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.british_default_head = {}
	self.customizations.british_default_head.name = "character_customization_british_default_name_head"
	self.customizations.british_default_head.description = "character_customization_british_default_desc_head"
	self.customizations.british_default_head.part_type = CharacterCustomizationTweakData.PART_TYPE_HEAD
	self.customizations.british_default_head.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_BRITISH,
	}
	self.customizations.british_default_head.path = "units/vanilla/characters/players/british/head/npc_criminal_uk_default_head"
	self.customizations.british_default_head.path_icon = "ui/temp/customization_temp_df"
	self.customizations.british_default_head.redeem_xp = 0
	self.customizations.british_default_head.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.british_default_upper = {}
	self.customizations.british_default_upper.name = "character_customization_british_default_name_upper"
	self.customizations.british_default_upper.description = "character_customization_british_default_desc_upper"
	self.customizations.british_default_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.british_default_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_BRITISH,
	}
	self.customizations.british_default_upper.path = "units/vanilla/characters/players/british/upper/default_002/player_british_default_002_upper"
	self.customizations.british_default_upper.path_icon = "units/vanilla/characters/players/british/upper/default_002/player_uk_default_002_upper_hud"
	self.customizations.british_default_upper.path_fps_hands = "units/vanilla/characters/players/british/fp/default_002/player_uk_default_002_fp"
	self.customizations.british_default_upper.redeem_xp = 0
	self.customizations.british_default_upper.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.british_default_upper.length = CharacterCustomizationTweakData.PART_LENGTH_SHORT
	self.customizations.british_default_lower = {}
	self.customizations.british_default_lower.name = "character_customization_british_default_name_lower"
	self.customizations.british_default_lower.description = "character_customization_british_default_desc_lower"
	self.customizations.british_default_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.british_default_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_BRITISH,
	}
	self.customizations.british_default_lower.path_long = "units/vanilla/characters/players/british/lower/default_002/player_british_default_002_lower"
	self.customizations.british_default_lower.path_short = "units/vanilla/characters/players/british/lower/default_002/player_british_default_002_lower_short"
	self.customizations.british_default_lower.path_icon = "units/vanilla/characters/players/british/lower/default_002/player_uk_default_002_lower_hud"
	self.customizations.british_default_lower.redeem_xp = 0
	self.customizations.british_default_lower.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.russian_default_head = {}
	self.customizations.russian_default_head.name = "character_customization_russian_default_name_head"
	self.customizations.russian_default_head.description = "character_customization_russian_default_desc_head"
	self.customizations.russian_default_head.part_type = CharacterCustomizationTweakData.PART_TYPE_HEAD
	self.customizations.russian_default_head.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_RUSSIAN,
	}
	self.customizations.russian_default_head.path = "units/vanilla/characters/players/soviet/head/player_soviet_head_002/player_soviet_head_002"
	self.customizations.russian_default_head.path_icon = "ui/temp/customization_temp_df"
	self.customizations.russian_default_head.redeem_xp = 0
	self.customizations.russian_default_head.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.russian_default_upper = {}
	self.customizations.russian_default_upper.name = "character_customization_russian_default_name_upper"
	self.customizations.russian_default_upper.description = "character_customization_russian_default_desc_upper"
	self.customizations.russian_default_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.russian_default_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_RUSSIAN,
	}
	self.customizations.russian_default_upper.path = "units/vanilla/characters/players/soviet/upper/default_002/player_soviet_default_002_upper"
	self.customizations.russian_default_upper.path_icon = "units/vanilla/characters/players/soviet/upper/default_002/player_soviet_default_002_upper_hud"
	self.customizations.russian_default_upper.path_fps_hands = "units/vanilla/characters/players/soviet/fp/default_002/player_soviet_default_002_fp"
	self.customizations.russian_default_upper.redeem_xp = 0
	self.customizations.russian_default_upper.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.russian_default_upper.length = CharacterCustomizationTweakData.PART_LENGTH_LONG
	self.customizations.russian_default_lower = {}
	self.customizations.russian_default_lower.name = "character_customization_russian_default_name_lower"
	self.customizations.russian_default_lower.description = "character_customization_russian_default_desc_lower"
	self.customizations.russian_default_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.russian_default_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_RUSSIAN,
	}
	self.customizations.russian_default_lower.path_long = "units/vanilla/characters/players/soviet/lower/default_002/player_soviet_default_002_lower"
	self.customizations.russian_default_lower.path_short = "units/vanilla/characters/players/soviet/lower/default_002/player_soviet_default_002_lower_short"
	self.customizations.russian_default_lower.path_icon = "units/vanilla/characters/players/soviet/lower/default_002/player_soviet_default_002_lower_hud"
	self.customizations.russian_default_lower.redeem_xp = 0
	self.customizations.russian_default_lower.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.british_casual_001_upper = {}
	self.customizations.british_casual_001_upper.name = "character_customization_british_casual_001_upper_name"
	self.customizations.british_casual_001_upper.description = "character_customization_british_casual_001_upper_desc"
	self.customizations.british_casual_001_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.british_casual_001_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_BRITISH,
	}
	self.customizations.british_casual_001_upper.path = "units/vanilla/characters/players/british/upper/casual_001/player_british_casual_001_upper"
	self.customizations.british_casual_001_upper.path_icon = "units/vanilla/characters/players/british/upper/casual_001/player_uk_casual_001_upper_hud"
	self.customizations.british_casual_001_upper.path_icon_large = "units/vanilla/characters/players/british/upper/casual_001/player_uk_casual_001_upper_large_hud"
	self.customizations.british_casual_001_upper.path_fps_hands = "units/vanilla/characters/players/british/fp/casual_001/player_uk_casual_001_fp"
	self.customizations.british_casual_001_upper.redeem_xp = 0
	self.customizations.british_casual_001_upper.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.customizations.british_casual_001_upper.length = CharacterCustomizationTweakData.PART_LENGTH_SHORT
	self.customizations.british_casual_001_upper.droppable = true
	self.customizations.british_gangbanger_001_upper = {}
	self.customizations.british_gangbanger_001_upper.name = "character_customization_british_gangbanger_001_upper_name"
	self.customizations.british_gangbanger_001_upper.description = "character_customization_british_gangbanger_001_upper_desc"
	self.customizations.british_gangbanger_001_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.british_gangbanger_001_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_BRITISH,
	}
	self.customizations.british_gangbanger_001_upper.path = "units/vanilla/characters/players/british/upper/gangbanger_001/player_british_gangbanger_001_upper"
	self.customizations.british_gangbanger_001_upper.path_icon = "units/vanilla/characters/players/british/upper/gangbanger_001/player_uk_gangbanger_001_upper_hud"
	self.customizations.british_gangbanger_001_upper.path_icon_large = "units/vanilla/characters/players/british/upper/gangbanger_001/player_uk_gangbanger_001_upper_large_hud"
	self.customizations.british_gangbanger_001_upper.path_fps_hands = "units/vanilla/characters/players/british/fp/gangbanger_001/player_uk_gangbanger_001_fp"
	self.customizations.british_gangbanger_001_upper.redeem_xp = 0
	self.customizations.british_gangbanger_001_upper.rarity = LootDropTweakData.RARITY_RARE
	self.customizations.british_gangbanger_001_upper.length = CharacterCustomizationTweakData.PART_LENGTH_SHORT
	self.customizations.british_gangbanger_001_upper.droppable = true
	self.customizations.british_gangbanger_001_lower = {}
	self.customizations.british_gangbanger_001_lower.name = "character_customization_british_gangbanger_001_lower_name"
	self.customizations.british_gangbanger_001_lower.description = "character_customization_british_gangbanger_001_lower_desc"
	self.customizations.british_gangbanger_001_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.british_gangbanger_001_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_BRITISH,
	}
	self.customizations.british_gangbanger_001_lower.path_long = "units/vanilla/characters/players/british/lower/gangbanger_001/player_british_gangbanger_001_lower"
	self.customizations.british_gangbanger_001_lower.path_short = "units/vanilla/characters/players/british/lower/gangbanger_001/player_british_gangbanger_001_lower_short"
	self.customizations.british_gangbanger_001_lower.path_icon = "units/vanilla/characters/players/british/lower/gangbanger_001/player_uk_gangbanger_001_lower_hud"
	self.customizations.british_gangbanger_001_lower.path_icon_large = "units/vanilla/characters/players/british/lower/gangbanger_001/player_uk_gangbanger_001_lower_large_hud"
	self.customizations.british_gangbanger_001_lower.redeem_xp = 0
	self.customizations.british_gangbanger_001_lower.rarity = LootDropTweakData.RARITY_RARE
	self.customizations.british_gangbanger_001_lower.droppable = true
	self.customizations.british_casual_004_lower = {}
	self.customizations.british_casual_004_lower.name = "character_customization_british_casual_004_lower_name"
	self.customizations.british_casual_004_lower.description = "character_customization_british_casual_004_lower_desc"
	self.customizations.british_casual_004_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.british_casual_004_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_BRITISH,
	}
	self.customizations.british_casual_004_lower.path_long = "units/vanilla/characters/players/british/lower/casual_004/player_british_casual_004_lower"
	self.customizations.british_casual_004_lower.path_short = "units/vanilla/characters/players/british/lower/casual_004/player_british_casual_004_lower_short"
	self.customizations.british_casual_004_lower.path_icon = "units/vanilla/characters/players/british/lower/casual_004/player_british_casual_004_lower_hud"
	self.customizations.british_casual_004_lower.path_icon_large = "units/vanilla/characters/players/british/lower/casual_004/player_british_casual_004_lower_large_hud"
	self.customizations.british_casual_004_lower.redeem_xp = 0
	self.customizations.british_casual_004_lower.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.british_casual_004_lower.droppable = true
	self.customizations.american_gangbanger_002_upper = {}
	self.customizations.american_gangbanger_002_upper.name = "character_customization_american_gangbanger_002_upper_name"
	self.customizations.american_gangbanger_002_upper.description = "character_customization_american_gangbanger_002_upper_desc"
	self.customizations.american_gangbanger_002_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.american_gangbanger_002_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_AMERICAN,
	}
	self.customizations.american_gangbanger_002_upper.path = "units/vanilla/characters/players/usa/upper/gangbanger_002/npc_criminal_usa_gangbanger_002_upper"
	self.customizations.american_gangbanger_002_upper.path_icon = "units/vanilla/characters/players/usa/upper/gangbanger_002/player_usa_gangbanger_002_upper_hud"
	self.customizations.american_gangbanger_002_upper.path_icon_large = "units/vanilla/characters/players/usa/upper/gangbanger_002/player_usa_gangbanger_002_upper_large_hud"
	self.customizations.american_gangbanger_002_upper.path_fps_hands = "units/vanilla/characters/players/usa/fp/gangbanger_002/player_usa_gangbanger_002_fp"
	self.customizations.american_gangbanger_002_upper.redeem_xp = 0
	self.customizations.american_gangbanger_002_upper.rarity = LootDropTweakData.RARITY_RARE
	self.customizations.american_gangbanger_002_upper.length = CharacterCustomizationTweakData.PART_LENGTH_SHORT
	self.customizations.american_gangbanger_002_upper.droppable = true
	self.customizations.american_officer_002_upper = {}
	self.customizations.american_officer_002_upper.name = "character_customization_american_officer_002_upper_name"
	self.customizations.american_officer_002_upper.description = "character_customization_american_officer_002_upper_desc"
	self.customizations.american_officer_002_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.american_officer_002_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_AMERICAN,
	}
	self.customizations.american_officer_002_upper.path = "units/vanilla/characters/players/usa/upper/officer_002/player_criminal_usa_officer_002_upper"
	self.customizations.american_officer_002_upper.path_icon = "units/vanilla/characters/players/usa/upper/officer_002/player_usa_officer_002_upper_hud"
	self.customizations.american_officer_002_upper.path_icon_large = "units/vanilla/characters/players/usa/upper/officer_002/player_usa_officer_002_upper_large_hud"
	self.customizations.american_officer_002_upper.path_fps_hands = "units/vanilla/characters/players/usa/fp/officer_002/player_usa_officer_002_fp"
	self.customizations.american_officer_002_upper.redeem_xp = 0
	self.customizations.american_officer_002_upper.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.american_officer_002_upper.length = CharacterCustomizationTweakData.PART_LENGTH_SHORT
	self.customizations.american_officer_002_upper.droppable = true
	self.customizations.american_gangbanger_001_lower = {}
	self.customizations.american_gangbanger_001_lower.name = "character_customization_american_gangbanger_001_lower_name"
	self.customizations.american_gangbanger_001_lower.description = "character_customization_american_gangbanger_001_lower_desc"
	self.customizations.american_gangbanger_001_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.american_gangbanger_001_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_AMERICAN,
	}
	self.customizations.american_gangbanger_001_lower.path_long = "units/vanilla/characters/players/usa/lower/gangbanger_001/npc_criminal_usa_gangbanger_001_lower"
	self.customizations.american_gangbanger_001_lower.path_short = "units/vanilla/characters/players/usa/lower/gangbanger_001/npc_criminal_usa_gangbanger_001_lower_short"
	self.customizations.american_gangbanger_001_lower.path_icon = "units/vanilla/characters/players/usa/lower/gangbanger_001/player_usa_gangbanger_001_lower_hud"
	self.customizations.american_gangbanger_001_lower.path_icon_large = "units/vanilla/characters/players/usa/lower/gangbanger_001/player_usa_gangbanger_001_lower_large_hud"
	self.customizations.american_gangbanger_001_lower.redeem_xp = 0
	self.customizations.american_gangbanger_001_lower.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.customizations.american_gangbanger_001_lower.droppable = true
	self.customizations.american_officer_001_lower = {}
	self.customizations.american_officer_001_lower.name = "character_customization_american_officer_001_lower_name"
	self.customizations.american_officer_001_lower.description = "character_customization_american_officer_001_lower_desc"
	self.customizations.american_officer_001_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.american_officer_001_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_AMERICAN,
	}
	self.customizations.american_officer_001_lower.path_long = "units/vanilla/characters/players/usa/lower/officer_001/player_criminal_usa_officer_001_lower"
	self.customizations.american_officer_001_lower.path_short = "units/vanilla/characters/players/usa/lower/officer_001/player_criminal_usa_officer_001_lower_short"
	self.customizations.american_officer_001_lower.path_icon = "units/vanilla/characters/players/usa/lower/officer_001/player_usa_officer_001_lower_hud"
	self.customizations.american_officer_001_lower.path_icon_large = "units/vanilla/characters/players/usa/lower/officer_001/player_usa_officer_001_lower_large_hud"
	self.customizations.american_officer_001_lower.redeem_xp = 0
	self.customizations.american_officer_001_lower.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.american_officer_001_lower.droppable = true
	self.customizations.german_officer_002_upper = {}
	self.customizations.german_officer_002_upper.name = "character_customization_german_officer_002_upper_name"
	self.customizations.german_officer_002_upper.description = "character_customization_german_officer_002_upper_desc"
	self.customizations.german_officer_002_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.german_officer_002_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_GERMAN,
	}
	self.customizations.german_officer_002_upper.path = "units/vanilla/characters/players/german/upper/officer_002/npc_criminal_ger_officer_002_upper"
	self.customizations.german_officer_002_upper.path_icon = "units/vanilla/characters/players/german/upper/officer_002/player_german_officer_002_upper_hud"
	self.customizations.german_officer_002_upper.path_icon_large = "units/vanilla/characters/players/german/upper/officer_002/player_german_officer_002_upper_large_hud"
	self.customizations.german_officer_002_upper.path_fps_hands = "units/vanilla/characters/players/german/fp/officer_002/player_german_officer_002_fp"
	self.customizations.german_officer_002_upper.redeem_xp = 0
	self.customizations.german_officer_002_upper.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.customizations.german_officer_002_upper.length = CharacterCustomizationTweakData.PART_LENGTH_LONG
	self.customizations.german_officer_002_upper.droppable = true
	self.customizations.german_gangbanger_001_upper = {}
	self.customizations.german_gangbanger_001_upper.name = "character_customization_german_gangbanger_001_upper_name"
	self.customizations.german_gangbanger_001_upper.description = "character_customization_german_gangbanger_001_upper_desc"
	self.customizations.german_gangbanger_001_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.german_gangbanger_001_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_GERMAN,
	}
	self.customizations.german_gangbanger_001_upper.path = "units/vanilla/characters/players/german/upper/gangbanger_001/npc_criminal_ger_gangbanger_001_upper"
	self.customizations.german_gangbanger_001_upper.path_icon = "units/vanilla/characters/players/german/upper/gangbanger_001/player_german_gangbanger_001_upper_hud"
	self.customizations.german_gangbanger_001_upper.path_icon_large = "units/vanilla/characters/players/german/upper/gangbanger_001/player_german_gangbanger_001_upper_large_hud"
	self.customizations.german_gangbanger_001_upper.path_fps_hands = "units/vanilla/characters/players/german/fp/gangbanger_001/player_german_gangbanger_001_fp"
	self.customizations.german_gangbanger_001_upper.redeem_xp = 0
	self.customizations.german_gangbanger_001_upper.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.german_gangbanger_001_upper.length = CharacterCustomizationTweakData.PART_LENGTH_SHORT
	self.customizations.german_gangbanger_001_upper.droppable = true
	self.customizations.german_gangbanger_001_lower = {}
	self.customizations.german_gangbanger_001_lower.name = "character_customization_german_gangbanger_001_lower_name"
	self.customizations.german_gangbanger_001_lower.description = "character_customization_german_gangbanger_001_lower_desc"
	self.customizations.german_gangbanger_001_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.german_gangbanger_001_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_GERMAN,
	}
	self.customizations.german_gangbanger_001_lower.path_long = "units/vanilla/characters/players/german/lower/gangbanger_001/npc_criminal_ger_gangbanger_001_lower"
	self.customizations.german_gangbanger_001_lower.path_short = "units/vanilla/characters/players/german/lower/gangbanger_001/npc_criminal_ger_gangbanger_001_lower_short"
	self.customizations.german_gangbanger_001_lower.path_icon = "units/vanilla/characters/players/german/lower/gangbanger_001/player_german_gangbanger_001_lower_hud"
	self.customizations.german_gangbanger_001_lower.path_icon_large = "units/vanilla/characters/players/german/lower/gangbanger_001/player_german_gangbanger_001_lower_large_hud"
	self.customizations.german_gangbanger_001_lower.redeem_xp = 0
	self.customizations.german_gangbanger_001_lower.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.german_gangbanger_001_lower.droppable = true
	self.customizations.german_officer_002_lower = {}
	self.customizations.german_officer_002_lower.name = "character_customization_german_officer_002_lower_name"
	self.customizations.german_officer_002_lower.description = "character_customization_german_officer_002_lower_desc"
	self.customizations.german_officer_002_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.german_officer_002_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_GERMAN,
	}
	self.customizations.german_officer_002_lower.path_long = "units/vanilla/characters/players/german/lower/officer_002/npc_criminal_ger_officer_002_lower"
	self.customizations.german_officer_002_lower.path_short = "units/vanilla/characters/players/german/lower/officer_002/npc_criminal_ger_officer_002_lower_short"
	self.customizations.german_officer_002_lower.path_icon = "units/vanilla/characters/players/german/lower/officer_002/player_german_officer_002_lower_hud"
	self.customizations.german_officer_002_lower.path_icon_large = "units/vanilla/characters/players/german/lower/officer_002/player_german_officer_002_lower_large_hud"
	self.customizations.german_officer_002_lower.redeem_xp = 0
	self.customizations.german_officer_002_lower.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.customizations.german_officer_002_lower.droppable = true
	self.customizations.russian_commisar_003_upper = {}
	self.customizations.russian_commisar_003_upper.name = "character_customization_russian_commisar_003_upper_name"
	self.customizations.russian_commisar_003_upper.description = "character_customization_russian_commisar_003_upper_desc"
	self.customizations.russian_commisar_003_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.russian_commisar_003_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_RUSSIAN,
	}
	self.customizations.russian_commisar_003_upper.path = "units/vanilla/characters/players/soviet/upper/commisar_003/player_soviet_commisar_003_upper"
	self.customizations.russian_commisar_003_upper.path_icon = "units/vanilla/characters/players/soviet/upper/commisar_003/player_soviet_commissar_003_upper_hud"
	self.customizations.russian_commisar_003_upper.path_icon_large = "units/vanilla/characters/players/soviet/upper/commisar_003/player_soviet_commissar_003_upper_large_hud"
	self.customizations.russian_commisar_003_upper.path_fps_hands = "units/vanilla/characters/players/soviet/fp/commisar_003/player_soviet_commisar_003_fp"
	self.customizations.russian_commisar_003_upper.redeem_xp = 0
	self.customizations.russian_commisar_003_upper.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.russian_commisar_003_upper.length = CharacterCustomizationTweakData.PART_LENGTH_LONG
	self.customizations.russian_commisar_003_upper.droppable = true
	self.customizations.russian_casual_001_upper = {}
	self.customizations.russian_casual_001_upper.name = "character_customization_russian_casual_001_upper_name"
	self.customizations.russian_casual_001_upper.description = "character_customization_russian_casual_001_upper_desc"
	self.customizations.russian_casual_001_upper.part_type = CharacterCustomizationTweakData.PART_TYPE_UPPER
	self.customizations.russian_casual_001_upper.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_RUSSIAN,
	}
	self.customizations.russian_casual_001_upper.path = "units/vanilla/characters/players/soviet/upper/casual_001/npc_criminal_soviet_casual_001_upper"
	self.customizations.russian_casual_001_upper.path_icon = "units/vanilla/characters/players/soviet/upper/casual_001/player_soviet_casual_001_upper_hud"
	self.customizations.russian_casual_001_upper.path_icon_large = "units/vanilla/characters/players/soviet/upper/casual_001/player_soviet_casual_001_upper_large_hud"
	self.customizations.russian_casual_001_upper.path_fps_hands = "units/vanilla/characters/players/soviet/fp/casual_001/player_soviet_casual_001_fp"
	self.customizations.russian_casual_001_upper.redeem_xp = 0
	self.customizations.russian_casual_001_upper.rarity = LootDropTweakData.RARITY_COMMON
	self.customizations.russian_casual_001_upper.length = CharacterCustomizationTweakData.PART_LENGTH_SHORT
	self.customizations.russian_casual_001_upper.droppable = true
	self.customizations.russian_casual_001_lower = {}
	self.customizations.russian_casual_001_lower.name = "character_customization_russian_casual_001_lower_name"
	self.customizations.russian_casual_001_lower.description = "character_customization_russian_casual_001_lower_desc"
	self.customizations.russian_casual_001_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.russian_casual_001_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_RUSSIAN,
	}
	self.customizations.russian_casual_001_lower.path_long = "units/vanilla/characters/players/soviet/lower/casual_001/npc_criminal_soviet_casual_001_lower"
	self.customizations.russian_casual_001_lower.path_short = "units/vanilla/characters/players/soviet/lower/casual_001/npc_criminal_soviet_casual_001_lower_short"
	self.customizations.russian_casual_001_lower.path_icon = "units/vanilla/characters/players/soviet/lower/casual_001/player_soviet_casual_001_lower_hud"
	self.customizations.russian_casual_001_lower.path_icon_large = "units/vanilla/characters/players/soviet/lower/casual_001/player_soviet_casual_001_lower_large_hud"
	self.customizations.russian_casual_001_lower.redeem_xp = 0
	self.customizations.russian_casual_001_lower.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.customizations.russian_casual_001_lower.droppable = true
	self.customizations.russian_commisar_002_lower = {}
	self.customizations.russian_commisar_002_lower.name = "character_customization_russian_commisar_002_lower_name"
	self.customizations.russian_commisar_002_lower.description = "character_customization_russian_commisar_002_lower_desc"
	self.customizations.russian_commisar_002_lower.part_type = CharacterCustomizationTweakData.PART_TYPE_LOWER
	self.customizations.russian_commisar_002_lower.nationalities = {
		CharacterCustomizationTweakData.NATIONALITY_RUSSIAN,
	}
	self.customizations.russian_commisar_002_lower.path_long = "units/vanilla/characters/players/soviet/lower/commisar_002/npc_criminal_soviet_commisar_002_lower"
	self.customizations.russian_commisar_002_lower.path_short = "units/vanilla/characters/players/soviet/lower/commisar_002/npc_criminal_soviet_commisar_002_lower_short"
	self.customizations.russian_commisar_002_lower.path_icon = "units/vanilla/characters/players/soviet/lower/commisar_002/player_soviet_commisar_002_lower_hud"
	self.customizations.russian_commisar_002_lower.path_icon_large = "units/vanilla/characters/players/soviet/lower/commisar_002/player_soviet_commisar_002_lower_large_hud"
	self.customizations.russian_commisar_002_lower.redeem_xp = 0
	self.customizations.russian_commisar_002_lower.rarity = LootDropTweakData.RARITY_RARE
	self.customizations.russian_commisar_002_lower.droppable = true
	self._head_index = {
		"american_default_head",
		"german_default_head",
		"british_default_head",
		"russian_default_head",
	}
	self._upper_index = {
		"american_default_upper",
		"german_default_upper",
		"british_default_upper",
		"russian_default_upper",
		"british_casual_001_upper",
		"british_gangbanger_001_upper",
		"american_gangbanger_002_upper",
		"american_officer_002_upper",
		"german_officer_002_upper",
		"german_gangbanger_001_upper",
		"russian_commisar_003_upper",
		"russian_casual_001_upper",
	}
	self._lower_index = {
		"american_default_lower",
		"german_default_lower",
		"british_default_lower",
		"russian_default_lower",
		"british_gangbanger_001_lower",
		"british_casual_004_lower",
		"american_gangbanger_001_lower",
		"american_officer_001_lower",
		"german_gangbanger_001_lower",
		"german_officer_002_lower",
		"russian_casual_001_lower",
		"russian_commisar_002_lower",
	}
end

function CharacterCustomizationTweakData:get_index_table(part_type)
	local source_table = {}

	if part_type == CharacterCustomizationTweakData.PART_TYPE_HEAD then
		source_table = clone(self._head_index)
	elseif part_type == CharacterCustomizationTweakData.PART_TYPE_UPPER then
		source_table = clone(self._upper_index)
	elseif part_type == CharacterCustomizationTweakData.PART_TYPE_LOWER then
		source_table = clone(self._lower_index)
	end

	return source_table
end

function CharacterCustomizationTweakData:get_all_parts_indexed(part_type, nationality, owned)
	local result = {}
	local source_table = self:get_index_table(part_type)

	for index, part_key in ipairs(source_table) do
		result[index] = {}

		local data_part = clone(self.customizations[part_key])

		data_part.key_name = part_key
		result[index] = data_part
	end

	return result
end

function CharacterCustomizationTweakData:get_all_parts(part_type)
	local result = {}
	local source_table = self:get_index_table(part_type)

	for index, part_key in ipairs(source_table) do
		result[part_key] = {}

		local data_part = clone(self.customizations[part_key])

		data_part.key_name = part_key
		result[part_key] = data_part
	end

	return result
end

function CharacterCustomizationTweakData:get_defaults()
	local result = {}

	result.american_default_head = self.customizations.american_default_head
	result.american_default_upper = self.customizations.american_default_upper
	result.american_default_lower = self.customizations.american_default_lower
	result.british_default_head = self.customizations.british_default_head
	result.british_default_upper = self.customizations.british_default_upper
	result.british_default_lower = self.customizations.british_default_lower
	result.german_default_head = self.customizations.german_default_head
	result.german_default_upper = self.customizations.german_default_upper
	result.german_default_lower = self.customizations.german_default_lower
	result.russian_default_head = self.customizations.russian_default_head
	result.russian_default_upper = self.customizations.russian_default_upper
	result.russian_default_lower = self.customizations.russian_default_lower

	return result
end

function CharacterCustomizationTweakData:get_customizations_by_rarity(rarity)
	local customizations = {}

	for key, customization in pairs(self.customizations) do
		if customization.rarity == rarity and (not customization.dlc or managers.dlc:has_dlc(customization.dlc)) then
			table.insert(customizations, key)
		end
	end

	return customizations
end

function CharacterCustomizationTweakData:get_reward_loot_by_rarity(rarity)
	local customizations = {}

	for key, customization in pairs(self.customizations) do
		if customization.rarity == rarity and customization.droppable and (not customization.dlc or managers.dlc:has_dlc(customization.dlc)) then
			table.insert(customizations, key)
		end
	end

	return customizations
end
