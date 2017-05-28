function UnbreakableSetUp(event)
	local caster = event.caster

	caster.unbreakable_damage = 0
end

function Unbreakable( event )
	local caster = event.caster
	local target = event.unit -- unit? The killed thing
	local ability = event.ability
	local stack_ability = caster:GetAbilityByIndex(3)
	local ult = caster:GetAbilityByIndex(4)
	local modifier = "modifier_blood_of_the_innocent_stack"
	local damage = event.attack_damage
	if damage < 25 then
		return
	end

	local creep_stacks = stack_ability:GetLevelSpecialValueFor( "creep_stacks", stack_ability:GetLevel() - 1 )
	local hero_stacks = stack_ability:GetLevelSpecialValueFor( "hero_stacks", stack_ability:GetLevel() - 1 )
	local max_stacks = stack_ability:GetLevelSpecialValueFor( "max_stacks", stack_ability:GetLevel() - 1 )
	local ult_stacks = ult:GetLevelSpecialValueFor( "stacks", ult:GetLevel() - 1 )

	max_stacks = max_stacks + ult_stacks

	caster.unbreakable_damage = caster.unbreakable_damage + damage

	local stacks_gained = ability:GetLevelSpecialValueFor( "stacks_per_hit", 0)
	if damage < 25 then
		return
	end

	-- Check if the hero already has the modifier
	local current_stack = caster:GetModifierStackCount( modifier, stack_ability )
	if not current_stack then
		stack_ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		current_stack = 0
	end

	-- Set the stack up to max
	if (current_stack + stacks_gained) <= max_stacks then
		caster:SetModifierStackCount( modifier, stack_ability, current_stack + stacks_gained )
	else
		caster:SetModifierStackCount( modifier, stack_ability, max_stacks )
	end
end

function UnbreakableExplode(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local casterLocation = caster:GetAbsOrigin()
	local nearbyUnits = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	local count = table.getn(nearbyUnits)

	for i=1,count do
		local damageTable = {
		victim = nearbyUnits[i],
		attacker = caster,
		damage = caster.unbreakable_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	 
	ApplyDamage(damageTable)
	end
end