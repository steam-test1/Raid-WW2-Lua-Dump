FireTweakData = FireTweakData or class()
FireTweakData.FIRE_TYPE_SINGLE = "single"
FireTweakData.FIRE_TYPE_PARENTED = "parented"
FireTweakData.FIRE_TYPE_HEX = "hex"
FireTweakData.FIRE_TYPE_LINE = "line"
FireTweakData.NETWORK_DAMAGE_MULTIPLIER = 163.84
FireTweakData.NETWORK_DAMAGE_LIMIT = 32768
FireTweakData.PROP_DAMAGE_LIMIT = 200
FireTweakData.PROP_DAMAGE_PRECISION = 0.25

function FireTweakData:init(tweak_data)
	self:_init_effects()
	self:_init_dot_types()
	self:_init_fires()

	self.character_fire_bones = {
		Idstring("Spine"),
		Idstring("LeftArm"),
		Idstring("RightArm"),
		Idstring("LeftLeg"),
		Idstring("RightLeg"),
	}
	self.death_effects = {}
	self.death_effects.default = {
		{
			duration = 9,
			effect = "character_9s",
		},
		{
			duration = 5,
			effect = "character_5s",
		},
		{
			duration = 5,
			effect = "character_5s",
		},
		{
			duration = 7,
			effect = "character_7s",
		},
		default = {
			duration = 3,
			effect = "character",
		},
	}
end

function FireTweakData:_init_effects()
	self.effects = {
		character = Idstring("effects/vanilla/fire/fire_character_burning_001"),
		character_5s = Idstring("effects/vanilla/fire/fire_character_burning_001_5s"),
		character_7s = Idstring("effects/vanilla/fire/fire_character_burning_001_7s"),
		character_9s = Idstring("effects/vanilla/fire/fire_character_burning_001_9s"),
		character_endless = Idstring("effects/vanilla/fire/fire_character_burning_001_endless"),
		molotov = Idstring("effects/vanilla/fire/fire_molotov_grenade_001"),
		thermite = Idstring("effects/upd_blaze/thermite_grenade_burn"),
		thermite_detonate = Idstring("effects/upd_blaze/thermite_grenade_explode"),
	}
end

function FireTweakData:_init_dot_types()
	self.dot_types = {}
	self.dot_types.default = {
		damage = 10,
		duration = 2,
		tick_interval = 0.5,
		trigger_chance = 35,
		trigger_max_distance = 3000,
		variant = "fire",
	}
	self.dot_types.thermite = {
		damage = 10,
		duration = 13,
		tick_interval = 0.5,
		trigger_chance = 68,
		trigger_max_distance = 3000,
		variant = "fire",
	}
end

function FireTweakData:_init_fires()
	self.explosive_barrel = {
		alert_radius = 1500,
		damage = 15,
		dot_type = "default",
		duration = 20,
		effect_name = self.effects.molotov,
		iterations = 4,
		player_damage = 5,
		range = 65,
		sound_burning = "burn_loop_body",
		sound_burning_stop = "burn_loop_body_stop",
		sound_impact = "grenade_explode",
		sound_impact_duration = 0.6,
		tick_interval = 0.665,
		type = self.FIRE_TYPE_HEX,
	}
	self.flamer_tank = clone(self.explosive_barrel)
	self.flamer_tank.duration = 10
	self.flamer_tank.iterations = 6
	self.flamer_tank.range = 75
	self.flamer_tank.sound_impact = nil
	self.flamer_tank.sound_impact_duration = 0.3
	self.thermite_grenade = {
		alert_radius = 750,
		damage = 10,
		dot_type = "thermite",
		duration = 35,
		effect_name = self.effects.thermite,
		player_damage = 3,
		range = 380,
		sound_burning = "cvy_thermite_glow",
		sound_burning_stop = "cvy_thermite_finish",
		tick_interval = 0.875,
		type = self.FIRE_TYPE_PARENTED,
	}
	self.thermite_detonate = {
		alert_radius = 1400,
		damage = 30,
		dot_type = "thermite",
		duration = 1,
		effect_name = self.effects.thermite_detonate,
		player_damage = 5,
		range = 500,
		tick_interval = 0.3333,
		type = self.FIRE_TYPE_SINGLE,
	}
end
