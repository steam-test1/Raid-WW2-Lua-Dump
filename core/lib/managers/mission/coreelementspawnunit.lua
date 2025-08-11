core:module("CoreElementSpawnUnit")
core:import("CoreMissionScriptElement")
core:import("CoreUnit")

ElementSpawnUnit = ElementSpawnUnit or class(CoreMissionScriptElement.MissionScriptElement)

function ElementSpawnUnit:init(...)
	ElementSpawnUnit.super.init(self, ...)

	self._units = {}
end

function ElementSpawnUnit:client_on_executed(...)
	if self._values.unit_name ~= "none" then
		local network_sync = PackageManager:unit_data(self._values.unit_name:id(), ""):network_sync()

		if network_sync ~= "none" and network_sync ~= "client" then
			return
		end
	end

	self:on_executed(...)
end

function ElementSpawnUnit:on_executed(instigator, ...)
	if not self._values.enabled then
		return
	end

	if self._values.unit_name ~= "none" then
		local amount

		if self._values.counter_id then
			local element = self:get_mission_element(self._values.counter_id)

			amount = element:counter_value()
		else
			amount = self._values.unit_spawn_amount
		end

		local unit

		for i = 1, amount do
			local pos, rot = self:get_orientation()

			if self._values.unit_spawn_settled then
				local ray = World:raycast(pos, pos + Vector3(0, 0, -2000), nil, managers.slot:get_mask("world_geometry"))

				if ray then
					pos = ray.position
				end
			end

			unit = CoreUnit.safe_spawn_unit(self._values.unit_name, pos, rot)

			if self._values.unit_spawn_mass then
				unit:push(self._values.unit_spawn_mass, self._values.unit_spawn_dir * self._values.unit_spawn_velocity)
			end

			table.insert(self._units, unit)
		end

		instigator = unit
	elseif Application:editor() then
		managers.editor:output_error("Cant spawn unit \"none\" [" .. self._editor_name .. "]")
	end

	ElementSpawnUnit.super.on_executed(self, instigator, ...)
end

function ElementSpawnUnit:units()
	return self._units
end

function ElementSpawnUnit:delete_units()
	for _, unit in ipairs(self._units) do
		if alive(unit) then
			unit:set_slot(0)
		end
	end

	self._units = {}
end

function ElementSpawnUnit:destroy()
	if Network:is_server() then
		self:delete_units()
	end
end

function ElementSpawnUnit:operation_remove()
	self:destroy()
end

function ElementSpawnUnit:stop_simulation(...)
	self:destroy()
end
