TextGui = TextGui or class()
TextGui.COLORS = {}
TextGui.COLORS = {}
TextGui.COLORS.black = Color(0, 0, 0)
TextGui.COLORS.white = Color(1, 1, 1)
TextGui.COLORS.red = Color(0.8, 0, 0)
TextGui.COLORS.green = Color(0, 0.8, 0)
TextGui.COLORS.blue = Color(0, 0, 0.8)
TextGui.COLORS.yellow = Color(0.8, 0.8, 0)
TextGui.COLORS.orange = Color(0.8, 0.4, 0)
TextGui.COLORS.light_red = Color(0.8, 0.4, 0.4)
TextGui.COLORS.light_blue = Color(0.4, 0.6, 0.8)
TextGui.COLORS.light_green = Color(0.6, 0.8, 0.4)
TextGui.COLORS.light_yellow = Color(0.8, 0.8, 0.4)
TextGui.COLORS.light_orange = Color(0.8, 0.6, 0.4)
TextGui.GUI_EVENT_IDS = {}
TextGui.GUI_EVENT_IDS.syncronize = 1
TextGui.GUI_EVENT_IDS.timer_set = 2
TextGui.GUI_EVENT_IDS.timer_start_count_up = 3
TextGui.GUI_EVENT_IDS.timer_start_count_down = 4
TextGui.GUI_EVENT_IDS.timer_pause = 5
TextGui.GUI_EVENT_IDS.timer_resume = 6
TextGui.GUI_EVENT_IDS.number_set = 7

function TextGui:init(unit)
	self._unit = unit
	self._visible = true
	self.ROWS = self.ROWS or 2
	self.WIDTH = self.WIDTH or 640
	self.HEIGHT = self.HEIGHT or 360
	self.FONT = self.FONT or "fonts/font_large_mf"
	self.FONT_SIZE = self.FONT_SIZE or 180
	self.COLOR_TYPE = self.COLOR_TYPE or "light_blue"
	self.BG_COLOR_TYPE = self.BG_COLOR_TYPE or nil
	self.TEXT_COLOR = TextGui.COLORS[self.COLOR_TYPE]

	if self.BG_COLOR_TYPE then
		self.BG_COLOR = TextGui.COLORS[self.BG_COLOR_TYPE]
	end

	self._texts_data = {}

	for i = 1, self.ROWS do
		self._texts_data[i] = {}
		self._texts_data[i].speed = 120 + 240 * math.rand(1)
		self._texts_data[i].gap = 20
		self._texts_data[i].texts_data = {}
		self._texts_data[i].iterator = 1
		self._texts_data[i].guis = {}
	end

	self._text = "HELLO WORLD!"
	self._gui_object = self._gui_object or "gui_object"
	self._new_gui = World:gui()

	self:add_workspace(self._unit:get_object(Idstring(self._gui_object)))
	self:setup()
	self._unit:set_extension_update_enabled(Idstring("text_gui"), true)
end

function TextGui:add_workspace(gui_object)
	self._ws = self._new_gui:create_object_workspace(self.WIDTH, self.HEIGHT, gui_object, Vector3(0, 0, 0))
	self._panel = self._ws:panel()
end

function TextGui:setup()
	self._panel:clear()

	if self.BG_COLOR then
		self._bg_rect = self._panel:rect({
			color = self.BG_COLOR,
			layer = -1,
		})
	end

	local font_size = self.FONT_SIZE
end

