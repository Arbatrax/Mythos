function Mercenaries(keys)
  local caster = keys.caster
  local ability = keys.ability
  local melee = ability:GetLevelSpecialValueFor("melee", 0)
  local ranged = ability:GetLevelSpecialValueFor("ranged", 0)
  local cost = ability:GetLevelSpecialValueFor("cost", 0)
  local neutral_island = Entities:FindByName( nil, "neutral_island_point"):GetAbsOrigin()
  local spawner = Entities:FindByName( nil, "mercenary_spawner"):GetAbsOrigin()
  local mercenaries = {}


  --Spawns mercenaries to assault the neutral island ------------------------------------------------------
  for i=1,melee do
    mercenaries[i] = CreateUnitByName("lane_creep_melee_mercenary", spawner, true, nil, nil, caster:GetTeam())
    Timers:CreateTimer(0.25, function()
      mercenaries[i]:MoveToPositionAggressive(neutral_island)
    end)  
  end

  for i=melee+1,melee+ranged do
    mercenaries[i] = CreateUnitByName("lane_creep_ranged_mercenary", spawner, true, nil, nil, caster:GetTeam())
    Timers:CreateTimer(0.25, function()
      mercenaries[i]:MoveToPositionAggressive(neutral_island)
    end)  
  end  

  caster:ModifyGold(cost, false, 0)
  EmitSoundOn("General.Buy", caster)
  Timers:CreateTimer(1, function()
    EmitSoundOn("Hero_LegionCommander.PressTheAttack", caster)    
  end)
end