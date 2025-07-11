MenuCallbackHandler = MenuCallbackHandler or class(CoreMenuCallbackHandler.CallbackHandler)

function MenuCallbackHandler:init()
	MenuCallbackHandler.super.init(self)
end

function MenuCallbackHandler:trial_buy()
	print("[MenuCallbackHandler:trial_buy]")
	managers.dlc:buy_full_game()
end

function MenuCallbackHandler:dlc_buy_pc()
	print("[MenuCallbackHandler:dlc_buy_pc]")
	Steam:overlay_activate("store", managers.dlc:get_app_id())
end

function MenuCallbackHandler:has_full_game()
	return managers.dlc:has_full_game()
end

function MenuCallbackHandler:is_trial()
	return managers.dlc:is_trial()
end

function MenuCallbackHandler:is_not_trial()
	return not self:is_trial()
end

function MenuCallbackHandler:has_preorder()
	return managers.dlc:has_preorder()
end

function MenuCallbackHandler:not_has_preorder()
	return not managers.dlc:has_preorder()
end

function MenuCallbackHandler:has_all_dlcs()
	return true
end

function MenuCallbackHandler:is_overlay_enabled()
	return IS_PC and Steam:overlay_enabled() or false
end

function MenuCallbackHandler:_on_host_setting_updated()
	return
end

function MenuCallbackHandler:is_dlc_latest_locked(check_dlc)
	local dlcs = {}
	local dlc_tweak_data = tweak_data.dlc

	for _, dlc in ipairs(dlcs) do
		if dlc_tweak_data[dlc] then
			local dlc_func = dlc_tweak_data[dlc].dlc

			if dlc_tweak_data[dlc].free then
				return false
			elseif dlc_func then
				if not managers.dlc[dlc_func](managers.dlc, dlc_tweak_data[dlc]) then
					return dlc == check_dlc
				end
			else
				Application:error("[MenuCallbackHandler:is_dlc_lastest_locked] DLC do not have a dlc check function tweak_data_dlc.dlc", dlc)
			end

			if dlc == check_dlc then
				break
			end
		else
			Application:error("[MenuCallbackHandler:is_dlc_lastest_locked] DLC do not exist in dlc tweak data", dlc)
		end
	end

	return false
end

function MenuCallbackHandler:not_has_all_dlcs()
	return not self:has_all_dlcs()
end

function MenuCallbackHandler:reputation_check(data)
	return managers.experience:current_level() >= data:value()
end

function MenuCallbackHandler:is_win32()
	return IS_PC
end

function MenuCallbackHandler:is_fullscreen()
	return managers.viewport:is_fullscreen()
end

function MenuCallbackHandler:voice_enabled()
	return IS_PC and managers.network and managers.network.voice_chat and managers.network.voice_chat:enabled()
end

function MenuCallbackHandler:customize_controller_enabled()
	return true
end

function MenuCallbackHandler:is_ps4()
	return IS_PS4
end

function MenuCallbackHandler:is_xb1()
	return IS_XB1
end

function MenuCallbackHandler:is_server()
	return Network:is_server()
end

function MenuCallbackHandler:is_not_server()
	return not self:is_server()
end

function MenuCallbackHandler:is_online()
	return managers.network.account:signin_state() == "signed in"
end

function MenuCallbackHandler:is_singleplayer()
	return Global.game_settings.single_player
end

function MenuCallbackHandler:is_multiplayer()
	return not Global.game_settings.single_player
end

function MenuCallbackHandler:is_not_max_rank()
	return managers.experience:current_rank() < #tweak_data.infamy.ranks
end

function MenuCallbackHandler:singleplayer_restart()
	return self:is_singleplayer() and self:has_full_game()
end

function MenuCallbackHandler:kick_player_visible()
	return self:is_server() and self:is_multiplayer() and managers.platform:presence() ~= "Mission_end" and managers.vote:option_host_kick()
end

function MenuCallbackHandler:kick_vote_visible()
	return self:is_multiplayer() and managers.platform:presence() ~= "Mission_end" and managers.vote:option_vote_kick()
