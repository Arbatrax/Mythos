function Backlash(keys)
	local target = keys.unit
	local ability = keys.ability
	local damage_percent = ability:GetLevelSpecialValueFor( "damage_percent", ability:GetLevel() - 1 )
	local hp = target:GetMaxHealth()

	print("hello")
	
	local damageTable = {
		victim = target,
		attacker = target,
		damage = damage_percent * hp,
		damage_type = DAMAGE_TYPE_PURE,
	}
 
	ApplyDamage(damageTable)
end