function TextGui:_create_text_gui(row)
	local data = self._texts_data[row]
	local text_data = data.texts_data[data.iterator]

	if not text_data then
		return
	end

	local color = self.COLORS[text_data.color_type or self.COLOR_TYPE]
	local font_size = text_data.font_size or self.FONT_SIZE
	local font = text_data.font or self.FONT
	local gui = self._panel:text({
		align = "center",
		color = color,
		font = font,
		font_size = font_size,
		layer = 0,
		text = text_data.text,
		vertical = "center",
		visible = true,
		y = 0,
	})

	if self.RENDER_TEMPLATE then
		gui:set_render_template(Idstring(self.RENDER_TEMPLATE))
	end

	if self.BLEND_MODE then
		gui:set_blend_mode(self.BLEND_MODE)
	end

	local _, _, w, h = gui:text_rect()

	gui:set_w(w)
	gui:set_h(h)

	local y = self._panel:h()

	if text_data.align_h and text_data.align_h == "bottom" then
		gui:set_bottom((row - 1) * (y / self.ROWS) + y / self.ROWS)
	else
		gui:set_center_y((row - 1) * (y / self.ROWS) + y / self.ROWS / 2)
	end

	local x = self._panel:w()

	if not self.START_RIGHT then
		if #data.guis > 0 then
			local last_gui = data.guis[#data.guis]

			x = last_gui.x + last_gui.gui:w() + data.gap
		else
			x = 0
		end
	end

	gui:set_x(x)
	table.insert(data.guis, {
		gui = gui,
		x = x,
	})

	if text_data.once then
		table.remove(data.texts_data, data.iterator)
	end

	data.iterator = data.iterator + 1

	if data.iterator > #data.texts_data then
		data.iterator = 1
	end
end

function TextGui:update(unit, t, dt)
	if not self._visible then
		return
	end

	for row, data in ipairs(self._texts_data) do
		if #data.texts_data > 0 and #data.guis == 0 then
			self:_create_text_gui(row)
		end

		local i = 1

		while i <= #data.guis do
			local gui_data = data.guis[i]

			gui_data.gui:set_x(gui_data.x)

			gui_data.x = gui_data.x - data.speed * dt

			if i == #data.guis and gui_data.x + gui_data.gui:w() + data.gap < self._panel:w() then
				self:_create_text_gui(row)
			end

			if gui_data.x + gui_data.gui:w() < 0 then
				gui_data.gui:parent():remove(gui_data.gui)
				table.remove(data.guis, i)
			else
				i = i + 1
			end
		end
	end
end

function TextGui:set_color_type(type)
	self.COLOR_TYPE = type
	self.TEXT_COLOR = TextGui.COLORS[self.COLOR_TYPE]
end

function TextGui:set_bg_color_type(type)
	self.BG_COLOR_TYPE = type
	self.BG_COLOR = self.BG_COLOR_TYPE and TextGui.COLORS[self.BG_COLOR_TYPE] or nil

	if self.BG_COLOR then
		self._bg_rect = self._bg_rect or self._panel:rect({
			color = self.BG_COLOR,
			layer = -1,
		})

		self._bg_rect:set_color(self.BG_COLOR)
	elseif alive(self._bg_rect) then
		self._bg_rect:parent():remove(self._bg_rect)

		self._bg_rect = nil
	end
end

function TextGui:add_once_text(...)
	local t = self:add_text(...)

	t.once = true
end

function TextGui:add_text(row, text, color_type, font_size, align_h, font)
	local data = self._texts_data[row]

	table.insert(data.texts_data, {
		align_h = align_h,
		color_type = color_type,
		font = font,
		font_size = font_size,
		text = text,
	})

	return data.texts_data[#data.texts_data]
end

function TextGui:set_row_speed(row, speed)
	local data = self._texts_data[row]

	data.speed = speed
end

function TextGui:set_row_gap(row, gap)
	local data = self._texts_data[row]

	data.gap = gap
end

function TextGui:clear_row_and_guis(row)
	local data = self._texts_data[row]

	while #data.guis > 0 do
		local gui_data = table.remove(data.guis)

		gui_data.gui:parent():remove(gui_data.gui)
	end

	self:clear_row(row)
end

function TextGui:clear_row(row)
	local data = self._texts_data[row]

	data.texts_data = {}
	data.iterator = 1
end

function TextGui:_test()
	return
end

function TextGui:_test2()
	return
end

function TextGui:_sequence_trigger(sequence_name)
	if not Network:is_server() then
		return
	end

	if self._unit:damage():has_sequence(sequence_name) then
		self._unit:damage():run_sequence_simple(sequence_name)
	end
end

function TextGui:set_visible(visible)
	self._visible = visible

	if visible then
		self._ws:show()
	else
		self._ws:hide()
	end
end

function TextGui:lock_gui()
	self._ws:set_cull_distance(self._cull_distance)
	self._ws:set_frozen(true)
end

function TextGui:sync_gui_net_event(event_id, value)
	if event_id == TextGui.GUI_EVENT_IDS.syncronize then
		self:timer_set(value)
	elseif event_id == TextGui.GUI_EVENT_IDS.timer_set then
		self:timer_set(value)
	elseif event_id == TextGui.GUI_EVENT_IDS.timer_start_count_up then
		self:timer_start_count_up()
	elseif event_id == TextGui.GUI_EVENT_IDS.timer_start_count_down then
		self:timer_start_count_down()
	elseif event_id == TextGui.GUI_EVENT_IDS.timer_pause then
		self:timer_pause()
	elseif event_id == TextGui.GUI_EVENT_IDS.timer_resume then
		self:timer_resume()
	elseif event_id == TextGui.GUI_EVENT_IDS.number_set then
		self:number_set(value)
	end
end

function TextGui:destroy()
	if alive(self._new_gui) and alive(self._ws) then
		self._new_gui:destroy_workspace(self._ws)

		self._ws = nil
		self._new_gui = nil
	end
end

function TextGui:save(data)
	local state = {}

	state.COLOR_TYPE = self.COLOR_TYPE
	state.BG_COLOR_TYPE = self.BG_COLOR_TYPE
	state.visible = self._visible
	data.TextGui = state
end

function TextGui:load(data)
	local state = data.TextGui

	self:set_color_type(state.COLOR_TYPE)
	self:set_bg_color_type(state.BG_COLOR_TYPE)

	if state.visible ~= self._visible then
		self:set_visible(state.visible)
	end
end
