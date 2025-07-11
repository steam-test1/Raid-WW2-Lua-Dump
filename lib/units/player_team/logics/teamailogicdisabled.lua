require("lib/units/enemies/cop/logics/CopLogicAttack")

TeamAILogicDisabled = class(TeamAILogicAssault)
TeamAILogicDisabled.on_long_distance_interact = TeamAILogicIdle.on_long_distance_interact

function TeamAILogicDisabled.enter(data, new_logic_name, enter_params)
	local my_data = {
		unit = data.unit,
	}

	TeamAILogicBase.enter(data, new_logic_name, enter_params, my_data)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data

	data.internal_data = my_data
	my_data.detection = data.char_tweak.detection.combat
	my_data.vision = data.char_tweak.vision.combat

	local slot = PlayerInventory.SLOT_1
	local inventory = data.unit:inventory()

	if inventory:is_selection_available(slot) and inventory:equipped_selection() ~= slot then
		inventory:equip_selection(slot, false)
	end

	local usage = data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage

	my_data.weapon_range = data.char_tweak.weapon[usage].range
	my_data.enemy_detect_slotmask = managers.slot:get_mask("enemies")

	if old_internal_data then
		CopLogicAttack._set_best_cover(data, my_data, old_internal_data.best_cover)
		CopLogicAttack._set_nearest_cover(my_data, old_internal_data.nearest_cover)

		my_data.attention_unit = old_internal_data.attention_unit
	end

	local key_str = tostring(data.key)

	my_data.detection_task_key = "TeamAILogicDisabled._upd_enemy_detection" .. key_str

	CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicDisabled._upd_enemy_detection, data, data.t)

	my_data.stay_cool = nil

	if data.unit:character_damage():need_revive() then
		TeamAILogicDisabled._register_revive_SO(data, my_data, "revive")
	end

	data.unit:brain():set_update_enabled_state(false)

	if not data.unit:character_damage():bleed_out() then
		my_data.invulnerable = true

		data.unit:character_damage():set_invulnerable(true)
	end

	if data.objective then
		data.objective_failed_clbk(data.unit, data.objective, true)
		data.unit:brain():set_objective(nil)
	end
end

function TeamAILogicDisabled.exit(data, new_logic_name, enter_params)
	TeamAILogicBase.exit(data, new_logic_name, enter_params)

	local my_data = data.internal_data

	my_data.exiting = true

	TeamAILogicDisabled._unregister_revive_SO(my_data)

	if my_data.invulnerable then
		data.unit:character_damage():set_invulnerable(false)
	end

	CopLogicBase.cancel_queued_tasks(my_data)

	if new_logic_name ~= "inactive" then
		data.unit:brain():set_update_enabled_state(true)
	end
end

function TeamAILogicDisabled._upd_enemy_detection(data)
	data.t = TimerManager:game():time()

	local my_data = data.internal_data
	local delay = CopLogicBase._upd_attention_obj_detection(data, AIAttentionObject.REACT_SURPRISED, nil)
	local new_attention, new_prio_slot, new_reaction = TeamAILogicIdle._get_priority_attention(data, data.detected_attention_objects, nil, data.cool)

	TeamAILogicBase._set_attention_obj(data, new_attention, new_reaction)
	TeamAILogicDisabled._upd_aim(data, my_data)
	CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicDisabled._upd_enemy_detection, data, data.t + delay)
end

function TeamAILogicDisabled._upd_aim(data, my_data)
	local shoot, aim
	local focus_enemy = data.attention_obj

	if my_data.stay_cool then
		-- block empty
	elseif focus_enemy then
		local should_shoot = focus_enemy and focus_enemy.reaction >= AIAttentionObject.REACT_SHOOT
		local should_aim = should_shoot or focus_enemy and focus_enemy.reaction >= AIAttentionObject.REACT_AIM

		if focus_enemy.verified then
			if focus_enemy.verified_dis < 2000 or my_data.alert_t and data.t - my_data.alert_t < 7 then
				shoot = should_shoot
			end
		elseif focus_enemy.verified_t and data.t - focus_enemy.verified_t < 10 then
			aim = should_aim

			if my_data.shooting and data.t - focus_enemy.verified_t < 3 then
				shoot = should_shoot
			end
		elseif focus_enemy.verified_dis < 600 and my_data.walking_to_cover_shoot_pos then
			aim = should_aim
		end
	end

	if aim or shoot then
		if focus_enemy.verified then
			if my_data.attention_unit ~= focus_enemy.u_key then
				CopLogicBase._set_attention(data, focus_enemy)

				my_data.attention_unit = focus_enemy.u_key
			end
		elseif my_data.attention_unit ~= focus_enemy.verified_pos then
			CopLogicBase._set_attention_on_pos(data, mvector3.copy(focus_enemy.verified_pos))

			my_data.attention_unit = mvector3.copy(focus_enemy.verified_pos)
		end
	else
		if my_data.shooting then
			local new_action

			if data.unit:anim_data().reload then
				new_action = {
					body_part = 3,
					type = "reload",
				}
			else
				new_action = {
					body_part = 3,
					type = "idle",
				}
			end

			data.unit:brain():action_request(new_action)
		end

		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)

			my_data.attention_unit = nil
		end
	end

	if shoot then
		if not my_data.firing then
			data.unit:movement():set_allow_fire(true)

			my_data.firing = true
		end
	elseif my_data.firing then
		data.unit:movement():set_allow_fire(false)

		my_data.firing = nil
	end
