--[[
	Mortal Kombat sound mod - aka MKombat
	Written by Rollie of Bloodscalp

	Will play various sound effects during PVP combat (as well as some PVE sound effects)
	
	You can modify some of the values to change the behavior.
]]--

local version = "20000";
local lastTarget = "";
local tookDamage = false;
local finishHim = false;
local healthFinishHim = false;
local blewit = false;
local critLastHit = false;
local lastMusicPlay = 0;
local lastPraisePlay = 0;
local songTimeout = 300;  --  this is in seconds, change this to lower number to play music more often
local praiseTimeout = 30;
MK_CurrentPack = 1;
local newPack = 1;
local MKombatDebug = false;
local MKombat_OriginalChatFrame_OnEvent = nil;
local MKombat_Enabled = true;

g_MKombat_Packs = {};

MKombat_Vars = {};

function MKombat_Msg(msg)
    if( DEFAULT_CHAT_FRAME ) then
        DEFAULT_CHAT_FRAME:AddMessage(msg);
    end
end


function MKombat_OnLoad()
	this:RegisterEvent("PLAYER_DEAD");
	this:RegisterEvent("DUEL_REQUESTED");
	this:RegisterEvent("UNIT_COMBO_POINTS");	
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");
	
	this:RegisterEvent( "ZONE_CHANGED_NEW_AREA" );
	
	this:RegisterEvent( "VARIABLES_LOADED" );
	
	MKombat_OriginalChatFrame_OnEvent = ChatFrame_OnEvent;
	ChatFrame_OnEvent = MKombat_ChatFrame_OnEvent;
	
	
	--
	-- Register a slash command
	--
	SLASH_MKombatCMD1 = "/mkombat";
	SlashCmdList["MKombatCMD"] = MKombat_Command;
	
	
	MKombat_Msg("|cff33ffff MKombat v" .. version .. " loaded!" );
	
end

