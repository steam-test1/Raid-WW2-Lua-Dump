SpecialObjectiveGroupElement = SpecialObjectiveGroupElement or class(MissionElement)
SpecialObjectiveGroupElement.LINK_VALUES = {
	{
		table_value = "spawn_instigator_ids",
		type = "instigator",
	},
	{
		output = true,
		table_value = "followup_elements",
		type = "followup",
	},
	{
		output = true,
		table_key = "id",
		table_value = "followup_patrol_elements",
		type = "followup",
	},
}

function SpecialObjectiveGroupElement:init(unit)
	SpecialObjectiveGroupElement.super.init(self, unit)

	self._hed.base_chance = 1
	self._hed.use_instigator = false
	self._hed.followup_elements = nil
	self._hed.followup_patrol_elements = {}
	self._hed.spawn_instigator_ids = nil
	self._hed.mode = "randomizer"

	table.insert(self._save_values, "base_chance")
	table.insert(self._save_values, "use_instigator")
	table.insert(self._save_values, "followup_elements")
	table.insert(self._save_values, "followup_patrol_elements")
	table.insert(self._save_values, "spawn_instigator_ids")
	table.insert(self._save_values, "mode")
end

function SpecialObjectiveGroupElement:post_init(...)
	SpecialObjectiveGroupElement.super.post_init(self, ...)
end

function SpecialObjectiveGroupElement:draw_links(t, dt, selected_unit, all_units)
	self:_remove_deleted_units(all_units)

	if self._hed.mode == "patrol_group" then
		if self._hed.followup_patrol_elements then
			for _, element in ipairs(self._hed.followup_patrol_elements) do
				local unit = all_units[element.id]

				if alive(unit) then
					local unit_data = unit:mission_element_data()

					unit_data._patrol_group = true

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
		end
	else
		SpecialObjectiveUnitElement.super.draw_links(self, t, dt, selected_unit)
		self:_draw_follow_up(selected_unit, all_units)
	end
end

function SpecialObjectiveGroupElement:update_selected(t, dt, selected_unit, all_units)
	self:_draw_follow_up(selected_unit, all_units)

	if self._hed.spawn_instigator_ids then
		for _, id in ipairs(self._hed.spawn_instigator_ids) do
			local unit = all_units[id]
			local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

			if draw then
				self:_draw_link({
					b = 0.75,
					from_unit = unit,
					g = 0,
					r = 0,
					to_unit = self._unit,
				})
			end
		end
	end
end

function SpecialObjectiveGroupElement:update_unselected(t, dt, selected_unit, all_units)
	if self._hed.followup_elements then
		local followup_elements = self._hed.followup_elements
		local i = #followup_elements

		while i > 0 do
			local element_id = followup_elements[i]

			if not alive(all_units[element_id]) then
				table.remove(followup_elements, i)
			end

			i = i - 1
		end
	end

	if self._hed.spawn_instigator_ids then
		local spawn_instigator_ids = self._hed.spawn_instigator_ids
		local i = #spawn_instigator_ids

		while i > 0 do
			local id = spawn_instigator_ids[i]

			if not alive(all_units[id]) then
				table.remove(self._hed.spawn_instigator_ids, i)
			end

			i = i - 1
		end
	end
end

function SpecialObjectiveGroupElement:_remove_deleted_units(all_units)
	if self._hed.followup_patrol_elements then
		local followup_elements = self._hed.followup_patrol_elements
		local i = #followup_elements

		while i > 0 do
			local element_id = followup_elements[i].id

			if not alive(all_units[element_id]) then
				table.remove(followup_elements, i)
			end

			i = i - 1
		end
	end
end

function SpecialObjectiveGroupElement:_draw_follow_up(selected_unit, all_units)
	SpecialObjectiveUnitElement._draw_follow_up(self, selected_unit, all_units)
end

function SpecialObjectiveGroupElement:update_editing()
	self:_so_raycast()
	self:_spawn_raycast()
	self:_raycast()
end

function SpecialObjectiveGroupElement:_so_raycast()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and (string.find(ray.unit:name():s(), "point_special_objective", 1, true) or string.find(ray.unit:name():s(), "ai_so_group", 1, true)) then
		local id = ray.unit:unit_data().unit_id

		Application:draw(ray.unit, 0, 1, 0)

		return id
	end

	return nil
end

