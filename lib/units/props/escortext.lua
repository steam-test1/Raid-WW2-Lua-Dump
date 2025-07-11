EscortExt = EscortExt or class()

function EscortExt:init(unit)
	self._unit = unit
	self._wp_offset = Vector3(0, 0, 200)
	self._wp_offset_hp = Vector3(0, 0, 175)
	self._was_safe = false
	self._safe_color = Color(1, 1, 1)
	self._unsafe_color = Color(1, 0, 0)
	self._ws = managers.hud:fullscreen_workspace()

	local tweak = self._unit:base():char_tweak()

	if not tweak.immortal and not self._unit:character_damage().immortal then
		self:_setup_health_bar()
		self:set_health_bar_visible(false)
	end

	if Network:is_server() then
		managers.enemy:add_delayed_clbk("EscortExt_set_logic" .. tostring(self._unit:key()), callback(self, self, "set_logic"), TimerManager:game():time())
	end

	self._unit:set_extension_update_enabled(Idstring("escort"), false)
end

function EscortExt:set_logic()
	if Network:is_client() then
		return
	end

	if not self._unit:brain():is_objective_type("escort") then
		self._unit:brain():set_objective({
			allow_cool = true,
			type = "escort",
		})
	end
end

function EscortExt:destroy()
	self:remove_health_bar()
	self:remove_waypoint()
end

function EscortExt:_setup_health_bar()
	self._health_panel = self._ws:panel():panel({})
	self._health_bar_bg = self._health_panel:bitmap({
		halign = "center",
		layer = -1,
		name = "bg",
		texture = tweak_data.gui.icons[HUDTeammatePlayer.PLAYER_HEALTH_BG_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammatePlayer.PLAYER_HEALTH_BG_ICON].texture_rect,
		valign = "center",
	})

	self._health_bar_bg:set_w(self._health_bar_bg:w() / 2)
	self._health_panel:set_w(self._health_bar_bg:w())
	self._health_panel:set_h(self._health_bar_bg:h())
	self._health_bar_bg:set_center_x(self._health_panel:w() / 2)
	self._health_bar_bg:set_center_y(self._health_panel:h() / 2)

	self._health_bar = self._health_panel:rect({
		color = tweak_data.gui.colors.progress_75,
		h = self._health_bar_bg:h() - 2,
		name = "fg",
		w = self._health_bar_bg:w() - 2,
	})

	self._health_bar:set_center_x(self._health_panel:w() / 2)
	self._health_bar:set_center_y(self._health_panel:h() / 2)
	self:update_health_bar()
end

function EscortExt:update_health_bar()
	if not alive(self._health_panel) then
		return
	end

	local full_size = self._health_panel:w() - 2
	local new_size = full_size * self._unit:character_damage():health_ratio()

	self._health_bar:set_w(new_size)
end

function EscortExt:remove_health_bar()
	if not alive(self._health_panel) then
		return
	end

	self._health_panel:parent():remove(self._health_panel)

	self._health_panel = nil
	self._health_bar = nil
	self._health_bar_bg = nil
end

function EscortExt:set_health_bar_visible(visible)
	if not alive(self._health_panel) then
		return
	end

	self._health_panel:set_visible(visible)

	self._health_visible = visible
end

function EscortExt:has_waypoint()
	return self._has_waypoint
end

function EscortExt:add_waypoint()
	if self._has_waypoint then
		self:remove_waypoint()
	end

	self._position = self._unit:position() + self._wp_offset
	self._rotation = self._unit:rotation()
	self._waypoint_data = {
		blend_mode = "add",
		color = self._unsafe_color,
		distance = true,
		icon = "waypoint_escort_crouch",
		map_icon = "waypoint_escort_crouch",
		no_sync = true,
		position = self._position,
		present_timer = 0,
		radius = 200,
		rotation = self._rotation,
		show_on_screen = true,
		unit = self._unit,
		waypoint_color = self._unsafe_color,
		waypoint_type = "unit_waypoint",
	}
	self._icon_id = tostring(self._unit:key())

	managers.hud:add_waypoint(self._icon_id, self._waypoint_data)
	self._unit:set_extension_update_enabled(Idstring("escort"), true)

	self._has_waypoint = true
