GroupAIStateBesiege = GroupAIStateBesiege or class(GroupAIStateBase)
GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS = 4
GroupAIStateBesiege._ANTICIPATION_RESERVE = 6
GroupAIStateBesiege.POLICE_UPDATE_INTERVAL = 1

local mvec3_dis = mvector3.distance_sq

function GroupAIStateBesiege:init()
	GroupAIStateBesiege.super.init(self)
	self:on_tweak_data_reloaded()

	self.max_important_distance = self._tweak_data.max_important_distance or math.huge

	if not Network:is_server() then
		return
	end
end

function GroupAIStateBesiege:on_tweak_data_reloaded()
	self._tweak_data = tweak_data.group_ai.besiege
end

function GroupAIStateBesiege:_init_misc_data(clean_up)
	GroupAIStateBesiege.super._init_misc_data(self, clean_up)
	self:_create_area_data()

	self._task_data = {
		assault = {
			disabled = true,
			is_first = true,
		},
		reenforce = {
			next_dispatch_t = 0,
			tasks = {},
		},
		regroup = {},
	}

	if managers.navigation:is_data_ready() then
		self:_assign_enemies()
	else
		Application:debug("[GroupAIStateBase:GroupAIStateBesiege()] nav data not ready, queuing..")
		managers.navigation:add_listener(self:nav_ready_listener_key(), {
			"navigation_ready",
		}, callback(self, self, "_assign_enemies"))
	end

	self._disable_teleport_ai = false
	self._spawn_group_override = nil
	self._enemy_update_t = self._t + self.POLICE_UPDATE_INTERVAL
end

function GroupAIStateBesiege:_assign_enemies()
	local all_areas = self._area_data

	for u_key, u_data in pairs(self._police) do
		if not u_data.assigned_area then
			local nav_seg = u_data.unit:movement():nav_tracker():nav_segment()
			local nav_area = self:get_area_from_nav_seg_id(nav_seg)

			self:set_enemy_assigned(nav_area, u_key)
		end
	end

	managers.navigation:remove_listener(self:nav_ready_listener_key())
end

function GroupAIStateBesiege:set_disable_teleport_ai(value)
	self._disable_teleport_ai = value
end

function GroupAIStateBesiege:clean_up()
	managers.navigation:remove_listener(self:nav_ready_listener_key())
	self:_init_misc_data(true)
end

function GroupAIStateBesiege:nav_ready_listener_key()
	return "GroupAIStateBesiege"
end

function GroupAIStateBesiege:update(t, dt)
	GroupAIStateBesiege.super.update(self, t, dt)

	if not Network:is_server() then
		return
	end

	if t > self._enemy_update_t then
		self:_update_enemy_activity()
	end

	if managers.navigation:is_data_ready() and self._draw_enabled then
		self:_draw_enemy_activity(t)
		self:_draw_spawn_points()
	end
end

function GroupAIStateBesiege:paused_update(t, dt)
	GroupAIStateBesiege.super.paused_update(self, t, dt)

	if not Network:is_server() then
		return
	end

	if self._draw_enabled and managers.navigation:is_data_ready() then
		self:_draw_enemy_activity(t)
		self:_draw_spawn_points()
	end
end

function GroupAIStateBesiege:assign_enemy_to_group_ai(unit, team_id)
	local u_tracker = unit:movement():nav_tracker()
	local seg = u_tracker:nav_segment()
	local area = self:get_area_from_nav_seg_id(seg)
	local u_name = unit:name()
	local u_category

	for _, nationality in pairs(tweak_data.group_ai.unit_categories) do
		for cat_name, category in pairs(nationality) do
			for _, test_u_name in ipairs(category.units) do
				if u_name == test_u_name then
					u_category = cat_name

					break
				end
			end
		end
	end

	local group_desc = {
		size = 1,
		type = u_category or "custom",
	}
	local group = self:_create_group(group_desc)

	group.team = self._teams[team_id]

	local grp_objective
	local objective = unit:brain():objective()
	local grp_obj_type = self._task_data.assault.active and "assault_area" or "recon_area"

	if objective then
		grp_objective = {
			area = objective.area or objective.nav_seg and self:get_area_from_nav_seg_id(objective.nav_seg) or area,
			type = grp_obj_type,
		}
		objective.grp_objective = grp_objective
	else
		grp_objective = {
			area = area,
			type = grp_obj_type,
		}
	end

	grp_objective.moving_out = false
	group.objective = grp_objective
	group.has_spawned = true

	self:_add_group_member(group, unit:key())
	self:set_enemy_assigned(area, unit:key())
end

function GroupAIStateBesiege:on_enemy_unregistered(unit)
	GroupAIStateBesiege.super.on_enemy_unregistered(self, unit)

	if not Network:is_server() then
		return
	end

	local u_key = unit:key()

	self:set_enemy_assigned(nil, u_key)

	local objective = unit:brain():objective()

	if objective and objective.fail_clbk then
		local fail_clbk = objective.fail_clbk

		objective.fail_clbk = nil

		fail_clbk(unit)
	end
end

function GroupAIStateBesiege:_remove_group_member(group, u_key, is_casualty)
	if self._groups[group.id] and is_casualty then
		local task = group.task

		if task == "assault" and self._task_data.assault.active then
			self._task_data.assault.casualties = self._task_data.assault.casualties + 1
		end
	end

	GroupAIStateBesiege.super._remove_group_member(self, group, u_key, is_casualty)
end

function GroupAIStateBesiege:_update_enemy_activity()
	if self._ai_enabled and not managers.worldcollection.level_transition_in_progress then
		self:_upd_SO()
		self:_upd_SO_groups()

		if self._enemy_weapons_hot then
			self:_calculate_drama_value()
			self:_upd_regroup_task()
			self:_upd_reenforce_tasks()
			self:_upd_assault_tasks()
			self:_upd_group_spawning()
			self:_begin_new_tasks()
			self:_upd_groups()
			self:_distance_based_retire_groups()
			self:_check_and_teleport_team_ai()
		end
	end

	self._enemy_update_t = self._t + self.POLICE_UPDATE_INTERVAL
end

function GroupAIStateBesiege:_check_and_teleport_team_ai()
	if self._disable_teleport_ai then
		return
	end

	local t = self._t

	self._next_teleport_teamai_t = self._next_teleport_teamai_t or t

	if t > self._next_teleport_teamai_t then
		self:teleport_team_ai()

		self._next_teleport_teamai_t = t + 4
	end
end

function GroupAIStateBesiege:_upd_SO()
	local t = self._t
	local so_to_delete = {}

	for id, so in pairs(self._special_objectives) do
		if t > so.delay_t then
			if so.data.interval then
				so.delay_t = t + so.data.interval
			end

			if so.chance == 1 or math.random() <= so.chance then
				local so_data = so.data

				so.chance = so_data.base_chance

				if so_data.objective.follow_unit and not alive(so_data.objective.follow_unit) then
					table.insert(so_to_delete, id)
				else
					local unit_data = GroupAIStateBase._execute_so(self, so_data, so.rooms, so.administered)

					if unit_data then
						if so.remaining_usage then
							so.remaining_usage = so.remaining_usage - 1

							if so.remaining_usage == 0 then
								table.insert(so_to_delete, id)
							end
						end

						if so.non_repeatable then
							so.administered[unit_data.unit:key()] = true
						end
					end
				end
			elseif so.data.chance_inc then
				so.chance = so.chance + so.data.chance_inc
			end

			if not so.data.interval then
				table.insert(so_to_delete, id)
			end
		end
	end

	for _, so_id in ipairs(so_to_delete) do
		self:remove_special_objective(so_id)
	end
end

