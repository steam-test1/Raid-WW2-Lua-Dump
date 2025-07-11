core:import("CoreEnvironmentEffectsManager")

local is_editor = Application:editor()

EnvironmentEffectsManager = EnvironmentEffectsManager or class(CoreEnvironmentEffectsManager.EnvironmentEffectsManager)

function EnvironmentEffectsManager:init()
	EnvironmentEffectsManager.super.init(self)
	self:add_effect("rain", RainEffect:new())
	self:add_effect("rain_light", RainEffectLight:new())
	self:add_effect("raindrop_screen", RainDropScreenEffect:new())
	self:add_effect("lightning", LightningEffect:new())
	self:add_effect("speed_lines", SpeedLinesEffect:new())
	self:add_effect("smoke_of_war", SmokeOfWarEffect:new())

	self._camera_position = Vector3()
	self._camera_rotation = Rotation()
end

function EnvironmentEffectsManager:update(t, dt)
	self._camera_position = managers.viewport:get_current_camera_position()
	self._camera_rotation = managers.viewport:get_current_camera_rotation()

	EnvironmentEffectsManager.super.update(self, t, dt)
end

function EnvironmentEffectsManager:camera_position()
	return self._camera_position
end

function EnvironmentEffectsManager:camera_rotation()
	return self._camera_rotation
end

EnvironmentEffect = EnvironmentEffect or class()

function EnvironmentEffect:init(default)
	self._default = default
end

function EnvironmentEffect:load_effects()
	return
end

function EnvironmentEffect:update(t, dt)
	return
end

function EnvironmentEffect:start()
	return
end

function EnvironmentEffect:stop()
	return
end

function EnvironmentEffect:default()
	return self._default
end

RainEffect = RainEffect or class(EnvironmentEffect)

function RainEffect:init()
	EnvironmentEffect.init(self)

	self._effect_name = Idstring("effects/vanilla/rain/rain_01_a")
end

function RainEffect:load_effects()
	if is_editor then
		CoreEngineAccess._editor_load(Idstring("effect"), self._effect_name)
	end
end

function RainEffect:update(t, dt)
	local vp = managers.viewport:first_active_viewport()

	if vp and self._vp ~= vp then
		vp:vp():set_post_processor_effect("World", Idstring("streaks"), Idstring("streaks_rain"))

		if alive(self._vp) then
			self._vp:vp():set_post_processor_effect("World", Idstring("streaks"), Idstring("streaks"))
		end

		self._vp = vp
	end

	local c_pos = managers.environment_effects:camera_position()

	if not c_pos then
		return
	end

	World:effect_manager():move(self._effect, c_pos)
end

function RainEffect:start()
	self._effect = World:effect_manager():spawn({
		effect = self._effect_name,
		position = Vector3(),
		rotation = Rotation(),
	})
end

function RainEffect:stop()
	World:effect_manager():kill(self._effect)

	self._effect = nil

	if alive(self._vp) then
		self._vp:vp():set_post_processor_effect("World", Idstring("streaks"), Idstring("streaks"))

		self._vp = nil
	end
end

RainEffectLight = RainEffectLight or class(RainEffect)

function RainEffectLight:init()
	RainEffect.init(self)

	self._effect_name = Idstring("effects/vanilla/rain/rain_01_a_light")
end

LightningEffect = LightningEffect or class(EnvironmentEffect)

function LightningEffect:init()
	EnvironmentEffect.init(self)
end

function LightningEffect:load_effects()
	return
end

function LightningEffect:_update_wait_start()
	if Underlay:loaded() then
		self:start()
	end
end

function LightningEffect:_update(t, dt)
	if not self._sky_material or not self._sky_material:alive() then
		self._sky_material = Underlay:material(Idstring("sky"))
	end

	if self._flashing then
		self:_update_function(t, dt)
	end

	if self._sound_delay then
		self._sound_delay = self._sound_delay - dt

		if self._sound_delay <= 0 then
			self._sound_delay = nil
		end
	end

	self._next = self._next - dt

	if self._next <= 0 then
		self:_set_lightning_values()
		self:_make_lightning()

		self._update_function = self._update_first

		self:_set_next_timer()

		self._flashing = true
	end
