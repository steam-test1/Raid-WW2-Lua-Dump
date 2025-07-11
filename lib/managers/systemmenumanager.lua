core:module("SystemMenuManager")
core:import("CoreEvent")
core:import("CoreClass")
require("lib/managers/dialogs/GenericDialog")
require("lib/managers/dialogs/PS4KeyboardInputDialog")
require("lib/managers/dialogs/XB1KeyboardInputDialog")
require("lib/managers/dialogs/XB1SelectUserDialog")
require("lib/managers/dialogs/XB1AchievementsDialog")
require("lib/managers/dialogs/XB1PlayerDialog")

SystemMenuManager = SystemMenuManager or class()
SystemMenuManager.PLATFORM_CLASS_MAP = {}

function SystemMenuManager:new(...)
	local platform = SystemInfo:platform()

	return (self.PLATFORM_CLASS_MAP[platform:key()] or GenericSystemMenuManager):new(...)
end

GenericSystemMenuManager = GenericSystemMenuManager or class()
GenericSystemMenuManager.DIALOG_CLASS = GenericDialog
GenericSystemMenuManager.GENERIC_DIALOG_CLASS = GenericDialog
GenericSystemMenuManager.PLATFORM_DIALOG_CLASS = GenericDialog

function GenericSystemMenuManager:init()
	if not Global.dialog_manager then
		Global.dialog_manager = {
			init_show_data_list = nil,
		}
	end

	self._dialog_shown_callback_handler = CoreEvent.CallbackEventHandler:new()
	self._dialog_hidden_callback_handler = CoreEvent.CallbackEventHandler:new()
	self._dialog_closed_callback_handler = CoreEvent.CallbackEventHandler:new()
	self._active_changed_callback_handler = CoreEvent.CallbackEventHandler:new()
	self._controller = managers.controller:create_controller("dialog", nil, false)

	self._controller:set_enabled(false)
	managers.controller:add_default_wrapper_index_change_callback(callback(self, self, "changed_controller_index"))

	self._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(self, self, "resolution_changed"))

	managers.controller:add_hotswap_callback("system_menu", callback(self, self, "controller_hotswap_triggered"), 2)
end

