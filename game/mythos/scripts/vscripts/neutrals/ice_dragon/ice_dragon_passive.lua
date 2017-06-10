function OnSpawn(keys)
	local unit = keys.caster
	unit.phase = 1

	print("ice dragon passive applied")
	print("phase "..unit.phase)

	AddAnimationTranslate(unit, "injured")
end

function PhaseChange(keys)
	local unit = keys.caster
	local ability = keys.ability
	local health_percent = unit:GetHealth()/unit:GetMaxHealth()

	if health_percent <= 0.90 and unit.phase == 1 then
		unit.phase = 2
		print("phase "..unit.phase)

		unit:Stop()
		EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Target", unit)
		RemoveAnimationTranslate(unit)
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_ice_dragon_phase_two", {})
		unit:SetAttackCapability(2)
	end
end