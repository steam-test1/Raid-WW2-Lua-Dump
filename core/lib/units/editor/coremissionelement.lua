CoreMissionElement = CoreMissionElement or class()
MissionElement = MissionElement or class(CoreMissionElement)
MissionElement.SAVE_UNIT_POSITION = true
MissionElement.SAVE_UNIT_ROTATION = true
MissionElement.RANDOMS = nil

function MissionElement:init(...)
	CoreMissionElement.init(self, ...)
end

function CoreMissionElement:init(unit)
	if not CoreMissionElement.editor_link_brush then
		local brush = Draw:brush()

		brush:set_font(Idstring("core/fonts/nice_editor_font"), 10)
		brush:set_render_template(Idstring("OverlayVertexColorTextured"))

		CoreMissionElement.editor_link_brush = brush
	end

	self._unit = unit
	self._hed = self._unit:mission_element_data()
	self._ud = self._unit:unit_data()

	self._unit:anim_play(1)

	self._save_values = {}
	self._update_selected_on = false

	self:_add_default_saves()

	self._parent_panel = managers.editor:mission_element_panel()
	self._parent_sizer = managers.editor:mission_element_sizer()
	self._panels = {}
	self._on_executed_units = {}
	self._arrow_brush = Draw:brush()

	self:_create_icon()
end

function CoreMissionElement:post_init()
	if self.RANDOMS then
		for _, value_name in ipairs(self.RANDOMS) do
			if tonumber(self._hed[value_name]) then
				self._hed[value_name] = {
					self._hed[value_name],
					0,
				}
			end
		end
	end
end

function CoreMissionElement:_create_icon()
	local iconsize = 32

	if Global.iconsize then
		iconsize = Global.iconsize
	end

	if self._icon == nil and self._icon_x == nil then
		return
	end

	local root = self._unit:orientation_object()

	if root == nil then
		return
	end

	if self._iconcolor_type then
		if self._iconcolor_type == "trigger" then
			self._iconcolor = "ff81bffc"
		elseif self._iconcolor_type == "logic" then
			self._iconcolor = "ffffffd9"
		elseif self._iconcolor_type == "operator" then
			self._iconcolor = "fffcbc7c"
		elseif self._iconcolor_type == "filter" then
			self._iconcolor = "ff65ad67"
		end
	end

	if self._iconcolor == nil then
		self._iconcolor = "fff"
	end

	self._iconcolor_c = Color(self._iconcolor)
	self._icon_gui = World:newgui()

	local pos = self._unit:position() - Vector3(iconsize / 2, iconsize / 2, 0)

	self._icon_ws = self._icon_gui:create_linked_workspace(64, 64, root, pos, Vector3(iconsize, 0, 0), Vector3(0, iconsize, 0))

	self._icon_ws:set_billboard(self._icon_ws.BILLBOARD_BOTH)
	self._icon_ws:panel():gui(Idstring("core/guis/core_edit_icon"))

	self._icon_script = self._icon_ws:panel():gui(Idstring("core/guis/core_edit_icon")):script()

	if self._icon then
		self._icon_script:seticon(self._icon, tostring(self._iconcolor))
	elseif self._icon_x then
		self._icon_script:seticon_texture_rect(self._icon_x, self._icon_y, self._icon_w, self._icon_h, tostring(self._iconcolor))
	end
end

function CoreMissionElement:set_icon_size(size)
	if not self._icon_ws then
		return
	end

	local root = self._unit:orientation_object()
	local pos = self._unit:position() - Vector3(size / 2, size / 2, 0)

	self._icon_ws:set_linked(64, 64, root, pos, Vector3(size, 0, 0), Vector3(0, size, 0))
end

function CoreMissionElement:_add_default_saves()
	self._hed.enabled = true
	self._hed.debug = nil
	self._hed.execute_on_startup = false
	self._hed.execute_on_startup_priority = 100
	self._hed.base_delay = 0
	self._hed.base_delay_rand = nil
	self._hed.trigger_times = 0
	self._hed.on_executed = {}

	if self.USES_POINT_ORIENTATION then
		self._hed.orientation_elements = nil
		self._hed.use_orientation_sequenced = nil
		self._hed.disable_orientation_on_use = nil
	end

	if self.USES_INSTIGATOR_RULES then
		self._hed.rules_elements = nil
	end

	if self.INSTANCE_VAR_NAMES then
		self._hed.instance_var_names = nil
	end

	table.insert(self._save_values, "unit:position")
	table.insert(self._save_values, "unit:rotation")
	table.insert(self._save_values, "enabled")
	table.insert(self._save_values, "execute_on_startup")
	table.insert(self._save_values, "execute_on_startup_priority")
	table.insert(self._save_values, "base_delay")
	table.insert(self._save_values, "trigger_times")
	table.insert(self._save_values, "on_executed")
	table.insert(self._save_values, "orientation_elements")
	table.insert(self._save_values, "use_orientation_sequenced")
	table.insert(self._save_values, "disable_orientation_on_use")
	table.insert(self._save_values, "rules_elements")
	table.insert(self._save_values, "instance_var_names")
end

