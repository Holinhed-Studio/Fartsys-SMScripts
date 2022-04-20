#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
new bool:sndJeffy = false;
char ReserveTempID[64];

public Plugin:myinfo =
{
	name = "League of Legends Handler",
	description = "Helper module for the League of Fortress game mode",
	author = "DovahkiWarrior",
	version = "1.0.0",
	url = "https://forums.firehostredux.net"
}
public OnPluginStart()
{
	new String:overlays_file[64];
	Format(overlays_file,sizeof(overlays_file),"overlays/league/rift.vtf");
	PrecacheDecal(overlays_file,true);
	AddFileToDownloadsTable("materials/overlays/league/rift.vtf");
	PrecacheDecal(overlays_file,true);
	AddFileToDownloadsTable("materials/overlays/league/riftred.vtf");
	PrecacheDecal(overlays_file,true);
	AddFileToDownloadsTable("materials/overlays/league/riftblue.vtf");
	Format(overlays_file,sizeof(overlays_file),"overlays/league/rift.vmt");
	PrecacheDecal(overlays_file,true);
	AddFileToDownloadsTable("materials/overlays/league/rift.vmt");
	Format(overlays_file,sizeof(overlays_file),"overlays/league/riftred.vmt");
	PrecacheDecal(overlays_file,true);
	AddFileToDownloadsTable("materials/overlays/league/riftred.vmt");
	Format(overlays_file,sizeof(overlays_file),"overlays/league/riftblue.vmt");
	PrecacheDecal(overlays_file,true);
	AddFileToDownloadsTable("materials/overlays/league/riftblue.vmt");
	PrecacheSound("vo/league/summonerreconnect.mp3", true);
	PrecacheSound("vo/jeffy/league/summonerreconnect.mp3", true);
	PrecacheSound("vo/league/enemydisconnected.mp3", true);
	PrecacheSound("vo/jeffy/league/enemydisconnected.mp3", true);
	PrecacheSound("vo/league/allydisconnected.mp3", true);
	PrecacheSound("vo/jeffy/league/allydisconnected.mp3", true);
	AddFileToDownloadsTable("sound/vo/league/summonerreconnect.mp3");
	AddFileToDownloadsTable("sound/vo/jeffy/league/summonerreconnect.mp3");
	AddFileToDownloadsTable("sound/vo/league/enemydisconnected.mp3");
	AddFileToDownloadsTable("sound/vo/jeffy/league/enemydisconnected.mp3");
	AddFileToDownloadsTable("sound/vo/league/allydisconnected.mp3");
	AddFileToDownloadsTable("sound/vo/jeffy/league/allydisconnected.mp3");
	
	RegAdminCmd("lol_alertriftblue", Command_AlertRiftBlue, ADMFLAG_ROOT, "Alert red that blue has summoned the rift herald");
	RegAdminCmd("lol_alertriftred", Command_AlertRiftRed, ADMFLAG_ROOT, "Alert blue that red has summoned the rift herald");
	RegAdminCmd("lol_bluetakerift", Command_BlueTakeRift, ADMFLAG_ROOT, "Alert that blue has slain the rift herald");
	RegAdminCmd("lol_redtakerift", Command_RedTakeRift, ADMFLAG_ROOT, "Alert that blue has slain the rift herald");
	RegAdminCmd("lol_riftslain", Command_RiftSlain, ADMFLAG_ROOT, "Alert that the rift herald has been slain");
	RegAdminCmd("lol_slainbyrift", Command_SlainByRift, ADMFLAG_ROOT, "Alert that the rift herald has slain");
	RegAdminCmd("lol_stormed", Command_Stormed, ADMFLAG_ROOT, "Alert that the player has been struck down");
	RegAdminCmd("lol_redturretdestroyed", Command_RedTurretDestroyed, ADMFLAG_ROOT, "Alert that red turret is destroyed");
	RegAdminCmd("lol_blueturretdestroyed", Command_BlueTurretDestroyed, ADMFLAG_ROOT, "Alert that blue turret is destroyed");
	RegAdminCmd("lol_redinhibdes", Command_RedInhibDestroyed, ADMFLAG_ROOT, "Alert that red inhibitor is destroyed");
	RegAdminCmd("lol_blueinhibdes", Command_BlueInhibDestroyed, ADMFLAG_ROOT, "Alert that blue inhibitor is destroyed");
	RegAdminCmd("lol_redinhibressoon", Command_RedInhibRessoon, ADMFLAG_ROOT, "Alert that red inhibitor is respawning soon");
	RegAdminCmd("lol_blueinhibressoon", Command_BlueInhibRessoon, ADMFLAG_ROOT, "Alert that blue inhibitor is respawning soon");
	RegAdminCmd("lol_redinhibres", Command_RedInhibRes, ADMFLAG_ROOT, "Alert that red inhibitor is respawned");
	RegAdminCmd("lol_blueinhibres", Command_BlueInhibRes, ADMFLAG_ROOT, "Alert that blue inhibitor is respawned");
	RegAdminCmd("lh_jeffy", Command_LHJeffy, ADMFLAG_ROOT, "Notify CM that jeffy's sounds are to be used.");
	RegAdminCmd("lol_karthusult", Command_Requiem, ADMFLAG_ROOT, "Karthus Ult!");
	RegAdminCmd("lol_grompkspree", Command_GKSpree, ADMFLAG_ROOT, "Gromp is on a killing spree.");
}

