/*************************************************
**          PURE CHAOS EXTENDED                 **
**                                              **
** THE CHAOS HAS JUST GOTTEN AN ORDER OF        **
** MAGNITUDE MORE INSANE. USE THIS PLUGIN       **
** AT YOUR OWN RISK. I WILL BE RESPONSIBLE      **
** FOR ANY TRUE CHAOS THAT HAPPENS WITHIN YOUR  **
** SERVER, BUT I WILL NOT BE RESPONSIBLE FOR    **
** THE TIMES WHEN EVERYTHING GOES EXTREMELY WAY **
** OUT OF CONTROL. IF YOUR SERVER BREAKS, I AM  **
** NOT GOING TO TAKE RESPONSIBILITY. YOU HAVE   **
** BEEN WARNED. -- Dovahkiin-Warrior            **
***                                            ***
****                  WARNING                 ****
**** THIS PLUGIN REQUIRES THE FOLLOWING OTHER ****
**** PLUGINS, PLEASE MAKE SURE THEY EXIST!!!! ****
****                                          ****
****                  GODMODE			      ****
****            BE THE SENTRYBUSTER           ****
****                BE THE ROBOT              ****
****            TF2ITEMS GIVE WEAPON          ****
****              ROLL THE DICE V2            ****
****              BE THE DEFLECTOR            ****
****              BE THE HORSEMANN            ****
****            BE THE SKELETON KING          ****
****              BUILDING RESIZES            ****
****                NECRO-MASHED              ****
****               RESIZE PLAYERS             ****
****              SET PLAYER SPEED            ****
****             EVIL ADMIN: ROCKET           ****
****                   SOUNDS                 ****
****                TF2 SET CLASS             ****
****            TF2 FULL INFINITE AMMO        ****
****               TF2 RATE OF FIRE           ****
****                TF2 ATTRIBUTES            ****
****              TF2 THRILLER DANCE          ****
****                 TRAIN RAIN               ****
****                                          ****
****                                          ****
****        AND THE TF2ITEMS EXTENSION        ****
****                                          ****
**************************************************
*************************************************/

//Simple script setup
#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <regex>
#define PLGVER "3.1.0"
#undef REQUIRE_PLUGIN
#undef REQUIRE_EXTENSIONS
#include <cstrike>
#define REQUIRE_EXTENSIONS
#define TEAMSWITCH_ARRAY_SIZE 64
#pragma newdecls required

// Team definitions
#define TEAM_1    2
#define TEAM_2    3
#define TEAM_SPEC 1

//Initiate booleans
bool cstrikeExtAvail = false;
bool DeathIsHooked   = false;
bool PrettifyChat    = true;
bool Chaos = false;
ConVar g_Prettify;
char teamName1[5];
char teamName2[5];

//Ints
int chaosIndex = 0;
int shuffled = 0;

//Give plugin info
public Plugin myinfo ={
	name		=	"Pure Chaos [Extended]",
	author		=	"ProfessorFartsalot",
	description	=	"Create inhuman amounts of absolute pure and true chaos..",
	version		=	PLGVER,
	url			=	"https://forums.firehostredux.com"
};

//Enumerate Team switch module listener
enum SwitchModuleEvent{
	SwitchModuleEvent_Now	= 0
};

