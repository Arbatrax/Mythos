function Dispersion( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local attack_damage = keys.attack_damage * damage * .01

	local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 1, false)
	local num = table.getn(nearbyUnits)
	if num > 1 then
		for i = 2, num do
			local damageTable = {
						victim = nearbyUnits[i],
						attacker = caster,
						damage = attack_damage,
						damage_type = DAMAGE_TYPE_PURE,
					}
			ApplyDamage(damageTable)
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_unstable_current.vpcf", PATTACH_CUSTOMORIGIN, target)
			local nearbyUnitLocation = nearbyUnits[i]:GetAbsOrigin()
			ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
			ParticleManager:SetParticleControlEnt(particle, 1, nearbyUnits[i], PATTACH_POINT_FOLLOW, "attach_hitloc", nearbyUnitLocation, true)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end
end