function SpecialObjectiveGroupElement:_spawn_raycast()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if not ray or not ray.unit then
		return
	end

	local id

	if string.find(ray.unit:name():s(), "ai_enemy_group", 1, true) or string.find(ray.unit:name():s(), "ai_spawn_enemy", 1, true) or string.find(ray.unit:name():s(), "ai_civilian_group", 1, true) or string.find(ray.unit:name():s(), "ai_spawn_civilian", 1, true) then
		id = ray.unit:unit_data().unit_id

		Application:draw(ray.unit, 0, 0, 1)
	end

	return id
end

function SpecialObjectiveGroupElement:_raycast()
	local from = managers.editor:get_cursor_look_point(0)
	local to = managers.editor:get_cursor_look_point(100000)
	local ray = World:raycast(from, to, nil, managers.slot:get_mask("all"))

	if ray and ray.position then
		Application:draw_sphere(ray.position, 10, 1, 1, 1)

		return ray.position
	end

	return nil
end

function SpecialObjectiveGroupElement:_element_type(element_id)
	local unit = managers.editor:unit_with_id(element_id)

	return string.match(unit:name():s(), ".*/(.*)")
end

function SpecialObjectiveGroupElement:_clear_followups(element_id)
	local pso = managers.editor:unit_with_id(element_id)
	local pso_med = pso:mission_element_data()

	pso_med.followup_elements = {}
	pso_med._patrol_group = true
end

function SpecialObjectiveGroupElement:_relink_patrol_followups()
	local ai_so_group_targets = {}

	for _, patrol_element_data in ipairs(self._hed.followup_patrol_elements) do
		if patrol_element_data.type == "point_special_objective" then
			self:_clear_followups(patrol_element_data.id)
		elseif patrol_element_data.type == "ai_so_group" then
			table.insert(ai_so_group_targets, patrol_element_data.id)
		end
	end

	for _, patrol_element_data in ipairs(self._hed.followup_patrol_elements) do
		if patrol_element_data.type == "point_special_objective" then
			local pso = managers.editor:unit_with_id(patrol_element_data.id)
			local pso_med = pso:mission_element_data()

			for _, group_id in ipairs(ai_so_group_targets) do
				table.insert(pso_med.followup_elements, group_id)
			end
		end
	end
end

function SpecialObjectiveGroupElement:_lmb()
	local id = self:_so_raycast()

	if id then
		if self._hed.mode == "patrol_group" then
			if self._hed.followup_patrol_elements then
				for i, element in ipairs(self._hed.followup_patrol_elements) do
					if element.id == id then
						table.remove(self._hed.followup_patrol_elements, i)

						if element.type == "point_special_objective" then
							self:_clear_followups(element.id)
						end

						self:_relink_patrol_followups()

						return
					end
				end
			end
		elseif self._hed.followup_elements then
			for i, element_id in ipairs(self._hed.followup_elements) do
				if element_id == id then
					table.remove(self._hed.followup_elements, i)

					return
				end
			end
		end

		if self._hed.mode == "patrol_group" then
			self._hed.followup_patrol_elements = self._hed.followup_patrol_elements or {}

			table.insert(self._hed.followup_patrol_elements, {
				id = id,
				type = self:_element_type(id),
			})
		else
			self._hed.followup_elements = self._hed.followup_elements or {}

			table.insert(self._hed.followup_elements, id)
		end

		if self._hed.mode == "patrol_group" then
			self:_relink_patrol_followups()
		end

		return
	end

	local id = self:_spawn_raycast()

	if id then
		if self._hed.spawn_instigator_ids then
			for i, si_id in ipairs(self._hed.spawn_instigator_ids) do
				if si_id == id then
					table.remove(self._hed.spawn_instigator_ids, i)

					return
				end
			end
		end

		self._hed.spawn_instigator_ids = self._hed.spawn_instigator_ids or {}

		table.insert(self._hed.spawn_instigator_ids, id)

		return
	end
end

function SpecialObjectiveGroupElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "_lmb"))
end

function SpecialObjectiveGroupElement:selected()
	SpecialObjectiveUnitElement.super.selected(self)
end