function MKombat_OnEvent()
	if( event == "UNIT_HEALTH") then
		if( arg1 == "target" and UnitHealth("target") < 21 and UnitHealth("target") > 0 and not healthFinishHim ) then
	        if( UnitName("target") ) then
      			--  PLAY FINISH HIM!!!
				MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack]["FINISH_THEM"] );
				healthFinishHim = true;
			end
		end
	elseif( event == "PLAYER_DEAD") then
		--  You suck
		MKombat_PlayRandom( "MKOMBAT_DEATH" ); 
		
    elseif (event == "PLAYER_TARGET_CHANGED") then
        -- initialize if we're not for some reason
        -- if we have a vaild target, its a player, and its an enemy
        healthFinishHim = false;
        if( UnitName("target") and UnitIsPlayer("target") and UnitIsEnemy("player", "target") and UnitHealth("target") > 0) then
            finishHim = false;
            healthFinishHim = false;
            tookDamage = false;
			healthOneShot = false;
            blewit = false;
            lastTarget = UnitName("target");
			MKombat_PlayRandom( "ENEMY_TARGET" );
	    end
	    
	elseif( event == "PLAYER_REGEN_ENABLED") then
		finishHim = false;
		healthFinishHim = false;
		healthOneShot = false;
		StopMusic();
		
	elseif( event == "UNIT_COMBAT") then
		if( arg1 == "player" and arg2=="WOUND") then
			--  we took damage
			tookDamage = true;
			if( arg3 == "CRITICAL" ) then
				--  we got critted 
				
			end
		elseif( arg1 == "target" and arg2=="WOUND" ) then
			if( healthFinishHim ) then
				--  we hit him
				healthOneShot = true;
			elseif( healthOneShot ) then
				blewit = true;
			end
			
			if( critLastHit ) then
				critLastHit = false;
			end
		end
		
		
      	if( GetComboPoints("Player") == 5 and not finishHim) then
      		--  PLAY FINISH HIM!!!
			MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack]["MKOMBAT_RPARRY"] );
			finishHim = true;
		elseif( GetComboPoints("Player") ~= 5 and finishHim) then
			finishHim = false;
      	end		
      	
	elseif( event == "PLAYER_REGEN_DISABLED") then
		critLastHit = false;
        if( UnitName("target") and UnitIsPlayer("target") and UnitIsEnemy("player", "target") and UnitHealth("target") > 0) then
            finishHim = false;
            healthFinishHim = false;
            healthOneShot = false;
            blewit = false;
            if( GetTime() - lastMusicPlay > songTimeout ) then
				--  Combat music
				MKombat_PlayRandom( "MKOMBAT_COMBAT" ); 
				lastMusicPlay = GetTime();
			end
	    end
	    
	elseif( event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
        local index = string.find( arg1, " dies." );
        if( not index ) then
            return;
        end
        local value = string.sub( arg1, 0, index-1 );
        -- if we have a name
        if( value and value==lastTarget) then
			if( not tookDamage ) then
				MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack]["FLAWLESS_WIN"] );
			elseif( finishHim and not blewit ) then
				MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack]["FATALITY"] );
			elseif( critLastHit ) then
				MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack]["BRUTALITY"] );
			else
				MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack]["SUPURB_VICTORY"] );
			end
        end
    elseif( event == "ZONE_CHANGED_NEW_AREA" ) then
		local ZoneName = GetRealZoneText();
		if( ZoneName ~= nil and ZoneName == "Un'Goro Crater" and MKombat_Vars["lotl"] ~= "disable" ) then
		    MKombat_Msg("|cffff3333 Land of the Lost theme song brought to you by MKombat sound mod!  You can disable it by typing /mkombat lotl disable, or enable to turn it on");
			MKombat_PlayFile( "Interface\\AddOns\\MKombat\\Sounds\\lotl.mp3" );
		end
    elseif( event == "VARIABLES_LOADED" ) then
		--
		--  Load the primay pack
		--
		if( g_MKombat_Packs[MK_CurrentPack]["OnLoad"] ~= nil ) then
			g_MKombat_Packs[MK_CurrentPack]["OnLoad"]();
		end
	end
	
	--
	--  Call the sound pack's override for the OnEvent
	--
	if( g_MKombat_Packs[MK_CurrentPack]["OnEvent"] ~= nil ) then
		g_MKombat_Packs[MK_CurrentPack]["OnEvent"]( event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
	end

end

function MKombat_ChatFrame_OnEvent()

	MKombat_OriginalChatFrame_OnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
	
    if( event and (strsub(event, 1, 15) == "CHAT_MSG_COMBAT" or strsub(event, 1, 14) == "CHAT_MSG_SPELL") ) then
		if( arg1 == nil ) then
			arg1 = "nil";
		end

		local pattern = "Your (.+) crits (.+) for (%d+)";
        local s, e;
        local results = { };
        s, e, results[0], results[1], results[2], results[3], results[4] = string.find(arg1, pattern);
		if( results[0] ~= nil ) then
			critLastHit = true;
			--  we critted 
			if( GetTime() - lastPraisePlay > praiseTimeout ) then
				MKombat_PlayRandom( "MKOMBAT_POSITIVE" ); 
				lastPraisePlay = GetTime();
			end			
        end
    end
end

function MKombat_PlayRandom( pack )
	if( table.getn( g_MKombat_Packs[MK_CurrentPack][pack] ) ~= 0 ) then
		local randomNum = math.random(1, table.getn( g_MKombat_Packs[MK_CurrentPack][pack] ) ); 
		MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack][pack][randomNum] );
	end
end

function MKombat_PlayFile( file )
	if( MKombat_Enabled == true ) then
		if( file ~= nil ) then
			PlaySoundFile( file );
		elseif( MKombatDebug == true ) then
			MKombat_Msg("|cff33ffff MKombat => Got nil for sound effect file name, did not play");
		end
	end
end