function CoreMissionElement:build_default_gui(panel, sizer)
	self:_build_value_checkbox(panel, sizer, "enabled")
	self:_build_value_checkbox(panel, sizer, "execute_on_startup")
	self:_build_value_number(panel, sizer, "execute_on_startup_priority", {
		floats = 0,
		min = 0,
	}, "Specifies priority if this element is executed on startup (lower number means faster execution)")
	self:_build_value_number(panel, sizer, "trigger_times", {
		floats = 0,
		min = 0,
	}, "Specifies how many time this element can be executed (0 mean unlimited times)")

	local base_delay_sizer = EWS:BoxSizer("HORIZONTAL")

	sizer:add(base_delay_sizer, 0, 0, "EXPAND,LEFT")

	local base_delay_ctrlr = self:_build_value_number(panel, base_delay_sizer, "base_delay", {
		ctrlr_proportions = 1,
		floats = 2,
		min = 0,
		name_proportions = 1,
		sizer_proportions = 2,
	}, "Specifies a base delay that is added to each on executed delay")
	local base_delay_rand_ctrlr = self:_build_value_number(panel, base_delay_sizer, "base_delay_rand", {
		ctrlr_proportions = 1,
		floats = 2,
		min = 0,
		name_proportions = 0,
		sizer_proportions = 1,
	}, "Specifies an additional random time to be added to base delay (delay + rand)", "  random")
	local on_executed_sizer = EWS:StaticBoxSizer(panel, "VERTICAL", "On Executed")
	local element_sizer = EWS:BoxSizer("HORIZONTAL")

	on_executed_sizer:add(element_sizer, 0, 1, "EXPAND,LEFT")

	self._elements_params = {
		ctrlr_proportions = 2,
		name = "Element:",
		name_proportions = 1,
		options = {},
		panel = panel,
		sizer = element_sizer,
		sizer_proportions = 1,
		sorted = true,
		tooltip = "Select an element from the combobox",
	}

	local elements = CoreEWS.combobox(self._elements_params)

	elements:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "on_executed_element_selected"), nil)

	self._add_elements_toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	self._add_elements_toolbar:add_tool("ADD_ELEMENT", "Add an element", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	self._add_elements_toolbar:connect("ADD_ELEMENT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_on_toolbar_add_element"), nil)
	self._add_elements_toolbar:realize()
	element_sizer:add(self._add_elements_toolbar, 0, 1, "EXPAND,LEFT")

	self._elements_toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	self._elements_toolbar:add_tool("DELETE_SELECTED", "Remove selected element", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	self._elements_toolbar:connect("DELETE_SELECTED", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_on_toolbar_remove"), nil)
	self._elements_toolbar:realize()
	element_sizer:add(self._elements_toolbar, 0, 1, "EXPAND,LEFT")

	if not self.ON_EXECUTED_ALTERNATIVES and self._create_dynamic_on_executed_alternatives then
		self:_create_dynamic_on_executed_alternatives()
	end

	if self.ON_EXECUTED_ALTERNATIVES then
		local on_executed_alternatives_params = {
			ctrlr_proportions = 2,
			name = "Alternative:",
			name_proportions = 1,
			options = self.ON_EXECUTED_ALTERNATIVES,
			panel = panel,
			sizer = on_executed_sizer,
			sorted = false,
			tooltip = "Select an alternative on executed from the combobox",
			value = self.ON_EXECUTED_ALTERNATIVES[1],
		}
		local on_executed_alternatives_types = CoreEws.combobox(on_executed_alternatives_params)

		on_executed_alternatives_types:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "on_executed_alternatives_types"), nil)

		self._on_executed_alternatives_params = on_executed_alternatives_params
	end

	local delay_sizer = EWS:BoxSizer("HORIZONTAL")

	on_executed_sizer:add(delay_sizer, 0, 0, "EXPAND,LEFT")

	self._element_delay_params = {
		ctrlr_proportions = 1,
		floats = 2,
		min = 0,
		name = "Delay:",
		name_proportions = 1,
		panel = panel,
		sizer = delay_sizer,
		sizer_proportions = 2,
		tooltip = "Sets the delay time for the selected on executed element",
		value = 0,
	}

	local element_delay = CoreEws.number_controller(self._element_delay_params)

	element_delay:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_executed_element_delay"), nil)
	element_delay:connect("EVT_KILL_FOCUS", callback(self, self, "on_executed_element_delay"), nil)

	self._element_delay_rand_params = {
		ctrlr_proportions = 1,
		floats = 2,
		min = 0,
		name = "  Random:",
		name_proportions = 0,
		panel = panel,
		sizer = delay_sizer,
		sizer_proportions = 1,
		tooltip = "Specifies an additional random time to be added to delay (delay + rand)",
		value = 0,
	}

	local element_delay_rand = CoreEws.number_controller(self._element_delay_rand_params)

	element_delay_rand:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_executed_element_delay_rand"), nil)
	element_delay_rand:connect("EVT_KILL_FOCUS", callback(self, self, "on_executed_element_delay_rand"), nil)
	sizer:add(on_executed_sizer, 0, 0, "EXPAND")

	if self.USES_POINT_ORIENTATION then
		sizer:add(self:_build_point_orientation(panel), 0, 0, "EXPAND")
	end

	if self.INSTANCE_VAR_NAMES then
		sizer:add(self:_build_instance_var_names(panel), 0, 0, "EXPAND")
	end

	sizer:add(EWS:StaticLine(panel, "", "LI_HORIZONTAL"), 0, 5, "EXPAND,TOP,BOTTOM")
	self:append_elements_sorted()
	self:set_on_executed_element()

	local function refresh_list_flow_cbk(ctrlr)
		local function f()
			managers.editor:refresh_list_flow()
		end

		ctrlr:connect("EVT_COMMAND_TEXT_ENTER", f, nil)
		ctrlr:connect("EVT_KILL_FOCUS", f, nil)
	end

	refresh_list_flow_cbk(base_delay_ctrlr)
	refresh_list_flow_cbk(base_delay_rand_ctrlr)
	refresh_list_flow_cbk(element_delay)
	refresh_list_flow_cbk(element_delay_rand)
end

