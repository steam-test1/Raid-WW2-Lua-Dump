local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_div = mvector3.divide
local mvec3_norm = mvector3.normalize
local mvec3_len = mvector3.length
local mvec3_dot = mvector3.dot
local mvec3_set_z = mvector3.set_z
local mvec3_z = mvector3.z
local mvec3_set_len = mvector3.set_length
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_rot1 = Rotation()
local tmp_rot2 = Rotation()
local tmp_rot3 = Rotation()

HuskPlayerMovement = HuskPlayerMovement or class()
HuskPlayerMovement._ids_base = Idstring("base")
HuskPlayerMovement._default_weapon_index = 9
HuskPlayerMovement._calc_suspicion_ratio_and_sync = PlayerMovement._calc_suspicion_ratio_and_sync
HuskPlayerMovement.on_suspicion = PlayerMovement.on_suspicion
HuskPlayerMovement.state_enter_time = PlayerMovement.state_enter_time
HuskPlayerMovement.SO_access = PlayerMovement.SO_access
HuskPlayerMovement.on_revive_SO_verification = PlayerBleedOut.on_revive_SO_verification
HuskPlayerMovement.set_team = PlayerMovement.set_team
HuskPlayerMovement.team = PlayerMovement.team
HuskPlayerMovement.sync_net_event = PlayerMovement.sync_net_event
HuskPlayerMovement.set_friendly_fire = PlayerMovement.set_friendly_fire
HuskPlayerMovement.friendly_fire = PlayerMovement.friendly_fire
HuskPlayerMovement._walk_anim_velocities = {
	crouch = {
		cbt = {
			run = {
				bwd = 268.68,
				fwd = 312.25,
				l = 282.93,
				r = 282.93,
			},
			walk = {
				bwd = 163.74,
				fwd = 174.45,
				l = 152.14,
				r = 162.85,
			},
		},
	},
	stand = {
		cbt = {
			run = {
				bwd = 416.77,
				fwd = 414.73,
				l = 416.35,
				r = 411.9,
			},
			sprint = {
				79,
				35,
				14,
				9,
				bwd = 547,
				fwd = 672,
				l = 488,
				r = 547,
			},
			walk = {
				bwd = 208.27,
				fwd = 208.27,
				l = 192.75,
				r = 192.75,
			},
		},
		ntl = {
			run = {
				bwd = 402.62,
				fwd = 381.35,
				l = 405.06,
				r = 405.06,
			},
			walk = {
				bwd = 156.4,
				fwd = 183.48,
				l = 150.36,
				r = 152.15,
			},
		},
	},
}
HuskPlayerMovement._walk_anim_velocities.stand.hos = HuskPlayerMovement._walk_anim_velocities.stand.cbt
HuskPlayerMovement._walk_anim_velocities.crouch.hos = HuskPlayerMovement._walk_anim_velocities.crouch.cbt
HuskPlayerMovement._walk_anim_lengths = {
	crouch = {
		cbt = {
			run = {
				bwd = 20,
				fwd = 21,
				l = 19,
				r = 19,
			},
			run_start = {
				bwd = 16,
				fwd = 31,
				l = 30,
				r = 22,
			},
			run_start_turn = {
				bwd = 28,
				l = 21,
				r = 21,
			},
			run_stop = {
				bwd = 25,
				fwd = 27,
				l = 28,
				r = 26,
			},
			walk = {
				bwd = 31,
				fwd = 31,
				l = 27,
				r = 28,
			},
		},
	},
	panic = {
		ntl = {
			run = {
				bwd = 15,
				fwd = 15,
				l = 15,
				r = 16,
			},
		},
	},
	stand = {
		cbt = {
			run = {
				bwd = 18,
				fwd = 19,
				l = 18,
				r = 20,
			},
			run_start = {
				bwd = 25,
				fwd = 29,
				l = 27,
				r = 24,
			},
			run_start_turn = {
				bwd = 26,
				l = 37,
				r = 26,
			},
			run_stop = {
				bwd = 23,
				fwd = 29,
				l = 28,
				r = 31,
			},
			sprint = {
				bwd = 16,
				fwd = 16,
				l = 16,
				r = 19,
			},
			walk = {
				bwd = 26,
				fwd = 26,
				l = 26,
				r = 26,
			},
		},
		ntl = {
			run = {
				bwd = 17,
				fwd = 26,
				l = 20,
				r = 20,
			},
			walk = {
				bwd = 31,
				fwd = 31,
				l = 29,
				r = 31,
			},
		},
	},
	wounded = {
		cbt = {
			run = {
				bwd = 18,
				fwd = 19,
				l = 19,
				r = 19,
			},
			walk = {
				bwd = 29,
				fwd = 28,
				l = 29,
				r = 29,
			},
		},
	},
}

for _, stances in pairs(HuskPlayerMovement._walk_anim_lengths) do
	for _, speeds in pairs(stances) do
		for _, sides in pairs(speeds) do
			for side, speed in pairs(sides) do
				sides[side] = speed * 0.03333
			end
		end
	end
end

HuskPlayerMovement._walk_anim_lengths.stand.hos = HuskPlayerMovement._walk_anim_lengths.stand.cbt
HuskPlayerMovement._walk_anim_lengths.crouch.hos = HuskPlayerMovement._walk_anim_lengths.crouch.cbt
HuskPlayerMovement._matching_walk_anims = {
	bwd = {
		fwd = true,
	},
	fwd = {
		bwd = true,
	},
	l = {
		r = true,
	},
	r = {
		l = true,
	},
}
HuskPlayerMovement._stance_names = {
	"ntl",
	"hos",
	"cbt",
	"wnd",
}
HuskPlayerMovement._look_modifier_name = Idstring("action_upper_body")
HuskPlayerMovement._head_modifier_name = Idstring("look_head")
HuskPlayerMovement._arm_modifier_name = Idstring("aim_r_arm")
HuskPlayerMovement._mask_off_modifier_name = Idstring("look_mask_off")

function HuskPlayerMovement:init(unit)
	self._unit = unit
	self._machine = unit:anim_state_machine()
	self._crouch_detection_offset_z = mvec3_z(tweak_data.player.stances.default.crouched.head.translation)
	self._m_pos = unit:position()
	self._m_rot = unit:rotation()
	self._look_dir = self._m_rot:y()
	self._sync_look_dir = nil
	self._look_ang_vel = 0
	self._move_data = nil
	self._last_vel_z = 0
	self._remote_head_pos = Vector3()
	self._remote_pos = Vector3()
	self._sync_pos = nil
	self._sync_fall_dt = 0
	self._nav_tracker = nil
	self._look_modifier = self._machine:get_modifier(self._look_modifier_name)
	self._head_modifier = self._machine:get_modifier(self._head_modifier_name)
	self._arm_modifier = self._machine:get_modifier(self._arm_modifier_name)
	self._mask_off_modifier = self._machine:get_modifier(self._mask_off_modifier_name)
	self._aim_up_expire_t = nil
	self._is_weapon_gadget_on = nil

	local stance = {}

	self._stance = stance
	self._vehicle_shooting_stance = PlayerDriving.STANCE_NORMAL
	stance.names = self._stance_names
	stance.values = {
		1,
		0,
		0,
	}
	stance.blend = {
		0.8,
		0.5,
		0.3,
	}
	stance.code = 1
	stance.name = "ntl"
	stance.owner_stance_code = 2
	self._m_stand_pos = mvector3.copy(self._m_pos)

	mvector3.set_z(self._m_stand_pos, self._m_pos.z + tweak_data.player.PLAYER_EYE_HEIGHT)

	self._m_com = math.lerp(self._m_pos, self._m_stand_pos, 0.5)
	self._obj_head = unit:get_object(Idstring("Head"))
	self._obj_spine = unit:get_object(Idstring("Spine1"))
	self._m_head_rot = Rotation(self._look_dir, math.UP)
	self._m_head_pos = self._obj_head:position()
	self._m_detect_pos = mvector3.copy(self._m_head_pos)
	self._m_newest_pos = mvector3.copy(self._m_pos)
	self._footstep_style = nil
	self._footstep_event = ""
	self._state = "standard"
	self._state_enter_t = TimerManager:game():time()
	self._pose_code = 1
	self._tase_effect_table = {
		effect = tweak_data.common_effects.taser_hit,
		parent = self._unit:get_object(Idstring("e_taser")),
	}
	self._sequenced_events = {}
	self._synced_suspicion = false
	self._suspicion_ratio = false
	self._SO_access = managers.navigation:convert_access_flag("teamAI1")
	self._slotmask_gnd_ray = managers.slot:get_mask("player_ground_check")

	self:set_friendly_fire(true)

	self._auto_firing = 0
end

function HuskPlayerMovement:post_init()
	self._ext_anim = self._unit:anim_data()

	self._unit:inventory():add_listener("HuskPlayerMovement", {
		"equip",
	}, callback(self, self, "clbk_inventory_event"))

	if managers.navigation:is_data_ready() then
		self._nav_tracker = managers.navigation:create_nav_tracker(self._unit:position())
		self._standing_nav_seg_id = self._nav_tracker:nav_segment()
		self._pos_rsrv_id = managers.navigation:get_pos_reservation_id()
	end

	self._unit:inventory():synch_equipped_weapon(WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID, "thompson")

	self._attention_handler = CharacterAttentionObject:new(self._unit)

	if Network:is_server() then
		self._attention_handler:setup_attention_positions(self._remote_head_pos, self._remote_pos)
	else
		self._attention_handler:setup_attention_positions(self._m_head_pos, self._m_pos)
	end

	local network_peer = managers.network:session():peer_by_unit(self._unit)

	if network_peer then
		self:set_player_class(network_peer:class())
	else
		self:set_player_class(SkillTreeTweakData.CLASS_RECON)
	end

	self._enemy_weapons_hot_listen_id = "PlayerMovement" .. tostring(self._unit:key())

	managers.groupai:state():add_listener(self._enemy_weapons_hot_listen_id, {
		"enemy_weapons_hot",
	}, callback(self, PlayerMovement, "clbk_enemy_weapons_hot"))
end

function HuskPlayerMovement:set_character_anim_variables()
	local char_name = managers.criminals:character_name_by_unit(self._unit)

	if not char_name then
		return
	end

	self._machine:set_global("husk", 1)
	self:check_visual_equipment()
	self._unit:contour():update_materials()
	self._unit:contour():add("teammate", nil, nil)

	local color_id = managers.criminals:character_color_id_by_unit(self._unit)

	if color_id then
		self._unit:contour():change_color("teammate", tweak_data.peer_vector_colors[color_id])
	end
end

function HuskPlayerMovement:check_visual_equipment()
	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local carry_data = managers.player:get_synced_carry(peer_id)

	if carry_data then
		self:set_visual_carry(carry_data.carry_id)
	end
end

function HuskPlayerMovement:set_visual_carry(carry_id)
	if not carry_id then
		self:_destroy_current_carry_unit()

		return
	end

	local carry_tweak = tweak_data.carry[carry_id]

	if not carry_tweak then
		return
	end

	if not carry_tweak.visual_unit_name then
		self:_create_carry_unit(tweak_data.carry.default_visual_unit, tweak_data.carry.default_visual_unit_joint_array, tweak_data.carry.default_visual_unit_root_joint)

		return
	end

	self:_create_carry_unit(carry_tweak.visual_unit_name, carry_tweak.visual_unit_joint_array, carry_tweak.visual_unit_root_joint)
end

function HuskPlayerMovement:_destroy_current_carry_unit()
	if alive(self._current_carry_unit) then
		self._current_carry_unit:set_slot(0)

		self._current_carry_unit = nil
	end
end

function HuskPlayerMovement:_create_carry_unit(unit_name, joint_array, root_joint)
	self:_destroy_current_carry_unit()

	self._current_carry_unit = safe_spawn_unit(Idstring(unit_name), self._unit:position())

	self._unit:link(Idstring(root_joint), self._current_carry_unit, self._current_carry_unit:orientation_object():name())

	if joint_array then
		for _, o_name in ipairs(joint_array) do
			local ids_object = Idstring(o_name)
			local player_align = self._unit:get_object(ids_object)
			local carry_align = self._current_carry_unit:get_object(ids_object)

			carry_align:link(player_align)
			carry_align:set_position(player_align:position())
			carry_align:set_rotation(player_align:rotation())
		end
	end
end

function HuskPlayerMovement:update(unit, t, dt)
	if self._wait_load then
		return
	end

	self:_calculate_m_pose()
	self:_upd_sequenced_events(t, dt)

	if self._attention_updator then
		self._attention_updator(dt)
	end

	if not self._movement_updator and self._move_data and (self._state == "standard" or self._state == "carry" or self._state == "carry_corpse") then
		self._movement_updator = callback(self, self, "_upd_move_standard")
		self._last_vel_z = 0
	end

	if self._movement_updator then
		self._movement_updator(t, dt)
	end

	self:_upd_stance(t)

	if not self._peer_weapon_spawned and alive(self._unit) then
		local inventory = self._unit:inventory()

		if inventory and inventory.check_peer_weapon_spawn then
			self._peer_weapon_spawned = inventory:check_peer_weapon_spawn()
		else
			self._peer_weapon_spawned = true
		end
	end

	if self._auto_firing >= 2 then
		self._aim_up_expire_t = TimerManager:game():time() + 2
	end
