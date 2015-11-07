function IronFur( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stack = caster:GetModifierStackCount("modifier_iron_fur_stack", caster)

	ability:ApplyDataDrivenModifier(caster, caster, ("modifier_iron_fur_stack"), {duration=10})
	if stack < 6 then
		caster:SetModifierStackCount("modifier_iron_fur_stack", caster, stack+1)
	else
		caster:SetModifierStackCount("modifier_iron_fur_stack", caster, stack)
	end
end
