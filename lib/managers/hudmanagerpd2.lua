core:import("CoreEvent")
require("lib/managers/hud/HUDTeammateBase")
require("lib/managers/hud/HUDTeammatePlayer")
require("lib/managers/hud/HUDTeammateAI")
require("lib/managers/hud/HUDTeammatePeer")
require("lib/managers/hud/HUDWeapon/HUDWeaponBase")
require("lib/managers/hud/HUDWeapon/HUDWeaponGeneric")
require("lib/managers/hud/HUDWeapon/HUDWeaponGrenade")
require("lib/managers/hud/HUDWeapon/HUDWeaponClipShots")
require("lib/managers/hud/HUDWeapon/HUDWeaponDrum")
require("lib/managers/hud/HUDWeapon/HUDWeaponRevolver")
require("lib/managers/hud/HUDEquipment")
require("lib/managers/hud/HUDInteraction")
require("lib/managers/hud/HUDCardDetails")
require("lib/managers/hud/HUDMapWaypoint")
require("lib/managers/hud/HUDMapPlayerPin")
require("lib/managers/hud/HUDMapTab")
require("lib/managers/hud/HUDTabGreedBar")
require("lib/managers/hud/HUDTabCandyProgression")
require("lib/managers/hud/HUDTabWeaponChallenge")
require("lib/managers/hud/HUDTabScreen")
require("lib/managers/hud/HUDNameLabel")
require("lib/managers/hud/HUDNameVehicleLabel")
require("lib/managers/hud/HUDObjectives")
require("lib/managers/hud/HUDObjectivesTab")
require("lib/managers/hud/HUDObjectiveBase")
require("lib/managers/hud/HUDObjectiveSub")
require("lib/managers/hud/HUDObjectiveMain")
require("lib/managers/hud/HUDObjectiveDescription")
require("lib/managers/hud/HUDToastNotification")
require("lib/managers/hud/HUDCarry")
require("lib/managers/hud/HUDChat")
require("lib/managers/hud/HUDChatMessage")
require("lib/managers/hud/HUDDriving")
require("lib/managers/hud/HUDHitConfirm")
require("lib/managers/hud/HUDHitDirection")
require("lib/managers/hud/HUDSuspicion")
require("lib/managers/hud/HUDSuspicionIndicator")
require("lib/managers/hud/HUDSuspicionDirection")
require("lib/managers/hud/HUDPlayerCustody")
require("lib/managers/hud/HUDMotionDot")
require("lib/managers/hud/HUDCenterPrompt")
require("lib/managers/hud/HUDBigPrompt")
require("lib/managers/hud/HUDControllerHotswap")
require("lib/managers/hud/HUDCrosshair")
require("lib/managers/hud/HUDStatusEffects")
require("lib/managers/hud/HUDSpecialInteraction/Base")
require("lib/managers/hud/HUDSpecialInteraction/LockPick")
require("lib/managers/hud/HUDSpecialInteraction/FuseCutting")
require("lib/managers/hud/HUDSpecialInteraction/Rewiring")
require("lib/managers/hud/HUDSpecialInteraction/Roulette")
require("lib/managers/hud/HUDMultipleChoiceWheel")
require("lib/managers/hud/HUDTurret")
require("lib/managers/hud/HUDWatermark/HUDWatermarkBase")
require("lib/managers/hud/HUDPlayerVoiceChatStatus")

HUDManager.disabled = {}
HUDManager.disabled[Idstring("guis/player_hud"):key()] = true
HUDManager.disabled[Idstring("guis/experience_hud"):key()] = true
HUDManager.PLAYER_PANEL = 4
HUDManager.TEAMMATE_PANEL_W = 444
HUDManager.TEAMMATE_PANEL_DISTANCE = 32
HUDManager.AI_TEAMMATE_PANEL_PADDING = 18
HUDManager.PEER_TEAMMATE_PANEL_PADDING = 10
HUDManager.WEAPONS_PANEL_W = 384
HUDManager.WEAPONS_PANEL_H = 84
HUDManager.CHAT_DISTANCE_FROM_BOTTOM = 128
HUDManager.MINIGAMES = {
	cut_fuse = HUDSpecialInteractionFuseCutting,
	pick_lock = HUDSpecialInteractionLockPick,
	rewire = HUDSpecialInteractionRewiring,
	roulette = HUDSpecialInteractionRoulette,
}

function HUDManager:controller_mod_changed()
	if alive(managers.interaction:active_unit()) then
		local player = managers.player:local_player()

		managers.interaction:active_unit():interaction():selected(player)
	end
end

function HUDManager:fit_text(text, default_font_size)
	text:set_font_size(default_font_size)

	local rect_w = select(3, text:text_rect())
	local text_w = text:w()

	if text_w < rect_w then
		local scale = text_w / rect_w

		text:set_font_size(default_font_size * scale)
	end
end

function HUDManager:add_weapon(data)
	self._hud.weapons[data.inventory_index] = {
		inventory_index = data.inventory_index,
		unit = data.unit,
	}

	local tweak_data = data.unit:base():weapon_tweak_data()

	if tweak_data.hud and not self._weapon_panels[data.inventory_index] or self._weapon_panels[data.inventory_index] and (data.force or self._weapon_panels[data.inventory_index]:name_id() ~= tweak_data.name_id) then
		if self._weapon_panels[data.inventory_index] then
			self._weapon_panels[data.inventory_index]:destroy()
		end

		self._weapon_panels[data.inventory_index] = nil

		local weapons_panel = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT).panel:child("weapons_panel")

		if data.inventory_index == 1 or data.inventory_index == 2 then
			local weapon_hud_type = data.unit:base():get_weapon_hud_type()

			if weapon_hud_type then
				tweak_data = deep_clone(tweak_data)

				for k, v in pairs(weapon_hud_type) do
					tweak_data.hud[k] = v
				end
			end
		end

		local panel_class_id = tweak_data.hud and tweak_data.hud.panel_class

		if panel_class_id then
			local is_grenade = panel_class_id and panel_class_id == "grenade"
			local use_custom_ui = managers.user:get_setting("hud_special_weapon_panels") or is_grenade
			local panel_class = use_custom_ui and self._weapon_panel_classes[panel_class_id] or HUDWeaponGeneric

			self._weapon_panels[data.inventory_index] = panel_class:new(data.inventory_index, weapons_panel, tweak_data)
		else
			self._weapon_panels[data.inventory_index] = HUDWeaponGeneric:new(data.inventory_index, weapons_panel, tweak_data)
		end

		self:_layout_weapon_panels()
	end

	if data.is_equip then
		self:set_weapon_selected_by_inventory_index(data.inventory_index)
	end

	if not data.is_equip and (data.inventory_index == 1 or data.inventory_index == 2) then
		self:_update_second_weapon_ammo_info(HUDManager.PLAYER_PANEL, data.unit)
	end
end

function HUDManager:_layout_weapon_panels()
	local weapons_panel = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT).panel:child("weapons_panel")
	local right = weapons_panel:w()
	local bottom = weapons_panel:h()
	local w = 0

	for i = #self._weapon_panels, 1, -1 do
		if i ~= 2 then
			self._weapon_panels[i]:set_x(right - self._weapon_panels[i]:w())
			self._weapon_panels[i]:set_y(bottom - self._weapon_panels[i]:h())

			right = right - self._weapon_panels[i]:w()
			w = w + self._weapon_panels[i]:w()
		end
	end

	if self._weapon_panels[2] then
		self._weapon_panels[2]:set_x(right - self._weapon_panels[2]:w())
		self._weapon_panels[2]:set_y(bottom - self._weapon_panels[2]:h())

		right = right - self._weapon_panels[2]:w()
		w = w + self._weapon_panels[2]:w()
	end

	weapons_panel:set_w(w)
	weapons_panel:set_right(weapons_panel:parent():w())
	weapons_panel:set_bottom(weapons_panel:parent():h())
end

function HUDManager:set_weapon_selected_by_inventory_index(inventory_index)
	self:_set_weapon_selected(inventory_index)
end

function HUDManager:_set_weapon_selected(id)
	self._hud.selected_weapon = id

	local icon = self._hud.weapons[self._hud.selected_weapon].unit:base():weapon_tweak_data().hud and self._hud.weapons[self._hud.selected_weapon].unit:base():weapon_tweak_data().hud.icon

	self:_set_teammate_weapon_selected(HUDManager.PLAYER_PANEL, id, icon)
end

function HUDManager:_set_teammate_weapon_selected(i, id, icon)
	if i ~= HUDManager.PLAYER_PANEL then
		return
	end

	for j = 1, #self._weapon_panels do
		self._weapon_panels[j]:set_selected(j == id)
	end
end

function HUDManager:unselect_all_weapons()
	for i = 1, #self._weapon_panels do
		self._weapon_panels[i]:set_selected(false)
	end
end

function HUDManager:remove_all_weapons()
	while self._weapon_panels and #self._weapon_panels > 0 do
		self._weapon_panels[1]:destroy()
		table.remove(self._weapon_panels, 1)
	end
