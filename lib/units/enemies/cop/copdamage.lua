CopDamage = CopDamage or class()
CopDamage._all_event_types = {
	"dmg_rcv",
	"light_hurt",
	"hurt",
	"heavy_hurt",
	"death",
	"shield_knock",
	"stun",
	"counter_tased",
	"taser_tased",
}
CopDamage._ATTACK_VARIANTS = {
	"explosion",
	"stun",
	"fire",
}
CopDamage._HEALTH_GRANULARITY = 512
CopDamage.WEAPON_TYPE_GRANADE = 1
CopDamage.WEAPON_TYPE_BULLET = 2
CopDamage.WEAPON_TYPE_FLAMER = 3
CopDamage.DEBUG_HP = CopDamage.DEBUG_HP or false
CopDamage._hurt_severities = {
	explode = "expl_hurt",
	fire = "fire_hurt",
	heavy = "heavy_hurt",
	light = "light_hurt",
	moderate = "hurt",
	none = false,
	poison = "poison_hurt",
}
CopDamage._COMMENT_DEATH_TABLE = {
	german_commander = "enemy_officer_comment_death",
	german_flamer = "enemy_flamer_comment_death",
	german_officer = "enemy_officer_comment_death",
	german_og_commander = "enemy_officer_comment_death",
	german_sniper = "enemy_sniper_comment_death",
	german_spotter = "enemy_spotter_comment_death",
	shield = false,
	sniper = false,
	tank = false,
	taser = false,
}
CopDamage._impact_bones = {}

local impact_bones_tmp = {
	"Hips",
	"Spine",
	"Spine1",
	"Spine2",
	"Neck",
	"Head",
	"LeftShoulder",
	"LeftArm",
	"LeftForeArm",
	"RightShoulder",
	"RightArm",
	"RightForeArm",
	"LeftUpLeg",
	"LeftLeg",
	"LeftFoot",
	"RightUpLeg",
	"RightLeg",
	"RightFoot",
}

for i, k in ipairs(impact_bones_tmp) do
	local name_ids = Idstring(impact_bones_tmp[i])

	CopDamage._impact_bones[name_ids:key()] = name_ids
end

impact_bones_tmp = nil

local mvec_1 = Vector3()
local mvec_2 = Vector3()
local ids_character_damage = Idstring("character_damage")

function CopDamage:init(unit)
	self._unit = unit

	local char_tweak = tweak_data.character[unit:base():char_tweak_id()]

	self._HEALTH_INIT = char_tweak.HEALTH_INIT

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMY_HEALTH) then
		self._HEALTH_INIT = self._HEALTH_INIT * (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_ENEMY_HEALTH) or 1)
	end

	self._health = self._HEALTH_INIT
	self._health_ratio = 1
	self._HEALTH_INIT_PRECENT = self._HEALTH_INIT / self._HEALTH_GRANULARITY
	self._damage_reduction_multiplier = nil
	self._autotarget_data = {
		fast = unit:get_object(Idstring("Spine1")),
	}
	self._pickup = nil
	self._ignore_knockdown = char_tweak.damage.ignore_knockdown
	self._listener_holder = EventListenerHolder:new()

	if char_tweak.permanently_invulnerable or self.immortal then
		self:set_invulnerable(true)
	end

	self._char_tweak = char_tweak
	self._helmet_popped = false
	self._spine2_obj = unit:get_object(Idstring("Spine2"))

	if self._head_body_name then
		self._ids_head_body_name = Idstring(self._head_body_name)
		self._head_body_key = self._unit:body(self._head_body_name):key()
	end

	self._last_time_unit_got_fire_damage = nil
	self._last_time_unit_got_fire_effect = nil
	self._temp_flame_redir_res = nil
	self._active_fire_bone_effects = {}

	if CopDamage.DEBUG_HP then
		self:_create_debug_ws()
	end

	self._tase_effect_table = {
		effect = tweak_data.common_effects.taser_hit,
		parent = self._spine2_obj,
	}
	self._last_damage_direction = nil
	self._dismembered_parts = {}

	self._unit:set_extension_update_enabled(ids_character_damage, false)
end

function CopDamage:get_last_damage_direction()
	return self._last_damage_direction
end

function CopDamage:get_last_time_unit_got_fire_damage()
	return self._last_time_unit_got_fire_damage
end

function CopDamage:set_last_time_unit_got_fire_damage(time)
	self._last_time_unit_got_fire_damage = time
end

function CopDamage:get_temp_flame_redir_res()
	return self._temp_flame_redir_res
end

function CopDamage:set_temp_flame_redir_res(value)
	self._temp_flame_redir_res = value
end

function CopDamage:get_damage_type(damage_percent, category)
	category = category or WeaponTweakData.DAMAGE_TYPE_BULLET

	local hurt_table = self._char_tweak.damage.hurt_severity[category]
	local dmg = damage_percent / self._HEALTH_GRANULARITY

	if hurt_table.health_reference == "full" then
		-- block empty
	elseif hurt_table.health_reference == "current" then
		dmg = math.min(1, self._HEALTH_INIT * dmg / self._health)
	else
		dmg = math.min(1, self._HEALTH_INIT * dmg / hurt_table.health_reference)
	end

	local zone

	for i_zone, test_zone in ipairs(hurt_table.zones) do
		if i_zone == #hurt_table.zones or dmg < test_zone.health_limit then
			zone = test_zone

			break
		end
	end

	local limiter = math.random()
	local total_w = 0

	for sev_name, hurt_type in pairs(self._hurt_severities) do
		local weight = zone[sev_name]

		if weight and weight > 0 then
			total_w = total_w + weight

			if limiter <= total_w then
				return hurt_type or "dmg_rcv"
			end
		end
	end

	return "dmg_rcv"
end

function CopDamage:is_head(body)
	local head = self._head_body_name and body and body:name() == self._ids_head_body_name

	return head
end

function CopDamage:_dismember_body_part(attack_data)
	local hit_body_part = attack_data.body_name

	hit_body_part = hit_body_part or attack_data.col_ray.body:name()

	local dismember_part = tweak_data.character.dismemberment_data.dismembers[hit_body_part:key()]

	if not dismember_part then
		return
	end

	self:dismember(dismember_part, attack_data.variant, true)
end

function CopDamage:dismember(dismember_part, variant, allow_network)
	table.insert(self._dismembered_parts, dismember_part)

	local decal_data = tweak_data.character.dismemberment_data.blood_decal_data[dismember_part]

	self:_dismember_part(dismember_part, decal_data, variant)

	if variant == "explosion" then
		local force_left_right = string.match(dismember_part, "_l_")

		force_left_right = force_left_right and "r" or "l"

		local additional_part = self:_random_dismember_part(force_left_right)

		self:_dismember_part(additional_part, tweak_data.character.dismemberment_data.blood_decal_data[additional_part], variant)
	end

	if allow_network and false then
		managers.network:session():send_to_peers("sync_part_dismemberment", self._unit, dismember_part, variant)
	end
end

function CopDamage:_random_dismember_part(force_left_right)
	local head = ({
		true,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
	})[math.random(8)]
	local left_right = force_left_right or ({
		"l",
		"r",
	})[math.random(2)]
	local up_down = ({
		"upper",
		"lower",
	})[math.random(2)]
	local arm_leg = ({
		"arm",
		"leg",
	})[math.random(2)]

	if head then
		return "dismember_head"
	else
		return "dismember_" .. left_right .. "_" .. up_down .. "_" .. arm_leg
	end
end

function CopDamage:debug_dismember_random_part()
	local additional_part = "dismember_head"

	self:_dismember_part(additional_part, tweak_data.character.dismemberment_data.blood_decal_data[additional_part], "explosion")
end

function CopDamage:_dismember_part(dismember_part, decal_data, variant)
	if not self._unit:damage():has_sequence(dismember_part) then
		return
	end

	self._unit:damage():run_sequence_simple(dismember_part)

	local materials = self._unit:materials()

	for i, material in ipairs(materials) do
		material:set_variable(Idstring("gradient_uv_offset"), Vector3(decal_data[1], decal_data[2], 0))
		material:set_variable(Idstring("gradient_power"), decal_data[3])
	end

	if variant == WeaponTweakData.DAMAGE_TYPE_BULLET then
		self._unit:sound():play("bullet_hit_bone_limboff", nil, nil)
	elseif variant == WeaponTweakData.DAMAGE_TYPE_EXPLOSION then
		local check_to = self._unit:movement() and self._unit:movement():m_head_pos() or self._unit:position()

		if managers.player:is_player_looking_at(check_to, {
			distance = 4000,
			raycheck = true,
		}) then
			managers.dialog:queue_dialog("player_gen_grenade_aftermath", {
				skip_idle_check = true,
			})
		end
	end
end

function CopDamage:dismembered_parts()
	return self._dismembered_parts
end

