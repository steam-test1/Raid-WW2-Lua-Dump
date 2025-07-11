CopInventory = CopInventory or class(PlayerInventory)

function CopInventory:init(unit)
	CopInventory.super.init(self, unit)

	self._unit = unit
	self._available_selections = {}
	self._equipped_selection = nil
	self._latest_addition = nil
	self._selected_primary = nil
	self._use_data_alias = "npc"
	self._align_places = {}
	self._align_places.right_hand = {
		obj3d_name = Idstring("a_weapon_right_front"),
		on_body = true,
	}
	self._align_places.back = {
		obj3d_name = Idstring("Hips"),
		on_body = true,
	}
	self._listener_id = "CopInventory" .. tostring(unit:key())
end

function CopInventory:_send_equipped_weapon()
	CopInventory.super._send_equipped_weapon(self, PlayerInventory.SEND_WEAPON_TYPE_TEAMAI_COPS)
end

function CopInventory:add_unit_by_name(new_unit_name, equip)
	local new_unit = World:spawn_unit(new_unit_name, Vector3(), Rotation())

	self:_chk_spawn_shield(new_unit)
	new_unit:base():setup({
		alert_AI = true,
		alert_filter = self._unit:brain():SO_access(),
		expend_ammo = false,
		hit_player = true,
		hit_slotmask = managers.slot:get_mask("bullet_impact_targets"),
		ignore_units = {
			self._unit,
			new_unit,
			self._shield_unit,
		},
		user_unit = self._unit,
	})
	self:add_unit(new_unit, equip)
end

function CopInventory:_chk_spawn_shield(weapon_unit)
	if self._shield_unit_name and not alive(self._shield_unit) then
		local align_name = Idstring("a_weapon_left_front")
		local align_obj = self._unit:get_object(align_name)

		self._shield_unit = World:spawn_unit(Idstring(self._shield_unit_name), align_obj:position(), align_obj:rotation())

		self._unit:link(align_name, self._shield_unit, self._shield_unit:orientation_object():name())
		self._shield_unit:set_enabled(false)
	end
end

function CopInventory:add_unit(new_unit, equip)
	CopInventory.super.add_unit(self, new_unit, equip)
end

function CopInventory:get_sync_data(sync_data)
	MPPlayerInventory.get_sync_data(self, sync_data)
end

function CopInventory:get_weapon()
	local equipped_selection = self._available_selections[self._equipped_selection]

	return equipped_selection and equipped_selection.unit
end

function CopInventory:drop_weapon()
	local unit = self:get_weapon()

	if alive(unit) and unit:damage() then
		unit:unlink()
		unit:set_slot(18)
		unit:damage():has_then_run_sequence_simple("enable_body")
		self:_call_listeners("unequip")
		self:remove_selection(self._equipped_selection)
		managers.game_play_central:add_dropped_weapon(unit)
	end
end

function CopInventory:drop_shield()
	if alive(self._shield_unit) and self._shield_unit:damage() then
		self._shield_unit:unlink()
		self._shield_unit:damage():has_then_run_sequence_simple("enable_body")
	end
end

function CopInventory:anim_clbk_weapon_attached(unit, state)
	print("[CopInventory:anim_clbk_weapon_attached]", state)

	if location == true then
		print("linking")

		local weap_unit = self._equipped_selection.unit
		local weap_align_data = selection.use_data.equip
		local align_place = self._align_places[weap_align_data.align_place]
		local parent_unit = self._unit
		local res = parent_unit:link(align_place.obj3d_name, weap_unit, weap_unit:orientation_object():name())
	else
		print("unlinking")
		self._equipped_selection.unit:unlink()
	end
end

function CopInventory:destroy_all_items()
	CopInventory.super.destroy_all_items(self)

	if alive(self._shield_unit) then
		self._shield_unit:set_slot(0)

		self._shield_unit = nil
	end
end

function CopInventory:anim_clbk_equip_enter(unit)
	self:show_equipped_unit()
end

function CopInventory:anim_clbk_hide_weapon(unit)
	self:hide_equipped_unit()
end
