HUDMapTab = HUDMapTab or class()
HUDMapTab.BACKGROUND_LAYER = 1
HUDMapTab.INNER_PANEL_LAYER = 2
HUDMapTab.WAYPOINT_PANEL_LAYER = 3
HUDMapTab.PLAYER_PINS_LAYER = 5
HUDMapTab.PIN_PANEL_PADDING = 50

function HUDMapTab:init(panel, params)
	self:_create_panel(panel, params)
	self:_create_inner_panel()
	self:_create_pin_panel()
	self:_create_waypoint_panel()

	self._waypoints = {}
end

function HUDMapTab:_create_panel(panel, params)
	self._object = panel:panel({
		halign = "scale",
		layer = params.layer or panel:layer(),
		name = "map_panel",
		valign = "scale",
	})
end

function HUDMapTab:_create_inner_panel()
	self._inner_panel = self._object:panel({
		halign = "center",
		layer = HUDMapTab.INNER_PANEL_LAYER,
		name = "inner_panel",
		valign = "center",
	})
end

function HUDMapTab:_create_pin_panel()
	if self._object:child("player_pins_panel") then
		self._object:remove(self._object:child("player_pins_panel"))
	end

	local player_pins_panel = self._inner_panel:panel({
		halign = "scale",
		layer = HUDMapTab.PLAYER_PINS_LAYER,
		name = "player_pins_panel",
		valign = "scale",
	})
end

function HUDMapTab:_create_waypoint_panel()
	if self._object:child("waypoint_panel") then
		self._object:remove(self._object:child("waypoint_panel"))
	end

	local waypoint_panel = self._inner_panel:panel({
		halign = "scale",
		layer = HUDMapTab.WAYPOINT_PANEL_LAYER,
		name = "waypoint_panel",
		valign = "scale",
	})
end

function HUDMapTab:_setup_level(level, location)
	self:_set_level(level, location)
	self:_create_map_background()
	self:_fit_inner_panel()
	self:_create_base_icon()
	self:_create_player_pins()
	self:_create_waypoints()
	self:update()
end

function HUDMapTab:_fit_inner_panel()
	local panel_shape = self._tweak_data.panel_shape
	local background_panel = self._object:child("map_background_panel")
	local x = background_panel:x() + panel_shape.x - self.PIN_PANEL_PADDING
	local y = background_panel:y() + panel_shape.y - self.PIN_PANEL_PADDING
	local w = panel_shape.w + self.PIN_PANEL_PADDING * 2
	local h = panel_shape.h + self.PIN_PANEL_PADDING * 2

	self._inner_panel:set_shape(x, y, w, h)
end

function HUDMapTab:_create_player_pins()
	local pin_panel = self._inner_panel:child("player_pins_panel")

	pin_panel:clear()

	self._player_pins = {}

	self:_create_peer_pins(pin_panel)
	self:_create_ai_pins(pin_panel)

	if self._tweak_data and self._tweak_data.pin_scale then
		self:_scale_pins(self._tweak_data.pin_scale)
	end
end

function HUDMapTab:_create_peer_pins(panel)
	local peers = managers.network:session():all_peers()

	for index, peer in pairs(peers) do
		local peer_pin_params = {
			id = index,
			nationality = peer:character(),
		}
		local peer_pin = HUDMapPlayerPin:new(panel, peer_pin_params)

		if peer == managers.network:session():local_peer() then
			self._local_player_pin = peer_pin
		end

		table.insert(self._player_pins, peer_pin)
	end
end

function HUDMapTab:_create_ai_pins(panel)
	local ai_characters = managers.criminals:ai_criminals()
	local peer_pins_number = #self._player_pins

	for index, ai_character in pairs(ai_characters) do
		local peer_pin_params = {
			ai = true,
			id = peer_pins_number + index,
			nationality = ai_character.name,
		}
		local peer_pin = HUDMapPlayerPin:new(panel, peer_pin_params)

		table.insert(self._player_pins, peer_pin)
	end
end

