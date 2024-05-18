// Clockwork Castletown v1.0.0 by Professor Fartsalot for the FireHost Redux Community
#include <clientprefs>
#include <fcc_helper>
#include <morecolors>
#include <regex>
#include <sdktools>
#include <sourcemod>
#include <tf2_stocks>
#pragma newdecls required
#pragma semicolon 1
static char PLUGIN_VERSION[8] = "1.0.5";

public Plugin myinfo = {
  name = "Fartsy's Clockwork Chaos - Framework",
  author = "Fartsy",
  description = "Framework for Fartsy's Clockwork Chaos (PL Mods)",
  version = PLUGIN_VERSION,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart() {
  FccLogger(1, "####### STARTUP SEQUENCE INITIATED... PREPARE FOR THE END TIMES #######");
  RegisterAndPrecacheAllFiles();
  RegisterAllCommands();
  SetupCoreData();
  CPrintToChatAll("{darkred}Plugin Reloaded. If you do not hear music, please do !sounds and configure your preferences.");
  // cvarSNDDefault = CreateConVar("sm_fartsyscc_sound", "3", "Default sound for new users, 3 = Everything, 2 = Sounds Only, 1 = Music Only, 0 = Nothing");
  // SetCookieMenuItem(FartsysSNDSelected, 0, "Fartsys Clockwork Chaos Sound Preferences");
  Format(LoggerInfo, sizeof(LoggerInfo), "####### STARTUP COMPLETE (v%s) #######", PLUGIN_VERSION);
  FccLogger(1, LoggerInfo);
}

// Music system, see FartsysAss.sp:46
public void OnGameFrame() {
  /*  if (core.tickMusic) {
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
    }*/
}


// Restart music for the new client
public Action RefireMusicForClient(Handle timer, int client) {
  if (IsValidClient(client)) {
    //    if (GetClientTeam(client) == 0) CreateTimer(1.0, RefireMusicForClient, client);
    //    else if (GetClientTeam(client) == 2) CSEClient(client, BGMArray[core.BGMINDEX].realPath, BGMArray[core.BGMINDEX].SNDLVL, true, 1, 1.0, 100);
  }
  return Plugin_Stop;
}

// Queue music for new clients, also track their health.
public void OnClientPostAdminCheck(int client) {
  //  if (!IsFakeClient(client) && core.bgmPlaying) CreateTimer(1.0, RefireMusicForClient, client);
  int steamID = GetSteamAccountID(client);
  if (!steamID || steamID <= 10000) return;
  //  if (!core.bgmPlaying) SetupMusic(GetRandomInt(1, 4)); //Change these variables, I have no idea how this should work at the moment.
}

// Now that command definitions are done, lets make some things happen.
public void OnMapStart() {
  //  CreateTimer(1.0, SelectAdminTimer);
  //  FastFire("OnUser1 rain:Alpha:0:0.0:1");
  //  sudo(1002);
}

// Adverts for round information
public Action PerformMatchAdverts(Handle timer) {
  //  if (core.isMatch) {
  char buffer[16];
  char tbuffer[16];
  char HintText[256];
  //    int sPos = RoundToFloor(core.ticksMusic / 66.6666666666);
  //    int tPos = RoundToFloor(core.refireTime / 66.6666666666);
  //    Format(buffer, 16, "%02d:%02d", sPos / 60, sPos % 60);
  //    Format(tbuffer, 16, "%02d:%02d", tPos / 60, tPos % 60);
  // Format(HintText, sizeof(HintText), (bombState[0].isMoving ? "Payload: MOVING (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)" : bombState[0].isReady ? "Payload: READY (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)" : "Payload: PREPARING (%i/%i) | !sacpoints: %i/%i \n Music: %s (%s/%s)"), bombState[0].state, bombState[0].stateMax, core.sacPoints, core.sacPointsMax, core.songName, buffer, tbuffer);
  //    CreateTimer(2.5, PerformMatchAdverts);
  for (int i = 1; i <= MaxClients; i++) {
    if (IsValidClient(i)) {
      PrintHintText(i, HintText);
      StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
    }
  }
  //}
  return Plugin_Stop;
}

// Command: Get current song
public Action Command_GetCurrentSong(int client, int args) {
  /*char buffer[16];
  char tbuffer[16];
  int sPos = RoundToFloor(core.ticksMusic / 66.6666666666);
  int tPos = RoundToFloor(core.refireTime / 66.6666666666);
  Format(buffer, 16, "%02d:%02d", sPos / 60, sPos % 60);
  Format(tbuffer, 16, "%02d:%02d", tPos / 60, tPos % 60);
  CPrintToChat(client, "The current song is: {limegreen}%s {orange}(%s / %s)", core.songName, buffer, tbuffer);*/
  return Plugin_Handled;
}

// Command: Return the client to spawn
public Action Command_Return(int client, int args) {
  if (!IsPlayerAlive(client)) {
    CPrintToChat(client, "{red}[Core] You must be alive to use this command...");
    return Plugin_Handled;
  }
  char name[128];
  GetClientName(client, name, sizeof(name));
  CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Client {red}%s {white}began casting {darkviolet}/return{white}.", name);
  //  CustomSoundEmitter(SFXArray[41], 65, false, 0, 1.0, 100);
  CreateTimer(5.0, ReturnClient, client);
  return Plugin_Handled;
}

// Return the client to spawn
public Action ReturnClient(Handle timer, int clientID) {
  //  TeleportEntity(clientID, Return, NULL_VECTOR, NULL_VECTOR);
  // CSEClient(clientID, SFXArray[42], 65, false, 0, 1.0, 100);
  return Plugin_Handled;
}

// Join us on Discord!
public Action Command_Discord(int client, int args) {
  CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Our Discord server URL is {darkviolet}https://discord.com/invite/HjQsDy6e2H{white}.");
  ShowMOTDPanel(client, "FireHostRedux Discord", "https://discord.com/invite/HjQsDy6e2H", MOTDPANEL_TYPE_URL);
  return Plugin_Handled;
}

// Check who died by what and announce it to chat.
/*
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
        switch (damagebits){
            case 1:{

            }
        }
    }
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
}*/

// Create a temp entity and fire an input - ADVANCED Mode
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

// Custom sound emitter, I don't know how many fucking times I've rewritten this! See potato.sp
// int flags:
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
    //    if (isBGM && (soundPreference[i] == 1 || soundPreference[i] == 3) || !isBGM && soundPreference[i] >= 2) EmitSoundToClient(i, sndName, _, core.SNDCHAN, TSNDLVL, flags, vol, pitch, _, _, _, _, _);
  }
}
// Play sound to client. Ripped straight from potato. Allows us to play sounds directly to people when they join.
void CSEClient(int client, char[] sndName, int TSNDLVL, bool isBGM, int flags, float vol, int pitch) {
  if (!IsValidClient(client)) return;
  //  if (isBGM && (soundPreference[client] == 1 || soundPreference[client] == 3) || !isBGM && soundPreference[client] >= 2) EmitSoundToClient(client, sndName, _, core.SNDCHAN, TSNDLVL, flags, vol, pitch, _, _, _, _, _);
}

