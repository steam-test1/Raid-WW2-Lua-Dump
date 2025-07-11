core:import("CoreGameStateMachine")
require("lib/states/BootupState")
require("lib/states/MenuTitlescreenState")
require("lib/states/MenuMainState")
require("lib/states/EditorState")
require("lib/states/WorldCameraState")
require("lib/states/IngamePlayerBase")
require("lib/states/IngameStandard")
require("lib/states/IngameBleedOut")
require("lib/states/IngameWaitingForPlayers")
require("lib/states/IngameWaitingForRespawn")
require("lib/states/IngameElectrified")
require("lib/states/EventCompleteState")
require("lib/states/IngameSpecialInteraction")
require("lib/states/IngameDriving")
require("lib/states/IngameParachuting")
require("lib/states/IngameFreefall")
require("lib/states/IngameLoading")
require("lib/states/IngameMenu")

GameStateMachine = GameStateMachine or class(CoreGameStateMachine.GameStateMachine)

function GameStateMachine:init()
	if not Global.game_state_machine then
		Global.game_state_machine = {
			is_boot_from_sign_out = false,
			is_boot_intro_done = false,
		}
	end

	self._is_boot_intro_done = Global.game_state_machine.is_boot_intro_done
	Global.game_state_machine.is_boot_intro_done = true
	self._is_boot_from_sign_out = Global.game_state_machine.is_boot_from_sign_out
	Global.game_state_machine.is_boot_from_sign_out = false

	local setup_boot = not self._is_boot_intro_done and not Application:editor()
	local setup_title = (setup_boot or self._is_boot_from_sign_out) and not Application:editor()

	self._controller_enabled_count = 1

	local empty = GameState:new("empty", self)
	local editor = EditorState:new(self)
	local world_camera = WorldCameraState:new(self)
	local bootup = BootupState:new(self, setup_boot)
	local menu_titlescreen = MenuTitlescreenState:new(self, setup_title)
	local menu_main = MenuMainState:new(self)
	local ingame_standard = IngameStandardState:new(self)
	local ingame_bleed_out = IngameBleedOutState:new(self)
	local ingame_electrified = IngameElectrifiedState:new(self)
	local ingame_waiting_for_players = IngameWaitingForPlayersState:new(self)
	local ingame_waiting_for_respawn = IngameWaitingForRespawnState:new(self)
	local ingame_driving = IngameDriving:new(self)
	local ingame_parachuting = IngameParachuting:new(self)
	local ingame_freefall = IngameFreefall:new(self)
	local ingame_special_interaction = IngameSpecialInteraction:new(self)
	local ingame_loading = IngameLoading:new(self)
	local ingame_menu = IngameMenu:new(self)
	local event_complete_screen = EventCompleteState:new(self)
	local empty_func = callback(nil, empty, "default_transition")
	local editor_func = callback(nil, editor, "default_transition")
	local world_camera_func = callback(nil, world_camera, "default_transition")
	local bootup_func = callback(nil, bootup, "default_transition")
	local menu_titlescreen_func = callback(nil, menu_titlescreen, "default_transition")
	local menu_main_func = callback(nil, menu_main, "default_transition")
	local ingame_standard_func = callback(nil, ingame_standard, "default_transition")
	local ingame_bleed_out_func = callback(nil, ingame_bleed_out, "default_transition")
	local ingame_electrified_func = callback(nil, ingame_electrified, "default_transition")
	local ingame_waiting_for_players_func = callback(nil, ingame_waiting_for_players, "default_transition")
	local ingame_waiting_for_respawn_func = callback(nil, ingame_waiting_for_respawn, "default_transition")
	local ingame_driving_func = callback(nil, ingame_driving, "default_transition")
	local ingame_parachuting_func = callback(nil, ingame_parachuting, "default_transition")
	local ingame_freefall_func = callback(nil, ingame_freefall, "default_transition")
	local ingame_special_interaction_func = callback(nil, ingame_special_interaction, "default_transition")
	local ingame_loading_func = callback(nil, ingame_loading, "default_transition")
	local ingame_menu_func = callback(nil, ingame_menu, "default_transition")
	local event_complete_screen_func = callback(nil, event_complete_screen, "default_transition")

	CoreGameStateMachine.GameStateMachine.init(self, empty)
	self:add_transition(editor, empty, editor_func)
	self:add_transition(editor, world_camera, editor_func)
	self:add_transition(editor, editor, editor_func)
	self:add_transition(editor, ingame_standard, editor_func)
	self:add_transition(editor, ingame_parachuting, editor_func)
	self:add_transition(editor, ingame_freefall, editor_func)
	self:add_transition(editor, ingame_bleed_out, editor_func)
	self:add_transition(editor, event_complete_screen, editor_func)
	self:add_transition(editor, ingame_loading, editor_func)
	self:add_transition(editor, ingame_menu, editor_func)
	self:add_transition(editor, ingame_waiting_for_players, editor_func)
	self:add_transition(world_camera, editor, world_camera_func)
	self:add_transition(world_camera, empty, world_camera_func)
	self:add_transition(world_camera, world_camera, world_camera_func)
	self:add_transition(world_camera, ingame_standard, world_camera_func)
	self:add_transition(world_camera, ingame_parachuting, world_camera_func)
	self:add_transition(world_camera, ingame_freefall, world_camera_func)
	self:add_transition(world_camera, ingame_bleed_out, world_camera_func)
	self:add_transition(world_camera, ingame_electrified, world_camera_func)
	self:add_transition(world_camera, ingame_waiting_for_players, world_camera_func)
	self:add_transition(world_camera, ingame_waiting_for_respawn, world_camera_func)
	self:add_transition(world_camera, event_complete_screen, world_camera_func)
	self:add_transition(world_camera, ingame_loading, world_camera_func)
	self:add_transition(world_camera, ingame_menu, world_camera_func)
	self:add_transition(menu_titlescreen, menu_main, menu_titlescreen_func)
	self:add_transition(bootup, menu_titlescreen, bootup_func)
	self:add_transition(ingame_standard, editor, ingame_standard_func)
	self:add_transition(ingame_standard, world_camera, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_parachuting, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_freefall, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_bleed_out, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_electrified, ingame_standard_func)
	self:add_transition(ingame_standard, event_complete_screen, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_waiting_for_respawn, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_standard, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_waiting_for_players, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_special_interaction, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_driving, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_loading, ingame_standard_func)
	self:add_transition(ingame_standard, ingame_menu, ingame_standard_func)
	self:add_transition(ingame_special_interaction, editor, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, world_camera, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, ingame_standard, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, ingame_bleed_out, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, ingame_electrified, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, ingame_waiting_for_respawn, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, event_complete_screen, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, ingame_loading, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, ingame_menu, ingame_special_interaction_func)
	self:add_transition(ingame_special_interaction, ingame_waiting_for_players, ingame_special_interaction_func)
	self:add_transition(ingame_driving, editor, ingame_driving_func)
	self:add_transition(ingame_driving, world_camera, ingame_driving_func)
	self:add_transition(ingame_driving, ingame_standard, ingame_driving_func)
	self:add_transition(ingame_driving, ingame_bleed_out, ingame_driving_func)
	self:add_transition(ingame_driving, ingame_electrified, ingame_driving_func)
	self:add_transition(ingame_driving, ingame_waiting_for_respawn, ingame_driving_func)
	self:add_transition(ingame_driving, event_complete_screen, ingame_driving_func)
	self:add_transition(ingame_driving, ingame_loading, ingame_driving_func)
	self:add_transition(ingame_driving, ingame_menu, ingame_driving_func)
	self:add_transition(ingame_driving, ingame_waiting_for_players, ingame_driving_func)
	self:add_transition(ingame_bleed_out, editor, ingame_bleed_out_func)
	self:add_transition(ingame_bleed_out, world_camera, ingame_bleed_out_func)
	self:add_transition(ingame_bleed_out, ingame_standard, ingame_bleed_out_func)
	self:add_transition(ingame_bleed_out, event_complete_screen, ingame_bleed_out_func)
	self:add_transition(ingame_bleed_out, ingame_waiting_for_respawn, ingame_bleed_out_func)
	self:add_transition(ingame_bleed_out, ingame_loading, ingame_bleed_out_func)
	self:add_transition(ingame_bleed_out, ingame_menu, ingame_bleed_out_func)
	self:add_transition(ingame_bleed_out, ingame_waiting_for_players, ingame_bleed_out_func)
	self:add_transition(ingame_electrified, editor, ingame_electrified_func)
	self:add_transition(ingame_electrified, world_camera, ingame_electrified_func)
	self:add_transition(ingame_electrified, ingame_standard, ingame_electrified_func)
	self:add_transition(ingame_electrified, event_complete_screen, ingame_electrified_func)
	self:add_transition(ingame_electrified, ingame_bleed_out, ingame_electrified_func)
	self:add_transition(ingame_electrified, ingame_loading, ingame_electrified_func)
	self:add_transition(ingame_electrified, ingame_menu, ingame_electrified_func)
	self:add_transition(ingame_electrified, ingame_waiting_for_players, ingame_electrified_func)
	self:add_transition(ingame_waiting_for_players, ingame_standard, ingame_waiting_for_players_func)
	self:add_transition(ingame_waiting_for_players, event_complete_screen, ingame_waiting_for_players_func)
	self:add_transition(ingame_waiting_for_players, ingame_parachuting, ingame_waiting_for_players_func)
	self:add_transition(ingame_waiting_for_players, ingame_freefall, ingame_waiting_for_players_func)
	self:add_transition(ingame_waiting_for_players, ingame_loading, ingame_waiting_for_players_func)
	self:add_transition(ingame_waiting_for_players, ingame_menu, ingame_waiting_for_players_func)
	self:add_transition(ingame_waiting_for_players, world_camera, ingame_waiting_for_players_func)
	self:add_transition(ingame_waiting_for_players, ingame_waiting_for_respawn, ingame_waiting_for_players_func)
	self:add_transition(ingame_waiting_for_players, editor, ingame_waiting_for_players_func)
	self:add_transition(ingame_loading, ingame_standard, ingame_waiting_for_players_func)
	self:add_transition(ingame_loading, event_complete_screen, ingame_waiting_for_players_func)
	self:add_transition(ingame_loading, ingame_parachuting, ingame_waiting_for_players_func)
	self:add_transition(ingame_loading, ingame_freefall, ingame_waiting_for_players_func)
	self:add_transition(ingame_loading, ingame_waiting_for_players, ingame_waiting_for_players_func)
	self:add_transition(ingame_loading, world_camera, ingame_waiting_for_players_func)
	self:add_transition(ingame_loading, ingame_waiting_for_respawn, ingame_waiting_for_players_func)
	self:add_transition(ingame_loading, ingame_waiting_for_players, ingame_waiting_for_players_func)
	self:add_transition(ingame_menu, ingame_standard, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_driving, ingame_menu_func)
	self:add_transition(ingame_menu, event_complete_screen, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_menu, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_parachuting, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_freefall, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_loading, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_waiting_for_players, ingame_menu_func)
	self:add_transition(ingame_menu, world_camera, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_waiting_for_respawn, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_waiting_for_players, ingame_menu_func)
	self:add_transition(ingame_menu, ingame_bleed_out, ingame_menu_func)
	self:add_transition(ingame_waiting_for_respawn, ingame_standard, ingame_waiting_for_respawn_func)
	self:add_transition(ingame_waiting_for_respawn, editor, ingame_waiting_for_respawn_func)
	self:add_transition(ingame_waiting_for_respawn, event_complete_screen, ingame_waiting_for_respawn_func)
	self:add_transition(ingame_waiting_for_respawn, ingame_loading, ingame_waiting_for_respawn_func)
	self:add_transition(ingame_waiting_for_respawn, ingame_menu, ingame_waiting_for_respawn_func)
	self:add_transition(ingame_waiting_for_respawn, ingame_waiting_for_players, ingame_waiting_for_respawn_func)
	self:add_transition(ingame_parachuting, editor, ingame_parachuting_func)
	self:add_transition(ingame_parachuting, world_camera, ingame_parachuting_func)
	self:add_transition(ingame_parachuting, ingame_standard, ingame_parachuting_func)
	self:add_transition(ingame_parachuting, ingame_bleed_out, ingame_parachuting_func)
	self:add_transition(ingame_parachuting, event_complete_screen, ingame_parachuting_func)
	self:add_transition(ingame_parachuting, ingame_loading, ingame_parachuting_func)
	self:add_transition(ingame_parachuting, ingame_menu, ingame_parachuting_func)
	self:add_transition(ingame_parachuting, ingame_waiting_for_players, ingame_parachuting_func)
	self:add_transition(ingame_freefall, editor, ingame_freefall_func)
	self:add_transition(ingame_freefall, world_camera, ingame_freefall_func)
	self:add_transition(ingame_freefall, ingame_standard, ingame_freefall_func)
	self:add_transition(ingame_freefall, ingame_bleed_out, ingame_freefall_func)
	self:add_transition(ingame_freefall, ingame_parachuting, ingame_freefall_func)
	self:add_transition(ingame_freefall, event_complete_screen, ingame_freefall_func)
	self:add_transition(ingame_freefall, ingame_loading, ingame_freefall_func)
	self:add_transition(ingame_freefall, ingame_menu, ingame_freefall_func)
	self:add_transition(ingame_freefall, ingame_waiting_for_players, ingame_freefall_func)
	self:add_transition(event_complete_screen, ingame_standard, event_complete_screen_func)
	self:add_transition(event_complete_screen, editor, event_complete_screen_func)
	self:add_transition(event_complete_screen, ingame_bleed_out, event_complete_screen_func)
	self:add_transition(event_complete_screen, ingame_electrified, event_complete_screen_func)
	self:add_transition(event_complete_screen, world_camera, event_complete_screen_func)
	self:add_transition(event_complete_screen, empty, event_complete_screen_func)
	self:add_transition(event_complete_screen, menu_main, event_complete_screen_func)
	self:add_transition(event_complete_screen, ingame_loading, event_complete_screen_func)
	self:add_transition(event_complete_screen, ingame_waiting_for_players, event_complete_screen_func)
	self:add_transition(empty, editor, empty_func)
	self:add_transition(empty, world_camera, empty_func)
	self:add_transition(empty, bootup, empty_func)
	self:add_transition(empty, menu_titlescreen, empty_func)
	self:add_transition(empty, menu_main, empty_func)
	self:add_transition(empty, ingame_standard, empty_func)
	self:add_transition(empty, ingame_parachuting, empty_func)
	self:add_transition(empty, ingame_freefall, empty_func)
	self:add_transition(empty, ingame_bleed_out, empty_func)
	self:add_transition(empty, ingame_waiting_for_players, empty_func)
	self:add_transition(empty, ingame_waiting_for_respawn, empty_func)
	self:add_transition(empty, event_complete_screen, empty_func)
	self:add_transition(empty, ingame_loading, empty_func)
	managers.menu:add_active_changed_callback(callback(self, self, "menu_active_changed_callback"))
	managers.system_menu:add_active_changed_callback(callback(self, self, "dialog_active_changed_callback"))
