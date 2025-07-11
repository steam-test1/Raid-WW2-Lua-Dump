CivilianLogicEscort = class(CivilianLogicBase)
CivilianLogicEscort.AVOIDANCE_PATH_CHECK_DELAY = 0.75
CivilianLogicEscort.AVOIDANCE_PATH_CHECK_DELAY_LONGER = 1.5
CivilianLogicEscort.IDLE_TALK_DELAY = 45

function CivilianLogicEscort.enter(data, new_logic_name, enter_params)
	local my_data = {
		unit = data.unit,
	}

	CopLogicBase.enter(data, new_logic_name, enter_params, my_data)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data

	data.unit:brain():set_update_enabled_state(true)

	if data.char_tweak.escort_idle_talk then
		my_data._say_random_t = Application:time() + CivilianLogicEscort.IDLE_TALK_DELAY
	end

	CivilianLogicEscort._get_objective_path_data(data, my_data)

	data.internal_data = my_data

	if not data.objective.allow_cool then
		data.unit:movement():set_cool(false, "escort")
	end

	data.unit:movement():set_stance("hos")

	my_data.advance_path_search_id = "CivilianLogicEscort_detailed" .. tostring(data.key)
	my_data.coarse_path_search_id = "CivilianLogicEscort_coarse" .. tostring(data.key)
	my_data.vision = data.char_tweak.vision

	if data.char_tweak.outline_on_discover then
		if not data.been_outlined then
			my_data.outline_detection_task_key = "CivilianLogicIdle._upd_outline_detection" .. tostring(data.key)

			CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, data, data.t + 2)
		end
	else
		data.unit:contour():add("highlight_character")
	end

	local attention_settings

	if not data.char_tweak.immortal then
		attention_settings = {
			"custom_escort_cbt",
		}
	else
		attention_settings = {
			"civ_enemy_cbt",
			"civ_civ_cbt",
		}
	end

	data.unit:brain():set_attention_settings(attention_settings)

	my_data.safe_distance_offset = math.rand(100)
end

function CivilianLogicEscort.exit(data, new_logic_name, enter_params)
	CopLogicBase.exit(data, new_logic_name, enter_params)

	local my_data = data.internal_data

	data.unit:brain():cancel_all_pathing_searches()
	CopLogicBase.cancel_queued_tasks(my_data)
	data.unit:contour():remove("highlight")

	if new_logic_name ~= "inactive" then
		data.unit:brain():set_update_enabled_state(true)
	end

	my_data.last_avoidance_t = nil
	my_data.safe_distance_offset = nil
end

