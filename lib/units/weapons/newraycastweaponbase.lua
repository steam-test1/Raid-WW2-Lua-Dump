local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_sub = mvector3.subtract
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_len = mvector3.length
local mvec3_cross = mvector3.cross
local math_clamp = math.clamp
local math_lerp = math.lerp
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()

NewRaycastWeaponBase = NewRaycastWeaponBase or class(RaycastWeaponBase)

require("lib/units/weapons/CosmeticsWeaponBase")

function NewRaycastWeaponBase:init(unit)
	NewRaycastWeaponBase.super.init(self, unit)
	unit:set_extension_update_enabled(Idstring("base"), true)

	self._crit_reserve = 0
	self._gadgets = nil
	self._armor_piercing_chance = self:weapon_tweak_data().armor_piercing_chance or 0
	self._use_shotgun_reload = self:weapon_tweak_data().use_shotgun_reload
	self._movement_penalty = tweak_data.upgrades.weapon_movement_penalty[self:weapon_tweak_data().category] or 1
	self._gun_kick = {
		x = {
			delta = 0,
			velocity = 0,
		},
		y = {
			delta = 0,
			velocity = 0,
		},
	}
	self._texture_switches = {}
	self._parts_texture_switches = {}
	self._textures = {}
	self._cosmetics_data = nil
	self._materials = nil
	self._highlight_enemy = managers.player:has_category_upgrade("player", "highlight_enemy")
end

function NewRaycastWeaponBase:is_npc()
	return false
end

function NewRaycastWeaponBase:skip_queue()
	return false
end

function NewRaycastWeaponBase:set_texture_switches(texture_switches)
	self._texture_switches = texture_switches
end

function NewRaycastWeaponBase:set_factory_data(factory_id)
	self._factory_id = factory_id
end

function NewRaycastWeaponBase:_third_person()
	return self:is_npc()
end

function NewRaycastWeaponBase:assemble(factory_id)
	local third_person = self:_third_person()
	local skip_queue = self:skip_queue()

	self._parts, self._blueprint = managers.weapon_factory:assemble_default(factory_id, self._unit, third_person, callback(self, self, "clbk_assembly_complete", function()
		return
	end), skip_queue)

	self:_update_stats_values()
end

function NewRaycastWeaponBase:assemble_from_blueprint(factory_id, blueprint, clbk)
	local third_person = self:_third_person()
	local skip_queue = self:skip_queue()

	self._parts, self._blueprint = managers.weapon_factory:assemble_from_blueprint(factory_id, self._unit, blueprint, third_person, callback(self, self, "clbk_assembly_complete", clbk or function()
		return
	end), skip_queue)

	self:_update_stats_values()
end

function NewRaycastWeaponBase:clbk_assembly_complete(clbk, parts, blueprint)
	self._assembly_complete = true
	self._parts = parts
	self._blueprint = blueprint

	self:_update_fire_object()
	self:_update_stats_values()

	if self._setup and self._setup.timer then
		self:set_timer(self._setup.timer)
	end

	self:_setup_magazine()
	self:_apply_cosmetics(clbk or function()
		return
	end)
	self:apply_texture_switches()
	self:check_npc()
	self:set_parts_enabled(self._enabled)
	clbk()
end

function NewRaycastWeaponBase:_setup_magazine()
	local magazine = managers.weapon_factory:get_part_from_weapon_by_type("magazine", self._parts)

	if magazine then
		local bullet_objects = managers.weapon_factory:get_part_data_type_from_weapon_by_type("magazine", "bullet_objects", self._parts)

		if bullet_objects then
			self._bullet_objects = {}

			local prefix = bullet_objects.prefix

			for i = 1, bullet_objects.amount do
				local object = magazine.unit:get_object(Idstring(prefix .. i))

				if object then
					self._bullet_objects[i] = self._bullet_objects[i] or {}

					table.insert(self._bullet_objects[i], object)
				end
			end
		end

		if not self._hud_class_override then
			local hud_class_override = managers.weapon_factory:get_part_data_type_from_weapon_by_type("magazine", "hud_class_override", self._parts)

			if hud_class_override then
				self._hud_class_override = hud_class_override
			end
		end
	end

	if not self._bullet_objects or #self._bullet_objects == 0 then
		local ammo = managers.weapon_factory:get_part_from_weapon_by_type("ammo", self._parts)

		if ammo then
			local bullet_objects = managers.weapon_factory:get_part_data_type_from_weapon_by_type("ammo", "bullet_objects", self._parts)

			if bullet_objects then
				self._bullet_objects = {}

				local prefix = bullet_objects.prefix

				for i = 1, bullet_objects.amount do
					local object = ammo.unit:get_object(Idstring(prefix .. i))

					if object then
						self._bullet_objects[i] = self._bullet_objects[i] or {}

						table.insert(self._bullet_objects[i], object)
					end
				end
			end
		end
	end
end

function NewRaycastWeaponBase:get_weapon_hud_type()
	return self._hud_class_override
end

function NewRaycastWeaponBase:apply_texture_switches()
	if not self._parts then
		Application:stack_dump_error("[NewRaycastWeaponBase:apply_modified_textures] Cannot texture, parts must be assembled, or at least contain a parts list first!")

		return
	end

	if self._texture_switches then
		for part_id, texture_data in pairs(self._texture_switches) do
			self:apply_modified_textures(part_id, texture_data)
		end
	end

	local parts_tweak = tweak_data.weapon.factory.parts
	local skin_texture_switches = {}

	for part_id, part_data in pairs(self._parts) do
		skin_texture_switches[part_id] = parts_tweak[part_id][self:is_npc() and "materials_tps" or "materials_fps"]
	end

	if skin_texture_switches then
		for part_id, texture_data in pairs(skin_texture_switches) do
			self:apply_modified_textures(part_id, texture_data)
		end
	end
end

function NewRaycastWeaponBase:apply_modified_textures(part_id, texture_data)
	local parts_tweak = tweak_data.weapon.factory.parts

	self._parts_texture_switches = self._parts_texture_switches or {}

	if self._parts_texture_switches[part_id] == texture_data then
		return
	end

	local unique_materials = parts_tweak[part_id] and parts_tweak[part_id].unique_materials
	local part_data = self._parts and self._parts[part_id]

	if not part_data or not unique_materials then
		Application:warn("[NewRaycastWeaponBase:apply_modified_textures] Part lacks unique_materials table, part will not be modified!", part_id)

		return
	end

	local unit = part_data.unit
	local material_config = unit:get_objects_by_type(IDS_MATERIAL)

	for _, material_str in ipairs(unique_materials) do
		if texture_data[material_str] then
			local material_ids = Idstring(material_str)

			for _, material in ipairs(material_config) do
				if material:name() == material_ids and texture_data[material_str] then
					for channel, texture_id in pairs(texture_data[material_str]) do
						if texture_id and DB:has(Idstring("texture"), texture_id) then
							local retrieved_texture = TextureCache:retrieve(texture_id, "normal")

							Application:set_material_texture(material, Idstring(channel), retrieved_texture)

							if self._parts_texture_switches[part_id] and self._parts_texture_switches[part_id][channel] then
								TextureCache:unretrieve(Idstring(self._parts_texture_switches[part_id][channel]))
							end

							self._parts_texture_switches[part_id] = self._parts_texture_switches[part_id] or {}
							self._parts_texture_switches[part_id][channel] = texture_id
						else
							Application:error("[NewRaycastWeaponBase:apply_modified_textures] ---- Switch texture do not exists", texture_id)
						end
					end
				end
			end
		end
	end
