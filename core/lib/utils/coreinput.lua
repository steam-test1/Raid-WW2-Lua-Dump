core:module("CoreInput")
core:import("CoreClass")

local IDS_SHIFT_L = Idstring("left shift")
local IDS_SHIFT_R = Idstring("right shift")

function shift()
	return Input:keyboard():down(IDS_SHIFT_L) or Input:keyboard():down(IDS_SHIFT_R)
end

local IDS_CTRL_L = Idstring("left ctrl")
local IDS_CTRL_R = Idstring("right ctrl")

function ctrl()
	return Input:keyboard():down(IDS_CTRL_L) or Input:keyboard():down(IDS_CTRL_R)
end

local IDS_ALT_L = Idstring("left alt")
local IDS_ALT_R = Idstring("right alt")

function alt()
	return Input:keyboard():down(IDS_ALT_L)
end

RepKey = RepKey or CoreClass.class()

function RepKey:init(keys, pause, rep)
	self._keys = keys or {}
	self._current_time = 0
	self._current_rep_time = 0
	self._pause = pause or 0.5
	self._rep = rep or 0.1
	self._input = Input:keyboard()
end

function RepKey:set_input(input)
	self._input = input
end

function RepKey:update(d, dt)
	local anykey = false

	for _, key in ipairs(self._keys) do
		if self._input:down(Idstring(key)) then
			anykey = true

			break
		end
	end

	local down = false

	if anykey then
		if self._current_time == 0 then
			down = true
		end

		if self._current_time >= self._pause then
			down = true

			if self._current_rep_time >= self._rep then
				down = true
				self._current_rep_time = 0
			else
				down = false
				self._current_rep_time = self._current_rep_time + dt
			end
		else
			self._current_time = self._current_time + dt
		end
	else
		self._current_time = 0
		self._current_rep_time = 0
	end

	return down
end
