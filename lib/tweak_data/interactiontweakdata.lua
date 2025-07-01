InteractionTweakData = InteractionTweakData or class()

function InteractionTweakData:get_interaction(key)
	if self[key] then
		return self[key]
	else
		Application:warn("[InteractionTweakData:get_interaction] Interaction '" .. tostring(key) .. "' does not exist!")

		return self.temp_interact_box
	end
end

function InteractionTweakData:init()
	self.DEFAULT_INTERACTION_DOT = 0.9
	self.CULLING_DISTANCE = 2000
	self.INTERACT_DISTANCE = 200
	self.POWERUP_INTERACTION_DISTANCE = 270
	self.CARRY_DROP_INTERACTION_DISTANCE = 270
	self.SMALL_OBJECT_INTERACTION_DISTANCE = 165
	self.INTERACT_DELAY_COMPLETED = 0.04
	self.INTERACT_DELAY_INTERRUPTED = 0.12
	self.INTERACT_TIMER_INSTA = 0
	self.INTERACT_TIMER_VERY_SHORT = 0.5
	self.INTERACT_TIMER_SHORT = 1
	self.INTERACT_TIMER_MEDIUM = 2
	self.INTERACT_TIMER_LONG = 4
	self.INTERACT_TIMER_CARRY = 1.5
	self.INTERACT_TIMER_CARRY_PAINTING = 1
	self.INTERACT_TIMER_CORPSE = 2
	self.MINIGAME_PICK_LOCK = "pick_lock"
	self.MINIGAME_CUT_FUSE = "cut_fuse"
	self.MINIGAME_REWIRE = "rewire"
	self.MINIGAME_REVIVE = "revive"
	self.MINIGAME_SELF_REVIE = "si_revive"
	self.MINIGAME_CC_ROULETTE = "roulette"

	self:_init_shared_multipliers()
	self:_init_shared_sounds()
	self:_init_interactions()
	self:_init_carry()
	self:_init_comwheels()
	self:_init_minigames()
end

function InteractionTweakData:_init_shared_multipliers()
	self.TIMER_MULTIPLIERS_GENERIC = {
		{
			category = "interaction",
			upgrade = "handyman_generic_speed_multiplier",
		},
	}
	self.TIMER_MULTIPLIERS_DYNAMITE = {
		{
			category = "interaction",
			upgrade = "saboteur_dynamite_speed_multiplier",
		},
	}
	self.TIMER_MULTIPLIERS_CROWBAR = {
		{
			category = "interaction",
			upgrade = "sapper_crowbar_speed_multiplier",
		},
	}
	self.TIMER_MULTIPLIERS_CORPSE = {
		{
			category = "interaction",
			upgrade = "predator_corpse_speed_multiplier",
		},
	}
	self.TIMER_MULTIPLIERS_CARRY = {
		{
			category = "interaction",
			upgrade = "strongback_carry_pickup_multiplier",
		},
	}
	self.TIMER_MULTIPLIERS_REWIRE = {
		{
			category = "interaction",
			upgrade = "handyman_rewire_speed_multipler",
		},
	}
end

function InteractionTweakData:_init_shared_sounds()
	self.LOCKPICK_SOUNDS = {
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
			{
				lock = "lock_b",
				mechanics = "lock_mechanics_b",
			},
		},
		dialog_enter = "player_gen_picking_lock",
		dialog_fail = "player_gen_lockpick_fail",
		dialog_success = "player_gen_lock_picked",
		failed = "lock_fail",
		success = "success",
	}
	self.DYNAMITE_SOUNDS = {
		apply = "lock_a",
		dialog_enter = "player_gen_rigging_fuse",
		dialog_success = "player_gen_fuse_rigged",
		failed = "lock_fail",
		finish = "plant_dynamite_finish",
		start = "plant_dynamite_start",
		success = "success",
		tick = "lock_mechanics_a",
	}
	self.REWIRE_SOUNDS = {
		apply = "lock_a",
		dialog_enter = "player_gen_picking_lock",
		dialog_fail = "player_gen_lockpick_fail",
		dialog_success = "player_gen_lock_picked",
		failed = "lock_fail",
		success = "success",
		tick = "lock_mechanics_a",
	}
end

