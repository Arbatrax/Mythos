function FractureDummy(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local location = keys.target_points[1]
	
	local unit = CreateUnitByName("fracture_dummy", location, false, caster, caster, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_fracture_dummy", {})
	unit:AddNewModifier(caster, ability, "modifier_kill", {duration=duration})
	unit:AddNoDraw()
	StartSoundEvent("Hero_EarthShaker.EchoSlam", unit)
end