core:import("CoreMissionScriptElement")

ElementDifficulty = ElementDifficulty or class(CoreMissionScriptElement.MissionScriptElement)

function ElementDifficulty:init(...)
	ElementDifficulty.super.init(self, ...)
end

function ElementDifficulty:client_on_executed(...)
	return
end

function ElementDifficulty:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_difficulty(self._values.difficulty + managers.enemy:commander_difficulty())
	ElementDifficulty.super.on_executed(self, instigator)
end