function GroupAIStateBesiege:_begin_new_tasks()
	local all_areas = self._area_data
	local nav_manager = managers.navigation
	local all_nav_segs = nav_manager._nav_segments
	local task_data = self._task_data
	local t = self._t
	local reenforce_candidates
	local reenforce_data = task_data.reenforce

	if reenforce_data.next_dispatch_t and t > reenforce_data.next_dispatch_t then
		reenforce_candidates = {}
	end

	local assault_candidates
	local assault_data = task_data.assault

	if self:get_clamped_difficulty() > 0 and assault_data.next_dispatch_t and t > assault_data.next_dispatch_t and not task_data.regroup.active then
		assault_candidates = true
	end

	if not reenforce_candidates and not assault_candidates then
		return
	end

	local found_areas = {}
	local to_search_areas = {}

	for area_id, area in pairs(all_areas) do
		if area.spawn_points then
			for _, sp_data in pairs(area.spawn_points) do
				if t >= sp_data.delay_t and not all_nav_segs[sp_data.nav_seg].disabled then
					table.insert(to_search_areas, area)

					found_areas[area_id] = true

					break
				end
			end
		end

		if not found_areas[area_id] and area.spawn_groups then
			for _, sp_data in pairs(area.spawn_groups) do
				if t >= sp_data.delay_t and not all_nav_segs[sp_data.nav_seg].disabled then
					table.insert(to_search_areas, area)

					found_areas[area_id] = true

					break
				end
			end
		end
	end

	if #to_search_areas == 0 then
		return
	end

	local i = 1

	repeat
		local area = to_search_areas[i]
		local force_factor = area.factors.reenforce
		local force_demand = force_factor and force_factor.amount
		local nr_police = area.police.amount
		local nr_criminals = area.criminal.amount
		local is_area_safe = nr_criminals == 0

		if reenforce_candidates and force_demand and force_demand > 0 and is_area_safe then
			local area_free = true

			for i_task, reenforce_task_data in ipairs(reenforce_data.tasks) do
				if reenforce_task_data.target_area == area then
					area_free = false

					break
				end
			end

			if area_free then
				table.insert(reenforce_candidates, area)
			end
		end

		if is_area_safe then
			for neighbour_area_id, neighbour_area in pairs(area.neighbours) do
				if not found_areas[neighbour_area_id] then
					table.insert(to_search_areas, neighbour_area)

					found_areas[neighbour_area_id] = true
				end
			end
		end

		i = i + 1
	until i > #to_search_areas

	if assault_candidates then
		self:_begin_assault_task()
	end

	if reenforce_candidates and #reenforce_candidates > 0 then
		local lucky_i_candidate = math.random(#reenforce_candidates)
		local reenforce_area = reenforce_candidates[lucky_i_candidate]

		self:_begin_reenforce_task(reenforce_area)
	end
end

function GroupAIStateBesiege:_begin_assault_task()
	local assault_task = self._task_data.assault

	assault_task.active = true
	assault_task.next_dispatch_t = nil
	assault_task.target_area = self:_find_assault_target_area()
	assault_task.start_t = self._t

	local diff_depend_force = self:get_difficulty_dependent_value(self._tweak_data.assault.force)
	local diff_depend_force_mul = self:_get_balancing_multiplier(self._tweak_data.assault.force_balance_mul)

	assault_task.is_first = nil
	assault_task.force = math.ceil(diff_depend_force * diff_depend_force_mul)
	assault_task.spawned_total = 0
	assault_task.casualties = 0

	if self._hunt_mode then
		self:_begin_assault_task_phase_build(assault_task)
	else
		self:_begin_assault_task_phase_anticipation(assault_task)
	end

	managers.dialog:queue_dialog("player_gen_incoming_wave", {
		skip_idle_check = true,
		sphere = nil,
	})

	if self._draw_drama then
		table.insert(self._draw_drama.assault_hist, {
			self._t,
		})
	end

	Application:debug("[GroupAi:Generic] ----------- BEGIN ASS. ANTICIPATION -------------", inspect(assault_task))
end

function GroupAIStateBesiege:_upd_assault_tasks()
	local task_data = self._task_data.assault

	if not task_data.active then
		return
	end

	local diff_spawn_pool = self:get_difficulty_dependent_value(self._tweak_data.assault.spawn_pool)
	local diff_spawn_pool_mul = self:_get_balancing_multiplier(self._tweak_data.assault.spawn_pool_balance_mul)
	local spawn_pool = diff_spawn_pool * diff_spawn_pool_mul
	local task_spawn_allowance = spawn_pool - task_data.casualties
	local no_spawn_allowance = task_spawn_allowance <= 0

	if task_spawn_allowance <= 0 and task_data.phase ~= "fade" then
		Application:trace("[GroupAIStateBesiege:_upd_assault_tasks] Too too many casulties, fall back")
		self:_begin_assault_task_phase_fade(task_data)
	end

	if self._update_phase then
		local cancel_logic = self:_update_phase(task_data)

		if cancel_logic then
			return
		end
	end

	if managers.enemy:is_commander_active() or self._drama_data.zone == "low" or self._hunt_mode then
		for criminal_key, criminal_data in pairs(self._criminals) do
			self:criminal_spotted(criminal_data.unit)

			for group_id, group in pairs(self._groups) do
				if group.objective.charge then
					for u_key, u_data in pairs(group.units) do
						u_data.unit:brain():clbk_group_member_attention_identified(nil, criminal_key)
					end
				end
			end
		end
	end

	task_data.target_area = self:_find_assault_target_area(task_data.target_area)

	self:_assign_recon_groups_to_retire()
	self:_upd_assault_spawning(task_data)
	self:_assign_enemy_groups_to_assault(task_data.phase)
end

local tmp_vec3 = Vector3()

function GroupAIStateBesiege:_find_assault_target_area(target_area)
	if target_area and not self:is_area_safe_assault(target_area) then
		return target_area
	end

	local target_pos = target_area and target_area.pos
	local nearest_area, nearest_dis

	for _, criminal_data in pairs(self._player_criminals) do
		if not criminal_data.status then
			local dis = math.huge

			if target_pos then
				mvector3.set(tmp_vec3, criminal_data.m_pos)
				mvector3.set_z(tmp_vec3, target_pos.z + math.abs(tmp_vec3.z - target_pos.z) * 2)

				dis = mvec3_dis(target_pos, tmp_vec3)
			end

			if not nearest_dis or dis < nearest_dis then
				nearest_dis = dis
				nearest_area = self:get_area_from_nav_seg_id(criminal_data.tracker:nav_segment())
			end
		end
	end

	return nearest_area or target_area
end

function GroupAIStateBesiege:_begin_assault_task_phase_anticipation(task_data)
	local anticipation_duration = self._tweak_data.assault.anticipation_duration

	managers.hud:setup_anticipation(anticipation_duration)
	managers.hud:start_anticipation()

	task_data.phase = "anticipation"
	task_data.phase_end_t = self._t + anticipation_duration
	self._update_phase = self._upd_assault_task_phase_anticipation
end

function GroupAIStateBesiege:_upd_assault_task_phase_anticipation(task_data)
	if self._t < task_data.phase_end_t then
		managers.hud:check_start_anticipation_music(task_data.phase_end_t - self._t)
	else
		self:_begin_assault_task_phase_build(task_data)
	end
end

function GroupAIStateBesiege:_begin_assault_task_phase_build(task_data)
	managers.mission:call_global_event("start_assault")
	managers.hud:start_assault()

	task_data.phase = "build"
	self._update_phase = self._upd_assault_task_phase_build
	task_data.phase_end_t = self._t + self._tweak_data.assault.build_duration

	self:set_assault_mode(true)
	managers.music:raid_music_state_change(MusicManager.RAID_MUSIC_ASSAULT)
end

function GroupAIStateBesiege:_upd_assault_task_phase_build(task_data)
	if self._t > task_data.phase_end_t or self._drama_data.zone == "high" then
		self:_begin_assault_task_phase_sustain(task_data)
	end
end

function GroupAIStateBesiege:_begin_assault_task_phase_sustain(task_data)
	task_data.phase = "sustain"
	self._update_phase = self._upd_assault_task_phase_sustain

	local sustain_min = self:get_difficulty_dependent_value(self._tweak_data.assault.sustain_duration_min)
	local sustain_max = self:get_difficulty_dependent_value(self._tweak_data.assault.sustain_duration_max)
	local sustain_mul = self:_get_balancing_multiplier(self._tweak_data.assault.sustain_duration_balance_mul)
	local sutain_duration = math.lerp(sustain_min, sustain_max, math.random()) * sustain_mul

	task_data.phase_end_t = self._t + sutain_duration
end

function GroupAIStateBesiege:_upd_assault_task_phase_sustain(task_data)
	if self._hunt_mode then
		return
	end

	if self._t > task_data.phase_end_t then
		self:_begin_assault_task_phase_fade(task_data)
	end
end

function GroupAIStateBesiege:_begin_assault_task_phase_fade(task_data)
	if self._hunt_mode then
		return
	end

	managers.music:raid_music_state_change(MusicManager.RAID_MUSIC_CONTROL)

	task_data.phase = "fade"
	self._update_phase = self._upd_assault_task_phase_fade
	task_data.phase_end_t = self._t + self._tweak_data.assault.fade_duration
end

function GroupAIStateBesiege:_upd_assault_task_phase_fade(task_data)
	if self._hunt_mode then
		return
	end

	local end_assault = task_data.force_end
	local min_enemies_left = self._tweak_data.assault.fade_enemy_limit
	local enemies_left = self:_count_police_force("assault")
	local enemies_low = enemies_left < min_enemies_left
	local timed_out = self._t > task_data.phase_end_t + self._tweak_data.assault.fade_task_timeout

	if enemies_low or timed_out then
		local alive_criminals = self:num_char_criminals()
		local engagement = self:_count_criminals_engaged_force(alive_criminals)
		local drama_low = self._drama_data.amount < tweak_data.drama.assault_fade_end

		timed_out = self._t > task_data.phase_end_t + self._tweak_data.assault.fade_drama_timeout

		if timed_out or drama_low and engagement < alive_criminals then
			end_assault = true

			Application:debug("[GroupAi:Generic] END ASSAULT!", "Reason: " .. (timed_out and "Timed Out" or "Drama & Engagement Low"))
		end
	end

	if end_assault then
		Application:debug("[GroupAi:Generic] assault task clear")

		task_data.active = nil
		task_data.phase = nil

		if self._draw_drama then
			self._draw_drama.assault_hist[#self._draw_drama.assault_hist][2] = self._t
		end

		managers.music:raid_music_state_change(MusicManager.RAID_MUSIC_CONTROL)
		managers.mission:call_global_event("end_assault")
		self:_begin_regroup_task()

		return true
	end
end

function GroupAIStateBesiege:_upd_assault_spawning(task_data)
	if next(self._spawning_groups) then
		return
	end

	if task_data.phase == "fade" then
		return
	end

	local nr_wanted = task_data.force - self:_count_police_force("assault")

	if task_data.phase == "anticipation" then
		nr_wanted = nr_wanted - self._ANTICIPATION_RESERVE
	end

	if not (nr_wanted > 0) then
		return
	end

	local allowed_groups = self:_get_spawn_groups("assault")
	local primary_target_area = task_data.target_area
	local spawn_group, group_nationality, spawn_group_type = self:_find_spawn_group_near_area(primary_target_area, allowed_groups, nil, nil, nil)

	if spawn_group then
		local grp_objective = {
			area = spawn_group.area,
			attitude = "avoid",
			coarse_path = {
				{
					spawn_group.area.pos_nav_seg,
					spawn_group.area.pos,
				},
			},
			pose = "crouch",
			stance = "hos",
			type = "assault_area",
		}
		local group = self:_spawn_in_group(spawn_group, group_nationality, spawn_group_type, grp_objective, task_data)

		if group then
			group.task = "assault"
		end
	end
end

function GroupAIStateBesiege:_distance_based_retire_groups()
	local max_distance = self._tweak_data.max_distance_to_player

	if not max_distance then
		return
	end

	for _, group in pairs(self._groups) do
		if group.has_spawned and group.objective.type ~= "retire" then
			local closest_dis_sq

			for _, crim_data in pairs(self:all_player_criminals()) do
				local my_dis_sq = mvec3_dis(crim_data.m_pos, group.objective.area.pos)

				if not closest_dis_sq or my_dis_sq < closest_dis_sq then
					closest_dis_sq = my_dis_sq
				end
			end

			if closest_dis_sq then
				if closest_dis_sq > max_distance * 2 then
					for _, unit in ipairs(group.units) do
						unit:set_slot(0)
					end
				elseif max_distance < closest_dis_sq then
					self:_assign_group_to_retire(group)
				end
			end
		end
	end
end

function GroupAIStateBesiege:_verify_anticipation_spawn_point(sp_data)
	local sp_nav_seg = sp_data.nav_seg
	local area = self:get_area_from_nav_seg_id(sp_nav_seg)

	if area.is_safe then
		return true
	end

	for criminal_key, c_data in pairs(self._criminals) do
		if not c_data.status and not c_data.is_deployable and mvector3.distance(sp_data.pos, c_data.m_pos) < 2500 and math.abs(sp_data.pos.z - c_data.m_pos.z) < 300 then
			return
		end
	end

	return true
end

function GroupAIStateBesiege:_begin_regroup_task()
	self._task_data.regroup.start_t = self._t
	self._task_data.regroup.end_t = self._t + self._tweak_data.regroup.duration
	self._task_data.regroup.active = true
	self._update_phase = nil

	if self._draw_drama then
		table.insert(self._draw_drama.regroup_hist, {
			self._t,
		})
	end

	self:_assign_assault_groups_to_retire()
end

function GroupAIStateBesiege:_end_regroup_task()
	if not self._task_data.regroup.active then
		return
	end

	self._task_data.regroup.active = nil

	self:set_assault_mode(false)
	managers.hud:end_assault(true)

	if not self._task_data.assault.next_dispatch_t then
		local assault_delay = self._tweak_data.assault.delay

		self._task_data.assault.next_dispatch_t = self._t + self:get_difficulty_dependent_value(assault_delay)
	end

	if self._draw_drama then
		self._draw_drama.regroup_hist[#self._draw_drama.regroup_hist][2] = self._t
	end
end

function GroupAIStateBesiege:_upd_regroup_task()
	if not self._task_data.regroup.active then
		return
	end

	self:_assign_assault_groups_to_retire()

	if self._t > self._task_data.regroup.end_t or self._drama_data.zone == "low" then
		self:_end_regroup_task()
	end
end

function GroupAIStateBesiege:_find_spawn_group_near_area(target_area, allowed_groups, target_pos, max_dis, verify_clbk)
	if not target_area then
		return
	end

	local all_areas = self._area_data

	max_dis = max_dis or self._tweak_data.max_spawning_distance

	local min_dis = self._tweak_data.min_spawning_distance and self._tweak_data.min_spawning_distance * self._tweak_data.min_spawning_distance or 0
	local max_z_dis_sq = self._tweak_data.max_spawning_height_diff or 0

	max_dis = max_dis and max_dis * max_dis

	local t = self._t
	local valid_spawn_groups = {}
	local valid_spawn_group_distances = {}

	target_pos = target_pos or target_area.pos

	local to_search_areas = {
		target_area,
	}
	local found_areas = {}

	found_areas[target_area.id] = true

	repeat
		local search_area = table.remove(to_search_areas, 1)
		local spawn_groups = search_area.spawn_groups

		if spawn_groups then
			for _, spawn_group in ipairs(spawn_groups) do
				if t >= spawn_group.delay_t and (not verify_clbk or verify_clbk(spawn_group)) then
					local z_dis_sq = math.abs(target_pos.z - spawn_group.pos.z)

					z_dis_sq = z_dis_sq * z_dis_sq

					local my_dis = mvec3_dis(target_pos, spawn_group.pos)

					if my_dis < max_dis and (z_dis_sq == 0 or z_dis_sq < max_z_dis_sq) then
						if my_dis < min_dis then
							my_dis = max_dis
						end

						table.insert(valid_spawn_groups, spawn_group)
						table.insert(valid_spawn_group_distances, my_dis)
					end
				end
			end
		end

		for other_area_id, other_area in pairs(all_areas) do
			if not found_areas[other_area_id] and other_area.neighbours[search_area.id] then
				table.insert(to_search_areas, other_area)

				found_areas[other_area_id] = true
			end
		end
	until #to_search_areas == 0

	if not next(valid_spawn_group_distances) then
		return
	end

	local total_weight = 0
	local candidate_groups = {}

	for i, distance in ipairs(valid_spawn_group_distances) do
		local weight = math.lerp(1, 0.2, math.min(1, distance / max_dis))
		local spawn_group = valid_spawn_groups[i]
		local group_types = spawn_group.mission_element:spawn_groups()
		local nationality = spawn_group.mission_element:nationality()

		total_weight = total_weight + self:_compile_best_groups(candidate_groups, spawn_group, nationality, group_types, allowed_groups, weight)
	end

	if total_weight == 0 then
		return
	end

	return self:_choose_best_group(candidate_groups, total_weight)
end

function GroupAIStateBesiege:_compile_best_groups(best_groups, group, nationality, group_types, allowed_groups, weight)
	local group_pool = tweak_data.group_ai.enemy_spawn_groups
	local total_weight = 0

	for _, group_type in ipairs(group_types) do
		if group_pool[nationality][group_type] then
			local cat_weights = allowed_groups[group_type]

			if cat_weights then
				local cat_weight = self:get_difficulty_dependent_value(cat_weights)
				local mod_weight = weight * cat_weight

				table.insert(best_groups, {
					group = group,
					group_type = group_type,
					nationality = nationality,
					weight = mod_weight,
				})

				total_weight = total_weight + mod_weight
			end
		else
			debug_pause("[GroupAIStateBesiege:_compile_best_groups] non-existent spawn_group:", group_type, ". element id:", group.mission_element._id)
		end
	end

	return total_weight
end

function GroupAIStateBesiege:_choose_best_group(best_groups, total_weight)
	local rand_wgt = total_weight * math.random()
	local best_grp, best_grp_nationality, best_grp_type

	for i, candidate in ipairs(best_groups) do
		rand_wgt = rand_wgt - candidate.weight

		if rand_wgt <= 0 then
			best_grp = candidate.group
			best_grp_nationality = candidate.nationality
			best_grp_type = candidate.group_type
			best_grp.delay_t = self._t + best_grp.interval

			break
		end
	end

	return best_grp, best_grp_nationality, best_grp_type
end

function GroupAIStateBesiege:force_spawn_group(group, nationality, group_types)
	local best_groups = {}
	local allowed_groups = self:_get_spawn_groups("assault")
	local total_weight = self:_compile_best_groups(best_groups, group, nationality, group_types, allowed_groups, 1)

	if total_weight <= 0 then
		return
	end

	local spawn_group, nationality, spawn_group_type = self:_choose_best_group(best_groups, total_weight)

	if spawn_group then
		local grp_objective = {
			area = spawn_group.area,
			attitude = "avoid",
			coarse_path = {
				{
					spawn_group.area.pos_nav_seg,
					spawn_group.area.pos,
				},
			},
			pose = "crouch",
			stance = "hos",
			type = "assault_area",
		}
		local group = self:_spawn_in_group(spawn_group, nationality, spawn_group_type, grp_objective)

		if group then
			group.task = "assault"
		end
	end

	Application:info("[GroupAIStateBesiege]", nationality, spawn_group_type, inspect(spawn_group))
end

function GroupAIStateBesiege:_spawn_in_individual_groups(grp_objective, spawn_points, task)
	for i_sp, spawn_point in ipairs(spawn_points) do
		local group_desc = {
			size = 1,
			type = "custom",
		}
		local grp_objective_cpy = clone(grp_objective)

		if not grp_objective_cpy.area then
			grp_objective_cpy.area = spawn_point.area
		end

		local group = self:_create_group(group_desc)

		group.objective = grp_objective_cpy
		group.objective.moving_out = true

		local spawn_task = {
			group = group,
			objective = self._create_objective_from_group_objective(grp_objective_cpy),
			spawn_point = spawn_point,
			task = task,
		}

		table.insert(self._spawning_groups, spawn_task)
	end
end

function GroupAIStateBesiege._extract_group_desc_structure(spawn_entry_outer, valid_unit_entries)
	for spawn_entry_key, spawn_entry in ipairs(spawn_entry_outer) do
		if spawn_entry.unit then
			table.insert(valid_unit_entries, clone(spawn_entry))
		else
			GroupAIStateBesiege._extract_group_desc_structure(spawn_entry, valid_unit_entries)
		end
	end

	for spawn_entry_key, spawn_entry in pairs(spawn_entry_outer) do
		if (type(spawn_entry_key) ~= "number" or spawn_entry_key > #spawn_entry_outer) and #spawn_entry ~= 0 then
			local i_rand = math.random(#spawn_entry)
			local rand_branch = spawn_entry[i_rand]

			if rand_branch.unit then
				table.insert(valid_unit_entries, clone(rand_branch))
			else
				GroupAIStateBesiege._extract_group_desc_structure(rand_branch, valid_unit_entries)
			end
		end
	end
end

function GroupAIStateBesiege:_is_special_spawn_allowed(special_type, spawn_entry)
	if self._task_data.assault.phase ~= "sustain" then
		return false
	end

	local spawn_limit = self._tweak_data.special_unit_spawn_limits[special_type]
	local unit_count = self:num_special_unit(special_type)
	local amount_min = spawn_entry and spawn_entry.amount_min or 0

	if spawn_limit < unit_count + amount_min then
		Application:warn("[GroupAIStateBesiege:_is_special_spawn_allowed] Spawning denied for", special_type, "(spawn limit reached)")

		return false
	end

	if not self._special_units[special_type] or not self._special_units[special_type].next_allowed_t then
		return true
	end

	local next_allowed_t = self._special_units[special_type].next_allowed_t

	if next_allowed_t <= self._t then
		return true
	end

	if self._drama_data.zone ~= "high" then
		local base_chance = 1 - unit_count / spawn_limit
		local drama_mul = 1 - self._drama_data.amount
		local bypass_cooldown = math.random()

		if bypass_cooldown <= base_chance * drama_mul then
			return true
		end
	end

	Application:warn("[GroupAIStateBesiege:_is_special_spawn_allowed] Spawning denied for", special_type, "(on cooldown)")

	return false
end

function GroupAIStateBesiege:_spawn_in_group(spawn_group, group_nationality, spawn_group_type, grp_objective, ai_task)
	local spawn_group_desc = tweak_data.group_ai.enemy_spawn_groups[group_nationality][spawn_group_type]
	local wanted_nr_units

	if type(spawn_group_desc.amount) == "table" then
		wanted_nr_units = math.random(spawn_group_desc.amount[1], spawn_group_desc.amount[2])
	else
		wanted_nr_units = spawn_group_desc.amount
	end

	local neighbours_safe = self:_chk_area_neighbours_safe(spawn_group.area)
	local valid_unit_types = {}

	self._extract_group_desc_structure(spawn_group_desc.spawn, valid_unit_types)

	local unit_categories = tweak_data.group_ai.unit_categories[group_nationality]
	local total_wgt = 0
	local i = 1

	while i <= #valid_unit_types do
		local spawn_entry = valid_unit_types[i]
		local cat_data = unit_categories[spawn_entry.unit]

		if not cat_data then
			debug_pause("[GroupAIStateBesiege:_spawn_in_group] unit category doesn't exist:", spawn_entry.unit)

			return
		end

		if spawn_entry.tactics and spawn_entry.tactics.attack_range and not neighbours_safe then
			spawn_group.delay_t = self._t + 1

			return
		end

		if cat_data.special_type and not self:_is_special_spawn_allowed(cat_data.special_type, spawn_entry) then
			spawn_group.delay_t = self._t + 1

			return
		end

		total_wgt = total_wgt + spawn_entry.freq
		i = i + 1
	end

	for _, sp_data in ipairs(spawn_group.spawn_pts) do
		sp_data.delay_t = self._t + math.rand(3)
	end

	local spawn_task = {
		ai_task = ai_task,
		objective = not grp_objective.element and self._create_objective_from_group_objective(grp_objective),
		spawn_group = spawn_group,
		spawn_group_type = spawn_group_type,
		units_remaining = {},
	}

	table.insert(self._spawning_groups, spawn_task)

	local function _add_unit_type_to_spawn_task(i, spawn_entry)
		local spawn_amount_mine = 1 + (spawn_task.units_remaining[spawn_entry.unit] and spawn_task.units_remaining[spawn_entry.unit].amount or 0)

		spawn_task.units_remaining[spawn_entry.unit] = {
			amount = spawn_amount_mine,
			nationality = group_nationality,
			spawn_entry = spawn_entry,
		}
		wanted_nr_units = wanted_nr_units - 1

		if spawn_entry.amount_min then
			spawn_entry.amount_min = spawn_entry.amount_min - 1
		end

		if spawn_entry.amount_max then
			spawn_entry.amount_max = spawn_entry.amount_max - 1

			if spawn_entry.amount_max == 0 then
				table.remove(valid_unit_types, i)

				total_wgt = total_wgt - spawn_entry.freq

				return true
			end
		end
	end

	local i = 1

	while i <= #valid_unit_types do
		local spawn_entry = valid_unit_types[i]

		if i <= #valid_unit_types and wanted_nr_units > 0 and spawn_entry.amount_min and spawn_entry.amount_min > 0 and (not spawn_entry.amount_max or spawn_entry.amount_max > 0) then
			if not _add_unit_type_to_spawn_task(i, spawn_entry) then
				i = i + 1
			end
		else
			i = i + 1
		end
	end

	while wanted_nr_units > 0 and #valid_unit_types ~= 0 do
		local rand_weight = math.random() * total_wgt
		local rand_i = 1
		local rand_entry

		repeat
			rand_entry = valid_unit_types[rand_i]
			rand_weight = rand_weight - rand_entry.freq

			if rand_weight <= 0 then
				break
			else
				rand_i = rand_i + 1
			end
		until false

		local cat_data = unit_categories[rand_entry.unit]

		if cat_data.special_type and self._tweak_data.special_unit_spawn_limits[cat_data.special_type] and self:num_special_unit(cat_data.special_type) >= self._tweak_data.special_unit_spawn_limits[cat_data.special_type] then
			table.remove(valid_unit_types, rand_i)

			total_wgt = total_wgt - rand_entry.freq
		else
			_add_unit_type_to_spawn_task(rand_i, rand_entry)
		end
	end

	local group_desc = {
		size = 0,
		type = spawn_group_type,
	}

	for u_name, spawn_info in pairs(spawn_task.units_remaining) do
		group_desc.size = group_desc.size + spawn_info.amount
	end

	local group = self:_create_group(group_desc)

	group.objective = grp_objective
	group.objective.moving_out = true
	group.team = self._teams[spawn_group.team_id or tweak_data.levels:get_default_team_ID("combatant")]
	group.spawn_area = spawn_group.area
	spawn_task.group = group

	return group
end

function GroupAIStateBesiege:_try_spawn_unit(u_type_name, nationality, spawn_entry, spawn_task, nr_units_spawned, produce_data)
	if nr_units_spawned >= GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS then
		return
	end

	local function _criminals_see_spawning(mission_element)
		local elem_check_pos = mission_element:value("position") + math.UP * 100

		for _, u_data in pairs(managers.groupai:state():all_player_criminals()) do
			local obstructed = World:raycast("ray", u_data.unit:movement():m_head_pos(), elem_check_pos, "ray_type", "ai_vision", "slot_mask", managers.slot:get_mask("world_geometry"), "report")

			if not obstructed then
				return false
			end
		end

		return true
	end

	local hopeless = true
	local group_ai_tweak = tweak_data.group_ai
	local spawn_points = spawn_task.spawn_group.spawn_pts
	local category = group_ai_tweak.unit_categories[nationality][u_type_name]

	for _, sp_data in ipairs(spawn_points) do
		if (sp_data.accessibility == "any" or category.access[sp_data.accessibility]) and (not sp_data.amount or sp_data.amount > 0) and sp_data.mission_element:enabled() then
			hopeless = false

			if sp_data.mission_element.forbid_seen and not _criminals_see_spawning(sp_data.mission_element) then
				Application:info("[GroupAi:Generic] _try_spawn_unit Will not spawn unit due to player visibility, Can try again later once the players move")

				return true
			end

			if self._t > sp_data.delay_t then
				produce_data.name = category.units[math.random(#category.units)]

				local spawned_unit = sp_data.mission_element:produce(produce_data)
				local u_key = spawned_unit:key()
				local objective

				if spawn_task.objective then
					objective = self.clone_objective(spawn_task.objective)
				else
					objective = spawn_task.group.objective.element:get_random_SO(spawned_unit)

					if not objective then
						Application:warn("[GroupAIStateBesiege] Could not keep unit, no objective at pos", spawned_unit:position())
						spawned_unit:set_slot(0)

						return true
					end

					objective.grp_objective = spawn_task.group.objective
				end

				local u_data = self._police[u_key]

				self:set_enemy_assigned(objective.area, u_key)

				if spawn_entry.tactics then
					u_data.tactics = spawn_entry.tactics
				end

				local sp_brain = spawned_unit:brain()

				sp_brain:set_spawn_entry(spawn_entry, u_data.tactics)

				u_data.rank = spawn_entry.rank

				self:_add_group_member(spawn_task.group, u_key)

				if sp_brain:is_available_for_assignment(objective) then
					if objective.element then
						objective.element:clbk_objective_administered(spawned_unit)
					end

					sp_brain:set_objective(objective)
				else
					sp_brain:set_followup_objective(objective)
				end

				if spawn_task.ai_task then
					spawn_task.ai_task.spawned_total = spawn_task.ai_task.spawned_total + 1
				end

				sp_data.delay_t = self._t + sp_data.interval

				if sp_data.amount then
					sp_data.amount = sp_data.amount - 1
				end

				return true
			end
		end
	end

	if hopeless then
		debug_pause("[GroupAIStateBesiege:_upd_group_spawning] spawn group", spawn_task.spawn_group.id, "failed to spawn unit", u_type_name)

		return true
	end
end

function GroupAIStateBesiege:_upd_group_spawning()
	local spawn_task = self._spawning_groups[1]

	if not spawn_task then
		return
	end

	local nr_units_spawned = 0
	local produce_data = {
		name = true,
		spawn_ai = {},
	}
	local unit_categories = tweak_data.group_ai.unit_categories
	local spawn_points = spawn_task.spawn_group.spawn_pts

	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		if not unit_categories[spawn_info.nationality][u_type_name].access.acrobatic then
			local nr_spawned = 0

			for i = spawn_info.amount, 1, -1 do
				local success = self:_try_spawn_unit(u_type_name, spawn_info.nationality, spawn_info.spawn_entry, spawn_task, nr_units_spawned, produce_data)

				if success then
					nr_spawned = nr_spawned + 1
					nr_units_spawned = nr_units_spawned + 1
				end
			end

			spawn_info.amount = spawn_info.amount - nr_spawned
		end
	end

	local all_spawned = true

	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		local nr_spawned = 0

		for i = spawn_info.amount, 1, -1 do
			local success = self:_try_spawn_unit(u_type_name, spawn_info.nationality, spawn_info.spawn_entry, spawn_task, nr_units_spawned, produce_data)

			if success then
				nr_spawned = nr_spawned + 1
				nr_units_spawned = nr_units_spawned + 1
			else
				all_spawned = false
			end
		end

		spawn_info.amount = spawn_info.amount - nr_spawned
	end

	if not all_spawned then
		return
	end

	spawn_task.group.has_spawned = true

	table.remove(self._spawning_groups, 1)

	if spawn_task.group.size <= 0 then
		self._groups[spawn_task.group.id] = nil
	end
end

function GroupAIStateBesiege:_begin_reenforce_task(reenforce_area)
	local new_task = {
		start_t = self._t,
		target_area = reenforce_area,
		use_spawn_event = true,
	}

	table.insert(self._task_data.reenforce.tasks, new_task)

	self._task_data.reenforce.active = true
	self._task_data.reenforce.next_dispatch_t = self._t + self:get_difficulty_dependent_value(self._tweak_data.reenforce.interval)
end

function GroupAIStateBesiege:_upd_reenforce_tasks()
	local reenforce_tasks = self._task_data.reenforce.tasks
	local t = self._t

	for i_task = #reenforce_tasks, 1, -1 do
		local task_data = reenforce_tasks[i_task]
		local force_settings = task_data.target_area.factors.reenforce
		local force_required = force_settings and force_settings.amount

		if force_required then
			local force_occupied = 0

			for group_id, group in pairs(self._groups) do
				if (group.objective.target_area or group.objective.area) == task_data.target_area and group.objective.type == "reenforce_area" then
					force_occupied = force_occupied + (group.has_spawned and group.size or group.initial_size)
				end
			end

			local force_missing = force_required - force_occupied

			if force_missing > 0 and not self._task_data.regroup.active and self._task_data.assault.phase ~= "fade" and t > self._task_data.reenforce.next_dispatch_t and self:is_area_safe(task_data.target_area) then
				self:_reenforce_area(task_data)
			elseif force_missing < 0 then
				self:_retreat_from_area(task_data, force_required)
			end
		else
			for group_id, group in pairs(self._groups) do
				if group.has_spawned and (group.objective.target_area or group.objective.area) == task_data.target_area and group.objective.type == "reenforce_area" then
					self:_assign_group_to_retire(group)
				end
			end

			reenforce_tasks[i_task] = reenforce_tasks[#reenforce_tasks]

			table.remove(reenforce_tasks)
		end
	end

	self:_assign_enemy_groups_to_reenforce()
end

function GroupAIStateBesiege:_reenforce_area(task_data)
	local t = self._t

	if next(self._spawning_groups) then
		return
	end

	local allowed_groups = self:_get_spawn_groups("reenforce")
	local spawn_group, group_nationality, spawn_group_type = self:_find_spawn_group_near_area(task_data.target_area, allowed_groups, nil, nil, nil)

	if spawn_group then
		local grp_objective = {
			area = spawn_group.area,
			attitude = "avoid",
			pose = "stand",
			scan = true,
			stance = "hos",
			target_area = task_data.target_area,
			type = "reenforce_area",
		}
		local group = self:_spawn_in_group(spawn_group, group_nationality, spawn_group_type, grp_objective, nil)

		if group then
			group.task = "reenforce"
		end

		self._task_data.reenforce.next_dispatch_t = t + self:get_difficulty_dependent_value(self._tweak_data.reenforce.interval)
	end
end

function GroupAIStateBesiege:_retreat_from_area(task_data, force_required)
	local force_defending = 0

	for group_id, group in pairs(self._groups) do
		if group.objective.area == task_data.target_area and group.objective.type == "reenforce_area" then
			force_defending = force_defending + (group.has_spawned and group.size or group.initial_size)
		end
	end

	local force_extra = force_defending - force_required

	if force_extra > 0 then
		local closest_group, closest_group_size

		for group_id, group in pairs(self._groups) do
			if group.has_spawned and (group.objective.target_area or group.objective.area) == task_data.target_area and group.objective.type == "reenforce_area" and (not closest_group_size or closest_group_size < group.size) and force_extra >= group.size then
				closest_group = group
				closest_group_size = group.size
			end
		end

		if closest_group then
			self:_assign_group_to_retire(closest_group)
		end
	end
end

function GroupAIStateBesiege:register_criminal(unit)
	GroupAIStateBesiege.super.register_criminal(self, unit)

	if not Network:is_server() then
		return
	end

	local u_key = unit:key()
	local record = self._criminals[u_key]
	local area_data = self:get_area_from_nav_seg_id(record.seg)

	area_data.criminal.units[u_key] = record
	area_data.criminal.amount = area_data.criminal.amount + 1
end

function GroupAIStateBesiege:unregister_criminal(unit)
	if Network:is_server() then
		local u_key = unit:key()
		local record = self._criminals[u_key]

		if record then
			for area_id, area in pairs(self._area_data) do
				if area.nav_segs[record.seg] then
					area.criminal.units[u_key] = nil
					area.criminal.amount = math.max(area.criminal.amount - 1, 0)
				end
			end
		else
			Application:error("[GroupAIStateBesiege:unregister_criminal] Missing criminal record for u_key", u_key, "in", inspect(self._criminals))
		end
	end

	GroupAIStateBesiege.super.unregister_criminal(self, unit)
end

function GroupAIStateBesiege:on_objective_complete(unit, objective)
	local new_objective, so_element

	if objective.followup_objective then
		if not objective.followup_objective.trigger_on then
			new_objective = objective.followup_objective
		else
			new_objective = {
				followup_objective = objective.followup_objective,
				interrupt_dis = objective.interrupt_dis,
				interrupt_health = objective.interrupt_health,
				type = "free",
			}
		end
	elseif objective.followup_SO then
		local current_SO_element = objective.followup_SO

		so_element = current_SO_element:choose_followup_SO(unit)
		new_objective = so_element and so_element:get_objective(unit)
	end

	if new_objective then
		if new_objective.nav_seg then
			local u_key = unit:key()
			local u_data = self._police[u_key]

			if u_data and u_data.assigned_area then
				self:set_enemy_assigned(self._area_data[new_objective.nav_seg], u_key)
			end
		end
	else
		local seg = unit:movement():nav_tracker():nav_segment()
		local area_data = self:get_area_from_nav_seg_id(seg)

		if not new_objective and objective.type == "free" then
			new_objective = {
				attitude = objective.attitude,
				is_default = true,
				type = "free",
			}
		end

		if not area_data.is_safe then
			area_data.is_safe = true

			self:_on_nav_seg_safety_status(seg, {
				reason = "guard",
				unit = unit,
			})
		end
	end

	objective.fail_clbk = nil

	unit:brain():set_objective(new_objective)

	if objective.complete_clbk then
		objective.complete_clbk(unit)
	end

	if so_element then
		so_element:clbk_objective_administered(unit)
	end
end

function GroupAIStateBesiege:on_defend_travel_end(unit, objective)
	local seg = objective.nav_seg
	local area = self:get_area_from_nav_seg_id(seg)

	if not area.is_safe then
		area.is_safe = true

		self:_on_area_safety_status(area, {
			reason = "guard",
			unit = unit,
		})
	end
end

function GroupAIStateBesiege:on_cop_jobless(unit)
	local u_key = unit:key()

	if not self._police[u_key].assigned_area then
		return nil
	end

	local jobless = false
	local nav_seg = unit:movement():nav_tracker():nav_segment()
	local area = self:get_area_from_nav_seg_id(nav_seg)
	local force_factor = area.factors.reenforce
	local force_demand = force_factor and force_factor.amount
	local nr_police = area.police.amount
	local undershot = force_demand and force_demand - nr_police
	local new_objective

	if undershot and undershot > 0 then
		new_objective = {
			attitude = "avoid",
			in_place = true,
			interrupt_dis = 700,
			interrupt_health = 0.5,
			is_default = true,
			nav_seg = nav_seg,
			scan = true,
			stance = "hos",
			type = "defend_area",
		}
		jobless = true
	elseif not area.is_safe then
		new_objective = {
			attitude = "avoid",
			in_place = true,
			is_default = true,
			nav_seg = nav_seg,
			scan = true,
			stance = "hos",
			type = "free",
		}
		jobless = true
	end

	if not jobless and new_objective then
		self:set_enemy_assigned(self._area_data[nav_seg], u_key)
		unit:brain():set_objective(new_objective)
	end

	return jobless
end

function GroupAIStateBesiege:_animate_health_change(bar, final_color)
	local starting_color = Color.red
	local curr_color = starting_color
	local l = 0.35
	local t = 0

	while t < l do
		local dt = coroutine.yield()

		t = t + dt

		local new_r = self:_ease_in_quart(t, starting_color.r, final_color.r, l)
		local new_g = self:_ease_in_quart(t, starting_color.g, final_color.g, l)
		local new_b = self:_ease_in_quart(t, starting_color.b, final_color.b, l)

		bar:set_color(Color(new_r, new_g, new_b))
	end

	bar:set_color(final_color)
end

function GroupAIStateBesiege:_ease_in_quart(t, starting_value, change, duration)
	t = t / duration

	return change * t * t * t * t + starting_value
end

function GroupAIStateBesiege:_draw_enemy_activity(t)
	local camera = managers.viewport:get_current_camera()

	if not camera then
		return
	end

	local the_width = 130
	local bar_height = 6
	local area_normal = -math.UP
	local draw_data = self._AI_draw_data
	local brush_area = draw_data.brush_area
	local logic_name_texts = draw_data.logic_name_texts
	local unit_type_texts = draw_data.unit_type_texts
	local unit_health_bars_bg = draw_data.unit_health_bars_bg
	local unit_health_bars = draw_data.unit_health_bars
	local unit_health_bar_prevs = draw_data.unit_health_bar_prevs
	local unit_health_bar_vals = draw_data.unit_health_bar_vals
	local rect_bgs = draw_data.rect_bgs
	local rect_bg_width = 0
	local group_id_texts = draw_data.group_id_texts
	local panel = draw_data.panel
	local ws = draw_data.workspace
	local mid_pos1 = Vector3()
	local mid_pos2 = Vector3()
	local focus_enemy_pen = draw_data.pen_focus_enemy
	local focus_player_brush = draw_data.brush_focus_player
	local suppr_period = 0.4
	local suppr_t = t % suppr_period

	if suppr_t > suppr_period * 0.5 then
		suppr_t = suppr_period - suppr_t
	end

	draw_data.brush_suppressed:set_color(Color(math.lerp(0.2, 0.5, suppr_t), 0.85, 0.9, 0.2))

	for area_id, area in pairs(self._area_data) do
		if area.police.amount > 0 then
			brush_area:half_sphere(area.pos, 22, area_normal)
		end
	end

	local function _f_draw_unit_type(u_key, l_data, draw_color, offset_head_pos_screen)
		local unit_type_text = unit_type_texts[u_key]
		local text_str = tostring(l_data.unit:model_filename())
		local path_parts = string.split(text_str, "/")

		text_str = path_parts[#path_parts]

		if unit_type_text then
			unit_type_text:set_text("../" .. text_str)

			local x, y, w, h = unit_type_text:text_rect()

			if w > rect_bg_width then
				rect_bg_width = w
			end
		else
			unit_type_text = panel:text({
				color = Color(0.47058823529411764, 0.8509803921568627, 0.30196078431372547),
				font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.lato, 16),
				font_size = 16,
				layer = 1,
				name = "unit_type_text",
				text = text_str,
			})
			unit_type_texts[u_key] = unit_type_text

			local x, y, w, h = unit_type_text:text_rect()

			if w > rect_bg_width then
				rect_bg_width = w
			end
		end

		local my_head_pos = mid_pos1

		mvector3.set(my_head_pos, l_data.unit:movement():m_head_pos())
		mvector3.set_z(my_head_pos, my_head_pos.z + offset_head_pos_screen)

		local my_head_pos_screen = camera:world_to_screen(my_head_pos)

		if my_head_pos_screen.z > 0 then
			local screen_x = (my_head_pos_screen.x + 1) * 0.5 * RenderSettings.resolution.x
			local screen_y = (my_head_pos_screen.y + 1) * 0.5 * RenderSettings.resolution.y

			unit_type_text:set_x(screen_x)
			unit_type_text:set_y(screen_y - 33)

			if not unit_type_text:visible() then
				unit_type_text:show()
			end
		elseif unit_type_text:visible() then
			unit_type_text:hide()
		end
	end

	local function _f_draw_unit_health(u_key, l_data, draw_color, offset_head_pos_screen)
		local unit_health_bar_bg = unit_health_bars_bg[u_key]
		local unit_health_bar_prev = unit_health_bar_prevs[u_key]
		local unit_health_bar = unit_health_bars[u_key]
		local unit_health_bar_val = unit_health_bar_vals[u_key]
		local current_health = tostring(l_data.unit:character_damage():health_ratio())
		local current_health_raw_value, current_health_ini_value

		if l_data.unit:character_damage().health ~= nil then
			current_health_raw_value = tostring(string.format("%.2f", l_data.unit:character_damage():health()))
			current_health_ini_value = tostring(string.format("%.2f", l_data.unit:character_damage():health_init()))
		else
			current_health_raw_value = string.format("%.2f", current_health)
			current_health_ini_value = "?"
		end

		if unit_health_bar then
			local current_w = the_width * current_health

			if unit_health_bar:w() ~= current_w then
				unit_health_bar:stop()
				unit_health_bar:animate(callback(self, self, "_animate_health_change"), Color(0.47058823529411764, 0.8509803921568627, 0.30196078431372547))
				unit_health_bar_val:animate(callback(self, self, "_animate_health_change"), Color(0.47058823529411764, 0.8509803921568627, 0.30196078431372547))
				unit_health_bar_prev:set_w(unit_health_bar:w())
			end

			unit_health_bar:set_w(the_width * current_health)
			unit_health_bar_val:set_text(tostring(current_health_raw_value) .. "/" .. tostring(current_health_ini_value))

			local x, y, w, h = unit_health_bar_val:text_rect()

			if unit_health_bar_bg:w() + w + 7 > rect_bg_width then
				rect_bg_width = unit_health_bar_bg:w() + w + 7
			end
		else
			unit_health_bar_bg = panel:rect({
				blend_mode = "normal",
				color = Color.black:with_alpha(0.64),
				h = bar_height,
				layer = 1,
				name = "unit_health_bar_bg",
				w = the_width * current_health,
			})
			unit_health_bar_prev = panel:rect({
				blend_mode = "normal",
				color = Color(0.39215686274509803, 0.058823529411764705, 0.058823529411764705),
				h = bar_height,
				layer = 1,
				name = "unit_health_bar_prev",
				w = the_width * current_health,
			})
			unit_health_bar = panel:rect({
				blend_mode = "normal",
				color = Color(0.47058823529411764, 0.8509803921568627, 0.30196078431372547),
				h = bar_height,
				layer = 1,
				name = "unit_health_bar",
				w = the_width * current_health,
			})
			unit_health_bar_val = panel:text({
				color = Color(0.47058823529411764, 0.8509803921568627, 0.30196078431372547),
				font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.lato, 16),
				font_size = 16,
				layer = 1,
				name = "unit_health_value",
				text = tostring(current_health_raw_value),
			})
			unit_health_bar_vals[u_key] = unit_health_bar_val
			unit_health_bars_bg[u_key] = unit_health_bar_bg
			unit_health_bars[u_key] = unit_health_bar
			unit_health_bar_prevs[u_key] = unit_health_bar_prev

			local x, y, w, h = unit_health_bar_val:text_rect()

			if unit_health_bar_bg:w() + w > rect_bg_width then
				rect_bg_width = unit_health_bar_bg:w() + w
			end
		end

		local my_head_pos = mid_pos1

		mvector3.set(my_head_pos, l_data.unit:movement():m_head_pos())
		mvector3.set_z(my_head_pos, my_head_pos.z + offset_head_pos_screen)

		local my_head_pos_screen = camera:world_to_screen(my_head_pos)

		if my_head_pos_screen.z > 0 then
			local screen_x = (my_head_pos_screen.x + 1) * 0.5 * RenderSettings.resolution.x
			local screen_y = (my_head_pos_screen.y + 1) * 0.5 * RenderSettings.resolution.y

			screen_y = screen_y - 8

			unit_health_bar_bg:set_x(screen_x)
			unit_health_bar_bg:set_y(screen_y)
			unit_health_bar_prev:set_x(screen_x)
			unit_health_bar_prev:set_y(screen_y)
			unit_health_bar:set_x(screen_x)
			unit_health_bar:set_y(screen_y)
			unit_health_bar_val:set_x(screen_x + unit_health_bar_bg:w() + 2)
			unit_health_bar_val:set_y(screen_y - 8)

			if not unit_health_bar:visible() then
				unit_health_bar_bg:show()
				unit_health_bar_prev:show()
				unit_health_bar:show()
				unit_health_bar_val:show()
			end
		elseif unit_health_bar:visible() then
			unit_health_bar_bg:hide()
			unit_health_bar_prev:hide()
			unit_health_bar:hide()
			unit_health_bar_val:hide()
		end
	end

	local function _f_draw_logic_name(u_key, l_data, draw_color, offset_head_pos_screen)
		local logic_name_text = logic_name_texts[u_key]
		local text_str = l_data.name

		if l_data.objective and l_data.objective.type then
			text_str = text_str .. ": " .. l_data.objective.type
		end

		if not l_data.group then
			text_str = l_data.team.id .. ": " .. text_str
		end

		if l_data.internal_data.vision then
			text_str = text_str .. ": " .. l_data.internal_data.vision.name .. " (vis)"
		end

		do
			local extra_txt = ""

			if l_data.objective then
				local f_u = l_data.objective.follow_unit

				if f_u then
					local name
					local follow_type = l_data.objective.deathguard and "Deathguard" or "Follow"

					if f_u:base() and f_u:base().nick_name then
						name = f_u:base():nick_name()
					else
						local path_parts = string.split(tostring(l_data.objective.follow_unit:model_filename()), "/")

						name = path_parts[#path_parts]
					end

					extra_txt = extra_txt .. "\n" .. follow_type .. ": " .. tostring(name)
				end
			end

			if l_data.objective and l_data.objective.area then
				extra_txt = extra_txt .. "\nObjArea is " .. (l_data.objective.area.is_safe and "SAFE" or "UNSAFE")
			end

			if l_data.group and l_data.group.units then
				extra_txt = extra_txt .. "\nTeam Size: " .. tostring(table.size(l_data.group.units))

				if l_data.group.casualties and l_data.group.casualties > 0 then
					extra_txt = extra_txt .. " (" .. tostring(l_data.group.casualties) .. " Casualties)"
				end

				local highest_ranking_u_key, highest_ranking_u_data = self._determine_group_leader(l_data.group.units)

				if highest_ranking_u_key and highest_ranking_u_data then
					extra_txt = extra_txt .. "\nRank: " .. tostring(highest_ranking_u_key == u_key and "Lead" or "Goon") .. " Lv " .. tostring(l_data.rank) .. "/" .. tostring(highest_ranking_u_data.rank)
				else
					extra_txt = extra_txt .. "\nRank: " .. tostring(l_data.rank)
				end
			end

			if extra_txt ~= "" then
				text_str = text_str .. "\n ~-~-~-~-~-~ EXTRA ~-~-~-~-~-~" .. extra_txt
			end
		end

		if logic_name_text then
			logic_name_text:set_text(text_str)

			local x, y, w, h = logic_name_text:text_rect()

			if w > rect_bg_width then
				rect_bg_width = w
			end
		else
			logic_name_text = panel:text({
				color = draw_color,
				font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.lato, 16),
				font_size = 16,
				layer = 1,
				name = "text",
				text = text_str,
			})
			logic_name_texts[u_key] = logic_name_text

			local x, y, w, h = logic_name_text:text_rect()

			if w > rect_bg_width then
				rect_bg_width = w
			end
		end

		local my_head_pos = mid_pos1

		mvector3.set(my_head_pos, l_data.unit:movement():m_head_pos())
		mvector3.set_z(my_head_pos, my_head_pos.z + offset_head_pos_screen)

		local my_head_pos_screen = camera:world_to_screen(my_head_pos)

		if my_head_pos_screen.z > 0 then
			local screen_x = (my_head_pos_screen.x + 1) * 0.5 * RenderSettings.resolution.x
			local screen_y = (my_head_pos_screen.y + 1) * 0.5 * RenderSettings.resolution.y

			logic_name_text:set_x(screen_x)
			logic_name_text:set_y(screen_y)

			if not logic_name_text:visible() then
				logic_name_text:show()
			end
		elseif logic_name_text:visible() then
			logic_name_text:hide()
		end
	end

	local function _f_draw_rect_bg(u_key, l_data, draw_color, offset_head_pos_screen)
		local rect_bg = rect_bgs[u_key]

		if not rect_bg then
			rect_bg = panel:rect({
				blend_mode = "normal",
				color = Color.black:with_alpha(0.5),
				h = 54,
				layer = 0,
				name = "rect_bg",
				w = rect_bg_width + 10,
			})
			rect_bgs[u_key] = rect_bg
		elseif rect_bg:w() ~= rect_bg_width + 10 then
			rect_bg:set_w(rect_bg_width + 10)
		end

		local my_head_pos = mid_pos1

		mvector3.set(my_head_pos, l_data.unit:movement():m_head_pos())
		mvector3.set_z(my_head_pos, my_head_pos.z + offset_head_pos_screen)

		local my_head_pos_screen = camera:world_to_screen(my_head_pos)

		if my_head_pos_screen.z > 0 then
			local screen_x = (my_head_pos_screen.x + 1) * 0.5 * RenderSettings.resolution.x
			local screen_y = (my_head_pos_screen.y + 1) * 0.5 * RenderSettings.resolution.y

			rect_bg:set_x(screen_x - 5)
			rect_bg:set_y(screen_y - 32)

			local logic_name_text = logic_name_texts[u_key]
			local _, y, _, h = logic_name_text:text_rect()

			rect_bg:set_h(40 + h)

			if not rect_bg:visible() then
				rect_bg:show()
			end
		elseif rect_bg:visible() then
			rect_bg:hide()
		end
	end

	local function _f_draw_obj_pos(unit)
		local brush
		local objective = unit:brain():objective()
		local objective_type = objective and objective.type

		if objective_type == "guard" then
			brush = draw_data.brush_guard
		elseif objective_type == "defend_area" then
			brush = draw_data.brush_defend
		elseif objective_type == "free" or objective_type == "follow" or objective_type == "surrender" then
			brush = draw_data.brush_free
		elseif objective_type == "act" then
			brush = draw_data.brush_act
		else
			brush = draw_data.brush_misc
		end

		local obj_pos, obj_path

		if objective then
			if objective.pos then
				obj_pos = objective.pos
			elseif objective.follow_unit then
				obj_pos = objective.follow_unit:movement():m_head_pos()

				if objective.follow_unit:base().is_local_player then
					obj_pos = obj_pos + math.UP * -30
				end
			elseif objective.path_data then
				obj_path = objective.path_data
			elseif objective.nav_seg then
				obj_pos = managers.navigation._nav_segments[objective.nav_seg].pos
			elseif objective.area then
				obj_pos = objective.area.pos
			end
		end

		if obj_path then
			local previous_pos = unit:movement():m_com()
			local start_segment = unit:movement():nav_tracker():nav_segment()
			local draw = false

			for _, segment in ipairs(obj_path) do
				if draw then
					local segment_pos = managers.navigation._nav_segments[segment[1]].pos

					brush:cylinder(previous_pos, segment_pos, 4, 3)

					previous_pos = segment_pos
				end

				if segment[1] == start_segment then
					draw = true
				end
			end

			brush:sphere(previous_pos, 24)
		elseif obj_pos then
			local u_pos = unit:movement():m_com()

			brush:cylinder(u_pos, obj_pos, 4, 3)
			brush:sphere(u_pos, 24)
		end

		if unit:brain()._logic_data.is_suppressed then
			mvector3.set(mid_pos1, unit:movement():m_pos())
			mvector3.set_z(mid_pos1, mid_pos1.z + 220)
			draw_data.brush_suppressed:cylinder(unit:movement():m_pos(), mid_pos1, 35)
		end
	end

	local group_center = Vector3()

	for group_id, group in pairs(self._groups) do
		local nr_units = 0

		for u_key, u_data in pairs(group.units) do
			nr_units = nr_units + 1

			mvector3.add(group_center, u_data.unit:movement():m_com())
		end

		if nr_units > 0 then
			mvector3.divide(group_center, nr_units)

			local gui_text = group_id_texts[group_id]
			local group_pos_screen = camera:world_to_screen(group_center)

			if group_pos_screen.z > 0 then
				if not gui_text then
					gui_text = panel:text({
						color = draw_data.group_id_color,
						font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.lato, 24),
						font_size = 24,
						layer = 2,
						name = "text",
						text = group.team.id .. ": " .. group_id .. ": " .. group.objective.type,
					})
					group_id_texts[group_id] = gui_text
				end

				local screen_x = (group_pos_screen.x + 1) * 0.5 * RenderSettings.resolution.x
				local screen_y = (group_pos_screen.y + 1) * 0.5 * RenderSettings.resolution.y

				gui_text:set_x(screen_x)
				gui_text:set_y(screen_y)

				if not gui_text:visible() then
					gui_text:show()
				end
			elseif gui_text and gui_text:visible() then
				gui_text:hide()
			end

			for u_key, u_data in pairs(group.units) do
				draw_data.pen_group:line(group_center, u_data.unit:movement():m_com())
			end
		end

		mvector3.set_zero(group_center)
	end

	local function _f_draw_attention_on_player(l_data)
		if l_data.attention_obj then
			local my_head_pos = l_data.unit:movement():m_head_pos()
			local e_pos = l_data.attention_obj.m_head_pos
			local dis = mvector3.distance(my_head_pos, e_pos)

			mvector3.step(mid_pos2, my_head_pos, e_pos, 300)
			mvector3.lerp(mid_pos1, my_head_pos, mid_pos2, t % 0.5)
			mvector3.step(mid_pos2, mid_pos1, e_pos, 50)
			focus_enemy_pen:line(mid_pos1, mid_pos2)

			if l_data.attention_obj.unit:base() and l_data.attention_obj.unit:base().is_local_player then
				focus_player_brush:sphere(my_head_pos, 20)
			end
		end
	end

	local function _f_draw_ai_vision(data)
		local my_data = data.internal_data

		if not my_data.vision then
			return
		end

		local brush_c1 = self._AI_draw_data.brush_ai_vision_c1
		local brush_c2 = self._AI_draw_data.brush_ai_vision_c2
		local brush_c3 = self._AI_draw_data.brush_ai_vision_c3
		local temp_rotation = Rotation()
		local draw_pos = data.unit:movement():m_head_pos()

		mrotation.set_yaw_pitch_roll(temp_rotation, data.unit:movement():m_head_rot():yaw(), 0, 0)

		local direction = temp_rotation:y()

		mvector3.normalize(direction)

		local rad_1 = math.sin(my_data.vision.cone_1.angle / 2) * my_data.vision.cone_1.distance
		local rad_2 = math.sin(my_data.vision.cone_2.angle / 2) * my_data.vision.cone_2.distance
		local rad_3 = math.sin(my_data.vision.cone_3.angle / 2) * my_data.vision.cone_3.distance
		local dist_1 = math.cos(my_data.vision.cone_1.angle / 2) * my_data.vision.cone_1.distance
		local dist_2 = math.cos(my_data.vision.cone_2.angle / 2) * my_data.vision.cone_2.distance
		local dist_3 = math.cos(my_data.vision.cone_3.angle / 2) * my_data.vision.cone_3.distance

		if my_data.vision.cone_1.angle >= 180 then
			brush_c1:half_sphere(draw_pos, my_data.vision.cone_1.distance, temp_rotation:y())
		else
			brush_c1:cone(draw_pos, draw_pos + direction * -dist_1, rad_1, 100)
			brush_c1:half_sphere(draw_pos + direction * -dist_1, rad_1, temp_rotation:y(), 4)
		end

		if my_data.vision.cone_2.angle >= 180 then
			brush_c2:half_sphere(draw_pos, my_data.vision.cone_2.distance, temp_rotation:y())
		else
			brush_c2:cone(draw_pos, draw_pos + direction * -dist_2, rad_2, 100)
			brush_c2:half_sphere(draw_pos + direction * -dist_2, rad_2, temp_rotation:y(), 4)
		end

		if my_data.vision.cone_3.angle >= 180 then
			brush_c3:half_sphere(draw_pos, my_data.vision.cone_3.distance, temp_rotation:y())
		else
			brush_c3:cone(draw_pos, draw_pos + direction * -dist_3, rad_3, 100)
			brush_c3:half_sphere(draw_pos + direction * -dist_3, rad_3, temp_rotation:y(), 4)
		end
	end

	local groups = {
		{
			color = Color(1, 1, 0, 0),
			group = self._police,
		},
		{
			color = Color(1, 0.75, 0.75, 0.75),
			group = managers.enemy:all_civilians(),
		},
		{
			color = Color(1, 0, 1, 0),
			group = self._ai_criminals,
		},
	}
	local selected_unit = World:selected_unit()

	for _, group_data in ipairs(groups) do
		for u_key, u_data in pairs(group_data.group) do
			if not selected_unit or selected_unit == u_data.unit then
				_f_draw_obj_pos(u_data.unit)

				if camera then
					local l_data = u_data.unit:brain()._logic_data

					rect_bg_width = 0

					local offset_head_pos_screen = -116

					_f_draw_unit_type(u_key, l_data, group_data.color, offset_head_pos_screen)
					_f_draw_unit_health(u_key, l_data, group_data.color, offset_head_pos_screen)
					_f_draw_logic_name(u_key, l_data, group_data.color, offset_head_pos_screen)
					_f_draw_rect_bg(u_key, l_data, group_data.color, offset_head_pos_screen)
					_f_draw_attention_on_player(l_data)

					if World:selected_unit() == u_data.unit then
						_f_draw_ai_vision(l_data)
					end
				end
			end
		end
	end

	for u_key, gui_text in pairs(unit_type_texts or {}) do
		local keep

		for _, group_data in ipairs(groups) do
			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_text)

			unit_type_texts[u_key] = nil
		end
	end

	for u_key, gui_text in pairs(logic_name_texts or {}) do
		local keep

		for _, group_data in ipairs(groups) do
			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_text)

			logic_name_texts[u_key] = nil
		end
	end

	for u_key, gui_bar in pairs(unit_health_bars or {}) do
		local keep

		for _, group_data in ipairs(groups) do
			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_bar)

			unit_health_bars[u_key] = nil
		end
	end

	for u_key, gui_bar in pairs(unit_health_bar_prevs or {}) do
		local keep

		for _, group_data in ipairs(groups) do
			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_bar)

			unit_health_bar_prevs[u_key] = nil
		end
	end

	for u_key, gui_bar in pairs(unit_health_bars_bg or {}) do
		local keep

		for _, group_data in ipairs(groups) do
			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_bar)

			unit_health_bars_bg[u_key] = nil
		end
	end

	for u_key, gui_text in pairs(unit_health_bar_vals) do
		local keep

		for _, group_data in ipairs(groups) do
			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_text)

			unit_health_bar_vals[u_key] = nil
		end
	end

	for u_key, gui_rect in pairs(rect_bgs) do
		local keep

		for _, group_data in ipairs(groups) do
			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_rect)

			rect_bgs[u_key] = nil
		end
	end

	for group_id, gui_text in pairs(group_id_texts) do
		if not self._groups[group_id] then
			panel:remove(gui_text)

			group_id_texts[group_id] = nil
		end
	end
