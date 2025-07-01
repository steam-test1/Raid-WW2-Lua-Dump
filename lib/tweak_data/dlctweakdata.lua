DLCTweakData = DLCTweakData or class()
DLCTweakData.DLC_NAME_PREORDER = "preorder"
DLCTweakData.DLC_NAME_BETA = "beta"

function DLCTweakData:init(tweak_data)
	if managers.dlc:is_installing() then
		tweak_data.BUNDLED_DLC_PACKAGES = {}
	else
		tweak_data.BUNDLED_DLC_PACKAGES = {}
	end

	self.preorder = {}
	self.preorder.content = {}
	self.beta = {}
	self.beta.content = {}
	self.starter_kit = {}
	self.starter_kit.free = true
	self.starter_kit.content = {}
	self.starter_kit.content.loot_global_value = "normal"
	self.starter_kit.content.loot_drops = {}
	self.starter_kit.content.upgrades = {
		"m3_knife",
		"m24",
		"coin_peace",
	}
end
