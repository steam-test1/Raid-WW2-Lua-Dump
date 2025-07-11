TradeManager = TradeManager or class()

function TradeManager:init()
	self._criminals_to_respawn = {}
	self._criminals_to_add = {}
	self._trade_counter_tick = 1

	self:set_trade_countdown(true)
end

function TradeManager:save(save_data)
	if not next(self._criminals_to_respawn) then
		local my_save_data = {}

		save_data.trade = my_save_data
		my_save_data.trade_countdown = self._trade_countdown or false

		return
	end

	local my_save_data = {}

	save_data.trade = my_save_data
	my_save_data.criminals = self._criminals_to_respawn
	my_save_data.trade_countdown = self._trade_countdown or false
	my_save_data.outfits = {}

	for _, crim in ipairs(self._criminals_to_respawn) do
		if crim.peer_id then
			my_save_data.outfits[crim.peer_id] = {
				outfit = managers.network:session():peer(crim.peer_id):profile("outfit_string"),
				version = managers.network:session():peer(crim.peer_id):outfit_version(),
			}
		end
	end
end

function TradeManager:load(load_data)
	local my_load_data = load_data.trade

	if not my_load_data then
		return
	end

	if my_load_data.trade_countdown ~= nil then
		self:set_trade_countdown(my_load_data.trade_countdown)
	end

	if my_load_data.criminals then
		self._criminals_to_respawn = my_load_data.criminals
		self._criminals_to_add = {}

		for _, crim in ipairs(self._criminals_to_respawn) do
			if not crim.ai and not managers.network:session():peer(crim.peer_id) then
				if crim.peer_id then
					self._criminals_to_add[crim.peer_id] = crim

					local peer = managers.network:session():peer(crim.peer_id)
					local outfit = my_load_data.outfits[crim.peer_id]

					crim.outfit = outfit
				end
			elseif crim.peer_id then
				local peer = managers.network:session():peer(crim.peer_id)
				local outfit = my_load_data.outfits[crim.peer_id]

				peer:set_outfit_string(outfit.outfit, outfit.version)
			end
		end
	end
end

function TradeManager:handshake_complete(peer_id)
	local crim = self._criminals_to_add[peer_id]

	if crim then
		local peer = managers.network:session():peer(peer_id)

		peer:set_outfit_string(crim.outfit)
		managers.criminals:add_character(crim.id, nil, crim.peer_id, crim.ai)

		self._criminals_to_add[peer_id] = nil
	end
end

function TradeManager:is_peer_in_custody(peer_id)
	for _, crim in ipairs(self._criminals_to_respawn) do
		if crim.peer_id == peer_id then
			return true
		end
	end
end

function TradeManager:is_criminal_in_custody(name)
	for _, crim in ipairs(self._criminals_to_respawn) do
		if crim.id == name then
			return true
		end
	end
end

function TradeManager:respawn_delay_by_name(character_name)
	for _, crim in ipairs(self._criminals_to_respawn) do
		if crim.id == character_name then
			return crim.respawn_penalty
		end
	end

	return 0
end

function TradeManager:update(t, dt)
	self._t = t

	if not managers.criminals or not managers.hud then
		return
	end

	local is_trade_allowed = self:is_trade_allowed()

	self._trade_counter_tick = self._trade_counter_tick - dt

	if self._trade_counter_tick <= 0 then
		self._trade_counter_tick = self._trade_counter_tick + 1

		for _, crim in ipairs(self._criminals_to_respawn) do
			if crim.respawn_penalty > 0 then
				crim.respawn_penalty = self._trade_countdown and crim.respawn_penalty - 1 or crim.respawn_penalty

				if crim.respawn_penalty <= 0 then
					crim.respawn_penalty = 0
				end
			end
		end

		if self._trade_countdown and is_trade_allowed then
			local trade = self:get_criminal_to_trade()

			if trade then
				self:clbk_respawn_criminal(trade)
			end
		end
	end
end

function TradeManager:is_trade_allowed()
	return Network:is_server() and #self._criminals_to_respawn > 0 and not managers.groupai:state():whisper_mode()
end

function TradeManager:num_in_trade_queue()
	return #self._criminals_to_respawn
end

function TradeManager:get_criminal_to_trade()
	for _, crim in ipairs(self._criminals_to_respawn) do
		if crim.ai and crim.respawn_penalty <= 0 then
			return crim
		end
	end
