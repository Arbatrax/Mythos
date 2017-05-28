function Drop(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()

	caster:DropItemAtPositionImmediate(ability, location)
end