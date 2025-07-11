HUDCombatDebug = HUDCombatDebug or class()

function HUDCombatDebug:init(hud)
	self._hud_panel = hud.panel
	self._is_shown = false

	if self._hud_panel:child("combat_debug_panel") then
		self._hud_panel:remove(self._hud_panel:child("combat_debug_panel"))
	end

	self._combat_debug_panel = self._hud_panel:panel({
		h = 265,
		halign = "center",
		layer = 99,
		name = "combat_debug_panel",
		valign = "center",
		visible = false,
		w = 300,
	})

	self._combat_debug_panel:set_center(0.8888888888888888 * self._combat_debug_panel:parent():w() / 2, self._combat_debug_panel:parent():h() / 2)
	self._combat_debug_panel:set_right(self._combat_debug_panel:parent():w())

	local background = self._combat_debug_panel:rect({
		color = Color.black:with_alpha(0.7),
		h = self._combat_debug_panel:h(),
		name = "combat_debug_bg",
		w = self._combat_debug_panel:w(),
		x = 0,
		y = 0,
	})

	self._default_font_size = tweak_data.gui.font_sizes.size_16
	self._default_font = tweak_data.gui:get_font_path(tweak_data.gui.fonts.lato, self._default_font_size)
	self._game_intensity = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.937, 0.6, 0.2),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_intensity",
		text = "Game intensity:",
		vertical = "top",
		visible = true,
		x = 10,
		y = 20,
	})
	self._current_phase = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.937, 0.6, 0.2),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase",
		text = "Current phase:",
		vertical = "top",
		visible = true,
		x = 10,
		y = 40,
	})
	self._current_phase_duration = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.937, 0.6, 0.2),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_duration",
		text = "Current phase - time elapsed:",
		vertical = "top",
		visible = true,
		x = 10,
		y = 60,
	})
	self._phase_number = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.2, 0.7529411764705882, 0.9372549019607843),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_number",
		text = "Phase number:",
		vertical = "top",
		visible = true,
		x = 10,
		y = 80,
	})
	self._spawned_phase = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.3058823529411765, 0.6745098039215687, 0.23137254901960785),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_enemies_spawned",
		text = "Enemies spawned (phase):",
		vertical = "top",
		visible = true,
		x = 10,
		y = 100,
	})
	self._killed_phase = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.2980392156862745, 0.796078431372549, 0.2823529411764706),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_enemies_killed",
		text = "Enemies killed (phase):",
		vertical = "top",
		visible = true,
		x = 10,
		y = 120,
	})
	self._spawned_lifetime = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.7137254901960784, 0.2627450980392157, 0.7411764705882353),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_lifetime_enemies_spawned",
		text = "Enemies spawned (lifetime):",
		vertical = "top",
		visible = true,
		x = 10,
		y = 140,
	})
	self._killed_lifetime = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.8509803921568627, 0.3568627450980392, 0.8823529411764706),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_lifetime_enemies_killed",
		text = "Enemies killed (lifetime):",
		vertical = "top",
		visible = true,
		x = 10,
		y = 160,
	})
	self._enemies_alive = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_enemies_alive",
		text = "Enemies alive:",
		vertical = "top",
		visible = true,
		x = 10,
		y = 180,
	})
	self._music_state = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_music_state",
		text = "Music state:",
		vertical = "top",
		visible = true,
		x = 10,
		y = 200,
	})
	self._player_world = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_wrld_players",
		text = "Player in world:",
		vertical = "top",
		visible = true,
		x = 10,
		y = 220,
	})
	self._wrld_alarm_state = self._combat_debug_panel:text({
		align = "left",
		blend_mode = "normal",
		color = Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_wrld_alarm_state",
		text = "Alarm state:",
		vertical = "top",
		visible = true,
		x = 10,
		y = 240,
	})
	self._game_intensity_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.937, 0.6, 0.2),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_intensity_val",
		text = "",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._game_intensity:y(),
	})
	self._current_phase_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.937, 0.6, 0.2),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_val",
		text = "reenforce",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._current_phase:y(),
	})
	self._current_phase_duration_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.937, 0.6, 0.2),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_duration_val",
		text = "0",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._current_phase_duration:y(),
	})
	self._current_phase_timer = 0
	self._phase_number_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.2, 0.7529411764705882, 0.9372549019607843),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_number_val",
		text = "0",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._phase_number:y(),
	})
	self._spawned_phase_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.3058823529411765, 0.6745098039215687, 0.23137254901960785),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_enemies_spawned_val",
		text = "0",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._spawned_phase:y(),
	})
	self._killed_phase_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.2980392156862745, 0.796078431372549, 0.2823529411764706),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_phase_enemies_killed_val",
		text = "0",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._killed_phase:y(),
	})
	self._spawned_lifetime_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.7137254901960784, 0.2627450980392157, 0.7411764705882353),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_lifetime_enemies_spawned_val",
		text = "0",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._spawned_lifetime:y(),
	})
	self._killed_lifetime_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.8509803921568627, 0.3568627450980392, 0.8823529411764706),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_lifetime_enemies_killed_val",
		text = "0",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._killed_lifetime:y(),
	})
	self._enemies_alive_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_enemies_alive_val",
		text = "0",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._enemies_alive:y(),
	})
	self._music_state_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_music_state_val",
		text = "none",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._music_state:y(),
	})
	self._player_world_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_player_world_val",
		text = "none",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._player_world:y(),
	})
	self._wrld_alarm_state_val = self._combat_debug_panel:text({
		align = "right",
		blend_mode = "normal",
		color = Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392),
		font = self._default_font,
		font_size = self._default_font_size,
		layer = background:layer() + 1,
		name = "combat_debug_wrld_alarm_state_val",
		text = "none",
		vertical = "top",
		visible = true,
		x = -10,
		y = self._wrld_alarm_state:y(),
	})

	managers.hud:add_updator("combat_debug_panel", callback(self, self, "update"))
