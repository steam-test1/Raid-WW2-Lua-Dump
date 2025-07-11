BaseInteractionExt = BaseInteractionExt or class()
BaseInteractionExt.EVENT_IDS = {}
BaseInteractionExt.EVENT_IDS.at_interact_start = 1
BaseInteractionExt.EVENT_IDS.at_interact_interupt = 2
BaseInteractionExt.SKILL_IDS = {}
BaseInteractionExt.SKILL_IDS.none = 1
BaseInteractionExt.SKILL_IDS.basic = 2
BaseInteractionExt.SKILL_IDS.aced = 3
BaseInteractionExt.INFO_IDS = {
	1,
	2,
	4,
	8,
	16,
	32,
	64,
	128,
}
BaseInteractionExt.INTERACTION_TYPE = {}
BaseInteractionExt.INTERACTION_TYPE.locator_based = "locator_based"
BaseInteractionExt.MIN_TIMER = 0.1

local ids_contour_color = Idstring("contour_color")
local ids_contour_opacity = Idstring("contour_opacity")

function BaseInteractionExt:init(unit)
	self._unit = unit

	self._unit:set_extension_update_enabled(Idstring("interaction"), false)
	self:refresh_material()
	self:set_tweak_data(self.tweak_data)
	self:set_active(self._tweak_data.start_active or self._tweak_data.start_active == nil and true)
	self:_upd_interaction_topology()
end

function BaseInteractionExt:refresh_material()
	self._materials = {}

	local all_materials = self._unit:get_objects_by_type(IDS_MATERIAL)

	for _, m in ipairs(all_materials) do
		if m:variable_exists(Idstring("contour_color")) then
			table.insert(self._materials, m)
		end
	end
end

function BaseInteractionExt:external_upd_interaction_topology()
	self:_upd_interaction_topology()
end

function BaseInteractionExt:_upd_interaction_topology()
	if self._tweak_data.interaction_obj then
		self._interact_obj = self._unit:get_object(self._tweak_data.interaction_obj)
	else
		self._interact_obj = self._interact_object and self._unit:get_object(Idstring(self._interact_object))
	end

	self._interact_position = self._interact_obj and self._interact_obj:position() or self._unit:position()

	local rotation = self._interact_obj and self._interact_obj:rotation() or self._unit:rotation()

	self._interact_axis = self._tweak_data.axis and rotation[self._tweak_data.axis](rotation) or nil

	if self._tweak_data.dot_limit then
		self:set_dot_limit(self._tweak_data.dot_limit)
	end

	self:_update_interact_position()
	self:_setup_ray_objects()
end

function BaseInteractionExt:set_tweak_data(id)
	local contour_id = self._contour_id
	local selected_contour_id = self._selected_contour_id

	if contour_id then
		self._unit:contour():remove_by_id(contour_id)

		self._contour_id = nil
	end

	if selected_contour_id then
		self._unit:contour():remove_by_id(selected_contour_id)

		self._selected_contour_id = nil
	end

	self.tweak_data = id
	self._tweak_data = tweak_data.interaction:get_interaction(id)

	if self._active and self._tweak_data.contour_preset then
		self._contour_id = self._unit:contour():add(self._tweak_data.contour_preset)
	end

	if self._active and self._is_selected and self._tweak_data.contour_preset_selected then
		self._selected_contour_id = self._unit:contour():add(self._tweak_data.contour_preset_selected)
	end

	self:_upd_interaction_topology()

	if alive(managers.interaction:active_unit()) and self._unit == managers.interaction:active_unit() then
		self:set_dirty(true)
	end
end

function BaseInteractionExt:set_dirty(dirty)
	self._dirty = dirty
end

function BaseInteractionExt:dirty()
	return self._dirty
end

function BaseInteractionExt:set_dot_limit(limit)
	self._dot_limit = limit
end

function BaseInteractionExt:dot_limit()
	return self._dot_limit or tweak_data.interaction.DEFAULT_INTERACTION_DOT or 0.9
end

function BaseInteractionExt:interact_position()
	self:_update_interact_position()

	return self._interact_position
end

function BaseInteractionExt:interact_axis()
	self:_update_interact_axis()

	return self._interact_axis
end

function BaseInteractionExt:_setup_ray_objects()
	if self._ray_object_names then
		self._ray_objects = {
			self._interact_obj or self._unit:orientation_object(),
		}

		for _, object_name in ipairs(self._ray_object_names) do
			table.insert(self._ray_objects, self._unit:get_object(Idstring(object_name)))
		end
	end
end

function BaseInteractionExt:ray_objects()
	return self._ray_objects
end

function BaseInteractionExt:self_blocking()
	return self._self_blocking
end

function BaseInteractionExt:_update_interact_position()
	if self._unit:moving() or self._tweak_data.force_update_position then
		self._interact_position = self._interact_obj and self._interact_obj:position() or self._unit:position()
	end
end

function BaseInteractionExt:refresh_interact_position()
	self._interact_position = self._interact_obj and self._interact_obj:position() or self._unit:position()
end

function BaseInteractionExt:_update_interact_axis()
	if self._tweak_data.axis and self._unit:moving() then
		local rotation = self._interact_obj and self._interact_obj:rotation() or self._unit:rotation()

		self._interact_axis = self._tweak_data.axis and rotation[self._tweak_data.axis](rotation) or nil
	end
end

function BaseInteractionExt:interact_distance()
	return self._tweak_data.interact_distance or tweak_data.interaction.INTERACT_DISTANCE
end

function BaseInteractionExt:interact_dont_interupt_on_distance()
	return self._tweak_data.interact_dont_interupt_on_distance or false
end

function BaseInteractionExt:interact_redirect()
	return self._tweak_data and self._tweak_data.redirect
end

function BaseInteractionExt:interact_delay_completed()
	return self._tweak_data and self._tweak_data.delay_completed or tweak_data.interaction.INTERACT_DELAY_COMPLETED
end

function BaseInteractionExt:interact_delay_interrupted()
	return self._tweak_data and self._tweak_data.delay_interrupted or tweak_data.interaction.INTERACT_DELAY_INTERRUPTED
end

function BaseInteractionExt:allowed_while_perservating()
	return managers.player:upgrade_value("interaction", "perseverance_allowed_interaction", false) and self._tweak_data.allowed_while_perservating
end

function BaseInteractionExt:update(distance_to_player)
	return
end

function BaseInteractionExt:_btn_interact()
	if not managers.menu:is_pc_controller() then
		return nil
	end

	local val = managers.localization:btn_macro("interact")

	return val .. "\n"
end

function BaseInteractionExt:can_select(player)
	if not self._active then
		return false
	end

	if not self:_has_required_upgrade(alive(player) and player:movement() and player:movement().current_state_name and player:movement():current_state_name()) then
		return false
	end

	if not self:_has_required_deployable() then
		return false
	end

	if not self:_is_in_required_state(alive(player) and player:movement() and player:movement().current_state_name and player:movement():current_state_name()) then
		return false
	end

	if self._tweak_data.special_equipment_block and managers.player:has_special_equipment(self._tweak_data.special_equipment_block) then
		return false
	end

	return true
end

function BaseInteractionExt:selected(player)
	local can_select, block_text = self:can_select(player)

	if not can_select then
		return
	end

	self._is_selected = true

	if block_text ~= false then
		self:_show_interaction_text()
	end

	return true
end

function BaseInteractionExt:_show_interaction_text(custom_text_id)
	local string_macros = {}

	self:_add_string_macros(string_macros)

	local text_id = custom_text_id or self._tweak_data.text_id or alive(self._unit) and self._unit:base().interaction_text_id and self._unit:base():interaction_text_id()
	local text = managers.localization:text(text_id, string_macros)
	local icon = self._tweak_data.icon

	if self._tweak_data.special_equipment and not managers.player:has_special_equipment(self._tweak_data.special_equipment) then
		local has_special_equipment = false

		if self._tweak_data.possible_special_equipment then
			for i, special_equipment in ipairs(self._tweak_data.possible_special_equipment) do
				if managers.player:has_special_equipment(special_equipment) then
					has_special_equipment = true

					break
				end
			end
		end

		if not has_special_equipment then
			text = managers.localization:text(self._tweak_data.equipment_text_id, string_macros)
			icon = self.no_equipment_icon or self._tweak_data.no_equipment_icon or icon
		end
	end

	if not not self._tweak_data.required_carry then
		local has_carry_item = managers.player:is_carrying_carry_id(self._tweak_data.required_carry)

		if not has_carry_item then
			text = managers.localization:text(self._tweak_data.carry_text_id, string_macros)
			icon = self.no_equipment_icon or self._tweak_data.no_equipment_icon or icon
		end
	end

	if self._tweak_data.contour_preset or self._tweak_data.contour_preset_selected then
		if not self._selected_contour_id and self._tweak_data.contour_preset_selected and self._tweak_data.contour_preset ~= self._tweak_data.contour_preset_selected then
			self._selected_contour_id = self._unit:contour():add(self._tweak_data.contour_preset_selected)
		end
	else
		self:set_contour("selected_color")
	end

	if self._hide_interaction_prompt ~= true then
		local details = self:_get_interaction_details()

		managers.hud:show_interact({
			details = details,
			icon = icon,
			text = text,
		})
	end
end

function BaseInteractionExt:_add_string_macros(macros)
	macros.BTN_INTERACT = self:_btn_interact()
end

function BaseInteractionExt:_get_interaction_details()
	return false
end

function BaseInteractionExt:unselect()
	self._is_selected = nil

	if self._tweak_data.contour_preset or self._tweak_data.contour_preset_selected then
		if self._selected_contour_id then
			self._unit:contour():remove_by_id(self._selected_contour_id)
		end

		self._selected_contour_id = nil
	elseif not self._unit:vehicle_driving() then
		self:set_contour("standard_color")
	else
		local vehicle_state_name = self._unit:vehicle_driving():get_state_name()

		if vehicle_state_name == VehicleDrivingExt.STATE_BROKEN then
			self:set_contour("standard_color", 1)
		else
			self:set_contour("standard_color", 0)
		end
	end
end

function BaseInteractionExt:_has_required_upgrade(movement_state)
	if not movement_state then
		return true
	end

	if self._tweak_data.requires_upgrade then
		local category = self._tweak_data.requires_upgrade.category
		local upgrade = self._tweak_data.requires_upgrade.upgrade

		return managers.player:has_category_upgrade(category, upgrade)
	end

	return true
end

function BaseInteractionExt:_has_required_deployable()
	if self._tweak_data.required_deployable then
		return managers.player:has_deployable_left(self._tweak_data.required_deployable)
	end

	return true
end

function BaseInteractionExt:_is_in_required_state(movement_state)
	return true
end

function BaseInteractionExt:_interact_say(params)
	if alive(params.player) then
		params.player:sound():say(params.event, false, true)
	end
end

