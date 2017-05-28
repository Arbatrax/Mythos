function EludeAnimation( keys )
	local caster = keys.caster

	AddAnimationTranslate(caster, "shadow_dance")
end

function EndEludeAnimation( keys )
	local caster = keys.caster

	RemoveAnimationTranslate(caster)
end