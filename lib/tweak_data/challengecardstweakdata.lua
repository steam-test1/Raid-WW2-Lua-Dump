require("lib/managers/BuffEffectManager")
require("lib/tweak_data/WeaponTweakData")

ChallengeCardsTweakData = ChallengeCardsTweakData or class()
ChallengeCardsTweakData.CARD_TYPE_RAID = "card_type_raid"
ChallengeCardsTweakData.CARD_TYPE_OPERATION = "card_type_operation"
ChallengeCardsTweakData.CARD_TYPE_NONE = "card_type_none"
ChallengeCardsTweakData.CARD_TYPE_BOUNTY = "card_type_bounty"
ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD = "card_category_challenge_card"
ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER = "card_category_booster"
ChallengeCardsTweakData.CARD_CATEGORY_BOUNTY = "card_category_bounty"
ChallengeCardsTweakData.KEY_NAME_FIELD = "key_name"
ChallengeCardsTweakData.FILTER_ALL_ITEMS = "filter_all_items"
ChallengeCardsTweakData.CARDS_TEXTURE_PATH = "ui/challenge_cards"
ChallengeCardsTweakData.TEXTURE_RECT_PATH_COMMON_THUMB = ""
ChallengeCardsTweakData.TEXTURE_RECT_PATH_UNCOMMON_THUMB = ""
ChallengeCardsTweakData.TEXTURE_RECT_PATH_RARE_THUMB = ""
ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE = "positive_effect"
ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE = "negative_effect"
ChallengeCardsTweakData.CARD_SELECTION_TIMER = 60
ChallengeCardsTweakData.PACK_TYPE_REGULAR = 1
ChallengeCardsTweakData.PACK_TYPE_HALLOWEEN = 2
ChallengeCardsTweakData.STACKABLE_AREA = {
	height = 680,
	width = 500,
}

function ChallengeCardsTweakData:init(tweak_data)
	self:_init_cards(tweak_data)
	self:_init_cards_newtype(tweak_data)
	self:_init_cards_generator(tweak_data)
	self:_init_bounty_data(tweak_data)
end

function ChallengeCardsTweakData:_init_cards_newtype(tweak_data)
	self.exchangers = {}
	self.crafting_items = {}
	self.bundles = {}

	local RARITY_SWAP = {}

	RARITY_SWAP[LootDropTweakData.RARITY_NONE] = "unique"
	RARITY_SWAP[LootDropTweakData.RARITY_COMMON] = "common"
	RARITY_SWAP[LootDropTweakData.RARITY_UNCOMMON] = "uncommon"
	RARITY_SWAP[LootDropTweakData.RARITY_RARE] = "rare"
	RARITY_SWAP[LootDropTweakData.RARITY_HALLOWEEN] = "halloween"

	local bonus_xp_tiers = {
		300,
		500,
		750,
		1000,
		1500,
		2000,
		2500,
		3000,
	}
	local bonus_xp_multiplier_tiers = {
		1.25,
		1.5,
		1.75,
		2,
		2.25,
		2.5,
		2.75,
		3,
	}

	local function setup_card(def_id, id, data)
		local card = data or {}
		local table_id = id

		card.name = card.name or "card_" .. id .. "_name_id"
		card.description = card.description or "card_" .. id .. "_desc_id"
		card.def_id = def_id

		local gui_id = "cc_" .. id .. "_hud"

		if DB:has("texture", self.challenge_card_texture_path .. gui_id) then
			card.texture = gui_id
		else
			Application:warn("[ChallengeCardsTweakData] card " .. id .. " was generated without a valid texture, using temporary texture.")

			card.texture = "cc_debug_card_hud"
		end

		if not data.card_category and data.effects then
			for _, effect in ipairs(data.effects) do
				if effect.type and effect.type == ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE then
					card.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD

					break
				end
			end

			if not card.card_category then
				card.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
			end
		end

		if data.rarity then
			table_id = table_id .. "_" .. RARITY_SWAP[data.rarity]
		end

		card.card_type = card.card_type or ChallengeCardsTweakData.CARD_TYPE_RAID
		self.cards[table_id] = card

		table.insert(self.cards_index, table_id)
	end
end

function ChallengeCardsTweakData:_init_cards_generator(tweak_data)
	local all_challenge_card_def_ids = self:get_card_defs_of_type(ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD)
	local all_booster_card_def_ids = self:get_card_defs_of_type(ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER)
	local make_new_generators = true

	if make_new_generators then
		self.bundles.loot_drop_pack = {
			def_id = ChallengeCardsTweakData.PACK_TYPE_REGULAR,
		}
		self.bundles.drop_single_card_halloween = {
			def_id = ChallengeCardsTweakData.PACK_TYPE_HALLOWEEN,
		}
		self.bundles.loot_drop_pack_of_3 = {
			def_id = 10001,
		}
		self.bundles.loot_drop_pack_of_1_halloween = {
			def_id = 10004,
		}
		self.bundles.raid_cards = {
			def_id = 10010,
		}
		self.bundles.raid_cards_halloween = {
			def_id = 10011,
		}
	end
end

function ChallengeCardsTweakData:get_card_defs_of_type(card_category, card_rarity)
	local cards = {}

	for id, card in pairs(self.cards) do
		local valid = true

		if valid and card_category and card.card_category ~= card_category then
			valid = false
		end

		if valid and card_rarity and card.rarity ~= card_rarity then
			valid = false
		end

		if valid then
			table.insert(cards, card.def_id)
		end
	end

	return cards
end

