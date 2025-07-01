CarryTweakData = CarryTweakData or class()
CarryTweakData.default_throw_power = 600
CarryTweakData.corpse_throw_power = 180

function CarryTweakData:init(tweak_data)
	self:_init_shared_multipliers()

	self.default_lootbag = "units/vanilla/dev/dev_lootbag/dev_lootbag"
	self.default_visual_unit = "units/vanilla/dev/dev_player_loot_bag/dev_player_loot_bag"
	self.default_visual_unit_joint_array = {
		"Spine1",
	}
	self.default_visual_unit_root_joint = "Hips"
	self.default_bag_delay = 0.1
	self.default_bag_weight = 2
	self.default_bag_icon = "carry_bag"
	self.backup_corpse_body_id = "corpse_body"
	self.types = {}
	self.types.being = {}
	self.types.being.move_speed_modifier = {
		0.7,
		0.7,
	}
	self.types.being.jump_modifier = {
		0.8,
		0.8,
	}
	self.types.being.stamina_consume_multi = {
		1.5,
		1.5,
	}
	self.types.being.throw_distance_multiplier = {
		1,
		1,
	}
	self.types.being.can_run = false
	self.types.normal = {}
	self.types.normal.move_speed_modifier = {
		1,
		0.8,
	}
	self.types.normal.jump_modifier = {
		1,
		0.8,
	}
	self.types.normal.stamina_consume_multi = {
		1,
		1.5,
	}
	self.types.normal.throw_distance_multiplier = {
		1,
		1,
	}
	self.types.normal.can_run = true

	local unit_painting_bag = "units/vanilla/starbreeze_units/sto_units/pickups/pku_painting_bag/pku_painting_bag"
	local unit_painting_bag_acc = "units/vanilla/starbreeze_units/sto_units/characters/npc_acc_painting_bag/npc_acc_painting_bag"
	local unit_painting_bag_static = "units/vanilla/starbreeze_units/sto_units/pickups/pku_painting_bag/pku_canvasbag_static"

	self.painting_sto = {}
	self.painting_sto.type = "normal"
	self.painting_sto.name_id = "hud_carry_painting"
	self.painting_sto.loot_value = 3
	self.painting_sto.loot_outlaw_value = 3
	self.painting_sto.loot_greed_value = tweak_data.greed.item_value.carry_painting
	self.painting_sto.unit = unit_painting_bag
	self.painting_sto.visual_unit_name = unit_painting_bag_acc
	self.painting_sto.unit_static = unit_painting_bag_static
	self.painting_sto.visual_unit_root_joint = "body_bag_spawn"
	self.painting_sto.AI_carry = {
		SO_category = "enemies",
	}
	self.painting_sto.hud_icon = "carry_painting"
	self.painting_sto.throw_rotations = Rotation(0, 0, 66)
	self.painting_sto.upgrade_throw_multiplier = self.THROW_MULTIPLIERS_GENERIC
	self.painting_sto.weight = 2
	self.painting_sto.show_objects = {
		g_sticker = true,
	}
	self.painting_sto_cheap = deep_clone(self.painting_sto)
	self.painting_sto_cheap.name_id = "hud_carry_painting"
	self.painting_sto_cheap.hud_icon = "carry_painting_cheap"
	self.painting_sto_cheap.loot_value = 1
	self.painting_sto_cheap.loot_outlaw_value = 1
	self.painting_sto_cheap.loot_greed_value = tweak_data.greed.item_value.carry_painting_cheap
	self.painting_sto_cheap.show_objects = {
		g_sticker = false,
	}
	self.wine_crate = {}
	self.wine_crate.type = "normal"
	self.wine_crate.name_id = "hud_carry_wine_crate"
	self.wine_crate.loot_value = 3
	self.wine_crate.loot_outlaw_value = 4
	self.wine_crate.loot_greed_value = tweak_data.greed.item_value.carry_high_end
	self.wine_crate.unit = "units/vanilla/starbreeze_units/cvy_units/pickups/pku_crate_wine_bag/pku_crate_wine_bag"
	self.wine_crate.skip_exit_secure = true
	self.wine_crate.AI_carry = {
		SO_category = "enemies",
	}
	self.wine_crate.upgrade_throw_multiplier = self.THROW_MULTIPLIERS_GENERIC
	self.wine_crate.weight = 3
	self.wine_crate.hud_icon = "carry_artefact"
	self.cigar_crate = deep_clone(self.wine_crate)
	self.cigar_crate.name_id = "hud_carry_cigar_crate"
	self.cigar_crate.unit = "units/vanilla/starbreeze_units/cvy_units/pickups/pku_crate_cigar_bag/pku_crate_cigar_bag"
	self.baptismal_font = deep_clone(self.wine_crate)
	self.baptismal_font.name_id = "hud_carry_baptismal_font"
	self.baptismal_font.unit = "units/vanilla/starbreeze_units/cvy_units/pickups/pku_baptismal_font_bag/pku_baptismal_font_bag"
	self.chocolate_box = {}
	self.chocolate_box.type = "normal"
	self.chocolate_box.name_id = "hud_carry_chocolate_box"
	self.chocolate_box.loot_value = 2
	self.chocolate_box.loot_outlaw_value = 3
	self.chocolate_box.loot_greed_value = tweak_data.greed.item_value.carry_mid_end
	self.chocolate_box.unit = "units/vanilla/starbreeze_units/cvy_units/pickups/pku_chocolate_box_bag/pku_chocolate_box_bag"
	self.chocolate_box.skip_exit_secure = true
	self.chocolate_box.AI_carry = {
		SO_category = "enemies",
	}
	self.chocolate_box.upgrade_throw_multiplier = self.THROW_MULTIPLIERS_GENERIC
	self.chocolate_box.weight = 2
	self.chocolate_box.hud_icon = "carry_artefact"
	self.crucifix = deep_clone(self.chocolate_box)
	self.crucifix.name_id = "hud_carry_crucifix"
	self.crucifix.unit = "units/vanilla/starbreeze_units/cvy_units/pickups/pku_crucifix_bag/pku_crucifix_bag"
	self.religious_figurine = deep_clone(self.chocolate_box)
	self.religious_figurine.name_id = "hud_carry_religious_figurine"
	self.religious_figurine.unit = "units/vanilla/starbreeze_units/cvy_units/pickups/pku_religious_figurine_bag/pku_religious_figurine_bag"
	self.candelabrum = deep_clone(self.chocolate_box)
	self.candelabrum.name_id = "hud_carry_candleabrum"
	self.candelabrum.unit = "units/vanilla/starbreeze_units/cvy_units/pickups/pku_candelabrum_bag/pku_candelabrum_bag"
	self.flak_shell = {}
	self.flak_shell.type = "normal"
	self.flak_shell.name_id = "hud_carry_flak_shell"
	self.flak_shell.skip_exit_secure = true
	self.flak_shell.unit = "units/vanilla/pickups/pku_flak_shell_bag/pku_flak_shell_bag"
	self.flak_shell.hud_icon = "carry_flak_shell"
	self.flak_shell.throw_sound = "flakshell_throw"
	self.flak_shell.upgrade_weight_multiplier = self.WEIGHT_MULTIPLIERS_SHELL
	self.flak_shell.weight = 4
	self.flak_shell_explosive = deep_clone(self.flak_shell)
	self.flak_shell_explosive.type = "normal"
	self.flak_shell_explosive.unit = "units/vanilla/pickups/pku_88_flak_shell_bag/pku_88_flak_shell_bag"
	self.flak_shell_explosive.hud_icon = "carry_flak_shell"
	self.flak_shell_explosive.can_explode = true
	self.flak_shell_explosive.throw_sound = "flakshell_throw"
	self.flak_shell_shot_explosive = deep_clone(self.flak_shell)
	self.flak_shell_shot_explosive.type = "normal"
	self.flak_shell_shot_explosive.unit = "units/vanilla/pickups/pku_88_flak_shell_explosive_bag/pku_88_flak_shell_explosive_bag"
	self.flak_shell_shot_explosive.hud_icon = "carry_flak_shell"
	self.flak_shell_shot_explosive.throw_sound = "flakshell_throw"
	self.flak_shell_shot_explosive.can_explode = true
	self.flak_shell_pallete = {}
	self.flak_shell_pallete.type = "normal"
	self.flak_shell_pallete.name_id = "hud_carry_flak_shell_pallete"
	self.flak_shell_pallete.skip_exit_secure = true
	self.flak_shell_pallete.throw_sound = "flakshell_throw"
	self.flak_shell_pallete.upgrade_weight_multiplier = self.WEIGHT_MULTIPLIERS_SHELL
	self.flak_shell_pallete.weight = 4
	self.tank_shells = {}
	self.tank_shells.type = "normal"
	self.tank_shells.name_id = "hud_carry_tank_shells"
	self.tank_shells.skip_exit_secure = true
	self.tank_shells.throw_sound = "flakshell_throw"
	self.tank_shells.hud_icon = "carry_flak_shell"
	self.tank_shells.upgrade_weight_multiplier = self.WEIGHT_MULTIPLIERS_SHELL
	self.tank_shells.weight = 4
	self.tank_shell_explosive = deep_clone(self.tank_shells)
	self.tank_shell_explosive.name_id = "hud_tank_shell"
	self.tank_shell_explosive.unit = "units/vanilla/pickups/pku_tank_shell_bag/pku_tank_shell_bag"
	self.tank_shell_explosive.can_explode = true
	self.plank = {}
	self.plank.type = "normal"
	self.plank.name_id = "hud_carry_plank"
	self.plank.unit = "units/vanilla/pickups/pku_plank_bag/pku_plank_bag"
	self.plank.hud_icon = "carry_planks"
	self.plank.cannot_stack = true
	self.plank.skip_exit_secure = true
	self.turret_m2_gun = {}
	self.turret_m2_gun.type = "normal"
	self.turret_m2_gun.name_id = "hud_carry_turret_m2_gun"
	self.turret_m2_gun.unit = "units/vanilla/pickups/pku_lootbag/pku_lootbag"
	self.turret_m2_gun.hud_icon = "carry_planks"
	self.turret_m2_gun.cannot_stack = true
	self.turret_m2_gun.skip_exit_secure = true
	self.parachute = {}
	self.parachute.type = "normal"
	self.parachute.name_id = "hud_carry_parachute"
	self.parachute.skip_exit_secure = true
	self.parachute.cannot_stack = true
	self.gold_bar = {}
	self.gold_bar.type = "normal"
	self.gold_bar.name_id = "hud_carry_gold_bar"
	self.gold_bar.loot_value = 2
	self.gold_bar.loot_outlaw_value = 2
	self.gold_bar.loot_greed_value = tweak_data.greed.item_value.carry_gold_bar
	self.gold_bar.unit = "units/vanilla/pickups/pku_gold_bar_bag/pku_gold_bar_bag"
	self.gold_bar.unit_static = "units/vanilla/pickups/pku_gold_bar_bag/pku_gold_bar_bag_static"
	self.gold_bar.hud_icon = "carry_gold"
	self.gold_bar.AI_carry = {
		SO_category = "enemies",
	}
	self.gold_bar.throw_rotations = Rotation(2, 40, 8)
	self.gold_bar.upgrade_throw_multiplier = self.THROW_MULTIPLIERS_GENERIC
	self.gold_bar.weight = 1
	self.gold = {}
	self.gold.type = "normal"
	self.gold.name_id = "hud_carry_gold"
	self.gold.loot_value = self.gold_bar.loot_value * 3
	self.gold.loot_outlaw_value = self.gold_bar.loot_outlaw_value * 3
	self.gold.loot_greed_value = tweak_data.greed.item_value.carry_gold
	self.gold.unit = "units/vanilla/pickups/pku_gold_crate_bag/pku_gold_crate_bag"
	self.gold.unit_static = "units/vanilla/pickups/pku_gold_crate_bag/pku_gold_crate_bag_static"
	self.gold.hud_icon = "carry_gold"
	self.gold.AI_carry = {
		SO_category = "enemies",
	}
	self.gold.throw_rotations = Rotation(0, 20, 0)
	self.gold.upgrade_throw_multiplier = self.THROW_MULTIPLIERS_GENERIC
	self.gold.weight = self.gold_bar.weight * 3
	self.crate_explosives = {
		hud_icon = "carry_explosive",
		name_id = "hud_carry_explosives",
		skip_exit_secure = true,
		type = "normal",
		unit = "units/upd_fb/pickups/pku_crate_explosives/pku_crate_explosives_bag",
		unit_static = "units/upd_fb/pickups/pku_crate_explosives/pku_crate_explosives_static",
		upgrade_weight_multiplier = self.WEIGHT_MULTIPLIERS_SHELL,
		weight = 2,
	}
	self.conspiracy_board = deep_clone(self.painting_sto)
	self.conspiracy_board.unit = "units/upd_fb/props/wall_board_conspiracy/pku_conspiracy_board_bag"
	self.conspiracy_board.name_id = "hud_carry_conspiracy_board"
	self.cable_plug = {}
	self.cable_plug.type = "normal"
	self.cable_plug.hud_icon = "carry_planks"
	self.cable_plug.cannot_stack = true
	self.cable_plug.skip_exit_secure = true
	self.cable_plug.unit = false
	self.cable_plug.weight = 4
	self.corpse_body = {}
	self.corpse_body.type = "being"
	self.corpse_body.name_id = "hud_carry_body"
	self.corpse_body.carry_item_id = "carry_item_corpse"
	self.corpse_body.hud_icon = "carry_corpse"
	self.corpse_body.throw_power = CarryTweakData.corpse_throw_power
	self.corpse_body.upgrade_weight_multiplier = self.WEIGHT_MULTIPLIERS_CORPSE
	self.corpse_body.skip_exit_secure = true
	self.corpse_body.needs_headroom_to_drop = true
	self.corpse_body.is_corpse = true
	self.corpse_body.cannot_stack = true
	self.corpse_body.cannot_secure = true
	self.german_spy_body = deep_clone(self.corpse_body)
	self.german_spy_body.name_id = "hud_carry_spy"
	self.german_spy_body.character_id = "civilian"
	self.german_spy_body.prompt_text = "hud_carry_put_down_prompt"
	self.german_spy_body.carry_item_id = "carry_item_spy"
	self.german_spy_body.hud_icon = "carry_alive"
	self.german_spy_body.visual_unit_root_joint = "body_bag_spawn"
	self.german_spy_body.visual_unit_name = "units/vanilla/characters/npc/models/raid_npc_spy/body_bag/raid_npc_spy_body_bag"
	self.german_spy_body.unit_static = "units/vanilla/characters/npc/models/raid_npc_spy/raid_npc_spy_static"
	self.german_spy_body.unit = "units/vanilla/characters/npc/models/raid_npc_spy/raid_npc_spy_corpse"
	self.german_spy_body.ignore_corpse_cleanup = true

	self:_build_missing_corpse_bags(tweak_data)

	self.codemachine_part_01 = {}
	self.codemachine_part_01.type = "normal"
	self.codemachine_part_01.name_id = "hud_carry_codemachine_part_01"
	self.codemachine_part_01.skip_exit_secure = true
	self.codemachine_part_01.weight = 1
	self.codemachine_part_02 = deep_clone(self.codemachine_part_01)
	self.codemachine_part_02.name_id = "hud_carry_codemachine_part_02"
	self.codemachine_part_03 = deep_clone(self.codemachine_part_01)
	self.codemachine_part_03.name_id = "hud_carry_codemachine_part_03"
	self.codemachine_part_04 = deep_clone(self.codemachine_part_01)
	self.codemachine_part_04.name_id = "hud_carry_codemachine_part_04"
	self.contraband_jewelry = {}
	self.contraband_jewelry.type = "normal"
	self.contraband_jewelry.name_id = "hud_carry_contraband_jewelry"
	self.contraband_jewelry.skip_exit_secure = true
	self.contraband_jewelry.weight = 1
	self.dev_pku_carry_light = {}
	self.dev_pku_carry_light.type = "normal"
	self.dev_pku_carry_light.name_id = "dev_pku_carry_light"
	self.dev_pku_carry_light.hud_icon = "carry_gold"
	self.dev_pku_carry_light.loot_value = 3
	self.dev_pku_carry_light.loot_outlaw_value = 1
	self.dev_pku_carry_light.loot_greed_value = 1
	self.dev_pku_carry_light.AI_carry = {
		SO_category = "enemies",
	}
	self.dev_pku_carry_light.weight = 1
	self.dev_pku_carry_medium = {}
	self.dev_pku_carry_medium.type = "normal"
	self.dev_pku_carry_medium.name_id = "dev_pku_carry_medium"
	self.dev_pku_carry_medium.hud_icon = "carry_gold"
	self.dev_pku_carry_medium.loot_value = 2
	self.dev_pku_carry_medium.loot_outlaw_value = 1
	self.dev_pku_carry_medium.loot_greed_value = 1
	self.dev_pku_carry_medium.AI_carry = {
		SO_category = "enemies",
	}
	self.dev_pku_carry_medium.weight = 2
	self.dev_pku_carry_heavy = {}
	self.dev_pku_carry_heavy.type = "normal"
	self.dev_pku_carry_heavy.name_id = "dev_pku_carry_heavy"
	self.dev_pku_carry_heavy.hud_icon = "carry_gold"
	self.dev_pku_carry_heavy.loot_value = 1
	self.dev_pku_carry_heavy.loot_outlaw_value = 1
	self.dev_pku_carry_heavy.loot_greed_value = 1
	self.dev_pku_carry_heavy.AI_carry = {
		SO_category = "enemies",
	}
	self.dev_pku_carry_heavy.weight = 3
	self.crate_of_fuel_canisters = {}
	self.crate_of_fuel_canisters.type = "normal"
	self.crate_of_fuel_canisters.name_id = "hud_carry_crate_of_fuel_canisters"
	self.crate_of_fuel_canisters.skip_exit_secure = false
	self.crate_of_fuel_canisters.AI_carry = {
		SO_category = "enemies",
	}
	self.crate_of_fuel_canisters.weight = 3
	self.spiked_wine_barrel = {}
	self.spiked_wine_barrel.type = "normal"
	self.spiked_wine_barrel.name_id = "hud_carry_spiked_wine"
	self.spiked_wine_barrel.unit = "units/vanilla/pickups/pku_barrel_bag/pku_barrel_bag"
	self.spiked_wine_barrel.skip_exit_secure = true
	self.spiked_wine_barrel.AI_carry = {
		SO_category = "enemies",
	}
	self.spiked_wine_barrel.weight = 3
	self.bonds_stack = {}
	self.bonds_stack.type = "normal"
	self.bonds_stack.name_id = "hud_carry_bonds"
	self.bonds_stack.loot_value = 2
	self.bonds_stack.AI_carry = {
		SO_category = "enemies",
	}
	self.bonds_stack.weight = 2
	self.torch_tank = {}
	self.torch_tank.type = "normal"
	self.torch_tank.name_id = "hud_carry_torch_tank"
	self.torch_tank.skip_exit_secure = true
	self.torch_tank.cannot_stack = true
	self.money_print_plate = {}
	self.money_print_plate.type = "normal"
	self.money_print_plate.name_id = "hud_carry_money_print_plate"
	self.money_print_plate.skip_exit_secure = true
	self.money_print_plate.weight = 2
	self.ladder_4m = {}
	self.ladder_4m.type = "normal"
	self.ladder_4m.name_id = "hud_carry_ladder"
	self.ladder_4m.skip_exit_secure = true
	self.ladder_4m.cannot_stack = true
