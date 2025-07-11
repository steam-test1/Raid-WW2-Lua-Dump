require("lib/managers/menu/raid_menu/RaidGuiBase")
require("lib/managers/menu/raid_menu/WeaponSelectionGui")
require("lib/managers/menu/raid_menu/CharacterSelectionGui")
require("lib/managers/menu/raid_menu/CharacterCreationGui")
require("lib/managers/menu/raid_menu/CharacterCustomizationGui")
require("lib/managers/menu/raid_menu/ChallengeCardsGui")
require("lib/managers/menu/raid_menu/ChallengeCardsViewGui")
require("lib/managers/menu/raid_menu/ChallengeCardsLootRewardGui")
require("lib/managers/menu/raid_menu/MissionJoinGui")
require("lib/managers/menu/raid_menu/MissionSelectionGui")
require("lib/managers/menu/raid_menu/MissionUnlockGui")
require("lib/managers/menu/raid_menu/RaidMainMenuGui")
require("lib/managers/menu/raid_menu/RaidMenuHeader")
require("lib/managers/menu/raid_menu/RaidMenuFooter")
require("lib/managers/menu/raid_menu/RaidMenuLeftOptions")
require("lib/managers/menu/raid_menu/RaidMenuOptionsControls")
require("lib/managers/menu/raid_menu/RaidMenuOptionsControlsKeybinds")
require("lib/managers/menu/raid_menu/RaidMenuOptionsControlsControllerMapping")
require("lib/managers/menu/raid_menu/RaidMenuOptionsVideo")
require("lib/managers/menu/raid_menu/RaidMenuOptionsVideoAdvanced")
require("lib/managers/menu/raid_menu/RaidMenuOptionsSound")
require("lib/managers/menu/raid_menu/RaidMenuOptionsInterface")
require("lib/managers/menu/raid_menu/RaidMenuOptionsNetwork")
require("lib/managers/menu/raid_menu/RaidMenuCreditsGui")
require("lib/managers/menu/raid_menu/RaidOptionsBackground")
require("lib/managers/menu/raid_menu/ReadyUpGui")
require("lib/managers/menu/raid_menu/LootScreenGui")
require("lib/managers/menu/raid_menu/GreedLootScreenGui")
require("lib/managers/menu/raid_menu/ExperienceGui")
require("lib/managers/menu/raid_menu/PostGameBreakdownGui")
require("lib/managers/menu/raid_menu/GoldAssetStoreGui")
require("lib/managers/menu/raid_menu/IntelGui")
require("lib/managers/menu/raid_menu/ComicBookGui")
require("lib/managers/menu/raid_menu/SpecialHonorsGui")
require("lib/managers/menu/raid_menu/RaidMenuProfileSwitcher")
require("lib/managers/hud/HUDPlayerVoiceChatStatus")

MenuComponentManager = MenuComponentManager or class()

function MenuComponentManager:init()
	self._ws = Overlay:gui():create_screen_workspace()
	self._fullscreen_ws = managers.gui_data:create_fullscreen_16_9_workspace()

	managers.gui_data:layout_workspace(self._ws)

	self._main_panel = self._ws:panel():panel()
	self._requested_textures = {}
	self._block_texture_requests = false
	self._sound_source = SoundDevice:create_source("MenuComponentManager")
	self._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(self, self, "resolution_changed"))
	self._request_done_clbk_func = callback(self, self, "_request_done_callback")
	self._active_components = {}
	self._active_components.raid_menu_mission_selection = {
		close = callback(self, self, "close_raid_menu_mission_selection_gui"),
		create = callback(self, self, "create_raid_menu_mission_selection_gui"),
	}
	self._active_components.raid_menu_mission_unlock = {
		close = callback(self, self, "close_raid_menu_mission_unlock_gui"),
		create = callback(self, self, "create_raid_menu_mission_unlock_gui"),
	}
	self._active_components.raid_menu_mission_join = {
		close = callback(self, self, "close_raid_menu_mission_join_gui"),
		create = callback(self, self, "create_raid_menu_mission_join_gui"),
	}
	self._active_components.raid_menu_weapon_select = {
		close = callback(self, self, "close_raid_menu_weapon_select_gui"),
		create = callback(self, self, "create_raid_menu_weapon_select_gui"),
	}
	self._active_components.raid_menu_profile_selection = {
		close = callback(self, self, "close_raid_menu_select_character_profile_gui"),
		create = callback(self, self, "create_raid_menu_select_character_profile_gui"),
	}
	self._active_components.raid_menu_profile_creation = {
		close = callback(self, self, "close_raid_menu_create_character_profile_gui"),
		create = callback(self, self, "create_raid_menu_create_character_profile_gui"),
	}
	self._active_components.raid_menu_character_customization = {
		close = callback(self, self, "close_raid_menu_character_customization_gui"),
		create = callback(self, self, "create_raid_menu_character_customization_gui"),
	}
	self._active_components.raid_menu_main = {
		close = callback(self, self, "close_raid_menu_main_menu_gui"),
		create = callback(self, self, "create_raid_menu_main_menu_gui"),
	}
	self._active_components.raid_menu_header = {
		close = callback(self, self, "close_raid_menu_header_gui"),
		create = callback(self, self, "create_raid_menu_header_gui"),
	}
	self._active_components.raid_menu_footer = {
		close = callback(self, self, "close_raid_menu_footer_gui"),
		create = callback(self, self, "create_raid_menu_footer_gui"),
	}
	self._active_components.raid_menu_left_options = {
		close = callback(self, self, "close_raid_menu_left_options_gui"),
		create = callback(self, self, "create_raid_menu_left_options_gui"),
	}
	self._active_components.raid_menu_options_controls = {
		close = callback(self, self, "close_raid_menu_options_controls_gui"),
		create = callback(self, self, "create_raid_menu_options_controls_gui"),
	}
	self._active_components.raid_menu_options_controls_keybinds = {
		close = callback(self, self, "close_raid_menu_options_controls_keybinds_gui"),
		create = callback(self, self, "create_raid_menu_options_controls_keybinds_gui"),
	}
	self._active_components.raid_menu_options_controller_mapping = {
		close = callback(self, self, "close_raid_menu_options_controller_mapping_gui"),
		create = callback(self, self, "create_raid_menu_options_controller_mapping_gui"),
	}
	self._active_components.raid_menu_options_sound = {
		close = callback(self, self, "close_raid_menu_options_sound_gui"),
		create = callback(self, self, "create_raid_menu_options_sound_gui"),
	}
	self._active_components.raid_menu_options_network = {
		close = callback(self, self, "close_raid_menu_options_network_gui"),
		create = callback(self, self, "create_raid_menu_options_network_gui"),
	}
	self._active_components.raid_menu_options_video = {
		close = callback(self, self, "close_raid_menu_options_video_gui"),
		create = callback(self, self, "create_raid_menu_options_video_gui"),
	}
	self._active_components.raid_menu_options_video_advanced = {
		close = callback(self, self, "close_raid_menu_options_video_advanced_gui"),
		create = callback(self, self, "create_raid_menu_options_video_advanced_gui"),
	}
	self._active_components.raid_menu_options_interface = {
		close = callback(self, self, "close_raid_menu_options_interface_gui"),
		create = callback(self, self, "create_raid_menu_options_interface_gui"),
	}
	self._active_components.raid_options_background = {
		close = callback(self, self, "close_raid_options_background_gui"),
		create = callback(self, self, "create_raid_options_background_gui"),
	}
	self._active_components.raid_menu_ready_up = {
		close = callback(self, self, "close_raid_ready_up_gui"),
		create = callback(self, self, "create_raid_ready_up_gui"),
	}
	self._active_components.raid_menu_challenge_cards = {
		close = callback(self, self, "close_raid_challenge_cards_gui"),
		create = callback(self, self, "create_raid_challenge_cards_gui"),
	}
	self._active_components.raid_menu_challenge_cards_view = {
		close = callback(self, self, "close_raid_challenge_cards_view_gui"),
		create = callback(self, self, "create_raid_challenge_cards_view_gui"),
	}
	self._active_components.raid_menu_challenge_cards_loot_reward = {
		close = callback(self, self, "close_raid_challenge_cards_loot_reward_gui"),
		create = callback(self, self, "create_raid_challenge_cards_loot_reward_gui"),
	}
	self._active_components.raid_menu_xp = {
		close = callback(self, self, "close_raid_menu_xp"),
		create = callback(self, self, "create_raid_menu_xp"),
	}
	self._active_components.raid_menu_post_game_breakdown = {
		close = callback(self, self, "close_raid_menu_post_game_breakdown"),
		create = callback(self, self, "create_raid_menu_post_game_breakdown"),
	}
	self._active_components.raid_menu_special_honors = {
		close = callback(self, self, "close_raid_menu_special_honors"),
		create = callback(self, self, "create_raid_menu_special_honors"),
	}
	self._active_components.raid_menu_loot = {
		close = callback(self, self, "close_raid_menu_loot"),
		create = callback(self, self, "create_raid_menu_loot"),
	}
	self._active_components.raid_menu_greed_loot = {
		close = callback(self, self, "close_raid_menu_greed_loot"),
		create = callback(self, self, "create_raid_menu_greed_loot"),
	}
	self._active_components.raid_menu_gold_asset_store = {
		close = callback(self, self, "close_raid_menu_gold_asset_store_gui"),
		create = callback(self, self, "create_raid_menu_gold_asset_store_gui"),
	}
	self._active_components.raid_menu_intel = {
		close = callback(self, self, "close_raid_menu_intel_gui"),
		create = callback(self, self, "create_raid_menu_intel_gui"),
	}
	self._active_components.raid_menu_comic_book = {
		close = callback(self, self, "close_raid_menu_comic_book_gui"),
		create = callback(self, self, "create_raid_menu_comic_book_gui"),
	}
	self._active_components.raid_menu_credits = {
		close = callback(self, self, "close_raid_menu_credits"),
		create = callback(self, self, "create_raid_menu_credits"),
	}
	self._active_controls = {}
	self._update_components = {}

	self._sound_source:post_event("close_pause_menu")
