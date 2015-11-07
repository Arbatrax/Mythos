function SeverCrit( event )
	local caster = event.caster
	local casterLocation = caster:GetAbsOrigin()
	local ability = event.ability
	local target = event.target
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local sever = caster:GetAbilityByIndex(0)
	local severduration = sever:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )

	if target:HasModifier("modifier_sever") then
		if target:IsHero() == true then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_throat_buff", {duration=duration})
			print("penis")
		else 
			print("boobs")
			local nearbyEnemies = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
			local count = table.getn(nearbyEnemies)
			if count > 0 then
				for i=1, count do
					print(count)
					sever:ApplyDataDrivenModifier(caster, nearbyEnemies[i], "modifier_sever", {duration=severduration})
				end
			end
		end
	end
end