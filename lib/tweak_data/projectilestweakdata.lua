ProjectilesTweakData = ProjectilesTweakData or class()

function ProjectilesTweakData:init(tweak_data)
	self.GRENADE_QUANTITY_UPGARDE = {
		{
			category = "player",
			upgrade = "grenadier_grenade_quantity",
		},
		{
			category = "player",
			upgrade = "pack_mule_equipment_quantity",
		},
	}
	self.MINE_QUANTITY_UPGARDE = {
		{
			category = "player",
			upgrade = "sapper_mine_quantity",
		},
		{
			category = "player",
			upgrade = "pack_mule_equipment_quantity",
		},
	}
	self._projectiles_index = {}

	self:_init_m24(tweak_data)
	self:_init_cluster(tweak_data)
	self:_init_molotov(tweak_data)
	self:_init_mortar_shell(tweak_data)
	self:_init_flamer_death_fake(tweak_data)
	self:_init_concrete(tweak_data)
	self:_init_d343(tweak_data)
	self:_init_mills(tweak_data)
	self:_init_decoy_coin(tweak_data)
	self:_init_betty(tweak_data)
	self:_add_desc_from_name_macro(self)
end

function ProjectilesTweakData:_init_m24(tweak_data)
	self.m24 = {}
	self.m24.name_id = "bm_grenade_frag"
	self.m24.weapon_id = "m24_grenade"
	self.m24.unit = "units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24"
	self.m24.unit_hand = "units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24_hand"
	self.m24.unit_dummy = "units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24_husk"
	self.m24.icon = "frag_grenade"
	self.m24.anim_global_param = "projectile_frag"
	self.m24.throwable = true
	self.m24.max_amount = 3
	self.m24.pickup_filter = "grenades"
	self.m24.upgrade_amounts = self.GRENADE_QUANTITY_UPGARDE
	self.m24.throw_allowed_expire_t = 0.662
	self.m24.expire_t = 0.455
	self.m24.repeat_expire_t = 1
	self.m24.is_a_grenade = true
	self.m24.damage = 600
	self.m24.player_damage = 20
	self.m24.range = 850
	self.m24.can_airburst = true
	self.m24.enemy_proximity_range = self.m24.range * 0.6
	self.m24.killzone_range = 0.33
	self.m24.init_timer = 4.5
	self.m24.animations = {}
	self.m24.animations.equip_id = "equip_welrod"
	self.m24.sound_event = "grenade_explode"
	self.m24.launch_speed = 350
	self.m24.gui = {}
	self.m24.gui.rotation_offset = 3
	self.m24.gui.distance_offset = -80
	self.m24.gui.height_offset = -14
	self.m24.gui.display_offset = 10
	self.m24.gui.initial_rotation = {}
	self.m24.gui.initial_rotation.yaw = -90
	self.m24.gui.initial_rotation.pitch = 60
	self.m24.gui.initial_rotation.roll = 0

	table.insert(self._projectiles_index, "m24")
end

function ProjectilesTweakData:_init_concrete(tweak_data)
	self.concrete = {}
	self.concrete.name_id = "bm_grenade_concrete"
	self.concrete.unit = "units/upd_001/weapons/wpn_fps_gre_concrete/wpn_fps_gre_concrete"
	self.concrete.unit_hand = "units/upd_001/weapons/wpn_fps_gre_concrete/wpn_fps_gre_concrete_hand"
	self.concrete.unit_dummy = "units/upd_001/weapons/wpn_fps_gre_concrete/wpn_fps_gre_concrete_husk"
	self.concrete.icon = "frag_grenade"
	self.concrete.throwable = true
	self.concrete.max_amount = 3
	self.concrete.pickup_filter = "grenades"
	self.concrete.upgrade_amounts = self.GRENADE_QUANTITY_UPGARDE
	self.concrete.anim_global_param = "projectile_frag"
	self.concrete.throw_allowed_expire_t = 0.662
	self.concrete.expire_t = 0.455
	self.concrete.repeat_expire_t = 1.5
	self.concrete.is_a_grenade = true
	self.concrete.damage = 800
	self.concrete.player_damage = 20
	self.concrete.range = 900
	self.concrete.can_airburst = true
	self.concrete.enemy_proximity_range = self.concrete.range * 0.6
	self.concrete.killzone_range = 0.33
	self.concrete.init_timer = 4.5
	self.concrete.animations = {}
	self.concrete.animations.equip_id = "equip_welrod"
	self.concrete.sound_event = "new_grenade_explode"
	self.concrete.launch_speed = 275
	self.concrete.gui = {}
	self.concrete.gui.rotation_offset = 3
	self.concrete.gui.distance_offset = -80
	self.concrete.gui.height_offset = -14
	self.concrete.gui.display_offset = 10
	self.concrete.gui.initial_rotation = {}
	self.concrete.gui.initial_rotation.yaw = -90
	self.concrete.gui.initial_rotation.pitch = 60
	self.concrete.gui.initial_rotation.roll = 0

	table.insert(self._projectiles_index, "concrete")
