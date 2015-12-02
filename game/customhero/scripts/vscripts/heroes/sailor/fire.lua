function Fire(keys)
	local caster = keys.caster
	local ability = keys.ability
	local shots = ability:GetLevelSpecialValueFor( "shots", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local direction = caster:GetForwardVector()
	local casterLocation = caster:GetAbsOrigin()
	local startpoint = casterLocation + direction * distance

	local counter = 0

	Timers:CreateTimer(function()
		counter = counter + 1
		local point = startpoint + direction * (radius/2) * counter
		local z = GetGroundHeight(point, caster)
		point[3] = z
		local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP, 0, 0, false)

		if table.getn(units) > 0 then
			for i=1,table.getn(units) do
				local damageTable = {
					victim = units[i],
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage(damageTable)
			end
		end
		
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_ABSORIGIN, caster)
 		ParticleManager:SetParticleControl(particle, 0, point)

 		EmitSoundOnLocationWithCaster(point, "Hero_Techies.LandMine.Detonate", caster)

		if counter <= shots then
			return delay
		end
    end)
	
end
