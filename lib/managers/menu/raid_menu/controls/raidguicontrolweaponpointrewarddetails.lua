RaidGUIControlWeaponPointRewardDetails = RaidGUIControlWeaponPointRewardDetails or class(RaidGUIControl)
RaidGUIControlWeaponPointRewardDetails.DEFAULT_WIDTH = 400
RaidGUIControlWeaponPointRewardDetails.HEIGHT = 400
RaidGUIControlWeaponPointRewardDetails.LEFT_PANEL_W = 860
RaidGUIControlWeaponPointRewardDetails.FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlWeaponPointRewardDetails.TITLE_DESCRIPTION_H = 50
RaidGUIControlWeaponPointRewardDetails.TITLE_DESCRIPTION_FONT_SIZE = tweak_data.gui.font_sizes.size_32
RaidGUIControlWeaponPointRewardDetails.TITLE_DESCRIPTION_COLOR = tweak_data.gui.colors.raid_white
RaidGUIControlWeaponPointRewardDetails.TITLE_PADDING_TOP = -14
RaidGUIControlWeaponPointRewardDetails.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_76
RaidGUIControlWeaponPointRewardDetails.TITLE_COLOR = tweak_data.gui.colors.raid_red
RaidGUIControlWeaponPointRewardDetails.REWARD_ICON_PANEL_Y = 144
RaidGUIControlWeaponPointRewardDetails.REWARD_ICON_PANEL_H = 560
RaidGUIControlWeaponPointRewardDetails.REWARD_ICON = "rwd_weapon_large"
RaidGUIControlWeaponPointRewardDetails.ITEM_TYPE_Y = 224
RaidGUIControlWeaponPointRewardDetails.ITEM_TYPE_H = 64
RaidGUIControlWeaponPointRewardDetails.ITEM_TYPE_FONT_SIZE = tweak_data.gui.font_sizes.size_38
RaidGUIControlWeaponPointRewardDetails.ITEM_TYPE_COLOR = tweak_data.gui.colors.raid_white
RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_Y = 304
RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_W = 352
RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_FONT = tweak_data.gui.fonts.lato
RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_FONT_SIZE = tweak_data.gui.font_sizes.size_20
RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_COLOR = tweak_data.gui.colors.raid_grey
RaidGUIControlWeaponPointRewardDetails.REDEEM_DESCRIPTION_CENTER_Y_FROM_BOTTOM = 192
RaidGUIControlWeaponPointRewardDetails.REDEEM_DESCRIPTION_FONT_SIZE = tweak_data.gui.font_sizes.size_32
RaidGUIControlWeaponPointRewardDetails.REDEEM_DESCRIPTION_COLOR = tweak_data.gui.colors.raid_white
RaidGUIControlWeaponPointRewardDetails.REDEEM_VALUE_CENTER_Y_FROM_BOTTOM = 148
RaidGUIControlWeaponPointRewardDetails.REDEEM_VALUE_FONT_SIZE = tweak_data.gui.font_sizes.size_56
RaidGUIControlWeaponPointRewardDetails.REDEEM_VALUE_COLOR = tweak_data.gui.colors.raid_red
RaidGUIControlWeaponPointRewardDetails.REDEEM_BUTTON_CENTER_Y_FROM_BOTTOM = 92

function RaidGUIControlWeaponPointRewardDetails:init(parent, params)
	RaidGUIControlWeaponPointRewardDetails.super.init(self, parent, params)

	if not params then
		Application:error("[RaidGUIControlWeaponPointRewardDetails:init] Parameters not specified for the XP reward details")

		return
	end

	self._xp_redeem_value = tweak_data.weapon_skills.weapon_point_reedemed_xp

	self:_create_control_panel()
	self:_create_left_panel()
	self:_create_title()
	self:_create_reward_image()
	self:_create_redeem_info()
	self:_create_right_panel()
	self:_create_item_type()
	self:_create_description()
end

function RaidGUIControlWeaponPointRewardDetails:_create_control_panel()
	local control_params = clone(self._params)

	control_params.x = control_params.x
	control_params.w = control_params.w or RaidGUIControlWeaponPointRewardDetails.DEFAULT_WIDTH
	control_params.h = control_params.h or RaidGUIControlWeaponPointRewardDetails.HEIGHT
	control_params.name = control_params.name .. "_customization_panel"
	control_params.layer = self._panel:layer() + 1
	self._control_panel = self._panel:panel(control_params)
	self._object = self._control_panel