function InteractionTweakData:_init_interactions()
	self.temp_interact_box = {}
	self.temp_interact_box.icon = "develop"
	self.temp_interact_box.text_id = "debug_interact_temp_interact_box"
	self.temp_interact_box.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.temp_interact_box.timer = 1
	self.temp_interact_box.interact_distance = 350
	self.temp_interact_box_long = deep_clone(self.temp_interact_box)
	self.temp_interact_box_long.timer = 4
	self.copy_machine_smuggle = {}
	self.copy_machine_smuggle.icon = "equipment_thermite"
	self.copy_machine_smuggle.text_id = "debug_interact_copy_machine"
	self.copy_machine_smuggle.interact_distance = 305
	self.grenade_crate = {}
	self.grenade_crate.icon = "equipment_ammo_bag"
	self.grenade_crate.text_id = "hud_interact_grenade_crate_take_grenades"
	self.grenade_crate.contour = "crate_loot_pickup"
	self.grenade_crate.blocked_hint_sound = "no_more_grenades"
	self.grenade_crate.action_text_id = "hud_action_taking_grenades"
	self.grenade_crate.interact_distance = self.POWERUP_INTERACTION_DISTANCE
	self.grenade_pickup_new = deep_clone(self.grenade_crate)
	self.grenade_pickup_new.start_active = true
	self.grenade_pickup_new.keep_active = true
	self.projectile_collect = deep_clone(self.grenade_crate)
	self.projectile_collect.force_update_position = true
	self.projectile_collect.start_active = false
	self.projectile_collect.keep_active = false
	self.grenade_crate_small = {}
	self.grenade_crate_small.icon = self.grenade_crate.icon
	self.grenade_crate_small.text_id = self.grenade_crate.text_id
	self.grenade_crate_small.contour = self.grenade_crate.contour
	self.grenade_crate_small.blocked_hint = self.grenade_crate.blocked_hint
	self.grenade_crate_small.blocked_hint_sound = self.grenade_crate.blocked_hint_sound
	self.grenade_crate_small.sound_start = self.grenade_crate.sound_start
	self.grenade_crate_small.sound_interupt = self.grenade_crate.sound_interupt
	self.grenade_crate_small.sound_done = self.grenade_crate.sound_done
	self.grenade_crate_small.action_text_id = self.grenade_crate.action_text_id
	self.grenade_crate_small.interact_distance = self.POWERUP_INTERACTION_DISTANCE
	self.grenade_crate_big = {}
	self.grenade_crate_big.icon = self.grenade_crate.icon
	self.grenade_crate_big.text_id = self.grenade_crate.text_id
	self.grenade_crate_big.contour = self.grenade_crate.contour
	self.grenade_crate_big.blocked_hint = self.grenade_crate.blocked_hint
	self.grenade_crate_big.blocked_hint_sound = self.grenade_crate.blocked_hint_sound
	self.grenade_crate_big.sound_start = self.grenade_crate.sound_start
	self.grenade_crate_big.sound_interupt = self.grenade_crate.sound_interupt
	self.grenade_crate_big.sound_done = self.grenade_crate.sound_done
	self.grenade_crate_big.action_text_id = self.grenade_crate.action_text_id
	self.grenade_crate_big.interact_distance = self.POWERUP_INTERACTION_DISTANCE
	self.ammo_bag = {}
	self.ammo_bag.icon = "equipment_ammo_bag"
	self.ammo_bag.text_id = "hud_interact_ammo_bag_take_ammo"
	self.ammo_bag.contour = "deployable"
	self.ammo_bag.blocked_hint = "hint_full_ammo"
	self.ammo_bag.blocked_hint_sound = "no_more_ammo"
	self.ammo_bag.action_text_id = "hud_action_taking_ammo"
	self.ammo_bag.interact_distance = self.POWERUP_INTERACTION_DISTANCE
	self.ammo_bag_small = {}
	self.ammo_bag_small.icon = self.ammo_bag.icon
	self.ammo_bag_small.text_id = self.ammo_bag.text_id
	self.ammo_bag_small.contour = self.ammo_bag.contour
	self.ammo_bag_small.blocked_hint = self.ammo_bag.blocked_hint
	self.ammo_bag_small.blocked_hint_sound = self.ammo_bag.blocked_hint_sound
	self.ammo_bag_small.sound_start = self.ammo_bag.sound_start
	self.ammo_bag_small.sound_interupt = self.ammo_bag.sound_interupt
	self.ammo_bag_small.sound_done = self.ammo_bag.sound_done
	self.ammo_bag_small.action_text_id = self.ammo_bag.action_text_id
	self.ammo_bag_small.interact_distance = self.POWERUP_INTERACTION_DISTANCE
	self.ammo_bag_big = {}
	self.ammo_bag_big.icon = self.ammo_bag.icon
	self.ammo_bag_big.text_id = self.ammo_bag.text_id
	self.ammo_bag_big.contour = self.ammo_bag.contour
	self.ammo_bag_big.blocked_hint = self.ammo_bag.blocked_hint
	self.ammo_bag_big.blocked_hint_sound = self.ammo_bag.blocked_hint_sound
	self.ammo_bag_big.sound_start = self.ammo_bag.sound_start
	self.ammo_bag_big.sound_interupt = self.ammo_bag.sound_interupt
	self.ammo_bag_big.sound_done = self.ammo_bag.sound_done
	self.ammo_bag_big.action_text_id = self.ammo_bag.action_text_id
	self.ammo_bag_big.interact_distance = self.POWERUP_INTERACTION_DISTANCE
	self.health_bag = {
		action_text_id = "hud_action_healing",
		blocked_hint = "hint_full_health",
		blocked_hint_sound = "no_more_health",
		contour = "deployable",
		icon = "equipment_doctor_bag",
		interact_distance = self.POWERUP_INTERACTION_DISTANCE,
		text_id = "hud_interact_doctor_bag_heal",
	}
	self.health_bag_small = clone(self.health_bag)
	self.health_bag_big = clone(self.health_bag)
	self.health_bag_big.text_id = "hud_interact_hold_doctor_bag_heal"
	self.health_bag_big.timer = 0.2
	self.resupply_all_equipment = {}
	self.resupply_all_equipment.start_active = true
	self.resupply_all_equipment.keep_active = true
	self.resupply_all_equipment.icon = self.ammo_bag_big.icon
	self.resupply_all_equipment.text_id = "hud_interact_resupply_all"
	self.resupply_all_equipment.contour = self.ammo_bag_big.contour
	self.resupply_all_equipment.timer = 0.5
	self.resupply_all_equipment.blocked_hint = self.ammo_bag_big.blocked_hint
	self.resupply_all_equipment.blocked_hint_sound = self.ammo_bag_big.blocked_hint_sound
	self.resupply_all_equipment.sound_start = self.ammo_bag_big.sound_start
	self.resupply_all_equipment.sound_interupt = self.ammo_bag_big.sound_interupt
	self.resupply_all_equipment.sound_done = self.ammo_bag_big.sound_done
	self.resupply_all_equipment.action_text_id = self.ammo_bag_big.action_text_id
	self.resupply_all_equipment.interact_distance = self.POWERUP_INTERACTION_DISTANCE
	self.empty_interaction = {}
	self.empty_interaction.interact_distance = 0
	self.driving_drive = {}
	self.driving_drive.icon = "develop"
	self.driving_drive.text_id = "hud_int_driving_drive"
	self.driving_drive.timer = 1
	self.driving_drive.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.driving_drive.interact_distance = 500
	self.driving_willy = {}
	self.driving_willy.icon = "develop"
	self.driving_willy.text_id = "hud_int_driving_drive"
	self.driving_willy.timer = 1
	self.driving_willy.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.driving_willy.interact_distance = 200
	self.foxhole = {}
	self.foxhole.icon = "develop"
	self.foxhole.text_id = "hud_int_enter_foxhole"
	self.foxhole.timer = 1
	self.foxhole.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.foxhole.interact_distance = 500
	self.foxhole.sound_start = "cvy_foxhole_start"
	self.foxhole.sound_interupt = "cvy_foxhole_cancel"
	self.foxhole.sound_done = "cvy_foxhole_finish"
	self.main_menu_select_interaction = {}
	self.main_menu_select_interaction.text_id = "hud_menu_crate_select"
	self.main_menu_select_interaction.interact_distance = 300
	self.main_menu_select_interaction.sound_done = "paper_shuffle"
	self.interaction_ball = {}
	self.interaction_ball.icon = "develop"
	self.interaction_ball.text_id = "debug_interact_interaction_ball"
	self.interaction_ball.timer = 5
	self.interaction_ball.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.interaction_ball.sound_start = "cft_hose_loop"
	self.interaction_ball.sound_interupt = "cft_hose_cancel"
	self.interaction_ball.sound_done = "cft_hose_end"
	self.invisible_interaction_open = {}
	self.invisible_interaction_open.icon = "develop"
	self.invisible_interaction_open.text_id = "hud_int_invisible_interaction_open"
	self.invisible_interaction_open.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.invisible_interaction_open.timer = 0.5
	self.sewer_manhole = {}
	self.sewer_manhole.icon = "develop"
	self.sewer_manhole.text_id = "debug_interact_sewer_manhole"
	self.sewer_manhole.timer = 3
	self.sewer_manhole.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.sewer_manhole.start_active = false
	self.sewer_manhole.interact_distance = 200
	self.sewer_manhole.equipment_text_id = "hud_interact_equipment_crowbar"
	self.open_trunk = {}
	self.open_trunk.icon = "develop"
	self.open_trunk.text_id = "debug_interact_open_trunk"
	self.open_trunk.timer = 0.5
	self.open_trunk.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_trunk.axis = "x"
	self.open_trunk.action_text_id = "hud_action_opening_trunk"
	self.open_trunk.sound_start = "truck_back_door_opening"
	self.open_trunk.sound_done = "truck_back_door_open"
	self.open_trunk.sound_interupt = "stop_truck_back_door_opening"
	self.take_gold_bar = {}
	self.take_gold_bar.icon = "interaction_gold"
	self.take_gold_bar.text_id = "hud_take_gold_bar"
	self.take_gold_bar.start_active = true
	self.take_gold_bar.sound_done = "gold_crate_drop"
	self.take_gold_bar.timer = self.INTERACT_TIMER_CARRY / 4
	self.take_gold_bar.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_gold_bar_bag = {}
	self.take_gold_bar_bag.icon = "develop"
	self.take_gold_bar_bag.text_id = "hud_take_gold_bar"
	self.take_gold_bar_bag.action_text_id = "hud_action_taking_gold_bar"
	self.take_gold_bar_bag.timer = self.INTERACT_TIMER_CARRY / 4
	self.take_gold_bar_bag.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_gold_bar_bag.force_update_position = true
	self.take_gold_bar_bag.sound_start = "gold_crate_pickup"
	self.take_gold_bar_bag.sound_interupt = "gold_crate_drop"
	self.take_gold_bar_bag.sound_done = "gold_crate_drop"
	self.gold_bag = {}
	self.gold_bag.icon = "interaction_gold"
	self.gold_bag.text_id = "debug_interact_gold_bag"
	self.gold_bag.start_active = false
	self.gold_bag.timer = self.INTERACT_TIMER_CARRY
	self.gold_bag.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.gold_bag.special_equipment_block = "gold_bag_equip"
	self.gold_bag.action_text_id = "hud_action_taking_gold"
	self.requires_gold_bag = {}
	self.requires_gold_bag.icon = "interaction_gold"
	self.requires_gold_bag.text_id = "debug_interact_requires_gold_bag"
	self.requires_gold_bag.equipment_text_id = "debug_interact_equipment_requires_gold_bag"
	self.requires_gold_bag.special_equipment = "gold_bag_equip"
	self.requires_gold_bag.start_active = true
	self.requires_gold_bag.equipment_consume = true
	self.requires_gold_bag.timer = self.INTERACT_TIMER_CARRY
	self.requires_gold_bag.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.requires_gold_bag.axis = "x"
	self.break_open = {}
	self.break_open.icon = "develop"
	self.break_open.text_id = "hud_int_break_open"
	self.break_open.start_active = false
	self.cut_fence = {}
	self.cut_fence.text_id = "hud_int_hold_cut_fence"
	self.cut_fence.action_text_id = "hud_action_cutting_fence"
	self.cut_fence.timer = self.INTERACT_TIMER_SHORT
	self.cut_fence.dot_limit = 0.8
	self.cut_fence.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.cut_fence.start_active = true
	self.cut_fence.sound_start = "bar_cut_fence"
	self.cut_fence.sound_interupt = "bar_cut_fence_cancel"
	self.cut_fence.sound_done = "bar_cut_fence_finished"
	self.use_flare = {}
	self.use_flare.text_id = "hud_int_use_flare"
	self.use_flare.start_active = false
	self.use_flare.dot_limit = 0.8
	self.use_flare.timer = self.INTERACT_TIMER_SHORT
	self.use_flare.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.disable_flare = deep_clone(self.use_flare)
	self.disable_flare.text_id = "hud_int_disable_flare"
	self.extinguish_flare = deep_clone(self.use_flare)
	self.extinguish_flare.text_id = "hud_int_estinguish_flare"
	self.extinguish_flare.contour = "interactable_danger"
	self.open_from_inside = {}
	self.open_from_inside.text_id = "hud_int_invisible_interaction_open"
	self.open_from_inside.start_active = true
	self.open_from_inside.interact_distance = 100
	self.open_from_inside.timer = self.INTERACT_TIMER_SHORT
	self.open_from_inside.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_from_inside.axis = "x"
	self.gen_pku_crowbar = {}
	self.gen_pku_crowbar.text_id = "hud_int_take_crowbar"
	self.gen_pku_crowbar.special_equipment_block = "crowbar"
	self.gen_pku_crowbar.sound_done = "crowbar_pickup"
	self.crate_loot = {}
	self.crate_loot.text_id = "hud_int_hold_crack_crate"
	self.crate_loot.action_text_id = "hud_action_cracking_crate"
	self.crate_loot.timer = self.INTERACT_TIMER_VERY_SHORT
	self.crate_loot.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.crate_loot.start_active = false
	self.crate_loot.sound_start = "bar_open_crate"
	self.crate_loot.sound_interupt = "bar_open_crate_cancel"
	self.crate_loot.sound_done = "bar_open_crate_finished"
	self.crate_loot_crowbar = deep_clone(self.crate_loot)
	self.crate_loot_crowbar.equipment_text_id = "hud_interact_equipment_crowbar"
	self.crate_loot_crowbar.special_equipment = "crowbar"
	self.crate_loot_crowbar.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CROWBAR
	self.crate_loot_crowbar.sound_start = "bar_crowbar"
	self.crate_loot_crowbar.sound_interupt = "bar_crowbar_cancel"
	self.crate_loot_crowbar.sound_done = "bar_crowbar_end"
	self.crate_loot_crowbar.start_active = true
	self.crate_loot_close = {}
	self.crate_loot_close.text_id = "hud_int_hold_close_crate"
	self.crate_loot_close.action_text_id = "hud_action_closing_crate"
	self.crate_loot_close.timer = self.INTERACT_TIMER_VERY_SHORT
	self.crate_loot_close.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.crate_loot_close.start_active = false
	self.crate_loot_close.sound_start = "bar_close_crate"
	self.crate_loot_close.sound_interupt = "bar_close_crate_cancel"
	self.crate_loot_close.sound_done = "bar_close_crate_finished"
	self.player_zipline = {}
	self.player_zipline.text_id = "hud_int_use_zipline"
	self.bag_zipline = {}
	self.bag_zipline.text_id = "hud_int_bag_zipline"
	self.crane_joystick_lift = {}
	self.crane_joystick_lift.text_id = "hud_int_crane_lift"
	self.crane_joystick_lift.start_active = false
	self.crane_joystick_right = {}
	self.crane_joystick_right.text_id = "hud_int_crane_right"
	self.crane_joystick_right.start_active = false
	self.crane_joystick_release = {}
	self.crane_joystick_release.text_id = "hud_int_crane_release"
	self.crane_joystick_release.start_active = false
	self.take_bank_door_keys = {}
	self.take_bank_door_keys.start_active = true
	self.take_bank_door_keys.text_id = "hud_int_take_door_keys"
	self.hold_unlock_bank_door = {}
	self.hold_unlock_bank_door.text_id = "hud_int_hold_unlock_door"
	self.hold_unlock_bank_door.action_text_id = "hud_int_action_unlocking_door"
	self.hold_unlock_bank_door.special_equipment = "door_key"
	self.hold_unlock_bank_door.equipment_text_id = "hud_int_need_door_keys"
	self.hold_unlock_bank_door.timer = self.INTERACT_TIMER_MEDIUM
	self.hold_unlock_bank_door.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_unlock_bank_door.equipment_consume = false
	self.hold_unlock_bank_door.start_active = false
	self.take_car_keys = {}
	self.take_car_keys.text_id = "hud_int_take_car_keys"
	self.take_car_keys.sound_done = "sps_inter_keys_pickup"
	self.unlock_car_01 = {}
	self.unlock_car_01.text_id = "hud_int_hold_unlock_car"
	self.unlock_car_01.action_text_id = "hud_unlocking_car"
	self.unlock_car_01.special_equipment = "car_key_01"
	self.unlock_car_01.equipment_text_id = "hud_int_need_car_keys"
	self.unlock_car_01.equipment_consume = true
	self.unlock_car_01.start_active = false
	self.unlock_car_01.timer = 2
	self.unlock_car_01.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.unlock_car_01.sound_start = "sps_inter_unlock_truck_start_loop"
	self.unlock_car_01.sound_interupt = "sps_inter_unlock_truck_stop_loop"
	self.unlock_car_01.sound_done = "sps_inter_unlock_truck_success"
	self.unlock_car_02 = deep_clone(self.unlock_car_01)
	self.unlock_car_02.special_equipment = "car_key_02"
	self.unlock_car_02.sound_start = "sps_inter_unlock_truck_start_loop"
	self.unlock_car_02.sound_interupt = "sps_inter_unlock_truck_stop_loop"
	self.unlock_car_02.sound_done = "sps_inter_unlock_truck_success"
	self.unlock_car_03 = deep_clone(self.unlock_car_01)
	self.unlock_car_03.special_equipment = "car_key_03"
	self.unlock_car_03.sound_start = "sps_inter_unlock_truck_start_loop"
	self.unlock_car_03.sound_interupt = "sps_inter_unlock_truck_stop_loop"
	self.unlock_car_03.sound_done = "sps_inter_unlock_truck_success"
	self.push_button = {}
	self.push_button.text_id = "hud_int_push_button"
	self.push_button.axis = "z"
	self.search_files_false = {}
	self.search_files_false.text_id = "hud_int_search_files"
	self.search_files_false.action_text_id = "hud_action_searching_files"
	self.search_files_false.axis = "x"
	self.search_files_false.contour = "interactable_icon"
	self.search_files_false.timer = 4.5
	self.search_files_false.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.search_files_false.interact_distance = 200
	self.search_files_false.sound_start = "bar_shuffle_papers"
	self.search_files_false.sound_interupt = "bar_shuffle_papers_cancel"
	self.search_files_false.sound_done = "bar_shuffle_papers_finished"
	self.hold_open = {}
	self.hold_open.text_id = "hud_int_invisible_interaction_open"
	self.hold_open.action_text_id = "hud_action_open_slash_close"
	self.hold_open.start_active = false
	self.hold_open.axis = "y"
	self.hold_open.timer = self.INTERACT_TIMER_SHORT
	self.hold_open.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.place_flare = {}
	self.place_flare.text_id = "hud_int_place_flare"
	self.place_flare.start_active = false
	self.place_flare.dot_limit = self.INTERACT_TIMER_VERY_SHORT
	self.place_flare.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.answer_call = {}
	self.answer_call.text_id = "hud_int_hold_answer_call"
	self.answer_call.action_text_id = "hud_action_answering_call"
	self.answer_call.timer = 0.5
	self.answer_call.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.answer_call.start_active = false
	self.cas_take_unknown = {}
	self.cas_take_unknown.text_id = "hud_take_???"
	self.cas_take_unknown.action_text_id = "hud_action_taking_???"
	self.cas_take_unknown.timer = 2
	self.cas_take_unknown.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.cas_take_unknown.interact_distance = 100
	self.cas_take_unknown.start_active = false
	self.hold_pku_intelligence = {}
	self.hold_pku_intelligence.text_id = "hud_int_pickup_intelligence"
	self.hold_pku_intelligence.action_text_id = "hud_action_pickup_intelligence"
	self.hold_pku_intelligence.timer = self.INTERACT_TIMER_VERY_SHORT
	self.hold_pku_intelligence.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_pku_intelligence.interact_distance = 150
	self.piano_key_instant_01 = {}
	self.piano_key_instant_01.text_id = "hud_play_key_01"
	self.piano_key_instant_01.interact_distance = self.SMALL_OBJECT_INTERACTION_DISTANCE
	self.piano_key_instant_01.contour = "interactable_look_at"
	self.piano_key_instant_02 = {}
	self.piano_key_instant_02.text_id = "hud_play_key_02"
	self.piano_key_instant_02.interact_distance = self.SMALL_OBJECT_INTERACTION_DISTANCE
	self.piano_key_instant_02.contour = "interactable_look_at"
	self.piano_key_instant_03 = {}
	self.piano_key_instant_03.text_id = "hud_play_key_03"
	self.piano_key_instant_03.interact_distance = self.SMALL_OBJECT_INTERACTION_DISTANCE
	self.piano_key_instant_03.contour = "interactable_look_at"
	self.piano_key_instant_04 = {}
	self.piano_key_instant_04.text_id = "hud_play_key_04"
	self.piano_key_instant_04.interact_distance = self.SMALL_OBJECT_INTERACTION_DISTANCE
	self.piano_key_instant_04.contour = "interactable_look_at"
	self.open_door_instant = {}
	self.open_door_instant.text_id = "hud_open_door_instant"
	self.open_door_instant.interact_distance = 200
	self.open_door_instant.sound_done = "door_open_generic"
	self.hold_open_crate_tut = {}
	self.hold_open_crate_tut.text_id = "hud_int_hold_get_gear"
	self.hold_open_crate_tut.action_text_id = "hud_action_get_gear"
	self.hold_open_crate_tut.timer = self.INTERACT_TIMER_SHORT
	self.hold_open_crate_tut.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_open_crate_tut.start_active = false
	self.hold_open_crate_tut.interact_distance = 300
	self.hold_open_crate_tut.dot_limit = 0.8
	self.hold_open_crate_tut.sound_start = "camp_unpack_stuff"
	self.hold_open_crate_tut.sound_done = "camp_unpacked"
	self.open_crate_1 = {}
	self.open_crate_1.text_id = "hud_open_crate_2"
	self.open_crate_1.action_text_id = "hud_action_opening_crate_2"
	self.open_crate_1.interact_distance = 200
	self.open_crate_1.timer = self.INTERACT_TIMER_INSTA
	self.open_crate_1.start_active = true
	self.open_crate_1.loot_table = {
		"basic_crate_tier",
	}
	self.open_crate_1.sound_done = "crate_open"
	self.open_crate_1.delay_completed = 0.34
	self.open_crate_1.redirect = Idstring("melee")
	self.open_crate_2 = deep_clone(self.open_crate_1)
	self.open_crate_2.loot_table = {
		"lockpick_crate_tier",
	}
	self.open_crate_2.redirect = nil
	self.open_crate_2.timer = self.INTERACT_TIMER_INSTA
	self.open_crate_2.legend_exit_text_id = "hud_legend_lockpicking_exit"
	self.open_crate_2.legend_interact_text_id = "hud_legend_lockpicking_interact"
	self.open_crate_2.minigame_bypass = {
		category = "interaction",
		special_equipment = "crowbar",
		upgrade = "sapper_lockpick_crate_bypass",
	}
	self.open_crate_2.timer = self.INTERACT_TIMER_VERY_SHORT
	self.open_crate_2.minigame_type = self.MINIGAME_PICK_LOCK
	self.open_crate_2.number_of_circles = 1
	self.open_crate_2.circle_rotation_speed = {
		240,
	}
	self.open_crate_2.circle_rotation_direction = {
		1,
	}
	self.open_crate_2.circle_difficulty = {
		0.85,
	}
	self.open_crate_2.sounds = self.LOCKPICK_SOUNDS
	self.open_crate_2.sound_start = "crowbarcrate_open"
	self.open_crate_2.sound_done = "crate_open"
	self.open_crate_2.sound_interupt = "stop_crowbarcrate_open"
	self.open_army_crate = {}
	self.open_army_crate.text_id = "hud_open_army_crate"
	self.open_army_crate.action_text_id = "hud_action_opening_army_crate"
	self.open_army_crate.special_equipment = "crowbar"
	self.open_army_crate.equipment_text_id = "hud_int_need_crowbar"
	self.open_army_crate.equipment_consume = false
	self.open_army_crate.start_active = false
	self.open_army_crate.interact_distance = 250
	self.open_army_crate.timer = self.INTERACT_TIMER_SHORT
	self.open_army_crate.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CROWBAR
	self.open_army_crate.loot_table = {
		"crowbar_crate_tier",
	}
	self.open_army_crate.sound_start = "crowbarcrate_open"
	self.open_army_crate.sound_done = "crate_open"
	self.open_army_crate.sound_interupt = "stop_crowbarcrate_open"
	self.open_crate_3 = deep_clone(self.open_army_crate)
	self.open_metalbox = {}
	self.open_metalbox.text_id = "hud_open_crate_2"
	self.open_metalbox.action_text_id = "hud_action_opening_crate_2"
	self.open_metalbox.interact_distance = 300
	self.open_metalbox.start_active = false
	self.take_document = {}
	self.take_document.text_id = "hud_take_document"
	self.take_document.interact_distance = 300
	self.take_document.start_active = true
	self.take_document.sound_done = "paper_shuffle"
	self.take_documents = {}
	self.take_documents.text_id = "hud_take_documents"
	self.take_documents.timer = self.INTERACT_TIMER_VERY_SHORT
	self.take_documents.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_documents.interact_distance = 300
	self.take_documents.start_active = true
	self.take_documents.sound_done = "paper_shuffle"
	self.open_window = {}
	self.open_window.text_id = "hud_open_window"
	self.open_window.action_text_id = "hud_action_opening_window"
	self.open_window.interact_distance = 300
	self.open_window.timer = self.INTERACT_TIMER_SHORT
	self.open_window.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_window.axis = "y"
	self.open_window.start_active = false
	self.take_thermite = {}
	self.take_thermite.text_id = "hud_take_thermite"
	self.take_thermite.action_text_id = "hud_action_taking_thermite"
	self.take_thermite.special_equipment_block = "thermite"
	self.take_thermite.timer = self.INTERACT_TIMER_SHORT
	self.take_thermite.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_thermite.start_active = true
	self.take_thermite.sound_event = "cvy_pick_up_thermite"
	self.set_up_radio = {}
	self.set_up_radio.text_id = "hud_int_set_up_radio"
	self.set_up_radio.action_text_id = "hud_action_set_up_radio"
	self.set_up_radio.timer = self.INTERACT_TIMER_MEDIUM
	self.set_up_radio.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.set_up_radio.start_active = false
	self.anwser_radio = {}
	self.anwser_radio.text_id = "hud_int_answer_radio"
	self.anwser_radio.action_text_id = "hud_action_answering_radio"
	self.anwser_radio.timer = self.INTERACT_TIMER_VERY_SHORT
	self.anwser_radio.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.anwser_radio.start_active = false
	self.tune_radio = deep_clone(self.anwser_radio)
	self.tune_radio.text_id = "hud_sii_tune_radio"
	self.tune_radio.action_text_id = "hud_action_sii_tune_radio"
	self.tune_radio.timer = self.INTERACT_TIMER_MEDIUM
	self.tune_radio.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.untie_zeppelin = {}
	self.untie_zeppelin.text_id = "hud_untie_zeppelin"
	self.untie_zeppelin.action_text_id = "hud_action_untying_zeppelin"
	self.untie_zeppelin.interact_distance = 300
	self.untie_zeppelin.timer = self.INTERACT_TIMER_LONG
	self.untie_zeppelin.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.untie_zeppelin.start_active = false
	self.take_tank_grenade = {}
	self.take_tank_grenade.text_id = "hud_take_tank_grenade"
	self.take_tank_grenade.action_text_id = "hud_action_taking_tank_grenade"
	self.take_tank_grenade.special_equipment_block = "tank_grenade"
	self.take_tank_grenade.timer = self.INTERACT_TIMER_SHORT
	self.take_tank_grenade.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_tank_grenade.start_active = true
	self.replace_tank_grenade = {}
	self.replace_tank_grenade.text_id = "hud_replace_tank_grenade"
	self.replace_tank_grenade.action_text_id = "hud_action_replacing_tank_grenade"
	self.replace_tank_grenade.special_equipment = "tank_grenade"
	self.replace_tank_grenade.equipment_text_id = "hud_no_tank_grenade"
	self.replace_tank_grenade.equipment_consume = true
	self.replace_tank_grenade.start_active = false
	self.replace_tank_grenade.timer = self.INTERACT_TIMER_SHORT
	self.replace_tank_grenade.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_tools = {}
	self.take_tools.text_id = "hud_take_tools"
	self.take_tools.action_text_id = "hud_action_taking_tools"
	self.take_tools.special_equipment_block = "repair_tools"
	self.take_tools.timer = self.INTERACT_TIMER_SHORT
	self.take_tools.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_tools.start_active = true
	self.take_tools.sound_done = "pickup_tools"
	self.take_gas_tank = {}
	self.take_gas_tank.text_id = "hud_take_gas_tank"
	self.take_gas_tank.action_text_id = "hud_action_taking_gas_tank"
	self.take_gas_tank.special_equipment_block = "gas_tank"
	self.take_gas_tank.timer = self.INTERACT_TIMER_SHORT
	self.take_gas_tank.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_gas_tank.start_active = true
	self.hold_remove_latch = {}
	self.hold_remove_latch.text_id = "hud_int_remove_latch"
	self.hold_remove_latch.action_text_id = "hud_action_remove_latch"
	self.hold_remove_latch.timer = self.INTERACT_TIMER_MEDIUM
	self.hold_remove_latch.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_remove_latch.start_active = false
	self.hold_remove_latch.axis = "y"
	self.replace_gas_tank = {}
	self.replace_gas_tank.text_id = "hud_replace_gas_tank"
	self.replace_gas_tank.action_text_id = "hud_action_replacing_gas_tank"
	self.replace_gas_tank.special_equipment = "gas_tank"
	self.replace_gas_tank.equipment_text_id = "hud_no_gas_tank"
	self.replace_gas_tank.timer = self.INTERACT_TIMER_MEDIUM
	self.replace_gas_tank.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.replace_gas_tank.equipment_consume = true
	self.replace_gas_tank.start_active = false
	self.open_toolbox = {}
	self.open_toolbox.text_id = "hud_open_toolbox"
	self.open_toolbox.action_text_id = "hud_action_opening_toolbox"
	self.open_toolbox.start_active = false
	self.open_toolbox.timer = self.INTERACT_TIMER_VERY_SHORT
	self.open_toolbox.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_toolbox.interact_distance = 300
	self.open_toolbox.sound_start = "toolbox_interact_start"
	self.open_toolbox.sound_done = "toolbox_interact_stop"
	self.open_toolbox.sound_interupt = "toolbox_interact_stop"
	self.take_safe_key = {}
	self.take_safe_key.text_id = "hud_take_safe_key"
	self.take_safe_key.special_equipment_block = "safe_key"
	self.take_safe_key.interact_distance = 300
	self.take_safe_key.start_active = true
	self.take_safe_key.sound_done = "sto_pick_up_key"
	self.unlock_the_safe = {}
	self.unlock_the_safe.text_id = "hud_unlock_safe"
	self.unlock_the_safe.action_text_id = "hud_action_unlocking_safe"
	self.unlock_the_safe.special_equipment = "safe_key"
	self.unlock_the_safe.equipment_text_id = "hud_no_safe_key"
	self.unlock_the_safe.timer = self.INTERACT_TIMER_MEDIUM
	self.unlock_the_safe.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.unlock_the_safe.equipment_consume = true
	self.unlock_the_safe.start_active = false
	self.pour_acid = {}
	self.pour_acid.text_id = "hud_pour_acid"
	self.pour_acid.action_text_id = "hud_action_pouring_acid"
	self.pour_acid.special_equipment = "acid"
	self.pour_acid.equipment_text_id = "hud_int_need_acid"
	self.pour_acid.timer = self.INTERACT_TIMER_MEDIUM
	self.pour_acid.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pour_acid.equipment_consume = true
	self.pour_acid.start_active = false
	self.take_acid = {}
	self.take_acid.text_id = "hud_take_acid"
	self.take_acid.action_text_id = "hud_action_taking_acid"
	self.take_acid.special_equipment_block = "acid"
	self.take_acid.timer = self.INTERACT_TIMER_SHORT
	self.take_acid.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_acid.start_active = true
	self.take_sps_briefcase = {}
	self.take_sps_briefcase.text_id = "hud_take_briefcase"
	self.take_sps_briefcase.action_text_id = "hud_action_taking_briefcase"
	self.take_sps_briefcase.special_equipment_block = "briefcase"
	self.take_sps_briefcase.timer = self.INTERACT_TIMER_SHORT
	self.take_sps_briefcase.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_sps_briefcase.start_active = true
	self.take_sps_briefcase.sound_done = "sps_pick_up_briefcase"
	self.take_thermite = {}
	self.take_thermite.text_id = "hud_int_take_thermite"
	self.take_thermite.special_equipment_block = "thermite"
	self.take_thermite.start_active = true
	self.take_thermite.sound_event = "cvy_pick_up_thermite"
	self.open_lid = {}
	self.open_lid.text_id = "hud_int_open_lid"
	self.open_lid.start_active = true
	self.open_lid.sound_event = "brh_holding_cells_door_lid"
	self.pku_codemachine_part_01 = {}
	self.pku_codemachine_part_01.text_id = "hud_take_codemachine_part_01"
	self.pku_codemachine_part_01.action_text_id = "hud_action_taking_codemachine_part_01"
	self.pku_codemachine_part_01.timer = self.INTERACT_TIMER_SHORT
	self.pku_codemachine_part_01.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pku_codemachine_part_01.start_active = true
	self.pku_codemachine_part_02 = {}
	self.pku_codemachine_part_02.text_id = "hud_take_codemachine_part_02"
	self.pku_codemachine_part_02.action_text_id = "hud_action_taking_codemachine_part_03"
	self.pku_codemachine_part_02.timer = self.INTERACT_TIMER_SHORT
	self.pku_codemachine_part_02.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pku_codemachine_part_02.start_active = true
	self.pku_codemachine_part_03 = {}
	self.pku_codemachine_part_03.text_id = "hud_take_codemachine_part_03"
	self.pku_codemachine_part_03.action_text_id = "hud_action_taking_codemachine_part_03"
	self.pku_codemachine_part_03.timer = self.INTERACT_TIMER_SHORT
	self.pku_codemachine_part_03.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pku_codemachine_part_03.start_active = true
	self.pku_codemachine_part_04 = {}
	self.pku_codemachine_part_04.text_id = "hud_take_codemachine_part_04"
	self.pku_codemachine_part_04.action_text_id = "hud_action_taking_codemachine_part_04"
	self.pku_codemachine_part_04.timer = self.INTERACT_TIMER_SHORT
	self.pku_codemachine_part_04.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pku_codemachine_part_04.start_active = true
	self.take_gold_bar_mold = {}
	self.take_gold_bar_mold.text_id = "hud_take_gold_bar_mold"
	self.take_gold_bar_mold.action_text_id = "hud_action_taking_gold_bar_mold"
	self.take_gold_bar_mold.timer = self.INTERACT_TIMER_SHORT
	self.take_gold_bar_mold.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_gold_bar_mold.special_equipment_block = "gold_bar_mold"
	self.take_gold_bar_mold.start_active = true
	self.place_mold = {}
	self.place_mold.text_id = "hud_place_mold"
	self.place_mold.action_text_id = "hud_action_placing_mold"
	self.place_mold.special_equipment = "gold_bar_mold"
	self.place_mold.equipment_text_id = "hud_int_need_gold_bar_mold"
	self.place_mold.timer = self.INTERACT_TIMER_SHORT
	self.place_mold.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.place_mold.equipment_consume = true
	self.place_mold.start_active = false
	self.place_tank_shell = {}
	self.place_tank_shell.text_id = "hud_place_tank_shell"
	self.place_tank_shell.action_text_id = "hud_action_placing_tank_shell"
	self.place_tank_shell.special_equipment = "tank_shell"
	self.place_tank_shell.equipment_text_id = "hud_int_need_tank_shell"
	self.place_tank_shell.timer = self.INTERACT_TIMER_MEDIUM
	self.place_tank_shell.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.place_tank_shell.equipment_consume = true
	self.place_tank_shell.start_active = false
	self.graveyard_check_tank = {}
	self.graveyard_check_tank.text_id = "hud_graveyard_check_tank"
	self.graveyard_check_tank.action_text_id = "hud_action_graveyard_check_tank"
	self.graveyard_check_tank.timer = self.INTERACT_TIMER_MEDIUM
	self.graveyard_check_tank.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.graveyard_check_tank.start_active = true
	self.graveyard_check_tank.special_equipment_block = "gold_bar_mold"
	self.graveyard_drag_pilot_1 = {}
	self.graveyard_drag_pilot_1.text_id = "hud_graveyard_drag_pilot_1"
	self.graveyard_drag_pilot_1.action_text_id = "hud_action_graveyard_drag_pilot_1"
	self.graveyard_drag_pilot_1.timer = self.INTERACT_TIMER_MEDIUM
	self.graveyard_drag_pilot_1.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.graveyard_drag_pilot_1.start_active = true
	self.graveyard_drag_pilot_1.special_equipment_block = "gold_bar_mold"
	self.search_radio_parts = {}
	self.search_radio_parts.text_id = "hud_search_radio_parts"
	self.search_radio_parts.action_text_id = "hud_action_searching_radio_parts"
	self.search_radio_parts.timer = self.INTERACT_TIMER_MEDIUM
	self.search_radio_parts.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.search_radio_parts.start_active = false
	self.search_radio_parts.special_equipment_block = "radio_parts"
	self.replace_radio_parts = {}
	self.replace_radio_parts.text_id = "hud_replace_radio_parts"
	self.replace_radio_parts.action_text_id = "hud_action_replacing_radio_parts"
	self.replace_radio_parts.special_equipment = "radio_parts"
	self.replace_radio_parts.equipment_text_id = "hud_int_need_radio_parts"
	self.replace_radio_parts.timer = self.INTERACT_TIMER_MEDIUM
	self.replace_radio_parts.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.replace_radio_parts.equipment_consume = true
	self.replace_radio_parts.start_active = false
	self.take_blacksmith_tong = {}
	self.take_blacksmith_tong.text_id = "hud_take_blacksmith_tong"
	self.take_blacksmith_tong.start_active = false
	self.take_blacksmith_tong.special_equipment_block = "blacksmith_tong"
	self.turret_m2 = {}
	self.turret_m2.text_id = "hud_turret_m2"
	self.turret_m2.action_text_id = "hud_action_mounting_turret"
	self.turret_m2.timer = self.INTERACT_TIMER_VERY_SHORT
	self.turret_m2.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.turret_m2.start_active = true
	self.turret_m2.sound_start = "turret_pick_up"
	self.turret_m2.sound_interupt = "turret_pick_up_stop"
	self.turret_m2.axis = "x"
	self.turret_m2_placement = {}
	self.turret_m2_placement.text_id = "hud_turret_placement"
	self.turret_m2_placement.action_text_id = "hud_action_placing_turret"
	self.turret_m2_placement.timer = self.INTERACT_TIMER_MEDIUM
	self.turret_m2_placement.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.turret_m2_placement.start_active = true
	self.turret_m2_placement.carry_consume = true
	self.turret_m2_placement.required_carry = "turret_m2_gun"
	self.turret_m2_placement.carry_text_id = "needs_carry_turret_m2_gun"
	self.turret_m2_placement.sound_start = "turret_pick_up"
	self.turret_m2_placement.sound_interupt = "turret_pick_up_stop"
	self.turret_m2_placement.axis = "x"
	self.turret_flak_88 = {}
	self.turret_flak_88.text_id = "hud_turret_88"
	self.turret_flak_88.action_text_id = "hud_action_mounting_turret"
	self.turret_flak_88.timer = self.INTERACT_TIMER_SHORT
	self.turret_flak_88.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.turret_flak_88.start_active = false
	self.turret_flak_88.sound_start = "turret_pick_up"
	self.turret_flak_88.sound_interupt = "turret_pick_up_stop"
	self.turret_flak_88.interact_distance = 400
	self.turret_flak_88.axis = "z"
	self.turret_flakvierling = {}
	self.turret_flakvierling.text_id = "hud_int_hold_turret_flakvierling"
	self.turret_flakvierling.action_text_id = "hud_action_turret_flakvierling"
	self.turret_flakvierling.timer = self.INTERACT_TIMER_SHORT
	self.turret_flakvierling.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.turret_flakvierling.start_active = true
	self.turret_flakvierling.sound_start = "turret_pick_up"
	self.turret_flakvierling.sound_interupt = "turret_pick_up_stop"
	self.turret_flakvierling.interact_distance = 400
	self.start_ladle = {}
	self.start_ladle.start_active = "false"
	self.start_ladle.text_id = "hud_start_ladle"
	self.stop_ladle = {}
	self.stop_ladle.start_active = "false"
	self.stop_ladle.text_id = "hud_stop_ladle"
	self.cool_gold_bar = {}
	self.cool_gold_bar.text_id = "hud_cool_gold_bar"
	self.cool_gold_bar.action_text_id = "hud_action_cooling_gold_bar"
	self.cool_gold_bar.special_equipment = "gold_bar"
	self.cool_gold_bar.equipment_text_id = "hud_int_need_gold_bar"
	self.cool_gold_bar.timer = self.INTERACT_TIMER_MEDIUM
	self.cool_gold_bar.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.cool_gold_bar.equipment_consume = true
	self.cool_gold_bar.start_active = false
	self.pour_iron = {}
	self.pour_iron.text_id = "hud_pour_iron"
	self.pour_iron.start_active = false
	self.open_chest = {}
	self.open_chest.text_id = "hud_open_chest"
	self.open_chest.action_text_id = "hud_action_opening_chest"
	self.open_chest.timer = self.INTERACT_TIMER_MEDIUM
	self.open_chest.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_chest.start_active = false
	self.open_radio_hatch = {}
	self.open_radio_hatch.text_id = "hud_open_radio_hatch"
	self.open_radio_hatch.action_text_id = "hud_action_opening_radio_hatch"
	self.open_radio_hatch.timer = self.INTERACT_TIMER_SHORT
	self.open_radio_hatch.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_radio_hatch.start_active = false
	self.open_tank_hatch = {}
	self.open_tank_hatch.text_id = "hud_open_tank_hatch"
	self.open_tank_hatch.action_text_id = "hud_action_opening_tank_hatch"
	self.open_tank_hatch.timer = self.INTERACT_TIMER_MEDIUM
	self.open_tank_hatch.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_tank_hatch.start_active = false
	self.open_hatch = {}
	self.open_hatch.text_id = "hud_open_hatch"
	self.open_hatch.action_text_id = "hud_action_opening_hatch"
	self.open_hatch.timer = self.INTERACT_TIMER_SHORT
	self.open_hatch.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_hatch.start_active = false
	self.break_open_door = {}
	self.break_open_door.text_id = "hud_break_open_door"
	self.break_open_door.action_text_id = "hud_action_breaking_opening_door"
	self.break_open_door.special_equipment = "crowbar"
	self.break_open_door.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CROWBAR
	self.break_open_door.equipment_text_id = "hud_int_need_crowbar"
	self.break_open_door.timer = self.INTERACT_TIMER_LONG
	self.break_open_door.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.break_open_door.equipment_consume = false
	self.break_open_door.start_active = false
	self.break_open_door.axis = "x"
	self.open_vault_door = {}
	self.open_vault_door.text_id = "hud_open_vault_door"
	self.open_vault_door.action_text_id = "hud_action_opening_vault_door"
	self.open_vault_door.timer = self.INTERACT_TIMER_LONG
	self.open_vault_door.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_vault_door.start_active = false
	self.breach_open_door = {}
	self.breach_open_door.text_id = "hud_breach_door"
	self.breach_open_door.action_text_id = "hud_action_breaching_door"
	self.breach_open_door.timer = self.INTERACT_TIMER_MEDIUM
	self.breach_open_door.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.breach_open_door.start_active = false
	self.take_blow_torch = {}
	self.take_blow_torch.text_id = "hud_take_blow_torch"
	self.take_blow_torch.special_equipment_block = "blow_torch"
	self.take_blow_torch.equipment_consume = false
	self.take_blow_torch.start_active = false
	self.fill_blow_torch = {}
	self.fill_blow_torch.text_id = "hud_fill_blow_torch"
	self.fill_blow_torch.action_text_id = "hud_action_filling_blow_torch"
	self.fill_blow_torch.special_equipment = "blow_torch"
	self.fill_blow_torch.special_equipment_block = "blow_torch_fuel"
	self.fill_blow_torch.equipment_text_id = "hud_int_need_blow_torch"
	self.fill_blow_torch.timer = self.INTERACT_TIMER_LONG
	self.fill_blow_torch.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.fill_blow_torch.equipment_consume = false
	self.fill_blow_torch.start_active = false
	self.cut_vault_bars = {}
	self.cut_vault_bars.text_id = "hud_cut_vault_bars"
	self.cut_vault_bars.action_text_id = "hud_action_cutting_vault_bars"
	self.cut_vault_bars.special_equipment = "blow_torch_fuel"
	self.cut_vault_bars.equipment_text_id = "hud_int_need_blow_torch_fuel"
	self.cut_vault_bars.timer = self.INTERACT_TIMER_LONG
	self.cut_vault_bars.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.cut_vault_bars.equipment_consume = true
	self.cut_vault_bars.start_active = true
	self.take_torch_tank = {}
	self.take_torch_tank.text_id = "hud_take_torch_tank"
	self.take_torch_tank.action_text_id = "hud_action_taking_torch_tank"
	self.take_torch_tank.timer = self.INTERACT_TIMER_CARRY
	self.take_torch_tank.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_torch_tank.start_active = false
	self.take_turret_m2_gun = {}
	self.take_turret_m2_gun.text_id = "hud_take_turret_m2_gun"
	self.take_turret_m2_gun.action_text_id = "hud_action_taking_turret_m2_gun"
	self.take_turret_m2_gun.timer = self.INTERACT_TIMER_CARRY
	self.take_turret_m2_gun.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_turret_m2_gun.start_active = false
	self.take_turret_m2_gun.sound_start = "turret_pick_up"
	self.take_turret_m2_gun.sound_interupt = "turret_pick_up_stop"
	self.take_turret_m2_gun_enabled = {}
	self.take_turret_m2_gun_enabled.text_id = "hud_take_turret_m2_gun"
	self.take_turret_m2_gun_enabled.action_text_id = "hud_action_taking_turret_m2_gun"
	self.take_turret_m2_gun_enabled.timer = self.INTERACT_TIMER_CARRY
	self.take_turret_m2_gun_enabled.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_turret_m2_gun_enabled.start_active = true
	self.take_turret_m2_gun_enabled.sound_start = "turret_pick_up"
	self.take_turret_m2_gun_enabled.sound_interupt = "turret_pick_up_stop"
	self.take_money_print_plate = {}
	self.take_money_print_plate.text_id = "hud_take_money_print_plate"
	self.take_money_print_plate.action_text_id = "hud_action_taking_money_print_plate"
	self.take_money_print_plate.timer = self.INTERACT_TIMER_CARRY
	self.take_money_print_plate.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_money_print_plate.start_active = false
	self.signal_light = {}
	self.signal_light.text_id = "hud_signal_light"
	self.signal_light.start_active = true
	self.signal_light.axis = "z"
	self.take_safe_keychain = {}
	self.take_safe_keychain.text_id = "hud_take_safe_keychain"
	self.take_safe_keychain.start_active = true
	self.take_safe_keychain.special_equipment_block = "safe_keychain"
	self.take_safe_keychain.equipment_consume = false
	self.unlock_the_safe_keychain = {}
	self.unlock_the_safe_keychain.text_id = "hud_unlock_safe"
	self.unlock_the_safe_keychain.action_text_id = "hud_action_unlocking_safe"
	self.unlock_the_safe_keychain.special_equipment = "safe_keychain"
	self.unlock_the_safe_keychain.equipment_text_id = "hud_no_safe_keychain"
	self.unlock_the_safe_keychain.timer = self.INTERACT_TIMER_SHORT
	self.unlock_the_safe_keychain.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.unlock_the_safe_keychain.equipment_consume = false
	self.unlock_the_safe_keychain.start_active = false
	self.take_gear = {}
	self.take_gear.text_id = "hud_take_gear"
	self.take_gear.action_text_id = "hud_action_taking_gear"
	self.take_gear.timer = self.INTERACT_TIMER_SHORT
	self.take_gear.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_gear.start_active = false
	self.take_gear.interact_distance = 250
	self.take_gear.can_interact_in_civilian = true
	self.activate_elevator = {}
	self.activate_elevator.text_id = "hud_activate_elevator"
	self.activate_elevator.start_active = false
	self.activate_elevator.interact_distance = 250
	self.lift_trap_door = {}
	self.lift_trap_door.text_id = "hud_lift_trap_door"
	self.lift_trap_door.start_active = false
	self.lift_trap_door.interact_distance = 300
	self.open_drop_pod = {}
	self.open_drop_pod.text_id = "hud_open_drop_pod"
	self.open_drop_pod.action_text_id = "hud_action_opening_drop_pod"
	self.open_drop_pod.timer = self.INTERACT_TIMER_SHORT
	self.open_drop_pod.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_drop_pod.start_active = false
	self.open_drop_pod.interact_distance = 300
	self.open_drop_pod.sound_start = "open_drop_pod_start"
	self.open_drop_pod.sound_interupt = "open_drop_pod_interrupt"
	self.pour_lava_ladle_01 = {}
	self.pour_lava_ladle_01.text_id = "hud_pour_lava"
	self.pour_lava_ladle_01.action_text_id = "hud_action_pouring_lava"
	self.pour_lava_ladle_01.timer = self.INTERACT_TIMER_MEDIUM
	self.pour_lava_ladle_01.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pour_lava_ladle_01.start_active = false
	self.pour_lava_ladle_01.interact_distance = 250
	self.open_fusebox = {}
	self.open_fusebox.text_id = "hud_open_fusebox"
	self.open_fusebox.action_text_id = "hud_action_opening_fusebox"
	self.open_fusebox.timer = self.INTERACT_TIMER_SHORT
	self.open_fusebox.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_fusebox.start_active = false
	self.open_fusebox.interact_distance = 250
	self.activate_trigger = {}
	self.activate_trigger.text_id = "hud_activate_trigger"
	self.activate_trigger.action_text_id = "hud_action_activating_trigger"
	self.activate_trigger.timer = self.INTERACT_TIMER_SHORT
	self.activate_trigger.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.activate_trigger.start_active = false
	self.activate_trigger.interact_distance = 250
	self.take_parachute = {}
	self.take_parachute.text_id = "hud_take_parachute"
	self.take_parachute.start_active = false
	self.take_parachute.interact_distance = 250
	self.take_bolt_cutter = {}
	self.take_bolt_cutter.text_id = "hud_take_bolt_cutter"
	self.take_bolt_cutter.start_active = false
	self.take_bolt_cutter.interact_distance = 250
	self.take_bolt_cutter.special_equipment_block = "bolt_cutter"
	self.cut_chain_bolt_cutter = {}
	self.cut_chain_bolt_cutter.text_id = "hud_cut_chain"
	self.cut_chain_bolt_cutter.action_text_id = "hud_action_cutting_chain"
	self.cut_chain_bolt_cutter.special_equipment = "bolt_cutter"
	self.cut_chain_bolt_cutter.equipment_text_id = "hud_int_need_bolt_cutter"
	self.cut_chain_bolt_cutter.equipment_consume = false
	self.cut_chain_bolt_cutter.start_active = false
	self.cut_chain_bolt_cutter.timer = 1
	self.take_bonds = {}
	self.take_bonds.text_id = "hud_take_bonds"
	self.take_bonds.action_text_id = "hud_action_taking_bonds"
	self.take_bonds.start_active = false
	self.take_bonds.timer = 1
	self.take_bonds.blocked_hint = "carry_block"
	self.take_tank_crank = {}
	self.take_tank_crank.text_id = "hud_take_tank_crank"
	self.take_tank_crank.start_active = false
	self.take_tank_crank.interact_distance = 250
	self.take_tank_crank.special_equipment_block = "tank_crank"
	self.start_the_tank = {}
	self.start_the_tank.text_id = "hud_start_tank"
	self.start_the_tank.action_text_id = "hud_action_starting_tank"
	self.start_the_tank.start_active = false
	self.start_the_tank.interact_distance = 250
	self.start_the_tank.timer = 5
	self.turn_searchlight = {}
	self.turn_searchlight.text_id = "hud_turn_searchlight"
	self.turn_searchlight.action_text_id = "hud_action_turning_searchlight"
	self.turn_searchlight.timer = self.INTERACT_TIMER_MEDIUM
	self.turn_searchlight.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.turn_searchlight.start_active = false
	self.turn_searchlight.interact_distance = 250
	self.turn_searchlight.sound_start = "searchlight_interaction_loop_start"
	self.turn_searchlight.sound_done = "searchlight_interaction_loop_stop"
	self.turn_searchlight.sound_interupt = "searchlight_interaction_loop_stop"
	self.take_dynamite_bag = {}
	self.take_dynamite_bag.text_id = "hud_int_take_dynamite"
	self.take_dynamite_bag.action_text_id = "hud_action_taking_dynamite"
	self.take_dynamite_bag.timer = self.INTERACT_TIMER_CARRY
	self.take_dynamite_bag.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_dynamite_bag.interact_distance = 250
	self.take_dynamite_bag.icon = "equipment_dynamite"
	self.take_dynamite_bag.special_equipment_block = "dynamite_bag"
	self.take_dynamite_bag.sound_done = "pickup_dynamite"
	self.take_cable_instant = {}
	self.take_cable_instant.text_id = "hud_take_cable"
	self.take_cable_instant.action_text_id = "hud_action_taking_cable"
	self.take_cable_instant.interact_distance = 200
	self.take_cable_instant.force_update_position = true
	self.take_cable = {}
	self.take_cable.text_id = "hud_take_cable"
	self.take_cable.action_text_id = "hud_action_taking_cable"
	self.take_cable.interact_distance = 200
	self.take_cable.timer = 2
	self.take_cable.force_update_position = true
	self.take_cable.sound_done = "el_cable_connected"
	self.take_cable.sound_start = "el_cable_connect"
	self.take_cable.sound_interupt = "el_cable_connect_stop"
	self.open_cargo_door = {}
	self.open_cargo_door.text_id = "hud_int_open_cargo_door"
	self.open_cargo_door.action_text_id = "hud_action_opening_cargo_door"
	self.open_cargo_door.timer = self.INTERACT_TIMER_SHORT
	self.open_cargo_door.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_cargo_door.interact_distance = 200
	self.close_cargo_door = deep_clone(self.open_cargo_door)
	self.close_cargo_door.text_id = "hud_int_close_cargo_door"
	self.close_cargo_door.action_text_id = "hud_action_closing_cargo_door"
	self.hold_couple_wagon = {}
	self.hold_couple_wagon.text_id = "hud_int_hold_couple_wagon"
	self.hold_couple_wagon.action_text_id = "hud_action_coupling_wagon"
	self.hold_couple_wagon.timer = self.INTERACT_TIMER_SHORT
	self.hold_couple_wagon.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_couple_wagon.start_active = false
	self.hold_couple_wagon.interact_distance = 300
	self.hold_decouple_wagon = deep_clone(self.hold_couple_wagon)
	self.hold_decouple_wagon.text_id = "hud_int_hold_decouple_wagon"
	self.hold_decouple_wagon.action_text_id = "hud_action_decoupling_wagon"
	self.hold_pull_lever = {}
	self.hold_pull_lever.text_id = "hud_int_hold_pull_lever"
	self.hold_pull_lever.action_text_id = "hud_action_pulling_lever"
	self.hold_pull_lever.start_active = false
	self.hold_pull_lever.interact_distance = 200
	self.hold_pull_lever.timer = self.INTERACT_TIMER_SHORT
	self.hold_pull_lever.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_pull_lever.dot_limit = 0.8
	self.hold_pull_lever.force_update_position = true
	self.hold_pull_lever.sound_start = "rail_switch_interaction_loop_start"
	self.hold_pull_lever.sound_done = "rail_switch_interaction_loop_stop"
	self.hold_pull_lever.sound_interupt = "rail_switch_interaction_loop_stop"
	self.hold_get_gear = {}
	self.hold_get_gear.text_id = "hud_int_hold_get_gear"
	self.hold_get_gear.action_text_id = "hud_action_get_gear"
	self.hold_get_gear.timer = self.INTERACT_TIMER_CARRY
	self.hold_get_gear.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_get_gear.start_active = false
	self.hold_get_gear.interact_distance = 300
	self.hold_get_gear_short_range = {}
	self.hold_get_gear_short_range.text_id = "hud_int_hold_get_gear"
	self.hold_get_gear_short_range.action_text_id = "hud_action_get_gear"
	self.hold_get_gear_short_range.timer = self.INTERACT_TIMER_CARRY
	self.hold_get_gear_short_range.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_get_gear_short_range.start_active = false
	self.hold_get_gear_short_range.interact_distance = 300
	self.hold_remove_blocker = {}
	self.hold_remove_blocker.text_id = "hud_int_hold_remove_blocker"
	self.hold_remove_blocker.action_text_id = "hud_action_removing_blocker"
	self.hold_remove_blocker.timer = self.INTERACT_TIMER_SHORT
	self.hold_remove_blocker.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_remove_blocker.start_active = false
	self.hold_remove_blocker.interact_distance = 250
	self.hold_remove_blocker.axis = "y"
	self.hold_remove_blocker.sound_start = "loco_blocker_remove_start"
	self.hold_remove_blocker.sound_done = "loco_blocker_remove_stop"
	self.hold_remove_blocker.sound_interupt = "loco_blocker_remove_stop"
	self.hold_open_hatch = {}
	self.hold_open_hatch.text_id = "hud_open_hatch"
	self.hold_open_hatch.action_text_id = "hud_action_opening_hatch"
	self.hold_open_hatch.timer = self.INTERACT_TIMER_SHORT
	self.hold_open_hatch.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_open_hatch.start_active = false
	self.hold_open_hatch.sound_done = "open_hatch_done"
	self.take_landmines = {}
	self.take_landmines.text_id = "hud_take_landmines"
	self.take_landmines.action_text_id = "hud_action_taking_landmines"
	self.take_landmines.timer = self.INTERACT_TIMER_SHORT
	self.take_landmines.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_landmines.start_active = false
	self.take_landmines.interact_distance = 250
	self.take_landmines.sound_start = "cvy_pick_up_mine"
	self.take_landmines.sound_interupt = "cvy_pick_up_mine_cancel_01"
	self.take_landmines.sound_done = "cvy_pick_up_mine_finish_01"
	self.place_landmine = {}
	self.place_landmine.text_id = "hud_place_landmine"
	self.place_landmine.action_text_id = "hud_action_placing_landmine"
	self.place_landmine.timer = self.INTERACT_TIMER_MEDIUM
	self.place_landmine.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.place_landmine.start_active = false
	self.place_landmine.interact_distance = 250
	self.place_landmine.equipment_text_id = "hint_no_landmines"
	self.place_landmine.special_equipment = "landmine"
	self.place_landmine.equipment_consume = true
	self.hold_start_locomotive = {}
	self.hold_start_locomotive.text_id = "hud_int_signal_driver"
	self.hold_start_locomotive.action_text_id = "hud_action_signaling_driver"
	self.hold_start_locomotive.timer = self.INTERACT_TIMER_SHORT
	self.hold_start_locomotive.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_start_locomotive.start_active = false
	self.free_radio_tehnician = {}
	self.free_radio_tehnician.text_id = "hud_untie_tehnician"
	self.free_radio_tehnician.action_text_id = "hud_action_untying_technician"
	self.free_radio_tehnician.timer = self.INTERACT_TIMER_MEDIUM
	self.free_radio_tehnician.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.free_radio_tehnician.start_active = false
	self.free_radio_tehnician.interact_distance = 250
	self.free_radio_tehnician.sound_start = "untie_rope_loop_interact_start"
	self.free_radio_tehnician.sound_done = "untie_rope_interact_end"
	self.free_radio_tehnician.sound_interupt = "untie_rope_loop_interrupt"
	self.hold_pull_down_ladder = {}
	self.hold_pull_down_ladder.text_id = "hud_int_pull_down_ladder"
	self.hold_pull_down_ladder.action_text_id = "hud_action_pull_down_ladder"
	self.hold_pull_down_ladder.timer = self.INTERACT_TIMER_MEDIUM
	self.hold_pull_down_ladder.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_pull_down_ladder.sound_done = "ladder_pull"
	self.hold_pull_down_ladder.interact_distance = 250
	self.detonate_the_dynamite = {}
	self.detonate_the_dynamite.text_id = "hud_int_detonate_the_dynamite"
	self.detonate_the_dynamite.action_text_id = "hud_action_detonate_the_dynamite"
	self.detonate_the_dynamite.timer = 0
	self.detonate_the_dynamite.sound_done = "bridge_switch_start"
	self.detonate_the_dynamite.interact_distance = 250
	self.detonate_the_dynamite_panel = {}
	self.detonate_the_dynamite_panel.text_id = "hud_int_detonate_the_dynamite"
	self.detonate_the_dynamite_panel.action_text_id = "hud_action_detonate_the_dynamite"
	self.detonate_the_dynamite_panel.timer = 0
	self.detonate_the_dynamite_panel.sound_done = "bridge_switch_start"
	self.detonate_the_dynamite_panel.interact_distance = 120
	self.detonate_the_dynamite_panel.start_active = false
	self.generic_press_panel = deep_clone(self.detonate_the_dynamite_panel)
	self.generic_press_panel.text_id = "hud_hold_open_barrier"
	self.generic_press_panel.action_text_id = "hud_action_opening_barrier"
	self.hold_call_boat_driver = {}
	self.hold_call_boat_driver.text_id = "hud_int_hold_call_boat_driver"
	self.hold_call_boat_driver.action_text_id = "hud_action_hold_call_boat_driver"
	self.hold_call_boat_driver.timer = self.INTERACT_TIMER_MEDIUM
	self.hold_call_boat_driver.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_call_boat_driver.sound_done = ""
	self.hold_call_boat_driver.interact_distance = 250
	self.cut_cage_lock = {}
	self.cut_cage_lock.text_id = "hud_cut_cage_lock"
	self.cut_cage_lock.action_text_id = "hud_action_cutting_cage_lock"
	self.cut_cage_lock.special_equipment = "blow_torch_fuel"
	self.cut_cage_lock.equipment_text_id = "hud_int_need_blow_torch_fuel"
	self.cut_cage_lock.timer = self.INTERACT_TIMER_LONG
	self.cut_cage_lock.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.cut_cage_lock.equipment_consume = true
	self.cut_cage_lock.start_active = false
	self.vhc_move_wagon = {}
	self.vhc_move_wagon.text_id = "hud_int_press_move_wagon"
	self.vhc_move_wagon.force_update_position = true
	self.move_crane = {}
	self.move_crane.text_id = "hud_int_press_move_crane"
	self.search_scrap_parts = {}
	self.search_scrap_parts.text_id = "hud_search_scrap_parts"
	self.search_scrap_parts.action_text_id = "hud_action_searching_scrap_parts"
	self.search_scrap_parts.timer = self.INTERACT_TIMER_MEDIUM
	self.search_scrap_parts.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.search_scrap_parts.start_active = true
	self.hold_attach_cable = {}
	self.hold_attach_cable.text_id = "hud_int_hold_attach_cable"
	self.hold_attach_cable.action_text_id = "hud_action_attaching_cable"
	self.hold_attach_cable.start_active = false
	self.hold_attach_cable.timer = self.INTERACT_TIMER_SHORT
	self.hold_attach_cable.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_detach_cable = {}
	self.hold_detach_cable.text_id = "hud_int_hold_detach_cable"
	self.hold_detach_cable.action_text_id = "hud_action_detaching_cable"
	self.hold_detach_cable.start_active = false
	self.hold_detach_cable.timer = self.INTERACT_TIMER_SHORT
	self.hold_detach_cable.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_detach_cable.sound_start = "cutting_cable_loop_start"
	self.hold_detach_cable.sound_interupt = "cutting_cable_loop_interrupt"
	self.hold_detach_cable.sound_done = "cutting_cable_loop_stop"
	self.take_code_book = {}
	self.take_code_book.text_id = "hud_take_code_book"
	self.take_code_book.action_text_id = "hud_action_taking_code_book"
	self.take_code_book.special_equipment_block = "code_book"
	self.take_code_book.start_active = false
	self.take_code_book.timer = self.INTERACT_TIMER_SHORT
	self.take_code_book.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_code_book.sound_done = "codebook_pickup_done"
	self.take_code_book_active = deep_clone(self.take_code_book)
	self.take_code_book_active.start_active = true
	self.take_code_book_empty = {}
	self.take_code_book_empty.text_id = "hud_take_code_book"
	self.take_code_book_empty.action_text_id = "hud_action_taking_code_book"
	self.take_code_book_empty.start_active = false
	self.take_code_book_empty.timer = self.INTERACT_TIMER_SHORT
	self.take_code_book_empty.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_code_book_empty.sound_done = "codebook_pickup_done"
	self.hold_ignite_flag = {}
	self.hold_ignite_flag.text_id = "hud_int_hold_ignite_flag"
	self.hold_ignite_flag.action_text_id = "hud_action_igniting_flag"
	self.hold_ignite_flag.timer = self.INTERACT_TIMER_MEDIUM
	self.hold_ignite_flag.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_ignite_flag.start_active = false
	self.hold_ignite_flag.axis = "y"
	self.hold_ignite_flag.sound_start = "flag_burn_interaction_start"
	self.hold_ignite_flag.sound_interupt = "flag_burn_interaction_interrupt"
	self.hold_ignite_flag.sound_done = "flag_burn_interaction_success"
	self.train_yard_open_door = {}
	self.train_yard_open_door.text_id = "hud_open_door_instant"
	self.train_yard_open_door.start_active = false
	self.train_yard_open_door.interact_distance = 250
	self.train_yard_open_door.sound_done = "generic_wood_door_opened"
	self.hold_take_canister = {}
	self.hold_take_canister.text_id = "hud_int_hold_take_canister"
	self.hold_take_canister.action_text_id = "hud_action_taking_canister"
	self.hold_take_canister.start_active = false
	self.hold_take_canister.timer = self.INTERACT_TIMER_SHORT
	self.hold_take_canister.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_take_canister.blocked_hint = "hud_hint_carry_block"
	self.hold_take_canister.sound_done = "canister_pickup"
	self.hold_take_crate_canisters = {}
	self.hold_take_crate_canisters.text_id = "hud_int_hold_take_crate_canisters"
	self.hold_take_crate_canisters.action_text_id = "hud_action_taking_crate_canisters"
	self.hold_take_crate_canisters.start_active = false
	self.hold_take_crate_canisters.timer = self.INTERACT_TIMER_SHORT
	self.hold_take_crate_canisters.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_take_empty_canister = deep_clone(self.hold_take_canister)
	self.hold_take_empty_canister.text_id = "hud_int_hold_empty_take_canister"
	self.hold_take_empty_canister.action_text_id = "hud_action_taking_empty_canister"
	self.hold_take_empty_canister.special_equipment_block = "empty_fuel_canister"
	self.hold_place_canister = {}
	self.hold_place_canister.text_id = "hud_int_hold_place_canister"
	self.hold_place_canister.action_text_id = "hud_action_placing_canister"
	self.hold_place_canister.equipment_text_id = "hud_hint_no_canister"
	self.hold_place_canister.special_equipment = "fuel_canister"
	self.hold_place_canister.timer = self.INTERACT_TIMER_SHORT
	self.hold_place_canister.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_place_canister.start_active = false
	self.hold_place_canister.equipment_consume = true
	self.hold_place_canister.sound_done = "canister_pickup"
	self.hold_fill_canister = {}
	self.hold_fill_canister.text_id = "hud_int_hold_fill_canister"
	self.hold_fill_canister.action_text_id = "hud_action_filling_canister"
	self.hold_fill_canister.equipment_text_id = "hud_hint_no_canister"
	self.hold_fill_canister.special_equipment = "empty_fuel_canister"
	self.hold_fill_canister.timer = self.INTERACT_TIMER_MEDIUM
	self.hold_fill_canister.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_fill_canister.start_active = false
	self.hold_fill_canister.sound_start = "canister_fill_loop_start"
	self.hold_fill_canister.sound_interupt = "canister_fill_loop_stop"
	self.hold_fill_canister.sound_done = "canister_fill_loop_stop"
	self.hold_fill_jeep = {}
	self.hold_fill_jeep.text_id = "hud_int_hold_fill_jeep"
	self.hold_fill_jeep.action_text_id = "hud_action_filling_jeep"
	self.hold_fill_jeep.equipment_text_id = "hud_hint_no_gasoline"
	self.hold_fill_jeep.special_equipment = "gas_x4"
	self.hold_fill_jeep.timer = self.INTERACT_TIMER_SHORT
	self.hold_fill_jeep.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_fill_jeep.start_active = false
	self.hold_fill_jeep.equipment_consume = true
	self.hold_fill_jeep.sound_start = "car_refuel_start"
	self.hold_fill_jeep.sound_interupt = "car_refuel_stop"
	self.hold_fill_jeep.sound_done = "car_refuel_stop"
	self.hold_fill_barrel_gasoline = deep_clone(self.hold_fill_jeep)
	self.hold_fill_barrel_gasoline.text_id = "hud_int_hold_fill_barrel_gasoline"
	self.hold_fill_barrel_gasoline.action_text_id = "hud_action_filling_barrel"
	self.hold_fill_barrel_gasoline.equipment_text_id = "hud_hint_no_gasoline"
	self.hold_fill_barrel_gasoline.special_equipment = "fuel_canister"
	self.give_tools_franz = {}
	self.give_tools_franz.text_id = "hud_give_tools_franz"
	self.give_tools_franz.action_text_id = "hud_action_giving_tools_franz"
	self.give_tools_franz.special_equipment = "repair_tools"
	self.give_tools_franz.equipment_text_id = "hud_no_tools_franz"
	self.give_tools_franz.equipment_consume = true
	self.give_tools_franz.start_active = false
	self.give_tools_franz.dot_limit = 0.7
	self.give_tools_franz.timer = self.INTERACT_TIMER_SHORT
	self.give_tools_franz.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.give_tools_franz.sound_done = "toolbox_pass"
	self.hold_reinforce_door = {}
	self.hold_reinforce_door.text_id = "hud_int_hold_reinforce_door"
	self.hold_reinforce_door.action_text_id = "hud_action_reinforcing_door"
	self.hold_reinforce_door.timer = self.INTERACT_TIMER_LONG
	self.hold_reinforce_door.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_reinforce_door.start_active = false
	self.hold_reinforce_door.sound_start = "reinforce_door_interact"
	self.hold_reinforce_door.sound_done = "reinforce_door_success"
	self.hold_reinforce_door.sound_interupt = "reinforce_door_interact_interrupt"
	self.hold_take_recording_device = {}
	self.hold_take_recording_device.text_id = "hud_int_hold_take_recording_device"
	self.hold_take_recording_device.action_text_id = "hud_action_taking_recording_device"
	self.hold_take_recording_device.start_active = false
	self.hold_take_recording_device.timer = self.INTERACT_TIMER_SHORT
	self.hold_take_recording_device.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_take_recording_device.sound_done = "recording_device_pickup"
	self.hold_place_recording_device = {}
	self.hold_place_recording_device.text_id = "hud_int_hold_place_recording_device"
	self.hold_place_recording_device.action_text_id = "hud_action_placing_recording_device"
	self.hold_place_recording_device.equipment_text_id = "hud_hint_no_recording_device"
	self.hold_place_recording_device.special_equipment = "recording_device"
	self.hold_place_recording_device.timer = self.INTERACT_TIMER_SHORT
	self.hold_place_recording_device.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_place_recording_device.start_active = false
	self.hold_place_recording_device.equipment_consume = true
	self.hold_place_recording_device.sound_done = "recording_device_placement"
	self.hold_connect_cable = {}
	self.hold_connect_cable.text_id = "hud_int_hold_connect_cable"
	self.hold_connect_cable.action_text_id = "hud_action_connecting_cable"
	self.hold_connect_cable.timer = self.INTERACT_TIMER_SHORT
	self.hold_connect_cable.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_connect_cable.start_active = false
	self.press_collect_reward = {}
	self.press_collect_reward.text_id = "hud_int_collect_reward"
	self.press_collect_reward.start_active = false
	self.press_collect_reward.interact_distance = 500
	self.start_recording = {}
	self.start_recording.text_id = "hud_int_start_recording"
	self.start_recording.start_active = false
	self.hold_place_codebook = {}
	self.hold_place_codebook.text_id = "hud_int_hold_place_codebook"
	self.hold_place_codebook.action_text_id = "hud_action_placing_codebook"
	self.hold_place_codebook.equipment_text_id = "hud_hint_no_codebook"
	self.hold_place_codebook.special_equipment = "code_book"
	self.hold_place_codebook.timer = self.INTERACT_TIMER_VERY_SHORT
	self.hold_place_codebook.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_place_codebook.start_active = false
	self.hold_place_codebook.equipment_consume = true
	self.hold_place_codebook.sound_done = "codebook_pickup_done"
	self.hold_repair_fusebox = {}
	self.hold_repair_fusebox.text_id = "hud_int_hold_repair_fusebox"
	self.hold_repair_fusebox.action_text_id = "hud_action_repairing_fusebox"
	self.hold_repair_fusebox.timer = self.INTERACT_TIMER_LONG
	self.hold_repair_fusebox.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_repair_fusebox.start_active = false
	self.hold_repair_fusebox.axis = "x"
	self.hold_repair_fusebox.sound_start = "fusebox_repair_interact_start"
	self.hold_repair_fusebox.sound_interupt = "fusebox_repair_interrupt"
	self.hold_repair_fusebox.sound_done = "fusebox_repair_success"
	self.hold_place_codemachine = {}
	self.hold_place_codemachine.text_id = "hud_int_hold_place_codemachine"
	self.hold_place_codemachine.action_text_id = "hud_action_placing_codemachine"
	self.hold_place_codemachine.equipment_text_id = "hud_hint_no_codemachine"
	self.hold_place_codemachine.special_equipment = "enigma"
	self.hold_place_codemachine.timer = self.INTERACT_TIMER_SHORT
	self.hold_place_codemachine.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_place_codemachine.start_active = false
	self.hold_place_codemachine.equipment_consume = true
	self.hold_place_codemachine.sound_done = "recording_device_placement"
	self.pour_gas_generator = {}
	self.pour_gas_generator.text_id = "hud_pour_gas_generator"
	self.pour_gas_generator.action_text_id = "hud_action_pouring_gas_generator"
	self.pour_gas_generator.equipment_text_id = "hud_hint_no_canister"
	self.pour_gas_generator.special_equipment = "fuel_canister"
	self.pour_gas_generator.timer = self.INTERACT_TIMER_LONG
	self.pour_gas_generator.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pour_gas_generator.start_active = false
	self.pour_gas_generator.equipment_consume = true
	self.pour_gas_generator.sound_start = "canister_fill_loop_start"
	self.pour_gas_generator.sound_interupt = "canister_fill_loop_stop"
	self.start_generator = {}
	self.start_generator.text_id = "hud_start_generator"
	self.start_generator.start_active = false
	self.start_generator.timer = self.INTERACT_TIMER_SHORT
	self.start_generator.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.load_shell = {}
	self.load_shell.text_id = "hud_load_shell"
	self.load_shell.action_text_id = "hud_action_loading_shell"
	self.load_shell.timer = self.INTERACT_TIMER_VERY_SHORT
	self.load_shell.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.load_shell.start_active = false
	self.load_shell.interact_dont_interupt_on_distance = true
	self.load_shell_use_carry = deep_clone(self.load_shell)
	self.load_shell_use_carry.required_carry = {
		"flak_shell",
		"flak_shell_explosive",
		"flak_shell_shot_explosive",
	}
	self.load_shell_use_carry.carry_text_id = "needs_carry_flak_shell"
	self.load_shell_use_carry.carry_consume = true
	self.place_shell_use_carry = deep_clone(self.load_shell)
	self.place_shell_use_carry.text_id = "hud_place_shell"
	self.place_shell_use_carry.action_text_id = "hud_action_placing_shell"
	self.place_shell_use_carry.required_carry = {
		"flak_shell",
		"flak_shell_explosive",
		"flak_shell_shot_explosive",
	}
	self.place_shell_use_carry.carry_text_id = "needs_carry_flak_shell"
	self.place_shell_use_carry.carry_consume = true
	self.pku_empty_bucket = {}
	self.pku_empty_bucket.text_id = "hud_int_take_empty_bucket"
	self.pku_empty_bucket.special_equipment_block = "empty_bucket"
	self.pku_empty_bucket.timer = self.INTERACT_TIMER_SHORT
	self.pku_empty_bucket.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pku_empty_bucket.start_active = false
	self.pku_fill_bucket = {}
	self.pku_fill_bucket.text_id = "hud_int_fill_bucket"
	self.pku_fill_bucket.equipment_text_id = "hud_hint_need_empty_bucket"
	self.pku_fill_bucket.special_equipment_block = "full_bucket"
	self.pku_fill_bucket.special_equipment = "empty_bucket"
	self.pku_fill_bucket.timer = self.INTERACT_TIMER_SHORT
	self.pku_fill_bucket.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.pku_fill_bucket.start_active = false
	self.pku_fill_bucket.equipment_consume = true
	self.hold_give_full_bucket = {}
	self.hold_give_full_bucket.text_id = "hud_int_hold_give_full_bucket"
	self.hold_give_full_bucket.action_text_id = "hud_action_giving_full_bucket"
	self.hold_give_full_bucket.equipment_text_id = "hud_hint_need_full_bucket"
	self.hold_give_full_bucket.special_equipment = "full_bucket"
	self.hold_give_full_bucket.timer = self.INTERACT_TIMER_SHORT
	self.hold_give_full_bucket.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_give_full_bucket.start_active = false
	self.hold_give_full_bucket.equipment_consume = true
	self.hold_contact_mrs_white = {}
	self.hold_contact_mrs_white.text_id = "hud_int_hold_contact_mrs_white"
	self.hold_contact_mrs_white.action_text_id = "hud_action_contacting_mrs_white"
	self.hold_contact_mrs_white.timer = self.INTERACT_TIMER_VERY_SHORT
	self.hold_contact_mrs_white.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.hold_contact_mrs_white.start_active = false
	self.hold_contact_boat_driver = deep_clone(self.hold_contact_mrs_white)
	self.hold_contact_boat_driver.text_id = "hud_int_hold_contact_boat_driver"
	self.hold_contact_boat_driver.action_text_id = "hud_action_contacting_boat_driver"
	self.hold_request_dynamite_airdrop = deep_clone(self.hold_contact_mrs_white)
	self.hold_request_dynamite_airdrop.text_id = "hud_int_hold_request_dynamite_airdrop"
	self.hold_request_dynamite_airdrop.action_text_id = "hud_action_requesting_airdrop"
	self.take_code_machine_part = {}
	self.take_code_machine_part.text_id = "hud_take_code_machine_part"
	self.take_code_machine_part.start_active = true
	self.take_code_machine_part.sound_done = "recording_device_placement"
	self.hold_start_plane = {}
	self.hold_start_plane.text_id = "hud_hold_start_plane"
	self.hold_start_plane.action_text_id = "hud_action_starting_plane"
	self.hold_start_plane.start_active = false
	self.hold_start_plane.timer = self.INTERACT_TIMER_LONG
	self.hold_start_plane.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_enigma = {}
	self.take_enigma.text_id = "hud_take_enigma"
	self.take_enigma.action_text_id = "hud_action_taking_enigma"
	self.take_enigma.special_equipment_block = "enigma"
	self.take_enigma.start_active = false
	self.take_enigma.timer = 3
	self.take_enigma.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_enigma.sound_done = "enigma_machine_pickup"
	self.wake_up_spy = {}
	self.wake_up_spy.text_id = "hud_wake_up_spy"
	self.wake_up_spy.action_text_id = "hud_action_waking_up_spy"
	self.wake_up_spy.start_active = false
	self.wake_up_spy.timer = self.INTERACT_TIMER_LONG
	self.wake_up_spy.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.wake_up_spy.dot_limit = 0.7
	self.hold_open_barrier = {}
	self.hold_open_barrier.text_id = "hud_hold_open_barrier"
	self.hold_open_barrier.action_text_id = "hud_action_opening_barrier"
	self.hold_open_barrier.start_active = false
	self.hold_open_barrier.timer = self.INTERACT_TIMER_SHORT
	self.hold_open_barrier.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.shut_off_valve = {}
	self.shut_off_valve.text_id = "hud_shut_off_valve"
	self.shut_off_valve.action_text_id = "hud_action_shutting_off_valve"
	self.shut_off_valve.start_active = false
	self.shut_off_valve.timer = self.INTERACT_TIMER_MEDIUM
	self.shut_off_valve.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.shut_off_valve.sound_start = "open_drop_pod_start"
	self.shut_off_valve.sound_interupt = "open_drop_pod_interrupt"
	self.shut_off_valve.sound_done = "elevator_switch"
	self.turn_on_valve = {}
	self.turn_on_valve.text_id = "hud_turn_on_valve"
	self.turn_on_valve.action_text_id = "hud_action_turning_on_valve"
	self.turn_on_valve.start_active = false
	self.turn_on_valve.timer = self.INTERACT_TIMER_MEDIUM
	self.turn_on_valve.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.turn_on_valve.sound_start = "disconnect_hose_start"
	self.turn_on_valve.sound_interupt = "disconnect_hose_interrupt"
	self.turn_on_valve.sound_done = "disconnect_hose_interrupt"
	self.destroy_valve = {}
	self.destroy_valve.text_id = "hud_desroy_valve"
	self.destroy_valve.action_text_id = "hud_action_destroying_valve"
	self.destroy_valve.start_active = false
	self.destroy_valve.timer = self.INTERACT_TIMER_MEDIUM
	self.destroy_valve.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.destroy_valve.sound_start = "gas_controller_destroy_interaction_start"
	self.destroy_valve.sound_interupt = "gas_controller_destroy_interaction_stop"
	self.destroy_valve.sound_done = "gas_controller_destroy"
	self.replace_flag = {}
	self.replace_flag.text_id = "hud_replace_flag"
	self.replace_flag.action_text_id = "hud_action_replacing_flag"
	self.replace_flag.start_active = false
	self.replace_flag.timer = self.INTERACT_TIMER_MEDIUM
	self.replace_flag.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.replace_flag.dot_limit = 0.7
	self.replace_flag.sound_done = "flag_replace"
	self.open_container = {}
	self.open_container.text_id = "hud_open_container"
	self.open_container.action_text_id = "hud_action_opening_container"
	self.open_container.start_active = false
	self.open_container.timer = self.INTERACT_TIMER_SHORT
	self.open_container.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.close_container = deep_clone(self.open_container)
	self.close_container.text_id = "hud_close_container"
	self.close_container.action_text_id = "hud_action_closing_container"
	self.press_take_dogtags = {
		interact_distance = self.SMALL_OBJECT_INTERACTION_DISTANCE,
		sound_done = "dogtags_pickup",
		start_active = true,
		text_id = "hud_int_press_take_dogtags",
		timer = self.INTERACT_TIMER_INSTA,
	}
	self.hold_take_dogtags = deep_clone(self.press_take_dogtags)
	self.hold_take_dogtags.text_id = "hud_int_hold_take_dogtags"
	self.hold_take_dogtags.action_text_id = "hud_action_taking_dogtags"
	self.hold_take_dogtags.timer = self.INTERACT_TIMER_VERY_SHORT
	self.hold_take_dogtags.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.press_take_loot = {
		sound_done = "pickup_tools",
		start_active = true,
		text_id = "hud_int_press_take_loot",
		timer = self.INTERACT_TIMER_INSTA,
	}
	self.hold_take_loot = deep_clone(self.press_take_loot)
	self.hold_take_loot.text_id = "hud_int_hold_take_loot"
	self.hold_take_loot.action_text_id = "hud_action_taking_loot"
	self.hold_take_loot.timer = self.INTERACT_TIMER_VERY_SHORT
	self.hold_take_loot.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.regular_cache_box = {}
	self.regular_cache_box.text_id = "hud_int_regular_cache_box"
	self.regular_cache_box.action_text_id = "hud_action_taking_cache_loot"
	self.regular_cache_box.sound_done = "pickup_tools"
	self.regular_cache_box.start_active = true
	self.disconnect_hose = {}
	self.disconnect_hose.text_id = "hud_disconnect_hose"
	self.disconnect_hose.action_text_id = "hud_action_disconnecting_hose"
	self.disconnect_hose.start_active = false
	self.disconnect_hose.timer = self.INTERACT_TIMER_LONG
	self.disconnect_hose.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.disconnect_hose.sound_start = "disconnect_hose_start"
	self.disconnect_hose.sound_interupt = "disconnect_hose_interrupt"
	self.disconnect_hose.sound_done = "disconnect_hose_success"
	self.push_truck_bridge = {}
	self.push_truck_bridge.text_id = "hud_push_truck_bridge"
	self.push_truck_bridge.action_text_id = "hud_action_pushing_truck_bridge"
	self.push_truck_bridge.start_active = false
	self.push_truck_bridge.timer = self.INTERACT_TIMER_LONG
	self.push_truck_bridge.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.connect_tank_truck = {}
	self.connect_tank_truck.text_id = "hud_connect_tank_truck"
	self.connect_tank_truck.action_text_id = "hud_action_connecting_tank_truck"
	self.connect_tank_truck.start_active = false
	self.connect_tank_truck.timer = self.INTERACT_TIMER_LONG
	self.connect_tank_truck.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.connect_tank_truck.sound_start = "fuel_tank_connect"
	self.connect_tank_truck.sound_interupt = "fuel_tank_connect_stop"
	self.set_fire_barrel = {}
	self.set_fire_barrel.text_id = "hud_interact_consumable_mission"
	self.set_fire_barrel.action_text_id = "hud_action_consumable_mission"
	self.set_fire_barrel.start_active = false
	self.set_fire_barrel.timer = 3
	self.set_fire_barrel.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.set_fire_barrel.sound_start = "flag_burn_interaction_start"
	self.set_fire_barrel.sound_interupt = "flag_burn_interaction_interrupt"
	self.set_fire_barrel.sound_done = "barrel_fire_start"
	self.open_door = {}
	self.open_door.text_id = "hud_open_door_instant"
	self.open_door.interact_distance = 200
	self.open_door.axis = "y"
	self.open_truck_trunk = {}
	self.open_truck_trunk.text_id = "hud_open_truck_trunk"
	self.open_truck_trunk.action_text_id = "hud_opening_truck_trunk"
	self.open_truck_trunk.interact_distance = 200
	self.open_truck_trunk.start_active = false
	self.open_truck_trunk.timer = self.INTERACT_TIMER_SHORT
	self.open_truck_trunk.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.open_truck_trunk.axis = "y"
	self.open_truck_trunk.sound_start = "truck_back_door_opening"
	self.open_truck_trunk.sound_done = "truck_back_door_open"
	self.folder_outlaw = {}
	self.folder_outlaw.start_active = true
	self.folder_outlaw.timer = self.INTERACT_TIMER_SHORT
	self.folder_outlaw.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.folder_outlaw.text_id = "hud_interact_consumable_mission"
	self.folder_outlaw.action_text_id = "hud_action_consumable_mission"
	self.folder_outlaw.blocked_hint = "hud_hint_consumable_mission_block"
	self.folder_outlaw.reward_type = "outlaw"
	self.folder_outlaw.sound_done = "consumable_mission_unlocked"
	self.request_recording_device = {}
	self.request_recording_device.text_id = "hud_request_recording_device"
	self.request_recording_device.action_text_id = "hud_action_requesting_recording_device"
	self.request_recording_device.start_active = true
	self.request_recording_device.timer = 2
	self.thermite = {}
	self.thermite.icon = "equipment_thermite"
	self.thermite.text_id = "debug_interact_thermite"
	self.thermite.equipment_text_id = "debug_interact_equipment_thermite"
	self.thermite.special_equipment = "thermite"
	self.thermite.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.thermite.equipment_consume = true
	self.thermite.interact_distance = 300
	self.thermite.timer = 3
	self.apply_thermite_paste = {}
	self.apply_thermite_paste.text_id = "hud_int_hold_ignite_thermite_paste"
	self.apply_thermite_paste.action_text_id = "hud_action_ignite_thermite_paste"
	self.apply_thermite_paste.special_equipment = "thermite_paste"
	self.apply_thermite_paste.equipment_text_id = "hud_int_need_thermite_paste"
	self.apply_thermite_paste.equipment_consume = true
	self.apply_thermite_paste.start_active = false
	self.apply_thermite_paste.contour = "interactable_icon"
	self.apply_thermite_paste.timer = self.INTERACT_TIMER_SHORT
	self.apply_thermite_paste.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.apply_thermite_paste.sound_start = "bar_thermal_lance_fix"
	self.apply_thermite_paste.sound_interupt = "bar_thermal_lance_fix_cancel"
	self.apply_thermite_paste.sound_done = "bar_thermal_lance_fix_finished"
	self.ignite_thermite = {}
	self.ignite_thermite.text_id = "hud_ignite_thermite"
	self.ignite_thermite.action_text_id = "hud_action_igniting_thermite"
	self.ignite_thermite.special_equipment = "thermite"
	self.ignite_thermite.equipment_text_id = "hud_int_need_thermite"
	self.ignite_thermite.equipment_consume = true
	self.ignite_thermite.start_active = false
	self.ignite_thermite.timer = self.INTERACT_TIMER_MEDIUM
	self.ignite_thermite.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.use_thermite = {}
	self.use_thermite.text_id = "hud_int_hold_use_thermite"
	self.use_thermite.action_text_id = "hud_action_hold_using_thermite"
	self.use_thermite.special_equipment = "thermite"
	self.use_thermite.equipment_text_id = "hud_int_need_thermite_cvy"
	self.use_thermite.equipment_consume = true
	self.use_thermite.start_active = true
	self.use_thermite.timer = self.INTERACT_TIMER_MEDIUM
	self.use_thermite.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.use_thermite.sound_start = "cvy_place_thermite"
	self.use_thermite.sound_interupt = "cvy_place_thermite_cancel"
	self.use_thermite.sound_done = "cvy_place_thermite_cancel"
	self.take_portable_radio = {}
	self.take_portable_radio.text_id = "hud_int_take_portable_radio"
	self.take_portable_radio.action_text_id = "hud_action_taking_portable_radio"
	self.take_portable_radio.timer = self.INTERACT_TIMER_SHORT
	self.take_portable_radio.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.take_portable_radio.interact_distance = 250
	self.take_portable_radio.special_equipment_block = "portable_radio"
	self.plant_portable_radio = {}
	self.plant_portable_radio.text_id = "hud_plant_portable_radio"
	self.plant_portable_radio.action_text_id = "hud_action_planting_portable_radio"
	self.plant_portable_radio.interact_distance = 250
	self.plant_portable_radio.timer = self.INTERACT_TIMER_MEDIUM
	self.plant_portable_radio.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_GENERIC
	self.plant_portable_radio.equipment_text_id = "hint_no_portable_radio"
	self.plant_portable_radio.special_equipment = "portable_radio"
	self.plant_portable_radio.start_active = false
	self.plant_portable_radio.equipment_consume = true
	self.plant_portable_radio.sound_start = "dynamite_placing"
	self.plant_portable_radio.sound_done = "dynamite_placed"
	self.plant_portable_radio.sound_interupt = "stop_dynamite_placing"
	self.dynamite_x1_pku = {}
	self.dynamite_x1_pku.text_id = "hud_int_take_dynamite"
	self.dynamite_x1_pku.action_text_id = "hud_action_taking_dynamite"
	self.dynamite_x1_pku.timer = self.INTERACT_TIMER_SHORT
	self.dynamite_x1_pku.interact_distance = 220
	self.dynamite_x1_pku.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_DYNAMITE
	self.dynamite_x1_pku.icon = "equipment_dynamite"
	self.dynamite_x1_pku.special_equipment_block = "dynamite"
	self.dynamite_x1_pku.sound_done = "pickup_dynamite"
	self.mine_pku = {}
	self.mine_pku.text_id = "hud_int_take_mine"
	self.mine_pku.action_text_id = "hud_action_taking_mine"
	self.mine_pku.special_equipment_block = "landmine"
	self.mine_pku.timer = self.INTERACT_TIMER_SHORT
	self.mine_pku.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_DYNAMITE
	self.mine_pku.start_active = true
	self.mine_pku.sound_start = "cvy_pick_up_mine"
	self.mine_pku.sound_interupt = "cvy_pick_up_mine_cancel_01"
	self.mine_pku.sound_done = "cvy_pick_up_mine_finish_01"
	self.dynamite_x4_pku = deep_clone(self.dynamite_x1_pku)
	self.dynamite_x4_pku.special_equipment_block = "dynamite_x4"
	self.dynamite_x5_pku = deep_clone(self.dynamite_x1_pku)
	self.dynamite_x5_pku.special_equipment_block = "dynamite_x5"
	self.plant_dynamite = {}
	self.plant_dynamite.text_id = "hud_plant_dynamite"
	self.plant_dynamite.action_text_id = "hud_action_planting_dynamite"
	self.plant_dynamite.interact_distance = 220
	self.plant_dynamite.timer = self.INTERACT_TIMER_MEDIUM
	self.plant_dynamite.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_DYNAMITE
	self.plant_dynamite.equipment_text_id = "hint_no_dynamite"
	self.plant_dynamite.special_equipment = "dynamite"
	self.plant_dynamite.start_active = false
	self.plant_dynamite.equipment_consume = true
	self.plant_dynamite.axis = "z"
	self.plant_dynamite.sound_start = "dynamite_placing"
	self.plant_dynamite.sound_done = "dynamite_placed"
	self.plant_dynamite.sound_interupt = "stop_dynamite_placing"
	self.plant_dynamite_x5 = deep_clone(self.plant_dynamite)
	self.plant_dynamite_x5.special_equipment = "dynamite_x5"
	self.plant_dynamite_x4 = deep_clone(self.plant_dynamite)
	self.plant_dynamite_x4.special_equipment = "dynamite_x4"
	self.plant_dynamite_from_bag = deep_clone(self.plant_dynamite)
	self.plant_dynamite_from_bag.equipment_consume = false
	self.plant_dynamite_from_bag.special_equipment = "dynamite_bag"
	self.plant_mine = {}
	self.plant_mine.text_id = "hud_plant_mine"
	self.plant_mine.action_text_id = "hud_action_planting_mine"
	self.plant_mine.interact_distance = 220
	self.plant_mine.timer = self.INTERACT_TIMER_MEDIUM
	self.plant_mine.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_DYNAMITE
	self.plant_mine.equipment_text_id = "hint_no_mine"
	self.plant_mine.special_equipment = "landmine"
	self.plant_mine.start_active = false
	self.plant_mine.equipment_consume = true
	self.plant_mine.axis = "z"
	self.plant_mine.sound_start = "cvy_plant_mine_loop_01"
	self.plant_mine.sound_done = "cvy_plant_mine_finish_01"
	self.plant_mine.sound_interupt = "cvy_plant_mine_cancel_01"
	self.defuse_mine = deep_clone(self.plant_mine)
	self.defuse_mine.text_id = "hud_defuse_mine"
	self.defuse_mine.action_text_id = "hud_action_defusinging_mine"
	self.defuse_mine.equipment_text_id = nil
	self.defuse_mine.special_equipment = nil
	self.defuse_mine.equipment_consume = nil
	self.defuse_mine.contour = "interactable_danger"
	self.rig_dynamite = {}
	self.rig_dynamite.text_id = "hud_int_rig_dynamite"
	self.rig_dynamite.action_text_id = "hud_action_rig_dynamite"
	self.rig_dynamite.timer = self.INTERACT_TIMER_MEDIUM
	self.rig_dynamite.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_DYNAMITE
	self.rig_dynamite.interact_distance = 280
	self.rig_dynamite.sound_start = "dynamite_placing"
	self.rig_dynamite.sound_done = "dynamite_placed"
	self.rig_dynamite.sound_interupt = "stop_dynamite_placing"
	self.rig_dynamite.special_equipment = "dynamite"
	self.rig_dynamite.equipment_consume = true
	self.plant_dynamite_bag = {}
	self.plant_dynamite_bag.text_id = "hud_plant_dynamite_bag"
	self.plant_dynamite_bag.action_text_id = "hud_action_planting_dynamite_bag"
	self.plant_dynamite_bag.interact_distance = 250
	self.plant_dynamite_bag.timer = self.INTERACT_TIMER_MEDIUM
	self.plant_dynamite_bag.equipment_text_id = "hint_no_dynamite_bag"
	self.plant_dynamite_bag.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_DYNAMITE
	self.plant_dynamite_bag.special_equipment = "dynamite_bag"
	self.plant_dynamite_bag.start_active = false
	self.plant_dynamite_bag.equipment_consume = true
	self.plant_dynamite_bag.sound_start = "dynamite_placing"
	self.plant_dynamite_bag.sound_done = "dynamite_placed"
	self.plant_dynamite_bag.sound_interupt = "stop_dynamite_placing"
	self.saboteur_turret = {}
	self.saboteur_turret.text_id = "hud_saboteur_turret"
	self.saboteur_turret.action_text_id = "hud_action_saboteur_turret"
	self.saboteur_turret.timer = self.INTERACT_TIMER_MEDIUM
	self.saboteur_turret.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_DYNAMITE
	self.saboteur_turret.requires_upgrade = {
		category = "interaction",
		upgrade = "saboteur_boobytrap_turret",
	}
	self.saboteur_turret.dot_limit = 0.95
	self.saboteur_turret.interact_distance = 65
	self.saboteur_turret.force_update_position = true
	self.saboteur_turret.axis = "y"
	self.saboteur_turret.sound_start = "dynamite_placing"
	self.saboteur_turret.sound_done = "dynamite_placed"
	self.saboteur_turret.sound_interupt = "stop_dynamite_placing"
	self.revive = {}
	self.revive.icon = "interaction_help"
	self.revive.text_id = "hud_interact_revive"
	self.revive.action_text_id = "hud_action_reviving"
	self.revive.contour_preset = "teammate_downed"
	self.revive.contour_preset_selected = "teammate_downed_selected"
	self.revive.start_active = false
	self.revive.allowed_while_perservating = true
	self.revive.interact_distance = 300
	self.revive.dot_limit = 0.75
	self.revive.axis = "z"
	self.revive.timer = 5
	self.revive.upgrade_timer_multipliers = {
		{
			category = "interaction",
			upgrade = "medic_revive_speed_multiplier",
		},
	}
	self.revive.player_say_interacting = "player_gen_revive_start"
	self.intimidate = {}
	self.intimidate.icon = "equipment_cable_ties"
	self.intimidate.text_id = "debug_interact_intimidate"
	self.intimidate.equipment_text_id = "debug_interact_equipment_cable_tie"
	self.intimidate.action_text_id = "hud_action_cable_tying"
	self.intimidate.start_active = false
	self.intimidate.equipment_consume = true
	self.intimidate.no_contour = true
	self.intimidate.timer = 2
	self.pickpocket_steal = {}
	self.pickpocket_steal.text_id = "hud_int_skill_pickpocket"
	self.pickpocket_steal.action_text_id = "hud_action_skill_pickpocketing"
	self.pickpocket_steal.timer = self.INTERACT_TIMER_SHORT
	self.pickpocket_steal.no_contour = true
	self.pickpocket_steal.stealth_only = true
	self.pickpocket_steal.requires_upgrade = {
		category = "interaction",
		upgrade = "pickpocket_greed_steal",
	}
	self.pickpocket_steal.interaction_obj = Idstring("Spine")
	self.repair = {}
	self.repair.text_id = "hud_repair"
	self.repair.action_text_id = "hud_action_repairing"
	self.repair.special_equipment = "repair_tools"
	self.repair.equipment_text_id = "hud_no_tools"
	self.repair.equipment_consume = false
	self.repair.start_active = false
	self.repair.timer = self.INTERACT_TIMER_LONG
	self.dead = {}
	self.dead.icon = "interaction_help"
	self.dead.text_id = "hud_interact_revive"
	self.dead.start_active = false
	self.dead.interact_distance = 300
	self.free = {}
	self.free.icon = "interaction_free"
	self.free.text_id = "debug_interact_free"
	self.free.start_active = false
	self.free.interact_distance = 300
	self.free.no_contour = true
	self.free.timer = 1
	self.free.sound_start = "bar_rescue"
	self.free.sound_interupt = "bar_rescue_cancel"
	self.free.sound_done = "bar_rescue_finished"
	self.free.action_text_id = "hud_action_freeing"
	self.hostage_trade = {}
	self.hostage_trade.icon = "interaction_trade"
	self.hostage_trade.text_id = "debug_interact_trade"
	self.hostage_trade.start_active = true
	self.hostage_trade.timer = 3
	self.hostage_trade.requires_upgrade = {
		category = "player",
		upgrade = "hostage_trade",
	}
	self.hostage_trade.action_text_id = "hud_action_trading"
	self.hostage_trade.contour_preset = "generic_interactable"
	self.hostage_trade.contour_preset_selected = "generic_interactable_selected"
	self.hostage_move = {}
	self.hostage_move.icon = "interaction_trade"
	self.hostage_move.text_id = "debug_interact_hostage_move"
	self.hostage_move.start_active = true
	self.hostage_move.timer = 1
	self.hostage_move.action_text_id = "hud_action_standing_up"
	self.hostage_move.no_contour = true
	self.hostage_move.interaction_obj = Idstring("Spine")
	self.hostage_stay = {}
	self.hostage_stay.icon = "interaction_trade"
	self.hostage_stay.text_id = "debug_interact_hostage_stay"
	self.hostage_stay.start_active = true
	self.hostage_stay.timer = 0.4
	self.hostage_stay.action_text_id = "hud_action_getting_down"
	self.hostage_stay.no_contour = true
	self.hostage_stay.interaction_obj = Idstring("Spine2")
	self.hostage_convert = {}
	self.hostage_convert.icon = "develop"
	self.hostage_convert.text_id = "hud_int_hostage_convert"
	self.hostage_convert.blocked_hint = "convert_enemy_failed"
	self.hostage_convert.timer = 1.5
	self.hostage_convert.requires_upgrade = {
		category = "player",
		upgrade = "convert_enemies",
	}
	self.hostage_convert.upgrade_timer_multiplier = {
		category = "player",
		upgrade = "convert_enemies_interaction_speed_multiplier",
	}
	self.hostage_convert.action_text_id = "hud_action_converting_hostage"
	self.hostage_convert.no_contour = true
	self.activate_switch = {}
	self.activate_switch.icon = "develop"
	self.activate_switch.text_id = "hud_activate_switch"
	self.activate_switch.action_text_id = "hud_action_activate_switch"
	self.activate_switch.axis = "y"
	self.activate_switch.interact_distance = 200
	self.activate_switch.timer = 2.335
	self.activate_switch_easy = deep_clone(self.activate_switch)
	self.activate_switch_medium = deep_clone(self.activate_switch)
