#pragma semicolon 1
#include <sourcemod>
#define PLUGIN_VERSION "0x01"

public Plugin:myinfo = {
    name = "Disable Spectator",
    author = "Chdata",
    description = "I'm writing plugins instead of studying for tests.",
    version = PLUGIN_VERSION,
    url = "http://steamcommunity.com/groups/tf2data"
};

public OnPluginStart()
{
    AddCommandListener(DoSuicide2, "jointeam");
}

public OnConfigsExecuted()
{
    SetConVarInt(FindConVar("mp_forcecamera"), 2); // cameraposition stays with dead person
}

public Action:DoSuicide2(client, const String:command[], argc)
{
	if (!(CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)))
	{
		if (argc == 1)
		{
			PrintToChatAll("[DEBUG] Client was checkeed if they are less than 2, and has no permission to spectate!", client);
			ChangeClientTeam(client, GetRandomInt(2, 3));
			PrintToChat(client, "[NoSpec] S-stop staring at me senpai!");
			return Plugin_Handled;
		}
	}
	else
	{
		ChangeClientTeam(client, 1);
	}
}