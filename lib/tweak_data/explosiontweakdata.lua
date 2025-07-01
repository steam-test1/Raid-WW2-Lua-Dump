ExplosionTweakData = ExplosionTweakData or class()

function ExplosionTweakData:init(tweak_data)
	self.explosive_barrel = {
		curve_pow = 3,
		damage = 650,
		effect_params = {
			camera_shake_mul = 4,
			effect = "effects/vanilla/explosions/exp_fire_barrel_001",
		},
		player_damage = 80,
		range = 650,
	}
	self.explosive_barrel_small = {
		curve_pow = 2,
		damage = 550,
		player_damage = 65,
		range = 550,
	}
	self.flamer_tank = {
		curve_pow = 3,
		damage = 3000,
		effect_params = {
			sound_event = "explosive_barrel_destruction",
		},
		player_damage = 100,
		range = 500,
	}
	self.thermite_detonate = {
		curve_pow = 0.1,
		damage = 60,
		effect_params = {
			camera_shake_mul = 2,
			effect = "effects/upd_blaze/thermite_grenade_explode",
			sound_event = "thermite_grenade_explode",
		},
		player_damage = 0,
		range = 600,
	}
end
