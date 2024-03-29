modifier_dimensional_lightning_transform = class({})

function modifier_dimensional_lightning_transform:DeclareFunctions()
    local funcs = {
              MODIFIER_PROPERTY_MODEL_CHANGE
    }

    return funcs
end

function modifier_dimensional_lightning_transform:GetModifierModelChange ()
	local models = {"models/courier/drodo/drodo.vmdl"
	, "models/courier/frog/frog.vmdl"
    , "models/courier/mighty_boar/mighty_boar.vmdl"
	, "models/courier/snowleopard/snowleopard_courier.vmdl"
    , "models/items/courier/alphid_of_lecaciida/alphid_of_lecaciida.vmdl"
    , "models/items/courier/blotto_and_stick/blotto.vmdl"}

    return models[math.random(1,6)]
end