end

function MenuComponentManager:get_controller_input_bool(button)
	if not managers.menu or not managers.menu:active_menu() then
		return
	end

	local controller = managers.menu:active_menu().input:get_controller_class()

	if managers.menu:active_menu().input:get_accept_input() then
		return controller:get_input_bool(button)
	end
end

function MenuComponentManager:_setup_controller_input()
	if not self._controller_connected then
		self._left_axis_vector = Vector3()
		self._right_axis_vector = Vector3()

		if managers.menu:active_menu() then
			self._fullscreen_ws:connect_controller(managers.menu:active_menu().input:get_controller(), true)
			self._fullscreen_ws:panel():axis_move(callback(self, self, "_axis_move"))
		end

		self._controller_connected = true
	end
end

function MenuComponentManager:_destroy_controller_input()
	if self._controller_connected then
		self._fullscreen_ws:disconnect_all_controllers()

		if alive(self._fullscreen_ws:panel()) then
			self._fullscreen_ws:panel():axis_move(nil)
		end

		self._controller_connected = nil

		if IS_PC then
			self._fullscreen_ws:disconnect_keyboard()
			self._fullscreen_ws:panel():key_press(nil)
		end
	end
end

function MenuComponentManager:saferect_ws()
	return self._ws
end

function MenuComponentManager:fullscreen_ws()
	return self._fullscreen_ws
end

function MenuComponentManager:resolution_changed()
	managers.gui_data:layout_workspace(self._ws)
	managers.gui_data:layout_fullscreen_16_9_workspace(self._fullscreen_ws)

	if self._tcst then
		managers.gui_data:layout_fullscreen_16_9_workspace(self._tcst)
	end
end

function MenuComponentManager:_axis_move(o, axis_name, axis_vector, controller)
	if axis_name == Idstring("left") then
		mvector3.set(self._left_axis_vector, axis_vector)
	elseif axis_name == Idstring("right") then
		mvector3.set(self._right_axis_vector, axis_vector)
	end
end

function MenuComponentManager:set_active_components(components, node)
	local to_close = {}

	for component, _ in pairs(self._active_components) do
		to_close[component] = true
	end

	for _, component in ipairs(components) do
		local component_data = self._active_components[component]

		if component_data then
			to_close[component] = nil

			local component_object = component_data.create(node, component)

			component_data.component_object = component_object
		end
	end

	for component, _ in pairs(to_close) do
		local component_data = self._active_components[component]

		component_data.close(node, component)

		component_data.component_object = nil
	end

	if not managers.menu:is_pc_controller() then
		self:_setup_controller_input()
	end
end

function MenuComponentManager:update(t, dt)
	for _, component in pairs(self._update_components) do
		if component then
			component:update(t, dt)
		end
	end
end

function MenuComponentManager:get_left_controller_axis()
	if managers.menu:is_pc_controller() or not self._left_axis_vector then
		return 0, 0
	end

	local x = mvector3.x(self._left_axis_vector)
	local y = mvector3.y(self._left_axis_vector)

	return x, y
end

function MenuComponentManager:get_right_controller_axis()
	if managers.menu:is_pc_controller() or not self._right_axis_vector then
		return 0, 0
	end

	local x = mvector3.x(self._right_axis_vector)
	local y = mvector3.y(self._right_axis_vector)

	return x, y
