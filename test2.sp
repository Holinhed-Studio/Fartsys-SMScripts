#pragma semicolon 1
#define PLUGIN_AUTHOR "DovahkiWarrior"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <geoip>

char ReserveTempID[64];

public Plugin:myinfo = 
{
	name = "Connect Message", 
	author = PLUGIN_AUTHOR, 
	description = "When a player connects a message appears with their information", 
	version = PLUGIN_VERSION, 
	url = ""
};

public void OnPluginStart()
{
}

public void OnClientPostAdminCheck(client)
{
	char name[32],authid[64];
	GetClientName(client, name, sizeof(name));
	GetClientAuthId(client, AuthId_SteamID64, authid, sizeof(authid));
	if (StrEqual(authid, ReserveTempID))
	{
		PrintToChatAll("\x01\x04%s\x01 (\x05%s\x01) \x0700AA00reconnected\x07AAAAAA.", name, authid);
		PrintToServer("\x01\x04%s\x01 (\x05%s\x01) \x0700AA00reconnected\x07AAAAAA.", name, authid);
	}
	else
	{
		PrintToChatAll("\x01\x04%s\x01 (\x05%s\x01) \x0700AA00connected\x07AAAAAA.", name, authid);
		PrintToServer("\x01\x04 %s \x01(\x05%s\x01) \x0700AA00connected\x07AAAAAA.", name, authid);
	}
}

public void OnClientDisconnect(client)
{
	char name[32],authid[64];
	GetClientName(client, name, sizeof(name));
	GetClientAuthId(client, AuthId_SteamID64, authid, sizeof(authid));
	ReserveTempID = authid;
	new DisconnectedTeam = GetClientTeam(client);
	if (DisconnectedTeam == 3)
	{
		for (new tclient=1; tclient<=MaxClients; tclient++)
		{
			if (IsClientInGame(tclient))
			{
				new TeamCheck = GetClientTeam(tclient);
				if (!(TeamCheck == 3))
				{
					PrintToChat(tclient, "\x0700AAAA %s \x01(\x05%s\x01) \x0700AAAAdisconnected.", name, authid);
				}
			
				else if (TeamCheck == 3)
				{
					PrintToChat(tclient, "\x0700AAAA %s \x01(\x05%s\x05) \x0700AAAAdisconnected.", name, authid);
				}
			}
		}
	}
	else
	{
		for (new tclient=1; tclient<=MaxClients; tclient++)
		{
			if (IsClientInGame(tclient))
			{
				new TeamCheck = GetClientTeam(tclient);
				if (!(TeamCheck == 3))
				{
					PrintToChat(tclient, "\x07AA0000 %s \x01(\x05%s\x01) \x07AA0000disconnected.", name, authid);
				}
			
				else if (TeamCheck == 3)
				{
					PrintToChat(tclient, "\x07AA0000 %s \x01(\x05%s\x05) \x07AA0000disconnected.", name, authid);
				}
			}
		}
	}
}