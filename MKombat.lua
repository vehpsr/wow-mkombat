local version = "20006";
local finishHim = false;
local lastMusicPlay = 0;
local songTimeout = 300; -- this is in seconds, change this to lower number to play music more often
local mobCount = 0;
local dance = false;

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
    this:RegisterEvent("UNIT_HEALTH");
    this:RegisterEvent("PLAYER_REGEN_DISABLED");
    this:RegisterEvent("PLAYER_TARGET_CHANGED");
    this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent( "VARIABLES_LOADED" );

    MKombat_OriginalChatFrame_OnEvent = ChatFrame_OnEvent;
    ChatFrame_OnEvent = MKombat_ChatFrame_OnEvent;

    -- Register a slash command
    SLASH_MKombatCMD1 = "/mkombat";
    SlashCmdList["MKombatCMD"] = MKombat_Command;
end

function SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,amount, school, resisted, blocked, absorbed, critical, glancing, crushing)
    if (srcName == UnitName("player") and critical) then
        MKombat_PlayRandom( "MKOMBAT_POSITIVE" );
    end
end

function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,spellId, spellName, spellSchool, amount, school, resisted, blocked, absorbed, critical, glancing, crushing)
    SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,amount, school, resisted, blocked, absorbed, critical, glancing, crushing);
end

function SpellHeal(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,spellId, spellName, spellSchool, amount, overheal,critical)
    if (srcName == UnitName("player") and critical) then
        if (math.random(1, 4) == 1) then
            MKombat_Play("holyshit.wav");
        else
            MKombat_PlayRandom( "MKOMBAT_POSITIVE" );
        end
    end
end

function MKombat_OnEvent()
    if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        if (arg2 == "SWING_DAMAGE") then
            SwingDamage(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16);
        elseif (arg2 == "RANGE_DAMAGE" or arg2 == "SPELL_DAMAGE") then
            SpellDamage(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18);
        elseif (arg2 == "SPELL_HEAL") then
            if (arg13 == 1 and not arg14) then -- Elsia: Heuristic for detection 2.4 format. Fails if overheal is exactly 1 and the heal was not a crit (WotLK).
                SpellHeal(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,1);
            end
            if (arg14) then
                SpellHeal(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14);
            end
        elseif (arg2 == "UNIT_DIED" or arg2 == "UNIT_DESTROYED") then
            mobCount = mobCount + 1;
            if (mobCount == 1) then
                MKombat_Play("firstblood.wav");
            else
                if (math.random(1, 4) == 1) then
                    MKombat_PlayRandom( "MKOMBAT_WIN" );
                end
                MKombat_Msg("|cff33ffff MKombat mob count: " .. mobCount);
            end
        end
    elseif (event == "PLAYER_ENTERING_WORLD") then
        MKombat_Msg("|cff33ffff MKombat Nazarbaev-beta loaded!" );
    elseif( event == "UNIT_HEALTH") then
        if (arg1 ~= "target" or not UnitName("target") or healthFinishHim or UnitHealth("target") < 1) then
            return;
        end
        if (UnitHealth("target") < UnitHealthMax("target") / 21) then
            MKombat_Play("finishim.wav");
            healthFinishHim = true;
        end
    elseif( event == "PLAYER_DEAD") then
        MKombat_PlayRandom( "MKOMBAT_DEATH" ); -- You suck
    elseif (event == "PLAYER_TARGET_CHANGED") then
        healthFinishHim = false;
        if( UnitName("target") and UnitIsEnemy("player", "target") and UnitHealth("target") > 0) then
            if (math.random(1, 4) == 1) then
                MKombat_PlayRandom( "ENEMY_TARGET" );
            end
        end
    elseif (event == "DUEL_REQUESTED") then
        MKombat_PlayRandom( "ENEMY_TARGET" );
    elseif( event == "PLAYER_REGEN_DISABLED") then
        if( UnitName("target") and UnitIsEnemy("player", "target") and UnitHealth("target") > 0) then
            if(dance and (GetTime() - lastMusicPlay > songTimeout) ) then
                MKombat_PlayRandom( "MKOMBAT_COMBAT" ); -- Combat music
                lastMusicPlay = GetTime();
            end
        end
    elseif( event == "VARIABLES_LOADED" ) then
        if( g_MKombat_Packs[MK_CurrentPack]["OnLoad"] ~= nil ) then
            g_MKombat_Packs[MK_CurrentPack]["OnLoad"]();
        end
    end
    if( g_MKombat_Packs[MK_CurrentPack]["OnEvent"] ~= nil ) then
        g_MKombat_Packs[MK_CurrentPack]["OnEvent"]( event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
    end
end

function MKombat_ChatFrame_OnEvent()
    MKombat_OriginalChatFrame_OnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
end

function MKombat_Play(file)
    PlaySoundFile( "Interface\\AddOns\\MKombat\\Sounds\\MK\\" .. file );
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

    if( string.lower( param1 ) == "enable" ) then
        MKombat_SetEnabled( true );
        MKombat_Msg("|cff33ffff MKombat enabled" );
    elseif( string.lower( param1 ) == "disable" ) then
        MKombat_SetEnabled( false );
        MKombat_Msg("|cff33ffff MKombat disabled" );
    elseif(string.lower(param1) == "dance" ) then
        local danceMsg = "";
        if (dance) then
            dance = false;
            danceMsg = "dance is off";
        else
            dance = true;
            danceMsg = "let's dance!";
        end
        MKombat_Msg("|cff33ffff MKombat " .. danceMsg);
    else
        MKombat_DisplayUsage();
    end
end

function MKombat_SetEnabled( enabled )
    MKombat_Enabled = enabled;
end

function MKombat_DisplayUsage()
    MKombat_PlayFile( g_MKombat_Packs[MK_CurrentPack]["WELCOME_LOADED"] );
    MKombat_Msg("|cff33ffff Usage:  /MKombat");
    MKombat_Msg("|cff33ffff  /MKombat disable - Disable MKombat sound engine and sound effects");
    MKombat_Msg("|cff33ffff  /MKombat enable - Enable MKombat sound engine and sound effects");
    MKombat_Msg("|cff33ffff  /MKombat dance - Turn on/off combat dance (disabled by default)");
end
