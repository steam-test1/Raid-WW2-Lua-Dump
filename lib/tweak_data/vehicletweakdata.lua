VehicleTweakData = VehicleTweakData or class()
VehicleTweakData.AI_TELEPORT_DISTANCE = 2000
VehicleTweakData.FADE_DISTANCE = 3800
VehicleTweakData.FADE_DISTANCE_START = 3800

function VehicleTweakData:init(tweak_data)
	self:_init_data_jeep_willy()
	self:_init_data_kubelwagen()
	self:_init_data_truck()
	self:_init_data_foxhole()
end

function VehicleTweakData:_init_data_jeep_willy()
	self.jeep_willy = {}
	self.jeep_willy.unit = "units/vehicles/willy_jeep/fps_vehicle_jeep_willy"
	self.jeep_willy.name = "hud_vehicle_jeep"
	self.jeep_willy.hud_label_offset = 150
	self.jeep_willy.animations = {
		driver = "drive_kubelwagen_driver",
		passenger_back_left = "drive_kubelwagen_back_left",
		passenger_back_right = "drive_kubelwagen_back_right",
		passenger_front = "drive_kubelwagen_passanger",
		vehicle_id = "kubelwagen",
	}
	self.jeep_willy.sound = {
		broken_engine = "kubel_engine_break",
		bump = "car_bumper_01",
		bump_locator = "anim_tire_front_left",
		bump_rtpc = "TRD_bump",
		bump_treshold = 8,
		door_close = "car_door_open",
		engine_rpm_rtpc = "car_falcogini_rpm",
		engine_sound_event = "muscle",
		engine_speed_rtpc = "car_falcogini_speed",
		engine_start = "muscle_engine_start",
		gear_shift = "gear_shift",
		hit = "car_hits_something",
		hit_enemy = "car_hit_body_01",
		hit_rtpc = "TRD_hit",
		horn_start = "kubel_horn_start",
		horn_stop = "kubel_horn_stop",
		lateral_slip_treshold = 0.35,
		longitudal_slip_treshold = 0.8,
		slip = "car_skid_01",
		slip_locator = "anim_tire_front_left",
		slip_stop = "car_skid_stop_01",
	}
	self.jeep_willy.seats = {
		driver = {
			driving = true,
			name = "driver",
			next_seat = "passenger_front",
		},
		passenger_back_left = {
			allow_shooting = true,
			driving = false,
			has_shooting_mode = false,
			name = "passenger_back_left",
			next_seat = "driver",
		},
		passenger_back_right = {
			allow_shooting = true,
			driving = false,
			has_shooting_mode = false,
			name = "passenger_back_right",
			next_seat = "passenger_back_left",
		},
		passenger_front = {
			allow_shooting = true,
			driving = false,
			has_shooting_mode = false,
			name = "passenger_front",
			next_seat = "passenger_back_right",
		},
	}
	self.jeep_willy.loot_points = {
		loot = {
			name = "loot",
		},
	}
	self.jeep_willy.repair_point = "v_repair_engine"
	self.jeep_willy.trunk_point = "interact_trunk"
	self.jeep_willy.damage = {
		max_health = 1250,
	}
	self.jeep_willy.max_speed = 160
	self.jeep_willy.max_rpm = 8000
	self.jeep_willy.loot_drop_point = "v_repair_engine"
	self.jeep_willy.max_loot_bags = 4
	self.jeep_willy.interact_distance = 350
	self.jeep_willy.driver_camera_offset = Vector3(0, 0.2, 2.5)
end

