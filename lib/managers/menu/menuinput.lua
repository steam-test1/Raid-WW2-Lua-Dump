core:import("CoreMenuInput")

MenuInput = MenuInput or class(CoreMenuInput.MenuInput)
MenuInput.AXIS_TIMER_A = 0.12
MenuInput.AXIS_TIMER_B = 0.3
MenuInput.special_buttons = {
	"menu_controller_face_right",
	"menu_controller_face_left",
	"menu_controller_face_bottom",
	"menu_controller_face_top",
	"menu_controller_shoulder_left",
	"menu_controller_shoulder_right",
	"menu_controller_trigger_left",
	"menu_controller_trigger_right",
	"menu_controller_dpad_up",
	"menu_controller_dpad_down",
	"menu_controller_dpad_left",
	"menu_controller_dpad_right",
}

function MenuInput:init(logic, ...)
	MenuInput.super.init(self, logic, ...)

	self._move_axis_limit = 0.5
	self._controller_mouse_active_counter = 0
	self._item_input_action_map[ItemColumn.TYPE] = callback(self, self, "input_item")
	self._item_input_action_map[MenuItemDivider.TYPE] = callback(self, self, "input_item")
	self._item_input_action_map[MenuItemInput.TYPE] = callback(self, self, "input_item")
	self._callback_map = {}
	self._callback_map.mouse_moved = {}
	self._callback_map.mouse_pressed = {}
	self._callback_map.mouse_released = {}
	self._callback_map.mouse_clicked = {}
	self._callback_map.mouse_double_click = {}
end

function MenuInput:back(...)
	self._slider_marker = nil

	local active_menu = managers.menu:active_menu()

	if active_menu then
		local menu_renderer = active_menu.renderer
		local node_gui = menu_renderer:active_node_gui()

		if node_gui and node_gui._listening_to_input then
			return
		end

		if managers.system_menu and managers.system_menu:is_active() and not managers.system_menu:is_closing() then
			return
		end
	end

	MenuInput.super.back(self, ...)
end

function MenuInput:activate_mouse(position, controller_activated)
	if not controller_activated and managers.controller:get_default_wrapper_type() ~= "pc" and managers.controller:get_default_wrapper_type() ~= "steam" then
		return
	end

	self._mouse_active = true

	local data = {}

	data.mouse_move = callback(self, self, "mouse_moved")
	data.mouse_press = callback(self, self, "mouse_pressed")
	data.mouse_release = callback(self, self, "mouse_released")
	data.mouse_click = callback(self, self, "mouse_clicked")
	data.mouse_double_click = callback(self, self, "mouse_double_click")
	data.id = self._menu_name

	managers.mouse_pointer:use_mouse(data, position)
end

function MenuInput:activate_controller_mouse(position)
	self._controller_mouse_active_counter = self._controller_mouse_active_counter + 1

	Application:debug("MenuInput:activate_controller_mouse()", self._controller_mouse_active_counter)

	if self._controller_mouse_active_counter == 1 and managers.mouse_pointer:change_mouse_to_controller(self._controller:get_controller()) then
		self:activate_mouse(position, true)
	end
end

function MenuInput:deactivate_controller_mouse()
	self._controller_mouse_active_counter = self._controller_mouse_active_counter - 1

	Application:debug("MenuInput:deactivate_controller_mouse()", self._controller_mouse_active_counter)

	if self._controller_mouse_active_counter < 0 then
		-- block empty
	end

	if self._controller_mouse_active_counter == 0 and managers.mouse_pointer:change_controller_to_mouse() then
		self:deactivate_mouse()
	end
end

function MenuInput:get_controller_class()
	return self._controller
end

function MenuInput:get_controller()
	return self._controller:get_controller()
end

function MenuInput:deactivate_mouse()
	if not self._mouse_active then
		return
	end

	self._mouse_active = false

	managers.mouse_pointer:remove_mouse(self._menu_name)
end

function MenuInput:open(position, ...)
	MenuInput.super.open(self, ...)

	self._page_timer = 0
	self.AXIS_STATUS_UP = 0
	self.AXIS_STATUS_PRESSED = 1
	self.AXIS_STATUS_DOWN = 2
	self.AXIS_STATUS_RELEASED = 3
	self._axis_status = {
		x = self.AXIS_STATUS_UP,
		y = self.AXIS_STATUS_UP,
	}

	self:activate_mouse(position)
	managers.controller:set_menu_mode_enabled(true)
end