//Initiate the core, register required commands & Precache and Allocate files
public void OnPluginStart(){
	ServerCommand("sm plugins unload chaos/instantrespawn; sm plugins unload chaos/train_rain"),
	PrintToServer("[Pure Chaos] *******WARNING: PLEASE MAKE SURE YOU HAVE ALL THE PLUGINS REQUIRED TO RUN THIS PLUGIN, OTHERWISE THINGS WILL NOT WORK AS INTENDED. YOU HAVE BEEN WARNED."),
	RegAdminCmd("sm_chaos", Command_LegacyChaos, ADMFLAG_ROOT, "Unleash Pure Chaos");
	RegAdminCmd("sm_truechaos", Command_TrueChaos, ADMFLAG_ROOT, "Unleash Pure Chaos");
	RegAdminCmd("sm_666", Command_DeleteThis, ADMFLAG_ROOT, "DELETE THIS");
	RegAdminCmd("sm_randomizeall", Command_RandomizeAll, ADMFLAG_ROOT, "Randomize everyone to a single class");
	g_Prettify = CreateConVar("sm_chaos_prettify", "1", " Prettify chat while chaos is active. 0/1 - On/off");
	HookEvent("player_team", Event_PlayerTeam, EventHookMode_Pre);
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre);
	PrecacheSound("chaos/warn.mp3", true),
    AddFileToDownloadsTable("sound/chaos/warn.mp3"),
	PrecacheSound("chaos/theme.mp3", true),
	AddFileToDownloadsTable("sound/chaos/theme.mp3"),
	PrecacheSound("chaos/bgm/canttouchthis.mp3", true),
	AddFileToDownloadsTable("sound/chaos/bgm/canttouchthis.mp3"),
	PrecacheSound("chaos/bgm/hampsterdance.mp3", true),
	AddFileToDownloadsTable("sound/chaos/bgm/hampsterdance.mp3"),
	PrecacheSound("chaos/bgm/finaldest.mp3", true),
	AddFileToDownloadsTable("sound/chaos/bgm/finaldest.mp3"),
	PrecacheSound("chaos/bgm/skeletons.mp3", true),
	AddFileToDownloadsTable("sound/chaos/bgm/skeletons.mp3"),
	PrecacheSound("chaos/bgm/somebody.mp3", true),
	AddFileToDownloadsTable("sound/chaos/bgm/somebody.mp3"),
	PrecacheSound("chaos/bgm/intro.mp3", true),
	AddFileToDownloadsTable("sound/chaos/bgm/intro.mp3");
	PrecacheSound("trainsawlaser/extra/sound1.wav", true),
	AddFileToDownloadsTable("sound/trainsawlaser/extra/sound1.wav"),
	PrecacheSound("trainsawlaser/extra/sound2.wav", true),
	AddFileToDownloadsTable("sound/trainsawlaser/extra/sound2.wav");
}

//Mute Player Team Changes if allowed
public Action Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast){
	if(g_Prettify.BoolValue){
		if(!event.GetBool("silent")){
			event.BroadcastDisabled = true;
		}
	}
	return Plugin_Continue;
}

//Mute CVar changes if allowed
public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast){
	if(g_Prettify.BoolValue){
		event.BroadcastDisabled = true;
	}
	return Plugin_Continue;
}

//Get the current Team names and print team list to Server console
public void OnMapStart(){
	GetTeamName(2, teamName1, sizeof(teamName1));
	GetTeamName(3, teamName2, sizeof(teamName2));
	PrintToChatAll("\x079A769A [True Chaos] Team Names: %s %s - Using CStrike: %s - Muting sv_tags & sv_gravity to purify chat: %s",	teamName1, teamName2, (cstrikeExtAvail ? "yes" : "no" ), (PrettifyChat ? "yes" : "no")),
	PrintToServer("[True Chaos] Team Names: %s %s - Using CStrike: %s - Muting sv_tags & sv_gravity to purify chat: %s",	teamName1, teamName2, (cstrikeExtAvail ? "yes" : "no" ), (PrettifyChat ? "yes" : "no"));
}

//Execute switch command on player after they die
public Action playerDeath(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast){
	if(!Chaos){
		PrintToServer("[True Chaos] Chaos is not active."); //If this event is properly unhooked, we should never get here.
	}
	else{
		bool toSpec = false;
		//int client = GetClientOfUserId(GetEventInt(event, "userid"));
		int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
		int cTeam  = GetClientTeam(client);
		int toTeam = (toSpec ? TEAM_SPEC : TEAM_1 + TEAM_2 - cTeam);	
		if(cstrikeExtAvail && !toSpec){
			CS_SwitchTeam(client, toTeam);
		}
		else{
			ChangeClientTeam(client, toTeam);
			PrintToChatAll("\x0700FF00 [True Chaos] %N has been switched by death.", client);
		}
	}
//	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
//	new weapon = GetClientWeapon(attacker, "weapon", -1);
//	PrintToChatAll("\x07888888 [True Chaos] %N was killed by %N", client, attacker); //Show that player was killed by attacker
}

