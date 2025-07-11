local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_cross = mvector3.cross
local mvec3_rot = mvector3.rotate_with
local mvec3_rand_orth = mvector3.random_orthogonal
local mvec3_lerp = mvector3.lerp
local mrot_axis_angle = mrotation.set_axis_angle
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
local temp_vec3 = Vector3()
local temp_rot1 = Rotation()
local bezier_curve = {
	0,
	0,
	1,
	1,
}

CopActionShoot = CopActionShoot or class()
CopActionShoot._ik_presets = {
	r_arm = {
		get_blend = "_get_blend_ik_r_arm",
		start = "_begin_ik_r_arm",
		stop = "_stop_ik_r_arm",
		update = "_update_ik_r_arm",
	},
	spine = {
		get_blend = "_get_blend_ik_spine",
		start = "_begin_ik_spine",
		stop = "_stop_ik_spine",
		update = "_update_ik_spine",
	},
}

function CopActionShoot:init(action_desc, common_data)
	self._common_data = common_data

	local t = TimerManager:game():time()

	self._ext_movement = common_data.ext_movement
	self._ext_anim = common_data.ext_anim
	self._ext_brain = common_data.ext_brain
	self._ext_inventory = common_data.ext_inventory
	self._ext_base = common_data.ext_base
	self._body_part = action_desc.body_part
	self._machine = common_data.machine
	self._unit = common_data.unit

	local preset_name = self._ext_anim.base_aim_ik or "spine"
	local preset_data = self._ik_presets[preset_name]

	self._ik_preset = preset_data

	self[preset_data.start](self)

	if not self._ext_inventory:equipped_selection() then
		Application:error("[CopActionShoot:init vent] No weapon equipped: ", inspect(self._unit), "   ", inspect(common_data.char_tweak))

		return
	end

	local weapon_unit = self._ext_inventory:equipped_unit()
	local weap_tweak = weapon_unit:base():weapon_tweak_data()
	local weapon_usage_tweak = common_data.char_tweak.weapon[weap_tweak.usage]

	if not weapon_usage_tweak then
		Application:error("[CopActionShoot:init vent] unknown weapon used: ", inspect(self._unit), "   ", inspect(weapon_unit), "   ", inspect(weap_tweak), "   ", inspect(common_data.char_tweak))

		return
	end

	self._weapon_unit = weapon_unit
	self._weapon_base = weapon_unit:base()
	self._weap_tweak = weap_tweak
	self._w_usage_tweak = weapon_usage_tweak
	self._reload_speed = weapon_usage_tweak.RELOAD_SPEED
	self._spread = weapon_usage_tweak.spread
	self._falloff = weapon_usage_tweak.FALLOFF
	self._variant = action_desc.variant
	self._body_part = action_desc.body_part
	self._turn_allowed = Network:is_client()
	self._automatic_weap = weap_tweak.auto and true
	self._shoot_t = 0
	self._melee_timeout_t = t + 1

	local shoot_from_pos = self._ext_movement:m_head_pos()

	self._shoot_from_pos = shoot_from_pos

	self:on_attention(common_data.attention)

	if Network:is_server() then
		self._ext_movement:set_stance_by_code(3)
	end

	CopActionAct._create_blocks_table(self, action_desc.blocks)

	if Network:is_server() then
		common_data.ext_network:send("action_aim_state", true)
	end

	self._skipped_frames = 1
	self._get_target_position = self._get_target_pos

	return true
end

