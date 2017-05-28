function roar_of_the_crowd( keys )

	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	
	Timers:CreateTimer(function()
		local casterLocation = caster:GetAbsOrigin()
		local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		local count = table.getn(nearbyUnits)
		if count > 2 then
			caster:RemoveModifierByName("modifier_roar_of_the_crowd_debuff")
			caster:SetModifierStackCount("modifier_roar_of_the_crowd_buff", caster, count-2)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_roar_of_the_crowd_debuff", {})
			caster:SetModifierStackCount("modifier_roar_of_the_crowd_buff", caster, 0)
		end
    	return 0.5
    end
  	)
end
