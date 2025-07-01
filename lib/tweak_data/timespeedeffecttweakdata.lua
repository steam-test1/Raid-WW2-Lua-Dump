TimeSpeedEffectTweakData = TimeSpeedEffectTweakData or class()

function TimeSpeedEffectTweakData:init()
	self.buff_effect = {
		affect_timer = {
			"player",
			"pausable",
			"game_animation",
		},
		speed = 1,
		timer = "pausable",
	}
end