function BaseInteractionExt:interact_start(player, locator)
	Application:debug("[BaseInteractionExt:interact_start]", player, locator)

	local function show_hint(hint_id)
		managers.notification:add_notification({
			duration = 2,
			id = hint_id,
			shelf_life = 5,
			text = managers.localization:text(hint_id),
		})
	end

	local blocked, skip_hint, custom_hint = self:_interact_blocked(player)

	if blocked then
		if not skip_hint and (custom_hint or self._tweak_data.blocked_hint) then
			Application:debug("[BaseInteractionExt:interact_start] interaction blocked, unit: " .. tostring(self._unit), "block_hint: " .. tostring(custom_hint or self._tweak_data.blocked_hint))

			if self._tweak_data.blocked_hint_sound then
				self:_post_event(player, "blocked_hint_sound")
				managers.dialog:queue_dialog("player_gen_full_reserve", {
					instigator = managers.player:local_player(),
					skip_idle_check = true,
				})
			end

			if custom_hint or self._tweak_data.blocked_hint then
				show_hint(custom_hint or self._tweak_data.blocked_hint)
			end
		end

		return false
	elseif managers.player:is_perseverating() and not self:allowed_while_perservating() then
		player:sound():play("generic_fail_sound")

		return false
	end

	local player_say_interacting = self._tweak_data.player_say_interacting

	if player_say_interacting and player_say_interacting ~= "" then
		local timer = self:_get_timer()
		local delay = timer * 0.1 + math.random() * (timer * 0.2)

		managers.queued_tasks:queue("player_say_interacting", self._interact_say, self, {
			event = player_say_interacting,
			player = player,
		}, delay, nil)
		Application:debug("[BaseInteractionExt:interact_start] player_say_interacting, delay", player_say_interacting, delay)
	end

	if not self:can_interact(player) then
		if self._tweak_data.blocked_hint then
			show_hint(self._tweak_data.blocked_hint)
		end

		return false
	end

	if self._unit:damage() and self._unit:damage():has_sequence("interact_start_local") then
		self._unit:damage():run_sequence_simple("interact_start_local", {
			unit = player,
		})
	end

	if self:_timer_value() then
		local timer = self:_get_timer()

		if timer > 0 then
			self:_post_event(player, "sound_start")
			self:_at_interact_start(player, timer)

			return false, timer
		end
	end

	return self:interact(player, locator)
end

function BaseInteractionExt:_timer_value()
	return self._tweak_data.timer
end

function BaseInteractionExt:_get_timer()
	local modified_timer = self:_get_modified_timer()

	if modified_timer then
		return modified_timer
	end

	local multiplier = 1

	if self._tweak_data.upgrade_timer_multiplier then
		multiplier = multiplier * managers.player:upgrade_value(self._tweak_data.upgrade_timer_multiplier.category, self._tweak_data.upgrade_timer_multiplier.upgrade, 1)
	end

	if self._tweak_data.upgrade_timer_multipliers then
		for _, upgrade_timer_multiplier in pairs(self._tweak_data.upgrade_timer_multipliers) do
			multiplier = multiplier * managers.player:upgrade_value(upgrade_timer_multiplier.category, upgrade_timer_multiplier.upgrade, 1)
		end
	end

	multiplier = multiplier * managers.player:temporary_upgrade_value("temporary", "handyman_interaction_boost", 1)

	local base_timer_val = self:_timer_value() or 0
	local modified_timer_val = base_timer_val * multiplier * managers.player:toolset_value()

	if base_timer_val >= BaseInteractionExt.MIN_TIMER then
		return math.max(BaseInteractionExt.MIN_TIMER, modified_timer_val)
	end

	return base_timer_val * modified_timer_val
end

function BaseInteractionExt:_get_modified_timer()
	return false
end

function BaseInteractionExt:check_interupt()
	return false
end

function BaseInteractionExt:interact_interupt(player, complete)
	local tweak_data_id = self._tweak_data_at_interact_start ~= self.tweak_data and self._tweak_data_at_interact_start

	self:_post_event(player, "sound_interupt", tweak_data_id)

	if managers.queued_tasks:has_task("player_say_interacting") then
		managers.queued_tasks:unqueue("player_say_interacting")
	end

	if not complete and self._unit:damage() and self._unit:damage():has_sequence("interact_interupt_local") then
		self._unit:damage():run_sequence_simple("interact_interupt_local", {
			unit = player,
		})
	end

	self:_at_interact_interupt(player, complete)
end

function BaseInteractionExt:_post_event(player, sound_type, tweak_data_id)
	if not alive(player) then
		return
	end

	if player ~= managers.player:player_unit() then
		return
	end

	local tweak_data_table = self._tweak_data

	if tweak_data_id then
		tweak_data_table = tweak_data.interaction:get_interaction(tweak_data_id)
	end

	if tweak_data_table[sound_type] then
		player:sound():play(tweak_data_table[sound_type])
	end
end

function BaseInteractionExt:_at_interact_start()
	self._tweak_data_at_interact_start = self.tweak_data
end

function BaseInteractionExt:_at_interact_interupt(player, complete)
	self._tweak_data_at_interact_start = nil
end

function BaseInteractionExt:interact(player)
	self._tweak_data_at_interact_start = nil

	self:_post_event(player, "sound_done")

	local weap_base = managers.player:get_current_state()._equipped_unit:base()

	if weap_base.name_id == "dp28" then
		weap_base:set_magazine_pos_based_on_ammo()
	end

	managers.player:activate_temporary_upgrade("temporary", "handyman_interaction_boost")
end

function BaseInteractionExt:can_interact(player)
	if not self._active then
		return false
	end

	if not self:_has_required_upgrade(alive(player) and player:movement() and player:movement().current_state_name and player:movement():current_state_name()) then
		return false
	end

	if not self:_has_required_deployable() then
		return false
	end

	if not self:_is_in_required_state(alive(player) and player:movement() and player:movement().current_state_name and player:movement():current_state_name()) then
		return false
	end

	if self._tweak_data.special_equipment_block and managers.player:has_special_equipment(self._tweak_data.special_equipment_block) then
		return false
	end

	if not self._tweak_data.special_equipment or self._tweak_data.dont_need_equipment then
		return true
	end

	return managers.player:has_special_equipment(self._tweak_data.special_equipment)
end

function BaseInteractionExt:_interact_blocked(player)
	return false
end

function BaseInteractionExt:active()
	return self._active
end

function BaseInteractionExt:set_active(active, sync)
	if not active and self._active then
		managers.interaction:remove_unit(self._unit)

		if self._tweak_data.contour_preset or self._tweak_data.contour_preset_selected then
			if self._contour_id and self._unit:contour() then
				self._unit:contour():remove_by_id(self._contour_id)
			end

			self._contour_id = nil

			if self._selected_contour_id and self._unit:contour() then
				self._unit:contour():remove_by_id(self._selected_contour_id)
			end

			self._selected_contour_id = nil
		elseif not self._tweak_data.no_contour then
			managers.occlusion:add_occlusion(self._unit)
		end

		self._is_selected = nil
	elseif active and not self._active then
		managers.interaction:add_unit(self._unit)

		if self._tweak_data.contour_preset then
			if not self._contour_id then
				self._contour_id = self._unit:contour():add(self._tweak_data.contour_preset)
			end
		elseif not self._tweak_data.no_contour then
			managers.occlusion:remove_occlusion(self._unit)
		end
	end

	self._active = active

	if not self._tweak_data.contour_preset then
		local contour = self._unit:contour()

		if not contour or contour:enabled() then
			local opacity_value = self:_set_active_contour_opacity()

			self:set_contour("standard_color", opacity_value)
		end
	end

	if sync and managers.network:session() then
		local u_id = self._unit:id()

		if u_id == -1 then
			local u_data = managers.enemy:get_corpse_unit_data_from_key(self._unit:key())

			if u_data then
				u_id = u_data.u_id
			else
				debug_pause_unit(self._unit, "[BaseInteractionExt:set_active] could not sync interaction state.", self._unit)

				return
			end
		end

		managers.network:session():send_to_peers_synched("interaction_set_active", self._unit, u_id, active, self.tweak_data, self._unit:contour() and self._unit:contour():is_flashing() or false)
	end
end

function BaseInteractionExt:_set_active_contour_opacity()
	return nil
end

function BaseInteractionExt:set_outline_flash_state(state, sync)
	if self._contour_id then
		self._unit:contour():flash(self._contour_id, state and self._tweak_data.contour_flash_interval or nil)
		self:set_active(self._active, sync)
	end
end

function BaseInteractionExt:set_contour(color, opacity)
	local contour = self._unit:contour()

	if contour and not contour:enabled() or self._tweak_data.no_contour or self._contour_override then
		return
	end

	for _, m in ipairs(self._materials) do
		m:set_variable(ids_contour_color, tweak_data.contour[self._tweak_data.contour or "interactable"][color])
		m:set_variable(ids_contour_opacity, opacity or self._active and 1 or 0)
	end
end

function BaseInteractionExt:set_contour_override(state)
	self._contour_override = state
end

function BaseInteractionExt:save(data)
	local state = {}

	state.active = self._active

	if self.tweak_data then
		state.tweak_data = self.tweak_data
	end

	if self._unit:contour() and self._unit:contour():is_flashing() then
		state.is_flashing = true
	end

	data.InteractionExt = state
end

function BaseInteractionExt:load(data)
	local state = data.InteractionExt

	if state then
		self:set_active(state.active)

		if state.tweak_data then
			self:set_tweak_data(state.tweak_data)
		end

		if state.is_flashing and self._contour_id then
			self._unit:contour():flash(self._contour_id, self._tweak_data.contour_flash_interval)
		end
	end
end

function BaseInteractionExt:remove_interact()
	if not managers.interaction:active_unit() or self._unit == managers.interaction:active_unit() then
		managers.hud:remove_interact()
	end
end

function BaseInteractionExt:destroy()
	self:remove_interact()
	self:set_active(false, false)

	if self._unit == managers.interaction:active_unit() then
		self:_post_event(managers.player:player_unit(), "sound_interupt")
	end

	if self._tweak_data.contour_preset then
		-- block empty
	elseif not self._tweak_data.no_contour then
		managers.occlusion:add_occlusion(self._unit)
	end

	if self._interacting_units then
		for u_key, unit in pairs(self._interacting_units) do
			if alive(unit) then
				unit:base():remove_destroy_listener(self._interacting_unit_destroy_listener_key)
			end
		end

		self._interacting_units = nil
	end
end

UseInteractionExt = UseInteractionExt or class(BaseInteractionExt)

function UseInteractionExt:unselect()
	UseInteractionExt.super.unselect(self)
	managers.hud:remove_interact()
end

function UseInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	UseInteractionExt.super.interact(self, player)

	if self._tweak_data.equipment_consume then
		managers.player:remove_special(self._tweak_data.special_equipment)
	end

	if self._tweak_data.deployable_consume then
		managers.player:remove_equipment(self._tweak_data.required_deployable)
	end

	if self._tweak_data.sound_event then
		player:sound():play(self._tweak_data.sound_event)
	end

	self:remove_interact()

	if self._unit:damage() and self._unit:damage():has_sequence("interact") then
		self._unit:damage():run_sequence_simple("interact", {
			unit = player,
		})
	end

	if self._unit:damage() and self._unit:damage():has_sequence("load") then
		self._unit:damage():run_sequence_simple("load", {
			unit = player,
		})
	end

	managers.network:session():send_to_peers_synched("sync_interacted", self._unit, -2, self.tweak_data, 1)

	if self._global_event then
		managers.mission:call_global_event(self._global_event, player)
	end

	self:set_active(self._tweak_data.keep_active == true)
