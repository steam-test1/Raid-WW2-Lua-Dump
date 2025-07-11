core:import("CoreMissionScriptElement")

ElementSpecialObjective = ElementSpecialObjective or class(CoreMissionScriptElement.MissionScriptElement)
ElementSpecialObjective._AI_GROUPS = {
	"enemies",
	"friendlies",
	"civilians",
	"bank_manager_old_man",
	"escort_guy_1",
	"escort_guy_2",
	"escort_guy_3",
	"escort_guy_4",
	"escort_guy_5",
	"chavez",
}
ElementSpecialObjective._PATHING_STYLES = {
	"destination",
	"precise",
	"coarse",
	"warp",
}
ElementSpecialObjective._ATTITUDES = {
	"avoid",
	"engage",
}
ElementSpecialObjective._TRIGGER_ON = {
	"interact",
}
ElementSpecialObjective._INTERACTION_VOICES = {
	"default",
	"cuff_cop",
	"down_cop",
	"stop_cop",
	"escort_keep",
	"escort_go",
	"escort",
	"stop",
	"down_stay",
	"down",
	"bridge_codeword",
	"bridge_chair",
	"undercover_interrogate",
}
ElementSpecialObjective._STANCES = {
	"ntl",
	"hos",
	"cbt",
}
ElementSpecialObjective._POSES = {
	"crouch",
	"stand",
}
ElementSpecialObjective._HASTES = {
	"walk",
	"run",
}
ElementSpecialObjective._DEFAULT_VALUES = {
	action_duration_max = 0,
	action_duration_min = 0,
	ai_group = 1,
	base_chance = 1,
	chance_inc = 0,
	interaction_voice = 1,
	interrupt_dis = -1,
	interrupt_dmg = 0,
	interval = -1,
	path_style = 1,
}

function ElementSpecialObjective:init(...)
	ElementSpecialObjective.super.init(self, ...)
	self:_finalize_values(self._values)

	self._values = clone(self._values)
end

function ElementSpecialObjective:_finalize_values(values)
	values.so_action = self:value("so_action")

	local function _index_or_nil(table_in, name_in)
		local found_index = table.index_of(table_in, values[name_in])

		values[name_in] = found_index ~= -1 and found_index or nil
	end

	local function _nil_if_default(name_in)
		if values[name_in] == self._DEFAULT_VALUES[name_in] then
			values[name_in] = nil
		end
	end

	local function _nil_if_none(name_in)
		if values[name_in] == "none" then
			values[name_in] = nil
		end
	end

	local function _save_boolean(name_in)
		values[name_in] = values[name_in] or nil
	end

	_save_boolean("use_instigator")

	if values.use_instigator then
		values.ai_group = nil
		values.interval = nil
		values.search_distance = nil
	else
		values.ai_group = table.index_of(self._AI_GROUPS, values.ai_group)

		_nil_if_default("ai_group")
		_nil_if_default("interval")
	end

	_save_boolean("is_navigation_link")

	if values.use_instigator then
		values.search_position = nil
	end

	if values.align_position then
		_save_boolean("align_position")
		_save_boolean("align_rotation")
		_save_boolean("needs_pos_rsrv")
		_index_or_nil(ElementSpecialObjective._PATHING_STYLES, "path_style")
		_index_or_nil(ElementSpecialObjective._HASTES, "path_haste")
		_nil_if_none("patrol_path")
	else
		if not values.is_navigation_link then
			values.position = nil
		end

		values.align_position = nil
		values.align_rotation = nil
		values.needs_pos_rsrv = nil
		values.path_style = nil
		values.path_haste = nil
		values.patrol_path = nil
	end

	if values.align_rotation or values.is_navigation_link then
		values.rotation = mrotation.yaw(values.rotation)
	else
		values.rotation = nil
	end

	_nil_if_default("base_chance")

	if values.base_chance then
		_nil_if_default("chance_inc")
	else
		values.chance_inc = nil
	end

	_nil_if_default("action_duration_min")
	_nil_if_default("action_duration_max")
	_index_or_nil(ElementSpecialObjective._TRIGGER_ON, "trigger_on")
	_index_or_nil(ElementSpecialObjective._INTERACTION_VOICES, "interaction_voice")
	_save_boolean("repeatable")
	_save_boolean("forced")
	_save_boolean("scan")
	_save_boolean("allow_followup_self")
	_save_boolean("is_navigation_link")
	_save_boolean("is_align_point")
	_index_or_nil(ElementSpecialObjective._STANCES, "path_stance")
	_index_or_nil(ElementSpecialObjective._POSES, "pose")
	_nil_if_none("so_action")
	_nil_if_default("interrupt_dis")
	_nil_if_default("interrupt_dmg")
	_index_or_nil(ElementSpecialObjective._ATTITUDES, "attitude")

	if values.followup_elements and not next(values.followup_elements) then
		values.followup_elements = nil
	end

	if values.spawn_instigator_ids and not next(values.spawn_instigator_ids) then
		values.spawn_instigator_ids = nil
	end

	values.SO_access = managers.navigation:convert_access_filter_to_number(values.SO_access)
