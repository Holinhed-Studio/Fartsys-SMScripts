/*                         WELCOME TO FARTSY'S ASS ROTTENBURG.
*
*   A FEW THINGS TO KNOW: ONE.... THIS IS INTENDED TO BE USED WITH UBERUPGRADES.
*   TWO..... THE MUSIC USED WITH THIS MOD MAY OR MAY NOT BE COPYRIGHTED. WE HAVE NO INTENTION ON INFRINGEMENT.
*   THREE..... THIS MOD IS INTENDED FOR USE ON THE FIREHOSTREDUX SERVERS ONLY. SUPPORT IS LIMITED.
*   FOUR..... THIS WAS A NIGHTMARE TO FIGURE OUT AND BUG FIX. I HOPE IT WAS WORTH IT.
*   FIVE..... PLEASE HAVE FUN AND ENJOY YOURSELF!
*   SIX..... THE DURATION OF MUSIC TIMERS SHOULD BE SET DEPENDING WHAT SONG IS USED. SET THIS USING THE FLOATS BGM<X>Dur BELOW.
*   SEVEN..... TIPS AND TRICKS MAY BE ADDED TO THE TIMER, SEE PerformAdverts(Handle timer);
*
*                                       GL HF!!!
* For Taco bell edition, target ass_relay with trigger for InitWaveOutput and FireUser2 for StartWaveOutput. FireUser3 still acts as boss dead relay, and FireUser4 will act as map completion.
* Also for taco bell edition, pop file needs to be updated for boss spawns to work as intended. See normal edition pop script.
*/
#include <sourcemod>
#include <sdktools>
#include <clientprefs>
#include <morecolors>
#include <regex>
#include <tf2_stocks>
#pragma newdecls required
#pragma semicolon 1
bool bombProgression = false;
bool bombReset = false; //used for notifying us when Event mvm_bomb_reset_by_player doesn't....
bool brawler_emergency = false;
bool canHindenburg = false;
bool canHWBoss = false;
bool canSENTMeteors = false;
bool canSENTNukes = false;
bool canSENTShark = false;
bool canSENTStars = false;
bool canTornado = false;
bool crusader = false;
bool isWave = false;
bool tornado = false;
bool tacobell = false;
bool sacrificedByClient = false;
bool TornadoWarningIssued = false;
Database FB_Database;
static char BELL[32] = "fartsy/misc/bell.wav";
static char BGM1[32] = "fartsy/music/ffxiv/locus.mp3";
static char BGM2[32] = "fartsy/music/ffxiv/metal.mp3";
static char BGM3[64] = "fartsy/music/ffxiv/exponentialentropy.mp3";
static char BGM4[64] = "fartsy/music/ffxiv/tornfromtheheavens.mp3";
static char BGM5[64] = "fartsy/music/ffxiv/metalbrutejusticemode.mp3";
static char BGM6[64] = "fartsy/music/ffxiv/penitus.mp3";
static char BGM7[64] = "fartsy/music/ffxiv/revengetwofold.mp3";
static char BGM8[64] = "fartsy/music/ffxiv/landslide.mp3";
static char BGM9[64] = "fartsy/music/brawler/xbc2/battle.mp3";
static char BGM9Intro[64] = "fartsy/music/brawler/xbc2/battle_intro.mp3";
static char BGM10Intro[32] = "fartsy/music/brawler/onewingedintro.mp3";
static char BGM10[64] = "fartsy/music/brawler/onewingedangel.mp3";
static char BGM1Title[32] = "FFXIV - Locus";
static char BGM2Title[32] = "FFXIV - Metal";
static char BGM3Title[32] = "FFXIV - Exponential Entropy";
static char BGM4Title[32] = "FFXIV - Torn From the Heavens";
static char BGM5Title[64] = "FFXIV - Metal: Brute Justice Mode";
static char BGM6Title[32] = "FFXIV - Penitus";
static char BGM7Title[32] = "FFXIV - Revenge Twofold";
static char BGM8Title[32] = "FFXIV - Landslide";
static char BGM9Title[64] = "Xenoblade Chronicles 2 - Battle!!";
static char BGM10Title[64] = "FF Advent Children - One Winged Angel";
static char BMB1SND[32] = "fartsy/misc/murica.mp3";
static char BMB2SND[32] = "fartsy/bl2/grenade_detonate.mp3";
static char BMB3SND[32] = "fartsy/gbombs5/t_12.mp3";
static char BMB4SND[32] = "fartsy/misc/majorkong.mp3";
static char BOOM[32] = "fartsy/vo/spongebob/boom.mp3";
static char CLOCKTICK[32] = "fartsy/misc/clock_tick.wav";
static char COUNTDOWN[32] = "fartsy/misc/countdown.wav";
static char CRUSADERATTACK[64] = "fartsy/misc/fartsyscrusader_attack.mp3";
char curSong[64] = "null";
char songName[64] = "null";
static char DEFAULTBGM1[64] = "fartsy/music/ffxiv/TheSilentRegardOfStars.mp3";
static char DEFAULTBGM2[64] = "fartsy/music/ffxiv/KnowledgeNeverSleeps.mp3";
static char DEFAULTBGM1Title[64] = "FFXIV - The Silent Regard of Stars";
static char DEFAULTBGM2Title[64] = "FFXIV - Knowledge Never Sleeps";
static char EVENTSTART[32] = "fartsy/ffxiv/bossfatejoin.mp3";
static char EXPLOSIVEPARADISE[64] = "fartsy/misc/explosiveparadise.mp3";
static char FALLSND01[32] = "fartsy/vo/l4d2/billfall02.mp3";
static char FALLSND02[32] = "fartsy/vo/l4d2/coachfall02.mp3";
static char FALLSND03[32] = "fartsy/vo/l4d2/ellisfall01.mp3";
static char FALLSND04[64] = "fartsy/vo/l4d2/francisfall02.mp3";
static char FALLSND05[32] = "fartsy/vo/l4d2/louisfall01.mp3";
static char FALLSND06[32] = "fartsy/vo/l4d2/louisfall03.mp3";
static char FALLSND07[32] = "fartsy/vo/l4d2/nickfall01.mp3";
static char FALLSND08[32] = "fartsy/vo/l4d2/zoeyfall01.mp3";
static char FALLSND09[32] = "fartsy/vo/ddd/woahhh.mp3";
static char FALLSND0A[64] = "fartsy/vo/jigglypuff/jigglypuff.mp3";
static char FALLSND0B[32] = "fartsy/vo/kirby/eeeahhhh.mp3";
static char FALLSND0C[32] = "fartsy/vo/luigi/ohohohohoo.mp3";
static char FALLSND0D[32] = "fartsy/vo/mario/wahahahaha.mp3";
static char FALLSND0E[32] = "fartsy/vo/pika/pikapika.mp3";
static char FALLSND0F[32] = "fartsy/vo/wario/wheee.mp3";
static char FALLSND10[32] = "fartsy/vo/mario/wowww.mp3";
static char GLOBALTHUNDER01[32] = "fartsy/weather/thunder1.wav";
static char GLOBALTHUNDER02[32] = "fartsy/weather/thunder2.wav";
static char GLOBALTHUNDER03[32] = "fartsy/weather/thunder3.wav";
static char GLOBALTHUNDER04[32] = "fartsy/weather/thunder4.wav";
static char GLOBALTHUNDER05[32] = "fartsy/weather/thunder5.wav";
static char GLOBALTHUNDER06[32] = "fartsy/weather/thunder6.wav";
static char GLOBALTHUNDER07[32] = "fartsy/weather/thunder7.wav";
static char GLOBALTHUNDER08[32] = "fartsy/weather/thunder8.wav";
static char HINDENBURGBOOM[64] = "fartsy/gbombs5/tsar_detonate.mp3";
static char HINDENCRASH[32] = "fartsy/vo/jeffy/hinden.wav";
static char INCOMING[64] = "fartsy/vo/ddo/koboldincoming.wav";
static char OnslaughterLaserSND[32] = "fartsy/misc/antimatter.mp3";
static char OnslaughterFlamePreATK[32] = "weapons/flame_thrower_start.wav";
static char OnslaughterFlamePostATK[32] = "weapons/flame_thrower_end.wav";
static char PLUGIN_VERSION[8] = "4.6.6";
static char RETURNSND[32] = "fartsy/ffxiv/return.mp3";
static char RETURNSUCCESS[32] = "fartsy/ffxiv/returnsuccess.mp3";
static char SHARKSND01[32] = "fartsy/memes/babyshark/baby.mp3";
static char SHARKSND02[64] = "fartsy/memes/babyshark/baby02.mp3";
static char SHARKSND03[64] = "fartsy/memes/babyshark/doot01.mp3";
static char SHARKSND04[64] = "fartsy/memes/babyshark/doot02.mp3";
static char SHARKSND05[64] = "fartsy/memes/babyshark/doot03.mp3";
static char SHARKSND06[64] = "fartsy/memes/babyshark/doot04.mp3";
static char SHARKSND07[64] = "fartsy/memes/babyshark/shark.mp3";
static char SHARKSND08[64] = "fartsy/memes/babyshark/shark02.mp3";
static char SPEC01[32] = "fartsy/vo/fartsy/goobbue.mp3";
static char SPEC02[32] = "fartsy/misc/shroom.mp3";
static char SPEC03[64] = "fartsy/vo/inurat/nuclearwaffle.mp3";
static char STRONGMAN[32] = "fartsy/misc/strongman_bell.wav";
static char SUS[32] = "amongus/emergency.mp3";
static char TRIGGERSCORE[32] = "fartsy/misc/triggerscore.wav";
static char VICTORY[32] = "fartsy/ffxivvictoryedit.mp3";
static char VO_SEPHMEMORY[32] = "fartsy/vo/sephiroth/memory.mp3";
static char WTFBOOM[32] = "fartsy/misc/wtfboom.mp3";
static float HWNMin = 210.0;
static float HWNMax = 380.0;
static float Return[3] = {-3730.0, 67.0, -252.0};
int BGMINDEX = 0;
static int BGMSNDLVL = 95;
int FailedCount = 0;
int INCOMINGDISPLAYED = 0;
int CodeEntry = 0;
static int DEFBGMSNDLVL = 50;
int bombStatus = 0;
int bombStatusMax = 0;
int curWave = 0;
int explodeType = 0;
int lastAdmin = 0;
int sacPoints = 0;
int sacPointsMax = 60;
static int SFXSNDLVL = 75;
static int SNDCHAN = 6;
int soundPreference[MAXPLAYERS + 1];
int tbLoop = 0;
int waveFlags = 0;
Handle cvarSNDDefault = INVALID_HANDLE;
stock bool IsValidClient(int client){
	return (0 < client <= MaxClients && IsClientInGame(client));
}

public Plugin myinfo ={
	name = "Fartsy's Ass - Framework",
	author = "Fartsy#8998",
	description = "Framework for Fartsy's Ass (MvM Mods)",
	version = PLUGIN_VERSION,
	url = "https://forums.firehostredux.com"
};

public void OnPluginStart(){
    PrecacheSound(BELL, true),
    PrecacheSound(BGM1, true),
    PrecacheSound(BGM2, true),
    PrecacheSound(BGM3, true),
    PrecacheSound(BGM4, true),
    PrecacheSound(BGM5, true),
    PrecacheSound(BGM6, true),
    PrecacheSound(BGM7, true),
    PrecacheSound(BGM8, true),
	PrecacheSound(BGM9, true),
	PrecacheSound(BGM9Intro, true),
	PrecacheSound(BGM10, true),
	PrecacheSound(BGM10Intro, true),
	PrecacheSound(BMB1SND, true),
	PrecacheSound(BMB2SND, true),
	PrecacheSound(BMB3SND, true),
	PrecacheSound(BMB4SND, true),
	PrecacheSound(BOOM, true),
    PrecacheSound(CLOCKTICK, true),
    PrecacheSound(COUNTDOWN, true),
    PrecacheSound(CRUSADERATTACK, true),
    PrecacheSound(DEFAULTBGM1, true),
    PrecacheSound(DEFAULTBGM2, true),
	PrecacheSound(EVENTSTART, true),
	PrecacheSound(EXPLOSIVEPARADISE, true),
    PrecacheSound(FALLSND01, true),
    PrecacheSound(FALLSND02, true),
    PrecacheSound(FALLSND03, true),
    PrecacheSound(FALLSND04, true),
    PrecacheSound(FALLSND05, true),
    PrecacheSound(FALLSND06, true),
    PrecacheSound(FALLSND07, true),
    PrecacheSound(FALLSND08, true),
    PrecacheSound(FALLSND09, true),
    PrecacheSound(FALLSND0A, true),
    PrecacheSound(FALLSND0B, true),
    PrecacheSound(FALLSND0C, true),
    PrecacheSound(FALLSND0D, true),
    PrecacheSound(FALLSND0E, true),
    PrecacheSound(FALLSND0F, true),
    PrecacheSound(FALLSND10, true),
    PrecacheSound(GLOBALTHUNDER01, true),
    PrecacheSound(GLOBALTHUNDER02, true),
    PrecacheSound(GLOBALTHUNDER03, true),
    PrecacheSound(GLOBALTHUNDER04, true),
    PrecacheSound(GLOBALTHUNDER05, true),
    PrecacheSound(GLOBALTHUNDER06, true),
    PrecacheSound(GLOBALTHUNDER07, true),
    PrecacheSound(GLOBALTHUNDER08, true),
	PrecacheSound(HINDENBURGBOOM, true),
	PrecacheSound(HINDENCRASH, true),
	PrecacheSound(INCOMING, true),
	PrecacheSound(OnslaughterLaserSND, true),
	PrecacheSound(OnslaughterFlamePreATK, true),
	PrecacheSound(OnslaughterFlamePostATK, true),
	PrecacheSound(RETURNSND, true),
	PrecacheSound(RETURNSUCCESS, true),
    PrecacheSound(SHARKSND01, true),
    PrecacheSound(SHARKSND02, true),
    PrecacheSound(SHARKSND03, true),
    PrecacheSound(SHARKSND04, true),
    PrecacheSound(SHARKSND05, true),
    PrecacheSound(SHARKSND06, true),
    PrecacheSound(SHARKSND07, true),
    PrecacheSound(SHARKSND08, true),
	PrecacheSound(SPEC01, true),
	PrecacheSound(SPEC02, true),
	PrecacheSound(SPEC03, true),
    PrecacheSound(STRONGMAN, true),
	PrecacheSound(SUS, true),
    PrecacheSound(TRIGGERSCORE, true),
	PrecacheSound(VICTORY, true),
	PrecacheSound(VO_SEPHMEMORY, true),
    PrecacheSound(WTFBOOM, true),
	PrecacheSound("mvm/ambient_mp3/mvm_siren.mp3", true),
	PrecacheSound("fartsy/memes/priceisright_fail.wav", true),
	PrecacheSound("fartsy/eee/the_horn.wav", true),
    PrecacheSound("fartsy/misc/fartsyscrusader_bgm_locus.mp3", true),
	PrecacheSound("ambient/sawblade_impact1.wav", true),
	PrecacheSound("vo/sandwicheat09.mp3", true),
    RegServerCmd("fb_operator", Command_Operator, "Serverside only. Does nothing when executed as client."),
    RegConsoleCmd("sm_bombstatus", Command_FBBombStatus, "Check bomb status"),
    RegConsoleCmd("sm_song", Command_GetCurrentSong, "Get current song name"),
	RegConsoleCmd("sm_stats", Command_MyStats, "Print current statistics"),
	RegConsoleCmd("sm_return", Command_Return, "Return to Spawn"),
	RegConsoleCmd("sm_sacpoints", Command_SacrificePointShop, "Fartsy's Annihilation Supply Shop"),
	RegConsoleCmd("sm_discord", Command_Discord, "Join our Discord server!"),
	RegConsoleCmd("sm_sounds", Command_Sounds, "Toggle sounds on or off via menu"),
    HookEvent("player_death", EventDeath),
	HookEvent("player_spawn", EventSpawn),
    HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre),
    HookEvent("mvm_wave_complete", EventWaveComplete),
    HookEvent("mvm_wave_failed", EventWaveFailed),
    HookEvent("mvm_bomb_alarm_triggered", EventWarning),
	AddFileToDownloadsTable("sound/amongus/emergency.mp3");
    HookEventEx("player_hurt", Event_Playerhurt, EventHookMode_Pre);
    CPrintToChatAll("{darkred}Plugin Loaded.");
    cvarSNDDefault = CreateConVar("sm_fartsysass_sound", "3", "Default sound for new users, 3 = Everything, 2 = Sounds Only, 1 = Music Only, 0 = Nothing");
    SetCookieMenuItem(FartsysSNDSelected, 0, "Fartsys Ass Sound Preferences");
}

public Action Command_MyStats(int client, int args){
	if (!FB_Database){
		return;
	}
	int steamID = GetSteamAccountID(client);
	if (!steamID || steamID<=10000){
		return;
	}
	DataPack pk = new DataPack();
	pk.WriteCell(client ? GetClientUserId(client) : 0);
	pk.WriteString("steamid");
	char queryID[256];
	Format(queryID, sizeof(queryID), "SELECT * from ass_activity WHERE steamid = %d;", steamID);
	FB_Database.Query(MyStats, queryID, pk);
}