end

function UseInteractionExt:sync_interacted(peer, player, status, skip_alive_check)
	if not self._active then
		return
	end

	local player = peer:unit()

	if not skip_alive_check and not alive(player) then
		return
	end

	self:remove_interact()
	self:set_active(false)

	if self._unit:damage() and self._unit:damage():has_sequence("interact") then
		self._unit:damage():run_sequence_simple("interact", {
			unit = player,
		})
	end

	if self._unit:damage() and self._unit:damage():has_sequence("load") then
		self._unit:damage():run_sequence_simple("load", {
			unit = player,
		})
	end

	return player
end

function UseInteractionExt:destroy()
	UseInteractionExt.super.destroy(self)
end

LootCrateInteractionExt = LootCrateInteractionExt or class(UseInteractionExt)

function LootCrateInteractionExt:init(unit)
	LootCrateInteractionExt.super.init(self, unit)
	self:setup_effects()

	if Network:is_server() then
		self:set_lootcrate_tier(managers.drop_loot:crate_pick_tier(self._unit._is_loot_crate_static))
	end
end

function LootCrateInteractionExt:set_lootcrate_tier(tier)
	if self._unit:damage() then
		if tier and tier > 0 then
			self._unit:damage():run_sequence_simple("set_tier_" .. tostring(tier), {
				unit = self._unit,
			})
		else
			self._unit:damage():run_sequence_simple("hide", {
				unit = self._unit,
			})
		end

		if Network:is_server() then
			managers.network:session():send_to_peers("sync_set_lootcrate_tier", self._unit, tier)
		end
	end
end

function LootCrateInteractionExt:setup_effects()
	local ids_mat_effect1 = Idstring("mat_metal_effect")
	local ids_mat_effect2 = Idstring("mat_wood_effect")
	local ids_uv0_speed = Idstring("uv0_speed")
	local ids_uv0_offset = Idstring("uv0_offset")
	local material = self._unit:material(ids_mat_effect1)
	local r = math.random()
	local offset = Vector3(r, r, r)

	r = math.rand(0.18, 0.2)

	local speed = Vector3(r, r, r)

	if material then
		material:set_variable(ids_uv0_offset, offset)
		material:set_variable(ids_uv0_speed, speed)
	end

	material = self._unit:material(ids_mat_effect2)

	if material then
		material:set_variable(ids_uv0_offset, offset)
		material:set_variable(ids_uv0_speed, speed)
	end
end

function LootCrateInteractionExt:_interact_blocked(player)
	return false
end

function LootCrateInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	local params = deep_clone(self._tweak_data)

	if params.minigame_type == tweak_data.interaction.MINIGAME_PICK_LOCK and not self:_bypass_minigame() then
		params.target_unit = self._unit

		managers.player:upgrade_minigame_params(params)

		self._player = player
		self._unit:unit_data()._interaction_done = false

		game_state_machine:change_state_by_name("ingame_special_interaction", params)
	else
		LootCrateInteractionExt.super.interact(self, player)
		managers.statistics:open_loot_crate()
	end

	return true
end

function LootCrateInteractionExt:_timer_value()
	if not self._tweak_data.minigame_type or self:_bypass_minigame() then
		return LootCrateInteractionExt.super._timer_value(self)
	end

	return 0
end

function LootCrateInteractionExt:_bypass_minigame()
	local can_bypass = false

	if self._tweak_data.minigame_bypass then
		local params = self._tweak_data.minigame_bypass

		can_bypass = managers.player:upgrade_value(params.category, params.upgrade, false)
		can_bypass = (not params.special_equipment or managers.player:has_special_equipment(params.special_equipment)) and can_bypass
	end

	return can_bypass
end

function LootCrateInteractionExt:special_interaction_done()
	LootCrateInteractionExt.super.interact(self, self._player)
	managers.statistics:open_loot_crate()
	managers.network:session():send_to_peers("special_interaction_done", self._unit)
	self:set_special_interaction_done()
end

function LootCrateInteractionExt:set_special_interaction_done()
	self._unit:unit_data()._interaction_done = true
end

function LootCrateInteractionExt:save(data)
	LootCrateInteractionExt.super.save(self, data)

	local state = {}

	state.crate_tier = self._crate_tier

	Application:debug("[DropLootCrate] sending crate_tier", state.crate_tier, " - - - - ", self._unit)

	data.LootCrateInteractionExt = state
end

function LootCrateInteractionExt:load(data)
	local state = data.LootCrateInteractionExt

	if state and state.crate_tier then
		Application:debug("[DropLootCrate] loading crate_tier", state.crate_tier, " - - - - ", self._unit)
		self:setup_lootcrate(state.crate_tier)
	end

	LootCrateInteractionExt.super.load(self, data)
end

LootDropInteractionExt = LootDropInteractionExt or class(UseInteractionExt)

function LootDropInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	LootDropInteractionExt.super.interact(self, player)

	if Network:is_server() then
		self:_spawn_loot()
	end

	return true
end

function LootDropInteractionExt:sync_interacted(...)
	LootDropInteractionExt.super.sync_interacted(self, ...)

	if Network:is_server() then
		self:_spawn_loot()
	end
end

function LootDropInteractionExt:_spawn_loot()
	local loot_locator = self._unit:get_object(Idstring("snap_1"))
	local unit = managers.game_play_central:spawn_pickup({
		name = "gold_bar_medium",
		position = loot_locator:position() + Vector3(0, 0, 5),
		rotation = loot_locator:rotation(),
	})

	unit:loot_drop():set_value(self._unit:loot_drop():value())
	managers.network:session():send_to_peers_synched("sync_loot_value", unit, self._unit:loot_drop():value())
end

SpecialLootCrateInteractionExt = SpecialLootCrateInteractionExt or class(LootCrateInteractionExt)

function SpecialLootCrateInteractionExt:_interact_blocked(player)
	return false
end

function SpecialLootCrateInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	local params = deep_clone(self._tweak_data)

	params.target_unit = self._unit

	managers.player:upgrade_minigame_params(params)

	self._player = player
	self._unit:unit_data()._interaction_done = false

	game_state_machine:change_state_by_name("ingame_special_interaction", params)

	return true
end

function SpecialLootCrateInteractionExt:special_interaction_done()
	SpecialLootCrateInteractionExt.super.interact(self, self._player)
	managers.network:session():send_to_peers("special_interaction_done", self._unit)
end

function SpecialLootCrateInteractionExt:set_special_interaction_done()
	self._unit:unit_data()._interaction_done = true
end

PickupInteractionExt = PickupInteractionExt or class(UseInteractionExt)

function PickupInteractionExt:_interact_blocked(player)
	return false
end

function PickupInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	PickupInteractionExt.super.interact(self, player)
	self._unit:pickup():pickup(player)

	return true
end

function PickupInteractionExt:selected(player)
	local return_val = PickupInteractionExt.super.selected(self, player)

	return return_val
end

function PickupInteractionExt:unselect()
	PickupInteractionExt.super.unselect(self)
end

HealthPickupInteractionExt = HealthPickupInteractionExt or class(PickupInteractionExt)

function HealthPickupInteractionExt:_interact_blocked(player)
	if not alive(player) then
		return true
	end

	if self._unit:pickup():get_restores_down() and not player:character_damage():is_max_revives() then
		return false
	end

	return not player:character_damage():need_healing()
end

function HealthPickupInteractionExt:selected(player)
	if not self:can_select(player) then
		return
	end

	self._hide_interaction_prompt = alive(player) and not player:character_damage():need_healing()

	if self._unit:pickup():get_restores_down() and alive(player) and not player:character_damage():is_max_revives() then
		self._hide_interaction_prompt = false
	end

	local return_val = HealthPickupInteractionExt.super.selected(self, player)

	self._hide_interaction_prompt = nil

	return return_val
end

function HealthPickupInteractionExt:unselect()
	HealthPickupInteractionExt.super.unselect(self)
	managers.hud:remove_interact()
end

function HealthPickupInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	HealthPickupInteractionExt.super.interact(self, player)

	return true
end

function HealthPickupInteractionExt:_get_interaction_details()
	local pku = self._unit:pickup()
	local pku_heal_dwn = pku:get_restores_down()

	if pku_heal_dwn then
		local local_player = managers.player:local_player()

		if not local_player:character_damage():is_max_revives() then
			return {
				icon = "waypoint_special_health",
				text = managers.localization:text("details_returns_one_down"),
			}
		end
	end
end

AmmoPickupInteractionExt = AmmoPickupInteractionExt or class(PickupInteractionExt)

function AmmoPickupInteractionExt:selected(player)
	if not self:can_select(player) then
		return
	end

	if player ~= nil and not player:inventory():need_ammo() then
		self._hide_interaction_prompt = true
	end

	local return_val = AmmoPickupInteractionExt.super.selected(self, player)

	self._hide_interaction_prompt = nil

	return return_val
end

function AmmoPickupInteractionExt:unselect()
	AmmoPickupInteractionExt.super.unselect(self)
	managers.hud:remove_interact()
end

function AmmoPickupInteractionExt:_interact_blocked(player)
	return not player:inventory():need_ammo()
end

function AmmoPickupInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	AmmoPickupInteractionExt.super.interact(self, player)

	return true
end

GrenadePickupInteractionExt = GrenadePickupInteractionExt or class(PickupInteractionExt)

function GrenadePickupInteractionExt:selected(player)
	if not self:can_select(player) then
		return
	end

	local blocked, _, _ = self:_interact_blocked(player)

	if blocked then
		self._hide_interaction_prompt = true
	end

	local return_val = GrenadePickupInteractionExt.super.selected(self, player)

	self._hide_interaction_prompt = nil

	return return_val
end

function GrenadePickupInteractionExt:unselect()
	GrenadePickupInteractionExt.super.unselect(self)
	managers.hud:remove_interact()
end

function GrenadePickupInteractionExt:_interact_blocked(player)
	if not managers.network:session() then
		return false, nil, nil
	end

	local local_peer_id = managers.network:session():local_peer():id()

	if self._unit:base() and not self:_is_local_thrower() then
		return true, nil, nil
	end

	if self._pickup_filter and self._pickup_filter ~= tweak_data.projectiles[managers.blackmarket:equipped_projectile()].pickup_filter then
		Application:info("[GrenadePickupInteractionExt:_interact_blocked] Wrong pickup")

		return true, nil, "hint_wrong_grenades"
	end

	if managers.player:got_max_grenades() then
		Application:info("[GrenadePickupInteractionExt:_interact_blocked] Full grenades")

		return true, nil, "hint_full_grenades"
	end

	return false, nil, nil
end

