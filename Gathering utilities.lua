--Leave "" Blank if you don't want to use any food
--if its HQ include <hq> next to the name "Stuffed Peppers <hq>"
Food = "Stuffed Peppers <hq>"
Medicine = "Superior Spiritbond Potion <hq>"

Extract = true      --if you want it to extract materia
Repair = true       --if you want it to Repauer
RepairAmount = 20   --Repair amount

--don't touch!
Foodcheck = 0
Medicinecheck = 0

while true do
if GetCharacterCondition(6) == false and GetCharacterCondition(45) == false and GetCharacterCondition(4) == false and GetCharacterCondition(27) == false and (PathIsRunning() == false or PathfindInProgress() == false) then
while GetCharacterCondition(27) == true or GetCharacterCondition(4) == true do
yield("/wait 1")
end
--Repair
if NeedsRepair(RepairAmount) and Repair == true then
yield("/gbr auto off")
yield("/visland pause")

while not IsAddonVisible("Repair") do
    yield("/generalaction repair")
    yield("/wait 0.5")
end
if GetCharacterCondition(4) == true then
    yield("/gaction dismount")
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
    yield("/wait 1")
    yield("/gbr auto on")
    yield("/visland resume")
end

--Materia Extract
if CanExtractMateria(100) and Extract == true and GetCharacterCondition(27) == false then
yield("/gbr auto off")
yield("/visland pause")
    yield("/generalaction \"Materia Extraction\"")
    yield("/waitaddon Materialize")
while CanExtractMateria(100) == true and GetCharacterCondition(27) == false do
    if GetCharacterCondition(4) == true then
    yield("/gaction dismount")
    end
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
    yield("/e Extracted all materia")
    yield("/wait 1")
    yield("/gbr auto on")
    yield("/visland resume")
end

--Food usage
if not HasStatusId(48) and (Food == "" == false) and Foodcheck <= 5 then
    while not HasStatusId(48) and (Food == "" == false) and Foodcheck <= 5 do
        yield("/item " .. Food)
        yield("/wait 2")
        Foodcheck = Foodcheck + 1
    end
    if Foodcheck >= 5 then
    yield("/echo no Food left")
    yield("/e <se.1>")
    end
    if HasStatusId(48) then
    Foodcheck = 0
    end
end

--Medicane usage
if not HasStatusId(49) and (Medicine == "" == false) and Medicinecheck <= 5 then
    while not HasStatusId(49) and (Medicine == "" == false) and Medicinecheck <= 5 do
        yield("/item " .. Medicine)
        yield("/wait 2")
        Medicinecheck = Medicinecheck + 1
    end
    if Medicinecheck >= 5 then
    yield("/echo no Medicine left")
    yield("/e <se.1>")
    end
    if HasStatusId(49) then
    Medicinecheck = 0
    end
end

end
yield("/wait 1")
end