function VehicleTweakData:_init_data_kubelwagen()
	self.kubelwagen = {}
	self.kubelwagen.unit = "units/vanilla/vehicles/fps_vehicle_kubelwagen/fps_vehicle_kubelwagen"
	self.kubelwagen.name = "hud_vehicle_kubelwagen"
	self.kubelwagen.hud_label_offset = 150
	self.kubelwagen.waypoint_hud_icon = "waypoint_special_vehicle_kugelwagen"
	self.kubelwagen.waypoint_map_icon = "map_waypoint_map_kugelwagen"
	self.kubelwagen.animations = {
		driver = "drive_kubelwagen_driver",
		passenger_back_left = "drive_kubelwagen_back_left",
		passenger_back_right = "drive_kubelwagen_back_right",
		passenger_front = "drive_kubelwagen_passanger",
		vehicle_id = "kubelwagen",
	}
	self.kubelwagen.sound = {
		broken_engine = "kubel_engine_break",
		bump = "car_bumper_01",
		bump_locator = "anim_tire_front_left",
		bump_rtpc = "TRD_bump",
		bump_treshold = 8,
		door_close = "car_door_open",
		engine_rpm_rtpc = "TRD",
		engine_sound_event = "kubel_final_engine",
		engine_speed_rtpc = "TRD_speed",
		engine_start = "kubel_final_engine_start",
		engine_stop = "kubel_final_engine_stop",
		gear_shift = "gear_shift",
		hit = "car_hits_something",
		hit_enemy = "car_hit_body_01",
		hit_rtpc = "TRD_hit",
		horn_start = "kubel_horn_start",
		horn_stop = "kubel_horn_stop",
		lateral_slip_treshold = 0.35,
		longitudal_slip_treshold = 0.8,
		slip = "car_skid_01",
		slip_locator = "anim_tire_front_left",
		slip_stop = "car_skid_stop_01",
	}
	self.kubelwagen.seats = {
		driver = {
			allow_shooting = false,
			camera_limits = {
				50,
				45,
			},
			driving = true,
			has_shooting_mode = false,
			name = "driver",
			next_seat = "passenger_front",
		},
		passenger_back_left = {
			allow_shooting = false,
			camera_limits = {
				90,
				45,
			},
			driving = false,
			has_shooting_mode = true,
			name = "passenger_back_left",
			next_seat = "driver",
			shooting_pos = Vector3(-40, -20, 50),
		},
		passenger_back_right = {
			allow_shooting = false,
			camera_limits = {
				90,
				45,
			},
			driving = false,
			has_shooting_mode = true,
			name = "passenger_back_right",
			next_seat = "passenger_back_left",
			shooting_pos = Vector3(30, -20, 50),
		},
		passenger_front = {
			allow_shooting = true,
			camera_limits = {
				90,
				45,
			},
			driving = false,
			has_shooting_mode = false,
			name = "passenger_front",
			next_seat = "passenger_back_right",
			shooting_pos = Vector3(40, -20, 50),
		},
	}
	self.kubelwagen.loot_points = {
		loot = {
			name = "loot",
		},
	}
	self.kubelwagen.secure_loot = false
	self.kubelwagen.loot_filter = {
		conspiracy_board = true,
		german_spy_body = true,
		gold = true,
	}
	self.kubelwagen.allow_only_filtered = true
	self.kubelwagen.repair_point = "v_repair_engine"
	self.kubelwagen.trunk_point = "interact_trunk"
	self.kubelwagen.damage = {
		max_health = 1250,
	}
	self.kubelwagen.max_speed = 120
	self.kubelwagen.max_rpm = 6000
	self.kubelwagen.loot_drop_point = "v_repair_engine"
	self.kubelwagen.max_loot_bags = 8
	self.kubelwagen.interact_distance = 350
	self.kubelwagen.skins = {}
	self.kubelwagen.skins.special_edition = {
		dlc = DLCTweakData.DLC_NAME_SPECIAL_EDITION,
		sequence = "state_collector_edition_skin",
	}
	self.kubelwagen.driver_camera_offset = Vector3(0, 2, 22)
end