function MenuInput:close(...)
	MenuInput.super.close(self, ...)
	self:deactivate_mouse()
	managers.controller:set_menu_mode_enabled(false)
end

function MenuInput:set_page_timer(time)
	self._page_timer = time
end

function MenuInput:force_input()
	return self._force_input
end

function MenuInput:set_force_input(enabled)
	self._force_input = enabled
end

function MenuInput:accept_input(accept, ...)
	if managers.menu:active_menu() then
		managers.menu:active_menu().renderer:accept_input(accept)
	end

	MenuInput.super.accept_input(self, accept, ...)
end

function MenuInput:_modified_mouse_pos(x, y)
	return managers.mouse_pointer:convert_mouse_pos(x, y)
end

function MenuInput:mouse_moved(o, x, y, mouse_ws)
	if not managers.menu:active_menu() then
		return
	end

	self._keyboard_used = false
	self._mouse_moved = true
	x, y = self:_modified_mouse_pos(x, y)

	if self._slider_marker then
		local row_item = self._slider_marker.row_item

		if alive(row_item.gui_slider) then
			local where = (x - row_item.gui_slider:world_left()) / (row_item.gui_slider:world_right() - row_item.gui_slider:world_left())
			local item = self._slider_marker.item

			item:set_value_by_percentage(where * 100)
			self._logic:trigger_item(true, item)
			managers.mouse_pointer:set_pointer_image("grab")
		end

		return
	end

	local node_gui = managers.menu:active_menu().renderer:active_node_gui()
	local select_item, select_row_item

	if node_gui and managers.menu_component:input_focus() ~= true then
		local inside_item_panel_parent = node_gui:item_panel_parent():inside(x, y)

		if inside_item_panel_parent then
			for _, row_item in pairs(node_gui.row_items) do
				if row_item.gui_panel:inside(x, y) then
					local item = self._logic:get_item(row_item.name)

					if item and item.TYPE ~= "divider" then
						select_item = row_item.name
						select_row_item = row_item
					elseif not item then
						Application:error("[MenuInput:mouse_moved] Item not found in Menu Logic", row_item.name)
					end
				end
			end
		end
	end

	if select_item then
		local selected_item = managers.menu:active_menu().logic:selected_item()

		if not selected_item or select_item ~= selected_item:name() then
			managers.menu:active_menu().logic:mouse_over_select_item(select_item, false)
		elseif selected_item.TYPE == "slider" then
			managers.mouse_pointer:set_pointer_image("hand")
		elseif selected_item.TYPE == "multi_choice" then
			if select_row_item.arrow_right:visible() and select_row_item.arrow_right:inside(x, y) or select_row_item.arrow_left:visible() and select_row_item.arrow_left:inside(x, y) or select_row_item.arrow_right:visible() and select_row_item.arrow_left:visible() and select_row_item.gui_text:inside(x, y) then
				managers.mouse_pointer:set_pointer_image("link")
			else
				managers.mouse_pointer:set_pointer_image("arrow")
			end
		else
			managers.mouse_pointer:set_pointer_image("link")
		end

		return
	end

	local used, pointer = managers.menu:active_menu().renderer:mouse_moved(o, x, y)

	if used then
		managers.mouse_pointer:set_pointer_image(pointer)

		return
	end

	for i, clbk in pairs(self._callback_map.mouse_moved) do
		clbk(o, x, y, mouse_ws)
	end

	managers.mouse_pointer:set_pointer_image("arrow")
end

function MenuInput:input_expand(item, controller, mouse_click)
	if controller:get_input_pressed("confirm") or mouse_click then
		item:toggle()
		self._logic:trigger_item(true, item)
	end
end

function MenuInput:input_chat(item, controller, mouse_click)
	if not controller:get_input_pressed("confirm") and mouse_click then
		-- block empty
	end
end

function MenuInput:get_accept_input()
	return self._accept_input and true or false
end

function MenuInput:register_callback(input, name, callback)
	if not self._callback_map[input] then
		Application:error("MenuInput:register_callback", "Failed to register callback", "input: " .. input, "name: " .. name)

		return
	end

	self._callback_map[input][name] = callback
end

function MenuInput:unregister_callback(input, name)
	if not self._callback_map[input] then
		Application:error("MenuInput:register_callback", "Failed to unregister callback", "input: " .. input, "name: " .. name)

		return
	end

	self._callback_map[input][name] = nil
end