end

function GroupAIStateBesiege:filter_nav_seg_unsafe(nav_seg)
	return not self:is_nav_seg_safe(nav_seg)
end

function GroupAIStateBesiege:_on_nav_seg_safety_status(seg, event)
	local area = self:get_area_from_nav_seg_id(seg)

	self:_on_area_safety_status(area, event)
end

function GroupAIStateBesiege:add_flee_point(id, pos, so_action)
	local nav_seg = managers.navigation:get_nav_seg_from_pos(pos, true)
	local area = self:get_area_from_nav_seg_id(nav_seg)
	local flee_point = {
		area = area,
		nav_seg = nav_seg,
		pos = pos,
		so_action = so_action,
	}

	self._flee_points[id] = flee_point
	area.flee_points = area.flee_points or {}
	area.flee_points[id] = flee_point
end

function GroupAIStateBesiege:remove_flee_point(id)
	local flee_point = self._flee_points[id]

	if not flee_point then
		return
	end

	self._flee_points[id] = nil

	local area = flee_point.area

	area.flee_points[id] = nil

	if not next(area.flee_points) then
		area.flee_points = nil
	end
end

function GroupAIStateBesiege:flee_point(start_nav_seg)
	local start_area = self:get_area_from_nav_seg_id(start_nav_seg)
	local to_search_areas = {
		start_area,
	}
	local found_areas = {
		[start_area] = true,
	}

	repeat
		local search_area = table.remove(to_search_areas, 1)

		if search_area.flee_points and next(search_area.flee_points) then
			local flee_point_id, flee_point = next(search_area.flee_points)

			return flee_point.pos
		else
			for other_area_id, other_area in pairs(search_area.neighbours) do
				if not found_areas[other_area] then
					table.insert(to_search_areas, other_area)

					found_areas[other_area] = true
				end
			end
		end
	until #to_search_areas == 0
