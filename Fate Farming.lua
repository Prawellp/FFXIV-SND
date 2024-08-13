  --[[

  ****************************************
  *            Fate Farming              * 
  ****************************************

  Created by: Prawellp, sugarplum done updates v0.1.8 to v0.1.9, Caladbol (v0.2.3)

  ***********
  * Version *
  *  0.2.3  *
  ***********

    -> 0.2.3    Update the rsr enable when in a FATE to use the job validation logic. This will prevent DPS from aggroing too many mobs.
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
teleport = "Iq Br'aax"     --Enter the name of the Teleporter where youu farm Fates so it teleport back to the area and keeps farming
ChangeInstance = true      --should it Change Instance when there is no Fate (only works on DT fates)
Exchange = false           --should it Exchange Vouchers
OldV = false               --should it Exchange Old Vouchers

--Fate settings
CompletionToIgnoreFate = 80 --Percent above which we ignore the fate
fatewait = 0               --the amount how long it should when before dismounting (0 = at the edge of the fate 3-5 = should be in the middle of the fate)
BMR = true                 --if you want to use the BossMod dodge/follow mode

--Utilities
RepairAmount = 20          --the amount it needs to drop before Repairing (set it to 0 if you don't want it to repaier. onky supports self repair)
ExtractMateria = true      --should it Extract Materia
Food = ""                  --Leave "" Blank if you don't want to use any food
                           --if its HQ include <hq> next to the name "Baked Eggplant <hq>"

--Other stuff
Retainers = false          --should it do Retainers
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
if ChocoboS == true then
    PandoraSetFeatureState("Auto-Summon Chocobo", true) 
    PandoraSetFeatureConfigState("Auto-Summon Chocobo", "Use whilst in combat", true)
elseif ChocoboS == false then
    yield("/e Sad Chocobo noises...")
    PandoraSetFeatureState("Auto-Summon Chocobo", false) 
    PandoraSetFeatureConfigState("Auto-Summon Chocobo", "Use whilst in combat", false)
end

PandoraSetFeatureState("Auto-Sync FATEs", true) 
PandoraSetFeatureState("FATE Targeting Mode", true) 
yield("/wait 0.5001")

--Required Plugin Warning
if HasPlugin("vnavmesh") == false then
    yield("/echo [FATE] Please Install vnavmesh")
end
if HasPlugin("RotationSolverReborn") == false and HasPlugin("RotationSolver") == false then
    yield("/echo [FATE] Please Install Rotation Solver Reborn")
end
if HasPlugin("PandorasBox") == false then
    yield("/echo [FATE] Please Install Pandora'sBox")
end
--Optional Plugin Warning
if ChangeInstance == true  then
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
if BMR == true then
if HasPlugin("BossModReborn") == false and HasPlugin("BossMod") == false then
    yield("/echo [FATE] Please Install BossMod Reborn")
end
end 
------------------------------Functions----------------------------------------------
--Array declaration
FatesBlacklist = { --Fates to blacklist
    1931, -- Combing the Area, collect fate
    1937, -- Borne on the back of Burrowers, collect fate
    1936, -- mole patrol, defence fate?
    1886, -- Young Volcanoes, dangerous
    1906, -- Escape Shroom, collect fate
    1869, -- The Serpentlord Sires, collect fate
    1865, -- Gonna Have me Some Fur, collect fate
    1871, -- The Serpentlord Seethes, S rank fate
    1949, -- License to Dill, collect fate
    1957, -- When It's So Salvage, collect fate
    1913, -- Seeds of Tomorrow, collect fate
    1917, -- Scattered Memories, collect fate
    1922, -- Mascot Murder, S rank fate
    1909, -- The Spawning, collect fate
    1897, -- The Departed, dangerous
    1908 -- Moths Are Tough, Boss fight, very long
}

--Check if fate is in blacklist 
function IsBlackListed (fateID)
    for index, value in ipairs(FatesBlacklist) do
        if value == fateID then
            return true
        end
    end
    return false
end

function CheckTeleport (fateID)
    fatex = GetFateLocationX(fateID)
    fatey = GetFateLocationY(fateID)
    fatez = GetFateLocationZ(fateID)
    Playerx = GetPlayerRawXPos()
    Playery = GetPlayerRawYPos()
    Playerz = GetPlayerRawZPos()
    distanceatheryte1 = 100000000
    distanceatheryte2 = 100000000
    distanceatheryte3 = 100000000000
    distanceleeway = 150000
    distancefly = DistanceBetween(fatex, fatey, fatez, Playerx, Playery, Playerz)
    teleportath1 = ""
    teleportath2 = ""
    teleportath3 = ""


    if IsInZone(1187) then       --Urqopacha
    distanceatheryte1 = DistanceBetween(fatex, fatey, fatez, 335, -160, -415) -- Wach
    distanceatheryte2 = DistanceBetween(fatex, fatey, fatez, 465, 115, 635) -- Worl
    teleportath1 = "Wachunpelo"
    teleportath2 = "Worlar's Echo"
    end
    
    if IsInZone(1188) then       --Kozama'uka
    distanceatheryte1 = DistanceBetween(fatex, fatey, fatez, -170, 6, -470) -- Ok'Hanu
    distanceatheryte2 = DistanceBetween(fatex, fatey, fatez, -482, 123, 315) -- earth
    distanceatheryte3 = DistanceBetween(fatex, fatey, fatez, 545, 115, 200) -- many
    teleportath1 = "Ok'hanu"
    teleportath2 = "Earthenshire"
    teleportath3 = "Many Fires"
    end

    if IsInZone(1189) then     --Yak T'el
    distanceatheryte1 = DistanceBetween(fatex, fatey, fatez, -400, 24, -431) -- Iq Br'aax
    distanceatheryte2 = DistanceBetween(fatex, fatey, fatez, 720, -132, 527) -- Mamook
    teleportath1 = "Iq Br'aax"
    teleportath2 = "Mamook"
    end

    if IsInZone(1190) then      --Shaaloani
    distanceatheryte1 = DistanceBetween(fatex, fatey, fatez, 390, 0, 465) -- Hhusatahwi
    distanceatheryte2 = DistanceBetween(fatex, fatey, fatez, -295, 19, -115) -- Sheshenewezi Springs
    distanceatheryte3 = DistanceBetween(fatex, fatey, fatez, 310, -15, -567) -- Mehwahhetsoan
    teleportath1 = "Hhusatahwi"
    teleportath2 = "Sheshenewezi Springs"
    teleportath3 = "Mehwahhetsoan"
    end

    if IsInZone(1191) then      --Heritage Found
    distanceatheryte1 = DistanceBetween(fatex, fatey, fatez, 515, 145, 210) -- Yyasulani Station
    distanceatheryte2 = DistanceBetween(fatex, fatey, fatez, -221, 32, -583) -- The Outskirts
    distanceatheryte3 = DistanceBetween(fatex, fatey, fatez, -222, 31, 123) -- Electrope Strike
    teleportath1 = "Yyasulani Station"
    teleportath2 = "The Outskirts"
    teleportath3 = "Electrope Strike"
    end

    if IsInZone(1192) then      --Living Memory
    distanceatheryte1 = DistanceBetween(fatex, fatey, fatez, 0, 56, 796) -- Leynode Mnemo
    distanceatheryte2 = DistanceBetween(fatex, fatey, fatez, 659, 27, -285) -- Lleynode Pyro
    distanceatheryte3 = DistanceBetween(fatex, fatey, fatez, -253, 56, -400) -- Lleynode Aero
    teleportath1 = "Leynode Mnemo"
    teleportath2 = "Leynode Pyro"
    teleportath3 = "Leynode Aero"
    end

    comparisondist1 = (distanceatheryte1 - distancefly) + distanceleeway
    comparisondist2 = (distanceatheryte2 - distancefly) + distanceleeway
    comparisondist3 = (distanceatheryte3 - distancefly) + distanceleeway

                if comparisondist1 < comparisondist2 and comparisondist1 < comparisondist3 and comparisondist1 < 0 then
                    yield("/tp "..teleportath1)
                    yield("/wait 8")
                elseif comparisondist2 < comparisondist3 and comparisondist2 < 0 then
                    yield("/tp "..teleportath2)
                    yield("/wait 8")
                elseif comparisondist3 < 0 then
                    yield("/tp "..teleportath3)
                    yield("/wait 8")
                end
                
end

--Gets the Location fo the Fate
function FateLocation()
    if GetCharacterCondition(45) == false then
    fates = GetActiveFates()
    minDistance = 100000
    fateId = 0
    for i = 0, fates.Count-1 do
    tempfate = fates[i]
    if GetFateDuration(fates[i]) > 0 and GetFateProgress(fates[i]) < CompletionToIgnoreFate and IsBlackListed(tempfate) == false then
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
yield("/wait 1.0001")
end
end
--Paths to the Fate
function FatePath()
if fateX == 0 and fateY == 5 and fateZ == 0 then
    noFate = true
    yield("/vnavmesh stop")
    yield("/wait 2.0001")
end
--Announcement for FateId
if fateX ~= 0 and fateY ~= 5 and fateZ ~= 0 then
    zoneid = GetZoneID()
    noFate = false
while GetCharacterCondition(26) == true do
yield("/wait 1")
end
    
CheckTeleport(fateId)

    if noFate ~= true then
    while IsInFate() == false and GetCharacterCondition(4) == false do
        yield("/wait 3.0001")
        yield('/gaction "mount roulette"')
        yield("/wait 3.0002")
    if GetCharacterCondition(4) == true and HasFlightUnlocked(zoneid) then
        yield("/gaction jump")
        yield("/wait 2.0002")
    end
    end
end

    if HasFlightUnlocked(zoneid) then
    PathfindAndMoveTo(fateX, fateY, fateZ, true)
    else
    PathfindAndMoveTo(fateX, fateY, fateZ)
    end

    if Announce == 2 then
    yield("/echo [FATE] Moving to Fate: "..fateId)  
end

--Announcement for gems
if gcount == 0  and fateId ~= 0 and Announce == 1 or Announce == 2 then
    yield("/echo [FATE] Gems: "..gems)
    yield("/wait 0.5002")
    gcount = gcount +1
end
end
end

--Enable rotation based on the current job
function enableRotation()
    Class = GetClassJobId()
    if Class ~= 21 or Class ~= 37 or Class ~= 19 then
    yield("/rotation manual")
    yield("/rotation settings aoetype 1")
    end
    if Class == 21 or Class == 37 or Class == 19 then
    yield("/rotation auto")
    yield("/rotation settings aoetype 2")
    end
end

--Paths to the enemy (for Meele)
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
InstanceCount = 0
--When there is no Fate 
function noFateSafe()
    if noFate == true then
    if fcount == 0 then
        yield("/echo [FATE] No Fate existing")
        fcount = fcount +1
    end

--Change Instance
while GetCharacterCondition(26) == true do
    yield("/wait 1.0002")
end
if ChangeInstance == true and InstanceCount ~= 3 then
yield("/wait 1.0003")

    yield("/target Aetheryte")
    yield("/wait 1.0014")

    while HasTarget() == false do
    if IsInZone(1187) then      --Urqopacha
    yield("/tp Wachunpelo")
    yield("/wait 7.0007")
    end
    if IsInZone(1188) then      --Kozama'uka
    yield("/tp Ok'hanu")
    yield("/wait 7.0008")
    end
    if IsInZone(1189) then      --Yak T'el
    yield("/tp Iq Br'aax")
    yield("/wait 7.0009")
    end
    if IsInZone(1190) then      --Shaaloani
        yield("/tp Hhusatahwi")
        yield("/wait 7.0010")
    end 
    if IsInZone(1191) then      --Heritage Found
        yield("/tp The Outskirts")
        yield("/wait 7.0011")
    end
    if IsInZone(1192) then      --Living Memory
        yield("/tp Leynode mnemo")
        yield("/wait 7.0012")
    end
    while GetCharacterCondition(45) do
    yield("/wait 1.0015")
    end
    yield("/target Aetheryte")
    end

    yield("/lockon")
    yield("/automove")
    while GetDistanceToTarget() > 15 do
    yield("/wait 0.5004")
    if IsMoving() == false then
    if GetTargetName() == "Aetheryte" then
    yield("/target Aetheryte")
    yield("/lockon")
    end
    yield("/automove")
    end
    end

    while PathIsRunning() or PathfindInProgress() do
    yield("/wait 1.0016")
    end
    yield("/vnavmesh stop")
    yield("/gaction dismount")
    if GetCharacterCondition(45) == false and InstanceCount == 0 then
    yield("/wait 0.5005")
    yield("/li 1")
    yield("/wait 1.0017")
    end
    if GetCharacterCondition(45) == false and InstanceCount == 1 then
    yield("/wait 0.5006")
    yield("/li 2")
    yield("/wait 1.0018")
    end
    if GetCharacterCondition(45) == false and InstanceCount == 2 then
    yield("/wait 0.5007")
    yield("/li 3")
    yield("/wait 1.0019")
    end
    if GetCharacterCondition(45) == false and IsPlayerAvailable() == true then
    FateLocation()
    yield("/lockon off")
    yield("/automove off")
    end
    
    if InstanceCount == 2 then
       InstanceCount = 0
    else
    InstanceCount = InstanceCount + 1
    end
    if GetCharacterCondition(45) then
    yield("/wait 1.0021")
    end
end

--If you get attacked it flies up
    if GetCharacterCondition(26) then
    Name = GetCharacterName()
    PlocX = GetPlayerRawXPos(Name)
    PlocY = GetPlayerRawYPos(Name)+40
    PlocZ = GetPlayerRawZPos(Name)
    yield("/gaction jump")
    yield("/wait 0.5009")
    PathfindAndMoveTo(PlocX, PlocY, PlocZ, true)
    PathStop()
    yield("/wait 2.0008")
    end
  end
  end
---------------------------Beginning of the Code------------------------------------
gcount = 0
cCount = 0
fcount = 0
Foodcheck = 0
zoneid = GetZoneID()

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


enableRotation()

--vnavmesh building
if NavIsReady() == false then
yield("/echo [FATE] Building Mesh Please wait...")
end
while NavIsReady() == false do
yield("/wait 1.0022")
end
if NavIsReady() then
yield("/echo [FATE] Mesh is Ready!")
end

--Start of the Code
while true do
gems = GetItemCount(26807)

--food usage
if GetCharacterCondition(27) == false and GetCharacterCondition(45) == false then
if not HasStatusId(48) and (Food == "" == false) and Foodcheck <= 10 and GetCharacterCondition(27) == false and GetCharacterCondition(45) == false then
    while not HasStatusId(48) and (Food == "" == false) and Foodcheck <= 10 and GetCharacterCondition(27) == false and GetCharacterCondition(45) == false do
    while GetCharacterCondition(27) == true or GetCharacterCondition(45) == true do
    yield("/wait 1")
    end
        yield("/item " .. Food)
        yield("/wait 2")
        Foodcheck = Foodcheck + 1
    end
    if Foodcheck >= 10 then
    yield("/echo [FATE] no Food left <se.1>")
    end
    if HasStatusId(48) then
    Foodcheck = 0
    end
end
end
---------------------------Notification tab--------------------------------------
if gems > 1400 and cCount == 0 then
    yield("/echo [FATE] You are Almost capped with ur Bicolor Gems! <se.3>")
    yield("/wait 1.0023")
    cCount = cCount +1
end
---------------------------Fate Pathing part--------------------------------------
if IsPlayerAvailable() then
FateLocation()
FatePath()
noFateSafe()
end
Fate1 = fateId
-------------------------------Fate Pathing Process------------------------------
--Jumps when landing while pathing to a fate
while PathIsRunning() or PathfindInProgress() and IsInFate() == false do
    if GetCharacterCondition(4) and GetCharacterCondition(77) == false and HasFlightUnlocked(zoneid) then 
        yield("/gaction jump")
        yield("/wait 0.3")
    end
--Stops Moving to dead Fates
FateLocation()

if Fate1 ~= Fate2 then
if PathIsRunning() == false then
    FateLocation()
    FatePath()
    yield("/wait 1.0024")
end
    yield("/vnavmesh stop")
    yield("/wait 0.5010")
end
--Stops Pathing when in Fate
if PathIsRunning() and IsInFate() == true then
    enableRotation()
    if fateId == 1919 then
        yield("/wait 2.0010")
    end
    yield("/wait "..fatewait)
    yield("/vnavmesh stop")
    yield("/wait 0.5011")
end
end
--Path stops when there is no fate 
if noFate == true and PathIsRunning() or PathfindInProgress() then
    yield("/vnavmesh stop")
    yield("/wait 2.0011")
end
--Dismounting upon arriving in fate
while IsInFate() and GetCharacterCondition(4) do
    yield("/gaction dismount")
    yield("/wait 0.3")
    yield("/vnavmesh stop")
end
-------------------------------Fate----------------------------------------------
--Dismounts when in fate
bmaiactive = false
while IsInFate() do
    InstanceCount = 0
    yield("/vnavmesh stop")
    if GetCharacterCondition(4) == true then
        yield("/vnavmesh stop")
        yield("/gaction dismount")
        yield("/wait 2.0012")
        PathStop()
        yield("/vnavmesh stop")
    end
--Activates Bossmod upon landing in a fate
if GetCharacterCondition(4) == false and bmaiactive == false then 
    if BMR == true then
        yield("/bmrai on")
        yield("/bmrai followtarget on")
        yield("/bmrai followcombat on")
        yield("/bmrai followoutofcombat on")
        bmaiactive = true
    end
end
--Paths to enemys when Bossmod is disabled
    if BMR == false then 
    enemyPathing()
    end
    PathStop()
    yield("/vnavmesh stop")
    yield("/wait 1.0025")
    fcount = 0
    gcount = 0
    cCount = 0

end
--Disables bossmod when the fate is over
if IsInFate() == false and bmaiactive == true then 
    if BMR == true then
        yield("/bmrai off")
        yield("/bmrai followtarget off")
        yield("/bmrai followcombat off")
        yield("/bmrai followoutofcombat off")
        bmaiactive = false
    end
end

-----------------------------After Fate------------------------------------------
while GetCharacterCondition(26) do
yield("/wait 1.0026")
end
--Repair function
if RepairAmount > 0 and GetCharacterCondition(4) == false then
    if NeedsRepair(RepairAmount) then
    while not IsAddonVisible("Repair") do
    yield("/generalaction repair")
    yield("/wait 0.5012")
    end
    yield("/callback Repair true 0")
    yield("/wait 0.1")
if IsAddonVisible("SelectYesno") then
    yield("/callback SelectYesno true 0")
    yield("/wait 0.1")
end
while GetCharacterCondition(39) do 
    yield("/wait 1.0027") 
end
    yield("/wait 1.0028")
    yield("/callback Repair true -1")
end
end

--Materia Extraction function
if ExtractMateria == true  and GetCharacterCondition(4) == false then
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

if CanExtractMateria(100) and Extract == true and GetCharacterCondition(27) == false then
        yield("/generalaction \"Materia Extraction\"")
        yield("/waitaddon Materialize")
    while CanExtractMateria(100) == true and GetCharacterCondition(27) == false do
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
if Retainers == true and GetCharacterCondition(26) == false then 
    if ARRetainersWaitingToBeProcessed() == true then
        while not IsInZone(129) do
        yield("/tp limsa")
        yield("/wait 7.0013")
        end
        while IsPlayerAvailable() == false and NavIsReady() == false do
        yield("/wait 1.0030")
        end
        if IsPlayerAvailable() and NavIsReady() then
        PathfindAndMoveTo(-122.7251, 18.0000, 20.3941)
        yield("/wait 1.0031")
        end
        while PathIsRunning() or PathfindInProgress() do
        yield("/wait 1.0032")
        end
        if PathIsRunning() == false or PathfindInProgress() == false then
        PathfindAndMoveTo(-122.7251, 18.0000, 20.3941)
        yield("/wait 1.0033")
        end
        yield("/target Summoning Bell")
        while GetTargetName() == "" do
        yield("/target Summoning Bell")
        end 
        while GetTargetName() == "Summoning Bell" and GetDistanceToTarget() > 4.5 do
            PathfindAndMoveTo(-122.7251, 18.0000, 20.3941)
            yield("/wait 1.0034")
            while PathIsRunning() or PathfindInProgress() do
                yield("/wait 1.0035")
            end
        end
        if GetTargetName() == "Summoning Bell" and GetDistanceToTarget() <= 4.5 then
        yield("/wait 0.5015")
        yield("/interact")
        if IsAddonVisible("RetainerList") then
        yield("/ays e")
        yield("/echo [FATE] Processing retainers")
        yield("/wait 1.0036")
        end
        end
       
        while ARRetainersWaitingToBeProcessed() == true do
            yield("/wait 1.0037")
        end

        yield("/wait 1.0038")
        yield("/waitaddon RetainerList")
        yield("/echo [FATE] Finished processing retainers")
        yield("/wait 1.0039")
        yield("/callback RetainerList true -1")
        yield("/wait 1.0040")
        while IsInZone(129) do
        if IsAddonVisible("RetainerList") then
        yield("/callback RetainerList true -1")
        end
        if IsAddonVisible("RetainerList") == false then
        yield("/tp "..teleport)
        yield("/wait 7.0014")
        end
        end
        while GetCharacterCondition(45) do
            yield("/wait 1.0041")
        end
        yield("/wait 1.0042")
    end
end
------------------------------Vouchers-----------------------------------------------
--old Vouchers!
if gems > 1400 and Exchange == true and OldV == true then
    yield("/tp Old Sharlayan")
    yield("/wait 7.0015")
while GetCharacterCondition(45) == true do
    yield("/wait 0.5016")
end
if IsInZone(962) then
    while PathIsRunning() == false or PathfindInProgress() == false do
    PathfindAndMoveTo(72.497, 5.1499, -33.533)
    end
    yield("/wait 2.0013")
while GetCharacterCondition(31) == false do
    yield("/target Gadfrid")
    yield("/wait 1.0043")
    yield("/interact")
    yield("/click Talk Click") 
    yield("/wait 1.0044")
end
if GetCharacterCondition(31) == true then
    yield("/callback ShopExchangeCurrency false 0 5 13") --Change the last number "13" to the amount u want to buy 
    yield("/wait 1.0045")
    yield("/callback SelectYesno true 0")
    yield("/wait 1.0046")
    yield("/callback ShopExchangeCurrency true -1")
    yield("/wait 1.0047")
    yield("/tp "..teleport)
    yield("/wait 7.0016")
while GetCharacterCondition(45) do
    yield("/wait 1.0048")
end
end
end
end

--new Vouchers!
if gems > 1400 and Exchange == true and OldV == false then
while not IsInZone(1186) do
    yield("/tp Solution Nine")
    yield("/wait 7.0017")
        
    while GetCharacterCondition(45) == true do
        yield("/wait 0.5017")
    end
end
if IsInZone(1186) then

    while IsPlayerAvailable() == false or NavIsReady() == false do
        yield("/wait 1.0049")
    end

    while GetCharacterCondition(45) == false do
        yield("/li Nexus Arcade")
        yield("/wait 2.0014")
    end

    while GetCharacterCondition(45) == true or GetCharacterCondition(32) == true do
        yield("/wait 1.0050")
    end

    if IsPlayerAvailable() == true and GetCharacterCondition(45) == false or GetCharacterCondition(32) == false then
        yield("/wait 1.0051")
        PathfindAndMoveTo(-198.466, 0.922, -6.955) --NPC
        yield("/wait 1.0052")
    end

    while PathIsRunning() == true or PathfindInProgress() == true do
        yield("/wait 1.0053")
        while GetDistanceToPoint(-198.466, 0.922, -6.955) > 10 and GetDistanceToPoint(-198.466, 0.922, -6.955) < 15 do
            PathfindAndMoveTo(-198.466, 0.922, -6.955)
            yield("/echo [FATE] Repathing")
            yield("/wait 1")
        end
    end

    if IsInZone(1186) and PathIsRunning() == false or PathfindInProgress() == false then
        yield("/target Beryl")
        yield("/wait 0.5019")
            
        while IsInZone(1186) and not IsAddonVisible("ShopExchangeCurrency") do
            yield("/interact")
            yield("/wait 0.5020")
            yield("/click Talk Click")
            yield("/wait 1.0054")
        end

        if IsInZone(1186) and GetCharacterCondition(31) == true and IsAddonVisible("ShopExchangeCurrency") then
                yield("/callback ShopExchangeCurrency false 0 5 13") --Change the last number "13" to the amount u want to buy 
                yield("/wait 0.5021")
                yield("/callback SelectYesno true 0")
                yield("/wait 0.5022")
                yield("/callback ShopExchangeCurrency true -1")
                yield("/wait 1.0055")
                yield("/tp "..teleport)
                yield("/wait 7.0018")
            while GetCharacterCondition(45) do
                yield("/wait 1.0056")
        end
    end
    end
    end
end
end