function CopDamage:damage_knockdown(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		return "friendly_fire"
	end

	attack_data.result = {}
	attack_data.result.variant = attack_data.variant
	attack_data.result.type = "expl_hurt"

	local damage = attack_data.damage
	local damage_percent = 0

	if damage > 0 then
		damage_percent = math.ceil(math.clamp(damage / self._HEALTH_INIT_PRECENT, 1, self._HEALTH_GRANULARITY))
	end

	local body_index = self._unit:get_body_index(attack_data.col_ray.body:name())
	local hit_offset_height = math.clamp(attack_data.col_ray.position.z - self._unit:movement():m_pos().z, 0, 300)

	self:_send_knockdown_attack_result(attack_data.attacker_unit, damage_percent, body_index, hit_offset_height)
	self:_on_damage_received(attack_data)
end

function CopDamage:damage_bullet(attack_data)
	self._last_damage_direction = attack_data.col_ray.ray

	if attack_data.damage < 0.001 then
		return "no_damage"
	elseif self._dead or self._invulnerable then
		return
	end

	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		return "friendly_fire"
	end

	local is_civilian = CopDamage.is_civilian(self._unit:base()._tweak_table)
	local player_unit = managers.player:local_player()
	local is_attacker_player = attack_data.attacker_unit == player_unit
	local death_event_params = {}

	death_event_params.damage_type = WeaponTweakData.DAMAGE_TYPE_BULLET
	death_event_params.enemy_type = tweak_data.character[self._unit:base()._tweak_table].type
	death_event_params.special_enemy_type = tweak_data.character[self._unit:base()._tweak_table].special_type

	local result
	local body_index = self._unit:get_body_index(attack_data.col_ray.body:name())
	local head = self._head_body_name and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name
	local instakill = false
	local damage = attack_data.damage

	if self._unit:base():char_tweak().DAMAGE_CLAMP_BULLET then
		damage = math.min(damage, self._unit:base():char_tweak().DAMAGE_CLAMP_BULLET)
	end

	damage = damage * (self._marked_dmg_mul or 1)

	if self:is_surprise_leeway() and head then
		damage = self._HEALTH_INIT
	end

	local headshot_multiplier = 1
	local weapon_headshot_multiplier = 1
	local bodyshot_multiplier = 1

	if is_attacker_player then
		local critical_hit, crit_damage = self:roll_critical_hit(damage, attack_data.col_ray)

		if critical_hit then
			death_event_params.critical_hit = true
			damage = crit_damage
		end

		if head then
			death_event_params.headshot = true
		end

		headshot_multiplier = headshot_multiplier * managers.player:upgrade_value("player", "headshot_damage_multiplier", 1)

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE) and head then
			headshot_multiplier = headshot_multiplier * (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE) or 1)
		end

		local weapon_unit = attack_data.weapon_unit

		if alive(weapon_unit) and weapon_unit:base().weapon_tweak_data then
			weapon_headshot_multiplier = weapon_unit:base():weapon_tweak_data().headshot_multiplier or 1

			local selection_index = weapon_unit:base().selection_index and weapon_unit:base():selection_index() or 0

			if selection_index == WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID then
				bodyshot_multiplier = bodyshot_multiplier * managers.player:upgrade_value("primary_weapon", "anatomist_bodyshot_damage_multiplier", 1)

				if managers.player:has_category_upgrade("primary_weapon", "farsighted_long_range_damage_multiplier") then
					local multiplier = managers.player:upgrade_value("primary_weapon", "farsighted_long_range_damage_multiplier", 1)

					if (attack_data.col_ray.distance or 0) < tweak_data.upgrades.farsighted_activation_distance then
						multiplier = 2 - multiplier
					end

					damage = damage * multiplier
				end
			elseif selection_index == WeaponInventoryManager.BM_CATEGORY_SECONDARY_ID then
				headshot_multiplier = headshot_multiplier * managers.player:upgrade_value("secondary_weapon", "anatomist_headshot_damage_multiplier", 1)
			end
		end
	end

	if self._damage_reduction_multiplier then
		damage = damage * self._damage_reduction_multiplier
	elseif head then
		if self._char_tweak.headshot_dmg_mul then
			damage = damage * weapon_headshot_multiplier * self._char_tweak.headshot_dmg_mul * headshot_multiplier
		else
			instakill = true
			damage = self._health * 10
		end
	else
		damage = damage * bodyshot_multiplier
	end

	if self._unit:unit_data().turret_weapon then
		death_event_params.mounted_on_turret = true

		local turret_tweak_data = tweak_data.weapon[self._unit:unit_data().turret_weapon._name_id]
		local damage_multiplier = turret_tweak_data.puppet_damage_multiplier or 1

		damage = damage * damage_multiplier
	end

	local damage_percent = math.ceil(math.clamp(damage / self._HEALTH_INIT_PRECENT, 1, self._HEALTH_GRANULARITY))

	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	if self._immortal or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT) and not head or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE) and head or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_EXPLOSION) or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_MELEE) then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_AUTO_KILL) and head then
		damage = self._health
		damage_percent = 100
	end

	damage = self:_apply_damage_modifier(damage, attack_data)

	local is_kill_shot = damage >= self._health

	if is_attacker_player and damage > 0 then
		local wep_type_shotgun

		if alive(attack_data.weapon_unit) and attack_data.weapon_unit:base().weapon_tweak_data and attack_data.weapon_unit:base():weapon_tweak_data().category == WeaponTweakData.WEAPON_CATEGORY_SHOTGUN then
			wep_type_shotgun = true
		end

		if is_kill_shot or damage >= WeaponTweakData.HIT_INDICATOR_ABSOLUTE or damage / self._HEALTH_INIT >= WeaponTweakData.HIT_INDICATOR_PERCENT then
			managers.hud:on_hit_confirmed({
				hit_type = wep_type_shotgun and HUDHitConfirm.HIT_SPLINTER or HUDHitConfirm.HIT_NORMAL,
				is_crit = death_event_params.critical_hit,
				is_headshot = head,
				is_killshot = is_kill_shot,
				pos = attack_data.col_ray.position,
			})
		end

		if head then
			managers.player:on_headshot_dealt(is_kill_shot)
		end
	end

	if is_kill_shot then
		if head and damage > math.random(25) then
			self:_spawn_head_gadget({
				dir = attack_data.col_ray.ray,
				position = attack_data.col_ray.body:position(),
				rotation = attack_data.col_ray.body:rotation(),
			})

			if self._char_tweak.headshot_helmet then
				self._helmet_popped = true
			end
		end

		attack_data.damage = self._health
		result = {
			type = "death",
			variant = attack_data.variant,
		}

		self:die(attack_data)
		self:chk_killshot(attack_data.attacker_unit, WeaponTweakData.DAMAGE_TYPE_BULLET)

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) then
			local health_amount_regen = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) or 0

			if health_amount_regen > 0 and attack_data.attacker_unit == managers.player:local_player() then
				managers.player:local_player():character_damage():restore_health(health_amount_regen * managers.player:local_player():character_damage():get_max_health(), true)
			end
		end
	else
		attack_data.damage = damage

		local result_type = self:get_damage_type(damage_percent, WeaponTweakData.DAMAGE_TYPE_BULLET)

		result = {
			type = result_type,
			variant = attack_data.variant,
		}

		self:_apply_damage_to_health(damage)

		if head and damage > math.random(25) then
			self:_spawn_head_gadget({
				dir = attack_data.col_ray.ray,
				position = attack_data.col_ray.body:position(),
				rotation = attack_data.col_ray.body:rotation(),
			})

			if self._char_tweak.headshot_helmet then
				self._helmet_popped = true
			end
		end

		if self._unit:brain().is_flamer and is_attacker_player and not self:dead() and not self._flamer_hint_popped and managers.statistics._global.killed.german_flamer.count < 5 then
			self._flamer_hint_popped = true

			managers.hud:set_big_prompt({
				description = managers.localization:text("hint_shoot_flamer_tank_desc"),
				duration = 5,
				id = "shoot_flamer_tank",
				title = utf8.to_upper(managers.localization:text("hint_shoot_flamer_tank")),
			})
		end
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position
	attack_data.headshot = head

	local dismember_victim = false

	if result.type == "death" then
		if self:_dismember_condition(attack_data, false) then
			self:_dismember_body_part(attack_data)

			death_event_params.dismemberment_occured = true
			dismember_victim = true
		end

		local data = {
			dismembered = dismember_victim,
			head_shot = head,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			unit_key = self._unit:key(),
			variant = attack_data.variant,
			weapon_unit = attack_data.weapon_unit,
		}

		if not attack_data.attacker_unit then
			Application:error("CopDamage:damage_bullet: missing attacker unit. ", inspect(attack_data))
		end

		if attack_data.attacker_unit and managers.groupai:state():all_criminals()[attack_data.attacker_unit:key()] then
			managers.statistics:killed_by_anyone(data)
		end

		if is_attacker_player then
			death_event_params.enemy_distance = mvector3.distance(self._unit:position(), attack_data.attacker_unit:position())
			death_event_params.damage = attack_data.damage
			death_event_params.player_used_steelsight = managers.player:get_current_state():in_steelsight()
			death_event_params.weapon_used = attack_data.weapon_unit
			death_event_params.using_turret = managers.player:current_state() == "turret"
			death_event_params.enemy_marked = self._marked_dmg_mul ~= nil

			self:_comment_death(attack_data.attacker_unit, self._unit:base()._tweak_table)

			local attacker_state = managers.player:current_state()

			data.attacker_state = attacker_state

			managers.statistics:killed(data)
			managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_KILLED_ENEMY, death_event_params)
		elseif attack_data.attacker_unit:in_slot(managers.slot:get_mask("criminals_no_deployables")) then
			self:_AI_comment_death(attack_data.attacker_unit, self._unit:base()._tweak_table)
		elseif attack_data.attacker_unit:base().sentry_gun and Network:is_server() then
			local server_info = attack_data.weapon_unit:base():server_information()

			if server_info and server_info.owner_peer_id ~= managers.network:session():local_peer():id() then
				local owner_peer = managers.network:session():peer(server_info.owner_peer_id)

				if owner_peer then
					owner_peer:send_queued_sync("sync_player_kill_statistic", data.name, data.head_shot and true or false, data.weapon_unit, data.variant, data.stats_name)
				end
			else
				data.attacker_state = managers.player:current_state()

				managers.statistics:killed(data)
			end
		end
	end

	local hit_offset_height = math.clamp(attack_data.col_ray.position.z - self._unit:movement():m_pos().z, 0, 300)
	local attacker = attack_data.attacker_unit

	if attacker:id() == -1 then
		attacker = self._unit
	end

	if alive(attack_data.weapon_unit) and attack_data.weapon_unit:base() and attack_data.weapon_unit:base().add_damage_result then
		attack_data.weapon_unit:base():add_damage_result(self._unit, attacker, result.type == "death", damage_percent)
	end

	self:_send_bullet_attack_result(attack_data, attacker, damage_percent, body_index, hit_offset_height)
	self:_on_damage_received(attack_data)

	if is_attacker_player and not is_civilian then
		local damage_enemy_params = {
			attack_data = attack_data,
			unit = self._unit,
		}

		managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_DAMAGED_ENEMY, damage_enemy_params)
	end

	return result
end

function CopDamage:is_surprise_leeway()
	local leeway = tweak_data.player.surprise_kill_leeway

	leeway = leeway + managers.player:upgrade_value("player", "predator_surprise_kill_leeway_multiplier", 0)

	return self._unit:movement():cool() or leeway > TimerManager:game():time() - self._unit:movement():not_cool_t()
end

function CopDamage:is_surprise_knockdown()
	local leeway = managers.player:upgrade_value("player", "predator_surprise_knockdown", 0)

	return not self._unit:movement():cool() and leeway > TimerManager:game():time() - self._unit:movement():not_cool_t()
end

function CopDamage.is_civilian(type)
	return type == "civilian" or type == "civilian_female" or type == "bank_manager"
end

function CopDamage.is_gangster(type)
	return type == "gangster" or type == "biker_escape" or type == "mobster" or type == "mobster_boss" or type == "biker"
end

function CopDamage.is_cop(type)
	return not CopDamage.is_civilian(type) and not CopDamage.is_gangster(type)
end

function CopDamage:ignore_knockdown()
	return self._ignore_knockdown
end

function CopDamage:_comment_death(unit, type)
	local dialogue_id = CopDamage._COMMENT_DEATH_TABLE[type]

	if dialogue_id then
		managers.dialog:queue_dialog(dialogue_id, {
			instigator = managers.player:local_player(),
			skip_idle_check = true,
		})
	end
end

function CopDamage:_AI_comment_death(unit, type)
	return
end

