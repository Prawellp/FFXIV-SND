# Fate Farming Script

## This script requires all files in this folder. MAKE SURE TO TELL SND WHERE THEY ARE (SND OPTIONS --> LUA PATHS)

1. Make sure you have the right plugins.
   
					1. Chat Coordinates
					2. VNAVMESH
					3. Pandora
					4. RSR
					5. BMR
					6. TextAdvance

3. Make sure to set up your paths. Use the Lua path setting in the SND help config.
   
Like this:
![screenshot](https://github.com/CacahuetesManu/SND/blob/main/Docs/LuaPaths.png)

5. Change RSR to attack ALL enemies when solo, or previously engaged.

6. Modify the variables in the script to match what you want.
   ```
	--Teleport and Voucher
	SelectedZoneName = "Living Memory"  --Enter the name of the zone where you want to farm Fates
	EnableChangeInstance = true      --should it Change Instance when there is no Fate (only works on DT fates)
	Exchange = false           --should it Exchange Vouchers
	OldV = false               --should it Exchange Old Vouchers

	--Fate settings
	WaitIfBonusBuff = true          --Don't change instances if you have the Twist of Fate bonus buff
	CompletionToIgnoreFate = 80     --Percent above which to ignore fate
	MinTimeLeftToIgnoreFate = 5*60  --Seconds below which to ignore fate
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
   ```

## Credit
README borrowed from https://github.com/CacahuetesManu/SND/blob/main/Hunt%20Log%20Doer/README.md