function CivilianLogicEscort.update(data)
	local my_data = data.internal_data
	local unit = data.unit
	local objective = data.objective
	local t = data.t

	if my_data._say_random_t and t > my_data._say_random_t then
		data.unit:sound():say("a02x_any", true)

		my_data._say_random_t = t + math.random(30, 60)
	end

	if my_data.has_old_action then
		CivilianLogicTravel._upd_stop_old_action(data, my_data)

		return
	end

	local scared_reason = CivilianLogicEscort.too_scared_to_move(data)

	if scared_reason then
		if scared_reason == "abandoned" and not data.char_tweak.immortal then
			data.unit:brain():set_attention_settings({
				"custom_escort_cbt",
			})
		end

		if scared_reason == "hostiles" then
			-- block empty
		end

		if not data.unit:anim_data().panic then
			my_data.commanded_to_move = nil

			data.unit:movement():action_request({
				body_part = 1,
				clamp_to_graph = true,
				type = "act",
				variant = "panic",
			})
		end
	elseif not data.char_tweak.immortal then
		data.unit:brain():set_attention_settings({
			"civ_enemy_cbt",
			"civ_civ_cbt",
		})

		my_data.commanded_to_move = true
	end

	if my_data.processing_advance_path or my_data.processing_coarse_path then
		CivilianLogicEscort._upd_pathing(data, my_data)
	elseif my_data.advancing or my_data.getting_up then
		-- block empty
	elseif my_data.advance_path and (not my_data.last_avoidance_t or my_data.last_avoidance_t + CivilianLogicEscort.AVOIDANCE_PATH_CHECK_DELAY < data.t) then
		if my_data.commanded_to_move then
			if data.unit:anim_data().standing_hesitant then
				CivilianLogicEscort._begin_advance_action(data, my_data)
			else
				CivilianLogicEscort._begin_stand_hesitant_action(data, my_data)
			end
		end
	elseif objective then
		if my_data.coarse_path then
			local coarse_path = my_data.coarse_path
			local cur_index = my_data.coarse_path_index
			local total_nav_points = #coarse_path

			if total_nav_points <= cur_index then
				objective.in_place = true

				data.objective_complete_clbk(unit, objective)

				return
			else
				local to_pos = coarse_path[cur_index + 1][2]

				my_data.processing_advance_path = true

				unit:brain():search_for_path(my_data.advance_path_search_id, to_pos)
			end
		elseif unit:brain():search_for_coarse_path(my_data.coarse_path_search_id, objective.nav_seg) then
			my_data.processing_coarse_path = true
		end
	else
		CopLogicBase._exit_to_state(data.unit, "idle")
	end

	if data.unit:anim_data().walk and (not my_data.last_avoidance_t or my_data.last_avoidance_t + CivilianLogicEscort.AVOIDANCE_PATH_CHECK_DELAY_LONGER < data.t) then
		local pos = data.unit:position() + Vector3(0, 0, 100)
		local avoidance_ray = data.unit:raycast("ray", pos, pos + data.unit:rotation():y() * 20, "slot_mask", 21)

		avoidance_ray = avoidance_ray or data.unit:raycast("ray", pos, pos + data.unit:rotation():x() * 20, "slot_mask", 21)

		if avoidance_ray and alive(avoidance_ray.unit) and avoidance_ray.unit:anim_data().walk then
			data.unit:movement():action_request({
				body_part = 1,
				type = "idle",
			})

			my_data.last_avoidance_t = data.t
		end
	end
end

function CivilianLogicEscort.on_long_distance_interact(data, amount, aggressor_unit)
	Application:info("[CivilianLogicEscort.on_long_distance_interact]", data, amount, aggressor_unit)
end

function CivilianLogicEscort.on_action_completed(data, action)
	local my_data = data.internal_data
	local action_type = action:type()

	if action_type == "walk" then
		my_data.advancing = nil

		if action:expired() and my_data.coarse_path_index then
			my_data.coarse_path_index = my_data.coarse_path_index + 1
		end
	elseif action_type == "act" and my_data.getting_up then
		my_data.getting_up = nil
	end
end

function CivilianLogicEscort._upd_pathing(data, my_data)
	if data.pathing_results then
		local pathing_results = data.pathing_results

		data.pathing_results = nil

		local path = pathing_results[my_data.advance_path_search_id]

		if path and my_data.processing_advance_path then
			my_data.processing_advance_path = nil

			if path ~= "failed" then
				my_data.advance_path = path
			else
				print("[CivilianLogicEscort:_upd_pathing] advance_path failed")
				managers.groupai:state():on_civilian_objective_failed(data.unit, data.objective)

				return
			end
		end

		path = pathing_results[my_data.coarse_path_search_id]

		if path and my_data.processing_coarse_path then
			my_data.processing_coarse_path = nil

			if path ~= "failed" then
				my_data.coarse_path = path
				my_data.coarse_path_index = 1
			else
				managers.groupai:state():on_civilian_objective_failed(data.unit, data.objective)

				return
			end
		end
	end
end

function CivilianLogicEscort.on_new_objective(data, old_objective)
	CivilianLogicIdle.on_new_objective(data, old_objective)
end

function CivilianLogicEscort.damage_clbk(data, damage_info)
	return
end

