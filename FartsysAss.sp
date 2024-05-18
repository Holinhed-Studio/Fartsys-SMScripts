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
static char PLUGIN_VERSION[8] = "7.1.0";

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
      if (core.shouldStopMusic) {
        for (int i = 1; i <= MaxClients; i++) {
          StopSound(i, core.SNDCHAN, core.cachedPath);
          core.shouldStopMusic = false;
        }
      }
      core.songName = BGMArray[core.BGMINDEX].songName;
      core.refireTime = BGMArray[core.BGMINDEX].refireTime;
      core.ticksMusic = (core.tickOffset ? BGMArray[core.BGMINDEX].ticksOffset : 0);
      CustomSoundEmitter(BGMArray[core.BGMINDEX].realPath, BGMArray[core.BGMINDEX].SNDLVL, true, 1, 1.0, 100);
      CreateTimer(1.0, SyncMusic);
    }
  }
}

//Restart music for the new client
public Action RefireMusicForClient(Handle timer, int client) {
  if (IsValidClient(client)) {
    if (GetClientTeam(client) == 0) CreateTimer(1.0, RefireMusicForClient, client);
    else if (GetClientTeam(client) == 2) CSEClient(client, BGMArray[core.BGMINDEX].realPath, BGMArray[core.BGMINDEX].SNDLVL, true, 1, 1.0, 100);
  }
  return Plugin_Stop;
}
//Get client's stats via command
public Action Command_MyStats(int client, int args) {
  int steamID = GetSteamAccountID(client);
  if (!FB_Database || !steamID || steamID <= 10000) return Plugin_Stop;
  char queryID[256];
  Format(queryID, sizeof(queryID), "SELECT * from ass_activity WHERE steamid = %i;", steamID);
  FB_Database.Query(MyStats, queryID, client);
  return Plugin_Continue;
}

public void MyStats(Database db, DBResultSet results, const char[] error, int client) {
  if (!results) {
    LogError("Failed to query database: %s", error);
    return;
  }
  char name[64];
  char class [64];
  int health, healthMax, steamID, damagedealt, damagedealtsession, kills, killssession, deaths, deathssession, bombsreset, bombsresetsession, sacrifices, sacrificessession;
  char lastkilledname[128];
  char lastusedweapon[128];
  char killedbyname[128];
  char killedbyweapon[128];
  if (results.FetchRow()) {
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
  if (action == CookieMenuAction_SelectOption) ShowFartsyMenu(client);
}

//Queue music for new clients, also track their health.
public void OnClientPostAdminCheck(int client) {
  if (!IsFakeClient(client) && core.bgmPlaying) CreateTimer(1.0, RefireMusicForClient, client);
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
    if (!core.bgmPlaying) SetupMusic(GetRandomInt(1, 4));
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
  } else if (action == MenuAction_End) CloseHandle(menu);
  return 0;
}

//Fartsy's A.S.S
public Action Command_SacrificePointShop(int client, int args) {
  ShowFartsysAss(client);
  return Plugin_Handled;
}

//Fartsy's A.S.S
public void ShowFartsysAss(int client) {
  CPrintToChat(client, (!core.isWave ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}The sacrificial points counter is currently at %i of %i maximum for this wave." : core.sacPoints <= 9 ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {red}You do not have enough sacrifice points to use this shop. You have %i / 10 required." : ""), core.sacPoints, core.sacPointsMax);
  if (!core.isWave || core.sacPoints < 10) return;
  Menu menu = new Menu(MenuHandlerFartsysAss, MENU_ACTIONS_DEFAULT);
  char buffer[100];
  menu.SetTitle("Fartsy's Annihilation Supply Shop");
  menu.ExitButton = true;
  for (int i = 0; i < RoundToFloor(core.sacPoints / 10.0); i++) menu.AddItem(buffer, ass[i].name);
  menu.Display(client, 20);
}

//Also Fartsy's A.S.S
public int MenuHandlerFartsysAss(Menu menu, MenuAction action, int client, int item) {
  if (action == MenuAction_Select) {
    if (core.sacPoints < ass[item].price) return 0;
    else sudo(ass[item].purchase);
    Format(LoggerInfo, sizeof(LoggerInfo), "%N opted for %s via the A.S.S.", client, ass[item].name);
    AssLogger(1, LoggerInfo);
  } else if (action == MenuAction_End) CloseHandle(menu);
  return 0;
}

