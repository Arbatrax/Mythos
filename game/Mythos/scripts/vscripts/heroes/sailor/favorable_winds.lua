function FavorableWinds( keys )
    local caster = keys.caster
    local ability = keys.ability
    local casterLocation = caster:GetAbsOrigin()
    local casterDir = caster:GetForwardVector()
    local ability = keys.ability
    local casterPoint = caster:GetAbsOrigin()
    local spawnDistance = ability:GetLevelSpecialValueFor( "behind", ability:GetLevel() - 1 )   
    local spawnRadius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local sideVector = casterDir:Cross(Vector(0, 0, 1))

    local rightSpawn = casterLocation + spawnRadius * sideVector + spawnDistance * -casterDir
    local leftSpawn = casterLocation - spawnRadius * sideVector + spawnDistance * -casterDir

    local projectileSpeed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
    local width = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )

    local info = 
    {
        Ability = ability,
        EffectName = "",
        vSpawnOrigin = casterLocation + spawnDistance * -casterDir,
        fDistance = distance,
        fStartRadius = width,
        fEndRadius = width,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        vVelocity = caster:GetForwardVector() * projectileSpeed,
        bProvidesVision = true,
        iVisionRadius = 650,
        iVisionTeamNumber = caster:GetTeamNumber()
    }

    projectile = ProjectileManager:CreateLinearProjectile(info)

    local info = 
    {
        Ability = ability,
        EffectName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
        vSpawnOrigin = rightSpawn,
        fDistance = distance,
        fStartRadius = width,
        fEndRadius = width,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        vVelocity = caster:GetForwardVector() * projectileSpeed,
        bProvidesVision = false,
        iVisionRadius = 1000,
        iVisionTeamNumber = caster:GetTeamNumber()
    }

    right_projectile = ProjectileManager:CreateLinearProjectile(info)

    info = 
    {
        Ability = ability,
        EffectName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
        vSpawnOrigin = leftSpawn,
        fDistance = distance,
        fStartRadius = width,
        fEndRadius = width,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        vVelocity = caster:GetForwardVector() * projectileSpeed,
        bProvidesVision = false,
        iVisionRadius = 1000,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    
    left_projectile = ProjectileManager:CreateLinearProjectile(info)

end

function OnCollide(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
    local debuff_duration = ability:GetLevelSpecialValueFor( "slow_duration", ability:GetLevel() - 1 )

    if target:GetTeam() == caster:GetTeam() then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_favorable_winds_buff", {duration = duration})
    else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_favorable_winds_debuff", {duration = debuff_duration})
    end
end