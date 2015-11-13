-- This is the primary mythos gamemode script and should be used to assist in initializing your game mode

_G.nCOUNTDOWNTIMER = 1201

-- Set this to true if you want to see a complete debug output of all events/processes done by mythos
-- You can also change the cvar 'mythos_spew' at any time to 1 or 0 for output/no output
MYTHOS_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[MYTHOS] creating mythos game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')

require('libraries/animations')

-- These internal libraries set up mythos's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core mythos files.
require('settings')
-- utility_functions has many utility functions
require('utility_functions')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core mythos files.
require('events')

require('CosmeticLib')

trickster_dimensional_lightning_lua = class({})
LinkLuaModifier( "modifier_dimensional_lightning_transform", "heroes/trickster/modifier_dimensional_lightning_transform", LUA_MODIFIER_MOTION_NONE )

sailor_kiss_lua = class({})
LinkLuaModifier( "modifier_kiss_transform", "heroes/sailor/modifier_kiss_transform", LUA_MODIFIER_MOTION_NONE )

sandbro_quake_lua = class({})
LinkLuaModifier( "modifier_quake_transform", "heroes/sandbro/modifier_quake_transform", LUA_MODIFIER_MOTION_NONE )

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[MYTHOS] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[MYTHOS] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[MYTHOS] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]

--This function runs right after a hero is picked.
function GameMode:OnPlayerPickHero(keys)
  local hero = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
  local heroname = hero:GetUnitName()

  if heroname == "npc_dota_hero_lycan" or heroname == "npc_dota_hero_lone_druid" or heroname == "npc_dota_hero_ursa" or heroname == "npc_dota_hero_necrolyte" then
    CosmeticLib:RemoveAll(hero)
  end

  --Moves the model underground and skills up the ability "hide_hero" prevents the hero from movies, being attacked etc. Used for GOD players only.
  if heroname == "npc_dota_hero_treant" then
    local ability = hero:FindAbilityByName("plant_mushroom") 
    ability:UpgradeAbility(true)
  end

  if heroname == "npc_dota_hero_legion_commander" then
    local ability = hero:FindAbilityByName("gladiator_stance") 
    ability:UpgradeAbility(true)
    ability = hero:FindAbilityByName("guardian_stance")
    ability:CastAbility()
  end

  if heroname == "npc_dota_hero_night_stalker" then
    local ability = hero:FindAbilityByName("blood_of_the_innocent") 
    ability:UpgradeAbility(true)
  end

  player.faith = 10
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  if GetMapName() == "mythos" then
    DebugPrint('[MYTHOS] Starting to load Mythos gamemode...')
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 4 )

    print('Mythos gamemode loading.')

    -- Call the internal function to set up the rules/behaviors specified in constants.lua
    -- This also sets up event hooks for all event handlers in events.lua
    -- Check out internals/gamemode to see/modify the exact code
    GameMode:_InitGameMode()
    GameRules.DropTable = LoadKeyValues("scripts/kv/item_drops.kv")
    GameRules.TreasureChest = LoadKeyValues("scripts/kv/treasure_chest.kv")
    GameRules.FactionTable = LoadKeyValues("scripts/kv/factions.kv")
    -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
    Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

    DebugPrint('[MYTHOS] Done loading Mythos gamemode!\n\n')
    print('Mythos gamemode loaded.')
  elseif GetMapName() == 'plateau' then
    print('Mythos: Artifact gamemode loading.')
    GameMode:_InitGameMode()
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 3 )
    print('Mythos: Artifact gamemode loaded.')
  else
    print("Unknown Map")
  end
end

