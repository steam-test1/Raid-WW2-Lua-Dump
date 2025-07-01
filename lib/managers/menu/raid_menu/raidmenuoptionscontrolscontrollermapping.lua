RaidMenuOptionsControlsControllerMapping = RaidMenuOptionsControlsControllerMapping or class(RaidGuiBase)

function RaidMenuOptionsControlsControllerMapping:init(ws, fullscreen_ws, node, component_name)
	self._label_font = tweak_data.gui.fonts.din_compressed
	self._label_font_size = tweak_data.gui.font_sizes.size_32

	RaidMenuOptionsControlsControllerMapping.super.init(self, ws, fullscreen_ws, node, component_name)
end

function RaidMenuOptionsControlsControllerMapping:_set_initial_data()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_controls_controller_mapping_on_foot")
end

function RaidMenuOptionsControlsControllerMapping:_layout()
	RaidMenuOptionsControlsControllerMapping.super._layout(self)

	self._controller_image = self._root_panel:bitmap({
		h = 600,
		name = "controller_image",
		texture = "ui/main_menu/textures/controller",
		w = 1200,
		x = 0,
		y = 0,
	})

	self._controller_image:set_center_x(self._root_panel:w() / 2)
	self._controller_image:set_center_y(self._root_panel:h() / 2)

	self._panel_on_foot = self._root_panel:panel({
		name = "panel_on_foot",
		visible = true,
		x = 0,
		y = 0,
	})
	self._panel_in_vehicle = self._root_panel:panel({
		name = "panel_on_foot",
		visible = false,
		x = 0,
		y = 0,
	})

	self:_layout_on_foot()
	self:_layout_in_vehicle()
	self:bind_controller_inputs_on_foot()
end

function RaidMenuOptionsControlsControllerMapping:close()
	RaidMenuOptionsControlsControllerMapping.super.close(self)
end

function RaidMenuOptionsControlsControllerMapping:_layout_on_foot()
	local southpaw = managers.user:get_setting("southpaw")
	local controller_bind_move_text = self:translate("menu_controller_keybind_move", true)
	local controller_bind_malee_text = self:translate("menu_controller_keybind_melee_attack", true)

	if southpaw then
		controller_bind_move_text = self:translate("menu_controller_keybind_melee_attack", true)
		controller_bind_malee_text = self:translate("menu_controller_keybind_move", true)
	end

	self._controller_keybind_aim = self._panel_on_foot:label({
		name = "aim_down_sight",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_aim_down_sight", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.007,
		control = self._controller_keybind_aim,
	})

	self._controller_keybind_lean = self._panel_on_foot:label({
		name = "lean",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_lean", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.14,
		control = self._controller_keybind_lean,
	})

	self._controller_keybind_move = self._panel_on_foot:label({
		name = "move",
		font = self._label_font,
		font_size = self._label_font_size,
		text = controller_bind_move_text,
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.362,
		control = self._controller_keybind_move,
	})

	self._controller_keybind_comm_wheel = self._panel_on_foot:label({
		name = "communication_wheel",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_comm_wheel", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.507,
		control = self._controller_keybind_comm_wheel,
	})

	self._controller_keybind_grenade = self._panel_on_foot:label({
		name = "grenade",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_grenade", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.582,
		control = self._controller_keybind_grenade,
	})

	self._controller_keybind_fire_mode = self._panel_on_foot:label({
		name = "fire_mode",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_weap_fire_mode", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.805,
		control = self._controller_keybind_fire_mode,
	})

	self._controller_keybind_knife = self._panel_on_foot:label({
		name = "knife",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_knife", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "bottom",
		coord_x = 0.466,
		control = self._controller_keybind_knife,
	})

	self._controller_keybind_melee_attack = self._panel_on_foot:label({
		name = "melee_attack",
		font = self._label_font,
		font_size = self._label_font_size,
		text = controller_bind_malee_text,
	})

	self:_set_position_size_controller_keybind_label({
		align = "bottom",
		coord_x = 0.615,
		control = self._controller_keybind_melee_attack,
	})

	self._controller_keybind_fire_weapon = self._panel_on_foot:label({
		name = "fire_weapon",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_fire_weapon", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.007,
		control = self._controller_keybind_fire_weapon,
	})

	self._controller_keybind_interact = self._panel_on_foot:label({
		name = "interact",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_interact", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.14,
		control = self._controller_keybind_interact,
	})

	self._controller_keybind_switch_weapons = self._panel_on_foot:label({
		name = "switch_weapons",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_switch_weapons", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.258,
		control = self._controller_keybind_switch_weapons,
	})

	self._controller_keybind_crouch = self._panel_on_foot:label({
		name = "crouch",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_crouch", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.357,
		control = self._controller_keybind_crouch,
	})

	self._controller_keybind_jump = self._panel_on_foot:label({
		name = "jump",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_jump", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.447,
		control = self._controller_keybind_jump,
	})

	self._controller_keybind_reload = self._panel_on_foot:label({
		name = "reload",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_reload", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.537,
		control = self._controller_keybind_reload,
	})

	self._controller_keybind_mission_info = self._panel_on_foot:label({
		name = "mission_info",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_mission_info", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "top",
		coord_x = 0.46,
		control = self._controller_keybind_mission_info,
	})

	self._controller_keybind_ingame_menu = self._panel_on_foot:label({
		name = "ingame_menu",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_ingame_menu", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "top",
		coord_x = 0.57,
		control = self._controller_keybind_ingame_menu,
	})