function SpecialObjectiveGroupElement:add_unit_list_btn()
	local script = self._unit:mission_element_data().script

	local function f(unit)
		if not unit or not unit:mission_element_data() or unit:mission_element_data().script ~= script then
			return
		end

		local id = unit:unit_data().unit_id

		if self._hed.spawn_instigator_ids and table.contains(self._hed.spawn_instigator_ids, id) then
			return false
		end

		if self._hed.followup_elements and table.contains(self._hed.followup_elements, id) then
			return false
		end

		if string.find(unit:name():s(), "ai_enemy_group", 1, true) or string.find(unit:name():s(), "ai_spawn_enemy", 1, true) or string.find(unit:name():s(), "ai_civilian_group", 1, true) or string.find(unit:name():s(), "ai_spawn_civilian", 1, true) or string.find(unit:name():s(), "point_special_objective", 1, true) or string.find(unit:name():s(), "ai_so_group", 1, true) then
			return true
		end

		return false
	end

	local dialog = SelectUnitByNameModal:new("Add Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		if string.find(unit:name():s(), "ai_enemy_group", 1, true) or string.find(unit:name():s(), "ai_spawn_enemy", 1, true) or string.find(unit:name():s(), "ai_civilian_group", 1, true) or string.find(unit:name():s(), "ai_spawn_civilian", 1, true) then
			self._hed.spawn_instigator_ids = self._hed.spawn_instigator_ids or {}

			table.insert(self._hed.spawn_instigator_ids, id)
		elseif string.find(unit:name():s(), "point_special_objective", 1, true) or string.find(unit:name():s(), "ai_so_group", 1, true) then
			self._hed.followup_elements = self._hed.followup_elements or {}

			table.insert(self._hed.followup_elements, id)
		end
	end
end

function SpecialObjectiveGroupElement:remove_unit_list_btn()
	local function f(unit)
		return self._hed.spawn_instigator_ids and table.contains(self._hed.spawn_instigator_ids, unit:unit_data().unit_id) or self._hed.followup_elements and table.contains(self._hed.followup_elements, unit:unit_data().unit_id)
	end

	local dialog = SelectUnitByNameModal:new("Remove Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		if self._hed.spawn_instigator_ids then
			table.delete(self._hed.spawn_instigator_ids, id)
		end

		if self._hed.followup_elements then
			table.delete(self._hed.followup_elements, id)
		end
	end
end

function SpecialObjectiveGroupElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local tooltip = ""

	tooltip = tooltip .. "RANDOMIZER: Assigns SOs to instigators.\n"
	tooltip = tooltip .. "PATROL GROUP: Assigns random SO in a way that will repeat the same path from this group.\n"
	tooltip = tooltip .. "FORCED SPAWN: Will spawn a new group of choice.\n"
	tooltip = tooltip .. "RECURRING: Spawns new group. After failure, a new group will be spawned with a delay.\n"

	local mode_params = {
		ctrlr_proportions = 2,
		name = "Mode:",
		name_proportions = 1,
		options = {
			"randomizer",
			"patrol_group",
			"forced_spawn",
			"recurring_cloaker_spawn",
			"recurring_spawn_1",
		},
		panel = panel,
		sizer = panel_sizer,
		sorted = false,
		tooltip = tooltip,
		value = self._hed.mode,
	}
	local mode = CoreEws.combobox(mode_params)

	mode:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "set_element_data"), {
		ctrlr = mode,
		value = "mode",
	})

	local use_instigator = EWS:CheckBox(panel, "Use instigator", "")

	use_instigator:set_value(self._hed.use_instigator)
	use_instigator:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = use_instigator,
		value = "use_instigator",
	})
	panel_sizer:add(use_instigator, 0, 0, "EXPAND")

	local base_chance_params = {
		ctrlr_proportions = 2,
		floats = 2,
		max = 1,
		min = 0,
		name = "Base chance:",
		name_proportions = 1,
		panel = panel,
		sizer = panel_sizer,
		tooltip = "Used to specify chance to happen (1.0 == 100%)",
		value = self._hed.base_chance,
	}
	local base_chance = CoreEws.number_controller(base_chance_params)

	base_chance:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		ctrlr = base_chance,
		value = "base_chance",
	})
	base_chance:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		ctrlr = base_chance,
		value = "base_chance",
	})

	self._btn_toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	self._btn_toolbar:add_tool("ADD_UNIT_LIST", "Add unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	self._btn_toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "add_unit_list_btn"), nil)
	self._btn_toolbar:add_tool("REMOVE_UNIT_LIST", "Remove unit from unit list", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	self._btn_toolbar:connect("REMOVE_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "remove_unit_list_btn"), nil)
	self._btn_toolbar:realize()
	panel_sizer:add(self._btn_toolbar, 0, 1, "EXPAND,LEFT")
end

function SpecialObjectiveGroupElement:add_to_mission_package()
	return
end
