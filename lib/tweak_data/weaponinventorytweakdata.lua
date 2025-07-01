WeaponInventoryTweakData = WeaponInventoryTweakData or class()

function WeaponInventoryTweakData:init()
	self.weapon_primaries_index = {
		{
			slot = 1,
			weapon_id = "m1903",
		},
		{
			slot = 2,
			weapon_id = "carbine",
		},
		{
			slot = 3,
			weapon_id = "sten",
		},
		{
			slot = 4,
			weapon_id = "m1912",
		},
		{
			slot = 5,
			weapon_id = "thompson",
		},
		{
			slot = 6,
			weapon_id = "garand",
		},
		{
			slot = 7,
			weapon_id = "m1918",
		},
	}
	self.weapon_secondaries_index = {
		{
			slot = 1,
			weapon_id = "c96",
		},
	}
	self.weapon_grenades_index = {
		{
			default = true,
			slot = 1,
			weapon_id = "m24",
		},
	}
	self.weapon_melee_index = {
		{
			default = true,
			droppable = false,
			redeemed_xp = 0,
			slot = 1,
			weapon_id = "m3_knife",
		},
		{
			droppable = true,
			redeemed_xp = 50,
			slot = 2,
			weapon_id = "bc41_knuckle_knife",
		},
	}
end