end

function NewRaycastWeaponBase:check_npc()
	return
end

function NewRaycastWeaponBase:has_scope()
	if not self._scopes or #self._scopes == 0 then
		return false
	end

	return true
end

function NewRaycastWeaponBase:change_part(part_id)
	self._parts = managers.weapon_factory:change_part(self._unit, self._factory_id, part_id or "wpn_fps_m4_uupg_b_sd", self._parts, self._blueprint)

	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:remove_part(part_id)
	self._parts = managers.weapon_factory:remove_part(self._unit, self._factory_id, part_id, self._parts, self._blueprint)

	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:remove_part_by_type(type)
	self._parts = managers.weapon_factory:remove_part_by_type(self._unit, self._factory_id, type, self._parts, self._blueprint)

	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:change_blueprint(blueprint)
	self._blueprint = blueprint
	self._parts = managers.weapon_factory:change_blueprint(self._unit, self._factory_id, self._parts, blueprint)

	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:blueprint_to_string()
	local s = managers.weapon_factory:blueprint_to_string(self._factory_id, self._blueprint)

	return s
end

local FIRE_IDS = Idstring("fire")

function NewRaycastWeaponBase:_update_fire_object()
	local fire = managers.weapon_factory:get_part_from_weapon_by_type("barrel_ext", self._parts) or managers.weapon_factory:get_part_from_weapon_by_type("barrel", self._parts) or managers.weapon_factory:get_part_from_weapon_by_type("slide", self._parts)

	if not fire then
		debug_pause("[NewRaycastWeaponBase:_update_fire_object] Weapon \"" .. tostring(self._factory_id) .. "\" is missing fire object!")
	elseif not fire.unit:get_object(FIRE_IDS) then
		debug_pause("[NewRaycastWeaponBase:_update_fire_object] Weapon \"" .. tostring(self._factory_id) .. "\" is missing fire object for part \"" .. tostring(fire.unit) .. "\"!")
	else
		self:change_fire_object(fire.unit:get_object(FIRE_IDS))
	end
end

function NewRaycastWeaponBase:got_silencer()
	return self._silencer
end

local ids_single = Idstring("single")
local ids_auto = Idstring("auto")