function CopDamage:damage_fire(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	local result
	local damage = attack_data.damage

	if not attack_data.attacker_unit or attack_data.attacker_unit:id() == -1 then
		attack_data.attacker_unit = self._unit
	end

	local attacker_unit = attack_data.attacker_unit

	if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	if attack_data.attacker_unit:brain() and attack_data.attacker_unit:brain().is_flamer then
		local flamer_tweak = tweak_data.character[attack_data.attacker_unit:base()._tweak_table]

		damage = damage * flamer_tweak.friendly_fire_dmg_mul
	end

	if self._char_tweak.damage and self._char_tweak.damage.fire_damage_mul then
		damage = damage * self._char_tweak.damage.fire_damage_mul
	end

	damage = math.clamp(damage, 0, self._HEALTH_INIT)

	local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)

	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	if self._immortal then
		damage = 0
		damage_percent = 0
	end

	local head = self._head_body_name and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT) and not head or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE) and head then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_EXPLOSION) or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_MELEE) then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_AUTO_KILL) and head then
		damage = self._health
		damage_percent = 100
	end

	local headshot_multiplier = 1
	local is_attacker_player = attack_data.attacker_unit == managers.player:player_unit()

	if is_attacker_player then
		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE) and head then
			headshot_multiplier = headshot_multiplier * (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE) or 1)
		end

		if head then
			managers.player:on_headshot_dealt()
		end
	end

	if self._damage_reduction_multiplier then
		damage = damage * self._damage_reduction_multiplier
	elseif head then
		if self._char_tweak.headshot_dmg_mul then
			local helmet_hs_multi = self._helmet_popped and math.max(1, self._char_tweak.headshot_dmg_mul) or self._char_tweak.headshot_dmg_mul

			damage = damage * helmet_hs_multi * headshot_multiplier
		else
			damage = self._health
		end
	end

	local is_crit_hit = false

	if is_attacker_player then
		is_crit_hit, damage = self:roll_critical_hit(damage)
	end

	damage = self:_apply_damage_modifier(damage)

	local is_kill_shot = damage >= self._health

	if is_attacker_player then
		local pos = self._spine2_obj:position()

		managers.hud:on_hit_confirmed({
			hit_type = HUDHitConfirm.HIT_SPLINTER,
			is_killshot = is_kill_shot,
			pos = pos,
		})
	end

	if is_kill_shot then
		attack_data.damage = self._health
		result = {
			type = "death",
			variant = attack_data.variant,
		}

		self:die(attack_data)
		self:chk_killshot(attack_data.attacker_unit, "fire")

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) then
			local health_amount_regen = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) or 0

			if is_attacker_player then
				managers.player:local_player():character_damage():restore_health(health_amount_regen * managers.player:local_player():character_damage():get_max_health(), true)
			end
		end
	else
		attack_data.damage = damage
		result = {
			type = attack_data.variant == "stun" and "hurt_sick" or self:get_damage_type(damage_percent, "fire"),
			variant = attack_data.variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position
	attack_data.headshot = head

	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	if result.type == "death" then
		local data = {
			head_shot = head,
			name = self._unit:base()._tweak_table,
			owner = attack_data.owner,
			stats_name = self._unit:base()._stats_name,
			unit_key = self._unit:key(),
			variant = attack_data.variant,
			weapon_unit = attack_data.weapon_unit,
		}

		managers.statistics:killed_by_anyone(data)

		if is_attacker_player then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit:base()._tweak_table)
			end

			managers.statistics:killed(data)
		end
	end

	if alive(attacker) and attacker:base() and attacker:base().add_damage_result then
		attacker:base():add_damage_result(self._unit, result.type == "death", damage_percent)
	end

	if not attack_data.is_fire_dot_damage then
		local fire_dot_data = attack_data.fire_dot_data
		local char_tweak = tweak_data.character[self._unit:base()._tweak_table]
		local flammable = char_tweak.flammable ~= nil and char_tweak.flammable or true
		local distance = 1000
		local hit_loc = attack_data.col_ray.hit_position

		if hit_loc and alive(attacker_unit) and attacker_unit.position then
			distance = mvector3.distance(hit_loc, attacker_unit:position())
		end

		local fire_dot_max_distance = 3000
		local fire_dot_trigger_chance = 30

		if fire_dot_data then
			fire_dot_max_distance = tonumber(fire_dot_data.trigger_max_distance)
			fire_dot_trigger_chance = tonumber(fire_dot_data.trigger_chance)
		end

		local start_dot_damage_roll = math.random(1, 100)
		local start_dot_dance_antimation = false

		if flammable and distance < fire_dot_max_distance and start_dot_damage_roll <= fire_dot_trigger_chance then
			local _, play_animation = self:apply_dot(attack_data.fire_dot_type, attack_data.weapon_unit)

			start_dot_dance_antimation = play_animation
		end

		if fire_dot_data then
			fire_dot_data.start_dot_dance_antimation = start_dot_dance_antimation
			attack_data.fire_dot_data = fire_dot_data
		end
	end

	self:_send_fire_attack_result(attack_data, attacker, damage_percent, attack_data.is_fire_dot_damage, attack_data.col_ray.ray)
	self:_on_damage_received(attack_data)
end

function CopDamage:damage_dot(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	local result
	local damage = attack_data.damage

	damage = self:_apply_damage_modifier(damage)
	damage = math.clamp(damage, 0, self._HEALTH_INIT)

	local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)

	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	if self._immortal then
		damage = 0
		damage_percent = 0
	end

	local head = self._head_body_name and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT) and not head or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE) and head then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_EXPLOSION) or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_MELEE) then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_AUTO_KILL) and head then
		damage = self._health
		damage_percent = 100
	end

	if damage >= self._health then
		attack_data.damage = self._health
		result = {
			type = "death",
			variant = attack_data.variant,
		}

		self:die(attack_data)
		self:chk_killshot(attack_data.attacker_unit, attack_data.variant or "dot")

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) then
			local health_amount_regen = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) or 0

			if attack_data.attacker_unit == managers.player:local_player() then
				managers.player:local_player():character_damage():restore_health(health_amount_regen * managers.player:local_player():character_damage():get_max_health(), true)
			end
		end
	else
		attack_data.damage = damage

		local result_type = attack_data.hurt_animation and self:get_damage_type(damage_percent, attack_data.variant) or "dmg_rcv"

		result = {
			type = result_type,
			variant = attack_data.variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position

	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local attacker_unit = attack_data.attacker_unit

	if result.type == "death" then
		local data = {
			head_shot = head,
			name = self._unit:base()._tweak_table,
			owner = attack_data.owner,
			stats_name = self._unit:base()._stats_name,
			unit_key = self._unit:key(),
			variant = attack_data.variant,
			weapon_unit = attack_data.weapon_unit,
		}

		managers.statistics:killed_by_anyone(data)

		if attacker_unit == managers.player:player_unit() then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit:base()._tweak_table)
			end

			managers.statistics:killed(data)
		end
	end

	self:_send_dot_attack_result(attack_data, attacker, damage_percent, attack_data.variant, attack_data.col_ray.ray)
	self:_on_damage_received(attack_data)
end

function CopDamage:damage_explosion(attack_data)
	self._last_damage_direction = attack_data.col_ray.ray

	if self._dead or self._invulnerable then
		return
	end

	local death_event_params = {}

	death_event_params.damage_type = WeaponTweakData.DAMAGE_TYPE_EXPLOSION
	death_event_params.damage = attack_data.damage
	death_event_params.enemy_type = tweak_data.character[self._unit:base()._tweak_table].type
	death_event_params.special_enemy_type = tweak_data.character[self._unit:base()._tweak_table].special_type
	death_event_params.enemy_marked = self._marked_dmg_mul ~= nil

	local result
	local damage = attack_data.damage
	local attacker_unit = attack_data.attacker_unit

	if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	local is_civilian = CopDamage.is_civilian(self._unit:base()._tweak_table)
	local player_unit = managers.player:local_player()
	local is_attacker_player = attacker_unit == player_unit

	damage = damage * (self._char_tweak.damage.explosion_damage_mul or 1)
	damage = damage * (self._marked_dmg_mul or 1)
	damage = self:_apply_damage_modifier(damage)
	damage = math.clamp(damage, 0, self._HEALTH_INIT)

	local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)

	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	if self._immortal then
		damage = 0
		damage_percent = 0
	end

	local head

	if self._head_body_name and attack_data.variant ~= "stun" then
		head = attack_data.col_ray.body and self._head_body_key and attack_data.col_ray.body:key() == self._head_body_key

		local body = self._unit:body(self._head_body_name)

		self:_spawn_head_gadget({
			dir = -attack_data.col_ray.ray,
			position = body:position(),
			rotation = body:rotation(),
		})
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT) and not head or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE) and head then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_IMPERVIOUS_TO_EXPLOSIVE_DAMAGE) then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_MELEE) and not managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_EXPLOSION) then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_AUTO_KILL) and head then
		damage = self._health
		damage_percent = 100
	end

	local is_crit_hit = false

	if is_attacker_player then
		is_crit_hit, damage = self:roll_critical_hit(damage)
	end

	local is_kill_shot = damage >= self._health

	if is_attacker_player and damage > 0 then
		local pos = self._spine2_obj:position()

		managers.hud:on_hit_confirmed({
			hit_type = HUDHitConfirm.HIT_SPLINTER,
			is_crit = death_event_params.critical_hit,
			is_killshot = is_kill_shot,
			pos = pos,
		})
	end

	if is_kill_shot then
		attack_data.damage = self._health
		result = {
			type = "death",
			variant = attack_data.variant,
		}

		self:die(attack_data)

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) then
			local health_amount_regen = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) or 0

			if is_attacker_player then
				attacker_unit:character_damage():restore_health(health_amount_regen * attacker_unit:character_damage():get_max_health(), true)
			end
		end
	else
		attack_data.damage = damage

		local result_type = attack_data.variant == "stun" and "hurt_sick" or self:get_damage_type(damage_percent, "explosion")

		result = {
			type = result_type,
			variant = attack_data.variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position
	attack_data.headshot = head

	if not attacker_unit or attacker_unit:id() == -1 then
		attacker_unit = self._unit
	end

	if result.type == "death" then
		local dismember_victim = false

		if self:_dismember_condition(attack_data, true) then
			death_event_params.dismemberment_occured = true

			self:_dismember_body_part(attack_data)

			dismember_victim = true
		end

		local data = {
			dismembered = dismember_victim,
			head_shot = head,
			name = self._unit:base()._tweak_table,
			owner = attack_data.owner,
			stats_name = self._unit:base()._stats_name,
			unit_key = self._unit:key(),
			variant = attack_data.variant,
			weapon_unit = attack_data.weapon_unit,
		}

		managers.statistics:killed_by_anyone(data)

		attacker_unit = attack_data.attacker_unit

		if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
			data.weapon_unit = attack_data.attacker_unit
		end

		self:chk_killshot(attacker_unit, "explosion")

		if is_attacker_player then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit:base()._tweak_table)
			end

			managers.statistics:killed(data)
			managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_KILLED_ENEMY, death_event_params)
		end
	end

	if alive(attacker_unit) and attacker_unit:base() and attacker_unit:base().add_damage_result then
		attacker_unit:base():add_damage_result(self._unit, result.type == "death", damage_percent)
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(attack_data.pos, attack_data.col_ray.ray)
	end

	self:_send_explosion_attack_result(attack_data, attack_data.attacker_unit, damage_percent, self:_get_attack_variant_index(attack_data.result.variant), attack_data.col_ray.ray)
	self:_on_damage_received(attack_data)

	if is_attacker_player and not is_civilian then
		local damage_enemy_params = {
			attack_data = attack_data,
			unit = self._unit,
		}

		managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_DAMAGED_ENEMY, damage_enemy_params)
	end

	return result
end

function CopDamage:roll_critical_hit(damage, ray)
	local critical_hit = managers.player:roll_crits(ray and ray.distance)

	if critical_hit then
		local critical_damage_mul = self._char_tweak.headshot_dmg_mul
		local critical_hits = self._char_tweak.critical_hits

		if critical_hits and critical_hits.damage_mul then
			critical_damage_mul = critical_hits.damage_mul
		end

		critical_damage_mul = critical_damage_mul + (managers.player:upgrade_value("player", "critbrain_critical_hit_damage", 1) - 1)
		damage = damage * critical_damage_mul
	end

	return critical_hit, damage
end

