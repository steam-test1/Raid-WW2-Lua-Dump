RaidGUIControlEventDisplay = RaidGUIControlEventDisplay or class(RaidGUIControl)
RaidGUIControlEventDisplay.HEIGHT = 240
RaidGUIControlEventDisplay.INNER_HEIGHT = 200
RaidGUIControlEventDisplay.RIGHT_SIDE_X = 64
RaidGUIControlEventDisplay.TITLE_FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlEventDisplay.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.menu_list
RaidGUIControlEventDisplay.TITLE_COLOR = tweak_data.gui.colors.raid_white
RaidGUIControlEventDisplay.CHALLENGES_Y = 64
RaidGUIControlEventDisplay.PROGRESS_IMAGE_LEFT = "candy_progress_left"
RaidGUIControlEventDisplay.PROGRESS_IMAGE_CENTER = "candy_progress_center"
RaidGUIControlEventDisplay.PROGRESS_IMAGE_RIGHT = "candy_progress_right"
RaidGUIControlEventDisplay.PROGRESS_IMAGE_OVERLAY = "candy_progress_overlay"
RaidGUIControlEventDisplay.DESCRIPTION_FONT = tweak_data.gui.fonts.lato
RaidGUIControlEventDisplay.DESCRIPTION_FONT_SIZE = tweak_data.gui.font_sizes.size_20
RaidGUIControlEventDisplay.DESCRIPTION_COLOR = tweak_data.gui.colors.raid_grey
RaidGUIControlEventDisplay.INNER_PADDING = 40

function RaidGUIControlEventDisplay:init(parent, params)
	RaidGUIControlEventDisplay.super.init(self, parent, params)
	self:_create_panel()
	self:_create_title()
	self:_create_inner_panel()
	self:_create_toggle()
	self:_create_challenge()
end

function RaidGUIControlEventDisplay:_create_panel()
	self._object = self._panel:panel({
		h = self.HEIGHT,
		halign = "right",
		name = "event_display_panel",
		valign = "bottom",
	})
	self._background = self._object:nine_cut_bitmap({
		alpha = 0.75,
		corner_size = 32,
		h = self.INNER_HEIGHT,
		icon = "dialog_rect",
		layer = 0,
		name = "event_background",
		w = self._object:w(),
	})

	self._background:set_bottom(self._object:h())

	self._separator = self._object:gradient({
		h = 4,
		layer = self._background:layer() + 1,
		name = "event_separator",
		orientation = "horizontal",
		y = self._background:y() + 4,
	})
end

function RaidGUIControlEventDisplay:_create_title()
	self._title = self._object:text({
		align = "center",
		font = tweak_data.gui:get_font_path(self.TITLE_FONT, self.TITLE_FONT_SIZE),
		font_size = self.TITLE_FONT_SIZE,
		name = "event_title",
		text = "SUPER SPECIAL EVENT",
	})
end

function RaidGUIControlEventDisplay:_create_inner_panel()
	self._inner_panel = self._object:panel({
		h = self.INNER_HEIGHT,
		halign = "grow",
		layer = 1,
		name = "event_inner_panel",
		valign = "grow",
		w = self._object:w() - self.INNER_PADDING,
	})

	self._inner_panel:set_center_x(self._object:w() / 2)
	self._inner_panel:set_bottom(self._object:h())
end

function RaidGUIControlEventDisplay:_create_toggle()
	self._event_checkbox = self._inner_panel:toggle_button({
		description = self:translate("menu_enable_event_title", true),
		layer = self._background:layer() + 1,
		name = "event_checkbox",
		value = true,
		y = 14,
	})

	self._event_checkbox:set_center_x(self._inner_panel:w() / 2)
	self._event_checkbox:set_value_and_render(Global.game_settings.event_enabled, true)

	if not Network:is_server() then
		self._event_checkbox:set_enabled(false)
	end
end

