function Dash( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin() 
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1)) * 0.03
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local distance = (target_point - caster_location):Length2D()
	local direction = (target_point - caster_location):Normalized()
	local traveled_distance = 100

	-- Moving the caster
	Timers:CreateTimer(0, function()
		caster:StartGesture( ACT_DOTA_RUN )
		if traveled_distance < distance then
			caster_location = caster_location + direction * speed
			caster:SetAbsOrigin(caster_location)
			traveled_distance = traveled_distance + speed
			return 0.03
		else
			
			caster:RemoveGesture( ACT_DOTA_RUN )
			caster:RemoveModifierByName("modifier_dash")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dash_speed", {duration = duration})
		end

	end)

end