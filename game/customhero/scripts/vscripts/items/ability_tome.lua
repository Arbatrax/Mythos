function Ability( event )
	local caster = event.caster
	
	local count = caster:GetAbilityPoints() 
	caster:SetAbilityPoints(count+1)
end