//Randomize everyone to the same class, scramble classes
public Action Command_RandomizeAll(int client, int args){
	int ClassVal, NewClassVal = 0;
	while (ClassVal == NewClassVal){
		ClassVal = GetRandomInt (1, 18);
	}
	NewClassVal = ClassVal;
	switch(NewClassVal){
		case 1:{
			ServerCommand("sm_setclass @all scout");
		}
		case 2:{
			ServerCommand("sm_setclass @all soldier");
		}
		case 3:{
			ServerCommand("sm_setclass @all pyro");
		}
		case 4:{
			ServerCommand("sm_setclass @all demo");
		}
		case 5:{
			ServerCommand("sm_setclass @all heavy");
		}
		case 6:{
			ServerCommand("sm_setclass @all engineer");
		}
		case 7:{
			ServerCommand("sm_setclass @all medic");
		}
		case 8:{
			ServerCommand("sm_setclass @all sniper");
		}
		case 9:{
			ServerCommand("sm_setclass @all spy");
		}
		case 10:{
			ServerCommand("sm_setclass @red scout"),
			ServerCommand("sm_setclass @blue soldier");
		}
		case 11:{
			ServerCommand("sm_setclass @red pyro"),
			ServerCommand("sm_setclass @blue spy");
		}
		case 12:{
			ServerCommand("sm_setclass @red demoman"),
			ServerCommand("sm_setclass @blue engineer");
		}
		case 13:{
			ServerCommand("sm_setclass @red heavy"),
			ServerCommand("sm_setclass @blue medic");
		}
		case 14:{
			ServerCommand("sm_setclass @red sniper"),
			ServerCommand("sm_setclass @blue soldier");
		}
		case 15:{
			ServerCommand("sm_setclass @red soldier"),
			ServerCommand("sm_setclass @blue pyro");
		}
		case 16:{
			ServerCommand("sm_setclass @red scout"),
			ServerCommand("sm_setclass @red heavy");
		}
		case 17:{
			ServerCommand("sm_setclass @red engineer"),
			ServerCommand("sm_setclass @blue spy");
		}
		case 18:{
			ServerCommand("sm_setclass @red pyro"),
			ServerCommand("sm_setclass @blue scout");
		}
	}
}

/*******************************
*   LEGACY CHAOS BEGINS HERE   *
*                              *
* Fun fact, legacy chaos was   *
* my first ever version of the *
* plugin. It executed cfgs by  *
* using timers with a song in  *
* the background playing. I've *
* decided to keep this as its  *
* own little module because I  *
* really just thought it's     *
* kinda cute. And chaotic! :)  *
*******************************/

//Execute chaos command and inform the server that true chaos is about to spawn
public Action Command_LegacyChaos(int client, int args)
{
	PrintCenterTextAll("GET READY FOR PURE CHAOS....."),
	PrintToChatAll("User %N has initiated two minutes of pure chaos... There will be many waves, prepare for absolute chaos and potential crashes!", client),
	EmitSoundToAll("chaos/warn.mp3", client),
	CreateTimer(3.0, Command_LegacyStart);
	if (g_Prettify.BoolValue){
		PrintToChatAll("\x07AA0000[Chaos Engine v2.1] \x07999999Limiting chat spam : \x07009900true");
	}
	if (!g_Prettify.BoolValue){
		PrintToChatAll("\x07AA0000[Chaos Engine v2.1] \x07999999Limiting chat spam : \x07660000false");
	}
}

//Execute when legacy initiated by command.
public Action Command_LegacyStart(Handle timer){
	EmitSoundToAll("chaos/theme.mp3"),
	CreateTimer(13.60, Command_Chaos1);
}

//Execute when true chaos requests initiation.
public Action Command_LegacyStartByHook(Handle timer){
	PrintToChatAll("\x07AA0000 [True Chaos] Initiating Legacy Pure Chaos... It is likely that everyone is now in grave danger. I highly suggest you flee immediately while you have the chance before it's too late..."),
	EmitSoundToAll("chaos/theme.mp3"),
	CreateTimer(13.60, Command_Chaos1);
}

/************************************************************************
*    This is the configuration timing of the original pure chaos,       *
*  feel free to edit if this is either lasting too long or doesn't      *
*  fit your needs. You may also change the path to the configurations   *
*  or you may change the events that occur when these timers fire. All  *
*  of the following timers may be modified to fit your needs, just be   *
*  very careful so as to not overdo things, as that is the job of True  *
*  Chaos' module which is listed farther down. This version will send   *
*  configuration execution requests to the server at a specified time,  *
*  and as such, the commands contained within these configuration files *
*  will be executed when the server loads them individually. You should *
*  not really NEED to edit these commands unless you TRULY wish to use  *
*  either more config files, or less config files.                      *
************************************************************************/

