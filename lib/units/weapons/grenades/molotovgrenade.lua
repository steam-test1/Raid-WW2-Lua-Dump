MolotovGrenade = MolotovGrenade or class(GrenadeBase)

function MolotovGrenade:_setup_from_tweak_data()
	local grenade_entry = self.name_id or "molotov"

	self._tweak_data = tweak_data.projectiles[grenade_entry]
	self._init_timer = self._tweak_data.init_timer or 2.5
	self._damage = self._tweak_data.damage
	self._player_damage = self._tweak_data.player_damage
	self._range = self._tweak_data.range
	self._alert_radius = self._tweak_data.alert_radius
	self._curve_pow = self._tweak_data.curve_pow or 3
	self._fire_entry = self._tweak_data.fire_tweak_id
	self._detonated = false
end

function MolotovGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, ...)
	if not self._detonated then
		self:detonate(normal)
		managers.network:session():send_to_peers_synched("sync_detonate_molotov_grenade", self._unit, "base", GrenadeBase.EVENT_IDS.detonate, normal)
	end
end

function MolotovGrenade:detonate(normal)
	local position = self._unit:position()

	managers.explosion:detect_and_give_dmg({
		alert_radius = self._alert_radius,
		collision_slotmask = managers.slot:get_mask("explosion_targets"),
		curve_pow = self._curve_pow,
		damage = self._damage,
		hit_pos = position,
		ignite_character = true,
		ignore_unit = self._unit,
		no_raycast_check_characters = true,
		player_damage = self._player_damage,
		push_units = false,
		range = self._range,
		user = self._unit,
	})

	self._fire_data = managers.fire:propagate_fire(position, self._fire_entry)
	self._detonated = true

	if Network:is_server() then
		self._unit:set_slot(0)
	else
		self._unit:set_enabled(false)
	end
end

function MolotovGrenade:sync_detonate_molotov_grenade(event_id, normal)
	if event_id == GrenadeBase.EVENT_IDS.detonate then
		self:_detonate_on_client(normal)
	end
end

function MolotovGrenade:_detonate_on_client(normal)
	if not self._detonated then
		self:detonate(normal)
	end
end

function MolotovGrenade:bullet_hit()
	if not Network:is_server() then
		return
	end

	self._timer = nil

	self:_detonate()
end
