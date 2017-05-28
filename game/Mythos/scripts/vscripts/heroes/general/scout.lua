--[[ ============================================================================================================
	Author: Rook
	Date: June 6, 2015
	Called when Venomancer's Plague Ward is cast.  Spawns a Plague Ward of the appropriate level at the target location.
	Additional parameters: keys.Duration
================================================================================================================= ]]
function venomancer_plague_ward_datadriven_on_spell_start(keys)
	--The Plague Ward should initialize facing away from Venomancer, so find that direction.
	local caster_origin = keys.caster:GetAbsOrigin()
	local direction = (keys.target_points[1] - caster_origin):Normalized()
	direction.z = 0
	
	keys.caster:EmitSound("Hero_Venomancer.Plague_Ward")
	
	local scout_level = keys.ability:GetLevel()
	if scout_level >= 1 and scout_level <= 4 then
		local scout_unit = CreateUnitByName("call_of_the_wild_" .. scout_level .. "_datadriven", keys.target_points[1], false, keys.caster, nil, keys.caster:GetTeam())
		scout_unit:SetForwardVector(direction)
		scout_unit:SetControllableByPlayer(keys.caster:GetPlayerID(), true)
		
		--Display particle effects for Venomancer as well as the plague ward.
		--local venomancer_plague_ward_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_ABSORIGIN, keys.caster)
		--local plague_ward_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_spawn.vpcf", PATTACH_ABSORIGIN, scout_unit)
		
		--Add the green duration circle, and kill the plague ward after the duration ends.
		scout_unit:AddNewModifier(scout_unit, nil, "modifier_kill", {duration = keys.Duration})
		
		--Store the unit that spawned this plague ward (i.e. Venomancer).
		scout_unit.venomancer_plague_ward_parent = keys.caster
	end
end
