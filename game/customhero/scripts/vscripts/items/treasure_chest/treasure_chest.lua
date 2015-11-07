function Loot(keys)
    local caster = keys.caster
    local ability = keys.ability
    local pos = caster:GetAbsOrigin()
    local count = ability:GetLevelSpecialValueFor("demons", 0)
    local duration = ability:GetLevelSpecialValueFor("duration", 0)
    local caster_location = caster:GetAbsOrigin()

    local demon_table = {}

    local i = 0
    Timers:CreateTimer(function()
        local unit = CreateUnitByName("loot_demon", caster_location, true, nil, nil, DOTA_TEAM_NEUTRALS )
        table.insert(demon_table, unit)

        --unit:AddNewModifier(unit, nil, "modifier_kill", {duration = 20})
        unit:AddNewModifier(unit, nil, "modifier_magic_immune", {})

        ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_basher_cast.vpcf", PATTACH_ABSORIGIN, unit)
        EmitSoundOn("Hero_Antimage.Blink_in", unit)


        i = i+1
        if i < count then
            return duration/count
        end
    end)

    local k = 1
    Timers:CreateTimer(0.3, function()
        demon_table[k]:MoveToPosition(Vector(math.random(-10000,10000), math.random(-10000,10000)))
        k = k+1
        if i < count then
            return duration/count
        end
    end)

    Timers:CreateTimer(9.85, function()
        for j=1,count do
            if demon_table[i]:IsAlive() then
                ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_basher_cast.vpcf", PATTACH_POINT, demon_table[j])
                EmitSoundOn("Hero_Antimage.Blink_in", unit)
                Timers:CreateTimer(0.15, function()
                    demon_table[j]:RemoveSelf()    
                end)
            end
        end
    end)
end