public void MyStats(Database db, DBResultSet results, const char[] error, any data){
	DataPack pk = view_as<DataPack>(data);
	pk.Reset();
	
	int userId = pk.ReadCell();
	char steamId[64];
	pk.ReadString(steamId, sizeof(steamId));
	delete pk;
	
	int client = userId ? GetClientOfUserId(userId) : 0;
	bool validClient = !userId || client;
	
	if (!results)
	{
		if (validClient){
			PrintToChat(client,"[SM] Command Database Query Error");
		}
		LogError("Failed to query database: %s", error);
		return;
	}
	if (!validClient){
		return;
	}
	char name[64];
	char class[64];
	int steamID, damagedealt, damagedealtsession, kills, killssession, deaths, deathssession, bombsreset, bombsresetsession, sacrifices, sacrificessession;
	char lastkilledname[128];
	char lastusedweapon[128];
	char killedbyname[128];
	char killedbyweapon[128];
	if (results.FetchRow()){
		results.FetchString(0, name, 64); //name
		steamID = results.FetchInt(1); //steamid
		results.FetchString(4, class, 64); //class
		damagedealt = results.FetchInt(5); //damage dealt
		damagedealtsession = results.FetchInt(6); //damage dealt session
		kills = results.FetchInt(7); //kills
		killssession = results.FetchInt(8); //kills session
		deaths = results.FetchInt(9); //deaths
		deathssession = results.FetchInt(10); //deaths session
		bombsreset = results.FetchInt(11); //bombs reset
		bombsresetsession = results.FetchInt(12); //bombs reset session
		sacrifices = results.FetchInt(13); //sacrifices
		sacrificessession = results.FetchInt(14); //sacrifices session
		results.FetchString(15, lastkilledname, sizeof(lastkilledname)); //last client killed
		results.FetchString(16, lastusedweapon, sizeof(lastusedweapon)); //using weapon
		results.FetchString(17, killedbyname, sizeof(killedbyname)); //last client that killed
		results.FetchString(18, killedbyweapon, sizeof(killedbyweapon)); //using weapon
	}
	CPrintToChat(client,"\x07AAAAAA[CORE] Showing stats of %s   [%s] || SteamID: %i ", name, class, steamID);
	CPrintToChat(client,"{white}Damage Dealt: %i (Session: %i) || Kills: %i (Session: %i) || Deaths: %i (Session: %i) || Bombs Reset: %i (Session: %i)", damagedealt, damagedealtsession, kills, killssession, deaths, deathssession, bombsreset, bombsresetsession);
	CPrintToChat(client,"Sacrifices: %i(Session:%i) || Killed %s (using %s) || Last killed by: %s (using %s)", sacrifices, sacrificessession, lastkilledname, lastusedweapon, killedbyname, killedbyweapon);
}

public void OnConfigsExecuted(){
	if (!FB_Database){
		Database.Connect(Database_OnConnect, "ass");
	}
}

//DB setup
public void Database_OnConnect(Database db, const char[] error, any data){
	if (!db){
		LogError("Could not connect to the database: %s", error);
		return;
	}
	char buffer[64];
	db.Driver.GetIdentifier(buffer, sizeof(buffer));
	if (!StrEqual(buffer, "mysql", false)){
		delete db;
		LogError("Could not connect to the database: expected mysql database.");
		return;
	}
	FB_Database = db;
	FB_Database.Query(Database_FastQuery, "CREATE TABLE IF NOT EXISTS ass_activity(name TEXT, steamid INT UNSIGNED, date DATE, seconds INT UNSIGNED DEFAULT '0', class TEXT DEFAULT 'na', damagedealt INT UNSIGNED DEFAULT '0', damagedealtsession INT UNSIGNED DEFAULT '0', kills INT UNSIGNED DEFAULT '0', killssession INT UNSIGNED DEFAULT '0', deaths INT UNSIGNED DEFAULT '0', deathssession INT UNSIGNED DEFAULT '0', bombsreset INT UNSIGNED DEFAULT '0', bombsresetsession INT UNSIGNED DEFAULT '0', sacrifices INT UNSIGNED DEFAULT '0', sacrificessession INT UNSIGNED DEFAULT '0', lastkilledname TEXT DEFAULT 'na', lastweaponused TEXT DEFAULT 'na', killedbyname TEXT DEFAULT 'na', killedbyweapon TEXT DEFAULT 'na', soundprefs INT UNSIGNED DEFAULT '3', PRIMARY KEY (steamid));");
}

//Database Fastquery Manager
public void Database_FastQuery(Database db, DBResultSet results, const char[] error, any data){
	if (!results){	
		LogError("Failed to query database: %s", error);
	}
}
public void Database_MergeDataError(Database db, any data, int numQueries, const char[] error, int failIndex, any[] queryData){
	LogError("Failed to query database (transaction): %s", error);
}

//When a client leaves
public void OnClientDisconnect(int client){
	if (!FB_Database)
	{
		return;
	}
	
	int steamID = GetSteamAccountID(client);
	if (!steamID || steamID<=10000){
		return;
	}
	char query[256];
	char clientName[128];
	GetClientInfo(client, "name", clientName, 128);
	Format(query, sizeof(query), "INSERT INTO ass_activity (name, steamid, date, seconds) VALUES ('%s', %d, CURRENT_DATE, %d) ON DUPLICATE KEY UPDATE name = '%s', seconds = seconds + VALUES(seconds);", clientName, steamID, GetClientMapTime(client), clientName);
	PrintToServer("%s", query);
	FB_Database.Query(Database_FastQuery, query);
}

//Calculate time spent on server in seconds
int GetClientMapTime(int client){
	float clientTime = GetClientTime(client), gameTime = GetGameTime();
	if (clientTime > gameTime)
	{
		return RoundToZero(gameTime);
	}
	
	return RoundToZero(clientTime);
}

//Clientprefs built in menu
public void FartsysSNDSelected(int client, CookieMenuAction action, any info, char[] buffer, int maxlen) {
	if (action == CookieMenuAction_SelectOption)
	{
		ShowFartsyMenu(client);
	}
}

// When a new client joins
public void OnClientPutInServer(int client){
	if(!IsFakeClient(client)){
		if (!FB_Database){//Use defaults if no database
			PrintToServer("No database detected, setting soundPreference for %N to default.", client);
			soundPreference[client] = GetConVarInt(cvarSNDDefault);
			return;
		}
		int steamID = GetSteamAccountID(client);
		if (!steamID || steamID<=10000){	
			return;
		}
		else{
			char query[1024];
			Format(query, sizeof(query), "INSERT INTO ass_activity (name, steamid, date, damagedealtsession, killssession, deathssession, bombsresetsession, sacrificessession) VALUES ('%N', %d, CURRENT_DATE, 0, 0, 0, 0, 0) ON DUPLICATE KEY UPDATE name = '%N', damagedealtsession = 0, killssession = 0, deathssession = 0, bombsresetsession = 0, sacrificessession = 0;", client, steamID, client);
			FB_Database.Query(Database_FastQuery, query);

			DataPack pk = new DataPack();
			pk.WriteCell(client ? GetClientUserId(client) : 0);
			pk.WriteString("steamid");
			char queryID[256];
			Format(queryID, sizeof(queryID), "SELECT soundprefs from ass_activity WHERE steamid = '%d';", steamID);
			FB_Database.Query(SQL_SNDPrefs, queryID, pk);
		}
	}
	else{
		soundPreference[client] = 0;
	}
}

//Get client sound prefs
public void SQL_SNDPrefs(Database db, DBResultSet results, const char[] error, any data){
	DataPack pk = view_as<DataPack>(data);
	pk.Reset();
	int userId = pk.ReadCell();
	char steamId[64];
	pk.ReadString(steamId, sizeof(steamId));
	delete pk;
	int client = userId ? GetClientOfUserId(userId) : 0;
	bool validClient = !userId || client;
	if (!results){
		LogError("Failed to query database: %s", error);
		return;
	}
	if (!validClient){
		return;
	}
	if (results.FetchRow()){
		soundPreference[client] = results.FetchInt(0); //Set it
		//PrintToServer("Client %N soundPreference was set to %i", client, soundPreference[client]);
	}
}

//Send client sound menu
public void ShowFartsyMenu(int client){
    Menu menu = new Menu(MenuHandlerFartsy, MENU_ACTIONS_DEFAULT);
    char buffer[100];
    menu.SetTitle("FartsysAss Sound Menu");
    menu.AddItem(buffer, "Disable ALL");
    menu.AddItem(buffer, "Music Only");
    menu.AddItem(buffer, "Sound Effects Only");
    menu.AddItem(buffer, "Enable ALL");
    menu.Display(client, 20);
    menu.ExitButton = true;
}

//Create menu
public Action Command_Sounds(int client, int args){
	int steamID = GetSteamAccountID(client);
	if (!steamID || steamID<=10000){	
		return Plugin_Handled;
	}
	else{
		DataPack pk = new DataPack();
		pk.WriteCell(client ? GetClientUserId(client) : 0);
		pk.WriteString("steamid");
		char queryID[256];
		Format(queryID, sizeof(queryID), "SELECT soundprefs from ass_activity WHERE steamid = '%d';", steamID);
		FB_Database.Query(SQL_SNDPrefs, queryID, pk);
		ShowFartsyMenu(client);
		switch(soundPreference[client]){
			case 0:{
				PrintToChat(client, "Sounds are currently DISABLED.");
			}
			case 1:{
				PrintToChat(client, "Sounds are currently MUSIC ONLY.");
			}
			case 2:{
				PrintToChat(client, "Sounds are currently SOUND EFFECTS ONLY.");
			}
			case 3:{
				PrintToChat(client, "Sounds are currently ALL ON.");
			}
			case 4:{
				PrintToChat(client, "Somehow your sound preference was stored as non-existent 5... Please configure your sounds.");
			}
		}
		return Plugin_Handled;
	}
}

//  This selects or disables the sounds
public int MenuHandlerFartsy(Menu menu, MenuAction action, int param1, int param2){
	if(action == MenuAction_Select)
	{
		char query[256];
		int steamID = GetSteamAccountID(param1);
		if (!FB_Database || !steamID){
			return;
		}
		else{
			Format(query, sizeof(query), "UPDATE ass_activity SET soundprefs = '%i' WHERE steamid = '%d';", param2, steamID);
			FB_Database.Query(Database_FastQuery, query);
			soundPreference[param1] = param2;
			Command_Sounds(param1, 0);
		}
	}
	else if(action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

//Fartsy's A.S.S
public Action Command_SacrificePointShop(int client, int args){
	ShowFartsysAss(client);
	return Plugin_Handled;
}

//Fartsy's A.S.S
public void ShowFartsysAss(int client){
	if(sacPoints<=9 || !isWave){
		if(isWave){
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {red}ERROR: You do not have enough sacPoints. This command requires at least {white}10{red}. You have {white}%i{red}.", sacPoints);
		}
		else{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}The sacrificial points counter is currently at %i of %i maximum for this wave.", sacPoints, sacPointsMax);
		}
	}
	else{
		Menu menu = new Menu(MenuHandlerFartsysAss, MENU_ACTIONS_DEFAULT);
		char buffer[100];
		menu.SetTitle("Fartsy's Annihilation Supply Shop");
		menu.ExitButton = true;
		switch(sacPoints){
			case 10,11,12,13,14,15,16,17,18,19:{
				menu.AddItem(buffer, "[10] Kissone Bath Salts");
				menu.Display(client, 20);
			}
			case 20,21,22,23,24,25,26,27,28,29:{
				menu.AddItem(buffer, "[10] Kissone Bath Salts");
				menu.AddItem(buffer, "[20] Instant Fat Man");
				menu.Display(client, 20);
			}
			case 30,31,32,33,34,35,36,37,38,39:{
				menu.AddItem(buffer, "[10] Kissone Bath Salts");
				menu.AddItem(buffer, "[20] Instant Fat Man");
				menu.AddItem(buffer, "[30] Summon Goobbue or Kirby");
				menu.Display(client, 20);
			}
			case 40,41,42,43,44,45,46,47,48,49:{
				menu.AddItem(buffer, "[10] Kissone Bath Salts");
				menu.AddItem(buffer, "[20] Instant Fat Man");
				menu.AddItem(buffer, "[30] Summon Goobbue or Kirby");
				menu.AddItem(buffer, "[40] Explosives Paradise");
				menu.Display(client, 20);
			}
			case 50,51,52,53,54,55,56,57,58,59:{
				menu.AddItem(buffer, "[10] Kissone Bath Salts");
				menu.AddItem(buffer, "[20] Instant Fat Man");
				menu.AddItem(buffer, "[30] Summon Goobbue or Kirby");
				menu.AddItem(buffer, "[40] Explosives Paradise");
				menu.AddItem(buffer, "[50] Ass Gas");
				menu.AddItem(buffer, "[50] Banish Tornadoes");
				menu.Display(client, 20);
			}
			case 60,61,62,63,64,65,66,67,68,69:{
				menu.AddItem(buffer, "[10] Kissone Bath Salts");
				menu.AddItem(buffer, "[20] Instant Fat Man");
				menu.AddItem(buffer, "[30] Summon Goobbue or Kirby");
				menu.AddItem(buffer, "[40] Explosives Paradise");
				menu.AddItem(buffer, "[50] Ass Gas");
				menu.AddItem(buffer, "[50] Banish Tornadoes");
				menu.AddItem(buffer, "[60] Total Atomic Annihilation");
				menu.Display(client, 20);
			}
			case 70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99:{
				menu.AddItem(buffer, "[10] Kissone Bath Salts");
				menu.AddItem(buffer, "[20] Instant Fat Man");
				menu.AddItem(buffer, "[30] Summon Goobbue or Kirby");
				menu.AddItem(buffer, "[40] Explosives Paradise");
				menu.AddItem(buffer, "[50] Ass Gas");
				menu.AddItem(buffer, "[50] Banish Tornadoes");
				menu.AddItem(buffer, "[60] Total Atomic Annihilation");
				menu.AddItem(buffer, "[70] Meteorites");
				menu.AddItem(buffer, "[75] 150,000 UbUp Cash");
				menu.Display(client, 20);
			}
			case 100:{
				menu.AddItem(buffer, "[10] Kissone Bath Salts");
				menu.AddItem(buffer, "[20] Instant Fat Man");
				menu.AddItem(buffer, "[30] Summon Goobbue or Kirby");
				menu.AddItem(buffer, "[40] Explosives Paradise");
				menu.AddItem(buffer, "[50] Ass Gas");
				menu.AddItem(buffer, "[50] Banish Tornadoes");
				menu.AddItem(buffer, "[60] Total Atomic Annihilation");
				menu.AddItem(buffer, "[70] Meteorites");
				menu.AddItem(buffer, "[75] 150,000 UbUp Cash");
				menu.AddItem(buffer, "[100] Professor Fartsalot");
				menu.Display(client, 20);
			}
		}
	}
}

//Also Fartsy's A.S.S
public int MenuHandlerFartsysAss(Menu menu, MenuAction action, int param1, int param2){
	if(action == MenuAction_Select)
	{
		//PrintToChatAll("Got %i", param2);
		switch(param2){
			case 0:{
				if (sacPoints <=9){
					return;
				}
				else{
					ServerCommand("fb_operator 30");
				}
			}
			case 1:{
				if (sacPoints <=19){
					return;
				}
				else{
					ServerCommand("fb_operator 31");
				}
			}
			case 2:{
				if (sacPoints <=29){
					return;
				}
				else{
					ServerCommand("fb_operator 32");
				}
			}
			case 3:{
				if (sacPoints <=39){
					return;
				}
				else{
					ServerCommand("fb_operator 33");
				}
			}
			case 4,5:{
				if (sacPoints <=49){
					return;
				}
				else{
					ServerCommand("fb_operator 34");
				}
			}
			case 6:{
				if (sacPoints <=59){
					return;
				}
				else{
					ServerCommand("fb_operator 36");
				}
			}
			case 7:{
				if (sacPoints <=69){
					return;
				}
				else{
					ServerCommand("fb_operator 37");
				}

			}
			case 8:{
				if (sacPoints <=74){
					return;
				}
				else{
					ServerCommand("fb_operator 38");
				}

			}
			case 9:{
				if (sacPoints <=99){
					return;
				}
				else{
					ServerCommand("fb_operator 39");
				}

			}
		}
	}
	else if(action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

//Now that command definitions are done, lets make some things happen.
public void OnMapStart(){
    FireEntityInput("rain", "Alpha", "0", 0.0);
    ServerCommand("fb_operator 1002");
    CreateTimer(1.0, SelectAdminTimer);
}

//Repeating Timers
//Adverts for tips/tricks
public Action PerformAdverts(Handle timer){
	if (!isWave){
		CreateTimer (180.0, PerformAdverts);
		int i = GetRandomInt(1, 7);
		switch (i){
			case 1:{
				CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}We have a Discord server: {forestgreen}https://discord.com/invite/SkHaeMH");
			}
			case 2:{
				CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}Remember to buy your upgrades using {forestgreen}!buy");
			}
			case 3:{
				//CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}If this is your first time here, please run console command {forestgreen}snd_restart {white}for safety. Otherwise, you might {red}crash{white}!");
				CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}You may invoke {forestgreen}!sounds {white}to configure what sounds you hear from the plugin, or {forestgreen}!stats{white} to see your stats.");
			}
			case 4:{
				CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}Advanced users may quick buy upgrades using {forestgreen}!qbuy");
			}
			case 5:{
				CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}Don't forget to buy {forestgreen}protection upgrades {white}and {forestgreen}ammo regen{white}(if applicable)!");
			}
            case 6:{
                CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}TIP: As a {red}DEFENDER{white}, pushing your team's {forestgreen}payload {white}is crucial to wrecking havoc on the robots!");
            }
            case 7:{
                CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}Remember, if someone is being abusive, you may always invoke {forestgreen}!calladmin{white}.");
            }
            case 8:{
                CPrintToChatAll("{darkviolet}[{aqua}CORE{darkviolet}] {white}You may always invoke {forestgreen}!return{white} to be returned to spawn.");
            }
		}
	}
	return Plugin_Stop;
}

