function AirStrike(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local bombs = ability:GetLevelSpecialValueFor("bombs", (ability:GetLevel() - 1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local targetOrigin = target:GetAbsOrigin()
	
	local plane1 = CreateUnitByName("plane", origin, true, target, nil, target:GetTeamNumber())
	local plane2
	local plane3