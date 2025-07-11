core:import("CoreEditorUtils")
core:import("CoreEws")

EditUnitLight = EditUnitLight or class(EditUnitBase)
EditUnitLight.DEFAULT_SHADOW_RESOLUTION = 128
EditUnitLight.DEFAULT_SPOT_PROJECTION_TEXTURE = "units/lights/spot_light_projection_textures/default_df"

function EditUnitLight:init(editor)
	EditUnitLight.super.init(self)

	local panel, sizer = (editor or managers.editor):add_unit_edit_page({
		class = self,
		name = "Light",
	})
	local debug_sizer = EWS:BoxSizer("VERTICAL")
	local debug_ctrlr = EWS:CheckBox(panel, "Debug", "")

	debug_ctrlr:set_value(self._debug)
	debug_ctrlr:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "update_debug"), debug_ctrlr)
	debug_sizer:add(debug_ctrlr, 1, 5, "EXPAND,LEFT")
	sizer:add(debug_sizer, 0, 5, "EXPAND,BOTTOM,TOP")

	local lights_sizer = EWS:BoxSizer("HORIZONTAL")

	self._lights_params = {
		ctrlr_proportions = 4,
		name = "Lights:",
		name_proportions = 3,
		options = {},
		panel = panel,
		sizer = lights_sizer,
		sizer_proportions = 4,
		sorted = true,
		tooltip = "Select a light to edit from the combobox",
	}

	CoreEws.combobox(self._lights_params)
	self._lights_params.ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "change_light"), nil)

	self._color_ctrlr = EWS:Button(panel, "Color", "", "BU_EXACTFIT")

	self._color_ctrlr:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "show_color_dialog"), "")
	lights_sizer:add(self._color_ctrlr, 0, 5, "EXPAND,LEFT")

	self._color_hex_ctrl = EWS:TextCtrl(panel, "000000", "", "TE_LEFT,TE_PROCESS_ENTER")

	self._color_hex_ctrl:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "update_color"), "")
	self._color_hex_ctrl:connect("EVT_KILL_FOCUS", callback(self, self, "update_color"), "")
	lights_sizer:add(self._color_hex_ctrl, 0, 5, "EXPAND,LEFT")

	self._enabled_ctrlr = EWS:CheckBox(panel, "Enabled", "")

	self._enabled_ctrlr:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "update_enabled"), self._enabled_ctrlr)
	lights_sizer:add(self._enabled_ctrlr, 1, 5, "EXPAND,LEFT")
	sizer:add(lights_sizer, 0, 5, "EXPAND,BOTTOM")

	self._near_range_params = {
		ctrlr_proportions = 1,
		events = {
			{
				callback = callback(self, self, "update_near_range"),
				event = "EVT_COMMAND_TEXT_ENTER",
			},
			{
				callback = callback(self, self, "update_near_range"),
				event = "EVT_KILL_FOCUS",
			},
		},
		floats = 0,
		min = 0,
		name = "Near range [cm]:",
		name_proportions = 1,
		panel = panel,
		sizer = sizer,
		tooltip = "Sets the near range of the light in cm",
		value = 0,
	}

	CoreEws.number_controller(self._near_range_params)

	self._range_params = {
		ctrlr_proportions = 1,
		events = {
			{
				callback = callback(self, self, "update_far_range"),
				event = "EVT_COMMAND_TEXT_ENTER",
			},
			{
				callback = callback(self, self, "update_far_range"),
				event = "EVT_KILL_FOCUS",
			},
		},
		floats = 0,
		min = 0,
		name = "Far range [cm]:",
		name_proportions = 1,
		panel = panel,
		sizer = sizer,
		tooltip = "Sets the range of the light in cm",
		value = 0,
	}

	CoreEws.number_controller(self._range_params)

	self._upper_clipping_params = {
		ctrlr_proportions = 1,
		events = {
			{
				callback = callback(self, self, "update_clipping", "x"),
				event = "EVT_COMMAND_TEXT_ENTER",
			},
			{
				callback = callback(self, self, "update_clipping", "x"),
				event = "EVT_KILL_FOCUS",
			},
		},
		floats = 0,
		name = "Set the upper clipping [cm]:",
		name_proportions = 1,
		panel = panel,
		sizer = sizer,
		tooltip = "Sets the upper clipping in cm",
		value = 0,
	}

	CoreEws.number_controller(self._upper_clipping_params)

	self._lower_clipping_params = {
		ctrlr_proportions = 1,
		events = {
			{
				callback = callback(self, self, "update_clipping", "y"),
				event = "EVT_COMMAND_TEXT_ENTER",
			},
			{
				callback = callback(self, self, "update_clipping", "y"),
				event = "EVT_KILL_FOCUS",
			},
		},
		floats = 0,
		name = "Set the lower clipping [cm]:",
		name_proportions = 1,
		panel = panel,
		sizer = sizer,
		tooltip = "Sets the lower clipping in cm",
		value = 0,
	}

	CoreEws.number_controller(self._lower_clipping_params)

	local intensity_options = {}

	for _, intensity in ipairs(LightIntensityDB:list()) do
		table.insert(intensity_options, intensity:s())
	end

	self._intensity_params = {
		ctrlr_proportions = 3,
		default = "none",
		name = "Intensity:",
		name_proportions = 1,
		options = intensity_options,
		panel = panel,
		sizer = sizer,
		sorted = false,
		tooltip = "Select an intensity from the combobox",
	}

	CoreEws.combobox(self._intensity_params)
	self._intensity_params.ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "update_intensity"), nil)

	self._falloff_params = {
		ctrlr_proportions = 3,
		floats = 7,
		max = 2,
		min = 0,
		name = "Quadratic attenuation:",
		name_proportions = 1,
		panel = panel,
		sizer = sizer,
		tooltip = "Controls quadratic attenuation factor",
		value = 0.0001,
	}

	CoreEws.slider_and_number_controller(self._falloff_params)
	self._falloff_params.slider_ctrlr:connect("EVT_SCROLL_CHANGED", callback(self, self, "update_falloff"), nil)
	self._falloff_params.slider_ctrlr:connect("EVT_SCROLL_THUMBTRACK", callback(self, self, "update_falloff"), nil)
	self._falloff_params.number_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "update_falloff"), nil)
	self._falloff_params.number_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "update_falloff"), nil)

	self._linear_atten_params = {
		ctrlr_proportions = 3,
		floats = 7,
		max = 1,
		min = 1e-07,
		name = "Linear attenuation:",
		name_proportions = 1,
		panel = panel,
		sizer = sizer,
		tooltip = "Controls linear attenuation factor",
		value = 0.0001,
	}

	CoreEws.slider_and_number_controller(self._linear_atten_params)
	self._linear_atten_params.slider_ctrlr:connect("EVT_SCROLL_CHANGED", callback(self, self, "update_linear_atten"), nil)
	self._linear_atten_params.slider_ctrlr:connect("EVT_SCROLL_THUMBTRACK", callback(self, self, "update_linear_atten"), nil)
	self._linear_atten_params.number_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "update_linear_atten"), nil)
	self._linear_atten_params.number_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "update_linear_atten"), nil)

	self._spot_start_angle_params = {
		ctrlr_proportions = 3,
		floats = 0,
		max = 179,
		min = 1,
		name = "Start angle:",
		name_proportions = 1,
		panel = panel,
		sizer = sizer,
		tooltip = "Controls the start angle of the spot light",
		value = 1,
	}

	CoreEws.slider_and_number_controller(self._spot_start_angle_params)
	self._spot_start_angle_params.slider_ctrlr:connect("EVT_SCROLL_CHANGED", callback(self, self, "update_start_angle"), nil)
	self._spot_start_angle_params.slider_ctrlr:connect("EVT_SCROLL_THUMBTRACK", callback(self, self, "update_start_angle"), nil)
	self._spot_start_angle_params.number_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "update_start_angle"), nil)
	self._spot_start_angle_params.number_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "update_start_angle"), nil)

	self._spot_end_angle_params = {
		ctrlr_proportions = 3,
		floats = 0,
		max = 179,
		min = 1,
		name = "End angle:",
		name_proportions = 1,
		panel = panel,
		sizer = sizer,
		tooltip = "Controls the end angle of the spot light",
		value = 1,
	}

	CoreEws.slider_and_number_controller(self._spot_end_angle_params)
	self._spot_end_angle_params.slider_ctrlr:connect("EVT_SCROLL_CHANGED", callback(self, self, "update_end_angle"), nil)
	self._spot_end_angle_params.slider_ctrlr:connect("EVT_SCROLL_THUMBTRACK", callback(self, self, "update_end_angle"), nil)
	self._spot_end_angle_params.number_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "update_end_angle"), nil)
	self._spot_end_angle_params.number_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "update_end_angle"), nil)

	self._shadow_resolution_params = {
		ctrlr_proportions = 3,
		name = "Shadow Resolution:",
		name_proportions = 1,
		numbers = true,
		options = {
			64,
			128,
			256,
			512,
			1024,
			2048,
		},
		panel = panel,
		sizer = sizer,
		sorted = false,
		tooltip = "Select an resolution from the combobox",
		value = EditUnitLight.DEFAULT_SHADOW_RESOLUTION,
	}

	CoreEws.combobox(self._shadow_resolution_params)
	self._shadow_resolution_params.ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "update_resolution"), nil)

	self._spot_projection_texture_params = {
		ctrlr_proportions = 3,
		name = "Spot Texture:",
		name_proportions = 1,
		options = self:get_spot_projection_textures(),
		panel = panel,
		sizer = sizer,
		sorted = true,
		tooltip = "Select a spot projection texture from the combobox",
		value = EditUnitLight.DEFAULT_SPOT_PROJECTION_TEXTURE,
	}

	CoreEws.combobox(self._spot_projection_texture_params)
	self._spot_projection_texture_params.ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "update_spot_projection_texture"), nil)
	panel:layout()
	panel:set_enabled(false)

	self._panel = panel
