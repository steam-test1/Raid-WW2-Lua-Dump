core:module("CoreEditorSave")
core:import("CoreEditorUtils")
core:import("CoreCode")
core:import("CoreClass")
core:import("CoreXml")
core:import("CoreDebug")

function save_unit(world, level, unit, data)
	return
end

function save_data_table(unit)
	local ud = unit:unit_data()
	local t = {}

	t.name = unit:name():s()
	t.unit_id = ud.unit_id
	t.name_id = ud.name_id
	t.continent = unit:unit_data().continent and unit:unit_data().continent:name()
	t.position = unit:position()
	t.rotation = unit:rotation()
	t.mesh_variation = ud.mesh_variation
	t.material_variation = ud.material
	t.cutscene_actor = ud.cutscene_actor
	t.disable_shadows = ud.disable_shadows
	t.hide_on_projection_light = ud.hide_on_projection_light
	t.disable_on_ai_graph = ud.disable_on_ai_graph
	t.lights = _light_data_table(unit)
	t.triggers = _triggers_data_table(unit)
	t.editable_gui = _editable_gui_data_table(unit)
	t.projection_light = CoreEditorUtils.has_any_projection_light(unit)
	t.projection_lights = ud.projection_lights
	t.projection_textures = ud.projection_textures
	t.ladder = _editable_ladder_table(unit)
	t.zipline = _editable_zipline_table(unit)

	return t
end

function _light_data_table(unit)
	local lights = CoreEditorUtils.get_editable_lights(unit)

	if not lights then
		return nil
	end

	local t = {}

	for _, light in ipairs(lights) do
		local data = {
			clipping_values = light:clipping_values(),
			color = light:color(),
			enabled = light:enable(),
			falloff_exponent = light:falloff_exponent(),
			far_range = light:far_range(),
			linear_attenuation_factor = light:linear_attenuation_factor(),
			multiplier = CoreEditorUtils.get_intensity_preset(light:multiplier()):s(),
			name = light:name():s(),
			near_range = light:near_range(),
			spot_angle_end = light:spot_angle_end(),
			spot_angle_start = light:spot_angle_start(),
		}

		table.insert(t, data)
	end

	return #t > 0 and t or nil
end

function _triggers_data_table(unit)
	local triggers = managers.sequence:get_trigger_list(unit:name())

	if #triggers == 0 then
		return nil
	end

	local t = {}

	if #triggers > 0 and unit:damage() then
		local trigger_name_list = unit:damage():get_trigger_name_list()

		if trigger_name_list then
			for _, trigger_name in ipairs(trigger_name_list) do
				local trigger_data = unit:damage():get_trigger_data_list(trigger_name)

				if trigger_data and #trigger_data > 0 then
					for _, data in ipairs(trigger_data) do
						table.insert(t, {
							id = data.id,
							name = data.trigger_name,
							notify_unit_id = data.notify_unit:unit_data().unit_id,
							notify_unit_sequence = data.notify_unit_sequence,
							time = data.time,
						})
					end
				end
			end
		end
	end

	return #t > 0 and t or nil
end

function _editable_gui_data_table(unit)
	local t

	if unit:editable_gui() then
		t = {
			align = unit:editable_gui():align(),
			alpha = unit:editable_gui():alpha(),
			blend_mode = unit:editable_gui():blend_mode(),
			font = unit:editable_gui():font(),
			font_color = unit:editable_gui():font_color(),
			font_size = unit:editable_gui():font_size(),
			render_template = unit:editable_gui():render_template(),
			shape = unit:editable_gui():shape(),
			text = unit:editable_gui():text(),
			vertical = unit:editable_gui():vertical(),
			word_wrap = unit:editable_gui():word_wrap(),
			wrap = unit:editable_gui():wrap(),
		}
	end

	return t
end

function _editable_ladder_table(unit)
	local t

	if unit:ladder() then
		t = {
			height = unit:ladder():height(),
			width = unit:ladder():width(),
		}
	end

	return t
end

function _editable_zipline_table(unit)
	local t

	if unit:zipline() then
		t = {
			ai_ignores_bag = unit:zipline():ai_ignores_bag(),
			end_pos = unit:zipline():end_pos(),
			slack = unit:zipline():slack(),
			speed = unit:zipline():speed(),
			usage_type = unit:zipline():usage_type(),
		}
	end

	return t
end

function save_layout(params)
	local dialogs = {}

	if params.save_dialog_states then
		for name, dialog in pairs(params.dialogs) do
			dialogs[name] = {
				class = CoreDebug.class_name(getmetatable(dialog)),
				position = dialog:position(),
				size = dialog:size(),
				visible = dialog:visible(),
			}
		end

		for name, setting in pairs(params.dialogs_settings) do
			if not params.dialogs[name] then
				dialogs[name] = {
					class = setting.class,
					position = setting.position,
					size = setting.size,
					visible = setting.visible,
				}
			end
		end
	end

	local data = {
		dialogs = dialogs,
		is_iconized = Global.frame:is_iconized(),
		is_maximized = Global.frame:is_maximized(),
		position = Global.frame:get_position(),
		size = Global.frame:get_size(),
	}
	local f = SystemFS:open(params.file, "w")

	f:puts(ScriptSerializer:to_generic_xml(data))
	f:close()
end

function load_layout(params)
	local data = ScriptSerializer:from_generic_xml(params.file:read())

	for name, settings in pairs(data.dialogs) do
		params.dialogs_settings[name] = settings

		if settings.visible then
			managers.editor:show_dialog(name, settings.class)
		end
	end

	if not data.is_maximized and not data.is_iconized then
		Global.frame:maximize(data.is_maximized)
		Global.frame:set_size(data.size)
		Global.frame:set_position(data.position)
	elseif data.is_iconized then
		Global.frame:iconize(data.is_iconized)
	end
end
