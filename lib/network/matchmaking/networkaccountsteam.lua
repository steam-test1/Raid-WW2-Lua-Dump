require("lib/network/matchmaking/NetworkAccount")

NetworkAccountSTEAM = NetworkAccountSTEAM or class(NetworkAccount)

function NetworkAccountSTEAM:init()
	NetworkAccount.init(self)

	self._listener_holder = EventListenerHolder:new()

	Steam:init()
	Steam:request_listener(NetworkAccountSTEAM._on_join_request, NetworkAccountSTEAM._on_server_request)
	Steam:error_listener(NetworkAccountSTEAM._on_disconnected, NetworkAccountSTEAM._on_ipc_fail, NetworkAccountSTEAM._on_connect_fail)
	Steam:overlay_listener(callback(self, self, "_on_open_overlay"), callback(self, self, "_on_close_overlay"))

	self._gamepad_text_listeners = {}

	if Steam:overlay_open() then
		self:_on_open_overlay()
	end

	Steam:sa_handler():stats_store_callback(NetworkAccountSTEAM._on_stats_stored)
	Steam:sa_handler():init()
	self:_set_presences()
	managers.savefile:add_load_done_callback(callback(self, self, "_load_done"))
	Steam:lb_handler():register_storage_done_callback(NetworkAccountSTEAM._on_leaderboard_stored)
	Steam:lb_handler():register_mappings_done_callback(NetworkAccountSTEAM._on_leaderboard_mapped)
	self:inventory_load()
end

function NetworkAccountSTEAM:_load_done(...)
	print("NetworkAccountSTEAM:_load_done()", ...)
	self:_set_presences()
end

function NetworkAccountSTEAM:update()
	self:_chk_inventory_outfit_refresh()
end

function NetworkAccountSTEAM:_set_presences()
	Steam:set_rich_presence("level", managers.experience:current_level())
end

function NetworkAccountSTEAM:set_presences_peer_id(peer_id)
	Steam:set_rich_presence("peer_id", peer_id)
end

function NetworkAccountSTEAM:_call_listeners(event, params)
	if self._listener_holder then
		self._listener_holder:call(event, params)
	end
end

function NetworkAccountSTEAM:add_overlay_listener(key, events, clbk)
	self._listener_holder:add(key, events, clbk)
end

function NetworkAccountSTEAM:remove_overlay_listener(key)
	self._listener_holder:remove(key)
end

function NetworkAccountSTEAM:_on_open_overlay()
	if self._overlay_opened then
		return
	end

	self._overlay_opened = true

	self:_call_listeners("overlay_open")
	game_state_machine:_set_controller_enabled(false)
end

function NetworkAccountSTEAM:_on_close_overlay()
	if not self._overlay_opened then
		return
	end

	self._overlay_opened = false

	self:_call_listeners("overlay_close")

	if not managers.raid_menu:is_any_menu_open() then
		game_state_machine:_set_controller_enabled(true)
	end

	managers.dlc:chk_content_updated()
end

function NetworkAccountSTEAM:_on_gamepad_text_submitted(submitted, submitted_text)
	print("[NetworkAccountSTEAM:_on_gamepad_text_submitted]", "submitted", submitted, "submitted_text", submitted_text)

	for id, clbk in pairs(self._gamepad_text_listeners) do
		clbk(submitted, submitted_text)
	end

	self._gamepad_text_listeners = {}
end

function NetworkAccountSTEAM:show_gamepad_text_input(id, callback, params)
	return false
end

function NetworkAccountSTEAM:add_gamepad_text_listener(id, clbk)
	if self._gamepad_text_listeners[id] then
		debug_pause("[NetworkAccountSTEAM:add_gamepad_text_listener] ID already added!", id, "Old Clbk", self._gamepad_text_listeners[id], "New Clbk", clbk)
	end

	self._gamepad_text_listeners[id] = clbk
end

function NetworkAccountSTEAM:remove_gamepad_text_listener(id)
	if not self._gamepad_text_listeners[id] then
		debug_pause("[NetworkAccountSTEAM:remove_gamepad_text_listener] ID do not exist!", id)
	end

	self._gamepad_text_listeners[id] = nil
end

function NetworkAccountSTEAM:achievements_fetched()
	self._achievements_fetched = true
end

function NetworkAccountSTEAM:challenges_loaded()
	self._challenges_loaded = true
end

