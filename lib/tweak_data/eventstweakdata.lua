EventsTweakData = EventsTweakData or class()
EventsTweakData.REWERD_TYPE_GOLD = "REWERD_TYPE_GOLD"

function EventsTweakData:init()
	self.active_duty_bonus_rewards = {}
	self.active_duty_bonus_rewards[1] = {}
	self.active_duty_bonus_rewards[1].reward = EventsTweakData.REWERD_TYPE_GOLD
	self.active_duty_bonus_rewards[1].amount = 1
	self.active_duty_bonus_rewards[2] = {}
	self.active_duty_bonus_rewards[2].reward = EventsTweakData.REWERD_TYPE_GOLD
	self.active_duty_bonus_rewards[2].amount = 1
	self.active_duty_bonus_rewards[3] = {}
	self.active_duty_bonus_rewards[3].reward = EventsTweakData.REWERD_TYPE_GOLD
	self.active_duty_bonus_rewards[3].amount = 1
	self.active_duty_bonus_rewards[4] = {}
	self.active_duty_bonus_rewards[4].reward = EventsTweakData.REWERD_TYPE_GOLD
	self.active_duty_bonus_rewards[4].amount = 2
	self.active_duty_bonus_rewards[5] = {}
	self.active_duty_bonus_rewards[5].reward = EventsTweakData.REWERD_TYPE_GOLD
	self.active_duty_bonus_rewards[5].amount = 5
end
