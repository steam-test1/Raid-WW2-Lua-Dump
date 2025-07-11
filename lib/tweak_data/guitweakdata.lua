GuiTweakData = GuiTweakData or class()

function GuiTweakData:init()
	self.base_resolution = {
		x = 1920,
		y = 1080,
		z = 60,
	}

	self:_setup_layers()
	self:_setup_colors()
	self:_setup_hud_colors()
	self:_setup_fonts()
	self:_setup_font_paths()
	self:_setup_crosshairs()
	self:_setup_icons()
	self:_setup_reward_icons()
	self:_setup_radial_icons()
	self:_setup_hud_icons()
	self:_setup_hud_accessibility_icons()
	self:_setup_hud_hotswap_icons()
	self:_setup_hud_waypoint_icons()
	self:_setup_hud_reticles()
	self:_setup_hud_status_effects()
	self:_setup_map_icons()
	self:_setup_skill_icons()
	self:_setup_skill_big_icons()
	self:_setup_backgrounds()
	self:_setup_images()
	self:_setup_mission_photos()
	self:_setup_optical_flares()
	self:_setup_xp_icons()
	self:_setup_paper_icons()
	self:_setup_standalone_op_icons()
	self:_setup_nine_rect_icons()
	self:_setup_old_tweak_data()
end

function GuiTweakData:get_full_gui_data(icon, fallback)
	local gui = self.icons[icon] or self.icons[fallback] or {}

	return {
		color = gui.color,
		texture = gui.texture or "core/textures/default_texture_01_df",
		texture_rect = gui.texture_rect or {
			0,
			0,
			100,
			100,
		},
	}
end

function GuiTweakData:icon_w(icon)
	return self.icons[icon].texture_rect[3]
end

function GuiTweakData:icon_h(icon)
	return self.icons[icon].texture_rect[4]
end

function GuiTweakData:_setup_layers()
	self.PLAYER_PANELS_LAYER = 1300
	self.SAVEFILE_LAYER = 1500
	self.TAB_SCREEN_LAYER = 1400
	self.DEBRIEF_VIDEO_LAYER = 2000
end

function GuiTweakData:_setup_colors()
	self.colors = {}
	self.colors.raid_debug = Color("deaf3e")
	self.colors.raid_red = Color("de4a3e")
	self.colors.raid_dark_red = Color("c04236")
	self.colors.raid_brown_red = Color("802b24")
	self.colors.raid_light_red = Color("b8392e")
	self.colors.raid_white = Color("d7d7d7")
	self.colors.raid_dirty_white = Color("d3d3d3")
	self.colors.raid_grey = Color("9e9e9e")
	self.colors.raid_dark_grey = Color("565656")
	self.colors.raid_black = Color("0f0f0f")
	self.colors.raid_dark_gold = Color("805b24")
	self.colors.raid_gold = Color("c78e38")
	self.colors.raid_light_gold = Color("d8b883")
	self.colors.raid_skill_warcry = Color("c78e38")
	self.colors.raid_skill_boost = Color("64bc4c")
	self.colors.raid_skill_talent = Color("d5413d")
	self.colors.raid_skill_unapplied = Color("262626")
	self.colors.raid_skill_locked = Color("0f0f0f")
	self.colors.raid_list_background = Color.white:with_alpha(0.09803921568627451)
	self.colors.raid_select_card_background = Color.white:with_alpha(0.15)
	self.colors.raid_unlock_select_background = Color.white:with_alpha(0.1)
	self.colors.raid_table_background = Color.white:with_alpha(0.09803921568627451)
	self.colors.raid_table_cell_highlight_on = self.colors.raid_white
	self.colors.raid_table_cell_highlight_off = self.colors.raid_grey
	self.colors.progress_bar_dot = Color("797f88")
	self.colors.raid_grey_effects = Color("787878")
	self.colors.raid_grey_skills = Color("a9a9ae")
	self.colors.hitmarker_weak = Color("9e9e9e")
	self.colors.hitmarker_hurt = Color("d7d7d7")
	self.colors.hitmarker_kill = Color("de4a3e")
	self.colors.hitmarker_crit_kill = Color("db8f68")
	self.colors.hitmarker_crit = Color("d8b883")
	self.colors.loot_rarity_common = Color("9e9e9e")
	self.colors.loot_rarity_uncommon = Color("64bc4c")
	self.colors.loot_rarity_rare = Color("b8392e")
	self.colors.loot_rarity_halloween = Color("c78e38")
	self.colors.card_booster = Color("70b35b")
	self.colors.card_challenge = Color("de4a3e")
end

function GuiTweakData:_setup_hud_colors()
	self.colors.ammo_background_outline = Color("1f1f22")
	self.colors.ammo_text = Color("222222")
	self.colors.warcry_inactive = Color("ECECEC")
	self.colors.warcry_active = Color("dd9a38")
	self.colors.xp_breakdown_active_column = Color("dd9a38")
	self.colors.interaction_bar = Color("dd9a38")
	self.colors.teammate_interaction_bar = Color("9e9e9e")
	self.colors.progress_green = Color("64bc4c")
	self.colors.progress_yellow = Color("dd9a38")
	self.colors.progress_orange = Color("dd5c23")
	self.colors.progress_red = Color("b8392e")
	self.colors.progress_dark_red = Color("81271f")
	self.colors.toast_notification_border = Color("222222")
	self.colors.turret_overheat = Color("b8392e")
	self.colors.chat_border = Color("222222")
	self.colors.light_grey = Color("ececec")
	self.colors.dark_grey = Color("808080")
	self.colors.grid_item_grey = Color("1e1e1e")
	self.colors.chat_player_message = self.colors.raid_dirty_white
	self.colors.chat_peer_message = self.colors.raid_dirty_white
	self.colors.chat_system_message = self.colors.raid_red
	self.colors.gold_orange = Color("c68e38")
	self.colors.intel_newspapers_text = Color("d6c8b2")
	self.colors.player_health_colors = {
		{
			color = self.colors.progress_red,
			start_percentage = 0,
		},
		{
			color = self.colors.light_grey,
			start_percentage = 0.25,
		},
	}
	self.colors.player_warcry_colors = {
		{
			color = self.colors.light_grey,
			start_percentage = 0,
		},
	}
	self.colors.player_stamina_colors = {
		{
			color = self.colors.progress_red,
			start_percentage = 0,
		},
		{
			color = self.colors.light_grey,
			start_percentage = 0.25,
		},
	}
	self.colors.ammo_clip_colors = {
		{
			color = self.colors.progress_red,
			start_percentage = 0,
		},
		{
			color = self.colors.light_grey,
			start_percentage = 0.25,
		},
	}
	self.colors.ammo_clip_spent_colors = {
		{
			color = self.colors.progress_dark_red,
			start_percentage = 0,
		},
		{
			color = self.colors.dark_grey,
			start_percentage = 0.25,
		},
	}
	self.colors.turret_heat_colors = {
		{
			color = self.colors.progress_yellow,
			start_percentage = 0,
		},
	}
	self.colors.vehicle_health_colors = {
		{
			color = self.colors.progress_red,
			start_percentage = 0,
		},
		{
			color = self.colors.light_grey,
			start_percentage = 0.25,
		},
	}
	self.colors.vehicle_carry_amount_colors = {
		{
			color = self.colors.light_grey,
			start_percentage = 0,
		},
		{
			color = self.colors.progress_red,
			start_percentage = 0.25,
		},
	}
	self.colors.player_carry_amount_colors = {
		{
			color = self.colors.raid_gold,
			start_percentage = 0,
		},
		{
			color = self.colors.progress_red,
			start_percentage = 0.75,
		},
	}

	local color = self.colors.grid_item_grey

	self.colors.list_item_background = {
		0,
		color:with_alpha(0),
		0.1,
		color,
		0.9,
		color,
		1,
		color:with_alpha(0),
	}
end

function GuiTweakData.get_color_for_percentage(color_table, percentage)
	for i = #color_table, 1, -1 do
		if (percentage or 0.5) > color_table[i].start_percentage then
			return color_table[i].color
		end
	end

	return color_table[1].color
end

function GuiTweakData:_setup_fonts()
	self.fonts = {}
	self.fonts.din_compressed = "din_compressed"
	self.fonts.lato = "lato"
	self.fonts.noto = "noto"
	self.font_sizes = {}
	self.font_sizes.size_84 = 84
	self.font_sizes.size_76 = 76
	self.font_sizes.title = 66
	self.font_sizes.size_56 = 56
	self.font_sizes.size_52 = 52
	self.font_sizes.size_46 = 46
	self.font_sizes.menu_list = 42
	self.font_sizes.size_38 = 38
	self.font_sizes.dialg_title = 36
	self.font_sizes.subtitle = 32
	self.font_sizes.large = 32
	self.font_sizes.size_32 = 32
	self.font_sizes.medium = 28
	self.font_sizes.small = 26
	self.font_sizes.size_24 = 24
	self.font_sizes.extra_small = 22
	self.font_sizes.size_20 = 20
	self.font_sizes.size_18 = 18
	self.font_sizes.paragraph = 16
	self.font_sizes.size_16 = 16
	self.font_sizes.size_14 = 14
	self.font_sizes.size_12 = 12
end

function GuiTweakData:_setup_font_paths()
	self.font_paths = {}

	self:_setup_din_compressed_font_paths()
	self:_setup_din_compressed_outlined_fonts()
	self:_setup_lato_outlined_fonts()
	self:_setup_lato_font_paths()
end

function GuiTweakData:_setup_din_compressed_font_paths()
	self.font_paths.din_compressed = {}
	self.font_paths.din_compressed[18] = "ui/fonts/pf_din_text_comp_pro_medium_18_mf"
	self.font_paths.din_compressed[20] = "ui/fonts/pf_din_text_comp_pro_medium_20_mf"
	self.font_paths.din_compressed[22] = "ui/fonts/pf_din_text_comp_pro_medium_22_mf"
	self.font_paths.din_compressed[24] = "ui/fonts/pf_din_text_comp_pro_medium_24_mf"
	self.font_paths.din_compressed[26] = "ui/fonts/pf_din_text_comp_pro_medium_26_mf"
	self.font_paths.din_compressed[32] = "ui/fonts/pf_din_text_comp_pro_medium_32_mf"
	self.font_paths.din_compressed[38] = "ui/fonts/pf_din_text_comp_pro_medium_38_mf"
	self.font_paths.din_compressed[42] = "ui/fonts/pf_din_text_comp_pro_medium_42_mf"
	self.font_paths.din_compressed[46] = "ui/fonts/pf_din_text_comp_pro_medium_46_mf"
	self.font_paths.din_compressed[52] = "ui/fonts/pf_din_text_comp_pro_medium_52_mf"
	self.font_paths.din_compressed[56] = "ui/fonts/pf_din_text_comp_pro_medium_56_mf"
	self.font_paths.din_compressed[66] = "ui/fonts/pf_din_text_comp_pro_medium_66_mf"
	self.font_paths.din_compressed[72] = "ui/fonts/pf_din_text_comp_pro_medium_72_mf"
	self.font_paths.din_compressed[76] = "ui/fonts/pf_din_text_comp_pro_medium_76_mf"
	self.font_paths.din_compressed[84] = "ui/fonts/pf_din_text_comp_pro_medium_84_mf"
	self.font_paths.din_compressed.default = "ui/fonts/pf_din_text_comp_pro_medium_84_mf"
end

function GuiTweakData:_setup_din_compressed_outlined_fonts()
	self.fonts.din_compressed_outlined_18 = "ui/fonts/pf_din_text_comp_pro_medium_outlined_18_mf"
	self.fonts.din_compressed_outlined_20 = "ui/fonts/pf_din_text_comp_pro_medium_outlined_20_mf"
	self.fonts.din_compressed_outlined_22 = "ui/fonts/pf_din_text_comp_pro_medium_outlined_22_mf"
	self.fonts.din_compressed_outlined_24 = "ui/fonts/pf_din_text_comp_pro_medium_outlined_24_mf"
	self.fonts.din_compressed_outlined_26 = "ui/fonts/pf_din_text_comp_pro_medium_outlined_26_mf"
	self.fonts.din_compressed_outlined_32 = "ui/fonts/pf_din_text_comp_pro_medium_outlined_32_mf"
	self.fonts.din_compressed_outlined_38 = "ui/fonts/pf_din_text_comp_pro_medium_outlined_38_mf"
	self.fonts.din_compressed_outlined_42 = "ui/fonts/pf_din_text_comp_pro_medium_outlined_42_mf"
end

function GuiTweakData:_setup_lato_outlined_fonts()
	self.fonts.lato_outlined_18 = "ui/fonts/lato_regular_outlined_18_mf"
	self.fonts.lato_outlined_20 = "ui/fonts/lato_regular_outlined_20_mf"
end

function GuiTweakData:_setup_lato_font_paths()
	self.font_paths.lato = {}
	self.font_paths.lato[18] = "ui/fonts/lato_regular_18_mf"
	self.font_paths.lato[20] = "ui/fonts/lato_regular_20_mf"
	self.font_paths.lato[22] = "ui/fonts/lato_regular_22_mf"
	self.font_paths.lato[24] = "ui/fonts/lato_regular_24_mf"
	self.font_paths.lato[26] = "ui/fonts/lato_regular_26_mf"
	self.font_paths.lato[32] = "ui/fonts/lato_regular_32_mf"
	self.font_paths.lato[38] = "ui/fonts/lato_regular_38_mf"
	self.font_paths.lato[42] = "ui/fonts/lato_regular_42_mf"
	self.font_paths.lato.default = "ui/fonts/lato_regular_42_mf"
end

function GuiTweakData:_setup_noto_fonts()
	self.fonts.noto = {}
	self.fonts.noto[18] = "ui/fonts/noto_18"
	self.fonts.noto[20] = "ui/fonts/noto_20"
	self.fonts.noto[22] = "ui/fonts/noto_22"
	self.fonts.noto[24] = "ui/fonts/noto_24"
	self.fonts.noto[26] = "ui/fonts/noto_26"
	self.fonts.noto[32] = "ui/fonts/noto_32"
	self.fonts.noto[38] = "ui/fonts/noto_38"
	self.fonts.noto[42] = "ui/fonts/noto_42"
	self.fonts.noto.default = "ui/fonts/noto_42"
end

function GuiTweakData:get_font_path(font, font_size)
	local font_paths = self.font_paths[font]

	if not font_paths then
		return font
	end

	if not font_size then
		return font_paths.default
	end

	for i = 1, 4 do
		if font_paths[font_size * i] then
			font_paths[font_size] = font_paths[font_size * i]

			return font_paths[font_size * i]
		end
	end

	for i = font_size + 1, font_size * 2 do
		if font_paths[i] then
			font_paths[font_size] = font_paths[i]

			return font_paths[i]
		end
	end

	debug_pause("[GuiTweakData:get_font_path] Falling back to the default for font " .. tostring(font) .. " with size " .. tostring(font_size), debug.traceback())

	return font_paths.default
end

function GuiTweakData:_setup_crosshairs()
	self.crosshairs = {}
	self.crosshairs.pistol = {
		base_rotation = 0,
		degree_field = 360,
		edge_pips = 4,
		edge_pips_icon = "weapons_reticles_flatline",
	}
	self.crosshairs.smg = {
		base_rotation = 0,
		degree_field = 270,
		edge_pips = 3,
		edge_pips_icon = "weapons_reticles_flatline",
	}
	self.crosshairs.lmg = {
		base_rotation = 0,
		core_dot = "weapons_reticles_static_diamond",
		degree_field = 225,
		edge_pips = 5,
		edge_pips_icon = {
			"weapons_reticles_flatline",
		},
	}
	self.crosshairs.lmg_mg42 = deep_clone(self.crosshairs.lmg)
	self.crosshairs.lmg_mg42.degree_field = 360
	self.crosshairs.lmg_mg42.edge_pips = 6
	self.crosshairs.lmg_mg42.base_rotation = -30
	self.crosshairs.lmg_mg42.core_dot = "weapons_reticles_static_triangle"
	self.crosshairs.lmg_dp28 = deep_clone(self.crosshairs.lmg)
	self.crosshairs.lmg_dp28.degree_field = 360
	self.crosshairs.lmg_dp28.edge_pips = 4
	self.crosshairs.lmg_dp28.base_rotation = 0
	self.crosshairs.lmg_dp28.core_dot = "weapons_reticles_static_dot"
	self.crosshairs.lmg_dp28.edge_pips_icon = {
		"weapons_reticles_bowbend",
	}
	self.crosshairs.assault_rifle = {
		base_rotation = 0,
		core_dot = "weapons_reticles_static_dot",
		degree_field = 360,
		edge_pips = 4,
		edge_pips_icon = "weapons_reticles_flatline",
	}
	self.crosshairs.sniper = {
		base_rotation = 0,
		core_dot = "weapons_reticles_static_tri_small",
		degree_field = 270,
		edge_pips = 3,
		edge_pips_icon = "weapons_reticles_flatline",
	}
	self.crosshairs.shotgun = {
		base_rotation = 0,
		core_dot = "weapons_reticles_static_dot",
		degree_field = 360,
		edge_pips = 4,
		edge_pips_icon = "weapons_reticles_bowbend",
	}
	self.crosshairs.shotgun_db = deep_clone(self.crosshairs.shotgun)
	self.crosshairs.shotgun_db.edge_pips = 2
	self.crosshairs.grenade = {
		base_rotation = 0,
		core_dot = "weapons_reticles_static_diamond",
		degree_field = 0,
		edge_pips = 0,
		edge_pips_icon = nil,
	}
end

