WarcryTweakData = WarcryTweakData or class()

function WarcryTweakData:init(tweak_data)
	self.dummy = {}
	self.dummy.hud_icon = "player_panel_warcry_sharpshooter"

	self:_init_sharpshooter()
	self:_init_silver_bullet()
	self:_init_berserk()
	self:_init_sentry()
	self:_init_ghost()
	self:_init_pain_train()
	self:_init_clustertruck()
end

function WarcryTweakData:_init_sharpshooter()
	self.sharpshooter = {
		base_duration = 10,
		base_kill_fill_amount = 0.06666666666666667,
		desc_id = "warcry_sharpshooter_desc",
		headshot_multiplier = 0.5,
		health_boost_sound = "recon_warcry_enemy_hit",
		hud_icon = "player_panel_warcry_sharpshooter",
		lerp_duration = 0.75,
		name_id = "warcry_sharpshooter_name",
		overlay_pulse_ampl = 0.1,
		overlay_pulse_freq = 0.5,
		sound_switch = "warcry_echo",
		buffs = {
			{
				"warcry_player_aim_assist",
				"warcry_player_aim_assist_aim_at_head",
				"warcry_player_aim_assist_radius_1",
				"warcry_player_nullify_spread",
			},
			{
				"warcry_player_health_regen_amount_1",
				"warcry_player_health_regen_on_kill",
			},
			{
				"warcry_player_health_regen_amount_2",
			},
			{
				"warcry_player_health_regen_amount_3",
				"warcry_player_sniper_ricochet",
			},
		},
		ids_effect_name = Idstring("warcry_sharpshooter"),
	}
end

function WarcryTweakData:_init_silver_bullet()
	self.silver_bullet = {
		activation_callout = "warcry_sharpshooter",
		base_duration = 7.5,
		base_kill_fill_amount = 0.08333333333333333,
		desaturation = 0.5,
		desc_id = "warcry_silver_bullet_desc",
		duration_bonus_diminish = 0.65,
		fill_drain_multiplier = 0.0025,
		grain_noise_strength = 1,
		hud_icon = "player_panel_warcry_silver_bullet",
		lerp_duration = 0.75,
		name_id = "skill_warcry_silver_bullet_name",
		sound_switch = "warcry_heartbeat",
		tint_fov = 0.2,
		buffs = {
			{
				"warcry_player_silver_bullet_tint_distance_1",
				"warcry_player_shoot_through_walls",
				"warcry_player_shoot_through_enemies_2",
				"warcry_player_shoot_through_shields",
				"warcry_player_nullify_spread",
			},
			{
				"warcry_player_killshot_duration_bonus",
			},
			{
				"warcry_player_silver_bullet_tint_distance_2",
				"warcry_player_silver_bullet_drain_reduction",
			},
			{
				"warcry_player_penetrate_damage_multiplier",
			},
		},
		ids_effect_name = Idstring("warcry_ghost"),
	}
end

function WarcryTweakData:_init_berserk()
	self.berserk = {
		base_duration = 10,
		base_kill_fill_amount = 0.06666666666666667,
		desc_id = "warcry_berserk_desc",
		dismemberment_multiplier = 0.3,
		distorts_lense = true,
		hud_icon = "player_panel_warcry_berserk",
		lens_distortion_value = 0.92,
		lerp_duration = 0.75,
		name_id = "warcry_berserk_name",
		overlay_pulse_ampl = 0.1,
		overlay_pulse_freq = 1.3,
		sound_switch = "warcry_flame",
		buffs = {
			{
				"warcry_player_ammo_consumption_1",
				"warcry_player_kill_heal_bonus_1",
			},
			{
				"warcry_player_kill_heal_bonus_2",
				"warcry_turret_overheat_multiplier",
			},
			{
				"warcry_player_ammo_consumption_2",
				"warcry_player_kill_heal_bonus_3",
			},
			{
				"warcry_player_ammo_consumption_3",
				"warcry_player_refill_clip",
			},
		},
		ids_effect_name = Idstring("warcry_berserk"),
	}
end