function CopDamage:damage_tase(attack_data)
	if self._dead or self._invulnerable then
		if self._invulnerable then
			print("INVULNERABLE!  Not tasing.")
		end

		return
	end

	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		return "friendly_fire"
	end

	if self._tase_effect then
		World:effect_manager():fade_kill(self._tase_effect)
	end

	self._tase_effect = World:effect_manager():spawn(self._tase_effect_table)

	local result
	local damage = attack_data.damage

	if attack_data.attacker_unit == managers.player:player_unit() then
		local critical_hit, crit_damage = self:roll_critical_hit(damage)

		damage = crit_damage

		if attack_data.weapon_unit then
			local wep_type_shotgun

			if alive(attack_data.weapon_unit) and attack_data.weapon_unit:base().weapon_tweak_data and attack_data.weapon_unit:base():weapon_tweak_data().category == WeaponTweakData.WEAPON_CATEGORY_SHOTGUN then
				wep_type_shotgun = true
			end

			managers.hud:on_hit_confirmed({
				hit_type = wep_type_shotgun and HUDHitConfirm.HIT_SPLINTER or HUDHitConfirm.HIT_NORMAL,
				is_crit = death_event_params.critical_hit,
			})
		end
	end

	damage = self:_apply_damage_modifier(damage)
	damage = math.clamp(damage, 0, self._HEALTH_INIT)

	local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)

	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	local head

	if self._head_body_name then
		head = attack_data.col_ray.body and self._head_body_key and attack_data.col_ray.body:key() == self._head_body_key

		local body = self._unit:body(self._head_body_name)

		self:_spawn_head_gadget({
			dir = -attack_data.col_ray.ray,
			position = body:position(),
			rotation = body:rotation(),
		})
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT) and not head or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE) and head then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_EXPLOSION) or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_MELEE) then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_AUTO_KILL) and head then
		damage = self._health
		damage_percent = 100
	end

	if damage >= self._health then
		attack_data.damage = self._health
		result = {
			type = "death",
			variant = WeaponTweakData.DAMAGE_TYPE_BULLET,
		}

		self:die(attack_data)
		self:chk_killshot(attack_data.attacker_unit, "tase")

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) then
			local health_amount_regen = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) or 0

			if attack_data.attacker_unit == managers.player:local_player() then
				managers.player:local_player():character_damage():restore_health(health_amount_regen * managers.player:local_player():character_damage():get_max_health(), true)
			end
		end
	else
		attack_data.damage = damage

		local type = "taser_tased"

		if not self._char_tweak.damage.hurt_severity.tase then
			type = "none"
		end

		result = {
			type = type,
			variant = attack_data.variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position
	attack_data.headshot = head

	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	if result.type == "death" then
		local data = {
			head_shot = head,
			name = self._unit:base()._tweak_table,
			owner = attack_data.owner,
			stats_name = self._unit:base()._stats_name,
			unit_key = self._unit:key(),
			variant = attack_data.variant,
			weapon_unit = attack_data.weapon_unit,
		}

		managers.statistics:killed_by_anyone(data)

		local attacker_unit = attack_data.attacker_unit

		if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
			data.weapon_unit = attack_data.attacker_unit
		end

		if attacker_unit == managers.player:player_unit() then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit:base()._tweak_table)
			end

			managers.statistics:killed(data)
		end
	end

	if alive(attacker) and attacker:base() and attacker:base().add_damage_result then
		attacker:base():add_damage_result(self._unit, result.type == "death", damage_percent)
	end

	local variant = result.variant == "heavy" and 1 or 0

	self:_send_tase_attack_result(attack_data, damage_percent, variant)
	self:_on_damage_received(attack_data)

	return result
end

function CopDamage:_dismember_condition(attack_data, force_dismemberment)
	if not self._char_tweak.dismemberment_enabled then
		return
	end

	if force_dismemberment or Global.force_dismemberment or managers.player:upgrade_value("player", "warcry_dismember_always", false) == true then
		return true
	end

	if not alive(attack_data.weapon_unit) then
		return false
	end

	local weapon_base = attack_data.weapon_unit:base()
	local dismember_chance = weapon_base.dismember_chance and weapon_base:dismember_chance()

	if not dismember_chance or dismember_chance <= 0 then
		return false
	end

	local roll = math.rand(1)

	return roll <= dismember_chance
end

function CopDamage:damage_melee(attack_data)
	self._last_damage_direction = attack_data.col_ray.ray

	if self._dead or self._invulnerable then
		return
	end

	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		return "friendly_fire"
	end

	local result
	local head = self._head_body_name and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name
	local player_unit = managers.player:local_player()
	local is_attacker_player = attack_data and attack_data.attacker_unit == player_unit
	local death_event_params = {}

	death_event_params.damage = attack_data.damage
	death_event_params.damage_type = WeaponTweakData.DAMAGE_TYPE_MELEE
	death_event_params.enemy_type = tweak_data.character[self._unit:base()._tweak_table].type
	death_event_params.special_enemy_type = tweak_data.character[self._unit:base()._tweak_table].special_type
	death_event_params.enemy_marked = self._marked_dmg_mul ~= nil

	local damage = attack_data.damage
	local weapon_headshot_multiplier = 1
	local weapon_unit = attack_data.weapon_unit

	if alive(weapon_unit) and weapon_unit:base().weapon_tweak_data then
		weapon_headshot_multiplier = weapon_unit:base():weapon_tweak_data().headshot_multiplier or 1
	end

	if is_attacker_player then
		local critical_hit, crit_damage = self:roll_critical_hit(damage)

		if critical_hit then
			death_event_params.critical_hit = true
			damage = crit_damage
		end

		managers.hud:on_hit_confirmed({
			hit_type = HUDHitConfirm.HIT_NORMAL,
			is_crit = critical_hit,
			is_headshot = attack_data.can_headshot and head,
			is_killshot = damage > self._health,
		})
	end

	damage = damage * (self._marked_dmg_mul or 1)

	if self:is_surprise_leeway() then
		damage = self._HEALTH_INIT
	end

	if self._damage_reduction_multiplier then
		damage = damage * self._damage_reduction_multiplier
	elseif attack_data.can_headshot and head then
		if self._char_tweak.headshot_dmg_mul then
			damage = damage * weapon_headshot_multiplier * self._char_tweak.headshot_dmg_mul
		else
			damage = self._health * 10
		end
	end

	local damage_effect = attack_data.damage_effect
	local damage_effect_percent

	damage = self:_apply_damage_modifier(damage)
	damage = math.clamp(damage, self._HEALTH_INIT_PRECENT, self._HEALTH_INIT)

	local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)

	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	if self._immortal then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT) and not head or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE) and head then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_EXPLOSION) and not managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_VULNERABLE_ONLY_TO_MELEE) then
		damage = 0
		damage_percent = 0
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_HEADSHOT_AUTO_KILL) and head then
		damage = self._health
		damage_percent = 100
	end

	if damage >= self._health then
		damage_effect_percent = 1
		attack_data.damage = self._health
		result = {
			type = "death",
			variant = attack_data.variant,
		}

		self:die(attack_data)
		self:chk_killshot(attack_data.attacker_unit, WeaponTweakData.DAMAGE_TYPE_MELEE)

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_MELEE_KILL_REGENERATES_HEALTH) then
			local health_amount_regen = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_MELEE_KILL_REGENERATES_HEALTH) or 0

			if is_attacker_player then
				player_unit:character_damage():restore_health(health_amount_regen * player_unit:character_damage():get_max_health(), true)
			end
		end

		if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) then
			local health_amount_regen = managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_KILL_REGENERATES_HEALTH) or 0

			if is_attacker_player then
				player_unit:character_damage():restore_health(health_amount_regen * player_unit:character_damage():get_max_health(), true)
			end
		end
	else
		attack_data.damage = damage
		damage_effect = math.clamp(damage_effect, self._HEALTH_INIT_PRECENT, self._HEALTH_INIT)
		damage_effect_percent = math.ceil(damage_effect / self._HEALTH_INIT_PRECENT)
		damage_effect_percent = math.clamp(damage_effect_percent, 1, self._HEALTH_GRANULARITY)

		local result_type = attack_data.shield_knock and "shield_knock" or attack_data.variant == "counter_tased" and "counter_tased" or attack_data.variant == "taser_tased" and "taser_tased" or self:get_damage_type(damage_effect_percent, WeaponTweakData.DAMAGE_TYPE_MELEE) or "fire_hurt"

		result = {
			type = result_type,
			variant = attack_data.variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position
	attack_data.headshot = head

	local dismember_victim = false

	if result.type == "death" then
		local melee_weapon_used = attack_data.weapon_unit:base().is_melee_weapon and attack_data.weapon_unit:base():is_melee_weapon()
		local force_dismember = attack_data.can_headshot and head

		if melee_weapon_used and self:_dismember_condition(attack_data, force_dismember) then
			death_event_params.dismemberment_occured = true

			self:_dismember_body_part(attack_data)

			dismember_victim = true
		end

		local data = {
			dismembered = dismember_victim,
			head_shot = head,
			name = self._unit:base()._tweak_table,
			name_id = attack_data.name_id,
			stats_name = self._unit:base()._stats_name,
			unit_key = self._unit:key(),
			variant = attack_data.variant,
			weapon_unit = weapon_unit,
		}

		managers.statistics:killed_by_anyone(data)

		if is_attacker_player then
			self:_comment_death(attack_data.attacker_unit, self._unit:base()._tweak_table)
			managers.statistics:killed(data)
			managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_KILLED_ENEMY, death_event_params)
		end
	end

	local hit_offset_height = math.clamp(attack_data.col_ray.position.z - self._unit:movement():m_pos().z, 0, 300)
	local variant

	variant = result.type == "shield_knock" and 1 or result.type == "counter_tased" and 2 or result.type == "expl_hurt" and 4 or result.type == "taser_tased" and 5 or dismember_victim and 6 or 0

	local body_index = self._unit:get_body_index(attack_data.col_ray.body:name())

	self:_send_melee_attack_result(attack_data, damage_percent, damage_effect_percent, hit_offset_height, variant, body_index)
	self:_on_damage_received(attack_data)

	if is_attacker_player then
		local damage_enemy_params = {
			attack_data = attack_data,
			unit = self._unit,
		}

		managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_DAMAGED_ENEMY, damage_enemy_params)
		managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_DAMAGED_ENEMY_MELEE, damage_enemy_params)
	end

	return result
end

function CopDamage:damage_mission(attack_data)
	if self._dead or (self._invulnerable or self._immortal) and not attack_data.forced then
		return
	end

	local result
	local damage_percent = self._HEALTH_GRANULARITY

	attack_data.damage = self._health
	result = {
		type = "death",
		variant = attack_data.variant,
	}

	self:die(attack_data)

	attack_data.result = result
	attack_data.attack_dir = self._unit:rotation():y()
	attack_data.pos = self._unit:position()

	local attacker_unit = attack_data.attacker_unit

	if attacker_unit and attacker_unit == managers.player:local_player() then
		if alive(attacker_unit) then
			self:_comment_death(attacker_unit, self._unit:base()._tweak_table)
		end

		local data = {
			head_shot = false,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			variant = "explosion",
			weapon_unit = attack_data.weapon_unit,
		}

		managers.statistics:killed(data)

		local death_event_params = {}

		death_event_params.damage = attack_data.damage
		death_event_params.damage_type = WeaponTweakData.DAMAGE_TYPE_EXPLOSION
		death_event_params.enemy_type = tweak_data.character[self._unit:base()._tweak_table].type
		death_event_params.special_enemy_type = tweak_data.character[self._unit:base()._tweak_table].special_type
		death_event_params.weapon_used = attack_data.weapon_unit
		death_event_params.enemy_marked = self._marked_dmg_mul ~= nil

		managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_KILLED_ENEMY, death_event_params)
	end

	if not attacker_unit or attacker_unit:id() == -1 then
		attacker_unit = self._unit
	end

	self:_send_explosion_attack_result(attack_data, attacker_unit, damage_percent, self:_get_attack_variant_index("explosion"), attack_data.col_ray and attack_data.col_ray.ray)
	self:_on_damage_received(attack_data)

	return result