end

function GroupAIStateBesiege:safe_flee_point(start_nav_seg)
	local start_area = self:get_area_from_nav_seg_id(start_nav_seg)

	if start_area.criminal.amount > 0 then
		return
	end

	local to_search_areas = {
		start_area,
	}
	local found_areas = {
		[start_area] = true,
	}

	repeat
		local search_area = table.remove(to_search_areas, 1)

		if search_area.flee_points and next(search_area.flee_points) then
			local flee_point_id, flee_point = next(search_area.flee_points)

			return flee_point
		end

		for other_area_id, other_area in pairs(search_area.neighbours) do
			if not found_areas[other_area] and not (other_area.criminal.amount > 0) then
				table.insert(to_search_areas, other_area)

				found_areas[other_area] = true
			end
		end
	until #to_search_areas == 0
end

function GroupAIStateBesiege:add_enemy_loot_drop_point(id, pos)
	local nav_seg = managers.navigation:get_nav_seg_from_pos(pos, true)
	local area = self:get_area_from_nav_seg_id(nav_seg)
	local drop_point = {
		area = area,
		nav_seg = nav_seg,
		pos = pos,
	}

	self._enemy_loot_drop_points[id] = drop_point
	area.enemy_loot_drop_points = area.enemy_loot_drop_points or {}
	area.enemy_loot_drop_points[id] = drop_point
