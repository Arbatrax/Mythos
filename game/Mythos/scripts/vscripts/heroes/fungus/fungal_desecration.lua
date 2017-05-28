function SkillUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	ability:ApplyDataDrivenModifier(caster, caster.mushroom, "modifier_fungal_desecration", {})

	function MushroomPlant( keys )
		local caster = keys.caster
		local level = ability:GetLevel()

		if level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster.mushroom, "modifier_fungal_desecration", {})
		end
	end
end