EventSystemManager = EventSystemManager or class()
EventSystemManager.VERSION = 1

function EventSystemManager.get_instance()
	if not Global.event_manager then
		Global.event_manager = EventSystemManager:new()
	end

	setmetatable(Global.event_manager, EventSystemManager)

	return Global.event_manager
end

function EventSystemManager:init()
	self:reset()
end

function EventSystemManager:reset()
	return
end

function EventSystemManager:save_profile_slot(data)
	local state = {
		version = EventSystemManager.VERSION,
	}

	data.EventSystemManager = state
end

function EventSystemManager:load_profile_slot(data)
	local state = data.EventSystemManager

	if not state then
		return
	end

	if state.version and state.version ~= EventSystemManager.VERSION then
		-- block empty
	end
end
