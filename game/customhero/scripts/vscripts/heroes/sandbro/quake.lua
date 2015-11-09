function Quake(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local casterLocation = caster:GetAbsOrigin()
	local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	local fracture = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
	local count = table.getn(nearbyUnits)

	caster:AddNoDraw()

	Timers:CreateTimer(duration, function()
		caster:RemoveNoDraw()
    end)

    caster.quake_count = 0
    caster.fracture_check = false
    --checks the fracture table for the dummy unit
	for i=1,table.getn(fracture) do
		if fracture[i]:GetUnitName() == "fracture_dummy" then
			caster.fracture_check = true
			break
		end
	end

	--checks the nearbyunits table to apply the special fracture debuff if the dummy unit is present
	if caster.fracture_check == true then
		for i=1,count do
			ability:ApplyDataDrivenModifier(caster, nearbyUnits[i], "modifier_quake_fracture", {duration=duration})
		end
	end
end

function QuakeDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local multiplier = ability:GetLevelSpecialValueFor( "multiplier", ability:GetLevel() - 1 )
	local casterLocation = caster:GetAbsOrigin()
	local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	local fracture = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
	local count = table.getn(nearbyUnits)
	caster.quake_count = caster.quake_count + 1

	if caster.fracture_check == true then
		for i=1,count do
			
			local damageTable = {
				victim = nearbyUnits[i],
				attacker = caster,
				damage = damage * caster.quake_count *multiplier,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			 
			ApplyDamage(damageTable)
		end
	else
		for i=1,count do
			
			local damageTable = {
				victim = nearbyUnits[i],
				attacker = caster,
				damage = damage * caster.quake_count,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			 
			ApplyDamage(damageTable)
		end
	end
end