end

function GameStateMachine:init_finalize()
	if managers.hud then
		managers.hud:add_chatinput_changed_callback(callback(self, self, "chatinput_changed_callback"))
	end
end

function GameStateMachine:set_boot_intro_done(is_boot_intro_done)
	Global.game_state_machine.is_boot_intro_done = is_boot_intro_done
	self._is_boot_intro_done = is_boot_intro_done
end

function GameStateMachine:is_boot_intro_done()
	return self._is_boot_intro_done
end

function GameStateMachine:set_boot_from_sign_out(is_boot_from_sign_out)
	Global.game_state_machine.is_boot_from_sign_out = is_boot_from_sign_out
end

function GameStateMachine:is_boot_from_sign_out()
	return self._is_boot_from_sign_out
end

function GameStateMachine:menu_active_changed_callback(active)
	self:_set_controller_enabled(not active)
end

function GameStateMachine:dialog_active_changed_callback(active)
	self:_set_controller_enabled(not active)
end

function GameStateMachine:chatinput_changed_callback(active)
	self:_set_controller_enabled(not active)
end

function GameStateMachine:is_controller_enabled()
	return self._controller_enabled_count > 0
end

function GameStateMachine:_set_controller_enabled(enabled)
	local was_enabled = self:is_controller_enabled()
	local old_controller_enabled_count = self._controller_enabled_count

	self._controller_enabled_count = self._controller_enabled_count + (enabled and 1 or -1)

	if not was_enabled ~= not self:is_controller_enabled() then
		local state = self:current_state()

		if state then
			state:set_controller_enabled(enabled)
		else
			self._controller_enabled_count = old_controller_enabled_count
		end
	else
		self._controller_enabled_count = old_controller_enabled_count
	end
end