end

function EditUnitLight:get_spot_projection_textures()
	local entry_path = managers.database:entry_path(managers.database:base_path() .. "units\\lights\\spot_light_projection_textures")
	local files = SystemFS:list(managers.database:base_path() .. "units\\lights\\spot_light_projection_textures")
	local textures = {}

	for _, file in ipairs(files) do
		table.insert(textures, managers.database:entry_path(entry_path .. "\\" .. file))
	end

	return textures
end

function EditUnitLight:change_light()
	if alive(self._reference_unit) then
		local light = self._reference_unit:get_object(Idstring(self._lights_params.ctrlr:get_value()))

		self:update_light_ctrls_from_light(light)
	end
end

function EditUnitLight:update_light_ctrls_from_light(light)
	CoreEws.change_combobox_value(self._lights_params, light:name():s())
	self._enabled_ctrlr:set_value(light:enable())

	local r, g, b = (light:color() * 255):unpack()

	self._color_ctrlr:set_background_colour(r, g, b)
	self._color_hex_ctrl:set_value(string.format("%X%X%X", r, g, b))
	CoreEws.change_entered_number(self._range_params, light:far_range())
	CoreEws.change_entered_number(self._near_range_params, light:near_range())

	local clipping_values = light:clipping_values()

	CoreEws.change_entered_number(self._upper_clipping_params, clipping_values.x)
	CoreEws.change_entered_number(self._lower_clipping_params, clipping_values.y)

	local intensity = CoreEditorUtils.get_intensity_preset(light:multiplier())

	light:set_multiplier(LightIntensityDB:lookup(intensity))
	light:set_specular_multiplier(LightIntensityDB:lookup_specular_multiplier(intensity))
	CoreEws.change_combobox_value(self._intensity_params, intensity:s())
	CoreEws.change_slider_and_number_value(self._falloff_params, light:falloff_exponent())
	CoreEws.change_slider_and_number_value(self._linear_atten_params, light:linear_attenuation_factor())

	local is_falloff = string.match(light:properties(), "falloff") and true or false

	self._falloff_params.number_ctrlr:set_enabled(is_falloff)
	self._falloff_params.slider_ctrlr:set_enabled(is_falloff)
	self._linear_atten_params.number_ctrlr:set_enabled(is_falloff)
	self._linear_atten_params.slider_ctrlr:set_enabled(is_falloff)
	CoreEws.change_slider_and_number_value(self._spot_start_angle_params, light:spot_angle_start())
	CoreEws.change_slider_and_number_value(self._spot_end_angle_params, light:spot_angle_end())

	local is_spot = string.match(light:properties(), "spot") and true or false

	self._spot_start_angle_params.number_ctrlr:set_enabled(is_spot)
	self._spot_start_angle_params.slider_ctrlr:set_enabled(is_spot)
	self._spot_end_angle_params.number_ctrlr:set_enabled(is_spot)
	self._spot_end_angle_params.slider_ctrlr:set_enabled(is_spot)

	local is_shadow_projection = CoreEditorUtils.is_projection_light(self._reference_unit, light, "shadow_projection")

	self._shadow_resolution_params.ctrlr:set_enabled(is_shadow_projection)

	local resolution = self._reference_unit:unit_data().projection_lights

	resolution = resolution and resolution[light:name():s()] and resolution[light:name():s()].x or EditUnitLight.DEFAULT_SHADOW_RESOLUTION

	CoreEws.change_combobox_value(self._shadow_resolution_params, resolution)

	local is_projection = CoreEditorUtils.is_projection_light(self._reference_unit, light, "projection")

	self._spot_projection_texture_params.ctrlr:set_enabled(is_projection and is_spot)

	local projection_texture = self._reference_unit:unit_data().projection_textures

	projection_texture = projection_texture and projection_texture[light:name():s()] or EditUnitLight.DEFAULT_SPOT_PROJECTION_TEXTURE

	CoreEws.change_combobox_value(self._spot_projection_texture_params, projection_texture)
