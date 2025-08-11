GlobalStateManager = GlobalStateManager or class()
GlobalStateManager.PATH = "gamedata/global_state"
GlobalStateManager.FILE_EXTENSION = "state"
GlobalStateManager.FULL_PATH = GlobalStateManager.PATH .. "." .. GlobalStateManager.FILE_EXTENSION
GlobalStateManager.GLOBAL_STATE_NAME = "global_init"
GlobalStateManager.EVENT_PRE_START_RAID = "system_pre_start_raid"
GlobalStateManager.EVENT_START_RAID = "system_start_raid"
GlobalStateManager.EVENT_END_RAID = "system_end_raid"
GlobalStateManager.EVENT_END_TUTORIAL = "system_end_tutorial"
GlobalStateManager.EVENT_LEVEL_LOADED = "system_level_loaded"
GlobalStateManager.EVENT_RESTART_CAMP = "system_restart_camp"
GlobalStateManager.EVENT_CHARACTER_CREATED = "system_character_created"

local TYPE_BOOL = "bool"
local TYPE_VALUE = "value"
local GRP_TEMPORARY = "temporary"
local GRP_OPERATION = "operation"

function GlobalStateManager:init()
	self._triggers = {}
	self._states = {}
	self._listener_holder = EventListenerHolder:new()

	self:_parse_states()
	self:add_listener("CCM_PRE_START_RAID", {
		self.EVENT_PRE_START_RAID,
	}, callback(managers.challenge_cards, managers.challenge_cards, "system_pre_start_raid"))
	self:add_listener("RM_START_RAID", {
		self.EVENT_START_RAID,
	}, callback(managers.raid_menu, managers.raid_menu, "system_start_raid"))
	self:add_listener("JM_START_MISSION", {
		self.EVENT_START_RAID,
	}, callback(managers.raid_job, managers.raid_job, "external_start_mission"))
	self:add_listener("JM_END_MISSION", {
		self.EVENT_END_RAID,
	}, callback(managers.raid_job, managers.raid_job, "external_end_mission"))
	self:add_listener("JM_END_TUTORIAL", {
		self.EVENT_END_TUTORIAL,
	}, callback(managers.raid_job, managers.raid_job, "tutorial_ended"))
	self:add_listener("OM_START_MISSION", {
		self.EVENT_START_RAID,
	}, callback(managers.objectives, managers.objectives, "on_mission_start_callback"))
	self:add_listener("WM_END_MISSION", {
		self.EVENT_END_RAID,
	}, callback(managers.warcry, managers.warcry, "on_mission_end_callback"))
	self:add_listener("TAI_END_MISSION", {
		self.EVENT_END_RAID,
	}, callback(managers.criminals, managers.criminals, "on_mission_end_callback"))
	self:add_listener("TAI_START_MISSION", {
		self.EVENT_START_RAID,
	}, callback(managers.criminals, managers.criminals, "on_mission_start_callback"))
	self:add_listener("AM_LEVEL_LOADED", {
		self.EVENT_LEVEL_LOADED,
	}, callback(managers.achievment, managers.achievment, "on_level_loaded_callback"))
end

function GlobalStateManager:add_listener(key, events, clbk)
	self._listener_holder:add(key, events, clbk)
end

function GlobalStateManager:remove_listener(key)
	self._listener_holder:remove(key)
end

function GlobalStateManager:register_trigger(trigger, flag)
	if not flag then
		Application:error("[GlobalStateManager:register_trigger] Trying to register trigger without flag!", inspect(trigger))

		return
	end

	self._triggers[flag] = self._triggers[flag] or {}

	table.insert(self._triggers[flag], trigger)
end

function GlobalStateManager:unregister_trigger(trigger, flag)
	if not flag then
		Application:error("[GlobalStateManager:register_trigger] Trying to unregister trigger without flag!", inspect(trigger))

		return
	end

	local found

	for i, trig in ipairs(self._triggers[flag]) do
		if trig == trigger then
			found = i
		end
	end

	if found then
		table.remove(self._triggers[flag], found)
	end
end

function GlobalStateManager:flag_names(state_name)
	local flag_names = {}

	for name, value in pairs(self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]) do
		table.insert(flag_names, name)
	end

	return flag_names
end

function GlobalStateManager:flag_value(flag_name, state_name)
	local flag = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME][flag_name]

	if not flag then
		return false
	end

	return flag.value
end

function GlobalStateManager:_set_temporary_flag(flag_name, state_name)
	Application:warn("[GlobalStateManager] Creating a temporary flag, this may be unreliable and is WIP!", flag_name, state_name)

	local states = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]
	local flag = {
		group = GRP_TEMPORARY,
		value = nil,
	}

	states[flag_name] = flag

	return flag
