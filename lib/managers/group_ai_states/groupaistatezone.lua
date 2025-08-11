GroupAIStateZone = GroupAIStateZone or class(GroupAIStateRaid)

function GroupAIStateZone:on_tweak_data_reloaded()
	self._tweak_data = tweak_data.group_ai.zone
end

function GroupAIStateZone:nav_ready_listener_key()
	return "GroupAIStateZone"
end
