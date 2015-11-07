function Unbreakable( event )
	local caster = event.caster
	local target = event.unit -- unit? The killed thing
	local ability = event.ability
	local stack_ability = caster:GetAbilityByIndex(3)
	local ult = caster:GetAbilityByIndex(4)
	local modifier = "modifier_blood_of_the_innocent_stack"
	local damage = event.attack_damage
	local reduction = ability:GetLevelSpecialValueFor( "reduction", ult:GetLevel() - 1 )

	local creep_stacks = stack_ability:GetLevelSpecialValueFor( "creep_stacks", stack_ability:GetLevel() - 1 )
	local hero_stacks = stack_ability:GetLevelSpecialValueFor( "hero_stacks", stack_ability:GetLevel() - 1 )
	local max_stacks = stack_ability:GetLevelSpecialValueFor( "max_stacks", stack_ability:GetLevel() - 1 )
	local ult_stacks = ult:GetLevelSpecialValueFor( "stacks", ult:GetLevel() - 1 )

	max_stacks = max_stacks + ult_stacks

	if damage <= reduction and damage > 0 then
		caster:SetHealth(caster:GetHealth() + damage)

		local stacks_gained = ability:GetLevelSpecialValueFor( "stacks_per_hit", 0)

		-- Check if the hero already has the modifier
		local current_stack = caster:GetModifierStackCount( modifier, stack_ability )
		if not current_stack then
			stack_ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
			current_stack = 0
		end

		-- Set the stack up to max_souls
		if (current_stack + stacks_gained) <= max_stacks then
			caster:SetModifierStackCount( modifier, stack_ability, current_stack + stacks_gained )
		else
			caster:SetModifierStackCount( modifier, stack_ability, max_stacks )
		end
	elseif damage > reduction then 
		caster:SetHealth(caster:GetHealth() + reduction)

		local stacks_gained = ability:GetLevelSpecialValueFor( "stacks_per_hit", 0)

		-- Check if the hero already has the modifier
		local current_stack = caster:GetModifierStackCount( modifier, stack_ability )
		if not current_stack then
			stack_ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
			current_stack = 0
		end

		-- Set the stack up to max_souls
		if (current_stack + stacks_gained) <= max_stacks then
			caster:SetModifierStackCount( modifier, stack_ability, current_stack + stacks_gained )
		else
			caster:SetModifierStackCount( modifier, stack_ability, max_stacks )
		end
	end
end