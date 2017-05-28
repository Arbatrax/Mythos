function MasqueradeHide(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	target:AddNoDraw()
end

function Masquerade(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local illusion_count = ability:GetLevelSpecialValueFor("illusions", (ability:GetLevel() - 1))
	local duration = ability:GetLevelSpecialValueFor("spell_duration", (ability:GetLevel() - 1))
	local illusion_duration = ability:GetLevelSpecialValueFor("illusion_duration", (ability:GetLevel() - 1))
	local targetOrigin = target:GetAbsOrigin()
	local unit_name = target:GetUnitName()

	local time
	local illusion_table = {}

	local vRandomSpawnPos = {
		Vector( RandomInt( 50, 150 ), 0, 0 ),	
		Vector( 0, RandomInt( 50, 150 ), 0 ),	
		Vector( -RandomInt( 50, 150 ), 0, 0 ),	
		Vector( 0, -RandomInt( 50, 150 ), 0 ),	
		Vector( RandomInt( 50, 150 ), RandomInt( 50, 150 ), 0 ),		
		Vector( -RandomInt( 50, 150 ), -RandomInt( 50, 150 ), 0 ),		
		Vector( -RandomInt( 50, 150 ), RandomInt( 50, 150 ), 0 ),	
		Vector( RandomInt( 50, 150 ), -RandomInt( 50, 150 ), 0 ),	
		Vector( 0, 0, 0 ),	
	}

	local Gestures = {
		ACT_DOTA_RUN ,	
		ACT_DOTA_DIE ,	
		ACT_DOTA_FLAIL ,	
		ACT_DOTA_CAST_ABILITY_1 ,	
		ACT_DOTA_CAST_ABILITY_2 ,		
		ACT_DOTA_CAST_ABILITY_3 ,		
		ACT_DOTA_CAST_ABILITY_4 ,	
		ACT_DOTA_ATTACK ,	
		ACT_DOTA_SPAWN ,	
	}

	table.insert(illusion_table, target)


	for i=1,illusion_count do
		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local origin = targetOrigin + table.remove( vRandomSpawnPos, 1 )
		local illusion = CreateUnitByName(unit_name, origin, true, target, nil, target:GetTeamNumber())
		table.insert(illusion_table, illusion)
		illusion:AddNoDraw()
		illusion:SetPlayerID(target:GetPlayerID())
		

		-- Level Up the unit to the targets level
		local targetLevel = target:GetLevel()
		for i=1,targetLevel-1 do
			illusion:HeroLevelUp(false)
		end

		-- Set the skill points to 0 and learn the skills of the target
		illusion:SetAbilityPoints(0)
		for abilitySlot=0,15 do
			local ability = target:GetAbilityByIndex(abilitySlot)
			if ability ~= nil then 
				local abilityLevel = ability:GetLevel()
				local abilityName = ability:GetAbilityName()
				local illusionAbility = illusion:FindAbilityByName(abilityName)
				illusionAbility:SetLevel(abilityLevel)
			end
		end

		-- Set the unit as an illusion
		-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = illusion_duration, outgoing_damage = 0, incoming_damage = 300 })
		
		ability:ApplyDataDrivenModifier(caster, illusion, "modifier_masquerade_illusion", {})
		ability:ApplyDataDrivenModifier(caster, illusion, "modifier_masquerade_explosion", {duration = illusion_duration-0.1})
		ability:ApplyDataDrivenModifier(caster, illusion, "modifier_masquerade_target", {})

		-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
		illusion:MakeIllusion()
		-- Set the illusion hp to be the same as the target
		illusion:SetHealth(target:GetHealth())
		illusion:SetForwardVector(Vector(math.random(-10000,10000), math.random(-10000,10000)))
	end

	origin = targetOrigin + table.remove( vRandomSpawnPos, 1 )
	FindClearSpaceForUnit( target, origin, true )
	target:SetForwardVector(Vector(math.random(-10000,10000), math.random(-10000,10000)))

	for i=#illusion_table, 2, -1 do	-- Simply shuffle them
		local j = RandomInt( 1, i )
		illusion_table[i], illusion_table[j] = illusion_table[j], illusion_table[i]
	end

	local k = 1
	Timers:CreateTimer(function()

		illusion_table[k]:RemoveNoDraw()

		if illusion_table[k] == target then
			EndAnimation(target, Gestures[1])
		end
		illusion_table[k]:StartGesture(table.remove( Gestures, 1 ))
	
		illusion_table[k]:RemoveModifierByName("modifier_masquerade_target")


    	k = k +1
    	if k <= illusion_count + 1 then
    		return duration/illusion_count
    	end
    end
 	)
end

function EndAnimation(target, animation)
  Timers:CreateTimer(3, function()
      target:RemoveGesture(animation)
    end
  )
end