function NewRaycastWeaponBase:_update_stats_values()
	Application:debug("[NewRaycaseWeaponBase:_update_stats_values]")
	self:_check_sound_switch()

	self._silencer = managers.weapon_factory:has_perk("silencer", self._factory_id, self._blueprint)
	self._locked_fire_mode = managers.weapon_factory:has_perk("fire_mode_auto", self._factory_id, self._blueprint) and ids_auto or managers.weapon_factory:has_perk("fire_mode_single", self._factory_id, self._blueprint) and ids_single
	self._fire_mode = self._locked_fire_mode or Idstring(self:weapon_tweak_data().FIRE_MODE or "single")
	self._ammo_data = managers.weapon_factory:get_ammo_data_from_weapon(self._factory_id, self._blueprint) or {}
	self._can_shoot_through_shield = tweak_data.weapon[self._name_id].can_shoot_through_shield
	self._can_shoot_through_enemy = tweak_data.weapon[self._name_id].can_shoot_through_enemy
	self._can_shoot_through_wall = tweak_data.weapon[self._name_id].can_shoot_through_wall
	self._armor_piercing_chance = self:weapon_tweak_data().armor_piercing_chance or 0
	self._movement_penalty = tweak_data.upgrades.weapon_movement_penalty[self:weapon_tweak_data().category] or 1

	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)

	for part_id, stats in pairs(custom_stats) do
		if stats.movement_speed then
			self._movement_penalty = self._movement_penalty * stats.movement_speed
		end

		if tweak_data.weapon.factory.parts[part_id].type ~= "ammo" then
			if stats.ammo_pickup_min_mul then
				self._ammo_data.ammo_pickup_min_mul = self._ammo_data.ammo_pickup_min_mul and self._ammo_data.ammo_pickup_min_mul * stats.ammo_pickup_min_mul or stats.ammo_pickup_min_mul
			end

			if stats.ammo_pickup_max_mul then
				self._ammo_data.ammo_pickup_max_mul = self._ammo_data.ammo_pickup_max_mul and self._ammo_data.ammo_pickup_max_mul * stats.ammo_pickup_max_mul or stats.ammo_pickup_max_mul
			end
		end
	end

	if self._ammo_data then
		if self._ammo_data.can_shoot_through_shield ~= nil then
			self._can_shoot_through_shield = self._can_shoot_through_shield + (self._ammo_data.can_shoot_through_shield and 1)
		end

		if self._ammo_data.can_shoot_through_enemy ~= nil then
			self._can_shoot_through_enemy = self._can_shoot_through_enemy + (self._ammo_data.can_shoot_through_enemy and 1)
		end

		if self._ammo_data.can_shoot_through_wall ~= nil then
			self._can_shoot_through_wall = self._can_shoot_through_wall + (self._ammo_data.can_shoot_through_wall and 1)
		end

		if self._ammo_data.bullet_class ~= nil then
			self._bullet_class = CoreSerialize.string_to_classtable(self._ammo_data.bullet_class)
			self._bullet_slotmask = self._bullet_class:bullet_slotmask()
			self._blank_slotmask = self._bullet_class:blank_slotmask()
		end

		if self._ammo_data.armor_piercing_add ~= nil then
			self._armor_piercing_chance = math.clamp(self._armor_piercing_chance + self._ammo_data.armor_piercing_add, 0, 1)
		end

		if self._ammo_data.armor_piercing_mul ~= nil then
			self._armor_piercing_chance = math.clamp(self._armor_piercing_chance * self._ammo_data.armor_piercing_mul, 0, 1)
		end
	end

	if self._silencer then
		self._muzzle_effect = Idstring(self:weapon_tweak_data().muzzleflash_silenced or "effects/vanilla/weapons/9mm_auto_silence_fps")
	elseif self._ammo_data and self._ammo_data.muzzleflash ~= nil then
		self._muzzle_effect = Idstring(self._ammo_data.muzzleflash)
	else
		self._muzzle_effect = Idstring(self:weapon_tweak_data().muzzleflash or "effects/vanilla/weapons/muzzleflash_maingun")
	end

	self._muzzle_effect_table = {
		effect = self._muzzle_effect,
		force_synch = self._muzzle_effect_table.force_synch or false,
		parent = self._obj_fire,
	}

	local base_stats = self:weapon_tweak_data().stats

	if not base_stats then
		return
	end

	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)
	local stats = deep_clone(base_stats)
	local stats_tweak_data = tweak_data.weapon.stats
	local modifier_stats = self:weapon_tweak_data().stats_modifiers

	if stats.zoom then
		stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(self:category(), "zoom_increase", 0), #stats_tweak_data.zoom)
	end

	for stat, _ in pairs(stats) do
		if stats_tweak_data[stat] then
			if stats[stat] < 1 or stats[stat] > #stats_tweak_data[stat] then
				Application:error("[NewRaycastWeaponBase] Base weapon stat is out of bound!", "stat: " .. stat, "index: " .. stats[stat], "max_index: " .. #stats_tweak_data[stat], "This stat will be clamped!")
			end

			if parts_stats[stat] then
				stats[stat] = stats[stat] + parts_stats[stat]
			end

			stats[stat] = math_clamp(stats[stat], 1, #stats_tweak_data[stat])
		end
	end

	self._current_stats_indices = stats
	self._current_stats = {}

	for stat, i in pairs(stats) do
		if stats_tweak_data[stat] then
			self._current_stats[stat] = stats_tweak_data[stat][i]

			if modifier_stats and modifier_stats[stat] then
				self._current_stats[stat] = self._current_stats[stat] * modifier_stats[stat]
			end
		end
	end

	self._current_stats.alert_size = stats_tweak_data.alert_size[math_clamp(stats.alert_size, 1, #stats_tweak_data.alert_size)]

	if modifier_stats and modifier_stats.alert_size then
		self._current_stats.alert_size = self._current_stats.alert_size * modifier_stats.alert_size
	end

	if stats.concealment then
		stats.suspicion = math.clamp(#stats_tweak_data.concealment - base_stats.concealment - (parts_stats.concealment or 0), 1, #stats_tweak_data.concealment)
		self._current_stats.suspicion = stats_tweak_data.concealment[stats.suspicion]
	end

	self._crit_reserve = 0
	self._alert_size = self._current_stats.alert_size or self._alert_size
	self._suppression = self._current_stats.suppression or self._suppression
	self._zoom = self._current_stats.zoom or self._zoom
	self._spread = self._current_stats.spread or self._spread
	self._recoil = self._current_stats.recoil or self._recoil
	self._spread_moving = self._current_stats.spread_moving or self._spread_moving
	self._extra_ammo = self._current_stats.extra_ammo or self._extra_ammo
	self._total_ammo_mod = self._current_stats.total_ammo_mod or self._total_ammo_mod
	self._gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", self._factory_id, self._blueprint)
	self._scopes = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("scope", self._factory_id, self._blueprint)

	self:_check_reticle_obj()
	self:replenish()
end

function NewRaycastWeaponBase:_check_reticle_obj()
	self._reticle_obj = nil

	local part = managers.weapon_factory:get_part_from_weapon_by_type("scope", self._parts)

	if part and part.unit then
		local part_id = managers.weapon_factory:get_part_id_from_weapon_by_type("scope", self._blueprint)
		local part_tweak = tweak_data.weapon.factory.parts[part_id]

		if part_tweak and part_tweak.reticle_obj then
			self._reticle_obj = part.unit:get_object(Idstring(part_tweak.reticle_obj))
		end
	end
end

function NewRaycastWeaponBase:_check_sound_switch()
	local suppressed_switch = managers.weapon_factory:get_sound_switch("suppressed", self._factory_id, self._blueprint)

	self._sound_fire:set_switch("suppressed", suppressed_switch or "regular")
end

function NewRaycastWeaponBase:stance_id()
	return "new_m4"
end

function NewRaycastWeaponBase:weapon_hold()
	return self:weapon_tweak_data().weapon_hold
end

function NewRaycastWeaponBase:replenish()
	local ammo_max_multiplier = managers.player:upgrade_value(self:category(), "extra_ammo_multiplier", 1)
	local idx = self:selection_index()

	if idx then
		local buff_name

		if idx == WeaponInventoryManager.BM_CATEGORY_SECONDARY_ID then
			ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value("weapon", "secondary_ammo_increase", 1)
			ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value("player", "secondary_ammo_increase", 1)
			buff_name = BuffEffectManager.EFFECT_PLAYER_SECONDARY_AMMO_CAPACITY
		elseif idx == WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID then
			ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value("weapon", "primary_ammo_increase", 1)
			ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value("player", "primary_ammo_increase", 1)
			buff_name = BuffEffectManager.EFFECT_PLAYER_PRIMARY_AMMO_CAPACITY
		end

		if managers.buff_effect:is_effect_active(buff_name) then
			ammo_max_multiplier = managers.buff_effect:get_effect_value(buff_name) or 1
		elseif managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_ALL_AMMO_CAPACITY) and buff_name ~= nil then
			ammo_max_multiplier = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_ALL_AMMO_CAPACITY) or 1
		end

		ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value("player", "pack_mule_ammo_total_increase", 1)
		ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value("player", "cache_basket_ammo_total_increase", 1)
	end

	local ammo_max_per_clip = self:calculate_ammo_max_per_clip()
	local ammo_max = math.round(tweak_data.weapon[self._name_id].AMMO_MAX * ammo_max_multiplier)

	ammo_max_per_clip = math.min(ammo_max_per_clip, ammo_max)

	self:set_ammo_max_per_clip(ammo_max_per_clip)
	self:set_ammo_max(ammo_max)

	if managers.raid_job._tutorial_spawned then
		self:set_ammo_total(0)
		self:set_ammo_remaining_in_clip(0)
	else
		self:set_ammo_total(ammo_max)
		self:set_ammo_remaining_in_clip(ammo_max_per_clip)
	end

	self:tweak_data_anim_stop("magazine_empty")
	self:update_damage()
end

function NewRaycastWeaponBase:update_damage()
	if tweak_data.weapon[self._name_id].damage_profile then
		local damage_profile = tweak_data.weapon[self._name_id].damage_profile

		self._damage = (damage_profile[1].damage + self:damage_addend()) * self:damage_multiplier()
	else
		self._damage = 1
	end
end

function NewRaycastWeaponBase:calculate_ammo_max_per_clip()
	local weapon_tweak = self:weapon_tweak_data()
	local ammo = weapon_tweak.CLIP_AMMO_MAX
	local selection_index = weapon_tweak.use_data.selection_index
	local selection_category = selection_index == WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID and "primary_weapon" or "secondary_weapon"
	local weapon_category = weapon_tweak.category

	if self._extra_ammo then
		ammo = ammo + self._extra_ammo
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PRIMARY_AMMO_MAG) and selection_index == WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID then
		local ammo_multiplier = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PRIMARY_AMMO_MAG) or 1

		ammo = math.floor(ammo * ammo_multiplier)
	end

	local guess_upg_category = managers.player:upgrade_value(weapon_category, "magazine_upgrade", 0)

	if guess_upg_category ~= 0 then
		Application:debug("[NewRaycastWeaponBase:calculate_ammo_max_per_clip] Using class type", weapon_category, guess_upg_category)

		ammo = ammo + guess_upg_category
	else
		ammo = ammo + managers.player:upgrade_value(selection_category, "magazine_upgrade", 0)
	end

	if not self:upgrade_blocked(weapon_category, "clipazines_magazine_upgrade") then
		ammo = ammo + managers.player:upgrade_value(weapon_category, "clipazines_magazine_upgrade", 0)
	end

	return ammo
end

function NewRaycastWeaponBase:movement_penalty()
	return self._movement_penalty or 1
end

function NewRaycastWeaponBase:armor_piercing_chance()
	return self._armor_piercing_chance or 0
end

function NewRaycastWeaponBase:get_reticle_obj()
	return self._reticle_obj
end

function NewRaycastWeaponBase:get_part_by_type(type)
	if self._parts then
		return managers.weapon_factory:get_part_from_weapon_by_type(type, self._parts)
	end

	return nil
end

function NewRaycastWeaponBase:stance_mod()
	if not self._blueprint or not self._factory_id then
		return nil
	end

	return managers.weapon_factory:get_stance_mod(self._factory_id, self._blueprint)
end

function NewRaycastWeaponBase:lens_distortion()
	local stance_mod = self:stance_mod()

	return stance_mod and stance_mod.lens_distortion or managers.environment_controller:get_lens_distortion_value()
end

function NewRaycastWeaponBase:tweak_data_anim_play(anim, speed_multiplier, time)
	speed_multiplier = speed_multiplier or 1

	local had_animation = false

	local function anim_doer(unit, data)
		if unit and data.animations and data.animations[anim] then
			local ids_anim_name = Idstring(data.animations[anim])
			local length = unit:anim_length(ids_anim_name)

			unit:anim_stop(ids_anim_name)
			unit:anim_play_to(ids_anim_name, length, speed_multiplier)

			if time then
				unit:anim_set_time(ids_anim_name, length * time)
			end

			return true
		end

		return false
	end

	local data = tweak_data.weapon.factory[self._factory_id]

	if anim_doer(self._unit, data) then
		had_animation = true
	end

	for part_id, part_data in pairs(self._parts) do
		if anim_doer(part_data.unit, part_data) then
			had_animation = true
		end
	end

	return had_animation
end

function NewRaycastWeaponBase:has_tweak_data_anim(anim)
	local function anim_doer(unit, data)
		if unit and data.animations and data.animations[anim] then
			return true
		end
	end

	local data = tweak_data.weapon.factory[self._factory_id]

	if anim_doer(self._unit, data) then
		return true
	end

	for part_id, part_data in pairs(self._parts) do
		if anim_doer(part_data.unit, part_data) then
			return true
		end
	end

	return false
end

function NewRaycastWeaponBase:tweak_data_anim_stop(anim)
	local data = tweak_data.weapon.factory[self._factory_id]

	if data.animations and data.animations[anim] then
		local anim_name = data.animations[anim]

		self._unit:anim_stop(Idstring(anim_name))
	end

	for part_id, data in pairs(self._parts) do
		if data.unit and data.animations and data.animations[anim] then
			local anim_name = data.animations[anim]

			data.unit:anim_stop(Idstring(anim_name))
		end
	end

	NewRaycastWeaponBase.super.tweak_data_anim_stop(self, anim)
end

function NewRaycastWeaponBase:set_parts_enabled(enabled)
	if self._parts then
		for part_id, data in pairs(self._parts) do
			if alive(data.unit) then
				if not enabled then
					for _, anim in ipairs(data.unit:anim_groups()) do
						if anim ~= IDS_EMPTY then
							data.unit:anim_play_to(anim, 0)
							data.unit:anim_stop(anim)
						end
					end
				end

				data.unit:set_enabled(enabled)

				if data.unit:digital_gui() then
					data.unit:digital_gui():set_visible(enabled)
				end

				if data.unit:digital_gui_upper() then
					data.unit:digital_gui_upper():set_visible(enabled)
				end
			end
		end
	end
end

function NewRaycastWeaponBase:on_enabled(...)
	NewRaycastWeaponBase.super.on_enabled(self, ...)
	self:set_parts_enabled(true)

	self._spread_firing = 0
	self._spread_last_shot_t = 0
	self._recoil_firing = 0
	self._recoil_last_shot_t = 0

	if self._gun_kick then
		self._gun_kick.x.delta = 0
		self._gun_kick.x.velocity = 0
		self._gun_kick.y.delta = 0
		self._gun_kick.y.velocity = 0
	end
end

function NewRaycastWeaponBase:on_disabled(...)
	NewRaycastWeaponBase.super.on_disabled(self, ...)
	self:gadget_off()
	self:set_parts_enabled(false)
end

function NewRaycastWeaponBase:fire_mode()
	self._fire_mode = self._locked_fire_mode or self._fire_mode or Idstring(tweak_data.weapon[self._name_id].FIRE_MODE or "single")

	return self._fire_mode == ids_single and "single" or "auto"
end

function NewRaycastWeaponBase:is_single_fire()
	self._fire_mode = self._locked_fire_mode or self._fire_mode or Idstring(tweak_data.weapon[self._name_id].FIRE_MODE or "single")

	return self._fire_mode == ids_single
end

function NewRaycastWeaponBase:recoil_wait()
	local tweak_is_auto = tweak_data.weapon[self._name_id].FIRE_MODE == "auto"
	local weapon_is_auto = self:fire_mode() == "auto"

	if not tweak_is_auto then
		return nil
	end

	local multiplier = tweak_is_auto == weapon_is_auto and 1 or 2

	return self:weapon_tweak_data().fire_mode_data.fire_rate * multiplier
end

function NewRaycastWeaponBase:can_toggle_firemode()
	return tweak_data.weapon[self._name_id].CAN_TOGGLE_FIREMODE
end

function NewRaycastWeaponBase:toggle_firemode()
	local can_toggle = not self._locked_fire_mode and self:can_toggle_firemode()

	if can_toggle then
		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYERS_CAN_ONLY_USE_SINGLE_FIRE) then
			self._fire_mode = ids_single

			return false
		elseif self._fire_mode == ids_single then
			self._fire_mode = ids_auto

			self._sound_fire:post_event("wp_auto_switch_on")
		else
			self._fire_mode = ids_single

			self._sound_fire:post_event("wp_auto_switch_off")
		end
	end

	return can_toggle
