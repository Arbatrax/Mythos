function MeltDownDamage( keys )	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetMaxHealth() * 0.015

	-- Deals damage to phoenix and the target
	local damageTable = {
						victim = caster,
						attacker = caster,
						damage = damage,
						damage_type = DAMAGE_TYPE_PURE,
					}
			ApplyDamage( damageTable )
			damageTable = {
						victim = target,
						attacker = caster,
						damage = damage,
						damage_type = DAMAGE_TYPE_PURE,
					}
			ApplyDamage( damageTable )
end

function StopSound( keys )
	StopSoundEvent( keys.sound_name, keys.caster )
end