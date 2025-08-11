SpawnVehicleElement = SpawnVehicleElement or class(MissionElement)
SpawnVehicleElement.EXECUTE_CHANGES_INSTIGATOR = true

function SpawnVehicleElement:init(unit)
	Application:trace("SpawnVehicleElement:init", unit)
	MissionElement.init(self, unit)

	self._vehicle_names = {
		"spawn_starting_vehicle",
	}

	for k, v in pairs(tweak_data.vehicle) do
		if v.unit then
			table.insert_sorted(self._vehicle_names, k)
		end
	end

	self._hed.state = VehicleDrivingExt.STATE_INACTIVE
	self._hed.vehicle = self._vehicle_names[1]

	table.insert(self._save_values, "state")
	table.insert(self._save_values, "vehicle")
end

function SpawnVehicleElement:_build_panel(panel, panel_sizer)
	Application:trace("SpawnVehicleElement:_build_panel")
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "vehicle", self._vehicle_names, "Select a vehicle from the combobox")
	self:_add_help_text("The vehicle that will be spawned")
end

function SpawnVehicleElement:add_to_mission_package()
	if self._hed.vehicle ~= "none" and self._hed.vehicle ~= "spawn_starting_vehicle" then
		local unit_name = tweak_data.vehicle[self._hed.vehicle].unit
		local ids_unit_name = Idstring(unit_name)

		managers.editor:add_to_world_package({
			category = "units",
			continent = self._unit:unit_data().continent,
			name = unit_name,
		})

		local sequence_files = {}

		CoreEditorUtils.get_sequence_files_by_unit_name(ids_unit_name, sequence_files)

		for _, file in ipairs(sequence_files) do
			managers.editor:add_to_world_package({
				category = "script_data",
				continent = self._unit:unit_data().continent,
				init = true,
				name = file:s() .. ".sequence_manager",
			})
		end
	end
end
