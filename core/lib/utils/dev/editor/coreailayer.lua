core:module("CoreAiLayer")
core:import("CoreStaticLayer")
core:import("CoreTable")
core:import("CoreEws")
require("core/lib/units/data/CoreAiEditorData")

AiLayer = AiLayer or class(CoreStaticLayer.StaticLayer)

function AiLayer:init(owner)
	AiLayer.super.init(self, owner, "ai", {
		"ai",
	}, "ai_layer")

	self._brush = Draw:brush()
	self._graph_types = {
		surface = "surface",
	}
	self._unit_graph_types = {}
	self._unit_graph_types.surface = Idstring("core/units/nav_surface/nav_surface")
	self._nav_surface_unit = Idstring("core/units/nav_surface/nav_surface")

	self:_init_ai_settings()
	self:_init_mop_settings()

	self._default_values = {}
	self._default_values.all_visible = true
end

function AiLayer:load(world_holder, offset)
	Application:debug("[AiLayer:load]")
	AiLayer.super.load(self, world_holder, offset)

	local ai_settings = world_holder:create_world("world", "ai_settings", offset)

	for name, value in pairs(ai_settings or {}) do
		self._ai_settings[name] = value
	end

	managers.ai_data:load_units(self._created_units)
	self:_update_motion_paths_list()
	self:_update_settings()
end

function AiLayer:save(save_params)
	AiLayer.super.save(self, save_params)

	local file_name = "nav_manager_data"
	local path = save_params.dir .. "\\" .. file_name .. ".nav_data"
	local file = managers.editor:_open_file(path, nil, true)

	file:puts(managers.navigation:get_save_data())
	SystemFS:close(file)

	local t = {
		data = {
			file = file_name,
		},
		entry = "ai_nav_graphs",
		single_data_block = true,
	}

	managers.editor:add_save_data(t)

	local t = {
		data = {
			ai_data = managers.ai_data:save_data(),
			ai_settings = self._ai_settings,
		},
		entry = "ai_settings",
		single_data_block = true,
	}

	managers.editor:add_save_data(t)

	if managers.motion_path:paths_exist() then
		local mop_filename = "mop_manager_data"
		local mop_path = save_params.dir .. "\\" .. mop_filename .. ".mop_data"
		local mop_file = managers.editor:_open_file(mop_path, nil, true)

		mop_file:puts(managers.motion_path:get_save_data())
		SystemFS:close(mop_file)

		local t = {
			data = {
				file = mop_filename,
			},
			entry = "ai_mop_graphs",
			single_data_block = true,
		}

		managers.editor:add_save_data(t)
	end
end

function AiLayer:_add_project_unit_save_data(unit, data)
	if unit:name() == self._nav_surface_unit then
		data.ai_editor_data = unit:ai_editor_data()
	end
end

function AiLayer:update(t, dt)
	AiLayer.super.update(self, t, dt)

	if managers.navigation:is_data_ready() ~= self._graph_status then
		self._graph_status = managers.navigation:is_data_ready()

		local text = self._graph_status and "Graph is correct" or "Graph is incomplete"
		local color = self._graph_status and Vector3(0, 200, 0) or Vector3(200, 0, 0)

		self._status_text:change_value("")
		self._status_text:set_default_style_colour(color)
		self._status_text:append(text)
	end

	self:_draw(t, dt)
end

function AiLayer:external_draw(t, dt)
	self:_draw(t, dt)
end

function AiLayer:_draw(t, dt)
	for _, unit in ipairs(self._created_units) do
		local selected = unit == self._selected_unit

		if unit:name() == self._nav_surface_unit then
			local a = selected and 0.75 or 0.5
			local r = selected and 0 or 1
			local g = selected and 1 or 1
			local b = selected and 0 or 1

			self._brush:set_color(Color(a, r, g, b))
			self:_draw_surface(unit, t, dt, a, r, g, b)

			if selected then
				for id, _ in pairs(unit:ai_editor_data().visibilty_exlude_filter) do
					for _, to_unit in ipairs(self._created_units) do
						if to_unit:unit_data().unit_id == id then
							Application:draw_link({
								b = 0,
								from_unit = unit,
								g = 0,
								r = 1,
								to_unit = to_unit,
							})
						end
					end
				end

				for id, _ in pairs(unit:ai_editor_data().visibilty_include_filter) do
					for _, to_unit in ipairs(self._created_units) do
						if to_unit:unit_data().unit_id == id then
							Application:draw_link({
								b = 0,
								from_unit = unit,
								g = 1,
								r = 0,
								to_unit = to_unit,
							})
						end
					end
				end
			end
		end
	end