//Adverts for wave information
public Action PerformWaveAdverts(Handle timer){
	if (isWave){
		CreateTimer(2.5, PerformWaveAdverts);
		for(int i=1;i<=MaxClients;i++)
    	{
			switch (bombStatus){
				case 8,16,24,32,40,48,56,64:{
					if(TornadoWarningIssued && IsClientInGame(i)){
						if(bombProgression){
							PrintHintText(i, "Bomb Status: MOVING (%i/%i) || Sacrifice Points: %i/%i \nCurrent song: %s \n\n[TORNADO WARNING]", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
							StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
						}
						else{
							PrintHintText(i, "Bomb Status: READY (%i/%i) || Sacrifice Points: %i/%i \nCurrent song: %s \n\n[TORNADO WARNING]", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
							StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
						}
					}
					else if(bombProgression && IsClientInGame(i)){
						PrintHintText(i, "Bomb Status: MOVING (%i/%i) || Sacrifice Points: %i/%i \nCurrent song: %s", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
						StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
					}
					else if(IsClientInGame(i)){
						PrintHintText(i, "Bomb Status: READY (%i/%i) || Sacrifice Points: %i/%i \nCurrent song: %s", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
						StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
					}
				}
				case 0,1,2,3,4,5,6,7,9,10,11,12,13,14,15,17,18,19,20,21,22,23,25,26,27,28,29,30,31,33,34,35,36,37,38,39,41,42,43,44,45,46,47,49,50,51,52,53,54,55,57,58,59,60,61,62,63:{
					if(TornadoWarningIssued && IsClientInGame(i)){
						PrintHintText(i, "Bomb Status: %i/%i || Sacrifice Points: %i/%i \nCurrent song: %s \n\n[TORNADO WARNING]", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
						StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");	
					}
					else if(IsClientInGame(i)){
						PrintHintText(i, "Bomb Status: %i/%i || Sacrifice Points: %i/%i \nCurrent song: %s", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
						StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
					}
				}
			}
    	}
	}
	return Plugin_Stop;
}

//Feature admin timer
public Action SelectAdminTimer(Handle timer){
	if (isWave){
		return Plugin_Stop;
	}
	else{
		ServerCommand("fb_operator 1002");
		float f = GetRandomFloat(40.0, 120.0);
		CreateTimer(f, SelectAdminTimer);
		return Plugin_Handled;
	}
}

//Brute Justice Timer
public Action OnslaughterATK(Handle timer){
	if (waveFlags != 1){
		return Plugin_Stop;
	}
	else{
		float f = GetRandomFloat(5.0, 7.0);
		CreateTimer(f, OnslaughterATK);
		FireEntityInput("BruteJusticeDefaultATK", "FireMultiple", "3", 5.0);
		int i = GetRandomInt(1,10);
		switch(i){
			case 1,6:{
				FireEntityInput("BruteJusticeLaserParticle", "Start", "", 0.0);
				CustomSoundEmitter(OnslaughterLaserSND, SFXSNDLVL, false);
				FireEntityInput("BruteJusticeLaser", "TurnOn", "", 1.40);
				FireEntityInput("BruteJusticeLaserHurtAOE", "Enable", "", 1.40);
				FireEntityInput("BruteJusticeLaserParticle", "Stop", "", 3.00);
				FireEntityInput("BruteJusticeLaser", "TurnOff", "", 3.25);
				FireEntityInput("BruteJusticeLaserHurtAOE", "Disable", "", 3.25);
			}
			case 2,8:{
				FireEntityInput("BruteJustice", "FireUser1", "", 0.0);
			}
			case 3,7:{
				FireEntityInput("BruteJusticeFlameParticle", "Start", "", 0.0);
				FireEntityInput("BruteJusticeFlamethrowerHurtAOE", "Enable", "", 0.0);
				CustomSoundEmitter(OnslaughterFlamePreATK, SFXSNDLVL, false);
				FireEntityInput("SND.BruteJusticeFlameATK", "PlaySound", "", 1.25);
				FireEntityInput("BruteJusticeFlamethrowerHurtAOE", "Disable", "", 5.0);
				FireEntityInput("BruteJusticeFlameParticle", "Stop", "", 5.0);
				FireEntityInput("SND.BruteJusticeFlameATK", "FadeOut", ".25", 5.0);
				CreateTimer(5.0, TimedOperator, 60);
				FireEntityInput("SND.BruteJusticeFlameATK", "StopSound", "", 5.10);
			}
			case 4:{
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 0.0);
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 3.0);
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 5.0);
			}
			case 5:{
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "50", 0.0);
			}
			case 9:{
				FireEntityInput("BruteJusticeRocketSpammer", "FireOnce", "", 0.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireOnce", "", 5.00);
			}
			case 10:{
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 0.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 3.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 5.00);
			}
		}
	}
	return Plugin_Stop;
}

//Sephiroth Timer
public Action SephATK(Handle timer){
	if (waveFlags != 2){
		return Plugin_Stop;
	}
	else{
		float f = GetRandomFloat(5.0, 7.0);
		CreateTimer(f, SephATK);
		FireEntityInput("SephDefaultATK", "FireMultiple", "3", 5.0);
		int i = GetRandomInt(1,10);
		switch(i){
			case 1,6:{
			}
			case 2,8:{
				FireEntityInput("BruteJustice", "FireUser1", "", 0.0);
			}
			case 3,7:{
				FireEntityInput("BruteJusticeFlameParticle", "Start", "", 0.0);
				FireEntityInput("BruteJusticeFlamethrowerHurtAOE", "Enable", "", 0.0);
				CustomSoundEmitter(OnslaughterFlamePreATK, SFXSNDLVL, false);
				FireEntityInput("SND.BruteJusticeFlameATK", "PlaySound", "", 1.25);
				FireEntityInput("BruteJusticeFlamethrowerHurtAOE", "Disable", "", 5.0);
				FireEntityInput("BruteJusticeFlameParticle", "Stop", "", 5.0);
				FireEntityInput("SND.BruteJusticeFlameATK", "FadeOut", ".25", 5.0);
				CreateTimer(5.0, TimedOperator, 60);
				FireEntityInput("SND.BruteJusticeFlameATK", "StopSound", "", 5.10);
			}
			case 4:{
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 0.0);
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 3.0);
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 5.0);
			}
			case 5:{
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "50", 0.0);
			}
			case 9:{
				FireEntityInput("BruteJusticeRocketSpammer", "FireOnce", "", 0.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireOnce", "", 5.00);
			}
			case 10:{
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 0.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 3.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 5.00);
			}
		}
	}
	return Plugin_Stop;
}

//Shark Timer
public Action SharkTimer(Handle timer){
	if (canSENTShark){
		FireEntityInput("SentSharkTorpedo", "ForceSpawn", "", 0.0);
		float f = GetRandomFloat(2.0, 5.0);
		CreateTimer(f, SharkTimer);
		int i = GetRandomInt(1, 8);
		switch(i){
			case 1:{
				CustomSoundEmitter(SHARKSND01, SFXSNDLVL, false);
			}
			case 2:{
				CustomSoundEmitter(SHARKSND02, SFXSNDLVL, false);
			}
			case 3:{
				CustomSoundEmitter(SHARKSND03, SFXSNDLVL, false);
			}
			case 4:{
				CustomSoundEmitter(SHARKSND04, SFXSNDLVL, false);
			}
			case 5:{
				CustomSoundEmitter(SHARKSND05, SFXSNDLVL, false);
			}
			case 6:{
				CustomSoundEmitter(SHARKSND06, SFXSNDLVL, false);
			}
			case 7:{
				CustomSoundEmitter(SHARKSND07, SFXSNDLVL, false);
			}
			case 8:{
				CustomSoundEmitter(SHARKSND08, SFXSNDLVL, false);
			}
		}
		return Plugin_Handled;
	}
	return Plugin_Stop;
}

//Storm
public Action RefireStorm(Handle timer){
	if (isWave){
		float f = GetRandomFloat(7.0, 17.0);
		CreateTimer(f, RefireStorm);
		ServerCommand("fb_operator 1003");
		int Thunder = GetRandomInt(1, 16);
		switch (Thunder){
			case 1:{
				CustomSoundEmitter(GLOBALTHUNDER01, SFXSNDLVL, false);
				FireEntityInput("LightningHurt00", "Enable", "", 0.0),
				FireEntityInput("LightningHurt00",  "Disable", "", 0.07);
			}
			case 2:{
				CustomSoundEmitter(GLOBALTHUNDER02, SFXSNDLVL, false);
				FireEntityInput("LightningHurt01", "Enable", "", 0.0),
				FireEntityInput("LightningHurt01",  "Disable", "", 0.07);
			}
			case 3:{
				CustomSoundEmitter(GLOBALTHUNDER03, SFXSNDLVL, false);
				FireEntityInput("LightningHurt02", "Enable", "", 0.0),
				FireEntityInput("LightningHurt02",  "Disable", "", 0.07);
			}
			case 4:{
				CustomSoundEmitter(GLOBALTHUNDER04, SFXSNDLVL, false);
				FireEntityInput("LightningHurt03", "Enable", "", 0.0),
				FireEntityInput("LightningHurt03",  "Disable", "", 0.07);
			}
			case 5:{
				CustomSoundEmitter(GLOBALTHUNDER05, SFXSNDLVL, false);
				FireEntityInput("LightningHurt04", "Enable", "", 0.0),
				FireEntityInput("LightningHurt04",  "Disable", "", 0.07);
			}
			case 6:{
				CustomSoundEmitter(GLOBALTHUNDER06, SFXSNDLVL, false);
				FireEntityInput("LightningHurt05", "Enable", "", 0.0),
				FireEntityInput("LightningHurt05",  "Disable", "", 0.07);
			}
			case 7:{
				CustomSoundEmitter(GLOBALTHUNDER07, SFXSNDLVL, false);
				FireEntityInput("LightningHurt06", "Enable", "", 0.0),
				FireEntityInput("LightningHurt06",  "Disable", "", 0.07);
			}
			case 8:{
				CustomSoundEmitter(GLOBALTHUNDER08, SFXSNDLVL, false);
				FireEntityInput("LightningHurt07", "Enable", "", 0.0),
				FireEntityInput("LightningHurt07",  "Disable", "", 0.07);
			}
			case 9:{
				CustomSoundEmitter(GLOBALTHUNDER01, SFXSNDLVL, false);
				FireEntityInput("LightningHurt08", "Enable", "", 0.0),
				FireEntityInput("LightningHurt08",  "Disable", "", 0.07);
			}
			case 10:{
				CustomSoundEmitter(GLOBALTHUNDER02, SFXSNDLVL, false);
				FireEntityInput("LightningHurt09", "Enable", "", 0.0),
				FireEntityInput("LightningHurt09",  "Disable", "", 0.07);
			}
			case 11:{
				CustomSoundEmitter(GLOBALTHUNDER03, SFXSNDLVL, false);
				FireEntityInput("LightningHurt0A", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0A",  "Disable", "", 0.07);
			}
			case 12:{
				CustomSoundEmitter(GLOBALTHUNDER04, SFXSNDLVL, false);
				FireEntityInput("LightningHurt0B", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0B",  "Disable", "", 0.07);
			}
			case 13:{
				CustomSoundEmitter(GLOBALTHUNDER05, SFXSNDLVL, false);
				FireEntityInput("LightningHurt0C", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0C",  "Disable", "", 0.07);
			}
			case 14:{
				CustomSoundEmitter(GLOBALTHUNDER06, SFXSNDLVL, false);
				FireEntityInput("LightningHurt0D", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0D",  "Disable", "", 0.07);
			}
			case 15:{
				CustomSoundEmitter(GLOBALTHUNDER07, SFXSNDLVL, false);
				FireEntityInput("LightningHurt0E", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0E",  "Disable", "", 0.07);
			}
			case 16:{
				CustomSoundEmitter(GLOBALTHUNDER08, SFXSNDLVL, false);
				FireEntityInput("LightningHurt0F", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0F",  "Disable", "", 0.07);
			}
		}
	}
	return Plugin_Handled;
}

//SpecTimer
public Action SpecTimer(Handle timer){
	if(isWave){
		int i = GetRandomInt(1, 6);
		switch (i){
			case 1:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.Goobbue", "Enable", "", 0.1),
				CPrintToChatAll("{fullblue} Legend tells of a Goobbue sproutling somewhere nearby...");
			}
			case 2:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.Waffle", "Enable", "", 0.1),
				CPrintToChatAll("{turquoise}Don't eat THESE...");
			}
			case 3:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.Burrito", "Enable", "", 0.1),
				CPrintToChatAll("{darkred}What's worse than Taco Bell?");
			}
			case 4:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.Shroom", "Enable", "", 0.1),
				CPrintToChatAll("{red}M{white}A{red}R{white}I{red}O {white}time!");
			}
			case 5:{
				FireEntityInput("Spec*", "Disable", "", 0.0);
				FireEntityInput("Spec.BlueBall", "Enable", "", 0.1);
				CPrintToChatAll("{white}A {fullblue}Blue Ball {white}lurks from afar...");
			}
			case 6:{
				FireEntityInput("Spec*", "Enable", "", 0.0),
				CPrintToChatAll("{magenta}Is it a miracle? Is it {red}chaos{magenta}? WHO KNOWWWWWWS");
			}
		}
		float spDelay = GetRandomFloat(10.0, 30.0);
		CreateTimer(spDelay, SpecTimer);
	}
	return Plugin_Stop;
}

//SENTMeteor (Scripted Entity Meteors)
public Action SENTMeteorTimer(Handle timer){
	if(canSENTMeteors){
		CreateTimer(5.0, SENTMeteorTimer);
		int i = GetRandomInt(1, 8);
		switch(i){
			case 1:{
				FireEntityInput("FB.SentMeteor01", "ForceSpawn", "", 0.0);
			}
			case 2:{
				FireEntityInput("FB.SentMeteor02", "ForceSpawn", "", 0.0);
			}
			case 3:{
				FireEntityInput("FB.SentMeteor03", "ForceSpawn", "", 0.0);
			}
			case 4:{
				FireEntityInput("FB.SentMeteor04", "ForceSpawn", "", 0.0);
			}
			case 5:{
				FireEntityInput("FB.SentMeteor05", "ForceSpawn", "", 0.0);
			}
		}
	}
	return Plugin_Stop;
}

//SENTMeteor Timeout
public Action DisableSENTMeteors(Handle timer){
	canSENTMeteors = false;
	return Plugin_Stop;
}

//SENTNukes (Scripted Entity Nukes)
public Action SENTNukeTimer(Handle timer){
	if(canSENTNukes){
		FireEntityInput("FB.DropNuke", "PlaySound", "", 0.0);
		int i = GetRandomInt(1, 8);
		switch(i){
			case 1:{
				FireEntityInput("FB.SentNuke01", "ForceSpawn", "", 0.0);
			}
			case 2:{
				FireEntityInput("FB.SentNuke02", "ForceSpawn", "", 0.0);
			}
			case 3:{
				FireEntityInput("FB.SentNuke03", "ForceSpawn", "", 0.0);
			}
			case 4:{
				FireEntityInput("FB.SentNuke04", "ForceSpawn", "", 0.0);
			}
			case 5:{
				FireEntityInput("FB.SentNuke05", "ForceSpawn", "", 0.0);
			}
		}
		float f = GetRandomFloat(1.5, 3.0);
		CreateTimer(f, SENTNukeTimer);
	}
	return Plugin_Stop;
}

//SENTNukes Timeout
public Action DisableSENTNukes(Handle timer){
	canSENTNukes = false;
	return Plugin_Stop;
}

//SENTStars (Scripted Entity Stars)
public Action SENTStarTimer(Handle timer){
	if(canSENTStars){
		int i = GetRandomInt(1, 5);
		switch(i){
			case 1:{
				FireEntityInput("FB.SentStar01", "ForceSpawn", "", 0.0);
			}
			case 2:{
				FireEntityInput("FB.SentStar02", "ForceSpawn", "", 0.0);
			}
			case 3:{
				FireEntityInput("FB.SentStar03", "ForceSpawn", "", 0.0);
			}
			case 4:{
				FireEntityInput("FB.SentStar04", "ForceSpawn", "", 0.0);
			}
			case 5:{
				FireEntityInput("FB.SentStar05", "ForceSpawn", "", 0.0);
			}
		}
		float f = GetRandomFloat(0.75, 1.5);
		CreateTimer(f, SENTStarTimer);
	}
	return Plugin_Stop;
}

//SENTStars Timeout
public Action SENTStarDisable(Handle timer){
	canSENTStars = false;
	return Plugin_Handled;
}

//Crusader Incoming Timer for Crusader
public Action CRUSADERINCOMING(Handle timer){
	if(!crusader || INCOMINGDISPLAYED>17){
		INCOMINGDISPLAYED = 0;
		return Plugin_Stop;
	}
	else{
		INCOMINGDISPLAYED++;
		FireEntityInput("FB.INCOMING", "Display", "", 0.0);
		CreateTimer(1.75, CRUSADERINCOMING);
	}
	return Plugin_Stop;
}

//Halloween Bosses
public Action HWBosses(Handle timer){
	if(isWave && canHWBoss){
		int i = GetRandomInt(1, 10);
		switch(i){
			case 1:{
				FireEntityInput("hhh_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 2:{
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 3:{
				
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0),
				FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
				FireEntityInput("SkeleSpawner", "Disable", "", 10.0);
			}
			case 4:{
				FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
				FireEntityInput("SkeleSpawner", "Disable", "", 10.0);
			}
			case 5:{
				FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 6:{
				FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 7:{
				FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0);
			}
			case 8:{
				FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
				FireEntityInput("SkeleSpawner", "Disable", "", 30.0);
			}
			case 9:{
				FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
				FireEntityInput("SkeleSpawner", "Disable", "", 60.0),
				FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 10:{
				FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0);
			}
		}
		canHWBoss = false;
		CreateTimer(60.0, HWBossesRefire);
	}
	return Plugin_Stop;
}

//Repeat HWBosses Timer
public Action HWBossesRefire(Handle timer){
	if (isWave){
		float hwn = GetRandomFloat(HWNMin, HWNMax);
		CreateTimer(hwn, HWBosses);
	}
	return Plugin_Stop;
}

//SacPoints (Add points to Sacrifice Points occasionally)
public Action SacrificePointsTimer(Handle timer){
	if (isWave && (sacPoints < sacPointsMax)){
		sacPoints++;
		float f = GetRandomFloat(5.0, 30.0);
		CreateTimer(f, SacrificePointsTimer);
	}
	return Plugin_Stop;
}

//Track SacPoints and update entities every 0.1 seconds
public Action SacrificePointsUpdater(Handle timer){
	if (isWave){
		CreateTimer(0.1, SacrificePointsUpdater);
		if (sacPoints > sacPointsMax){
			sacPoints = sacPointsMax;
		}
	}
	return Plugin_Stop;
}

//BombStatus (Add points to Bomb Status occasionally)
public Action BombStatusAddTimer(Handle timer){
	if (isWave && (bombStatus < bombStatusMax)){
		bombStatus++;
		float f = GetRandomFloat(10.0, 45.0);
		PrintToServer("[DEBUG] Creating a %f timer to give bomb status an update. Current target is %i", f, bombStatus);
		CreateTimer(f, BombStatusAddTimer);
	}
	return Plugin_Stop;
}

//Track bombStatus and update entities every 0.1 seconds
public Action BombStatusUpdater(Handle timer){
	if (isWave){
		CreateTimer(0.1, BombStatusUpdater);
		if (bombStatus<bombStatusMax){
			switch (bombStatus){
				case 8:{
					bombStatusMax = 8;
					explodeType = 1;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					FireEntityInput("Bombs.FreedomBomb", "Enable", "", 0.0),
					CustomSoundEmitter(TRIGGERSCORE, SFXSNDLVL, false),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's {red}FREEDOM BOMB {forestgreen}is now available for deployment!");
				}
				case 16:{
					bombStatusMax = 16;
					explodeType = 2;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.ElonBust", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					CustomSoundEmitter(TRIGGERSCORE, SFXSNDLVL, false),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's {red}ELON BUST {forestgreen}is now available for deployment!");
				}
				case 24:{
					bombStatusMax = 24;
					explodeType = 3;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.BathSalts", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					CustomSoundEmitter(TRIGGERSCORE, SFXSNDLVL, false),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's {red}BATH SALTS {forestgreen}are now available for deployment!");
				}
				case 32:{
					bombStatusMax = 32;
					explodeType = 4;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.FallingStar", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					CustomSoundEmitter(TRIGGERSCORE, SFXSNDLVL, false),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's \x07FFFF00FALLING STAR{forestgreen} is now available for deployment!");
				}
				case 40:{
					bombStatusMax = 40;
					explodeType = 5;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.MajorKong", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					CustomSoundEmitter(TRIGGERSCORE, SFXSNDLVL, false),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's {red}MAJOR KONG {forestgreen}is now available for deployment!");
				}
				case 48:{
					bombStatusMax = 48;
					explodeType = 6;
					canSENTShark = true;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.SharkTorpedo", "Enable", "", 0.0),
					FireEntityInput("BombExploShark", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					CustomSoundEmitter(TRIGGERSCORE, SFXSNDLVL, false),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's {aqua}SHARK {forestgreen}is now available for deployment!");
				}
				case 56:{
					bombStatusMax = 56;
					explodeType = 7;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.FatMan", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					CustomSoundEmitter(TRIGGERSCORE, SFXSNDLVL, false),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's {orange}FAT MAN {forestgreen}is now available for deployment!");
				}
				case 64:{
					bombStatusMax = 64;
					explodeType = 8;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.Hydrogen", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					CustomSoundEmitter(TRIGGERSCORE, SFXSNDLVL, false),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's {red}HYDROGEN {forestgreen}is now available for deployment!");
				}
			}
		}
		else if (bombStatus>bombStatusMax)
		{
			bombStatus = bombStatusMax-4;
		}
		return Plugin_Continue;
	}
	return Plugin_Stop;
}

