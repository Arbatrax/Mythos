function Overcharge( keys )

	local caster = keys.caster
	local ability = keys.ability
	local max_stacks = ability:GetSpecialValueFor("max_stacks")
	local recharge = ability:GetSpecialValueFor("recharge")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_overcharge_damage", {})
	Timers:CreateTimer(function()
		local count = caster:GetModifierStackCount("modifier_overcharge_damage", caster)
		if count == 0  then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_overcharge_damage", {})
			caster:SetModifierStackCount("modifier_overcharge_damage", caster, 1)
		elseif count < max_stacks then
			caster:SetModifierStackCount("modifier_overcharge_damage", caster, count+1)
		end
    	return recharge
    end
  	)
end