end

function LightningEffect:start()
	if not Underlay:loaded() then
		self.update = self._update_wait_start

		return
	end

	self.update = self._update
	self._sky_material = Underlay:material(Idstring("sky"))
	self._original_color0 = self._sky_material:get_variable(Idstring("color0"))
	self._original_light_color = Global._global_light:color()
	self._original_sun_horizontal = Underlay:time(Idstring("sun_horizontal"))
	self._min_interval = 2
	self._rnd_interval = 10
	self._sound_source = SoundDevice:create_source("thunder")

	self:_set_next_timer()
end

function LightningEffect:stop()
	self:_set_original_values()
end

function LightningEffect:_update_first(t, dt)
	self._first_flash_time = self._first_flash_time - dt

	if self._first_flash_time <= 0 then
		self:_set_original_values()

		self._update_function = self._update_pause
	end
end

function LightningEffect:_update_pause(t, dt)
	self._pause_flash_time = self._pause_flash_time - dt

	if self._pause_flash_time <= 0 then
		self:_make_lightning()

		self._update_function = self._update_second
	end
end

function LightningEffect:_update_second(t, dt)
	self._second_flash_time = self._second_flash_time - dt

	if self._second_flash_time <= 0 then
		self:_set_original_values()

		self._flashing = false
	end
end

function LightningEffect:_set_original_values()
	self._sky_material:set_variable(Idstring("color0"), self._original_color0)
	Global._global_light:set_color(self._original_light_color)
	Underlay:set_time(Idstring("sun_horizontal"), self._original_sun_horizontal)
end

function LightningEffect:_make_lightning()
	self._sky_material:set_variable(Idstring("color0"), self._intensity_value)
	Global._global_light:set_color(self._intensity_value)
	Underlay:set_time(Idstring("sun_horizontal"), self._flash_anim_time)
end

function LightningEffect:_set_lightning_values()
	self._first_flash_time = 0.1
	self._pause_flash_time = 0.1
	self._second_flash_time = 0.3
	self._flash_roll = math.rand(360)
	self._flash_dir = Rotation(0, 0, self._flash_roll):y()
	self._flash_anim_time = math.rand(0, 1)
	self._distance = math.rand(1)
	self._intensity_value = math.lerp(Vector3(2, 2, 2), Vector3(5, 5, 5), self._distance)

	local c_pos = managers.environment_effects:camera_position()

	if c_pos then
		local sound_speed = 30000

		self._sound_delay = self._distance * 2

		self._sound_source:set_rtpc("lightning_distance", self._distance * 4000)
	end
end

function LightningEffect:_set_next_timer()
	self._next = self._min_interval + math.rand(self._rnd_interval)
end

RainDropScreenEffect = RainDropScreenEffect or class(EnvironmentEffect)

function RainDropScreenEffect:init()
	EnvironmentEffect.init(self)

	self._material = nil
	self._settings_1 = nil
	self._settings_2 = nil
end

function RainDropScreenEffect:update(t, dt)
	for name, value in pairs(self._settings_2) do
		local new_alpha = math.max(value.y - dt * 0.5, 0)

		if new_alpha == 0 then
			local player = managers.player:local_player()

			if not player then
				return
			end

			local camera_y = math.rad(player:camera():rotation():pitch()) / math.rad(FPCameraPlayerBase.MAX_PITCH)

			camera_y = math.max(math.min(camera_y, 1), -1)
			camera_y = camera_y * 0.5 + 0.5
			camera_y = math.pow(camera_y, 5)

			if camera_y > math.random() then
				mvector3.set(value, Vector3(math.random(), math.random(), 0))

				local offset_x = math.random() * math.random()
				local offset_y = math.random() * math.random()

				mvector3.set(self._settings_1[name], Vector3(offset_x, offset_y, math.random() * 2 * math.pi))
			end
		else
			mvector3.set(value, Vector3(value.x, new_alpha, value.z))
		end
	end

	self:_set_variables()
