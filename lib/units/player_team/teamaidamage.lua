require("lib/units/beings/player/PlayerDamage")

TeamAIDamage = TeamAIDamage or class()
TeamAIDamage._all_event_types = {
	"bleedout",
	"death",
	"hurt",
	"light_hurt",
	"heavy_hurt",
	"none",
}
TeamAIDamage._RESULT_INDEX_TABLE = {
	bleedout = 2,
	death = 3,
	heavy_hurt = 5,
	hurt = 1,
	light_hurt = 4,
}
TeamAIDamage._HEALTH_GRANULARITY = CopDamage._HEALTH_GRANULARITY
TeamAIDamage.set_invulnerable = CopDamage.set_invulnerable
TeamAIDamage._hurt_severities = CopDamage._hurt_severities
TeamAIDamage.get_damage_type = CopDamage.get_damage_type

function TeamAIDamage:init(unit)
	self._unit = unit
	self._char_tweak = tweak_data.character[unit:base()._tweak_table]

	local damage_tweak = self._char_tweak.damage

	self._HEALTH_INIT = damage_tweak.HEALTH_INIT
	self._HEALTH_TOTAL = self._HEALTH_INIT
	self._HEALTH_TOTAL_PERCENT = self._HEALTH_TOTAL / 100
	self._health = self._HEALTH_INIT
	self._health_ratio = self._health / self._HEALTH_INIT
	self._invulnerable = false
	self._char_dmg_tweak = damage_tweak
	self._network_tweak = tweak_data.network.team_ai
	self._focus_delay_mul = 1
	self._listener_holder = EventListenerHolder:new()
	self._bleed_out_paused_count = 0
	self._last_sync_t = 0
	self._dmg_interval = damage_tweak.MIN_DAMAGE_INTERVAL
	self._next_allowed_dmg_t = -100
	self._spine2_obj = unit:get_object(Idstring("Spine2"))
	self._tase_effect_table = {
		effect = tweak_data.common_effects.taser_hit,
		parent = self._unit:get_object(Idstring("e_taser")),
	}
end

function TeamAIDamage:update(unit, t, dt)
	if self._regenerate_t and t > self._regenerate_t then
		self:_regenerated(self._char_dmg_tweak.REGENERATE_RATIO)
	end

	if self._revive_reminder_line_t and t > self._revive_reminder_line_t then
		managers.dialog:queue_dialog("player_gen_call_help", {
			instigator = self._unit,
			skip_idle_check = true,
		})

		self._revive_reminder_line_t = nil
	end
end

function TeamAIDamage:damage_melee(attack_data)
	if self._invulnerable or self._dead then
		return
	end

	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		return
	end

	local result = {
		variant = "melee",
	}
	local _, health_subtracted = self:_apply_damage(attack_data, result)
	local t = TimerManager:game():time()

	self._next_allowed_dmg_t = t + self._dmg_interval
	self._last_received_dmg_t = t

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_melee_attack_result(attack_data)

	return result
end

function TeamAIDamage:force_bleedout()
	local attack_data = {
		col_ray = {
			position = Vector3(),
		},
		damage = 100000,
		pos = Vector3(),
	}
	local result = {
		type = "none",
		variant = "bullet",
	}

	attack_data.result = result

	local _, health_subtracted = self:_apply_damage(attack_data, result, true)

	self._next_allowed_dmg_t = TimerManager:game():time() + self._dmg_interval

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_bullet_attack_result(attack_data)
end

function TeamAIDamage:damage_bullet(attack_data)
	if self:_cannot_take_damage() then
		return
	elseif PlayerDamage._chk_dmg_too_soon(self) then
		return
	elseif PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		self:friendly_fire_hit()

		return
	end

	if self._unit:brain():is_objective_type("revive") then
		attack_data.damage = attack_data.damage * (self._char_tweak.damage.reviving_damage_mul or 1)
	end

	local result = {
		type = "none",
		variant = "bullet",
	}

	attack_data.result = result

	local _, health_subtracted = self:_apply_damage(attack_data, result)
	local t = TimerManager:game():time()

	self._next_allowed_dmg_t = t + self._dmg_interval
	self._last_received_dmg_t = t

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_bullet_attack_result(attack_data)

	return result
