#include <morecolors>
#include <sdktools>
#include <sourcemod>
#pragma newdecls required
static char PLG_VER[8] = "1.2.9";

bool bgmPlaying = false;
bool canTornado = false;
bool tickTornado = false;
bool tickWeather = false;
bool isTankAlive = false;
bool musicInitializedBlu, musicInitializedRed = false;
bool shouldMusicRestart = false;
bool tankDeploy = false;
bool tickMusic = false;
bool spawnPl4 = true;

char charHP[16];
char curPhaseBlu[256];
char curPhaseRed[256];
char curSongBlu[256], curSongRed[256];
char prevPhaseBlu[256], prevPhaseRed[256];
char prevSongBlu[256], prevSongRed[256];
char songNameBlu[256], songNameRed[256];
char tankStatus[128];

static char BGM0[64] = "fartsy/music/brawler/hw_aoc/aquietmoment.mp3";
static char BGM1[64] = "fartsy/music/brawler/fe_w/chaossilence.wav";
static char BGM2[64] = "fartsy/music/brawler/fe_3h/thelongroad_rain.wav";
static char BGM3[64] = "fartsy/music/brawler/fe_3h/thelongroad_thunder.wav";
static char BGM4[64] = "fartsy/music/brawler/fe_w/chaoshellishblaze.wav";
static char BGM5[64] = "fartsy/music/brawler/fe_w/resoluteheartsilence.wav";
static char BGM6[64] = "fartsy/music/brawler/demetori/nuclearfusion.wav";
static char BGM7[64] = "fartsy/music/brawler/fe_w/resoluteheart.wav";
static char BGM8[64] = "fartsy/music/brawler/demetori/riverstyx.wav";
static char BGM9[64] = "fartsy/music/brawler/fe_3h/apex1_calm.wav";
static char BGM10[64] = "fartsy/music/brawler/fe_3h/apex1_inferno.wav";
static char BGM11[64] = "fartsy/music/brawler/ffxiv/battleatthebigbridgexiv.wav";
static char BGM12[64] = "fartsy/music/brawler/fe_3h/apex2_calm.wav";
static char BGM13[64] = "fartsy/music/brawler/fe_3h/apex2_inferno.wav";
static char BGM14[64] = "fartsy/music/brawler/kirbyfl/rochelimitp1.wav";
static char BGM15[64] = "fartsy/music/brawler/ssbb/bossbattle1.wav";
static char BGM16[64] = "fartsy/music/brawler/kirbyfl/rochelimitp2.wav";
static char BGM17[64] = "fartsy/music/brawler/xbcr/youwillknowournames_remaster.wav";
static char BGM18[64] = "fartsy/music/brawler/xbcr/visionsofthefuture_remaster.wav";
static char BGM19[64] = "fartsy/music/brawler/xbc2/youwillrecallournames.wav";
static char BGM20[64] = "fartsy/music/brawler/xbc3/immediatethreat.wav";
static char BGM21[64] = "fartsy/music/brawler/xbc3/youwillknowournames_finale.wav";
static char BGM22[64] = "fartsy/music/brawler/xbc3/immediatethreatpre.wav";
static char BGM23[64] = "fartsy/music/brawler/xbc3/youwillknowournames_pre.wav";
static char BGM0Title[64] = "Hyrule Warriors AOC - A Quiet Moment";
static char BGM1Title[64] = "Fire Emblem W - Chaos (Silence)";
static char BGM2Title[64] = "Fire Emblem 3H - The Long Road (Rain)";
static char BGM3Title[64] = "Fire Emblem 3H - The Long Road (Thunder)";
static char BGM4Title[64] = "Fire Emblem W - Chaos (Hellish Blaze)";
static char BGM5Title[64] = "Fire Emblem W - Resolute Heart (Silence)";
static char BGM6Title[64] = "Demetori - Nuclear Fusion";
static char BGM7Title[64] = "Fire Emblem W - Resolute Heart";
static char BGM8Title[64] = "Demetori - View of the River Styx";
static char BGM9Title[64] = "Fire Emblem W - Apex of the World P1 (Embers)";
static char BGM10Title[64] = "Fire Emblem W - Apex of the World P1 (Inferno)";
static char BGM11Title[64] = "Final Fantasy XIV - Battle At The Big Bridge";
static char BGM12Title[64] = "Fire Emblem W - Apex of the World P2 (Embers)";
static char BGM13Title[64] = "Fire Emblem W - Apex of the World P2 (Inferno)";
static char BGM14Title[64] = "Kirby Forgotten Land - Two Planets Approach the Roche Limit P1";
static char BGM15Title[64] = "Super Smash Bros. Brawl - Boss Battle 1";
static char BGM16Title[64] = "Kirby Forgotten Land - Two Planets Approach the Roche Limit P2";
static char BGM17Title[64] = "Xenoblade Chronicles 1R - You Will Know Our Names";
static char BGM18Title[64] = "Xenoblade Chronicles 1R - Visions of the Future";
static char BGM19Title[64] = "Xenoblade Chronicles 2 - You Will Recall Our Names";
static char BGM20Title[64] = "Xenoblade Chronicles 3 - Immediate Threat";
static char BGM21Title[64] = "Xenoblade Chronicles 3 - You Will Know Our Names (Finale)";
static char BGM22Title[64] = "Xenoblade Chronicles 3 - Immediate Threat (Pre End)";
static char BGM23Title[64] = "Xenoblade Chronicles 3 - You Will Know Our Names (Pre End)";
static char CANNONECHO[48] = "fartsy/misc/brawler/cannon_echo.mp3";
static char COUNTDOWN[32] = "fartsy/misc/countdown.wav";
/*WARNING: Kill unused Teleports and Dests once swapped. PL1.RegenField to be enabled/disabled at the same time as PL1.CaptureArea. CRITICAL: Fire on pl.filterspawn<XX> team <x> when spawns change! Also, PL<x>.DeathPit to be enabled when Pl deployed.
 NOTE: tornadowarn00, tornadowarn01, and tornadowarn04 are generic warnings
 tornadowarn02 is for blu team only
 tornadowarn03 is for red team only
 NOTE: tank00 and tank03 are generic tank warnings
 tank01 is red only
 tank02 is red only
 tank04 is red only
*/
static int BGMSNDLVL = 95;
static int LOG_CORE = 0;
static int LOG_INFO = 1;
static int LOG_DBG = 2;
static int LOG_ERR = 3;
static int SNDCHAN = 6;
static char TSPWN[32] = "fartsy/misc/brawler/pl_tank.mp3";
static char TBGM0[16] = "test/bgm0.mp3";
static char TBGM1[16] = "test/bgm1.mp3";
static char TBGM3[16] = "test/bgm3.mp3";
static char TBGM4[16] = "test/bgm4.mp3";
static char TBGM5[16] = "test/bgm5.mp3";
static char TBGM6[16] = "test/bgm6.mp3";