end

function RainDropScreenEffect:_acquire_material(...)
	local vp = managers.viewport:first_active_viewport()

	if vp then
		vp:vp():set_post_processor_effect("World", Idstring("water_drops"), Idstring("water_drops"))

		self._material = vp:vp():get_post_processor_effect("World", Idstring("water_drops")):modifier(Idstring("water_drops_mod")):material()
	end
end

function RainDropScreenEffect:start()
	self._settings_1 = {
		uv_settings1 = Vector3(math.random(), math.random(), math.random() * 2 * math.pi),
		uv_settings2 = Vector3(math.random(), math.random(), math.random() * 2 * math.pi),
		uv_settings3 = Vector3(math.random(), math.random(), math.random() * 2 * math.pi),
		uv_settings4 = Vector3(math.random(), math.random(), math.random() * 2 * math.pi),
	}
	self._settings_2 = {
		uv_settings1 = Vector3(math.random(), math.random(), 0),
		uv_settings2 = Vector3(math.random(), math.random(), 0),
		uv_settings3 = Vector3(math.random(), math.random(), 0),
		uv_settings4 = Vector3(math.random(), math.random(), 0),
	}

	self:_set_variables()
end

function RainDropScreenEffect:_set_variables()
	if not self._material then
		self:_acquire_material()

		if not self._material then
			return
		end
	end

	for name, value in pairs(self._settings_1) do
		self._material:set_variable(Idstring(name .. "_1"), value)
	end

	for name, value in pairs(self._settings_2) do
		self._material:set_variable(Idstring(name .. "_2"), value)
	end
end

function RainDropScreenEffect:stop()
	local vp = managers.viewport:first_active_viewport()

	if vp then
		vp:vp():set_post_processor_effect("World", Idstring("water_drops"), Idstring("empty"))
	end

	self._material = nil
end

SpeedLinesEffect = SpeedLinesEffect or class(EnvironmentEffect)

function SpeedLinesEffect:init()
	EnvironmentEffect.init(self)

	self._effect_name = Idstring("effects/upd_skills/character/speed_lines_01")
end

function SpeedLinesEffect:load_effects()
	if is_editor then
		CoreEngineAccess._editor_load(Idstring("effect"), self._effect_name)
	end
end

function SpeedLinesEffect:update(t, dt)
	local c_pos = managers.environment_effects:camera_position()

	if not c_pos then
		return
	end

	World:effect_manager():move(self._effect, c_pos)
end

function SpeedLinesEffect:start()
	local c_rot = managers.environment_effects:camera_rotation()

	if not c_rot then
		return
	end

	local yaw = c_rot:yaw() + 90

	self._effect = World:effect_manager():spawn({
		effect = self._effect_name,
		position = Vector3(),
		rotation = Rotation(yaw, 0, 0),
	})
end

function SpeedLinesEffect:stop()
	World:effect_manager():kill(self._effect)

	self._effect = nil
end

SmokeOfWarEffect = SmokeOfWarEffect or class(EnvironmentEffect)

function SmokeOfWarEffect:init()
	EnvironmentEffect.init(self)

	self._effect_name = Idstring("effects/vanilla/environment/smoke_of_war")
end

function SmokeOfWarEffect:load_effects()
	if is_editor then
		CoreEngineAccess._editor_load(Idstring("effect"), self._effect_name)
	end
end

function SmokeOfWarEffect:update(t, dt)
	local c_pos = managers.environment_effects:camera_position()

	if not c_pos then
		return
	end

	World:effect_manager():move(self._effect, c_pos)
end

function SmokeOfWarEffect:start()
	self._effect = World:effect_manager():spawn({
		effect = self._effect_name,
		position = Vector3(),
		rotation = Rotation(),
	})
end

function SmokeOfWarEffect:stop()
	World:effect_manager():kill(self._effect)

	self._effect = nil
end

CoreClass.override_class(CoreEnvironmentEffectsManager.EnvironmentEffectsManager, EnvironmentEffectsManager)
