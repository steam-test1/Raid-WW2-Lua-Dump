TeamAIBrain = TeamAIBrain or class(CopBrain)
TeamAIBrain._create_attention_setting_from_descriptor = PlayerMovement._create_attention_setting_from_descriptor
TeamAIBrain.objective = CopBrain.objective
TeamAIBrain.is_objective_type = CopBrain.is_objective_type

function TeamAIBrain:init(unit)
	self._unit = unit
	self._timer = TimerManager:game()

	self:set_update_enabled_state(false)

	self._active = true
	self._current_logic = nil
	self._current_logic_name = nil
	self._SO_access = managers.navigation:convert_access_flag(tweak_data.character[unit:base()._tweak_table].access)
	self._reload_clbks[unit:key()] = callback(self, self, "on_reload")
end

function TeamAIBrain:post_init()
	self._logics = self:_get_logic_variant(self._unit:base()._tweak_table)

	self:_reset_logic_data()

	local my_key = tostring(self._unit:key())

	self._unit:character_damage():add_listener("TeamAIBrain_hurt" .. my_key, {
		"bleedout",
		"hurt",
		"light_hurt",
		"heavy_hurt",
		"none",
	}, callback(self, self, "clbk_damage"))
	self._unit:character_damage():add_listener("TeamAIBrain_death" .. my_key, {
		"death",
	}, callback(self, self, "clbk_death"))
	managers.groupai:state():add_listener("TeamAIBrain" .. my_key, {
		"enemy_weapons_hot",
	}, callback(self, self, "clbk_weapons_hot"))

	if not self._current_logic then
		self:set_init_logic("idle")
	end

	self:_setup_attention_handler()

	self._alert_listen_key = "TeamAIBrain" .. my_key

	local alert_listen_filter = managers.groupai:state():get_unit_type_filter("combatant")

	managers.groupai:state():add_alert_listener(self._alert_listen_key, callback(self, self, "on_alert"), alert_listen_filter, {
		bullet = true,
		vo_intimidate = true,
	}, self._unit:movement():m_head_pos())
end

function TeamAIBrain:current_logic_name()
	return self._current_logic_name
end

function TeamAIBrain:_reset_logic_data()
	TeamAIBrain.super._reset_logic_data(self)

	self._logic_data.enemy_slotmask = managers.slot:get_mask("enemies")

	local group_ai_state = managers.groupai:state()

	self._logic_data.objective_complete_clbk = callback(group_ai_state, group_ai_state, "on_criminal_objective_complete")
	self._logic_data.objective_failed_clbk = callback(group_ai_state, group_ai_state, "on_criminal_objective_failed")
end

function TeamAIBrain:set_spawn_ai(spawn_ai)
	TeamAIBrain.super.set_spawn_ai(self, spawn_ai)

	if managers.groupai:state():enemy_weapons_hot() then
		self:clbk_weapons_hot()
	end
end

function TeamAIBrain:clbk_damage(my_unit, damage_info)
	self._current_logic.damage_clbk(self._logic_data, damage_info)
end

function TeamAIBrain:clbk_death(my_unit, damage_info)
	TeamAIBrain.super.clbk_death(self, my_unit, damage_info)
	self:set_objective()
end

function TeamAIBrain:on_cop_neutralized(cop_key)
	return self._current_logic.on_cop_neutralized(self._logic_data, cop_key)
end

function TeamAIBrain:on_long_distance_interact(amount, instigator)
	if self._unit:anim_data().forced then
		Application:debug("[TeamAIBrain:on_long_distance_interact] ignore while parachuting")

		return
	end

	self._unit:movement():set_cool(false)

	return self._current_logic.on_long_distance_interact(self._logic_data, instigator)
end

function TeamAIBrain:on_recovered(reviving_unit)
	self._current_logic.on_recovered(self._logic_data, reviving_unit)
end

function TeamAIBrain:clbk_weapons_hot()
	self._current_logic.clbk_weapons_hot(self._logic_data)
end

function TeamAIBrain:pre_destroy(unit)
	TeamAIBrain.super.pre_destroy(self, unit)

	self._reload_clbks[unit:key()] = nil

	managers.groupai:state():remove_listener(self._alert_listen_key)
end

function TeamAIBrain:set_active(state)
	TeamAIBrain.super.set_active(self, state)

	if not state then
		self:set_objective()
	end

	self._unit:character_damage():disable()
end

function TeamAIBrain:_setup_attention_handler()
	TeamAIBrain.super._setup_attention_handler(self)
	self:on_cool_state_changed(self._unit:movement():cool())
end

function TeamAIBrain:on_cool_state_changed(state)
	if self._logic_data then
		self._logic_data.cool = state
	end

	if not self._attention_handler then
		return
	end

	local att_settings = {
		state and "team_team_idle" or "team_enemy_cbt",
	}

	PlayerMovement.set_attention_settings(self, att_settings)
end

function TeamAIBrain:clbk_attention_notice_sneak(observer_unit, status)
	return
end

function TeamAIBrain:_chk_enable_bodybag_interaction()
	self._unit:interaction():set_tweak_data("dead")
end
