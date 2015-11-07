function FactionBuff( event )
	local caster = event.caster
	
	local FactionInfo = GameRules.FactionTable[caster:GetUnitName()]

    if FactionInfo and FactionInfo == "Yerus" then
        caster:AddNewModifier(caster, nil, "modifier_rune_regen", {duration=10})
    elseif FactionInfo and FactionInfo == "Light" then
    	caster:AddNewModifier(caster, nil, "modifier_rune_haste", {duration=10})
	elseif FactionInfo and FactionInfo == "Unda" then
		caster:AddNewModifier(caster, nil, "modifier_rune_invis", {duration=10})
	elseif FactionInfo and FactionInfo == "Shadow" then
    end
end