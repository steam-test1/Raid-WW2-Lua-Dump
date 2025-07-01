GoldAssetStoreGui = GoldAssetStoreGui or class(RaidGuiBase)
GoldAssetStoreGui.CONFIRM_PRESSED_STATE_BUY = "state_buy"

function GoldAssetStoreGui:init(ws, fullscreen_ws, node, component_name)
	GoldAssetStoreGui.super.init(self, ws, fullscreen_ws, node, component_name)
	self._node.components.raid_menu_header:set_screen_name("menu_gold_asset_store_title")

	self._confirm_pressed_state = nil

	managers.raid_menu:hide_background()
end

function GoldAssetStoreGui:_setup_properties()
	GoldAssetStoreGui.super._setup_properties(self)

	self._background = nil
	self._background_rect = nil
end

function GoldAssetStoreGui:_set_initial_data()
	self._loaded_units = {}
	self._unit_data_to_show = nil
end

function GoldAssetStoreGui:_layout()
	self:_disable_dof()

	local gold_asset_store_grid_scrollable_area_params = {
		h = 612,
		name = "gold_asset_store_grid_scrollable_area",
		scroll_step = 30,
		w = 484,
		x = 0,
		y = 128,
	}

	self._gold_asset_store_grid_scrollable_area = self._root_panel:scrollable_area(gold_asset_store_grid_scrollable_area_params)

	local gold_asset_store_grid_params = {
		name = "gold_asset_store_grid",
		w = 480,
		x = 0,
		y = 0,
		grid_params = {
			scroll_marker_w = 32,
			vertical_spacing = 5,
			data_source_callback = callback(self, self, "_data_source_gold_asset_store"),
			on_click_callback = callback(self, self, "_on_click_gold_asset_store"),
			on_select_callback = callback(self, self, "_on_selected_gold_asset_store"),
		},
		item_params = {
			grid_item_icon = "grid_icon",
			item_h = 134,
			item_w = 134,
			key_value_field = "upgrade_name",
			selected_marker_h = 148,
			selected_marker_w = 148,
			row_class = RaidGUIControlGridItem,
		},
		scrollable_area_ref = self._gold_asset_store_grid_scrollable_area,
	}

	self._gold_asset_store_grid = self._gold_asset_store_grid_scrollable_area:get_panel():grid(gold_asset_store_grid_params)

	local params_rotate_gold_item = {
		h = 750,
		name = "rotate_gold_item",
		w = 800,
		x = 500,
		y = 90,
	}

	self._rotate_gold_item = self._root_panel:rotate_unit(params_rotate_gold_item)
	self._item_title = self._root_panel:label({
		align = "right",
		h = 64,
		text = "",
		w = 352,
		x = 0,
		y = 0,
		color = tweak_data.gui.colors.raid_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.large,
	})
	self._item_description = self._root_panel:label({
		h = 352,
		text = "",
		w = 352,
		wrap = true,
		x = 0,
		y = 192,
		color = tweak_data.gui.colors.raid_grey,
		font = tweak_data.gui.fonts.lato,
		font_size = tweak_data.gui.font_sizes.size_20,
	})

	self._item_title:set_right(self._root_panel:w())
	self._item_title:set_center_y(128)
	self._item_description:set_right(self._root_panel:w())

	self._coord_center_y = 864
	self._buy_button = self._root_panel:short_primary_gold_button({
		name = "buy_button",
		visible = false,
		x = 0,
		layer = RaidGuiBase.FOREGROUND_LAYER,
		on_click_callback = callback(self, self, "_on_click_button_buy"),
		text = self:translate("gold_item_buy_button", true),
	})

	self._buy_button:set_center_y(self._coord_center_y)

	self._info_label = self._root_panel:label({
		name = "info_label",
		visible = false,
		x = 0,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.small,
		layer = RaidGuiBase.FOREGROUND_LAYER,
		text = self:translate("grid_item_insuficient_gold_label", true),
	})

	local x1, y1, w1, h1 = self._info_label:text_rect()

	self._info_label:set_h(h1)
	self._info_label:set_center_y(self._coord_center_y)

	self._gold_currency_label = self._root_panel:label({
		name = "gold_currency_label",
		text = "",
		visible = false,
		x = 250,
		color = tweak_data.gui.colors.gold_orange,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_38,
		layer = RaidGuiBase.FOREGROUND_LAYER,
	})

	local x2, y2, w2, h2 = self._gold_currency_label:text_rect()

	self._gold_currency_label:set_h(h2)
	self._gold_currency_label:set_w(w2)
	self._gold_currency_label:set_center_y(self._coord_center_y)
	self._gold_currency_label:set_right(512)

	self._gold_currency_icon = self._root_panel:bitmap({
		name = "gold_currency_icon",
		visible = false,
		x = 200,
		color = tweak_data.gui.colors.gold_orange,
		layer = RaidGuiBase.FOREGROUND_LAYER,
		texture = tweak_data.gui.icons.gold_amount_purchase.texture,
		texture_rect = tweak_data.gui.icons.gold_amount_purchase.texture_rect,
	})

	self._gold_currency_icon:set_center_y(self._coord_center_y)
	self._gold_currency_icon:set_right(self._gold_currency_label:x() - 14)

	self._gold_item_bought_icon = self._root_panel:bitmap({
		name = "gold_item_bought_icon",
		visible = false,
		x = 200,
		layer = RaidGuiBase.FOREGROUND_LAYER,
		texture = tweak_data.gui.icons.consumable_purchased_confirmed.texture,
		texture_rect = tweak_data.gui.icons.consumable_purchased_confirmed.texture_rect,
	})

	self._gold_item_bought_icon:set_center_y(self._coord_center_y)
	self._gold_item_bought_icon:set_right(self._gold_currency_label:x() - 14)
	self:bind_controller_inputs()
	self._gold_asset_store_grid_scrollable_area:setup_scroll_area()
	self._gold_asset_store_grid:set_selected(true)

	local selected_item = self._gold_asset_store_grid:selected_grid_item()

	if selected_item then
		local selected_item_data = selected_item:get_data()

		self:_populate_selected_item_data_and_load(selected_item_data)
	end
