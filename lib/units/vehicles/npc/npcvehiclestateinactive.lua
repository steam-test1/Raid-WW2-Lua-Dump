NpcVehicleStateInactive = NpcVehicleStateInactive or class(NpcBaseVehicleState)

function NpcVehicleStateInactive:init(unit)
	NpcBaseVehicleState.init(self, unit)
end

function NpcVehicleStateInactive:update(t, dt)
	return
end

function NpcVehicleStateInactive:name()
	return NpcVehicleDrivingExt.STATE_INACTIVE
end
