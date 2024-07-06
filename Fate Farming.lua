  --[[

  ****************************************
  *            Fate Farming              * 
  ****************************************

  Created by: Prawellp

  ***********
  * Version *
  *  0.1.0  *
  ***********

    -> 0.1.0:  made it stop going to Fates that are done (i think)
               switches Instance in the new DT areas
    -> 0.0.9: added now an shop exchange function that will teleport to the shop and exchange ur gems for Bicolor Vouchers
              you will need to have every fate in Endwalker completet for it to work
              added new settings to the feature and new Plugin Requirments
              made it that it will dismount when arriving in the fate and hopefully when u target an fate enemy path to it to prevent getting stuck in some buildings
    -> 0.0.8: added auto repair function
              added new settings
              fixed the bug with the chat spamming
              made it now when the chocobo or fate settings are false that it will disable them in Pandora
              sadly still didn't fix the bug that it paths into buildings and makes u stuck
    -> 0.0.7: made the code look Prettier
              and fixed some stuff like you will go a bit higher then the fate and then dismount all the way hopefully preventing trying to fly into buildings
              added functions to call them to make the loop code look smaller
              hopefully fixed the problem that it spams in chat
              should mount when there is no fate and u get in combat
    -> 0.0.6: you will now dismount upon entering the fate (hopefully) instead pathing to the center
              if you got to the spot where u "should" dismount but don't dismount, triggers a counter that will start and change the path to another location to prevent being stuck cause of some stones
              Removed auto rs settings now need toset the engage setting in rs to Previously engaged targets (look at Required Plugins)
              when no fate exists it won't go to 0.0.0 anymore and just stand still till a new fate spawn 

  Known Issues: still paths to the fate when its done while pathing
                it can happen if u switch zones after using it it won't work and u would need to relog

  *********************
  *  Required Plugins *
  *********************


  Plugins that are used are:
  -> VNavmesh (for pathing) AND Visland: https://puni.sh/api/repository/veyn
  -> Pandora : https://love.puni.sh/ment.json
  -> RotationSolver Reborn : https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
     -> Target -> activate "Select only Fate targets in Fate" and "Target Fate priority"
     -> Target -> "Engage settings" set to "Previously engaged targets (enagegd on countdown timer)"
  -> Something Need Doing [Expanded Edition] : https://puni.sh/api/repository/croizat
  -> Teleporter
]]

--[[

  **************
  *  Settings  *
  **************
  ]]

  teleport = "Yedlihmad" --Enter the name of the Teleporter where u farm Fates so it teleport back to the area and keeps farming
  Exchange = false --true (yes)| false (no) if it should exchange ur gems to Bicolor Gemstone Voucher
  
  ManualRepair = true --true (yes)| false (no) --will repair your gear after every fate if the threshold is reached.
  RepairAmount = 99   -- the amount of Condition you gear will need before getting Repaired
  
  
  FateS = true --true (yes)| false (no)
  --Activates the Fate settings in Pandora "Auto-Sync FATEs" and "FATE Targeting Mode".
  
  ChocoboS = true --true (yes)| false (no)
  --Activates the Chocobo settings in Pandora "Auto-Summon Chocobo" and "Use whilst in combat".
  
  
  Announce = 2
  --Change this value for how much echos u want in chat 
  --2 is the fate your Moving to and Bicolor gems amount
  --1 is only Bicolor gems
  --0 is nothing
  --echos will appear after it found a new fate 
  
  --[[
  
  ************
  *  Script  *
  *   Start  *
  ************
  
  ]]
  
  ----------------------------------Settings----------------------------------------------
  if ChocoboS == true then
  PandoraSetFeatureState("Auto-Summon Chocobo", true) 
  PandoraSetFeatureConfigState("Auto-Summon Chocobo", "Use whilst in combat", true)
  elseif ChocoboS == false then
  yield("/e Sad Chocobo noises...")
  PandoraSetFeatureState("Auto-Summon Chocobo", false) 
  PandoraSetFeatureConfigState("Auto-Summon Chocobo", "Use whilst in combat", false)
  end
  
  if FateS == true then
  PandoraSetFeatureState("Auto-Sync FATEs", true) 
  PandoraSetFeatureState("FATE Targeting Mode", true) 
  yield("/wait 1")
  elseif FateS == false then
  yield("/e I hope u have something that syncs and targets them")
  end
  -------------------------------------------------------------------------------------
  
  ------------------------------functions----------------------------------------------
  function FateLocation()
    fates = GetActiveFates()
    minDistance = 50000
    fateId = 0
    for i = 0, fates.Count-1 do
      if GetFateDuration(fates[i]) > 0 then
        distance = GetDistanceToPoint(GetFateLocationX(fates[i]), GetFateLocationY(fates[i]), GetFateLocationZ(fates[i]))
        if distance < minDistance then
          minDistance = distance
          fateId = fates[i]
          Fate2 = fateId
        end
      end
    end
  
    fateX = GetFateLocationX(fateId)
    fateY = GetFateLocationY(fateId)+5
    fateZ = GetFateLocationZ(fateId)
    LogInfo(fateX.." , "..fateY.." , "..fateZ)