end

function GoldAssetStoreGui:_data_source_gold_asset_store()
	local gold_items_data_source = managers.gold_economy:get_store_items_data()

	return gold_items_data_source
end

function GoldAssetStoreGui:_on_click_gold_asset_store(item_data)
	self:_grid_item_clicked_selected(item_data)
end

function GoldAssetStoreGui:_on_selected_gold_asset_store(item_idx, item_data)
	self:_grid_item_clicked_selected(item_data)
end

function GoldAssetStoreGui:_on_click_button_buy()
	local selected_item = self._gold_asset_store_grid:selected_grid_item()
	local selected_item_data = selected_item:get_data()
	local dialog_params = {
		amount = selected_item_data.gold_price,
		callback_yes = callback(self, self, "_buy_gold_item_yes_callback", selected_item_data),
		item_name = self:translate(selected_item_data.name_id, true),
	}

	managers.menu:show_gold_asset_store_purchase_dialog(dialog_params)
end

function GoldAssetStoreGui:update(t, dt)
	if self._unit_data_to_show and self._loaded_units[self._unit_data_to_show.scene_unit] and self._unit_data_to_show_changed then
		self:_spawn_scene_camp_unit(self._unit_data_to_show)

		self._unit_data_to_show_changed = false
	end
end

function GoldAssetStoreGui:_grid_item_clicked_selected(item_data)
	if self._unit_data_to_show == item_data then
		return
	end

	self:_despawn_scene_camp_unit()

	self._unit_data_to_show = item_data
	self._unit_data_to_show_changed = true

	self:_populate_selected_item_data_and_load(item_data)
end

function GoldAssetStoreGui:_populate_selected_item_data_and_load(item_data)
	self:_load_scene_camp_unit(item_data)
	self._item_title:set_text(self:translate(item_data.name_id, true))
	self._item_description:set_text(self:translate(item_data.description_id, false))
	self:_process_controls_states()
end

function GoldAssetStoreGui:_load_scene_camp_unit(item_data)
	if not item_data.scene_unit or item_data.scene_unit == "" then
		return
	end

	self._loaded_units[item_data.scene_unit] = false

	managers.dyn_resource:load(Idstring("unit"), Idstring(item_data.scene_unit), DynamicResourceManager.DYN_RESOURCES_PACKAGE, callback(self, self, "_camp_scene_unit_loaded_callback", item_data))
end

function GoldAssetStoreGui:_spawn_scene_camp_unit(unit_data_to_show)
	self._spawned_unit_position = self:get_character_spawn_location()
	self._spawned_unit = World:spawn_unit(Idstring(unit_data_to_show.scene_unit), self._spawned_unit_position, Rotation(0, 0, 0))

	if unit_data_to_show and unit_data_to_show.scene_unit_rotation then
		self._spawned_unit:set_rotation(unit_data_to_show.scene_unit_rotation)
	end

	self._rotate_gold_item:set_unit(self._spawned_unit, self._spawned_unit_position, 90, self._spawned_unit_offset, Vector3(0, 0, 0))
end

function GoldAssetStoreGui:get_character_spawn_location()
	local units = World:find_units_quick("all", managers.slot:get_mask("env_effect"))
	local result

	if units then
		for _, unit in pairs(units) do
			if unit:name() == Idstring("units/vanilla/props/props_camp_upgrades/golden_store_floor/golden_store_floor") then
				result = unit:get_object(Idstring("rp_golden_store_floor")):position()

				mvector3.add(result, Vector3(0, 0, 10))
			end
		end
	end

	return result
end

function GoldAssetStoreGui:pix_to_screen(px_x, px_y)
	local sx = 2 * px_x / self._root_panel:w() - 1
	local sy = 2 * px_y / self._root_panel:h() - 1

	return sx, sy
end