//Execute Configs in order.
public Action Command_Chaos1(Handle timer){
	ServerCommand("exec sourcemod/chaos/1.cfg"),
	CreateTimer(40.0, Command_Chaos2);
}
//Execute the Second Config
public Action Command_Chaos2(Handle timer){
	ServerCommand("exec sourcemod/chaos/2.cfg"),
	CreateTimer(25.40, Command_Chaos3);
}
//Execute the Third Config
public Action Command_Chaos3(Handle timer){
	ServerCommand("exec sourcemod/chaos/3.cfg"),
	CreateTimer(25.50, Command_Chaos4);
}
//Execute the Fourth Config
public Action Command_Chaos4(Handle timer){
	ServerCommand("exec sourcemod/chaos/4.cfg"),
	CreateTimer(25.50, Command_ChaosFinal);
}
//Execute the Final Config
public Action Command_ChaosFinal(Handle timer){
	ServerCommand("exec sourcemod/chaos/5.cfg"),
	PrintCenterTextAll("The chaos has settled.."),
	EmitSoundToAll("player/taunt_sfx_bell_single.wav");
	if (DeathIsHooked == true){
		UnhookEvent("player_death", playerDeath), //Unhook Player Death
		PrintToChatAll("\x07AA0000 [Pure Chaos] \x07AAAA00Unhooking Event: player_death"), //Notify that player death has been unhooked and thus teamswitch is off
		DeathIsHooked = false;
	}
}

