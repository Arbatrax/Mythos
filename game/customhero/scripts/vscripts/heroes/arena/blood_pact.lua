function BloodPact( event )
	local caster = event.caster
	local ability = event.ability
	local health_cost = ability:GetSpecialValueFor("health_cost")
	local sacrifice = caster:GetHealth() * .01 * health_cost

	print(sacrifice)

	local damageTable = {
		victim = caster,
		attacker = caster,
		damage = sacrifice,
		damage_type = DAMAGE_TYPE_PURE,
	}
 
	ApplyDamage(damageTable)
end