end

function HUDManager:set_weapon_blocked_by_inventory_index(inventory_index, state)
	self:_set_teammate_weapon_blocked(HUDManager.PLAYER_PANEL, inventory_index, state)
end

function HUDManager:_set_teammate_weapon_blocked(i, id, blocked)
	if i ~= HUDManager.PLAYER_PANEL then
		return
	end

	for j = 1, #self._weapon_panels do
		if j == id then
			self._weapon_panels[j]:set_blocked(blocked)
		end
	end
end

function HUDManager:recreate_weapon_firemode(i)
	return
end

function HUDManager:set_teammate_weapon_firemode(i, id, firemode)
	if i == HUDManager.PLAYER_PANEL and self._weapon_panels[id] then
		self._weapon_panels[id]:set_firemode(firemode)
	end
end

function HUDManager:set_firemode_for_weapon(weapon_name_id, firemode)
	for i = 1, #self._weapon_panels do
		local panel_name_id = self._weapon_panels[i] and self._weapon_panels[i]:name_id()

		if panel_name_id and panel_name_id == weapon_name_id then
			self._weapon_panels[i]:set_firemode(firemode)

			return
		end
	end
end

function HUDManager:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max)
	if selection_index > 2 then
		return
	end

	self:set_teammate_ammo_amount(HUDManager.PLAYER_PANEL, selection_index, max_clip, current_clip, current_left, max)
end

function HUDManager:set_teammate_ammo_amount(id, selection_index, max_clip, current_clip, current_left, max)
	if not self._weapon_panels[selection_index] then
		Application:error("[HUDManager:set_teammate_ammo_amount] Attempting to set ammo for non existant weapon panel")

		return
	end

	local type = selection_index == 1 and "secondary" or "primary"

	self._weapon_panels[selection_index]:set_max_clip(max_clip)
	self._weapon_panels[selection_index]:set_current_clip(current_clip)
	self._weapon_panels[selection_index]:set_max(max)

	local total_ammo_without_current_clip = current_left - current_clip

	if total_ammo_without_current_clip < 0 then
		total_ammo_without_current_clip = 0
	end

	local is_empty = current_clip == 0 and total_ammo_without_current_clip == 0

	self._weapon_panels[selection_index]:set_current_left(total_ammo_without_current_clip)
	self._weapon_panels[selection_index]:set_no_ammo(is_empty)
end

function HUDManager:set_weapon_ammo_by_unit(unit)
	local second_weapon_index = self._hud.selected_weapon == 1 and 2 or 1

	if second_weapon_index == unit:base():weapon_tweak_data().use_data.selection_index then
		self:_update_second_weapon_ammo_info(HUDManager.PLAYER_PANEL, unit)
	end
end

function HUDManager:_update_second_weapon_ammo_info(i, unit)
	return
end

function HUDManager:set_player_panel_character_data(data)
	self._teammate_panels[HUDManager.PLAYER_PANEL]:set_character_data(data)
end

function HUDManager:refresh_player_panel()
	self._teammate_panels[HUDManager.PLAYER_PANEL]:refresh()
end

function HUDManager:refresh_player_panels()
	for i = 1, #self._teammate_panels do
		self._teammate_panels[i]:refresh()
	end
end

function HUDManager:show_player_panel()
	self._teammate_panels[HUDManager.PLAYER_PANEL]:show()
	self._teammate_panels[HUDManager.PLAYER_PANEL]:set_peer_id(managers.network:session():local_peer():id())
end

function HUDManager:hide_player_panel()
	self._teammate_panels[HUDManager.PLAYER_PANEL]:hide()
end

function HUDManager:reset_player_state()
	self:reset_teammate_state(HUDManager.PLAYER_PANEL)
end

function HUDManager:reset_player_panel_states()
	for i = 1, #self._teammate_panels do
		self:reset_teammate_state(i)
	end
end

function HUDManager:reset_teammate_state(i)
	self._teammate_panels[i]:reset_state()
end

function HUDManager:set_player_health(data)
	self:set_teammate_health(HUDManager.PLAYER_PANEL, data)
end

function HUDManager:set_teammate_health(i, data)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:set_health(data)
	else
		debug_pause("[ HUDManager:set_teammate_health ] teammate panel " .. tostring(i) .. " doesn't exist!")
		Application:error("data:", inspect(data))
		Application:error("teammate panels:", inspect(self._teammate_panels))
		Application:error(debug.traceback())
	end
end

function HUDManager:set_player_special_health(data)
	self:set_teammate_special_health(HUDManager.PLAYER_PANEL, data)
end

function HUDManager:set_teammate_special_health(i, recoverable_percent)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:set_special_health(recoverable_percent)
	end
end

function HUDManager:set_player_downs(downs_amount)
	if self._teammate_panels[HUDManager.PLAYER_PANEL] then
		self._teammate_panels[HUDManager.PLAYER_PANEL]:set_downs_amount(downs_amount)
	end
end

function HUDManager:override_player_down_color(color)
	if self._teammate_panels[HUDManager.PLAYER_PANEL] then
		self._teammate_panels[HUDManager.PLAYER_PANEL]:override_downs_color(color)
	end
end

function HUDManager:set_player_warcry_meter_fill(data)
	self:set_teammate_warcry_meter_fill(HUDManager.PLAYER_PANEL, data)
end

function HUDManager:set_teammate_warcry_meter_fill(i, data)
	self._teammate_panels[i]:set_warcry_meter_fill(data)
end

function HUDManager:set_player_warcry_meter_glow(value)
	self:set_warcry_meter_glow(HUDManager.PLAYER_PANEL, value)
end

function HUDManager:set_player_active_warcry(warcry)
	self:set_teammate_active_warcry(HUDManager.PLAYER_PANEL, nil, warcry)
end

function HUDManager:set_teammate_active_warcry(i, name_label_id, warcry)
	self._teammate_panels[i]:set_active_warcry(warcry)
end

function HUDManager:set_warcry_meter_glow(i, value)
	self._teammate_panels[i]:set_warcry_ready(value)
end

function HUDManager:activate_teammate_warcry(i, name_label_id, duration)
	self._teammate_panels[i]:activate_warcry(duration)
end

function HUDManager:deactivate_player_warcry()
	self._sound_source:post_event("warcry_active_stop")
	self:set_player_warcry_meter_glow(false)
	self:hide_big_prompt("warcry_ready")
	self:deactivate_teammate_warcry(HUDManager.PLAYER_PANEL, nil)
end

function HUDManager:deactivate_teammate_warcry(i, name_label_id)
	self._teammate_panels[i]:deactivate_warcry()
end

function HUDManager:set_player_level(level)
	self:set_teammate_level(HUDManager.PLAYER_PANEL, level)
end

function HUDManager:set_teammate_level(i, level)
	self._teammate_panels[i]:set_level(level)
end

function HUDManager:show_teammate_turret_icon(teammate_panel_id, name_label_id)
	local panel = self._teammate_panels[teammate_panel_id]

	if panel ~= nil then
		panel:show_turret_icon()
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:show_turret_icon()
	end
end

function HUDManager:hide_teammate_turret_icon(teammate_panel_id, name_label_id)
	local panel = self._teammate_panels[teammate_panel_id]

	if panel ~= nil then
		panel:hide_turret_icon()
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:hide_turret_icon()
	end
end

function HUDManager:set_player_armor(data)
	self:set_teammate_armor(HUDManager.PLAYER_PANEL, data)
end

function HUDManager:set_teammate_armor(i, data)
	if self._teammate_panels[i] then
		-- block empty
	else
		debug_pause("[ HUDManager:set_teammate_armor ] teammate panel " .. tostring(i) .. " doesn't exist!")
		Application:error("data:", inspect(data))
		Application:error("teammate panels:", inspect(self._teammate_panels))
		Application:error(debug.traceback())
	end
end

function HUDManager:set_teammate_name(i, teammate_name)
	local is_local_player = i == HUDManager.PLAYER_PANEL

	self._teammate_panels[i]:set_name(teammate_name, is_local_player)
end

function HUDManager:set_player_nationality(nationality)
	self:set_teammate_nationality(HUDManager.PLAYER_PANEL, nationality)
end

function HUDManager:set_teammate_nationality(i, nationality)
	self._teammate_panels[i]:set_nationality(nationality)
end

function HUDManager:add_special_equipment(data)
	self:add_teammate_special_equipment(HUDManager.PLAYER_PANEL, data)
end

function HUDManager:add_teammate_special_equipment(i, data)
	if not i then
		Application:error("[HUDManager][add_teammate_special_equipment] - Didn't get a teammate panel number")
		Application:stack_dump()

		return
	end

	self._teammate_panels[i]:add_special_equipment(data)
end

function HUDManager:remove_special_equipment(equipment)
	self:remove_teammate_special_equipment(HUDManager.PLAYER_PANEL, equipment)
end

