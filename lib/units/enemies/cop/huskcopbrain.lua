HuskCopBrain = HuskCopBrain or class()
HuskCopBrain._NET_EVENTS = {
	weapon_laser_off = 2,
	weapon_laser_on = 1,
}

function HuskCopBrain:init(unit)
	self._unit = unit
end

function HuskCopBrain:post_init()
	self._alert_listen_key = "HuskCopBrain" .. tostring(self._unit:key())

	local alert_listen_filter = managers.groupai:state():get_unit_type_filter("criminal")

	managers.groupai:state():add_alert_listener(self._alert_listen_key, callback(self, self, "on_alert"), alert_listen_filter, {
		aggression = true,
		bullet = true,
		explosion = true,
		footstep = true,
		vo_cbt = true,
		vo_intimidate = true,
	}, self._unit:movement():m_head_pos())

	self._last_alert_t = 0
	self._distance_to_target = 100000

	self._unit:character_damage():add_listener("HuskCopBrain_death" .. tostring(self._unit:key()), {
		"death",
	}, callback(self, self, "clbk_death"))
end

function HuskCopBrain:interaction_voice()
	return self._interaction_voice
end

function HuskCopBrain:on_long_distance_interact(amount, instigator)
	amount = math.clamp(math.ceil(amount * 10), 0, 10)

	self._unit:network():send_to_host("long_distance_interaction", amount, instigator)

	return self._interaction_voice
end

function HuskCopBrain:clbk_death(my_unit, damage_info)
	if self._alert_listen_key then
		managers.groupai:state():remove_alert_listener(self._alert_listen_key)

		self._alert_listen_key = nil
	end

	if self._unit:inventory():equipped_unit() then
		self._unit:inventory():equipped_unit():base():set_laser_enabled(false)
	end
end

function HuskCopBrain:set_interaction_voice(voice)
	self._interaction_voice = voice
end

function HuskCopBrain:load(load_data)
	local my_load_data = load_data.brain

	self:set_interaction_voice(my_load_data.interaction_voice)

	if my_load_data.weapon_laser_on then
		self:sync_net_event(self._NET_EVENTS.weapon_laser_on)
	end
end

function HuskCopBrain:on_cool_state_changed(state)
	return
end

function HuskCopBrain:on_action_completed(action)
	return
end

function HuskCopBrain:on_alert(alert_data)
	if self._unit:id() == -1 then
		return
	end

	if TimerManager:game():time() - self._last_alert_t < 5 then
		return
	end

	if CopLogicBase._chk_alert_obstructed(self._unit:movement():m_head_pos(), alert_data) then
		return
	end

	self._unit:network():send_to_host("alert", alert_data[5])

	self._last_alert_t = TimerManager:game():time()
end

function HuskCopBrain:on_team_set(team_data)
	return
end

function HuskCopBrain:sync_net_event(event_id)
	if event_id == self._NET_EVENTS.weapon_laser_on then
		self._weapon_laser_on = true

		if self._unit:inventory() and self._unit:inventory():equipped_unit() and self._unit:inventory():equipped_unit():base() and self._unit:inventory():equipped_unit():base().set_laser_enabled then
			self._unit:inventory():equipped_unit():base():set_laser_enabled(true)
		end

		managers.enemy:_destroy_unit_gfx_lod_data(self._unit:key())
	elseif event_id == self._NET_EVENTS.weapon_laser_off then
		self._weapon_laser_on = nil

		if self._unit:inventory() and self._unit:inventory():equipped_unit() and self._unit:inventory():equipped_unit():base() and self._unit:inventory():equipped_unit():base().set_laser_enabled then
			self._unit:inventory():equipped_unit():base():set_laser_enabled(false)
		end

		if not self._unit:character_damage():dead() then
			managers.enemy:_create_unit_gfx_lod_data(self._unit)
		end
	end
end

function HuskCopBrain:pre_destroy()
	if Network:is_server() then
		self._unit:movement():set_attention()
	else
		self._unit:movement():synch_attention()
	end

	if self._alert_listen_key then
		managers.groupai:state():remove_alert_listener(self._alert_listen_key)

		self._alert_listen_key = nil
	end

	if self._weapon_laser_on then
		self:sync_net_event(self._NET_EVENTS.weapon_laser_off)
	end

	managers.enemy:_destroy_unit_gfx_lod_data(self._unit:key())
end

function HuskCopBrain:distance_to_target()
	return self._distance_to_target
end

function HuskCopBrain:set_distance_to_target(distance)
	self._distance_to_target = distance
end

function HuskCopBrain:anim_clbk_throw_flare(unit)
	return
end
