function Fire(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "shots", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local multiplier = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local casterLocation = caster:GetAbsOrigin()

	local counter = 0

	Timers:CreateTimer(function()
		counter = counter + 1
		local point = caster:GetForwardVector()+radius * counter
		local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP, 0, 0, false)

		for i=1,table.getn(units) do
			local damageTable = {
				victim = units[i],
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
		end
		
 
		ApplyDamage(damageTable)

		if counter <= shots then
			return delay
		end
    end)
	
end
