RaidGuiBase = RaidGuiBase or class()
RaidGuiBase.BACKGROUND_LAYER = 10
RaidGuiBase.FOREGROUND_LAYER = 20
RaidGuiBase.PADDING = 42
RaidGuiBase.MENU_ANIMATION_DISTANCE = 0
RaidGuiBase.Colors = {}
RaidGuiBase.Colors.screen_background = Color(0.85, 0, 0, 0)

function RaidGuiBase:init(ws, fullscreen_ws, node, component_name)
	managers.raid_menu:register_on_escape_callback(callback(self, self, "on_escape"))

	self._name = component_name
	self._ws = ws
	self._fullscreen_ws = fullscreen_ws
	self._node = node
	self._ws_panel = self._ws:panel()
	self._ws_panel = self._ws_panel:panel({
		background_color = self._background_color,
		h = self._panel_h,
		layer = self._panel_layer,
		name = self._name .. "_ws_panel",
		w = self._panel_w,
		x = self._panel_x,
		y = self._panel_y,
	})
	self._fullscreen_ws_panel = self._fullscreen_ws:panel()

	self:_setup_properties()
	self:_clear_controller_bindings()

	if not node.components then
		node.components = {}
	end

	self._node.components[self._name] = self
	self._controls = {}

	self:_set_initial_data()

	local params_root_panel = {
		background_color = self._background_color,
		h = self._panel_h,
		is_root_panel = self._panel_is_root_panel,
		layer = self._panel_layer,
		name = self._name .. "_panel",
		w = self._panel_w,
		x = self._panel_x,
		y = self._panel_y,
	}

	self._root_panel = RaidGUIPanel:new(self._ws_panel, params_root_panel)

	self:_layout()
	self._ws_panel:stop()
	self._ws_panel:animate(callback(self, self, "_animate_open"))
	managers.menu_component:post_event("menu_enter")
end

function RaidGuiBase:_setup_properties()
	self._panel_x = 0
	self._panel_y = 0
	self._panel_w = self._ws:width()
	self._panel_h = self._ws:height()
	self._panel_layer = RaidGuiBase.FOREGROUND_LAYER
	self._panel_is_root_panel = true
	self._background = true
end

function RaidGuiBase:_set_initial_data()
	return
end

function RaidGuiBase:translate(text, upper_case_flag)
	local button_macros = managers.localization:get_default_macros()
	local result = managers.localization:text(text, button_macros)

	if upper_case_flag then
		result = utf8.to_upper(result)
	end

	return result
end

function RaidGuiBase:_disable_dof()
	self._odof_near, self._odof_near_pad, self._odof_far, self._odof_far_pad = managers.environment_controller:get_dof_override_ranges()

	managers.environment_controller:set_dof_override(true)
	managers.environment_controller:set_dof_override_ranges(0, 0, 100000, 0, 0)
end

function RaidGuiBase:_enable_dof()
	managers.environment_controller:set_dof_override_ranges(self._odof_near, self._odof_near_pad, self._odof_far, self._odof_far_pad)
	managers.environment_controller:set_dof_override(false)
end

function RaidGuiBase:_layout()
	return
end

function RaidGuiBase:close()
	self._node.components[self._name] = nil

	for _, control in ipairs(self._controls) do
		control:close()
	end

	self._ws_panel:stop()
	self._ws_panel:animate(callback(self, self, "_animate_close"))
	managers.menu_component:post_event("menu_exit")
end

function RaidGuiBase:_close()
	self._root_panel:close()
	self._ws:panel():remove(self._ws_panel)
	self._fullscreen_ws_panel:clear()
end

function RaidGuiBase:mouse_moved(o, x, y)
	local active_control = managers.raid_menu:get_active_control()

	if active_control then
		local used, pointer = active_control:on_mouse_moved(o, x, y)

		return used, pointer
	end

	return self._root_panel:mouse_moved(o, x, y)
end