end

function HuskPlayerMovement:enable_update()
	return
end

function HuskPlayerMovement:sync_look_dir(fwd)
	self._sync_look_dir = fwd
end

function HuskPlayerMovement:set_look_dir_instant(fwd)
	mvector3.set(self._look_dir, fwd)
	self._look_modifier:set_target_y(self._look_dir)

	self._sync_look_dir = nil
end

function HuskPlayerMovement:m_pos()
	return self._m_pos
end

function HuskPlayerMovement:m_stand_pos()
	return self._m_stand_pos
end

function HuskPlayerMovement:m_com()
	return self._m_com
end

function HuskPlayerMovement:m_head_rot()
	return self._m_head_rot
end

function HuskPlayerMovement:m_head_pos()
	return self._m_head_pos
end

function HuskPlayerMovement:m_detect_pos()
	return self._m_detect_pos
end

function HuskPlayerMovement:m_newest_pos()
	return self._m_newest_pos
end

function HuskPlayerMovement:m_rot()
	return self._m_rot
end

function HuskPlayerMovement:get_object(object_name)
	return self._unit:get_object(object_name)
end

function HuskPlayerMovement:detect_look_dir()
	return self._sync_look_dir or self._look_dir
end

function HuskPlayerMovement:look_dir()
	return self._look_dir
end

