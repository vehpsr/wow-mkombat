--[[
	Replace or add your own sound files to use a different set of sounds
]]--

--  Add a new pack if you use multiple sounds for an event
	local SW_Pack = {};
	SW_Pack["MKOMBAT_DEATH"] = {};
	SW_Pack["MKOMBAT_COMBAT"] = {};
	SW_Pack["MKOMBAT_POSITIVE"] = {};
	SW_Pack["ENEMY_TARGET"] = {};

--  Name the pack. "This" will be typed to load the pack.
	SW_Pack["NAME"] = "SWars";

--  Enter the path for where your sound files are loacted. 
	local soundPath = "Interface\\AddOns\\MKombat\\Sounds\\SW\\";

--  Played when the mob/player is at 20% health and/or 5 combo points are built up
	SW_Pack["FINISH_THEM"] = soundPath .. "Jawa.wav" 

--  DEATH sounds, one is randomly played when you die.  You can add additional sounds by using 
--  the same format shown: table.insert( MKOMBAT_DEATH, soundPath .. "sound_file" );
	table.insert( SW_Pack["MKOMBAT_DEATH"], soundPath .. "Jabba.wav" );
	table.insert( SW_Pack["MKOMBAT_DEATH"], soundPath .. "Palpatine.wav" );
	table.insert( SW_Pack["MKOMBAT_DEATH"], soundPath .. "Sebulba.wav" );
	table.insert( SW_Pack["MKOMBAT_DEATH"], soundPath .. "Crumb.wav" );

--  Played when TARGETS are detected. Either NPC, an enemy player, or duel request
	SW_Pack["ENEMY_HIGH_TARGET"] = soundPath .. "Alerted.wav";
	table.insert( SW_Pack["ENEMY_TARGET"], soundPath .. "Force.wav" );
	table.insert( SW_Pack["ENEMY_TARGET"], soundPath .. "Fire.wav" );
	table.insert( SW_Pack["ENEMY_TARGET"], soundPath .. "Kill.wav" );

--  Played when CRITS are detected.  Currently it detects crits you do as well as others
	table.insert( SW_Pack["MKOMBAT_POSITIVE"], soundPath .. "Chewbacca.wav" );
	table.insert( SW_Pack["MKOMBAT_POSITIVE"], soundPath .. "Yoda.wav" );
	table.insert( SW_Pack["MKOMBAT_POSITIVE"], soundPath .. "Boshuda.wav" );

--  Played when DODGES are detected.
	SW_Pack["MKOMBAT_HDODGE"] = soundPath .. "Bullseye.wav"; --hunter dodge
	SW_Pack["MKOMBAT_DODGE"] = soundPath .. "Blaster.wav"; --other classes dodge
	SW_Pack["MKOMBAT_WTDODGE"] = soundPath .. "Fuzzball.wav"; --warrior target dodge
	SW_Pack["MKOMBAT_TDODGE"] = soundPath .. "Can'tSee.wav"; --other classes target dodge

--  Played when PARRYS are detected.
	SW_Pack["MKOMBAT_RPARRY"] = soundPath .. "ComeHere.wav" --rogue parry
	SW_Pack["MKOMBAT_PARRY"] = soundPath .. "Gonk.wav"; --other classes parry

--  Played when COMBO POINTS are detected. (5 combo point sound is same as "FINISH_THEM" wave above.)
	SW_Pack["MKOMBAT_COMBO1"] = soundPath .. "R2-Combo1.wav"; --1 combo point
	SW_Pack["MKOMBAT_COMBO2"] = soundPath .. "R2-Combo2.wav"; --2 combo points
	SW_Pack["MKOMBAT_COMBO3"] = soundPath .. "R2-Combo3.wav"; --3 combo points
	SW_Pack["MKOMBAT_COMBO4"] = soundPath .. "R2-Combo4.wav"; --4 combo points

