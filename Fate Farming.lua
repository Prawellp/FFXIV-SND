  --[[

  ****************************************
  *            Fate Farming              * 
  ****************************************

  Created by: Prawellp, sugarplum done updates v0.1.8 to v0.1.9

  ***********
  * Version *
  *  0.2.4  *
  ***********
    -> 1.0.0    Code changes
                    added pathing priority to prefer bonus fates -> most progress -> fate time left -> by distance
                    added settings for:
                        - WaitIfBonusBuff
                        - MinTimeLeftToIgnoreFate
                        - JoinBossFatesIfActive
                        - CompletionToJoinBossFate
                    enabled non-collection fates that require interacting with an npc to start
                    [dev] rework of internal fate lists, aetheryte lists, character statuses
    -> 0.2.4    Code changes
                    added revive upon death (requires "teleport" to be set in the settings)
                    added GC turn ins
                Setting changes
                    added the category Retainer
                    added 2 new settings for it in the Retainer settings
                Plugin changes
                    added Deliveroo in Optional Plugins for turn ins
    -> 0.2.3    Code changes
                    forgot the rotation settings in the last update to change it based on your job when entering a fate (thanks Caladbol)
                    Removed the numbers behind the wait because im to lazy to update them and check wich i need
                    added antistuck
    -> 0.2.2    Voucher exchange
                    Removed the target, lockon and move to Aetheryte. causing problems since the new spawn points in S9
                    Repaths if you get stuck at the counter
                Rotation Solver
                    turns auto on every time you enter a fate.
                Build in "[FATE]" before every echo in chat
    -> 0.2.1    Fixed game crash caused by checking for the Food status
    -> 0.2.0    Code changes
                    added auto snd property set (sets the snd settings so you don't have to)
                    sets the rsr settings to auto (and aoetype 2) when your on Tank (DRK not included), and on other classes to manual (and aoetype 1) 
                Plugin changes
                    removed the need of simple tweaks (plugin)
                    removed the need of yes already for the materia (plugin)
                    some bossmod settings will now be automatically set so no need to manually check for them (Requires version 7.2.0.22)
                        (Please make sure to change the Desired distance for Meeles manually tho)
                Setting changes
                    added fatewait for the amount it should wait before landing
                    removed Manualrepair setting
                    if RepairAmount is set to 0 it wont repair (to have less settings)
                    Reordert the settings and named some categorys
                    BMR will now be default set to true
                    added food usage


*********************
*  Required Plugins *
*********************

Plugins that are needed for it to work:

    -> Something Need Doing [Expanded Edition] : (Main Plugin for everything to work)   https://puni.sh/api/repository/croizat   
    -> VNavmesh :   (for Pathing/Moving)    https://puni.sh/api/repository/veyn       
    -> Pandora :    (for Fate targeting and auto sync [ChocoboS])   https://love.puni.sh/ment.json             
    -> RotationSolver Reborn :  (for Attacking enemys)  https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json       
        -> Target -> activate "Select only Fate targets in Fate" and "Target Fate priority"
        -> Target -> "Engage settings" set to "Previously engaged targets (enagegd on countdown timer)"

*********************
*  Optional Plugins *
*********************

This Plugins are Optional and not needed unless you have it enabled in the settings:

    -> Teleporter :  (for Teleporting to aetherytes [teleport][Exchange][Retainers])
    -> Lifestream :  (for chaning Instances [ChangeInstance][Exchange]) https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json
    -> AutoRetainer : (for Retainers [Retainers])   https://love.puni.sh/ment.json
    -> Deliveroo : (for gc turn ins [TurnIn])   https://plugins.carvel.li/
    -> Bossmod Reborn : (for AI dodging [BMR])  https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
        -> make sure to set the Max distance in the AI Settings to the desired distance (25 is to far for Meeles)

]]
--[[

**************
*  Settings  *
**************
]]

--true = yes
--false = no

--Teleport and Voucher
teleport = "Electrope Strike"   --Enter the name of the Teleporter where youu farm Fates so it teleport back to the area and keeps farming
EnableChangeInstance = true      --should it Change Instance when there is no Fate (only works on DT fates)
Exchange = false           --should it Exchange Vouchers
OldV = false               --should it Exchange Old Vouchers

--Fate settings
WaitIfBonusBuff = true          --Don't change instances if you have the Twist of Fate bonus buff
CompletionToIgnoreFate = 80     --Percent above which to ignore fate
MinTimeLeftToIgnoreFate = 4*60  --Seconds below which to ignore fate
JoinBossFatesIfActive = true    --Join boss fates if someone is already working on it (to avoid soloing long boss fates). If false, avoid boss fates entirely.
CompletionToJoinBossFate = 20   --Percent above which to join boss fate
fatewait = 0                    --the amount how long it should when before dismounting (0 = at the beginning of the fate 3-5 = should be in the middle of the fate)
useBMR = true                   --if you want to use the BossMod dodge/follow mode


--Utilities
RepairAmount = 20          --the amount it needs to drop before Repairing (set it to 0 if you don't want it to repaier. onky supports self repair)
ExtractMateria = true      --should it Extract Materia
Food = ""                  --Leave "" Blank if you don't want to use any food
                           --if its HQ include <hq> next to the name "Baked Eggplant <hq>"

--Retainer
Retainers = false          --should it do Retainers
TurnIn = false             --should it to Turn ins at the GC
slots = 5                  --how much inventory space before turning in

--Other stuff
ChocoboS = true            --should it Activate the Chocobo settings in Pandora (to summon it)
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
--Chocobo settings
if ChocoboS == true then
    PandoraSetFeatureState("Auto-Summon Chocobo", true) 
    PandoraSetFeatureConfigState("Auto-Summon Chocobo", "Use whilst in combat", true)
elseif ChocoboS == false then
    PandoraSetFeatureState("Auto-Summon Chocobo", false) 
    PandoraSetFeatureConfigState("Auto-Summon Chocobo", "Use whilst in combat", false)
end

--Fate settings
PandoraSetFeatureState("Auto-Sync FATEs", true) 
PandoraSetFeatureState("FATE Targeting Mode", true) 
yield("/wait 0.5")

--snd property
function setSNDProperty(propertyName, value)
    local currentValue = GetSNDProperty(propertyName)
    if currentValue ~= value then
        SetSNDProperty(propertyName, tostring(value))
        LogInfo("[SetSNDProperty] " .. propertyName .. " set to " .. tostring(value))
    end
end

setSNDProperty("UseItemStructsVersion", true)
setSNDProperty("UseSNDTargeting", true)
setSNDProperty("StopMacroIfTargetNotFound", false)
setSNDProperty("StopMacroIfCantUseItem", false)
setSNDProperty("StopMacroIfItemNotFound", false)
setSNDProperty("StopMacroIfAddonNotFound", false)
setSNDProperty("StopMacroIfAddonNotVisible", false)

--Required Plugin Warning
if not HasPlugin("vnavmesh") then
    yield("/echo [FATE] Please Install vnavmesh")
end
if not HasPlugin("RotationSolverReborn") and not HasPlugin("RotationSolver") then
    yield("/echo [FATE] Please Install Rotation Solver Reborn")
end
if not HasPlugin("PandorasBox") then
    yield("/echo [FATE] Please Install Pandora's Box")
end
if not HasPlugin("TextAdvance") then
    yield("/echo [FATE] Please Install TextAdvance")
end

--Optional Plugin Warning
if EnableChangeInstance == true  then
    if HasPlugin("Lifestream") == false then
        yield("/echo [FATE] Please Install Lifestream or Disable ChangeInstance in the settings")
    end
end
if Retainers == true then
    if HasPlugin("AutoRetainer") == false then
        yield("/echo [FATE] Please Install AutoRetainer")
    end
end
if ExtractMateria == true then
    if HasPlugin("YesAlready") == false then
        yield("/echo [FATE] Please Install YesAlready")
    end 
end   
if useBMR == true then
    if HasPlugin("BossModReborn") == false and HasPlugin("BossMod") == false then
        yield("/echo [FATE] Please Install BossMod Reborn")
    end
end 
------------------------------Functions----------------------------------------------
--Array declaration

CharacterCondition = {
    dead=2,
    mounted=4,
    inCombat=26,
    casting=27,
    occupied31=31,
    occupied32=32,
    occupied=33,
    occupied39=39,
    transition=45,
    flying=77
}

CollectionFates = { --Fates to blacklist
    1865, -- Gonna Have me Some Fur
    1869, -- The Serpentlord Sires
    1906, -- Escape Shroom
    1909, -- The Spawning
    1913, -- Seeds of Tomorrow
    1917, -- Scattered Memories
    1931, -- Combing the Area
    1937, -- Borne on the back of Burrowers
    1949, -- License to Dill
    1957, -- When It's So Salvage
}

NonCollectionFatesWithNpc = {
    { fateId=1916, npcName="Unlost Sentry GX", x=-484.6, y=-5.7, z=626.9},  -- Canal Carnage
    { fateId=1920, npcName="The Grand Marshal", x=711.5, y=7.7, z=650.5 },  -- Mascot March
    { fateId=1942, npcName="Novice Hunter", x=408.7956, y=78.64982, z=-407.6445 },          -- It's Super Defective
    { fateId=1943, npcName="Novice Hunter", x=529.0959, y=80.72841, z=-225.3374 },                             -- Running of the Katobleps
    { fateId=1945, npcName="Imperiled Hunter", x=207.6147, y=100.027725, z=66.86777 },      -- Ware the Wolves
    { fateId=1950, npcName="Perplexed Reforger", x=-416.2661, y=38.563328, z=-294.5882 },   -- Domo Arigato
    { fateId=1952, npcName="Driftdowns Reforger", x=9.3, y=14.8, z=0 },                     -- Old Stampeding Grounds
    { fateId=1953, npcName="Panicked Courier", x=-194.994, y=29.70854, z=360.1072 },        -- Pulling the Wool
}

BossFates = {
    1871, -- The Serpentlord Seethes, S rank fate
    1873, -- Breaking  the Jaw
    1908, -- Moths Are Tough
    1912, -- Feed Me, Sentries
    1915, -- Slime to Die
    1918, -- Critical Corruption
    1919, -- Horse in the Round
    1922, -- Mascot Murder, S rank fate
    1948, -- A Scythe to an Axe Fight
    1956, -- (Got My Eye) Set on You
}

BlacklistedFates = 
{
    1886, -- Young Volcanoes, dangerous
    1897, -- The Departed, dangerous
    1936, -- mole patrol, defence fate?
}

--Check if fate is in blacklist 
function IsBlackListed(fateID)
    for index, value in ipairs(BlacklistedFates) do
        if value == fateID then
            return true
        end
    end
    return false
end

function IsCollectionsFate(fateID)
    for index, value in ipairs(CollectionFates) do
        if value == fateID then
            return true
        end
    end
    return false
end

function IsNonCollectionsNpcFate(fateID)
    for index, value in ipairs(NonCollectionFatesWithNpc) do
        if value.fateId == fateID then
            return true
        end
    end
    return false
end

function GetFateNpc(fateID)
    yield("/echo Entered GetFateNpc function")
    for index, value in ipairs(NonCollectionFatesWithNpc) do
        if value.fateId == fateID then
            return value
        end
    end
end

function IsBossFate(fateID)
    for index, value in ipairs(BossFates) do
        if value == fateID then
            return true
        end
    end
    return false
end

Zones = {
    {
        zoneName="Urqopacha",
        zoneId=1187,
        aetheryteList={
            { aetheryteName="Wachunpelo", x=335, y=-160, z=-415 },
            { aetheryteName="Worlar's Echo", x=465, y=115, z=635 },
        }
    },
    {
        zoneName="Kozama'uka",
        zoneId=1188,
        aetheryteList={
            { aetheryteName="Ok'hanu", x=-170, y=6, z=-470 },
            { aetheryteName="Many Fires", x=465, y=115, z=635 },
            { aetheryteName="Earthenshire", x=545, y=115, z=200 }
        }
    },
    {
        zoneName="Yak T'el",
        zoneId=1189,
        aetheryteList={
            { aetheryteName="Iq Br'aax", x=-400, y=24, z=-431 },
            { aetheryteName="Mamook", x=720, y=-132, z=527 }
        }
    },
    {
        zoneName="Shaaloani",
        zoneId=1190,
        aetheryteList={
            { aetheryteName="Hhusatahwi", x=390, y=0, z=465 },
            { aetheryteName="Sheshenewezi Springs", x=-295, y=19, z=-115 },
            { aetheryteName="Mehwahhetsoan", x=310, y=-15, z=-567 }
        }
    },
    {
        zoneName="Heritage Found",
        zoneId=1191,
        aetheryteList={
            { aetheryteName="Yyasulani Station", x=515, y=145, z=210 },
            { aetheryteName="The Outskirts", x=-221, y=32, z=-583 },
            { aetheryteName="Electrope Strike", x=-222, y=31, z=123 }
        }
    },
    {
        zoneName="Living Memory",
        zoneId=1192,
        aetheryteList={
            { aetheryteName="Leynode Mnemo", x=0, y=56, z=796 },
            { aetheryteName="Leynode Pyro", x=659, y=27, z=-285 },
            { aetheryteName="Leynode Aero", x=-253, y=56, z=-400 }
        }
    }
}

function TeleportToClosestAetheryteToFate(playerPosition, nextFate)
    teleportTimePenalty = 500000 -- to account for how long teleport takes you

    local aetheryteForClosestFate = nil
    local closestTravelDistance = DistanceBetween(nextFate.x, nextFate.y, nextFate.z, playerPosition.x, playerPosition.y, playerPosition.z)
    for j, aetheryte in ipairs(SelectedZone.aetheryteList) do
        local distanceAetheryteToFate = DistanceBetween(aetheryte.x, aetheryte.y, aetheryte.z, nextFate.x, nextFate.y, nextFate.z)
        local comparisonDistance = distanceAetheryteToFate + teleportTimePenalty

        if comparisonDistance < closestTravelDistance then
            -- LogInfo("[FATE] Travel via "..aetheryte.aetheryteName.." is closer than previous")
            closestTravelDistance = comparisonDistance
            aetheryteForClosestFate = aetheryte
        end
    end

    -- LogInfo("[FATE] Final closest aetheryte is "..aetheryteForClosestFate.aetheryteName.." with distance: "..closestAetheryteTravelDistance)

    if aetheryteForClosestFate ~=nil then
        yield("/tp "..aetheryteForClosestFate.aetheryteName)
        yield("/wait 8")
    end
end

function EorzeaTimeToUnixTime(eorzeaTime)
    return eorzeaTime/(144/7) -- 24h Eorzea Time equals 70min IRL
end

--[[
    Given two fates, picks the better one based on priority progress -> is bonus -> time left -> distance
]]
function SelectNextFateHelper(tempFate, nextFate)
    
    if tempFate.timeLeft < MinTimeLeftToIgnoreFate then
        return nextFate
    else
        if nextFate == nil then
                LogInfo("[FATE] Selecting #"..tempFate.fateId.." because no other options so far.")
                return tempFate
        elseif nextFate.startTime == 0 and tempFate.startTime > 0 then -- nextFate is an unopened npc fate
            LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." is an unopened npc fate.")
            return tempFate
        elseif tempFate.startTime == 0 and nextFate.startTime > 0 then -- tempFate is an unopened npc fate
            return nextFate
        else -- select based on progress
            if tempFate.progress > nextFate.progress then
                LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." has less progress.")
                return tempFate
            elseif tempFate.progress < nextFate.progress then
                LogInfo("[FATE] Selecting #"..nextFate.fateId.." because other fate #"..tempFate.fateId.." has less progress.")
                return nextFate
            elseif tempFate.progress == nextFate.progress then
                if nextFate.isBonusFate and tempFate.isBonusFate then
                    if tempFate.timeLeft < nextFate.timeLeft then -- select based on time left
                        LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." has more time left.")
                        return tempFate
                    elseif tempFate.timeLeft > nextFate.timeLeft then
                        LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." has more time left.")
                        return nextFate
                    elseif tempFate.timeLeft ==  nextFate.timeLeft then
                        if tempFate.playerDistance < nextFate.playerDistance then
                            LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." is farther.")
                            return tempFate
                        elseif tempFate.playerDistance > nextFate.playerDistance then
                            LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." is farther.")
                            return tempFate
                        else
                            if tempFate.fateId < nextFate.fateId then
                                return tempFate
                            else
                                return nextFate
                            end
                        end
                    end
                elseif nextFate.isBonusFate then
                    return nextFate
                elseif tempFate.isBonusFate then
                    return tempFate
                end
            end
        end
    end
    return nextFate
