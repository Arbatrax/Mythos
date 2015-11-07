function UnitKill( keys )
	local caster = keys.caster
	local ability = keys.ability
	local unit = keys.unit
	local unit_location = unit:GetAbsOrigin()
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local stacks = ability:GetLevelSpecialValueFor("stacks_per_hit", (ability:GetLevel() - 1))
	local max = ability:GetLevelSpecialValueFor("max_vampires", (ability:GetLevel() - 1))

	if caster.unit_count == nil then
		caster.unit_count = 0
	end

	if caster.unit_count < 5 then
		local unit = CreateUnitByName("vampire", unit_location, true, nil, nil, caster:GetTeam())   
		unit:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_vampirism_vampire", {})

		caster.unit_count = caster.unit_count + 1
	end
end

function ResetCount( keys )
	local caster = keys.caster

	caster.unit_count = caster.unit_count - 1
end