end

function TradeManager:sync_set_trade_death(criminal_name, respawn_penalty, from_local)
	if not from_local then
		local crim_data = managers.criminals:character_data_by_name(criminal_name)

		if not crim_data then
			return
		end

		if crim_data.ai then
			self:on_AI_criminal_death(criminal_name, respawn_penalty)
		else
			self:on_player_criminal_death(criminal_name, respawn_penalty)
		end
	end

	self:play_custody_voice(criminal_name)

	if managers.criminals:local_character_name() == criminal_name and not Network:is_server() and game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
		game_state_machine:current_state():trade_death(respawn_penalty)
	end
end

function TradeManager:sync_set_trade_spawn(criminal_name)
	local crim_data = managers.criminals:character_data_by_name(criminal_name)

	if crim_data then
		managers.hud:set_mugshot_normal(crim_data.mugshot_id)
	end

	for i, crim in ipairs(self._criminals_to_respawn) do
		if crim.id == criminal_name then
			table.remove(self._criminals_to_respawn, i)

			break
		end
	end
end

function TradeManager:sync_set_trade_replace(replace_ai, criminal_name1, criminal_name2, respawn_penalty)
	if replace_ai then
		self:replace_ai_with_player(criminal_name1, criminal_name2, respawn_penalty)
	else
		self:replace_player_with_ai(criminal_name1, criminal_name2, respawn_penalty)
	end
end

function TradeManager:play_custody_voice(criminal_name)
	if managers.criminals:local_character_name() == criminal_name then
		return
	end

	if #self._criminals_to_respawn == 3 then
		local criminal_left

		for _, crim_data in pairs(managers.groupai:state():all_char_criminals()) do
			if alive(crim_data.unit) and not crim_data.unit:movement():downed() and not crim_data.unit:character_damage():dead() then
				criminal_left = crim_data.unit

				break
			end
		end

		if alive(criminal_left) then
			managers.dialog:queue_dialog("player_gen_only_survivor", {
				instigator = criminal_left,
				skip_idle_check = true,
			})
		end
	end
end

function TradeManager:on_AI_criminal_death(criminal_name, respawn_penalty, skip_netsend)
	print("[TradeManager:on_AI_criminal_death]", criminal_name, respawn_penalty, skip_netsend)

	if not managers.hud then
		return
	end

	local criminal_unit = managers.criminals:character_unit_by_name(criminal_name)

	if alive(criminal_unit) then
		local teammate_panel_id = criminal_unit:unit_data() and criminal_unit:unit_data().teammate_panel_id
		local name_label_id = criminal_unit:unit_data() and criminal_unit:unit_data().name_label_id

		managers.hud:on_teammate_died(teammate_panel_id, name_label_id)
	end

	local criminal = {
		ai = true,
		id = criminal_name,
		respawn_penalty = respawn_penalty,
	}

	table.insert(self._criminals_to_respawn, criminal)

	if Network:is_server() and not skip_netsend then
		managers.network:session():send_to_peers_synched("set_trade_death", criminal_name, respawn_penalty)
		self:sync_set_trade_death(criminal_name, respawn_penalty, true)
	end

	return criminal
end

function TradeManager:on_player_criminal_death(criminal_name, respawn_penalty, skip_netsend)
	for _, crim in ipairs(self._criminals_to_respawn) do
		if crim.id == criminal_name then
			Application:debug("[TradeManager:on_player_criminal_death] criminal already dead", criminal_name)

			return
		end
	end

	if respawn_penalty and tweak_data.player.damage.automatic_respawn_time then
		respawn_penalty = math.min(respawn_penalty, tweak_data.player.damage.automatic_respawn_time)
	end

	local crim_data = managers.criminals:character_data_by_name(criminal_name)

	if crim_data then
		if managers.hud then
			managers.hud:set_mugshot_custody(crim_data.mugshot_id)
		else
			debug_pause("[TradeManager:on_player_criminal_death] no hud manager! criminal_name:", criminal_name)
		end
	end

	local peer_id = managers.criminals:character_peer_id_by_name(criminal_name)
	local crim = {
		ai = false,
		id = criminal_name,
		peer_id = peer_id,
		respawn_penalty = respawn_penalty,
	}
	local inserted = false

	for i, crim_to_respawn in ipairs(self._criminals_to_respawn) do
		if crim_to_respawn.ai or respawn_penalty < crim_to_respawn.respawn_penalty then
			table.insert(self._criminals_to_respawn, i, crim)

			inserted = true

			break
		end
	end

	if not inserted then
		table.insert(self._criminals_to_respawn, crim)
	end

	if Network:is_server() and not skip_netsend then
		managers.network:session():send_to_peers_synched("set_trade_death", criminal_name, respawn_penalty)
		self:sync_set_trade_death(criminal_name, respawn_penalty, true)
	end

	print("[TradeManager:on_player_criminal_death]", criminal_name, ". Respawn queue:")

	for i, crim_to_respawn in ipairs(self._criminals_to_respawn) do
		print(inspect(crim_to_respawn))
	end

	self:on_player_criminal_removed(criminal_name)

	return crim