end

function MenuComponentManager:accept_input(accept)
	return
end

function MenuComponentManager:input_focus()
	if managers.system_menu and managers.system_menu:is_active() and not managers.system_menu:is_closing() then
		return true
	end
end

function MenuComponentManager:scroll_up()
	return
end

function MenuComponentManager:scroll_down()
	return
end

function MenuComponentManager:move_up()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled, target = component.component_object:move_up()

			if handled then
				return true
			end

			if not handled and target then
				return self:_set_active_control(target)
			end
		end
	end
end

function MenuComponentManager:move_down()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled, target = component.component_object:move_down()

			if handled then
				return true
			end

			if not handled and target then
				return self:_set_active_control(target)
			end
		end
	end
end

function MenuComponentManager:move_left()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled, target = component.component_object:move_left()

			if handled then
				return true
			end

			if not handled and target then
				return self:_set_active_control(target)
			end
		end
	end
end

function MenuComponentManager:_set_active_control(target_control_name)
	for _, active_control in pairs(self._active_controls) do
		if active_control[target_control_name] then
			managers.raid_menu:set_active_control(active_control[target_control_name])
			active_control[target_control_name]:set_selected(true)
		end
	end
end

function MenuComponentManager:move_right()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled, target = component.component_object:move_right()

			if handled then
				return true
			end

			if not handled and target then
				return self:_set_active_control(target)
			end
		end
	end
end

function MenuComponentManager:scroll_up()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled, target = component.component_object:scroll_up()

			if handled then
				return true
			end
		end
	end
end

function MenuComponentManager:scroll_down()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled, target = component.component_object:scroll_down()

			if handled then
				return true
			end
		end
	end
end

function MenuComponentManager:scroll_left()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled, target = component.component_object:scroll_left()

			if handled then
				return true
			end
		end
	end
end

function MenuComponentManager:scroll_right()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled, target = component.component_object:scroll_right()

			if handled then
				return true
			end
		end
	end
end

function MenuComponentManager:next_page()
	return
end

function MenuComponentManager:previous_page()
	return
end

function MenuComponentManager:confirm_pressed()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled = component.component_object:confirm_pressed()

			if handled then
				return true
			end
		end
	end

	if Application:production_build() and self._debug_font_gui then
		self._debug_font_gui:toggle()
	end
end

function MenuComponentManager:back_pressed()
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled = component.component_object:back_pressed()

			if handled then
				return true
			end
		end
	end
end

function MenuComponentManager:special_btn_pressed(...)
	for _, component in pairs(self._active_components) do
		if component.component_object and component.component_object.special_btn_pressed then
			local handled, target = component.component_object:special_btn_pressed(...)

			if handled then
				return true
			end

			if not handled and target then
				return self:_set_active_control(target)
			end
		end
	end
end

function MenuComponentManager:mouse_pressed(o, button, x, y)
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled = component.component_object:mouse_pressed(o, button, x, y)

			if handled then
				return true
			end
		end
	end

	if self._minimized_list and button == Idstring("0") then
		for i, data in ipairs(self._minimized_list) do
			if data.panel:inside(x, y) then
				data.callback(data)

				break
			end
		end
	end
end

function MenuComponentManager:mouse_clicked(o, button, x, y)
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled = component.component_object:mouse_clicked(o, button, x, y)

			if handled then
				return true
			end
		end
	end
end

function MenuComponentManager:mouse_double_click(o, button, x, y)
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled = component.component_object:mouse_double_click(o, button, x, y)

			if handled then
				return true
			end
		end
	end
end

function MenuComponentManager:mouse_released(o, button, x, y)
	for _, component in pairs(self._active_components) do
		if component.component_object then
			local handled = component.component_object:mouse_released(o, button, x, y)

			if handled then
				return true
			end
		end
	end

	return false
end

function MenuComponentManager:mouse_moved(o, x, y)
	local wanted_pointer = "arrow"

	for _, component in pairs(self._active_components) do
		if component.component_object then
			local used, pointer = component.component_object:mouse_moved(o, x, y)

			wanted_pointer = pointer or wanted_pointer

			if used then
				return true, wanted_pointer
			end
		end
	end

	if self._minimized_list then
		for i, data in ipairs(self._minimized_list) do
			if data.mouse_over ~= data.panel:inside(x, y) then
				data.mouse_over = data.panel:inside(x, y)

				data.text:set_font(data.mouse_over and tweak_data.menu.default_font_no_outline_id or Idstring(tweak_data.menu.default_font))
				data.text:set_color(data.mouse_over and Color.black or Color.white)
				data.selected:set_visible(data.mouse_over)
				data.help_text:set_visible(data.mouse_over)
			end

			data.help_text:set_position(x + 12, y + 12)
		end
	end

	return false, wanted_pointer
end

function MenuComponentManager:peer_outfit_updated(peer_id)
	return
end

function MenuComponentManager:on_peer_removed(peer, reason)
	return
end

function MenuComponentManager:add_minimized(config)
	self._minimized_list = self._minimized_list or {}
	self._minimized_id = (self._minimized_id or 0) + 1

	local panel = self._main_panel:panel({
		h = 20,
		layer = tweak_data.gui.MENU_COMPONENT_LAYER,
		w = 100,
	})
	local text

	if config.text then
		text = panel:text({
			align = "center",
			font = tweak_data.menu.default_font,
			font_size = 22,
			halign = "left",
			hvertical = "center",
			layer = 2,
			text = config.text,
			vertical = "center",
		})

		text:set_center_y(panel:center_y())

		local _, _, w, h = text:text_rect()

		text:set_size(w + 8, h)
		panel:set_size(w + 8, h)
	end

	local help_text = panel:parent():text({
		align = "left",
		color = Color.white,
		font = tweak_data.menu.small_font,
		font_size = tweak_data.menu.small_font_size,
		halign = "left",
		hvertical = "center",
		layer = 3,
		text = config.help_text or "CLICK TO MAXIMIZE WEAPON INFO",
		vertical = "center",
		visible = false,
	})

	help_text:set_shape(help_text:text_rect())

	local unselected = panel:bitmap({
		layer = 0,
		texture = "guis/textures/menu_unselected",
	})

	unselected:set_h(64 * panel:h() / 32)
	unselected:set_center_y(panel:center_y())

	local selected = panel:bitmap({
		layer = 1,
		texture = "guis/textures/menu_selected",
		visible = false,
	})

	selected:set_h(64 * panel:h() / 32)
	selected:set_center_y(panel:center_y())
	panel:set_bottom(self._main_panel:h() - CoreMenuRenderer.Renderer.border_height)

	local top_line = panel:parent():bitmap({
		layer = 1,
		texture = "guis/textures/headershadow",
		visible = false,
		w = panel:w(),
	})

	top_line:set_bottom(panel:top())
	table.insert(self._minimized_list, {
		callback = config.callback,
		help_text = help_text,
		id = self._minimized_id,
		mouse_over = false,
		panel = panel,
		selected = selected,
		text = text,
		top_line = top_line,
	})
	self:_layout_minimized()

	return self._minimized_id
