function Blind(keys)
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )

	local day = target:GetDayTimeVisionRange()
	local night = target:GetNightTimeVisionRange()

	target:SetDayTimeVisionRange(0)
	target:SetNightTimeVisionRange(0)

	Timers:CreateTimer(duration, function()
   		target:SetDayTimeVisionRange(day)
		target:SetNightTimeVisionRange(night)
   	end)
end