end

function GroupAIStateBesiege:remove_enemy_loot_drop_point(id)
	local drop_point = self._enemy_loot_drop_points[id]

	if not drop_point then
		return
	end

	self._enemy_loot_drop_points[id] = nil

	local area = drop_point.area

	area.enemy_loot_drop_points[id] = nil

	if not next(area.enemy_loot_drop_points) then
		area.enemy_loot_drop_points = nil
	end
end

function GroupAIStateBesiege:get_safe_enemy_loot_drop_point(start_nav_seg)
	local start_area = self:get_area_from_nav_seg_id(start_nav_seg)

	if start_area.criminal.amount > 0 then
		return
	end

	local to_search_areas = {
		start_area,
	}
	local found_areas = {
		[start_area] = true,
	}

	repeat
		local search_area = table.remove(to_search_areas, 1)

		if search_area.enemy_loot_drop_points and next(search_area.enemy_loot_drop_points) then
			local nr_drop_points = table.size(search_area.enemy_loot_drop_points)
			local lucky_drop_point = math.random(nr_drop_points)

			for drop_point_id, drop_point in pairs(search_area.enemy_loot_drop_points) do
				lucky_drop_point = lucky_drop_point - 1

				if lucky_drop_point == 0 then
					return drop_point
				end
			end
		else
			for other_area_id, other_area in pairs(search_area.neighbours) do
				if not found_areas[other_area] and not (other_area.criminal.amount > 0) then
					table.insert(to_search_areas, other_area)

					found_areas[other_area] = true
				end
			end
		end
	until #to_search_areas == 0