end

function HUDCombatDebug:update(t, dt)
	self._current_phase_timer = self._current_phase_timer + dt

	if self._is_shown == false then
		return
	end

	if not managers.navigation or not managers.worldcollection then
		return
	end

	local game_intensity = string.format("%.3f", tostring(managers.groupai:state():get_difficulty()))

	if self._game_intensity_val:text() ~= game_intensity then
		self._game_intensity_val:set_text(game_intensity)
		self._game_intensity_val:stop()
		self._game_intensity_val:animate(callback(self, self, "_animate_change"), Color(0.937, 0.6, 0.2))
	end

	local current_phase = tostring(managers.groupai:state():current_phase())

	if self._current_phase_val:text() ~= current_phase then
		self._current_phase_val:set_text(current_phase)
		self._current_phase_val:stop()
		self._current_phase_val:animate(callback(self, self, "_animate_change"), Color(0.937, 0.6, 0.2))
		self._current_phase_duration_val:stop()
		self._current_phase_duration_val:animate(callback(self, self, "_animate_change"), Color(0.937, 0.6, 0.2))

		self._current_phase_timer = 0
	end

	local curr_t = math.floor(self._current_phase_timer + 0.5)

	self._current_phase_duration_val:set_text(string.format("%.2d:%.2d:%.2d", curr_t / 3600, curr_t / 60 % 60, curr_t % 60))

	local phase_number = tostring(managers.groupai:state():wave_number())

	if self._phase_number_val:text() ~= phase_number then
		self._phase_number_val:set_text(phase_number)
		self._phase_number_val:stop()
		self._phase_number_val:animate(callback(self, self, "_animate_change"), Color(0.2, 0.7529411764705882, 0.9372549019607843))
	end

	local spawned_phase = tostring(managers.groupai:state():enemies_spawned_in_current_phase())

	if self._spawned_phase_val:text() ~= spawned_phase then
		self._spawned_phase_val:set_text(spawned_phase)
		self._spawned_phase_val:stop()
		self._spawned_phase_val:animate(callback(self, self, "_animate_change"), Color(0.3058823529411765, 0.6745098039215687, 0.23137254901960785))
	end

	local killed_phase = tostring(managers.groupai:state():enemies_killed_in_current_phase())

	if self._killed_phase_val:text() ~= killed_phase then
		self._killed_phase_val:set_text(killed_phase)
		self._killed_phase_val:stop()
		self._killed_phase_val:animate(callback(self, self, "_animate_change"), Color(0.2980392156862745, 0.796078431372549, 0.2823529411764706))
	end

	local spawned_lifetime = tostring(managers.groupai:state():enemies_spawned_lifetime())

	if self._spawned_lifetime_val:text() ~= spawned_lifetime then
		self._spawned_lifetime_val:set_text(spawned_lifetime)
		self._spawned_lifetime_val:stop()
		self._spawned_lifetime_val:animate(callback(self, self, "_animate_change"), Color(0.7137254901960784, 0.2627450980392157, 0.7411764705882353))
	end

	local kills_lifetime = tostring(managers.groupai:state():enemies_killed_lifetime())

	if self._killed_lifetime_val:text() ~= kills_lifetime then
		self._killed_lifetime_val:set_text(kills_lifetime)
		self._killed_lifetime_val:stop()
		self._killed_lifetime_val:animate(callback(self, self, "_animate_change"), Color(0.8509803921568627, 0.3568627450980392, 0.8823529411764706))
	end

	local enemies_alive = tostring(managers.groupai:state():enemies_in_level())

	if self._enemies_alive_val:text() ~= enemies_alive then
		self._enemies_alive_val:set_text(enemies_alive)
		self._enemies_alive_val:stop()
		self._enemies_alive_val:animate(callback(self, self, "_animate_change"), Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392))
	end

	if managers.player:local_player() and managers.groupai:state() then
		local worlds = managers.groupai:state():get_last_world_ids_for_criminals()
		local txt = ""

		for _, player_world_id in ipairs(worlds) do
			txt = txt .. "_" .. tostring(player_world_id)
		end

		if self._player_world_val:text() ~= txt then
			self:set_player_world(txt)
		end
	end

	if managers.player:local_player() and managers.worldcollection:check_all_worlds_prepared() then
		local world = managers.worldcollection:get_world_id_from_pos(managers.player:local_player():position())
		local alarm = managers.worldcollection:get_alarm_for_world(world)

		if self._wrld_alarm_state_val:text() ~= tostring(alarm) then
			self:set_wrld_alarm_state(alarm)
		end
	end
