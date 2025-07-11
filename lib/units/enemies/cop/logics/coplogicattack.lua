local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_lerp = mvector3.lerp
local mvec3_norm = mvector3.normalize
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
local temp_vec3 = Vector3()

CopLogicAttack = class(CopLogicBase)
CopLogicAttack.super = CopLogicBase

function CopLogicAttack.enter(data, new_logic_name, enter_params)
	local my_data = {
		unit = data.unit,
	}

	CopLogicBase.enter(data, new_logic_name, enter_params, my_data)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data

	data.internal_data = my_data
	my_data.detection = data.char_tweak.detection.combat
	my_data.vision = data.char_tweak.vision.combat

	local usage = data.unit:inventory():equipped_selection() and data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage

	if usage then
		my_data.weapon_range = data.char_tweak.weapon[usage].range
		my_data.weapon_range_max = data.char_tweak.weapon[usage].max_range
		my_data.additional_weapon_stats = data.char_tweak.weapon[usage].additional_weapon_stats
	end

	if old_internal_data then
		my_data.turning = old_internal_data.turning
		my_data.firing = old_internal_data.firing
		my_data.shooting = old_internal_data.shooting
		my_data.attention_unit = old_internal_data.attention_unit
	end

	my_data.peek_to_shoot_allowed = true
	my_data.detection_task_key = "CopLogicAttack._upd_enemy_detection" .. tostring(data.key)

	CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicAttack._upd_enemy_detection, data, data.t)
	CopLogicBase._chk_has_old_action(data, my_data)

	my_data.attitude = data.objective and data.objective.attitude or "avoid"

	data.unit:brain():set_update_enabled_state(false)

	if data.cool then
		data.unit:movement():set_cool(false)
	end

	if (not data.objective or not data.objective.stance) and data.unit:movement():stance_code() == 1 then
		data.unit:movement():set_stance("hos")
	end

	if my_data ~= data.internal_data then
		return
	end

	my_data.update_queue_id = "CopLogicAttack.queued_update" .. tostring(data.key)

	CopLogicAttack.queue_update(data, my_data, 0)

	if data.objective and (data.objective.action_duration or data.objective.action_timeout_t and data.objective.action_timeout_t > data.t) then
		CopLogicBase.request_action_timeout_callback(data)
	end

	data.unit:brain():set_attention_settings({
		cbt = true,
	})
end

function CopLogicAttack.exit(data, new_logic_name, enter_params)
	CopLogicBase.exit(data, new_logic_name, enter_params)

	local my_data = data.internal_data

	data.unit:brain():cancel_all_pathing_searches()
	CopLogicBase.cancel_queued_tasks(my_data)
	CopLogicBase.cancel_delayed_clbks(my_data)
	data.brain:rem_pos_rsrv("path")
	data.unit:brain():set_update_enabled_state(true)
end

function CopLogicAttack.queued_update(data)
	local my_data = data.internal_data

	data.t = TimerManager:game():time()

	if my_data.has_old_action then
		CopLogicAttack._upd_stop_old_action(data, my_data)

		if my_data.has_old_action then
			CopLogicAttack.queue_update(data, my_data)

			return
		end
	end

	if CopLogicBase._chk_relocate(data) then
		return
	end

	CopLogicAttack._process_pathing_results(data, my_data)

	if not data.attention_obj or data.attention_obj.reaction < AIAttentionObject.REACT_AIM then
		CopLogicAttack._upd_enemy_detection(data, true)

		if my_data ~= data.internal_data or not data.attention_obj then
			return
		end
	end

	if data.attention_obj.reaction >= AIAttentionObject.REACT_COMBAT then
		my_data.want_to_take_cover = CopLogicAttack._chk_wants_to_take_cover(data, my_data)

		CopLogicAttack._update_cover(data)
		CopLogicAttack._upd_combat_movement(data)
	end

	if data.team.id == "criminal1" and (not data.objective or data.objective.type == "free") and (not data.path_fail_t or data.t - data.path_fail_t > 6) then
		managers.groupai:state():on_criminal_jobless(data.unit)

		if my_data ~= data.internal_data then
			return
		end
	end

	CopLogicAttack.queue_update(data, my_data)
end