end

function EditUnitLight:update_falloff()
	for _, light in ipairs(self:_selected_lights()) do
		light:set_falloff_exponent(self._falloff_params.value)
	end
end

function EditUnitLight:update_linear_atten()
	for _, light in ipairs(self:_selected_lights()) do
		light:set_linear_attenuation_factor(self._linear_atten_params.value)
	end
end

function EditUnitLight:update_enabled()
	for _, light in ipairs(self:_selected_lights()) do
		light:set_enable(self._enabled_ctrlr:get_value())
	end
end

function EditUnitLight:show_color_dialog()
	local colordlg = EWS:ColourDialog(self._panel, true, self._color_ctrlr:background_colour() / 255)

	if colordlg:show_modal() then
		local r, g, b = (colordlg:get_colour() * 255):unpack()

		self._color_ctrlr:set_background_colour(r, g, b)
		self._color_hex_ctrl:set_value(string.format("%X%X%X", r, g, b))

		for _, light in ipairs(self:_selected_lights()) do
			light:set_color(self._color_ctrlr:background_colour() / 255)
		end
	end
end

function EditUnitLight:update_color()
	local color_value = self._color_hex_ctrl:get_value():gsub("#", "")
	local color = Color(color_value)
	local color_vect = Vector3(color:unpack())

	self._color_ctrlr:set_background_colour((color * 255):unpack())

	for _, light in ipairs(self:_selected_lights()) do
		light:set_color(color_vect)
	end
