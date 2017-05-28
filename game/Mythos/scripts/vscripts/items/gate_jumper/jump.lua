function Jumping( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]

	local gate = FindUnitsInRadius(4, point, nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 1, false)

	for i=1, table.getn(gate) do
		if gate[i]:GetUnitName() == "gate" then
			caster.gate = gate[i]
			break
		end
	end
end

function Jump (keys)
	local caster = keys.caster

	FindClearSpaceForUnit(caster, caster.gate:GetAbsOrigin(), true)
end