// Remove edict allocated by temp entity
public Action DeleteEdict(Handle timer, any entity) {
  if (IsValidEdict(entity)) RemoveEdict(entity);
  return Plugin_Stop;
}

// Log debug info
void FccLogger(int logLevel, char[] logData) {
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

// Operator, core of the entire map
public Action Command_Operator(int args) {
  char arg1[16];
  GetCmdArg(1, arg1, sizeof(arg1));
  int x = StringToInt(arg1);
  PrintToServer("Directly calling sudo with %i", args);
  sudo(x);
  return Plugin_Continue;
}

void sudo(int task) {
  Format(LoggerDbg, sizeof(LoggerDbg), "Calling sudo with %i", task);
  FccLogger(0, LoggerDbg);
  switch (task) {
    // Match End, pick winning team based on distance
    case 0: {
      FastFire(PLR > PLB ? "OnUser1 WinRed:RoundWin::0.0:1" : PLR < PLB ? "OnUser1 WinBlu:RoundWin::0.0:1" : "OnUser1 WinStalemate:RoundWin::0.0:1");
      return;
    }
    // Setup Begin
    case 1: {
      FccLogger(0, "Setup beginning....");
      FastFire("OnUser1 PL1.TrackTrain:Stop::0.5:1");
      FastFire("OnUser1 UI.PLCore:SwitchOverlay:1::0.0:1");
      FastFire("OnUser1 UI.PLBlue00:SwitchOverlay:1::0.0:1");
      FastFire("OnUser1 UI.PLBlue01:SwitchOverlay:1::0.0:1");
      FastFire("OnUser1 UI.PLBlue02:SwitchOverlay:1::0.0:1");
      if(RecedeTimer != INVALID_HANDLE) KillTimer(RecedeTimer);
      isMatch = true;
      PLB = 0;
      PLL = 0;
      PLM = false;
      PLR = 0;
      PLT = "N/A";
      PLRL = 20;
      BLC = false;
      REC = false;
      RECEDE = false;
      CreateTimer(0.5, PayloadUpdateTimer);
      CPrintToChatAll("{darkgreen} Clockwork Castletown ({lime}v%s{darkgreen}) - Escort the crystal the longest distance to win!", PLUGIN_VERSION);
      return;
    }
    // Setup End / round start
    case 2: {
      FccLogger(1, "Match started!");
      return;
    }
    case 3: {
      // Payload started moving by blue
      PLT = "BLU";
      PLM = true;
      FastFire("OnUser1 PL1.TrackTrain:StartForward::0.0:1");
      KillTimer(RecedeTimer);
      RecedeTimer = INVALID_HANDLE;
      RECEDE = false;
      return;
    }
    // Payload started moving by red
    case 4: {
      PLT = "RED";
      PLM = true;
      FastFire("OnUser1 PL1.TrackTrain:StartBackward::0.0:1");
      KillTimer(RecedeTimer);
      RecedeTimer = INVALID_HANDLE;
      RECEDE = false;
      return;
    }
    // Payload stopped moving
    case 5: {
      PLT = "NEUTRAL";
      PLM = false;
      FastFire("OnUser1 PL1.TrackTrain:Stop::0.0:1");
      RecedeTimer = CreateTimer(45.0, BeginRecede, PLL);
      return;
    }
    // Payload on blue side of map
    case 6: {
      PLL = 2;
      return;
    }
    // Payload red side of map
    case 7: {
      PLL = 1;
      return;
    }
    // Point 1 capture (this would be 75% capture from blue's perspective)
    case 8: {
      FastFire("OnUser1 PL4.CP:SetOwner:3:0.0:1"); //Change this to instead enable a capture area, stop the payload and disable capture area while the CP is capturing.. Re enable it after 15s. Check if blue is pushing and not receding.
      return;
    }
    // Point -1 capture (this would be 75% capture from red's perspective)
    case 9: {
      FastFire("OnUser1 PL2.CP:SetOwner:2:0.0:1"); // see case 8
      return;
    }
    // Op codes for payload progression
    case 10: {
      PrintToServer("Got 10, PLL %i", PLL);
      switch(PLL){
        case 1:{
          PrintToChatAll("DEBUG: Checking if RECEDE: %b STREQUAL PLT RED: %b, PLB %i < PLPOS %i PLRL: %i...", RECEDE, StrEqual(PLT, "RED"), PLB, PLPOS[PLRL], PLRL);
          if(RECEDE || StrEqual(PLT, "RED")) PLRL--; //If it's receding back to mid or being pushed by red back to mid... This is occuring on red's side of the map.
          else PLRL++;//It's moving forward by blue to red.
          if(PLB < PLPOS[PLRL]){
            PLB+=5;
            FastFire("OnUser1 test:scorebluepoints::0.0:1");
          }
          return;
        }
        case 2:{
          PrintToChatAll("DEBUG: Checking if RECEDE: %b STREQUAL PLT BLU: %b, PLR %i < PLPOS %i PLRL: %i...", RECEDE, StrEqual(PLT, "BLU"), PLR, PLPOS[PLRL], PLRL);
          if(RECEDE || StrEqual(PLT, "BLU")) PLRL++; //If it's receding back to mid or being pushed by blu back to mid... this is occuring on blu's side of the map.
          else PLRL--; //It's moving forward by red to blue.
          if(PLR < PLPOS[PLRL]){
            PLR+=5;
            FastFire("OnUser1 test:scoreredpoints::0.0:1");
          }
          return;
        }
      }
//      PrintToChatAll("BLU %i% RED %i%, PLM: %b, PLL: %i, PLT: %s", PLB, PLR, PLM, PLL, PLT);
      return;
    }
    //Blu reached end of track (FF)
    case 11: {
        //FastFire("OnUser1 WinBlu:RoundWin::0.0:1"); //Change this to instead enable a capture area, stop the payload, and disable payload capture area while the CP is capturing... Victory after 15s (onCapTeam2)
    }
    //Red reached end of track (00)
    case 12:{
        //FastFire("OnUser1 WinRed:RoundWin::0.0:1"); //Change this, see case 11...
    }
    //Payload reached neutral point
    case 13:{
        PLT = "N/A";
        PLL = 0;
        PLM = false;
        RECEDE = false;
        PLRL = 20;
        FastFire("OnUser1 PL1.TrackTrain:Stop::0.0:1");
    }
    //Debug
    case 42:{
      PLR+=5;
      return;
    }
    case 69:{
      PLB +=5;
      return;
    }
  }
}

// Recede payload after 45 seconds
public Action BeginRecede(Handle timer, int side) {
  if (side > 0) FastFire(side == 1 ? "OnUser1 PL1.TrackTrain:StartBackward::0.0:1" : "OnUser1 PL1.TrackTrain:StartForward::0.0:1");
  RECEDE = true;
  return Plugin_Stop;
}

// Show payload state
public Action PayloadUpdateTimer(Handle timer){
  if(!isMatch) return Plugin_Stop;
  CCH[30].BLU = BLC ? "hud/cconflict/cc_blu0B" : "hud/cconflict/cc_blu0A";
  CCH[10].RED = REC ? "hud/cconflict/cc_red20" : "hud/cconflict/cc_red1F";
  char state[64];
  Format(state, sizeof(state), StrEqual(PLT, "BLU") ? CCH[PLRL].BLU : StrEqual(PLT, "RED") ? CCH[PLRL].RED :  RECEDE ? CCH[PLRL].NEUTRAL : CCH[PLRL].IDLE);
  ShowOverlayAll(state);
  PrintToServer(state);
  CreateTimer(0.5, PayloadUpdateTimer);
  return Plugin_Stop;
}