end

function InteractionTweakData:_init_carry()
	self.gold_pile = {}
	self.gold_pile.icon = "interaction_gold"
	self.gold_pile.text_id = "hud_interact_gold_pile_take_money"
	self.gold_pile.action_text_id = "hud_action_taking_gold"
	self.gold_pile.timer = self.INTERACT_TIMER_CARRY
	self.gold_pile.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.gold_pile.start_active = true
	self.gold_pile.sound_done = "gold_crate_drop"
	self.gold_pile_inactive = deep_clone(self.gold_pile)
	self.gold_pile_inactive.start_active = false
	self.gold_pile_inactive_repeating = deep_clone(self.gold_pile_inactive)
	self.gold_pile_inactive_repeating.keep_active = true
	self.carry_drop_gold = {}
	self.carry_drop_gold.icon = "interaction_gold"
	self.carry_drop_gold.text_id = "hud_interact_gold_pile_take_money"
	self.carry_drop_gold.action_text_id = "hud_action_taking_gold"
	self.carry_drop_gold.timer = self.INTERACT_TIMER_CARRY
	self.carry_drop_gold.distance = self.CARRY_DROP_INTERACTION_DISTANCE
	self.carry_drop_gold.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.carry_drop_gold.force_update_position = true
	self.carry_drop_gold.sound_start = "gold_crate_pickup"
	self.carry_drop_gold.sound_interupt = "gold_crate_drop"
	self.carry_drop_gold.sound_done = "gold_crate_drop"
	self.hold_take_wine_crate = {}
	self.hold_take_wine_crate.text_id = "hud_take_wine_crate"
	self.hold_take_wine_crate.action_text_id = "hud_action_taking_wine_crate"
	self.hold_take_wine_crate.timer = self.INTERACT_TIMER_CARRY
	self.hold_take_wine_crate.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.hold_take_wine_crate.start_active = true
	self.hold_take_wine_crate.interact_distance = 250
	self.take_tank_shell = {}
	self.take_tank_shell.text_id = "hud_take_tank_shell"
	self.take_tank_shell.action_text_id = "hud_action_taking_tank_shell"
	self.take_tank_shell.special_equipment_block = "tank_shell"
	self.take_tank_shell.timer = self.INTERACT_TIMER_CARRY
	self.take_tank_shell.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_tank_shell.start_active = false
	self.take_contraband_jewelry = {}
	self.take_contraband_jewelry.text_id = "hud_take_contraband_jewelry"
	self.take_contraband_jewelry.action_text_id = "hud_action_taking_contraband_jewelry"
	self.take_contraband_jewelry.timer = self.INTERACT_TIMER_CARRY
	self.take_contraband_jewelry.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_contraband_jewelry.start_active = true
	self.carry_drop = {}
	self.carry_drop.text_id = "hud_int_hold_grab_the_bag"
	self.carry_drop.action_text_id = "hud_action_grabbing_bag"
	self.carry_drop.timer = self.INTERACT_TIMER_CARRY
	self.carry_drop.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.carry_drop.force_update_position = true
	self.take_spiked_wine = {}
	self.take_spiked_wine.text_id = "hud_take_spiked_wine"
	self.take_spiked_wine.action_text_id = "hud_action_taking_spiked_wine"
	self.take_spiked_wine.timer = self.INTERACT_TIMER_CARRY
	self.take_spiked_wine.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_spiked_wine.start_active = false
	self.take_painting = {}
	self.take_painting.text_id = "hud_take_painting"
	self.take_painting.action_text_id = "hud_action_taking_painting"
	self.take_painting.timer = self.INTERACT_TIMER_MEDIUM
	self.take_painting.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_painting.interact_distance = 250
	self.take_painting.start_active = false
	self.take_painting.sound_start = "sto_painting"
	self.take_painting.sound_interupt = "sto_painting_cancel"
	self.take_painting.sound_done = "sto_painting_finish"
	self.take_painting_active = {}
	self.take_painting_active.text_id = "hud_take_painting"
	self.take_painting_active.action_text_id = "hud_action_taking_painting"
	self.take_painting_active.timer = self.INTERACT_TIMER_CARRY_PAINTING
	self.take_painting_active.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_painting_active.interact_distance = self.CARRY_DROP_INTERACTION_DISTANCE
	self.take_painting_active.start_active = true
	self.take_painting_active.sound_done = "sto_pick_up_painting"
	self.take_tank_shells = {}
	self.take_tank_shells.text_id = "hud_take_tank_shells"
	self.take_tank_shells.action_text_id = "hud_action_taking_tank_shells"
	self.take_tank_shells.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_tank_shells.start_active = false
	self.take_tank_shells.interact_distance = 250
	self.take_tank_shells.timer = 5
	self.hold_take_cigar_crate = deep_clone(self.hold_take_wine_crate)
	self.hold_take_cigar_crate.text_id = "hud_take_cigar_crate"
	self.hold_take_cigar_crate.action_text_id = "hud_action_taking_cigar_crate"
	self.hold_take_chocolate_box = deep_clone(self.hold_take_wine_crate)
	self.hold_take_chocolate_box.text_id = "hud_take_chocolate_box"
	self.hold_take_chocolate_box.action_text_id = "hud_action_taking_chocolate_box"
	self.hold_take_crucifix = deep_clone(self.hold_take_wine_crate)
	self.hold_take_crucifix.text_id = "hud_take_crucifix"
	self.hold_take_crucifix.action_text_id = "hud_action_taking_crucifix"
	self.hold_take_baptismal_font = deep_clone(self.hold_take_wine_crate)
	self.hold_take_baptismal_font.text_id = "hud_take_baptismal_font"
	self.hold_take_baptismal_font.action_text_id = "hud_action_taking_baptismal_font"
	self.hold_take_religious_figurine = deep_clone(self.hold_take_wine_crate)
	self.hold_take_religious_figurine.text_id = "hud_take_religious_figurine"
	self.hold_take_religious_figurine.action_text_id = "hud_action_taking_religious_figurine"
	self.hold_take_candelabrum = deep_clone(self.hold_take_wine_crate)
	self.hold_take_candelabrum.text_id = "hud_take_candelabrum"
	self.hold_take_candelabrum.action_text_id = "hud_action_taking_candelabrum"
	self.carry_drop_flak_shell = {}
	self.carry_drop_flak_shell.text_id = "hud_take_flak_shell"
	self.carry_drop_flak_shell.action_text_id = "hud_action_taking_flak_shell"
	self.carry_drop_flak_shell.timer = self.INTERACT_TIMER_CARRY
	self.carry_drop_flak_shell.distance = self.CARRY_DROP_INTERACTION_DISTANCE
	self.carry_drop_flak_shell.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.carry_drop_flak_shell.force_update_position = true
	self.carry_drop_flak_shell.sound_start = "flakshell_take"
	self.carry_drop_flak_shell.sound_done = "flakshell_packed"
	self.carry_drop_flak_shell.sound_interupt = "flakshell_take_stop"
	self.carry_drop_tank_shell = deep_clone(self.carry_drop_flak_shell)
	self.carry_drop_tank_shell.text_id = "hud_take_tank_shell"
	self.carry_drop_tank_shell.action_text_id = "hud_action_taking_tank_shell"
	self.carry_drop_tank_shell.sound_start = "flakshell_take"
	self.carry_drop_tank_shell.sound_done = "flakshell_packed"
	self.carry_drop_tank_shell.sound_interupt = "flakshell_take_stop"
	self.carry_drop_barrel = deep_clone(self.carry_drop_flak_shell)
	self.carry_drop_barrel.text_id = "hud_take_barrel"
	self.carry_drop_barrel.action_text_id = "hud_action_taking_barrel"
	self.take_ladder = {}
	self.take_ladder.text_id = "hud_take_ladder"
	self.take_ladder.action_text_id = "hud_action_taking_ladder"
	self.take_ladder.interact_distance = 250
	self.take_ladder.timer = self.INTERACT_TIMER_CARRY
	self.take_ladder.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_ladder.start_active = false
	self.take_ladder.sound_start = "ladder_pickup_loop_start"
	self.take_ladder.sound_interupt = "ladder_pickup_complete"
	self.take_ladder.sound_done = "ladder_pickup_complete"
	self.take_plank = {}
	self.take_plank.text_id = "hud_take_plank"
	self.take_plank.action_text_id = "hud_action_taking_plank"
	self.take_plank.interact_distance = 350
	self.take_plank.timer = self.INTERACT_TIMER_CARRY
	self.take_plank.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_plank.start_active = false
	self.take_plank.sound_done = "take_plank"
	self.take_plank_bag = deep_clone(self.take_plank)
	self.take_plank_bag.interact_distance = self.CARRY_DROP_INTERACTION_DISTANCE
	self.take_plank_bag.force_update_position = true
	self.take_plank_bag.start_active = true
	self.take_flak_shell = {}
	self.take_flak_shell.text_id = "hud_take_flak_shell"
	self.take_flak_shell.action_text_id = "hud_action_taking_flak_shell"
	self.take_flak_shell.interact_distance = 300
	self.take_flak_shell.timer = self.INTERACT_TIMER_CARRY
	self.take_flak_shell.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_flak_shell.start_active = false
	self.take_flak_shell.sound_start = "flakshell_take"
	self.take_flak_shell.sound_done = "flakshell_packed"
	self.take_flak_shell.sound_interupt = "flakshell_take_stop"
	self.take_flak_shell_bag = deep_clone(self.take_flak_shell)
	self.take_flak_shell_bag.force_update_position = true
	self.take_flak_shell_bag.start_active = true
	self.take_flak_shell_bag.timer = self.INTERACT_TIMER_CARRY
	self.take_flak_shell_pallete = {}
	self.take_flak_shell_pallete.text_id = "hud_take_flak_shell_pallete"
	self.take_flak_shell_pallete.action_text_id = "hud_action_taking_flak_shell_pallete"
	self.take_flak_shell_pallete.interact_distance = 250
	self.take_flak_shell_pallete.timer = self.INTERACT_TIMER_CARRY
	self.take_flak_shell_pallete.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CARRY
	self.take_flak_shell_pallete.start_active = false
	self.corpse_dispose = {}
	self.corpse_dispose.icon = "develop"
	self.corpse_dispose.text_id = "hud_int_dispose_corpse"
	self.corpse_dispose.timer = self.INTERACT_TIMER_CORPSE
	self.corpse_dispose.dot_limit = 0.7
	self.corpse_dispose.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CORPSE
	self.corpse_dispose.action_text_id = "hud_action_disposing_corpse"
	self.corpse_dispose.no_contour = true
	self.corpse_dispose.stealth_only = true
	self.corpse_dispose.player_say_interacting = "player_gen_carry_body"
	self.carry_spy = {}
	self.carry_spy.text_id = "hud_carry_spy"
	self.carry_spy.action_text_id = "hud_action_carring_spy"
	self.carry_spy.start_active = false
	self.carry_spy.timer = self.INTERACT_TIMER_CORPSE
	self.carry_spy.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CORPSE
	self.carry_spy.dot_limit = 0.7
	self.carry_spy.player_say_interacting = "or_op_spy_picked_up"
	self.carry_drop_spy = deep_clone(self.carry_drop)
	self.carry_drop_spy.text_id = "hud_carry_spy"
	self.carry_drop_spy.action_text_id = "hud_action_carring_spy"
	self.carry_drop_spy.timer = self.INTERACT_TIMER_CORPSE
	self.carry_drop_spy.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_CORPSE
	self.carry_drop_spy.dot_limit = 0.7
	self.carry_drop_spy.player_say_interacting = "or_op_spy_picked_up"