function GoldAssetStoreGui:_despawn_scene_camp_unit()
	if self._spawned_unit then
		self._spawned_unit:set_slot(0)

		self._spawned_unit = nil
	end
end

function GoldAssetStoreGui:_camp_scene_unit_loaded_callback(item_data)
	self._loaded_units[item_data.scene_unit] = true
end

function GoldAssetStoreGui:_process_controls_states()
	local selected_item_data = self._gold_asset_store_grid:selected_grid_item():get_data()

	if selected_item_data.gold_price then
		self._gold_currency_label:set_text(selected_item_data.gold_price)

		local x2, y2, w2, h2 = self._gold_currency_label:text_rect()

		self._gold_currency_label:set_h(h2)
		self._gold_currency_label:set_w(w2)
		self._gold_currency_label:set_center_y(self._coord_center_y)
		self._gold_currency_label:set_right(512)
		self._gold_currency_icon:set_center_y(self._coord_center_y)
		self._gold_currency_icon:set_right(self._gold_currency_label:x() - 14)
		self._gold_item_bought_icon:set_center_y(self._coord_center_y)
		self._gold_item_bought_icon:set_right(self._gold_currency_label:x() - 14)
	end

	if Network:is_server() then
		if selected_item_data.status == RaidGUIControlGridItem.STATUS_OWNED_OR_PURCHASED then
			self._buy_button:show()
			self._buy_button:disable()
			self._buy_button:set_text(self:translate("gold_asset_store_purchased_button", true))
			self._info_label:hide()
			self._gold_currency_icon:hide()
			self._gold_currency_label:show()
			self._gold_item_bought_icon:show()
			self:bind_controller_inputs()
		elseif selected_item_data.status == RaidGUIControlGridItem.STATUS_PURCHASABLE then
			self._buy_button:show()
			self._buy_button:enable()
			self._buy_button:set_text(self:translate("gold_asset_store_buy_button", true))
			self._info_label:hide()
			self._gold_currency_icon:show()
			self._gold_currency_label:show()
			self._gold_item_bought_icon:hide()
			self:bind_controller_inputs_buy()
		elseif selected_item_data.status == RaidGUIControlGridItem.STATUS_NOT_ENOUGHT_RESOURCES then
			self._buy_button:hide()
			self._info_label:show()
			self._info_label:set_text(self:translate("gold_asset_store_insuficient_gold_label", true))
			self._info_label:set_color(tweak_data.gui.colors.raid_red)
			self._gold_currency_icon:show()
			self._gold_currency_label:show()
			self._gold_item_bought_icon:hide()
			self:bind_controller_inputs()
		end
	else
		self._info_label:show()
		self._info_label:set_text(self:translate("gold_asset_store_only_host", true))
		self._info_label:set_color(tweak_data.gui.colors.raid_red)
		self._gold_currency_icon:hide()
		self._gold_currency_label:hide()
		self._gold_item_bought_icon:hide()
		self:bind_controller_inputs()
	end
end

function GoldAssetStoreGui:_buy_gold_item_yes_callback(item_data)
	Application:trace("[GoldAssetStoreGui:_buy_gold_item_yes_callback] item_data ", inspect(item_data))
	managers.gold_economy:spend_gold(item_data.gold_price)
	managers.gold_economy:update_camp_upgrade(item_data.upgrade_name, item_data.level)
	self._gold_asset_store_grid:refresh_data()
	self._gold_asset_store_grid:select_grid_item_by_key_value({
		key = "upgrade_name",
		value = item_data.upgrade_name,
	})
	self:_process_controls_states()
	managers.savefile:setting_changed()
	managers.savefile:save_setting(true)
	managers.gold_economy:layout_camp()
	managers.menu_component:post_event("gold_spending_apply")
end

function GoldAssetStoreGui:close()
	for scene_unit, loaded in pairs(self._loaded_units) do
		if not loaded then
			Application:trace("[GoldAssetStoreGui][close] Unloading unit ", scene_unit)
			managers.dyn_resource:unload(Idstring("unit"), Idstring(scene_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE, false)
		end
	end

	self:_despawn_scene_camp_unit()
	self:_enable_dof()
	GoldAssetStoreGui.super.close(self)
end

function GoldAssetStoreGui:bind_controller_inputs()
	local legend = {
		controller = {
			"menu_legend_back",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	self:set_legend(legend)

	self._confirm_pressed_state = nil
end

function GoldAssetStoreGui:bind_controller_inputs_buy()
	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_gold_asset_store_buy",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	self:set_legend(legend)

	self._confirm_pressed_state = GoldAssetStoreGui.CONFIRM_PRESSED_STATE_BUY
end

function GoldAssetStoreGui:confirm_pressed()
	local selected_item = self._gold_asset_store_grid:selected_grid_item()

	if selected_item and selected_item:get_data() and self._confirm_pressed_state == GoldAssetStoreGui.CONFIRM_PRESSED_STATE_BUY then
		self:_on_click_button_buy()
	end

	return true
end
