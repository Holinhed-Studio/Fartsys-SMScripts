//Simple script setup
#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <regex>
#define CFGS_VERSION "1.1.0"

//Give plugin info
public Plugin:myinfo =
{
	name		=	"Pure Chaos",
	author		=	"Tonybear5",
	description	=	"Execute cvar configs in sync with song when command run.",
	version		=	"CFGS_VERSION",
	url			=	"http://veterangiveaways.co.uk"
};

//Initiate the engine
public OnPluginStart()
{	
	RegAdminCmd("sm_chaos", Command_Chaos, ADMFLAG_ROOT, "60 Seconds of Pure Chaos");
	PrecacheSound("chaos/warn.mp3", true),
    AddFileToDownloadsTable("sound/chaos/warn.mp3"),
	PrecacheSound("chaos/theme.mp3", true),
	AddFileToDownloadsTable("sound/chaos/theme.mp3");
}
	
//Execute the Command and inform the server that true chaos is about to spawn
public Action:Command_Chaos(client, args)
{
	PrintCenterTextAll("GET READY FOR PURE CHAOS....."),
	EmitSoundToAll("chaos/warn.mp3", client),
	CreateTimer(3.0, Command_ChaosStart);
}

//Begin the chaos
public Action:Command_ChaosStart(Handle timer)
{
	PrintToChatAll("A user has initiated two minutes of pure chaos... There will be many waves, prepare for absolute chaos and potential crashes!"),
	EmitSoundToAll("chaos/theme.mp3"),
	CreateTimer(13.60, Command_Chaos1);
}

/*
* This is the configuration timing, feel free to edit if this is either lasting too long
* or doesn't fit your needs. You may also change the path to the configurations or you
* may change the events that occur when these timers fire.
*/


//Execute the First Config
public Action:Command_Chaos1(Handle timer)
{
	ServerCommand("exec sourcemod/chaos/1.cfg"),
	CreateTimer(40.0, Command_Chaos2);
}

//Execute the Second Config
public Action:Command_Chaos2(Handle timer)
{
	ServerCommand("exec sourcemod/chaos/2.cfg"),
	CreateTimer(25.40, Command_Chaos3);
}

//Execute the Third Config
public Action:Command_Chaos3(Handle timer)
{
	ServerCommand("exec sourcemod/chaos/3.cfg"),
	CreateTimer(25.50, Command_Chaos4);
}

//Execute the Fourth Config
public Action:Command_Chaos4(Handle timer)
{
	ServerCommand("exec sourcemod/chaos/4.cfg"),
	CreateTimer(25.50, Command_ChaosFinal);
}

//Execute the Final Config
public Action:Command_ChaosFinal(Handle timer)
{
	ServerCommand("exec sourcemod/chaos/5.cfg"),
	PrintCenterTextAll("The chaos has settled.."),
	EmitSoundToAll("player/taunt_sfx_bell_single.wav");
}