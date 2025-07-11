require("lib/states/GameState")

EventCompleteState = EventCompleteState or class(GameState)
EventCompleteState.SCREEN_ACTIVE_DEBRIEF_VIDEO = 1
EventCompleteState.SCREEN_ACTIVE_SPECIAL_HONORS = 2
EventCompleteState.SCREEN_ACTIVE_STEAM_LOOT = 3
EventCompleteState.SCREEN_ACTIVE_GREED_LOOT = 4
EventCompleteState.SCREEN_ACTIVE_LOOT = 5
EventCompleteState.SCREEN_ACTIVE_EXPERIENCE = 6
EventCompleteState.LOOT_DATA_READY_KEY = "loot_data_ready"
EventCompleteState.SUCCESS_VIDEOS = {
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_01_throws_himself_v007",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_02_chickens_out_v007",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_03_salutes_v006",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_04_shoots_and_miss_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_05_crunches_bones_v006",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_06_plays_with_tin_men_v006",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_07_cries_tannenbaum_v007",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_08_chess_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_09_is_having_a_reverie_v007",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_10_colours_a_map_v009",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_11_swears_v005",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_12_plays_with_tanks_v005",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_13_flips_a_table_v007",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_success/s_14_moustache_v006",
	},
}
EventCompleteState.FAILURE_VIDEOS = {
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_01_edelweiss_v007",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_02_sizzles_v007",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_03_toasts_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_04_misunderstands_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_05_hugs_the_world_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_06_tin_soldiers_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_07_told_you_so_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_08_pumps_his_fists_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_09_bras_dhonneur_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_10_executes_v008",
	},
	{
		chance = 1,
		path = "movies/vanilla/debrief_failure/f_11_sings_v007",
	},
}

function EventCompleteState:init(game_state_machine, setup)
	GameState.init(self, "event_complete_screen", game_state_machine)

	self._type = ""
	self._continue_cb = callback(self, self, "_continue")
	self._controller = nil
	self._continue_block_timer = 0
	self._awarded_rewards = {
		greed_gold = false,
		loot = false,
		xp = false,
	}
end

function EventCompleteState:setup_controller()
	if not self._controller then
		self._controller = managers.controller:create_controller("victoryscreen", managers.controller:get_default_wrapper_index(), false)

		self._controller:set_enabled(true)
		managers.controller:add_hotswap_callback("event_complete_state", callback(self, self, "on_controller_hotswap"))
	end
end

function EventCompleteState:set_controller_enabled(enabled)
	return
end

