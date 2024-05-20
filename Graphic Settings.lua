--[[

  ****************************************
  *              Graphics                * 
  *     [Template for Max Graphics]      *
  ****************************************

  Created by: Prawellp

  Script Info:
  A Basic script that changes ur Graphic settings by one click after configurations
  usefull for Mutli client users who want diffrent graphics for each client
  you can put the script in a macro to toggle it with one click just use /pcraft run SND_SCRIPT_NAME_HERE
  (it wont revert back so u would need a second one if you want the old graphics back)

  **************
  *  Settings  *
  **************

]]

--Resolution
Setting1 = 0 --(0 Disabled | 1 Enabled) Enable dynamic resolution.

--General
Setting2 = 1 --(0 Disabled | 1 Enabled) Enable wet Surface effects 
Setting3 = 1 --(0 Disabled | 1 Enabled) Disable rendering of objects when not visible. (Occlusion CUlling)
Setting4 = 1 --(0 Disabled | 1 Enabled) Use low-detail models on distant objects. (LOD)
Setting5 = 0 --(0 Maximum | 1 High | 2 Standart | 3 Off) Real-time Reflections
Setting6 = 0 --(0 FFXAA | 1 Off) Edge Smoothing (Anti-aliasing)
Setting7 = 0 --(0 High | 1 Normal ) Transparent Lighting Quality
Setting8 = 0 --(0 High | 1 Normal | 2 Low | 3 Off) Grass Quality
Setting9 = 0 --(0 High | 1 Normal) Parallax Occlusion
Setting10 = 0 --(0 High | 1 Normal) Tesselation
Setting11 = 0 --(0 Standart | 1 Off) Glare
Setting12 = 0  --(0 High | 1 Normal) Map Resolution

--Shadows
Setting13 = 0 --(0 Display | 1 Hide) Self
Setting14 = 0 --(0 Display | 1 Hide) Party Members
Setting15 = 0 --(0 Display | 1 Hide) Other NPCs
Setting16 = 0 --(0 Display | 1 Hide) Enemies

--Shadow Quality
Setting17 = 0 --(0 Disabled | 1 Enabled) Use low-detail models on shadows. (LOD)
Setting18 = 0 --(0 High | 1 Normal | 2 Low) Shadow Resolution
Setting19 = 0 --(0 Best | 1 Normal | 2 Off) Shadow Cascading
Setting20 = 0 --(0 Strong | 1 Weak) Shadow Softening

--Texture Detail
Setting21 = 0 --(0 Anisotropic | 1 Trilinear | 2 Bilinear) Texture Filtering
Setting22 = 0 --(0 x16 | 1 x8 | 2 x4) Anisotropic Filtering

--Movement Physics
Setting23 = 0 --(0 Full | 1 Simple | 2 Off) Self
Setting24 = 0 --(0 Full | 1 Simple | 2 Off) Party Members
Setting25 = 0 --(0 Full | 1 Simple | 2 Off) Other NPCs
Setting26 = 0 --(0 Full | 1 Simple | 2 Off) Enemies

--Effects
Setting27 = 1 --(0 Disabled | 1 Enabled) Naturally darken the edges of the screen. (Limb Darkening)
Setting28 = 1 --(0 Disabled | 1 Enabled) Blur the graphics around an object in motion. (Radial Blur)
Setting29 = 0 --(0 HBAO+: Quality | 1 HBAO+: Standart | 2 Strong | 3 Light | 4 Off) Screen Space Ambient Occlusion
Setting30 = 0 --(0 Normal | 1 Low | 2 Off) Glare
Setting31 = 0 --(0 Normal | 1 Low | 2 Off) Water Refraction

--Cinematic Cutscenes
Setting32 = 1 --(0 Disabled | 1 Enabled) Enable depth of field.



--------------------Starting Script--------------------

yield("/systemconfig")

while not IsAddonVisible("ConfigSystem") do
    yield("/wait 0.1")
end

if IsAddonVisible("ConfigSystem") then

yield("/pcall ConfigSystem true 17 83 "..Setting1)

yield("/pcall ConfigSystem true 17 84 "..Setting2)
yield("/pcall ConfigSystem true 17 53 "..Setting3)
yield("/pcall ConfigSystem true 17 54 "..Setting4)
yield("/pcall ConfigSystem true 17 82 "..Setting5)
yield("/pcall ConfigSystem true 17 56 "..Setting6)
yield("/pcall ConfigSystem true 17 57 "..Setting7)
yield("/pcall ConfigSystem true 17 58 "..Setting8)
yield("/pcall ConfigSystem true 17 85 "..Setting9)
yield("/pcall ConfigSystem true 17 86 "..Setting10)
yield("/pcall ConfigSystem true 17 87 "..Setting11)
yield("/pcall ConfigSystem true 17 59 "..Setting12)

yield("/pcall ConfigSystem true 17 74 "..Setting13)
yield("/pcall ConfigSystem true 17 75 "..Setting14)
yield("/pcall ConfigSystem true 17 76 "..Setting15)
yield("/pcall ConfigSystem true 17 77 "..Setting16)

yield("/pcall ConfigSystem true 17 60 "..Setting17)
yield("/pcall ConfigSystem true 17 62 "..Setting18)
yield("/pcall ConfigSystem true 17 63 "..Setting19)
yield("/pcall ConfigSystem true 17 64 "..Setting20)

yield("/pcall ConfigSystem true 17 65 "..Setting21)
yield("/pcall ConfigSystem true 17 66 "..Setting22)

yield("/pcall ConfigSystem true 17 78 "..Setting23)
yield("/pcall ConfigSystem true 17 79 "..Setting24)
yield("/pcall ConfigSystem true 17 80 "..Setting25)
yield("/pcall ConfigSystem true 17 81 "..Setting26)

yield("/pcall ConfigSystem true 17 68 "..Setting27)
yield("/pcall ConfigSystem true 17 69 "..Setting28)
yield("/pcall ConfigSystem true 17 70 "..Setting29)
yield("/pcall ConfigSystem true 17 71 "..Setting30)
yield("/pcall ConfigSystem true 17 72 "..Setting31)
yield("/pcall ConfigSystem true 17 73 "..Setting32)

yield("/pcall ConfigSystem true 0")
yield("/systemconfig")
else
    yield("/systemconfig")
end