//RobotLaunchTimer (Randomly fling robots)
public Action RobotLaunchTimer(Handle timer){
	if (isWave){
		FireEntityInput("FB.RobotLauncher", "Enable", "", 0.0),
		FireEntityInput("FB.RobotLauncher", "Disable", "", 7.5);
		float f = GetRandomFloat(5.0, 30.0);
		CreateTimer(f, RobotLaunchTimer);
	}
	return Plugin_Stop;
}

//Command action definitions
//Get current song
public Action Command_GetCurrentSong(int client, int args){
	PrintToChat(client, "The current song is: %s", songName);
	return Plugin_Handled;
}

//Determine which bomb has been recently pushed and tell the client if a bomb is ready or not.
public Action Command_FBBombStatus(int client, int args){
	CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}The bomb status is currently %i, with a max of %i", bombStatus, bombStatusMax);
	switch(bombStatus){
		case 0,1,2,3,4,5,6,7:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Bombs are {red}NOT READY{white}!");
		}
		case 8:{
			if(bombProgression){
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team is currently pushing a {red}FREEDOM BOMB {forestgreen}!");
			}
			else{
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team has not deployed any bombs, however: Your team's {red}FREEDOM BOMB {forestgreen}is available for deployment!");
			}
		}
		case 9,10,11,12,13,14,15:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}FREEDOM BOMB {forestgreen}. Please wait for the next bomb.");
		}
		case 16:{
			if(bombProgression){
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team is currently pushing an {red}ELON BUST {forestgreen}!");
			}
			else{ 
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}FREEDOM BOMB {forestgreen}. Your team's {red}ELON BUST {forestgreen}is available for deployment!");
			}
		}
		case 17,18,19,20,21,22,23:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed {white}ELON BUST {forestgreen}. Please wait for the next bomb.");
		}
		case 24:{
			if(bombProgression){
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team is currently pushing {red}BATH SALTS {forestgreen}!");
			}
			else{
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}ELON BUST {forestgreen}. Your team's {red}BATH SALTS {forestgreen}are available for deployment!");
			}
		}
		case 25,26,27,28,29,30,31:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed {white}BATH SALTS {forestgreen}. Please wait for the next bomb.");
		}
		case 32:{
			if(bombProgression){
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team is currently pushing a {red}FALLING STAR {forestgreen}!");
			}
			else{
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed {white}BATH SALTS {forestgreen}. Your team's {red}FALLING STAR {forestgreen}is available for deployment!");
			}
		}
		case 33,34,35,36,37,38,39:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}FALLING STAR {forestgreen}. Please wait for the next bomb.");
		}
		case 40:{
			if(bombProgression){
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team is currently pushing a {red}MAJOR KONG {forestgreen}!");
			}
			else{
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed {white}FALLING STAR {forestgreen}. Your team's {red}MAJOR KONG {forestgreen}is available for deployment!");
			}
		}
		case 41,42,43,44,45,46,47:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}MAJOR KONG {forestgreen}. Please wait for the next bomb.");
		}
		case 48:{
			if(bombProgression){
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team is currently pushing a {red}SHARK {forestgreen}!");
			}
			else{
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed {white}MAJOR KONG {forestgreen}. Your team's {red}SHARK {forestgreen}is available for deployment!");
			}
		}
		case 49,50,51,52,53,54,55:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}SHARK {forestgreen}. Please wait for the next bomb.");
		}
		case 56:{
			if(bombProgression){
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team is currently pushing a {red}FAT MAN {forestgreen}!");
			}
			else{
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}SHARK {forestgreen}. Your team's {red}FAT MAN {forestgreen}is available for deployment!");
			}
		}
		case 57,58,59,60,61,62,63:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}FAT MAN {forestgreen}. Please wait for the next bomb.");
		}
		case 64:{
			if(bombProgression){
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team is delivering \x07FFFF00HYDROGEN {forestgreen}!");
			}
			else{
				CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {red} FAT MAN {forestgreen}. Your team's \x07FFFF00HYDROGEN {forestgreen}is available for deployment!");
			}
		}
		case 65,66,67,68,69,70,71:{
			CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team recently deployed a {white}HYDROGEN{forestgreen}. Bombs are automatically reset to preserve the replayable aspect of this game mode.");
		}
		case 72:{
			CPrintToChatAll("{red}Something exceeded a maximum value!!! Apparently the bomb status is %i, with a maximum status of %i.", bombStatus, bombStatusMax);
		}
	}
	return Plugin_Handled;
}

//Return the client to spawn
public Action Command_Return(int client, int args){
	if (!IsPlayerAlive(client)){
		ReplyToCommand(client, "{red}[Core] You must be alive to use this command...");
		return Plugin_Handled;
	}
	else{
		char name[128];
		GetClientName(client, name, sizeof(name));
		CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%s {white}began casting {darkviolet}/return{white}.", name);
		CustomSoundEmitter(RETURNSND, SFXSNDLVL, false);
		CreateTimer(5.0, ReturnClient, client);
	}
	return Plugin_Handled;
}

//Return the client to spawn
public Action ReturnClient(Handle timer, int clientID){
	TeleportEntity(clientID, Return, NULL_VECTOR, NULL_VECTOR);
	if(soundPreference[clientID] >= 2){
		EmitSoundToClient(clientID, RETURNSUCCESS);
	}
	return Plugin_Handled;
}

//Join us on Discord!
public Action Command_Discord(int client, int args){
	CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Our Discord server URL is {darkviolet}https://discord.com/invite/SkHaeMH{white}."),
	ShowMOTDPanel(client, "FireHostRedux Discord", "https://discord.com/invite/SkHaeMH", MOTDPANEL_TYPE_URL);
	return Plugin_Handled;
}

//Events
//Check who died by what and announce it to chat.
public Action EventDeath(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast){
	int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
	int attacker = GetClientOfUserId(Spawn_Event.GetInt("attacker"));
	char attackerName[64];
	char weapon[32];
	Spawn_Event.GetString("weapon", weapon, sizeof(weapon));
	GetClientName(attacker, attackerName, sizeof(attackerName));
	if (0 < client <= MaxClients && IsClientInGame(client)){
		int damagebits = Spawn_Event.GetInt("damagebits");
		//Find server name
		Handle convar = FindConVar("hostname");
		char ServerName[64];
		GetConVarString( convar, ServerName, sizeof(ServerName)); 
		if(StrEqual(attackerName, ServerName)){
			attackerName = "[INTENTIONAL GAME DESIGN]";
		}
		if(attacker>0 && sacrificedByClient){//Was the client Sacrificed?
			SacrificeClient(client, attacker, bombReset);
			sacrificedByClient = false;
		}
		if(!attacker){
			switch(damagebits){
				case 1:{ //CRUSH
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was crushed by a {red}FALLING ROCK FROM OUTER SPACE{white}!", client);
					weapon = "Meteor to the Face";
				}
				case 8:{ //BURN
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was {red}MELTED{white}.", client);
					weapon = "Melted by Sharts or Ass Gas";
				}
				case 16:{ //FREEZE
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was flattened out by a {red}TRAIN{white}!", client);
					weapon = "Attempted Train Robbery";
				}
				case 32:{ //FALL
					if(tornado){
						switch(GetClientTeam(client)){
							case 2:{
								CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was {red}YEETED OUT INTO ORBIT{white}!", client);
								weapon = "Yeeted into Orbit by a Tornado";
							}
							case 3:{
								CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was {red}YEETED OUT INTO ORBIT{white}! ({limegreen}+1 pt{white})", client);
								sacPoints++;
								int i = GetRandomInt(1, 16);
								switch (i){
									case 1:{
										CustomSoundEmitter(FALLSND01, SFXSNDLVL, false);
									}
									case 2:{
										CustomSoundEmitter(FALLSND02, SFXSNDLVL, false);
									}
									case 3:{
										CustomSoundEmitter(FALLSND03, SFXSNDLVL, false);
									}
									case 4:{
										CustomSoundEmitter(FALLSND04, SFXSNDLVL, false);
									}
									case 5:{
										CustomSoundEmitter(FALLSND05, SFXSNDLVL, false);
									}
									case 6:{
										CustomSoundEmitter(FALLSND06, SFXSNDLVL, false);
									}
									case 7:{
										CustomSoundEmitter(FALLSND07, SFXSNDLVL, false);
									}
									case 8:{
										CustomSoundEmitter(FALLSND08, SFXSNDLVL, false);
									}
									case 9:{
										CustomSoundEmitter(FALLSND09, SFXSNDLVL, false);
									}
									case 10:{
										CustomSoundEmitter(FALLSND0A, SFXSNDLVL, false);
									}
									case 11:{
										CustomSoundEmitter(FALLSND0B, SFXSNDLVL, false),
										FireEntityInput("FB.BlueKirbTemplate", "ForceSpawn", "", 0.0);
									}
									case 12:{
										CustomSoundEmitter(FALLSND0C, SFXSNDLVL, false);
									}
									case 13:{
										CustomSoundEmitter(FALLSND0D, SFXSNDLVL, false);
									}
									case 14:{
										CustomSoundEmitter(FALLSND0E, SFXSNDLVL, false);
									}
									case 15:{
										CustomSoundEmitter(FALLSND0F, SFXSNDLVL, false);
									}
									case 16:{
										CustomSoundEmitter(FALLSND10, SFXSNDLVL, false);
									}
								}
							}
						}
					}
					else{
						CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N fell to a {red}CLUMSY PAINFUL DEATH{white}!", client);
						weapon = "Tripped on a LEGO";
					}
				}
				case 64:{ //BLAST
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N went {red} KABOOM{white}!", client);
					weapon = "Gone Kaboom!";
				}
				case 128:{ //CLUB
					if(canHindenburg){
						CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N is {red}CRASHING THE HINDENBURG{white}!!!", client);
						weapon = "Crashing the Hindenburg";
					}
				}
				case 256:{ //SHOCK
					CPrintToChatAll("{darkviolet}[{red}EXTERMINATUS{darkviolet}] {white}Client %N has humliated themselves with an {red}incorrect {white}key entry!", client);
					weapon = "Failed FB Code Entry";
					int i = GetRandomInt(1, 16);
					switch(i){
						case 1,3,10:{
							FireEntityInput("BG.Meteorites1", "ForceSpawn", "", 0.0),
							CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, a {red}METEOR{white}has been spotted coming towards Dovah's Ass!!!"),
							FireEntityInput("bg.meteorite1", "StartForward", "", 0.1);
						}
						case 2,5,16:{
							CreateTimer(0.5, TimedOperator, 71);
							FireEntityInput("FB.TankTrain", "TeleportToPathTrack", "Tank01", 0.0),
							FireEntityInput("FB.TankTrain", "StartForward", "", 0.25),
							FireEntityInput("FB.TankTrain", "SetSpeed", "1", 0.35),
							FireEntityInput("FB.Tank", "Enable", "", 1.0);
						}
						case 4,8,14:{
							CustomSoundEmitter("ambient/alarms/train_horn_distant1.wav", SFXSNDLVL, false),
							FireEntityInput("TrainSND", "PlaySound", "", 0.0),
							FireEntityInput("TrainDamage", "Enable", "", 0.0),
							FireEntityInput("Train01", "Enable", "", 0.0),
							CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {orange}KISSONE'S TRAIN{white}is {red}INCOMING{white}. Look out!"),
							FireEntityInput("TrainTrain", "TeleportToPathTrack", "TrainTrack01", 0.0),
							FireEntityInput("TrainTrain", "StartForward", "", 0.1);
						}
						case 6,9:{
							canTornado = true,
							CreateTimer(1.0, TimedOperator, 41);
						}
						case 7,13:{
							CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, a {red}METEOR SHOWER{white}has been reported from Dovah's Ass!!!");
							canSENTMeteors = true,
							CreateTimer(1.0, SENTMeteorTimer),
							CreateTimer(30.0, DisableSENTMeteors);
						}
						case 11:{
							FireEntityInput("FB.Slice", "Enable", "", 0.0),
							CustomSoundEmitter("ambient/sawblade_impact1.wav", SFXSNDLVL, false),
							FireEntityInput("FB.Slice", "Disable", "", 1.0);
						}
						case 12,15:{
							CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, it's begun to rain {red}ATOM BOMBS{white}! TAKE COVER!"),
							canSENTNukes = true,
							CreateTimer(1.0, SENTNukeTimer),
							CreateTimer(30.0, DisableSENTNukes);
						}
					}
				}
				case 512:{ //SONIC
					CPrintToChatAll("{darkviolet}[{red}EXTERMINATUS{darkviolet}] {white}Client %N has sacrificed themselves with a {forestgreen}correct {white}key entry! Prepare your anus!", client);
					ServerCommand("fb_operator 1006");
					weapon = "Correct FB Code Entry";
				}
				case 1024:{ //ENERGYBEAM
					if(crusader){
						CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been vaporized by {red}THE CRUSADER{white}!", client);
						weapon = "Crusader";
					}
					else if(waveFlags == 1){
						CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been vaporized by {red}THE ONSLAUGHTER{white}!", client);
						weapon = "Onslaughter";	
					}
					else{
						CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been vaporized by a {red}HIGH ENERGY PHOTON BEAM{white}!", client);
						weapon = "HE Photon Beam";
					}
				}
				case 16384:{ //DROWN
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N {red}DROWNED{white}.", client);
					weapon = "Darwin Award for Drowning";
				}
				case 32768:{ //PARALYZE
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been crushed by a {darkviolet}MYSTERIOUS BLUE BALL{white}!", client);
					weapon = "Mysterious Blue Ball";
				}
				case 65536:{ //NERVEGAS
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been {red}SLICED TO RIBBONS{white}!", client);
					weapon = "FB Code Entry Failed";
				}
				case 131072:{ //POISON
					CPrintToChat(client, "{darkviolet}[{red}CORE{darkviolet}] {white}Please don't sit {red}IDLE {white}in the FC Tavern.");
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was killed for standing in the Tavern instead of helping their team!", client);
					weapon = "Idle in FC Tavern..?";
				}
				case 262144:{ //RADIATION
				CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was blown away by a {red}NUCLEAR EXPLOSION{white}!", client);
				weapon = "Nuclear Explosion";
				}
				case 524288:{ //DROWNRECOVER
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N experienced {red}TACO BELL{white}!", client);
					weapon = "Taco Bell";
				}
				case 1048576:{ //ACID
					CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been crushed by a {forestgreen}FALLING GOOBBUE FROM OUTER SPACE{white}!", client);
					weapon = "Falling Goobbue";
				}
			}
		}

		//Log if a player killed someone
		if(attacker != client){
			char query[256];
			int steamID;
			if(attacker != 0){
				steamID = GetSteamAccountID(attacker);
			}
			else{
				steamID = 0;
			}
			if (!FB_Database){
				return Plugin_Handled;
			}
			if (!steamID || steamID <= 10000){
				int steamIDclient = GetSteamAccountID(client);
				if (!steamIDclient || steamIDclient<=10000){
					return Plugin_Handled;
				}
				else{
					char queryClient[256];
					Format(queryClient, sizeof(queryClient), "UPDATE ass_activity SET deaths = deaths + 1, deathssession = deathssession + 1 WHERE steamid = %i;", steamIDclient);
					FB_Database.Query(Database_FastQuery, queryClient);
					if (!StrEqual(weapon, "world")){
						Format(queryClient, sizeof(queryClient), "UPDATE ass_activity SET killedbyname = '%s', killedbyweapon = '%s' WHERE steamid = %i;", attackerName, weapon, steamIDclient);
						FB_Database.Query(Database_FastQuery, queryClient);
					}
					return Plugin_Handled;
				}
			}
			Format(query, sizeof(query), "UPDATE ass_activity SET kills = kills + 1, killssession = killssession + 1 WHERE steamid = %i;", steamID);
			FB_Database.Query(Database_FastQuery, query);
			if (!StrEqual(weapon, "world")){
				Format(query, sizeof(query), "UPDATE ass_activity SET lastkilledname = '%N', lastweaponused = '%s' WHERE steamid = %i;", client, weapon, steamID);
				FB_Database.Query(Database_FastQuery, query);
			}
		}
		return Plugin_Handled;
	}
	return Plugin_Handled;
}