function MenuInput:can_toggle_chat()
	local item = self._logic:selected_item()

	if item and item.TYPE == "input" then
		return not item:focus()
	end

	return true
end

function MenuInput:mouse_pressed(o, button, x, y)
	if not self._accept_input then
		return
	end

	if managers.blackmarket and managers.blackmarket:is_preloading_weapons() then
		return
	end

	if not managers.menu:active_menu() then
		return
	end

	self._keyboard_used = false
	x, y = self:_modified_mouse_pos(x, y)

	if managers.menu:active_menu().renderer:mouse_pressed(o, button, x, y) then
		return
	end

	for i, clbk in pairs(self._callback_map.mouse_pressed) do
		clbk(o, button, x, y)
	end
end

function MenuInput:mouse_released(o, button, x, y)
	if not managers.menu:active_menu() then
		return
	end

	x, y = self:_modified_mouse_pos(x, y)

	if button == Idstring("0") and managers.menu_component:input_focus() ~= true then
		local node_gui = managers.menu:active_menu().renderer:active_node_gui()

		if not node_gui or node_gui._listening_to_input then
			return
		end

		if node_gui then
			for _, row_item in pairs(node_gui.row_items) do
				if row_item.item:parameters().pd2_corner then
					if row_item.gui_text:inside(x, y) then
						local item = self._logic:selected_item()

						if item then
							self._item_input_action_map[item.TYPE](item, self._controller, true)

							return node_gui.mouse_pressed and node_gui:mouse_pressed(button, x, y)
						end
					end
				elseif not row_item.gui_panel:inside(x, y) or not node_gui._item_panel_parent:inside(x, y) or row_item.type == "divider" then
					-- block empty
				elseif row_item.type == "slider" then
					if row_item.gui_slider_marker:inside(x, y) then
						self._slider_marker = {
							button = button,
							item = row_item.item,
							row_item = row_item,
						}
					elseif row_item.gui_slider:inside(x, y) then
						local where = (x - row_item.gui_slider:world_left()) / (row_item.gui_slider:world_right() - row_item.gui_slider:world_left())
						local item = row_item.item

						item:set_value_by_percentage(where * 100)
						self._logic:trigger_item(true, item)

						self._slider_marker = {
							button = button,
							item = row_item.item,
							row_item = row_item,
						}
					end
				elseif row_item.type == "multi_choice" then
					local item = row_item.item

					if row_item.arrow_right:inside(x, y) then
						if item:next() then
							self._logic:trigger_item(true, item)
						end
					elseif row_item.arrow_left:inside(x, y) then
						if item:previous() then
							self._logic:trigger_item(true, item)
						end
					elseif row_item.gui_text:inside(x, y) then
						if row_item.align == "left" then
							if item:previous() then
								self._logic:trigger_item(true, item)
							end
						elseif item:next() then
							self._logic:trigger_item(true, item)
						end
					end
				else
					local item = self._logic:selected_item()

					if item then
						self._item_input_action_map[item.TYPE](item, self._controller, true)

						return node_gui.mouse_pressed and node_gui:mouse_pressed(button, x, y)
					end
				end
			end
		end
	end

	if managers.menu:active_menu().renderer:mouse_released(o, button, x, y) then
		return
	end

	for i, clbk in pairs(self._callback_map.mouse_released) do
		clbk(o, button, x, y)
	end
end

function MenuInput:mouse_clicked(o, button, x, y)
	x, y = self:_modified_mouse_pos(x, y)

	for i, clbk in pairs(self._callback_map.mouse_clicked) do
		clbk(o, button, x, y)
	end

	if not managers.menu:active_menu() or not managers.menu:active_menu().renderer.mouse_clicked then
		return
	end

	return managers.menu:active_menu().renderer:mouse_clicked(o, button, x, y)
end

function MenuInput:mouse_double_click(o, button, x, y)
	x, y = self:_modified_mouse_pos(x, y)

	for i, clbk in pairs(self._callback_map.mouse_double_click) do
		clbk(o, button, x, y)
	end

	if not managers.menu:active_menu() or not managers.menu:active_menu().renderer.mouse_double_click then
		return
	end

	return managers.menu:active_menu().renderer:mouse_double_click(o, button, x, y)
end

local ids_chat = Idstring("toggle_chat")