end

function TeamAIDamage:damage_explosion(attack_data)
	if self:_cannot_take_damage() then
		return
	end

	local attacker_unit = attack_data.attacker_unit

	if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	if PlayerDamage.is_friendly_fire(self, attacker_unit) then
		self:friendly_fire_hit()

		return
	end

	attack_data.damage = attack_data.damage * (self._char_tweak.damage.explosion_damage_mul or 1)

	if self._unit:brain():is_objective_type("revive") then
		attack_data.damage = attack_data.damage * (self._char_tweak.damage.reviving_damage_mul or 1)
	end

	local result = {
		variant = attack_data.variant,
	}
	local _, health_subtracted = self:_apply_damage(attack_data, result)

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_explosion_attack_result(attack_data)

	return result
end

function TeamAIDamage:damage_fire(attack_data)
	if self:_cannot_take_damage() then
		return
	end

	local attacker_unit = attack_data.attacker_unit

	if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	if PlayerDamage.is_friendly_fire(self, attacker_unit) then
		self:friendly_fire_hit()

		return
	end

	attack_data.damage = attack_data.damage * (self._char_tweak.damage.fire_damage_mul or 1)

	if self._unit:brain():is_objective_type("revive") then
		attack_data.damage = attack_data.damage * (self._char_tweak.damage.reviving_damage_mul or 1)
	end

	local result = {
		variant = attack_data.variant,
	}
	local _, health_subtracted = self:_apply_damage(attack_data, result)

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_fire_attack_result(attack_data)

	return result
end

function TeamAIDamage:damage_mission(attack_data)
	if self._dead or self._invulnerable and not attack_data.forced then
		return
	end

	attack_data.damage = self._health
	attack_data.variant = "explosion"

	local result = {
		variant = attack_data.variant,
	}
	local _, health_subtracted = self:_apply_damage(attack_data, result)

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_explosion_attack_result(attack_data)

	return result
end

function TeamAIDamage:damage_tase(attack_data)
	if attack_data ~= nil and PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		self:friendly_fire_hit()

		return
	end

	if self:_cannot_take_damage() then
		return
	end

	self._regenerate_t = nil

	local damage_info = {
		result = {
			type = "hurt",
		},
		variant = "tase",
	}

	if self._tase_effect then
		World:effect_manager():fade_kill(self._tase_effect)
	end

	self._tase_effect = World:effect_manager():spawn(self._tase_effect_table)

	self:_call_listeners(damage_info)

	if Network:is_server() then
		self:_send_tase_attack_result()
	end

	return damage_info
end

function TeamAIDamage:_apply_damage(attack_data, result, force)
	local damage = attack_data.damage

	damage = math.clamp(damage, self._HEALTH_TOTAL_PERCENT, self._HEALTH_TOTAL)

	local damage_percent = math.ceil(damage / self._HEALTH_TOTAL_PERCENT)

	damage = damage_percent * self._HEALTH_TOTAL_PERCENT
	attack_data.damage = damage

	local dodged

	if not force then
		dodged = self:inc_dodge_count(damage_percent / 2)
	end

	attack_data.pos = attack_data.pos or attack_data.col_ray.position
	attack_data.result = result

	if not force and (dodged or self._unit:anim_data().dodge) then
		result.type = "none"

		return 0, 0
	end

	local health_subtracted = 0

	if not self._bleed_out then
		health_subtracted = self._health
		self._health = self._health - damage

		if self:_check_bleed_out() then
			result.type = "bleedout"
			self._health_ratio = 1
		else
			health_subtracted = damage
			result.type = self:get_damage_type(damage_percent, "bullet") or "none"

			self:_on_hurt()

			self._health_ratio = self._health / self._HEALTH_INIT
		end
	end

	return damage_percent, health_subtracted
end

function TeamAIDamage:friendly_fire_hit()
	self:inc_dodge_count(2)
end

