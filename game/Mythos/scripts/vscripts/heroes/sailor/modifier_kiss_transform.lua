modifier_kiss_transform = class({})

function modifier_kiss_transform:DeclareFunctions()
    local funcs = {
              MODIFIER_PROPERTY_MODEL_CHANGE
    }

    return funcs
end

function modifier_kiss_transform:GetModifierModelChange ()
    return "models/heroes/tidehunter/tidehunter.vmdl"
end