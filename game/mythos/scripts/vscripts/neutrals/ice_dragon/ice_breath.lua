function Delay(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.point

	Timers:CreateTimer(.7, function()
	  StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1})
	end
	)
end

function BreathAI(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("ai_radius", 1)
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", 1)
	
	Timers:CreateTimer(10, function()
		local casterLocation = caster:GetAbsOrigin()
		local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 2, false)
		local count = table.getn(nearbyUnits)
		if count > 0 then
			local cast_point = nearbyUnits[1]:GetAbsOrigin()
			local ice_breath = caster:GetAbilityByIndex(1)
			

			caster:CastAbilityOnPosition(cast_point, ice_breath, 1)
		end
    	return cooldown
    end
  	)
end