function CopActionShoot:on_inventory_event(event)
	if self._weapon_unit and self._autofiring then
		self._weapon_base:stop_autofire()

		if self._ext_anim.recoil then
			self._ext_movement:play_redirect("up_idle")
		end
	end

	local weapon_unit = self._ext_inventory:equipped_unit()

	self._weapon_unit = weapon_unit

	if weapon_unit then
		local weap_tweak = weapon_unit:base():weapon_tweak_data()
		local weapon_usage_tweak = self._common_data.char_tweak.weapon[weap_tweak.usage]

		if not weapon_usage_tweak then
			Application:error("[CopActionShoot:on_inventory_event] unknown weapon used: ", inspect(self._unit), "   ", inspect(weap_tweak), "   ", inspect(self._common_data.char_tweak))

			return
		end

		self._weapon_base = weapon_unit:base()
		self._weap_tweak = weap_tweak
		self._w_usage_tweak = weapon_usage_tweak
		self._reload_speed = weapon_usage_tweak.RELOAD_SPEED
		self._spread = weapon_usage_tweak.spread
		self._falloff = weapon_usage_tweak.FALLOFF
		self._automatic_weap = weap_tweak.auto and true
	else
		self._weapon_base = nil
		self._weap_tweak = nil
		self._w_usage_tweak = nil
		self._reload_speed = nil
		self._spread = nil
		self._falloff = nil
		self._automatic_weap = nil
	end

	self._autofiring = nil
	self._autoshots_fired = nil

	if self._weapon_unit then
		self.update = nil
	else
		self.update = self._upd_empty()
	end
end

function CopActionShoot:on_attention(attention, old_attention)
	if self._shooting_player and old_attention and alive(old_attention.unit) then
		old_attention.unit:movement():on_targetted_for_attack(false, self._common_data.unit)
	end

	self._shooting_player = nil
	self._shooting_husk_player = nil
	self._next_vis_ray_t = nil

	if attention then
		local t = TimerManager:game():time()

		self[self._ik_preset.start](self)

		local vis_state = self._ext_base:lod_stage()

		if vis_state and vis_state < 3 and self[self._ik_preset.get_blend](self) > 0 then
			self._aim_transition = {
				duration = 0.333,
				start_t = t + 0.0001,
				start_vec = mvector3.copy(self._common_data.look_vec),
			}
			self._get_target_position = self._get_transition_target_pos
		else
			self._aim_transition = nil
			self._get_target_position = self._get_target_pos
		end

		self._mod_enable_t = t + 0.5

		if attention.unit then
			self._shooting_player = attention.unit:base() and attention.unit:base().is_local_player

			if Network:is_client() then
				self._shooting_husk_player = attention.unit:base() and attention.unit:base().is_husk_player

				if self._shooting_husk_player then
					self._next_vis_ray_t = t
				end
			end

			if self._shooting_player or self._shooting_husk_player then
				self._verif_slotmask = managers.slot:get_mask("AI_visibility")
				self._line_of_sight_t = -100

				if self._shooting_player then
					attention.unit:movement():on_targetted_for_attack(true, self._common_data.unit)
				end
			else
				self._verif_slotmask = nil
			end

			local usage_tweak = self._w_usage_tweak
			local target_pos = attention.handler and attention.handler:get_attention_m_pos() or attention.unit:movement():m_head_pos()
			local focus_error_roll = math.random(360)
			local shoot_hist = self._shoot_history

			if shoot_hist then
				local displacement = mvector3.distance(target_pos, shoot_hist.m_last_pos)
				local focus_delay = usage_tweak.focus_delay * math.min(1, displacement / usage_tweak.focus_dis)

				shoot_hist.focus_delay = focus_delay
				shoot_hist.focus_error_roll = focus_error_roll
				shoot_hist.focus_start_t = t
				shoot_hist.m_last_pos = mvector3.copy(target_pos)
			else
				shoot_hist = {
					focus_delay = usage_tweak.focus_delay,
					focus_error_roll = focus_error_roll,
					focus_start_t = t,
					m_last_pos = mvector3.copy(target_pos),
				}
				self._shoot_history = shoot_hist
			end
		end
	else
		self[self._ik_preset.stop](self)

		if self._aim_transition then
			self._aim_transition = nil
			self._get_target_position = self._get_target_pos
		end
	end

	self._attention = attention
end

function CopActionShoot:save(save_data)
	save_data.type = "shoot"
	save_data.body_part = 3
