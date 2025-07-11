CharacterCreationGui = CharacterCreationGui or class(RaidGuiBase)
CharacterCreationGui.STEP_TWO_INDICATOR_DEFAULT_X = 224

function CharacterCreationGui:init(ws, fullscreen_ws, node, component_name)
	self._loading_units = {}

	CharacterCreationGui.super.init(self, ws, fullscreen_ws, node, component_name)

	self._character_spawn_location = nil
	self._hardcore = false

	self._node.components.raid_menu_header:set_screen_name("character_creation_title")
	self:_bind_controller_inputs()
	managers.raid_menu:hide_background()
end

function CharacterCreationGui:_setup_properties()
	CharacterCreationGui.super._setup_properties(self)

	self._background = nil
	self._background_rect = nil
end

function CharacterCreationGui:_set_initial_data()
	managers.character_customization:reset_current_version_to_attach()

	self._character_save_done_callback_ref = callback(self, self, "_character_save_done_callback")
end

function CharacterCreationGui:_update_control_visibility()
	local show_class_controls = self._current_screen == "class"
	local show_nationality_screen = not show_class_controls

	for _, control in ipairs(self._nationality_screen_controls) do
		control:set_visible(show_nationality_screen)
	end

	for _, control in ipairs(self._class_screen_controls) do
		control:set_visible(show_class_controls)
	end

	local icon_data1, icon_data2

	if self._current_screen == "class" then
		icon_data1 = tweak_data.gui.icons.character_creation_1_large
		icon_data2 = tweak_data.gui.icons.character_creation_2_small

		self._class_label:set_color(tweak_data.gui.colors.raid_dirty_white)
		self._nationality_label:set_color(tweak_data.gui.colors.raid_grey)
	elseif self._current_screen == "nationality" then
		icon_data1 = tweak_data.gui.icons.character_creation_checked
		icon_data2 = tweak_data.gui.icons.character_creation_2_large

		self._class_label:set_color(tweak_data.gui.colors.raid_red)
		self._nationality_label:set_color(tweak_data.gui.colors.raid_dirty_white)
	else
		icon_data1 = tweak_data.gui.icons.character_creation_checked
		icon_data2 = tweak_data.gui.icons.character_creation_checked

		self._class_label:set_color(tweak_data.gui.colors.raid_red)
		self._nationality_label:set_color(tweak_data.gui.colors.raid_red)
	end

	self._number_1:set_image(icon_data1.texture)
	self._number_1:set_texture_rect(icon_data1.texture_rect)
	self._number_2:set_image(icon_data2.texture)
	self._number_2:set_texture_rect(icon_data2.texture_rect)
end

