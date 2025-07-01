RaidGUIControlRespec = RaidGUIControlRespec or class(RaidGUIControl)
RaidGUIControlRespec.DEFAULT_W = 320
RaidGUIControlRespec.DEFAULT_H = 150
RaidGUIControlRespec.TITLE_H = 64
RaidGUIControlRespec.TITLE_FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlRespec.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_38
RaidGUIControlRespec.TITLE_COLOR = Color.white
RaidGUIControlRespec.DESCRIPTION_W = 320
RaidGUIControlRespec.DESCRIPTION_Y = 80
RaidGUIControlRespec.DESCRIPTION_FONT = tweak_data.gui.fonts.lato
RaidGUIControlRespec.DESCRIPTION_FONT_SIZE = tweak_data.gui.font_sizes.size_20
RaidGUIControlRespec.DESCRIPTION_COLOR = tweak_data.gui.colors.raid_grey
RaidGUIControlRespec.COST_PADDING_DOWN = 32

function RaidGUIControlRespec:init(parent, params)
	RaidGUIControlRespec.super.init(self, parent, params)

	if not params then
		Application:error("[RaidGUIControlRespec:init] Parameters not specified for the skill details " .. tostring(self._name))

		return
	end

	self:_create_control_panel()
	self:_create_respec_description()
end

function RaidGUIControlRespec:_create_control_panel()
	local control_params = clone(self._params)

	control_params.name = control_params.name .. "_customization_panel"
	control_params.layer = self._panel:layer() + 1
	control_params.w = self._params.w or RaidGUIControlRespec.DEFAULT_W
	control_params.h = self._params.h or RaidGUIControlRespec.DEFAULT_H
	self._control_panel = self._panel:panel(control_params)
	self._object = self._control_panel
end

function RaidGUIControlRespec:_create_respec_title()
	local skill_title_params = {
		align = "left",
		color = RaidGUIControlRespec.TITLE_COLOR,
		font = RaidGUIControlRespec.TITLE_FONT,
		font_size = RaidGUIControlRespec.TITLE_FONT_SIZE,
		h = RaidGUIControlRespec.TITLE_H,
		name = "respec_title",
		text = utf8.to_upper(managers.localization:text("menu_character_skills_retrain_title")),
		vertical = "center",
		w = self._object:w(),
		wrap = false,
		x = 0,
		y = 0,
	}

	self._title = self._object:label(skill_title_params)
end

function RaidGUIControlRespec:_create_respec_description()
	local description_text_params = {
		color = RaidGUIControlRespec.DESCRIPTION_COLOR,
		font = RaidGUIControlRespec.DESCRIPTION_FONT,
		font_size = RaidGUIControlRespec.DESCRIPTION_FONT_SIZE,
		h = self._object:h(),
		name = "respec_description",
		text = managers.localization:text("menu_character_skills_retrain_desc"),
		w = RaidGUIControlRespec.DESCRIPTION_W,
		word_wrap = true,
		wrap = true,
		x = 0,
		y = RaidGUIControlRespec.DESCRIPTION_Y,
	}

	self._description = self._object:label(description_text_params)
end
