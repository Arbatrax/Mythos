function Activate(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

	if attacker:IsHero() then 
		ability:SetActivated(true)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_riposte_activate", {duration=duration})
	end
end

function Deactivate(keys)
	local caster = keys.caster
	local ability = keys.ability

	ability:SetActivated(false)
end

function Riposte( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local distance = ability:GetLevelSpecialValueFor("knockback_distance_max", (ability:GetLevel() - 1))
	local duration = ability:GetLevelSpecialValueFor("knockback_duration", (ability:GetLevel() - 1))
	local height = ability:GetLevelSpecialValueFor("knockback_height", (ability:GetLevel() - 1))
	local atkdmg = caster:GetAttackDamage()
	local location = caster:GetAbsOrigin()
	local point = location + caster:GetForwardVector() * radius

	local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP, 0, 0, false)

	for i=1,table.getn(units) do

		local knockbackModifierTable =
	    {
	        should_stun = 0,
	        knockback_duration = duration,
	        duration = duration,
	        knockback_distance = distance,
	        knockback_height = height,
	        center_x = caster:GetAbsOrigin().x,
	        center_y = caster:GetAbsOrigin().y,
	        center_z = caster:GetAbsOrigin().z
	    }
		local damageTable = {
			victim = units[i],
			attacker = caster,
			damage = atkdmg + damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		 
		ApplyDamage(damageTable)
	    units[i]:AddNewModifier( caster, nil, "modifier_knockback", knockbackModifierTable )
	end
end