function CharacterCreationGui:_layout()
	self._loaded_weapons = {}
	self._selected_class = tweak_data.skilltree.base_classes[1]
	self._selected_nation = tweak_data.skilltree.classes[self._selected_class].default_natioanlity
	self._class_screen_controls = {}
	self._nationality_screen_controls = {}

	self._root_panel:label({
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed_outlined_38,
		font_size = tweak_data.gui.font_sizes.size_38,
		h = 38,
		name = "subtitle_profiles",
		text = self:translate("character_creation_subtitle", true),
		w = 416,
		x = 0,
		y = 96,
	})

	local subtitle_class = self._root_panel:label({
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.din_compressed_outlined_24,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 24,
		name = "subtitle_small_profile_class",
		text = self:translate("character_creation_subtitle_class", true),
		w = 416,
		x = 0,
		y = 144,
	})

	table.insert(self._class_screen_controls, subtitle_class)

	local subtitle_nationality = self._root_panel:label({
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.din_compressed_outlined_24,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 24,
		name = "subtitle_small_profile_nationality",
		text = self:translate("character_creation_subtitle_nationality", true),
		w = 416,
		x = 0,
		y = 144,
	})

	table.insert(self._nationality_screen_controls, subtitle_nationality)

	self._class_list = self._root_panel:list_active({
		data_source_callback = callback(self, self, "_data_source_class_list"),
		h = 384,
		item_class = RaidGUIControlListItemCharacterCreateClass,
		item_h = 96,
		name = "class_list",
		on_item_clicked_callback = callback(self, self, "_on_class_click_callback"),
		on_item_double_clicked_callback = callback(self, self, "_on_click_button_next"),
		on_item_selected_callback = callback(self, self, "_on_class_select_callback"),
		selection_enabled = true,
		vertical_spacing = 2,
		w = 416,
		x = 0,
		y = 224,
	})

	table.insert(self._class_screen_controls, self._class_list)

	self._nation_list = self._root_panel:list_active({
		data_source_callback = callback(self, self, "_data_source_nation_list"),
		h = 384,
		item_class = RaidGUIControlListItemCharacterCreateNation,
		item_h = 96,
		name = "nation_list",
		on_item_clicked_callback = callback(self, self, "_on_nation_click_callback"),
		on_item_double_clicked_callback = callback(self, self, "_on_click_button_next"),
		on_item_selected_callback = callback(self, self, "_on_nation_select_callback"),
		selection_enabled = true,
		vertical_spacing = 2,
		w = 416,
		x = 0,
		y = 224,
	})

	table.insert(self._nationality_screen_controls, self._nation_list)

	local list_bottom = self._class_list:bottom()
	local your_selection = self._root_panel:label({
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.din_compressed_outlined_24,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 24,
		name = "label_your_selection",
		text = self:translate("character_creation_your_selection", true),
		w = 256,
		x = 0,
		y = list_bottom + 64,
	})
	local icon_data = tweak_data.gui.icons.character_creation_1_large
	local tex_rect = icon_data.texture_rect

	self._number_1 = self._root_panel:image({
		h = tex_rect[4],
		texture = icon_data.texture,
		texture_rect = tex_rect,
		w = tex_rect[3],
		x = 0,
		y = your_selection:bottom() + 32,
	})
	self._class_label = self._root_panel:label({
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed_outlined_32,
		font_size = tweak_data.gui.font_sizes.size_32,
		h = 42,
		name = "class_label",
		text = self:translate(tweak_data.skilltree.classes[self._selected_class].name_id, true),
		w = 160,
		x = self._number_1:right() + 10,
		y = your_selection:bottom() + 40,
	})
	icon_data = tweak_data.gui.icons.character_creation_2_small
	tex_rect = icon_data.texture_rect
	self._number_2 = self._root_panel:image({
		h = tex_rect[4],
		texture = icon_data.texture,
		texture_rect = tex_rect,
		w = tex_rect[3],
		x = CharacterCreationGui.STEP_TWO_INDICATOR_DEFAULT_X,
		y = your_selection:bottom() + 35,
	})
	self._nationality_label = self._root_panel:label({
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed_outlined_32,
		font_size = tweak_data.gui.font_sizes.size_32,
		h = 42,
		name = "nationality_label",
		text = self:translate("character_profile_creation_" .. self._selected_nation, true),
		w = 256,
		x = self._number_2:right() + 10,
		y = your_selection:bottom() + 40,
	})

	local _, _, w, _ = self._class_label:text_rect()

	self._class_label:set_w(w)
	self._number_2:set_x(math.max(CharacterCreationGui.STEP_TWO_INDICATOR_DEFAULT_X, self._class_label:right() + 20))
	self._nationality_label:set_x(self._number_2:right() + 10)

	self._next_button = self._root_panel:short_primary_button({
		layer = RaidGuiBase.FOREGROUND_LAYER,
		name = "next_button",
		on_click_callback = callback(self, self, "_on_click_button_next"),
		text = self:translate("character_profile_next_button", true),
		w = 192,
		x = 0,
		y = list_bottom + 224,
	})
	self._right_side_info_class = self._root_panel:create_custom_control(RaidGUIControlClassDescription, {
		h = 720,
		name = "right_side_info_panel",
		visible = false,
		w = 516,
		x = 1308,
		y = 0,
	}, {
		class = nil,
	})

	self._right_side_info_class:set_right(self._root_panel:right())
	self._right_side_info_class:set_center_y(self._root_panel:h() / 2)
	table.insert(self._class_screen_controls, self._right_side_info_class)

	self._right_side_info_nationality = self._root_panel:create_custom_control(RaidGUIControlNationalityDescription, {
		h = 620,
		name = "right_side_info_panel",
		visible = false,
		w = 480,
		x = 1308,
		y = 0,
	}, {
		class = nil,
	})

	self._right_side_info_nationality:set_right(self._root_panel:right())
	self._right_side_info_nationality:set_center_y(self._root_panel:h() / 2)
	table.insert(self._nationality_screen_controls, self._right_side_info_nationality)

	self._current_screen = "class"

	self:_update_control_visibility()
	self._class_list:set_selected(true)
	self._class_list:select_item_by_index(1)
	self._class_list:activate_item_by_value(self._selected_class)
	self:_set_class_default_nationality()
	self:_spawn_empty_character_skeleton()
