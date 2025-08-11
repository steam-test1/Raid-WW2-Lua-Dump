ElementVehicleTrigger = ElementVehicleTrigger or class(CoreMissionScriptElement.MissionScriptElement)

function ElementVehicleTrigger:init(...)
	ElementVehicleTrigger.super.init(self, ...)
end

function ElementVehicleTrigger:on_script_activated()
	if Network:is_server() then
		managers.vehicle:add_listener(self._id, {
			self._values.event,
		}, callback(self, self, "on_executed"))
	end
end

function ElementVehicleTrigger:is_valid_instigator(vehicle_unit)
	if self._values.elements then
		for _, id in ipairs(self._values.elements) do
			local element = self:get_mission_element(id)

			if element:is_vehicle_unit_mine(vehicle_unit) then
				return true
			end
		end

		return false
	end

	return true
end

function ElementVehicleTrigger:send_to_host(instigator)
	if instigator then
		managers.network:session():send_to_host("to_server_mission_element_trigger", self._id, nil)
	end
end

function ElementVehicleTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self:is_valid_instigator(instigator) then
		ElementVehicleTrigger.super.on_executed(self, self._unit or instigator)
	end
end

function ElementVehicleTrigger:destroy()
	if Network:is_server() then
		managers.vehicle:remove_listener(self._id)
	end
end
