Ladder = Ladder or class()
Ladder.ladders = Ladder.ladders or {}
Ladder.active_ladders = Ladder.active_ladders or {}
Ladder.ladder_index = 1
Ladder.LADDERS_PER_FRAME = 100
Ladder.DEBUG = false
Ladder.EVENT_IDS = {}
LadderExtended = LadderExtended or class(Ladder)

function LadderExtended:init(unit)
	LadderExtended.super.init(self, unit)

	self.g_top = not not self.g_top and Idstring(self.g_top) or false
	self.g_mid = not not self.g_mid and Idstring(self.g_mid) or false
	self.g_bot = not not self.g_bot and Idstring(self.g_bot) or false
	self.g_top_height = self.g_top_height or 25
	self.g_mid_height = self.g_mid_height or 25
	self.g_bot_height = self.g_bot_height or 25
	self.prop_yaw = self.prop_yaw or 180
	self._ladder_graphics_spawned = 0
	self._ladder_graphics = {}
end

function LadderExtended:destroy(unit)
	self:despawn_prop_units()
	LadderExtended.super.destroy(self, unit)
end

function LadderExtended:save(data)
	LadderExtended.super.save(self, data)

	data.LadderExtended.show_props = self._ladder_graphics_spawned ~= 0
end

function LadderExtended:load(data)
	LadderExtended.super.load(self, data)

	if data.LadderExtended.show_props then
		self:spawn_prop_units()
	end
end

function LadderExtended:set_height(v)
	LadderExtended.super.set_height(self, v)

	if self._ladder_graphics_spawned > 0 then
		self:despawn_prop_units()
		self:spawn_prop_units()
	end
end

function LadderExtended:set_enabled(enabled, show_props)
	LadderExtended.super.set_enabled(self, enabled)

	if show_props == nil then
		return
	end

	if not self._enabled and self._ladder_graphics_spawned > 0 then
		self:despawn_prop_units()
	elseif self._enabled then
		self:spawn_prop_units()
	end
end

function LadderExtended:despawn_prop_units()
	for _, unit in ipairs(self._ladder_graphics) do
		if alive(unit) then
			unit:set_slot(0)
		end
	end

	self._ladder_graphics_spawned = 0
end

function LadderExtended:spawn_prop_units()
	local mid_parts = math.floor((self._height - self.g_bot_height - self.g_top_height - self._exit_on_top_offset - 10) / self.g_mid_height)
	local rot = self._ladder_orientation_obj:rotation()

	rot = Rotation(rot:yaw() + self.prop_yaw, rot:pitch(), rot:roll())

	local pos = self._ladder_orientation_obj:position()
	local _spawned_unit

	_spawned_unit = safe_spawn_unit(self.g_bot, pos, rot)

	table.insert(self._ladder_graphics, _spawned_unit)

	self._ladder_graphics_spawned = 1
	pos = pos + self._up * self.g_bot_height

	for i = 0, mid_parts do
		_spawned_unit = safe_spawn_unit(self.g_mid, pos, rot)

		table.insert(self._ladder_graphics, _spawned_unit)

		self._ladder_graphics_spawned = self._ladder_graphics_spawned + 1
		pos = pos + self._up * self.g_mid_height
	end

	_spawned_unit = safe_spawn_unit(self.g_top, pos, rot)

	table.insert(self._ladder_graphics, _spawned_unit)

	self._ladder_graphics_spawned = self._ladder_graphics_spawned + 1
end

function Ladder.current_ladder()
	return Ladder.active_ladders[Ladder.ladder_index]
end

function Ladder.next_ladder()
	Ladder.ladder_index = Ladder.ladder_index + 1

	if Ladder.ladder_index > #Ladder.active_ladders then
		Ladder.ladder_index = 1
	end

	return Ladder.current_ladder()
end

function Ladder:init(unit)
	self._unit = unit
	self.normal_axis = self.normal_axis or "y"
	self.up_axis = self.up_axis or "z"
	self._offset = self._offset or 0
	self._offset_normal = self._offset_normal or 0

	self:set_enabled(true)

	self._climb_on_top_offset = 30
	self._exit_on_top_offset = 20
	self._normal_target_offset = self._normal_target_offset or 40

	self:set_config()
	table.insert(Ladder.ladders, self._unit)
end

function Ladder:set_config()
	self._ladder_orientation_obj = self._unit:get_object(Idstring(self._ladder_orientation_obj_name))

	local rotation = self._ladder_orientation_obj:rotation()
	local position = self._ladder_orientation_obj:position()

	self._normal = rotation[self.normal_axis](rotation)

	if self.invert_normal_axis then
		mvector3.multiply(self._normal, -1)
	end

	self._up = rotation[self.up_axis](rotation)
	self._w_dir = math.cross(self._up, self._normal)
	position = position + self._up * self._offset
	position = position + self._normal * self._offset_normal

	local top = position + self._up * self._height

	self._bottom = position
	self._top = top
	self._rotation = Rotation(self._w_dir, self._up, self._normal)
	self._corners = {
		position - self._w_dir * self._width / 2,
		position + self._w_dir * self._width / 2,
		top + self._w_dir * self._width / 2,
		top - self._w_dir * self._width / 2,
	}