end

function AiLayer:_draw_surface(unit, t, dt, a, r, g, b)
	local rot1 = Rotation(math.sin(t * 10) * 180, 0, 0)
	local rot2 = rot1 * Rotation(90, 0, 0)
	local pos1 = unit:position() - rot1:y() * 100
	local pos2 = unit:position() - rot2:y() * 100

	Application:draw_line(pos1, pos1 + rot1:y() * 200, r, g, b)
	Application:draw_line(pos2, pos2 + rot2:y() * 200, r, g, b)
	self._brush:quad(pos1, pos2, pos1 + rot1:y() * 200, pos2 + rot2:y() * 200)
end

function AiLayer:build_panel(notebook)
	AiLayer.super.build_panel(self, notebook, {
		units_notebook_min_size = Vector3(-1, 140, 0),
		units_noteboook_proportion = 0,
	})

	local ai_sizer = EWS:BoxSizer("VERTICAL")
	local graphs_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Graphs")
	local graphs = EWS:ListBox(self._ews_panel, "ai_layer_graph", "LB_EXTENDED,LB_HSCROLL,LB_NEEDED_SB,LB_SORT")

	for name, _ in pairs(self._graph_types) do
		graphs:append(name)
	end

	for i = 0, graphs:nr_items() - 1 do
		graphs:select_index(i)
	end

	graphs_sizer:add(graphs, 1, 0, "EXPAND")

	local button_sizer1 = EWS:StaticBoxSizer(self._ews_panel, "HORIZONTAL", "Calculate")
	local calc_btn = EWS:Button(self._ews_panel, "All", "", "BU_EXACTFIT,NO_BORDER")

	button_sizer1:add(calc_btn, 0, 5, "RIGHT")
	calc_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_calc_graphs"), {
		build_type = "all",
		vis_graph = true,
	})

	local calc_selected_btn = EWS:Button(self._ews_panel, "Selected", "", "BU_EXACTFIT,NO_BORDER")

	button_sizer1:add(calc_selected_btn, 0, 5, "RIGHT")
	calc_selected_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_calc_graphs"), {
		build_type = "selected",
		vis_graph = true,
	})

	local calc_ground_btn = EWS:Button(self._ews_panel, "Ground All", "", "BU_EXACTFIT,NO_BORDER")

	button_sizer1:add(calc_ground_btn, 0, 5, "RIGHT")
	calc_ground_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_calc_graphs"), {
		build_type = "all",
		vis_graph = false,
	})

	local calc_ground_selected_btn = EWS:Button(self._ews_panel, "Ground Selected", "", "BU_EXACTFIT,NO_BORDER")

	button_sizer1:add(calc_ground_selected_btn, 0, 5, "RIGHT")
	calc_ground_selected_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_calc_graphs"), {
		build_type = "selected",
		vis_graph = false,
	})

	local calc_vis_graph_btn = EWS:Button(self._ews_panel, "Visibility", "", "BU_EXACTFIT,NO_BORDER")

	button_sizer1:add(calc_vis_graph_btn, 0, 5, "RIGHT")
	calc_vis_graph_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_build_visibility_graph"), nil)
	graphs_sizer:add(button_sizer1, 0, 0, "EXPAND")

	local button_sizer2 = EWS:BoxSizer("HORIZONTAL")
	local clear_btn = EWS:Button(self._ews_panel, "Clear All", "", "BU_EXACTFIT,NO_BORDER")

	button_sizer2:add(clear_btn, 0, 5, "RIGHT")
	clear_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_clear_graphs"), nil)

	local clear_selected_btn = EWS:Button(self._ews_panel, "Clear Selected", "", "BU_EXACTFIT,NO_BORDER")

	button_sizer2:add(clear_selected_btn, 0, 5, "RIGHT")
	clear_selected_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_clear_selected_nav_segment"), nil)
	graphs_sizer:add(button_sizer2, 0, 0, "EXPAND")

	local build_settings = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Build Settings")

	self._all_visible = EWS:CheckBox(self._ews_panel, "All visible", "", "ALIGN_LEFT")

	self._all_visible:set_value(self._default_values.all_visible)
	build_settings:add(self._all_visible, 0, 0, "EXPAND")

	self._ray_length_params = {
		ctrlr_proportions = 3,
		floats = 0,
		min = 1,
		name = "Ray length [cm]:",
		name_proportions = 1,
		panel = self._ews_panel,
		sizer = build_settings,
		sizer_proportions = 1,
		tooltip = "Specifies the visible graph ray lenght in centimeter",
		value = 150,
	}

	CoreEws.number_controller(self._ray_length_params)
	graphs_sizer:add(build_settings, 0, 0, "EXPAND")

	local visualize_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Visualize")

	self._nav_visualization_checkboxes = {}
	self._nav_visualization_checkboxes.quads = EWS:CheckBox(self._ews_panel, "Quads", "", "ALIGN_LEFT")
	self._nav_visualization_checkboxes.doors = EWS:CheckBox(self._ews_panel, "Doors", "", "ALIGN_LEFT")
	self._nav_visualization_checkboxes.segments = EWS:CheckBox(self._ews_panel, "Segments", "", "ALIGN_LEFT")
	self._nav_visualization_checkboxes.coarse_graph = EWS:CheckBox(self._ews_panel, "Coarse Graph", "", "ALIGN_LEFT")
	self._nav_visualization_checkboxes.visibility_graph = EWS:CheckBox(self._ews_panel, "Visibility Graph", "", "ALIGN_LEFT")
	self._nav_visualization_checkboxes.blockers = EWS:CheckBox(self._ews_panel, "Blockers", "", "ALIGN_LEFT")
	self._nav_visualization_checkboxes.covers = EWS:CheckBox(self._ews_panel, "Covers", "", "ALIGN_LEFT")
	self._nav_visualization_checkboxes.sectors = EWS:CheckBox(self._ews_panel, "Sectors", "", "ALIGN_LEFT")

	for name, ctrl in pairs(self._nav_visualization_checkboxes) do
		visualize_sizer:add(ctrl, 0, 0, "EXPAND")
		ctrl:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "_apply_visualization_options"))
	end

	graphs_sizer:add(visualize_sizer, 0, 0, "EXPAND")

	self._status_text = EWS:TextCtrl(self._ews_panel, "", 0, "TE_NOHIDESEL,TE_RICH2,TE_DONTWRAP,TE_READONLY,TE_CENTRE")

	graphs_sizer:add(self._status_text, 0, 0, "EXPAND,ALIGN_CENTER")
	ai_sizer:add(graphs_sizer, 0, 0, "EXPAND")
	ai_sizer:add(self:_build_ai_settings(), 0, 0, "EXPAND")
	ai_sizer:add(self:_build_ai_unit_settings(), 0, 0, "EXPAND")
	ai_sizer:add(self:_build_motion_path_section(), 0, 0, "EXPAND")
	self._sizer:add(ai_sizer, 1, 0, "EXPAND")

	self._graphs = graphs

	return self._ews_panel