function HUDMapTab:_create_map_background()
	if self._object:child("map_background_panel") then
		self._object:remove(self._object:child("map_background_panel"))
	end

	local map_texture = self._tweak_data.texture
	local gui_data = tweak_data.gui:get_full_gui_data(map_texture)
	local background_panel = self._object:panel({
		h = gui_data.texture_rect[4],
		halign = "center",
		layer = HUDMapTab.BACKGROUND_LAYER,
		name = "map_background_panel",
		valign = "center",
		w = gui_data.texture_rect[3],
	})

	background_panel:set_center_x(self._object:w() / 2)
	background_panel:set_center_y(self._object:h() / 2)

	local background_image = background_panel:bitmap({
		name = "background_image",
		texture = gui_data.texture,
		texture_rect = gui_data.texture_rect,
	})
end

function HUDMapTab:_create_base_icon()
	if self._inner_panel:child("base_icon") then
		self._inner_panel:remove(self._inner_panel:child("base_icon"))
	end

	if not self._tweak_data.base_location then
		return
	end

	local base_x, base_y = self:_get_map_position(self._tweak_data.base_location.x, self._tweak_data.base_location.y)
	local base_icon_texture = self._tweak_data.base_icon or "map_camp"
	local base_icon = self._inner_panel:bitmap({
		name = "base_icon",
		texture = tweak_data.gui.icons[base_icon_texture].texture,
		texture_rect = tweak_data.gui.icons[base_icon_texture].texture_rect,
	})

	base_icon:set_center_x(base_x)
	base_icon:set_center_y(base_y)
end

function HUDMapTab:_create_waypoints()
	local waypoint_panel = self._inner_panel:child("waypoint_panel")
	local waypoints = managers.hud:get_all_waypoints()

	waypoint_panel:clear()

	self._waypoints = {}

	for index, waypoint_data in pairs(waypoints) do
		self:_create_waypoint(waypoint_data)
	end
end

function HUDMapTab:_create_waypoint(waypoint_data)
	local waypoint_panel = self._inner_panel:child("waypoint_panel")

	if self._waypoints[waypoint_data.id_string] then
		self:remove_waypoint(waypoint_data.id_string)
	end

	if waypoint_data.waypoint_radius then
		waypoint_data.waypoint_radius = waypoint_data.waypoint_radius * self:_get_map_size_factor()
	end

	local waypoint = HUDMapWaypointBase.create(waypoint_panel, waypoint_data)

	if waypoint then
		self._waypoints[waypoint_data.id_string] = waypoint

		if self._tweak_data and self._tweak_data.pin_scale then
			waypoint:set_scale(self._tweak_data.pin_scale)
		end
	end
end

function HUDMapTab:show()
	if not self:_current_level_has_map() then
		return
	end

	local current_level = self:_get_current_player_level()

	if current_level ~= self._current_level then
		self:_setup_level(current_level, "default")
	end

	self._object:set_visible(true)

	self._shown = true
end

function HUDMapTab:hide()
	self._object:set_visible(false)

	self._shown = false
end

function HUDMapTab:refresh_peers()
	if not self:_current_level_has_map() then
		return
	end

	self:_create_player_pins()
end

function HUDMapTab:add_waypoint(data)
	self:_create_waypoint(data)
end

function HUDMapTab:remove_waypoint(id)
	if self._waypoints[id] then
		self._waypoints[id]:destroy()

		self._waypoints[id] = nil
	end
end

function HUDMapTab:peer_enter_vehicle(peer_id)
	if not self._player_pins then
		return
	end

	for _, player_pin in pairs(self._player_pins) do
		if player_pin:id() == peer_id then
			player_pin:set_hidden(true)

			return
		end
	end
end

function HUDMapTab:peer_exit_vehicle(peer_id)
	if not self._player_pins then
		return
	end

	for _, player_pin in pairs(self._player_pins) do
		if player_pin:id() == peer_id then
			player_pin:set_hidden(false)

			return
		end
	end
end

function HUDMapTab:update()
	if not self._shown then
		return
	end

	self:_update_peer_positions()
	self:_update_ai_positions()
	self:_update_waypoints()
end