end

function ElementSpecialObjective:event(name, unit)
	if self._events and self._events[name] then
		for _, callback in pairs(self._events[name]) do
			callback(unit)
		end
	end
end

function ElementSpecialObjective:clbk_objective_action_start(unit)
	self:event("anim_start", unit)
end

function ElementSpecialObjective:clbk_objective_administered(unit)
	if self._values.needs_pos_rsrv then
		self._pos_rsrv = self._pos_rsrv or {}

		local unit_rsrv = self._pos_rsrv[unit:key()]

		if unit_rsrv then
			managers.navigation:unreserve_pos(unit_rsrv)
		else
			unit_rsrv = {
				position = self._values.align_position and self._values.position or unit:position(),
				radius = 30,
			}
			self._pos_rsrv[unit:key()] = unit_rsrv
		end

		unit_rsrv.filter = unit:movement():pos_rsrv_id()

		managers.navigation:add_pos_reservation(unit_rsrv)
	end

	self._receiver_units = self._receiver_units or {}
	self._receiver_units[unit:key()] = unit

	self:event("administered", unit)
end

function ElementSpecialObjective:clbk_objective_complete(unit)
	if self._pos_rsrv then
		local unit_rsrv = self._pos_rsrv[unit:key()]

		if unit_rsrv then
			managers.navigation:unreserve_pos(unit_rsrv)

			self._pos_rsrv[unit:key()] = nil
		end
	end

	if self._receiver_units then
		self._receiver_units[unit:key()] = nil

		if not next(self._receiver_units) then
			self._receiver_units = nil
		end
	end

	if self.turret_unit then
		self.turret_unit:weapon():on_turret_SO_completed(unit)
	end

	self:event("complete", unit)
end

function ElementSpecialObjective:clbk_objective_failed(unit)
	if self._pos_rsrv then
		local unit_rsrv = self._pos_rsrv[unit:key()]

		if unit_rsrv then
			managers.navigation:unreserve_pos(unit_rsrv)

			self._pos_rsrv[unit:key()] = nil
		end
	end

	if self._receiver_units then
		self._receiver_units[unit:key()] = nil

		if not next(self._receiver_units) then
			self._receiver_units = nil
		end
	end

	if managers.editor and managers.editor._stopping_simulation then
		return
	end

	if self.turret_unit then
		self.turret_unit:weapon():on_turret_SO_failed(unit)
	end

	self:event("fail", unit)
end

function ElementSpecialObjective:clbk_verify_administration(unit)
	if self._values.needs_pos_rsrv then
		self._tmp_pos_rsrv = self._tmp_pos_rsrv or {
			position = self._values.position,
			radius = 30,
		}

		local pos_rsrv = self._tmp_pos_rsrv

		pos_rsrv.filter = unit:movement():pos_rsrv_id()

		if managers.navigation:is_pos_free(pos_rsrv) then
			return true
		else
			return false
		end
	end

	return true
end

function ElementSpecialObjective:add_event_callback(name, callback, callback_id)
	local id = callback_id or "generic_id"

	self._events = self._events or {}
	self._events[name] = self._events[name] or {}
	self._events[name][id] = callback
end

function ElementSpecialObjective:remove_event_callback(callback_id)
	if self._events and self._events.complete then
		self._events.complete[callback_id] = nil
	end

	if self._events and self._events.fail then
		self._events.fail[callback_id] = nil
	end

	if self._events and self._events.administered then
		self._events.administered[callback_id] = nil
	end
end