end

function MenuComponentManager:_layout_minimized()
	local x = 0

	for i, data in ipairs(self._minimized_list) do
		data.panel:set_x(x)
		data.top_line:set_x(x)

		x = x + data.panel:w() + 2
	end
end

function MenuComponentManager:remove_minimized(id)
	for i, data in ipairs(self._minimized_list) do
		if data.id == id then
			data.help_text:parent():remove(data.help_text)
			data.top_line:parent():remove(data.top_line)
			self._main_panel:remove(data.panel)
			table.remove(self._minimized_list, i)

			break
		end
	end

	self:_layout_minimized()
end

function MenuComponentManager:_request_done_callback(texture_ids)
	local key = texture_ids:key()
	local entry = self._requested_textures[key]

	if not entry then
		return
	end

	local clbks = {}

	for index, owner_data in pairs(entry.owners) do
		table.insert(clbks, owner_data.clbk)

		owner_data.clbk = nil
	end

	for _, clbk in pairs(clbks) do
		clbk(texture_ids)
	end
end

function MenuComponentManager:request_texture(texture, done_cb)
	if self._block_texture_requests then
		debug_pause(string.format("[MenuComponentManager:request_texture] Requesting texture is blocked! %s", texture))

		return false
	end

	local texture_ids = Idstring(texture)

	if not DB:has(Idstring("texture"), texture_ids) then
		Application:error(string.format("[MenuComponentManager:request_texture] No texture entry named \"%s\" in database.", texture))

		return false
	end

	local key = texture_ids:key()
	local entry = self._requested_textures[key]

	if not entry then
		entry = {
			next_index = 1,
			owners = {},
			texture_ids = texture_ids,
		}
		self._requested_textures[key] = entry
	end

	local index = entry.next_index

	entry.owners[index] = {
		clbk = done_cb,
	}

	local next_index = index + 1

	while entry.owners[next_index] do
		if index == next_index then
			debug_pause("[MenuComponentManager:request_texture] overflow!")
		end

		next_index = next_index + 1

		if next_index == 10000 then
			next_index = 1
		end
	end

	entry.next_index = next_index

	TextureCache:request(texture_ids, "NORMAL", callback(self, self, "_request_done_callback"), 100)

	return index
end

function MenuComponentManager:unretrieve_texture(texture, index)
	local texture_ids = Idstring(texture)
	local key = texture_ids:key()
	local entry = self._requested_textures[key]

	if entry and entry.owners[index] then
		entry.owners[index] = nil

		if not next(entry.owners) then
			self._requested_textures[key] = nil
		end

		TextureCache:unretrieve(texture_ids)
	end
end

function MenuComponentManager:retrieve_texture(texture)
	return TextureCache:retrieve(texture, "NORMAL")
end

MenuComponentPostEventInstance = MenuComponentPostEventInstance or class()

function MenuComponentPostEventInstance:init(sound_source)
	self._sound_source = sound_source
	self._post_event = false
end

function MenuComponentPostEventInstance:post_event(event)
	if alive(self._post_event) then
		self._post_event:stop()
	end

	self._post_event = false

	if alive(self._sound_source) then
		self._post_event = self._sound_source:post_event(event)
	end
end

function MenuComponentPostEventInstance:stop_event()
	if alive(self._post_event) then
		self._post_event:stop()
	end

	self._post_event = false
end

function MenuComponentManager:new_post_event_instance()
	local event_instance = MenuComponentPostEventInstance:new(self._sound_source)

	self._unique_event_instances = self._unique_event_instances or {}

	table.insert(self._unique_event_instances, event_instance)

	return event_instance
end

function MenuComponentManager:post_event(event, unique)
	if alive(self._post_event) then
		self._post_event:stop()

		self._post_event = nil
	end

	local post_event = self._sound_source:post_event(event)

	if unique then
		self._post_event = post_event
	end

	return post_event
end

function MenuComponentManager:stop_event()
	print("MenuComponentManager:stop_event()")

	if alive(self._post_event) then
		self._post_event:stop()

		self._post_event = nil
	end
end

function MenuComponentManager:close()
	print("[MenuComponentManager:close]")

	if alive(self._sound_source) then
		self._sound_source:stop()
	end

	self:_destroy_controller_input()
	self:close_menu_alert()

	if self._requested_textures then
		for key, entry in pairs(self._requested_textures) do
			TextureCache:unretrieve(entry.texture_ids)
		end
	end

	self._requested_textures = {}
	self._block_texture_requests = true
end

function MenuComponentManager:create_raid_menu_mission_selection_gui(node, component)
	return self:_create_raid_menu_mission_selection_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_mission_selection_gui(node, component)
	self:close_raid_menu_mission_selection_gui(node, component)

	self._raid_menu_mission_selection_gui = MissionSelectionGui:new(self._ws, self._fullscreen_ws, node, component)

	table.insert(self._update_components, self._raid_menu_mission_selection_gui)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_mission_selection_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list.raid_list = self._raid_menu_mission_selection_gui._raid_list
		final_list.new_operation_list = self._raid_menu_mission_selection_gui._new_operation_list
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_mission_selection_gui
end

function MenuComponentManager:close_raid_menu_mission_selection_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_mission_selection_gui then
		self:remove_update_component(self._raid_menu_mission_selection_gui)
		self._raid_menu_mission_selection_gui:close()

		self._raid_menu_mission_selection_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_mission_unlock_gui(node, component)
	return self:_create_raid_menu_mission_unlock_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_mission_unlock_gui(node, component)
	self:close_raid_menu_mission_unlock_gui(node, component)

	self._raid_menu_mission_unlock_gui = MissionUnlockGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_mission_unlock_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list.raid_list = self._raid_menu_mission_unlock_gui._raid_list
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	table.insert(self._update_components, self._raid_menu_mission_unlock_gui)

	return self._raid_menu_mission_unlock_gui
end

function MenuComponentManager:close_raid_menu_mission_unlock_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_mission_unlock_gui then
		self:remove_update_component(self._raid_menu_mission_unlock_gui)
		self._raid_menu_mission_unlock_gui:close()

		self._raid_menu_mission_unlock_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_mission_join_gui(node, component)
	return self:_create_raid_menu_mission_join_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_mission_join_gui(node, component)
	self:close_raid_menu_mission_join_gui(node, component)

	self._raid_menu_mission_join_gui = MissionJoinGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_mission_join_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_mission_join_gui
