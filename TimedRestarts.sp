//Simple script setup
#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

//Give plugin info
public Plugin:myinfo =
{
	name		=	"Timed Restarts",
	author		=	"Dovahkiin-Warrior",
	description	=	"Restarts a server every 12 hours or by manual control",
	version		=	"1.0.0",
	url			=	"https://forums.firehostredux.com"
};

//Initiate the core, register required commands & Precache and Allocate files
public OnPluginStart()
{	
	PrintToServer("***Auto Restart Module: INITIATED***"),
	RegAdminCmd("sm_restart", Command_RestartServer, ADMFLAG_ROOT, "Restart the server safely"),
	RegAdminCmd("sm_restart_1h", Command_RestartServer1H, ADMFLAG_ROOT, "Restart the server in one hour");
	RegAdminCmd("sm_restart_30m", Command_RestartServer30M, ADMFLAG_ROOT, "Restart the server in thirty minutes");
	RegAdminCmd("sm_restart_15m", Command_RestartServer15M, ADMFLAG_ROOT, "Restart the server in fifteen minutes");
	RegAdminCmd("sm_restart_10m", Command_RestartServer10M, ADMFLAG_ROOT, "Restart the server in ten minutes");
	RegAdminCmd("sm_restart_5m", Command_RestartServer5M, ADMFLAG_ROOT, "Restart the server in five minutes");
	RegAdminCmd("sm_restart_now", Command_RestartServerSudo, ADMFLAG_ROOT, "Restart the server now [as sudo - unsafe method]");
}

public OnMapStart()
{
	CreateTimer(43180.0, PerformTimedRestart);
	PrintToServer("*** Auto Restart Module: Created timer with value of 43180.0 ***");
}

public Action:Command_RestartServer(client, args)
{
	EmitSoundToAll("ui/system_message_alert.wav"),
	ServerCommand("sm_hsay [AutoRestart] Server will restart in 60 seconds!"),
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA The server will restart in 60 seconds."),
	CreateTimer(60.0, RestartServer);
}

public Action:Command_RestartServer1H(client, args)
{
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA The server will restart in one hour."),
	CreateTimer(3580.0, RestartServer1H);
}
public Action:Command_RestartServer30M(client, args)
{
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA The server will restart in thirty minutes."),
	CreateTimer(1780.0, RestartServer30M);
}

public Action:Command_RestartServer15M(client, args)
{
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA The server will restart in fifteen minutes."),
	CreateTimer(880.0, RestartServer15M);
}

public Action:Command_RestartServer10M(client, args)
{
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA The server will restart in ten minutes."),
	CreateTimer(580.0, RestartServer10M);
}

public Action:Command_RestartServer5M(client, args)
{
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA The server will restart in five minutes."),
	CreateTimer(280.0, RestartServer5M);
}

public Action:Command_RestartServerSudo(client, args)
{
	ServerCommand("exit");
}

public Action:PerformTimedRestart(Handle timer)
{
	EmitSoundToAll("ui/system_message_alert.wav"),
	ServerCommand("sm_hsay [AutoRestart] Server will restart in 20 seconds!"),
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA Server uptime is: \x07AA000012 hours"),
	PrintToChatAll("\x07AAAAAARestarting the server gracefully - Please wait and then reconnect!"),
	CreateTimer(20.0, RestartServer);
}

public Action:RestartServer1H(Handle timer)
{
	EmitSoundToAll("ui/system_message_alert.wav"),
	ServerCommand("sm_hsay [AutoRestart] Server will restart in 20 seconds!"),
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA Restarting the server gracefully - Please wait and then reconnect!"),
	CreateTimer(20.0, RestartServer);
}

public Action:RestartServer30M(Handle timer)
{
	EmitSoundToAll("ui/system_message_alert.wav"),
	ServerCommand("sm_hsay [AutoRestart] Server will restart in 20 seconds!"),
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA Restarting the server gracefully - Please wait and then reconnect!"),
	CreateTimer(20.0, RestartServer);
}

public Action:RestartServer15M(Handle timer)
{
	EmitSoundToAll("ui/system_message_alert.wav"),
	ServerCommand("sm_hsay [AutoRestart] Server will restart in 20 seconds!"),
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA Restarting the server gracefully - Please wait and then reconnect!"),
	CreateTimer(20.0, RestartServer);
}

public Action:RestartServer10M(Handle timer)
{
	EmitSoundToAll("ui/system_message_alert.wav"),
	ServerCommand("sm_hsay [AutoRestart] Server will restart in 20 seconds!"),
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA Restarting the server gracefully - Please wait and then reconnect!"),
	CreateTimer(20.0, RestartServer);
}

public Action:RestartServer5M(Handle timer)
{
	EmitSoundToAll("ui/system_message_alert.wav"),
	ServerCommand("sm_hsay [AutoRestart] Server will restart in 20 seconds!"),
	PrintToChatAll("\x0700FF00[\x07AA0000Auto Restart\x0700FF00]\x07AAAAAA Restarting the server gracefully - Please wait and then reconnect!"),
	CreateTimer(20.0, RestartServer);
}

public Action:RestartServer(Handle timer)
{
	ServerCommand("_restart");
}