end

function RaidGUIControlWeaponPointRewardDetails:_create_left_panel()
	local left_panel_params = {
		h = self._object:h(),
		name = "left_panel",
		w = RaidGUIControlWeaponPointRewardDetails.LEFT_PANEL_W,
	}

	self._left_panel = self._object:panel(left_panel_params)
end

function RaidGUIControlWeaponPointRewardDetails:_create_title()
	local title_description_params = {
		align = "left",
		color = RaidGUIControlWeaponPointRewardDetails.TITLE_DESCRIPTION_COLOR,
		font = RaidGUIControlWeaponPointRewardDetails.FONT,
		font_size = RaidGUIControlWeaponPointRewardDetails.TITLE_DESCRIPTION_FONT_SIZE,
		h = RaidGUIControlWeaponPointRewardDetails.TITLE_DESCRIPTION_H,
		name = "title_description",
		text = self:translate("menu_loot_screen_bracket_unlocked_title", true),
		vertical = "center",
	}
	local title_description = self._left_panel:text(title_description_params)
	local _, _, w, _ = title_description:text_rect()

	title_description:set_w(w)

	local title_params = {
		align = "center",
		color = RaidGUIControlWeaponPointRewardDetails.TITLE_COLOR,
		font = RaidGUIControlWeaponPointRewardDetails.FONT,
		font_size = RaidGUIControlWeaponPointRewardDetails.TITLE_FONT_SIZE,
		name = "customization_name",
		text = self:translate("menu_loot_screen_weapon_point", true),
		vertical = "top",
		y = title_description:y() + title_description:h() + RaidGUIControlWeaponPointRewardDetails.TITLE_PADDING_TOP,
	}

	self._customization_name = self._left_panel:text(title_params)

	self:_layout_title()
end

function RaidGUIControlWeaponPointRewardDetails:_layout_title()
	local _, _, w, h = self._customization_name:text_rect()

	self._customization_name:set_w(w)
	self._customization_name:set_h(h)
	self._customization_name:set_center_x(self._left_panel:w() / 2)

	local title_description = self._left_panel:child("title_description")

	title_description:set_x(self._customization_name:x())
end

function RaidGUIControlWeaponPointRewardDetails:_create_reward_image()
	local reward_image_panel_params = {
		h = RaidGUIControlWeaponPointRewardDetails.REWARD_ICON_PANEL_H,
		name = "reward_image_panel",
		w = self._left_panel:w(),
		y = RaidGUIControlWeaponPointRewardDetails.REWARD_ICON_PANEL_Y,
	}
	local reward_image_panel = self._left_panel:panel(reward_image_panel_params)
	local reward_image_params = {
		name = "reward_image",
		texture = tweak_data.gui.icons[RaidGUIControlWeaponPointRewardDetails.REWARD_ICON].texture,
		texture_rect = tweak_data.gui.icons[RaidGUIControlWeaponPointRewardDetails.REWARD_ICON].texture_rect,
	}

	self._reward_image = reward_image_panel:bitmap(reward_image_params)

	self._reward_image:set_center_x(reward_image_panel:w() / 2)
	self._reward_image:set_center_y(reward_image_panel:h() / 2)
end