function GameMode:OnHeroInGame(hero)
  print("[MYTHOS] Hero spawned in game for first time -- " .. hero:GetUnitName())
  
  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  local item = CreateItem("item_blink", hero, hero)
  hero:AddItem(item)
  if GetMapName() == "plateau" then
    CustomGameEventManager:Send_ServerToAllClients( "change_ui", {} )
    self.m_TeamColors = {}
  	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
  	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
  	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
  	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
  	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
  	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
  	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
  	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
  	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
  	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple

  	for team = 0, (DOTA_TEAM_COUNT-1) do
  		color = self.m_TeamColors[ team ]
  		if color then
  			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
  		end
  	end
  elseif GetMapName() == "mythos" then 
    CustomGameEventManager:Send_ServerToAllClients( "hide_timer", {} )
    CustomGameEventManager:Send_ServerToAllClients( "hide_board", {} )
    item = CreateItem("item_gate_jumper", hero, hero)
    hero:AddItem(item)
    item = CreateItem("item_purple_orb", hero, hero)
    hero:AddItem(item)
    item = CreateItem("item_green_orb", hero, hero)
    hero:AddItem(item)
  else
    print('Hero in unknown map')
  end

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  
  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end
--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[MYTHOS] The game has officially begun")
  print("Game started.")
  --Notifications:TopToAll("Top Notification for 5 seconds", 5.0)

  if GetMapName() == "mythos" then
    print("Mythos map selected.")

  --Creates timers for spawning creeps every min
    Timers:CreateTimer( function()
         SpawnCreeps()
         return 60
      end)

    Timers:CreateTimer(5, function()
    SpawnNeutralIsland()
    end)

    SpawnGods()

    local point = Entities:FindByName( nil, "bonus_spawn1"):GetAbsOrigin()
    local item = CreateItem("item_imp_portal", nil, nil)
    local drop = CreateItemOnPositionSync( point, item )

    point = Entities:FindByName( nil, "bonus_spawn2"):GetAbsOrigin()
    local unit = CreateUnitByName("mountain_brawler", point, true, nil, nil, DOTA_TEAM_NEUTRALS )   

    point = Entities:FindByName( nil, "gate_spawner"):GetAbsOrigin()
    local unit = CreateUnitByName("gate", point, true, nil, nil, DOTA_TEAM_NEUTRALS )   

    Timers:CreateTimer( function()
      SpawnLaneCreeps()
      return 30
    end)
  elseif GetMapName() == "plateau" then
    self.m_GatheredShuffledTeams = {}
    self.TEAM_KILLS_TO_WIN = 2000
    self.countdownEnabled = true
    print("Countdown should be enabled ", self.countdownEnabled)
    self.isGameTied = true
    self.leadingTeam = -1
    self.runnerupTeam = -1
    self.leadingTeamScore = 0
    self.runnerupTeamScore = 0
    self:GatherAndRegisterValidTeams()
    Timers:CreateTimer( function()
         GameMode:OnThink()
         return 1
      end)
  else
    print("Not loaded into any known map.")
  end
end

