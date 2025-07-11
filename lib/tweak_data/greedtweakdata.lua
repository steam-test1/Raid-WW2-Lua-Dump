GreedTweakData = GreedTweakData or class()

function GreedTweakData:init()
	self.difficulty_level_point_multipliers = {
		1,
		2,
		3.5,
		4.5,
	}
	self.difficulty_level_point_multipliers_carry = {
		0.5,
		1,
		1.5,
		2,
	}
	self.cache_base_spawn_chance = 0.25
	self.difficulty_cache_chance_multipliers = {
		0,
		1,
		1.35,
		1.5,
	}

	self:_init_item_values()
	self:_init_greed_items()
	self:_init_cache_items()
	self:_init_value_weights()
end

function GreedTweakData:_init_item_values()
	self.item_value = {}
	self.item_value.complete_gold_bar = 1000
	self.item_value.rare_commodity = 700
	self.item_value.high_end = 400
	self.item_value.mid_end = 250
	self.item_value.low_end = 100
	self.item_value.carry_painting = 1000
	self.item_value.carry_painting_cheap = 350
	self.item_value.carry_gold = 1500
	self.item_value.carry_gold_bar = 500
	self.item_value.carry_high_end = 2000
	self.item_value.carry_mid_end = 1250
	self.item_value.carry_low_end = 500
end

function GreedTweakData:_init_greed_items()
	self.greed_items = {}
	self.greed_items.confidential_documents = {}
	self.greed_items.confidential_documents.name_id = "hud_confidential_documents"
	self.greed_items.confidential_documents.hud_icon = "carry_gold"
	self.greed_items.confidential_documents.value = self.item_value.complete_gold_bar
	self.greed_items.chocolate_box = {}
	self.greed_items.chocolate_box.name_id = "hud_carry_chocolate_box"
	self.greed_items.chocolate_box.hud_icon = "carry_gold"
	self.greed_items.chocolate_box.value = self.item_value.rare_commodity
	self.greed_items.cigar_box = {}
	self.greed_items.cigar_box.name_id = "hud_carry_cigar_crate"
	self.greed_items.cigar_box.hud_icon = "carry_gold"
	self.greed_items.cigar_box.value = self.item_value.rare_commodity
	self.greed_items.wine_box = {}
	self.greed_items.wine_box.name_id = "hud_carry_wine_crate"
	self.greed_items.wine_box.hud_icon = "carry_gold"
	self.greed_items.wine_box.value = self.item_value.rare_commodity
	self.greed_items.jewelry_box = {}
	self.greed_items.jewelry_box.name_id = "hud_greed_jewelry_box"
	self.greed_items.jewelry_box.hud_icon = "carry_gold"
	self.greed_items.jewelry_box.value = self.item_value.rare_commodity
	self.greed_items.eagle_statue = {}
	self.greed_items.eagle_statue.name_id = "hud_greed_eagle_statue"
	self.greed_items.eagle_statue.hud_icon = "carry_gold"
	self.greed_items.eagle_statue.value = self.item_value.high_end
	self.greed_items.coin_collection = {}
	self.greed_items.coin_collection.name_id = "hud_greed_coin_collection"
	self.greed_items.coin_collection.hud_icon = "carry_gold"
	self.greed_items.coin_collection.value = self.item_value.high_end
	self.greed_items.egg_decoration = {}
	self.greed_items.egg_decoration.name_id = "hud_greed_egg_decoration"
	self.greed_items.egg_decoration.hud_icon = "carry_gold"
	self.greed_items.egg_decoration.value = self.item_value.high_end
	self.greed_items.vase = {}
	self.greed_items.vase.name_id = "hud_greed_vase"
	self.greed_items.vase.hud_icon = "carry_gold"
	self.greed_items.vase.value = self.item_value.high_end
	self.greed_items.golden_inkwell = {}
	self.greed_items.golden_inkwell.name_id = "hud_greed_golden_inkwell"
	self.greed_items.golden_inkwell.hud_icon = "carry_gold"
	self.greed_items.golden_inkwell.value = self.item_value.mid_end
	self.greed_items.golden_medal = {}
	self.greed_items.golden_medal.name_id = "hud_greed_golden_medal"
	self.greed_items.golden_medal.hud_icon = "carry_gold"
	self.greed_items.golden_medal.value = self.item_value.mid_end
	self.greed_items.book = {}
	self.greed_items.book.name_id = "hud_greed_book"
	self.greed_items.book.hud_icon = "carry_gold"
	self.greed_items.book.value = self.item_value.mid_end
	self.greed_items.globe = {}
	self.greed_items.globe.name_id = "hud_greed_globe"
	self.greed_items.globe.hud_icon = "carry_gold"
	self.greed_items.globe.value = self.item_value.mid_end
	self.greed_items.kaleidoscope = {}
	self.greed_items.kaleidoscope.name_id = "hud_greed_kaleidoscope"
	self.greed_items.kaleidoscope.hud_icon = "carry_gold"
	self.greed_items.kaleidoscope.value = self.item_value.mid_end
	self.greed_items.lighter = {}
	self.greed_items.lighter.name_id = "hud_greed_lighter"
	self.greed_items.lighter.hud_icon = "carry_gold"
	self.greed_items.lighter.value = self.item_value.low_end
	self.greed_items.letter_opener = {}
	self.greed_items.letter_opener.name_id = "hud_greed_letter_opener"
	self.greed_items.letter_opener.hud_icon = "carry_gold"
	self.greed_items.letter_opener.value = self.item_value.low_end
	self.greed_items.golden_compass = {}
	self.greed_items.golden_compass.name_id = "hud_greed_golden_compass"
	self.greed_items.golden_compass.hud_icon = "carry_gold"
	self.greed_items.golden_compass.value = self.item_value.low_end
	self.greed_items.watch = {}
	self.greed_items.watch.name_id = "hud_greed_watch"
	self.greed_items.watch.hud_icon = "carry_gold"
	self.greed_items.watch.value = self.item_value.low_end
