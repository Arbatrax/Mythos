function Projectile( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local particleName = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
	local distance = 50
	local direction = caster:GetForwardVector()
	local casterLocation = caster:GetAbsOrigin()
	local startpoint = casterLocation + direction * distance


   	local unit = CreateUnitByName("fracture_dummy", startpoint, false, caster, caster, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_iris_dummy", {})
    local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, unit)
    ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.04, function()
		local info = 
		{
			Target = target,
			Source = caster,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf",
		    iMoveSpeed = speed,
			vSourceLoc= casterLocation,                -- Optional (HOW)
			bDrawsOnMinimap = false,                          -- Optional
		        bDodgeable = false,                                -- Optional
		        bIsAttack = false,                                -- Optional
		        bVisibleToEnemies = true,                         -- Optional
		        bReplaceExisting = false,                         -- Optional
		        flExpireTime = GameRules:GetGameTime() + 30,      -- Optional but recommended
			bProvidesVision = false,                           -- Optional
			iVisionRadius = 400,                              -- Optional
			iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
		unit:MoveToNPC(target)
    end
  	)

	Timers:CreateTimer( function()
		unit_location = unit:GetAbsOrigin() 
		target_location = target:GetAbsOrigin()
		distance = (target_location - unit_location):Length2D()

		if distance < 122 or target:IsAlive() == false then
			unit:RemoveSelf()
			ParticleManager:DestroyParticle(particle, true)
		else
			return 0.03
		end
    end
  	)
	unit:AddNoDraw()
end