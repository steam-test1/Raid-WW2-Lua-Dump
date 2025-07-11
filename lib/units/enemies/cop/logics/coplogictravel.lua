local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

CopLogicTravel = class(CopLogicBase)
CopLogicTravel.death_clbk = CopLogicAttack.death_clbk
CopLogicTravel.on_criminal_neutralized = CopLogicAttack.on_criminal_neutralized

function CopLogicTravel.enter(data, new_logic_name, enter_params)
	if not data.objective then
		return
	end

	local my_data = {
		unit = data.unit,
	}

	CopLogicBase.enter(data, new_logic_name, enter_params, my_data)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data
	local is_cool = data.unit:movement():cool()

	if is_cool then
		my_data.detection = data.char_tweak.detection.ntl
		my_data.vision = data.char_tweak.vision.idle
	else
		my_data.detection = data.char_tweak.detection.recon
		my_data.vision = data.char_tweak.vision.combat
	end

	if old_internal_data then
		my_data.turning = old_internal_data.turning
		my_data.firing = old_internal_data.firing
		my_data.shooting = old_internal_data.shooting
		my_data.attention_unit = old_internal_data.attention_unit
	end

	if data.char_tweak.announce_incomming then
		my_data.announce_t = data.t + 2
	end

	data.internal_data = my_data

	local key_str = tostring(data.key)

	my_data.upd_task_key = "CopLogicTravel.queued_update" .. key_str

	CopLogicTravel.queue_update(data, my_data)

	my_data.cover_update_task_key = "CopLogicTravel._update_cover" .. key_str

	if my_data.nearest_cover or my_data.best_cover then
		CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", data), data.t + 1)
	end

	my_data.advance_path_search_id = "CopLogicTravel_detailed" .. tostring(data.key)
	my_data.coarse_path_search_id = "CopLogicTravel_coarse" .. tostring(data.key)

	CopLogicBase._chk_has_old_action(data, my_data)

	local objective = data.objective
	local path_data = objective.path_data

	if objective.path_style == "warp" then
		my_data.warp_pos = objective.pos
	elseif path_data then
		local path_style = objective.path_style

		if path_style == "precise" then
			local path = {
				mvector3.copy(data.m_pos),
			}

			for _, point in ipairs(path_data.points) do
				table.insert(path, mvector3.copy(point.position))
			end

			my_data.advance_path = path
			my_data.coarse_path_index = 1

			local start_seg = data.unit:movement():nav_tracker():nav_segment()
			local end_pos = mvector3.copy(path[#path])
			local end_seg = managers.navigation:get_nav_seg_from_pos(end_pos)

			my_data.coarse_path = {
				{
					start_seg,
				},
				{
					end_seg,
					end_pos,
				},
			}
			my_data.path_is_precise = true
		elseif path_style == "coarse" then
			local nav_manager = managers.navigation
			local f_get_nav_seg = nav_manager.get_nav_seg_from_pos
			local start_seg = data.unit:movement():nav_tracker():nav_segment()
			local path = {
				{
					start_seg,
				},
			}

			for _, point in ipairs(path_data.points) do
				local pos = mvector3.copy(point.position)
				local nav_seg = f_get_nav_seg(nav_manager, pos)

				table.insert(path, {
					nav_seg,
					pos,
				})
			end

			my_data.coarse_path = path

			local i = CopLogicTravel.complete_coarse_path(data, my_data, path)

			if not i then
				my_data.coarse_path_index = 1
			else
				my_data.coarse_path_index = i
			end
		elseif path_style == "coarse_complete" then
			my_data.coarse_path = deep_clone(objective.path_data)

			local i = CopLogicTravel.complete_coarse_path(data, my_data, my_data.coarse_path)

			if not i then
				my_data.coarse_path_index = 1
			else
				my_data.coarse_path_index = i
			end
		end
	end

	if objective.stance then
		local upper_body_action = data.unit:movement()._active_actions[3]

		if not upper_body_action or upper_body_action:type() ~= "shoot" then
			data.unit:movement():set_stance(objective.stance)
		end
	end

	if data.attention_obj and data.attention_obj.reaction > AIAttentionObject.REACT_AIM then
		data.unit:movement():set_cool(false, managers.groupai:state().analyse_giveaway(data.unit:base()._tweak_table, data.attention_obj.unit))
	end

	if is_cool then
		data.unit:brain():set_attention_settings({
			peaceful = true,
		})
	else
		data.unit:brain():set_attention_settings({
			cbt = true,
		})
	end

	local usage = data.unit:inventory():equipped_selection() and data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage

	if usage then
		my_data.weapon_range = data.char_tweak.weapon[usage].range
		my_data.weapon_range_max = data.char_tweak.weapon[usage].max_range
		my_data.additional_weapon_stats = data.char_tweak.weapon[usage].additional_weapon_stats
	end

	my_data.attitude = data.objective.attitude or "avoid"
	my_data.path_ahead = data.objective.path_ahead or false
	my_data.path_safely = data.team.foes[tweak_data.levels:get_default_team_ID("player")]

	data.unit:brain():set_update_enabled_state(false)

	if Application:production_build() then
		my_data.pathing_debug = {
			from_pos = Vector3(),
			to_pos = Vector3(),
		}
	end
end

function CopLogicTravel.exit(data, new_logic_name, enter_params)
	CopLogicBase.exit(data, new_logic_name, enter_params)

	local my_data = data.internal_data

	data.unit:brain():cancel_all_pathing_searches()
	CopLogicBase.cancel_queued_tasks(my_data)
	CopLogicBase.cancel_delayed_clbks(my_data)
	data.brain:rem_pos_rsrv("path")
	data.unit:brain():set_update_enabled_state(true)
end

function CopLogicTravel.queued_update(data)
	local my_data = data.internal_data

	data.t = TimerManager:game():time()
	my_data.close_to_criminal = nil

	local delay = CopLogicTravel._upd_enemy_detection(data)

	if data.internal_data ~= my_data then
		return
	end

	CopLogicTravel.upd_advance(data)

	if data.internal_data ~= my_data then
		return
	end

	CopLogicTravel.queue_update(data, data.internal_data, delay)
end

function CopLogicTravel.upd_advance(data)
	local unit = data.unit
	local my_data = data.internal_data
	local objective = data.objective
	local t = TimerManager:game():time()

	data.t = t

	if my_data.has_old_action then
		CopLogicAttack._upd_stop_old_action(data, my_data)

		if my_data.has_old_action then
			return
		end
	end

	if my_data.warp_pos then
		data.unit:movement():set_position(objective.pos)

		if objective.rot then
			data.unit:movement():set_rotation(objective.rot)
		end

		CopLogicTravel._on_destination_reached(data)
	elseif my_data.advancing then
		if my_data.coarse_path then
			if my_data.announce_t and t > my_data.announce_t then
				CopLogicTravel._try_anounce(data, my_data)
			end

			CopLogicTravel._chk_stop_for_follow_unit(data, my_data)

			if my_data ~= data.internal_data then
				return
			end
		end
	elseif my_data.advance_path then
		CopLogicTravel._chk_begin_advance(data, my_data)

		if my_data.advancing and my_data.path_ahead then
			CopLogicTravel._check_start_path_ahead(data)
		end
	elseif my_data.processing_advance_path or my_data.processing_coarse_path then
		CopLogicTravel._upd_pathing(data, my_data)

		if my_data ~= data.internal_data then
			return
		end
	elseif my_data.cover_leave_t then
		if not my_data.turning and not unit:movement():chk_action_forbidden("walk") and not data.unit:anim_data().reload then
			if t > my_data.cover_leave_t then
				my_data.cover_leave_t = nil
			elseif data.attention_obj and data.attention_obj.reaction >= AIAttentionObject.REACT_SCARED and (not my_data.best_cover or not my_data.best_cover[NavigationManager.COVER_RESERVED]) and not unit:anim_data().crouch and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch) then
				CopLogicAttack._request_action_crouch(data)
			end
		end
	elseif objective and (objective.nav_seg or objective.type == "follow") then
		local path_ok = CopLogicTravel._verifiy_coarse_path(objective.nav_seg, my_data.coarse_path)

		if my_data.coarse_path and path_ok then
			if my_data.coarse_path_index == #my_data.coarse_path then
				CopLogicTravel._on_destination_reached(data)

				return
			else
				CopLogicTravel._chk_start_pathing_to_next_nav_point(data, my_data)
			end
		else
			CopLogicTravel._begin_coarse_pathing(data, my_data)
		end
	else
		CopLogicBase._exit_to_state(data.unit, "idle")

		return
	end
end

function CopLogicTravel._verifiy_coarse_path(nav_seg, path)
	if not nav_seg or not path then
		return true
	end

	if path[#path][1] == nav_seg then
		return true
	end

	return false
end

function CopLogicTravel._upd_enemy_detection(data)
	managers.groupai:state():on_unit_detection_updated(data.unit)

	local my_data = data.internal_data
	local delay = CopLogicBase._upd_attention_obj_detection(data, nil, nil)
	local new_attention, new_prio_slot, new_reaction = CopLogicBase._get_priority_attention(data, data.detected_attention_objects, nil)
	local old_att_obj = data.attention_obj

	CopLogicBase._set_attention_obj(data, new_attention, new_reaction)

	local objective = data.objective
	local allow_trans, obj_failed = CopLogicBase.is_obstructed(data, objective, nil, new_attention)

	if allow_trans and (obj_failed or not objective or objective.type ~= "follow") then
		local wanted_state = CopLogicBase._get_logic_state_from_reaction(data)

		if wanted_state and wanted_state ~= data.name then
			if obj_failed then
				data.objective_failed_clbk(data.unit, data.objective)
			end

			if my_data == data.internal_data and objective and not objective.is_default then
				debug_pause_unit(data.unit, "[CopLogicTravel._upd_enemy_detection] exiting without discarding objective", data.unit, inspect(objective))
				CopLogicBase._exit_to_state(data.unit, wanted_state)
			end

			CopLogicBase._report_detections(data.detected_attention_objects)

			return delay
		end
	end

	if my_data == data.internal_data then
		if data.cool and new_reaction == AIAttentionObject.REACT_SUSPICIOUS and CopLogicBase._upd_suspicion(data, my_data, new_attention) then
			CopLogicBase._report_detections(data.detected_attention_objects)

			return delay
		elseif new_reaction and new_reaction <= AIAttentionObject.REACT_SCARED then
			local set_attention = data.unit:movement():attention()

			if not set_attention or set_attention.u_key ~= new_attention.u_key then
				CopLogicBase._set_attention(data, new_attention, nil)
			end
		end

		CopLogicAttack._upd_aim(data, my_data)
	end

	CopLogicBase._report_detections(data.detected_attention_objects)

	if new_attention and data.char_tweak.chatter.entrance and not data.entrance and new_attention.criminal_record and new_attention.verified and new_reaction >= AIAttentionObject.REACT_SCARED and math.abs(data.m_pos.z - new_attention.m_pos.z) < 4000 then
		data.unit:sound():say(data.brain.entrance_chatter_cue or "entrance", true, nil)

		data.entrance = true
	end

	if data.cool then
		CopLogicTravel.upd_suspicion_decay(data)
	end

	return delay
end

function CopLogicTravel._upd_pathing(data, my_data)
	if data.pathing_results then
		local pathing_results = data.pathing_results

		data.pathing_results = nil

		local path = pathing_results[my_data.advance_path_search_id]

		if path and my_data.processing_advance_path then
			my_data.processing_advance_path = nil
			data.unit:brain().path_failed = false

			if path ~= "failed" then
				my_data.advance_path = path
			else
				if Application:production_build() then
					local txt = "[CopLogicTravel:_upd_pathing] advance_path failed"

					if false and managers.groupai:visualization_enabled() then
						debug_pause_unit(data.unit, txt, data.unit, my_data.coarse_path_index, inspect(my_data.coarse_path))
						Application:draw_line(data.m_pos, my_data.pathing_debug.from_pos, 1, 0, 0)
						Application:draw_cone(my_data.pathing_debug.to_pos, my_data.pathing_debug.from_pos, 20, 1, 0, 0)
					end
				end

				data.path_fail_t = data.t
				data.unit:brain().path_failed = true

				data.objective_failed_clbk(data.unit, data.objective)

				return
			end
		end

		local path = pathing_results[my_data.coarse_path_search_id]

		if path and my_data.processing_coarse_path then
			my_data.processing_coarse_path = nil

			if path ~= "failed" then
				my_data.coarse_path = path
				my_data.coarse_path_index = 1
				data.unit:brain().path_failed = false
			elseif my_data.path_safely then
				my_data.path_safely = nil
			else
				data.path_fail_t = data.t
				data.unit:brain().path_failed = true

				data.objective_failed_clbk(data.unit, data.objective)

				return
			end
		end
	end
end

function CopLogicTravel._update_cover(ignore_this, data)
	local my_data = data.internal_data

	CopLogicBase.on_delayed_clbk(my_data, my_data.cover_update_task_key)

	local cover_release_dis = 100
	local nearest_cover = my_data.nearest_cover
	local best_cover = my_data.best_cover
	local m_pos = data.m_pos

	if not my_data.in_cover and nearest_cover and cover_release_dis < mvector3.distance(nearest_cover[1][NavigationManager.COVER_POSITION], m_pos) then
		managers.navigation:release_cover(nearest_cover[1])

		my_data.nearest_cover = nil
		nearest_cover = nil
	end

	if best_cover and cover_release_dis < mvector3.distance(best_cover[1][NavigationManager.COVER_POSITION], m_pos) then
		managers.navigation:release_cover(best_cover[1])

		my_data.best_cover = nil
		best_cover = nil
	end

	if nearest_cover or best_cover then
		CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", data), data.t + math.rand(1.9, 2.1))
	end
end

function CopLogicTravel._chk_request_action_turn_to_cover(data, my_data)
	local fwd = data.unit:movement():m_rot():y()

	mvector3.set(tmp_vec1, my_data.best_cover[1][NavigationManager.COVER_FORWARD])
	mvector3.negate(tmp_vec1)

	local error_spin = tmp_vec1:to_polar_with_reference(fwd, math.UP).spin

	if math.abs(error_spin) > 25 then
		local new_action_data = {}

		new_action_data.type = "turn"
		new_action_data.body_part = 2
		new_action_data.angle = error_spin
		my_data.turning = data.unit:brain():action_request(new_action_data)

		if my_data.turning then
			return true
		end
	end
end

function CopLogicTravel._chk_cover_height(data, cover, slotmask)
	local ray_from = tmp_vec1

	mvector3.set(ray_from, math.UP)
	mvector3.multiply(ray_from, 110)
	mvector3.add(ray_from, cover[1])

	local ray_to = tmp_vec2

	mvector3.set(ray_to, cover[NavigationManager.COVER_FORWARD])
	mvector3.multiply(ray_to, 200)
	mvector3.add(ray_to, ray_from)

	local ray = World:raycast("ray", ray_from, ray_to, "slot_mask", slotmask, "ray_type", "ai_vision", "report")

	return ray
end

function CopLogicTravel.on_action_completed(data, action)
	local my_data = data.internal_data
	local action_type = action:type()

	if action_type == "walk" then
		if action:expired() and not my_data.starting_advance_action and my_data.coarse_path_index and not my_data.has_old_action and my_data.advancing and not my_data.skip_coarse then
			local step = my_data.coarse_path_step or 1

			my_data.coarse_path_step = 1
			my_data.coarse_path_index = my_data.coarse_path_index + step

			if my_data.coarse_path_index > #my_data.coarse_path then
				my_data.coarse_path_index = my_data.coarse_path_index - 1
			end
		end

		my_data.skip_coarse = false
		my_data.advancing = nil

		if my_data.moving_to_cover then
			if action:expired() then
				if my_data.best_cover then
					managers.navigation:release_cover(my_data.best_cover[1])
				end

				my_data.best_cover = my_data.moving_to_cover

				CopLogicBase.chk_cancel_delayed_clbk(my_data, my_data.cover_update_task_key)

				local high_ray = CopLogicTravel._chk_cover_height(data, my_data.best_cover[1], data.visibility_slotmask)

				my_data.best_cover[NavigationManager.COVER_RESERVED] = high_ray
				my_data.in_cover = true

				local cover_wait_time = my_data.coarse_path_index == #my_data.coarse_path - 1 and 0.3 or 0.6 + 0.4 * math.random()

				if not CopLogicTravel._chk_close_to_criminal(data, my_data) then
					cover_wait_time = 0
				end

				local close_in_fast = data.team.foes[tweak_data.levels:get_default_team_ID("player")] and not my_data.attention_unit

				if close_in_fast then
					cover_wait_time = 0
				end

				my_data.cover_leave_t = data.t + cover_wait_time
			else
				managers.navigation:release_cover(my_data.moving_to_cover[1])

				if my_data.best_cover then
					local dis = mvector3.distance(my_data.best_cover[1][NavigationManager.COVER_POSITION], data.unit:movement():m_pos())

					if dis > 100 then
						managers.navigation:release_cover(my_data.best_cover[1])

						my_data.best_cover = nil
					end
				end
			end

			my_data.moving_to_cover = nil
		elseif my_data.best_cover then
			local dis = mvector3.distance(my_data.best_cover[1][NavigationManager.COVER_POSITION], data.unit:movement():m_pos())

			if dis > 100 then
				managers.navigation:release_cover(my_data.best_cover[1])

				my_data.best_cover = nil
			end
		end

		if not action:expired() then
			if my_data.processing_advance_path then
				local pathing_results = data.pathing_results

				if pathing_results and pathing_results[my_data.advance_path_search_id] then
					data.pathing_results[my_data.advance_path_search_id] = nil
					my_data.processing_advance_path = nil
				end
			elseif my_data.advance_path then
				my_data.advance_path = nil
			end

			data.unit:brain():abort_detailed_pathing(my_data.advance_path_search_id)
		end
	elseif action_type == "turn" then
		data.internal_data.turning = nil
	elseif action_type == "shoot" then
		data.internal_data.shooting = nil
	elseif action_type == "dodge" then
		local objective = data.objective
		local allow_trans, obj_failed = CopLogicBase.is_obstructed(data, objective, nil, nil)

		if allow_trans then
			local wanted_state = data.logic._get_logic_state_from_reaction(data)

			if wanted_state and wanted_state ~= data.name and obj_failed then
				if data.unit:in_slot(managers.slot:get_mask("enemies")) or data.unit:in_slot(17) then
					data.objective_failed_clbk(data.unit, data.objective)
				elseif data.unit:in_slot(managers.slot:get_mask("criminals")) then
					managers.groupai:state():on_criminal_objective_failed(data.unit, data.objective, false)
				end

				if my_data == data.internal_data then
					CopLogicBase._exit_to_state(data.unit, wanted_state)
				end
			end
		end
	elseif action_type == "act" and action._action_desc and action._action_desc.complete_callback then
		action._action_desc.complete_callback(data.unit)
	end
end

function CopLogicTravel._get_pos_accross_door(guard_door, nav_seg)
	local rooms = guard_door.rooms
	local room_1_seg = guard_door.low_seg
	local accross_vec = guard_door.high_pos - guard_door.low_pos
	local rot_angle = 90

	if room_1_seg == nav_seg then
		if guard_door.low_pos.y == guard_door.high_pos.y then
			rot_angle = rot_angle * -1
		end
	elseif guard_door.low_pos.x == guard_door.high_pos.x then
		rot_angle = rot_angle * -1
	end

	mvector3.rotate_with(accross_vec, Rotation(rot_angle))

	local max_dis = 1500

	mvector3.set_length(accross_vec, 1500)

	local door_pos = guard_door.center
	local door_tracker = managers.navigation:create_nav_tracker(mvector3.copy(door_pos))
	local accross_positions = managers.navigation:find_walls_accross_tracker(door_tracker, accross_vec)

	if accross_positions then
		local optimal_dis = math.lerp(max_dis * 0.6, max_dis, math.random())
		local best_error_dis, best_pos, best_is_hit, best_is_miss, best_has_too_much_error

		for _, accross_pos in ipairs(accross_positions) do
			local error_dis = math.abs(mvector3.distance(accross_pos[1], door_pos) - optimal_dis)
			local too_much_error = error_dis / optimal_dis > 0.3
			local is_hit = accross_pos[2]

			if best_is_hit then
				if is_hit then
					if error_dis < best_error_dis then
						best_pos = accross_pos[1]
						best_error_dis = error_dis
						best_has_too_much_error = too_much_error
					end
				elseif best_has_too_much_error then
					best_pos = accross_pos[1]
					best_error_dis = error_dis
					best_is_miss = true
					best_is_hit = nil
				end
			elseif best_is_miss then
				if not too_much_error then
					best_pos = accross_pos[1]
					best_error_dis = error_dis
					best_has_too_much_error = nil
					best_is_miss = nil
					best_is_hit = true
				end
			else
				best_pos = accross_pos[1]
				best_is_hit = is_hit
				best_is_miss = not is_hit
				best_has_too_much_error = too_much_error
				best_error_dis = error_dis
			end
		end

		managers.navigation:destroy_nav_tracker(door_tracker)

		return best_pos
	end

	managers.navigation:destroy_nav_tracker(door_tracker)
end

function CopLogicTravel.is_available_for_assignment(data, new_objective)
	if new_objective and new_objective.forced then
		return true
	elseif data.objective and data.objective.type == "act" then
		if (not new_objective or new_objective and new_objective.type == "free") and data.objective.interrupt_dis == -1 then
			return true
		end

		return
	else
		return CopLogicAttack.is_available_for_assignment(data, new_objective)
	end
end

function CopLogicTravel.is_advancing(data)
	if data.internal_data.advancing and data.pos_rsrv.move_dest then
		return data.pos_rsrv.move_dest.position
	end
end

function CopLogicTravel._reserve_pos_along_vec(look_pos, wanted_pos)
	local step_vec = look_pos - wanted_pos
	local max_pos_mul = math.floor(mvector3.length(step_vec) / 65)

	mvector3.set_length(step_vec, 65)

	local data = {
		block = max_pos_mul == 0,
		max_pos_mul = max_pos_mul,
		start_pos = wanted_pos,
		step_mul = max_pos_mul > 0 and 1 or -1,
		step_vec = step_vec,
	}
	local step_clbk = callback(CopLogicTravel, CopLogicTravel, "_rsrv_pos_along_vec_step_clbk", data)
	local res_data = managers.navigation:reserve_pos(TimerManager:game():time(), 1, wanted_pos, step_clbk, 30, data.pos_rsrv_id)

	return res_data
end

function CopLogicTravel._rsrv_pos_along_vec_step_clbk(shait, data, test_pos)
	local step_mul = data.step_mul
	local nav_manager = managers.navigation
	local step_vec = data.step_vec

	mvector3.set(test_pos, step_vec)
	mvector3.multiply(test_pos, step_mul)
	mvector3.add(test_pos, data.start_pos)

	local params = {
		allow_entry = false,
		pos_from = data.start_pos,
		pos_to = test_pos,
	}
	local blocked = nav_manager:raycast(params)

	if blocked then
		if data.block then
			return false
		end

		data.block = true

		if step_mul > 0 then
			data.step_mul = -step_mul
		else
			data.step_mul = -step_mul + 1

			if data.step_mul > data.max_pos_mul then
				return
			end
		end

		return CopLogicTravel._rsrv_pos_along_vec_step_clbk(shait, data, test_pos)
	elseif data.block then
		data.step_mul = step_mul + math.sign(step_mul)

		if data.step_mul > data.max_pos_mul then
			return
		end
	elseif step_mul > 0 then
		data.step_mul = -step_mul
	else
		data.step_mul = -step_mul + 1

		if data.step_mul > data.max_pos_mul then
			data.block = true
			data.step_mul = -data.step_mul
		end
	end

	return true
end

function CopLogicTravel._investigate_coarse_path_verify_clbk(shait, nav_seg)
	return managers.groupai:state():is_nav_seg_safe(nav_seg)
end

function CopLogicTravel._chk_request_action_walk_to_advance_pos(data, my_data, speed, end_rot, no_strafe, end_pose)
	if not data.unit:movement():chk_action_forbidden("walk") or data.unit:anim_data().act_idle then
		CopLogicAttack._adjust_path_start_pos(data, my_data.advance_path)

		local path = my_data.advance_path
		local new_action_data = {
			body_part = 2,
			end_pose = end_pose,
			end_rot = end_rot,
			nav_path = path,
			no_strafe = no_strafe,
			path_simplified = my_data.path_is_precise,
			type = "walk",
			variant = speed or "run",
		}

		my_data.advance_path = nil
		my_data.starting_advance_action = true
		my_data.advancing = data.unit:brain():action_request(new_action_data)
		my_data.starting_advance_action = false

		if my_data.advancing then
			data.brain:rem_pos_rsrv("path")

			if my_data.nearest_cover and (not my_data.delayed_clbks or not my_data.delayed_clbks[my_data.cover_update_task_key]) then
				CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", data), data.t + 1)
			end
		end
	end
end

function CopLogicTravel._determine_destination_occupation(data, objective)
	local occupation

	if objective.type == "defend_area" then
		if objective.cover then
			occupation = {
				cover = objective.cover,
				radius = objective.radius,
				seg = objective.nav_seg,
				type = "defend",
			}
		elseif objective.pos then
			occupation = {
				pos = objective.pos,
				radius = objective.radius,
				seg = objective.nav_seg,
				type = "defend",
			}
		else
			local near_pos = objective.follow_unit and objective.follow_unit:movement():nav_tracker():field_position()
			local cover = CopLogicTravel._find_cover(data, objective.nav_seg, near_pos)

			if cover then
				occupation = {
					cover = {
						cover,
					},
					radius = objective.radius,
					seg = objective.nav_seg,
					type = "defend",
				}
			else
				local nav_seg = managers.navigation._nav_segments[objective.nav_seg]

				if nav_seg then
					near_pos = CopLogicTravel._get_pos_on_wall(nav_seg.pos, 700)
					occupation = {
						pos = near_pos,
						radius = objective.radius,
						seg = objective.nav_seg,
						type = "defend",
					}
				else
					debug_pause("[CopLogicTravel._determine_destination_occupation] Can't find nav_seg for the objective!?", inspect(objective), inspect(managers.navigation._nav_segments))
				end
			end
		end
	elseif objective.type == "phalanx" then
		local logic = data.unit:brain():get_logic_by_name(objective.type)

		logic.register_in_group_ai(data.unit)

		local phalanx_circle_pos = logic.calc_initial_phalanx_pos(data.m_pos, objective)

		occupation = {
			pos = phalanx_circle_pos,
			radius = objective.radius,
			seg = objective.nav_seg,
			type = "defend",
		}
	elseif objective.type == "act" then
		occupation = {
			pos = objective.pos,
			seg = objective.nav_seg,
			type = "act",
		}
	elseif objective.type == "follow" then
		local my_data = data.internal_data
		local follow_tracker = objective.follow_unit:movement():nav_tracker()
		local dest_nav_seg_id = my_data.coarse_path[#my_data.coarse_path][1]
		local dest_area = managers.groupai:state():get_area_from_nav_seg_id(dest_nav_seg_id)
		local follow_pos = follow_tracker:field_position()
		local threat_pos

		if data.attention_obj and data.attention_obj.nav_tracker and data.attention_obj.reaction >= AIAttentionObject.REACT_COMBAT then
			threat_pos = data.attention_obj.nav_tracker:field_position()
		end

		local cover = managers.navigation:find_cover_in_nav_seg_3(dest_area.nav_segs, nil, follow_pos, threat_pos)

		if cover then
			occupation = {
				cover = {
					cover,
				},
				type = "defend",
			}
		else
			local max_dist

			if objective.called then
				max_dist = 600
			end

			local to_pos = CopLogicTravel._get_pos_on_wall(dest_area.pos, max_dist)

			occupation = {
				pos = to_pos,
				type = "defend",
			}
		end
	elseif objective.type == "revive" then
		local is_local_player = objective.follow_unit:base().is_local_player
		local revive_u_mv = objective.follow_unit:movement()
		local revive_u_tracker = revive_u_mv:nav_tracker()
		local revive_u_rot = is_local_player and Rotation(0, 0, 0) or revive_u_mv:m_rot()
		local revive_u_fwd = revive_u_rot:y()
		local revive_u_right = revive_u_rot:x()
		local revive_u_pos = revive_u_tracker:lost() and revive_u_tracker:field_position() or revive_u_mv:m_pos()
		local ray_params = {
			trace = true,
			tracker_from = revive_u_tracker,
		}

		if revive_u_tracker:lost() then
			ray_params.pos_from = revive_u_pos
		end

		local stand_dis

		if is_local_player or objective.follow_unit:base().is_husk_player then
			stand_dis = 120
		else
			stand_dis = 90

			local mid_pos = mvector3.copy(revive_u_fwd)

			mvector3.multiply(mid_pos, -20)
			mvector3.add(mid_pos, revive_u_pos)

			ray_params.pos_to = mid_pos

			local ray_res = managers.navigation:raycast(ray_params)

			revive_u_pos = ray_params.trace[1]
		end

		local rand_side_mul = math.rand_bool() and 1 or -1
		local revive_pos = mvector3.copy(revive_u_right)

		mvector3.multiply(revive_pos, rand_side_mul * stand_dis)
		mvector3.add(revive_pos, revive_u_pos)

		ray_params.pos_to = revive_pos

		local ray_res = managers.navigation:raycast(ray_params)

		if ray_res then
			local opposite_pos = mvector3.copy(revive_u_right)

			mvector3.multiply(opposite_pos, -rand_side_mul * stand_dis)
			mvector3.add(opposite_pos, revive_u_pos)

			ray_params.pos_to = opposite_pos

			local opposite_ray_res = managers.navigation:raycast(ray_params)

			if opposite_ray_res then
				if mvector3.distance(ray_params.trace[1], revive_u_pos) > mvector3.distance(revive_pos, revive_u_pos) then
					revive_pos = ray_params.trace[1]
				else
					revive_pos = ray_params.trace[1]
				end
			else
				revive_pos = ray_params.trace[1]
			end
		else
			revive_pos = ray_params.trace[1]
		end

		local revive_rot = revive_u_pos - revive_pos
		local revive_rot = Rotation(revive_rot, math.UP)

		occupation = {
			pos = revive_pos,
			rot = revive_rot,
			type = "revive",
		}
	else
		occupation = {
			pos = objective.pos,
			seg = objective.nav_seg,
		}
	end

	return occupation
end

function CopLogicTravel._get_pos_on_wall(from_pos, max_dist, step_offset, is_recurse)
	local nav_manager = managers.navigation
	local nr_rays = 7
	local ray_dis = max_dist or 1000
	local step = 360 / nr_rays
	local offset = step_offset or math.random(360)
	local step_rot = Rotation(step)
	local offset_rot = Rotation(offset)
	local offset_vec = Vector3(ray_dis, 0, 0)

	mvector3.rotate_with(offset_vec, offset_rot)

	local to_pos = mvector3.copy(from_pos)

	mvector3.add(to_pos, offset_vec)

	local from_tracker = nav_manager:create_nav_tracker(from_pos)
	local ray_params = {
		allow_entry = false,
		pos_to = to_pos,
		trace = true,
		tracker_from = from_tracker,
	}
	local rsrv_desc = {
		false,
		60,
	}
	local fail_position

	repeat
		to_pos = mvector3.copy(from_pos)

		mvector3.add(to_pos, offset_vec)

		ray_params.pos_to = to_pos

		local ray_res = nav_manager:raycast(ray_params)

		if ray_res then
			rsrv_desc.position = ray_params.trace[1]

			local is_free = nav_manager:is_pos_free(rsrv_desc)

			if is_free then
				managers.navigation:destroy_nav_tracker(from_tracker)

				return ray_params.trace[1]
			end
		elseif not fail_position then
			rsrv_desc.position = ray_params.trace[1]

			local is_free = nav_manager:is_pos_free(rsrv_desc)

			if is_free then
				fail_position = to_pos
			end
		end

		mvector3.rotate_with(offset_vec, step_rot)

		nr_rays = nr_rays - 1
	until nr_rays == 0

	managers.navigation:destroy_nav_tracker(from_tracker)

	if fail_position then
		return fail_position
	end

	if not is_recurse then
		return CopLogicTravel._get_pos_on_wall(from_pos, ray_dis * 0.5, offset + step * 0.5, true)
	end

	return from_pos
end

function CopLogicTravel.queue_update(data, my_data, delay)
	delay = data.important and 0 or delay or 0.3

	CopLogicBase.queue_task(my_data, my_data.upd_task_key, CopLogicTravel.queued_update, data, data.t + delay, data.important and true)
end

function CopLogicTravel._try_anounce(data, my_data)
	local my_pos = data.m_pos
	local max_dis_sq = 2250000
	local my_key = data.key
	local announce_type = data.char_tweak.announce_incomming

	for u_key, u_data in pairs(managers.enemy:all_enemies()) do
		if u_key ~= my_key and tweak_data.character[u_data.unit:base()._tweak_table].chatter[announce_type] and max_dis_sq > mvector3.distance_sq(my_pos, u_data.m_pos) and not u_data.unit:sound():speaking(data.t) and (u_data.unit:anim_data().idle or u_data.unit:anim_data().move) then
			managers.groupai:state():chk_say_enemy_chatter(u_data.unit, u_data.m_pos, announce_type)

			my_data.announce_t = data.t + 15

			break
		end
	end
end

function CopLogicTravel._get_all_paths(data)
	return {
		advance_path = data.internal_data.advance_path,
	}
end

function CopLogicTravel._set_verified_paths(data, verified_paths)
	data.internal_data.advance_path = verified_paths.advance_path
end

function CopLogicTravel.chk_should_turn(data, my_data)
	return not my_data.advancing and not my_data.turning and not my_data.has_old_action and not data.unit:movement():chk_action_forbidden("walk") and (not my_data.coarse_path or not (my_data.coarse_path_index >= #my_data.coarse_path - 1) or not data.objective.rot)
end

function CopLogicTravel.complete_coarse_path(data, my_data, coarse_path)
	local first_seg_id = coarse_path[1][1]
	local current_seg_id = data.unit:movement():nav_tracker():nav_segment()
	local all_nav_segs = managers.navigation._nav_segments

	if not coarse_path[1][2] then
		coarse_path[1][2] = mvector3.copy(all_nav_segs[first_seg_id].pos)
	end

	if first_seg_id ~= current_seg_id then
		table.insert(coarse_path, 1, {
			current_seg_id,
			mvector3.copy(data.m_pos),
		})
	end

	local i_nav_point = 1

	while i_nav_point < #coarse_path do
		local nav_seg_id = coarse_path[i_nav_point][1]
		local next_nav_seg_id = coarse_path[i_nav_point + 1][1]
		local nav_seg = all_nav_segs[nav_seg_id]

		if not nav_seg.neighbours[next_nav_seg_id] then
			local search_params = {
				access_pos = data.SO_access,
				from_seg = nav_seg_id,
				id = "CopLogicTravel_complete_coarse_path",
				to_seg = next_nav_seg_id,
			}
			local ins_coarse_path = managers.navigation:search_coarse(search_params)

			if not ins_coarse_path then
				return
			end

			local i_insert = #ins_coarse_path - 1

			while i_insert > 1 do
				table.insert(coarse_path, i_nav_point + 1, ins_coarse_path[i_insert])

				i_insert = i_insert - 1
			end
		end

		i_nav_point = i_nav_point + 1
	end

	if #coarse_path == 1 then
		table.insert(coarse_path, 1, {
			current_seg_id,
			mvector3.copy(data.m_pos),
		})
	end

	local start_index

	for i, nav_point in ipairs(coarse_path) do
		if current_seg_id == nav_point[1] then
			start_index = i
		end
	end

	if start_index then
		start_index = math.min(start_index, #coarse_path - 1)

		return start_index
	end

	local to_search_segs = {
		current_seg_id,
	}
	local found_segs = {
		[current_seg_id] = "init",
	}

	repeat
		local search_seg_id = table.remove(to_search_segs, 1)
		local search_seg = all_nav_segs[search_seg_id]

		for other_seg_id, door_list in pairs(search_seg.neighbours) do
			local other_seg = all_nav_segs[other_seg_id]

			if not other_seg.disabled and not found_segs[other_seg_id] then
				found_segs[other_seg_id] = search_seg_id

				if other_seg_id == first_seg_id then
					local last_added_seg_id = other_seg_id

					while found_segs[last_added_seg_id] ~= "init" do
						last_added_seg_id = found_segs[last_added_seg_id]

						table.insert(coarse_path, 1, {
							last_added_seg_id,
							all_nav_segs[last_added_seg_id].pos,
						})
					end

					return 1
				else
					table.insert(to_search_segs, other_seg_id)
				end
			end
		end
	until #to_search_segs == 0

	return 1
end

function CopLogicTravel._chk_close_to_criminal(data, my_data)
	if my_data.close_to_criminal == nil then
		my_data.close_to_criminal = false

		local my_area = managers.groupai:state():get_area_from_nav_seg_id(data.unit:movement():nav_tracker():nav_segment())

		if next(my_area.criminal.units) then
			my_data.close_to_criminal = true
		else
			for _, nbr in pairs(my_area.neighbours) do
				if next(nbr.criminal.units) then
					my_data.close_to_criminal = true

					break
				end
			end
		end
	end

	return my_data.close_to_criminal
end

CopLogicTravel._TRAVEL_GROUP_WAIT_DISTANCE = 4000000
CopLogicTravel._TRAVEL_GROUP_WAIT_TOLERANCE = 1.3224999999999998

function CopLogicTravel.chk_group_ready_to_move(data, my_data)
	local my_objective = data.objective

	if not my_objective.grp_objective then
		return true
	end

	if not CopLogicTravel._chk_close_to_criminal(data, my_data) then
		return true
	end

	local my_dis = mvector3.distance_sq(my_objective.area.pos, data.m_pos)

	if my_dis > CopLogicTravel._TRAVEL_GROUP_WAIT_DISTANCE then
		return true
	end

	my_dis = my_dis * CopLogicTravel._TRAVEL_GROUP_WAIT_TOLERANCE

	for u_key, u_data in pairs(data.group.units) do
		if u_key ~= data.key then
			local his_objective = u_data.unit:brain():objective()

			if his_objective and his_objective.grp_objective == my_objective.grp_objective and not his_objective.in_place then
				local his_dis = mvector3.distance_sq(his_objective.area.pos, u_data.m_pos)

				if my_dis < his_dis then
					return false
				end
			end
		end
	end

	return true
end

function CopLogicTravel.apply_wall_offset_to_cover(data, my_data, cover, wall_fwd_offset)
	local to_pos_fwd = tmp_vec1

	mvector3.set(to_pos_fwd, cover[NavigationManager.COVER_FORWARD])
	mvector3.multiply(to_pos_fwd, wall_fwd_offset)
	mvector3.add(to_pos_fwd, cover[1])

	local ray_params = {
		pos_to = to_pos_fwd,
		trace = true,
		tracker_from = cover[NavigationManager.COVER_TRACKER],
	}
	local collision = managers.navigation:raycast(ray_params)

	if not collision then
		return cover[1]
	end

	local col_pos_fwd = ray_params.trace[1]
	local space_needed = mvector3.distance(col_pos_fwd, to_pos_fwd) + wall_fwd_offset * 1.05
	local to_pos_bwd = tmp_vec2

	mvector3.set(to_pos_bwd, cover[NavigationManager.COVER_FORWARD])
	mvector3.multiply(to_pos_bwd, -space_needed)
	mvector3.add(to_pos_bwd, cover[1])

	local ray_params = {
		pos_to = to_pos_bwd,
		trace = true,
		tracker_from = cover[NavigationManager.COVER_TRACKER],
	}
	local collision = managers.navigation:raycast(ray_params)

	return collision and ray_params.trace[1] or mvector3.copy(to_pos_bwd)
end

function CopLogicTravel._find_cover(data, search_nav_seg, near_pos)
	local cover
	local search_area = managers.groupai:state():get_area_from_nav_seg_id(search_nav_seg)

	if not search_area then
		return
	end

	if data.unit:movement():cool() then
		cover = managers.navigation:find_cover_in_nav_seg_1(search_area.nav_segs)
	else
		local optimal_threat_dis, threat_pos

		if data.objective.attitude == "engage" then
			optimal_threat_dis = data.internal_data.weapon_range.optimal
		else
			optimal_threat_dis = data.internal_data.weapon_range.far
		end

		near_pos = near_pos or search_area.pos

		local all_criminals = managers.groupai:state():all_char_criminals()
		local closest_crim_u_data, closest_crim_dis

		for u_key, u_data in pairs(all_criminals) do
			local crim_area = managers.groupai:state():get_area_from_nav_seg_id(u_data.tracker:nav_segment())

			if crim_area == search_area then
				threat_pos = u_data.m_pos

				break
			else
				local crim_dis = mvector3.distance_sq(near_pos, u_data.m_pos)

				if not closest_crim_dis or crim_dis < closest_crim_dis then
					threat_pos = u_data.m_pos
					closest_crim_dis = crim_dis
				end
			end
		end

		cover = managers.navigation:find_cover_from_threat(search_area.nav_segs, optimal_threat_dis, near_pos, threat_pos)
	end

	return cover
end

function CopLogicTravel._get_allowed_travel_nav_segs(data, my_data, to_pos)
	local nav_segs = {}
	local added_segs = {}

	for _, nav_point in ipairs(my_data.coarse_path) do
		local area = managers.groupai:state():get_area_from_nav_seg_id(nav_point[1])

		if not area then
			return nil
		end

		for nav_seg_id, _ in pairs(area.nav_segs) do
			if not added_segs[nav_seg_id] then
				added_segs[nav_seg_id] = true

				table.insert(nav_segs, nav_seg_id)
			end
		end
	end

	local end_nav_seg = managers.navigation:get_nav_seg_from_pos(to_pos, true)
	local end_area = managers.groupai:state():get_area_from_nav_seg_id(end_nav_seg)

	for nav_seg_id, _ in pairs(end_area.nav_segs) do
		if not added_segs[nav_seg_id] then
			added_segs[nav_seg_id] = true

			table.insert(nav_segs, nav_seg_id)
		end
	end

	local standing_nav_seg = data.unit:movement():nav_tracker():nav_segment()

	if not added_segs[standing_nav_seg] then
		table.insert(nav_segs, standing_nav_seg)

		added_segs[standing_nav_seg] = true
	end

	return nav_segs
end

function CopLogicTravel._check_start_path_ahead(data)
	local my_data = data.internal_data

	if my_data.processing_advance_path then
		return
	end

	local objective = data.objective
	local coarse_path = my_data.coarse_path

	if not my_data.coarse_path_index then
		local txt = "[CopLogicTravel._check_start_path_ahead] my_data.coarse_path_index is nill! "

		if managers.groupai:visualization_enabled() then
			debug_pause_unit(data.unit, txt, data.unit, my_data.coarse_path_index, inspect(my_data.coarse_path))
			Application:draw_line(data.m_pos, my_data.pathing_debug.from_pos, 1, 0, 0)
			Application:draw_cone(my_data.pathing_debug.to_pos, my_data.pathing_debug.from_pos, 20, 1, 0, 0)
		else
			print(txt, data.unit, my_data.coarse_path_index, inspect(my_data.coarse_path))
		end

		return
	end

	local next_index = my_data.coarse_path_index + my_data.coarse_path_step + 1
	local total_nav_points = #coarse_path

	if total_nav_points < next_index then
		return
	end

	local to_pos = data.logic._get_exact_move_pos(data, next_index)

	if not to_pos then
		CopLogicTravel._begin_coarse_pathing(data, my_data)

		return
	end

	my_data.processing_advance_path = true

	local prio = data.logic.get_pathing_prio(data)
	local from_pos = data.pos_rsrv.move_dest.position
	local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(data, my_data, to_pos)

	if not nav_segs then
		CopLogicTravel._begin_coarse_pathing(data, my_data)

		return
	end

	if Application:production_build() then
		mvector3.set(my_data.pathing_debug.from_pos, from_pos)
		mvector3.set(my_data.pathing_debug.to_pos, to_pos)
	end

	data.unit:brain():search_for_path_from_pos(my_data.advance_path_search_id, from_pos, to_pos, prio, nil, nav_segs)
end

function CopLogicTravel.get_pathing_prio(data)
	local prio
	local objective = data.objective

	if objective and (objective.follow_unit and (objective.follow_unit:base().is_local_player or objective.follow_unit:base().is_husk_player) or objective.type == "phalanx") then
		prio = 4

		if data.team.id == tweak_data.levels:get_default_team_ID("player") then
			prio = prio + 1
		end
	end

	return prio
end

function CopLogicTravel._get_exact_move_pos(data, nav_index)
	local my_data = data.internal_data
	local objective = data.objective
	local to_pos
	local coarse_path = my_data.coarse_path
	local total_nav_points = #coarse_path
	local reservation, wants_reservation

	if total_nav_points <= nav_index then
		local new_occupation = data.logic._determine_destination_occupation(data, objective)

		if new_occupation then
			if new_occupation.type == "guard" then
				local guard_door = new_occupation.door
				local guard_pos = CopLogicTravel._get_pos_accross_door(guard_door, objective.nav_seg)

				if guard_pos then
					reservation = CopLogicTravel._reserve_pos_along_vec(guard_door.center, guard_pos)

					if reservation then
						local guard_object = {
							door = guard_door,
							from_seg = new_occupation.from_seg,
							type = "door",
						}

						objective.guard_obj = guard_object
						to_pos = reservation.pos
					end
				end
			elseif new_occupation.type == "defend" then
				if new_occupation.cover then
					to_pos = new_occupation.cover[1][NavigationManager.COVER_POSITION]

					if data.char_tweak.wall_fwd_offset then
						to_pos = CopLogicTravel.apply_wall_offset_to_cover(data, my_data, new_occupation.cover[1], data.char_tweak.wall_fwd_offset)
					end

					if my_data.moving_to_cover then
						managers.navigation:release_cover(my_data.moving_to_cover[1])
					end

					local new_cover = new_occupation.cover

					managers.navigation:reserve_cover(new_cover[1], data.pos_rsrv_id)

					my_data.moving_to_cover = new_cover
				elseif new_occupation.pos then
					to_pos = new_occupation.pos
				end

				wants_reservation = true
			elseif new_occupation.type == "act" then
				to_pos = new_occupation.pos
				wants_reservation = true
			elseif new_occupation.type == "revive" then
				to_pos = new_occupation.pos
				objective.rot = new_occupation.rot
				wants_reservation = true
			else
				to_pos = new_occupation.pos
				wants_reservation = true
			end
		end

		if not to_pos then
			to_pos = managers.navigation:find_random_position_in_segment(objective.nav_seg)
			to_pos = CopLogicTravel._get_pos_on_wall(to_pos)
			wants_reservation = true
		end
	else
		if my_data.moving_to_cover then
			managers.navigation:release_cover(my_data.moving_to_cover[1])

			my_data.moving_to_cover = nil
		end

		local nav_seg = coarse_path[nav_index][1]
		local area = managers.groupai:state():get_area_from_nav_seg_id(nav_seg)

		if not area then
			return nil
		end

		local want_cover = true

		if want_cover then
			local cover = want_cover and managers.navigation:find_cover_in_nav_seg_1(area.nav_segs)

			if cover then
				managers.navigation:reserve_cover(cover, data.pos_rsrv_id)

				my_data.moving_to_cover = {
					cover,
				}
				to_pos = cover[1]
			else
				to_pos = coarse_path[nav_index][2]
			end
		else
			to_pos = coarse_path[nav_index][2]
		end
	end

	if not reservation and wants_reservation then
		data.brain:add_pos_rsrv("path", {
			position = mvector3.copy(to_pos),
			radius = 60,
		})
	end

	return to_pos
end

function CopLogicTravel._on_destination_reached(data)
	local objective = data.objective

	objective.in_place = true

	if objective.type == "free" or objective.type == "turret" then
		if not objective.action_duration then
			data.objective_complete_clbk(data.unit, objective)

			return
		end
	elseif objective.type == "flee" then
		data.unit:brain():set_active(false)
		data.unit:base():set_slot(data.unit, 0)

		return
	elseif objective.type == "defend_area" then
		if objective.grp_objective and objective.grp_objective.type == "retire" then
			if not objective.grp_objective.action then
				data.unit:brain():set_active(false)
				data.unit:base():set_slot(data.unit, 0)

				return
			else
				objective.grp_objective.type = "act"
			end
		else
			managers.groupai:state():on_defend_travel_end(data.unit, objective)
		end
	end

	data.logic.on_new_objective(data)
end

function CopLogicTravel._chk_start_pathing_to_next_nav_point(data, my_data)
	if not CopLogicTravel.chk_group_ready_to_move(data, my_data) then
		return
	end

	local total_nav_points = #my_data.coarse_path
	local step = 1

	if total_nav_points - my_data.coarse_path_index > 1 then
		step = 1
	end

	my_data.coarse_path_step = step

	local to_pos = CopLogicTravel._get_exact_move_pos(data, my_data.coarse_path_index + step)

	if not to_pos then
		CopLogicTravel._begin_coarse_pathing(data, my_data)

		return
	end

	my_data.processing_advance_path = true

	local prio = data.logic.get_pathing_prio(data)
	local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(data, my_data, to_pos)

	if not nav_segs then
		CopLogicTravel._begin_coarse_pathing(data, my_data)

		return
	end

	if Application:production_build() then
		mvector3.set(my_data.pathing_debug.from_pos, data.m_pos)
		mvector3.set(my_data.pathing_debug.to_pos, to_pos)
	end

	data.unit:brain():search_for_path(my_data.advance_path_search_id, to_pos, prio, nil, nav_segs)
end

function CopLogicTravel._begin_coarse_pathing(data, my_data)
	local verify_clbk

	if my_data.path_safely then
		verify_clbk = callback(CopLogicTravel, CopLogicTravel, "_investigate_coarse_path_verify_clbk")
	end

	local nav_seg

	if data.objective.follow_unit and alive(data.objective.follow_unit:movement():nav_tracker()) then
		nav_seg = data.objective.follow_unit:movement():nav_tracker():nav_segment()
	else
		nav_seg = data.objective.nav_seg
	end

	if data.unit:brain():search_for_coarse_path(my_data.coarse_path_search_id, nav_seg, verify_clbk) then
		my_data.processing_coarse_path = true
	end
end

function CopLogicTravel._chk_begin_advance(data, my_data)
	if data.unit:movement():chk_action_forbidden("walk") then
		return
	end

	local objective = data.objective
	local haste

	if objective and objective.haste then
		haste = objective.haste
	else
		haste = data.unit:movement():cool() and "walk" or "run"
	end

	local pose

	pose = not data.char_tweak.crouch_move and "stand" or data.char_tweak.allowed_poses and not data.char_tweak.allowed_poses.stand and "crouch" or data.is_suppressed and "crouch" or objective and objective.pose or "stand"

	if not data.unit:anim_data()[pose] then
		CopLogicAttack["_request_action_" .. pose](data)
	end

	local end_rot

	if my_data.coarse_path_index >= #my_data.coarse_path - 1 then
		end_rot = objective and objective.rot
	end

	local no_strafe = false
	local close_in_fast = not data.unit:movement():cool() and data.team.foes[tweak_data.levels:get_default_team_ID("player")] and not my_data.attention_unit

	if close_in_fast then
		pose = "stand"
		haste = "run"
		no_strafe = true
	end

	local end_pose

	if my_data.moving_to_cover and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch) then
		end_pose = "crouch"
	end

	if data.char_tweak.never_strafe then
		no_strafe = true
	end

	CopLogicTravel._chk_request_action_walk_to_advance_pos(data, my_data, haste, end_rot, no_strafe, end_pose)
end

function CopLogicTravel._chk_stop_for_follow_unit(data, my_data)
	local objective = data.objective

	if objective.type ~= "follow" or data.unit:movement():chk_action_forbidden("walk") or data.unit:anim_data().act_idle then
		return
	end

	if not my_data.coarse_path_index then
		debug_pause_unit(data.unit, "[CopLogicTravel._chk_stop_for_follow_unit]", data.unit, inspect(data), inspect(my_data))

		return
	end

	local follow_unit_nav_seg = data.objective.follow_unit:movement():nav_tracker():nav_segment()
	local my_nav_seg = data.unit:movement():nav_tracker():nav_segment()

	if follow_unit_nav_seg == my_nav_seg then
		objective.in_place = true

		data.logic.on_new_objective(data)
	end
end
