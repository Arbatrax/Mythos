function FrozenTomb (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	 
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
	    iMoveSpeed = 900,
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
	    bDodgeable = false,                                -- Optional
	    bIsAttack = false,                                -- Optional
	    bVisibleToEnemies = true,                         -- Optional
	    bReplaceExisting = false,                         -- Optional
	    flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 250,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function Collide(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))


	local damageTable = {
		victim = target,
		attacker = player,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = ability --Optional.
	}
	 
	ApplyDamage(damageTable)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_frozen_tomb_stun", {duration = stun_duration})
end

function Slow(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local slow_duration = ability:GetLevelSpecialValueFor("slow_duration", (ability:GetLevel() - 1))


	ability:ApplyDataDrivenModifier(caster, target, "modifier_frozen_tomb_slow", {duration = slow_duration})
end