function EventCompleteState:at_enter(old_state, params)
	Application:trace("[EventCompleteState] at_enter")
	managers.player:replenish_player()

	local player = managers.player:player_unit()

	if player then
		player:movement():current_state():interupt_all_actions()
		player:sound():stop()
		player:character_damage():stop_heartbeat()
		player:camera():set_shaker_parameter("headbob", "amplitude", 0)
		player:base():set_stats_screen_visible(false)
		player:camera():play_redirect(PlayerStandard.IDS_UNEQUIP)
		player:base():set_enabled(true)
		player:base():set_visible(false)
	end

	self._controller_list = {}

	for index = 1, managers.controller:get_wrapper_count() do
		local con = managers.controller:create_controller("boot_" .. index, index, false)

		con:enable()

		self._controller_list[index] = con
	end

	self.is_at_last_event = managers.raid_job:is_at_last_event()
	self._success = managers.raid_job:stage_success()
	self.initial_xp = managers.experience:total()
	self.initial_skills_xp = self:get_skill_xp_progress()
	self.loot_data = {}
	self.peers_loot_drops = {}
	self._difficulty = Global.game_settings.difficulty

	managers.consumable_missions:on_mission_completed(self._success)
	managers.system_event_listener:add_listener("event_complete_state_top_stats_ready", {
		CoreSystemEventListenerManager.SystemEventListenerManager.TOP_STATS_READY,
	}, callback(self, self, "on_top_stats_ready"))

	self._current_job_data = managers.raid_job:current_job() and clone(managers.raid_job:current_job()) or managers.raid_job:previously_completed_job() and clone(managers.raid_job:previously_completed_job())
	self._job_type = self._current_job_data.job_type
	self._active_challenge_card = managers.challenge_cards:get_active_card()

	if self._active_challenge_card and self._active_challenge_card.key_name and self._active_challenge_card.key_name ~= "empty" and self._active_challenge_card.loot_drop_group then
		managers.challenge_cards.forced_loot_card = self._active_challenge_card
	else
		managers.challenge_cards.forced_loot_card = nil
	end

	self:_calculate_card_xp_bonuses()
	self:_set_memory()
	self:set_statistics_values()
	managers.statistics:stop_session({
		quit = false,
		success = self._success,
		type = "victory",
	})
	managers.statistics:send_statistics()
	self:get_personal_stats()

	if self.is_at_last_event and self:is_success() then
		managers.lootdrop:add_listener(LootScreenGui.EVENT_KEY_PEER_LOOT_RECEIVED, {
			LootDropManager.EVENT_PEER_LOOT_RECEIVED,
		}, callback(self, self, "on_loot_dropped_for_peer"))

		if self._current_job_data.consumable then
			self._loot_ready = true

			self:_check_complete_achievements()
		else
			self:on_loot_data_ready()
			self:_calculate_extra_loot_secured()
		end
	end

	if Network:is_server() then
		managers.network:session():set_state("game_end")
	else
		managers.raid_job:on_mission_ended()
	end

	managers.platform:set_playing(false)
	managers.hud:remove_updator("point_of_no_return")
	managers.hud:hide_stats_screen()

	self._continue_block_timer = Application:time() + 1.5

	managers.dialog:quit_dialog()
	self:setup_controller()

	self._old_state = old_state

	local total_killed = managers.statistics:session_total_killed()

	if self.is_at_last_event then
		local is_operation = self._job_type == OperationsTweakData.JOB_TYPE_OPERATION

		if is_operation and self:is_success() or not is_operation then
			managers.challenge_cards:remove_active_challenge_card()
			managers.challenge_cards:clear_suggested_cards()

			if Network:is_server() then
				managers.network.matchmake:set_challenge_card_info()
				managers.network.matchmake:set_job_info_by_current_job()
			end
		end

		if self:is_success() and self:job_data().bounty then
			if Network:is_server() then
				managers.raid_job:set_bounty_completed_seed(self:job_data().seed)
			else
				local seed = managers.event_system:get_sync_bounty_seed()

				if seed then
					managers.raid_job:set_bounty_completed_seed(seed)
				end
			end
		end
	end

	managers.menu_component:post_event("menu_volume_set")
	managers.music:stop()
	managers.dialog:set_paused(true)

	local gui = Overlay:gui()

	self._full_workspace = gui:create_screen_workspace()
	self._safe_rect_workspace = gui:create_screen_workspace()
	self._safe_panel = self._safe_rect_workspace:panel()
	self._active_screen = EventCompleteState.SCREEN_ACTIVE_DEBRIEF_VIDEO

	local skip_cinematics = managers.user:get_setting("skip_cinematics")

	if not skip_cinematics and (self.is_at_last_event or not self._success) then
		self:_create_debrief_video()
	else
		self:_continue()
	end
end

function EventCompleteState:_calculate_card_xp_bonuses()
	local card_xp_addition = 0
	local card_xp_multiplier = 1

	if self._active_challenge_card and self._active_challenge_card.status == ChallengeCardsManager.CARD_STATUS_SUCCESS then
		card_xp_addition = self._active_challenge_card.bonus_xp or 0
	end

	if self._active_challenge_card and self._active_challenge_card.status == ChallengeCardsManager.CARD_STATUS_SUCCESS then
		card_xp_multiplier = self._active_challenge_card.bonus_xp_multiplier or 1
	end

	self._card_xp_addition = card_xp_addition
	self._card_xp_multiplier = card_xp_multiplier
end

function EventCompleteState:card_bonus_xp()
	return self._card_xp_addition
end

function EventCompleteState:card_xp_multiplier()
	return self._card_xp_multiplier
end

function EventCompleteState:_calculate_extra_loot_secured()
	local extra_loot_value = 0
	local extra_loot_count = 0
	local loot_secured = managers.loot:get_secured()

	while loot_secured do
		local loot_tweak_data = tweak_data.carry[loot_secured.carry_id]

		if loot_tweak_data and loot_tweak_data.loot_value then
			extra_loot_value = extra_loot_value + loot_tweak_data.loot_value
			extra_loot_count = extra_loot_count + 1
		end

		loot_secured = managers.loot:get_secured()
	end

	if extra_loot_value > 0 then
		self.loot_data[LootScreenGui.LOOT_ITEM_EXTRA_LOOT] = {
			acquired = extra_loot_count,
			acquired_value = extra_loot_value,
			icon = "rewards_extra_loot",
			title = "menu_loot_screen_bonus_loot",
			total_value = 0,
		}
	end