function NetworkAccountSTEAM:experience_loaded()
	self._experience_loaded = true
end

function NetworkAccountSTEAM._on_leaderboard_stored(status)
	print("[NetworkAccountSTEAM:_on_leaderboard_stored] Leaderboard stored, ", status, ".")
end

function NetworkAccountSTEAM._on_leaderboard_mapped()
	print("[NetworkAccountSTEAM:_on_leaderboard_stored] Leaderboard mapped.")
	Steam:lb_handler():request_storage()
end

function NetworkAccountSTEAM._on_stats_stored(status)
	print("[NetworkAccountSTEAM:_on_stats_stored] Statistics stored, ", status, ". Publishing leaderboard score to Steam!")
end

function NetworkAccountSTEAM:get_stat(key)
	return Steam:sa_handler():get_stat(key)
end

function NetworkAccountSTEAM:get_lifetime_stat(key)
	return Steam:sa_handler():get_lifetime_stat(key)
end

function NetworkAccountSTEAM:get_global_stat(key, days)
	local value = 0
	local global_stat

	if days and days < 0 then
		local day = math.abs(days) + 1

		global_stat = Steam:sa_handler():get_global_stat(key, day)

		return global_stat[day] or 0
	elseif days then
		global_stat = Steam:sa_handler():get_global_stat(key, days == 1 and 1 or days + 1)

		for i = days > 1 and 2 or 1, #global_stat do
			local day = global_stat[i]

			if day > -2000000000 then
				value = value + day
			end
		end
	else
		global_stat = Steam:sa_handler():get_global_stat(key)

		for _, day in ipairs(global_stat) do
			if day > -2000000000 then
				value = value + day
			end
		end
	end

	return value
end

function NetworkAccountSTEAM:publish_statistics(stats, force_store)
	if managers.dlc:is_trial() then
		return
	end

	local handler = Steam:sa_handler()
	local err = false

	for key, stat in pairs(stats) do
		local res

		if stat.type == "int" then
			local val = math.max(0, handler:get_stat(key))

			if stat.method == "lowest" then
				if val > stat.value then
					res = handler:set_stat(key, stat.value)
				else
					res = true
				end
			elseif stat.method == "highest" then
				if val < stat.value then
					res = handler:set_stat(key, stat.value)
				else
					res = true
				end
			elseif stat.method == "set" then
				res = handler:set_stat(key, math.clamp(stat.value, 0, 2147483000))
			elseif stat.value > 0 then
				local mval = val / 1000 + stat.value / 1000

				if mval >= 2147483 then
					res = handler:set_stat(key, 2147483000)
				else
					res = handler:set_stat(key, val + stat.value)
				end
			else
				res = true
			end
		elseif stat.type == "float" then
			if stat.value > 0 then
				local val = handler:get_stat_float(key)

				res = handler:set_stat_float(key, val + stat.value)
			else
				res = true
			end
		elseif stat.type == "avgrate" then
			res = handler:set_stat_float(key, stat.value, stat.hours)
		end

		if not res then
			Application:error("[NetworkAccountSTEAM:publish_statistics] Error, could not set stat " .. key)

			err = true
		end
	end

	if not err then
		handler:store_data()
	end
end

function NetworkAccountSTEAM._on_disconnected(lobby_id, friend_id)
	Application:info("[NetworkAccountSTEAM._on_disconnected] LobbyID", lobby_id, "FriendID", friend_id)

	if Application:editor() then
		return
	end

	if Network:is_server() then
		managers.raid_menu:show_dialog_disconnected_from_steam()

		Global.game_settings.single_player = true

		if managers.network.matchmake.lobby_handler then
			managers.network.matchmake.lobby_handler:leave_lobby()
		end
	end

	Application:warn("Disconnected from Steam!! Please wait", 12)
end

function NetworkAccountSTEAM._on_ipc_fail(lobby_id, friend_id)
	Application:warn("[NetworkAccountSTEAM._on_ipc_fail]")
end

