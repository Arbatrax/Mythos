function CrazedAcolyte( event )
	local caster = event.caster
	local caster_location = caster:GetAbsOrigin()
	local unit_name = caster:GetUnitName()
	local player = caster:GetPlayerID()
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local casterOrigin = caster:GetAbsOrigin()
	local target = event.target
	local target_location = target:GetAbsOrigin()
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 ) * 0.03
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local silence_duration = ability:GetLevelSpecialValueFor( "silence_duration", ability:GetLevel() - 1 )


	-- handle_UnitOwner needs to be nil, else it will crash the game.
	local distance = (target_location - caster_location):Length2D()
	local direction = (target_location - caster_location):Normalized()
	local illusion_location = caster_location + direction * 100

	local illusion = CreateUnitByName(unit_name, illusion_location, true, caster, nil, caster:GetTeamNumber())
	illusion_location = illusion:GetAbsOrigin()
	distance = (target_location - illusion_location):Length2D()
	direction = (target_location - illusion_location):Normalized()

	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = 0, incoming_damage = 200 })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()

	-- Set the illusion hp to be the same as the caster
	illusion:SetHealth(caster:GetHealth())

	ability:ApplyDataDrivenModifier(illusion, illusion, "modifier_crazed_acolyte", {})
	illusion:StartGesture(1508)

	Timers:CreateTimer( function()
		if illusion:IsAlive() and distance > 50 then
			illusion_location = illusion:GetAbsOrigin() 
			target_location = target:GetAbsOrigin()
			distance = (target_location - illusion_location):Length2D()
			direction = (target_location - illusion_location):Normalized()
			illusion:SetForwardVector(direction)
			illusion_location = illusion_location + direction * speed
			illusion:SetAbsOrigin(illusion_location)
			return 0.03
		elseif distance < 50 then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf" , PATTACH_WORLDORIGIN , illusion)
			ParticleManager:SetParticleControl(particle, 0 , illusion_location)
			ParticleManager:SetParticleControl(particle, 1 , Vector(150, 2, 300))
			illusion:ForceKill(false)		

			local damageTable = {
						victim = target,
						attacker = caster,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
			ApplyDamage( damageTable )
			EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Target", target)
			target:AddNewModifier(caster, ability, "modifier_silence", {duration=silence_duration})
		end

	end)
end