function ChallengeCardsTweakData:_init_cards(tweak_data)
	self.challenge_card_texture_path = "ui/challenge_cards/"
	self.challenge_card_texture_rect = {
		0,
		0,
		512,
		512,
	}

	local function setup_card(id)
		local card = {}

		card.name = "card_" .. id .. "_name_id"
		card.description = "card_" .. id .. "_desc_id"
		card.tradable = true

		local gui_id = "cc_" .. id .. "_hud"

		if DB:has("texture", self.challenge_card_texture_path .. gui_id) then
			card.texture = gui_id
		else
			Application:error("[ChallengeCardsTweakData] card " .. id .. " was generated without a valid texture, using temporary texture.")

			card.texture = "cc_debug_card_hud"
		end

		return card
	end

	self.card_back_challenge_cards = {}
	self.card_back_challenge_cards.texture = self.challenge_card_texture_path .. "cc_back_hud"
	self.card_back_challenge_cards.texture_rect = self.challenge_card_texture_rect
	self.card_back_boosters = {}
	self.card_back_boosters.texture = self.challenge_card_texture_path .. "cc_back_booster_hud"
	self.card_back_boosters.texture_rect = self.challenge_card_texture_rect
	self.card_back_halloween_2017 = {}
	self.card_back_halloween_2017.texture = self.challenge_card_texture_path .. "cc_back_halloween_hud"
	self.card_back_halloween_2017.texture_rect = self.challenge_card_texture_rect
	self.challenge_card_stackable_2_texture_path = "ui/challenge_cards/cc_stackable_2_cards_hud"
	self.challenge_card_stackable_2_texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.challenge_card_stackable_3_texture_path = "ui/challenge_cards/cc_stackable_3_cards_hud"
	self.challenge_card_stackable_3_texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.challenge_card_stackable_booster_2_texture_path = "ui/challenge_cards/cc_stackable_booster_2_cards_hud"
	self.challenge_card_stackable_booster_2_texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.challenge_card_stackable_booster_3_texture_path = "ui/challenge_cards/cc_stackable_booster_3_cards_hud"
	self.challenge_card_stackable_booster_3_texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.not_selected_cardback = {}
	self.not_selected_cardback.texture_path = ChallengeCardsTweakData.CARDS_TEXTURE_PATH
	self.not_selected_cardback.texture_rect = {
		501,
		2,
		497,
		670,
	}
	self.rarity_definition = {}
	self.rarity_definition.loot_rarity_common = {
		color = Color("ececec"),
		texture = ChallengeCardsTweakData.CARDS_TEXTURE_PATH,
		texture_gui = tweak_data.gui.icons.loot_rarity_common,
		texture_gui_dirty = tweak_data.gui.icons.loot_rarity_common_dirty,
		texture_rect = {
			0,
			0,
			512,
			512,
		},
	}
	self.rarity_definition.loot_rarity_uncommon = {
		color = Color("71b35b"),
		texture = ChallengeCardsTweakData.CARDS_TEXTURE_PATH,
		texture_gui = tweak_data.gui.icons.loot_rarity_uncommon,
		texture_gui_dirty = tweak_data.gui.icons.loot_rarity_uncommon_dirty,
		texture_rect = {
			0,
			0,
			512,
			512,
		},
	}
	self.rarity_definition.loot_rarity_rare = {
		color = Color("718c9e"),
		texture = ChallengeCardsTweakData.CARDS_TEXTURE_PATH,
		texture_gui = tweak_data.gui.icons.loot_rarity_rare,
		texture_gui_dirty = tweak_data.gui.icons.loot_rarity_rare_dirty,
		texture_rect = {
			0,
			0,
			512,
			512,
		},
	}
	self.rarity_definition.loot_rarity_halloween = {
		color = Color("d88023"),
		texture = ChallengeCardsTweakData.CARDS_TEXTURE_PATH,
		texture_gui = tweak_data.gui.icons.loot_rarity_halloween,
		texture_gui_dirty = tweak_data.gui.icons.loot_rarity_halloween_dirty,
		texture_rect = {
			0,
			0,
			512,
			512,
		},
	}
	self.rarity_definition.loot_rarity_none = {
		color = nil,
		texture = ChallengeCardsTweakData.CARDS_TEXTURE_PATH,
		texture_gui = tweak_data.gui.icons.loot_rarity_common,
		texture_gui_dirty = tweak_data.gui.icons.loot_rarity_common_dirty,
		texture_rect = {
			0,
			0,
			512,
			512,
		},
	}
	self.type_definition = {}
	self.type_definition.card_type_raid = {
		texture_gui = tweak_data.gui.icons.card_type_raid,
		texture_gui_dirty = tweak_data.gui.icons.card_type_raid_dirty,
	}
	self.type_definition.card_type_operation = {
		texture_gui = tweak_data.gui.icons.card_type_operation,
		texture_gui_dirty = tweak_data.gui.icons.card_type_operation_dirty,
	}
	self.type_definition.card_type_none = {
		texture_gui = tweak_data.gui.icons.card_type_none,
		texture_gui_dirty = tweak_data.gui.icons.card_type_none_dirty,
	}
	self.type_definition.card_type_bounty = {
		texture_gui = tweak_data.gui.icons.card_type_bounty,
		texture_gui_dirty = tweak_data.gui.icons.card_type_bounty_dirty,
	}
	self.card_glow = {}
	self.card_glow.texture = "ui/main_menu/textures/cards_atlas"
	self.card_glow.texture_rect = {
		305,
		662,
		159,
		222,
	}
	self.card_amount_background = {}
	self.card_amount_background.texture = tweak_data.gui.icons.card_counter_bg.texture
	self.card_amount_background.texture_rect = tweak_data.gui.icons.card_counter_bg.texture_rect
	self.steam_inventory = {}
	self.steam_inventory.gameplay = {}
	self.steam_inventory.gameplay.def_id = 1
	self.cards = {}
	self.card_templates = {}
	self.cards.empty = {
		card_type = ChallengeCardsTweakData.CARD_TYPE_NONE,
		description = "DESC",
		effects = {},
		menu_skip = true,
		name = "NAME",
		rarity = LootDropTweakData.RARITY_NONE,
		steam_skip = true,
		texture = "",
	}
	self.card_templates.bounty_card = {
		card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOUNTY,
		card_type = ChallengeCardsTweakData.CARD_TYPE_RAID,
		key_name = "bounty_card",
		locked_suggestion = true,
		menu_skip = true,
		name = "NOT_YET_GENERATED",
		rarity = LootDropTweakData.RARITY_NONE,
		steam_skip = true,
		text_color = tweak_data.gui.colors.raid_black,
		texture = "cc_bounty_rare_hud",
	}
	self.cards.ra_on_the_scrounge = {}
	self.cards.ra_on_the_scrounge.name = "card_ra_on_the_scrounge_name_id"
	self.cards.ra_on_the_scrounge.description = "card_ra_on_the_scrounge_desc_id"
	self.cards.ra_on_the_scrounge.tradable = true
	self.cards.ra_on_the_scrounge.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.15,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_ALL_AMMO_CAPACITY,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0.8,
		},
	}
	self.cards.ra_on_the_scrounge.positive_description = {
		desc_id = "effect_loot_drop_effect_increased",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.ra_on_the_scrounge.negative_description = {
		desc_id = "effect_player_primary_and_secondary_ammo_capacity_lowered",
		desc_params = {
			EFFECT_VALUE_1 = "20%",
		},
	}
	self.cards.ra_on_the_scrounge.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.ra_on_the_scrounge.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_on_the_scrounge.texture = "cc_raid_common_on_the_scrounge_hud"
	self.cards.ra_on_the_scrounge.bonus_xp = 400
	self.cards.ra_on_the_scrounge.def_id = 20001
	self.cards.ra_on_the_scrounge.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_no_backups = {}
	self.cards.ra_no_backups.name = "card_ra_no_backups_name_id"
	self.cards.ra_no_backups.description = "card_ra_no_backups_desc_id"
	self.cards.ra_no_backups.tradable = true
	self.cards.ra_no_backups.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.15,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_SECONDARY_AMMO_CAPACITY,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0,
		},
	}
	self.cards.ra_no_backups.positive_description = {
		desc_id = "effect_player_faster_reload",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.ra_no_backups.negative_description = {
		desc_id = "effect_player_no_secondary_ammo",
	}
	self.cards.ra_no_backups.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.ra_no_backups.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_no_backups.texture = "cc_raid_common_no_backups_hud"
	self.cards.ra_no_backups.bonus_xp = 350
	self.cards.ra_no_backups.def_id = 20002
	self.cards.ra_no_backups.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_this_is_gonna_hurt = {}
	self.cards.ra_this_is_gonna_hurt.name = "card_ra_this_is_gonna_hurt_name_id"
	self.cards.ra_this_is_gonna_hurt.description = "card_ra_this_is_gonna_hurt_desc_id"
	self.cards.ra_this_is_gonna_hurt.tradable = true
	self.cards.ra_this_is_gonna_hurt.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.15,
		},
		{
			name = BuffEffectManager.EFFECT_SET_BLEEDOUT_TIMER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 15,
		},
	}
	self.cards.ra_this_is_gonna_hurt.positive_description = {
		desc_id = "effect_enemies_take_more_damage",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.ra_this_is_gonna_hurt.negative_description = {
		desc_id = "effect_set_bleedout_timer",
		desc_params = {
			EFFECT_VALUE_1 = "15",
		},
	}
	self.cards.ra_this_is_gonna_hurt.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.ra_this_is_gonna_hurt.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_this_is_gonna_hurt.texture = "cc_raid_common_this_is_gonna_hurt_hud"
	self.cards.ra_this_is_gonna_hurt.bonus_xp = 300
	self.cards.ra_this_is_gonna_hurt.def_id = 20003
	self.cards.ra_this_is_gonna_hurt.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_not_in_the_face = {}
	self.cards.ra_not_in_the_face.name = "card_ra_not_in_the_face_name_id"
	self.cards.ra_not_in_the_face.description = "card_ra_not_in_the_face_desc_id"
	self.cards.ra_not_in_the_face.tradable = true
	self.cards.ra_not_in_the_face.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_CRITICAL_HIT_CHANCE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 0.1,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_not_in_the_face.positive_description = {
		desc_id = "effect_critical_hit_chance_increase",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.ra_not_in_the_face.negative_description = {
		desc_id = "effect_headshot_doesnt_do_damage",
	}
	self.cards.ra_not_in_the_face.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.ra_not_in_the_face.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_not_in_the_face.texture = "cc_raid_common_not_in_the_face_hud"
	self.cards.ra_not_in_the_face.bonus_xp = 450
	self.cards.ra_not_in_the_face.def_id = 20004
	self.cards.ra_not_in_the_face.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_loaded_for_bear = {}
	self.cards.ra_loaded_for_bear.name = "card_ra_loaded_for_bear_name_id"
	self.cards.ra_loaded_for_bear.description = "card_ra_loaded_for_bear_desc_id"
	self.cards.ra_loaded_for_bear.tradable = true
	self.cards.ra_loaded_for_bear.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_ALL_AMMO_CAPACITY,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.2,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_MOVEMENT_SPEED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0.85,
		},
	}
	self.cards.ra_loaded_for_bear.positive_description = {
		desc_id = "effect_player_primary_and_secondary_ammo_capacity_increased",
		desc_params = {
			EFFECT_VALUE_1 = "20%",
		},
	}
	self.cards.ra_loaded_for_bear.negative_description = {
		desc_id = "effect_player_movement_speed_reduced",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.ra_loaded_for_bear.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.ra_loaded_for_bear.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_loaded_for_bear.texture = "cc_raid_common_loaded_for_bear_hud"
	self.cards.ra_loaded_for_bear.bonus_xp = 350
	self.cards.ra_loaded_for_bear.def_id = 20005
	self.cards.ra_loaded_for_bear.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_total_carnage = {}
	self.cards.ra_total_carnage.name = "card_ra_total_carnage_name_id"
	self.cards.ra_total_carnage.description = "card_ra_total_carnage_desc_id"
	self.cards.ra_total_carnage.tradable = true
	self.cards.ra_total_carnage.effects = {
		{
			name = BuffEffectManager.EFFECT_AMMO_PICKUPS_REFIL_GRENADES,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_EXPLOSION,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_MELEE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_total_carnage.positive_description = {
		desc_id = "effect_ammo_pickups_refill_grenades",
	}
	self.cards.ra_total_carnage.negative_description = {
		desc_id = "effect_enemies_vulnerable_only_to_explosion_and_melee",
	}
	self.cards.ra_total_carnage.rarity = LootDropTweakData.RARITY_RARE
	self.cards.ra_total_carnage.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_total_carnage.texture = "cc_raid_uncommon_total_carnage_hud"
	self.cards.ra_total_carnage.bonus_xp_multiplier = 1.75
	self.cards.ra_total_carnage.def_id = 20006
	self.cards.ra_total_carnage.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_switch_hitter = {}
	self.cards.ra_switch_hitter.name = "card_ra_switch_hitter_name_id"
	self.cards.ra_switch_hitter.description = "card_ra_switch_hitter_desc_id"
	self.cards.ra_switch_hitter.tradable = true
	self.cards.ra_switch_hitter.effects = {
		{
			name = BuffEffectManager.EFFECT_SHOOTING_SECONDARY_WEAPON_FILLS_PRIMARY_AMMO,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1,
		},
		{
			name = BuffEffectManager.EFFECT_SHOOTING_PRIMARY_WEAPON_CONSUMES_BOTH_AMMOS,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_switch_hitter.positive_description = {
		desc_id = "effect_shooting_secondary_weapon_fills_primary_ammo",
	}
	self.cards.ra_switch_hitter.negative_description = {
		desc_id = "effect_shooting_your_primary_weapon_consumes_both_ammos",
	}
	self.cards.ra_switch_hitter.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_switch_hitter.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_switch_hitter.texture = "cc_raid_uncommon_switch_hitter_hud"
	self.cards.ra_switch_hitter.bonus_xp_multiplier = 1.65
	self.cards.ra_switch_hitter.def_id = 20007
	self.cards.ra_switch_hitter.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_gunslingers = {}
	self.cards.ra_gunslingers.name = "card_ra_gunslingers_name_id"
	self.cards.ra_gunslingers.description = "card_ra_gunslingers_desc_id"
	self.cards.ra_gunslingers.tradable = true
	self.cards.ra_gunslingers.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.15,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_PRIMARY_AMMO_CAPACITY,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0,
		},
	}
	self.cards.ra_gunslingers.positive_description = {
		desc_id = "effect_pistol_damage_increased",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.ra_gunslingers.negative_description = {
		desc_id = "effect_player_no_primary_ammo",
	}
	self.cards.ra_gunslingers.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_gunslingers.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_gunslingers.texture = "cc_raid_uncommon_gunslingers_hud"
	self.cards.ra_gunslingers.bonus_xp_multiplier = 1.65
	self.cards.ra_gunslingers.def_id = 20008
	self.cards.ra_gunslingers.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_fresh_troops = {}
	self.cards.ra_fresh_troops.name = "card_ra_fresh_troops_name_id"
	self.cards.ra_fresh_troops.description = "card_ra_fresh_troops_desc_id"
	self.cards.ra_fresh_troops.tradable = true
	self.cards.ra_fresh_troops.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_CHANCE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.25,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 1.5,
		},
	}
	self.cards.ra_fresh_troops.positive_description = {
		desc_id = "effect_loot_drop_chance_increased",
		desc_params = {
			EFFECT_VALUE_1 = "25%",
		},
	}
	self.cards.ra_fresh_troops.negative_description = {
		desc_id = "effect_enemies_health_increased",
		desc_params = {
			EFFECT_VALUE_1 = "50%",
		},
	}
	self.cards.ra_fresh_troops.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_fresh_troops.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_fresh_troops.texture = "cc_raid_uncommon_fresh_troops_hud"
	self.cards.ra_fresh_troops.bonus_xp_multiplier = 2.25
	self.cards.ra_fresh_troops.def_id = 20009
	self.cards.ra_fresh_troops.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_dont_you_die_on_me = {}
	self.cards.ra_dont_you_die_on_me.name = "card_ra_dont_you_die_on_me_name_id"
	self.cards.ra_dont_you_die_on_me.description = "card_ra_dont_you_die_on_me_desc_id"
	self.cards.ra_dont_you_die_on_me.tradable = true
	self.cards.ra_dont_you_die_on_me.effects = {
		{
			name = BuffEffectManager.EFFECT_MODIFY_BLEEDOUT_TIMER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 10,
		},
		{
			fail_message = BuffEffectManager.FAIL_EFFECT_MESSAGE_PLAYER_DIED,
			name = BuffEffectManager.EFFECT_PLAYER_DIED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_dont_you_die_on_me.positive_description = {
		desc_id = "effect_bleedout_timer_increased",
		desc_params = {
			EFFECT_VALUE_1 = "10",
		},
	}
	self.cards.ra_dont_you_die_on_me.negative_description = {
		desc_id = "effect_players_cannot_die_during_raid",
	}
	self.cards.ra_dont_you_die_on_me.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_dont_you_die_on_me.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_dont_you_die_on_me.texture = "cc_raid_uncommon_dont_you_die_on_me_hud"
	self.cards.ra_dont_you_die_on_me.bonus_xp_multiplier = 1.8
	self.cards.ra_dont_you_die_on_me.def_id = 20010
	self.cards.ra_dont_you_die_on_me.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_no_second_chances = {}
	self.cards.ra_no_second_chances.name = "card_ra_no_second_chances_name_id"
	self.cards.ra_no_second_chances.description = "card_ra_no_second_chances_desc_id"
	self.cards.ra_no_second_chances.tradable = true
	self.cards.ra_no_second_chances.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
		{
			fail_message = BuffEffectManager.FAIL_EFFECT_MESSAGE_PLAYER_WENT_TO_BLEEDOUT,
			name = BuffEffectManager.EFFECT_PLAYER_BLEEDOUT,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_no_second_chances.positive_description = {
		desc_id = "effect_player_health_increased",
		desc_params = {
			EFFECT_VALUE_1 = "10",
		},
	}
	self.cards.ra_no_second_chances.negative_description = {
		desc_id = "effect_players_cannot_bleedout_during_raid",
	}
	self.cards.ra_no_second_chances.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_no_second_chances.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_no_second_chances.texture = "cc_raid_rare_no_second_chances_hud"
	self.cards.ra_no_second_chances.bonus_xp_multiplier = 2.2
	self.cards.ra_no_second_chances.def_id = 20011
	self.cards.ra_no_second_chances.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_a_perfect_score = {}
	self.cards.ra_a_perfect_score.name = "card_ra_a_perfect_score_name_id"
	self.cards.ra_a_perfect_score.description = "card_ra_a_perfect_score_desc_id"
	self.cards.ra_a_perfect_score.tradable = true
	self.cards.ra_a_perfect_score.effects = {
		{
			name = BuffEffectManager.EFFECT_FORCED_CRATE_TIER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 2,
		},
		{
			fail_message = BuffEffectManager.FAIL_EFFECT_MESSAGE_PLAYER_FAILED_INTERACTION_MINI_GAME,
			name = BuffEffectManager.EFFECT_PLAYER_FAILED_INTERACTION_MINI_GAME,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_a_perfect_score.positive_description = {
		desc_id = "effect_all_chests_are_locked",
	}
	self.cards.ra_a_perfect_score.negative_description = {
		desc_id = "effect_players_cant_fail_minigame",
	}
	self.cards.ra_a_perfect_score.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_a_perfect_score.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_a_perfect_score.texture = "cc_raid_rare_a_perfect_score_hud"
	self.cards.ra_a_perfect_score.bonus_xp_multiplier = 2.2
	self.cards.ra_a_perfect_score.def_id = 20012
	self.cards.ra_a_perfect_score.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_helmet_shortage = {}
	self.cards.ra_helmet_shortage.name = "card_ra_helmet_shortage_name_id"
	self.cards.ra_helmet_shortage.description = "card_ra_helmet_shortage_desc_id"
	self.cards.ra_helmet_shortage.tradable = true
	self.cards.ra_helmet_shortage.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 3,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0.5,
		},
	}
	self.cards.ra_helmet_shortage.positive_description = {
		desc_id = "effect_headshots_damage_increased",
		desc_params = {
			EFFECT_VALUE_1 = "300%",
		},
	}
	self.cards.ra_helmet_shortage.negative_description = {
		desc_id = "effect_player_health_reduced",
		desc_params = {
			EFFECT_VALUE_1 = "50%",
		},
	}
	self.cards.ra_helmet_shortage.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_helmet_shortage.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_helmet_shortage.texture = "cc_raid_rare_helmet_shortage_hud"
	self.cards.ra_helmet_shortage.bonus_xp_multiplier = 2.5
	self.cards.ra_helmet_shortage.def_id = 20013
	self.cards.ra_helmet_shortage.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_hemorrhaging = {}
	self.cards.ra_hemorrhaging.name = "card_ra_hemorrhaging_name_id"
	self.cards.ra_hemorrhaging.description = "card_ra_hemorrhaging_desc_id"
	self.cards.ra_hemorrhaging.tradable = true
	self.cards.ra_hemorrhaging.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_MELEE_KILL_REGENERATES_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 0.1,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEALTH_REGEN,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = -0.00333,
		},
	}
	self.cards.ra_hemorrhaging.positive_description = {
		desc_id = "effect_melee_kills_regenerate_health",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.ra_hemorrhaging.negative_description = {
		desc_id = "effect_health_drain_per_minute",
		desc_params = {
			EFFECT_VALUE_1 = "20%",
		},
	}
	self.cards.ra_hemorrhaging.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_hemorrhaging.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_hemorrhaging.texture = "cc_raid_rare_hemorrhaging_hud"
	self.cards.ra_hemorrhaging.bonus_xp_multiplier = 2.5
	self.cards.ra_hemorrhaging.def_id = 20014
	self.cards.ra_hemorrhaging.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_crab_people = {}
	self.cards.ra_crab_people.name = "card_ra_crab_people_name_id"
	self.cards.ra_crab_people.description = "card_ra_crab_people_desc_id"
	self.cards.ra_crab_people.tradable = true
	self.cards.ra_crab_people.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_MOVEMENT_SPEED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.3,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_CAN_MOVE_ONLY_BACK_AND_SIDE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_crab_people.positive_description = {
		desc_id = "effect_player_movement_speed_increased",
	}
	self.cards.ra_crab_people.negative_description = {
		desc_id = "effect_player_can_only_walk_backwards_or_sideways",
	}
	self.cards.ra_crab_people.rarity = LootDropTweakData.RARITY_RARE
	self.cards.ra_crab_people.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_crab_people.texture = "cc_raid_rare_crab_people_hud"
	self.cards.ra_crab_people.bonus_xp_multiplier = 3
	self.cards.ra_crab_people.def_id = 20015
	self.cards.ra_crab_people.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_slasher_movie = {}
	self.cards.ra_slasher_movie.name = "card_ra_slasher_movie_name_id"
	self.cards.ra_slasher_movie.description = "card_ra_slasher_movie_desc_id"
	self.cards.ra_slasher_movie.tradable = true
	self.cards.ra_slasher_movie.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEALTH_REGEN,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 0.01666,
		},
		{
			name = BuffEffectManager.EFFECT_MELEE_DAMAGE_INCREASE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 20,
		},
		{
			name = BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
		{
			name = BuffEffectManager.EFFECT_WARCRIES_DISABLED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_slasher_movie.positive_description = {
		desc_id = "effect_melee_damage_increased_health_regen",
		desc_params = {
			EFFECT_VALUE_1 = "100%",
		},
	}
	self.cards.ra_slasher_movie.negative_description = {
		desc_id = "effect_melee_avail_warcries_disabled",
	}
	self.cards.ra_slasher_movie.rarity = LootDropTweakData.RARITY_HALLOWEEN
	self.cards.ra_slasher_movie.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_slasher_movie.texture = "cc_special_raid_slasher_movie_hud"
	self.cards.ra_slasher_movie.bonus_xp_multiplier = 2.75
	self.cards.ra_slasher_movie.def_id = 20016
	self.cards.ra_slasher_movie.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_slasher_movie.card_back = "card_back_halloween_2017"
	self.cards.ra_slasher_movie.title_in_texture = true
	self.cards.ra_slasher_movie.loot_drop_group = LootDropTweakData.REWARD_HALLOWEEN_2017
	self.cards.ra_slasher_movie.selected_sound = "halloween_challenge_card_chosen"
	self.cards.ra_pumpkin_pie = {}
	self.cards.ra_pumpkin_pie.name = "card_ra_pumpkin_pie_name_id"
	self.cards.ra_pumpkin_pie.description = "card_ra_pumpkin_pie_desc_id"
	self.cards.ra_pumpkin_pie.tradable = true
	self.cards.ra_pumpkin_pie.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 3,
		},
		{
			name = BuffEffectManager.EFFECT_PUMKIN_HEADS,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = true,
		},
		{
			name = BuffEffectManager.EFFECT_ATTACK_ONLY_IN_AIR,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_pumpkin_pie.positive_description = {
		desc_id = "effect_headshots_damage_increased",
		desc_params = {
			EFFECT_VALUE_1 = "300%",
		},
	}
	self.cards.ra_pumpkin_pie.negative_description = {
		desc_id = "effect_only_attack_in_air",
	}
	self.cards.ra_pumpkin_pie.rarity = LootDropTweakData.RARITY_HALLOWEEN
	self.cards.ra_pumpkin_pie.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_pumpkin_pie.texture = "cc_special_raid_pumpkin_pie_hud"
	self.cards.ra_pumpkin_pie.bonus_xp_multiplier = 2.5
	self.cards.ra_pumpkin_pie.def_id = 20017
	self.cards.ra_pumpkin_pie.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_pumpkin_pie.card_back = "card_back_halloween_2017"
	self.cards.ra_pumpkin_pie.title_in_texture = true
	self.cards.ra_pumpkin_pie.loot_drop_group = LootDropTweakData.REWARD_HALLOWEEN_2017
	self.cards.ra_pumpkin_pie.selected_sound = "halloween_challenge_card_chosen"
	self.cards.ra_season_of_resurrection = {}
	self.cards.ra_season_of_resurrection.name = "card_ra_season_of_resurrection_name_id"
	self.cards.ra_season_of_resurrection.description = "card_ra_season_of_resurrection_desc_id"
	self.cards.ra_season_of_resurrection.tradable = true
	self.cards.ra_season_of_resurrection.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_LOW_HEALTH_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 4,
		},
		{
			name = BuffEffectManager.EFFECT_NO_BLEEDOUT_PUMPIKIN_REVIVE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_season_of_resurrection.positive_description = {
		desc_id = "effect_player_low_health_damage",
	}
	self.cards.ra_season_of_resurrection.negative_description = {
		desc_id = "effect_no_bleedout_pumpkin_revive",
	}
	self.cards.ra_season_of_resurrection.rarity = LootDropTweakData.RARITY_HALLOWEEN
	self.cards.ra_season_of_resurrection.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_season_of_resurrection.texture = "cc_special_raid_season_of_resurrection_hud"
	self.cards.ra_season_of_resurrection.bonus_xp_multiplier = 2.5
	self.cards.ra_season_of_resurrection.def_id = 20018
	self.cards.ra_season_of_resurrection.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_season_of_resurrection.card_back = "card_back_halloween_2017"
	self.cards.ra_season_of_resurrection.title_in_texture = true
	self.cards.ra_season_of_resurrection.loot_drop_group = LootDropTweakData.REWARD_HALLOWEEN_2017
	self.cards.ra_season_of_resurrection.selected_sound = "halloween_challenge_card_chosen"
	self.cards.op_limited_supplies = {}
	self.cards.op_limited_supplies.name = "card_op_limited_supplies_name_id"
	self.cards.op_limited_supplies.description = "card_op_limited_supplies_desc_id"
	self.cards.op_limited_supplies.tradable = true
	self.cards.op_limited_supplies.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.15,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_ALL_AMMO_CAPACITY,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0.8,
		},
	}
	self.cards.op_limited_supplies.positive_description = {
		desc_id = "effect_loot_drop_effect_increased",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.op_limited_supplies.negative_description = {
		desc_id = "effect_player_primary_and_secondary_ammo_capacity_lowered",
		desc_params = {
			EFFECT_VALUE_1 = "20%",
		},
	}
	self.cards.op_limited_supplies.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.op_limited_supplies.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_limited_supplies.texture = "cc_operation_common_limited_supplies_hud"
	self.cards.op_limited_supplies.bonus_xp = 1000
	self.cards.op_limited_supplies.def_id = 30001
	self.cards.op_limited_supplies.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_take_the_cannoli = {}
	self.cards.op_take_the_cannoli.name = "card_op_take_the_cannoli_name_id"
	self.cards.op_take_the_cannoli.description = "card_op_take_the_cannoli_desc_id"
	self.cards.op_take_the_cannoli.tradable = true
	self.cards.op_take_the_cannoli.effects = {
		{
			name = BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = true,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_CHANCE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0.85,
		},
	}
	self.cards.op_take_the_cannoli.positive_description = {
		desc_id = "effect_no_movement_penalty_for_carrying_heavy_objects",
	}
	self.cards.op_take_the_cannoli.negative_description = {
		desc_id = "effect_loot_drop_chance_decreased",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.op_take_the_cannoli.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.op_take_the_cannoli.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_take_the_cannoli.texture = "cc_operation_common_take_the_canonoli_hud"
	self.cards.op_take_the_cannoli.bonus_xp = 1500
	self.cards.op_take_the_cannoli.def_id = 30002
	self.cards.op_take_the_cannoli.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_everyones_a_tough_guy = {}
	self.cards.op_everyones_a_tough_guy.name = "card_op_everyones_a_tough_guy_name_id"
	self.cards.op_everyones_a_tough_guy.description = "card_op_everyones_a_tough_guy_desc_id"
	self.cards.op_everyones_a_tough_guy.tradable = true
	self.cards.op_everyones_a_tough_guy.effects = {
		{
			name = BuffEffectManager.EFFECT_MODIFY_BLEEDOUT_TIMER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 5,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 1.1,
		},
	}
	self.cards.op_everyones_a_tough_guy.positive_description = {
		desc_id = "effect_bleedout_timer_increased",
		desc_params = {
			EFFECT_VALUE_1 = "5",
		},
	}
	self.cards.op_everyones_a_tough_guy.negative_description = {
		desc_id = "effect_enemies_health_increased",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.op_everyones_a_tough_guy.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.op_everyones_a_tough_guy.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_everyones_a_tough_guy.texture = "cc_operation_common_everyones_a_tough_guy_hud"
	self.cards.op_everyones_a_tough_guy.bonus_xp = 1400
	self.cards.op_everyones_a_tough_guy.def_id = 30003
	self.cards.op_everyones_a_tough_guy.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_nichtsplosions = {}
	self.cards.op_nichtsplosions.name = "card_op_nichtsplosions_name_id"
	self.cards.op_nichtsplosions.description = "card_op_nichtsplosions_desc_id"
	self.cards.op_nichtsplosions.tradable = true
	self.cards.op_nichtsplosions.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.15,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMIES_IMPERVIOUS_TO_EXPLOSIVE_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.op_nichtsplosions.positive_description = {
		desc_id = "effect_player_faster_reload",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.op_nichtsplosions.negative_description = {
		desc_id = "effect_enemies_impervious_to_explosive_damage",
	}
	self.cards.op_nichtsplosions.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.op_nichtsplosions.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_nichtsplosions.texture = "cc_operation_common_nichtsplosions_hud"
	self.cards.op_nichtsplosions.bonus_xp = 1200
	self.cards.op_nichtsplosions.def_id = 30004
	self.cards.op_nichtsplosions.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_war_weary = {}
	self.cards.op_war_weary.name = "card_op_war_weary_name_id"
	self.cards.op_war_weary.description = "card_op_war_weary_desc_id"
	self.cards.op_war_weary.tradable = true
	self.cards.op_war_weary.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0.75,
		},
	}
	self.cards.op_war_weary.positive_description = {
		desc_id = "effect_enemies_take_more_damage",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.op_war_weary.negative_description = {
		desc_id = "effect_loot_drop_effect_decreased",
		desc_params = {
			EFFECT_VALUE_1 = "25%",
		},
	}
	self.cards.op_war_weary.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.op_war_weary.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_war_weary.texture = "cc_operation_common_war_weary_hud"
	self.cards.op_war_weary.bonus_xp = 800
	self.cards.op_war_weary.def_id = 30005
	self.cards.op_war_weary.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_special_for_a_reason = {}
	self.cards.op_special_for_a_reason.name = "card_op_special_for_a_reason_name_id"
	self.cards.op_special_for_a_reason.description = "card_op_special_for_a_reason_desc_id"
	self.cards.op_special_for_a_reason.tradable = true
	self.cards.op_special_for_a_reason.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_MOVEMENT_SPEED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_DOES_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 1.5,
		},
	}
	self.cards.op_special_for_a_reason.positive_description = {
		desc_id = "effect_player_movement_speed_increased",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.op_special_for_a_reason.negative_description = {
		desc_id = "effect_special_enemies_deal_increased_damage",
		desc_params = {
			EFFECT_VALUE_1 = "50%",
		},
	}
	self.cards.op_special_for_a_reason.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_special_for_a_reason.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_special_for_a_reason.texture = "cc_operation_uncommon_special_for_a_reason_hud"
	self.cards.op_special_for_a_reason.bonus_xp_multiplier = 1.3
	self.cards.op_special_for_a_reason.def_id = 30006
	self.cards.op_special_for_a_reason.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_dont_blink = {}
	self.cards.op_dont_blink.name = "card_op_dont_blink_name_id"
	self.cards.op_dont_blink.description = "card_op_dont_blink_desc_id"
	self.cards.op_dont_blink.tradable = true
	self.cards.op_dont_blink.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_CHANCE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_DESPAWN_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 5,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_DESPAWN_AMMO,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 5,
		},
	}
	self.cards.op_dont_blink.positive_description = {
		desc_id = "effect_loot_drop_chance_increased",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.op_dont_blink.negative_description = {
		desc_id = "effect_loot_drop_pickups_desappear",
		desc_params = {
			EFFECT_VALUE_1 = "5",
		},
	}
	self.cards.op_dont_blink.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_dont_blink.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_dont_blink.texture = "cc_operation_uncommon_dont_blink_hud"
	self.cards.op_dont_blink.bonus_xp_multiplier = 1.4
	self.cards.op_dont_blink.def_id = 30007
	self.cards.op_dont_blink.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_bad_coffee = {}
	self.cards.op_bad_coffee.name = "card_op_bad_coffee_name_id"
	self.cards.op_bad_coffee.description = "card_op_bad_coffee_desc_id"
	self.cards.op_bad_coffee.tradable = true
	self.cards.op_bad_coffee.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
		{
			name = BuffEffectManager.EFFECT_SET_BLEEDOUT_TIMER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 15,
		},
	}
	self.cards.op_bad_coffee.positive_description = {
		desc_id = "effect_player_faster_reload",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.op_bad_coffee.negative_description = {
		desc_id = "effect_set_bleedout_timer",
		desc_params = {
			EFFECT_VALUE_1 = "15",
		},
	}
	self.cards.op_bad_coffee.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_bad_coffee.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_bad_coffee.texture = "cc_operation_uncommon_bad_coffee_hud"
	self.cards.op_bad_coffee.bonus_xp_multiplier = 1.6
	self.cards.op_bad_coffee.def_id = 30008
	self.cards.op_bad_coffee.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_playing_for_keeps = {}
	self.cards.op_playing_for_keeps.name = "card_op_playing_for_keeps_name_id"
	self.cards.op_playing_for_keeps.description = "card_op_playing_for_keeps_desc_id"
	self.cards.op_playing_for_keeps.tradable = true
	self.cards.op_playing_for_keeps.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0.75,
		},
	}
	self.cards.op_playing_for_keeps.positive_description = {
		desc_id = "effect_enemies_take_more_damage",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.op_playing_for_keeps.negative_description = {
		desc_id = "effect_player_health_reduced",
		desc_params = {
			EFFECT_VALUE_1 = "25",
		},
	}
	self.cards.op_playing_for_keeps.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_playing_for_keeps.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_playing_for_keeps.texture = "cc_operation_uncommon_playing_for_keeps_hud"
	self.cards.op_playing_for_keeps.bonus_xp_multiplier = 1.5
	self.cards.op_playing_for_keeps.def_id = 30009
	self.cards.op_playing_for_keeps.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_silent_shout = {}
	self.cards.op_silent_shout.name = "card_op_silent_shout_name_id"
	self.cards.op_silent_shout.description = "card_op_silent_shout_desc_id"
	self.cards.op_silent_shout.tradable = true
	self.cards.op_silent_shout.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_MELEE_KILL_REGENERATES_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 0.1,
		},
		{
			fail_message = BuffEffectManager.FAIL_EFFECT_MESSAGE_PLAYER_USED_WARCRY,
			name = BuffEffectManager.EFFECT_PLAYERS_CANT_USE_WARCRIES,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.op_silent_shout.positive_description = {
		desc_id = "effect_melee_kills_regenerate_health",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.op_silent_shout.negative_description = {
		desc_id = "effect_players_cant_use_warcry",
	}
	self.cards.op_silent_shout.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_silent_shout.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_silent_shout.texture = "cc_operation_uncommon_silent_shout_hud"
	self.cards.op_silent_shout.bonus_xp_multiplier = 1.55
	self.cards.op_silent_shout.def_id = 30010
	self.cards.op_silent_shout.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_blow_me = {}
	self.cards.op_blow_me.name = "card_op_blow_me_name_id"
	self.cards.op_blow_me.description = "card_op_blow_me_desc_id"
	self.cards.op_blow_me.tradable = true
	self.cards.op_blow_me.effects = {
		{
			name = BuffEffectManager.EFFECT_GRENADE_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 2,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_ALL_AMMO_CAPACITY,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 0.5,
		},
	}
	self.cards.op_blow_me.positive_description = {
		desc_id = "effect_player_grenade_damage_increased",
		desc_params = {
			EFFECT_VALUE_1 = "100%",
		},
	}
	self.cards.op_blow_me.negative_description = {
		desc_id = "effect_player_primary_and_secondary_ammo_capacity_lowered",
		desc_params = {
			EFFECT_VALUE_1 = "50%",
		},
	}
	self.cards.op_blow_me.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_blow_me.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_blow_me.texture = "cc_operation_rare_blow_me_hud"
	self.cards.op_blow_me.bonus_xp_multiplier = 1.75
	self.cards.op_blow_me.def_id = 30011
	self.cards.op_blow_me.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_you_only_live_once = {}
	self.cards.op_you_only_live_once.name = "card_op_you_only_live_once_name_id"
	self.cards.op_you_only_live_once.description = "card_op_you_only_live_once_desc_id"
	self.cards.op_you_only_live_once.tradable = true
	self.cards.op_you_only_live_once.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 0.05,
		},
		{
			fail_message = BuffEffectManager.FAIL_EFFECT_MESSAGE_PLAYER_DIED,
			name = BuffEffectManager.EFFECT_PLAYER_DIED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.op_you_only_live_once.positive_description = {
		desc_id = "effect_player_health_regenerates_on_every_kill",
		desc_params = {
			EFFECT_VALUE_1 = "5%",
		},
	}
	self.cards.op_you_only_live_once.negative_description = {
		desc_id = "effect_players_cannot_die_during_operation",
	}
	self.cards.op_you_only_live_once.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_you_only_live_once.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_you_only_live_once.texture = "cc_operation_rare_you_only_live_once_hud"
	self.cards.op_you_only_live_once.bonus_xp_multiplier = 2
	self.cards.op_you_only_live_once.def_id = 30012
	self.cards.op_you_only_live_once.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_short_controlled_bursts = {}
	self.cards.op_short_controlled_bursts.name = "card_op_short_controlled_bursts_name_id"
	self.cards.op_short_controlled_bursts.description = "card_op_short_controlled_bursts_desc_id"
	self.cards.op_short_controlled_bursts.tradable = true
	self.cards.op_short_controlled_bursts.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_CRITICAL_HIT_CHANCE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 0.07,
		},
		{
			fail_message = BuffEffectManager.FAIL_EFFECT_MESSAGE_PLAYER_EMPTIED_A_CLIP,
			name = BuffEffectManager.EFFECT_PLAYERS_CANT_EMPTY_CLIPS,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.op_short_controlled_bursts.positive_description = {
		desc_id = "effect_critical_hit_chance_increase",
		desc_params = {
			EFFECT_VALUE_1 = "7%",
		},
	}
	self.cards.op_short_controlled_bursts.negative_description = {
		desc_id = "effect_players_cant_empty_any_clips",
	}
	self.cards.op_short_controlled_bursts.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_short_controlled_bursts.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_short_controlled_bursts.texture = "cc_operation_rare_short_controlled_bursts_hud"
	self.cards.op_short_controlled_bursts.bonus_xp_multiplier = 2
	self.cards.op_short_controlled_bursts.def_id = 30013
	self.cards.op_short_controlled_bursts.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_elite_opponents = {}
	self.cards.op_elite_opponents.name = "card_op_elite_opponents_name_id"
	self.cards.op_elite_opponents.description = "card_op_elite_opponents_desc_id"
	self.cards.op_elite_opponents.tradable = true
	self.cards.op_elite_opponents.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_CHANCE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.25,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 1.5,
		},
	}
	self.cards.op_elite_opponents.positive_description = {
		desc_id = "effect_loot_drop_chance_increased",
		desc_params = {
			EFFECT_VALUE_1 = "25%",
		},
	}
	self.cards.op_elite_opponents.negative_description = {
		desc_id = "effect_enemies_health_increased",
		desc_params = {
			EFFECT_VALUE_1 = "50%",
		},
	}
	self.cards.op_elite_opponents.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_elite_opponents.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_elite_opponents.texture = "cc_operation_rare_elite_opponents_hud"
	self.cards.op_elite_opponents.bonus_xp_multiplier = 2
	self.cards.op_elite_opponents.def_id = 30014
	self.cards.op_elite_opponents.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.op_and_headaches_for_all = {}
	self.cards.op_and_headaches_for_all.name = "card_op_and_headaches_for_all_name_id"
	self.cards.op_and_headaches_for_all.description = "card_op_and_headaches_for_all_desc_id"
	self.cards.op_and_headaches_for_all.tradable = true
	self.cards.op_and_headaches_for_all.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.5,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.op_and_headaches_for_all.positive_description = {
		desc_id = "effect_headshots_damage_increased",
		desc_params = {
			EFFECT_VALUE_1 = "50%",
		},
	}
	self.cards.op_and_headaches_for_all.negative_description = {
		desc_id = "effect_enemies_vulnerable_only_to_headshots",
	}
	self.cards.op_and_headaches_for_all.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_and_headaches_for_all.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_and_headaches_for_all.texture = "cc_operation_rare_headaches_for_all_hud"
	self.cards.op_and_headaches_for_all.bonus_xp_multiplier = 2.5
	self.cards.op_and_headaches_for_all.def_id = 30015
	self.cards.op_and_headaches_for_all.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_b_walk_it_off = {}
	self.cards.ra_b_walk_it_off.name = "challenge_card_ra_b_walk_it_off_name_id"
	self.cards.ra_b_walk_it_off.description = "challenge_card_ra_b_walk_it_off_desc_id"
	self.cards.ra_b_walk_it_off.tradable = true
	self.cards.ra_b_walk_it_off.effects = {
		{
			name = BuffEffectManager.EFFECT_MODIFY_BLEEDOUT_TIMER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 5,
		},
	}
	self.cards.ra_b_walk_it_off.positive_description = {
		desc_id = "effect_bleedout_timer_increased",
		desc_params = {
			EFFECT_VALUE_1 = "5",
		},
	}
	self.cards.ra_b_walk_it_off.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.ra_b_walk_it_off.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_b_walk_it_off.texture = "cc_booster_raid_common_walk_it_of_hud"
	self.cards.ra_b_walk_it_off.def_id = 40002
	self.cards.ra_b_walk_it_off.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
	self.cards.ra_b_in_fine_feather = {}
	self.cards.ra_b_in_fine_feather.name = "challenge_card_ra_b_in_fine_feather_name_id"
	self.cards.ra_b_in_fine_feather.description = "challenge_card_ra_b_in_fine_feather_desc_id"
	self.cards.ra_b_in_fine_feather.tradable = true
	self.cards.ra_b_in_fine_feather.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
	}
	self.cards.ra_b_in_fine_feather.positive_description = {
		desc_id = "effect_player_health_increased",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.ra_b_in_fine_feather.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_b_in_fine_feather.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_b_in_fine_feather.texture = "cc_booster_raid_uncommon_in_fine_feather_hud"
	self.cards.ra_b_in_fine_feather.def_id = 40004
	self.cards.ra_b_in_fine_feather.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
	self.cards.ra_b_precision_fire = {}
	self.cards.ra_b_precision_fire.name = "challenge_card_ra_b_precision_fire_name_id"
	self.cards.ra_b_precision_fire.description = "challenge_card_ra_b_precision_fire_desc_id"
	self.cards.ra_b_precision_fire.tradable = true
	self.cards.ra_b_precision_fire.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
	}
	self.cards.ra_b_precision_fire.positive_description = {
		desc_id = "effect_enemies_take_increased_damage",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.ra_b_precision_fire.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.ra_b_precision_fire.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_b_precision_fire.texture = "cc_booster_raid_rare_precision_shooting_hud"
	self.cards.ra_b_precision_fire.def_id = 40005
	self.cards.ra_b_precision_fire.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
	self.cards.op_b_recycle_for_victory = {}
	self.cards.op_b_recycle_for_victory.name = "challenge_card_op_b_recycle_for_victory_name_id"
	self.cards.op_b_recycle_for_victory.description = "challenge_card_op_b_recycle_for_victory_desc_id"
	self.cards.op_b_recycle_for_victory.tradable = true
	self.cards.op_b_recycle_for_victory.effects = {
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
	}
	self.cards.op_b_recycle_for_victory.positive_description = {
		desc_id = "effect_loot_drop_effect_increased",
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.op_b_recycle_for_victory.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.op_b_recycle_for_victory.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_b_recycle_for_victory.texture = "cc_booster_operation_common_recycle_for_victory_hud"
	self.cards.op_b_recycle_for_victory.def_id = 50001
	self.cards.op_b_recycle_for_victory.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
	self.cards.op_b_will_not_go_quietly = {}
	self.cards.op_b_will_not_go_quietly.name = "challenge_card_op_b_will_not_go_quietly_name_id"
	self.cards.op_b_will_not_go_quietly.description = "challenge_card_op_b_will_not_go_quietly_desc_id"
	self.cards.op_b_will_not_go_quietly.tradable = true
	self.cards.op_b_will_not_go_quietly.effects = {
		{
			name = BuffEffectManager.EFFECT_MODIFY_BLEEDOUT_TIMER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 7.5,
		},
	}
	self.cards.op_b_will_not_go_quietly.positive_description = {
		desc_id = "effect_bleedout_timer_increased",
		desc_params = {
			EFFECT_VALUE_1 = "7.5",
		},
	}
	self.cards.op_b_will_not_go_quietly.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.op_b_will_not_go_quietly.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_b_will_not_go_quietly.texture = "cc_booster_operation_uncommon_will_not_go_quietly_hud"
	self.cards.op_b_will_not_go_quietly.def_id = 50003
	self.cards.op_b_will_not_go_quietly.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
	self.cards.op_b_on_top_form = {}
	self.cards.op_b_on_top_form.name = "challenge_card_op_b_on_top_form_name_id"
	self.cards.op_b_on_top_form.description = "challenge_card_op_b_on_top_form_desc_id"
	self.cards.op_b_on_top_form.tradable = true
	self.cards.op_b_on_top_form.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_HEALTH,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.15,
		},
	}
	self.cards.op_b_on_top_form.positive_description = {
		desc_id = "effect_player_health_increased",
		desc_params = {
			EFFECT_VALUE_1 = "15%",
		},
	}
	self.cards.op_b_on_top_form.rarity = LootDropTweakData.RARITY_COMMON
	self.cards.op_b_on_top_form.card_type = ChallengeCardsTweakData.CARD_TYPE_OPERATION
	self.cards.op_b_on_top_form.texture = "cc_booster_operation_rare_on_top_form_hud"
	self.cards.op_b_on_top_form.def_id = 50006
	self.cards.op_b_on_top_form.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
	self.cards.ra_dooms_day = setup_card("ra_dooms_day")
	self.cards.ra_dooms_day.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_MOVEMENT_SPEED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.5,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_DOOMS_DAY,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_CANNOT_ADS,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_CANNOT_SPRINT,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_dooms_day.positive_description = {
		desc_id = BuffEffectManager.EFFECT_PLAYER_MOVEMENT_SPEED,
		desc_params = {
			EFFECT_VALUE_1 = "50%",
		},
	}
	self.cards.ra_dooms_day.negative_description = {
		desc_id = BuffEffectManager.EFFECT_PLAYER_DOOMS_DAY,
	}
	self.cards.ra_dooms_day.rarity = LootDropTweakData.RARITY_RARE
	self.cards.ra_dooms_day.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_dooms_day.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_dooms_day.bonus_xp = 400
	self.cards.ra_dooms_day.def_id = 400
	self.cards.free_crowbar = setup_card("free_crowbar")
	self.cards.free_crowbar.effects = {
		{
			name = BuffEffectManager.EFFECT_FORCED_CRATE_TIER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 3,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_EQUIP_CROWBAR,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = true,
		},
	}
	self.cards.free_crowbar.positive_description = {
		desc_id = "effect_all_chests_are_tier3",
	}
	self.cards.free_crowbar.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.free_crowbar.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.free_crowbar.def_id = 403
	self.cards.free_crowbar.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
	self.cards.lucky_day = setup_card("lucky_day")
	self.cards.lucky_day.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_CRITICAL_HIT_CHANCE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 0.1,
		},
		{
			name = BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.1,
		},
	}
	self.cards.lucky_day.positive_description = {
		desc_id = BuffEffectManager.EFFECT_LUCKY_DAY,
		desc_params = {
			EFFECT_VALUE_1 = "10%",
		},
	}
	self.cards.lucky_day.rarity = LootDropTweakData.RARITY_UNCOMMON
	self.cards.lucky_day.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.lucky_day.def_id = 404
	self.cards.lucky_day.card_category = ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER
	self.cards.ra_mag_roulette = setup_card("mag_roulette")
	self.cards.ra_mag_roulette.effects = {
		{
			name = BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = 1.3,
		},
		{
			name = BuffEffectManager.EFFECT_PLAYER_RANDOM_RELOAD,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = true,
		},
	}
	self.cards.ra_mag_roulette.positive_description = {
		desc_id = "effect_player_faster_reload",
		desc_params = {
			EFFECT_VALUE_1 = "30%",
		},
	}
	self.cards.ra_mag_roulette.negative_description = {
		desc_id = "effect_player_random_reload",
	}
	self.cards.ra_mag_roulette.rarity = LootDropTweakData.RARITY_RARE
	self.cards.ra_mag_roulette.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_mag_roulette.bonus_xp = 350
	self.cards.ra_mag_roulette.def_id = 405
	self.cards.ra_mag_roulette.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_trick_or_treat = setup_card("trick_or_treat")
	self.cards.ra_trick_or_treat.card_category = ChallengeCardsTweakData.CARD_CATEGORY_CHALLENGE_CARD
	self.cards.ra_trick_or_treat.card_type = ChallengeCardsTweakData.CARD_TYPE_RAID
	self.cards.ra_trick_or_treat.rarity = LootDropTweakData.RARITY_HALLOWEEN
	self.cards.ra_trick_or_treat.def_id = 406
	self.cards.ra_trick_or_treat.selected_sound = "halloween_challenge_card_chosen"
	self.cards.ra_trick_or_treat.bonus_xp_multiplier = 1.75
	self.cards.ra_trick_or_treat.event = true
	self.cards.ra_trick_or_treat.effects = {
		{
			effect_class = "BuffEffectCandy",
			name = BuffEffectManager.EFFECT_TRICK_OR_TREAT,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = true,
		},
		{
			name = BuffEffectManager.EFFECT_PUMKIN_HEADS,
			type = ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE,
			value = true,
		},
		{
			name = BuffEffectManager.EFFECT_FORCED_CRATE_TIER,
			type = ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE,
			value = 1,
		},
	}
	self.cards.ra_trick_or_treat.positive_description = {
		desc_id = "effect_trick_or_treat_positive",
		desc_params = {
			AMOUNT_XP = "50%",
		},
	}
	self.cards.ra_trick_or_treat.negative_description = {
		desc_id = "effect_trick_or_treat_malus",
	}
	self.cards_index = {
		"ra_on_the_scrounge",
		"ra_no_backups",
		"ra_this_is_gonna_hurt",
		"ra_not_in_the_face",
		"ra_loaded_for_bear",
		"ra_total_carnage",
		"ra_switch_hitter",
		"ra_gunslingers",
		"ra_fresh_troops",
		"ra_dont_you_die_on_me",
		"ra_no_second_chances",
		"ra_a_perfect_score",
		"ra_helmet_shortage",
		"ra_hemorrhaging",
		"ra_crab_people",
		"op_limited_supplies",
		"op_take_the_cannoli",
		"op_everyones_a_tough_guy",
		"op_nichtsplosions",
		"op_war_weary",
		"op_special_for_a_reason",
		"op_dont_blink",
		"op_bad_coffee",
		"op_playing_for_keeps",
		"op_silent_shout",
		"op_blow_me",
		"op_you_only_live_once",
		"op_short_controlled_bursts",
		"op_elite_opponents",
		"op_and_headaches_for_all",
		"ra_b_walk_it_off",
		"ra_b_in_fine_feather",
		"ra_b_precision_fire",
		"op_b_recycle_for_victory",
		"op_b_will_not_go_quietly",
		"op_b_on_top_form",
		"ra_slasher_movie",
		"ra_pumpkin_pie",
		"ra_season_of_resurrection",
		"ra_dooms_day",
		"free_crowbar",
		"lucky_day",
		"ra_mag_roulette",
		"ra_trick_or_treat",
	}
	self.playtimegenerator = {}
	self.bundledefinitions = {}
	self.generators = {}