end

function InteractionTweakData:_init_comwheels()
	local com_wheel_color = Color(1, 0.8, 0)

	local function com_wheel_clbk(say_target_id, default_say_id, post_prefix, past_prefix, waypoint_tech)
		local character = managers.network:session():local_peer()._character
		local nationality = CriminalsManager.comm_wheel_callout_from_nationality(character)
		local snd = post_prefix .. nationality .. past_prefix
		local text
		local player = managers.player:player_unit()

		if not alive(player) then
			return
		end

		local target, target_nationality = player:movement():current_state():teammate_aimed_at_by_player()

		if target ~= nil then
			local target_char = CriminalsManager.comm_wheel_callout_from_nationality(target_nationality)

			if target_char == nationality and nationality ~= "amer" then
				target_char = "amer"
			elseif target_char == nationality and nationality == "amer" then
				target_char = "brit"
			end

			if nationality == "russian" then
				nationality = "rus"
			end

			text = say_target_id .. "~" .. target

			player:sound():say(nationality .. "_call_" .. target_char, true, true)
			player:sound():queue_sound("comm_wheel", post_prefix .. nationality .. past_prefix, nil, true)
		else
			text = default_say_id

			player:sound():say(post_prefix .. nationality .. past_prefix, true, true)
		end

		managers.chat:send_message(ChatManager.GAME, "Player", text)
	end

	self.com_wheel = {}
	self.com_wheel.icon = "develop"
	self.com_wheel.color = com_wheel_color
	self.com_wheel.text_id = "debug_interact_temp_interact_box"
	self.com_wheel.wheel_radius_inner = 120
	self.com_wheel.wheel_radius_outer = 150
	self.com_wheel.text_padding = 25
	self.com_wheel.cooldown = 1.5
	self.com_wheel.options = {
		{
			clbk = com_wheel_clbk,
			clbk_data = {
				"com_wheel_target_say_yes",
				"com_wheel_say_yes",
				"com_",
				"_yes",
			},
			color = com_wheel_color,
			icon = "comm_wheel_yes",
			id = "yes",
			text_id = "com_wheel_yes",
		},
		{
			clbk = com_wheel_clbk,
			clbk_data = {
				"com_wheel_target_say_no",
				"com_wheel_say_no",
				"com_",
				"_no",
			},
			color = com_wheel_color,
			icon = "comm_wheel_no",
			id = "no",
			text_id = "com_wheel_no",
		},
		{
			clbk = com_wheel_clbk,
			clbk_data = {
				"com_wheel_target_say_found_it",
				"com_wheel_say_found_it",
				"com_",
				"_found",
			},
			color = com_wheel_color,
			icon = "comm_wheel_found_it",
			id = "found_it",
			text_id = "com_wheel_found_it",
		},
		{
			clbk = com_wheel_clbk,
			clbk_data = {
				"com_wheel_target_say_not_here",
				"com_wheel_say_not_here",
				"com_",
				"_notfound",
			},
			color = com_wheel_color,
			icon = "comm_wheel_not_here",
			id = "not_here",
			text_id = "com_wheel_not_here",
		},
		{
			clbk = com_wheel_clbk,
			clbk_data = {
				"com_wheel_target_say_follow_me",
				"com_wheel_say_follow_me",
				"com_",
				"_follow",
			},
			color = com_wheel_color,
			icon = "comm_wheel_follow_me",
			id = "follow_me",
			text_id = "com_wheel_follow_me",
		},
		{
			clbk = com_wheel_clbk,
			clbk_data = {
				"com_wheel_target_say_wait",
				"com_wheel_say_wait",
				"com_",
				"_wait",
			},
			color = com_wheel_color,
			icon = "comm_wheel_wait",
			id = "wait",
			text_id = "com_wheel_wait",
		},
		{
			clbk = com_wheel_clbk,
			clbk_data = {
				"com_wheel_target_say_assistance",
				"com_wheel_say_assistance",
				"com_",
				"_help",
			},
			color = com_wheel_color,
			icon = "comm_wheel_assistance",
			id = "assistance",
			text_id = "com_wheel_assistance",
		},
		{
			clbk = com_wheel_clbk,
			clbk_data = {
				"com_wheel_target_say_enemy",
				"com_wheel_say_enemy",
				"com_",
				"_enemy",
			},
			color = com_wheel_color,
			icon = "comm_wheel_enemy",
			id = "enemy",
			text_id = "com_wheel_enemy",
		},
	}
	self.carry_wheel = {}
	self.carry_wheel.icon = "develop"
	self.carry_wheel.text_id = "debug_interact_temp_interact_box"
	self.carry_wheel.cooldown = 0.35
	self.carry_wheel.options = {
		{
			clbk = function()
				managers.player:drop_all_carry()
			end,
			icon = "comm_wheel_follow_me",
			id = "drop_all",
			multiplier = 2,
			text_id = "hud_carry_drop_all",
		},
	}
