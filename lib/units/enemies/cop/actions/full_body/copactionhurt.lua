local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_set_l = mvector3.set_length
local mvec3_sub = mvector3.subtract
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_dot = mvector3.dot
local mvec3_cross = mvector3.cross
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_rand_orth = mvector3.random_orthogonal
local mvec3_dis = mvector3.distance
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()

CopActionHurt = CopActionHurt or class()
CopActionHurt.running_death_anim_variants = {
	female = 5,
	male = 26,
}
CopActionHurt.death_anim_variants = {
	heavy = {
		crouching = {
			bwd = {
				high = 3,
				low = 1,
			},
			fwd = {
				high = 7,
				low = 2,
			},
			l = {
				high = 3,
				low = 1,
			},
			r = {
				high = 3,
				low = 1,
			},
		},
		not_crouching = {
			bwd = {
				high = 1,
				low = 1,
			},
			fwd = {
				high = 6,
				low = 2,
			},
			l = {
				high = 1,
				low = 1,
			},
			r = {
				high = 1,
				low = 1,
			},
		},
	},
	normal = {
		crouching = {
			bwd = {
				high = 3,
				low = 1,
			},
			fwd = {
				high = 14,
				low = 5,
			},
			l = {
				high = 3,
				low = 1,
			},
			r = {
				high = 3,
				low = 1,
			},
		},
		not_crouching = {
			bwd = {
				high = 3,
				low = 2,
			},
			fwd = {
				high = 14,
				low = 5,
			},
			l = {
				high = 3,
				low = 1,
			},
			r = {
				high = 3,
				low = 1,
			},
		},
	},
}
CopActionHurt.death_anim_fe_variants = {
	heavy = {
		crouching = {
			bwd = {
				high = 0,
				low = 0,
			},
			fwd = {
				high = 0,
				low = 0,
			},
			l = {
				high = 0,
				low = 0,
			},
			r = {
				high = 0,
				low = 0,
			},
		},
		not_crouching = {
			bwd = {
				high = 0,
				low = 0,
			},
			fwd = {
				high = 0,
				low = 0,
			},
			l = {
				high = 0,
				low = 0,
			},
			r = {
				high = 0,
				low = 0,
			},
		},
	},
	normal = {
		crouching = {
			bwd = {
				high = 2,
				low = 0,
			},
			fwd = {
				high = 5,
				low = 2,
			},
			l = {
				high = 2,
				low = 0,
			},
			r = {
				high = 2,
				low = 0,
			},
		},
		not_crouching = {
			bwd = {
				high = 3,
				low = 0,
			},
			fwd = {
				high = 6,
				low = 2,
			},
			l = {
				high = 2,
				low = 0,
			},
			r = {
				high = 2,
				low = 0,
			},
		},
	},
}
CopActionHurt.hurt_anim_variants_highest_num = 18
CopActionHurt.hurt_anim_variants = {
	expl_hurt = {
		bwd = 8,
		fwd = 8,
		l = 7,
		r = 7,
	},
	fire_hurt = {
		bwd = 8,
		fwd = 8,
		l = 7,
		r = 7,
	},
	heavy_hurt = {
		not_crouching = {
			bwd = {
				high = 3,
				low = 2,
			},
			fwd = {
				high = 18,
				low = 7,
			},
			l = {
				high = 4,
				low = 2,
			},
			r = {
				high = 4,
				low = 2,
			},
		},
	},
	hurt = {
		not_crouching = {
			bwd = {
				high = 2,
				low = 1,
			},
			fwd = {
				high = 13,
				low = 5,
			},
			l = {
				high = 3,
				low = 1,
			},
			r = {
				high = 3,
				low = 1,
			},
		},
	},
}
CopActionHurt.running_hurt_anim_variants = {
	fwd = 14,
}
ShieldActionHurt = ShieldActionHurt or class(CopActionHurt)
ShieldActionHurt.hurt_anim_variants = deep_clone(CopActionHurt.hurt_anim_variants)
ShieldActionHurt.hurt_anim_variants.expl_hurt = {
	bwd = 2,
	fwd = 2,
	l = 2,
	r = 2,
}
ShieldActionHurt.hurt_anim_variants.fire_hurt = {
	bwd = 2,
	fwd = 2,
	l = 2,
	r = 2,
}
CopActionHurt.fire_death_anim_variants_length = {
	9,
	5,
	5,
	7,
	4,
}