end

function ChallengeCardsTweakData:_init_bounty_data(tweak_data)
	self.bounty_data = {}
	self.bounty_data.default_names = {
		"card_bounty_name_1_id",
		"card_bounty_name_2_id",
		"card_bounty_name_3_id",
		"card_bounty_name_4_id",
	}
	self.bounty_data.effects_library = {
		[BuffEffectManager.EFFECT_MODIFY_BLEEDOUT_TIMER] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_bleedout_timer_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_bleedout_timer_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_SET_BLEEDOUT_TIMER,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_029",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.4,
						text = "10",
						value = -10,
					},
				},
				{
					{
						difficulty = 0.6,
						text = "15",
						value = -15,
					},
				},
				{
					{
						difficulty = 0.8,
						text = "20",
						value = -20,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "3",
						value = 3,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "5",
						value = 5,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "10",
						value = 10,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_SET_BLEEDOUT_TIMER] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_set_bleedout_timer",
			},
			forbids = {
				BuffEffectManager.EFFECT_MODIFY_BLEEDOUT_TIMER,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						text = "3",
						value = 3,
					},
				},
				{
					{
						difficulty = 0.75,
						text = "10",
						value = 10,
					},
				},
				{
					{
						difficulty = 0.6,
						text = "15",
						value = 15,
					},
				},
				{
					{
						difficulty = 0.5,
						text = "20",
						value = 20,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_MODIFY_LIVES] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_modify_lives_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_modify_lives_positive",
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_035",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_036",
					"card_bounty_name_submission_037",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						text = "3",
						value = -3,
					},
				},
				{
					{
						difficulty = 0.8,
						text = "2",
						value = -2,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "1",
						value = 1,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMY_HEALTH] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_enemy_health_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_enemy_health_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_005",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_018",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = 0.75,
						text = "50%",
						value = 1.5,
					},
				},
				{
					{
						difficulty = 1,
						text = "75%",
						value = 1.75,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "25%",
						value = 0.75,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_enemy_damage_resistance_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_enemy_damage_resistance_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMY_HEALTH,
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE,
				BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.4,
						text = "30%",
						value = 0.7,
					},
				},
				{
					{
						difficulty = 1,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 1.5,
						text = "70%",
						value = 0.3,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.2,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.4,
						text = "20%",
						value = 1.2,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMY_DOES_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_enemies_damage_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_enemies_damage_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_PLAYER_HEALTH,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_003",
					"card_bounty_name_submission_013",
					"card_bounty_name_submission_026",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_004",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = 0.75,
						text = "50%",
						value = 1.5,
					},
				},
				{
					{
						difficulty = 1,
						text = "75%",
						value = 1.75,
					},
				},
				{
					{
						difficulty = 1.5,
						text = "100%",
						value = 2,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "5%",
						value = 0.95,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "10%",
						value = 0.9,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_CHANCE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_loot_drop_chance_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_loot_drop_chance_positive",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.25,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = 0.4,
						text = "20%",
						value = 0.8,
					},
				},
				{
					{
						difficulty = 0.6,
						text = "30%",
						value = 0.7,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.3,
						text = "30%",
						value = 1.3,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_loot_drop_effect_increased",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.05,
						text = "5%",
						value = 1.05,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "25%",
						value = 1.25,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_PRIMARY_AMMO_CAPACITY] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_primary_ammo_capacity_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_primary_ammo_capacity_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_021",
					"card_bounty_name_submission_022",
					"card_bounty_name_submission_028",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_030",
					"card_bounty_name_submission_034",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.7,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						added_forbids = {
							BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE,
						},
						difficulty = 0.85,
						text = "0%",
						value = 0,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.075,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.125,
						text = "40%",
						value = 1.4,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_SECONDARY_AMMO_CAPACITY] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_secondary_ammo_capacity_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_secondary_ammo_capacity_positive",
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_021",
					"card_bounty_name_submission_022",
					"card_bounty_name_submission_028",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_030",
					"card_bounty_name_submission_034",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.6,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						added_forbids = {
							BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE,
						},
						difficulty = 0.75,
						text = "0%",
						value = 0,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.05,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.075,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "40%",
						value = 1.4,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_primary_damage_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_primary_damage_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
				BuffEffectManager.EFFECT_ENEMY_HEALTH,
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_AMMO_CAPACITY,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_024",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						text = "25%",
						value = 0.75,
					},
				},
				{
					{
						difficulty = 0.6,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 0.8,
						text = "75%",
						value = 0.25,
					},
				},
				{
					{
						difficulty = 1,
						text = "95%",
						value = 0.05,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.01,
						text = "1%",
						value = 1.01,
					},
				},
				{
					{
						difficulty = -0.05,
						text = "5%",
						value = 1.05,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.3,
						text = "30%",
						value = 1.3,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_secondary_damage_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_secondary_damage_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
				BuffEffectManager.EFFECT_ENEMY_HEALTH,
				BuffEffectManager.EFFECT_PLAYER_SECONDARY_AMMO_CAPACITY,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_012",
					"card_bounty_name_submission_024",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.4,
						text = "25%",
						value = 0.75,
					},
				},
				{
					{
						difficulty = 0.5,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 0.7,
						text = "75%",
						value = 0.25,
					},
				},
				{
					{
						difficulty = 0.9,
						text = "95%",
						value = 0.05,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.01,
						text = "1%",
						value = 1.01,
					},
				},
				{
					{
						difficulty = -0.02,
						text = "5%",
						value = 1.05,
					},
				},
				{
					{
						difficulty = -0.08,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "30%",
						value = 1.3,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_HEALTH] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_health_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_health_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMY_DOES_DAMAGE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_020",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = 0.65,
						text = "25%",
						value = 0.75,
					},
				},
				{
					{
						difficulty = 1.2,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 1.8,
						text = "75%",
						value = 0.25,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.05,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = -0.4,
						text = "50%",
						value = 1.5,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_MOVEMENT_SPEED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_movement_speed_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_movement_speed_positive",
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_011",
					"card_bounty_name_submission_023",
					"card_bounty_name_submission_032",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.25,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = 0.28,
						text = "15%",
						value = 0.85,
					},
				},
				{
					{
						difficulty = 0.3,
						text = "20%",
						value = 0.8,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.75,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "30%",
						value = 1.3,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_reload_speed_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_reload_speed_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_008",
					"card_bounty_name_submission_009",
					"card_bounty_name_submission_019",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.3,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = 0.4,
						text = "20%",
						value = 0.8,
					},
				},
				{
					{
						difficulty = 0.5,
						text = "30%",
						value = 0.7,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "30%",
						value = 1.3,
					},
				},
				{
					{
						difficulty = -0.25,
						text = "50%",
						value = 1.5,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_headshots_damage_increased",
			},
			forbids = {
				BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_010",
					"card_bounty_name_submission_016",
					"card_bounty_name_submission_017",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.15,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "15%",
						value = 1.15,
					},
				},
				{
					{
						difficulty = -0.25,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.3,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = -0.35,
						text = "30%",
						value = 1.3,
					},
				},
				{
					{
						difficulty = -0.5,
						text = "50%",
						value = 1.5,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_MELEE_DAMAGE_INCREASE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_melee_damage_positive",
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_melee_damage_negative",
			},
			forbids = {
				BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.4,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 0.65,
						text = "90%",
						value = 0.1,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.35,
						text = "200%",
						value = 2,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CRITICAL_HIT_CHANCE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_crit_chance_positive",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.05,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "15%",
						value = 1.15,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.175,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "30%",
						value = 1.3,
					},
				},
				{
					{
						difficulty = -1,
						text = "100%",
						value = 2,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_headshot_doesnt_do_damage",
			},
			forbids = {
				BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_WARCRIES_DISABLED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_warcries_disabled_negative",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_AMMO_PICKUPS_REFIL_GRENADES] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_ammo_pickups_refill_equipment",
			},
			forbids = {
				BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_007",
					"card_bounty_name_submission_015",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.3,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_bags_dont_slow_players_down",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.25,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_melee_only_negative",
			},
			forbids = {
				BuffEffectManager.EFFECT_AMMO_PICKUPS_REFIL_GRENADES,
				BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED,
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE,
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_AMMO_CAPACITY,
				BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE,
				BuffEffectManager.EFFECT_PLAYER_SECONDARY_AMMO_CAPACITY,
				BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE,
				BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE,
				BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_CHANCE,
				BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_DESPAWN_AMMO,
				BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_DESPAWN_HEALTH,
				BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_014",
					"card_bounty_name_submission_027",
					"card_bounty_name_submission_033",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CAN_MOVE_ONLY_BACK_AND_SIDE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_can_only_walk_backwards_or_sideways",
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_001",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 666.666,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_DOOMS_DAY] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_PLAYER_DOOMS_DAY,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_002",
					"card_bounty_name_submission_025",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.82,
						includes = {
							[BuffEffectManager.EFFECT_PLAYER_CANNOT_ADS] = {
								value = true,
							},
							[BuffEffectManager.EFFECT_PLAYER_CANNOT_SPRINT] = {
								value = true,
							},
						},
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CANNOT_SPRINT] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_PLAYER_CANNOT_SPRINT,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.45,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CANNOT_ADS] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_PLAYER_CANNOT_ADS,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_RANDOM_RELOAD] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_PLAYER_RANDOM_RELOAD,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.65,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.3,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_TIME_SPEED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_TIME_SPEED,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.45,
						effect_class = "BuffEffectTimeSpeed",
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = 0.6,
						effect_class = "BuffEffectTimeSpeed",
						text = "20%",
						value = 1.2,
					},
				},
			},
		},
	}
end

function ChallengeCardsTweakData:get_all_cards_indexed()
	local result = {}
	local counter = 1

	for _, card_key_name in pairs(self.cards_index) do
		self.cards[card_key_name][ChallengeCardsTweakData.KEY_NAME_FIELD] = card_key_name
		result[counter] = self.cards[card_key_name]
		counter = counter + 1
	end

	return result
end

function ChallengeCardsTweakData:get_card_by_key_name(card_key_name)
	local result = {}
	local card_data = self.cards[card_key_name]

	if not card_data and card_key_name == "bounty_card" then
		card_data = managers.raid_job:bounty_job_data().active_card
	end

	if card_data then
		result = clone(card_data)
		result[ChallengeCardsTweakData.KEY_NAME_FIELD] = card_key_name
	else
		result = nil
	end

	return result
end

function ChallengeCardsTweakData:get_card_def_id_by_key_name(card_key_name)
	local result = self:get_card_by_key_name(card_key_name)

	return result.def_id
end
