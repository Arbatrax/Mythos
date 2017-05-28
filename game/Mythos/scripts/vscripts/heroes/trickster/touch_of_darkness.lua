function SetUp(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if target:HasModifier("modifier_touch_of_darkness") == true then
		ParticleManager:DestroyParticle(target.particle, true)
	end

	target.particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_warlock/warlock_shadow_word_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, caster:GetTeam())

end

function BuffRemove(keys)
	local unit = keys.unit
	unit:RemoveModifierByName("modifier_touch_of_darkness")
end

function ParticleDestroy(keys)
	local target = keys.target
	ParticleManager:DestroyParticle(target.particle, true)
end
