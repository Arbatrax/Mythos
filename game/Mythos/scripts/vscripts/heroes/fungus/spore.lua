function MushroomHeal( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)

	if IsValidEntity(caster.mushroom) and caster.mushroom:IsAlive() then
		ability:ApplyDataDrivenModifier(caster.mushroom, caster.mushroom, "modifier_spore_effect", {})
		EmitSoundOn("Hero_Leshrac.Pulse_Nova", caster.mushroom)
	end
end

function MushroomHealEnd(keys)
	local caster = keys.caster
	if IsValidEntity(caster.mushroom) and caster.mushroom:IsAlive() then
		caster.mushroom:RemoveModifierByName("modifier_spore_effect")
	end
	StopSoundEvent("Hero_Leshrac.Pulse_Nova", caster)
	StopSoundEvent("Hero_Leshrac.Pulse_Nova", caster.mushroom)
end