end

--Gets the Location of the next Fate. Prioritizes anything with progress above 0, then by shortest time left
function SelectNextFate()
    local fates = GetActiveFates()

    local nextFate = nil
    for i = 0, fates.Count-1 do
        local tempFate = {
            fateId = fates[i],
            name = GetFateName(fates[i]),
            progress = GetFateProgress(fates[i]),
            duration = GetFateDuration(fates[i]),
            startTime = GetFateStartTimeEpoch(fates[i]),
            x = GetFateLocationX(fates[i]),
            y = GetFateLocationY(fates[i]),
            z = GetFateLocationZ(fates[i]),
            isBonusFate = GetFateIsBonus(fates[i]),
            fateNpc = GetFateNpc(fates[i])
        }
        tempFate.playerDistance = GetDistanceToPoint(tempFate.x, tempFate.y, tempFate.z)
        LogInfo("[FATE] Considering fate #"..tempFate.fateId.." "..tempFate.name)

        local currentTime = EorzeaTimeToUnixTime(GetCurrentEorzeaTimestamp())
        if tempFate.startTime == 0 then
            tempFate.timeLeft = 900
            if pcall(function () yield("/echo [FATE] NPC for fate #"..tempFate.fateId.." "..tempFate.name.." is "..tempFate.fateNpc.npcName) end) then
            else
                yield("/echo [FATE] Cannot find NPC for fate #"..tempFate.fateId.." "..tempFate.name)
            end
        else
            tempFate.timeElapsed = currentTime - tempFate.startTime
            tempFate.timeLeft = tempFate.duration - tempFate.timeElapsed
        end
        LogInfo("[FATE] Time left on fate #:"..tempFate.fateId..": "..math.floor(tempFate.timeLeft//60).."min, "..math.floor(tempFate.timeLeft%60).."s")
        
        
        if IsCollectionsFate(tempFate.fateId) then -- skip collections fates
            LogInfo("[FATE] Skipping fate #"..tempFate.fateId.." "..tempFate.name.." due to being collections fate.")
        elseif not IsBlackListed(tempFate.fateId) then -- check fate is not blacklisted for any reason
            if IsNonCollectionsNpcFate(tempFate.fateId) then
                if tempFate.startTime > 0 then -- if someone already opened this fate, then treat is as all the other fates
                    nextFate = SelectNextFateHelper(tempFate, nextFate)
                else -- no one has opened this fate yet
                    if nextFate == nil then -- pick this if there's nothing else
                        nextFate = tempFate
                    elseif tempFate.isBonusFate then
                        nextFate = SelectNextFateHelper(tempFate, nextFate)
                    elseif nextFate.startTime == 0 then -- both fates are unopened npc fates
                        nextFate = SelectNextFateHelper(tempFate, nextFate)
                    end
                end
            elseif IsBossFate(tempFate.fateId) then
                if JoinBossFatesIfActive and tempFate.progress >= CompletionToJoinBossFate then
                    nextFate = SelectNextFateHelper(tempFate, nextFate)
                end
            else -- else is normal fate
                nextFate = SelectNextFateHelper(tempFate, nextFate)
            end
            LogInfo("[FATE] Finished considering fate #"..tempFate.fateId.." "..tempFate.name)
        end
    end

    LogInfo("[FATE] Finished considering all fates")

    if nextFate == nil then
        LogInfo("[FATE] No available fates found.")
        yield("/echo [FATE] No available fates found.")
    else
        LogInfo("[FATE] Final selected fate #"..nextFate.fateId.." "..nextFate.name)
        yield("/echo [FATE] Selected fate #"..nextFate.fateId.." "..nextFate.name)
    end
    yield("/wait 1")

    return nextFate
end

--Paths to the Fate
function MoveToFate(nextFate)
    while GetCharacterCondition(CharacterCondition.inCombat) do
        yield("/wait 1")
    end

    local playerPosition = {
        x = GetPlayerRawXPos(),
        y = GetPlayerRawYPos(),
        z = GetPlayerRawZPos()
    }
    TeleportToClosestAetheryteToFate(playerPosition, nextFate)

    while not IsInFate() and not GetCharacterCondition(CharacterCondition.mounted) do
        yield("/wait 3")
        yield('/gaction "mount roulette"')
        yield("/wait 3")
        if GetCharacterCondition(CharacterCondition.mounted) and not GetCharacterCondition(CharacterCondition.flying) and HasFlightUnlocked(SelectedZone.zoneId) then
            yield("/gaction jump")
            yield("/wait 2")
        end
    end

    if HasFlightUnlocked(SelectedZone.zoneId) then
        yield("/echo [FATE] Moving to "..nextFate.x..", "..nextFate.y..", "..nextFate.z)
        PathfindAndMoveTo(nextFate.x, nextFate.y, nextFate.z, true)
    else
        yield("/echo [FATE] Moving to "..nextFate.x..", "..nextFate.y..", "..nextFate.z)
        PathfindAndMoveTo(nextFate.x, nextFate.y, nextFate.z)
    end

    if Announce == 2 then
        LogInfo("[FATE] Moving to Fate: #"..nextFate.fateId.." "..nextFate.name.." at X:"..nextFate.x..", Y: "..nextFate.y..", Z: "..nextFate.z)  
    end

    --Announcement for gems
    if GemAnnouncementCount == 0  and nextFate.fateId ~= 0 and Announce == 1 or Announce == 2 then
        LogInfo("[FATE] Gems: "..gems)
        yield("/wait 0.5")
        GemAnnouncementCount = GemAnnouncementCount +1
    end
end

function InteractWithFateNpc(target)
    yield("/vnavmesh stop")
    LogInfo("[FATE] Moving to fate NPC at X:"..target.x..", Y:"..target.y..", Z:"..target.z)
    PathfindAndMoveTo(target.x, target.y, target.z)
    LogInfo("[FATE] Finished moving to fate NPC")
    yield("/target "..target.npcName)
    yield("/wait 1")

    while not HasTarget() do
        PathfindAndMoveTo(target.x, target.y, target.z)
        yield("/target "..target.npcName)
        yield("/wait 1")
    end

    LogDebug("[FATE] Found fate NPC "..target.npcName..". Current distance: "..DistanceBetween(GetPlayerRawXPos(), GetPlayerRawYPos(), GetPlayerRawZPos(), target.x, target.y, target.z))

    yield("/lockon")
    yield("/automove")

    while GetDistanceToTarget() > 15 do
        LogDebug("[FATE] Too far from Fate NPC "..target.npcName..". Current distance: "..DistanceBetween(GetPlayerRawXPos(), GetPlayerRawYPos(), GetPlayerRawZPos(), target.x, target.y, target.z))
        yield("/wait 0.5")
        if not IsMoving() then
            if GetTargetName() == target.npcName then
                yield("/target "..target.npcName)
                yield("/lockon")
            end
            yield("/automove")
        end
    end

    LogDebug("[FATE] Arrived at Fate NPC "..target.npcName..". Current distance: "..DistanceBetween(GetPlayerRawXPos(), GetPlayerRawYPos(), GetPlayerRawZPos(), target.x, target.y, target.z))
    yield("/wait 1")
    yield("/interact")
    LogDebug("[FATE] Triggered interact with "..target.npcName..".")
    yield("/wait 1")
    if IsAddonVisible("SelectYesno") then
        yield("/callback SelectYesno true 0")
        yield("/wait 0.1")
    end
    LogInfo("[FATE] Exiting InteractWithFateNpc")
end

--Paths to the enemy (for Meele)
function EnemyPathing()
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

CurrentInstance = 0
--When there is no Fate 
function ChangeInstance()
    --Change Instance
    while GetCharacterCondition(CharacterCondition.inCombat) do
        yield("/wait 1")
    end
    if EnableChangeInstance and CurrentInstance ~= 3 then
        yield("/wait 1")

        yield("/target Aetheryte")
        yield("/wait 1")

        while not HasTarget() do
            LogInfo("[FATE] Cannot target aetheryte.")
            local closestAetheryte = nil
            local closestAetheryteDistance = math.maxinteger
            for i, aetheryte in ipairs(SelectedZone.aetheryteList) do
                local distanceToAetheryte = GetDistanceToPoint(aetheryte.x, aetheryte.y, aetheryte.z)
                if distanceToAetheryte < closestAetheryteDistance then
                    closestAetheryte = aetheryte
                    closestAetheryteDistance = distanceToAetheryte
                end
            end
            yield("/tp "..closestAetheryte.aetheryteName)
            
            while GetCharacterCondition(CharacterCondition.transition) do
                yield("/wait 1")
            end

            yield("/target Aetheryte")
            yield("/wait 1")
        end

        yield("/lockon")
        yield("/automove")
        while GetDistanceToTarget() > 15 do
            yield("/wait 0.5")
            if not IsMoving() then
                if GetTargetName() == "Aetheryte" then
                    yield("/target Aetheryte")
                    yield("/lockon")
                end
                yield("/automove")
            end
        end

        while PathIsRunning() or PathfindInProgress() do
            yield("/wait 1")
        end
            yield("/vnavmesh stop")
            yield("/gaction dismount")

        if not GetCharacterCondition(CharacterCondition.transition) then
            yield("/wait 0.5")
            yield("/li "..CurrentInstance+1)
            yield("/wait 1")
            CurrentInstance = (CurrentInstance + 1) % 3
        end

        while GetCharacterCondition(CharacterCondition.transition) do
            CodeWait(1)
        end
        CurrentFate = SelectNextFate()
        yield("/lockon off")
        yield("/automove off")
    end
end

function AvoidEnemiesWhileFlying()
    --If you get attacked it flies up
    if GetCharacterCondition(CharacterCondition.inCombat) then
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

function PromptRSR()
    Class = GetClassJobId()
    
    if Class == 21 or Class == 37 or Class == 19 or Class == 32 then -- tank classes
        yield("/rotation auto")
        yield("/rotation settings aoetype 1")
    elseif Class == 24 then -- white mage holy OP
        yield("/rotation manual")
        yield("/rotation settings aoetype 2")
    else
        yield("/rotation manual")
        yield("/rotation settings aoetype 3")
    end
end

function antistuck()
    stuck = 0
    PX = GetPlayerRawXPos()
    PY = GetPlayerRawYPos()
    PZ = GetPlayerRawZPos()
    yield("/wait 3")
    PXX = GetPlayerRawXPos()
    PYY = GetPlayerRawYPos()
    PZZ = GetPlayerRawZPos()

    if PX == PXX and PY == PYY and PZ == PZZ then
        while GetDistanceToTarget() > 3.5 and stuck < 20 do
            local enemy_x = GetTargetRawXPos()
            local enemy_y = GetTargetRawYPos()
            local enemy_z = GetTargetRawZPos()
            if PathIsRunning() == false and GetCharacterCondition(4, false) then 
                LogInfo("[FATE] Moving to enemy "..enemy_x..", "..enemy_y..", "..enemy_z)
                PathfindAndMoveTo(enemy_x, enemy_y, enemy_z)
            end
            if not PathIsRunning() and GetCharacterCondition(4, true) then
                LogInfo("[FATE] Moving to enemy "..enemy_x..", "..enemy_y..", "..enemy_z)
                PathfindAndMoveTo(enemy_x, enemy_y, enemy_z, true)
            end
            yield("/wait 0.5")
            stuck = stuck + 1
        end
        if stuck >= 20 then
            yield("/vnavmesh stop")
        end
        stuck = 0
    end
end

function HandleDeath()
    if GetCharacterCondition(CharacterCondition.dead) then --Condition Dead
        yield("/echo [FATE] You have died. Returning to home aetheryte.")
        while not IsAddonVisible("SelectYesno") do --rez addon wait
            yield("/wait 1")
        end

        if IsAddonVisible("SelectYesno") then --rez addon yes
            yield("/callback SelectYesno true 0")
            yield("/wait 0.1")
        end

        while GetCharacterCondition(CharacterCondition.transition) do --wait between areas
            yield("/wait 1")
        end

        while GetCharacterCondition(2) do --wait till alive
            yield("/wait 1")
        end

        yield("/tp "..teleport) --teleport
        yield("/wait 7")

        while GetCharacterCondition(CharacterCondition.transition) do --wait between areas
            yield("/wait 1")
        end
    end
end

function CodeWait(seconds)
    startTime = GetCurrentEorzeaTimestamp()
    endTime = startTime + seconds
    while GetCurrentEorzeaTimestamp() < endTime do
        -- do nothing
    end
end

---------------------------Beginning of the Code------------------------------------
GemAnnouncementCount = 0
cCount = 0
AvailableFateCount = 0
FoodCheck = 0

--vnavmesh building
if not NavIsReady() then
    yield("/echo [FATE] Building Mesh Please wait...")
end
while not NavIsReady() do
    yield("/wait 1")
end
if NavIsReady() then
    yield("/echo [FATE] Mesh is Ready!")
end

-- turn on TextAdvance
yield("/at y")

--Start of the Loop
SelectedZone = nil
for i, zone in ipairs(Zones) do
    for j, aetheryte in ipairs(zone.aetheryteList) do
        if aetheryte.aetheryteName == teleport then
            SelectedZone = zone
        end
    end
end
if SelectedZone == nil then
    yield("/echo Cannot find aetheryte "..teleport)
end
if not IsInZone(SelectedZone.zoneId) then
    yield("/echo [FATE] Teleporting to "..teleport.." and beginning FATE farm.")
    yield("/tp "..teleport)
    yield("/wait 7")
end

while true do
    gems = GetItemCount(26807)

    --food usage
    if not (GetCharacterCondition(CharacterCondition.casting) or GetCharacterCondition(CharacterCondition.transition)) then
        if not HasStatusId(48) and (Food == "" == false) and FoodCheck <= 10 and not GetCharacterCondition(CharacterCondition.casting) and not GetCharacterCondition(CharacterCondition.transition) then
            while not HasStatusId(48) and (Food == "" == false) and FoodCheck <= 10 and not GetCharacterCondition(CharacterCondition.casting) and not GetCharacterCondition(CharacterCondition.transition) do
                while GetCharacterCondition(CharacterCondition.casting) or GetCharacterCondition(CharacterCondition.transition) do
                    yield("/wait 1")
                end
                yield("/item " .. Food)
                yield("/wait 2")
                FoodCheck = FoodCheck + 1
            end
            if FoodCheck >= 10 then
                yield("/echo [FATE] no Food left <se.1>")
            end
            if HasStatusId(48) then
                FoodCheck = 0
            end
        end
    end

    ---------------------------Notification tab--------------------------------------
    if gems > 1400 and cCount == 0 then
        yield("/echo [FATE] You are almost capped with ur Bicolor Gems! <se.3>")
        yield("/wait 1")
        cCount = cCount +1
    end
    ---------------------------Select and Move to Fate--------------------------------------

    while not IsPlayerAvailable() do
        -- wait for player to be avialable
    end
    CurrentFate = SelectNextFate() -- init first fate object

    -- if has twist of fate buff 
    if CurrentFate == nil and WaitIfBonusBuff and (HasStatusId(1288) or HasStatusId(1289)) then
        yield("/echo [FATE] Staying in instance due to Twist of Fate bonus buff.")
        while CurrentFate == nil do
            CodeWait(30)
            CurrentFate = SelectNextFate()
        end
    else
        while CurrentFate == nil do
            LogInfo("[FATE] Changing instances.")
            ChangeInstance()
        end
    end
    MoveToFate(CurrentFate)

    HandleDeath()

    NextFate = CurrentFate
    ---------------------------- While vnavmesh is Moving ------------------------------

    -- while vnavmesh is moving to a fate
    while PathIsRunning() or PathfindInProgress() and not IsInFate() do
        
        -- if mounted on land, jump to fly
        if GetCharacterCondition(CharacterCondition.mounted) and not GetCharacterCondition(CharacterCondition.flying) and HasFlightUnlocked(SelectedZone.zoneId) then 
            yield("/gaction jump")
            yield("/wait 0.3")
        end

        --Stops Moving to dead Fates or change paths to better fates
        NextFate = SelectNextFate()
        if CurrentFate.fateId ~= NextFate.fateId then
            yield("/echo [FATE] Stopped pathing, higher priority fate found: #"..NextFate.fateId.." "..NextFate.name)
            yield("/vnavmesh stop")
            yield("/wait 0.5")
            if not PathIsRunning() then
                CurrentFate = NextFate
                MoveToFate(NextFate)
                yield("/wait 1")
            end
        end

        -- Stops Pathing when in Fate
        if PathIsRunning() then
            if IsInFate() then
                LogInfo("[FATE] Arrived at fate #"..CurrentFate.fateId.." "..CurrentFate.name)
                yield("/vnavmesh stop")
                yield("/wait "..fatewait)
                yield("/wait 0.5")
                PromptRSR()
            elseif CurrentFate.startTime == 0 and DistanceBetween(GetPlayerRawXPos(), GetPlayerRawYPos(), GetPlayerRawZPos(), CurrentFate.fateNpc.x, CurrentFate.fateNpc.y, CurrentFate.fateNpc.z) < 7 then -- need to talk to npc to start fate
                LogInfo("[FATE] Arrived at fate #"..CurrentFate.fateId.." "..CurrentFate.name)    
                yield("/vnavmesh stop")
                yield("/gaction dismount")
                InteractWithFateNpc(CurrentFate.fateNpc)
            end
        end
    end
    yield("/echo [FATE] Arrived at fate #"..NextFate.fateId.." "..NextFate.name)
    CurrentFate = NextFate

    --Dismounting upon arriving at fate
    while GetCharacterCondition(CharacterCondition.mounted) and (IsInFate() or CurrentFate.startTime == 0) do
        yield("/vnavmesh stop")
        yield("/gaction dismount")
        yield("/wait 0.3")
        antistuck()
    end

    if CurrentFate.startTime == 0 then -- need to talk to npc to start fate
        InteractWithFateNpc(CurrentFate.fateNpc)
    end

    -------------------------------Engage Fate Combat--------------------------------------------
    --Dismounts when in fate
    bossModAIActive = false

    while IsInFate() do
        CurrentInstance = 0
        yield("/vnavmesh stop")
        if GetCharacterCondition(CharacterCondition.mounted) then
            yield("/vnavmesh stop")
            yield("/gaction dismount")
            yield("/wait 2")
            yield("/vnavmesh stop")
        end

        --Activates Bossmod upon landing in a fate
        if not GetCharacterCondition(CharacterCondition.mounted) and not bossModAIActive then 
            if useBMR then
                yield("/bmrai on")
                yield("/bmrai followtarget on")
                yield("/bmrai followcombat on")
                yield("/bmrai followoutofcombat on")
                bossModAIActive = true
            end
        end

        --Paths to enemys when Bossmod is disabled
        if not useBMR then 
            EnemyPathing()
        end
        yield("/vnavmesh stop")
        yield("/wait 1")
        AvailableFateCount = 0
        GemAnnouncementCount = 0
        cCount = 0
        antistuck()
        if GetCharacterCondition(CharacterCondition.dead) then
            HandleDeath()
        end

        yield("/target Forlorn Maiden")
        yield("/target Forlorn")
    end

    --Disables bossmod when the fate is over
    if not IsInFate() and bossModAIActive then 
        if useBMR then
            yield("/bmrai off")
            yield("/bmrai followtarget off")
            yield("/bmrai followcombat off")
            yield("/bmrai followoutofcombat off")
            bossModAIActive = false
        end
    end

    -----------------------------After Fate------------------------------------------
    while GetCharacterCondition(CharacterCondition.inCombat) do
        yield("/wait 1")
    end

    --Repair function
    if RepairAmount > 0 and not GetCharacterCondition(CharacterCondition.mounted) then
        if NeedsRepair(RepairAmount) then
            while not IsAddonVisible("Repair") do
                yield("/generalaction repair")
                yield("/wait 0.5")
            end
            yield("/callback Repair true 0")
            yield("/wait 0.1")
            if IsAddonVisible("SelectYesno") then
                yield("/callback SelectYesno true 0")
                yield("/wait 0.1")
            end
            while GetCharacterCondition(39) do 
                yield("/wait 1") 
            end
            yield("/wait 1")
            yield("/callback Repair true -1")
        end
    end

    --Materia Extraction function
    if ExtractMateria and not GetCharacterCondition(CharacterCondition.mounted) then
        if CanExtractMateria(100) then
            yield("/generalaction \"Materia Extraction\"")
            yield("/waitaddon Materialize")
            while CanExtractMateria(100) == true do
                if not IsAddonVisible("Materialize") then
                    yield("/generalaction \"Materia Extraction\"")
                end
                yield("/pcall Materialize true 2")
                yield("/wait 0.5")
                if IsAddonVisible("MaterializeDialog") then
                    yield("/pcall MaterializeDialog true 0")
                    yield("/wait 0.1")
                end
                while GetCharacterCondition(39) do
                    yield("/wait 0.5")
                end
            end 
            yield("/wait 1")
            yield("/pcall Materialize true -1")
            yield("/echo [FATE] Extracted all materia")
            yield("/wait 1")
        end
    end

    if CanExtractMateria(100) and Extract and not GetCharacterCondition(CharacterCondition.casting) then
        yield("/generalaction \"Materia Extraction\"")
        yield("/waitaddon Materialize")
        while CanExtractMateria(100) == true and not GetCharacterCondition(CharacterCondition.casting) do
            if not IsAddonVisible("Materialize") then
                yield("/generalaction \"Materia Extraction\"")
            end
                yield("/pcall Materialize true 2")
                yield("/wait 0.5")
            if IsAddonVisible("MaterializeDialog") then
                yield("/pcall MaterializeDialog true 0")
                yield("/wait 0.1")
            end
            while GetCharacterCondition(39) do
                yield("/wait 0.5")
            end
        end 
        yield("/wait 1")
        yield("/pcall Materialize true -1")
        yield("/echo [FATE] Extracted all materia")
        yield("/wait 1")
    end

    --Retainer Process
    if Retainers and GetCharacterCondition(CharacterCondition.inCombat) == false then 
        if ARRetainersWaitingToBeProcessed() == true then
            while not IsInZone(129) do
                yield("/tp limsa")
                yield("/wait 7")
            end
            while IsPlayerAvailable() == false and NavIsReady() == false do
                yield("/wait 1")
            end
            if IsPlayerAvailable() and NavIsReady() then
                PathfindAndMoveTo(-122.7251, 18.0000, 20.3941)
                yield("/wait 1")
            end
            while PathIsRunning() or PathfindInProgress() do
                yield("/wait 1")
            end
            if PathIsRunning() == false or PathfindInProgress() == false then
                PathfindAndMoveTo(-122.7251, 18.0000, 20.3941)
                yield("/wait 1")
            end
            yield("/target Summoning Bell")
            while GetTargetName() == "" do
            yield("/target Summoning Bell")
            end 
            while GetTargetName() == "Summoning Bell" and GetDistanceToTarget() > 4.5 do
                PathfindAndMoveTo(-122.7251, 18.0000, 20.3941)
                yield("/wait 1")
                while PathIsRunning() or PathfindInProgress() do
                    yield("/wait 1")
                end
            end
            if GetTargetName() == "Summoning Bell" and GetDistanceToTarget() <= 4.5 then
            yield("/wait 0.5")
            yield("/interact")
            if IsAddonVisible("RetainerList") then
            yield("/ays e")
            yield("/echo [FATE] Processing retainers")
            yield("/wait 1")
            end
            end
        
            while ARRetainersWaitingToBeProcessed() == true do
                yield("/wait 1")
            end

            yield("/wait 1")
            yield("/waitaddon RetainerList")
            yield("/echo [FATE] Finished processing retainers")
            yield("/wait 1")
            yield("/callback RetainerList true -1")
            yield("/wait 1")
            while IsInZone(129) do
                if IsAddonVisible("RetainerList") then
                    yield("/callback RetainerList true -1")
                    yield("/wait 1")
                end

                --Deliveroo
                if GetInventoryFreeSlotCount() < slots and TurnIn == true then
                    yield("/li gc")
                end
                while DeliverooIsTurnInRunning() == false do
                    yield("/wait 1")
                    yield("/deliveroo enable")
                end
                if DeliverooIsTurnInRunning() then
                    yield("/vnav stop")
                end
                while DeliverooIsTurnInRunning() do
                    yield("/wait 1")
                end
            end

            yield("/tp "..teleport)
            yield("/wait 7")

            while GetCharacterCondition(CharacterCondition.transition) do
                yield("/wait 1")
            end
            yield("/wait 1")
        end
    end


------------------------------Vouchers-----------------------------------------------
--old Vouchers!
    if gems > 1400 and Exchange == true and OldV == true then
        yield("/tp Old Sharlayan")
        yield("/wait 7")
        while GetCharacterCondition(CharacterCondition.transition) == true do
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
                yield("/click Talk Click") 
                yield("/wait 1")
            end
            if GetCharacterCondition(31) == true then
                yield("/callback ShopExchangeCurrency false 0 5 13") --Change the last number "13" to the amount u want to buy 
                yield("/wait 1")
                yield("/callback SelectYesno true 0")
                yield("/wait 1")
                yield("/callback ShopExchangeCurrency true -1")
                yield("/wait 1")
                yield("/tp "..teleport)
                yield("/wait 7")
                while GetCharacterCondition(CharacterCondition.transition) do
                    yield("/wait 1")
                end
            end
        end
    end

    --new Vouchers!
    if gems > 1400 and Exchange == true and OldV == false then
        while not IsInZone(1186) do
            yield("/tp Solution Nine")
            yield("/wait 7")
                
            while GetCharacterCondition(CharacterCondition.transition) == true do
                yield("/wait 0.5")
            end
        end
        if IsInZone(1186) then

            while IsPlayerAvailable() == false or NavIsReady() == false do
                yield("/wait 1")
            end

            while GetCharacterCondition(CharacterCondition.transition) == false do
                yield("/li Nexus Arcade")
                yield("/wait 2")
            end

            while GetCharacterCondition(CharacterCondition.transition) == true or GetCharacterCondition(32) == true do
                yield("/wait 1")
            end

            if IsPlayerAvailable() == true and GetCharacterCondition(CharacterCondition.transition) == false or GetCharacterCondition(32) == false then
                yield("/wait 1")
                PathfindAndMoveTo(-198.466, 0.922, -6.955) --NPC
                yield("/wait 1")
            end

            while PathIsRunning() == true or PathfindInProgress() == true do
                yield("/wait 1")
                while GetDistanceToPoint(-198.466, 0.922, -6.955) > 10 and GetDistanceToPoint(-198.466, 0.922, -6.955) < 15 do
                    PathfindAndMoveTo(-198.466, 0.922, -6.955)
                    yield("/echo [FATE] Repathing")
                    yield("/wait 1")
                end
            end

            if IsInZone(1186) and PathIsRunning() == false or PathfindInProgress() == false then
                yield("/target Beryl")
                yield("/wait 0.5")
            
                while IsInZone(1186) and not IsAddonVisible("ShopExchangeCurrency") do
                    yield("/interact")
                    yield("/wait 0.5")
                    yield("/click Talk Click")
                    yield("/wait 1")
                end

                if IsInZone(1186) and GetCharacterCondition(31) == true and IsAddonVisible("ShopExchangeCurrency") then
                    yield("/callback ShopExchangeCurrency false 0 5 13") --Change the last number "13" to the amount you want to buy. Change the third number "5" to the item you want to buy (the first item will be 0 then 1, 2, 3 and so on )
                    yield("/wait 0.5")
                    yield("/callback SelectYesno true 0")
                    yield("/wait 0.5")
                    yield("/callback ShopExchangeCurrency true -1")
                    yield("/wait 1")
                    yield("/tp "..teleport)
                    yield("/wait 7")
                    while GetCharacterCondition(CharacterCondition.transition) do
                        yield("/wait 1")
                    end
                end
            end
        end
    end
end
