function Fire(keys)
	local caster = keys.caster

	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_ATTACK, rate=1.0, translate="Espada_pistola", translate2="tidebringer"})
end

function Damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multiplier = ability:GetLevelSpecialValueFor( "damage_multiplier", ability:GetLevel() - 1 )

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = caster:GetAgility() * multiplier,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
 
	ApplyDamage(damageTable)
end