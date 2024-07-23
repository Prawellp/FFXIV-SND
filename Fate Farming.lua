  --[[

  ****************************************
  *            Fate Farming              * 
  ****************************************

  Created by: Prawellp, sugarplum done updates v0.1.8 to v0.1.9

  ***********
  * Version *
  *  0.1.9  *
  ***********

    -> 0.1.9    Fixed running into Aetherytes when trying to change instace.
                    ->Will also loop back to the first instance after no fates found in third instance.
                    ->In SND settings under /target turn off Stop macro if not found setting.
                    ->In SND settings under /waitaddon turn off both settings.
                Stopped it from mounting at the start till a fate is found so you don't mount jump then unmount if there are no fates.
                Added names of fates to blacklist.
    -> 0.1.8.1  got rid of uneeded echo messages
    -> 0.1.8    teleport to closest aethyrite for fates.
    -> 0.1.7:   added a new testing feature where you can test stuff that may change other stuff or even be added if enough Positive feedback is given and no bug happening
                    ->added new settings for it
                    ->added testing for instance change
                added new Optional Plugin "Simple Tweaks Plugin"
                    -> needed for the new Vouchers
                    -> needed for Testing
                added new setting "CompletionToIgnoreFate"
                    -> will skip fates that have above the given number of completion Percentage
                added numbers behind the waits for better Debugging so when Reporting something because your stuck please Provide the wait time where its stuck
    -> 0.1.6:   added new Vouchers
                    ->new settings if you want to buy the old ones or new ones
                    ->will use the aetheryte so make sure to have Lifestream
                fixed Instance travel
                    ->shouldn't stop the script anymore (i hope)
                    ->added instance 3 and 4 for travelling
                    ->it will no longer teleport for instance travel after Teleporting one time until you entert a fate again
                Blacklist
                  ->added the 2 Boss fates
                  ->new Blacklist function
                  ->added more fates to the Blacklist
                fixed Retainers
                added a chat Warning when the Required/Optional Plugins aren't enabled if they are required (enabled in settings) only works on 3pp Plugins
                Removed Fatewarning (not enough fates for it)
                made the Description in Settings more clear (hopefully)
                in Required/Optional Plugins there will be a new field in the "()" that will be "[]" to show for what settings you need for it
    -> 0.1.5:   added AutoRetainer support
                    ->new settings for it
                    ->new Optional Plugin requirments for it
                changed to Value of old Vouchers bought from 9 to 13
    -> 0.1.4:   added non-flight support
                will wait for Mesh to be ready before starting now
    -> 0.1.3:   added Bossmod AI feature for dodging and following target (look in Optional Plugins for settings) this is still experimental so it can bug a bit
                Blacklistet some Fates in the Second Area of DT
                Removed Fate settings because they are important. and no need settings for that
                added the section Optional Plugins for stuff like Instance travel, Materia extraction and Bossmod
                Fixed the voucher exchange (but still the old Voucher!!!)

    Known Issues: "Cannot execute at this time." will appear sometimes in the chat you can just Ignore that.

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
    -> Simple Tweaks Plugin: (for targeting [Exchange])
        -> enable "Fix '/target' command"

    -> Yes Already : (for Materia Extraction [ExtractMateria])  https://love.puni.sh/ment.json
        -> Bothers -> MaterializeDialog

    -> Bossmod Reborn : (for AI dodging [BMR])  https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
        -> AI Settings -> enable "Follow during combat" and "Follow out of combat"


]]
--[[

**************
*  Settings  *
**************
]]

--true = yes
--false = no
testing = false           --if you want to test features that may be added or change other sutff

teleport = "Iq Br'aax"     --Enter the name of the Teleporter where youu farm Fates so it teleport back to the area and keeps farming
Exchange = false            --should it Exchange Vouchers
OldV = false               --should it Exchange Old Vouchers
ChangeInstance = true      --sChangeInstancehould it Change Instance when there is no Fate (only works on DT fates)
Retainers = false           --should it do Retainers

ManualRepair = true        --Should it Repair your gear if it falls Below the Repair Amount?
RepairAmount = 20          --the amount it need to drop before Repairing
ExtractMateria = true      --should it Extract Materia
CompletionToIgnoreFate = 80 --Percent above which we ignore the fate

BMR = true                 --if you want to use the BossMod dodge/follow mode
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
    yield("/echo Please Install vnavmesh")
end
if HasPlugin("RotationSolverReborn") == false and HasPlugin("RotationSolver") == false then
    yield("/echo Please Install Rotation Solver Reborn")
end
if HasPlugin("PandorasBox") == false then
    yield("/echo Please Install Pandora'sBox")
end
--Optional Plugin Warning
if ChangeInstance == true  then
if HasPlugin("Lifestream") == false then
    yield("/echo Please Install Lifestream or Disable ChangeInstance in the settings")
end
end
if Retainers == true then
if HasPlugin("AutoRetainer") == false then
    yield("/echo Please Install AutoRetainer")
end
end
if ExtractMateria == true then
if HasPlugin("YesAlready") == false then
    yield("/echo Please Install YesAlready")