function HUDManager:remove_teammate_special_equipment(panel_id, equipment)
	self._teammate_panels[panel_id]:remove_special_equipment(equipment)
end

function HUDManager:set_special_equipment_amount(equipment_id, amount)
	self:set_teammate_special_equipment_amount(HUDManager.PLAYER_PANEL, equipment_id, amount)
end

function HUDManager:set_teammate_special_equipment_amount(i, equipment_id, amount)
	self._teammate_panels[i]:set_special_equipment_amount(equipment_id, amount)
end

function HUDManager:clear_player_special_equipments()
	self._teammate_panels[HUDManager.PLAYER_PANEL]:clear_special_equipment()
end

function HUDManager:set_stored_health(stored_health_ratio)
	return
end

function HUDManager:set_stored_health_max(stored_health_ratio)
	return
end

function HUDManager:add_item(data)
	return
end

function HUDManager:set_deployable_equipment(i, data)
	return
end

function HUDManager:set_item_amount(index, amount)
	return
end

function HUDManager:set_teammate_deployable_equipment_amount(i, index, data)
	return
end

function HUDManager:set_teammate_grenades(i, data)
	if i == HUDManager.PLAYER_PANEL then
		self._weapon_panels[WeaponInventoryManager.BM_CATEGORY_GRENADES_ID]:set_amount(data.amount)
	end
end

function HUDManager:set_teammate_grenades_amount(i, data)
	if i == HUDManager.PLAYER_PANEL then
		self._weapon_panels[WeaponInventoryManager.BM_CATEGORY_GRENADES_ID]:set_amount(data.amount)
	end
end

function HUDManager:set_player_condition(icon_data, text)
	self:set_teammate_condition(HUDManager.PLAYER_PANEL, icon_data, text)
end

function HUDManager:set_teammate_condition(i, icon_data, text)
	if not i then
		print("Didn't get a number")
		Application:stack_dump()

		return
	end

	self._teammate_panels[i]:set_condition(icon_data, text)
end

function HUDManager:on_teammate_downed(teammate_panel_id, name_label_id)
	local teammate_panel = self._teammate_panels[teammate_panel_id]

	if teammate_panel then
		self._teammate_panels[teammate_panel_id]:go_into_bleedout()
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:go_into_bleedout()
	end
end

function HUDManager:on_teammate_revived(teammate_panel_id, name_label_id)
	local teammate_panel = self._teammate_panels[teammate_panel_id]

	if teammate_panel then
		self._teammate_panels[teammate_panel_id]:on_revived()
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:on_revived()
	end
end

function HUDManager:on_teammate_died(teammate_panel_id, name_label_id)
	local teammate_panel = self._teammate_panels[teammate_panel_id]

	if teammate_panel then
		self._teammate_panels[teammate_panel_id]:on_died()
	end
end

function HUDManager:on_teammate_start_special_interaction(teammate_panel_id, name_label_id, interaction_type)
	local teammate_panel = self._teammate_panels[teammate_panel_id]

	if teammate_panel then
		self._teammate_panels[teammate_panel_id]:show_special_interaction_icon(interaction_type)
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:show_special_interaction_icon(interaction_type)
	end
end

function HUDManager:on_teammate_stop_special_interaction(teammate_panel_id, name_label_id)
	local teammate_panel = self._teammate_panels[teammate_panel_id]

	if teammate_panel then
		self._teammate_panels[teammate_panel_id]:hide_special_interaction_icon()
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:hide_special_interaction_icon()
	end
end

function HUDManager:set_teammate_carry_info(teammate_panel_id, name_label_id, carry_id)
	if teammate_panel_id and self._teammate_panels[teammate_panel_id] and teammate_panel_id ~= HUDManager.PLAYER_PANEL then
		self._teammate_panels[teammate_panel_id]:set_carry_info(carry_id)
	end
end

function HUDManager:remove_teammate_carry_info(teammate_panel_id, name_label_id)
	if teammate_panel_id and self._teammate_panels[teammate_panel_id] and teammate_panel_id ~= HUDManager.PLAYER_PANEL then
		self._teammate_panels[teammate_panel_id]:remove_carry_info()
	end
end

function HUDManager:start_player_timer(time)
	self:start_teammate_timer(HUDManager.PLAYER_PANEL, nil, time)
end

function HUDManager:start_teammate_timer(i, name_label_id, time, current)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:start_timer(time, current)
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:start_timer(time, current)
	end
end

function HUDManager:is_teammate_timer_running(i)
	if self._teammate_panels[i] then
		return self._teammate_panels[i]:is_timer_running()
	end

	return false
end

function HUDManager:pause_player_timer(pause)
	self:pause_teammate_timer(HUDManager.PLAYER_PANEL, nil, pause)
end

function HUDManager:pause_teammate_timer(i, name_label_id, pause)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:set_pause_timer(pause)
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:set_pause_timer(pause)
	end
end

function HUDManager:stop_player_timer()
	self:stop_teammate_timer(HUDManager.PLAYER_PANEL, nil)
end

function HUDManager:stop_teammate_timer(i, name_label_id)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:stop_timer()
	end

	local name_label = self:_get_name_label(name_label_id)

	if name_label then
		name_label:stop_timer()
	end
end

function HUDManager:_setup_ingame_hud_saferect()
	Application:trace("[HUDManager]_setup_ingame_hud_saferect")

	if not self:alive(PlayerBase.INGAME_HUD_SAFERECT) then
		return
	end

	local hud = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	self:_create_teammates_panel(hud)
	self:_create_weapons_panel(hud)
	self:_create_present_panel(hud)
	self:_create_interaction(hud)
	self:_create_pd_progress()
	self:_create_progress_timer(hud)
	self:_create_objectives(hud)
	self:_create_suspicion(hud)
	self:_create_hit_confirm(hud)
	self:_create_hit_direction(hud)
	self:_create_center_prompt(hud)
	self:_create_big_prompt(hud)
	self:_create_controller_hotswap(hud)
	self:_create_suspicion_direction(hud)
	self:_create_turret_hud(hud)
	self:_create_carry(hud)
	self:_setup_driving_hud()
	self:_create_custody_hud()
	self:_create_hud_chat()
	self:_setup_tab_screen()
	self:_get_tab_objectives()
	self:_create_watermark(hud)
	self:_create_crosshair(hud)
	self:set_motiondot_type(managers.user:get_setting("motion_dot"))
	self:_create_status_effects(hud)
end

function HUDManager:_create_ammo_test()
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	if hud.panel:child("ammo_test") then
		hud.panel:remove(hud.panel:child("ammo_test"))
	end

	local panel = hud.panel:panel({
		h = 4,
		name = "ammo_test",
		w = 100,
		x = 550,
		y = 200,
	})

	panel:set_center_y(hud.panel:h() / 2 - 40)
	panel:set_center_x(hud.panel:w() / 2)
	panel:rect({
		color = Color.black:with_alpha(0.5),
		name = "ammo_test_bg_rect",
	})
	panel:rect({
		color = Color.white,
		layer = 1,
		name = "ammo_test_rect",
	})
end

function HUDManager:hud_chat()
	return self._hud_chat
end

function HUDManager:_create_hud_chat()
	local hud_ingame = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	if self._hud_chat then
		self._hud_chat:remove()
	end

	self._hud_chat = HUDChat:new(self._saferect, hud_ingame.panel, true)

	self._hud_chat:set_bottom(hud_ingame.panel:h() - HUDManager.CHAT_DISTANCE_FROM_BOTTOM)
	self._hud_chat:hide()
end

function HUDManager:mark_cheater(peer_id)
	if NetworkPeer.CHEAT_CHECKS_DISABLED == true then
		return
	end

	for i, data in ipairs(self._hud.teammate_panels_data) do
		if self._teammate_panels[i]:peer_id() == peer_id then
			self._teammate_panels[i]:set_cheater(true)

			break
		end
	end
end