end

function AiLayer:_build_ai_settings()
	local graphs_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Settings")
	local group_state = {
		ctrlr_proportions = 3,
		name = "Group state:",
		name_proportions = 1,
		options = managers.groupai:state_names(),
		panel = self._ews_panel,
		sizer = graphs_sizer,
		sizer_proportions = 1,
		sorted = true,
		tooltip = "Select a group state from the combo box",
		value = self._ai_settings.group_state,
	}
	local state = CoreEws.combobox(group_state)

	state:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_set_group_state"), nil)

	self._ai_settings_guis = {}
	self._ai_settings_guis.group_state = group_state

	return graphs_sizer
end

function AiLayer:_build_ai_unit_settings()
	local sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Unit settings")
	local suspicion_multiplier = {
		ctrlr_proportions = 4,
		floats = 1,
		min = 1,
		name = "Suspicion Multiplier:",
		name_proportions = 1,
		panel = self._ews_panel,
		sizer = sizer,
		sizer_proportions = 1,
		tooltip = "multiplier applied to suspicion buildup rate",
		value = 1,
	}
	local suspicion_multiplier_ctrlr = CoreEws.number_controller(suspicion_multiplier)

	suspicion_multiplier_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_suspicion_mul"), nil)
	suspicion_multiplier_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "_set_suspicion_mul"), nil)

	local detection_multiplier = {
		ctrlr_proportions = 4,
		floats = 2,
		min = 0.01,
		name = "Detection Multiplier:",
		name_proportions = 1,
		panel = self._ews_panel,
		sizer = sizer,
		sizer_proportions = 1,
		tooltip = "multiplier applied to AI detection speed. min is 0.01",
		value = 1,
	}
	local detection_multiplier_ctrlr = CoreEws.number_controller(detection_multiplier)

	detection_multiplier_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_detection_mul"), nil)
	detection_multiplier_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "_set_detection_mul"), nil)

	local location_sizer = EWS:BoxSizer("HORIZONTAL")

	location_sizer:add(EWS:StaticText(self._ews_panel, "Map Location:", 0, ""), 1, 0, "ALIGN_CENTER_VERTICAL")

	local location_id = EWS:TextCtrl(self._ews_panel, "")

	location_id:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_location"))
	location_id:connect("EVT_KILL_FOCUS", callback(self, self, "_set_location"))
	location_sizer:add(location_id, 4, 0, "EXPAND")
	sizer:add(location_sizer, 1, 0, "EXPAND")

	local tag_sizer = EWS:BoxSizer("HORIZONTAL")
	local barrage_allowed = EWS:CheckBox(self._ews_panel, "Barrage Allowed", "", "ALIGN_LEFT")

	barrage_allowed:set_value(false)
	barrage_allowed:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "_set_barrage_allowed"), nil)
	tag_sizer:add(barrage_allowed, 1, 0, "EXPAND")
	sizer:add(tag_sizer, 1, 0, "EXPAND")

	self._ai_unit_settings_guis = {}
	self._ai_unit_settings_guis.text = text
	self._ai_unit_settings_guis.suspicion_multiplier = suspicion_multiplier
	self._ai_unit_settings_guis.detection_multiplier = detection_multiplier
	self._ai_unit_settings_guis.location_id = location_id
	self._ai_unit_settings_guis.barrage_allowed = barrage_allowed

	return sizer
