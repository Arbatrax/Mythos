function TempestParticle( event )
	local caster = event.caster
	local ability = event.ability
	local location = caster:GetAbsOrigin()
	local particleName = "particles/units/heroes/hero_slardar/slardar_typhoon2amp_damage.vpcf"
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tempest_aura", {duration = duration})

	if caster.AmpDamageParticle then
		ParticleManager:DestroyParticle(caster.AmpDamageParticle,false)
	end

-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function() 
		caster.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControl(caster.AmpDamageParticle, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(caster.AmpDamageParticle, 2, caster:GetAbsOrigin())

		ParticleManager:SetParticleControlEnt(caster.AmpDamageParticle, 1, caster, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster.AmpDamageParticle, 2, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end)

	Timers:CreateTimer(duration, function() 
		ParticleManager:DestroyParticle(caster.AmpDamageParticle,false)
	end)
end
