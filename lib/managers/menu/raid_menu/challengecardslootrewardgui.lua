ChallengeCardsLootRewardGui = ChallengeCardsLootRewardGui or class(RaidGuiBase)
ChallengeCardsLootRewardGui.EVENT_KET_STEAM_LOOT_DROPPED = "event_key_steam_loot_dropped"

function ChallengeCardsLootRewardGui:init(ws, fullscreen_ws, node, component_name)
	ChallengeCardsLootRewardGui.super.init(self, ws, fullscreen_ws, node, component_name)
	managers.raid_menu:register_on_escape_callback(callback(self, self, "on_escape"))

	self._timer_frequency = 30
	self._timer = 31
end

function ChallengeCardsLootRewardGui:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_challenge_cards")

	self._loot_list = clone(managers.challenge_cards:get_temp_steam_loot())
end

function ChallengeCardsLootRewardGui:_layout()
	self:bind_controller_inputs()
	self:_show_loot_list(self._loot_list)
end

function ChallengeCardsLootRewardGui:_show_loot_list(loot_list)
	local coord_y = 200
	local loot_reward_card_params = {
		h = self._root_panel:h() - coord_y,
		item_params = {
			item_h = 352,
			item_w = 256,
			wrapper_h = 600,
		},
		loot_list = loot_list,
		w = self._root_panel:w(),
		x = 0,
		y = coord_y,
	}

	self._loot_cards = self._root_panel:create_custom_control(RaidGUIControlLootRewardCards, loot_reward_card_params)
end

function ChallengeCardsLootRewardGui:update(t, dt)
	return
end

function ChallengeCardsLootRewardGui:_continue_button_on_click()
	managers.raid_menu:close_menu()
end

function ChallengeCardsLootRewardGui:close()
	if self._closing then
		return
	end

	self._closing = true

	game_state_machine:current_state():continue()

	self._peer_slots = {}

	ChallengeCardsLootRewardGui.super.close(self)
end

function ChallengeCardsLootRewardGui:on_escape()
	self:_continue_button_on_click()

	return true
end

function ChallengeCardsLootRewardGui:bind_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "_continue_button_on_click"),
			key = Idstring("menu_controller_face_bottom"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_continue",
		},
		keyboard = {
			{
				callback = callback(self, self, "_continue_button_on_click", nil),
				key = "footer_continue",
			},
		},
	}

	self:set_legend(legend)
end