end

function AiLayer:_build_motion_path_section()
	local motion_paths_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Motion Paths (Work In Progress)")
	local create_paths_btn = EWS:Button(self._ews_panel, "Recreate Paths", "", "BU_EXACTFIT,NO_BORDER")

	motion_paths_sizer:add(create_paths_btn, 0, 5, "RIGHT")
	create_paths_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_create_motion_paths"), nil)

	local motion_paths_list_sizer = EWS:StaticBoxSizer(self._ews_panel, "HORIZONTAL", "Generated motion paths list")
	local motion_path_toolbar = EWS:ToolBar(self._ews_panel, "", "TB_FLAT,TB_VERTICAL,TB_NODIVIDER")

	motion_path_toolbar:add_tool("GT_DELETE", "Delete", CoreEws.image_path("toolbar\\delete_16x16.png"), "Delete selected motion path and its markers.")
	motion_path_toolbar:connect("GT_DELETE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_delete_motion_path"), nil)
	motion_path_toolbar:add_check_tool("ONLY_DRAW_SELECTED_MOTION_PATH", "Toggle draw on selected motion path.", CoreEws.image_path("lock_16x16.png"), "Toggle draw on selected motion path.")
	motion_path_toolbar:set_tool_state("ONLY_DRAW_SELECTED_MOTION_PATH", self._only_draw_selected_motion_path)
	motion_path_toolbar:connect("ONLY_DRAW_SELECTED_MOTION_PATH", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_toggle_only_draw_selected_motion_path"), motion_path_toolbar)
	motion_path_toolbar:realize()
	motion_paths_list_sizer:add(motion_path_toolbar, 0, 0, "EXPAND")

	self._motion_paths_list = EWS:ListBox(self._ews_panel, "ai_layer_motion_paths", "LB_SINGLE,LB_HSCROLL,LB_NEEDED_SB,LB_SORT")

	self._motion_paths_list:connect("EVT_COMMAND_LISTBOX_SELECTED", callback(self, self, "_select_motion_path"), nil)
	motion_paths_list_sizer:add(self._motion_paths_list, 1, 0, "EXPAND")
	motion_paths_sizer:add(motion_paths_list_sizer, 1, 0, "EXPAND")

	local mop_path_types = {
		"airborne",
		"ground",
	}

	if managers.motion_path then
		mop_path_types = managers.motion_path:get_path_types()
	end

	local mop_type = {
		ctrlr_proportions = 3,
		name = "Selected path type:",
		name_proportions = 1,
		options = mop_path_types,
		panel = self._ews_panel,
		sizer = motion_paths_sizer,
		sorted = false,
		tooltip = "Path is used for either ground or airborne units.",
		value = self._motion_path_settings.path_type,
	}
	local path_type_ctrlr = CoreEws.combobox(mop_type)

	path_type_ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_set_mop_type"), nil)

	local speed_limit = {
		ctrlr_proportions = 3,
		floats = 1,
		min = -1,
		name = "Default Speed Limit [km/h]:",
		name_proportions = 1,
		panel = self._ews_panel,
		sizer = motion_paths_sizer,
		tooltip = "Default speed limit for units moved along this path. -1 for no limit.",
		value = 50,
	}
	local speed_limit_ctrlr = CoreEws.number_controller(speed_limit)

	speed_limit_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_mop_speed_limit"), nil)
	speed_limit_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "_set_mop_speed_limit"), nil)

	self.motion_path_settings_guis = {}
	self.motion_path_settings_guis.default_speed_limit = speed_limit
	self.motion_path_settings_guis.default_speed_limit_ctrlr = speed_limit_ctrlr
	self.motion_path_settings_guis.path_type = mop_type
	self.motion_path_settings_guis.path_type_ctrlr = path_type_ctrlr

	return motion_paths_sizer
