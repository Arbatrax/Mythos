function QuakeDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "shots", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local multiplier = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local casterLocation = caster:GetAbsOrigin()

	local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	local count = table.getn(nearbyUnits)
	local counter = 0

	Timers:CreateTimer(function()
		counter = counter + 1
		local point = caster:GetForwardVector()+radius * counter
		local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP, 0, 0, false)


		if counter <= shots then
			return delay
		end
    end)
	
end
