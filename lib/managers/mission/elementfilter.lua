core:import("CoreMissionScriptElement")

ElementFilter = ElementFilter or class(CoreMissionScriptElement.MissionScriptElement)

function ElementFilter:init(...)
	ElementFilter.super.init(self, ...)
end

function ElementFilter:client_on_executed(...)
	self:on_executed(...)
end

function ElementFilter:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if not self:_check_platform() then
		return
	end

	if not self:_check_difficulty() then
		return
	end

	if not self:_check_players() then
		return
	end

	if not self:_check_mode() then
		return
	end

	if not self:_check_alarm() then
		return
	end

	ElementFilter.super.on_executed(self, instigator)
end

local pc_only = Idstring("PC")
local console_only = Idstring("CONSOLE")

function ElementFilter:_check_platform()
	local simulation_platform = Global.running_simulation and Idstring(managers.editor:mission_platform())

	if self._values.platform_win32 then
		if simulation_platform then
			if simulation_platform == pc_only then
				return true
			end
		elseif IS_PC then
			return true
		end
	end

	if self._values.platform_console then
		if simulation_platform then
			if simulation_platform == console_only then
				return true
			end
		elseif IS_CONSOLE then
			return true
		end
	end

	return false
end

function ElementFilter:_check_difficulty()
	local diff = Global.game_settings and Global.game_settings.difficulty or Global.DEFAULT_DIFFICULTY
	local diff_list = tweak_data.difficulties

	if self._values.difficulty_normal and diff == diff_list[1] then
		return true
	end

	if self._values.difficulty_hard and diff == diff_list[2] then
		return true
	end

	if self._values.difficulty_overkill and diff == diff_list[3] then
		return true
	end

	if self._values.difficulty_overkill_145 and diff == diff_list[4] then
		return true
	end

	return false
end

function ElementFilter:_check_players()
	local players = Global.running_simulation and managers.editor:mission_player()

	players = players or managers.network:session() and managers.network:session():amount_of_players()

	if not players then
		return false
	end

	if self._values.player_1 and players == 1 then
		return true
	end

	if self._values.player_2 and players == 2 then
		return true
	end

	if self._values.player_3 and players == 3 then
		return true
	end

	if self._values.player_4 and players == 4 then
		return true
	end

	return false
end

function ElementFilter:_check_mode()
	if self._values.mode_control == nil or self._values.mode_assault == nil then
		return true
	end

	if managers.groupai:state():get_assault_mode() and self._values.mode_assault then
		return true
	end

	if not managers.groupai:state():get_assault_mode() and self._values.mode_control then
		return true
	end

	return false
end

function ElementFilter:_check_alarm()
	local alarm = managers.worldcollection:get_alarm_for_world(self._sync_id)

	if self._values.alarm_on == nil or self._values.alarm_off == nil then
		return true
	end

	if alarm and self._values.alarm_on then
		return true
	end

	if not alarm and self._values.alarm_off then
		return true
	end
end
