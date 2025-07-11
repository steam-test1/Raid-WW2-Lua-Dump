GrenadePickup = GrenadePickup or class(Pickup)

function GrenadePickup:init(unit)
	Application:warn("[GrenadePickup] TODO: DEPRECATE ME!")
	GrenadePickup.super.init(self, unit)
end

function GrenadePickup:_pickup(unit)
	if self._picked_up then
		return
	end

	local inventory = unit:inventory()

	if not unit:character_damage():dead() and inventory then
		local picked_up = false
		local excess_grenades_remaining = 0
		local gained_grenades = 0
		local effect_ammo_pickup_multiplier = 1
		local grenades_to_add = 0

		if not managers.player:got_max_grenades() then
			if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_AMMO_EFFECT_INCREASE) then
				effect_ammo_pickup_multiplier = effect_ammo_pickup_multiplier + ((managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_AMMO_EFFECT_INCREASE) or 1) - 1)
			end

			if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE) then
				effect_ammo_pickup_multiplier = effect_ammo_pickup_multiplier + ((managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE) or 1) - 1)
			end

			local grenades_amount = tweak_data.drop_loot[self.tweak_data].grenades_amount or 1
			local grenades_pku_add = tweak_data.projectiles[inventory.equipped_grenade].per_pickup or 1

			grenades_to_add = grenades_amount * grenades_pku_add * effect_ammo_pickup_multiplier
			gained_grenades = managers.player:add_grenade_amount(math.floor(grenades_to_add))
			excess_grenades_remaining = grenades_amount - math.ceil(gained_grenades / grenades_pku_add)
			picked_up = true
		end

		if picked_up then
			self._picked_up = true

			for i_grenade = 1, gained_grenades do
				managers.player:register_grenade(managers.network:session():local_peer():id())
			end

			managers.network:session():send_to_peers_synched("register_grenades_pickup", self._unit, gained_grenades)

			if Network:is_client() then
				managers.network:session():send_to_host("sync_pickup", self._unit)
			elseif excess_grenades_remaining > 0 then
				local size = excess_grenades_remaining == 1 and "small" or "medium"
				local replacement_id = Pickup.PATH .. "pku_granade_" .. size

				if self._beaming then
					replacement_id = replacement_id .. "_beam"
				end

				self._unit_replacement = World:spawn_unit(Idstring(replacement_id), self._unit:position(), self._unit:rotation())
			end

			self:consume()

			return true
		end
	end

	return false
end

function GrenadePickup:register_grenades(gained_grenades, peer)
	local player = managers.player:local_player()

	if not alive(player) or not player:character_damage() or player:character_damage():is_downed() or player:character_damage():dead() then
		return
	end

	if peer and not self._grenade_registered then
		for i_grenade = 1, gained_grenades do
			managers.player:register_grenade(peer:id())
		end

		self._grenade_registered = true
	end
end

function GrenadePickup:get_pickup_type()
	return "grenade"
end