end

function CopDamage:get_ranged_attack_autotarget_data_fast()
	return {
		object = self._autotarget_data.fast,
	}
end

function CopDamage:get_ranged_attack_autotarget_data(shoot_from_pos, aim_vec)
	local autotarget_data

	autotarget_data = {
		body = self._unit:body("b_spine1"),
	}

	local dis = mvector3.distance(shoot_from_pos, self._unit:position())

	if dis > 3500 then
		autotarget_data = {
			body = self._unit:body("b_spine1"),
		}
	else
		self._aim_bodies = {}

		table.insert(self._aim_bodies, self._unit:body("b_right_thigh"))
		table.insert(self._aim_bodies, self._unit:body("b_left_thigh"))
		table.insert(self._aim_bodies, self._unit:body("b_head"))
		table.insert(self._aim_bodies, self._unit:body("b_left_lower_arm"))
		table.insert(self._aim_bodies, self._unit:body("b_right_lower_arm"))

		local uncovered_body, best_angle

		for i, body in ipairs(self._aim_bodies) do
			local body_pos = body:center_of_mass()
			local body_vec = body_pos - shoot_from_pos
			local body_angle = body_vec:angle(aim_vec)

			if not best_angle or body_angle < best_angle then
				local aim_ray = World:raycast("ray", shoot_from_pos, body_pos, "sphere_cast_radius", 30, "bundle", 4, "slot_mask", managers.slot:get_mask("melee_equipment"))

				if not aim_ray then
					uncovered_body = body
					best_angle = body_angle
				end
			end
		end

		if uncovered_body then
			autotarget_data = {
				body = uncovered_body,
			}
		else
			autotarget_data = {
				body = self._unit:body("b_spine1"),
			}
		end
	end

	return autotarget_data
end

function CopDamage:get_impact_segment(position)
	local closest_dist_sq, closest_bone

	for _, bone_name in pairs(self._impact_bones) do
		local bone_obj = self._unit:get_object(bone_name)
		local bone_dist_sq = mvector3.distance_sq(position, bone_obj:position())

		if not closest_bone or bone_dist_sq < closest_dist_sq then
			closest_bone = bone_obj
			closest_dist_sq = bone_dist_sq
		end
	end

	local parent_bone, child_bone, closest_child

	closest_dist_sq = nil

	for _, bone_obj in ipairs(closest_bone:children()) do
		if self._impact_bones[bone_obj:name():key()] then
			local bone_dist_sq = mvector3.distance_sq(position, bone_obj:position())

			if not closest_dist_sq or bone_dist_sq < closest_dist_sq then
				closest_child = bone_obj
				closest_dist_sq = bone_dist_sq
			end
		end
	end

	local bone_obj = closest_bone:parent()

	if bone_obj and self._impact_bones[bone_obj:name():key()] then
		local bone_dist_sq = mvector3.distance_sq(position, bone_obj:position())

		if not closest_dist_sq or bone_dist_sq < closest_dist_sq then
			parent_bone = bone_obj
			child_bone = closest_bone
		end
	end

	if not parent_bone then
		parent_bone = closest_bone
		child_bone = closest_child
	end

	return parent_bone, child_bone
end

function CopDamage:_spawn_head_gadget(params)
	if not self._head_gear then
		return
	end

	if self._head_gear_object then
		if self._nr_head_gear_objects then
			for i = 1, self._nr_head_gear_objects do
				local head_gear_obj_name = self._head_gear_object .. tostring(i)

				self._unit:get_object(Idstring(head_gear_obj_name)):set_visibility(false)
			end
		else
			self._unit:get_object(Idstring(self._head_gear_object)):set_visibility(false)
		end

		if self._head_gear_decal_mesh then
			local mesh_name_idstr = Idstring(self._head_gear_decal_mesh)

			self._unit:decal_surface(mesh_name_idstr):set_mesh_material(mesh_name_idstr, Idstring("flesh"))
		end
	end

	local unit = World:spawn_unit(Idstring(self._head_gear), params.position, params.rotation)

	if not params.skip_push then
		local dir = math.UP - params.dir / 2

		dir = dir:spread(25)

		local body = unit:body(0)

		body:push_at(body:mass(), dir * math.lerp(300, 650, math.random()), unit:position() + Vector3(math.rand(1), math.rand(1), math.rand(1)))
	end

	self._head_gear = false
end

function CopDamage:dead()
	return self._dead
end

function CopDamage:_remove_debug_gui()
	if alive(self._gui) and alive(self._ws) then
		self._gui:destroy_workspace(self._ws)

		self._ws = nil
		self._gui = nil
	end
end

function CopDamage:die(attack_data)
	if self._immortal then
		debug_pause("Immortal character died!")
	end

	self:_remove_debug_gui()
	self._unit:base():set_slot(self._unit, 17)

	if self._pickup then
		self:drop_pickup()
	elseif attack_data.drop_loot == nil or attack_data.drop_loot == true then
		local loot_table = self._unit:base():char_tweak().loot_table

		if loot_table then
			local killer = attack_data.attacker_unit
			local tracker = self._unit:movement():nav_tracker()
			local position = tracker:lost() and tracker:field_position() or tracker:position()
			local rotation = self._unit:rotation()

			managers.drop_loot:enemy_drop_item(loot_table, killer, position, rotation)
		end
	end

	self._unit:base():set_gear_dead()
	self._unit:inventory():drop_shield()

	if self._unit:unit_data().mission_element then
		self._unit:unit_data().mission_element:event("death", self._unit)

		if not self._unit:unit_data().alerted_event_called then
			self._unit:unit_data().alerted_event_called = true

			self._unit:unit_data().mission_element:event("alerted", self._unit)
		end
	end

	if self._unit:movement() then
		self._unit:movement():remove_giveaway()
	end

	self._health = 0
	self._health_ratio = 0
	self._dead = true

	self:set_mover_collision_state(false)

	if self._death_sequence then
		if self._unit:damage() then
			self._unit:damage():has_then_run_sequence_simple(self._death_sequence)
		else
			debug_pause_unit(self._unit, "[CopDamage:die] does not have death sequence", self._death_sequence, self._unit)
		end
	end

	if self._unit:base():char_tweak().die_sound_event then
		self._unit:sound():play(self._unit:base():char_tweak().die_sound_event, nil, nil)
	end

	local weapon_data = tweak_data.blackmarket.melee_weapons[attack_data.name_id]

	if weapon_data and weapon_data.sounds and weapon_data.sounds.killing_blow then
		self._unit:sound():play(weapon_data.sounds.killing_blow, nil, nil)
	end

	self._unit:damage():add_body_collision_callback(callback(self, self, "clbk_impact"))
end

function CopDamage:clbk_impact(state)
	if self._body_drop_detected then
		return
	end

	if state and state == Idstring("large") then
		self._body_drop_detected = true

		local character_tweak = tweak_data.character[self._unit:base()._tweak_table]

		if character_tweak and character_tweak.dead_body_drop_sound then
			self._unit:sound():play(character_tweak.dead_body_drop_sound, nil, nil)
		end
	end
end

function CopDamage:set_mover_collision_state(state)
	local change_state

	if state then
		if self._mover_collision_state then
			if self._mover_collision_state == -1 then
				self._mover_collision_state = nil
				change_state = true
			else
				self._mover_collision_state = self._mover_collision_state + 1
			end
		end
	elseif self._mover_collision_state then
		self._mover_collision_state = self._mover_collision_state - 1
	else
		self._mover_collision_state = -1
		change_state = true
	end

	if change_state then
		local body = self._mover_blocker and self._unit:body(self._mover_blocker) or false

		if body then
			body:set_enabled(state)
		end
	end
end

function CopDamage:anim_clbk_mover_collision_state(unit, state)
	state = state == "true" and true or false

	self:set_mover_collision_state(state)
end

function CopDamage:drop_pickup()
	if self._pickup then
		local tracker = self._unit:movement():nav_tracker()
		local position = tracker:lost() and tracker:field_position() or tracker:position()
		local rotation = self._unit:rotation()

		managers.game_play_central:spawn_pickup({
			name = self._pickup,
			position = position + Vector3(0, 0, 1.5),
			rotation = rotation,
		})
	end
end

function CopDamage:sync_damage_knockdown(attacker_unit, damage_percent, i_body, hit_offset_height, death)
	if self._dead then
		return
	end

	local body = self._unit:body(i_body)
	local damage = damage_percent * self._HEALTH_INIT_PRECENT
	local attack_data = {}
	local hit_pos = mvector3.copy(self._unit:movement():m_pos())

	mvector3.set_z(hit_pos, hit_pos.z + hit_offset_height)

	attack_data.pos = hit_pos

	local attack_dir, distance

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:movement():m_head_pos()
		distance = mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir

	local result = {
		type = "expl_hurt",
		variant = "expl_hurt",
	}

	attack_data.variant = "expl_hurt"
	attack_data.attacker_unit = attacker_unit
	attack_data.result = result
	attack_data.damage = damage

	self:_on_damage_received(attack_data)
end

