#include <morecolors>
#include <sdktools>
#include <sourcemod>
#pragma newdecls required
bool isTankAlive = false;
bool tankDeploy = false;
char charHP[16];
char tankStatus[128];
static char CANNONECHO[32] = "fartsy/brawler/cannon_echo.mp3"; //MAKE ME EXIST PLS AND ADD ME (AS WELL AS THE KISSONE TANK MATERIALS) TO PAKINCLUDE FOR POTATO
static char COUNTDOWN[32] = "fartsy/misc/countdown.wav";
static char PLG_VER[8] = "1.1.4";
static int LOG_CORE = 0;
static int LOG_INFO = 1;
static int LOG_DBG = 2;
static int LOG_ERR = 3;
static int BGMSNDLVL = 95;
static int SNDCHAN = 6;
static char TSPWN[32] = "fartsy/misc/brawler/pl_tank.mp3";
static char TBGM0[16] = "test/bgm0.mp3";
static char TBGM1[16] = "test/bgm1.mp3";
static char TBGM3[16] = "test/bgm3.mp3";
static char TBGM4[16] = "test/bgm4.mp3";
static char TBGM5[16] = "test/bgm5.mp3";
static char TBGM6[16] = "test/bgm6.mp3";
int failCount = 0;

public Plugin myinfo = {
  author = "Fartsy",
  description = "Don't worry about it...",
  version = PLG_VER,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart() {
  PrecacheSound(TSPWN, true);
  PrecacheSound(TBGM0, true);
  PrecacheSound(TBGM1, true);
  PrecacheSound(TBGM3, true);
  PrecacheSound(TBGM4, true);
  PrecacheSound(TBGM5, true);
  PrecacheSound(TBGM6, true);
  PrecacheSound(COUNTDOWN, true);
  PrecacheSound(CANNONECHO, true);
  RegServerCmd("fb_operator", Command_Operator, "Server-side only. Does nothing when excecuted as client.");
}

//Operator, handle all map requests
public Action Command_Operator(int args) {
  char arg1[16];
  GetCmdArg(1, arg1, sizeof(arg1));
  int x = StringToInt(arg1);
  switch (x) {
  //Red Win
  case 0: {
    PrintToChatAll("RED WON.");
    FireEntityInput("WinRed", "RoundWin", "", 0.0);
  }
  //Blu Win
  case 1: {
    PrintToChatAll("BLUE WON.");
  }
  //Round Start
  case 2: {
    ServerCommand("fb_operator 100");
  }
  //PL1 Deployed, spawn tank
  case 3: {
    CustomSoundEmitter(TSPWN, BGMSNDLVL, false, 0, 1.0, 100, 0);
    FireEntityInput("PL1.Const", "Break", "", 0.0);
    FireEntityInput("PL1.CaptureArea", "Disable", "", 0.0);
    FireEntityInput("PL.RoundTimer", "AddTeamTime", "3 300", 0.0);
    FireEntityInput("PL1.CaptureArea", "CaptureCurrentCP", "", 0.0);
    FireEntityInput("PL1.CP", "SetOwner", "3", 0.0);
    FireEntityInput("PL1.Track0*", "Kill", "", 0.0);
    FireEntityInput("PL1.Track10", "Kill", "", 0.0);
    FireEntityInput("PL1.Track11", "Kill", "", 0.0);
    FireEntityInput("PL1.Track12", "Kill", "", 0.0);
    FireEntityInput("PL1.Track13", "Kill", "", 0.0);
    FireEntityInput("PL1.Track14", "Kill", "", 0.0);
    FireEntityInput("PL1.Track15", "Kill", "", 0.0);
    FireEntityInput("PL1.Track16", "Kill", "", 0.0);
    FireEntityInput("PL.WatcherA", "SetTrainCanRecede", "0", 0.0);
    FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track17", 0.1);
    FireEntityInput("PL1.TrackTrain", "Stop", "", 0.1);
    FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL2.CP", 1.0);
    FireEntityInput("PL1.TankMaker", "ForceSpawn", "", 5.0);
    CreateTimer(1.0, TimedOperator, 0);
  }
  //PL2 (Tank) started push
  case 4: {
    isTankAlive = true;
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "69", 0.0);
    FireEntityInput("PL.WatcherA", "SetSpeedForwardModifier", "0.5", 0.0);
    CreateTimer(7.0, TankPingTimer);
  }
  //PL2 (Tank) Killed
  case 5: {
    if (tankDeploy) {
      isTankAlive = false;
      return Plugin_Stop;
    } else {
      isTankAlive = false;
      FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
      FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track17", 0.0);
      FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
      FireEntityInput("PL1.Track40", "DisableAlternatePath", "", 0.0);
      CreateTimer(5.0, TimedOperator, 1); //Spawn new tank, possibly with higher health?
    }
  }
  //PL2 (Tank) Requested to Deploy
  case 6: {
    if (isTankAlive) {
      PrintToChatAll("TANK ALIVE. DEPLOY TRUE.");
      tankDeploy = true;
      FireEntityInput("TankBossA", "SetHealth", "900000", 0.0);
      FireEntityInput("PL1.TrackTrain", "Stop", "", 0.1);
      FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track40", 0.1);
      FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
      CreateTimer(0.2, TimedOperator, 2);
    } else {
      tankDeploy = false;
      PrintToChatAll("TANK NOT ALIVE. DEPLOY FALSE.");
      FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
      FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track17", 0.0);
      FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    }
  }
  //PL2 (Tank) Successfully Deployed!
  case 7: {
    isTankAlive = false;
    FireEntityInput("PL.Spawn00", "Kill", "", 0.0);
    FireEntityInput("PL.FilterSpawn01", "SetTeam", "2", 0.0);
    FireEntityInput("PL.Spawn02", "SetTeam", "3", 0.0);
    FireEntityInput("PL.Spawn02", "Enable", "", 0.1);
    PotatoLogger(LOG_DBG, "TankDeployed!");
    FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
    FireEntityInput("PL1.CaptureArea", "Disable", "", 0.0);
    FireEntityInput("PL.RoundTimer", "AddTeamTime", "3 300", 0.0);
    FireEntityInput("PL2.CP", "SetOwner", "3", 0.0);
    FireEntityInput("PL1.CaptureArea", "CaptureCurrentCP", "", 0.0);
    FireEntityInput("PL.WatcherA", "SetSpeedForwardModifier", "1", 0.0);
    FireEntityInput("PL1.TrackTrain", "AddOutput", "height 10", 0.0);
    FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track41", 0.0);
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL3.CP", 1.0);
    FireEntityInput("PL.TankBoomSND", "PlaySound", "", 8.0);
    FireEntityInput("PL.TankExplo", "Explode", "", 8.0);
    FireEntityInput("PL.TankParticle", "Start", "", 8.0);
    FireEntityInput("PL.TankShake", "StartShake", "", 8.0);
    FireEntityInput("TankBossA", "Kill", "", 8.0);
    FireEntityInput("PL1.CaptureArea", "Enable", "", 10.0);
    FireEntityInput("PL3.PayloadSpawner", "ForceSpawn", "", 10.0);
  }
  //PL3 Spawned
  case 8: {
    FireEntityInput("PL3.Const", "TurnOn", "", 0.1);
  }
  //PL3 arrived at cannon
  case 9: {
    FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
    FireEntityInput("PL1.CaptureArea", "Disable", "", 0.0);
    FireEntityInput("PL.WatcherA", "SetTrainCanRecede", "0", 0.0);
    FireEntityInput("PL.CannonDoor", "Open", "", 0.0)
    FireEntityInput("PL.CannonLift", "Open", "", 2.0);
    FireEntityInput("PL1.CannonLift", "SetSpeed", "0.0", 2.10);
    FireEntityInput("PL1.CannonLift", "Close", "", 5.10);
    FireEntityInput("PL1.TrackTrain", "StartForward", "", 5.20);
  }
  //PL3 cannon loaded, aim and fire!
  case 10: {
    char aimP[8];
    char aimY[8];
    float aimPitch, aimYaw;
    if(failCount == 2){
      aimPitch = 0.85;
      aimYaw = 0.85;
      FireEntityInput("PL1.CaptureArea", "Enable", "", 1.0);
      FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL4.CP", 5.0);
    }
    else{
      int CannonPos = GetRandomInt(1, 9);
      switch (CannonPos) {
        //Normal outcome
        case 1,3,5,7,9: {
          failCount = 0;
          aimPitch = 0.85;
          aimYaw = 0.85;
          FireEntityInput("PL1.CaptureArea", "Enable", "", 1.0);
          FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL4.CP", 5.0);
        }
        //Aim at blue spawn
        case 2: {
          failCount++;
          aimPitch = 0.7;
          aimYaw = 0.1;
          CreateTimer(15.0, TimedOperator, 4);
        }
        //Aim at Red spawn
        case 4,6,8: {
          failCount++;
          aimPitch = 0.8;
          aimYaw = 0.65;
          CreateTimer(15.0, TimedOperator, 4);
        }
      }
    }
    FloatToString(aimPitch, aimP, sizeof(aimP));
    FloatToString(aimYaw, aimY, sizeof(aimY));
    FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
    FireEntityInput("PL3.Payload", "Kill", "", 0.0);
    FireEntityInput("PL3.Const", "Kill", "", 0.0);
    FireEntityInput("PL.SentCart", "ForceSpawn", "", 0.0);
    FireEntityInput("PL.CannonLift", "SetSpeed", "40", 0.0);
    FireEntityInput("PL.CannonLift", "Open", "", 0.1);
    FireEntityInput("PL.CannonPitch", "SetPosition", aimP, 5.0);
    FireEntityInput("PL.CannonYaw", "SetPosition", aimY, 5.0);
    FireEntityInput("PL.CannonSND", "PlaySound", "", 10.0);
    CreateTimer(10.35, TimedOperator, 3);
    FireEntityInput("PL.CannonShake", "StartShake", "", 10.0);
    FireEntityInput("PL.CannonFodder", "Enable", "", 10.0);
    FireEntityInput("PL.SentCartPhys", "SetDamageFilter", "NuBooliMe", 10.5);
    FireEntityInput("PL.CannonFodder", "Disable", "", 11.0);
    FireEntityInput("PL.CannonPitch", "SetPosition", "0.0", 20.0);
    FireEntityInput("PL.CannonYaw", "SetPosition", "0.0", 20.0);
  }
  //PL3 deployed (testing function, fix me)
  case 11:{
    PotatoLogger(LOG_DBG, "PL3 Captured!");
    FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track50", 0.0);
    FireEntityInput("PL1.CaptureArea", "CaptureCurrentCP", "", 0.0);
    FireEntityInput("PL3.CP", "SetOwner", "3", 0.0);
  }
  //PL4 deployed
  case 12:{
    PotatoLogger(LOG_DBG, "PL4 Captured. To Do: Make cool thing happen instead of *ding* you captured lulululululu~");
    FireEntityInput("PL1.TrackTrain", "Kill", "", 0.0);
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    FireEntityInput("PL1.CaptureArea", "Kill", "", 1.0);
    FireEntityInput("PL5.CP", "SetOwner", "3", 1.0);
  }
  //PL5 deployed
  case 13:{
    PotatoLogger(LOG_DBG, "PL4 Captured. To Do: Make cool thing happen instead of *ding* you captured lulululululu~");
    FireEntityInput("PL1.TrackTrain", "Kill", "", 0.0);
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    FireEntityInput("PL1.CaptureArea", "Kill", "", 1.0);
    FireEntityInput("PL5.CP", "SetOwner", "3", 1.0);
  }
  //CP1 Captured
  case 14:{
    //Unlock CTF1 after 60 seconds
  }
  //CTF1 Captured
  case 15:{
    FireEntityInput("PL.Spawn01", "Disable", "", 0.0);
    FireEntityInput("PL.Spawn02", "Enable", "", 0.0);
  }
  //CTF2 Captured
  case 16:{
    FireEntityInput("CP2.CP", "SetLocked", "0", 0.0);
  }
  //CP2 Captured - Does not need an operator command, actually. Maybe stop music for all clients then requeue normal BGM by setting BGMINDEX to 0?
  case 17:{
    //game win?
  }
  //Setup begin
  case 99:{
    //Do something
  }
  //Setup finished
  case 100:{
    QueueMusicSystem();
    FireEntityInput("PL.SpawnDoor00", "Unlock", "", 0.0);
  }
  case 9010: {
    CustomSoundEmitter(TBGM6, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM4, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
    CustomSoundEmitter(TBGM5, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
    CustomSoundEmitter(TBGM3, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
  }
  case 9011: {
    CustomSoundEmitter(TBGM6, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM4, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM5, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
    CustomSoundEmitter(TBGM3, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
  }
  case 9012: {
    CustomSoundEmitter(TBGM6, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM4, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM5, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM3, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
  }
  case 9013: {
    CustomSoundEmitter(TBGM6, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM4, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM5, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM3, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
  }
  case 9014: {
    CustomSoundEmitter(TBGM6, BGMSNDLVL - 10, true, 1, 0.05, 100, 2);
    CustomSoundEmitter(TBGM4, BGMSNDLVL - 10, true, 1, 1.0, 100, 2);
    CustomSoundEmitter(TBGM5, BGMSNDLVL - 10, true, 1, 1.0, 100, 2);
    CustomSoundEmitter(TBGM3, BGMSNDLVL - 10, true, 1, 1.0, 100, 2);
  }
  case 9015: {
    CustomSoundEmitter(TBGM6, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
    CustomSoundEmitter(TBGM4, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
    CustomSoundEmitter(TBGM5, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
    CustomSoundEmitter(TBGM3, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
  }
  case 9016: {
    CustomSoundEmitter(TBGM6, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
    CustomSoundEmitter(TBGM4, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
    CustomSoundEmitter(TBGM5, BGMSNDLVL - 10, true, 1, 0.05, 100, 0);
    CustomSoundEmitter(TBGM3, BGMSNDLVL - 10, true, 1, 1.0, 100, 0);
  }
  default:{
    char E[128];
    Format(E, sizeof(E), "{red}Attempted to call unimplemented {white}fb_operator %i{red}!", x);
    PotatoLogger(3, E);
  }
  }
  return Plugin_Handled;
}
//Timed operator, handle specific requests
public Action TimedOperator(Handle timer, int opCode) {
  switch (opCode) {
  case 0: {
    EmitSoundToAll(COUNTDOWN);
    CreateTimer(15.0, TankHealthTimer);
  }
  case 1: {
    int newHP = GetRandomInt(30000, 50000);
    IntToString(newHP, charHP, sizeof charHP);
    FireEntityInput("PL1.TankMaker", "ForceSpawn", "", 0.0);
    FireEntityInput("TankBossA", "SetHealth", charHP, 0.0);
  }
  case 2: {
    PrintToChatAll("ToggleAltPath!");
    FireEntityInput("PL1.Track40", "EnableAlternatePath", "", 0.0);
    FireEntityInput("PL1.Track40", "DisableAlternatePath", "", 10.0);
  }
  case 3:{
    EmitSoundToAll(CANNONECHO);
  }
  case 4:{
    PrintToChatAll("Resetting payload.");
    FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track41", 0.0);
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL3.CP", 1.0);
    FireEntityInput("PL1.CaptureArea", "Enable", "", 1.0);
    FireEntityInput("PL3.PayloadSpawner", "ForceSpawn", "", 1.0);
  }
  }
}

//Prepare the music system
void QueueMusicSystem() {
  PotatoLogger(LOG_INFO, "{lime}Music system queued.");
}

//Tank Checker
public Action TankPingTimer(Handle timer) {
  int tank = FindEntityByClassname(-1, "tank_boss"); //check if tank is alive
  if (tank == -1) {
    isTankAlive = false;
    PrintToChatAll("Tank ded");
    return Plugin_Stop;
  } else {
    isTankAlive = true;
    int tankHP = GetEntProp(tank, Prop_Data, "m_iHealth");
    int tankMaxHP = GetEntProp(tank, Prop_Data, "m_iMaxHealth");
    if (tankHP > 500000) {
      PrintToChatAll("BLUE TANK IS DEPLOYING ITS BOMB.");
      return Plugin_Stop;
    } else {
      float p = float(tankHP) / float(tankMaxHP);
      Format(tankStatus, sizeof(tankStatus), "{blue}Tank HP: %i%% (%i/%i)", RoundFloat(p * 100), tankHP, tankMaxHP);
      CreateTimer(1.0, TankPingTimer);
    }
  }
  return Plugin_Stop;
}

//Tank Health Status
public Action TankHealthTimer(Handle timer) {
  if(isTankAlive){
    PotatoLogger(LOG_CORE, tankStatus);
    CreateTimer(15.0, TankHealthTimer);
  }
  return Plugin_Stop;
}
//Create temp entity, fire input
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
//Remove edict allocated by temp entity
public Action DeleteEdict(Handle timer, any entity) {
  if (IsValidEdict(entity)) RemoveEdict(entity);
  return Plugin_Stop;
}

//Debug logger
void PotatoLogger(int logLvl, char[] dbgMsg){
  switch(logLvl){
    //Normal log
    case 0:{
      CPrintToChatAll("{green}[Potato/CORE]{white}: %s", dbgMsg);
    }
    //Info log
    case 1:{
      CPrintToChatAll("{yellow}[Potato/INFO @ %f]{white}: %s", GetGameTime(), dbgMsg);
    }
    //Debug log
    case 2:{
      CPrintToChatAll("{violet}[Potato/DEBUG @ %f]{white}: %s", GetGameTime(), dbgMsg);
    }
    //Error log
    case 3:{
      CPrintToChatAll("{red}[Potato/ERROR @ %f]{white}: %s", GetGameTime(), dbgMsg);
    }
  }
}

//Custom sound emitter, I don't know how many fucking times I've rewritten this! See FartsysAss.sp
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

void CustomSoundEmitter(char[] sndName, int SNDLVL, bool isBGM, int flags, float vol, int pitch, int team){
  char dbgWarn[255];
  Format(dbgWarn, sizeof(dbgWarn), "{orange}WARNING: soundpreference is bypassed. Sound %s will play regardless of preference.", sndName);
  PotatoLogger(LOG_DBG, dbgWarn);
  for (int i = 1; i <= MaxClients; i++){
    if(IsClientInGame(i) && !IsFakeClient(i)){
      if(team == 0){
        if(isBGM && true){//see below
          PotatoLogger(LOG_DBG, "Client on ALL teams got BGM!");
          EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, flags, vol, pitch, _, _, _, _, _);
        } else if (!isBGM && true){
          PotatoLogger(LOG_DBG, "Client on ALL teams got SFX!");
          EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, flags, vol, pitch, _, _, _, _, _);
        }
      }
      else if(GetClientTeam(i) == 2 && team == 2){
        if(isBGM && true){ //instead of using true, use soundPreference(i)
          PotatoLogger(LOG_DBG, "Client on Red team got BGM!");
          EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, flags, vol, pitch, _, _, _, _, _);
        } else if(!isBGM && true) {
          PotatoLogger(LOG_DBG, "Client on Red team got SFX!");
          EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, flags, vol, pitch, _, _, _, _, _);
        }
      }
      else if(GetClientTeam(i) == 3 && team == 3){
        if(isBGM && true){//see above
          PotatoLogger(LOG_DBG, "Client on Blu team got BGM!");
          EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, flags, vol, pitch, _, _, _, _, _);
        } else if (!isBGM && true){
          PotatoLogger(LOG_DBG, "Client on Blu team got SFX!");
          EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, flags, vol, pitch, _, _, _, _, _);
        }
      }
    }
  }
}


//Phase Reaction Chamber
void PhaseChange(int type){
  PL1 changes to thunder and base once cart goes underground for BLU ONLY.
  PL1 red team ONLY HEARS one song. They are not affected by any changes to blue.
  PL2 NO CHANGES (if pl2, return;)
  PL3 NO CHANGES (if pl3, return;)
  PL4 River sticks red, blue gets calm version when not pushing, intense when pushing
  PL5 red gets battle at big bridge no changes, blue gets apex pt 2 calm, upon reaching bridge blue gets intense apex pt 2
  CP1 no changes, once capped and 60 second timer will have a music segment
  CTF1 Kirby phase 2 red, you will know our names remastered blue
  CTF2 no changes
  CP2 both teams on capping, song changes for BOTH teams. Red: Immediate Threat/Alt Immediate Threat, Blue: You will know our names/Alt You will know our names
}