function CopActionHurt:init(action_desc, common_data)
	local t = TimerManager:game():time()

	self._common_data = common_data
	self._ext_movement = common_data.ext_movement
	self._ext_inventory = common_data.ext_inventory
	self._ext_anim = common_data.ext_anim
	self._unit = common_data.unit
	self._machine = common_data.machine
	self._attention = common_data.attention
	self._action_desc = action_desc
	self._body_part = action_desc.body_part

	local tweak_table = self._unit:base()._tweak_table
	local is_civilian = CopDamage.is_civilian(tweak_table)
	local is_female = (self._machine:get_global("female") or 0) == 1
	local crouching = self._unit:anim_data().crouch or self._unit:anim_data().hurt and self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "crh") > 0
	local redir_res
	local action_type = action_desc.hurt_type
	local start_dot_dance_antimation = action_desc.fire_dot_data and action_desc.fire_dot_data.start_dot_dance_antimation

	if action_desc.variant == "tase" then
		redir_res = self._ext_movement:play_redirect("tased")

		if not redir_res then
			debug_pause("[CopActionHurt:init] tased redirect failed in", self._machine:segment_state(Idstring("base")))

			return
		end
	elseif action_type == "fire_hurt" or action_type == "light_hurt" and action_desc.variant == "fire" then
		local char_tweak = tweak_data.character[self._unit:base()._tweak_table]
		local use_animation_on_fire_damage

		use_animation_on_fire_damage = char_tweak.use_animation_on_fire_damage == nil and true or char_tweak.use_animation_on_fire_damage

		if start_dot_dance_antimation and self._unit:character_damage() and self._unit:character_damage().get_last_time_unit_got_fire_damage then
			local last_fire_recieved = self._unit:character_damage():get_last_time_unit_got_fire_damage()

			if last_fire_recieved == nil or t - last_fire_recieved > 1 then
				if use_animation_on_fire_damage then
					redir_res = self._ext_movement:play_redirect("fire_hurt")

					local dir_str
					local fwd_dot = action_desc.direction_vec:dot(common_data.fwd)

					if fwd_dot < 0 then
						local hit_pos = action_desc.hit_pos
						local hit_vec = (hit_pos - common_data.pos):with_z(0):normalized()

						if mvector3.dot(hit_vec, common_data.right) > 0 then
							dir_str = "r"
						else
							dir_str = "l"
						end
					else
						dir_str = "bwd"
					end

					self._machine:set_parameter(redir_res, dir_str, 1)
				end

				self._unit:character_damage():set_last_time_unit_got_fire_damage(t)
			end
		end
	elseif action_type == "taser_tased" then
		local char_tweak = tweak_data.character[self._unit:base()._tweak_table]

		if char_tweak.can_be_tased == nil or char_tweak.can_be_tased then
			redir_res = self._ext_movement:play_redirect("taser")

			local variant = math.random(4)
			local dir_str

			dir_str = variant == 1 and "var1" or variant == 2 and "var2" or variant == 3 and "var3" or variant == 4 and "var4" or "fwd"

			self._machine:set_parameter(redir_res, dir_str, 1)
		end
	elseif action_type == "light_hurt" then
		if not self._ext_anim.upper_body_active or self._ext_anim.upper_body_empty or self._ext_anim.recoil then
			redir_res = self._ext_movement:play_redirect(action_type)

			if not redir_res then
				debug_pause("[CopActionHurt:init] light_hurt redirect failed in", self._machine:segment_state(Idstring("upper_body")))

				return
			end

			local dir_str
			local fwd_dot = action_desc.direction_vec:dot(common_data.fwd)

			if fwd_dot < 0 then
				local hit_pos = action_desc.hit_pos
				local hit_vec = (hit_pos - common_data.pos):with_z(0):normalized()

				if mvector3.dot(hit_vec, common_data.right) > 0 then
					dir_str = "r"
				else
					dir_str = "l"
				end
			else
				dir_str = "bwd"
			end

			self._machine:set_parameter(redir_res, dir_str, 1)

			local height_str = action_desc.hit_pos.z > self._ext_movement:m_com().z and "high" or "low"

			self._machine:set_parameter(redir_res, height_str, 1)
		end

		self._expired = true

		return true
	elseif action_type == "hurt_sick" then
		local ecm_hurts_table = self._common_data.char_tweak.ecm_hurts

		if not ecm_hurts_table then
			debug_pause_unit(self._unit, "[CopActionHurt:init] Unit missing ecm_hurts in Character Tweak Data", self._unit)

			return
		end

		redir_res = self._ext_movement:play_redirect("hurt_sick")

		if not redir_res then
			debug_pause("[CopActionHurt:init] hurt_sick redirect failed in", self._machine:segment_state(Idstring("base")))

			return
		end

		local is_cop = true

		if is_civilian then
			is_cop = false
		end

		local sick_variants = {}

		for i, d in pairs(ecm_hurts_table) do
			table.insert(sick_variants, i)
		end

		local variant = sick_variants[math.random(#sick_variants)]
		local duration = math.random(ecm_hurts_table[variant].min_duration, ecm_hurts_table[variant].max_duration)

		for _, hurt_sick in ipairs(sick_variants) do
			self._machine:set_global(hurt_sick, hurt_sick == variant and 1 or 0)
		end

		self._sick_time = t + duration
	elseif action_type == "poison_hurt" then
		redir_res = self._ext_movement:play_redirect("hurt_poison")

		if not redir_res then
			debug_pause("[CopActionHurt:init] hurt_sick redirect failed in", self._machine:segment_state(Idstring("base")))

			return
		end

		self._sick_time = t + 2
	elseif action_type == "bleedout" then
		redir_res = self._ext_movement:play_redirect("bleedout")

		if not redir_res then
			debug_pause("[CopActionHurt:init] bleedout redirect failed in", self._machine:segment_state(Idstring("base")))

			return
		end
	elseif action_type == "death" and action_desc.variant == "fire" then
		redir_res = self._ext_movement:play_redirect("death_fire")

		if not redir_res then
			debug_pause("[CopActionHurt:init] death_fire redirect failed in", self._machine:segment_state(Idstring("base")))

			return
		end

		local variant_count = #CopActionHurt.fire_death_anim_variants_length or 5
		local variant = 1

		if variant_count > 1 then
			variant = math.random(variant_count)
		end

		for i = 1, variant_count do
			local state_value = 0

			if i == variant then
				state_value = 1
			end

			self._machine:set_parameter(redir_res, "var" .. tostring(i), state_value)
		end

		self:_start_enemy_fire_effect_on_death(variant)
	elseif action_type == "death" and action_desc.variant == "poison" then
		self:force_ragdoll()
	elseif action_type == "death" and (self._ext_anim.run and self._ext_anim.move_fwd or self._ext_anim.sprint) and not common_data.char_tweak.no_run_death_anim then
		redir_res = self._ext_movement:play_redirect("death_run")

		if not redir_res then
			debug_pause("[CopActionHurt:init] death_run redirect failed in", self._machine:segment_state(Idstring("base")))

			return
		end

		local variant = self.running_death_anim_variants[is_female and "female" or "male"] or 1

		if variant > 1 then
			variant = math.random(variant)
		end

		self._machine:set_parameter(redir_res, "var" .. tostring(variant), 1)
	elseif action_type == "death" and (self._ext_anim.run or self._ext_anim.ragdoll) and self:_start_ragdoll() then
		self.update = self._upd_ragdolled
	elseif action_type == "knockdown" or action_type == "heavy_hurt" and (self._ext_anim.run or self._ext_anim.sprint) and not common_data.is_suppressed and not crouching then
		redir_res = self._ext_movement:play_redirect("heavy_run")

		if not redir_res then
			debug_pause("[CopActionHurt:init] heavy_run redirect failed in", self._machine:segment_state(Idstring("base")))

			return
		end

		local variant = self.running_hurt_anim_variants.fwd or 1

		if variant > 1 then
			variant = math.random(variant)
		end

		self._machine:set_parameter(redir_res, "var" .. tostring(variant), 1)
	else
		local variant, height, old_variant, old_info

		if (action_type == "hurt" or action_type == "heavy_hurt") and self._ext_anim.hurt then
			for i = 1, self.hurt_anim_variants_highest_num do
				if self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "var" .. i) then
					old_variant = i

					break
				end
			end

			if old_variant ~= nil then
				old_info = {
					bwd = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "bwd"),
					crh = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "crh"),
					fwd = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "fwd"),
					high = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "high"),
					hvy = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "hvy"),
					l = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "l"),
					low = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "low"),
					mod = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "mod"),
					r = self._machine:get_parameter(self._machine:segment_state(Idstring("base")), "r"),
				}
			end
		end

		redir_res = self._ext_movement:play_redirect(action_type)

		if not redir_res then
			debug_pause_unit(self._unit, "[CopActionHurt:init]", action_type, "redirect failed in", self._machine:segment_state(Idstring("base")), self._unit)

			return
		end

		if action_desc.variant == "bleeding" then
			-- block empty
		else
			local nr_variants = self._ext_anim.base_nr_variants

			if nr_variants then
				variant = math.random(nr_variants)
			else
				local fwd_dot = action_desc.direction_vec:dot(common_data.fwd)
				local right_dot = action_desc.direction_vec:dot(common_data.right)
				local dir_str

				dir_str = math.abs(fwd_dot) > math.abs(right_dot) and (fwd_dot < 0 and "fwd" or "bwd") or right_dot > 0 and "l" or "r"

				self._machine:set_parameter(redir_res, dir_str, 1)

				local hit_z = action_desc.hit_pos.z

				height = hit_z > self._ext_movement:m_com().z and "high" or "low"

				if action_type == "death" then
					local death_type = is_civilian and "normal" or action_desc.death_type

					if is_female then
						variant = self.death_anim_fe_variants[death_type][crouching and "crouching" or "not_crouching"][dir_str][height]
					else
						variant = self.death_anim_variants[death_type][crouching and "crouching" or "not_crouching"][dir_str][height]
					end

					if variant > 1 then
						variant = math.random(variant)
					end
				elseif action_type ~= "shield_knock" and action_type ~= "counter_tased" and action_type ~= "taser_tased" then
					if old_variant and (old_info[dir_str] == 1 and old_info[height] == 1 and old_info.mod == 1 and action_type == "hurt" or old_info.hvy == 1 and action_type == "heavy_hurt") then
						variant = old_variant
					end

					if not variant then
						if action_type == "expl_hurt" then
							variant = self.hurt_anim_variants[action_type][dir_str]
						else
							variant = self.hurt_anim_variants[action_type].not_crouching[dir_str][height]
						end

						if variant > 1 then
							variant = math.random(variant)
						end
					end
				end
			end

			variant = variant or 1

			if variant then
				self._machine:set_parameter(redir_res, "var" .. tostring(variant), 1)
			end

			if height then
				self._machine:set_parameter(redir_res, height, 1)
			end

			if crouching then
				self._machine:set_parameter(redir_res, "crh", 1)
			end

			if action_type == "hurt" then
				self._machine:set_parameter(redir_res, "mod", 1)
			elseif action_type == "heavy_hurt" then
				self._machine:set_parameter(redir_res, "hvy", 1)
			elseif action_type == "death" and action_desc.death_type == "heavy" and not is_civilian then
				self._machine:set_parameter(redir_res, "heavy", 1)
			elseif action_type == "expl_hurt" then
				self._machine:set_parameter(redir_res, "expl", 1)
			end
		end
	end

	if self._ext_anim.upper_body_active and not self._ragdolled then
		self._ext_movement:play_redirect("up_idle")
	end

	self._last_vel_z = 0
	self._hurt_type = action_type
	self._variant = action_desc.variant
	self._body_part = action_desc.body_part

	if action_type == "bleedout" then
		self.update = self._upd_bleedout
		self._shoot_t = t + 1

		if Network:is_server() then
			self._ext_inventory:equip_selection(1, true)
		end

		local weapon_unit = self._ext_inventory:equipped_unit()
		local weap_tweak = weapon_unit:base():weapon_tweak_data()
		local weapon_usage_tweak = common_data.char_tweak.weapon[weap_tweak.usage]

		self._weapon_base = weapon_unit:base()
		self._weapon_unit = weapon_unit
		self._weap_tweak = weap_tweak
		self._w_usage_tweak = weapon_usage_tweak
		self._reload_speed = weapon_usage_tweak.RELOAD_SPEED
		self._spread = weapon_usage_tweak.spread
		self._falloff = weapon_usage_tweak.FALLOFF
		self._head_modifier_name = Idstring("look_head")
		self._arm_modifier_name = Idstring("aim_r_arm")
		self._head_modifier = self._machine:get_modifier(self._head_modifier_name)
		self._arm_modifier = self._machine:get_modifier(self._arm_modifier_name)
		self._aim_vec = mvector3.copy(common_data.fwd)
		self._anim = redir_res

		if not self._shoot_history then
			self._shoot_history = {
				focus_delay = weapon_usage_tweak.focus_delay,
				focus_error_roll = math.random(360),
				focus_start_t = t,
				m_last_pos = common_data.pos + common_data.fwd * 500,
			}
		end
	elseif action_type == "hurt_sick" or action_type == "poison_hurt" then
		self.update = self._upd_sick
	elseif action_desc.variant == "tase" then
		-- block empty
	elseif self._ragdolled then
		-- block empty
	elseif self._unit:anim_data().skip_force_to_graph then
		self.update = self._upd_empty
	else
		self.update = self._upd_hurt
	end

	local shoot_chance

	if self._ext_inventory and not self._weapon_dropped and common_data.char_tweak.shooting_death and not self._ext_movement:cool() and t - self._ext_movement:not_cool_t() > 3 then
		local weapon_unit = self._ext_inventory:equipped_unit()

		if weapon_unit then
			if action_type == "counter_tased" or action_type == "taser_tased" then
				weapon_unit:base():on_reload()

				shoot_chance = 1
			elseif action_type == "death" or action_type == "hurt" or action_type == "heavy_hurt" then
				shoot_chance = 0.1
			end
		end
	end

	if shoot_chance then
		local equipped_weapon = self._ext_inventory:equipped_unit()

		if equipped_weapon and (not equipped_weapon:base().clip_empty or not equipped_weapon:base():clip_empty()) and shoot_chance > math.random() then
			self._weapon_unit = equipped_weapon

			self._unit:movement():set_friendly_fire(true)

			self._friendly_fire = true

			if equipped_weapon:base():weapon_tweak_data().auto then
				equipped_weapon:base():start_autofire()

				self._shooting_hurt = true
			else
				self._delayed_shooting_hurt_clbk_id = "shooting_hurt" .. tostring(self._unit:key())

				managers.enemy:add_delayed_clbk(self._delayed_shooting_hurt_clbk_id, callback(self, self, "clbk_shooting_hurt"), TimerManager:game():time() + math.lerp(0.2, 0.4, math.random()))
			end
		end
	end

	if not self._unit:base().nick_name then
		if action_desc.variant == "fire" then
			if tweak_table ~= "tank" and tweak_table ~= "shield" and not self._unit:sound():speaking() then
				if action_desc.hurt_type == "fire_hurt" then
					self._unit:sound():say("burnhurt", true, true)
				elseif action_desc.hurt_type == "death" then
					self._unit:sound():say("burndeath", true, true)
				end
			end
		elseif action_type == "death" then
			if not managers.groupai:state():is_police_called() then
				local result = self._unit:sound():say("death_stealth")
			else
				self._unit:sound():say("death")
			end
		elseif action_type == "counter_tased" or action_type == "taser_tased" then
			self._unit:sound():say("tasered")
		else
			self._unit:sound():say("hurt")
		end

		if Network:is_server() then
			managers.groupai:state():propagate_alert({
				"vo_distress",
				common_data.ext_movement:m_head_pos(),
				25,
				self._unit:brain():SO_access(),
				self._unit,
			})
		end
	end

	if action_type == "death" or action_type == "bleedout" or action_desc.variant == "tased" then
		self._floor_normal = self:_get_floor_normal(common_data.pos, common_data.fwd, common_data.right)
	end

	CopActionAct._create_blocks_table(self, action_desc.blocks)
	self._ext_movement:enable_update()

	if (self._body_part == 1 or self._body_part == 2) and Network:is_server() then
		local stand_rsrv = self._unit:brain():get_pos_rsrv("stand")

		if not stand_rsrv or mvector3.distance_sq(stand_rsrv.position, common_data.pos) > 400 then
			self._unit:brain():add_pos_rsrv("stand", {
				position = mvector3.copy(common_data.pos),
				radius = 30,
			})
		end
	end

	return true
