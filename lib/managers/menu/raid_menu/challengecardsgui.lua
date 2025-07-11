ChallengeCardsGui = ChallengeCardsGui or class(RaidGuiBase)
ChallengeCardsGui.PHASE = 1
ChallengeCardsGui.SUGGESTED_CARDS_Y = 572

function ChallengeCardsGui:init(ws, fullscreen_ws, node, component_name)
	ChallengeCardsGui.super.init(self, ws, fullscreen_ws, node, component_name)

	self._phase_two_timer = ChallengeCardsTweakData.CARD_SELECTION_TIMER

	managers.system_event_listener:add_listener("challenge_cards_gui_suggestions_changed", {
		CoreSystemEventListenerManager.SystemEventListenerManager.CHALLENGE_CARDS_SUGGESTED_CARDS_CHANGED,
		CoreSystemEventListenerManager.SystemEventListenerManager.EVENT_DROP_IN,
	}, callback(self, self, "suggestions_changed"))
	managers.system_event_listener:add_listener("challenge_cards_gui_inventory_processed", {
		CoreSystemEventListenerManager.SystemEventListenerManager.EVENT_STEAM_INVENTORY_PROCESSED,
	}, callback(self, self, "_players_inventory_processed"))
	managers.system_event_listener:add_listener("challenge_cards_gui_steam_inventory_loaded", {
		CoreSystemEventListenerManager.SystemEventListenerManager.EVENT_STEAM_INVENTORY_LOADED,
	}, callback(self, self, "_players_inventory_loaded"))
end

function ChallengeCardsGui:_set_initial_data()
	self._challenge_cards_data_source = {}
	self._challenge_cards_steam_data_source = {}
	self._filter_rarity = nil
	self._filter_type = nil
	self._selected_card_data = nil
	self._sound_source = SoundDevice:create_source("challenge_card")
end

