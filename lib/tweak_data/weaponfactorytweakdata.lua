local ids_unit = Idstring("unit")

function preload_all()
	for id, part in pairs(tweak_data.weapon.factory.parts) do
		if part.third_unit then
			local ids_unit_name = Idstring(part.third_unit)

			managers.dyn_resource:load(ids_unit, ids_unit_name, "packages/dyn_resources", false)
		else
			print(id, "didn't have third")
		end
	end
end

function preload_all_units()
	for id, part in pairs(tweak_data.weapon.factory) do
		if part.unit then
			local ids_unit_name = Idstring(part.unit)

			managers.dyn_resource:load(ids_unit, ids_unit_name, "packages/dyn_resources", false)
		else
			print(id, "didn't have unit")
		end
	end
end

function print_package_strings_unit()
	for id, part in pairs(tweak_data.weapon.factory) do
		if part.unit then
			print("<unit name=\"" .. part.unit .. "\"/>")
		end
	end
end

function print_package_strings_part_unit()
	for id, part in pairs(tweak_data.weapon.factory.parts) do
		if part.unit then
			local f = SystemFS:open(id .. ".package", "w")

			f:puts("<package>")
			f:puts("\t<units>")
			f:puts("\t\t<unit name=\"" .. part.unit .. "\"/>")
			f:puts("\t</units>")
			f:puts("</package>")
			SystemFS:close(f)
		end
	end
end

function preload_all_first()
	for id, part in pairs(tweak_data.weapon.factory.parts) do
		if part.unit then
			local ids_unit_name = Idstring(part.unit)

			managers.dyn_resource:load(ids_unit, ids_unit_name, "packages/dyn_resources", false)
		else
			print(id, "didn't have unit")
		end
	end
end

function print_package_strings()
	for id, part in pairs(tweak_data.weapon.factory.parts) do
		if part.third_unit then
			print("<unit name=\"" .. part.third_unit .. "\"/>")
		end
	end
end

function print_parts_without_texture()
	Application:debug("print_parts_without_texture")

	for id, part in pairs(tweak_data.weapon.factory.parts) do
		if part.pcs then
			local guis_catalog = "guis/"
			local bundle_folder = part.texture_bundle_folder

			if bundle_folder then
				guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
			end

			guis_catalog = guis_catalog .. "textures/pd2/blackmarket/icons/mods/"

			if not DB:has(Idstring("texture"), guis_catalog .. id) then
				print(guis_catalog .. id)
			end
		end
	end

	Application:debug("---------------------------")
end

local is_win_32 = SystemInfo:platform() == Idstring("WIN32")
local is_not_win_32 = not is_win_32

WeaponFactoryTweakData = WeaponFactoryTweakData or class()

function WeaponFactoryTweakData:init()
	self.parts = {}

	self:_init_base_parts_for_cloning()
	self:_init_silencers()
	self:_init_nozzles()
	self:_init_gadgets()
	self:_init_vertical_grips()
	self:_init_sights()
	self:_init_m1911()
	self:_init_webley()
	self:_init_thompson()
	self:_init_sten()
	self:_init_garand()
	self:_init_garand_golden()
	self:_init_m1918()
	self:_init_m1903()
	self:_init_m1912()
	self:_init_mp38()
	self:_init_mp44()
	self:_init_carbine()
	self:_init_welrod()
	self:_init_mg42()
	self:_init_c96()
	self:_init_mosin()
	self:_init_sterling()
	self:_init_geco()
	self:create_ammunition()
	self:_init_content_unfinished()
	self:_cleanup_unfinished_content()
	self:_cleanup_unfinished_parts()
end

function WeaponFactoryTweakData:_init_silencers()
	return
end

function WeaponFactoryTweakData:_init_nozzles()
	return
end

function WeaponFactoryTweakData:_init_gadgets()
	return
end

function WeaponFactoryTweakData:_init_vertical_grips()
	return
end

function WeaponFactoryTweakData:_init_sights()
	return
end

function WeaponFactoryTweakData:_init_content_unfinished()
	return
end

function WeaponFactoryTweakData:_cleanup_unfinished_content()
	return
end

function WeaponFactoryTweakData:_cleanup_unfinished_parts()
	return
end

function WeaponFactoryTweakData:_init_base_parts_for_cloning()
	return
end