end

function EventCompleteState:on_loot_data_ready()
	self.loot_acquired = managers.raid_job:loot_acquired_in_job()
	self.loot_spawned = managers.raid_job:loot_spawned_in_job()

	if self.loot_spawned == 0 then
		managers.system_event_listener:add_listener("event_complete_state_loot_data_ready", {
			EventCompleteState.LOOT_DATA_READY_KEY,
		}, callback(self, self, "on_loot_data_ready"))

		return
	end

	self.peers_loot_drops = managers.lootdrop:get_loot_for_peers()
	self.loot_data[LootScreenGui.LOOT_ITEM_DOG_TAGS] = {
		acquired = self.loot_acquired,
		acquired_value = self.loot_acquired * tweak_data.lootdrop.dog_tag.loot_value,
		icon = "rewards_dog_tags",
		title = "menu_loot_screen_dog_tags",
		total = self.loot_spawned,
		total_value = self.loot_spawned * tweak_data.lootdrop.dog_tag.loot_value,
	}
	self._loot_ready = true

	self:_check_complete_achievements()
end

function EventCompleteState:drop_loot_for_player()
	Application:info("[EventCompleteState] drop_loot_for_player")

	local acquired_loot_value = 0
	local total_loot_value = 0
	local loot_percentage = 0
	local forced_loot_group

	for id, loot_item in pairs(self.loot_data) do
		acquired_loot_value = acquired_loot_value + loot_item.acquired_value
		total_loot_value = total_loot_value + loot_item.total_value
	end

	if total_loot_value > 0 then
		loot_percentage = acquired_loot_value / total_loot_value
	end

	local loot_percentage = math.clamp(loot_percentage, 0, 1)

	if self._active_challenge_card and self._active_challenge_card.key_name and self._active_challenge_card.key_name ~= "empty" then
		forced_loot_group = managers.challenge_cards:get_loot_drop_group(self._active_challenge_card)

		Application:info("[EventCompleteState] Challenge card active, Forced loot group is:", forced_loot_group, "from card", self._active_challenge_card.key_name)
	end

	managers.lootdrop:give_loot_to_player(loot_percentage, forced_loot_group)

	self._awarded_rewards.loot = true

	Application:info("[EventCompleteState] drop_loot_for_player DONE!")
end

function EventCompleteState:on_loot_dropped_for_player()
	Application:trace("[EventCompleteState] on_loot_dropped_for_player")

	self.local_player_loot_drop = managers.lootdrop:get_dropped_loot()

	if self._active_screen == EventCompleteState.SCREEN_ACTIVE_LOOT and managers.menu_component._raid_menu_loot_gui then
		managers.menu_component._raid_menu_loot_gui:set_local_loot_drop(self.local_player_loot_drop)
	end
end

function EventCompleteState:on_loot_dropped_for_peer()
	Application:trace("[EventCompleteState] on_loot_dropped_for_peer")

	self.peers_loot_drops = managers.lootdrop:get_loot_for_peers()

	if self._active_screen == EventCompleteState.SCREEN_ACTIVE_LOOT and managers.menu_component._raid_menu_loot_gui and managers.menu_component._raid_menu_loot_gui.peer_loot_shown then
		managers.menu_component._raid_menu_loot_gui:refresh_peers_loot_display()
	end
end

function EventCompleteState:_get_debrief_video(success)
	local video_list = EventCompleteState[success and "SUCCESS_VIDEOS" or "FAILURE_VIDEOS"]
	local video_path
	local total = 0

	for _, video in ipairs(video_list) do
		total = total + video.chance
	end

	local value = math.rand(total)

	for _, video in ipairs(video_list) do
		value = value - video.chance

		if value <= 0 then
			video_path = video.path

			break
		end
	end

	return video_path
end