function SpawnLaneCreeps()
  local top_spawner = Entities:FindByName( nil, "top_lane_spawner"):GetAbsOrigin()
  local bot_spawner = Entities:FindByName( nil, "bot_lane_spawner"):GetAbsOrigin()
  local bot_left = Entities:FindByName( nil, "bot_left_point"):GetAbsOrigin()
  local bot_right = Entities:FindByName( nil, "bot_right_point"):GetAbsOrigin()
  local top_left = Entities:FindByName( nil, "top_left_point"):GetAbsOrigin()
  local top_right = Entities:FindByName( nil, "top_right_point"):GetAbsOrigin()
  local left_bot_creeps = {}
  local right_bot_creeps = {}
  local left_top_creeps = {}
  local right_top_creeps = {}

  --Sets up 4 checkers at each of the corners of the lanes that send the creeps on to the next check point ----------------------------------
  Timers:CreateTimer(function()
      local nearby_bot_left = FindUnitsInRadius(4, bot_left, nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP , 0, 0, false)
      for i=1,table.getn(nearby_bot_left) do
        if nearby_bot_left[i]:GetTeam() == 2 then
          nearby_bot_left[i]:MoveToPositionAggressive(top_left)
        elseif nearby_bot_left[i]:GetTeam() == 3 then
          nearby_bot_left[i]:MoveToPositionAggressive(bot_spawner)
        end
      end
      return 0.5 
  end) 

  Timers:CreateTimer(function()
      local nearby_bot_right = FindUnitsInRadius(4, bot_right, nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP , 0, 0, false)
      for i=1,table.getn(nearby_bot_right) do
        if nearby_bot_right[i]:GetTeam() == 2 then
          nearby_bot_right[i]:MoveToPositionAggressive(top_right)
        elseif nearby_bot_right[i]:GetTeam() == 3 then
          nearby_bot_right[i]:MoveToPositionAggressive(bot_spawner)
        end
      end
      return 0.5 
  end) 

  Timers:CreateTimer(function()
      local nearby_top_left = FindUnitsInRadius(4, top_left, nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP , 0, 0, false)
      for i=1,table.getn(nearby_top_left) do
        if nearby_top_left[i]:GetTeam() == 2 then
          nearby_top_left[i]:MoveToPositionAggressive(top_spawner)
        elseif nearby_top_left[i]:GetTeam() == 3 then
          nearby_top_left[i]:MoveToPositionAggressive(bot_left)
        end
      end
      return 0.5  
  end) 

  Timers:CreateTimer(function()
      local nearby_top_right = FindUnitsInRadius(4, top_right, nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP , 0, 0, false)
      for i=1,table.getn(nearby_top_right) do
        if nearby_top_right[i]:GetTeam() == 2 then
          nearby_top_right[i]:MoveToPositionAggressive(top_spawner)
        elseif nearby_top_right[i]:GetTeam() == 3 then
          nearby_top_right[i]:MoveToPositionAggressive(bot_right)
        end
      end
      return 0.5 
  end) 

  --Spawns bottoms  creeps for the left and right side ------------------------------------------------------
  for i=1,3 do
    left_bot_creeps[i] = CreateUnitByName("lane_creep_melee_light", bot_spawner, true, nil, nil, DOTA_TEAM_GOODGUYS)
    Timers:CreateTimer(0.25, function()
      left_bot_creeps[i]:MoveToPositionAggressive(bot_left)
    end)  
  end

  light_ranged = CreateUnitByName("lane_creep_ranged_light", bot_spawner, true, nil, nil, DOTA_TEAM_GOODGUYS)
  Timers:CreateTimer(0.35, function()
    light_ranged:MoveToPositionAggressive(bot_left)
  end)  

  for i=1,3 do
    right_bot_creeps[i] = CreateUnitByName("lane_creep_melee_light", bot_spawner, true, nil, nil, DOTA_TEAM_GOODGUYS)
    Timers:CreateTimer(0.25, function()
      right_bot_creeps[i]:MoveToPositionAggressive(bot_right)
    end)  
  end

  light_ranged2 = CreateUnitByName("lane_creep_ranged_light", bot_spawner, true, nil, nil, DOTA_TEAM_GOODGUYS)
  Timers:CreateTimer(0.35, function()
    light_ranged2:MoveToPositionAggressive(bot_right)
  end) 

  --Spawns top creeps for the left and right side -------------------------------------------------------------
  for i=1,3 do
    left_top_creeps[i] = CreateUnitByName("lane_creep_melee_dark", top_spawner, true, nil, nil, DOTA_TEAM_BADGUYS)
    Timers:CreateTimer(0.25, function()
      left_top_creeps[i]:MoveToPositionAggressive(top_left)
    end)  
  end

  dark_ranged = CreateUnitByName("lane_creep_ranged_dark", top_spawner, true, nil, nil, DOTA_TEAM_BADGUYS)
  Timers:CreateTimer(0.35, function()
    dark_ranged:MoveToPositionAggressive(top_left)
  end)  

  for i=1,3 do
    right_top_creeps[i] = CreateUnitByName("lane_creep_melee_dark", top_spawner, true, nil, nil, DOTA_TEAM_BADGUYS)
    Timers:CreateTimer(0.25, function()
      right_top_creeps[i]:MoveToPositionAggressive(top_right)
    end)  
  end

  dark_ranged2 = CreateUnitByName("lane_creep_ranged_dark", top_spawner, true, nil, nil, DOTA_TEAM_BADGUYS)
  Timers:CreateTimer(0.35, function()
    dark_ranged2:MoveToPositionAggressive(top_right)
  end) 
end

