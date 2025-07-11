HUDInteraction = HUDInteraction or class()
HUDInteraction.DETAILS_ICON_SIZE = 42
HUDInteraction.DETAILS_PADDING = 4
HUDInteraction.FONT_SIZE = tweak_data.gui.font_sizes.size_24
HUDInteraction.FONT = tweak_data.gui.fonts.din_compressed_outlined_24

function HUDInteraction:init(hud, child_name)
	self._hud_panel = hud.panel
	self._progress_bar_width = 288
	self._progress_bar_height = 8
	self._progress_bar_x = self._hud_panel:w() / 2 - self._progress_bar_width / 2
	self._progress_bar_y = self._hud_panel:h() / 2 + 191
	self._progress_bar_bg = self._hud_panel:bitmap({
		h = self._progress_bar_height,
		layer = 2,
		name = "progress_bar_bg",
		texture = tweak_data.gui.icons.interaction_hold_meter_bg.texture,
		texture_rect = tweak_data.gui.icons.interaction_hold_meter_bg.texture_rect,
		visible = false,
		w = self._progress_bar_width,
		x = self._progress_bar_x,
		y = self._progress_bar_y,
	})
	self._child_name_text = (child_name or "interact") .. "_text"
	self._child_ivalid_name_text = (child_name or "interact") .. "_invalid_text"

	if self._hud_panel:child(self._child_name_text) then
		self._hud_panel:remove(self._hud_panel:child(self._child_name_text))
	end

	if self._hud_panel:child(self._child_ivalid_name_text) then
		self._hud_panel:remove(self._hud_panel:child(self._child_ivalid_name_text))
	end

	local interact_text = self._hud_panel:text({
		align = "center",
		font = HUDInteraction.FONT,
		font_size = HUDInteraction.FONT_SIZE,
		h = 64,
		layer = 1,
		name = self._child_name_text,
		text = "HELLO",
		valign = "center",
		visible = false,
	})
	local invalid_text = self._hud_panel:text({
		align = "center",
		blend_mode = "normal",
		color = Color(1, 0.3, 0.3),
		font = tweak_data.gui.fonts.din_compressed_outlined_24,
		font_size = 24,
		h = 64,
		layer = 3,
		name = self._child_ivalid_name_text,
		text = "HELLO",
		valign = "center",
		visible = false,
	})

	interact_text:set_center_y(self._hud_panel:h() / 2 + 200)
	invalid_text:set_center_y(self._hud_panel:h() / 2 + 200)

	self._panels_being_animated = {}
end

function HUDInteraction:show_interact(data)
	self._prompt_id = nil
	self._saved_text = data and data.text or self._saved_text

	if not self._saved_text then
		return
	end

	self:remove_interact()

	local text = utf8.to_upper(self._saved_text or managers.localization:text("interact_button_press"))

	self._hud_panel:child(self._child_name_text):set_text(text)
	self._hud_panel:child(self._child_name_text):set_visible(true)

	if data and data.duration then
		self._prompt_id = data.id

		if managers.queued_tasks:has_task("hud_interaction_prompt_hide") then
			managers.queued_tasks:unqueue("hud_interaction_prompt_hide")
		end

		managers.queued_tasks:queue("hud_interaction_prompt_hide", self.hide_prompt, self, self._prompt_id, data.duration, nil)
	end

	if data and data.details then
		self:_show_details(data.details)
	elseif data then
		self:_remove_details()
	elseif self._details_panel then
		self._details_panel:show()
	end
end

function HUDInteraction:hide_prompt(id)
	if self._prompt_id == id then
		self._hud_panel:child(self._child_name_text):set_visible(false)
	end
end

function HUDInteraction:remove_interact()
	if not alive(self._hud_panel) then
		return
	end

	self._hud_panel:child(self._child_name_text):set_visible(false)
	self._hud_panel:child(self._child_ivalid_name_text):set_visible(false)

	if self._details_panel then
		self._details_panel:hide()
	end
