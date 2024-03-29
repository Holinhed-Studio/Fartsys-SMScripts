#include <sourcemod>
#include <sdktools>
#define PLUGIN_NAME "Baseball Hell Randomizer"
#define PLUGIN_AUTHOR "SirDovahBearYT"
#define PLUGIN_DESCRIPTION "Picks a random gamemode every 60 seconds"
#define PLUGIN_VERSION "1.2.0"
#define GONG "misc/halloween/strongman_bell_01.wav"
bool Running;

public Plugin myinfo = 
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = "http://www.sourcemod.net"
};

public OnPluginStart()
{
	PrecacheSound(GONG, true);
	Running = false;
	while(Running == false)
	{
		CreateTimer(60.0, Command_RandomExec);
		Running = true;
	}
}

public Action Command_RandomExec(Handle timer)
{
	new RandomNumbersArray[7] = {1,2,3,4,5,6,7}; 
	new randomnum = GetRandomInt(1, 7); 
	if (randomnum == 1)
	{
		ServerCommand("baseballhell_mode SCOUT_PLAY_ALL_WEAPONS");
		ServerCommand("sm_csay SCOUT PLAYS WITH ALL WEAPONS!");
		EmitSoundToAll(GONG);
		Running = false;
	}
	if (randomnum == 2)
	{
		ServerCommand("baseballhell_mode SCOUT_PLAY_BAT_ONLY");
		ServerCommand("sm_csay SCOUT PLAYS WITH BAT ONLY!");
		EmitSoundToAll(GONG);
		Running = false;
	}
	if (randomnum == 3)
	{
		ServerCommand("baseballhell_mode ALL_PLAY_ALL_WEAPONS");
		ServerCommand("sm_csay ALL CLASSES PLAY ALL WEAPONS!");
		EmitSoundToAll(GONG);
		Running = false;
	}
	if (randomnum == 4)
	{
		ServerCommand("baseballhell_mode ALL_PLAY_BAT_ONLY");
		ServerCommand("sm_csay EVERYONE PLAYS BAT ONLY");
		EmitSoundToAll(GONG);
		Running = false;
	}
	if (randomnum == 5)
	{
		ServerCommand("baseballhell_mode FLAK_CANNON");
		ServerCommand("sm_csay FLAK CANNONS FOR ALL!");
		EmitSoundToAll(GONG);
		Running = false;
	}
	if (randomnum == 6)
	{
		ServerCommand("baseballhell_mode HUNTSMAN");
		ServerCommand("sm_csay RAPID FIRE HUNTSMANS INCOMING!");
		EmitSoundToAll(GONG);
		Running = false;
	}
	if (randomnum == 7)
	{
		ServerCommand("baseballhell_mode ROCKETMAN");
		ServerCommand("sm_csay VALVE ROCKET LAUNCHERS FOR ALL!");
		EmitSoundToAll(GONG);
		Running = false;
	}
	else
	{
		Running = false;
	}
}