end

function TeamAILogicDisabled.on_recovered(data, reviving_unit)
	local my_data = data.internal_data

	if reviving_unit and my_data.rescuer and my_data.rescuer:key() == reviving_unit:key() then
		my_data.rescuer = nil
	else
		TeamAILogicDisabled._unregister_revive_SO(my_data)
	end

	CopLogicBase._exit_to_state(data.unit, "assault")
end

function TeamAILogicDisabled._register_revive_SO(data, my_data, rescue_type)
	local followup_objective = {
		action = {
			blocks = {
				action = -1,
				aim = -1,
				heavy_hurt = -1,
				hurt = -1,
				walk = -1,
			},
			body_part = 1,
			type = "act",
			variant = "crouch",
		},
		scan = true,
		type = "act",
	}
	local objective = {
		action = {
			align_sync = true,
			blocks = {
				action = -1,
				aim = -1,
				heavy_hurt = -1,
				hurt = -1,
				light_hurt = -1,
				walk = -1,
			},
			body_part = 1,
			type = "act",
			variant = rescue_type,
		},
		action_duration = tweak_data.interaction:get_interaction(data.name == "surrender" and "free" or "revive").timer,
		called = true,
		destroy_clbk_key = false,
		fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", data),
		follow_unit = data.unit,
		followup_objective = followup_objective,
		nav_seg = data.unit:movement():nav_tracker():nav_segment(),
		scan = true,
		type = "revive",
	}
	local so_descriptor = {
		AI_group = "friendlies",
		admin_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_administered", data),
		base_chance = 1,
		chance_inc = 0,
		interval = 6,
		objective = objective,
		search_dis_sq = 1000000,
		search_pos = mvector3.copy(data.m_pos),
		usage_amount = 1,
	}
	local so_id = "TeamAIrevive" .. tostring(data.key)

	my_data.SO_id = so_id

	managers.groupai:state():add_special_objective(so_id, so_descriptor)

	my_data.deathguard_SO_id = PlayerBleedOut._register_deathguard_SO(data.unit)
end

function TeamAILogicDisabled._unregister_revive_SO(my_data)
	if my_data.deathguard_SO_id then
		PlayerBleedOut._unregister_deathguard_SO(my_data.deathguard_SO_id)

		my_data.deathguard_SO_id = nil
	end

	if my_data.rescuer then
		local rescuer = my_data.rescuer

		my_data.rescuer = nil

		if rescuer:brain():objective() then
			managers.groupai:state():on_criminal_objective_failed(rescuer, rescuer:brain():objective())
		end
	elseif my_data.SO_id then
		managers.groupai:state():remove_special_objective(my_data.SO_id)

		my_data.SO_id = nil
	end
end

function TeamAILogicDisabled.is_available_for_assignment(data, new_objective)
	return false
end

function TeamAILogicDisabled.damage_clbk(data, damage_info)
	local my_data = data.internal_data

	if data.unit:character_damage():need_revive() and not my_data.SO_id and not my_data.rescuer then
		TeamAILogicDisabled._register_revive_SO(data, my_data, "revive")
	end

	TeamAILogicIdle.damage_clbk(data, damage_info)
end

function TeamAILogicDisabled.on_revive_SO_administered(ignore_this, data, receiver_unit)
	local my_data = data.internal_data

	my_data.rescuer = receiver_unit
	my_data.SO_id = nil
end

function TeamAILogicDisabled.on_revive_SO_failed(ignore_this, data)
	local my_data = data.internal_data

	if my_data.rescuer and data.unit:character_damage():need_revive() and not my_data.exiting then
		my_data.rescuer = nil

		TeamAILogicDisabled._register_revive_SO(data, my_data, "revive")
	end
end

function TeamAILogicDisabled.on_new_objective(data, old_objective)
	TeamAILogicBase.on_new_objective(data, old_objective)

	if old_objective and old_objective.fail_clbk then
		old_objective.fail_clbk(data.unit)
	end
end