function EventCompleteState:_create_debrief_video()
	Application:trace("[EventCompleteState:_create_debrief_video()]")

	if managers.network.voice_chat then
		managers.network.voice_chat:trc_check_mute()
	end

	local full_panel = self._full_workspace:panel()
	local params_root_panel = {
		background_color = Color.black,
		h = full_panel:h(),
		is_root_panel = true,
		layer = tweak_data.gui.DEBRIEF_VIDEO_LAYER,
		name = "event_complete_video_root_panel",
		w = full_panel:w(),
		x = full_panel:x(),
		y = full_panel:y(),
	}

	self._panel = RaidGUIPanel:new(full_panel, params_root_panel)

	local video = self:_get_debrief_video(self:is_success())
	local debrief_video_params = {
		layer = self._panel:layer() + 1,
		name = "event_complete_debrief_video",
		video = video,
		width = self._panel:w(),
	}

	self._debrief_video = self._panel:video(debrief_video_params)

	self._debrief_video:pause()
	self._debrief_video:set_h(self._panel:w() * (self._debrief_video:video_height() / self._debrief_video:video_width()))
	self._debrief_video:set_center_y(self._panel:h() / 2)
	managers.gui_data:layout_workspace(self._safe_rect_workspace)

	local press_any_key_text = managers.controller:is_using_controller() and "press_any_key_to_skip_controller" or "press_any_key_to_skip"
	local press_any_key_prompt = self._safe_panel:text({
		alpha = 0,
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.din_compressed, tweak_data.gui.font_sizes.size_32),
		font_size = tweak_data.gui.font_sizes.size_32,
		layer = self._debrief_video:layer() + 1,
		name = "press_any_key_prompt",
		text = utf8.to_upper(managers.localization:text(press_any_key_text)),
	})
	local _, _, w, h = press_any_key_prompt:text_rect()

	press_any_key_prompt:set_w(w)
	press_any_key_prompt:set_h(h)
	press_any_key_prompt:set_right(self._safe_panel:w() - 50)
	press_any_key_prompt:set_bottom(self._safe_panel:h() - 50)
	press_any_key_prompt:animate(callback(self, self, "_animate_show_press_any_key_prompt"))
	managers.queued_tasks:queue("play_debrief_video", self._play_debrief_video, self, nil, 2.3)
end

function EventCompleteState:_play_debrief_video()
	if self._debrief_video then
		self._debrief_video:play()
	end
end

function EventCompleteState:_animate_show_press_any_key_prompt(prompt)
	local duration = 0.7
	local t = 0

	wait(6)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 0.75, duration)

		prompt:set_alpha(current_alpha)
	end

	prompt:set_alpha(0.75)
end

function EventCompleteState:_animate_change_press_any_key_prompt(prompt)
	local fade_out_duration = 0.25
	local t = (1 - prompt:alpha()) * fade_out_duration

	while t < fade_out_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0.75, -0.75, fade_out_duration)

		prompt:set_alpha(current_alpha)
	end

	prompt:set_alpha(0)

	local press_any_key_text = managers.controller:is_using_controller() and "press_any_key_to_skip_controller" or "press_any_key_to_skip"

	prompt:set_text(utf8.to_upper(managers.localization:text(press_any_key_text)))

	local _, _, w, h = prompt:text_rect()

	prompt:set_w(w)
	prompt:set_h(h)
	prompt:set_right(self._safe_panel:w() - 50)

	local fade_in_duration = 0.25

	t = 0

	while t < fade_in_duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quartic_in_out(t, 0, 0.75, fade_in_duration)

		prompt:set_alpha(current_alpha)
	end

	prompt:set_alpha(0.75)
end

function EventCompleteState:on_controller_hotswap()
	local press_any_key_prompt = self._safe_panel:child("press_any_key_prompt")

	if press_any_key_prompt then
		press_any_key_prompt:stop()
		press_any_key_prompt:animate(callback(self, self, "_animate_change_press_any_key_prompt"))
	end
end

function EventCompleteState:job_data()
	return self._current_job_data
end

