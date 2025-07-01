GroupAIStateEmpty = GroupAIStateEmpty or class(GroupAIStateBase)

function GroupAIStateEmpty:assign_enemy_to_group_ai(unit)
	return
end

function GroupAIStateEmpty:flee_point(start_nav_seg)
	return
end

function GroupAIStateEmpty:set_area_min_police_force(id, force, pos)
	return
end

function GroupAIStateEmpty:set_wave_mode(flag)
	return
end

function GroupAIStateEmpty:add_preferred_spawn_points(id, spawn_points)
	return
end

function GroupAIStateEmpty:remove_preferred_spawn_points(id)
	return
end

function GroupAIStateEmpty:is_area_safe()
	return true
end

function GroupAIStateEmpty:is_nav_seg_safe()
	return true
end

function GroupAIStateEmpty:on_defend_travel_end(unit, objective)
	return
end

function GroupAIStateEmpty:on_cop_jobless(unit)
	return
end

function GroupAIStateEmpty:on_nav_segment_state_change(changed_seg, state)
	return
end

function GroupAIStateEmpty:register_criminal(criminal_unit)
	return
end

function GroupAIStateEmpty:unregister_criminal(criminal_unit)
	return
end

function GroupAIStateEmpty:on_criminal_recovered(criminal_unit)
	return
end

function GroupAIStateEmpty:on_criminal_disabled(criminal_unit)
	return
end

function GroupAIStateEmpty:on_criminal_neutralized(criminal_unit)
	return
end

function GroupAIStateEmpty:fill_criminal_team()
	return
end

function GroupAIStateEmpty:spawn_one_criminal_ai()
	return
end

function GroupAIStateEmpty:remove_one_criminal_ai()
	return
end

function GroupAIStateEmpty:is_detection_persistent()
	return false
end

function GroupAIStateEmpty:set_importance_weight(cop_unit, dis_report)
	return
end

function GroupAIStateEmpty:add_special_objective(id, objective_data)
	return
end

function GroupAIStateEmpty:remove_special_objective(id)
	return
end

function GroupAIStateEmpty:on_nav_link_unregistered()
	return
end

function GroupAIStateEmpty:save(save_data)
	return
end

function GroupAIStateEmpty:load(load_data)
	return
end