end

function CharacterCreationGui:set_character_select_allowed(value)
	self._character_select_allowed = value

	self._class_list:set_abort_selection(not value)
end

function CharacterCreationGui:_set_class_default_nationality()
	self._selected_nation = tweak_data.skilltree.classes[self._selected_class].default_natioanlity

	self._nationality_label:set_text(self:translate("character_profile_creation_" .. self._selected_nation, true))
	self._nation_list:select_item_by_value(self._selected_nation)
	self._nation_list:activate_item_by_value(self._selected_nation)
end

function CharacterCreationGui:_on_nation_click_callback(data)
	if self._selected_nation == data.value then
		return
	end

	self._selected_nation = data.value

	self._nationality_label:set_text(self:translate("character_profile_creation_" .. self._selected_nation, true))
	self:show_selected_character_description()
	self:show_selected_character()

	if self._selected_nation == "american" then
		managers.menu_component:post_event("char_creation_rivet_intro")
	elseif self._selected_nation == "british" then
		managers.menu_component:post_event("char_creation_sterling_intro")
	elseif self._selected_nation == "russian" then
		managers.menu_component:post_event("char_creation_kurgan_intro")
	elseif self._selected_nation == "german" then
		managers.menu_component:post_event("char_creation_wolfgang_intro")
	end
end

function CharacterCreationGui:_on_nation_select_callback(data)
	if self._current_screen ~= "nationality" then
		return
	end

	self:_on_nation_click_callback(data)
	self._nation_list:activate_item_by_value(data.value)
end

function CharacterCreationGui:_on_class_click_callback(data)
	if self._selected_class == data.value then
		return
	end

	self._selected_class = data.value

	self._class_label:set_text(self:translate(tweak_data.skilltree.classes[self._selected_class].name_id, true))

	local _, _, w, _ = self._class_label:text_rect()

	self._class_label:set_w(w)
	self._number_2:set_x(math.max(CharacterCreationGui.STEP_TWO_INDICATOR_DEFAULT_X, self._class_label:right() + 20))
	self._nationality_label:set_x(self._number_2:right() + 10)
	self:_set_class_default_nationality()
	self:show_selected_character_description()
	self:show_selected_character()

	if self._selected_class == "assault" then
		managers.menu_component:post_event("char_creation_assault_intro")
	elseif self._selected_class == "infiltrator" then
		managers.menu_component:post_event("char_creation_insurgent_intro")
	elseif self._selected_class == "recon" then
		managers.menu_component:post_event("char_creation_recon_intro")
	elseif self._selected_class == "demolitions" then
		managers.menu_component:post_event("char_creation_demolitions_intro")
	end
end

function CharacterCreationGui:_on_class_select_callback(data)
	if self._current_screen ~= "class" then
		return
	end

	self:_on_class_click_callback(data)
	self._class_list:activate_item_by_value(data.value)
end

function CharacterCreationGui:_data_source_nation_list()
	local nationalities = {}

	for _, class_name in pairs(tweak_data.skilltree.base_classes) do
		local nationality = tweak_data.skilltree.classes[class_name].default_natioanlity
		local nation_text = managers.localization:to_upper_text("menu_" .. nationality)

		table.insert(nationalities, {
			info = nationality,
			text = nation_text,
			value = nationality,
		})
	end

	return nationalities
