
function leap_to_kill( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1)) * 0.03
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
	local hp = target:GetHealth()/target:GetMaxHealth()
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()
	local distance = (target_location - caster_location):Length2D()
	local direction = (target_location - caster_location):Normalized()
	local height = 70
	

	--Checks if the target is above 35% HP, if yes it ends the spell and resets the cooldown on Leap, if no it leaps to the target
	if hp > 0.35 then 
		ability:EndCooldown()
	else
		-- Moving the caster
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_leap_to_kill", {})
		caster:SetAbsOrigin(caster_location + Vector(0,0,height))
		Timers:CreateTimer(0, function()
			if distance > 135 then
				caster_location = caster:GetAbsOrigin() 
				target_location = target:GetAbsOrigin()
				distance = (target_location - caster_location):Length2D()
				direction = (target_location - caster_location):Normalized()
				caster_location[1] = caster_location[1] + direction[1] * speed
				caster_location[2] = caster_location[2] + direction[2] * speed
				caster:SetAbsOrigin(caster_location)
				return 0.03
			else
				--returns the caster to the ground
				caster:SetAbsOrigin(Vector(caster_location[1], caster_location[2], target_location[3]))
				Stun(keys)
			end

		end)
		--removes immunity while traveling
		
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_leap_to_kill_crit", {duration=4})
		
	end
	
end

function Stun(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration=stun_duration})
	caster:RemoveModifierByName("modifier_leap_to_kill")
end