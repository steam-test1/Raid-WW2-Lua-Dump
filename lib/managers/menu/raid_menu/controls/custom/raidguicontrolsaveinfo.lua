RaidGUIControlSaveInfo = RaidGUIControlSaveInfo or class(RaidGUIControl)

function RaidGUIControlSaveInfo:init(parent, params)
	RaidGUIControlSaveInfo.super.init(self, parent, params)

	self._on_click_callback = params.on_click_callback

	self:_create_panel()
	self:_create_info_icons()
	self:_create_peer_details()
end

function RaidGUIControlSaveInfo:_create_panel()
	local panel_params = clone(self._params)

	panel_params.name = panel_params.name .. "_panel"
	panel_params.layer = panel_params.layer or self._panel:layer() + 1
	panel_params.x = self._params.x or 0
	panel_params.y = self._params.y or 0
	panel_params.w = self._params.w or self._panel:w()
	panel_params.h = self._params.h or self._panel:h()
	self._object = self._panel:panel(panel_params)
end

function RaidGUIControlSaveInfo:_create_info_icons()
	local info_icons_panel_params = {
		h = 96,
		name = "info_icons_panel",
		x = 0,
		y = 18,
		w = self._object:w() * 0.8,
	}

	self._info_icons_panel = self._object:panel(info_icons_panel_params)

	self._info_icons_panel:set_center_x(self._object:w() / 2)

	local h = self._info_icons_panel:h()
	local difficulty_info_params = {
		align = "left",
		icon = "difficulty_1",
		name = "difficulty_info",
		text = "",
		x = 0,
		y = 0,
	}

	self._difficulty_info_icon = self._info_icons_panel:info_icon(difficulty_info_params)

	if h < self._difficulty_info_icon:h() then
		h = self._difficulty_info_icon:h()
	end

	local server_info_params = {
		align = "center",
		icon = "ico_server",
		name = "server_info",
		x = 0,
		y = 0,
		text = self:translate("menu_save_info_server_type_title", true),
	}

	self._server_info_icon = self._info_icons_panel:info_icon(server_info_params)

	self._server_info_icon:set_center_x(self._info_icons_panel:w() / 2)

	if h < self._server_info_icon:h() then
		h = self._server_info_icon:h()
	end

	local loot_info_params = {
		align = "right",
		name = "loot_info",
		text = "0000",
		x = 0,
		y = 0,
		title = self:translate("menu_save_info_loot_title", true),
	}

	self._loot_info_icon = self._info_icons_panel:info_icon(loot_info_params)

	self._loot_info_icon:set_right(self._info_icons_panel:w())

	if h < self._loot_info_icon:h() then
		h = self._loot_info_icon:h()
	end

	self._info_icons_panel:set_h(h)
end

function RaidGUIControlSaveInfo:_create_peer_details()
	local peer_info_panel_params = {
		h = 512,
		name = "peer_info_panel",
		y = 132,
		w = self._info_icons_panel:w(),
		x = self._info_icons_panel:x(),
	}

	self._peer_info_panel = self._object:panel(peer_info_panel_params)
	self._peer_info_details = {}

	local y = 0

	for i = 1, 4 do
		local params = {
			x = 0,
			y = y,
		}
		local peer_details = self._peer_info_panel:create_custom_control(RaidGUIControlPeerDetails, params)

		table.insert(self._peer_info_details, peer_details)

		y = y + 128
	end
end

function RaidGUIControlSaveInfo:set_save_info(slot_index)
	local save_slot = managers.raid_job:get_save_slots()[slot_index]

	if not save_slot then
		return
	end

	self._difficulty_info_icon:set_icon(tostring(save_slot.difficulty), {
		color = Color.black,
	})
	self._difficulty_info_icon:set_text("menu_" .. tostring(save_slot.difficulty))

	local event_data = save_slot.event_data[#save_slot.event_data]
	local loot_acquired = 0

	for _, data in pairs(save_slot.event_data) do
		if data.loot_data then
			loot_acquired = loot_acquired + data.loot_data.acquired
		end
	end

	self._loot_info_icon:set_text(string.format("%04.0f", loot_acquired), {
		no_translate = true,
	})

	for i = 1, #self._peer_info_details do
		self._peer_info_details[i]:set_alpha(0)

		local peer_data = event_data.peer_data[i]

		if peer_data then
			local name

			if peer_data.is_local_player then
				name = self:translate("menu_save_info_you", true) .. " (" .. peer_data.name .. ")"
			elseif SystemInfo:platform() == Idstring("XB1") then
				name = managers.hud:get_character_name_by_nationality(peer_data.nationality)
			else
				name = peer_data.name
			end

			self._peer_info_details[i]:set_profile_name(name)
			self._peer_info_details[i]:set_class(peer_data.class)
			self._peer_info_details[i]:set_nationality(peer_data.nationality)
			self._peer_info_details[i]:set_level(peer_data.level)
			self._peer_info_details[i]:set_alpha(1)
		end
	end
end

function RaidGUIControlSaveInfo:set_left(left)
	self._object:set_left(left)
end

function RaidGUIControlSaveInfo:set_right(right)
	self._object:set_right(right)
end

function RaidGUIControlSaveInfo:set_top(top)
	self._object:set_top(top)
end

function RaidGUIControlSaveInfo:set_bottom(bottom)
	self._object:set_bottom(bottom)
end

function RaidGUIControlSaveInfo:set_center_x(center_x)
	self._object:set_center_x(center_x)
end

function RaidGUIControlSaveInfo:set_center_y(center_y)
	self._object:set_center_y(center_y)
end

function RaidGUIControlSaveInfo:close()
	return
end
