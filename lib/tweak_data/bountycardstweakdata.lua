function ChallengeCardsTweakData:_init_bounty_data(tweak_data)
	self.bounty_data = {}
	self.bounty_data.default_names = {
		"card_bounty_name_1_id",
		"card_bounty_name_2_id",
		"card_bounty_name_3_id",
		"card_bounty_name_4_id",
	}
	self.bounty_data.effects_library = {
		[BuffEffectManager.EFFECT_MODIFY_BLEEDOUT_TIMER] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_bleedout_timer_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_bleedout_timer_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_SET_BLEEDOUT_TIMER,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_029",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.4,
						text = "10",
						value = -10,
					},
				},
				{
					{
						difficulty = 0.6,
						text = "15",
						value = -15,
					},
				},
				{
					{
						difficulty = 0.8,
						text = "20",
						value = -20,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "3",
						value = 3,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "5",
						value = 5,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "10",
						value = 10,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_SET_BLEEDOUT_TIMER] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_set_bleedout_timer",
			},
			forbids = {
				BuffEffectManager.EFFECT_MODIFY_BLEEDOUT_TIMER,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						text = "3",
						value = 3,
					},
				},
				{
					{
						difficulty = 0.75,
						text = "10",
						value = 10,
					},
				},
				{
					{
						difficulty = 0.6,
						text = "15",
						value = 15,
					},
				},
				{
					{
						difficulty = 0.5,
						text = "20",
						value = 20,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_MODIFY_LIVES] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_modify_lives_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_modify_lives_positive",
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_035",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_036",
					"card_bounty_name_submission_037",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						text = "3",
						value = -3,
					},
				},
				{
					{
						difficulty = 0.8,
						text = "2",
						value = -2,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "1",
						value = 1,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMY_HEALTH] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_enemy_health_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_enemy_health_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_005",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_018",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = 0.75,
						text = "50%",
						value = 1.5,
					},
				},
				{
					{
						difficulty = 1,
						text = "75%",
						value = 1.75,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "25%",
						value = 0.75,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_enemy_damage_resistance_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_enemy_damage_resistance_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMY_HEALTH,
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE,
				BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.4,
						text = "30%",
						value = 0.7,
					},
				},
				{
					{
						difficulty = 1,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 1.5,
						text = "70%",
						value = 0.3,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.2,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.4,
						text = "20%",
						value = 1.2,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMY_DOES_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_enemies_damage_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_enemies_damage_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_PLAYER_HEALTH,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_003",
					"card_bounty_name_submission_013",
					"card_bounty_name_submission_026",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_004",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = 0.75,
						text = "50%",
						value = 1.5,
					},
				},
				{
					{
						difficulty = 1,
						text = "75%",
						value = 1.75,
					},
				},
				{
					{
						difficulty = 1.5,
						text = "100%",
						value = 2,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "5%",
						value = 0.95,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "10%",
						value = 0.9,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_CHANCE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_loot_drop_chance_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_loot_drop_chance_positive",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.25,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = 0.4,
						text = "20%",
						value = 0.8,
					},
				},
				{
					{
						difficulty = 0.6,
						text = "30%",
						value = 0.7,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.3,
						text = "30%",
						value = 1.3,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_loot_drop_effect_increased",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.05,
						text = "5%",
						value = 1.05,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "25%",
						value = 1.25,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_PRIMARY_AMMO_CAPACITY] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_primary_ammo_capacity_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_primary_ammo_capacity_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_021",
					"card_bounty_name_submission_022",
					"card_bounty_name_submission_028",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_030",
					"card_bounty_name_submission_034",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.7,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						added_forbids = {
							BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE,
						},
						difficulty = 0.85,
						text = "0%",
						value = 0,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.075,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.125,
						text = "40%",
						value = 1.4,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_SECONDARY_AMMO_CAPACITY] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_secondary_ammo_capacity_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_secondary_ammo_capacity_positive",
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_021",
					"card_bounty_name_submission_022",
					"card_bounty_name_submission_028",
				},
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_030",
					"card_bounty_name_submission_034",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.6,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						added_forbids = {
							BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE,
						},
						difficulty = 0.75,
						text = "0%",
						value = 0,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.05,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.075,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "40%",
						value = 1.4,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_primary_damage_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_primary_damage_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
				BuffEffectManager.EFFECT_ENEMY_HEALTH,
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_AMMO_CAPACITY,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_024",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						text = "25%",
						value = 0.75,
					},
				},
				{
					{
						difficulty = 0.6,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 0.8,
						text = "75%",
						value = 0.25,
					},
				},
				{
					{
						difficulty = 1,
						text = "95%",
						value = 0.05,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.01,
						text = "1%",
						value = 1.01,
					},
				},
				{
					{
						difficulty = -0.05,
						text = "5%",
						value = 1.05,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.3,
						text = "30%",
						value = 1.3,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_secondary_damage_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_secondary_damage_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMIES_RECEIVE_DAMAGE,
				BuffEffectManager.EFFECT_ENEMY_HEALTH,
				BuffEffectManager.EFFECT_PLAYER_SECONDARY_AMMO_CAPACITY,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_012",
					"card_bounty_name_submission_024",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.4,
						text = "25%",
						value = 0.75,
					},
				},
				{
					{
						difficulty = 0.5,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 0.7,
						text = "75%",
						value = 0.25,
					},
				},
				{
					{
						difficulty = 0.9,
						text = "95%",
						value = 0.05,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.01,
						text = "1%",
						value = 1.01,
					},
				},
				{
					{
						difficulty = -0.02,
						text = "5%",
						value = 1.05,
					},
				},
				{
					{
						difficulty = -0.08,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "30%",
						value = 1.3,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_HEALTH] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_health_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_health_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ENEMY_DOES_DAMAGE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_020",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = 0.65,
						text = "25%",
						value = 0.75,
					},
				},
				{
					{
						difficulty = 1.2,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 1.8,
						text = "75%",
						value = 0.25,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.05,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = -0.4,
						text = "50%",
						value = 1.5,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_MOVEMENT_SPEED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_movement_speed_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_movement_speed_positive",
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_011",
					"card_bounty_name_submission_023",
					"card_bounty_name_submission_032",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.25,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = 0.28,
						text = "15%",
						value = 0.85,
					},
				},
				{
					{
						difficulty = 0.3,
						text = "20%",
						value = 0.8,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.75,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "30%",
						value = 1.3,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_reload_speed_negative",
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_reload_speed_positive",
			},
			forbids = {
				BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_008",
					"card_bounty_name_submission_009",
					"card_bounty_name_submission_019",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.3,
						text = "10%",
						value = 0.9,
					},
				},
				{
					{
						difficulty = 0.4,
						text = "20%",
						value = 0.8,
					},
				},
				{
					{
						difficulty = 0.5,
						text = "30%",
						value = 0.7,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.1,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "30%",
						value = 1.3,
					},
				},
				{
					{
						difficulty = -0.25,
						text = "50%",
						value = 1.5,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_headshots_damage_increased",
			},
			forbids = {
				BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_010",
					"card_bounty_name_submission_016",
					"card_bounty_name_submission_017",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.15,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "15%",
						value = 1.15,
					},
				},
				{
					{
						difficulty = -0.25,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.3,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = -0.35,
						text = "30%",
						value = 1.3,
					},
				},
				{
					{
						difficulty = -0.5,
						text = "50%",
						value = 1.5,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_MELEE_DAMAGE_INCREASE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_melee_damage_positive",
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_melee_damage_negative",
			},
			forbids = {
				BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.4,
						text = "50%",
						value = 0.5,
					},
				},
				{
					{
						difficulty = 0.65,
						text = "90%",
						value = 0.1,
					},
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.35,
						text = "200%",
						value = 2,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CRITICAL_HIT_CHANCE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_player_crit_chance_positive",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.05,
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = -0.1,
						text = "15%",
						value = 1.15,
					},
				},
				{
					{
						difficulty = -0.15,
						text = "20%",
						value = 1.2,
					},
				},
				{
					{
						difficulty = -0.175,
						text = "25%",
						value = 1.25,
					},
				},
				{
					{
						difficulty = -0.2,
						text = "30%",
						value = 1.3,
					},
				},
				{
					{
						difficulty = -1,
						text = "100%",
						value = 2,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_headshot_doesnt_do_damage",
			},
			forbids = {
				BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_WARCRIES_DISABLED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_warcries_disabled_negative",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_AMMO_PICKUPS_REFIL_GRENADES] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_ammo_pickups_refill_equipment",
			},
			forbids = {
				BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
					"card_bounty_name_submission_007",
					"card_bounty_name_submission_015",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.3,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_BAGS_DONT_SLOW_PLAYERS_DOWN] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = "effect_bags_dont_slow_players_down",
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.25,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_ONLY_MELEE_AVAILABLE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_melee_only_negative",
			},
			forbids = {
				BuffEffectManager.EFFECT_AMMO_PICKUPS_REFIL_GRENADES,
				BuffEffectManager.EFFECT_PLAYER_RELOAD_SPEED,
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_DAMAGE,
				BuffEffectManager.EFFECT_PLAYER_PRIMARY_AMMO_CAPACITY,
				BuffEffectManager.EFFECT_PLAYER_SECONDARY_DAMAGE,
				BuffEffectManager.EFFECT_PLAYER_SECONDARY_AMMO_CAPACITY,
				BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DAMAGE,
				BuffEffectManager.EFFECT_PLAYER_HEADSHOT_DOESNT_DO_DAMAGE,
				BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_CHANCE,
				BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_DESPAWN_AMMO,
				BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_DESPAWN_HEALTH,
				BuffEffectManager.EFFECT_ENEMY_LOOT_DROP_REWARD_INCREASE,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_014",
					"card_bounty_name_submission_027",
					"card_bounty_name_submission_033",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 1,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CAN_MOVE_ONLY_BACK_AND_SIDE] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = "effect_player_can_only_walk_backwards_or_sideways",
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_001",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 666.666,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_DOOMS_DAY] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_PLAYER_DOOMS_DAY,
			},
			names = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
					"card_bounty_name_submission_002",
					"card_bounty_name_submission_025",
				},
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.82,
						includes = {
							[BuffEffectManager.EFFECT_PLAYER_CANNOT_ADS] = {
								value = true,
							},
							[BuffEffectManager.EFFECT_PLAYER_CANNOT_SPRINT] = {
								value = true,
							},
						},
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CANNOT_SPRINT] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_PLAYER_CANNOT_SPRINT,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.45,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CANNOT_ADS] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_PLAYER_CANNOT_ADS,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.5,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_RANDOM_RELOAD] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_PLAYER_RANDOM_RELOAD,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.65,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = BuffEffectManager.EFFECT_PLAYER_CARRY_INVERT_SPEED,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_POSITIVE] = {
				{
					{
						difficulty = -0.3,
						value = true,
					},
				},
			},
		},
		[BuffEffectManager.EFFECT_TIME_SPEED] = {
			descriptions = {
				[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = BuffEffectManager.EFFECT_TIME_SPEED,
			},
			[ChallengeCardsTweakData.EFFECT_TYPE_NEGATIVE] = {
				{
					{
						difficulty = 0.45,
						effect_class = "BuffEffectTimeSpeed",
						text = "10%",
						value = 1.1,
					},
				},
				{
					{
						difficulty = 0.6,
						effect_class = "BuffEffectTimeSpeed",
						text = "20%",
						value = 1.2,
					},
				},
			},
		},
	}
end
