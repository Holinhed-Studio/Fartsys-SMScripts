/*                         WELCOME TO FARTSY'S ASS ROTTENBURG.
 *
 *   A FEW THINGS TO KNOW: ONE.... THIS IS INTENDED TO BE USED WITH UBERUPGRADES.
 *   TWO..... THE MUSIC USED WITH THIS MOD MAY OR MAY NOT BE COPYRIGHTED. WE HAVE NO INTENTION ON INFRINGEMENT. THIS PROJECT IS PURELY NON PROFIT AND JUST FOR FUN. SHOULD COPYRIGHT HOLDERS WISH THIS PROJECT BE TAKEN DOWN, I (Fartsy) SHALL OBLIGE WITHOUT HESITATION.
 *   THREE..... THIS MOD IS INTENDED FOR USE ON THE FIREHOSTREDUX SERVERS ONLY. SUPPORT IS LIMITED.
 *   FOUR..... THIS WAS A NIGHTMARE TO FIGURE OUT AND BUG FIX. I HOPE IT WAS WORTH IT.
 *   FIVE..... PLEASE HAVE FUN AND ENJOY YOURSELF!
 *   SIX..... THE DURATION OF MUSIC TIMERS SHOULD BE SET DEPENDING WHAT SONG IS USED. SET THIS USING THE INTS IN THE VARIABLES INCLUDE. SONG DUR IN SECONDS / 0.0151515151515 = REFIRE TIME.
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
#include <ass_helper>
#pragma newdecls required
#pragma semicolon 1
static char PLUGIN_VERSION[8] = "7.0.0-pre7";

public Plugin myinfo = {
  name = "Fartsy's Ass - Framework",
  author = "Fartsy",
  description = "Framework for Fartsy's Ass (MvM Mods)",
  version = PLUGIN_VERSION,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart() {
  AssLogger(1, "####### STARTUP SEQUENCE INITIATED... PREPARE FOR THE END TIMES #######");
  RegisterAndPrecacheAllFiles();
  RegisterAllCommands();
  SetupCoreData();
  PrecacheSound(TBGM0, true);
  PrecacheSound(TBGM2, true);
  PrecacheSound(TBGM3, true);
  PrecacheSound(TBGM4, true);
  PrecacheSound(TBGM5, true);
  PrecacheSound(TBGM6, true);
  HookEvent("player_death", EventDeath);
  HookEvent("player_spawn", EventSpawn);
  HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre);
  HookEvent("mvm_wave_complete", EventWaveComplete);
  HookEvent("mvm_wave_failed", EventWaveFailed);
  HookEvent("mvm_bomb_alarm_triggered", EventWarning);
  HookEventEx("player_hurt", Event_Playerhurt, EventHookMode_Pre);
  CPrintToChatAll("{darkred}Plugin Reloaded. If you do not hear music, please do !sounds and configure your preferences.");
  cvarSNDDefault = CreateConVar("sm_fartsysass_sound", "3", "Default sound for new users, 3 = Everything, 2 = Sounds Only, 1 = Music Only, 0 = Nothing");
  SetCookieMenuItem(FartsysSNDSelected, 0, "Fartsys Ass Sound Preferences");
  Format(LoggerInfo, sizeof(LoggerInfo), "####### STARTUP COMPLETE (v%s) #######", PLUGIN_VERSION);
  AssLogger(1, LoggerInfo);
}

//Music system rewrite for the 5th time. Can I ever make a change? Will my code begin to mend? Still everything's the same and it all just fades to math.
public void OnGameFrame() {
  if (core.tickMusic) {
    core.ticksMusic++;
    if (core.ticksMusic >= core.refireTime) {
      if(core.shouldStopMusic){
        for (int i = 1; i <= MaxClients; i++) {
          StopSound(i, core.SNDCHAN, core.cachedPath);
          core.shouldStopMusic = false;
        }
      }
      core.realPath = BGMArray[core.BGMINDEX].realPath;
      core.songName = BGMArray[core.BGMINDEX].songName;
      core.refireTime = BGMArray[core.BGMINDEX].refireTime;
      core.ticksMusic = (core.tickOffset ? BGMArray[core.BGMINDEX].ticksOffset : 0);
      CustomSoundEmitter(BGMArray[core.BGMINDEX].realPath, BGMArray[core.BGMINDEX].SNDLVL, true, 1, 1.0, 100);
      CreateTimer(1.0, SyncMusic);
    }
  }
}

//Restart music for the new client
public Action RefireMusicForClient(Handle timer, int client){
  if(IsValidClient(client)){
    if(GetClientTeam(client) == 0)
      CreateTimer(1.0, RefireMusicForClient, client);
    else if (GetClientTeam(client) == 2)
      CSEClient(client, BGMArray[core.BGMINDEX].realPath, BGMArray[core.BGMINDEX].SNDLVL, true, 1, 1.0, 100);
  }
  return Plugin_Stop;
}

public Action Command_MyStats(int client, int args) {
  int steamID = GetSteamAccountID(client);
  if (!FB_Database || !steamID || steamID <= 10000) return Plugin_Stop;
  char queryID[256];
  Format(queryID, sizeof(queryID), "SELECT * from ass_activity WHERE steamid = %d;", steamID);
  PrintToServer(queryID);
  FB_Database.Query(MyStats, queryID, client);
  return Plugin_Continue;
}

public void MyStats(Database db, DBResultSet results, const char[] error, int client) {
  if (!results) {
    LogError("Failed to query database: %s", error);
    return;
  }
  char name[64];
  char class[64];
  int health, healthMax, steamID, damagedealt, damagedealtsession, kills, killssession, deaths, deathssession, bombsreset, bombsresetsession, sacrifices, sacrificessession;
  char lastkilledname[128];
  char lastusedweapon[128];
  char killedbyname[128];
  char killedbyweapon[128];
  if(results.FetchRow()){
    results.FetchString(0, name, 64); //name
    steamID = results.FetchInt(1); //steamid
    results.FetchString(4, class, 64); //class
    health = results.FetchInt(5); //health
    healthMax = results.FetchInt(6); //health
    damagedealt = results.FetchInt(7); //damage dealt
    damagedealtsession = results.FetchInt(8); //damage dealt session
    kills = results.FetchInt(9); //kills
    killssession = results.FetchInt(10); //kills session
    deaths = results.FetchInt(11); //deaths
    deathssession = results.FetchInt(12); //deaths session
    bombsreset = results.FetchInt(13); //bombs reset
    bombsresetsession = results.FetchInt(14); //bombs reset session
    sacrifices = results.FetchInt(15); //sacrifices
    sacrificessession = results.FetchInt(16); //sacrifices session
    results.FetchString(17, lastkilledname, sizeof(lastkilledname)); //last client killed
    results.FetchString(18, lastusedweapon, sizeof(lastusedweapon)); //using weapon
    results.FetchString(19, killedbyname, sizeof(killedbyname)); //last client that killed
    results.FetchString(20, killedbyweapon, sizeof(killedbyweapon)); //using weapon
    CPrintToChat(client, "\x07AAAAAA[CORE] Showing stats of %s   [%s, %i/%i hp] || SteamID: %i ", name, class, health, healthMax, steamID);
    CPrintToChat(client, "{white}Damage Dealt: %i (Session: %i) || Kills: %i (Session: %i) || Deaths: %i (Session: %i) || Bombs Reset: %i (Session: %i)", damagedealt, damagedealtsession, kills, killssession, deaths, deathssession, bombsreset, bombsresetsession);
    CPrintToChat(client, "Sacrifices: %i(Session:%i) || Killed %s (using %s) || Last killed by: %s (using %s)", sacrifices, sacrificessession, lastkilledname, lastusedweapon, killedbyname, killedbyweapon);
  }
  return;
}

//Sync client stats when they leave
public void OnClientDisconnect(int client) {
  int steamID = GetSteamAccountID(client);
  if (!FB_Database || !steamID || steamID <= 10000) return;
  char query[256];
  char clientName[128];
  GetClientInfo(client, "name", clientName, 128);
  Format(query, sizeof(query), "INSERT INTO ass_activity (name, steamid, date, seconds) VALUES ('%s', %d, CURRENT_DATE, %d) ON DUPLICATE KEY UPDATE name = '%s', seconds = seconds + VALUES(seconds);", clientName, steamID, GetClientMapTime(client), clientName);
  FB_Database.Query(Database_FastQuery, query);
}

//Clientprefs built in menu
public void FartsysSNDSelected(int client, CookieMenuAction action, any info, char[] buffer, int maxlen) {
  if (action == CookieMenuAction_SelectOption)
    ShowFartsyMenu(client);
}

//Queue music for new clients, also track their health.
public void OnClientPostAdminCheck(int client){
  if(!IsFakeClient(client) && core.bgmPlaying)
    CreateTimer(1.0, RefireMusicForClient, client);
  int steamID = GetSteamAccountID(client);
  if (!steamID || steamID <= 10000) return;
    else {
      if (!FB_Database) {
        PrintToServer("No database detected, setting soundPreference for %N to default.", client);
        soundPreference[client] = GetConVarInt(cvarSNDDefault);
      }
      if (!core.tickingClientHealth) {
        CreateTimer(1.0, TickClientHealth);
        core.tickingClientHealth = true;
      }
      if (!core.bgmPlaying)
        SetupMusic(GetRandomInt(1, 4));
      char query[1024];
      Format(query, sizeof(query), "INSERT INTO ass_activity (name, steamid, date, damagedealtsession, killssession, deathssession, bombsresetsession, sacrificessession) VALUES ('%N', %d, CURRENT_DATE, 0, 0, 0, 0, 0) ON DUPLICATE KEY UPDATE name = '%N', damagedealtsession = 0, killssession = 0, deathssession = 0, bombsresetsession = 0, sacrificessession = 0;", client, steamID, client);
      FB_Database.Query(Database_FastQuery, query);
      char queryID[256];
      Format(queryID, sizeof(queryID), "SELECT soundprefs from ass_activity WHERE steamid = '%d';", steamID);
      FB_Database.Query(SQL_SNDPrefs, queryID, client);
    }
}

//Get client sound prefs
public void SQL_SNDPrefs(Database db, DBResultSet results, const char[] error, int client) {
  if (!results) {
    LogError("Failed to query database: %s", error);
    return;
  }
  if (!IsValidClient(client)) return;
  if (results.FetchRow()) soundPreference[client] = results.FetchInt(0);
}

//Send client sound menu
public void ShowFartsyMenu(int client) {
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

// Create menu
public Action Command_Sounds(int client, int args) {
  int steamID = GetSteamAccountID(client);
  if (!steamID || steamID <= 10000) return Plugin_Handled;
  else {
    char queryID[256];
    Format(queryID, sizeof(queryID), "SELECT soundprefs from ass_activity WHERE steamid = '%d';", steamID);
    FB_Database.Query(SQL_SNDPrefs, queryID, client);
    ShowFartsyMenu(client);
    PrintToChat(client, sndPrefs[soundPreference[client]]);
    return Plugin_Handled;
  }
}

// This selects or disables the sounds
public int MenuHandlerFartsy(Menu menu, MenuAction action, int param1, int param2) {
  if (action == MenuAction_Select) {
    char query[256];
    int steamID = GetSteamAccountID(param1);
    if (!FB_Database || !steamID) return 0;
    else {
      Format(query, sizeof(query), "UPDATE ass_activity SET soundprefs = '%i' WHERE steamid = '%d';", param2, steamID);
      FB_Database.Query(Database_FastQuery, query);
      soundPreference[param1] = param2;
      Command_Sounds(param1, 0);
    }
  }
  else if (action == MenuAction_End) CloseHandle(menu);
  return 0;
}

//Fartsy's A.S.S
public Action Command_SacrificePointShop(int client, int args) {
  ShowFartsysAss(client);
  return Plugin_Handled;
}

//Fartsy's A.S.S
public void ShowFartsysAss(int client) {
  CPrintToChat(client, (!core.isWave ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}The sacrificial points counter is currently at %i of %i maximum for this wave." :  core.sacPoints <= 9 ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {red}You do not have enough sacrifice points to use this shop. You have %i / 10 required." : ""), core.sacPoints, core.sacPointsMax);
  if (!core.isWave) return;
  else {
    Menu menu = new Menu(MenuHandlerFartsysAss, MENU_ACTIONS_DEFAULT);
    char buffer[100];
    menu.SetTitle("Fartsy's Annihilation Supply Shop");
    menu.ExitButton = true;
    for (int i = 0; i < RoundToFloor(core.sacPoints / 10.0); i++)
      menu.AddItem(buffer, ASS[i]);
    menu.Display(client, 20);
  }
}

//Also Fartsy's A.S.S
public int MenuHandlerFartsysAss(Menu menu, MenuAction action, int param1, int param2) {
  if (action == MenuAction_Select) {
    //PrintToChatAll("Got %i", param2);
    switch (param2) {
      case 0: {
        if (core.sacPoints <= 9) return 0;
        else sudo(30); // bath salts
      }
      case 1: {
        if (core.sacPoints <= 19) return 0;
        else sudo(31); // goobbue
      }
      case 2: {
        if (core.sacPoints <= 29 || core.doFailsafe) return 0;
        else sudo(32); // failsafe
      }
      case 3: {
        if (core.sacPoints <= 39) return 0;
        else sudo(33); //explosive paradise
      }
      case 4: {
        if (core.sacPoints <= 49) return 0;
        else sudo(34); //Banish tornadoes
      }
      case 5: {
        if (core.sacPoints <= 59) return 0;
        else sudo(35); //Ass Gas
      }
      case 6: {
        if (core.sacPoints <= 69) return 0;
        else sudo (36); //Instant fat man
      }
      case 7: {
        if (core.sacPoints <= 79) return 0;
        else sudo(37);
      }
      case 8: {
        if (core.sacPoints <= 74) return 0;
        else sudo(38);
      }
      case 9: {
        if (core.sacPoints <= 99) return 0;
        else sudo(39);
      }
    }
    Format (LoggerInfo, sizeof(LoggerInfo), "%N opted for %s via the A.S.S.", param1, ASS[param2]);
    AssLogger(1, LoggerInfo);
  }
  else if (action == MenuAction_End)
    CloseHandle(menu);
  return 0;
}

//Now that command definitions are done, lets make some things happen.
public void OnMapStart() {
  CreateTimer(1.0, SelectAdminTimer);
  FireEntityInput("rain", "Alpha", "0", 0.0);
  sudo(1002);
}

//Adverts for tips/tricks
public Action PerformAdverts(Handle timer) {
  if (!core.isWave) {
    CreateTimer(180.0, PerformAdverts);
    CPrintToChatAll(AdvMessage[GetRandomInt(0, 7)]);
  }
  return Plugin_Stop;
}

//Adverts for wave information
public Action PerformWaveAdverts(Handle timer) {
  if (core.isWave) {
    char buffer[16];
    char tbuffer[16];
    char HintText[256];
    int sPos = RoundToFloor(core.ticksMusic/66.6666666666);
    int tPos = RoundToFloor(core.refireTime/66.6666666666);
    Format(buffer, 16, "%02d:%02d", sPos / 60, sPos % 60);
    Format(tbuffer, 16, "%02d:%02d", tPos / 60, tPos % 60);
    Format (HintText, sizeof(HintText), (core.bombProgression ? "Payload: MOVING (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)" : bombState[0].ready ? "Payload: READY (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)" : "Payload: PREPARING (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)"), core.bombStatus, core.bombStatusMax, core.sacPoints, core.sacPointsMax, core.songName, buffer, tbuffer);
    CreateTimer(2.5, PerformWaveAdverts);
    for (int i = 1; i <= MaxClients; i++) {
      if(IsValidClient(i)){
        PrintHintText(i, (core.TornadoWarningIssued ? "%s \n\n[TORNADO WARNING]" : "%s"), HintText, HintText);
        StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
      }
    }
  }
  return Plugin_Stop;
}

//Feature admin timer
public Action SelectAdminTimer(Handle timer) {
  if (core.isWave) return Plugin_Stop;
  else {
    sudo(1002);
    CreateTimer(GetRandomFloat(40.0, 120.0), SelectAdminTimer);
    return Plugin_Stop;
  }
}

//Brute Justice Timer
public Action OnslaughterATK(Handle timer) {
  if (core.waveFlags != 1) return Plugin_Stop;
  else {
    CreateTimer(GetRandomFloat(5.0, 7.0), OnslaughterATK);
    FireEntityInput("BruteJusticeDefaultATK", "FireMultiple", "3", 5.0);
    switch (GetRandomInt(1, 10)) {
      case 1, 6: {
        FireEntityInput("BruteJusticeLaserParticle", "Start", "", 0.0);
        CustomSoundEmitter(SFXArray[38], 65, false, 0, 1.0, 100);
        FireEntityInput("BruteJusticeLaser", "TurnOn", "", 1.40);
        FireEntityInput("BruteJusticeLaserHurtAOE", "Enable", "", 1.40);
        FireEntityInput("BruteJusticeLaserParticle", "Stop", "", 3.00);
        FireEntityInput("BruteJusticeLaser", "TurnOff", "", 3.25);
        FireEntityInput("BruteJusticeLaserHurtAOE", "Disable", "", 3.25);
      }
      case 2, 8: {
        FireEntityInput("BruteJustice", "FireUser1", "", 0.0);
      }
      case 3, 7: {
        FireEntityInput("BruteJusticeFlameParticle", "Start", "", 0.0);
        FireEntityInput("BruteJusticeFlamethrowerHurtAOE", "Enable", "", 0.0);
        CustomSoundEmitter(SFXArray[39], 65, false, 0, 1.0, 100);
        FireEntityInput("SND.BruteJusticeFlameATK", "PlaySound", "", 1.25);
        FireEntityInput("BruteJusticeFlamethrowerHurtAOE", "Disable", "", 5.0);
        FireEntityInput("BruteJusticeFlameParticle", "Stop", "", 5.0);
        FireEntityInput("SND.BruteJusticeFlameATK", "FadeOut", ".25", 5.0);
        CreateTimer(5.0, TimedOperator, 60);
        FireEntityInput("SND.BruteJusticeFlameATK", "StopSound", "", 5.10);
      }
      case 4: {
        FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 0.0);
        FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 3.0);
        FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 5.0);
      }
      case 5: {
        FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "50", 0.0);
      }
      case 9: {
        FireEntityInput("BruteJusticeRocketSpammer", "FireOnce", "", 0.00);
        FireEntityInput("BruteJusticeRocketSpammer", "FireOnce", "", 5.00);
      }
      case 10: {
        FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 0.00);
        FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 3.00);
        FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 5.00);
      }
    }
  }
  return Plugin_Stop;
}

//Sephiroth Timer
public Action SephATK(Handle timer) {
  if (core.waveFlags != 2) {
    return Plugin_Stop;
  } else {
    float f = GetRandomFloat(5.0, 10.0);
    CreateTimer(f, SephATK);
    FireEntityInput("SephArrows", "FireMultiple", "3", 5.0);
    int i = GetRandomInt(1, 12);
    switch (i) {
      case 1, 6: {
        CreateTimer(1.0, SephNukeTimer);
        CreateTimer(7.0, TimedOperator, 11);
        core.canSephNuke = true;
      }
      case 2, 8: {
        CPrintToChatAll("{blue}Sephiroth: Say goodbye!");
        FireEntityInput("SephMeteor", "ForceSpawn", "", 0.0);
      }
      case 3, 7: {
        FireEntityInput("SephNuke", "ForceSpawn", "", 0.0);
        CustomSoundEmitter(SFXArray[8], 65, false, 0, 1.0, 100);
      }
      case 4: {
        FireEntityInput("SephRocketSpammer", "FireMultiple", "10", 0.0);
        FireEntityInput("SephRocketSpammer", "FireMultiple", "10", 3.0);
        FireEntityInput("SkeleSpawner", "Enable", "", 0.0);
        FireEntityInput("SkeleSpawner", "Disable", "", 20.0);
      }
      case 5: {
        CPrintToChatAll("{blue}Sephiroth: Have at thee!");
        FireEntityInput("SephRocketSpammer", "FireMultiple", "50", 0.0);
      }
      case 9: {
        FireEntityInput("SephRocketSpammer", "FireOnce", "", 0.00);
        FireEntityInput("SephRocketSpammer", "FireOnce", "", 5.00);
      }
      case 10: {
        CPrintToChatAll("{blue}Sephiroth: I dare say you will go off with a bang! HAHAHAHAHAHAHAA");
        FireEntityInput("SephRocketSpammer", "FireMultiple", "10", 0.00);
        FireEntityInput("SephRocketSpammer", "FireMultiple", "10", 3.00);
        FireEntityInput("SephRocketSpammer", "FireMultiple", "10", 5.00);
      }
      case 11: {
        CPrintToChatAll("{blue}Sephiroth: Hahaha, let's see how you like THIS!"),
          ServerCommand("sm_smash @red");
      }
      case 12: {
        CPrintToChatAll("{blue}Sephiroth: Ohhhh, you dare oppose ME?");
      }
    }
  }
  return Plugin_Stop;
}

//Boss Health Timer
public Action BossHPTimer(Handle timer) {
  int BossEnt = (core.waveFlags == 1 ? FindEntityByTargetname("OnslaughterTank", "tank_boss") : core.waveFlags == 2 ? FindEntityByTargetname("SephirothTank", "tank_boss") : -1);
  int BossRelayEnt = (core.waveFlags == 1 ? FindEntityByTargetname("FB.BruteJusticeDMGRelay","func_physbox") : core.waveFlags == 2 ? FindEntityByTargetname("FB.SephirothDMGRelay", "func_physbox") : -1);
  if (BossEnt == -1 || BossRelayEnt == -1) return Plugin_Stop;
  CPrintToChatAll((core.waveFlags == 1 ? "{blue}Onslaughter's HP: %i (%i)" : core.waveFlags == 2 ? "{blue}Sephiroth's HP: %i (%i)" : "{blue}Error: Boss not found... core.waveFlags was neither 1 nor 2"), GetEntProp(BossEnt, Prop_Data, "m_iHealth"), GetEntProp(BossRelayEnt, Prop_Data, "m_iHealth"));
  CreateTimer(10.0, BossHPTimer);
  return Plugin_Stop;
}

//Shark Timer
public Action SharkTimer(Handle timer) {
  if (core.canSENTShark) {
    FireEntityInput("SentSharkTorpedo", "ForceSpawn", "", 0.0);
    CreateTimer(GetRandomFloat(2.0, 5.0), SharkTimer);
    CustomSoundEmitter(SFXArray[GetRandomInt(43, 50)], 65, false, 0, 1.0, 100);
  }
  return Plugin_Stop;
}

//Storm
public Action RefireStorm(Handle timer) {
  if (core.isWave) {
    CreateTimer(GetRandomFloat(7.0, 17.0), RefireStorm);
    sudo(1003);
    int StrikePos = GetRandomInt(0, 15);
    FireEntityInput(StrikeAt[StrikePos], "Enable", "", 0.0);
    FireEntityInput(StrikeAt[StrikePos], "Disable", "", 0.07);
    CustomSoundEmitter(SFXArray[GetRandomInt(27, 34)], 65, false, 0, 1.0, 100);
  }
  return Plugin_Stop;
}

//SpecTimer
public Action SpecTimer(Handle timer) {
  if (core.isWave) {
    FireEntityInput("Spec*", "Disable", "", 0.0);
    FireEntityInput(SpecEnt[GetRandomInt(0, 5)], "Enable", "", 0.1);
  }
  CreateTimer(GetRandomFloat(10.0, 30.0), SpecTimer);
  return Plugin_Stop;
}

//SENTMeteor (Scripted Entity Meteors)
public Action SENTMeteorTimer(Handle timer) {
  if (core.canSENTMeteors) {
    CreateTimer(5.0, SENTMeteorTimer);
    FireEntityInput(FB_SENT[GetRandomInt(0, 4)], "ForceSpawn", "", 0.0); // replace me with teleportEntity eventually then forcespawn...
  }
  return Plugin_Stop;
}

//CrusaderSentNukes
public Action CrusaderNukeTimer(Handle timer) {
  if (core.canCrusaderNuke) {
    CustomSoundEmitter(SFXArray[8], 65, false, 0, 1.0, 100);
    FireEntityInput("FB.CrusaderNuke", "ForceSpawn", "", 0.0);
    CreateTimer(GetRandomFloat(1.5, 3.0), CrusaderNukeTimer);
  }
  return Plugin_Stop;
}

//SephSentNukes
public Action SephNukeTimer(Handle timer) {
  if (core.canSephNuke) {
    CustomSoundEmitter(SFXArray[8], 65, false, 0, 1.0, 100),
      FireEntityInput("SephNuke", "ForceSpawn", "", 0.0);
    CreateTimer(GetRandomFloat(1.5, 3.0), SephNukeTimer);
  }
  return Plugin_Stop;
}

//SENTStars (Scripted Entity Stars)
public Action SENTStarTimer(Handle timer) {
  if (core.canSENTStars) {
    FireEntityInput(FB_SENT[10], "ForceSpawn", "", 0.0); // replace me with teleportEntity eventually then forcespawn...
    CreateTimer(GetRandomFloat(0.75, 1.5), SENTStarTimer);
  }
  return Plugin_Stop;
}

//Crusader Incoming Timer for Crusader
public Action CRUSADERINCOMING(Handle timer) {
  if (!core.crusader || core.INCOMINGDISPLAYED > 17) {
    core.INCOMINGDISPLAYED = 0;
    return Plugin_Stop;
  } else {
    core.INCOMINGDISPLAYED++;
    FireEntityInput("FB.INCOMING", "Display", "", 0.0);
    CreateTimer(1.75, CRUSADERINCOMING);
  }
  return Plugin_Stop;
}

//Halloween Bosses
public Action HWBosses(Handle timer) {
  if (core.isWave && core.canHWBoss) {
    int i = GetRandomInt(1, 10);
    switch (i) {
    case 1: {
      FireEntityInput("hhh_maker", "ForceSpawn", "", 0.0);
      FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
    }
    case 2: {
      FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
    }
    case 3: {

      FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0),
        FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
        FireEntityInput("SkeleSpawner", "Disable", "", 10.0);
    }
    case 4: {
      FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
        FireEntityInput("SkeleSpawner", "Disable", "", 10.0);
    }
    case 5: {
      FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
        FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
    }
    case 6: {
      FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
        FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
        FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
    }
    case 7: {
      FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
        FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0);
    }
    case 8: {
      FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
        FireEntityInput("SkeleSpawner", "Disable", "", 30.0);
    }
    case 9: {
      FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
        FireEntityInput("SkeleSpawner", "Disable", "", 60.0),
        FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
        FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
        FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
    }
    case 10: {
      FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0);
    }
    }
    core.canHWBoss = false;
    CreateTimer(60.0, HWBossesRefire);
  }
  return Plugin_Stop;
}

//Repeat HWBosses Timer
public Action HWBossesRefire(Handle timer) {
  if (core.isWave) CreateTimer(GetRandomFloat(core.HWNMin, core.HWNMax), HWBosses);
  return Plugin_Stop;
}

//SacPoints (Add points to Sacrifice Points occasionally)
public Action SacrificePointsTimer(Handle timer) {
  if (core.isWave && (core.sacPoints < core.sacPointsMax)) {
    core.sacPoints++;
    CreateTimer(GetRandomFloat(5.0, 30.0), SacrificePointsTimer);
  }
  return Plugin_Stop;
}

//Track SacPoints and update entities every 0.1 seconds
public Action SacrificePointsUpdater(Handle timer) {
  if (core.isWave) {
    CreateTimer(0.1, SacrificePointsUpdater);
    if (core.sacPoints > core.sacPointsMax) {
      core.sacPoints = core.sacPointsMax;
    }
  }
  return Plugin_Stop;
}

//BombStatus (Add points to Bomb Status occasionally)
public Action BombStatusAddTimer(Handle timer) {
  if (core.isWave && (core.bombStatus < core.bombStatusMax)) {
    bombState[0].ready = false;
    core.bombStatus++;
    CreateTimer(GetRandomFloat(10.0, 45.0), BombStatusAddTimer);
  }
  return Plugin_Stop;
}

//Track core.bombStatus and update entities every 0.1 seconds
public Action BombStatusUpdater(Handle timer) {
  if (core.isWave) {
    CreateTimer(0.1, BombStatusUpdater);
    if (core.bombStatus < core.bombStatusMax) {
      switch (core.bombStatus) {
        case 8,16,24,32,40,48,56,64: {
          int curBomb = RoundToFloor(core.bombStatus / 8.0);
          core.bombStatusMax = core.bombStatus;
          core.canSENTShark = bombState[curBomb].canSENTShark; //false until 48 (6)
          bombState[0].ready = true;
          FireEntityInput("Bombs*", "Disable", "", 0.0);
          FireEntityInput("Delivery", "Unlock", "", 0.0);
          FireEntityInput(bombState[curBomb].identifier, "Enable", "", 0.0);
          CustomSoundEmitter(SFXArray[56], 65, false, 0, 1.0, 100);
          CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's %s {forestgreen}is now available for deployment!", bombState[curBomb].name);
        }
      }
    } else if (core.bombStatus > core.bombStatusMax) {
      core.bombStatus = core.bombStatusMax - 4;
    }
    return Plugin_Continue;
  }
  return Plugin_Stop;
}

//RobotLaunchTimer (Randomly fling robots)
public Action RobotLaunchTimer(Handle timer) {
  if (core.isWave) {
    FireEntityInput("FB.RobotLauncher", "Enable", "", 0.0);
    FireEntityInput("FB.RobotLauncher", "Disable", "", 7.5);
    CreateTimer(GetRandomFloat(5.0, 30.0), RobotLaunchTimer);
  }
  return Plugin_Stop;
}

//Command action definitions
//Get current song
public Action Command_GetCurrentSong(int client, int args) {
  char buffer[16];
  char tbuffer[16];
  int sPos = RoundToFloor(core.ticksMusic/66.6666666666);
  int tPos = RoundToFloor(core.refireTime/66.6666666666);
  Format(buffer, 16, "%02d:%02d", sPos / 60, sPos % 60);
  Format(tbuffer, 16, "%02d:%02d", tPos / 60, tPos % 60);
  PrintToChat(client, "The current song is: %s (%s / %s)", core.songName, buffer, tbuffer);
  return Plugin_Handled;
}

//Determine which bomb has been recently pushed and tell the client if a bomb is ready or not.
public Action Command_FBBombStatus(int client, int args) {
  char bombStatusMsg[256];
  Format(bombStatusMsg, sizeof(bombStatusMsg), (core.bombProgression ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}(%i/%i) Your team is currently pushing a %s!" : bombState[0].ready ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}(%i/%i) Your team's %s is ready!" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}(%i/%i) Your team recently deployed a %s! Please wait for the next bomb."), core.bombStatus, core.bombStatusMax, bombState[RoundToFloor(core.bombStatus / 8.0)].name);
  CPrintToChat(client, bombStatusMsg);
  return Plugin_Handled;
}

//Return the client to spawn
public Action Command_Return(int client, int args) {
  if (!IsPlayerAlive(client)) {
    ReplyToCommand(client, "{red}[Core] You must be alive to use this command...");
    return Plugin_Handled;
  } else {
    char name[128];
    GetClientName(client, name, sizeof(name));
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%s {white}began casting {darkviolet}/return{white}.", name);
    CustomSoundEmitter(SFXArray[41], 65, false, 0, 1.0, 100);
    CreateTimer(5.0, ReturnClient, client);
  }
  return Plugin_Handled;
}

//Return the client to spawn
public Action ReturnClient(Handle timer, int clientID) {
  TeleportEntity(clientID, Return, NULL_VECTOR, NULL_VECTOR);
  CSEClient(clientID, SFXArray[42], 65, false, 0, 1.0, 100);
  return Plugin_Handled;
}

//Join us on Discord!
public Action Command_Discord(int client, int args) {
  CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Our Discord server URL is {darkviolet}https://discord.com/invite/SkHaeMH{white}.");
  ShowMOTDPanel(client, "FireHostRedux Discord", "https://discord.com/invite/SkHaeMH", MOTDPANEL_TYPE_URL);
  return Plugin_Handled;
}

//Events
//Check who died by what and announce it to chat.
public Action EventDeath(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
  int attacker = GetClientOfUserId(Spawn_Event.GetInt("attacker"));
  char attackerName[64];
  char weapon[32];
  Spawn_Event.GetString("weapon", weapon, sizeof(weapon));
  GetClientName(attacker, attackerName, sizeof(attackerName));
  if (0 < client <= MaxClients && IsClientInGame(client)) {
    int damagebits = Spawn_Event.GetInt("damagebits");
    //Find server name
    Handle convar = FindConVar("hostname");
    char ServerName[64];
    GetConVarString(convar, ServerName, sizeof(ServerName));
    if (StrEqual(attackerName, ServerName)) {
      attackerName = "[INTENTIONAL GAME DESIGN]";
    }
    if (attacker > 0 && core.sacrificedByClient) { //Was the client Sacrificed?
      SacrificeClient(client, attacker, core.bombReset);
      core.sacrificedByClient = false;
    }
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
        if (core.tornado) {
          switch (GetClientTeam(client)) {
            case 2: {
              CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was {red}%s{white}!", client, DeathMessage[GetRandomInt(0, 5)]);
              weapon = "Yeeted into Orbit via Tornado";
            }
            case 3: {
              CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N was {red}%s{white}! ({limegreen}+1 pt{white})", client, DeathMessage[GetRandomInt(0, 5)]);
              core.sacPoints++;
              CustomSoundEmitter(SFXArray[GetRandomInt(11, 26)], 65, false, 0, 1.0, 100);
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
        CPrintToChatAll("{darkviolet}[{red}EXTERMINATUS{darkviolet}] {white}Client %N has humliated themselves with an {red}incorrect {white}key entry!", client);
        weapon = "Failed FB Code Entry";
        int i = GetRandomInt(1, 16);
        switch (i) {
        case 1, 3, 10: {
          FireEntityInput("BG.Meteorites1", "ForceSpawn", "", 0.0),
            CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, a {red}METEOR{white}has been spotted coming towards Dovah's Ass!!!"),
            FireEntityInput("bg.meteorite1", "StartForward", "", 0.1);
        }
        case 2, 5, 16: {
          CreateTimer(0.5, TimedOperator, 71);
          FireEntityInput("FB.TankTrain", "TeleportToPathTrack", "Tank01", 0.0),
            FireEntityInput("FB.TankTrain", "StartForward", "", 0.25),
            FireEntityInput("FB.TankTrain", "SetSpeed", "1", 0.35),
            FireEntityInput("FB.Tank", "Enable", "", 1.0);
        }
        case 4, 8, 14: {
          CustomSoundEmitter("ambient/alarms/train_horn_distant1.wav", 65, false, 0, 1.0, 100),
            FireEntityInput("TrainSND", "PlaySound", "", 0.0),
            FireEntityInput("TrainDamage", "Enable", "", 0.0),
            FireEntityInput("Train01", "Enable", "", 0.0),
            CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {orange}KISSONE'S TRAIN{white}is {red}INCOMING{white}. Look out!"),
            FireEntityInput("TrainTrain", "TeleportToPathTrack", "TrainTrack01", 0.0),
            FireEntityInput("TrainTrain", "StartForward", "", 0.1);
        }
        case 6, 9: {
          core.canTornado = true,
            CreateTimer(1.0, TimedOperator, 41);
        }
        case 7, 13: {
          CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, it appears to have started raining a {red}METEOR SHOWER{white}!!!");
          core.canSENTMeteors = true,
            CreateTimer(1.0, SENTMeteorTimer),
            CreateTimer(30.0, TimedOperator, 12);
        }
        case 11: {
          FireEntityInput("FB.Slice", "Enable", "", 0.0),
            CustomSoundEmitter("ambient/sawblade_impact1.wav", 65, false, 0, 1.0, 100),
            FireEntityInput("FB.Slice", "Disable", "", 1.0);
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
        Format(EnergyDeath, sizeof (EnergyDeath), (core.crusader ? "THE CRUSADER" : core.waveFlags == 1 ? "THE ONSLAUGHTER" : "A HIGH ENERGY PHOTON BEAM"));
        weapon = (core.crusader ? "Crusader" : core.waveFlags == 1 ? "Onslaughter" : "HE Photon Beam");
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been vaporized by {red}%s{white}!", client, EnergyDeath);
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
        CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}Client %N has been crushed by a {forestgreen}FALLING GOOBBUE FROM OUTER SPACE{white}!", client);
        weapon = "Falling Goobbue";
      }
      }
    }

    //Log if a player killed someone
    if (attacker != client) {
      if (!FB_Database) {
        return Plugin_Handled;
      }
      char query[256];
      int steamID = (attacker != 0 ? GetSteamAccountID(attacker) : 0);
      if (!steamID || steamID <= 10000) {
        int steamIDclient = GetSteamAccountID(client);
        if (!steamIDclient || steamIDclient <= 10000) {
          return Plugin_Handled;
        } else {
          char queryClient[256];
          Format(queryClient, sizeof(queryClient), "UPDATE ass_activity SET deaths = deaths + 1, deathssession = deathssession + 1 WHERE steamid = %i;", steamIDclient);
          FB_Database.Query(Database_FastQuery, queryClient);
          if (!StrEqual(weapon, "world")) {
            Format(queryClient, sizeof(queryClient), "UPDATE ass_activity SET killedbyname = '%s', killedbyweapon = '%s' WHERE steamid = %i;", attackerName, weapon, steamIDclient);
            FB_Database.Query(Database_FastQuery, queryClient);
          }
          return Plugin_Handled;
        }
      }
      Format(query, sizeof(query), "UPDATE ass_activity SET kills = kills + 1, killssession = killssession + 1 WHERE steamid = %i;", steamID);
      FB_Database.Query(Database_FastQuery, query);
      if (!StrEqual(weapon, "world")) {
        Format(query, sizeof(query), "UPDATE ass_activity SET lastkilledname = '%N', lastweaponused = '%s' WHERE steamid = %i;", client, weapon, steamID);
        FB_Database.Query(Database_FastQuery, query);
      }
    }
    return Plugin_Handled;
  }
  return Plugin_Handled;
}

//Check who spawned and log their class
public Action EventSpawn(Event Spawn_Event,
  const char[] Spawn_Name, bool Spawn_Broadcast) {
  int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
  if (IsValidClient(client)) {
    char strClass[32];
    char query[256];
    int class = Spawn_Event.GetInt("class");
    int steamID = GetSteamAccountID(client);
    if (!FB_Database || !steamID || !class) return Plugin_Handled;
    strClass = ClassDefinitions[class-1];
    Format(query, sizeof(query), "UPDATE ass_activity SET class = '%s' WHERE steamid = %i;", strClass, steamID);
    FB_Database.Query(Database_FastQuery, query);
  }
  return Plugin_Handled;
}

//When we win
public Action EventWaveComplete(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  sudo(300);
  sudo(1000);
  sudo(1002);
  sudo(1007);
  CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}You've defeated the wave!");
  CreateTimer(1.0, PerformAdverts);
  CreateTimer(40.0, SelectAdminTimer);
  return Plugin_Handled;
}

//Announce when we are in danger.
public Action EventWarning(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  if (core.doFailsafe){
    core.failsafeCount++;
    CPrintToChatAll( "%s Counter: %i", failsafe[GetRandomInt(0, 14)], core.failsafeCount);
    EmitSoundToAll(SFXArray[55]);
    ServerCommand("sm_freeze @blue; wait 180; sm_smash @blue;sm_evilrocket @blue");
    core.doFailsafe = false;
  }
  else
    CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {darkred}PROFESSOR'S ASS IS ABOUT TO BE DEPLOYED!!!");
  return Plugin_Handled;
}

//When the wave fails
public Action EventWaveFailed(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  if (core.FailedCount == 0) { //Works around valve's way of firing EventWaveFailed four times when mission changes. Without this, BGM would play 4 times and any functions enclosed would also happen four times.......
    core.FailedCount++;
    sudo(1000);
    CreateTimer(1.0, PerformAdverts);
    CreateTimer(40.0, SelectAdminTimer);
  }
  CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave {red}failed {white}successfully!");
  sudo(300);
  sudo(1007);
  sudo(1002);
  return Plugin_Handled;
}

//Log Damage!
public void Event_Playerhurt(Handle event, const char[] name, bool dontBroadcast) {
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
  int damage = GetEventInt(event, "damageamount");
  //int health = GetEventInt(event, "health");
  //int attackerhp = GetClientHealth(attacker);
  if (IsValidClient(attacker) && attacker != client) {
    char query[256];
    int steamID = GetSteamAccountID(attacker);
    if (!FB_Database || !steamID) {
      return;
    }
    Format(query, sizeof(query), "UPDATE ass_activity SET damagedealt = damagedealt + %i, damagedealtsession = damagedealtsession + %i WHERE steamid = %i;", damage, damage, steamID);
    FB_Database.Query(Database_FastQuery, query);
  }
}

//Functions
//Create a temp entity and fire an input
public Action FireEntityInput(char[] strTargetname, char[] strInput, char[] strParameter, float flDelay) {
  char strBuffer[255];
  Format(strBuffer, sizeof(strBuffer), "OnUser1 %s:%s:%s:%f:1", strTargetname, strInput, strParameter, flDelay);
  //PrintToChatAll("{limegreen}[CORE] {white}Firing entity %s with input %s , a parameter override of %s , and delay of %f ...", strTargetname, strInput, strParameter, flDelay);
  int entity = CreateEntityByName("info_target");
  if (IsValidEdict(entity)) {
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
//Dispatch a circle AOE
public Action DispatchCircleAOE(float posX, float posY, float posZ){
  int ent = FindEntityByTargetname("CircleTemplate", "point_template");
  if (ent != -1) {
    float dest[3];
    dest[0] = posX;
    dest[1] = posY;
    dest[2] = posZ;
    float destAng[3];
    float destVel[3];
    TeleportEntity(ent, dest, destAng, destVel);
    FireEntityInput("CircleTemplate", "ForceSpawn", "", 0.0);
  }
  else
    PrintToServer("Nope");
  return Plugin_Stop;
}

//Custom sound emitter, I don't know how many fucking times I've rewritten this! See potato.sp
//int flags:
//	SND_NOFLAGS= 0,             /**< Nothing */
//	SND_CHANGEVOL = 1,          /**< Change sound volume */
//	SND_CHANGEPITCH = 2,        /**< Change sound pitch */
//	SND_STOP = 3,               /**< Stop the sound */
//	SND_SPAWNING = 4,           /**< Used in some cases for ambients */
//	SND_DELAY = 5,              /**< Sound has an initial delay */
//	SND_STOPLOOPING = 6,        /**< Stop looping all sounds on the entity */
//	SND_SPEAKER = 7,            /**< Being played by a mic through a speaker */
//	SND_SHOULDPAUSE = 8         /**< Pause if game is paused */
void CustomSoundEmitter(char[] sndName, int TSNDLVL, bool isBGM, int flags, float vol, int pitch){
  for (int i = 1; i <= MaxClients; i++){
    if(IsValidClient(i)){
      if (isBGM && (soundPreference[i] == 1 || soundPreference[i] == 3) || !isBGM && soundPreference[i] >= 2)
        EmitSoundToClient(i, sndName, _, core.SNDCHAN, TSNDLVL, flags, vol, pitch, _, _, _, _, _);
    }
  }
}
//Play sound to client. Ripped straight from potato. Allows us to play sounds directly to people when they join.
void CSEClient(int client, char[] sndName, int TSNDLVL, bool isBGM, int flags, float vol, int pitch){
  if(IsValidClient(client)){
    if(isBGM && (soundPreference[client] == 1 || soundPreference[client] == 3) || !isBGM && soundPreference[client] >= 2)
      EmitSoundToClient(client, sndName, _, core.SNDCHAN, TSNDLVL, flags, vol, pitch, _, _, _, _, _);
  }
}