function GrenadePickupInteractionExt:_is_local_thrower()
	if not managers.network:session() then
		return false
	end

	local local_peer_id = managers.network:session():local_peer():id()

	return self._unit:base() and self._unit:base().is_thrower_peer_id and self._unit:base():is_thrower_peer_id(local_peer_id)
end

function GrenadePickupInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	GrenadePickupInteractionExt.super.interact(self, player)

	return true
end

function GrenadePickupInteractionExt:set_contour(color, opacity)
	if not managers.user:get_setting("throwable_contours") or not self:_is_local_thrower() then
		opacity = 0
	end

	GrenadePickupInteractionExt.super.set_contour(self, color, opacity)
end

DropInteractionExt = DropInteractionExt or class(UseInteractionExt)

function DropInteractionExt:_interact_blocked(player)
	return false
end

function DropInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	DropInteractionExt.super.super.interact(self, player)

	local params = deep_clone(self._tweak_data)

	params.target_unit = self._unit

	game_state_machine:change_state_by_name("ingame_multiple_choice_interaction", params)

	return true
end

DropPodInteractionExt = DropPodInteractionExt or class(UseInteractionExt)

function DropPodInteractionExt:_interact_blocked(player)
	return false
end

function DropPodInteractionExt:set_unit(unit_id)
	self._spawn_unit = unit_id
end

function DropPodInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	DropPodInteractionExt.super.interact(self, player)

	local spawn_location = self._unit:get_object(Idstring("spawn_location")) or self._unit:root_object()

	managers.airdrop:spawn_unit_inside_pod(tostring(self._unit:id()), spawn_location:position(), spawn_location:rotation():yaw(), spawn_location:rotation():pitch(), spawn_location:rotation():roll())

	return true
end

MultipleChoiceInteractionExt = MultipleChoiceInteractionExt or class(UseInteractionExt)

function MultipleChoiceInteractionExt:can_interact(player)
	if not self:_has_required_upgrade(alive(player) and player:movement() and player:movement().current_state_name and player:movement():current_state_name()) then
		return false
	end

	if not self:_has_required_deployable() then
		return false
	end

	if self._tweak_data.special_equipment_block and managers.player:has_special_equipment(self._tweak_data.special_equipment_block) then
		return false
	end

	if not self._tweak_data.special_equipment or self._tweak_data.dont_need_equipment then
		return true
	end

	if managers.player:has_special_equipment(self._tweak_data.special_equipment) then
		return true
	end

	if self._tweak_data.possible_special_equipment then
		for i, special_equipment in ipairs(self._tweak_data.possible_special_equipment) do
			if managers.player:has_special_equipment(special_equipment) then
				return true
			end
		end
	end

	return false
end

function MultipleChoiceInteractionExt:interact(player)
	if self._tweak_data.dont_need_equipment then
		MultipleChoiceInteractionExt.super.interact(self, player)

		return
	end

	if not managers.player:has_special_equipment(self._tweak_data.special_equipment) then
		if self._tweak_data.possible_special_equipment then
			for i, special_equipment in ipairs(self._tweak_data.possible_special_equipment) do
				if managers.player:has_special_equipment(special_equipment) then
					managers.player:remove_special(special_equipment)
				end
			end
		end

		if self._unit:damage() then
			self._unit:damage():run_sequence_simple("wrong", {
				unit = player,
			})
		end

		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "interaction", 1)

		return
	end

	MultipleChoiceInteractionExt.super.interact(self, player)
	managers.player:remove_special(self._tweak_data.special_equipment)
end

function MultipleChoiceInteractionExt:sync_net_event(event_id, player)
	if self._unit:damage() then
		self._unit:damage():run_sequence_simple("wrong", {
			unit = player,
		})
	end
end

ECMJammerInteractionExt = ECMJammerInteractionExt or class(UseInteractionExt)

function ECMJammerInteractionExt:interact(player)
	if not self:can_interact(player) then
		return false
	end

	ECMJammerInteractionExt.super.super.interact(self, player)
	self._unit:base():set_feedback_active()
	self:remove_interact()
end

function ECMJammerInteractionExt:can_interact(player)
	return ECMJammerInteractionExt.super.can_interact(self, player) and self._unit:base():owner() == player
end

function ECMJammerInteractionExt:selected(player)
	if not self:can_interact(player) then
		return
	end

	local result = ECMJammerInteractionExt.super.selected(self, player)

	if result then
		self._unit:base():contour_selected()
	end

	return result
end

function ECMJammerInteractionExt:unselect()
	ECMJammerInteractionExt.super.unselect(self)
	self._unit:base():contour_unselected()
end

function ECMJammerInteractionExt:set_active(active, sync, ...)
	ECMJammerInteractionExt.super.set_active(self, active, sync, ...)
	self._unit:base():contour_interaction()
end

ReviveInteractionExt = ReviveInteractionExt or class(BaseInteractionExt)

function ReviveInteractionExt:init(unit, ...)
	self._wp_id = "ReviveInteractionExt" .. unit:id()

	ReviveInteractionExt.super.init(self, unit, ...)
end

function ReviveInteractionExt:_at_interact_start(player, timer)
	ReviveInteractionExt.super._at_interact_start(self, player, timer)
	self:_at_interact_start_revive(player, timer)
	self:set_waypoint_paused(true)
	managers.network:session():send_to_peers_synched("interaction_set_waypoint_paused", self._unit, true)
end

function ReviveInteractionExt:_at_interact_start_revive(player, timer)
	if self._unit:base().is_husk_player then
		local revive_rpc_params = {
			"start_revive_player",
			timer,
		}

		self._unit:network():send_to_unit(revive_rpc_params)
	else
		self._unit:character_damage():pause_bleed_out()
	end
end

function ReviveInteractionExt:_at_interact_interupt(player, complete)
	ReviveInteractionExt.super._at_interact_interupt(self, player, complete)
	self:_at_interact_interupt_revive(player)
	self:set_waypoint_paused(false)

	if self._unit:id() ~= -1 then
		managers.network:session():send_to_peers_synched("interaction_set_waypoint_paused", self._unit, false)
	end
end

function ReviveInteractionExt:_at_interact_interupt_revive(player)
	if self._unit:base().is_husk_player then
		local revive_rpc_params = {
			"interupt_revive_player",
		}

		self._unit:network():send_to_unit(revive_rpc_params)
	else
		self._unit:character_damage():unpause_bleed_out()
	end
end

function ReviveInteractionExt:set_waypoint_paused(paused)
	if self._active_wp then
		managers.hud:set_waypoint_timer_pause(self._wp_id, paused)

		if managers.criminals:character_data_by_unit(self._unit) then
			local name_label_id = self._unit:unit_data() and self._unit:unit_data().name_label_id

			managers.hud:pause_teammate_timer(managers.criminals:character_data_by_unit(self._unit).panel_id, name_label_id, paused)
		end
	end
end

function ReviveInteractionExt:get_waypoint_time()
	if self._active_wp then
		local data = managers.hud:get_waypoint_data(self._wp_id)

		if data then
			return data.timer
		end
	end

	return nil
end

local is_win32 = IS_PC

function ReviveInteractionExt:set_active(active, sync, down_time)
	ReviveInteractionExt.super.set_active(self, active)

	local panel_id

	if managers.criminals:character_data_by_unit(self._unit) then
		panel_id = managers.criminals:character_data_by_unit(self._unit).panel_id
	end

	panel_id = panel_id or self._unit:unit_data() and self._unit:unit_data().teammate_panel_id

	local name_label_id = self._unit:unit_data() and self._unit:unit_data().name_label_id

	if self._active then
		local location_id = self._unit:movement():get_location_id()
		local location = location_id and " " .. managers.localization:text(location_id) or ""
		local hint = "hint_teammate_downed"

		managers.notification:add_notification({
			duration = 3,
			id = hint,
			shelf_life = 5,
			text = managers.localization:text(hint, {
				LOCATION = location,
				TEAMMATE = self._unit:base():nick_name(),
			}),
		})

		if not self._active_wp then
			down_time = down_time or 999

			local text = managers.localization:text(self.tweak_data == "revive" and "debug_team_mate_need_revive" or "debug_team_mate_need_free")
			local icon = self.tweak_data == "revive" and "waypoint_special_downed" or "wp_rescue"
			local timer = self.tweak_data == "revive" and (self._unit:base().is_husk_player and down_time or tweak_data.character[self._unit:base()._tweak_table].damage.DOWNED_TIME)

			managers.hud:add_waypoint(self._wp_id, {
				distance = is_win32,
				icon = icon,
				text = text,
				unit = self._unit,
				waypoint_type = "revive",
			})

			self._active_wp = true

			managers.hud:start_teammate_timer(panel_id, name_label_id, timer)
		end

		if self._from_dropin then
			down_time = down_time or 999

			local name = managers.criminals:character_name_by_unit(self._unit)
			local current = managers.hud._teammate_timers[name] and managers.hud._teammate_timers[name].timer_current
			local total = managers.hud._teammate_timers[name] and managers.hud._teammate_timers[name].timer_total

			if current then
				managers.hud:start_teammate_timer(panel_id, name_label_id, total, current)
			end

			self._from_dropin = nil
		end
	elseif self._active_wp then
		managers.hud:remove_waypoint(self._wp_id)

		self._active_wp = false

		managers.hud:stop_teammate_timer(panel_id, name_label_id)
	end
end

function ReviveInteractionExt:unselect()
	ReviveInteractionExt.super.unselect(self)
	managers.hud:remove_interact()
end

function ReviveInteractionExt:interact(reviving_unit)
	if reviving_unit and reviving_unit == managers.player:player_unit() then
		if not self:can_interact(reviving_unit) then
			return
		end

		if self._tweak_data.equipment_consume then
			managers.player:remove_special(self._tweak_data.special_equipment)
		end

		if self._tweak_data.sound_event then
			reviving_unit:sound():play(self._tweak_data.sound_event)
		end

		ReviveInteractionExt.super.interact(self, reviving_unit)
	end

	self:remove_interact()

	if self._unit:damage() then
		if self._unit:damage() and self._unit:damage():has_sequence("interact") then
			self._unit:damage():run_sequence_simple("interact", {
				unit = player,
			})
		end

		if self._unit:damage() and self._unit:damage():has_sequence("load") then
			self._unit:damage():run_sequence_simple("load", {
				unit = player,
			})
		end
	end

	if self._unit:base().is_husk_player then
		local revive_rpc_params = {
			"revive_player",
			managers.player:upgrade_value("player", "revive_health_boost", 0),
			managers.player:upgrade_value("player", "revive_damage_reduction_level", 0),
		}

		managers.statistics:revived({
			npc = false,
			reviving_unit = reviving_unit,
		})
		self._unit:network():send_to_unit(revive_rpc_params)
	else
		self._unit:character_damage():revive(reviving_unit)
		managers.statistics:revived({
			npc = true,
			reviving_unit = reviving_unit,
		})
	end

	if reviving_unit:in_slot(managers.slot:get_mask("criminals")) then
		local hint = self.tweak_data == "revive" and 2 or 3

		managers.network:session():send_to_peers_synched("sync_teammate_helped_hint", hint, self._unit, reviving_unit)
		managers.trade:sync_teammate_helped_hint(self._unit, reviving_unit, hint)
	end
