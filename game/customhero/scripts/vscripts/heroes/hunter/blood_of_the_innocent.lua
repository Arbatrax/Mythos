function StackIncrement( event )
	local caster = event.caster
	local target = event.unit -- unit? The killed thing
	local ability = event.ability
	local stack_ability = caster:GetAbilityByIndex(3)
	local ult = caster:GetAbilityByIndex(4)
	local modifier = "modifier_blood_of_the_innocent_stack"

	local creep_stacks = stack_ability:GetLevelSpecialValueFor( "creep_stacks", stack_ability:GetLevel() - 1 )
	local hero_stacks = stack_ability:GetLevelSpecialValueFor( "hero_stacks", stack_ability:GetLevel() - 1 )
	local max_stacks = stack_ability:GetLevelSpecialValueFor( "max_stacks", stack_ability:GetLevel() - 1 )
	local ult_stacks = ult:GetLevelSpecialValueFor( "stacks", ult:GetLevel() - 1 )

	max_stacks = max_stacks + ult_stacks

	if ability == caster:GetAbilityByIndex(1) then
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
	elseif ability == caster:GetAbilityByIndex(2) then
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
	elseif ability == stack_ability then
		-- Check how many stacks can be granted
		local stacks_gained = creep_stacks
		if target:IsRealHero() then
			stacks_gained = hero_stacks
		end

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

function StackDecrement( event )
	local caster = event.caster
	local target = event.target
	local stack_ability = caster:GetAbilityByIndex(3)
	local ult = caster:GetAbilityByIndex(4)
	local modifier = "modifier_blood_of_the_innocent_stack"

	local current_stack = caster:GetModifierStackCount( modifier, stack_ability )
	if not current_stack then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		current_stack = 0
	end

	if current_stack > 0 then
		caster:SetModifierStackCount( modifier, stack_ability, current_stack - 1 )
	else
		caster:SetModifierStackCount( modifier, stack_ability, 0 )
		caster:RemoveModifierByName("modifier_hysteria_buff")
		RemoveAnimationTranslate(caster)
		ult:ToggleAbility()
	end
end

function Cleave (event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local ability = event.ability
	local modifier = "modifier_blood_of_the_innocent_stack"
	local stack_count = caster:GetModifierStackCount( modifier, ability )
	local damage_modifier = math.abs(stack_count-60) * .01
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )

	if stack_count < 60 then
		DoCleaveAttack(caster, target, ability, damage*damage_modifier, radius, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
	end
end