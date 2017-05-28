function Duel(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local spellduration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))


    --This function is called every frame and checks whether anyone effected by the duel debuff has tried to leave the radius 
    --if they do it resets them inside the circle 
    --anyone over 800 units outside the circle or magic immune has their debuff removed
	function CheckPos( event )
		local target = event.target
		local target_location = target:GetAbsOrigin()
		local distance = (target_location - caster_location):Length2D()
		local reset = (radius/distance) * (target_location-caster_location) + caster_location

		if distance > 800 or target:IsMagicImmune() then
			target:RemoveModifierByName("modifier_duel_trap")
		elseif distance > radius then
			target:SetAbsOrigin(reset)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_duel_phase", {duration=0.03})
		end
	end

	--This function spawns the spectators in a circle around the center point
	function SetSpectators(stuff)
		local spectators = ability:GetLevelSpecialValueFor("spectators", (ability:GetLevel() - 1))
		local increment = math.pi * 2/spectators
		local angle
		local spectators_pos = {}
		local spec_radius = radius + 75


		for i=0, spectators-1 do
			angle = increment * i
			local indivpos = Vector(spec_radius * math.cos(angle), spec_radius * math.sin(angle), caster_location[3] ) + caster_location
			local unit = CreateUnitByName("arena_spectator", indivpos, true, nil, nil, DOTA_TEAM_NEUTRALS)
			Timers:CreateTimer(spellduration, function()
      				unit:RemoveSelf()
      		end)
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_duel_spectator", {})
			unit:SetForwardVector(-Vector(spec_radius * math.cos(angle), spec_radius * math.sin(angle), 0):Normalized())
			unit:StartGesture(ACT_DOTA_VICTORY)
		end
	end
end