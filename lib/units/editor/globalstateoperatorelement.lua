GlobalStateOperatorElement = GlobalStateOperatorElement or class(MissionElement)
GlobalStateOperatorElement.SAVE_UNIT_POSITION = false
GlobalStateOperatorElement.SAVE_UNIT_ROTATION = false
GlobalStateOperatorElement.ACTIONS = {
	"set",
	"clear",
	"default",
	"event",
	"set_value",
	"add_value",
	"sub_value",
	"links_set_value",
}

function GlobalStateOperatorElement:init(unit)
	GlobalStateOperatorElement.super.init(self, unit)

	self._hed.action = "set"
	self._hed.flag = ""
	self._hed.elements = {}

	table.insert(self._save_values, "use_instigator")
	table.insert(self._save_values, "action")
	table.insert(self._save_values, "flag")
	table.insert(self._save_values, "value")
	table.insert(self._save_values, "elements")

	self._actions = GlobalStateOperatorElement.ACTIONS
	self._flags = tweak_data.operations:get_all_mission_flags()

	table.sort(self._flags)
end

function GlobalStateOperatorElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "flag", self._flags, "Select an flag")
	self:_build_value_combobox(panel, panel_sizer, "action", self._actions, "Select an action for the selected flag")

	local value_sizer = EWS:BoxSizer("HORIZONTAL")

	panel_sizer:add(value_sizer, 0, 0, "EXPAND")

	local value_name = EWS:StaticText(panel, "Value:", 0, "")

	value_sizer:add(value_name, 1, 0, "ALIGN_CENTER_VERTICAL")

	local value = EWS:TextCtrl(panel, self._hed.value, "", "TE_PROCESS_ENTER")

	value_sizer:add(value, 2, 0, "ALIGN_CENTER_VERTICAL")
	value:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		ctrlr = value,
		value = "value",
	})
	value:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		ctrlr = value,
		value = "value",
	})

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:realize()
	panel_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	self:_add_help_text("Changes the global state flags")
end

function GlobalStateOperatorElement:update_editing()
	return
end

function GlobalStateOperatorElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function GlobalStateOperatorElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and self._hed.elements then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function GlobalStateOperatorElement:remove_links(unit)
	for _, id in ipairs(self._hed.elements) do
		if id == unit:unit_data().unit_id then
			table.delete(self._hed.elements, id)
		end
	end
end

function GlobalStateOperatorElement:draw_links(t, dt, selected_unit, all_units)
	ApplyJobValueUnitElement.super.draw_links(self, t, dt, selected_unit)

	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				b = 0.25,
				from_unit = self._unit,
				g = 0.85,
				r = 0.85,
				to_unit = unit,
			})
		end
	end
end