//Inform CM that we're using Jeffy's sounds
public Action:Command_LHJeffy(client, args)
{
	sndJeffy = true;
}

public OnMapStart()
{
	UnlockConsoleCommandAndConvar("r_screenoverlay");
}

//UnlockConsoleCommandAndConvar by AtomicStryker, http://forums.alliedmods.net/showpost.php?p=1318884&postcount=7
UnlockConsoleCommandAndConvar(const String:command[])
{
    new flags = GetCommandFlags(command);
    if (flags != INVALID_FCVAR_FLAGS)
    {
        SetCommandFlags(command, flags & ~FCVAR_CHEAT);
    }
    
    new Handle:cvar = FindConVar(command);
    if (cvar != INVALID_HANDLE)
    {
        flags = GetConVarFlags(cvar);
        SetConVarFlags(cvar, flags & ~FCVAR_CHEAT);
    }
}

//Connect and Disconnect Notifications
public void OnClientPostAdminCheck(client)
{
	char name[32],authid[64];
	GetClientName(client, name, sizeof(name));
	GetClientAuthId(client, AuthId_SteamID64, authid, sizeof(authid));
	if (StrEqual(authid, ReserveTempID))
	{
		PrintToChatAll("\x01\x04%s\x01 (\x05%s\x01) \x0700AA00reconnected\x07AAAAAA.", name, authid);
		PrintToServer("\x01\x04%s\x01 (\x05%s\x01) \x0700AA00reconnected\x07AAAAAA.", name, authid);
		if (sndJeffy == false)
		{
			EmitSoundToAll("vo/league/summonerreconnect.mp3");
			EmitSoundToAll("vo/league/summonerreconnect.mp3");
		}
		else
		{
			EmitSoundToAll("vo/jeffy/league/summonerreconnect.mp3");
			EmitSoundToAll("vo/jeffy/league/summonerreconnect.mp3");
		}
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
					if (sndJeffy == false)
					{
						EmitSoundToClient(tclient, "vo/league/enemydisconnected.mp3");
						EmitSoundToClient(tclient, "vo/league/enemydisconnected.mp3");
					}
					else
					{
						EmitSoundToClient(tclient, "vo/jeffy/league/enemydisconnected.mp3");
						EmitSoundToClient(tclient, "vo/jeffy/league/enemydisconnected.mp3");
						EmitSound
					}
				}
			
				else if (TeamCheck == 3)
				{
					PrintToChat(tclient, "\x0700AAAA %s \x01(\x05%s\x05) \x0700AAAAdisconnected.", name, authid);
					if (sndJeffy == false)
					{
						EmitSoundToClient(tclient, "vo/league/allydisconnected.mp3");
						EmitSoundToClient(tclient, "vo/league/allydisconnected.mp3");
					}
					else
					{
						EmitSoundToClient(tclient, "vo/jeffy/league/allydisconnected.mp3");
						EmitSoundToClient(tclient, "vo/jeffy/league/allydisconnected.mp3");
					}
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
					if (sndJeffy == false)
					{
						EmitSoundToClient(tclient, "vo/league/allydisconnected.mp3");
						EmitSoundToClient(tclient, "vo/league/allydisconnected.mp3");
					}
					else
					{
						EmitSoundToClient(tclient, "vo/jeffy/league/allydisconnected.mp3");
						EmitSoundToClient(tclient, "vo/jeffy/league/allydisconnected.mp3");
					}
				}
			
				else if (TeamCheck == 3)
				{
					PrintToChat(tclient, "\x07AA0000 %s \x01(\x05%s\x05) \x07AA0000disconnected.", name, authid);
					if (sndJeffy == false)
					{
						EmitSoundToClient(tclient, "vo/league/enemydisconnected.mp3");
						EmitSoundToClient(tclient, "vo/league/enemydisconnected.mp3");
					}
					else
					{
						EmitSoundToClient(tclient, "vo/jeffy/league/enemydisconnected.mp3");
						EmitSoundToClient(tclient, "vo/jeffy/league/enemydisconnected.mp3");
					}
				}
			}
		}
	}
}

public Action:Command_AlertRiftBlue(client, args)
{
	ClearScreen();
	ShowAlertBlue();	
}

public Action:Command_AlertRiftRed(client, args)
{
	ClearScreen();
	ShowAlertRed();	
}

public ClearScreen()
{
	for (new client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			ClientCommand(client, "r_screenoverlay \"/\"");
		}
	}
}

