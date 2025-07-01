TimeSpeedEffectTweakData = TimeSpeedEffectTweakData or class()

function TimeSpeedEffectTweakData:init()
	self:_init_base_effects()
	self:_init_mission_effects()
end

function TimeSpeedEffectTweakData:_init_base_effects()
	self.mask_on = {
		fade_in = 0.25,
		fade_in_delay = 1.35,
		fade_out = 0.8,
		speed = 0.2,
		sustain = 5,
		timer = "pausable",
	}
	self.mask_on_player = {
		affect_timer = "player",
		speed = 0.5,
		fade_in = self.mask_on.fade_in,
		fade_in_delay = self.mask_on.fade_in_delay,
		fade_out = self.mask_on.fade_out,
		sustain = self.mask_on.sustain,
		timer = self.mask_on.timer,
	}
	self.downed = {
		fade_in = 0.25,
		fade_out = 0.8,
		speed = 0.3,
		sustain = 3,
		timer = "pausable",
	}
	self.downed_player = {
		affect_timer = "player",
		fade_in = self.downed.fade_in,
		fade_out = self.downed.fade_out,
		speed = self.downed.speed,
		sustain = self.downed.sustain,
		timer = self.downed.timer,
	}
end

function TimeSpeedEffectTweakData:_init_mission_effects()
	self.mission_effects = {}
	self.mission_effects.quickdraw = {
		fade_in = 0.3,
		fade_in_delay = 0.5,
		fade_out = 0.8,
		speed = 0.2,
		sustain = 5,
		sync = true,
		timer = "pausable",
	}
	self.mission_effects.quickdraw_player = {
		affect_timer = "player",
		speed = 0.5,
		sync = true,
		timer = "pausable",
		fade_in = self.mission_effects.quickdraw.fade_in,
		fade_in_delay = self.mission_effects.quickdraw.fade_in_delay,
		fade_out = self.mission_effects.quickdraw.fade_out,
		sustain = self.mission_effects.quickdraw.sustain,
	}
end