end

function NewRaycastWeaponBase:set_ammo_remaining_in_clip(...)
	NewRaycastWeaponBase.super.set_ammo_remaining_in_clip(self, ...)
	self:check_bullet_objects()
end

function NewRaycastWeaponBase:check_bullet_objects()
	if self._bullet_objects then
		self:_update_bullet_objects(self:get_ammo_remaining_in_clip())
	end
end

function NewRaycastWeaponBase:predict_bullet_objects()
	self:_update_bullet_objects(self:get_ammo_total())
end

function NewRaycastWeaponBase:_update_bullet_objects(ammo)
	if self._bullet_objects then
		for i, objects in pairs(self._bullet_objects) do
			for _, object in ipairs(objects) do
				object:set_visibility(i <= ammo)
			end
		end
	end
end

function NewRaycastWeaponBase:has_part(part_id)
	return self._blueprint and table.contains(self._blueprint, part_id)
end

function NewRaycastWeaponBase:has_gadget()
	return self._gadgets and #self._gadgets > 0
end

function NewRaycastWeaponBase:is_gadget_on()
	return self._gadget_on and self._gadget_on > 0 and self._gadget_on or false
end

function NewRaycastWeaponBase:gadget_on()
	self:set_gadget_on(1, true)
end

function NewRaycastWeaponBase:gadget_off()
	self:set_gadget_on(0, true, nil, true)