function RaidGUIControlEventDisplay:_create_challenge()
	local default_icon = "wpn_skill_accuracy"

	self._icon = self._inner_panel:bitmap({
		layer = self._background:layer() + 1,
		name = "weapon_challenge_icon",
		texture = tweak_data.gui.icons[default_icon].texture,
		texture_rect = tweak_data.gui.icons[default_icon].texture_rect,
		x = 8,
		y = self.CHALLENGES_Y,
	})
	self._description = self._inner_panel:text({
		color = self.DESCRIPTION_COLOR,
		font = tweak_data.gui:get_font_path(self.DESCRIPTION_FONT, self.DESCRIPTION_FONT_SIZE),
		font_size = self.DESCRIPTION_FONT_SIZE,
		layer = self._background:layer() + 1,
		name = "weapon_challenge_description",
		text = "Bla bla bla bla",
		w = self._inner_panel:w() - self.RIGHT_SIDE_X,
		wrap = true,
		x = self.RIGHT_SIDE_X,
		y = self.CHALLENGES_Y,
	})
	self._progress_bar_panel = self._inner_panel:panel({
		h = tweak_data.gui:icon_h(self.PROGRESS_IMAGE_CENTER),
		name = "weapon_challenge_progress_bar_panel",
		vertical = "bottom",
		w = self._inner_panel:w(),
	})

	self._progress_bar_panel:set_center_y(self._inner_panel:h() - 32)

	local progress_bar_background = self._progress_bar_panel:three_cut_bitmap({
		center = self.PROGRESS_IMAGE_CENTER,
		color = Color.white:with_alpha(0.5),
		h = tweak_data.gui:icon_h(self.PROGRESS_IMAGE_CENTER),
		layer = 1,
		left = self.PROGRESS_IMAGE_LEFT,
		name = "weapon_challenge_progress_bar_background",
		right = self.PROGRESS_IMAGE_RIGHT,
		w = self._progress_bar_panel:w(),
	})

	self._progress_bar_foreground_panel = self._progress_bar_panel:panel({
		h = self._progress_bar_panel:h(),
		halign = "scale",
		layer = 2,
		name = "weapon_challenge_progress_bar_foreground_panel",
		valign = "scale",
		w = self._progress_bar_panel:w(),
	})
	self._progress_bar = self._progress_bar_foreground_panel:three_cut_bitmap({
		center = self.PROGRESS_IMAGE_CENTER,
		h = tweak_data.gui:icon_h(self.PROGRESS_IMAGE_CENTER),
		left = self.PROGRESS_IMAGE_LEFT,
		name = "weapon_challenge_progress_bar_background",
		right = self.PROGRESS_IMAGE_RIGHT,
		w = self._progress_bar_panel:w(),
	})

	local icon_data = tweak_data.gui:get_full_gui_data(self.PROGRESS_IMAGE_OVERLAY)

	icon_data.texture_rect[3] = self._progress_bar_panel:w() * 0.55

	local overlay = self._progress_bar_foreground_panel:bitmap({
		alpha = 0.3,
		blend_mode = "add",
		color = tweak_data.gui.colors.raid_dark_red,
		h = self._progress_bar_panel:h(),
		layer = progress_bar_background:layer() + 5,
		name = "candy_progress_bar_background",
		texture = icon_data.texture,
		texture_rect = icon_data.texture_rect,
		w = self._progress_bar_panel:w(),
		wrap_mode = "wrap",
	})

	self._progress_text = self._progress_bar_panel:label({
		align = "center",
		color = tweak_data.gui.colors.raid_dirty_white,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.size_24,
		h = self._progress_bar_panel:h(),
		layer = overlay:layer() + 5,
		name = "weapon_challenge_progress_bar_text",
		text = "123/456",
		vertical = "center",
		w = self._progress_bar_panel:w(),
		y = -2,
	})
end

function RaidGUIControlEventDisplay:set_event(event_name)
	local event_data = tweak_data.events.special_events[event_name]
	local accent_color = event_data.accent_color and tweak_data.gui.colors[event_data.accent_color] or self.TITLE_COLOR

	self._title:set_text(self:translate(event_data.name_id, true))
	self._title:set_color(accent_color)
	self._separator:set_gradient_points({
		0,
		accent_color:with_alpha(0),
		0.2,
		accent_color:with_alpha(1),
		0.8,
		accent_color:with_alpha(1),
		1,
		accent_color:with_alpha(0),
	})

	if event_data.challenge_id then
		local challenge_tweak = tweak_data.challenge[event_data.challenge_id]
		local challenge = managers.challenge:get_challenge(ChallengeManager.CATEGORY_GENERIC, event_data.challenge_id)
		local data = challenge:data()
		local tasks = challenge:tasks()
		local briefing_id = tasks[1]:briefing_id()
		local count = tasks[1]:current_count()
		local target = tasks[1]:target()
		local min_range = math.round(tasks[1]:min_range() / 100)
		local max_range = math.round(tasks[1]:max_range() / 100)

		self._progress_bar:set_color(accent_color)

		local range = max_range > 0 and max_range or min_range

		self._description:set_text(managers.localization:text(briefing_id, {
			AMOUNT = target,
			RANGE = range,
			WEAPON = managers.localization:text(data.unlock),
		}))
		self._progress_bar_foreground_panel:set_w(self._progress_bar_panel:w() * (count / target))

		local icon = tweak_data.gui:get_full_gui_data(challenge_tweak.challenge_icon)

		self._icon:set_image(icon.texture, unpack(icon.texture_rect))

		local progress_text

		if count ~= target then
			progress_text = tostring(count) .. "/" .. tostring(target)
		else
			progress_text = utf8.to_upper(managers.localization:text("menu_weapon_challenge_completed"))
		end

		self._progress_text:set_text(progress_text)
	end
end

function RaidGUIControlEventDisplay:highlight_on()
	self._event_checkbox:set_selected(true)
end

function RaidGUIControlEventDisplay:confirm_pressed()
	return self._event_checkbox:confirm_pressed()
end

function RaidGUIControlEventDisplay:move_up()
	if self._selected and self._on_menu_move and self._on_menu_move.up then
		self._event_checkbox:set_selected(false)

		return self:_menu_move_to(self._on_menu_move.up, "up")
	end
end

function RaidGUIControlEventDisplay:get_value()
	return self._event_checkbox:get_value()
end
