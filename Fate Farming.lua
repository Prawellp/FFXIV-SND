  --[[

  ****************************************
  *            Fate Farming              * 
  ****************************************

  Created by: Prawellp

  ***********
  * Version *
  *  0.1.4  *
  ***********

    -> 0.1.4:   added non-flight support
                will wait for Mesh to be ready before starting now
    -> 0.1.3:   added Bossmod AI feature for dodging and following target (look in Optional Plugins for settings) this is still experimental so it can bug a bit
                Blacklistet some Fates in the Second Area of DT
                Removed Fate settings because they are important. and no need settings for that
                added the section Optional Plugins for stuff like Instance travel, Materia extraction and Bossmod
                Fixed the voucher exchange (but still the old Voucher!!!)
    -> 0.1.2:   added Materia Extraction (and new Plugin Requirment for it)
                new settings added for the Instance changing (only supports Instance 1 and 2 for now)
                Fixed Instance travel (make sure to interact with the aethryte first so its ready)
                added a warning in chat if the Fate is Dangerous (for now its only 2, this are fates i did and almost died as a WAR (level 94) so be aware if you're another class and may be around that level)
                added a setting for the Warning if you don't care
    -> 0.1.1:   Fixed Instance travel
                new Plugin Requirment for instance travel
    -> 0.1.0:   made it stop going to Fates that are done
                switches Instance in the new DT areas


*********************
*  Required Plugins *
*********************

Plugins that are needed for it to work:

    -> VNavmesh :   (for Pathing/Moving)  https://puni.sh/api/repository/veyn       
    -> Pandora :    (for Fate targeting and auto sync) https://love.puni.sh/ment.json             
    -> RotationSolver Reborn :  (for Attacking enemys)  https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json       
        -> Target -> activate "Select only Fate targets in Fate" and "Target Fate priority"
        -> Target -> "Engage settings" set to "Previously engaged targets (enagegd on countdown timer)"
    -> Something Need Doing [Expanded Edition] : (Main Plugin for everything to work)   https://puni.sh/api/repository/croizat       

*********************
*  Optional Plugins *
*********************

This Plugins are Optional and not needed unless you have it enabled in the settings:

    -> Teleporter :  (for Teleporting to aethrytes)
    -> Lifestream :  (for chaning Instances) https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json
    -> Yes Already : (for Materia Extraction) https://love.puni.sh/ment.json
        -> Bothers -> MaterializeDialog
    -> Bossmod Reborn : (for AI dodging) https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
        -> AI Settings -> enable "Follow during combat" and "Follow out of combat"
]]
--[[

**************
*  Settings  *
**************
]]

--Be aware it still buys the old Vouchers!!!
teleport = "Yedlihmad" --Enter the name of the Teleporter where u farm Fates so it teleport back to the area and keeps farming
Exchange = false --true (yes)| false (no) if it should exchange ur gems to Bicolor Gemstone Voucher
ChangeInstance = true --true (yes)| false (no) if there is no Fate it will change the instance (only works in DT areas!)

ManualRepair = true --true (yes)| false (no) --will repair your gear after every fate if the threshold is reached.
RepairAmount = 20   -- the amount of Condition you gear will need before getting Repaired
ExtractMateria = true --true (yes)| false (no) --will Extract Materia if you can

BMR = false --true (yes)| false (no)    --will activate bossmod AI for dodging
ChocoboS = true --true (yes)| false (no)    --Activates the Chocobo settings in Pandora "Auto-Summon Chocobo" and "Use whilst in combat".

FateWarning = true --true (yes)| false (no) --echos a warning in chat with sound from Known Dangerous Fates
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
yield("/wait 0.5")

-------------------------------------------------------------------------------------
  
------------------------------functions----------------------------------------------
--gets the Location fo the Fate
function FateLocation()
    fates = GetActiveFates()
    minDistance = 50000
    fateId = 0
    for i = 0, fates.Count-1 do
    tempfate = fates[i]
    if GetFateDuration(fates[i]) > 0 and tempfate ~= 1931 and tempfate ~= 1937 and tempfate ~= 1938 and tempfate ~= 1936 then --(Blacklist (still need to find away to make it better))
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

--Paths to the Fate
function FatePath()
if fateX == 0 and fateY == 5 and fateZ == 0 then
    noFate = true
    yield("/vnavmesh stop")
    PathStop()
    yield("/wait 2")
end
--Announcement for FateId
if fateX ~= 0 and fateY ~= 5 and fateZ ~= 0 then
    noFate = false
    if HasFlightUnlocked(zoneid) then
    PathfindAndMoveTo(fateX, fateY, fateZ, true)
    else
    PathfindAndMoveTo(fateX, fateY, fateZ)
    end
    if Announce == 2 then
        yield("/echo Moving to Fate: "..fateId)  
--Warning for Dangerous Fates
    if fateId == 1888 or fateId == 1886 and FateWarning == true then
        yield("/echo Be aware this fate can be Dangerous!")  
        yield("/e <se.9>")
    end
end

--Announcement for gems
if gcount == 0  and fateId ~= 0 and Announce == 1 or Announce == 2 then
    yield("/e Gems: "..gems)
    yield("/wait 0.5")
    gcount = gcount +1
end
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
--when there is no Fate 
function noFateSafe()
    if noFate == true then
    if fcount == 0 then
        yield("/echo No Fate existing")
        fcount = fcount +1
    end
--change Instance
if ChangeInstance == true and InstanceCount ~= 4 then
    if IsInZone(1187) then      --Urqopacha
    yield("/tp Wachunpelo")
    yield("/wait 6")
    while GetCharacterCondition(45) do
    yield("/wait 1")
    end
    yield("/wait 2")
    PathMoveTo(334.213, -160.170, -418.789)
    end

    if IsInZone(1188) then      --Kozama'uka
    yield("/tp Ok'hanu")
    yield("/wait 6")
    while GetCharacterCondition(45) do
    yield("/wait 1")
    end
    yield("/wait 2")
    PathMoveTo(-167.426, 7.467, -478.871)
    end

    if IsInZone(1189) then      --Yak T'el
    yield("/tp Iq Br'aax")
    yield("/wait 6")
    while GetCharacterCondition(45) do
    yield("/wait 1")
    end
    yield("/wait 2")
    PathMoveTo(-397.166, 23.464, -429.682)
    end

    if IsInZone(1190) then      --Shaaloani
    yield("/tp Hhusatahwi")
    yield("/wait 6")
    while GetCharacterCondition(45) do
    yield("/wait 1")
    end
    yield("/wait 2")
    PathMoveTo(387.697, -0.241, 469.930)
    end

    if IsInZone(1191) then      --Heritage Found
    yield("/tp The Outskirts")
    yield("/wait 6")
    while GetCharacterCondition(45) do
    yield("/wait 1")
    end
    yield("/wait 2")
    PathMoveTo(-222.029, 31.869, -581.571)
    yield("/wait 2")
    yield("/gaction jump")
    yield("/wait 1")
    end

    if IsInZone(1192) then      --Living Memory
    yield("/tp Leynode mnemo")
    yield("/wait 6")
    while GetCharacterCondition(45) do
    yield("/wait 1")
    end
    yield("/wait 2")
    PathMoveTo(-0.229, 55.666, 794.944)
    yield("/wait 1")
    end
    
    yield("/wait 0.5")
    yield("/li 1")
    yield("/wait 0.5")
    if GetCharacterCondition(45) == false then
    yield("/li 2")
    yield("/wait 0.5")
    end
    yield("/vnavmesh stop")
    InstanceCount = InstanceCount + 1
end

--if you get attacked it flies up
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
zoneid = GetZoneID()
if NavIsReady() == false then
yield("/echo Building Mesh Please wait...")
end

--will mount if not mounted on start
if GetCharacterCondition(4) == false then
    yield('/gaction "mount roulette"')
    yield("/wait 3")
    if GetCharacterCondition(4) == true and HasFlightUnlocked(zoneid) then
    yield("/gaction jump")
    yield("/wait 2")
    end
    end
    yield("/rotation auto")
  
--Start of the Code
while NavIsReady() == false do
yield("/wait 1")
end
if NavIsReady() then
yield("/echo Mesh is Ready!")
end
while true do
gems = GetItemCount(26807)
  
---------------------------Notification tab---------------------------------------
if gems > 1400 and cCount == 0 then
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
    InstanceCount = 0
    if GetCharacterCondition(4) and GetCharacterCondition(77) == false and HasFlightUnlocked(zoneid) then 
        yield("/gaction jump")
        yield("/wait 0.3")
    end
--Stops Moving to dead Fates
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
--stops Pathing when in Fate
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
bmaiactive = false
while IsInFate() do
    yield("/vnavmesh stop")
    if GetCharacterCondition(4) == true then
        yield("/vnavmesh stop")
        yield("/gaction dismount")
        yield("/wait 2")
        PathStop()
        yield("/vnavmesh stop")
    end
if GetCharacterCondition(4) == false and bmaiactive == false then 
    if BMR == true then
        yield("/bmrai on")
        yield("/bmrai followtarget on")
        bmaiactive = true
    end
end
    if BMR == false then 
    enemyPathing()
    end
    PathStop()
    yield("/vnavmesh stop")
    yield("/wait 1")
    fcount = 0
    gcount = 0
    cCount = 0

end
if IsInFate() == false and bmaiactive == true then 
    if BMR == true then
        yield("/bmrai off")
        yield("/bmrai followtarget off")
        bmaiactive = false
    end
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
--Materia Extraction function
if ExtractMateria == true then
if CanExtractMateria(100) then
    yield("/generalaction \"Materia Extraction\"")
    yield("/waitaddon Materialize")
while CanExtractMateria(100)==true do
    yield("/pcall Materialize true 2")
    yield("/wait 0.5")
while GetCharacterCondition(39) do
    yield("/wait 0.5")
end
end 
    yield("/wait 1")
    yield("/pcall Materialize true -1")
    yield("/e Extracted all materia")
end 
end
------------------------------Teleport-----------------------------------------------
--old Vouchers!
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
    yield("/click Talk_Click")
    yield("/wait 1")
end
if GetCharacterCondition(31) == true then
    yield("/pcall ShopExchangeCurrency false 0 5 13") --Change the last number "13" to the amount u want to buy 
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