end

function HUDInteraction:show_interaction_bar(current, total)
	self:remove_interact()

	if self._progress_bar then
		self._progress_bar:parent():remove(self._progress_bar)

		self._progress_bar = nil
	end

	self._progress_bar = self._hud_panel:rect({
		alpha = 1,
		blend_mode = "normal",
		color = tweak_data.gui.colors.interaction_bar,
		h = 0,
		layer = 3,
		name = "interaction_progress_bar_show",
		w = 0,
		x = self._progress_bar_x,
		y = self._progress_bar_y,
	})

	self._progress_bar_bg:set_visible(true)
	self._progress_bar:animate(callback(self, self, "_animate_interaction_start"), 0.25)
end

function HUDInteraction:set_interaction_bar_width(current, total)
	if not self._progress_bar then
		return
	end

	local progress = current / total

	self._progress_bar:set_width(progress * self._progress_bar_width)
end

function HUDInteraction:animate_progress(duration)
	if not self._progress_bar then
		self:show_interaction_bar(0, duration)
	end

	self._auto_animation = self._progress_bar:animate(callback(self, self, "_animate_interaction_duration"), duration)
end

function HUDInteraction:hide_interaction_bar(complete, show_interact_at_finish)
	if complete then
		local progress_full = self._hud_panel:rect({
			alpha = 1,
			blend_mode = "normal",
			color = Color(0.8666666666666667, 0.6039215686274509, 0.2196078431372549),
			h = self._progress_bar_height,
			layer = 3,
			name = "interaction_progress_bar_hide",
			w = self._progress_bar_width,
			x = self._progress_bar_x,
			y = self._progress_bar_y,
		})

		progress_full:animate(callback(self, self, "_animate_interaction_complete"))
	end

	if self._progress_bar then
		local progress_cancel = self._hud_panel:rect({
			alpha = 1,
			blend_mode = "normal",
			color = Color(0.8666666666666667, 0.6039215686274509, 0.2196078431372549),
			h = self._progress_bar:h(),
			layer = 3,
			name = "interaction_progress_bar_cancel",
			w = self._progress_bar:w(),
			x = self._progress_bar_x,
			y = self._progress_bar_y,
		})

		progress_cancel:animate(callback(self, self, "_animate_interaction_cancel"), 0.15)
		self._progress_bar:stop()
		self._progress_bar:parent():remove(self._progress_bar)
		self._progress_bar_bg:set_visible(false)

		self._progress_bar = nil

		if show_interact_at_finish then
			self:show_interact()
		end
	end
end

function HUDInteraction:set_bar_valid(valid, text_id)
	self._hud_panel:child(self._child_name_text):set_visible(valid)

	local invalid_text = self._hud_panel:child(self._child_ivalid_name_text)

	if text_id then
		invalid_text:set_text(managers.localization:to_upper_text(text_id))
	end

	invalid_text:set_visible(not valid)
end

function HUDInteraction:destroy()
	self._hud_panel:remove(self._hud_panel:child(self._child_name_text))
	self._hud_panel:remove(self._hud_panel:child(self._child_ivalid_name_text))

	if managers.queued_tasks:has_task("hud_interaction_prompt_hide") then
		managers.queued_tasks:unqueue("hud_interaction_prompt_hide")
	end

	if self._progress_bar then
		self._progress_bar:parent():remove(self._progress_bar)
		self._pdwrogress_bar_bg:parent():remove(self._progress_bar_bg)

		self._progress_bar = nil
		self._progress_bar_bg = nil
	end

	self:_remove_details()
end