end

function InteractionTweakData:_init_minigames()
	self.minigame_icons = {
		cut_fuse = "equipment_panel_dynamite",
		pick_lock = "player_panel_status_lockpick",
	}
	self.si_revive = {}
	self.si_revive.icon = "develop"
	self.si_revive.text_id = "skill_interaction_revive"
	self.si_revive.action_text_id = "skill_interaction_revive"
	self.si_revive.axis = "y"
	self.si_revive.minigame_type = self.MINIGAME_SELF_REVIE
	self.si_revive.interact_distance = 200
	self.si_revive.number_of_circles = 1
	self.si_revive.circle_rotation_speed = {
		300,
	}
	self.si_revive.circle_rotation_direction = {
		1,
	}
	self.si_revive.circle_difficulty = {
		0.9,
	}
	self.si_revive.sounds = self.LOCKPICK_SOUNDS
	self.sii_tune_radio_easy = {}
	self.sii_tune_radio_easy.icon = "develop"
	self.sii_tune_radio_easy.text_id = "hud_sii_tune_radio"
	self.sii_tune_radio_easy.action_text_id = "hud_action_sii_tune_radio"
	self.sii_tune_radio_easy.axis = "y"
	self.sii_tune_radio_easy.interact_distance = 200
	self.sii_tune_radio_easy.minigame_type = self.MINIGAME_PICK_LOCK
	self.sii_tune_radio_easy.number_of_circles = 1
	self.sii_tune_radio_easy.circle_rotation_speed = {
		220,
	}
	self.sii_tune_radio_easy.circle_rotation_direction = {
		1,
	}
	self.sii_tune_radio_easy.circle_difficulty = {
		0.84,
	}
	self.sii_tune_radio_easy.sounds = self.LOCKPICK_SOUNDS
	self.sii_tune_radio_medium = {}
	self.sii_tune_radio_medium.icon = "develop"
	self.sii_tune_radio_medium.text_id = "hud_sii_tune_radio"
	self.sii_tune_radio_medium.action_text_id = "hud_action_sii_tune_radio"
	self.sii_tune_radio_medium.axis = "y"
	self.sii_tune_radio_medium.interact_distance = 200
	self.sii_tune_radio_medium.minigame_type = self.MINIGAME_PICK_LOCK
	self.sii_tune_radio_medium.number_of_circles = 2
	self.sii_tune_radio_medium.circle_rotation_speed = {
		220,
		250,
	}
	self.sii_tune_radio_medium.circle_rotation_direction = {
		1,
		-1,
	}
	self.sii_tune_radio_medium.circle_difficulty = {
		0.84,
		0.88,
	}
	self.sii_tune_radio_medium.sounds = self.LOCKPICK_SOUNDS
	self.sii_tune_radio = {}
	self.sii_tune_radio.icon = "develop"
	self.sii_tune_radio.text_id = "hud_sii_tune_radio"
	self.sii_tune_radio.action_text_id = "hud_action_sii_tune_radio"
	self.sii_tune_radio.axis = "y"
	self.sii_tune_radio.interact_distance = 200
	self.sii_tune_radio.minigame_type = self.MINIGAME_PICK_LOCK
	self.sii_tune_radio.number_of_circles = 3
	self.sii_tune_radio.circle_rotation_speed = {
		220,
		250,
		280,
	}
	self.sii_tune_radio.circle_rotation_direction = {
		1,
		-1,
		1,
	}
	self.sii_tune_radio.circle_difficulty = {
		0.84,
		0.88,
		0.92,
	}
	self.sii_tune_radio.sounds = self.LOCKPICK_SOUNDS
	self.sii_play_recordings = deep_clone(self.sii_tune_radio)
	self.sii_play_recordings.text_id = "hud_int_play_recordings"
	self.sii_play_recordings.action_text_id = "hud_action_playing_recordings"
	self.sii_play_recordings.axis = "z"
	self.sii_change_channel = deep_clone(self.sii_play_recordings)
	self.sii_change_channel.text_id = "hud_int_change_channel"
	self.sii_change_channel.action_text_id = "hud_action_changing_channel"
	self.sii_play_recordings_easy = deep_clone(self.sii_tune_radio_easy)
	self.sii_play_recordings_easy.text_id = "hud_int_play_recordings"
	self.sii_play_recordings_easy.action_text_id = "hud_action_playing_recordings"
	self.sii_play_recordings_easy.axis = "z"
	self.sii_play_recordings_medium = deep_clone(self.sii_tune_radio_medium)
	self.sii_play_recordings_medium.text_id = "hud_int_play_recordings"
	self.sii_play_recordings_medium.action_text_id = "hud_action_playing_recordings"
	self.sii_play_recordings_medium.axis = "z"
	self.sii_replay_last_message = deep_clone(self.sii_play_recordings)
	self.sii_replay_last_message.text_id = "hud_int_replay_last_message"
	self.sii_replay_last_message.action_text_id = "hud_action_replaying_message"
	self.sii_replay_last_message_easy = deep_clone(self.sii_play_recordings_easy)
	self.sii_replay_last_message_easy.text_id = "hud_int_replay_last_message"
	self.sii_replay_last_message_easy.action_text_id = "hud_action_replaying_message"
	self.sii_replay_last_message_medium = deep_clone(self.sii_play_recordings_medium)
	self.sii_replay_last_message_medium.text_id = "hud_int_replay_last_message"
	self.sii_replay_last_message_medium.action_text_id = "hud_action_replaying_message"
	self.sii_test = {}
	self.sii_test.icon = "develop"
	self.sii_test.text_id = "hud_sii_lockpick"
	self.sii_test.interact_distance = 500
	self.sii_test.minigame_type = self.MINIGAME_PICK_LOCK
	self.sii_test.number_of_circles = 3
	self.sii_test.circle_rotation_speed = {
		160,
		180,
		190,
	}
	self.sii_test.circle_rotation_direction = {
		1,
		-1,
		1,
	}
	self.sii_test.circle_difficulty = {
		0.9,
		0.93,
		0.96,
	}
	self.sii_lockpick_easy = {}
	self.sii_lockpick_easy.minigame_type = self.MINIGAME_PICK_LOCK
	self.sii_lockpick_easy.icon = "develop"
	self.sii_lockpick_easy.text_id = "hud_sii_lockpick"
	self.sii_lockpick_easy.action_text_id = "hud_action_sii_lockpicking"
	self.sii_lockpick_easy.legend_exit_text_id = "hud_legend_lockpicking_exit"
	self.sii_lockpick_easy.legend_interact_text_id = "hud_legend_lockpicking_interact"
	self.sii_lockpick_easy.interact_distance = 200
	self.sii_lockpick_easy.number_of_circles = 1
	self.sii_lockpick_easy.circle_rotation_speed = {
		220,
	}
	self.sii_lockpick_easy.circle_rotation_direction = {
		1,
	}
	self.sii_lockpick_easy.circle_difficulty = {
		0.88,
	}
	self.sii_lockpick_easy.sounds = self.LOCKPICK_SOUNDS
	self.sii_lockpick_easy.loot_table = {
		"lockpick_crate_tier",
	}
	self.sii_lockpick_easy_y_direction = deep_clone(self.sii_lockpick_easy)
	self.sii_lockpick_easy_y_direction.axis = "y"
	self.sii_lockpick_medium = {
		action_text_id = "hud_action_sii_lockpicking",
		circle_difficulty = {
			0.88,
			0.9,
		},
		circle_rotation_direction = {
			1,
			-1,
		},
		circle_rotation_speed = {
			220,
			250,
		},
		icon = "develop",
		interact_distance = 200,
		legend_exit_text_id = "hud_legend_lockpicking_exit",
		legend_interact_text_id = "hud_legend_lockpicking_interact",
		loot_table = {
			"lockpick_crate_tier",
		},
		minigame_type = self.MINIGAME_PICK_LOCK,
		number_of_circles = 2,
		sounds = self.LOCKPICK_SOUNDS,
		text_id = "hud_sii_lockpick",
	}
	self.sii_lockpick_medium_y_direction = deep_clone(self.sii_lockpick_medium)
	self.sii_lockpick_medium_y_direction.axis = "y"
	self.sii_lockpick_hard = {}
	self.sii_lockpick_hard.icon = "develop"
	self.sii_lockpick_hard.text_id = "hud_sii_lockpick"
	self.sii_lockpick_hard.action_text_id = "hud_action_sii_lockpicking"
	self.sii_lockpick_hard.legend_exit_text_id = "hud_legend_lockpicking_exit"
	self.sii_lockpick_hard.legend_interact_text_id = "hud_legend_lockpicking_interact"
	self.sii_lockpick_hard.interact_distance = 200
	self.sii_lockpick_hard.minigame_type = self.MINIGAME_PICK_LOCK
	self.sii_lockpick_hard.number_of_circles = 3
	self.sii_lockpick_hard.circle_rotation_speed = {
		220,
		250,
		280,
	}
	self.sii_lockpick_hard.circle_rotation_direction = {
		1,
		-1,
		1,
	}
	self.sii_lockpick_hard.circle_difficulty = {
		0.88,
		0.9,
		0.92,
	}
	self.sii_lockpick_hard.sounds = self.LOCKPICK_SOUNDS
	self.sii_lockpick_hard.loot_table = {
		"lockpick_crate_tier",
	}
	self.sii_lockpick_hard_y_direction = deep_clone(self.sii_lockpick_hard)
	self.sii_lockpick_hard_y_direction.axis = "y"
	self.picklock_door = {}
	self.picklock_door.icon = "develop"
	self.picklock_door.text_id = "hud_picklock_door"
	self.picklock_door.action_text_id = "hud_action_picklock_door"
	self.picklock_door.axis = "y"
	self.picklock_door.interact_distance = 200
	self.picklock_door.minigame_type = self.MINIGAME_PICK_LOCK
	self.picklock_door.number_of_circles = 3
	self.picklock_door.circle_rotation_speed = {
		160,
		180,
		190,
	}
	self.picklock_door.circle_rotation_direction = {
		1,
		-1,
		1,
	}
	self.picklock_door.circle_difficulty = {
		0.9,
		0.93,
		0.96,
	}
	self.picklock_door.sounds = self.LOCKPICK_SOUNDS
	self.picklock_door_easy = {}
	self.picklock_door_easy.icon = "develop"
	self.picklock_door_easy.text_id = "hud_picklock_door"
	self.picklock_door_easy.action_text_id = "hud_action_picklock_door"
	self.picklock_door_easy.axis = "y"
	self.picklock_door_easy.interact_distance = 200
	self.picklock_door_easy.minigame_type = self.MINIGAME_PICK_LOCK
	self.picklock_door_easy.number_of_circles = 1
	self.picklock_door_easy.circle_rotation_speed = {
		160,
	}
	self.picklock_door_easy.circle_rotation_direction = {
		1,
	}
	self.picklock_door_easy.circle_difficulty = {
		0.9,
	}
	self.picklock_door_easy.sounds = self.LOCKPICK_SOUNDS
	self.picklock_door_medium = {}
	self.picklock_door_medium.icon = "develop"
	self.picklock_door_medium.text_id = "hud_picklock_door"
	self.picklock_door_medium.action_text_id = "hud_action_picklock_door"
	self.picklock_door_medium.axis = "y"
	self.picklock_door_medium.interact_distance = 200
	self.picklock_door_medium.minigame_type = self.MINIGAME_PICK_LOCK
	self.picklock_door_medium.number_of_circles = 2
	self.picklock_door_medium.circle_rotation_speed = {
		160,
		180,
	}
	self.picklock_door_medium.circle_rotation_direction = {
		1,
		-1,
	}
	self.picklock_door_medium.circle_difficulty = {
		0.9,
		0.93,
	}
	self.picklock_door_medium.sounds = self.LOCKPICK_SOUNDS
	self.picklock_window_easy = {}
	self.picklock_window_easy.icon = "develop"
	self.picklock_window_easy.text_id = "hud_picklock_window"
	self.picklock_window_easy.action_text_id = "hud_action_picklock_window"
	self.picklock_window_easy.axis = "y"
	self.picklock_window_easy.interact_distance = 200
	self.picklock_window_easy.minigame_type = self.MINIGAME_PICK_LOCK
	self.picklock_window_easy.number_of_circles = 1
	self.picklock_window_easy.circle_rotation_speed = {
		200,
	}
	self.picklock_window_easy.circle_rotation_direction = {
		1,
	}
	self.picklock_window_easy.circle_difficulty = {
		0.85,
	}
	self.picklock_window_easy.sounds = self.LOCKPICK_SOUNDS
	self.picklock_window_medium = {}
	self.picklock_window_medium.icon = "develop"
	self.picklock_window_medium.text_id = "hud_picklock_window"
	self.picklock_window_medium.action_text_id = "hud_action_picklock_window"
	self.picklock_window_medium.axis = "y"
	self.picklock_window_medium.interact_distance = 200
	self.picklock_window_medium.minigame_type = self.MINIGAME_PICK_LOCK
	self.picklock_window_medium.number_of_circles = 2
	self.picklock_window_medium.circle_rotation_speed = {
		200,
		230,
	}
	self.picklock_window_medium.circle_rotation_direction = {
		1,
		-1,
	}
	self.picklock_window_medium.circle_difficulty = {
		0.85,
		0.9,
	}
	self.picklock_window_medium.sounds = self.LOCKPICK_SOUNDS
	self.picklock_window = {}
	self.picklock_window.icon = "develop"
	self.picklock_window.text_id = "hud_picklock_window"
	self.picklock_window.action_text_id = "hud_action_picklock_window"
	self.picklock_window.axis = "y"
	self.picklock_window.interact_distance = 200
	self.picklock_window.minigame_type = self.MINIGAME_PICK_LOCK
	self.picklock_window.number_of_circles = 3
	self.picklock_window.circle_rotation_speed = {
		200,
		230,
		260,
	}
	self.picklock_window.circle_rotation_direction = {
		1,
		-1,
		1,
	}
	self.picklock_window.circle_difficulty = {
		0.85,
		0.9,
		0.95,
	}
	self.picklock_window.sounds = self.LOCKPICK_SOUNDS
	self.call_mrs_white_easy = {}
	self.call_mrs_white_easy.icon = "develop"
	self.call_mrs_white_easy.text_id = "hud_call_mrs_white"
	self.call_mrs_white_easy.action_text_id = "hud_action_call_mrs_white"
	self.call_mrs_white_easy.axis = "z"
	self.call_mrs_white_easy.interact_distance = 200
	self.call_mrs_white_easy.minigame_type = self.MINIGAME_PICK_LOCK
	self.call_mrs_white_easy.number_of_circles = 1
	self.call_mrs_white_easy.circle_rotation_speed = {
		200,
	}
	self.call_mrs_white_easy.circle_rotation_direction = {
		1,
	}
	self.call_mrs_white_easy.circle_difficulty = {
		0.9,
	}
	self.call_mrs_white_easy.sounds = self.LOCKPICK_SOUNDS
	self.call_mrs_white_medium = {}
	self.call_mrs_white_medium.icon = "develop"
	self.call_mrs_white_medium.text_id = "hud_call_mrs_white"
	self.call_mrs_white_medium.action_text_id = "hud_action_call_mrs_white"
	self.call_mrs_white_medium.axis = "z"
	self.call_mrs_white_medium.interact_distance = 200
	self.call_mrs_white_medium.minigame_type = self.MINIGAME_PICK_LOCK
	self.call_mrs_white_medium.number_of_circles = 2
	self.call_mrs_white_medium.circle_rotation_speed = {
		200,
		220,
	}
	self.call_mrs_white_medium.circle_rotation_direction = {
		1,
		-1,
	}
	self.call_mrs_white_medium.circle_difficulty = {
		0.9,
		0.92,
	}
	self.call_mrs_white_medium.sounds = self.LOCKPICK_SOUNDS
	self.call_mrs_white = {}
	self.call_mrs_white.icon = "develop"
	self.call_mrs_white.text_id = "hud_call_mrs_white"
	self.call_mrs_white.action_text_id = "hud_action_call_mrs_white"
	self.call_mrs_white.axis = "z"
	self.call_mrs_white.interact_distance = 200
	self.call_mrs_white.minigame_type = self.MINIGAME_PICK_LOCK
	self.call_mrs_white.number_of_circles = 3
	self.call_mrs_white.circle_rotation_speed = {
		200,
		220,
		240,
	}
	self.call_mrs_white.circle_rotation_direction = {
		1,
		-1,
		1,
	}
	self.call_mrs_white.circle_difficulty = {
		0.9,
		0.92,
		0.94,
	}
	self.call_mrs_white.sounds = self.LOCKPICK_SOUNDS
	self.lockpick_cargo_door = deep_clone(self.open_cargo_door)
	self.lockpick_cargo_door.timer = self.INTERACT_TIMER_INSTA
	self.lockpick_cargo_door.minigame_type = self.MINIGAME_PICK_LOCK
	self.lockpick_cargo_door.number_of_circles = 1
	self.lockpick_cargo_door.circle_rotation_speed = {
		210,
		240,
		270,
	}
	self.lockpick_cargo_door.circle_rotation_direction = {
		1,
		-1,
		1,
	}
	self.lockpick_cargo_door.circle_difficulty = {
		0.84,
		0.87,
		0.9,
	}
	self.lockpick_cargo_door.sounds = self.LOCKPICK_SOUNDS
	self.minigame_lockpicking_base = {
		action_text_id = "hud_action_lockpicking",
		circle_difficulty = {
			0.84,
			0.88,
			0.91,
			0.94,
		},
		circle_rotation_direction = {
			1,
			-1,
			1,
			-1,
		},
		circle_rotation_speed = {
			240,
			260,
			280,
			300,
		},
		interact_distance = 220,
		legend_exit_text_id = "hud_legend_lockpicking_exit",
		legend_interact_text_id = "hud_legend_lockpicking_interact",
		minigame_type = self.MINIGAME_PICK_LOCK,
		number_of_circles = 4,
		sounds = self.LOCKPICK_SOUNDS,
		text_id = "hud_int_pick_lock",
	}
	self.minigame_fusecutting_base = {}
	self.minigame_fusecutting_base.minigame_type = self.MINIGAME_CUT_FUSE
	self.minigame_fusecutting_base.text_id = "hud_int_cut_fuse"
	self.minigame_fusecutting_base.action_text_id = "hud_action_cutting_fuse"
	self.minigame_fusecutting_base.legend_interact_text_id = "hud_legend_fusecutting_interact"
	self.minigame_fusecutting_base.interact_distance = 240
	self.minigame_fusecutting_base.circle_rotation_speed = 240
	self.minigame_fusecutting_base.circle_difficulty = 0.13
	self.minigame_fusecutting_base.circle_difficulty_mul = 0.83
	self.minigame_fusecutting_base.circle_difficulty_deviation = {
		0.7,
		1.1,
	}
	self.minigame_fusecutting_base.cut_timers = {
		90,
		80,
		70,
		60,
		50,
		45,
		40,
		35,
		30,
	}
	self.minigame_fusecutting_base.max_cuts = 9
	self.minigame_fusecutting_base.sounds = self.DYNAMITE_SOUNDS
	self.minigame_fusecutting_dynamite_bag = deep_clone(self.minigame_fusecutting_base)
	self.minigame_fusecutting_dynamite_bag.equipment_text_id = "hint_no_dynamite_bag"
	self.minigame_fusecutting_dynamite_bag.special_equipment = "dynamite_bag"
	self.minigame_fusecutting_dynamite_bag.equipment_consume = true
	self.minigame_rewire_base = {}
	self.minigame_rewire_base.minigame_type = self.MINIGAME_REWIRE
	self.minigame_rewire_base.text_id = "hud_int_rewire"
	self.minigame_rewire_base.action_text_id = "hud_action_rewiring"
	self.minigame_rewire_base.legend_interact_text_id = "hud_legend_rewiring_interact"
	self.minigame_rewire_base.interact_distance = 220
	self.minigame_rewire_base.fuse_radius = 256
	self.minigame_rewire_base.fuse_walls = 8
	self.minigame_rewire_base.fuse_gap_size = 0.1
	self.minigame_rewire_base.fuse_rotation_speed = 160
	self.minigame_rewire_base.sounds = self.REWIRE_SOUNDS
	self.minigame_rewire_base.node_types = {
		bend = 5,
		dead = 2,
		line = 1,
		trap = 2,
	}
	self.minigame_rewire_base.node_count_x = 3
	self.minigame_rewire_base.node_count_y = 3
	self.minigame_rewire_base.speed = {
		2.6,
		2.6,
		2.6,
		2.6,
		2.6,
	}
	self.rewire_fuse_pane = deep_clone(self.hold_attach_cable)
	self.rewire_fuse_pane.text_id = "hud_rewire_fuse_pane"
	self.rewire_fuse_pane.action_text_id = "hud_action_rewire_fuse_pane"
	self.rewire_fuse_pane.axis = "y"
	self.rewire_fuse_pane.timer = self.INTERACT_TIMER_LONG
	self.rewire_fuse_pane.upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_REWIRE
	self.rewire_fuse_pane.sound_done = "el_cable_connected"
	self.rewire_fuse_pane.sound_start = "el_cable_connect"
	self.rewire_fuse_pane.sound_interupt = "el_cable_connect_stop"
	self.rewire_fuse_pane.interact_distance = 200
	self.rewire_fuse_pane_easy = deep_clone(self.rewire_fuse_pane)
	self.rewire_fuse_pane_medium = deep_clone(self.rewire_fuse_pane)
	self.rewire_fuse_pane_hard = deep_clone(self.rewire_fuse_pane)
	self.activate_burners = {
		action_text_id = "hud_action_activate_burners",
		axis = "y",
		interact_distance = 200,
		sound_done = "el_cable_connected",
		sound_interupt = "el_cable_connect_stop",
		sound_start = "el_cable_connect",
		text_id = "hud_activate_burners",
		timer = self.INTERACT_TIMER_LONG,
		upgrade_timer_multipliers = self.TIMER_MULTIPLIERS_REWIRE,
	}
	self.activate_burners_easy = deep_clone(self.activate_burners)
	self.activate_burners_easy.timer = self.INTERACT_TIMER_SHORT
	self.activate_burners_medium = deep_clone(self.activate_burners)
	self.activate_burners_medium.timer = self.INTERACT_TIMER_MEDIUM
	self.minigame_cc_roulette = {}
	self.minigame_cc_roulette.minigame_type = self.MINIGAME_CC_ROULETTE
	self.minigame_cc_roulette.text_id = "hud_test_minigame_cc_roulette"
	self.minigame_cc_roulette.action_text_id = "hud_action_test_minigame_cc_roulette"
	self.minigame_cc_roulette.axis = "y"
	self.minigame_cc_roulette.circle_rotation_speed = 400
	self.minigame_cc_roulette.sounds = self.LOCKPICK_SOUNDS
end
