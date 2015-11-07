function FungalSpore( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local jumps = ability:GetLevelSpecialValueFor("jumps", (ability:GetLevel() - 1))
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() - 1))
	local target_location = target:GetAbsOrigin()
	local nearbyUnits
	local buff = "modifier_fungal_spore_positive"

	if 2 == target:GetTeam() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fungal_spore_positive", {duration = duration})
	elseif 2 ~= target:GetTeam() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fungal_spore_negative", {duration = duration})
	end

	function FungalSporePos (keys)
		if jumps > 0 then
  			nearbyUnits = FindUnitsInRadius(caster:GetTeam(), target_location, nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 1, false)
  			if nearbyUnits[2] == caster.mushroom then
				ability:ApplyDataDrivenModifier(caster, nearbyUnits[2], "modifier_fungal_spore_positive", {duration = duration})
				jumps = ability:GetLevelSpecialValueFor("jumps", (ability:GetLevel() - 1))
				target_location = nearbyUnits[2]:GetAbsOrigin()
  			elseif nearbyUnits[2] ~= nil then
				ability:ApplyDataDrivenModifier(caster, nearbyUnits[2], "modifier_fungal_spore_positive", {duration = duration})
				jumps = jumps - 1
				target_location = nearbyUnits[2]:GetAbsOrigin()
  			end
  		end
  	end
	
	function FungalSporeNeg(keys)
		if jumps > 0 then
  			nearbyUnits = FindUnitsInRadius(caster:GetTeam(), target_location, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 1, false)
  			if nearbyUnits[2] ~= nil then
  				ability:ApplyDataDrivenModifier(caster, nearbyUnits[2], "modifier_fungal_spore_negative", {duration = duration})
  				jumps = jumps - 1
  				target_location = nearbyUnits[2]:GetAbsOrigin()
  			end
  		end  
	end

end