end

function ProjectilesTweakData:_init_d343(tweak_data)
	self.d343 = {}
	self.d343.name_id = "bm_grenade_d343"
	self.d343.unit = "units/upd_003/weapons/wpn_fps_gre_d343/wpn_fps_gre_d343"
	self.d343.unit_hand = "units/upd_003/weapons/wpn_fps_gre_d343/wpn_fps_gre_d343_hand"
	self.d343.unit_dummy = "units/upd_003/weapons/wpn_fps_gre_d343/wpn_fps_gre_d343_husk"
	self.d343.icon = "frag_grenade"
	self.d343.throwable = true
	self.d343.pickup_filter = "grenades"
	self.d343.max_amount = 4
	self.d343.upgrade_amounts = self.GRENADE_QUANTITY_UPGARDE
	self.d343.anim_global_param = "projectile_frag"
	self.d343.throw_allowed_expire_t = 0.662
	self.d343.expire_t = 0.455
	self.d343.repeat_expire_t = 1.5
	self.d343.is_a_grenade = true
	self.d343.can_airburst = true
	self.d343.damage = 850
	self.d343.player_damage = 20
	self.d343.range = 900
	self.d343.enemy_proximity_range = self.d343.range * 0.6
	self.d343.killzone_range = 0.33
	self.d343.init_timer = 4.5
	self.d343.animations = {}
	self.d343.animations.equip_id = "equip_welrod"
	self.d343.sound_event = "d43d_grenade_explode"
	self.d343.launch_speed = 210
	self.d343.gui = {}
	self.d343.gui.rotation_offset = 0
	self.d343.gui.distance_offset = -120
	self.d343.gui.height_offset = -8
	self.d343.gui.display_offset = 16
	self.d343.gui.initial_rotation = {}
	self.d343.gui.initial_rotation.yaw = 0
	self.d343.gui.initial_rotation.pitch = 90
	self.d343.gui.initial_rotation.roll = 30

	table.insert(self._projectiles_index, "d343")
end

function ProjectilesTweakData:_init_mills(tweak_data)
	self.mills = {}
	self.mills.name_id = "bm_grenade_mills"
	self.mills.unit = "units/upd_015/weapons/wpn_fps_gre_mills/wpn_fps_gre_mills"
	self.mills.unit_hand = "units/upd_015/weapons/wpn_fps_gre_mills/wpn_fps_gre_mills_hand"
	self.mills.unit_dummy = "units/upd_015/weapons/wpn_fps_gre_mills/wpn_fps_gre_mills_husk"
	self.mills.icon = "frag_grenade"
	self.mills.throwable = true
	self.mills.max_amount = 3
	self.mills.pickup_filter = "grenades"
	self.mills.upgrade_amounts = self.GRENADE_QUANTITY_UPGARDE
	self.mills.anim_global_param = "projectile_frag"
	self.mills.throw_allowed_expire_t = 0.662
	self.mills.expire_t = 0.455
	self.mills.repeat_expire_t = 1.5
	self.mills.is_a_grenade = true
	self.mills.can_airburst = true
	self.mills.damage = 900
	self.mills.player_damage = 20
	self.mills.range = 700
	self.mills.enemy_proximity_range = self.mills.range * 0.6
	self.mills.killzone_range = 0.33
	self.mills.init_timer = 4.5
	self.mills.animations = {}
	self.mills.animations.equip_id = "equip_welrod"
	self.mills.sound_event = "mills_grenade_explode"
	self.mills.launch_speed = 210
	self.mills.gui = {}
	self.mills.gui.rotation_offset = 0
	self.mills.gui.distance_offset = -120
	self.mills.gui.height_offset = -8
	self.mills.gui.display_offset = 16
	self.mills.gui.initial_rotation = {}
	self.mills.gui.initial_rotation.yaw = -90
	self.mills.gui.initial_rotation.pitch = 60
	self.mills.gui.initial_rotation.roll = 0

	table.insert(self._projectiles_index, "mills")
