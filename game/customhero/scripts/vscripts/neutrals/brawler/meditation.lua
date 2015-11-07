function Meditation( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	
	Timers:CreateTimer(function()
		local casterLocation = caster:GetAbsOrigin()
		local nearbyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, 0, 1, false)
		local count = table.getn(nearbyHeroes)

		if count > 0 then
			local hero = nearbyHeroes[1]
			print(hero:GetUnitName())
			caster:RemoveModifierByName("modifier_meditation")
			EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), "Hero_Puck.Phase_Shift", caster)
		else
      		return 0.03			
		end
    end)
end

function Brawling( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attack_damage = keys.attack_damage
	local attacker = keys.attacker
	local health = caster:GetHealth()

	--If you kill the the brawler it makes him immune and friendly
	if attack_damage >= health then
		caster:AddNewModifier(caster, ability, "modifier_invulnerable", {})
		caster:SetTeam(attacker:GetTeam())
		caster:SetHealth(caster:GetMaxHealth())

		--Plays victory cheering and animation
		EmitGlobalSound("Hero_LegionCommander.Duel.Victory")
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_DISABLED, rate=1})

		--drops gold bag and walks away after 1 second
		Timers:CreateTimer(1, function()
			local casterLocation = caster:GetAbsOrigin()
			caster:MoveToPosition(casterLocation+math.random(500, 1000))

			local item = CreateItem("item_charm_of_the_mountain_brawler", nil, nil)
		    local pos = caster:GetAbsOrigin()
		    local drop = CreateItemOnPositionSync( pos, item )
		    local pos_launch = pos+RandomVector(RandomFloat(150,200))
		    item:LaunchLoot(false, 200, 0.75, pos_launch)
		end)

		--Plays animation and disappears
        Timers:CreateTimer(5.80, function()
        	EmitSoundOn("hero_bloodseeker.bloodRite", caster)
			ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_POINT, caster)


			Timers:CreateTimer(0.20, function()
  				caster:RemoveSelf()
  			end)
		end)
	end
end
