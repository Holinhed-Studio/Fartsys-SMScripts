#include <sourcemod>
Database BB_DB;
static char PLUGIN_VERSION[8] = "1.0.0";
bool rehash;

public Plugin myinfo = {
    name = "Burningbird Donator Rehash",
    author = "Fartsy",
    description = "Checks each minute for new donators and then rehashes the admins if needed",
    version = PLUGIN_VERSION,
    url = "https://wiki.firehostredux.com"
};

//Connect to database
public void OnConfigsExecuted() {
  if (!BB_DB) Database.Connect(BB_OnConnect, "bb_rehasher");
}

//Format database if needed
public void BB_OnConnect(Database db, char[] error, any data) {
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
  BB_DB = db;
  BB_DB.Query(Database_FastQuery, "CREATE TABLE IF NOT EXISTS bb_rehash(rehash INT UNSIGNED DEFAULT '0');");
  BB_DB.Query(Database_FastQuery, "INSERT INTO bb_rehash (rehash) VALUES (1) ON DUPLICATE KEY UPDATE rehash = 1;"); // Set to 1 so we don't miss out on donators between restarts.
  CreateTimer(60.0, CheckReloadStatus);
}

//Check if we need to rehash, do the rehash
public Action CheckReloadStatus(Handle timer){
  BB_DB.Query(Rehasher, "SELECT * FROM bb_rehash");
  return Plugin_Stop;
}

public void Rehasher(Database db, DBResultSet results, const char[] error, any data) {
  if (!results) {
    LogError("Failed to query database: %s", error);
    return;
  }
  if (results.FetchRow()) {
    rehash = results.FetchInt(0) == 1 ? true : false;
  }
  if (rehash){
    ServerCommand("sm_rehash");
    BB_DB.Query(Database_FastQuery, "UPDATE bb_rehash SET rehash = 0;"); 
  }
  CreateTimer(60.0, CheckReloadStatus);
  return;
}

//Database Fastquery Manager
public void Database_FastQuery(Database db, DBResultSet results, const char[] error, any data) {
  if (!results) LogError("Failed to query database: %s", error);
}