function ChallengeCardsGui:_layout()
	local common_width = 800

	self._phase_one_panel = self._root_panel:panel({
		name = "phase_one_panel",
		x = 0,
		y = 0,
	})
	self._phase_two_panel = self._root_panel:panel({
		name = "phase_two_panel",
		x = 0,
		y = 0,
	})
	self._cards_suggest_title = self._root_panel:label({
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.title,
		h = 60,
		name = "cards_suggest_title",
		text = "",
		vertical = "top",
		visible = true,
		w = 800,
	})

	local tabs_params = {
		{
			name = "tab_all",
			text = self:translate("menu_filter_all", true),
		},
		{
			callback_param = LootDropTweakData.RARITY_COMMON,
			name = "tab_common",
			text = self:translate("loot_rarity_common", true),
		},
		{
			callback_param = LootDropTweakData.RARITY_UNCOMMON,
			name = "tab_uncommon",
			text = self:translate("loot_rarity_uncommon", true),
		},
		{
			callback_param = LootDropTweakData.RARITY_RARE,
			name = "tab_rare",
			text = self:translate("loot_rarity_rare", true),
		},
		{
			callback_param = LootDropTweakData.RARITY_OTHER,
			name = "tab_other",
			text = self:translate("menu_filter_other", true),
		},
	}

	self._rarity_filters_tabs = self._phase_one_panel:tabs({
		dont_trigger_special_buttons = true,
		name = "rarity_filters_tabs",
		on_click_callback = callback(self, self, "on_click_filter_rarity"),
		tab_align = "center",
		tab_height = 64,
		tab_width = common_width / #tabs_params,
		tabs_params = tabs_params,
		x = 0,
		y = 96,
	})
	self._challenge_cards_grid_scrollable_area = self._phase_one_panel:scrollable_area({
		h = 612,
		name = "challenge_cards_grid_scrollable_area",
		scroll_step = 60,
		w = common_width,
		y = 192,
	})
	self._card_grid = self._challenge_cards_grid_scrollable_area:get_panel():grid({
		grid_params = {
			data_source_callback = callback(self, self, "data_source_inventory_cards"),
			on_click_callback = callback(self, self, "_on_click_inventory_cards"),
			on_select_callback = callback(self, self, "_on_select_inventory_cards"),
			scroll_marker_w = 32,
			vertical_spacing = 5,
		},
		item_params = {
			item_h = 230,
			item_w = 166.11111105999998,
			key_value_field = "key_name",
			row_class = RaidGUIControlCardWithSelector,
			selected_marker_h = 256,
			selected_marker_w = 184.888888832,
		},
		name = "challenge_cards_grid",
		scrollable_area_ref = self._challenge_cards_grid_scrollable_area,
		w = common_width,
	})

	self._challenge_cards_grid_scrollable_area:setup_scroll_area()

	local card_details_params = {
		card_h = 384,
		card_w = 272,
		card_x = 0,
		card_y = 0,
		h = 544,
		name = "card_deatils",
		visible = true,
		w = self._root_panel:w() - (self._card_grid:right() + 100),
		x = self._card_grid:right() + 100,
		y = self._rarity_filters_tabs:bottom(),
	}

	self._card_details = self._phase_one_panel:create_custom_control(RaidGUIControlCardDetails, card_details_params)

	local suggested_cards_grid_params = {
		grid_params = {
			lock_texture = true,
			remove_texture = true,
		},
		h = 265,
		item_params = {
			h = 232,
			w = 192,
		},
		name = "suggested_cards_grid",
		visible = true,
		w = 856,
		x = self._card_details:left(),
		y = ChallengeCardsGui.SUGGESTED_CARDS_Y,
	}

	self._suggested_cards_grid = self._phase_one_panel:suggested_cards_grid(suggested_cards_grid_params)

	local button_padding = 32

	self._suggest_card_button = self._phase_one_panel:short_primary_button({
		name = "suggest_card_button",
		on_click_callback = callback(self, self, "suggest_card"),
		text = ">SUGGEST<",
		y = self._phase_one_panel:bottom() - 128,
	})
	self._clear_card_button = self._phase_one_panel:short_secondary_button({
		name = "clear_card_button",
		on_click_callback = callback(self, self, "cancel_card"),
		text = self:translate("menu_clear_selection", true),
		y = self._suggest_card_button:y(),
	})

	self._clear_card_button:set_left(self._suggest_card_button:right() + button_padding)
	self:_setup_single_player()

	if not managers.raid_job:current_job_type() then
		self._info_label = self._phase_one_panel:label({
			align = "center",
			color = tweak_data.gui.colors.raid_red,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.large,
			h = 48,
			layer = RaidGuiBase.FOREGROUND_LAYER,
			text = self:translate("menu_challenge_cards_no_mission_selected", true),
			vertical = "center",
			w = self._challenge_cards_grid_scrollable_area:w(),
			y = self._phase_one_panel:bottom() - 128,
		})

		self._suggest_card_button:hide()
		self._clear_card_button:hide()
	end

	self._cards_title_ph2_host = self._root_panel:label({
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.title,
		h = 60,
		name = "cards_title_ph2_host",
		text = self:translate("menu_challenge_cards_title_ph2_host", true),
		vertical = "top",
		visible = false,
		w = 800,
		x = 0,
		y = 0,
	})
	self._cards_title_ph2_client = self._root_panel:label({
		color = tweak_data.gui.colors.raid_red,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.title,
		h = 60,
		name = "cards_title_ph2_client",
		text = self:translate("menu_challenge_cards_title_ph2_client", true),
		vertical = "top",
		visible = false,
		w = 800,
		x = 0,
		y = 0,
	})

	local host_activates_card_grid_params = {
		grid_params = {
			on_click_callback = callback(self, self, "on_item_host_clicks_suggested_card_grid"),
		},
		h = 675,
		item_params = {
			item_h = 383,
			item_w = 300,
			selected_marker_h = 675,
			selected_marker_w = 352,
		},
		name = "host_activates_card_grid",
		visible = true,
		w = 1725,
		x = 0,
		y = 96,
	}

	self._host_activates_card_grid = self._phase_two_panel:suggested_cards_grid_large(host_activates_card_grid_params)
	self._phase_two_activate_button = self._phase_two_panel:long_primary_button({
		name = "phase_two_activate_button",
		on_click_callback = callback(self, self, "phase_two_activate"),
		text = self:translate("menu_select_card_button", true),
		x = 0,
		y = self._suggested_cards_grid:bottom() + 32,
	})
	self._continue_without_a_card_button = self._phase_two_panel:long_secondary_button({
		name = "continue_without_a_card",
		on_click_callback = callback(self, self, "_on_continue_without_card"),
		text = self:translate("menu_challenge_cards_host_skip_suggestions", true),
		x = 0,
		y = self._suggested_cards_grid:bottom() + 32,
	})

	self._continue_without_a_card_button:set_right(self._phase_two_panel:right())

	self._filter_type = managers.raid_job:current_job_type()

	local rm_head = self._node.components.raid_menu_header
	local rm_head_text

	rm_head_text = self._filter_type == OperationsTweakData.JOB_TYPE_RAID and "menu_challenge_cards_suggest_raid_title" or self._filter_type == OperationsTweakData.JOB_TYPE_OPERATION and "menu_challenge_cards_suggest_operation_title" or "menu_challenge_cards_view_title"

	rm_head:set_screen_name(rm_head_text)
	self:suggestions_changed()
	self._phase_one_panel:show()
	self._phase_two_panel:hide()

	if Network:is_server() then
		-- block empty
	else
		local host_name = managers.network:session():all_peers()[1]:name()

		self._host_ph2_message = self._phase_two_panel:label({
			align = "center",
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.large,
			h = 36,
			name = "client_waiting_message",
			text = utf8.to_upper(managers.localization:text("menu_challenge_cards_waiting_choose_card_msg", {
				PEER_NAME = host_name,
			})),
			w = self._phase_two_panel:w(),
			x = 0,
			y = self._phase_two_activate_button:y() - 48,
		})
	end

	if managers.controller:is_using_controller() then
		self._suggest_card_button:hide()
		self._clear_card_button:hide()
	end

	if ChallengeCardsGui.PHASE == 2 then
		self._timer_label = self._root_panel:label({
			color = tweak_data.gui.colors.raid_white,
			font = tweak_data.gui.fonts.din_compressed,
			font_size = tweak_data.gui.font_sizes.title,
			h = 60,
			name = "timer_label",
			text = "",
			vertical = "top",
			visible = true,
			w = 200,
		})

		self._timer_label:set_right(self._root_panel:right())

		self._timer_icon = self._root_panel:image({
			h = 34,
			name = "timer_icon",
			texture = tweak_data.gui.icons.ico_time.texture,
			texture_rect = tweak_data.gui.icons.ico_time.texture_rect,
			w = 34,
			x = 0,
			y = 20,
		})

		self:redirect_to_phase_two_screen()
	end

	self:bind_controller_inputs()
	managers.challenge_cards:set_automatic_steam_inventory_refresh(true)
	managers.network.account:inventory_load()
	self:_players_inventory_processed({
		list = managers.challenge_cards:get_readyup_card_cache(),
	})
	self:_auto_select_first_card_in_grid()
