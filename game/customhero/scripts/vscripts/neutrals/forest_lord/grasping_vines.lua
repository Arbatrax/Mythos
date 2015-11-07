function GraspingVines( keys )

	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	local location
	local casterLocation = caster:GetAbsOrigin()
	local allyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	local count = table.getn(allyHeroes)
	local unit
	--print(count)
	if count > 0 then
		for i=1, count, 1 do
			location = allyHeroes[i]:GetAbsOrigin()
			unit = CreateUnitByName("neutral_treant_summon", location, true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit:AddNewModifier(caster, nil, "modifier_kill", {duration = 10})
		end
	end
end