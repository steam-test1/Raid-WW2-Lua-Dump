ClientNetworkSession = ClientNetworkSession or class(BaseNetworkSession)
ClientNetworkSession.HOST_SANITY_CHECK_INTERVAL = 4
ClientNetworkSession.HOST_REQUEST_JOIN_INTERVAL = 2
ClientNetworkSession.JOIN_REQUEST_TIMEOUT = 20

function ClientNetworkSession:request_join_host(host_rpc, result_cb)
	print("[ClientNetworkSession:request_join_host]", host_rpc, result_cb)

	self._cb_find_game = result_cb

	local host_name = managers.network.matchmake:game_owner_name()
	local host_user_id = IS_PC and host_rpc:ip_at_index(0) or false
	local id, peer = self:add_peer(host_name, nil, nil, nil, nil, 1, nil, host_user_id, "", "")

	if IS_PC then
		peer:set_steam_rpc(host_rpc)
	end

	local ticket = peer:create_ticket()

	self._server_peer = peer

	Network:set_multiplayer(true)
	Network:set_client(host_rpc)

	local request_rpc = IS_PC and peer:steam_rpc() or host_rpc
	local xuid = IS_XB1 and managers.network.account:player_id() or ""
	local lvl = managers.experience:current_level()
	local gameversion = managers.network.matchmake.GAMEVERSION or -1
	local join_req_id = self:_get_join_attempt_identifier()

	self._join_request_params = {
		host_rpc = request_rpc,
		params = {
			self._local_peer:name(),
			managers.blackmarket:get_preferred_character_string(),
			managers.dlc:dlcs_string(),
			xuid,
			lvl,
			gameversion,
			join_req_id,
			ticket,
		},
	}

	request_rpc:request_join(unpack(self._join_request_params.params))

	self._first_join_request_t = TimerManager:wall():time()
	self._last_join_request_t = self._first_join_request_t
end