end

function CopActionHurt:_start_fire_animation(redir_res, action_type, t, action_desc, common_data)
	return
end

function CopActionHurt:_start_enemy_fire_animation(action_type, t, use_animation_on_fire_damage, action_desc, common_data)
	return
end

function CopActionHurt:_start_enemy_fire_effect_on_death(death_variant)
	if self._fire_death_effects then
		return
	end

	self._fire_death_effects = {}

	local fire_tweak = tweak_data.fire
	local effects_table = fire_tweak.death_effects.default
	local fire_variant = effects_table[death_variant] or effects_table.default
	local effect_name = fire_tweak.effects[fire_variant.effect]
	local bones = fire_tweak.character_fire_bones
	local effect_manager = World:effect_manager()

	for _, bone_name in ipairs(bones) do
		local bone = self._unit:get_object(bone_name)

		if bone then
			local effect_id = effect_manager:spawn({
				effect = effect_name,
				parent = bone,
			})

			table.insert(self._fire_death_effects, effect_id)
		end
	end

	self._unit:sound():play("burn_loop_body")

	self._fire_death_effects_key = "fire_death_" .. tostring(self._unit:key())

	managers.queued_tasks:queue(self._fire_death_effects_key, self._remove_fire_death_effects, self, nil, fire_variant.duration)
