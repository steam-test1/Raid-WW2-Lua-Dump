EnemyDummyTriggerUnitElement = EnemyDummyTriggerUnitElement or class(MissionElement)
EnemyDummyTriggerUnitElement.LINK_VALUES = {
	{
		table_value = "elements",
		type = "trigger",
	},
}

function EnemyDummyTriggerUnitElement:init(unit)
	MissionElement.init(self, unit)

	self._hed.event = "death"
	self._hed.elements = {}

	table.insert(self._save_values, "event")
	table.insert(self._save_values, "elements")
end

function EnemyDummyTriggerUnitElement:draw_links(t, dt, selected_unit, all_units)
	MissionElement.draw_links(self, t, dt, selected_unit)

	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				b = 0,
				from_unit = unit,
				g = 0.75,
				r = 0,
				to_unit = self._unit,
			})
		end
	end
end

function EnemyDummyTriggerUnitElement:update_editing()
	return
end

function EnemyDummyTriggerUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and self:_correct_unit(ray.unit:name():s()) then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function EnemyDummyTriggerUnitElement:_correct_unit(u_name)
	local names = {
		"ai_spawn_enemy",
		"ai_enemy_group",
		"ai_spawn_civilian",
		"ai_civilian_group",
	}

	for _, name in ipairs(names) do
		if string.find(u_name, name, 1, true) then
			return true
		end
	end

	return false
end

function EnemyDummyTriggerUnitElement:remove_links(unit)
	for _, id in ipairs(self._hed.elements) do
		if id == unit:unit_data().unit_id then
			table.delete(self._hed.elements, id)
		end
	end
end

function EnemyDummyTriggerUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function EnemyDummyTriggerUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local names = {
		"ai_spawn_enemy",
		"ai_enemy_group",
		"ai_spawn_civilian",
		"ai_civilian_group",
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)

	local options = {
		"marked",
		"alerted",
		"death",
		"killshot",
		"fled",
		"spawn",
		"panic",
		"weapons_hot",
		"anim_act_01",
		"anim_act_02",
		"anim_act_03",
		"anim_act_04",
		"anim_act_05",
		"anim_act_06",
		"anim_act_07",
		"anim_act_08",
		"anim_act_09",
		"anim_act_10",
	}

	self:_build_value_combobox(panel, panel_sizer, "event", options)
end