end

function MenuComponentManager:close_raid_menu_mission_join_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_mission_join_gui then
		self._raid_menu_mission_join_gui:close()

		self._raid_menu_mission_join_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_weapon_select_gui(node, component)
	return self:_create_raid_menu_weapon_select_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_weapon_select_gui(node, component)
	self:close_raid_menu_weapon_select_gui(node, component)

	self._raid_menu_weapon_select_gui = WeaponSelectionGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_weapon_select_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list.weapon_list = self._raid_menu_weapon_select_gui._weapon_list
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_weapon_select_gui
end

function MenuComponentManager:close_raid_menu_weapon_select_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_weapon_select_gui then
		self._raid_menu_weapon_select_gui:close()

		self._raid_menu_weapon_select_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_main_menu_gui(node, component)
	return self:_create_raid_menu_main_menu_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_main_menu_gui(node, component)
	self:close_raid_menu_main_menu_gui(node, component)

	self._raid_menu_main_menu_gui = RaidMainMenuGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_main_menu_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_main_menu_gui
end

function MenuComponentManager:close_raid_menu_main_menu_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_main_menu_gui then
		self._raid_menu_main_menu_gui:close()

		self._raid_menu_main_menu_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_select_character_profile_gui(node, component)
	return self:_create_raid_menu_select_character_profile_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_select_character_profile_gui(node, component)
	self:close_raid_menu_select_character_profile_gui(node, component)

	self._raid_menu_select_character_profile_gui = CharacterSelectionGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_select_character_profile_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	table.insert(self._update_components, self._raid_menu_select_character_profile_gui)

	return self._raid_menu_select_character_profile_gui
end

function MenuComponentManager:close_raid_menu_select_character_profile_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_select_character_profile_gui then
		self:remove_update_component(self._raid_menu_select_character_profile_gui)
		self._raid_menu_select_character_profile_gui:close()

		self._raid_menu_select_character_profile_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_create_character_profile_gui(node, component)
	return self:_create_raid_menu_create_character_profile_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_create_character_profile_gui(node, component)
	self:close_raid_menu_create_character_profile_gui(node, component)

	self._raid_menu_create_character_profile_gui = CharacterCreationGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_create_character_profile_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	table.insert(self._update_components, self._raid_menu_create_character_profile_gui)

	return self._raid_menu_create_character_profile_gui
end

function MenuComponentManager:close_raid_menu_create_character_profile_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_create_character_profile_gui then
		self:remove_update_component(self._raid_menu_create_character_profile_gui)
		self._raid_menu_create_character_profile_gui:close()

		self._raid_menu_create_character_profile_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_character_customization_gui(node, component)
	return self:_create_raid_menu_character_customization_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_character_customization_gui(node, component)
	self:close_raid_menu_character_customization_gui(node, component)

	self._raid_menu_character_customization_gui = CharacterCustomizationGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_character_customization_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list.character_customizations_grid = self._raid_menu_character_customization_gui._character_customizations_grid
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_character_customization_gui
end

function MenuComponentManager:close_raid_menu_character_customization_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_character_customization_gui then
		self._raid_menu_character_customization_gui:close()

		self._raid_menu_character_customization_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_gold_asset_store_gui(node, component)
	return self:_create_raid_menu_gold_asset_store_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_gold_asset_store_gui(node, component)
	self:close_raid_menu_gold_asset_store_gui(node, component)

	self._raid_menu_gold_asset_store_gui = GoldAssetStoreGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_gold_asset_store_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list.gold_asset_store_grid = self._raid_menu_gold_asset_store_gui._gold_asset_store_grid
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	table.insert(self._update_components, self._raid_menu_gold_asset_store_gui)

	return self._raid_menu_gold_asset_store_gui
end

function MenuComponentManager:close_raid_menu_gold_asset_store_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_gold_asset_store_gui then
		self:remove_update_component(self._raid_menu_gold_asset_store_gui)
		self._raid_menu_gold_asset_store_gui:close()

		self._raid_menu_gold_asset_store_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_intel_gui(node, component)
	return self:_create_raid_menu_intel_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_intel_gui(node, component)
	self:close_raid_menu_intel_gui(node, component)

	self._raid_menu_intel_gui = IntelGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_intel_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list.intel_grid = self._raid_menu_intel_gui._intel_grid
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	table.insert(self._update_components, self._raid_menu_intel_gui)

	return self._raid_menu_intel_gui
end

function MenuComponentManager:close_raid_menu_intel_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_intel_gui then
		self:remove_update_component(self._raid_menu_intel_gui)
		self._raid_menu_intel_gui:close()

		self._raid_menu_intel_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_comic_book_gui(node, component)
	return self:_create_raid_menu_comic_book_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_comic_book_gui(node, component)
	self:close_raid_menu_comic_book_gui(node, component)

	self._raid_menu_comic_book_gui = ComicBookGui:new(self._ws, self._fullscreen_ws, node, component)

	if self._active_comic_id then
		self._raid_menu_comic_book_gui:set_comic(self._active_comic_id)

		self._active_comic_id = nil
	end

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_comic_book_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_comic_book_gui
end

function MenuComponentManager:set_comic_book_id(id)
	if self._raid_menu_comic_book_gui then
		self._raid_menu_comic_book_gui:set_comic(id)
	else
		self._active_comic_id = id
	end
end

function MenuComponentManager:close_raid_menu_comic_book_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_comic_book_gui then
		self._raid_menu_comic_book_gui:close()

		self._raid_menu_comic_book_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_header_gui(node, component)
	return self:_create_raid_menu_header_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_header_gui(node, component)
	self:close_raid_menu_header_gui()

	self._raid_menu_header_gui = RaidMenuHeader:new(self._ws, self._fullscreen_ws, node, component)

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_header_gui
end

function MenuComponentManager:close_raid_menu_header_gui()
	if self._raid_menu_header_gui then
		self._raid_menu_header_gui:close()

		self._raid_menu_header_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_footer_gui(node, component)
	return self:_create_raid_menu_footer_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_footer_gui(node, component)
	self:close_raid_menu_footer_gui(node, component)

	self._raid_menu_footer_gui = RaidMenuFooter:new(self._ws, self._fullscreen_ws, node, component)

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_footer_gui
end

function MenuComponentManager:close_raid_menu_footer_gui(node, component)
	if self._raid_menu_footer_gui then
		self._raid_menu_footer_gui:close()

		self._raid_menu_footer_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:refresh_player_profile_gui()
	if self._raid_menu_footer_gui then
		self._raid_menu_footer_gui:refresh_player_profile()
	end
end