function CivilianLogicEscort._get_objective_path_data(data, my_data)
	local objective = data.objective
	local path_data = objective.path_data
	local path_style = objective.path_style

	if path_data then
		if path_style == "precise" then
			local path = {
				mvector3.copy(data.m_pos),
			}

			for _, point in ipairs(path_data.points) do
				table.insert(path, point.position)
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
		elseif path_style == "coarse" then
			local t_ins = table.insert

			my_data.coarse_path_index = 1

			local start_seg = data.unit:movement():nav_tracker():nav_segment()

			my_data.coarse_path = {
				{
					start_seg,
				},
			}

			local coarse_path = my_data.coarse_path
			local points = path_data.points
			local i_point = 1

			while i_point <= #path_data.points do
				local next_pos = points[i_point].position
				local next_seg = managers.navigation:get_nav_seg_from_pos(next_pos)

				t_ins(coarse_path, {
					next_seg,
					mvector3.copy(next_pos),
				})

				i_point = i_point + 1
			end
		elseif path_style == "destination" then
			my_data.coarse_path_index = 1

			local start_seg = data.unit:movement():nav_tracker():nav_segment()
			local end_pos = mvector3.copy(path_data.points[#path_data.points].position)
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
		end
	end
end

function CivilianLogicEscort.too_scared_to_move(data)
	local my_data = data.internal_data
	local nobody_close = true
	local min_dis_sq = (data.char_tweak.escort_safe_dist or 1000) + my_data.safe_distance_offset

	min_dis_sq = min_dis_sq * min_dis_sq

	for c_key, c_data in pairs(managers.groupai:state():all_player_criminals()) do
		if min_dis_sq > mvector3.distance_sq(c_data.m_pos, data.m_pos) then
			nobody_close = nil

			break
		end
	end

	if nobody_close then
		return "abandoned"
	end

	local player_team_id = tweak_data.levels:get_default_team_ID("player")
	local nobody_close = true
	local min_dis_sq = data.char_tweak.escort_scared_dist

	min_dis_sq = min_dis_sq * min_dis_sq

	for c_key, c_data in pairs(managers.enemy:all_enemies()) do
		if not c_data.unit:anim_data().surrender and c_data.unit:brain()._current_logic_name ~= "trade" and not not c_data.unit:movement():team().foes[player_team_id] and min_dis_sq > mvector3.distance_sq(c_data.m_pos, data.m_pos) and math.abs(c_data.m_pos.z - data.m_pos.z) < 250 then
			nobody_close = nil

			break
		end
	end

	if not nobody_close then
		return "hostiles"
	end
end

function CivilianLogicEscort._begin_advance_action(data, my_data)
	CopLogicAttack._adjust_path_start_pos(data, my_data.advance_path)

	local objective = data.objective
	local haste = objective and objective.haste or "walk"
	local new_action_data = {
		body_part = 2,
		end_rot = objective.rot,
		nav_path = my_data.advance_path,
		type = "walk",
		variant = haste,
	}

	my_data.advancing = data.unit:brain():action_request(new_action_data)

	if my_data.advancing then
		data.brain:rem_pos_rsrv("path")

		my_data.advance_path = nil
	else
		debug_pause("[CivilianLogicEscort._begin_advance_action] failed to start")
	end
end

function CivilianLogicEscort._begin_stand_hesitant_action(data, my_data)
	local action = {
		blocks = {
			action = -1,
			heavy_hurt = -1,
			hurt = -1,
			walk = -1,
		},
		body_part = 1,
		clamp_to_graph = true,
		type = "act",
		variant = "cm_so_escort_get_up_hesitant",
	}

	my_data.getting_up = data.unit:movement():action_request(action)
end

function CivilianLogicEscort._get_all_paths(data)
	return {
		advance_path = data.internal_data.advance_path,
	}
end

function CivilianLogicEscort._set_verified_paths(data, verified_paths)
	data.internal_data.stare_path = verified_paths.stare_path
end

function CivilianLogicEscort.on_alert()
	return
end