function HUDManager:add_teammate_panel(character_name, player_name, ai, peer_id)
	for i, data in ipairs(self._hud.teammate_panels_data) do
		if not data.taken then
			if i ~= HUDManager.PLAYER_PANEL then
				self._ai_teammate_panels[i]:hide()
				self._peer_teammate_panels[i]:hide()

				self._teammate_panels[i] = ai and self._ai_teammate_panels[i] or self._peer_teammate_panels[i]
			end

			self._teammate_panels[i]:reset_state()
			self._teammate_panels[i]:show()
			self._teammate_panels[i]:set_peer_id(peer_id)
			self:set_teammate_name(i, player_name)
			self:set_teammate_nationality(i, character_name)

			if peer_id then
				local peer_equipment = managers.player:get_synced_equipment_possession(peer_id) or {}

				for equipment, amount in pairs(peer_equipment) do
					self:add_teammate_special_equipment(i, {
						amount = amount,
						icon = tweak_data.equipments.specials[equipment].icon,
						id = equipment,
					})
				end

				local peer_deployable_equipment = managers.player:get_synced_deployable_equipment(peer_id)

				if peer_deployable_equipment then
					local icon = tweak_data.equipments[peer_deployable_equipment.deployable].icon

					self:set_deployable_equipment(i, {
						amount = peer_deployable_equipment.amount,
						icon = icon,
					})
				end

				local peer_grenades = managers.player:get_synced_grenades(peer_id)

				if peer_grenades then
					local icon = tweak_data.projectiles[peer_grenades.grenade].icon
				end

				local peer = managers.network:session():peer(peer_id)

				self._teammate_panels[i]:set_level(peer:level())

				if Network:is_server() then
					self._teammate_panels[HUDManager.PLAYER_PANEL]:show_host_indicator()
				elseif peer:is_host() then
					self._teammate_panels[i]:show_host_indicator()
				end
			end

			local unit = managers.criminals:character_unit_by_name(character_name)

			if alive(unit) then
				local weapon = unit:inventory():equipped_unit()

				if alive(weapon) then
					local icon = weapon:base():weapon_tweak_data().hud_icon
					local equipped_selection = unit:inventory():equipped_selection()

					self:_set_teammate_weapon_selected(i, equipped_selection, icon)
				end
			else
				self:on_teammate_died(i)
			end

			local peer_carry_data = managers.player:get_synced_carry(peer_id)

			if peer_carry_data and #peer_carry_data > 0 then
				local unit_data = managers.network:session():peer(peer_id):unit():unit_data()
				local name_label_id

				if unit_data.name_label_id then
					name_label_id = unit_data.name_label_id
				end

				self:set_teammate_carry_info(i, name_label_id, peer_carry_data[1].carry_id)
			end

			data.taken = true

			if ai then
				data.ai = true
			else
				data.ai = false
			end

			if unit then
				unit:unit_data().teammate_panel_id = i
			end

			if peer_id then
				managers.network:session():peer(peer_id):set_teammate_panel_id(i)
			end

			self:_layout_teammate_panels()
			self._tab_screen:refresh_peers()

			if unit and unit:character_damage().run_queued_teammate_panel_update then
				unit:character_damage():run_queued_teammate_panel_update()
			end

			return i
		end
	end

	debug_pause("[HUDManager:add_teammate_panel] Teammate panel is not added:", character_name, player_name, ai, peer_id)
end

function HUDManager:remove_teammate_panel(id)
	self._teammate_panels[id]:hide()

	if not self._teammate_panels[id]:is_ai() then
		self._teammate_panels[id]:hide_host_indicator()
	end

	self._hud.teammate_panels_data[id].taken = false

	self:_layout_teammate_panels()
	self._tab_screen:refresh_peers()

	if Network:is_server() and managers.network:session():count_all_peers() == 1 then
		self._teammate_panels[HUDManager.PLAYER_PANEL]:hide_host_indicator()
	end
end

function HUDManager:_layout_teammate_panels()
	local y = 0
	local human_teammates_exist = false

	for i = 1, #self._teammate_panels do
		if i ~= HUDManager.PLAYER_PANEL and not self._teammate_panels[i]:is_ai() then
			self._teammate_panels[i]:set_y(y)

			y = y + self._teammate_panels[i]:h() + self._teammate_panels[i]:padding_down()
			human_teammates_exist = true
		end
	end

	for i = 1, #self._teammate_panels do
		if i ~= HUDManager.PLAYER_PANEL and self._teammate_panels[i]:is_ai() then
			self._teammate_panels[i]:set_y(y)

			y = y + self._teammate_panels[i]:h() + self._teammate_panels[i]:padding_down()

			if human_teammates_exist then
				self._teammate_panels[i]:set_x(16)
			else
				self._teammate_panels[i]:set_x(0)
			end
		end
	end
end

function HUDManager:get_teammate_panel_by_id(peer_id)
	for i = 1, 4 do
		if peer_id == self._teammate_panels[i]:peer_id() then
			return self._teammate_panels[i]
		end
	end

	return nil
end

function HUDManager:teampanels_height()
	return 300
end

