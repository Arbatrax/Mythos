function Wander( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	
	Timers:CreateTimer(function()
		if IsValidEntity(caster) then
			local casterLocation = caster:GetAbsOrigin()
			local nearbyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, 0, 1, false)
			local count = table.getn(nearbyHeroes)

			if count > 0 then
				local hero = nearbyHeroes[1]
				print(hero:GetUnitName())
				caster:RemoveModifierByName("modifier_wandering")
				caster:SetTeam(hero:GetTeam())
				caster:MoveToNPC(hero)
				EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), "Hero_Puck.Phase_Shift", caster)
				--caster:AddSpeechBubble(1, "Help I'm lost!", 5.0, 0, 0)
				Shrine(keys)
			else
	      		return 0.03			
			end
		end
    end)
end

function Shrine(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)

	Timers:CreateTimer(function()
	local casterLocation = caster:GetAbsOrigin()
	local nearbyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 1, false)
	local count = table.getn(nearbyHeroes)

		if count > 0 and nearbyHeroes[1]:HasModifier("modifier_heavenly_presence") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_wandering", {})
			local god = nearbyHeroes[1]
			caster:MoveToNPC(god)
			caster:Stop()
			ParticleManager:CreateParticle("particles/econ/courier/courier_faceless_rex/cour_rex_flying.vpcf", PATTACH_POINT, caster)
			Timers:CreateTimer(1.80, function()
				EmitGlobalSound("Hero_Terrorblade.Sunder.Target")
				ParticleManager:CreateParticle("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf", PATTACH_POINT, caster)
				Timers:CreateTimer(0.20, function()
      				caster:RemoveSelf()
      				DropItem(casterLocation)
					Empower(keys, god)
      			end)
		    end)
			--caster:AddSpeechBubble(1, "Help I'm lost!", 5.0, 0, 0)
		else
      		return 0.03			
		end
    end)
end

function DropItem(casterLocation)
	local item = CreateItem("item_mana_eater", nil, nil)
    local drop = CreateItemOnPositionSync( casterLocation, item )
    local pos_launch = casterLocation+RandomVector(RandomFloat(150,200))

    item:LaunchLoot(false, 200, 0.75, pos_launch)
end

function Empower(keys, god)
	local caster = keys.caster
	local ability = keys.ability
	local heroes = HeroList:GetAllHeroes()
	local count = HeroList:GetHeroCount()

	local FactionInfo

	if god:GetUnitName() == "light" then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", PATTACH_ABSORIGIN, god)
		local buff = god:GetAbilityByIndex(0)

		Timers:CreateTimer(2, function()
			god:RemoveModifierByName("modifier_medusa_stone_gaze_stone")

			EmitGlobalSound("Hero_Omniknight.GuardianAngel.Cast")
			EmitGlobalSound("Hero_Omniknight.GuardianAngel")	

			for i=1,count do

				FactionInfo = GameRules.FactionTable[heroes[i]:GetUnitName()]

				if FactionInfo and FactionInfo == "Light" then
				  buff:ApplyDataDrivenModifier(god, heroes[i], "modifier_gift_of_light", {duration=10})
				end
			end
		end)
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(particle, true)
			god:AddNewModifier(god, nil, "modifier_medusa_stone_gaze_stone", {})
		end)	
	elseif god:GetUnitName() == "yerus" then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", PATTACH_ABSORIGIN, god)
		local buff = god:GetAbilityByIndex(0)

		Timers:CreateTimer(2, function()
			god:RemoveModifierByName("modifier_medusa_stone_gaze_stone")

    		StartAnimation(god, {duration=2.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})

			EmitGlobalSound("Hero_LoneDruid.BattleCry")
			EmitGlobalSound("Hero_LoneDruid.BattleCry.Bear")	

			for i=1,count do

				FactionInfo = GameRules.FactionTable[heroes[i]:GetUnitName()]

				if FactionInfo and FactionInfo == "Yerus" then
				  buff:ApplyDataDrivenModifier(god, heroes[i], "modifier_gift_of_yerus", {duration=10})
				end
			end
		end)

		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(particle, true)
			god:AddNewModifier(god, nil, "modifier_medusa_stone_gaze_stone", {})
		end)
	elseif god:GetUnitName() == "unda" then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet.vpcf", PATTACH_OVERHEAD_FOLLOW, god)
		local buff = god:GetAbilityByIndex(0)

		Timers:CreateTimer(2, function()
			god:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
			--ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", PATTACH_OVERHEAD_FOLLOW, god)
			ParticleManager:DestroyParticle(particle, true)

    		StartAnimation(god, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.55})

    		EmitGlobalSound("Ability.Torrent")
			EmitGlobalSound("Hero_NagaSiren.SongOfTheSiren")

			for i=1,count do

				FactionInfo = GameRules.FactionTable[heroes[i]:GetUnitName()]
				print(FactionInfo)
				if FactionInfo and FactionInfo == "Unda" then
				  buff:ApplyDataDrivenModifier(god, heroes[i], "modifier_gift_of_unda", {duration=10})
				end
			end
		end)

		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(particle, true)
			god:AddNewModifier(god, nil, "modifier_medusa_stone_gaze_stone", {})
		end)
	elseif god:GetUnitName() == "dark" then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform_c.vpcf", PATTACH_ABSORIGIN, god)
		local buff = god:GetAbilityByIndex(0)

		Timers:CreateTimer(2, function()
			god:RemoveModifierByName("modifier_medusa_stone_gaze_stone")

    		StartAnimation(god, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})

			EmitGlobalSound("Hero_Lich.ChainFrost")

			for i=1,count do

				FactionInfo = GameRules.FactionTable[heroes[i]:GetUnitName()]

				if FactionInfo and FactionInfo == "Dark" then
				  buff:ApplyDataDrivenModifier(unit, heroes[i], "modifier_gift_of_dark", {duration=10})
				end
			end
		end)

		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(particle, true)
			god:AddNewModifier(god, nil, "modifier_medusa_stone_gaze_stone", {})
		end)
	end
end