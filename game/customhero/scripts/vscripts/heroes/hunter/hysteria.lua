function HysteriaAnimation(event)
	local caster = event.caster
	local ability = event.ability
	local modifier = "modifier_blood_of_the_innocent_stack"


	local current_stack = caster:GetModifierStackCount( modifier, ability )
	if current_stack > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_hysteria_buff", {})
		AddAnimationTranslate(caster, "haste")
		ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_void_hit.vpcf", PATTACH_POINT, caster)
		EmitSoundOn("Hero_Nightstalker.Darkness", caster)
	else
		ability:ToggleAbility()
	end
end

function HysteriaAnimationEnd(event)
	local caster = event.caster

	caster:RemoveModifierByName("modifier_hysteria_buff")
	RemoveAnimationTranslate(caster)
end

function Vision (event)
	local caster = event.caster
	local ability = event.ability

	caster:SetDayTimeVisionRange(0)
	caster:SetNightTimeVisionRange(0)
end

function VisionEnd (event)
	local caster = event.caster
	local ability = event.ability

	caster:SetDayTimeVisionRange(1800)
	caster:SetNightTimeVisionRange(900)
end