//Check who spawned and log their class
public Action EventSpawn(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast){
	int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
	if(IsValidClient(client)){
		char strClass[32];
		char query[256];
		int class = Spawn_Event.GetInt("class");
		int steamID = GetSteamAccountID(client);
		if (!FB_Database || !steamID || !class){
			return Plugin_Handled;
		}
		switch(class){
			case 1:{
				strClass = "scout";
			}
			case 2:{
				strClass = "sniper";
			}
			case 3:{
				strClass = "soldier";
			}
			case 4:{
				strClass = "demoman";
			}
			case 5:{
				strClass = "medic";
			}
			case 6:{
				strClass = "heavy";
			}
			case 7:{
				strClass = "pyro";
			}
			case 8:{
				strClass = "spy";
			}
			case 9:{
				strClass = "engineer";
			}
		}
		Format(query, sizeof(query), "UPDATE ass_activity SET class = '%s' WHERE steamid = %i;", strClass, steamID);
		FB_Database.Query(Database_FastQuery, query);
	}
	return Plugin_Handled;
}

//Silence cvar changes to minimize chat spam.
public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast){
	event.BroadcastDisabled = true;
	return Plugin_Handled;
}

//When we win
public Action EventWaveComplete(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast){
    BGMINDEX = 0;
    tbLoop = 0;
    canHindenburg = false;
    canHWBoss = false;
    canTornado = false;
    isWave = false;
    bombStatusMax = 7;
    bombStatus = 5;
    explodeType = 0;
    waveFlags = 0;
    ServerCommand("fb_operator 1000");
    CreateTimer(1.0, PerformAdverts);
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}You've defeated the wave!");
    FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0),
    FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
    FireEntityInput("Barricade_Rebuild_Relay", "Trigger", "", 0.0);
    FireEntityInput("FB.KP*", "Lock", "", 0.0);
    FireEntityInput("OldSpawn", "Disable", "", 0.0);
    FireEntityInput("NewSpawn", "Enable", "", 0.0);
    FireEntityInput("CommonSpells", "Disable", "", 0.0);
    FireEntityInput("RareSpells", "Disable", "", 0.0);
    FireEntityInput("dovahsassprefer", "Disable", "", 0.0);
    FireEntityInput("bombpath_left_arrows", "Disable", "", 0.0);
    FireEntityInput("bombpath_right_arrows", "Disable", "", 0.0);
    FireEntityInput("rain", "Alpha", "0", 0.0);
    ServerCommand("fb_operator 1007");
    ServerCommand("fb_operator 1002");
    CreateTimer(40.0, SelectAdminTimer);
    return Plugin_Handled;
}

//Announce when we are in danger.
public Action EventWarning(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast){
	CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {darkred}PROFESSOR'S ASS IS ABOUT TO BE DEPLOYED!!!");
	return Plugin_Handled;
}

//When the wave fails
public Action EventWaveFailed(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast){
    BGMINDEX = 0;
    tbLoop = 0;
    canHindenburg = false;
    canHWBoss = false;
    canTornado = false;
    isWave = false;
    bombStatusMax = 7;
    bombStatus = 5;
    explodeType = 0;
    waveFlags = 0;
    if (FailedCount == 0){ //Works around valve's way of firing EventWaveFailed four times when mission changes. Without this, BGM would play 4 times and any functions enclosed would also happen four times.......
		FailedCount++;
		ServerCommand("fb_operator 1000");
		CreateTimer(1.0, PerformAdverts);
		CreateTimer(40.0, SelectAdminTimer);
	}
    FireEntityInput("rain", "Alpha", "0", 0.0);
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave {red}failed {white}successfully!");
    FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0),
    FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
    FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0),
    FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
    FireEntityInput("Barricade_Rebuild_Relay", "Trigger", "", 0.0);
    FireEntityInput("FB.KP*", "Lock", "", 0.0);
    FireEntityInput("OldSpawn", "Disable", "", 0.0);
    FireEntityInput("NewSpawn", "Enable", "", 0.0);
    FireEntityInput("CommonSpells", "Disable", "", 0.0);
    FireEntityInput("RareSpells", "Disable", "", 0.0);
    FireEntityInput("dovahsassprefer", "Disable", "", 0.0);
    FireEntityInput("bombpath_left_arrows", "Disable", "", 0.0);
    FireEntityInput("bombpath_right_arrows", "Disable", "", 0.0);
    FireEntityInput("rain", "Alpha", "0", 0.0);
    ServerCommand("fb_operator 1007");
    ServerCommand("fb_operator 1002");
    return Plugin_Handled;
}

//Log Damage!
public void Event_Playerhurt(Handle event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	int damage = GetEventInt(event, "damageamount");
	if(IsValidClient(attacker) && attacker != client)
	{
		char query[256];
		int steamID = GetSteamAccountID(attacker);
		PrintToConsole(attacker, "Writing new myDmg value %i", damage);
		if (!FB_Database){
			return;
		}
		if (!steamID){	
			return;
		}
		Format(query, sizeof(query), "UPDATE ass_activity SET damagedealt = damagedealt + %i, damagedealtsession = damagedealtsession + %i WHERE steamid = %i;", damage, damage, steamID);
		FB_Database.Query(Database_FastQuery, query);
	}
}

//Functions
//Create a temp entity and fire an input
public Action FireEntityInput(char[] strTargetname, char[] strInput, char[] strParameter, float flDelay){
	char strBuffer[255];
	Format(strBuffer, sizeof(strBuffer), "OnUser1 %s:%s:%s:%f:1", strTargetname, strInput, strParameter, flDelay);
	//PrintToChatAll("{limegreen}[CORE] {white}Firing entity %s with input %s , a parameter override of %s , and delay of %f ...", strTargetname, strInput, strParameter, flDelay);
	int entity = CreateEntityByName("info_target");
	if(IsValidEdict(entity))
	{
		DispatchSpawn(entity);
		ActivateEntity(entity);
		SetVariantString(strBuffer);
		AcceptEntityInput(entity, "AddOutput");
		AcceptEntityInput(entity, "FireUser1");
		CreateTimer(0.0, DeleteEdict, entity);
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

//Custom sound processor, this should make handling sounds easier.
public Action CustomSoundEmitter(char[] sndName, int SNDLVL, bool isBGM){
	for (int i = 1; i <= MaxClients; i++)
	{
		//If it's music
		if(IsClientInGame(i) && !IsFakeClient(i) && (soundPreference[i] == 1 || soundPreference[i] == 3) && isBGM){
			EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, _, _, _, _, _, _, _, _);
		}
		//If it's sound effects
		else if(IsClientInGame(i) && !IsFakeClient(i) && soundPreference[i] >= 2 && !isBGM){
			EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, _, _, _, _, _, _, _, _);
		}
	}
	return Plugin_Handled;
}

//Jump waves.
public Action JumpToWave(int wave_number){
	int flags = GetCommandFlags("tf_mvm_jump_to_wave");
	SetCommandFlags("tf_mvm_jump_to_wave", flags & ~FCVAR_CHEAT);
	ServerCommand("tf_mvm_jump_to_wave %d", wave_number);
	FakeClientCommand(0, "");
	SetCommandFlags("tf_mvm_jump_to_wave", flags|FCVAR_CHEAT);
	return Plugin_Handled;
}

//Remove edict allocated by temp entity
public Action DeleteEdict(Handle timer, any entity){
	if(IsValidEdict(entity)) RemoveEdict(entity);
	return Plugin_Stop;
}

//Sacrifice target and grant bonus points
public Action SacrificeClient(int client, int attacker, bool wasBombReset){
    if (attacker <= MaxClients && IsClientInGame(attacker) && wasBombReset == true){
		CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%N {white}has reset the ass! ({limegreen}+5 pts{white})", attacker);
		bombReset = false;
		char query[256];
		int steamID = GetSteamAccountID(attacker);
		sacPoints+=5;
		if (!FB_Database || !steamID){
			return Plugin_Handled;
		}
		Format(query, sizeof(query), "UPDATE ass_activity SET bombsreset = bombsreset + 1, bombsresetsession = bombsresetsession + 1 WHERE steamid = %i;", steamID);
		FB_Database.Query(Database_FastQuery, query);
	}
	else if (attacker <= MaxClients && IsClientInGame(attacker) && wasBombReset == false){
		int steamID = GetSteamAccountID(attacker);
		if (!FB_Database || !steamID || !isWave){
			return Plugin_Handled;
		}
		else{
			char query[256];
			sacPoints++;
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%N {white}has sacrificed {blue}%N {white}for the ass! ({limegreen}+1 pt{white})", attacker, client);
			Format(query, sizeof(query), "UPDATE ass_activity SET sacrifices = sacrifices + 1, sacrificessession = sacrificessession + 1 WHERE steamid = %i;", steamID); //Eventually we will want to replace this with sacrifices, sacrificessession.
			FB_Database.Query(Database_FastQuery, query);
		}
	}
    return Plugin_Handled;
}	