end

function CopActionHurt:_remove_fire_death_effects()
	if not self._fire_death_effects_key then
		return
	end

	local effect_manager = World:effect_manager()

	for _, effect_id in ipairs(self._fire_death_effects) do
		effect_manager:fade_kill(effect_id)
	end

	self._unit:sound():play("burn_loop_body_stop")

	self._fire_death_effects_key = nil
	self._fire_death_effects = nil
end

function CopActionHurt:_get_floor_normal(at_pos, fwd, right)
	local padding_height = 150
	local center_pos = at_pos + math.UP

	mvec3_set_z(center_pos, center_pos.z + padding_height)

	local fall = 100
	local down_vec = Vector3(0, 0, -fall - padding_height)
	local dis = 50
	local fwd_pos, bwd_pos, r_pos, l_pos
	local from_pos = fwd * dis

	mvec3_add(from_pos, center_pos)

	local to_pos = from_pos + down_vec
	local down_ray = World:raycast("ray", from_pos, to_pos, "slot_mask", 1)

	if down_ray then
		fwd_pos = down_ray.position
	else
		fwd_pos = to_pos:with_z(at_pos.z)
	end

	mvec3_set(from_pos, fwd)
	mvec3_mul(from_pos, -dis)
	mvec3_add(from_pos, center_pos)
	mvec3_set(to_pos, from_pos)
	mvec3_add(to_pos, down_vec)

	down_ray = World:raycast("ray", from_pos, to_pos, "slot_mask", 1)

	if down_ray then
		bwd_pos = down_ray.position
	else
		bwd_pos = to_pos:with_z(at_pos.z)
	end

	mvec3_set(from_pos, right)
	mvec3_mul(from_pos, dis)
	mvec3_add(from_pos, center_pos)
	mvec3_set(to_pos, from_pos)
	mvec3_add(to_pos, down_vec)

	down_ray = World:raycast("ray", from_pos, to_pos, "slot_mask", 1)

	if down_ray then
		r_pos = down_ray.position
	else
		r_pos = to_pos:with_z(at_pos.z)
	end

	mvec3_set(from_pos, right)
	mvec3_mul(from_pos, -dis)
	mvec3_add(from_pos, center_pos)
	mvec3_set(to_pos, from_pos)
	mvec3_add(to_pos, down_vec)

	down_ray = World:raycast("ray", from_pos, to_pos, "slot_mask", 1)

	if down_ray then
		l_pos = down_ray.position
	else
		l_pos = to_pos

		mvec3_set_z(l_pos, at_pos.z)
	end

	local pose_fwd = fwd_pos

	mvec3_sub(pose_fwd, bwd_pos)

	local pose_l = l_pos

	mvec3_sub(pose_l, r_pos)

	local ground_normal = pose_fwd:cross(pose_l)

	mvec3_norm(ground_normal)

	return ground_normal
