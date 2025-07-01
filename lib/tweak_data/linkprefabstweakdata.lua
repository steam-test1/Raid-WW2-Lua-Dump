LinkPrefabsTweakData = LinkPrefabsTweakData or class()

function LinkPrefabsTweakData:init()
	self.default_align_obj = "root_point"
	self.truck_cargo_001 = {}
	self.truck_cargo_001.align_obj = "anim_body"
	self.truck_cargo_001.props = {
		{
			pos = Vector3(0, 25, 70),
			rot = Rotation(0, 0, 0),
			unit = "units/vanilla/props/props_sandbags_05/props_sandbags_05",
		},
		{
			pos = Vector3(0, -10, 70),
			rot = Rotation(0, 0, 0),
			sequences = {
				_init = "disable_search_for_enemies",
			},
			unit = "units/vanilla/turrets/turret_m2/turret_m2",
		},
	}
end
