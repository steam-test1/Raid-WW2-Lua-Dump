NetworkSpawnPointExt = NetworkSpawnPointExt or class()

function NetworkSpawnPointExt:init(unit)
	if managers.network then
		-- block empty
	end
end

function NetworkSpawnPointExt:get_data(unit)
	return {
		position = unit:position(),
		rotation = unit:rotation(),
	}
end

function NetworkSpawnPointExt:destroy(unit)
	return
end