end

function EditUnitLight:update_intensity()
	for _, light in ipairs(self:_selected_lights()) do
		light:set_multiplier(LightIntensityDB:lookup(Idstring(self._intensity_params.value)))
		light:set_specular_multiplier(LightIntensityDB:lookup_specular_multiplier(Idstring(self._intensity_params.value)))
	end
end

function EditUnitLight:update_near_range(params)
	for _, light in ipairs(self:_selected_lights()) do
		light:set_near_range(params.value)
	end
end

function EditUnitLight:update_far_range(params)
	for _, light in ipairs(self:_selected_lights()) do
		light:set_far_range(params.value)
	end
end

function EditUnitLight:update_clipping(value, params)
	for _, light in ipairs(self:_selected_lights()) do
		local clipping_values = light:clipping_values()

		if value == "x" then
			light:set_clipping_values(clipping_values:with_x(params.value))
		elseif value == "y" then
			light:set_clipping_values(clipping_values:with_y(params.value))
		elseif value == "z" then
			light:set_clipping_values(clipping_values:with_z(params.value))
		end
	end
end

function EditUnitLight:update_start_angle()
	for _, light in ipairs(self:_selected_lights()) do
		light:set_spot_angle_start(self._spot_start_angle_params.value)
	end
end

function EditUnitLight:update_end_angle()
	for _, light in ipairs(self:_selected_lights()) do
		light:set_spot_angle_end(self._spot_end_angle_params.value)
	end
end

function EditUnitLight:update_resolution()
	local value = self._shadow_resolution_params.value

	for _, unit in ipairs(self._selected_units) do
		if alive(unit) then
			local light = unit:get_object(Idstring(self._lights_params.ctrlr:get_value()))

			if light then
				unit:unit_data().projection_lights = unit:unit_data().projection_lights or {}
				unit:unit_data().projection_lights[light:name():s()] = {
					x = value,
					y = value,
				}
			end
		end
	end