end

function ChallengeCardsGui:_setup_single_player()
	self._is_single_player = managers.network:session():count_all_peers() == 1

	if self._is_single_player then
		self._suggest_button_string_id = "menu_select_card_buton"
		self._disabled_suggest_button_string_id = "menu_selected"
		self._unable_suggest_button_string_id = "menu_unavailable"
	else
		self._suggest_button_string_id = "menu_suggest_card_buton"
		self._disabled_suggest_button_string_id = "menu_suggested"
		self._unable_suggest_button_string_id = "menu_unavailable"
	end

	self._suggest_card_button:set_text(self:translate(self._suggest_button_string_id, true))
end

function ChallengeCardsGui:host_skip_suggestions()
	self:phase_two_cancel()
	self:redirect_to_level_loading()
end

function ChallengeCardsGui:on_item_host_clicks_suggested_card_grid(selected_item_data)
	self:select_suggested_card(selected_item_data)
end

function ChallengeCardsGui:sync_host_selects_suggested_card(card_key_name, peer_id, steam_instance_id)
	if card_key_name == nil and peer_id == nil and steam_instance_id == nil then
		self._host_chosen_card = nil
	else
		self._host_chosen_card = {
			key_name = card_key_name,
			peer_id = peer_id,
			steam_instance_id = steam_instance_id,
		}

		local is_host = Network:is_server()

		if not is_host then
			self._host_activates_card_grid:select_item(peer_id)
		end
	end
