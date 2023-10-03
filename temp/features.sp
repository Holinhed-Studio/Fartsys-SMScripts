//Simple script setup
#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <regex>
#define TSF_VERSION "1.0.0"

//Give plugin info
public Plugin:myinfo =
{
	name		=	"Trade Server Features",
	author		=	"Tonybear5",
	description	=	"Shows client !features motd panel",
	version		=	"TSF_VERSION",
	url			=	"http://veterangiveaways.co.uk"
};

//Hook into server
public OnAllPluginsLoaded()
{
	RegConsoleCmd("sm_features", Command_Features);
}

//Show the client the features
public Action:Command_Features(client, args)
{
	ShowMOTDPanel(client, "Trade Server Features", "http://veterangiveaways.co.uk/showthread.php?tid=8&pid=10#pid10", MOTDPANEL_TYPE_URL);
}