function TeamAIDamage:inc_dodge_count(n)
	local t = Application:time()

	if not self._to_dodge_t or self._to_dodge_t - t < 0 then
		self._to_dodge_t = t
	end

	self._to_dodge_t = self._to_dodge_t + n

	if self._to_dodge_t - t < 3 then
		return
	end

	if self._dodge_t and t - self._dodge_t < 5 then
		return
	end

	self._to_dodge_t = nil
	self._dodge_t = nil

	if CopLogicBase.chk_start_action_dodge(self._unit:brain()._logic_data, "hit") then
		self._dodge_t = t

		self:_on_hurt()

		return true
	end
end

function TeamAIDamage:health_init()
	return self._HEALTH_INIT
end

function TeamAIDamage:health()
	return self._health
end

function TeamAIDamage:down_time()
	return self._char_dmg_tweak.DOWNED_TIME
end

function TeamAIDamage:_check_bleed_out()
	if self._health > 0 then
		return
	end

	self._health = 0
	self._bleed_out = true
	self._regenerate_t = nil
	self._bleed_out_paused_count = 0

	if Network:is_server() then
		if not self._to_dead_clbk_id then
			self._to_dead_clbk_id = "TeamAIDamage_to_dead" .. tostring(self._unit:key())
			self._to_dead_t = TimerManager:game():time() + self:down_time()

			managers.enemy:add_delayed_clbk(self._to_dead_clbk_id, callback(self, self, "clbk_exit_to_dead"), self._to_dead_t)
		end

		managers.dialog:queue_dialog("player_gen_downed", {
			instigator = self._unit,
			skip_idle_check = true,
		})

		self._revive_reminder_line_t = self._to_dead_t - 10
	end

	managers.groupai:state():on_criminal_disabled(self._unit)

	if Network:is_server() then
		managers.groupai:state():report_criminal_downed(self._unit)
	end

	self._unit:interaction():set_tweak_data("revive")
	self._unit:interaction():set_active(true, false)
	managers.hud:on_teammate_downed(self._unit:unit_data().teammate_panel_id, self._unit:unit_data().name_label_id)
	self:_update_health_hud()

	return true
end

TeamAIDamage.get_paused_counter_name_by_peer = PlayerDamage.get_paused_counter_name_by_peer

function TeamAIDamage:pause_bleed_out(peer_id)
	self._bleed_out_paused_count = self._bleed_out_paused_count + 1

	PlayerDamage.set_peer_paused_counter(self, peer_id, "bleed_out")

	if self._bleed_out and self._bleed_out_paused_count == 1 then
		self._to_dead_remaining_t = self._to_dead_t - TimerManager:game():time()

		if self._to_dead_remaining_t < 0 then
			return
		end

		if Network:is_server() then
			managers.enemy:remove_delayed_clbk(self._to_dead_clbk_id)

			self._to_dead_clbk_id = nil
		end

		self._to_dead_t = nil
	end
end

function TeamAIDamage:unpause_bleed_out(peer_id)
	self._bleed_out_paused_count = self._bleed_out_paused_count - 1

	PlayerDamage.set_peer_paused_counter(self, peer_id, nil)

	if self._bleed_out and self._bleed_out_paused_count == 0 then
		self._to_dead_t = TimerManager:game():time() + self._to_dead_remaining_t

		if Network:is_server() and not self._dead and not self._to_dead_clbk_id then
			self._to_dead_clbk_id = "TeamAIDamage_to_dead" .. tostring(self._unit:key())

			managers.enemy:add_delayed_clbk(self._to_dead_clbk_id, callback(self, self, "clbk_exit_to_dead"), self._to_dead_t)
		end

		self._to_dead_remaining_t = nil
	end
end

function TeamAIDamage:stop_bleedout()
	self:_regenerated()
end

function TeamAIDamage:_on_hurt()
	if self._to_incapacitated_clbk_id then
		return
	end

	self:_update_health_hud()
	self:_schedule_regen()
end

function TeamAIDamage:_update_health_hud()
	managers.hud:set_teammate_health(self._unit:unit_data().teammate_panel_id, {
		current = self._health,
		total = self._HEALTH_INIT,
	})

	if Network:is_client() then
		return
	end

	local t = TimerManager:game():time()
	local sync_dt = t - self._last_sync_t

	if sync_dt < self._network_tweak.wait_delta_t then
		return
	end

	local health_percent = math.round(self._health_ratio * 100)

	self._unit:network():send("set_ai_health", math.clamp(health_percent, 0, 100))
