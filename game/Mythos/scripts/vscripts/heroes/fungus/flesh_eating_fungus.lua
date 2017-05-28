function FleshEatingFungus(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local threshold = ability:GetLevelSpecialValueFor("threshold", (ability:GetLevel() - 1))
	local target_health
	local sound = "Hero_Pudge.Rot"

	Timers:CreateTimer(function()
	 	target_health = target:GetHealth()/target:GetMaxHealth()
	 	if target_health > (threshold / 100) then
      		return 0.25
	 	else
	 		target:RemoveModifierByName("modifier_flesh_eating_fungus")
			StopSoundEvent(sound, target)
	 	end 		
    end
  	)
end