//Operator, core of the entire map
public Action Command_Operator(int args){
	char arg1[16];
	GetCmdArg(1, arg1, sizeof(arg1));
	int x = StringToInt(arg1);
	//PrintToConsoleAll("Calling on fb_operator because arg1 was %i, and was stored in memory position %i", x, arg1);
	switch (x){
		//When the map is complete
		case 0:{
			if(tacobell){
					CPrintToChatAll("WOWIE YOU DID IT! The server will restart in 30 seconds, prepare to do it again! LULW");
					CreateTimer(10.0, TimedOperator, 100);
			}
			else{
				CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}YOU HAVE SUCCESSFULLY COMPLETED PROF'S ASS ! THE SERVER WILL RESTART IN 10 SECONDS.");
				CreateTimer(10.0, TimedOperator, 100);
			}
		}
		//Prepare yourself!
		case 1:{
			char mapName[64];
			tacobell = false;
			ServerCommand("fb_startmoney 50000");
			CPrintToChatAll("{darkviolet}[{yellow}INFO{darkviolet}] {red}PROFESSOR'S ASS {white}v0x1D. Prepare yourself for the unpredictable... [{limegreen}by TTV/ProfessorFartsalot{white}]");
			GetCurrentMap(mapName, sizeof(mapName));
			FireEntityInput("rain", "Alpha", "0", 0.0);
			//Prepare for the end times....
			if (StrContains(mapName, "R1A", true) || StrContains(mapName, "R1B", true) || StrContains(mapName, "R1C", true) || StrContains(mapName, "R1D", true) || StrContains(mapName, "R1E", true) || StrContains(mapName, "R1F", true)){
				int i = GetRandomInt(1, 7);
				switch(i){
					case 1:{
						CPrintToChatAll("{darkviolet}[{yellow}????{darkviolet}] {darkviolet}Fartsy... what have you done???");
					}
					case 2:{
						CPrintToChatAll("{darkviolet}[{yellow}????{darkviolet}] {darkviolet}The end is NEAR...");
					}
					case 3:{
						CPrintToChatAll("{darkviolet}[{yellow}????{darkviolet}] {darkviolet}The ass grows ever stronger...");
					}
					case 4:{
						CPrintToChatAll("{darkviolet}[{yellow}????{darkviolet}] {darkviolet}Muahahahahahahahaha, so MUCH POWER!");
					}
					case 5:{
						CPrintToChatAll("{darkviolet}[{yellow}????{darkviolet}] {darkviolet}Just a little further.... JUST.. a LITTLE... FURTHER!");
					}
					case 6:{
						CPrintToChatAll("{darkviolet}[{yellow}????{darkviolet}] {darkviolet}Investigate if you dare...");
					}
					case 7:{
						CPrintToChatAll("{darkviolet}[{yellow}????{darkviolet}] {darkviolet}Come... JOIN US. Throw wide the gates!");
					}
				}
			}
		}
		//Wave init
		case 2:{
			int ent = FindEntityByClassname(-1, "tf_objective_resource"); //Get current wave, perform actions per wave.
			if(ent == -1){
				LogMessage("tf_objective_resource not found");
				return Plugin_Handled;
			}
			curWave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
			PerformWaveSetup();
			switch (curWave){
				case 1:{
					if(tacobell){
						BGMINDEX = 10;
						canTornado = true;
						bombStatus = 0;
						bombStatusMax = 10;
						sacPointsMax = 90;
						ServerCommand("fb_operator 1000");
					}
					else{
						BGMINDEX = 2;
						bombStatus = 0;
						bombStatusMax = 10;
						sacPointsMax = 90;
						ServerCommand("fb_operator 1000");
					}
				}
				case 2,9,16:{
					BGMINDEX = 3;
					canHWBoss = true;
					canTornado = true;
					bombStatus = 4;
					bombStatusMax = 18;
					sacPointsMax = 90;
					ServerCommand("fb_operator 1000");
					//CreateTimer(0.1, TimedOperator, 3);
					FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
					float hwn = GetRandomFloat(HWNMin, HWNMax);
					CreateTimer(hwn, HWBosses);
				}
				case 3,10,17:{
					BGMINDEX = 4;
					canHWBoss = true;
					canTornado = true;
					HWNMax = 360.0;
					bombStatus = 7;
					bombStatusMax = 26;
					sacPointsMax = 90;
					ServerCommand("fb_operator 1000");
					//CreateTimer(0.1, TimedOperator, 4);
					FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
					float f = GetRandomFloat(60.0, 180.0);
					CreateTimer(f, TimedOperator, 70);
					float hwn = GetRandomFloat(HWNMin, HWNMax);
					CreateTimer(hwn, HWBosses);
				}
				case 4,11,18:{
					BGMINDEX = 5;
					canHWBoss = true;
					canTornado = true;
					HWNMax = 360.0;
					isWave = true;
					bombStatus = 12;
					bombStatusMax = 34;
					sacPointsMax = 90;
					ServerCommand("fb_operator 1000");
					//CreateTimer(0.1, TimedOperator, 5);
					FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
					float hwn = GetRandomFloat(HWNMin, HWNMax);
					CreateTimer(hwn, HWBosses);
				}
				case 5,12,19:{
					BGMINDEX = 6;
					canHWBoss = true;
					canTornado = true;
					HWNMax = 260.0;
					HWNMin = 140.0;
					isWave = true;
					bombStatus = 14;
					bombStatusMax = 42;
					sacPointsMax = 100;
					ServerCommand("fb_operator 1000");
					//CreateTimer(0.1, TimedOperator, 6);
					FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
					FireEntityInput("w5_engie_hints", "Trigger", "", 3.0);
					float f = GetRandomFloat(60.0, 180.0);
					CreateTimer(f, TimedOperator, 70);
					float hwn = GetRandomFloat(HWNMin, HWNMax);
					CreateTimer(hwn, HWBosses);
				}
				case 6,13,20:{
					BGMINDEX = 7;
					canHWBoss = true;
					canTornado = true;
					HWNMax = 260.0;
					HWNMin = 140.0;
					isWave = true;
					bombStatus = 20;
					bombStatusMax = 50;
					sacPointsMax = 100;
					ServerCommand("fb_operator 1000");
					FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
					float hwn = GetRandomFloat(HWNMin, HWNMax);
					CreateTimer(hwn, HWBosses);
				}
				case 7,14,21:{
					BGMINDEX = 8;
					canHWBoss = true;
					canTornado = true;
					HWNMax = 240.0;
					HWNMin = 120.0;
					isWave = true;
					bombStatus = 28;
					bombStatusMax = 58;
					sacPointsMax = 100;
					ServerCommand("fb_operator 1000");
					FireEntityInput("rain", "Alpha", "200", 0.0);
					FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
					FireEntityInput("w5_engie_hints", "Trigger", "", 3.0);
					float hwn = GetRandomFloat(HWNMin, HWNMax);
					CreateTimer(hwn, HWBosses);
				}
				case 8,15:{
					BGMINDEX = 9;
					canHWBoss = true;
					canTornado = true;
					HWNMax = 240.0;
					HWNMin = 120.0;
					bombStatus = 30;
					bombStatusMax = 66;
					sacPointsMax = 100;
					ServerCommand("fb_operator 1000");
					FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
					FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
					float hwn = GetRandomFloat(HWNMin, HWNMax);
					CreateTimer(hwn, HWBosses);
				}
			}
			return Plugin_Handled;
		}
		//Force Tornado
		case 3:{
			if(isWave && canTornado && !tornado){
				CreateTimer(0.1, TimedOperator, 41);
				PrintCenterTextAll("OH NOES... PREPARE YOUR ANUS!");
			}
			else{
				PrintToServer("Error spawning manual tornado... Perhaps we are not in a wave, tornadoes are banished, or a tornado has already spawned???");
			}
			return Plugin_Handled;
		}
		//Signal that previous boss should spawn.
		case 4:{
			waveFlags--;
		}
		//Signal that a boss should spawn
		case 5:{
			if(waveFlags<0){
				waveFlags = 0;
			}
			switch (waveFlags){
				//Case 0, boss does not spawn. This is unreachable.
				case 0:{
					PrintToChatAll("Caught unhandled exception: waveFlags 0 but operator 5 was invoked.");
					return Plugin_Handled;
				}
				//Case 1, summon Onslaughter.
				case 1:{
					//PrintToChatAll("Got 1. Spawning Onslaughter."),
					FireEntityInput("FB.BruteJusticeTrain", "TeleportToPathTrack", "tank_path_a_10", 0.0),
					FireEntityInput("FB.BruteJustice", "Enable", "", 3.0),
					FireEntityInput("FB.BruteJusticeTrain", "StartForward", "", 3.0),
					FireEntityInput("FB.BruteJusticeParticles", "Start", "", 3.0),
					CreateTimer(5.0, OnslaughterATK),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 3.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 4.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 5.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 6.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 7.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 8.0);
				}
				//Case 2, summon Custom Boss 1
				case 2:{
					FireEntityInput("FB.Sephiroth", "Enable", "", 0.0),
					FireEntityInput("SephTrain", "SetSpeed", "0.5", 0.0),
					FireEntityInput("SephTrain", "TeleportToPathTrack", "Seph01", 0.0),
					FireEntityInput("SephTrain", "StartForward", "", 0.1),
					FireEntityInput("FB.SephParticles", "Start", "", 3.0),
					CreateTimer(5.0, SephATK),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 3.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 4.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 5.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 6.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 7.0),
					FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 8.0);
				}
			}
		}
		//Signal that next boss should spawn
		case 6:{
			waveFlags++;
		}
		//Signal to fastforward boss spawn.
		case 7:{
			waveFlags = 2;
			if (curWave == 8 && !tacobell){
				ServerCommand("fb_operator 1001");
				CreateTimer(0.0, TimedOperator, 8);
			}
		}
		//When a tornado intersects a tank.
		case 8:{
			FireEntityInput("FB.FakeTankSpawner", "ForceSpawn", "", 0.1);
		}
		//Client was Sacrificed.
		case 10:{
			sacrificedByClient = true;
		}
		//Onslaughter dmg relay was killed
		case 12:{
			FireEntityInput("tank_boss", "SetHealth", "1", 0.0),
			FireEntityInput("TankRelayDMG", "Enable", "", 0.1),
			FireEntityInput("TankRelayDMG", "Disable", "", 3.0);
		}
		//Tank Destroyed (+1), includes disabling onslaughter.
		case 13:{
			switch(waveFlags){
				case 0:{
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A tank has been destroyed. waveFlags was 0. ({limegreen}+1 pt{white})");
					sacPoints++;
				}
				case 1:{
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}ONSLAUGHTER {white}has been destroyed. ({limegreen}+25 pts{white})");
					FireEntityInput("FB.BruteJustice", "Disable", "", 0.0);	
					FireEntityInput("FB.BruteJusticeTrain", "Stop", "", 0.0);
					FireEntityInput("FB.BruteJusticeParticles", "Stop", "", 0.0);
					FireEntityInput("FB.BruteJusticeDMGRelay", "Break", "", 0.0);
					FireEntityInput("FB.BruteJusticeTrain", "TeleportToPathTrack", "tank_path_a_10", 0.5);
					waveFlags = 0;
					sacPoints+=25;
				}
				case 2:{
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A boss has been destroyed.({limegreen}+100 pts{white})");
					sacPoints+=100;
					waveFlags = 0;
				}
			}
			return Plugin_Handled;
		}
		//Bomb Reset (+5)
		case 14:{
			bombReset = true;
			sacPoints+=5;
		}
		//Bomb Deployed
		case 15:{
			switch (explodeType){
				//Invalid
				case 0:{
					PrintToServer("Tried to detonate with a bomb size of zero!");
				}
				//Small Explosion
				case 1:{
					FireEntityInput("RareSpells", "Enable", "", 0.0);
					EmitSoundToAll(BMB1SND),
					FireEntityInput("SmallExplosion", "Explode", "", 0.0),
					FireEntityInput("SmallExploShake", "StartShake", "", 0.0),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Small Bomb successfully pushed! ({limegreen}+2 pts{white})");
					sacPoints+=2,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					CustomSoundEmitter(COUNTDOWN, SFXSNDLVL, false);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=2;
					}
				}
				//Medium Explosion
				case 2:{
					FireEntityInput("RareSpells", "Enable", "", 0.0);
					EmitSoundToAll(BMB2SND),
					FireEntityInput("MediumExplosion", "Explode", "", 0.0),
					FireEntityInput("MedExploShake", "StartShake", "", 0.0),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Medium Bomb successfully pushed! ({limegreen}+5 pts{white})");
					sacPoints+=5,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					CustomSoundEmitter(COUNTDOWN, SFXSNDLVL, false);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=2;
					}
				}
				//Medium Explosion (Bath salts)
				case 3:{
					FireEntityInput("RareSpells", "Enable", "", 0.0);
					EmitSoundToAll(BMB2SND),
					FireEntityInput("MediumExplosion", "Explode", "", 0.0),
					FireEntityInput("MedExploShake", "StartShake", "", 0.0),
					ServerCommand("sm_freeze @blue 10");
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Medium Bomb successfully pushed! Bots froze for 10 seconds. ({limegreen}+5 pts{white})");
					sacPoints+=5,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					CustomSoundEmitter(COUNTDOWN, SFXSNDLVL, false);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=2;
					}
				}
				//Falling Star
				case 4:{
					FireEntityInput("RareSpells", "Enable", "", 0.0);
					canSENTStars = true,
					EmitSoundToAll(BMB2SND),
					FireEntityInput("MediumExplosion", "Explode", "", 0.0),
					FireEntityInput("MedExploShake", "StartShake", "", 0.0),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Large Bomb successfully pushed! ({limegreen}+10 pts{white})");
					sacPoints+=10,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					CustomSoundEmitter(COUNTDOWN, SFXSNDLVL, false),
					CreateTimer(1.0, SENTStarTimer),
					CreateTimer(60.0, SENTStarDisable);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=2;
					}
				}
				//Major Kong
				case 5:{
					FireEntityInput("RareSpells", "Enable", "", 0.0);
					EmitSoundToAll(BMB4SND),
					FireEntityInput("FB.Fade", "Fade", "", 1.7),
					FireEntityInput("LargeExplosion", "Explode", "", 1.7),
					FireEntityInput("LargeExplosionSound", "PlaySound", "", 1.7),
					FireEntityInput("LargeExploShake", "StartShake", "", 1.7),
					FireEntityInput("NukeAll", "Enable", "", 1.7),
					FireEntityInput("NukeAll", "Disable", "", 3.0),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}NUCLEAR WARHEAD {white}successfully pushed! ({limegreen}+25 pts{white})");
					sacPoints+=25,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					CustomSoundEmitter(COUNTDOWN, SFXSNDLVL, false);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=4;
					}
				}
				//Large (shark)
				case 6:{
					FireEntityInput("RareSpells", "Enable", "", 0.0);
					EmitSoundToAll(BMB3SND),
					FireEntityInput("LargeExplosion", "Explode", "", 0.0),
					FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Heavy Bomb successfully pushed! ({limegreen}+15 pts{white})");
					sacPoints+=15,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					CustomSoundEmitter(COUNTDOWN, SFXSNDLVL, false);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=4;
					}
				}
				//FatMan
				case 7:{
					FireEntityInput("RareSpells", "Enable", "", 0.0);
					EmitSoundToAll(HINDENBURGBOOM);
					FireEntityInput("LargeExplosion", "Explode", "", 0.0),
					FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
					FireEntityInput("NukeAll", "Enable", "", 0.0),
					FireEntityInput("FB.Fade", "Fade", "", 0.0),
					FireEntityInput("NukeAll", "Disable", "", 3.0),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}NUCLEAR WARHEAD{white}successfully pushed! ({limegreen}+25 pts{white})");
					sacPoints+=25,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					CreateTimer(15.0, SpecTimer);
					CustomSoundEmitter(COUNTDOWN, SFXSNDLVL, false);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=4;
					}
				}
				//Hydrogen
				case 8:{
					FireEntityInput("RareSpells", "Enable", "", 0.0);
					EmitSoundToAll(HINDENBURGBOOM);
					FireEntityInput("LargeExplosion", "Explode", "", 0.0),
					FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
					FireEntityInput("LargeExplosionSND", "PlaySound", "", 0.0),
					FireEntityInput("NukeAll", "Enable", "", 0.0),
					FireEntityInput("FB.Fade", "Fade", "", 0.0),
					FireEntityInput("NukeAll", "Disable", "", 3.0),
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}HINDENBURG {white}successfully fueled! ({limegreen}+30 pts{white})");
					CPrintToChatAll("The {red}HINDENBURG {forestgreen}is now ready for flight!");
					FireEntityInput("DeliveryBurg", "Unlock", "", 0.0);
					bombStatus = 0;
					canHindenburg = true;
					explodeType = 0;
					CreateTimer(3.0, BombStatusAddTimer);
					CustomSoundEmitter(COUNTDOWN, SFXSNDLVL, false);
				}
				//Fartsy of the Seventh Taco Bell
				case 69:{
					FireEntityInput("NukeAll", "Enable", "", 0.0),
					EmitSoundToAll(HINDENBURGBOOM);
					FireEntityInput("FB.Fade", "Fade", "", 0.0),
					FireEntityInput("NukeAll", "Disable", "", 2.0),
					bombStatusMax=64;
					CreateTimer(5.0, TimedOperator, 99);
				}
			}
			return Plugin_Handled;
		}
		//Tank deployed its bomb
		case 16:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A tank has deployed its bomb! ({limegreen}+1 pt{white})");
		}
		//Shark Enable & notify bomb push began
		case 20:{
			bombProgression = true;
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Bomb push in progress.");
			CreateTimer(3.0, SharkTimer);
		}
		//Shark Disable
		case 21:{
			bombProgression = false;
			canSENTShark = false;
		}
		//HINDENBOOM ACTIVATION
		case 28:{
			EmitSoundToAll(BOOM);
			FireEntityInput("HindenTrain", "StartForward", "", 0.0);
			FireEntityInput("DeliveryBurg", "Lock", "", 0.0);
			FireEntityInput("Boom", "Enable", "", 0.0);
			FireEntityInput("Bombs.TheHindenburg", "Enable", "", 0.0);
			FireEntityInput("Boom", "Disable", "", 1.0);
		}
		//HINDENBOOM!!!
		case 29:{
			CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}OH GOD, THEY'RE {red}CRASHING THE HINDENBURG{white}!!!");
			EmitSoundToAll(HINDENCRASH);
			CreateTimer(4.0, TimedOperator, 21);
			CreateTimer(7.0, TimedOperator, 37);
			FireEntityInput("LargeExplosion", "Explode", "", 7.0);
			FireEntityInput("LargeExploShake", "StartShake", "", 7.0);
			FireEntityInput("NukeAll", "Enable", "", 7.0);
			FireEntityInput("FB.Fade", "Fade", "", 7.0);
			FireEntityInput("NukeAll", "Disable", "", 9.0);
			FireEntityInput("Bombs.TheHindenburg", "Disable", "", 7.0);
			FireEntityInput("HindenTrain", "TeleportToPathTrack", "Hinden01", 7.0);
			FireEntityInput("HindenTrain", "Stop", "", 7.0);
			CreateTimer(8.0, TimedOperator, 99);
			bombStatus = 4;
			bombStatusMax = 8;
			explodeType = 0;
		}
		//Bath Salts spend
		case 30:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}INSTANT BATH SALT DETONATION! BOTS ARE FROZEN FOR 10 SECONDS! ({red}-10 pts{white})");
			ServerCommand("sm_freeze @blue 10");
			sacPoints-=10;
			FireEntityInput("BTN.Sacrificial*", "Color", "0 0 0", 0.0),
			FireEntityInput("BTN.Sacrificial01", "Lock", "", 0.0),
			FireEntityInput("MedExploShake", "StartShake", "", 0.10),
			FireEntityInput("MedExplosionSND", "PlaySound", "", 0.10),
			FireEntityInput("MediumExplosion", "Explode", "", 0.10);
		}
		//Fat man spend
		case 31:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}INSTANT FAT MAN DETONATION! ({red}-20 pts{white})");
			sacPoints-=20;
			FireEntityInput("BTN.Sacrificial*", "Color", "0 0 0", 0.0);
			FireEntityInput("BTN.Sacrificial02", "Lock", "", 0.0);
			FireEntityInput("LargeExplosion", "Explode", "", 0.0);
			FireEntityInput("LargeExploShake", "StartShake", "", 0.0);
			FireEntityInput("NukeAll", "Enable", "", 0.0);
			EmitSoundToAll(HINDENBURGBOOM);
			FireEntityInput("FB.Fade", "Fade", "", 0.0);
			FireEntityInput("NukeAll", "Disable", "", 2.0);
		}
		//Goob/Kirb spend
		case 32:{
			int i = GetRandomInt(1, 2);
			switch (i){
				case 1:{
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}GOOBBUE COMING IN FROM ORBIT! ({red}-30 pts{white})");
					sacPoints-=30;
					CustomSoundEmitter(SPEC01, SFXSNDLVL, false);
					CreateTimer(1.5, TimedOperator, 21);
					FireEntityInput("FB.GiantGoobTemplate", "ForceSpawn", "", 3.0);
				}
				case 2:{
					CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}BLUE KIRBY FALLING OUT OF THE SKY! ({red}-30 pts{white})");
					sacPoints-=30;
					FireEntityInput("FB.BlueKirbTemplate", "ForceSpawn", "", 0.0);
					CustomSoundEmitter(FALLSND0B, SFXSNDLVL, false);
				}
			}
		}
		//Explosive paradise spend
		case 33:{
			CustomSoundEmitter(EXPLOSIVEPARADISE, SFXSNDLVL, false);
			FireEntityInput("FB.FadeBLCK", "Fade", "", 0.0);
			ServerCommand("sm_evilrocket @blue");
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}We're spending most our lives living in an EXPLOSIVE PARADISE! Robots will be launched into orbit, too! ({red}-40 pts{white})");
			FireEntityInput("NukeAll", "Enable", "", 11.50);
			FireEntityInput("HUGEExplosion", "Explode", "", 11.50);
			FireEntityInput("FB.Fade", "Fade", "", 11.50);
			FireEntityInput("FB.ShakeBOOM", "StartShake", "", 11.50);
			FireEntityInput("NukeAll", "Disable", "", 12.30);
			sacPoints-=40;
		}
		//Ass Gas spend
		case 34:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}ANYTHING BUT THE ASS GAS!!!! ({red}-40 pts{white})");
			sacPoints-=40;
			FireEntityInput("HurtAll", "AddOutput", "damagetype 524288", 0.0);
			FireEntityInput("FB.ShakeBOOM", "StartShake", "", 0.1);
			FireEntityInput("HurtAll", "Enable", "", 0.1);
			FireEntityInput("HurtAll", "Disable", "", 4.1); //Add a sound to this in the future. Maybe gas sound from gbombs? Maybe custom fart sounds? hmm....
			FireEntityInput("FB.ShakeBOOM", "StopShake", "", 4.1);
		}
		//Banish tornadoes for the wave
		case 35:{
			if(canTornado || tornado){
				CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A PINK KIRBY HAS BANISHED TORNADOES FOR THIS WAVE! ({red}-50 pts{white})");
				ServerCommand("fb_operator 1005");
				canTornado = false;
				sacPoints-=50;
			}
			else{
				CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A PINK KIRBY HAS BANISHED TORNADOES.... BUT CANTORNADO and TORNADO WERE BOTH FALSE... CALL A PROGRAMMER. ({red} -0 pts{white})");
				ServerCommand("fb_operator 1005");
				canTornado = false;
			}
		}
		//Nuclear fallout spend
		case 36:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}TOTAL ATOMIC ANNIHILATION. ({red}-60 pts{white})");
			sacPoints-=60;
			canSENTNukes = true;
			CreateTimer(1.0, SENTNukeTimer);
			CreateTimer(45.0, DisableSENTNukes);
		}
		//Meteor shower spend
		case 37:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}COSMIC DEVASTATION IMMINENT. ({red}-70 pts{white})");
			sacPoints-=70;
			canSENTMeteors = true;
			CreateTimer(1.0, SENTMeteorTimer);
			CreateTimer(30.0, DisableSENTMeteors);
		}
		//150K UbUp Cash
		case 38:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}150K UbUp Cash Granted to {red}RED{white}! ({red}-75 pts{white})");
			sacPoints-=75;
			ServerCommand("sm_addcash @red 150000");
		}
		//Fartsy of the Seventh Taco Bell
		case 39:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}NOW PRESENTING... PROFESSOR FARTSALOT OF THE SEVENTH TACO BELL! ({red}-100 points{white})");
			sacPoints-=100;
			explodeType = 69;
			FireEntityInput("Delivery", "Unlock", "", 0.0),
			FireEntityInput("BombExplo*", "Disable", "", 0.0),
			FireEntityInput("Bombs*", "Disable", "", 0.0),
			FireEntityInput("Bombs.Professor", "Enable", "", 3.0);
		}
		//Found blue ball
		case 40:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}What on earth IS that? It appears to be a... \x075050FFBLUE BALL{white}!");
			CustomSoundEmitter(FALLSND0B, SFXSNDLVL, false);
			FireEntityInput("FB.BlueKirbTemplate", "ForceSpawn", "", 4.0);
			CreateTimer(4.0, TimedOperator, 21);
		}
		//Found burrito
		case 41:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Why would you even eat {red}The Forbidden Burrito{white}?");
			CustomSoundEmitter("vo/sandwicheat09.mp3", SFXSNDLVL, false);
			FireEntityInput("HurtAll", "AddOutput", "damagetype 8", 0.0);
			FireEntityInput("HurtAll", "Enable", "", 4.0);
			FireEntityInput("HurtAll", "Disable", "", 8.0);
		}
		//Found goobbue
		case 42:{
			CustomSoundEmitter(SPEC01, SFXSNDLVL, false);
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}ALL HAIL \x07FF00FFGOOBBUE{forestgreen}!");
			CreateTimer(4.0, TimedOperator, 21);
			FireEntityInput("FB.GiantGoobTemplate", "ForceSpawn", "", 4.0);
		}
		//Found Mario
		case 43:{
			CustomSoundEmitter(SPEC02, SFXSNDLVL, false);
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Welp, someone is playing \x0700FF00Mario{white}...");
		}
		//Found Waffle
		case 44:{
			CustomSoundEmitter(SPEC03, SFXSNDLVL, false);
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Oh no, someone has found and (probably) consumed a {red}WAFFLE OF MASS DESTRUCTION{white}!");
			FireEntityInput("HurtAll", "AddOutput", "damagetype 262144", 10.0);
			FireEntityInput("FB.ShakeBOOM", "StartShake", "", 10.3);
			FireEntityInput("HUGEExplosion", "Explode", "", 10.3);
			FireEntityInput("FB.Fade", "Fade", "", 10.3);
			FireEntityInput("HurtAll", "Enable", "", 10.3);
			FireEntityInput("HurtAll", "Disable", "", 12.3);
		}
		//Medium Explosion (defined again, but we aren't using a bomb this time)
		case 51:{
			CustomSoundEmitter(BMB3SND, SFXSNDLVL, false);
		}
		//Probably for the hindenburg... EDIT: NOPE. THIS IS FOR KIRB LANDING ON THE GROUND
		case 52:{
			EmitSoundToAll(HINDENBURGBOOM);
			FireEntityInput("FB.BOOM", "StartShake", "", 0.0);
			FireEntityInput("BlueBall*", "Kill", "", 0.0);
			FireEntityInput("HUGEExplosion", "Explode", "", 0.0);
			FireEntityInput("BlueKirb", "Kill", "", 0.0);
			FireEntityInput("HurtAll", "AddOutput", "damagetype 32768", 0.0);
			FireEntityInput("HurtAll", "Enable", "", 0.1);
			FireEntityInput("HurtAll", "Disable", "", 2.1);
		}
		//Giant Goobbue
		case 53:{
			EmitSoundToAll(HINDENBURGBOOM);
			FireEntityInput("FB.BOOM", "StartShake", "", 0.0);
			FireEntityInput("GiantGoob*", "Kill", "", 0.0);
			FireEntityInput("HUGEExplosion", "Explode", "", 0.0);
			FireEntityInput("HurtAll", "AddOutput", "damagetype 1048576", 0.0);
			FireEntityInput("HurtAll", "Enable", "", 0.1);
			FireEntityInput("HurtAll", "Disable", "", 2.1);
		}
		//Prev wave
		case 98:{
			int ent = FindEntityByClassname(-1, "tf_objective_resource");
			if(ent == -1)
			{
				LogMessage("tf_objective_resource not found");
				return Plugin_Handled;
			}

			int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
			int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
			int prev_wave = current_wave - 1;
			if(prev_wave >= max_wave)
			{
				CPrintToChatAll("{red}[ERROR] {white}HOW THE HELL DID WE GET HERE?!");
				return Plugin_Handled;
			}

			if(prev_wave < 1)
			{
				CPrintToChatAll("{red}[ERROR] {white}WE CAN'T JUMP TO WAVE 0, WHY WOULD YOU TRY THAT??");
				return Plugin_Handled;
			}
			JumpToWave(prev_wave);
		}
		//Next wave
		case 99:{
			int ent = FindEntityByClassname(-1, "tf_objective_resource");
			if(ent == -1)
			{
				LogMessage("tf_objective_resource not found");
				return Plugin_Handled;
			}

			int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
			int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
			int next_wave = current_wave + 1;
			if(next_wave > max_wave){
				int flags = GetCommandFlags("tf_mvm_force_victory");
				SetCommandFlags("tf_mvm_force_victory", flags & ~FCVAR_CHEAT);
				ServerCommand("tf_mvm_force_victory 1");
				FakeClientCommand(0, ""); //Not sure why, but this has to be here. Otherwise the specified commands simply refuse to work...
				SetCommandFlags("tf_mvm_force_victory", flags|FCVAR_CHEAT);
				CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}VICTORY HAS BEEN FORCED! THE SERVER WILL RESTART IN 10 SECONDS.");
				CreateTimer(10.0, TimedOperator, 100);
				return Plugin_Handled;
			}
			JumpToWave(next_wave);
		}
		//Code Entry from FC Keypad
		case 100:{
			if (CodeEntry == 17){
				FireEntityInput("FB.BOOM", "StartShake", "", 0.0),
				CustomSoundEmitter(BMB3SND, SFXSNDLVL, false),
				FireEntityInput("FB.CodeCorrectKill", "Enable", "", 0.0),
				FireEntityInput("FB.KP*", "Lock", "", 0.0),
				FireEntityInput("FB.CodeCorrectKill", "Disable", "", 1.0);
			}
			else{
				CodeEntry = 0;
				FireEntityInput("FB.CodeFailedKill", "Enable", "", 0.0),
				FireEntityInput("FB.CodeFailedKill", "Disable", "", 1.0),
				CustomSoundEmitter("fartsy/memes/priceisright_fail.wav", SFXSNDLVL, false);
			}
		}
		case 101:{
			CodeEntry++;
		}
		case 102:{
			CodeEntry+=2;
		}
		case 103:{
			CodeEntry+=3;
		}
		case 104:{
			CodeEntry+=4;
		}
		case 105:{
			CodeEntry+=5;
		}
		case 106:{
			CodeEntry+=6;
		}
		case 107:{
			CodeEntry+=7;
		}
		case 108:{
			CodeEntry+=8;
		}
		case 109:{
			CodeEntry+=9;
		}
		//Taco Bell Edition
		case 210:{
			tacobell = true;
			ServerCommand("fb_startmoney 200000");
			CPrintToChatAll("{darkviolet}[{orange}INFO{darkviolet}] {white}You have chosen {red}DOVAH'S ASS - TACO BELL EDITION{white}. Why... Why would you DO THIS?! Do you not realize what you've just done?????");
		}
		// Select BGM
		case 1000:{
			ServerCommand("fb_operator 1001");
			CreateTimer(0.0, TimedOperator, 1); //Create a timer to use a CPU cycle so that we don't confuse stopSound with our target song.
		}
		//Stop current song
		case 1001:{
			if (StrEqual(curSong, "null")){
				return Plugin_Handled;
			}
			for(int i=1;i<=MaxClients;i++){
		        StopSound(i, SNDCHAN, curSong);
    		}
			return Plugin_Handled;
		}
		//Feature an admin
		case 1002:{
			FireEntityInput("AdminPicker", "SetTextureIndex", "10", 0.0);
			int i = GetRandomInt(1, 9);
			switch (i){
				case 1:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "1", 0.1);
						lastAdmin = 1;
					}
				}
				case 2:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "2", 0.1);
						lastAdmin = 2;
					}
				}
				case 3:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "3", 0.1);
						lastAdmin = 3;
					}
				}
				case 4:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "4", 0.1);
						lastAdmin = 4;
					}
				}
				case 5:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "5", 0.1);
						lastAdmin = 5;
					}
				}
				case 6:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "6", 0.1);
						lastAdmin = 6;
					}
				}
				case 7:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "7", 0.1);
						lastAdmin = 7;
					}
				}
				case 8:{
					if (i == lastAdmin)
					{
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "8", 0.1);
						lastAdmin = 8;
					}
				}
				case 9:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "9", 0.1);
						lastAdmin = 9;
					}
				}
				case 10:{
					if (i == lastAdmin){
						ServerCommand("fb_operator 1002");
					}
					else{
						FireEntityInput("AdminPicker", "SetTextureIndex", "10", 0.1);
					}
				}
			}
			return Plugin_Handled;
		}
		//Strike Lightning
		case 1003:{
			FireEntityInput("lightning", "TurnOn", "", 0.0),
			FireEntityInput("weather", "Skin", "4", 0.0),
			FireEntityInput("value", "TurnOff", "", 0.0),
			FireEntityInput("LightningLaser", "TurnOn", "", 0.0),
			FireEntityInput("lightning", "TurnOff", "", 0.1),
			FireEntityInput("weather", "Skin", "3", 0.1),
			FireEntityInput("LightningLaser", "TurnOff", "", 0.1),
			FireEntityInput("lightning", "TurnOn", "", 0.17),
			FireEntityInput("weather", "Skin", "4", 0.17),
			FireEntityInput("LightningLaser", "TurnOn", "", 0.17),
			FireEntityInput("lightning", "TurnOff", "", 0.25),
			FireEntityInput("weather", "Skin", "3", 0.25),
			FireEntityInput("LightningLaser", "TurnOff", "", 0.25);
		}
		//Activate Tornado Timer
		case 1004:{
			if (isWave && canTornado){
				float f = GetRandomFloat(210.0, 500.0);
				float t = f - 30.0;
				CreateTimer (t, TimedOperator, 40);
				CreateTimer(f, TimedOperator, 41);
			}
		}
		//Despawn the tornado
		case 1005:{
			FireEntityInput("tornadof1", "stop", "", 0.0),
			FireEntityInput("TornadoKill", "Disable", "", 0.0),
			FireEntityInput("tornadof1wind", "Disable", "", 0.0),
			FireEntityInput("tornadowindf1", "StopSound", "", 0.0),
			FireEntityInput("shaketriggerf1", "Disable", "", 0.0),
			FireEntityInput("tornadobutton", "Unlock", "", 30.0);
			FireEntityInput("FB.FakeTankTank01", "Kill", "", 0.0);
			FireEntityInput("FB.FakeTankPhys01", "Kill", "", 0.0);
			tornado = false;
			return Plugin_Handled;
		}
		//Crusader
		case 1006:{
			ServerCommand("fb_operator 1001"),
			FireEntityInput("FB.MusicTimer", "Disable", "", 0.0);
			crusader = true,
			CreateTimer(25.20, TimedOperator, 78),
			CreateTimer(63.20, TimedOperator, 80),
			PrintToServer("Starting Crusader via plugin!"),
			EmitSoundToAll("fartsy/misc/fartsyscrusader_bgm_locus.mp3"),
			CreateTimer(1.75, CRUSADERINCOMING),
			FireEntityInput("FB.BOOM", "StopShake", "", 3.0),
			FireEntityInput("FB.CRUSADER", "Enable", "", 25.20),
			FireEntityInput("CrusaderTrain", "StartForward", "", 25.20),
			FireEntityInput("CrusaderLaserBase*", "StartForward", "", 25.20),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.9", 38.0),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.7", 38.60),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.5", 39.20),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.3", 40.40),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.1", 41.40),
			FireEntityInput("CrusaderTrain", "Stop", "", 42.60),
			FireEntityInput("FB.CrusaderLaserKill01", "Disable", "", 42.60),
			FireEntityInput("FB.CrusaderNukeTimer", "Disable", "", 42.60),
			FireEntityInput("FB.LaserCore", "TurnOn", "", 45.80),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.35", 45.80),
			FireEntityInput("FB.ShakeCore", "StartShake", "", 45.80),
			FireEntityInput("CrusaderSprite", "Color", "255 128 128", 45.80),
			FireEntityInput("FB.ShakeCore", "StopShake", "", 48.80),
			FireEntityInput("FB.LaserInnerMost", "TurnOn", "", 49.20),
			FireEntityInput("FB.ShakeInner", "StartShake", "", 49.20),
			FireEntityInput("CrusaderSprite", "Color", "255 230 230", 49.20),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.35", 50.20),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.45", 50.60),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.55", 51.0),
			FireEntityInput("FB.ShakeInner", "StopShake", "", 52.10),
			FireEntityInput("FB.ShakeInner", "StartShake", "", 52.20),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.45", 54.0),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.4", 54.40),
			FireEntityInput("FB.ShakeInner", "StopShake", "", 55.0),
			FireEntityInput("FB.ShakeInner", "StartShake", "", 55.10),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.75", 57.20),
			FireEntityInput("FB.CrusaderSideLaser", "TurnOn", "", 57.20),
			FireEntityInput("FB.ShakeInner", "StopShake", "", 58.0),
			FireEntityInput("FB.ShakeInner", "StartShake", "", 58.10),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "1", 58.50),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.75", 60.80),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.65", 61.10),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.55", 61.40),
			FireEntityInput("FB.LaserCore", "TurnOff", "", 61.40),
			FireEntityInput("FB.LaserInnerMost", "TurnOff", "", 61.40),
			FireEntityInput("CrusaderSprite", "Color", "0 0 0", 61.40),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.45", 61.70),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.3", 62.0),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.15", 62.30),
			FireEntityInput("FB.CrusaderSideLaser", "TurnOff", "", 62.30),
			FireEntityInput("CrusaderLaserBase*", "Stop", "", 62.70),
			FireEntityInput("FB.Laser*", "TurnOn", "", 65.20),
			FireEntityInput("CrusaderLaserBase*", "StartForward", "", 65.20),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "1", 65.20),
			FireEntityInput("FB.ShakeBOOM", "StartShake", "", 65.20),
			FireEntityInput("FB.Fade", "Fade", "", 65.20),
			FireEntityInput("HurtAll", "AddOutput", "damagetype 1024", 65.10),
			FireEntityInput("HurtAll", "Enable", "", 65.20),
			FireEntityInput("FB.CrusaderSideLaser", "TurnOn", "", 65.20),
			FireEntityInput("CrusaderSprite", "Color", "255 230 255", 65.20),
			FireEntityInput("FB.Laser*", "TurnOff", "", 70.0),
			FireEntityInput("CrusaderTrain", "StartForward", "", 70.0),
			FireEntityInput("CrusaderLaserBase*", "Stop", "", 70.0),
			FireEntityInput("HurtAll", "Disable", "", 70.0),
			FireEntityInput("FB.CrusaderSideLaser", "TurnOff", "", 70.0),
			FireEntityInput("CrusaderSprite", "Color", "0 0 0", 70.0),
			FireEntityInput("FB.ShakeBOOM", "StopShake", "", 70.20),
			FireEntityInput("CrusaderTrain", "Stop", "", 80.0),
			FireEntityInput("FB.CRUSADER", "Disable", "", 80.0);
			CreateTimer(80.0, TimedOperator, 79);
		}
		//Choose bomb path
		case 1007:{
			FireEntityInput("Nest_EN060", "Disable", "", 0.0),
			FireEntityInput("Nest_EN050", "Disable", "", 0.0),
			FireEntityInput("Nest_EN040", "Disable", "", 0.0),
			FireEntityInput("Nest_EN030", "Disable", "", 0.0),
			FireEntityInput("Nest_EN020", "Disable", "", 0.0),
			FireEntityInput("Nest_EN010", "Disable", "", 0.0),
			FireEntityInput("Nest_L050", "Disable", "", 0.0),
			FireEntityInput("Nest_L040", "Disable", "", 0.0),
			FireEntityInput("Nest_L030", "Disable", "", 0.0),
			FireEntityInput("Nest_L020", "Disable", "", 0.0),
			FireEntityInput("Nest_L010", "Disable", "", 0.0),
			FireEntityInput("Nest_R040", "Disable", "", 0.0),
			FireEntityInput("Nest_R030", "Disable", "", 0.0),
			FireEntityInput("Nest_R020", "Disable", "", 0.0),
			FireEntityInput("Nest_R010", "Disable", "", 0.0),
			FireEntityInput("bombpath_right_prefer_flankers", "Disable", "", 0.0),
			FireEntityInput("bombpath_left_prefer_flankers", "Disable", "", 0.0),
			FireEntityInput("bombpath_left_navavoid", "Disable", "", 0.0),
			FireEntityInput("bombpath_right_navavoid", "Disable", "", 0.0),
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.0),
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.0);
			int i = GetRandomInt(1, 3);
			switch(i){
				case 1:{
					FireEntityInput("Nest_R040", "Enable", "", 0.25),
					FireEntityInput("Nest_R030", "Enable", "", 0.25),
					FireEntityInput("Nest_R020", "Enable", "", 0.25),
					FireEntityInput("Nest_R010", "Enable", "", 0.25),
					FireEntityInput("bombpath_right_prefer_flankers", "Enable", "", 0.25),
					FireEntityInput("bombpath_right_navavoid", "Enable", "", 0.25),
					FireEntityInput("bombpath_right_arrows", "Enable", "", 0.25);
				}
				case 2:{
					FireEntityInput("Nest_L050", "Enable", "", 0.25),
					FireEntityInput("Nest_L040", "Enable", "", 0.25),
					FireEntityInput("Nest_L030", "Enable", "", 0.25),
					FireEntityInput("Nest_L020", "Enable", "", 0.25),
					FireEntityInput("Nest_L010", "Enable", "", 0.25),
					FireEntityInput("bombpath_left_prefer_flankers", "Enable", "", 0.25),
					FireEntityInput("bombpath_left_navavoid", "Enable", "", 0.25),
					FireEntityInput("bombpath_left_arrows", "Enable", "", 0.25);
				}
				case 3:{
					FireEntityInput("dovahsassprefer", "Enable", "", 0.25),
					FireEntityInput("Nest_R040", "Enable", "", 0.25),
					FireEntityInput("Nest_R030", "Enable", "", 0.25),
					FireEntityInput("Nest_R020", "Enable", "", 0.25),
					FireEntityInput("Nest_R010", "Enable", "", 0.25),
					FireEntityInput("bombpath_right_prefer_flankers", "Enable", "", 0.25),
					FireEntityInput("bombpath_right_navavoid", "Enable", "", 0.25),
					FireEntityInput("bombpath_right_arrows", "Enable", "", 0.25);
				}
			}
		}
		case 6942:{
			sacPoints = 2147483647;
		}
		//Do not EVER EVER execute this unless it's an emergency...
		case 6969:{
			if (!isWave){
				CPrintToChatAll("{darkred} [CORE] ERROR, attempted to invoke function without an active wave.");
			}
			else{
				if (!brawler_emergency){
					brawler_emergency = true,
					EmitSoundToAll(SUS),
					CreateTimer(1.0, TimedOperator, 6969),
					CPrintToChatAll("{darkred}EMERGENCY MODE ACTIVE.");
					sacPoints = -2147483648;
					ServerCommand("sm_addcash @red 2000000");
					ServerCommand("sm_god @red 1");
				}
				else{
					CPrintToChatAll("{darkred}[CORE] Failed to enter emergency mode, it is already active.");
					return Plugin_Handled;
				}
			}
		}
	}
	return Plugin_Handled;
}