int failCount = 0;
int BGMINDEX = 0;
int ChkPt = 1;
int refireTicksBlu, refireTicksRed = 0;
int stopForTeam = 0;
int stormIntensity = 0;
int ticksMusicBlu, ticksMusicRed = 0;

public Plugin myinfo = {
  author = "Fartsy",
  description = "Don't worry about it...",
  version = PLG_VER,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart() {
  PrecacheSound(BGM0, true);
  PrecacheSound(BGM1, true);
  PrecacheSound(BGM2, true);
  PrecacheSound(BGM3, true);
  PrecacheSound(BGM4, true);
  PrecacheSound(BGM5, true);
  PrecacheSound(BGM6, true);
  PrecacheSound(BGM7, true);
  PrecacheSound(BGM8, true);
  PrecacheSound(BGM9, true);
  PrecacheSound(BGM10, true);
  PrecacheSound(BGM11, true);
  PrecacheSound(BGM12, true);
  PrecacheSound(BGM13, true);
  PrecacheSound(BGM14, true);
  PrecacheSound(BGM15, true);
  PrecacheSound(BGM16, true);
  PrecacheSound(BGM17, true);
  PrecacheSound(BGM18, true);
  PrecacheSound(BGM19, true);
  PrecacheSound(BGM20, true);
  PrecacheSound(BGM21, true);
  PrecacheSound(BGM22, true);
  PrecacheSound(BGM23, true);
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

//Find an entity by its targetname
stock int FindEntityByTargetname(int startEnt, const char[] TargetName, bool caseSensitive, bool Contains)    // Same as FindEntityByClassname with sensitivity and contain features
{
  int entCount = GetEntityCount();
  //PrintToServer("EntCount was %i", entCount);
  char EntTargetName[300];
  for (int i = startEnt + 1; i < entCount; i++){
    if (!IsValidEntity(i))
      continue;
    else if (!IsValidEdict(i))
      continue;
    GetEntPropString(i, Prop_Data, "m_iName", EntTargetName, sizeof(EntTargetName));
    if ((StrEqual(EntTargetName, TargetName, caseSensitive) && !Contains) || (StrContains(EntTargetName, TargetName, caseSensitive) != -1 && Contains)){
      char D[256];
      Format (D, sizeof(D), "Ent %i, targetname %s", i, EntTargetName);
      PotatoLogger(LOG_DBG, D);
      return i;
    }
  }
  return -1;
}

public void OnGameFrame(){
  //tick music
  if (tickMusic){
    //Stop music if requested.
    if (shouldMusicRestart) {
      for (int i = 1; i <= MaxClients; i++) {
        if (!prevSongBlu || !prevSongRed){
          break;
        }
        if (IsClientInGame(i)){
          char StopLog[128];
          Format(StopLog, sizeof(StopLog), "Stopping music for client %N", i);
          PotatoLogger(LOG_DBG, StopLog);
          switch(stopForTeam){
            case 0:{
              StopSound(i, SNDCHAN, prevPhaseBlu);
              StopSound(i, SNDCHAN, prevPhaseRed);
              StopSound(i, SNDCHAN, prevSongBlu);
              StopSound(i, SNDCHAN, prevSongRed);
              musicInitializedBlu = false;
              musicInitializedRed = false;
              ticksMusicBlu = -5;
              refireTicksBlu = 0;
              ticksMusicRed = -5;
              refireTicksRed = 0;
            }
            case 2:{
              PotatoLogger(LOG_DBG, "Stopping for Team RED prevPhaseRed %s prevSongRed %s");
              StopSound(i, SNDCHAN, prevPhaseRed);
              StopSound(i, SNDCHAN, prevSongRed);
              musicInitializedRed = false;
              ticksMusicRed = -5;
              refireTicksRed = 0;
            }
            case 3:{
              StopSound(i, SNDCHAN, prevPhaseBlu);
              StopSound(i, SNDCHAN, prevSongBlu);
              musicInitializedBlu = false;
              ticksMusicBlu = -5;
              refireTicksBlu = 0;
            }
          }
          stopForTeam = 0;
          shouldMusicRestart = false;
        }
      }
    }
    //Start something if bgm is not playing
    if (!bgmPlaying) {
      refireTicksRed = 5900;
      ticksMusicRed = 0;
      refireTicksBlu = 5900;
      ticksMusicBlu = 0;
      bgmPlaying = true;
      curSongBlu = BGM0;
      curSongRed = BGM0;
      CreateTimer(0.5, UpdateMusicBlu);
      CreateTimer(0.5, UpdateMusicRed);
      CustomSoundEmitter(BGM0, BGMSNDLVL, true, 0, 1.0, 100, 0);
    }
    tickMusicRed();
    tickMusicBlu();
  }
  //tick tornado
  if (tickTornado){
    int Ent = FindEntityByTargetname(-1, "track2", true, true);
    if (Ent == -1) {
      //PrintToChatAll("Ent not found");
      return;
    } else {
      char t[300];
      GetEntPropString(Ent, Prop_Data, "m_iName", t, sizeof(t));
      PrintToChatAll("Entity %s with index %i found!", t, Ent)
      float destination[3];
      destination[0] = 0.0;
      destination[1] = 0.0;
      destination[2] = 0.0;
      float position[3];
      char targetname[128];
      GetEntPropString(Ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
      if (StrEqual(targetname, "track2")) {
        GetEntPropVector(Ent, Prop_Send, "m_vecOrigin", position);
        destination[0] = position[0] + 100.0;
        destination[1] = position[1] + 100.0;
        destination[2] = position[2];
        TeleportEntity(Ent, destination, NULL_VECTOR, NULL_VECTOR);
        PrintToConsoleAll("Teleporting track2 to %d %d %d", destination[0], destination[1], destination[2]);
      }
    }
  }
}

//Tick Music for Blu Team
void tickMusicBlu(){
  ticksMusicBlu++;
  //Track and play music
  if (ticksMusicBlu >= refireTicksBlu) {
    CreateTimer(0.5, UpdateMusicBlu);
    bgmPlaying = true;
    switch (BGMINDEX){
      //Setup Music, 90s clip
      case 0:{
        ticksMusicBlu = 0;
        curSongBlu = BGM0;
        songNameBlu = BGM0Title;
      }
      //PL 1, BLU Long Road
      case 1:{
        ticksMusicBlu = 0;
        curPhaseBlu = BGM3;
        curSongBlu = BGM2;
        songNameBlu = BGM2Title;
        refireTicksBlu = 10890;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM2, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Long Road Rain
          CustomSoundEmitter(BGM3, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Long Road Thunder (Play at 0.5 when phase change happens.)
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
      //PL2 BLU Resolute Heart Siilence
      case 2:{
        ticksMusicBlu = 0;
        curPhaseBlu = BGM7;
        curSongBlu = BGM5;
        songNameBlu = BGM5Title;
        refireTicksBlu = 5544;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM5, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Resolute Heart Silence
          CustomSoundEmitter(BGM7, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Resolute Heart
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
      //PL3 BLU Resolute Heart
      case 3:{
        ticksMusicBlu = 0;
        curPhaseBlu = BGM5;
        curSongBlu = BGM7;
        songNameBlu = BGM7Title;
        refireTicksBlu = 5544;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM5, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Resolute Heart Silence
          CustomSoundEmitter(BGM7, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Resolute Heart 
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
      //PL4 BLU Apex of the World P1, changes phase when cart pushing.
      case 4:{
        ticksMusicBlu = 0;
        curPhaseBlu = BGM10;
        curSongBlu = BGM9;
        songNameBlu = BGM9Title;
        refireTicksBlu = 12210;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM9, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Apex pt1 Calm
          CustomSoundEmitter(BGM10, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Apex pt1 Inferno 
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
      //PL5 BLU Apex of the World P2, changes when cart on bridge.
      case 5:{
        ticksMusicBlu = 0;
        curPhaseBlu = BGM13;
        curSongBlu = BGM12;
        songNameBlu = BGM12Title;
        refireTicksBlu = 8382;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM12, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Apex pt2 Calm
          CustomSoundEmitter(BGM13, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Apex pt2 Inferno 
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
      //CP1 BLU SSBB Boss Battle 1
      case 6:{
        ticksMusicBlu = 0;
        curSongBlu = BGM15;
        songNameBlu = BGM15Title;
        refireTicksBlu = 7260;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM15, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Smash Brawl Boss Battle 1
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
      //Int 1 BLU You Will Know Our Names XBR
      case 7:{
        ticksMusicBlu = 0;
        curSongBlu = BGM17;
        songNameBlu = BGM17Title;
        refireTicksBlu = 11682;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM17, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: You Will Know Our Names Remaster
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
      //Int 2 BLU You Will Recall Our Names XBC2
      case 8:{
        ticksMusicBlu = 0;
        curSongBlu = BGM19;
        songNameBlu = BGM19Title;
        refireTicksBlu = 13068;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM19, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: You Will Recall Our Names XBC2
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
      //CP 2 Blu You Will Know Our Names Finale XBC3, Pre End while capping
      case 9:{
        ticksMusicBlu = 0;
        curPhaseBlu = BGM23;
        curSongBlu = BGM21;
        songNameBlu = BGM21Title;
        refireTicksBlu = 12276;
        if(!musicInitializedBlu){
          CustomSoundEmitter(BGM21, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: You Will Know Our Names Finale XBC3
          CustomSoundEmitter(BGM23, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: You Will Know Our Names Finale Pre End XBC3
          shouldMusicRestart = false;
          musicInitializedBlu = true;
        }
      }
    }
  }
}

//Tick Music for Red Team
void tickMusicRed(){
  ticksMusicRed++;
  //Track and play music
  if (ticksMusicRed >= refireTicksRed) {
    CreateTimer(0.5, UpdateMusicRed);
    bgmPlaying = true;
    switch (BGMINDEX){
      //Setup Music, 90s clip
      case 0:{
        ticksMusicRed = 0;
        curSongRed = BGM0;
        songNameRed = BGM0Title;
      }
      //PL 1, RED Chaos Silence
      case 1:{
        ticksMusicRed = 0;
        curPhaseRed = BGM4;
        curSongRed = BGM1;
        songNameRed = BGM1Title;
        refireTicksRed = 6930;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM1, BGMSNDLVL, true, 1, 1.0, 100, 2); //RED: Chaos Silence
          CustomSoundEmitter(BGM4, BGMSNDLVL, true, 1, 0.05, 100, 2); //RED: Chaos Hellish Blaze
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
      //PL 2, RED Chaos Hellish Blaze
      case 2:{
        ticksMusicRed = 0;
        curPhaseRed = BGM1;
        curSongRed = BGM4;
        songNameRed = BGM4Title;
        refireTicksRed = 6930;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM1, BGMSNDLVL, true, 1, 0.05, 100, 2); //RED: Chaos Silence
          CustomSoundEmitter(BGM4, BGMSNDLVL, true, 1, 1.0, 100, 2); //RED: Chaos Hellish Blaze
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
      //PL 3, RED Demetori Nuclear Fusion
      case 3:{
        ticksMusicRed = 0;
        curSongRed = BGM6;
        songNameRed = BGM6Title;
        refireTicksRed = 15114;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM6, BGMSNDLVL, true, 0, 1.0, 100, 2); //RED: Nuclear Fusion
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
      //PL 4, RED View of the River Styx
      case 4:{
        ticksMusicRed = 0;
        curSongRed = BGM8;
        songNameRed = BGM8Title;
        refireTicksRed = 28776;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM8, BGMSNDLVL, true, 0, 1.0, 100, 2); //RED: View of the River Styx
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
      //PL 5, Battle at the Big Bridge XIV
      case 5:{
        ticksMusicRed = 0;
        curSongRed = BGM11;
        songNameRed = BGM11Title;
        refireTicksRed = 9306;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM11, BGMSNDLVL, true, 0, 1.0, 100, 2); //RED: Battle at the Big Bridge XIV
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
      //CP1, Two Planets Approach the Roche Limit P1
      case 6:{
        ticksMusicRed = 0;
        curSongRed = BGM14;
        songNameRed = BGM14Title;
        refireTicksRed = 14520;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM14, BGMSNDLVL, true, 0, 1.0, 100, 2); //RED: Two Planets Approach the Roche Limit Phase 1
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
      //Int 1 Two Planets Approach the Roche Limit P2
      case 7:{
        ticksMusicRed = 0;
        curSongRed = BGM16;
        songNameRed = BGM16Title;
        refireTicksRed = 13662;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM16, BGMSNDLVL, true, 0, 1.0, 100, 2); //RED: Two Planets Approach the Roche Limit Phase 2
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
      //Int 2 Visions of the Future XBR
      case 8:{
        ticksMusicRed = 0;
        curSongRed = BGM18;
        songNameRed = BGM18Title;
        refireTicksRed = 9174;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM18, BGMSNDLVL, true, 0, 1.0, 100, 2); //RED: Visions of the Future XBR
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
      //CP 2 Immediate Threat, pre end while being capped.
      case 9:{
        ticksMusicRed = 0;
        curPhaseRed = BGM22;
        curSongRed = BGM20;
        songNameRed = BGM20Title;
        refireTicksRed = 16500;
        if(!musicInitializedRed){
          CustomSoundEmitter(BGM20, BGMSNDLVL, true, 1, 1.0, 100, 2); //RED: Immediate Threat XB3
          CustomSoundEmitter(BGM22, BGMSNDLVL, true, 1, 0.05, 100, 2); //RED: Immediate Threat Pre End XB3
          shouldMusicRestart = false;
          musicInitializedRed = true;
        }
      }
    }
  }
}

public Action UpdateMusicBlu(Handle timer){
  prevPhaseBlu = curPhaseBlu;
  prevSongBlu = curSongBlu;
}

public Action UpdateMusicRed(Handle timer){
  prevPhaseRed = curPhaseRed;
  prevSongRed = curSongRed;
}

//Operator, handle all map requests
public Action Command_Operator(int args) {
  char arg1[16];
  GetCmdArg(1, arg1, sizeof(arg1));
  int x = StringToInt(arg1);
  switch (x) {
  //Red Win
  case 0: {
    stopForTeam = 0;
    BGMINDEX = 0;
    bgmPlaying = false;
    RestartMusic();
    tickMusic = false;
    PrintToChatAll("RED WON.");
    FireEntityInput("WinRed", "RoundWin", "", 0.0);
  }
  //Blu Win
  case 1: {
    stopForTeam = 0;
    BGMINDEX = 0;
    bgmPlaying = false;
    RestartMusic();
    tickMusic = false;
    PrintToChatAll("BLUE WON.");
  }
  //Round Start
  case 2: {
    ServerCommand("fb_operator 100");
  }
  //PL1 Deployed, spawn tank
  case 3: {
    PhaseChange(4);
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
    ChkPt = 2;
    isTankAlive = true;
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "69", 0.0);
    FireEntityInput("PL.WatcherA", "SetSpeedForwardModifier", "0.5", 0.0);
    FireEntityInput("TornadoPathing", "ForceSpawn", "", 0.0);
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
      PotatoLogger(LOG_DBG, "TANK ALIVE. DEPLOY TRUE.");
      tankDeploy = true;
      FireEntityInput("TankBossA", "SetHealth", "900000", 0.0);
      FireEntityInput("PL1.TrackTrain", "Stop", "", 0.1);
      FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track40", 0.1);
      FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
      CreateTimer(0.2, TimedOperator, 2);
    } else {
      tankDeploy = false;
      PotatoLogger(LOG_DBG, "TANK NOT ALIVE. DEPLOY FALSE.");
      FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
      FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track17", 0.0);
      FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    }
  }
  //PL2 (Tank) Successfully Deployed!
  case 7: {
    isTankAlive = false;
    //FireEntityInput("PL.Spawn00", "Kill", "", 0.0); //why am i doin dis
    //FireEntityInput("PL.FilterSpawn01", "SetTeam", "2", 0.0);
   // FireEntityInput("PL.Spawn02", "SetTeam", "3", 0.0);
    //FireEntityInput("PL.Spawn02", "Enable", "", 0.1);
    ChkPt = 2;
    PotatoLogger(LOG_DBG, "TankDeployed!");
    PhaseChange(4);
    FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
    FireEntityInput("PL1.CaptureArea", "Disable", "", 0.0);
    FireEntityInput("PL.RoundTimer", "AddTeamTime", "3 300", 0.0);
    FireEntityInput("PL2.CP", "SetOwner", "3", 0.0);
    FireEntityInput("PL1.CaptureArea", "CaptureCurrentCP", "", 0.0);
    FireEntityInput("PL.WatcherA", "SetSpeedForwardModifier", "1", 0.0);
    FireEntityInput("PL1.TrackTrain", "AddOutput", "height 10", 0.0);
    FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track41", 0.0);
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    FireEntityInput("PL.SpawnDoor00_1Trigger", "Enable", "", 0.0);
    FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL3.CP", 1.0);
    FireEntityInput("PL.TankBoomSND", "PlaySound", "", 8.0);
    FireEntityInput("PL.TankExplo", "Explode", "", 8.0);
    FireEntityInput("PL.TankParticle", "Start", "", 8.0);
    FireEntityInput("PL.TankShake", "StartShake", "", 8.0);
    FireEntityInput("TankBossA", "Kill", "", 8.0);
    FireEntityInput("PL3.CrateSpawner", "ForceSpawn", "", 12.0);
    FireEntityInput("PL1.CaptureArea", "Enable", "", 15.0);
    FireEntityInput("PL3.PayloadSpawner", "ForceSpawn", "", 15.0);
    FireEntityInput("PL.Teleport01", "Disable", "", 0.0);
    FireEntityInput("PL.Teleport02", "Enable", "", 0.1);
  }
  //PL3 Spawned
  case 8: {
    ChkPt = 3;
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
    FireEntityInput("PL.CannonDoor", "Close", "", 20.0);
    //ALSO REMEMBER TO UH.... TRY REMOVING THE IF SPAWNPL4 METHOD TOMORROW. THANKS. ALSO NOTICE: Try the current compile, removed the bobomb in case maybe it's just conflicting...
  }
  //PL3 deployed
  case 11:{
    //Quick and dirty workaround for PL3 triggering multiple times.
    if(spawnPl4){
      ChkPt = 4;
      BGMINDEX = 4;
      stopForTeam = 0;
      RestartMusic();
      PotatoLogger(LOG_DBG, "PL3 Captured! Spawning PL4!");
      FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track50", 0.0);
      FireEntityInput("PL1.CaptureArea", "CaptureCurrentCP", "", 0.0);
      FireEntityInput("PL3.CP", "SetOwner", "3", 0.0);
      FireEntityInput("PL1.TrackTrain", "AddOutput", "height 16", 0.0);
      FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track51", 0.20);
      FireEntityInput("PL4.PayloadSpawner", "ForceSpawn", "", 1.0);
      FireEntityInput("PL1.CaptureArea", "Enable", "", 1.0);
      FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL4.CP", 1.0);
      spawnPl4 = false;
      CreateTimer(5.0, TimedOperator, 5);
    }
  }
  //PL4 Spawned
  case 12:{
    FireEntityInput("PL4.Const", "TurnOn", "", 2.1);
  }
  //PL4 deployed
  case 13:{
    ChkPt = 5;
    BGMINDEX = 5;
    stopForTeam = 0;
    RestartMusic();
    FireEntityInput("PL4.Payload", "DisableMotion", "", 0.0);
    FireEntityInput("PL4.PayloadBomb", "DisableMotion", "", 0.0);
    FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track63", 0.0);
    FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
    FireEntityInput("PL1.CaptureArea", "CaptureCurrentCP", "", 0.0);
    FireEntityInput("PL4.CP", "SetOwner", "3", 0.0);
    FireEntityInput("PL1.CaptureArea", "Disable", "", 0.0);
    FireEntityInput("PL.RoundTimer", "AddTeamTime", "3 300", 0.0);
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    FireEntityInput("PL4.Pipe", "Open", "", 0.0);
    FireEntityInput("PL4.Payload", "Kill", "", 2.0);
    FireEntityInput("PL4.PayloadBomb", "Kill", "", 2.0);
    FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL5.CP", 2.0);
    FireEntityInput("PL1.CaptureArea", "Enable", "", 2.0);
    FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track64", 3.0);
  }
  // Pipe up!
  case 14:{
    FireEntityInput("PL4.PipeUpSND", "PlaySound", "", 0.0);
  }
  //Pipe dn!
  case 15:{
    ChkPt = 5;
    FireEntityInput("PL4.PipeDnSND", "PlaySound", "", 0.0);
    FireEntityInput("PL4.MarioSND", "PlaySound", "", 2.0);
    FireEntityInput("PL4.BoomSND", "PlaySound", "", 2.7);
    FireEntityInput("PL4.BoomShake", "StartShake", "", 2.7);
    FireEntityInput("PL5.PayloadSpawner", "ForceSpawn", "", 3.0);
    FireEntityInput("PL5.Payload", "SetAnimation", "stand_ITEM1", 3.1);
    FireEntityInput("PL5.Payload", "SetDefaultAnimation", "stand_ITEM1", 3.1);
    FireEntityInput("PL5.PayloadController", "SetPoseValue", "0.9", 3.2);
  }
  //PL5 deployed
  case 16:{
    BGMINDEX = 6;
    ChkPt = 6;
    stopForTeam = 0;
    RestartMusic();
    PotatoLogger(LOG_DBG, "PL5 Captured. To Do: Play sound and blow up gate instead of *ding* you captured lulululululu~");
    FireEntityInput("PL5.CP", "SetOwner", "3", 0.0);
    FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
    FireEntityInput("PL1.CaptureArea", "Kill", "", 1.0);
    FireEntityInput("PL5.Payload", "SetAnimation", "taunt_yetipunch", 0.0);
    FireEntityInput("PL5.Payload", "SetDefaultAnimation", "taunt_yetipunch", 0.1);
    FireEntityInput("PL5.PayloadController", "SetPoseValue", "0.9", 1.2);
    FireEntityInput("PL5.Payload", "ClearParent", "", 4.0);
    FireEntityInput("PL5.BoomSND", "PlaySound", "", 4.5);
    FireEntityInput("PL5.Explo", "Explode", "", 4.5);
    FireEntityInput("PL5.Shake", "StartShake", "", 4.5);
    FireEntityInput("PL5.Door", "Kill", "", 4.5);
    FireEntityInput("PL.KeepDoor", "Kill", "", 4.5);
    FireEntityInput("PL.KeepDoorTrigger", "Kill", "", 4.5);
    FireEntityInput("PL5.DoorFX", "Break", "", 4.5);
    FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track64", 4.9);
    FireEntityInput("PL1.TrackTrain", "Kill", "", 5.0);
    FireEntityInput("PL5.Payload", "Kill", "", 5.0);
    FireEntityInput("CP1.CP", "SetLocked", "0", 5.0);
  }
  //CP1 Start Capture
  case 17:{
    FireEntityInput("CP1.SirenMDL", "AddOutput", "Skin 2", 0.0);
    FireEntityInput("CP1.SirenMDL", "SetAnimation", "spin", 0.0);
  }
  //CP1 Capture Break
  case 18:{
    FireEntityInput("CP1.SirenMDL", "AddOutput", "Skin 1", 0.0);
    FireEntityInput("CP1.SirenMDL", "SetAnimation", "idle", 0.0);

  }
  //CP1 Captured
  case 19:{
    BGMINDEX = 7;
    ChkPt = 7;
    stopForTeam = 0;
    RestartMusic();
    FireEntityInput("PL.Tele01", "Kill", "", 0.0);
    FireEntityInput("PL.Tele02", "Kill", "", 0.0);
    FireEntityInput("CP1.SirenMDL", "AddOutput", "Skin 3", 0.0);
    FireEntityInput("CP1.SirenMDL", "SetAnimation", "spin", 0.0);
    FireEntityInput("PL.CPDoor", "Open", "", 0.0);
    FireEntityInput("PL.Teleport02", "Disable", "", 0.0);
    FireEntityInput("PL.Teleport03", "Enable", "", 0.1);
    FireEntityInput("PL.CPDoorBarrier", "Disable", "", 60.0);
    FireEntityInput("CTF1.CTF", "Enable", "", 60.0);
  }
  //CTF1 Captured
  case 20:{
    BGMINDEX = 8;
    ChkPt = 8;
    stopForTeam = 0;
    RestartMusic();
    FireEntityInput("PL.Teleport00", "Disable", "", 0.0);
    FireEntityInput("PL.Teleport04", "Enable", "", 0.1);
    FireEntityInput("PL.FilterSpawn02", "setteam", "2", 0.1);
    FireEntityInput("CTF1.CTF", "Kill", "", 0.1);
    FireEntityInput("PL.Spawn00_FlagDetZone", "Kill", "", 0.1);
    FireEntityInput("PL.Spawn03_FlagDetZone", "Enable", "", 1.0);
    FireEntityInput("CTF2.CTF", "Enable", "", 5.0);
  }
  //CTF2 Captured
  case 21:{
    BGMINDEX = 9;
    ChkPt = 9;
    stopForTeam = 0;
    RestartMusic();
    FireEntityInput("CTF2.CTF", "Kill", "", 0.1);
    FireEntityInput("PL.Spawn03_FlagDetZone", "Kill", "", 0.1);
    FireEntityInput("CP2.CP", "SetLocked", "0", 0.0);
  }
  //CP2 began capture
  case 22:{
    PhaseChange(1);
  }
  //CP2 capture break
  case 23:{
    PhaseChange(0);
  }
  //CP2 captured
  case 24:{

  }
  //Gilgamesh Spawned
  case 25:{
    FireEntityInput("PL5.Payload", "SetAnimation", "run_ITEM1", 0.0);
    FireEntityInput("PL5.Payload", "SetDefaultAnimation", "run_ITEM1", 0.0);
    FireEntityInput("PL5.PayloadController", "SetPoseValue", "0.9", 0.1);
    FireEntityInput("PL5.Payload", "SetAnimation", "stand_ITEM1", 1.0);
    FireEntityInput("PL5.Payload", "SetDefaultAnimation", "stand_ITEM1", 0.2);
    FireEntityInput("PL5.PayloadController", "SetPoseValue", "0.5", 1.1);
  }
  //Tornado should start
  case 26:{
    if(canTornado){
      FireEntityInput("F1_Debris", "Start", "", 1.0);
      FireEntityInput("F1_Core", "Start", "", 2.5);
    }
  }
  //Tornado should end
  case 27:{
    if(canTornado){
      FireEntityInput("F1_Debris", "Stop", "", 1.0);
      FireEntityInput("F1_Core", "Stop", "", 2.5);
    }
    else{
      FireEntityInput("F1_Meso", "Stop", "", 0.0);
    }
  }
  //Cart on Bridge
  case 94:{
    PhaseChange(3);
  }
  //Cart entered the mine
  case 95:{
    PhaseChange(2);
  }
  //Cart Forward
  case 96:{
    PhaseChange(1);
    FireEntityInput("PL5.Payload", "SetAnimation", "run_ITEM1", 0.0);
    FireEntityInput("PL5.Payload", "SetDefaultAnimation", "run_ITEM1", 0.0);
    FireEntityInput("PL5.PayloadController", "SetPoseValue", "0.9", 0.1);
  }
  //Cart Stopped
  case 97:{
    PhaseChange(0);
    FireEntityInput("PL5.Payload", "SetAnimation", "stand_ITEM1", 0.0);
    FireEntityInput("PL5.Payload", "SetDefaultAnimation", "stand_ITEM1", 0.0);
    FireEntityInput("PL5.PayloadController", "SetPoseValue", "0.9", 0.1);
  }
  //Cart Backward
  case 98:{
    FireEntityInput("PL5.Payload", "SetAnimation", "run_ITEM1", 0.0);
    FireEntityInput("PL5.Payload", "SetDefaultAnimation", "run_ITEM1", 0.0);
    FireEntityInput("PL5.PayloadController", "SetPoseValue", "0.1", 0.1);

  }
  //Setup begin
  case 99:{
    QueueMusicSystem();
    QueueWeatherSystem();
  }
  //Setup finished
  case 100:{
    BGMINDEX = 1;
    RestartMusic();
    FireEntityInput("PL.SpawnDoorTrigger00", "Enable", "", 0.0);
  }
  //debug
  case 9000:{
    FireEntityInput("TankBossA", "AddOutput", "target PL1.Track17", 0.0);
  }
  //debug
  case 9001:{
    FireEntityInput("f1_core", "Start", "", 1.0);
    tickTornado = true;
  }
  case 9002:{
    FireEntityInput("TornadoPathing", "ForceSpawn", "", 1.0);
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
    PotatoLogger(LOG_ERR, E);
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
  case 5:{
    spawnPl4 = true;
  }
  case 6:{
    FireEntityInput("T0x*", "Kill", "", 0.0);
  }
  }
}

//Prepare the music system
void QueueMusicSystem() {
  PotatoLogger(LOG_INFO, "{lime}Music system queued.");
  BGMINDEX = 0;
  bgmPlaying = false;
  ChkPt = 1;
  stopForTeam = 0;
  RestartMusic();
  tickMusic = true;
}

//Prepare the weather system
void QueueWeatherSystem() {
  //PotatoLogger(LOG_INFO, "{aqua}[TENGINE] {white}Weather {limegreen}v4{white} is good to go!");
  PotatoLogger(LOG_ERR, "CRITICAL: RunWeatherSystem IS NOT FINISHED. WEATHER WILL NOT WORK.");
  CreateTimer(10.0, RunWeatherSystem);
  CreateTimer(3.0, TimedOperator, 6);
  stormIntensity = 0;
  tickWeather = true;
}

//Run the weather system
public Action RunWeatherSystem(Handle timer){
  if(tickWeather){
    if (stormIntensity < 1){
      stormIntensity = 1;
    }
    int i = GetRandomInt(1, 16);
    switch(i){
      case 1:{
        stormIntensity++;
      }
      case 2:{
        stormIntensity--;
      }
      case 3:{
        stormIntensity++;
      }
      case 4:{
        stormIntensity--;
      }
      case 5:{
        stormIntensity++;
      }
      case 6:{
        stormIntensity++;
      }
      case 7:{
        stormIntensity--;
      }
      case 8:{
        stormIntensity++;
      }
      case 9:{
        stormIntensity--;
      }
      case 10:{
        stormIntensity++;
      }
    }
    CreateTimer(1.0, RunWeatherSystem);
  }
  if(stormIntensity >= 16){
    canTornado = true;
  }
  else{
    canTornado = false;
  }
  return Plugin_Stop;
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
      PotatoLogger(LOG_DBG, "BLUE TANK IS DEPLOYING ITS BOMB.");
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

//Control map entities
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

//Cleanup
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
void PhaseChange(int reason){
  //ChkPt is where we are in the map. Valid range is 1-9.
  switch(ChkPt){
    case 0:{
      PotatoLogger(LOG_ERR, "PhaseChange at chkpt 0 received, check code?");
    }
    case 1:{
      //Payload enterred the cave
      if(reason == 2){
        curPhaseBlu = BGM3;
        CreateTimer(0.1, UpdateMusicBlu);
        CustomSoundEmitter(BGM3, BGMSNDLVL, true, 1, 1.0, 100, 3);
      }
      //Payload deployed
      else if(reason == 4){
        BGMINDEX = 2;
        stopForTeam = 3;
        RestartMusic();
        curSongRed = BGM4;
        curPhaseRed = BGM1;
        CreateTimer(0.1, UpdateMusicRed);
        CustomSoundEmitter(BGM1, BGMSNDLVL, true, 1, 0.05, 100, 2); //RED: Chaos Silence
        CustomSoundEmitter(BGM4, BGMSNDLVL, true, 1, 1.0, 100, 2); //RED: Chaos Hellish Blaze
      }
    }
    case 2:{
      //Payload deployed
      if(reason == 4){
        BGMINDEX = 3;
        stopForTeam = 2;
        RestartMusic();
        curSongBlu = BGM7;
        curPhaseBlu = BGM5;
        CreateTimer(0.1, UpdateMusicBlu);
        CustomSoundEmitter(BGM5, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Resolute Heart Silence
        CustomSoundEmitter(BGM7, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Resolute Heart 
      }
    }
    case 3:{

    }
    case 4:{ //Inferno plays to blue while pushing
      //Cart stopped
      if(reason == 0){
        curSongBlu = BGM9;
        curPhaseBlu = BGM10;
        CreateTimer(0.1, UpdateMusicBlu);
        CustomSoundEmitter(BGM9, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Apex pt1 Calm
        CustomSoundEmitter(BGM10, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Apex pt1 Inferno 
      }
      //Cart started
      else if(reason == 1){
        curSongBlu = BGM10;
        curPhaseBlu = BGM9;
        CreateTimer(0.1, UpdateMusicBlu);
        CustomSoundEmitter(BGM9, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Apex pt1 Calm
        CustomSoundEmitter(BGM10, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Apex pt1 Inferno 
      }
    }
    case 5:{
      if(reason == 3){//Inferno plays to blue when cart is on the bridge
        curSongBlu = BGM13;
        curPhaseBlu = BGM12;
        CreateTimer(0.1, UpdateMusicBlu);
        CustomSoundEmitter(BGM12, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: Apex pt2 Calm
        CustomSoundEmitter(BGM13, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: Apex pt2 Inferno 
      }
    }
    //CP 1
    case 6:{

    }
    //Int 1
    case 7:{

    }
    //Int 2
    case 8:{

    }
    //CP 2
    case 9:{
      //Cap Stopped
      if(reason == 0){
        curSongRed = BGM20;
        curPhaseRed = BGM22;
        curSongBlu = BGM21;
        curPhaseBlu = BGM23;
        CreateTimer(0.1, UpdateMusicBlu);
        CreateTimer(0.1, UpdateMusicRed);
        CustomSoundEmitter(BGM20, BGMSNDLVL, true, 1, 1.0, 100, 2); //RED: Immediate Threat XB3
        CustomSoundEmitter(BGM22, BGMSNDLVL, true, 1, 0.05, 100, 2); //RED: Immediate Threat Pre End XB3
        CustomSoundEmitter(BGM21, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: You Will Know Our Names Finale XBC3
        CustomSoundEmitter(BGM23, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: You Will Know Our Names Finale Pre End XBC3
      }
      //Cap Started
      else if(reason == 1){
        curSongRed = BGM22;
        curPhaseRed = BGM20;
        curSongBlu = BGM23;
        curPhaseBlu = BGM21;
        CreateTimer(0.1, UpdateMusicBlu);
        CreateTimer(0.1, UpdateMusicRed);
        CustomSoundEmitter(BGM20, BGMSNDLVL, true, 1, 0.05, 100, 2); //RED: Immediate Threat XB3
        CustomSoundEmitter(BGM22, BGMSNDLVL, true, 1, 1.0, 100, 2); //RED: Immediate Threat Pre End XB3
        CustomSoundEmitter(BGM21, BGMSNDLVL, true, 1, 0.05, 100, 3); //BLU: You Will Know Our Names Finale XBC3
        CustomSoundEmitter(BGM23, BGMSNDLVL, true, 1, 1.0, 100, 3); //BLU: You Will Know Our Names Finale Pre End XBC3
      }
    }
  }
}

void RestartMusic(){
  shouldMusicRestart = true;
}