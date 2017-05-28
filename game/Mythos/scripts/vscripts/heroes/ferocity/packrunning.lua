function packrunning( keys )

	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	
	Timers:CreateTimer(function()
		--print('timer packrunning')
		local casterLocation = caster:GetAbsOrigin()
		local allyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		local count = table.getn(allyHeroes)
		--print(count)
		if count > 0 then
			for i=1, count do
				local stack = allyHeroes[i]:GetModifierStackCount("modifier_packrunning_buff", caster)
				if count ~= stack then
					allyHeroes[i]:SetModifierStackCount("modifier_packrunning_buff", caster, count)
				end
			end
		end
      	return 0.5
    end
  	)
end
