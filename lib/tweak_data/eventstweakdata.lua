EventsTweakData = EventsTweakData or class()
EventsTweakData.REWARD_TYPE_GOLD = "REWARD_TYPE_GOLD"
EventsTweakData.REWARD_TYPE_OUTLAW = "REWARD_TYPE_OUTLAW"
EventsTweakData.REWARD_ICON_SINGLE = "gold_bar_single"
EventsTweakData.REWARD_ICON_FEW = "gold_bar_3"
EventsTweakData.REWARD_ICON_MANY = "gold_bar_box"
EventsTweakData.REWARD_ICON_OUTLAW = "outlaw_raid_hud_item"

function EventsTweakData:init()
	self.login_rewards = {}
	self.login_rewards.active_duty = {
		{
			amount = 5,
			icon = EventsTweakData.REWARD_ICON_SINGLE,
			reward = EventsTweakData.REWARD_TYPE_GOLD,
		},
		{
			amount = 10,
			icon = EventsTweakData.REWARD_ICON_FEW,
			reward = EventsTweakData.REWARD_TYPE_GOLD,
		},
		{
			amount = 20,
			icon = EventsTweakData.REWARD_ICON_FEW,
			reward = EventsTweakData.REWARD_TYPE_GOLD,
		},
		{
			amount = 30,
			icon = EventsTweakData.REWARD_ICON_MANY,
			reward = EventsTweakData.REWARD_TYPE_GOLD,
		},
		{
			amount = 50,
			icon = EventsTweakData.REWARD_ICON_MANY,
			icon_outlaw = EventsTweakData.REWARD_ICON_OUTLAW,
			reward = EventsTweakData.REWARD_TYPE_OUTLAW,
		},
	}
end