end

function NewRaycastWeaponBase:set_gadget_on(gadget_on, ignore_enable, gadgets, ignore_bipod)
	if not ignore_enable and not self._enabled then
		return
	end

	if not self._assembly_complete then
		return
	end

	self._gadget_on = gadget_on or self._gadget_on
	gadgets = gadgets or managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", self._factory_id, self._blueprint)

	if gadgets then
		local xd, yd
		local part_factory = tweak_data.weapon.factory.parts

		table.sort(gadgets, function(x, y)
			xd = self._parts[x]
			yd = self._parts[y]

			if not xd then
				return false
			end

			if not yd then
				return true
			end

			return xd.unit:base().GADGET_TYPE > yd.unit:base().GADGET_TYPE
		end)

		local gadget

		for i, id in ipairs(gadgets) do
			gadget = self._parts[id]

			if gadget then
				local is_bipod = ignore_bipod and gadget.unit:base():is_bipod()

				if not is_bipod then
					gadget.unit:base():set_state(self._gadget_on == i, self._sound_fire)
				end

				if gadget.unit:base():is_bipod() then
					if gadget.unit:base():bipod_state() then
						self._gadget_on = i
					else
						self._gadget_on = 0
					end
				end
			end
		end
	end
end

function NewRaycastWeaponBase:toggle_gadget()
	if not self._enabled then
		return false
	end

	local gadget_on = self._gadget_on or 0
	local gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", self._factory_id, self._blueprint)

	if gadgets then
		gadget_on = (gadget_on + 1) % (#gadgets + 1)

		self:set_gadget_on(gadget_on, false, gadgets)

		return true
	end
end

function NewRaycastWeaponBase:gadget_update()
	self:set_gadget_on(false, true)
end

function NewRaycastWeaponBase:is_bipod_usable()
	local retval = false
	local bipod_part = managers.weapon_factory:get_parts_from_weapon_by_perk("bipod", self._parts)
	local bipod_unit

	if bipod_part and bipod_part[1] then
		bipod_unit = bipod_part[1].unit:base()
	end

	retval = bipod_unit:is_usable()

	return retval
end

function NewRaycastWeaponBase:gadget_toggle_requires_stance_update()
	if not self._enabled then
		return false
	end

	if not self._gadgets then
		return false
	end

	for _, part_id in ipairs(self._gadgets) do
		if self._parts[part_id].unit:base():toggle_requires_stance_update() then
			return true
		end
	end

	return false
end

function NewRaycastWeaponBase:check_stats()
	local base_stats = self:weapon_tweak_data().stats

	if not base_stats then
		return
	end

	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)
	local stats = deep_clone(base_stats)
	local tweak_data = tweak_data.weapon.stats
	local modifier_stats = self:weapon_tweak_data().stats_modifiers

	stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(self:category(), "zoom_increase", 0), #tweak_data.zoom)

	for stat, _ in pairs(stats) do
		if parts_stats[stat] then
			stats[stat] = math_clamp(stats[stat] + parts_stats[stat], 1, #tweak_data[stat])
		end
	end

	self._current_stats = {}

	for stat, i in pairs(stats) do
		self._current_stats[stat] = tweak_data[stat][i]

		if modifier_stats and modifier_stats[stat] then
			self._current_stats[stat] = self._current_stats[stat] * modifier_stats[stat]
		end
	end

	self._current_stats.alert_size = tweak_data.alert_size[math_clamp(stats.alert_size, 1, #tweak_data.alert_size)]

	if modifier_stats and modifier_stats.alert_size then
		self._current_stats.alert_size = self._current_stats.alert_size * modifier_stats.alert_size
	end

	return stats
end

function NewRaycastWeaponBase:_get_fire_spread_add()
	local user_unit = self._setup and self._setup.user_unit
	local current_state = user_unit:movement()._current_state

	if self:in_steelsight() then
		return self:weapon_tweak_data().spread.per_shot_steelsight or 0
	else
		return self:weapon_tweak_data().spread.per_shot or 0
	end
end

function NewRaycastWeaponBase:_get_fire_recoil()
	local weapon_tweak = self:weapon_tweak_data()

	if weapon_tweak.kick.formula then
		local f = weapon_tweak.kick.formula(self._recoil_firing)

		return f
	end

	return 0
end

function NewRaycastWeaponBase:fire(from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
	local weapon_tweak = self:weapon_tweak_data()
	local apply_gun_kick = weapon_tweak and weapon_tweak.gun_kick
	local mvec_direction = tmp_vec1
	local mvec_right = tmp_vec2
	local mvec_up = tmp_vec3

	if apply_gun_kick and (self:in_steelsight() or weapon_tweak.gun_kick.apply_during_hipfire) then
		mvec3_cross(mvec_right, direction, math.UP)
		mvec3_norm(mvec_right)
		mvec3_cross(mvec_up, direction, mvec_right)
		mvec3_norm(mvec_up)
		mvec3_mul(mvec_right, math.rad(self._gun_kick.x.delta))
		mvec3_mul(mvec_up, math.rad(self._gun_kick.y.delta))
		mvec3_set(mvec_direction, direction)
		mvec3_add(mvec_direction, mvec_right)
		mvec3_add(mvec_direction, mvec_up)
	else
		mvec3_set(mvec_direction, direction)
	end

	local ray_res = NewRaycastWeaponBase.super.fire(self, from_pos, mvec_direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)

	self._spread_firing = math.min((self._spread_firing or 0) + self:_get_fire_spread_add(shoot_player), self:weapon_tweak_data().spread.max or 2)
	self._spread_last_shot_t = (weapon_tweak.fire_mode_data and weapon_tweak.fire_mode_data.fire_rate or 0) / self:fire_rate_multiplier() * (weapon_tweak.spread.recovery_wait_multiplier or 1)
	self._recoil_firing = self:_get_fire_recoil()
	self._recoil_last_shot_t = (weapon_tweak.fire_mode_data and weapon_tweak.fire_mode_data.fire_rate or 0) / self:fire_rate_multiplier() * (weapon_tweak.kick.recovery_wait_multiplier or 1)

	if apply_gun_kick then
		local gun_kick_values = self:in_steelsight() and weapon_tweak.gun_kick.steelsight or weapon_tweak.gun_kick.hip_fire

		if gun_kick_values then
			local recoil_multiplier = self:recoil_multiplier()
			local kick_x = math.lerp(gun_kick_values[3], gun_kick_values[4], math.random()) * recoil_multiplier
			local kick_y = math.lerp(gun_kick_values[1], gun_kick_values[2], math.random()) * recoil_multiplier

			self._gun_kick.x.velocity = self._gun_kick.x.velocity + kick_x
			self._gun_kick.y.velocity = self._gun_kick.y.velocity + kick_y * -1
		end
	end

	return ray_res
end

function NewRaycastWeaponBase:update(unit, t, dt)
	self._spread_last_shot_t = math.max((self._spread_last_shot_t or 0) - dt, 0)

	if self._spread_last_shot_t <= 0.0001 then
		self._spread_firing = math.max((self._spread_firing or 0) - dt * (self:weapon_tweak_data().spread.recovery or 1), 0)
	end

	self._recoil_last_shot_t = math.max((self._recoil_last_shot_t or 0) - dt, 0)

	if self._recoil_last_shot_t <= 0.0001 then
		self._recoil_firing = math.max((self._recoil_firing or 0) - dt * (self:weapon_tweak_data().kick.recovery or 1), 0)
	end

	self:_update_horizontal_gun_kick(t, dt)
	self:_update_vertical_gun_kick(t, dt)
end

local recenter_divisor = 16

function NewRaycastWeaponBase:gun_kick()
	return self._gun_kick
end

function NewRaycastWeaponBase:_get_gun_kick_center_acceleration()
	local gun_kick_center_speed = 600

	if self:weapon_tweak_data().gun_kick then
		return self:weapon_tweak_data().gun_kick.recenter_speed or gun_kick_center_speed
	else
		return gun_kick_center_speed
	end
end

function NewRaycastWeaponBase:_update_horizontal_gun_kick(t, dt)
	local epsilon = 0.001
	local view_kick_center_speed = self:_get_gun_kick_center_acceleration()
	local max_deflection = 10

	if self:weapon_tweak_data().gun_kick and self:weapon_tweak_data().gun_kick.max_deflection then
		max_deflection = self:weapon_tweak_data().gun_kick.max_deflection[2]
	end

	self._gun_kick.x.delta = self._gun_kick.x.delta + self._gun_kick.x.velocity * dt

	local velocity_sign = math.sign(self._gun_kick.x.velocity)
	local velocity_sign_neg = velocity_sign * -1
	local delta_sign = math.sign(self._gun_kick.x.delta)
	local dir = delta_sign * -1

	if velocity_sign_neg == delta_sign then
		view_kick_center_speed = view_kick_center_speed / recenter_divisor
	end

	local acceleration = dt * view_kick_center_speed * dir

	self._gun_kick.x.velocity = self._gun_kick.x.velocity + acceleration

	if max_deflection < math.abs(self._gun_kick.x.delta) and velocity_sign == delta_sign then
		self._gun_kick.x.velocity = view_kick_center_speed / recenter_divisor * velocity_sign_neg
	end

	if math.abs(self._gun_kick.x.velocity / self._gun_kick.x.delta * 0.016666666666666666) > 0.8 then
		self._gun_kick.x.delta = 0
		self._gun_kick.x.velocity = 0
	end
end

function NewRaycastWeaponBase:_update_vertical_gun_kick(t, dt)
	local epsilon = 0.001
	local view_kick_center_speed = self:_get_gun_kick_center_acceleration()
	local max_deflection = 10

	if self:weapon_tweak_data().gun_kick and self:weapon_tweak_data().gun_kick.max_deflection then
		max_deflection = self:weapon_tweak_data().gun_kick.max_deflection[2]
	end

	self._gun_kick.y.delta = self._gun_kick.y.delta + self._gun_kick.y.velocity * dt

	local velocity_sign = math.sign(self._gun_kick.y.velocity)
	local velocity_sign_neg = velocity_sign * -1
	local delta_sign = math.sign(self._gun_kick.y.delta)
	local dir = delta_sign * -1

	if velocity_sign_neg == delta_sign then
		view_kick_center_speed = view_kick_center_speed / recenter_divisor
	end

	local acceleration = dt * view_kick_center_speed * dir

	self._gun_kick.y.velocity = self._gun_kick.y.velocity + acceleration

	if max_deflection < math.abs(self._gun_kick.y.delta) and velocity_sign == delta_sign then
		self._gun_kick.y.velocity = view_kick_center_speed / recenter_divisor * velocity_sign_neg
	end

	if math.abs(self._gun_kick.y.velocity / self._gun_kick.y.delta * 0.016666666666666666) > 0.5 then
		self._gun_kick.y.delta = 0
		self._gun_kick.y.velocity = 0
	end
end

function NewRaycastWeaponBase:_convert_add_to_mul(value)
	if value > 1 then
		return 1 / value
	elseif value < 1 then
		return math.abs(value - 1) + 1
	else
		return 1
	end
end

function NewRaycastWeaponBase:_get_spread(user_unit)
	if user_unit == managers.player:player_unit() then
		if managers.player:upgrade_value("player", "warcry_nullify_spread", false) then
			return 0
		end

		if self:in_steelsight() then
			if managers.player:upgrade_value("player", "warcry_nullify_spread_steelsight", false) then
				return 0
			end
		elseif managers.player:upgrade_value("player", "warcry_nullify_spread_hipfire", false) then
			return 0
		end
	end

	local current_state = user_unit:movement():current_state()
	local spread_stat = current_state and current_state:moving() and self._spread_moving or self._spread
	local spread_addend = self:spread_addend(current_state)
	local spread_multiplier = self:spread_multiplier(current_state)
	local spread_firing = self._spread_firing or 0

	return math.max(0, (spread_stat + spread_addend) * spread_multiplier + spread_firing)
end

function NewRaycastWeaponBase:damage_addend()
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state

	return managers.blackmarket:damage_addend(self._name_id, self:category(), self._silencer, nil, current_state, self._blueprint)
end

function NewRaycastWeaponBase:damage_multiplier()
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state
	local multiplier = managers.blackmarket:damage_multiplier(self._name_id, self:category(), self._silencer, nil, current_state, self._blueprint)

	return multiplier
end

function NewRaycastWeaponBase:melee_damage_multiplier()
	return managers.player:upgrade_value(self._name_id, "melee_multiplier", 1)
end

function NewRaycastWeaponBase:spread_addend(current_state)
	return managers.blackmarket:accuracy_addend(self._name_id, self:category(), self._current_stats_indices and self._current_stats_indices.spread, self._silencer, current_state, self:fire_mode(), self._blueprint)
end

function NewRaycastWeaponBase:spread_multiplier(current_state)
	return managers.blackmarket:accuracy_multiplier(self._name_id, self:category(), self._silencer, current_state, self._spread_moving, self:fire_mode(), self._blueprint)
end

function NewRaycastWeaponBase:recoil_addend()
	local recoil = managers.blackmarket:recoil_addend(self._name_id, self:category(), self._current_stats_indices and self._current_stats_indices.recoil, self._silencer, self._blueprint)
	local re = recoil + (self._recoil_firing or 0)

	return re
end

function NewRaycastWeaponBase:recoil_multiplier()
	return managers.blackmarket:recoil_multiplier(self._name_id, self:category(), self._silencer, self._blueprint)
end

function NewRaycastWeaponBase:dismember_chance()
	local chance = self:weapon_tweak_data().dismember_chance or 0

	if self:is_single_fire() then
		chance = chance + (managers.player:upgrade_value("player", "brutality_single_dismember_chance", 1) - 1)
	end

	if chance <= 0 then
		return
	end

	local multiplier = 1

	if self:in_steelsight() then
		multiplier = multiplier * managers.player:upgrade_value(self:category(), "steelsight_dismember_chance", 1)
	end

	return chance * multiplier
end

function NewRaycastWeaponBase:crit_reserve()
	return self._crit_reserve or 0
end

function NewRaycastWeaponBase:modify_crit_reserve(amount)
	self._crit_reserve = math.max(self._crit_reserve + amount, -1)
end

function NewRaycastWeaponBase:critical_hit_chance()
	local chance = 0

	chance = chance + (managers.player:upgrade_value(self:category(), "anatomist_critical_hit_chance", 1) - 1)

	if self:is_single_fire() then
		chance = chance + (managers.player:upgrade_value("player", "brutality_single_critical_hit_chance", 1) - 1)
	end

	return chance
end

function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	local multiplier = 1

	multiplier = multiplier + (1 - managers.player:upgrade_value(self:category(), "enter_steelsight_speed_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value("player", "fasthand_enter_steelsight_speed_multiplier", 1))

	local idx = self:selection_index()

	if idx == WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID then
		multiplier = multiplier + (1 - managers.player:upgrade_value("primary_weapon", "enter_steelsight_speed_multiplier", 1))
	elseif idx == WeaponInventoryManager.BM_CATEGORY_SECONDARY_ID then
		multiplier = multiplier + (1 - managers.player:upgrade_value("secondary_weapon", "enter_steelsight_speed_multiplier", 1))
	end

	return self:_convert_add_to_mul(multiplier)
end

function NewRaycastWeaponBase:fire_rate_multiplier()
	local weapon_category = self:category()
	local multiplier = 1

	multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "fire_rate_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value(self._name_id, "fire_rate_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value(weapon_category, "fire_rate_multiplier", 1))

	if self:in_steelsight() then
		multiplier = multiplier + (1 - managers.player:upgrade_value(weapon_category, "steelsight_fire_rate_multiplier", 1))
	end

	return self:_convert_add_to_mul(multiplier)
end

function NewRaycastWeaponBase:reload_speed_multiplier()
	local multiplier = 1

	multiplier = multiplier + (1 - managers.player:upgrade_value(self:category(), "reload_speed_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "passive_reload_speed_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "fasthand_reload_speed_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value(self._name_id, "reload_speed_multiplier", 1))

	local empty_reload = self._started_reload_empty or self:clip_empty()

	if empty_reload then
		multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "clipazines_empty_reload_speed_multiplier", 1))
	end

	local idx = self:selection_index()

	if idx == WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID then
		multiplier = multiplier + (1 - managers.player:upgrade_value("primary_weapon", "reload_speed_multiplier", 1))
	elseif idx == WeaponInventoryManager.BM_CATEGORY_SECONDARY_ID then
		multiplier = multiplier + (1 - managers.player:upgrade_value("secondary_weapon", "reload_speed_multiplier", 1))
	end

	if self._setup and alive(self._setup.user_unit) and self._setup.user_unit:movement() then
		local morale_boost_bonus = self._setup.user_unit:movement():morale_boost()

		if morale_boost_bonus then
			multiplier = multiplier + (1 - morale_boost_bonus.reload_speed_bonus)
		end
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED) then
		multiplier = multiplier + (1 - (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED) or 1))
	end

	local raid_multiplier = self:_convert_add_to_mul(multiplier)

	return raid_multiplier
end

function NewRaycastWeaponBase:_debug_bipod()
	local gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", self._factory_id, self._blueprint)

	if gadgets then
		local xd, yd
		local part_factory = tweak_data.weapon.factory.parts

		table.sort(gadgets, function(x, y)
			xd = self._parts[x]
			yd = self._parts[y]

			if not xd then
				return false
			end

			if not yd then
				return true
			end

			return xd.unit:base().GADGET_TYPE > yd.unit:base().GADGET_TYPE
		end)

		local gadget

		for i, id in ipairs(gadgets) do
			gadget = self._parts[id]

			if gadget then
				local is_bipod = gadget.unit:base():is_bipod()

				if is_bipod then
					gadget.unit:base():_shoot_bipod_rays(true)
				end
			end
		end
	end
end

function NewRaycastWeaponBase:use_shotgun_reload()
	return self._use_shotgun_reload
end

function NewRaycastWeaponBase:reload_expire_t()
	if self._use_shotgun_reload then
		local ammo_remaining_in_clip = self:get_ammo_remaining_in_clip()
		local shells_needed = math.min(self:get_ammo_total() - ammo_remaining_in_clip, self:get_ammo_max_per_clip() - ammo_remaining_in_clip)
		local total_loads = math.ceil(shells_needed / self:get_ammo_reload_clip_single())

		return total_loads * self:reload_shell_expire_t()
	end

	return nil
end

function NewRaycastWeaponBase:reload_enter_expire_t()
	if self._use_shotgun_reload then
		return self:weapon_tweak_data().timers.shotgun_reload_enter or 0.3
	end

	return nil
end

function NewRaycastWeaponBase:reload_exit_expire_t()
	if self._use_shotgun_reload then
		return self:weapon_tweak_data().timers.shotgun_reload_exit_empty or 0.7
	end

	return nil
end

function NewRaycastWeaponBase:reload_not_empty_exit_expire_t()
	if self._use_shotgun_reload then
		return self:weapon_tweak_data().timers.shotgun_reload_exit_not_empty or 0.3
	end

	return nil
end

function NewRaycastWeaponBase:reload_shell_expire_t()
	if self._use_shotgun_reload then
		return self:weapon_tweak_data().timers.shotgun_reload_shell or 0.5666666666666667
	end

	return nil
end

function NewRaycastWeaponBase:_first_shell_reload_expire_t()
	if self._use_shotgun_reload then
		return self:reload_shell_expire_t() - (self:weapon_tweak_data().timers.shotgun_reload_first_shell_offset or 0.33)
	end

	return nil
end

function NewRaycastWeaponBase:start_reload(...)
	NewRaycastWeaponBase.super.start_reload(self, ...)

	self._started_reload_empty = self:clip_empty()

	if self._use_shotgun_reload then
		self:update_next_shell_reload_t(true)
	end
end

function NewRaycastWeaponBase:started_reload_empty()
	return self._use_shotgun_reload and self._started_reload_empty
end

function NewRaycastWeaponBase:update_reloading(t, dt, time_left)
	if self._use_shotgun_reload and self._next_shell_reloded_t and t >= self._next_shell_reloded_t then
		local reload_clip_single = self:get_ammo_reload_clip_single()
		local ammo_in_clip = self:get_ammo_remaining_in_clip()
		local ammo_max_per_clip = self:get_ammo_max_per_clip()
		local new_total = math.max(0, self:get_ammo_total() - ammo_in_clip)
		local reload_amount = math.min(reload_clip_single, new_total)

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_RANDOM_RELOAD) then
			ammo_in_clip = 0
			reload_amount = math.random(1, ammo_max_per_clip)
		end

		self:update_next_shell_reload_t()

		local new_remaining = math.min(ammo_max_per_clip, ammo_in_clip + reload_amount)

		self:set_ammo_remaining_in_clip(new_remaining)
		managers.raid_job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)

		return true
	end
end

function NewRaycastWeaponBase:update_next_shell_reload_t(start)
	local reload_expire_t = start and self:_first_shell_reload_expire_t() or self:reload_shell_expire_t()

	if reload_expire_t then
		local speed_multiplier = self:reload_speed_multiplier()

		self._next_shell_reloded_t = managers.player:player_timer():time() + reload_expire_t / speed_multiplier
	end
end

function NewRaycastWeaponBase:reload_interuptable()
	return self._use_shotgun_reload
end

function NewRaycastWeaponBase:shotgun_shell_data()
	if self._use_shotgun_reload then
		local reload_shell_data = self:weapon_tweak_data().animations.reload_shell_data
		local unit_name = reload_shell_data and reload_shell_data.unit_name or "units/vanilla/weapons/wpn_fps_shells/wpn_fps_shells"
		local align = reload_shell_data and reload_shell_data.align or nil

		return {
			align = align,
			unit_name = unit_name,
		}
	end

	return nil
end

function NewRaycastWeaponBase:set_timer(timer, ...)
	NewRaycastWeaponBase.super.set_timer(self, timer)

	if self._assembly_complete then
		for id, data in pairs(self._parts) do
			data.unit:set_timer(timer)
			data.unit:set_animation_timer(timer)
		end
	end
end

function NewRaycastWeaponBase:run_ads_sequence(steelsight_state, instant)
	if not self:has_scope() then
		return
	end

	local seq = steelsight_state and "state_ads_entered" or "state_ads_exited"

	if instant then
		self:play_weapon_sequence(seq)

		return
	end

	local delay = tweak_data.player.TRANSITION_DURATION

	delay = delay + (self:transition_duration() or 0)

	local delay_multiplier = steelsight_state and 1 / self:enter_steelsight_speed_multiplier() or 1

	delay = delay * delay_multiplier

	if steelsight_state then
		delay = delay * 0.665
	else
		delay = delay * 0.33499999999999996
	end

	local tid = "NewRaycastWeaponBase.run_ads_sequence"

	managers.queued_tasks:unqueue(tid)
	managers.queued_tasks:queue(tid, self.play_weapon_sequence, self, seq, delay)
end

function NewRaycastWeaponBase:play_weapon_sequence(seq)
	if self._unit:damage() then
		self._unit:damage():has_then_run_sequence_simple(seq)
	end

	if self._assembly_complete then
		for id, data in pairs(self._parts) do
			if data.unit:damage() then
				data.unit:damage():has_then_run_sequence_simple(seq)
			end
		end
	end
end

function NewRaycastWeaponBase:destroy(unit)
	NewRaycastWeaponBase.super.destroy(self, unit)

	if self._parts_texture_switches then
		Application:debug("[NewRaycastWeaponBase:destroy] Destroying", inspect(self._parts_texture_switches))

		for part_id, texture_data in pairs(self._parts_texture_switches) do
			for _, texture_id in pairs(texture_data) do
				TextureCache:unretrieve(Idstring(texture_id))
			end
		end
	end

	if self._textures then
		Application:debug("[NewRaycastWeaponBase:destroy] Destroying", inspect(self._textures))

		for tex_id, texture_data in pairs(self._textures) do
			if not texture_data.applied then
				texture_data.applied = true

				TextureCache:unretrieve(texture_data.name)
			end
		end
	end

	managers.weapon_factory:disassemble(self._parts)
end

local mvec_to = Vector3()
local mvec_spread_direction = Vector3()
local mvec1 = Vector3()

function NewRaycastWeaponBase:update_debug(t, dt)
	if not Global.show_weapon_spread then
		return
	end

	local user_unit = managers.player:player_unit()

	if not user_unit then
		return
	end

	local from_pos = user_unit:camera():position()
	local direction = user_unit:camera():forward()
	local camera_rot = user_unit:camera():rotation()
	local ray_distance = type(Global.show_weapon_spread) == "number" and Global.show_weapon_spread or 1000
	local spread = self:_get_spread(user_unit)

	if spread == nil then
		return
	end

	if not self._brush_centre then
		self._brush_centre = Draw:brush(Color.red:with_alpha(0.5))
	end

	if not self._brush_outer then
		self._brush_outer = Draw:brush(Color(1, 0, 1):with_alpha(0.5))
	end

	if not self._brush_up then
		self._brush_up = Draw:brush(Color.blue:with_alpha(0.5))
	end

	if not self._brush_right then
		self._brush_right = Draw:brush(Color.green:with_alpha(0.5))
	end

	if not self._brush_firing then
		self._brush_firing = Draw:brush(Color(1, 1, 0):with_alpha(0.5), 0.25)
	end

	local weapon_tweak = self:weapon_tweak_data()
	local apply_gun_kick = weapon_tweak and weapon_tweak.gun_kick

	apply_gun_kick = apply_gun_kick and (self:in_steelsight() or weapon_tweak.gun_kick.apply_during_hipfire)

	local right = direction:cross(math.UP):normalized()
	local up = direction:cross(right):normalized()

	mvector3.set(mvec_to, direction)

	if apply_gun_kick then
		mvector3.add(mvec_to, right * math.rad(self._gun_kick.x.delta))
		mvector3.add(mvec_to, up * math.rad(self._gun_kick.y.delta))
	end

	mvector3.multiply(mvec_to, ray_distance)
	mvector3.add(mvec_to, from_pos)
	self._brush_centre:disc(mvec_to, 0.004 * ray_distance, direction, 4)

	local vec_right = mvec_to + right * 25

	self._brush_right:cylinder(mvec_to, vec_right, 0.001 * ray_distance)

	local vec_up = mvec_to + up * 25

	self._brush_up:cylinder(mvec_to, vec_up, 0.001 * ray_distance)

	for ang = 1, 360 do
		local theta = ang
		local ax = math.sin(theta) * spread
		local ay = math.cos(theta) * spread

		mvector3.set(mvec_spread_direction, direction)
		mvector3.add(mvec_spread_direction, right * math.rad(ax))
		mvector3.add(mvec_spread_direction, up * math.rad(ay))

		if apply_gun_kick then
			mvector3.add(mvec_spread_direction, right * math.rad(self._gun_kick.x.delta))
			mvector3.add(mvec_spread_direction, up * math.rad(self._gun_kick.y.delta))
		end

		mvector3.set(mvec_to, mvec_spread_direction)
		mvector3.multiply(mvec_to, ray_distance)
		mvector3.add(mvec_to, from_pos)
		self._brush_outer:disc(mvec_to, 0.001 * ray_distance, direction, 16)
	end

	if Global.simulate_weapon_spread then
		local theta = math.random() * 360
		local ax = math.sin(theta) * (math.random() * spread)
		local ay = math.cos(theta) * (math.random() * spread)

		mvector3.set(mvec_spread_direction, direction)
		mvector3.add(mvec_spread_direction, right * math.rad(ax))
		mvector3.add(mvec_spread_direction, up * math.rad(ay))

		if apply_gun_kick then
			mvector3.add(mvec_spread_direction, right * math.rad(self._gun_kick.x.delta))
			mvector3.add(mvec_spread_direction, up * math.rad(self._gun_kick.y.delta))
		end

		mvector3.set(mvec_to, mvec_spread_direction)
		mvector3.multiply(mvec_to, ray_distance)
		mvector3.add(mvec_to, from_pos)
		self._brush_firing:disc(mvec_to, 4, direction, 16)
	end
end
