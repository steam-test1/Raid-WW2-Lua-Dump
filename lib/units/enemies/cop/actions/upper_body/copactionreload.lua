CopActionReload = CopActionReload or class()
CopActionReload.MODIFIER_NAME = Idstring("action_upper_body_enemy")

function CopActionReload:init(action_desc, common_data)
	self._unit = common_data.unit
	self._ext_movement = common_data.ext_movement
	self._ext_anim = common_data.ext_anim
	self._ext_inventory = common_data.ext_inventory
	self._body_part = action_desc.body_part
	self._common_data = common_data
	self._machine = common_data.machine

	local reload_t

	for _, other_action in ipairs(common_data.active_actions) do
		if other_action and other_action.reload_t then
			reload_t = other_action.reload_t

			break
		end
	end

	if not reload_t and not self:_play_reload() then
		cat_print("george", "[CopActionReload:init] failed in", self._machine:segment_state(Idstring("base")))

		return false
	end

	if reload_t then
		self._reload_t = reload_t
	else
		local reload_delay = 3

		self._reload_t = TimerManager:game():time() + reload_delay
	end

	self._weapon_unit = self._ext_inventory:equipped_unit()
	self._body_part = action_desc.body_part
	self._modifier = self._machine:get_modifier(self.MODIFIER_NAME)
	self._blocks = {
		light_hurt = -1,
	}

	if self._attention then
		self._modifier_on = true

		local target_pos

		if self._attention.handler then
			target_pos = self._attention.handler:get_attention_m_pos()
		elseif self._attention.unit then
			target_pos = self._attention.unit:movement():m_head_pos()
		else
			target_pos = self._attention.pos
		end

		local shoot_from_pos = common_data.pos + math.UP * 160
		local target_vec = target_pos - shoot_from_pos

		self._machine:force_modifier(self.MODIFIER_NAME)
		self._modifier:set_target_y(target_vec)
	else
		self._modifier_on = nil
	end

	CopActionAct._create_blocks_table(self, action_desc.blocks)

	return true
end

function CopActionReload:type()
	return "reload"
end

function CopActionReload:update(t)
	if self._modifier_on then
		local target_pos

		if self._attention.handler then
			target_pos = self._attention.handler:get_attention_m_pos()
		elseif self._attention.unit then
			target_pos = self._attention.unit:movement():m_head_pos()
		else
			target_pos = self._attention.pos
		end

		local shoot_from_pos = math.UP * 130

		mvector3.add(shoot_from_pos, self._common_data.pos)

		local target_vec = target_pos - shoot_from_pos

		self._modifier:set_target_y(target_vec)
	end

	if t > self._reload_t then
		self._weapon_unit:base():on_reload()

		self._expired = true
	end

	if self._ext_anim.base_need_upd then
		self._ext_movement:upd_m_head_pos()
	end
end

function CopActionReload:_play_reload()
	local redir_res = self._ext_movement:play_redirect("reload")

	if not redir_res then
		return
	end

	managers.groupai:state():chk_say_enemy_chatter(self._unit, self._unit:position(), "reload")

	return redir_res
end

function CopActionReload:expired()
	return self._expired
end

function CopActionReload:on_attention(attention)
	if attention then
		self._modifier_on = true

		self._machine:force_modifier(self.MODIFIER_NAME)
	else
		self._modifier_on = nil

		self._machine:allow_modifier(self.MODIFIER_NAME)
	end

	self._attention = attention
end

function CopActionReload:on_exit()
	if self._modifier_on then
		self._modifier_on = nil

		self._machine:allow_modifier(self.MODIFIER_NAME)
	end
end

function CopActionReload:chk_block(action_type, t)
	return CopActionAct.chk_block(self, action_type, t)
end

function CopActionReload:need_upd()
	return true
end
