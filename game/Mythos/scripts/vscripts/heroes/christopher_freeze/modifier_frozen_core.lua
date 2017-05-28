modifier_frozen_core_lua = class({})

frozen_core_lua = class({})
LinkLuaModifier( "modifier_frozen_core_lua", LUA_MODIFIER_MOTION_NONE )

function modifier_frozen_core_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
 
	return funcs
end

function modifier_frozen_core_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return 
end