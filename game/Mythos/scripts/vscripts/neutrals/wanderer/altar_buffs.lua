function LetThereBeLight(keys)
	local target = keys.target
	target.day = target:GetDayTimeVisionRange()
	target.night = target:GetNightTimeVisionRange()

	target:SetDayTimeVisionRange(2700)
	target:SetNightTimeVisionRange(1350)
end

function NormalVision(keys)
	local target = keys.target
	target:SetDayTimeVisionRange(target.day)
	target:SetNightTimeVisionRange(target.night)
end

function RegenerateAllies(keys)
	local target = keys.target
	local targetLocation = target:GetAbsOrigin()
	local nearbyAllies = FindUnitsInRadius(target:GetTeam(), targetLocation, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	local count = table.getn(nearbyAllies)

	for x=1, count do
		nearbyAllies[i]:Heal(5 *target.GetLevel(), target)
		nearbyAllies[i]:GiveMana(target.GetLevel())
	end
end

function HurtEnemies(keys)
	local target = keys.target
	local targetLocation = target:GetAbsOrigin()
	local nearbyUnits = FindUnitsInRadius(target:GetTeam(), targetLocation, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	local count = table.getn(nearbyUnits)

	for x=1, count do
		local damageTable = {
				victim = nearbyUnits[i],
				attacker = target,
				damage = 5 * target.GetLevel() ,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			 
			ApplyDamage(damageTable)
	end
end