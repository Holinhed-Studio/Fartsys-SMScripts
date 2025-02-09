#include <sourcemod>
#include <sdktools>
#include <clientprefs>
#include <tf2_stocks>
Database KSYS_Database;

//Registry of all playable classes
char ClassDefs[][32] = {
  "scout",
  "sniper",
  "soldier",
  "demoman",
  "medic",
  "heavy",
  "pyro",
  "spy",
  "engineer",
  ""
};

enum struct PLAYER_SOUNDS {
    char sound[256];
    char sound_old[256];
    int killcount;
}
PLAYER_SOUNDS PD[MAXPLAYERS+1];

stock bool IsValidClient(int client) {
  return (0 < client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client));
}

char PLUGIN_VERSION[8] = "1.0.0";

public Plugin myinfo = {
  name = "Fartsy's Kill Streak System",
  author = "Fartsy",
  description = "Allows users to listen to music on kill streaks",
  version = PLUGIN_VERSION,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart(){
    HookEvent("player_death", EventDeath);
    HookEvent("player_spawn", EventSpawn);
    RegConsoleCmd("sm_ksys", Command_SetKSYS, "Set your killstreak sounds");
}

//Connect to database
public void OnConfigsExecuted() {
  if (!KSYS_Database) Database.Connect(Database_OnConnect, "ksys");
}

//Format database if needed
public void Database_OnConnect(Database db, char[] error, any data) {
  if (!db) {
    LogError(error);
    return;
  }
  char buffer[64];
  db.Driver.GetIdentifier(buffer, sizeof(buffer));
  if (!StrEqual(buffer, "mysql", false)) {
    delete db;
    LogError("Could not connect to the database: expected mysql database.");
    return;
  }
  KSYS_Database = db;
  KSYS_Database.Query(Database_FastQuery, "CREATE TABLE IF NOT EXISTS killstreak_sounds(steamid INT UNSIGNED, scout TEXT DEFAULT 'null', soldier TEXT DEFAULT 'null', pyro TEXT DEFAULT 'null', demoman TEXT DEFAULT 'null', heavy TEXT DEFAULT 'null', engineer TEXT DEFAULT 'null', medic TEXT DEFAULT 'null', sniper TEXT DEFAULT 'null', spy TEXT DEFAULT 'null', streak INT UNSIGNED DEFAULT '5', PRIMARY KEY (steamid, streak));");
}

//Database Fastquery Manager - Writing only
void Database_FastQuery(Database db, DBResultSet results, const char[] error, any data) {
  if (!results) LogError("Failed to query database: %s", error);
}
public void Database_MergeDataError(Database db, any data, int numQueries,
  const char[] error, int failIndex, any[] queryData) {
  LogError("Failed to query database (transaction): %s", error);
}

//Set up thing with thing
public Action Command_SetKSYS(int client, int args){
    char class[16];
    char sound[256];
    char streak[8];
    GetCmdArg(1, class, sizeof(class));
    GetCmdArg(2, sound, sizeof(sound));
    GetCmdArg(3, streak, sizeof(streak));
    int steamID = GetSteamAccountID(client);
    if (!steamID || steamID <= 10000) return Plugin_Handled;
    else {
      if (!KSYS_Database) {
          LogError("NO DATABASE");
          return Plugin_Handled;
      }
      char query[1024];
      Format(query, sizeof(query), "INSERT INTO killstreak_sounds (steamid, %s, streak) VALUES ('%d', '%s', '%i') ON DUPLICATE KEY UPDATE %s = '%s';", class, steamID, sound, StringToInt(streak), class, sound);
      KSYS_Database.Query(Database_FastQuery, query);
    }
    return Plugin_Handled;
}

//Do Killstreak Sounds
public Action EventDeath(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
  int attacker = GetClientOfUserId(Spawn_Event.GetInt("attacker"));
  int steamid = GetSteamAccountID(attacker);
  if (steamid && client != attacker && IsValidClient(attacker)){
    PD[client].killcount = 0;
    PD[attacker].killcount++;
    for (int i = 5; i <= 50; i = i+5){
      if(i == PD[attacker].killcount){
          PrintToChatAll("%N has a killstreak of %i!", attacker, PD[attacker].killcount);
          char query[1024];
          Format(query, sizeof(query), "SELECT %s, streak FROM killstreak_sounds WHERE steamID = '%d' AND streak = '%i';", ClassDefs[GetEntProp(attacker, Prop_Send, "m_iClass") - 1], steamid, i);
          KSYS_Database.Query(KSYS_Query, query, attacker);
      }
    }
  }
  return Plugin_Continue;
}

public Action EventSpawn(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
  if (IsValidClient(client)) PD[client].killcount = 0;
  return Plugin_Continue;
}

void KSYS_Query(Database db, DBResultSet results, const char[] error, int client) {
  if (!results) return;
  if (results.FetchRow()) {
    results.FetchString(0, PD[client].sound, 256);
    if (strcmp(PD[client].sound, "null") == 0 || strcmp(PD[client].sound, "") == 0) return;
    PrecacheSound(PD[client].sound, true);
    if (strcmp(PD[client].sound_old, "") != 0 || strcmp(PD[client].sound_old, PD[client].sound) != 0) for (int i = 0; i < 10; i++) StopSound(client, i, PD[client].sound_old);
    EmitSoundToClient(client, PD[client].sound);
    strcopy(PD[client].sound_old, 256, PD[client].sound);
  }
}