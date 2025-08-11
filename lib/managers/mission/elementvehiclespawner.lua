core:import("CoreMissionScriptElement")

ElementVehicleSpawner = ElementVehicleSpawner or class(CoreMissionScriptElement.MissionScriptElement)

local is_editor = Application:editor()

function ElementVehicleSpawner:init(...)
	ElementVehicleSpawner.super.init(self, ...)

	self._vehicles = {}

	for k, v in pairs(tweak_data.vehicle) do
		if v.unit then
			self._vehicles[k] = v.unit
		end
	end

	self._vehicle_units = {}
end

function ElementVehicleSpawner:value(name)
	return self._values[name]
end

function ElementVehicleSpawner:client_on_executed(...)
	if not self._values.enabled then
		return
	end
end

function ElementVehicleSpawner:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local vehicle
	local vehicle_id = self._values.vehicle

	if vehicle_id == "spawn_starting_vehicle" then
		local job_data

		if is_editor and managers.editor then
			-- block empty
		else
			job_data = managers.raid_job:current_job()
		end

		vehicle_id = job_data and job_data.starting_vehicle or "kubelwagen"

		Application:info("[ElementVehicleSpawner] spawn_starting_vehicle", vehicle_id)
	end

	if vehicle_id and self._vehicles[vehicle_id] then
		Application:info("[ElementVehicleSpawner] Spawned vehicle", vehicle_id, "<--", self._values.vehicle)

		vehicle = safe_spawn_unit(self._vehicles[vehicle_id], self._values.position, self._values.rotation)

		if vehicle then
			table.insert(self._vehicle_units, vehicle)
		end
	end

	ElementVehicleSpawner.super.on_executed(self, vehicle or instigator)
end

function ElementVehicleSpawner:unspawn_all_units()
	for _, vehicle_unit in ipairs(self._vehicle_units) do
		if alive(vehicle_unit) then
			managers.vehicle:remove_vehicle(vehicle_unit)
		end
	end
end

function ElementVehicleSpawner:is_vehicle_unit_mine(instigator)
	for _, vehicle_unit in ipairs(self._vehicle_units) do
		if alive(vehicle_unit) and alive(instigator) and instigator == vehicle_unit then
			return true
		end
	end

	return false
end

function ElementVehicleSpawner:stop_simulation(...)
	self:unspawn_all_units()
end
