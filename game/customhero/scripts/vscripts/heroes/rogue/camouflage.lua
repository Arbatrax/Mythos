function Check( keys )
	local caster = keys.caster
	local ability = keys.rogue
	
	if ability ~= caster:GetAbilityByIndex(1) then
		caster:RemoveModifierByName("modifier_camouflage")
 		caster:RemoveModifierByName("modifier_invisible")
 	end
end