end

function ReviveInteractionExt:save(data)
	ReviveInteractionExt.super.save(self, data)

	local state = {
		active_wp = self._active_wp,
		wp_id = self._wp_id,
	}

	data.ReviveInteractionExt = state
end

function ReviveInteractionExt:load(data)
	local state = data.ReviveInteractionExt

	if state then
		self._active_wp = state.active_wp
		self._wp_id = state.wp_id
	end

	ReviveInteractionExt.super.load(self, data)

	if self._active_wp then
		self._from_dropin = true
	end
end

AmmoBagInteractionExt = AmmoBagInteractionExt or class(UseInteractionExt)

function AmmoBagInteractionExt:_interact_blocked(player)
	return not player:inventory():need_ammo()
end

function AmmoBagInteractionExt:interact(player)
	AmmoBagInteractionExt.super.super.interact(self, player)

	local interacted = self._unit:base():take_ammo(player)

	for id, weapon in pairs(player:inventory():available_selections()) do
		managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
	end

	return interacted
end

MultipleEquipmentBagInteractionExt = MultipleEquipmentBagInteractionExt or class(UseInteractionExt)

function MultipleEquipmentBagInteractionExt:_interact_blocked(player)
	return not managers.player:can_pickup_equipment(self._special_equipment or "c4")
end

function MultipleEquipmentBagInteractionExt:interact(player)
	MultipleEquipmentBagInteractionExt.super.super.interact(self, player)

	local equipment_name = self._special_equipment or "c4"
	local max_player_can_carry = tweak_data.equipments.specials[equipment_name].quantity or 1
	local player_equipment = managers.player:has_special_equipment(equipment_name)
	local amount_wanted

	if player_equipment then
		amount_wanted = max_player_can_carry - Application:digest_value(player_equipment.amount, false)
	else
		amount_wanted = max_player_can_carry
	end

	if Network:is_server() then
		self:sync_interacted(nil, player, amount_wanted)
	else
		managers.network:session():send_to_host("sync_multiple_equipment_bag_interacted", self._unit, amount_wanted)
	end
end

function MultipleEquipmentBagInteractionExt:sync_interacted(peer, player, amount_wanted)
	local instigator = player or peer:unit()

	if Network:is_server() then
		if self._unit:damage() and self._unit:damage():has_sequence("interact") then
			self._unit:damage():run_sequence_simple("interact", {
				unit = player,
			})
		end

		if self._unit:damage() and self._unit:damage():has_sequence("load") then
			self._unit:damage():run_sequence_simple("load", {
				unit = player,
			})
		end

		if self._global_event then
			managers.mission:call_global_event(self._global_event, instigator)
		end
	end

	local equipment_name = self._special_equipment or "c4"
	local starting_quantity = tweak_data.equipments.specials[equipment_name] and tweak_data.equipments.specials[equipment_name].quantity or 1

	self._current_quantity = self._current_quantity or starting_quantity

	local amount_to_give = math.min(self._current_quantity, amount_wanted)

	if peer then
		managers.network:session():send_to_peer(peer, "give_equipment", equipment_name, amount_to_give, false)
	elseif player then
		managers.player:add_special({
			amount = amount_to_give,
			name = equipment_name,
		})
	end

	if self._remove_when_empty then
		self._current_quantity = self._current_quantity - amount_to_give

		if self._current_quantity <= 0 then
			self._unit:set_slot(0)
			managers.network:session():send_to_peers("remove_unit", self._unit)
		end
	end
end

SmallLootInteractionExt = SmallLootInteractionExt or class(UseInteractionExt)

function SmallLootInteractionExt:interact(player)
	if not self._unit:damage() or not self._unit:damage():has_sequence("interact") then
		SmallLootInteractionExt.super.super.interact(self, player)
	else
		SmallLootInteractionExt.super.interact(self, player)
	end

	self._unit:base():take(player)
end

function SmallLootInteractionExt:_get_interaction_details()
	local value = self._unit:loot_drop() and self._unit:loot_drop():value()
	local details = {
		icon = "rewards_dog_tags_small",
		text = tostring(value) .. "x " .. managers.localization:text("hud_dog_tags"),
	}

	return details
end

ZipLineInteractionExt = ZipLineInteractionExt or class(UseInteractionExt)

function ZipLineInteractionExt:can_select(player)
	return ZipLineInteractionExt.super.can_select(self, player)
end

function ZipLineInteractionExt:check_interupt()
	if alive(self._unit:zipline():user_unit()) then
		return true
	end

	return ZipLineInteractionExt.super.check_interupt(self)
end

function ZipLineInteractionExt:_interact_blocked(player)
	if self._unit:zipline():is_usage_type_bag() and not managers.player:is_carrying() then
		return true, nil, "zipline_no_bag"
	end

	if player:movement():in_air() then
		return true, nil, nil
	end

	if self._unit:zipline():is_interact_blocked() then
		return true, nil, nil
	end

	return false
end

function ZipLineInteractionExt:interact(player)
	ZipLineInteractionExt.super.super.interact(self, player)
	print("ZipLineInteractionExt:interact")
	self._unit:zipline():on_interacted(player)
end

IntimitateInteractionExt = IntimitateInteractionExt or class(BaseInteractionExt)

function IntimitateInteractionExt:unselect()
	UseInteractionExt.super.unselect(self)
	managers.hud:remove_interact()
end

function IntimitateInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	local has_equipment = managers.player:has_special_equipment(self._tweak_data.special_equipment)

	if self._tweak_data.equipment_consume and has_equipment then
		managers.player:remove_special(self._tweak_data.special_equipment)
	end

	if self._tweak_data.sound_event then
		player:sound():play(self._tweak_data.sound_event)
	end

	if self._unit:damage() then
		if self._unit:damage():has_sequence("interact") then
			self._unit:damage():run_sequence_simple("interact", {
				unit = player,
			})
		end

		if self._unit:damage():has_sequence("load") then
			self._unit:damage():run_sequence_simple("load", {
				unit = player,
			})
		end
	end

	if self.tweak_data == "corpse_dispose" then
		local enemy_tweak_data = self._unit:base():char_tweak()
		local carry_name = enemy_tweak_data.carry_tweak_corpse or tweak_data.carry.backup_corpse_body_id

		managers.player:add_carry(carry_name, 0)

		if player == managers.player:player_unit() then
			local carry_tweak = tweak_data.carry[carry_name]
			local carry_type = carry_tweak.type

			if carry_tweak.is_corpse then
				managers.player:set_carry_temporary_data(carry_name, self._unit:character_damage():dismembered_parts())
			end
		end

		local u_id = managers.enemy:get_corpse_unit_data_from_key(self._unit:key()).u_id

		if Network:is_server() then
			self:remove_interact()
			self:set_active(false, true)
			self._unit:set_slot(0)
			managers.enemy:remove_corpse_by_id(u_id)
			managers.network:session():send_to_peers_synched("remove_corpse_by_id", u_id, true, managers.network:session():local_peer():id())
		else
			managers.network:session():send_to_host("sync_interacted_by_id", u_id, self.tweak_data)
			player:movement():set_carry_restriction(true)
		end
	elseif self.tweak_data == "pickpocket_steal" then
		if Network:is_server() then
			self:remove_interact()
			self:set_active(false, true)

			local tweak_table_name = self._unit:brain():on_pickpocket_interaction(player)

			if tweak_table_name then
				managers.network:session():send_to_peers("pickpocket_interaction", self._unit, tweak_table_name)
			end
		else
			managers.network:session():send_to_host("sync_interacted", self._unit, self._unit:id(), self.tweak_data, 1)
		end
	else
		self:remove_interact()
		self:set_active(false)
	end
end

function IntimitateInteractionExt:sync_interacted(peer, player, status, skip_alive_check)
	local function _get_unit()
		local unit = player

		if not unit then
			unit = peer and peer:unit()

			if not unit then
				print("[IntimitateInteractionExt:sync_interacted] missing unit", inspect(peer))
			end
		end

		return unit
	end

	if self.tweak_data == "corpse_dispose" then
		self:remove_interact()
		self:set_active(false, true)

		local u_id = managers.enemy:get_corpse_unit_data_from_key(self._unit:key()).u_id

		self._unit:set_slot(0)
		managers.enemy:remove_corpse_by_id(u_id)
		managers.network:session():send_to_peers_synched("remove_corpse_by_id", u_id, true, peer:id())

		if Network:is_server() and peer then
			local enemy_tweak_data = self._unit:base():char_tweak()
			local carry_name = enemy_tweak_data.carry_tweak_corpse or tweak_data.carry.backup_corpse_body_id

			managers.player:set_carry_approved(carry_name, peer)
		end
	elseif self.tweak_data == "pickpocket_steal" then
		self:remove_interact()
		self:set_active(false, true)

		if Network:is_server() then
			local tweak_table_name = self._unit:brain():on_pickpocket_interaction(_get_unit())

			if tweak_table_name then
				managers.network:session():send_to_peers("pickpocket_interaction", self._unit, tweak_table_name)
			end
		end
	end
end

function IntimitateInteractionExt:on_peer_interacted(tweak_table_name)
	local tweak = tweak_data.greed.greed_items[tweak_table_name]

	if tweak then
		local value = tweak.value
		local notification_item = {
			icon = tweak.hud_icon,
			name_id = tweak.name_id,
			value = value,
		}

		managers.greed:on_loot_picked_up(value, notification_item)
	end
end

function IntimitateInteractionExt:_interact_blocked(player)
	if self.tweak_data == "corpse_dispose" then
		if managers.player:is_carrying() then
			return true
		end

		return not managers.player:local_can_carry("person")
	end
end

function IntimitateInteractionExt:_is_in_required_state(player)
	if self.tweak_data == "corpse_dispose" and managers.groupai:state():is_police_called() then
		return false
	end

	return IntimitateInteractionExt.super._is_in_required_state(self, player)
end

function IntimitateInteractionExt:on_interacting_unit_destroyed(peer, player)
	self:sync_interacted(peer, player, "interrupted", nil)
end

CarryInteractionExt = CarryInteractionExt or class(UseInteractionExt)

function CarryInteractionExt:_interact_blocked(player)
	local silent_block = self:_is_cooldown_or_zipline()

	if silent_block then
		return true, silent_block
	end

	local carry_id = self._unit:carry_data():carry_id()
	local tweak_data = tweak_data.carry[carry_id]

	if not tweak_data then
		Application:warn("[CarryInteractionExt:can_select] Carry interaction unit uses invalid carry id: ", tostring(carry_id), self._unit)

		return true, true
	end

	local blocked = not managers.player:local_can_carry(carry_id)
	local reason

	if tweak_data.cannot_stack then
		reason = "hud_hint_carry_cant_stack"
	elseif tweak_data.is_corpse then
		reason = "hud_hint_carry_cant_stack_corpse"
	elseif blocked then
		reason = "hud_hint_carry_weight_block_interact"
	end

	if blocked then
		managers.hud:shake_carry_icon()
	end

	return blocked, nil, reason