end

function ChallengeCardsGui:on_click_filter_rarity(rarity)
	self._filter_rarity = rarity

	self:reload_filtered_data()
end

function ChallengeCardsGui:reload_filtered_data()
	if self._challenge_cards_steam_data_source then
		local owned_cards = {}

		for _, card_data in ipairs(self._challenge_cards_steam_data_source) do
			owned_cards[card_data.key_name] = card_data
		end

		self._challenge_cards_data_source = {}

		for key_name, card_data in pairs(tweak_data.challenge_cards.cards) do
			if key_name ~= "empty" and self:_is_valid_rarity_filter(card_data.rarity) then
				local card = owned_cards[key_name]

				if not card then
					card = clone(card_data)
					card.key_name = key_name
				end

				table.insert(self._challenge_cards_data_source, card)
			end
		end

		local function sort_owned(a, b)
			if not a.steam_instances and not b.steam_instances then
				return false
			end

			if a.steam_instances and not b.steam_instances then
				return true
			end

			if a.steam_instances and b.steam_instances and #a.steam_instances > #b.steam_instances then
				return true
			end

			return false
		end

		table.sort(self._challenge_cards_data_source, sort_owned)
	end

	local result = {}

	for _, card_data in ipairs(self._challenge_cards_data_source) do
		local add_card = true

		if add_card and card_data.menu_skip then
			add_card = false
		end

		if not add_card or not self._filter_type or self._filter_type == OperationsTweakData.JOB_TYPE_RAID and card_data.card_type == ChallengeCardsTweakData.CARD_TYPE_RAID or self._filter_type == OperationsTweakData.JOB_TYPE_OPERATION and card_data.card_type == ChallengeCardsTweakData.CARD_TYPE_OPERATION then
			-- block empty
		else
			add_card = false
		end

		if add_card then
			table.insert(result, card_data)
		else
			Application:info("[ChallengeCardsGui:reload_filtered_data] Card '" .. card_data.key_name .. "' did not make visible filters", inspect(card_data))
		end
	end

	self._challenge_cards_data_source = clone(result)

	self._card_grid:refresh_data()
	self._challenge_cards_grid_scrollable_area:setup_scroll_area()
	self:_auto_select_same_card_in_grid()
	self._card_grid:set_selected(true)
end

function ChallengeCardsGui:_is_valid_rarity_filter(rarity)
	if not self._filter_rarity then
		return true
	end

	if self._filter_rarity == LootDropTweakData.RARITY_OTHER then
		if rarity == LootDropTweakData.RARITY_COMMON or rarity == LootDropTweakData.RARITY_UNCOMMON or rarity == LootDropTweakData.RARITY_RARE then
			return false
		else
			return true
		end
	elseif self._filter_rarity == rarity then
		return true
	end

	return false
end

function ChallengeCardsGui:data_source_inventory_cards()
	self._challenge_cards_data_source = self._challenge_cards_data_source or {}

	return self._challenge_cards_data_source
end

function ChallengeCardsGui:_on_click_inventory_cards(card_data)
	if card_data then
		managers.menu_component:post_event("highlight")

		self._selected_card_data = card_data

		self._card_details:set_card_details(card_data.key_name)
		self._card_details:set_control_mode(RaidGUIControlCardDetails.MODE_SUGGESTING)
		self._suggested_cards_grid:select_grid_item_by_item(nil)
	end

	self:_update_suggest_card_button()
end