function EventCompleteState:on_server_left(message)
	local loc = managers.localization
	local dialog_data = {
		button_list = {
			{
				callback_func = MenuCallbackHandler._dialog_end_game_yes,
				text = loc:text("dialog_ok"),
			},
		},
		text = loc:text("dialog_server_left"),
		title = loc:text("dialog_returning_to_main_menu"),
	}

	if not self._awarded_rewards.loot and managers.raid_job:is_at_last_event() and self:is_success() then
		managers.lootdrop._cards_already_rejected = true

		self:drop_loot_for_player()

		local dropped_loot = managers.lootdrop._dropped_loot

		if not dropped_loot.reward_type == LootDropTweakData.REWARD_XP then
			dialog_data.text = dialog_data.text .. "\n"
		end

		if dropped_loot.reward_type == LootDropTweakData.REWARD_CUSTOMIZATION then
			local outfit = loc:text(dropped_loot.character_customization.name)

			dialog_data.text = dialog_data.text .. loc:text("menu_server_left_loot_outfit", {
				OUTFIT = outfit,
			})
		elseif dropped_loot.reward_type == LootDropTweakData.REWARD_GOLD_BARS then
			local gold = managers.gold_economy:gold_string(dropped_loot.awarded_gold_bars)

			dialog_data.text = dialog_data.text .. loc:text("menu_server_left_loot_gold", {
				GOLD = gold,
			})
		elseif dropped_loot.reward_type == LootDropTweakData.REWARD_MELEE_WEAPON then
			local melee_tweak = tweak_data.blackmarket.melee_weapons[dropped_loot.weapon_id]

			if melee_tweak then
				local melee = loc:text(melee_tweak.name_id)

				dialog_data.text = dialog_data.text .. loc:text("menu_server_left_loot_melee", {
					MELEE = melee,
				})
			end
		end
	end

	if not self._awarded_rewards.xp then
		local base_xp = self:calculate_xp()
		local xp = managers.experience:experience_string(self._awarded_xp)

		dialog_data.text = dialog_data.text .. "\n" .. loc:text("menu_server_left_loot_xp", {
			XP = xp,
		})

		self:award_xp(base_xp)
	end

	if not self._awarded_rewards.greed_gold and managers.greed:acquired_gold_in_mission() and self:is_success() then
		local gold = managers.gold_economy:gold_string(managers.greed._gold_awarded_in_mission)

		dialog_data.text = dialog_data.text .. "\n" .. loc:text("menu_server_left_loot_greed_gold", {
			GOLD = gold,
		})

		managers.greed:award_gold_picked_up_in_mission()
	end

	managers.worldcollection:on_server_left()

	if managers.game_play_central then
		managers.game_play_central:stop_the_game()
	end

	managers.system_menu:show(dialog_data)

	Global.on_remove_peer_message = nil
end

function EventCompleteState:on_top_stats_ready()
	Application:trace("[EventCompleteState:on_top_stats_ready()]")

	if Network:is_server() then
		managers.raid_job:complete_current_event()
	end

	self.player_top_stats = managers.statistics:get_top_stats_for_player()

	local acquired_value = 0
	local total_value = 0

	if self:is_success() then
		self.special_honors = managers.statistics:get_top_stats()
		self.downed_stats = managers.statistics:get_downed_stats()

		if managers.network:session():amount_of_players() ~= 1 then
			for index, stat in pairs(self.special_honors) do
				if stat.peer_id == managers.network:session():local_peer():id() then
					acquired_value = acquired_value + tweak_data.statistics.top_stats[stat.id].loot_value
				end

				total_value = total_value + tweak_data.statistics.top_stats[stat.id].loot_value
			end

			local top_stats_loot_data = {
				acquired = #self.player_top_stats,
				acquired_value = acquired_value,
				icon = "rewards_top_stats",
				title = "menu_loot_screen_top_stats",
				total = #self.special_honors,
				total_value = total_value,
			}

			self.loot_data[LootScreenGui.LOOT_ITEM_TOP_STATS] = top_stats_loot_data
		end
	else
		self.special_honors = managers.statistics:get_bottom_stats()
	end

	for index, stat in pairs(self.player_top_stats) do
		acquired_value = acquired_value + tweak_data.statistics.top_stats[stat.id].loot_value
	end

	self.stats_ready = true

	if self._active_screen == EventCompleteState.SCREEN_ACTIVE_SPECIAL_HONORS and managers.menu_component._raid_menu_special_honors_gui then
		managers.menu_component._raid_menu_special_honors_gui:show_honors()
	end

	self:_check_complete_achievements()
end

function EventCompleteState:update(t, dt)
	if self._active_screen == EventCompleteState.SCREEN_ACTIVE_DEBRIEF_VIDEO and (self:is_playing() and self:is_skipped() or not self:is_playing()) then
		self._debrief_video:destroy()
		self._panel:remove(self._debrief_video)
		self._panel:remove_background()
		self._panel:remove(self._panel:child("disclaimer"))

		self._debrief_video = nil
		self._panel = nil

		self._safe_panel:child("press_any_key_prompt"):stop()
		self._safe_panel:remove(self._safe_panel:child("press_any_key_prompt"))
		self:_continue()
	end
end

function EventCompleteState:is_playing()
	return self._debrief_video:loop_count() < 1
end

function EventCompleteState:is_skipped()
	for _, controller in ipairs(self._controller_list) do
		if controller:get_any_input_pressed() then
			return true
		end
	end

	return false