end

function TeamAIDamage:_schedule_regen()
	local t = TimerManager:game():time()

	if self._regenerate_t and t < self._regenerate_t then
		return
	end

	if self._health_ratio >= 1 then
		self._regenerate_t = nil

		return
	end

	local regen_time = self:_is_away_from_criminals() and self._char_dmg_tweak.REGENERATE_TIME_AWAY or self._char_dmg_tweak.REGENERATE_TIME

	self._regenerate_t = t + regen_time
end

function TeamAIDamage:_is_away_from_criminals()
	local dis_limit = self._char_dmg_tweak.DISTANCE_IS_AWAY

	for _, crim in pairs(managers.groupai:state():all_player_criminals()) do
		if dis_limit > mvector3.distance_sq(self._unit:movement():m_pos(), crim.unit:movement():m_pos()) then
			return false
		end
	end

	return true
end

function TeamAIDamage:bleed_out()
	return self._bleed_out
end

function TeamAIDamage:is_downed()
	return self._bleed_out
end

function TeamAIDamage:_regenerated(ratio)
	if ratio then
		self._health = math.min(self._health + self._HEALTH_INIT * ratio, self._HEALTH_INIT)
		self._health_ratio = self._health / self._HEALTH_INIT
	else
		self._health = self._HEALTH_INIT
		self._health_ratio = 1
	end

	if self._bleed_out then
		self._bleed_out = nil
		self._bleed_death_t = nil
	end

	self._bleed_out_paused_count = 0
	self._to_dead_t = nil
	self._to_dead_remaining_t = nil
	self._regenerate_t = nil

	self:_clear_damage_transition_callbacks()
	self:_update_health_hud()
	self:_schedule_regen()
end

function TeamAIDamage:_clamp_health_percentage(health_abs)
	health_abs = math.clamp(health_abs, self._HEALTH_TOTAL_PERCENT, self._HEALTH_TOTAL)

	local health_percent = math.ceil(health_abs / self._HEALTH_TOTAL_PERCENT)

	health_abs = health_percent * self._HEALTH_TOTAL_PERCENT

	return health_abs, health_percent
end

function TeamAIDamage:_die()
	self._dead = true
	self._revive_reminder_line_t = nil

	if self._bleed_out then
		self._unit:interaction():set_active(false, false)

		self._bleed_out = nil
	end

	self._regenerate_t = nil
	self._health = 0
	self._health_ratio = 0

	self._unit:base():set_slot(self._unit, 17)
	self:_clear_damage_transition_callbacks()
	self:_update_health_hud()
end

function TeamAIDamage:_unregister_unit()
	local char_name = managers.criminals:character_name_by_unit(self._unit)

	managers.groupai:state():on_AI_criminal_death(char_name, self._unit)
	managers.groupai:state():on_criminal_neutralized(self._unit)
	self._unit:base():unregister()
	self:_clear_damage_transition_callbacks()
	Network:detach_unit(self._unit)
end

function TeamAIDamage:_send_damage_drama(attack_data, health_subtracted)
	PlayerDamage._send_damage_drama(self, attack_data, health_subtracted)
end

function TeamAIDamage:_call_listeners(damage_info)
	CopDamage._call_listeners(self, damage_info)
end

function TeamAIDamage:add_listener(...)
	CopDamage.add_listener(self, ...)
end

function TeamAIDamage:remove_listener(key)
	CopDamage.remove_listener(self, key)
end

function TeamAIDamage:get_base_health()
	return self._HEALTH_INIT
end

function TeamAIDamage:health_ratio()
	return self._health_ratio
end

function TeamAIDamage:set_health_ratio(value)
	self._health_ratio = value
end

function TeamAIDamage:focus_delay_mul()
	return self._focus_delay_mul
end

function TeamAIDamage:dead()
	return self._dead
end