end

function CopActionHurt:on_exit()
	if self._shooting_hurt then
		self._shooting_hurt = false

		self._weapon_unit:base():stop_autofire()
	end

	if self._delayed_shooting_hurt_clbk_id then
		managers.enemy:remove_delayed_clbk(self._delayed_shooting_hurt_clbk_id)

		self._delayed_shooting_hurt_clbk_id = nil
	end

	if self._friendly_fire then
		self._unit:movement():set_friendly_fire(false)

		self._friendly_fire = nil
	end

	if self._modifier_on then
		self._machine:allow_modifier(self._head_modifier_name)
		self._machine:allow_modifier(self._arm_modifier_name)
	end

	if self._expired then
		CopActionWalk._chk_correct_pose(self)
	end

	if not self._expired and Network:is_server() then
		if self._hurt_type == "bleedout" or self._variant == "tase" then
			self._unit:network():send("action_hurt_end")
		end

		if self._hurt_type == "bleedout" then
			self._ext_inventory:equip_selection(2, true)
		end
	end
end

function CopActionHurt:_get_pos_clamped_to_graph(test_head)
	local tracker = self._ext_movement:nav_tracker()
	local r = tracker:field_position()
	local new_pos = tmp_vec1

	mvec3_set(new_pos, self._unit:get_animation_delta_position())
	mvec3_set_z(new_pos, 0)
	mvec3_add(new_pos, r)

	local ray_params

	if test_head then
		local h = tmp_vec2

		mvec3_set(h, self._common_data.ext_movement._obj_head:position())
		mvec3_set_z(h, new_pos.z)

		ray_params = {
			pos_to = h,
			trace = true,
			tracker_from = tracker,
		}

		local hit = managers.navigation:raycast(ray_params)
		local nh = ray_params.trace[1]
		local collision_side = ray_params.trace[2]

		if hit and collision_side then
			mvec3_set(tmp_vec3, managers.navigation._dir_str_to_vec[collision_side])
			mvec3_sub(h, nh)
			mvec3_set_z(h, 0)

			local error_amount = -mvec3_dot(tmp_vec3, h)

			mvec3_mul(tmp_vec3, error_amount)
			mvector3.add(new_pos, tmp_vec3)
		end
	else
		ray_params = {
			tracker_from = tracker,
		}
	end

	ray_params.pos_to = new_pos
	ray_params.trace = true

	managers.navigation:raycast(ray_params)
	mvector3.set(new_pos, ray_params.trace[1])

	return new_pos
