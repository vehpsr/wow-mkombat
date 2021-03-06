--[[
    Replace or add your own sound files to use a different set of sounds
]]--

--  Add a new pack if you use multiple sounds for an event
    local MK_Pack = {};
    MK_Pack["MKOMBAT_DEATH"] = {};
    MK_Pack["MKOMBAT_COMBAT"] = {};
    MK_Pack["MKOMBAT_POSITIVE"] = {};
    MK_Pack["ENEMY_TARGET"] = {};
    MK_Pack["MKOMBAT_PARRY"] = {};
    MK_Pack["MKOMBAT_WIN"] = {};

--  Name the pack. "This" will be typed to load the pack.
    MK_Pack["NAME"] = "MKombat";

--  Enter the path for where your sound files are loacted.
    local soundPath = "Interface\\AddOns\\MKombat\\Sounds\\MK\\";

--  DEATH sounds, one is randomly played when you die.  You can add additional sounds by using 
--  the same format shown: table.insert( MKOMBAT_DEATH, soundPath .. "sound_file" );
    table.insert( MK_Pack["MKOMBAT_DEATH"], soundPath .. "pathetic.wav" );
    table.insert( MK_Pack["MKOMBAT_DEATH"], soundPath .. "URNTHING.wav" );
    table.insert( MK_Pack["MKOMBAT_DEATH"], soundPath .. "WEAK.wav" );
    table.insert( MK_Pack["MKOMBAT_DEATH"], soundPath .. "IOUS.wav" );
    table.insert( MK_Pack["MKOMBAT_DEATH"], soundPath .. "homer.wav" );
    table.insert( MK_Pack["MKOMBAT_DEATH"], soundPath .. "nelson.wav" );

--  Played when TARGETS are detected. Either NPC, an enemy player, or duel request
    table.insert( MK_Pack["ENEMY_TARGET"], soundPath .. "destiny.wav" );
    table.insert( MK_Pack["ENEMY_TARGET"], soundPath .. "TYM.wav" );
    table.insert( MK_Pack["ENEMY_TARGET"], soundPath .. "prepare.wav" );

--  Played when CRITS are detected.  Currently it detects crits you do as well as others
    table.insert( MK_Pack["MKOMBAT_POSITIVE"], soundPath .. "welldone.wav" );
    table.insert( MK_Pack["MKOMBAT_POSITIVE"], soundPath .. "excelent.wav" );
    table.insert( MK_Pack["MKOMBAT_POSITIVE"], soundPath .. "OUTSTAND.wav" );

--  Played when DODGES are detected.
    table.insert( MK_Pack["MKOMBAT_PARRY"], soundPath .. "evade.wav")
    table.insert( MK_Pack["MKOMBAT_PARRY"], soundPath .. "punishhim.wav");
    table.insert( MK_Pack["MKOMBAT_PARRY"], soundPath .. "parry.wav");

--  Played when COMBO POINTS are detected. (5 combo point sound is same as "FINISH_THEM" wave above.)
    MK_Pack["MKOMBAT_COMBO1"] = soundPath .. "combo1.mp3"; --1 combo point
    MK_Pack["MKOMBAT_COMBO2"] = soundPath .. "combo2.mp3"; --2 combo points
    MK_Pack["MKOMBAT_COMBO3"] = soundPath .. "combo3.mp3"; --3 combo points
    MK_Pack["MKOMBAT_COMBO4"] = soundPath .. "combo4.mp3"; --4 combo points

--  COMBAT MUSIC, add or remove your music preferences
    table.insert( MK_Pack["MKOMBAT_COMBAT"], soundPath .. "mkedit.mp3" );
    table.insert( MK_Pack["MKOMBAT_COMBAT"], soundPath .. "matrix.mp3" );
    table.insert( MK_Pack["MKOMBAT_COMBAT"], soundPath .. "blade.mp3" );

--  victory
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "mk4flaw.wav");
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "SKFATAL.wav");
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "skbrute.wav");
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "SUPURB.wav");
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "godlike.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "dominating.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "unstoppable.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "wickedsick.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "headshot.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "ludicrouskill.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "monsterkill.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "multikill.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "rampage.wav" );
    table.insert( MK_Pack["MKOMBAT_WIN"], soundPath .. "ultrakill.wav" );

--  Played when the AddOn is checked with "/mk"
    MK_Pack["WELCOME_LOADED"] = soundPath .. "TYM.wav";

--  You should define this function if you have any overrides or additions made in the added sound pack
    function MK_MKombat_OnEvent()
    end
--  You should assign the function name as shown
    MK_Pack["OnEvent"] = MK_MKombat_OnEvent;

--  You can add additional OnLoad functionality here as well
--  Do this if you need to register for additional events for your custom sound pack

--  Need to define the hook function
    local MK_OriginalChatFrame_OnEvent = nil;
    function MK_MKombat_OnLoad()
    end
    MK_Pack["OnLoad"] = MK_MKombat_OnLoad;

--  Finally do an insert into the sound packs object
    table.insert( g_MKombat_Packs, MK_Pack );