function TeamAIDamage:sync_damage_bullet(attacker_unit, damage, i_body, hit_offset_height)
	if self:_cannot_take_damage() then
		return
	end

	local body = self._unit:body(i_body)

	damage = damage * self._HEALTH_TOTAL_PERCENT

	local result = {
		variant = "bullet",
	}
	local hit_pos = mvector3.copy(self._unit:movement():m_pos())

	mvector3.set_z(hit_pos, hit_pos.z + hit_offset_height)

	local attack_dir

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:movement():m_head_pos()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	local attack_data = {
		attack_dir = attack_dir,
		attacker_unit = attacker_unit,
		damage = damage,
		pos = hit_pos,
		variant = "bullet",
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	self:_send_damage_drama(attack_data, health_subtracted)
	self:_send_bullet_attack_result(attack_data, hit_offset_height)
	self:_call_listeners(attack_data)
end

function TeamAIDamage:sync_damage_explosion(attacker_unit, damage, i_attack_variant)
	if self:_cannot_take_damage() then
		return
	end

	local variant = CopDamage._ATTACK_VARIANTS[i_attack_variant]

	damage = damage * self._HEALTH_TOTAL_PERCENT

	local result = {
		variant = variant,
	}
	local hit_pos = mvector3.copy(self._unit:movement():m_com())
	local attack_dir

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:position()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	local attack_data = {
		attack_dir = attack_dir,
		attacker_unit = attacker_unit,
		damage = damage,
		pos = hit_pos,
		variant = variant,
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	self:_send_damage_drama(attack_data, health_subtracted)
	self:_send_explosion_attack_result(attack_data)
	self:_call_listeners(attack_data)
end

function TeamAIDamage:sync_damage_fire(attacker_unit, damage, i_attack_variant)
	if self:_cannot_take_damage() then
		return
	end

	local variant = CopDamage._ATTACK_VARIANTS[i_attack_variant]

	damage = damage * self._HEALTH_TOTAL_PERCENT

	local result = {
		variant = variant,
	}
	local hit_pos = mvector3.copy(self._unit:movement():m_com())
	local attack_dir

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:position()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	local attack_data = {
		attack_dir = attack_dir,
		attacker_unit = attacker_unit,
		damage = damage,
		pos = hit_pos,
		variant = variant,
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	self:_send_damage_drama(attack_data, health_subtracted)
	self:_send_fire_attack_result(attack_data)
	self:_call_listeners(attack_data)
end

function TeamAIDamage:sync_damage_melee(attacker_unit, damage, damage_effect_percent, i_body, hit_offset_height)
	if self:_cannot_take_damage() then
		return
	end

	local body = self._unit:body(i_body)

	damage = damage * self._HEALTH_TOTAL_PERCENT

	local result = {
		variant = "melee",
	}
	local hit_pos = mvector3.copy(self._unit:movement():m_pos())

	mvector3.set_z(hit_pos, hit_pos.z + hit_offset_height)

	local attack_dir

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:movement():m_head_pos()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()

		mvector3.negate(attack_dir)
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	local attack_data = {
		attack_dir = attack_dir,
		attacker_unit = attacker_unit,
		damage = damage,
		pos = hit_pos,
		variant = "melee",
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	self:_send_damage_drama(attack_data, health_subtracted)
	self:_send_melee_attack_result(attack_data, hit_offset_height)
	self:_call_listeners(attack_data)
end

function TeamAIDamage:shoot_pos_mid(m_pos)
	self._spine2_obj:m_position(m_pos)
end

function TeamAIDamage:need_revive()
	return self._bleed_out and not self._dead
end

function TeamAIDamage:revive(reviving_unit)
	if self._dead then
		return
	end

	self._revive_reminder_line_t = nil

	if self._bleed_out then
		self:_regenerated()

		local action_data = {
			blocks = {
				action = -1,
				aim = -1,
				heavy_hurt = -1,
				hurt = -1,
				walk = -1,
			},
			body_part = 1,
			type = "act",
			variant = "stand",
		}
		local res = self._unit:movement():action_request(action_data)

		self._unit:interaction():set_active(false, false)
		self._unit:brain():on_recovered(reviving_unit)
		PlayerMovement.set_attention_settings(self._unit:brain(), {
			"team_enemy_cbt",
		}, "team_AI")
		self._unit:network():send("from_server_unit_recovered")
		managers.groupai:state():on_criminal_recovered(self._unit)
	end

	managers.hud:on_teammate_revived(self._unit:unit_data().teammate_panel_id, self._unit:unit_data().name_label_id)
	managers.dialog:queue_dialog("player_gen_revive_thanks", {
		instigator = self._unit,
		skip_idle_check = true,
	})
end

function TeamAIDamage:_send_bullet_attack_result(attack_data, hit_offset_height)
	hit_offset_height = hit_offset_height or math.clamp(attack_data.col_ray.position.z - self._unit:movement():m_pos().z, 0, 300)

	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_index = self._RESULT_INDEX_TABLE[attack_data.result.type] or 0

	self._unit:network():send("from_server_damage_bullet", attacker, hit_offset_height, result_index)
end

function TeamAIDamage:_send_explosion_attack_result(attack_data)
	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_index = self._RESULT_INDEX_TABLE[attack_data.result.type] or 0

	self._unit:network():send("from_server_damage_explosion_fire", attacker, result_index, CopDamage._get_attack_variant_index(self, attack_data.variant))
end

function TeamAIDamage:_send_fire_attack_result(attack_data)
	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_index = self._RESULT_INDEX_TABLE[attack_data.result.type] or 0

	self._unit:network():send("from_server_damage_explosion_fire", attacker, result_index, CopDamage._get_attack_variant_index(self, attack_data.variant))
end

function TeamAIDamage:_send_melee_attack_result(attack_data, hit_offset_height)
	hit_offset_height = hit_offset_height or math.clamp(attack_data.col_ray.position.z - self._unit:movement():m_pos().z, 0, 300)

	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_index = self._RESULT_INDEX_TABLE[attack_data.result.type] or 0

	self._unit:network():send("from_server_damage_melee", attacker, hit_offset_height, result_index)
end

function TeamAIDamage:_send_tase_attack_result()
	self._unit:network():send("from_server_damage_tase")
end

function TeamAIDamage:on_tase_ended()
	if self._tase_effect then
		World:effect_manager():fade_kill(self._tase_effect)
	end

	if self._to_incapacitated_clbk_id then
		self._regenerate_t = TimerManager:game():time() + self._char_dmg_tweak.REGENERATE_TIME

		managers.enemy:remove_delayed_clbk(self._to_incapacitated_clbk_id)

		self._to_incapacitated_clbk_id = nil

		local action_data = {
			blocks = {
				action = -1,
				heavy_hurt = -1,
				hurt = -1,
				walk = -1,
			},
			body_part = 1,
			type = "act",
			variant = "stand",
		}
		local res = self._unit:movement():action_request(action_data)

		self._unit:network():send("from_server_unit_recovered")
		managers.groupai:state():on_criminal_recovered(self._unit)
		self._unit:brain():on_recovered()
	end
end

function TeamAIDamage:clbk_exit_to_dead(from_client_join)
	self._to_dead_clbk_id = nil

	self:_die()

	if not from_client_join then
		self._unit:network():send("from_server_damage_bleeding")
	end

	local dmg_info = {
		join_game = from_client_join,
		result = {
			type = "death",
		},
		variant = "bleeding",
	}

	self:_call_listeners(dmg_info)
	self:_unregister_unit()
end

function TeamAIDamage:pre_destroy()
	self:_clear_damage_transition_callbacks()
end

function TeamAIDamage:_cannot_take_damage()
	return self._invulnerable or self._dead
end

function TeamAIDamage:disable()
	self:_clear_damage_transition_callbacks()
end

function TeamAIDamage:_clear_damage_transition_callbacks()
	if self._to_incapacitated_clbk_id then
		managers.enemy:remove_delayed_clbk(self._to_incapacitated_clbk_id)

		self._to_incapacitated_clbk_id = nil
	end

	if self._to_dead_clbk_id then
		managers.enemy:remove_delayed_clbk(self._to_dead_clbk_id)

		self._to_dead_clbk_id = nil
	end
end

function TeamAIDamage:last_suppression_t()
	return self._last_received_dmg_t
end

function TeamAIDamage:can_attach_projectiles()
	return false
end

function TeamAIDamage:save(data)
	data.char_dmg = data.char_dmg or {}
	data.char_dmg.health = self._health

	if self._bleed_out then
		data.char_dmg.bleedout = true
	end
end

function TeamAIDamage:run_queued_teammate_panel_update()
	return
end