end

function GlobalStateManager:set_flag(flag_name, state_name)
	local states = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]
	local flag = states[flag_name]

	flag = flag or self:_set_temporary_flag(flag_name, state_name)

	local old_state = flag.value

	flag.value = true

	self:_fire_triggers(flag_name, old_state, true)
end

function GlobalStateManager:clear_flag(flag_name, state_name)
	local states = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]
	local flag = states[flag_name]

	flag = flag or self:_set_temporary_flag(flag_name, state_name)

	local old_state = flag.value

	flag.value = false

	self:_fire_triggers(flag_name, old_state, false)
end

function GlobalStateManager:set_value_flag(flag_name, value, state_name)
	local states = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]
	local flag = states[flag_name]

	flag = flag or self:_set_temporary_flag(flag_name, state_name)

	local old_state = flag.value

	flag.value = value

	self:_fire_triggers(flag_name, old_state, value)
end

function GlobalStateManager:add_value_flag(flag_name, value, state_name)
	local states = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]
	local flag = states[flag_name]

	flag = flag or self:_set_temporary_flag(flag_name, state_name)

	local old_value = flag.value

	if type(old_value) == "number" then
		flag.value = math.max(0, old_value + value)
	else
		debug_pause("[GlobalStateManager:add_value_flag] Trying to add to a flag that is not a number value. Flag/Value:", flag_name, old_value)
	end

	self:_fire_triggers(flag_name, old_value, flag.value)
end

function GlobalStateManager:set_to_default(flag_name, state_name)
	local states = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]
	local flag = states[flag_name]

	if flag.group == GRP_TEMPORARY then
		states[flag_name] = nil
	else
		flag.value = flag.default
	end
end

function GlobalStateManager:reset_flags_for_group(group, state_name)
	local states = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]

	for flag_name, flag in pairs(states) do
		if flag.group == group then
			self:set_to_default(flag_name, state_name)
		end
	end
end

function GlobalStateManager:reset_all_flags(state_name)
	local states = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME]

	for flag_name, flag in pairs(states) do
		self:set_to_default(flag_name, state_name)
	end
end

function GlobalStateManager:fire_event(flag_name, state_name)
	if flag_name == GlobalStateManager.EVENT_START_RAID then
		managers.raid_menu:set_pause_menu_enabled(false)
	end

	if GlobalStateManager.EVENT_START_RAID == flag_name or GlobalStateManager.EVENT_END_RAID == flag_name then
		if not managers.network:session():chk_all_peers_spawned(true) then
			Application:debug("[GlobalStateManager:fire_event] Reschedule level start!")
			managers.queued_tasks:queue(nil, managers.global_state.fire_event, managers.global_state, flag_name, 1, nil)

			self._fire_event_delay = true

			local t = Application:time()

			if not self._next_hint_t or t > self._next_hint_t then
				self._next_hint_t = t + 6

				managers.notification:add_notification({
					duration = 2,
					id = "hud_waiting_for_player_dropin",
					shelf_life = 5,
					text = managers.localization:text("hud_waiting_for_player_dropin"),
				})
			end

			return
		elseif managers.vote:is_restarting() or not managers.raid_job.reload_mission_flag and managers.game_play_central:is_restarting() then
			return
		end
	end

	if self._fire_event_delay then
		self._fire_event_delay = nil

		managers.queued_tasks:queue(nil, managers.global_state.fire_event, managers.global_state, flag_name, ElementPlayerSpawner.HIDE_LOADING_SCREEN_DELAY + 0.1, nil)

		return
	end

	local flag = self._states[state_name or GlobalStateManager.GLOBAL_STATE_NAME][flag_name]

	if not flag then
		debug_pause("[GlobalStateManager:set_flag] Trying to set a flag that is not defined, check and resave level, or add it to global_state.state. Flag:", flag_name)

		return
	end

	if self._listener_holder._listeners and self._listener_holder._listeners[flag_name] then
		self:_call_listeners(flag_name)
	end

	if not self._triggers[flag_name] then
		return
	end

	for _, trigger in ipairs(self._triggers[flag_name]) do
		trigger:execute(flag_name, nil, true)
	end
end

function GlobalStateManager:sync_save(data)
	local state = {
		data = self._states,
	}

	data.GlobalStateManager = state
end

function GlobalStateManager:sync_load(data)
	local state = data.GlobalStateManager

	if state then
		self._states = state.data
	end
end

function GlobalStateManager:get_all_global_states()
	local global_states = {}

	for id, data in pairs(self._states.global_init) do
		table.insert(global_states, {
			id = id,
			value = data.value,
		})
	end

	return global_states