end

function CopActionHurt:_upd_empty(t)
	return
end

function CopActionHurt:_upd_sick(t)
	if not self._sick_time or t > self._sick_time then
		self._expired = true
	end
end

function CopActionHurt:_upd_tased(t)
	if not self._tased_time or t > self._tased_time then
		if self._tased_down_time and t < self._tased_down_time then
			local redir_res = self._ext_movement:play_redirect("bleedout")

			if not redir_res then
				debug_pause("[CopActionHurt:init] bleedout redirect failed in", self._machine:segment_state(Idstring("base")))
			end

			self.update = self._upd_tased_down
		else
			self._expired = true
		end
	end
end

function CopActionHurt:_upd_tased_down(t)
	if not self._tased_down_time or t > self._tased_down_time then
		self._expired = true
	end
end

function CopActionHurt:_upd_hurt(t)
	local dt = TimerManager:game():delta_time()

	if self._ext_anim.hurt or self._ext_anim.death then
		if self._shooting_hurt then
			local weap_unit = self._weapon_unit
			local weap_unit_base = weap_unit:base()
			local shoot_from_pos = weap_unit:position()
			local shoot_fwd = weap_unit:rotation():y()

			weap_unit_base:trigger_held(shoot_from_pos, shoot_fwd, 3)

			if weap_unit_base.clip_empty and weap_unit_base:clip_empty() then
				self._shooting_hurt = false

				weap_unit_base:stop_autofire()
			end
		end

		self._last_pos = self:_get_pos_clamped_to_graph(true)

		CopActionWalk._set_new_pos(self, dt)

		local new_rot = self._unit:get_animation_delta_rotation()

		new_rot = self._common_data.rot * new_rot

		mrotation.set_yaw_pitch_roll(new_rot, new_rot:yaw(), 0, 0)

		if self._ext_anim.death then
			local rel_prog = math.clamp(self._machine:segment_relative_time(Idstring("base")), 0, 1)

			if self._floor_normal == nil then
				self._floor_normal = Vector3(0, 0, 1)
			end

			local normal = math.lerp(math.UP, self._floor_normal, rel_prog)
			local fwd = new_rot:y()

			mvec3_cross(tmp_vec1, fwd, normal)
			mvec3_cross(fwd, normal, tmp_vec1)

			new_rot = Rotation(fwd, normal)
		end

		self._ext_movement:set_rotation(new_rot)
	else
		if self._shooting_hurt then
			self._shooting_hurt = false

			self._weapon_unit:base():stop_autofire()
		end

		if self._hurt_type == "death" then
			self._died = true
		else
			self._expired = true
		end
	end
end