function ClientNetworkSession:on_join_request_reply(reply, my_peer_id, my_character, job_id, difficulty_index, state_index, server_character, user_id, mission, xuid, auth_ticket, sender)
	print("[ClientNetworkSession:on_join_request_reply] ", self._server_peer and self._server_peer:user_id(), user_id, sender:ip_at_index(0), sender:protocol_at_index(0))

	if not self._server_peer or not self._cb_find_game then
		return
	end

	if self._server_peer:ip() and sender:ip_at_index(0) ~= self._server_peer:ip() then
		print("[ClientNetworkSession:on_join_request_reply] wrong host replied", self._server_peer:ip(), sender:ip_at_index(0))

		return
	end

	self._last_join_request_t = nil

	if IS_PC then
		if self._server_peer:user_id() and user_id ~= self._server_peer:user_id() then
			print("[ClientNetworkSession:on_join_request_reply] wrong host replied", self._server_peer:user_id(), user_id)

			return
		else
			if sender:protocol_at_index(0) == "STEAM" then
				self._server_protocol = "STEAM"
			else
				self._server_protocol = "TCP_IP"
			end

			self._server_peer:set_rpc(sender)
			self._server_peer:set_ip_verified(true)
			Network:set_client(sender)
		end
	else
		self._server_protocol = "TCP_IP"

		self._server_peer:set_rpc(sender)
		self._server_peer:set_ip_verified(true)
		Network:set_client(sender)
	end

	local cb = self._cb_find_game

	self._cb_find_game = nil

	if reply == 1 then
		self._host_sanity_send_t = TimerManager:wall():time() + self.HOST_SANITY_CHECK_INTERVAL

		tweak_data:set_difficulty(tweak_data:index_to_difficulty(difficulty_index))

		Global.game_settings.mission = mission

		self._server_peer:set_character(server_character)
		self._server_peer:set_xuid(xuid)
		self._server_peer:set_id(1)

		if IS_XB1 then
			local xnaddr = managers.network.matchmake:external_address(self._server_peer:rpc())

			self._server_peer:set_xnaddr(xnaddr)
			managers.network.matchmake:on_peer_added(self._server_peer)
		elseif IS_PS4 then
			managers.network.matchmake:on_peer_added(self._server_peer)
		end

		self:register_local_peer(my_peer_id)
		self._local_peer:set_character(my_character)
		self._local_peer:set_class(managers.skilltree:get_character_profile_class())

		if not self._server_peer:begin_ticket_session(auth_ticket) then
			self:remove_peer(self._server_peer, 1)
			cb("AUTH_HOST_FAILED")

			if managers.game_play_central and managers.game_play_central:is_restarting() then
				managers.game_play_central:is_restarting(false)
			end

			return
		end

		self._server_peer:set_in_lobby_soft(state_index == 1)
		self._server_peer:set_synched_soft(state_index ~= 1)
		self:_chk_send_proactive_outfit_loaded()

		local load_data = {
			instant = true,
		}

		if job_id ~= "" then
			Application:debug("[[ClientNetworkSession:on_join_request_reply]] Mission:", mission, job_id)

			local mission_data = tweak_data.operations:mission_data(job_id)

			load_data.background = mission_data.loading.image
			load_data.loading_text = mission_data.loading.text
			load_data.mission = mission_data
			mission_data.job_type = OperationsTweakData.JOB_TYPE_RAID

			self._server_peer:verify_job(job_id)
			managers.raid_job:load_level_tweak_packages(job_id)
			managers.raid_job:on_mission_started()
		else
			local mission_data = tweak_data.operations:mission_data(RaidJobManager.CAMP_ID)

			load_data.background = mission_data.loading.image
			load_data.loading_text = mission_data.loading.text
			load_data.mission = mission_data

			managers.raid_job:load_level_tweak_packages(RaidJobManager.CAMP_ID)
		end

		Global.dropin_loading_screen = load_data

		managers.menu:show_loading_screen(load_data)
		Application:debug("[ClientNetworkSession:on_join_request_reply] Shown loading screen!", inspect(managers.menu._loading_screen))
		cb(state_index == 1 and "JOINED_LOBBY" or "JOINED_GAME", state_index)
	elseif reply == 2 then
		self:remove_peer(self._server_peer, 1)
		cb("KICKED")
	elseif reply == 0 then
		if managers.network.matchmake._server_connect_retried and managers.network.matchmake._server_connect_retried >= NetworkMatchMaking.RETRY_CONNECT_COUNT then
			self:remove_peer(self._server_peer, 1)
		end

		cb("FAILED_CONNECT")
	elseif reply == 3 then
		self:remove_peer(self._server_peer, 1)
		cb("GAME_STARTED")
	elseif reply == 4 then
		self:remove_peer(self._server_peer, 1)
		cb("DO_NOT_OWN_HEIST")
	elseif reply == 5 then
		self:remove_peer(self._server_peer, 1)
		cb("GAME_FULL")
	elseif reply == 6 then
		self:remove_peer(self._server_peer, 1)
		cb("LOW_LEVEL")
	elseif reply == 7 then
		self:remove_peer(self._server_peer, 1)
		cb("WRONG_VERSION")
	elseif reply == 8 then
		self:remove_peer(self._server_peer, 1)
		cb("AUTH_FAILED")
	end

	if reply ~= 1 and managers.game_play_central and managers.game_play_central:is_restarting() then
		managers.game_play_central:set_restarting(false)
	end
end

function ClientNetworkSession:on_join_request_timed_out()
	local cb = self._cb_find_game

	self._cb_find_game = nil

	cb("TIMED_OUT")

	if managers.game_play_central then
		managers.game_play_central:set_restarting(false)
	end
end

function ClientNetworkSession:on_join_request_cancelled()
	local cb = self._cb_find_game

	if cb then
		self._cb_find_game = nil

		if self._server_peer then
			self:remove_peer(self._server_peer, 1)
		end

		cb("CANCELLED")
	end

	if managers.game_play_central then
		managers.game_play_central:set_restarting(false)
	end