function ElementSpecialObjective:on_executed(instigator)
	if not self._values.enabled or Network:is_client() then
		return
	end

	if not managers.groupai:state():is_AI_enabled() and not Application:editor() then
		-- block empty
	elseif self._values.spawn_instigator_ids then
		local chosen_units, objectives = self:_select_units_from_spawners()

		if chosen_units then
			for i, chosen_unit in ipairs(chosen_units) do
				self:_administer_objective(chosen_unit, objectives[i])
			end
		end
	elseif self._values.use_instigator then
		if self:_is_nav_link() then
			Application:error("[ElementSpecialObjective:on_executed] Ambiguous nav_link/SO. Element id:", self._id)
		elseif type_name(instigator) == "Unit" and alive(instigator) then
			if instigator:brain() then
				if (not instigator:character_damage() or not instigator:character_damage():dead()) and managers.navigation:check_access(self._values.SO_access, instigator:brain():SO_access(), 0) then
					local objective = self:get_objective(instigator)

					if objective then
						self:_administer_objective(instigator, objective)
					end
				end
			else
				Application:error("[ElementSpecialObjective:on_executed] Special Objective instigator is not an AI unit. Possibly improper \"use instigator\" flag use. Element id:", self._id)
			end
		elseif not instigator then
			Application:error("[ElementSpecialObjective:on_executed] Special Objective missing instigator. Possibly improper \"use instigator\" flag use. Element id:", self._id)
		end
	elseif self:_is_nav_link() then
		if self._values.so_action then
			managers.navigation:register_anim_nav_link(self)
		else
			Application:error("[ElementSpecialObjective:on_executed] Nav link without animation specified. Element id:", self._id)
		end
	else
		local objective = self:get_objective(instigator)

		if objective then
			local search_dis_sq = self._values.search_distance

			search_dis_sq = search_dis_sq and search_dis_sq * search_dis_sq or nil

			local so_descriptor = {
				AI_group = self._AI_GROUPS[self:_get_default_value_if_nil("ai_group")],
				access = tonumber(self._values.SO_access),
				admin_clbk = callback(self, self, "clbk_objective_administered"),
				base_chance = self:_get_default_value_if_nil("base_chance"),
				chance_inc = self:_get_default_value_if_nil("chance_inc"),
				interval = self._values.interval,
				objective = objective,
				repeatable = self._values.repeatable,
				search_dis_sq = search_dis_sq,
				search_pos = self._values.search_position,
				usage_amount = self._values.trigger_times,
			}

			managers.groupai:state():add_special_objective(self:_unique_string_id(), so_descriptor)
		end
	end

	ElementSpecialObjective.super.on_executed(self, instigator)
end

function ElementSpecialObjective:operation_remove()
	if self._nav_link then
		managers.navigation:unregister_anim_nav_link(self)
	else
		managers.groupai:state():remove_special_objective(self:_unique_string_id())

		if self._receiver_units then
			local t = clone(self._receiver_units)

			for u_key, unit in pairs(t) do
				if self._receiver_units[u_key] and alive(unit) and not unit:brain()._current_logic.inactive then
					unit:brain():set_objective(nil)
					unit:brain():action_request({
						body_part = 2,
						sync = true,
						type = "idle",
					})
				end
			end
		end
	end
end