function MKombat_Command( param1 )
    local  firsti, lasti, command, value = string.find (param1, "(%w+) (%w+)") ;

	if( string.lower( param1 ) == "list" ) then
		MKombat_ListPacks();
	elseif( string.lower( param1 ) == "enable" ) then
		MKombat_SetEnabled( true );
		MKombat_Msg("|cff33ffff MKombat enabled" );
	elseif( string.lower( param1 ) == "disable" ) then
		MKombat_SetEnabled( false );
		MKombat_Msg("|cff33ffff MKombat disabled" );
	elseif( command ~= nil and string.lower(command) == "load" ) then
		if( value ~= nil ) then
			MKombat_LoadPack( string.lower( value ) );
		else
		    MKombat_Msg("|cffff3333 MKombat Error =>  You must enter a packname to load");
		end
	elseif( command ~= nil and string.lower(command) == "debug" ) then
		if( value ~= nil ) then
			MKombatDebug = string.lower( value );
		    MKombat_Msg("|cff33ffff MKombat Debug set to " .. MKombatDebug);
		else
		    MKombat_Msg("|cffff3333 MKombat Error =>  You must enter either true or false after debug");
		end
	elseif( command ~= nil and string.lower(command) == "lotl" ) then
		if( value ~= nil and (string.lower(value) == "disable" or string.lower(value)=="enable")) then
			MKombat_Vars["lotl"] = string.lower(value);
		    MKombat_Msg("|cffff3333 MKombat Land of the Lost music set to : " .. string.lower(value));
		else
		    MKombat_Msg("|cffff3333 MKombat Error =>  Correct syntax is /mkombat lotl enable|disable");
		end
	else
	
		MKombat_DisplayUsage();
	end
end

function MKombat_SetEnabled( enabled )
	MKombat_Enabled = enabled;
end

function MKombat_DisplayUsage() 
	MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack]["WELCOME_LOADED"] );

    MKombat_Msg("|cff33ffff Usage:\n  /MKombat \n");
    MKombat_Msg("|cff33ffff   /MKombat list - Display list of sound packs\n");
    MKombat_Msg("|cff33ffff   /MKombat load @pack - Load the sound pack stated in @pack\n");
    MKombat_Msg("|cff33ffff   /MKombat disable - Disable the MKombat sound engine and sound effects\n");
    MKombat_Msg("|cff33ffff   /MKombat enable - Enable the MKombat sound engine and sound effects\n");
    
end

function MKombat_ListPacks()
	table.foreachi( g_MKombat_Packs, MKombat_ListPack );
end

function MKombat_ListPack( key, value )
	MKombat_Msg("|cff33ffff   MKombat Sound Pack #" .. key .. " : " .. value["NAME"] .. "\n");
end


function MKombat_LoadPack( pack )
	MKombat_Msg("|cff33ffff   Loading packs : " .. pack .. "\n");

	if( pack ~= nil ) then
		--  need to look for this pack
		newPack = pack;
		local newPackToBe = table.foreachi( g_MKombat_Packs, MKombat_FindPack );
		if( newPackToBe ~= nil ) then
			MK_CurrentPack = newPackToBe;
			MKombat_Msg("|cff33ffff   Loaded new sound pack : " .. pack .. "\n");
			--
			--  Load the primay pack
			--
			if( g_MKombat_Packs[MK_CurrentPack]["OnLoad"] ~= nil ) then
				g_MKombat_Packs[MK_CurrentPack]["OnLoad"]();
			end
		end
	end
end

function MKombat_FindPack( key, value )
	if( value == nil ) then
		value = "nil";
	end
	if( key == nil ) then
		key = "nil";
	end
	
	if( string.lower( value["NAME"] ) == string.lower( newPack ) ) then
		return key;
	else
		return nil;
	end
end

function MKombat_IsUsable(spell)
	local i,done,name,texture,realtexture,id=1,false;
	while (not done) do
		name = GetSpellName(i,BOOKTYPE_SPELL);
		texture = GetSpellTexture(i,BOOKTYPE_SPELL);
		if (not name) then
			done=true;
		elseif (name == spell) then
			id = i;
			realtexture = texture;
		end
		i = i+1;
	end
	if ( id ) then
		for j=1,120, 1 do
			if ( HasAction(j) ) then
				local actiontexture = GetActionTexture(j);
				if ( actiontexture == realtexture ) then
					local isUsable, notEnoughMana = IsUsableAction(j);
					if ( isUsable == 1 ) then
						return true;
					else
						return false;
					end
				end
			end			
		end
	end
end