end

function ProjectilesTweakData:_init_betty(tweak_data)
	self.betty = {}
	self.betty.name_id = "bm_grenade_betty"
	self.betty.unit = "units/upd_021/weapons/wpn_fps_gre_betty/wpn_fps_gre_betty"
	self.betty.unit_hand = "units/upd_021/weapons/wpn_fps_gre_betty/wpn_fps_gre_betty_hand"
	self.betty.unit_dummy = "units/upd_021/weapons/wpn_fps_gre_betty/wpn_fps_gre_betty_husk"
	self.betty.icon = "frag_grenade"
	self.betty.throwable = true
	self.betty.instant_throw = true
	self.betty.max_amount = 2
	self.betty.pickup_filter = "grenades"
	self.betty.upgrade_amounts = self.MINE_QUANTITY_UPGARDE
	self.betty.anim_global_param = "projectile_frag"
	self.betty.throw_allowed_expire_t = 0
	self.betty.expire_t = 0.46
	self.betty.repeat_expire_t = 1
	self.betty.is_a_grenade = true
	self.betty.damage = 750
	self.betty.player_damage = 35
	self.betty.range = 550
	self.betty.killzone_range = 0.5
	self.betty.init_timer = 3
	self.betty.animations = {}
	self.betty.animations.equip_id = "equip_welrod"
	self.betty.sound_event = "mills_grenade_explode"
	self.betty.launch_speed = 150
	self.betty.enemy_proximity_range = 200
	self.betty.enemy_proximity_delay = 0.44
	self.betty.jumpmine_velocity = 350
	self.betty.gui = {}
	self.betty.gui.rotation_offset = 0
	self.betty.gui.distance_offset = -120
	self.betty.gui.height_offset = -8
	self.betty.gui.display_offset = 16
	self.betty.gui.initial_rotation = {}
	self.betty.gui.initial_rotation.yaw = -90
	self.betty.gui.initial_rotation.pitch = 60
	self.betty.gui.initial_rotation.roll = 0

	table.insert(self._projectiles_index, "betty")
end

function ProjectilesTweakData:_init_cluster(tweak_data)
	self.cluster = {}
	self.cluster.name_id = "bm_grenade_frag"
	self.cluster.unit = "units/vanilla/dev/dev_shrapnel/dev_shrapnel"
	self.cluster.unit_dummy = "units/vanilla/dev/dev_shrapnel/dev_shrapnel_husk"
	self.cluster.throwable = false
	self.cluster.impact_detonation = true
	self.cluster.max_amount = 3
	self.cluster.anim_global_param = "projectile_frag"
	self.cluster.killzone_range = 0.33
	self.cluster.is_a_grenade = true
	self.cluster.damage = 250
	self.cluster.player_damage = 3
	self.cluster.range = 250
	self.cluster.launch_speed = 2
	self.cluster.adjust_z_range = {
		1,
		1.8,
	}
	self.cluster.animations = {}
	self.cluster.animations.equip_id = "equip_welrod"

	table.insert(self._projectiles_index, "cluster")
end