function MenuInput:update(t, dt)
	if self._menu_plane then
		self._menu_plane:set_rotation(Rotation(math.sin(t * 60) * 40, math.sin(t * 50) * 30, 0))
	end

	self:_update_axis_status()

	if managers.blackmarket and managers.blackmarket:is_preloading_weapons() then
		return
	end

	if managers.system_menu and managers.system_menu:is_active() and not managers.system_menu:is_closing() then
		return
	end

	if self._page_timer > 0 then
		self:set_page_timer(self._page_timer - dt)
	end

	if not MenuInput.super.update(self, t, dt) and self._accept_input or self:force_input() then
		local axis_timer = self:axis_timer()

		if axis_timer.y <= 0 then
			if self:menu_up_input_bool() then
				managers.menu:active_menu().renderer:move_up()
				self:set_axis_y_timer(MenuInput.AXIS_TIMER_A)

				if self:menu_up_pressed() then
					self:set_axis_y_timer(MenuInput.AXIS_TIMER_B)
				end
			elseif self:menu_down_input_bool() then
				managers.menu:active_menu().renderer:move_down()
				self:set_axis_y_timer(MenuInput.AXIS_TIMER_A)

				if self:menu_down_pressed() then
					self:set_axis_y_timer(MenuInput.AXIS_TIMER_B)
				end
			end
		end

		if axis_timer.x <= 0 then
			if self:menu_left_input_bool() then
				managers.menu:active_menu().renderer:move_left()
				self:set_axis_x_timer(MenuInput.AXIS_TIMER_A)

				if self:menu_left_pressed() then
					self:set_axis_x_timer(MenuInput.AXIS_TIMER_B)
				end
			elseif self:menu_right_input_bool() then
				managers.menu:active_menu().renderer:move_right()
				self:set_axis_x_timer(MenuInput.AXIS_TIMER_A)

				if self:menu_right_pressed() then
					self:set_axis_x_timer(MenuInput.AXIS_TIMER_B)
				end
			end
		end

		local scroll_timer = self:scroll_timer()

		if scroll_timer.y <= 0 then
			if self:menu_scroll_up_input_bool() then
				managers.menu:active_menu().renderer:scroll_up()
				self:set_scroll_y_timer(MenuInput.AXIS_TIMER_A)

				if self:menu_scroll_up_pressed() then
					self:set_scroll_y_timer(MenuInput.AXIS_TIMER_B)
				end
			elseif self:menu_scroll_down_input_bool() then
				managers.menu:active_menu().renderer:scroll_down()
				self:set_scroll_y_timer(MenuInput.AXIS_TIMER_A)

				if self:menu_scroll_down_pressed() then
					self:set_scroll_y_timer(MenuInput.AXIS_TIMER_B)
				end
			end
		end

		if scroll_timer.x <= 0 then
			if self:menu_scroll_left_input_bool() then
				managers.menu:active_menu().renderer:scroll_left()
				self:set_scroll_x_timer(MenuInput.AXIS_TIMER_B)

				if self:menu_scroll_left_pressed() then
					self:set_scroll_x_timer(MenuInput.AXIS_TIMER_B)
				end
			elseif self:menu_scroll_right_input_bool() then
				managers.menu:active_menu().renderer:scroll_right()
				self:set_scroll_x_timer(MenuInput.AXIS_TIMER_B)

				if self:menu_scroll_right_pressed() then
					self:set_scroll_x_timer(MenuInput.AXIS_TIMER_B)
				end
			end
		end

		if self._page_timer <= 0 then
			if self:menu_previous_page_input_bool() then
				managers.menu:active_menu().renderer:previous_page()
				self:set_page_timer(MenuInput.AXIS_TIMER_A)

				if self:menu_previous_page_pressed() then
					self:set_page_timer(MenuInput.AXIS_TIMER_B)
				end
			elseif self:menu_next_page_input_bool() then
				managers.menu:active_menu().renderer:next_page()
				self:set_page_timer(MenuInput.AXIS_TIMER_A)

				if self:menu_next_page_pressed() then
					self:set_page_timer(MenuInput.AXIS_TIMER_B)
				end
			end

			local renderer = managers.menu:active_menu().renderer

			if managers.menu:active_menu() and renderer then
				for _, button in ipairs(MenuInput.special_buttons) do
					if self._controller and self._accept_input and self._controller:get_input_pressed(button) and managers.menu_component:special_btn_pressed(Idstring(button)) then
						renderer:disable_input(0.2)

						break
					end
				end

				if self._controller and self._accept_input and self._controller:get_input_pressed("confirm") and renderer:confirm_pressed() then
					renderer:disable_input(0.2)
				end

				if self._controller and self._accept_input and self._controller:get_input_pressed("back") and renderer:back_pressed() then
					renderer:disable_input(0.2)
				end

				if self._controller and self._accept_input and self._controller:get_input_pressed("cancel") and renderer:back_pressed() then
					renderer:disable_input(0.2)
				end
			end

			if self._controller and self._accept_input and self._controller:get_input_pressed("toggle_chat") and renderer:special_btn_pressed(ids_chat) then
				renderer:disable_input(0.2)
			end
		end
	end

	if not self._keyboard_used and self._mouse_active and self._accept_input and not self._mouse_moved then
		self:mouse_moved(managers.mouse_pointer:mouse(), managers.mouse_pointer:world_position())
	end

	self._mouse_moved = nil