end

function EventCompleteState:get_personal_stats()
	local personal_stats = {}

	personal_stats.session_killed = managers.statistics:session_killed().total.count or 0
	personal_stats.session_accuracy = managers.statistics:session_hit_accuracy() or 0
	personal_stats.session_headshots = managers.statistics:session_total_head_shots() or 0
	personal_stats.session_headshot_percentage = 0

	if personal_stats.session_killed > 0 then
		personal_stats.session_headshot_percentage = personal_stats.session_headshots / personal_stats.session_killed * 100
	end

	personal_stats.session_special_kills = managers.statistics:session_total_specials_kills() or 0
	personal_stats.session_revives_data = managers.statistics:session_teammates_revived() or 0
	personal_stats.session_teammates_revived = 0

	for i, count in pairs(personal_stats.session_revives_data) do
		personal_stats.session_teammates_revived = personal_stats.session_teammates_revived + count
	end

	personal_stats.session_bleedouts = managers.statistics:session_downed()
	self.personal_stats = personal_stats
end

function EventCompleteState:get_skill_xp_progress()
	local skills_applied = managers.skilltree:get_skills_applied_grouped()
	local skill_types = {
		SkillTreeTweakData.TYPE_WARCRY,
		SkillTreeTweakData.TYPE_BOOSTS,
		SkillTreeTweakData.TYPE_TALENT,
	}
	local skills_table = {}

	for _, idx in ipairs(skill_types) do
		if skills_applied[idx] then
			for id, skill in pairs(skills_applied[idx]) do
				local skill_tweak = tweak_data.skilltree.skills[id]

				if skill_tweak and skill_tweak.exp_requirements then
					local slot_type = skill_tweak.upgrades_type
					local exp_progression = skill.exp_progression or 0
					local current_tier = skill.exp_tier or 1
					local max_tier = #skill_tweak.exp_requirements
					local exp_requirement_tier = skill_tweak.exp_requirements[math.min(max_tier, current_tier)]
					local tag_color = tweak_data.skilltree.skill_category_colors[slot_type]
					local at_max_tier = current_tier == max_tier
					local progress = 0

					progress = at_max_tier and 1 or exp_progression / exp_requirement_tier

					table.insert(skills_table, {
						at_max_tier = at_max_tier,
						id = id,
						max_tier = max_tier,
						progress = progress,
						tag_color = tag_color,
						tier = current_tier,
					})
				end
			end
		end
	end

	return skills_table
end

function EventCompleteState:get_base_xp_breakdown()
	local is_in_operation = self._job_type == OperationsTweakData.JOB_TYPE_OPERATION
	local current_operation = is_in_operation and self._current_job_data.job_id or nil
	local current_event

	if is_in_operation then
		current_event = self._current_job_data.events_index[self._current_job_data.current_event]
	else
		current_event = self._current_job_data.job_id
	end

	self.xp_breakdown = managers.experience:calculate_exp_breakdown(current_event, current_operation, true)

	if not self:is_success() then
		for i = 1, #self.xp_breakdown.additive do
			self.xp_breakdown.additive[i].amount = self.xp_breakdown.additive[i].amount * RaidJobManager.XP_MULTIPLIER_ON_FAIL
		end
	end
end

function EventCompleteState:calculate_xp()
	self:get_base_xp_breakdown()

	local additive = 0

	for i = 1, #self.xp_breakdown.additive do
		additive = additive + (self.xp_breakdown.additive[i].amount or 0)
	end

	local multiplicative = 1

	for i = 1, #self.xp_breakdown.multiplicative do
		local amount = self.xp_breakdown.multiplicative[i].amount or 0

		multiplicative = multiplicative + amount

		if self.xp_breakdown.multiplicative[i].id == "xp_multiplicative_level_difference" then
			self._level_difference_bonus = 1 + amount
		end
	end

	self.total_xp = additive * multiplicative

	Application:info("[EventCompleteState] NEW XP Total: " .. tostring(self.total_xp))

	return self.total_xp
end

function EventCompleteState:recalculate_xp()
	local total_xp = self:calculate_xp()

	if total_xp ~= self._awarded_xp then
		self:award_xp(total_xp - self._awarded_xp)
	end
end