function CoreMissionElement:_build_point_orientation(panel)
	local sizer = EWS:StaticBoxSizer(panel, "HORIZONTAL", "Point orientation")
	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_ELEMENT", "Add an element", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_ELEMENT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_add_unit_to_orientation_elements"), nil)
	toolbar:add_tool("DELETE_ELEMENT", "Remove selected element", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("DELETE_ELEMENT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_remove_unit_from_orientation_elements"), nil)
	toolbar:realize()
	sizer:add(toolbar, 0, 1, "EXPAND,LEFT")

	local use_orientation_sequenced = EWS:CheckBox(panel, "Use sequenced", "")

	use_orientation_sequenced:set_value(self._hed.use_orientation_sequenced)
	use_orientation_sequenced:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = use_orientation_sequenced,
		value = "use_orientation_sequenced",
	})
	sizer:add(use_orientation_sequenced, 0, 4, "EXPAND,LEFT")

	local disable_orientation_on_use = EWS:CheckBox(panel, "Disable on use", "")

	disable_orientation_on_use:set_value(self._hed.disable_orientation_on_use)
	disable_orientation_on_use:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = disable_orientation_on_use,
		value = "disable_orientation_on_use",
	})
	sizer:add(disable_orientation_on_use, 0, 4, "EXPAND,LEFT")

	return sizer
end

function CoreMissionElement:_add_unit_to_orientation_elements()
	local script = self._unit:mission_element_data().script

	local function f(unit)
		if not string.find(unit:name():s(), "point_orientation", 1, true) then
			return
		end

		if not alive(unit) or not unit:mission_element_data() or unit:mission_element_data().script ~= script then
			return
		end

		local id = unit:unit_data().unit_id

		if self._hed.orientation_elements and table.contains(self._hed.orientation_elements, id) then
			return false
		end

		return managers.editor:layer("Mission"):category_map()[unit:type():s()]
	end

	local dialog = SelectUnitByNameModal:new("Add Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		self:_add_orientation_unit_id(unit:unit_data().unit_id)
	end
end

function CoreMissionElement:_remove_unit_from_orientation_elements()
	if not self._hed.orientation_elements then
		return
	end

	local function f(unit)
		return table.contains(self._hed.orientation_elements, unit:unit_data().unit_id)
	end

	local dialog = SelectUnitByNameModal:new("Remove Unit", f)

	if dialog:cancelled() then
		return
	end

	for _, unit in ipairs(dialog:selected_units()) do
		self:_remove_orientation_unit_id(unit:unit_data().unit_id)
	end
end

function CoreMissionElement:_build_instance_var_names(panel)
	local sizer = EWS:StaticBoxSizer(panel, "VERTICAL", "Instance variables")
	local options = {}
	local func_instance_params_units = managers.editor:layer("Mission"):get_created_unit_by_pattern({
		"func_instance_params",
	})

	for _, unit in ipairs(func_instance_params_units) do
		for _, param in ipairs(unit:mission_element_data().params) do
			options[param.type] = options[param.type] or {}

			table.insert(options[param.type], param.var_name)
		end
	end

	for _, data in ipairs(self.INSTANCE_VAR_NAMES) do
		local params = {
			ctrlr_proportions = 2,
			default = "not_used",
			name = string.pretty(data.value, true) .. ":",
			name_proportions = 1,
			options = options[data.type] or {},
			panel = panel,
			sizer = sizer,
			sizer_proportions = 1,
			sorted = true,
			tooltip = "Select a value",
			value = self._hed.instance_var_names and self._hed.instance_var_names[data.value] or "not_used",
		}
		local ctrlr = CoreEws.combobox(params)

		ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_set_instance_var_name"), {
			ctrlr = ctrlr,
			data = data,
		})
	end

	return sizer
end

function CoreMissionElement:_set_instance_var_name(params)
	local value = params.ctrlr:get_value()

	value = value ~= "not_used" and value or nil
	self._hed.instance_var_names = self._hed.instance_var_names or {}
	self._hed.instance_var_names[params.data.value] = value
	self._hed.instance_var_names = next(self._hed.instance_var_names) and self._hed.instance_var_names or nil
end

function CoreMissionElement:_create_panel()
	if self._panel then
		return
	end

	self._panel, self._panel_sizer = self:_add_panel(self._parent_panel, self._parent_sizer)
end

function CoreMissionElement:_build_panel()
	self:_create_panel()
end

function CoreMissionElement:panel(id, parent, parent_sizer)
	if id then
		if self._panels[id] then
			return self._panels[id]
		end

		local panel, panel_sizer = self:_add_panel(parent, parent_sizer)

		self:_build_panel(panel, panel_sizer)

		self._panels[id] = panel

		return self._panels[id]
	end

	if not self._panel then
		self:_build_panel()
	end

	return self._panel
end

function CoreMissionElement:_add_panel(parent, parent_sizer)
	local panel = EWS:ScrolledWindow(parent, "", "VSCROLL,TAB_TRAVERSAL")

	panel:set_scroll_rate(Vector3(1, 20, 0))
	panel:set_virtual_size_hints(Vector3(0, 0, 0), Vector3(1, -1, -1))

	local panel_sizer = EWS:BoxSizer("VERTICAL")

	panel:set_sizer(panel_sizer)
	parent_sizer:add(panel, 1, 0, "EXPAND")
	panel:set_visible(false)
	panel:set_extension({
		alive = true,
	})
	self:build_default_gui(panel, panel_sizer)

	return panel, panel_sizer
end

function CoreMissionElement:add_help_text(data)
	if data.panel and data.sizer then
		data.sizer:add(EWS:TextCtrl(data.panel, data.text, 0, "TE_MULTILINE,TE_READONLY,TE_WORDWRAP,TE_CENTRE"), 0, 5, "EXPAND,TOP,BOTTOM")
	end
end

function CoreMissionElement:_add_help_text(text)
	self:add_help_text({
		panel = self._panel,
		sizer = self._panel_sizer,
		text = text,
	})
end

function CoreMissionElement:_on_toolbar_add_element()
	local function f(unit)
		if unit:type() == Idstring("mission_element") and unit ~= self._unit and managers.editor:current_continent() and unit:unit_data().continent and managers.editor:current_continent() == unit:unit_data().continent then
			return true
		end

		return false
	end

	local dialog = SelectUnitByNameModal:new("Add/Remove element", f)

	for _, unit in ipairs(dialog:selected_units()) do
		self:add_on_executed(unit)
	end
end

function CoreMissionElement:_on_toolbar_remove()
	self:remove_on_execute(self:_current_element_unit())
end