end

function MenuInput:menu_axis_move()
	if self._controller then
		local move = self._controller:get_input_axis("menu_move")

		if move then
			return move
		end
	end

	local axis_moved = {
		x = 0,
		y = 0,
	}

	return axis_moved
end

function MenuInput:menu_axis_scroll()
	if self._controller then
		local scroll = self._controller:get_input_axis("menu_scroll")

		if scroll then
			return scroll
		end
	end

	local axis_scrolled = {
		x = 0,
		y = 0,
	}

	return axis_scrolled
end

function MenuInput:menu_up_input_bool()
	local result_1 = MenuInput.super.menu_up_input_bool(self)
	local result_2 = self:menu_axis_move().y > self._move_axis_limit

	return result_1 or result_2
end

function MenuInput:menu_up_pressed()
	return MenuInput.super.menu_up_pressed(self) or self._axis_status.y == self.AXIS_STATUS_PRESSED and self:menu_axis_move().y > 0
end

function MenuInput:menu_up_released()
	return MenuInput.super.menu_up_released(self) or self._axis_status.y == self.AXIS_STATUS_RELEASED
end

function MenuInput:menu_down_input_bool()
	return MenuInput.super.menu_down_input_bool(self) or self:menu_axis_move().y < -self._move_axis_limit
end

function MenuInput:menu_down_pressed()
	return MenuInput.super.menu_down_pressed(self) or self._axis_status.y == self.AXIS_STATUS_PRESSED and self:menu_axis_move().y < 0
end

function MenuInput:menu_down_released()
	return MenuInput.super.menu_down_released(self) or self._axis_status.y == self.AXIS_STATUS_RELEASED
end

function MenuInput:menu_left_input_bool()
	local result_1 = MenuInput.super.menu_left_input_bool(self)
	local result_2 = self:menu_axis_move().x < -self._move_axis_limit

	return result_1 or result_2
end

function MenuInput:menu_left_pressed()
	return MenuInput.super.menu_left_pressed(self) or self._axis_status.x == self.AXIS_STATUS_PRESSED and self:menu_axis_move().x < 0
end

function MenuInput:menu_left_released()
	return MenuInput.super.menu_left_released(self) or self._axis_status.x == self.AXIS_STATUS_RELEASED
end

function MenuInput:menu_right_input_bool()
	return MenuInput.super.menu_right_input_bool(self) or self:menu_axis_move().x > self._move_axis_limit
end

function MenuInput:menu_right_pressed()
	return MenuInput.super.menu_right_pressed(self) or self._axis_status.x == self.AXIS_STATUS_PRESSED and self:menu_axis_move().x > 0
end

function MenuInput:menu_right_released()
	return MenuInput.super.menu_right_released(self) or self._axis_status.x == self.AXIS_STATUS_RELEASED
end

function MenuInput:menu_scroll_up_input_bool()
	return self:menu_axis_scroll().y > self._move_axis_limit
end

function MenuInput:menu_scroll_up_pressed()
	return self._axis_status.y == self.AXIS_STATUS_PRESSED and self:menu_axis_scroll().y > 0
end

function MenuInput:menu_scroll_up_released()
	return self._axis_status.y == self.AXIS_STATUS_RELEASED
end

function MenuInput:menu_scroll_down_input_bool()
	return self:menu_axis_scroll().y < -self._move_axis_limit
end

function MenuInput:menu_scroll_down_pressed()
	return self._axis_status.y == self.AXIS_STATUS_PRESSED and self:menu_axis_scroll().y < 0
end

function MenuInput:menu_scroll_down_released()
	return self._axis_status.y == self.AXIS_STATUS_RELEASED
end

function MenuInput:menu_scroll_left_input_bool()
	return self:menu_axis_scroll().x < -self._move_axis_limit