function CopActionHurt:_upd_bleedout(t)
	if self._floor_normal then
		local normal

		if self._ext_anim.bleedout_enter then
			local rel_t = self._machine:segment_relative_time(Idstring("base"))

			rel_t = math.min(1, rel_t + 0.5)

			local rel_prog = math.clamp(rel_t, 0, 1)

			normal = math.lerp(math.UP, self._floor_normal, rel_prog)

			self._ext_movement:set_m_pos(self._common_data.pos)
		else
			normal = self._floor_normal
			self._floor_normal = nil
		end

		mvec3_cross(tmp_vec1, self._common_data.fwd, normal)
		mvec3_cross(tmp_vec2, normal, tmp_vec1)

		local new_rot = Rotation(tmp_vec2, normal)

		self._ext_movement:set_rotation(new_rot)
	end

	if not self._ext_anim.bleedout_enter and self._weapon_unit then
		if self._attention and not self._ext_anim.reload and not self._ext_anim.equip then
			local autotarget, target_pos

			if self._attention.handler then
				target_pos = self._attention.handler:get_attention_m_pos()
			elseif self._attention.unit then
				target_pos = tmp_vec1

				self._attention.unit:character_damage():shoot_pos_mid(target_pos)
			else
				target_pos = self._attention.pos
			end

			local shoot_from_pos = self._ext_movement:m_head_pos()
			local target_vec = target_pos - shoot_from_pos
			local target_dis = mvec3_norm(target_vec)

			if not self._modifier_on then
				self._modifier_on = true

				self._machine:force_modifier(self._head_modifier_name)
				self._machine:force_modifier(self._arm_modifier_name)
			end

			if self._look_dir then
				local angle_diff = self._look_dir:angle(target_vec)
				local rot_speed_rel = math.pow(math.min(angle_diff / 90, 1), 0.5)
				local rot_speed = math.lerp(40, 360, rot_speed_rel)
				local dt = t - self._bleedout_look_t
				local rot_amount = math.min(rot_speed * dt, angle_diff)
				local diff_axis = self._look_dir:cross(target_vec)
				local rot = Rotation(diff_axis, rot_amount)

				self._look_dir = self._look_dir:rotate_with(rot)

				mvector3.normalize(self._look_dir)
			else
				self._look_dir = target_vec
			end

			self._bleedout_look_t = t

			self._head_modifier:set_target_z(self._look_dir)
			self._arm_modifier:set_target_y(self._look_dir)

			local aim_polar = self._look_dir:to_polar_with_reference(self._common_data.fwd, math.UP)
			local aim_spin_d90 = aim_polar.spin / 90
			local anim = self._machine:segment_state(Idstring("base"))
			local fwd = 1 - math.clamp(math.abs(aim_spin_d90), 0, 1)

			self._machine:set_parameter(anim, "angle0", fwd)

			local bwd = math.clamp(math.abs(aim_spin_d90), 1, 2) - 1

			self._machine:set_parameter(anim, "angle180", bwd)

			local l = 1 - math.clamp(math.abs(aim_spin_d90 - 1), 0, 1)

			self._machine:set_parameter(anim, "angle90neg", l)

			local r = 1 - math.clamp(math.abs(aim_spin_d90 + 1), 0, 1)

			self._machine:set_parameter(anim, "angle90", r)

			if t > self._shoot_t then
				if self._weapon_unit:base():clip_empty() then
					local res = CopActionReload._play_reload(self)

					if res then
						self._machine:set_speed(res, self._reload_speed)
					end
				elseif self._common_data.allow_fire then
					local falloff, i_range = CopActionShoot._get_shoot_falloff(self, target_dis, self._falloff)
					local spread = self._spread

					if autotarget then
						local new_target_pos = self._attention.handler and self._attention.handler:get_attention_m_pos() or CopActionShoot._get_unit_shoot_pos(self, self._attention.unit, t, target_pos, target_dis, self._w_usage_tweak)

						if new_target_pos then
							target_pos = new_target_pos
						else
							spread = math.min(20, spread)
						end
					end

					local spread_pos = tmp_vec2

					mvec3_rand_orth(spread_pos, target_vec)
					mvec3_set_l(spread_pos, spread)
					mvec3_add(spread_pos, target_pos)

					target_dis = mvec3_dir(target_vec, shoot_from_pos, spread_pos)

					local damage_multiplier = CopActionShoot._get_shoot_falloff_damage(self, self._falloff, target_dis, i_range)

					self._weapon_base:singleshot(shoot_from_pos, target_vec, damage_multiplier)

					local rand = math.random()

					self._shoot_t = t + math.lerp(falloff.recoil[1], falloff.recoil[2], rand)
				end
			end
		elseif self._modifier_on then
			self._modifier_on = false

			self._machine:allow_modifier(self._head_modifier_name)
			self._machine:allow_modifier(self._arm_modifier_name)
		end
	end
end

function CopActionHurt:_upd_ragdolled(t)
	local dt = TimerManager:game():delta_time()

	if self._shooting_hurt then
		local weap_unit = self._weapon_unit
		local weap_unit_base = weap_unit:base()
		local shoot_from_pos = weap_unit:position()
		local shoot_fwd = weap_unit:rotation():y()

		weap_unit_base:trigger_held(shoot_from_pos, shoot_fwd, 3)

		if weap_unit_base.clip_empty and weap_unit_base:clip_empty() then
			self._shooting_hurt = false

			weap_unit_base:stop_autofire()
		end
	end

	if self._ragdoll_active then
		self._hips_obj:m_position(tmp_vec1)
		self._ext_movement:set_position(tmp_vec1)
	end

	if not self._ragdoll_freeze_clbk_id and not self._shooting_hurt then
		self._died = true
	end
end

function CopActionHurt:type()
	return "hurt"
end

function CopActionHurt:hurt_type()
	return self._hurt_type
end

function CopActionHurt:expired()
	return self._expired
end

function CopActionHurt:chk_block(action_type, t)
	if CopActionAct.chk_block(self, action_type, t) then
		return true
	elseif action_type == "death" then
		-- block empty
	elseif (action_type == "hurt" or action_type == "heavy_hurt" or action_type == "hurt_sick" or action_type == "poison_hurt") and not self._ext_anim.hurt_exit then
		return true
	end
end

function CopActionHurt:on_attention(attention)
	self._attention = attention
end

function CopActionHurt:on_death_exit()
	if self._shooting_hurt then
		self._shooting_hurt = false

		self._weapon_unit:base():stop_autofire()
	end

	if not self._ragdolled then
		self._unit:set_animations_enabled(false)
	end
end

function CopActionHurt:on_death_drop(unit, stage)
	if self._weapon_dropped then
		return
	end

	if self._delayed_shooting_hurt_clbk_id then
		managers.enemy:remove_delayed_clbk(self._delayed_shooting_hurt_clbk_id)

		self._delayed_shooting_hurt_clbk_id = nil
	end

	if self._shooting_hurt then
		if stage == 2 then
			self._weapon_unit:base():stop_autofire()
			self._ext_inventory:drop_weapon()

			self._weapon_dropped = true
			self._shooting_hurt = false
		end
	elseif self._ext_inventory then
		self._ext_inventory:drop_weapon()

		self._weapon_dropped = true
	end
end

function CopActionHurt:body_part()
	return self._body_part
end

function CopActionHurt:need_upd()
	if self._died then
		return false
	else
		return true
	end
end