end

function Ladder:update(t, dt)
	if Ladder.DEBUG then
		self:debug_draw()
	end
end

local mvec1 = Vector3()

function Ladder:can_access(pos, move_dir)
	if not self._enabled then
		return
	end

	if Ladder.DEBUG then
		local brush = Draw:brush(Color.red)

		brush:cylinder(self._bottom, self._top, 5)
	end

	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._corners[1])

	local n_dot = mvector3.dot(self._normal, mvec1)

	if n_dot < 0 or n_dot > 50 then
		return false
	end

	local w_dot = mvector3.dot(self._w_dir, mvec1)

	if w_dot < 0 or w_dot > self._width then
		return false
	end

	local h_dot = mvector3.dot(self._up, mvec1)

	if h_dot < 0 or h_dot > self._height then
		return false
	end

	local towards_dot = mvector3.dot(move_dir, self._normal)

	if h_dot > self._height - self._climb_on_top_offset then
		return towards_dot > 0.5
	end

	if towards_dot < -0.5 then
		return true
	end
end

function Ladder:check_end_climbing(pos, move_dir, gnd_ray)
	if not self._enabled then
		return true
	end

	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._corners[1])

	local w_dot = mvector3.dot(self._w_dir, mvec1)
	local h_dot = mvector3.dot(self._up, mvec1)

	if w_dot < 0 or w_dot > self._width then
		return true
	elseif h_dot < 0 or h_dot > self._height + self._exit_on_top_offset then
		return true
	elseif gnd_ray and move_dir then
		local towards_dot = mvector3.dot(move_dir, self._normal)

		if towards_dot > 0 then
			if h_dot > self._height - self._climb_on_top_offset then
				return false
			end

			return true
		end
	end
end

function Ladder:get_normal_move_offset(pos)
	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._corners[1])

	local normal_move_offset = math.dot(self._normal, mvec1)
	local h_dot = mvector3.dot(self._up, mvec1)

	normal_move_offset = h_dot > self._height and h_dot < self._height + self._exit_on_top_offset and -1 or math.lerp(0, self._normal_target_offset - normal_move_offset, 0.1)

	return normal_move_offset
end

function Ladder:rotation()
	return self._rotation
end

function Ladder:up()
	return self._up
end

function Ladder:normal()
	return self._normal
end

function Ladder:w_dir()
	return self._w_dir
end

function Ladder:bottom()
	return self._bottom
end

function Ladder:top()
	return self._top
end

function Ladder:set_width(width)
	self._width = width

	self:set_config()
end

function Ladder:width()
	return self._width
end

function Ladder:set_height(height)
	self._height = height

	self:set_config()
end

function Ladder:height()
	return self._height
end

function Ladder:corners()
	return self._corners
end

function Ladder:set_enabled(enabled)
	self._enabled = enabled

	if self._enabled then
		if not table.contains(Ladder.active_ladders, self._unit) then
			table.insert(Ladder.active_ladders, self._unit)
		end
	else
		table.delete(Ladder.active_ladders, self._unit)
	end
end

function Ladder:destroy(unit)
	table.delete(Ladder.ladders, self._unit)
	table.delete(Ladder.active_ladders, self._unit)
end

function Ladder:debug_draw()
	local brush = Draw:brush(Color.white:with_alpha(0.5))

	brush:quad(self._corners[1], self._corners[2], self._corners[3], self._corners[4])

	for i = 1, 4 do
		brush:line(self._corners[i], self._corners[i] + self._normal * (50 + i * 25))
	end

	local brush = Draw:brush(Color.red)

	brush:sphere(self._corners[1], 5)
end

function Ladder:save(data)
	local state = {}

	state.enabled = self._enabled
	state.height = self._height
	state.width = self._width
	data.Ladder = state
end

function Ladder:load(data)
	local state = data.Ladder

	if state.enabled ~= self._enabled then
		self:set_enabled(state.enabled)
	end

	self._width = state.width
	self._height = state.height

	self:set_config()
end

function Ladder:setup_load(data)
	if not data.ladder then
		return
	end

	self:set_width(data.ladder.width)
	self:set_height(data.ladder.height)
end

if Application:editor() then
	function Ladder:editor_save(data)
		local state = {
			height = self:height(),
			width = self:width(),
		}

		data.ladder = state
	end
end