end

function MenuCallbackHandler:_restart_level_visible()
	if not self:is_multiplayer() or managers.raid_job:is_camp_loaded() then
		return false
	end

	local state = game_state_machine:current_state_name()

	return state ~= "ingame_waiting_for_players" and state ~= "ingame_lobby_menu" and state ~= "empty"
end

function MenuCallbackHandler:restart_level_visible()
	return self:is_server() and self:_restart_level_visible() and managers.vote:option_host_restart()
end

function MenuCallbackHandler:restart_vote_visible()
	return self:_restart_level_visible() and managers.vote:option_vote_restart()
end

function MenuCallbackHandler:lobby_exist()
	return managers.network.matchmake.lobby_handler
end

function MenuCallbackHandler:hidden()
	return false
end

function MenuCallbackHandler:is_pc_controller()
	return managers.menu:is_pc_controller()
end

function MenuCallbackHandler:is_not_pc_controller()
	return not self:is_pc_controller()
end

function MenuCallbackHandler:is_not_editor()
	return not Application:editor()
end

function MenuCallbackHandler:show_credits()
	game_state_machine:change_state_by_name("menu_credits")
end

function MenuCallbackHandler:can_load_game()
	return not Application:editor() and not Network:multiplayer()
end

function MenuCallbackHandler:can_save_game()
	return not Application:editor() and not Network:multiplayer()
end

function MenuCallbackHandler:is_not_multiplayer()
	return not Network:multiplayer()
end

function MenuCallbackHandler:debug_menu_enabled()
	return managers.menu:debug_menu_enabled()
end

function MenuCallbackHandler:leave_online_menu()
	managers.menu:leave_online_menu()
end

function MenuCallbackHandler:on_menu_option_help()
	print("MenuCallbackHandler:on_menu_option_help()")
	XboxLive:show_help_ui()
end

function MenuCallbackHandler:quit_game()
	local dialog_data = {}

	dialog_data.title = managers.localization:text("dialog_warning_title")
	dialog_data.text = managers.localization:text("dialog_are_you_sure_you_want_to_quit")

	local yes_button = {}

	yes_button.text = managers.localization:text("dialog_yes")
	yes_button.callback_func = callback(self, self, "_dialog_quit_yes")

	local no_button = {}

	no_button.text = managers.localization:text("dialog_no")
	no_button.callback_func = callback(self, self, "_dialog_quit_no")
	no_button.class = RaidGUIControlButtonShortSecondary
	no_button.cancel_button = true
	dialog_data.button_list = {
		yes_button,
		no_button,
	}

	managers.system_menu:show(dialog_data)
end

function MenuCallbackHandler:_dialog_quit_yes()
	self:_dialog_save_progress_backup_no()
end

function MenuCallbackHandler:_dialog_quit_no()
	return
end

function MenuCallbackHandler:_dialog_save_progress_backup_yes()
	setup:quit()
end

function MenuCallbackHandler:_dialog_save_progress_backup_no()
	setup:quit()
end

function MenuCallbackHandler:chk_dlc_content_updated()
	if managers.dlc then
		managers.dlc:chk_content_updated()
	end
end

function MenuCallbackHandler:toggle_ready(item)
	local ready = item:value() == "on"

	if not managers.network:session() then
		return
	end

	managers.network:session():local_peer():set_waiting_for_player_ready(ready)
	managers.network:session():chk_send_local_player_ready()

	if managers.menu:active_menu() and managers.menu:active_menu().renderer and managers.menu:active_menu().renderer.set_ready_items_enabled then
		managers.menu:active_menu().renderer:set_ready_items_enabled(not ready)
	end

	managers.network:session():on_set_member_ready(managers.network:session():local_peer():id(), ready, true, false)
end

function MenuCallbackHandler:invert_camera_horisontally(item)
	local invert = item:value() == "on"

	managers.user:set_setting("invert_camera_x", invert)
end

function MenuCallbackHandler:invert_camera_vertically(item)
	local invert = item:value() == "on"

	managers.user:set_setting("invert_camera_y", invert)