function HUDManager:_create_teammates_panel(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud.teammate_panels_data = self._hud.teammate_panels_data or {}
	self._teammate_panels = {}
	self._ai_teammate_panels = {}
	self._peer_teammate_panels = {}

	if hud.panel:child("teammates_panel") then
		hud.panel:remove(hud.panel:child("teammates_panel"))
	end

	local teammates_panel_params = {
		h = hud.panel:h(),
		halign = "left",
		name = "teammates_panel",
		valign = "grow",
		w = HUDManager.TEAMMATE_PANEL_W,
		x = 0,
		y = 0,
	}
	local teammates_panel = hud.panel:panel(teammates_panel_params)

	for i = 1, 3 do
		self._hud.teammate_panels_data[i] = {
			special_equipments = {},
			taken = false,
		}

		local ai_teammate = HUDTeammateAI:new(i, teammates_panel)

		ai_teammate:set_y((i - 1) * (HUDTeammateAI.DEFAULT_H + ai_teammate:padding_down()))
		table.insert(self._ai_teammate_panels, ai_teammate)

		local peer_teammate = HUDTeammatePeer:new(i, teammates_panel)

		peer_teammate:set_y((i - 1) * (HUDTeammatePeer.DEFAULT_H + peer_teammate:padding_down()))
		peer_teammate:hide()
		table.insert(self._peer_teammate_panels, peer_teammate)
	end

	for i = 1, #self._ai_teammate_panels do
		self._teammate_panels[i] = self._ai_teammate_panels[i]
	end

	local teammate = HUDTeammatePlayer:new(HUDManager.PLAYER_PANEL, teammates_panel)

	table.insert(self._teammate_panels, teammate)

	self._hud.teammate_panels_data[HUDManager.PLAYER_PANEL] = {
		special_equipments = {},
		taken = false,
	}
end

function HUDManager:_fix_peer_warcry_icons()
	for i = 1, #self._hud.name_labels do
		local peer_name_label = self._hud.name_labels[i]
		local peer_id = peer_name_label:peer_id()
		local warcry = peer_name_label.warcry

		if peer_name_label and peer_id and warcry then
			for j = 1, #self._teammate_panels do
				local teammate_panel = self._teammate_panels[j]

				if teammate_panel:peer_id() == peer_id then
					teammate_panel:set_active_warcry(warcry)
				end
			end
		end
	end
end

function HUDManager:_create_weapons_panel(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	local weapons_panel_params = {
		h = HUDManager.WEAPONS_PANEL_H,
		halign = "right",
		name = "weapons_panel",
		valign = "bottom",
		w = HUDManager.WEAPONS_PANEL_W,
	}
	local weapons_panel = hud.panel:panel(weapons_panel_params)

	weapons_panel:set_right(hud.panel:w())
	weapons_panel:set_bottom(hud.panel:h())

	self._weapon_panel_classes = {}
	self._weapon_panel_classes.grenade = HUDWeaponGrenade
	self._weapon_panel_classes.clip_shots = HUDWeaponClipShots
	self._weapon_panel_classes.drum_mag = HUDWeaponDrum
	self._weapon_panel_classes.revolver = HUDWeaponRevolver
	self._weapon_panels = {}
end

function HUDManager:_create_comm_wheel(hud, in_params)
	if self._hud_comm_wheel then
		self._hud_comm_wheel:destroy()

		self._hud_comm_wheel = nil
	end

	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	local params = tweak_data.interaction:get_interaction("com_wheel")
	local pm = managers.player

	params.show_clbks = {
		callback(pm, pm, "disable_view_movement"),
	}
	params.hide_clbks = {
		callback(pm, pm, "enable_view_movement"),
	}
	self._hud_comm_wheel = HUDMultipleChoiceWheel:new(self._saferect, hud, params)

	self._hud_comm_wheel:set_x(hud.panel:w() / 2 - self._hud_comm_wheel:w() / 2)
	self._hud_comm_wheel:set_y(0)
	self._hud_comm_wheel:hide()
end

function HUDManager:comm_wheel_exists()
	return self._hud_comm_wheel ~= nil
end

function HUDManager:show_comm_wheel()
	if not self._hud_comm_wheel then
		self:_create_comm_wheel()
	end

	self._hud_comm_wheel:show()
end

function HUDManager:trigger_comm_wheel_option(option_id)
	if self._hud_comm_wheel then
		self._hud_comm_wheel:trigger_option(option_id)
	end
end

function HUDManager:hide_comm_wheel(quiet)
	if self._hud_comm_wheel and self._hud_comm_wheel:is_visible() then
		self._hud_comm_wheel:hide(quiet)
	end
end

function HUDManager:add_comm_wheel_option(option, index)
	if not self._hud_comm_wheel then
		self:_create_comm_wheel()
	end

	self._hud_comm_wheel:add_option(option, index)
end

function HUDManager:remove_comm_wheel_option(option_id)
	if not self._hud_comm_wheel then
		self:_create_comm_wheel()
	end

	self._hud_comm_wheel:remove_option(option_id)
end

function HUDManager:set_comm_wheel_options(options)
	if not self._hud_comm_wheel then
		self:_create_comm_wheel()
	end

	self._hud_comm_wheel:set_options(options)
end

function HUDManager:is_comm_wheel_visible()
	if self._hud_comm_wheel ~= nil then
		return self._hud_comm_wheel:is_visible()
	end

	return false
end

function HUDManager:_destroy_comm_wheel()
	if self._hud_comm_wheel then
		self._hud_comm_wheel:destroy()

		self._hud_comm_wheel = nil
	end
end

function HUDManager:_create_carry_wheel(hud, in_params)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	local params = tweak_data.interaction:get_interaction("carry_wheel")
	local pm = managers.player

	params.show_clbks = {
		callback(pm, pm, "disable_view_movement"),
	}
	params.hide_clbks = {
		callback(pm, pm, "enable_view_movement"),
	}
	self._hud_carry_wheel = HUDMultipleChoiceWheel:new(self._saferect, hud, params)

	self._hud_carry_wheel:hide()
end

function HUDManager:show_carry_wheel()
	if not self._hud_carry_wheel then
		self:_create_carry_wheel()
	end

	self._hud_carry_wheel:show()
end

function HUDManager:hide_carry_wheel(quiet)
	if self._hud_carry_wheel then
		self._hud_carry_wheel:hide(quiet)
	end
end

function HUDManager:set_carry_wheel_options(options)
	if not self._hud_carry_wheel then
		self:_create_carry_wheel()
	end

	self._hud_carry_wheel:set_options(options)
end

function HUDManager:is_carry_wheel_visible()
	if self._hud_carry_wheel ~= nil then
		return self._hud_carry_wheel:is_visible()
	end

	return false
end

function HUDManager:_destroy_carry_wheel()
	if self._hud_carry_wheel then
		self._hud_carry_wheel:destroy()

		self._hud_carry_wheel = nil
	end
end

function HUDManager:_create_airdrop_wheel(hud, params)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	local params = tweak_data.interaction:get_interaction("airdrop_wheel")
	local pm = managers.player

	params.show_clbks = {
		callback(pm, pm, "disable_view_movement"),
	}
	params.hide_clbks = {
		callback(pm, pm, "enable_view_movement"),
	}
	self._hud_airdrop_wheel = HUDMultipleChoiceWheel:new(self._saferect, hud, params)

	self._hud_airdrop_wheel:hide()
end

function HUDManager:show_airdrop_wheel()
	if not self._hud_airdrop_wheel then
		self:_create_airdrop_wheel()
	end

	self._hud_airdrop_wheel:show()
end

function HUDManager:hide_airdrop_wheel(quiet)
	if self._hud_airdrop_wheel then
		self._hud_airdrop_wheel:hide(quiet)
	end
end

function HUDManager:set_airdrop_wheel_options(options)
	if not self._hud_airdrop_wheel then
		self:_create_airdrop_wheel()
	end

	self._hud_airdrop_wheel:set_options(options)
end

function HUDManager:is_airdrop_wheel_visible()
	if self._hud_airdrop_wheel ~= nil then
		return self._hud_airdrop_wheel:is_visible()
	end

	return false
end

function HUDManager:_destroy_airdrop_wheel()
	if self._hud_airdrop_wheel then
		self._hud_airdrop_wheel:destroy()

		self._hud_airdrop_wheel = nil
	end
end

function HUDManager:create_special_interaction(hud, params)
	Application:debug("[HUDManager:create_special_interaction] TYPE", params.minigame_type)

	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	local mini = params.minigame_type or tweak_data.interaction.MINIGAME_PICK_LOCK

	if not HUDManager.MINIGAMES[mini] then
		debug_pause("[HUDManager:create_special_interaction] minigame_type was nil!!")
	end

	if self._hud_special_interaction then
		self._hud_special_interaction:destroy()
	end

	self._hud_special_interaction = HUDManager.MINIGAMES[mini]:new(hud, params)

	self._hud_special_interaction:set_tweak_data(params)
	self._hud_special_interaction:hide()

	return self._hud_special_interaction
end

function HUDManager:special_interaction_exists()
	return self._hud_special_interaction ~= nil
end

function HUDManager:show_special_interaction()
	if self._hud_special_interaction then
		self._hud_special_interaction:show()
	end
end

function HUDManager:hide_special_interaction(completed)
	if self._hud_special_interaction then
		self._hud_special_interaction:hide(completed)
	end
end

function HUDManager:is_special_interaction_visible()
	if self._hud_special_interaction ~= nil then
		return self._hud_special_interaction:is_visible()
	end

	return false
end

function HUDManager:_create_present_panel(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._toast_notification = HUDToastNotification:new(hud)

	self._toast_notification:set_x(hud.panel:w() / 2 - self._toast_notification:w() / 2)
	self._toast_notification:set_y(70)
end

function HUDManager:present(params)
	if not self._toast_notification then
		local hud = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

		self:_create_present_panel(hud)
	end

	if self._toast_notification then
		self._toast_notification:present(params)
	end
end

function HUDManager:present_done()
	return
end

function HUDManager:_create_interaction(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_interaction = HUDInteraction:new(hud)
end

function HUDManager:show_interact(data)
	self._hud_interaction:show_interact(data)
end

function HUDManager:remove_interact()
	if not self._hud_interaction then
		return
	end

	self._hud_interaction:remove_interact()
end

function HUDManager:show_interaction_bar(current, total)
	self._hud_interaction:show_interaction_bar(current, total)
end

function HUDManager:set_interaction_bar_width(current, total)
	self._hud_interaction:set_interaction_bar_width(current, total)
end

function HUDManager:hide_interaction_bar(complete, show_interact_at_finish)
	self._hud_interaction:hide_interaction_bar(complete, show_interact_at_finish)
end

function HUDManager:_create_progress_timer(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._progress_timer = HUDInteraction:new(hud, "progress_timer")
end

function HUDManager:show_progress_timer(data)
	self._progress_timer:show_interact(data)
end

function HUDManager:remove_progress_timer()
	self._progress_timer:remove_interact()
end

function HUDManager:show_progress_timer_bar(current, total, description)
	if not self._progress_timer_progress_bar then
		local hud = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
		local progress_bar_params = {
			alpha = 0.8,
			color = tweak_data.gui.colors.interaction_bar,
			height = 8,
			name = "progress_timer_progress_bar",
			width = 256,
			x = hud.panel:w() / 2,
			y = hud.panel:h() / 2,
		}

		self._progress_timer_progress_bar = ProgressBarGuiObject:new(hud.panel, progress_bar_params)
	end

	self._progress_timer_progress_bar:show(description)
end

function HUDManager:set_progress_timer_bar_width(current, total)
	self._progress_timer_progress_bar:set_progress(current, total)
end

function HUDManager:set_progress_timer_bar_valid(valid, text_id)
	self._progress_timer:set_bar_valid(valid, text_id)
end

function HUDManager:hide_progress_timer_bar(complete)
	self._progress_timer_progress_bar:hide(complete)
end

function HUDManager:create_objectives_timer_hud(current, total)
	self._hud_objectives:show_timer()

	if self._tab_objectives then
		self._tab_objectives:show_timer()
	end
end

function HUDManager:set_objectives_timer_hud_value(current, total, remaining)
	self._hud_objectives:set_timer_value(current, total)

	if self._tab_objectives then
		self._tab_objectives:set_timer_value(current, total)
	end
end

function HUDManager:remove_objectives_timer_hud(complete)
	self._hud_objectives:hide_timer()

	if self._tab_objectives then
		self._tab_objectives:hide_timer()
	end
end

function HUDManager:show_objectives_timer_hud()
	self._hud_objectives:show_timer()

	if self._tab_objectives then
		self._tab_objectives:show_timer()
	end
end

function HUDManager:hide_objectives_timer_hud()
	self._hud_objectives:hide_timer()

	if self._tab_objectives then
		self._tab_objectives:hide_timer()
	end
end

function HUDManager:set_control_info(data)
	return
end

function HUDManager:sync_start_assault(data)
	return
end

function HUDManager:sync_end_assault(result)
	return
end

function HUDManager:on_progression_cycle_completed()
	if self._tab_screen then
		self._tab_screen:on_progression_cycle_completed()
	end

	local notification_params = {
		duration = 6,
		id = "progression_cycle_completed",
		notification_type = HUDNotification.RAID_UNLOCKED,
		priority = 4,
	}

	managers.notification:add_notification(notification_params)
end

function HUDManager:on_greed_loot_picked_up(old_progress, new_progress, notification_item)
	if self._tab_screen then
		self._tab_screen:on_greed_loot_picked_up(old_progress, new_progress)
	end

	managers.notification:add_notification({
		id = "greed_item_picked_up",
		initial_progress = old_progress,
		item = notification_item,
		new_progress = new_progress,
		notification_type = HUDNotification.GREED_ITEM,
		shelf_life = 8,
	})
end

function HUDManager:set_current_greed_amount(amount)
	if self._tab_screen then
		self._tab_screen:set_current_greed_amount(amount)
	end
end

function HUDManager:reset_greed_indicators()
	if self._tab_screen then
		self._tab_screen:reset_greed_indicator()
	end
end

function HUDManager:_setup_tab_screen()
	if not self:exists(HUDManager.TAB_SCREEN_FULLSCREEN) then
		self:load_hud(HUDManager.TAB_SCREEN_SAFERECT, true, true, true, {})
		self:load_hud(HUDManager.TAB_SCREEN_FULLSCREEN, true, true, false, {})
	end

	local hud_tab_fullscreen = managers.hud:script(HUDManager.TAB_SCREEN_FULLSCREEN)
	local hud_tab_safe = managers.hud:script(HUDManager.TAB_SCREEN_SAFERECT)

	self._tab_screen = HUDTabScreen:new(hud_tab_fullscreen, hud_tab_safe)

	self._tab_screen:hide()

	if IS_PC and IS_STEAM then
		managers.network.account:add_overlay_listener("[HUDManager] hide_tab_screen", {
			"overlay_open",
		}, callback(self, self, "hide_stats_screen"))
	end
end

function HUDManager:show_stats_screen()
	self._tab_screen:show()

	self._showing_stats_screen = true

	self:hide(PlayerBase.INGAME_HUD_FULLSCREEN)
	self:hide(PlayerBase.INGAME_HUD_SAFERECT)
	self:hide(IngameWaitingForRespawnState.GUI_SPECTATOR)
	self:show(HUDManager.TAB_SCREEN_FULLSCREEN)
	self:show(HUDManager.TAB_SCREEN_SAFERECT)
end

function HUDManager:hide_stats_screen()
	if self._tab_screen then
		self._tab_screen:hide()
	end

	if game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
		self:show(IngameWaitingForRespawnState.GUI_SPECTATOR)
	end

	self:show(PlayerBase.INGAME_HUD_FULLSCREEN)
	self:show(PlayerBase.INGAME_HUD_SAFERECT)

	if self._showing_stats_screen then
		self:hide(HUDManager.TAB_SCREEN_FULLSCREEN)
		self:hide(HUDManager.TAB_SCREEN_SAFERECT)
	end

	self._showing_stats_screen = false
end

function HUDManager:showing_stats_screen()
	return self._showing_stats_screen
end

function HUDManager:set_loot_picked_up(amount)
	self._tab_screen:set_loot_picked_up(amount)
end

function HUDManager:set_loot_total(amount)
	self._tab_screen:set_loot_total(amount)
end

function HUDManager:register_tab_event_panel(control_class, params)
	if self._tab_screen then
		self._tab_screen:register_event_panel(control_class, params)
	end
end

function HUDManager:set_tab_event_panel_data(data)
	if self._tab_screen then
		self._tab_screen:set_event_panel_data(data)
	end
end

function HUDManager:remove_tab_event_panel()
	if self._tab_screen then
		self._tab_screen:remove_event_panel()
	end
end

function HUDManager:set_map_location(location_id)
	if self._tab_screen then
		self._tab_screen:set_map_location(location_id)
	end
end

function HUDManager:clear_map()
	if self._tab_screen then
		self._tab_screen:clear_map()
	end
end

function HUDManager:feed_point_of_no_return_timer(time, is_inside)
	return
end

function HUDManager:show_point_of_no_return_timer()
	return
end

function HUDManager:hide_point_of_no_return_timer()
	return
end

function HUDManager:flash_point_of_no_return_timer(beep)
	if beep then
		self._sound_source:post_event("last_10_seconds_beep")
	end
end

function HUDManager:_create_objectives(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_objectives = HUDObjectives:new(hud.panel)

	self._hud_objectives:set_x(hud.panel:w() - self._hud_objectives:w())
	self._hud_objectives:set_y(0)
end

function HUDManager:_get_tab_objectives()
	self._tab_objectives = self._tab_screen:get_objectives_control()
end

function HUDManager:show_objectives()
	if self._hud_objectives then
		self._hud_objectives:show()
	end

	if self._tab_objectives then
		self._tab_objectives:show()
	end
end

function HUDManager:hide_objectives()
	if self._hud_objectives then
		self._hud_objectives:hide()
	end

	if self._tab_objectives then
		self._tab_objectives:hide()
	end
end

function HUDManager:activate_objective(data)
	if self._hud_objectives then
		self._hud_objectives:activate_objective(data)
	end

	if self._tab_objectives then
		self._tab_objectives:activate_objective(data)
	end
end

function HUDManager:complete_sub_objective(data)
	if self._hud_objectives then
		self._hud_objectives:complete_sub_objective(data)
	end

	if self._tab_objectives then
		self._tab_objectives:complete_sub_objective(data)
	end
end

function HUDManager:update_amount_objective(data)
	if self._hud_objectives then
		self._hud_objectives:update_amount_objective(data)
	end

	if self._tab_objectives then
		self._tab_objectives:update_amount_objective(data)
	end
end

function HUDManager:update_amount_sub_objective(data)
	if self._hud_objectives then
		self._hud_objectives:update_amount_sub_objective(data)
	end

	if self._tab_objectives then
		self._tab_objectives:update_amount_sub_objective(data)
	end
end

function HUDManager:remind_objective(id)
	if self._hud_objectives then
		self._hud_objectives:remind_objective(id)
	end

	if self._tab_objectives then
		self._tab_objectives:remind_objective(id)
	end
end

function HUDManager:remind_sub_objective(id)
	if self._hud_objectives then
		self._hud_objectives:remind_sub_objective(id)
	end

	if self._tab_objectives then
		self._tab_objectives:remind_sub_objective(id)
	end
end

function HUDManager:complete_objective(data)
	if self._hud_objectives then
		self._hud_objectives:complete_objective(data)
	end

	if self._tab_objectives then
		self._tab_objectives:complete_objective(data)
	end
end

function HUDManager:render_objective()
	if self._hud_objectives then
		self._hud_objectives:update_objectives()
	end

	if self._tab_objectives then
		self._tab_objectives:update_objectives()
	end
end

function HUDManager:feed_session_time(time)
	self._tab_screen:set_time(time)
end

function HUDManager:reset_session_time()
	self._tab_screen:reset_time()
	managers.game_play_central:start_job_timer()
end

function HUDManager:set_stamina_value(value)
	self._teammate_panels[HUDManager.PLAYER_PANEL]:set_stamina(value)
end

function HUDManager:set_max_stamina(value)
	self._teammate_panels[HUDManager.PLAYER_PANEL]:set_max_stamina(value)
end

function HUDManager:_create_turret_hud(hud)
	self._turret_hud = HUDTurret:new(hud)

	self._turret_hud:set_x(hud.panel:w() / 2 - self._turret_hud:w() / 2)
	self._turret_hud:set_y(hud.panel:h() / 2 - self._turret_hud:h() / 2)
end

function HUDManager:show_turret_hud(turret_unit, bullet_type)
	self._turret_hud:show(turret_unit, bullet_type)
end

function HUDManager:hide_turret_hud(turret_unit)
	self._turret_hud:hide(turret_unit)
end

function HUDManager:update_turret_reticle(v3)
	self._turret_hud:update_turret_reticle(v3)
end

function HUDManager:update_heat_indicator(current)
	self._turret_hud:update_heat_indicator(current)
end

function HUDManager:player_turret_overheat(turret_unit)
	self._turret_hud:overheat(turret_unit)
end

function HUDManager:player_turret_flak_insert()
	self._turret_hud:flak_insert()
end

function HUDManager:set_player_turret_overheating(overheating)
	self._turret_hud:set_overheating(overheating)
end

function HUDManager:player_turret_cooldown()
	self._turret_hud:cooldown()
end

function HUDManager:_create_drama_hud(hud)
	self._drama_hud = HUDDrama:new(hud)

	self._drama_hud:set_x(480)
	self._drama_hud:set_bottom(hud.panel:h())
end

function HUDManager:show_drama_hud(data)
	self._drama_hud:show(data)
end

function HUDManager:hide_drama_hud(data)
	self._drama_hud:hide(data)
end

function HUDManager:_create_watermark(hud)
	return
end

function HUDManager:_create_carry(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._carry_hud = HUDCarry:new(hud)

	self._carry_hud:set_x(hud.panel:w() / 2 - self._carry_hud:w() / 2)
	self._carry_hud:set_y(hud.panel:h() - self._carry_hud:h())
end

function HUDManager:show_carry_item(carry_id)
	self._carry_hud:show_carry_item(carry_id)
end

function HUDManager:hide_carry_item()
	self._carry_hud:hide_carry_item()
end

function HUDManager:set_carry_weight(ratio, overweight)
	self._carry_hud:set_carry_weight(ratio, overweight)
end

function HUDManager:shake_carry_icon()
	self._carry_hud:shake_carry_icon()
end

function HUDManager:_create_suspicion(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_suspicion = HUDSuspicion:new(hud, self._sound_source)
end

function HUDManager:hide_suspicion()
	self._hud_suspicion:hide()
end

function HUDManager:show_suspicion()
	self._hud_suspicion:show()
end

function HUDManager:set_suspicion(status)
	if type(status) == "boolean" then
		if status then
			self._hud_suspicion:discovered()
		else
			self._hud_suspicion:back_to_stealth()
		end
	else
		self._hud_suspicion:show()
	end
end

function HUDManager:_create_hit_confirm(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)
	self._hud_hit_confirm = HUDHitConfirm:new(hud)
end

function HUDManager:on_hit_confirmed(data)
	if managers.user:get_setting("hit_indicator") > HUDHitConfirm.MODE_OFF then
		self._hud_hit_confirm:on_hit_confirmed(data or {})
	end
end

function HUDManager:_create_crosshair(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_crosshair = HUDCrosshair:new(hud)

	self:set_crosshair_visible(true)
end

function HUDManager:set_crosshair_type(t)
	if self._hud_crosshair then
		self._hud_crosshair:set_crosshair_type(t)
	end
end

function HUDManager:set_crosshair_visible(visible)
	if self._hud_crosshair then
		self._hud_crosshair:set_crosshair_visible(managers.user:get_setting("hud_crosshairs") and visible)
	end
end

function HUDManager:set_crosshair_fade(visible)
	if self._hud_crosshair then
		self._hud_crosshair:set_crosshair_fade(visible)
	end
end

function HUDManager:set_crosshair_offset(offset)
	if self._hud_crosshair then
		self._hud_crosshair:set_crosshair_offset(offset)
	end
end

function HUDManager:set_crosshair_offset_instant(offset)
	if self._hud_crosshair then
		self._hud_crosshair:set_crosshair_offset_instant(offset)
	end
end

function HUDManager:set_crosshair_offset_kick(offset)
	if self._hud_crosshair then
		self._hud_crosshair:set_crosshair_offset_kick(offset)
	end
end

function HUDManager:update_crosshair_offset(t, dt)
	if self._hud_crosshair and managers.user:get_setting("hud_crosshairs") then
		self._hud_crosshair:update_crosshair_offset(t, dt)
	end
end

function HUDManager:_create_status_effects(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_status_effects = HUDStatusEffects:new(hud)
end

function HUDManager:add_status_effect(status_data)
	if self._hud_status_effects then
		Application:debug("[StatusEffects] add_status", status_data and status_data.id)
		self._hud_status_effects:add_status(status_data)
	end
end

function HUDManager:remove_status_effect(status_key, sync)
	if self._hud_status_effects then
		Application:debug("[StatusEffects] remove_status", status_key)
		self._hud_status_effects:remove_status(status_key, sync)
	end
end

function HUDManager:clear_all_status_effects()
	if self._hud_status_effects then
		self._hud_status_effects:clear_all_status()
	end
end

function HUDManager:_create_hit_direction(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_hit_direction = HUDHitDirection:new(hud)
end

function HUDManager:on_hit_direction(dir, unit_type_hit)
	self._hud_hit_direction:on_hit_direction(dir, unit_type_hit)
end

function HUDManager:on_hit_unit(attack_data, unit_type_hit)
	self._hud_hit_direction:on_hit_unit(attack_data, unit_type_hit)
end

function HUDManager:clear_hit_direction_indicators()
	self._hud_hit_direction:clean_up()
end

function HUDManager:_create_center_prompt(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._center_prompt = HUDCenterPrompt:new(hud)

	local y_offset = 128

	self._center_prompt:set_x(hud.panel:w() / 2 - self._center_prompt:w() / 2)
	self._center_prompt:set_y(hud.panel:h() / 2 + y_offset - self._center_prompt:h() / 2)
end

function HUDManager:set_prompt(id, text, duration)
	self._center_prompt:show_prompt(id, text, duration)
end

function HUDManager:hide_prompt(id)
	self._center_prompt:hide_prompt(id)
end

function HUDManager:_create_big_prompt(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._big_prompt = HUDBigPrompt:new(hud)

	self._big_prompt:set_x(hud.panel:w() / 2 - self._big_prompt:w() / 2)
	self._big_prompt:set_y(hud.panel:h() / 2 - 262)
end

function HUDManager:set_big_prompt(params)
	self._big_prompt:show_prompt(params)
end

function HUDManager:hide_big_prompt(id)
	self._big_prompt:hide_prompt(id)
end

function HUDManager:_create_controller_hotswap(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._controller_hotswap = HUDControllerHotswap:new(hud)

	self._controller_hotswap:set_x(0)
	self._controller_hotswap:set_y(hud.panel:h() / 2 - 140)
end

function HUDManager:set_controller_hotswap(params)
	self._controller_hotswap:show_prompt(params)
end

function HUDManager:hide_controller_hotswap(id)
	self._controller_hotswap:hide_prompt(id)
end

function HUDManager:_create_suspicion_direction(hud)
	hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
	self._hud_suspicion_direction = HUDSuspicionDirection:new(hud)
end

function HUDManager:create_suspicion_indicator(observer_key, observer_position, initial_state, suspect)
	self._hud_suspicion_direction:create_suspicion_indicator(observer_key, observer_position, initial_state, suspect)
end

function HUDManager:need_to_init_suspicion_indicator(observer_key)
	return self._hud_suspicion_direction:need_to_init(observer_key)
end

function HUDManager:initialize_suspicion_indicator(observer_key, alpha)
	self._hud_suspicion_direction:initialize(observer_key, alpha)
end

function HUDManager:show_suspicion_indicator(observer_key)
	self._hud_suspicion_direction:show_suspicion_indicator(observer_key)
end

function HUDManager:hide_suspicion_indicator(observer_key)
	self._hud_suspicion_direction:hide_suspicion_indicator(observer_key)
end

function HUDManager:set_suspicion_indicator_progress(observer_key, progress)
	self._hud_suspicion_direction:set_suspicion_indicator_progress(observer_key, progress)
end

function HUDManager:clear_suspicion_direction_indicators()
	self._hud_suspicion_direction:clean_up()
end

function HUDManager:_create_custody_hud(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_CUSTODY_HUD)
	self._hud_player_custody = HUDPlayerCustody:new(hud)
end

function HUDManager:set_custody_respawn_time(time)
	self._hud_player_custody:set_respawn_time(time)
end

function HUDManager:set_custody_respawn_type(is_ai_trade)
	self._hud_player_custody:set_respawn_type(is_ai_trade)
end

function HUDManager:set_custody_timer_visibility(visible)
	self._hud_player_custody:set_timer_visibility(visible)
end

function HUDManager:set_custody_pumpkin_challenge()
	self._hud_player_custody:set_pumpkin_challenge()
end

function HUDManager:set_custody_spectator_info(unit)
	self._hud_player_custody:set_spectator_info(unit)
end

function HUDManager:_create_motiondot_hud(hud)
	if not self:is_motion_dot_active() then
		hud = hud or managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)
		self._hud_motion_dot = HUDMotionDot:new(hud)
	else
		Application:warn("[HUDManager:_create_motiondot_hud] Motion dot already exists")
	end
end

function HUDManager:_kill_motiondot_hud()
	if self:is_motion_dot_active() then
		self._hud_motion_dot:clean_up()

		self._hud_motion_dot = nil
	else
		Application:warn("[HUDManager:_kill_motiondot_hud] Motion dot doesnt exist to kill")
	end
end

function HUDManager:set_motiondot_type(index)
	if index > 1 then
		if not self:is_motion_dot_active() then
			self:_create_motiondot_hud()
		else
			self._hud_motion_dot:on_setting_counts(index)
		end
	else
		self:_kill_motiondot_hud()
	end
end

function HUDManager:set_motiondot_counts(index)
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_counts(index)
	end
end

function HUDManager:increment_motiondot_counts()
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_counts_increment()
	end
end

function HUDManager:set_motiondot_offsets(index)
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_offsets(index)
	end
end

function HUDManager:increment_motiondot_offsets()
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_offsets_increment()
	end
end

function HUDManager:set_motiondot_icons(index)
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_icons(index)
	end
end

function HUDManager:increment_motiondot_icons()
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_icons_increment()
	end
end

function HUDManager:set_motiondot_sizes(index)
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_sizes(index)
	end
end

function HUDManager:increment_motiondot_sizes()
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_sizes_increment()
	end
end

function HUDManager:set_motiondot_color(color)
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_color(color)
	end
end

function HUDManager:set_motiondot_color_silly()
	if self:is_motion_dot_active() then
		self._hud_motion_dot:on_setting_color_silly()
	end
end

function HUDManager:fade_out_motion_dot()
	if self:is_motion_dot_active() then
		self._hud_motion_dot:set_fade_hide_dots()
	end
end

function HUDManager:fade_in_motion_dot()
	if self:is_motion_dot_active() then
		self._hud_motion_dot:set_fade_show_dots()
	end
end

function HUDManager:is_motion_dot_active()
	return not not self._hud_motion_dot
end

function HUDManager:is_motion_dot_ads_fade()
	return self._hud_motion_dot and tweak_data.motion_dot_modes_ads_hides[math.min(self._hud_motion_dot:type_index(), #tweak_data.motion_dot_modes_ads_hides)] or false
end

function HUDManager:align_teammate_name_label(panel, interact, double_radius)
	local text = panel:child("text")
	local action = panel:child("action")
	local bag = panel:child("bag")
	local bag_number = panel:child("bag_number")
	local cheater = panel:child("cheater")
	local _, _, tw, th = text:text_rect()
	local _, _, aw, ah = action:text_rect()
	local _, _, cw, ch = cheater:text_rect()

	panel:set_size(math.max(tw, cw) + 4 + double_radius, math.max(th + ah + ch, double_radius))
	text:set_size(panel:w(), th)
	action:set_size(panel:w(), ah)
	cheater:set_size(tw, ch)
	action:set_x(double_radius + 4)
	cheater:set_x(double_radius + 4)
	text:set_top(cheater:bottom())
	action:set_top(text:bottom())
	bag:set_top(text:top() + 4)

	local infamy = panel:child("infamy")

	if infamy then
		panel:set_w(panel:w() + infamy:w())
		text:set_size(panel:size())
		infamy:set_x(double_radius + 4)
		infamy:set_top(text:top())
		text:set_x(double_radius + 4 + infamy:w())
	end

	if bag_number then
		bag_number:set_bottom(text:bottom() - 1)
		panel:set_w(panel:w() + bag_number:w() + bag:w() + 8)
		bag:set_right(panel:w() - bag_number:w())
		bag_number:set_right(panel:w() + 2)
	else
		panel:set_w(panel:w() + bag:w() + 4)
		bag:set_right(panel:w())
	end

	bag:set_w(32)
	bag:set_h(16)
	bag:set_center_x(bag:parent():w() / 2)
	bag:set_y(10)
	text:set_center_x(panel:w() / 2)
	interact:set_position(panel:w() / 2, panel:h() / 2 + text:h() / 2 + 4)
end

function HUDManager:_add_name_label(data)
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)
	local last_id = self._hud.name_labels[#self._hud.name_labels] and self._hud.name_labels[#self._hud.name_labels]:id() or 0
	local id = last_id + 1
	local peer_id
	local is_husk_player = data.unit:base().is_husk_player

	if is_husk_player then
		peer_id = data.unit:network():peer():id()
	end

	local name_label_params = {
		id = id,
		movement = data.unit:movement(),
		name = data.name,
		nationality = data.nationality,
		peer_id = peer_id,
	}
	local name_label = HUDNameLabel:new(hud, name_label_params)

	table.insert(self._hud.name_labels, name_label)

	return id
end

function HUDManager:add_vehicle_name_label(data)
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)
	local last_id = self._hud.name_labels[#self._hud.name_labels] and self._hud.name_labels[#self._hud.name_labels]:id() or 0
	local id = last_id + 1
	local vehicle_name_label_params = {
		id = id,
		vehicle_name = managers.localization:text(data.name),
		vehicle_unit = data.unit,
	}
	local name_label = HUDNameVehicleLabel:new(hud, vehicle_name_label_params)

	table.insert(self._hud.vehicle_name_labels, name_label)

	return id
end

function HUDManager:_remove_name_label(id)
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)

	if not hud then
		return
	end

	for i, name_label in ipairs(self._hud.name_labels) do
		if name_label:id() == id then
			name_label:destroy()
			table.remove(self._hud.name_labels, i)

			break
		end
	end
end

function HUDManager:refresh_name_labels()
	for i = 1, #self._hud.name_labels do
		local peer_name_label = self._hud.name_labels[i]

		if peer_name_label and peer_name_label.refresh then
			peer_name_label:refresh()
		end
	end
end

function HUDManager:remove_vehicle_name_label(id)
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)

	if not hud then
		return
	end

	for i, name_label in ipairs(self._hud.vehicle_name_labels) do
		if name_label:id() == id then
			name_label:destroy()
			table.remove(self._hud.vehicle_name_labels, i)

			break
		end
	end
end

function HUDManager:clear_vehicle_name_labels()
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)

	if not hud then
		return
	end

	for i, name_label in ipairs(self._hud.vehicle_name_labels) do
		name_label:destroy()
	end

	self._hud.vehicle_name_labels = {}
end

function HUDManager:_name_label_by_peer_id(peer_id)
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)

	if not hud then
		return
	end

	for i, name_label in ipairs(self._hud.name_labels) do
		if name_label:peer_id() == peer_id then
			return name_label
		end
	end
end

function HUDManager:_get_name_label(id)
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)

	if not hud then
		return
	end

	for i, name_label in ipairs(self._hud.name_labels) do
		if name_label:id() == id then
			return name_label
		end
	end
end

function HUDManager:set_name_label_carry_info(peer_id, carry_id)
	return
end

function HUDManager:set_vehicle_label_carry_info(label_id, value, number)
	return
end

function HUDManager:remove_name_label_carry_info(peer_id)
	return
end

function HUDManager:teammate_start_progress(teammate_panel_id, name_label_id, timer)
	local name_label = self:_get_name_label(name_label_id)
	local teammate_panel = self._teammate_panels[teammate_panel_id]

	if name_label and name_label.start_interact then
		name_label:start_interact(timer)
	end

	if teammate_panel and teammate_panel.start_interact then
		teammate_panel:start_interact(timer)
	end
end

function HUDManager:teammate_cancel_progress(teammate_panel_id, name_label_id)
	local name_label = self:_get_name_label(name_label_id)
	local teammate_panel = self._teammate_panels[teammate_panel_id]

	if name_label and name_label.cancel_interact then
		name_label:cancel_interact()
	end

	if teammate_panel and teammate_panel.cancel_interact then
		teammate_panel:cancel_interact()
	end
end

function HUDManager:teammate_complete_progress(teammate_panel_id, name_label_id)
	local name_label = self:_get_name_label(name_label_id)
	local teammate_panel = self._teammate_panels[teammate_panel_id]

	if name_label and name_label.complete_interact then
		name_label:complete_interact()
	end

	if teammate_panel and teammate_panel.complete_interact then
		teammate_panel:complete_interact()
	end
end

function HUDManager:_animate_label_interact(panel, interact, timer)
	local t = 0

	while t <= timer do
		local dt = coroutine.yield()

		t = t + dt

		interact:set_current(t / timer)
	end

	interact:set_current(1)
end

function HUDManager:toggle_chatinput()
	self:set_chat_focus(true)
end

function HUDManager:chat_focus()
	return self._chat_focus
end

function HUDManager:set_chat_skip_first(skip_first)
	if self._hud_chat then
		self._hud_chat:set_skip_first(skip_first)
	end
end

function HUDManager:set_chat_focus(focus)
	if not self:alive(PlayerBase.INGAME_HUD_FULLSCREEN) and not self:alive(IngameWaitingForRespawnState.GUI_SPECTATOR) then
		return
	end

	if self._chat_focus == focus then
		return
	end

	if self._hud_comm_wheel then
		self:hide_comm_wheel(true)
	end

	setup:add_end_frame_callback(function()
		self._chat_focus = focus
	end)
	self._chatinput_changed_callback_handler:dispatch(focus)

	if focus then
		self._hud_chat:_on_focus()
	else
		self._hud_chat:_loose_focus()
	end
end

function HUDManager:_setup_driving_hud()
	local hud = managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT)

	self._hud_driving = HUDDriving:new(hud)
end

function HUDManager:start_driving()
	self._hud_driving:start()
end

function HUDManager:stop_driving()
	self._hud_driving:stop()
end

function HUDManager:set_driving_vehicle_state(speed, rpm, gear)
	self._hud_driving:set_vehicle_state(speed, rpm, gear)
end

function HUDManager:set_vehicle_loot_info(vehicle, current_loot, current_loot_amount, max_loot_amount)
	self._hud_driving:set_vehicle_loot_info(vehicle, current_loot, current_loot_amount, max_loot_amount)
end

function HUDManager:ai_entered_vehicle(ai_unit, vehicle)
	self._hud_driving:refresh_seats()
end

function HUDManager:peer_enter_vehicle(peer_id, vehicle)
	if peer_id == managers.network:session():local_peer():id() then
		self._hud_driving:show(vehicle)
	end

	self._hud_driving:refresh_seats()
	self._tab_screen:peer_enter_vehicle(peer_id)
end

function HUDManager:peer_exit_vehicle(peer_id)
	if peer_id == managers.network:session():local_peer():id() then
		self._hud_driving:hide()
	else
		self._hud_driving:refresh_seats()
	end

	self._tab_screen:peer_exit_vehicle(peer_id)
end

function HUDManager:player_changed_vehicle_seat()
	self._hud_driving:refresh_seats(true)
end

function HUDManager:refresh_vehicle_health()
	self._hud_driving:refresh_health()
end

function HUDManager:hide_vehicle_hud()
	self._hud_driving:hide()
end
