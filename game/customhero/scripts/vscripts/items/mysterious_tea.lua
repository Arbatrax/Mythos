function Mana( event )
	local caster = event.caster
	local ability = event.ability
	local count = caster:GetModifierStackCount("modifier_mysterious_tea_boost", caster)

	if count < 1 then 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mysterious_tea_boost", {})
		caster:SetModifierStackCount("modifier_mysterious_tea_boost", caster, 1)	
	else
		caster:SetModifierStackCount("modifier_mysterious_tea_boost", caster, 1+count)
	end
end