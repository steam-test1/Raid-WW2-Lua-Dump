WorldOperatorUnitElement = WorldOperatorUnitElement or class(MissionElement)
WorldOperatorUnitElement.ACTIONS = {
	"spawn",
	"spawn_alarmed",
	"despawn",
	"enable_plant_loot",
	"enable_alarm_state",
	"disable_alarm_state",
	"set_world_id",
}

function WorldOperatorUnitElement:init(unit)
	WorldOperatorUnitElement.super.init(self, unit)

	self._hed.operation = "spawn"
	self._hed.world = ""
	self._hed.elements = {}

	table.insert(self._save_values, "use_instigator")
	table.insert(self._save_values, "operation")
	table.insert(self._save_values, "operation_world_id")
	table.insert(self._save_values, "elements")

	self._actions = WorldOperatorUnitElement.ACTIONS
end

function WorldOperatorUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function WorldOperatorUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function WorldOperatorUnitElement:update_editing()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit then
		local sequences = managers.sequence:get_sequence_list(ray.unit:name())

		if #sequences > 0 then
			Application:draw(ray.unit, 0, 1, 0)
		end
	end
end

function WorldOperatorUnitElement:draw_links_unselected(...)
	WorldOperatorUnitElement.super.draw_links_unselected(self, ...)

	for _, id in ipairs(self._hed.elements) do
		local unit = managers.editor:unit_with_id(id)

		if alive(unit) then
			local params = {
				b = 0.5,
				from_unit = unit,
				g = 0,
				r = 0,
				to_unit = self._unit,
			}

			self:_draw_link(params)
			Application:draw(unit, 0, 0, 0.5)
		end
	end
end

function WorldOperatorUnitElement:draw_links_selected(...)
	WorldOperatorUnitElement.super.draw_links_selected(self, ...)

	for _, id in ipairs(self._hed.elements) do
		local unit = managers.editor:unit_with_id(id)

		if alive(unit) then
			local params = {
				b = 0.5,
				from_unit = unit,
				g = 0,
				r = 0,
				to_unit = self._unit,
			}

			self:_draw_link(params)
			Application:draw(unit, 0.25, 1, 0.25)
		else
			Application:error("[WorldOperatorUnitElement] draw_links_selected: did get a unit of id:", id)
		end
	end
end

function WorldOperatorUnitElement:add_unit_list_btn()
	local script = self._unit:mission_element_data().script

	local function f(unit)
		if not unit or not unit:mission_element_data() or unit:mission_element_data().script ~= script then
			return
		end

		local id = unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			return false
		end

		return managers.editor:layer("Mission"):category_map()[unit:type():s()]
	end

	local dialog = SelectUnitByNameModal:new("Add Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		table.insert(self._hed.elements, id)
	end
end

function WorldOperatorUnitElement:remove_unit_list_btn()
	local function f(unit)
		return table.contains(self._hed.elements, unit:unit_data().unit_id)
	end

	local dialog = SelectUnitByNameModal:new("Remove Unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		local id = unit:unit_data().unit_id

		table.delete(self._hed.elements, id)
	end
end

function WorldOperatorUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "operation", self._actions, "Select an operation for the selected elements")

	local worlds = self:_get_worlds()

	self:_build_value_combobox(panel, panel_sizer, "operation_world_id", worlds, "Select a world ID for the selected elements to change to")

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_UNIT_LIST", "Add unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "add_unit_list_btn"), nil)
	toolbar:add_tool("REMOVE_UNIT_LIST", "Remove unit from unit list", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("REMOVE_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "remove_unit_list_btn"), nil)
	toolbar:realize()
	panel_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	self:_add_help_text("Choose an operation to perform on the selected elements. An element might not have the selected operation implemented and will then generate error when executed.")
end

function WorldOperatorUnitElement:_get_worlds()
	local t = {
		"",
	}

	for level_id, data in pairs(_G.tweak_data.levels) do
		if type(data) == "table" and data.world_name then
			table.insert(t, level_id)
		end
	end

	table.sort(t)

	return t
end