end

function CarryInteractionExt:can_select(player)
	if not self._active then
		return false
	end

	if tweak_data.interaction:get_interaction(self.tweak_data).stealth_only and managers.groupai:state():is_police_called() then
		return false
	end

	if self:_is_cooldown_or_zipline() then
		return false
	end

	return CarryInteractionExt.super.can_select(self, player), managers.player:local_can_carry(self._unit:carry_data():carry_id())
end

function CarryInteractionExt:_is_cooldown_or_zipline()
	return managers.player:carry_blocked_by_cooldown() or self._unit:carry_data():is_attached_to_zipline_unit()
end

function CarryInteractionExt:interact(player)
	Application:warn("[CarryInteractionExt:interact] player", player)
	CarryInteractionExt.super.super.interact(self, player)
	self._unit:carry_data():on_pickup()
	managers.player:add_carry(self._unit:carry_data():carry_id(), self._unit:carry_data():multiplier())
	managers.network:session():send_to_peers_synched("sync_interacted", self._unit, self._unit:id(), self.tweak_data, 1)
	self:sync_interacted(nil, player)

	if Network:is_client() then
		player:movement():set_carry_restriction(true)
	end

	return true
end

function CarryInteractionExt:sync_interacted(peer, player, status, skip_alive_check)
	player = player or peer:unit()

	if self._unit:damage() and self._unit:damage():has_sequence("interact") then
		self._unit:damage():run_sequence_simple("interact", {
			unit = player,
		})
	end

	if self._unit:damage() and self._unit:damage():has_sequence("load") then
		self._unit:damage():run_sequence_simple("load", {
			unit = player,
		})
	end

	if self._global_event then
		managers.mission:call_global_event(self._global_event, player)
	end

	if Network:is_server() then
		if self._remove_on_interact then
			self._unit:carry_data():on_pickup()

			if self._unit == managers.interaction:active_unit() then
				self:interact_interupt(managers.player:player_unit(), false)
			end

			self:remove_interact()
			self:set_active(false, true)

			if alive(player) then
				self._unit:carry_data():trigger_load(player)
			end

			self._unit:set_slot(0)
		end

		if peer then
			managers.player:set_carry_approved(self._unit:carry_data():carry_id(), peer)
		end
	elseif self._remove_on_interact then
		self._unit:set_enabled(false)
	end
end

function CarryInteractionExt:_get_modified_timer()
	local base_timer = CarryInteractionExt.super._get_modified_timer(self) or self:_timer_value()

	return nil
end

function CarryInteractionExt:register_collision_callbacks()
	self._unit:set_body_collision_callback(callback(self, self, "_collision_callback"))

	self._has_modified_timer = true
	self._air_start_time = Application:time()

	for i = 0, self._unit:num_bodies() - 1 do
		local body = self._unit:body(i)

		body:set_collision_script_tag(Idstring("throw"))
		body:set_collision_script_filter(1)
		body:set_collision_script_quiet_time(1)
	end
end

function CarryInteractionExt:_collision_callback(tag, unit, body, other_unit, other_body, position, normal, velocity, ...)
	if self._has_modified_timer then
		self._has_modified_timer = nil
	end

	local air_time = Application:time() - self._air_start_time

	self._unit:carry_data():check_explodes_on_impact(velocity, air_time)

	self._air_start_time = Application:time()

	if self._unit:carry_data():can_explode() and not self._unit:carry_data():explode_sequence_started() then
		return
	end

	for i = 0, self._unit:num_bodies() - 1 do
		local body = self._unit:body(i)

		body:set_collision_script_tag(IDS_EMPTY)
	end
end

function CarryInteractionExt:_get_interaction_details()
	local carry_id = self._unit:carry_data():carry_id()
	local carry_tweak = tweak_data.carry[carry_id]

	if carry_tweak and not carry_tweak.cannot_stack then
		local weight = carry_tweak.weight or tweak_data.carry.default_bag_weight

		if carry_tweak.upgrade_weight_multiplier then
			local multiplier = carry_tweak.upgrade_weight_multiplier

			weight = weight * managers.player:upgrade_value(multiplier.category, multiplier.upgrade, 1)
		end

		local details = {
			icon = "weight_icon",
			text = weight,
		}

		return details
	end

	return CarryInteractionExt.super._get_interaction_details(self)
end

LootBankInteractionExt = LootBankInteractionExt or class(UseInteractionExt)

function LootBankInteractionExt:_interact_blocked(player)
	return not managers.player:is_carrying()
end

function LootBankInteractionExt:interact(player)
	LootBankInteractionExt.super.super.interact(self, player)

	if Network:is_client() then
		managers.network:session():send_to_host("sync_interacted", self._unit, -2, self.tweak_data, 1)
	else
		self:sync_interacted(nil, player)
	end

	managers.player:bank_carry()

	return true
end

function LootBankInteractionExt:sync_interacted(peer, player, status, skip_alive_check)
	local player = player or peer:unit()

	if self._unit:damage() and self._unit:damage():has_sequence("interact") then
		self._unit:damage():run_sequence_simple("interact", {
			unit = player,
		})
	end
end

UseCarryInteractionExt = UseCarryInteractionExt or class(UseInteractionExt)

function UseCarryInteractionExt:_interact_blocked(player)
	if managers.player:is_carrying() then
		local wrong_carry = not managers.player:is_carrying_carry_id(self._tweak_data.required_carry)
		local reason = wrong_carry and (self._tweak_data.required_carry_text or "wrong_carry_item") or nil

		return wrong_carry, nil, reason
	end

	return true, nil, self._tweak_data.required_carry_text
end

function UseCarryInteractionExt:interact(player)
	UseCarryInteractionExt.super.super.interact(self, player)
	managers.network:session():send_to_peers_synched("sync_interacted", self._unit, -2, self.tweak_data, 1)
	self:sync_interacted(nil, player)

	if self._tweak_data.carry_consume then
		managers.player:remove_carry_id(self._tweak_data.required_carry)
	end

	return true
end

function UseCarryInteractionExt:sync_interacted(peer, player, status, skip_alive_check)
	local player = player or peer:unit()

	if self._unit:damage() and self._unit:damage():has_sequence("interact") then
		self._unit:damage():run_sequence_simple("interact", {
			unit = player,
		})
	end
end

EventIDInteractionExt = EventIDInteractionExt or class(UseInteractionExt)

function EventIDInteractionExt:show_blocked_hint(player, skip_hint)
	local unit_base = alive(self._unit) and self._unit:base()

	if unit_base and unit_base.show_blocked_hint then
		unit_base:show_blocked_hint(self._tweak_data, player, skip_hint)
	end
end

function EventIDInteractionExt:_interact_blocked(player)
	local unit_base = alive(self._unit) and self._unit:base()

	if unit_base and unit_base.check_interact_blocked then
		return unit_base:check_interact_blocked(player)
	end

	return false
end

function EventIDInteractionExt:interact_start(player)
	local blocked, skip_hint = self:_interact_blocked(player)

	if blocked then
		self:show_blocked_hint(player, skip_hint)

		return false
	end

	local player_say_interacting = self._tweak_data.player_say_interacting

	if player_say_interacting and player_say_interacting ~= "" then
		local timer = self:_get_timer()
		local delay = timer * 0.1 + math.random() * (timer * 0.2)

		managers.queued_tasks:queue("player_say_interacting", self._interact_say, self, {
			event = player_say_interacting,
			player = player,
		}, delay, nil)
		Application:debug("[BaseInteractionExt:interact_start] player_say_interacting, delay", player_say_interacting, delay)
	end

	if self._tweak_data.timer then
		if not self:can_interact(player) then
			self:show_blocked_hint(player)

			return false
		end

		local timer = self:_get_timer()

		if timer ~= 0 then
			self:_post_event(player, "sound_start")
			self:_at_interact_start(player, timer)

			return false, timer
		end
	end

	return self:interact(player)
end

function EventIDInteractionExt:_add_string_macros(macros)
	EventIDInteractionExt.super._add_string_macros(self, macros)

	if alive(self._unit) and self._unit:base() and self._unit:base().add_string_macros then
		self._unit:base():add_string_macros(macros)
	end
end

function EventIDInteractionExt:interact(player)
	if not self:can_interact(player) then
		return false
	end

	local event_id = alive(self._unit) and self._unit:base() and self._unit:base().get_net_event_id and self._unit:base():get_net_event_id(player) or 1

	if event_id then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "interaction", event_id)
		self:sync_net_event(event_id, managers.network:session():local_peer())
	end
end

function EventIDInteractionExt:can_interact(player)
	if not EventIDInteractionExt.super.can_interact(self, player) then
		return false
	end

	return alive(self._unit) and self._unit:base() and self._unit:base().can_interact and self._unit:base():can_interact(player)
end

function EventIDInteractionExt:selected(player)
	local result = EventIDInteractionExt.super.selected(self, player)

	if result and self._unit:base().contour_selected then
		self._unit:base():contour_selected()
	end

	return result
end

function EventIDInteractionExt:unselect()
	EventIDInteractionExt.super.unselect(self)

	if self._unit:base().contour_unselected then
		self._unit:base():contour_unselected()
	end
end

function EventIDInteractionExt:sync_net_event(event_id, peer)
	local unit_base = alive(self._unit) and self._unit:base()

	if unit_base and unit_base.sync_net_event then
		unit_base:sync_net_event(event_id, peer)
	end
end

SpecialEquipmentInteractionExt = SpecialEquipmentInteractionExt or class(UseInteractionExt)

function SpecialEquipmentInteractionExt:_interact_blocked(player)
	local can_pickup, has_max_quantity = managers.player:can_pickup_equipment(self._special_equipment)

	return not can_pickup, false, has_max_quantity and "max_special_equipment" or nil
end

function SpecialEquipmentInteractionExt:interact(player)
	SpecialEquipmentInteractionExt.super.super.interact(self, player)
	managers.player:add_special({
		name = self._special_equipment,
	})

	if self._remove_on_interact then
		self:remove_interact()
		self:set_active(false)
	end

	if Network:is_client() then
		managers.network:session():send_to_host("sync_interacted", self._unit, -2, self.tweak_data, 1)
	else
		self:sync_interacted(nil, player)
	end

	return true
end

function SpecialEquipmentInteractionExt:selected(player)
	if self._special_equipment and managers.player:has_special_equipment(self._special_equipment) then
		return true
	end

	return SpecialEquipmentInteractionExt.super.selected(self, player)
end

function SpecialEquipmentInteractionExt:sync_interacted(peer, player, status, skip_alive_check)
	player = player or peer:unit()

	if self._unit:damage() then
		if self._unit:damage():has_sequence("interact") then
			self._unit:damage():run_sequence_simple("interact", {
				unit = player,
			})
		end

		if self._unit:damage():has_sequence("load") then
			self._unit:damage():run_sequence_simple("load", {
				unit = player,
			})
		end
	end

	if self._global_event then
		managers.mission:call_global_event(self._global_event, player)
	end

	if self._remove_on_interact then
		self._unit:set_slot(0)
	end