function CopDamage:sync_damage_bullet(attacker_unit, damage_percent, i_body, hit_offset_height, death)
	if self._dead then
		return
	end

	local body = self._unit:body(i_body)
	local head = self._head_body_name and body and body:name() == self._ids_head_body_name
	local damage = damage_percent * self._HEALTH_INIT_PRECENT
	local attack_data = {}
	local hit_pos = mvector3.copy(self._unit:movement():m_pos())

	mvector3.set_z(hit_pos, hit_pos.z + hit_offset_height)

	attack_data.pos = hit_pos
	attack_data.headshot = head

	local attack_dir, distance

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:movement():m_head_pos()
		distance = mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir

	local shotgun_push, result

	if death then
		if head and damage > math.random(10) then
			self:_spawn_head_gadget({
				dir = attack_dir,
				position = body:position(),
				rotation = body:rotation(),
			})
		end

		result = {
			type = "death",
			variant = WeaponTweakData.DAMAGE_TYPE_BULLET,
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, WeaponTweakData.DAMAGE_TYPE_BULLET)

		local data = {
			head_shot = head,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			variant = attack_data.variant,
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
		}

		if data.weapon_unit then
			managers.statistics:killed_by_anyone(data)

			if data.weapon_unit:base():weapon_tweak_data().is_shotgun and distance and distance < 500 then
				shotgun_push = true
			end
		end
	else
		local result_type = self:get_damage_type(damage_percent, WeaponTweakData.DAMAGE_TYPE_BULLET)

		result = {
			type = result_type,
			variant = WeaponTweakData.DAMAGE_TYPE_BULLET,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.variant = WeaponTweakData.DAMAGE_TYPE_BULLET
	attack_data.attacker_unit = attacker_unit
	attack_data.result = result
	attack_data.damage = damage

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	self:_send_sync_bullet_attack_result(attack_data, hit_offset_height)
	self:_on_damage_received(attack_data)

	if shotgun_push then
		managers.game_play_central:do_shotgun_push(self._unit, hit_pos, attack_dir, distance)
	end
end

function CopDamage:chk_killshot(attacker_unit, variant)
	if attacker_unit and attacker_unit == managers.player:player_unit() then
		managers.player:on_killshot(self._unit, variant)
	end
end

function CopDamage:sync_damage_explosion(attacker_unit, damage_percent, i_attack_variant, death, direction)
	if self._dead then
		return
	end

	local variant = CopDamage._ATTACK_VARIANTS[i_attack_variant]
	local damage = damage_percent * self._HEALTH_INIT_PRECENT
	local attack_data = {
		variant = variant,
	}
	local result

	if death then
		result = {
			type = "death",
			variant = variant,
		}

		self:die(attack_data)

		local data = {
			head_shot = false,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			variant = "explosion",
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
		}

		managers.statistics:killed_by_anyone(data)
	else
		local result_type = variant == "stun" and "hurt_sick" or self:get_damage_type(damage_percent, "explosion")

		result = {
			type = result_type,
			variant = variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.attacker_unit = attacker_unit
	attack_data.result = result
	attack_data.damage = damage

	local attack_dir

	if direction then
		attack_dir = direction
	elseif attacker_unit then
		attack_dir = self._unit:position() - attacker_unit:position()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir

	if self._head_body_name then
		local body = self._unit:body(self._head_body_name)

		self:_spawn_head_gadget({
			dir = Vector3(),
			position = body:position(),
			rotation = body:rotation(),
			skip_push = true,
		})
	end

	local is_kill_shot = result.type == "death"

	if attack_data.attacker_unit and attack_data.attacker_unit == managers.player:player_unit() then
		managers.hud:on_hit_confirmed({
			hit_type = HUDHitConfirm.HIT_SPLINTER,
			is_killshot = is_kill_shot,
		})
	end

	if is_kill_shot then
		local data = {
			head_shot = false,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			unit_key = self._unit:key(),
			variant = "explosion",
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
		}
		local attacker_unit = attack_data.attacker_unit

		if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
			data.weapon_unit = attack_data.attacker_unit
		end

		self:chk_killshot(attacker_unit, "explosion")

		if attacker_unit == managers.player:player_unit() then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit:base()._tweak_table)
			end

			managers.statistics:killed(data)

			local death_event_params = {}

			death_event_params.damage = attack_data.damage
			death_event_params.damage_type = WeaponTweakData.DAMAGE_TYPE_EXPLOSION
			death_event_params.enemy_type = tweak_data.character[self._unit:base()._tweak_table].type
			death_event_params.special_enemy_type = tweak_data.character[self._unit:base()._tweak_table].special_type
			death_event_params.enemy_marked = self._marked_dmg_mul ~= nil

			if self:_dismember_condition(attack_data, true) then
				death_event_params.dismemberment_occured = true
			end

			managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.PLAYER_KILLED_ENEMY, death_event_params)
		end
	end

	if alive(attacker_unit) and attacker_unit:base() and attacker_unit:base().add_damage_result then
		attacker_unit:base():add_damage_result(self._unit, result.type == "death", damage_percent)
	end

	if not self._no_blood then
		local hit_pos = mvector3.copy(self._unit:movement():m_pos())

		mvector3.set_z(hit_pos, hit_pos.z + 100)
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	attack_data.pos = self._unit:position()

	mvector3.set_z(attack_data.pos, attack_data.pos.z + math.random() * 180)
	self:_send_sync_explosion_attack_result(attack_data)
	self:_on_damage_received(attack_data)
end

function CopDamage:sync_damage_fire(attacker_unit, damage_percent, start_dot_dance_antimation, death, direction, weapon_type, weapon_id)
	if self._dead then
		return
	end

	local variant = "fire"
	local damage = damage_percent * self._HEALTH_INIT_PRECENT
	local is_fire_dot_damage = false
	local attack_data = {
		variant = variant,
	}
	local result

	if weapon_type then
		local fire_dot

		if weapon_type == CopDamage.WEAPON_TYPE_GRANADE then
			fire_dot = tweak_data.grenades[weapon_id].fire_dot_data
		elseif weapon_type == CopDamage.WEAPON_TYPE_BULLET then
			if tweak_data.weapon.factory.parts[weapon_id].custom_stats then
				fire_dot = tweak_data.weapon.factory.parts[weapon_id].custom_stats.fire_dot_data
			end
		elseif weapon_type == CopDamage.WEAPON_TYPE_FLAMER and tweak_data.weapon[weapon_id].fire_dot_data then
			fire_dot = tweak_data.weapon[weapon_id].fire_dot_data
		end

		attack_data.fire_dot_data = fire_dot

		if attack_data.fire_dot_data then
			attack_data.fire_dot_data.start_dot_dance_antimation = start_dot_dance_antimation
		end
	end

	if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	local is_attacker_player = attacker_unit == managers.player:player_unit()

	if death then
		result = {
			type = "death",
			variant = variant,
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, "fire")

		local data = {
			head_shot = false,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			variant = "fire",
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
		}

		managers.statistics:killed_by_anyone(data)
	else
		local result_type = variant == "stun" and "hurt_sick" or self:get_damage_type(damage_percent, "fire")

		result = {
			type = result_type,
			variant = variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.attacker_unit = attacker_unit
	attack_data.result = result
	attack_data.damage = damage
	attack_data.ignite_character = true
	attack_data.is_fire_dot_damage = is_fire_dot_damage

	local attack_dir

	if direction then
		attack_dir = direction
	elseif attacker_unit then
		attack_dir = self._unit:position() - attacker_unit:position()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir

	if self._head_body_name then
		local body = self._unit:body(self._head_body_name)

		self:_spawn_head_gadget({
			dir = Vector3(),
			position = body:position(),
			rotation = body:rotation(),
			skip_push = true,
		})
	end

	local is_kill_shot = result.type == "death"

	if is_attacker_player then
		local pos = self._spine2_obj:position()

		managers.hud:on_hit_confirmed({
			hit_type = HUDHitConfirm.HIT_SPLINTER,
			is_killshot = is_kill_shot,
			pos = pos,
		})
	end

	if is_kill_shot then
		local data = {
			head_shot = false,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			unit_key = self._unit:key(),
			variant = "fire",
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
		}

		if is_attacker_player then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit:base()._tweak_table)
			end

			managers.statistics:killed(data)
		end
	end

	if alive(attacker_unit) and attacker_unit:base() and attacker_unit:base().add_damage_result then
		attacker_unit:base():add_damage_result(self._unit, is_kill_shot, damage_percent)
	end

	attack_data.pos = self._unit:position()

	mvector3.set_z(attack_data.pos, attack_data.pos.z + math.random() * 180)
	self:_send_sync_fire_attack_result(attack_data)
	self:_on_damage_received(attack_data)
end

