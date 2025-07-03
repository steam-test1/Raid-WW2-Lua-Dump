require("lib/managers/menu/BoxGuiObject")

MenuNodeBaseGui = MenuNodeBaseGui or class(MenuNodeGui)
MenuNodeBaseGui.massive_font = tweak_data.menu.pd2_massive_font
MenuNodeBaseGui.large_font = tweak_data.menu.pd2_large_font
MenuNodeBaseGui.medium_font = tweak_data.menu.pd2_medium_font
MenuNodeBaseGui.small_font = tweak_data.menu.pd2_small_font
MenuNodeBaseGui.massive_font_size = tweak_data.menu.pd2_massive_font_size
MenuNodeBaseGui.large_font_size = tweak_data.menu.pd2_large_font_size
MenuNodeBaseGui.medium_font_size = tweak_data.menu.pd2_medium_font_size
MenuNodeBaseGui.small_font_size = tweak_data.menu.pd2_small_font_size
MenuNodeBaseGui.text_color = tweak_data.screen_colors.text
MenuNodeBaseGui.button_default_color = tweak_data.screen_colors.button_stage_3
MenuNodeBaseGui.button_highlighted_color = tweak_data.screen_colors.button_stage_2
MenuNodeBaseGui.button_selected_color = tweak_data.screen_colors.button_stage_1
MenuNodeBaseGui.is_win32 = IS_PC

function MenuNodeBaseGui:init(node, layer, parameters)
	MenuNodeBaseGui.super.init(self, node, layer, parameters)
	self:setup()
end

function MenuNodeBaseGui:setup()
	self._requested_textures = {}
	self._gui_boxes = {}
	self._text_buttons = {}
	self.is_pc_controller = managers.menu:is_pc_controller()
end

function MenuNodeBaseGui:mouse_moved(o, x, y)
	local used, icon = false, "arrow"

	for _, button in ipairs(self._text_buttons) do
		if alive(button.panel) and button.panel:visible() then
			if button.panel:inside(x, y) then
				if not button.highlighted then
					button.highlighted = true

					managers.menu_component:post_event("highlight")

					if alive(button.text) then
						button.text:set_color(button.highlighted_color or self.button_highlighted_color)
					end

					if alive(button.image) then
						button.image:set_color(button.highlighted_color or self.button_highlighted_color)
					end
				end

				used, icon = true, "link"
			elseif button.highlighted then
				button.highlighted = false

				if alive(button.text) then
					button.text:set_color(button.default_color or self.button_default_color)
				end

				if alive(button.image) then
					button.image:set_color(button.default_color or self.button_default_color)
				end
			end
		end
	end

	return used, icon
end

function MenuNodeBaseGui:mouse_pressed(button, x, y)
	if button == Idstring("0") or button == Idstring("1") then
		for _, btn in ipairs(self._text_buttons) do
			if alive(btn.panel) and btn.panel:visible() and btn.panel:inside(x, y) then
				if btn.clbk then
					btn.clbk(button, btn.params)
				end

				managers.menu_component:post_event("menu_enter")

				return true
			end
		end
	end

	return MenuNodeBaseGui.super.mouse_pressed(self, button, x, y)
end

function MenuNodeBaseGui:mouse_released(button, x, y)
	return
end

function MenuNodeBaseGui:confirm_pressed()
	return
end

function MenuNodeBaseGui:previous_page()
	return
end

function MenuNodeBaseGui:next_page()
	return
end

function MenuNodeBaseGui:move_up()
	print("MenuNodeBaseGui:move_up")
end

function MenuNodeBaseGui:move_down()
	print("MenuNodeBaseGui:move_down")
end

function MenuNodeBaseGui:move_left()
	return
end

function MenuNodeBaseGui:move_right()
	return
end

function MenuNodeBaseGui:request_texture(texture_path, panel, keep_aspect_ratio, blend_mode)
	if not managers.menu_component then
		return
	end

	local texture_count = managers.menu_component:request_texture(texture_path, callback(self, self, "texture_done_clbk", {
		blend_mode = blend_mode,
		keep_aspect_ratio = keep_aspect_ratio,
		panel = panel,
	}))

	table.insert(self._requested_textures, {
		texture = texture_path,
		texture_count = texture_count,
	})
end

function MenuNodeBaseGui:unretrieve_textures()
	if self._requested_textures then
		for i, data in pairs(self._requested_textures) do
			managers.menu_component:unretrieve_texture(data.texture, data.texture_count)
		end
	end

	self._requested_textures = {}
end

function MenuNodeBaseGui:texture_done_clbk(params, texture_ids)
	params = params or {}

	local panel = params.panel or params[1]
	local keep_aspect_ratio = params.keep_aspect_ratio
	local blend_mode = params.blend_mode
	local name = params.name or "streamed_texture"

	if not alive(panel) then
		Application:error("[MenuNodeBaseGui:texture_done_clbk] Missing GUI panel", "texture_ids", texture_ids, "params", inspect(params))

		return
	end

	local image = panel:bitmap({
		blend_mode = blend_mode,
		name = name,
		texture = texture_ids,
	})

	if keep_aspect_ratio then
		local texture_width = image:texture_width()
		local texture_height = image:texture_height()
		local panel_width = panel:w()
		local panel_height = panel:h()
		local tw = texture_width
		local th = texture_height
		local pw = panel_width
		local ph = panel_height

		if tw == 0 or th == 0 then
			Application:error("[MenuNodeBaseGui:texture_done_clbk] Texture size error!:", "width", tw, "height", th)

			tw = 1
			th = 1
		end

		local sw = math.min(pw, ph * (tw / th))
		local sh = math.min(ph, pw / (tw / th))

		image:set_size(math.round(sw), math.round(sh))
		image:set_center(panel:w() * 0.5, panel:h() * 0.5)
	else
		image:set_size(panel:size())
	end
end

function MenuNodeBaseGui:close()
	self:unretrieve_textures()
	MenuNodeBaseGui.super.close(self)
end
