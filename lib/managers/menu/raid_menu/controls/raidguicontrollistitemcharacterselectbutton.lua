RaidGUIControlListItemCharacterSelectButton = RaidGUIControlListItemCharacterSelectButton or class(RaidGUIControl)
RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_CUSTOMIZE = "button_customize"
RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_DELETE = "button_delete"
RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_CREATE = "button_create"
RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_RENAME = "button_rename"
RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_NATION = "button_nation"
RaidGUIControlListItemCharacterSelectButton.BUTTON_COLOR = Color("313131")

function RaidGUIControlListItemCharacterSelectButton:init(parent, params)
	RaidGUIControlListItemCharacterSelectButton.super.init(self, parent, params)

	self._object = self._panel:panel({
		h = self._params.h,
		visible = false,
		w = self._params.w,
		x = self._params.x,
		y = self._params.y,
	})
	self._special_action_callback = self._params.special_action_callback
	self._background = self._object:image({
		h = CharacterSelectionGui.BUTTON_H,
		layer = self._object:layer(),
		texture = tweak_data.gui.icons.btn_list_rect.texture,
		texture_rect = tweak_data.gui.icons.btn_list_rect.texture_rect,
		w = CharacterSelectionGui.BUTTON_W,
		x = 0,
		y = 0,
	})
	self._icon = self._object:image({
		color = RaidGUIControlListItemCharacterSelectButton.BUTTON_COLOR,
		h = 32,
		layer = self._background:layer() + 1,
		texture = tweak_data.gui.icons.list_btn_ico_plus.texture,
		texture_rect = tweak_data.gui.icons.list_btn_ico_plus.texture_rect,
		w = 32,
		x = 0,
		y = 0,
	})

	self._icon:set_center(CharacterSelectionGui.BUTTON_W / 2, CharacterSelectionGui.BUTTON_H / 2)

	self._label = self._object:label({
		align = "center",
		color = tweak_data.gui.colors.raid_black,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.keybinding,
		h = 25,
		text = "",
		vertical = "center",
		visible = false,
		w = 116,
		x = 0,
		y = 0,
	})

	self._label:set_center(CharacterSelectionGui.BUTTON_W / 2, CharacterSelectionGui.BUTTON_H / 2)
end

function RaidGUIControlListItemCharacterSelectButton:set_button(button_type)
	if button_type == RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_CUSTOMIZE then
		self._icon:set_image(tweak_data.gui.icons.list_btn_ico_shirt.texture)
		self._icon:set_texture_rect(tweak_data.gui.icons.list_btn_ico_shirt.texture_rect)
		self._label:set_text(self:translate("character_selection_button_customize", true))

		self._button_type = RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_CUSTOMIZE
	elseif button_type == RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_RENAME then
		self._icon:set_image(tweak_data.gui.icons.list_btn_ico_rename.texture)
		self._icon:set_texture_rect(tweak_data.gui.icons.list_btn_ico_rename.texture_rect)
		self._label:set_text(self:translate("character_selection_button_rename", true))

		self._button_type = RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_RENAME
	elseif button_type == RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_NATION then
		self._icon:set_image(tweak_data.gui.icons.list_btn_ico_globe.texture)
		self._icon:set_texture_rect(tweak_data.gui.icons.list_btn_ico_globe.texture_rect)
		self._label:set_text(self:translate("character_selection_button_nation", true))

		self._button_type = RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_NATION
	elseif button_type == RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_DELETE then
		self._icon:set_image(tweak_data.gui.icons.list_btn_ico_x.texture)
		self._icon:set_texture_rect(tweak_data.gui.icons.list_btn_ico_x.texture_rect)
		self._label:set_text(self:translate("character_selection_button_delete", true))

		self._button_type = RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_DELETE
	elseif button_type == RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_CREATE then
		self._icon:set_image(tweak_data.gui.icons.list_btn_ico_plus.texture)
		self._icon:set_texture_rect(tweak_data.gui.icons.list_btn_ico_plus.texture_rect)
		self._label:set_text(self:translate("character_selection_button_create", true))

		self._button_type = RaidGUIControlListItemCharacterSelectButton.BUTTON_TYPE_CREATE
	end
end

function RaidGUIControlListItemCharacterSelectButton:highlight_on()
	self._background:set_image(tweak_data.gui.icons.btn_list_rect_hover.texture)
	self._background:set_texture_rect(tweak_data.gui.icons.btn_list_rect_hover.texture_rect)
	self._label:set_visible(true)
	self._icon:set_visible(false)
end

function RaidGUIControlListItemCharacterSelectButton:highlight_off()
	self._background:set_image(tweak_data.gui.icons.btn_list_rect.texture)
	self._background:set_texture_rect(tweak_data.gui.icons.btn_list_rect.texture_rect)
	self._label:set_visible(false)
	self._icon:set_visible(true)
end

function RaidGUIControlListItemCharacterSelectButton:mouse_released(o, button, x, y)
	return self:on_mouse_released()
end

function RaidGUIControlListItemCharacterSelectButton:on_mouse_released()
	if self._special_action_callback then
		self._special_action_callback(self._params.slot_index, self._button_type)

		return true
	end
end