//Jump waves.
public Action JumpToWave(int wave_number) {
  int flags = GetCommandFlags("tf_mvm_jump_to_wave");
  SetCommandFlags("tf_mvm_jump_to_wave", flags & ~FCVAR_CHEAT);
  ServerCommand("tf_mvm_jump_to_wave %d", wave_number);
  FakeClientCommand(0, "");
  SetCommandFlags("tf_mvm_jump_to_wave", flags | FCVAR_CHEAT);
  return Plugin_Handled;
}

//Remove edict allocated by temp entity
public Action DeleteEdict(Handle timer, any entity) {
  if (IsValidEdict(entity)) RemoveEdict(entity);
  return Plugin_Stop;
}

//Sacrifice target and grant bonus points
public Action SacrificeClient(int client, int attacker, bool wasBombReset) {
  if (attacker <= MaxClients && IsClientInGame(attacker) && wasBombReset == true) {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%N {white}has reset the ass! ({limegreen}+5 pts{white})", attacker);
    core.bombReset = false;
    char query[256];
    int steamID = GetSteamAccountID(attacker);
    core.sacPoints += 5;
    if (!FB_Database || !steamID) {
      return Plugin_Handled;
    }
    Format(query, sizeof(query), "UPDATE ass_activity SET bombsreset = bombsreset + 1, bombsresetsession = bombsresetsession + 1 WHERE steamid = %i;", steamID);
    FB_Database.Query(Database_FastQuery, query);
  } else if (attacker <= MaxClients && IsClientInGame(attacker) && wasBombReset == false) {
    int steamID = GetSteamAccountID(attacker);
    if (!FB_Database || !steamID || !core.isWave) {
      return Plugin_Handled;
    } else {
      char query[256];
      core.sacPoints++;
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%N {white}has sacrificed {blue}%N {white}for the ass! ({limegreen}+1 pt{white})", attacker, client);
      Format(query, sizeof(query), "UPDATE ass_activity SET sacrifices = sacrifices + 1, sacrificessession = sacrificessession + 1 WHERE steamid = %i;", steamID); //Eventually we will want to replace this with sacrifices, sacrificessession.
      FB_Database.Query(Database_FastQuery, query);
    }
  }
  return Plugin_Handled;
}
void AssLogger(int logLevel, char[] logData){
  switch(logLevel){
    case 0:{
      LogMessage("[DEBUG]: %s", logData);
    }
    case 1:{
      LogMessage("[INFO]: %s", logData);
    }
    case 2:{
      LogMessage("[WARN]: %s", logData);
    }
    case 3:{
      LogMessage("[ERROR]: %s", logData);
    }
  }
}
//Operator, core of the entire map
public Action Command_Operator(int args) {
  char arg1[16];
  GetCmdArg(1, arg1, sizeof(arg1));
  int x = StringToInt(arg1);
  sudo(x);
  return Plugin_Continue;
}

