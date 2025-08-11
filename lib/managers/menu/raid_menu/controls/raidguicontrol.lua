RaidGUIControl = RaidGUIControl or class()
RaidGUIControl.ID = 1
RaidGUIControl.IDS_MOUSE_0 = Idstring("0")
RaidGUIControl.IDS_MOUSE_1 = Idstring("1")

function RaidGUIControl:init(parent, params)
	self._type = self._type or "raid_gui_control"
	self._control_id = RaidGUIControl.ID
	RaidGUIControl.ID = RaidGUIControl.ID + 1
	self._name = params.name or self._type .. "_" .. self._control_id
	self._parent = parent
	self._parent_panel = params.panel or parent.get_panel and parent:get_panel() or parent:panel()
	self._params = clone(params)
	self._params.name = params.name or self._name
	self._mouse_inside = false
	self._params.color = params.color or Color.white
	self._params.layer = params.layer or self._parent_panel:layer() or RaidGuiBase.FOREGROUND_LAYER
	self._params.blend_mode = params.blend_mode or "normal"
	self._panel = self._parent_panel
	self._params.panel = self._panel
	self._pointer_type = "arrow"
	self._on_mouse_enter_callback = params.on_mouse_enter_callback
	self._on_mouse_exit_callback = params.on_mouse_exit_callback
	self._autoconfirm = params.autoconfirm
	self._on_menu_move = params.on_menu_move
	self._selected_control = false
	self._callback_handler = RaidMenuCallbackHandler:new()
	self._enabled = self._params.enabled or true
	self._selectable = self._params.selectable or true
end

function RaidGUIControl:name()
	return self._params.name
end

function RaidGUIControl:set_param_value(param_name, param_value)
	self._params[param_name] = param_value
end

function RaidGUIControl:close()
	return
end

function RaidGUIControl:translate(text, upper_case_flag, additional_macros)
	local button_macros

	if additional_macros then
		button_macros = clone(managers.localization:get_default_macros())

		for index, macro in pairs(additional_macros) do
			button_macros[index] = macro
		end
	else
		button_macros = managers.localization:get_default_macros()
	end

	local result = managers.localization:text(text, button_macros)

	if upper_case_flag then
		result = utf8.to_upper(result)
	end

	return result
end

function RaidGUIControl:inside(x, y)
	return self._object and self._object:inside(x, y) and self._object:tree_visible()
end

function RaidGUIControl:mouse_moved(o, x, y)
	if self:inside(x, y) then
		if not self._mouse_inside then
			self:on_mouse_over(x, y)
		end

		self:on_mouse_moved(o, x, y)

		return true, self._pointer_type
	end

	if self._mouse_inside then
		self:on_mouse_out(x, y)
	end

	return false
end

function RaidGUIControl:mouse_pressed(o, button, x, y)
	if self:inside(x, y) then
		self._mouse_pressed = true

		return self:on_mouse_pressed(button, x, y)
	end

	return false
end

function RaidGUIControl:mouse_clicked(o, button, x, y)
	if self:inside(x, y) then
		return self:on_mouse_clicked(button)
	end

	return false
end

function RaidGUIControl:mouse_released(o, button, x, y)
	if self:inside(x, y) and self._mouse_pressed then
		self._mouse_pressed = nil

		return self:on_mouse_released(button)
	end

	return false
end

function RaidGUIControl:mouse_scroll_up(o, button, x, y)
	if self:inside(x, y) then
		return self:on_mouse_scroll_up(button)
	end

	return false
end

function RaidGUIControl:mouse_scroll_down(o, button, x, y)
	if self:inside(x, y) then
		return self:on_mouse_scroll_down(button)
	end

	return false
end

function RaidGUIControl:mouse_double_click(o, button, x, y)
	if self:inside(x, y) and self.on_double_click then
		return self:on_double_click(button)
	end

	return false
end

function RaidGUIControl:on_mouse_moved(o, x, y)
	return
end

function RaidGUIControl:on_mouse_over(x, y)
	self._mouse_inside = true

	self:highlight_on()

	if self._on_mouse_enter_callback then
		self._on_mouse_enter_callback(self, self._data)
	end
end

function RaidGUIControl:on_mouse_out(x, y)
	self._mouse_inside = false

	self:highlight_off()

	if self._on_mouse_exit_callback then
		self._on_mouse_exit_callback(self, self._data)
	end
end

function RaidGUIControl:on_mouse_pressed()
	return false
end

function RaidGUIControl:on_mouse_clicked()
	return false
end

function RaidGUIControl:on_mouse_released()
	return false
end

function RaidGUIControl:on_mouse_double_click()
	return false
end

function RaidGUIControl:on_mouse_scroll_up()
	return false
end

function RaidGUIControl:on_mouse_scroll_down()
	return false
end

function RaidGUIControl:highlight_on()
	if self._object and self._object.highlight_on then
		self._object:highlight_on()
	end
end

function RaidGUIControl:highlight_off()
	if self._object and self._object.highlight_off then
		self._object:highlight_off()
	end
end

function RaidGUIControl:show()
	if self._object then
		self._object:show()
	end
end

function RaidGUIControl:hide()
	if self._object then
		self._object:hide()
	end
end

function RaidGUIControl:center_x()
	if self._object then
		return self._object:center_x()
	end
end

function RaidGUIControl:center_y()
	if self._object then
		return self._object:center_y()
	end
end

function RaidGUIControl:set_center_x(x)
	if self._object then
		self._object:set_center_x(x)
	end
end

function RaidGUIControl:set_center_y(y)
	if self._object then
		self._object:set_center_y(y)
	end
end

function RaidGUIControl:set_center(x, y)
	if self._object then
		self._object:set_center(x, y)
	end
end