function CoreMissionElement:set_element_data(data)
	if data.callback then
		local he = self._unit:mission_element()

		he[data.callback](he, data.ctrlr, data.params)
	end

	if data.value then
		self._hed[data.value] = data.ctrlr:get_value()
		self._hed[data.value] = tonumber(self._hed[data.value]) or self._hed[data.value]

		if data.value == "base_delay_rand" then
			self._hed[data.value] = self._hed[data.value] > 0 and self._hed[data.value] or nil
		end

		if EWS:get_key_state("K_CONTROL") then
			local value = tonumber(self._hed[data.value]) or self._hed[data.value]

			for _, unit in ipairs(managers.editor:layer("Mission"):selected_units()) do
				if unit ~= self._unit and unit:mission_element_data() then
					unit:mission_element_data()[data.value] = value

					unit:mission_element():set_panel_dirty()
				end
			end
		end
	end
end

function CoreMissionElement:set_panel_dirty()
	if not alive(self._panel) then
		return
	end

	self._panel:destroy()

	self._panel = nil
end

function CoreMissionElement:selected()
	self:append_elements_sorted()
end

function CoreMissionElement:on_unselected()
	return
end

function CoreMissionElement:update_selected()
	return
end

function CoreMissionElement:update_unselected()
	return
end

function CoreMissionElement:can_edit()
	return self.update_editing
end

function CoreMissionElement:begin_editing()
	return
end

function CoreMissionElement:end_editing()
	return
end

function CoreMissionElement:clone_data(all_units)
	for _, data in ipairs(self._hed.on_executed) do
		table.insert(self._on_executed_units, all_units[data.id])
	end
end

function CoreMissionElement:layer_finished()
	for _, data in ipairs(self._hed.on_executed) do
		local unit = managers.worlddefinition:get_mission_element_unit(data.id)

		table.insert(self._on_executed_units, unit)
	end
end

function CoreMissionElement:save_data(file, t)
	self:save_values(file, t)
end

function CoreMissionElement:save_values(file, t)
	t = t .. "\t"

	file:puts(t .. "<values>")

	for _, name in ipairs(self._save_values) do
		self:save_value(file, t, name)
	end

	file:puts(t .. "</values>")
end

function CoreMissionElement:save_value(file, t, name)
	t = t .. "\t"

	file:puts(save_value_string(self._hed, name, t, self._unit))
end

function CoreMissionElement:new_save_values()
	local t = {
		position = self.SAVE_UNIT_POSITION and self._unit:position() or nil,
		rotation = self.SAVE_UNIT_ROTATION and self._unit:rotation() or nil,
	}

	for _, value in ipairs(self._save_values) do
		t[value] = self._hed[value]
	end

	t.base_delay_rand = self._hed.base_delay_rand and self._hed.base_delay_rand > 0 and self._hed.base_delay_rand or nil

	if self.save then
		self:save(t)
	end

	if self.RANDOMS then
		for _, value_name in ipairs(self.RANDOMS) do
			if t[value_name][2] == 0 then
				t[value_name] = t[value_name][1]
			end
		end
	end

	return t
end

function CoreMissionElement:name()
	return self._unit:name() .. self._ud.unit_id
end

function CoreMissionElement:add_to_mission_package()
	return
end

function CoreMissionElement:get_color(type)
	if type then
		if type == "activate" or type == "enable" then
			return 0, 1, 0
		elseif type == "deactivate" or type == "disable" then
			return 1, 0, 0
		end
	end

	return 0, 1, 0
end

function CoreMissionElement:draw_links_selected(t, dt, selected_unit)
	local unit = self:_current_element_unit()

	if alive(unit) then
		local r, g, b = 1, 1, 1

		if self._iconcolor and managers.editor:layer("Mission"):use_colored_links() then
			r = self._iconcolor_c.r
			g = self._iconcolor_c.g
			b = self._iconcolor_c.b
		end

		if unit and self._unit and self:_should_draw_link(unit, self._unit) then
			self:_draw_link({
				b = b,
				from_unit = self._unit,
				g = g,
				r = r,
				thick = true,
				to_unit = unit,
			})
		end
	end
end

function CoreMissionElement:_draw_link(params)
	params.draw_flow = managers.editor:layer("Mission"):visualize_flow()

	Application:draw_link(params)
end

function CoreMissionElement:draw_links_unselected()
	return
end

function CoreMissionElement:clear()
	return
end

function CoreMissionElement:action_types()
	return self._action_types
end

function CoreMissionElement:timeline_color()
	return self._timeline_color
end

function CoreMissionElement:add_triggers(vc)
	return
end

function CoreMissionElement:base_add_triggers(vc)
	if self.USES_POINT_ORIENTATION then
		vc:add_trigger(Idstring("lmb"), callback(self, self, "_on_use_point_orientation"))
	end

	if self.USES_INSTIGATOR_RULES then
		vc:add_trigger(Idstring("lmb"), callback(self, self, "_on_use_instigator_rule"))
	end
end

function CoreMissionElement:_on_use_point_orientation()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and string.find(ray.unit:name():s(), "point_orientation", 1, true) then
		local id = ray.unit:unit_data().unit_id

		if self._hed.orientation_elements and table.contains(self._hed.orientation_elements, id) then
			self:_remove_orientation_unit_id(id)
		else
			self:_add_orientation_unit_id(id)
		end
	end
end

function CoreMissionElement:_add_orientation_unit_id(id)
	self._hed.orientation_elements = self._hed.orientation_elements or {}

	table.insert(self._hed.orientation_elements, id)
end

function CoreMissionElement:_remove_orientation_unit_id(id)
	table.delete(self._hed.orientation_elements, id)

	self._hed.orientation_elements = #self._hed.orientation_elements > 0 and self._hed.orientation_elements or nil
end