end

function GreedTweakData:_init_cache_items()
	self.cache_items = {}
	self.cache_items.regular_cache_box = {}
	self.cache_items.regular_cache_box.name_id = "hud_greed_regular_cache_box"
	self.cache_items.regular_cache_box.hud_icon = "carry_gold"
	self.cache_items.regular_cache_box.value = self.item_value.complete_gold_bar * 4
	self.cache_items.regular_cache_box.single_interaction_value = 300
	self.cache_items.regular_cache_box.single_interaction_value_rand = {
		4,
		50,
	}
	self.cache_items.regular_cache_box.interaction_timer = 0.6
	self.cache_items.regular_cache_box.lockpick = {
		circle_difficulty = {
			0.9,
			0.92,
			0.94,
		},
		circle_rotation_direction = {
			1,
			-1,
			1,
		},
		circle_rotation_speed = {
			240,
			260,
			280,
		},
		number_of_circles = 3,
		sounds = {
			circles = {
				{
					lock = "lock_a",
					mechanics = "lock_mechanics_a",
				},
				{
					lock = "lock_b",
					mechanics = "lock_mechanics_b",
				},
				{
					lock = "lock_c",
					mechanics = "lock_mechanics_c",
				},
			},
			dialog_enter = "player_gen_picking_lock",
			dialog_fail = "player_gen_lockpick_fail",
			dialog_success = "player_gen_lock_picked",
			failed = "lock_fail",
			success = "success",
		},
	}
	self.cache_items.regular_cache_box.sequences = {
		{
			max_value = 0,
			sequence = "chest_open_empty",
		},
		{
			max_value = 0.5,
			sequence = "chest_open_half_full",
		},
		{
			max_value = 1,
			sequence = "chest_open_full",
		},
	}
end

function GreedTweakData:_init_value_weights()
	self.value_weights = {}
	self.value_weights.pickpocket = {
		{
			{
				chance = 55,
				value = 0,
			},
			{
				chance = 45,
				value = self.item_value.low_end,
			},
		},
		{
			{
				chance = 60,
				value = 0,
			},
			{
				chance = 43,
				value = self.item_value.low_end,
			},
		},
		{
			{
				chance = 55,
				value = 0,
			},
			{
				chance = 35,
				value = self.item_value.low_end,
			},
			{
				chance = 10,
				value = self.item_value.mid_end,
			},
		},
		{
			{
				chance = 50,
				value = 0,
			},
			{
				chance = 32,
				value = self.item_value.low_end,
			},
			{
				chance = 12,
				value = self.item_value.mid_end,
			},
			{
				chance = 6,
				value = self.item_value.high_end,
			},
		},
	}
end

function GreedTweakData:value_line_id(v)
	v = v or 0

	if v >= self.item_value.high_end then
		return "large"
	elseif v >= self.item_value.mid_end then
		return "medium"
	elseif v >= self.item_value.low_end then
		return "small"
	end

	return "empty"
end

function GreedTweakData:get_random_item_weighted(weights)
	if not weights then
		return
	end

	local total = 0

	for _, value_entry in pairs(weights) do
		total = total + value_entry.chance
	end

	local value_tier = self.item_value.low_end
	local value = math.random(total)

	for _, value_entry in pairs(weights) do
		value = value - value_entry.chance

		if value <= 0 then
			value_tier = value_entry.value

			break
		end
	end

	if value_tier == 0 then
		return
	end

	local tier_table = {}

	for name, item in pairs(self.greed_items) do
		if item.value == value_tier then
			table.insert(tier_table, name)
		end
	end

	local winner_item = tier_table[math.random(#tier_table)]

	return winner_item, self.greed_items[winner_item]
end
