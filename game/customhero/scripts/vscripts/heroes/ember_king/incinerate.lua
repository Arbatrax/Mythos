function Incinerate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))

	if target:HasModifier("modifier_searing") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_incinerate_stun", {duration=duration})
		print("TRUEUEUEUEUE")
	end
end
	