//TRUE PURE CHAOS BEGINS HERE
public Action Command_TrueChaos(int client, int args){
	PrintToChatAll("[True Chaos] Initiation began by user %N... There will be many waves, prepare for the end times!", client),
	CreateTimer(1.0, Chaos_Operator, 0);
	if (g_Prettify.BoolValue){
		PrintToChatAll("\x07AA0000[Chaos Engine v2.1] \x07999999Limiting chat spam : \x07009900true");
	}
	else{
		PrintToChatAll("\x07AA0000[Chaos Engine v2.1] \x07999999Limiting chat spam : \x07660000false");
	}
}
//Screw this old system. Lets write an operator.
public Action Chaos_Operator(Handle timer, int operation){
	switch(operation){
		case 0:{
			int chaosLvl = GetRandomInt(0, 5);
			switch (chaosLvl){
				case 0:{ //Difficulty 0. Lowest difficulty.
					Chaos = true;
					ServerCommand("sm plugins load chaos/instantrespawn; sm_buildingresizer_enabled 1; sm_building_minsize 0.8; sm_building_maxsize 1.4"),
					EmitSoundToAll("chaos/bgm/canttouchthis.mp3"),
					PrintToChatAll("\x07AA0000 [True Chaos] \x07999999Ensuring all Hammers are sharpened, I's are crossed, and T's are dotted for \x0700CCCCLevel 0\x07999999..."),
					CreateTimer(1.5, Chaos_TimedOperator, 0);
				}
				case 1:{ //Difficulty 1. Now we're talkin'!
					Chaos = true;
					ServerCommand("sm plugins load chaos/instantrespawn; sm_buildingresizer_enabled 1; sm_building_minsize 0.6; sm_building_maxsize 1.8"),
					EmitSoundToAll("chaos/bgm/hampsterdance.mp3"),
					PrintToChatAll("\x07AA0000 [True Chaos] \x07999999Recruiting robot hampsters for \x0700AA00Level 1\x07999999..."),
					CreateTimer(9.4, Chaos_TimedOperator, 10);
				}
				case 2:{ //Difficulty 2. Things are getting real.
					Chaos = true;
					ServerCommand("sm plugins load chaos/instantrespawn; sm_buildingresizer_enabled 1; sm_building_minsize 0.4; sm_building_maxsize 2.2"),
					EmitSoundToAll("chaos/bgm/finaldest.mp3"),
					PrintToChatAll("\x07AA0000 [True Chaos] \x07999999Downloading more RAM for \x07AAAA00Level 2\x07999999..."),
					CreateTimer(5.75, Chaos_TimedOperator, 20);
				}
				case 3:{
					CreateTimer(0.05, Chaos_Operator, 0);
				}
				/* case 3:{ //Difficulty 3. Pure Chaos.
				*	Chaos = true;
				*	ServerCommand("sm plugins load chaos/instantrespawn; sm_buildingresizer_enabled 1; sm_building_minsize 0.2; sm_building_maxsize 2.6"),
				*	PrintToChatAll("\x07AA0000 [True Chaos] \x07999999Power of the Sorcerer, to great to be controlled! Now rises his greatest minions for \x07CC8000Level 3\x07999999..."),
				*	EmitSoundToAll("chaos/bgm/skeletons.mp3"),
				*	CreateTimer(13.0, Chaos_TimedOperator, 30);
				}*/
				case 4:{ //Difficulty 4. Madness.
					Chaos = true;
					ServerCommand("sm plugins load chaos/instantrespawn; sm_buildingresizer_enabled 1; sm_building_minsize 0.1; sm_building_maxsize 3.2"),
					EmitSoundToAll("chaos/bgm/somebody.mp3"),
					PrintToChatAll("\x07AA0000 [True Chaos] \x07999999Asking Meme-chan out on a date for \x07CC0000Level 4\x07999999..."),
					CreateTimer(18.50, Chaos_TimedOperator, 40);
				}
				case 5:{ //Difficulty 5. True Chaos.
					Chaos = true;
					PrintToServer("Got 5... PREPARE FOR THE END TIMES!!!"),
					ServerCommand("sm plugins load chaos/instantrespawn; sm_buildingresizer_enabled 1; sm_building_minsize 0.0125; sm_building_maxsize 4.0"),
					PrintToChatAll("\x07FF00FF [True Chaos] Very bad things are about to happen..."), 
					EmitSoundToAll("chaos/bgm/intro.mp3"),
					CreateTimer(80.0, Chaos_TimedOperator, 50);
				}
			}
			return Plugin_Stop;
		}
	}
	return Plugin_Stop;
}
//Timed Operator, actually runs the chaos scripts.
public Action Chaos_TimedOperator(Handle timer, int operation){
	switch (operation){
//Chaos lvl 0
		case 0:{
			Chaos = true;
			HookEvent("player_death", playerDeath); //Begin hooking player_death for switch team functionality
			DeathIsHooked = true;
			PrintToChatAll("\x0700AAAA [True Chaos] Hooking event: player_death"); //Tell the chat we are hooking player death.
			CreateTimer(1.5, Chaos_TimedOperator, 1);
		}
		case 1:{
			ServerCommand("sm_god @all 1"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707020<\x0700AAAA00\x07707020> \x07707020All players are now in God Mode. You can't touch this!"),
			CreateTimer(3.5, Chaos_TimedOperator, 2);
		}
		case 2:{
			ServerCommand("sm_slap @all 5"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707020<\x0700AAAA00\x07707020> \x07707020Attempting to slap all players. Nope, still can't touch this!"),
			CreateTimer(4.2, Chaos_TimedOperator, 3);
		}
		case 3:{
			ServerCommand("sm_thriller @all 13"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707020<\x0700AAAA00\x07707020> \x07707020Break it down!"),
			CreateTimer(13.6, Chaos_TimedOperator, 4);
		}
		case 4:{
			ServerCommand("sm_smash @all"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707020<\x0700AAAA00\x07707020> \x07707020STOP! HAMMERTIME!!!"),
			CreateTimer(1.0, Chaos_TimedOperator, 5);
		}
		case 5:{
			ServerCommand("sm_bedeflector @all; sm_mortal @all"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707020<\x0700AAAA00\x07707020> \x07707020Be the deflector, go with the flow!"),
			CreateTimer(28.5, Chaos_TimedOperator, 6);
		}
		case 6:{
			ServerCommand("sm_smash @all"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707020<\x0700AAAA00\x07707020> \x07707020STOP! HAMMERTIME!!!"),
			CreateTimer(3.0, Chaos_TimedOperator, 7);
		}
		case 7:{
			ServerCommand("sm plugins unload chaos/instantrespawn; sm_slay @all; sm_buildingresizer_enabled 0"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707020<\x0700AAAA00\x07707020> \x07707020STOP! Chaos is over!!!");
			if (DeathIsHooked){
				UnhookEvent("player_death", playerDeath), //Unhook Player Death
				PrintToChatAll("\x07AA0000 [Pure Chaos] \x07AAAA00Unhooking Event: player_death"), //Notify that player death has been unhooked and thus teamswitch is off
				DeathIsHooked = false;
			}
			Chaos = false;
			return Plugin_Stop;
		}
//Chaos lvl 1
		case 10:{
			PrintCenterTextAll("Current Song: The Hampsterdance"),
			ServerCommand("sm_noclip @all; sm_givew @all 9205; sm plugins load chaos/train_rain"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07700070<\x0700AA0001\x07700070> \x07700070All players will receive noclip and Robin Walker's Rocket Launcher, Trains will rain from the sky"),
			CreateTimer(9.4, Chaos_TimedOperator, 11);
		}
		case 11:{
			PrintCenterTextAll("Current Song: The Hampsterdance"),
			ServerCommand("sm_smite @all; sm_forcertd @all; sm_smash @all;sm_buddha @all; sm_forcertd @all"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07007700<\x0700AA0001\x07007700> \x07007700All players will receive random RTD, Buddha, then another random RTD"),
			CreateTimer(14.6, Chaos_TimedOperator, 12);
		}
		case 12:{
			ServerCommand("sm_slay @all"),
			CreateTimer(0.25, Chaos_TimedOperator, 13);
		}
		case 13:{
			PrintCenterTextAll("Current Song: The Hampsterdance"),
			ServerCommand("sm_forcertd @all 2; sm_robot @all; sm_givew @all 9014"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07700070<\x0700AA0001\x07700070> \x07700070All players will receive lucky sandvich, robot, and a Valve Sniper Rifle"),
			CreateTimer(15.80, Chaos_TimedOperator, 100);
			CreateTimer(20.00, Chaos_TimedOperator, 14);
		}
		case 14:{
			ServerCommand("sm_givew @blue 21; sm_fia @blue 1; sm_rof @blue 20; sm_givew @red 2228; sm_forcertd @red 13"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07700000<\x0700AA0001\x07700000> \x07700000LET'S PLAY DODGEBALL WITH SOME NUKES!!!"),
			CreateTimer(29.0, Chaos_TimedOperator, 15);
		}
		case 15:{
			ServerCommand("sm_slay @all; sm_rof @all 1"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07007000<\x0700AA0001\x07007000> \x07007000Shuffling classes....."),
			CreateTimer(0.20, Chaos_TimedOperator, 102);
			CreateTimer(16.20, Chaos_TimedOperator, 100);
			CreateTimer(17.20, Chaos_TimedOperator, 16);
		}
		case 16:{
			ServerCommand("sm_resizehands @all -2; sv_gravity 100"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07007070<\x0700AA0001\x07007070> \x07007070All players will have -2 hand size, gravity will be 100"),
			CreateTimer(8.0, Chaos_TimedOperator, 17);
		}
		case 17:{
			ServerCommand("sv_gravity 800; sm_thriller @all 8"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707000<\x0700AA0001\x07707000> \x07707000Dance, fools!"),
			CreateTimer(8.0, Chaos_TimedOperator, 18);
		}
		case 18:{
			ServerCommand("sm_bedeflector @all"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07707020<\x0700AA0001\x07707020> \x07707020All players will become deflector"),
			CreateTimer(12.0, Chaos_TimedOperator, 100);
			CreateTimer(12.25, Chaos_TimedOperator, 19);
		}
		case 19:{
			ServerCommand("sm_thriller @all 35; sm_resizehands @all 1"),
			ServerCommand("sm plugins unload chaos/instantrespawn; sm_fia @all 0; sm_buildingresizer_enabled 0; sm plugins unload chaos/train_rain"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07999999<\x0700AA0001\x07999999> True Chaos at level *1* has ended");
			if (DeathIsHooked == true)
			{
				UnhookEvent("player_death", playerDeath), //Unhook Player Death
				PrintToChatAll("\x07AA0000 [Pure Chaos] \x07AAAA00Unhooking Event: player_death"), //Notify that player death has been unhooked and thus teamswitch is off
				DeathIsHooked = false;
			}
			Chaos = false;
		}
//Chaos lvl 2
		case 20:{
			PrintCenterTextAll("Current Song: Final Destination - Super Smash Bros. Brawl"),
			ServerCommand("sm_bedeflector @blue; sm_behhh @red"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07E48C12<\x07AAAA0002\x07E48C12> \x07E48C12Blue team will become deflector, red team will become HHH"),
			CreateTimer(10.0, Chaos_TimedOperator, 21);
		}
		case 21:{
			ServerCommand("sm_setspeed @all 520; sm_behhh @blue; sm_bedeflector @red"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07E48C12<\x07AAAA0002\x07E48C12> Blue team will become HHH, red team will become Deflector"),
			CreateTimer(15.0, Chaos_TimedOperator, 22);
		}
		case 22:{
			ServerCommand("sm_givew @all 9205"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07700070<\x07AAAA0002\x07700070> All players will receive Robin Walker's Rocket Launcher"),
			CreateTimer(10.0, Chaos_TimedOperator, 23);
		}
		case 23:
		{
			ServerCommand("sm_slay @all; sm_resizetorso @all -1000; sm_noclip @all"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07008000<\x07AAAA0002\x07008000> All players will have -1000 torso size and noclip"),
			CreateTimer(12.0, Chaos_TimedOperator, 100);
			CreateTimer(12.75, Chaos_TimedOperator, 24);
		}
		case 24:{
			ServerCommand("sm_resizetorso @all 10; sv_gravity -800; sm_fia @all 1; sm_givew @all 2228; sm_forcertd @all 13"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07B41262<\x07AAAA0002\x07B41262> All players will have 10 torso size, gravity will be -800, full infinite ammo will be activated, and all players will receive a nuke launcher, as well as homing projectiles"),
			CreateTimer(22.0, Chaos_TimedOperator, 25);
		}
		case 25:{
			ServerCommand("sv_gravity 2000; sm_givew @all 2228; sm_rof @all 20; mp_friendlyfire 1"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07B41262<\x07AAAA0002\x07B41262> Gravity will be 2000, all players will receive a nuke launcher, rate of fire will be 20x, and friendly fire will be activated"),
			CreateTimer(11.0, Chaos_TimedOperator, 26);
		}
		case 26:{
			ServerCommand("sv_gravity -2000; sm_rof @all 1; sm_fia @all 0; sm_givew @all 9205; mp_friendlyfire 0; sm_resizetorso @all -1; sm_setspeed @all 5000"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07AA0090<\x07AAAA0002\x07AA0090> Gravity will be -2000, all players will receive Robin Walker's Rocket Launcher,  all players will have -1 torso size"),
			CreateTimer(35.0, Chaos_TimedOperator, 27);
		}
		case 27:{
			ServerCommand("sv_gravity 800; sm_slay @all; sm plugins unload chaos/instantrespawn;  sm_resizetorso @all 1; sm plugins reload bedeflector; sm_resetspeed @all; sm_buildingresizer_enabled 0"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07999999<\x07AAAA0002\x07999999> True chaos at level *2* has ended");
			if (DeathIsHooked == true)
			{
				UnhookEvent("player_death", playerDeath), //Unhook Player Death
				PrintToChatAll("\x07AA0000 [Pure Chaos] \x07AAAA00Unhooking Event: player_death"), //Notify that player death has been unhooked and thus teamswitch is off
				DeathIsHooked = false;
			}
			Chaos = false;
		}
//Chaos lvl 3
		case 30:{
			Chaos = true,
			HookEvent("player_death", playerDeath), //Begin hooking player_death for switch team functionality
			DeathIsHooked = true,                   //Tell the plugin Death has been hooked
			ServerCommand("sm_beskeleton @all 1"),
			PrintToChatAll("\x0700AAAA [True Chaos] \x07999999<\x07CC800004\x07999999> Spooky scary skeletons send shivers down your spine... Seal your doom tonight!"),
			CreateTimer(18.5, Chaos_TimedOperator, 31);
		}
		case 31:{
			ServerCommand("sm_beskeleton @all 1"),
			PrintToChatAll("\x0700AAAA [True Chaos] \x07999999<\x07CC800004\x07999999> Spooky scary spooky scary..."),
			CreateTimer(18.5, Chaos_TimedOperator, 32);
		}
		case 32:{
			ServerCommand("sm_beskeleton @all 1"),
			PrintToChatAll("\x0700AAAA [True Chaos] \x07999999<\x07CC800004\x07999999> You'll shake and shudder in surprise, when you hear these zombies shriek!"),
			CreateTimer(12.5, Chaos_TimedOperator, 104);
			CreateTimer(20.0, Chaos_TimedOperator, 104);
			CreateTimer(28.0, Chaos_TimedOperator, 104);
			CreateTimer(32.0, Chaos_TimedOperator, 104);
			CreateTimer(34.0, Chaos_TimedOperator, 104);
			CreateTimer(36.0, Chaos_TimedOperator, 104);
			CreateTimer(52.0, Chaos_TimedOperator, 104);
			CreateTimer(58.0, Chaos_TimedOperator, 104);
			CreateTimer(64.0, Chaos_TimedOperator, 33);
		}
		case 33:{
			PrintToChatAll("\x0700AAAA [True Chaos] \x07999999<\x07CC800004\x07999999> True chaos at level *3* has ended"),
			ServerCommand("sm_slay @all");
			if (DeathIsHooked == true)
			{
				UnhookEvent("player_death", playerDeath), //Unhook Player Death
				PrintToChatAll("\x07AA0000 [Pure Chaos] \x07AAAA00Unhooking Event: player_death"), //Notify that player death has been unhooked and thus teamswitch is off
				DeathIsHooked = false;
			}
			Chaos = false;
		}
//Chaos lvl 4
		case 40:{
			Chaos = true,
			HookEvent("player_death", playerDeath), //Begin hooking player_death for switch team functionality
			DeathIsHooked = true,                   //Tell the plugin Death has been hooked
			PrintToChatAll("\x07AA0000 [True Chaos] \x07999999<\x07CC000004\x07999999> Meme-chan said yes OMG!!! UNLEASH DA CHAOSSSS!!!"),
			ServerCommand("sm_givew @all 9018; sm plugins load chaos/train_rain"),
			CreateTimer(40.0, Chaos_Operator, 0),
			CreateTimer(47.0, Chaos_TimedOperator, 41);
		}
		case 41:{
			ServerCommand("sm_givew @all 9014"),
			CreateTimer(20.0, Chaos_TimedOperator, 42);
		}
		case 42:{
			ServerCommand("sm_evilrocket @all"),
			PrintToChatAll("\x07AA0000 [True Chaos] \x07999999<\x07CC000004\x07999999> TO SPAAAAAAAAAAAAAAAAAAAAAAACE!!!"),
			CreateTimer(20.0, Chaos_TimedOperator, 43);
		}

		case 43:{
			UnhookEvent("player_death", playerDeath),
			ServerCommand("sm_forcertd @all 13; sm plugins unload chaos/train_rain"),
			CreateTimer(60.0, Chaos_Operator, 0);
		}
//Chaos lvl 5
		case 50:{
			HookEvent("player_death", playerDeath), //Begin hooking player_death for switch team functionality
			DeathIsHooked = true,					//Tell the plugin Death has been hooked
			PrintToChatAll("\x0700AAAA [True Chaos] Hooking event: player_death"), //Tell the chat we are hooking player death.
			CreateTimer(60.0, Chaos_Operator, 0),
			CreateTimer(120.0, Chaos_Operator, 0),
			CreateTimer(0.05, Command_LegacyStartByHook);
		}
//Special functions
		case 100:{
			ServerCommand("sm_slay @all");
			switch (chaosIndex){
				case 1:{
					PrintToChatAll("Got one via case 100.");
				}
			}
		}
		case 102:{
			if (shuffled < 15){
				ServerCommand("sm_randomizeall"),
				CreateTimer(1.0, Chaos_TimedOperator, 102);
				shuffled++;
			}
			else{
				ServerCommand("sm_slay @all");
			}			
		}
		case 104:{
			ServerCommand("sm_beskeleton @all 1");
		}
	}
	return Plugin_Stop;
}
//Seriously, you should delete this, as well as the RegConsoleCmd line for sm_666 up at the beginning of the code.
public Action Command_DeleteThis(int client, int args){
	Chaos = true;
	PrintToChatAll("\x07880000 OOF, WHO SUMMONED SATAN?! ... hint ... it was %N!", client),
	CreateTimer(6.6, Command_UnleashSatan);
}
//Unleashes pure hell.
public Action Command_UnleashSatan(Handle timer){
	Chaos = true,
	CreateTimer(0.0, Chaos_TimedOperator, 0),
	CreateTimer(1.0, Chaos_TimedOperator, 10),
	CreateTimer(2.0, Chaos_TimedOperator, 20),
	CreateTimer(3.0, Chaos_TimedOperator, 30),
	CreateTimer(4.0, Chaos_TimedOperator, 40),
	CreateTimer(5.0, Chaos_TimedOperator, 50),
	CreateTimer(166.6, Command_EndSatan),
	ServerCommand("tf_bot_add 32");
}
public Action Command_EndSatan (Handle timer){
	PrintToChatAll("\x07AA0000 [Pure Chaos] \x07660000Satan has left.... for now..."),
	ServerCommand("tf_bot_kick all");
	if (DeathIsHooked){
		UnhookEvent("player_death", playerDeath), //Unhook Player Death
		PrintToChatAll("\x07AA0000 [Pure Chaos] \x07AAAA00Unhooking Event: player_death"), //Notify that player death has been unhooked and thus teamswitch is off
		DeathIsHooked = false;
	}
	Chaos = false;
}