function GuiTweakData:_setup_icons()
	self.icons = {}
	self.icons.credits_logo_lgl = {}
	self.icons.credits_logo_lgl.texture = "ui/atlas/menu/raid_atlas_logos"
	self.icons.credits_logo_lgl.texture_rect = {
		2,
		866,
		448,
		448,
	}
	self.icons.credits_logo_sb = {}
	self.icons.credits_logo_sb.texture = "ui/atlas/menu/raid_atlas_logos"
	self.icons.credits_logo_sb.texture_rect = {
		452,
		866,
		448,
		448,
	}
	self.icons.raid_hw_logo_small = {}
	self.icons.raid_hw_logo_small.texture = "ui/atlas/menu/raid_atlas_logos"
	self.icons.raid_hw_logo_small.texture_rect = {
		2,
		1316,
		400,
		242,
	}
	self.icons.raid_logo_big = {}
	self.icons.raid_logo_big.texture = "ui/atlas/menu/raid_atlas_logos"
	self.icons.raid_logo_big.texture_rect = {
		2,
		2,
		880,
		430,
	}
	self.icons.raid_logo_small = {}
	self.icons.raid_logo_small.texture = "ui/atlas/menu/raid_atlas_logos"
	self.icons.raid_logo_small.texture_rect = {
		2,
		1560,
		384,
		192,
	}
	self.icons.raid_se_logo_big = {}
	self.icons.raid_se_logo_big.texture = "ui/atlas/menu/raid_atlas_logos"
	self.icons.raid_se_logo_big.texture_rect = {
		2,
		434,
		880,
		430,
	}
	self.icons.raid_se_logo_small = {}
	self.icons.raid_se_logo_small.texture = "ui/atlas/menu/raid_atlas_logos"
	self.icons.raid_se_logo_small.texture_rect = {
		404,
		1316,
		400,
		242,
	}
	self.icons.raid_oops_logo_small = {}
	self.icons.raid_oops_logo_small.texture = "ui/updates/upd_oops/update_logo"
	self.icons.raid_oops_logo_small.texture_rect = {
		0,
		0,
		833,
		500,
	}
	self.icons.bootup_logo_sb = {}
	self.icons.bootup_logo_sb.texture = "ui/atlas/raid_atlas_bootup"
	self.icons.bootup_logo_sb.texture_rect = {
		0,
		0,
		1024,
		1024,
	}
	self.icons.bootup_logo_lgl = {}
	self.icons.bootup_logo_lgl.texture = "ui/atlas/raid_atlas_bootup"
	self.icons.bootup_logo_lgl.texture_rect = {
		1024,
		0,
		1024,
		1024,
	}
	self.icons.bootup_logo_third_parties = {}
	self.icons.bootup_logo_third_parties.texture = "ui/atlas/raid_atlas_bootup"
	self.icons.bootup_logo_third_parties.texture_rect = {
		0,
		1024,
		2048,
		1024,
	}
	self.icons.credits_logo_wwise = {}
	self.icons.credits_logo_wwise.texture = "ui/atlas/raid_atlas_bootup"
	self.icons.credits_logo_wwise.texture_rect = {
		512,
		1280,
		512,
		512,
	}
	self.icons.credits_logo_bink = {}
	self.icons.credits_logo_bink.texture = "ui/atlas/raid_atlas_bootup"
	self.icons.credits_logo_bink.texture_rect = {
		1024,
		1280,
		512,
		512,
	}
	self.icons.credits_logo_physx = {}
	self.icons.credits_logo_physx.texture = "ui/atlas/raid_atlas_bootup"
	self.icons.credits_logo_physx.texture_rect = {
		1536,
		1280,
		512,
		512,
	}
	self.icons.breadcumb_indicator = {}
	self.icons.breadcumb_indicator.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.breadcumb_indicator.texture_rect = {
		576,
		352,
		32,
		32,
	}
	self.icons.btn_circ_lock = {}
	self.icons.btn_circ_lock.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_circ_lock.texture_rect = {
		741,
		452,
		48,
		48,
	}
	self.icons.btn_circ_lock_hover = {}
	self.icons.btn_circ_lock_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_circ_lock_hover.texture_rect = {
		610,
		452,
		48,
		48,
	}
	self.icons.btn_circ_x = {}
	self.icons.btn_circ_x.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_circ_x.texture_rect = {
		664,
		502,
		48,
		48,
	}
	self.icons.btn_circ_x_hover = {}
	self.icons.btn_circ_x_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_circ_x_hover.texture_rect = {
		714,
		502,
		48,
		48,
	}
	self.icons.btn_dissabled_192 = {}
	self.icons.btn_dissabled_192.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_dissabled_192.texture_rect = {
		610,
		302,
		192,
		48,
	}
	self.icons.btn_dissabled_192_hover = {}
	self.icons.btn_dissabled_192_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_dissabled_192_hover.texture_rect = {
		804,
		302,
		192,
		48,
	}
	self.icons.btn_dissabled_256 = {}
	self.icons.btn_dissabled_256.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_dissabled_256.texture_rect = {
		490,
		2,
		256,
		48,
	}
	self.icons.btn_dissabled_256_hover = {}
	self.icons.btn_dissabled_256_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_dissabled_256_hover.texture_rect = {
		748,
		2,
		256,
		48,
	}
	self.icons.btn_list_rect = {}
	self.icons.btn_list_rect.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_list_rect.texture_rect = {
		372,
		726,
		116,
		94,
	}
	self.icons.btn_list_rect_hover = {}
	self.icons.btn_list_rect_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_list_rect_hover.texture_rect = {
		458,
		888,
		116,
		94,
	}
	self.icons.btn_primary_192 = {}
	self.icons.btn_primary_192.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_primary_192.texture_rect = {
		610,
		352,
		192,
		48,
	}
	self.icons.btn_primary_192_hover = {}
	self.icons.btn_primary_192_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_primary_192_hover.texture_rect = {
		804,
		352,
		192,
		48,
	}
	self.icons.btn_primary_256 = {}
	self.icons.btn_primary_256.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_primary_256.texture_rect = {
		490,
		52,
		256,
		48,
	}
	self.icons.btn_primary_256_hover = {}
	self.icons.btn_primary_256_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_primary_256_hover.texture_rect = {
		748,
		52,
		256,
		48,
	}
	self.icons.btn_purchase_192 = {}
	self.icons.btn_purchase_192.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_purchase_192.texture_rect = {
		610,
		402,
		192,
		48,
	}
	self.icons.btn_purchase_192_hover = {}
	self.icons.btn_purchase_192_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_purchase_192_hover.texture_rect = {
		804,
		402,
		192,
		48,
	}
	self.icons.btn_purchase_256 = {}
	self.icons.btn_purchase_256.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_purchase_256.texture_rect = {
		490,
		102,
		256,
		48,
	}
	self.icons.btn_purchase_256_hover = {}
	self.icons.btn_purchase_256_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_purchase_256_hover.texture_rect = {
		748,
		102,
		256,
		48,
	}
	self.icons.btn_secondary_192 = {}
	self.icons.btn_secondary_192.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_secondary_192.texture_rect = {
		830,
		452,
		192,
		48,
	}
	self.icons.btn_secondary_192_hover = {}
	self.icons.btn_secondary_192_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_secondary_192_hover.texture_rect = {
		830,
		502,
		192,
		48,
	}
	self.icons.btn_secondary_256 = {}
	self.icons.btn_secondary_256.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_secondary_256.texture_rect = {
		490,
		152,
		256,
		48,
	}
	self.icons.btn_secondary_256_hover = {}
	self.icons.btn_secondary_256_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_secondary_256_hover.texture_rect = {
		748,
		152,
		256,
		48,
	}
	self.icons.btn_small_128 = {}
	self.icons.btn_small_128.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_small_128.texture_rect = {
		534,
		678,
		128,
		40,
	}
	self.icons.btn_small_128_hover = {}
	self.icons.btn_small_128_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_small_128_hover.texture_rect = {
		830,
		982,
		128,
		40,
	}
	self.icons.btn_tetriary_192 = {}
	self.icons.btn_tetriary_192.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_tetriary_192.texture_rect = {
		830,
		552,
		192,
		48,
	}
	self.icons.btn_tetriary_192_hover = {}
	self.icons.btn_tetriary_192_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_tetriary_192_hover.texture_rect = {
		830,
		602,
		192,
		48,
	}
	self.icons.btn_tetriary_256 = {}
	self.icons.btn_tetriary_256.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_tetriary_256.texture_rect = {
		490,
		202,
		256,
		48,
	}
	self.icons.btn_tetriary_256_hover = {}
	self.icons.btn_tetriary_256_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_tetriary_256_hover.texture_rect = {
		748,
		202,
		256,
		48,
	}
	self.icons.btn_tetriary_disabled_192 = {}
	self.icons.btn_tetriary_disabled_192.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_tetriary_disabled_192.texture_rect = {
		830,
		652,
		192,
		48,
	}
	self.icons.btn_tetriary_disabled_192_hover = {}
	self.icons.btn_tetriary_disabled_192_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_tetriary_disabled_192_hover.texture_rect = {
		830,
		702,
		192,
		48,
	}
	self.icons.btn_tetriary_disabled_256 = {}
	self.icons.btn_tetriary_disabled_256.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_tetriary_disabled_256.texture_rect = {
		490,
		252,
		256,
		48,
	}
	self.icons.btn_tetriary_disabled_256_hover = {}
	self.icons.btn_tetriary_disabled_256_hover.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.btn_tetriary_disabled_256_hover.texture_rect = {
		748,
		252,
		256,
		48,
	}
	self.icons.card_counter_bg = {}
	self.icons.card_counter_bg.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.card_counter_bg.texture_rect = {
		654,
		786,
		51,
		32,
	}
	self.icons.card_counter_bg_large = {}
	self.icons.card_counter_bg_large.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.card_counter_bg_large.texture_rect = {
		389,
		822,
		102,
		64,
	}
	self.icons.cc_empty_slot_large = {}
	self.icons.cc_empty_slot_large.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.cc_empty_slot_large.texture_rect = {
		98,
		452,
		272,
		388,
	}
	self.icons.cc_empty_slot_small = {}
	self.icons.cc_empty_slot_small.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.cc_empty_slot_small.texture_rect = {
		332,
		2,
		156,
		222,
	}
	self.icons.character_creation_1_large = {}
	self.icons.character_creation_1_large.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.character_creation_1_large.texture_rect = {
		584,
		502,
		48,
		48,
	}
	self.icons.character_creation_2_large = {}
	self.icons.character_creation_2_large.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.character_creation_2_large.texture_rect = {
		584,
		552,
		48,
		48,
	}
	self.icons.character_creation_2_small = {}
	self.icons.character_creation_2_small.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.character_creation_2_small.texture_rect = {
		584,
		602,
		48,
		48,
	}
	self.icons.character_creation_checked = {}
	self.icons.character_creation_checked.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.character_creation_checked.texture_rect = {
		634,
		552,
		48,
		48,
	}
	self.icons.character_creation_nationality_american = {}
	self.icons.character_creation_nationality_american.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.character_creation_nationality_american.texture_rect = {
		401,
		226,
		52,
		52,
	}
	self.icons.character_creation_nationality_british = {}
	self.icons.character_creation_nationality_british.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.character_creation_nationality_british.texture_rect = {
		401,
		280,
		52,
		52,
	}
	self.icons.character_creation_nationality_german = {}
	self.icons.character_creation_nationality_german.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.character_creation_nationality_german.texture_rect = {
		522,
		302,
		52,
		52,
	}
	self.icons.character_creation_nationality_russian = {}
	self.icons.character_creation_nationality_russian.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.character_creation_nationality_russian.texture_rect = {
		790,
		820,
		52,
		52,
	}
	self.icons.charsel_default_lower = {}
	self.icons.charsel_default_lower.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.charsel_default_lower.texture_rect = {
		129,
		230,
		134,
		134,
	}
	self.icons.charsel_default_upper = {}
	self.icons.charsel_default_upper.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.charsel_default_upper.texture_rect = {
		265,
		230,
		134,
		134,
	}
	self.icons.checkbox_base = {}
	self.icons.checkbox_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.checkbox_base.texture_rect = {
		576,
		386,
		32,
		32,
	}
	self.icons.checkbox_check_base = {}
	self.icons.checkbox_check_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.checkbox_check_base.texture_rect = {
		342,
		998,
		20,
		20,
	}
	self.icons.consumable_purchased_confirmed = {}
	self.icons.consumable_purchased_confirmed.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.consumable_purchased_confirmed.texture_rect = {
		634,
		602,
		48,
		48,
	}
	self.icons.gold_amount_footer = {}
	self.icons.gold_amount_footer.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.gold_amount_footer.texture_rect = {
		576,
		420,
		32,
		32,
	}
	self.icons.gold_amount_purchase = {}
	self.icons.gold_amount_purchase.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.gold_amount_purchase.texture_rect = {
		720,
		752,
		32,
		32,
	}
	self.icons.hslider_arrow_left_base = {}
	self.icons.hslider_arrow_left_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.hslider_arrow_left_base.texture_rect = {
		754,
		752,
		32,
		32,
	}
	self.icons.hslider_arrow_right_base = {}
	self.icons.hslider_arrow_right_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.hslider_arrow_right_base.texture_rect = {
		759,
		786,
		32,
		32,
	}
	self.icons.ico_arrow_large_left = {}
	self.icons.ico_arrow_large_left.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_arrow_large_left.texture_rect = {
		792,
		874,
		52,
		52,
	}
	self.icons.ico_arrow_large_right = {}
	self.icons.ico_arrow_large_right.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_arrow_large_right.texture_rect = {
		844,
		820,
		52,
		52,
	}
	self.icons.ico_bonus = {}
	self.icons.ico_bonus.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.ico_bonus.texture_rect = {
		128,
		64,
		64,
		64,
	}
	self.icons.ico_malus = {}
	self.icons.ico_malus.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.ico_malus.texture_rect = {
		192,
		64,
		64,
		64,
	}
	self.icons.ico_condition = {}
	self.icons.ico_condition.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.ico_condition.texture_rect = {
		192,
		128,
		64,
		64,
	}
	self.icons.ico_class_assault = {}
	self.icons.ico_class_assault.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_class_assault.texture_rect = {
		826,
		928,
		52,
		52,
	}
	self.icons.ico_class_demolitions = {}
	self.icons.ico_class_demolitions.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_class_demolitions.texture_rect = {
		846,
		874,
		52,
		52,
	}
	self.icons.ico_class_infiltrator = {}
	self.icons.ico_class_infiltrator.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_class_infiltrator.texture_rect = {
		898,
		820,
		52,
		52,
	}
	self.icons.ico_class_recon = {}
	self.icons.ico_class_recon.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_class_recon.texture_rect = {
		880,
		928,
		52,
		52,
	}
	self.icons.ico_difficulty_deathwish = {}
	self.icons.ico_difficulty_deathwish.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_difficulty_deathwish.texture_rect = {
		664,
		452,
		75,
		48,
	}
	self.icons.ico_difficulty_hard = {}
	self.icons.ico_difficulty_hard.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_difficulty_hard.texture_rect = {
		684,
		552,
		48,
		48,
	}
	self.icons.ico_difficulty_normal = {}
	self.icons.ico_difficulty_normal.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_difficulty_normal.texture_rect = {
		734,
		552,
		48,
		48,
	}
	self.icons.ico_difficulty_overkill = {}
	self.icons.ico_difficulty_overkill.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_difficulty_overkill.texture_rect = {
		684,
		602,
		48,
		48,
	}
	self.icons.ico_difficulty_very_hard = {}
	self.icons.ico_difficulty_very_hard.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_difficulty_very_hard.texture_rect = {
		734,
		602,
		48,
		48,
	}
	self.icons.ico_dlc = {}
	self.icons.ico_dlc.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_dlc.texture_rect = {
		788,
		752,
		32,
		32,
	}
	self.icons.ico_filter = {}
	self.icons.ico_filter.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_filter.texture_rect = {
		793,
		786,
		32,
		32,
	}
	self.icons.ico_flag_american = {}
	self.icons.ico_flag_american.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_flag_american.texture_rect = {
		486,
		480,
		96,
		64,
	}
	self.icons.ico_flag_british = {}
	self.icons.ico_flag_british.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_flag_british.texture_rect = {
		486,
		546,
		96,
		64,
	}
	self.icons.ico_flag_empty = {}
	self.icons.ico_flag_empty.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_flag_empty.texture_rect = {
		486,
		612,
		96,
		64,
	}
	self.icons.ico_flag_german = {}
	self.icons.ico_flag_german.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_flag_german.texture_rect = {
		490,
		726,
		96,
		64,
	}
	self.icons.ico_flag_russian = {}
	self.icons.ico_flag_russian.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_flag_russian.texture_rect = {
		493,
		821,
		96,
		64,
	}
	self.icons.ico_info = {}
	self.icons.ico_info.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_info.texture_rect = {
		458,
		984,
		36,
		36,
	}
	self.icons.ico_intel = {}
	self.icons.ico_intel.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_intel.texture_rect = {
		496,
		984,
		36,
		36,
	}
	self.icons.ico_locker = {}
	self.icons.ico_locker.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_locker.texture_rect = {
		822,
		752,
		32,
		32,
	}
	self.icons.ico_lower_body = {}
	self.icons.ico_lower_body.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_lower_body.texture_rect = {
		455,
		258,
		33,
		33,
	}
	self.icons.ico_map = {}
	self.icons.ico_map.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_map.texture_rect = {
		534,
		984,
		36,
		36,
	}
	self.icons.ico_map_mini_raid = {}
	self.icons.ico_map_mini_raid.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_map_mini_raid.texture_rect = {
		572,
		984,
		36,
		36,
	}
	self.icons.ico_map_raid = {}
	self.icons.ico_map_raid.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_map_raid.texture_rect = {
		792,
		452,
		36,
		36,
	}
	self.icons.ico_map_starting_point = {}
	self.icons.ico_map_starting_point.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_map_starting_point.texture_rect = {
		792,
		490,
		36,
		36,
	}
	self.icons.ico_nav_back_base = {}
	self.icons.ico_nav_back_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_nav_back_base.texture_rect = {
		792,
		528,
		36,
		36,
	}
	self.icons.ico_nav_right_base = {}
	self.icons.ico_nav_right_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_nav_right_base.texture_rect = {
		792,
		566,
		36,
		36,
	}
	self.icons.ico_operation = {}
	self.icons.ico_operation.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_operation.texture_rect = {
		157,
		842,
		56,
		56,
	}
	self.icons.ico_ops_card = {}
	self.icons.ico_ops_card.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_ops_card.texture_rect = {
		792,
		604,
		36,
		36,
	}
	self.icons.ico_page_turn_left = {}
	self.icons.ico_page_turn_left.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_page_turn_left.texture_rect = {
		827,
		786,
		32,
		32,
	}
	self.icons.ico_page_turn_right = {}
	self.icons.ico_page_turn_right.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_page_turn_right.texture_rect = {
		856,
		752,
		32,
		32,
	}
	self.icons.ico_play_audio = {}
	self.icons.ico_play_audio.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_play_audio.texture_rect = {
		792,
		642,
		36,
		36,
	}
	self.icons.ico_raid = {}
	self.icons.ico_raid.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_raid.texture_rect = {
		215,
		842,
		56,
		56,
	}
	self.icons.ico_sel_rect_bottom_right = {}
	self.icons.ico_sel_rect_bottom_right.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_sel_rect_bottom_right.texture_rect = {
		458,
		226,
		30,
		30,
	}
	self.icons.ico_sel_rect_bottom_right_white = {}
	self.icons.ico_sel_rect_bottom_right_white.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_sel_rect_bottom_right_white.texture_rect = {
		490,
		302,
		30,
		30,
	}
	self.icons.ico_sel_rect_small_bottom_right = {}
	self.icons.ico_sel_rect_small_bottom_right.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_sel_rect_small_bottom_right.texture_rect = {
		440,
		998,
		16,
		16,
	}
	self.icons.ico_sel_rect_small_bottom_right_white = {}
	self.icons.ico_sel_rect_small_bottom_right_white.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_sel_rect_small_bottom_right_white.texture_rect = {
		129,
		432,
		16,
		16,
	}
	self.icons.ico_sel_rect_small_top_left = {}
	self.icons.ico_sel_rect_small_top_left.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_sel_rect_small_top_left.texture_rect = {
		147,
		432,
		16,
		16,
	}
	self.icons.ico_sel_rect_small_top_left_white = {}
	self.icons.ico_sel_rect_small_top_left_white.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_sel_rect_small_top_left_white.texture_rect = {
		165,
		432,
		16,
		16,
	}
	self.icons.ico_sel_rect_top_left = {}
	self.icons.ico_sel_rect_top_left.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_sel_rect_top_left.texture_rect = {
		788,
		714,
		30,
		30,
	}
	self.icons.ico_sel_rect_top_left_white = {}
	self.icons.ico_sel_rect_top_left_white.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_sel_rect_top_left_white.texture_rect = {
		929,
		786,
		30,
		30,
	}
	self.icons.ico_server = {}
	self.icons.ico_server.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_server.texture_rect = {
		576,
		302,
		32,
		48,
	}
	self.icons.ico_slider_thumb = {}
	self.icons.ico_slider_thumb.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_slider_thumb.texture_rect = {
		861,
		786,
		32,
		32,
	}
	self.icons.ico_slider_thumb_large = {}
	self.icons.ico_slider_thumb_large.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_slider_thumb_large.texture_rect = {
		890,
		752,
		32,
		32,
	}
	self.icons.ico_time = {}
	self.icons.ico_time.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_time.texture_rect = {
		742,
		988,
		34,
		34,
	}
	self.icons.ico_upper_body = {}
	self.icons.ico_upper_body.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_upper_body.texture_rect = {
		455,
		293,
		33,
		33,
	}
	self.icons.ico_voice_chat = {}
	self.icons.ico_voice_chat.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ico_voice_chat.texture_rect = {
		895,
		786,
		32,
		32,
	}
	self.icons.icon_loot_won = {}
	self.icons.icon_loot_won.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.icon_loot_won.texture_rect = {
		129,
		2,
		201,
		226,
	}
	self.icons.icon_paper_stamp_consumable = {}
	self.icons.icon_paper_stamp_consumable.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.icon_paper_stamp_consumable.texture_rect = {
		2,
		902,
		112,
		112,
	}
	self.icons.icon_paper_stamp_consumable_ver002 = {}
	self.icons.icon_paper_stamp_consumable_ver002.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.icon_paper_stamp_consumable_ver002.texture_rect = {
		116,
		900,
		112,
		112,
	}
	self.icons.icon_weapon_unlocked = {}
	self.icons.icon_weapon_unlocked.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.icon_weapon_unlocked.texture_rect = {
		490,
		792,
		40,
		27,
	}
	self.icons.if_center_base = {}
	self.icons.if_center_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.if_center_base.texture_rect = {
		1006,
		104,
		10,
		48,
	}
	self.icons.if_left_base = {}
	self.icons.if_left_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.if_left_base.texture_rect = {
		1006,
		154,
		10,
		48,
	}
	self.icons.if_right_base = {}
	self.icons.if_right_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.if_right_base.texture_rect = {
		1006,
		204,
		10,
		48,
	}
	self.icons.info_icon = {}
	self.icons.info_icon.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.info_icon.texture_rect = {
		924,
		752,
		32,
		32,
	}
	self.icons.kb_center_base = {}
	self.icons.kb_center_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.kb_center_base.texture_rect = {
		1006,
		254,
		10,
		32,
	}
	self.icons.kb_left_base = {}
	self.icons.kb_left_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.kb_left_base.texture_rect = {
		1006,
		288,
		10,
		32,
	}
	self.icons.kb_right_base = {}
	self.icons.kb_right_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.kb_right_base.texture_rect = {
		387,
		366,
		10,
		32,
	}
	self.icons.list_btn_ico_customize = {}
	self.icons.list_btn_ico_customize.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.list_btn_ico_customize.texture_rect = {
		958,
		752,
		30,
		30,
	}
	self.icons.list_btn_ico_plus = {}
	self.icons.list_btn_ico_plus.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.list_btn_ico_plus.texture_rect = {
		961,
		784,
		30,
		30,
	}
	self.icons.list_btn_ico_x = {}
	self.icons.list_btn_ico_x.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.list_btn_ico_x.texture_rect = {
		990,
		752,
		30,
		30,
	}
	self.icons.loading_revolver_circle = {}
	self.icons.loading_revolver_circle.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.loading_revolver_circle.texture_rect = {
		183,
		432,
		10,
		10,
	}
	self.icons.loot_meter_parts_l = {}
	self.icons.loot_meter_parts_l.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.loot_meter_parts_l.texture_rect = {
		134,
		1014,
		4,
		8,
	}
	self.icons.loot_meter_parts_m = {}
	self.icons.loot_meter_parts_m.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.loot_meter_parts_m.texture_rect = {
		140,
		1014,
		4,
		8,
	}
	self.icons.loot_meter_parts_r = {}
	self.icons.loot_meter_parts_r.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.loot_meter_parts_r.texture_rect = {
		146,
		1014,
		4,
		8,
	}
	self.icons.loot_rarity_common = {}
	self.icons.loot_rarity_common.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.loot_rarity_common.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.loot_rarity_uncommon = {}
	self.icons.loot_rarity_uncommon.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.loot_rarity_uncommon.texture_rect = {
		64,
		0,
		64,
		64,
	}
	self.icons.loot_rarity_rare = {}
	self.icons.loot_rarity_rare.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.loot_rarity_rare.texture_rect = {
		128,
		0,
		64,
		64,
	}
	self.icons.loot_rarity_halloween = {}
	self.icons.loot_rarity_halloween.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.loot_rarity_halloween.texture_rect = {
		192,
		0,
		64,
		64,
	}
	self.icons.loot_rarity_common_dirty = {}
	self.icons.loot_rarity_common_dirty.texture = "ui/atlas/menu/cc_menu_tags_dirty"
	self.icons.loot_rarity_common_dirty.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.loot_rarity_uncommon_dirty = {}
	self.icons.loot_rarity_uncommon_dirty.texture = "ui/atlas/menu/cc_menu_tags_dirty"
	self.icons.loot_rarity_uncommon_dirty.texture_rect = {
		64,
		0,
		64,
		64,
	}
	self.icons.loot_rarity_rare_dirty = {}
	self.icons.loot_rarity_rare_dirty.texture = "ui/atlas/menu/cc_menu_tags_dirty"
	self.icons.loot_rarity_rare_dirty.texture_rect = {
		128,
		0,
		64,
		64,
	}
	self.icons.loot_rarity_halloween_dirty = {}
	self.icons.loot_rarity_halloween_dirty.texture = "ui/atlas/menu/cc_menu_tags_dirty"
	self.icons.loot_rarity_halloween_dirty.texture_rect = {
		192,
		0,
		64,
		64,
	}
	self.icons.card_type_operation = {}
	self.icons.card_type_operation.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.card_type_operation.texture_rect = {
		0,
		64,
		64,
		64,
	}
	self.icons.card_type_raid = {}
	self.icons.card_type_raid.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.card_type_raid.texture_rect = {
		64,
		64,
		64,
		64,
	}
	self.icons.card_type_none = {}
	self.icons.card_type_none.texture = "ui/atlas/menu/cc_menu_tags_clean"
	self.icons.card_type_none.texture_rect = {
		64,
		64,
		64,
		64,
	}
	self.icons.card_type_operation_dirty = {}
	self.icons.card_type_operation_dirty.texture = "ui/atlas/menu/cc_menu_tags_dirty"
	self.icons.card_type_operation_dirty.texture_rect = {
		0,
		64,
		64,
		64,
	}
	self.icons.card_type_raid_dirty = {}
	self.icons.card_type_raid_dirty.texture = "ui/atlas/menu/cc_menu_tags_dirty"
	self.icons.card_type_raid_dirty.texture_rect = {
		64,
		64,
		64,
		64,
	}
	self.icons.card_type_none_dirty = {}
	self.icons.card_type_none_dirty.texture = "ui/atlas/menu/cc_menu_tags_dirty"
	self.icons.card_type_none_dirty.texture_rect = {
		64,
		64,
		64,
		64,
	}
	self.icons.card_type_bounty = {}
	self.icons.card_type_bounty.texture = "ui/updates/upd_cow/cc_menu_tags_bounty"
	self.icons.card_type_bounty.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.card_type_bounty_dirty = {}
	self.icons.card_type_bounty_dirty.texture = "ui/updates/upd_cow/cc_menu_tags_bounty"
	self.icons.card_type_bounty_dirty.texture_rect = {
		64,
		0,
		64,
		64,
	}
	self.icons.players_icon_gamecard = {}
	self.icons.players_icon_gamecard.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.players_icon_gamecard.texture_rect = {
		664,
		680,
		32,
		32,
	}
	self.icons.players_icon_kick = {}
	self.icons.players_icon_kick.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.players_icon_kick.texture_rect = {
		698,
		680,
		32,
		32,
	}
	self.icons.players_icon_mute = {}
	self.icons.players_icon_mute.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.players_icon_mute.texture_rect = {
		720,
		714,
		32,
		32,
	}
	self.icons.players_icon_outline = {}
	self.icons.players_icon_outline.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.players_icon_outline.texture_rect = {
		486,
		678,
		46,
		46,
	}
	self.icons.players_icon_unmute = {}
	self.icons.players_icon_unmute.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.players_icon_unmute.texture_rect = {
		732,
		680,
		32,
		32,
	}
	self.icons.players_icon_xbox_invite = {}
	self.icons.players_icon_xbox_invite.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.players_icon_xbox_invite.texture_rect = {
		754,
		714,
		32,
		32,
	}
	self.icons.ready_up_card_not_selected = {}
	self.icons.ready_up_card_not_selected.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ready_up_card_not_selected.texture_rect = {
		282,
		998,
		18,
		24,
	}
	self.icons.ready_up_card_selected_active = {}
	self.icons.ready_up_card_selected_active.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ready_up_card_selected_active.texture_rect = {
		302,
		998,
		18,
		24,
	}
	self.icons.ready_up_card_selected_inactive = {}
	self.icons.ready_up_card_selected_inactive.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.ready_up_card_selected_inactive.texture_rect = {
		322,
		998,
		18,
		24,
	}
	self.icons.rewards_dog_tags = {}
	self.icons.rewards_dog_tags.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_dog_tags.texture_rect = {
		230,
		900,
		112,
		96,
	}
	self.icons.rewards_dog_tags_small = {}
	self.icons.rewards_dog_tags_small.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_dog_tags_small.texture_rect = {
		588,
		720,
		64,
		64,
	}
	self.icons.rewards_extra_loot = {}
	self.icons.rewards_extra_loot.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_extra_loot.texture_rect = {
		344,
		900,
		112,
		96,
	}
	self.icons.rewards_extra_loot_frame = {}
	self.icons.rewards_extra_loot_frame.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_extra_loot_frame.texture_rect = {
		372,
		432,
		112,
		96,
	}
	self.icons.rewards_extra_loot_middle_gold = {}
	self.icons.rewards_extra_loot_middle_gold.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_extra_loot_middle_gold.texture_rect = {
		401,
		334,
		112,
		96,
	}
	self.icons.rewards_extra_loot_middle_loot = {}
	self.icons.rewards_extra_loot_middle_loot.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_extra_loot_middle_loot.texture_rect = {
		372,
		530,
		112,
		96,
	}
	self.icons.rewards_extra_loot_small = {}
	self.icons.rewards_extra_loot_small.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_extra_loot_small.texture_rect = {
		591,
		820,
		64,
		64,
	}
	self.icons.rewards_extra_loot_small_frame = {}
	self.icons.rewards_extra_loot_small_frame.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_extra_loot_small_frame.texture_rect = {
		642,
		886,
		64,
		64,
	}
	self.icons.rewards_extra_loot_small_middle_gold = {}
	self.icons.rewards_extra_loot_small_middle_gold.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_extra_loot_small_middle_gold.texture_rect = {
		676,
		952,
		64,
		64,
	}
	self.icons.rewards_extra_loot_small_middle_loot = {}
	self.icons.rewards_extra_loot_small_middle_loot.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_extra_loot_small_middle_loot.texture_rect = {
		654,
		720,
		64,
		64,
	}
	self.icons.rewards_top_stats = {}
	self.icons.rewards_top_stats.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.rewards_top_stats.texture_rect = {
		372,
		628,
		112,
		96,
	}
	self.icons.saving_background = {}
	self.icons.saving_background.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.saving_background.texture_rect = {
		129,
		366,
		256,
		64,
	}
	self.icons.skill_placeholder = {}
	self.icons.skill_placeholder.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.skill_placeholder.texture_rect = {
		657,
		820,
		47,
		64,
	}
	self.icons.skill_warcry_placeholder = {}
	self.icons.skill_warcry_placeholder.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.skill_warcry_placeholder.texture_rect = {
		515,
		356,
		56,
		64,
	}
	self.icons.skl_bg_vline = {}
	self.icons.skl_bg_vline.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.skl_bg_vline.texture_rect = {
		95,
		452,
		1,
		448,
	}
	self.icons.skl_level_bg = {}
	self.icons.skl_level_bg.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.skl_level_bg.texture_rect = {
		95,
		2,
		32,
		448,
	}
	self.icons.skl_level_bg_left = {}
	self.icons.skl_level_bg_left.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.skl_level_bg_left.texture_rect = {
		2,
		2,
		91,
		448,
	}
	self.icons.skl_level_bg_right = {}
	self.icons.skl_level_bg_right.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.skl_level_bg_right.texture_rect = {
		2,
		452,
		91,
		448,
	}
	self.icons.slider_end_left = {}
	self.icons.slider_end_left.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_end_left.texture_rect = {
		707,
		786,
		50,
		32,
	}
	self.icons.slider_end_right = {}
	self.icons.slider_end_right.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_end_right.texture_rect = {
		778,
		988,
		50,
		32,
	}
	self.icons.slider_large_center = {}
	self.icons.slider_large_center.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_large_center.texture_rect = {
		1006,
		2,
		16,
		32,
	}
	self.icons.slider_large_left = {}
	self.icons.slider_large_left.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_large_left.texture_rect = {
		1006,
		36,
		16,
		32,
	}
	self.icons.slider_large_pin = {}
	self.icons.slider_large_pin.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_large_pin.texture_rect = {
		998,
		302,
		6,
		48,
	}
	self.icons.slider_large_right = {}
	self.icons.slider_large_right.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_large_right.texture_rect = {
		1006,
		70,
		16,
		32,
	}
	self.icons.slider_line_center_base = {}
	self.icons.slider_line_center_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_line_center_base.texture_rect = {
		2,
		1016,
		4,
		4,
	}
	self.icons.slider_line_left_base = {}
	self.icons.slider_line_left_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_line_left_base.texture_rect = {
		8,
		1016,
		4,
		4,
	}
	self.icons.slider_line_right_base = {}
	self.icons.slider_line_right_base.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_line_right_base.texture_rect = {
		14,
		1016,
		4,
		4,
	}
	self.icons.slider_mid_center = {}
	self.icons.slider_mid_center.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_mid_center.texture_rect = {
		364,
		998,
		10,
		20,
	}
	self.icons.slider_mid_dot = {}
	self.icons.slider_mid_dot.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_mid_dot.texture_rect = {
		195,
		432,
		10,
		10,
	}
	self.icons.slider_mid_left = {}
	self.icons.slider_mid_left.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_mid_left.texture_rect = {
		376,
		998,
		10,
		20,
	}
	self.icons.slider_mid_right = {}
	self.icons.slider_mid_right.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_mid_right.texture_rect = {
		388,
		998,
		10,
		20,
	}
	self.icons.slider_pimple = {}
	self.icons.slider_pimple.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_pimple.texture_rect = {
		116,
		1014,
		16,
		8,
	}
	self.icons.slider_pin = {}
	self.icons.slider_pin.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.slider_pin.texture_rect = {
		998,
		352,
		18,
		27,
	}
	self.icons.star_rating = {}
	self.icons.star_rating.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.star_rating.texture_rect = {
		400,
		998,
		18,
		18,
	}
	self.icons.star_rating_empty = {}
	self.icons.star_rating_empty.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.star_rating_empty.texture_rect = {
		420,
		998,
		18,
		18,
	}
	self.icons.star_rating_empty_large = {}
	self.icons.star_rating_empty_large.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.star_rating_empty_large.texture_rect = {
		230,
		998,
		24,
		24,
	}
	self.icons.star_rating_large = {}
	self.icons.star_rating_large.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.star_rating_large.texture_rect = {
		256,
		998,
		24,
		24,
	}
	self.icons.switch_bg = {}
	self.icons.switch_bg.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.switch_bg.texture_rect = {
		588,
		786,
		64,
		32,
	}
	self.icons.switch_thumb = {}
	self.icons.switch_thumb.texture = "ui/atlas/menu/raid_atlas_menu"
	self.icons.switch_thumb.texture_rect = {
		766,
		680,
		32,
		32,
	}
	self.icons.list_btn_ico_shirt = {}
	self.icons.list_btn_ico_shirt.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.list_btn_ico_shirt.texture_rect = {
		1,
		1,
		30,
		30,
	}
	self.icons.list_btn_ico_rename = {}
	self.icons.list_btn_ico_rename.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.list_btn_ico_rename.texture_rect = {
		33,
		1,
		30,
		30,
	}
	self.icons.list_btn_ico_globe = {}
	self.icons.list_btn_ico_globe.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.list_btn_ico_globe.texture_rect = {
		1,
		33,
		30,
		30,
	}
	self.icons.grid_item_locked = {}
	self.icons.grid_item_locked.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.grid_item_locked.texture_rect = {
		80,
		49,
		48,
		48,
	}
	self.icons.grid_item_fg = {}
	self.icons.grid_item_fg.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.grid_item_fg.texture_rect = {
		80,
		100,
		48,
		48,
	}
	self.icons.skill_slot_unlocked = {}
	self.icons.skill_slot_unlocked.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.skill_slot_unlocked.texture_rect = {
		0,
		64,
		32,
		32,
	}
	self.icons.list_btn_context_bg = {}
	self.icons.list_btn_context_bg.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.list_btn_context_bg.texture_rect = {
		0,
		96,
		48,
		48,
	}
	self.icons.list_btn_context_fg = {}
	self.icons.list_btn_context_fg.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.list_btn_context_fg.texture_rect = {
		0,
		144,
		48,
		48,
	}
	self.icons.list_separator_left = {}
	self.icons.list_separator_left.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.list_separator_left.texture_rect = {
		64,
		150,
		30,
		2,
	}
	self.icons.list_separator_right = {}
	self.icons.list_separator_right.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.list_separator_right.texture_rect = {
		98,
		150,
		30,
		2,
	}
	self.icons.list_separator_center = {}
	self.icons.list_separator_center.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.list_separator_center.texture_rect = {
		94,
		150,
		4,
		2,
	}
	self.icons.arrow_down = {}
	self.icons.arrow_down.texture = "ui/atlas/menu/raid_atlas_menu_2"
	self.icons.arrow_down.texture_rect = {
		0,
		192,
		25,
		25,
	}
	self.icons.menu_item_resume = {}
	self.icons.menu_item_resume.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_resume.texture_rect = {
		0,
		2,
		28,
		28,
	}
	self.icons.menu_item_restart = {}
	self.icons.menu_item_restart.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_restart.texture_rect = {
		30,
		2,
		28,
		28,
	}
	self.icons.menu_item_options = {}
	self.icons.menu_item_options.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_options.texture_rect = {
		60,
		2,
		28,
		28,
	}
	self.icons.menu_item_quit = {}
	self.icons.menu_item_quit.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_quit.texture_rect = {
		90,
		2,
		28,
		28,
	}
	self.icons.menu_item_camp = {}
	self.icons.menu_item_camp.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_camp.texture_rect = {
		120,
		2,
		28,
		28,
	}
	self.icons.menu_item_missions = {}
	self.icons.menu_item_missions.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_missions.texture_rect = {
		150,
		2,
		28,
		28,
	}
	self.icons.menu_item_weapons = {}
	self.icons.menu_item_weapons.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_weapons.texture_rect = {
		180,
		2,
		28,
		28,
	}
	self.icons.menu_item_skills = {}
	self.icons.menu_item_skills.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_skills.texture_rect = {
		210,
		2,
		28,
		28,
	}
	self.icons.menu_item_cards = {}
	self.icons.menu_item_cards.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_cards.texture_rect = {
		0,
		32,
		28,
		28,
	}
	self.icons.menu_item_characters = {}
	self.icons.menu_item_characters.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_characters.texture_rect = {
		30,
		32,
		28,
		28,
	}
	self.icons.menu_item_servers = {}
	self.icons.menu_item_servers.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_servers.texture_rect = {
		60,
		32,
		28,
		28,
	}
	self.icons.menu_item_controls = {}
	self.icons.menu_item_controls.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_controls.texture_rect = {
		90,
		32,
		28,
		28,
	}
	self.icons.menu_item_video = {}
	self.icons.menu_item_video.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_video.texture_rect = {
		120,
		32,
		28,
		28,
	}
	self.icons.menu_item_interface = {}
	self.icons.menu_item_interface.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_interface.texture_rect = {
		150,
		32,
		28,
		28,
	}
	self.icons.menu_item_sound = {}
	self.icons.menu_item_sound.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_sound.texture_rect = {
		180,
		32,
		28,
		28,
	}
	self.icons.menu_item_network = {}
	self.icons.menu_item_network.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_network.texture_rect = {
		210,
		32,
		28,
		28,
	}
	self.icons.menu_item_credits = {}
	self.icons.menu_item_credits.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_credits.texture_rect = {
		0,
		62,
		28,
		28,
	}
	self.icons.menu_item_online = {}
	self.icons.menu_item_online.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_online.texture_rect = {
		30,
		62,
		28,
		28,
	}
	self.icons.menu_item_offline = {}
	self.icons.menu_item_offline.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_offline.texture_rect = {
		60,
		62,
		28,
		28,
	}
	self.icons.menu_item_tutorial = {}
	self.icons.menu_item_tutorial.texture = "ui/atlas/menu/raid_atlas_menu_icons"
	self.icons.menu_item_tutorial.texture_rect = {
		120,
		62,
		28,
		28,
	}
	self.icons.menu_item_background = {
		texture = "ui/atlas/menu/raid_atlas_buttons",
		texture_rect = {
			0,
			0,
			480,
			64,
		},
	}
	self.icons.list_item_background_left = {
		texture = "ui/atlas/menu/raid_atlas_buttons",
		texture_rect = {
			0,
			68,
			96,
			64,
		},
	}
	self.icons.list_item_background_center = {
		texture = "ui/atlas/menu/raid_atlas_buttons",
		texture_rect = {
			96,
			68,
			96,
			64,
		},
	}
	self.icons.list_item_background_right = {
		texture = "ui/atlas/menu/raid_atlas_buttons",
		texture_rect = {
			384,
			68,
			96,
			64,
		},
	}

	local wpnskl_x = 40

	self.icons.wpn_skill_selected = {}
	self.icons.wpn_skill_selected.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_selected.texture_rect = {
		0,
		0,
		80,
		108,
	}
	self.icons.wpn_skill_blank = {}
	self.icons.wpn_skill_blank.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_blank.texture_rect = {
		wpnskl_x * 2,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_blank_part = deep_clone(self.icons.wpn_skill_blank)
	self.icons.wpn_skill_blank_part.texture_rect[2] = 54
	self.icons.wpn_skill_locked = {}
	self.icons.wpn_skill_locked.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_locked.texture_rect = {
		wpnskl_x * 3,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_locked_part = deep_clone(self.icons.wpn_skill_locked)
	self.icons.wpn_skill_locked_part.texture_rect[2] = 54
	self.icons.wpn_skill_unknown = {}
	self.icons.wpn_skill_unknown.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_unknown.texture_rect = {
		wpnskl_x * 4,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_unknown_part = deep_clone(self.icons.wpn_skill_unknown)
	self.icons.wpn_skill_unknown_part.texture_rect[2] = 54
	self.icons.wpn_skill_mag_size = {}
	self.icons.wpn_skill_mag_size.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_mag_size.texture_rect = {
		wpnskl_x * 5,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_mag_size_part = deep_clone(self.icons.wpn_skill_mag_size)
	self.icons.wpn_skill_mag_size_part.texture_rect[2] = 54
	self.icons.wpn_skill_accuracy = {}
	self.icons.wpn_skill_accuracy.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_accuracy.texture_rect = {
		wpnskl_x * 6,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_accuracy_part = deep_clone(self.icons.wpn_skill_accuracy)
	self.icons.wpn_skill_accuracy_part.texture_rect[2] = 54
	self.icons.wpn_skill_damage = {}
	self.icons.wpn_skill_damage.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_damage.texture_rect = {
		wpnskl_x * 7,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_damage_part = deep_clone(self.icons.wpn_skill_damage)
	self.icons.wpn_skill_damage_part.texture_rect[2] = 54
	self.icons.wpn_skill_stability = {}
	self.icons.wpn_skill_stability.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_stability.texture_rect = {
		wpnskl_x * 8,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_stability_part = deep_clone(self.icons.wpn_skill_stability)
	self.icons.wpn_skill_stability_part.texture_rect[2] = 54
	self.icons.wpn_skill_gold = {}
	self.icons.wpn_skill_gold.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_gold.texture_rect = {
		wpnskl_x * 9,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_gold_part = deep_clone(self.icons.wpn_skill_gold)
	self.icons.wpn_skill_gold_part.texture_rect[2] = 54
	self.icons.wpn_skill_spread = {}
	self.icons.wpn_skill_spread.texture = "ui/atlas/menu/raid_atlas_wpn_upg"
	self.icons.wpn_skill_spread.texture_rect = {
		wpnskl_x * 10,
		0,
		40,
		54,
	}
	self.icons.wpn_skill_spread_part = deep_clone(self.icons.wpn_skill_spread)
	self.icons.wpn_skill_spread_part.texture_rect[2] = 54
	self.icons.difficulty_1 = {}
	self.icons.difficulty_1.texture = "ui/atlas/raid_atlas_missions"
	self.icons.difficulty_1.texture_rect = {
		2,
		2,
		76,
		64,
	}
	self.icons.difficulty_2 = {}
	self.icons.difficulty_2.texture = "ui/atlas/raid_atlas_missions"
	self.icons.difficulty_2.texture_rect = {
		80,
		2,
		76,
		64,
	}
	self.icons.difficulty_3 = {}
	self.icons.difficulty_3.texture = "ui/atlas/raid_atlas_missions"
	self.icons.difficulty_3.texture_rect = {
		158,
		2,
		76,
		64,
	}
	self.icons.difficulty_4 = {}
	self.icons.difficulty_4.texture = "ui/atlas/raid_atlas_missions"
	self.icons.difficulty_4.texture_rect = {
		236,
		2,
		76,
		64,
	}
	self.icons.difficulty_5 = {}
	self.icons.difficulty_5.texture = "ui/atlas/raid_atlas_missions"
	self.icons.difficulty_5.texture_rect = {
		314,
		2,
		76,
		64,
	}
	self.icons.dog_tags_ops = {}
	self.icons.dog_tags_ops.texture = "ui/atlas/raid_atlas_missions"
	self.icons.dog_tags_ops.texture_rect = {
		392,
		2,
		76,
		64,
	}
	self.icons.extra_loot = {}
	self.icons.extra_loot.texture = "ui/atlas/raid_atlas_missions"
	self.icons.extra_loot.texture_rect = {
		2,
		68,
		76,
		64,
	}
	self.icons.mission_raid_railyard_menu = {}
	self.icons.mission_raid_railyard_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.mission_raid_railyard_menu.texture_rect = {
		2,
		200,
		56,
		56,
	}
	self.icons.missions_art_storage = {}
	self.icons.missions_art_storage.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_art_storage.texture_rect = {
		2,
		258,
		56,
		56,
	}
	self.icons.missions_bunkers = {}
	self.icons.missions_bunkers.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_bunkers.texture_rect = {
		2,
		316,
		56,
		56,
	}
	self.icons.missions_camp = {}
	self.icons.missions_camp.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_camp.texture_rect = {
		2,
		374,
		56,
		56,
	}
	self.icons.missions_menu_consumable_forest = {}
	self.icons.missions_menu_consumable_forest.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_menu_consumable_forest.texture_rect = {
		2,
		432,
		56,
		56,
	}
	self.icons.missions_consumable_mission = {}
	self.icons.missions_consumable_mission.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_consumable_mission.texture_rect = {
		60,
		200,
		56,
		56,
	}
	self.icons.missions_convoy = {}
	self.icons.missions_convoy.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_convoy.texture_rect = {
		80,
		68,
		56,
		56,
	}
	self.icons.missions_hunters = {}
	self.icons.missions_hunters.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_hunters.texture_rect = {
		80,
		126,
		56,
		56,
	}
	self.icons.missions_mini_raid_1_menu = {}
	self.icons.missions_mini_raid_1_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_mini_raid_1_menu.texture_rect = {
		60,
		258,
		56,
		56,
	}
	self.icons.missions_mini_raid_2_menu = {}
	self.icons.missions_mini_raid_2_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_mini_raid_2_menu.texture_rect = {
		60,
		316,
		56,
		56,
	}
	self.icons.missions_mini_raid_3_menu = {}
	self.icons.missions_mini_raid_3_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_mini_raid_3_menu.texture_rect = {
		60,
		374,
		56,
		56,
	}
	self.icons.missions_mini_raids_menu = {}
	self.icons.missions_mini_raids_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_mini_raids_menu.texture_rect = {
		60,
		432,
		56,
		56,
	}
	self.icons.missions_operation_clear_skies_menu = {}
	self.icons.missions_operation_clear_skies_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_operation_clear_skies_menu.texture_rect = {
		118,
		184,
		56,
		56,
	}
	self.icons.missions_operation_clear_skies_menu_1 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_missions_op_clear_skies",
		texture_rect = {
			3,
			3,
			50,
			50,
		},
	}
	self.icons.missions_operation_clear_skies_menu_2 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_missions_op_clear_skies",
		texture_rect = {
			59,
			3,
			50,
			50,
		},
	}
	self.icons.missions_operation_clear_skies_menu_3 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_missions_op_clear_skies",
		texture_rect = {
			115,
			3,
			50,
			50,
		},
	}
	self.icons.missions_operation_clear_skies_menu_4 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_missions_op_clear_skies",
		texture_rect = {
			171,
			3,
			50,
			50,
		},
	}
	self.icons.missions_operation_clear_skies_menu_5 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_missions_op_clear_skies",
		texture_rect = {
			3,
			59,
			50,
			50,
		},
	}
	self.icons.missions_operation_clear_skies_menu_6 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_missions_op_clear_skies",
		texture_rect = {
			59,
			59,
			50,
			50,
		},
	}
	self.icons.missions_operation_empty_slot_menu = {}
	self.icons.missions_operation_empty_slot_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_operation_empty_slot_menu.texture_rect = {
		138,
		68,
		56,
		56,
	}
	self.icons.missions_operation_rhinegold_menu = {}
	self.icons.missions_operation_rhinegold_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_operation_rhinegold_menu.texture_rect = {
		138,
		126,
		56,
		56,
	}
	self.icons.missions_operation_rhinegold_menu_1 = {
		texture = "ui/missions/operation_rhinegold/raid_atlas_missions_op_rhine_gold",
		texture_rect = {
			3,
			3,
			50,
			50,
		},
	}
	self.icons.missions_operation_rhinegold_menu_2 = {
		texture = "ui/missions/operation_rhinegold/raid_atlas_missions_op_rhine_gold",
		texture_rect = {
			59,
			3,
			50,
			50,
		},
	}
	self.icons.missions_operation_rhinegold_menu_3 = {
		texture = "ui/missions/operation_rhinegold/raid_atlas_missions_op_rhine_gold",
		texture_rect = {
			115,
			3,
			50,
			50,
		},
	}
	self.icons.missions_operation_rhinegold_menu_4 = {
		texture = "ui/missions/operation_rhinegold/raid_atlas_missions_op_rhine_gold",
		texture_rect = {
			171,
			3,
			50,
			50,
		},
	}
	self.icons.missions_operations_category_menu = {}
	self.icons.missions_operations_category_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_operations_category_menu.texture_rect = {
		118,
		242,
		56,
		56,
	}
	self.icons.missions_raid_bank_menu = {}
	self.icons.missions_raid_bank_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_raid_bank_menu.texture_rect = {
		118,
		300,
		56,
		56,
	}
	self.icons.missions_raid_bridge_menu = {}
	self.icons.missions_raid_bridge_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_raid_bridge_menu.texture_rect = {
		118,
		358,
		56,
		56,
	}
	self.icons.missions_raid_castle_menu = {}
	self.icons.missions_raid_castle_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_raid_castle_menu.texture_rect = {
		118,
		416,
		56,
		56,
	}
	self.icons.missions_raid_flaktower_menu = {}
	self.icons.missions_raid_flaktower_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_raid_flaktower_menu.texture_rect = {
		196,
		68,
		56,
		56,
	}
	self.icons.missions_raid_radio_menu = {}
	self.icons.missions_raid_radio_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_raid_radio_menu.texture_rect = {
		254,
		68,
		56,
		56,
	}
	self.icons.missions_raids_category_menu = {}
	self.icons.missions_raids_category_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_raids_category_menu.texture_rect = {
		312,
		68,
		56,
		56,
	}
	self.icons.missions_silo = {}
	self.icons.missions_silo.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_silo.texture_rect = {
		370,
		68,
		56,
		56,
	}
	self.icons.missions_spies = {}
	self.icons.missions_spies.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_spies.texture_rect = {
		428,
		68,
		56,
		56,
	}
	self.icons.missions_tank_depot = {}
	self.icons.missions_tank_depot.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_tank_depot.texture_rect = {
		196,
		126,
		56,
		56,
	}
	self.icons.missions_kelly = {}
	self.icons.missions_kelly.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_kelly.texture_rect = {
		312,
		126,
		56,
		56,
	}
	self.icons.missions_fury_railway = {}
	self.icons.missions_fury_railway.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_fury_railway.texture_rect = {
		368,
		126,
		56,
		56,
	}
	self.icons.missions_forest_bunker = {}
	self.icons.missions_forest_bunker.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_forest_bunker.texture_rect = {
		424,
		126,
		56,
		56,
	}
	self.icons.missions_raid_bounty_menu = {}
	self.icons.missions_raid_bounty_menu.texture = "ui/updates/upd_cow/job_icons"
	self.icons.missions_raid_bounty_menu.texture_rect = {
		384,
		0,
		56,
		56,
	}
	self.icons.missions_operation_bounty_menu = {}
	self.icons.missions_operation_bounty_menu.texture = "ui/updates/upd_cow/job_icons"
	self.icons.missions_operation_bounty_menu.texture_rect = {
		448,
		0,
		56,
		56,
	}
	self.icons.missions_tutorial = {}
	self.icons.missions_tutorial.texture = "ui/atlas/raid_atlas_missions"
	self.icons.missions_tutorial.texture_rect = {
		254,
		126,
		56,
		56,
	}
	self.icons.server_menu = {}
	self.icons.server_menu.texture = "ui/atlas/raid_atlas_missions"
	self.icons.server_menu.texture_rect = {
		2,
		134,
		76,
		64,
	}
	self.icons.rwd_card_pack = {}
	self.icons.rwd_card_pack.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_card_pack.texture_rect = {
		878,
		2,
		112,
		96,
	}
	self.icons.rwd_gold_bar = {}
	self.icons.rwd_gold_bar.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_gold_bar.texture_rect = {
		324,
		1754,
		112,
		96,
	}
	self.icons.rwd_gold_bars = {}
	self.icons.rwd_gold_bars.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_gold_bars.texture_rect = {
		878,
		100,
		112,
		96,
	}
	self.icons.rwd_gold_crate = {}
	self.icons.rwd_gold_crate.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_gold_crate.texture_rect = {
		324,
		1852,
		112,
		96,
	}
	self.icons.rwd_grenade = {}
	self.icons.rwd_grenade.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_grenade.texture_rect = {
		324,
		1950,
		112,
		96,
	}
	self.icons.rwd_grenade_large = {}
	self.icons.rwd_grenade_large.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_grenade_large.texture_rect = {
		2,
		2,
		436,
		436,
	}
	self.icons.rwd_lower_body = {}
	self.icons.rwd_lower_body.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_lower_body.texture_rect = {
		878,
		198,
		112,
		96,
	}
	self.icons.rwd_lower_body_large = {}
	self.icons.rwd_lower_body_large.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_lower_body_large.texture_rect = {
		2,
		440,
		436,
		436,
	}
	self.icons.rwd_melee = {}
	self.icons.rwd_melee.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_melee.texture_rect = {
		878,
		296,
		112,
		96,
	}
	self.icons.rwd_melee_large = {}
	self.icons.rwd_melee_large.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_melee_large.texture_rect = {
		440,
		2,
		436,
		436,
	}
	self.icons.rwd_stats_bg = {}
	self.icons.rwd_stats_bg.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_stats_bg.texture_rect = {
		440,
		1202,
		578,
		167,
	}
	self.icons.rwd_upper_body = {}
	self.icons.rwd_upper_body.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_upper_body.texture_rect = {
		878,
		394,
		112,
		96,
	}
	self.icons.rwd_upper_body_large = {}
	self.icons.rwd_upper_body_large.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_upper_body_large.texture_rect = {
		2,
		878,
		436,
		436,
	}
	self.icons.rwd_weapon = {}
	self.icons.rwd_weapon.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_weapon.texture_rect = {
		878,
		492,
		112,
		96,
	}
	self.icons.rwd_weapon_large = {}
	self.icons.rwd_weapon_large.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_weapon_large.texture_rect = {
		440,
		440,
		436,
		436,
	}
	self.icons.rwd_xp = {}
	self.icons.rwd_xp.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_xp.texture_rect = {
		878,
		590,
		112,
		96,
	}
	self.icons.rwd_xp_large = {}
	self.icons.rwd_xp_large.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.rwd_xp_large.texture_rect = {
		2,
		1316,
		436,
		436,
	}
	self.icons.xp_double_unlock = {}
	self.icons.xp_double_unlock.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.xp_double_unlock.texture_rect = {
		440,
		1371,
		316,
		353,
	}
	self.icons.xp_failure = {}
	self.icons.xp_failure.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.xp_failure.texture_rect = {
		440,
		878,
		521,
		322,
	}
	self.icons.xp_skill_set = {}
	self.icons.xp_skill_set.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.xp_skill_set.texture_rect = {
		758,
		1371,
		249,
		324,
	}
	self.icons.xp_weapon = {}
	self.icons.xp_weapon.texture = "ui/atlas/menu/raid_atlas_reward"
	self.icons.xp_weapon.texture_rect = {
		2,
		1754,
		320,
		286,
	}
	self.icons.bonus_bg_flag = {}
	self.icons.bonus_bg_flag.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_bg_flag.texture_rect = {
		2,
		2,
		256,
		480,
	}
	self.icons.bonus_bg_flag_fail = {}
	self.icons.bonus_bg_flag_fail.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_bg_flag_fail.texture_rect = {
		2,
		484,
		256,
		480,
	}
	self.icons.bonus_highest_accu = {}
	self.icons.bonus_highest_accu.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_highest_accu.texture_rect = {
		490,
		2,
		160,
		160,
	}
	self.icons.bonus_highest_accu_small = {}
	self.icons.bonus_highest_accu_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_highest_accu_small.texture_rect = {
		422,
		232,
		64,
		64,
	}
	self.icons.bonus_least_bleedout = {}
	self.icons.bonus_least_bleedout.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_least_bleedout.texture_rect = {
		652,
		2,
		160,
		160,
	}
	self.icons.bonus_least_bleedout_small = {}
	self.icons.bonus_least_bleedout_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_least_bleedout_small.texture_rect = {
		422,
		298,
		64,
		64,
	}
	self.icons.bonus_least_health_lost = {}
	self.icons.bonus_least_health_lost.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_least_health_lost.texture_rect = {
		814,
		2,
		160,
		160,
	}
	self.icons.bonus_least_health_lost_small = {}
	self.icons.bonus_least_health_lost_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_least_health_lost_small.texture_rect = {
		422,
		364,
		64,
		64,
	}
	self.icons.bonus_most_ammo_looted = {}
	self.icons.bonus_most_ammo_looted.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_ammo_looted.texture_rect = {
		490,
		164,
		160,
		160,
	}
	self.icons.bonus_most_ammo_looted_small = {}
	self.icons.bonus_most_ammo_looted_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_ammo_looted_small.texture_rect = {
		422,
		430,
		64,
		64,
	}
	self.icons.bonus_most_bleedouts = {}
	self.icons.bonus_most_bleedouts.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_bleedouts.texture_rect = {
		260,
		232,
		160,
		160,
	}
	self.icons.bonus_most_bleedouts_small = {}
	self.icons.bonus_most_bleedouts_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_bleedouts_small.texture_rect = {
		260,
		634,
		64,
		64,
	}
	self.icons.bonus_most_headshots = {}
	self.icons.bonus_most_headshots.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_headshots.texture_rect = {
		652,
		164,
		160,
		160,
	}
	self.icons.bonus_most_headshots_small = {}
	self.icons.bonus_most_headshots_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_headshots_small.texture_rect = {
		260,
		700,
		64,
		64,
	}
	self.icons.bonus_most_health_looted = {}
	self.icons.bonus_most_health_looted.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_health_looted.texture_rect = {
		814,
		164,
		160,
		160,
	}
	self.icons.bonus_most_health_looted_small = {}
	self.icons.bonus_most_health_looted_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_health_looted_small.texture_rect = {
		260,
		766,
		64,
		64,
	}
	self.icons.bonus_most_kills = {}
	self.icons.bonus_most_kills.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_kills.texture_rect = {
		488,
		326,
		160,
		160,
	}
	self.icons.bonus_most_kills_small = {}
	self.icons.bonus_most_kills_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_kills_small.texture_rect = {
		260,
		832,
		64,
		64,
	}
	self.icons.bonus_most_revives = {}
	self.icons.bonus_most_revives.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_revives.texture_rect = {
		260,
		394,
		160,
		160,
	}
	self.icons.bonus_most_revives_small = {}
	self.icons.bonus_most_revives_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_revives_small.texture_rect = {
		260,
		898,
		64,
		64,
	}
	self.icons.bonus_most_specials_killed = {}
	self.icons.bonus_most_specials_killed.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_specials_killed.texture_rect = {
		650,
		326,
		160,
		160,
	}
	self.icons.bonus_most_specials_killed_small = {}
	self.icons.bonus_most_specials_killed_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_specials_killed_small.texture_rect = {
		326,
		634,
		64,
		64,
	}
	self.icons.bonus_most_warcries_used = {}
	self.icons.bonus_most_warcries_used.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_warcries_used.texture_rect = {
		812,
		326,
		160,
		160,
	}
	self.icons.bonus_most_warcries_used_small = {}
	self.icons.bonus_most_warcries_used_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.bonus_most_warcries_used_small.texture_rect = {
		338,
		556,
		64,
		64,
	}
	self.icons.reward_loot = {}
	self.icons.reward_loot.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.reward_loot.texture_rect = {
		260,
		2,
		228,
		228,
	}
	self.icons.reward_loot_small = {}
	self.icons.reward_loot_small.texture = "ui/atlas/menu/raid_atlas_bonus_loot"
	self.icons.reward_loot_small.texture_rect = {
		260,
		556,
		76,
		76,
	}
end

function GuiTweakData:_setup_reward_icons()
	self.icons.gold_bar_single = {}
	self.icons.gold_bar_single.texture = "ui/icons/rewards/gold_hud"
	self.icons.gold_bar_single.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.gold_bar_3 = {}
	self.icons.gold_bar_3.texture = "ui/icons/rewards/gold_3x_hud"
	self.icons.gold_bar_3.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.gold_bar_box = {}
	self.icons.gold_bar_box.texture = "ui/icons/rewards/gold_box_hud"
	self.icons.gold_bar_box.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.reward_pile_gold_1 = {}
	self.icons.reward_pile_gold_1.texture = "ui/icons/rewards/reward_pile_gold_1"
	self.icons.reward_pile_gold_1.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.reward_pile_gold_2 = {}
	self.icons.reward_pile_gold_2.texture = "ui/icons/rewards/reward_pile_gold_2"
	self.icons.reward_pile_gold_2.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.reward_pile_gold_3 = {}
	self.icons.reward_pile_gold_3.texture = "ui/icons/rewards/reward_pile_gold_3"
	self.icons.reward_pile_gold_3.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.reward_pile_gold_4 = {}
	self.icons.reward_pile_gold_4.texture = "ui/icons/rewards/reward_pile_gold_4"
	self.icons.reward_pile_gold_4.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.reward_pile_gold_5 = {}
	self.icons.reward_pile_gold_5.texture = "ui/icons/rewards/reward_pile_gold_5"
	self.icons.reward_pile_gold_5.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.loot_crate_default = {}
	self.icons.loot_crate_default.texture = "ui/icons/rewards/reward_crate_default_hud"
	self.icons.loot_crate_default.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.loot_crate_bronze = {}
	self.icons.loot_crate_bronze.texture = "ui/icons/rewards/reward_crate_bronze_hud"
	self.icons.loot_crate_bronze.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.loot_crate_silver = {}
	self.icons.loot_crate_silver.texture = "ui/icons/rewards/reward_crate_silver_hud"
	self.icons.loot_crate_silver.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.loot_crate_gold = {}
	self.icons.loot_crate_gold.texture = "ui/icons/rewards/reward_crate_gold_hud"
	self.icons.loot_crate_gold.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.loot_greed_items = {}
	self.icons.loot_greed_items.texture = "ui/icons/rewards/gold_loot_hud"
	self.icons.loot_greed_items.texture_rect = {
		0,
		0,
		1024,
		512,
	}
	self.icons.outlaw_raid_hud_item = {}
	self.icons.outlaw_raid_hud_item.texture = "ui/icons/rewards/outlaw_raid_hud"
	self.icons.outlaw_raid_hud_item.texture_rect = {
		0,
		0,
		512,
		512,
	}
end

function GuiTweakData:_setup_radial_icons()
	self.icons.interact_lockpick_tool = {}
	self.icons.interact_lockpick_tool.texture = "ui/icons/interact_lockpick_tool_hud"
	self.icons.interact_lockpick_tool.texture_rect = {
		0,
		0,
		256,
		256,
	}
	self.icons.interact_generic_bg = {}
	self.icons.interact_generic_bg.texture = "ui/icons/radial/interact_generic_circle_bg_hud"
	self.icons.interact_generic_bg.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.interact_lockpick_circles = {}
	self.icons.interact_lockpick_circles[1] = {}
	self.icons.interact_lockpick_circles[1].texture = "ui/icons/radial/interact_lockpick_circle_1_hud"
	self.icons.interact_lockpick_circles[1].texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.interact_lockpick_circles[2] = {}
	self.icons.interact_lockpick_circles[2].texture = "ui/icons/radial/interact_lockpick_circle_2_hud"
	self.icons.interact_lockpick_circles[2].texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.interact_lockpick_circles[3] = {}
	self.icons.interact_lockpick_circles[3].texture = "ui/icons/radial/interact_lockpick_circle_3_hud"
	self.icons.interact_lockpick_circles[3].texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.interact_lockpick_circles[4] = {}
	self.icons.interact_lockpick_circles[4].texture = "ui/icons/radial/interact_lockpick_circle_4_hud"
	self.icons.interact_lockpick_circles[4].texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.interact_fuse_thread = {}
	self.icons.interact_fuse_thread.texture = "ui/icons/radial/interact_fuse_thread_hud"
	self.icons.interact_fuse_thread.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.interact_knife_tool = {}
	self.icons.interact_knife_tool.texture = "ui/icons/interact_knife_tool_hud"
	self.icons.interact_knife_tool.texture_rect = {
		0,
		0,
		256,
		256,
	}
	self.icons.interact_rewire_bg = {}
	self.icons.interact_rewire_bg.texture = "ui/icons/radial/interact_rewire_bg_hud"
	self.icons.interact_rewire_bg.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.interact_rewire_fg = {}
	self.icons.interact_rewire_fg.texture = "ui/icons/radial/interact_rewire_fg_hud"
	self.icons.interact_rewire_fg.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.interact_rewire_node_line = {}
	self.icons.interact_rewire_node_line.texture = "ui/icons/radial/interact_rewire_nodes_hud"
	self.icons.interact_rewire_node_line.texture_rect = {
		256,
		0,
		128,
		128,
	}
	self.icons.interact_rewire_node_line_horizontal = {}
	self.icons.interact_rewire_node_line_horizontal.texture = "ui/icons/radial/interact_rewire_nodes_hud"
	self.icons.interact_rewire_node_line_horizontal.texture_rect = {
		384,
		0,
		128,
		128,
	}
	self.icons.interact_rewire_node_bend_down_right = {}
	self.icons.interact_rewire_node_bend_down_right.texture = "ui/icons/radial/interact_rewire_nodes_hud"
	self.icons.interact_rewire_node_bend_down_right.texture_rect = {
		0,
		128,
		128,
		128,
	}
	self.icons.interact_rewire_node_bend_down_left = {}
	self.icons.interact_rewire_node_bend_down_left.texture = "ui/icons/radial/interact_rewire_nodes_hud"
	self.icons.interact_rewire_node_bend_down_left.texture_rect = {
		128,
		128,
		128,
		128,
	}
	self.icons.interact_rewire_node_bend_up_right = {}
	self.icons.interact_rewire_node_bend_up_right.texture = "ui/icons/radial/interact_rewire_nodes_hud"
	self.icons.interact_rewire_node_bend_up_right.texture_rect = {
		0,
		256,
		128,
		128,
	}
	self.icons.interact_rewire_node_bend_up_left = {}
	self.icons.interact_rewire_node_bend_up_left.texture = "ui/icons/radial/interact_rewire_nodes_hud"
	self.icons.interact_rewire_node_bend_up_left.texture_rect = {
		128,
		256,
		128,
		128,
	}
	self.icons.interact_rewire_node_dead = {}
	self.icons.interact_rewire_node_dead.texture = "ui/icons/radial/interact_rewire_nodes_hud"
	self.icons.interact_rewire_node_dead.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.interact_rewire_node_trap = {}
	self.icons.interact_rewire_node_trap.texture = "ui/icons/radial/interact_rewire_nodes_hud"
	self.icons.interact_rewire_node_trap.texture_rect = {
		128,
		0,
		128,
		128,
	}
	self.icons.special_int_cc_roulette_wheel = {}
	self.icons.special_int_cc_roulette_wheel.texture = "ui/icons/radial/interact_roulette_circle_hud"
	self.icons.special_int_cc_roulette_wheel.texture_rect = {
		0,
		0,
		512,
		512,
	}
	self.icons.special_int_cc_roulette_pointer = {}
	self.icons.special_int_cc_roulette_pointer.texture = "ui/icons/radial/interact_roulette_pointer_hud"
	self.icons.special_int_cc_roulette_pointer.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.special_int_cc_roulette_bullet = {}
	self.icons.special_int_cc_roulette_bullet.texture = "ui/icons/radial/interact_roulette_bullet_hud"
	self.icons.special_int_cc_roulette_bullet.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.special_int_cc_roulette_timer = {}
	self.icons.special_int_cc_roulette_timer.texture = "ui/icons/radial/interact_roulette_timer_hud"
	self.icons.special_int_cc_roulette_timer.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.teammate_circle_fill_small = {}
	self.icons.teammate_circle_fill_small.texture = "ui/icons/radial/meters_ai_downed_and_objective_countdown_fill_hud"
	self.icons.teammate_circle_fill_small.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.teammate_circle_fill_medium = {}
	self.icons.teammate_circle_fill_medium.texture = "ui/icons/radial/meters_teammate_downed_fill_hud"
	self.icons.teammate_circle_fill_medium.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.objective_timer_watch = {}
	self.icons.objective_timer_watch.texture = "ui/icons/radial/objective_timer_watch"
	self.icons.objective_timer_watch.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.teammate_circle_fill_large = {}
	self.icons.teammate_circle_fill_large.texture = "ui/icons/radial/meters_downed_fill_hud"
	self.icons.teammate_circle_fill_large.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.teammate_interact_fill_large = {}
	self.icons.teammate_interact_fill_large.texture = "ui/icons/radial/player_panel_interaction_teammate_fill_hud"
	self.icons.teammate_interact_fill_large.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.objective_progress_fill = {}
	self.icons.objective_progress_fill.texture = "ui/icons/radial/meters_objective_progress_fill_hud"
	self.icons.objective_progress_fill.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.stamina_bar_fill = {}
	self.icons.stamina_bar_fill.texture = "ui/icons/radial/meters_stamina_fill_hud"
	self.icons.stamina_bar_fill.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.warcry_bar_fill = {}
	self.icons.warcry_bar_fill.texture = "ui/icons/radial/meters_warccry_fill_hud"
	self.icons.warcry_bar_fill.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.comm_wheel_circle = {}
	self.icons.comm_wheel_circle.texture = "ui/icons/radial/comm_wheel_circle_hud"
	self.icons.comm_wheel_circle.texture_rect = {
		0,
		0,
		256,
		256,
	}
	self.icons.stealth_eye_fill = {}
	self.icons.stealth_eye_fill.texture = "ui/icons/radial/stealth_eye_in_hud"
	self.icons.stealth_eye_fill.texture_rect = {
		0,
		0,
		32,
		32,
	}
	self.icons.skill_progress_circle_256px = {}
	self.icons.skill_progress_circle_256px.texture = "ui/icons/radial/skill_progress_circle_256px"
	self.icons.skill_progress_circle_256px.texture_rect = {
		0,
		0,
		256,
		256,
	}
	self.icons.rewards_extra_loot_fill = {}
	self.icons.rewards_extra_loot_fill.texture = "ui/icons/radial/rewards_extra_loot_fill"
	self.icons.rewards_extra_loot_fill.texture_rect = {
		8,
		16,
		112,
		96,
	}
end

function GuiTweakData:_setup_hud_icons()
	self.icons.aa_gun_bg = {}
	self.icons.aa_gun_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.aa_gun_bg.texture_rect = {
		387,
		1355,
		384,
		54,
	}
	self.icons.aa_gun_flak = {}
	self.icons.aa_gun_flak.texture = "ui/atlas/raid_atlas_hud"
	self.icons.aa_gun_flak.texture_rect = {
		731,
		1281,
		154,
		28,
	}
	self.icons.backgrounds_chat_bg = {}
	self.icons.backgrounds_chat_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_chat_bg.texture_rect = {
		1,
		1165,
		384,
		432,
	}
	self.icons.backgrounds_detected_msg = {}
	self.icons.backgrounds_detected_msg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_detected_msg.texture_rect = {
		387,
		1411,
		380,
		68,
	}
	self.icons.backgrounds_equipment_panel_msg = {}
	self.icons.backgrounds_equipment_panel_msg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_equipment_panel_msg.texture_rect = {
		387,
		1481,
		380,
		68,
	}
	self.icons.backgrounds_health_bg = {}
	self.icons.backgrounds_health_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_health_bg.texture_rect = {
		387,
		1255,
		288,
		10,
	}
	self.icons.backgrounds_machine_gun_empty = {}
	self.icons.backgrounds_machine_gun_empty.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_machine_gun_empty.texture_rect = {
		1,
		1599,
		380,
		50,
	}
	self.icons.backgrounds_toast_mission_bg = {}
	self.icons.backgrounds_toast_mission_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_toast_mission_bg.texture_rect = {
		1,
		1069,
		660,
		94,
	}
	self.icons.backgrounds_toast_mission_bg_002 = {}
	self.icons.backgrounds_toast_mission_bg_002.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_toast_mission_bg_002.texture_rect = {
		1,
		963,
		728,
		104,
	}
	self.icons.backgrounds_vehicle_bags_weight = {}
	self.icons.backgrounds_vehicle_bags_weight.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_vehicle_bags_weight.texture_rect = {
		863,
		1419,
		10,
		84,
	}
	self.icons.backgrounds_vehicle_damage_bg = {}
	self.icons.backgrounds_vehicle_damage_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_vehicle_damage_bg.texture_rect = {
		663,
		1135,
		64,
		10,
	}
	self.icons.backgrounds_warcry_msg = {}
	self.icons.backgrounds_warcry_msg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_warcry_msg.texture_rect = {
		387,
		1551,
		380,
		68,
	}
	self.icons.backgrounds_weapon_counter_bg = {}
	self.icons.backgrounds_weapon_counter_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.backgrounds_weapon_counter_bg.texture_rect = {
		961,
		1045,
		54,
		34,
	}
	self.icons.bullet_active = {}
	self.icons.bullet_active.texture = "ui/atlas/raid_atlas_hud"
	self.icons.bullet_active.texture_rect = {
		713,
		1227,
		16,
		16,
	}
	self.icons.bullet_empty = {}
	self.icons.bullet_empty.texture = "ui/atlas/raid_atlas_hud"
	self.icons.bullet_empty.texture_rect = {
		713,
		1245,
		16,
		16,
	}
	self.icons.car_slot_empty = {}
	self.icons.car_slot_empty.texture = "ui/atlas/raid_atlas_hud"
	self.icons.car_slot_empty.texture_rect = {
		387,
		1165,
		32,
		32,
	}
	self.icons.carry_alive = {}
	self.icons.carry_alive.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_alive.texture_rect = {
		72,
		72,
		72,
		72,
	}
	self.icons.carry_bag = {}
	self.icons.carry_bag.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_bag.texture_rect = {
		0,
		0,
		72,
		72,
	}
	self.icons.carry_corpse = {}
	self.icons.carry_corpse.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_corpse.texture_rect = {
		0,
		72,
		72,
		72,
	}
	self.icons.carry_flak_shell = {}
	self.icons.carry_flak_shell.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_flak_shell.texture_rect = {
		144,
		0,
		72,
		72,
	}
	self.icons.carry_gold = {}
	self.icons.carry_gold.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_gold.texture_rect = {
		216,
		0,
		72,
		72,
	}
	self.icons.carry_painting = {}
	self.icons.carry_painting.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_painting.texture_rect = {
		288,
		0,
		72,
		72,
	}
	self.icons.carry_painting_cheap = {}
	self.icons.carry_painting_cheap.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_painting_cheap.texture_rect = {
		72,
		0,
		72,
		72,
	}
	self.icons.carry_artefact = {}
	self.icons.carry_artefact.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_artefact.texture_rect = {
		144,
		72,
		72,
		72,
	}
	self.icons.carry_planks = {}
	self.icons.carry_planks.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_planks.texture_rect = {
		216,
		72,
		72,
		72,
	}
	self.icons.carry_explosive = {}
	self.icons.carry_explosive.texture = "ui/atlas/raid_atlas_carry"
	self.icons.carry_explosive.texture_rect = {
		288,
		72,
		72,
		72,
	}
	self.icons.carry_weight_indicator_bg = {}
	self.icons.carry_weight_indicator_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.carry_weight_indicator_bg.texture_rect = {
		780,
		1965,
		80,
		80,
	}
	self.icons.carry_weight_indicator_fill = {}
	self.icons.carry_weight_indicator_fill.texture = "ui/icons/radial/meters_carry_weight_fill_hud"
	self.icons.carry_weight_indicator_fill.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.chat_input_rounded_rect = {}
	self.icons.chat_input_rounded_rect.texture = "ui/atlas/raid_atlas_hud"
	self.icons.chat_input_rounded_rect.texture_rect = {
		387,
		1201,
		324,
		52,
	}
	self.icons.comm_wheel_assistance = {}
	self.icons.comm_wheel_assistance.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_assistance.texture_rect = {
		961,
		1081,
		52,
		52,
	}
	self.icons.comm_wheel_bg = {}
	self.icons.comm_wheel_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_bg.texture_rect = {
		1,
		1,
		960,
		960,
	}
	self.icons.comm_wheel_enemy = {}
	self.icons.comm_wheel_enemy.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_enemy.texture_rect = {
		961,
		1135,
		52,
		52,
	}
	self.icons.comm_wheel_follow_me = {}
	self.icons.comm_wheel_follow_me.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_follow_me.texture_rect = {
		961,
		1189,
		52,
		52,
	}
	self.icons.comm_wheel_found_it = {}
	self.icons.comm_wheel_found_it.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_found_it.texture_rect = {
		961,
		1243,
		52,
		52,
	}
	self.icons.comm_wheel_no = {}
	self.icons.comm_wheel_no.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_no.texture_rect = {
		663,
		1147,
		52,
		52,
	}
	self.icons.comm_wheel_not_here = {}
	self.icons.comm_wheel_not_here.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_not_here.texture_rect = {
		677,
		1263,
		52,
		52,
	}
	self.icons.comm_wheel_triangle = {}
	self.icons.comm_wheel_triangle.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_triangle.texture_rect = {
		961,
		1297,
		52,
		52,
	}
	self.icons.comm_wheel_wait = {}
	self.icons.comm_wheel_wait.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_wait.texture_rect = {
		961,
		1351,
		52,
		52,
	}
	self.icons.comm_wheel_yes = {}
	self.icons.comm_wheel_yes.texture = "ui/atlas/raid_atlas_hud"
	self.icons.comm_wheel_yes.texture_rect = {
		949,
		1479,
		52,
		52,
	}
	self.icons.coom_wheel_line = {}
	self.icons.coom_wheel_line.texture = "ui/atlas/raid_atlas_hud"
	self.icons.coom_wheel_line.texture_rect = {
		1017,
		1045,
		6,
		242,
	}
	self.icons.equipment_panel_code_book = {}
	self.icons.equipment_panel_code_book.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_code_book.texture_rect = {
		421,
		1165,
		32,
		32,
	}
	self.icons.equipment_panel_code_device = {}
	self.icons.equipment_panel_code_device.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_code_device.texture_rect = {
		455,
		1165,
		32,
		32,
	}
	self.icons.equipment_panel_crowbar = {}
	self.icons.equipment_panel_crowbar.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_crowbar.texture_rect = {
		489,
		1165,
		32,
		32,
	}
	self.icons.equipment_panel_cvy_landimine = {}
	self.icons.equipment_panel_cvy_landimine.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_cvy_landimine.texture_rect = {
		523,
		1165,
		32,
		32,
	}
	self.icons.equipment_panel_cvy_thermite = {}
	self.icons.equipment_panel_cvy_thermite.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_cvy_thermite.texture_rect = {
		557,
		1165,
		32,
		32,
	}
	self.icons.equipment_panel_dynamite = {}
	self.icons.equipment_panel_dynamite.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_dynamite.texture_rect = {
		609,
		1317,
		32,
		32,
	}
	self.icons.equipment_panel_dynamite_stick = {}
	self.icons.equipment_panel_dynamite_stick.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_dynamite_stick.texture_rect = {
		643,
		1279,
		32,
		32,
	}
	self.icons.equipment_panel_fuel_empty = {}
	self.icons.equipment_panel_fuel_empty.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_fuel_empty.texture_rect = {
		609,
		1279,
		32,
		32,
	}
	self.icons.equipment_panel_fuel_full = {}
	self.icons.equipment_panel_fuel_full.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_fuel_full.texture_rect = {
		643,
		1313,
		32,
		32,
	}
	self.icons.equipment_panel_gold = {}
	self.icons.equipment_panel_gold.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_gold.texture_rect = {
		677,
		1317,
		32,
		32,
	}
	self.icons.equipment_panel_parachute = {}
	self.icons.equipment_panel_parachute.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_parachute.texture_rect = {
		327,
		1705,
		32,
		32,
	}
	self.icons.equipment_panel_portable_radio = {}
	self.icons.equipment_panel_portable_radio.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_portable_radio.texture_rect = {
		361,
		1705,
		32,
		32,
	}
	self.icons.equipment_panel_recording_device = {}
	self.icons.equipment_panel_recording_device.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_recording_device.texture_rect = {
		977,
		1723,
		32,
		32,
	}
	self.icons.equipment_panel_sps_briefcase = {}
	self.icons.equipment_panel_sps_briefcase.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_sps_briefcase.texture_rect = {
		977,
		1757,
		32,
		32,
	}
	self.icons.equipment_panel_power_cable = {}
	self.icons.equipment_panel_power_cable.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_power_cable.texture_rect = {
		992,
		1984,
		32,
		32,
	}
	self.icons.equipment_panel_sps_interaction_key = {}
	self.icons.equipment_panel_sps_interaction_key.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_sps_interaction_key.texture_rect = {
		649,
		1717,
		32,
		32,
	}
	self.icons.equipment_panel_sto_safe_key = {}
	self.icons.equipment_panel_sto_safe_key.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_sto_safe_key.texture_rect = {
		683,
		1717,
		32,
		32,
	}
	self.icons.equipment_panel_tools = {}
	self.icons.equipment_panel_tools.texture = "ui/atlas/raid_atlas_hud"
	self.icons.equipment_panel_tools.texture_rect = {
		717,
		1717,
		32,
		32,
	}
	self.icons.hud_notification_tier_t1 = {}
	self.icons.hud_notification_tier_t1.texture = "ui/atlas/raid_atlas_hud"
	self.icons.hud_notification_tier_t1.texture_rect = {
		1,
		1813,
		40,
		54,
	}
	self.icons.hud_notification_tier_t2 = {}
	self.icons.hud_notification_tier_t2.texture = "ui/atlas/raid_atlas_hud"
	self.icons.hud_notification_tier_t2.texture_rect = {
		1,
		1869,
		40,
		54,
	}
	self.icons.hud_notification_tier_t3 = {}
	self.icons.hud_notification_tier_t3.texture = "ui/atlas/raid_atlas_hud"
	self.icons.hud_notification_tier_t3.texture_rect = {
		1,
		1925,
		40,
		54,
	}
	self.icons.hud_notification_tier_t4 = {}
	self.icons.hud_notification_tier_t4.texture = "ui/atlas/raid_atlas_hud"
	self.icons.hud_notification_tier_t4.texture_rect = {
		1,
		1981,
		40,
		54,
	}
	self.icons.interaction_hold_meter_bg = {}
	self.icons.interaction_hold_meter_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.interaction_hold_meter_bg.texture_rect = {
		387,
		1267,
		288,
		10,
	}
	self.icons.interaction_key_left = {}
	self.icons.interaction_key_left.texture = "ui/atlas/raid_atlas_hud"
	self.icons.interaction_key_left.texture_rect = {
		717,
		1147,
		12,
		38,
	}
	self.icons.interaction_key_middle = {}
	self.icons.interaction_key_middle.texture = "ui/atlas/raid_atlas_hud"
	self.icons.interaction_key_middle.texture_rect = {
		717,
		1187,
		12,
		38,
	}
	self.icons.interaction_key_right = {}
	self.icons.interaction_key_right.texture = "ui/atlas/raid_atlas_hud"
	self.icons.interaction_key_right.texture_rect = {
		869,
		1311,
		12,
		38,
	}
	self.icons.machine_gun_full = {}
	self.icons.machine_gun_full.texture = "ui/atlas/raid_atlas_hud"
	self.icons.machine_gun_full.texture_rect = {
		383,
		1621,
		380,
		50,
	}
	self.icons.machine_gun_solo = {}
	self.icons.machine_gun_solo.texture = "ui/atlas/raid_atlas_hud"
	self.icons.machine_gun_solo.texture_rect = {
		1011,
		1479,
		10,
		50,
	}
	self.icons.miissions_raid_flaktower = {}
	self.icons.miissions_raid_flaktower.texture = "ui/atlas/raid_atlas_hud"
	self.icons.miissions_raid_flaktower.texture_rect = {
		963,
		1,
		56,
		56,
	}
	self.icons.mission_camp = {}
	self.icons.mission_camp.texture = "ui/atlas/raid_atlas_hud"
	self.icons.mission_camp.texture_rect = {
		963,
		59,
		56,
		56,
	}
	self.icons.missions_consumable_forest = {}
	self.icons.missions_consumable_forest.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_consumable_forest.texture_rect = {
		963,
		117,
		56,
		56,
	}
	self.icons.missions_consumable_mission = {}
	self.icons.missions_consumable_mission.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_consumable_mission.texture_rect = {
		963,
		175,
		56,
		56,
	}
	self.icons.missions_mini_raid_1 = {}
	self.icons.missions_mini_raid_1.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_mini_raid_1.texture_rect = {
		963,
		233,
		56,
		56,
	}
	self.icons.missions_mini_raid_2 = {}
	self.icons.missions_mini_raid_2.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_mini_raid_2.texture_rect = {
		963,
		291,
		56,
		56,
	}
	self.icons.missions_mini_raid_3 = {}
	self.icons.missions_mini_raid_3.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_mini_raid_3.texture_rect = {
		963,
		349,
		56,
		56,
	}
	self.icons.missions_mini_raids = {}
	self.icons.missions_mini_raids.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_mini_raids.texture_rect = {
		963,
		407,
		56,
		56,
	}
	self.icons.missions_operation_clear_skies = {}
	self.icons.missions_operation_clear_skies.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_operation_clear_skies.texture_rect = {
		963,
		465,
		56,
		56,
	}
	self.icons.missions_operation_rhinegold = {}
	self.icons.missions_operation_rhinegold.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_operation_rhinegold.texture_rect = {
		963,
		523,
		56,
		56,
	}
	self.icons.missions_operations_category = {}
	self.icons.missions_operations_category.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_operations_category.texture_rect = {
		963,
		581,
		56,
		56,
	}
	self.icons.missions_raid_bank = {}
	self.icons.missions_raid_bank.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_raid_bank.texture_rect = {
		963,
		639,
		56,
		56,
	}
	self.icons.missions_raid_bridge = {}
	self.icons.missions_raid_bridge.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_raid_bridge.texture_rect = {
		963,
		697,
		56,
		56,
	}
	self.icons.missions_raid_castle = {}
	self.icons.missions_raid_castle.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_raid_castle.texture_rect = {
		963,
		755,
		56,
		56,
	}
	self.icons.missions_raid_radio = {}
	self.icons.missions_raid_radio.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_raid_radio.texture_rect = {
		963,
		813,
		56,
		56,
	}
	self.icons.missions_raid_railyard = {}
	self.icons.missions_raid_railyard.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_raid_railyard.texture_rect = {
		963,
		871,
		56,
		56,
	}
	self.icons.missions_raids_category = {}
	self.icons.missions_raids_category.texture = "ui/atlas/raid_atlas_hud"
	self.icons.missions_raids_category.texture_rect = {
		963,
		929,
		56,
		56,
	}
	self.icons.weight_icon = {}
	self.icons.weight_icon.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weight_icon.texture_rect = {
		239,
		1989,
		40,
		40,
	}
	self.icons.nationality_small_american = {}
	self.icons.nationality_small_american.texture = "ui/atlas/raid_atlas_hud_nations"
	self.icons.nationality_small_american.texture_rect = {
		0,
		0,
		32,
		32,
	}
	self.icons.nationality_small_british = {}
	self.icons.nationality_small_british.texture = "ui/atlas/raid_atlas_hud_nations"
	self.icons.nationality_small_british.texture_rect = {
		0,
		32,
		32,
		32,
	}
	self.icons.nationality_small_german = {}
	self.icons.nationality_small_german.texture = "ui/atlas/raid_atlas_hud_nations"
	self.icons.nationality_small_german.texture_rect = {
		0,
		96,
		32,
		32,
	}
	self.icons.nationality_small_russian = {}
	self.icons.nationality_small_russian.texture = "ui/atlas/raid_atlas_hud_nations"
	self.icons.nationality_small_russian.texture_rect = {
		0,
		64,
		32,
		32,
	}
	self.icons.nationality_small_dr_reinhardt = {}
	self.icons.nationality_small_dr_reinhardt.texture = "ui/atlas/raid_atlas_hud_nations"
	self.icons.nationality_small_dr_reinhardt.texture_rect = {
		32,
		0,
		32,
		32,
	}
	self.icons.nationality_small_franz = {}
	self.icons.nationality_small_franz.texture = "ui/atlas/raid_atlas_hud_nations"
	self.icons.nationality_small_franz.texture_rect = {
		32,
		32,
		32,
		32,
	}
	self.icons.nationality_small_male_spy = {}
	self.icons.nationality_small_male_spy.texture = "ui/atlas/raid_atlas_hud_nations"
	self.icons.nationality_small_male_spy.texture_rect = {
		32,
		64,
		32,
		32,
	}
	self.icons.nationality_small_female_spy = deep_clone(self.icons.nationality_small_male_spy)
	self.icons.voice_chat_talking_icon = {}
	self.icons.voice_chat_talking_icon.texture = "ui/icons/ico_voice_chat_hud"
	self.icons.voice_chat_talking_icon.texture_rect = {
		0,
		0,
		32,
		32,
	}
	self.icons.voice_chat_muted_icon = {}
	self.icons.voice_chat_muted_icon.texture = "ui/icons/ico_voice_chat_hud"
	self.icons.voice_chat_muted_icon.texture_rect = {
		32,
		0,
		32,
		32,
	}
	self.icons.voice_chat_bg_black_icon = {}
	self.icons.voice_chat_bg_black_icon.texture = "ui/icons/voice_chat_bg_black_hud"
	self.icons.voice_chat_bg_black_icon.texture_rect = {
		0,
		0,
		256,
		32,
	}
	self.icons.notification_consumable = {}
	self.icons.notification_consumable.texture = "ui/atlas/raid_atlas_notification_intel"
	self.icons.notification_consumable.texture_rect = {
		0,
		0,
		256,
		256,
	}
	self.icons.objecives_new_empty_frame = {}
	self.icons.objecives_new_empty_frame.texture = "ui/atlas/raid_atlas_hud"
	self.icons.objecives_new_empty_frame.texture_rect = {
		671,
		1673,
		42,
		42,
	}
	self.icons.objective_checked = {}
	self.icons.objective_checked.texture = "ui/atlas/raid_atlas_hud"
	self.icons.objective_checked.texture_rect = {
		759,
		1711,
		38,
		38,
	}
	self.icons.objective_progress_bg = {}
	self.icons.objective_progress_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.objective_progress_bg.texture_rect = {
		663,
		1069,
		64,
		64,
	}
	self.icons.objective_unchecked = {}
	self.icons.objective_unchecked.texture = "ui/atlas/raid_atlas_hud"
	self.icons.objective_unchecked.texture_rect = {
		799,
		1711,
		38,
		38,
	}
	self.icons.objectives_new_checked_red_bg = {}
	self.icons.objectives_new_checked_red_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.objectives_new_checked_red_bg.texture_rect = {
		715,
		1673,
		42,
		42,
	}
	self.icons.objectives_new_progress_bg = {}
	self.icons.objectives_new_progress_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.objectives_new_progress_bg.texture_rect = {
		883,
		1355,
		74,
		42,
	}
	self.icons.player_panel_ai_downed_and_objective_countdown_bg = {}
	self.icons.player_panel_ai_downed_and_objective_countdown_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_ai_downed_and_objective_countdown_bg.texture_rect = {
		1,
		1673,
		48,
		48,
	}
	self.icons.player_panel_class_assault = {}
	self.icons.player_panel_class_assault.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_class_assault.texture_rect = {
		327,
		1651,
		52,
		52,
	}
	self.icons.player_panel_class_demolitions = {}
	self.icons.player_panel_class_demolitions.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_class_demolitions.texture_rect = {
		43,
		1813,
		52,
		52,
	}
	self.icons.player_panel_class_infiltrator = {}
	self.icons.player_panel_class_infiltrator.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_class_infiltrator.texture_rect = {
		43,
		1867,
		52,
		52,
	}
	self.icons.player_panel_class_recon = {}
	self.icons.player_panel_class_recon.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_class_recon.texture_rect = {
		43,
		1921,
		52,
		52,
	}
	self.icons.player_panel_downed_bg = {}
	self.icons.player_panel_downed_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_downed_bg.texture_rect = {
		773,
		1355,
		88,
		88,
	}
	self.icons.player_panel_host_indicator = {}
	self.icons.player_panel_host_indicator.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_host_indicator.texture_rect = {
		959,
		1825,
		32,
		32,
	}
	self.icons.player_panel_lives_indicator_1 = {}
	self.icons.player_panel_lives_indicator_1.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_lives_indicator_1.texture_rect = {
		864,
		2016,
		32,
		32,
	}
	self.icons.player_panel_lives_indicator_1.color = self.colors.raid_light_red
	self.icons.player_panel_lives_indicator_2 = {}
	self.icons.player_panel_lives_indicator_2.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_lives_indicator_2.texture_rect = {
		896,
		2016,
		32,
		32,
	}
	self.icons.player_panel_lives_indicator_2.color = self.colors.raid_white
	self.icons.player_panel_lives_indicator_3 = {}
	self.icons.player_panel_lives_indicator_3.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_lives_indicator_3.texture_rect = {
		928,
		2016,
		32,
		32,
	}
	self.icons.player_panel_lives_indicator_3.color = self.colors.raid_white
	self.icons.player_panel_lives_indicator_4 = {}
	self.icons.player_panel_lives_indicator_4.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_lives_indicator_4.texture_rect = {
		960,
		2016,
		32,
		32,
	}
	self.icons.player_panel_lives_indicator_4.color = self.colors.raid_white
	self.icons.player_panel_lives_indicator_5 = {}
	self.icons.player_panel_lives_indicator_5.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_lives_indicator_5.texture_rect = {
		992,
		2016,
		32,
		32,
	}
	self.icons.player_panel_lives_indicator_5.color = self.colors.raid_white
	self.icons.player_panel_interaction_teammate_bg = {}
	self.icons.player_panel_interaction_teammate_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_interaction_teammate_bg.texture_rect = {
		961,
		987,
		56,
		56,
	}
	self.icons.player_panel_nationality_american = {}
	self.icons.player_panel_nationality_american.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_nationality_american.texture_rect = {
		43,
		1975,
		52,
		52,
	}
	self.icons.player_panel_nationality_british = {}
	self.icons.player_panel_nationality_british.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_nationality_british.texture_rect = {
		97,
		1807,
		52,
		52,
	}
	self.icons.player_panel_nationality_german = {}
	self.icons.player_panel_nationality_german.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_nationality_german.texture_rect = {
		97,
		1861,
		52,
		52,
	}
	self.icons.player_panel_nationality_russian = {}
	self.icons.player_panel_nationality_russian.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_nationality_russian.texture_rect = {
		97,
		1915,
		52,
		52,
	}
	self.icons.player_panel_stamina_bg = {}
	self.icons.player_panel_stamina_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_stamina_bg.texture_rect = {
		769,
		1445,
		88,
		88,
	}
	self.icons.player_panel_status_dead_ai = {}
	self.icons.player_panel_status_dead_ai.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_status_dead_ai.texture_rect = {
		97,
		1969,
		52,
		52,
	}
	self.icons.player_panel_status_lockpick = {}
	self.icons.player_panel_status_lockpick.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_status_lockpick.texture_rect = {
		151,
		1807,
		52,
		52,
	}
	self.icons.player_panel_status_mounted_weapon = {}
	self.icons.player_panel_status_mounted_weapon.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_status_mounted_weapon.texture_rect = {
		181,
		1739,
		52,
		52,
	}
	self.icons.player_panel_teammate_downed_bg = {}
	self.icons.player_panel_teammate_downed_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_teammate_downed_bg.texture_rect = {
		1,
		1723,
		88,
		88,
	}
	self.icons.player_panel_warcry_bg = {}
	self.icons.player_panel_warcry_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.player_panel_warcry_bg.texture_rect = {
		91,
		1717,
		88,
		88,
	}
	self.icons.vehicle_bags_weight_indicator = {}
	self.icons.vehicle_bags_weight_indicator.texture = "ui/atlas/raid_atlas_hud"
	self.icons.vehicle_bags_weight_indicator.texture_rect = {
		631,
		1179,
		12,
		12,
	}
	self.icons.view_more_key_left = {}
	self.icons.view_more_key_left.texture = "ui/atlas/raid_atlas_hud"
	self.icons.view_more_key_left.texture_rect = {
		869,
		1351,
		12,
		32,
	}
	self.icons.view_more_key_middle = {}
	self.icons.view_more_key_middle.texture = "ui/atlas/raid_atlas_hud"
	self.icons.view_more_key_middle.texture_rect = {
		711,
		1317,
		12,
		32,
	}
	self.icons.view_more_key_right = {}
	self.icons.view_more_key_right.texture = "ui/atlas/raid_atlas_hud"
	self.icons.view_more_key_right.texture_rect = {
		863,
		1385,
		12,
		32,
	}
	self.icons.vip_health_bg = {}
	self.icons.vip_health_bg.texture = "ui/atlas/raid_atlas_hud"
	self.icons.vip_health_bg.texture_rect = {
		591,
		1165,
		70,
		12,
	}
	self.icons.weapon_panel_ass_carbine = {}
	self.icons.weapon_panel_ass_carbine.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_ass_carbine.texture_rect = {
		731,
		1311,
		136,
		42,
	}
	self.icons.weapon_panel_ass_garand = {}
	self.icons.weapon_panel_ass_garand.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_ass_garand.texture_rect = {
		873,
		1547,
		136,
		42,
	}
	self.icons.weapon_panel_ass_mp44 = {}
	self.icons.weapon_panel_ass_mp44.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_ass_mp44.texture_rect = {
		873,
		1591,
		136,
		42,
	}
	self.icons.weapon_panel_gre_m24 = {}
	self.icons.weapon_panel_gre_m24.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_gre_m24.texture_rect = {
		769,
		1535,
		102,
		42,
	}
	self.icons.weapon_panel_hdm = {}
	self.icons.weapon_panel_hdm.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_hdm.texture_rect = {
		869,
		1635,
		136,
		42,
	}
	self.icons.weapon_panel_indicator_rapid_fire = {}
	self.icons.weapon_panel_indicator_rapid_fire.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_indicator_rapid_fire.texture_rect = {
		591,
		1179,
		18,
		18,
	}
	self.icons.weapon_panel_indicator_single_fire = {}
	self.icons.weapon_panel_indicator_single_fire.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_indicator_single_fire.texture_rect = {
		611,
		1179,
		18,
		18,
	}
	self.icons.weapon_panel_indicator_shell_loaded = {}
	self.icons.weapon_panel_indicator_shell_loaded.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_shell_loaded.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.weapon_panel_indicator_shell_spent = {}
	self.icons.weapon_panel_indicator_shell_spent.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_shell_spent.texture_rect = {
		64,
		0,
		64,
		64,
	}
	self.icons.weapon_panel_indicator_shell_small_loaded = {}
	self.icons.weapon_panel_indicator_shell_small_loaded.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_shell_small_loaded.texture_rect = {
		64,
		96,
		32,
		32,
	}
	self.icons.weapon_panel_indicator_shell_small_spent = {}
	self.icons.weapon_panel_indicator_shell_small_spent.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_shell_small_spent.texture_rect = {
		96,
		96,
		32,
		32,
	}
	self.icons.weapon_panel_indicator_rifle_loaded = {}
	self.icons.weapon_panel_indicator_rifle_loaded.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_rifle_loaded.texture_rect = {
		0,
		64,
		16,
		64,
	}
	self.icons.weapon_panel_indicator_rifle_spent = {}
	self.icons.weapon_panel_indicator_rifle_spent.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_rifle_spent.texture_rect = {
		16,
		64,
		16,
		64,
	}
	self.icons.weapon_panel_indicator_9mm_loaded = {}
	self.icons.weapon_panel_indicator_9mm_loaded.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_9mm_loaded.texture_rect = {
		32,
		96,
		16,
		32,
	}
	self.icons.weapon_panel_indicator_9mm_spent = {}
	self.icons.weapon_panel_indicator_9mm_spent.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_9mm_spent.texture_rect = {
		48,
		96,
		16,
		32,
	}
	self.icons.weapon_panel_indicator_9mm_loaded_thin = {}
	self.icons.weapon_panel_indicator_9mm_loaded_thin.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_9mm_loaded_thin.texture_rect = {
		64,
		64,
		8,
		32,
	}
	self.icons.weapon_panel_indicator_9mm_spent_thin = {}
	self.icons.weapon_panel_indicator_9mm_spent_thin.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_9mm_spent_thin.texture_rect = {
		72,
		64,
		8,
		32,
	}
	self.icons.weapon_panel_indicator_drum_fg_ring = {}
	self.icons.weapon_panel_indicator_drum_fg_ring.texture = "ui/icons/ammo_icons/ammo_icons_drum_fg"
	self.icons.weapon_panel_indicator_drum_fg_ring.texture_rect = {
		0,
		0,
		32,
		32,
	}
	self.icons.weapon_panel_indicator_drum_bg_ring = {}
	self.icons.weapon_panel_indicator_drum_bg_ring.texture = "ui/icons/ammo_icons/ammo_icons_drum_bg"
	self.icons.weapon_panel_indicator_drum_bg_ring.texture_rect = {
		0,
		0,
		32,
		32,
	}
	self.icons.weapon_panel_indicator_drum_ooa_ring = {}
	self.icons.weapon_panel_indicator_drum_ooa_ring.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_drum_ooa_ring.texture_rect = {
		32,
		64,
		32,
		32,
	}
	self.icons.weapon_panel_indicator_revolver_bullet = {}
	self.icons.weapon_panel_indicator_revolver_bullet.texture = "ui/icons/ammo_icons/ammo_icons"
	self.icons.weapon_panel_indicator_revolver_bullet.texture_rect = {
		80,
		80,
		16,
		16,
	}
	self.icons.weapon_panel_indicator_revolver_cyl6 = {}
	self.icons.weapon_panel_indicator_revolver_cyl6.texture = "ui/icons/ammo_icons/ammo_icons_revolver_6"
	self.icons.weapon_panel_indicator_revolver_cyl6.texture_rect = {
		0,
		0,
		32,
		32,
	}
	self.icons.weapon_panel_lmg_dp28 = {}
	self.icons.weapon_panel_lmg_dp28.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_lmg_dp28.texture_rect = {
		869,
		1679,
		136,
		42,
	}
	self.icons.weapon_panel_lmg_m1918 = {}
	self.icons.weapon_panel_lmg_m1918.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_lmg_m1918.texture_rect = {
		51,
		1673,
		136,
		42,
	}
	self.icons.weapon_panel_lmg_mg42 = {}
	self.icons.weapon_panel_lmg_mg42.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_lmg_mg42.texture_rect = {
		189,
		1651,
		136,
		42,
	}
	self.icons.weapon_panel_nagant_m1895 = {}
	self.icons.weapon_panel_nagant_m1895.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_nagant_m1895.texture_rect = {
		189,
		1695,
		136,
		42,
	}
	self.icons.weapon_panel_pis_c96 = {}
	self.icons.weapon_panel_pis_c96.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_pis_c96.texture_rect = {
		235,
		1739,
		136,
		42,
	}
	self.icons.weapon_panel_pis_m1911 = {}
	self.icons.weapon_panel_pis_m1911.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_pis_m1911.texture_rect = {
		205,
		1847,
		136,
		42,
	}
	self.icons.weapon_panel_pis_tt33 = {}
	self.icons.weapon_panel_pis_tt33.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_pis_tt33.texture_rect = {
		259,
		1783,
		136,
		42,
	}
	self.icons.weapon_panel_pis_georg = {}
	self.icons.weapon_panel_pis_georg.texture = "ui/updates/upd_georg/atlas_weapon_icons"
	self.icons.weapon_panel_pis_georg.texture_rect = {
		0,
		0,
		136,
		42,
	}
	self.icons.weapon_panel_sho_1912 = {}
	self.icons.weapon_panel_sho_1912.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_sho_1912.texture_rect = {
		373,
		1739,
		136,
		42,
	}
	self.icons.weapon_panel_sho_geco = {}
	self.icons.weapon_panel_sho_geco.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_sho_geco.texture_rect = {
		395,
		1673,
		136,
		42,
	}
	self.icons.weapon_panel_shotty = {}
	self.icons.weapon_panel_shotty.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_shotty.texture_rect = {
		533,
		1673,
		136,
		42,
	}
	self.icons.weapon_panel_smg_mp38 = {}
	self.icons.weapon_panel_smg_mp38.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_smg_mp38.texture_rect = {
		839,
		1723,
		136,
		42,
	}
	self.icons.weapon_panel_smg_sten = {}
	self.icons.weapon_panel_smg_sten.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_smg_sten.texture_rect = {
		511,
		1717,
		136,
		42,
	}
	self.icons.weapon_panel_smg_sterling = {}
	self.icons.weapon_panel_smg_sterling.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_smg_sterling.texture_rect = {
		649,
		1751,
		136,
		42,
	}
	self.icons.weapon_panel_smg_thompson = {}
	self.icons.weapon_panel_smg_thompson.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_smg_thompson.texture_rect = {
		511,
		1761,
		136,
		42,
	}
	self.icons.weapon_panel_snp_m1903 = {}
	self.icons.weapon_panel_snp_m1903.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_snp_m1903.texture_rect = {
		821,
		1767,
		136,
		42,
	}
	self.icons.weapon_panel_snp_mosin = {}
	self.icons.weapon_panel_snp_mosin.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_snp_mosin.texture_rect = {
		649,
		1795,
		136,
		42,
	}
	self.icons.weapon_panel_welrod = {}
	self.icons.weapon_panel_welrod.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapon_panel_welrod.texture_rect = {
		821,
		1811,
		136,
		42,
	}
	self.icons.weapons_panel_bren = {}
	self.icons.weapons_panel_bren.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_bren.texture_rect = {
		397,
		1805,
		136,
		42,
	}
	self.icons.weapons_panel_browning = {}
	self.icons.weapons_panel_browning.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_browning.texture_rect = {
		535,
		1839,
		136,
		42,
	}
	self.icons.weapons_panel_enfield = {}
	self.icons.weapons_panel_enfield.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_enfield.texture_rect = {
		673,
		1853,
		136,
		42,
	}
	self.icons.weapons_panel_gre_concrete = {}
	self.icons.weapons_panel_gre_concrete.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_gre_concrete.texture_rect = {
		769,
		1579,
		102,
		42,
	}
	self.icons.weapons_panel_gre_d343 = {}
	self.icons.weapons_panel_gre_d343.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_gre_d343.texture_rect = {
		765,
		1623,
		102,
		42,
	}
	self.icons.weapons_panel_gre_mills = {}
	self.icons.weapons_panel_gre_mills.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_gre_mills.texture_rect = {
		765,
		1667,
		102,
		42,
	}
	self.icons.weapons_panel_itchaca = {}
	self.icons.weapons_panel_itchaca.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_itchaca.texture_rect = {
		811,
		1855,
		136,
		42,
	}
	self.icons.weapons_panel_kar_98k = {}
	self.icons.weapons_panel_kar_98k.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_kar_98k.texture_rect = {
		343,
		1849,
		136,
		42,
	}
	self.icons.weapons_panel_pis_webley = {}
	self.icons.weapons_panel_pis_webley.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_pis_webley.texture_rect = {
		205,
		1891,
		136,
		42,
	}
	self.icons.weapons_panel_gre_decoy_coin = {}
	self.icons.weapons_panel_gre_decoy_coin.texture = "ui/atlas/raid_atlas_hud"
	self.icons.weapons_panel_gre_decoy_coin.texture_rect = {
		238,
		1940,
		42,
		42,
	}
	self.icons.weapons_panel_gre_betty = {}
	self.icons.weapons_panel_gre_betty.texture = "ui/atlas/raid_atlas_new_items"
	self.icons.weapons_panel_gre_betty.texture_rect = {
		96,
		0,
		42,
		42,
	}
	self.icons.weapons_panel_gre_gold_bar = {}
	self.icons.weapons_panel_gre_gold_bar.texture = "ui/updates/upd_candy/atlas_gold_bar"
	self.icons.weapons_panel_gre_gold_bar.texture_rect = {
		96,
		0,
		42,
		42,
	}
	self.icons.weapons_panel_gre_anti_tank = {}
	self.icons.weapons_panel_gre_anti_tank.texture = "ui/updates/upd_blaze/atlas_weapon_icons"
	self.icons.weapons_panel_gre_anti_tank.texture_rect = {
		96,
		0,
		102,
		42,
	}
	self.icons.weapons_panel_gre_thermite = {}
	self.icons.weapons_panel_gre_thermite.texture = "ui/updates/upd_blaze/atlas_weapon_icons"
	self.icons.weapons_panel_gre_thermite.texture_rect = {
		96,
		128,
		102,
		42,
	}
	self.icons.missions_consumable_fury_railway = {}
	self.icons.missions_consumable_fury_railway.texture = "ui/atlas/raid_atlas_hud_raids_mini"
	self.icons.missions_consumable_fury_railway.texture_rect = {
		4,
		4,
		56,
		56,
	}
	self.icons.presenter_blur = {}
	self.icons.presenter_blur.texture = "ui/icons/presenter_blur_mask"
	self.icons.presenter_blur.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.presenter_background = {}
	self.icons.presenter_background.texture = "ui/atlas/raid_atlas_presenter"
	self.icons.presenter_background.texture_rect = {
		0,
		0,
		128,
		128,
	}
	self.icons.presenter_objective = {}
	self.icons.presenter_objective.texture = "ui/atlas/raid_atlas_presenter"
	self.icons.presenter_objective.texture_rect = {
		128,
		0,
		128,
		128,
	}
end

function GuiTweakData:_setup_hud_hotswap_icons()
	self.icons.hotswap_device_keyboard = {}
	self.icons.hotswap_device_keyboard.texture = "ui/icons/controller_hotswap_icons"
	self.icons.hotswap_device_keyboard.texture_rect = {
		0,
		0,
		64,
		64,
	}
	self.icons.hotswap_device_controller_ps4 = {}
	self.icons.hotswap_device_controller_ps4.texture = "ui/icons/controller_hotswap_icons"
	self.icons.hotswap_device_controller_ps4.texture_rect = {
		64,
		0,
		64,
		64,
	}
	self.icons.hotswap_device_controller_xb1 = {}
	self.icons.hotswap_device_controller_xb1.texture = "ui/icons/controller_hotswap_icons"
	self.icons.hotswap_device_controller_xb1.texture_rect = {
		0,
		64,
		64,
		64,
	}
	self.icons.hotswap_device_unknown = {}
	self.icons.hotswap_device_unknown.texture = "ui/icons/controller_hotswap_icons"
	self.icons.hotswap_device_unknown.texture_rect = {
		64,
		64,
		64,
		64,
	}
end

function GuiTweakData:_setup_hud_accessibility_icons()
	local common_motion_dot_size = {
		0,
		0,
		32,
		32,
	}

	self.icons.motion_dot = {}
	self.icons.motion_dot.texture = "ui/icons/accessibility/access_motion_dot"
	self.icons.motion_dot.texture_rect = common_motion_dot_size
	self.icons.motion_dot_contour = {}
	self.icons.motion_dot_contour.texture = "ui/icons/accessibility/access_motion_dot_contour"
	self.icons.motion_dot_contour.texture_rect = common_motion_dot_size
	self.icons.motion_dot_outline = {}
	self.icons.motion_dot_outline.texture = "ui/icons/accessibility/access_motion_dot_outline"
	self.icons.motion_dot_outline.texture_rect = common_motion_dot_size
	self.icons.motion_dot_inline = {}
	self.icons.motion_dot_inline.texture = "ui/icons/accessibility/access_motion_dot"
	self.icons.motion_dot_inline.texture_rect = common_motion_dot_size
	self.icons.motion_plus = {}
	self.icons.motion_plus.texture = "ui/icons/accessibility/access_motion_plus"
	self.icons.motion_plus.texture_rect = common_motion_dot_size
	self.icons.motion_plus_contour = {}
	self.icons.motion_plus_contour.texture = "ui/icons/accessibility/access_motion_plus_contour"
	self.icons.motion_plus_contour.texture_rect = common_motion_dot_size
	self.icons.motion_plus_outline = {}
	self.icons.motion_plus_outline.texture = "ui/icons/accessibility/access_motion_plus_outline"
	self.icons.motion_plus_outline.texture_rect = common_motion_dot_size
	self.icons.motion_plus_inline = {}
	self.icons.motion_plus_inline.texture = "ui/icons/accessibility/access_motion_plus"
	self.icons.motion_plus_inline.texture_rect = common_motion_dot_size
end

function GuiTweakData:_setup_hud_waypoint_icons()
	self.icons.damage_indicator_1 = {}
	self.icons.damage_indicator_1.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.damage_indicator_1.texture_rect = {
		1,
		1,
		296,
		64,
	}
	self.icons.damage_indicator_2 = {}
	self.icons.damage_indicator_2.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.damage_indicator_2.texture_rect = {
		1,
		67,
		296,
		64,
	}
	self.icons.damage_indicator_3 = {}
	self.icons.damage_indicator_3.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.damage_indicator_3.texture_rect = {
		1,
		133,
		296,
		64,
	}
	self.icons.damage_indicator_4 = {}
	self.icons.damage_indicator_4.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.damage_indicator_4.texture_rect = {
		1,
		199,
		296,
		64,
	}
	self.icons.indicator_hit_dot = {}
	self.icons.indicator_hit_dot.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.indicator_hit_dot.texture_rect = {
		0,
		992,
		32,
		32,
	}
	self.icons.indicator_hit_body = {}
	self.icons.indicator_hit_body.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.indicator_hit_body.texture_rect = {
		32,
		992,
		32,
		32,
	}
	self.icons.indicator_hit_head = {}
	self.icons.indicator_hit_head.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.indicator_hit_head.texture_rect = {
		64,
		992,
		32,
		32,
	}
	self.icons.indicator_hit_bomb = {}
	self.icons.indicator_hit_bomb.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.indicator_hit_bomb.texture_rect = {
		96,
		992,
		32,
		32,
	}
	self.icons.indicator_hit_armor = {}
	self.icons.indicator_hit_armor.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.indicator_hit_armor.texture_rect = {
		128,
		992,
		32,
		32,
	}
	self.icons.indicator_hit_weakness = {}
	self.icons.indicator_hit_weakness.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.indicator_hit_weakness.texture_rect = {
		160,
		992,
		32,
		32,
	}
	self.icons.map_state_alarm = {}
	self.icons.map_state_alarm.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.map_state_alarm.texture_rect = {
		377,
		167,
		72,
		72,
	}
	self.icons.map_state_alarm_1 = {}
	self.icons.map_state_alarm_1.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.map_state_alarm_1.texture_rect = {
		447,
		331,
		64,
		64,
	}
	self.icons.map_state_alarm_2 = {}
	self.icons.map_state_alarm_2.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.map_state_alarm_2.texture_rect = {
		149,
		265,
		64,
		64,
	}
	self.icons.map_state_alarm_3 = {}
	self.icons.map_state_alarm_3.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.map_state_alarm_3.texture_rect = {
		215,
		265,
		64,
		64,
	}
	self.icons.map_waypoint_pov_in = {}
	self.icons.map_waypoint_pov_in.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.map_waypoint_pov_in.texture_rect = {
		1,
		459,
		32,
		32,
	}
	self.icons.map_waypoint_pov_out = {}
	self.icons.map_waypoint_pov_out.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.map_waypoint_pov_out.texture_rect = {
		451,
		251,
		38,
		38,
	}
	self.icons.map_waypoint_up_down = {}
	self.icons.map_waypoint_up_down.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.map_waypoint_up_down.texture_rect = {
		493,
		1,
		18,
		18,
	}
	self.icons.stealth_alarm_icon = {}
	self.icons.stealth_alarm_icon.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_alarm_icon.texture_rect = {
		299,
		89,
		76,
		76,
	}
	self.icons.stealth_alarm_in = {}
	self.icons.stealth_alarm_in.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_alarm_in.texture_rect = {
		377,
		89,
		76,
		76,
	}
	self.icons.stealth_alarm_out = {}
	self.icons.stealth_alarm_out.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_alarm_out.texture_rect = {
		299,
		167,
		76,
		76,
	}
	self.icons.stealth_eye_bg = {}
	self.icons.stealth_eye_bg.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_eye_bg.texture_rect = {
		455,
		89,
		52,
		52,
	}
	self.icons.stealth_eye_out = {}
	self.icons.stealth_eye_out.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_eye_out.texture_rect = {
		455,
		143,
		52,
		52,
	}
	self.icons.stealth_eye_prompt_icon = {}
	self.icons.stealth_eye_prompt_icon.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_eye_prompt_icon.texture_rect = {
		451,
		197,
		52,
		52,
	}
	self.icons.stealth_indicator_fill = {}
	self.icons.stealth_indicator_fill.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_indicator_fill.texture_rect = {
		299,
		1,
		192,
		42,
	}
	self.icons.stealth_indicator_stroke = {}
	self.icons.stealth_indicator_stroke.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_indicator_stroke.texture_rect = {
		299,
		45,
		192,
		42,
	}
	self.icons.stealth_triangle_empty = {}
	self.icons.stealth_triangle_empty.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_triangle_empty.texture_rect = {
		377,
		241,
		72,
		72,
	}
	self.icons.stealth_triangle_filled = {}
	self.icons.stealth_triangle_filled.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_triangle_filled.texture_rect = {
		299,
		245,
		72,
		72,
	}
	self.icons.stealth_triangle_filled_cropped = {}
	self.icons.stealth_triangle_filled_cropped.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_triangle_filled_cropped.texture_rect = {
		281,
		479,
		36,
		31,
	}
	self.icons.stealth_triangle_outside_left = {}
	self.icons.stealth_triangle_outside_left.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_triangle_outside_left.texture_rect = {
		373,
		315,
		72,
		72,
	}
	self.icons.stealth_triangle_outside_right = {}
	self.icons.stealth_triangle_outside_right.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_triangle_outside_right.texture_rect = {
		1,
		265,
		72,
		72,
	}
	self.icons.stealth_triangle_outside_top = {}
	self.icons.stealth_triangle_outside_top.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.stealth_triangle_outside_top.texture_rect = {
		75,
		265,
		72,
		72,
	}
	self.icons.waypoint_special_aim = {}
	self.icons.waypoint_special_aim.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_aim.texture_rect = {
		451,
		291,
		38,
		38,
	}
	self.icons.waypoint_special_air_strike = {}
	self.icons.waypoint_special_air_strike.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_air_strike.texture_rect = {
		281,
		319,
		38,
		38,
	}
	self.icons.waypoint_special_ammo = {}
	self.icons.waypoint_special_ammo.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_ammo.texture_rect = {
		321,
		319,
		38,
		38,
	}
	self.icons.waypoint_special_boat = {}
	self.icons.waypoint_special_boat.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_boat.texture_rect = {
		149,
		331,
		38,
		38,
	}
	self.icons.waypoint_special_code_book = {}
	self.icons.waypoint_special_code_book.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_code_book.texture_rect = {
		189,
		331,
		38,
		38,
	}
	self.icons.waypoint_special_code_device = {}
	self.icons.waypoint_special_code_device.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_code_device.texture_rect = {
		229,
		331,
		38,
		38,
	}
	self.icons.waypoint_special_crowbar = {}
	self.icons.waypoint_special_crowbar.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_crowbar.texture_rect = {
		269,
		359,
		38,
		38,
	}
	self.icons.waypoint_special_cvy_foxhole = {}
	self.icons.waypoint_special_cvy_foxhole.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_cvy_foxhole.texture_rect = {
		309,
		359,
		38,
		38,
	}
	self.icons.waypoint_special_cvy_landimine = {}
	self.icons.waypoint_special_cvy_landimine.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_cvy_landimine.texture_rect = {
		349,
		389,
		38,
		38,
	}
	self.icons.waypoint_special_defend = {}
	self.icons.waypoint_special_defend.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_defend.texture_rect = {
		389,
		389,
		38,
		38,
	}
	self.icons.waypoint_special_dog_tags = {}
	self.icons.waypoint_special_dog_tags.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_dog_tags.texture_rect = {
		429,
		397,
		38,
		38,
	}
	self.icons.waypoint_special_door = {}
	self.icons.waypoint_special_door.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_door.texture_rect = {
		469,
		397,
		38,
		38,
	}
	self.icons.waypoint_special_downed = {}
	self.icons.waypoint_special_downed.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_downed.texture_rect = {
		1,
		339,
		38,
		38,
	}
	self.icons.waypoint_special_dynamite_stick = {}
	self.icons.waypoint_special_dynamite_stick.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_dynamite_stick.texture_rect = {
		41,
		339,
		38,
		38,
	}
	self.icons.waypoint_special_escape = {}
	self.icons.waypoint_special_escape.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_escape.texture_rect = {
		81,
		339,
		38,
		38,
	}
	self.icons.waypoint_special_explosive = {}
	self.icons.waypoint_special_explosive.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_explosive.texture_rect = {
		121,
		371,
		38,
		38,
	}
	self.icons.waypoint_special_fire = {}
	self.icons.waypoint_special_fire.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_fire.texture_rect = {
		161,
		371,
		38,
		38,
	}
	self.icons.waypoint_special_fix = {}
	self.icons.waypoint_special_fix.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_fix.texture_rect = {
		201,
		371,
		38,
		38,
	}
	self.icons.waypoint_special_general_vip_sit = {}
	self.icons.waypoint_special_general_vip_sit.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_general_vip_sit.texture_rect = {
		241,
		399,
		38,
		38,
	}
	self.icons.waypoint_special_gereneral_vip_move = {}
	self.icons.waypoint_special_gereneral_vip_move.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_gereneral_vip_move.texture_rect = {
		281,
		399,
		38,
		38,
	}
	self.icons.waypoint_special_gold = {}
	self.icons.waypoint_special_gold.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_gold.texture_rect = {
		321,
		429,
		38,
		38,
	}
	self.icons.waypoint_special_health = {}
	self.icons.waypoint_special_health.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_health.texture_rect = {
		361,
		429,
		38,
		38,
	}
	self.icons.waypoint_special_kill = {}
	self.icons.waypoint_special_kill.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_kill.texture_rect = {
		401,
		437,
		38,
		38,
	}
	self.icons.waypoint_special_lockpick = {}
	self.icons.waypoint_special_lockpick.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_lockpick.texture_rect = {
		441,
		437,
		38,
		38,
	}
	self.icons.waypoint_special_loot = {}
	self.icons.waypoint_special_loot.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_loot.texture_rect = {
		1,
		379,
		38,
		38,
	}
	self.icons.waypoint_special_loot_drop = {}
	self.icons.waypoint_special_loot_drop.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_loot_drop.texture_rect = {
		41,
		379,
		38,
		38,
	}
	self.icons.waypoint_special_parachute = {}
	self.icons.waypoint_special_parachute.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_parachute.texture_rect = {
		81,
		379,
		38,
		38,
	}
	self.icons.waypoint_special_phone = {}
	self.icons.waypoint_special_phone.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_phone.texture_rect = {
		121,
		411,
		38,
		38,
	}
	self.icons.waypoint_special_portable_radio = {}
	self.icons.waypoint_special_portable_radio.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_portable_radio.texture_rect = {
		161,
		411,
		38,
		38,
	}
	self.icons.waypoint_special_power = {}
	self.icons.waypoint_special_power.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_power.texture_rect = {
		201,
		411,
		38,
		38,
	}
	self.icons.waypoint_special_prisoner = {}
	self.icons.waypoint_special_prisoner.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_prisoner.texture_rect = {
		241,
		439,
		38,
		38,
	}
	self.icons.waypoint_special_recording_device = {}
	self.icons.waypoint_special_recording_device.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_recording_device.texture_rect = {
		281,
		439,
		38,
		38,
	}
	self.icons.waypoint_special_refuel = {}
	self.icons.waypoint_special_refuel.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_refuel.texture_rect = {
		321,
		469,
		38,
		38,
	}
	self.icons.waypoint_special_refuel_empty = {}
	self.icons.waypoint_special_refuel_empty.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_refuel_empty.texture_rect = {
		361,
		469,
		38,
		38,
	}
	self.icons.waypoint_special_key = {}
	self.icons.waypoint_special_key.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_key.texture_rect = {
		401,
		477,
		38,
		38,
	}
	self.icons.waypoint_special_stash_box = {}
	self.icons.waypoint_special_stash_box.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_stash_box.texture_rect = {
		441,
		477,
		38,
		38,
	}
	self.icons.waypoint_special_thermite = {}
	self.icons.waypoint_special_thermite.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_thermite.texture_rect = {
		1,
		419,
		38,
		38,
	}
	self.icons.waypoint_special_tools = {}
	self.icons.waypoint_special_tools.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_tools.texture_rect = {
		41,
		419,
		38,
		38,
	}
	self.icons.waypoint_special_valve = {}
	self.icons.waypoint_special_valve.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_valve.texture_rect = {
		81,
		419,
		38,
		38,
	}
	self.icons.waypoint_special_vehicle_kugelwagen = {}
	self.icons.waypoint_special_vehicle_kugelwagen.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_vehicle_kugelwagen.texture_rect = {
		121,
		451,
		38,
		38,
	}
	self.icons.waypoint_special_vehicle_truck = {}
	self.icons.waypoint_special_vehicle_truck.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_vehicle_truck.texture_rect = {
		161,
		451,
		38,
		38,
	}
	self.icons.waypoint_special_wait = {}
	self.icons.waypoint_special_wait.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_wait.texture_rect = {
		201,
		451,
		38,
		38,
	}
	self.icons.waypoint_special_where = {}
	self.icons.waypoint_special_where.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_where.texture_rect = {
		241,
		479,
		38,
		38,
	}
	self.icons.waypoint_special_camp_mission_raid = {}
	self.icons.waypoint_special_camp_mission_raid.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_camp_mission_raid.texture_rect = {
		1,
		491,
		32,
		32,
	}
	self.icons.waypoint_special_plug_cable = {}
	self.icons.waypoint_special_plug_cable.texture = "ui/atlas/raid_atlas_waypoints"
	self.icons.waypoint_special_plug_cable.texture_rect = {
		1,
		523,
		38,
		38,
	}
end

function GuiTweakData:_setup_hud_reticles()
	self.icons.weapons_reticles_ass_carbine = {}
	self.icons.weapons_reticles_ass_carbine.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_ass_carbine.texture_rect = {
		1,
		1,
		76,
		76,
	}
	self.icons.weapons_reticles_ass_garand = {}
	self.icons.weapons_reticles_ass_garand.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_ass_garand.texture_rect = {
		79,
		1,
		76,
		76,
	}
	self.icons.weapons_reticles_ass_mp44 = {}
	self.icons.weapons_reticles_ass_mp44.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_ass_mp44.texture_rect = {
		157,
		1,
		76,
		76,
	}
	self.icons.weapons_reticles_lmg_m1918 = {}
	self.icons.weapons_reticles_lmg_m1918.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_lmg_m1918.texture_rect = {
		1,
		79,
		76,
		76,
	}
	self.icons.weapons_reticles_lmg_mg42 = {}
	self.icons.weapons_reticles_lmg_mg42.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_lmg_mg42.texture_rect = {
		79,
		79,
		76,
		76,
	}
	self.icons.weapons_reticles_pis_c96 = {}
	self.icons.weapons_reticles_pis_c96.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_pis_c96.texture_rect = {
		157,
		79,
		76,
		76,
	}
	self.icons.weapons_reticles_pis_m1911 = {}
	self.icons.weapons_reticles_pis_m1911.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_pis_m1911.texture_rect = {
		1,
		157,
		76,
		76,
	}
	self.icons.weapons_reticles_turret_quad = {}
	self.icons.weapons_reticles_turret_quad.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_turret_quad.texture_rect = {
		79,
		157,
		76,
		76,
	}
	self.icons.weapons_reticles_smg_mp38 = {}
	self.icons.weapons_reticles_smg_mp38.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_smg_mp38.texture_rect = {
		157,
		157,
		76,
		76,
	}
	self.icons.weapons_reticles_smg_sten = {}
	self.icons.weapons_reticles_smg_sten.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_smg_sten.texture_rect = {
		1,
		235,
		76,
		76,
	}
	self.icons.weapons_reticles_smg_sterling = {}
	self.icons.weapons_reticles_smg_sterling.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_smg_sterling.texture_rect = {
		79,
		235,
		76,
		76,
	}
	self.icons.weapons_reticles_smg_thompson = {}
	self.icons.weapons_reticles_smg_thompson.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_smg_thompson.texture_rect = {
		157,
		235,
		76,
		76,
	}
	self.icons.weapons_reticles_smg_thompson_upgraded = {}
	self.icons.weapons_reticles_smg_thompson_upgraded.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_smg_thompson_upgraded.texture_rect = {
		1,
		313,
		76,
		76,
	}
	self.icons.weapons_reticles_snp_m1903 = {}
	self.icons.weapons_reticles_snp_m1903.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_snp_m1903.texture_rect = {
		1,
		391,
		76,
		76,
	}
	self.icons.weapons_reticles_snp_mosin = {}
	self.icons.weapons_reticles_snp_mosin.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_snp_mosin.texture_rect = {
		79,
		313,
		76,
		76,
	}
	self.icons.weapons_reticles_static_cross = {}
	self.icons.weapons_reticles_static_cross.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_static_cross.texture_rect = {
		78,
		390,
		38,
		38,
	}
	self.icons.weapons_reticles_static_triangle = {}
	self.icons.weapons_reticles_static_triangle.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_static_triangle.texture_rect = {
		117,
		390,
		38,
		38,
	}
	self.icons.weapons_reticles_static_diamond = {}
	self.icons.weapons_reticles_static_diamond.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_static_diamond.texture_rect = {
		156,
		390,
		38,
		38,
	}
	self.icons.weapons_reticles_static_dot = {}
	self.icons.weapons_reticles_static_dot.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_static_dot.texture_rect = {
		78,
		429,
		38,
		38,
	}
	self.icons.weapons_reticles_arrowcross = {}
	self.icons.weapons_reticles_arrowcross.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_arrowcross.texture_rect = {
		117,
		429,
		38,
		38,
	}
	self.icons.weapons_reticles_flatline = {}
	self.icons.weapons_reticles_flatline.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_flatline.texture_rect = {
		156,
		429,
		38,
		38,
	}
	self.icons.weapons_reticles_static_tri_small = {}
	self.icons.weapons_reticles_static_tri_small.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_static_tri_small.texture_rect = {
		195,
		390,
		38,
		38,
	}
	self.icons.weapons_reticles_bowbend = {}
	self.icons.weapons_reticles_bowbend.texture = "ui/atlas/raid_atlas_reticles"
	self.icons.weapons_reticles_bowbend.texture_rect = {
		156,
		312,
		78,
		78,
	}
end

function GuiTweakData:_setup_hud_status_effects()
	local function _make_icon(name, x, y, path, color)
		self.icons[name] = {
			color = color,
			texture = path or "ui/atlas/raid_atlas_hud_status_effects",
			texture_rect = {
				64 * x,
				64 * y,
				64,
				64,
			},
		}
	end

	_make_icon("status_effect_health_regen", 0, 0)
	_make_icon("status_effect_damage_resistance", 1, 0)
	_make_icon("status_effect_movement_speed", 2, 0)
	_make_icon("status_effect_stamina_boost", 3, 0)
	_make_icon("status_effect_explosion_resistance", 0, 1)
	_make_icon("status_effect_crit_chances", 1, 1)
	_make_icon("status_effect_on_fire", 2, 1)
	_make_icon("status_effect_dismemberment_boost", 3, 1)

	local hw_path = "ui/updates/upd_candy/atlas_candy_icons"

	_make_icon("status_effect_candy_unlimited_ammo", 0, 0, hw_path, Color("76ff81"))
	_make_icon("status_effect_candy_armor_pen", 1, 0, hw_path, Color("76ff81"))
	_make_icon("status_effect_candy_sprint_speed", 2, 0, hw_path, Color("ffcf76"))
	_make_icon("status_effect_candy_jump_boost", 3, 0, hw_path, Color("ffcf76"))
	_make_icon("status_effect_candy_attack_damage", 0, 1, hw_path, Color("76a6ff"))
	_make_icon("status_effect_candy_critical_hit_chance", 1, 1, hw_path, Color("76a6ff"))
	_make_icon("status_effect_candy_health_regen", 2, 1, hw_path, Color("ff76f0"))
	_make_icon("status_effect_candy_god_mode", 3, 1, hw_path, Color("ff76f0"))
	_make_icon("status_effect_candy_simple", 0, 2, hw_path, Color("ff76f0"))
end

function GuiTweakData:_setup_map_icons()
	self.icons.map_zone_germany = {}
	self.icons.map_zone_germany.texture = "ui/atlas/raid_atlas_map"
	self.icons.map_zone_germany.texture_rect = {
		1,
		1,
		1098,
		1080,
	}
	self.icons.map_ico_camp = {}
	self.icons.map_ico_camp.texture = "ui/atlas/raid_atlas_map"
	self.icons.map_ico_camp.texture_rect = {
		1507,
		1,
		52,
		52,
	}
	self.icons.map_gang = {}
	self.icons.map_gang.texture = "ui/atlas/raid_atlas_map"
	self.icons.map_gang.texture_rect = {
		1561,
		1,
		52,
		52,
	}
	self.icons.map_unknown_location = {}
	self.icons.map_unknown_location.texture = "ui/atlas/raid_atlas_map"
	self.icons.map_unknown_location.texture_rect = {
		1101,
		1,
		256,
		256,
	}
	self.icons.map_waypoint_map_kugelwagen = {}
	self.icons.map_waypoint_map_kugelwagen.texture = "ui/atlas/raid_atlas_map"
	self.icons.map_waypoint_map_kugelwagen.texture_rect = {
		1359,
		1,
		72,
		72,
	}
	self.icons.map_waypoint_map_truck = {}
	self.icons.map_waypoint_map_truck.texture = "ui/atlas/raid_atlas_map"
	self.icons.map_waypoint_map_truck.texture_rect = {
		1433,
		1,
		72,
		72,
	}
	self.icons.map_forest_bunker = {}
	self.icons.map_forest_bunker.texture = "ui/missions/forest_bunker/map_forest_bunker"
	self.icons.map_forest_bunker.texture_rect = {
		0,
		0,
		1024,
		1024,
	}
	self.icons.map_forest_bunker_int = {}
	self.icons.map_forest_bunker_int.texture = "ui/missions/forest_bunker/map_forest_bunker_int"
	self.icons.map_forest_bunker_int.texture_rect = {
		0,
		0,
		1024,
		1024,
	}
	self.icons.map_ico_bunker = {}
	self.icons.map_ico_bunker.texture = "ui/atlas/raid_atlas_map"
	self.icons.map_ico_bunker.texture_rect = {
		1507,
		54,
		52,
		52,
	}
end

function GuiTweakData:_setup_skill_icons()
	local function _make_icon(name, x, y)
		self.icons[name] = {
			texture = "ui/atlas/skilltree/raid_atlas_skills_new",
			texture_rect = {
				256 * x,
				256 * y,
				256,
				256,
			},
		}
	end

	_make_icon("skills_placeholder", 0, 0)
	_make_icon("skills_opportunist", 1, 0)
	_make_icon("skills_fitness_freak", 2, 0)
	_make_icon("skills_fast_hands", 3, 0)
	_make_icon("skills_fleetfoot", 4, 0)
	_make_icon("skills_handyman", 5, 0)
	_make_icon("skills_medic", 6, 0)
	_make_icon("skills_helpcry", 7, 0)
	_make_icon("skills_locksmith", 0, 1)
	_make_icon("skills_clipazines", 1, 1)
	_make_icon("skills_grenadier", 2, 1)
	_make_icon("skills_strong_back", 3, 1)
	_make_icon("skills_scuttler", 4, 1)
	_make_icon("skills_sprinter", 5, 1)
	_make_icon("skills_saboteur", 6, 1)
	_make_icon("skills_duck_and_cover", 7, 1)
	_make_icon("skills_predator", 0, 2)
	_make_icon("skills_anatomist", 1, 2)
	_make_icon("skills_perseverance", 2, 2)
	_make_icon("skills_warcry_pain_train", 3, 2)
	_make_icon("skills_pickpocket", 4, 2)
	_make_icon("skills_pack_mule", 5, 2)
	_make_icon("skills_focus", 7, 2)
	_make_icon("skills_fragstone", 0, 3)
	_make_icon("skills_painkiller", 1, 3)
	_make_icon("skills_high_dive", 2, 3)
	_make_icon("skills_gunner", 3, 3)
	_make_icon("skills_box_o_choc", 4, 3)
	_make_icon("skills_boost_charge_shortrange", 5, 3)
	_make_icon("skills_farsighted", 6, 3)
	_make_icon("skills_steadiness", 7, 3)
	_make_icon("skills_brutality", 0, 4)
	_make_icon("skills_boost_warcry_duration", 1, 4)
	_make_icon("skills_boost_charge_longrange", 2, 4)
	_make_icon("skills_boost_generic_damage", 4, 4)
	_make_icon("skills_warcry_sharpshooter", 5, 4)
	_make_icon("skills_warcry_silver_bullet", 6, 4)
	_make_icon("skills_warcry_ghost", 7, 4)
	_make_icon("skills_warcry_clustertruck", 0, 5)
	_make_icon("skills_warcry_berserk", 1, 5)
	_make_icon("skills_warcry_sentry", 2, 5)
	_make_icon("skills_warcry_hold_the_line", 3, 5)
	_make_icon("skills_boost_nothing", 4, 5)
	_make_icon("skills_marshal", 5, 5)
	_make_icon("skills_boxer", 6, 5)
	_make_icon("skills_revenant", 7, 5)
	_make_icon("skills_bellhop", 0, 6)
	_make_icon("skills_rally", 1, 6)
	_make_icon("skills_holdbarred", 2, 6)
	_make_icon("skills_critbrain", 3, 6)
	_make_icon("skills_leaded", 4, 6)
	_make_icon("skills_agile", 5, 6)
	_make_icon("skills_do_die", 6, 6)
	_make_icon("skills_blammfu", 7, 6)
	_make_icon("skills_toughness", 0, 7)
	_make_icon("skills_big_game", 1, 7)
	_make_icon("skills_sapper", 2, 7)
	_make_icon("skills_cache_basket", 3, 7)
	_make_icon("skills_warcry_scorched_earth", 4, 7)

	self.icons.player_panel_warcry_berserk = {}
	self.icons.player_panel_warcry_berserk.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.player_panel_warcry_berserk.texture_rect = {
		156,
		0,
		52,
		52,
	}
	self.icons.player_panel_warcry_cluster_truck = {}
	self.icons.player_panel_warcry_cluster_truck.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.player_panel_warcry_cluster_truck.texture_rect = {
		0,
		0,
		52,
		52,
	}
	self.icons.player_panel_warcry_scorched_earth = {}
	self.icons.player_panel_warcry_scorched_earth.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.player_panel_warcry_scorched_earth.texture_rect = {
		208,
		0,
		52,
		52,
	}
	self.icons.player_panel_warcry_invisibility = {}
	self.icons.player_panel_warcry_invisibility.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.player_panel_warcry_invisibility.texture_rect = {
		104,
		0,
		52,
		52,
	}
	self.icons.player_panel_warcry_sharpshooter = {}
	self.icons.player_panel_warcry_sharpshooter.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.player_panel_warcry_sharpshooter.texture_rect = {
		52,
		0,
		52,
		52,
	}
	self.icons.warcry_silver_bullet = {}
	self.icons.warcry_silver_bullet.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.warcry_silver_bullet.texture_rect = {
		104,
		156,
		52,
		52,
	}
	self.icons.player_panel_warcry_silver_bullet = {}
	self.icons.player_panel_warcry_silver_bullet.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.player_panel_warcry_silver_bullet.texture_rect = {
		104,
		52,
		52,
		52,
	}
	self.icons.warcry_sentry = {}
	self.icons.warcry_sentry.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.warcry_sentry.texture_rect = {
		0,
		156,
		52,
		52,
	}
	self.icons.player_panel_warcry_sentry = {}
	self.icons.player_panel_warcry_sentry.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.player_panel_warcry_sentry.texture_rect = {
		0,
		52,
		52,
		52,
	}
	self.icons.player_panel_warcry_pain_train = {}
	self.icons.player_panel_warcry_pain_train.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.player_panel_warcry_pain_train.texture_rect = {
		156,
		52,
		52,
		52,
	}
	self.icons.warcry_pain_train = {}
	self.icons.warcry_pain_train.texture = "ui/atlas/skilltree/raid_atlas_wc_hud_small"
	self.icons.warcry_pain_train.texture_rect = {
		156,
		156,
		52,
		52,
	}
	self.icons.skills_weapon_tier_1 = {}
	self.icons.skills_weapon_tier_1.texture = "ui/atlas/skilltree/raid_atlas_skills"
	self.icons.skills_weapon_tier_1.texture_rect = {
		158,
		548,
		76,
		76,
	}
	self.icons.skills_weapon_tier_2 = {}
	self.icons.skills_weapon_tier_2.texture = "ui/atlas/skilltree/raid_atlas_skills"
	self.icons.skills_weapon_tier_2.texture_rect = {
		236,
		548,
		76,
		76,
	}
	self.icons.skills_weapon_tier_3 = {}
	self.icons.skills_weapon_tier_3.texture = "ui/atlas/skilltree/raid_atlas_skills"
	self.icons.skills_weapon_tier_3.texture_rect = {
		314,
		548,
		76,
		76,
	}
	self.icons.skills_weapon_tier_4 = {}
	self.icons.skills_weapon_tier_4.texture = "ui/atlas/skilltree/raid_atlas_skills"
	self.icons.skills_weapon_tier_4.texture_rect = {
		392,
		548,
		76,
		76,
	}
end

function GuiTweakData:_setup_skill_big_icons()
	self.icons.experience_mission_fail_large = {}
	self.icons.experience_mission_fail_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.experience_mission_fail_large.texture_rect = {
		1642,
		765,
		380,
		380,
	}
	self.icons.experience_no_progress_large = {}
	self.icons.experience_no_progress_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.experience_no_progress_large.texture_rect = {
		1642,
		1147,
		380,
		380,
	}
	self.icons.skills_weapon_tier_1_large = {}
	self.icons.skills_weapon_tier_1_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.skills_weapon_tier_1_large.texture_rect = {
		1642,
		2,
		380,
		380,
	}
	self.icons.skills_weapon_tier_2_large = {}
	self.icons.skills_weapon_tier_2_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.skills_weapon_tier_2_large.texture_rect = {
		1642,
		384,
		380,
		380,
	}
	self.icons.skills_weapon_tier_3_large = {}
	self.icons.skills_weapon_tier_3_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.skills_weapon_tier_3_large.texture_rect = {
		2,
		766,
		380,
		380,
	}
	self.icons.skills_weapon_tier_4_large = {}
	self.icons.skills_weapon_tier_4_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.skills_weapon_tier_4_large.texture_rect = {
		2,
		1148,
		380,
		380,
	}
	self.icons.weapon_ass_carbine_large = {}
	self.icons.weapon_ass_carbine_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_ass_carbine_large.texture_rect = {
		2,
		2,
		408,
		126,
	}
	self.icons.weapon_ass_garand_large = {}
	self.icons.weapon_ass_garand_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_ass_garand_large.texture_rect = {
		412,
		2,
		408,
		126,
	}
	self.icons.weapon_ass_mp44_large = {}
	self.icons.weapon_ass_mp44_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_ass_mp44_large.texture_rect = {
		822,
		2,
		408,
		126,
	}
	self.icons.weapon_bren_large = {}
	self.icons.weapon_bren_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_bren_large.texture_rect = {
		1232,
		2,
		408,
		126,
	}
	self.icons.weapon_browning_large = {}
	self.icons.weapon_browning_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_browning_large.texture_rect = {
		2,
		130,
		408,
		126,
	}
	self.icons.weapon_enfield_large = {}
	self.icons.weapon_enfield_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_enfield_large.texture_rect = {
		412,
		130,
		408,
		126,
	}
	self.icons.weapon_gre_concrete_large = {}
	self.icons.weapon_gre_concrete_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_gre_concrete_large.texture_rect = {
		1266,
		1026,
		240,
		126,
	}
	self.icons.weapon_gre_decoy_coin_large = {}
	self.icons.weapon_gre_decoy_coin_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_gre_decoy_coin_large.texture_rect = {
		1024,
		772,
		128,
		128,
	}
	self.icons.weapon_gre_d343_large = {}
	self.icons.weapon_gre_d343_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_gre_d343_large.texture_rect = {
		856,
		770,
		126,
		126,
	}
	self.icons.weapon_gre_mills_large = {}
	self.icons.weapon_gre_mills_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_gre_mills_large.texture_rect = {
		856,
		898,
		126,
		126,
	}
	self.icons.weapon_hdm = {}
	self.icons.weapon_hdm.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_hdm.texture_rect = {
		822,
		130,
		408,
		126,
	}
	self.icons.weapon_itchaca_large = {}
	self.icons.weapon_itchaca_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_itchaca_large.texture_rect = {
		1232,
		130,
		408,
		126,
	}
	self.icons.weapon_kar_98k_large = {}
	self.icons.weapon_kar_98k_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_kar_98k_large.texture_rect = {
		2,
		258,
		408,
		126,
	}
	self.icons.weapon_lmg_dp28_large = {}
	self.icons.weapon_lmg_dp28_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_lmg_dp28_large.texture_rect = {
		412,
		258,
		408,
		126,
	}
	self.icons.weapon_lmg_m1918_large = {}
	self.icons.weapon_lmg_m1918_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_lmg_m1918_large.texture_rect = {
		822,
		258,
		408,
		126,
	}
	self.icons.weapon_lmg_mg42_large = {}
	self.icons.weapon_lmg_mg42_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_lmg_mg42_large.texture_rect = {
		1232,
		258,
		408,
		126,
	}
	self.icons.weapon_nagant_m1895 = {}
	self.icons.weapon_nagant_m1895.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_nagant_m1895.texture_rect = {
		2,
		386,
		408,
		126,
	}
	self.icons.weapon_pis_c96_large = {}
	self.icons.weapon_pis_c96_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_pis_c96_large.texture_rect = {
		2,
		514,
		408,
		126,
	}
	self.icons.weapon_pis_m1911_large = {}
	self.icons.weapon_pis_m1911_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_pis_m1911_large.texture_rect = {
		2,
		1912,
		408,
		126,
	}
	self.icons.weapon_pis_tt33_large = {}
	self.icons.weapon_pis_tt33_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_pis_tt33_large.texture_rect = {
		412,
		386,
		408,
		126,
	}
	self.icons.weapon_pis_georg_large = {
		texture = "ui/updates/upd_georg/atlas_weapon_icons",
		texture_rect = {
			0,
			42,
			408,
			126,
		},
	}
	self.icons.ws_georg_yankee_large = {
		texture = "ui/updates/upd_georg/ws_georg_yankee_large",
		texture_rect = {
			0,
			0,
			512,
			256,
		},
	}
	self.icons.ws_georg_uber_large = {
		texture = "ui/updates/upd_georg/ws_georg_uber_large",
		texture_rect = {
			0,
			0,
			512,
			256,
		},
	}
	self.icons.weapon_pis_webley_large = {}
	self.icons.weapon_pis_webley_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_pis_webley_large.texture_rect = {
		412,
		514,
		408,
		126,
	}
	self.icons.weapon_sho_1912_large = {}
	self.icons.weapon_sho_1912_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_sho_1912_large.texture_rect = {
		412,
		1912,
		408,
		126,
	}
	self.icons.weapon_sho_geco_large = {}
	self.icons.weapon_sho_geco_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_sho_geco_large.texture_rect = {
		822,
		386,
		408,
		126,
	}
	self.icons.weapon_shotty = {}
	self.icons.weapon_shotty.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_shotty.texture_rect = {
		1232,
		386,
		408,
		126,
	}
	self.icons.weapon_smg_mp38_large = {}
	self.icons.weapon_smg_mp38_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_smg_mp38_large.texture_rect = {
		822,
		514,
		408,
		126,
	}
	self.icons.weapon_smg_sten_large = {}
	self.icons.weapon_smg_sten_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_smg_sten_large.texture_rect = {
		1232,
		514,
		408,
		126,
	}
	self.icons.weapon_smg_sterling_large = {}
	self.icons.weapon_smg_sterling_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_smg_sterling_large.texture_rect = {
		822,
		642,
		408,
		126,
	}
	self.icons.weapon_smg_thompson_large = {}
	self.icons.weapon_smg_thompson_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_smg_thompson_large.texture_rect = {
		1232,
		642,
		408,
		126,
	}
	self.icons.weapon_snp_m1903_large = {}
	self.icons.weapon_snp_m1903_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_snp_m1903_large.texture_rect = {
		822,
		1912,
		408,
		126,
	}
	self.icons.weapon_snp_mosin_large = {}
	self.icons.weapon_snp_mosin_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_snp_mosin_large.texture_rect = {
		1232,
		770,
		408,
		126,
	}
	self.icons.weapon_welrod_large = {}
	self.icons.weapon_welrod_large.texture = "ui/atlas/skilltree/raid_atlas_experience"
	self.icons.weapon_welrod_large.texture_rect = {
		1232,
		898,
		408,
		126,
	}
	self.icons.weapon_gre_betty_large = {}
	self.icons.weapon_gre_betty_large.texture = "ui/atlas/raid_atlas_new_items"
	self.icons.weapon_gre_betty_large.texture_rect = {
		0,
		0,
		96,
		128,
	}
	self.icons.weapon_gre_gold_bar_large = {}
	self.icons.weapon_gre_gold_bar_large.texture = "ui/updates/upd_candy/atlas_gold_bar"
	self.icons.weapon_gre_gold_bar_large.texture_rect = {
		0,
		0,
		96,
		128,
	}
	self.icons.candy_progress_left = {}
	self.icons.candy_progress_left.texture = "ui/updates/upd_candy/atlas_candy_icons"
	self.icons.candy_progress_left.texture_rect = {
		70,
		144,
		16,
		32,
	}
	self.icons.candy_progress_center = {}
	self.icons.candy_progress_center.texture = "ui/updates/upd_candy/atlas_candy_icons"
	self.icons.candy_progress_center.texture_rect = {
		88,
		144,
		16,
		32,
	}
	self.icons.candy_progress_right = {}
	self.icons.candy_progress_right.texture = "ui/updates/upd_candy/atlas_candy_icons"
	self.icons.candy_progress_right.texture_rect = {
		106,
		144,
		16,
		32,
	}
	self.icons.candy_progress_overlay = {}
	self.icons.candy_progress_overlay.texture = "ui/updates/upd_candy/atlas_candy_icons"
	self.icons.candy_progress_overlay.texture_rect = {
		0,
		224,
		256,
		32,
	}
	self.icons.candy_buff_background = {}
	self.icons.candy_buff_background.texture = "ui/updates/upd_candy/atlas_candy_icons"
	self.icons.candy_buff_background.texture_rect = {
		128,
		128,
		64,
		64,
	}
	self.icons.weapon_gre_anti_tank_large = {}
	self.icons.weapon_gre_anti_tank_large.texture = "ui/updates/upd_blaze/atlas_weapon_icons"
	self.icons.weapon_gre_anti_tank_large.texture_rect = {
		0,
		0,
		96,
		128,
	}
	self.icons.weapon_gre_thermite_large = {}
	self.icons.weapon_gre_thermite_large.texture = "ui/updates/upd_blaze/atlas_weapon_icons"
	self.icons.weapon_gre_thermite_large.texture_rect = {
		0,
		128,
		96,
		128,
	}
end

function GuiTweakData:_setup_backgrounds()
	self.backgrounds = {}
	self.backgrounds.splash_screen = {}
	self.backgrounds.splash_screen.texture = "ui/backgrounds/raid_main_bg_hud"
	self.backgrounds.splash_screen.texture_rect = {
		0,
		0,
		2048,
		1024,
	}
	self.backgrounds.main_menu = {}
	self.backgrounds.main_menu.texture = "ui/backgrounds/raid_main_bg_hud"
	self.backgrounds.main_menu.texture_rect = {
		0,
		0,
		2048,
		1024,
	}
	self.backgrounds.secondary_menu = {}
	self.backgrounds.secondary_menu.texture = "ui/backgrounds/raid_secondary_menu_bg_hud"
	self.backgrounds.secondary_menu.texture_rect = {
		0,
		0,
		2048,
		1024,
	}
end

function GuiTweakData:_setup_images()
	self.images = {}
	self.images.menu_paper = {}
	self.images.menu_paper.texture = "ui/main_menu/textures/mission_paper_background"
	self.images.menu_paper.texture_rect = {
		5,
		0,
		1049,
		1527,
	}
end

function GuiTweakData:_setup_mission_photos()
	self.mission_photos = {}
	self.mission_photos.intel_bank_01 = {}
	self.mission_photos.intel_bank_01.texture = "ui/missions/treasury/raid_atlas_photos_bank"
	self.mission_photos.intel_bank_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_bank_02 = {}
	self.mission_photos.intel_bank_02.texture = "ui/missions/treasury/raid_atlas_photos_bank"
	self.mission_photos.intel_bank_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_bank_03 = {}
	self.mission_photos.intel_bank_03.texture = "ui/missions/treasury/raid_atlas_photos_bank"
	self.mission_photos.intel_bank_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_bank_04 = {}
	self.mission_photos.intel_bank_04.texture = "ui/missions/treasury/raid_atlas_photos_bank"
	self.mission_photos.intel_bank_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_bridge_01 = {}
	self.mission_photos.intel_bridge_01.texture = "ui/missions/bridge/raid_atlas_photos_bridge"
	self.mission_photos.intel_bridge_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_bridge_02 = {}
	self.mission_photos.intel_bridge_02.texture = "ui/missions/bridge/raid_atlas_photos_bridge"
	self.mission_photos.intel_bridge_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_bridge_03 = {}
	self.mission_photos.intel_bridge_03.texture = "ui/missions/bridge/raid_atlas_photos_bridge"
	self.mission_photos.intel_bridge_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_bridge_04 = {}
	self.mission_photos.intel_bridge_04.texture = "ui/missions/bridge/raid_atlas_photos_bridge"
	self.mission_photos.intel_bridge_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_bridge_05 = {}
	self.mission_photos.intel_bridge_05.texture = "ui/missions/bridge/raid_atlas_photos_bridge"
	self.mission_photos.intel_bridge_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_castle_01 = {}
	self.mission_photos.intel_castle_01.texture = "ui/missions/castle/raid_atlas_photos_castle"
	self.mission_photos.intel_castle_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_castle_02 = {}
	self.mission_photos.intel_castle_02.texture = "ui/missions/castle/raid_atlas_photos_castle"
	self.mission_photos.intel_castle_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_castle_03 = {}
	self.mission_photos.intel_castle_03.texture = "ui/missions/castle/raid_atlas_photos_castle"
	self.mission_photos.intel_castle_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_castle_04 = {}
	self.mission_photos.intel_castle_04.texture = "ui/missions/castle/raid_atlas_photos_castle"
	self.mission_photos.intel_castle_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_castle_05 = {}
	self.mission_photos.intel_castle_05.texture = "ui/missions/castle/raid_atlas_photos_castle"
	self.mission_photos.intel_castle_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_flak_01 = {}
	self.mission_photos.intel_flak_01.texture = "ui/missions/flakturm/raid_atlas_photos_flak"
	self.mission_photos.intel_flak_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_flak_02 = {}
	self.mission_photos.intel_flak_02.texture = "ui/missions/flakturm/raid_atlas_photos_flak"
	self.mission_photos.intel_flak_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_flak_03 = {}
	self.mission_photos.intel_flak_03.texture = "ui/missions/flakturm/raid_atlas_photos_flak"
	self.mission_photos.intel_flak_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_flak_04 = {}
	self.mission_photos.intel_flak_04.texture = "ui/missions/flakturm/raid_atlas_photos_flak"
	self.mission_photos.intel_flak_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_flak_05 = {}
	self.mission_photos.intel_flak_05.texture = "ui/missions/flakturm/raid_atlas_photos_flak"
	self.mission_photos.intel_flak_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_flak_06 = {}
	self.mission_photos.intel_flak_06.texture = "ui/missions/flakturm/raid_atlas_photos_flak"
	self.mission_photos.intel_flak_06.texture_rect = {
		420,
		582,
		416,
		288,
	}
	self.mission_photos.intel_radio_01 = {}
	self.mission_photos.intel_radio_01.texture = "ui/missions/radio_base/raid_atlas_photos_radio"
	self.mission_photos.intel_radio_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_radio_02 = {}
	self.mission_photos.intel_radio_02.texture = "ui/missions/radio_base/raid_atlas_photos_radio"
	self.mission_photos.intel_radio_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_radio_03 = {}
	self.mission_photos.intel_radio_03.texture = "ui/missions/radio_base/raid_atlas_photos_radio"
	self.mission_photos.intel_radio_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_radio_04 = {}
	self.mission_photos.intel_radio_04.texture = "ui/missions/radio_base/raid_atlas_photos_radio"
	self.mission_photos.intel_radio_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_radio_05 = {}
	self.mission_photos.intel_radio_05.texture = "ui/missions/radio_base/raid_atlas_photos_radio"
	self.mission_photos.intel_radio_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_train_01 = {}
	self.mission_photos.intel_train_01.texture = "ui/missions/rail_yard/raid_atlas_photos_trainyard"
	self.mission_photos.intel_train_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_train_02 = {}
	self.mission_photos.intel_train_02.texture = "ui/missions/rail_yard/raid_atlas_photos_trainyard"
	self.mission_photos.intel_train_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_train_03 = {}
	self.mission_photos.intel_train_03.texture = "ui/missions/rail_yard/raid_atlas_photos_trainyard"
	self.mission_photos.intel_train_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_train_04 = {}
	self.mission_photos.intel_train_04.texture = "ui/missions/rail_yard/raid_atlas_photos_trainyard"
	self.mission_photos.intel_train_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_train_05 = {}
	self.mission_photos.intel_train_05.texture = "ui/missions/rail_yard/raid_atlas_photos_trainyard"
	self.mission_photos.intel_train_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_forest_01 = {}
	self.mission_photos.intel_forest_01.texture = "ui/missions/forest/raid_atlas_photos_forest"
	self.mission_photos.intel_forest_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_forest_02 = {}
	self.mission_photos.intel_forest_02.texture = "ui/missions/forest/raid_atlas_photos_forest"
	self.mission_photos.intel_forest_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_forest_03 = {}
	self.mission_photos.intel_forest_03.texture = "ui/missions/forest/raid_atlas_photos_forest"
	self.mission_photos.intel_forest_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_forest_04 = {}
	self.mission_photos.intel_forest_04.texture = "ui/missions/forest/raid_atlas_photos_forest"
	self.mission_photos.intel_forest_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_art_storage_01 = {}
	self.mission_photos.intel_art_storage_01.texture = "ui/missions/art_storage/raid_atlas_photos_art_storage"
	self.mission_photos.intel_art_storage_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_art_storage_02 = {}
	self.mission_photos.intel_art_storage_02.texture = "ui/missions/art_storage/raid_atlas_photos_art_storage"
	self.mission_photos.intel_art_storage_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_art_storage_03 = {}
	self.mission_photos.intel_art_storage_03.texture = "ui/missions/art_storage/raid_atlas_photos_art_storage"
	self.mission_photos.intel_art_storage_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_art_storage_04 = {}
	self.mission_photos.intel_art_storage_04.texture = "ui/missions/art_storage/raid_atlas_photos_art_storage"
	self.mission_photos.intel_art_storage_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_art_storage_05 = {}
	self.mission_photos.intel_art_storage_05.texture = "ui/missions/art_storage/raid_atlas_photos_art_storage"
	self.mission_photos.intel_art_storage_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_bunkers_01 = {}
	self.mission_photos.intel_bunkers_01.texture = "ui/missions/bunkers/raid_atlas_photos_bunkers"
	self.mission_photos.intel_bunkers_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_bunkers_02 = {}
	self.mission_photos.intel_bunkers_02.texture = "ui/missions/bunkers/raid_atlas_photos_bunkers"
	self.mission_photos.intel_bunkers_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_bunkers_03 = {}
	self.mission_photos.intel_bunkers_03.texture = "ui/missions/bunkers/raid_atlas_photos_bunkers"
	self.mission_photos.intel_bunkers_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_bunkers_04 = {}
	self.mission_photos.intel_bunkers_04.texture = "ui/missions/bunkers/raid_atlas_photos_bunkers"
	self.mission_photos.intel_bunkers_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_bunkers_05 = {}
	self.mission_photos.intel_bunkers_05.texture = "ui/missions/bunkers/raid_atlas_photos_bunkers"
	self.mission_photos.intel_bunkers_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_convoy_01 = {}
	self.mission_photos.intel_convoy_01.texture = "ui/missions/convoy/raid_atlas_photos_convoy"
	self.mission_photos.intel_convoy_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_convoy_02 = {}
	self.mission_photos.intel_convoy_02.texture = "ui/missions/convoy/raid_atlas_photos_convoy"
	self.mission_photos.intel_convoy_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_convoy_03 = {}
	self.mission_photos.intel_convoy_03.texture = "ui/missions/convoy/raid_atlas_photos_convoy"
	self.mission_photos.intel_convoy_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_convoy_04 = {}
	self.mission_photos.intel_convoy_04.texture = "ui/missions/convoy/raid_atlas_photos_convoy"
	self.mission_photos.intel_convoy_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_convoy_05 = {}
	self.mission_photos.intel_convoy_05.texture = "ui/missions/convoy/raid_atlas_photos_convoy"
	self.mission_photos.intel_convoy_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_tank_depot_01 = {}
	self.mission_photos.intel_tank_depot_01.texture = "ui/missions/tank_depot/raid_atlas_photos_tank_depot"
	self.mission_photos.intel_tank_depot_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_tank_depot_02 = {}
	self.mission_photos.intel_tank_depot_02.texture = "ui/missions/tank_depot/raid_atlas_photos_tank_depot"
	self.mission_photos.intel_tank_depot_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_tank_depot_03 = {}
	self.mission_photos.intel_tank_depot_03.texture = "ui/missions/tank_depot/raid_atlas_photos_tank_depot"
	self.mission_photos.intel_tank_depot_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_tank_depot_04 = {}
	self.mission_photos.intel_tank_depot_04.texture = "ui/missions/tank_depot/raid_atlas_photos_tank_depot"
	self.mission_photos.intel_tank_depot_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_tank_depot_05 = {}
	self.mission_photos.intel_tank_depot_05.texture = "ui/missions/tank_depot/raid_atlas_photos_tank_depot"
	self.mission_photos.intel_tank_depot_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_hunters_01 = {}
	self.mission_photos.intel_hunters_01.texture = "ui/missions/hunters/raid_atlas_photos_hunters"
	self.mission_photos.intel_hunters_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_hunters_02 = {}
	self.mission_photos.intel_hunters_02.texture = "ui/missions/hunters/raid_atlas_photos_hunters"
	self.mission_photos.intel_hunters_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_hunters_03 = {}
	self.mission_photos.intel_hunters_03.texture = "ui/missions/hunters/raid_atlas_photos_hunters"
	self.mission_photos.intel_hunters_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_hunters_04 = {}
	self.mission_photos.intel_hunters_04.texture = "ui/missions/hunters/raid_atlas_photos_hunters"
	self.mission_photos.intel_hunters_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_kelly_01 = {}
	self.mission_photos.intel_kelly_01.texture = "ui/missions/kelly/raid_atlas_photos_kelly"
	self.mission_photos.intel_kelly_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_kelly_02 = {}
	self.mission_photos.intel_kelly_02.texture = "ui/missions/kelly/raid_atlas_photos_kelly"
	self.mission_photos.intel_kelly_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_kelly_03 = {}
	self.mission_photos.intel_kelly_03.texture = "ui/missions/kelly/raid_atlas_photos_kelly"
	self.mission_photos.intel_kelly_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_kelly_04 = {}
	self.mission_photos.intel_kelly_04.texture = "ui/missions/kelly/raid_atlas_photos_kelly"
	self.mission_photos.intel_kelly_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_spies_01 = {}
	self.mission_photos.intel_spies_01.texture = "ui/missions/spies/raid_atlas_photos_spies"
	self.mission_photos.intel_spies_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_spies_02 = {}
	self.mission_photos.intel_spies_02.texture = "ui/missions/spies/raid_atlas_photos_spies"
	self.mission_photos.intel_spies_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_spies_03 = {}
	self.mission_photos.intel_spies_03.texture = "ui/missions/spies/raid_atlas_photos_spies"
	self.mission_photos.intel_spies_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_spies_04 = {}
	self.mission_photos.intel_spies_04.texture = "ui/missions/spies/raid_atlas_photos_spies"
	self.mission_photos.intel_spies_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_spies_05 = {}
	self.mission_photos.intel_spies_05.texture = "ui/missions/spies/raid_atlas_photos_spies"
	self.mission_photos.intel_spies_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_silo_01 = {}
	self.mission_photos.intel_silo_01.texture = "ui/missions/silo/raid_atlas_photos_silo"
	self.mission_photos.intel_silo_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_silo_02 = {}
	self.mission_photos.intel_silo_02.texture = "ui/missions/silo/raid_atlas_photos_silo"
	self.mission_photos.intel_silo_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_silo_03 = {}
	self.mission_photos.intel_silo_03.texture = "ui/missions/silo/raid_atlas_photos_silo"
	self.mission_photos.intel_silo_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_silo_04 = {}
	self.mission_photos.intel_silo_04.texture = "ui/missions/silo/raid_atlas_photos_silo"
	self.mission_photos.intel_silo_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_silo_05 = {}
	self.mission_photos.intel_silo_05.texture = "ui/missions/silo/raid_atlas_photos_silo"
	self.mission_photos.intel_silo_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_silo_06 = {}
	self.mission_photos.intel_silo_06.texture = "ui/missions/silo/raid_atlas_photos_silo"
	self.mission_photos.intel_silo_06.texture_rect = {
		420,
		582,
		416,
		288,
	}
	self.mission_photos.intel_clear_skies_01 = {}
	self.mission_photos.intel_clear_skies_01.texture = "ui/missions/operation_clear_skies/raid_atlas_photos_op_clear_skies"
	self.mission_photos.intel_clear_skies_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_clear_skies_02 = {}
	self.mission_photos.intel_clear_skies_02.texture = "ui/missions/operation_clear_skies/raid_atlas_photos_op_clear_skies"
	self.mission_photos.intel_clear_skies_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_clear_skies_03 = {}
	self.mission_photos.intel_clear_skies_03.texture = "ui/missions/operation_clear_skies/raid_atlas_photos_op_clear_skies"
	self.mission_photos.intel_clear_skies_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_clear_skies_04 = {}
	self.mission_photos.intel_clear_skies_04.texture = "ui/missions/operation_clear_skies/raid_atlas_photos_op_clear_skies"
	self.mission_photos.intel_clear_skies_04.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.mission_photos.intel_clear_skies_05 = {}
	self.mission_photos.intel_clear_skies_05.texture = "ui/missions/operation_clear_skies/raid_atlas_photos_op_clear_skies"
	self.mission_photos.intel_clear_skies_05.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_clear_skies_06 = {}
	self.mission_photos.intel_clear_skies_06.texture = "ui/missions/operation_clear_skies/raid_atlas_photos_op_clear_skies"
	self.mission_photos.intel_clear_skies_06.texture_rect = {
		420,
		582,
		416,
		288,
	}
	self.mission_photos.intel_clear_skies_07 = {}
	self.mission_photos.intel_clear_skies_07.texture = "ui/missions/operation_clear_skies/raid_atlas_photos_op_clear_skies"
	self.mission_photos.intel_clear_skies_07.texture_rect = {
		2,
		872,
		416,
		288,
	}
	self.mission_photos.intel_clear_skies_08 = {}
	self.mission_photos.intel_clear_skies_08.texture = "ui/missions/operation_clear_skies/raid_atlas_photos_op_clear_skies"
	self.mission_photos.intel_clear_skies_08.texture_rect = {
		420,
		872,
		416,
		288,
	}
	self.mission_photos.intel_rhinegold_01 = {}
	self.mission_photos.intel_rhinegold_01.texture = "ui/missions/operation_rhinegold/raid_atlas_photos_op_rhine_gold"
	self.mission_photos.intel_rhinegold_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_rhinegold_02 = {}
	self.mission_photos.intel_rhinegold_02.texture = "ui/missions/operation_rhinegold/raid_atlas_photos_op_rhine_gold"
	self.mission_photos.intel_rhinegold_02.texture_rect = {
		420,
		2,
		416,
		288,
	}
	self.mission_photos.intel_rhinegold_03 = {}
	self.mission_photos.intel_rhinegold_03.texture = "ui/missions/operation_rhinegold/raid_atlas_photos_op_rhine_gold"
	self.mission_photos.intel_rhinegold_03.texture_rect = {
		2,
		292,
		416,
		288,
	}
	self.mission_photos.intel_rhinegold_04 = {}
	self.mission_photos.intel_rhinegold_04.texture = "ui/missions/operation_rhinegold/raid_atlas_photos_op_rhine_gold"
	self.mission_photos.intel_rhinegold_04.texture_rect = {
		2,
		582,
		416,
		288,
	}
	self.mission_photos.intel_rhinegold_05 = {}
	self.mission_photos.intel_rhinegold_05.texture = "ui/missions/operation_rhinegold/raid_atlas_photos_op_rhine_gold"
	self.mission_photos.intel_rhinegold_05.texture_rect = {
		420,
		292,
		416,
		288,
	}
	self.icons.intel_table_newspapers = {}
	self.icons.intel_table_newspapers.texture = "ui/atlas/menu/raid_atlas_intel_table_1"
	self.icons.intel_table_newspapers.texture_rect = {
		2,
		2,
		1120,
		752,
	}
	self.icons.intel_table_personnel_folder = {}
	self.icons.intel_table_personnel_folder.texture = "ui/atlas/menu/raid_atlas_intel_table_1"
	self.icons.intel_table_personnel_folder.texture_rect = {
		2,
		756,
		1088,
		768,
	}
	self.icons.intel_table_personnel_img_control = {}
	self.icons.intel_table_personnel_img_control.texture = "ui/atlas/menu/raid_atlas_intel_table_1"
	self.icons.intel_table_personnel_img_control.texture_rect = {
		2,
		1526,
		320,
		448,
	}
	self.icons.intel_table_personnel_img_kurgan = {}
	self.icons.intel_table_personnel_img_kurgan.texture = "ui/atlas/menu/raid_atlas_intel_table_1"
	self.icons.intel_table_personnel_img_kurgan.texture_rect = {
		324,
		1526,
		320,
		448,
	}
	self.icons.intel_table_personnel_img_mrs_white = {}
	self.icons.intel_table_personnel_img_mrs_white.texture = "ui/atlas/menu/raid_atlas_intel_table_1"
	self.icons.intel_table_personnel_img_mrs_white.texture_rect = {
		646,
		1526,
		320,
		448,
	}
	self.icons.intel_table_personnel_img_rivet = {}
	self.icons.intel_table_personnel_img_rivet.texture = "ui/atlas/menu/raid_atlas_intel_table_1"
	self.icons.intel_table_personnel_img_rivet.texture_rect = {
		968,
		1526,
		320,
		448,
	}
	self.icons.intel_table_personnel_img_sterling = {}
	self.icons.intel_table_personnel_img_sterling.texture = "ui/atlas/menu/raid_atlas_intel_table_1"
	self.icons.intel_table_personnel_img_sterling.texture_rect = {
		1092,
		756,
		320,
		448,
	}
	self.icons.intel_table_personnel_img_wolfgang = {}
	self.icons.intel_table_personnel_img_wolfgang.texture = "ui/atlas/menu/raid_atlas_intel_table_1"
	self.icons.intel_table_personnel_img_wolfgang.texture_rect = {
		1124,
		2,
		320,
		448,
	}
	self.icons.intel_table_archive = {}
	self.icons.intel_table_archive.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_archive.texture_rect = {
		2,
		2,
		1024,
		704,
	}
	self.icons.intel_table_opp_img_fallschirmjager_a = {}
	self.icons.intel_table_opp_img_fallschirmjager_a.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_fallschirmjager_a.texture_rect = {
		2,
		1414,
		320,
		448,
	}
	self.icons.intel_table_opp_img_fallschirmjager_b = {}
	self.icons.intel_table_opp_img_fallschirmjager_b.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_fallschirmjager_b.texture_rect = {
		324,
		1414,
		320,
		448,
	}
	self.icons.intel_table_opp_img_flammen_a = {}
	self.icons.intel_table_opp_img_flammen_a.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_flammen_a.texture_rect = {
		646,
		1414,
		320,
		448,
	}
	self.icons.intel_table_opp_img_gebirgsjager_a = {}
	self.icons.intel_table_opp_img_gebirgsjager_a.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_gebirgsjager_a.texture_rect = {
		968,
		1414,
		320,
		448,
	}
	self.icons.intel_table_opp_img_gebirgsjager_b = {}
	self.icons.intel_table_opp_img_gebirgsjager_b.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_gebirgsjager_b.texture_rect = {
		1290,
		2,
		320,
		448,
	}
	self.icons.intel_table_opp_img_herr_a = {}
	self.icons.intel_table_opp_img_herr_a.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_herr_a.texture_rect = {
		1612,
		2,
		320,
		448,
	}
	self.icons.intel_table_opp_img_herr_b = {}
	self.icons.intel_table_opp_img_herr_b.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_herr_b.texture_rect = {
		1290,
		452,
		320,
		448,
	}
	self.icons.intel_table_opp_img_herr_c = {}
	self.icons.intel_table_opp_img_herr_c.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_herr_c.texture_rect = {
		1028,
		902,
		320,
		448,
	}
	self.icons.intel_table_opp_img_officer_a = {}
	self.icons.intel_table_opp_img_officer_a.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_officer_a.texture_rect = {
		1612,
		452,
		320,
		448,
	}
	self.icons.intel_table_opp_img_sniper_a = {}
	self.icons.intel_table_opp_img_sniper_a.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_sniper_a.texture_rect = {
		1290,
		1352,
		320,
		448,
	}
	self.icons.intel_table_opp_img_spotter_a = {}
	self.icons.intel_table_opp_img_spotter_a.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_spotter_a.texture_rect = {
		1350,
		902,
		320,
		448,
	}
	self.icons.intel_table_opp_img_waffen_ss_a = {}
	self.icons.intel_table_opp_img_waffen_ss_a.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_waffen_ss_a.texture_rect = {
		1672,
		902,
		320,
		448,
	}
	self.icons.intel_table_opp_img_waffen_ss_b = {}
	self.icons.intel_table_opp_img_waffen_ss_b.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opp_img_waffen_ss_b.texture_rect = {
		1612,
		1352,
		320,
		448,
	}
	self.icons.intel_table_opposition_card = {}
	self.icons.intel_table_opposition_card.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.intel_table_opposition_card.texture_rect = {
		2,
		708,
		1024,
		704,
	}
	self.icons.play_icon = {}
	self.icons.play_icon.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.play_icon.texture_rect = {
		2,
		1864,
		100,
		100,
	}
	self.icons.play_icon_outline = {}
	self.icons.play_icon_outline.texture = "ui/atlas/menu/raid_atlas_intel_table_2"
	self.icons.play_icon_outline.texture_rect = {
		104,
		1864,
		100,
		100,
	}
	self.mission_photos.intel_fury_railway_01 = {}
	self.mission_photos.intel_fury_railway_01.texture = "ui/missions/fury_railway/raid_atlas_photos_fury_railway"
	self.mission_photos.intel_fury_railway_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_fury_railway_02 = {}
	self.mission_photos.intel_fury_railway_02.texture = "ui/missions/fury_railway/raid_atlas_photos_fury_railway"
	self.mission_photos.intel_fury_railway_02.texture_rect = {
		2,
		290,
		416,
		288,
	}
	self.mission_photos.intel_fury_railway_03 = {}
	self.mission_photos.intel_fury_railway_03.texture = "ui/missions/fury_railway/raid_atlas_photos_fury_railway"
	self.mission_photos.intel_fury_railway_03.texture_rect = {
		2,
		578,
		416,
		288,
	}
	self.mission_photos.intel_fury_railway_04 = {}
	self.mission_photos.intel_fury_railway_04.texture = "ui/missions/fury_railway/raid_atlas_photos_fury_railway"
	self.mission_photos.intel_fury_railway_04.texture_rect = {
		418,
		2,
		416,
		288,
	}
	self.mission_photos.intel_forest_bunker_01 = {}
	self.mission_photos.intel_forest_bunker_01.texture = "ui/missions/forest_bunker/raid_atlas_photos_forest_bunker"
	self.mission_photos.intel_forest_bunker_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_forest_bunker_02 = {}
	self.mission_photos.intel_forest_bunker_02.texture = "ui/missions/forest_bunker/raid_atlas_photos_forest_bunker"
	self.mission_photos.intel_forest_bunker_02.texture_rect = {
		2,
		290,
		416,
		288,
	}
	self.mission_photos.intel_forest_bunker_03 = {}
	self.mission_photos.intel_forest_bunker_03.texture = "ui/missions/forest_bunker/raid_atlas_photos_forest_bunker"
	self.mission_photos.intel_forest_bunker_03.texture_rect = {
		2,
		578,
		416,
		288,
	}
	self.mission_photos.intel_forest_bunker_04 = {}
	self.mission_photos.intel_forest_bunker_04.texture = "ui/missions/forest_bunker/raid_atlas_photos_forest_bunker"
	self.mission_photos.intel_forest_bunker_04.texture_rect = {
		418,
		2,
		416,
		288,
	}
	self.mission_photos.intel_random_operation_01 = {}
	self.mission_photos.intel_random_operation_01.texture = "ui/updates/upd_oops/raid_atlas_photos_random_operation"
	self.mission_photos.intel_random_operation_01.texture_rect = {
		2,
		2,
		416,
		288,
	}
	self.mission_photos.intel_random_operation_02 = {}
	self.mission_photos.intel_random_operation_02.texture = "ui/updates/upd_oops/raid_atlas_photos_random_operation"
	self.mission_photos.intel_random_operation_02.texture_rect = {
		2,
		290,
		416,
		288,
	}
	self.mission_photos.intel_random_operation_03 = {}
	self.mission_photos.intel_random_operation_03.texture = "ui/updates/upd_oops/raid_atlas_photos_random_operation"
	self.mission_photos.intel_random_operation_03.texture_rect = {
		418,
		2,
		416,
		288,
	}
end

function GuiTweakData:_setup_optical_flares()
	self.icons.lens_glint = {}
	self.icons.lens_glint.texture = "ui/optical_flares/raid_reward_lens_glint_df"
	self.icons.lens_glint.texture_rect = {
		0,
		0,
		1024,
		1024,
	}
	self.icons.lens_iris = {}
	self.icons.lens_iris.texture = "ui/optical_flares/raid_reward_lens_iris_df"
	self.icons.lens_iris.texture_rect = {
		0,
		0,
		1024,
		1024,
	}
	self.icons.lens_orbs = {}
	self.icons.lens_orbs.texture = "ui/optical_flares/raid_reward_lens_orbs_df"
	self.icons.lens_orbs.texture_rect = {
		0,
		0,
		1024,
		1024,
	}
	self.icons.lens_shimmer = {}
	self.icons.lens_shimmer.texture = "ui/optical_flares/raid_reward_lens_shimmer_df"
	self.icons.lens_shimmer.texture_rect = {
		0,
		0,
		1024,
		1024,
	}
	self.icons.lens_spike_ball = {}
	self.icons.lens_spike_ball.texture = "ui/optical_flares/raid_reward_lens_spike_ball_df"
	self.icons.lens_spike_ball.texture_rect = {
		0,
		0,
		1024,
		1024,
	}
end

function GuiTweakData:_setup_xp_icons()
	self.icons.xp_events_mission_raid_railyard = {}
	self.icons.xp_events_mission_raid_railyard.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_mission_raid_railyard.texture_rect = {
		2,
		2,
		392,
		392,
	}
	self.icons.xp_events_missions_art_storage = {}
	self.icons.xp_events_missions_art_storage.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_art_storage.texture_rect = {
		2,
		396,
		392,
		392,
	}
	self.icons.xp_events_missions_bunkers = {}
	self.icons.xp_events_missions_bunkers.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_bunkers.texture_rect = {
		2,
		790,
		392,
		392,
	}
	self.icons.xp_events_missions_consumable_forest = {}
	self.icons.xp_events_missions_consumable_forest.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_consumable_forest.texture_rect = {
		2,
		1184,
		392,
		392,
	}
	self.icons.xp_events_missions_convoy = {}
	self.icons.xp_events_missions_convoy.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_convoy.texture_rect = {
		2,
		1578,
		392,
		392,
	}
	self.icons.xp_events_missions_hunters = {}
	self.icons.xp_events_missions_hunters.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_hunters.texture_rect = {
		396,
		2,
		392,
		392,
	}
	self.icons.xp_events_missions_operation_clear_skies = {}
	self.icons.xp_events_missions_operation_clear_skies.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_operation_clear_skies.texture_rect = {
		790,
		2,
		392,
		392,
	}
	self.icons.xp_events_missions_operation_clear_skies_1 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_xp_op_clear_skies",
		texture_rect = {
			25,
			25,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_clear_skies_2 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_xp_op_clear_skies",
		texture_rect = {
			525,
			25,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_clear_skies_3 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_xp_op_clear_skies",
		texture_rect = {
			1025,
			25,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_clear_skies_4 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_xp_op_clear_skies",
		texture_rect = {
			1525,
			25,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_clear_skies_5 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_xp_op_clear_skies",
		texture_rect = {
			25,
			525,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_clear_skies_6 = {
		texture = "ui/missions/operation_clear_skies/raid_atlas_xp_op_clear_skies",
		texture_rect = {
			525,
			525,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_rhinegold = {}
	self.icons.xp_events_missions_operation_rhinegold.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_operation_rhinegold.texture_rect = {
		1184,
		2,
		392,
		392,
	}
	self.icons.xp_events_missions_operation_rhinegold_1 = {
		texture = "ui/missions/operation_rhinegold/raid_atlas_missions_op_rhine_gold",
		texture_rect = {
			25,
			25,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_rhinegold_2 = {
		texture = "ui/missions/operation_rhinegold/raid_atlas_missions_op_rhine_gold",
		texture_rect = {
			525,
			25,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_rhinegold_3 = {
		texture = "ui/missions/operation_rhinegold/raid_atlas_missions_op_rhine_gold",
		texture_rect = {
			1025,
			25,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operation_rhinegold_4 = {
		texture = "ui/missions/operation_rhinegold/raid_atlas_missions_op_rhine_gold",
		texture_rect = {
			1525,
			25,
			450,
			450,
		},
	}
	self.icons.xp_events_missions_operations_category = {}
	self.icons.xp_events_missions_operations_category.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_operations_category.texture_rect = {
		1578,
		2,
		392,
		392,
	}
	self.icons.xp_events_missions_raid_bank = {}
	self.icons.xp_events_missions_raid_bank.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_raid_bank.texture_rect = {
		396,
		396,
		392,
		392,
	}
	self.icons.xp_events_missions_raid_bridge = {}
	self.icons.xp_events_missions_raid_bridge.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_raid_bridge.texture_rect = {
		396,
		790,
		392,
		392,
	}
	self.icons.xp_events_missions_raid_castle = {}
	self.icons.xp_events_missions_raid_castle.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_raid_castle.texture_rect = {
		396,
		1184,
		392,
		392,
	}
	self.icons.xp_events_missions_raid_flaktower = {}
	self.icons.xp_events_missions_raid_flaktower.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_raid_flaktower.texture_rect = {
		396,
		1578,
		392,
		392,
	}
	self.icons.xp_events_missions_raid_radio = {}
	self.icons.xp_events_missions_raid_radio.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_raid_radio.texture_rect = {
		790,
		396,
		392,
		392,
	}
	self.icons.xp_events_missions_raids_category = {}
	self.icons.xp_events_missions_raids_category.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_raids_category.texture_rect = {
		1184,
		396,
		392,
		392,
	}
	self.icons.xp_events_missions_silo = {}
	self.icons.xp_events_missions_silo.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_silo.texture_rect = {
		1578,
		396,
		392,
		392,
	}
	self.icons.xp_events_missions_spies = {}
	self.icons.xp_events_missions_spies.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_spies.texture_rect = {
		790,
		790,
		392,
		392,
	}
	self.icons.xp_events_missions_tank_depot = {}
	self.icons.xp_events_missions_tank_depot.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_tank_depot.texture_rect = {
		790,
		1184,
		392,
		392,
	}
	self.icons.xp_events_missions_kelly = {}
	self.icons.xp_events_missions_kelly.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_kelly.texture_rect = {
		790,
		1576,
		392,
		392,
	}
	self.icons.xp_events_missions_fury_railway = {}
	self.icons.xp_events_missions_fury_railway.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_fury_railway.texture_rect = {
		1182,
		790,
		392,
		392,
	}
	self.icons.xp_events_missions_forest_bunker = {}
	self.icons.xp_events_missions_forest_bunker.texture = "ui/atlas/raid_atlas_xp"
	self.icons.xp_events_missions_forest_bunker.texture_rect = {
		1574,
		790,
		392,
		392,
	}
	self.icons.xp_events_missions_raid_bounty = {}
	self.icons.xp_events_missions_raid_bounty.texture = "ui/updates/upd_cow/job_icons"
	self.icons.xp_events_missions_raid_bounty.texture_rect = {
		0,
		0,
		392,
		392,
	}
end

function GuiTweakData:_setup_paper_icons()
	self.icons.icon_intel_tape_01 = {}
	self.icons.icon_intel_tape_01.texture = "ui/atlas/menu/raid_atlas_papers"
	self.icons.icon_intel_tape_01.texture_rect = {
		386,
		1653,
		192,
		64,
	}
	self.icons.icon_intel_tape_02 = {}
	self.icons.icon_intel_tape_02.texture = "ui/atlas/menu/raid_atlas_papers"
	self.icons.icon_intel_tape_02.texture_rect = {
		500,
		1539,
		192,
		64,
	}
	self.icons.icon_paper_stamp = {}
	self.icons.icon_paper_stamp.texture = "ui/atlas/menu/raid_atlas_papers"
	self.icons.icon_paper_stamp.texture_rect = {
		386,
		1539,
		112,
		112,
	}
	self.icons.paper_intel = {}
	self.icons.paper_intel.texture = "ui/atlas/menu/raid_atlas_papers"
	self.icons.paper_intel.texture_rect = {
		1065,
		1388,
		891,
		621,
	}
	self.icons.paper_mission_book = {}
	self.icons.paper_mission_book.texture = "ui/atlas/menu/raid_atlas_papers"
	self.icons.paper_mission_book.texture_rect = {
		2,
		2,
		1061,
		1535,
	}
	self.icons.paper_reward_large = {}
	self.icons.paper_reward_large.texture = "ui/atlas/menu/raid_atlas_papers"
	self.icons.paper_reward_large.texture_rect = {
		1065,
		2,
		955,
		1384,
	}
	self.icons.paper_reward_small = {}
	self.icons.paper_reward_small.texture = "ui/atlas/menu/raid_atlas_papers"
	self.icons.paper_reward_small.texture_rect = {
		2,
		1539,
		382,
		448,
	}
	self.icons.folder_mission = {}
	self.icons.folder_mission.texture = "ui/atlas/menu/raid_atlas_papers_2"
	self.icons.folder_mission.texture_rect = {
		2,
		786,
		546,
		782,
	}
	self.icons.folder_mission_hud_notification_ops = {}
	self.icons.folder_mission_hud_notification_ops.texture = "ui/atlas/menu/raid_atlas_papers_2"
	self.icons.folder_mission_hud_notification_ops.texture_rect = {
		598,
		388,
		252,
		332,
	}
	self.icons.folder_mission_hud_notification_raid = {}
	self.icons.folder_mission_hud_notification_raid.texture = "ui/atlas/menu/raid_atlas_papers_2"
	self.icons.folder_mission_hud_notification_raid.texture_rect = {
		598,
		722,
		232,
		332,
	}
	self.icons.folder_mission_op = {}
	self.icons.folder_mission_op.texture = "ui/atlas/menu/raid_atlas_papers_2"
	self.icons.folder_mission_op.texture_rect = {
		2,
		2,
		594,
		782,
	}
	self.icons.folder_mission_selection = {}
	self.icons.folder_mission_selection.texture = "ui/atlas/menu/raid_atlas_papers_2"
	self.icons.folder_mission_selection.texture_rect = {
		598,
		2,
		268,
		384,
	}
end

function GuiTweakData:_setup_standalone_op_icons()
	local HD = "ui/updates/upd_oops/atlas_operations_large"
	local LQ = "ui/updates/upd_oops/atlas_operations_small"

	self.icons.op_empty_slot_lq = {
		texture = LQ,
		texture_rect = {
			0,
			0,
			56,
			56,
		},
	}
	self.icons.op_empty_slot_hd = {
		texture = HD,
		texture_rect = {
			0,
			0,
			224,
			224,
		},
	}
	self.icons.op_blank_lq = {
		texture = LQ,
		texture_rect = {
			56,
			0,
			56,
			56,
		},
	}
	self.icons.op_blank_hd = {
		texture = HD,
		texture_rect = {
			224,
			0,
			224,
			224,
		},
	}
	self.icons.op_rhinegold_lq = {
		texture = LQ,
		texture_rect = {
			112,
			0,
			56,
			56,
		},
	}
	self.icons.op_rhinegold_hd = {
		texture = HD,
		texture_rect = {
			448,
			0,
			224,
			224,
		},
	}
	self.icons.op_clear_skies_lq = {
		texture = LQ,
		texture_rect = {
			168,
			0,
			56,
			56,
		},
	}
	self.icons.op_clear_skies_hd = {
		texture = HD,
		texture_rect = {
			672,
			0,
			224,
			224,
		},
	}
	self.icons.op_free_play_lq = {
		texture = LQ,
		texture_rect = {
			0,
			56,
			56,
			56,
		},
	}
	self.icons.op_free_play_hd = {
		texture = HD,
		texture_rect = {
			0,
			224,
			224,
			224,
		},
	}
	self.icons.op_random_short_lq = {
		texture = LQ,
		texture_rect = {
			56,
			56,
			56,
			56,
		},
	}
	self.icons.op_random_short_hd = {
		texture = HD,
		texture_rect = {
			224,
			224,
			224,
			224,
		},
	}
	self.icons.op_random_medium_lq = {
		texture = LQ,
		texture_rect = {
			112,
			56,
			56,
			56,
		},
	}
	self.icons.op_random_medium_hd = {
		texture = HD,
		texture_rect = {
			448,
			224,
			224,
			224,
		},
	}
	self.icons.op_random_long_lq = {
		texture = LQ,
		texture_rect = {
			168,
			56,
			56,
			56,
		},
	}
	self.icons.op_random_long_hd = {
		texture = HD,
		texture_rect = {
			672,
			224,
			224,
			224,
		},
	}
end

function GuiTweakData:_setup_nine_rect_icons()
	local function make_nine_rect(nine_rect_id, texture, texture_rect, edge_rect)
		if type(edge_rect) == "number" then
			edge_rect = {
				edge_rect,
				edge_rect,
				edge_rect,
				edge_rect,
			}
		end

		local x_left = texture_rect[1]
		local x_center = x_left + edge_rect[1]
		local x_right = x_left + texture_rect[3] - edge_rect[3]
		local y_top = texture_rect[2]
		local y_center = y_top + edge_rect[2]
		local y_bottom = y_top + texture_rect[3] - edge_rect[3]
		local w_left = edge_rect[1]
		local w_right = edge_rect[3]
		local w_center = texture_rect[3] - w_left - w_right
		local h_top = edge_rect[2]
		local h_bottom = edge_rect[4]
		local h_center = texture_rect[4] - h_top - h_bottom

		self.icons[nine_rect_id .. "_top"] = {
			texture = texture,
			texture_rect = {
				x_center,
				y_top,
				w_center,
				h_top,
			},
		}
		self.icons[nine_rect_id .. "_bottom"] = {
			texture = texture,
			texture_rect = {
				x_center,
				y_bottom,
				w_center,
				h_bottom,
			},
		}
		self.icons[nine_rect_id .. "_left"] = {
			texture = texture,
			texture_rect = {
				x_left,
				y_center,
				w_left,
				h_center,
			},
		}
		self.icons[nine_rect_id .. "_right"] = {
			texture = texture,
			texture_rect = {
				x_right,
				y_center,
				w_right,
				h_center,
			},
		}
		self.icons[nine_rect_id .. "_top_left"] = {
			texture = texture,
			texture_rect = {
				x_left,
				y_top,
				w_left,
				h_top,
			},
		}
		self.icons[nine_rect_id .. "_top_right"] = {
			texture = texture,
			texture_rect = {
				x_right,
				y_top,
				w_right,
				h_top,
			},
		}
		self.icons[nine_rect_id .. "_bottom_left"] = {
			texture = texture,
			texture_rect = {
				x_left,
				y_bottom,
				w_left,
				h_bottom,
			},
		}
		self.icons[nine_rect_id .. "_bottom_right"] = {
			texture = texture,
			texture_rect = {
				x_right,
				y_bottom,
				w_right,
				h_bottom,
			},
		}
		self.icons[nine_rect_id .. "_center"] = {
			texture = texture,
			texture_rect = {
				x_center,
				y_center,
				w_center,
				h_center,
			},
		}
	end

	make_nine_rect("dialog_rect", "ui/atlas/menu/raid_atlas_menu_2", {
		80,
		0,
		48,
		48,
	}, 16)
end

function GuiTweakData:_setup_old_tweak_data()
	self.suspicion_to_visibility = {}
	self.suspicion_to_visibility[1] = {}
	self.suspicion_to_visibility[1].name_id = "bm_menu_concealment_low"
	self.suspicion_to_visibility[1].max_index = 9
	self.suspicion_to_visibility[2] = {}
	self.suspicion_to_visibility[2].name_id = "bm_menu_concealment_medium"
	self.suspicion_to_visibility[2].max_index = 20
	self.suspicion_to_visibility[3] = {}
	self.suspicion_to_visibility[3].name_id = "bm_menu_concealment_high"
	self.suspicion_to_visibility[3].max_index = 30
	self.mouse_pointer = {}
	self.mouse_pointer.controller = {}
	self.mouse_pointer.controller.acceleration_speed = 4
	self.mouse_pointer.controller.max_acceleration = 3
	self.mouse_pointer.controller.mouse_pointer_speed = 125

	local min_amount_weapons = 72

	self.WEAPON_ROWS_PER_PAGE = 4
	self.WEAPON_COLUMNS_PER_PAGE = 4
	self.MAX_WEAPON_PAGES = math.ceil(min_amount_weapons / (self.WEAPON_ROWS_PER_PAGE * self.WEAPON_COLUMNS_PER_PAGE))
	self.MAX_WEAPON_SLOTS = self.MAX_WEAPON_PAGES * self.WEAPON_ROWS_PER_PAGE * self.WEAPON_COLUMNS_PER_PAGE
	self.server_browser = {}
	self.server_browser.max_active_jobs = 0
	self.server_browser.active_job_time = 925
	self.server_browser.new_job_min_time = 1.5
	self.server_browser.new_job_max_time = 3.5
	self.server_browser.refresh_servers_time = 5
	self.server_browser.total_active_jobs = 50
	self.server_browser.max_active_server_jobs = 100
	self.stats_present_multiplier = 10
end