function MenuComponentManager:create_raid_menu_profile_switcher_gui(node, component)
	return self:_create_raid_menu_profile_switcher_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_profile_switcher_gui(node, component)
	self:close_raid_menu_profile_switcher_gui(node, component)

	self._raid_menu_profile_switcher_gui = RaidMenuProfileSwitcher:new(self._ws, self._fullscreen_ws, node, component)

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_profile_switcher_gui
end

function MenuComponentManager:close_raid_menu_profile_switcher_gui(node, component)
	if self._raid_menu_profile_switcher_gui then
		self._raid_menu_profile_switcher_gui:close()

		self._raid_menu_profile_switcher_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_left_options_gui(node, component)
	return self:_create_raid_menu_left_options_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_left_options_gui(node, component)
	self:close_raid_menu_left_options_gui(node, component)

	self._raid_menu_left_options_gui = RaidMenuLeftOptions:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_left_options_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_left_options_gui
end

function MenuComponentManager:close_raid_menu_left_options_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_left_options_gui then
		self._raid_menu_left_options_gui:close()

		self._raid_menu_left_options_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_options_background_gui(node, component)
	return self:_create_raid_options_background_gui(node, component)
end

function MenuComponentManager:_create_raid_options_background_gui(node, component)
	self:close_raid_options_background_gui(node, component)

	self._raid_options_background_gui = RaidOptionsBackground:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_options_background_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_options_background_gui
end

function MenuComponentManager:close_raid_options_background_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_options_background_gui then
		self._raid_options_background_gui:close()

		self._raid_options_background_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_options_controls_gui(node, component)
	return self:_create_raid_menu_options_controls_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_options_controls_gui(node, component)
	self:close_raid_menu_options_controls_gui(node, component)

	self._raid_options_controls_gui = RaidMenuOptionsControls:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_options_controls_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_options_controls_gui
end

function MenuComponentManager:close_raid_menu_options_controls_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_options_controls_gui then
		self._raid_options_controls_gui:close()

		self._raid_options_controls_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_options_controls_keybinds_gui(node, component)
	return self:_create_raid_menu_options_controls_keybinds_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_options_controls_keybinds_gui(node, component)
	self:close_raid_menu_options_controls_keybinds_gui(node, component)

	self._raid_options_controls_keybinds_gui = RaidMenuOptionsControlsKeybinds:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_options_controls_keybinds_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_options_controls_keybinds_gui
end

function MenuComponentManager:close_raid_menu_options_controls_keybinds_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_options_controls_keybinds_gui then
		self._raid_options_controls_keybinds_gui:close()

		self._raid_options_controls_keybinds_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_options_controller_mapping_gui(node, component)
	return self:_create_raid_menu_options_controller_mapping_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_options_controller_mapping_gui(node, component)
	self:close_raid_menu_options_controller_mapping_gui(node, component)

	self._raid_menu_options_controller_mapping_gui = RaidMenuOptionsControlsControllerMapping:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_options_controller_mapping_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_options_controller_mapping_gui
end

function MenuComponentManager:close_raid_menu_options_controller_mapping_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_options_controller_mapping_gui then
		self._raid_menu_options_controller_mapping_gui:close()

		self._raid_menu_options_controller_mapping_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_options_sound_gui(node, component)
	return self:_create_raid_menu_options_sound_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_options_sound_gui(node, component)
	self:close_raid_menu_options_sound_gui(node, component)

	self._raid_options_sound_gui = RaidMenuOptionsSound:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_options_sound_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_options_sound_gui
end

function MenuComponentManager:close_raid_menu_options_sound_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_options_sound_gui then
		self._raid_options_sound_gui:close()

		self._raid_options_sound_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_options_network_gui(node, component)
	return self:_create_raid_menu_options_network_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_options_network_gui(node, component)
	self:close_raid_menu_options_network_gui(node, component)

	self._raid_options_network_gui = RaidMenuOptionsNetwork:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_options_network_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_options_network_gui
end

function MenuComponentManager:close_raid_menu_options_network_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_options_network_gui then
		self._raid_options_network_gui:close()

		self._raid_options_network_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_options_video_gui(node, component)
	return self:_create_raid_menu_options_video_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_options_video_gui(node, component)
	self:close_raid_menu_options_video_gui(node, component)

	self._raid_options_video_gui = RaidMenuOptionsVideo:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_options_video_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_options_video_gui
end

function MenuComponentManager:close_raid_menu_options_video_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_options_video_gui then
		self._raid_options_video_gui:close()

		self._raid_options_video_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_options_video_advanced_gui(node, component)
	return self:_create_raid_menu_options_video_advanced_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_options_video_advanced_gui(node, component)
	self:close_raid_menu_options_video_advanced_gui(node, component)

	self._raid_options_video_advanced_gui = RaidMenuOptionsVideoAdvanced:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_options_video_advanced_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_options_video_advanced_gui
end

function MenuComponentManager:close_raid_menu_options_video_advanced_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_options_video_advanced_gui then
		self._raid_options_video_advanced_gui:close()

		self._raid_options_video_advanced_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_options_interface_gui(node, component)
	return self:_create_raid_menu_options_interface_gui(node, component)
end

function MenuComponentManager:_create_raid_menu_options_interface_gui(node, component)
	self:close_raid_menu_options_interface_gui(node, component)

	self._raid_options_interface_gui = RaidMenuOptionsInterface:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_options_interface_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_options_interface_gui
end

function MenuComponentManager:close_raid_menu_options_interface_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_options_interface_gui then
		self._raid_options_interface_gui:close()

		self._raid_options_interface_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_ready_up_gui(node, component)
	self:close_raid_ready_up_gui(node, component)

	self._raid_ready_up_gui = ReadyUpGui:new(self._ws, self._fullscreen_ws, node, component)

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	table.insert(self._update_components, self._raid_ready_up_gui)

	return self._raid_ready_up_gui
end

function MenuComponentManager:close_raid_ready_up_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_ready_up_gui then
		self:remove_update_component(self._raid_ready_up_gui)
		self._raid_ready_up_gui:close()

		self._raid_ready_up_gui = nil
	end
end

function MenuComponentManager:create_raid_challenge_cards_gui(node, component)
	return self:_create_raid_challenge_cards_gui(node, component)
end

function MenuComponentManager:_create_raid_challenge_cards_gui(node, component)
	self:close_raid_challenge_cards_gui(node, component)

	self._raid_challenge_cards_gui = ChallengeCardsGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_challenge_cards_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list.card_grid = self._raid_challenge_cards_gui._card_grid
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	table.insert(self._update_components, self._raid_challenge_cards_gui)

	return self._raid_challenge_cards_gui
end

