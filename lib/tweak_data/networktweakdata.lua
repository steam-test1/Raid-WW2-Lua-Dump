NetworkTweakData = NetworkTweakData or class()

function NetworkTweakData:init(tweak_data)
	self.camera = {
		angle_delta = 45,
		sync_delta_t = 0.5,
		wait_delta_t = 0.2,
	}
	self.driving = {
		wait_delta_t = 0.05,
		wait_distance = 1,
	}
	self.team_ai = {
		wait_delta_t = 0.5,
	}
	self.stealth_speed_boost = 1.025
end
