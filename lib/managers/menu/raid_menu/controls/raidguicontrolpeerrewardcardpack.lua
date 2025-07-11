RaidGUIControlPeerRewardCardPack = RaidGUIControlPeerRewardCardPack or class(RaidGUIControl)
RaidGUIControlPeerRewardCardPack.WIDTH = 544
RaidGUIControlPeerRewardCardPack.HEIGHT = 96
RaidGUIControlPeerRewardCardPack.ICON = "rwd_card_pack"
RaidGUIControlPeerRewardCardPack.DESCRIPTION = "menu_loot_screen_card_pack"
RaidGUIControlPeerRewardCardPack.FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlPeerRewardCardPack.NAME_Y = 12
RaidGUIControlPeerRewardCardPack.NAME_COLOR = tweak_data.gui.colors.raid_dirty_white
RaidGUIControlPeerRewardCardPack.NAME_PADDING_DOWN = 2
RaidGUIControlPeerRewardCardPack.NAME_FONT_SIZE = tweak_data.gui.font_sizes.size_32
RaidGUIControlPeerRewardCardPack.DESCRIPTION_COLOR = tweak_data.gui.colors.raid_grey_effects
RaidGUIControlPeerRewardCardPack.DESCRIPTION_FONT_SIZE = tweak_data.gui.font_sizes.size_24
RaidGUIControlPeerRewardCardPack.IMAGE_PADDING_RIGHT = 10
RaidGUIControlPeerRewardCardPack.TEXT_X = 128

function RaidGUIControlPeerRewardCardPack:init(parent, params)
	RaidGUIControlPeerRewardCardPack.super.init(self, parent, params)

	if not params then
		Application:error("[RaidGUIControlPeerRewardCardPack:init] Parameters not specified for the weapon point peer drop details")

		return
	end

	self:_create_control_panel()
	self:_create_card_pack_details()
end

function RaidGUIControlPeerRewardCardPack:_create_control_panel()
	local control_params = clone(self._params)

	control_params.x = control_params.x
	control_params.w = control_params.w or RaidGUIControlPeerRewardCardPack.WIDTH
	control_params.h = control_params.h or RaidGUIControlPeerRewardCardPack.HEIGHT
	control_params.name = control_params.name .. "_card_pack_peer_panel"
	control_params.layer = self._panel:layer() + 1
	self._control_panel = self._panel:panel(control_params)
	self._object = self._control_panel
end

function RaidGUIControlPeerRewardCardPack:_create_card_pack_details()
	local params_weapon_point_image = {
		name = "card_pack_image",
		texture = tweak_data.gui.icons[RaidGUIControlPeerRewardCardPack.ICON].texture,
		texture_rect = tweak_data.gui.icons[RaidGUIControlPeerRewardCardPack.ICON].texture_rect,
		x = 0,
		y = 0,
	}

	self._weapon_point_image = self._object:bitmap(params_weapon_point_image)

	local params_player_name = {
		align = "left",
		color = RaidGUIControlPeerRewardCardPack.NAME_COLOR,
		font = RaidGUIControlPeerRewardCardPack.FONT,
		font_size = RaidGUIControlPeerRewardCardPack.NAME_FONT_SIZE,
		layer = 1,
		name = "peer_card_pack_name_label",
		text = "",
		w = self._object:w() - RaidGUIControlPeerRewardCardPack.TEXT_X,
		x = RaidGUIControlPeerRewardCardPack.TEXT_X,
		y = RaidGUIControlPeerRewardCardPack.NAME_Y,
	}

	self._name_label = self._object:text(params_player_name)

	local _, _, _, h = self._name_label:text_rect()

	self._name_label:set_h(h)

	local params_card_pack_description = {
		align = "left",
		color = RaidGUIControlPeerRewardCardPack.DESCRIPTION_COLOR,
		font = RaidGUIControlPeerRewardCardPack.FONT,
		font_size = RaidGUIControlPeerRewardCardPack.DESCRIPTION_FONT_SIZE,
		layer = 1,
		name = "card_pack_description_label",
		text = self:translate(RaidGUIControlPeerRewardCardPack.DESCRIPTION, true),
		w = self._name_label:w(),
		x = self._name_label:x(),
		y = self._name_label:y() + self._name_label:h() + RaidGUIControlPeerRewardCardPack.NAME_PADDING_DOWN,
	}

	self._card_pack_description_label = self._object:text(params_card_pack_description)

	local _, _, _, h = self._card_pack_description_label:text_rect()

	self._card_pack_description_label:set_h(h)
end

function RaidGUIControlPeerRewardCardPack:set_player_name(name)
	if managers.user:get_setting("capitalize_names") then
		name = utf8.to_upper(name)
	end

	self._name_label:set_text(name)
	self:_layout_text()
end

function RaidGUIControlPeerRewardCardPack:_layout_text()
	local _, _, _, h = self._name_label:text_rect()

	self._name_label:set_h(h)
	self._name_label:set_y(RaidGUIControlPeerRewardCardPack.NAME_Y)
	self._card_pack_description_label:set_y(self._name_label:y() + self._name_label:h() + RaidGUIControlPeerRewardCardPack.NAME_PADDING_DOWN)
end