end

function HUDCombatDebug:set_music_state(state_flag)
	self._music_state_val:set_text(tostring(state_flag))
	self._music_state_val:stop()
	self._music_state_val:animate(callback(self, self, "_animate_change"), Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392))
end

function HUDCombatDebug:set_player_world(state_flag)
	self._player_world_val:set_text(tostring(state_flag))
	self._player_world_val:stop()
	self._player_world_val:animate(callback(self, self, "_animate_change"), Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392))
end

function HUDCombatDebug:set_wrld_alarm_state(state_flag)
	self._wrld_alarm_state_val:set_text(tostring(state_flag))
	self._wrld_alarm_state_val:stop()
	self._wrld_alarm_state_val:animate(callback(self, self, "_animate_change"), Color(0.8823529411764706, 0.3568627450980392, 0.3568627450980392))
end

function HUDCombatDebug:toggle()
	if self._combat_debug_panel:visible() == true then
		self._combat_debug_panel:set_visible(false)

		self._is_shown = false
	else
		self._combat_debug_panel:set_visible(true)

		self._is_shown = true
	end
end

function HUDCombatDebug:is_shown()
	return self._is_shown
end

function HUDCombatDebug:clean_up()
	managers.hud:remove_updator("combat_debug_panel")
	self._combat_debug_panel:parent():remove(self._combat_debug_panel)
end

function HUDCombatDebug:_animate_change(text, final_color)
	local starting_color = Color.red
	local curr_color = starting_color
	local t = 0

	text:set_x(-30)

	while t < 0.5 do
		local dt = coroutine.yield()

		t = t + dt

		text:set_x(self:_ease_in_quart(t, -30, 20, 0.5))

		local new_r = self:_ease_in_quart(t, starting_color.r, final_color.r, 0.5)
		local new_g = self:_ease_in_quart(t, starting_color.g, final_color.g, 0.5)
		local new_b = self:_ease_in_quart(t, starting_color.b, final_color.b, 0.5)

		text:set_color(Color(new_r, new_g, new_b))
	end

	text:set_x(-10)
	text:set_color(final_color)
end

function HUDCombatDebug:_ease_in_quart(t, starting_value, change, duration)
	t = t / duration

	return change * t * t * t * t + starting_value
end
