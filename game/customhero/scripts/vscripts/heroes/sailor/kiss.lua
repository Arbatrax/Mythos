function TakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = keys.attack_damage
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local threshold = ability:GetLevelSpecialValueFor("threshold", (ability:GetLevel() - 1))
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", (ability:GetLevel() - 1))
	local heal = ability:GetLevelSpecialValueFor("bonus_health", (ability:GetLevel() - 1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local hp = caster:GetMaxHealth()
	local current = caster:GetHealth()
	local absorb = threshold * hp *0.01
	local modifierName = "modifier_kiss_passive"
	local location = caster:GetAbsOrigin()

	if damage >= absorb and current > 0 then
		ability:StartCooldown(cooldown)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kiss_buff", {duration=duration})
		caster:AddNewModifier(caster, ability, "modifier_kiss_transform", {duration=duration})
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN, caster)

		caster:Heal(heal, caster)

		local unit = CreateUnitByName("fracture_dummy", location, false, caster, caster, caster:GetTeam()) 
		unit:AddNoDraw()
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_kiss_mist", {})
		unit:AddNewModifier(caster, ability, "modifier_kill", {duration=duration})

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sailor/mistsmoke.vpcf", PATTACH_ABSORIGIN, caster)
 		ParticleManager:SetParticleControl(particle, 0, Vector(location[1], location[2], location[3]+10))
 		ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))

 		Timers:CreateTimer(duration, function()
	        ParticleManager:DestroyParticle(particle, true)
	    end)

		caster:RemoveModifierByName(modifierName) 
	    Timers:CreateTimer(cooldown, function()
	        ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
	    end)
	elseif current == 0 then
	    local unit = CreateUnitByName("fracture_dummy", location, false, caster, caster, caster:GetTeam()) 
		unit:AddNoDraw()
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_kiss_mist", {})
		unit:AddNewModifier(caster, ability, "modifier_kill", {duration=duration})

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sailor/mistsmoke.vpcf", PATTACH_ABSORIGIN, caster)
 		ParticleManager:SetParticleControl(particle, 0, Vector(location[1], location[2], location[3]+20))
 		ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))

 		Timers:CreateTimer(duration, function()
	        ParticleManager:DestroyParticle(particle, true)
	    end)

		caster:RemoveModifierByName(modifierName) 
	    Timers:CreateTimer(cooldown, function()
	        ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
	    end)
	end
end