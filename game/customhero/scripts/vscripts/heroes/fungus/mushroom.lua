function Mushroom( keys )

	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	local location = keys.target_points[1] 

	if IsValidEntity(caster.mushroom) and caster.mushroom:IsAlive() then
		caster.mushroom:AddNewModifier(caster, nil, "modifier_kill", {duration = 0.2})
	end
	caster.mushroom = CreateUnitByName("mushroom", location, true, nil, nil, DOTA_TEAM_GOODGUYS)
	ability:ApplyDataDrivenModifier(caster, caster.mushroom, "modifier_mushroom", {})
	EmitSoundOn("Hero_Treant.LeechSeed.Target", caster.mushroom)
end