function EventCompleteState:award_xp(value)
	Application:trace("[EventCompleteState] value: " .. tostring(value))
	managers.experience:add_points(value, false)

	local skill_value = value

	if self._level_difference_bonus and self._level_difference_bonus > 1 then
		skill_value = skill_value / self._level_difference_bonus

		Application:trace("[EventCompleteState] reduced skill value: " .. tostring(skill_value), self._level_difference_bonus)
	end

	managers.skilltree:add_skill_points(skill_value)

	if not self._awarded_xp then
		self._awarded_xp = 0
	end

	self._awarded_xp = self._awarded_xp + value
	self._awarded_rewards.xp = true
end

function EventCompleteState:is_success()
	return self._success
end

function EventCompleteState:at_exit(next_state)
	Application:trace("[EventCompleteState] at_exit")
	self:_clear_controller()

	if managers.network.voice_chat then
		managers.network.voice_chat:trc_check_unmute()
	end

	managers.experience:clear_loot_redeemed_xp()
	managers.loot:clear()
	managers.greed:clear_cache()

	self.initial_xp = nil
	self.xp_breakdown = nil
	self.total_xp = nil
	self.stats_ready = nil
	self._loot_ready = nil
	self.local_player_loot_drop = nil
	self._level_difference_bonus = nil
	self._achievements_awarded = nil
	self._awarded_xp = 0
	self.loot_acquired = 0
	self.loot_spawned = 0
	self.loot_data = {}

	managers.statistics:clear_peer_statistics()
	managers.savefile:save_game(SavefileManager.SETTING_SLOT)

	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(true)
		player:base():set_visible(true)
		player:camera():play_redirect(PlayerStandard.IDS_EQUIP)
	end

	if Network:is_server() then
		managers.raid_job:start_next_event()
		managers.network:session():set_state("in_game")
		managers.network.matchmake:set_job_info_by_current_job()
	end

	managers.system_event_listener:remove_listener("event_complete_state_top_stats_ready")
	managers.system_event_listener:remove_listener("event_complete_state_loot_data_ready")
	managers.lootdrop:remove_listener(LootScreenGui.EVENT_KEY_PEER_LOOT_RECEIVED)
	managers.music:stop()
	managers.music:post_event(MusicManager.CAMP_MUSIC, true)
	managers.menu_component:post_event("menu_volume_reset")
	managers.dialog:set_paused(false)
	Overlay:gui():destroy_workspace(self._full_workspace)
	Overlay:gui():destroy_workspace(self._safe_rect_workspace)
end

function EventCompleteState:_shut_down_network()
	Network:set_multiplayer(false)
	managers.network:queue_stop_network()
	managers.network.matchmake:destroy_game()
	managers.network.voice_chat:destroy_voice()
end

function EventCompleteState:_continue_blocked()
	local out_focus = managers.menu:active_menu() ~= self._mission_end_menu

	if out_focus then
		return true
	end

	if managers.hud:showing_stats_screen() then
		return true
	end

	if managers.system_menu:is_active() then
		return true
	end

	if managers.menu_component:input_focus() == 1 then
		return true
	end

	local timer_blocking = self._continue_block_timer and self._continue_block_timer > Application:time()

	if timer_blocking then
		return true
	end

	return false
end

function EventCompleteState:continue()
	self:_continue()
end