function CoreMissionElement:_on_use_instigator_rule()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and string.find(ray.unit:name():s(), "data_instigator_rule", 1, true) then
		local id = ray.unit:unit_data().unit_id

		if self._hed.rules_elements and table.contains(self._hed.rules_elements, id) then
			self:_remove_instigator_rule_unit_id(id)
		else
			self:_add_instigator_rule_unit_id(id)
		end
	end
end

function CoreMissionElement:_add_instigator_rule_unit_id(id)
	self._hed.rules_elements = self._hed.rules_elements or {}

	table.insert(self._hed.rules_elements, id)
end

function CoreMissionElement:_remove_instigator_rule_unit_id(id)
	table.delete(self._hed.rules_elements, id)

	self._hed.rules_elements = #self._hed.rules_elements > 0 and self._hed.rules_elements or nil
end

function CoreMissionElement:clear_triggers()
	return
end

function CoreMissionElement:widget_affect_object()
	return nil
end

function CoreMissionElement:use_widget_position()
	return nil
end

function CoreMissionElement:set_enabled()
	if self._icon_ws then
		self._icon_ws:show()
	end
end

function CoreMissionElement:set_disabled()
	if self._icon_ws then
		self._icon_ws:hide()
	end
end

function CoreMissionElement:on_set_visible(visible)
	if self._icon_ws then
		if visible then
			self._icon_ws:show()
		else
			self._icon_ws:hide()
		end
	end
end

function CoreMissionElement:set_update_selected_on(value)
	self._update_selected_on = value
end

function CoreMissionElement:update_selected_on()
	return self._update_selected_on
end

function CoreMissionElement:destroy_panel()
	if self._panel then
		self._panel:extension().alive = false

		self._panel:destroy()

		self._panel = nil
	end
end

function CoreMissionElement:destroy()
	if self._timeline then
		self._timeline:destroy()
	end

	if self._panel then
		self._panel:extension().alive = false

		self._panel:destroy()
	end

	if self._icon_ws and alive(self._icon_gui) and alive(self._icon_ws) then
		self._icon_gui:destroy_workspace(self._icon_ws)

		self._icon_ws = nil
	end

	if self.stop_test_element then
		self:stop_test_element()
	end
end

function CoreMissionElement:draw_links(t, dt, selected_unit, all_units)
	self:_base_check_removed_units(all_units)
	self:draw_link_on_executed(t, dt, selected_unit)
	self:_draw_elements(t, dt, self._hed.orientation_elements, selected_unit, all_units)
	self:_draw_elements(t, dt, self._hed.rules_elements, selected_unit, all_units)
end

function CoreMissionElement:_base_check_removed_units(all_units)
	if self._hed.orientation_elements then
		for _, id in ipairs(clone(self._hed.orientation_elements)) do
			local unit = all_units[id]

			if not alive(unit) then
				self:_remove_orientation_unit_id(id)
			end
		end
	end

	if self._hed.rules_elements then
		for _, id in ipairs(clone(self._hed.rules_elements)) do
			local unit = all_units[id]

			if not alive(unit) then
				self:_remove_instigator_rule_unit_id(id)
			end
		end
	end
end

function CoreMissionElement:_draw_elements(t, dt, elements, selected_unit, all_units)
	if not elements then
		return
	end

	for _, id in ipairs(elements) do
		local unit = all_units[id]

		if selected_unit and self._unit and self:_should_draw_link(selected_unit, unit) then
			local r, g, b = unit:mission_element():get_link_color()

			self:_draw_link({
				b = b,
				from_unit = unit,
				g = g,
				r = r,
				to_unit = self._unit,
			})
		end
	end
end

function CoreMissionElement:_should_draw_link(selected_unit, unit)
	return not selected_unit or unit == selected_unit or self._unit == selected_unit
end

function CoreMissionElement:get_link_color(unit)
	local r, g, b = 1, 1, 1

	if self._iconcolor and managers.editor:layer("Mission"):use_colored_links() then
		r = self._iconcolor_c.r
		g = self._iconcolor_c.g
		b = self._iconcolor_c.b
	end

	return r, g, b
end

function CoreMissionElement:draw_link_on_executed(t, dt, selected_unit)
	local unit_sel = self._unit == selected_unit

	CoreMissionElement.editor_link_brush:set_color(unit_sel and Color.green or Color.white)

	for _, unit in ipairs(self._on_executed_units) do
		if not selected_unit or unit_sel or unit == selected_unit then
			local dir = mvector3.copy(unit:position())

			mvector3.subtract(dir, self._unit:position())

			local vec_len = mvector3.normalize(dir)
			local offset = math.min(50, vec_len)

			mvector3.multiply(dir, offset)

			if self._distance_to_camera < 1000000 then
				local element = self:_get_on_executed(unit:unit_data().unit_id)
				local text = self:_get_delay_string(element)
				local alternative = element.alternative

				if alternative then
					text = text .. " - " .. alternative .. ""
				end

				CoreMissionElement.editor_link_brush:center_text(self._unit:position() + dir, text, managers.editor:camera_rotation():x(), -managers.editor:camera_rotation():z())
			end

			local r, g, b = self:get_link_color()

			self:_draw_link({
				b = b * 0.75,
				from_unit = self._unit,
				g = g * 0.75,
				r = r * 0.75,
				to_unit = unit,
			})
		end
	end
end

function CoreMissionElement:_get_delay_string(element)
	local delay = self._hed.base_delay + element.delay
	local text = string.format("%.2f", delay)

	if self._hed.base_delay_rand or element.delay_rand then
		local delay_max = delay + (element.delay_rand or 0)

		delay_max = delay_max + (self._hed.base_delay_rand and self._hed.base_delay_rand or 0)
		text = text .. "-" .. string.format("%.2f", delay_max) .. ""
	end

	return text
end

function CoreMissionElement:add_on_executed(unit)
	if self:remove_on_execute(unit) then
		return
	end

	local params = {
		alternative = self.ON_EXECUTED_ALTERNATIVES and self.ON_EXECUTED_ALTERNATIVES[1],
		delay = 0,
		id = unit:unit_data().unit_id,
	}

	table.insert(self._on_executed_units, unit)
	table.insert(self._hed.on_executed, params)

	if self._timeline then
		self._timeline:add_element(unit, params)
	end

	self:append_elements_sorted()
	self:set_on_executed_element(unit)