end

function RaidMenuOptionsControlsControllerMapping:_layout_in_vehicle()
	local southpaw = managers.user:get_setting("southpaw")
	local controller_bind_steering_text = self:translate("menu_controller_keybind_steering", true)
	local controller_bind_look_back_text = self:translate("menu_controller_keybind_look_back", true)

	if southpaw then
		controller_bind_steering_text = self:translate("menu_controller_keybind_not_available", true)
		controller_bind_look_back_text = self:translate("menu_controller_keybind_steering_southpaw", true)
	end

	self._controller_keybind_reverse = self._panel_in_vehicle:label({
		name = "reverse",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_reverse", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.007,
		control = self._controller_keybind_reverse,
	})

	self._controller_keybind_change_seat = self._panel_in_vehicle:label({
		name = "change_seat",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_change_seat", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.14,
		control = self._controller_keybind_change_seat,
	})

	self._controller_keybind_steering = self._panel_in_vehicle:label({
		name = "move",
		font = self._label_font,
		font_size = self._label_font_size,
		text = controller_bind_steering_text,
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.362,
		control = self._controller_keybind_steering,
	})

	self._controller_keybind_na2 = self._panel_in_vehicle:label({
		name = "na2",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_not_available", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.507,
		control = self._controller_keybind_na2,
	})

	self._controller_keybind_na3 = self._panel_in_vehicle:label({
		name = "na3",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_not_available", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.582,
		control = self._controller_keybind_na3,
	})

	self._controller_keybind_na4 = self._panel_in_vehicle:label({
		name = "na4",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_not_available", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "left",
		coord_y = 0.805,
		control = self._controller_keybind_na4,
	})

	self._controller_keybind_na5 = self._panel_in_vehicle:label({
		name = "na5",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_not_available", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "bottom",
		coord_x = 0.466,
		control = self._controller_keybind_na5,
	})

	self._controller_keybind_look_back = self._panel_in_vehicle:label({
		name = "look_back",
		font = self._label_font,
		font_size = self._label_font_size,
		text = controller_bind_look_back_text,
	})

	self:_set_position_size_controller_keybind_label({
		align = "bottom",
		coord_x = 0.615,
		control = self._controller_keybind_look_back,
	})

	self._controller_keybind_na7 = self._panel_in_vehicle:label({
		name = "accelerate",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_accelerate", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.007,
		control = self._controller_keybind_na7,
	})

	self._controller_keybind_exit_vehicle = self._panel_in_vehicle:label({
		name = "exit_vehicle",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_exit_vehicle", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.14,
		control = self._controller_keybind_exit_vehicle,
	})

	self._controller_keybind_na8 = self._panel_in_vehicle:label({
		name = "na8",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_not_available", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.258,
		control = self._controller_keybind_na8,
	})

	self._controller_keybind_switch_pose = self._panel_in_vehicle:label({
		name = "switch_pose",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_switch_pose", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.357,
		control = self._controller_keybind_switch_pose,
	})

	self._controller_keybind_handbrake = self._panel_in_vehicle:label({
		name = "handbrake",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_handbrake", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.447,
		control = self._controller_keybind_handbrake,
	})

	self._controller_keybind_na10 = self._panel_in_vehicle:label({
		name = "na10",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_not_available", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "right",
		coord_y = 0.537,
		control = self._controller_keybind_na10,
	})

	self._controller_keybind_mission_info_vehicle = self._panel_in_vehicle:label({
		name = "mission_info_vehicle",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_mission_info", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "top",
		coord_x = 0.46,
		control = self._controller_keybind_mission_info_vehicle,
	})

	self._controller_keybind_ingame_menu_vehicle = self._panel_in_vehicle:label({
		name = "ingame_menu_vehicle",
		font = self._label_font,
		font_size = self._label_font_size,
		text = self:translate("menu_controller_keybind_ingame_menu", true),
	})

	self:_set_position_size_controller_keybind_label({
		align = "top",
		coord_x = 0.57,
		control = self._controller_keybind_ingame_menu_vehicle,
	})
