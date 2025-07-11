CoreTimerUnitElement = CoreTimerUnitElement or class(MissionElement)
CoreTimerUnitElement.SAVE_UNIT_POSITION = false
CoreTimerUnitElement.SAVE_UNIT_ROTATION = false
CoreTimerUnitElement.INSTANCE_VAR_NAMES = {
	{
		type = "number",
		value = "timer",
	},
}
CoreTimerUnitElement.LINK_VALUES = {
	{
		layer = "Statics",
		output = true,
		table_value = "digital_gui_unit_ids",
		type = "guis",
	},
}
TimerUnitElement = TimerUnitElement or class(CoreTimerUnitElement)

function TimerUnitElement:init(...)
	TimerUnitElement.super.init(self, ...)
end

function CoreTimerUnitElement:init(unit)
	CoreTimerUnitElement.super.init(self, unit)

	self._digital_gui_units = {}
	self._hed.timer = 0
	self._hed.digital_gui_unit_ids = {}
	self._hed.output_monitor_id = nil

	table.insert(self._save_values, "output_monitor_id")
	table.insert(self._save_values, "timer")
	table.insert(self._save_values, "digital_gui_unit_ids")
end

function CoreTimerUnitElement:layer_finished()
	MissionElement.layer_finished(self)

	for _, id in pairs(self._hed.digital_gui_unit_ids) do
		local unit = managers.worlddefinition:get_unit_on_load(id, callback(self, self, "load_unit"))

		if unit then
			self._digital_gui_units[unit:unit_data().unit_id] = unit
		end
	end
end

function CoreTimerUnitElement:load_unit(unit)
	if unit then
		self._digital_gui_units[unit:unit_data().unit_id] = unit
	end
end

function CoreTimerUnitElement:update_selected()
	for _, id in pairs(self._hed.digital_gui_unit_ids) do
		if not alive(self._digital_gui_units[id]) then
			table.delete(self._hed.digital_gui_unit_ids, id)

			self._digital_gui_units[id] = nil
		end
	end

	for id, unit in pairs(self._digital_gui_units) do
		if not alive(unit) then
			table.delete(self._hed.digital_gui_unit_ids, id)

			self._digital_gui_units[id] = nil
		else
			local params = {
				b = 0,
				from_unit = self._unit,
				g = 1,
				r = 0,
				to_unit = unit,
			}

			self:_draw_link(params)
			Application:draw(unit, 0, 1, 0)
		end
	end
end

function CoreTimerUnitElement:update_unselected(t, dt, selected_unit, all_units)
	for _, id in pairs(self._hed.digital_gui_unit_ids) do
		if not alive(self._digital_gui_units[id]) then
			table.delete(self._hed.digital_gui_unit_ids, id)

			self._digital_gui_units[id] = nil
		end
	end

	for id, unit in pairs(self._digital_gui_units) do
		if not alive(unit) then
			table.delete(self._hed.digital_gui_unit_ids, id)

			self._digital_gui_units[id] = nil
		end
	end
end

function CoreTimerUnitElement:draw_links_unselected(...)
	CoreTimerUnitElement.super.draw_links_unselected(self, ...)

	for id, unit in pairs(self._digital_gui_units) do
		local params = {
			b = 0,
			from_unit = self._unit,
			g = 0.5,
			r = 0,
			to_unit = unit,
		}

		self:_draw_link(params)
		Application:draw(unit, 0, 0.5, 0)
	end
end

function CoreTimerUnitElement:update_editing()
	local ray = managers.editor:unit_by_raycast({
		mask = managers.slot:get_mask("all"),
		ray_type = "body editor",
		sample = true,
	})

	if ray and ray.unit and ray.unit:digital_gui() and ray.unit:digital_gui():is_timer() then
		Application:draw(ray.unit, 0, 1, 0)
	end
end

function CoreTimerUnitElement:select_unit()
	local ray = managers.editor:unit_by_raycast({
		mask = managers.slot:get_mask("all"),
		ray_type = "body editor",
		sample = true,
	})

	if ray and ray.unit and ray.unit:digital_gui() and ray.unit:digital_gui():is_timer() then
		local unit = ray.unit

		if self._digital_gui_units[unit:unit_data().unit_id] then
			self:_remove_unit(unit)
		else
			self:_add_unit(unit)
		end
	end
end

function CoreTimerUnitElement:_remove_unit(unit)
	self._digital_gui_units[unit:unit_data().unit_id] = nil

	table.delete(self._hed.digital_gui_unit_ids, unit:unit_data().unit_id)
end

function CoreTimerUnitElement:_add_unit(unit)
	self._digital_gui_units[unit:unit_data().unit_id] = unit

	table.insert(self._hed.digital_gui_unit_ids, unit:unit_data().unit_id)
end

function CoreTimerUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "select_unit"))
end

function CoreTimerUnitElement:_add_unit_filter(unit)
	if self._digital_gui_units[unit:unit_data().unit_id] then
		return false
	end

	return unit:digital_gui() and unit:digital_gui():is_timer()
end

