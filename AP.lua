--[[
	Replace or add your own sound files to use a different set of sounds
]]--

--  Add a new pack if you use multiple sounds for an event
	local AP_Pack = {};
	AP_Pack["MKOMBAT_DEATH"] = {};
	AP_Pack["MKOMBAT_COMBAT"] = {};
	AP_Pack["MKOMBAT_POSITIVE"] = {};
	AP_Pack["ENEMY_TARGET"] = {};

--  Name the pack. "This" will be typed to load the pack.
	AP_Pack["NAME"] = "APowers";

--  Enter the path for where your sound files are loacted. 
	local soundPath = "Interface\\AddOns\\MKombat\\Sounds\\AP\\";

--  Played when the mob/player is at 20% health and/or 5 combo points are built up
	AP_Pack["FINISH_THEM"] = soundPath .. "yeahbaby.wav"

--  DEATH sounds, one is randomly played when you die.  You can add additional sounds by using 
--  the same format shown: table.insert( MKOMBAT_DEATH, soundPath .. "sound_file" );
	table.insert( AP_Pack["MKOMBAT_DEATH"], soundPath .. "randy.wav" );
	table.insert( AP_Pack["MKOMBAT_DEATH"], soundPath .. "scrotum.wav" );
	table.insert( AP_Pack["MKOMBAT_DEATH"], soundPath .. "sharks.wav" );
	table.insert( AP_Pack["MKOMBAT_DEATH"], soundPath .. "angry.wav" );

--  Played when TARGETS are detected. Either NPC, an enemy player, or duel request
	AP_Pack["ENEMY_HIGH_TARGET"] = soundPath .. " ";
	table.insert( AP_Pack["ENEMY_TARGET"], soundPath .. "groovy2.wav" );

--  Played when CRITS are detected.  Currently it detects crits you do as well as others
	table.insert( AP_Pack["MKOMBAT_POSITIVE"], soundPath .. "yeahbaby.wav" );
	table.insert( AP_Pack["MKOMBAT_POSITIVE"], soundPath .. "nerdalrt.wav" );
	table.insert( AP_Pack["MKOMBAT_POSITIVE"], soundPath .. "dothat.wav" );

--  Played when DODGES are detected.
	--AP_Pack["MKOMBAT_HDODGE"] = soundPath .. " "; --hunter dodge
	--AP_Pack["MKOMBAT_DODGE"] = soundPath .. " "; --other classes dodge
	--AP_Pack["MKOMBAT_WTDODGE"] = soundPath .. " "; --warrior target dodge
	--AP_Pack["MKOMBAT_TDODGE"] = soundPath .. " "; --other classes target dodge

--  Played when PARRYS are detected.
	--AP_Pack["MKOMBAT_RPARRY"] = soundPath .. " " --rogue parry
	--AP_Pack["MKOMBAT_PARRY"] = soundPath .. " "; --other classes parry

--  Played when COMBO POINTS are detected. (5 combo point sound is same as "FINISH_THEM" wave above.)
	--AP_Pack["MKOMBAT_COMBO1"] = soundPath .. " "; --1 combo point
	--AP_Pack["MKOMBAT_COMBO2"] = soundPath .. " "; --2 combo points
	--AP_Pack["MKOMBAT_COMBO3"] = soundPath .. " "; --3 combo points
	--AP_Pack["MKOMBAT_COMBO4"] = soundPath .. " "; --4 combo points

--  COMBAT MUSIC, add or remove your music preferences
	table.insert( AP_Pack["MKOMBAT_COMBAT"], soundPath .. "apedit.mp3" );

--  Flawless victory, you were not damaged
	AP_Pack["FLAWLESS_WIN "]= soundPath .. "shaglic1.wav";

--  Fatality - you killed the target after hearing the FINISH HIM sound
	AP_Pack["FATALITY"]     = soundPath .. "horny.wav";

--  Brutality - You killed the target with a crit after hearing the FINISH HIM sound 
	AP_Pack["BRUTALITY"]    = soundPath .. "behave.wav";

--  You killed your opponent
	AP_Pack["SUPURB_VICTORY"] = soundPath .. "groovy.wav";

--  Played when the AddOn is checked with "/mk"
	AP_Pack["WELCOME_LOADED"] = soundPath .. "danger.wav";


--  You should define this function if you have any overrides or additions made in the added sound pack
	function AP_MKombat_OnEvent()
	end
--  You should assign the function name as shown
	AP_Pack["OnEvent"] = AP_MKombat_OnEvent;

--  You can add additional OnLoad functionality here as well
--  Do this if you need to register for additional events for your custom sound pack
	function AP_MKombat_OnLoad()
	end
	AP_Pack["OnLoad"] = AP_MKombat_OnLoad;

--  Finally do an insert into the sound packs object
	table.insert( g_MKombat_Packs, AP_Pack );