end

function FatePath()
  if fateX == 0 and fateY == 5 and fateZ == 0 then
    noFate = true
    yield("/vnavmesh stop")
    PathStop()
    yield("/wait 2")
end

  if fateX ~= 0 and fateY ~= 5 and fateZ ~= 0 then
  noFate = false
  PathfindAndMoveTo(fateX, fateY, fateZ, true)
  if Announce == 2 then
  yield("/echo Moving to Fate: "..fateId)  
  end


  if gcount == 0  and fateId ~= 0 and Announce == 1 or Announce == 2 then
    yield("/e Gems: "..gems)
    yield("/wait 0.5")
    gcount = gcount +1
  end
  end
end

  
  function enemyPathing()
  while GetDistanceToTarget() > 3.5 do
    local enemy_x = GetTargetRawXPos()
    local enemy_y = GetTargetRawYPos()
    local enemy_z = GetTargetRawZPos()
    if PathIsRunning() == false then 
    PathfindAndMoveTo(enemy_x, enemy_y, enemy_z)
    end
    yield("/wait 0.1")
  end
  end
  
  function noFateSafe()
  if noFate == true then
    if fcount == 0 then
    yield("/echo No Fate existing")
    fcount = fcount +1
    end

    if IsInZone(1187) then      --Urqopacha
    yield("/tp Wachunpelo")
    yield("/wait 6")
    end
    if IsInZone(1188) then      --Kozama'uka
    yield("/tp Ok'hanu")
    yield("/wait 6")
    end
    if IsInZone(1189) then      --Yak T'el
    yield("/tp Iq Br'aax")
    yield("/wait 6")
    end
    if IsInZone(1190) then      --Shaaloani
    yield("/tp Hhusatahwi")
    yield("/wait 6")
    end
    if IsInZone(1191) then      --Heritage Found
    yield("/tp The Outskirts")
    yield("/wait 6")
    end
    if IsInZone(1191) then      --Living Memory
    yield("/tp Leynode mnemo")
    yield("/wait 6")
    end


    while GetCharacterCondition(45) do
    yield("/wait 1")
    end
    yield("/target Aetheryte")
    yield("/wait 0.5")
    yield("/lockon")
    yield("/wait 0.5")
    yield("/automove")
    yield("/wait 0.5")
    yield("/wait 0.5")
    yield("/li 1")
    yield("/wait 2")
    if GetCharacterCondition(45) == false then
    yield("/li 2")
    yield("/wait 1")
    end
    if GetCharacterCondition(45) == false then
    yield("/li 3")
    yield("/wait 1")
    end
    if GetCharacterCondition(45) == false then
    yield("/li 4")
    yield("/wait 1")
    end

    if GetCharacterCondition(26) then
    Name = GetCharacterName()
    PlocX = GetPlayerRawXPos(Name)
    PlocY = GetPlayerRawYPos(Name)+40
    PlocZ = GetPlayerRawZPos(Name)
    yield("/gaction jump")
    yield("/wait 0.5")
    PathfindAndMoveTo(PlocX, PlocY, PlocZ, true)
    PathStop()
    yield("/wait 2")
    end
  end
  end
  ---------------------------Beginning of the Code------------------------------------
  gcount = 0
  cCount = 0
  fcount = 0
  
  --will mount if not mounted on start
  if GetCharacterCondition(4) == false then
    yield('/gaction "mount roulette"')
    yield("/wait 3")
    if GetCharacterCondition(4) == true then
    yield("/gaction jump")
    yield("/wait 2")
  end
  end
  yield("/rotation auto")
  
  --Start of the Code
    while true do
    gems = GetItemCount(26807)
  
  ---------------------------Notification tab---------------------------------------
    if gems > 900 and cCount == 0 then
      yield("/e You are Almost capped with ur Bicolor Gems! <se.3>")
      yield("/wait 1")
      cCount = cCount +1
    end
  ---------------------------------------------------------------------------------
  
  FateLocation()
  FatePath()
  noFateSafe()
  Fate1 = fateId

  -------------------------------Mount---------------------------------------------
  --jump when landing while pathing to fate
  while PathIsRunning() or PathfindInProgress() and IsInFate() == false do
    if GetCharacterCondition(4) and GetCharacterCondition(77) == false then 
      yield("/gaction jump")
      yield("/wait 0.3")
    end