function CoreTimerUnitElement:_remove_unit_filter(unit)
	return self._digital_gui_units[unit:unit_data().unit_id]
end

function CoreTimerUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_add_remove_static_unit_from_list(panel, panel_sizer, {
		add_filter = callback(self, self, "_add_unit_filter"),
		add_result = callback(self, self, "_add_unit"),
		remove_filter = callback(self, self, "_remove_unit_filter"),
		remove_result = callback(self, self, "_remove_unit"),
	})
	self:_build_value_number(panel, panel_sizer, "timer", {
		floats = 1,
		min = 0,
	}, "Specifies how long time (in seconds) to wait before execute")
	self:_add_help_text("Creates a timer element. When the timer runs out, execute will be run. The timer element can be operated on using the logic_timer_operator")
end

function CoreTimerUnitElement:register_debug_output_unit(output_monitor_id)
	self._hed.output_monitor_id = output_monitor_id
end

function CoreTimerUnitElement:unregister_debug_output_unit()
	self._hed.output_monitor_id = nil
end

CoreTimerOperatorUnitElement = CoreTimerOperatorUnitElement or class(MissionElement)
CoreTimerOperatorUnitElement.LINK_VALUES = {
	{
		output = true,
		table_value = "elements",
		type = "operator",
	},
}
TimerOperatorUnitElement = TimerOperatorUnitElement or class(CoreTimerOperatorUnitElement)

function TimerOperatorUnitElement:init(...)
	TimerOperatorUnitElement.super.init(self, ...)
end

function CoreTimerOperatorUnitElement:init(unit)
	CoreTimerOperatorUnitElement.super.init(self, unit)

	self._hed.operation = "none"
	self._hed.time = 0
	self._hed.elements = {}

	table.insert(self._save_values, "operation")
	table.insert(self._save_values, "time")
	table.insert(self._save_values, "elements")
end

function CoreTimerOperatorUnitElement:draw_links(t, dt, selected_unit, all_units)
	CoreTimerOperatorUnitElement.super.draw_links(self, t, dt, selected_unit)

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

function CoreTimerOperatorUnitElement:update_editing()
	return
end

function CoreTimerOperatorUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and (ray.unit:name() == Idstring("core/units/mission_elements/logic_timer/logic_timer") or ray.unit:name() == Idstring("core/units/mission_elements/logic_timer_hud/logic_timer_hud")) then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function CoreTimerOperatorUnitElement:remove_links(unit)
	for _, id in ipairs(self._hed.elements) do
		if id == unit:unit_data().unit_id then
			table.delete(self._hed.elements, id)
		end
	end
end

function CoreTimerOperatorUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function CoreTimerOperatorUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local names = {
		"logic_timer/logic_timer",
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)
	self:_build_value_combobox(panel, panel_sizer, "operation", {
		"none",
		"pause",
		"start",
		"add_time",
		"subtract_time",
		"reset",
		"set_time",
		"show_hud_timer",
		"hide_hud_timer",
	}, "Select an operation for the selected elements")
	self:_build_value_number(panel, panel_sizer, "time", {
		floats = 1,
		min = 0,
	}, "Amount of time to add, subtract or set to the timers.")
	self:_add_help_text("This element can modify logic_timer element. Select timers to modify using insert and clicking on the elements.")
end

CoreTimerTriggerUnitElement = CoreTimerTriggerUnitElement or class(MissionElement)
CoreTimerTriggerUnitElement.LINK_VALUES = {
	{
		table_value = "elements",
		type = "trigger",
	},
}
TimerTriggerUnitElement = TimerTriggerUnitElement or class(CoreTimerTriggerUnitElement)

function TimerTriggerUnitElement:init(...)
	TimerTriggerUnitElement.super.init(self, ...)
end

function CoreTimerTriggerUnitElement:init(unit)
	CoreTimerTriggerUnitElement.super.init(self, unit)

	self._hed.time = 0
	self._hed.elements = {}

	table.insert(self._save_values, "time")
	table.insert(self._save_values, "elements")
end

function CoreTimerTriggerUnitElement:draw_links(t, dt, selected_unit, all_units)
	CoreTimerTriggerUnitElement.super.draw_links(self, t, dt, selected_unit)

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

function CoreTimerTriggerUnitElement:update_editing()
	return
end

function CoreTimerTriggerUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and (ray.unit:name() == Idstring("core/units/mission_elements/logic_timer/logic_timer") or ray.unit:name() == Idstring("core/units/mission_elements/logic_timer_hud/logic_timer_hud")) then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function CoreTimerTriggerUnitElement:remove_links(unit)
	for _, id in ipairs(self._hed.elements) do
		if id == unit:unit_data().unit_id then
			table.delete(self._hed.elements, id)
		end
	end
end

function CoreTimerTriggerUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function CoreTimerTriggerUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local names = {
		"logic_timer/logic_timer",
		"logic_timer_hud/logic_timer_hud",
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)
	self:_build_value_number(panel, panel_sizer, "time", {
		floats = 1,
		min = 0,
	}, "Specify how much time should be left on the timer to trigger.")
	self:_add_help_text("This element is a trigger to logic_timer element.")
end