end

function CarryTweakData:_init_shared_multipliers()
	self.WEIGHT_MULTIPLIERS_SHELL = {
		category = "carry",
		upgrade = "saboteur_shell_weight_multiplier",
	}
	self.WEIGHT_MULTIPLIERS_CORPSE = {
		category = "carry",
		upgrade = "predator_corpse_weight_multiplier",
	}
	self.THROW_MULTIPLIERS_GENERIC = {
		category = "carry",
		upgrade = "strongback_throw_distance_multiplier",
	}
end

function CarryTweakData:_build_missing_corpse_bags(tweak_data)
	local char_map = tweak_data.character.character_map()

	for _, data in pairs(char_map) do
		for _, character in ipairs(data.list) do
			if not self[character .. "_body"] then
				local bodybag_path = data.path .. character
				local character_path = bodybag_path .. "/" .. character
				local bag = deep_clone(self.corpse_body)

				bag.character_id = character
				bag.unit = character_path .. "_corpse"
				bag.visual_unit_name = bodybag_path .. "/body_bag/" .. character .. "_body_bag"
				bag.visual_unit_root_joint = "body_bag_spawn"
				self[character .. "_body"] = bag
			end
		end
	end
end

function CarryTweakData:get_carry_ids()
	local t = {}

	for id, _ in pairs(tweak_data.carry) do
		if type(tweak_data.carry[id]) == "table" and tweak_data.carry[id].type then
			table.insert(t, id)
		end
	end

	table.sort(t)

	return t
end

function CarryTweakData:get_zipline_offset(carry_id)
	if self[carry_id] and not not self[carry_id].zipline_offset then
		return self[carry_id].zipline_offset
	end

	return Vector3(15, 0, -8)
end

function CarryTweakData:get_type_value_weighted(type_id, get_id, weight)
	local type_data = self.types[type_id]

	if type_data then
		if type(type_data[1]) == "boolean" then
			return weight <= type_data[get_id][1] or type_data[get_id][2]
		else
			return math.lerp(type_data[get_id][1], type_data[get_id][2], weight)
		end
	end

	return nil
end