function CopDamage:sync_damage_dot(attacker_unit, damage_percent, death, variant, hurt_animation)
	if self._dead then
		return
	end

	local damage = damage_percent * self._HEALTH_INIT_PRECENT
	local attack_data = {
		variant = variant,
	}
	local result

	if death then
		result = {
			type = "death",
			variant = variant,
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, variant or "dot")

		local data = {
			head_shot = false,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			variant = attack_data.variant,
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
		}

		if data.weapon_unit then
			managers.statistics:killed_by_anyone(data)
		end
	else
		local result_type = hurt_animation and self:get_damage_type(damage_percent, variant) or "dmg_rcv"

		result = {
			type = result_type,
			variant = variant,
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.variant = variant
	attack_data.attacker_unit = attacker_unit
	attack_data.result = result
	attack_data.damage = damage

	self:_on_damage_received(attack_data)
end

function CopDamage:_sync_dismember(attacker_unit)
	if not attacker_unit then
		return false
	end

	local attacker_name = managers.criminals:character_name_by_unit(attacker_unit)
	local peer_id = managers.network:session():peer_by_unit(attacker_unit):id()
	local peer = managers.network:session():peer(peer_id)
	local attacker_weapon = peer:melee_id()

	return true
end

function CopDamage:sync_damage_melee(attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death)
	local attack_data = {}
	local body = self._unit:body(i_body)

	attack_data.attacker_unit = attacker_unit

	local damage = damage_percent * self._HEALTH_INIT_PRECENT
	local result

	if death then
		if self:_sync_dismember(attacker_unit) and variant == 6 then
			attack_data.body_name = body:name()

			self:_dismember_body_part(attack_data)
		end

		result = {
			type = "death",
			variant = WeaponTweakData.DAMAGE_TYPE_MELEE,
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, WeaponTweakData.DAMAGE_TYPE_MELEE)

		local data = {
			head_shot = false,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			variant = WeaponTweakData.DAMAGE_TYPE_MELEE,
		}

		managers.statistics:killed_by_anyone(data)
	else
		local result_type = variant == 1 and "shield_knock" or variant == 2 and "counter_tased" or variant == 5 and "taser_tased" or variant == 4 and "expl_hurt" or self:get_damage_type(damage_effect_percent, WeaponTweakData.DAMAGE_TYPE_BULLET) or "fire_hurt"

		result = {
			type = result_type,
			variant = WeaponTweakData.DAMAGE_TYPE_MELEE,
		}

		self:_apply_damage_to_health(damage)

		attack_data.variant = result_type
	end

	attack_data.variant = WeaponTweakData.DAMAGE_TYPE_MELEE
	attack_data.attacker_unit = attacker_unit
	attack_data.result = result
	attack_data.damage = damage

	local attack_dir

	if attacker_unit then
		attack_dir = self._unit:position() - attacker_unit:position()

		mvector3.normalize(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir
	attack_data.pos = self._unit:position()

	mvector3.set_z(attack_data.pos, attack_data.pos.z + math.random() * 180)

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(self._unit:movement():m_pos() + Vector3(0, 0, hit_offset_height), attack_dir)
	end

	self:_send_sync_melee_attack_result(attack_data, hit_offset_height)
	self:_on_damage_received(attack_data)
end

function CopDamage:sync_damage_tase(attacker_unit, damage_percent, variant, death)
	if self._dead then
		return
	end

	if self._tase_effect then
		World:effect_manager():fade_kill(self._tase_effect)
	end

	self._tase_effect = World:effect_manager():spawn(self._tase_effect_table)

	local damage = damage_percent * self._HEALTH_INIT_PRECENT
	local attack_data = {}
	local result

	if death then
		result = {
			type = "death",
			variant = WeaponTweakData.DAMAGE_TYPE_BULLET,
		}

		self:die(WeaponTweakData.DAMAGE_TYPE_BULLET)
		self:chk_killshot(attacker_unit, "tase")

		local data = {
			head_shot = false,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			variant = WeaponTweakData.DAMAGE_TYPE_MELEE,
		}

		managers.statistics:killed_by_anyone(data)
	else
		result = {
			type = "taser_tased",
			variant = variant == 1 and "heavy" or "light",
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.variant = result.variant
	attack_data.attacker_unit = attacker_unit
	attack_data.result = result
	attack_data.damage = damage

	local attack_dir

	if attacker_unit then
		attack_dir = self._unit:position() - attacker_unit:position()

		mvector3.normalize(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir
	attack_data.pos = self._unit:position()

	mvector3.set_z(attack_data.pos, attack_data.pos.z + math.random() * 180)
	self:_send_sync_tase_attack_result(attack_data)
	self:_on_damage_received(attack_data)
end

function CopDamage:_send_bullet_attack_result(attack_data, attacker, damage_percent, body_index, hit_offset_height)
	self._unit:network():send("damage_bullet", attacker, damage_percent, body_index, hit_offset_height, self._dead and true or false)
end

function CopDamage:_send_knockdown_attack_result(attacker, damage_percent, body_index, hit_offset_height)
	self._unit:network():send("damage_knockdown", attacker, damage_percent, body_index, hit_offset_height, self._dead and true or false)
end

function CopDamage:_send_explosion_attack_result(attack_data, attacker, damage_percent, i_attack_variant, direction)
	self._unit:network():send("damage_explosion_fire", attacker, damage_percent, i_attack_variant, self._dead and true or false, direction)
end

function CopDamage:_send_fire_attack_result(attack_data, attacker, damage_percent, is_fire_dot_damage, direction)
	local weapon_type, weapon_unit

	if attack_data.attacker_unit and attack_data.attacker_unit:base()._grenade_entry == "molotov" then
		weapon_type = CopDamage.WEAPON_TYPE_GRANADE
		weapon_unit = "molotov"
	elseif alive(attack_data.weapon_unit) and attack_data.weapon_unit:base()._name_id ~= nil and tweak_data.weapon[attack_data.weapon_unit:base()._name_id] ~= nil and tweak_data.weapon[attack_data.weapon_unit:base()._name_id].fire_dot_data ~= nil then
		weapon_type = CopDamage.WEAPON_TYPE_FLAMER
		weapon_unit = attack_data.weapon_unit:base()._name_id
	elseif alive(attack_data.weapon_unit) and attack_data.weapon_unit:base()._parts then
		for part_id, part in pairs(attack_data.weapon_unit:base()._parts) do
			if tweak_data.weapon.factory.parts[part_id].custom_stats and tweak_data.weapon.factory.parts[part_id].custom_stats.fire_dot_data then
				weapon_type = CopDamage.WEAPON_TYPE_BULLET
				weapon_unit = part_id
			end
		end
	end

	local start_dot_dance_antimation = attack_data.fire_dot_data and attack_data.fire_dot_data.start_dot_dance_antimation

	self._unit:network():send("damage_fire", attacker, damage_percent, start_dot_dance_antimation, self._dead and true or false, direction, weapon_type, weapon_unit)
end

function CopDamage:_send_dot_attack_result(attack_data, attacker, damage_percent, variant, direction)
	self._unit:network():send("damage_dot", attacker, damage_percent, self._dead and true or false, variant, attack_data.hurt_animation)
end

function CopDamage:_send_tase_attack_result(attack_data, damage_percent, variant)
	self._unit:network():send("damage_tase", attack_data.attacker_unit, damage_percent, variant, self._dead and true or false)
end

function CopDamage:_send_melee_attack_result(attack_data, damage_percent, damage_effect_percent, hit_offset_height, variant, body_index)
	body_index = math.clamp(body_index, 0, 128)

	self._unit:network():send("damage_melee", attack_data.attacker_unit, damage_percent, damage_effect_percent, body_index, hit_offset_height, variant, self._dead and true or false)
end

function CopDamage:_send_sync_bullet_attack_result(attack_data, hit_offset_height)
	return
end

function CopDamage:_send_sync_explosion_attack_result(attack_data)
	return
end

function CopDamage:_send_sync_tase_attack_result(attack_data)
	return
end

function CopDamage:_send_sync_melee_attack_result(attack_data, hit_offset_height)
	return
end

function CopDamage:_send_sync_fire_attack_result(attack_data)
	return
end

function CopDamage:sync_death(damage)
	if self._dead then
		return
	end
end

function CopDamage:_on_damage_received(damage_info)
	self:build_suppression("max", nil)
	self:_call_listeners(damage_info)

	if damage_info.result.type == "death" then
		managers.enemy:on_enemy_died(self._unit, damage_info)

		for c_key, c_data in pairs(managers.groupai:state():all_char_criminals()) do
			if c_data.engaged[self._unit:key()] then
				debug_pause_unit(self._unit:key(), "dead AI engaging player", self._unit, c_data.unit)
			end
		end
	end

	if self._dead and self._unit:movement():attention() then
		debug_pause_unit(self._unit, "[CopDamage:_on_damage_received] dead AI", self._unit, inspect(self._unit:movement():attention()))
	end

	local attacker_unit = damage_info and damage_info.attacker_unit

	if alive(attacker_unit) and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	if attacker_unit == managers.player:player_unit() and damage_info then
		managers.player:on_damage_dealt(self._unit, damage_info)
	end

	self:_update_debug_ws(damage_info)
end

function CopDamage:_call_listeners(damage_info)
	self._listener_holder:call(damage_info.result.type, self._unit, damage_info)
end

function CopDamage:add_listener(key, events, clbk)
	events = events or self._all_event_types

	self._listener_holder:add(key, events, clbk)
end

function CopDamage:remove_listener(key)
	self._listener_holder:remove(key)
end

function CopDamage:set_pickup(pickup)
	self._pickup = pickup
end

function CopDamage:pickup()
	return self._pickup
end

function CopDamage:health_ratio()
	return self._health_ratio
end

function CopDamage:health()
	return self._health
end

function CopDamage:health_init()
	return self._HEALTH_INIT
end

function CopDamage:convert_to_criminal(health_multiplier)
	self:set_mover_collision_state(false)

	self._health = self._HEALTH_INIT
	self._health_ratio = 1
	self._damage_reduction_multiplier = health_multiplier

	self._unit:set_slot(16)
end

function CopDamage:set_invulnerable(state)
	if state then
		self._invulnerable = (self._invulnerable or 0) + 1
	elseif self._invulnerable then
		if self._invulnerable == 1 then
			self._invulnerable = nil
		else
			self._invulnerable = self._invulnerable - 1
		end
	end
end

function CopDamage:is_invulnerable()
	return self._invulnerable
end

function CopDamage:set_immortal(immortal)
	self._immortal = immortal or false
end

function CopDamage:is_immortal()
	return self._immortal
end

function CopDamage:build_suppression(amount, panic_chance)
	if self._dead or not self._char_tweak.suppression then
		return
	end

	if self._unit:unit_data().turret_weapon then
		return
	end

	local t = TimerManager:game():time()
	local sup_tweak = self._char_tweak.suppression

	if panic_chance and (panic_chance == -1 or panic_chance > 0 and sup_tweak.panic_chance_mul > 0 and math.random() < panic_chance * sup_tweak.panic_chance_mul) then
		amount = "panic"
	end

	local amount_val

	if amount == "max" or amount == "panic" then
		amount_val = (sup_tweak.brown_point or sup_tweak.react_point)[2]
	elseif Network:is_server() and self._suppression_hardness_t and t < self._suppression_hardness_t then
		amount_val = amount * 0.5
	else
		amount_val = amount
	end

	if not Network:is_server() then
		local sync_amount

		if amount == "panic" then
			sync_amount = 16
		elseif amount == "max" then
			sync_amount = 15
		else
			local sync_amount_ratio

			if sup_tweak.brown_point then
				if sup_tweak.brown_point[2] <= 0 then
					sync_amount_ratio = 1
				else
					sync_amount_ratio = amount_val / sup_tweak.brown_point[2]
				end
			else
				sync_amount_ratio = sup_tweak.react_point[2] <= 0 and 1 or amount_val / sup_tweak.react_point[2]
			end

			sync_amount = math.clamp(math.ceil(sync_amount_ratio * 15), 1, 15)
		end

		managers.network:session():send_to_host("suppression", self._unit, sync_amount)

		return
	end

	if self._suppression_data then
		self._suppression_data.value = math.min(self._suppression_data.brown_point or self._suppression_data.react_point, self._suppression_data.value + amount_val)
		self._suppression_data.last_build_t = t
		self._suppression_data.decay_t = t + self._suppression_data.duration

		managers.enemy:reschedule_delayed_clbk(self._suppression_data.decay_clbk_id, self._suppression_data.decay_t)
	else
		local duration = math.lerp(sup_tweak.duration[1], sup_tweak.duration[2], math.random())
		local decay_t = t + duration

		self._suppression_data = {
			brown_point = sup_tweak.brown_point and math.lerp(sup_tweak.brown_point[1], sup_tweak.brown_point[2], math.random()),
			decay_clbk_id = "CopDamage_suppression" .. tostring(self._unit:key()),
			decay_t = decay_t,
			duration = duration,
			last_build_t = t,
			react_point = sup_tweak.react_point and math.lerp(sup_tweak.react_point[1], sup_tweak.react_point[2], math.random()),
			value = amount_val,
		}

		managers.enemy:add_delayed_clbk(self._suppression_data.decay_clbk_id, callback(self, self, "clbk_suppression_decay"), decay_t)
	end

	if not self._suppression_data.brown_zone and self._suppression_data.brown_point and self._suppression_data.value >= self._suppression_data.brown_point then
		self._suppression_data.brown_zone = true

		self._unit:brain():on_suppressed(amount == "panic" and "panic" or true)
	elseif amount == "panic" then
		self._unit:brain():on_suppressed("panic")
	end

	if not self._suppression_data.react_zone and self._suppression_data.react_point and self._suppression_data.value >= self._suppression_data.react_point then
		self._suppression_data.react_zone = true

		self._unit:movement():on_suppressed(amount == "panic" and "panic" or true)
	elseif amount == "panic" then
		self._unit:movement():on_suppressed("panic")
	end
end

function CopDamage:clbk_suppression_decay()
	local sup_data = self._suppression_data

	self._suppression_data = nil

	if not alive(self._unit) or self._dead then
		return
	end

	if sup_data.react_zone then
		self._unit:movement():on_suppressed(false)
	end

	if sup_data.brown_zone then
		self._unit:brain():on_suppressed(false)
	end

	self._suppression_hardness_t = TimerManager:game():time() + 30
end

function CopDamage:last_suppression_t()
	return self._suppression_data and self._suppression_data.last_build_t
end

function CopDamage:focus_delay_mul()
	return 1
end

function CopDamage:shoot_pos_mid(m_pos)
	self._spine2_obj:m_position(m_pos)
end

function CopDamage:on_marked_state(state, multiplier)
	if state then
		self._marked_dmg_mul = multiplier or 1
	else
		self._marked_dmg_mul = nil
	end
end

function CopDamage:marked_dmg_mul()
	return self._marked_dmg_mul
end

function CopDamage:_get_attack_variant_index(variant)
	for i, test_variant in ipairs(self._ATTACK_VARIANTS) do
		if variant == test_variant then
			return i
		end
	end

	debug_pause("variant not found!", variant, inspect(self._ATTACK_VARIANTS))

	return 1
end

function CopDamage:_create_debug_ws()
	self._gui = World:newgui()

	local obj = self._unit:get_object(Idstring("Head"))

	self._ws = self._gui:create_linked_workspace(100, 100, obj, obj:position() + obj:rotation():y() * 25, obj:rotation():x() * 50, obj:rotation():y() * 50)

	self._ws:set_billboard(self._ws.BILLBOARD_BOTH)
	self._ws:panel():text({
		align = "left",
		color = Color.white,
		font = "fonts/font_medium_shadow_mf",
		font_size = 30,
		layer = 1,
		name = "health",
		render_template = "OverlayVertexColorTextured",
		text = "" .. self._health,
		vertical = "top",
		visible = true,
		y = 0,
	})
	self._ws:panel():text({
		align = "left",
		color = Color.white,
		font = "fonts/font_medium_shadow_mf",
		font_size = 30,
		layer = 1,
		name = "ld",
		render_template = "OverlayVertexColorTextured",
		text = "",
		vertical = "top",
		visible = true,
		y = 30,
	})
	self._ws:panel():text({
		align = "left",
		color = Color.white,
		font = "fonts/font_medium_shadow_mf",
		font_size = 30,
		layer = 1,
		name = "variant",
		render_template = "OverlayVertexColorTextured",
		text = "",
		vertical = "top",
		visible = true,
		y = 60,
	})
	self:_update_debug_ws()
end

function CopDamage:_update_debug_ws(damage_info)
	if alive(self._ws) then
		local str = string.format("HP: %.2f", self._health)

		self._ws:panel():child("health"):set_text(str)
		self._ws:panel():child("ld"):set_text(string.format("LD: %.2f", damage_info and damage_info.damage or 0))
		self._ws:panel():child("variant"):set_text("V: " .. (damage_info and damage_info.variant or "N/A"))

		local vc = Color.white

		if damage_info and damage_info.variant then
			vc = damage_info.variant == "fire" and Color.red or damage_info.variant == WeaponTweakData.DAMAGE_TYPE_MELEE and Color.yellow or Color.white
		end

		self._ws:panel():child("variant"):set_color(vc)

		local function func(o)
			local mt = 0.25
			local t = mt

			while t >= 0 do
				local dt = coroutine.yield()

				t = math.clamp(t - dt, 0, mt)

				local v = t / mt
				local a = 1
				local r = 1
				local g = 0.25 + 0.75 * (1 - v)
				local b = 0.25 + 0.75 * (1 - v)

				o:set_color(Color(a, r, g, b))
			end
		end

		self._ws:panel():child("ld"):animate(func)

		if damage_info and damage_info.damage > 0 then
			local text = self._ws:panel():text({
				align = "center",
				color = Color.white,
				font = "fonts/font_medium_shadow_mf",
				font_size = 20,
				h = 40,
				layer = 1,
				render_template = "OverlayVertexColorTextured",
				rotation = 360,
				text = string.format("%.2f", damage_info.damage),
				vertical = "center",
				visible = true,
				w = 40,
				y = -20,
			})

			local function func2(o, dir)
				local mt = 8
				local t = mt

				while t > 0 do
					local dt = coroutine.yield()

					t = math.clamp(t - dt, 0, mt)

					local speed = dt * 100

					o:move(dir * speed, (1 - math.abs(dir)) * -speed)
					text:set_alpha(t / mt)
				end

				self._ws:panel():remove(o)
			end

			local dir = math.sin(Application:time() * 1000)

			text:set_rotation(dir * 90)
			text:animate(func2, dir)
		end
	end
end

function CopDamage:save(data)
	data.char_dmg = data.char_dmg or {}

	if self._health ~= self._HEALTH_INIT then
		data.char_dmg.health = self._health
	end

	if self._invulnerable then
		data.char_dmg.invulnerable = self._invulnerable
	end

	if self._immortal then
		data.immortal = self._immortal
	end

	if self._unit:in_slot(16) then
		data.char_dmg.is_converted = true
	end

	data.char_dmg.dead = self._dead

	if self._applied_dots then
		data.char_dmg.applied_dots = {}

		local t = TimerManager:game():time()

		for _, dot_applied in ipairs(self._applied_dots) do
			local tick_next = dot_applied.tick_next - t
			local save_data = {
				tick_next = tick_next,
				ticks_left = dot_applied.ticks_left,
				tweak_id = dot_applied.tweak_id,
				weapon_unit = dot_applied.weapon_unit,
			}

			table.insert(data.char_dmg.applied_dots, save_data)
		end
	end
end

function CopDamage:load(data)
	if not data.char_dmg then
		return
	end

	self._dead = data.char_dmg.dead

	if data.char_dmg.dead then
		self._unit:base():set_gear_dead()
	end

	if data.char_dmg.health then
		self._health = data.char_dmg.health
		self._health_ratio = self._health / self._HEALTH_INIT
	end

	if data.char_dmg.invulnerable then
		self._invulnerable = data.char_dmg.invulnerable
	end

	if data.char_dmg.immortal then
		self._immortal = data.char_dmg.immortal
	end

	if data.char_dmg.is_converted then
		self._unit:set_slot(16)
		managers.groupai:state():sync_converted_enemy(self._unit)
		self._unit:contour():add("friendly", false)
	end

	if data.char_dmg.applied_dots then
		local t = TimerManager:game():time()

		for _, dot_applied in ipairs(data.char_dmg.applied_dots) do
			local tweak_id = dot_applied.tweak_id
			local weapon_unit = dot_applied.weapon_unit
			local new_dot = self:apply_dot(tweak_id, weapon_unit)

			new_dot.ticks_left = dot_applied.ticks_left
			new_dot.tick_next = t + dot_applied.tick_next
			new_dot.attacker_unit = dot_applied.attacker_unit
		end
	end
end

function CopDamage:_apply_damage_to_health(damage)
	self._health = self._health - damage
	self._health_ratio = self._health / self._HEALTH_INIT
end

function CopDamage:_apply_min_health_limit(damage, damage_percent)
	local lower_health_percentage_limit = self._unit:base():char_tweak().LOWER_HEALTH_PERCENTAGE_LIMIT

	if lower_health_percentage_limit then
		local real_damage_percent = damage_percent / self._HEALTH_GRANULARITY
		local new_health_ratio = self._health_ratio - real_damage_percent

		if new_health_ratio < lower_health_percentage_limit then
			real_damage_percent = self._health_ratio - lower_health_percentage_limit
			damage_percent = real_damage_percent * self._HEALTH_GRANULARITY
			damage = damage_percent * self._HEALTH_INIT_PRECENT
		end
	end

	return damage, damage_percent
end

function CopDamage:_apply_damage_modifier(damage, attack_data)
	local damage_reduction = self._unit:movement():team().damage_reduction or 0
	local damage_modifier = 1

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE) then
		damage_modifier = (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE) or 1) * damage_modifier
	end

	local health_ratio = 1

	if attack_data and attack_data.attacker_unit and attack_data.attacker_unit.character_damage then
		health_ratio = attack_data.attacker_unit:character_damage():health_ratio()
	end

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_LOW_HEALTH_DAMAGE) then
		local multiplier = (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_LOW_HEALTH_DAMAGE) or 1) + (1 - health_ratio)

		damage_modifier = multiplier * damage_modifier
	end

	local primary_damage_buff = managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE)
	local secondary_damage_buff = managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE)

	if attack_data and attack_data.attacker_unit == managers.player:local_player() and attack_data.weapon_unit and attack_data.weapon_unit:base()._use_data and attack_data.weapon_unit:base()._use_data.player and (primary_damage_buff or secondary_damage_buff) then
		if primary_damage_buff and attack_data.weapon_unit:base()._use_data.player.selection_index == tweak_data.WEAPON_SLOT_PRIMARY then
			damage_modifier = damage_modifier + (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE) or 1) - 1
		end

		if secondary_damage_buff and attack_data.weapon_unit:base()._use_data.player.selection_index == tweak_data.WEAPON_SLOT_SECONDARY then
			damage_modifier = damage_modifier + (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE) or 1) - 1
		end
	end

	damage_modifier = damage_modifier - damage_reduction
	damage = damage * damage_modifier

	return damage
