//Simple script setup
#pragma semicolon 1

//include Sourcemod and SDK Tools
#include <sourcemod>
#include <sdktools>

//Booleans and convar definitions
bool:PrettifyChat    = true;
ConVar g_Prettify;
String:teamName1[5],
String:teamName2[5];

//Give plugin info
public Plugin:myinfo =
{
	name		=	"Mute Server Events",
	author		=	"Dovahkiin-Warrior",
	description	=	"Disable CVar broadcast",
	version		=	"1.0.0",
	url			=	"https://firehostredux.net"
};

public OnPluginStart()
{
	g_Prettify = CreateConVar("sm_silence_cvars", "1", " Prettify chat while chaos is active. 0/1 - On/off (Default: 1)"), //Create the convar that tells the below code whether or not to block cvar broadcasts
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre); //Hook the cvar change event
}

//Mute CVar changes if allowed
public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast) //On Cvar Change.....
{
	if(g_Prettify.BoolValue) //Check if sm_silence_cvars is 1...
	{
		event.BroadcastDisabled = true; //Disable broadcasting cvars if the above statement is indeed true
	}
	
	return Plugin_Continue; //Continue running the plugin
}

//Get the current Team names and print team list to Server chat & then to console
public OnMapStart()
{
	GetTeamName(2, teamName1, sizeof(teamName1));
	GetTeamName(3, teamName2, sizeof(teamName2));
	PrintToChatAll("\x079A769A [CVar Mute] Team Names: %s %s - Muting convar broadcasts: %s",	teamName1, teamName2, (PrettifyChat ? "yes" : "no")),
	PrintToServer("[CVar Mute] Team Names: %s %s - Muting convar broadcasts: %s",	teamName1, teamName2, (PrettifyChat ? "yes" : "no"));
}