end

function AiLayer:_set_mop_type()
	local selected_path = self:_selected_motion_path()

	if selected_path then
		if not self._motion_path_settings[selected_path] then
			self._motion_path_settings[selected_path] = {}
		end

		local path_type = self.motion_path_settings_guis.path_type.value

		self._motion_path_settings[selected_path].path_type = path_type

		managers.motion_path:set_path_type(path_type)
	end
end

function AiLayer:_set_mop_speed_limit()
	local speed_limit = self.motion_path_settings_guis.default_speed_limit.value
	local selected_path = self:_selected_motion_path()

	if selected_path then
		if not self._motion_path_settings[selected_path] then
			self._motion_path_settings[selected_path] = {}
		end

		self._motion_path_settings[selected_path].speed_limit = speed_limit
	end

	managers.motion_path:set_default_speed_limit(speed_limit)
end

function AiLayer:_delete_motion_path()
	Application:debug("AiLayer:_delete_motion_path()")
end

function AiLayer:_toggle_only_draw_selected_motion_path(motion_path_toolbar)
	self._only_draw_selected_motion_path = motion_path_toolbar:tool_state("ONLY_DRAW_SELECTED_MOTION_PATH")
end

function AiLayer:_update_motion_paths_list()
	self._motion_paths_list:clear()

	self._motion_path_settings = {}

	if not managers.motion_path then
		return
	end

	local all_paths = managers.motion_path:get_all_paths()

	for _, path in ipairs(managers.motion_path:get_all_paths()) do
		self._motion_paths_list:append(path.id)

		self._motion_path_settings[path.id] = {}

		if not path.default_speed_limit then
			path.default_speed_limit = -1
		end

		if not path.path_type then
			local all_path_types = managers.motion_path:get_path_types()

			if all_path_types then
				path.path_type = all_path_types[1]
			else
				path.path_type = "airborne"
			end
		end

		self.motion_path_settings_guis.default_speed_limit_ctrlr:set_value(path.default_speed_limit)

		self._motion_path_settings[path.id].speed_limit = path.default_speed_limit
		self._motion_path_settings[path.id].path_type = path.path_type

		self.motion_path_settings_guis.path_type_ctrlr:set_value(path.path_type)
	end

	if #all_paths > 0 then
		self._motion_paths_list:select_index(0)

		local selected_path = self:_selected_motion_path()

		if selected_path then
			self.motion_path_settings_guis.default_speed_limit_ctrlr:set_value(self._motion_path_settings[selected_path].speed_limit)
			self.motion_path_settings_guis.path_type_ctrlr:set_value(self._motion_path_settings[selected_path].path_type)
			managers.motion_path:select_path(selected_path)
		end
	end
