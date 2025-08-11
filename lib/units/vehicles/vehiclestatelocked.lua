VehicleStateLocked = VehicleStateLocked or class(BaseVehicleState)

function VehicleStateLocked:init(unit)
	BaseVehicleState.init(self, unit)
end

function VehicleStateLocked:enter(state_data, enter_data)
	self._driving_ext:_stop_engine_sound()
	self._unit:interaction():set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
	self:disable_interactions()

	if Network:is_server() then
		self._driving_ext:set_input(0, 0, 1, 1, false, false, 2)
	end
end

function VehicleStateLocked:disable_interactions()
	if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)

		self._driving_ext._interaction_enter_vehicle = false
		self._driving_ext._interaction_repair = false
	end
end

function VehicleStateLocked:allow_exit()
	return true
end

function VehicleStateLocked:stop_vehicle()
	return true
end

function VehicleStateLocked:is_vulnerable()
	return false
end