public ShowAlertBlue()
{
	for (new client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (TeamCheck == 3)
			{
				ClientCommand(client, "r_screenoverlay \"overlays/league/rift.vtf\""),
				PrintToChat(client, "\x0700AAAA[Your Team] \x07AAAAAAhas summoned the \x07AA00AARIFT HERALD!!!"),
				CreateTimer(3.0, TimedClear);
			}
			
			else
			{
				ClientCommand(client, "r_screenoverlay \"overlays/league/riftblue.vtf\""),
				PrintToChat(client, "\x07AA0000[Enemy Team] \x07AAAAAAhas summoned the \x07AA00AARIFT HERALD!!!"),
				CreateTimer(3.0, TimedClear);
			}
		}
	}
}

public ShowAlertRed()
{
	for (new client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				ClientCommand(client, "r_screenoverlay \"overlays/league/rift.vtf\""),
				PrintToChat(client, "\x07AA0000[Enemy Team] \x07AAAAAAhas summoned the \x07AA00AARIFT HERALD!!!"),
				CreateTimer(3.0, TimedClear);
			}
			
			else if (TeamCheck == 3)
			{
				ClientCommand(client, "r_screenoverlay \"overlays/league/riftred.vtf\""),
				PrintToChatAll("\x0700AAAA[Your Team] \x07AAAAAAhas summoned the \x07AA00AARIFT HERALD!!!"),
				CreateTimer(3.0, TimedClear);
			}
		}
	}
}

public Action:TimedClear(Handle:timer)
{
	ClearScreen();
}

public Action:Command_BlueTakeRift(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x0700AAAA[Enemy Team] \x07AAAAAAhas taken the \x07AA00AAEye of The Herald!");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x0700AAAA[Your Team] \x07AAAAAAhas taken the \x07AA00AAEye of The Herald!");
			}
		}
	}
}

public Action:Command_RedTakeRift(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x07AA0000[Your Team] \x07AAAAAAhas taken the \x07AA00AAEye of The Herald!");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x07AA0000[Enemy Team] \x07AAAAAAhas taken the \x07AA00AAEye of The Herald!");
			}
		}
	}
}

public Action:Command_RiftSlain(client, args)
{
	PrintToChatAll("\x07AA00AA[Rift Herald] \x07AAAAAAhas been slain.");
}

public Action:Command_SlainByRift(client, args)
{
	PrintToChatAll("\x07AA00AARift Herald \x07AAAAAAhas slain a player!");
}

public Action:Command_Stormed(client, args)
{
	PrintToChatAll("\x07AAAAAAA player has been \x07AA0000Struck by Lightning!");
}

public Action:Command_RedTurretDestroyed(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x07AA0000[Your Turret] \x07AAAAAAhas been destroyed.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x07AA0000[Enemy Turret] \x07AAAAAAhas been destroyed.");
			}
		}
	}
}

public Action:Command_BlueTurretDestroyed(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x0700AAAA[Enemy Turret] \x07AAAAAAhas been destroyed.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x0700AAAA[Your Turret] \x07AAAAAAhas been destroyed.");
			}
		}
	}
}

public Action:Command_RedInhibDestroyed(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x07AA0000[Your Inhibitor] \x07AAAAAAhas been destroyed.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x07AA0000[Enemy Inhibitor] \x07AAAAAAhas been destroyed.");
			}
		}
	}
}

public Action:Command_BlueInhibDestroyed(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x0700AAAA[Enemy Inhibitor] \x07AAAAAAhas been destroyed.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x0700AAAA[Your Inhibitor] \x07AAAAAAhas been destroyed.");
			}
		}
	}
}

public Action:Command_RedInhibRessoon(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x07AA0000[Your Inhibitor] \x07AAAAAAis respawning soon.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x07AA0000[Enemy Inhibitor] \x07AAAAAAis respawning soon.");
			}
		}
	}
}

public Action:Command_BlueInhibRessoon(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x0700AAAA[Enemy Inhibitor] \x07AAAAAAis respawning soon.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x0700AAAA[Your Inhibitor] \x07AAAAAAis respawning soon.");
			}
		}
	}
}

public Action:Command_RedInhibRes(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x07AA0000[Your Inhibitor] \x07AAAAAAhas respawned.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x07AA0000[Enemy Inhibitor] \x07AAAAAAhas respawned.");
			}
		}
	}
}

public Action:Command_BlueInhibRes(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x0700AAAA[Enemy Inhibitor] \x07AAAAAAhas respawned.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x0700AAAA[Your Inhibitor] \x07AAAAAAhas respawned.");
			}
		}
	}
}

public Action:Command_GKSpree(client, args)
{
	PrintToChatAll("\x07AAAAAA[\x07AA00AAGromp\x07AAAAAA] is on a \x07AA0000Killing Spree\x07AAAAAA!");
}

//Custom Ult Module
public Action:Comamnd_Requiem(client, args)
{
	for (client=1; client<=MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			new TeamCheck = GetClientTeam(client);
			if (!(TeamCheck == 3))
			{
				PrintToChat(client, "\x0700AAAA[Enemy Inhibitor] \x07AAAAAAhas respawned.");
			}
			
			else if (TeamCheck == 3)
			{
				PrintToChat(client, "\x0700AAAA[Your Inhibitor] \x07AAAAAAhas respawned.");
			}
		}
	}
}