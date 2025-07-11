DLCTweakData = DLCTweakData or class()
DLCTweakData.DLC_GRANT_TYPE_AUTO = 1
DLCTweakData.DLC_GRANT_TYPE_DROP = 2
DLCTweakData.DLC_GRANT_TYPE_BUY = 3
DLCTweakData.DLC_NAME_FULL_GAME = "full_game"
DLCTweakData.DLC_NAME_PREORDER = "preorder"
DLCTweakData.DLC_NAME_SPECIAL_EDITION = "special_edition"
DLCTweakData.DLC_NAME_OFFICIAL_SOUNDTRACK = "official_soundtrack"
DLCTweakData.DLC_NAME_STARTER_KIT = "starter_kit"

function DLCTweakData:init(tweak_data)
	tweak_data.BUNDLED_DLC_PACKAGES = {}

	self:_init_descriptions()
end

function DLCTweakData:_init_descriptions()
	self.descriptions = {}
	self.descriptions[DLCTweakData.DLC_NAME_STARTER_KIT] = {
		content = {
			gold_award = {
				amount = 50,
				item = "starter_kit_army_crate",
			},
			loot_global_value = "normal",
		},
		free = true,
	}
	self.descriptions[DLCTweakData.DLC_NAME_PREORDER] = {
		content = {
			customizations = {
				{
					item = "american_highlander_jacket_upper",
				},
				{
					item = "american_highlander_jacket_lower",
				},
				{
					item = "russian_highlander_jacket_upper",
				},
				{
					item = "russian_highlander_jacket_lower",
				},
				{
					item = "german_highlander_jacket_upper",
				},
				{
					item = "german_highlander_jacket_lower",
				},
				{
					item = "british_highlander_jacket_upper",
				},
				{
					item = "british_highlander_jacket_lower",
				},
			},
			gold_award = {
				amount = 50,
				item = "preorder_army_crate",
			},
			weapon_skins = {
				{
					item = "garand_special_edition",
				},
			},
		},
	}
	self.descriptions[DLCTweakData.DLC_NAME_SPECIAL_EDITION] = {
		content = {
			camp_customizations = {
				{
					item = "special_edition_bomb",
				},
			},
			customizations = {
				{
					item = "american_highlander_jacket_upper",
				},
				{
					item = "american_highlander_jacket_lower",
				},
				{
					item = "russian_highlander_jacket_upper",
				},
				{
					item = "russian_highlander_jacket_lower",
				},
				{
					item = "german_highlander_jacket_upper",
				},
				{
					item = "german_highlander_jacket_lower",
				},
				{
					item = "british_highlander_jacket_upper",
				},
				{
					item = "british_highlander_jacket_lower",
				},
				{
					item = "american_special_edition_001_upper",
				},
				{
					item = "british_special_edition_001_upper",
				},
				{
					item = "german_special_edition_001_upper",
				},
				{
					item = "russian_special_edition_001_upper",
				},
			},
			gold_award = {
				amount = 50,
				item = "special_edition_army_crate",
			},
			melee_weapons = {
				{
					item = "km_dagger",
				},
			},
			vehicle_skins = {
				{
					item = "kubelwagen_special_edition",
					vehicle = "kubelwagen",
				},
			},
			weapon_skins = {
				{
					item = "garand_special_edition",
				},
			},
		},
		name_id = "dlc_special_edition",
	}
	self.descriptions[DLCTweakData.DLC_NAME_OFFICIAL_SOUNDTRACK] = {
		content = {
			melee_weapons = {
				{
					item = "marching_mace",
				},
			},
		},
	}
end

function DLCTweakData:get_name_id(dlc)
	return self.descriptions[dlc] and self.descriptions[dlc].name_id
end

function DLCTweakData:get_eligible_gold_awards()
	local eligible_awards = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.gold_award and managers.dlc:is_dlc_unlocked(dlc_name) then
			table.insert(eligible_awards, {
				amount = dlc_desc.content.gold_award.amount,
				item = dlc_desc.content.gold_award.item,
				name = dlc_name,
			})
		end
	end

	return eligible_awards
end