end

function AiLayer:_create_motion_paths()
	managers.motion_path:recreate_paths()
	self:_update_motion_paths_list()
end

function AiLayer:_select_motion_path()
	local motion_path_name = self:_selected_motion_path()

	managers.motion_path:select_path(motion_path_name)

	if self._motion_path_settings[motion_path_name] then
		self.motion_path_settings_guis.default_speed_limit_ctrlr:set_value(self._motion_path_settings[motion_path_name].speed_limit)
		self.motion_path_settings_guis.path_type_ctrlr:set_value(self._motion_path_settings[motion_path_name].path_type)
	end
end

function AiLayer:_selected_motion_path()
	local index = self._motion_paths_list:selected_index()

	if index ~= -1 then
		return self._motion_paths_list:get_string(index)
	end

	return nil
end

function AiLayer:_calc_graphs(params)
	local build_type = params.build_type

	if build_type == "all" then
		local confirm = EWS:message_box(Global.frame_panel, "Are you sure?", "AI", "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))

		if confirm == "NO" then
			return
		end
	end

	local selected = self._graphs:selected_indices()

	if build_type == "all" then
		managers.navigation:clear()
	end

	for _, i in ipairs(selected) do
		local selection = self._graphs:get_string(i)
		local type = self._graph_types[selection]

		if type then
			local settings = self:_get_build_settings(type, build_type)

			if #settings > 0 then
				self._saved_disabled_units = {}

				for name, layer in pairs(managers.editor:layers()) do
					for _, unit in ipairs(layer:created_units()) do
						if unit:unit_data().disable_on_ai_graph then
							unit:set_enabled(false)
							table.insert(self._saved_disabled_units, unit)
						else
							local instance_name = unit:unit_data().instance

							if not not instance_name then
								local instance_data = managers.world_instance:get_instance_data_by_name(instance_name)

								if instance_data.mission_placed then
									unit:set_enabled(false)
									table.insert(self._saved_disabled_units, unit)
								end
							end
						end
					end
				end

				managers.editor:output("Make graph " .. type .. "_" .. self._graphs:get_string(i))
				managers.navigation:build_nav_segments(settings, callback(self, self, "_graphs_done", params.vis_graph))
			end
		else
			Application:error("Invalid selection \"" .. tostring(selection) .. "\".")
		end
	end
end

function AiLayer:_graphs_done(vis_graph)
	managers.editor:output("Navigation seqments calculated")

	for _, unit in ipairs(self._saved_disabled_units) do
		unit:set_enabled(true)
	end

	if vis_graph then
		self:_build_visibility_graph()
	end
end

function AiLayer:_build_visibility_graph()
	local all_visible = self._all_visible:get_value() and true
	local exclude, include

	if not all_visible then
		exclude = {}
		include = {}

		for _, unit in ipairs(self._created_units) do
			if unit:name() == self._nav_surface_unit then
				exclude[unit:unit_data().unit_id] = unit:ai_editor_data().visibilty_exlude_filter
				include[unit:unit_data().unit_id] = unit:ai_editor_data().visibilty_include_filter
			end
		end
	end

	local ray_lenght = self._ray_length_params.value

	managers.navigation:build_visibility_graph(callback(self, self, "_visibility_graph_done"), all_visible, exclude, include, ray_lenght)
end

function AiLayer:_visibility_graph_done()
	managers.editor:output("Visibility graph calculated")
end

function AiLayer:_get_build_settings(type, build_type)
	local settings = {}
	local units = self:_get_units(type, build_type)

	for _, unit in ipairs(units) do
		local ray = managers.editor:unit_by_raycast({
			from = unit:position() + Vector3(0, 0, 50),
			mask = managers.slot:get_mask("all"),
			sample = true,
			to = unit:position() - Vector3(0, 0, 150),
		})

		if ray and ray.position then
			table.insert(settings, {
				barrage_allowed = unit:ai_editor_data().barrage_allowed,
				color = Color(),
				id = unit:unit_data().unit_id,
				location_id = unit:ai_editor_data().location_id,
				position = unit:position(),
			})
		end
	end

	return settings
end

function AiLayer:_get_units(type, build_type)
	local unit_name = self._unit_graph_types[type]
	local units = {}

	for _, unit in ipairs(build_type == "selected" and self._selected_units or self._created_units) do
		if unit:name() == unit_name then
			table.insert(units, unit)
		end
	end

	return units
end

function AiLayer:_apply_visualization_options()
	local options = {}

	for name, ctrl in pairs(self._nav_visualization_checkboxes) do
		options[name] = ctrl:get_value()
	end

	managers.navigation:set_debug_draw_state(options)
end

function AiLayer:_set_group_state()
	self._ai_settings.group_state = self._ai_settings_guis.group_state.value

	managers.groupai:set_state(self._ai_settings.group_state)
end

function AiLayer:_update_settings()
	for name, value in pairs(self._ai_settings) do
		if self._ai_settings_guis[name] then
			CoreEws.change_combobox_value(self._ai_settings_guis[name], value)
		end
	end
end

function AiLayer:_clear_graphs()
	local confirm = EWS:message_box(Global.frame_panel, "Clear all graphs?", "AI", "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))

	if confirm == "NO" then
		return
	end

	managers.navigation:clear()
end

function AiLayer:_clear_selected_nav_segment()
	local confirm = EWS:message_box(Global.frame_panel, "Clear selected graph segment?", "AI", "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))

	if confirm == "NO" then
		return
	end

	print("[AiLayer:_clear_selected_nav_segment]")

	local selected = self._graphs:selected_indices()
	local units = self:_get_units("surface", "selected")

	for _, unit in ipairs(units) do
		print("deleting", unit:unit_data().unit_id)
		managers.navigation:delete_nav_segment(unit:unit_data().unit_id)
	end
end

function AiLayer:set_select_unit(unit)
	if alive(unit) and unit:name() == self._nav_surface_unit then
		self._ai_unit_settings_guis.location_id:set_value(unit:ai_editor_data().location_id or "")
		CoreEws.change_entered_number(self._ai_unit_settings_guis.suspicion_multiplier, unit:ai_editor_data().suspicion_mul)
		CoreEws.change_entered_number(self._ai_unit_settings_guis.detection_multiplier, unit:ai_editor_data().detection_mul)
		self._ai_unit_settings_guis.barrage_allowed:set_value(unit:ai_editor_data().barrage_allowed)
	end

	if not self:_add_to_visible_exlude_filter(unit) then
		AiLayer.super.set_select_unit(self, unit)

		if not alive(unit) or unit:name() == self._nav_surface_unit then
			managers.navigation:set_selected_segment(unit)
		end
	end
end

function AiLayer:_add_to_visible_exlude_filter(unit)
	if not alive(unit) then
		return false
	end

	if unit:name() ~= self._nav_surface_unit then
		return false
	end

	if self._selected_unit and self._editor_data.virtual_controller:down(Idstring("visible_exlude_filter")) and unit ~= self._selected_unit then
		if self._selected_unit:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] then
			self._selected_unit:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] = nil
			unit:ai_editor_data().visibilty_exlude_filter[self._selected_unit:unit_data().unit_id] = nil
		else
			self._selected_unit:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] = nil
			unit:ai_editor_data().visibilty_include_filter[self._selected_unit:unit_data().unit_id] = nil
			self._selected_unit:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] = true
			unit:ai_editor_data().visibilty_exlude_filter[self._selected_unit:unit_data().unit_id] = true
		end

		return true
	end

	if self._selected_unit and self._editor_data.virtual_controller:down(Idstring("visible_include_filter")) and unit ~= self._selected_unit then
		if self._selected_unit:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] then
			self._selected_unit:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] = nil
			unit:ai_editor_data().visibilty_include_filter[self._selected_unit:unit_data().unit_id] = nil
		else
			self._selected_unit:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] = nil
			unit:ai_editor_data().visibilty_exlude_filter[self._selected_unit:unit_data().unit_id] = nil
			self._selected_unit:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] = true
			unit:ai_editor_data().visibilty_include_filter[self._selected_unit:unit_data().unit_id] = true
		end

		return true
	end

	return false