end

AccessCameraInteractionExt = AccessCameraInteractionExt or class(UseInteractionExt)

function AccessCameraInteractionExt:_interact_blocked(player)
	return false
end

function AccessCameraInteractionExt:interact(player)
	AccessCameraInteractionExt.super.super.interact(self, player)
	game_state_machine:change_state_by_name("ingame_access_camera")

	return true
end

MissionElementInteractionExt = MissionElementInteractionExt or class(UseInteractionExt)

function MissionElementInteractionExt:set_mission_element(mission_element)
	self._mission_element = mission_element
end

function MissionElementInteractionExt:_timer_value(...)
	if self._override_timer_value then
		return self._override_timer_value
	end

	return MissionElementInteractionExt.super._timer_value(self, ...)
end

function MissionElementInteractionExt:set_override_timer_value(override_timer_value)
	self._override_timer_value = override_timer_value
end

function MissionElementInteractionExt:sync_net_event(event_id, peer)
	local player = peer:unit()

	if event_id == BaseInteractionExt.EVENT_IDS.at_interact_start then
		if Network:is_server() then
			self._mission_element:on_interact_start(player)
		end
	elseif event_id == BaseInteractionExt.EVENT_IDS.at_interact_interupt and Network:is_server() then
		self._mission_element:on_interact_interupt(player)
	end
end

function MissionElementInteractionExt:_at_interact_start(player, ...)
	MissionElementInteractionExt.super._at_interact_start(self, player, ...)

	if Network:is_server() then
		self._mission_element:on_interact_start(player)
	else
		managers.network:session():send_to_host("sync_unit_event_id_16", self._unit, "interaction", BaseInteractionExt.EVENT_IDS.at_interact_start)
	end
end

function MissionElementInteractionExt:_at_interact_interupt(player, complete)
	MissionElementInteractionExt.super._at_interact_interupt(self, player, complete)

	if not complete then
		if Network:is_server() then
			self._mission_element:on_interact_interupt(player)
		else
			managers.network:session():send_to_host("sync_unit_event_id_16", self._unit, "interaction", BaseInteractionExt.EVENT_IDS.at_interact_interupt)
		end
	end
end

function MissionElementInteractionExt:interact(player, ...)
	MissionElementInteractionExt.super.interact(self, player, ...)

	if Network:is_server() then
		self._mission_element:on_interacted(player)
	end

	return true
end

function MissionElementInteractionExt:sync_interacted(peer, player, ...)
	player = MissionElementInteractionExt.super.sync_interacted(self, peer, player, ...)

	if Network:is_server() and alive(player) then
		self._mission_element:on_interacted(player)
	end
end

function MissionElementInteractionExt:save(data)
	MissionElementInteractionExt.super.save(self, data)

	local state = {}

	state.tweak_data = self.tweak_data
	state.override_timer_value = self._override_timer_value
	data.MissionElementInteractionExt = state
end

function MissionElementInteractionExt:load(data)
	local state = data.MissionElementInteractionExt

	self._override_timer_value = state.override_timer_value

	MissionElementInteractionExt.super.load(self, data)
	self:set_tweak_data(state.tweak_data)
end

DrivingInteractionExt = DrivingInteractionExt or class(UseInteractionExt)

function DrivingInteractionExt:init(unit)
	self.super.init(self, unit)
end

function DrivingInteractionExt:_timer_value(...)
	if self._override_timer_value then
		return self._override_timer_value
	end

	return MissionElementInteractionExt.super._timer_value(self, ...)
end

function DrivingInteractionExt:set_override_timer_value(override_timer_value)
	self._override_timer_value = override_timer_value
end

function DrivingInteractionExt:interact(player, locator)
	if locator == nil then
		return false
	end

	DrivingInteractionExt.super.super.interact(self, player)

	local vehicle_ext = self._unit:vehicle_driving()
	local success = false

	Application:debug("[DrivingInteractionExt:interact] action ", self._action)

	if self._action == VehicleDrivingExt.INTERACT_ENTER or self._action == VehicleDrivingExt.INTERACT_DRIVE then
		success = managers.player:enter_vehicle(self._unit, locator)
	elseif self._action == VehicleDrivingExt.INTERACT_LOOT then
		success = vehicle_ext:give_vehicle_loot_to_player(managers.network:session():local_peer():id())
	elseif self._action == VehicleDrivingExt.INTERACT_REPAIR then
		vehicle_ext:repair_vehicle(player)
		managers.interaction:deactivate_unit()
	elseif self._action == VehicleDrivingExt.INTERACT_TRUNK then
		vehicle_ext:interact_trunk()
	end

	return success
end

function DrivingInteractionExt:_add_string_macros(macros)
	DrivingInteractionExt.super._add_string_macros(self, macros)

	macros.LOOT = self._loot_text
end

function DrivingInteractionExt:selected(player, locator)
	if locator == nil then
		return false
	end

	if locator then
		Application:debug("[DrivingInteractionExt:selected] locator: ", locator:name())
	end

	if not alive(player) or not self:can_select(player, locator) then
		return
	end

	local vehicle_ext = self._unit:vehicle_driving()
	local action = vehicle_ext:get_action_for_interaction(player:position(), locator)

	if action == VehicleDrivingExt.INTERACT_ENTER then
		self._tweak_data.text_id = "hud_int_vehicle_enter"
	elseif action == VehicleDrivingExt.INTERACT_DRIVE then
		self._tweak_data.text_id = "hud_int_vehicle_drive"
	elseif action == VehicleDrivingExt.INTERACT_LOOT and vehicle_ext:has_loot_stored() then
		self._tweak_data.text_id = "hud_int_vehicle_loot"

		local loot_data = vehicle_ext:get_loot()
		local low_weight_index

		for i, carry_item in ipairs(loot_data) do
			if managers.player:local_can_carry(carry_item.carry_id) then
				low_weight_index = i

				break
			end
		end

		if low_weight_index then
			local carry_item = tweak_data.carry[loot_data[low_weight_index].carry_id]

			if carry_item and carry_item.carry_item_id then
				self._tweak_data.text_id = "hud_int_vehicle_custom_loot"
				self._loot_text = managers.localization:text(carry_item.carry_item_id)
			end
		end
	elseif action == VehicleDrivingExt.INTERACT_REPAIR then
		self._tweak_data.text_id = "hud_int_vehicle_repair"
	elseif action == VehicleDrivingExt.INTERACT_TRUNK then
		if vehicle_ext._trunk_open then
			self._tweak_data.text_id = "hud_int_vehicle_close_trunk"
		else
			self._tweak_data.text_id = "hud_int_vehicle_open_trunk"
		end
	else
		self._tweak_data.text_id = nil

		return false
	end

	self._action = action

	local res = DrivingInteractionExt.super.selected(self, player)

	return res
end

function DrivingInteractionExt:can_select(player, locator)
	if locator == nil then
		return true
	end

	local can_select = DrivingInteractionExt.super.can_select(self, player)

	if can_select then
		local vehicle_ext = self._unit:vehicle_driving()
		local action = vehicle_ext:get_action_for_interaction(player:position(), locator)

		can_select = vehicle_ext:is_interaction_enabled(action)

		if action == VehicleDrivingExt.INTERACT_LOOT then
			can_select = true
		end
	end

	return can_select
end

function DrivingInteractionExt:_can_grab_carry_item()
	local vehicle_ext = self._unit:vehicle_driving()

	for _, carry_item in ipairs(vehicle_ext:get_loot()) do
		if managers.player:local_can_carry(carry_item.carry_id) then
			return true
		end
	end

	return false
end

function DrivingInteractionExt:_interact_blocked(player)
	local blocked = false
	local reason

	if managers.player:is_perseverating() then
		reason = "hud_vehicle_no_enter_berserker"
		blocked = true
	elseif managers.player:is_carrying() then
		if self._action == VehicleDrivingExt.INTERACT_ENTER or self._action == VehicleDrivingExt.INTERACT_DRIVE then
			reason = "hud_vehicle_no_enter_carry"
			blocked = true
		elseif self._action == VehicleDrivingExt.INTERACT_LOOT and not self:_can_grab_carry_item() then
			reason = "hud_hint_carry_weight_block_interact"
			blocked = true

			managers.hud:shake_carry_icon()
		end
	end

	return blocked, nil, reason
end

function DrivingInteractionExt:_post_event(player, sound_type, tweak_data_id)
	if not alive(player) then
		return
	end

	if player ~= managers.player:player_unit() then
		return
	end

	local vehicle_ext = self._unit:vehicle_driving()

	if self._vehicle_action == VehicleDrivingExt.INTERACT_REPAIR then
		if sound_type == "sound_interupt" then
			local sound = vehicle_ext._tweak_data.sound.fix_engine_stop

			if sound then
				player:sound():play(sound)
			end
		elseif sound_type == "sound_start" then
			local sound = vehicle_ext._tweak_data.sound.fix_engine_loop

			if sound then
				player:sound():play(sound)
			end
		end
	end
end

function DrivingInteractionExt:_set_active_contour_opacity()
	if self._unit:vehicle_driving() then
		if self._unit:vehicle_driving():get_state_name() == VehicleDrivingExt.STATE_BROKEN then
			return 1
		else
			return 0
		end
	else
		return 1
	end
end

function DrivingInteractionExt:interact_distance()
	local vehicle_ext = self._unit:vehicle_driving()

	return vehicle_ext._tweak_data.interact_distance or tweak_data.interaction.INTERACT_DISTANCE
end

function DrivingInteractionExt:_setup_ray_objects()
	if self._ray_object_names then
		self._ray_objects = {}

		for _, object_name in ipairs(self._ray_object_names) do
			table.insert(self._ray_objects, self._unit:get_object(Idstring(object_name)))
		end
	end
end

core:import("CoreMenuNode")

MainMenuInteractionExt = MainMenuInteractionExt or class(UseInteractionExt)

function MainMenuInteractionExt:init(unit)
	MainMenuInteractionExt.super.init(self, unit)

	if self._menu_item == "comic_book_menu" and not managers.dlc:is_dlc_unlocked(DLCTweakData.DLC_NAME_SPECIAL_EDITION) then
		self._unit:set_slot(0)
	end
end

function MainMenuInteractionExt:can_select(player, locator)
	if self._menu_item == "comic_book_menu" then
		return managers.dlc:is_dlc_unlocked(DLCTweakData.DLC_NAME_SPECIAL_EDITION)
	end

	return true
end

function MainMenuInteractionExt:interact(player)
	MainMenuInteractionExt.super.super.interact(self, player)

	local success = false
	local is_offline = Global.game_settings.single_player

	if self._menu_item == "mission_join_menu" and is_offline then
		return false
	elseif self._menu_item == "challenge_cards_view_menu" and is_offline then
		return false
	end

	if self._menu_item == "mission_selection_menu" then
		if managers.progression:have_pending_missions_to_unlock() then
			success = managers.raid_menu:open_menu("mission_unlock_menu")
		else
			success = managers.raid_menu:open_menu(self._menu_item)
		end
	else
		success = managers.raid_menu:open_menu(self._menu_item)
	end

	if success then
		-- block empty
	end

	return success