end

function GlobalStateManager:set_global_states(states)
	for i = 1, #states do
		if states[i] and states[i].value ~= nil then
			local flag_name = states[i].id
			local flag = self._states.global_init[flag_name]

			flag = flag or self:_set_temporary_flag(flag_name)
			flag.value = states[i].value
		else
			Application:warn("[GlobalStateManager:set_global_states] no states value for", i, inspect(states[i] or {}))
		end
	end
end

function GlobalStateManager:sync_global_states()
	if managers.network:session() then
		local global_state_string = managers.global_state:get_modified_flags_longstring()

		Application:info("[GlobalStateManager:sync_global_states] Sending peers state string:", global_state_string)
		managers.network:session():send_to_peers_synched("sync_global_state", global_state_string)
	end
end

function GlobalStateManager:get_modified_flags_longstring()
	local longstring = ""
	local global_states = self:get_modified_flags()

	for _, data in ipairs(global_states) do
		longstring = longstring .. tostring(data.id) .. "|" .. tostring(data.value) .. "|"
	end

	return longstring
end

function GlobalStateManager:get_modified_flags()
	local global_states = {}

	for id, data in pairs(self._states.global_init) do
		if data.group == GRP_TEMPORARY or data.value ~= data.default then
			table.insert(global_states, {
				group = data.group,
				id = id,
				value = data.value,
			})
		end
	end

	return global_states
end

function GlobalStateManager:save_game(data)
	local global_states = self:get_modified_flags()

	Application:info("[GlobalStateManager:save_game] Saving these IDs", inspect(global_states))

	data.global_state = global_states
end

function GlobalStateManager:load_game(data)
	if data.global_state then
		self:reset_all_flags()
		Application:info("[GlobalStateManager:load_game] Loading these IDs", inspect(data.global_state))

		for i = 1, #data.global_state do
			local sav_id = data.global_state[i].id

			if self._states.global_init[sav_id] then
				local sav_value = data.global_state[i].value

				self._states.global_init[sav_id].value = sav_value
			end
		end
	end
end

function GlobalStateManager:on_simulation_ended()
	self._triggers = {}
	self._states = {}

	self:_parse_states()
end

function GlobalStateManager:check_flag_value(check_type, value1, value2)
	local type_matches = type(value1) == type(value2)
	local type_numbers = type(value1) == "number" and type(value2) == "number"

	if check_type == "equal" then
		return type_matches and value2 == value1
	elseif check_type == "not_equal" then
		return type_matches and value2 ~= value1
	elseif check_type == "less_or_equal" then
		return type_numbers and value2 <= value1
	elseif check_type == "greater_or_equal" then
		return type_numbers and value1 <= value2
	elseif check_type == "less_than" then
		return type_numbers and value2 < value1
	elseif check_type == "greater_than" then
		return type_numbers and value1 < value2
	end

	Application:error("[GlobalStateManager:check_flag_value] check_type was not applicable. Bad check_type:", check_type, value1, value2)
end

function GlobalStateManager:_parse_states()
	Application:info("[GlobalStateManager] Parsing...", self.FILE_EXTENSION:id(), self.PATH:id())

	local list = PackageManager:script_data(self.FILE_EXTENSION:id(), self.PATH:id())
	local states = list.states

	for _, state in ipairs(states) do
		for _, flag in ipairs(state) do
			if flag._meta == "flag" then
				self._states = self._states or {}
				self._states[state.id] = self._states[state.id] or {}
				self._states[state.id][flag.id] = self._states[state.id][flag.id] or {}

				local state = self._states[state.id][flag.id]

				state.group = flag.group
				state.data_type = flag.data_type or TYPE_BOOL
				state.value = self:_parse_value(flag.value, state.data_type)
				state.default = self:_parse_value(flag.value, state.data_type)
			else
				Application:error("Unknown node \"" .. tostring(data._meta) .. "\" in \"" .. self.FULL_PATH .. "\". Expected \"flag\" node.")
			end
		end
	end
end

function GlobalStateManager:_parse_value(value, data_type)
	if data_type == TYPE_VALUE then
		return value
	elseif value == "set" then
		return true
	elseif value == "cleared" then
		return false
	end
end

function GlobalStateManager:_fire_triggers(flag, old_state, new_state)
	Application:info("[GlobalStateManager:_fire_triggers] flag, old, new", flag, old_state, new_state)

	if old_state == new_state then
		return
	end

	if not self._triggers[flag] then
		return
	end

	for _, trigger in ipairs(self._triggers[flag]) do
		trigger:execute(flag, new_state)
	end
end

function GlobalStateManager:_call_listeners(event, params)
	self._listener_holder:call(event, params)
end
