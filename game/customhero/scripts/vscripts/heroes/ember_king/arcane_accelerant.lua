function PhoenixBuff( keys )	
	local caster = keys.caster
	local ability = keys.ability
	
	if caster.phoenix and IsValidEntity(caster.phoenix) and caster.phoenix:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, caster.phoenix, "modifier_arcane_accelerant_caster", {})
	end
end