function NetworkAccountSTEAM._on_join_request(lobby_id, friend_id)
	Application:trace("[NetworkAccountSTEAM._on_join_request]")

	if managers.savefile:get_active_characters_count() < 1 then
		managers.raid_menu:show_dialog_join_others_forbidden()

		return
	end

	if managers.network.matchmake.lobby_handler and managers.network.matchmake.lobby_handler:id() == lobby_id then
		return
	end

	if managers.network:session() and managers.network:session():has_other_peers() then
		managers.raid_menu:show_dialog_already_in_game()

		return
	end

	if managers.raid_job and managers.raid_job:is_in_tutorial() then
		managers.menu:show_ok_only_dialog("dialog_warning_title", "dialog_err_cant_join_from_game")

		return
	end

	if managers.raid_job and not managers.raid_job:played_tutorial() then
		managers.menu:show_ok_only_dialog("dialog_warning_title", "dialog_err_tutorial_not_finished")

		return
	end

	if game_state_machine:current_state_name() ~= "menu_main" then
		Application:trace("[NetworkAccountSTEAM._on_join_request] INGAME INVITE")

		if managers.groupai then
			managers.groupai:kill_all_AI()
		end

		Global.game_settings.single_player = false
		Global.boot_invite = lobby_id

		MenuCallbackHandler:_dialog_end_game_yes()

		return
	else
		if not Global.user_manager.user_index or not Global.user_manager.active_user_state_change_quit then
			Application:trace("[NetworkAccountSTEAM._on_join_request] BOOT UP INVITE")

			Global.boot_invite = lobby_id

			return
		end

		Global.game_settings.single_player = false

		managers.network.matchmake:join_server_with_check(lobby_id, true)
	end
end

function NetworkAccountSTEAM._on_server_request(ip, pw)
	Application:trace("[NetworkAccountSTEAM._on_server_request]", ip, pw)
end

function NetworkAccountSTEAM._on_connect_fail(ip, pw)
	Application:warn("[NetworkAccountSTEAM._on_connect_fail]", ip, pw)
end

function NetworkAccountSTEAM:signin_state()
	if self:local_signin_state() == true then
		return "signed in"
	end

	return "not signed in"
end

function NetworkAccountSTEAM:local_signin_state()
	return Steam:logged_on()
end

function NetworkAccountSTEAM:username_id()
	return Steam:username()
end

function NetworkAccountSTEAM:username_by_id(id)
	return Steam:username(id)
end

function NetworkAccountSTEAM:player_id()
	return Steam:userid()
end

function NetworkAccountSTEAM:is_connected()
	return true
end

function NetworkAccountSTEAM:lan_connection()
	return true
end

function NetworkAccountSTEAM:set_playing(state)
	Steam:set_playing(state)
end

function NetworkAccountSTEAM:_load_globals()
	if Global.steam and Global.steam.account then
		self._outfit_signature = Global.steam.account.outfit_signature and Global.steam.account.outfit_signature:get_data()

		if Global.steam.account.outfit_signature then
			Global.steam.account.outfit_signature:destroy()
		end

		Global.steam.account = nil
	end
end

function NetworkAccountSTEAM:_save_globals()
	Global.steam = Global.steam or {}
	Global.steam.account = {}
	Global.steam.account.outfit_signature = self._outfit_signature and Application:create_luabuffer(self._outfit_signature)
end

function NetworkAccountSTEAM:is_ready_to_close()
	return not self._inventory_is_loading and not self._inventory_outfit_refresh_requested and not self._inventory_outfit_refresh_in_progress
end

function NetworkAccountSTEAM:inventory_load(callback_ref)
	Application:info("[NetworkAccountSTEAM:inventory_load] Inventory Loading: ", self._inventory_is_loading)

	if self._inventory_is_loading then
		return
	end

	if managers.raid_menu:is_offline_mode() then
		self:_clbk_inventory_load(nil, {})

		return
	end

	if callback_ref then
		Steam:inventory_load(callback_ref)
	else
		Steam:inventory_load(callback(self, self, "_clbk_inventory_load"))
	end
end

function NetworkAccountSTEAM:_clbk_inventory_load(error, list)
	self._inventory_is_loading = nil

	if error then
		Application:error("[NetworkAccountSTEAM:_clbk_inventory_load] Failed to update tradable inventory (" .. tostring(error) .. ")")
	end

	local filtered_cards = self:_verify_filter_cards(list)

	managers.system_event_listener:call_listeners(CoreSystemEventListenerManager.SystemEventListenerManager.EVENT_STEAM_INVENTORY_LOADED, {
		cards = filtered_cards,
		error = error,
	})
end

