PlayerSkill = {}

function PlayerSkill.has_skill(category, skill, player)
	if alive(player) and player:base().is_husk_player then
		return player:base():upgrade_value(category, skill) ~= nil
	else
		return managers.player:has_category_upgrade(category, skill)
	end
end

function PlayerSkill.skill_data(category, skill, default, player)
	if alive(player) and player:base().is_husk_player then
		return player:base():upgrade_value(category, skill) or default
	else
		return managers.player:upgrade_value(category, skill, default)
	end
end

function PlayerSkill.skill_level(category, skill, default, player)
	if alive(player) and player:base().is_husk_player then
		return player:base():upgrade_level(category, skill) or 0
	else
		return managers.player:upgrade_level(category, skill, default)
	end
end

function PlayerSkill.warcry_data(category, skill, default, peer_id)
	if peer_id then
		return managers.warcry:peer_warcry_upgrade_value(peer_id, category, skill) or default
	else
		return managers.player:upgrade_value(category, skill, default)
	end
end