function CopLogicAttack._upd_combat_movement(data)
	local my_data = data.internal_data
	local unit = data.unit
	local t = data.t
	local focus_enemy = data.attention_obj
	local enemy_visible = focus_enemy.verified
	local enemy_spotted_last_short = focus_enemy.verified_t and t - focus_enemy.verified_t < 3
	local enemy_spotted_last_long = focus_enemy.verified_t and t - focus_enemy.verified_t < 9
	local action_taken = data.logic.action_taken(data, my_data)

	action_taken = action_taken or CopLogicAttack._upd_pose(data, my_data)

	local in_cover = my_data.in_cover
	local want_to_take_cover = my_data.want_to_take_cover
	local move_to_cover = false
	local use_flank_cover = false

	if not my_data.peek_to_shoot_allowed and not enemy_spotted_last_long and (action_taken or want_to_take_cover or not in_cover) then
		my_data.peek_to_shoot_allowed = true
	end

	if my_data.stay_out_time and (enemy_spotted_last_short or not my_data.at_cover_shoot_pos or action_taken or want_to_take_cover) then
		my_data.stay_out_time = nil
	elseif my_data.attitude == "engage" and not my_data.stay_out_time and my_data.at_cover_shoot_pos and not enemy_spotted_last_short and not action_taken and not want_to_take_cover then
		my_data.stay_out_time = t + 6
	end

	if not action_taken then
		if want_to_take_cover then
			move_to_cover = true
		elseif not enemy_spotted_last_short then
			if data.tactics and data.tactics.charge and data.objective and data.objective.grp_objective and data.objective.grp_objective.charge and (not my_data.charge_path_failed_t or data.t - my_data.charge_path_failed_t > 6) then
				if my_data.charge_path then
					local path = my_data.charge_path

					my_data.charge_path = nil
					action_taken = CopLogicAttack._request_action_walk_to_cover_shoot_pos(data, my_data, path)
				elseif not my_data.charge_path_search_id and focus_enemy.nav_tracker then
					my_data.charge_pos = CopLogicTravel._get_pos_on_wall(focus_enemy.nav_tracker:field_position(), my_data.weapon_range.optimal, 45, nil)

					if my_data.charge_pos then
						my_data.charge_path_search_id = "charge" .. tostring(data.key)

						unit:brain():search_for_path(my_data.charge_path_search_id, my_data.charge_pos, nil, nil, nil)
					else
						debug_pause_unit(data.unit, "failed to find charge_pos", data.unit)

						my_data.charge_path_failed_t = TimerManager:game():time()
					end
				end
			elseif in_cover then
				if my_data.peek_to_shoot_allowed then
					local height

					height = in_cover[NavigationManager.COVER_RESERVED] and 150 or 80

					local my_tracker = data.unit:movement():nav_tracker()
					local shoot_from_pos = CopLogicAttack._peek_for_pos_sideways(data, my_data, my_tracker, focus_enemy.m_head_pos, height)

					if shoot_from_pos then
						local path = {
							my_tracker:position(),
							shoot_from_pos,
						}

						action_taken = CopLogicAttack._request_action_walk_to_cover_shoot_pos(data, my_data, path, math.rand_bool() and "run" or "walk")
					else
						my_data.peek_to_shoot_allowed = false
						move_to_cover = true
						use_flank_cover = true
					end
				elseif not enemy_spotted_last_long then
					move_to_cover = true
					use_flank_cover = true
				end
			elseif my_data.walking_to_cover_shoot_pos then
				-- block empty
			else
				move_to_cover = my_data.at_cover_shoot_pos and t > my_data.stay_out_time and true or true
			end
		end
	end

	local best_cover = my_data.best_cover

	if not action_taken and not my_data.processing_cover_path and not my_data.cover_path and not my_data.charge_path_search_id and best_cover and (not in_cover or best_cover[1] ~= in_cover[1]) and (not my_data.cover_path_failed_t or data.t - my_data.cover_path_failed_t > 5) then
		CopLogicAttack._cancel_cover_pathing(data, my_data)

		local search_id = tostring(data.unit:key()) .. "cover"

		if data.unit:brain():search_for_path_to_cover(search_id, best_cover[1], best_cover[NavigationManager.COVER_RESERVATION]) then
			my_data.cover_path_search_id = search_id
			my_data.processing_cover_path = best_cover
		end
	end

	if not action_taken and move_to_cover and my_data.cover_path then
		action_taken = CopLogicAttack._request_action_walk_to_cover(data, my_data)
	end

	if use_flank_cover then
		if not my_data.flank_cover then
			my_data.flank_cover = CopLogicAttack._flank_cover_params()
		end
	else
		my_data.flank_cover = nil
	end

	if data.important and not my_data.turning and not data.unit:movement():chk_action_forbidden("walk") and CopLogicAttack._can_move(data) and enemy_visible and (not in_cover or not in_cover[NavigationManager.COVER_RESERVED]) then
		if data.is_suppressed and data.t - data.unit:character_damage():last_suppression_t() < 0.7 then
			action_taken = CopLogicBase.chk_start_action_dodge(data, "scared")
		end

		local focus_enemy_dis_near = 2000

		if not action_taken and focus_enemy.is_person and focus_enemy_dis_near > focus_enemy.dis and (math.rand_bool() or data.group and data.group.size > 1) then
			local try_dodge = false

			if focus_enemy.is_local_player then
				local e_movement_state = focus_enemy.unit:movement():current_state()

				if not e_movement_state:_is_reloading() and not e_movement_state:_interacting() and not e_movement_state:is_equipping() then
					try_dodge = true
				end
			else
				local e_anim_data = focus_enemy.unit:anim_data()

				if (e_anim_data.move or e_anim_data.idle) and not e_anim_data.reload then
					try_dodge = true
				end
			end

			if try_dodge and focus_enemy.aimed_at then
				action_taken = CopLogicBase.chk_start_action_dodge(data, "preemptive")
			end
		end
	end

	if not action_taken and want_to_take_cover and not best_cover and CopLogicAttack._should_retreat(data, focus_enemy) then
		action_taken = CopLogicAttack._start_action_move_back(data, my_data, focus_enemy, false)
	end

	action_taken = action_taken or CopLogicAttack._start_action_move_out_of_the_way(data, my_data)
end

function CopLogicAttack._flank_cover_params()
	local turn_direction = math.rand_bool() and -1 or 1
	local step_angle = 30

	return {
		angle = step_angle * turn_direction,
		sign = turn_direction,
		step = step_angle,
	}
end

function CopLogicAttack._should_retreat(data, focus_enemy)
	if focus_enemy and focus_enemy.nav_tracker and focus_enemy.verified and focus_enemy.dis < 250 and CopLogicAttack._can_move(data) then
		return true
	end

	return false
end

function CopLogicAttack._start_action_move_back(data, my_data, focus_enemy, engage)
	local from_pos = mvector3.copy(data.m_pos)
	local threat_tracker = focus_enemy.nav_tracker
	local threat_head_pos = focus_enemy.m_head_pos
	local max_walk_dis = 400
	local vis_required = engage
	local retreat_to = CopLogicAttack._find_retreat_position(from_pos, focus_enemy.m_pos, threat_head_pos, threat_tracker, max_walk_dis, vis_required)

	if not retreat_to then
		return
	end

	CopLogicAttack._cancel_cover_pathing(data, my_data)

	local new_action_data = {
		body_part = 2,
		nav_path = {
			from_pos,
			retreat_to,
		},
		type = "walk",
		variant = "walk",
	}

	my_data.advancing = data.unit:brain():action_request(new_action_data)

	if my_data.advancing then
		my_data.retreating = true

		return true
	end

	return false
end

function CopLogicAttack._start_action_move_out_of_the_way(data, my_data)
	local my_tracker = data.unit:movement():nav_tracker()
	local reservation = {
		filter = data.pos_rsrv_id,
		position = data.m_pos,
		radius = 30,
	}

	if not managers.navigation:is_pos_free(reservation) then
		local to_pos = CopLogicTravel._get_pos_on_wall(data.m_pos, 500)

		if to_pos then
			local path = {
				my_tracker:position(),
				to_pos,
			}

			CopLogicAttack._request_action_walk_to_cover_shoot_pos(data, my_data, path, "run")
		end
	end
end