function ProjectilesTweakData:_init_ammo_bag(tweak_data)
	self.ammo_bag = {}
	self.ammo_bag.name_id = "bm_grenade_frag"
	self.ammo_bag.unit = "units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24"
	self.ammo_bag.unit_hand = "units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24_hand"
	self.ammo_bag.unit_dummy = "units/vanilla/weapons/wpn_gre_m24/wpn_gre_m24_husk"
	self.ammo_bag.icon = "frag_grenade"
	self.ammo_bag.throwable = true
	self.ammo_bag.max_amount = 3
	self.ammo_bag.anim_global_param = "projectile_frag"
	self.ammo_bag.throw_allowed_expire_t = 0
	self.ammo_bag.expire_t = 1.1
	self.ammo_bag.repeat_expire_t = 1.5
	self.ammo_bag.is_a_grenade = false
	self.ammo_bag.damage = 0
	self.ammo_bag.player_damage = 0
	self.ammo_bag.range = 1000
	self.ammo_bag.init_timer = 4.5
	self.ammo_bag.push_at_body_index = 0
	self.ammo_bag.animations = {}
	self.ammo_bag.animations.equip_id = "equip_welrod"

	table.insert(self._projectiles_index, "ammo_bag")
end

function ProjectilesTweakData:_init_molotov(tweak_data)
	self.molotov = {}
	self.molotov.name_id = "bm_grenade_molotov"
	self.molotov.icon = "molotov_grenade"
	self.molotov.no_cheat_count = true
	self.molotov.impact_detonation = true
	self.molotov.time_cheat = 1
	self.molotov.throwable = false
	self.molotov.max_amount = 3
	self.molotov.upgrade_amounts = self.GRENADE_QUANTITY_UPGARDE
	self.molotov.texture_bundle_folder = "bbq"
	self.molotov.physic_effect = tweak_data.physics_effects.molotov_throw
	self.molotov.anim_global_param = "projectile_molotov"
	self.molotov.throw_allowed_expire_t = 0.662
	self.molotov.expire_t = 0.46
	self.molotov.repeat_expire_t = 1.5
	self.molotov.is_a_grenade = true
	self.molotov.init_timer = 10
	self.molotov.damage = 15
	self.molotov.player_damage = 5
	self.molotov.fire_dot_data = {
		dot_damage = 10,
		dot_length = 2.01,
		dot_tick_period = 0.5,
		dot_trigger_chance = 35,
		dot_trigger_max_distance = 3000,
	}
	self.molotov.range = 75
	self.molotov.killzone_range = 0
	self.molotov.burn_duration = 20
	self.molotov.burn_tick_period = 0.665
	self.molotov.sound_event_impact_duration = 4
	self.molotov.alert_radius = 1500
	self.molotov.fire_alert_radius = 1500
	self.molotov.animations = {}
	self.molotov.animations.equip_id = "equip_welrod"

	table.insert(self._projectiles_index, "molotov")
end

function ProjectilesTweakData:_init_decoy_coin(tweak_data)
	self.decoy_coin = {}
	self.decoy_coin.name_id = "bm_coin"
	self.decoy_coin.unit = "units/vanilla/weapons/wpn_fps_decoy_coin_peace/wpn_decoy_coin_peace"
	self.decoy_coin.unit_hand = "units/vanilla/weapons/wpn_fps_decoy_coin_peace/wpn_decoy_coin_peace_hand"
	self.decoy_coin.unit_dummy = "units/vanilla/weapons/wpn_fps_decoy_coin_peace/wpn_decoy_coin_peace_husk"
	self.decoy_coin.icon = "frag_grenade"
	self.decoy_coin.max_amount = 5
	self.decoy_coin.upgrade_amount = {
		category = "player",
		upgrade = "pack_mule_equipment_quantity",
	}
	self.decoy_coin.pickup_filter = "coins"
	self.decoy_coin.is_a_grenade = true
	self.decoy_coin.throwable = true
	self.decoy_coin.instant_throw = true
	self.decoy_coin.impact_detonation = true
	self.decoy_coin.remove_on_impact = false
	self.decoy_coin.attach_on_collision = false
	self.decoy_coin.anim_global_param = "projectile_molotov"
	self.decoy_coin.throw_allowed_expire_t = 0
	self.decoy_coin.expire_t = 0.46
	self.decoy_coin.repeat_expire_t = 1
	self.decoy_coin.range = 1000
	self.decoy_coin.launch_speed = 200
	self.decoy_coin.damage = 15
	self.decoy_coin.headshot_multiplier = 3
	self.decoy_coin.animations = {}
	self.decoy_coin.animations.equip_id = "equip_welrod"
	self.decoy_coin.gui = {}
	self.decoy_coin.gui.rotation_offset = 0
	self.decoy_coin.gui.distance_offset = -160
	self.decoy_coin.gui.height_offset = -14
	self.decoy_coin.gui.display_offset = 22
	self.decoy_coin.gui.initial_rotation = {}
	self.decoy_coin.gui.initial_rotation.yaw = 150
	self.decoy_coin.gui.initial_rotation.pitch = 8
	self.decoy_coin.gui.initial_rotation.roll = 0

	table.insert(self._projectiles_index, "decoy_coin")