--------------------------------
    FateLocation()
    yield("/wait 1")

    if Fate1 ~= Fate2 then
    if PathIsRunning() == false then
    FateLocation()
    FatePath()
    end
    yield("/vnavmesh stop")
    yield("/wait 0.5")
    end
--------------------------------
    if PathIsRunning() and IsInFate() == true then
      yield("/vnavmesh stop")
      yield("/wait 0.5")
     end
  end
  --path stop when no fate 
    if noFate == true and PathIsRunning() or PathfindInProgress() then
      PathStop()
      yield("/vnavmesh stop")
      yield("/wait 2")
    end
  --dismounting when in fate
    while IsInFate() and GetCharacterCondition(4) do
      yield("/gaction dismount")
      yield("/wait 0.3")
      PathStop()
      yield("/vnavmesh stop")
    end
  ---------------------------------------------------------------------------------
  
  -------------------------------Fate----------------------------------------------
  --dismounts when in fate and paths to the enemys
  while IsInFate() do
      yield("/vnavmesh stop")
      if GetCharacterCondition(4) == true then
        yield("/vnavmesh stop")
        yield("/gaction dismount")
        yield("/wait 2")
        PathStop()
        yield("/vnavmesh stop")
      end
      enemyPathing()
      PathStop()
      yield("/vnavmesh stop")
      yield("/wait 1")
      fcount = 0
      gcount = 0
      cCount = 0
    end
  ---------------------------------------------------------------------------------
  
  -----------------------------After Fate------------------------------------------
  --Repair function
    if ManualRepair == true then
      if NeedsRepair(RepairAmount) then
        while not IsAddonVisible("Repair") do
          yield("/generalaction repair")
          yield("/wait 0.5")
        end
        yield("/pcall Repair true 0")
        yield("/wait 0.1")
        if IsAddonVisible("SelectYesno") then
          yield("/pcall SelectYesno true 0")
          yield("/wait 0.1")
        end
        while GetCharacterCondition(39) do 
          yield("/wait 1") 
        end
        yield("/wait 1")
        yield("/pcall Repair true -1")
      end
    end
  ------------------------------Teleport-----------------------------------------------
  if gems > 1400 and Exchange == true then
      yield("/tp Old Sharlayan")
      yield("/wait 6")
    while GetCharacterCondition(45) == true do
      yield("/wait 0.5")
    end
    if IsInZone(962) then
      while PathIsRunning() == false or PathfindInProgress() == false do
        PathfindAndMoveTo(72.497, 5.1499, -33.533)
      end
      yield("/wait 2")
      while GetCharacterCondition(31) == false do
        yield("/target Gadfrid")
        yield("/wait 1")
        yield("/interact")
        yield("/click talk")
        yield("/wait 1")
      end
      if GetCharacterCondition(31) == true then
        yield("/pcall ShopExchangeCurrency false 0 5 9") --Change the last number "9" to the amount u want to buy 
        yield("/wait 1")
        yield("/pcall SelectYesno true 0")
        yield("/wait 1")
        yield("/pcall ShopExchangeCurrency true -1")
        yield("/wait 1")
        yield("/tp "..teleport)
        yield("/wait 6")
      while GetCharacterCondition(45) do
        yield("/wait 1")
      end
  end
  end
  end
  ---------------------------------------------------------------------------------
    --when fate done mount
    while IsInFate() == false and GetCharacterCondition(4) == false do
      PathStop()
      yield("/wait 3")
      yield('/gaction "mount roulette"')
      yield("/wait 3")
      if GetCharacterCondition(4) == true then
      yield("/gaction jump")
      yield("/wait 2")
      end
     end
  --------------------------------------------------------------------------------
  end
