core:import("CoreMissionScriptElement")

ElementWaypoint = ElementWaypoint or class(CoreMissionScriptElement.MissionScriptElement)

function ElementWaypoint:init(...)
	ElementWaypoint.super.init(self, ...)

	self._network_execute = true
	self._waypoint_shown = nil

	if self._values.icon == "guis/textures/waypoint2" or self._values.icon == "guis/textures/waypoint" then
		self._values.icon = "wp_standard"
	end
end

function ElementWaypoint:_get_unique_id()
	return self._sync_id .. self._id
end

function ElementWaypoint:on_script_activated()
	self._mission_script:add_save_state_cb(self._id)
end

function ElementWaypoint:client_on_executed(...)
	self:on_executed(...)
end

function ElementWaypoint:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:_add_waypoint()
	ElementWaypoint.super.on_executed(self, instigator)
end

function ElementWaypoint:_add_waypoint()
	Application:debug("[ElementWaypoint] self._values.icon", inspect(self._values))

	local text = managers.localization:text(self._values.text_id)
	local map_icon = self._values.map_display == "icon" and self._values.icon or nil
	local wp_data = tweak_data.gui.icons[self._values.icon] or tweak_data.gui.icons.wp_standard
	local wp_color = wp_data and wp_data.color or Color(1, 1, 1)
	local pos, rot = self:get_orientation()

	managers.hud:add_waypoint(self:_get_unique_id(), {
		distance = true,
		icon = self._values.icon,
		map_icon = map_icon,
		position = pos,
		range_max = self._values.range_max,
		range_min = self._values.range_min,
		show_on_screen = true,
		state = "sneak_present",
		text = text,
		waypoint_color = wp_color,
		waypoint_depth = self._values.depth,
		waypoint_display = self._values.map_display,
		waypoint_radius = self._values.radius,
		waypoint_type = "objective",
		waypoint_width = self._values.width,
	})

	self._waypoint_shown = true
end

function ElementWaypoint:operation_add()
	self:_add_waypoint()
end

function ElementWaypoint:operation_remove()
	if self._waypoint_shown then
		managers.hud:remove_waypoint(self:_get_unique_id())

		self._waypoint_shown = nil
	end
end

function ElementWaypoint:pre_destroy()
	if self._waypoint_shown then
		managers.hud:remove_waypoint(self:_get_unique_id())

		self._waypoint_shown = nil
	end
end