end

function ProjectilesTweakData:_init_mortar_shell(tweak_data)
	self.mortar_shell = {}
	self.mortar_shell.name_id = "bm_mortar_shell"
	self.mortar_shell.unit = "units/vanilla/weapons/wpn_npc_proj_mortar_shell/wpn_npc_proj_mortar_shell"
	self.mortar_shell.unit_dummy = "units/vanilla/weapons/wpn_npc_proj_mortar_shell/wpn_npc_proj_mortar_shell_husk"
	self.mortar_shell.weapon_id = "mortar_shell"
	self.mortar_shell.no_cheat_count = false
	self.mortar_shell.impact_detonation = true
	self.mortar_shell.physic_effect = tweak_data.physics_effects.no_gravity
	self.mortar_shell.adjust_z = 0
	self.mortar_shell.push_at_body_index = 0
	self.mortar_shell.init_timer = 5
	self.mortar_shell.damage = 75
	self.mortar_shell.player_damage = 25
	self.mortar_shell.range = 2400
	self.mortar_shell.killzone_range = 0.33
	self.mortar_shell.init_timer = 15
	self.mortar_shell.effect_name = "effects/vanilla/explosions/exp_artillery_explosion_001"
	self.mortar_shell.sound_event = "grenade_launcher_explosion"
	self.mortar_shell.sound_event_impact_duration = 4

	table.insert(self._projectiles_index, "mortar_shell")
end

function ProjectilesTweakData:_init_flamer_death_fake(tweak_data)
	self.flamer_death_fake = clone(self.molotov)
	self.flamer_death_fake.init_timer = 0.01
	self.flamer_death_fake.adjust_z = 0
	self.flamer_death_fake.throwable = false
	self.flamer_death_fake.unit = "units/vanilla/dev/flamer_death_fake/flamer_death_fake"
	self.flamer_death_fake.unit_dummy = "units/vanilla/dev/flamer_death_fake/flamer_death_fake_husk"
	self.flamer_death_fake.burn_duration = 10
	self.flamer_death_fake.sound_event_impact_duration = 1

	table.insert(self._projectiles_index, "flamer_death_fake")
end

function BlackMarketTweakData:get_projectiles_index()
	return tweak_data.projectiles._projectiles_index
end

function BlackMarketTweakData:get_index_from_projectile_id(projectile_id)
	for index, entry_name in ipairs(tweak_data.projectiles._projectiles_index) do
		if entry_name == projectile_id then
			return index
		end
	end

	return 0
end

function BlackMarketTweakData:get_projectile_name_from_index(index)
	return tweak_data.projectiles._projectiles_index[index]
end

function ProjectilesTweakData:_add_desc_from_name_macro(tweak_data)
	for id, data in pairs(tweak_data) do
		if data.name_id and not data.desc_id then
			data.desc_id = tostring(data.name_id) .. "_desc"
		end

		if not data.name_id then
			-- block empty
		end
	end
end