end

function TradeManager:set_trade_countdown(enabled)
	self._trade_countdown = enabled

	if Network:is_server() and managers.network then
		managers.network:session():send_to_peers_synched("set_trade_countdown", enabled)
	end
end

function TradeManager:replace_ai_with_player(ai_criminal, player_criminal, new_respawn_penalty)
	local first_crim = self._criminals_to_respawn[1]

	if first_crim and first_crim.id == ai_criminal then
		self:cancel_trade()
	end

	local respawn_penalty

	for i, c in ipairs(self._criminals_to_respawn) do
		if c.id == ai_criminal then
			respawn_penalty = new_respawn_penalty or c.respawn_penalty

			table.remove(self._criminals_to_respawn, i)

			break
		end
	end

	if respawn_penalty then
		if respawn_penalty <= 0 then
			respawn_penalty = 1
		end

		return self:on_player_criminal_death(player_criminal, respawn_penalty, true)
	end
end

function TradeManager:replace_player_with_ai(player_criminal, ai_criminal, new_respawn_penalty)
	local first_crim = self._criminals_to_respawn[1]

	if first_crim and first_crim.id == player_criminal then
		self:cancel_trade()
	end

	local respawn_penalty

	for i, c in ipairs(self._criminals_to_respawn) do
		if c.id == player_criminal then
			respawn_penalty = new_respawn_penalty or c.respawn_penalty

			print("replacing player in custody. respawn_penalty", respawn_penalty)
			table.remove(self._criminals_to_respawn, i)

			break
		end
	end

	if respawn_penalty then
		if respawn_penalty <= 0 then
			respawn_penalty = 1
		end

		print("managers.criminals:nr_AI_criminals()", managers.criminals:nr_AI_criminals())

		if managers.groupai:state():team_ai_enabled() and managers.groupai:state():is_AI_enabled() and managers.criminals:nr_AI_criminals() <= CriminalsManager.MAX_NR_TEAM_AI then
			return self:on_AI_criminal_death(ai_criminal, respawn_penalty, true)
		end
	end
end

function TradeManager:on_player_criminal_removed(player_criminal)
	if not Network:is_server() then
		return
	end

	local peer_id = managers.criminals:character_peer_id_by_name(player_criminal)
	local is_players_alive = false

	for u_key, u_data in pairs(managers.groupai:state():all_player_criminals()) do
		local peer = managers.network:session():peer_by_unit(u_data.unit)

		if u_data.status ~= "dead" and peer and peer:id() ~= peer_id then
			is_players_alive = true
		end
	end

	if not is_players_alive then
		self:cancel_trade()
	end
end

function TradeManager:remove_from_trade(criminal)
	local first_crim = self._criminals_to_respawn[1]

	if first_crim and first_crim.id == criminal then
		self:cancel_trade()
	end

	for i, c in ipairs(self._criminals_to_respawn) do
		if c.id == criminal then
			table.remove(self._criminals_to_respawn, i)

			break
		end
	end
end

function TradeManager:remove_all_criminals_to_respawn()
	self._criminals_to_respawn = {}
end

function TradeManager:_send_finish_trade(criminal, respawn_delay)
	if criminal.ai == true then
		return
	end

	local peer_id = managers.criminals:character_peer_id_by_name(criminal.id)

	if peer_id == 1 then
		if game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
			game_state_machine:current_state():finish_trade()
		end
	else
		local peer = managers.network:session():peer(peer_id)

		if peer then
			peer:send_queued_sync("finish_trade")
		end
	end