end

function ClientNetworkSession:discover_hosts()
	self._discovered_hosts = {}

	Network:broadcast(NetworkManager.DEFAULT_PORT):discover_host()
end

function ClientNetworkSession:on_host_discovered(new_host, new_host_name, level_name, my_ip, state, difficulty)
	if self._discovered_hosts then
		local new_host_data = {
			difficulty = difficulty,
			host_name = new_host_name,
			level_name = level_name,
			my_ip = my_ip,
			rpc = new_host,
			state = state,
		}
		local already_known

		for i_host, host_data in ipairs(self._discovered_hosts) do
			if host_data.host_name == new_host_name and host_data.rpc:ip_at_index(0) == new_host:ip_at_index(0) then
				self._discovered_hosts[i_host] = new_host_data
				already_known = true

				break
			end
		end

		if not already_known then
			table.insert(self._discovered_hosts, new_host_data)
		end
	end
end

function ClientNetworkSession:on_server_up_received(host_rpc)
	if self._discovered_hosts then
		host_rpc:request_host_discover_reply()
	end
end

function ClientNetworkSession:discovered_hosts()
	return self._discovered_hosts
end

function ClientNetworkSession:send_to_host(...)
	if self._server_peer then
		self._server_peer:send(...)
	else
		print("[ClientNetworkSession:send_to_host] no host")
	end
end

function ClientNetworkSession:is_host()
	return false
end

function ClientNetworkSession:is_client()
	return true
end

function ClientNetworkSession:load_level(...)
	self:send_to_host("set_loading_state", true, self._load_counter)
	self:_load_level(...)
end

function ClientNetworkSession:load_lobby(...)
	self:send_to_host("set_loading_state", true, self._load_counter)
	self:_load_lobby(...)
end

function ClientNetworkSession:peer_handshake(name, peer_id, peer_user_id, in_lobby, loading, synched, character, xuid, xnaddr)
	print("ClientNetworkSession:peer_handshake", name, peer_id, peer_user_id, in_lobby, loading, synched, character, xuid, xnaddr)

	if self._peers[peer_id] then
		print("ALREADY HAD PEER returns here")

		local peer = self._peers[peer_id]

		if peer:ip_verified() then
			self._server_peer:send("connection_established", peer_id)
		end

		return
	end

	local rpc

	if self._server_protocol == "STEAM" then
		rpc = Network:handshake(peer_user_id, nil, "STEAM")

		Network:add_co_client(rpc)
	end

	if IS_PC then
		-- block empty
	else
		peer_user_id = false
	end

	if IS_PC then
		name = managers.network.account:username_by_id(peer_user_id)
	end

	local id, peer = self:add_peer(name, rpc, in_lobby, loading, synched, peer_id, character, peer_user_id, xuid, nil)

	cat_print("multiplayer_base", "[ClientNetworkSession:peer_handshake]", name, peer_user_id, loading, synched, id, inspect(peer))

	local check_peer = IS_XB1 and peer or nil

	self:chk_send_connection_established(name, peer_user_id, check_peer)

	if managers.trade then
		managers.trade:handshake_complete(peer_id)
	end
end

function ClientNetworkSession:on_PSN_connection_established(name, ip)
	if not IS_PS4 then
		return
	end

	self:chk_send_connection_established(name, nil, false)
end

function ClientNetworkSession:on_peer_synched(peer_id)
	local peer = self._peers[peer_id]

	if not peer then
		cat_error("multiplayer_base", "[ClientNetworkSession:on_peer_synched] Unknown Peer:", peer_id)

		return
	end

	peer:set_loading(false)
	peer:set_synched(true)
	self:on_peer_sync_complete(peer, peer_id)
end

