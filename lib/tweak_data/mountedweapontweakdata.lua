MountedWeaponTweakData = MountedWeaponTweakData or class()

function MountedWeaponTweakData:init(tweak_data)
	self:_init_data_sherman()
	self:_init_data_tiger()
	self:_init_data_luchs()
end

function MountedWeaponTweakData:_init_data_sherman()
	self.sherman = {}
	self.sherman.sound = {
		main_cannon_fire = "Play_sherman_canon",
		main_cannon_fire_hit = "",
	}
	self.sherman.effect = {
		main_cannon_fire = "effects/vanilla/explosions/vehicle_explosion",
		main_cannon_fire_hit = "effects/vanilla/explosions/vehicle_explosion",
	}
	self.sherman.turret = {
		armor_piercing = true,
		damage = 20,
		damage_radius = 1000,
		gun_locator = "anim_gun",
		locator = "anim_turret",
		player_damage = 10,
		range = 20000,
		traverse_time = 10,
	}
	self.sherman.main_cannon_shell_speed = 60000
	self.sherman.main_cannon_reload_speed = 5
end

function MountedWeaponTweakData:_init_data_tiger()
	self.tiger = {}
	self.tiger.sound = {
		main_cannon_fire = "Play_tiger_canon",
		main_cannon_fire_hit = "",
	}
	self.tiger.effect = {
		main_cannon_fire = "effects/vanilla/explosions/vehicle_explosion",
		main_cannon_fire_hit = "effects/vanilla/explosions/vehicle_explosion",
	}
	self.tiger.turret = {
		armor_piercing = true,
		damage = 50,
		damage_radius = 1000,
		gun_locator = "anim_gun",
		locator = "anim_turret",
		player_damage = 10,
		range = 20000,
		traverse_time = 10,
	}
	self.tiger.main_cannon_shell_speed = 60000
	self.tiger.main_cannon_reload_speed = 5
end

function MountedWeaponTweakData:_init_data_luchs()
	self.luchs = {}
	self.luchs.sound = {
		main_cannon_fire = "Play_luchs_canon",
		main_cannon_fire_hit = "",
	}
	self.luchs.effect = {
		main_cannon_fire = "effects/vanilla/explosions/vehicle_explosion",
		main_cannon_fire_hit = "effects/vanilla/explosions/vehicle_explosion",
	}
	self.luchs.turret = {
		armor_piercing = true,
		damage = 20,
		damage_radius = 1000,
		gun_locator = "anim_turret_pitch",
		locator = "anim_turret_heading",
		player_damage = 10,
		range = 20000,
		traverse_time = 10,
	}
	self.luchs.main_cannon_shell_speed = 60000
	self.luchs.main_cannon_reload_speed = 5
end