function GenericSystemMenuManager:init_finalize()
	local gui = Overlay:gui()

	self._ws = Overlay:gui():create_screen_workspace()

	managers.gui_data:layout_1280_workspace(self._ws)
	self._ws:hide()

	if Global.dialog_manager.init_show_data_list then
		local init_show_data_list = Global.dialog_manager.init_show_data_list

		Global.dialog_manager.init_show_data_list = nil

		for index, data in ipairs(init_show_data_list) do
			cat_print("dialog_manager", "[SystemMenuManager] Processing init dialog. Index: " .. tostring(index) .. "/" .. tostring(#init_show_data_list))
			self:show(data)
		end
	end
end

function GenericSystemMenuManager:controller_hotswap_triggered()
	if self._active_dialog then
		self._active_dialog:set_controller(self._controller)
		self._active_dialog:controller_hotswap_triggered()
	end
end

function GenericSystemMenuManager:resolution_changed()
	managers.gui_data:layout_1280_workspace(self._ws)
end

function GenericSystemMenuManager:add_init_show(data)
	local init_show_data_list = Global.dialog_manager.init_show_data_list
	local priority = data.priority or 0

	cat_print("dialog_manager", "[SystemMenuManager] Adding an init dialog with priority \"" .. tostring(priority) .. "\".")

	if init_show_data_list then
		for index = #init_show_data_list, 1, -1 do
			local next_data = init_show_data_list[index]
			local next_priority = next_data.priority or 0

			if priority < next_priority then
				cat_print("dialog_manager", "[SystemMenuManager] Ignoring request to show init dialog since it had lower priority than the existing priority \"" .. tostring(next_priority) .. "\". Index: " .. tostring(index) .. "/" .. tostring(#init_show_data_list))

				return false
			elseif next_priority < priority then
				cat_print("dialog_manager", "[SystemMenuManager] Removed an already added init dialog with the lower priority of \"" .. tostring(next_priority) .. "\". Index: " .. tostring(index) .. "/" .. tostring(#init_show_data_list))
				table.remove(init_show_data_list, index)
			end
		end
	else
		init_show_data_list = {}
	end

	table.insert(init_show_data_list, data)

	Global.dialog_manager.init_show_data_list = init_show_data_list
end

function GenericSystemMenuManager:destroy()
	managers.controller:remove_hotswap_callback("system_menu")

	if alive(self._ws) then
		Overlay:gui():destroy_workspace(self._ws)

		self._ws = nil
	end

	if self._controller then
		self._controller:destroy()

		self._controller = nil
	end
end

function GenericSystemMenuManager:changed_controller_index(default_wrapper_index)
	local was_enabled = self._controller:enabled()

	self._controller:destroy()

	self._controller = managers.controller:create_controller("dialog", nil, false)

	self._controller:set_enabled(was_enabled)
end

function GenericSystemMenuManager:update(t, dt)
	if self._active_dialog and self._active_dialog.update then
		self._active_dialog:update(t, dt)
	end

	self:update_queue()
	self:check_active_state()
end

function GenericSystemMenuManager:paused_update(t, dt)
	self:update(t, dt)
end

function GenericSystemMenuManager:update_queue()
	if not self:is_active(true) and self._dialog_queue then
		local dialog, index

		for next_index, next_dialog in ipairs(self._dialog_queue) do
			if not dialog or next_dialog:priority() > dialog:priority() then
				index = next_index
				dialog = next_dialog
			end
		end

		table.remove(self._dialog_queue, index)

		if not next(self._dialog_queue) then
			self._dialog_queue = nil
		end

		if dialog then
			self:_show_instance(dialog, true)
		end
	end
end

function GenericSystemMenuManager:check_active_state()
	local active = self:is_active(true)

	if not self._old_active_state ~= not active then
		self:event_active_changed(active)

		self._old_active_state = active
	end
end

function GenericSystemMenuManager:block_exec()
	return self:is_active()
end

function GenericSystemMenuManager:is_active()
	return self._active_dialog ~= nil
end

function GenericSystemMenuManager:is_closing()
	return self._active_dialog and self._active_dialog:is_closing() or false
end

function GenericSystemMenuManager:force_close_all()
	if self._active_dialog and self._active_dialog:blocks_exec() then
		self._active_dialog:fade_out_close()
	end

	if self._dialog_queue then
		for i, dialog in ipairs(self._dialog_queue) do
			if self._active_dialog and self._active_dialog ~= dialog then
				dialog:force_close()
			end
		end
	end

	self._dialog_queue = nil
end

function GenericSystemMenuManager:get_dialog(id)
	if not id then
		return
	end

	if self._active_dialog and self._active_dialog:id() == id then
		return self._active_dialog
	end
end

function GenericSystemMenuManager:close(id, hard)
	if not id then
		return
	end

	print("close active dialog", self._active_dialog and self._active_dialog:id(), id)

	if self._active_dialog and self._active_dialog:id() == id then
		if hard then
			self._active_dialog:close()
		else
			self._active_dialog:fade_out_close()
		end
	end

	if not self._dialog_queue then
		return
	end

	local remove_list

	for i, dialog in ipairs(self._dialog_queue) do
		if dialog:id() == id then
			print("remove from queue", id)

			remove_list = remove_list or {}

			table.insert(remove_list, 1, i)
		end
	end

	if remove_list then
		for _, i in ipairs(remove_list) do
			table.remove(self._dialog_queue, i)
		end
	end
end

function GenericSystemMenuManager:is_active_by_id(id)
	if not self._active_dialog or not id then
		return false
	end

	if self._active_dialog:id() == id then
		return true, self._active_dialog
	end

	if not self._dialog_queue then
		return false
	end

	for i, dialog in ipairs(self._dialog_queue) do
		if dialog:id() == id then
			return true, dialog
		end
	end

	return false
end

function GenericSystemMenuManager:_show_result(success, data)
	if not success and data then
		local default_button_index = data.focus_button or 1
		local button_list = data.button_list

		if data.button_list then
			local button_data = data.button_list[default_button_index]

			if button_data then
				local callback_func = button_data.callback_func

				if callback_func then
					callback_func(default_button_index, button_data)
				end
			end
		end

		if data.callback_func then
			data.callback_func(default_button_index, data)
		end
	end
end

function GenericSystemMenuManager:show(data)
	if _G.setup and _G.setup:has_queued_exec() then
		return
	end

	local success = self:_show_class(data, self.GENERIC_DIALOG_CLASS, self.DIALOG_CLASS, data.force)

	self:_show_result(success, data)

	if managers.hud then
		managers.hud:hide_comm_wheel(true)
		managers.hud:hide_stats_screen()
	end
end

function GenericSystemMenuManager:show_platform(data)
	local success = self:_show_class(data, self.GENERIC_DIALOG_CLASS, self.PLATFORM_DIALOG_CLASS, data.force)

	self:_show_result(success, data)
end

function GenericSystemMenuManager:show_select_storage(data)
	self:_show_class(data, self.GENERIC_SELECT_STORAGE_DIALOG_CLASS, self.SELECT_STORAGE_DIALOG_CLASS, false)
end

function GenericSystemMenuManager:show_keyboard_input(data)
	self:_show_class(data, self.GENERIC_KEYBOARD_INPUT_DIALOG, self.KEYBOARD_INPUT_DIALOG, true)
end

function GenericSystemMenuManager:show_select_user(data)
	self:_show_class(data, self.GENERIC_SELECT_USER_DIALOG, self.SELECT_USER_DIALOG, false)
end

function GenericSystemMenuManager:_show_class(data, generic_dialog_class, dialog_class, force)
	local dialog_class = data and data.is_generic and generic_dialog_class or dialog_class

	if dialog_class then
		local dialog = dialog_class:new(self, data)

		self:_show_instance(dialog, force)

		return true
	else
		if data then
			local callback_func = data.callback_func

			if callback_func then
				callback_func()
			end
		end

		return false
	end
end

function GenericSystemMenuManager:_show_instance(dialog, force)
	local is_active = self:is_active(true)

	if is_active and force then
		self:hide_active_dialog()
	end

	local queue = true

	if not is_active then
		queue = not dialog:show()
	end

	if queue then
		self:queue_dialog(dialog, force and 1 or nil)
	end
end

function GenericSystemMenuManager:hide_active_dialog()
	if self._active_dialog and not self._active_dialog:is_closing() and self._active_dialog.hide then
		self:queue_dialog(self._active_dialog, 1)
		self._active_dialog:hide()
	end
end

function GenericSystemMenuManager:get_active_dialog()
	return self._active_dialog
end

function GenericSystemMenuManager:_is_dialog_queued_or_active(dialog)
	if self._active_dialog and self._active_dialog.is_identical and self._active_dialog:is_identical(dialog) then
		return true
	end

	for _, d in ipairs(self._dialog_queue) do
		if d:is_identical(dialog) then
			return true
		end
	end
end

function GenericSystemMenuManager:queue_dialog(dialog, index, hiding)
	if Global.category_print.dialog_manager then
		cat_print("dialog_manager", "[SystemMenuManager] [Queue dialog (index: " .. tostring(index) .. "/" .. tostring(self._dialog_queue and #self._dialog_queue) .. ")] " .. tostring(dialog:to_string()))
	end

	self._dialog_queue = self._dialog_queue or {}

	if hiding then
		if index then
			table.insert(self._dialog_queue, index, dialog)
		else
			table.insert(self._dialog_queue, dialog)
		end

		return
	end

	if not self:_is_dialog_queued_or_active(dialog) then
		if index then
			table.insert(self._dialog_queue, index, dialog)
		else
			table.insert(self._dialog_queue, dialog)
		end
	end
end

function GenericSystemMenuManager:set_active_dialog(dialog)
	self._active_dialog = dialog

	local is_ws_visible = dialog and dialog._get_ws and dialog:_get_ws() == self._ws

	if not self._is_ws_visible ~= not is_ws_visible then
		if is_ws_visible then
			self._ws:show()
		else
			self._ws:hide()
		end

		self._is_ws_visible = is_ws_visible
	end

	local is_controller_enabled = dialog and dialog:_get_controller() == self._controller

	if not self._controller:enabled() ~= not is_controller_enabled then
		self._controller:set_enabled(is_controller_enabled)
	end
end

function GenericSystemMenuManager:_is_engine_delaying_signin_change()
	if self._is_engine_delaying_signin_change_delay then
		self._is_engine_delaying_signin_change_delay = self._is_engine_delaying_signin_change_delay - TimerManager:main():delta_time()

		if self._is_engine_delaying_signin_change_delay <= 0 then
			self._is_engine_delaying_signin_change_delay = nil

			return false
		end
	else
		self._is_engine_delaying_signin_change_delay = 1.2
	end

	return true
end

function GenericSystemMenuManager:_get_ws()
	return self._ws
end

function GenericSystemMenuManager:_get_controller()
	return self._controller
end

function GenericSystemMenuManager:add_dialog_shown_callback(func)
	self._dialog_shown_callback_handler:add(func)
end

function GenericSystemMenuManager:remove_dialog_shown_callback(func)
	self._dialog_shown_callback_handler:remove(func)
end

function GenericSystemMenuManager:add_dialog_hidden_callback(func)
	self._dialog_hidden_callback_handler:add(func)
end

function GenericSystemMenuManager:remove_dialog_hidden_callback(func)
	self._dialog_hidden_callback_handler:remove(func)
end

function GenericSystemMenuManager:add_dialog_closed_callback(func)
	self._dialog_closed_callback_handler:add(func)
end

function GenericSystemMenuManager:remove_dialog_closed_callback(func)
	self._dialog_closed_callback_handler:remove(func)
end

function GenericSystemMenuManager:add_active_changed_callback(func)
	self._active_changed_callback_handler:add(func)
end

function GenericSystemMenuManager:remove_active_changed_callback(func)
	self._active_changed_callback_handler:remove(func)
end

function GenericSystemMenuManager:event_dialog_shown(dialog)
	if Global.category_print.dialog_manager then
		cat_print("dialog_manager", "[SystemMenuManager] [Show dialog] " .. tostring(dialog:to_string()))
	end

	if dialog.fade_in then
		dialog:fade_in()
	end

	self:set_active_dialog(dialog)
	self._dialog_shown_callback_handler:dispatch(dialog)
end

function GenericSystemMenuManager:event_dialog_hidden(dialog)
	if Global.category_print.dialog_manager then
		cat_print("dialog_manager", "[SystemMenuManager] [Hide dialog] " .. tostring(dialog:to_string()))
	end

	self:set_active_dialog(nil)
	self._dialog_hidden_callback_handler:dispatch(dialog)
end

function GenericSystemMenuManager:event_dialog_closed(dialog)
	if Global.category_print.dialog_manager then
		cat_print("dialog_manager", "[SystemMenuManager] [Close dialog] " .. tostring(dialog:to_string()))
	end

	self:set_active_dialog(nil)
	self._dialog_closed_callback_handler:dispatch(dialog)
end

function GenericSystemMenuManager:event_active_changed(active)
	if Global.category_print.dialog_manager then
		cat_print("dialog_manager", "[SystemMenuManager] [Active changed] Active: " .. tostring(not not active))
	end
end

WinSystemMenuManager = WinSystemMenuManager or class(GenericSystemMenuManager)
SystemMenuManager.PLATFORM_CLASS_MAP[Idstring("win32"):key()] = WinSystemMenuManager
XB1SystemMenuManager = XB1SystemMenuManager or class(GenericSystemMenuManager)
XB1SystemMenuManager.KEYBOARD_INPUT_DIALOG = XB1KeyboardInputDialog
XB1SystemMenuManager.GENERIC_KEYBOARD_INPUT_DIALOG = XB1KeyboardInputDialog
XB1SystemMenuManager.GENERIC_SELECT_USER_DIALOG = XB1SelectUserDialog
XB1SystemMenuManager.SELECT_USER_DIALOG = XB1SelectUserDialog
XB1SystemMenuManager.GENERIC_ACHIEVEMENTS_DIALOG = XB1AchievementsDialog
XB1SystemMenuManager.ACHIEVEMENTS_DIALOG = XB1AchievementsDialog
XB1SystemMenuManager.GENERIC_PLAYER_DIALOG = XB1PlayerDialog
XB1SystemMenuManager.PLAYER_DIALOG = XB1PlayerDialog
SystemMenuManager.PLATFORM_CLASS_MAP[Idstring("XB1"):key()] = XB1SystemMenuManager

function XB1SystemMenuManager:is_active(skip_block_exec)
	local dialog_block = self._active_dialog and (skip_block_exec or self._active_dialog:blocks_exec())

	return dialog_block and (GenericSystemMenuManager.is_active(self) or Application:is_showing_system_dialog())
end

PS4SystemMenuManager = PS4SystemMenuManager or class(GenericSystemMenuManager)
PS4SystemMenuManager.KEYBOARD_INPUT_DIALOG = PS4KeyboardInputDialog
PS4SystemMenuManager.GENERIC_KEYBOARD_INPUT_DIALOG = PS4KeyboardInputDialog
SystemMenuManager.PLATFORM_CLASS_MAP[Idstring("PS4"):key()] = PS4SystemMenuManager

function PS4SystemMenuManager:init()
	GenericSystemMenuManager.init(self)

	self._is_ps_button_menu_visible = false

	PS4:set_ps_button_callback(callback(self, self, "ps_button_menu_callback"))
end

function PS4SystemMenuManager:ps_button_menu_callback(is_ps_button_menu_visible)
	self._is_ps_button_menu_visible = is_ps_button_menu_visible
end

function PS4SystemMenuManager:block_exec()
	return GenericSystemMenuManager.is_active(self) or PS4:is_displaying_box()
end

function PS4SystemMenuManager:is_active()
	return GenericSystemMenuManager.is_active(self) or PS4:is_displaying_box() or self._is_ps_button_menu_visible
end
