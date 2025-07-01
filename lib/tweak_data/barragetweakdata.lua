BarrageTweakData = BarrageTweakData or class()
BarrageType = {}
BarrageType.ARTILLERY = 1
BarrageType.AIRPLANE = 2
BarrageType.RANDOM = 3

function BarrageTweakData:init(tweak_data)
	local difficulty = Global.game_settings and Global.game_settings.difficulty or Global.DEFAULT_DIFFICULTY
	local difficulty_index = tweak_data:difficulty_to_index(difficulty)

	self.default = {}
	self.default.type = BarrageType.ARTILLERY
	self.default.direction = Vector3(-0.33, 0, -0.33)
	self.default.distance = 16000
	self.default.projectile_id = "mortar_shell"
	self.default.lauch_power = 36
	self.default.area_radius = {
		1200,
		1000,
		900,
	}
	self.default.cooldown = {
		140,
		130,
		120,
	}
	self.default.initial_delay = 3.5
	self.default.barrage_launch_sound_delay = 3.5
	self.default.barrage_launch_sound_event = "grenade_launcher"

	if difficulty_index <= TweakData.DIFFICULTY_1 then
		self.default.projectiles_per_minute = {
			30,
			30,
			30,
		}
		self.flare_timer = 15
		self.default.duration = {
			10,
			15,
			20,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_2 then
		self.default.projectiles_per_minute = {
			30,
			35,
			40,
		}
		self.flare_timer = 12
		self.default.duration = {
			10,
			15,
			20,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_3 then
		self.default.projectiles_per_minute = {
			30,
			40,
			45,
		}
		self.flare_timer = 10
		self.default.duration = {
			12,
			17,
			22,
		}
	elseif difficulty_index == TweakData.DIFFICULTY_4 then
		self.default.projectiles_per_minute = {
			35,
			40,
			50,
		}
		self.flare_timer = 8
		self.default.duration = {
			14,
			19,
			24,
		}
	end

	self.blimp_barrage = deep_clone(self.default)
	self.blimp_barrage.launch_from = "blimp"
	self.blimp_barrage.direction = nil
	self.blimp_barrage.area_radius = {
		1000,
		600,
		1200,
	}
	self.blimp_barrage.lauch_power = 35
	self.blimp_barrage.projectiles_per_minute = {
		90,
		100,
		120,
	}
	self.blimp_barrage.duration = {
		30,
		30,
		30,
	}
	self.blimp_barrage.initial_delay = 1
	self.blimp_barrage.barrage_launch_sound_delay = 0.1
	self.spotted_arty = clone(self.default)
	self.spotted_arty.direction = Vector3(0, 0, -1)
	self.spotted_arty.spotting_rounds = 0
	self.spotted_arty.area_radius = {
		900,
		700,
		800,
	}
	self.spotted_arty.spotting_rounds_delay = 5
	self.spotted_arty.spotting_rounds_min_distance = 1000
	self.spotted_arty.initial_delay = 0
	self.spotted_arty.cooldown = {
		60,
		40,
		20,
	}
	self.spotted_arty.barrage_launch_sound_delay = 7.5
	self.spotted_arty.barrage_launch_sound_event = "grenade_launcher"
	self.stuka_strafe = {}
	self.stuka_strafe.type = BarrageType.AIRPLANE
	self.stuka_strafe.airplane_unit = Idstring("units/vanilla/vehicles/vhc_junkers_attack/vhc_junkers_attack")
	self.stuka_strafe.sequence_name = "anim_machinegun_attack"
	self.stuka_strafe.cooldown = {
		5,
		4,
		3,
	}
	self.stuka_bomb = {}
	self.stuka_bomb.type = BarrageType.AIRPLANE
	self.stuka_bomb.airplane_unit = Idstring("units/vanilla/vehicles/vhc_junkers_ju87_anim/vhc_junkers_ju87_anim")
	self.stuka_bomb.sequence_name = "anim_drop_bomb"
	self.stuka_bomb.cooldown = {
		30,
		20,
		10,
	}
	self.napalm = {}
	self.napalm.type = BarrageType.ARTILLERY
	self.napalm.direction = Vector3(0, 0, -1)
	self.napalm.area_radius = {
		1500,
		1200,
		1000,
	}
	self.napalm.projectile_id = "molotov"
	self.napalm.lauch_power = 20
	self.napalm.duration = {
		10,
		12,
		15,
	}
	self.napalm.projectiles_per_minute = {
		90,
		100,
		120,
	}
	self.napalm.cooldown = {
		15,
		12.5,
		10,
	}
	self.napalm.initial_delay = 8
	self.napalm.barrage_launch_sound_delay = 7.5
	self.napalm.barrage_launch_sound_event = "grenade_launcher"
	self.cluster = {}
	self.cluster.type = BarrageType.ARTILLERY
	self.cluster.direction = Vector3(0, 0, -1)
	self.cluster.area_radius = {
		900,
		700,
		800,
	}
	self.cluster.projectile_id = "mortar_shell"
	self.cluster.lauch_power = 15
	self.cluster.duration = {
		20,
		25,
		30,
	}
	self.cluster.projectiles_per_minute = {
		70,
		70,
		75,
	}
	self.cluster.cooldown = {
		45,
		30,
		20,
	}
	self.cluster.initial_delay = 8
	self.cluster.barrage_launch_sound_delay = 7.5
	self.cluster.barrage_launch_sound_event = "grenade_launcher"
	self.random = {}
	self.random.type = BarrageType.RANDOM
	self.random.type_table = {
		cluster = {
			4,
			5,
			8,
		},
		stuka_bomb = {
			8,
			4,
			2,
		},
	}
end

function BarrageTweakData:get_barrage_ids()
	local t = {}

	for id, _ in pairs(tweak_data.barrage) do
		if type(tweak_data.barrage[id]) == "table" then
			table.insert(t, id)
		end
	end

	table.sort(t)

	return t
end
