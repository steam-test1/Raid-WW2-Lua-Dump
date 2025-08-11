ElementGlobalStateOperator = ElementGlobalStateOperator or class(CoreMissionScriptElement.MissionScriptElement)

function ElementGlobalStateOperator:init(...)
	ElementGlobalStateOperator.super.init(self, ...)
end

function ElementGlobalStateOperator:client_on_executed(...)
	self:on_executed(...)
end

function ElementGlobalStateOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local flag = self._values.flag
	local value = self._values.value
	local action = self._values.action

	if action == "set" then
		managers.global_state:set_flag(flag)
	elseif action == "clear" then
		managers.global_state:clear_flag(flag)
	elseif action == "default" then
		managers.global_state:set_to_default(flag)
	elseif action == "event" then
		managers.global_state:fire_event(flag)
	elseif action == "set_value" then
		managers.global_state:set_value_flag(flag, value)
	elseif action == "add_value" then
		managers.global_state:add_value_flag(flag, value)
	elseif action == "sub_value" then
		managers.global_state:add_value_flag(flag, -value)
	elseif action == "links_set_value" then
		local elements = self._values.elements or {}
		local flag_value = managers.global_state:flag_value(flag)

		for _, id in ipairs(elements) do
			local element = self:get_mission_element(id)

			if element then
				element:apply_custom_value(flag_value)
			end
		end
	else
		managers.editor:output_error("Element " .. self:editor_name() .. " doesn't have an action '" .. action .. "' function implemented.")
	end

	ElementGlobalStateOperator.super.on_executed(self, instigator)
end
