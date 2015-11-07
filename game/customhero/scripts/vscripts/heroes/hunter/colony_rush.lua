function ColonyRush(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

    local point_difference_normalized = (point - caster:GetAbsOrigin()):Normalized()

	local info = 
	{
		Ability = ability,
        	EffectName = "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin(),
        	fDistance = 1400,
        	fStartRadius = 50,
        	fEndRadius = 50,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = point_difference_normalized * 800,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)


end