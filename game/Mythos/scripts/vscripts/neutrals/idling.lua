function Idling( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	local name = caster:GetUnitName()
	
	Timers:CreateTimer(function()
		if IsValidEntity(caster) then
			local casterLocation = caster:GetAbsOrigin()
			local nearbyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, 0, 1, false)
			local count = table.getn(nearbyHeroes)

			if count > 0 then
				local hero = nearbyHeroes[1]
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk_flat.vpcf", PATTACH_ABSORIGIN, caster)

				Timers:CreateTimer(1, function()
					caster:RemoveSelf()
					DropItem(casterLocation, name)
				end)
			else
	      		return 0.03			
			end
		end
    end)
end

function DropItem(casterLocation, name)
	local item
	if name == "mercenary" then
		item = CreateItem("item_mercenary_flag", nil, nil)
	elseif name == "imp_master" then
		item = CreateItem("item_imp_portal", nil, nil)
	end

	print(name)

    local drop = CreateItemOnPositionSync( casterLocation, item )
    local pos_launch = casterLocation+RandomVector(RandomFloat(150,200))

    --item:LaunchLoot(false, 200, 0.75, pos_launch)
end