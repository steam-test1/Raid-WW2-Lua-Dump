SelectGroupByName = SelectGroupByName or class(CoreEditorEwsDialog)

local tmp_vec3 = Vector3()

function SelectGroupByName:init(...)
	local styles = managers.editor:format_dialog_styles("DEFAULT_DIALOG_STYLE,RESIZE_BORDER")

	CoreEditorEwsDialog.init(self, nil, "Select group by name", "", Vector3(300, 150, 0), Vector3(500, 300, 0), styles, ...)
	self._dialog:set_min_size(Vector3(500, 240, 0))
	self:create_panel("VERTICAL")

	local horizontal_ctrlr_sizer = EWS:BoxSizer("HORIZONTAL")
	local list_sizer = EWS:BoxSizer("VERTICAL")

	list_sizer:add(EWS:StaticText(self._panel, "Filter", 0, ""), 0, 0, "ALIGN_CENTER_HORIZONTAL")

	self._filter = EWS:TextCtrl(self._panel, "", "", "TE_CENTRE")

	list_sizer:add(self._filter, 0, 0, "EXPAND")
	self._filter:connect("EVT_COMMAND_TEXT_UPDATED", callback(self, self, "update_filter"), nil)

	self._list = EWS:ListCtrl(self._panel, "", "LC_REPORT,LC_NO_HEADER,LC_SORT_ASCENDING")

	self._list:clear_all()
	self._list:append_column("Name")
	list_sizer:add(self._list, 1, 0, "EXPAND")
	horizontal_ctrlr_sizer:add(list_sizer, 3, 0, "EXPAND")
	self._panel_sizer:add(horizontal_ctrlr_sizer, 1, 0, "EXPAND")
	self._list:connect("EVT_COMMAND_LIST_ITEM_SELECTED", callback(self, self, "on_mark_group"), nil)
	self._list:connect("EVT_COMMAND_LIST_ITEM_ACTIVATED", callback(self, self, "on_select_group"), nil)
	self._list:connect("EVT_KEY_DOWN", callback(self, self, "key_delete"), "")
	self._list:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")

	local button_sizer = EWS:BoxSizer("HORIZONTAL")
	local select_btn = EWS:Button(self._panel, "Select", "", "")

	button_sizer:add(select_btn, 0, 2, "RIGHT,LEFT")
	select_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_select_group"), "")
	select_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")

	local find_btn = EWS:Button(self._panel, "Find", "", "")

	button_sizer:add(find_btn, 0, 2, "RIGHT,LEFT")
	find_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_find_group"), "")
	find_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")

	local ungroup_btn = EWS:Button(self._panel, "Ungroup", "", "")

	button_sizer:add(ungroup_btn, 0, 2, "RIGHT,LEFT")
	ungroup_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_ungroup"), "")
	ungroup_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")

	local delete_btn = EWS:Button(self._panel, "Delete", "", "")

	button_sizer:add(delete_btn, 0, 2, "RIGHT,LEFT")
	delete_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_delete"), "")
	delete_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")

	local cancel_btn = EWS:Button(self._panel, "Cancel", "", "")

	button_sizer:add(cancel_btn, 0, 2, "RIGHT,LEFT")
	cancel_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_cancel"), "")
	cancel_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")
	self._panel_sizer:add(button_sizer, 0, 4, "ALIGN_RIGHT,TOP,BOTTOM")
	self._dialog_sizer:add(self._panel, 1, 5, "EXPAND,LEFT,RIGHT")
	self:fill_group_list()
	self._dialog:set_visible(true)
end

function SelectGroupByName:key_delete(ctrlr, event)
	event:skip()

	if EWS:name_to_key_code("K_DELETE") == event:key_code() then
		self:on_delete()
	end
end

function SelectGroupByName:key_cancel(ctrlr, event)
	event:skip()

	if EWS:name_to_key_code("K_ESCAPE") == event:key_code() then
		self:on_cancel()
	end
end

function SelectGroupByName:on_delete()
	managers.editor:freeze_gui_lists()

	local groups = self:_selected_item_groups()

	for _, group in ipairs(groups) do
		for _, unit in ipairs(clone(group:units())) do
			managers.editor:delete_unit(unit)
		end
	end

	managers.editor:thaw_gui_lists()
end

function SelectGroupByName:on_mark_group()
	return
end

function SelectGroupByName:on_ungroup()
	local groups = self:_selected_item_groups()

	for _, group in ipairs(groups) do
		managers.editor:remove_group(group:name())
	end
end

function SelectGroupByName:on_select_group()
	local group = self:_selected_item_group()

	if not group then
		return
	end

	local ref = group:reference()

	managers.editor:change_layer_based_on_unit(ref)
	managers.editor:freeze_gui_lists()
	managers.editor:select_group(group)
	managers.editor:thaw_gui_lists()
end

function SelectGroupByName:on_find_group()
	local group = self:_selected_item_group()

	if not group then
		return
	end

	local radius = 0

	mvector3.set_zero(tmp_vec3)

	for _, unit in ipairs(self:_selected_item_group():units()) do
		if radius < unit:bounding_sphere_radius() then
			radius = unit:bounding_sphere_radius()
		end

		mvector3.add(tmp_vec3, unit:position())
	end

	mvector3.multiply(tmp_vec3, 1 / #self:_selected_item_group():units())
	managers.editor:center_view_on_point(tmp_vec3, radius * 4)
end

function SelectGroupByName:_selected_item_groups()
	local groups = {}

	for _, i in ipairs(self._list:selected_items()) do
		local group = self._groups[self._list:get_item_data(i)]

		table.insert(groups, group)
	end

	return groups
end

function SelectGroupByName:_selected_item_group()
	local index = self._list:selected_item()

	if index ~= -1 then
		return self._groups[self._list:get_item_data(index)]
	end
end

function SelectGroupByName:group_removed(group)
	for i = 0, self._list:item_count() - 1 do
		if self._groups[self._list:get_item_data(i)] == group then
			self._list:delete_item(i)

			return
		end
	end
end

function SelectGroupByName:group_created(group)
	local i = self._list:append_item(group:name())
	local j = #self._groups + 1

	self._groups[j] = group

	self._list:set_item_data(i, j)
end

function SelectGroupByName:group_selected(group)
	for _, i in ipairs(self._list:selected_items()) do
		self._list:set_item_selected(i, false)
	end

	for i = 0, self._list:item_count() - 1 do
		if self._groups[self._list:get_item_data(i)] == group then
			self._list:set_item_selected(i, true)
			self._list:ensure_visible(i)

			return
		end
	end
end

function SelectGroupByName:update_filter()
	self:fill_group_list()
end

function SelectGroupByName:fill_group_list()
	self._list:delete_all_items()

	local groups = managers.editor:groups():groups()
	local j = 1
	local filter = self._filter:get_value()

	self._groups = {}

	self._list:freeze()

	for name, group in pairs(groups) do
		if string.find(name, filter, 1, true) then
			local units = group._units
			local i = self._list:append_item(name .. " [" .. #units .. "]")

			self._groups[j] = group

			self._list:set_item_data(i, j)

			j = j + 1
		end
	end

	self._list:thaw()
	self._list:autosize_column(0)
end

function SelectGroupByName:reset()
	self:fill_group_list()
end

function SelectGroupByName:freeze()
	self._list:freeze()
end

function SelectGroupByName:thaw()
	self._list:thaw()
end