function ClientNetworkSession:ok_to_load_level(load_counter)
	print("[ClientNetworkSession:ok_to_load_level] load_counter", load_counter, "self._received_ok_to_load_level", self._received_ok_to_load_level)

	if self._closing then
		return
	end

	if self._received_ok_to_load_level then
		print("Allready recieved ok to load level, returns")

		return
	end

	if self._load_counter == load_counter then
		print("Allready loaded, returns")

		return
	end

	self._load_counter = load_counter
	self._received_ok_to_load_level = load_counter

	if managers.menu:active_menu() then
		managers.menu:close_menu()
	end

	managers.system_menu:force_close_all()

	local level_id = Global.game_settings.level_id
	local level_name = level_id and tweak_data.levels[level_id].world_name
	local mission = Global.game_settings.mission ~= "none" and Global.game_settings.mission or nil
	local world_setting = Global.game_settings.world_setting

	self:load_level(level_name, mission, world_setting, nil, level_id)
end

function ClientNetworkSession:ok_to_load_lobby(load_counter)
	print("[ClientNetworkSession:ok_to_load_lobby] load_counter", load_counter, "self._received_ok_to_load_lobby", self._received_ok_to_load_lobby, self._local_peer:id())

	if self._closing then
		return
	end

	if self:_local_peer_in_lobby() then
		return
	end

	if self._received_ok_to_load_lobby then
		print("Allready recieved ok to load lobby, returns")

		return
	end

	if self._load_counter == load_counter then
		print("Allready loaded, returns")

		return
	end

	self._load_counter = load_counter

	self:send_to_host("set_loading_state", true, self._load_counter)

	self._received_ok_to_load_lobby = load_counter

	if managers.menu:active_menu() then
		managers.menu:close_menu()
	end

	managers.system_menu:force_close_all()
	managers.network:session():load_lobby()
end

function ClientNetworkSession:on_mutual_connection(other_peer_id)
	local other_peer = self._peers[other_peer_id]

	if not other_peer then
		return
	end
end

function ClientNetworkSession:on_peer_requested_info(peer_id)
	local other_peer = self._peers[peer_id]

	if not other_peer then
		return
	end

	other_peer:set_ip_verified(true)
	self._local_peer:sync_lobby_data(other_peer)
	self._local_peer:sync_data(other_peer)
	Application:debug("[ClientNetworkSession:on_load_complete]", self._load_counter)
	other_peer:send("set_loading_state", self._local_peer:loading(), self._load_counter or 1)
	other_peer:send("peer_exchange_info", self._local_peer:id())
end

function ClientNetworkSession:update()
	ClientNetworkSession.super.update(self)

	if not self._closing then
		local wall_time = TimerManager:wall():time()

		if self._server_peer and self._host_sanity_send_t and wall_time > self._host_sanity_send_t then
			self._server_peer:send("sanity_check_network_status")

			self._host_sanity_send_t = wall_time + self.HOST_SANITY_CHECK_INTERVAL
		end

		self:_upd_request_join_resend(wall_time)

		if IS_XB1 then
			for peer_id, peer in pairs(self._peers) do
				if peer ~= self._server_peer and not peer:rpc() then
					self:chk_send_connection_established(peer:name(), peer:user_id(), peer)
				end
			end
		end
	end
end

function ClientNetworkSession:_soft_remove_peer(peer)
	ClientNetworkSession.super._soft_remove_peer(self, peer)

	if peer:id() == 1 then
		Network:set_disconnected()
	end
end

function ClientNetworkSession:on_peer_save_received(event, event_data)
	if managers.network:stopping() then
		return
	end

	local packet_index = event_data.index
	local total_nr_packets = event_data.total

	print("[ClientNetworkSession:on_peer_save_received]", packet_index, "/", total_nr_packets)

	if packet_index == total_nr_packets then
		self._local_peer:set_synched(true)
	end
end

function ClientNetworkSession:is_expecting_sanity_chk_reply()
	return self._host_sanity_send_t and true
end

function ClientNetworkSession:load(data)
	ClientNetworkSession.super.load(self, data)
end

