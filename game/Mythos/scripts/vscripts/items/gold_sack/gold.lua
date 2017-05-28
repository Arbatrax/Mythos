function GiveGold( keys )
	local caster = keys.caster
	local ability = keys.ability
	local min = ability:GetLevelSpecialValueFor("goldmin", 0)
	local max = ability:GetLevelSpecialValueFor("goldmax", 0)
	local goldgain = math.random(min, max)
	
	caster:ModifyGold(goldgain, false, 13)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, caster, goldgain, nil )
end