function ChallengeCardsGui:_on_select_inventory_cards(item_idx, card_data)
	if card_data then
		managers.menu_component:post_event("highlight")

		self._selected_card_data = card_data

		self._card_details:set_card_details(card_data.key_name)
		self._card_details:set_control_mode(RaidGUIControlCardDetails.MODE_SUGGESTING)
		self._suggested_cards_grid:select_grid_item_by_item(nil)
	end

	self:_update_suggest_card_button()
end

function ChallengeCardsGui:suggest_card()
	if not self._filter_type then
		managers.menu_component:post_event("generic_fail_sound")

		return
	end

	local card_data = self._selected_card_data

	if card_data and card_data.steam_instances then
		managers.menu_component:post_event("sugg_card_lock")

		local steam_instance_id = card_data.steam_instances[1].instance_id

		managers.challenge_cards:suggest_challenge_card(card_data.key_name, steam_instance_id)
		self:_update_suggest_card_button()
	else
		managers.menu_component:post_event("generic_fail_sound")
	end
end

function ChallengeCardsGui:cancel_card()
	managers.challenge_cards:remove_suggested_challenge_card()
	self:_update_suggest_card_button()
	managers.menu_component:post_event("sugg_card_remove")
end

function ChallengeCardsGui:phase_two_activate()
	local peer_id

	if self._host_chosen_card then
		peer_id = self._host_chosen_card.peer_id
	end

	self:sync_phase_two_execute_action("ACTIVATE", peer_id)
	managers.network:session():send_to_peers_synched("sync_phase_two_execute_action", "ACTIVATE", peer_id)
	self:redirect_to_level_loading()
end

function ChallengeCardsGui:_on_continue_without_card()
	self:host_skip_suggestions()

	return true, nil
end

function ChallengeCardsGui:phase_two_cancel()
	self:sync_phase_two_execute_action("CANCEL", nil)
	managers.network:session():send_to_peers_synched("sync_phase_two_execute_action", "CANCEL", nil)
end

function ChallengeCardsGui:sync_phase_two_execute_action(action, peer_id)
	if action == "ACTIVATE" and self._host_chosen_card then
		managers.challenge_cards:select_challenge_card(peer_id)
	end
end

function ChallengeCardsGui:_players_inventory_loaded(params)
	if not params then
		return
	end

	if params.cards then
		-- block empty
	end
end

function ChallengeCardsGui:_players_inventory_processed(params)
	self._challenge_cards_steam_data_source = managers.challenge_cards:get_readyup_card_cache()
	self._challenge_cards_data_source = clone(self._challenge_cards_steam_data_source)

	self:reload_filtered_data()
	self._card_grid:refresh_data()
	self._challenge_cards_grid_scrollable_area:setup_scroll_area()
	self._card_grid:set_selected(true)
end

function ChallengeCardsGui:suggestions_changed()
	self._suggested_cards_grid:refresh_data()
	self._host_activates_card_grid:refresh_data()
end

function ChallengeCardsGui:close()
	managers.challenge_cards:set_automatic_steam_inventory_refresh(false)
	managers.system_event_listener:remove_listener("challenge_cards_gui_suggestions_changed")
	managers.system_event_listener:remove_listener("challenge_cards_gui_inventory_processed")
	managers.system_event_listener:remove_listener("challenge_cards_gui_steam_inventory_loaded")

	ChallengeCardsGui.PHASE = 1

	ChallengeCardsGui.super.close(self)
end

function ChallengeCardsGui:select_suggested_card(selected_item_data)
	local is_host = Network:is_server()

	if is_host then
		local key_name, peer_id, steam_instance_id

		if selected_item_data then
			key_name = selected_item_data.key_name
			peer_id = selected_item_data.peer_id
			steam_instance_id = selected_item_data.steam_instance_id
		end

		self:sync_host_selects_suggested_card(key_name, peer_id, steam_instance_id)
		managers.network:session():send_to_peers_synched("sync_host_selects_suggested_card", key_name, peer_id, steam_instance_id)
	end
