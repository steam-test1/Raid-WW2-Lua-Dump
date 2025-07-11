core:import("CoreMissionScriptElement")

ElementTeleportPlayer = ElementTeleportPlayer or class(CoreMissionScriptElement.MissionScriptElement)
ElementTeleportPlayer.PEER_OFFSETS = {}
ElementTeleportPlayer.PEER_OFFSETS[1] = 0
ElementTeleportPlayer.PEER_OFFSETS[2] = 1
ElementTeleportPlayer.PEER_OFFSETS[3] = -1
ElementTeleportPlayer.PEER_OFFSETS[4] = 2

function ElementTeleportPlayer:init(...)
	ElementTeleportPlayer.super.init(self, ...)
end

function ElementTeleportPlayer:value(name)
	return self._values[name]
end

function ElementTeleportPlayer:get_spawn_position()
	local peer_id = managers.network:session():local_peer():id()
	local position = self._values.position
	local x = self._values.rotation:x()

	position = position + ElementTeleportPlayer.PEER_OFFSETS[peer_id] * x * 100

	return position
end

function ElementTeleportPlayer:client_on_executed(...)
	if not self._values.enabled then
		return
	end

	if not managers.player:local_player() then
		return
	end

	local position = self:get_spawn_position()

	managers.player:warp_to(position, self._values.rotation)
	managers.player:set_player_state(self._values.state or managers.player:current_state())
	managers.menu:hide_loading_screen()
end

function ElementTeleportPlayer:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if not managers.player:local_player() then
		return
	end

	local position = self:get_spawn_position()
	local rotation

	if self._values.keep_instigator_rotation then
		rotation = instigator:rotation()
	else
		rotation = self._values.rotation
	end

	managers.player:warp_to(position, rotation or Rotation())
	managers.player:set_player_state(self._values.state or managers.player:current_state())
	managers.menu:hide_loading_screen()
	managers.groupai:state():on_player_spawn_state_set(self._values.state or managers.player:default_player_state())
	ElementTeleportPlayer.super.on_executed(self, self._unit or instigator)
end

function ElementTeleportPlayer:_spawn_team_ai()
	managers.worldcollection.team_ai_transition = false

	managers.groupai:state():on_criminal_team_AI_enabled_state_changed(true)
end
