FlamethrowerEffectExtension = FlamethrowerEffectExtension or class()
FlamethrowerEffectExtension.MIN_EFFECT_INTERVAL = 0.01

function FlamethrowerEffectExtension:init(unit, ...)
	self._unit = unit
	self._name_id = self.name_id or "test_raycast_weapon"
	self.name_id = nil

	self:setup_default()
	self._unit:set_extension_update_enabled(Idstring("flamethrower_effect_extension"), true)
end

function FlamethrowerEffectExtension:setup_default()
	self._flame_effect = {}
	self._flame_effect.effect = tweak_data.common_effects.flamer_burst
	self._nozzle_effect = {}
	self._nozzle_effect.effect = tweak_data.common_effects.flamer_nosel
	self._pilot_light = {}
	self._pilot_light.effect = tweak_data.common_effects.flamer_pilot
	self._flame_max_range = tweak_data.weapon[self._name_id].flame_max_range
	self._single_flame_effect_duration = tweak_data.weapon[self._name_id].single_flame_effect_duration
	self._distance_to_gun_tip = 50
	self._flamethrower_effect_collection = {}
end

local mvec1 = Vector3()

function FlamethrowerEffectExtension:update(unit, t, dt)
	if self._flamethrower_effect_collection ~= nil then
		local flame_effect_dt = self._single_flame_effect_duration / dt
		local flame_effect_distance = self._flame_max_range / flame_effect_dt

		for _, effect_entry in pairs(self._flamethrower_effect_collection) do
			local do_continue = true

			if World:effect_manager():alive(effect_entry.id) == false then
				if effect_entry.been_alive == true then
					World:effect_manager():kill(effect_entry.id)
					table.remove(self._flamethrower_effect_collection, _)

					do_continue = false
				end
			elseif effect_entry.been_alive == false then
				effect_entry.been_alive = true
			end

			if do_continue == true then
				mvector3.set(mvec1, effect_entry.position)
				mvector3.add(effect_entry.position, effect_entry.direction * flame_effect_distance)

				local raycast = World:raycast(mvec1, effect_entry.position)

				if raycast ~= nil then
					table.remove(self._flamethrower_effect_collection, _)
				else
					World:effect_manager():move(effect_entry.id, effect_entry.position)
				end

				local effect_distance = mvector3.distance(effect_entry.position, unit:position())

				if effect_distance > self._flame_max_range then
					World:effect_manager():kill(effect_entry.id)
				end
			end
		end
	end
end

function FlamethrowerEffectExtension:_spawn_muzzle_effect(from_pos, direction)
	if self._next_fire_time and self._next_fire_time > managers.player:player_timer():time() then
		return
	end

	local from = from_pos + direction * self._distance_to_gun_tip
	local nozzle_obj = self._unit:get_object(Idstring("fire"))
	local nozzle_pos = nozzle_obj:position()
	local attach_obj = self._unit
	local effect_id = World:effect_manager():spawn({
		effect = self._flame_effect.effect,
		normal = math.UP,
		position = nozzle_pos,
	})

	self._next_fire_time = managers.player:player_timer():time() + FlamethrowerEffectExtension.MIN_EFFECT_INTERVAL

	table.insert(self._flamethrower_effect_collection, {
		been_alive = false,
		direction = mvector3.copy(direction),
		id = effect_id,
		position = nozzle_pos,
	})
end
