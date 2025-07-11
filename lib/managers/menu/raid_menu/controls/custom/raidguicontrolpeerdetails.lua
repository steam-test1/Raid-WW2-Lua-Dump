RaidGUIControlPeerDetails = RaidGUIControlPeerDetails or class(RaidGUIControl)
RaidGUIControlPeerDetails.FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlPeerDetails.NAME_X = 70
RaidGUIControlPeerDetails.NAME_FONT_SIZE = 26
RaidGUIControlPeerDetails.NAME_PADDING_DOWN = 10
RaidGUIControlPeerDetails.NAME_COLOR = tweak_data.gui.colors.raid_light_red
RaidGUIControlPeerDetails.DEFAULT_W = 300
RaidGUIControlPeerDetails.DEFAULT_H = 64
RaidGUIControlPeerDetails.CLASS_ICON_PADDING_LEFT = 5
RaidGUIControlPeerDetails.ICON_TITLE_FONT_SIZE = 38
RaidGUIControlPeerDetails.ICON_FONT_SIZE = 14
RaidGUIControlPeerDetails.LEVEL_W = 64

function RaidGUIControlPeerDetails:init(parent, params)
	RaidGUIControlPeerDetails.super.init(self, parent, params)

	if not params then
		Application:error("[RaidGUIControlPeerDetails:init] Parameters not specified for the peer details control " .. tostring(self._name))

		return
	end

	self._pointer_type = "arrow"

	self:highlight_off()
	self:_create_panel()
	self:_create_profile_name()
	self:_create_profile_details()
end

function RaidGUIControlPeerDetails:_create_panel()
	local panel_params = clone(self._params)

	panel_params.name = panel_params.name .. "_panel"
	panel_params.layer = self._panel:layer() + 1
	panel_params.x = self._params.x or 0
	panel_params.y = self._params.y or 0
	panel_params.w = self._params.w or RaidGUIControlPeerDetails.DEFAULT_W
	panel_params.h = RaidGUIControlPeerDetails.DEFAULT_H
	self._object = self._panel:panel(panel_params)
end

function RaidGUIControlPeerDetails:_create_profile_name()
	local profile_name_params = {
		align = "left",
		color = tweak_data.gui.colors.raid_black,
		font = RaidGUIControlPeerDetails.FONT,
		font_size = RaidGUIControlPeerDetails.NAME_FONT_SIZE,
		h = 32,
		name = "profile_name",
		text = "PROFILE NAME",
		vertical = "center",
		w = self._object:w() - RaidGUIControlPeerDetails.NAME_X - RaidGUIControlPeerDetails.LEVEL_W,
		x = RaidGUIControlPeerDetails.NAME_X,
		y = 0,
	}

	self._profile_name = self._object:text(profile_name_params)
end

function RaidGUIControlPeerDetails:_create_profile_details()
	local class_icon_params = {
		color = tweak_data.gui.colors.raid_black,
		name = "class_icon",
		texture = tweak_data.gui.icons.ico_class_infiltrator.texture,
		texture_rect = tweak_data.gui.icons.ico_class_infiltrator.texture_rect,
	}

	self._class_icon = self._object:bitmap(class_icon_params)

	self._class_icon:set_center_y(self._object:h() / 2)

	local nationality_params = {
		align = "left",
		color = tweak_data.gui.colors.raid_black,
		font = RaidGUIControlPeerDetails.FONT,
		font_size = tweak_data.gui.font_sizes.extra_small,
		h = 32,
		name = "nationality",
		text = "GERMAN",
		vertical = "center",
		w = self._object:w() - RaidGUIControlPeerDetails.NAME_X,
		x = RaidGUIControlPeerDetails.NAME_X,
		y = 0,
	}

	self._nationality = self._object:text(nationality_params)

	self._nationality:set_bottom(self._object:h())

	local level_text_params = {
		align = "center",
		color = tweak_data.gui.colors.raid_black,
		font = RaidGUIControlPeerDetails.FONT,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = 32,
		name = "level_text",
		text = "10",
		vertical = "center",
		w = RaidGUIControlPeerDetails.LEVEL_W,
	}

	self._level_text = self._object:text(level_text_params)

	self._level_text:set_right(self._object:w())
end

function RaidGUIControlPeerDetails:set_profile_name(name)
	if managers.user:get_setting("capitalize_names") then
		name = utf8.to_upper(name)
	end

	self._profile_name:set_text(name)
end

function RaidGUIControlPeerDetails:set_class(character_class)
	self._class_icon:set_image(tweak_data.gui.icons["ico_class_" .. character_class].texture)
	self._class_icon:set_texture_rect(unpack(tweak_data.gui.icons["ico_class_" .. character_class].texture_rect))
end

function RaidGUIControlPeerDetails:set_nationality(nationality)
	local params = {
		icon_h = 48,
		text_size = RaidGUIControlPeerDetails.ICON_FONT_SIZE,
	}

	self._nationality:set_text(utf8.to_upper(managers.localization:text("nationality_" .. nationality)))
end

function RaidGUIControlPeerDetails:set_level(level)
	self._level_text:set_text(tostring(level))
end

function RaidGUIControlPeerDetails:close()
	return
end
