core:import("CoreMissionScriptElement")

ElementPlayerSpawner = ElementPlayerSpawner or class(CoreMissionScriptElement.MissionScriptElement)
ElementPlayerSpawner.HIDE_LOADING_SCREEN_DELAY = 2
ElementPlayerSpawner.BASE_DELAY = 3.5

function ElementPlayerSpawner:init(...)
	ElementPlayerSpawner.super.init(self, ...)
	managers.player:preload()
end

function ElementPlayerSpawner:get_spawn_position()
	local peer_id = managers.network:session():local_peer():id()
	local position = self._values.position
	local x = self._values.rotation:x()

	position = position + ElementTeleportPlayer.PEER_OFFSETS[peer_id] * x * 100

	return position
end

function ElementPlayerSpawner:value(name)
	return self._values[name]
end

function ElementPlayerSpawner:client_on_executed(...)
	if not self._values.enabled then
		return
	end

	managers.player:set_player_state(self._values.state or managers.player:default_player_state())
	self:_end_transition(true)
end

function ElementPlayerSpawner:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.player:set_player_state(self._values.state or managers.player:default_player_state())
	managers.groupai:state():on_player_spawn_state_set(self._values.state or managers.player:default_player_state())
	managers.network:register_spawn_point(self:_unique_string_id(), {
		position = self._values.position,
		rotation = self._values.rotation,
	})
	ElementPlayerSpawner.super.on_executed(self, self._unit or instigator)
	self:_end_transition()
end

function ElementPlayerSpawner:_end_transition(client)
	local cnt = managers.worldcollection.world_counter or 0
	local player_spawned = true

	if client and not managers.player:player_unit() then
		player_spawned = false
	end

	if not managers.worldcollection:check_all_peers_synced_last_world(CoreWorldCollection.STAGE_LOAD_FINISHED) or cnt > 0 or not player_spawned then
		managers.queued_tasks:queue(nil, self._end_transition, self, client, 0.5)

		return
	end

	if managers.worldcollection.level_transition_in_progress and not managers.player._players_spawned then
		managers.player._players_spawned = true

		managers.queued_tasks:queue(nil, managers.worldcollection.level_transition_ended, managers.worldcollection, nil, ElementPlayerSpawner.BASE_DELAY)
		managers.queued_tasks:queue(nil, self._do_hide_loading_screen, self, nil, ElementPlayerSpawner.BASE_DELAY + ElementPlayerSpawner.HIDE_LOADING_SCREEN_DELAY)
	end
end

function ElementPlayerSpawner:_do_hide_loading_screen()
	if managers.raid_job:is_camp_loaded() or managers.raid_job:is_in_tutorial() then
		managers.queued_tasks:queue(nil, self._first_login_check, self, nil, 0.5)
	end

	local spawned_weapon_slot = PlayerInventory.SLOT_2

	if managers.player:local_player() and managers.raid_job:current_job() and (managers.raid_job:current_job().start_in_stealth or managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE)) then
		spawned_weapon_slot = PlayerInventory.SLOT_4
	end

	managers.player:get_current_state():force_change_weapon_slot(spawned_weapon_slot)
	managers.menu:hide_loading_screen()
end

function ElementPlayerSpawner:_first_login_check()
	if managers.worldcollection.first_login_check then
		managers.worldcollection.first_login_check = false

		managers.raid_menu:first_login_check()

		if managers.raid_menu:is_offline_mode() or managers.raid_job:is_in_tutorial() then
			-- block empty
		else
			managers.event_system:on_camp_entered()
		end
	end
end

function ElementPlayerSpawner:destroy()
	ElementPlayerSpawner.super.destroy(self)
	managers.queued_tasks:unqueue_all(nil, self)
end
