EventsTweakData = EventsTweakData or class()
EventsTweakData.REWARD_TYPE_GOLD = "REWARD_TYPE_GOLD"
EventsTweakData.REWARD_TYPE_OUTLAW = "REWARD_TYPE_OUTLAW"
EventsTweakData.REWARD_TYPE_CARD = "REWARD_TYPE_CARD"
EventsTweakData.REWARD_ICON_SINGLE = "gold_bar_single"
EventsTweakData.REWARD_ICON_FEW = "gold_bar_3"
EventsTweakData.REWARD_ICON_MANY = "gold_bar_box"
EventsTweakData.REWARD_ICON_OUTLAW = "outlaw_raid_hud_item"

function EventsTweakData:init(tweak_data)
	self.login_rewards = {}

	self:_init_active_duty_rewards()
	self:_init_halloween_rewards()

	self.special_events = {}

	self:_init_trick_or_treat_event(tweak_data)
end

function EventsTweakData:_init_active_duty_rewards()
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

function EventsTweakData:_init_halloween_rewards()
	self.login_rewards.halloween = {
		{
			amount = 10,
			generator_id = ChallengeCardsTweakData.PACK_TYPE_HALLOWEEN,
			icon = self.REWARD_ICON_SINGLE,
			reward = self.REWARD_TYPE_CARD,
		},
		{
			amount = 20,
			generator_id = ChallengeCardsTweakData.PACK_TYPE_HALLOWEEN,
			icon = self.REWARD_ICON_SINGLE,
			reward = self.REWARD_TYPE_CARD,
		},
		{
			amount = 40,
			generator_id = ChallengeCardsTweakData.PACK_TYPE_HALLOWEEN,
			icon = self.REWARD_ICON_SINGLE,
			reward = self.REWARD_TYPE_CARD,
		},
	}
end

function EventsTweakData:_init_trick_or_treat_event(tweak_data)
	self.special_events.trick_or_treat = {
		accent_color = "progress_orange",
		camp_continent = "event_halloween",
		card_id = "ra_trick_or_treat",
		challenge_id = "candy_gold_bar",
		date = {
			finish = 1110,
			start = 1023,
		},
		game_logo = tweak_data.gui.icons.raid_hw_logo_small,
		login_rewards = "halloween",
		milestones = {
			40,
			80,
			130,
			190,
		},
		name_id = "hud_trick_or_treat_title",
		package = "packages/halloween_candy",
		upgrades = {
			"temporary_candy_health_regen",
			"temporary_candy_god_mode",
			"temporary_candy_armor_pen",
			"temporary_candy_unlimited_ammo",
			"temporary_candy_sprint_speed",
			"temporary_candy_jump_boost",
			"temporary_candy_attack_damage",
			"temporary_candy_critical_hit_chance",
		},
	}
	self.special_events.trick_or_treat.bonus_effects = {
		refill_ammo = "hud_trick_or_treat_buff_ammo",
		refill_down = "hud_trick_or_treat_buff_down",
		refill_health = "hud_trick_or_treat_buff_health",
		refill_warcry = "hud_trick_or_treat_buff_warcry",
		undead = "hud_trick_or_treat_buff_undead",
	}
	self.special_events.trick_or_treat.malus_effects = {
		{
			desc_id = "effect_set_bleedout_timer",
			desc_params = {
				EFFECT_VALUE_1 = "15",
			},
			name = BuffEffectManager.EFFECT_SET_BLEEDOUT_TIMER,
			value = 15,
		},
		{
			desc_id = "effect_player_slower_reload",
			desc_params = {
				EFFECT_VALUE_1 = "20%",
			},
			name = BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED,
			value = 0.8,
		},
		{
			desc_id = "effect_health_drain_per_minute",
			desc_params = {
				EFFECT_VALUE_1 = "30%",
			},
			name = BuffEffectManager.EFFECT_PLAYER_HEALTH_REGEN,
			value = -0.005,
		},
		{
			desc_id = BuffEffectManager.EFFECT_ENEMIES_MELEE_DAMAGE_INCREASE,
			desc_params = {
				EFFECT_VALUE_1 = "400%",
			},
			name = BuffEffectManager.EFFECT_ENEMIES_MELEE_DAMAGE_INCREASE,
			value = 4,
		},
		{
			blocked_by = BuffEffectManager.EFFECT_ENEMY_HEALTH,
			desc_id = "effect_enemies_deal_increased_damage",
			desc_params = {
				EFFECT_VALUE_1 = "15%",
			},
			name = BuffEffectManager.EFFECT_ENEMY_DOES_DAMAGE,
			stage = 3,
			value = 1.15,
		},
		{
			blocked_by = BuffEffectManager.EFFECT_ENEMY_DOES_DAMAGE,
			desc_id = "effect_enemies_health_increased",
			desc_params = {
				EFFECT_VALUE_1 = "20%",
			},
			name = BuffEffectManager.EFFECT_ENEMY_HEALTH,
			stage = 3,
			value = 1.2,
		},
		{
			chance = 50,
			desc_id = "effect_warcries_disabled",
			name = BuffEffectManager.EFFECT_WARCRIES_DISABLED,
			stage = 4,
			value = true,
		},
		{
			blocked_by = BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE,
			chance = 30,
			desc_id = "effect_enemies_vulnerable_only_to_headshots",
			name = BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT,
			stage = 4,
			value = true,
		},
		{
			blocked_by = BuffEffectManager.EFFECT_ENEMIES_DIE_ONLY_ON_HEADSHOT,
			chance = 30,
			desc_id = "effect_headshot_doesnt_do_damage",
			name = BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE,
			stage = 4,
			value = true,
		},
		{
			desc_id = "effect_shooting_your_primary_weapon_consumes_both_ammos",
			name = BuffEffectManager.EFFECT_SHOOTING_PRIMARY_WEAPON_CONSUMES_BOTH_AMMOS,
			stage = 5,
			value = true,
		},
		{
			chance = 5,
			desc_id = "effect_player_can_only_walk_backwards_or_sideways",
			name = BuffEffectManager.EFFECT_PLAYER_CAN_MOVE_ONLY_BACK_AND_SIDE,
			stage = 5,
			value = true,
		},
	}
	self.special_events.oops = {
		date = {
			finish = 715,
			start = 620,
		},
		game_logo = tweak_data.gui.icons.raid_oops_logo_small,
	}
end