function HUDMapTab:_get_current_player_level()
	local current_job = managers.raid_job:current_job()

	if not current_job or managers.raid_job:is_camp_loaded() then
		local camp = managers.raid_job:camp()

		return camp.level_id
	end

	if current_job.job_type == OperationsTweakData.JOB_TYPE_OPERATION then
		local current_event_id = current_job.events_index[current_job.current_event]
		local current_event = current_job.events[current_event_id]

		return current_event.level_id
	elseif current_job.job_type == OperationsTweakData.JOB_TYPE_RAID then
		return current_job.level_id
	end

	return nil
end

function HUDMapTab:_current_level_has_map()
	local player_world = self:_get_current_player_level()

	if player_world and tweak_data.levels[player_world] and tweak_data.levels[player_world].map then
		return true
	end

	return false
end

function HUDMapTab:_set_level(level, location)
	local map_data = tweak_data.levels[level] and tweak_data.levels[level].map

	if map_data then
		if not map_data[location] then
			location = "default"
		end

		self._current_level = level
		self._current_location = location
		self._tweak_data = map_data[self._current_location]
	else
		self._current_level = nil
		self._current_location = nil
		self._tweak_data = nil
	end
end

function HUDMapTab:clear()
	self._current_level = nil
	self._current_location = nil
	self._tweak_data = nil
end

function HUDMapTab:_scale_pins(scale)
	for _, pin in ipairs(self._player_pins) do
		pin:set_scale(scale)
	end
end

function HUDMapTab:set_location(location)
	location = location or "default"

	if self._current_level and self._current_location ~= location then
		self:_setup_level(self._current_level, location)
	end
end

function HUDMapTab:_update_peer_positions()
	local peers = managers.network:session():all_peers()

	for index, peer in pairs(peers) do
		local unit = peer:unit()
		local pin = self._player_pins[index]

		if alive(unit) then
			local map_x, map_y = self:_get_map_position(unit:position().x, unit:position().y)

			pin:show()
			pin:set_position(map_x, map_y)
		else
			pin:hide()
		end
	end
end

function HUDMapTab:_update_ai_positions()
	local ai_characters = managers.criminals:ai_criminals()
	local peer_pins_number = managers.network:session():count_all_peers()

	for index, ai_character in pairs(ai_characters) do
		if self._player_pins[peer_pins_number + index] then
			local unit = ai_character.unit
			local pin = self._player_pins[peer_pins_number + index]

			if alive(unit) then
				local map_x, map_y = self:_get_map_position(unit:position().x, unit:position().y)

				pin:show()
				pin:set_position(map_x, map_y)
			else
				pin:hide()
			end
		end
	end
end

function HUDMapTab:_update_waypoints()
	local all_waypoints = managers.hud:get_all_waypoints()

	for index, waypoint_data in pairs(all_waypoints) do
		if self._waypoints[index] then
			local map_x, map_y = self:_get_map_position(waypoint_data.position.x, waypoint_data.position.y)

			self._waypoints[index]:set_position(map_x, map_y)
			self._waypoints[index]:set_data(waypoint_data)
		end
	end
end

function HUDMapTab:_get_map_position(world_x, world_y)
	local world_borders = self._tweak_data.world_borders
	local map_x = self.PIN_PANEL_PADDING + (world_x - world_borders.left) / math.abs(world_borders.right - world_borders.left) * (self._inner_panel:w() - self.PIN_PANEL_PADDING * 2)
	local map_y = self.PIN_PANEL_PADDING + math.abs(world_y - world_borders.up) / math.abs(world_borders.down - world_borders.up) * (self._inner_panel:h() - self.PIN_PANEL_PADDING * 2)

	return map_x, map_y
end

function HUDMapTab:_get_map_size_factor()
	if not self._tweak_data or not self._tweak_data.world_borders then
		return 1
	end

	local world_w = self._tweak_data.world_borders.right - self._tweak_data.world_borders.left
	local map_w = self._inner_panel:w()

	return map_w / world_w
end

function HUDMapTab:set_x(x)
	self._object:set_x(x)
end

function HUDMapTab:set_y(y)
	self._object:set_y(y)
end

function HUDMapTab:w()
	return self._object:w()
end

function HUDMapTab:h()
	return self._object:h()
end