function ClientNetworkSession:on_load_complete(simulation)
	Application:debug("[ClientNetworkSession:on_load_complete]", simulation)
	ClientNetworkSession.super.on_load_complete(self, simulation)

	if not simulation then
		self._host_sanity_send_t = TimerManager:wall():time() + self.HOST_SANITY_CHECK_INTERVAL
	end
end

function ClientNetworkSession:_get_join_attempt_identifier()
	if not self._join_attempt_identifier then
		self._join_attempt_identifier = math.random(1, 65536)
	end

	return self._join_attempt_identifier
end

function ClientNetworkSession:_upd_request_join_resend(wall_time)
	if self._last_join_request_t then
		if wall_time - self._first_join_request_t > ClientNetworkSession.JOIN_REQUEST_TIMEOUT and self._server_peer and self._cb_find_game then
			self._last_join_request_t = nil

			local cb = self._cb_find_game

			self._cb_find_game = nil

			self:remove_peer(self._server_peer, 1)
			cb("FAILED_CONNECT")

			return
		end

		if self._last_join_request_t and wall_time - self._last_join_request_t > ClientNetworkSession.HOST_REQUEST_JOIN_INTERVAL then
			self._join_request_params.host_rpc:request_join(unpack(self._join_request_params.params))

			self._last_join_request_t = wall_time
		end
	end
end

function ClientNetworkSession:chk_send_outfit_loading_status()
	print("[ClientNetworkSession:chk_send_outfit_loading_status]\n", inspect(self._notify_host_when_outfits_loaded), "\n", "self:_get_peer_outfit_versions_str()", self:_get_peer_outfit_versions_str())

	if self._notify_host_when_outfits_loaded and self._notify_host_when_outfits_loaded.outfit_versions_str == self:_get_peer_outfit_versions_str() and self:are_all_peer_assets_loaded() then
		print("answering to request")
		self:send_to_host("set_member_ready", self._local_peer:id(), self._notify_host_when_outfits_loaded.request_id, 3, self._notify_host_when_outfits_loaded.outfit_versions_str)

		self._notify_host_when_outfits_loaded = nil

		return true
	end
end

function ClientNetworkSession:notify_host_when_outfits_loaded(request_id, outfit_versions_str)
	print("[ClientNetworkSession:notify_host_when outfits_loaded] request_id", request_id)

	self._notify_host_when_outfits_loaded = {
		outfit_versions_str = outfit_versions_str,
		request_id = request_id,
	}

	self:chk_send_outfit_loading_status()
end

function ClientNetworkSession:on_peer_outfit_loaded(peer)
	ClientNetworkSession.super.on_peer_outfit_loaded(self, peer)
	self:_chk_send_proactive_outfit_loaded()
end

function ClientNetworkSession:_chk_send_proactive_outfit_loaded()
	if not self:server_peer() or not self:server_peer():ip_verified() or self:server_peer():id() == 0 or self._local_peer:id() == 0 then
		return
	end

	local sent = self:chk_send_outfit_loading_status()

	if not sent and self:are_all_peer_assets_loaded() then
		print("[ClientNetworkSession:_chk_send_proactive_outfit_loaded] sending outfit_ready proactively")
		self:send_to_host("set_member_ready", self._local_peer:id(), 0, 3, "proactive")
	end
end

function ClientNetworkSession:on_set_member_ready(peer_id, ready, state_changed, from_network)
	ClientNetworkSession.super.on_set_member_ready(self, peer_id, ready, state_changed, from_network)

	if from_network and ready then
		self:chk_send_outfit_loading_status()
	end
end

function ClientNetworkSession:remove_peer(...)
	ClientNetworkSession.super.remove_peer(self, ...)
	self:chk_send_outfit_loading_status()
end

function ClientNetworkSession:set_peer_loading_state(peer, state, load_counter)
	peer:set_loading(state)
	ClientNetworkSession.super.set_peer_loading_state(self, peer, state, load_counter)
end