end

function GroupAIStateBesiege:_draw_spawn_points()
	local all_areas = self._area_data
	local tmp_vec3 = Vector3()

	for area_id, area_data in pairs(all_areas) do
		local area_spawn_points = area_data.spawn_points

		if area_spawn_points then
			for _, sp_data in ipairs(area_spawn_points) do
				Application:draw_sphere(sp_data.pos, 150, 0.1, 0.4, 0.6)
			end
		end

		local area_spawn_groups = area_data.spawn_groups

		if area_spawn_groups then
			for _, spawn_group in ipairs(area_spawn_groups) do
				mvector3.set(tmp_vec3, math.UP)
				mvector3.multiply(tmp_vec3, 2500)
				mvector3.add(tmp_vec3, spawn_group.pos)
				Application:draw_cylinder(spawn_group.pos, tmp_vec3, 150, 0.2, 0.1, 0.75)

				for _, sp_data in ipairs(spawn_group.spawn_pts) do
					mvector3.set(tmp_vec3, math.UP)
					mvector3.multiply(tmp_vec3, 200)
					mvector3.add(tmp_vec3, sp_data.pos)
					Application:draw_cylinder(sp_data.pos, tmp_vec3, 30, 0.1, 0.4, 0.6)
					Application:draw_cylinder(spawn_group.pos, sp_data.pos, 20, 0.2, 0.1, 0.75)
				end
			end
		end
	end
end

function GroupAIStateBesiege:set_area_reenforce(id, amount, pos)
	if amount then
		local nav_seg_id = managers.navigation:get_nav_seg_from_pos(pos, true)
		local area = self:get_area_from_nav_seg_id(nav_seg_id)
		local factors = area.factors

		factors.reenforce = {
			amount = amount,
			id = id,
		}
	else
		for area_id, area in pairs(self._area_data) do
			local force_factor = area.factors.reenforce

			if force_factor and force_factor.id == id then
				area.factors.reenforce = nil

				for group_id, group in pairs(self._groups) do
					if group.objective and group.objective.area and group.objective.area.id == area_id then
						self:_set_assault_objective_to_group(group, nil)
					end
				end

				return
			end
		end
	end
end

function GroupAIStateBesiege:set_wave_mode(flag)
	local old_wave_mode = self._wave_mode

	self._wave_mode = flag
	self._hunt_mode = nil

	if flag == "hunt" then
		self._hunt_mode = true
		self._wave_mode = "besiege"

		managers.hud:start_assault()
		self:set_assault_mode(true)
		self:_end_regroup_task()

		if self._task_data.assault.active then
			self._task_data.assault.phase = "sustain"

			managers.music:raid_music_state_change(MusicManager.RAID_MUSIC_ASSAULT)
		else
			self._task_data.assault.next_dispatch_t = self._t
		end
	elseif flag == "besiege" then
		if self._task_data.regroup.active then
			self._task_data.assault.next_dispatch_t = self._task_data.regroup.end_t
		elseif not self._task_data.assault.active then
			self._task_data.assault.next_dispatch_t = self._t
		end
	elseif flag == "quiet" then
		self._hunt_mode = nil
	else
		self._wave_mode = old_wave_mode

		debug_pause("[GroupAIStateBesiege:set_wave_mode] flag", flag, " does not apply to the current Group AI state.")
	end
end

function GroupAIStateBesiege:on_simulation_ended()
	GroupAIStateBesiege.super.on_simulation_ended(self)

	if managers.navigation:is_data_ready() then
		self:_create_area_data()

		self._task_data = {}
		self._task_data.reenforce = {
			next_dispatch_t = 0,
			tasks = {},
		}
		self._task_data.assault = {
			disabled = true,
			is_first = true,
		}
		self._task_data.regroup = {}
	end

	self._enemy_update_t = 0
end

function GroupAIStateBesiege:on_simulation_started()
	GroupAIStateBesiege.super.on_simulation_started(self)

	if managers.navigation:is_data_ready() then
		self:_create_area_data()

		self._task_data = {}
		self._task_data.reenforce = {
			next_dispatch_t = 0,
			tasks = {},
		}
		self._task_data.assault = {
			disabled = true,
			is_first = true,
		}
		self._task_data.regroup = {}
	end
end

function GroupAIStateBesiege:on_enemy_weapons_hot(is_delayed_callback)
	if not self._ai_enabled then
		return
	end

	if not self._enemy_weapons_hot then
		self._task_data.assault.disabled = nil
		self._task_data.assault.next_dispatch_t = self._t
	end

	GroupAIStateBesiege.super.on_enemy_weapons_hot(self, is_delayed_callback)
end

function GroupAIStateBesiege:is_detection_persistent()
	return self._task_data.assault.active
end

function GroupAIStateBesiege:_assign_enemy_groups_to_assault(phase)
	for group_id, group in pairs(self._groups) do
		if group.has_spawned and group.objective.type == "assault_area" then
			if group.objective.moving_out then
				local pass_amount = math.floor(group.size / 2)
				local done_moving = 0

				for u_key, u_data in pairs(group.units) do
					local unit = u_data.unit
					local objective = unit:brain():objective()

					if objective and objective.grp_objective == group.objective then
						local segment = unit:movement():nav_tracker():nav_segment()

						if objective.area and objective.area.nav_segs[segment] then
							done_moving = done_moving + 1
						end
					end
				end

				if pass_amount <= done_moving then
					group.objective.moving_out = nil
					group.in_place_t = self._t
					group.objective.moving_in = nil

					self:_voice_move_complete(group)
				end
			end

			if not group.objective.moving_in then
				self:_set_assault_objective_to_group(group, phase)
			end
		end
	end
end

function GroupAIStateBesiege:_is_group_waiting_push(group, charge)
	if not group or not group.in_place_t then
		return true
	end

	local base_delay = charge and self._tweak_data.assault.charge_delay or self._tweak_data.assault.push_delay
	local push_delay = self:_get_balancing_multiplier(base_delay)

	return push_delay > self._t - group.in_place_t
end

