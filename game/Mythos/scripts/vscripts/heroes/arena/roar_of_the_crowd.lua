function roar_of_the_crowd( keys )

	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	

	--This function checks every 0.5 seconds for nearby units to the player, it grants a stack of the buff for each unit present beyond the player and 1 enemy
	Timers:CreateTimer(function()
		local casterLocation = caster:GetAbsOrigin()
		local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		local count = table.getn(nearbyUnits)
		if count > 2 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_roar_of_the_crowd_buff", {})
			caster:SetModifierStackCount("modifier_roar_of_the_crowd_buff", caster, count-2)
		else
			caster:RemoveModifierByName("modifier_roar_of_the_crowd_buff")
		end
    	return 0.5
    end
  	)
end