end

function AiLayer:delete_unit(unit)
	for _, u in ipairs(self._created_units) do
		if u:name() == self._nav_surface_unit and u ~= unit then
			u:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] = nil
			u:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] = nil
		end
	end

	if unit:name() == self._nav_surface_unit then
		managers.navigation:delete_nav_segment(unit:unit_data().unit_id)
	end

	AiLayer.super.delete_unit(self, unit)
end

function AiLayer:prepare_replace_params(unit)
	local params = AiLayer.super.prepare_replace_params(self, unit)

	if params and unit:name() == self._nav_surface_unit then
		params.ai_editor_data = unit:ai_editor_data()
	end

	return params
end

function AiLayer:_recreate_unit(name, params)
	local new_unit = AiLayer.super._recreate_unit(self, name, params)

	if params.ai_editor_data and alive(new_unit) then
		local new_data = new_unit:ai_editor_data()

		for k, v in pairs(params.ai_editor_data) do
			new_data[k] = v
		end
	end

	return new_unit
end

function AiLayer:update_unit_settings()
	AiLayer.super.update_unit_settings(self)
end

function AiLayer:_init_ai_settings()
	self._ai_settings = {}
	self._ai_settings.group_state = "raid"

	managers.groupai:set_state(self._ai_settings.group_state)