function VehicleTweakData:_init_data_truck()
	self.truck = {
		animations = {
			driver = "drive_truck_driver",
			passenger_back_left = "drive_truck_back_left",
			passenger_back_right = "drive_truck_back_right",
			passenger_front = "drive_truck_passanger",
			vehicle_id = "truck",
		},
		hud_label_offset = 250,
		name = "hud_vehicle_truck",
		sound = {
			broken_engine = "kubel_engine_break",
			bump = "car_bumper_01",
			bump_locator = "anim_tire_front_left",
			bump_rtpc = "TRD_bump",
			bump_treshold = 8,
			door_close = "car_door_open",
			engine_rpm_rtpc = "TRD",
			engine_sound_event = "truck_engine_event",
			engine_speed_rtpc = "TRD_speed",
			engine_start = "truck_1p_engine_start",
			engine_stop = "truck_1p_engine_stop",
			gear_shift = "gear_shift",
			hit = "car_hits_something",
			hit_enemy = "car_hit_body_01",
			hit_rtpc = "TRD_hit",
			horn_start = "kubel_horn_start",
			horn_stop = "kubel_horn_stop",
			lateral_slip_treshold = 0.35,
			longitudal_slip_treshold = 0.8,
			slip = "car_skid_01",
			slip_locator = "anim_tire_front_left",
			slip_stop = "car_skid_stop_01",
		},
		unit = "units/vanilla/vehicles/fps_vehicle_truck_02/fps_vehicle_truck_02",
		waypoint_hud_icon = "waypoint_special_vehicle_truck",
		waypoint_map_icon = "map_waypoint_map_truck",
	}
	self.truck.seats = {
		driver = {
			driving = true,
			name = "driver",
			next_seat = "passenger_front",
			sound_environment_end = "leave_truck",
			sound_environment_start = "enter_truck",
		},
		passenger_back_left = {
			allow_shooting = true,
			driving = false,
			has_shooting_mode = true,
			name = "passenger_back_left",
			next_seat = "driver",
			shooting_pos = Vector3(-50, 0, 50),
		},
		passenger_back_right = {
			allow_shooting = true,
			driving = false,
			has_shooting_mode = true,
			name = "passenger_back_right",
			next_seat = "passenger_back_left",
			shooting_pos = Vector3(50, 0, 50),
		},
		passenger_front = {
			allow_shooting = false,
			camera_limits = {
				90,
				45,
			},
			driving = false,
			has_shooting_mode = true,
			name = "passenger_front",
			next_seat = "passenger_back_right",
			shooting_pos = Vector3(50, -20, 50),
			sound_environment_end = "leave_truck",
			sound_environment_start = "enter_truck",
		},
	}
	self.truck.loot_points = {
		loot = {
			name = "loot",
		},
		loot_1 = {
			name = "loot_1",
		},
		loot_2 = {
			name = "loot_2",
		},
		loot_3 = {
			name = "loot_3",
		},
		loot_4 = {
			name = "loot_4",
		},
	}
	self.truck.loot_filter = {
		crate_explosives = true,
		gold = true,
		gold_bar = true,
		painting_sto = true,
		painting_sto_cheap = true,
	}
	self.truck.repair_point = "v_repair_engine"
	self.truck.damage = {
		max_health = 2500,
	}
	self.truck.max_speed = 85
	self.truck.max_rpm = 5000
	self.truck.loot_drop_point = "v_loot_drop"
	self.truck.max_loot_bags = 200
	self.truck.interact_distance = 475
	self.truck.driver_camera_offset = Vector3(0, 2, 20)
	self.truck_ss = deep_clone(self.truck)
	self.truck_ss.unit = "units/vanilla/vehicles/fps_vehicle_truck_ss/fps_vehicle_truck_ss"
	self.truck_ss.seats.passenger_back_right.has_shooting_mode = false
	self.truck_ss.seats.passenger_back_left.has_shooting_mode = false
end

function VehicleTweakData:_init_data_foxhole()
	self.foxhole = {}
	self.foxhole.unit = "units/vanilla/vehicles/fps_foxhole/fps_foxhole"
	self.foxhole.name = "hud_foxhole"
	self.foxhole.hud_label_offset = 950
	self.foxhole.animations = {
		driver = "drive_kubelwagen_driver",
		vehicle_id = "kubelwagen",
	}
	self.foxhole.sound = {
		broken_engine = "occasional_silence",
		bump = "occasional_silence",
		bump_rtpc = "occasional_silence",
		bump_treshold = 8,
		door_close = "occasional_silence",
		engine_rpm_rtpc = "occasional_silence",
		engine_sound_event = "occasional_silence",
		engine_speed_rtpc = "occasional_silence",
		engine_start = "occasional_silence",
		engine_stop = "occasional_silence",
		gear_shift = "occasional_silence",
		going_reverse = "occasional_silence",
		going_reverse_stop = "occasional_silence",
		hit = "occasional_silence",
		hit_enemy = "car_hit_body_01",
		hit_rtpc = "occasional_silence",
		lateral_slip_treshold = 0.35,
		longitudal_slip_treshold = 0.8,
		slip = "occasional_silence",
		slip_stop = "car_skid_stop_01",
	}
	self.foxhole.seats = {
		driver = {
			camera_limits = {
				90,
				45,
			},
			driving = false,
			has_shooting_mode = false,
			name = "driver",
			next_seat = "driver",
		},
	}
	self.foxhole.loot_points = {
		loot = {
			name = "loot",
		},
	}
	self.foxhole.repair_point = "v_repair_engine"
	self.foxhole.trunk_point = "interact_trunk"
	self.foxhole.damage = {
		max_health = 100000,
	}
	self.foxhole.max_speed = 1
	self.foxhole.max_rpm = 2
	self.foxhole.loot_drop_point = "v_repair_engine"
	self.foxhole.max_loot_bags = 0
	self.foxhole.interact_distance = 350
	self.foxhole.driver_camera_offset = Vector3(0, 0.2, 15.5)
end