end

function EscortExt:remove_waypoint()
	if not self._has_waypoint then
		return
	end

	managers.hud:remove_waypoint(self._icon_id)
	self._unit:set_extension_update_enabled(Idstring("escort"), false)

	self._has_waypoint = false
end

function EscortExt:is_safe()
	local someone_close = false
	local char_tweak = tweak_data.character[self._unit:base()._tweak_table]
	local min_dis_sq = char_tweak and char_tweak.escort_safe_dist or 1000

	min_dis_sq = min_dis_sq * min_dis_sq

	for c_key, c_data in pairs(managers.groupai:state():all_char_criminals()) do
		if min_dis_sq > mvector3.distance_sq(c_data.m_pos, self._unit:position()) then
			someone_close = true

			break
		end
	end

	return someone_close
end

local health_pos = Vector3()
local health_dir = Vector3()
local cam_dir = Vector3()

function EscortExt:update(t, dt)
	if self._has_waypoint then
		mvector3.set(self._position, self._unit:position() + self._wp_offset)

		local rotation = self._unit:rotation()

		mrotation.set_yaw_pitch_roll(self._rotation, rotation:yaw(), rotation:pitch(), rotation:roll())

		if not self._was_safe and self:is_safe() then
			self:set_waypoint_safe(true)

			self._was_safe = true
		elseif self._was_safe and not self:is_safe() then
			self:set_waypoint_safe(false)

			self._was_safe = false

			local char_tweak = tweak_data.character[self._unit:base()._tweak_table]

			if char_tweak and char_tweak.unsafe_vo then
				self._unit:sound():say(char_tweak.unsafe_vo, true)
			end
		end
	end

	if alive(self._health_bar) and self._health_visible then
		local cam = managers.viewport:get_current_camera()

		if not cam then
			return
		end

		mvector3.set(cam_dir, cam:rotation():y())
		mvector3.set(health_dir, self._unit:position())
		mvector3.subtract(health_dir, cam:position())
		mvector3.normalize(health_dir)

		local dot = mvector3.dot(cam_dir, health_dir)

		if dot < 0 then
			self._health_panel:hide()
		else
			mvector3.set(health_pos, self._ws:world_to_screen(cam, self._unit:position() + self._wp_offset_hp))
			self._health_panel:set_center(health_pos.x, health_pos.y)
			self._health_panel:show()
		end
	end
end

function EscortExt:set_waypoint_safe(safe)
	local final_color = safe and self._safe_color or self._unsafe_color
	local final_icon = safe and "waypoint_escort_stand" or "waypoint_escort_crouch"

	managers.hud:change_waypoint_distance_color(self._icon_id, final_color)
	managers.hud:change_waypoint_arrow_color(self._icon_id, final_color)
	managers.hud:change_waypoint_icon_color(self._icon_id, final_color)
	managers.hud:change_waypoint_icon(self._icon_id, final_icon)
end

function EscortExt:set_active(active)
	self._active = active

	if active then
		if not self:has_waypoint() then
			self:add_waypoint()
			self:set_waypoint_safe(self:is_safe())
		end
	else
		self:remove_waypoint()
	end

	self:set_health_bar_visible(active)

	if Network:is_server() then
		self._unit:network():send("set_escort_active", active)
	end
end

function EscortExt:active()
	return self._active
end

function EscortExt:save(data)
	data.escort = {}

	if self._has_waypoint then
		data.escort.has_waypoint = true
		data.escort.was_safe = self._was_safe
	end

	data.escort.health_visible = self._health_visible
end

function EscortExt:load(data)
	if data.escort.has_waypoint then
		self:add_waypoint()
		self:set_waypoint_safe(data.escort.was_safe)
	end

	self:set_health_bar_visible(data.escort.health_visible)
end
