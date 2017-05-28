function Intimidate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local skillduration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

	print(skillduration)
	if caster:HasModifier("modifier_gladiator_stance") == true then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_intimidate_silence", {duration = skillduration})
	end
	if caster:HasModifier("modifier_guardian_stance") == true then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_intimidate_disarm", {duration = skillduration})
	end
end