function WarcryTweakData:_init_sentry()
	self.sentry = {
		activation_callout = "warcry_berserk",
		base_duration = 6,
		base_kill_fill_amount = 0.09090909090909091,
		desc_id = "warcry_sentry_desc",
		distorts_lense = true,
		hud_icon = "player_panel_warcry_sentry",
		lens_distortion_value = 1.02,
		lerp_duration = 0.75,
		name_id = "skill_warcry_sentry_name",
		overlay_pulse_ampl = 0.1,
		overlay_pulse_freq = 1.3,
		sound_switch = "warcry_spiral",
		buffs = {
			{
				"warcry_player_shooting_movement_speed_reduction",
				"warcry_player_nullify_spread",
				"warcry_player_nullify_recoil",
				"warcry_temporary_sentry_shooting",
			},
			{
				"warcry_player_magazine_size_multiplier",
				"warcry_player_shooting_damage_reduction_1",
			},
			{
				"warcry_player_shooting_drain_reduction",
				"warcry_player_shooting_damage_reduction_2",
			},
			{
				"warcry_player_shoot_through_enemies_1",
				"warcry_player_dismember_always",
			},
		},
		ids_effect_name = Idstring("warcry_berserk"),
	}
end

function WarcryTweakData:_init_ghost()
	self.ghost = {
		base_duration = 10,
		base_kill_fill_amount = 0.06666666666666667,
		desaturation = 0.8,
		desc_id = "warcry_ghost_desc",
		grain_noise_strength = 10,
		hud_icon = "player_panel_warcry_invisibility",
		lerp_duration = 0.75,
		melee_multiplier = 0.3,
		name_id = "warcry_ghost_name",
		sound_switch = "warcry_heartbeat",
		tint_distance = 3200,
		buffs = {
			{
				"warcry_player_dodge_1",
			},
			{
				"warcry_player_dodge_2",
			},
			{
				"warcry_player_dodge_3",
			},
			{
				"warcry_player_dodge_4",
			},
		},
		ids_effect_name = Idstring("warcry_ghost"),
	}
end

function WarcryTweakData:_init_pain_train()
	self.pain_train = {
		activation_threshold = 0.5,
		base_duration = 4.6,
		base_kill_fill_amount = 0.08333333333333333,
		desc_id = "warcry_pain_train_desc",
		distorts_lense = true,
		hud_icon = "player_panel_warcry_pain_train",
		interrupt_penalty_percentage = 0.1,
		knockdown_distance = 170,
		knockdown_fill_penalty = 0.15,
		lens_distortion_value = 1.02,
		lerp_duration = 0.75,
		name_id = "skill_warcry_pain_train_name",
		buffs = {
			{
				"warcry_player_charge_damage_reduction_1",
				"warcry_player_charge_knockdown_fov_1",
			},
			{
				"warcry_player_charge_knockdown_fov_2",
				"warcry_player_charge_damage_reduction_2",
			},
			{},
			{
				"warcry_player_charge_damage_reduction_3",
				"warcry_player_charge_knockdown_flamer",
			},
		},
	}
end

function WarcryTweakData:_init_clustertruck()
	self.clustertruck = {
		base_duration = 8,
		base_kill_fill_amount = 0.06666666666666667,
		desc_id = "warcry_clustertruck_desc",
		fire_intensity = 2.6,
		fire_opacity = 0.5,
		hud_icon = "player_panel_warcry_cluster_truck",
		lerp_duration = 0.75,
		name_id = "warcry_clustertruck_name",
		sound_switch = "warcry_spiral",
		buffs = {
			{
				"warcry_player_grenade_refill_amounts_1",
				"warcry_player_grenade_clusters_1",
				"warcry_player_grenade_cluster_damage_1",
				"warcry_player_grenade_cluster_range_1",
			},
			{
				"warcry_player_grenade_refill_amounts_2",
				"warcry_player_grenade_cluster_damage_2",
				"warcry_player_grenade_cluster_range_2",
			},
			{
				"warcry_player_grenade_clusters_2",
				"warcry_player_grenade_cluster_damage_3",
				"warcry_player_grenade_cluster_range_3",
			},
			{
				"warcry_player_grenade_clusters_3",
				"warcry_player_grenade_airburst",
			},
		},
		ids_effect_name = Idstring("warcry_clustertruck"),
	}
end
