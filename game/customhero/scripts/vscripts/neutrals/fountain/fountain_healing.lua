function Heal( keys )
	local target = keys.target
	local ability = keys.ability
	local heal = target:GetMaxHealth() * ability:GetLevelSpecialValueFor("heal", (ability:GetLevel() - 1)) * 0.01
	local mana = target:GetMaxMana() * ability:GetLevelSpecialValueFor("heal", (ability:GetLevel() - 1)) * 0.01
	
	target:GiveMana(mana*0.1)
	target:Heal(heal*0.1, caster)
end
