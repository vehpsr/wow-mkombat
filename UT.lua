--[[
	Replace or add your own sound files to use a different set of sounds
]]--

--  Add a new pack if you use multiple sounds for an event
	local UT_Pack = {};
	UT_Pack["MKOMBAT_DEATH"] = {};
	UT_Pack["MKOMBAT_COMBAT"] = {};
	UT_Pack["MKOMBAT_POSITIVE"] = {};
	UT_Pack["ENEMY_TARGET"] = {};

--  Name the pack. "This" will be typed to load the pack.
	UT_Pack["NAME"] = "UNREALT";

--  Enter the path for where your sound files are loacted. 
	local soundPath = "Interface\\AddOns\\MKombat\\Sounds\\UT\\";

--  Played when the mob/player is at 20% health and/or 5 combo points are built up
	UT_Pack["FINISH_THEM"] = "Interface\\AddOns\\MKombat\\Sounds\\finishim.wav" 
	--you can use a specified path instead of the soundpath if you want, like above.

--  DEATH sounds, one is randomly played when you die.  You can add additional sounds by using 
--  the same format shown: table.insert( MKOMBAT_DEATH, soundPath .. "sound_file" );
	--table.insert( UT_Pack["MKOMBAT_DEATH"], soundPath .. "pathetic.wav" );
	--table.insert( UT_Pack["MKOMBAT_DEATH"], soundPath .. "URNTHING.wav" );
	--table.insert( UT_Pack["MKOMBAT_DEATH"], soundPath .. "WEAK.wav" );
	--table.insert( UT_Pack["MKOMBAT_DEATH"], soundPath .. "IOUS.wav" );

--  Played when TARGETS are detected. Either NPC, an enemy player, or duel request
	UT_Pack["ENEMY_HIGH_TARGET"] = soundPath .. " ";
	table.insert( UT_Pack["ENEMY_TARGET"], soundPath .. "prepare.wav" );

--  Played when CRITS are detected.  Currently it detects crits you do as well as others
	table.insert( UT_Pack["MKOMBAT_POSITIVE"], soundPath .. "holyshit.wav" );
	table.insert( UT_Pack["MKOMBAT_POSITIVE"], soundPath .. "wickedsick.wav" );

--  Played when DODGES are detected.
	--UT_Pack["MKOMBAT_HDODGE"] = soundPath .. " "; --hunter dodge
	--UT_Pack["MKOMBAT_DODGE"] = soundPath .. " "; --other classes dodge
	--UT_Pack["MKOMBAT_WTDODGE"] = soundPath .. " "; --warrior target dodge
	--UT_Pack["MKOMBAT_TDODGE"] = soundPath .. " "; --other classes target dodge

--  Played when PARRYS are detected.
	--UT_Pack["MKOMBAT_RPARRY"] = soundPath .. " " --rogue parry
	--UT_Pack["MKOMBAT_PARRY"] = soundPath .. " "; --other classes parry

--  Played when COMBO POINTS are detected. (5 combo point sound is same as "FINISH_THEM" wave above.)
	--UT_Pack["MKOMBAT_COMBO1"] = soundPath .. " "; --1 combo point
	--UT_Pack["MKOMBAT_COMBO2"] = soundPath .. " "; --2 combo points
	--UT_Pack["MKOMBAT_COMBO3"] = soundPath .. " "; --3 combo points
	--UT_Pack["MKOMBAT_COMBO4"] = soundPath .. " "; --4 combo points

--  COMBAT MUSIC, add or remove your music preferences
	table.insert( UT_Pack["MKOMBAT_COMBAT"], "Interface\\AddOns\\MKombat\\Sounds\\matrix.mp3" );
	table.insert( UT_Pack["MKOMBAT_COMBAT"], "Interface\\AddOns\\MKombat\\Sounds\\blade.mp3" );

--  Flawless victory, you were not damaged
	UT_Pack["FLAWLESS_WIN "]= soundPath .. "humiliation.wav";

--  Fatality - you killed the target after hearing the FINISH HIM sound
	UT_Pack["FATALITY"]     = soundPath .. "godlike.wav";

--  Brutality - You killed the target with a crit after hearing the FINISH HIM sound 
	UT_Pack["BRUTALITY"]    = soundPath .. "dominating.wav";

--  You killed your opponent
	UT_Pack["SUPURB_VICTORY"] = soundPath .. "unstoppable.wav";

--  Played when the AddOn is checked with "/mk"
	UT_Pack["WELCOME_LOADED"] = soundPath .. "firstblood.wav";

--  local variables for this sound pack
	local UT_KillCount = 0;
	local UT_OriginalChatFrame_OnEvent = nil;

--  You should define this function if you have any overrides or additions made in the added sound pack
	function UT_MKombat_OnEvent()
		if( event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
        		local index = string.find( arg1, " dies." );
        		if( not index ) then
            		return;
        		end
        		local value = string.sub( arg1, 0, index-1 );
        		-- if we have a name
        		if( value and value==lastTarget) then
				UT_KillCount = UT_KillCount + 1;
				MKombat_Msg("|cffff3333   KILLS IN A ROW : " .. UT_KillCount .. "\n");
				--now check our kill count
				if( UT_KillCount > 1 ) then
					if( UT_KilLCount > 2 ) then
						if( UT_KillCount > 3 ) then
							if( UT_KilLCount > 4 ) then
								if( UT_KilLCount > 5 ) then
									if( UT_KilLCount > 6 ) then --we killed 7 or more			
										MKombat_PlayFile( soundPath .. "ludicrouskill.wav" );
									else --we killed 6								
										MKombat_PlayFile( soundPath .. "ultrakill.wav" );
									end
								else --we killed 5								
									MKombat_PlayFile( soundPath .. "monsterkill.wav" );
								end
							else --we killed 4							
								MKombat_PlayFile( soundPath .. "multikill.wav" );
							end
						else --we killed 3						
							MKombat_PlayFile( soundPath .. "rampage.wav" );
						end
					else --we killed 2					
						MKombat_PlayFile( soundPath .. "killingspree.wav" );
					end
				end
        		end
		elseif( event == "PLAYER_DEAD") then --You suck		
			UT_KillCount = 0;
		end
	end

--  You should assign the function name as shown
	UT_Pack["OnEvent"] = UT_MKombat_OnEvent;

--  You can add additional OnLoad functionality here as well
--  Do this if you need to register for additional events for your custom sound pack
	function UT_MKombat_OnLoad()
		-- Hook the ChatFrame_OnEvent function
		UT_OriginalChatFrame_OnEvent = ChatFrame_OnEvent;
		ChatFrame_OnEvent = UT_MKombat_ChatFrame_OnEvent;
	end
	UT_Pack["OnLoad"] = UT_MKombat_OnLoad;

	function UT_MKombat_ChatFrame_OnEvent()
		UT_OriginalChatFrame_OnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
		if( event and (strsub(event, 1, 15) == "CHAT_MSG_COMBAT" or strsub(event, 1, 14) == "CHAT_MSG_SPELL") ) then
			if( arg1 == nil ) then
				arg1 = "nil";
			end
			local pattern = "Your Aimed Shot crits (.+) for (%d+)";
        		local s, e;
        		local results = { };
        		s, e, results[0], results[1], results[2], results[3], results[4] = string.find(arg1, pattern);
			if( results[0] ~= nil ) then
				MKombat_PlayFile( soundPath .. "headshot.wav" );
        		end
    		end
	end

--  Finally do an insert into the sound packs object
	table.insert( g_MKombat_Packs, UT_Pack );