end

function CoreMissionElement:remove_links(unit)
	return
end

function CoreMissionElement:remove_on_execute(unit)
	for _, on_executed in ipairs(self._hed.on_executed) do
		if on_executed.id == unit:unit_data().unit_id then
			if self._timeline then
				self._timeline:remove_element(on_executed)
			end

			table.delete(self._hed.on_executed, on_executed)
			table.delete(self._on_executed_units, unit)
			self:append_elements_sorted()

			return true
		end
	end

	return false
end

function CoreMissionElement:delete_unit(units)
	for _, unit in ipairs(units) do
		if alive(unit) then
			unit:mission_element():remove_on_execute(self._unit)
			unit:mission_element():remove_links(self._unit)
		end
	end
end

function CoreMissionElement:set_on_executed_element(unit, id)
	unit = unit or self:on_execute_unit_by_id(id)

	if not alive(unit) then
		self:_set_on_execute_ctrlrs_enabled(false)
		self:_set_first_executed_element()

		return
	end

	self:_set_on_execute_ctrlrs_enabled(true)

	if self._elements_params then
		local name = self:combobox_name(unit)

		CoreEWS.change_combobox_value(self._elements_params, name)
		self:set_on_executed_data()
	end
end

function CoreMissionElement:set_on_executed_data()
	local id = self:combobox_id(self._elements_params.value)
	local params = self:_get_on_executed(id)

	CoreEWS.change_entered_number(self._element_delay_params, params.delay)
	CoreEWS.change_entered_number(self._element_delay_rand_params, params.delay_rand or 0)

	if self._on_executed_alternatives_params then
		CoreEWS.change_combobox_value(self._on_executed_alternatives_params, params.alternative)
	end

	if self._timeline then
		self._timeline:select_element(params)
	end
end

function CoreMissionElement:_set_first_executed_element()
	if #self._hed.on_executed > 0 then
		self:set_on_executed_element(nil, self._hed.on_executed[1].id)
	end
end

function CoreMissionElement:_set_on_execute_ctrlrs_enabled(enabled)
	if not self._elements_params then
		return
	end

	self._elements_params.ctrlr:set_enabled(enabled)
	self._element_delay_params.number_ctrlr:set_enabled(enabled)
	self._element_delay_rand_params.number_ctrlr:set_enabled(enabled)
	self._elements_toolbar:set_enabled(enabled)

	if self._on_executed_alternatives_params then
		self._on_executed_alternatives_params.ctrlr:set_enabled(enabled)
	end
end

function CoreMissionElement:on_executed_element_selected()
	self:set_on_executed_data()
end

function CoreMissionElement:_get_on_executed(id)
	for _, params in ipairs(self._hed.on_executed) do
		if params.id == id then
			return params
		end
	end
end

function CoreMissionElement:_current_element_id()
	if not self._elements_params or not self._elements_params.value then
		return nil
	end

	return self:combobox_id(self._elements_params.value)
end

function CoreMissionElement:_current_element_unit()
	local id = self:_current_element_id()

	if not id then
		return nil
	end

	local unit = self:on_execute_unit_by_id(id)

	if not alive(unit) then
		return nil
	end

	return unit
end

function CoreMissionElement:on_executed_element_delay()
	local id = self:combobox_id(self._elements_params.value)
	local params = self:_get_on_executed(id)

	if params then
		params.delay = self._element_delay_params.value

		if self._timeline then
			self._timeline:delay_updated(params)
		end
	end
end

function CoreMissionElement:on_executed_element_delay_rand()
	local id = self:combobox_id(self._elements_params.value)
	local params = self:_get_on_executed(id)

	if params then
		params.delay_rand = self._element_delay_rand_params.value > 0 and self._element_delay_rand_params.value or nil
	end
end

function CoreMissionElement:on_executed_alternatives_types()
	local id = self:combobox_id(self._elements_params.value)
	local params = self:_get_on_executed(id)

	print("self._on_executed_alternatives_params.value", self._on_executed_alternatives_params.value)

	params.alternative = self._on_executed_alternatives_params.value
end

function CoreMissionElement:append_elements_sorted()
	if not self._elements_params then
		return
	end

	local id = self:_current_element_id()

	CoreEWS.update_combobox_options(self._elements_params, self:_combobox_names_names(self._on_executed_units))
	self:set_on_executed_element(nil, id)
end

function CoreMissionElement:combobox_name(unit)
	return unit:unit_data().name_id .. " (" .. unit:unit_data().unit_id .. ")"
end

function CoreMissionElement:combobox_id(name)
	local s
	local e = string.len(name) - 1

	for i = string.len(name), 0, -1 do
		local t = string.sub(name, i, i)

		if t == "(" then
			s = i + 1

			break
		end
	end

	return tonumber(string.sub(name, s, e))
end

function CoreMissionElement:on_execute_unit_by_id(id)
	for _, unit in ipairs(self._on_executed_units) do
		if unit:unit_data().unit_id == id then
			return unit
		end
	end

	return nil
end

function CoreMissionElement:_combobox_names_names(units)
	local names = {}

	for _, unit in ipairs(units) do
		if alive(unit) then
			table.insert(names, self:combobox_name(unit))
		end
	end

	return names
end

function CoreMissionElement:on_timeline()
	if not self._timeline then
		self._timeline = MissionElementTimeline:new(self._unit:unit_data().name_id)

		self._timeline:set_mission_unit(self._unit)
	else
		self._timeline:set_visible(true)
	end
end