void sudo(int task){
  Format(LoggerDbg, sizeof(LoggerDbg), "Calling sudo with %i", task);
  AssLogger(0, LoggerDbg);
  switch (task) {
    case 20000:{
      for (int i = 1; i < sizeof(BGMArray); i++){
        PrintToServer("Real Path: %s Song Name: %s", BGMArray[i].realPath, BGMArray[i].songName);
      }
    }
    //When the map is complete
    case 0: {
      CPrintToChatAll(core.tacobell ? "WOWIE YOU DID IT! The server will restart in 30 seconds, prepare to do it again! LULW" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}YOU HAVE SUCCESSFULLY COMPLETED PROF'S ASS ! THE SERVER WILL RESTART IN 10 SECONDS.");
      CreateTimer(10.0, TimedOperator, 100);
    }
    //Prepare yourself!
    case 1: {
      core.tacobell = false;
      ServerCommand("fb_startmoney 50000");
      CPrintToChatAll("{darkviolet}[{yellow}INFO{darkviolet}] {red}PROFESSOR'S ASS {white}v0x20 (Core-v%s). Prepare yourself for the unpredictable... [{limegreen}by TTV/ProfessorFartsalot{white}]", PLUGIN_VERSION);
      FireEntityInput("rain", "Alpha", "0", 0.0);
    }
    //Wave init
    case 2: {
      core.curWave = GetCurWave();
      PerformWaveSetup();
      switch (core.curWave) {
        case 3, 10, 17: {
          core.HWNMax = 360.0;
          FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
          FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
          float f = GetRandomFloat(60.0, 180.0);
          CreateTimer(f, TimedOperator, 70);
        }
        case 4, 11, 18: {
          core.HWNMax = 360.0;
          FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
          FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
        }
        case 5, 12, 19: {
          core.HWNMax = 260.0;
          core.HWNMin = 140.0;
          FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
          FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
          FireEntityInput("w5_engie_hints", "Trigger", "", 3.0);
          float f = GetRandomFloat(60.0, 180.0);
          CreateTimer(f, TimedOperator, 70);
        }
        case 6, 13, 20: {
          core.HWNMax = 260.0;
          core.HWNMin = 140.0;
          FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
          FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
        }
        case 7, 14, 21: {
          core.HWNMax = 240.0;
          core.HWNMin = 120.0;
          FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
          FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
          FireEntityInput("w5_engie_hints", "Trigger", "", 3.0);
        }
        case 8, 15: {
          core.HWNMax = 240.0;
          core.HWNMin = 120.0;
          FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
          FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
        }
      }
      core.bombStatus = DefaultsArray[core.curWave].defBombStatus;
      core.bombStatusMax = DefaultsArray[core.curWave].defBombStatusMax;
      core.canHWBoss = DefaultsArray[core.curWave].defCanHWBoss;
      core.canTornado = DefaultsArray[core.curWave].defCanTornado;
      core.sacPointsMax = DefaultsArray[core.curWave].defSacPointsMax;
      float hwn = GetRandomFloat(core.HWNMin, core.HWNMax);
      CreateTimer(hwn, HWBosses);
      FireEntityInput("rain", "Alpha", "200", 0.0);
      FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
      FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
      SetupMusic(core.tacobell ? tacoBellBGMIndex[core.curWave] : DefaultsArray[core.curWave].defBGMIndex);
      return;
    }
    //Force Tornado
    case 3: {
      if (core.isWave && core.canTornado && !core.tornado) {
        CreateTimer(0.1, TimedOperator, 41);
        PrintCenterTextAll("OH NOES... PREPARE YOUR ANUS!");
      } else {
        PrintToServer("Error spawning manual tornado... Perhaps we are not in a wave, tornadoes are banished, or a tornado has already spawned???");
      }
      return;
    }
    //Signal that previous boss should spawn.
    case 4: {
      core.waveFlags--;
    }
    //Signal that a boss should spawn
    case 5: {
      if (core.waveFlags < 0) core.waveFlags = 0;
      switch (core.waveFlags){
        case 0:{
          PrintToChatAll("Caught unhandled exception: core.waveFlags 0 but operator 5 was invoked.");
          return;
        }
        case 1: {
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
          CreateTimer(10.0, BossHPTimer);
        }
        case 2: {
          FireEntityInput("FB.Sephiroth", "Enable", "", 0.0),
          FireEntityInput("SephMeteor", "SetParent", "FB.Sephiroth", 0.0),
          FireEntityInput("SephTrain", "SetSpeedReal", "12", 0.0),
          FireEntityInput("SephTrain", "TeleportToPathTrack", "Seph01", 0.0),
          FireEntityInput("SephTrain", "StartForward", "", 0.1),
          FireEntityInput("SephTrain", "SetSpeedReal", "12", 20.5),
          FireEntityInput("FB.SephParticles", "Start", "", 3.0),
          FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 3.0),
          FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 4.0),
          FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 5.0),
          FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 6.0),
          FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 7.0),
          FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 8.0),
          FireEntityInput("FB.BruteJusticeDMGRelay", "Kill", "", 0.0);
          int players = 0;
          for (int i = 1; i <= MaxClients; i++) {
            if (IsValidClient(i))
              players++;
          }
          PrintToServer("We have %i player(s), setting boss attributes accordingly!", players);
          switch (players) {
            case 1: {
              FireEntityInput("SephTrain", "SetSpeedReal", "40", 23.0);
              FireEntityInput("tank_boss", "SetHealth", "409600", 1.0);
              FireEntityInput("FB.SephDMGRelay", "SetHealth", "32768000", 1.0);
            }
            case 2: {
              FireEntityInput("SephTrain", "SetSpeedReal", "35", 23.0);
              FireEntityInput("tank_boss", "SetHealth", "614400", 1.0);
              FireEntityInput("FB.SephDMGRelay", "SetHealth", "32768000", 1.0);
            }
            case 3: {
              FireEntityInput("SephTrain", "SetSpeedReal", "35", 23.0);
              FireEntityInput("tank_boss", "SetHealth", "614400", 1.0);
              FireEntityInput("FB.SephDMGRelay", "SetHealth", "131072000", 1.0);
            }
            case 4: {
              FireEntityInput("SephTrain", "SetSpeedReal", "30", 23.0);
              FireEntityInput("tank_boss", "SetHealth", "819200", 1.0);
              FireEntityInput("FB.SephDMGRelay", "SetHealth", "262144000", 1.0);
            }
            case 5, 6, 7, 8, 9, 10: {
              FireEntityInput("SephTrain", "SetSpeedReal", "25", 23.0),
                FireEntityInput("tank_boss", "SetHealth", "819200", 1.0),
                FireEntityInput("FB.SephDMGRelay", "SetHealth", "655360000", 1.0);
            }
          }
          CreateTimer(30.0, BossHPTimer);
        }
      }
    }
    //Signal that next boss should spawn
    case 6: {
      core.waveFlags++;
    }
    //Signal to fastforward boss spawn.
    case 7: {
      core.waveFlags = 2;
      if (core.curWave == 8 && !core.tacobell) {
        sudo(1001);
        CreateTimer(0.0, TimedOperator, 8);
      }
    }
    //When a tornado intersects a tank.
    case 8: {
      FireEntityInput("FB.FakeTankSpawner", "ForceSpawn", "", 0.1);
    }
    //Client was Sacrificed.
    case 10: {
      core.sacrificedByClient = true;
    }
    //Damage relay took damage
    case 11: {
      FireEntityInput("TankRelayDMG", "Enable", "", 0.0),
        FireEntityInput("TankRelayDMG", "Disable", "", 0.5);
    }
    //dmg relay was killed
    case 12: {
      FireEntityInput("tank_boss", "SetHealth", "1", 0.0);
      FireEntityInput("TankRelayDMG", "Enable", "", 0.1);
      FireEntityInput("TankRelayDMG", "Enable", "", 0.5);
      FireEntityInput("TankRelayDMG", "Enable", "", 1.0);
      FireEntityInput("TankRelayDMG", "Disable", "", 10.0);
    }
    //Tank Destroyed (+1), includes disabling onslaughter.
    case 13: {
      switch (core.waveFlags) {
      case 0: {
        CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A tank has been destroyed. ({limegreen}+1 pt{white})");
        core.sacPoints++;
      }
      case 1: {
        CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}ONSLAUGHTER {white}has been destroyed. ({limegreen}+25 pts{white})");
        FireEntityInput("FB.BruteJustice", "Disable", "", 0.0);
        FireEntityInput("FB.BruteJusticeTrain", "Stop", "", 0.0);
        FireEntityInput("FB.BruteJusticeParticles", "Stop", "", 0.0);
        FireEntityInput("FB.BruteJusticeDMGRelay", "Break", "", 0.0);
        FireEntityInput("FB.BruteJusticeTrain", "TeleportToPathTrack", "tank_path_a_10", 0.5);
        core.waveFlags = 0;
        core.sacPoints += 25;
      }
      case 2: {
        CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}SEPHIROTH {white}has been destroyed. ({limegreen}+100 pts{white})");
        FireEntityInput("FB.Sephiroth", "Disable", "", 0.0);
        FireEntityInput("SephTrain", "TeleportToPathTrack", "Seph01", 0.0);
        FireEntityInput("SephTrain", "Stop", "", 0.0);
        core.canSephNuke = false;
        core.sacPoints += 100;
        core.waveFlags = 0;
        core.canTornado = false;
      }
      }
      return;
    }
    //Bomb Reset (+5)
    case 14: {
      core.bombReset = true;
      core.sacPoints += 5;
    }
    //Bomb Deployed
    case 15: {
      FireEntityInput("FB.PayloadWarning", "Disable", "", 0.0);
      switch (core.bombStatus) {
        //Invalid
      case 0: {
        PrintToServer("Tried to detonate with a bomb size of zero!");
      }
      //Small Explosion
      case 8: {
        FireEntityInput("RareSpells", "Enable", "", 0.0);
        EmitSoundToAll(SFXArray[1]),
          FireEntityInput("SmallExplosion", "Explode", "", 0.0),
          FireEntityInput("SmallExploShake", "StartShake", "", 0.0),
          CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Small Bomb successfully pushed! ({limegreen}+2 pts{white})");
        core.sacPoints += 2,
          core.bombStatusMax += 10,
          CreateTimer(3.0, BombStatusAddTimer);
        CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100);
        if (core.bombStatus >= core.bombStatusMax) {
          return;
        } else {
          core.bombStatus += 2;
        }
      }
      //Medium Explosion
      case 16: {
        FireEntityInput("RareSpells", "Enable", "", 0.0);
        EmitSoundToAll(SFXArray[2]),
          FireEntityInput("MediumExplosion", "Explode", "", 0.0),
          FireEntityInput("MedExploShake", "StartShake", "", 0.0),
          CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Medium Bomb successfully pushed! ({limegreen}+5 pts{white})");
        core.sacPoints += 5,
          core.bombStatusMax += 10,
          CreateTimer(3.0, BombStatusAddTimer);
        CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100);
        if (core.bombStatus >= core.bombStatusMax) {
          return;
        } else {
          core.bombStatus += 2;
        }
      }
      //Medium Explosion (Bath salts)
      case 24: {
        FireEntityInput("RareSpells", "Enable", "", 0.0);
        EmitSoundToAll(SFXArray[2]),
          FireEntityInput("MediumExplosion", "Explode", "", 0.0),
          FireEntityInput("MedExploShake", "StartShake", "", 0.0),
          ServerCommand("sm_freeze @blue 10");
        CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Medium Bomb successfully pushed! Bots froze for 10 seconds. ({limegreen}+5 pts{white})");
        core.sacPoints += 5,
          core.bombStatusMax += 10,
          CreateTimer(3.0, BombStatusAddTimer);
        CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100);
        if (core.bombStatus >= core.bombStatusMax) {
          return;
        } else {
          core.bombStatus += 2;
        }
      }
      //Falling Star
      case 32: {
        FireEntityInput("RareSpells", "Enable", "", 0.0);
        core.canSENTStars = true,
          EmitSoundToAll(SFXArray[2]),
          FireEntityInput("MediumExplosion", "Explode", "", 0.0),
          FireEntityInput("MedExploShake", "StartShake", "", 0.0),
          CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Large Bomb successfully pushed! ({limegreen}+10 pts{white})");
        core.sacPoints += 10,
          core.bombStatusMax += 10,
          CreateTimer(3.0, BombStatusAddTimer);
        CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100),
          CreateTimer(1.0, SENTStarTimer),
          CreateTimer(60.0, TimedOperator, 14);
        if (core.bombStatus >= core.bombStatusMax) {
          return;
        } else {
          core.bombStatus += 2;
        }
      }
      //Major Kong
      case 40: {
        FireEntityInput("RareSpells", "Enable", "", 0.0);
        EmitSoundToAll(SFXArray[4]),
          FireEntityInput("FB.Fade", "Fade", "", 1.7),
          FireEntityInput("LargeExplosion", "Explode", "", 1.7),
          FireEntityInput("LargeExplosionSound", "PlaySound", "", 1.7),
          FireEntityInput("LargeExploShake", "StartShake", "", 1.7),
          FireEntityInput("NukeAll", "Enable", "", 1.7),
          FireEntityInput("NukeAll", "Disable", "", 3.0),
          CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}NUCLEAR WARHEAD {white}successfully pushed! ({limegreen}+25 pts{white})");
        core.sacPoints += 25,
          core.bombStatusMax += 10,
          CreateTimer(3.0, BombStatusAddTimer);
        CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100);
        if (core.bombStatus >= core.bombStatusMax) {
          return;
        } else {
          core.bombStatus += 4;
        }
      }
      //Large (shark)
      case 48: {
        FireEntityInput("RareSpells", "Enable", "", 0.0);
        EmitSoundToAll(SFXArray[3]),
          FireEntityInput("LargeExplosion", "Explode", "", 0.0),
          FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
          CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Heavy Bomb successfully pushed! ({limegreen}+15 pts{white})");
        core.sacPoints += 15,
          core.bombStatusMax += 10,
          CreateTimer(3.0, BombStatusAddTimer);
        CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100);
        if (core.bombStatus >= core.bombStatusMax) {
          return;
        } else {
          core.bombStatus += 4;
        }
      }
      //FatMan
      case 56: {
        FireEntityInput("RareSpells", "Enable", "", 0.0);
        EmitSoundToAll(SFXArray[35]);
        FireEntityInput("LargeExplosion", "Explode", "", 0.0);
        FireEntityInput("LargeExploShake", "StartShake", "", 0.0);
        FireEntityInput("HurtAll", "AddOutput", "damagetype 262144", 0.0);
        FireEntityInput("HurtAll", "AddOutput", "damage 2000000", 0.0);
        FireEntityInput("HurtAll", "Enable", "", 0.1);
        FireEntityInput("FB.Fade", "Fade", "", 0.0);
        FireEntityInput("HurtAll", "Disable", "", 3.0);
        CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}NUCLEAR WARHEAD{white}successfully pushed! ({limegreen}+25 pts{white})");
        core.sacPoints += 25,
        core.bombStatusMax += 10,
        CreateTimer(3.0, BombStatusAddTimer);
        CreateTimer(15.0, SpecTimer);
        CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100);
        if (core.bombStatus >= core.bombStatusMax) {
          return;
        } else {
          core.bombStatus += 4;
        }
      }
      //Hydrogen
      case 64: {
        FireEntityInput("RareSpells", "Enable", "", 0.0);
        EmitSoundToAll(SFXArray[35]);
        FireEntityInput("LargeExplosion", "Explode", "", 0.0),
          FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
          FireEntityInput("LargeExplosionSND", "PlaySound", "", 0.0),
          FireEntityInput("NukeAll", "Enable", "", 0.0),
          FireEntityInput("FB.Fade", "Fade", "", 0.0),
          FireEntityInput("NukeAll", "Disable", "", 3.0),
          CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}HINDENBURG {white}successfully fueled! ({limegreen}+30 pts{white})");
        CPrintToChatAll("The {red}HINDENBURG {forestgreen}is now ready for flight!");
        FireEntityInput("DeliveryBurg", "Unlock", "", 0.0);
        core.bombStatus = 0;
        core.canHindenburg = true;
        CreateTimer(3.0, BombStatusAddTimer);
        CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100);
      }
      //Fartsy of the Seventh Taco Bell
      case 69: {
        FireEntityInput("NukeAll", "Enable", "", 0.0),
          EmitSoundToAll(SFXArray[35]);
        FireEntityInput("FB.Fade", "Fade", "", 0.0),
          FireEntityInput("NukeAll", "Disable", "", 2.0),
          core.bombStatusMax = 64;
        CreateTimer(5.0, TimedOperator, 99);
      }
      }
      return;
    }
    //Tank deployed its bomb
    case 16: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A tank has deployed its bomb! ({limegreen}+1 pt{white})");
    }
    //Shark Enable & notify bomb push began
    case 20: {
      core.bombProgression = true;
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Bomb push in progress.");
      FireEntityInput("FB.PayloadWarning", "Enable", "", 0.0);
      CreateTimer(3.0, SharkTimer);
    }
    //Shark Disable
    case 21: {
      core.bombProgression = false;
      core.canSENTShark = false;
    }
    //HINDENBOOM ACTIVATION
    case 28: {
      EmitSoundToAll(SFXArray[5]);
      FireEntityInput("HindenTrain", "StartForward", "", 0.0);
      FireEntityInput("DeliveryBurg", "Lock", "", 0.0);
      FireEntityInput("Boom", "Enable", "", 0.0);
      FireEntityInput("Bombs.TheHindenburg", "Enable", "", 0.0);
      FireEntityInput("Boom", "Disable", "", 1.0);
    }
    //HINDENBOOM!!!
    case 29: {
      CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}OH GOD, THEY'RE {red}CRASHING THE HINDENBURG{white}!!!");
      EmitSoundToAll(SFXArray[36]);
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
      core.bombStatus = 4;
      core.bombStatusMax = 8;
    }
    //Bath Salts spend
    case 30: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}INSTANT BATH SALT DETONATION! BOTS ARE FROZEN FOR 10 SECONDS! ({red}-10 pts{white})");
      ServerCommand("sm_freeze @blue 10");
      core.sacPoints -= 10;
      FireEntityInput("MedExploShake", "StartShake", "", 0.10),
      FireEntityInput("MedExplosionSND", "PlaySound", "", 0.10),
      FireEntityInput("MediumExplosion", "Explode", "", 0.10);
    }
    //Goob/Kirb spend
    case 31: {
      int i = GetRandomInt(1, 2);
      if (i == 1) CreateTimer(1.5, TimedOperator, 21);
      FireEntityInput(i == 1 ? "FB.GiantGoobTemplate" : "FB.BlueKirbTemplate", "ForceSpawn", "", 0.0);
      CPrintToChatAll(i == 1 ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}GOOBBUE COMING IN FROM ORBIT! ({red}-20 pts{white})" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}BLUE KIRBY FALLING OUT OF THE SKY! ({red}-20 pts{white})");
      CustomSoundEmitter(i == 1 ? SFXArray[51] : SFXArray[21], 65, false, 0, 1.0, 100);
      core.sacPoints -= 20;
    }
    //35K ubup cash spend
    case 32: {
      if(!core.doFailsafe){
        core.doFailsafe = true;
        CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave fail-safe activated! ({red}-30 pts{white})");
        core.sacPoints -= 30;
      }
      else return;
    }
    //Explosive paradise spend
    case 33: {
      CustomSoundEmitter(SFXArray[10], 65, false, 0, 1.0, 100);
      FireEntityInput("FB.FadeBLCK", "Fade", "", 0.0);
      ServerCommand("sm_evilrocket @blue");
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}We're spending most our lives living in an EXPLOSIVE PARADISE! Robots will be launched into orbit, too! ({red}-40 pts{white})");
      FireEntityInput("NukeAll", "Enable", "", 11.50);
      FireEntityInput("HUGEExplosion", "Explode", "", 11.50);
      FireEntityInput("FB.Fade", "Fade", "", 11.50);
      FireEntityInput("FB.ShakeBOOM", "StartShake", "", 11.50);
      FireEntityInput("NukeAll", "Disable", "", 12.30);
      core.sacPoints -= 40;
    }
    //Banish Tornadoes
    case 34: {
      if (core.canTornado || core.tornado) core.sacPoints -= 50;
      CPrintToChatAll(core.canTornado || core.tornado ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A PINK KIRBY HAS BANISHED TORNADOES FOR THIS WAVE! ({red}-50 pts{white})" : "{red}TTV/professorfartsalot {white}:  Please do not, the tornado button. Thanks. ({red} -0 pts{white})");
      core.canTornado = false;
      sudo(1005);
    }
    //Ass Gas spend
    case 35: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}ANYTHING BUT THE ASS GAS!!!! ({red}-60 pts{white})");
      core.sacPoints -= 60;
      FireEntityInput("HurtAll", "AddOutput", "damagetype 524288", 0.0);
      FireEntityInput("FB.ShakeBOOM", "StartShake", "", 0.1);
      FireEntityInput("HurtAll", "AddOutput", "damage 400", 0.0);
      FireEntityInput("HurtAll", "Enable", "", 0.1);
      FireEntityInput("HurtAll", "Disable", "", 4.1); //Add a sound to this in the future. Maybe gas sound from gbombs? Maybe custom fart sounds? hmm....
      FireEntityInput("FB.ShakeBOOM", "StopShake", "", 4.1);
    }
    //Nuclear fallout spend
    case 36: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}INSTANT FAT MAN DETONATION! ({red}-70 pts{white})");
      core.sacPoints -= 70;
      FireEntityInput("LargeExplosion", "Explode", "", 0.0);
      FireEntityInput("LargeExploShake", "StartShake", "", 0.0);
      FireEntityInput("HurtAll", "AddOutput", "damagetype 262144", 0.0);
      FireEntityInput("HurtAll", "AddOutput", "damage 2000000", 0.0);
      FireEntityInput("HurtAll", "Enable", "", 0.1);
      EmitSoundToAll(SFXArray[35]);
      FireEntityInput("FB.Fade", "Fade", "", 0.0);
      FireEntityInput("HurtAll", "Disable", "", 2.0);
    }
    //Meteor shower spend
    case 37: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}COSMIC DEVASTATION IMMINENT. ({red}-80 pts{white})");
      core.sacPoints -= 80;
      core.canSENTMeteors = true;
      CreateTimer(1.0, SENTMeteorTimer);
      CreateTimer(30.0, TimedOperator, 12);
    }
    //300K UbUp Cash
    case 38: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}150K UbUp Cash Granted to {red}RED{white}! ({red}-90 pts{white})");
      core.sacPoints -= 90;
      ServerCommand("sm_addcash @red 300000");
    }
    //Fartsy of the Seventh Taco Bell
    case 39: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}NOW PRESENTING... PROFESSOR FARTSALOT OF THE SEVENTH TACO BELL! ({red}-100 points{white})");
      core.sacPoints -= 100;
      core.bombStatusMax = 69;
      core.bombStatus = 69;
      FireEntityInput("Delivery", "Unlock", "", 0.0),
      FireEntityInput("BombExplo*", "Disable", "", 0.0),
      FireEntityInput("Bombs*", "Disable", "", 0.0),
      FireEntityInput("Bombs.Professor", "Enable", "", 3.0);
    }
    //Found blue ball
    case 40: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}What on earth IS that? It appears to be a... \x075050FFBLUE BALL{white}!");
      CustomSoundEmitter(SFXArray[21], 65, false, 0, 1.0, 100);
      FireEntityInput("FB.BlueKirbTemplate", "ForceSpawn", "", 4.0);
      CreateTimer(4.0, TimedOperator, 21);
    }
    //Found burrito
    case 41: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Why would you even eat {red}The Forbidden Burrito{white}?");
      CustomSoundEmitter("vo/sandwicheat09.mp3", 65, false, 0, 1.0, 100);
      FireEntityInput("HurtAll", "AddOutput", "damagetype 8", 0.0);
      FireEntityInput("HurtAll", "AddOutput", "damage 2000", 0.0);
      FireEntityInput("HurtAll", "Enable", "", 4.0);
      FireEntityInput("HurtAll", "Disable", "", 8.0);
    }
    //Found goobbue
    case 42: {
      CustomSoundEmitter(SFXArray[51], 65, false, 0, 1.0, 100);
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}ALL HAIL \x07FF00FFGOOBBUE{forestgreen}!");
      CreateTimer(4.0, TimedOperator, 21);
      FireEntityInput("FB.GiantGoobTemplate", "ForceSpawn", "", 4.0);
    }
    //Found Mario
    case 43: {
      CustomSoundEmitter(SFXArray[52], 65, false, 0, 1.0, 100);
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Welp, someone is playing \x0700FF00Mario{white}...");
    }
    //Found Waffle
    case 44: {
      CustomSoundEmitter(SFXArray[53], 65, false, 0, 1.0, 100);
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Oh no, someone has found and (probably) consumed a {red}WAFFLE OF MASS DESTRUCTION{white}!");
      FireEntityInput("HurtAll", "AddOutput", "damagetype 262144", 10.0);
      FireEntityInput("HurtAll", "AddOutput", "damage 2000000", 0.0);
      FireEntityInput("FB.ShakeBOOM", "StartShake", "", 10.3);
      FireEntityInput("HUGEExplosion", "Explode", "", 10.3);
      FireEntityInput("FB.Fade", "Fade", "", 10.3);
      FireEntityInput("HurtAll", "Enable", "", 10.3);
      FireEntityInput("HurtAll", "Disable", "", 12.3);
    }
    //Medium Explosion (defined again, but we aren't using a bomb this time)
    case 51: {
      CustomSoundEmitter(SFXArray[3], 65, false, 0, 1.0, 100);
    }
    //Probably for the hindenburg... EDIT: NOPE. THIS IS FOR KIRB LANDING ON THE GROUND
    case 52: {
      EmitSoundToAll(SFXArray[35]);
      FireEntityInput("FB.BOOM", "StartShake", "", 0.0);
      FireEntityInput("BlueBall*", "Kill", "", 0.0);
      FireEntityInput("HUGEExplosion", "Explode", "", 0.0);
      FireEntityInput("BlueKirb", "Kill", "", 0.0);
      FireEntityInput("HurtAll", "AddOutput", "damagetype 32768", 0.0);
      FireEntityInput("HurtAll", "AddOutput", "damage 666666.667", 0.0);
      FireEntityInput("HurtAll", "Enable", "", 0.1);
      FireEntityInput("HurtAll", "Disable", "", 2.1);
    }
    //Giant Goobbue
    case 53: {
      EmitSoundToAll(SFXArray[35]);
      FireEntityInput("FB.BOOM", "StartShake", "", 0.0);
      FireEntityInput("GiantGoob*", "Kill", "", 0.0);
      FireEntityInput("HUGEExplosion", "Explode", "", 0.0);
      FireEntityInput("HurtAll", "AddOutput", "damagetype 1048576", 0.0);
      FireEntityInput("HurtAll", "AddOutput", "damage 666666.667", 0.0);
      FireEntityInput("HurtAll", "Enable", "", 0.1);
      FireEntityInput("HurtAll", "Disable", "", 2.1);
    }
    //Prev wave
    case 98: {
      int prev_wave = GetCurWave() - 1;
      if (prev_wave < 1) {
        CPrintToChatAll("{red}[ERROR] {white}WE CAN'T JUMP TO WAVE 0, WHY WOULD YOU TRY THAT??");
        return;
      }
      JumpToWave(prev_wave);
    }
    //Next wave
    case 99: {
      int ent = FindEntityByClassname(-1, "tf_objective_resource");
      if (ent == -1) {
        LogMessage("tf_objective_resource not found");
        return;
      }
      int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
      int next_wave = GetCurWave() + 1;
      if (next_wave > max_wave) {
        int flags = GetCommandFlags("tf_mvm_force_victory");
        SetCommandFlags("tf_mvm_force_victory", flags & ~FCVAR_CHEAT);
        ServerCommand("tf_mvm_force_victory 1");
        FakeClientCommand(0, ""); //Not sure why, but this has to be here. Otherwise the specified commands simply refuse to work...
        SetCommandFlags("tf_mvm_force_victory", flags | FCVAR_CHEAT);
        CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}VICTORY HAS BEEN FORCED! THE SERVER WILL RESTART IN 10 SECONDS.");
        CreateTimer(10.0, TimedOperator, 100);
        return;
      }
      JumpToWave(next_wave);
    }
    //Code Entry from FC Keypad
    case 100: {
      if (core.CodeEntry == 17) {
        FireEntityInput("FB.BOOM", "StartShake", "", 0.0),
          CustomSoundEmitter(SFXArray[3], 65, false, 0, 1.0, 100),
          FireEntityInput("FB.CodeCorrectKill", "Enable", "", 0.0),
          FireEntityInput("FB.KP*", "Lock", "", 0.0),
          FireEntityInput("FB.CodeCorrectKill", "Disable", "", 1.0);
      } else {
        core.CodeEntry = 0;
        FireEntityInput("FB.CodeFailedKill", "Enable", "", 0.0),
          FireEntityInput("FB.CodeFailedKill", "Disable", "", 1.0),
          CustomSoundEmitter("fartsy/memes/priceisright_fail.wav", 65, false, 0, 1.0, 100);
      }
    }
    case 101: {
      core.CodeEntry++;
    }
    case 102: {
      core.CodeEntry += 2;
    }
    case 103: {
      core.CodeEntry += 3;
    }
    case 104: {
      core.CodeEntry += 4;
    }
    case 105: {
      core.CodeEntry += 5;
    }
    case 106: {
      core.CodeEntry += 6;
    }
    case 107: {
      core.CodeEntry += 7;
    }
    case 108: {
      core.CodeEntry += 8;
    }
    case 109: {
      core.CodeEntry += 9;
    }
    //Debug, somethingsomething aoe blah blah blah
    case 200:{
      DispatchCircleAOE(1613.101929, -1490.457520, -532.186646);
    }
    //Taco Bell Edition
    case 210: {
      core.tacobell = true;
      ServerCommand("fb_startmoney 200000");
      CPrintToChatAll("{darkviolet}[{orange}INFO{darkviolet}] {white}You have chosen {red}DOVAH'S ASS - TACO BELL EDITION{white}. Warning: All upgrade progress will be lost if you fail the wave. DO NOT FAIL US.");
    }
    //Reset Map
    case 300:{
      core.shouldStopMusic = true;
      core.BGMINDEX = GetRandomInt(1, 4);
      core.ticksMusic = -2;
      core.refireTime = 2;
      core.canCrusaderNuke = false;
      core.canHindenburg = false;
      core.canHWBoss = false;
      core.canSephNuke = false;
      core.canTornado = false;
      core.isWave = false;
      core.bombStatusMax = 7;
      core.bombStatus = 5;
      core.sephiroth = false;
      core.waveFlags = 0;
      bombState[0].ready = false;
      FireEntityInput("rain", "Alpha", "0", 0.0);
      FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0);
      FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
      FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0);
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
    }
    //TEMP FUNCTIONS
    case 301: {
      EmitSoundToAll(BGMArray[5].realPath, _, core.SNDCHAN, BGMArray[5].SNDLVL, SND_CHANGEVOL, 0.05, _, _, _, _, _, _);
    }
    //TEMP FUNCTIONS
    case 302: {
      EmitSoundToAll(BGMArray[5].realPath, _, core.SNDCHAN, BGMArray[5].SNDLVL, SND_CHANGEVOL, 1.0, _, _, _, _, _, _);
    }
    case 304: {
      EmitSoundToAll(BGMArray[6].realPath, _, core.SNDCHAN, BGMArray[6].SNDLVL, SND_CHANGEVOL, 0.05, _, _, _, _, _, _);
    }
    case 305: {
      EmitSoundToAll(BGMArray[6].realPath, _, core.SNDCHAN, BGMArray[6].SNDLVL, SND_CHANGEVOL, 1.0, _, _, _, _, _, _);
    }
    //LOOP SYSTEM
    case 500: {
      PrintToConsoleAll("[CORE] Phase Change started... phase 2!");
      core.BGMINDEX = 9;
      core.shouldStopMusic = true;
    }
    case 501: {
      PrintToConsoleAll("[CORE] Phase Change started... phase 3!");
      core.BGMINDEX = 10;
      core.shouldStopMusic = true;
    }
    case 502: {
      PrintToChatAll("Got 502 but not implemented in popfile, please report this to fartsy!");
      PrintToConsoleAll("[CORE] Phase Change started... phase 4!");
      core.BGMINDEX = 11;
      core.shouldStopMusic = true;
    }
    // FINAL Music system rewrite (again) AGAINNNNNNNNNNNN.... and again!
    case 1000: {
      SetupMusic(core.BGMINDEX);
    }
    //Stop current song
    case 1001: {
      if (StrEqual(core.realPath, "null")) return;
      for (int i = 1; i <= MaxClients; i++) {
        StopSound(i, core.SNDCHAN, core.realPath);
      }
      return;
    }
    //Feature an admin
    case 1002: {
      FireEntityInput("AdminPicker", "SetTextureIndex", "0", 0.0);
      int i = GetRandomInt(1, 10);
      char TextureIndex[4];
      IntToString(i, TextureIndex, sizeof(TextureIndex));
      if (i == core.lastAdmin)
        sudo(1002);
      else {
        FireEntityInput("AdminPicker", "SetTextureIndex", TextureIndex, 0.1);
        core.lastAdmin = i;
      }
      return;
    }
    //Strike Lightning
    case 1003: {
      FireEntityInput("lightning", "TurnOn", "", 0.0);
      FireEntityInput("weather", "Skin", "4", 0.0);
      FireEntityInput("value", "TurnOff", "", 0.0);
      FireEntityInput("LightningLaser", "TurnOn", "", 0.0);
      FireEntityInput("lightning", "TurnOff", "", 0.1);
      FireEntityInput("weather", "Skin", "3", 0.1);
      FireEntityInput("LightningLaser", "TurnOff", "", 0.1);
      FireEntityInput("lightning", "TurnOn", "", 0.17);
      FireEntityInput("weather", "Skin", "4", 0.17);
      FireEntityInput("LightningLaser", "TurnOn", "", 0.17);
      FireEntityInput("lightning", "TurnOff", "", 0.25);
      FireEntityInput("weather", "Skin", "3", 0.25);
      FireEntityInput("LightningLaser", "TurnOff", "", 0.25);
    }
    //Activate Tornado Timer
    case 1004: {
      if (core.isWave && core.canTornado) {
        if (core.curWave == 4) {
          float f = GetRandomFloat(30.0, 60.0);
          float t = f - 30.0;
          CreateTimer(t, TimedOperator, 40);
          CreateTimer(f, TimedOperator, 41);
        } else {
          float f = GetRandomFloat(210.0, 500.0);
          float t = f - 30.0;
          CreateTimer(t, TimedOperator, 40);
          CreateTimer(f, TimedOperator, 41);
        }
      }
    }
    //Despawn the tornado
    case 1005: {
      FireEntityInput("tornadof1", "stop", "", 0.0);
      FireEntityInput("TornadoKill", "Disable", "", 0.0);
      FireEntityInput("tornadof1wind", "Disable", "", 0.0);
      FireEntityInput("tornadowindf1", "StopSound", "", 0.0);
      FireEntityInput("shaketriggerf1", "Disable", "", 0.0);
      FireEntityInput("tornadobutton", "Unlock", "", 30.0);
      FireEntityInput("FB.FakeTankTank01", "Kill", "", 0.0);
      FireEntityInput("FB.FakeTankPhys01", "Kill", "", 0.0);
      core.tornado = false;
      return;
    }
    //Crusader
    case 1006: {
      core.tickMusic=false;
      sudo(1001);
      FireEntityInput("FB.MusicTimer", "Disable", "", 0.0);
      core.crusader = true;
      CreateTimer(25.20, TimedOperator, 78);
      CreateTimer(63.20, TimedOperator, 80);
      PrintToServer("Starting Crusader via plugin!");
      EmitSoundToAll("fartsy/misc/fartsyscrusader_bgm_locus.mp3");
      CreateTimer(1.75, CRUSADERINCOMING);
      FireEntityInput("FB.BOOM", "StopShake", "", 3.0);
      FireEntityInput("FB.CRUSADER", "Enable", "", 25.20);
      FireEntityInput("CrusaderTrain", "StartForward", "", 25.20);
      FireEntityInput("CrusaderLaserBase*", "StartForward", "", 25.20);
      CreateTimer(25.20, TimedOperator, 9);
      FireEntityInput("CrusaderTrain", "SetSpeed", "0.9", 38.0);
      FireEntityInput("CrusaderTrain", "SetSpeed", "0.7", 38.60);
      FireEntityInput("CrusaderTrain", "SetSpeed", "0.5", 39.20);
      FireEntityInput("CrusaderTrain", "SetSpeed", "0.3", 40.40);
      FireEntityInput("CrusaderTrain", "SetSpeed", "0.1", 41.40);
      FireEntityInput("CrusaderTrain", "Stop", "", 42.60);
      FireEntityInput("FB.CrusaderLaserKill01", "Disable", "", 42.60);
      CreateTimer(42.60, TimedOperator, 10);
      FireEntityInput("FB.LaserCore", "TurnOn", "", 45.80);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.35", 45.80);
      FireEntityInput("FB.ShakeCore", "StartShake", "", 45.80);
      FireEntityInput("CrusaderSprite", "Color", "255 128 128", 45.80);
      FireEntityInput("FB.ShakeCore", "StopShake", "", 48.80);
      FireEntityInput("FB.LaserInnerMost", "TurnOn", "", 49.20);
      FireEntityInput("FB.ShakeInner", "StartShake", "", 49.20);
      FireEntityInput("CrusaderSprite", "Color", "255 230 230", 49.20);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.35", 50.20);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.45", 50.60);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.55", 51.0);
      FireEntityInput("FB.ShakeInner", "StopShake", "", 52.10);
      FireEntityInput("FB.ShakeInner", "StartShake", "", 52.20);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.45", 54.0);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.4", 54.40);
      FireEntityInput("FB.ShakeInner", "StopShake", "", 55.0);
      FireEntityInput("FB.ShakeInner", "StartShake", "", 55.10);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.75", 57.20);
      FireEntityInput("FB.CrusaderSideLaser", "TurnOn", "", 57.20);
      FireEntityInput("FB.ShakeInner", "StopShake", "", 58.0);
      FireEntityInput("FB.ShakeInner", "StartShake", "", 58.10);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "1", 58.50);
      FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.75", 60.80);
      FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.65", 61.10);
      FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.55", 61.40);
      FireEntityInput("FB.LaserCore", "TurnOff", "", 61.40);
      FireEntityInput("FB.LaserInnerMost", "TurnOff", "", 61.40);
      FireEntityInput("CrusaderSprite", "Color", "0 0 0", 61.40);
      FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.45", 61.70);
      FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.3", 62.0);
      FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.15", 62.30);
      FireEntityInput("FB.CrusaderSideLaser", "TurnOff", "", 62.30);
      FireEntityInput("CrusaderLaserBase*", "Stop", "", 62.70);
      FireEntityInput("FB.Laser*", "TurnOn", "", 65.20);
      FireEntityInput("CrusaderLaserBase*", "StartForward", "", 65.20);
      FireEntityInput("CrusaderLaserBase", "SetSpeed", "1", 65.20);
      FireEntityInput("FB.ShakeBOOM", "StartShake", "", 65.20);
      FireEntityInput("FB.Fade", "Fade", "", 65.20);
      FireEntityInput("HurtAll", "AddOutput", "damagetype 1024", 65.10);
      FireEntityInput("HurtAll", "AddOutput", "damage 2000000", 65.10);
      FireEntityInput("HurtAll", "Enable", "", 65.20);
      FireEntityInput("FB.CrusaderSideLaser", "TurnOn", "", 65.20);
      FireEntityInput("CrusaderSprite", "Color", "255 230 255", 65.20);
      FireEntityInput("FB.Laser*", "TurnOff", "", 70.0);
      FireEntityInput("CrusaderTrain", "StartForward", "", 70.0);
      FireEntityInput("CrusaderLaserBase*", "Stop", "", 70.0);
      FireEntityInput("HurtAll", "Disable", "", 70.0);
      FireEntityInput("FB.CrusaderSideLaser", "TurnOff", "", 70.0);
      FireEntityInput("CrusaderSprite", "Color", "0 0 0", 70.0);
      FireEntityInput("FB.ShakeBOOM", "StopShake", "", 70.20);
      FireEntityInput("CrusaderTrain", "Stop", "", 80.0);
      FireEntityInput("FB.CRUSADER", "Disable", "", 80.0);
      CreateTimer(80.0, TimedOperator, 79);
    }
    //Choose bomb path
    case 1007: {
      FireEntityInput("Nest_*", "Disable", "", 0.0);
      FireEntityInput("bombpath_right_prefer_flankers", "Disable", "", 0.0);
      FireEntityInput("bombpath_left_prefer_flankers", "Disable", "", 0.0);
      FireEntityInput("bombpath_left_navavoid", "Disable", "", 0.0);
      FireEntityInput("bombpath_right_navavoid", "Disable", "", 0.0);
      FireEntityInput("bombpath_right_arrows", "Disable", "", 0.0);
      FireEntityInput("bombpath_left_arrows", "Disable", "", 0.0);
      int i = GetRandomInt(1, 3);
      switch (i) {
        case 1: {
          FireEntityInput("Nest_R*", "Enable", "", 0.25);
          FireEntityInput("bombpath_right_prefer_flankers", "Enable", "", 0.25);
          FireEntityInput("bombpath_right_navavoid", "Enable", "", 0.25);
          FireEntityInput("bombpath_right_arrows", "Enable", "", 0.25);
        }
        case 2: {
          FireEntityInput("Nest_L*", "Enable", "", 0.25);
          FireEntityInput("bombpath_left_prefer_flankers", "Enable", "", 0.25);
          FireEntityInput("bombpath_left_navavoid", "Enable", "", 0.25);
          FireEntityInput("bombpath_left_arrows", "Enable", "", 0.25);
        }
        case 3: {
          FireEntityInput("dovahsassprefer", "Enable", "", 0.25);
          FireEntityInput("Nest_EN*", "Enable", "", 0.25);
          FireEntityInput("bombpath_right_prefer_flankers", "Enable", "", 0.25);
          FireEntityInput("bombpath_right_navavoid", "Enable", "", 0.25);
          FireEntityInput("bombpath_right_arrows", "Enable", "", 0.25);
        }
      }
    }
    //Monitor power up/down!
    case 1008: {
      if (!core.monitorOn) {
        core.monitorOn = true;
        if (!core.monitorColor)
          FireEntityInput("FB.MonitorSprite", "Color", "0 0 255", 0.0);
        else
          FireEntityInput("FB.MonitorSprite", "Color", "0 255 0", 0.0);
        FireEntityInput("FB.MonitorBlank", "Disable", "", 0.0);
        FireEntityInput("FB.MonitorBW", "Enable", "", 0.0);
      }
      else {
        core.monitorOn = false;
        FireEntityInput("FB.MonitorSprite", "Color", "255 0 0", 0.0);
        FireEntityInput("FB.Monitor", "Disable", "", 0.0);
        FireEntityInput("FB.MonitorBW", "Disable", "", 0.0);
        FireEntityInput("FB.MonitorBlank", "Enable", "", 0.0);
      }
    }
    //Cycle monitor forward
    case 1009: {
      core.camSel++;
      if (core.camSel >= 5) core.camSel = 0;
      FireEntityInput("FB.Monitor", "SetCamera", SelectedCamera[core.camSel], 0.0);
      FireEntityInput("FB.MonitorBW", "SetCamera", SelectedCamera[core.camSel], 0.0);
    }
    //Cycle monitor back
    case 1010: {
      core.camSel--;
      if(core.camSel <= -1) core.camSel = 4;
      FireEntityInput("FB.Monitor", "SetCamera", SelectedCamera[core.camSel], 0.0);
      FireEntityInput("FB.MonitorBW", "SetCamera", SelectedCamera[core.camSel], 0.0);
    }
    //Enable black and white.
    case 1011: {
      if (!core.monitorOn) return;
      else {
        if (!core.monitorColor) {
          core.monitorColor = true;
          FireEntityInput("FB.MonitorSprite", "Color", "0 255 0", 0.0);
          FireEntityInput("FB.Monitor", "Enable", "", 0.0);
          FireEntityInput("FB.MonitorBW", "Disable", "", 0.0);
        } else {
          core.monitorColor = false;
          FireEntityInput("FB.MonitorSprite", "Color", "0 0 255", 0.0);
          FireEntityInput("FB.Monitor", "Disable", "", 0.0);
          FireEntityInput("FB.MonitorBW", "Enable", "", 0.0);
        }
      }
    }
    case 6942: {
      core.sacPoints = 2147483647;
    }
    //Do not EVER EVER execute this unless it's an emergency...
    case 6969: {
      if (!core.isWave) {
        CPrintToChatAll("{darkred} [CORE] ERROR, attempted to invoke function without an active wave.");
        return;
      } else {
        if (!core.brawler_emergency) {
          core.brawler_emergency = true,
          EmitSoundToAll(SFXArray[55]);
          CreateTimer(1.0, TimedOperator, 6969);
          CPrintToChatAll("{darkred}EMERGENCY MODE ACTIVE.");
          core.sacPoints = 0;
          ServerCommand("sm_addcash @red 2000000");
          ServerCommand("sm_god @red 1");
        } else {
          CPrintToChatAll("{darkred}[CORE] Failed to enter emergency mode, it is already active.");
          return;
        }
      }
    }
    //DEBUG
    case 9000: {
      CreateTimer(10.0, BossHPTimer);
    }
    case 9001:{
      PrintToServer("BGM State is %b", core.bgmPlaying);
    }
    case 9010: {
      CustomSoundEmitter(TBGM6, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM4, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM5, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM3, 65, true, 1, 0.05, 100);
    }
    case 9011: {
      CustomSoundEmitter(TBGM6, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM4, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM5, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM3, 65, true, 1, 0.05, 100);
    }
    case 9012: {
      CustomSoundEmitter(TBGM6, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM4, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM5, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM3, 65, true, 1, 0.05, 100);
    }
    case 9013: {
      CustomSoundEmitter(TBGM6, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM4, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM5, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM3, 65, true, 1, 1.0, 100);
    }
    case 9014: {
      CustomSoundEmitter(TBGM6, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM4, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM5, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM3, 65, true, 1, 1.0, 100);
    }
    case 9015: {
      CustomSoundEmitter(TBGM6, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM4, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM5, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM3, 65, true, 1, 1.0, 100);
    }
    case 9016: {
      CustomSoundEmitter(TBGM6, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM4, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM5, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM3, 65, true, 1, 1.0, 100);
    }
    //Play Instrumental
    case 9020: {
      CustomSoundEmitter(TBGM0, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM1, 65, true, 1, 0.05, 100);
    }
    //Play Both
    case 9021: {
      CustomSoundEmitter(TBGM0, 65, true, 1, 1.0, 100);
      CustomSoundEmitter(TBGM1, 65, true, 1, 1.0, 100);
    }
    //Play vocal only
    case 9022: {
      CustomSoundEmitter(TBGM0, 65, true, 1, 0.05, 100);
      CustomSoundEmitter(TBGM1, 65, true, 1, 1.0, 100);
    }
  }
  return;
}