function SpawnGods()
  local point
  point = Entities:FindByName( nil, "god_spawn_light"):GetAbsOrigin()
  unit = CreateUnitByName("light", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
  unit:SetForwardVector(Vector(0,-1,0)) 
  AddFOWViewer(2, point, 500, 18000, false)

  point = Entities:FindByName( nil, "god_spawn_dark"):GetAbsOrigin()
  unit = CreateUnitByName("dark", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
  unit:SetForwardVector(Vector(0,-1,0))
  AddFOWViewer(2, point, 500, 18000, false)

  point = Entities:FindByName( nil, "god_spawn_unda"):GetAbsOrigin()
  unit = CreateUnitByName("unda", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
  unit:SetForwardVector(Vector(0,-1,0))
  AddFOWViewer(2, point, 500, 18000, false)

  point = Entities:FindByName( nil, "god_spawn_yerus"):GetAbsOrigin()
  unit = CreateUnitByName("yerus", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
  unit:SetForwardVector(Vector(0,-1,0))
  AddFOWViewer(2, point, 500, 18000, false)
end

function SpawnCreeps()
  --Spawns Bot side neutral camps
  if ClearCamp("bot_neutral_camp1") == true then
    SpawnCamp("bot_neutral_camp1", "neutral_dinosaur_baby", 2)
    SpawnCamp("bot_neutral_camp1", "neutral_dinosaur", 1)
  end
  if ClearCamp("bot_neutral_camp2") == true then
    SpawnCamp("bot_neutral_camp2", "neutral_ghost_1", 2)
    SpawnCamp("bot_neutral_camp2", "neutral_ghost_2", 2)
  end
  if ClearCamp("bot_neutral_camp3") == true then
    SpawnCamp("bot_neutral_camp3", "neutral_bug_small", 3)
    SpawnCamp("bot_neutral_camp3", "neutral_bug_large", 1)
  end  
  if ClearCamp("bot_neutral_camp4") == true then
    SpawnCamp("bot_neutral_camp4", "neutral_golem_small", 6)
  end
  if ClearCamp("bot_neutral_camp5") == true then
    SpawnCamp("bot_neutral_camp5", "neutral_kobold_basic", 3)
  end
  if ClearCamp("bot_neutral_vision") == true then
    SpawnCamp("bot_neutral_vision", "neutral_harpy_vision", 1)
  end
  --Spawns Top side neutral camps
  if ClearCamp("top_neutral_camp1") == true then
    SpawnCamp("top_neutral_camp1", "neutral_forest_lord", 1)
  end
  if ClearCamp("top_neutral_camp2") == true then
    SpawnCamp("top_neutral_camp2", "neutral_ghost_1", 2)
    SpawnCamp("top_neutral_camp2", "neutral_ghost_2", 2)
  end
  if ClearCamp("top_neutral_camp3") == true then
    SpawnCamp("top_neutral_camp3", "neutral_dog", 5)
    SpawnCamp("top_neutral_camp3", "neutral_dog_master", 1)
  end  
  if ClearCamp("top_neutral_camp4") == true then
    SpawnCamp("top_neutral_camp4", "neutral_kobold_basic", 3)
  end
  if ClearCamp("top_neutral_camp5") == true then
    SpawnCamp("top_neutral_camp5", "neutral_kobold_basic", 3)
  end
  if ClearCamp("top_neutral_vision") == true then
    SpawnCamp("top_neutral_vision", "neutral_harpy_vision", 1)
  end
end

function SpawnNeutralIsland()
  --Spawns neutral island creeps
  for i=1, 2, 1 do
    local point = Entities:FindByName( nil, "neutral_tower_spawn" ..i):GetAbsOrigin()
    local unit = CreateUnitByName("neutral_tower", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
    unit:AddNewModifier(caster, nil, "modifier_tower_truesight_aura", {})
    unit:AddNewModifier(caster, nil, "modifier_magic_immune", {})
  end
  if ClearCamp("neutral_campboss") == true then
    SpawnCamp("neutral_campboss", "neutral_island_boss", 1)
  end
  if ClearCamp("neutral_camp1") == true then
    SpawnCamp("neutral_camp1", "neutral_kobold_basic", 3)
  end
  if ClearCamp("neutral_camp2") == true then
    SpawnCamp("neutral_camp2", "neutral_dog", 5)
    SpawnCamp("neutral_camp2", "neutral_dog_master", 1)
  end
end

function Leash(point, neutral)
  Timers:CreateTimer(function()
    if neutral:IsNull() == false and neutral:GetTeam() == 4 then
      local vect = neutral:GetAbsOrigin() - point
      local distance_from_leash = vect:Length2D()

      if (neutral.walkbackMode == true and distance_from_leash < 100) then
        neutral.walkbackMode = false
        neutral:MoveToPositionAggressive(point)
      end
      if (neutral.walkbackMode == false and distance_from_leash > 750) then
        neutral.walkbackMode = true
        neutral:MoveToPosition(point)
      end
    end
    return 1 
  end)
end

function SpawnCamp(camp, neutral, num)
  local point = Entities:FindByName( nil, camp):GetAbsOrigin()
  for i=1, num do
    unit = CreateUnitByName(neutral, point, true, nil, nil, DOTA_TEAM_NEUTRALS)
    unit.walkbackMode = false
    Leash(point, unit)
  end
end

function ClearCamp(camp)
  local point = Entities:FindByName( nil, camp):GetAbsOrigin()
  local nearbyUnits = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, point, nil, 500, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 0, 0, false)
  if table.getn(nearbyUnits) == 0 then
    return true
  end
end
-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end
--C+P from overthrow

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function GameMode:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end
-- Checks teamcolor default white
function GameMode:ColorForTeam( teamID )
  local color = self.m_TeamColors[ teamID ]
  if color == nil then
    color = { 255, 255, 255 } -- default to white
  end
  return color
end
--UpdatesScoreboard
function GameMode:UpdateScoreboard()
  local sortedTeams = {}
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
  end

  -- reverse-sort by score
  table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

  for _, t in pairs( sortedTeams ) do
    local clr = self:ColorForTeam( t.teamID )

    -- Scaleform UI Scoreboard
    local score = 
    {
      team_id = t.teamID,
      team_score = t.teamScore
    }
    FireGameEvent( "score_board", score )
  end
  -- Leader effects (moved from OnTeamKillCredit)
  local leader = sortedTeams[1].teamID
  -- print("Leader = " .. leader)
  self.leadingTeam = leader
  self.runnerupTeam = sortedTeams[2].teamID
  self.leadingTeamScore = sortedTeams[1].teamScore
  self.runnerupTeamScore = sortedTeams[2].teamScore
  if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
    self.isGameTied = true
  else
    self.isGameTied = false
  end
  local allHeroes = HeroList:GetAllHeroes()
  for _,entity in pairs( allHeroes) do
    if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
      if entity:IsAlive() == true then
        -- Attaching a particle to the leading team heroes
        local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
            if existingParticle == -1 then
              local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
          ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
          entity:Attribute_SetIntValue( "particleID", particleLeader )
        end
      else
        local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
        if particleLeader ~= -1 then
          ParticleManager:DestroyParticle( particleLeader, true )
          entity:DeleteAttribute( "particleID" )
        end
      end
    else
      local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
      if particleLeader ~= -1 then
        ParticleManager:DestroyParticle( particleLeader, true )
        entity:DeleteAttribute( "particleID" )
      end
    end
  end
end

function GameMode:OnThink()
 --  print("1")
  self:UpdateScoreboard()
  -- Stop thinking if game is paused
  if GameRules:IsGamePaused() == true then
        return 1
  end
  -- print(2)
  -- print(self.countdownEnabled)
  if self.countdownEnabled == true then
    CountdownTimer()
    if nCOUNTDOWNTIMER == 30 then
      CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
    end
    if nCOUNTDOWNTIMER <= 0 then
      --Check to see if there's a tie
      if self.isGameTied == false then
        GameRules:SetGameWinner( self.leadingTeam )
        self.countdownEnabled = false
      else
        self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
        local broadcast_killcount = 
        {
          killcount = self.TEAM_KILLS_TO_WIN
        }
        CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
      end
    end
  end
  -- print('3')
end