function CoreMissionElement:_build_value_combobox(panel, sizer, value_name, options, tooltip, custom_name, params)
	local horizontal_sizer = EWS:BoxSizer("HORIZONTAL")

	sizer:add(horizontal_sizer, params and params.horizontal_sizer_proportions or 0, 1, "EXPAND,LEFT")

	local combobox_params = {
		ctrlr_proportions = 2,
		name = string.pretty(custom_name or value_name, true) .. ":",
		name_proportions = 1,
		options = options,
		panel = panel,
		sizer = horizontal_sizer,
		sizer_proportions = 1,
		sorted = false,
		tooltip = tooltip or "Select an option from the combobox",
		value = self._hed[value_name],
	}
	local ctrlr = CoreEws.combobox(combobox_params)

	ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "set_element_data"), {
		ctrlr = ctrlr,
		value = value_name,
	})

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("SELECT_NAME_LIST", "Select from list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("SELECT_NAME_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_on_gui_value_combobox_toolbar_select_dialog"), {
		combobox_params = combobox_params,
		value_name = value_name,
	})
	toolbar:realize()
	horizontal_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")

	return ctrlr, combobox_params
end

function CoreMissionElement:_on_gui_value_combobox_toolbar_select_dialog(params)
	local dialog = SelectNameModal:new("Select name", params.combobox_params.options)

	if dialog:cancelled() then
		return
	end

	for _, name in ipairs(dialog:_selected_item_assets()) do
		CoreEws.change_combobox_value(params.combobox_params, name)
		self:set_element_data({
			ctrlr = params.combobox_params.ctrlr,
			value = params.value_name,
		})
	end
end

function CoreMissionElement:_build_value_number(panel, sizer, value_name, options, tooltip, custom_name)
	local number_params = {
		ctrlr_proportions = options.ctrlr_proportions or 2,
		floats = options.floats,
		max = options.max,
		min = options.min,
		name = string.pretty(custom_name or value_name, true) .. ":",
		name_proportions = options.name_proportions or 1,
		panel = panel,
		sizer = sizer,
		sizer_proportions = options.sizer_proportions,
		tooltip = tooltip or "Set a number value",
		value = self._hed[value_name],
	}
	local ctrlr = CoreEws.number_controller(number_params)

	ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		ctrlr = ctrlr,
		value = value_name,
	})
	ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		ctrlr = ctrlr,
		value = value_name,
	})

	return ctrlr, number_params
end

function CoreMissionElement:_build_value_checkbox(panel, sizer, value_name, tooltip, custom_name)
	local checkbox = EWS:CheckBox(panel, custom_name or string.pretty(value_name, true), "")

	checkbox:set_value(self._hed[value_name])
	checkbox:set_tool_tip(tooltip or "Click to toggle")
	checkbox:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		ctrlr = checkbox,
		value = value_name,
	})
	sizer:add(checkbox, 0, 0, "EXPAND")

	return checkbox
end

function CoreMissionElement:_open_color_picker(panel, color_ctrlr)
	self.__color_picker_dialog = self.__color_picker_dialog or CoreColorPickerDialog.ColorPickerDialog:new(panel, true, "HORIZONTAL", true)

	self.__color_picker_dialog._window:set_focus()
	self.__color_picker_dialog:connect("EVT_CLOSE_WINDOW", function()
		self.__color_picker_dialog = nil
	end)
	self.__color_picker_dialog:connect("EVT_COLOR_UPDATED", callback(self, self, "_on_color_changed"), "")

	local editor_window = self._parent_panel:parent():parent():parent():parent():parent():parent()
	local distance = Vector3(editor_window:get_size().x * 0.85, editor_window:get_size().y * 0.6, editor_window:get_size().z)

	self.__color_picker_dialog:set_position(editor_window:get_position() + distance)
	self.__color_picker_dialog:set_visible(true)
end

function CoreMissionElement:_build_value_color(panel, sizer, value_name, tooltip, custom_name)
	local horizontal_sizer = EWS:BoxSizer("HORIZONTAL")

	sizer:add(horizontal_sizer, 0, 0, "EXPAND,ALIGN_RIGHT")

	local text_ctrlr = EWS:StaticText(panel, custom_name or string.pretty(value_name, true) .. ": ")

	text_ctrlr:set_tool_tip(tooltip or "Click to select a color")
	horizontal_sizer:add(text_ctrlr, 0, 158 - text_ctrlr:get_size().x, "ALIGN_LEFT,ALIGN_CENTER_VERTICAL,RIGHT")

	local color_ctrlr = EWS:Button(panel, "", "", "BU_RIGHT")

	color_ctrlr:set_background_colour(0, 255, 0)
	color_ctrlr:set_tool_tip(tooltip or "Click to select a color")
	color_ctrlr:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_open_color_picker"), {
		color_ctrlr = color_ctrlr,
		panel = panel,
	})
	horizontal_sizer:add(color_ctrlr, 1, 0, "RIGHT")

	return text_ctrlr, color_ctrlr
end

function CoreMissionElement:_build_value_random_number(panel, sizer, value_name, options, tooltip, custom_name)
	local horizontal_sizer = EWS:BoxSizer("HORIZONTAL")

	sizer:add(horizontal_sizer, 0, 0, "EXPAND,LEFT")

	local number_params = {
		ctrlr_proportions = options.ctrlr_proportions or 2,
		floats = options.floats,
		max = options.max,
		min = options.min,
		name = string.pretty(custom_name or value_name, true) .. ":",
		name_proportions = options.name_proportions or 2,
		panel = panel,
		sizer = horizontal_sizer,
		sizer_proportions = options.sizer_proportions or 2,
		tooltip = tooltip or "Set a number value",
		value = self._hed[value_name][1],
	}
	local ctrlr = CoreEws.number_controller(number_params)

	ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_random_number_element_data"), {
		ctrlr = ctrlr,
		index = 1,
		value = value_name,
	})
	ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "_set_random_number_element_data"), {
		ctrlr = ctrlr,
		index = 1,
		value = value_name,
	})

	local number2_params = {
		ctrlr_proportions = options.ctrlr_proportions or 2,
		floats = options.floats,
		max = options.max,
		min = options.min,
		name = "+ random:",
		name_proportions = options.name_proportions or 1,
		panel = panel,
		sizer = horizontal_sizer,
		sizer_proportions = options.sizer_proportions or 1,
		tooltip = "Add a random amount",
		value = self._hed[value_name][2],
	}
	local ctrlr2 = CoreEws.number_controller(number2_params)

	ctrlr2:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_random_number_element_data"), {
		ctrlr = ctrlr2,
		index = 2,
		value = value_name,
	})
	ctrlr2:connect("EVT_KILL_FOCUS", callback(self, self, "_set_random_number_element_data"), {
		ctrlr = ctrlr2,
		index = 2,
		value = value_name,
	})

	return ctrlr, number_params
