
function PhoenixSpawn( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)
	local arcane = caster:GetAbilityByIndex(1)

	-- Set the unit name, concatenated with the level number
	local unit_name = event.unit_name
	
	unit_name = unit_name..level

	-- Check if the phoenix is alive, heals and spawns them near the caster if it is
	if caster.phoenix and IsValidEntity(caster.phoenix) and caster.phoenix:IsAlive() then
		FindClearSpaceForUnit(caster.phoenix, origin, true)
		
		caster.phoenix:SetHealth(caster:GetMaxHealth())

	else
		-- Create the unit and make it controllable
		local caster_total = caster:GetMaxHealth()
		caster.phoenix = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.phoenix:SetControllableByPlayer(player, true)
		caster.phoenix:SetMaxHealth(caster_total)
		caster.phoenix:SetHealth(caster_total)
		LearnPhoenixAbilities( caster.phoenix, level )
		ability:ApplyDataDrivenModifier(caster, caster.phoenix, "modifier_health_link", {})
		if arcane:GetLevel() > 0 then
			arcane:ApplyDataDrivenModifier(caster, caster.phoenix, "modifier_arcane_accelerant_caster", {})
		end

	end

  	Timers:CreateTimer(function()
		local caster_total = caster:GetMaxHealth()
		local phoenix_total = caster.phoenix:GetMaxHealth()
		if caster_total ~= phoenix_total then
			if caster_total > phoenix_total then
				caster.phoenix:SetMaxHealth(caster_total)
			elseif caster_total < phoenix_total then
				caster.phoenix:SetMaxHealth(caster_total)
			end
		end
      	return 3
    end
  	)	
end

function Health(keys)
	local caster = keys.caster
	local ember_health = caster:GetHealth()
	local phoenix_health = caster.phoenix:GetHealth()
	local total_health = ember_health + phoenix_health

	function HealthChange(event)
		local ember_health_current = caster:GetHealth()
		local phoenix_health_current = caster.phoenix:GetHealth()
		local total_health_current = ember_health_current + phoenix_health_current
		local damage = event.damage
		local attacker = event.attacker
		if damage and damage >= total_health then
			caster:RemoveModifierByName("modifier_health_link")
			caster.phoenix:RemoveModifierByName("modifier_health_link")
			local damageTable = {
						victim = caster,
						attacker = attacker,
						damage = damage,
						damage_type = DAMAGE_TYPE_PURE,
					}
			ApplyDamage( damageTable )
			damageTable = {
						victim = caster.phoenix,
						attacker = attacker,
						damage = damage,
						damage_type = DAMAGE_TYPE_PURE,
					}
			ApplyDamage( damageTable )
		
		elseif total_health ~= total_health_current then
			local health_split = total_health_current/2
			caster:SetHealth(health_split)
			caster.phoenix:SetHealth(health_split)
			ember_health = ember_health_current
			phoenix_health = phoenix_health_current
			total_health = ember_health + phoenix_health
		end
	end
end

function PhoenixLevel( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local unit_name = "phoenix"..level
	local arcane = caster:GetAbilityByIndex(1)



	if caster.phoenix and caster.phoenix:IsAlive() then 
		-- Remove the old phoenix in its position
		local origin = caster.phoenix:GetAbsOrigin()
		caster.phoenix:RemoveSelf()

		-- Create the unit and make it controllable
		caster.phoenix = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.phoenix:SetControllableByPlayer(player, true)
		if arcane:GetLevel() > 0 then
			arcane:ApplyDataDrivenModifier(caster, caster.phoenix, "modifier_arcane_accelerant_caster", {})
		end

		-- Learn its abilities: return lvl 2, entangle lvl 3, demolish lvl 4. By Index
		LearnPhoenixAbilities( caster.phoenix, level )
	end
end

function Death(ability, caster)
	caster.phoenix:Kill(nil ,caster.phoenix)
	caster:ForceKill(false)

end

-- Auxiliar Function to loop over all the abilities of the unit and set them to a level
function LearnPhoenixAbilities( unit, level )

	-- Learn its abilities, for ember_king_phoenix its return lvl 2, entangle lvl 3, demolish lvl 4. By Index
	for i=0,15 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(level)
			print("Set Level "..level.." on "..ability:GetAbilityName())
		end
	end

end