end

function TradeManager:_send_begin_trade(criminal)
	if criminal.ai == true then
		return
	end

	local peer_id = managers.criminals:character_peer_id_by_name(criminal.id)

	if peer_id == 1 then
		if game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
			game_state_machine:current_state():begin_trade()
		end
	else
		local peer = managers.network:session():peer(peer_id)

		if peer then
			peer:send_queued_sync("begin_trade")
		end
	end
end

function TradeManager:_send_cancel_trade(criminal)
	if criminal.ai == true then
		return
	end

	local peer_id = managers.criminals:character_peer_id_by_name(criminal.id)

	if peer_id == managers.network:session():local_peer():id() then
		if game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
			game_state_machine:current_state():cancel_trade()
		end
	else
		local peer = managers.network:session():peer(peer_id)

		if peer then
			peer:send_queued_sync("cancel_trade")
		end
	end
end

function TradeManager:cancel_trade()
	local criminal = self:get_criminal_to_trade()

	if criminal then
		self:_send_cancel_trade(criminal)
	end

	managers.groupai:state():check_gameover_conditions()
end

function TradeManager:clbk_respawn_criminal(respawn_criminal)
	if not Network:is_server() then
		return
	end

	local respawn_criminal = respawn_criminal or self:get_criminal_to_trade()

	if not respawn_criminal then
		return
	end

	local possible_criminals = {}

	for u_key, u_data in pairs(managers.groupai:state():all_char_criminals()) do
		if u_data.status ~= "dead" then
			table.insert(possible_criminals, u_data.unit)
		end
	end

	if #possible_criminals <= 0 then
		return
	end

	local spawn_on_unit = possible_criminals[math.random(1, #possible_criminals)]

	print("Found criminal to respawn ", respawn_criminal and inspect(respawn_criminal))
	table.delete(self._criminals_to_respawn, respawn_criminal)
	managers.network:session():send_to_peers_synched("set_trade_spawn", respawn_criminal.id)

	if respawn_criminal.ai then
		managers.groupai:state():spawn_one_criminal_ai(false, respawn_criminal.id, spawn_on_unit)
	end
end

function TradeManager:sync_teammate_helped_hint(helped_unit, helping_unit, hint)
	if not alive(helped_unit) or not alive(helping_unit) then
		return
	end

	local local_unit = managers.criminals:character_unit_by_name(managers.criminals:local_character_name())
	local hint_id = "teammate"

	if local_unit == helped_unit then
		hint_id = "you_were"
	elseif local_unit == helping_unit then
		hint_id = "you"
	end

	if not hint or hint == 1 then
		hint_id = hint_id .. "_revived"
	elseif hint == 2 then
		hint_id = hint_id .. "_helpedup"
	elseif hint == 3 then
		hint_id = hint_id .. "_rescued"
	end

	hint_id = "hint_" .. hint_id

	if hint_id then
		local notification_text = managers.localization:text(hint_id, {
			HELPER = helping_unit:base():nick_name(),
			TEAMMATE = helped_unit:base():nick_name(),
		})

		managers.notification:add_notification({
			duration = 3,
			id = hint_id,
			shelf_life = 5,
			text = notification_text,
		})
	end
end

function TradeManager:get_min_criminal_to_trade()
	local min_crim

	for _, crim in ipairs(self._criminals_to_respawn) do
		if not crim.ai and (not min_crim or min_crim.respawn_penalty > crim.respawn_penalty) then
			min_crim = crim
		end
	end

	return min_crim
end

function TradeManager:_set_auto_assault_ai_trade(character_name, time)
	if self._auto_assault_ai_trade_criminal_name ~= character_name then
		self._auto_assault_ai_trade_criminal_name = character_name

		if managers.network and not Global.game_settings.single_player then
			managers.network:session():send_to_peers_synched("set_auto_assault_ai_trade", character_name, time)
		end
	end
end

function TradeManager:sync_set_auto_assault_ai_trade(character_name, time)
	self._auto_assault_ai_trade_criminal_name = character_name
	self._auto_assault_ai_trade_t = time
end

function TradeManager:on_simulation_ended()
	self:remove_all_criminals_to_respawn()

	self._criminals_to_add = {}
	self._trade_counter_tick = 1
end
