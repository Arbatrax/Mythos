
function Ascend( keys )
	local caster = keys.caster
	local target_location = keys.target_points[1]
	local ability = keys.ability
	local speed = 2000 * 0.03
	local caster_location = caster:GetAbsOrigin()
	local peak = Vector(caster_location[1], caster_location[2], 1000)

	

	-- Moving the caster
	Timers:CreateTimer(function()
		if caster_location[3] < 1000 then
			caster_location = caster:GetAbsOrigin() 
			distance = (peak - caster_location):Length2D()
			direction = (peak - caster_location):Normalized()
			caster_location = caster_location + direction * speed
			caster:SetAbsOrigin(caster_location)
			return 0.03
		else
			--begins decesent
			caster:SetAbsOrigin(Vector(target_location[1], target_location[2], 1000))
			Timers:CreateTimer(function()
			if caster_location[3] > target_location[3]+10 then
				caster_location = caster:GetAbsOrigin() 
				distance = (target_location - caster_location):Length2D()
				direction = (target_location - caster_location):Normalized()
				caster_location = caster_location + direction * speed
				caster:SetAbsOrigin(caster_location)
				return 0.03
			else
				caster:RemoveModifierByName("modifier_dive_bomb")
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_dive_bomb_blast", {duration=1})
			end

			end)	

		end
		
	end)

	function Blast()
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() - 1))
		ability:ApplyDataDrivenModifier(caster, target, "modifier_leap_to_kill_debuff", {duration=stun_duration})
		caster:RemoveModifierByName("modifier_leap_to_kill")
	end		
end
	