function NetworkAccountSTEAM:_verify_filter_cards(card_list)
	local filtered_list = {}
	local result = {}

	if card_list then
		for _, cc_steamdata in pairs(card_list) do
			if cc_steamdata.category == ChallengeCardsManager.INV_CAT_CHALCARD then
				local cc_tweakdata = managers.challenge_cards:get_challenge_card_data(cc_steamdata.entry)

				if cc_tweakdata then
					if not filtered_list[cc_tweakdata.key_name] then
						filtered_list[cc_tweakdata.key_name] = cc_tweakdata
						filtered_list[cc_tweakdata.key_name].steam_instances = {}
					end

					local instance_id = cc_steamdata.instance_id or #filtered_list[cc_tweakdata.key_name].steam_instances

					table.insert(filtered_list[cc_tweakdata.key_name].steam_instances, {
						instance_id = tostring(instance_id),
						stack_amount = cc_steamdata.amount or 1,
					})
				end
			end
		end
	end

	if filtered_list then
		for card_key_name, card_data in pairs(filtered_list) do
			table.insert(result, card_data)
		end
	end

	return result
end

function NetworkAccountSTEAM:inventory_is_loading()
	return self._inventory_is_loading
end

function NetworkAccountSTEAM:inventory_reward(item_def_id, callback_ref)
	item_def_id = item_def_id or 1

	Application:debug("[NetworkAccountSTEAM:inventory_reward] item_def_id:", item_def_id)

	if callback_ref then
		Steam:inventory_reward(callback_ref, item_def_id)
	else
		Steam:inventory_reward(callback(self, self, "_clbk_inventory_reward"), item_def_id)
	end

	return true
end

function NetworkAccountSTEAM:_clbk_inventory_reward(error, tradable_list)
	Application:trace("[NetworkAccountSTEAM:_clbk_inventory_reward] Dummy fallback")
	Application:trace("\t-error ", inspect(error))
	Application:trace("\t-tradable_list ", inspect(tradable_list))
end

function NetworkAccountSTEAM:inventory_remove(instance_id)
	local status = Steam:inventory_remove(instance_id)

	Application:trace("[NetworkAccountSTEAM:inventory_remove] instance_id ", instance_id, ", status", status)

	return true
end

function NetworkAccountSTEAM:inventory_reward_dlc(def_id, reward_promo_callback)
	return
end

function NetworkAccountSTEAM:inventory_outfit_refresh()
	self._inventory_outfit_refresh_requested = true
end

function NetworkAccountSTEAM:_inventory_outfit_refresh()
	local outfit = managers.blackmarket:tradable_outfit()

	print("[NetworkAccountSTEAM:_inventory_outfit_refresh]", "outfit: ", inspect(outfit))

	if table.size(outfit) > 0 then
		self._outfit_signature = nil
		self._inventory_outfit_refresh_in_progress = true

		Steam:inventory_signature_create(outfit, callback(self, self, "_clbk_tradable_outfit_data"))
	else
		self._outfit_signature = ""

		managers.network:session():check_send_outfit()
	end
end

function NetworkAccountSTEAM:_chk_inventory_outfit_refresh()
	if not self._inventory_outfit_refresh_requested then
		return
	end

	if self._inventory_outfit_refresh_in_progress then
		return
	end

	self._inventory_outfit_refresh_requested = nil

	self:_inventory_outfit_refresh()
end

function NetworkAccountSTEAM:inventory_outfit_verify(steam_id, outfit_data, outfit_callback)
	if outfit_data == "" then
		return outfit_callback and outfit_callback(nil, false, {})
	end

	Steam:inventory_signature_verify(steam_id, outfit_data, outfit_callback)
end

function NetworkAccountSTEAM:inventory_outfit_signature()
	return self._outfit_signature
end

function NetworkAccountSTEAM:inventory_repair_list(list)
	return
end

function NetworkAccountSTEAM:_clbk_tradable_outfit_data(error, outfit_signature)
	print("[NetworkAccountSTEAM:_clbk_tradable_outfit_data] error: ", error, ", self._outfit_signature: ", self._outfit_signature, "\n outfit_signature: ", outfit_signature, "\n")

	self._inventory_outfit_refresh_in_progress = nil

	if self._inventory_outfit_refresh_requested then
		return
	end

	if error then
		Application:error("[NetworkAccountSTEAM:_clbk_tradable_outfit_data] Failed to check tradable inventory (" .. tostring(error) .. ")")
	end

	self._outfit_signature = outfit_signature

	if managers.network:session() then
		managers.network:session():check_send_outfit()
	end
end