end

function CopActionShoot:on_exit()
	if Network:is_server() then
		self._ext_movement:set_stance("hos")
	end

	if self._modifier_on then
		self[self._ik_preset.stop](self)
	end

	if self._autofiring then
		self._weapon_base:stop_autofire()
	end

	if self._ext_anim.recoil then
		self._ext_movement:play_redirect("up_idle")
	end

	if Network:is_server() then
		self._common_data.unit:network():send("action_aim_state", false)
	end

	if self._shooting_player and alive(self._attention.unit) then
		self._attention.unit:movement():on_targetted_for_attack(false, self._common_data.unit)
	end
end

function CopActionShoot:update(t)
	local vis_state = self._ext_base:lod_stage() or 4
	local high_quality = vis_state == 1

	if high_quality then
		-- block empty
	elseif vis_state * 3 > self._skipped_frames then
		self._skipped_frames = self._skipped_frames + 1

		return
	else
		self._skipped_frames = 1
	end

	local shoot_from_pos = self._shoot_from_pos
	local ext_anim = self._ext_anim
	local target_vec, target_dis, autotarget, target_pos

	if self._attention then
		target_pos, target_vec, target_dis, autotarget = self:_get_target_position(shoot_from_pos, self._attention, t)

		local tar_vec_flat = temp_vec2

		mvec3_set(tar_vec_flat, target_vec)
		mvec3_set_z(tar_vec_flat, 0)
		mvec3_norm(tar_vec_flat)

		local fwd = self._common_data.fwd
		local fwd_dot = mvec3_dot(fwd, tar_vec_flat)

		if self._turn_allowed then
			local active_actions = self._common_data.active_actions
			local queued_actions = self._common_data.queued_actions

			if (not active_actions[2] or active_actions[2]:type() == "idle") and (not queued_actions or not queued_actions[1] and not queued_actions[2]) and not self._ext_movement:chk_action_forbidden("walk") then
				local fwd_dot_flat = mvec3_dot(tar_vec_flat, fwd)

				if fwd_dot_flat < 0.87 then
					local spin = tar_vec_flat:to_polar_with_reference(fwd, math.UP).spin
					local new_action_data = {
						angle = spin,
						body_part = 2,
						type = "turn",
					}

					self._ext_movement:action_request(new_action_data)
				end
			end
		end

		target_vec = self:_upd_ik(target_vec, fwd_dot, t)
	end

	if ext_anim.reload or ext_anim.equip or ext_anim.melee or ext_anim.equip then
		-- block empty
	elseif self._weapon_base:clip_empty() then
		if self._autofiring then
			self._weapon_base:stop_autofire()

			if ext_anim.recoil then
				self._ext_movement:play_redirect("up_idle")
			end

			self._autofiring = nil
			self._autoshots_fired = nil
		end

		if not ext_anim.recoil then
			if self._ext_anim.base_no_reload then
				self._weapon_unit:base():on_reload()
			else
				local res = CopActionReload._play_reload(self)

				if res then
					self._machine:set_speed(res, self._reload_speed)
				end
			end
		end
	elseif self._autofiring then
		if not target_vec or not self._common_data.allow_fire then
			self._weapon_base:stop_autofire()

			self._shoot_t = t + 0.6
			self._autofiring = nil
			self._autoshots_fired = nil

			if ext_anim.recoil then
				self._ext_movement:play_redirect("up_idle")
			end
		else
			local spread = self._spread
			local falloff, i_range = self:_get_shoot_falloff(target_dis, self._falloff)
			local new_target_pos = self._shoot_history and self:_get_unit_shoot_pos(t, target_pos, target_dis, self._w_usage_tweak, falloff, i_range, autotarget)

			if new_target_pos then
				target_pos = new_target_pos
			else
				spread = math.min(20, spread)
			end

			local spread_pos = temp_vec2

			mvec3_rand_orth(spread_pos, target_vec)
			mvec3_set_l(spread_pos, spread)
			mvec3_add(spread_pos, target_pos)

			target_dis = mvec3_dir(target_vec, shoot_from_pos, spread_pos)

			local damage_multiplier = self:_get_shoot_falloff_damage(self._falloff, target_dis, i_range)
			local fired = self._weapon_base:trigger_held(shoot_from_pos, target_vec, damage_multiplier, self._shooting_player, nil, nil, nil, self._attention.unit)

			if fired then
				if fired.hit_enemy and fired.hit_enemy.type == "death" and self._unit:unit_data().mission_element then
					self._unit:unit_data().mission_element:event("killshot", self._unit)
				end

				if high_quality and not ext_anim.recoil and not ext_anim.base_no_recoil then
					self._ext_movement:play_redirect("recoil_auto")
				end

				if not self._autofiring or self._autoshots_fired == self._autofiring - 1 then
					self._autofiring = nil
					self._autoshots_fired = nil

					self._weapon_base:stop_autofire()

					if ext_anim.recoil then
						self._ext_movement:play_redirect("up_idle")
					end

					self:_add_shoot_recoil_delay(falloff, high_quality, t)
				else
					self._autoshots_fired = self._autoshots_fired + 1
				end
			end
		end
	elseif target_vec and self._common_data.allow_fire and t > self._shoot_t and t > self._mod_enable_t then
		local shoot

		if autotarget or self._shooting_husk_player and t > self._next_vis_ray_t then
			if self._shooting_husk_player then
				self._next_vis_ray_t = t + 2
			end

			local fire_line = World:raycast("ray", shoot_from_pos, target_pos, "slot_mask", self._verif_slotmask, "ray_type", "ai_vision")

			if fire_line then
				if t - self._line_of_sight_t > 3 then
					local aim_delay_minmax = self._w_usage_tweak.aim_delay
					local lerp_dis = math.min(1, target_vec:length() / self._falloff[#self._falloff].r)
					local aim_delay = math.lerp(aim_delay_minmax[1], aim_delay_minmax[2], lerp_dis)

					aim_delay = aim_delay + math.random() * aim_delay * 0.3

					if self._common_data.is_suppressed then
						aim_delay = aim_delay * 1.5
					end

					self._shoot_t = t + aim_delay
				elseif fire_line.distance > 300 then
					shoot = true
				end
			else
				if t - self._line_of_sight_t > 1 and not self._last_vis_check_status then
					local shoot_hist = self._shoot_history
					local displacement = mvector3.distance(target_pos, shoot_hist.m_last_pos)
					local focus_delay = self._w_usage_tweak.focus_delay * math.min(1, displacement / self._w_usage_tweak.focus_dis)

					shoot_hist.focus_start_t = t
					shoot_hist.focus_delay = focus_delay
					shoot_hist.m_last_pos = mvector3.copy(target_pos)
				end

				self._line_of_sight_t = t
				shoot = true
			end

			self._last_vis_check_status = shoot
		elseif self._shooting_husk_player then
			shoot = self._last_vis_check_status
		else
			shoot = true
		end

		local melee

		if autotarget and (not self._common_data.melee_countered_t or t - self._common_data.melee_countered_t > 15) and target_dis < 130 and self._w_usage_tweak.melee_speed and t > self._melee_timeout_t then
			melee = self:_chk_start_melee(target_vec, target_dis, autotarget, target_pos)
			shoot = shoot or melee
		end

		if shoot and not melee and self._weapon_base:start_shooting_allowed() then
			local falloff, i_range = self:_get_shoot_falloff(target_dis, self._falloff)
			local firemode

			if self._automatic_weap then
				local random_mode = math.random()

				for i_mode, mode_chance in ipairs(falloff.mode) do
					if random_mode <= mode_chance then
						firemode = i_mode

						break
					end
				end
			else
				firemode = 1
			end

			if firemode > 1 then
				self._weapon_base:start_autofire(firemode < 4 and firemode)

				self._autofiring = firemode < 4 and firemode or math.random(self._w_usage_tweak.autofire_rounds[1], self._w_usage_tweak.autofire_rounds[2])
				self._autoshots_fired = 0

				if high_quality and not ext_anim.base_no_recoil then
					self._ext_movement:play_redirect("recoil_auto")
				end
			else
				local spread = self._spread

				if autotarget then
					local new_target_pos = self._shoot_history and self:_get_unit_shoot_pos(t, target_pos, target_dis, self._w_usage_tweak, falloff, i_range, autotarget)

					if new_target_pos then
						target_pos = new_target_pos
					else
						spread = math.min(20, spread)
					end
				end

				local spread_pos = temp_vec2

				mvec3_rand_orth(spread_pos, target_vec)
				mvec3_set_l(spread_pos, spread)
				mvec3_add(spread_pos, target_pos)

				target_dis = mvec3_dir(target_vec, shoot_from_pos, spread_pos)

				local damage_multiplier = self:_get_shoot_falloff_damage(self._falloff, target_dis, i_range)
				local fired = self._weapon_base:singleshot(shoot_from_pos, target_vec, damage_multiplier, self._shooting_player, nil, nil, nil, self._attention.unit)

				if fired then
					if fired.hit_enemy and fired.hit_enemy.type == "death" and self._unit:unit_data().mission_element then
						self._unit:unit_data().mission_element:event("killshot", self._unit)
					end

					if high_quality and not ext_anim.base_no_recoil then
						self._ext_movement:play_redirect("recoil_single")
					end

					self:_add_shoot_recoil_delay(falloff, high_quality, t)
				end
			end
		end
	end

	if self._ext_anim.base_need_upd then
		self._ext_movement:upd_m_head_pos()
	end
end

function CopActionShoot:_add_shoot_recoil_delay(falloff, high_quality, t)
	if high_quality then
		local supp_t_add = self._common_data.is_suppressed and 1.5 or 1

		self._shoot_t = t + supp_t_add * math.rand(falloff.recoil[1], falloff.recoil[2])
	else
		self._shoot_t = t + falloff.recoil[2]
	end
end

function CopActionShoot:_upd_empty(t)
	return
end

function CopActionShoot:type()
	return "shoot"
end

function CopActionShoot:_get_shoot_falloff(target_dis, falloff)
	for i_range, range_data in ipairs(falloff) do
		if target_dis < range_data.r then
			return range_data, i_range
		end
	end

	return falloff[#falloff], #falloff
end

function CopActionShoot:_get_shoot_falloff_damage(falloff, target_dis, idx)
	if idx == 1 then
		return falloff[idx].dmg_mul
	elseif idx == #falloff and target_dis >= falloff[idx].r then
		return falloff[idx].dmg_mul
	else
		local a = falloff[idx - 1]
		local b = falloff[idx]
		local t = (target_dis - a.r) / (b.r - a.r)

		return math.lerp(a.dmg_mul, b.dmg_mul, t)
	end
end

function CopActionShoot:_get_unit_shoot_pos(t, pos, dis, w_tweak, falloff, i_range, shooting_local_player)
	local shoot_hist = self._shoot_history
	local focus_delay, focus_prog

	if shoot_hist.focus_delay then
		focus_delay = (shooting_local_player and self._attention.unit:character_damage():focus_delay_mul() or 1) * shoot_hist.focus_delay
		focus_prog = focus_delay > 0 and (t - shoot_hist.focus_start_t) / focus_delay

		if not focus_prog or focus_prog >= 1 then
			shoot_hist.focus_delay = nil
			focus_prog = 1
		end
	else
		focus_prog = 1
	end

	local dis_lerp
	local hit_chances = falloff.acc
	local hit_chance

	if i_range == 1 then
		dis_lerp = dis / falloff.r
		hit_chance = math.lerp(hit_chances[1], hit_chances[2], focus_prog)
	else
		local prev_falloff = w_tweak.FALLOFF[i_range - 1]

		dis_lerp = math.min(1, (dis - prev_falloff.r) / (falloff.r - prev_falloff.r))

		local prev_range_hit_chance = math.lerp(prev_falloff.acc[1], prev_falloff.acc[2], focus_prog)

		hit_chance = math.lerp(prev_range_hit_chance, math.lerp(hit_chances[1], hit_chances[2], focus_prog), dis_lerp)
	end

	if self._common_data.is_suppressed then
		hit_chance = hit_chance * (w_tweak.SUPPRESSION_ACC_CHANCE or 0.5)
	end

	if self._common_data.active_actions[2] and self._common_data.active_actions[2]:type() == "dodge" then
		hit_chance = hit_chance * self._common_data.active_actions[2]:accuracy_multiplier()
	end

	if hit_chance > math.random() then
		mvec3_set(shoot_hist.m_last_pos, pos)
	else
		local enemy_vec = temp_vec2

		mvec3_set(enemy_vec, pos)
		mvec3_sub(enemy_vec, self._common_data.pos)

		local error_vec = Vector3()

		mvec3_cross(error_vec, enemy_vec, math.UP)
		mrot_axis_angle(temp_rot1, enemy_vec, shoot_hist.focus_error_roll)
		mvec3_rot(error_vec, temp_rot1)

		local miss_min_dis = shooting_local_player and 31 or 150
		local error_vec_len = miss_min_dis + w_tweak.spread + w_tweak.miss_dis * (1 - focus_prog)

		mvec3_set_l(error_vec, error_vec_len)
		mvec3_add(error_vec, pos)
		mvec3_set(shoot_hist.m_last_pos, error_vec)

		return error_vec
	end
end

function CopActionShoot:on_death_drop()
	if self._weapon_dropped then
		return
	end

	if self._shooting_hurt then
		if stage == 2 then
			self._weapon_base:stop_autofire()
			self._ext_inventory:drop_weapon()

			self._weapon_dropped = true
			self._shooting_hurt = false
		end
	elseif self._ext_inventory then
		self._ext_inventory:drop_weapon()

		self._weapon_dropped = true
	end
end

function CopActionShoot:get_husk_interrupt_desc()
	return {
		block_type = "action",
		body_part = 3,
		type = "shoot",
	}
end

function CopActionShoot:need_upd()
	return true
end

function CopActionShoot:_get_transition_target_pos(shoot_from_pos, attention, t)
	local transition = self._aim_transition

	if not transition or not transition.start_t then
		debug_pause("[CopActionShoot][_get_transition_target_pos]  Invalid params for _get_transition_target_pos:    ", inspect(transition))

		self._aim_transition = nil
		self._get_target_position = self._get_target_pos

		return self:_get_target_position(shoot_from_pos, attention)
	end

	local prog = (t - transition.start_t) / transition.duration

	if prog > 1 then
		self._aim_transition = nil
		self._get_target_position = self._get_target_pos

		return self:_get_target_position(shoot_from_pos, attention)
	end

	prog = math.bezier(bezier_curve, prog)

	local target_pos, target_vec, target_dis, autotarget

	if attention.handler then
		target_pos = temp_vec1

		mvector3.set(target_pos, attention.handler:get_attention_m_pos())

		if self._shooting_player then
			autotarget = true
		end
	elseif attention.unit then
		if self._shooting_player then
			autotarget = true
		end

		target_pos = temp_vec1

		attention.unit:character_damage():shoot_pos_mid(target_pos)
	else
		target_pos = attention.pos
	end

	target_vec = temp_vec3
	target_dis = mvec3_dir(target_vec, shoot_from_pos, target_pos)

	mvec3_lerp(target_vec, transition.start_vec, target_vec, prog)

	return target_pos, target_vec, target_dis, autotarget
end

function CopActionShoot:_get_target_pos(shoot_from_pos, attention)
	local target_pos, target_vec, target_dis, autotarget

	if attention.handler then
		target_pos = temp_vec1

		mvector3.set(target_pos, attention.handler:get_attention_m_pos())

		if self._shooting_player then
			autotarget = true
		end
	elseif attention.unit then
		if self._shooting_player then
			autotarget = true
		end

		target_pos = temp_vec1

		attention.unit:character_damage():shoot_pos_mid(target_pos)
	else
		target_pos = attention.pos
	end

	target_vec = temp_vec3
	target_dis = mvec3_dir(target_vec, shoot_from_pos, target_pos)

	return target_pos, target_vec, target_dis, autotarget
end

function CopActionShoot:set_ik_preset(preset_name)
	self[self._ik_preset.stop](self)

	local preset_data = self._ik_presets[preset_name]

	self._ik_preset = preset_data

	self[preset_data.start](self)
end

function CopActionShoot:_begin_ik_spine()
	if self._modifier then
		return
	end

	self._modifier_name = Idstring("action_upper_body_enemy")
	self._modifier = self._machine:get_modifier(self._modifier_name)

	self:_set_ik_updator("_upd_ik_spine")

	self._modifier_on = nil
	self._mod_enable_t = nil
end

function CopActionShoot:_stop_ik_spine()
	if not self._modifier then
		return
	end

	self._machine:allow_modifier(self._modifier_name)

	self._modifier_name = nil
	self._modifier = nil
	self._modifier_on = nil
end

function CopActionShoot:_upd_ik_spine(target_vec, fwd_dot, t)
	if fwd_dot > 0.5 then
		if not self._modifier_on then
			self._modifier_on = true

			self._machine:force_modifier(self._modifier_name)

			self._mod_enable_t = t + 0.5
		end

		self._modifier:set_target_y(target_vec)
		mvec3_set(self._common_data.look_vec, target_vec)

		return target_vec
	else
		if self._modifier_on then
			self._modifier_on = nil

			self._machine:allow_modifier(self._modifier_name)
		end

		return nil
	end
end

function CopActionShoot:_get_blend_ik_spine()
	return self._modifier:blend()
end

function CopActionShoot:_begin_ik_r_arm()
	if self._head_modifier then
		return
	end

	self._head_modifier_name = Idstring("look_head")
	self._head_modifier = self._machine:get_modifier(self._head_modifier_name)
	self._r_arm_modifier_name = Idstring("aim_r_arm")
	self._r_arm_modifier = self._machine:get_modifier(self._r_arm_modifier_name)
	self._modifier_on = nil
	self._mod_enable_t = false

	self:_set_ik_updator("_upd_ik_r_arm")
end

function CopActionShoot:_stop_ik_r_arm()
	if not self._head_modifier then
		return
	end

	self._machine:allow_modifier(self._head_modifier_name)
	self._machine:allow_modifier(self._r_arm_modifier_name)

	self._head_modifier_name = nil
	self._head_modifier = nil
	self._r_arm_modifier_name = nil
	self._r_arm_modifier = nil
	self._modifier_on = nil
end

function CopActionShoot:_upd_ik_r_arm(target_vec, fwd_dot, t)
	if fwd_dot > 0.01 then
		if not self._modifier_on then
			self._modifier_on = true

			self._machine:force_modifier(self._head_modifier_name)
			self._machine:force_modifier(self._r_arm_modifier_name)

			self._mod_enable_t = t + 0.5
		end

		self._head_modifier:set_target_z(target_vec)
		self._r_arm_modifier:set_target_y(target_vec)
		mvec3_set(self._common_data.look_vec, target_vec)

		return target_vec
	else
		if self._modifier_on then
			self._modifier_on = nil

			self._machine:allow_modifier(self._head_modifier_name)
			self._machine:allow_modifier(self._r_arm_modifier_name)
		end

		return nil
	end
end

function CopActionShoot:_get_blend_ik_r_arm()
	return self._r_arm_modifier:blend()
end

function CopActionShoot:_set_ik_updator(name)
	self._upd_ik = self[name]
end

function CopActionShoot:_chk_start_melee(target_vec, target_dis, autotarget, target_pos)
	local melee_weapon = self._unit:base():melee_weapon()
	local is_weapon = melee_weapon == "weapon"
	local state = self._ext_movement:play_redirect(is_weapon and "melee" or "melee_item")

	if state then
		if not is_weapon then
			local anim_attack_vars = {
				"var1",
				"var2",
			}

			self._common_data.machine:set_parameter(state, anim_attack_vars[math.random(#anim_attack_vars)], 1)

			local param = tweak_data.weapon.npc_melee[melee_weapon].animation_param

			self._common_data.machine:set_parameter(state, param, 1)
		end

		if is_weapon then
			local anim_speed = self._w_usage_tweak.melee_speed

			self._common_data.machine:set_speed(state, anim_speed)
		end

		self._melee_timeout_t = TimerManager:game():time() + (self._w_usage_tweak.melee_retry_delay and math.lerp(self._w_usage_tweak.melee_retry_delay[1], self._w_usage_tweak.melee_retry_delay[2], math.random()) or 1)
	else
		debug_pause_unit(self._common_data.unit, "[CopActionShoot:_chk_start_melee] redirect failed in state", self._common_data.machine:segment_state(Idstring("base")), self._common_data.unit)
	end

	return state and true
end

function CopActionShoot:anim_clbk_melee_strike()
	if not self._attention then
		return
	end

	local shoot_from_pos = self._shoot_from_pos
	local ext_anim = self._ext_anim
	local max_dix = 165
	local target_pos, target_vec, target_dis, autotarget = self:_get_target_pos(shoot_from_pos, self._attention, TimerManager:game():time())

	if not autotarget or not (target_dis < max_dix) then
		return
	end

	local min_dot = math.lerp(0, 0.4, target_dis / max_dix)
	local tar_vec_flat = temp_vec2

	mvec3_set(tar_vec_flat, target_vec)
	mvec3_set_z(tar_vec_flat, 0)
	mvec3_norm(tar_vec_flat)

	local fwd = self._common_data.fwd
	local fwd_dot = mvec3_dot(fwd, tar_vec_flat)

	if fwd_dot < min_dot then
		return
	end

	local push_vel = target_vec:with_z(0.1):normalized() * 600
	local melee_weapon = self._unit:base():melee_weapon()
	local is_weapon = melee_weapon == "weapon"
	local damage = is_weapon and self._w_usage_tweak.melee_dmg or tweak_data.weapon.npc_melee[melee_weapon].damage

	damage = damage * (is_weapon and 1 or self._common_data.char_tweak.melee_weapon_dmg_multiplier or 1)

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_MELEE_DAMAGE_INCREASE) then
		damage = damage * managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_ENEMIES_MELEE_DAMAGE_INCREASE)
	end

	local action_data = {
		attacker_unit = self._common_data.unit,
		col_ray = {
			position = shoot_from_pos + fwd * 50,
			ray = mvector3.copy(target_vec),
		},
		damage = damage,
		melee_weapon = melee_weapon,
		push_vel = push_vel,
		variant = "melee",
		weapon_unit = self._weapon_unit,
	}
	local defense_data = self._attention.unit:character_damage():damage_melee(action_data)

	if defense_data == "countered" then
		self._common_data.melee_countered_t = TimerManager:game():time()

		local action_data = {
			attack_dir = -1 * target_vec:normalized(),
			attacker_unit = self._strike_unit,
			col_ray = {
				body = self._unit:body("body"),
				position = self._common_data.pos + math.UP * 100,
			},
			damage = 0,
			damage_effect = 1,
			variant = "counter_spooc",
		}

		self._unit:character_damage():damage_melee(action_data)

		return
	end
end
