UpgradesManager = UpgradesManager or class()
UpgradesManager.AQUIRE_STRINGS = {
	"Default",
	"SkillTree",
	"SpecializationTree",
	"LevelTree",
	"DLC",
	"WeaponSkill",
	"MeleeWeaponDrop",
}
UpgradesManager.CATEGORY_ARMOR = "armor"
UpgradesManager.CATEGORY_FEATURE = "feature"
UpgradesManager.CATEGORY_WEAPON = "weapon"
UpgradesManager.CATEGORY_GRENADE = "grenade"
UpgradesManager.CATEGORY_MELEE_WEAPON = "melee_weapon"
UpgradesManager.CATEGORY_EQUIPMENT = "equipment"
UpgradesManager.CATEGORY_EQUIPMENT_UPGRADE = "equipment_upgrade"
UpgradesManager.CATEGORY_TEMPORARY = "temporary"
UpgradesManager.CATEGORY_COOLDOWN = "cooldown"
UpgradesManager.CATEGORY_TEAM = "team"

function UpgradesManager:init()
	self:_setup()
	self:on_tweak_data_reloaded()
end

function UpgradesManager:on_tweak_data_reloaded()
	self._tweak_data = tweak_data.upgrades
end

function UpgradesManager:_setup()
	if not Global.upgrades_manager then
		Global.upgrades_manager = {
			aquired = {},
		}
	end

	self._global = Global.upgrades_manager
end

function UpgradesManager:aquired(id, identifier)
	if identifier then
		local identify_key = Idstring(identifier):key()

		return not not self._global.aquired[id] and not not self._global.aquired[id][identify_key]
	else
		local count = 0

		for key, aquired in pairs(self._global.aquired[id] or {}) do
			if aquired then
				count = count + 1
			end
		end

		return count > 0
	end
end

function UpgradesManager:aquire_default(id, identifier)
	if not self._tweak_data.definitions[id] then
		Application:error("Tried to aquire an upgrade that doesn't exist: " .. (id or "nil") .. "")

		return
	end

	local upgrade = self._tweak_data.definitions[id]

	if upgrade.dlc and not managers.dlc:is_dlc_unlocked(upgrade.dlc) then
		Application:error("Tried to aquire an upgrade locked to a dlc you do not have: " .. id .. " DLC: ", upgrade.dlc)

		return
	end

	if not identifier then
		debug_pause(identifier, "[UpgradesManager:aquire_default] No identifier for upgrade aquire", "id", id)

		identifier = UpgradesManager.AQUIRE_STRINGS[1]
	end

	local identify_key = Idstring(identifier):key()

	if self._global.aquired[id] and self._global.aquired[id][identify_key] then
		Application:error("[UpgradesManager:aquire_default] Tried to aquire an upgrade that has already been aquired: " .. id, "identifier", identifier, "id_key", identify_key)
		Application:stack_dump()

		return
	end

	self._global.aquired[id] = self._global.aquired[id] or {}
	self._global.aquired[id][identify_key] = identifier

	local upgrade = self._tweak_data.definitions[id]

	self:_aquire_upgrade(upgrade, id, true)
end

function UpgradesManager:enable_weapon(id, identifier)
	if not self._tweak_data.definitions[id] then
		Application:error("Tried to aquire an upgrade that doesn't exist: " .. (id or "nil") .. "")

		return
	end

	local upgrade = self._tweak_data.definitions[id]

	if upgrade.dlc and not managers.dlc:is_dlc_unlocked(upgrade.dlc) then
		Application:error("Tried to aquire an upgrade locked to a dlc you do not have: " .. id .. " DLC: ", upgrade.dlc)

		return
	end

	if not identifier then
		debug_pause(identifier, "[UpgradesManager:aquire_default] No identifier for upgrade aquire", "id", id)

		identifier = UpgradesManager.AQUIRE_STRINGS[1]
	end

	local identify_key = Idstring(identifier):key()

	if self._global.aquired[id] and self._global.aquired[id][identify_key] then
		Application:error("[UpgradesManager:enable_weapon] Tried to aquire an upgrade that has already been aquired: " .. id, "identifier", identifier, "id_key", identify_key)
		Application:stack_dump()

		return
	end

	self._global.aquired[id] = self._global.aquired[id] or {}
	self._global.aquired[id][identify_key] = identifier

	managers.player:aquire_weapon(upgrade, id, UpgradesManager.AQUIRE_STRINGS[1])
