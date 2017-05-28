function Lightning( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1] 
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

	for i=1,table.getn(units) do 
    	 ability:ApplyDataDrivenModifier(caster, units[i], "modifier_dimensional_lightning", {duration = duration})
    end

	Timers:CreateTimer(function()
	    if caster:HasModifier("modifier_dimensional_lightning_buff") then
			for i=1,table.getn(units) do
				local damageTable = {
					victim = units[i],
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage(damageTable)

				units[i]:AddNewModifier(caster, ability, "modifier_dimensional_lightning_transform", {})

				local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(lightningBolt,0, caster:GetAbsOrigin())	
				ParticleManager:SetParticleControl(lightningBolt,1, units[i]:GetAbsOrigin())
				units[i]:EmitSound("Hero_ShadowShaman.EtherShock.Target")
			end
	    	return 1
		end
	end)
end

function CheckForBuff(keys)
	local caster = keys.caster
	local target = keys.target

	if caster:HasModifier("modifier_dimensional_lightning_buff") == false then
		if target:HasModifier("modifier_dimensional_lightning") then
			target:RemoveModifierByName("modifier_dimensional_lightning")
			target:RemoveModifierByName("modifier_dimensional_lightning_transform")
		end
	end
end