end

function CopDamage.skill_action_knockdown(unit, hit_position, direction, hurt_type)
	if alive(unit) and unit.movement and unit.character_damage and not unit:character_damage():dead() then
		hurt_type = hurt_type or "knockdown"

		local client_interrupt = Network:is_client()
		local action_data = {
			block_type = "heavy_hurt",
			blocks = {
				act = -1,
				action = -1,
				aim = -1,
				dodge = -1,
				hurt = -1,
				idle = -1,
				walk = -1,
			},
			body_part = 1,
			client_interrupt = client_interrupt,
			direction_vec = direction,
			hit_pos = hit_position,
			hurt_type = hurt_type,
			type = "hurt",
		}

		if Network:is_server() or not unit:movement():chk_action_forbidden(action_data) then
			return unit:movement():action_request(action_data)
		end
	end

	return false
end

function CopDamage:apply_dot(tweak_id, weapon_unit)
	if not tweak_id then
		return
	end

	local dot_data = tweak_data.fire.dot_types[tweak_id]

	self._applied_dots = self._applied_dots or {}

	local variant = dot_data.variant
	local duration = dot_data.duration
	local tick_interval = dot_data.tick_interval
	local damage = dot_data.damage
	local attacker_unit = managers.player:player_unit()

	if alive(weapon_unit) and weapon_unit:base() and weapon_unit:base().thrower_unit then
		attacker_unit = weapon_unit:base():thrower_unit()
	end

	local time = TimerManager:game():time()
	local total_ticks = math.floor(duration / tick_interval)
	local tick_next = time + tick_interval
	local animation_chance = 0
	local dot_applied = self:is_dot_applied(variant)

	if dot_applied then
		local total_damage = damage * total_ticks
		local remaining_damage = dot_applied.damage * dot_applied.ticks_left

		if remaining_damage < total_damage then
			animation_chance = total_ticks + dot_applied.ticks_left
			dot_applied.tweak_id = tweak_id
			dot_applied.damage = damage
			dot_applied.ticks_left = total_ticks
			dot_applied.tick_interval = tick_interval
			dot_applied.weapon_unit = weapon_unit
			dot_applied.attacker_unit = attacker_unit
		end
	else
		dot_applied = {
			attacker_unit = attacker_unit,
			damage = damage,
			effects = {},
			tick_interval = tick_interval,
			tick_next = tick_next,
			ticks_left = total_ticks,
			tweak_id = tweak_id,
			variant = variant,
			weapon_unit = weapon_unit,
		}

		managers.fire:ignite_character(self._unit, dot_applied.effects)

		if dot_data.variant == "fire" then
			self._unit:sound():play("burn_loop_body")
		end

		table.insert(self._applied_dots, dot_applied)
	end

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("sync_apply_enemy_dot", self._unit, tweak_id, weapon_unit)
	end

	self._unit:set_extension_update_enabled(ids_character_damage, true)

	local play_animation = animation_chance > math.random() * 50

	return dot_applied, play_animation
end

function CopDamage:is_dot_applied(dot_variant)
	if dot_variant then
		for _, dot_applied in ipairs(self._applied_dots) do
			if dot_applied.variant == dot_variant then
				return dot_applied
			end
		end

		return false
	end

	return not not next(self._applied_dots)
end

function CopDamage:_do_dot_tick(dot_data)
	if Network:is_server() then
		dot_data.attacker_unit = alive(dot_data.attacker_unit) and dot_data.attacker_unit
		dot_data.attacker_unit = alive(dot_data.weapon_unit) and dot_data.weapon_unit

		local damage = dot_data.damage
		local attacker_unit = dot_data.attacker_unit
		local weapon_unit = dot_data.weapon_unit
		local col_ray = {
			unit = self._unit,
		}

		FlameBulletBase:give_fire_damage_dot(col_ray, weapon_unit, attacker_unit, damage, true)
	end
end

function CopDamage:remove_dot(dot_data)
	if not dot_data then
		return
	end

	if dot_data.effects then
		for _, effect_id in ipairs(dot_data.effects) do
			World:effect_manager():fade_kill(effect_id)
		end
	end

	if dot_data.variant == "fire" then
		self._unit:sound():play("burn_loop_body_stop")
	end
end

function CopDamage:update(unit, t, dt)
	for i = #self._applied_dots, 1, -1 do
		local data = self._applied_dots[i]

		if t >= data.tick_next then
			self:_do_dot_tick(data)

			data.tick_next = t + data.tick_interval
			data.ticks_left = data.ticks_left - 1
		end

		if data.ticks_left == 0 then
			self:remove_dot(data)
			table.remove(self._applied_dots, i)
		end
	end

	if not next(self._applied_dots) then
		self._unit:set_extension_update_enabled(ids_character_damage, false)

		self._applied_dots = {}
	end
end

function CopDamage:destroy(...)
	self:_remove_debug_gui()

	if self._applied_dots then
		for _, dot_data in ipairs(self._applied_dots) do
			self:remove_dot(dot_data)
		end
	end
end