end

function MainMenuInteractionExt:selected(player)
	if self._menu_item == "raid_menu_weapon_select" then
		self._tweak_data.text_id = "hud_menu_interaction_select_weapon_select"
	elseif self._menu_item == "challenge_cards_view_menu" then
		if Global.game_settings.single_player then
			self._tweak_data.text_id = "hud_menu_interaction_challenge_cards_offline"
		else
			self._tweak_data.text_id = "hud_menu_interaction_challenge_card_view"
		end
	elseif self._menu_item == "mission_selection_menu" then
		if managers.progression:have_pending_missions_to_unlock() then
			self._tweak_data.text_id = "hud_menu_interaction_unlock_missions"
		elseif Network:is_server() then
			self._tweak_data.text_id = "hud_menu_interaction_select_missions"
		else
			self._tweak_data.text_id = "hud_menu_interaction_view_missions"
		end
	elseif self._menu_item == "mission_join_menu" then
		if Global.game_settings.single_player then
			self._tweak_data.text_id = "hud_menu_interaction_select_mission_join_offline"
		else
			self._tweak_data.text_id = "hud_menu_interaction_select_mission_join"
		end
	elseif self._menu_item == "profile_selection_menu" then
		self._tweak_data.text_id = "hud_menu_interaction_select_profiles"
	elseif self._menu_item == "profile_creation_menu" then
		self._tweak_data.text_id = "hud_menu_interaction_select_profiles_creation"
	elseif self._menu_item == "raid_main_menu" then
		self._tweak_data.text_id = "hud_menu_interaction_select_main_menu"
	elseif self._menu_item == "raid_menu_xp" then
		self._tweak_data.text_id = "hud_menu_interaction_select_skills_menu"
	elseif self._menu_item == "gold_asset_store_menu" then
		self._tweak_data.text_id = "hud_menu_interaction_select_gold_asset_store_menu"
	elseif self._menu_item == "intel_menu" then
		self._tweak_data.text_id = "hud_menu_interaction_select_intel_menu"
	elseif self._menu_item == "comic_book_menu" then
		self._tweak_data.text_id = "hud_menu_interaction_select_comic_book_menu"
	end

	local res = MainMenuInteractionExt.super.selected(self, player)

	return res
end

SpotterFlareInteractionExt = SpotterFlareInteractionExt or class(UseInteractionExt)

function SpotterFlareInteractionExt:interact(player)
	SpotterFlareInteractionExt.super.interact(self, player)
	player:sound():say("player_flare_extinguished", false, true)
end

GreedItemInteractionExt = GreedItemInteractionExt or class(UseInteractionExt)

function GreedItemInteractionExt:interact(player)
	Application:debug("[GreedItemInteractionExt:interact] Player picked up a greed item.")
	GreedItemInteractionExt.super.interact(self, player)

	local value = self._unit:greed():value()
	local value_line = self._unit:greed():value_line_id()

	if value_line ~= "none" and value_line ~= "dogtag" then
		player:sound():say("player_gen_loot_" .. value_line, false, true)
	end

	managers.greed:pickup_greed_item(value, self._unit)
	managers.network:session():send_to_peers("greed_item_picked_up", self._unit, value)
end

function GreedItemInteractionExt:_get_interaction_details()
	local value = self._unit:greed():value()
	local details = {
		icon = "carry_gold",
		text = value .. "g",
	}

	return details
end

function GreedItemInteractionExt:on_peer_interacted(amount)
	managers.greed:pickup_greed_item(amount, self._unit)
end

function GreedItemInteractionExt:can_select()
	return true
end

GreedCacheItemInteractionExt = GreedCacheItemInteractionExt or class(BaseInteractionExt)

function GreedCacheItemInteractionExt:init(unit)
	GreedCacheItemInteractionExt.super.init(self, unit)
end

function GreedCacheItemInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	if self._unit:greed():locked() then
		local params = self._unit:greed():get_lockpick_parameters()

		params.target_unit = self._unit

		managers.player:upgrade_minigame_params(params)
		game_state_machine:change_state_by_name("ingame_special_interaction", params)
	else
		GreedCacheItemInteractionExt.super.interact(self, player)

		local value = self._unit:greed():on_interacted()

		managers.greed:pickup_cache_loot(value)
		managers.network:session():send_to_peers("greed_cache_item_interacted_with", self._unit, value)
	end

	return true
end

function GreedCacheItemInteractionExt:on_peer_interacted(amount)
	local amount_picked_up = self._unit:greed():on_interacted(amount)

	managers.greed:pickup_cache_loot(amount_picked_up)
end

function GreedCacheItemInteractionExt:special_interaction_done()
	self:set_special_interaction_done()
	managers.network:session():send_to_peers("special_interaction_done", self._unit)
end

function GreedCacheItemInteractionExt:set_special_interaction_done()
	self._unit:greed():unlock()
	self:set_dirty(true)
end

function GreedCacheItemInteractionExt:can_select()
	return self._unit:greed():reserve_left() > 0
end

function GreedCacheItemInteractionExt:unselect()
	UseInteractionExt.unselect(self)
end

function GreedCacheItemInteractionExt:_show_interaction_text()
	if self._unit:greed():locked() then
		GreedCacheItemInteractionExt.super._show_interaction_text(self, "hud_greed_cache_locked_prompt")
	else
		GreedCacheItemInteractionExt.super._show_interaction_text(self, "hud_greed_cache_unlocked_prompt")
	end
end

function GreedCacheItemInteractionExt:_timer_value()
	if self._unit:greed():locked() then
		return 0
	else
		return self._unit:greed():interaction_timer_value()
	end
end

function GreedCacheItemInteractionExt:_get_interaction_details()
	if self._unit:greed():locked() then
		return
	end

	local value = self._unit:greed():reserve_left()
	local details = {
		icon = "carry_gold",
		text = value .. "g",
	}

	return details
end

SecretDocumentInteractionExt = SecretDocumentInteractionExt or class(UseInteractionExt)

function SecretDocumentInteractionExt:interact(player)
	Application:debug("[SecretDocumentInteractionExt]", self._tweak_data and self._tweak_data.reward_type)
	SecretDocumentInteractionExt.super.interact(self, player)

	local notification_data

	if self._tweak_data.reward_type == "outlaw" then
		notification_data = self:_interact_reward_outlaw(player)
	else
		debug_pause("[SecretDocumentInteractionExt] Invalid lore here! By player", self._unit, player)
	end

	if notification_data then
		managers.notification:add_notification(notification_data)
	end
end

function SecretDocumentInteractionExt:_interact_reward_outlaw(player)
	local chosen_consumable = tweak_data.operations:get_random_unowned_consumable_raid()

	managers.consumable_missions:pickup_mission(chosen_consumable)

	local notification_data = {
		doc_icon = "notification_consumable",
		doc_text = "hud_hint_consumable_mission_secured",
		duration = 4,
		id = "hud_hint_consumable_mission",
		notification_type = HUDNotification.CONSUMABLE_MISSION_PICKED_UP,
		priority = 3,
	}

	return notification_data
end

function SecretDocumentInteractionExt:can_interact(player)
	if self._tweak_data.reward_type == "outlaw" and managers.consumable_missions:is_all_missions_unlocked() then
		return false
	end

	return SecretDocumentInteractionExt.super.can_interact(self, player)
end

function SecretDocumentInteractionExt:on_load_complete()
	local world_id = managers.worldcollection:get_worlddefinition_by_unit_id(self._unit:unit_data().unit_id):world_id()

	managers.consumable_missions:register_document(self._unit, world_id)
end

FoxholeInteractionExt = FoxholeInteractionExt or class(UseInteractionExt)

function FoxholeInteractionExt:interact(player)
	FoxholeInteractionExt.super.interact(self, player)

	if not self._unit:foxhole() then
		Application:error("[FoxholeInteractionExt:interact] Foxhole interaction unit missing foxhole extension!")

		return
	end

	if not alive(player) then
		Application:error("[FoxholeInteractionExt:interact] Invalid player unit")

		return
	end

	self._unit:foxhole():register_player(player)
	player:movement():set_foxhole_unit(self._unit)
	managers.player:set_player_state("foxhole")
end

ResupplyFullInteractionExt = ResupplyFullInteractionExt or class(UseInteractionExt)

function ResupplyFullInteractionExt:_interact_blocked(player)
	if not player:inventory():need_ammo() and managers.player:got_max_grenades() and player:character_damage():full_health() then
		return true
	end

	return false
end

function ResupplyFullInteractionExt:interact(player)
	ResupplyFullInteractionExt.super.super.interact(self, player)
	managers.player:replenish_player_weapons()
	managers.player:replenish_player()
end

SabotageInteractionExt = SabotageInteractionExt or class(UseInteractionExt)

function SabotageInteractionExt:set_visible(visible)
	if visible and self._tweak_data.requires_upgrade then
		local category = self._tweak_data.requires_upgrade.category
		local upgrade = self._tweak_data.requires_upgrade.upgrade

		visible = managers.player:has_category_upgrade(category, upgrade)
	end

	if visible then
		local equipped_grenade = managers.blackmarket:equipped_grenade()
		local weapon_data = tweak_data.weapon[equipped_grenade]

		visible = weapon_data and weapon_data.category == WeaponTweakData.WEAPON_CATEGORY_GRENADE or false
	end

	if self._unit:damage() then
		self._unit:damage():has_then_run_sequence_simple(visible and "show" or "hide")
	end
end

function SabotageInteractionExt:can_select(player)
	if not managers.player:can_throw_grenade() then
		return false
	end

	local equipped_grenade = managers.blackmarket:equipped_grenade()
	local weapon_data = tweak_data.weapon[equipped_grenade]

	if not weapon_data or weapon_data.category ~= WeaponTweakData.WEAPON_CATEGORY_GRENADE then
		return
	end

	return SabotageInteractionExt.super.can_select(self, player)
end

function SabotageInteractionExt:interact(player)
	if not alive(player) and not managers.player:can_throw_grenade() then
		return false
	end

	managers.player:on_throw_grenade()

	if not managers.player:can_throw_grenade() and player:inventory():equipped_selection() == PlayerInventory.SLOT_3 then
		player:inventory():equip_not_empty()
	end

	SabotageInteractionExt.super.interact(self, player)
end

DummyInteractionExt = DummyInteractionExt or class(BaseInteractionExt)

function DummyInteractionExt:interact_start()
	return false
end

function DummyInteractionExt:can_select()
	return false
end

function DummyInteractionExt:can_interact()
	return false
end

CandyPickupInteractionExt = CandyPickupInteractionExt or class(PickupInteractionExt)

function CandyPickupInteractionExt:_interact_blocked(player)
	return not managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_TRICK_OR_TREAT)
end

function CandyPickupInteractionExt:_get_interaction_details()
	local interaction_detail = self._unit:pickup():interaction_detail()

	if interaction_detail then
		local details = {
			icon = interaction_detail.icon,
			text = managers.localization:text(interaction_detail.text),
		}

		return details
	end

	return false
end
