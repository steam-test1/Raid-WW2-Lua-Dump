CoreLogicChanceUnitElement = CoreLogicChanceUnitElement or class(MissionElement)
LogicChanceUnitElement = LogicChanceUnitElement or class(CoreLogicChanceUnitElement)

function LogicChanceUnitElement:init(...)
	CoreLogicChanceUnitElement.init(self, ...)
end

function CoreLogicChanceUnitElement:init(unit)
	MissionElement.init(self, unit)

	self._hed.chance = 100
	self._hed.output_monitor_id = nil

	table.insert(self._save_values, "output_monitor_id")
	table.insert(self._save_values, "chance")
end

function CoreLogicChanceUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_number(panel, panel_sizer, "chance", {
		floats = 0,
		max = 100,
		min = 0,
	}, "Specifies chance that this element will call its on executed elements (in percent)")
end

function CoreLogicChanceUnitElement:register_debug_output_unit(output_monitor_id)
	self._hed.output_monitor_id = output_monitor_id
end

function CoreLogicChanceUnitElement:unregister_debug_output_unit()
	self._hed.output_monitor_id = nil
end

CoreLogicChanceOperatorUnitElement = CoreLogicChanceOperatorUnitElement or class(MissionElement)
CoreLogicChanceOperatorUnitElement.LINK_VALUES = {
	{
		output = true,
		table_value = "elements",
		type = "operator",
	},
}
LogicChanceOperatorUnitElement = LogicChanceOperatorUnitElement or class(CoreLogicChanceOperatorUnitElement)

function LogicChanceOperatorUnitElement:init(...)
	LogicChanceOperatorUnitElement.super.init(self, ...)
end

function CoreLogicChanceOperatorUnitElement:init(unit)
	CoreLogicChanceOperatorUnitElement.super.init(self, unit)

	self._hed.operation = "none"
	self._hed.chance = 0
	self._hed.elements = {}

	table.insert(self._save_values, "operation")
	table.insert(self._save_values, "chance")
	table.insert(self._save_values, "elements")
end

function CoreLogicChanceOperatorUnitElement:draw_links(t, dt, selected_unit, all_units)
	CoreLogicChanceOperatorUnitElement.super.draw_links(self, t, dt, selected_unit)

	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				b = 0.25,
				from_unit = self._unit,
				g = 0.75,
				r = 0.75,
				to_unit = unit,
			})
		end
	end
end

function CoreLogicChanceOperatorUnitElement:update_editing()
	return
end

function CoreLogicChanceOperatorUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and ray.unit:name() == Idstring("core/units/mission_elements/logic_chance/logic_chance") then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function CoreLogicChanceOperatorUnitElement:remove_links(unit)
	for _, id in ipairs(self._hed.elements) do
		if id == unit:unit_data().unit_id then
			table.delete(self._hed.elements, id)
		end
	end
end

function CoreLogicChanceOperatorUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function CoreLogicChanceOperatorUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local names = {
		"logic_chance/logic_chance",
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)
	self:_build_value_combobox(panel, panel_sizer, "operation", {
		"none",
		"add_chance",
		"subtract_chance",
		"reset",
		"set_chance",
	}, "Select an operation for the selected elements")
	self:_build_value_number(panel, panel_sizer, "chance", {
		floats = 0,
		max = 100,
		min = 0,
	}, "Amount of chance to add, subtract or set to the logic chance elements.")
	self:_add_help_text("This element can modify logic_chance element. Select logic chance elements to modify using insert and clicking on the elements.")
end

CoreLogicChanceTriggerUnitElement = CoreLogicChanceTriggerUnitElement or class(MissionElement)
CoreLogicChanceTriggerUnitElement.LINK_VALUES = {
	{
		table_value = "elements",
		type = "trigger",
	},
}
LogicChanceTriggerUnitElement = LogicChanceTriggerUnitElement or class(CoreLogicChanceTriggerUnitElement)

function LogicChanceTriggerUnitElement:init(...)
	LogicChanceTriggerUnitElement.super.init(self, ...)
end

function CoreLogicChanceTriggerUnitElement:init(unit)
	CoreLogicChanceTriggerUnitElement.super.init(self, unit)

	self._hed.outcome = "fail"
	self._hed.elements = {}

	table.insert(self._save_values, "outcome")
	table.insert(self._save_values, "elements")
end

function CoreLogicChanceTriggerUnitElement:draw_links(t, dt, selected_unit, all_units)
	CoreLogicChanceTriggerUnitElement.super.draw_links(self, t, dt, selected_unit)

	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				b = 0.25,
				from_unit = unit,
				g = 0.85,
				r = 0.85,
				to_unit = self._unit,
			})
		end
	end
end

function CoreLogicChanceTriggerUnitElement:update_editing()
	return
end

function CoreLogicChanceTriggerUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and ray.unit:name() == Idstring("core/units/mission_elements/logic_chance/logic_chance") then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function CoreLogicChanceTriggerUnitElement:remove_links(unit)
	for _, id in ipairs(self._hed.elements) do
		if id == unit:unit_data().unit_id then
			table.delete(self._hed.elements, id)
		end
	end
end

function CoreLogicChanceTriggerUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function CoreLogicChanceTriggerUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local names = {
		"logic_chance/logic_chance",
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)
	self:_build_value_combobox(panel, panel_sizer, "outcome", {
		"fail",
		"success",
	}, "Select an outcome to trigger on")
	self:_add_help_text("This element is a trigger to logic_chance element.")
end
