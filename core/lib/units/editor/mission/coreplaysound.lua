CorePlaySoundUnitElement = CorePlaySoundUnitElement or class(MissionElement)
CorePlaySoundUnitElement.LINK_VALUES = {
	{
		layer = "target",
		output = true,
		table_value = "elements",
	},
}
PlaySoundUnitElement = PlaySoundUnitElement or class(CorePlaySoundUnitElement)

function PlaySoundUnitElement:init(...)
	PlaySoundUnitElement.super.init(self, ...)
end

function CorePlaySoundUnitElement:init(unit)
	CorePlaySoundUnitElement.super.init(self, unit)

	self._hed.elements = {}
	self._hed.append_prefix = false
	self._hed.use_instigator = false

	table.insert(self._save_values, "sound_event")
	table.insert(self._save_values, "elements")
	table.insert(self._save_values, "append_prefix")
	table.insert(self._save_values, "use_instigator")
end

function CorePlaySoundUnitElement:draw_links(t, dt, selected_unit, all_units)
	MissionElement.draw_links(self, t, dt, selected_unit, all_units)
end

function CorePlaySoundUnitElement:update_editing()
	return
end

function CorePlaySoundUnitElement:update_selected(t, dt, selected_unit, all_units)
	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				b = 0,
				from_unit = self._unit,
				g = 0,
				r = 0.75,
				to_unit = unit,
			})
		end
	end
end

function CorePlaySoundUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		mask = 10,
		ray_type = "editor",
	})

	if ray and ray.unit and (string.find(ray.unit:name():s(), "ai_spawn_enemy", 1, true) or string.find(ray.unit:name():s(), "ai_spawn_civilian", 1, true)) then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

function CorePlaySoundUnitElement:remove_links(unit)
	for _, id in ipairs(self._hed.elements) do
		if id == unit:unit_data().unit_id then
			table.delete(self._hed.elements, id)
		end
	end
end

function CorePlaySoundUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

function CorePlaySoundUnitElement:post_init(...)
	CorePlaySoundUnitElement.super.post_init(self, ...)
	self:_add_soundbank()
end

function CorePlaySoundUnitElement:test_element()
	if self._hed.sound_event then
		managers.editor:set_wanted_mute(false)
		managers.editor:set_listener_enabled(true)

		if self._ss then
			self._ss:stop()
		end

		self._ss = SoundDevice:create_source(self._unit:unit_data().name_id)

		self._ss:set_position(self._unit:position())
		self._ss:set_orientation(self._unit:rotation())
		self._ss:post_event(self._hed.sound_event)
	end
end

function CorePlaySoundUnitElement:stop_test_element()
	managers.editor:set_wanted_mute(true)
	managers.editor:set_listener_enabled(false)

	if self._ss then
		self._ss:stop()
	end
end

function CorePlaySoundUnitElement:set_category(params)
	local value = params.value

	CoreEws.update_combobox_options(self._sound_params, managers.sound_environment:scene_events(value))
	CoreEws.change_combobox_value(self._sound_params, managers.sound_environment:scene_events(value)[1])

	self._hed.sound_event = self._sound_params.value

	self:_add_soundbank()
end

function CorePlaySoundUnitElement:_add_soundbank()
	self:stop_test_element()
	managers.sound_environment:add_soundbank(managers.sound_environment:scene_soundbank(self._hed.sound_event))
end

function CorePlaySoundUnitElement:set_element_data(params, ...)
	CorePlaySoundUnitElement.super.set_element_data(self, params, ...)

	if params.value == "sound_event" then
		self:_add_soundbank()
	end
end

function CorePlaySoundUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local names = {
		"ai_spawn_enemy",
		"ai_spawn_civilian",
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)

	local paths = managers.sound_environment:scene_paths()

	if #paths <= 0 then
		local help = {
			panel = panel,
			sizer = panel_sizer,
		}

		help.text = "No scene sounds available in project!"

		self:add_help_text(help)

		return
	end

	self._hed.sound_event = self._hed.sound_event or managers.sound_environment:scene_events(paths[1])[1]

	self:_add_soundbank()

	local path_value = managers.sound_environment:scene_path(self._hed.sound_event)
	local _, _ = CoreEws.combobox_and_list({
		name = "Category:",
		options = paths,
		panel = panel,
		sizer = panel_sizer,
		value = path_value,
		value_changed_cb = callback(self, self, "set_category"),
	})
	local _, sound_params = self:_build_value_combobox(panel, panel_sizer, "sound_event", managers.sound_environment:scene_events(path_value), "Select a sound event")

	self._sound_params = sound_params

	self:_build_value_checkbox(panel, panel_sizer, "append_prefix", "Append unit prefix")
	self:_build_value_checkbox(panel, panel_sizer, "use_instigator", "Play on instigator")
end

function CorePlaySoundUnitElement:add_to_mission_package()
	managers.editor:add_to_sound_package({
		category = "soundbanks",
		name = managers.sound_environment:scene_soundbank(self._hed.sound_event),
	})
end

function CorePlaySoundUnitElement:destroy()
	self:stop_test_element()
	CorePlaySoundUnitElement.super.destroy(self)
end