//Perform Wave Setup
public Action PerformWaveSetup() {
  core.isWave = true; //It's a wave!
  core.FailedCount = 0; //Reset fail count to zero. (See EventWaveFailed, where we play the BGM.)
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
public Action TimedOperator(Handle timer, int job) {
  switch (job) {
  case 0: {
    CPrintToChatAll(core.VIPBGM >= 0 ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave %i: {forestgreen}%s{white} (requested by VIP {forestgreen}%N{white})" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave %i: {forestgreen}%s", core.curWave, core.songName, core.VIPIndex);
  }
  //Boss script
  case 2: {
    ServerCommand("fb_operator 1001"); //Stop all bgm.
    FireEntityInput("FB.MusicTimer", "Disable", "", 0.0); //Disable all bgm.
    CreateTimer(0.0, TimedOperator, 3);
  }
  //Boss script pt 2
  case 3: {
    core.BGMINDEX = 16;
    core.realPath = BGMArray[core.BGMINDEX].realPath;
    core.songName = BGMArray[core.BGMINDEX].songName;
    CustomSoundEmitter(BGMArray[core.BGMINDEX].realPath, BGMArray[core.BGMINDEX].SNDLVL, true, 0, 1.0, 100);
    FireEntityInput("FB.FadeTotalBLCK", "Fade", "", 0.0);
    FireEntityInput("FB.FadeTotalBLCK", "Fade", "", 3.0);
    FireEntityInput("FB.FadeTotalBLCK", "Fade", "", 7.0);
    FireEntityInput("FB.FadeTotalBLCK", "Fade", "", 12.0);
    FireEntityInput("SephMeteor", "ForceSpawn", "", 19.6);
    CreateTimer(23.0, TimedOperator, 4);
  }
  //Boss script pt 3
  case 4: {
    CustomSoundEmitter(SFXArray[9], 65, false, 0, 1.0, 100),
      CreateTimer(4.1, TimedOperator, 5);
  }
  //Boss script pt 4
  case 5: {
    CustomSoundEmitter(SFXArray[58], 65, false, 0, 1.0, 100),
      FireEntityInput("SephNuke", "ForceSpawn", "", 3.0),
      CreateTimer(3.2, TimedOperator, 6);
  }
  //Boss script pt 5
  case 6: {
    CustomSoundEmitter(SFXArray[35], 65, false, 0, 1.0, 100),
      FireEntityInput("FB.Fade", "Fade", "", 0.0),
      CreateTimer(1.0, SephATK),
      CreateTimer(1.7, TimedOperator, 7);
  }
  //DO THE THING ALREADY
  case 7: {
    core.sephiroth = true;
    core.ticksMusic = 0;
    core.refireTime = BGMArray[16].refireTime;
  }
  //Signal boss to actually spawn after delay.
  case 8: {
    CustomSoundEmitter(SFXArray[57], 65, false, 0, 1.0, 100);
    CPrintToChatAll("{darkgreen}[CORE] You did it!!! {darkred}Or... did you...?");
    FireEntityInput("FB.FadeBLCK", "Fade", "", 0.0);
    CreateTimer(4.8, TimedOperator, 2);
  }
  //Crusader Nuke activation
  case 9: {
    core.canCrusaderNuke = true;
    CreateTimer(1.0, CrusaderNukeTimer);
  }
  //Crusader Nuke Deactivation
  case 10: {
    core.canCrusaderNuke = false;
    return Plugin_Stop;
  }
  //Seph Nuke Deactivation
  case 11: {
    core.canSephNuke = false;
    return Plugin_Stop;
  }
  //SENTMeteor Timeout
  case 12: {
    core.canSENTMeteors = false;
    return Plugin_Stop;
  }
  //SENTStars Timeout
  case 14: {
    core.canSENTStars = false;
    return Plugin_Stop;
  }
  //Incoming
  case 21: {
    CustomSoundEmitter(SFXArray[37], 65, false, 0, 1.0, 100);
    return Plugin_Stop;
  }
  case 37: {
    EmitSoundToAll(SFXArray[35]);
    return Plugin_Stop;
  }
  case 40: {
    if (core.isWave && core.canTornado) {
      EmitSoundToAll("mvm/ambient_mp3/mvm_siren.mp3"),
        core.TornadoWarningIssued = true;
    }
    return Plugin_Stop;
  }
  case 41: {
    if (core.isWave && core.canTornado && !core.tornado) {
      FireEntityInput("TornadoKill", "Enable", "", 0.0),
        FireEntityInput("tornadobutton", "Lock", "", 0.0),
        FireEntityInput("tornadof1", "start", "", 20.0),
        FireEntityInput("shaketriggerf1", "Enable", "", 20.0),
        FireEntityInput("tornadowindf1", "PlaySound", "", 20.0),
        FireEntityInput("tornadof1wind", "Enable", "", 21.50);
      core.tornado = true;
      float f = GetRandomFloat(60.0, 120.0);
      CreateTimer(f, TimedOperator, 42);
    }
    return Plugin_Stop;
  }
  case 42: {
    ServerCommand("fb_operator 1005");
    core.TornadoWarningIssued = false;
    ServerCommand("fb_operator 1004");
  }
  case 60: {
    CustomSoundEmitter(SFXArray[40], 65, false, 0, 1.0, 100);
    return Plugin_Stop;
  }
  case 70: {
    if (core.isWave) {
      FireEntityInput("FB.KP*", "Unlock", "", 0.0);
      CustomSoundEmitter(SFXArray[0], 65, false, 0, 1.0, 100);
    }
    return Plugin_Stop;
  }
  case 71: {
    CustomSoundEmitter("fartsy/eee/the_horn.wav", 65, false, 0, 1.0, 100);
    return Plugin_Stop;
  }
  case 78: {
    EmitSoundToAll(SFXArray[7]);
    return Plugin_Handled;
  }
  case 79: {
    core.crusader = false;
    core.curWave = GetCurWave();
    if (core.isWave && (core.curWave == 3 || core.curWave == 5)) {
      sudo(99);
    }
    return Plugin_Stop;
  }
  case 80: {
    EmitSoundToAll(SFXArray[59]);
    return Plugin_Stop;
  }
  case 99: {
    if (core.isWave) {
      sudo(99);
    }
    return Plugin_Stop;
  }
  case 100: {
    ServerCommand("_restart");
  }
  case 1000: {
    PrintToConsoleAll("This shouldn't be showing in your console. If it is, contact Fartsy#8998 .");
  }
  case 6969: {
    if (core.isWave) {
      ServerCommand("sm_freeze @blue; sm_smash @blue; sm_evilrocket @blue");
      sudo(2);
      CreateTimer(4.0, TimedOperator, 6970);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6970: {
    if (core.isWave) {
      EmitSoundToAll(SFXArray[6]);
      CreateTimer(7.0, TimedOperator, 6971);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6971: {
    if (core.isWave) {
      ServerCommand("fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40");
      CreateTimer(1.0, TimedOperator, 6972);
    } 
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6972: {
    if (core.isWave) {
      ServerCommand("fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42");
      sudo(1006);
      CreateTimer(1.0, TimedOperator, 6973);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6973: {
    if (core.isWave) {
      core.bombStatus = 8;
      core.bombStatusMax = 10;
      sudo(15);
      CreateTimer(1.0, TimedOperator, 6974);
    } 
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6974: {
    if (core.isWave) {
      core.bombStatus = 16,
      core.bombStatusMax = 18,
      ServerCommand("fb_operator 15;fb_operator 15"),
      CreateTimer(1.0, TimedOperator, 6975);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6975: {
    if (core.isWave) {
      core.bombStatus = 24,
      core.bombStatusMax = 26,
      ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15");
      CreateTimer(1.0, TimedOperator, 6976);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6976: {
    if (core.isWave) {
      core.bombStatus = 32,
      core.bombStatusMax = 34,
        ServerCommand("fb_operator 15;fb_operator15;fb_operator 15;fb_operator 15"),
        CreateTimer(1.0, TimedOperator, 6977);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6977: {
    if (core.isWave) {
      core.bombStatus = 40,
      core.bombStatusMax = 42,
        ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15"),
        CreateTimer(1.0, TimedOperator, 6978);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6978: {
    if (core.isWave) {
      core.bombStatus = 48,
      core.bombStatusMax = 50,
        ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15"),
        ServerCommand("fb_operator 30"),
        CreateTimer(1.0, TimedOperator, 6979);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6979: {
    if (core.isWave) {
      core.bombStatus = 5,
      ServerCommand("fb_operator 31"),
        CreateTimer(1.0, TimedOperator, 6980);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6980: {
    if (core.isWave) {
      ServerCommand("fb_operator 32"),
        CreateTimer(1.0, TimedOperator, 6981);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6981: {
    if (core.isWave) {
      ServerCommand("fb_operator 33"),
        CreateTimer(1.0, TimedOperator, 6982);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6982: {
    if (core.isWave) {
      ServerCommand("fb_operator 34"),
        CreateTimer(1.0, TimedOperator, 6983);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6983: {
    if (core.isWave) {
      ServerCommand("fb_operator 35"),
        CreateTimer(1.0, TimedOperator, 6984);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6984: {
    if (core.isWave) {
      ServerCommand("fb_operator 36"),
        CreateTimer(1.0, TimedOperator, 6985);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6985: {
    if (core.isWave) {
      sudo(37);
      CreateTimer(1.0, TimedOperator, 6986);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6986: {
    if (core.isWave) {
      ServerCommand("sm_freeze @blue -1; sm_smash @blue"),
        CreateTimer(3.0, TimedOperator, 6987);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6987: {
    if (core.isWave) {
      ServerCommand("fb_operator 40; fb_operator 42; fb_operator 30; fb_operator 32; fb_operator 34; fb_operator 32; fb_operator 31; fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 31;fb_operator 32;fb_operator 32;fb_operator 31;fb_operator 32;fb_operator 32");
      CreateTimer(1.0, TimedOperator, 6988);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6988: {
    if (core.isWave) {
      core.bombStatus = 48;
      core.bombStatusMax = 50;
      ServerCommand("fb_operator 15;fb_operator15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15");
      for (int i = 0; i < 12; i++){
        sudo(GetRandomInt(30,37));
        sudo(GetRandomInt(40,44));
        sudo(1003);
      }
      CreateTimer(1.0, TimedOperator, 6989);
    }
    else
      ExitEmergencyMode();
    return Plugin_Stop;
  }
  case 6989: {
    CPrintToChatAll("{darkgreen}[CORE] Exiting emergency mode."),
    core.brawler_emergency = false;
    ServerCommand("sm_god @red 0");
    return Plugin_Stop;
  }
  }
  return Plugin_Stop;
}

//Exit emergency mode!
public void ExitEmergencyMode() {
  CPrintToChatAll("{darkgreen}[CORE] Exiting emergency mode, the wave has ended.");
  core.brawler_emergency = false;
  core.sacPoints = 0;
  ServerCommand("sm_god @red 0");
}

//Setup music, this allows us to change it with VIP access...
public void SetupMusic(int bgm) {
  core.bgmPlaying = true;
  core.ticksMusic = -2;
  core.refireTime = 2;
  core.tickMusic = true;
  core.tickOffset = false;
  core.BGMINDEX = (core.VIPBGM >= 0 ? core.VIPBGM : bgm);
  core.realPath = (core.VIPBGM >= 0 ? BGMArray[core.VIPBGM].realPath : BGMArray[bgm].realPath);
  core.shouldStopMusic = (!StrEqual(core.cachedPath, core.realPath) ? true : false);
}
//VIP Music Menu
public Action Command_Music(int client, int args) {
  int steamID = GetSteamAccountID(client);
  if (!steamID || steamID <= 10000) return Plugin_Handled;
  else ShowFartsyMusicMenu(client);
  return Plugin_Handled;
}

//VIP Music Menu
public void ShowFartsyMusicMenu(int client) {
  Menu menu = new Menu(MenuHandlerFartsyMusic, MENU_ACTIONS_DEFAULT);
  char buffer[100];
  menu.SetTitle("FartsysAss Music Menu");
  for (int i = 0; i < sizeof(BGMArray); i++)
    menu.AddItem(buffer, BGMArray[i].songName);
  menu.Display(client, 20);
  menu.ExitButton = true;
}

// VIP Music Menu, bgm-1 fixes the fact that position 0 is Restore Defaults, and arrays cannot be -1. By adding Restore Defaults at position 0, we offset everything by +1.
public int MenuHandlerFartsyMusic(Menu menu, MenuAction action, int client, int bgm) {
  if (action == MenuAction_Select) {
    core.curWave = GetCurWave();
    CPrintToChat(client, (bgm == 0 ? "{darkgreen}[CORE] Confirmed. Next song set to {aqua}Default{darkgreen}." : "{limegreen}[CORE] Confirmed. Next song set to {aqua}%s{limegreen}."),  BGMArray[bgm].songName);
    core.BGMINDEX = (bgm == 0 ? (core.tacobell ? tacoBellBGMIndex[core.curWave] : core.sephiroth ? 16 : core.isWave ? DefaultsArray[core.curWave].defBGMIndex : GetRandomInt(1, 4)) : bgm);
    core.shouldStopMusic = (!StrEqual(core.cachedPath, BGMArray[bgm].realPath) ? true : false);
    core.VIPBGM = (bgm == 0 ? -1 : bgm);
    core.VIPIndex = client;
    PrintToServer("Debug, music set to core.BGMINDEX %i and path %s", core.BGMINDEX, BGMArray[bgm].realPath);
  }
  else if (action == MenuAction_End)
    CloseHandle(menu);
  return 0;
}

public Action TickClientHealth(Handle timer) {
  for (int i = 1; i <= MaxClients; i++) {
    if (IsValidClient(i) && (GetClientTeam(i) == 2)) {
      int health = GetClientHealth(i);
      int healthMax = TF2_GetPlayerMaxHealth(i);
      if (!FB_Database) return Plugin_Stop;
      else {
        char query[256];
        int steamID = GetSteamAccountID(i);
        Format(query, sizeof(query), "UPDATE ass_activity SET health = %i, maxHealth = %i WHERE steamid = %i;", health, healthMax, steamID);
        FB_Database.Query(Database_FastQuery, query);
      }
    }
    else if (GetClientCount(true) <= 0){
      PrintToServer("Server is empty. Stopping the music queue.");
      core.bgmPlaying = false;
      core.tickingClientHealth = false;
      core.tickMusic = false;
      core.BGMINDEX = GetRandomInt(1, 4);
      core.shouldStopMusic = false;
      core.realPath = "null";
      core.refireTime = 0;
      core.ticksMusic = 0;
      return Plugin_Stop;
    }
  }
  CreateTimer(1.0, TickClientHealth);
  return Plugin_Stop;
}
//Get current wave
public int GetCurWave(){
  int ent = FindEntityByClassname(-1, "tf_objective_resource");
  if (ent == -1) {
    AssLogger(3, "tf_objective_resource not found");
    return -1;
  }
  return GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
}