--  COMBAT MUSIC, add or remove your music preferences
	table.insert( SW_Pack["MKOMBAT_COMBAT"], soundPath .. "March.wav" );
	table.insert( SW_Pack["MKOMBAT_COMBAT"], soundPath .. "SW.wav" );

--  Flawless victory, you were not damaged
	SW_Pack["FLAWLESS_WIN "]= soundPath .. "Greedo.wav";

--  Fatality - you killed the target after hearing the FINISH HIM sound
	SW_Pack["FATALITY"]     = soundPath .. "Greatshot.wav";

--  Brutality - You killed the target with a crit after hearing the FINISH HIM sound 
	SW_Pack["BRUTALITY"]    = soundPath .. "Energy.wav";

--  You killed your opponent
	SW_Pack["SUPURB_VICTORY"] = soundPath .. "Hokey.wav";

--  Played when the AddOn is checked with "/mk"
	SW_Pack["WELCOME_LOADED"] = soundPath .. "ObiWan.wav";

--  local variables for this sound pack
	local SW_KillCount = 0;
	local SW_OriginalChatFrame_OnEvent = nil;

--  You should define this function if you have any overrides or additions made in the added sound pack
	function SW_MKombat_OnEvent()
		if( event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
        		local index = string.find( arg1, " dies." );
        		if( not index ) then
            		return;
        		end
        		local value = string.sub( arg1, 0, index-1 );
        		-- if we have a name
        		if( value and value==lastTarget) then
				SW_KillCount = SW_KillCount + 1;
				MKombat_Msg("|cffff3333   KILLS IN A ROW : " .. SW_KillCount .. "\n");
				--now check our kill count
				if( SW_KillCount > 1 ) then
					if( SW_KilLCount > 2 ) then
						if( SW_KillCount > 3 ) then
							if( SW_KilLCount > 4 ) then
								if( SW_KilLCount > 5 ) then
									if( SW_KilLCount > 6 ) then --we killed 7 or more			
										MKombat_PlayFile( soundPath .. "Madness.wav" );
									else --we killed 6								
										MKombat_PlayFile( soundPath .. "StopUs.wav" );
									end
								else --we killed 5								
									MKombat_PlayFile( soundPath .. "GreatDisturbance.wav" );
								end
							else --we killed 4							
								MKombat_PlayFile( soundPath .. "Station.wav" );
							end
						else --we killed 3						
							MKombat_PlayFile( soundPath .. "RebelFriends.wav" );
						end
					else --we killed 2					
						MKombat_PlayFile( soundPath .. "Scheduled.wav" );
					end
				end
        		end
		elseif( event == "PLAYER_DEAD") then --You suck		
			SW_KillCount = 0;
		end
	end

--  You should assign the function name as shown
	SW_Pack["OnEvent"] = SW_MKombat_OnEvent;

--  You can add additional OnLoad functionality here as well
--  Do this if you need to register for additional events for your custom sound pack
	function SW_MKombat_OnLoad()
		-- Hook the ChatFrame_OnEvent function
		SW_OriginalChatFrame_OnEvent = ChatFrame_OnEvent;
		ChatFrame_OnEvent = SW_MKombat_ChatFrame_OnEvent;
	end
	SW_Pack["OnLoad"] = SW_MKombat_OnLoad;

	function SW_MKombat_ChatFrame_OnEvent()
		SW_OriginalChatFrame_OnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
		if( event and (strsub(event, 1, 15) == "CHAT_MSG_COMBAT" or strsub(event, 1, 14) == "CHAT_MSG_SPELL") ) then
			if( arg1 == nil ) then
				arg1 = "nil";
			end
			local pattern = "Your Aimed Shot crits (.+) for (%d+)";
        		local s, e;
        		local results = { };
        		s, e, results[0], results[1], results[2], results[3], results[4] = string.find(arg1, pattern);
			if( results[0] ~= nil ) then
				MKombat_PlayFile( soundPath .. "TuskenRaider.wav" );
        		end
    		end
	end

--  Finally do an insert into the sound packs object
	table.insert( g_MKombat_Packs, SW_Pack );
