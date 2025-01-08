//Sync client stats when they leave
public void OnClientDisconnect(int client) {
  //Database Ass_Database = Get_Ass_Database();
  int steamID = GetSteamAccountID(client);
  if (steamID) {
    iDmgHealingTotal -= EmnityManager[client].iDamage;
    iDmgHealingTotal -= EmnityManager[client].iHealing;
  }
  if (!Ass_Database || !steamID || steamID <= 10000) return;
  char query[256];
  char clientName[128];
  GetClientInfo(client, "name", clientName, 128);
  Format(query, sizeof(query), "INSERT INTO ass_activity (name, steamid, date, seconds) VALUES ('%s', %d, CURRENT_DATE, %d) ON DUPLICATE KEY UPDATE name = '%s', seconds = seconds + VALUES(seconds);", clientName, steamID, GetClientMapTime(client), clientName);
  Ass_Database.Query(Database_FastQuery, query);
}
//Check who spawned and log their class
public Action EventSpawn(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
  if (IsValidClient(client)) {
    int class = Spawn_Event.GetInt("class");
    int steamID = GetSteamAccountID(client);
    if (!Ass_Database || !steamID || !class) return Plugin_Handled;
    char strClass[32];
    char query[256];
    strClass = ClassDefinitions[class - 1];
    Format(query, sizeof(query), "UPDATE ass_activity SET class = '%s' WHERE steamid = %i;", strClass, steamID);
    Ass_Database.Query(Database_FastQuery, query);
  }
  return Plugin_Handled;
}
//Log Damage!
public void Event_PlayerHurt(Handle event, const char[] name, bool dontBroadcast) {
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
  int damage = GetEventInt(event, "damageamount");
  if (IsValidClient(attacker) && attacker != client) {
    int steamID = GetSteamAccountID(attacker);
    if (!Ass_Database || !steamID) return;
    PrintToServer("Adding Damage %i dealt by %N, with index %i", damage, attacker, attacker);
    int healer = GetHealerOfClient(attacker);
    if (healer != -1){
      EmnityManager[healer].iDamage += RoundToFloor(damage * 0.35);
      iDmgHealingTotal += RoundToFloor(damage * 0.35);
    }
    EmnityManager[attacker].iDamage += damage;
    iDmgHealingTotal += damage;
    char query[256];
    Format(query, sizeof(query), "UPDATE ass_activity SET damagedealt = damagedealt + %i, damagedealtsession = damagedealtsession + %i WHERE steamid = %i;", damage, damage, steamID);
    Ass_Database.Query(Database_FastQuery, query);
  }
}
//Check who died by what and announce it to chat.
public Action EventDeath(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
  int attacker = GetClientOfUserId(Spawn_Event.GetInt("attacker"));
  int steamid = GetSteamAccountID(client);
  if(steamid){
    iDmgHealingTotal -= EmnityManager[client].iDamage;
    iDmgHealingTotal -= EmnityManager[client].iHealing;
    EmnityManager[client].iBossDamage = 0;
    EmnityManager[client].iDamage = 0;
    EmnityManager[client].iHealing = 0;
  }
  char name[64];
  char weapon[32];
  Format(name, sizeof(name), attacker == 0 ? "[INTENTIONAL GAME DESIGN]" : "%N", IsValidClient(attacker) ? client : attacker);
  Spawn_Event.GetString("weapon", weapon, sizeof(weapon));
  if (0 < client <= MaxClients && IsClientInGame(client)) {
    int damagebits = Spawn_Event.GetInt("damagebits");
    if (IsValidClient(attacker) && core.sacrificedByClient) SacrificeClient(client, attacker, core.bombReset);
    if (!attacker) {
      switch (damagebits) {
      case 1: { //CRUSH
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was crushed by a {red}FALLING ROCK FROM OUTER SPACE{white}!", client);
        weapon = "Meteor to the Face";
      }
      case 8: { //BURN
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was {red}MELTED{white}.", client);
        weapon = "Melted by Sharts or Ass Gas";
      }
      case 16: { //FREEZE
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was flattened out by a {red}TRAIN{white}!", client);
        weapon = "Attempted Train Robbery";
      }
      case 32: { //FALL
        if (WeatherManager.hasTornado) {
          switch (GetClientTeam(client)) {
          case 2: {
            CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was {red}%s{white}!", client, DeathMessage[GetRandomInt(0, 5)]);
            weapon = "Yeeted into Orbit via Tornado";
          }
          case 3: {
            CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was {red}%s{white}! ({limegreen}+1 pt{white})", client, DeathMessage[GetRandomInt(0, 5)]);
            core.sacPoints++;
            CustomSoundEmitter(SFXArray[GetRandomInt(11, 26)].realPath, 65, false, 0, 1.0, 100);
          }
          }
        } else {
          CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N fell to a {red}CLUMSY PAINFUL DEATH{white}!", client);
          weapon = "Tripped on a LEGO";
        }
      }
      case 64: { //BLAST
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N went {red} KABOOM{white}!", client);
        weapon = "Gone Kaboom!";
      }
      case 128: { //CLUB
        if (core.canHindenburg) {
          CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N is {red}CRASHING THE HINDENBURG{white}!!!", client);
          weapon = "Crashing the Hindenburg";
        }
      }
      case 256: { //SHOCK
      if(core.CodeEntry > 0){
          CPrintToChatAll("{darkviolet}[{red}EXTERMINATUS{darkviolet}] {white}Client %N has humliated themselves with an {red}incorrect {white}key entry!", client);
          weapon = "Failed FB Code Entry";
          int i = GetRandomInt(1, 16);
          switch (i) {
            case 1, 3, 10: {
              FastFire2("BG.Meteorites1", "ForceSpawn", "", 0.0, false);
              CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, a {red}METEOR{white}has been spotted coming towards Dovah's Ass!!!");
              FastFire2("bg.meteorite1", "StartForward", "", 0.1, false);
            }
            case 2, 5, 16: {
              CreateTimer(0.5, TimedOperator, 71);
              FastFire2("FB.TankTrain", "TeleportToPathTrack", "Tank01", 0.0, false);
              FastFire2("FB.TankTrain", "StartForward", "", 0.25, false);
              FastFire2("FB.TankTrain", "SetSpeed", "1", 0.35, false);
              FastFire2("FB.Tank", "Enable", "", 1.0, false);
            }
            case 4, 8, 14: {
              CustomSoundEmitter("ambient/alarms/train_horn_distant1.wav", 65, false, 0, 1.0, 100);
              FastFire2("TrainSND","PlaySound", "", 0.0, false);
              FastFire2("TrainDamage", "Enable", "", 0.0, false);
              FastFire2("Train01", "Enable", "", 0.0, false);
              CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {orange}KISSONE'S TRAIN{white}is {red}INCOMING{white}. Look out!");
              FastFire2("TrainTrain", "TeleportToPathTrack", "TrainTrack01", 0.0, false);
              FastFire2("TrainTrain", "StartForward", "", 0.1, false);
            }
            case 6, 9: {
              WeatherManager.canTornado = true;
              CreateTimer(1.0, TimedOperator, 41);
            }
            case 7, 13: {
              CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, it appears to have started raining a {red}METEOR SHOWER{white}!!!");
              core.canSENTMeteors = true;
              CreateTimer(1.0, SENTMeteorTimer);
              CreateTimer(30.0, TimedOperator, 12);
            }
            case 11: {
              FastFire2("FB.Slice", "Enable", "", 0.0, false);
              CustomSoundEmitter("ambient/sawblade_impact1.wav", 65, false, 0, 1.0, 100);
              FastFire2("FB.Slice", "Disable", "", 1.0, false);
            }
          }
        }
      }
      case 512: { //SONIC
        CPrintToChatAll("{darkviolet}[{red}EXTERMINATUS{darkviolet}] {white}Client %N has sacrificed themselves with a {forestgreen}correct {white}key entry! Prepare your anus!", client);
        sudo(1006);
        weapon = "Correct FB Code Entry";
      }
      case 1024: { //ENERGYBEAM
        char EnergyDeath[32];
        Format(EnergyDeath, sizeof(EnergyDeath), (core.crusader ? "THE CRUSADER" : core.waveFlags == 1 ? "ONSLAUGHTER" : "LIGHTNING"));
        weapon = (core.crusader ? "Crusader" : core.waveFlags == 1 ? "Onslaughter" : "Lightning");
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been %s by {red}%s{white}!", client, (core.crusader ? "nuked" : core.waveFlags == 1 ? "deleted" : "struck"), EnergyDeath);
      }
      case 16384: { //DROWN
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N {red}DROWNED{white}.", client);
        weapon = "Darwin Award for Drowning";
      }
      case 32768: { //PARALYZE
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been crushed by a {darkviolet}MYSTERIOUS BLUE BALL{white}!", client);
        weapon = "Mysterious Blue Ball";
      }
      case 65536: { //NERVEGAS
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been {red}SLICED TO RIBBONS{white}!", client);
        weapon = "FB Code Entry Failed";
      }
      case 131072: { //POISON
        CPrintToChat(client, "{darkviolet}[{red}CORE{darkviolet}] {white}Please don't sit {red}IDLE {white}in the FC Tavern.");
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was killed for standing in the Tavern instead of helping their team!", client);
        weapon = "Idle in FC Tavern..?";
      }
      case 262144: { //RADIATION
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was blown away by a {red}NUCLEAR EXPLOSION{white}!", client);
        weapon = "Nuclear Explosion";
      }
      case 524288: { //DROWNRECOVER
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N experienced {red}TACO BELL{white}!", client);
        weapon = "Taco Bell";
      }
      case 1048576: { //ACID
        CPrintToChatAll( isGoobbue ? "{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been crushed by a {forestgreen}FALLING GOOBBUE FROM OUTER SPACE{white}!" : "{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was deleted by {orange}AN AREA OF EFFECT{white}!", client);
        weapon = isGoobbue ? "Falling Goobbue" : "AREA_EFFECT";
      }
      }
    }
    //Log if a player killed someone or was killed by a robot
    if (attacker != client) {
      if (!Ass_Database) return Plugin_Handled;
      char query[256];
      int steamID = (IsValidClient(attacker) ? GetSteamAccountID(attacker) : GetSteamAccountID(client));
      Format(query, sizeof(query), IsValidClient(attacker) && !StrEqual(weapon, "world") ? "UPDATE ass_activity SET kills = kills +1, killssession = killssession + 1, lastkilledname = '%s', lastweaponused = '%s' WHERE steamid = %i;" : !StrEqual(weapon, "world") && !IsValidClient(attacker) ? "UPDATE ass_activity SET deaths = deaths + 1, deathssession = deathssession + 1, killedbyname = '%s', killedbyweapon = '%s' WHERE steamid = %i;" : "RETURN", name, weapon, steamID);
      if (StrEqual(query, "RETURN")) return Plugin_Handled;
      Ass_Database.Query(Database_FastQuery, query);
    }
  }
  return Plugin_Handled;
}
//When we win
public Action EventWaveComplete(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  sudo(300);
  CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}You've defeated the wave!");
  return Plugin_Handled;
}
//Announce when we are in danger.
public Action EventWarning(Event Spawn_Event,
  const char[] Spawn_Name, bool Spawn_Broadcast) {
  if (core.doFailsafe) {
    core.failsafeCount++;
    CPrintToChatAll("%s Counter: %i", failsafe[GetRandomInt(0, sizeof(failsafe) - 1)], core.failsafeCount);
    EmitSoundToAll(SFXArray[55].realPath);
    PerformWaveFailsafe(GetRandomInt(0,1));
    core.doFailsafe = false;
  } else CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {darkred}PROFESSOR'S ASS IS ABOUT TO BE DEPLOYED!!!");
  return Plugin_Handled;
}
//When the wave fails
public Action EventWaveFailed(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave {red}failed {white}successfully!");
  sudo(300);
  return Plugin_Handled;
}
//Sacrifice target and grant bonus points
public Action SacrificeClient(int client, int attacker, bool wasBombReset) {
  if (attacker <= MaxClients && IsClientInGame(attacker)) {
    core.bombReset = false;
    core.sacPoints += wasBombReset ? 5 : 1;
    core.sacrificedByClient = false;
    int steamID = GetSteamAccountID(attacker);
    if (!Ass_Database || !steamID) return Plugin_Handled;
    char query[256];
    CPrintToChatAll(wasBombReset ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%N {white}has reset the ass! ({limegreen}+5 pts{white})" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%N {white}has sacrificed {blue}%N {white}for the ass! ({limegreen}+1 pt{white})", attacker, client);
    Format(query, sizeof(query), wasBombReset ? "UPDATE ass_activity SET bombsreset = bombsreset + 1, bombsresetsession = bombsresetsession + 1 WHERE steamid = %i;" : "UPDATE ass_activity SET sacrifices = sacrifices + 1, sacrificessession = sacrificessession + 1 WHERE steamid = %i;", steamID);
    Ass_Database.Query(Database_FastQuery, query);
  }
  return Plugin_Handled;
}