end 
end   
if BMR == true then
if HasPlugin("BossModReborn") == false and HasPlugin("BossMod") == false then
    yield("/echo Please Install BossMod Reborn")
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
    yield("/echo Moving to Fate: "..fateId)  
end

--Announcement for gems
if gcount == 0  and fateId ~= 0 and Announce == 1 or Announce == 2 then
    yield("/e Gems: "..gems)
    yield("/wait 0.5002")
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
--When there is no Fate 
function noFateSafe()
    if noFate == true then
    if fcount == 0 then
        yield("/echo No Fate existing")
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
if NavIsReady() == false then
yield("/echo Building Mesh Please wait...")
end

--Will mount if not mounted on start
--if GetCharacterCondition(4) == false then
    --yield('/gaction "mount roulette"')
    --yield("/wait 3.0003")
    --if GetCharacterCondition(4) == true and HasFlightUnlocked(zoneid) then
    --yield("/gaction jump")
    --yield("/wait 2.0009")
    --end
--end
zoneid = GetZoneID()
yield("/rotation auto")
yield("/rotation settings aoetype 2")
  
--Start of the Code
while NavIsReady() == false do
yield("/wait 1.0022")
end
if NavIsReady() then
yield("/echo Mesh is Ready!")
end

while true do
gems = GetItemCount(26807)
  
---------------------------Notification tab--------------------------------------
if gems > 1400 and cCount == 0 then
    yield("/e You are Almost capped with ur Bicolor Gems! <se.3>")
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
    if fateId == 1919 then
        yield("/wait 2.0010")
    end
    yield("/vnavmesh stop")
    yield("/wait 0.5011")
end
end
--Path stops when there is no fate 
if noFate == true and PathIsRunning() or PathfindInProgress() then
    PathStop()
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
        bmaiactive = false
    end
end

-----------------------------After Fate------------------------------------------
while GetCharacterCondition(26) do
yield("/wait 1.0026")
end
--Repair function
if ManualRepair == true and GetCharacterCondition(4) == false then
    if NeedsRepair(RepairAmount) then
    while not IsAddonVisible("Repair") do
    yield("/generalaction repair")
    yield("/wait 0.5012")
    end
    yield("/pcall Repair true 0")
    yield("/wait 0.1")
if IsAddonVisible("SelectYesno") then
    yield("/pcall SelectYesno true 0")
    yield("/wait 0.1")
end
while GetCharacterCondition(39) do 
    yield("/wait 1.0027") 
end
    yield("/wait 1.0028")
    yield("/pcall Repair true -1")
end
end
--Materia Extraction function
if ExtractMateria == true  and GetCharacterCondition(4) == false then
if CanExtractMateria(100) then
    yield("/generalaction \"Materia Extraction\"")
    yield("/waitaddon Materialize")
while CanExtractMateria(100)==true do
    yield("/pcall Materialize true 2")
    yield("/wait 0.5013")
while GetCharacterCondition(39) do
    yield("/wait 0.5014")
end
end 
    yield("/wait 1.0029")
    yield("/pcall Materialize true -1")
    yield("/e Extracted all materia")
end 
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
        yield("/echo processing retainers")
        yield("/wait 1.0036")
        end
        end
       
        while ARRetainersWaitingToBeProcessed() == true do
            yield("/wait 1.0037")
        end

        yield("/wait 1.0038")
        yield("/waitaddon RetainerList")
        yield("/e Finished processing retainers")
        yield("/wait 1.0039")
        yield("/pcall RetainerList true -1")
        yield("/wait 1.0040")
        while IsInZone(129) do
        if IsAddonVisible("RetainerList") then
        yield("/pcall RetainerList true -1")
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
    yield("/click Talk_Click")
    yield("/wait 1.0044")
end
if GetCharacterCondition(31) == true then
    yield("/pcall ShopExchangeCurrency false 0 5 13") --Change the last number "13" to the amount u want to buy 
    yield("/wait 1.0045")
    yield("/pcall SelectYesno true 0")
    yield("/wait 1.0046")
    yield("/pcall ShopExchangeCurrency true -1")
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

    if PathIsRunning() == false or PathfindInProgress() == false then
    yield("/target Aetheryte")
    yield("/lockon")
    yield("/automove")
    end

    while GetDistanceToTarget() > 11 do
    yield("/wait 0.5018")
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
    end

    if IsInZone(1186) and PathIsRunning() == false or PathfindInProgress() == false then
        yield("/target Beryl")
        yield("/wait 0.5019")
        
        while IsInZone(1186) and not IsAddonVisible("ShopExchangeCurrency") do
        yield("/interact")
        yield("/wait 0.5020")
        yield("/click Talk_Click")
        yield("/wait 1.0054")
        end

        if IsInZone(1186) and GetCharacterCondition(31) == true and IsAddonVisible("ShopExchangeCurrency") then
            yield("/pcall ShopExchangeCurrency false 0 5 1") --Change the last number "13" to the amount u want to buy 
            yield("/wait 0.5021")
            yield("/pcall SelectYesno true 0")
            yield("/wait 0.5022")
            yield("/pcall ShopExchangeCurrency true -1")
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