function CopActionHurt:on_inventory_event(event)
	local weapon_unit = self._ext_inventory:equipped_unit()

	if weapon_unit then
		local weap_tweak = weapon_unit:base():weapon_tweak_data()
		local weapon_usage_tweak = self._common_data.char_tweak.weapon[weap_tweak.usage]

		self._weapon_unit = weapon_unit
		self._weapon_base = weapon_unit:base()
		self._weap_tweak = weap_tweak
		self._w_usage_tweak = weapon_usage_tweak
		self._reload_speed = weapon_usage_tweak.RELOAD_SPEED
		self._spread = weapon_usage_tweak.spread
		self._falloff = weapon_usage_tweak.FALLOFF
		self._automatic_weap = weap_tweak.auto and true
	else
		self._weapon_unit = false
		self._shooting_hurt = false
	end
end

function CopActionHurt:save(save_data)
	for i, k in pairs(self._action_desc) do
		if type_name(k) ~= "Unit" or alive(k) then
			save_data[i] = k
		end
	end
end

function CopActionHurt:_start_ragdoll()
	if self._ragdolled then
		return true
	end

	if self._unit:damage() and self._unit:damage():has_sequence("switch_to_ragdoll") then
		self:on_death_drop(self._unit, 2)

		self._ragdolled = true

		self._unit:base():set_visibility_state(1)
		self._unit:set_driving("orientation_object")
		self._unit:anim_state_machine():set_enabled(false)
		self._unit:set_animations_enabled(false)

		local res = self._unit:damage():run_sequence_simple("switch_to_ragdoll")

		self._unit:add_body_activation_callback(callback(self, self, "clbk_body_active_state"))

		self._root_act_tags = {}

		local hips_body = self._unit:body("rag_Hips")
		local tag = hips_body:activate_tag()

		if tag == Idstring("") then
			tag = Idstring("root_follow")

			hips_body:set_activate_tag(tag)
		end

		self._root_act_tags[tag:key()] = true
		tag = hips_body:deactivate_tag()

		if tag == Idstring("") then
			tag = Idstring("root_follow")

			hips_body:set_deactivate_tag(tag)
		end

		self._root_act_tags[tag:key()] = true
		self._hips_obj = self._unit:get_object(Idstring("Hips"))
		self._ragdoll_active = true

		self._ext_movement:enable_update()

		local hips_pos = self._hips_obj:position()

		self._rag_pos = hips_pos
		self._ragdoll_freeze_clbk_id = "freeze_rag" .. tostring(self._unit:key())

		managers.enemy:add_delayed_clbk(self._ragdoll_freeze_clbk_id, callback(self, self, "clbk_chk_freeze_ragdoll"), TimerManager:game():time() + 3)

		if self._unit:anim_data().repel_loop then
			self._unit:sound():anim_clbk_play_sound(self._unit, "repel_end")
		end

		return true
	end
end

function CopActionHurt:force_ragdoll()
	if self:_start_ragdoll() then
		self.update = self._upd_ragdolled

		self._ext_movement:enable_update()
	end
end

function CopActionHurt:clbk_body_active_state(tag, unit, body, activated)
	if self._root_act_tags[tag:key()] then
		if activated then
			self._died = false
			self._ragdoll_active = true

			self._ext_movement:enable_update()
		else
			self._ragdoll_active = false

			if not self._shooting_hurt then
				self._died = true
			end
		end
	end
end

CopActionHurt._apply_freefall = CopActionWalk._apply_freefall

function CopActionHurt:_freeze_ragdoll()
	self._root_act_tags = {}

	if self._unit:damage() and self._unit:damage():has_sequence("freeze_ragdoll") then
		self._unit:damage():run_sequence_simple("freeze_ragdoll")
	end
end

function CopActionHurt:clbk_chk_freeze_ragdoll()
	if not alive(self._unit) then
		self._ragdoll_freeze_clbk_id = nil

		return
	end

	local t = TimerManager:game():time()

	self._hips_obj:m_position(tmp_vec1)

	local cur_dis = mvec3_dis(self._rag_pos, tmp_vec1)

	if cur_dis < 30 then
		self:_freeze_ragdoll()

		self._ragdoll_freeze_clbk_id = nil
	else
		mvec3_set(self._rag_pos, tmp_vec1)
		managers.enemy:add_delayed_clbk(self._ragdoll_freeze_clbk_id, callback(self, self, "clbk_chk_freeze_ragdoll"), t + 1.5)
	end
end

function CopActionHurt:clbk_shooting_hurt()
	self._delayed_shooting_hurt_clbk_id = nil

	if not alive(self._weapon_unit) then
		return
	end

	local fire_obj = self._weapon_unit:get_object(Idstring("fire"))

	if fire_obj then
		self._weapon_unit:base():singleshot(fire_obj:position(), fire_obj:rotation(), 1, false, nil, nil, nil, nil)
	end
end

function CopActionHurt:on_destroy()
	if self._shooting_hurt then
		self._shooting_hurt = false

		if alive(self._weapon_unit) then
			self._weapon_unit:base():stop_autofire()
		end
	end

	if self._fire_death_effects_key then
		managers.queued_tasks:unqueue(self._fire_death_effects_key)
		self:_remove_fire_death_effects()
	end

	if self._delayed_shooting_hurt_clbk_id then
		managers.enemy:remove_delayed_clbk(self._delayed_shooting_hurt_clbk_id)

		self._delayed_shooting_hurt_clbk_id = nil
	end
end