function DLCTweakData:get_eligible_random_customizations()
	local eligible_awards = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.random_customization and managers.dlc:is_dlc_unlocked(dlc_name) then
			table.insert(eligible_awards, {
				item = dlc_desc.content.random_customization.item,
			})
		end
	end

	return eligible_awards
end

function DLCTweakData:get_unlocked_weapons()
	local weapons = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.weapons and managers.dlc:is_dlc_unlocked(dlc_name) then
			for _, weapon in pairs(dlc_desc.content.weapons) do
				weapons[weapon.item] = true
			end
		end
	end

	return weapons
end

function DLCTweakData:get_locked_weapons()
	local unlocked_weapons = self:get_unlocked_weapons()
	local weapons = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.weapons and managers.dlc:is_dlc_unlocked(dlc_name) then
			for _, weapon in pairs(dlc_desc.content.weapons) do
				if not unlocked_weapons[weapon.item] then
					weapons[weapon.item] = true
				end
			end
		end
	end

	return weapons
end

function DLCTweakData:is_weapon_unlocked(weapon_id)
	local weapons = self:get_unlocked_weapons()
	local unlocked = weapons[weapon_id] and true or false

	return unlocked
end

function DLCTweakData:get_unlocked_weapon_skins()
	local skins = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.weapon_skins and managers.dlc:is_dlc_unlocked(dlc_name) then
			for _, skin in pairs(dlc_desc.content.weapon_skins) do
				skins[skin.item] = true
			end
		end
	end

	return skins
end

function DLCTweakData:get_locked_weapon_skins()
	local unlocked_weapons = self:get_unlocked_weapon_skins()
	local skins = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.weapon_skins and managers.dlc:is_dlc_unlocked(dlc_name) then
			for _, skin in pairs(dlc_desc.content.weapon_skins) do
				if not unlocked_weapons[skin.item] then
					skins[skin.item] = true
				end
			end
		end
	end

	return skins
end

function DLCTweakData:is_weapon_skin_unlocked(skin_id)
	local skins = self:get_unlocked_weapon_skins()
	local unlocked = skins[skin_id] and true or false

	return unlocked
end

function DLCTweakData:get_unlocked_melee_weapons()
	local weapons = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.melee_weapons and managers.dlc:is_dlc_unlocked(dlc_name) then
			for _, weapon in pairs(dlc_desc.content.melee_weapons) do
				weapons[weapon.item] = true
			end
		end
	end

	return weapons
end

function DLCTweakData:get_locked_melee_weapons()
	local unlocked_weapons = self:get_unlocked_melee_weapons()
	local weapons = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.melee_weapons and managers.dlc:is_dlc_unlocked(dlc_name) then
			for _, weapon in pairs(dlc_desc.content.melee_weapons) do
				if not unlocked_weapons[weapon.item] then
					weapons[weapon.item] = true
				end
			end
		end
	end

	return weapons
end

function DLCTweakData:is_melee_weapon_unlocked(weapon_id)
	local melee_weapons = self:get_unlocked_melee_weapons()
	local unlocked = melee_weapons[weapon_id] and true or false

	return unlocked
end

function DLCTweakData:get_unlocked_customizations()
	local customizations = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.customizations and managers.dlc:is_dlc_unlocked(dlc_name) then
			for _, customization in pairs(dlc_desc.content.customizations) do
				customizations[customization.item] = true
			end
		end
	end

	return customizations
end

function DLCTweakData:get_locked_customizations()
	local unlocked_customizations = self:get_unlocked_customizations()
	local customizations = {}

	for dlc_name, dlc_desc in pairs(self.descriptions) do
		if dlc_desc.content.customizations and not managers.dlc:is_dlc_unlocked(dlc_name) then
			for _, customization in pairs(dlc_desc.content.customizations) do
				if not unlocked_customizations[customization] then
					customizations[customization.item] = true
				end
			end
		end
	end

	return customizations
end

function DLCTweakData:is_customization_unlocked(customization_name)
	local customizations = self:get_unlocked_customizations()
	local unlocked = customizations[customization_id] and true or false

	return unlocked
end