//Now that command definitions are done, lets make some things happen.
public void OnMapStart() {
  CreateTimer(1.0, SelectAdminTimer);
  FastFire("OnUser1 rain:Alpha:0:0.0:1");
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
    int sPos = RoundToFloor(core.ticksMusic / 66.6666666666);
    int tPos = RoundToFloor(core.refireTime / 66.6666666666);
    Format(buffer, 16, "%02d:%02d", sPos / 60, sPos % 60);
    Format(tbuffer, 16, "%02d:%02d", tPos / 60, tPos % 60);
    Format(HintText, sizeof(HintText), (bombState[0].isMoving ? "Payload: MOVING (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)" : bombState[0].isReady ? "Payload: READY (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)" : "Payload: PREPARING (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)"), bombState[0].state, bombState[0].stateMax, core.sacPoints, core.sacPointsMax, core.songName, buffer, tbuffer);
    CreateTimer(2.5, PerformWaveAdverts);
    for (int i = 1; i <= MaxClients; i++) {
      if (IsValidClient(i)) {
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
  }
  return Plugin_Stop;
}

//Brute Justice Timer
public Action OnslaughterATK(Handle timer) {
  if (core.waveFlags != 1) return Plugin_Stop;
  else {
    CreateTimer(GetRandomFloat(5.0, 7.0), OnslaughterATK);
    FastFire("OnUser1 BruteJusticeDefaultATK:FireMultiple:3:5.0:1");
    switch (GetRandomInt(1, 10)) {
    case 1, 6: {
      FastFire("OnUser1 BruteJusticeLaserParticle:Start::0.0:1");
      CustomSoundEmitter(SFXArray[38], 65, false, 0, 1.0, 100);
      FastFire("OnUser1 BruteJusticeLaser:TurnOn::1.40:1");
      FastFire("OnUser1 BruteJusticeLaserHurtAOE:Enable::1.40:1");
      FastFire("OnUser1 BruteJusticeLaserParticle:Stop::3.00:1");
      FastFire("OnUser1 BruteJusticeLaser:TurnOff::3.25:1");
      FastFire("OnUser1 BruteJusticeLaserHurtAOE:Disable::3.25:1");
    }
    case 2, 8: {
      FastFire("OnUser1 BruteJustice:FireUser1::0.0:1");
    }
    case 3, 7: {
      FastFire("OnUser1 BruteJusticeFlameParticle:Start::0.0:1");
      FastFire("OnUser1 BruteJusticeFlamethrowerHurtAOE:Enable::0.0:1");
      CustomSoundEmitter(SFXArray[39], 65, false, 0, 1.0, 100);
      FastFire("OnUser1 SND.BruteJusticeFlameATK:PlaySound::1.25:1");
      FastFire("OnUser1 BruteJusticeFlamethrowerHurtAOE:Disable::5.0:1");
      FastFire("OnUser1 BruteJusticeFlameParticle:Stop::5.0:1");
      FastFire("OnUser1 SND.BruteJusticeFlameATK:FadeOut:.25:5.0:1");
      CreateTimer(5.0, TimedOperator, 60);
      FastFire("OnUser1 SND.BruteJusticeFlameATK:StopSound::5.1:1");
    }
    case 4: {
      FastFire("OnUser1 BruteJusticeGrenadeSpammer:FireMultiple:10:0.0:1");
      FastFire("OnUser1 BruteJusticeGrenadeSpammer:FireMultiple:10:3.0:1");
      FastFire("OnUser1 BruteJusticeGrenadeSpammer:FireMultiple:10:5.0:1");
    }
    case 5: {
      FastFire("OnUser1 BruteJusticeGrenadeSpammer:FireMultiple:50:0.0:1");
    }
    case 9: {
      FastFire("OnUser1 BruteJusticeRocketSpammer:FireOnce::0.0:1");
      FastFire("OnUser1 BruteJusticeRocketSpammer:FireOnce::5.0:1");
    }
    case 10: {
      FastFire("OnUser1 BruteJusticeRocketSpammer:FireMultiple:10:0.0:1");
      FastFire("OnUser1 BruteJusticeRocketSpammer:FireMultiple:10:3.0:1");
      FastFire("OnUser1 BruteJusticeRocketSpammer:FireMultiple:10:5.0:1");
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
    FastFire("OnUser1 SephArrows:FireMultiple:3:5.0:1");
    SephBoss[GetRandomInt(0, 11)].attack();
  }
  return Plugin_Stop;
}

//Boss Health Timer
public Action BossHPTimer(Handle timer) {
  int BossEnt = (core.waveFlags == 1 ? FindEntityByTargetname("OnslaughterTank", "tank_boss") : core.waveFlags == 2 ? FindEntityByTargetname("SephirothTank", "tank_boss") : -1);
  int BossRelayEnt = (core.waveFlags == 1 ? FindEntityByTargetname("FB.BruteJusticeDMGRelay", "func_physbox") : core.waveFlags == 2 ? FindEntityByTargetname("FB.SephirothDMGRelay", "func_physbox") : -1);
  if (BossEnt == -1 || BossRelayEnt == -1) return Plugin_Stop;
  CPrintToChatAll((core.waveFlags == 1 ? "{blue}Onslaughter's HP: %i (%i)" : core.waveFlags == 2 ? "{blue}Sephiroth's HP: %i (%i)" : "{blue}Error: Boss not found... core.waveFlags was neither 1 nor 2"), GetEntProp(BossEnt, Prop_Data, "m_iHealth"), GetEntProp(BossRelayEnt, Prop_Data, "m_iHealth"));
  CreateTimer(10.0, BossHPTimer);
  return Plugin_Stop;
}

//Shark Timer
public Action SharkTimer(Handle timer) {
  if (core.canSENTShark) {
    FastFire("OnUser1 SentSharkTorpedo:ForceSpawn::0.0:1");
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
    FastFire(StrikeAt[GetRandomInt(0, sizeof(StrikeAt) - 1)]);
    FastFire("OnUser1 LightningHurt*:Disable::0.07:1");
    CustomSoundEmitter(SFXArray[GetRandomInt(27, 34)], 65, false, 0, 1.0, 100);
  }
  return Plugin_Stop;
}

//SpecTimer
public Action SpecTimer(Handle timer) {
  if (core.isWave) {
    FastFire("OnUser1 Spec*:Disable::0.0:1");
    FireEntityInput(SpecEnt[GetRandomInt(0, 5)], "Enable", "", 0.1);
    CreateTimer(GetRandomFloat(10.0, 30.0), SpecTimer);
  }
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

//Used for nukes, obiviously
public Action NukeTimer(Handle timer) {
  if (!core.canCrusaderNuke && !core.canSephNuke) return Plugin_Stop;
  CustomSoundEmitter(SFXArray[8], 65, false, 0, 1.0, 100);
  FastFire(core.canCrusaderNuke ? "OnUser1 FB.CrusaderNuke:ForceSpawn::0.0:1" : core.canSephNuke ? "OnUser1 SephNuke:ForceSpawn::0.0:1" : "OnUser1 SephNuke:FireUser1::0.0:1");
  CreateTimer(GetRandomFloat(1.5, 3.0), NukeTimer);
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
  }
  core.INCOMINGDISPLAYED++;
  FastFire("OnUser1 FB.INCOMING:Display::0.0:1");
  CreateTimer(1.75, CRUSADERINCOMING);
  return Plugin_Stop;
}

//Halloween Bosses
public Action HWBosses(Handle timer) {
  if (core.isWave && core.canHWBoss) {
    HWBoss[GetRandomInt(0, 11)].attack();
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
  if (!core.isWave) return Plugin_Stop;
  CreateTimer(0.1, SacrificePointsUpdater);
  if (core.sacPoints > core.sacPointsMax) core.sacPoints = core.sacPointsMax;
  return Plugin_Stop;
}

//BombStatus (Add points to Bomb Status occasionally)
public Action BombStatusAddTimer(Handle timer) {
  if (core.isWave && (bombState[0].state < bombState[0].stateMax)) {
    bombState[0].isReady = false;
    bombState[0].state++;
    CreateTimer(GetRandomFloat(10.0, 45.0), BombStatusAddTimer);
  }
  return Plugin_Stop;
}

//Track bombState[0].state and update entities every 0.1 seconds
public Action BombStatusUpdater(Handle timer) {
  if (core.isWave) {
    CreateTimer(0.1, BombStatusUpdater);
    if (bombState[0].state < bombState[0].stateMax) {
      switch (bombState[0].state) {
      case 8, 16, 24, 32, 40, 48, 56, 64: {
        int curBomb = bombState[0].getCurBomb();
        bombState[0].stateMax = bombState[0].state;
        bombState[0].isReady = true;
        core.canSENTShark = bombState[curBomb].canSENTShark;
        FastFire("OnUser1 Bombs*:Disable::0.0:1");
        FastFire("OnUser1 Delivery:Unlock::0.0:1");
        FireEntityInput(bombState[curBomb].identifier, "Enable", "", 0.0);
        CustomSoundEmitter(SFXArray[56], 65, false, 0, 1.0, 100);
        CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Your team's %s {forestgreen}is now available for deployment!", bombState[curBomb].name);
      }
      }
    } else if (bombState[0].state > bombState[0].stateMax) bombState[0].state = bombState[0].upperLimit();
  }
  return Plugin_Stop;
}

//RobotLaunchTimer (Randomly fling robots)
public Action RobotLaunchTimer(Handle timer) {
  if (!core.isWave) return Plugin_Stop;
  FastFire("OnUser1 FB.RobotLauncher:Enable::0.0:1");
  FastFire("OnUser1 FB.RobotLauncher:Disable::7.5:1");
  CreateTimer(GetRandomFloat(5.0, 30.0), RobotLaunchTimer);
  return Plugin_Stop;
}

//Command action definitions
//Get current song
public Action Command_GetCurrentSong(int client, int args) {
  char buffer[16];
  char tbuffer[16];
  int sPos = RoundToFloor(core.ticksMusic / 66.6666666666);
  int tPos = RoundToFloor(core.refireTime / 66.6666666666);
  Format(buffer, 16, "%02d:%02d", sPos / 60, sPos % 60);
  Format(tbuffer, 16, "%02d:%02d", tPos / 60, tPos % 60);
  CPrintToChat(client, "The current song is: {limegreen}%s {orange}(%s / %s)", core.songName, buffer, tbuffer);
  return Plugin_Handled;
}

//Determine which bomb has been recently pushed and tell the client if a bomb is ready or not.
public Action Command_FBBombStatus(int client, int args) {
  char bombStatusMsg[256];
  Format(bombStatusMsg, sizeof(bombStatusMsg), (bombState[0].isMoving ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}(%i/%i) Your team is currently pushing a %s!" : bombState[0].isReady ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}(%i/%i) Your team's %s is ready!" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}(%i/%i) Your team recently deployed a %s! Please wait for the next bomb."), bombState[0].state, bombState[0].stateMax, bombState[RoundToFloor(bombState[0].state / 8.0)].name);
  CPrintToChat(client, bombStatusMsg);
  return Plugin_Handled;
}

//Return the client to spawn
public Action Command_Return(int client, int args) {
  if (!IsPlayerAlive(client)) {
    CPrintToChat(client, "{red}[Core] You must be alive to use this command...");
    return Plugin_Handled;
  }
  char name[128];
  GetClientName(client, name, sizeof(name));
  CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%s {white}began casting {darkviolet}/return{white}.", name);
  CustomSoundEmitter(SFXArray[41], 65, false, 0, 1.0, 100);
  CreateTimer(5.0, ReturnClient, client);
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

//Check who died by what and announce it to chat.
public Action EventDeath(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
  int attacker = GetClientOfUserId(Spawn_Event.GetInt("attacker"));
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
          FastFire("OnUser1 BG.Meteorites1:ForceSpawn:0.0:1");
          CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, a {red}METEOR{white}has been spotted coming towards Dovah's Ass!!!");
          FastFire("OnUser1 bg.meteorite1:StartForward:0.1:1");
        }
        case 2, 5, 16: {
          CreateTimer(0.5, TimedOperator, 71);
          FastFire("OnUser1 FB.TankTrain:TeleportToPathTrack:Tank01:0.0:1");
          FastFire("OnUser1 FB.TankTrain:StartForward:0.25:1");
          FastFire("OnUser1 FB.TankTrain:SetSpeed:1:0.35:1");
          FastFire("OnUser1 FB.Tank:Enable:1.0:1");
        }
        case 4, 8, 14: {
          CustomSoundEmitter("ambient/alarms/train_horn_distant1.wav", 65, false, 0, 1.0, 100);
          FastFire("OnUser1 TrainSND:PlaySound:0.0:1");
          FastFire("OnUser1 TrainDamage:Enable:0.0:1");
          FastFire("OnUser1 Train01:Enable:0.0:1");
          CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {orange}KISSONE'S TRAIN{white}is {red}INCOMING{white}. Look out!");
          FastFire("OnUser1 TrainTrain:TeleportToPathTrack:TrainTrack01:0.0:1");
          FastFire("OnUser1 TrainTrain:StartForward:0.1:1");
        }
        case 6, 9: {
          core.canTornado = true;
          CreateTimer(1.0, TimedOperator, 41);
        }
        case 7, 13: {
          CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {white}Uh oh, it appears to have started raining a {red}METEOR SHOWER{white}!!!");
          core.canSENTMeteors = true;
          CreateTimer(1.0, SENTMeteorTimer);
          CreateTimer(30.0, TimedOperator, 12);
        }
        case 11: {
          FastFire("OnUser1 FB.Slice:Enable:0.0:1");
          CustomSoundEmitter("ambient/sawblade_impact1.wav", 65, false, 0, 1.0, 100);
          FastFire("OnUser1 FB.Slice:Disable:1.0:1");
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
        Format(EnergyDeath, sizeof(EnergyDeath), (core.crusader ? "THE CRUSADER" : core.waveFlags == 1 ? "THE ONSLAUGHTER" : "A HIGH ENERGY PHOTON BEAM"));
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
    //Log if a player killed someone or was killed by a robot
    if (attacker != client) {
      if (!FB_Database) return Plugin_Handled;
      char query[256];
      int steamID = (IsValidClient(attacker) ? GetSteamAccountID(attacker) : GetSteamAccountID(client));
      Format(query, sizeof(query), IsValidClient(attacker) && !StrEqual(weapon, "world") ? "UPDATE ass_activity SET kills = kills +1, killssession = killssession + 1, lastkilledname = '%s', lastweaponused = '%s' WHERE steamid = %i;" : !StrEqual(weapon, "world") && !IsValidClient(attacker) ? "UPDATE ass_activity SET deaths = deaths + 1, deathssession = deathssession + 1, killedbyname = '%s', killedbyweapon = '%s' WHERE steamid = %i;" : "RETURN", name, weapon, steamID);
      if (StrEqual(query, "RETURN")) return Plugin_Handled;
      FB_Database.Query(Database_FastQuery, query);
    }
  }
  return Plugin_Handled;
}

//Check who spawned and log their class
public Action EventSpawn(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
  if (IsValidClient(client)) {
    int class = Spawn_Event.GetInt("class");
    int steamID = GetSteamAccountID(client);
    if (!FB_Database || !steamID || !class) return Plugin_Handled;
    char strClass[32];
    char query[256];
    strClass = ClassDefinitions[class - 1];
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
public Action EventWarning(Event Spawn_Event,
  const char[] Spawn_Name, bool Spawn_Broadcast) {
  if (core.doFailsafe) {
    core.failsafeCount++;
    CPrintToChatAll("%s Counter: %i", failsafe[GetRandomInt(0, sizeof(failsafe) - 1)], core.failsafeCount);
    EmitSoundToAll(SFXArray[55]);
    ServerCommand("sm_freeze @blue; wait 180; sm_smash @blue;sm_evilrocket @blue");
    core.doFailsafe = false;
  } else CPrintToChatAll("{darkviolet}[{red}WARN{darkviolet}] {darkred}PROFESSOR'S ASS IS ABOUT TO BE DEPLOYED!!!");
  return Plugin_Handled;
}

//When the wave fails
public Action EventWaveFailed(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast) {
  sudo(1000);
  CreateTimer(1.0, PerformAdverts);
  CreateTimer(40.0, SelectAdminTimer);
  CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave {red}failed {white}successfully!");
  sudo(300);
  sudo(1007);
  sudo(1002);
  return Plugin_Handled;
}

//Log Damage!
public void Event_PlayerHurt(Handle event, const char[] name, bool dontBroadcast) {
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
  int damage = GetEventInt(event, "damageamount");
  if (IsValidClient(attacker) && attacker != client) {
    int steamID = GetSteamAccountID(attacker);
    if (!FB_Database || !steamID) return;
    char query[256];
    Format(query, sizeof(query), "UPDATE ass_activity SET damagedealt = damagedealt + %i, damagedealtsession = damagedealtsession + %i WHERE steamid = %i;", damage, damage, steamID);
    FB_Database.Query(Database_FastQuery, query);
  }
}

//Functions
/* Create a temp entity and fire an input - DEPRECATED */
public Action FireEntityInput(char[] strTargetname, char[] strInput, char[] strParameter, float flDelay) {
  char strBuffer[255];
  Format(strBuffer, sizeof(strBuffer), "OnUser1 %s:%s:%s:%f:1", strTargetname, strInput, strParameter, flDelay);
  //PrintToChatAll("{limegreen}[CORE] {white}Firing entity %s with input %s , a parameter override of %s , and delay of %f ...", strTargetname, strInput, strParameter, flDelay);
  int entity = CreateEntityByName("info_target");
  if (!IsValidEdict(entity)) return Plugin_Handled;
  DispatchSpawn(entity);
  ActivateEntity(entity);
  SetVariantString(strBuffer);
  AcceptEntityInput(entity, "AddOutput");
  AcceptEntityInput(entity, "FireUser1");
  CreateTimer(0.0, DeleteEdict, entity);
  return Plugin_Continue;
}
//Create a temp entity and fire an input - ADVANCED Mode
public Action FastFire(char[] input) {
  int entity = CreateEntityByName("info_target");
  if (!IsValidEdict(entity)) return Plugin_Handled;
  DispatchSpawn(entity);
  ActivateEntity(entity);
  SetVariantString(input);
  AcceptEntityInput(entity, "AddOutput");
  AcceptEntityInput(entity, "FireUser1");
  CreateTimer(0.0, DeleteEdict, entity);
  return Plugin_Continue;
}
//Dispatch a circle AOE
public Action DispatchCircleAOE(float posX, float posY, float posZ) {
  int ent = FindEntityByTargetname("CircleTemplate", "point_template");
  if (ent != -1) {
    float dest[3];
    dest[0] = posX;
    dest[1] = posY;
    dest[2] = posZ;
    float destAng[3];
    float destVel[3];
    TeleportEntity(ent, dest, destAng, destVel);
    FastFire("OnUser1 CircleTemplate:ForceSpawn::0.0:1");
  }
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
void CustomSoundEmitter(char[] sndName, int TSNDLVL, bool isBGM, int flags, float vol, int pitch) {
  for (int i = 1; i <= MaxClients; i++) {
    if (!IsValidClient(i)) continue;
    if (isBGM && (soundPreference[i] == 1 || soundPreference[i] == 3) || !isBGM && soundPreference[i] >= 2) EmitSoundToClient(i, sndName, _, core.SNDCHAN, TSNDLVL, flags, vol, pitch, _, _, _, _, _);
  }
}
//Play sound to client. Ripped straight from potato. Allows us to play sounds directly to people when they join.
void CSEClient(int client, char[] sndName, int TSNDLVL, bool isBGM, int flags, float vol, int pitch) {
  if (!IsValidClient(client)) return;
  if (isBGM && (soundPreference[client] == 1 || soundPreference[client] == 3) || !isBGM && soundPreference[client] >= 2) EmitSoundToClient(client, sndName, _, core.SNDCHAN, TSNDLVL, flags, vol, pitch, _, _, _, _, _);
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
  if (attacker <= MaxClients && IsClientInGame(attacker)) {
    core.bombReset = false;
    core.sacPoints += wasBombReset ? 5 : 1;
    core.sacrificedByClient = false;
    int steamID = GetSteamAccountID(attacker);
    if (!FB_Database || !steamID) return Plugin_Handled;
    char query[256];
    CPrintToChatAll(wasBombReset ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%N {white}has reset the ass! ({limegreen}+5 pts{white})" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%N {white}has sacrificed {blue}%N {white}for the ass! ({limegreen}+1 pt{white})", attacker, client);
    Format(query, sizeof(query), wasBombReset ? "UPDATE ass_activity SET bombsreset = bombsreset + 1, bombsresetsession = bombsresetsession + 1 WHERE steamid = %i;" : "UPDATE ass_activity SET sacrifices = sacrifices + 1, sacrificessession = sacrificessession + 1 WHERE steamid = %i;", steamID);
    FB_Database.Query(Database_FastQuery, query);
  }
  return Plugin_Handled;
}
//Log debug info
void AssLogger(int logLevel, char[] logData) {
  switch (logLevel) {
  case 0: {
    LogMessage("[DEBUG]: %s", logData);
  }
  case 1: {
    LogMessage("[INFO]: %s", logData);
  }
  case 2: {
    LogMessage("[WARN]: %s", logData);
  }
  case 3: {
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
void sudo(int task) {
  Format(LoggerDbg, sizeof(LoggerDbg), "Calling sudo with %i", task);
  AssLogger(0, LoggerDbg);
  switch (task) {
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
    FastFire("OnUser1 rain:Alpha:0:0.0:1");
  }
  //Wave init
  case 2: {
    core.curWave = GetCurWave();
    PerformWaveSetup();
    switch (core.curWave) {
    case 3, 10, 17: {
      core.HWNMax = 360.0;
      for (int i = 8; i < sizeof(WaveSetup) - 3; i++) FastFire(WaveSetup[i]);
      float f = GetRandomFloat(60.0, 180.0);
      CreateTimer(f, TimedOperator, 70);
    }
    case 4, 11, 18: {
      core.HWNMax = 360.0;
      for (int i = 8; i < sizeof(WaveSetup) - 2; i++) FastFire(WaveSetup[i]);
    }
    case 5, 12, 19: {
      core.HWNMax = 260.0;
      core.HWNMin = 140.0;
      for (int i = 8; i < sizeof(WaveSetup) - 2; i++) FastFire(WaveSetup[i]);
      FastFire("OnUser1 w5_engie_hints:Trigger::3.0:1");
      float f = GetRandomFloat(60.0, 180.0);
      CreateTimer(f, TimedOperator, 70);
    }
    case 6, 13, 20: {
      core.HWNMax = 260.0;
      core.HWNMin = 140.0;
      for (int i = 8; i < sizeof(WaveSetup) - 1; i++) FastFire(WaveSetup[i]);
    }
    case 7, 14, 21: {
      core.HWNMax = 240.0;
      core.HWNMin = 120.0;
      for (int i = 8; i < sizeof(WaveSetup); i++) FastFire(WaveSetup[i]);
      FastFire("OnUser1 w5_engie_hints:Trigger::3.0:1");
    }
    case 8, 15: {
      core.HWNMax = 240.0;
      core.HWNMin = 120.0;
      for (int i = 8; i < sizeof(WaveSetup); i++) FastFire(WaveSetup[i]);
    }
    }
    bombState[0].state = DefaultsArray[core.curWave].defBombStatus;
    bombState[0].stateMax = DefaultsArray[core.curWave].defBombStatusMax;
    core.canHWBoss = DefaultsArray[core.curWave].defCanHWBoss;
    core.canTornado = DefaultsArray[core.curWave].defCanTornado;
    core.sacPointsMax = DefaultsArray[core.curWave].defSacPointsMax;
    float hwn = GetRandomFloat(core.HWNMin, core.HWNMax);
    CreateTimer(hwn, HWBosses);
    SetupMusic(core.tacobell ? tacoBellBGMIndex[core.curWave] : DefaultsArray[core.curWave].defBGMIndex);
    return;
  }
  //Force Tornado
  case 3: {
    if (core.isWave && core.canTornado && !core.tornado) {
      CreateTimer(0.1, TimedOperator, 41);
      PrintCenterTextAll("OH NOES... PREPARE YOUR ANUS!");
    } else PrintToServer("Error spawning manual tornado... Perhaps we are not in a wave, tornadoes are banished, or a tornado has already spawned???");
    return;
  }
  //Signal that previous boss should spawn.
  case 4: {
    core.waveFlags--;
  }
  //Signal that a boss should spawn
  case 5: {
    if (core.waveFlags < 0) core.waveFlags = 0;
    switch (core.waveFlags) {
    case 0: {
      PrintToChatAll("Caught unhandled exception: core.waveFlags 0 but operator 5 was invoked.");
      return;
    }
    case 1: {
      FastFire("OnUser1 FB.BruteJusticeTrain:TeleportToPathTrack:tank_path_a_10:0.0:1");
      FastFire("OnUser1 FB.BruteJustice:Enable::3.0:1");
      FastFire("OnUser1 FB.BruteJusticeTrain:StartForward::3.0:1");
      FastFire("OnUser1 FB.BruteJusticeParticles:Start::3.0:1");
      CreateTimer(5.0, OnslaughterATK);
      FastFire("OnUser1 tank_boss:AddOutput:rendermode 10:3.0:1");
      FastFire("OnUser1 tank_boss:AddOutput:rendermode 10:7.0:1");
      CreateTimer(10.0, BossHPTimer);
    }
    case 2: {
      FastFire("OnUser1 FB.Sephiroth:Enable::0.0:1");
      FastFire("OnUser1 SephMeteor:SetParent:FB.Sephiroth:0.0:1");
      FastFire("OnUser1 SephTrain:SetSpeedReal:12:0.0:1");
      FastFire("OnUser1 SephTrain:TeleportToPathTrack:Seph01:0.0:1");
      FastFire("OnUser1 SephTrain:StartForward::0.1:1");
      FastFire("OnUser1 SephTrain:SetSpeedReal:12:20.5:1");
      FastFire("OnUser1 FB.SephParticles:Start::3.0:1");
      FastFire("OnUser1 tank_boss:AddOutput:rendermode 10:3.0:1");
      FastFire("OnUser1 tank_boss:AddOutput:rendermode 10:7.0:1");
      FastFire("OnUser1 FB.BruteJusticeDMGRelay:Kill::0.0:1");
      switch (GetClientCount(true)) {
      case 1: {
        FastFire("OnUser1 SephTrain:SetSpeedReal:40:23.0:1");
        FastFire("OnUser1 tank_boss:SetHealth:409600:1.0:1");
        FastFire("OnUser1 FB.SephDMGRelay:SetHealth:32768000:1.0:1");
      }
      case 2: {
        FastFire("OnUser1 SephTrain:SetSpeedReal:35:23.0:1");
        FastFire("OnUser1 tank_boss:SetHealth:614400:1.0:1");
        FastFire("OnUser1 FB.SephDMGRelay:SetHealth:32768000:1.0:1");
      }
      case 3: {
        FastFire("OnUser1 SephTrain:SetSpeedReal:35:23.0:1");
        FastFire("OnUser1 tank_boss:SetHealth:614400:1.0:1");
        FastFire("OnUser1 FB.SephDMGRelay:SetHealth:131072000:1.0:1");
      }
      case 4: {
        FastFire("OnUser1 SephTrain:SetSpeedReal:30:23.0:1");
        FastFire("OnUser1 tank_boss:SetHealth:819200:1.0:1");
        FastFire("OnUser1 FB.SephDMGRelay:SetHealth:262144000:1.0:1");
      }
      case 5, 6, 7, 8, 9, 10: {
        FastFire("OnUser1 SephTrain:SetSpeedReal:25:23.0:1");
        FastFire("OnUser1 tank_boss:SetHealth:819200:1.0:1");
        FastFire("OnUser1 FB.SephDMGRelay:SetHealth:655360000:1.0:1");
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
    FastFire("OnUser1 FB.FakeTankSpawner:ForceSpawn:0.1:1");
  }
  //Client was Sacrificed.
  case 10: {
    core.sacrificedByClient = true;
  }
  //Damage relay took damage
  case 11: {
    FastFire("OnUser1 TankRelayDMG:Enable:0.0:1");
    FastFire("OnUser1 TankRelayDMG:Disable:0.5:1");
  }
  //dmg relay was killed
  case 12: {
    FastFire("OnUser1 tank_boss:SetHealth:1:0.0:1");
    FastFire("OnUser1 TankRelayDMG:Enable:0.1:1");
    FastFire("OnUser1 TankRelayDMG:Enable:0.5:1");
    FastFire("OnUser1 TankRelayDMG:Enable:1.0:1");
    FastFire("OnUser1 TankRelayDMG:Disable:60.0:1");
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
      FastFire("OnUser1 TankRelayDMG:Enable:1.0:1");
      FastFire("OnUser1 TankRelayDMG:Disable:60.0:1");
      FastFire("OnUser1 FB.BruteJustice:Disable:0.0:1");
      FastFire("OnUser1 FB.BruteJusticeTrain:Stop:0.0:1");
      FastFire("OnUser1 FB.BruteJusticeParticles:Stop:0.0:1");
      FastFire("OnUser1 FB.BruteJusticeDMGRelay:Break:0.0:1");
      FastFire("OnUser1 FB.BruteJusticeTrain:TeleportToPathTrack:tank_path_a_10:0.5:1");
      core.waveFlags = 0;
      core.sacPoints += 25;
    }
    case 2: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}SEPHIROTH {white}has been destroyed. ({limegreen}+100 pts{white})");
      FastFire("OnUser1 TankRelayDMG:Enable:1.0:1");
      FastFire("OnUser1 TankRelayDMG:Disable:60.0:1");
      FastFire("OnUser1 FB.Sephiroth:Disable:0.0:1");
      FastFire("OnUser1 SephTrain:TeleportToPathTrack:Seph01:0.0:1");
      FastFire("OnUser1 SephTrain:Stop:0.0:1");
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
    FastFire("OnUser1 FB.PayloadWarning:Disable:0.0:1");
    if (!core.isWave) return;
    if (bombState[0].state == 69) {
      bombState[7].explode(false);
      bombState[0].stateMax = 64;
      CreateTimer(5.0, TimedOperator, 99);
    }
    bombState[bombState[0].getCurBomb()].explode(true);
    bombState[0].stateMax += 10;
    if (bombState[0].state >= bombState[0].stateMax) return;
    else bombState[0].state += 2;
    return;
  }
  //Tank deployed its bomb
  case 16: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A tank has deployed its bomb! ({limegreen}+1 pt{white})");
  }
  //Shark Enable & notify bomb push began
  case 20: {
    bombState[0].isMoving = true;
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Bomb push in progress.");
    FastFire("OnUser1 FB.PayloadWarning:Enable:0.0:1");
    CreateTimer(3.0, SharkTimer);
  }
  //Shark Disable
  case 21: {
    bombState[0].isMoving = false;
    core.canSENTShark = false;
  }
  //HINDENBOOM ACTIVATION
  case 28: {
    EmitSoundToAll(SFXArray[5]);
    FastFire("OnUser1 HindenTrain:StartForward:0.0:1");
    FastFire("OnUser1 DeliveryBurg:Lock:0.0:1");
    FastFire("OnUser1 Boom:Enable:0.0:1");
    FastFire("OnUser1 Bombs.TheHindenburg:Enable:0.0:1");
    FastFire("OnUser1 Boom:Disable:1.0:1");
  }
  //HINDENBOOM!!!
  case 29: {
    CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}OH GOD, THEY'RE {red}CRASHING THE HINDENBURG{white}!!!");
    EmitSoundToAll(SFXArray[36]);
    CreateTimer(4.0, TimedOperator, 21);
    CreateTimer(7.0, TimedOperator, 37);
    FastFire("OnUser1 LargeExplosion:Explode:7.0:1");
    FastFire("OnUser1 LargeExploShake:StartShake:7.0:1");
    FastFire("OnUser1 NukeAll:Enable:7.0:1");
    FastFire("OnUser1 FB.Fade:Fade:7.0:1");
    FastFire("OnUser1 NukeAll:Disable:9.0:1");
    FastFire("OnUser1 Bombs.TheHindenburg:Disable:7.0:1");
    FastFire("OnUser1 HindenTrain:TeleportToPathTrack:Hinden01:7.0:1");
    FastFire("OnUser1 HindenTrain:Stop:7.0:1");
    CreateTimer(8.0, TimedOperator, 99);
    bombState[0].state = 4;
    bombState[0].stateMax = 8;
  }
  //Bath Salts spend
  case 30: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}INSTANT BATH SALT DETONATION! BOTS ARE FROZEN FOR 10 SECONDS! ({red}-10 pts{white})");
    ServerCommand("sm_freeze @blue 10");
    core.sacPoints -= 10;
    bombState[3].explode(false);
  }
  //Goob/Kirb spend
  case 31: {
    int i = GetRandomInt(1, 2);
    if (i == 1) CreateTimer(1.5, TimedOperator, 21);
    FastFire(i == 1 ? "OnUser1 FB.GiantGoobTemplate:ForceSpawn::0.0:1" : "OnUser1 FB.BlueKirbTemplate:ForceSpawn::0.0:1");
    CPrintToChatAll(i == 1 ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}GOOBBUE COMING IN FROM ORBIT! ({red}-20 pts{white})" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}BLUE KIRBY FALLING OUT OF THE SKY! ({red}-20 pts{white})");
    CustomSoundEmitter(i == 1 ? SFXArray[51] : SFXArray[21], 65, false, 0, 1.0, 100);
    core.sacPoints -= 20;
  }
  //35K ubup cash spend
  case 32: {
    if (!core.doFailsafe) {
      core.doFailsafe = true;
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave fail-safe activated! ({red}-30 pts{white})");
      core.sacPoints -= 30;
    } else return;
  }
  //Explosive paradise spend
  case 33: {
    CustomSoundEmitter(SFXArray[10], 65, false, 0, 1.0, 100);
    FastFire("OnUser1 FB.FadeBLCK:Fade:0.0:1");
    ServerCommand("sm_evilrocket @blue");
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}We're spending most our lives living in an EXPLOSIVE PARADISE! Robots will be launched into orbit, too! ({red}-40 pts{white})");
    //Add this to explosion array?
    FastFire("OnUser1 NukeAll:Enable:11.50:1");
    FastFire("OnUser1 HUGEExplosion:Explode:11.50:1");
    FastFire("OnUser1 FB.Fade:Fade:11.50:1");
    FastFire("OnUser1 FB.ShakeBOOM:StartShake:11.50:1");
    FastFire("OnUser1 NukeAll:Disable:12.30:1");
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
    FastFire("OnUser1 HurtAll:AddOutput:damagetype 524288:0.0:1");
    FastFire("OnUser1 FB.ShakeBOOM:StartShake:0.1:1");
    FastFire("OnUser1 HurtAll:AddOutput:damage 400:0.0:1");
    FastFire("OnUser1 HurtAll:Enable:0.1:1");
    FastFire("OnUser1 HurtAll:Disable:4.1:1"); //Add a sound to this in the future. Maybe gas sound from gbombs? Maybe custom fart sounds? hmm....
    FastFire("OnUser1 FB.ShakeBOOM:StopShake:4.1:1");
  }
  //Nuclear fallout spend
  case 36: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}INSTANT FAT MAN DETONATION! ({red}-70 pts{white})");
    core.sacPoints -= 70;
    bombState[7].explode(false);
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
    bombState[0].stateMax = 69;
    bombState[0].state = 69;
    FastFire("OnUser1 Delivery:Unlock:0.0:1");
    FastFire("OnUser1 BombExplo*:Disable:0.0:1");
    FastFire("OnUser1 Bombs*:Disable:0.0:1");
    FastFire("OnUser1 Bombs.Professor:Enable:3.0:1");
  }
  //Found blue ball
  case 40: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}What on earth IS that? It appears to be a... \x075050FFBLUE BALL{white}!");
    CustomSoundEmitter(SFXArray[21], 65, false, 0, 1.0, 100);
    FastFire("OnUser1 FB.BlueKirbTemplate:ForceSpawn:4.0:1");
    CreateTimer(4.0, TimedOperator, 21);
  }
  //Found burrito
  case 41: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Why would you even eat {red}The Forbidden Burrito{white}?");
    CustomSoundEmitter("vo/sandwicheat09.mp3", 65, false, 0, 1.0, 100);
    FastFire("OnUser1 HurtAll:AddOutput:damagetype 8:0.0:1");
    FastFire("OnUser1 HurtAll:AddOutput:damage 2000:0.0:1");
    FastFire("OnUser1 HurtAll:Enable:4.0:1");
    FastFire("OnUser1 HurtAll:Disable:8.0:1");
  }
  //Found goobbue
  case 42: {
    CustomSoundEmitter(SFXArray[51], 65, false, 0, 1.0, 100);
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}ALL HAIL \x07FF00FFGOOBBUE{forestgreen}!");
    CreateTimer(4.0, TimedOperator, 21);
    FastFire("OnUser1 FB.GiantGoobTemplate:ForceSpawn::4.0:1");
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
    //Yup, another one for the explosion array
    FastFire("OnUser1 HurtAll:AddOutput:damagetype 262144:10.0:1");
    FastFire("OnUser1 HurtAll:AddOutput:damage 2000000:0.0:1");
    FastFire("OnUser1 FB.ShakeBOOM:StartShake:10.3:1");
    FastFire("OnUser1 HUGEExplosion:Explode:10.3:1");
    FastFire("OnUser1 FB.Fade:Fade:10.3:1");
    FastFire("OnUser1 HurtAll:Enable:10.3:1");
    FastFire("OnUser1 HurtAll:Disable:12.3:1");
  }
  //Medium Explosion (defined again, but we aren't using a bomb this time)
  case 51: {
    CustomSoundEmitter(SFXArray[3], 65, false, 0, 1.0, 100);
  }
  //Probably for the hindenburg... EDIT: NOPE. THIS IS FOR KIRB LANDING ON THE GROUND
  case 52: {
    EmitSoundToAll(SFXArray[35]);
    FastFire("OnUser1 FB.BOOM:StartShake:0.0:1");
    FastFire("OnUser1 BlueBall*:Kill:0.0:1");
    FastFire("OnUser1 HUGEExplosion:Explode:0.0:1");
    FastFire("OnUser1 BlueKirb:Kill:0.0:1");
    FastFire("OnUser1 HurtAll:AddOutput:damagetype 32768:0.0:1");
    FastFire("OnUser1 HurtAll:AddOutput:damage 666666.667:0.0:1");
    FastFire("OnUser1 HurtAll:Enable:0.1:1");
    FastFire("OnUser1 HurtAll:Disable:2.1:1");
  }
  //Giant Goobbue
  case 53: {
    EmitSoundToAll(SFXArray[35]);
    FastFire("OnUser1 FB.BOOM:StartShake:0.0:1");
    FastFire("OnUser1 GiantGoob*:Kill:0.0:1");
    FastFire("OnUser1 HUGEExplosion:Explode:0.0:1");
    FastFire("OnUser1 HurtAll:AddOutput:damagetype 1048576:0.0:1");
    FastFire("OnUser1 HurtAll:AddOutput:damage 666666.667:0.0:1");
    FastFire("OnUser1 HurtAll:Enable:0.1:1");
    FastFire("OnUser1 HurtAll:Disable:2.1:1");
  }
  //Prev wave
  case 98: {
    int prev_wave = GetCurWave() - 1;
    if (prev_wave < 1) return;
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
      FastFire("OnUser1 FB.BOOM:StartShake:0.0:1");
      CustomSoundEmitter(SFXArray[3], 65, false, 0, 1.0, 100);
      FastFire("OnUser1 FB.CodeCorrectKill:Enable:0.0:1");
      FastFire("OnUser1 FB.KP*:Lock:0.0:1");
      FastFire("OnUser1 FB.CodeCorrectKill:Disable:1.0:1");
    } else {
      core.CodeEntry = 0;
      FastFire("OnUser1 FB.CodeFailedKill:Enable::0.0:1");
      FastFire("OnUser1 FB.CodeFailedKill:Disable::1.0:1");
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
  case 200: {
    DispatchCircleAOE(GetRandomFloat(1350.0, 1620.0), GetRandomFloat(-1350.0, -1520.0), -580.0);
  }
  //Taco Bell Edition
  case 210: {
    core.tacobell = true;
    ServerCommand("fb_startmoney 200000");
    CPrintToChatAll("{darkviolet}[{orange}INFO{darkviolet}] {white}You have chosen {red}DOVAH'S ASS - TACO BELL EDITION{white}. Warning: All upgrade progress will be lost if you fail the wave. DO NOT FAIL US.");
  }
  //Reset Map
  case 300: {
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
    bombState[0].stateMax = 7;
    bombState[0].state = 5;
    core.sephiroth = false;
    core.waveFlags = 0;
    bombState[0].isReady = false;
    FastFire("OnUser1 Barricade_Rebuild_Relay:Trigger:0.0:1");
    FastFire("OnUser1 FB.KP*:Lock:0.0:1");
    FastFire("OnUser1 OldSpawn:Disable:0.0:1");
    FastFire("OnUser1 NewSpawn:Enable:0.0:1");
    FastFire("OnUser1 CommonSpells:Disable:0.0:1");
    FastFire("OnUser1 RareSpells:Disable:0.0:1");
    FastFire("OnUser1 dovahsassprefer:Disable:0.0:1");
    FastFire("OnUser1 bombpath_left_arrows:Disable:0.0:1");
    FastFire("OnUser1 bombpath_right_arrows:Disable:0.0:1");
    FastFire("OnUser1 rain:Alpha:0.0:1");
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
    core.BGMINDEX = 9;
    core.shouldStopMusic = true;
  }
  case 501: {
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
    if (StrEqual(BGMArray[core.BGMINDEX].realPath, "null")) return;
    for (int i = 1; i <= MaxClients; i++) {
      StopSound(i, core.SNDCHAN, BGMArray[core.BGMINDEX].realPath);
    }
    return;
  }
  //Feature an admin
  case 1002: {
    char fireString[48];
    int i = GetRandomInt(1, 10);
    if (i == core.lastAdmin) i = GetRandomInt(1, 10);
    Format(fireString, sizeof(fireString), "OnUser1 AdminPicker:SetTextureIndex:%i:0.0:1", i);
    FastFire(fireString);
    core.lastAdmin = i;
    return;
  }
  //Strike Lightning
  case 1003: {
    for (int i = 0; i < sizeof(lightning); i++) FastFire(lightning[i]);
  }
  //Activate Tornado Timer
  case 1004: {
    if (!core.isWave || !core.canTornado) return;
    float f = (core.curWave == 4 ? GetRandomFloat(30.0, 60.0) : GetRandomFloat(210.0, 500.0));
    CreateTimer(f - 30.0, TimedOperator, 40);
    CreateTimer(f, TimedOperator, 41);
  }
  //Despawn the tornado
  case 1005: {
    for (int i = 6; i < 14; i++) FastFire(TornadoLogic[i]);
    core.tornado = false;
    return;
  }
  //Crusader
  case 1006: {
    core.tickMusic = false;
    sudo(1001);
    core.crusader = true;
    CreateTimer(1.75, CRUSADERINCOMING);
    CreateTimer(25.20, TimedOperator, 9);
    CreateTimer(25.20, TimedOperator, 78);
    CreateTimer(42.60, TimedOperator, 10);
    CreateTimer(63.20, TimedOperator, 80);
    PrintToServer("Starting Crusader via plugin!");
    EmitSoundToAll("fartsy/misc/fartsyscrusader_bgm_locus.mp3");
    CreateTimer(80.0, TimedOperator, 79);
    for (int i = 0; i < sizeof(CrusaderBrrr); i++) FastFire(CrusaderBrrr[i]);
  }
  //Choose bomb path
  case 1007: {
    FastFire("OnUser1 Nest_*:Disable:0.0:1");
    FastFire("OnUser1 bombpath_right_prefer_flankers:Disable:0.0:1");
    FastFire("OnUser1 bombpath_left_prefer_flankers:Disable:0.0:1");
    FastFire("OnUser1 bombpath_left_navavoid:Disable:0.0:1");
    FastFire("OnUser1 bombpath_right_navavoid:Disable:0.0:1");
    FastFire("OnUser1 bombpath_right_arrows:Disable:0.0:1");
    FastFire("OnUser1 bombpath_left_arrows:Disable:0.0:1");
    //BombPath[GetRandomInt(0, 2)].activate(); // Currently doesn't work because we act on 4 different targets minimum...
    switch (GetRandomInt(1, 3)) {
    case 1: {
      FastFire("OnUser1 Nest_R*:Enable:0.25:1");
      FastFire("OnUser1 bombpath_right_prefer_flankers:Enable:0.25:1");
      FastFire("OnUser1 bombpath_right_navavoid:Enable:0.25:1");
      FastFire("OnUser1 bombpath_right_arrows:Enable:0.25:1");
    }
    case 2: {
      FastFire("OnUser1 Nest_L*:Enable:0.25:1");
      FastFire("OnUser1 bombpath_left_prefer_flankers:Enable:0.25:1");
      FastFire("OnUser1 bombpath_left_navavoid:Enable:0.25:1");
      FastFire("OnUser1 bombpath_left_arrows:Enable:0.25:1");
    }
    case 3: {
      FastFire("OnUser1 dovahsassprefer:Enable:0.25:1");
      FastFire("OnUser1 Nest_EN*:Enable:0.25:1");
      FastFire("OnUser1 bombpath_right_prefer_flankers:Enable:0.25:1");
      FastFire("OnUser1 bombpath_right_navavoid:Enable:0.25:1");
      FastFire("OnUser1 bombpath_right_arrows:Enable:0.25:1");
    }
    }
  }
  //Monitor power up/down!
  case 1008: {
    core.monitorOn = (!core.monitorOn ? true : false);
    FastFire(!core.monitorColor && core.monitorOn ? "OnUser1 FB.MonitorSprite:Color:0 0 255:0.0:1" : core.monitorOn ? "OnUser1 FB.MonitorSprite:Color:0 255 0:0.0:1" : "OnUser1 FB.MonitorSprite:Color:255 0 0:0.0:1");
    FastFire(!core.monitorColor && core.monitorOn ? "OnUser1 FB.MonitorBW:Enable:0.0:1" : core.monitorOn ? "OnUser1 FB.Monitor:Enable:0.0:1" : "OnUser1 FB.Monitor:Disable:0.0:1");
    FastFire(!core.monitorColor && core.monitorOn ? "OnUser1 FB.Monitor:Disable:0.0:1" : core.monitorOn ? "OnUser1 FB.MonitorBW:Disable:0.0:1" : "OnUser1 FB.MonitorBlank:Enable:0.0:1");
    FastFire(core.monitorOn ? "OnUser1 FB.MonitorBlank:Disable:0.0:1" : "OnUser1 FB.MonitorBlank:Enable:0.2:1");
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
    if (core.camSel <= -1) core.camSel = 4;
    FireEntityInput("FB.Monitor", "SetCamera", SelectedCamera[core.camSel], 0.0);
    FireEntityInput("FB.MonitorBW", "SetCamera", SelectedCamera[core.camSel], 0.0);
  }
  //Enable black and white.
  case 1011: {
    if (!core.monitorOn) return;
    core.monitorColor = (!core.monitorColor ? true : false);
    FastFire(!core.monitorColor ? "OnUser1 FB.MonitorSprite:Color:0 255 0:0.0:1": "OnUser1 FB.MonitorSprite:Color:0 0 255:0.0:1");
    FastFire(!core.monitorColor ? "OnUser1 FB.Monitor:Enable:0.0:1" : "OnUser1 FB.MonitorBW:Disable:0.0:1");
    FastFire(!core.monitorColor ? "OnUser1 FB.Monitor:Disable:0.0:1" : "OnUser1 FB.MonitorBW:Enable:0.0:1");
  }
  case 6942: {
    core.sacPoints = 2147483647;
  }
  //Do not EVER EVER execute this unless it's an emergency...
  case 6969: {
    CPrintToChatAll(!core.isWave ? "{darkred} [CORE] ERROR, attempted to invoke function without an active wave." : core.brawler_emergency ? "{darkred}[CORE] Failed to enter emergency mode, it is already active." : "{darkred}[CORE] EMERGENCY MODE ACTIVATED...");
    if (!core.isWave || core.brawler_emergency) return;
    Emerge(0);
  }
  //DEBUG
  case 8000: {
    SephBoss[GetRandomInt(0, 6)].attack();
  }
  case 9000: {
    CreateTimer(10.0, BossHPTimer);
  }
  case 9001: {
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
  for (int i = 0; i < sizeof(WaveSetup) - 4; i++) FastFire(WaveSetup[i]);
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
      CreateTimer(0.0, TimedOperator, 3);
    }
    //Boss script pt 2
    case 3: {
      core.BGMINDEX = 16;
      core.songName = BGMArray[core.BGMINDEX].songName;
      CustomSoundEmitter(BGMArray[core.BGMINDEX].realPath, BGMArray[core.BGMINDEX].SNDLVL, true, 0, 1.0, 100);
      FastFire("OnUser1 FB.FadeTotalBLCK:Fade:0.0:1");
      FastFire("OnUser1 FB.FadeTotalBLCK:Fade:3.0:1");
      FastFire("OnUser1 FB.FadeTotalBLCK:Fade:7.0:1");
      FastFire("OnUser1 FB.FadeTotalBLCK:Fade:12.0:1");
      FastFire("OnUser1 SephMeteor:ForceSpawn:19.6:1");
      CreateTimer(23.0, TimedOperator, 4);
    }
    //Boss script pt 3
    case 4: {
      CustomSoundEmitter(SFXArray[9], 65, false, 0, 1.0, 100);
      CreateTimer(4.1, TimedOperator, 5);
    }
    //Boss script pt 4
    case 5: {
      CustomSoundEmitter(SFXArray[58], 65, false, 0, 1.0, 100);
      FastFire("OnUser1 SephNuke:ForceSpawn:3.0:1");
      CreateTimer(3.2, TimedOperator, 6);
    }
    //Boss script pt 5
    case 6: {
      CustomSoundEmitter(SFXArray[35], 65, false, 0, 1.0, 100);
      FastFire("OnUser1 FB.Fade:Fade:0.0:1");
      CreateTimer(1.0, SephATK);
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
      FastFire("OnUser1 FB.FadeBLCK:Fade::0.0:1");
      CreateTimer(4.8, TimedOperator, 2);
    }
    //Crusader Nuke activation
    case 9: {
      core.canCrusaderNuke = true;
      CreateTimer(1.0, NukeTimer);
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
        EmitSoundToAll("mvm/ambient_mp3/mvm_siren.mp3");
        core.TornadoWarningIssued = true;
      }
      return Plugin_Stop;
    }
    // start tornado
    case 41: {
      if (!core.isWave || !core.canTornado || core.tornado) return Plugin_Stop;
      for (int i = 0; i < 6; i++) FastFire(TornadoLogic[i]);
      core.tornado = true;
      float f = GetRandomFloat(60.0, 120.0);
      CreateTimer(f, TimedOperator, 42);
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
    case 6969: {
      if (!core.isWave){
        ExitEmergencyMode();
        return Plugin_Stop;
      }
      BEM++;
      Emerge(BEM);
      return Plugin_Stop;
    }
    }
    return Plugin_Stop;
}

