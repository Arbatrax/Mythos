function SkillUp(keys)
	local caster = keys.caster
	local this_ability = keys.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = keys.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)

	ability_handle:SetLevel(this_abilityLevel)

	if caster.dominate_mind == nil then
		ability_handle:SetActivated( false )
	end
end

function DominateMind( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_team = caster:GetTeamNumber()
	local player = caster:GetPlayerOwnerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If there is already a dominated unit then kill the old one
	if caster.dominate_mind then
		caster.dominate_mind:ForceKill(true) 
	end
	
	local final_gift = caster:GetAbilityByIndex(3)
	final_gift:SetActivated( true )


	-- Initialize the tracking data
	caster.dominate_mind = target

	-- Change the ownership of the unit and restore its mana to full
	caster.dominate_mind:Stop()
	target:SetTeam(caster_team)
	target:SetOwner(caster)
	target:SetControllableByPlayer(player, true)
	target:GiveMana(target:GetMaxMana())
end

function DominateMindRemove( keys )
	local caster = keys.caster
	local final_gift = caster:GetAbilityByIndex(3)

	final_gift:SetActivated( false )
	caster.dominate_mind = nil
end

function FinalGift( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local unitLocation = caster.dominate_mind:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local nearbyEnemies = FindUnitsInRadius(caster:GetTeam(), unitLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	local count = table.getn(nearbyEnemies)

	EmitSoundOn("Hero_LifeStealer.Consume", caster.dominate_mind)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_clean_mid.vpcf", PATTACH_ABSORIGIN, caster.dominate_mind)

	caster.dominate_mind:ForceKill(true) 

	if count > 0 then
		for i=1, count do
			ability:ApplyDataDrivenModifier(caster, nearbyEnemies[i], "modifier_final_gift_debuff", {duration=duration})
			local damageTable = {
				victim = nearbyEnemies[i],
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			ApplyDamage(damageTable)
		end
	end
end