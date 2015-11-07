function HurricaneBegin(keys)
	local caster = keys.caster
	local ability = keys.ability

	caster:AddNoDraw()
	Timers:CreateTimer(function()
		if caster:HasModifier("modifier_hurricane_buff") == true then
			caster:EmitSound("Hero_Invoker.Tornado")	    
			return 5   
		end
    end
	)
	local hurricane = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_tornado.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	Timers:CreateTimer(function()
		if caster:HasModifier("modifier_hurricane_buff") == true then
		    ParticleManager:DestroyParticle(hurricane, false)
			hurricane = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_tornado.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		return 0.20    
		else
			ParticleManager:DestroyParticle(hurricane, false)
		end
    end
	)
 	
end

function HurricaneEnd(keys)
	local caster = keys.caster
	caster:RemoveNoDraw()
	caster:StopSound("Hero_Invoker.Tornado")
end