function ElementSpecialObjective:get_objective(instigator)
	local is_AI_SO = self._is_AI_SO or string.begins(self._values.so_action, "AI")
	local pose, stance, attitude, path_style, pos, rot, interrupt_dis, interrupt_health, haste, trigger_on, interaction_voice = self:_get_misc_SO_params()
	local objective = {
		action_duration = self:_get_action_duration(),
		action_start_clbk = callback(self, self, "clbk_objective_action_start"),
		attitude = attitude,
		complete_clbk = callback(self, self, "clbk_objective_complete"),
		element = self,
		fail_clbk = callback(self, self, "clbk_objective_failed"),
		followup_SO = self._values.followup_elements and self or nil,
		forced = self._values.forced,
		haste = haste,
		interaction_voice = interaction_voice,
		interrupt_dis = interrupt_dis,
		interrupt_health = interrupt_health,
		path_style = path_style,
		pos = pos,
		pose = pose,
		rot = rot,
		scan = self._values.scan,
		stance = stance,
		trigger_on = trigger_on,
		type = false,
		verification_clbk = callback(self, self, "clbk_verify_administration"),
	}

	if self._values.followup_elements then
		local mission = self._sync_id ~= 0 and managers.worldcollection:mission_by_id(self._sync_id) or managers.mission
		local so_element = mission:get_element_by_id(self._values.followup_elements[1])

		if so_element.get_objective_trigger and so_element:get_objective_trigger() then
			objective.followup_objective = so_element:get_objective()
			objective.followup_SO = nil
		end
	end

	if is_AI_SO then
		if Application:editor() and not Global.running_simulation then
			return
		end

		local objective_type = string.sub(self._values.so_action, 4)
		local last_pos, nav_seg

		if objective_type == "phalanx" then
			objective.nav_seg = managers.navigation:get_nav_seg_from_pos(objective.pos)
			objective.type = objective_type
		elseif objective_type == "hunt" then
			nav_seg, last_pos = self:_get_hunt_location(instigator)

			if not nav_seg then
				return
			end
		else
			local path_name = self._values.patrol_path

			if not path_name then
				last_pos = pos or self._values.position
			elseif path_style == "destination" then
				local path_data = managers.ai_data:destination_path(self._values.position, Rotation(self._values.rotation, 0, 0))

				objective.path_data = path_data
				last_pos = self._values.position
			else
				local path_data = managers.ai_data:patrol_path(path_name)

				objective.path_data = path_data

				local points = path_data.points

				last_pos = points[#points].position
			end
		end

		if objective_type == "defend" or objective_type == "search" or objective_type == "hunt" then
			objective.type = "defend_area"
			objective.nav_seg = nav_seg or last_pos and managers.navigation:get_nav_seg_from_pos(last_pos)
		elseif objective_type == "idle" then
			objective.type = "free"
			objective.nav_seg = nav_seg or last_pos and managers.navigation:get_nav_seg_from_pos(last_pos)
		elseif objective_type ~= "phalanx" then
			objective.type = objective_type
			objective.nav_seg = nav_seg or pos and last_pos and managers.navigation:get_nav_seg_from_pos(last_pos)

			if objective_type == "security" then
				objective.rubberband_rotation = true
			end
		end
	else
		local action

		if self._values.so_action then
			action = {
				align_sync = true,
				blocks = {
					action = -1,
					heavy_hurt = -1,
					hurt = -1,
					light_hurt = -1,
					walk = -1,
				},
				body_part = 1,
				needs_full_blend = true,
				type = "act",
				variant = self._values.so_action,
			}
			objective.type = "act"
		else
			objective.type = "free"
		end

		objective.action = action

		if self._values.align_position then
			objective.nav_seg = managers.navigation:get_nav_seg_from_pos(self._values.position)

			if path_style == "destination" then
				local path_data = managers.ai_data:destination_path(self._values.position, Rotation(self._values.rotation or 0, 0, 0))

				objective.path_data = path_data
			else
				local path_name = self._values.patrol_path
				local path_data = managers.ai_data:patrol_path(path_name)

				objective.path_data = path_data
			end
		end
	end

	if objective.nav_seg then
		objective.area = managers.groupai:state():get_area_from_nav_seg_id(objective.nav_seg)
	end

	return objective
end

function ElementSpecialObjective:_get_hunt_location(instigator)
	if not alive(instigator) then
		return
	end

	local from_pos = instigator:movement():m_pos()
	local nearest_criminal, nearest_dis, nearest_pos
	local criminals = managers.groupai:state():all_criminals()

	for u_key, record in pairs(criminals) do
		if not record.status then
			local my_dis = mvector3.distance(from_pos, record.m_pos)

			if not nearest_dis or my_dis < nearest_dis then
				nearest_dis = my_dis
				nearest_criminal = record.unit
				nearest_pos = record.m_pos
			end
		end
	end

	if not nearest_criminal then
		print("[ElementSpecialObjective:_create_SO_hunt] Could not find a criminal to hunt")

		return
	end

	local criminal_tracker = nearest_criminal:movement():nav_tracker()
	local objective_nav_seg = criminal_tracker:nav_segment()

	return objective_nav_seg, criminal_tracker:field_position()
end

function ElementSpecialObjective:_get_misc_SO_params()
	local pose, stance, attitude, path_style, pos, rot, interrupt_dis, interrupt_health, haste, trigger_on, interaction_voice
	local values = self._values

	pos = values.align_position and values.position or nil
	rot = values.align_position and values.align_rotation and Rotation(values.rotation, 0, 0) or nil
	path_style = values.align_position and self._PATHING_STYLES[self:_get_default_value_if_nil("path_style")] or nil
	attitude = self._ATTITUDES[values.attitude]
	stance = self._STANCES[values.path_stance]
	pose = self._POSES[values.pose]

	if not values.interrupt_dis then
		interrupt_dis = self._DEFAULT_VALUES.interrupt_dis
	elseif values.interrupt_dis ~= 0 then
		interrupt_dis = values.interrupt_dis * 100
	end

	if values.interrupt_dmg then
		interrupt_health = values.interrupt_dmg < 1 and 1 - values.interrupt_dmg or nil
	else
		interrupt_health = 1
	end

	haste = self._HASTES[values.path_haste]
	trigger_on = self._TRIGGER_ON[values.trigger_on] or nil
	interaction_voice = values.interaction_voice and self._INTERACTION_VOICES[values.interaction_voice]

	return pose, stance, attitude, path_style, pos, rot, interrupt_dis, interrupt_health, haste, trigger_on, interaction_voice
end

function ElementSpecialObjective:nav_link_end_pos()
	return self._values.search_position
end

function ElementSpecialObjective:nav_link_access()
	return tonumber(self._values.SO_access)
end

function ElementSpecialObjective:chance()
	return self:_get_default_value_if_nil("base_chance")
end

function ElementSpecialObjective:nav_link_delay()
	return self:_get_default_value_if_nil("interval")
end

function ElementSpecialObjective:nav_link()
	return self._nav_link
end

function ElementSpecialObjective:id()
	return self._id
end

function ElementSpecialObjective:_is_nav_link()
	return self._values.is_navigation_link or self._values.navigation_link and self._values.navigation_link ~= -1
end

function ElementSpecialObjective:set_nav_link(nav_link)
	self._nav_link = nav_link
end

function ElementSpecialObjective:nav_link_wants_align_pos()
	return self._values.align_position
end

function ElementSpecialObjective:_select_units_from_spawners()
	local candidates = {}
	local objectives = {}
	local mission = self._sync_id ~= 0 and managers.worldcollection:mission_by_id(self._sync_id) or managers.mission

	for _, element_id in ipairs(self._values.spawn_instigator_ids) do
		local spawn_element = mission:get_element_by_id(element_id)

		if not spawn_element then
			debug_pause("[ElementSpecialObjective:_select_units_from_spawners()] Missing mission script element! (parent, world_id, element)", self, _id, self._editor_name, self._sync_id, element_id)
		else
			for _, unit in ipairs(spawn_element:units()) do
				if alive(unit) and (not unit:character_damage() or not unit:character_damage():dead()) and managers.navigation:check_access(self._values.SO_access, unit:brain():SO_access(), 0) then
					local objective = self:get_objective(unit)

					if objective and (self._values.forced or unit:brain():is_available_for_assignment(objective)) then
						table.insert(candidates, unit)
						table.insert(objectives, objective)
					end
				end
			end
		end
	end

	if self._values.turret_id then
		self.turret_unit = managers.worldcollection:get_unit_with_id(self._values.turret_id, nil, self._sync_id or 0)
	end

	local wanted_nr_units

	if self._values.trigger_times and self._values.trigger_times > 0 then
		wanted_nr_units = self._values.trigger_times
	else
		return candidates, objectives
	end

	wanted_nr_units = math.min(wanted_nr_units, #candidates)

	local chosen_units = {}
	local chosen_objectives = {}

	for i = 1, wanted_nr_units do
		local i_unit = math.random(#candidates)
		local chosen_unit = table.remove(candidates, i_unit)

		table.insert(chosen_units, chosen_unit)
		table.insert(chosen_objectives, table.remove(objectives, i_unit))
	end

	return chosen_units, chosen_objectives
end

function ElementSpecialObjective:get_objective_trigger()
	return self._values.trigger_on
end

function ElementSpecialObjective:_administer_objective(unit, objective)
	if objective.type == "phalanx" then
		GroupAIStateBase:register_phalanx_unit(unit)
	end

	if objective.type == "turret" then
		self:_administer_to_turret(unit, objective)

		return
	end

	if objective.trigger_on == "interact" then
		if not unit:brain():objective() then
			local idle_objective = {
				followup_objective = objective,
				type = "free",
			}

			unit:brain():set_objective(idle_objective)
		end

		unit:brain():set_followup_objective(objective)

		return
	end

	if self._values.forced or unit:brain():is_available_for_assignment(objective) or not unit:brain():objective() then
		if objective.area then
			local u_key = unit:key()
			local u_data = managers.enemy:all_enemies()[u_key]

			if u_data and u_data.assigned_area then
				managers.groupai:state():set_enemy_assigned(objective.area, u_key)
			end
		end

		unit:brain():set_objective(objective)
		self:clbk_objective_administered(unit)
	else
		unit:brain():set_followup_objective(objective)
	end
end

function ElementSpecialObjective:_administer_to_turret(unit, objective)
	if not self.turret_unit or not self.turret_unit:weapon() or not self.turret_unit:weapon():is_available() then
		self:clbk_objective_failed(unit)

		return
	end

	local so_object = self.turret_unit:weapon()._SO_object
	local turret_pos = self.turret_unit:weapon()._SO_object:position()
	local turret_rot = self.turret_unit:weapon()._SO_object:rotation()

	objective.pos = turret_pos
	objective.rot = turret_rot

	self.turret_unit:weapon():on_turret_SO_administered(unit, self)
	unit:brain():set_objective(objective)
	self:clbk_objective_administered(unit)
end

function ElementSpecialObjective:choose_followup_SO(unit, skip_element_ids)
	if not self._values.followup_elements then
		return
	end

	if skip_element_ids == nil then
		if self._values.allow_followup_self and self:enabled() then
			skip_element_ids = {}
		else
			skip_element_ids = {
				[self._id] = true,
			}
		end
	end

	if self._values.SO_access and unit and not managers.navigation:check_access(self._values.SO_access, unit:brain():SO_access(), 0) then
		return
	end

	local total_weight = 0
	local pool = {}
	local mission = self._sync_id ~= 0 and managers.worldcollection:mission_by_id(self._sync_id) or managers.mission

	for _, followup_element_id in ipairs(self._values.followup_elements) do
		local weight
		local followup_element = mission:get_element_by_id(followup_element_id)

		if followup_element:enabled() then
			if not followup_element.get_as_followup then
				debug_pause("[ElementSpecialObjective][choose_followup_SO] Element chosen as SO followup doesn't have the 'get_followup' method. This element:  ", inspect(self), inspect(self._values), " \nFollowup element:  ", inspect(followup_element))
			else
				followup_element, weight = followup_element:get_as_followup(unit, skip_element_ids)

				if followup_element and followup_element:enabled() and weight > 0 then
					table.insert(pool, {
						element = followup_element,
						weight = weight,
					})

					total_weight = total_weight + weight
				end
			end
		end
	end

	if not next(pool) or total_weight <= 0 then
		return
	end

	local lucky_w = math.random() * total_weight
	local accumulated_w = 0

	for i, followup_data in ipairs(pool) do
		accumulated_w = accumulated_w + followup_data.weight

		if lucky_w <= accumulated_w then
			return pool[i].element
		end
	end
end

function ElementSpecialObjective:get_as_followup(unit, skip_element_ids)
	if (not unit or managers.navigation:check_access(self._values.SO_access, unit:brain():SO_access(), 0) and self:clbk_verify_administration(unit)) and not skip_element_ids[self._id] then
		return self, self:_get_default_value_if_nil("base_chance")
	end

	self:event("admin_fail", unit)
end

function ElementSpecialObjective:_get_action_duration()
	if not self._values.action_duration_max and not self._values.action_duration_min then
		return
	else
		local val1 = self:_get_default_value_if_nil("action_duration_min")
		local val2 = self:_get_default_value_if_nil("action_duration_max")
		local min = math.min(val1, val2)
		local max = math.max(val1, val2)

		return math.lerp(min, max, math.random())
	end
end

function ElementSpecialObjective:_get_default_value_if_nil(name_in)
	return self._values[name_in] or self._DEFAULT_VALUES[name_in]
end

function ElementSpecialObjective:destroy()
	ElementSpecialObjective.super.destroy(self)

	if self._pos_rsrv then
		for _, unit_rsrv in pairs(self._pos_rsrv) do
			managers.navigation:unreserve_pos(unit_rsrv)
		end

		self._pos_rsrv = nil
	end
end
