IntelGui = IntelGui or class(RaidGuiBase)
IntelGui.CATEGORY_BULLETINS = "bulletins"
IntelGui.CATEGORY_OPERATIONAL_STATUS = "operational_status"
IntelGui.CATEGORY_RAID_PERSONEL = "raid_personnel"
IntelGui.CATEGORY_OPPOSITION_FORCES = "opposition_forces"
IntelGui.CATEGORY_CONTROL_ARCHIVE = "control_archive"

function IntelGui:init(ws, fullscreen_ws, node, component_name)
	IntelGui.super.init(self, ws, fullscreen_ws, node, component_name)
	self._node.components.raid_menu_header:set_screen_name("menu_intel_screen_name")
end

function IntelGui:_set_initial_data()
	self._selected_category = IntelGui.CATEGORY_RAID_PERSONEL
end

function IntelGui:_layout()
	self:_disable_dof()
	self:_layout_content()
	self:_layout_tab_categories()
	self:_layout_list()
	self._category_items_list:set_selected(true, false)
	self:bind_controller_inputs()
end

function IntelGui:_layout_tab_categories()
	local category_tabs_params = {
		initial_tab_idx = 1,
		name = "category_tabs",
		on_click_callback = callback(self, self, "on_intel_category_selected"),
		parent_control_ref = self,
		tab_align = "center",
		tab_font_size = tweak_data.gui.font_sizes.small,
		tab_height = 64,
		tab_width = 220,
		tabs_params = {},
		y = 80,
	}

	for category_index, category_name in ipairs(tweak_data.intel.category_index) do
		category_tabs_params.tabs_params[category_index] = {}
		category_tabs_params.tabs_params[category_index].name = "tab_" .. category_name
		category_tabs_params.tabs_params[category_index].icon = nil
		category_tabs_params.tabs_params[category_index].text = self:translate(tweak_data.intel.categories[category_name].name_id, true)
		category_tabs_params.tabs_params[category_index].callback_param = category_name
	end

	self._category_tabs = self._root_panel:tabs(category_tabs_params)
end

function IntelGui:_layout_list()
	local category_items_list_scrollable_area_params = {
		h = 700,
		name = "category_items_list_scrollable_area",
		scroll_step = 19,
		scrollbar_width = 10,
		w = 460,
		y = 192,
	}

	self._category_items_list_scrollable_area = self._root_panel:scrollable_area(category_items_list_scrollable_area_params)

	local category_items_list_params = {
		data_source_callback = callback(self, self, "data_source_category_items_list"),
		item_class = RaidGUIControlListItem,
		item_font = tweak_data.gui.fonts.lato,
		item_font_size = tweak_data.gui.font_sizes.size_24,
		item_h = 62,
		loop_items = true,
		name = "category_items_list",
		on_item_clicked_callback = callback(self, self, "on_item_clicked_category_items_list"),
		on_item_selected_callback = callback(self, self, "on_item_selected_category_items_list"),
		on_mouse_over_sound_event = "highlight",
		scrollable_area_ref = self._category_items_list_scrollable_area,
		selection_enabled = true,
		use_unlocked = false,
		w = category_items_list_scrollable_area_params.w,
	}

	self._category_items_list = self._category_items_list_scrollable_area:get_panel():list(category_items_list_params)

	self._category_items_list_scrollable_area:setup_scroll_area()
end

function IntelGui:_layout_content()
	self:_create_category_controls(self._selected_category)
	self:_setup_category_controls(self._selected_category)
end

function IntelGui:close()
	IntelGui.super.close(self)
end

function IntelGui:on_intel_category_selected(data)
	self._selected_category = data

	self:_setup_category_controls(self._selected_category)

	if self._selected_category == IntelGui.CATEGORY_CONTROL_ARCHIVE then
		self:bind_controller_inputs_play_video()
	else
		self:bind_controller_inputs()
	end

	self._category_items_list:refresh_data()
	self._category_items_list_scrollable_area:setup_scroll_area()
	self._category_items_list:set_selected(true, false)
end

function IntelGui:on_item_clicked_category_items_list(data)
	self:_list_item_selected(data.value)
end

function IntelGui:on_item_selected_category_items_list(data)
	self:_list_item_selected(data.value)
end

function IntelGui:data_source_category_items_list()
	local result = {}
	local is_unlocked = true
	local data_source_table = tweak_data.intel.categories[self._selected_category].items

	if data_source_table then
		for list_item_index, list_item_data in pairs(data_source_table) do
			if self._selected_category == IntelGui.CATEGORY_CONTROL_ARCHIVE then
				is_unlocked = managers.unlock:is_unlocked({
					identifier = UnlockManager.CATEGORY_CONTROL_ARCHIVE,
					slot = UnlockManager.SLOT_PROFILE,
				}, {
					list_item_data.id,
				})
			elseif self._selected_category == IntelGui.CATEGORY_OPERATIONAL_STATUS or self._selected_category == IntelGui.CATEGORY_BULLETINS then
				list_item_index = #data_source_table - list_item_index + 1
				list_item_data = data_source_table[list_item_index]
			else
				is_unlocked = true
			end

			if is_unlocked then
				table.insert(result, {
					selected = #result == 0,
					text = self:translate(list_item_data.list_item_name_id, false),
					value = list_item_data.id,
				})
			end
		end
	end

	return result
end

function IntelGui:_list_item_selected(list_item_value)
	Application:trace("[IntelGui:_list_item_selected] list_item_value ", list_item_value)
	self:_show_selected_list_item_data(list_item_value)
end