function RaidGUIControl:rotate(angle)
	if self._object then
		self._object:rotate(angle)
	end
end

function RaidGUIControl:set_rotation(angle)
	if self._object then
		self._object:set_rotation(angle)
	end
end

function RaidGUIControl:rotation()
	return self._object and self._object:rotation()
end

function RaidGUIControl:set_visible(visible)
	if self._object then
		self._object:set_visible(visible)
	end
end

function RaidGUIControl:visible()
	if self._object and self._object.alive then
		return alive(self._object) and self._object:visible()
	end

	return self._object:visible()
end

function RaidGUIControl:set_selectable(value)
	self._selectable = value
end

function RaidGUIControl:selectable()
	return self._selectable
end

function RaidGUIControl:set_alpha(alpha)
	if self._object and self._object.set_alpha then
		self._object:set_alpha(alpha)
	end
end

function RaidGUIControl:alpha()
	if self._object and self._object.alpha then
		return self._object:alpha()
	end

	return nil
end

function RaidGUIControl:set_x(x)
	if self._object then
		self._object:set_x(x)
	end
end

function RaidGUIControl:set_top(value)
	if self._object then
		self._object:set_top(value)
	end
end

function RaidGUIControl:set_bottom(value)
	if self._object then
		self._object:set_bottom(value)
	end
end

function RaidGUIControl:set_right(value)
	if self._object then
		self._object:set_right(value)
	end
end

function RaidGUIControl:set_left(value)
	if self._object then
		self._object:set_left(value)
	end
end

function RaidGUIControl:set_y(y)
	if self._object then
		self._object:set_y(y)
	end
end

function RaidGUIControl:set_w(w)
	if self._object then
		self._object:set_w(w)
	end
end

function RaidGUIControl:set_h(h)
	if self._object then
		self._object:set_h(h)
	end
end

function RaidGUIControl:w()
	return self._object and self._object:w()
end

function RaidGUIControl:h()
	return self._object and self._object:h()
end

function RaidGUIControl:x()
	return self._object and self._object:x()
end

function RaidGUIControl:y()
	return self._object and self._object:y()
end

function RaidGUIControl:world_x()
	return self._object and self._object:world_x()
end

function RaidGUIControl:world_y()
	return self._object and self._object:world_y()
end

function RaidGUIControl:layer()
	return self._object and self._object:layer() or self._params.layer
end

function RaidGUIControl:set_layer(layer)
	if self._object then
		return self._object._engine_panel:set_layer(layer)
	end
end

function RaidGUIControl:left()
	return self._object and self._object:left()
end

function RaidGUIControl:right()
	return self._object and self._object:right()
end

function RaidGUIControl:top()
	return self._object and self._object:top()
end

function RaidGUIControl:bottom()
	return self._object and self._object:bottom()
end

function RaidGUIControl:set_selected(value)
	self._selected = value

	if self._selected then
		self:highlight_on()
	else
		self:highlight_off()
	end
end

function RaidGUIControl:is_selected()
	return self._selected
end

function RaidGUIControl:move_up()
	if self._selected and self._on_menu_move and self._on_menu_move.up then
		return self:_menu_move_to(self._on_menu_move.up, "up")
	end
end

function RaidGUIControl:move_down()
	if self._selected and self._on_menu_move and self._on_menu_move.down then
		return self:_menu_move_to(self._on_menu_move.down, "down")
	end
end

function RaidGUIControl:move_left()
	if self._selected and self._on_menu_move and self._on_menu_move.left then
		return self:_menu_move_to(self._on_menu_move.left, "left")
	end
end

function RaidGUIControl:move_right()
	if self._selected and self._on_menu_move and self._on_menu_move.right then
		return self:_menu_move_to(self._on_menu_move.right, "right")
	end
end

function RaidGUIControl:scroll_up()
	return false
end

function RaidGUIControl:scroll_down()
	return false
end

function RaidGUIControl:scroll_left()
	return false
end

function RaidGUIControl:scroll_right()
	return false
end

function RaidGUIControl:special_btn_pressed(...)
	return
end

function RaidGUIControl:set_menu_move_controls(controls)
	self._on_menu_move = controls
end

function RaidGUIControl:_menu_move_to(target_control_name, direction)
	local component_controls = managers.menu_component._active_controls

	for _, controls in pairs(component_controls) do
		for _, control in pairs(controls) do
			if control._name == target_control_name then
				if control:visible() and control:selectable() and control:enabled() then
					self:set_selected(false)

					if control._autoconfirm then
						if control._on_click_callback then
							control:_on_click_callback()
						end
					else
						control:set_selected(true)
					end

					return true
				else
					return self:_find_next_visible_control(control, direction)
				end
			end
		end
	end

	return nil, target_control_name
end

function RaidGUIControl:_find_next_visible_control(control_ref, direction)
	local next_control_name = control_ref and control_ref._on_menu_move and control_ref._on_menu_move[direction]

	if not next_control_name then
		return false
	end

	return self:_menu_move_to(next_control_name, direction)
end

function RaidGUIControl:confirm_pressed()
	return
end

function RaidGUIControl:check_item_availability(item, availability_flags)
	if not availability_flags then
		return true
	end

	self._callback_handler = self._callback_handler or RaidMenuCallbackHandler:new()

	local result = true

	for _, availability_flag in pairs(availability_flags) do
		local availability_callback = callback(self._callback_handler, self._callback_handler, availability_flag)

		if availability_callback then
			result = result and availability_callback()
		end
	end

	return result
end

function RaidGUIControl:scrollable_area_post_setup(params)
	return
end

function RaidGUIControl:enabled()
	return self._enabled
end

function RaidGUIControl:set_enabled(enabled)
	self._enabled = enabled
end