end

function EditUnitLight:update_spot_projection_texture()
	local value = self._spot_projection_texture_params.value

	for _, unit in ipairs(self._selected_units) do
		if alive(unit) then
			local light = unit:get_object(Idstring(self._lights_params.ctrlr:get_value()))

			if light then
				light:set_projection_texture(Idstring(value), false, false)

				unit:unit_data().projection_textures = unit:unit_data().projection_textures or {}
				unit:unit_data().projection_textures[light:name():s()] = value
			end
		end
	end
end

function EditUnitLight:_selected_lights()
	local lights = {}

	for _, unit in ipairs(self._selected_units) do
		if alive(unit) then
			local light = unit:get_object(Idstring(self._lights_params.ctrlr:get_value()))

			if light then
				table.insert(lights, light)
			end
		end
	end

	return lights
end

function EditUnitLight:_reference_light()
	if alive(self._reference_unit) then
		return self._reference_unit:get_object(Idstring(self._lights_params.ctrlr:get_value()))
	end
end

function EditUnitLight:_is_type(type)
	return string.find(self:_reference_light():properties(), type)
end

function EditUnitLight:is_editable(unit, units)
	if alive(unit) then
		local lights = CoreEditorUtils.get_editable_lights(unit) or {}
		local options = {}

		for _, light in ipairs(lights) do
			table.insert(options, light:name():s())
		end

		CoreEws.update_combobox_options(self._lights_params, options)

		if lights[1] then
			self._reference_unit = unit
			self._selected_units = units

			self:update_light_ctrls_from_light(lights[1])

			return true
		end
	end

	self._selected_units = {}

	return false
end

function EditUnitLight:update(t, dt)
	self:_draw(t, dt)
end

function EditUnitLight:_draw(t, dt)
	if not self._debug then
		return
	end

	for _, light in ipairs(self:_selected_lights()) do
		self:_draw_light(light, t, dt)
	end
end

function EditUnitLight:_draw_light(light, t, dt)
	if not light:enable() then
		return
	end

	local c = light:color()
	local clipping_values = light:clipping_values()

	if self:_is_type("omni") then
		self._brush:set_color(Color(0.15, c.x * 1, c.y * 1, c.z * 1))
		self._brush:sphere(light:position(), light:far_range(), 4)
		self._brush:set_color(Color(0.15, c.x * 0.5, c.y * 0.5, c.z * 0.5))
		self._brush:sphere(light:position(), light:near_range(), 4)
		Application:draw_sphere(light:position(), light:near_range(), c.x * 0.5, c.y * 0.5, c.z * 0.5)
		Application:draw_sphere(light:position(), light:far_range(), c.x * 1, c.y * 1, c.z * 1)
	else
		local far_radius = math.tan(light:spot_angle_end() / 2) * light:far_range()
		local near_radius = math.tan(light:spot_angle_end() / 2) * light:near_range()

		self._brush:set_color(Color(0.25, c.x * 1, c.y * 1, c.z * 1))
		self._brush:cone(light:position(), light:position() - light:rotation():z() * light:far_range(), far_radius)
		self._brush:set_color(Color(0.25, c.x * 0.25, c.y * 0.25, c.z * 0.25))
		self._brush:cone(light:position(), light:position() - light:rotation():z() * light:near_range(), near_radius)
		Application:draw_cone(light:position(), light:position() - light:rotation():z() * light:far_range(), far_radius, c.x * 1, c.y * 1, c.z * 1)
		Application:draw_cone(light:position(), light:position() - light:rotation():z() * light:near_range(), near_radius, c.x * 0.5, c.y * 0.5, c.z * 0.5)
	end

	self._brush:set_color(Color(0.5, c.x * 1, c.y * 0.5, c.z * 0))
	self._brush:disc(light:position() + Vector3(0, 0, clipping_values.x), light:far_range())
	self._pen:circle(light:position() + Vector3(0, 0, clipping_values.x), light:far_range())
	self._brush:set_color(Color(0.5, c.x * 1, c.y * 0.2, c.z * 0))
	self._brush:disc(light:position() + Vector3(0, 0, clipping_values.y), light:far_range())
	self._pen:circle(light:position() + Vector3(0, 0, clipping_values.y), light:far_range())
end