end

function ChallengeCardsGui:_update_suggest_card_button()
	local local_peer = managers.network:session():local_peer()
	local suggested_card = managers.challenge_cards:get_suggested_cards()[local_peer._id]

	if managers.controller:is_using_controller() then
		return
	end

	if self._challenge_cards_data_source and #self._challenge_cards_data_source < 1 or not self._challenge_cards_data_source then
		self._suggest_card_button:disable()
		self._suggest_card_button:hide()
	elseif suggested_card and self._selected_card_data and self._selected_card_data.key_name == suggested_card.key_name or self._selected_card_data and not self._selected_card_data.steam_instances or not managers.raid_job:current_job_type() then
		self._suggest_card_button:disable()
		self._suggest_card_button:set_text(self:translate(self._unable_suggest_button_string_id, true))
	else
		self._suggest_card_button:enable()
		self._suggest_card_button:show()
		self._suggest_card_button:set_text(self:translate(self._suggest_button_string_id, true))
	end
end

function ChallengeCardsGui:_auto_select_first_card_in_grid()
	if self._challenge_cards_data_source and #self._challenge_cards_data_source >= 1 then
		self._selected_card_data = self._challenge_cards_data_source[1]

		self._card_details:set_card_details(self._selected_card_data.key_name)
		self._card_details:set_control_mode(RaidGUIControlCardDetails.MODE_SUGGESTING)
		self._suggested_cards_grid:select_grid_item_by_item(nil)
		self._card_details:show()
	else
		managers.challenge_cards:remove_suggested_challenge_card()
		self._card_details:hide()
	end

	self:_update_suggest_card_button()
end

function ChallengeCardsGui:_auto_select_same_card_in_grid()
	if not self._selected_card_data then
		self:_auto_select_first_card_in_grid()

		return
	end

	if self._challenge_cards_data_source and #self._challenge_cards_data_source >= 1 then
		self._card_details:set_card_details(self._selected_card_data.key_name)
		self._card_details:set_control_mode(RaidGUIControlCardDetails.MODE_SUGGESTING)
		self._suggested_cards_grid:select_grid_item_by_item(nil)
		self._card_details:show()
	else
		managers.challenge_cards:remove_suggested_challenge_card()
		self._card_details:hide()
	end

	self:_update_suggest_card_button()
end

function ChallengeCardsGui:update(t, dt)
	if ChallengeCardsGui.PHASE == 2 then
		if self._phase_two_timer > 0 then
			self._phase_two_timer = self._phase_two_timer - dt

			if self._phase_two_timer < 0 then
				self._phase_two_timer = 0
			end

			self._timer_label:set_text(" " .. math.floor(self._phase_two_timer))

			local x, y, w, h = self._timer_label:text_rect()

			self._timer_label:set_width(w)
			self._timer_label:set_right(self._root_panel:right())
			self._timer_icon:set_right(self._timer_label:left())
		elseif self._phase_two_timer == 0 then
			self:redirect_to_level_loading()
		end
	end
end

function ChallengeCardsGui:redirect_to_phase_two_screen()
	if not self._phase_one_completed then
		self._phase_one_completed = true

		local all_players_passed = true

		for _, suggested_card_data in pairs(managers.challenge_cards:get_suggested_cards()) do
			if not suggested_card_data.menu_skip then
				all_players_passed = false

				break
			end
		end

		if all_players_passed then
			self:phase_two_cancel()
		end

		self._phase_one_panel:set_visible(false)
		self._phase_two_panel:set_visible(true)

		if Network:is_server() then
			self._node.components.raid_menu_header:set_screen_name("menu_challenge_cards_choose_suggested_card")
		else
			self._node.components.raid_menu_header:set_screen_name("menu_challenge_cards_waiting_choose_card")
		end

		local is_host = Network:is_server()

		if is_host then
			self._phase_two_activate_button:set_visible(true)
			self._continue_without_a_card_button:set_visible(true)
		else
			self._phase_two_activate_button:set_visible(false)
			self._continue_without_a_card_button:set_visible(false)
		end

		local selected_suggested_card_item = self._host_activates_card_grid:select_first_available_item()
		local selected_suggested_card_data = selected_suggested_card_item:get_data()

		self:select_suggested_card(selected_suggested_card_data)
		self._card_grid:set_selected(false)
		self._host_activates_card_grid:set_selected(true)
	end