function EventCompleteState:_continue()
	Application:trace("[EventCompleteState] _continue")

	if self._active_screen == EventCompleteState.SCREEN_ACTIVE_DEBRIEF_VIDEO then
		self._active_screen = EventCompleteState.SCREEN_ACTIVE_SPECIAL_HONORS

		managers.queued_tasks:unqueue("play_debrief_video")
		managers.music:post_event("music_mission_" .. (self:is_success() and "success" or "fail"), true)

		if managers.network.voice_chat then
			managers.network.voice_chat:trc_check_unmute()
		end

		if managers.network:session():amount_of_players() > 1 then
			managers.raid_menu:open_menu("raid_menu_special_honors", false)
		else
			self:_continue()
		end
	elseif self._active_screen == EventCompleteState.SCREEN_ACTIVE_SPECIAL_HONORS then
		if self.is_at_last_event and self:is_success() then
			local success = managers.raid_menu:open_menu("raid_menu_loot_screen", false)

			if success then
				self._active_screen = EventCompleteState.SCREEN_ACTIVE_LOOT
			end
		elseif self:is_success() and managers.greed:acquired_gold_in_mission() then
			self._active_screen = EventCompleteState.SCREEN_ACTIVE_GREED_LOOT

			local success = managers.raid_menu:open_menu("raid_menu_greed_loot_screen", false)

			managers.greed:award_gold_picked_up_in_mission()

			self._awarded_rewards.greed_gold = true
		else
			local base_xp = self:calculate_xp()

			self:award_xp(base_xp)

			local success = managers.raid_menu:open_menu("raid_menu_post_game_breakdown", false)

			if success then
				self._active_screen = EventCompleteState.SCREEN_ACTIVE_EXPERIENCE
			end
		end

		managers.hud:post_event("prize_set_volume_continue")
		managers.hud:post_event("next_page_woosh")
	elseif self._active_screen == EventCompleteState.SCREEN_ACTIVE_LOOT then
		self._active_screen = EventCompleteState.SCREEN_ACTIVE_GREED_LOOT

		if self:is_success() and managers.greed:acquired_gold_in_mission() then
			local success = managers.raid_menu:open_menu("raid_menu_greed_loot_screen", false)

			managers.greed:award_gold_picked_up_in_mission()

			self._awarded_rewards.greed_gold = true
		else
			self:_continue()

			return
		end
	elseif self._active_screen == EventCompleteState.SCREEN_ACTIVE_GREED_LOOT then
		local base_xp = self:calculate_xp()

		self:award_xp(base_xp)

		local success = managers.raid_menu:open_menu("raid_menu_post_game_breakdown", false)

		if success then
			self._active_screen = EventCompleteState.SCREEN_ACTIVE_EXPERIENCE
		else
			self._active_screen = nil

			game_state_machine:change_state(self._old_state)
		end

		managers.hud:post_event("prize_set_volume_continue")
		managers.hud:post_event("next_page_woosh")
	else
		self._active_screen = nil

		managers.raid_menu:close_all_menus()
		game_state_machine:change_state(self._old_state)
	end
end

function EventCompleteState:_clear_controller()
	managers.controller:remove_hotswap_callback("event_complete_state")

	if self._controller_list then
		for _, controller in ipairs(self._controller_list) do
			controller:destroy()
		end
	end

	if not self._controller then
		return
	end

	self._controller:set_enabled(false)
	self._controller:destroy()

	self._controller = nil
end

function EventCompleteState:game_ended()
	return true
end

function EventCompleteState:_check_complete_achievements()
	if self._achievements_awarded or not self.stats_ready or not self._loot_ready then
		return
	end

	if self:is_success() then
		local job_id = self._current_job_data.job_id
		local peers_connected = managers.network:session():count_all_peers()
		local dogtags_collected = self.loot_spawned == self.loot_acquired
		local total_downs = self.downed_stats.total_downs or 0
		local all_players_downed = self.downed_stats.all_players_downed or false
		local mission_data = {
			consumable = self._current_job_data.consumable,
			difficulty = tweak_data:difficulty_to_index(Global.game_settings.difficulty),
			dogtags_collected = dogtags_collected,
			no_bleedout = total_downs == 0,
			peers_connected = peers_connected,
			stealthed = self._job_memory.stealth,
		}

		managers.achievment:check_mission_achievements(job_id, mission_data)
		managers.achievment:check_achievement_complete_raid_with_4_different_classes()
		managers.achievment:check_achievement_complete_raid_with_no_kills()
		managers.achievment:check_achievement_kill_30_enemies_with_vehicle_on_bank_level()

		if peers_connected > 1 and all_players_downed then
			managers.achievment:award("ach_all_players_go_to_bleedout")
		end

		self._achievements_awarded = true
	end
end

function EventCompleteState:_set_memory()
	self._job_memory = {
		stealth = managers.raid_job:get_memory("stealth_completion"),
	}
end

function EventCompleteState:set_statistics_values()
	Application:info("[EventCompleteState] set_statistics_values: complete job with challenge card", self._active_challenge_card and inspect(self._active_challenge_card))

	if self._active_challenge_card and self._active_challenge_card.event and managers.event_system:is_event_active() then
		Application:info("[EventCompleteState] set_statistics_values: event", self._active_challenge_card and self._active_challenge_card.event)

		return
	end

	local used_challenge_card = self._active_challenge_card and self._active_challenge_card.key_name and self._active_challenge_card.key_name ~= "empty"

	Application:info("[EventCompleteState] set_statistics_values: used_challenge_card", used_challenge_card)

	if self:is_success() and used_challenge_card then
		managers.statistics:complete_job_with_card(self._job_type, self._active_challenge_card)
	end
end

function EventCompleteState:is_joinable()
	return false
end
