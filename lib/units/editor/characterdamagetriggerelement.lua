CharacterDamageTriggerUnitElement = CharacterDamageTriggerUnitElement or class(MissionElement)
CharacterDamageTriggerUnitElement.LINK_VALUES = {
	{
		table_value = "elements",
		type = "trigger",
	},
}

function CharacterDamageTriggerUnitElement:init(unit)
	CharacterDamageTriggerUnitElement.super.init(self, unit)

	self._hed.elements = {}
	self._hed.damage_types = ""
	self._hed.percentage = false

	table.insert(self._save_values, "elements")
	table.insert(self._save_values, "damage_types")
	table.insert(self._save_values, "percentage")
end

function CharacterDamageTriggerUnitElement:draw_links(t, dt, selected_unit, all_units)
	MissionElement.draw_links(self, t, dt, selected_unit)

	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				b = 0,
				from_unit = unit,
				g = 0.85,
				r = 0,
				to_unit = self._unit,
			})
		end
	end
end

function CharacterDamageTriggerUnitElement:update_editing()
	return
end

function CharacterDamageTriggerUnitElement:add_element()
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

function CharacterDamageTriggerUnitElement:_correct_unit(u_name)
	local names = {
		"ai_spawn_enemy",
		"ai_enemy_group",
		"ai_spawn_civilian",
		"ai_civilian_group",
		"point_spawn_player",
	}

	for _, name in ipairs(names) do
		if string.find(u_name, name, 1, true) then
			return true
		end
	end

	return false
end

function CharacterDamageTriggerUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function CharacterDamageTriggerUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local dmg_sizer = EWS:BoxSizer("HORIZONTAL")

	dmg_sizer:add(EWS:StaticText(panel, "Damage Types Filter:", 0, ""), 1, 0, "ALIGN_CENTER_VERTICAL")

	local dmg_types = EWS:TextCtrl(panel, self._hed.damage_types, "", "TE_PROCESS_ENTER")

	dmg_types:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		ctrlr = dmg_types,
		value = "damage_types",
	})
	dmg_types:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		ctrlr = dmg_types,
		value = "damage_types",
	})
	dmg_sizer:add(dmg_types, 2, 0, "ALIGN_CENTER_VERTICAL")
	panel_sizer:add(dmg_sizer, 0, 0, "EXPAND")

	local percentage = EWS:CheckBox(panel, "Percentage", "")

	percentage:set_value(self._hed.percentage)
	percentage:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = percentage,
		value = "percentage",
	})
	panel_sizer:add(percentage, 0, 0, "EXPAND")
	self:add_help_text({
		panel = panel,
		sizer = panel_sizer,
		text = "logic_counter_operator elements will use the reported <damage> as the amount to add/subtract/set.\nDamage types can be filtered by specifying specific damage types separated by spaces.",
	})
end
