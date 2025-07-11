HUDChatMessage = HUDChatMessage or class()
HUDChatMessage.W = 320
HUDChatMessage.NAME_H = 32
HUDChatMessage.NAME_FONT = tweak_data.gui.fonts.din_compressed_outlined_20
HUDChatMessage.NAME_FONT_SIZE = tweak_data.gui.font_sizes.size_20
HUDChatMessage.MESSAGE_FONT = tweak_data.gui.fonts.lato_outlined_18
HUDChatMessage.MESSAGE_FONT_SIZE = tweak_data.gui.font_sizes.size_18
HUDChatMessage.MESSAGE_PADDING_DOWN = 5
HUDChatMessage.PLAYER_MESSAGE_COLOR = tweak_data.gui.colors.chat_player_message
HUDChatMessage.PEER_MESSAGE_COLOR = tweak_data.gui.colors.chat_peer_message
HUDChatMessage.SYSTEM_MESSAGE_COLOR = tweak_data.gui.colors.chat_system_message
HUDChatMessagePlayer = HUDChatMessagePlayer or class(HUDChatMessage)

function HUDChatMessagePlayer:init(message_panel, name, message, peer_id)
	self._message_color = HUDChatMessage.PLAYER_MESSAGE_COLOR
	self._horizontal_text_align = "right"

	local player_name = managers.network:session():local_peer():name()

	HUDChatMessagePlayer.super.init(self, message_panel, player_name, message, peer_id)
end

HUDChatMessagePeer = HUDChatMessagePeer or class(HUDChatMessage)

function HUDChatMessagePeer:init(message_panel, name, message, peer_id)
	self._message_color = HUDChatMessage.PEER_MESSAGE_COLOR
	self._horizontal_text_align = "left"

	local peer_name = managers.network:session():peer(peer_id):name()

	HUDChatMessagePeer.super.init(self, message_panel, peer_name, message, peer_id)
end

HUDChatMessageSystem = HUDChatMessageSystem or class(HUDChatMessage)

function HUDChatMessageSystem:init(message_panel, name, message)
	self._message_color = HUDChatMessage.SYSTEM_MESSAGE_COLOR
	self._horizontal_text_align = "left"
	self._system_message = true

	local system_name = managers.localization:to_upper_text("menu_system_message")

	HUDChatMessageSystem.super.init(self, message_panel, system_name, message)
end

function HUDChatMessage:init(message_panel, name, message, peer_id)
	self._messages = {}

	self:_create_panel(message_panel)
	self:_create_name(name)
	self:_create_message_panel()
	self:add_message(message)

	self._peer_id = peer_id
end

function HUDChatMessage:_create_panel(message_panel)
	local panel_params = {
		halign = "scale",
		name = "player_message_panel",
		valign = "bottom",
		w = HUDChatMessage.W,
	}

	self._object = message_panel:panel(panel_params)
end

function HUDChatMessage:_create_name(name)
	if managers.user:get_setting("capitalize_names") then
		name = utf8.to_upper(name)
	end

	local name_params = {
		align = self._horizontal_text_align,
		color = self._message_color,
		font = HUDChatMessage.NAME_FONT,
		font_size = HUDChatMessage.NAME_FONT_SIZE,
		h = HUDChatMessage.NAME_H,
		halign = "scale",
		layer = 20,
		name = "name",
		text = name,
		valign = "top",
		vertical = "center",
		w = self._object:w(),
		x = 0,
		y = 0,
	}

	self._name = self._object:text(name_params)
end

function HUDChatMessage:_create_message_panel()
	local message_panel_params = {
		h = self._object:h() - self._name:h(),
		halign = "scale",
		name = "message_panel",
		valign = "bottom",
		w = self._object:w(),
		x = 0,
		y = self._name:y() + self._name:h(),
	}

	self._message_panel = self._object:panel(message_panel_params)
end

function HUDChatMessage:_create_message(message)
	local message_params = {
		align = self._horizontal_text_align,
		color = self._message_color,
		font = HUDChatMessage.MESSAGE_FONT,
		font_size = HUDChatMessage.MESSAGE_FONT_SIZE,
		halign = "scale",
		name = "message",
		text = message,
		valign = "bottom",
		vertical = "center",
		w = self._object:w(),
		wrap = true,
		x = 0,
		y = self._name:h(),
	}

	self._message = self._object:text(message_params)

	local _, _, _, h = self._message:text_rect()

	self._message:set_h(h)
end

function HUDChatMessage:_size_panel()
	local h = self._name:h()
	local bottom = self._message_panel:h()

	for i = #self._messages, 1, -1 do
		self._messages[i]:set_bottom(bottom)

		bottom = bottom - self._messages[i]:h() - HUDChatMessage.MESSAGE_PADDING_DOWN
		h = h + self._messages[i]:h() + HUDChatMessage.MESSAGE_PADDING_DOWN
	end

	if h > self._object:parent():h() then
		h = self._object:parent():h()
	end

	self._object:set_h(h)
	self._name:set_y(0)
	self._message_panel:set_h(h - self._name:h())
	self._message_panel:set_bottom(h)
end

function HUDChatMessage:add_message(message)
	local message_params = {
		align = self._horizontal_text_align,
		color = self._message_color,
		font = HUDChatMessage.MESSAGE_FONT,
		font_size = HUDChatMessage.MESSAGE_FONT_SIZE,
		halign = "scale",
		name = "message_" .. tostring(#self._messages + 1),
		text = message,
		valign = "bottom",
		vertical = "center",
		w = self._message_panel:w(),
		wrap = true,
		x = 0,
		y = 0,
	}
	local new_message = self._message_panel:text(message_params)
	local _, _, _, h = new_message:text_rect()

	new_message:set_h(h)

	local y = 0

	for i = 1, #self._messages do
		y = y + self._messages[i]:h() + HUDChatMessage.MESSAGE_PADDING_DOWN
	end

	new_message:set_y(y)
	table.insert(self._messages, new_message)
	self:_size_panel()
end

function HUDChatMessage:destroy()
	self._object:clear()
	self._object:parent():remove(self._object)
end

function HUDChatMessage:x()
	return self._object:x()
end

function HUDChatMessage:y()
	return self._object:y()
end

function HUDChatMessage:w()
	return self._object:w()
end

function HUDChatMessage:h()
	return self._object:h()
end

function HUDChatMessage:set_x(x)
	self._object:set_x(x)
end

function HUDChatMessage:set_y(y)
	self._object:set_y(y)
end

function HUDChatMessage:set_top(top)
	self._object:set_top(top)
end

function HUDChatMessage:set_bottom(bottom)
	if bottom > 0 and bottom - self:h() < 0 then
		local h = bottom
		local new_message_panel_height = h - self._name:h()

		if new_message_panel_height < self._messages[#self._messages]:h() then
			new_message_panel_height = self._messages[#self._messages]:h()
			h = self._name:h() + new_message_panel_height
		end

		self._message_panel:set_h(new_message_panel_height)
		self._object:set_h(h)
		self._message_panel:set_bottom(h)
	end

	self._object:set_bottom(bottom)
end

function HUDChatMessage:peer_id()
	return self._peer_id
end

function HUDChatMessage:system_message()
	return self._system_message or false
end