end

function UpgradesManager:aquire(id, loading, identifier)
	if not self._tweak_data.definitions[id] then
		Application:error("Tried to aquire an upgrade that doesn't exist: " .. tostring(id))

		return
	end

	local upgrade = self._tweak_data.definitions[id]

	if upgrade.dlc and not managers.dlc:is_dlc_unlocked(upgrade.dlc) then
		Application:error("Tried to aquire an upgrade locked to a dlc you do not have: " .. id .. " DLC: ", upgrade.dlc)

		return
	end

	if not identifier then
		debug_pause(identifier, "[UpgradesManager:aquire] No identifier for upgrade aquire", "id", id, "loading", loading)

		identifier = UpgradesManager.AQUIRE_STRINGS[1]
	end

	local identify_key = Idstring(identifier):key()

	if self._global.aquired[id] and self._global.aquired[id][identify_key] then
		Application:error("[UpgradesManager:aquire] Tried to aquire an upgrade that has already been aquired: " .. id, "identifier", identifier, "id_key", identify_key)
		Application:stack_dump()

		return
	end

	self._global.aquired[id] = self._global.aquired[id] or {}
	self._global.aquired[id][identify_key] = identifier

	self:_aquire_upgrade(upgrade, id, loading)
end

function UpgradesManager:unaquire(id, identifier)
	if not self._tweak_data.definitions[id] then
		Application:error("Tried to unaquire an upgrade that doesn't exist: " .. (id or "nil") .. "")

		return
	end

	if not identifier then
		debug_pause(identifier, "[UpgradesManager:unaquire] No identifier for upgrade aquire", "id", id)

		identifier = UpgradesManager.AQUIRE_STRINGS[1]
	end

	local identify_key = Idstring(identifier):key()

	if not self._global.aquired[id] or not self._global.aquired[id][identify_key] then
		Application:error("Tried to unaquire an upgrade that hasn't been aquired: " .. id, "identifier", identifier)

		return
	end

	self._global.aquired[id][identify_key] = nil

	local count = 0

	for key, aquired in pairs(self._global.aquired[id]) do
		count = count + 1
	end

	if count == 0 then
		self._global.aquired[id] = nil

		local upgrade = self._tweak_data.definitions[id]

		self:_unaquire_upgrade(upgrade, id)
	end
end

