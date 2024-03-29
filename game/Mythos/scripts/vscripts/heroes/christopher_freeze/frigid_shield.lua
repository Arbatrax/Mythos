function FrigidShieldInitialize( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stack = keys.modifier_stack
	local max_stacks = ability:GetLevelSpecialValueFor("charges", ability_level)

	target:SetModifierStackCount(modifier_stack, ability, max_stacks)

	function FrigidShieldCounter( keys )	
		local current_stack = target:GetModifierStackCount(modifier_stack, ability)

		-- If its 1 then remove the modifier entirely, otherwise just reduce the stack number by 1
		if current_stack <= 1 then
			target:RemoveModifierByNameAndCaster(modifier_stack, caster)
		else
			target:SetModifierStackCount(modifier_stack, ability, current_stack - 1)
		end
		
	end
end

