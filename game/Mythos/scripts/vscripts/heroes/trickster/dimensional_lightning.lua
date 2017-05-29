function Lightning( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1] 
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	if caster.lightning_units then
		for i=1,table.getn(caster.lightning_units) do 
			if caster.lightning_units[i]:HasModifier("modifier_dimensional_lightning") then
    			caster.lightning_units[i]:RemoveModifierByName("modifier_dimensional_lightning")
    		end
    	end
    end

	caster.lightning_units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

	for i=1,table.getn(caster.lightning_units) do 
    	ability:ApplyDataDrivenModifier(caster, caster.lightning_units[i], "modifier_dimensional_lightning", {duration = duration})

    	local damageTable = {
		victim = caster.lightning_units[i],
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)

		caster.lightning_units[i]:AddNewModifier(caster, ability, "modifier_dimensional_lightning_transform", {})

		local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(lightningBolt, 0, caster:GetAbsOrigin())	
		ParticleManager:SetParticleControl(lightningBolt, 1, caster.lightning_units[i]:GetAbsOrigin())
		caster.lightning_units[i]:EmitSound("Hero_ShadowShaman.EtherShock.Target")
    end
end

function LightningTick(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))

	target:RemoveModifierByName("modifier_dimensional_lightning_transform")

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)

	target:AddNewModifier(caster, ability, "modifier_dimensional_lightning_transform", {})

	local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(lightningBolt, 0, caster:GetAbsOrigin())	
	ParticleManager:SetParticleControl(lightningBolt, 1, target:GetAbsOrigin())
	target:EmitSound("Hero_ShadowShaman.EtherShock.Target")
	ParticleManager:ReleaseParticleIndex(lightningBolt)

end

function ChannelFinish(keys)
	local caster = keys.caster

	for i=1,table.getn(caster.lightning_units) do 
		caster.lightning_units[i]:RemoveModifierByName("modifier_dimensional_lightning")
		caster.lightning_units[i]:RemoveModifierByName("modifier_dimensional_lightning_transform")
    end
end


