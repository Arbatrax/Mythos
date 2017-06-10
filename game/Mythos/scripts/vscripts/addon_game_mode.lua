-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')
require( 'CosmeticLib' )

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  --DebugPrint("[MYTHOS] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle", "particles/neutral_fx/ghost_base_attack.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_furion/furion_base_attack.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_lycan/lycan_claw_blur_b.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_undying/undying_tnt_wlk_golem.vpcf", context)
 
  PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/props_debris/merchant_debris_book001.vmdl", context)
  PrecacheModel("models/props_items/eaglehorn01.vmdl" , context)
  PrecacheModel("models/props_items/ring_perseverance.vmdl"  , context)
  PrecacheModel("models/heroes/tidehunter/tidehunter.vmdl", context)

  -- Sounds for items
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("example_ability", context)
  PrecacheItemByNameSync("item_mana_eater", context)
  PrecacheItemByNameSync("item_mercenary_flag", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way

  PrecacheUnitByNameSync("npc_dota_hero_warlock", context)
  PrecacheUnitByNameSync("npc_dota_hero_winter_wyvern", context)
  PrecacheUnitByNameSync("npc_dota_hero_lich", context)
  PrecacheUnitByNameSync("npc_dota_hero_shadow_demon", context)
  
  --All model precaches needed for neutral camps
  PrecacheUnitByNameSync("yerus", context)
  PrecacheUnitByNameSync("unda", context)
  PrecacheUnitByNameSync("light", context)
  PrecacheUnitByNameSync("dark", context)

  PrecacheUnitByNameSync("fountain", context)
  PrecacheUnitByNameSync("lane_creep_melee_mercenary", context)
  PrecacheUnitByNameSync("lane_creep_ranged_mercenary", context)
  PrecacheUnitByNameSync("lane_creep_melee_light", context)
  PrecacheUnitByNameSync("lane_creep_ranged_light", context)
  PrecacheUnitByNameSync("lane_creep_melee_dark", context)
  PrecacheUnitByNameSync("lane_creep_ranged_dark", context)
  PrecacheUnitByNameSync("gate", context)
  PrecacheUnitByNameSync("vampire", context)
  PrecacheUnitByNameSync("mountain_brawler", context)
  PrecacheUnitByNameSync("wanderer", context)
  PrecacheUnitByNameSync("loot_demon", context)
  PrecacheUnitByNameSync("neutral_tower", context)
  PrecacheUnitByNameSync("neutral_dog", context)
  PrecacheUnitByNameSync("neutral_kobold", context)
  PrecacheUnitByNameSync("neutral_dog_master", context)
  PrecacheUnitByNameSync("neutral_forest_lord", context)
  PrecacheUnitByNameSync("neutral_treant_summon", context)
  PrecacheUnitByNameSync("neutral_dinosaur_baby", context)
  PrecacheUnitByNameSync("neutral_dinosaur", context)
  PrecacheUnitByNameSync("neutral_ghost_1", context)
  PrecacheUnitByNameSync("neutral_ghost_2", context)
  PrecacheUnitByNameSync("neutral_bug_large", context)
  PrecacheUnitByNameSync("neutral_bug_small", context)
  PrecacheUnitByNameSync("neutral_golem_small", context)

  


  -- Precaching resources to disable cosmetics
  PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()

end