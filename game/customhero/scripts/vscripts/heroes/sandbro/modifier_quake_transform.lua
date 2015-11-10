modifier_quake_transform = class({})

function modifier_quake_transform:DeclareFunctions()
    local funcs = {
              MODIFIER_PROPERTY_MODEL_CHANGE
    }

    return funcs
end

function modifier_quake_transform:GetModifierModelChange ()
    return "models/heroes/nerubian_assassin/mound.vmdl"
end