function WeaponFactoryTweakData:_init_thompson()
	self.parts.wpn_fps_smg_thompson_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_smg_thompson_b_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_b_standard",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_b_m1928 = {
		a_obj = "a_b",
		name_id = "bm_wp_smg_thompson_b_m1928",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_b_m1928",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_b_m1928",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_thompson_body_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_body_standard",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_body_m1928 = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_thompson_body_m1928",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_body_m1928",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_body_m1928",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_o_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_thompson_o_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_o_standard",
		type = "sight",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_o_standard",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_o_m1928 = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_thompson_o_m1928",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_o_m1928",
		type = "sight",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_o_m1928",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_thompson_m_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_m_standard",
		bullet_objects = {
			amount = 4,
			prefix = "g_bullet_",
		},
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_m_standard_double = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_thompson_m_standard_double",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_m_standard_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_m_standard_double",
		bullet_objects = {
			amount = 4,
			prefix = "g_bullet_",
		},
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_m_drum = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_thompson_m_drum",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_m_drum",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_m_drum",
		bullet_objects = {
			amount = 3,
			prefix = "g_bullet_",
		},
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_m_short = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_thompson_m_short",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_m_short",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_m_short",
		bullet_objects = {
			amount = 4,
			prefix = "g_bullet_",
		},
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_m_short_double = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_thompson_m_short_double",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_m_short_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_m_short_double",
		bullet_objects = {
			amount = 4,
			prefix = "g_bullet_",
		},
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_smg_thompson_dh_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_dh_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_dh_standard",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_dh_m1928 = {
		a_obj = "a_dh",
		name_id = "bm_wp_smg_thompson_dh_m1928",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_dh_m1928",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_dh_m1928",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_extra_sling = {
		a_obj = "a_extra",
		name_id = "bm_wp_smg_thompson_extra_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_extra_sling",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_extra_sling",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_fg_standard = {
		a_obj = "a_fg",
		name_id = "bm_wp_smg_thompson_fg_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_fg_standard",
		type = "foregrip",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_fg_standard",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_fg_m1928 = {
		a_obj = "a_fg",
		name_id = "bm_wp_smg_thompson_fg_m1928",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_fg_m1928",
		type = "foregrip",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_fg_m1928",
		forbids = {
			"wpn_fps_smg_thompson_extra_sling",
		},
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_release_standard = {
		a_obj = "a_release",
		name_id = "bm_wp_smg_thompson_release_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_release_standard",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_release_standard",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_smg_thompson_s_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_s_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_s_standard",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_g_standard = {
		a_obj = "a_g",
		name_id = "bm_wp_smg_thompson_g_standard",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_g_standard",
		type = "grip",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_g_standard",
		stats = {
			value = 0,
		},
	}
	self.parts.wpn_fps_smg_thompson_ns_cutts = {
		a_obj = "a_ns",
		name_id = "bm_wp_smg_thompson_g_ns_cutts",
		parent = "barrel",
		third_unit = "units/vanilla/weapons/wpn_third_smg_thompson_pts/wpn_third_smg_thompson_ns_cutts",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_smg_thompson_pts/wpn_fps_smg_thompson_ns_cutts",
		stats = {
			value = 0,
		},
	}
	self.wpn_fps_smg_thompson = {}
	self.wpn_fps_smg_thompson.unit = "units/vanilla/weapons/wpn_fps_smg_thompson/wpn_fps_smg_thompson"
	self.wpn_fps_smg_thompson.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_smg_thompson.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_smg_thompson.override = {
		wpn_fps_smg_thompson_ns_cutts = {
			parent = "barrel",
		},
	}
	self.wpn_fps_smg_thompson.default_blueprint = {
		"wpn_fps_smg_thompson_body_standard",
		"wpn_fps_smg_thompson_s_standard",
		"wpn_fps_smg_thompson_b_standard",
		"wpn_fps_smg_thompson_m_short",
		"wpn_fps_smg_thompson_dh_standard",
		"wpn_fps_smg_thompson_extra_sling",
		"wpn_fps_smg_thompson_fg_standard",
		"wpn_fps_smg_thompson_release_standard",
		"wpn_fps_smg_thompson_g_standard",
		"wpn_fps_smg_thompson_o_standard",
	}
	self.wpn_fps_smg_thompson.uses_parts = {
		"wpn_fps_smg_thompson_body_standard",
		"wpn_fps_smg_thompson_s_standard",
		"wpn_fps_smg_thompson_b_standard",
		"wpn_fps_smg_thompson_m_short",
		"wpn_fps_smg_thompson_dh_standard",
		"wpn_fps_smg_thompson_extra_sling",
		"wpn_fps_smg_thompson_fg_standard",
		"wpn_fps_smg_thompson_release_standard",
		"wpn_fps_smg_thompson_g_standard",
		"wpn_fps_smg_thompson_o_standard",
		"wpn_fps_smg_thompson_b_m1928",
		"wpn_fps_smg_thompson_body_m1928",
		"wpn_fps_smg_thompson_o_m1928",
		"wpn_fps_smg_thompson_m_short_double",
		"wpn_fps_smg_thompson_m_standard",
		"wpn_fps_smg_thompson_m_standard_double",
		"wpn_fps_smg_thompson_m_drum",
		"wpn_fps_smg_thompson_fg_m1928",
		"wpn_fps_smg_thompson_ns_cutts",
		"wpn_fps_smg_thompson_dh_m1928",
	}
	self.wpn_fps_smg_thompson_npc = deep_clone(self.wpn_fps_smg_thompson)
	self.wpn_fps_smg_thompson_npc.unit = "units/vanilla/weapons/wpn_fps_smg_thompson/wpn_fps_smg_thompson_npc"
end

function WeaponFactoryTweakData:_init_sten()
	self.parts.wpn_fps_smg_sten_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_smg_sten_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_o_lee_enfield = {
		a_obj = "a_b",
		name_id = "bm_wp_smg_sten_o_lee_enfield",
		type = "sight",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_o_lee_enfield",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_ns_slanted = {
		a_obj = "a_ns",
		name_id = "bm_wp_smg_sten_ns_slanted",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_ns_slanted",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_sten_body_standard",
		type = "upper_receiver",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_body_mk3 = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_sten_body_mk3",
		type = "upper_receiver",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_body_mk3",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_body_mk3_vented = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_sten_body_mk3_vented",
		type = "upper_receiver",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_body_mk3_vented",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_sten_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_m_standard",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_m_standard_double = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_sten_m_standard_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_m_standard_double",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_m_long = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_sten_m_long",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_m_long",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_m_long_double = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_sten_m_long_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_m_long_double",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_m_short = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_sten_m_short",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_m_short",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_smg_sten_dh_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_smg_sten_s_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_s_wooden = {
		a_obj = "a_s",
		name_id = "bm_wp_smg_sten_s_wooden",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_s_wooden",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_fg_wooden = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_sten_fg_wooden",
		type = "foregrip",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_fg_wooden",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_g_wooden = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_sten_g_wooden",
		type = "grip",
		unit = "units/vanilla/weapons/wpn_fps_smg_sten_pts/wpn_fps_smg_sten_g_wooden",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sten_b_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_b_standard"
	self.parts.wpn_fps_smg_sten_o_lee_enfield.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_o_lee_enfield"
	self.parts.wpn_fps_smg_sten_ns_slanted.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_ns_slanted"
	self.parts.wpn_fps_smg_sten_body_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_body_standard"
	self.parts.wpn_fps_smg_sten_body_mk3.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_body_mk3"
	self.parts.wpn_fps_smg_sten_body_mk3_vented.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_body_mk3_vented"
	self.parts.wpn_fps_smg_sten_m_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_m_standard"
	self.parts.wpn_fps_smg_sten_m_standard_double.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_m_standard_double"
	self.parts.wpn_fps_smg_sten_m_long.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_m_long"
	self.parts.wpn_fps_smg_sten_m_long_double.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_m_long_double"
	self.parts.wpn_fps_smg_sten_m_short.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_m_short"
	self.parts.wpn_fps_smg_sten_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_dh_standard"
	self.parts.wpn_fps_smg_sten_s_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_s_standard"
	self.parts.wpn_fps_smg_sten_s_wooden.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_s_wooden"
	self.parts.wpn_fps_smg_sten_fg_wooden.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_fg_wooden"
	self.parts.wpn_fps_smg_sten_g_wooden.third_unit = "units/vanilla/weapons/wpn_third_smg_sten_pts/wpn_third_smg_sten_g_wooden"
	self.wpn_fps_smg_sten = {}
	self.wpn_fps_smg_sten.unit = "units/vanilla/weapons/wpn_fps_smg_sten/wpn_fps_smg_sten"
	self.wpn_fps_smg_sten.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_smg_sten.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_smg_sten.default_blueprint = {
		"wpn_fps_smg_sten_body_standard",
		"wpn_fps_smg_sten_b_standard",
		"wpn_fps_smg_sten_m_short",
		"wpn_fps_smg_sten_dh_standard",
		"wpn_fps_smg_sten_s_standard",
	}
	self.wpn_fps_smg_sten.uses_parts = {
		"wpn_fps_smg_sten_body_standard",
		"wpn_fps_smg_sten_b_standard",
		"wpn_fps_smg_sten_m_short",
		"wpn_fps_smg_sten_dh_standard",
		"wpn_fps_smg_sten_s_standard",
		"wpn_fps_smg_sten_m_standard",
		"wpn_fps_smg_sten_m_standard_double",
		"wpn_fps_smg_sten_m_long",
		"wpn_fps_smg_sten_m_long_double",
		"wpn_fps_smg_sten_s_wooden",
		"wpn_fps_smg_sten_fg_wooden",
		"wpn_fps_smg_sten_g_wooden",
		"wpn_fps_smg_sten_ns_slanted",
		"wpn_fps_smg_sten_body_mk3",
		"wpn_fps_smg_sten_body_mk3_vented",
		"wpn_fps_smg_sten_o_lee_enfield",
	}
	self.wpn_fps_smg_sten_npc = deep_clone(self.wpn_fps_smg_sten)
	self.wpn_fps_smg_sten_npc.unit = "units/vanilla/weapons/wpn_fps_smg_sten/wpn_fps_smg_sten_npc"
end

function WeaponFactoryTweakData:_init_garand()
	self.parts.wpn_fps_ass_garand_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_ass_garand_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_b_tanker = {
		a_obj = "a_b",
		name_id = "bm_wp_ass_garand_b_tanker",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_b_tanker",
		forbids = {
			"wpn_fps_ass_garand_extra_swiwel",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_garand_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_ns_conical = {
		a_obj = "a_ns",
		name_id = "bm_wp_ass_garand_ns_conical",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_ns_conical",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_ass_garand_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_m_standard",
		bullet_objects = {
			amount = 8,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_m_bar_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_garand_m_bar_standard",
		type = "magazine_ext",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_m_bar_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_m_bar_extended = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_garand_m_bar_extended",
		type = "magazine_ext",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_m_bar_extended",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_bolt_standard = {
		a_obj = "a_bolt",
		name_id = "bm_wp_ass_garand_bolt_standard",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_bolt_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_ass_garand_dh_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_extra_swiwel = {
		a_obj = "a_extra",
		name_id = "bm_wp_ass_garand_extra_swiwel",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_extra_swiwel",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_extra1_swiwel = {
		a_obj = "a_extra1",
		name_id = "bm_wp_ass_garand_extra1_swiwel",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_extra1_swiwel",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_ass_garand_s_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_s_folding = {
		a_obj = "a_s",
		name_id = "bm_wp_ass_garand_s_folding",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_s_folding",
		forbids = {
			"wpn_fps_ass_garand_s_cheek_rest",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_s_cheek_rest = {
		a_obj = "a_s",
		name_id = "bm_wp_ass_garand_s_cheek_rest",
		type = "stock_ext",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_s_cheek_rest",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_strip_standard = {
		a_obj = "a_strip",
		name_id = "bm_wp_ass_garand_strip_standard",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_strip_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_b_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_b_standard"
	self.parts.wpn_fps_ass_garand_b_tanker.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_b_tanker"
	self.parts.wpn_fps_ass_garand_body_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_body_standard"
	self.parts.wpn_fps_ass_garand_ns_conical.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_ns_conical"
	self.parts.wpn_fps_ass_garand_m_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_m_standard"
	self.parts.wpn_fps_ass_garand_m_bar_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_m_bar_standard"
	self.parts.wpn_fps_ass_garand_m_bar_extended.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_m_bar_extended"
	self.parts.wpn_fps_ass_garand_bolt_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_bolt_standard"
	self.parts.wpn_fps_ass_garand_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_dh_standard"
	self.parts.wpn_fps_ass_garand_extra_swiwel.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_extra_swiwel"
	self.parts.wpn_fps_ass_garand_extra1_swiwel.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_extra1_swiwel"
	self.parts.wpn_fps_ass_garand_s_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_s_standard"
	self.parts.wpn_fps_ass_garand_s_folding.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_s_folding"
	self.parts.wpn_fps_ass_garand_s_cheek_rest.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_s_cheek_rest"
	self.parts.wpn_fps_ass_garand_strip_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_strip_standard"
	self.wpn_fps_ass_garand = {}
	self.wpn_fps_ass_garand.unit = "units/vanilla/weapons/wpn_fps_ass_garand/wpn_fps_ass_garand"
	self.wpn_fps_ass_garand.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_ass_garand.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_ass_garand.default_blueprint = {
		"wpn_fps_ass_garand_body_standard",
		"wpn_fps_ass_garand_b_standard",
		"wpn_fps_ass_garand_m_standard",
		"wpn_fps_ass_garand_bolt_standard",
		"wpn_fps_ass_garand_dh_standard",
		"wpn_fps_ass_garand_extra_swiwel",
		"wpn_fps_ass_garand_extra1_swiwel",
		"wpn_fps_ass_garand_s_standard",
		"wpn_fps_ass_garand_strip_standard",
	}
	self.wpn_fps_ass_garand.uses_parts = {
		"wpn_fps_ass_garand_body_standard",
		"wpn_fps_ass_garand_b_standard",
		"wpn_fps_ass_garand_m_standard",
		"wpn_fps_ass_garand_bolt_standard",
		"wpn_fps_ass_garand_dh_standard",
		"wpn_fps_ass_garand_extra_swiwel",
		"wpn_fps_ass_garand_extra1_swiwel",
		"wpn_fps_ass_garand_s_standard",
		"wpn_fps_ass_garand_strip_standard",
		"wpn_fps_ass_garand_ns_conical",
		"wpn_fps_ass_garand_b_tanker",
		"wpn_fps_ass_garand_s_cheek_rest",
		"wpn_fps_ass_garand_s_folding",
		"wpn_fps_ass_garand_m_bar_standard",
		"wpn_fps_ass_garand_m_bar_extended",
	}
	self.wpn_fps_ass_garand_npc = deep_clone(self.wpn_fps_ass_garand)
	self.wpn_fps_ass_garand_npc.unit = "units/vanilla/weapons/wpn_fps_ass_garand/wpn_fps_ass_garand_npc"
end

function WeaponFactoryTweakData:_init_garand_golden()
	self.parts.wpn_fps_ass_garand_golden_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_ass_garand_golden_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_b_tanker = {
		a_obj = "a_b",
		name_id = "bm_wp_ass_garand_golden_b_tanker",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_b_tanker",
		forbids = {
			"wpn_fps_ass_garand_golden_extra_swiwel",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_garand_golden_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_ns_conical = {
		a_obj = "a_ns",
		name_id = "bm_wp_ass_garand_golden_ns_conical",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_ns_conical",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_ass_garand_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_m_standard",
		bullet_objects = {
			amount = 8,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_m_bar_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_garand_golden_m_bar_standard",
		type = "magazine_ext",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_m_bar_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_m_bar_extended = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_garand_golden_m_bar_extended",
		type = "magazine_ext",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_m_bar_extended",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_bolt_standard = {
		a_obj = "a_bolt",
		name_id = "bm_wp_ass_garand_golden_bolt_standard",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_bolt_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_ass_garand_golden_dh_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_extra_swiwel = {
		a_obj = "a_extra",
		name_id = "bm_wp_ass_garand_golden_extra_swiwel",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_extra_swiwel",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_extra1_swiwel = {
		a_obj = "a_extra1",
		name_id = "bm_wp_ass_garand_golden_extra1_swiwel",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_extra1_swiwel",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_ass_garand_golden_s_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_s_folding = {
		a_obj = "a_s",
		name_id = "bm_wp_ass_garand_golden_s_folding",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_s_folding",
		forbids = {
			"wpn_fps_ass_garand_s_cheek_rest",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_s_cheek_rest = {
		a_obj = "a_s",
		name_id = "bm_wp_ass_garand_s_cheek_rest",
		type = "stock_ext",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_s_cheek_rest",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_strip_standard = {
		a_obj = "a_strip",
		name_id = "bm_wp_ass_garand_golden_strip_standard",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_ass_garand_pts/wpn_fps_ass_garand_golden_strip_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_garand_golden_b_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_b_standard"
	self.parts.wpn_fps_ass_garand_golden_b_tanker.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_b_tanker"
	self.parts.wpn_fps_ass_garand_golden_body_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_body_standard"
	self.parts.wpn_fps_ass_garand_golden_ns_conical.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_ns_conical"
	self.parts.wpn_fps_ass_garand_m_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_m_standard"
	self.parts.wpn_fps_ass_garand_golden_m_bar_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_m_bar_standard"
	self.parts.wpn_fps_ass_garand_golden_m_bar_extended.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_m_bar_extended"
	self.parts.wpn_fps_ass_garand_golden_bolt_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_bolt_standard"
	self.parts.wpn_fps_ass_garand_golden_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_dh_standard"
	self.parts.wpn_fps_ass_garand_golden_extra_swiwel.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_extra_swiwel"
	self.parts.wpn_fps_ass_garand_golden_extra1_swiwel.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_extra1_swiwel"
	self.parts.wpn_fps_ass_garand_golden_s_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_s_standard"
	self.parts.wpn_fps_ass_garand_golden_s_folding.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_s_folding"
	self.parts.wpn_fps_ass_garand_s_cheek_rest.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_s_cheek_rest"
	self.parts.wpn_fps_ass_garand_golden_strip_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_garand_pts/wpn_third_ass_garand_golden_strip_standard"
	self.wpn_fps_ass_garand_golden = {}
	self.wpn_fps_ass_garand_golden.unit = "units/vanilla/weapons/wpn_fps_ass_garand/wpn_fps_ass_garand_golden"
	self.wpn_fps_ass_garand_golden.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_ass_garand_golden.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_ass_garand_golden.default_blueprint = {
		"wpn_fps_ass_garand_golden_body_standard",
		"wpn_fps_ass_garand_golden_b_standard",
		"wpn_fps_ass_garand_m_standard",
		"wpn_fps_ass_garand_golden_bolt_standard",
		"wpn_fps_ass_garand_golden_dh_standard",
		"wpn_fps_ass_garand_golden_extra_swiwel",
		"wpn_fps_ass_garand_golden_extra1_swiwel",
		"wpn_fps_ass_garand_golden_s_standard",
		"wpn_fps_ass_garand_golden_strip_standard",
	}
	self.wpn_fps_ass_garand_golden.uses_parts = {
		"wpn_fps_ass_garand_golden_body_standard",
		"wpn_fps_ass_garand_golden_b_standard",
		"wpn_fps_ass_garand_m_standard",
		"wpn_fps_ass_garand_golden_bolt_standard",
		"wpn_fps_ass_garand_golden_dh_standard",
		"wpn_fps_ass_garand_golden_extra_swiwel",
		"wpn_fps_ass_garand_golden_extra1_swiwel",
		"wpn_fps_ass_garand_golden_s_standard",
		"wpn_fps_ass_garand_golden_strip_standard",
		"wpn_fps_ass_garand_golden_ns_conical",
		"wpn_fps_ass_garand_golden_b_tanker",
		"wpn_fps_ass_garand_s_cheek_rest",
		"wpn_fps_ass_garand_golden_s_folding",
		"wpn_fps_ass_garand_golden_m_bar_standard",
		"wpn_fps_ass_garand_golden_m_bar_extended",
	}
	self.wpn_fps_ass_garand_golden_npc = deep_clone(self.wpn_fps_ass_garand_golden)
	self.wpn_fps_ass_garand_golden_npc.unit = "units/vanilla/weapons/wpn_fps_ass_garand/wpn_fps_ass_garand_golden_npc"
end

function WeaponFactoryTweakData:_init_m1918()
	self.parts.wpn_fps_lmg_m1918_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_lmg_m1918_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_ns_standard = {
		a_obj = "a_ns",
		name_id = "bm_wp_lmg_m1918_ns_standard",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_ns_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_ns_cutts = {
		a_obj = "a_ns",
		name_id = "bm_wp_lmg_m1918_ns_cutts",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_ns_cutts",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_lmg_m1918_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_carry_handle = {
		a_obj = "a_body",
		name_id = "bm_wp_lmg_m1918_carry_handle",
		type = "handle",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_carry_handle",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_bipod = {
		a_obj = "a_bp",
		name_id = "bm_wp_lmg_m1918_bipod",
		parent = "barrel",
		type = "bipod",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_bipod",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_g_monitor = {
		a_obj = "a_body",
		name_id = "bm_wp_lmg_m1918_g_monitor",
		type = "grip",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_g_monitor",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_lmg_m1918_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_m_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_m_extended = {
		a_obj = "a_m",
		name_id = "bm_wp_lmg_m1918_m_extended",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_m_extended",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_lmg_m1918_dh_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_lmg_m1918_pts/wpn_fps_lmg_m1918_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_m1918_b_standard.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_b_standard"
	self.parts.wpn_fps_lmg_m1918_ns_standard.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_ns_standard"
	self.parts.wpn_fps_lmg_m1918_ns_cutts.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_ns_cutts"
	self.parts.wpn_fps_lmg_m1918_body_standard.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_body_standard"
	self.parts.wpn_fps_lmg_m1918_carry_handle.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_carry_handle"
	self.parts.wpn_fps_lmg_m1918_bipod.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_bipod"
	self.parts.wpn_fps_lmg_m1918_g_monitor.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_g_monitor"
	self.parts.wpn_fps_lmg_m1918_m_standard.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_m_standard"
	self.parts.wpn_fps_lmg_m1918_m_extended.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_m_extended"
	self.parts.wpn_fps_lmg_m1918_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_lmg_m1918_pts/wpn_third_lmg_m1918_dh_standard"
	self.wpn_fps_lmg_m1918 = {}
	self.wpn_fps_lmg_m1918.unit = "units/vanilla/weapons/wpn_fps_lmg_m1918/wpn_fps_lmg_m1918"
	self.wpn_fps_lmg_m1918.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_lmg_m1918.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_lmg_m1918.default_blueprint = {
		"wpn_fps_lmg_m1918_body_standard",
		"wpn_fps_lmg_m1918_b_standard",
		"wpn_fps_lmg_m1918_ns_standard",
		"wpn_fps_lmg_m1918_m_standard",
		"wpn_fps_lmg_m1918_dh_standard",
	}
	self.wpn_fps_lmg_m1918.uses_parts = {
		"wpn_fps_lmg_m1918_body_standard",
		"wpn_fps_lmg_m1918_b_standard",
		"wpn_fps_lmg_m1918_ns_standard",
		"wpn_fps_lmg_m1918_m_standard",
		"wpn_fps_lmg_m1918_dh_standard",
		"wpn_fps_lmg_m1918_ns_cutts",
		"wpn_fps_lmg_m1918_g_monitor",
		"wpn_fps_lmg_m1918_m_extended",
		"wpn_fps_lmg_m1918_carry_handle",
		"wpn_fps_lmg_m1918_bipod",
	}
	self.wpn_fps_lmg_m1918_npc = deep_clone(self.wpn_fps_lmg_m1918)
	self.wpn_fps_lmg_m1918_npc.unit = "units/vanilla/weapons/wpn_fps_lmg_m1918/wpn_fps_lmg_m1918_npc"
end

function WeaponFactoryTweakData:_init_m1903()
	self.parts.wpn_fps_snp_m1903_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_snp_m1903_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_body_type_s = {
		a_obj = "a_body",
		name_id = "bm_wp_snp_m1903_body_type_s",
		type = "body",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_body_type_s",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_body_type_c = {
		a_obj = "a_body",
		name_id = "bm_wp_snp_m1903_body_type_c",
		type = "body",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_body_type_c",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_s_cheek_rest = {
		a_obj = "a_body",
		name_id = "bm_wp_snp_m1903_s_cheek_rest",
		type = "stock_ext",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_s_cheek_rest",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_bolt_firepin = {
		a_obj = "a_firepin",
		name_id = "bm_wp_snp_m1903_m_standard",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_bolt_firepin",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_bolt_standard = {
		a_obj = "a_bolt",
		name_id = "bm_wp_snp_m1903_m_standard",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_bolt_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_snp_m1903_m_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_extra_follower = {
		a_obj = "a_follower",
		name_id = "bm_wp_snp_m1903_m_standard",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_extra_follower",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_snp_m1903_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_m_standard",
		animations = {
			fire = "recoil",
			fire_steelsight = "recoil",
			reload_enter = "reload_enter",
			reload_exit = "reload_exit",
			reload_not_empty_exit = "reload_exit",
		},
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_m_extended = {
		a_obj = "a_m",
		name_id = "bm_wp_snp_m1903_m_standard",
		parent = "body",
		type = "magazine_ext",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_m_extended",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_ns_mclean = {
		a_obj = "a_ns",
		name_id = "bm_wp_snp_m1903_ns_mclean",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_ns_mclean",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_m1903_o_scope = {
		a_obj = "a_o",
		name_id = "bm_wp_snp_m1903_o_scope",
		reticle_obj = "g_reticle_1",
		type = "scope",
		unit = "units/vanilla/weapons/wpn_fps_snp_m1903_pts/wpn_fps_snp_m1903_o_scope",
		stance_mod = {
			wpn_fps_snp_m1903 = {
				lens_distortion_power = 1.04,
				translation = Vector3(0.015, -30, -1.665),
			},
		},
		stats = {
			value = 1,
			zoom = 10,
		},
	}
	self.parts.wpn_fps_snp_m1903_b_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_b_standard"
	self.parts.wpn_fps_snp_m1903_body_type_s.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_body_type_s"
	self.parts.wpn_fps_snp_m1903_body_type_c.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_body_type_c"
	self.parts.wpn_fps_snp_m1903_s_cheek_rest.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_s_cheek_rest"
	self.parts.wpn_fps_snp_m1903_bolt_firepin.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_bolt_firepin"
	self.parts.wpn_fps_snp_m1903_bolt_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_bolt_standard"
	self.parts.wpn_fps_snp_m1903_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_dh_standard"
	self.parts.wpn_fps_snp_m1903_extra_follower.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_extra_follower"
	self.parts.wpn_fps_snp_m1903_m_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_m_standard"
	self.parts.wpn_fps_snp_m1903_m_extended.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_m_extended"
	self.parts.wpn_fps_snp_m1903_ns_mclean.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_ns_mclean"
	self.parts.wpn_fps_snp_m1903_o_scope.third_unit = "units/vanilla/weapons/wpn_third_snp_m1903_pts/wpn_third_snp_m1903_o_scope"
	self.wpn_fps_snp_m1903 = {}
	self.wpn_fps_snp_m1903.unit = "units/vanilla/weapons/wpn_fps_snp_m1903/wpn_fps_snp_m1903"
	self.wpn_fps_snp_m1903.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_snp_m1903.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload_enter = "reload_enter",
		reload_exit = "reload_exit",
		reload_not_empty_exit = "reload_exit",
	}
	self.wpn_fps_snp_m1903.default_blueprint = {
		"wpn_fps_snp_m1903_body_type_s",
		"wpn_fps_snp_m1903_b_standard",
		"wpn_fps_snp_m1903_bolt_firepin",
		"wpn_fps_snp_m1903_bolt_standard",
		"wpn_fps_snp_m1903_dh_standard",
		"wpn_fps_snp_m1903_extra_follower",
		"wpn_fps_snp_m1903_m_standard",
	}
	self.wpn_fps_snp_m1903.uses_parts = {
		"wpn_fps_snp_m1903_body_type_s",
		"wpn_fps_snp_m1903_b_standard",
		"wpn_fps_snp_m1903_bolt_firepin",
		"wpn_fps_snp_m1903_bolt_standard",
		"wpn_fps_snp_m1903_dh_standard",
		"wpn_fps_snp_m1903_extra_follower",
		"wpn_fps_snp_m1903_m_standard",
		"wpn_fps_snp_m1903_body_type_c",
		"wpn_fps_snp_m1903_s_cheek_rest",
		"wpn_fps_snp_m1903_ns_mclean",
		"wpn_fps_snp_m1903_o_scope",
		"wpn_fps_snp_m1903_m_extended",
	}
	self.wpn_fps_snp_m1903_npc = deep_clone(self.wpn_fps_snp_m1903)
	self.wpn_fps_snp_m1903_npc.unit = "units/vanilla/weapons/wpn_fps_snp_m1903/wpn_fps_snp_m1903_npc"
end

function WeaponFactoryTweakData:_init_m1911()
	self.parts.wpn_fps_pis_m1911_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_pis_m1911_body_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_pis_m1911_b_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_sl_standard = {
		a_obj = "a_sl",
		name_id = "bm_wp_pis_m1911_sl_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_sl_standard",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_sl_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_pis_m1911_m_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_m_standard",
		bullet_objects = {
			amount = 8,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_m_extended = {
		a_obj = "a_m",
		name_id = "bm_wp_pis_m1911_m_extended",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_m_extended",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_m_extended",
		bullet_objects = {
			amount = 3,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_m_banana = {
		a_obj = "a_m",
		name_id = "bm_wp_pis_m1911_m_banana",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_m_banana",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_m_banana",
		bullet_objects = {
			amount = 3,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_dh_hammer = {
		a_obj = "a_dh",
		name_id = "bm_wp_pis_m1911_body_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_dh_hammer",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_dh_hammer",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_ns_cutts = {
		a_obj = "a_ns",
		name_id = "bm_wp_pis_m1911_ns_cutts",
		parent = "barrel",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_ns_cutts",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_ns_cutts",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_fg_tommy = {
		a_obj = "a_body",
		name_id = "bm_wp_pis_m1911_fg_tommy",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_fg_tommy",
		type = "foregrip",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_fg_tommy",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_m1911_s_wooden = {
		a_obj = "a_body",
		name_id = "bm_wp_pis_m1911_s_wooden",
		third_unit = "units/vanilla/weapons/wpn_third_pis_m1911_pts/wpn_third_pis_m1911_s_wooden",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_pis_m1911_pts/wpn_fps_pis_m1911_s_wooden",
		stats = {
			value = 1,
		},
	}
	self.wpn_fps_pis_m1911 = {}
	self.wpn_fps_pis_m1911.unit = "units/vanilla/weapons/wpn_fps_pis_m1911/wpn_fps_pis_m1911"
	self.wpn_fps_pis_m1911.optional_types = {
		"barrel_ext",
		"gadget",
	}
	self.wpn_fps_pis_m1911.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_pis_m1911.default_blueprint = {
		"wpn_fps_pis_m1911_body_standard",
		"wpn_fps_pis_m1911_b_standard",
		"wpn_fps_pis_m1911_sl_standard",
		"wpn_fps_pis_m1911_m_standard",
		"wpn_fps_pis_m1911_dh_hammer",
	}
	self.wpn_fps_pis_m1911.uses_parts = {
		"wpn_fps_pis_m1911_body_standard",
		"wpn_fps_pis_m1911_b_standard",
		"wpn_fps_pis_m1911_sl_standard",
		"wpn_fps_pis_m1911_m_standard",
		"wpn_fps_pis_m1911_dh_hammer",
		"wpn_fps_pis_m1911_m_extended",
		"wpn_fps_pis_m1911_m_banana",
		"wpn_fps_pis_m1911_ns_cutts",
		"wpn_fps_pis_m1911_fg_tommy",
		"wpn_fps_pis_m1911_s_wooden",
	}
	self.wpn_fps_pis_m1911_npc = deep_clone(self.wpn_fps_pis_m1911)
	self.wpn_fps_pis_m1911_npc.unit = "units/vanilla/weapons/wpn_fps_pis_m1911/wpn_fps_pis_m1911_npc"
end

function WeaponFactoryTweakData:_init_geco()
	self.parts.wpn_fps_sho_geco_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_sho_geco_b_standard",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_b_standard",
		type = "barrel",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_b_short = {
		a_obj = "a_b",
		name_id = "bm_wp_sho_geco_b_short",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_b_short",
		type = "barrel",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_b_short",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_sho_geco_s_standard",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_s_standard",
		type = "stock",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_s_cheek_rest = {
		a_obj = "a_s",
		name_id = "bm_wp_sho_geco_s_cheek_rest",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_s_cheek_rest",
		type = "stock",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_s_cheek_rest",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_lock = {
		a_obj = "a_lock",
		name_id = "bm_wp_sho_geco_lock",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_lock",
		type = "lock",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_lock",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_sho_geco_body_standard",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_body_standard",
		type = "lower_receiver",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_shell_1 = {
		a_obj = "a_shell_1",
		name_id = "bm_wp_sho_geco_shell_1",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_shell_1",
		type = "shell_1",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_shell_1",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_shell_2 = {
		a_obj = "a_shell_2",
		name_id = "bm_wp_sho_geco_shell_2",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_shell_2",
		type = "shell_2",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_shell_2",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_trigger_1 = {
		a_obj = "a_trigger_1",
		name_id = "bm_wp_sho_geco_trigger_1",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_trigger_1",
		type = "trigger_1",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_trigger_1",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_geco_trigger_2 = {
		a_obj = "a_trigger_2",
		name_id = "bm_wp_sho_geco_trigger_2",
		third_unit = "units/upd_001/weapons/wpn_third_sho_geco_pts/wpn_third_sho_geco_trigger_2",
		type = "trigger_2",
		unit = "units/upd_001/weapons/wpn_fps_sho_geco_pts/wpn_fps_sho_geco_trigger_2",
		stats = {
			value = 1,
		},
	}
	self.wpn_fps_sho_geco = {}
	self.wpn_fps_sho_geco.unit = "units/upd_001/weapons/wpn_fps_sho_geco/wpn_fps_sho_geco"
	self.wpn_fps_sho_geco.optional_types = {
		"barrel_ext",
		"gadget",
	}
	self.wpn_fps_sho_geco.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_sho_geco.default_blueprint = {
		"wpn_fps_sho_geco_b_standard",
		"wpn_fps_sho_geco_s_standard",
		"wpn_fps_sho_geco_lock",
		"wpn_fps_sho_geco_body_standard",
		"wpn_fps_sho_geco_shell_1",
		"wpn_fps_sho_geco_shell_2",
		"wpn_fps_sho_geco_trigger_1",
		"wpn_fps_sho_geco_trigger_2",
	}
	self.wpn_fps_sho_geco.uses_parts = {
		"wpn_fps_sho_geco_b_standard",
		"wpn_fps_sho_geco_s_standard",
		"wpn_fps_sho_geco_lock",
		"wpn_fps_sho_geco_body_standard",
		"wpn_fps_sho_geco_shell_1",
		"wpn_fps_sho_geco_shell_2",
		"wpn_fps_sho_geco_trigger_1",
		"wpn_fps_sho_geco_trigger_2",
		"wpn_fps_sho_geco_b_short",
		"wpn_fps_sho_geco_s_cheek_rest",
	}
	self.wpn_fps_sho_geco_npc = deep_clone(self.wpn_fps_sho_geco)
	self.wpn_fps_sho_geco_npc.unit = "units/upd_001/weapons/wpn_fps_sho_geco/wpn_fps_sho_geco_npc"
end

function WeaponFactoryTweakData:_init_m1912()
	self.parts.wpn_fps_sho_m1912_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_sho_m1912_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_b_long = {
		a_obj = "a_b",
		name_id = "bm_wp_sho_m1912_b_long",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_b_long",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_b_short = {
		a_obj = "a_b",
		name_id = "bm_wp_sho_m1912_b_short",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_b_short",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_b_heat_shield = {
		a_obj = "a_b",
		name_id = "bm_wp_sho_m1912_b_heat_shield",
		type = "extra",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_b_heat_shield",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_ns_cutts = {
		a_obj = "a_ns",
		name_id = "bm_wp_sho_m1912_ns_cutts",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_ns_cutts",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_sho_m1912_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_bolt_standard = {
		a_obj = "a_bolt",
		name_id = "bm_wp_sho_m1912_bolt_standard",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_bolt_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_fg_standard = {
		a_obj = "a_fg",
		name_id = "bm_wp_sho_m1912_fg_standard",
		type = "foregrip",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_fg_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_fg_long = {
		a_obj = "a_fg",
		name_id = "bm_wp_sho_m1912_fg_long",
		type = "foregrip",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_fg_long",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_sho_m1912_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_m_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_sho_m1912_s_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_s_cheek_rest = {
		a_obj = "a_s",
		name_id = "bm_wp_sho_m1912_s_cheek_rest",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_s_cheek_rest",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_s_pad = {
		a_obj = "a_pad",
		name_id = "bm_wp_sho_m1912_s_pad",
		parent = "stock",
		type = "stock_ext",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_s_pad",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_s_pistol_grip = {
		a_obj = "a_s",
		name_id = "bm_wp_sho_m1912_s_pistol_grip",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_sho_m1912_pts/wpn_fps_sho_m1912_s_pistol_grip",
		forbids = {
			"wpn_fps_sho_m1912_s_pad",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_sho_m1912_b_standard.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_b_standard"
	self.parts.wpn_fps_sho_m1912_b_long.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_b_long"
	self.parts.wpn_fps_sho_m1912_b_short.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_b_short"
	self.parts.wpn_fps_sho_m1912_b_heat_shield.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_b_heat_shield"
	self.parts.wpn_fps_sho_m1912_ns_cutts.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_ns_cutts"
	self.parts.wpn_fps_sho_m1912_body_standard.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_body_standard"
	self.parts.wpn_fps_sho_m1912_bolt_standard.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_bolt_standard"
	self.parts.wpn_fps_sho_m1912_fg_standard.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_fg_standard"
	self.parts.wpn_fps_sho_m1912_fg_long.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_fg_long"
	self.parts.wpn_fps_sho_m1912_m_standard.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_m_standard"
	self.parts.wpn_fps_sho_m1912_s_standard.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_s_standard"
	self.parts.wpn_fps_sho_m1912_s_cheek_rest.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_s_cheek_rest"
	self.parts.wpn_fps_sho_m1912_s_pad.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_s_pad"
	self.parts.wpn_fps_sho_m1912_s_pistol_grip.third_unit = "units/vanilla/weapons/wpn_third_sho_m1912_pts/wpn_third_sho_m1912_s_pistol_grip"
	self.wpn_fps_sho_m1912 = {}
	self.wpn_fps_sho_m1912.unit = "units/vanilla/weapons/wpn_fps_sho_m1912/wpn_fps_sho_m1912"
	self.wpn_fps_sho_m1912.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload_exit = "reload_exit",
	}
	self.wpn_fps_sho_m1912.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_sho_m1912.default_blueprint = {
		"wpn_fps_sho_m1912_b_standard",
		"wpn_fps_sho_m1912_body_standard",
		"wpn_fps_sho_m1912_bolt_standard",
		"wpn_fps_sho_m1912_fg_standard",
		"wpn_fps_sho_m1912_m_standard",
		"wpn_fps_sho_m1912_s_standard",
	}
	self.wpn_fps_sho_m1912.uses_parts = {
		"wpn_fps_sho_m1912_b_standard",
		"wpn_fps_sho_m1912_body_standard",
		"wpn_fps_sho_m1912_bolt_standard",
		"wpn_fps_sho_m1912_fg_standard",
		"wpn_fps_sho_m1912_m_standard",
		"wpn_fps_sho_m1912_s_standard",
		"wpn_fps_sho_m1912_b_long",
		"wpn_fps_sho_m1912_b_short",
		"wpn_fps_sho_m1912_ns_cutts",
		"wpn_fps_sho_m1912_s_cheek_rest",
		"wpn_fps_sho_m1912_s_pad",
		"wpn_fps_sho_m1912_s_pistol_grip",
		"wpn_fps_sho_m1912_b_heat_shield",
		"wpn_fps_sho_m1912_fg_long",
	}
	self.wpn_fps_sho_m1912_npc = deep_clone(self.wpn_fps_sho_m1912)
	self.wpn_fps_sho_m1912_npc.unit = "units/vanilla/weapons/wpn_fps_sho_m1912/wpn_fps_sho_m1912_npc"
end

function WeaponFactoryTweakData:_init_mp38()
	self.parts.wpn_fps_smg_mp38_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_smg_mp38_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_b_compensated = {
		a_obj = "a_b",
		name_id = "bm_wp_smg_mp38_b_compensated",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_b_compensated",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_b_fluted = {
		a_obj = "a_b",
		name_id = "bm_wp_smg_mp38_b_fluted",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_b_fluted",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_smg_mp38_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_smg_mp38_dh_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_dh_curved = {
		a_obj = "a_dh",
		name_id = "bm_wp_smg_mp38_dh_curved",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_dh_curved",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_mp38_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_m_standard",
		bullet_objects = {
			amount = 3,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_m_standard_double = {
		a_obj = "a_m",
		name_id = "bm_wp_smg_mp38_m_standard_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_m_standard_double",
		bullet_objects = {
			amount = 3,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_smg_mp38_s_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_s_wooden = {
		a_obj = "a_s",
		name_id = "bm_wp_smg_mp38_s_wooden",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_smg_mp38_pts/wpn_fps_smg_mp38_s_wooden",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_mp38_b_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_b_standard"
	self.parts.wpn_fps_smg_mp38_b_compensated.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_b_compensated"
	self.parts.wpn_fps_smg_mp38_b_fluted.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_b_fluted"
	self.parts.wpn_fps_smg_mp38_body_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_body_standard"
	self.parts.wpn_fps_smg_mp38_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_dh_standard"
	self.parts.wpn_fps_smg_mp38_dh_curved.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_dh_curved"
	self.parts.wpn_fps_smg_mp38_m_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_m_standard"
	self.parts.wpn_fps_smg_mp38_m_standard_double.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_m_standard_double"
	self.parts.wpn_fps_smg_mp38_s_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_s_standard"
	self.parts.wpn_fps_smg_mp38_s_wooden.third_unit = "units/vanilla/weapons/wpn_third_smg_mp38_pts/wpn_third_smg_mp38_s_wooden"
	self.wpn_fps_smg_mp38 = {}
	self.wpn_fps_smg_mp38.unit = "units/vanilla/weapons/wpn_fps_smg_mp38/wpn_fps_smg_mp38"
	self.wpn_fps_smg_mp38.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_smg_mp38.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_smg_mp38.default_blueprint = {
		"wpn_fps_smg_mp38_b_standard",
		"wpn_fps_smg_mp38_body_standard",
		"wpn_fps_smg_mp38_dh_standard",
		"wpn_fps_smg_mp38_m_standard",
		"wpn_fps_smg_mp38_s_standard",
	}
	self.wpn_fps_smg_mp38.uses_parts = {
		"wpn_fps_smg_mp38_b_standard",
		"wpn_fps_smg_mp38_body_standard",
		"wpn_fps_smg_mp38_dh_standard",
		"wpn_fps_smg_mp38_m_standard",
		"wpn_fps_smg_mp38_s_standard",
		"wpn_fps_smg_mp38_m_standard_double",
		"wpn_fps_smg_mp38_dh_curved",
		"wpn_fps_smg_mp38_b_compensated",
		"wpn_fps_smg_mp38_b_fluted",
		"wpn_fps_smg_mp38_s_wooden",
	}
	self.wpn_fps_smg_mp38_npc = deep_clone(self.wpn_fps_smg_mp38)
	self.wpn_fps_smg_mp38_npc.unit = "units/vanilla/weapons/wpn_fps_smg_mp38/wpn_fps_smg_mp38_npc"
end

function WeaponFactoryTweakData:_init_mp44()
	self.parts.wpn_fps_ass_mp44_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_ass_mp44_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_mp44_body_standard",
		type = "body",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_ass_mp44_dh_standard",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_m_short = {
		a_obj = "a_m",
		name_id = "bm_wp_ass_mp44_m_short",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_m_short",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_m_short_double = {
		a_obj = "a_m",
		name_id = "bm_wp_ass_mp44_m_short_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_m_short_double",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_ass_mp44_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_m_standard",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_m_standard_double = {
		a_obj = "a_m",
		name_id = "bm_wp_ass_mp44_m_standard_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_m_standard_double",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_fg_standard = {
		a_obj = "a_fg",
		name_id = "bm_wp_ass_mp44_fg_standard",
		type = "foregrip",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_fg_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_ass_mp44_m_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_mp44_o_scope = {
		a_obj = "a_o",
		name_id = "bm_wp_ass_mp44_o_scope",
		parent = "body",
		type = "sight",
		unit = "units/vanilla/weapons/wpn_fps_ass_mp44_pts/wpn_fps_ass_mp44_o_scope",
		stance_mod = {
			wpn_fps_ass_mp44 = {
				lens_distortion_power = 1.03,
				translation = Vector3(0, -15, -1.64784),
			},
		},
		stats = {
			value = 1,
			zoom = 5,
		},
	}
	self.parts.wpn_fps_ass_mp44_b_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_b_standard"
	self.parts.wpn_fps_ass_mp44_body_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_body_standard"
	self.parts.wpn_fps_ass_mp44_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_dh_standard"
	self.parts.wpn_fps_ass_mp44_m_short.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_m_short"
	self.parts.wpn_fps_ass_mp44_m_short_double.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_m_short_double"
	self.parts.wpn_fps_ass_mp44_m_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_m_standard"
	self.parts.wpn_fps_ass_mp44_m_standard_double.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_m_standard_double"
	self.parts.wpn_fps_ass_mp44_fg_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_fg_standard"
	self.parts.wpn_fps_ass_mp44_s_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_s_standard"
	self.parts.wpn_fps_ass_mp44_o_scope.third_unit = "units/vanilla/weapons/wpn_third_ass_mp44_pts/wpn_third_ass_mp44_o_scope"
	self.wpn_fps_ass_mp44 = {}
	self.wpn_fps_ass_mp44.unit = "units/vanilla/weapons/wpn_fps_ass_mp44/wpn_fps_ass_mp44"
	self.wpn_fps_ass_mp44.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_ass_mp44.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_ass_mp44.default_blueprint = {
		"wpn_fps_ass_mp44_b_standard",
		"wpn_fps_ass_mp44_body_standard",
		"wpn_fps_ass_mp44_dh_standard",
		"wpn_fps_ass_mp44_m_short",
		"wpn_fps_ass_mp44_fg_standard",
		"wpn_fps_ass_mp44_s_standard",
	}
	self.wpn_fps_ass_mp44.uses_parts = {
		"wpn_fps_ass_mp44_b_standard",
		"wpn_fps_ass_mp44_body_standard",
		"wpn_fps_ass_mp44_dh_standard",
		"wpn_fps_ass_mp44_m_short",
		"wpn_fps_ass_mp44_fg_standard",
		"wpn_fps_ass_mp44_s_standard",
		"wpn_fps_ass_mp44_m_short_double",
		"wpn_fps_ass_mp44_m_standard",
		"wpn_fps_ass_mp44_m_standard_double",
		"wpn_fps_ass_mp44_o_scope",
	}
	self.wpn_fps_ass_mp44_npc = deep_clone(self.wpn_fps_ass_mp44)
	self.wpn_fps_ass_mp44_npc.unit = "units/vanilla/weapons/wpn_fps_ass_mp44/wpn_fps_ass_mp44_npc"
end

function WeaponFactoryTweakData:_init_carbine()
	self.parts.wpn_fps_ass_carbine_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_ass_carbine_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_carbine_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_body_wooden = {
		a_obj = "a_body",
		name_id = "bm_wp_ass_carbine_body_wooden",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_body_wooden",
		forbids = {
			"wpn_fps_ass_carbine_s_standard",
			"wpn_fps_ass_carbine_g_standard",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_ass_carbine_dh_standard",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_bolt_standard = {
		a_obj = "a_bolt",
		name_id = "bm_wp_ass_carbine_bolt_standard",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_bolt_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_ass_carbine_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_m_standard",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_m_extended = {
		a_obj = "a_m",
		name_id = "bm_wp_ass_carbine_m_extended",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_m_extended",
		bullet_objects = {
			amount = 5,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_g_standard = {
		a_obj = "a_g",
		name_id = "bm_wp_ass_carbine_g_standard",
		type = "grip",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_g_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_ass_carbine_m_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_ass_carbine_pts/wpn_fps_ass_carbine_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_ass_carbine_b_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_b_standard"
	self.parts.wpn_fps_ass_carbine_body_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_body_standard"
	self.parts.wpn_fps_ass_carbine_body_wooden.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_body_wooden"
	self.parts.wpn_fps_ass_carbine_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_dh_standard"
	self.parts.wpn_fps_ass_carbine_bolt_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_bolt_standard"
	self.parts.wpn_fps_ass_carbine_m_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_m_standard"
	self.parts.wpn_fps_ass_carbine_m_extended.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_m_extended"
	self.parts.wpn_fps_ass_carbine_g_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_g_standard"
	self.parts.wpn_fps_ass_carbine_s_standard.third_unit = "units/vanilla/weapons/wpn_third_ass_carbine_pts/wpn_third_ass_carbine_s_standard"
	self.wpn_fps_ass_carbine = {}
	self.wpn_fps_ass_carbine.unit = "units/vanilla/weapons/wpn_fps_ass_carbine/wpn_fps_ass_carbine"
	self.wpn_fps_ass_carbine.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_ass_carbine.optional_types = {
		"barrel_ext",
		"gadget",
		"barrel",
		"lower_receiver",
	}
	self.wpn_fps_ass_carbine.default_blueprint = {
		"wpn_fps_ass_carbine_b_standard",
		"wpn_fps_ass_carbine_body_standard",
		"wpn_fps_ass_carbine_dh_standard",
		"wpn_fps_ass_carbine_bolt_standard",
		"wpn_fps_ass_carbine_m_standard",
		"wpn_fps_ass_carbine_g_standard",
		"wpn_fps_ass_carbine_s_standard",
	}
	self.wpn_fps_ass_carbine.uses_parts = {
		"wpn_fps_ass_carbine_b_standard",
		"wpn_fps_ass_carbine_body_standard",
		"wpn_fps_ass_carbine_dh_standard",
		"wpn_fps_ass_carbine_bolt_standard",
		"wpn_fps_ass_carbine_m_standard",
		"wpn_fps_ass_carbine_g_standard",
		"wpn_fps_ass_carbine_s_standard",
		"wpn_fps_ass_carbine_body_wooden",
		"wpn_fps_ass_carbine_m_extended",
	}
	self.wpn_fps_ass_carbine_npc = deep_clone(self.wpn_fps_ass_carbine)
	self.wpn_fps_ass_carbine_npc.unit = "units/vanilla/weapons/wpn_fps_ass_carbine/wpn_fps_ass_carbine_npc"
end

function WeaponFactoryTweakData:_init_mg42()
	self.parts.wpn_fps_lmg_mg42_b_mg42 = {
		a_obj = "a_b",
		name_id = "bm_wp_mg42_b_mg42",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_b_mg42",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_n42 = {
		a_obj = "a_ns",
		name_id = "bm_wp_mg42_n42",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_n42",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_b_mg34 = {
		a_obj = "a_b",
		name_id = "bm_wp_mg42_b_mg34",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_b_mg34",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_n34 = {
		a_obj = "a_ns",
		name_id = "bm_wp_mg42_n34",
		parent = "barrel",
		type = "barrel_ext",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_n42",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_receiver = {
		a_obj = "a_body",
		name_id = "bm_wp_mg42_receiver",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_receiver",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_lid_standard = {
		a_obj = "a_lid",
		name_id = "bm_wp_mg42_lid_standard",
		type = "upper_receiver",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_lid_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_lid_mg34 = {
		a_obj = "a_body",
		name_id = "bm_wp_mg42_lid_mg34",
		type = "upper_receiver",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_lid_mg34",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_mg42_dh_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_dh_extra = {
		a_obj = "a_dh_extra",
		name_id = "bm_wp_mg42_dh_extra",
		type = "dh_ext",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_dh_extra",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_bipod = {
		a_obj = "a_bp",
		name_id = "bm_wp_mg42_bipod",
		parent = "barrel",
		type = "bipod",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_bipod",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_dh_mg34 = {
		a_obj = "a_body",
		name_id = "bm_wp_mg42_dh_mg34",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_dh_mg34",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_mg42_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_m_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_handle = {
		a_obj = "a_handle",
		name_id = "bm_wp_mg42_handle",
		type = "custom",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_handle",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_band_1 = {
		a_obj = "a_band_1",
		name_id = "bm_wp_mg42_band_1",
		type = "band_1",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_band_1",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_band_2 = {
		a_obj = "a_band_2",
		name_id = "bm_wp_mg42_band_2",
		type = "band_2",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_band_2",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_band_3 = {
		a_obj = "a_band_3",
		name_id = "bm_wp_mg42_band_3",
		type = "band_3",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_band_3",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_m_double = {
		a_obj = "a_body",
		name_id = "bm_wp_mg42_m_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_m_double",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_lmg_mg42_b_mg42.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_b_mg42"
	self.parts.wpn_fps_lmg_mg42_n42.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_n42"
	self.parts.wpn_fps_lmg_mg42_b_mg34.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_b_mg34"
	self.parts.wpn_fps_lmg_mg42_n34.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_n34"
	self.parts.wpn_fps_lmg_mg42_receiver.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_receiver"
	self.parts.wpn_fps_lmg_mg42_lid_standard.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_lid_standard"
	self.parts.wpn_fps_lmg_mg42_lid_mg34.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_lid_mg34"
	self.parts.wpn_fps_lmg_mg42_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_dh_standard"
	self.parts.wpn_fps_lmg_mg42_dh_extra.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_dh_extra"
	self.parts.wpn_fps_lmg_mg42_bipod.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_bipod"
	self.parts.wpn_fps_lmg_mg42_dh_mg34.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_dh_mg34"
	self.parts.wpn_fps_lmg_mg42_m_standard.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_m_standard"
	self.parts.wpn_fps_lmg_mg42_handle.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_handle"
	self.parts.wpn_fps_lmg_mg42_band_1.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_band_1"
	self.parts.wpn_fps_lmg_mg42_band_2.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_band_2"
	self.parts.wpn_fps_lmg_mg42_band_3.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_band_3"
	self.parts.wpn_fps_lmg_mg42_m_double.third_unit = "units/vanilla/weapons/wpn_third_lmg_mg42_pts/wpn_third_lmg_mg42_m_double"
	self.wpn_fps_lmg_mg42 = {}
	self.wpn_fps_lmg_mg42.unit = "units/vanilla/weapons/wpn_fps_lmg_mg42/wpn_fps_lmg_mg42"
	self.wpn_fps_lmg_mg42.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_lmg_mg42.optional_types = {
		"barrel_ext",
		"gadget",
		"vertical_grip",
	}
	self.wpn_fps_lmg_mg42.default_blueprint = {
		"wpn_fps_lmg_mg42_b_mg42",
		"wpn_fps_lmg_mg42_n42",
		"wpn_fps_lmg_mg42_receiver",
		"wpn_fps_lmg_mg42_lid_standard",
		"wpn_fps_lmg_mg42_dh_standard",
		"wpn_fps_lmg_mg42_dh_extra",
		"wpn_fps_lmg_mg42_m_standard",
		"wpn_fps_lmg_mg42_handle",
		"wpn_fps_lmg_mg42_band_1",
		"wpn_fps_lmg_mg42_band_2",
		"wpn_fps_lmg_mg42_band_3",
	}
	self.wpn_fps_lmg_mg42.uses_parts = {
		"wpn_fps_lmg_mg42_b_mg42",
		"wpn_fps_lmg_mg42_n42",
		"wpn_fps_lmg_mg42_receiver",
		"wpn_fps_lmg_mg42_lid_standard",
		"wpn_fps_lmg_mg42_dh_standard",
		"wpn_fps_lmg_mg42_dh_extra",
		"wpn_fps_lmg_mg42_m_standard",
		"wpn_fps_lmg_mg42_handle",
		"wpn_fps_lmg_mg42_band_1",
		"wpn_fps_lmg_mg42_band_2",
		"wpn_fps_lmg_mg42_band_3",
		"wpn_fps_lmg_mg42_b_mg34",
		"wpn_fps_lmg_mg42_n34",
		"wpn_fps_lmg_mg42_bipod",
		"wpn_fps_lmg_mg42_dh_mg34",
		"wpn_fps_lmg_mg42_m_double",
		"wpn_fps_lmg_mg42_lid_mg34",
	}
	self.wpn_fps_lmg_mg42_npc = deep_clone(self.wpn_fps_lmg_mg42)
	self.wpn_fps_lmg_mg42_npc.unit = "units/vanilla/weapons/wpn_fps_lmg_mg42/wpn_fps_lmg_mg42_npc"
end

function WeaponFactoryTweakData:_init_c96()
	self.parts.wpn_fps_pis_c96_b_long = {
		a_obj = "a_b",
		name_id = "bm_wp_c96_b_long",
		type = "slide",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_b_long",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_b_long_finned = {
		a_obj = "a_b",
		name_id = "bm_wp_c96_b_long_finned",
		type = "slide",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_b_long_finned",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_c96_b_standard",
		type = "slide",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_c96_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_g_standard = {
		a_obj = "a_g",
		name_id = "bm_wp_c96_g_standard",
		type = "grip",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_g_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_m_long = {
		a_obj = "a_m",
		name_id = "bm_wp_c96_m_long",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_m_long",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_m_extended = {
		a_obj = "a_m",
		name_id = "bm_wp_c96_m_extended",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_m_extended",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_c96_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_m_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_s_wooden = {
		a_obj = "a_s",
		name_id = "bm_wp_c96_s_wooden",
		type = "grip",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_s_wooden",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_bullets_standard = {
		a_obj = "a_bullets",
		name_id = "bm_wp_c96_bullets_standard",
		type = "bullets",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_bullets_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_strip_standard = {
		a_obj = "a_strip",
		name_id = "bm_wp_c96_strip_standard",
		type = "strip",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_strip_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_bolt_standard = {
		a_obj = "a_bolt",
		name_id = "bm_wp_c96_bolt_standard",
		type = "bolt",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_bolt_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_hammer_standard = {
		a_obj = "a_hammer",
		name_id = "bm_wp_c96_hammer_standard",
		type = "hammer",
		unit = "units/vanilla/weapons/wpn_fps_pis_c96_pts/wpn_fps_pis_c96_hammer_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_c96_b_long.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_b_long"
	self.parts.wpn_fps_pis_c96_b_long_finned.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_b_long_finned"
	self.parts.wpn_fps_pis_c96_b_standard.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_b_standard"
	self.parts.wpn_fps_pis_c96_body_standard.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_body_standard"
	self.parts.wpn_fps_pis_c96_g_standard.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_g_standard"
	self.parts.wpn_fps_pis_c96_m_long.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_m_long"
	self.parts.wpn_fps_pis_c96_m_extended.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_m_extended"
	self.parts.wpn_fps_pis_c96_m_standard.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_m_standard"
	self.parts.wpn_fps_pis_c96_s_wooden.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_s_wooden"
	self.parts.wpn_fps_pis_c96_bullets_standard.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_bullets_standard"
	self.parts.wpn_fps_pis_c96_strip_standard.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_strip_standard"
	self.parts.wpn_fps_pis_c96_bolt_standard.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_bolt_standard"
	self.parts.wpn_fps_pis_c96_hammer_standard.third_unit = "units/vanilla/weapons/wpn_third_pis_c96_pts/wpn_third_pis_c96_hammer_standard"
	self.wpn_fps_pis_c96 = {}
	self.wpn_fps_pis_c96.unit = "units/vanilla/weapons/wpn_fps_pis_c96/wpn_fps_pis_c96"
	self.wpn_fps_pis_c96.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_pis_c96.optional_types = {
		"barrel_ext",
		"gadget",
		"sight",
	}
	self.wpn_fps_pis_c96.default_blueprint = {
		"wpn_fps_pis_c96_b_standard",
		"wpn_fps_pis_c96_body_standard",
		"wpn_fps_pis_c96_g_standard",
		"wpn_fps_pis_c96_m_standard",
		"wpn_fps_pis_c96_bullets_standard",
		"wpn_fps_pis_c96_strip_standard",
		"wpn_fps_pis_c96_bolt_standard",
		"wpn_fps_pis_c96_hammer_standard",
	}
	self.wpn_fps_pis_c96.uses_parts = {
		"wpn_fps_pis_c96_b_standard",
		"wpn_fps_pis_c96_body_standard",
		"wpn_fps_pis_c96_g_standard",
		"wpn_fps_pis_c96_m_standard",
		"wpn_fps_pis_c96_bullets_standard",
		"wpn_fps_pis_c96_strip_standard",
		"wpn_fps_pis_c96_bolt_standard",
		"wpn_fps_pis_c96_hammer_standard",
		"wpn_fps_pis_c96_b_long",
		"wpn_fps_pis_c96_b_long_finned",
		"wpn_fps_pis_c96_m_long",
		"wpn_fps_pis_c96_m_extended",
		"wpn_fps_pis_c96_s_wooden",
	}
	self.wpn_fps_pis_c96_npc = deep_clone(self.wpn_fps_pis_c96)
	self.wpn_fps_pis_c96_npc.unit = "units/vanilla/weapons/wpn_fps_pis_c96/wpn_fps_pis_c96_npc"
end

function WeaponFactoryTweakData:_init_webley()
	self.parts.wpn_fps_pis_webley_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_webley_body_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_body_standard",
		type = "body",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_lock_standard = {
		a_obj = "a_lock",
		name_id = "bm_wp_webley_lock_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_lock_standard",
		type = "lock",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_lock_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_hammer_standard = {
		a_obj = "a_hammer",
		name_id = "bm_wp_webley_hammer_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_hammer_standard",
		type = "hammer",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_hammer_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_trigger_standard = {
		a_obj = "a_trigger",
		name_id = "bm_wp_webley_trigger_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_trigger_standard",
		type = "trigger",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_trigger_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_webley_b_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_webley_m_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_m_standard",
		type = "drum",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_m_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_ejector_standard = {
		a_obj = "a_ejector",
		name_id = "bm_wp_webley_ejector_standard",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_ejector_standard",
		type = "ejector",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_ejector_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_casing_1 = {
		a_obj = "a_casing_1",
		name_id = "bm_wp_webley_casing_1",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_casing_1",
		type = "extra_1",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_casing_1",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_casing_2 = {
		a_obj = "a_casing_2",
		name_id = "bm_wp_webley_casing_2",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_casing_2",
		type = "extra_2",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_casing_2",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_casing_3 = {
		a_obj = "a_casing_3",
		name_id = "bm_wp_webley_casing_3",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_casing_3",
		type = "extra_3",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_casing_3",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_casing_4 = {
		a_obj = "a_casing_4",
		name_id = "bm_wp_webley_casing_4",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_casing_4",
		type = "extra_4",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_casing_4",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_casing_5 = {
		a_obj = "a_casing_5",
		name_id = "bm_wp_webley_casing_5",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_casing_5",
		type = "extra_5",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_casing_5",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_casing_6 = {
		a_obj = "a_casing_6",
		name_id = "bm_wp_webley_casing_6",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_casing_6",
		type = "extra_6",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_casing_6",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_bullet_clip = {
		a_obj = "a_clip",
		name_id = "bm_wp_webley_bullet_clip",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_bullet_clip",
		type = "bullet_clip",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_bullet_clip",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_pis_webley_bullets = {
		a_obj = "a_bullets",
		name_id = "bm_wp_webley_bullets",
		third_unit = "units/vanilla/weapons/wpn_third_pis_webley_pts/wpn_third_pis_webley_bullets",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_pis_webley_pts/wpn_fps_pis_webley_bullets",
		animations = {
			reload = "reload",
			reload_not_empty = "reload_not_empty",
		},
		bullet_objects = {
			amount = 6,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.wpn_fps_pis_webley = {}
	self.wpn_fps_pis_webley.unit = "units/vanilla/weapons/wpn_fps_pis_webley/wpn_fps_pis_webley"
	self.wpn_fps_pis_webley.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_pis_webley.optional_types = {
		"barrel_ext",
		"gadget",
		"sight",
	}
	self.wpn_fps_pis_webley.default_blueprint = {
		"wpn_fps_pis_webley_body_standard",
		"wpn_fps_pis_webley_lock_standard",
		"wpn_fps_pis_webley_hammer_standard",
		"wpn_fps_pis_webley_trigger_standard",
		"wpn_fps_pis_webley_b_standard",
		"wpn_fps_pis_webley_m_standard",
		"wpn_fps_pis_webley_ejector_standard",
		"wpn_fps_pis_webley_casing_1",
		"wpn_fps_pis_webley_casing_2",
		"wpn_fps_pis_webley_casing_3",
		"wpn_fps_pis_webley_casing_4",
		"wpn_fps_pis_webley_casing_5",
		"wpn_fps_pis_webley_casing_6",
		"wpn_fps_pis_webley_bullet_clip",
		"wpn_fps_pis_webley_bullets",
	}
	self.wpn_fps_pis_webley.uses_parts = {
		"wpn_fps_pis_webley_body_standard",
		"wpn_fps_pis_webley_lock_standard",
		"wpn_fps_pis_webley_hammer_standard",
		"wpn_fps_pis_webley_trigger_standard",
		"wpn_fps_pis_webley_b_standard",
		"wpn_fps_pis_webley_m_standard",
		"wpn_fps_pis_webley_ejector_standard",
		"wpn_fps_pis_webley_casing_1",
		"wpn_fps_pis_webley_casing_2",
		"wpn_fps_pis_webley_casing_3",
		"wpn_fps_pis_webley_casing_4",
		"wpn_fps_pis_webley_casing_5",
		"wpn_fps_pis_webley_casing_6",
		"wpn_fps_pis_webley_bullet_clip",
		"wpn_fps_pis_webley_bullets",
	}
	self.wpn_fps_pis_webley_npc = deep_clone(self.wpn_fps_pis_webley)
	self.wpn_fps_pis_webley_npc.unit = "units/vanilla/weapons/wpn_fps_pis_webley/wpn_fps_pis_webley_npc"
end

function WeaponFactoryTweakData:_init_mosin()
	self.parts.wpn_fps_snp_mosin_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_mosin_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_b_long = {
		a_obj = "a_b",
		name_id = "bm_wp_mosin_b_long",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_b_long",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_mosin_body_standard",
		type = "body",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_body_grip = {
		a_obj = "a_body",
		name_id = "bm_wp_mosin_body_grip",
		type = "body",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_body_grip",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_body_target = {
		a_obj = "a_body",
		name_id = "bm_wp_mosin_body_target",
		type = "body",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_body_target",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_bolt_standard = {
		a_obj = "a_bolt",
		name_id = "bm_wp_mosin_bolt_standard",
		type = "bolt",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_bolt_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_dh_standard = {
		a_obj = "a_dh",
		name_id = "bm_wp_mosin_dh_standard",
		type = "drag_handle",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_dh_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_m_standard = {
		a_obj = "a_m",
		name_id = "bm_wp_mosin_m_standard",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_m_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_clip_standard = {
		a_obj = "a_clip",
		name_id = "bm_wp_mosin_clip_standard",
		type = "clip",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_clip_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_bullet = {
		a_obj = "a_bullet",
		name_id = "bm_wp_mosin_bullet",
		type = "bullets",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_bullet",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_snp_mosin_o_scope = {
		a_obj = "a_o",
		name_id = "bm_wp_mosin_o_scope",
		parent = "body",
		reticle_obj = "g_reticle",
		type = "scope",
		unit = "units/vanilla/weapons/wpn_fps_snp_mosin_pts/wpn_fps_snp_mosin_o_scope",
		stance_mod = {
			wpn_fps_snp_mosin = {
				lens_distortion_power = 1.04,
				translation = Vector3(0, -21, -2.323),
			},
		},
		stats = {
			value = 1,
			zoom = 8,
		},
	}
	self.parts.wpn_fps_snp_mosin_b_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_b_standard"
	self.parts.wpn_fps_snp_mosin_b_long.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_b_long"
	self.parts.wpn_fps_snp_mosin_body_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_body_standard"
	self.parts.wpn_fps_snp_mosin_body_grip.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_body_grip"
	self.parts.wpn_fps_snp_mosin_body_target.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_body_target"
	self.parts.wpn_fps_snp_mosin_bolt_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_bolt_standard"
	self.parts.wpn_fps_snp_mosin_dh_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_dh_standard"
	self.parts.wpn_fps_snp_mosin_m_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_m_standard"
	self.parts.wpn_fps_snp_mosin_clip_standard.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_clip_standard"
	self.parts.wpn_fps_snp_mosin_bullet.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_bullet"
	self.parts.wpn_fps_snp_mosin_o_scope.third_unit = "units/vanilla/weapons/wpn_third_snp_mosin_pts/wpn_third_snp_mosin_o_scope"
	self.wpn_fps_snp_mosin = {}
	self.wpn_fps_snp_mosin.unit = "units/vanilla/weapons/wpn_fps_snp_mosin/wpn_fps_snp_mosin"
	self.wpn_fps_snp_mosin.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_snp_mosin.optional_types = {
		"gadget",
		"sight",
		"bayonet",
	}
	self.wpn_fps_snp_mosin.default_blueprint = {
		"wpn_fps_snp_mosin_b_standard",
		"wpn_fps_snp_mosin_body_standard",
		"wpn_fps_snp_mosin_bolt_standard",
		"wpn_fps_snp_mosin_dh_standard",
		"wpn_fps_snp_mosin_m_standard",
		"wpn_fps_snp_mosin_clip_standard",
		"wpn_fps_snp_mosin_bullet",
	}
	self.wpn_fps_snp_mosin.uses_parts = {
		"wpn_fps_snp_mosin_b_standard",
		"wpn_fps_snp_mosin_body_standard",
		"wpn_fps_snp_mosin_bolt_standard",
		"wpn_fps_snp_mosin_dh_standard",
		"wpn_fps_snp_mosin_m_standard",
		"wpn_fps_snp_mosin_clip_standard",
		"wpn_fps_snp_mosin_bullet",
		"wpn_fps_snp_mosin_b_long",
		"wpn_fps_snp_mosin_body_grip",
		"wpn_fps_snp_mosin_body_target",
		"wpn_fps_snp_mosin_o_scope",
	}
	self.wpn_fps_snp_mosin_npc = deep_clone(self.wpn_fps_snp_mosin)
	self.wpn_fps_snp_mosin_npc.unit = "units/vanilla/weapons/wpn_fps_snp_mosin/wpn_fps_snp_mosin_npc"
end

function WeaponFactoryTweakData:_init_sterling()
	self.parts.wpn_fps_smg_sterling_b_long = {
		a_obj = "a_b",
		name_id = "bm_wp_sterling_b_long",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_smg_sterling_pts/wpn_fps_smg_sterling_b_long",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sterling_b_standard = {
		a_obj = "a_b",
		name_id = "bm_wp_sterling_b_standard",
		type = "barrel",
		unit = "units/vanilla/weapons/wpn_fps_smg_sterling_pts/wpn_fps_smg_sterling_b_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sterling_body_standard = {
		a_obj = "a_body",
		name_id = "bm_wp_sterling_body_standard",
		type = "lower_receiver",
		unit = "units/vanilla/weapons/wpn_fps_smg_sterling_pts/wpn_fps_smg_sterling_body_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sterling_bolt_standard = {
		a_obj = "a_bolt",
		name_id = "bm_wp_sterling_bolt_standard",
		type = "bolt",
		unit = "units/vanilla/weapons/wpn_fps_smg_sterling_pts/wpn_fps_smg_sterling_bolt_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sterling_m_long = {
		a_obj = "a_m",
		name_id = "bm_wp_sterling_m_long",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_sterling_pts/wpn_fps_smg_sterling_m_long",
		bullet_objects = {
			amount = 3,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sterling_m_long_double = {
		a_obj = "a_m",
		name_id = "bm_wp_sterling_m_long_double",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_sterling_pts/wpn_fps_smg_sterling_m_long_double",
		bullet_objects = {
			amount = 3,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sterling_m_medium = {
		a_obj = "a_m",
		name_id = "bm_wp_sterling_m_medium",
		type = "magazine",
		unit = "units/vanilla/weapons/wpn_fps_smg_sterling_pts/wpn_fps_smg_sterling_m_medium",
		bullet_objects = {
			amount = 3,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sterling_s_standard = {
		a_obj = "a_s",
		name_id = "bm_wp_sterling_s_standard",
		type = "stock",
		unit = "units/vanilla/weapons/wpn_fps_smg_sterling_pts/wpn_fps_smg_sterling_s_standard",
		stats = {
			value = 1,
		},
	}
	self.parts.wpn_fps_smg_sterling_b_long.third_unit = "units/vanilla/weapons/wpn_third_smg_sterling_pts/wpn_third_smg_sterling_b_long"
	self.parts.wpn_fps_smg_sterling_b_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sterling_pts/wpn_third_smg_sterling_b_standard"
	self.parts.wpn_fps_smg_sterling_body_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sterling_pts/wpn_third_smg_sterling_body_standard"
	self.parts.wpn_fps_smg_sterling_bolt_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sterling_pts/wpn_third_smg_sterling_bolt_standard"
	self.parts.wpn_fps_smg_sterling_m_long.third_unit = "units/vanilla/weapons/wpn_third_smg_sterling_pts/wpn_third_smg_sterling_m_long"
	self.parts.wpn_fps_smg_sterling_m_long_double.third_unit = "units/vanilla/weapons/wpn_third_smg_sterling_pts/wpn_third_smg_sterling_m_long_double"
	self.parts.wpn_fps_smg_sterling_m_medium.third_unit = "units/vanilla/weapons/wpn_third_smg_sterling_pts/wpn_third_smg_sterling_m_medium"
	self.parts.wpn_fps_smg_sterling_s_standard.third_unit = "units/vanilla/weapons/wpn_third_smg_sterling_pts/wpn_third_smg_sterling_s_standard"
	self.wpn_fps_smg_sterling = {}
	self.wpn_fps_smg_sterling.unit = "units/vanilla/weapons/wpn_fps_smg_sterling/wpn_fps_smg_sterling"
	self.wpn_fps_smg_sterling.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_smg_sterling.optional_types = {
		"barrel_ext",
		"gadget",
		"vertical_grip",
	}
	self.wpn_fps_smg_sterling.default_blueprint = {
		"wpn_fps_smg_sterling_b_standard",
		"wpn_fps_smg_sterling_body_standard",
		"wpn_fps_smg_sterling_bolt_standard",
		"wpn_fps_smg_sterling_m_medium",
		"wpn_fps_smg_sterling_s_standard",
	}
	self.wpn_fps_smg_sterling.uses_parts = {
		"wpn_fps_smg_sterling_b_standard",
		"wpn_fps_smg_sterling_body_standard",
		"wpn_fps_smg_sterling_bolt_standard",
		"wpn_fps_smg_sterling_m_medium",
		"wpn_fps_smg_sterling_s_standard",
		"wpn_fps_smg_sterling_b_long",
		"wpn_fps_smg_sterling_m_long",
		"wpn_fps_smg_sterling_m_long_double",
	}
	self.wpn_fps_smg_sterling_npc = deep_clone(self.wpn_fps_smg_sterling)
	self.wpn_fps_smg_sterling_npc.unit = "units/vanilla/weapons/wpn_fps_smg_sterling/wpn_fps_smg_sterling_npc"
end

function WeaponFactoryTweakData:_init_welrod()
	self.wpn_fps_pis_welrod = {}
	self.wpn_fps_pis_welrod.unit = "units/vanilla/weapons/wpn_fps_pis_welrod/wpn_fps_pis_welrod"
	self.wpn_fps_pis_welrod.optional_types = {
		"barrel_ext",
		"gadget",
	}
	self.wpn_fps_pis_welrod.animations = {
		fire = "recoil",
		fire_steelsight = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
	}
	self.wpn_fps_pis_welrod.default_blueprint = {
		"wpn_fps_pis_m1911_body_standard",
		"wpn_fps_pis_m1911_b_standard",
		"wpn_fps_pis_m1911_sl_standard",
		"wpn_fps_pis_m1911_m_standard",
		"wpn_fps_pis_m1911_dh_hammer",
	}
	self.wpn_fps_pis_welrod.uses_parts = {
		"wpn_fps_pis_m1911_body_standard",
		"wpn_fps_pis_m1911_b_standard",
		"wpn_fps_pis_m1911_sl_standard",
		"wpn_fps_pis_m1911_m_standard",
		"wpn_fps_pis_m1911_dh_hammer",
	}
	self.wpn_fps_pis_welrod_npc = deep_clone(self.wpn_fps_pis_welrod)
	self.wpn_fps_pis_welrod_npc.unit = "units/vanilla/weapons/wpn_fps_pis_welrod/wpn_fps_pis_welrod_npc"
end

function WeaponFactoryTweakData:is_part_internal(part_id)
	return self.parts[part_id] and self.parts[part_id].internal_part or false
end

function WeaponFactoryTweakData:create_ammunition()
	return
end
