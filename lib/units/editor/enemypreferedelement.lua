EnemyPreferedAddUnitElement = EnemyPreferedAddUnitElement or class(MissionElement)
EnemyPreferedAddUnitElement.LINK_VALUES = {
	{
		output = true,
		table_value = "spawn_groups",
		type = "spawn_group",
	},
	{
		output = true,
		table_value = "spawn_points",
		type = "spawn_point",
	},
}
EnemyPreferedAddUnitElement.SAVE_UNIT_POSITION = false
EnemyPreferedAddUnitElement.SAVE_UNIT_ROTATION = false

function EnemyPreferedAddUnitElement:init(unit)
	EnemyPreferedRemoveUnitElement.super.init(self, unit)
	table.insert(self._save_values, "spawn_points")
	table.insert(self._save_values, "spawn_groups")
end

function EnemyPreferedAddUnitElement:draw_links(t, dt, selected_unit, all_units)
	EnemyPreferedRemoveUnitElement.super.draw_links(self, t, dt, selected_unit, all_units)
	self:_private_draw_links(t, dt, selected_unit, all_units)
end

function EnemyPreferedAddUnitElement:_private_draw_links(t, dt, selected_unit, all_units)
	local function _draw_func(element_ids)
		if not element_ids then
			return
		end

		for _, id in ipairs(element_ids) do
			local unit = all_units[id]
			local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

			if draw then
				self:_draw_link({
					b = 0.75,
					from_unit = self._unit,
					g = 0,
					r = 0,
					to_unit = unit,
				})
			end
		end
	end

	_draw_func(self._hed.spawn_points)
	_draw_func(self._hed.spawn_groups)
end

function EnemyPreferedAddUnitElement:update_editing()
	return
end

function EnemyPreferedAddUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit then
		local is_group, id

		if string.find(ray.unit:name():s(), "ai_spawn_enemy", 1, true) then
			id = ray.unit:unit_data().unit_id
		elseif string.find(ray.unit:name():s(), "ai_enemy_group", 1, true) then
			id = ray.unit:unit_data().unit_id
			is_group = true
		end

		if id then
			if is_group then
				if self._hed.spawn_groups and table.contains(self._hed.spawn_groups, id) then
					self:_delete_id_from_table(id, "spawn_groups")
				else
					self._hed.spawn_groups = self._hed.spawn_groups or {}

					table.insert(self._hed.spawn_groups, id)
				end
			elseif self._hed.spawn_points and table.contains(self._hed.spawn_points, id) then
				self:_delete_id_from_table(id, "spawn_points")
			else
				self._hed.spawn_points = self._hed.spawn_points or {}

				table.insert(self._hed.spawn_points, id)
			end
		end
	end
end

function EnemyPreferedAddUnitElement:_delete_id_from_table(id, table_name)
	if not self._hed[table_name] then
		return
	end

	table.delete(self._hed[table_name], id)

	if not next(self._hed[table_name]) then
		self._hed[table_name] = nil
	end
end

function EnemyPreferedAddUnitElement:remove_links(unit)
	local rem_u_id = unit:unit_data().unit_id

	local function _rem_func(element_ids)
		if not element_ids then
			return
		end

		for _, id in ipairs(element_ids) do
			if id == rem_u_id then
				table.delete(element_ids, id)
			end
		end
	end

	_rem_func(self._hed.spawn_points)
	_rem_func(self._hed.spawn_groups)
end

function EnemyPreferedAddUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function EnemyPreferedAddUnitElement:add_unit_list_btn()
	local script = self._unit:mission_element_data().script

	local function f(unit)
		if not unit or not unit:mission_element_data() or unit:mission_element_data().script ~= script then
			return
		end

		local id = unit:unit_data().unit_id

		if self._hed.spawn_points and table.contains(self._hed.spawn_points, id) then
			return false
		end

		if self._hed.spawn_groups and table.contains(self._hed.spawn_groups, id) then
			return false
		end

		if string.find(unit:name():s(), "ai_enemy_group", 1, true) or string.find(unit:name():s(), "ai_spawn_enemy", 1, true) then
			return true
		end

		return false
	end

	local dialog = SelectUnitByNameModal:new("Add Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		if string.find(unit:name():s(), "ai_enemy_group", 1, true) then
			self._hed.spawn_groups = self._hed.spawn_groups or {}

			table.insert(self._hed.spawn_groups, id)
		elseif string.find(unit:name():s(), "ai_spawn_enemy", 1, true) then
			self._hed.spawn_points = self._hed.spawn_points or {}

			table.insert(self._hed.spawn_points, id)
		end
	end
end

function EnemyPreferedAddUnitElement:remove_unit_list_btn()
	local function f(unit)
		return self._hed.spawn_groups and table.contains(self._hed.spawn_groups, unit:unit_data().unit_id) or self._hed.spawn_points and table.contains(self._hed.spawn_points, unit:unit_data().unit_id)
	end

	local dialog = SelectUnitByNameModal:new("Remove Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		self:_delete_id_from_table(id, "spawn_groups")
		self:_delete_id_from_table(id, "spawn_points")
	end
end

function EnemyPreferedAddUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_UNIT_LIST", "Add unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "add_unit_list_btn"), nil)
	toolbar:add_tool("REMOVE_UNIT_LIST", "Remove unit from unit list", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("REMOVE_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "remove_unit_list_btn"), nil)
	toolbar:realize()
	panel_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
end

EnemyPreferedRemoveUnitElement = EnemyPreferedRemoveUnitElement or class(MissionElement)
EnemyPreferedRemoveUnitElement.LINK_VALUES = {
	{
		output = true,
		table_value = "elements",
		type = "operator",
	},
}
EnemyPreferedRemoveUnitElement.SAVE_UNIT_POSITION = false
EnemyPreferedRemoveUnitElement.SAVE_UNIT_ROTATION = false

function EnemyPreferedRemoveUnitElement:init(unit)
	EnemyPreferedRemoveUnitElement.super.init(self, unit)

	self._hed.elements = {}

	table.insert(self._save_values, "elements")
end

function EnemyPreferedRemoveUnitElement:update_editing()
	return
end

function EnemyPreferedRemoveUnitElement:draw_links(t, dt, selected_unit, all_units)
	EnemyPreferedRemoveUnitElement.super.draw_links(self, t, dt, selected_unit)

	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				b = 0,
				from_unit = self._unit,
				g = 0,
				r = 0.75,
				to_unit = unit,
			})
		end
	end
end

function EnemyPreferedRemoveUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and string.find(ray.unit:name():s(), "ai_enemy_prefered_add", 1, true) then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function EnemyPreferedRemoveUnitElement:remove_links(unit)
	for _, id in ipairs(self._hed.elements) do
		if id == unit:unit_data().unit_id then
			table.delete(self._hed.elements, id)
		end
	end
end

function EnemyPreferedRemoveUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function EnemyPreferedRemoveUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local names = {
		"ai_enemy_prefered_add",
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)
end