function GroupAIStateBesiege:_set_objective_to_enemy_group(group, grp_objective)
	group.objective = grp_objective

	if grp_objective.area then
		grp_objective.moving_out = true

		if not grp_objective.nav_seg and grp_objective.coarse_path then
			grp_objective.nav_seg = grp_objective.coarse_path[#grp_objective.coarse_path][1]
		end
	end

	grp_objective.assigned_t = self._t

	if self._AI_draw_data and self._AI_draw_data.group_id_texts[group.id] then
		self._AI_draw_data.panel:remove(self._AI_draw_data.group_id_texts[group.id])

		self._AI_draw_data.group_id_texts[group.id] = nil
	end
end

function GroupAIStateBesiege:_upd_groups()
	for group_id, group in pairs(self._groups) do
		self:_verify_group_objective(group)

		for u_key, u_data in pairs(group.units) do
			local nav_seg = u_data.tracker:nav_segment()
			local world_id = managers.navigation:get_world_for_nav_seg(nav_seg)
			local alarm = managers.worldcollection:get_alarm_for_world(world_id)

			if alarm then
				local brain = u_data.unit:brain()
				local current_objective = brain:objective()

				if (not current_objective or current_objective.is_default or current_objective.grp_objective and current_objective.grp_objective ~= group.objective and not current_objective.grp_objective.no_retry) and (not group.objective.follow_unit or alive(group.objective.follow_unit)) then
					local objective = self._create_objective_from_group_objective(group.objective, u_data.unit)

					if objective and brain:is_available_for_assignment(objective) then
						self:set_enemy_assigned(objective.area or group.objective.area, u_key)

						if objective.element then
							objective.element:clbk_objective_administered(u_data.unit)
						end

						u_data.unit:brain():set_objective(objective)
					end
				end
			end
		end
	end
end

function GroupAIStateBesiege:_set_assault_objective_to_group(group, phase)
	if not group.has_spawned then
		return
	end

	local phase_is_anticipation = phase == "anticipation"
	local current_objective = group.objective
	local _, group_leader_u_data = self._determine_group_leader(group.units)
	local tactics = group_leader_u_data and group_leader_u_data.tactics or {}

	if current_objective.tactic and not tactics[current_objective.tactic] then
		current_objective.tactic = nil
	end

	if tactics.deathguard and not phase_is_anticipation then
		local success = self:_assign_group_objective_deathguard(group, group_leader_u_data)

		if success then
			return
		end
	end

	local unsafe_area = self:_chk_group_areas_unsafe(group)
	local push, open_fire, pull_back, objective_area

	if phase_is_anticipation then
		if tactics.charge and not current_objective.moving_out then
			push = true
		elseif current_objective.open_fire then
			pull_back = true
		end
	elseif unsafe_area then
		if not current_objective.open_fire then
			open_fire = true
			objective_area = unsafe_area
		end
	elseif not current_objective.moving_out then
		local unsafe_seg_id = self:_chk_coarse_path_unsafe(group)

		if unsafe_seg_id then
			objective_area = self:get_area_from_nav_seg_id(unsafe_seg_id)
		end

		if tactics.attack_range and current_objective.open_fire then
			push = not self:_is_group_waiting_push(group)
		else
			push = true
		end
	end

	objective_area = objective_area or current_objective.area

	if open_fire then
		self:_assign_group_objective_open_fire(group, objective_area, tactics)
	elseif push then
		self:_assign_group_objective_push(group, objective_area, tactics)
	elseif pull_back then
		self:_assign_group_objective_pull_back(group, tactics)
	end
end

function GroupAIStateBesiege:_assign_group_objective_push(group, objective_area, tactics)
	local max_distance = self._tweak_data.max_distance_to_player
	local retarget_chance = self._tweak_data.assault.retarget_chance
	local current_objective = group.objective
	local to_search_areas = {
		objective_area,
	}
	local found_areas = {
		[objective_area.id] = objective_area,
	}
	local assault_area, assault_path

	repeat
		local search_area = table.remove(to_search_areas, 1)

		if not self:is_area_safe(search_area) then
			local is_objective_area = search_area == objective_area
			local can_retarget = tactics.retarget and not is_objective_area
			local current_area = current_objective.area
			local new_path = managers.navigation:search_coarse({
				access_pos = self._get_group_acces_mask(group),
				from_seg = current_area.pos_nav_seg,
				id = "GroupAI_approach",
				to_seg = search_area.pos_nav_seg,
				verify_clbk = callback(self, self, "is_nav_seg_safe"),
			})

			if new_path then
				self:_merge_coarse_path_by_area(new_path)

				assault_area = search_area
				assault_path = new_path
				can_retarget = can_retarget and max_distance > mvec3_dis(current_area.pos, assault_area.pos)

				if can_retarget and retarget_chance >= math.random() then
					Application:trace("[GroupAIStateBesiege:_set_assault_objective_to_group] new target aquired")

					found_areas[assault_area.id] = nil
					retarget_chance = retarget_chance * self._tweak_data.assault.retarget_chance_mul
				else
					break
				end
			end
		else
			for other_area_id, other_area in pairs(search_area.neighbours) do
				if not found_areas[other_area_id] then
					found_areas[other_area_id] = search_area

					table.insert(to_search_areas, other_area)
				end
			end
		end
	until #to_search_areas == 0

	if not assault_area or not assault_path then
		return
	end

	local charge = tactics.charge
	local push = not tactics.attack_range and #assault_path == 2

	if push then
		if self:_is_group_waiting_push(group, charge) then
			return
		end

		self:_voice_move_in_start(group)
	else
		table.remove(assault_path)

		local approach_area_id = assault_path[#assault_path][1]

		assault_area = self:get_area_from_nav_seg_id(approach_area_id)
	end

	local pose = not charge and push and "crouch" or "stand"

	self:_set_objective_to_enemy_group(group, {
		area = assault_area,
		attitude = push and "engage" or "avoid",
		charge = charge,
		coarse_path = assault_path,
		interrupt_dis = charge and 0,
		moving_in = push and true,
		open_fire = push,
		pose = pose,
		pushed = push,
		stance = "hos",
		type = "assault_area",
	})

	group.is_chasing = group.is_chasing or push
end

function GroupAIStateBesiege:_assign_group_objective_open_fire(group, objective_area, tactics)
	local current_objective = group.objective
	local assault_path = {
		{
			objective_area.pos_nav_seg,
			mvector3.copy(objective_area.pos),
		},
	}

	self:_set_objective_to_enemy_group(group, {
		area = objective_area,
		attitude = "engage",
		coarse_path = assault_path,
		open_fire = true,
		pose = "stand",
		stance = "hos",
		tactic = current_objective.tactic,
		type = "assault_area",
	})
	self:_voice_open_fire_start(group)
end

function GroupAIStateBesiege:_assign_group_objective_pull_back(group, tactics)
	local current_objective = group.objective
	local retreat_area

	for u_key, u_data in pairs(group.units) do
		local nav_seg_id = u_data.tracker:nav_segment()

		if current_objective.area.nav_segs[nav_seg_id] then
			retreat_area = current_objective.area

			break
		end

		if self:is_nav_seg_safe(nav_seg_id) then
			retreat_area = self:get_area_from_nav_seg_id(nav_seg_id)

			break
		end
	end

	if not retreat_area and current_objective.coarse_path then
		local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)

		if forwardmost_i_nav_point then
			local nearest_safe_nav_seg_id = current_objective.coarse_path(forwardmost_i_nav_point)

			retreat_area = self:get_area_from_nav_seg_id(nearest_safe_nav_seg_id)
		end
	end

	if retreat_area then
		group.is_chasing = nil

		self:_set_objective_to_enemy_group(group, {
			area = retreat_area,
			attitude = "avoid",
			coarse_path = {
				{
					retreat_area.pos_nav_seg,
					mvector3.copy(retreat_area.pos),
				},
			},
			pose = "crouch",
			stance = "hos",
			type = "assault_area",
		})
	end
end

function GroupAIStateBesiege:_assign_group_objective_deathguard(group, group_leader_u_data)
	local objective = group.objective

	if objective and objective.tactic == "deathguard" and alive(objective.follow_unit) then
		local u_key = objective.follow_unit:key()
		local u_data = self._char_criminals[u_key]

		if u_data and u_data.status and objective.area.nav_segs[u_data.seg] then
			return true
		end
	end

	local closest_crim_data
	local closest_crim_dis_sq = math.huge

	for u_key, u_data in pairs(self._char_criminals) do
		if u_data.status then
			local _, _, closest_u_dis_sq = self._get_closest_group_unit_to_pos(u_data.m_pos, group.units)

			if closest_u_dis_sq and closest_u_dis_sq < closest_crim_dis_sq then
				closest_crim_data = u_data
				closest_crim_dis_sq = closest_u_dis_sq
			end
		end
	end

	if not closest_crim_data or not alive(closest_crim_data.unit) then
		return false
	end

	for _, other_group in pairs(self._groups) do
		local other_objective = other_group.objective

		if other_objective.tactic == "deathguard" and other_objective.follow_unit == closest_crim_data.unit then
			return
		end
	end

	local coarse_path = managers.navigation:search_coarse({
		access_pos = self._get_group_acces_mask(group),
		from_tracker = group_leader_u_data.unit:movement():nav_tracker(),
		id = "GroupAI_deathguard",
		to_tracker = closest_crim_data.tracker,
	})

	if not coarse_path then
		return false
	end

	group.is_chasing = true

	self:_voice_deathguard_start(group)
	self:_set_objective_to_enemy_group(group, {
		area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
		attitude = "engage",
		coarse_path = coarse_path,
		distance = 800,
		follow_unit = closest_crim_data.unit,
		moving_in = true,
		tactic = "deathguard",
		type = "assault_area",
	})

	return true
end

function GroupAIStateBesiege._create_objective_from_group_objective(grp_objective, receiving_unit)
	local objective = {
		grp_objective = grp_objective,
	}

	if grp_objective.element then
		objective = grp_objective.element:get_random_SO(receiving_unit)

		if objective then
			objective.grp_objective = grp_objective
		end

		return
	elseif grp_objective.type == "defend_area" or grp_objective.type == "recon_area" or grp_objective.type == "reenforce_area" then
		objective.type = "defend_area"
		objective.stance = "hos"
		objective.pose = "crouch"
		objective.scan = true
		objective.interrupt_dis = 200
		objective.interrupt_suppression = true
	elseif grp_objective.type == "retire" then
		objective.type = "defend_area"
		objective.stance = "hos"
		objective.pose = "stand"
		objective.scan = true
		objective.interrupt_dis = 200
		objective.action = grp_objective.action
	elseif grp_objective.type == "assault_area" then
		objective.type = "defend_area"

		if grp_objective.follow_unit then
			objective.follow_unit = grp_objective.follow_unit
			objective.distance = grp_objective.distance
		end

		objective.stance = "hos"
		objective.pose = "stand"
		objective.scan = true
		objective.interrupt_dis = 200
		objective.interrupt_suppression = true
	elseif grp_objective.type == "create_phalanx" then
		objective.type = "phalanx"
		objective.stance = "hos"
		objective.interrupt_dis = nil
		objective.interrupt_health = nil
		objective.interrupt_suppression = nil
		objective.attitude = "avoid"
		objective.path_ahead = true
	elseif grp_objective.type == "hunt" then
		objective.type = "hunt"
		objective.stance = "hos"
		objective.scan = true
		objective.interrupt_dis = 200
	end

	objective.stance = grp_objective.stance or objective.stance
	objective.pose = grp_objective.pose or objective.pose
	objective.area = grp_objective.area
	objective.nav_seg = grp_objective.nav_seg or objective.area.pos_nav_seg
	objective.attitude = grp_objective.attitude or objective.attitude
	objective.interrupt_dis = grp_objective.interrupt_dis or objective.interrupt_dis
	objective.interrupt_health = grp_objective.interrupt_health or objective.interrupt_health
	objective.interrupt_suppression = grp_objective.interrupt_suppression or objective.interrupt_suppression
	objective.pos = grp_objective.pos

	if grp_objective.scan ~= nil then
		objective.scan = grp_objective.scan
	end

	if grp_objective.coarse_path then
		objective.path_style = "coarse_complete"
		objective.path_data = grp_objective.coarse_path
	end

	return objective
end

function GroupAIStateBesiege:_assign_groups_to_retire(allowed_groups, suitable_grp_func)
	for group_id, group in pairs(self._groups) do
		if not allowed_groups[group.type] and group.objective.type ~= "reenforce_area" and group.objective.type ~= "retire" then
			self:_assign_group_to_retire(group)
		elseif suitable_grp_func and allowed_groups[group.type] then
			suitable_grp_func(group)
		end
	end
end

function GroupAIStateBesiege:_assign_group_to_retire(group)
	local retire_area, retire_pos, retire_flee_point
	local to_search_areas = {
		group.objective.area,
	}
	local found_areas = {
		[group.objective.area] = true,
	}

	repeat
		local search_area = table.remove(to_search_areas, 1)

		if search_area.flee_points and next(search_area.flee_points) then
			retire_area = search_area

			local flee_point_id, flee_point = next(search_area.flee_points)

			retire_pos = flee_point.pos
			retire_flee_point = flee_point

			break
		else
			for other_area_id, other_area in pairs(search_area.neighbours) do
				if not found_areas[other_area] then
					table.insert(to_search_areas, other_area)

					found_areas[other_area] = true
				end
			end
		end
	until #to_search_areas == 0

	if not retire_area then
		Application:error("[GroupAIStateBesiege:_assign_group_to_retire] flee point not found. from area:", inspect(group.objective.area), "group ID:", group.id)

		return
	end

	local grp_objective = {
		area = retire_area or group.objective.area,
		coarse_path = {
			{
				retire_area.pos_nav_seg,
				retire_area.pos,
			},
		},
		pos = retire_pos,
		type = "retire",
	}

	if retire_flee_point and retire_flee_point.so_action and retire_flee_point.so_action ~= "none" then
		grp_objective.action = {
			align_sync = true,
			blocks = {
				act = 1,
				action = 1,
				aim = 1,
				heavy_hurt = -1,
				hurt = -1,
				idle = 1,
				light_hurt = -1,
				walk = 1,
			},
			body_part = 1,
			complete_callback = callback(self, self, "on_retire_action_complete"),
			needs_full_blend = true,
			type = "act",
			variant = retire_flee_point.so_action,
		}
	end

	self:_voice_retreat_start(group)
	self:_set_objective_to_enemy_group(group, grp_objective)
end

function GroupAIStateBesiege:on_retire_action_complete(unit)
	unit:brain():set_active(false)
	unit:base():set_slot(unit, 0)
end

function GroupAIStateBesiege._determine_group_leader(units)
	local highest_rank, highest_ranking_u_key, highest_ranking_u_data

	for u_key, u_data in pairs(units) do
		if u_data.rank and (not highest_rank or highest_rank < u_data.rank) then
			highest_rank = u_data.rank
			highest_ranking_u_key = u_key
			highest_ranking_u_data = u_data
		end
	end

	return highest_ranking_u_key, highest_ranking_u_data
end

function GroupAIStateBesiege._get_closest_group_unit_to_pos(pos, units)
	local closest_dis_sq, closest_u_key, closest_u_data

	for u_key, u_data in pairs(units) do
		local my_dis = mvec3_dis(pos, u_data.m_pos)

		if not closest_dis_sq or my_dis < closest_dis_sq then
			closest_dis_sq = my_dis
			closest_u_key = u_key
			closest_u_data = u_data
		end
	end

	return closest_u_key, closest_u_data, closest_dis_sq
end

function GroupAIStateBesiege:_assign_assault_groups_to_retire()
	local function suitable_grp_func(group)
		if group.objective.type == "assault_area" then
			local regroup_area

			if group.objective.area.criminal.amount > 0 then
				for other_area_id, other_area in pairs(group.objective.area.neighbours) do
					if other_area.criminal.amount == 0 then
						regroup_area = other_area

						break
					end
				end
			end

			regroup_area = regroup_area or group.objective.area

			local grp_objective = {
				area = regroup_area,
				attitude = "avoid",
				pose = "crouch",
				stance = "hos",
				type = "recon_area",
			}

			self:_set_objective_to_enemy_group(group, grp_objective)
		end
	end

	local allowed_groups = self:_get_spawn_groups("recon")

	self:_assign_groups_to_retire(allowed_groups, suitable_grp_func)
end

function GroupAIStateBesiege:_assign_recon_groups_to_retire()
	local function suitable_grp_func(group)
		if group.objective.type == "recon_area" then
			local grp_objective = {
				area = group.objective.area,
				attitude = "avoid",
				pose = "crouch",
				stance = "hos",
				type = "assault_area",
			}

			self:_set_objective_to_enemy_group(group, grp_objective)
		end
	end

	local allowed_groups = self:_get_spawn_groups("assault")

	self:_assign_groups_to_retire(allowed_groups, suitable_grp_func)
end

function GroupAIStateBesiege:_assign_enemy_groups_to_reenforce()
	for group_id, group in pairs(self._groups) do
		if group.has_spawned and group.objective.type == "reenforce_area" then
			local locked_up_in_area

			if group.objective.moving_out then
				local done_moving = true

				for u_key, u_data in pairs(group.units) do
					local objective = u_data.unit:brain():objective()

					if not objective or objective.is_default or objective.grp_objective and objective.grp_objective ~= group.objective then
						if objective then
							if objective.area then
								locked_up_in_area = objective.area
							elseif objective.nav_seg then
								locked_up_in_area = self:get_area_from_nav_seg_id(objective.nav_seg)
							else
								locked_up_in_area = self:get_area_from_nav_seg_id(u_data.tracker:nav_segment())
							end
						else
							locked_up_in_area = self:get_area_from_nav_seg_id(u_data.tracker:nav_segment())
						end
					elseif not objective.in_place and objective.area and not objective.area.nav_segs[u_data.unit:movement():nav_tracker():nav_segment()] then
						done_moving = false
					end
				end

				if done_moving then
					group.objective.moving_out = nil
					group.objective.moving_in = nil
					group.in_place_t = self._t

					self:_voice_move_complete(group)
				end
			end

			if group.objective.moving_in or locked_up_in_area and locked_up_in_area ~= group.objective.area then
				-- block empty
			elseif not group.objective.moving_out then
				self:_set_reenforce_objective_to_group(group)
			end
		end
	end
end

function GroupAIStateBesiege:_set_reenforce_objective_to_group(group)
	if not group.has_spawned then
		return
	end

	local current_objective = group.objective

	if current_objective.target_area then
		if current_objective.moving_out and not current_objective.moving_in then
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)

			if forwardmost_i_nav_point then
				for i = forwardmost_i_nav_point + 1, #current_objective.coarse_path do
					local nav_point = current_objective.coarse_path[forwardmost_i_nav_point]

					if not self:is_nav_seg_safe(nav_point[1]) then
						for j = 0, #current_objective.coarse_path - forwardmost_i_nav_point do
							table.remove(current_objective.coarse_path)
						end

						local grp_objective = {
							area = self:get_area_from_nav_seg_id(current_objective.coarse_path[#current_objective.coarse_path][1]),
							attitude = "avoid",
							pose = "stand",
							scan = true,
							stance = "hos",
							target_area = current_objective.target_area,
							type = "reenforce_area",
						}

						self:_set_objective_to_enemy_group(group, grp_objective)

						return
					end
				end
			end
		end

		if not current_objective.moving_out and not current_objective.area.neighbours[current_objective.target_area.id] then
			local search_params = {
				access_pos = self._get_group_acces_mask(group),
				from_seg = current_objective.area.pos_nav_seg,
				id = "GroupAI_reenforce",
				to_seg = current_objective.target_area.pos_nav_seg,
				verify_clbk = callback(self, self, "is_nav_seg_safe"),
			}
			local coarse_path = managers.navigation:search_coarse(search_params)

			if coarse_path then
				self:_merge_coarse_path_by_area(coarse_path)
				table.remove(coarse_path)

				local grp_objective = {
					area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
					attitude = "avoid",
					coarse_path = coarse_path,
					pose = "stand",
					scan = true,
					stance = "hos",
					target_area = current_objective.target_area,
					type = "reenforce_area",
				}

				self:_set_objective_to_enemy_group(group, grp_objective)
			end
		end

		if not current_objective.moving_out and current_objective.area.neighbours[current_objective.target_area.id] and current_objective.target_area.criminal.amount == 0 then
			local grp_objective = {
				area = current_objective.target_area,
				attitude = "engage",
				pose = "crouch",
				scan = true,
				stance = "hos",
				type = "reenforce_area",
			}

			self:_set_objective_to_enemy_group(group, grp_objective)

			group.objective.moving_in = true
		end
	end
end

function GroupAIStateBesiege:_get_group_forwardmost_coarse_path_index(group)
	local coarse_path = group.objective.coarse_path
	local forwardmost_i_nav_point = #coarse_path

	while forwardmost_i_nav_point > 0 do
		local nav_seg = coarse_path[forwardmost_i_nav_point][1]
		local area = self:get_area_from_nav_seg_id(nav_seg)

		if not area then
			return
		end

		for u_key, u_data in pairs(group.units) do
			if area.nav_segs[u_data.unit:movement():nav_tracker():nav_segment()] then
				return forwardmost_i_nav_point
			end
		end

		forwardmost_i_nav_point = forwardmost_i_nav_point - 1
	end
end

function GroupAIStateBesiege:_voice_deathguard_start(group)
	for _, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter.deathguard and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "deathguard") then
			return
		end
	end
end

function GroupAIStateBesiege:_voice_open_fire_start(group)
	for _, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter.aggressive and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "aggressive") then
			return
		end
	end
