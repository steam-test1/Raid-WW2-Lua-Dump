InvulnerableUnitElement = InvulnerableUnitElement or class(MissionElement)
InvulnerableUnitElement.LINK_VALUES = {
	{
		output = true,
		table_value = "elements",
		type = "invulnerable",
	},
}

function InvulnerableUnitElement:init(unit)
	InvulnerableUnitElement.super.init(self, unit)

	self._hed.invulnerable = true
	self._hed.immortal = false
	self._hed.apply_instigator = false
	self._hed.elements = {}

	table.insert(self._save_values, "invulnerable")
	table.insert(self._save_values, "immortal")
	table.insert(self._save_values, "apply_instigator")
	table.insert(self._save_values, "elements")
end

function InvulnerableUnitElement:draw_links(t, dt, selected_unit, all_units)
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

function InvulnerableUnitElement:update_editing()
	return
end

function InvulnerableUnitElement:add_element()
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

function InvulnerableUnitElement:_correct_unit(u_name)
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

function InvulnerableUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function InvulnerableUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local invulnerable = EWS:CheckBox(panel, "Invulnerable", "")

	invulnerable:set_value(self._hed.invulnerable)
	invulnerable:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = invulnerable,
		value = "invulnerable",
	})
	panel_sizer:add(invulnerable, 0, 0, "EXPAND")

	local immortal = EWS:CheckBox(panel, "Immortal", "")

	immortal:set_value(self._hed.immortal)
	immortal:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = immortal,
		value = "immortal",
	})
	panel_sizer:add(immortal, 0, 0, "EXPAND")

	local apply_instigator = EWS:CheckBox(panel, "apply_instigator", "")

	apply_instigator:set_value(self._hed.apply_instigator)
	apply_instigator:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = apply_instigator,
		value = "apply_instigator",
	})
	panel_sizer:add(apply_instigator, 0, 0, "EXPAND")

	local help = {}

	help.text = "Makes a unit invulnerable or immortal."
	help.panel = panel
	help.sizer = panel_sizer

	self:add_help_text(help)
end