end

function AiLayer:_init_mop_settings()
	self._motion_path_settings = {}

	if managers.motion_path then
		local path_types = managers.motion_path:get_path_types()

		if path_types then
			self._motion_path_settings.path_type = path_types[1]
		end
	end
end

function AiLayer:clear()
	AiLayer.super.clear(self)

	if managers.motion_path then
		managers.motion_path:delete_paths()
	end

	self:_init_ai_settings()
	self:_update_settings()
	managers.ai_data:clear()
	self:_update_motion_paths_list()
	managers.navigation:clear()
end

function AiLayer:add_triggers()
	AiLayer.super.add_triggers(self)
end

function AiLayer:_set_suspicion_mul()
	if not self._selected_unit or not self._selected_unit:ai_editor_data() then
		return
	end

	self._selected_unit:ai_editor_data().suspicion_mul = self._ai_unit_settings_guis.suspicion_multiplier.value

	managers.navigation:set_suspicion_multiplier(self._selected_unit:unit_data().unit_id, self._ai_unit_settings_guis.suspicion_multiplier.value)
end

function AiLayer:_set_detection_mul()
	if not self._selected_unit or not self._selected_unit:ai_editor_data() then
		return
	end

	self._selected_unit:ai_editor_data().detection_mul = self._ai_unit_settings_guis.detection_multiplier.value

	managers.navigation:set_detection_multiplier(self._selected_unit:unit_data().unit_id, self._ai_unit_settings_guis.detection_multiplier.value)
end

function AiLayer:_set_barrage_allowed()
	if not self._selected_unit or not self._selected_unit:ai_editor_data() then
		return
	end

	self._selected_unit:ai_editor_data().barrage_allowed = self._ai_unit_settings_guis.barrage_allowed:get_value()

	managers.navigation:set_barrage_allowed(self._selected_unit:unit_data().unit_id, self._ai_unit_settings_guis.barrage_allowed:get_value())
end

function AiLayer:_set_location()
	if not self._selected_unit or not self._selected_unit:ai_editor_data() then
		return
	end

	local location_id = self._ai_unit_settings_guis.location_id:get_value()

	self._selected_unit:ai_editor_data().location_id = location_id

	managers.navigation:set_location_ID(self._selected_unit:unit_data().unit_id, location_id)
end