end

function GroupAIStateBesiege:_voice_move_in_start(group)
	for _, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter.go_go and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "go_go") then
			break
		end
	end
end

function GroupAIStateBesiege:_voice_move_complete(group)
	for _, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter.ready and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "ready") then
			break
		end
	end
end

function GroupAIStateBesiege:_voice_retreat_start(group)
	for _, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter.retreat and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "retreat") then
			break
		end
	end
end

function GroupAIStateBesiege:_chk_group_areas_unsafe(group)
	local objective = group.objective
	local occupied_areas = {}

	for u_key, u_data in pairs(group.units) do
		local nav_seg = u_data.tracker:nav_segment()

		for area_id, area in pairs(self._area_data) do
			if area.nav_segs[nav_seg] then
				occupied_areas[area_id] = area
			end
		end
	end

	for area_id, area in pairs(occupied_areas) do
		if not self:is_area_safe(area) then
			return area
		end
	end
end

function GroupAIStateBesiege:_chk_area_neighbours_safe(area)
	for area_id, neighbour_area in pairs(area.neighbours) do
		if not self:is_area_safe(neighbour_area) then
			return false
		end
	end

	return true
end

function GroupAIStateBesiege:_chk_coarse_path_unsafe(group)
	local current_objective = group.objective

	if not current_objective.coarse_path then
		return
	end

	local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)

	if not forwardmost_i_nav_point then
		return
	end

	for i = forwardmost_i_nav_point + 1, #current_objective.coarse_path do
		local nav_point = current_objective.coarse_path[forwardmost_i_nav_point]

		if not self:is_nav_seg_safe(nav_point[1]) then
			return nav_point[1]
		end
	end
end

function GroupAIStateBesiege:_count_criminals_engaged_force(max_count)
	local count = 0
	local all_enemies = self._police

	for _, crim_data in pairs(self._char_criminals) do
		local crim_area = self:get_area_from_nav_seg_id(crim_data.tracker:nav_segment())

		for ene_key, engaged_ene_data in pairs(crim_data.engaged) do
			local ene_data = all_enemies[ene_key]

			if ene_data then
				local ene_group = ene_data.group

				if ene_group and ene_group.objective.type == "assault_area" then
					local ene_area = self:get_area_from_nav_seg_id(ene_data.tracker:nav_segment())

					if ene_area == crim_area or ene_area.neighbours[crim_area] then
						count = count + 1

						if max_count and max_count == count then
							return max_count
						end
					end
				end
			end
		end
	end

	return count
end

function GroupAIStateBesiege:_verify_group_objective(group)
	local is_objective_broken
	local grp_objective = group.objective
	local coarse_path = grp_objective.coarse_path
	local nav_segments = managers.navigation._nav_segments

	if coarse_path then
		for i_node, node in ipairs(coarse_path) do
			local nav_seg = nav_segments[node[1]]

			if not nav_seg then
				return
			end

			if nav_seg.disabled then
				is_objective_broken = true

				break
			end
		end
	end

	local found = false

	if not grp_objective.moving_out then
		for u_key, u_data in pairs(group.units) do
			if not u_data.unit:brain().path_failed then
				found = true

				break
			end
		end

		if not found then
			is_objective_broken = true

			for u_key, u_data in pairs(group.units) do
				u_data.unit:brain().path_failed = false
			end
		end
	end

	if not is_objective_broken then
		return
	end

	local new_area
	local tested_nav_seg_ids = {}

	for u_key, u_data in pairs(group.units) do
		u_data.tracker:move(u_data.m_pos)

		local nav_seg_id = u_data.tracker:nav_segment()

		if not tested_nav_seg_ids[nav_seg_id] then
			tested_nav_seg_ids[nav_seg_id] = true

			local areas = self:get_areas_from_nav_seg_id(nav_seg_id)

			for _, test_area in pairs(areas) do
				for test_nav_seg, _ in pairs(test_area.nav_segs) do
					if not nav_segments[test_nav_seg].disabled then
						new_area = test_area

						break
					end
				end

				if new_area then
					break
				end
			end
		end

		if new_area then
			break
		end
	end

	if not new_area then
		Application:debug("[GroupAi:Generic] [GroupAIStateBesiege:_verify_group_objective] could not find replacement area to", inspect(grp_objective.area))

		return
	end

	group.objective = {
		area = new_area,
		moving_out = false,
		type = grp_objective.type,
	}
end

function GroupAIStateBesiege:team_data(team_id)
	return self._teams[team_id]
end

function GroupAIStateBesiege:set_char_team(unit, team_id)
	local u_key = unit:key()
	local team = self._teams[team_id]
	local u_data = self._police[u_key]

	if u_data and u_data.group then
		u_data.group.team = team

		for _, other_u_data in pairs(u_data.group.units) do
			other_u_data.unit:movement():set_team(team)
		end

		return
	end

	unit:movement():set_team(team)
end

function GroupAIStateBesiege:set_team_relation(team1_id, team2_id, relation, mutual)
	if mutual then
		self:set_team_relation(team1_id, team2_id, relation, nil)
		self:set_team_relation(team2_id, team1_id, relation, nil)

		return
	end

	if relation == "foe" then
		self._teams[team1_id].foes[team2_id] = true
	elseif relation == "friend" or relation == "neutral" then
		self._teams[team1_id].foes[team2_id] = nil
	end

	if Network:is_server() then
		local team1_index = tweak_data.levels:get_team_index(team1_id)
		local team2_index = tweak_data.levels:get_team_index(team2_id)
		local relation_code = relation == "neutral" and 1 or relation == "friend" and 2 or 3

		managers.network:session():send_to_peers_synched("sync_team_relation", team1_index, team2_index, relation_code)
	end
end

function GroupAIStateBesiege:_check_spawn_phalanx()
	if Global.game_settings.single_player then
		return
	end

	if not self._phalanx_center_pos then
		return
	end

	if not self._task_data or not self._task_data.assault.active then
		return
	end

	if self._task_data.assault.phase ~= "build" and self._task_data.assault.phase ~= "sustain" then
		return
	end

	if self._phalanx_spawn_group then
		return
	end

	local now = TimerManager:game():time()
	local respawn_delay = tweak_data.group_ai.phalanx.spawn_chance.respawn_delay

	if self._phalanx_despawn_time and now < self._phalanx_despawn_time + respawn_delay then
		return
	end

	local spawn_chance_start = tweak_data.group_ai.phalanx.spawn_chance.start

	self._phalanx_current_spawn_chance = self._phalanx_current_spawn_chance or spawn_chance_start
	self._phalanx_last_spawn_check = self._phalanx_last_spawn_check or now
	self._phalanx_last_chance_increase = self._phalanx_last_chance_increase or now

	local spawn_chance_increase = tweak_data.group_ai.phalanx.spawn_chance.increase
	local spawn_chance_max = tweak_data.group_ai.phalanx.spawn_chance.max

	if spawn_chance_max > self._phalanx_current_spawn_chance and spawn_chance_increase > 0 then
		local chance_increase_intervall = tweak_data.group_ai.phalanx.chance_increase_intervall

		if now >= self._phalanx_last_chance_increase + chance_increase_intervall then
			self._phalanx_last_chance_increase = now
			self._phalanx_current_spawn_chance = math.min(spawn_chance_max, self._phalanx_current_spawn_chance + spawn_chance_increase)
		end
	end

	if self._phalanx_current_spawn_chance > 0 then
		local check_spawn_intervall = tweak_data.group_ai.phalanx.check_spawn_intervall

		if now >= self._phalanx_last_spawn_check + check_spawn_intervall then
			self._phalanx_last_spawn_check = now

			if math.random() <= self._phalanx_current_spawn_chance then
				self:_spawn_phalanx()
			end
		end
	end
end

function GroupAIStateBesiege:_spawn_phalanx()
	if self._phalanx_center_pos then
		local phalanx_center_pos = self._phalanx_center_pos
		local phalanx_center_nav_seg = managers.navigation:get_nav_seg_from_pos(phalanx_center_pos)
		local phalanx_area = self:get_area_from_nav_seg_id(phalanx_center_nav_seg)
		local phalanx_group = {
			Phalanx = {
				1,
				1,
				1,
			},
		}
		local spawn_group, group_nationality, spawn_group_type = self:_find_spawn_group_near_area(phalanx_area, phalanx_group, nil, nil, nil)

		if spawn_group.spawn_pts[1] and spawn_group.spawn_pts[1].pos then
			local spawn_pos = spawn_group.spawn_pts[1].pos
			local spawn_nav_seg = managers.navigation:get_nav_seg_from_pos(spawn_pos)
			local spawn_area = self:get_area_from_nav_seg_id(spawn_nav_seg)

			if spawn_group then
				local grp_objective = {
					area = spawn_area,
					nav_seg = spawn_nav_seg,
					type = "defend_area",
				}

				print("Phalanx spawn started!")

				self._phalanx_spawn_group = self:_spawn_in_group(spawn_group, group_nationality, spawn_group_type, grp_objective, nil)

				self:set_assault_endless(true)
				managers.network:session():send_to_peers_synched("group_ai_event", self:get_sync_event_id("phalanx_spawned"), 0)
			end
		end
	else
		print("self._phalanx_center_pos NOT SET!!!")
	end
end

function GroupAIStateBesiege:_check_phalanx_group_has_spawned()
	if self._phalanx_spawn_group then
		if self._phalanx_spawn_group.has_spawned then
			if not self._phalanx_spawn_group.set_to_phalanx_group_obj then
				local pos = self._phalanx_center_pos
				local nav_seg = managers.navigation:get_nav_seg_from_pos(pos)
				local area = self:get_area_from_nav_seg_id(nav_seg)
				local grp_objective = {
					area = area,
					nav_seg = nav_seg,
					pos = pos,
					type = "create_phalanx",
				}

				Application:warn("[GroupAIStateBesiege:_check_phalanx_group_has_spawned] Phalanx spawn finished, setting phalanx objective!")
				self:_set_objective_to_enemy_group(self._phalanx_spawn_group, grp_objective)

				self._phalanx_spawn_group.set_to_phalanx_group_obj = true
			end
		else
			Application:warn("[GroupAIStateBesiege:_check_phalanx_group_has_spawned] Phalanx group has not yet spawned completely!")
		end
	end
end

function GroupAIStateBesiege:phalanx_damage_reduction_enable()
	local law1team = self:_get_law1_team()

	self:set_phalanx_damage_reduction_buff(law1team.damage_reduction or tweak_data.group_ai.phalanx.vip.damage_reduction.start)

	self._phalanx_damage_reduction_last_increase = self._phalanx_damage_reduction_last_increase or TimerManager:game():time()
end

function GroupAIStateBesiege:phalanx_damage_reduction_disable()
	self:set_phalanx_damage_reduction_buff(-1)

	self._phalanx_damage_reduction_last_increase = nil
end

function GroupAIStateBesiege:_get_law1_team()
	local team_id = tweak_data.levels:get_default_team_ID("combatant")

	return self:team_data(team_id)
end

function GroupAIStateBesiege:_check_phalanx_damage_reduction_increase()
	local law1team = self:_get_law1_team()
	local damage_reduction_max = tweak_data.group_ai.phalanx.vip.damage_reduction.max

	if law1team.damage_reduction and damage_reduction_max > law1team.damage_reduction then
		local now = TimerManager:game():time()
		local increase_intervall = tweak_data.group_ai.phalanx.vip.damage_reduction.increase_intervall
		local last_increase = self._phalanx_damage_reduction_last_increase

		if now > last_increase + increase_intervall then
			last_increase = now

			local damage_reduction = math.min(damage_reduction_max, law1team.damage_reduction + tweak_data.group_ai.phalanx.vip.damage_reduction.increase)

			self:set_phalanx_damage_reduction_buff(damage_reduction)

			self._phalanx_damage_reduction_last_increase = last_increase

			print("Phalanx damage reduction buff has been increased to ", law1team.damage_reduction, "%!")

			if alive(self:phalanx_vip()) then
				self:phalanx_vip():sound():say("cpw_a05", true, true)
			end
		end
	end
end

function GroupAIStateBesiege:set_phalanx_damage_reduction_buff(damage_reduction)
	local law1team = self:_get_law1_team()

	damage_reduction = damage_reduction or -1

	if law1team then
		if damage_reduction > 0 then
			law1team.damage_reduction = damage_reduction
		else
			law1team.damage_reduction = nil
		end

		self:set_damage_reduction_buff_hud()
	end

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("sync_damage_reduction_buff", damage_reduction)
	end
end

function GroupAIStateBesiege:set_damage_reduction_buff_hud()
	local law1team = self:_get_law1_team()

	if law1team then
		if law1team.damage_reduction then
			print("Setting damage reduction buff icon to ENABLED!")
		else
			print("Setting damage reduction buff icon to DISABLED!")
		end
	else
		debug_pause("LAW 1 TEAM NOT FOUND!!!!")
	end
end

function GroupAIStateBesiege:set_assault_endless(enabled)
	self._hunt_mode = enabled

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("sync_assault_endless", enabled)
	end
end

function GroupAIStateBesiege:activate_spawn_group_override(group_id)
	if not self._tweak_data.assault.group_overrides[group_id] then
		return
	end

	self._spawn_group_override = group_id
end

function GroupAIStateBesiege:deactivate_spawn_group_override()
	self._spawn_group_override = nil
end

function GroupAIStateBesiege:_get_spawn_groups(phase)
	local phase_data = self._tweak_data[phase]

	if not phase_data then
		return
	end

	return self._spawn_group_override and phase_data.group_overrides and phase_data.group_overrides[self._spawn_group_override] or phase_data.groups
end

function GroupAIStateBesiege:phalanx_despawned()
	self._phalanx_despawn_time = TimerManager:game():time()
	self._phalanx_spawn_group = nil

	local spawn_chance_decrease = tweak_data.group_ai.phalanx.spawn_chance.decrease

	self._phalanx_current_spawn_chance = math.max(0, self._phalanx_current_spawn_chance or tweak_data.group_ai.phalanx.spawn_chance.start - spawn_chance_decrease)
end

function GroupAIStateBesiege:phalanx_spawn_group()
	return self._phalanx_spawn_group
end

function GroupAIStateBesiege:force_end_assault_phase()
	local task_data = self._task_data.assault

	if task_data.active then
		self:_begin_assault_task_phase_fade(task_data)
	end

	self:set_assault_endless(false)
end