end

function RaidMenuOptionsControlsControllerMapping:_set_position_size_controller_keybind_label(params)
	local x, y, w, h = params.control:text_rect()

	params.control:set_w(w)
	params.control:set_h(h)
	params.control:set_align("center")

	if params.align == "left" then
		params.control:set_right(self._controller_image:x() + self._controller_image:w() * 0.13)
		params.control:set_center_y(self._controller_image:y() + self._controller_image:h() * params.coord_y)
	elseif params.align == "bottom" then
		params.control:set_top(self._controller_image:bottom())
		params.control:set_center_x(self._controller_image:x() + self._controller_image:w() * params.coord_x)
	elseif params.align == "right" then
		params.control:set_left(self._controller_image:right() - self._controller_image:w() * 0.13)
		params.control:set_center_y(self._controller_image:y() + self._controller_image:h() * params.coord_y)
	elseif params.align == "top" then
		params.control:set_bottom(self._controller_image:top())
		params.control:set_center_x(self._controller_image:x() + self._controller_image:w() * params.coord_x)
	end
end

function RaidMenuOptionsControlsControllerMapping:bind_controller_inputs_on_foot()
	local bindings = {
		{
			callback = callback(self, self, "_show_vehicle_mapping"),
			key = Idstring("menu_controller_shoulder_right"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_options_controller_mapping_in_vehicle",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	self:set_legend(legend)
end

function RaidMenuOptionsControlsControllerMapping:bind_controller_inputs_in_vehicle()
	local bindings = {
		{
			callback = callback(self, self, "_show_on_foot_mapping"),
			key = Idstring("menu_controller_shoulder_left"),
		},
	}

	self:set_controller_bindings(bindings, true)

	local legend = {
		controller = {
			"menu_legend_back",
			"menu_legend_options_controller_mapping_on_foot",
		},
		keyboard = {
			{
				key = "footer_back",
				callback = callback(self, self, "_on_legend_pc_back", nil),
			},
		},
	}

	self:set_legend(legend)
end

function RaidMenuOptionsControlsControllerMapping:_show_vehicle_mapping()
	self._panel_on_foot:hide()
	self._panel_in_vehicle:show()
	self:bind_controller_inputs_in_vehicle()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_controls_controller_mapping_in_vehicle")
end

function RaidMenuOptionsControlsControllerMapping:_show_on_foot_mapping()
	self._panel_on_foot:show()
	self._panel_in_vehicle:hide()
	self:bind_controller_inputs_on_foot()
	self._node.components.raid_menu_header:set_screen_name("menu_header_options_main_screen_name", "menu_header_options_controls_controller_mapping_on_foot")
end