end

function CharacterCreationGui:_data_source_class_list()
	local classes = {}

	for _, class_name in pairs(tweak_data.skilltree.base_classes) do
		local char_class = tweak_data.skilltree.classes[class_name]
		local class_text = managers.localization:to_upper_text(char_class.name_id)

		table.insert(classes, {
			text = class_text,
			value = char_class.name,
		})
	end

	return classes
end

function CharacterCreationGui:_on_click_button_next()
	if not self._weapons_assembled then
		return
	end

	if self._current_screen == "class" then
		self._current_screen = "nationality"

		self._nation_list:set_selected(true)
		self._class_list:set_selected(false)

		local default_natioanlity = tweak_data.skilltree.classes[self._selected_class].default_natioanlity

		self._nation_list:select_item_by_value(default_natioanlity)
		self:_update_control_visibility()
		self:show_selected_character_description()
		managers.raid_menu:register_on_escape_callback(callback(self, self, "back_pressed"))
	elseif self._current_screen == "nationality" then
		self._current_screen = "name_entry"

		self:_update_control_visibility()
		self:_show_character_create_input_textbox()
	end

	return true
end

function CharacterCreationGui:back_pressed()
	if not self._weapons_assembled then
		Application:debug("[CharacterCreationGui:back_pressed] weapons are not assembled yet, can't go back!")

		return true
	end

	print("[CharacterCreationGui:back_pressed] button")

	if self._current_screen == "nationality" then
		self._current_screen = "class"

		self._nation_list:set_selected(false)
		self._class_list:set_selected(true)
		self:_set_class_default_nationality()
		self:_update_control_visibility()
		self._class_list:select_item_by_value(self._selected_class)
		self:show_selected_character_description()
		self:show_selected_character()
		managers.raid_menu:register_on_escape_callback(nil)
	end

	return true
end

function CharacterCreationGui:on_click_character_name()
	self:input_focus()
	self:_on_focus()
end

function CharacterCreationGui:show_selected_character_description()
	local right_side_info = self._current_screen == "class" and self._right_side_info_class or self._right_side_info_nationality

	right_side_info:set_data({
		class_name = self._selected_class,
		class_stats = managers.skilltree:calculate_stats(self._selected_class),
		level = 0,
		nationality = self._selected_nation,
	})
end

function CharacterCreationGui:show_selected_character()
	if self._spawned_character_unit then
		local anim_state_name = "character_creation_" .. tweak_data.skilltree.default_weapons[self._selected_class].primary
		local state = self._spawned_character_unit:play_redirect(Idstring(anim_state_name))

		self._spawned_character_unit:anim_state_machine():set_parameter(state)
		self._spawned_character_unit:customization():destroy_all_parts_on_character()
	end

	self:show_selected_character_default_customization(self._selected_nation)
end

function CharacterCreationGui:_spawn_empty_character_skeleton()
	self:set_character_select_allowed(false)

	self._loading_units[CharacterCustomizationTweakData.CRIMINAL_MENU_SELECT_UNIT] = true

	managers.dyn_resource:load(IDS_UNIT, Idstring(CharacterCustomizationTweakData.CRIMINAL_MENU_SELECT_UNIT), DynamicResourceManager.DYN_RESOURCES_PACKAGE, callback(self, self, "_spawn_empty_character_skeleton_loaded"))
end

function CharacterCreationGui:_spawn_empty_character_skeleton_loaded()
	self._loading_units[CharacterCustomizationTweakData.CRIMINAL_MENU_SELECT_UNIT] = nil

	self:get_character_spawn_location()

	if not self._spawned_character_unit then
		self:_destroy_character_unit()

		local unit_name = CharacterCustomizationTweakData.CRIMINAL_MENU_SELECT_UNIT
		local position = self._character_spawn_location:position() or Vector3(0, 0, 0)
		local rotation = self._character_spawn_location:rotation() or Rotation(0, 0, 0)

		self._spawned_character_unit = World:spawn_unit(Idstring(unit_name), position, rotation)
	end

	self:show_selected_character_description()
	self:show_selected_character()
	self:_load_class_default_weapons()
	self:set_character_select_allowed(true)