end

function MenuInput:menu_scroll_left_pressed()
	return self._axis_status.x == self.AXIS_STATUS_PRESSED and self:menu_axis_scroll().x < 0
end

function MenuInput:menu_scroll_left_released()
	return self._axis_status.x == self.AXIS_STATUS_RELEASED
end

function MenuInput:menu_scroll_right_input_bool()
	return self:menu_axis_scroll().x > self._move_axis_limit
end

function MenuInput:menu_scroll_right_pressed()
	return self._axis_status.x == self.AXIS_STATUS_PRESSED and self:menu_axis_scroll().x > 0
end

function MenuInput:menu_scroll_right_released()
	return self._axis_status.x == self.AXIS_STATUS_RELEASED
end

function MenuInput:menu_next_page_input_bool()
	if self._controller then
		return self._controller:get_input_bool("next_page")
	end

	return false
end

function MenuInput:menu_next_page_pressed()
	if self._controller then
		return self._controller:get_input_pressed("next_page")
	end

	return false
end

function MenuInput:menu_next_page_released()
	if self._controller then
		return self._controller:get_input_released("next_page")
	end

	return false
end

function MenuInput:menu_previous_page_input_bool()
	if self._controller then
		return self._controller:get_input_bool("previous_page")
	end

	return false
end

function MenuInput:menu_previous_page_pressed()
	if self._controller then
		return self._controller:get_input_pressed("previous_page")
	end

	return false
end

function MenuInput:menu_previous_page_released()
	if self._controller then
		return self._controller:get_input_released("previous_page")
	end

	return false
end

function MenuInput:_update_axis_status()
	local axis_moved = self:menu_axis_move()

	if self._axis_status.x == self.AXIS_STATUS_UP and math.abs(axis_moved.x) - self._move_axis_limit > 0 then
		self._axis_status.x = self.AXIS_STATUS_PRESSED
	elseif math.abs(axis_moved.x) - self._move_axis_limit > 0 then
		self._axis_status.x = self.AXIS_STATUS_DOWN
	elseif self._axis_status.x == self.AXIS_STATUS_PRESSED or self._axis_status.x == self.AXIS_STATUS_DOWN then
		self._axis_status.x = self.AXIS_STATUS_RELEASED
	else
		self._axis_status.x = self.AXIS_STATUS_UP
	end

	if self._axis_status.y == self.AXIS_STATUS_UP and math.abs(axis_moved.y) - self._move_axis_limit > 0 then
		self._axis_status.y = self.AXIS_STATUS_PRESSED
	elseif math.abs(axis_moved.y) - self._move_axis_limit > 0 then
		self._axis_status.y = self.AXIS_STATUS_DOWN
	elseif self._axis_status.y == self.AXIS_STATUS_PRESSED or self._axis_status.y == self.AXIS_STATUS_DOWN then
		self._axis_status.y = self.AXIS_STATUS_RELEASED
	else
		self._axis_status.y = self.AXIS_STATUS_UP
	end
end

function MenuInput:_update_axis_scroll_status()
	local axis_scrolled = self:menu_axis_scroll()

	if self._axis_status.x == self.AXIS_STATUS_UP and math.abs(axis_scrolled.x) - self._move_axis_limit > 0 then
		self._axis_status.x = self.AXIS_STATUS_PRESSED
	elseif math.abs(axis_scrolled.x) - self._move_axis_limit > 0 then
		self._axis_status.x = self.AXIS_STATUS_DOWN
	elseif self._axis_status.x == self.AXIS_STATUS_PRESSED or self._axis_status.x == self.AXIS_STATUS_DOWN then
		self._axis_status.x = self.AXIS_STATUS_RELEASED
	else
		self._axis_status.x = self.AXIS_STATUS_UP
	end

	if self._axis_status.y == self.AXIS_STATUS_UP and math.abs(axis_scrolled.y) - self._move_axis_limit > 0 then
		self._axis_status.y = self.AXIS_STATUS_PRESSED
	elseif math.abs(axis_scrolled.y) - self._move_axis_limit > 0 then
		self._axis_status.y = self.AXIS_STATUS_DOWN
	elseif self._axis_status.y == self.AXIS_STATUS_PRESSED or self._axis_status.y == self.AXIS_STATUS_DOWN then
		self._axis_status.y = self.AXIS_STATUS_RELEASED
	else
		self._axis_status.y = self.AXIS_STATUS_UP
	end
end