//Perform Wave Setup
public Action PerformWaveSetup(){
	isWave = true; //It's a wave!
	FailedCount = 0; //Reset fail count to zero. (See EventWaveFailed, where we play the BGM.)
	ServerCommand("fb_operator 1001"); //Stop any playing BGM
	CreateTimer(0.25, TimedOperator, 0); //Print wave information to global chat
	CreateTimer(2.5, PerformWaveAdverts); //Activate the mini hud
	CreateTimer(0.1, BombStatusUpdater); //Activate the bomb status updater
	CreateTimer(1.0, BombStatusAddTimer); //Activate bomb status timer
	CreateTimer(1.0, RobotLaunchTimer); //Activate robot launch timer
	CreateTimer(1.0, SacrificePointsTimer); //Activate sacrifice points add timer
	CreateTimer(1.0, SacrificePointsUpdater); //Activate sacrifice points updater
	CreateTimer(1.0, RefireStorm); //Activate thunderstorm
	FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1); //Disable right arrows TODO: Figure out why
	FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1); //Disable left arrows TODO: Figure out why
	FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0); //Activate Intel 1
	FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0); //Activate Intel 2
	FireEntityInput("CommonSpells", "Enable", "", 0.0); // Activate common spells
	FireEntityInput("rain", "Alpha", "200", 0.0); //Activate rain
	FireEntityInput("OldSpawn", "Enable", "", 0.0); //Activate Old Spawn
	FireEntityInput("NewSpawn", "Disable", "", 0.0); //De-activate New SpawnServerCommand("fb_operator 1002");
	ServerCommand("fb_operator 1002"); //Feature admin
	ServerCommand("fb_operator 1004"); //Activate Tornado Timer
	ServerCommand("fb_operator 1007"); //Choose bomb path
	return Plugin_Handled;
}