function IntelGui:_create_category_controls(selected_category)
	self._bulletins_control = self._root_panel:create_custom_control(RaidGUIControlIntelBulletin, {
		h = 752,
		visible = false,
		w = 1120,
		x = 512,
		y = 144,
	})
	self._operational_status_control = self._root_panel:create_custom_control(RaidGUIControlIntelOperationalStatus, {
		h = 752,
		visible = false,
		w = 1120,
		x = 512,
		y = 144,
	})
	self._raid_personel_control = self._root_panel:create_custom_control(RaidGUIControlIntelRaidPersonel, {
		h = 768,
		visible = false,
		w = 1088,
		x = 512,
		y = 160,
	})
	self._opposite_forces_control = self._root_panel:create_custom_control(RaidGUIControlIntelOppositeForces, {
		h = 704,
		visible = false,
		w = 1024,
		x = 544,
		y = 192,
	})
	self._control_archive_control = self._root_panel:create_custom_control(RaidGUIControlIntelControlArchive, {
		h = 704,
		visible = false,
		w = 1024,
		x = 544,
		y = 192,
	})
end

function IntelGui:_setup_category_controls(selected_category)
	Application:info("[IntelGui:_setup_category_controls] selected_category ", selected_category)

	if selected_category == IntelGui.CATEGORY_BULLETINS then
		self._active_category_control = self._bulletins_control

		self._bulletins_control:set_visible(true)
		self._operational_status_control:set_visible(false)
		self._raid_personel_control:set_visible(false)
		self._opposite_forces_control:set_visible(false)
		self._control_archive_control:set_visible(false)
	elseif selected_category == IntelGui.CATEGORY_OPERATIONAL_STATUS then
		self._active_category_control = self._operational_status_control

		self._bulletins_control:set_visible(false)
		self._operational_status_control:set_visible(true)
		self._raid_personel_control:set_visible(false)
		self._opposite_forces_control:set_visible(false)
		self._control_archive_control:set_visible(false)
	elseif selected_category == IntelGui.CATEGORY_RAID_PERSONEL then
		self._active_category_control = self._raid_personel_control

		self._bulletins_control:set_visible(false)
		self._operational_status_control:set_visible(false)
		self._raid_personel_control:set_visible(true)
		self._opposite_forces_control:set_visible(false)
		self._control_archive_control:set_visible(false)
	elseif selected_category == IntelGui.CATEGORY_OPPOSITION_FORCES then
		self._active_category_control = self._opposite_forces_control

		self._bulletins_control:set_visible(false)
		self._operational_status_control:set_visible(false)
		self._raid_personel_control:set_visible(false)
		self._opposite_forces_control:set_visible(true)
		self._control_archive_control:set_visible(false)
	elseif selected_category == IntelGui.CATEGORY_CONTROL_ARCHIVE then
		self._active_category_control = self._control_archive_control

		self._bulletins_control:set_visible(false)
		self._operational_status_control:set_visible(false)
		self._raid_personel_control:set_visible(false)
		self._opposite_forces_control:set_visible(false)
		self._control_archive_control:set_visible(true)
	end
end

function IntelGui:_show_selected_list_item_data(list_item_value)
	self._active_category_control:set_data(list_item_value)

	local item_full_data = self._active_category_control:get_data()

	self:_stop_intel_audio()

	if item_full_data and item_full_data.description_vo_id then
		self:_play_intel_audio(item_full_data.description_vo_id)
	end
end

function IntelGui:update(t, dt)
	if self._control_archive_control then
		self._control_archive_control:update(t, dt)
	end
end

function IntelGui:_play_intel_audio(intel_audio_id)
	self._intel_audio = managers.menu_component:post_event(intel_audio_id)
end

function IntelGui:_stop_intel_audio()
	managers.queued_tasks:unqueue("play_intel_audio")

	if alive(self._intel_audio) then
		self._intel_audio:stop()

		self._intel_audio = nil
	end
end

function IntelGui:bind_controller_inputs()
	local bindings = {
		{
			callback = callback(self, self, "_on_weapon_category_tab_left"),
			key = Idstring("menu_controller_shoulder_left"),
		},
		{
			callback = callback(self, self, "_on_weapon_category_tab_right"),
			key = Idstring("menu_controller_shoulder_right"),
		},
	}
	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_intel_tabs",
		},
		keyboard = {
			{
				callback = callback(self, self, "_on_legend_pc_back", nil),
				key = "footer_back",
			},
		},
	}

	self:set_controller_bindings(bindings, true)
	self:set_legend(legend)
end

function IntelGui:bind_controller_inputs_play_video()
	local bindings = {
		{
			callback = callback(self, self, "_on_weapon_category_tab_left"),
			key = Idstring("menu_controller_shoulder_left"),
		},
		{
			callback = callback(self, self, "_on_weapon_category_tab_right"),
			key = Idstring("menu_controller_shoulder_right"),
		},
	}
	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_intel_tabs",
			"menu_legend_intel_play_video",
		},
		keyboard = {
			{
				callback = callback(self, self, "_on_legend_pc_back", nil),
				key = "footer_back",
			},
		},
	}

	self:set_controller_bindings(bindings, true)
	self:set_legend(legend)
end

function IntelGui:_on_weapon_category_tab_left()
	self._category_tabs:_move_left()

	return true, nil
end

function IntelGui:_on_weapon_category_tab_right()
	self._category_tabs:_move_right()

	return true, nil
end

function IntelGui:confirm_pressed()
	if self._selected_category == IntelGui.CATEGORY_CONTROL_ARCHIVE then
		local selected_item = self._category_items_list:selected_item()

		if selected_item then
			local selected_item_data = self._category_items_list:selected_item():data()

			self._control_archive_control:play_video()
		end
	end

	return true
end