function RaidGUIControlWeaponPointRewardDetails:_create_redeem_info()
	local redeem_description_params = {
		color = RaidGUIControlWeaponPointRewardDetails.REDEEM_DESCRIPTION_COLOR,
		font = RaidGUIControlWeaponPointRewardDetails.FONT,
		font_size = RaidGUIControlWeaponPointRewardDetails.REDEEM_DESCRIPTION_FONT_SIZE,
		name = "redeem_description",
		text = self:translate("menu_loot_screen_redeem_worth_title", true),
	}
	local redeem_description = self._left_panel:text(redeem_description_params)
	local redeem_value_params = {
		color = RaidGUIControlWeaponPointRewardDetails.REDEEM_VALUE_COLOR,
		font = RaidGUIControlWeaponPointRewardDetails.FONT,
		font_size = RaidGUIControlWeaponPointRewardDetails.REDEEM_VALUE_FONT_SIZE,
		name = "redeem_value",
		text = self._xp_redeem_value .. " " .. self:translate("menu_label_xp", true),
	}

	self._xp_redeem_value_text = self._left_panel:text(redeem_value_params)

	self:_layout_redeem_info()

	local redeem_xp_button_params = {
		layer = RaidGuiBase.FOREGROUND_LAYER,
		name = "redeem_xp_button",
		on_click_callback = callback(self, self, "_on_click_redeem"),
		text = self:translate("menu_loot_screen_redeem_xp", true),
		x = 0,
		y = self._left_panel:h() - RaidGUIControlWeaponPointRewardDetails.REDEEM_BUTTON_CENTER_Y_FROM_BOTTOM,
	}

	self._redeem_button = self._left_panel:short_tertiary_button(redeem_xp_button_params)

	self._redeem_button:set_center_x(self._left_panel:w() / 2)
end

function RaidGUIControlWeaponPointRewardDetails:_layout_redeem_info()
	local redeem_description = self._left_panel:child("redeem_description")
	local _, _, w, h = redeem_description:text_rect()

	redeem_description:set_w(w)
	redeem_description:set_h(h)
	redeem_description:set_center_x(self._left_panel:w() / 2)
	redeem_description:set_center_y(self._left_panel:h() - RaidGUIControlWeaponPointRewardDetails.REDEEM_DESCRIPTION_CENTER_Y_FROM_BOTTOM)

	local _, _, w, h = self._xp_redeem_value_text:text_rect()

	self._xp_redeem_value_text:set_w(w)
	self._xp_redeem_value_text:set_h(h)
	self._xp_redeem_value_text:set_center_x(self._left_panel:w() / 2)
	self._xp_redeem_value_text:set_center_y(self._left_panel:h() - RaidGUIControlWeaponPointRewardDetails.REDEEM_VALUE_CENTER_Y_FROM_BOTTOM)
end

function RaidGUIControlWeaponPointRewardDetails:_create_right_panel()
	local right_panel_params = {
		h = self._object:h(),
		name = "right_panel",
		w = self._object:w() - self._left_panel:w(),
	}

	self._right_panel = self._object:panel(right_panel_params)

	self._right_panel:set_right(self._object:w())
end

function RaidGUIControlWeaponPointRewardDetails:_create_item_type()
	local item_type_params = {
		align = "right",
		color = RaidGUIControlWeaponPointRewardDetails.ITEM_TYPE_COLOR,
		font = RaidGUIControlWeaponPointRewardDetails.FONT,
		font_size = RaidGUIControlWeaponPointRewardDetails.ITEM_TYPE_FONT_SIZE,
		h = RaidGUIControlWeaponPointRewardDetails.ITEM_TYPE_H,
		name = "item_type",
		text = self:translate("menu_loot_screen_weapon_point_title_text", true),
		vertical = "center",
		w = self._right_panel:w(),
		y = RaidGUIControlWeaponPointRewardDetails.ITEM_TYPE_Y,
	}

	self._item_type = self._right_panel:text(item_type_params)
end

function RaidGUIControlWeaponPointRewardDetails:_create_description()
	local description_params = {
		align = "left",
		color = RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_COLOR,
		font = RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_FONT,
		font_size = RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_FONT_SIZE,
		name = "description",
		text = self:translate("menu_loot_screen_weapon_point_description"),
		vertical = "top",
		w = RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_W,
		wrap = true,
		y = RaidGUIControlWeaponPointRewardDetails.DESCRIPTION_Y,
	}

	self._description = self._right_panel:text(description_params)

	self._description:set_right(self._right_panel:w())
end

function RaidGUIControlWeaponPointRewardDetails:_on_click_redeem()
	local params = {
		callback = callback(self, self, "redeem"),
		xp = self._xp_redeem_value,
	}

	managers.menu:show_redeem_weapon_point_dialog(params)
end

function RaidGUIControlWeaponPointRewardDetails:redeem()
	managers.lootdrop:redeem_dropped_loot_for_goldbars()
	self._redeem_button:hide()
end
