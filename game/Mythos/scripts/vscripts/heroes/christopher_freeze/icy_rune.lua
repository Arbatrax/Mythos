function IcyRune( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", 1)
	local caster_location = caster:GetAbsOrigin()
	local mana = ability:GetLevelSpecialValueFor("mana", (ability:GetLevel() - 1))
	local mana_aoe = ability:GetLevelSpecialValueFor("mana_aoe", (ability:GetLevel() - 1))

	caster:GiveMana(mana)

	local allyHeroes = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
	local count = table.getn(allyHeroes)
	if count > 0 then
		for i=1, count do
			allyHeroes[i]:GiveMana(mana_aoe)
		end
	end

end

function IcyRuneSoundStop( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end