//Setup music, this allows us to change it with VIP access...
public void SetupMusic(int bgm) {
  core.bgmPlaying = true;
  core.ticksMusic = -2;
  core.refireTime = 2;
  core.tickMusic = true;
  core.tickOffset = false;
  core.BGMINDEX = (core.VIPBGM >= 0 ? core.VIPBGM : bgm);
  core.shouldStopMusic = (!StrEqual(core.cachedPath, BGMArray[core.BGMINDEX].realPath) ? true : false);
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
  for (int i = 0; i < sizeof(BGMArray); i++) menu.AddItem(buffer, BGMArray[i].songName);
  menu.Display(client, 20);
  menu.ExitButton = true;
}

// VIP Music Menu
public int MenuHandlerFartsyMusic(Menu menu, MenuAction action, int client, int bgm) {
  if (action == MenuAction_Select) {
    core.curWave = GetCurWave();
    CPrintToChat(client, (bgm == 0 ? "{darkgreen}[CORE] Confirmed. Next song set to {aqua}Default{darkgreen}." : "{limegreen}[CORE] Confirmed. Next song set to {aqua}%s{limegreen}."), BGMArray[bgm].songName);
    core.BGMINDEX = (bgm == 0 ? (core.tacobell ? tacoBellBGMIndex[core.curWave] : core.sephiroth ? 16 : core.isWave ? DefaultsArray[core.curWave].defBGMIndex : GetRandomInt(1, 4)) : bgm);
    core.shouldStopMusic = (!StrEqual(core.cachedPath, BGMArray[bgm].realPath) ? true : false);
    core.VIPBGM = (bgm == 0 ? -1 : bgm);
    core.VIPIndex = client;
  } else if (action == MenuAction_End) CloseHandle(menu);
  return 0;
}

//Track and update client health
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
  }
  if (GetClientCount(true) == 0) {
    AssLogger(1, "Server is empty. Music queue stopped.");
    core.bgmPlaying = false;
    core.tickingClientHealth = false;
    core.tickMusic = false;
    core.BGMINDEX = GetRandomInt(1, 4);
    core.shouldStopMusic = false;
    core.refireTime = 0;
    core.ticksMusic = 0;
    return Plugin_Stop;
  }
  CreateTimer(1.0, TickClientHealth);
  return Plugin_Stop;
}
//Get current wave
public int GetCurWave() {
  int ent = FindEntityByClassname(-1, "tf_objective_resource");
  if (ent != -1) return GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
  AssLogger(3, "tf_objective_resource not found");
  return -1;
}