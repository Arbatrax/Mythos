function GlacialTomb(keys)
	local caster = keys.caster
	local ability = keys.ability
	local debuff_count = ability:GetLevelSpecialValueFor("debuff_count", 1)
	local stack_count = ability:GetLevelSpecialValueFor("stack_count", 1)
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	local casterLocation = caster:GetAbsOrigin()
	local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
	local count = table.getn(nearbyUnits)

	for i=1,count do
		if debuff_count > 0 then
			ability:ApplyDataDrivenModifier(caster, nearbyUnits[i], "modifier_glacial_tomb_debuff", {})
			nearbyUnits[i]:SetModifierStackCount("modifier_glacial_tomb_debuff", caster, stack_count)
			debuff_count = debuff_count - 1
		end
	end
end

function TombProximity(keys)
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("debuff_radius", 1)
	local stacks_per_sec = ability:GetLevelSpecialValueFor("stacks_per_sec", 1)
	local unitLocation = unit:GetAbsOrigin()
	local nearbyUnits = FindUnitsInRadius(unit:GetTeam(), unitLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 1, false)
	local count = table.getn(nearbyUnits)
	local friendlies = 0
	local current_stacks = unit:GetModifierStackCount("modifier_glacial_tomb_debuff", caster)

	if count > 1 then
		for i=2,count do
			if nearbyUnits[i]:HasModifier("modifier_glacial_tomb_debuff") == false then
				friendlies = friendlies + 1
			end
		end

		local new_stacks = (current_stacks - (stacks_per_sec/10 * friendlies))

		if new_stacks <= 0 then
			unit:RemoveModifierByName("modifier_glacial_tomb_debuff")
		else
			unit:SetModifierStackCount("modifier_glacial_tomb_debuff", caster, new_stacks)
		end
	end
end

function GlacialAI(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", 1)
	local glacial_tomb = caster:GetAbilityByIndex(1)

  	Timers:CreateTimer(15, function()
		local casterLocation = caster:GetAbsOrigin()
		local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 2, false)
		local count = table.getn(nearbyUnits)
			print(count)
		if count > 0 then
			caster:CastAbilityNoTarget(glacial_tomb, 1)
		end
    	return cooldown
    end
  	)
end