end

function CharacterCreationGui:get_character_spawn_location()
	local units = World:find_units_quick("all", managers.slot:get_mask("env_effect"))

	if units then
		for _, unit in pairs(units) do
			if unit:name() == Idstring("units/vanilla/arhitecture/ber_a/ber_a_caracter_menu/caracter_menu_floor/caracter_menu_floor") then
				self._character_spawn_location = unit:get_object(Idstring("rp_caracter_menu_floor"))

				break
			end
		end
	end
end

function CharacterCreationGui:close()
	if self._parts_being_loaded then
		for _, parts in pairs(self._parts_being_loaded) do
			Application:trace("[CharacterCreationGui][close] disassembling weapon parts ", inspect(parts))
			managers.weapon_factory:disassemble(parts)
		end
	end

	if self._loading_units then
		for unit_name, _ in pairs(self._loading_units) do
			Application:trace("[CharacterCreationGui][close] Unloading unit ", unit_name)
			managers.dyn_resource:unload(IDS_UNIT, Idstring(unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
		end
	end

	self:_enable_dof()
	self:_destroy_weapon_parts_and_weapon_units()
	self:_destroy_character_unit()

	self._selected_character = nil
	self._selected_class = nil

	if managers.player:local_player() then
		managers.player:_internal_load()
		managers.player:local_player():inventory():equip_selection(WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID, false)
		managers.player:local_player():camera():play_redirect(PlayerStandard.IDS_EQUIP)
	end

	managers.hud:refresh_player_panel()
	managers.network:session():send_to_peers_synched("sync_character_level", managers.experience:current_level())
	managers.network:session():send_to_peers_synched("sync_character_class_nationality", managers.skilltree:get_character_profile_class(), managers.player:get_character_profile_nation())
	CharacterCreationGui.super.close(self)
	managers.network:start_matchmake_attributes_update()
	managers.weapon_skills:update_weapon_part_animation_weights()
end

function CharacterCreationGui:show_selected_character_default_customization(nationality)
	self._spawned_character_unit:customization():destroy_all_parts_on_character()

	local default_head = managers.character_customization:get_default_part_key_name(nationality, CharacterCustomizationTweakData.PART_TYPE_HEAD)
	local default_upper = managers.character_customization:get_default_part_key_name(nationality, CharacterCustomizationTweakData.PART_TYPE_UPPER)
	local default_lower = managers.character_customization:get_default_part_key_name(nationality, CharacterCustomizationTweakData.PART_TYPE_LOWER)

	managers.character_customization:increase_current_version_to_attach()
	self._spawned_character_unit:customization():attach_all_parts_to_character_by_parts(nationality, default_head, default_upper, default_lower)
end

function CharacterCreationGui:_destroy_character_unit()
	if self._spawned_character_unit then
		self._spawned_character_unit:customization():destroy_all_parts_on_character()
		self._spawned_character_unit:set_slot(0)

		self._spawned_character_unit = nil
	end
end

function CharacterCreationGui:_show_character_create_input_textbox()
	local num_append_txt = {
		"ARNE",
		"BOMBA",
		"CENTRAL",
		"DIENST",
		"ENIGMA",
		"FISH",
	}
	local slot_index = managers.savefile:get_create_character_slot()
	local params = {
		callback_no = callback(self, self, "_callback_no_function"),
		callback_yes = callback(self, self, "_callback_yes_function"),
		textbox_value = num_append_txt[slot_index - 10],
	}

	managers.menu:show_character_create_dialog(params)
end

function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function character_name_exists(name)
	for slot_index = SavefileManager.CHARACTER_PROFILE_STARTING_SLOT, SavefileManager.CHARACTER_PROFILE_STARTING_SLOT + SavefileManager.CHARACTER_PROFILE_SLOTS_COUNT - 1 do
		local slot_data = Global.savefile_manager.meta_data_list[slot_index]

		if slot_data and slot_data.cache then
			local character_name = slot_data.cache.PlayerManager.character_profile_name

			if character_name == name then
				return true
			end
		end
	end

	return false
end

function CharacterCreationGui:_callback_yes_function(button, button_data, data)
	local new_profile_name = trim(data.input_field_text)

	if new_profile_name == "" then
		local params = {
			callback_func = callback(self, self, "_show_character_create_input_textbox"),
			textbox_id = "dialog_err_empty_character_name",
		}

		managers.menu:show_err_character_name_dialog(params)

		return
	elseif character_name_exists(new_profile_name) then
		local params = {
			callback_func = callback(self, self, "_show_character_create_input_textbox"),
			textbox_id = "dialog_err_duplicate_character_name",
		}

		managers.menu:show_err_character_name_dialog(params)

		return
	end

	self:create_new_character(new_profile_name)
end

function CharacterCreationGui:_callback_no_function()
	self._current_screen = "nationality"

	self:_update_control_visibility()
	self._next_button:enable()
end

function CharacterCreationGui:create_new_character(character_profile_name)
	if self._character_created then
		Application:error("[CharacterCreationGui:create_new_character] This function should only be called once!")

		return
	end

	managers.savefile:add_save_done_callback(self._character_save_done_callback_ref)

	local character_profile_nation = self._selected_nation
	local character_profile_base_class = self._selected_class
	local slot_index = managers.savefile:get_create_character_slot()

	managers.savefile:set_save_progress_slot(slot_index)
	managers.savefile:reset_progress_managers()
	managers.player:set_character_profile_name(character_profile_name)
	managers.player:set_is_character_profile_hardcore(false)
	managers.player:set_character_profile_nation(self._selected_nation)
	managers.weapon_inventory:add_all_weapons_to_player_inventory()
	managers.skilltree:set_character_profile_base_class(self._selected_class)
	managers.player:set_character_class(self._selected_class)
	managers.weapon_skills:set_character_default_weapon_skills()
	managers.breadcrumb:reset()
	managers.blackmarket:set_preferred_character(self._selected_nation, 1)
	managers.character_customization:reaply_character_criminal(self._selected_nation)

	local local_peer = managers.network:session():local_peer()

	managers.network:session():send_to_peers_synched("set_character_customization", local_peer._unit, managers.blackmarket:outfit_string(), local_peer:outfit_version(), local_peer._id)

	local player = managers.player:local_player()

	if alive(player) then
		local camera = player:camera()
		local camera_unit = camera:camera_unit()
		local customization_ext = camera_unit:customizationfps()

		customization_ext:attach_fps_hands(character_profile_nation, managers.player:get_customization_equiped_upper_name())
	end

	if managers.raid_job._tutorial_spawned then
		managers.player:tutorial_clear_all_ammo()
	end

	managers.savefile:save_game(slot_index)
	Application:debug("[CharacterCreationGui:create_new_character] managers.global_state.fire_character_created_event = true")

	managers.global_state.fire_character_created_event = true
	self._character_created = true
end

function CharacterCreationGui:_character_save_done_callback(slot, success, is_setting_slot, cache_only, aborted)
	local saving_character_slot = managers.savefile:get_save_progress_slot()

	if slot == saving_character_slot then
		managers.savefile:save_last_selected_character_profile_slot()
	elseif is_setting_slot then
		managers.savefile:remove_save_done_callback(self._character_save_done_callback_ref)
		managers.statistics:create_character()
		managers.statistics:publish_camp_stats_to_steam()
		managers.savefile:set_create_character_slot(nil)
		managers.player:on_upgrades_changed()
		managers.raid_menu:register_on_escape_callback()
		managers.raid_menu:set_close_menu_allowed(true)
		managers.raid_menu:on_escape()
	end
end

function CharacterCreationGui:update(t, dt)
	local weapon_id = tweak_data.skilltree.default_weapons[self._selected_class].primary

	self:_show_weapon(weapon_id)

	if managers.savefile:get_active_characters_count() > 0 then
		managers.raid_menu:set_close_menu_allowed(true)
	else
		managers.raid_menu:set_close_menu_allowed(false)
	end
end

function CharacterCreationGui:_load_class_default_weapons()
	self._parts_being_loaded = {}
	self._weapons_loaded = {}

	for _, data in pairs(tweak_data.skilltree.default_weapons) do
		self._weapons_loaded[data.primary] = false
	end

	for _, data in pairs(tweak_data.skilltree.default_weapons) do
		local weapon_id = data.primary
		local weapon_factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon_id)
		local unit_path = tweak_data.weapon.factory[weapon_factory_id].unit

		self._loading_units[unit_path] = true

		managers.dyn_resource:load(IDS_UNIT, Idstring(unit_path), DynamicResourceManager.DYN_RESOURCES_PACKAGE, callback(self, self, "_weapon_unit_load_complete_callback", {
			unit_path = unit_path,
			weapon_factory_id = weapon_factory_id,
			weapon_id = weapon_id,
		}))
	end
end

function CharacterCreationGui:_weapon_unit_load_complete_callback(params)
	self._loading_units[params.unit_path] = nil

	if self._spawned_character_unit then
		local right_hand_locator = self._spawned_character_unit:get_object(Idstring("a_weapon_right_front"))
		local weapon_unit = safe_spawn_unit(Idstring(params.unit_path), right_hand_locator:position(), Rotation(0, 0, 0))

		self._spawned_character_unit:link(Idstring("a_weapon_right_front"), weapon_unit, weapon_unit:orientation_object():name())

		local weapon_blueprint = managers.weapon_inventory:get_weapon_default_blueprint(WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID, params.weapon_id)

		self._loaded_weapons[params.weapon_id] = {}

		local parts, blueprint = managers.weapon_factory:assemble_from_blueprint(params.weapon_factory_id, weapon_unit, weapon_blueprint, true, callback(self, self, "_assemble_completed", {
			weapon_id = params.weapon_id,
		}), true)

		self._parts_being_loaded[params.weapon_id] = parts

		table.insert(self._loaded_weapons[params.weapon_id], weapon_unit)
		weapon_unit:set_visible(false)
	end
end

function CharacterCreationGui:_assemble_completed(params, parts, blueprint)
	self._parts_being_loaded[params.weapon_id] = nil

	if self._loaded_weapons then
		for _, part in pairs(parts) do
			table.insert(self._loaded_weapons[params.weapon_id], part.unit)
			part.unit:set_visible(false)
		end
	end

	self._weapons_loaded[params.weapon_id] = true

	local all_weapons_loaded = true

	for index, data in pairs(self._weapons_loaded) do
		all_weapons_loaded = all_weapons_loaded and self._weapons_loaded[index]
	end

	if all_weapons_loaded then
		self._weapons_assembled = true

		Application:trace("CharacterCreationGui:_assemble_completed: ALL WEAPONS ASSEMBLED")
	end
end

function CharacterCreationGui:_show_weapon(weapon_id)
	if not self._loaded_weapons then
		return
	end

	for wpn_id, wpn_units in pairs(self._loaded_weapons) do
		local visible = wpn_id == weapon_id

		for _, unit in ipairs(wpn_units) do
			unit:set_visible(visible)
		end
	end
end

function CharacterCreationGui:_destroy_weapon_parts_and_weapon_units()
	for wpn_id, wpn_units in pairs(self._loaded_weapons) do
		if self._weapons_loaded[wpn_id] then
			for _, unit in ipairs(wpn_units) do
				if alive(unit) then
					unit:set_slot(0)

					unit = nil
				end
			end
		end
	end

	self._loaded_weapons = nil
end

function CharacterCreationGui:_bind_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "_on_click_button_next"),
			key = Idstring("menu_controller_face_bottom"),
		},
		{
			callback = callback(self, self, "back_pressed"),
			key = Idstring("menu_controller_face_right"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_character_select",
		},
		keyboard = {
			{
				callback = callback(self, self, "_on_legend_pc_back"),
				key = "footer_back",
			},
		},
	}

	self:set_legend(legend)
end