function UpgradesManager:_aquire_upgrade(upgrade, id, loading)
	if upgrade.category == UpgradesManager.CATEGORY_WEAPON then
		self:_aquire_weapon(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_FEATURE then
		self:_aquire_feature(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_EQUIPMENT then
		self:_aquire_equipment(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_EQUIPMENT_UPGRADE then
		self:_aquire_equipment_upgrade(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_TEMPORARY then
		self:_aquire_temporary(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_COOLDOWN then
		self:_aquire_cooldown(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_TEAM then
		self:_aquire_team(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_ARMOR then
		self:_aquire_armor(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_MELEE_WEAPON then
		self:_aquire_melee_weapon(upgrade, id, loading)
	elseif upgrade.category == UpgradesManager.CATEGORY_GRENADE then
		self:_aquire_grenade(upgrade, id, loading)
	end
end

function UpgradesManager:_unaquire_upgrade(upgrade, id)
	if upgrade.category == UpgradesManager.CATEGORY_WEAPON then
		self:_unaquire_weapon(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_FEATURE then
		self:_unaquire_feature(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_EQUIPMENT then
		self:_unaquire_equipment(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_EQUIPMENT_UPGRADE then
		self:_unaquire_equipment_upgrade(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_TEMPORARY then
		self:_unaquire_temporary(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_COOLDOWN then
		self:_unaquire_cooldown(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_TEAM then
		self:_unaquire_team(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_ARMOR then
		self:_unaquire_armor(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_MELEE_WEAPON then
		self:_unaquire_melee_weapon(upgrade, id)
	elseif upgrade.category == UpgradesManager.CATEGORY_GRENADE then
		self:_unaquire_grenade(upgrade, id)
	end
end

function UpgradesManager:_aquire_weapon(upgrade, id, loading)
	managers.player:aquire_weapon(upgrade, id)
	managers.blackmarket:on_aquired_weapon_platform(upgrade, id, loading)
end

function UpgradesManager:_unaquire_weapon(upgrade, id)
	managers.player:unaquire_weapon(upgrade, id)
	managers.blackmarket:on_unaquired_weapon_platform(upgrade, id)
end

function UpgradesManager:_aquire_melee_weapon(upgrade, id, loading)
	managers.player:aquire_melee_weapon(upgrade, id)
	managers.blackmarket:on_aquired_melee_weapon(upgrade, id, loading)
end

function UpgradesManager:_unaquire_melee_weapon(upgrade, id)
	managers.player:unaquire_melee_weapon(upgrade, id)
	managers.blackmarket:on_unaquired_melee_weapon(upgrade, id)
end

function UpgradesManager:_aquire_grenade(upgrade, id, loading)
	managers.player:aquire_grenade(upgrade, id)
	managers.blackmarket:on_aquired_grenade(upgrade, id, loading)
end

function UpgradesManager:_unaquire_grenade(upgrade, id)
	managers.player:unaquire_grenade(upgrade, id)
	managers.blackmarket:on_unaquired_grenade(upgrade, id)
end

function UpgradesManager:_aquire_feature(feature)
	if feature.incremental then
		managers.player:aquire_incremental_upgrade(feature.upgrade)
	else
		managers.player:aquire_upgrade(feature.upgrade)
	end
end

function UpgradesManager:_unaquire_feature(feature)
	if feature.incremental then
		managers.player:unaquire_incremental_upgrade(feature.upgrade)
	else
		managers.player:unaquire_upgrade(feature.upgrade)
	end
end

function UpgradesManager:_aquire_equipment(equipment, id, loading)
	managers.player:aquire_equipment(equipment, id, loading)
end

function UpgradesManager:_unaquire_equipment(equipment, id)
	managers.player:unaquire_equipment(equipment, id)
end

function UpgradesManager:_aquire_equipment_upgrade(equipment_upgrade)
	if equipment_upgrade.incremental then
		managers.player:aquire_incremental_upgrade(equipment_upgrade.upgrade)
	else
		managers.player:aquire_upgrade(equipment_upgrade.upgrade)
	end
end

function UpgradesManager:_unaquire_equipment_upgrade(equipment_upgrade)
	if equipment_upgrade.incremental then
		managers.player:unaquire_incremental_upgrade(equipment_upgrade.upgrade)
	else
		managers.player:unaquire_upgrade(equipment_upgrade.upgrade)
	end
end

function UpgradesManager:_aquire_temporary(temporary, id)
	if temporary.incremental then
		managers.player:aquire_incremental_upgrade(temporary.upgrade)
	else
		managers.player:aquire_upgrade(temporary.upgrade, id)
	end
end

function UpgradesManager:_unaquire_temporary(temporary, id)
	if temporary.incremental then
		managers.player:unaquire_incremental_upgrade(temporary.upgrade)
	else
		managers.player:unaquire_upgrade(temporary.upgrade)
	end
end

function UpgradesManager:_aquire_cooldown(cooldown, id)
	managers.player:aquire_cooldown_upgrade(cooldown.upgrade, id)
end

function UpgradesManager:_unaquire_cooldown(cooldown, id)
	managers.player:unaquire_cooldown_upgrade(cooldown.upgrade)
end

function UpgradesManager:_aquire_team(team, id)
	managers.player:aquire_team_upgrade(team.upgrade, id)
end

function UpgradesManager:_unaquire_team(upgrade, id)
	managers.player:unaquire_team_upgrade(upgrade, id)
end

function UpgradesManager:_aquire_armor(upgrade, id, loading)
	managers.blackmarket:on_aquired_armor(upgrade, id, loading)
end

function UpgradesManager:_unaquire_armor(upgrade, id)
	managers.blackmarket:on_unaquired_armor(upgrade, id)
end

function UpgradesManager:upgrade_exists(upgrade_id)
	return not not self._tweak_data.definitions[upgrade_id]
end

function UpgradesManager:get_category(upgrade_id)
	local upgrade = self._tweak_data.definitions[upgrade_id]

	return upgrade.category
end

function UpgradesManager:get_upgrade_upgrade(upgrade_id)
	local upgrade = self._tweak_data.definitions[upgrade_id]

	return upgrade.upgrade
end

function UpgradesManager:aquired_by_category(category)
	local t = {}

	for name, _ in pairs(self._global.aquired) do
		if self._tweak_data.definitions[name].category == category and self:aquired(name) then
			table.insert(t, name)
		end
	end

	return t
end

function UpgradesManager:aquired_features()
	return self:aquired_by_category(UpgradesManager.CATEGORY_FEATURE)
end

function UpgradesManager:aquired_armors()
	return self:aquired_by_category(UpgradesManager.CATEGORY_ARMOR)
end

function UpgradesManager:aquired_weapons()
	return self:aquired_by_category(UpgradesManager.CATEGORY_WEAPON)
end

function UpgradesManager:aquired_grenades()
	return self:aquired_by_category(UpgradesManager.CATEGORY_GRENADE)
end

function UpgradesManager:aquired_melee_weapons()
	return self:aquired_by_category(UpgradesManager.CATEGORY_MELEE_WEAPON)
end

function UpgradesManager:aquired_equipments()
	return self:aquired_by_category(UpgradesManager.CATEGORY_EQUIPMENT)
end

function UpgradesManager:aquired_equipment_upgrades()
	return self:aquired_by_category(UpgradesManager.CATEGORY_EQUIPMENT_UPGRADE)
end

function UpgradesManager:aquired_temporary()
	return self:aquired_by_category(UpgradesManager.CATEGORY_TEMPORARY)
end

function UpgradesManager:aquired_cooldowns()
	return self:aquired_by_category(UpgradesManager.CATEGORY_COOLDOWN)
end

function UpgradesManager:aquired_teams()
	return self:aquired_by_category(UpgradesManager.CATEGORY_TEAM)
end

function UpgradesManager:all_weapon_upgrades()
	for id, data in pairs(self._tweak_data.definitions) do
		if data.category == UpgradesManager.CATEGORY_WEAPON then
			print(id)
		end
	end
end

function UpgradesManager:weapon_upgrade_by_weapon_id(weapon_id)
	for id, data in pairs(self._tweak_data.definitions) do
		if data.category == UpgradesManager.CATEGORY_WEAPON and data.weapon_id == weapon_id then
			return data
		end
	end
end

function UpgradesManager:weapon_upgrade_by_factory_id(factory_id)
	for id, data in pairs(self._tweak_data.definitions) do
		if data.category == UpgradesManager.CATEGORY_WEAPON and data.factory_id == factory_id then
			return data
		end
	end
end

function UpgradesManager:save(data)
	return
end

function UpgradesManager:load(data)
	self:reset()
end

function UpgradesManager:reset()
	Application:debug("[UpgradesManager:reset] resetting and going to _setup()")

	Global.upgrades_manager = nil

	self:_setup()
end