end

function CoreMissionElement:_set_random_number_element_data(data)
	print("_set_random_number_element_data", inspect(data))

	local value = data.ctrlr:get_value()

	value = tonumber(value)

	print("data.ctrlr:get_value()", value, type(value))
	print("self._hed[ data.value ]", inspect(self._hed[data.value]))

	self._hed[data.value][data.index] = value
end

function CoreMissionElement:_build_add_remove_unit_from_list(panel, sizer, elements, names, exact_names)
	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_UNIT_LIST", "Add unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_add_unit_list_btn"), {
		elements = elements,
		exact_names = exact_names,
		names = names,
	})
	toolbar:add_tool("REMOVE_UNIT_LIST", "Remove unit from unit list", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("REMOVE_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_remove_unit_list_btn"), {
		elements = elements,
	})
	toolbar:realize()
	sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
end

function CoreMissionElement:_add_unit_list_btn(params)
	local elements = params.elements or {}
	local script = self._unit:mission_element_data().script

	local function f_correct_unit(unit)
		if not params.names and not params.exact_names then
			return true
		end

		local u_name = unit:name():s()

		if params.exact_names then
			for _, name in ipairs(params.exact_names) do
				if u_name == name then
					return true
				end
			end
		end

		if params.names then
			for _, name in ipairs(params.names) do
				if string.find(u_name, name, 1, true) then
					return true
				end
			end
		end

		return false
	end

	local function f(unit)
		if not alive(unit) or not unit:mission_element_data() or unit:mission_element_data().script ~= script then
			return
		end

		local id = unit:unit_data().unit_id

		if table.contains(elements, id) then
			return false
		end

		if f_correct_unit(unit) then
			return true
		end

		return false
	end

	local dialog = SelectUnitByNameModal:new("Add Units", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		table.insert(elements, id)
	end
end

function CoreMissionElement:_remove_unit_list_btn(params)
	local elements = params.elements

	local function f(unit)
		return table.contains(elements, unit:unit_data().unit_id)
	end

	local dialog = SelectUnitByNameModal:new("Remove Units", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		table.delete(elements, id)
	end
end

function CoreMissionElement:_build_add_remove_static_unit_from_list(panel, sizer, params)
	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_UNIT_LIST", "Add units from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_add_static_unit_list_btn"), params)
	toolbar:add_tool("REMOVE_UNIT_LIST", "Remove units from unit list", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("REMOVE_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_remove_static_unit_list_btn"), params)
	toolbar:realize()
	sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
end

function CoreMissionElement:_add_static_unit_list_btn(params)
	local dialog = (params.single and SingleSelectUnitByNameModal or SelectUnitByNameModal):new("Add Static Units", params.add_filter)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		params.add_result(unit)
	end
end

function CoreMissionElement:_remove_static_unit_list_btn(params)
	local dialog = (params.single and SingleSelectUnitByNameModal or SelectUnitByNameModal):new("Remove Static Units", params.remove_filter)

	for _, unit in ipairs(dialog:selected_units()) do
		params.remove_result(unit)
	end
end

function CoreMissionElement:get_links_to_unit(to_unit, links, all_units)
	for i, data in ipairs(self._hed.on_executed) do
		local link = {
			alternative = data.alternative,
			delay = self:_get_delay_string(data),
			index = i,
			type = "on_executed",
		}

		self:_add_links_to_element(data.id, link, to_unit, links.on_executed, links.executers, all_units)
	end

	if self.USES_POINT_ORIENTATION and self._hed.orientation_elements then
		local params = {
			table_value = "orientation_elements",
			type = "orientation",
		}

		self:_get_links_from_value(self._hed.orientation_elements, params, to_unit, links, all_units)
	end

	if self.LINK_VALUES then
		for _, params in ipairs(self.LINK_VALUES) do
			local value = self._hed[params.table_value or params.value]

			if value then
				self:_get_links_from_value(value, params, to_unit, links, all_units)
			end
		end
	end
end

function CoreMissionElement:_get_links_from_value(value, params, to_unit, links, all_units)
	if not value then
		return
	end

	local type = params.type or params.table_value or params.value
	local links1 = params.output and links.on_executed or links.executers
	local links2 = params.output and links.executers or links.on_executed
	local layer = params.layer and managers.editor:layer(params.layer)

	all_units = layer and layer:created_units_pairs() or all_units

	if params.table_value then
		for i, element in ipairs(value) do
			local id = params.table_key and element[params.table_key] or element
			local link = {
				index = i,
				layer = params.layer,
				type = type,
			}

			self:_add_links_to_element(id, link, to_unit, links1, links2, all_units)
		end
	elseif params.value then
		local link = {
			layer = params.layer,
			type = type,
		}

		self:_add_links_to_element(value, link, to_unit, links1, links2, all_units)
	end
end

function CoreMissionElement:_add_links_to_element(id, link, to_unit, links1, links2, all_units)
	if type(to_unit) == "table" then
		link.id = to_unit.id
	else
		link.id = to_unit:unit_data().unit_id or 0
	end

	if to_unit == self._unit then
		if link.layer == "Instances" then
			link.instance = id
		else
			link.unit = all_units[id]
		end

		table.insert(links1, link)
	elseif id == link.id then
		link.unit = self._unit

		table.insert(links2, link)
	end
end