function RaidGuiBase:mouse_pressed(o, button, x, y)
	if button == Idstring("mouse wheel up") then
		return self._root_panel:mouse_scroll_up(o, button, x, y)
	elseif button == Idstring("mouse wheel down") then
		return self._root_panel:mouse_scroll_down(o, button, x, y)
	else
		return self._root_panel:mouse_pressed(o, button, x, y)
	end
end

function RaidGuiBase:mouse_clicked(o, button, x, y)
	return self._root_panel:mouse_clicked(o, button, x, y)
end

function RaidGuiBase:mouse_double_click(o, button, x, y)
	return self._root_panel:mouse_double_click(o, button, x, y)
end

function RaidGuiBase:mouse_released(o, button, x, y)
	local is_left_click = button == Idstring("0")

	if not is_left_click then
		return true
	end

	managers.raid_menu:clear_active_control()

	return self._root_panel:mouse_released(o, button, x, y)
end

function RaidGuiBase:back_pressed()
	managers.raid_menu:on_escape()

	return true
end

function RaidGuiBase:move_up()
	return self._root_panel:move_up()
end

function RaidGuiBase:move_down()
	return self._root_panel:move_down()
end

function RaidGuiBase:move_left()
	return self._root_panel:move_left()
end

function RaidGuiBase:move_right()
	return self._root_panel:move_right()
end

function RaidGuiBase:scroll_up()
	return self._root_panel:scroll_up()
end

function RaidGuiBase:scroll_down()
	return self._root_panel:scroll_down()
end

function RaidGuiBase:scroll_left()
	return self._root_panel:scroll_left()
end

function RaidGuiBase:scroll_right()
	return self._root_panel:scroll_right()
end

function RaidGuiBase:confirm_pressed()
	return self._root_panel:confirm_pressed()
end

function RaidGuiBase:on_escape()
	return false
end

function RaidGuiBase:_clear_controller_bindings()
	self._controller_bindings = {}
end

function RaidGuiBase:set_controller_bindings(bindings, clear_old)
	if clear_old then
		self:_clear_controller_bindings()
	end

	for _, binding in ipairs(bindings) do
		local found = false

		for index, current_binding in ipairs(self._controller_bindings) do
			if current_binding.key == binding.key then
				self._controller_bindings[index] = binding
				found = true
			end
		end

		if not found then
			table.insert(self._controller_bindings, binding)
		end
	end
end

function RaidGuiBase:special_btn_pressed(button)
	local binding_to_trigger

	for index, binding in ipairs(self._controller_bindings) do
		if binding.key == button then
			binding_to_trigger = binding
		end
	end

	if binding_to_trigger then
		return binding_to_trigger.callback(binding_to_trigger.data)
	end

	return false, nil
end

function RaidGuiBase:set_legend(legend)
	managers.raid_menu:set_legend_labels(legend)
end

function RaidGuiBase:_on_legend_pc_back()
	managers.raid_menu:on_escape()
end

function RaidGuiBase:_animate_open()
	local duration = 0.15
	local t = 0

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quadratic_out(t, 0, 1, duration)

		self._ws_panel:set_alpha(current_alpha)

		local current_offset = Easing.quadratic_out(t, RaidGuiBase.MENU_ANIMATION_DISTANCE, -RaidGuiBase.MENU_ANIMATION_DISTANCE, duration)

		self._ws_panel:set_x(current_offset)
	end

	self._ws_panel:set_alpha(1)
	self._ws_panel:set_x(0)
end

function RaidGuiBase:_animate_close()
	local duration = 0.15
	local t = 0

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_alpha = Easing.quadratic_in(t, 1, -1, duration)

		self._ws_panel:set_alpha(current_alpha)

		local current_offset = Easing.quadratic_in(t, 0, RaidGuiBase.MENU_ANIMATION_DISTANCE, duration)

		self._ws_panel:set_x(current_offset)
	end

	self:_close()
end