function HuskPlayerMovement:_calculate_m_pose()
	mrotation.set_look_at(self._m_head_rot, self._look_dir, math.UP)
	self._obj_head:m_position(self._m_head_pos)
	self._obj_spine:m_position(self._m_com)

	local det_pos = self._m_detect_pos

	if self._move_data then
		local path = self._move_data.path

		mvector3.set(det_pos, path[#path])
		mvector3.set(self._m_newest_pos, det_pos)
	else
		mvector3.set(det_pos, self._m_pos)
		mvector3.set(self._m_newest_pos, self._m_pos)
	end

	local offset_z = self._pose_code == 2 and self._crouch_detection_offset_z or mvec3_z(self._m_head_pos) - mvec3_z(self._m_pos)

	mvec3_set_z(det_pos, mvec3_z(det_pos) + offset_z)
end

function HuskPlayerMovement:set_position(pos)
	mvector3.set(self._m_pos, pos)
	self._unit:set_position(pos)

	if self._nav_tracker then
		self._nav_tracker:move(pos)

		local nav_seg_id = self._nav_tracker:nav_segment()

		if self._standing_nav_seg_id ~= nav_seg_id then
			self._standing_nav_seg_id = nav_seg_id

			local metadata = managers.navigation:get_nav_seg_metadata(nav_seg_id)

			self._unit:base():set_suspicion_multiplier("area", metadata.suspicion_mul)
			self._unit:base():set_detection_multiplier("area", metadata.detection_mul and 1 / metadata.detection_mul or nil)
			managers.groupai:state():on_criminal_nav_seg_change(self._unit, nav_seg_id)
		end
	end
end

function HuskPlayerMovement:get_location_id()
	return self._standing_nav_seg_id and managers.navigation:get_nav_seg_metadata(self._standing_nav_seg_id).location_id or nil
end

function HuskPlayerMovement:set_rotation(rot)
	mrotation.set_yaw_pitch_roll(self._m_rot, rot:yaw(), 0, 0)
	self._unit:set_rotation(rot)
end

function HuskPlayerMovement:set_m_rotation(rot)
	mrotation.set_yaw_pitch_roll(self._m_rot, rot:yaw(), 0, 0)
end

function HuskPlayerMovement:nav_tracker()
	return self._nav_tracker
end

function HuskPlayerMovement:play_redirect(redirect_name, at_time)
	if not redirect_name then
		return
	end

	local result = self._unit:play_redirect(Idstring(redirect_name), at_time)

	result = result ~= IDS_EMPTY and result

	if not result then
		print("[HuskPlayerMovement:play_redirect] redirect", redirect_name, "failed in", self._machine:segment_state(self._ids_base), self._machine:segment_state(Idstring("upper_body")))
		Application:stack_dump()
	end

	return result
end

function HuskPlayerMovement:play_redirect_idstr(redirect_name, at_time)
	if not redirect_name then
		return
	end

	local result = self._unit:play_redirect(redirect_name, at_time)

	result = result ~= IDS_EMPTY and result

	if not result then
		print("[HuskPlayerMovement:play_redirect_idstr] redirect", redirect_name, "failed in", self._machine:segment_state(self._ids_base), self._machine:segment_state(Idstring("upper_body")))
		Application:stack_dump()
	end

	return result
end

function HuskPlayerMovement:_play_equip_weapon()
	local redir_res = self:play_redirect("equip")

	if redir_res then
		local weapon = self._unit:inventory():equipped_unit()

		if weapon then
			self._unit:inventory():show_equipped_unit()

			local weap_tweak = weapon:base():weapon_tweak_data()
			local weapon_hold = weap_tweak.hold

			self._machine:set_parameter(redir_res, "to_" .. weapon_hold, 1)
		end
	end
end

function HuskPlayerMovement:play_state(state_name, at_time)
	if not state_name then
		return
	end

	local result = self._unit:play_state(Idstring(state_name), at_time)

	result = result ~= IDS_EMPTY and result

	if not result then
		print("[HuskPlayerMovement:play_state] state", state_name, "failed in", self._machine:segment_state(self._ids_base), self._machine:segment_state(Idstring("upper_body")))
		Application:stack_dump()
	end

	return result
end

function HuskPlayerMovement:play_state_idstr(state_name, at_time)
	if not state_name then
		return
	end

	local result = self._unit:play_state(state_name, at_time)

	result = result ~= IDS_EMPTY and result

	if not result then
		print("[HuskPlayerMovement:play_state_idstr] state", state_name, "failed in", self._machine:segment_state(self._ids_base), self._machine:segment_state(Idstring("upper_body")))
		Application:stack_dump()
	end

	return result
end

function HuskPlayerMovement:anim_cbk_set_melee_item_state_vars(unit)
	local state = self._unit:anim_state_machine():segment_state(Idstring("upper_body"))
	local anim_attack_vars = {
		"var1",
		"var2",
	}

	self._unit:anim_state_machine():set_parameter(state, anim_attack_vars[math.random(#anim_attack_vars)], 1)

	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local peer = managers.network:session():peer(peer_id)
	local melee_entry = peer:melee_id()
	local anim_global_param = tweak_data.blackmarket.melee_weapons[melee_entry].anim_global_param

	self._unit:anim_state_machine():set_parameter(state, anim_global_param, 1)
end

function HuskPlayerMovement:anim_cbk_spawn_melee_item(unit, graphic_object)
	if alive(self._melee_item_unit) or not managers.network:session() or not managers.network:session():peer_by_unit(self._unit) then
		return
	end

	local align_obj_name = Idstring("a_weapon_left_front")
	local align_obj = self._unit:get_object(align_obj_name)
	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local peer = managers.network:session():peer(peer_id)
	local melee_entry = peer:melee_id()
	local graphic_object_name = Idstring(graphic_object)
	local graphic_objects = tweak_data.blackmarket.melee_weapons[melee_entry].graphic_objects or {}
	local unit_name = tweak_data.blackmarket.melee_weapons[melee_entry].third_unit

	if unit_name then
		self._melee_item_unit = World:spawn_unit(Idstring(unit_name), align_obj:position(), align_obj:rotation())

		self._unit:link(align_obj:name(), self._melee_item_unit, self._melee_item_unit:orientation_object():name())

		for a_object, g_object in pairs(graphic_objects) do
			local g_obj_name = Idstring(g_object)
			local g_obj = self._melee_item_unit:get_object(g_obj_name)

			g_obj:set_visibility(Idstring(a_object) == graphic_object_name)
		end

		if alive(self._unit:inventory():equipped_unit()) and self._unit:inventory():equipped_unit():base().AKIMBO then
			self._unit:inventory():equipped_unit():base():on_melee_item_shown()
		end

		if self._unit:inventory().on_melee_item_shown then
			self._unit:inventory():on_melee_item_shown()
		end
	end
end

function HuskPlayerMovement:anim_cbk_unspawn_melee_item(unit)
	if alive(self._melee_item_unit) then
		self._melee_item_unit:unlink()
		World:delete_unit(self._melee_item_unit)

		self._melee_item_unit = nil

		if alive(self._unit:inventory():equipped_unit()) and self._unit:inventory():equipped_unit():base().AKIMBO then
			self._unit:inventory():equipped_unit():base():on_melee_item_hidden()
		end
	end

	if self._unit:inventory().on_melee_item_hidden then
		self._unit:inventory():on_melee_item_hidden()
	end
end

function HuskPlayerMovement:set_need_revive(need_revive, down_time)
	if self._need_revive == need_revive then
		return
	end

	self._unit:character_damage():set_last_down_time(down_time)

	self._need_revive = need_revive

	self._unit:interaction():set_active(need_revive, false, down_time)

	if Network:is_server() then
		if need_revive and not self._revive_SO_id and not self._revive_rescuer then
			self:_register_revive_SO()
		elseif not need_revive and (self._revive_SO_id or self._revive_rescuer or self._deathguard_SO_id) then
			self:_unregister_revive_SO()
		end
	end
end

function HuskPlayerMovement:set_player_class(class)
	self._player_class = class
	self._class_tweak_data = tweak_data.player:get_tweak_data_for_class(self._player_class)
end

function HuskPlayerMovement:_register_revive_SO()
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
			variant = "revive",
		},
		action_duration = tweak_data.interaction.revive.timer,
		called = true,
		complete_clbk = callback(self, self, "on_revive_SO_completed"),
		destroy_clbk_key = false,
		fail_clbk = callback(self, self, "on_revive_SO_failed"),
		follow_unit = self._unit,
		followup_objective = followup_objective,
		haste = "run",
		nav_seg = self._unit:movement():nav_tracker():nav_segment(),
		pose = "stand",
		scan = true,
		type = "revive",
	}
	local so_descriptor = {
		AI_group = "friendlies",
		admin_clbk = callback(self, self, "on_revive_SO_administered"),
		base_chance = 1,
		chance_inc = 0,
		interval = 1,
		objective = objective,
		search_pos = self._unit:position(),
		usage_amount = 1,
		verification_clbk = callback(HuskPlayerMovement, HuskPlayerMovement, "on_revive_SO_verification", self._unit),
	}
	local so_id = "PlayerHusk_revive" .. tostring(self._unit:key())

	self._revive_SO_id = so_id

	managers.groupai:state():add_special_objective(so_id, so_descriptor)

	if not self._deathguard_SO_id then
		self._deathguard_SO_id = PlayerBleedOut._register_deathguard_SO(self._unit)
	end
end

function HuskPlayerMovement:_unregister_revive_SO()
	if self._deathguard_SO_id then
		PlayerBleedOut._unregister_deathguard_SO(self._deathguard_SO_id)

		self._deathguard_SO_id = nil
	end

	if self._revive_rescuer then
		local rescuer = self._revive_rescuer

		self._revive_rescuer = nil

		rescuer:brain():set_objective(nil)
	elseif self._revive_SO_id then
		managers.groupai:state():remove_special_objective(self._revive_SO_id)

		self._revive_SO_id = nil
	end

	if self._sympathy_civ then
		local sympathy_civ = self._sympathy_civ

		self._sympathy_civ = nil

		sympathy_civ:brain():set_objective(nil)
	end
end

function HuskPlayerMovement:set_need_assistance(need_assistance)
	if self._need_assistance == need_assistance then
		return
	end

	self._need_assistance = need_assistance

	if Network:is_server() then
		if need_assistance and not self._assist_SO_id then
			local objective = {
				called = true,
				destroy_clbk_key = false,
				follow_unit = self._unit,
				nav_seg = self._unit:movement():nav_tracker():nav_segment(),
				scan = true,
				type = "follow",
			}
			local so_descriptor = {
				AI_group = "friendlies",
				base_chance = 1,
				chance_inc = 0,
				interval = 6,
				objective = objective,
				search_dis_sq = 25000000,
				search_pos = self._unit:position(),
				usage_amount = 1,
			}
			local so_id = "PlayerHusk_assistance" .. tostring(self._unit:key())

			self._assist_SO_id = so_id

			managers.groupai:state():add_special_objective(so_id, so_descriptor)
		elseif not need_assistance and self._assist_SO_id then
			managers.groupai:state():remove_special_objective(self._assist_SO_id)

			self._assist_SO_id = nil
		end
	end
end

function HuskPlayerMovement:on_revive_SO_administered(receiver_unit)
	if self._revive_SO_id then
		self._revive_rescuer = receiver_unit
		self._revive_SO_id = nil
	end
end

function HuskPlayerMovement:on_revive_SO_failed(rescuer)
	if self._revive_rescuer then
		self._revive_rescuer = nil

		self:_register_revive_SO()
	end
end

function HuskPlayerMovement:on_revive_SO_completed(rescuer)
	self._revive_rescuer = nil

	self:_unregister_revive_SO()
end

function HuskPlayerMovement:need_revive()
	return self._need_revive
end

function HuskPlayerMovement:downed()
	return self._need_revive or self._need_assistance
end

function HuskPlayerMovement:_upd_attention_standard(dt)
	if not self._atention_on then
		if self._ext_anim.bleedout then
			if self._sync_look_dir and self._sync_look_dir ~= self._look_dir then
				self._look_dir = mvector3.copy(self._sync_look_dir)
			end

			return
		else
			self._atention_on = true

			self._machine:force_modifier(self._look_modifier_name)
		end
	end

	if self._sync_look_dir then
		local tar_look_dir = tmp_vec1

		mvec3_set(tar_look_dir, self._sync_look_dir)

		local wait_for_turn
		local hips_fwd = tmp_vec2

		mrotation.y(self._m_rot, hips_fwd)

		local hips_err_spin = tar_look_dir:to_polar_with_reference(hips_fwd, math.UP).spin
		local max_spin = 60
		local min_spin = -90

		if max_spin < hips_err_spin or hips_err_spin < min_spin then
			wait_for_turn = true

			if max_spin < hips_err_spin then
				mvector3.rotate_with(tar_look_dir, Rotation(max_spin - hips_err_spin))
			else
				mvector3.rotate_with(tar_look_dir, Rotation(min_spin - hips_err_spin))
			end
		end

		local error_angle = tar_look_dir:angle(self._look_dir)
		local rot_speed_rel = math.pow(math.min(error_angle / 90, 1), 0.5)
		local rot_speed = math.lerp(40, 360, rot_speed_rel)
		local rot_amount = math.min(rot_speed * dt, error_angle)
		local error_axis = self._look_dir:cross(tar_look_dir)
		local rot_adj = Rotation(error_axis, rot_amount)

		self._look_dir = self._look_dir:rotate_with(rot_adj)

		self._look_modifier:set_target_y(self._look_dir)

		if rot_amount == error_angle and not wait_for_turn then
			self._sync_look_dir = nil
		end
	end
end

function HuskPlayerMovement:_upd_attention_bleedout(dt)
	if self._sync_look_dir then
		local fwd = self._m_rot:y()

		if self._atention_on then
			if self._ext_anim.reload then
				self._atention_on = false

				local blend_out_t = 0.15

				self._machine:set_modifier_blend(self._head_modifier_name, blend_out_t)
				self._machine:set_modifier_blend(self._arm_modifier_name, blend_out_t)
				self._machine:forbid_modifier(self._head_modifier_name)
				self._machine:forbid_modifier(self._arm_modifier_name)
			end
		elseif self._ext_anim.bleedout_falling or self._ext_anim.reload then
			if self._sync_look_dir ~= self._look_dir then
				self._look_dir = mvector3.copy(self._sync_look_dir)
			end

			return
		else
			self._atention_on = true

			self._machine:force_modifier(self._head_modifier_name)
			self._machine:force_modifier(self._arm_modifier_name)
		end

		local error_angle = self._sync_look_dir:angle(self._look_dir)
		local rot_speed_rel = math.pow(math.min(error_angle / 90, 1), 0.5)
		local rot_speed = math.lerp(40, 360, rot_speed_rel)
		local rot_amount = math.min(rot_speed * dt, error_angle)
		local error_axis = self._look_dir:cross(self._sync_look_dir)
		local rot_adj = Rotation(error_axis, rot_amount)

		self._look_dir = self._look_dir:rotate_with(rot_adj)

		self._arm_modifier:set_target_y(self._look_dir)
		self._head_modifier:set_target_z(self._look_dir)

		local aim_polar = self._look_dir:to_polar_with_reference(fwd, math.UP)
		local aim_spin = aim_polar.spin
		local anim = self._machine:segment_state(self._ids_base)
		local fwd = 1 - math.clamp(math.abs(aim_spin / 90), 0, 1)

		self._machine:set_parameter(anim, "angle0", fwd)

		local bwd = math.clamp(math.abs(aim_spin / 90), 1, 2) - 1

		self._machine:set_parameter(anim, "angle180", bwd)

		local l = 1 - math.clamp(math.abs(aim_spin / 90 - 1), 0, 1)

		self._machine:set_parameter(anim, "angle90neg", l)

		local r = 1 - math.clamp(math.abs(aim_spin / 90 + 1), 0, 1)

		self._machine:set_parameter(anim, "angle90", r)

		if rot_amount == error_angle then
			self._sync_look_dir = nil
		end
	end
end

function HuskPlayerMovement:_upd_attention_zipline(dt)
	if self._sync_look_dir then
		if self._atention_on then
			if self._ext_anim.reload then
				self._atention_on = false

				local blend_out_t = 0.15

				self._machine:set_modifier_blend(self._head_modifier_name, blend_out_t)
				self._machine:set_modifier_blend(self._arm_modifier_name, blend_out_t)
				self._machine:forbid_modifier(self._head_modifier_name)
				self._machine:forbid_modifier(self._arm_modifier_name)
			end
		elseif self._ext_anim.reload then
			if self._sync_look_dir ~= self._look_dir then
				self._look_dir = mvector3.copy(self._sync_look_dir)
			end

			return
		else
			self._atention_on = true

			self._machine:force_modifier(self._head_modifier_name)
			self._machine:force_modifier(self._arm_modifier_name)
		end

		local max_yaw_from_rp = 90
		local min_yaw_from_rp = -90
		local root_yaw = mrotation.yaw(self._m_rot)
		local look_rot = tmp_rot1

		mrotation.set_look_at(look_rot, self._sync_look_dir, math.UP)

		local look_yaw = mrotation.yaw(look_rot)
		local look_yaw_relative = look_yaw - root_yaw

		if math.abs(look_yaw_relative) > 180 then
			look_yaw_relative = look_yaw_relative - math.sign(look_yaw_relative) * 180
		end

		local out_of_bounds

		if max_yaw_from_rp < look_yaw_relative or look_yaw_relative < min_yaw_from_rp then
			out_of_bounds = true
			look_yaw_relative = math.clamp(look_yaw_relative, min_yaw_from_rp, max_yaw_from_rp)
		end

		local old_look_rot = tmp_rot2

		mrotation.set_look_at(old_look_rot, self._look_dir, math.UP)

		local old_look_yaw = mrotation.yaw(old_look_rot)
		local old_look_yaw_relative = old_look_yaw - root_yaw

		if math.abs(old_look_yaw_relative) > 180 then
			old_look_yaw_relative = old_look_yaw_relative - math.sign(old_look_yaw_relative) * 180
		end

		local yaw_diff = look_yaw_relative - old_look_yaw_relative
		local pitch_diff = mrotation.pitch(look_rot) - mrotation.pitch(old_look_rot)
		local yaw_step = math.lerp(40, 400, (math.min(math.abs(yaw_diff), 20) / 20)^2) * dt

		yaw_step = math.sign(yaw_diff) * math.min(yaw_step, math.abs(yaw_diff))

		local pitch_step = math.lerp(30, 250, (math.min(math.abs(pitch_diff), 20) / 20)^2) * dt

		pitch_step = math.sign(pitch_diff) * math.min(pitch_step, math.abs(pitch_diff))

		local new_yaw = old_look_yaw + yaw_step
		local out_of_bounds

		if max_yaw_from_rp < new_yaw - root_yaw or min_yaw_from_rp > new_yaw - root_yaw then
			new_yaw = math.clamp(new_yaw, min_yaw_from_rp, max_yaw_from_rp)
		end

		if look_yaw_relative == 0 and new_yaw == look_yaw and pitch_diff == pitch_step and not out_of_bounds then
			self._sync_look_dir = nil
		end

		local new_rot = tmp_rot3

		mrotation.set_yaw_pitch_roll(new_rot, new_yaw, mrotation.pitch(old_look_rot) + pitch_step, 0)
		mrotation.y(new_rot, self._look_dir)
		self._arm_modifier:set_target_y(self._look_dir)
		self._head_modifier:set_target_z(self._look_dir)

		local aim_spin = new_yaw - root_yaw

		if math.abs(aim_spin) > 180 then
			aim_spin = aim_spin - math.sign(aim_spin) * 180
		end

		local anim = self._machine:segment_state(self._ids_base)
		local fwd = 1 - math.clamp(math.abs(aim_spin / 90), 0, 1)
		local l = math.clamp(aim_spin / max_yaw_from_rp, 0, 1)
		local r = math.clamp(aim_spin / min_yaw_from_rp, 0, 1)

		self._machine:set_parameter(anim, "fwd", fwd)
		self._machine:set_parameter(anim, "l", l)
		self._machine:set_parameter(anim, "r", r)
	end
end

function HuskPlayerMovement:_upd_attention_driving(dt)
	if not alive(self._vehicle_unit) then
		return
	end

	if self._driver and not self._vehicle_unit:get_state_name() == VehicleDrivingExt.STATE_INACTIVE then
		local steer = self._vehicle:get_steer()
		local anim = self._machine:segment_state(self._ids_base)
		local r = math.clamp(-steer, 0, 1)
		local l = math.clamp(steer, 0, 1)
		local fwd = math.clamp(1 - steer, 0, 1)

		self._machine:set_parameter(anim, "fwd", fwd)
		self._machine:set_parameter(anim, "l", l)
		self._machine:set_parameter(anim, "r", r)
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:force_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)

		if self._sync_look_dir then
			self:update_sync_look_dir(dt)
		end

		return
	end

	if not self._sync_look_dir then
		return
	end

	if self._atention_on then
		self._atention_on = false

		if self._ext_anim.reload then
			self._atention_on = false

			local blend_out_t = 0.15

			self._machine:set_modifier_blend(self._arm_modifier_name, blend_out_t)
			self._machine:set_modifier_blend(self._head_modifier_name, blend_out_t)
			self._machine:set_modifier_blend(self._look_modifier_name, blend_out_t)
			self._machine:forbid_modifier(self._head_modifier_name)
			self._machine:forbid_modifier(self._arm_modifier_name)
			self._machine:forbid_modifier(self._look_modifier_name)
		end
	elseif self._ext_anim.reload then
		if self._sync_look_dir ~= self._look_dir then
			self._look_dir = mvector3.copy(self._sync_look_dir)
		end

		return
	else
		self._atention_on = true

		if self._vehicle_shooting_stance == PlayerDriving.STANCE_NORMAL and not self._allow_shooting then
			self._machine:forbid_modifier(self._look_modifier_name)
			self._machine:force_modifier(self._head_modifier_name)
			self._machine:forbid_modifier(self._arm_modifier_name)
		else
			self._machine:force_modifier(self._look_modifier_name)
			self._machine:forbid_modifier(self._head_modifier_name)
			self._machine:forbid_modifier(self._arm_modifier_name)
		end
	end

	self:update_sync_look_dir(dt)

	local fwd = self._m_rot:y()
	local spin = fwd:to_polar_with_reference(self._look_dir, math.UP).spin
	local anim = self._machine:segment_state(self._ids_base)
	local aim_spin = spin

	fwd = math.clamp(1 - math.abs(aim_spin) / 45, 0, 1)

	local bwd = math.clamp(1 - (180 - math.abs(aim_spin)) / 45, 0, 1)
	local l, r

	if aim_spin > 0 then
		r = 1 - fwd - bwd
		l = 0
	else
		l = 1 - fwd - bwd
		r = 0
	end

	self._machine:set_parameter(anim, "fwd", fwd)
	self._machine:set_parameter(anim, "l", l)
	self._machine:set_parameter(anim, "r", r)
	self._machine:set_parameter(anim, "bwd", bwd)
	self._machine:set_parameter(anim, "team_ai", 0)
end

function HuskPlayerMovement:update_sync_look_dir(dt)
	local tar_look_dir = tmp_vec1

	mvec3_set(tar_look_dir, self._sync_look_dir)

	local error_angle = tar_look_dir:angle(self._look_dir)
	local rot_speed_rel = math.pow(math.min(error_angle / 90, 1), 0.5)
	local rot_speed = math.lerp(40, 360, rot_speed_rel)
	local rot_amount = math.min(rot_speed * dt, error_angle)
	local error_axis = self._look_dir:cross(tar_look_dir)
	local rot_adj = Rotation(error_axis, rot_amount)

	self._look_dir = self._look_dir:rotate_with(rot_adj)

	if self._vehicle_shooting_stance == PlayerDriving.STANCE_NORMAL and not self._allow_shooting then
		self._head_modifier:set_target_z(self._look_dir)
	else
		self._look_modifier:set_target_y(self._look_dir)
		self._arm_modifier:set_target_y(self._look_dir)
		self._head_modifier:set_target_z(self._look_dir)
	end

	if rot_amount == error_angle then
		self._sync_look_dir = nil
	end
end

function HuskPlayerMovement:_upd_attention_tased(dt)
	return
end

function HuskPlayerMovement:_upd_attention_disarmed(dt)
	return
end

function HuskPlayerMovement:_upd_sequenced_events(t, dt)
	local sequenced_events = self._sequenced_events
	local next_event = sequenced_events[1]

	if not next_event then
		return
	end

	if next_event.commencing then
		return
	end

	if self._tase_effect then
		World:effect_manager():fade_kill(self._tase_effect)
	end

	local event_type = next_event.type

	self:_cleanup_previous_state(next_event.previous_state)

	if event_type == "move" then
		next_event.commencing = true

		self:_start_movement(next_event.path)
	elseif event_type == "bleedout" then
		if self:_start_bleedout(next_event) then
			table.remove(sequenced_events, 1)
		end
	elseif event_type == "tased" then
		if self:_start_tased(next_event) then
			table.remove(sequenced_events, 1)
		end
	elseif event_type == "standard" then
		if self:_start_standard(next_event) then
			table.remove(sequenced_events, 1)
		end
	elseif event_type == "dead" then
		if self:_start_dead(next_event) then
			table.remove(sequenced_events, 1)
		end
	elseif event_type == "zipline" then
		next_event.commencing = true

		self:_start_zipline(next_event)
	elseif event_type == "driving" then
		if self:_start_driving(next_event) then
			table.remove(sequenced_events, 1)
		end
	elseif event_type == "jump" then
		self:_start_jumping(next_event)
	end

	local event_type = next_event and not next_event.commencing and next_event.type

	if event_type == "freefall" then
		if self:_start_freefall(next_event) then
			table.remove(sequenced_events, 1)
		end
	elseif event_type == "parachuting" and self:_start_parachute(next_event) then
		table.remove(sequenced_events, 1)
	end
end

function HuskPlayerMovement:_add_sequenced_event(event_desc)
	table.insert(self._sequenced_events, event_desc)
end

function HuskPlayerMovement:_upd_stance(t)
	if self._aim_up_expire_t and t > self._aim_up_expire_t then
		self._aim_up_expire_t = nil

		self:_chk_change_stance()
	end

	local stance = self._stance

	if stance.transition then
		local transition = stance.transition

		if t > transition.next_upd_t then
			transition.next_upd_t = t + 0.033

			local values = stance.values
			local prog = (t - transition.start_t) / transition.duration

			if prog < 1 then
				local prog_smooth = math.clamp(math.bezier({
					0,
					0,
					1,
					1,
				}, prog), 0, 1)
				local v_start = transition.start_values
				local v_end = transition.end_values
				local mlerp = math.lerp

				for i, v in ipairs(v_start) do
					values[i] = mlerp(v, v_end[i], prog_smooth)
				end
			else
				for i, v in ipairs(transition.end_values) do
					values[i] = v
				end

				if transition.delayed_shot then
					self:_shoot_blank(1)
				end

				stance.transition = nil
			end

			local names = stance.names

			for i, v in ipairs(values) do
				self._machine:set_global(names[i], values[i])
			end
		end
	end
end

function HuskPlayerMovement:_upd_slow_pos_reservation(t, dt)
	local slow_dist = 100

	mvec3_set(tmp_vec2, self._pos_reservation_slow.position)
	mvec3_sub(tmp_vec2, self._pos_reservation.position)

	if slow_dist < mvec3_norm(tmp_vec2) then
		mvec3_mul(tmp_vec2, slow_dist)
		mvec3_add(tmp_vec2, self._pos_reservation.position)
		mvec3_set(self._pos_reservation_slow.position, tmp_vec2)
		managers.navigation:move_pos_rsrv(self._pos_reservation)
	end
end

function HuskPlayerMovement:_upd_move_downed(t, dt)
	if self._move_data then
		local data = self._move_data
		local path = data.path
		local end_pos = path[#path]
		local cur_pos = self._m_pos
		local new_pos = tmp_vec1
		local displacement = 300 * dt
		local dis = mvector3.distance(cur_pos, end_pos)

		if dis < displacement then
			self._move_data = nil

			table.remove(self._sequenced_events, 1)
			mvector3.set(new_pos, end_pos)
		else
			mvector3.step(new_pos, cur_pos, end_pos, displacement)
		end

		self:set_position(new_pos)
	end
end

function HuskPlayerMovement:_upd_move_standard(t, dt)
	if self._load_data then
		return
	end

	local look_dir_flat = self._look_dir:with_z(0)

	mvector3.normalize(look_dir_flat)

	local leg_fwd_cur = self._m_rot:y()
	local waist_twist = look_dir_flat:to_polar_with_reference(leg_fwd_cur, math.UP).spin
	local abs_waist_twist = math.abs(waist_twist)

	if self._ext_anim.bleedout_enter or self._ext_anim.bleedout_exit or self._ext_anim.fatal_enter or self._ext_anim.fatal_exit then
		return
	end

	if self._pose_code == 1 then
		if not self._ext_anim.stand then
			self:play_redirect("stand")
		end
	elseif self._pose_code == 3 then
		if not self._ext_anim.prone then
			self:play_redirect("prone")
		end
	elseif not self._ext_anim.crouch then
		self:play_redirect("crouch")
	end

	if self._turning then
		self:set_m_rotation(self._unit:rotation())

		if not self._ext_anim.turn then
			self._turning = nil

			self._unit:set_driving("orientation_object")
			self._machine:set_root_blending(true)
		end
	end

	if self._move_data then
		if self._turning then
			self._turning = nil

			self._unit:set_driving("orientation_object")
			self._machine:set_root_blending(true)
		end

		local data = self._move_data
		local new_pos
		local path_len_remaining = data.path_len - data.prog_in_seg
		local wanted_str8_vel, max_velocity
		local max_dis = 400
		local slowdown_dis = 170

		if max_dis < data.path_len or self:_is_slowdown_to_next_action() or not self:_chk_groun_ray() then
			max_velocity = self:_get_max_move_speed(true) * 1.1
			wanted_str8_vel = max_velocity
		elseif slowdown_dis < data.path_len or not self:_chk_groun_ray() then
			max_velocity = self:_get_max_move_speed(true) * 0.95
			wanted_str8_vel = max_velocity
		else
			max_velocity = self:_get_max_move_speed(true) * 1.1

			local min_velocity = 200
			local min_dis = 50
			local dis_lerp = math.clamp((path_len_remaining - min_dis) / (max_dis - min_dis), 0, 1)

			wanted_str8_vel = math.lerp(min_velocity, max_velocity, dis_lerp)
		end

		if wanted_str8_vel < data.velocity_len then
			data.velocity_len = wanted_str8_vel
		else
			local max_acc = max_velocity * 1.75

			data.velocity_len = math.clamp(data.velocity_len + dt * max_acc, 0, wanted_str8_vel)
		end

		local wanted_travel_dis = data.velocity_len * dt
		local new_pos, complete = HuskPlayerMovement._walk_spline(data, self._m_pos, wanted_travel_dis)
		local last_z_vel = self._last_vel_z

		if mvector3.z(new_pos) < mvector3.z(self._m_pos) then
			last_z_vel = last_z_vel - 971 * dt

			local new_z = self._m_pos.z + last_z_vel * dt

			new_z = math.max(new_pos.z, new_z)

			mvec3_set_z(new_pos, new_z)
		elseif complete then
			self._move_data = nil

			table.remove(self._sequenced_events, 1)
		else
			last_z_vel = 0
		end

		self._last_vel_z = last_z_vel

		local displacement = tmp_vec1

		mvec3_set(displacement, new_pos)
		mvec3_sub(displacement, self._m_pos)
		mvec3_set_z(displacement, 0)
		self:set_position(new_pos)

		local waist_twist_max = 45
		local sign_waist_twist = math.sign(waist_twist)
		local leg_max_angle_adj = math.min(abs_waist_twist, 120 * dt)
		local waist_twist_new = waist_twist - sign_waist_twist * leg_max_angle_adj

		if waist_twist_max < math.abs(waist_twist_new) then
			waist_twist_new = sign_waist_twist * waist_twist_max
		else
			waist_twist_new = waist_twist - sign_waist_twist * leg_max_angle_adj
		end

		local leg_rot_new = Rotation(look_dir_flat, math.UP) * Rotation(-waist_twist_new)

		self:set_rotation(leg_rot_new)

		local anim_velocity, anim_side

		if not self:_is_anim_move_redirect_forbidden(path_len_remaining) then
			local fwd_new = self._m_rot:y()
			local right_new = fwd_new:cross(math.UP)
			local walk_dir_flat = data.seg_dir:with_z(0)

			mvector3.normalize(walk_dir_flat)

			local fwd_dot = walk_dir_flat:dot(fwd_new)
			local right_dot = walk_dir_flat:dot(right_new)

			if math.abs(fwd_dot) > math.abs(right_dot) then
				anim_side = fwd_dot > 0 and "fwd" or "bwd"
			else
				anim_side = right_dot > 0 and "r" or "l"
			end

			local vel_len = mvector3.length(displacement) / dt
			local stance_name = self._stance.name

			anim_velocity = stance_name == "ntl" and (self._ext_anim.run and (vel_len > 250 and "run" or "walk") or vel_len > 300 and "run" or "walk") or self._ext_anim.sprint and (vel_len > 450 and self._pose_code == 1 and "sprint" or vel_len > 250 and "run" or "walk") or self._ext_anim.run and (vel_len > 500 and self._pose_code == 1 and "sprint" or vel_len > 250 and "run" or "walk") or vel_len > 500 and self._pose_code == 1 and "sprint" or vel_len > 300 and "run" or "walk"

			self:_adjust_move_anim(anim_side, anim_velocity)

			local pose = self._ext_anim.pose
			local stance = self._stance.name

			if not self._walk_anim_velocities[pose] or not self._walk_anim_velocities[pose][stance] or not self._walk_anim_velocities[pose][stance][anim_velocity] or not self._walk_anim_velocities[pose][stance][anim_velocity][anim_side] then
				Application:error(self._unit, "Boom...", self._unit, "pose", pose, "stance", stance, "anim_velocity", anim_velocity, "anim_side", anim_side, self._machine:segment_state(self._ids_base))

				return
			end

			if not self:_is_anim_move_speed_forbidden() then
				local animated_walk_vel = self._walk_anim_velocities[pose][stance][anim_velocity][anim_side]
				local anim_speed = vel_len / animated_walk_vel

				self:_adjust_walk_anim_speed(dt, anim_speed)
			end
		elseif not self:_is_anim_idle_redirect_forbidden() then
			self:play_redirect("idle")
		end
	elseif self:_is_anim_stop_allowed() then
		self:play_redirect("idle")
	elseif self._ext_anim.idle_full_blend and not self._turning and (waist_twist > 40 or waist_twist < -65) then
		local angle = waist_twist
		local dir_str = angle > 0 and "l" or "r"
		local redir_name = "turn_" .. dir_str
		local redir_res = self:play_redirect(redir_name)

		if redir_res then
			self._turning = true

			local abs_angle = math.abs(angle)

			if abs_angle > 135 then
				self._machine:set_parameter(redir_res, "angle135", 1)
			elseif abs_angle > 90 then
				local lerp = (abs_angle - 90) / 45

				self._machine:set_parameter(redir_res, "angle135", lerp)
				self._machine:set_parameter(redir_res, "angle90", 1 - lerp)
			elseif abs_angle > 45 then
				local lerp = (abs_angle - 45) / 45

				self._machine:set_parameter(redir_res, "angle90", lerp)
				self._machine:set_parameter(redir_res, "angle45", 1 - lerp)
			else
				self._machine:set_parameter(redir_res, "angle45", 1)
			end

			self._unit:set_driving("animation")
			self._machine:set_root_blending(false)
		else
			debug_pause_unit(self._unit, "[HuskPlayerMovement:_upd_move_standard] ", redir_name, " redirect failed in", self._machine:segment_state(self._ids_base), self._unit)
		end
	end
end

function HuskPlayerMovement:_is_slowdown_to_next_action()
	local event_desc = self._sequenced_events[2]

	return event_desc and event_desc.is_no_move_slowdown
end

function HuskPlayerMovement:_is_anim_move_redirect_forbidden(path_len_remaining)
	return not self._move_data or self._ext_anim.landing or self._ext_anim.jumping and path_len_remaining < 50
end

function HuskPlayerMovement:_is_anim_idle_redirect_forbidden()
	return self._ext_anim.idle or self._ext_anim.landing
end

function HuskPlayerMovement:_is_anim_move_speed_forbidden()
	return self._ext_anim.jumping or self._ext_anim.landing
end

function HuskPlayerMovement:_is_anim_stop_allowed()
	return self._ext_anim.jumping or self._ext_anim.landing and self._ext_anim.move
end

function HuskPlayerMovement:_is_start_move_velocity_max()
	return self._ext_anim.jumping
end

function HuskPlayerMovement:_upd_move_zipline(t, dt)
	if self._load_data then
		return
	end

	if not self._ext_anim.zipline then
		self:play_redirect("zipline")
	end

	local event_desc = self._sequenced_events[1]

	event_desc.current_time = math.min(1, event_desc.current_time + dt / event_desc.zipline_unit:zipline():total_time())

	self:set_position(event_desc.zipline_unit:zipline():update_and_get_pos_at_time(event_desc.current_time))

	if event_desc.current_time == 1 then
		self:on_exit_zipline()
	end

	local look_rot = tmp_rot1

	mrotation.set_look_at(look_rot, self._look_dir, math.UP)

	local look_yaw = mrotation.yaw(look_rot)
	local root_yaw = mrotation.yaw(self._m_rot)

	if math.abs(look_yaw - root_yaw) > 180 then
		root_yaw = root_yaw - math.sign(root_yaw) * 180
	end

	local yaw_diff = look_yaw - root_yaw
	local step = math.lerp(20, 220, math.min(math.abs(yaw_diff), 30) / 30) * dt

	step = math.sign(yaw_diff) * math.min(step, math.abs(yaw_diff))

	local new_rot = tmp_rot1

	mrotation.set_yaw_pitch_roll(new_rot, root_yaw + step, 0, 0)
	self:set_rotation(new_rot)
end

function HuskPlayerMovement:_upd_move_driving(t, dt)
	if self._load_data then
		return
	end

	self:set_position(self.seat_third:position())
	self:set_rotation(self.seat_third:rotation())
end

function HuskPlayerMovement:anim_clbk_exit_vehicle(unit)
	if not self._change_seat then
		self:on_exit_vehicle()
	end
end

function HuskPlayerMovement:_adjust_move_anim(side, speed)
	local anim_data = self._ext_anim

	if anim_data.haste == speed and anim_data["move_" .. side] then
		return
	end

	local redirect_name = speed .. "_" .. side
	local enter_t
	local move_side = anim_data.move_side

	if move_side and (side == move_side or self._matching_walk_anims[side][move_side]) then
		local seg_rel_t = self._machine:segment_relative_time(self._ids_base)
		local pose = self._ext_anim.pose
		local stance = self._stance.name

		if not self._walk_anim_lengths[pose] or not self._walk_anim_lengths[pose][stance] or not self._walk_anim_lengths[pose][stance][speed] or not self._walk_anim_lengths[pose][stance][speed][side] then
			Application:error(self._unit, "[HuskPlayerMovement:_adjust_move_anim] Boom...", self._unit, "pose", pose, "stance", stance, "speed", speed, "side", side, self._machine:segment_state(self._ids_base))

			return
		end

		local walk_anim_length = self._walk_anim_lengths[pose][stance][speed][side]

		enter_t = seg_rel_t * walk_anim_length
	end

	local redir_res = self:play_redirect(redirect_name, enter_t)

	return redir_res
end

function HuskPlayerMovement:sync_action_walk_nav_point(pos)
	if Network:is_server() then
		if not self._pos_reservation then
			self._pos_reservation = {
				filter = self._pos_rsrv_id,
				position = mvector3.copy(pos),
				radius = 100,
			}
			self._pos_reservation_slow = {
				filter = self._pos_rsrv_id,
				position = mvector3.copy(pos),
				radius = 100,
			}

			managers.navigation:add_pos_reservation(self._pos_reservation)
			managers.navigation:add_pos_reservation(self._pos_reservation_slow)
		else
			self._pos_reservation.position = mvector3.copy(pos)

			managers.navigation:move_pos_rsrv(self._pos_reservation)
			self:_upd_slow_pos_reservation()
		end
	end

	local nr_seq_events = #self._sequenced_events

	if nr_seq_events == 1 and self._move_data then
		local path = self._move_data.path
		local vec = tmp_vec1

		mvector3.set(vec, pos)
		mvector3.subtract(vec, path[#path])

		if mvector3.z(vec) < 0 then
			mvector3.set_z(vec, 0)
		end

		self._move_data.path_len = self._move_data.path_len + mvector3.length(vec)

		table.insert(path, pos)
	elseif nr_seq_events > 0 and self._sequenced_events[nr_seq_events].type == "move" then
		table.insert(self._sequenced_events[#self._sequenced_events].path, pos)
	else
		local event_desc = {
			path = {
				pos,
			},
			type = "move",
		}

		self:_add_sequenced_event(event_desc)
	end
end

function HuskPlayerMovement:sync_remote_position(head_pos, pos)
	mvector3.set(self._remote_head_pos, head_pos)
	mvector3.set(self._remote_pos, pos)
end

function HuskPlayerMovement:current_state()
	return self
end

function HuskPlayerMovement:_start_movement(path)
	local data = {}

	self._move_data = data

	table.insert(path, 1, self._unit:position())

	data.path = path

	if self:_is_start_move_velocity_max() then
		data.velocity_len = self:_get_max_move_speed(true)
	else
		data.velocity_len = 0
	end

	local nr_nodes = #path
	local path_len = 0
	local i = 1

	while i < nr_nodes do
		mvector3.set(tmp_vec1, path[i + 1])
		mvector3.subtract(tmp_vec1, path[i])

		if mvector3.z(tmp_vec1) < 0 then
			mvector3.set_z(tmp_vec1, 0)
		end

		path_len = path_len + mvector3.length(tmp_vec1)
		i = i + 1
	end

	data.path_len = path_len
	data.prog_in_seg = 0
	data.seg_dir = Vector3()

	mvec3_set(data.seg_dir, path[2])
	mvec3_sub(data.seg_dir, path[1])

	if mvector3.z(data.seg_dir) < 0 then
		mvec3_set_z(data.seg_dir, 0)
	end

	data.seg_len = mvec3_norm(data.seg_dir)
end

function HuskPlayerMovement:_upd_attention_bipod(dt)
	return
end

function HuskPlayerMovement:_upd_move_bipod(t, dt)
	if self._state == "standard" then
		self._attention_updator = callback(self, self, "_upd_attention_standard")
		self._movement_updator = callback(self, self, "_upd_move_standard")

		self._look_modifier:set_target_y(self._look_dir)

		return
	end

	if self._pose_code == 1 then
		if not self._ext_anim.stand then
			self:play_redirect("stand")
		end
	elseif self._pose_code == 3 then
		if not self._ext_anim.prone then
			self:play_redirect("prone")
		end
	elseif not self._ext_anim.crouch then
		self:play_redirect("crouch")
	end

	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local husk_bipod_data = managers.player:get_bipod_data_for_peer(peer_id)

	if not husk_bipod_data then
		return
	end

	local bipod_pos = husk_bipod_data.bipod_pos

	if not bipod_pos then
		local weapon = self._unit:inventory():equipped_unit()
		local bipod_obj = weapon:get_object(Idstring("a_bp"))

		if bipod_obj then
			bipod_pos = bipod_obj:position()
		else
			return
		end
	end

	if not bipod_pos then
		return
	end

	local body_pos = husk_bipod_data.body_pos

	body_pos = body_pos or Vector3(self._m_pos.x, self._m_pos.y, self._m_pos.z)
	self._stance.owner_stance_code = 3

	self:_chk_change_stance()

	if not self._sync_look_dir then
		self._sync_look_dir = self._look_dir
	end

	if not self._bipod_last_angle then
		self._bipod_last_angle = self._sync_look_dir:angle(self._look_dir)
	end

	self._unit:set_driving("script")

	local husk_original_look_direction = Vector3(self._look_dir.x, self._look_dir.y, 0)
	local target_angle = self._sync_look_dir:angle(self._look_dir)
	local rotate_direction = math.sign((self._sync_look_dir - self._look_dir):to_polar_with_reference(self._look_dir, math.UP).spin)
	local rotate_angle = target_angle * rotate_direction

	rotate_angle = math.lerp(self._bipod_last_angle, rotate_angle, dt * 2)

	if self._anim_playing == nil then
		self._anim_playing = false
	end

	local stop_threshold = 0.115

	if stop_threshold < math.abs(self._bipod_last_angle - rotate_angle) and not self._anim_playing and rotate_direction == -1 then
		self:play_redirect("walk_r", nil)

		self._anim_playing = true
	elseif stop_threshold < math.abs(self._bipod_last_angle - rotate_angle) and not self._anim_playing and rotate_direction == 1 then
		self:play_redirect("walk_l", nil)

		self._anim_playing = true
	elseif stop_threshold > math.abs(self._bipod_last_angle - rotate_angle) and self._anim_playing then
		self:play_redirect("idle", nil)

		self._anim_playing = false
	end

	self._bipod_last_angle = rotate_angle

	local new_x = math.cos(rotate_angle) * (body_pos.x - bipod_pos.x) - math.sin(rotate_angle) * (body_pos.y - bipod_pos.y) + bipod_pos.x
	local new_y = math.sin(rotate_angle) * (body_pos.x - bipod_pos.x) + math.cos(rotate_angle) * (body_pos.y - bipod_pos.y) + bipod_pos.y
	local new_pos = Vector3(new_x, new_y, self._m_pos.z)

	self:set_position(new_pos)

	local body_rotation = Rotation(husk_original_look_direction, math.UP) * Rotation(rotate_angle)

	self:set_rotation(body_rotation)
	managers.player:set_bipod_data_for_peer({
		bipod_pos = bipod_pos,
		body_pos = body_pos,
		peer_id = peer_id,
	})
end

function HuskPlayerMovement:_upd_attention_turret(dt)
	return
end

function HuskPlayerMovement:_upd_move_turret(t, dt)
	if self._state == "standard" then
		self._attention_updator = callback(self, self, "_upd_attention_standard")
		self._movement_updator = callback(self, self, "_upd_move_standard")

		self._look_modifier:set_target_y(self._look_dir)

		return
	end

	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local husk_turret_data = managers.player:get_turret_data_for_peer(peer_id)
	local turret_unit = husk_turret_data.turret_unit

	if not alive(turret_unit) or not turret_unit.weapon then
		return
	end

	self._unit:set_driving("animation")

	local fire_locator = turret_unit:weapon():_get_fire_locator()

	if not fire_locator then
		return
	end

	if turret_unit:weapon()._puppet_stance and turret_unit:weapon()._puppet_stance == "standing" then
		local current_direction = fire_locator:rotation():y()

		mvector3.negate(current_direction)
		mvector3.multiply(current_direction, 1000)

		local original_direction = turret_unit:rotation():y()

		mvector3.multiply(original_direction, 1000)

		local deflection = original_direction:angle(current_direction)
		local deflection_direction = math.sign((original_direction - current_direction):to_polar_with_reference(current_direction, math.UP).spin)
		local spin_max = turret_unit:movement()._spin_max or deflection
		local deflection_normalized = math.clamp(math.abs(deflection), 0, math.abs(spin_max)) / math.abs(spin_max)
		local redirect_animation = "e_so_mg34_aim_right"
		local redirect_state = Idstring("std/stand/so/idle/e_so_mg34_aim_right")

		if deflection_direction < 0 then
			redirect_animation = "e_so_mg34_aim_left"
			redirect_state = Idstring("std/stand/so/idle/e_so_mg34_aim_left")
		end

		self._machine:set_parameter(redirect_state, "t", deflection_normalized)
		self:play_redirect(redirect_animation)
	end

	local update_alignments = false

	if update_alignments then
		local third_person_locator = turret_unit:weapon()._locator_tpp

		self:set_position(third_person_locator:position())
		self:set_rotation(third_person_locator:rotation())
	end
end

function HuskPlayerMovement:_start_standard(event_desc)
	self:set_need_revive(false)
	self:set_need_assistance(false)
	managers.hud:on_teammate_revived(self._unit:unit_data().teammate_panel_id, self._unit:unit_data().name_label_id)
	self._unit:set_slot(3)

	if Network:is_server() then
		managers.groupai:state():on_player_weapons_hot()
	end

	managers.groupai:state():on_criminal_recovered(self._unit)

	local previous_state = event_desc and event_desc.previous_state

	if previous_state == "parachuting" or previous_state == "freefall" then
		self:_play_equip_weapon()
	end

	if previous_state == "parachuting" or previous_state == "freefall" then
		self:on_exit_fall()
	end

	if previous_state == "turret" then
		local peer_id = managers.network:session():peer_by_unit(self._unit):id()

		self:_on_exit_turret(peer_id)
	end

	if not self._ext_anim.stand then
		local redir_res = self:play_redirect("stand")

		if not redir_res then
			self:play_state("std/stand/still/idle/look")
		end
	end

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	if self._state == "bipod" then
		local peer_id = managers.network:session():peer_by_unit(self._unit):id()

		self._attention_updator = callback(self, self, "_upd_attention_bipod")
		self._movement_updator = callback(self, self, "_upd_move_bipod")

		self._look_modifier:set_target_y(self._look_dir)
	elseif self._state == "turret" then
		local peer_id = managers.network:session():peer_by_unit(self._unit):id()

		self:_on_enter_turret(peer_id)
		managers.hud:show_teammate_turret_icon(self._unit:unit_data().teammate_panel_id, self._unit:unit_data().name_label_id)

		self._attention_updator = callback(self, self, "_upd_attention_turret")
		self._movement_updator = callback(self, self, "_upd_move_turret")

		self._look_modifier:set_target_y(self._look_dir)
	else
		self._attention_updator = callback(self, self, "_upd_attention_standard")
		self._movement_updator = callback(self, self, "_upd_move_standard")

		self._look_modifier:set_target_y(self._look_dir)
	end

	self._last_vel_z = 0

	return true
end

function HuskPlayerMovement:_on_enter_turret(peer_id)
	local husk_data = managers.player:get_turret_data_for_peer(peer_id)

	self._unit:inventory():hide_equipped_unit()

	if husk_data and alive(husk_data.turret_unit) and husk_data.turret_unit.weapon then
		local husk_placement = husk_data.turret_unit:get_object(Idstring("third_person_placement"))

		self:set_rotation(husk_placement:rotation())
		self:set_position(husk_placement:position())

		if husk_data.turret_unit:weapon()._puppet_stance and husk_data.turret_unit:weapon()._puppet_stance == "sitting" then
			husk_data.turret_unit:link(Idstring("third_person_placement"), self._unit)
		end

		self:play_redirect(husk_data.enter_animation)
	end
end

function HuskPlayerMovement:_on_exit_turret(peer_id)
	local husk_data = managers.player:get_turret_data_for_peer(peer_id)

	self._unit:inventory():show_equipped_unit()
	self._unit:unlink()

	if husk_data then
		self:play_redirect(husk_data.exit_animation)
	end

	managers.hud:hide_teammate_turret_icon(self._unit:unit_data().teammate_panel_id, self._unit:unit_data().name_label_id)
end

function HuskPlayerMovement:_start_bleedout(event_desc)
	local redir_res

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE) then
		redir_res = self:play_redirect("fatal")
	else
		redir_res = self:play_redirect("bleedout")
	end

	if not redir_res then
		print("[HuskPlayerMovement:_start_bleedout] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

		return
	end

	self:sync_stop_auto_fire_sound()
	self._unit:set_slot(3)
	managers.hud:on_teammate_downed(self._unit:unit_data().teammate_panel_id, self._unit:unit_data().name_label_id)
	managers.groupai:state():on_criminal_disabled(self._unit)
	self._unit:interaction():set_tweak_data("revive")
	self:set_need_revive(true, event_desc.down_time)
	managers.hud:hide_teammate_turret_icon(self._unit:unit_data().teammate_panel_id, self._unit:unit_data().name_label_id)

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self._attention_updator = callback(self, self, "_upd_attention_bleedout")
	self._movement_updator = callback(self, self, "_upd_move_downed")

	return true
end

function HuskPlayerMovement:_start_tased(event_desc)
	local redir_res = self:play_redirect("tased")

	if not redir_res then
		print("[HuskPlayerMovement:_start_tased] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

		return
	end

	self._unit:set_slot(3)
	self:set_need_revive(false)
	managers.groupai:state():on_criminal_disabled(self._unit, "electrified")

	self._tase_effect = World:effect_manager():spawn(self._tase_effect_table)

	self:set_need_assistance(true)

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self._attention_updator = callback(self, self, "_upd_attention_tased")
	self._movement_updator = callback(self, self, "_upd_move_downed")

	return true
end

function HuskPlayerMovement:_start_dead(event_desc)
	local redir_res = self:play_redirect("death")

	if not redir_res then
		print("[HuskPlayerMovement:_start_dead] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

		return
	end

	if self._atention_on then
		local blend_out_t = 0.15

		self._machine:set_modifier_blend(self._look_modifier_name, blend_out_t)
		self._machine:set_modifier_blend(self._head_modifier_name, blend_out_t)
		self._machine:set_modifier_blend(self._arm_modifier_name, blend_out_t)
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self._attention_updator = false
	self._movement_updator = callback(self, self, "_upd_move_downed")

	return true
end

function HuskPlayerMovement:_start_driving(event_desc)
	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local vehicle_data = managers.player:get_vehicle_for_peer(peer_id)

	if not vehicle_data then
		return false
	end

	local vehicle_tweak_data = vehicle_data.vehicle_unit:vehicle_driving()._tweak_data
	local vehicle_unit = vehicle_data.vehicle_unit
	local animation = vehicle_tweak_data.animations[vehicle_data.seat]

	self._allow_shooting = vehicle_tweak_data.seats[vehicle_data.seat].allow_shooting
	self._vehicle = vehicle_unit:vehicle()
	self._vehicle_unit = vehicle_unit
	self._driver = false

	if vehicle_data.seat == "driver" then
		self._driver = true

		self._unit:inventory():hide_equipped_unit()
	elseif self._allow_shooting then
		self._unit:inventory():show_equipped_unit()
	end

	self:play_redirect(animation)

	self.seat_third = vehicle_unit:get_object(Idstring(VehicleDrivingExt.THIRD_PREFIX .. vehicle_data.seat))

	self:set_look_dir_instant(self.seat_third:rotation():x())

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self:set_position(self.seat_third:position())
	self:set_rotation(self.seat_third:rotation())

	self._movement_updator = callback(self, self, "_upd_move_driving")
	self._attention_updator = callback(self, self, "_upd_attention_driving")

	self:_execute_vehicle_change_stance(self._vehicle_shooting_stance)

	return true
end

function HuskPlayerMovement:_adjust_walk_anim_speed(dt, target_speed)
	local state = self._machine:segment_state(self._ids_base)
	local cur_speed = self._machine:get_speed(state)
	local max = 2
	local min = 0.05
	local new_speed

	if cur_speed < target_speed and cur_speed < max then
		new_speed = target_speed
	elseif target_speed < cur_speed and min < cur_speed then
		new_speed = target_speed
	end

	if new_speed then
		self._machine:set_speed(state, new_speed)
	end
end

function HuskPlayerMovement:sync_shot_blank(impact)
	local delay = self._stance.values[3] < 0.7
	local f = false

	if not delay then
		self:_shoot_blank(impact)

		self._aim_up_expire_t = TimerManager:game():time() + 2
	else
		function f(impact)
			self:_shoot_blank(impact)
		end
	end

	self:_change_stance(3, f)
end

function HuskPlayerMovement:sync_start_auto_fire_sound()
	if self._auto_firing <= 0 then
		local delay = self._stance.values[3] < 0.7

		if delay then
			self._auto_firing = 1

			local function f(t)
				self:play_redirect("recoil_auto")

				self._auto_firing = 2
			end

			self:_change_stance(3, f)
		else
			self:play_redirect("recoil_auto")
			self:_change_stance(3, false)

			self._auto_firing = 2
		end

		self._aim_up_expire_t = TimerManager:game():time() + 2
	end
end

function HuskPlayerMovement:sync_stop_auto_fire_sound()
	if self._auto_firing > 0 then
		self._auto_firing = 0

		self:play_redirect("recoil_single")

		local stance = self._stance

		if stance.transition then
			stance.transition.delayed_shot = nil
		end
	end
end

function HuskPlayerMovement:sync_raise_weapon()
	if self._auto_firing <= 0 then
		local delay = self._stance.values[3] < 0.7

		if delay then
			self._auto_firing = 1

			self:play_redirect("recoil_auto")

			local function f(t)
				self._auto_firing = 2
			end

			self:_change_stance(3, f)
		else
			self:_change_stance(3, false)

			self._auto_firing = 2
		end

		self._aim_up_expire_t = TimerManager:game():time() + 2
	end
end

function HuskPlayerMovement:set_cbt_permanent(on)
	self._is_weapon_gadget_on = on

	self:_chk_change_stance()
end

function HuskPlayerMovement:_shoot_blank(impact)
	local equipped_weapon = self._unit:inventory():equipped_unit()

	if equipped_weapon and equipped_weapon:base().fire_blank then
		equipped_weapon:base():fire_blank(self._look_dir, impact)

		if self._aim_up_expire_t ~= -1 then
			self._aim_up_expire_t = TimerManager:game():time() + 2
		end
	end

	local anim_data = self._unit:anim_data()

	if not anim_data.base_no_recoil or anim_data.player_ignore_base_no_recoil then
		self:play_redirect("recoil_single")
	end
end

function HuskPlayerMovement:sync_reload_weapon()
	self:play_redirect("reload")
end

function HuskPlayerMovement:sync_pose(pose_code)
	self:_change_pose(pose_code)
end

function HuskPlayerMovement:_change_stance(stance_code, delayed_shot)
	if stance_code == 1 then
		Application:debug("[HuskPlayerMovement:_change_stance] Setting Husk to NTL?", debug.traceback())
	end

	if self._stance.code and self._stance.code == stance_code then
		return
	end

	local stance = self._stance
	local end_values = {
		0,
		0,
		0,
	}

	end_values[stance_code] = 1
	stance.code = stance_code
	stance.name = self._stance_names[stance_code]

	local start_values = {}

	for _, value in ipairs(stance.values) do
		table.insert(start_values, value)
	end

	local delay = stance.blend[stance_code]

	if delayed_shot then
		delay = delay * 0.3
	end

	local t = TimerManager:game():time()
	local transition = {
		delayed_shot = delayed_shot,
		duration = delay,
		end_values = end_values,
		next_upd_t = t + 0.07,
		start_t = t,
		start_values = start_values,
	}

	stance.transition = transition
end

function HuskPlayerMovement:_change_pose(pose_code)
	if self._foxhole_state then
		return
	end

	local redirect = pose_code == 1 and "stand" or pose_code == 3 and "prone" or "crouch"

	self._pose_code = pose_code

	if self._ext_anim[redirect] then
		return
	end

	if self._load_data then
		return
	end

	local enter_t
	local move_side = self._ext_anim.move_side

	if move_side then
		local seg_rel_t = self._machine:segment_relative_time(self._ids_base)
		local speed = self._ext_anim.run and "run" or "walk"
		local pose = self._ext_anim.pose
		local stance = self._stance.name

		if not self._walk_anim_lengths[pose] or not self._walk_anim_lengths[pose][stance] or not self._walk_anim_lengths[pose][stance][speed] or not self._walk_anim_lengths[pose][stance][speed][move_side] then
			Application:error(self._unit, "[HuskPlayerMovement:_change_pose] Boom...", self._unit, "pose", pose, "stance", stance, "speed", speed, "move_side", move_side, self._machine:segment_state(self._ids_base))

			return
		end

		local walk_anim_length = self._walk_anim_lengths[self._ext_anim.pose][self._stance.name][speed][move_side]

		enter_t = seg_rel_t * walk_anim_length
	end

	self:play_redirect(redirect, enter_t)
end

function HuskPlayerMovement:sync_movement_state(state, down_time)
	cat_print("george", "[HuskPlayerMovement:sync_movement_state]", state)

	local previous_state = self._state

	self._state = state
	self._last_down_time = down_time
	self._state_enter_t = TimerManager:game():time()

	local peer = self._unit:network():peer()

	if peer then
		-- block empty
	end

	if state == "standard" then
		local event_desc = {
			previous_state = previous_state,
			type = "standard",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "bleed_out" then
		local event_desc = {
			down_time = down_time,
			type = "bleedout",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "tased" then
		local event_desc = {
			type = "tased",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "carry" or state == "carry_corpse" then
		local event_desc = {
			previous_state = previous_state,
			type = "standard",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "bipod" then
		local event_desc = {
			previous_state = previous_state,
			type = "standard",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "driving" then
		local event_desc = {
			previous_state = previous_state,
			type = "driving",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "freefall" then
		local event_desc = {
			previous_state = previous_state,
			type = "freefall",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "parachuting" then
		local event_desc = {
			previous_state = previous_state,
			type = "parachuting",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "turret" then
		local event_desc = {
			previous_state = previous_state,
			type = "standard",
		}

		self:_add_sequenced_event(event_desc)
	elseif state == "dead" then
		local peer_id = managers.network:session():peer_by_unit(self._unit):id()

		managers.groupai:state():on_player_criminal_death(peer_id)
	end
end

function HuskPlayerMovement:on_uncovered(enemy_unit)
	self._unit:network():send_to_unit({
		"suspect_uncovered",
		enemy_unit,
	})
end

function HuskPlayerMovement:anim_clbk_footstep(unit)
	CopMovement.anim_clbk_footstep(self, unit, self._m_pos)
end

function HuskPlayerMovement:ground_ray()
	return
end

function HuskPlayerMovement:clbk_inventory_event(unit, event)
	local weapon = self._unit:inventory():equipped_unit()

	if not alive(weapon) then
		return
	end

	local ext_base = weapon:base()

	if ext_base.set_hand_held then
		ext_base:set_hand_held(true)
	end

	if self._weapon_hold then
		self._machine:set_global(self._weapon_hold, 0)
	end

	local weap_tweak = ext_base:weapon_tweak_data()
	local weapon_hold = weap_tweak.husk_hold or weap_tweak.hold

	self._machine:set_global(weapon_hold, 1)

	self._weapon_hold = weapon_hold

	if self._weapon_anim_global then
		self._machine:set_global(self._weapon_anim_global, 0)
	end

	local weapon_usage = weap_tweak.usage_anim

	self._machine:set_global(weapon_usage, 1)

	self._weapon_anim_global = weapon_usage
end

function HuskPlayerMovement:current_state_name()
	return self._state
end

function HuskPlayerMovement:tased()
	return self._state == "tased"
end

function HuskPlayerMovement:charging()
	return self._state == "charging"
end

function HuskPlayerMovement:on_death_exit()
	return
end

function HuskPlayerMovement:load(data)
	self._load_data = data

	if managers.navigation:is_data_ready() then
		self:_do_load()
	else
		Application:debug("[HuskPlayerMovement:load] queueng player movement load until navigation is ready")

		self._nav_ready_listener_key = "HuskPlayerMovement" .. tostring(self._unit:key())

		managers.navigation:add_listener(self._nav_ready_listener_key, {
			"navigation_ready",
		}, callback(self, self, "_do_load"))

		self._wait_load = true
	end
end

function HuskPlayerMovement:_do_load()
	self._wait_load = false

	local data = self._load_data

	self.update = HuskPlayerMovement._post_load

	if data.movement.attentions then
		for _, setting_index in ipairs(data.movement.attentions) do
			local setting_name = tweak_data.attention:get_attention_name(setting_index)

			self:set_attention_setting_enabled(setting_name, true)
		end
	end

	self._team = managers.groupai:state():team_data(data.movement.team_id)

	if self._nav_ready_listener_key then
		managers.navigation:remove_listener(self._nav_ready_listener_key)
	end

	if data.movement.foxhole_unit then
		self:set_foxhole_state(true)
	end
end

function HuskPlayerMovement:_post_load(unit, t, dt)
	if not managers.network:session() then
		return
	end

	local peer = managers.network:session():peer(self._load_data.movement.peer_id)

	if not peer then
		debug_pause("[HuskPlayerMovement:_post_load] peer is null!", inspect(self._load_data), self._unit)
	end

	if peer then
		local data = self._load_data

		self.update = nil
		self._load_data = nil

		local my_data = data.movement

		if not my_data then
			return
		end

		peer:set_outfit_string(my_data.outfit, my_data.outfit_version)
		UnitNetworkHandler.set_unit(UnitNetworkHandler, unit, my_data.character_name, my_data.outfit, my_data.outfit_version, my_data.peer_id)

		if managers.network:session():peer_by_unit(unit) == nil then
			Application:error("[HuskPlayerBase:_post_load] A player husk who appears to not have an owning member was detached.")
			Network:detach_unit(unit)
			unit:set_slot(0)

			return
		end

		self:sync_movement_state(my_data.state_name, data.down_time)
		self:sync_pose(my_data.pose)

		if my_data.stance then
			Application:debug("[HuskPlayerMovement:_post_load] Setting stance on husk:", my_data.stance)
			self:sync_stance(my_data.stance)
		end

		local unit_rot = Rotation(my_data.look_fwd:with_z(0), math.UP)

		self:set_rotation(unit_rot)
		self:set_look_dir_instant(my_data.look_fwd)

		if data.zip_line_unit_id then
			local worlddefinition = managers.worldcollection and managers.worldcollection:get_worlddefinition_by_unit_id(data.zip_line_unit_id) or managers.worlddefinition
			local original_unit_id = worlddefinition:get_original_unit_id(data.zip_line_unit_id)

			self:on_enter_zipline(worlddefinition:get_unit_on_load(original_unit_id, callback(self, self, "on_enter_zipline")))
		end
	end
end

function HuskPlayerMovement:save(data)
	local peer_id = managers.network:session():peer_by_unit(self._unit):id()

	data.movement = {
		character_name = managers.criminals:character_name_by_unit(self._unit),
		look_fwd = self:detect_look_dir(),
		outfit = managers.network:session():peer(peer_id):profile("outfit_string"),
		peer_id = peer_id,
		pose = self._pose_code,
		stance = self._stance.code,
		state_name = self._state,
	}
	data.zip_line_unit_id = self:zipline_unit() and self:zipline_unit():editor_id()
	data.down_time = self._last_down_time
end

function HuskPlayerMovement:pre_destroy(unit)
	if self._pos_reservation then
		managers.navigation:unreserve_pos(self._pos_reservation)
		managers.navigation:unreserve_pos(self._pos_reservation_slow)

		self._pos_reservation = nil
		self._pos_reservation_slow = nil
	end

	self:set_need_revive(false)
	self:set_need_assistance(false)
	self._attention_handler:set_attention(nil)

	if self._nav_tracker then
		managers.navigation:destroy_nav_tracker(self._nav_tracker)

		self._nav_tracker = nil
	end

	if self._enemy_weapons_hot_listen_id then
		managers.groupai:state():remove_listener(self._enemy_weapons_hot_listen_id)

		self._enemy_weapons_hot_listen_id = nil
	end

	self:anim_cbk_unspawn_melee_item()
	self:_destroy_current_carry_unit()

	if Network:is_server() and self._foxhole_state and alive(self._foxhole_unit) then
		self._foxhole_unit:foxhole():set_locked(false)
		self._foxhole_unit:damage():run_sequence_simple("enable_interaction")
		self._foxhole_unit:foxhole():unregister_player()
	end
end

function HuskPlayerMovement:set_attention_setting_enabled(setting_name, state)
	return PlayerMovement.set_attention_setting_enabled(self, setting_name, state, false)
end

function HuskPlayerMovement:clbk_attention_notice_sneak(observer_unit, status)
	return PlayerMovement.clbk_attention_notice_sneak(self, observer_unit, status)
end

function HuskPlayerMovement:_create_attention_setting_from_descriptor(setting_desc, setting_name)
	return PlayerMovement._create_attention_setting_from_descriptor(self, setting_desc, setting_name)
end

function HuskPlayerMovement:attention_handler()
	return self._attention_handler
end

function HuskPlayerMovement:_feed_suspicion_to_hud()
	return
end

function HuskPlayerMovement:_apply_attention_setting_modifications(setting)
	setting.detection = self._unit:base():detection_settings()
end

function HuskPlayerMovement:sync_stance(stance_code)
	self._stance.owner_stance_code = stance_code

	self:_chk_change_stance()
end

function HuskPlayerMovement:_chk_change_stance()
	local wanted_stance_code

	wanted_stance_code = self._is_weapon_gadget_on and 3 or self._aim_up_expire_t and 3 or self._stance.owner_stance_code

	if wanted_stance_code ~= self._stance.code then
		self:_change_stance(wanted_stance_code)
	end
end

function HuskPlayerMovement:_get_max_move_speed(run)
	local class_tweak_data = self._class_tweak_data
	local unit_base = self._unit:base()
	local base_speed = class_tweak_data.movement.speed.WALKING_SPEED
	local multiplier = unit_base:upgrade_value("player", "fleetfoot_movement_speed_multiplier") or 1

	if self._pose_code == 2 then
		base_speed = class_tweak_data.movement.speed.CROUCHING_SPEED
		multiplier = multiplier * (unit_base:upgrade_value("player", "scuttler_crouch_speed_increase") or 1)
	elseif run then
		base_speed = class_tweak_data.movement.speed.RUNNING_SPEED
		multiplier = multiplier * (unit_base:upgrade_value("player", "sprinter_run_speed_increase") or 1)
	end

	if self:charging() then
		multiplier = multiplier * PlayerCharging.SPEED_MUL
	end

	return base_speed * multiplier
end

function HuskPlayerMovement._walk_spline(move_data, pos, walk_dis)
	local path = move_data.path
	local seg_dir = move_data.seg_dir

	while true do
		local prog_in_seg = move_data.prog_in_seg + walk_dis

		if move_data.seg_len == 0 or prog_in_seg >= move_data.seg_len then
			if #path == 2 then
				move_data.prog_in_seg = move_data.seg_len

				return mvector3.copy(path[2]), true
			else
				table.remove(path, 1)

				walk_dis = walk_dis - move_data.seg_len + move_data.prog_in_seg
				move_data.path_len = move_data.path_len - move_data.seg_len
				move_data.prog_in_seg = 0

				mvec3_set(seg_dir, path[2])
				mvec3_sub(seg_dir, path[1])

				if mvector3.z(seg_dir) < 0 then
					mvec3_set_z(seg_dir, 0)
				end

				move_data.seg_len = mvec3_norm(seg_dir)
			end
		else
			move_data.prog_in_seg = prog_in_seg

			local return_vec = Vector3()

			mvector3.lerp(return_vec, path[1], path[2], prog_in_seg / move_data.seg_len)

			return return_vec, nil
		end
	end
end

function HuskPlayerMovement:_chk_groun_ray()
	local up_pos = tmp_vec1

	mvec3_set(up_pos, math.UP)
	mvec3_mul(up_pos, 30)
	mvec3_add(up_pos, self._m_pos)

	local down_pos = tmp_vec2

	mvec3_set(down_pos, math.UP)
	mvec3_mul(down_pos, -20)
	mvec3_add(down_pos, self._m_pos)

	return World:raycast("ray", up_pos, down_pos, "slot_mask", self._slotmask_gnd_ray, "ray_type", "walk", "report")
end

function HuskPlayerMovement:sync_attention_setting(setting_name, state)
	if state then
		local setting_desc = tweak_data.attention.settings[setting_name]

		if setting_desc then
			local setting = self:_create_attention_setting_from_descriptor(setting_desc, setting_name)

			self._unit:movement():attention_handler():add_attention(setting)
		else
			debug_pause_unit(self._unit, "[PlayerMovement:add_attention_setting] invalid setting", setting_name, self._unit)
		end
	else
		self._unit:movement():attention_handler():remove_attention(setting_name)
	end
end

function HuskPlayerMovement:on_enter_zipline(zipline_unit)
	local event_desc = {
		type = "zipline",
		zipline_unit = zipline_unit,
	}

	self:_add_sequenced_event(event_desc)
end

function HuskPlayerMovement:on_exit_zipline()
	table.remove(self._sequenced_events, 1)

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self._look_modifier:set_target_y(self._look_dir)

	self._attention_updator = callback(self, self, "_upd_attention_standard")
	self._movement_updator = callback(self, self, "_upd_move_standard")
end

function HuskPlayerMovement:_start_zipline(event_desc)
	event_desc.current_time = event_desc.zipline_unit:zipline():current_time()

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self._arm_modifier:set_target_y(self._look_dir)
	self._head_modifier:set_target_z(self._look_dir)

	self._movement_updator = callback(self, self, "_upd_move_zipline")
	self._attention_updator = callback(self, self, "_upd_attention_zipline")
end

function HuskPlayerMovement:zipline_unit()
	if self._sequenced_events[1] and self._sequenced_events[1].zipline_unit then
		return self._sequenced_events[1].zipline_unit
	end
end

function HuskPlayerMovement:on_exit_vehicle()
	local event_desc = self._sequenced_events[1]

	if self._atention_on then
		self._atention_on = false
	end

	self._machine:forbid_modifier(self._look_modifier_name)
	self._machine:forbid_modifier(self._head_modifier_name)
	self._machine:forbid_modifier(self._arm_modifier_name)
	self._machine:forbid_modifier(self._mask_off_modifier_name)

	self._vehicle = nil

	self._look_modifier:set_target_y(self._look_dir)

	self._vehicle_shooting_stance = PlayerDriving.STANCE_NORMAL

	self._unit:inventory():show_equipped_unit()

	self._movement_updator = callback(self, self, "_upd_move_standard")
	self._attention_updator = callback(self, self, "_upd_attention_standard")
end

function HuskPlayerMovement:sync_vehicle_change_stance(stance)
	local anim = self._machine:segment_state(self._ids_base)

	self._machine:set_parameter(anim, "shooting_stance", stance)

	self._vehicle_shooting_stance = stance
end

function HuskPlayerMovement:_execute_vehicle_change_stance(stance)
	local anim = self._machine:segment_state(self._ids_base)

	self._machine:set_parameter(anim, "shooting_stance", stance)
end

function HuskPlayerMovement:sync_move_to_next_seat()
	self._change_seat = true

	self:_start_driving()

	self._change_seat = false
end

function HuskPlayerMovement:sync_action_jump(pos, jump_vec)
	self:sync_action_walk_nav_point(mvector3.copy(pos))

	if #self._sequenced_events > 5 then
		return
	end

	local event_desc = {
		is_no_move_slowdown = true,
		jump_vec = jump_vec,
		pos = pos,
		steer_velocity = Vector3(),
		type = "jump",
	}

	self:_add_sequenced_event(event_desc)
end

function HuskPlayerMovement:sync_action_jump_middle(pos)
	for i = #self._sequenced_events, 1, -1 do
		local event_desc = self._sequenced_events[i]

		if event_desc.type == "jump" then
			event_desc.middle_pos = pos

			break
		end
	end
end

function HuskPlayerMovement:sync_action_land(pos)
	local jump_index
	local count = #self._sequenced_events

	for i = count, 1, -1 do
		local event_desc = self._sequenced_events[i]

		if event_desc.type == "jump" then
			event_desc.land_pos = pos
			jump_index = i

			break
		end
	end

	self._unit:sound_source():post_event("footstep_land_npc")

	if jump_index == count or count == 0 then
		self:sync_action_walk_nav_point(mvector3.copy(pos))
	end
end

function HuskPlayerMovement:_start_jumping(event_desc)
	event_desc.commencing = true
	self._movement_updator = callback(self, self, "_upd_move_jump")

	mvec3_set(tmp_vec1, event_desc.jump_vec)
	mvec3_set_z(tmp_vec1, 0)

	if mvec3_dot(tmp_vec1, self._look_dir) > 0 then
		self:play_redirect("jump_fwd")
	else
		self:play_redirect("jump")
	end
end

function HuskPlayerMovement:_upd_move_jump(t, dt)
	local event_desc = self._sequenced_events[1]
	local new_pos = self._m_pos

	mvec3_set(tmp_vec1, event_desc.jump_vec)
	mvec3_mul(tmp_vec1, dt)
	mvec3_add(new_pos, tmp_vec1)

	local jump_z = tmp_vec1.z
	local gravity_z = World:gravity().z

	mvec3_set_z(event_desc.jump_vec, event_desc.jump_vec.z + gravity_z * dt)

	if event_desc.middle_pos and new_pos.z > event_desc.middle_pos.z then
		mvec3_set_z(new_pos, event_desc.middle_pos.z)

		if event_desc.jump_vec.z > 0 then
			mvec3_set_z(event_desc.jump_vec, 0)

			jump_z = 0
		end
	end

	local is_verified_pos = false

	if gravity_z < 0 then
		if event_desc.land_pos then
			self:_jump_toward(dt, new_pos, event_desc.steer_velocity, event_desc.land_pos, event_desc.jump_vec, jump_z, gravity_z, true)

			is_verified_pos = true
		elseif event_desc.middle_pos then
			if event_desc.jump_vec.z > 0 then
				self:_jump_toward(dt, new_pos, event_desc.steer_velocity, event_desc.middle_pos, event_desc.jump_vec, jump_z, gravity_z, false)

				is_verified_pos = true
			else
				if not event_desc.calc_land_pos then
					event_desc.calc_land_pos = mvector3.copy(event_desc.middle_pos)
				else
					mvec3_set(event_desc.calc_land_pos, event_desc.middle_pos)
				end

				mvec3_sub(event_desc.calc_land_pos, event_desc.pos)
				mvec3_set_z(event_desc.calc_land_pos, 0)
				mvec3_mul(event_desc.calc_land_pos, 2)
				mvec3_add(event_desc.calc_land_pos, event_desc.pos)
				self:_jump_toward(dt, new_pos, event_desc.steer_velocity, event_desc.calc_land_pos, event_desc.jump_vec, jump_z, gravity_z, false)
			end
		end
	end

	if not is_verified_pos then
		self._unit:m_position(tmp_vec1)
		mvec3_set(tmp_vec2, new_pos)
		mvec3_sub(tmp_vec2, tmp_vec1)
		mvec3_norm(tmp_vec2)
		mvec3_sub(tmp_vec1, tmp_vec2)
		mvec3_mul(tmp_vec2, 30 * (1 - math.abs(mvec3_dot(tmp_vec2, math.UP))))
		mvec3_add(tmp_vec2, new_pos)

		local is_hit = World:raycast("ray", tmp_vec1, tmp_vec2, "slot_mask", self._slotmask_gnd_ray, "ray_type", "walk", "report")

		if is_hit then
			mvec3_set(new_pos, tmp_vec1)
			self:_exit_jumping()
		end
	end

	self:set_position(new_pos)
	mvec3_set(tmp_vec1, self._look_dir)
	mvec3_set_z(tmp_vec1, 0)
	mrotation.set_look_at(tmp_rot1, tmp_vec1, math.UP)
	self:set_rotation(tmp_rot1)
end

function HuskPlayerMovement:_jump_toward(dt, mvec_new_pos, mvec_steer_velocity, target, velocity, jump_z, gravity_z, is_real_land_pos)
	local velocity_z = velocity.z
	local time_left = (-velocity_z - math.sqrt(math.abs(velocity_z * velocity_z + 2 * (target.z - mvec_new_pos.z) * gravity_z))) / gravity_z
	local jump_max_movement = self._class_tweak_data.movement.speed.RUNNING_SPEED

	mvec3_set(tmp_vec2, target)
	mvec3_sub(tmp_vec2, mvec_new_pos)
	mvec3_set_z(tmp_vec2, 0)

	if time_left < 0 and mvec3_dot(tmp_vec2, velocity) > 0 then
		time_left = -time_left
	end

	mvec3_set(tmp_vec1, velocity)
	mvec3_set_z(tmp_vec1, 0)
	mvec3_mul(tmp_vec1, time_left)
	mvec3_sub(tmp_vec2, tmp_vec1)

	if time_left ~= 0 then
		mvec3_div(tmp_vec2, time_left)
	end

	mvec3_set(mvec_steer_velocity, tmp_vec2)

	if jump_max_movement < mvec3_len(tmp_vec2) then
		mvec3_set_len(tmp_vec2, jump_max_movement)
	end

	mvec3_mul(tmp_vec2, dt)
	mvec3_add(mvec_new_pos, tmp_vec2)

	if is_real_land_pos and velocity.z < 0 then
		local diff_z = mvec_new_pos.z - target.z

		if diff_z + jump_z <= 0 then
			if diff_z < 0 then
				mvec3_set_z(mvec_new_pos, mvec_new_pos.z - math.max(diff_z, jump_z))
			end

			self:_exit_jumping()
		end
	end
end

function HuskPlayerMovement:_exit_jumping()
	table.remove(self._sequenced_events, 1)

	self._movement_updator = callback(self, self, "_upd_move_standard")
end

function HuskPlayerMovement:_cleanup_previous_state(previous_state)
	if alive(self._parachute_unit) and not self._parachute_unit:unit_data().closed then
		self._parachute_unit:unit_data().closed = true

		local position = self._parachute_unit:position()
		local rotation = self._parachute_unit:rotation()

		self._parachute_unit:unlink()

		if previous_state == "parachuting" then
			self._parachute_unit:damage():run_sequence_simple("make_dynamic")
		else
			Application:debug("[HuskPlayerMovement:_cleanup_previous_state] previous_state", previous_state)
			self._parachute_unit:set_slot(0)

			self._parachute_unit = nil
		end

		self._unit:inventory():show_equipped_unit()
	end
end

function HuskPlayerMovement:_start_freefall(event_desc)
	Application:debug("[HuskPlayerMovement:_start_freefall] STARTED")
	self._unit:inventory():hide_equipped_unit()

	if not self._ext_anim.freefall then
		self:play_redirect("freefall_fwd")
	end

	self._sync_look_dir = self._look_dir
	self._last_vel_z = 360
	self._terminal_velocity = tweak_data.player.freefall.terminal_velocity
	self._gravity = tweak_data.player.freefall.gravity
	self._damping = tweak_data.player.freefall.gravity / tweak_data.player.freefall.terminal_velocity
	self._anim_name = "freefall"

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self._movement_updator = callback(self, self, "_upd_move_fall")
	self._attention_updator = callback(self, self, "_upd_attention_fall")

	return true
end

function HuskPlayerMovement:_start_parachute(event_desc)
	Application:debug("[HuskPlayerMovement:_start_parachute] STARTED")
	self._unit:inventory():hide_equipped_unit()
	self:play_redirect("freefall_to_parachute")

	self._sync_look_dir = self._look_dir
	self._terminal_velocity = tweak_data.player.parachute.terminal_velocity
	self._damping = tweak_data.player.parachute.gravity / tweak_data.player.parachute.terminal_velocity
	self._gravity = tweak_data.player.parachute.gravity
	self._anim_name = "parachute"

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self._movement_updator = callback(self, self, "_upd_move_fall")
	self._attention_updator = callback(self, self, "_upd_attention_fall")
	self._parachute_unit = safe_spawn_unit(Idstring("units/vanilla/props/props_parachute/props_parachute"), self._unit:position() + Vector3(0, 0, 100), self._unit:rotation())

	self._parachute_unit:set_visible(false)
	self._unit:link(Idstring("a_weapon_left_front"), self._parachute_unit, Idstring("rp_props_parachute"))
	self._parachute_unit:damage():run_sequence_simple("animation_unfold")
	managers.queued_tasks:queue(nil, self._show_parachute, self, nil, 0.2, nil)
	managers.worldcollection:register_spawned_unit_on_last_world(self._parachute_unit)

	return true
end

function HuskPlayerMovement:_show_parachute()
	self._parachute_unit:set_visible(true)
end

function HuskPlayerMovement:_upd_move_fall(t, dt)
	if self._load_data or not self._sync_fall_pos then
		return
	end

	if self._last_vel_z == 0 then
		self._last_vel_z = self._m_pos.z
	end

	local pos = Vector3()

	if self._last_vel_z == self._terminal_velocity then
		-- block empty
	elseif self._last_vel_z < self._terminal_velocity then
		self._last_vel_z = self._last_vel_z * math.exp(-dt * self._damping)
		self._last_vel_z = self._last_vel_z + self._gravity * dt

		if self._last_vel_z > self._terminal_velocity then
			self._last_vel_z = self._terminal_velocity
		end
	else
		self._last_vel_z = self._last_vel_z - self._gravity * dt

		if self._last_vel_z < self._terminal_velocity then
			self._last_vel_z = self._terminal_velocity
		end
	end

	mvector3.lerp(pos, self._m_pos, self._sync_fall_pos, dt)

	local new_z = pos.z - self._last_vel_z * dt

	mvec3_set_z(pos, new_z)

	local yaw_diff = self._m_rot:yaw() - self._sync_fall_rot:yaw()
	local rot = self._m_rot:slerp(self._sync_fall_rot, dt)

	if math.abs(yaw_diff) > 2 then
		if yaw_diff > 0 then
			if not self._ext_anim.right then
				self:play_redirect(self._anim_name .. "_r")
			end
		elseif not self._ext_anim.left then
			self:play_redirect(self._anim_name .. "_l")
		end
	elseif not self._ext_anim.fwd then
		self:play_redirect(self._anim_name .. "_fwd")
	end

	self:set_rotation(rot)
	self:set_position(pos)
end

function HuskPlayerMovement:_upd_attention_fall(dt)
	if not self._atention_on then
		self._atention_on = true

		self._machine:force_modifier(self._head_modifier_name)
	end

	if self._sync_look_dir then
		self:update_sync_look_dir(dt)
	end
end

function HuskPlayerMovement:sync_fall_position(pos, rot)
	self._sync_fall_pos = pos
	self._sync_fall_rot = rot
	self._sync_fall_dt = 0
end

function HuskPlayerMovement:sync_warp_position(pos, rot)
	self._sequenced_events = {}

	self:set_rotation(rot)
	self:set_position(pos)
	self:_start_standard()
end

function HuskPlayerMovement:on_exit_fall()
	Application:debug("[HuskPlayerMovement:on_exit_fall()] Exiting parachute")

	local event_desc = self._sequenced_events[1]

	if self._atention_on then
		self._atention_on = false
	end

	self._machine:forbid_modifier(self._look_modifier_name)
	self._machine:forbid_modifier(self._head_modifier_name)
	self._machine:forbid_modifier(self._arm_modifier_name)
	self._machine:forbid_modifier(self._mask_off_modifier_name)
	self._head_modifier:set_target_z(self._look_dir)
	self._look_modifier:set_target_y(self._look_dir)

	self._movement_updator = callback(self, self, "_upd_move_standard")
	self._attention_updator = callback(self, self, "_upd_attention_standard")
end

function HuskPlayerMovement:on_anim_turret_mg34_exit_finished(unit, param1)
	self._unit:inventory():show_equipped_unit()
end

function HuskPlayerMovement:on_anim_turret_flakvierling_exit_finished(unit, param1)
	self._unit:inventory():show_equipped_unit()
end

function HuskPlayerMovement:anim_clbk_close_parachute(unit)
	if alive(self._parachute_unit) and not self._parachute_unit:unit_data().closed then
		self._parachute_unit:unit_data().closed = true

		local position = self._parachute_unit:position()
		local rotation = self._parachute_unit:rotation()

		self._parachute_unit:unlink()

		if not unit then
			self._parachute_unit:damage():run_sequence_simple("make_dynamic_death")
		else
			self._parachute_unit:damage():run_sequence_simple("make_dynamic")
		end

		self._unit:inventory():show_equipped_unit()
	end
end

function HuskPlayerMovement:set_foxhole_state(state, unit)
	self._foxhole_state = self._foxhole_state or false

	if self._foxhole_state == state then
		return
	end

	self._foxhole_state = state
	self._foxhole_unit = alive(unit) and unit

	self:play_redirect(state and "e_so_foxhole_enter" or "e_so_foxhole_exit")

	if state then
		self._movement_updator = callback(self, self, "_upd_move_downed")

		if Network:is_server() then
			PlayerMovement.check_players_in_foxhole()
		end
	end
end

function HuskPlayerMovement:is_in_foxhole()
	return self._foxhole_state
end