end

function MenuCallbackHandler:choice_job_id_filter(item)
	local job_id_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("job_id") == job_id_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("job_id", job_id_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
end

function MenuCallbackHandler:choice_new_servers_only(item)
	local num_players_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("num_players") == num_players_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("num_players", num_players_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
end

function MenuCallbackHandler:choice_kick_option(item)
	local kicking_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("kick_option") == kicking_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("kick_option", kicking_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
end

function MenuCallbackHandler:choice_job_appropriate_filter(item)
	local diff_appropriate = item:value()

	Global.game_settings.search_appropriate_jobs = diff_appropriate == "on" and true or false

	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
end

function MenuCallbackHandler:choice_server_state_lobby(item)
	local state_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("state") == state_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("state", state_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
end

function MenuCallbackHandler:refresh_node(item)
	local logic = managers.menu:active_menu().logic

	if logic then
		logic:refresh_node()
	end
end

function MenuCallbackHandler:set_lan_game()
	Global.game_settings.playing_lan = true
end

function MenuCallbackHandler:set_not_lan_game()
	Global.game_settings.playing_lan = nil
end

function MenuCallbackHandler:create_lobby()
	managers.network.matchmake:create_lobby(managers.network:get_matchmake_attributes())
end

function MenuCallbackHandler:play_single_player()
	Global.game_settings.single_player = true

	managers.network:host_game()
	Network:set_server()
end

function MenuCallbackHandler:apply_and_save_render_settings()
	local function func()
		Application:apply_render_settings()
		Application:save_render_settings()
	end

	local fullscreen_ws = managers.menu_component and managers.menu_component._fullscreen_ws

	if game_state_machine:current_state()._name ~= "menu_main" and alive(fullscreen_ws) then
		local black_overlay = fullscreen_ws:panel():panel({
			layer = tweak_data.gui.MOUSE_LAYER - 1,
			name = "apply_render_settings_panel",
		})

		black_overlay:rect({
			color = Color.black,
		})
		black_overlay:animate(function(o)
			coroutine.yield()
			func()
			over(0.05, function(p)
				black_overlay:set_alpha(1 - p)
			end)
			fullscreen_ws:panel():remove(black_overlay)
		end)
	else
		func()
	end
end

function MenuCallbackHandler:on_stage_success()
	managers.mission:on_stage_success()
end

function MenuCallbackHandler:lobby_start_the_game()
	MenuCallbackHandler:start_the_game()
end

function MenuCallbackHandler:leave_lobby()
	if game_state_machine:current_state_name() == "ingame_lobby_menu" then
		self:end_game()

		return
	end

	local dialog_data = {}

	dialog_data.title = managers.localization:text("dialog_warning_title")
	dialog_data.text = managers.localization:text("dialog_are_you_sure_you_want_leave")
	dialog_data.id = "leave_lobby"

	local yes_button = {}

	yes_button.text = managers.localization:text("dialog_yes")
	yes_button.callback_func = callback(self, self, "_dialog_leave_lobby_yes")

	local no_button = {}

	no_button.text = managers.localization:text("dialog_no")
	no_button.callback_func = callback(self, self, "_dialog_leave_lobby_no")
	no_button.class = RaidGUIControlButtonShortSecondary
	no_button.cancel_button = true
	dialog_data.button_list = {
		yes_button,
		no_button,
	}

	managers.system_menu:show(dialog_data)

	return true
end

function MenuCallbackHandler:_dialog_leave_lobby_yes()
	if managers.network:session() then
		managers.network:session():local_peer():set_in_lobby(false)
		managers.network:session():send_to_peers("set_peer_left")
	end

	managers.menu:on_leave_lobby()
end

function MenuCallbackHandler:_dialog_leave_lobby_no()
	return
end

function MenuCallbackHandler:connect_to_host_rpc(item)
	local function f(res)
		if res == "JOINED_LOBBY" then
			self:on_enter_lobby()
		elseif res == "JOINED_GAME" then
			local level_id = tweak_data.levels:get_level_id_from_world_name(item:parameters().level_name)

			managers.network:session():load_level(item:parameters().level_name, nil, nil, nil, level_id, nil)
		elseif res == "KICKED" then
			managers.menu:show_peer_kicked_dialog()
		else
			Application:error("[MenuCallbackHandler:connect_to_host_rpc] FAILED TO START MULTIPLAYER!")
		end
	end

	managers.network:join_game_at_host_rpc(item:parameters().rpc, f)
end

function MenuCallbackHandler:host_multiplayer(item)
	managers.network:host_game()

	local level_id = item:parameters().level_id
	local level_name = level_id and tweak_data.levels[level_id].world_name

	level_id = level_id or tweak_data.levels:get_level_id_from_world_name(item:parameters().level)
	level_name = level_name or item:parameters().level or "bank"
	Global.game_settings.level_id = level_id

	managers.network:session():load_level(level_name, nil, nil, nil, level_id)
end

function MenuCallbackHandler:join_multiplayer()
	local function f(new_host_rpc)
		if new_host_rpc then
			managers.menu:active_menu().logic:refresh_node("select_host")
		end
	end

	managers.network:discover_hosts(f)
end

function MenuCallbackHandler:find_lan_games()
	if self:is_win32() then
		local function f(new_host_rpc)
			if new_host_rpc then
				managers.menu:active_menu().logic:refresh_node("play_lan")
			end
		end

		managers.network:discover_hosts(f)
	end
end

function MenuCallbackHandler:find_online_games_with_friends()
	self:_find_online_games(true)
end

function MenuCallbackHandler:find_online_games()
	self:_find_online_games()
end

function MenuCallbackHandler:_find_online_games(friends_only)
	if self:is_win32() then
		local function f(info)
			print("info in function")
			print(inspect(info))
			managers.network.matchmake:search_lobby_done()
			managers.menu:active_menu().logic:refresh_node("play_online", true, info, friends_only)
		end

		managers.network.matchmake:register_callback("search_lobby", f)
		managers.network.matchmake:search_lobby(friends_only)

		local function usrs_f(success, amount)
			print("usrs_f", success, amount)

			if success then
				local stack = managers.menu:active_menu().renderer._node_gui_stack
				local node_gui = stack[#stack]

				if node_gui.set_mini_info then
					node_gui:set_mini_info(managers.localization:text("menu_players_online", {
						COUNT = amount,
					}))
				end
			end
		end

		Steam:sa_handler():concurrent_users_callback(usrs_f)
		Steam:sa_handler():get_concurrent_users()
	end

	if self:is_ps3() or self:is_ps4() then
		if #PSN:get_world_list() == 0 then
			return
		end

		local function f(info_list)
			print("info_list in function")
			print(inspect(info_list))
			managers.network.matchmake:search_lobby_done()
			managers.menu:active_menu().logic:refresh_node("play_online", true, info_list, friends_only)
		end

		managers.network.matchmake:register_callback("search_lobby", f)
		managers.network.matchmake:start_search_lobbys(friends_only)
	end
end

function MenuCallbackHandler:connect_to_lobby(item)
	managers.network.matchmake:join_server_with_check(item:parameters().room_id)
end

function MenuCallbackHandler:stop_multiplayer()
	Application:debug("[MenuCallbackHandler:stop_multiplayer()]")

	Global.game_settings.single_player = false

	if managers.network:session() and managers.network:session():local_peer():id() == 1 then
		managers.network:stop_network(true)
	end
end

function MenuCallbackHandler:invite_friends()
	if managers.network.matchmake.lobby_handler then
		if MenuCallbackHandler:is_overlay_enabled() then
			Steam:overlay_activate("invite", managers.network.matchmake.lobby_handler:id())
		else
			managers.menu:show_enable_steam_overlay()
		end
	end
end

function MenuCallbackHandler:invite_friend(item)
	if item:parameters().signin_status ~= "signed_in" then
		return
	end

	managers.network.matchmake:send_join_invite(item:parameters().friend)
end

function MenuCallbackHandler:invite_friends_XB1()
	local platform_id = managers.user:get_platform_id()

	XboxLive:invite_friends_ui(platform_id, managers.network.matchmake._session)
end

function MenuCallbackHandler:invite_xbox_live_party()
	local platform_id = managers.user:get_platform_id()

	XboxLive:show_party_ui(platform_id)
end

function MenuCallbackHandler:invite_friends_ps4()
	PSN:invite_friends()
end

function MenuCallbackHandler:view_invites()
	print("View invites")
	print(PSN:display_message_invitation())
end

function MenuCallbackHandler:kick_player(item)
	if managers.vote:is_restarting() then
		Application:debug("[MenuCallbackHandler:kick_player] No kick during restart.")

		return
	end

	if managers.vote:option_host_kick() then
		managers.vote:message_host_kick(item:parameters().peer)
	elseif managers.vote:option_vote_kick() then
		managers.vote:kick(item:parameters().peer:id())
	end
end

function MenuCallbackHandler:mute_player(item)
	if managers.network.voice_chat then
		managers.network.voice_chat:mute_player(item:parameters().peer, item:value() == "on")
		item:parameters().peer:set_muted(item:value() == "on")
	end
end

function MenuCallbackHandler:mute_xbox_player(item)
	if managers.network.voice_chat then
		managers.network.voice_chat:set_muted(item:parameters().xuid, item:value() == "on")
		item:parameters().peer:set_muted(item:value() == "on")
	end
end

function MenuCallbackHandler:mute_xb1_player(item)
	if managers.network.voice_chat then
		managers.network.voice_chat:set_muted(item:parameters().xuid, item:value() == "on")
		item:parameters().peer:set_muted(item:value() == "on")
	end
end

function MenuCallbackHandler:mute_ps4_player(item)
	if managers.network.voice_chat then
		managers.network.voice_chat:mute_player(item:parameters().peer, item:value() == "on")
		item:parameters().peer:set_muted(item:value() == "on")
	end
end

function MenuCallbackHandler:restart_mission(item)
	if not managers.vote:available() or managers.vote:is_restarting() then
		return
	end

	local dialog_data = {}

	dialog_data.title = managers.localization:text("dialog_mp_restart_mission_title")
	dialog_data.text = managers.localization:text(managers.vote:option_vote_restart() and "dialog_mp_restart_level_message" or "dialog_mp_restart_level_host_message")

	local yes_button = {}

	yes_button.text = managers.localization:text("dialog_yes")

	function yes_button.callback_func()
		if managers.vote:option_vote_restart() then
			managers.vote:restart()
		else
			managers.vote:restart_auto()
		end
	end

	local no_button = {}

	no_button.text = managers.localization:text("dialog_no")
	no_button.class = RaidGUIControlButtonShortSecondary
	no_button.cancel_button = true
	dialog_data.button_list = {
		yes_button,
		no_button,
	}

	managers.system_menu:show(dialog_data)
end

function MenuCallbackHandler:view_gamer_card(item)
	XboxLive:show_gamer_card_ui(managers.user:get_platform_id(), item:parameters().xuid)
end

function MenuCallbackHandler:save_settings()
	managers.savefile:save_setting(true)
end

function MenuCallbackHandler:save_progress()
	managers.savefile:save_progress()
end

function MenuCallbackHandler:save_game(item)
	if not managers.savefile:is_active() then
		local param_map = item:parameters()

		managers.savefile:save_game(param_map.slot, false)

		if managers.savefile:is_active() then
			managers.menu:set_save_game_callback(callback(self, self, "save_game_callback"))
		else
			self:save_game_callback()
		end
	end
end

function MenuCallbackHandler:save_game_callback()
	managers.menu:set_save_game_callback(nil)
	managers.menu:back()
end

function MenuCallbackHandler:start_the_game()
	managers.worldcollection.level_transition_in_progress = true

	local level_id = Global.game_settings.level_id
	local level_name = level_id and tweak_data.levels[level_id].world_name

	if Global.boot_invite then
		Global.boot_invite.used = true
		Global.boot_invite.pending = false
	end

	if Global.boot_play_together then
		Global.boot_play_together.used = true
		Global.boot_play_together.pending = false
	end

	local mission = Global.game_settings.mission ~= "none" and Global.game_settings.mission or nil
	local world_setting = Global.game_settings.world_setting

	managers.network:session():load_level(level_name, mission, world_setting, nil, level_id)
end

function MenuCallbackHandler:singleplayer_restart_game_to_camp(item)
	managers.menu:show_restart_game_dialog({
		yes_func = function()
			managers.game_play_central:restart_the_game()
		end,
	})
end

function MenuCallbackHandler:singleplayer_restart_mission(item)
	managers.menu:show_restart_game_dialog({
		yes_func = function()
			managers.game_play_central:restart_the_game()
		end,
	})
end

function MenuCallbackHandler:always_hide()
	return false
end

function MenuCallbackHandler:_refresh_brightness()
	managers.user:set_setting("brightness", managers.user:get_setting("brightness"), true)
end

function MenuCallbackHandler:end_game()
	print(" MenuCallbackHandler:end_game() ")

	local dialog_data = {}

	dialog_data.title = managers.localization:text("dialog_warning_title")
	dialog_data.text = managers.localization:text("dialog_are_you_sure_you_want_to_leave_game")

	local yes_button = {}

	yes_button.text = managers.localization:text("dialog_yes")
	yes_button.callback_func = callback(self, self, "_dialog_end_game_yes")

	local no_button = {}

	no_button.text = managers.localization:text("dialog_no")
	no_button.callback_func = callback(self, self, "_dialog_end_game_no")
	no_button.class = RaidGUIControlButtonShortSecondary
	no_button.cancel_button = true
	dialog_data.button_list = {
		yes_button,
		no_button,
	}

	managers.system_menu:show(dialog_data)
end

function MenuCallbackHandler:_dialog_end_game_yes()
	managers.platform:set_playing(false)
	managers.statistics:stop_session({
		quit = true,
	})
	managers.savefile:save_setting(true)
	managers.raid_job:deactivate_current_job()
	managers.raid_job:cleanup()
	managers.lootdrop:reset_loot_value_counters()
	managers.consumable_missions:on_level_exited(false)
	managers.greed:on_level_exited(false)
	managers.worldcollection:on_simulation_ended()

	if managers.airdrop then
		managers.airdrop:cleanup()
	end

	if Network:multiplayer() then
		Network:set_multiplayer(false)
		managers.network:session():send_to_peers("set_peer_left")
		managers.network:queue_stop_network()
	end

	managers.network.matchmake:destroy_game()
	managers.network.voice_chat:destroy_voice()

	if managers.groupai then
		managers.groupai:state():set_AI_enabled(false)
	end

	managers.menu:close_menu("menu_pause")
	setup:load_start_menu()
end

function MenuCallbackHandler:load_start_menu_lobby()
	managers.network:session():load_lobby()
end

function MenuCallbackHandler:_dialog_end_game_no()
	return
end

function MenuCallbackHandler:_reset_mainmusic()
	managers.music:post_event(MusicManager.STOP_ALL_MUSIC)
	managers.music:post_event(MusicManager.MENU_MUSIC)
end

function MenuCallbackHandler:resume_game()
	managers.menu:close_menu("menu_pause")
end

function MenuCallbackHandler:delayed_open_savefile_menu(item)
	if not self._delayed_open_savefile_menu_callback then
		if managers.savefile:is_active() then
			managers.menu:set_delayed_open_savefile_menu_callback(callback(self, self, "open_savefile_menu", item))
		else
			self:open_savefile_menu(item)
		end
	end
end

function MenuCallbackHandler:open_savefile_menu(item)
	managers.menu:set_delayed_open_savefile_menu_callback(nil)

	local parameter_map = item:parameters()

	managers.menu:open_node(parameter_map.delayed_node, {
		parameter_map,
	})
end

function MenuCallbackHandler:hide_huds()
	managers.hud:set_disabled()
end

function MenuCallbackHandler:toggle_hide_huds(item)
	if item:value() == "on" then
		managers.hud:set_disabled()
	else
		managers.hud:set_enabled()
	end
end

function MenuCallbackHandler:toggle_mission_fading_debug_enabled(item)
	managers.mission:set_fading_debug_enabled(item:value() == "off")
end

function MenuCallbackHandler:menu_back()
	managers.menu:back()
end

function MenuCallbackHandler:set_default_controller(item)
	local params = {
		callback = function()
			managers.controller:load_settings("settings/controller_settings")
			managers.controller:clear_user_mod(item:parameters().category, RaidMenuOptionsControlsKeybinds.CONTROLS_INFO)

			local logic = managers.menu:active_menu().logic

			if logic then
				logic:refresh_node()
			end
		end,
		text = managers.localization:text("dialog_use_default_keys_message"),
	}

	managers.menu:show_default_option_dialog(params)
end

function MenuCallbackHandler:debug_goto_custody()
	local player = managers.player:player_unit()

	if not alive(player) then
		return
	end

	if managers.player:current_state() ~= "bleed_out" then
		managers.player:set_player_state("bleed_out")
	end

	managers.player:force_drop_carry()
	managers.statistics:downed({
		death = true,
	})
	game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
	player:character_damage():set_invulnerable(true)
	player:character_damage():set_health(0)
	player:base():_unregister()
	player:base():set_slot(player, 0)
end

function MenuCallbackHandler:start_job(job_data)
	local raid_data = tweak_data.operations:mission_data(job_data.job_id)

	Global.game_settings.level_id = raid_data.level_id or job_data.job_id
	Global.game_settings.mission = "none"
	Global.game_settings.world_setting = nil

	tweak_data:set_difficulty(job_data.difficulty)

	local matchmake_attributes = managers.network:get_matchmake_attributes()

	if Network:is_server() then
		local job_id_index = tweak_data.operations:get_index_from_raid_id(managers.raid_job:current_job_id())
		local level_id_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
		local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)

		managers.network:session():send_to_peers("sync_game_settings", job_id_index, level_id_index, difficulty_index)
		managers.network.matchmake:set_server_attributes(matchmake_attributes)

		local active_menu = managers.menu:active_menu()

		if active_menu and active_menu.logic then
			active_menu.logic:navigate_back(true)
			active_menu.logic:refresh_node("lobby", true)
		end
	else
		managers.network.matchmake:create_lobby(matchmake_attributes)
	end

	if job_data.job_id == OperationsTweakData.ENTRY_POINT_LEVEL then
		local mission = tweak_data.operations:mission_data(managers.raid_job:played_tutorial() and RaidJobManager.CAMP_ID or RaidJobManager.TUTORIAL_ID)
		local data = {}

		data.background = mission.loading.image
		data.loading_text = mission.loading.text
		data.mission = mission

		managers.menu:show_loading_screen(data)
	end

	managers.raid_job:on_mission_started()
end

function MenuCallbackHandler:start_single_player_job(job_data)
	local raid_data = tweak_data.operations:mission_data(job_data.job_id)

	Global.game_settings.level_id = raid_data.level_id
	Global.game_settings.mission = "none"
	Global.game_settings.world_setting = nil

	tweak_data:set_difficulty(job_data.difficulty)
	MenuCallbackHandler:start_the_game()
	managers.raid_job:on_mission_started()
end

function MenuCallbackHandler:_update_outfit_information()
	local outfit_string = managers.blackmarket:outfit_string()

	if self:is_win32() then
		Steam:set_rich_presence("outfit", outfit_string)
	end

	if managers.network:session() then
		local local_peer = managers.network:session():local_peer()
		local player_class = managers.skilltree:get_character_profile_class()

		local_peer:set_outfit_string(outfit_string)
		local_peer:set_class(player_class)
		managers.network:session():check_send_outfit()
	end
end

function MenuCallbackHandler:stage_success()
	if not managers.raid_job:has_active_job() then
		return true
	end

	return managers.raid_job:stage_success()
end
