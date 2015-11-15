function Teleport(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor( "tp_range", ability:GetLevel() - 1 )
	local target = keys.target_points[1]
	local casterLocation = caster:GetAbsOrigin()
	local nearbyAllies = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	local count = table.getn(nearbyAllies)

	for x=1, count do
		FindClearSpaceForUnit(nearbyAllies[x], target, true)
	end
end