function HUDInteraction:_show_details(params)
	if self._details_panel then
		self._details_panel:parent():remove(self._details_panel)

		self._details_panel = nil
	end

	local interact_text = self._hud_panel:child(self._child_name_text)
	local _, interact_y, _, interact_h = interact_text:text_rect()

	self._details_panel = self._hud_panel:panel({
		name = "interaction_details_panel",
	})

	local icon_gui = tweak_data.gui:get_full_gui_data(params.icon)
	local detail_icon = self._details_panel:bitmap({
		color = params.color,
		h = HUDInteraction.DETAILS_ICON_SIZE,
		name = "details_icon",
		texture = icon_gui.texture,
		texture_rect = icon_gui.texture_rect,
		w = HUDInteraction.DETAILS_ICON_SIZE,
		x = HUDInteraction.DETAILS_PADDING,
	})
	local detail_text = self._details_panel:text({
		color = params.color,
		font = HUDInteraction.FONT,
		font_size = HUDInteraction.FONT_SIZE,
		name = "detail_text",
		text = tostring(params.text),
		vertical = "center",
	})
	local _, _, w, h = detail_text:text_rect()

	detail_text:set_size(w + HUDInteraction.DETAILS_PADDING, detail_icon:h())
	detail_text:set_x(detail_icon:right() + HUDInteraction.DETAILS_PADDING)
	detail_text:set_center_y(detail_icon:center_y() + 3)
	self._details_panel:set_size(detail_text:right(), detail_text:bottom())
	self._details_panel:set_center_x(self._hud_panel:w() / 2)
	self._details_panel:set_y(interact_y + interact_h + HUDInteraction.DETAILS_PADDING)
end

function HUDInteraction:_remove_details()
	if self._details_panel then
		self._details_panel:parent():remove(self._details_panel)

		self._details_panel = nil
	end
end

function HUDInteraction:_animate_interaction_start(progress_bar, duration)
	local t = 0

	self._panels_being_animated[tostring(progress_bar)] = true

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_height = self:_ease_out_quint(t, 0, self._progress_bar_height, duration)

		progress_bar:set_height(current_height)
		progress_bar:set_y(self._progress_bar_y)
	end

	progress_bar:set_height(self._progress_bar_height)

	self._panels_being_animated[tostring(progress_bar)] = false
end

function HUDInteraction:_animate_interaction_duration(progress_bar, duration)
	local t = 0

	self:set_interaction_bar_width(0, duration)

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		self:set_interaction_bar_width(t, duration)
	end

	self:set_interaction_bar_width(duration, duration)
end

function HUDInteraction:_animate_interaction_cancel(progress_bar, duration)
	local t = 0
	local start_height = progress_bar:h()

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_height = self:_ease_in_quint(t, start_height, -start_height, duration)

		progress_bar:set_height(current_height)
		progress_bar:set_y(self._progress_bar_y)
	end

	progress_bar:set_height(0)
	progress_bar:parent():remove(progress_bar)
end

function HUDInteraction:_animate_interaction_complete(progress_bar)
	local duration = 0.5
	local t = 0

	progress_bar:set_halign("right")

	while t < duration do
		local dt = coroutine.yield()

		t = t + dt

		local current_width = self:_ease_out_quint(t, self._progress_bar_width, -self._progress_bar_width, duration)

		progress_bar:set_width(current_width)
		progress_bar:set_right(self._hud_panel:w() / 2 + self._progress_bar_width / 2)
	end

	progress_bar:set_width(0)
	progress_bar:parent():remove(progress_bar)
end

function HUDInteraction:ease_in_out_multiple(t, starting_value, change, duration)
	t = t / (duration / 2)

	if t < 1 then
		return change / 2 * t * t + starting_value
	end

	t = t - 1

	return -change / 2 * (t * (t - 2) - 1) + starting_value
end

function HUDInteraction:_ease_in_quart(t, starting_value, change, duration)
	t = t / duration

	return change * t * t * t * t + starting_value
end

function HUDInteraction:_ease_in_quint(t, starting_value, change, duration)
	t = t / duration

	return change * t * t * t * t * t + starting_value
end

function HUDInteraction:_ease_out_quint(t, starting_value, change, duration)
	t = t / duration
	t = t - 1

	return change * (t * t * t * t * t + 1) + starting_value
end
