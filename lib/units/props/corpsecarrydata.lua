CorpseCarryData = CorpseCarryData or class(CarryData)

function CorpseCarryData:destroy()
	self:_clear_spawn_gear()
	CorpseCarryData.super.destroy(self)
end

function CorpseCarryData:load(data)
	CorpseCarryData.super.load(self, data)

	self._tweak_table = tweak_data.carry[self:carry_id()].character_id
	self._char_tweak = tweak_data.character[self._tweak_table]

	self:_init_spawn_gear()
	self:set_gear_dead()
end

CorpseCarryData._init_spawn_gear = CopBase._init_spawn_gear
CorpseCarryData._clear_spawn_gear = CopBase._clear_spawn_gear
CorpseCarryData.set_spawn_gear_visibility_state = CopBase.set_spawn_gear_visibility_state
CorpseCarryData.set_gear_dead = CopBase.set_gear_dead

function CorpseCarryData:on_pickup()
	if self._dismembered_parts then
		managers.player:set_carry_temporary_data(self:carry_id(), self._dismembered_parts)
	end

	local corpse_data = managers.enemy:get_corpse_unit_data_from_key(self._unit:key())

	if corpse_data then
		local u_id = corpse_data.u_id

		managers.enemy:remove_corpse_by_id(u_id)
		managers.network:session():send_to_peers_synched("remove_corpse_by_id", u_id, true, 1)
	end

	self:_clear_spawn_gear()
end

function CorpseCarryData:on_thrown()
	Application:info("[CorpseCarryData:on_thrown] Threw corpse ID", self:carry_id())
	self._unit:damage():has_then_run_sequence_simple("set_bodybag_class")

	self._dismembered_parts = self._dismembered_parts or managers.player:carry_temporary_data(self:carry_id())

	for _, dismember_part in ipairs(self._dismembered_parts or {}) do
		if self:_dismember(dismember_part .. "_no_blood", dismember_part) then
			self:_dismember(dismember_part)
		end
	end

	managers.player:clear_carry_temporary_data(self:carry_id())

	self._tweak_table = tweak_data.carry[self:carry_id()].character_id
	self._char_tweak = tweak_data.character[self._tweak_table]

	self:_init_spawn_gear()
	self:set_gear_dead()
	self:_switch_to_ragdoll()
end

local blank_idstr = Idstring("")
local rootfollow_idstr = Idstring("root_follow")

function CorpseCarryData:_switch_to_ragdoll()
	if not self._unit:damage() or not self._unit:damage():has_sequence("switch_to_ragdoll") then
		return
	end

	self._unit:set_driving("orientation_object")
	self._unit:set_animations_enabled(false)
	self._unit:damage():run_sequence_simple("switch_to_ragdoll")

	self._root_act_tags = {}

	local hips_body = self._unit:body("rag_Hips")
	local tag = hips_body:activate_tag()

	if tag == blank_idstr then
		tag = rootfollow_idstr

		hips_body:set_activate_tag(tag)
	end

	tag = hips_body:deactivate_tag()

	if tag == blank_idstr then
		tag = rootfollow_idstr

		hips_body:set_deactivate_tag(tag)
	end
end

function CorpseCarryData:_dismember(part_name, decal_name)
	if not self._unit:damage():has_sequence(part_name) then
		return false
	end

	self._unit:damage():run_sequence_simple(part_name)

	local decal_data = tweak_data.character.dismemberment_data.blood_decal_data[decal_name or part_name]

	if decal_data then
		local materials = self._unit:materials()

		for i, material in ipairs(materials) do
			material:set_variable(Idstring("gradient_uv_offset"), Vector3(decal_data[1], decal_data[2], 0))
			material:set_variable(Idstring("gradient_power"), decal_data[3])
		end
	end
end
