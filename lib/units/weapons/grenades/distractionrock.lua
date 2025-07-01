DistractionRock = DistractionRock or class(GrenadeBase)

function DistractionRock:_setup_from_tweak_data()
	local grenade_entry = self.name_id

	self._tweak_data = tweak_data.projectiles[grenade_entry]
	self._init_timer = self._tweak_data.init_timer or 2.5
	self._mass_look_up_modifier = self._tweak_data.mass_look_up_modifier
	self._range = self._tweak_data.range
	self._pathing_searches = {}

	local sound_event = self._tweak_data.sound_event or "grenade_explode"

	self._custom_params = {
		camera_shake_max_mul = 4,
		sound_muffle_effect = true,
		effect = self._effect_name,
		feedback_range = self._range * 2,
		sound_event = sound_event,
	}
end

function DistractionRock:clbk_impact(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	Application:debug("[DistractionRock:clbk_impact]")
end

function DistractionRock:_on_collision(col_ray)
	Application:debug("[DistractionRock:_on_collision]")
end

function DistractionRock:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	if self._hand_held then
		return
	end

	local pos = self._unit:position()
	local range = self._range
	local slotmask = managers.slot:get_mask("enemies")
	local units = World:find_units_quick("sphere", pos, self._range, slotmask)

	if units then
		local closest_cop

		for _, cop in ipairs(units) do
			local search_id = "DistractionRock._detonate" .. tostring(cop:key())
			local search_params = {
				finished = false,
				access_pos = cop:brain()._SO_access,
				cop = cop,
				id = search_id,
				pos_from = cop:movement():m_pos(),
				pos_to = pos,
				result_clbk = callback(self, self, "clbk_pathing_results", search_id),
			}

			self._pathing_searches[search_id] = search_params

			managers.navigation:search_pos_to_pos(search_params)
		end
	end
end

function DistractionRock:clbk_pathing_results(search_id, path)
	local search = self._pathing_searches[search_id]

	if path and search then
		search.finished = true
		search.total_length = 0

		local last_leg

		for _, leg in ipairs(path) do
			if leg.x then
				if last_leg then
					local length = leg - last_leg

					search.total_length = search.total_length + length:length()
				else
					last_leg = leg
				end
			else
				search.invalid = true
			end
		end

		if not search.invalid and search.total_length < self._range and not self._found_cop then
			self:_abort_all_unfinished_pathing()

			self._found_cop = CopLogicBase.register_search_SO(search.cop, nil, search.pos_to)
		end
	end
end

function DistractionRock:_abort_all_unfinished_pathing()
	for search_id, search in pairs(self._pathing_searches) do
		if not search.finished then
			managers.navigation:cancel_pathing_search(search_id)
		end
	end
end

function DistractionRock:_detonate_on_client()
	return
end

function DistractionRock:bullet_hit()
	Application:debug("[DistractionRock:bullet_hit]")
end

function DistractionRock:set_attention_state(state)
	if state then
		if not self._attention_setting then
			self._attention_handler = AIAttentionObject:new(self._unit, true)

			if self._attention_obj_name then
				self._attention_handler:set_detection_object_name(self._attention_obj_name)
			end

			local descriptor = "distraction_ntl"
			local attention_setting = PlayerMovement._create_attention_setting_from_descriptor(self, tweak_data.attention.settings[descriptor], descriptor)

			self._attention_handler:set_attention(attention_setting)
		end
	elseif self._attention_handler then
		self._attention_handler:set_attention(nil)

		self._attention_handler = nil
	end
end

function DistractionRock:update_attention_settings(descriptor)
	local tweak_data = tweak_data.attention.settings[descriptor]

	if tweak_data and self._attention_handler then
		local attention_setting = PlayerMovement._create_attention_setting_from_descriptor(self, tweak_data, descriptor)

		self._attention_handler:set_attention(attention_setting)
	end
end