function CopLogicAttack._peek_for_pos_sideways(data, my_data, from_racker, peek_to_pos, height)
	local unit = data.unit
	local my_tracker = from_racker
	local enemy_pos = peek_to_pos
	local my_pos = unit:movement():m_pos()
	local back_vec = my_pos - enemy_pos

	mvector3.set_z(back_vec, 0)
	mvector3.set_length(back_vec, 75)

	local back_pos = my_pos + back_vec
	local ray_params = {
		allow_entry = true,
		pos_to = back_pos,
		trace = true,
		tracker_from = my_tracker,
	}
	local ray_res = managers.navigation:raycast(ray_params)

	back_pos = ray_params.trace[1]

	local back_polar = (back_pos - my_pos):to_polar()
	local right_polar = back_polar:with_spin(back_polar.spin + 90):with_r(180)
	local right_vec = right_polar:to_vector()
	local right_pos = back_pos + right_vec

	ray_params.pos_to = right_pos

	local ray_res = managers.navigation:raycast(ray_params)
	local stand_ray = World:raycast("ray", ray_params.trace[1] + math.UP * height, enemy_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision")
	local min_visiblity_range = 150

	if not stand_ray or min_visiblity_range > mvector3.distance(stand_ray.position, enemy_pos) then
		return ray_params.trace[1]
	end

	local left_pos = back_pos - right_vec

	ray_params.pos_to = left_pos

	local ray_res = managers.navigation:raycast(ray_params)
	local stand_ray = World:raycast("ray", ray_params.trace[1] + math.UP * height, enemy_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision")

	if not stand_ray or min_visiblity_range > mvector3.distance(stand_ray.position, enemy_pos) then
		return ray_params.trace[1]
	end

	return nil
end

function CopLogicAttack._cancel_pathing(data, my_data, path_search_id)
	if data.active_searches[path_search_id] then
		managers.navigation:cancel_pathing_search(path_search_id)

		data.active_searches[path_search_id] = nil
	elseif data.pathing_results then
		data.pathing_results[path_search_id] = nil
	end
end

function CopLogicAttack._cancel_cover_pathing(data, my_data)
	my_data.cover_path = nil

	if not my_data.processing_cover_path then
		return
	end

	CopLogicAttack._cancel_pathing(data, my_data, my_data.cover_path_search_id)

	my_data.processing_cover_path = nil
	my_data.cover_path_search_id = nil
end

function CopLogicAttack._cancel_charge(data, my_data)
	my_data.charge_pos = nil
	my_data.charge_path = nil

	if not my_data.charge_path_search_id then
		return
	end

	CopLogicAttack._cancel_pathing(data, my_data, my_data.charge_path_search_id)

	my_data.charge_path_search_id = nil
end

function CopLogicAttack._cancel_expected_pos_path(data, my_data)
	my_data.expected_pos_path = nil

	if not my_data.expected_pos_path_search_id then
		return
	end

	CopLogicAttack._cancel_pathing(data, my_data, my_data.expected_pos_path_search_id)

	my_data.expected_pos_path_search_id = nil
end

function CopLogicAttack._request_action_turn_to_enemy(data, my_data, my_pos, enemy_pos)
	local fwd = data.unit:movement():m_rot():y()
	local target_vec = enemy_pos - my_pos
	local error_spin = target_vec:to_polar_with_reference(fwd, math.UP).spin

	if math.abs(error_spin) > 27 then
		local new_action_data = {}

		new_action_data.type = "turn"
		new_action_data.body_part = 2
		new_action_data.angle = error_spin

		if data.unit:brain():action_request(new_action_data) then
			my_data.turning = new_action_data.angle

			return true
		end
	end
end

function CopLogicAttack._cancel_walking_to_cover(data, my_data, skip_action)
	my_data.cover_path = nil

	if my_data.moving_to_cover then
		if not skip_action then
			local new_action = {
				body_part = 2,
				type = "idle",
			}

			data.unit:brain():action_request(new_action)
		end
	elseif my_data.processing_cover_path then
		data.unit:brain():cancel_all_pathing_searches()

		my_data.cover_path_search_id = nil
		my_data.processing_cover_path = nil
	end
end

function CopLogicAttack._request_action_walk_to_cover(data, my_data)
	CopLogicAttack._adjust_path_start_pos(data, my_data.cover_path)

	local movement_mode = "walk"

	if (not data.attention_obj or data.attention_obj.reaction < AIAttentionObject.REACT_COMBAT or data.attention_obj.dis > 500) and mvector3.distance_sq(my_data.cover_path[#my_data.cover_path], data.m_pos) < 90000 then
		movement_mode = "run"
	elseif data.attention_obj and data.attention_obj.reaction >= AIAttentionObject.REACT_COMBAT and data.attention_obj.dis > math.lerp(my_data.weapon_range.optimal, my_data.weapon_range.far, 0.75) then
		movement_mode = "run"
	end

	local end_pose

	if my_data.moving_to_cover and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch) then
		end_pose = "crouch"
	end

	local new_action_data = {
		body_part = 2,
		end_pose = end_pose,
		nav_path = my_data.cover_path,
		type = "walk",
		variant = movement_mode,
	}

	my_data.cover_path = nil
	my_data.advancing = data.unit:brain():action_request(new_action_data)

	if my_data.advancing then
		my_data.moving_to_cover = my_data.best_cover
		my_data.at_cover_shoot_pos = nil
		my_data.in_cover = nil

		data.brain:rem_pos_rsrv("path")
	end
end

function CopLogicAttack._adjust_path_start_pos(data, path)
	local first_nav_point = path[1]
	local my_pos = data.m_pos

	if first_nav_point.x ~= my_pos.x or first_nav_point.y ~= my_pos.y then
		table.insert(path, 1, mvector3.copy(my_pos))
	end
end

function CopLogicAttack._request_action_walk_to_cover_shoot_pos(data, my_data, path, speed)
	CopLogicAttack._cancel_cover_pathing(data, my_data)
	CopLogicAttack._cancel_charge(data, my_data)
	CopLogicAttack._adjust_path_start_pos(data, path)

	local new_action_data = {
		body_part = 2,
		nav_path = path,
		type = "walk",
		variant = speed or "walk",
	}

	my_data.cover_path = nil
	my_data.advancing = data.unit:brain():action_request(new_action_data)

	if my_data.advancing then
		my_data.walking_to_cover_shoot_pos = my_data.advancing
		my_data.at_cover_shoot_pos = nil
		my_data.in_cover = nil

		data.brain:rem_pos_rsrv("path")
	end
end

function CopLogicAttack._request_action_crouch(data)
	if data.unit:anim_data().crouch or data.unit:movement():chk_action_forbidden("crouch") then
		return
	end

	local new_action_data = {
		body_part = 4,
		type = "crouch",
	}
	local res = data.unit:brain():action_request(new_action_data)

	return res
end

function CopLogicAttack._request_action_stand(data)
	if data.unit:anim_data().stand or data.unit:movement():chk_action_forbidden("stand") then
		return
	end

	local new_action_data = {
		body_part = 4,
		type = "stand",
	}
	local res = data.unit:brain():action_request(new_action_data)

	return res
end

function CopLogicAttack._update_cover(data)
	local my_data = data.internal_data
	local cover_release_dis_sq = 10000
	local best_cover = my_data.best_cover

	if not data.attention_obj or not data.attention_obj.nav_tracker or not (data.attention_obj.reaction >= AIAttentionObject.REACT_COMBAT) then
		if best_cover and cover_release_dis_sq < mvector3.distance_sq(best_cover[1][NavigationManager.COVER_POSITION], data.m_pos) then
			CopLogicAttack._set_best_cover(data, my_data, nil)
		end

		return
	end

	local in_cover = my_data.in_cover
	local find_new = not my_data.moving_to_cover and not my_data.walking_to_cover_shoot_pos and not my_data.retreating

	if not find_new then
		if in_cover then
			local threat_pos = data.attention_obj.verified_pos

			in_cover[NavigationManager.COVER_TRACKER], in_cover[NavigationManager.COVER_RESERVED] = CopLogicAttack._chk_covered(data, data.m_pos, threat_pos, data.visibility_slotmask)
		end

		return
	end

	local enemy_tracker = data.attention_obj.nav_tracker
	local threat_pos = enemy_tracker:field_position()

	if data.objective and data.objective.type == "follow" then
		CopLogicAttack._find_cover_for_follow(data, my_data, threat_pos)
	else
		CopLogicAttack._find_cover(data, my_data, threat_pos)
	end

	if in_cover then
		local threat_pos = data.attention_obj.verified_pos

		in_cover[NavigationManager.COVER_TRACKER], in_cover[NavigationManager.COVER_RESERVED] = CopLogicAttack._chk_covered(data, data.m_pos, threat_pos, data.visibility_slotmask)
	end
end

function CopLogicAttack._find_cover_for_follow(data, my_data, threat_pos)
	local near_pos = data.objective.follow_unit:movement():m_pos()

	if my_data.best_cover and CopLogicAttack._verify_follow_cover(my_data.best_cover[1], near_pos, threat_pos, 200, 1000) or my_data.processing_cover_path or my_data.charge_path_search_id then
		return
	end

	local follow_unit_area = managers.groupai:state():get_area_from_nav_seg_id(data.objective.follow_unit:movement():nav_tracker():nav_segment())
	local found_cover = managers.navigation:find_cover_in_nav_seg_3(follow_unit_area.nav_segs, data.objective.distance and data.objective.distance * 0.9 or nil, near_pos, threat_pos)

	if not found_cover then
		return
	end

	if not follow_unit_area.nav_segs[found_cover[NavigationManager.COVER_TRACKER]:nav_segment()] then
		debug_pause_unit(data.unit, "cover in wrong area")
	end

	local better_cover = {
		found_cover,
	}

	CopLogicAttack._set_best_cover(data, my_data, better_cover)

	local offset_pos = CopLogicAttack._get_cover_offset_pos(data, better_cover, threat_pos)

	if offset_pos then
		better_cover[NavigationManager.COVER_RESERVATION] = offset_pos
	end
end

function CopLogicAttack._find_cover(data, my_data, threat_pos)
	local min_dis, max_dis
	local want_to_take_cover = my_data.want_to_take_cover
	local flank_cover = my_data.flank_cover
	local best_cover = my_data.best_cover
	local group_ai_twk = tweak_data.group_ai

	if want_to_take_cover then
		min_dis = math.max(data.attention_obj.dis * 0.9, data.attention_obj.dis - 200)
	end

	if my_data.processing_cover_path or my_data.charge_path_search_id or not flank_cover and best_cover and CopLogicAttack._verify_cover(best_cover[1], threat_pos, min_dis, max_dis) then
		return
	end

	local target_to_unit_vec = data.m_pos - threat_pos

	if flank_cover then
		local angle = flank_cover.angle
		local sign = flank_cover.sign

		if math.sign(angle) ~= sign then
			angle = -angle + flank_cover.step * sign

			if math.abs(angle) > 90 then
				flank_cover.failed = true
			else
				flank_cover.angle = angle
			end
		else
			flank_cover.angle = -angle
		end

		if not flank_cover.failed then
			mvector3.rotate_with(target_to_unit_vec, Rotation(flank_cover.angle))
		end
	end

	local optimal_distance = target_to_unit_vec:length()
	local max_dis

	if want_to_take_cover then
		if optimal_distance < my_data.weapon_range.far then
			optimal_distance = optimal_distance + group_ai_twk.cover_optimal_add_retreat

			mvector3.set_length(target_to_unit_vec, optimal_distance)
		end

		max_dis = math.max(optimal_distance + 800, my_data.weapon_range.far)
	elseif optimal_distance > my_data.weapon_range.optimal * 1.2 then
		optimal_distance = my_data.weapon_range.optimal

		mvector3.set_length(target_to_unit_vec, optimal_distance)

		max_dis = my_data.weapon_range.far
	end

	local optimal_position = threat_pos + target_to_unit_vec

	mvector3.set_length(target_to_unit_vec, max_dis)

	local furthest_position = threat_pos + target_to_unit_vec
	local cone_angle

	if flank_cover and not flank_cover.failed then
		cone_angle = flank_cover.step
	else
		cone_angle = math.lerp(group_ai_twk.cover_cone_angle[1], group_ai_twk.cover_cone_angle[2], math.min(1, optimal_distance / 3000))
	end

	local search_nav_seg

	if data.objective and data.objective.type == "defend_area" then
		search_nav_seg = data.objective.area and data.objective.area.nav_segs or data.objective.nav_seg
	end

	local found_cover = managers.navigation:find_cover_in_cone_from_threat_pos(threat_pos, furthest_position, optimal_position, cone_angle, search_nav_seg, data.pos_rsrv_id)

	if found_cover and (not best_cover or best_cover[1] ~= found_cover) then
		local better_cover = {
			found_cover,
		}

		CopLogicAttack._set_best_cover(data, my_data, better_cover)

		local offset_pos = CopLogicAttack._get_cover_offset_pos(data, better_cover, threat_pos)

		if offset_pos then
			better_cover[NavigationManager.COVER_RESERVATION] = offset_pos
		end
	end
end

function CopLogicAttack._verify_cover(cover, threat_pos, min_dis, max_dis)
	local threat_dis = mvector3.direction(temp_vec1, cover[1], threat_pos)

	if min_dis and threat_dis < min_dis or max_dis and max_dis < threat_dis then
		return false
	end

	local cover_dot = mvector3.dot(temp_vec1, cover[NavigationManager.COVER_FORWARD])

	if cover_dot < 0.67 then
		return false
	end

	return true
end

function CopLogicAttack._verify_follow_cover(cover, near_pos, threat_pos, min_dis, max_dis)
	if CopLogicAttack._verify_cover(cover, threat_pos, min_dis, max_dis) and mvector3.distance(near_pos, cover[1]) < 600 then
		return true
	end
end

function CopLogicAttack._chk_covered(data, cover_pos, threat_pos, slotmask)
	local ray_from = temp_vec1

	mvec3_set(ray_from, math.UP)
	mvector3.multiply(ray_from, 80)
	mvector3.add(ray_from, cover_pos)

	local ray_to_pos = temp_vec2

	mvector3.step(ray_to_pos, ray_from, threat_pos, 300)

	local low_ray = World:raycast("ray", ray_from, ray_to_pos, "slot_mask", slotmask)
	local high_ray

	if low_ray then
		mvector3.set_z(ray_from, ray_from.z + 60)
		mvector3.step(ray_to_pos, ray_from, threat_pos, 300)

		high_ray = World:raycast("ray", ray_from, ray_to_pos, "slot_mask", slotmask)
	end

	return low_ray, high_ray
end

function CopLogicAttack._process_pathing_results(data, my_data)
	if not data.pathing_results then
		return
	end

	local pathing_results = data.pathing_results
	local path = pathing_results[my_data.cover_path_search_id]

	if path then
		if path ~= "failed" then
			my_data.cover_path = path
		else
			CopLogicAttack._set_best_cover(data, my_data, nil)

			my_data.cover_path_failed_t = TimerManager:game():time()
		end

		my_data.processing_cover_path = nil
		my_data.cover_path_search_id = nil
	end

	path = pathing_results[my_data.charge_path_search_id]

	if path then
		if path ~= "failed" then
			my_data.charge_path = path
		end

		my_data.charge_path_search_id = nil
		my_data.charge_path_failed_t = TimerManager:game():time()
	end

	path = pathing_results[my_data.expected_pos_path_search_id]

	if path then
		if path ~= "failed" then
			my_data.expected_pos_path = path
		end

		my_data.expected_pos_path_search_id = nil
	end

	data.pathing_results = nil
end

function CopLogicAttack._upd_enemy_detection(data, is_synchronous)
	managers.groupai:state():on_unit_detection_updated(data.unit)

	data.t = TimerManager:game():time()

	local my_data = data.internal_data
	local delay = CopLogicBase._upd_attention_obj_detection(data, nil, nil)
	local desired_attention, new_prio_slot, new_reaction = CopLogicBase._get_priority_attention(data, data.detected_attention_objects, nil)

	CopLogicBase._set_attention_obj(data, desired_attention, new_reaction)
	CopLogicAttack._chk_exit_attack_logic(data, new_reaction)

	if my_data ~= data.internal_data then
		return
	end

	local old_att_obj = data.attention_obj

	if desired_attention then
		if old_att_obj and old_att_obj.u_key ~= desired_attention.u_key then
			CopLogicAttack._cancel_charge(data, my_data)

			my_data.flank_cover = nil

			if not data.unit:movement():chk_action_forbidden("walk") then
				CopLogicAttack._cancel_walking_to_cover(data, my_data)
			end

			CopLogicAttack._set_best_cover(data, my_data, nil)
		end
	elseif old_att_obj then
		CopLogicAttack._cancel_charge(data, my_data)

		my_data.flank_cover = nil
	end

	CopLogicBase._chk_call_the_police(data)

	if my_data ~= data.internal_data then
		return
	end

	data.logic._upd_aim(data, my_data)

	if not is_synchronous then
		CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicAttack._upd_enemy_detection, data, delay and data.t + delay, data.important and true)
	end

	CopLogicBase._report_detections(data.detected_attention_objects)
end

function CopLogicAttack._find_retreat_position(from_pos, threat_pos, threat_head_pos, threat_tracker, max_dist, vis_required)
	local nav_manager = managers.navigation
	local ct_rays = 5
	local step = 180 / ct_rays
	local step_rot = Rotation(step)
	local offset = math.random(step)
	local offset_rot = Rotation(offset)
	local dir = math.random() < 0.5 and -1 or 1

	step = step * dir

	local ray_dis = max_dist or 1000
	local offset_vec = mvector3.copy(threat_pos)

	mvector3.subtract(offset_vec, from_pos)
	mvector3.normalize(offset_vec)
	mvector3.multiply(offset_vec, ray_dis)
	mvector3.rotate_with(offset_vec, Rotation((90 + offset) * dir))

	local from_tracker = nav_manager:create_nav_tracker(from_pos)
	local ray_params = {
		trace = true,
		tracker_from = from_tracker,
	}
	local rsrv_desc = {
		radius = 60,
	}
	local fail_position

	for i_ray = 1, ct_rays do
		local to_pos = mvector3.copy(from_pos)

		mvector3.add(to_pos, offset_vec)

		ray_params.pos_to = to_pos

		local ray_res = nav_manager:raycast(ray_params)

		if ray_res then
			rsrv_desc.position = ray_params.trace[1]

			local is_free = nav_manager:is_pos_free(rsrv_desc)

			if is_free and (not vis_required or CopLogicAttack._is_threat_visible(ray_params.trace[1], threat_pos, threat_head_pos, threat_tracker)) then
				managers.navigation:destroy_nav_tracker(from_tracker)

				return ray_params.trace[1]
			end
		elseif not fail_position then
			rsrv_desc.position = ray_params.trace[1]

			local is_free = nav_manager:is_pos_free(rsrv_desc)

			if is_free then
				fail_position = ray_params.trace[1]
			end
		end

		mvector3.rotate_with(offset_vec, step_rot)
	end

	managers.navigation:destroy_nav_tracker(from_tracker)

	if fail_position then
		return fail_position
	end

	return nil
end

function CopLogicAttack._is_threat_visible(retreat_pos, threat_pos, threat_head_pos, threat_tracker)
	local ray_params = {
		pos_from = retreat_pos,
		trace = true,
		tracker_to = threat_tracker,
	}
	local walk_ray_res = managers.navigation:raycast(ray_params)

	if not walk_ray_res then
		return ray_params.trace[1]
	end

	local retreat_head_pos = mvector3.copy(retreat_pos)

	mvector3.add(retreat_head_pos, Vector3(0, 0, 150))

	local slotmask = managers.slot:get_mask("AI_visibility")
	local ray_res = World:raycast("ray", retreat_head_pos, threat_head_pos, "slot_mask", slotmask, "ray_type", "ai_vision")

	if not ray_res then
		return walk_ray_res or ray_params.trace[1]
	end

	return false
end

function CopLogicAttack.on_action_completed(data, action)
	local my_data = data.internal_data
	local action_type = action:type()

	if action_type == "walk" then
		my_data.advancing = nil

		CopLogicAttack._cancel_cover_pathing(data, my_data)
		CopLogicAttack._cancel_charge(data, my_data)

		if my_data.retreating then
			my_data.retreating = false
		elseif my_data.moving_to_cover then
			if action:expired() then
				my_data.in_cover = my_data.moving_to_cover
				my_data.cover_enter_t = data.t
			end

			my_data.moving_to_cover = nil
		elseif my_data.walking_to_cover_shoot_pos then
			my_data.walking_to_cover_shoot_pos = nil
			my_data.at_cover_shoot_pos = true
		end
	elseif action_type == "shoot" then
		my_data.shooting = nil
	elseif action_type == "turn" then
		my_data.turning = nil
	elseif action_type == "hurt" then
		CopLogicAttack._cancel_cover_pathing(data, my_data)

		if data.important and action:expired() and not CopLogicBase.chk_start_action_dodge(data, "hit") then
			CopLogicAttack._upd_aim(data, my_data)
		end
	elseif action_type == "dodge" then
		local timeout = action:timeout()

		if timeout then
			data.dodge_timeout_t = TimerManager:game():time() + math.lerp(timeout[1], timeout[2], math.random())
		end

		CopLogicAttack._cancel_cover_pathing(data, my_data)

		if action:expired() then
			CopLogicAttack._upd_aim(data, my_data)
		end
	end
end

function CopLogicAttack._upd_aim(data, my_data)
	local shoot, aim, expected_pos
	local focus_enemy = data.attention_obj

	if not my_data.weapon_range then
		Application:error("[CopLogicAttack._upd_aim()] My data lacked weapon_range!", inspect(my_data))

		my_data.weapon_range = {}
		my_data.weapon_range.close = 10000
		my_data.weapon_range.optimal = 12000
		my_data.weapon_range.far = 20000
	end

	local should_shoot = focus_enemy and focus_enemy.reaction >= AIAttentionObject.REACT_SHOOT
	local should_aim = should_shoot or focus_enemy and focus_enemy.reaction >= AIAttentionObject.REACT_AIM

	if should_aim then
		local last_sup_t = data.unit:character_damage():last_suppression_t()

		if focus_enemy.verified or focus_enemy.nearly_visible then
			if data.unit:anim_data().run and focus_enemy.dis > my_data.weapon_range.close then
				local walk_to_pos = data.unit:movement():get_walk_to_pos()

				if walk_to_pos then
					mvector3.direction(temp_vec1, data.m_pos, walk_to_pos)
					mvector3.direction(temp_vec2, data.m_pos, focus_enemy.m_pos)

					local dot = mvector3.dot(temp_vec1, temp_vec2)

					if dot < 0.6 then
						shoot = false
						aim = false
					end
				end
			end

			if aim == nil and should_aim then
				if should_shoot then
					local running = my_data.advancing and not my_data.advancing:stopping() and my_data.advancing:haste() == "run"

					if not shoot and last_sup_t and data.t - last_sup_t < 7 * (running and 0.3 or 1) * (focus_enemy.verified and 1 or focus_enemy.vis_ray and focus_enemy.vis_ray.distance > 500 and 0.5 or 0.2) then
						shoot = true
					end

					if not shoot and focus_enemy.verified and focus_enemy.verified_dis < data.internal_data.weapon_range.close then
						shoot = true
					end

					if not shoot and focus_enemy.verified and focus_enemy.criminal_record and (not my_data.weapon_range_max or focus_enemy.verified_dis < my_data.weapon_range_max) then
						shoot = true
					end

					if not shoot and focus_enemy.unit:vehicle() then
						shoot = true
					end

					if not shoot and my_data.attitude == "engage" then
						if focus_enemy.verified then
							if focus_enemy.verified_dis < data.internal_data.weapon_range[running and "close" or "far"] or focus_enemy.reaction == AIAttentionObject.REACT_SHOOT then
								shoot = true
							end
						else
							local time_since_verification = focus_enemy.verified_t and data.t - focus_enemy.verified_t or 500

							if my_data.firing and not my_data.detection.avoid_suppressive_firing and time_since_verification < 3.5 then
								shoot = true
							else
								data.brain:search_for_path_to_unit("hunt" .. tostring(my_data.key), focus_enemy.unit)
							end
						end
					end

					if not shoot and focus_enemy.char_tweak and focus_enemy.char_tweak.is_escort and not focus_enemy.char_tweak.immortal then
						local escort_ext = focus_enemy.unit:escort()

						if escort_ext and not escort_ext:is_safe() then
							shoot = true
						end
					end

					aim = aim or shoot

					if not aim and focus_enemy.verified_dis < (running and data.internal_data.weapon_range.close or data.internal_data.weapon_range.far) then
						aim = true
					end
				else
					aim = true
				end
			end
		elseif should_aim then
			local time_since_verification = focus_enemy.verified_t and data.t - focus_enemy.verified_t
			local running = my_data.advancing and not my_data.advancing:stopping() and my_data.advancing:haste() == "run"
			local same_z = math.abs(focus_enemy.verified_pos.z - data.m_pos.z) < 250

			if running then
				if time_since_verification and time_since_verification < math.lerp(5, 1, math.max(0, focus_enemy.verified_dis - 500) / 600) then
					aim = true
				end
			else
				aim = true
			end

			if aim and my_data.shooting and should_shoot and time_since_verification and time_since_verification < (running and 2 or 3) then
				shoot = true
			end

			if not aim then
				expected_pos = CopLogicAttack._get_expected_attention_position(data, my_data)

				if expected_pos then
					if not running then
						aim = true
					else
						local watch_dir = temp_vec1

						mvec3_set(watch_dir, expected_pos)
						mvec3_sub(watch_dir, data.m_pos)
						mvec3_set_z(watch_dir, 0)

						local watch_pos_dis = mvec3_norm(watch_dir)
						local walk_to_pos = data.unit:movement():get_walk_to_pos()
						local walk_vec = temp_vec2

						mvec3_set(walk_vec, walk_to_pos)
						mvec3_sub(walk_vec, data.m_pos)
						mvec3_set_z(walk_vec, 0)
						mvec3_norm(walk_vec)

						local watch_walk_dot = mvec3_dot(watch_dir, walk_vec)

						if watch_pos_dis < 500 or watch_pos_dis < 1000 and watch_walk_dot > 0.85 then
							aim = true
						end
					end
				end
			end
		else
			expected_pos = CopLogicAttack._get_expected_attention_position(data, my_data)

			if expected_pos then
				aim = true
			end
		end
	end

	local weapon_cooldown = false

	if shoot and my_data.additional_weapon_stats and my_data.additional_weapon_stats.shooting_duration then
		my_data.additional_weapon_stats.shooting_t = my_data.additional_weapon_stats.shooting_t or data.t + my_data.additional_weapon_stats.shooting_duration

		if my_data.additional_weapon_stats.shooting_t < data.t then
			local rand_shoot = my_data.additional_weapon_stats.shooting_duration + math.random(0, 100) / 150
			local rand_cooldown = my_data.additional_weapon_stats.cooldown_duration + math.random(0, 100) / 400

			my_data.additional_weapon_stats.shooting_t = data.t + rand_shoot + rand_shoot + rand_cooldown
			my_data.additional_weapon_stats.cooldown_t = data.t + rand_cooldown
		elseif my_data.additional_weapon_stats.cooldown_t and my_data.additional_weapon_stats.cooldown_t > data.t then
			weapon_cooldown = true
		end
	end

	if shoot and weapon_cooldown then
		shoot = false
		aim = true
	end

	if not aim and data.char_tweak.always_face_enemy and focus_enemy and focus_enemy.reaction >= AIAttentionObject.REACT_COMBAT then
		aim = true
	end

	if data.logic.chk_should_turn(data, my_data) and (focus_enemy or expected_pos) then
		local enemy_pos = expected_pos or (focus_enemy.verified or focus_enemy.nearly_visible) and focus_enemy.m_pos or focus_enemy.verified_pos

		CopLogicAttack._request_action_turn_to_enemy(data, my_data, data.m_pos, enemy_pos)
	end

	if aim or shoot then
		if expected_pos then
			if my_data.attention_unit ~= expected_pos then
				CopLogicBase._set_attention_on_pos(data, mvector3.copy(expected_pos))

				my_data.attention_unit = mvector3.copy(expected_pos)
			end
		elseif focus_enemy.verified or focus_enemy.nearly_visible then
			if my_data.attention_unit ~= focus_enemy.u_key then
				CopLogicBase._set_attention(data, focus_enemy)

				my_data.attention_unit = focus_enemy.u_key
			end
		else
			local look_pos = focus_enemy.last_verified_pos or focus_enemy.verified_pos

			if my_data.attention_unit ~= look_pos then
				CopLogicBase._set_attention_on_pos(data, mvector3.copy(look_pos))

				my_data.attention_unit = mvector3.copy(look_pos)
			end
		end

		if not my_data.shooting and not data.unit:anim_data().reload and not data.unit:movement():chk_action_forbidden("action") then
			local shoot_action = {
				body_part = 3,
				type = "shoot",
			}

			if data.unit:brain():action_request(shoot_action) then
				my_data.shooting = true
			end
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

	CopLogicAttack.aim_allow_fire(shoot, aim, data, my_data)
end

function CopLogicAttack.aim_allow_fire(shoot, aim, data, my_data)
	if shoot then
		if not my_data.firing then
			data.unit:movement():set_allow_fire(true)

			my_data.firing = true

			if not data.unit:in_slot(16) and data.char_tweak.chatter.aggressive then
				managers.groupai:state():chk_say_enemy_chatter(data.unit, data.m_pos, "aggressive")
			end
		end
	elseif my_data.firing then
		data.unit:movement():set_allow_fire(false)

		my_data.firing = nil
	end
end

function CopLogicAttack.chk_should_turn(data, my_data)
	return not my_data.turning and not my_data.has_old_action and not data.unit:movement():chk_action_forbidden("walk") and not my_data.moving_to_cover and not my_data.walking_to_cover_shoot_pos and not my_data.retreating
end

function CopLogicAttack._get_cover_offset_pos(data, cover_data, threat_pos)
	local threat_vec = threat_pos - cover_data[1][1]

	mvector3.set_z(threat_vec, 0)

	local threat_polar = threat_vec:to_polar_with_reference(cover_data[1][2], math.UP)
	local threat_spin = threat_polar.spin
	local rot

	if threat_spin < -20 then
		rot = Rotation(90)
	elseif threat_spin > 20 then
		rot = Rotation(-90)
	else
		rot = Rotation(180)
	end

	local offset_pos = mvector3.copy(cover_data[1][2])

	mvector3.rotate_with(offset_pos, rot)
	mvector3.set_length(offset_pos, 25)
	mvector3.add(offset_pos, cover_data[1][1])

	local ray_params = {
		pos_to = offset_pos,
		trace = true,
		tracker_from = cover_data[1][3],
	}

	managers.navigation:raycast(ray_params)

	return ray_params.trace[1]
end

function CopLogicAttack._find_flank_pos(data, my_data, flank_tracker, max_dist)
	local pos = flank_tracker:position()
	local vec_to_pos = pos - data.m_pos

	mvector3.set_z(vec_to_pos, 0)

	local max_dis = max_dist or 1500

	mvector3.set_length(vec_to_pos, max_dis)

	local accross_positions = managers.navigation:find_walls_accross_tracker(flank_tracker, vec_to_pos, 160, 5)

	if accross_positions then
		local optimal_dis = max_dis
		local best_error_dis, best_pos, best_is_hit, best_is_miss, best_has_too_much_error

		for _, accross_pos in ipairs(accross_positions) do
			local error_dis = math.abs(mvector3.distance(accross_pos[1], pos) - optimal_dis)
			local too_much_error = error_dis / optimal_dis > 0.2
			local is_hit = accross_pos[2]

			if best_is_hit then
				if is_hit then
					if error_dis < best_error_dis then
						local reservation = {
							filter = data.pos_rsrv_id,
							position = accross_pos[1],
							radius = 30,
						}

						if managers.navigation:is_pos_free(reservation) then
							best_pos = accross_pos[1]
							best_error_dis = error_dis
							best_has_too_much_error = too_much_error
						end
					end
				elseif best_has_too_much_error then
					local reservation = {
						filter = data.pos_rsrv_id,
						position = accross_pos[1],
						radius = 30,
					}

					if managers.navigation:is_pos_free(reservation) then
						best_pos = accross_pos[1]
						best_error_dis = error_dis
						best_is_miss = true
						best_is_hit = nil
					end
				end
			elseif best_is_miss then
				if not too_much_error then
					local reservation = {
						filter = data.pos_rsrv_id,
						position = accross_pos[1],
						radius = 30,
					}

					if managers.navigation:is_pos_free(reservation) then
						best_pos = accross_pos[1]
						best_error_dis = error_dis
						best_has_too_much_error = nil
						best_is_miss = nil
						best_is_hit = true
					end
				end
			else
				local reservation = {
					filter = data.pos_rsrv_id,
					position = accross_pos[1],
					radius = 30,
				}

				if managers.navigation:is_pos_free(reservation) then
					best_pos = accross_pos[1]
					best_is_hit = is_hit
					best_is_miss = not is_hit
					best_has_too_much_error = too_much_error
					best_error_dis = error_dis
				end
			end
		end

		return best_pos
	end
end

function CopLogicAttack.damage_clbk(data, damage_info)
	CopLogicBase.damage_clbk(data, damage_info)
end

function CopLogicAttack.is_available_for_assignment(data, new_objective)
	local my_data = data.internal_data

	if my_data.exiting then
		return
	end

	if new_objective and new_objective.forced then
		return true
	end

	if data.unit:movement():chk_action_forbidden("walk") then
		return
	end

	if data.path_fail_t and data.t < data.path_fail_t + 6 then
		return
	end

	if data.is_suppressed then
		return
	end

	local att_obj = data.attention_obj

	if not att_obj or att_obj.reaction < AIAttentionObject.REACT_AIM then
		return true
	end

	if not new_objective or new_objective.type == "free" then
		return true
	end

	if new_objective then
		local allow_trans, obj_fail = CopLogicBase.is_obstructed(data, new_objective, 0.2)

		if obj_fail then
			return
		end
	end

	return true
end

function CopLogicAttack._chk_wants_to_take_cover(data, my_data)
	if not data.attention_obj or data.attention_obj.reaction < AIAttentionObject.REACT_COMBAT then
		return false
	end

	if my_data.moving_to_cover or my_data.attitude ~= "engage" or data.is_suppressed or data.unit:anim_data().reload or not data.unit:inventory():equipped_selection() then
		return true
	end

	local ammo_max, ammo = data.unit:inventory():equipped_unit():base():ammo_info()

	if ammo_max > 4 and ammo / ammo_max < 0.25 then
		return true
	end

	return false
end

function CopLogicAttack._set_best_cover(data, my_data, cover_data)
	local best_cover = my_data.best_cover

	if best_cover then
		managers.navigation:release_cover(best_cover[1])
		CopLogicAttack._cancel_cover_pathing(data, my_data)
	end

	if cover_data then
		managers.navigation:reserve_cover(cover_data[1], data.pos_rsrv_id)

		my_data.best_cover = cover_data

		if not my_data.in_cover and not my_data.walking_to_cover_shoot_pos and not my_data.moving_to_cover and mvec3_dis_sq(cover_data[1][1], data.m_pos) < 100 then
			my_data.in_cover = my_data.best_cover
			my_data.cover_enter_t = data.t
		end
	else
		my_data.best_cover = nil
		my_data.flank_cover = nil
	end
end

function CopLogicAttack._set_nearest_cover(my_data, cover_data)
	local nearest_cover = my_data.nearest_cover

	if nearest_cover then
		managers.navigation:release_cover(nearest_cover[1])
	end

	if cover_data then
		local pos_rsrv_id = my_data.unit:movement():pos_rsrv_id()

		managers.navigation:reserve_cover(cover_data[1], pos_rsrv_id)

		my_data.nearest_cover = cover_data
	else
		my_data.nearest_cover = nil
	end
end

function CopLogicAttack._can_move(data)
	return not data.objective or not data.objective.pos or not data.objective.in_place
end

function CopLogicAttack.queue_update(data, my_data, delay)
	local update_delay = delay

	update_delay = update_delay or data.important and 0.5 or 2

	CopLogicBase.queue_task(my_data, my_data.update_queue_id, data.logic.queued_update, data, data.t + update_delay, true)
end

function CopLogicAttack._get_expected_attention_position(data, my_data)
	local main_enemy = data.attention_obj
	local e_nav_tracker = main_enemy.nav_tracker

	if not e_nav_tracker then
		return
	end

	local my_nav_seg = data.unit:movement():nav_tracker():nav_segment()
	local e_pos = main_enemy.m_pos
	local e_nav_seg = e_nav_tracker:nav_segment()

	if e_nav_seg == my_nav_seg then
		mvec3_set(temp_vec1, e_pos)
		mvec3_set_z(temp_vec1, temp_vec1.z + tweak_data.player.PLAYER_EYE_HEIGHT)

		return temp_vec1
	end

	local expected_path = my_data.expected_pos_path
	local from_nav_seg, to_nav_seg

	if expected_path then
		local i_from_seg

		for i, k in ipairs(expected_path) do
			if k[1] == my_nav_seg then
				i_from_seg = i

				break
			end
		end

		if i_from_seg then
			local function _find_aim_pos(from_nav_seg, to_nav_seg)
				local closest_dis = 1000000000
				local closest_door
				local min_point_dis_sq = 10000
				local found_doors = managers.navigation:find_segment_doors(from_nav_seg, callback(CopLogicAttack, CopLogicAttack, "_chk_is_right_segment", to_nav_seg))

				for _, door in pairs(found_doors) do
					mvec3_set(temp_vec1, door)

					local dis = mvec3_dis_sq(e_pos, temp_vec1)

					if dis < closest_dis then
						closest_dis = dis
						closest_door = door
					end
				end

				if closest_door then
					mvec3_set(temp_vec1, closest_door)
					mvec3_sub(temp_vec1, data.m_pos)
					mvec3_set_z(temp_vec1, 0)

					if min_point_dis_sq < mvector3.length_sq(temp_vec1) then
						mvec3_set(temp_vec1, closest_door)
						mvec3_set_z(temp_vec1, temp_vec1.z + tweak_data.player.PLAYER_EYE_HEIGHT)

						return temp_vec1
					else
						return false, true
					end
				end
			end

			local i = #expected_path

			while i > 0 do
				if expected_path[i][1] == e_nav_seg then
					to_nav_seg = expected_path[math.clamp(i, i_from_seg - 1, i_from_seg + 1)][1]

					local aim_pos, too_close = _find_aim_pos(my_nav_seg, to_nav_seg)

					if aim_pos then
						do return aim_pos end

						break
					end

					if too_close then
						local next_nav_seg = expected_path[math.clamp(i, i_from_seg - 2, i_from_seg + 2)][1]

						if next_nav_seg ~= to_nav_seg then
							local from_nav_seg = to_nav_seg

							to_nav_seg = next_nav_seg
							aim_pos = _find_aim_pos(from_nav_seg, to_nav_seg)
						end

						return aim_pos
					end

					break
				end

				i = i - 1
			end
		end

		if not i_from_seg or not to_nav_seg then
			expected_path = nil
			my_data.expected_pos_path = nil
		end
	end

	if not expected_path and not my_data.expected_pos_path_search_id then
		my_data.expected_pos_path_search_id = "ExpectedPos" .. tostring(data.key)

		data.unit:brain():search_for_coarse_path(my_data.expected_pos_path_search_id, e_nav_seg)
	end
end

function CopLogicAttack._chk_is_right_segment(ignore_this, enemy_nav_seg, test_nav_seg)
	return enemy_nav_seg == test_nav_seg
end

function CopLogicAttack.is_advancing(data)
	if data.internal_data.moving_to_cover then
		return data.internal_data.moving_to_cover[1][NavigationManager.COVER_POSITION]
	end

	if data.internal_data.walking_to_cover_shoot_pos then
		return data.internal_data.walking_to_cover_shoot_pos._last_pos
	end
end

function CopLogicAttack._get_all_paths(data)
	return {
		cover_path = data.internal_data.cover_path,
		flank_path = data.internal_data.flank_path,
	}
end

function CopLogicAttack._set_verified_paths(data, verified_paths)
	data.internal_data.cover_path = verified_paths.cover_path
	data.internal_data.flank_path = verified_paths.flank_path
end

function CopLogicAttack._chk_exit_attack_logic(data, new_reaction)
	if not data.unit:movement():chk_action_forbidden("walk") then
		local wanted_state = CopLogicBase._get_logic_state_from_reaction(data, new_reaction)

		if wanted_state ~= data.name then
			local allow_trans, obj_failed = CopLogicBase.is_obstructed(data, data.objective, nil, nil)

			if allow_trans then
				if obj_failed then
					data.objective_failed_clbk(data.unit, data.objective)
				elseif wanted_state ~= "idle" or not managers.groupai:state():on_cop_jobless(data.unit) then
					CopLogicBase._exit_to_state(data.unit, wanted_state)
				end

				CopLogicBase._report_detections(data.detected_attention_objects)
			end
		end
	end
end

function CopLogicAttack.action_taken(data, my_data)
	return my_data.turning or my_data.moving_to_cover or my_data.walking_to_cover_shoot_pos or my_data.retreating or my_data.has_old_action or data.unit:movement():chk_action_forbidden("walk")
end

function CopLogicAttack._upd_stop_old_action(data, my_data)
	if data.unit:anim_data().to_idle then
		return
	end

	if data.unit:movement():chk_action_forbidden("walk") then
		if not data.unit:movement():chk_action_forbidden("idle") then
			CopLogicBase._start_idle_action_from_act(data)
		end
	elseif data.unit:anim_data().act and data.unit:anim_data().needs_idle then
		CopLogicBase._start_idle_action_from_act(data)
	end

	CopLogicBase._chk_has_old_action(data, my_data)
end

function CopLogicAttack._upd_pose(data, my_data)
	local unit_can_stand = not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.stand
	local unit_can_crouch = not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch
	local stand_objective = data.objective and data.objective.pose == "stand"
	local crouch_objective = data.objective and data.objective.pose == "crouch"
	local need_cover = my_data.want_to_take_cover and (not my_data.in_cover or not my_data.in_cover[NavigationManager.COVER_RESERVED])

	if not unit_can_stand or need_cover and not stand_objective or crouch_objective then
		if not data.unit:anim_data().crouch and unit_can_crouch then
			return CopLogicAttack._request_action_crouch(data)
		end
	elseif (not unit_can_crouch or not my_data.peek_to_shoot_allowed and not crouch_objective or stand_objective) and data.unit:anim_data().crouch and unit_can_stand then
		return CopLogicAttack._request_action_stand(data)
	end
end

function CopLogicAttack._exit_non_walkable_area(data)
	local my_data = data.internal_data

	if my_data.advancing or not CopLogicAttack._can_move(data) or data.unit:movement():chk_action_forbidden("walk") then
		return
	end

	local my_tracker = data.unit:movement():nav_tracker()

	if not my_tracker:obstructed() then
		return
	end

	if data.objective and data.objective.nav_seg then
		local nav_seg_id = my_tracker:nav_segment()

		if not managers.navigation._nav_segments[nav_seg_id].disabled then
			data.objective.in_place = nil

			CopLogicAttack.on_new_objective(data, data.objective)

			return true
		end
	end
end
