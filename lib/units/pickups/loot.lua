Loot = Loot or class()

function Loot:init(unit)
	self._unit = unit
	self._value = 0
end

function Loot:set_value(value)
	self._value = value
end

function Loot:value()
	return self._value
end

function Loot:on_load_complete()
	local world_id = managers.worldcollection:get_worlddefinition_by_unit_id(self._unit:unit_data().unit_id):world_id()

	managers.lootdrop:register_loot(self._unit, self._loot_size, world_id)
end