end

function ChallengeCardsGui:redirect_to_level_loading()
	self._phase_two_completed = true

	managers.raid_menu:close_menu(false)
	managers.global_state:fire_event(GlobalStateManager.EVENT_START_RAID)
end

function ChallengeCardsGui:bind_controller_inputs()
	local legend = {
		controller = {},
		keyboard = {},
	}
	local bindings = {}

	if ChallengeCardsGui.PHASE == 1 then
		bindings = {
			{
				callback = callback(self, self, "_on_tabs_rarity_left"),
				key = Idstring("menu_controller_shoulder_left"),
			},
			{
				callback = callback(self, self, "_on_tabs_rarity_right"),
				key = Idstring("menu_controller_shoulder_right"),
			},
			{
				callback = callback(self, self, "confirm_pressed"),
				key = Idstring("menu_controller_face_bottom"),
			},
			{
				callback = callback(self, self, "cancel_card"),
				key = Idstring("menu_controller_face_left"),
			},
			{
				callback = callback(self, self, "back_pressed"),
				key = Idstring("menu_controller_face_right"),
			},
		}

		local selection_legend_string = "menu_legend_challenge_cards_suggest_card"

		if self._is_single_player then
			selection_legend_string = "menu_legend_challenge_cards_select_card"
		end

		legend = {
			controller = {
				"menu_legend_challenge_cards_rarity",
				selection_legend_string,
				"menu_legend_challenge_cards_remove_suggestion",
				"menu_legend_back",
			},
			keyboard = {
				{
					callback = callback(self, self, "_on_legend_pc_back", nil),
					key = "footer_back",
				},
			},
		}
	elseif Network:is_server() then
		bindings = {
			{
				callback = callback(self, self, "_on_select_card_left"),
				key = Idstring("menu_controller_shoulder_left"),
			},
			{
				callback = callback(self, self, "_on_select_card_right"),
				key = Idstring("menu_controller_shoulder_right"),
			},
			{
				callback = callback(self, self, "phase_two_activate"),
				key = Idstring("menu_controller_face_bottom"),
			},
			{
				callback = callback(self, self, "_on_continue_without_card"),
				key = Idstring("menu_controller_face_top"),
			},
		}
		legend = {
			controller = {
				"menu_legend_challenge_cards_toggle",
				"menu_legend_challenge_cards_select_card",
				"menu_legend_challenge_cards_continue_without_card",
			},
			keyboard = {
				{
					callback = callback(self, self, "_on_legend_pc_back", nil),
					key = "footer_back",
				},
			},
		}
	end

	self:set_controller_bindings(bindings, true)
	self:set_legend(legend)
end

function ChallengeCardsGui:_on_tabs_rarity_left()
	self._rarity_filters_tabs:_move_left()

	return true, nil
end

function ChallengeCardsGui:_on_tabs_rarity_right()
	self._rarity_filters_tabs:_move_right()

	return true, nil
end

function ChallengeCardsGui:_on_select_card_left()
	local item_data = self._host_activates_card_grid:move_selection_left()

	self:select_suggested_card(item_data)

	return true, nil
end

function ChallengeCardsGui:_on_select_card_right()
	local item_data = self._host_activates_card_grid:move_selection_right()

	self:select_suggested_card(item_data)

	return true, nil
end

function ChallengeCardsGui:back_pressed()
	if ChallengeCardsGui.PHASE == 2 then
		return true
	end

	ChallengeCardsGui.super.back_pressed(self)
end

function ChallengeCardsGui:confirm_pressed()
	if ChallengeCardsGui.PHASE == 1 then
		self:suggest_card()
	elseif Network:is_server() then
		self:phase_two_activate()
	end
end