//Timed commands
public Action TimedOperator(Handle timer, int job){
	switch(job){
		case 0:{
			CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave %i: {forestgreen}%s", curWave, songName);
		}
		//Music system rewrite (again)
		case 1:{
			switch(BGMINDEX){
				//Default BGM indexes are 0 and 1.
				case 0,1:{
					int BGM = GetRandomInt(1, 2);
					switch(BGM){
						case 1:{
							CustomSoundEmitter(DEFAULTBGM1, DEFBGMSNDLVL-10, true);
							curSong = DEFAULTBGM1;
							songName = DEFAULTBGM1Title;
							BGMINDEX = 0;
							FireEntityInput("FB.MusicTimer", "RefireTime", "137.55", 0.0),
							FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
							FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
						}
						case 2:{
							CustomSoundEmitter(DEFAULTBGM2, DEFBGMSNDLVL-10, true);
							curSong = DEFAULTBGM2;
							songName = DEFAULTBGM2Title;
							BGMINDEX = 1;
							FireEntityInput("FB.MusicTimer", "RefireTime", "235.3", 0.0),
							FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
							FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
						}
					}
				}
				//BGM1
				case 2:{
					CustomSoundEmitter(BGM1, BGMSNDLVL, true);
					curSong = BGM1;
					songName = BGM1Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "229.05", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
				//BGM2
				case 3:{
					CustomSoundEmitter(BGM2, BGMSNDLVL, true);
					curSong = BGM2;
					songName = BGM2Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "153.75", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
				//BGM3
				case 4:{
					CustomSoundEmitter(BGM3, BGMSNDLVL, true);
					curSong = BGM3;
					songName = BGM3Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "166.65", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
				//BGM4
				case 5:{
					CustomSoundEmitter(BGM4, BGMSNDLVL-15, true);
					curSong = BGM4;
					songName = BGM4Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "122.05", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
				//BGM5
				case 6:{
					CustomSoundEmitter(BGM5, BGMSNDLVL-5, true);
					curSong = BGM5;
					songName = BGM5Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "131.55", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
				//BGM6
				case 7:{
					CustomSoundEmitter(BGM6, BGMSNDLVL, true);
					curSong = BGM6;
					songName = BGM6Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "427.15", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
				//BGM7
				case 8:{
					CustomSoundEmitter(BGM7, BGMSNDLVL, true);
					curSong = BGM7;
					songName = BGM7Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "133.05", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
				//BGM8
				case 9:{
					CustomSoundEmitter(BGM8, BGMSNDLVL-10, true);
					curSong = BGM8;
					songName = BGM8Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "215.0", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
				//BGM9
				case 10:{
					if(tbLoop == 0){
						curSong = BGM9Intro;
						songName = BGM9Title;
						CustomSoundEmitter(BGM9Intro, BGMSNDLVL-5, true);
						FireEntityInput("FB.MusicTimer", "RefireTime", "11.60", 0.0),
						FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
						FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
						tbLoop = 1;
					}
					else{					
						CustomSoundEmitter(BGM9, BGMSNDLVL, true);
						curSong = BGM9;
						songName = BGM9Title;
						FireEntityInput("FB.MusicTimer", "RefireTime", "111.7", 0.0),
						FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
						FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
					}
				}
				//BGM10
				case 11:{
					CustomSoundEmitter(BGM10, BGMSNDLVL, true);
					curSong = BGM10;
					songName = BGM10Title;
					FireEntityInput("FB.MusicTimer", "RefireTime", "511.8", 0.0),
					FireEntityInput("FB.MusicTimer", "Enable", "", 0.1),
					FireEntityInput("FB.MusicTimer", "ResetTimer", "", 0.1);
				}
			}
		}
		//Boss script
		case 2:{
			ServerCommand("fb_operator 1001"); //Stop all bgm.
			FireEntityInput("FB.MusicTimer", "Disable", "", 0.0); //Disable all bgm.
			CreateTimer(0.0, TimedOperator, 3);
		}
		//Boss script pt 2
		case 3:{
			CustomSoundEmitter(BGM10Intro, BGMSNDLVL, true);
			FireEntityInput("FB.FadeBLCK", "Fade", "", 3.0);
			FireEntityInput("FB.FadeBLCK", "Fade", "", 5.0);
			FireEntityInput("FB.FadeBLCK", "Fade", "", 7.0);
			FireEntityInput("FB.FadeBLCK", "Fade", "", 9.0);
			FireEntityInput("FB.FadeBLCK", "Fade", "", 12.0);
			CreateTimer(23.0, TimedOperator, 4);
		}
		//Boss script pt 3
		case 4:{
			CustomSoundEmitter(EVENTSTART, SFXSNDLVL, false),
			CreateTimer(4.1, TimedOperator, 5);
		}
		//Boss script pt 4
		case 5:{
			CustomSoundEmitter(VO_SEPHMEMORY, SFXSNDLVL, false),
			CreateTimer(3.2, TimedOperator, 6);
		}
		//Boss script pt 5
		case 6:{
			CustomSoundEmitter(HINDENBURGBOOM, SFXSNDLVL-10, false),
			FireEntityInput("FB.Fade", "Fade", "", 0.0),
			CreateTimer(1.7, TimedOperator, 7);
		}
		//DO THE THING ALREADY
		case 7:{
			BGMINDEX = 11;
			curSong = BGM10;
			songName = BGM10Title;
			CustomSoundEmitter(BGM10, BGMSNDLVL, true),
			CreateTimer(312.0, TimedOperator, 1);
		}
		//Signal boss to actually spawn after delay.
		case 8:{
			CustomSoundEmitter(VICTORY, SFXSNDLVL, false);
			CPrintToChatAll("{darkgreen}[CORE] You did it!!! {darkred}Or... did you...?");
			FireEntityInput("FB.FadeBLCK", "Fade", "", 0.0);
			CreateTimer(4.8, TimedOperator, 2);
		}
		//Incoming
		case 21:{
			CustomSoundEmitter(INCOMING, SFXSNDLVL, false);
			return Plugin_Stop;
		}
		case 37:{
			EmitSoundToAll(HINDENBURGBOOM);
			return Plugin_Stop;
		}
		case 40:{
			if(isWave && canTornado){
				EmitSoundToAll("mvm/ambient_mp3/mvm_siren.mp3"),
				TornadoWarningIssued = true;
			}
			return Plugin_Stop;
		}
		case 41:{
			if (isWave && canTornado && !tornado){
				FireEntityInput("TornadoKill", "Enable", "", 0.0),
				FireEntityInput("tornadobutton", "Lock", "", 0.0),
				FireEntityInput("tornadof1", "start", "", 20.0),
				FireEntityInput("shaketriggerf1", "Enable", "", 20.0),
				FireEntityInput("tornadowindf1", "PlaySound", "", 20.0),
				FireEntityInput("tornadof1wind", "Enable", "", 21.50);
				tornado = true;
				float f = GetRandomFloat(60.0, 120.0);
				CreateTimer(f, TimedOperator, 42);
			}
			return Plugin_Stop;
		}
		case 42:{
			ServerCommand("fb_operator 1005");
			TornadoWarningIssued = false;
			ServerCommand("fb_operator 1004");
		}
		case 60:{
			CustomSoundEmitter(OnslaughterFlamePostATK, SFXSNDLVL, false);
			return Plugin_Stop;
		}
		case 70:{
			if(isWave){
				FireEntityInput("FB.KP*", "Unlock", "", 0.0);
				CustomSoundEmitter(BELL, SFXSNDLVL, false);
			}
			return Plugin_Stop;
		}
		case 71:{
			CustomSoundEmitter("fartsy/eee/the_horn.wav", SFXSNDLVL, false);
			return Plugin_Stop;
		}
		case 78:{
			EmitSoundToAll(CRUSADERATTACK);
			return Plugin_Handled;
		}
		case 79:{
			crusader = false;
			int ent = FindEntityByClassname(-1, "tf_objective_resource");
			if(ent == -1){
				LogMessage("tf_objective_resource not found");
				return Plugin_Stop;
			}
			int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
			if (isWave && (current_wave == 3 || current_wave == 5)){
				ServerCommand("fb_operator 99");
			}
			else{
				return Plugin_Stop;
			}
			return Plugin_Stop;
		}
		case 80:{
			EmitSoundToAll(WTFBOOM);
			return Plugin_Handled;
		}
		case 99:{
			if (isWave){
			ServerCommand("fb_operator 99");
			}
			else{
				return Plugin_Stop;
			}
		}
		case 100:{
			ServerCommand("_restart");
		}
		case 6969:{
			if(isWave){
				ServerCommand("sm_freeze @blue; sm_smash @blue; sm_evilrocket @blue"),
				ServerCommand("fb_operator 2"),
				CreateTimer(4.0, TimedOperator, 6970);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6970:{
			if(isWave){
				EmitSoundToAll(COUNTDOWN),
				CreateTimer(7.0, TimedOperator, 6971);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6971:{
			if(isWave){
				ServerCommand("fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40"),
				CreateTimer(1.0, TimedOperator, 6972);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6972:{
			if (isWave){
				ServerCommand("fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42"),
				ServerCommand("fb_operator 1006"),
				CreateTimer(1.0, TimedOperator, 6973);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6973:{
			if(isWave){
				explodeType = 1,
				ServerCommand("fb_operator 15"),
				CreateTimer(1.0, TimedOperator, 6974);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6974:{
			if(isWave){
				explodeType = 2,
				ServerCommand("fb_operator 15;fb_operator 15"),
				CreateTimer(1.0, TimedOperator, 6975);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6975:{
			if(isWave){
				explodeType = 3,
				ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15"),
				CreateTimer(1.0, TimedOperator, 6976);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6976:{
			if(isWave){
				explodeType = 4,
				ServerCommand("fb_operator 15;fb_operator15;fb_operator 15;fb_operator 15"),
				CreateTimer(1.0, TimedOperator, 6977);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6977:{
			if(isWave){
				explodeType = 5,
				ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15"),
				CreateTimer(1.0, TimedOperator, 6978);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6978:{
			if(isWave){
				explodeType = 6,
				ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15"),
				ServerCommand("fb_operator 30"),
				CreateTimer(1.0, TimedOperator, 6979);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6979:{
			if(isWave){
				ServerCommand("fb_operator 31"),
				CreateTimer(1.0, TimedOperator, 6980);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6980:{
			if(isWave){
				ServerCommand("fb_operator 32"),
				CreateTimer(1.0, TimedOperator, 6981);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6981:{
			if(isWave){
				ServerCommand("fb_operator 33"),
				CreateTimer(1.0, TimedOperator, 6982);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6982:{
			if(isWave){
				ServerCommand("fb_operator 34"),
				CreateTimer(1.0, TimedOperator, 6983);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6983:{
			if(isWave){
				ServerCommand("fb_operator 35"),
				CreateTimer(1.0, TimedOperator, 6984);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6984:{
			if(isWave){
				ServerCommand("fb_operator 36"),
				CreateTimer(1.0, TimedOperator, 6985);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6985:{
			if(isWave){
				ServerCommand("fb_operator 37"),
				CreateTimer(1.0, TimedOperator, 6986);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6986:{
			if(isWave){
				ServerCommand("sm_freeze @blue -1; sm_smash @blue"),
				CreateTimer(3.0, TimedOperator, 6987);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6987:{
			if(isWave){
				ServerCommand("fb_operator 40; fb_operator 42; fb_operator 30; fb_operator 32; fb_operator 34; fb_operator 32; fb_operator 31; fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 31;fb_operator 32;fb_operator 32;fb_operator 31;fb_operator 32;fb_operator 32");
				CreateTimer(1.0, TimedOperator, 6988);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6988:{
			if(isWave){
				explodeType = 6,
				ServerCommand("fb_operator 15;fb_operator15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15"),
				ServerCommand("fb_operator 30"),
				ServerCommand("fb_operator 31"),
				ServerCommand("fb_operator 32"),
				ServerCommand("fb_operator 33"),
				ServerCommand("fb_operator 34"),
				ServerCommand("fb_operator 35"),
				ServerCommand("fb_operator 36"),
				ServerCommand("fb_operator 37"),
				ServerCommand("fb_operator 40"),
				ServerCommand("fb_operator 41"),
				ServerCommand("fb_operator 42"),
				ServerCommand("fb_operator 43"),
				ServerCommand("fb_operator 44"),
				ServerCommand("fb_operator 32"),
				ServerCommand("fb_operator 32"),
				ServerCommand("fb_operator 32"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				ServerCommand("fb_operator 1003"),
				CreateTimer(1.0, TimedOperator, 6989);
			}
			else{
				ExitEmergencyMode();
				return Plugin_Handled;
			}
		}
		case 6989:{
			CPrintToChatAll("{darkgreen}[CORE] Exiting emergency mode."),
			brawler_emergency = false;
			ServerCommand("sm_god @red 0");
			return Plugin_Handled;
		}
	}
	return Plugin_Stop;
}

//Exit emergency mode!
public void ExitEmergencyMode(){
	CPrintToChatAll("{darkgreen}[CORE] Exiting emergency mode, the wave has ended."),
	brawler_emergency = false;
	ServerCommand("sm_god @red 0");
}
