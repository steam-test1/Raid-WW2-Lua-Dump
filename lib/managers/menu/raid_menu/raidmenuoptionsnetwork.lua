RaidMenuOptionsNetwork = RaidMenuOptionsNetwork or class(RaidGuiBase)

function RaidMenuOptionsNetwork:init(ws, fullscreen_ws, node, component_name)
	RaidMenuOptionsNetwork.super.init(self, ws, fullscreen_ws, node, component_name)
end

function RaidMenuOptionsNetwork:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_network_subtitle")
end

function RaidMenuOptionsNetwork:_layout()
	RaidMenuOptionsNetwork.super._layout(self)
	self:_layout_network()
	self:_load_network_values()
	self._toggle_menu_packet_throttling:set_selected(true)
	self:bind_controller_inputs()
end

function RaidMenuOptionsNetwork:close()
	managers.savefile:save_setting(true)
	RaidMenuOptionsNetwork.super.close(self)
end

function RaidMenuOptionsNetwork:_layout_network()
	local start_x = 0
	local start_y = 320
	local default_width = 512
	local packet_throttling_params = {
		description = utf8.to_upper(managers.localization:text("menu_packet_throttling")),
		name = "packet_throttling_params",
		on_click_callback = callback(self, self, "on_click_toggle_packet_throttling"),
		on_menu_move = {
			down = "push_to_talk",
			up = "use_compression",
		},
		w = default_width,
		x = start_x,
		y = start_y,
	}

	self._toggle_menu_packet_throttling = self._root_panel:toggle_button(packet_throttling_params)

	local forwarding_params = {
		description = utf8.to_upper(managers.localization:text("menu_net_forwarding")),
		name = "push_to_talk",
		on_click_callback = callback(self, self, "on_click_toggle_net_forwarding"),
		on_menu_move = {
			down = "use_compression",
			up = "packet_throttling_params",
		},
		w = default_width,
		x = start_x,
		y = packet_throttling_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_net_forwarding = self._root_panel:toggle_button(forwarding_params)

	local use_compression_params = {
		description = utf8.to_upper(managers.localization:text("menu_net_use_compression")),
		name = "use_compression",
		on_click_callback = callback(self, self, "on_click_toggle_net_use_compression"),
		on_menu_move = {
			down = "packet_throttling_params",
			up = "push_to_talk",
		},
		w = default_width,
		x = start_x,
		y = forwarding_params.y + RaidGuiBase.PADDING,
	}

	self._toggle_menu_net_use_compression = self._root_panel:toggle_button(use_compression_params)
end

function RaidMenuOptionsNetwork:_load_network_values()
	local net_packet_throttling = managers.user:get_setting("net_packet_throttling")
	local net_forwarding = managers.user:get_setting("net_forwarding")
	local net_use_compression = managers.user:get_setting("net_use_compression")

	self._toggle_menu_packet_throttling:set_value_and_render(net_packet_throttling)
	self._toggle_menu_net_forwarding:set_value_and_render(net_forwarding)
	self._toggle_menu_net_use_compression:set_value_and_render(net_use_compression)
end

function RaidMenuOptionsNetwork:on_click_toggle_packet_throttling()
	local net_packet_throttling = self._toggle_menu_packet_throttling:get_value()

	managers.menu:active_menu().callback_handler:toggle_net_throttling_raid(net_packet_throttling)
end

function RaidMenuOptionsNetwork:on_click_toggle_net_forwarding()
	local net_forwarding = self._toggle_menu_net_forwarding:get_value()

	managers.menu:active_menu().callback_handler:toggle_net_forwarding_raid(net_forwarding)
end

function RaidMenuOptionsNetwork:on_click_toggle_net_use_compression()
	local net_use_compression = self._toggle_menu_net_use_compression:get_value()

	managers.menu:active_menu().callback_handler:toggle_net_use_compression_raid(net_use_compression)
end

function RaidMenuOptionsNetwork:on_click_default_network()
	managers.menu:show_default_option_dialog({
		callback = function()
			managers.user:reset_setting_map("network")
			self:_load_network_values()
		end,
		text = managers.localization:text("dialog_default_network_options_message"),
	})
end

function RaidMenuOptionsNetwork:bind_controller_inputs()
	local legend = {
		controller = {
			"menu_legend_back",
		},
		keyboard = {
			{
				callback = callback(self, self, "_on_legend_pc_back", nil),
				key = "footer_back",
			},
		},
	}

	self:set_legend(legend)
end