function MenuComponentManager:close_raid_challenge_cards_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_challenge_cards_gui then
		self:remove_update_component(self._raid_challenge_cards_gui)
		self._raid_challenge_cards_gui:close()

		self._raid_challenge_cards_gui = nil
	end
end

function MenuComponentManager:create_raid_challenge_cards_view_gui(node, component)
	return self:_create_raid_challenge_cards_view_gui(node, component)
end

function MenuComponentManager:_create_raid_challenge_cards_view_gui(node, component)
	self:close_raid_challenge_cards_view_gui(node, component)

	self._raid_challenge_cards_view_gui = ChallengeCardsGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_challenge_cards_view_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list.card_grid = self._raid_challenge_cards_view_gui._card_grid
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_challenge_cards_view_gui
end

function MenuComponentManager:close_raid_challenge_cards_view_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_challenge_cards_view_gui then
		self._raid_challenge_cards_view_gui:close()

		self._raid_challenge_cards_view_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_challenge_cards_loot_reward_gui(node, component)
	return self:_create_raid_challenge_cards_loot_reward_gui(node, component)
end

function MenuComponentManager:_create_raid_challenge_cards_loot_reward_gui(node, component)
	Application:debug("[MenuComponentManager:_create_raid_challenge_cards_loot_reward_gui] CREATE RAID CHALLENGE CARDS REWARD GUI")
	self:close_raid_challenge_cards_loot_reward_gui(node, component)

	self._raid_challenge_cards_loot_reward_gui = ChallengeCardsLootRewardGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_challenge_cards_loot_reward_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	table.insert(self._update_components, self._raid_challenge_cards_loot_reward_gui)

	return self._raid_challenge_cards_loot_reward_gui
end

function MenuComponentManager:close_raid_challenge_cards_loot_reward_gui(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_challenge_cards_loot_reward_gui then
		self:remove_update_component(self._raid_challenge_cards_loot_reward_gui)
		self._raid_challenge_cards_loot_reward_gui:close()

		self._raid_challenge_cards_loot_reward_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_xp(node, component)
	return self:_create_raid_menu_xp(node, component)
end

function MenuComponentManager:_create_raid_menu_xp(node, component)
	self:close_raid_menu_xp(node, component)

	self._raid_menu_xp_gui = ExperienceGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_xp_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end

		final_list._equippable_upgrades = self._raid_menu_xp_gui._equippable_upgrades
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_xp_gui
end

function MenuComponentManager:close_raid_menu_xp(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_xp_gui then
		self._raid_menu_xp_gui:close()

		self._raid_menu_xp_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_post_game_breakdown(node, component)
	return self:_create_raid_menu_post_game_breakdown(node, component)
end

function MenuComponentManager:_create_raid_menu_post_game_breakdown(node, component)
	self:close_raid_menu_post_game_breakdown(node, component)

	self._raid_menu_post_game_breakdown_gui = PostGameBreakdownGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_post_game_breakdown_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_post_game_breakdown_gui
end

function MenuComponentManager:close_raid_menu_post_game_breakdown(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_post_game_breakdown_gui then
		self._raid_menu_post_game_breakdown_gui:close()

		self._raid_menu_post_game_breakdown_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_special_honors(node, component)
	return self:_create_raid_menu_special_honors(node, component)
end

function MenuComponentManager:_create_raid_menu_special_honors(node, component)
	self:close_raid_menu_special_honors(node, component)

	self._raid_menu_special_honors_gui = SpecialHonorsGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_special_honors_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_special_honors_gui
end

function MenuComponentManager:close_raid_menu_special_honors(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_special_honors_gui then
		self._raid_menu_special_honors_gui:close()

		self._raid_menu_special_honors_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_loot(node, component)
	return self:_create_raid_menu_loot(node, component)
end

function MenuComponentManager:_create_raid_menu_loot(node, component)
	self:close_raid_menu_loot(node, component)

	self._raid_menu_loot_gui = LootScreenGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_loot_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_loot_gui
end

function MenuComponentManager:close_raid_menu_loot(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_loot_gui then
		self._raid_menu_loot_gui:close()

		self._raid_menu_loot_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_greed_loot(node, component)
	return self:_create_raid_menu_greed_loot(node, component)
end

function MenuComponentManager:_create_raid_menu_greed_loot(node, component)
	self:close_raid_menu_loot(node, component)

	self._raid_menu_greed_loot_gui = GreedLootScreenGui:new(self._ws, self._fullscreen_ws, node, component)

	if component then
		self._active_controls[component] = {}

		local final_list = self._active_controls[component]

		for _, control in ipairs(self._raid_menu_greed_loot_gui._root_panel._controls) do
			self:_collect_controls(control, final_list)
		end
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_greed_loot_gui
end

function MenuComponentManager:close_raid_menu_greed_loot(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_greed_loot_gui then
		self._raid_menu_greed_loot_gui:close()

		self._raid_menu_greed_loot_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:create_raid_menu_credits(node, component)
	return self:_create_raid_menu_credits(node, component)
end

function MenuComponentManager:_create_raid_menu_credits(node, component)
	self:close_raid_menu_credits(node, component)

	self._raid_menu_credits_gui = RaidMenuCreditsGui:new(self._ws, self._fullscreen_ws, node, component)

	table.insert(self._update_components, self._raid_menu_credits_gui)

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end

	return self._raid_menu_credits_gui
end

function MenuComponentManager:close_raid_menu_credits(node, component)
	if component then
		self._active_controls[component] = {}
	end

	if self._raid_menu_credits_gui then
		self:remove_update_component(self._raid_menu_credits_gui)
		self._raid_menu_credits_gui:close()

		self._raid_menu_credits_gui = nil

		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

function MenuComponentManager:_collect_controls(controls_list, final_list)
	if controls_list._controls then
		for _, control in ipairs(controls_list._controls) do
			if control._controls then
				self:_collect_controls(control._controls, final_list)
			elseif control._name and control._type and control._type == "raid_gui_control" then
				final_list[control._name] = control
			end
		end
	end

	if controls_list._name and controls_list._type and controls_list._type == "raid_gui_control" then
		final_list[controls_list._name] = controls_list
	else
		for _, control in ipairs(controls_list) do
			if control._type and control._type == "raid_gui_control" then
				final_list[control._name] = control
			end
		end
	end
end

function MenuComponentManager:gather_controls_for_component(component_name)
	if component_name then
		self._active_controls[component_name] = {}

		local final_list = self._active_controls[component_name]
		local component_object = self._active_components[component_name].component_object

		if component_object then
			for _, control in ipairs(component_object._root_panel._controls) do
				self:_collect_controls(control, final_list)
			end
		end
	end
end

function MenuComponentManager:remove_update_component(component)
	for i = 1, #self._update_components do
		if self._update_components[i] == component then
			table.remove(self._update_components, i)

			break
		end
	end
end

function MenuComponentManager:_create_voice_chat_status_info()
	local widget_panel_params = {
		h = HUDPlayerVoiceChatStatus.DEFAULT_H * 4,
		name = "voice_chat_panel",
		w = HUDPlayerVoiceChatStatus.DEFAULT_W,
		x = 0,
	}

	self._voice_chat_panel = self._voicechat_ws:panel():panel(widget_panel_params)

	self._voice_chat_panel:set_top(self._voicechat_ws:panel():h() / 2 - HUDPlayerVoiceChatStatus.DEFAULT_H * 2)
	self._voice_chat_panel:set_right(self._voicechat_ws:panel():w() - HUDPlayerVoiceChatStatus.DEFAULT_W / 4)

	self._voice_chat_widgets = {}
	self._voice_chat_widgets[1] = HUDPlayerVoiceChatStatus:new(0, self._voice_chat_panel)
	self._voice_chat_widgets[2] = HUDPlayerVoiceChatStatus:new(1, self._voice_chat_panel)
	self._voice_chat_widgets[3] = HUDPlayerVoiceChatStatus:new(2, self._voice_chat_panel)
	self._voice_chat_widgets[4] = HUDPlayerVoiceChatStatus:new(3, self._voice_chat_panel)
end

function MenuComponentManager:_voice_panel_align_bottom_right()
	if self._voice_chat_panel then
		Application:trace("MenuComponentManager:_create_voice_chat_status_info")
		self._voice_chat_panel:set_bottom(self._voicechat_ws:panel():h() / 2 + HUDPlayerVoiceChatStatus.DEFAULT_H * 6)
		self._voice_chat_panel:set_right(self._voicechat_ws:panel():w() - HUDPlayerVoiceChatStatus.DEFAULT_W / 4)
	end
end

function MenuComponentManager:_voice_panel_align_mid_right(offset_y)
	if self._voice_chat_panel then
		local offset = offset_y and offset_y or 0

		Application:trace("MenuComponentManager:_create_voice_chat_status_info")
		self._voice_chat_panel:set_top(self._voicechat_ws:panel():h() / 2 - HUDPlayerVoiceChatStatus.DEFAULT_H * 2 + offset)
		self._voice_chat_panel:set_right(self._voicechat_ws:panel():w() - HUDPlayerVoiceChatStatus.DEFAULT_W / 4)
	end
end

function MenuComponentManager:_voice_panel_align_top_right()
	if self._voice_chat_panel then
		Application:trace("MenuComponentManager:_create_voice_chat_status_info")
		self._voice_chat_panel:set_top(self._voicechat_ws:panel():h() / 2 - HUDPlayerVoiceChatStatus.DEFAULT_H * 4)
		self._voice_chat_panel:set_right(self._voicechat_ws:panel():w() - HUDPlayerVoiceChatStatus.DEFAULT_W / 4)
	end
end

function MenuComponentManager:_voice_panel_align_bottom_left()
	if self._voice_chat_panel then
		Application:trace("MenuComponentManager:_create_voice_chat_status_info")
		self._voice_chat_panel:set_bottom(self._voicechat_ws:panel():h() / 2 + HUDPlayerVoiceChatStatus.DEFAULT_H * 6)
		self._voice_chat_panel:set_right(HUDPlayerVoiceChatStatus.DEFAULT_W)
	end
end

function MenuComponentManager:_voice_panel_align_mid_left()
	if self._voice_chat_panel then
		Application:trace("MenuComponentManager:_create_voice_chat_status_info")
		self._voice_chat_panel:set_top(self._voicechat_ws:panel():h() / 2 - HUDPlayerVoiceChatStatus.DEFAULT_H * 2)
		self._voice_chat_panel:set_right(HUDPlayerVoiceChatStatus.DEFAULT_W)
	end
end

function MenuComponentManager:toggle_voice_chat_listeners(enable)
	if enable then
		managers.system_event_listener:add_listener("voice_chat_ui_update_menumanager", {
			CoreSystemEventListenerManager.SystemEventListenerManager.UPDATE_VOICE_CHAT_UI,
		}, callback(self, self, "_update_voice_chat_ui"))
		managers.system_event_listener:add_listener("menucomponent_drop_out", {
			CoreSystemEventListenerManager.SystemEventListenerManager.EVENT_DROP_OUT,
		}, callback(self, self, "_peer_dropped_out"))
	else
		managers.system_event_listener:remove_listener("voice_chat_ui_update_menumanager")
	end
end

function MenuComponentManager:_peer_dropped_out(params)
	if params then
		local peer_id = params._id

		Application:trace("MenuComponentManager:_peer_dropped_out [peer id] " .. tostring(peer_id))

		if self._voice_chat_widgets[peer_id] then
			self._voice_chat_widgets[peer_id]:hide_chat_indicator()
		end
	end
end

function MenuComponentManager:_update_voice_chat_ui(params)
	Application:trace("MenuComponentManager:_update_voice_chat_ui")

	if params.status_type ~= "talk" then
		return
	end

	local user_data = params.user_data
	local is_local_user = false

	if IS_XB1 then
		is_local_user = managers.network.account:player_id() == user_data.user_xuid
	elseif IS_PS4 then
		is_local_user = managers.network.account:username_id() == user_data.user_name
	end

	local peer_to_update

	if is_local_user then
		peer_to_update = managers.network:session():local_peer()
	elseif IS_XB1 then
		peer_to_update = managers.network:session():peer_by_xuid(user_data.user_xuid)
	elseif IS_PS4 then
		peer_to_update = managers.network:session():peer_by_name(user_data.user_name)
	end

	if peer_to_update then
		local peer_id = peer_to_update:id()
		local peer_name = peer_to_update:name()

		Application:trace("MenuComponentManager:_update_voice_chat_ui peer is present " .. peer_name .. " peer id " .. tostring(peer_id))

		if self._voice_chat_widgets[peer_id] then
			if user_data.user_talking then
				self._voice_chat_widgets[peer_id]:show_chat_indicator(peer_name)
			else
				self._voice_chat_widgets[peer_id]:hide_chat_indicator()
			end
		end
	end
end

function MenuComponentManager:create_menu_alert(params)
	if self._raid_menu_alert and self._raid_menu_alert:name() == params.name then
		-- block empty
	else
		self:close_menu_alert()

		params = params or {}
		self._raid_menu_alert = RaidGUIControlMenuAlert:new(self._fullscreen_ws, params)
	end
end

function MenuComponentManager:close_menu_alert()
	if self._raid_menu_alert then
		self._raid_menu_alert:close()

		self._raid_menu_alert = nil
	end
end
