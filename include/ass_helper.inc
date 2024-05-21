char LoggerDbg[512];
char LoggerInfo[256];
Database FB_Database;
float CircleAOEpos[][3] = {
  
};
float CircleAOErot[][3] = {

};
//All sound effects
char SFXArray[][64] = {
  "fartsy/misc/bell.wav", // 0
  "fartsy/misc/murica.mp3", // 1
  "fartsy/bl2/grenade_detonate.mp3", // 2
  "fartsy/gbombs5/t_12.mp3", // 3
  "fartsy/misc/majorkong.mp3", // 4
  "fartsy/vo/spongebob/boom.mp3", // 5
  "fartsy/misc/countdown.wav", // 6
  "fartsy/misc/fartsyscrusader_attack.mp3", // 7
  "items/cart_warning_single.wav", // 8 (DROPNUKE)
  "fartsy/ffxiv/bossfatejoin.mp3", // 9 (EVENTSTART)
  "fartsy/misc/explosiveparadise.mp3", // 10 (EXPLOSIVEPARADISE)
  "fartsy/vo/l4d2/billfall02.mp3", // 11 (FALLSND01-10)
  "fartsy/vo/l4d2/coachfall02.mp3",// 12
  "fartsy/vo/l4d2/ellisfall01.mp3", // 13
  "fartsy/vo/l4d2/francisfall02.mp3", // 14
  "fartsy/vo/l4d2/louisfall01.mp3", // 15
  "fartsy/vo/l4d2/louisfall03.mp3", // 16
  "fartsy/vo/l4d2/nickfall01.mp3", // 17
  "fartsy/vo/l4d2/zoeyfall01.mp3", // 18
  "fartsy/vo/ddd/woahhh.mp3", // 19
  "fartsy/vo/jigglypuff/jigglypuff.mp3", // 20
  "fartsy/vo/kirby/eeeahhhh.mp3", // 21
  "fartsy/vo/luigi/ohohohohoo.mp3", // 22
  "fartsy/vo/mario/wahahahaha.mp3", // 23
  "fartsy/vo/pika/pikapika.mp3", // 24
  "fartsy/vo/wario/wheee.mp3", // 25
  "fartsy/vo/mario/wowww.mp3", // 26
  "fartsy/weather/thunder1.wav", // 27 (GlobalThunder01-08)
  "fartsy/weather/thunder2.wav", // 28
  "fartsy/weather/thunder3.wav", // 29
  "fartsy/weather/thunder4.wav", // 30
  "fartsy/weather/thunder5.wav", // 31
  "fartsy/weather/thunder6.wav", // 32
  "fartsy/weather/thunder7.wav", // 33
  "fartsy/weather/thunder8.wav", // 34
  "fartsy/gbombs5/tsar_detonate.mp3", // 35 (HINDENBURGBOOM)
  "fartsy/vo/jeffy/hinden.wav", // 36 (HINDENCRASH)
  "fartsy/vo/ddo/koboldincoming.wav", // 37 (INCOMING)
  "fartsy/misc/antimatter.mp3", // 38 (OnslaughterLaserSND)
  "weapons/flame_thrower_start.wav", // 39 OnslaughterFlamePreATK
  "weapons/flame_thrower_end.wav", // 40 OnslaughterFlamePostATK
  "fartsy/ffxiv/return.mp3", // 41 RETURNSND
  "fartsy/ffxiv/returnsuccess.mp3", // 42 RETURNSUCCESS
  "fartsy/memes/babyshark/baby.mp3", // 43 SHARKSND01-08
  "fartsy/memes/babyshark/baby02.mp3", // 44
  "fartsy/memes/babyshark/doot01.mp3", // 45
  "fartsy/memes/babyshark/doot02.mp3", // 46
  "fartsy/memes/babyshark/doot03.mp3", // 47
  "fartsy/memes/babyshark/doot04.mp3", // 48
  "fartsy/memes/babyshark/shark.mp3", // 49
  "fartsy/memes/babyshark/shark02.mp3", // 50
  "fartsy/vo/fartsy/goobbue.mp3", // 51 SPEC01
  "fartsy/misc/shroom.mp3", // 52 SPEC02
  "fartsy/vo/inurat/nuclearwaffle.mp3", // 53 SPEC03
  "fartsy/misc/strongman_bell.wav", // 54 STRONGMAN
  "amongus/emergency.mp3", // 55 SUS
  "fartsy/misc/triggerscore.wav", // 56 TRIGGERSCORE
  "fartsy/ffxivvictoryedit.mp3", // 57 VICTORY
  "fartsy/vo/sephiroth/memory.mp3", // 58 VO_SEPHMEMORY
  "fartsy/misc/wtfboom.mp3", // 59 WTFBOOM
  "mvm/ambient_mp3/mvm_siren.mp3", // 60
  "fartsy/memes/priceisright_fail.wav", // 61
  "fartsy/eee/the_horn.wav", // 62
  "fartsy/misc/fartsyscrusader_bgm_locus.mp3", // 63
  "ambient/sawblade_impact1.wav", // 64
  "vo/sandwicheat09.mp3" // 65
};
//Return position
float Return[3] = {
  -3730.0,
  67.0,
  -252.0
};
Handle cvarSNDDefault = INVALID_HANDLE;
int soundPreference[MAXPLAYERS + 1];
//Default values per wave
enum struct DEFAULTS {
  bool defCanHWBoss;
  bool defCanTornado;
  int defBGMIndex;
  int defBombStatus;
  int defBombStatusMax;
  int defSacPointsMax;
}
DEFAULTS DefaultsArray[9];
//Core values
enum struct COREDATA {
  bool bgmPlaying;
  bool bombReset;
  bool brawler_emergency;
  bool canCrusaderNuke;
  bool canHindenburg;
  bool canHWBoss;
  bool canSENTMeteors;
  bool canSENTShark;
  bool canSENTStars;
  bool canSephNuke;
  bool canTornado;
  bool crusader;
  bool doFailsafe;
  bool isWave;
  bool monitorOn;
  bool monitorColor;
  bool sacrificedByClient;
  bool sephiroth;
  bool shouldStopMusic;
  bool tornado;
  bool tacobell;
  bool tickingClientHealth;
  bool tickMusic;
  bool tickOffset;
  bool TornadoWarningIssued;
  char cachedPath[64];
  char songName[64];
  float HWNMin;
  float HWNMax;
  int BGMINDEX;
  int FailedCount;
  int INCOMINGDISPLAYED;
  int camSel;
  int CodeEntry;
  int curWave;
  int failsafeCount;
  int lastAdmin;
  int refireTime;
  int sacPoints;
  int sacPointsMax;
  int SNDCHAN;
  int ticksMusic;
  int VIPBGM;
  int VIPIndex;
  int waveFlags;
}
COREDATA core;
//Annihilation supply shop entries
enum struct ASShop {
  char name[64];
  int price;
  int purchase;
}
ASShop ass[10];
//Bomb states (note to self, any additions made to this array for custom things like shop purchases or boss events should be at the END of the array, prioritize actual bombs first so as not to break anything in the event we add more bombs.. and remember to adjust bombstate[x].explode(false) in the .sp file)
enum struct BOMBSTATE {
  bool canHindenburg;
  bool canSENTStars;
  bool canSENTShark;
  bool isMoving;
  bool isNuclear;
  bool isReady;
  bool shouldFreezeBots;
  char explEnt[64];
  char explShake[64];
  char explSnd[64];
  char identifier[64];
  char name[64];
  float explDly;
  float explShakeDly;
  float FadeDly;
  float NukeStart;
  int sacVal;
  int state;
  int stateMax;
  int getCurBomb() {
    return RoundToFloor(this.state / 8.0);
  }
  int upperLimit() {
    return (this.state - 4);
  }
  void explode(bool realExplosion){
    Format(LoggerDbg, sizeof(LoggerDbg), "Exploding a %s - isRealExplosion: %d canHinden: %d, canStars: %d, canShark: %d, isNuclear: %d, shouldFreezeBots: %d, explEnt: %s, explShake: %s, explSnd: %s, identifier: %s, explDly: %f, explShakeDly: %f, fadeDly: %f, NukeStart: %f, sacVal: %i...", this.name, realExplosion, this.canHindenburg, this.canSENTStars, this.canSENTShark, this.isNuclear, this.shouldFreezeBots, this.explEnt, this.explShake, this.explSnd, this.identifier, this.explDly, this.explShakeDly, this.FadeDly, this.NukeStart, this.sacVal);
    AssLogger(0, LoggerDbg);
    //Freeze bots?
    if(this.shouldFreezeBots){
      ServerCommand("sm_freeze @blue 10");
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] Bots frozen by Bath Salts for 10 seconds.");
    }
    //Summon star storm
    if(this.canSENTStars){
      core.canSENTStars = true;
      CreateTimer(1.0, SENTStarTimer);
      CreateTimer(60.0, TimedOperator, 14);
    }
    //Holy jesus, it's a nuke!
    if(this.isNuclear){
      FireEntityInput("LargeExplosionSND", "PlaySound", "", this.NukeStart);
      FireEntityInput("NukeAll", "Enable", "", this.NukeStart);
      FireEntityInput("HurtAll", "AddOutput", "damagetype 262144", this.NukeStart);
      FireEntityInput("HurtAll", "AddOutput", "damage 2000000", this.NukeStart);
      FireEntityInput("HurtAll", "Enable", "", this.NukeStart+0.1);
      FireEntityInput("FB.Fade", "Fade", "", this.FadeDly);
      FastFire("OnUser1 NukeAll:Disable::3.0:1");
      FastFire("OnUser1 HurtAll:Disable::3.0:1");
      if(this.state == 64){
        CreateTimer(15.0, SpecTimer);
        ResetBombState();
      }
      if(this.canHindenburg){
        core.canHindenburg = true;
        FastFire("OnUser1 DeliveryBurg:Unlock::0.0:1");
        CPrintToChatAll("The {red}HINDENBURG {forestgreen}is now ready for flight!");
      }
    }
    FireEntityInput(this.explEnt, "Explode", "", this.explDly);
    CustomSoundEmitter(this.explSnd, 65, false, 0, 1.0, 100);
    FireEntityInput(this.explShake, "StartShake", "", this.explShakeDly);
    if(realExplosion){
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] %s {forestgreen}successfully deployed! {white}({limegreen}+%i pts{white})", this.name, this.sacVal);
      core.sacPoints += this.sacVal;
      CreateTimer(3.0, BombStatusAddTimer);
      CustomSoundEmitter(SFXArray[6], 65, false, 0, 1.0, 100);
      FireEntityInput("RareSpells", "Enable", "", 0.0);
    }
  }
}
BOMBSTATE bombState[9];
void ResetBombState(){
  bombState[0].state = 0;
  bombState[0].stateMax = 10;
}
//Bomb paths
char BOMBPATH[][32] = {
  "bombpath_right_prefer_flankers",
  "bombpath_left_prefer_flankers"
}
//Custom Bosses - For Sephiroth, index may vary because we don't want to be able to execute code that shouldn't be executed. Example SephBoss[5].attack would run code that's part of SephBoss[4].attack. Also, this.fireCount is how many times FastFire should run, as well being added to this.index to determine what it does.
enum struct CUSTOMBOSS {
  bool shouldNuke;
  char ChatMessage[128];
  char fireString[128];
  char sound[64];
  int index;
  int fireCount;
  void attack(){
    if(this.shouldNuke) {
      CreateTimer(1.0, NukeTimer);
      CreateTimer(7.0, TimedOperator, 11);
      core.canSephNuke = true;
    }
    if (!StrEqual(this.ChatMessage, "")) CPrintToChatAll(this.ChatMessage);
    for (int i = 0; i < this.fireCount; i++) FastFire(this.fireString[this.index+i]);
  }
}
CUSTOMBOSS SephBoss[12];
CUSTOMBOSS HWBoss[12];
CUSTOMBOSS Onslaughter[10];
//Configure all variables
void SetupCoreData(){
  AssLogger(1, "Setting up core data...");
  ass[0].name = "[10] Kissone Bath Salts";
  ass[1].name = "[20] Summon Goobbue or Kirby";
  ass[2].name = "[30] Robot Trap (Wave Fail-safe)";
  ass[3].name = "[40] Explosives Paradise";
  ass[4].name = "[50] Banish Tornadoes";
  ass[5].name = "[60] Ass Gas";
  ass[6].name = "[70] Instant Fat Man";
  ass[7].name = "[80] Meteorites";
  ass[8].name = "[90) 300,000 UbUp Cash";
  ass[9].name = "[100] Professor Fartsalot";
  for (int i = 0; i < sizeof(ass); i++) ass[i].price = 10 + (10 * i);
  for (int i = 0; i < sizeof(ass); i++) ass[i].purchase = 30 + i;
  bombState[8].canHindenburg = true;
  bombState[4].canSENTStars = true;
  bombState[6].canSENTShark = true;
  bombState[5].explDly = 1.7;
  bombState[1].explEnt = "SmallExplosion";
  bombState[2].explEnt = "MediumExplosion";
  bombState[3].explEnt = "MediumExplosion";
  bombState[4].explEnt = "MediumExplosion";
  bombState[5].explEnt = "LargeExplosion";
  bombState[6].explEnt = "LargeExplosion";
  bombState[7].explEnt = "LargeExplosion";
  bombState[8].explEnt = "LargeExplosion";
  bombState[1].explShake = "SmallExploShake";
  bombState[2].explShake = "MedExploShake";
  bombState[3].explShake = "MedExploShake";
  bombState[4].explShake = "MedExploShake";
  bombState[5].explShake = "LargeExploShake";
  bombState[6].explShake = "LargeExploShake";
  bombState[7].explShake = "LargeExploShake";
  bombState[8].explShake = "LargeExploShake";
  bombState[5].explShakeDly = 1.7;
  bombState[1].explSnd = SFXArray[1];
  bombState[2].explSnd = SFXArray[2];
  bombState[3].explSnd = SFXArray[2];
  bombState[4].explSnd = SFXArray[2];
  bombState[5].explSnd = SFXArray[4];
  bombState[6].explSnd = SFXArray[3];
  bombState[7].explSnd = SFXArray[35];
  bombState[8].explSnd = SFXArray[35];
  bombState[1].identifier = "Bombs.FreedomBomb";
  bombState[2].identifier = "Bombs.ElonBust";
  bombState[3].identifier = "Bombs.BathSalts";
  bombState[4].identifier = "Bombs.FallingStar";
  bombState[5].identifier = "Bombs.MajorKong";
  bombState[6].identifier = "Bombs.SharkTorpedo";
  bombState[7].identifier = "Bombs.FatMan";
  bombState[8].identifier = "Bombs.Hydrogen";
  bombState[0].isMoving = false;
  bombState[5].isNuclear = true;
  bombState[7].isNuclear = true;
  bombState[8].isNuclear = true;
  bombState[5].NukeStart = 1.7;
  bombState[0].isReady = false;
  bombState[1].name = "{red}FREEDOM BOMB{white}";
  bombState[2].name = "{red}ELON BUST{white}";
  bombState[3].name = "{orange}BATH SALTS{white}";
  bombState[4].name = "{gold}FALLING STAR{white}";
  bombState[5].name = "{red}MAJOR KONG{white}";
  bombState[6].name = "{aqua}SHARK{white}";
  bombState[7].name = "{orange}FAT MAN{white}";
  bombState[8].name = "{red}HYDROGEN{white}";
  bombState[1].sacVal = 5;
  bombState[2].sacVal = 5;
  bombState[3].sacVal = 5;
  bombState[4].sacVal = 10;
  bombState[5].sacVal = 15;
  bombState[6].sacVal = 20;
  bombState[7].sacVal = 25;
  bombState[8].sacVal = 50;
  bombState[3].shouldFreezeBots = true;
  bombState[0].state = 0;
  bombState[0].stateMax = 0;
  //Per Wave options
  DefaultsArray[0].defCanHWBoss = false;
  DefaultsArray[1].defCanHWBoss = false;
  DefaultsArray[2].defCanHWBoss = false;
  DefaultsArray[3].defCanHWBoss = true;
  DefaultsArray[4].defCanHWBoss = true;
  DefaultsArray[5].defCanHWBoss = true;
  DefaultsArray[6].defCanHWBoss = true;
  DefaultsArray[7].defCanHWBoss = true;
  DefaultsArray[8].defCanHWBoss = true;
  DefaultsArray[0].defCanTornado = false;
  DefaultsArray[1].defCanTornado = false;
  DefaultsArray[2].defCanTornado = false;
  DefaultsArray[3].defCanTornado = true;
  DefaultsArray[4].defCanTornado = true;
  DefaultsArray[5].defCanTornado = true;
  DefaultsArray[6].defCanTornado = true;
  DefaultsArray[7].defCanTornado = true;
  DefaultsArray[8].defCanTornado = true;
  DefaultsArray[0].defBGMIndex = 1;
  DefaultsArray[1].defBGMIndex = 5;
  DefaultsArray[2].defBGMIndex = 6;
  DefaultsArray[3].defBGMIndex = 7;
  DefaultsArray[4].defBGMIndex = 8;
  DefaultsArray[5].defBGMIndex = 12;
  DefaultsArray[6].defBGMIndex = 13;
  DefaultsArray[7].defBGMIndex = 14;
  DefaultsArray[8].defBGMIndex = 15;
  DefaultsArray[0].defBombStatus = 0;
  DefaultsArray[1].defBombStatus = 4;
  DefaultsArray[2].defBombStatus = 7;
  DefaultsArray[3].defBombStatus = 8;
  DefaultsArray[4].defBombStatus = 12;
  DefaultsArray[5].defBombStatus = 14;
  DefaultsArray[6].defBombStatus = 20;
  DefaultsArray[7].defBombStatus = 28;
  DefaultsArray[8].defBombStatus = 30;
  DefaultsArray[0].defBombStatusMax = 0;
  DefaultsArray[1].defBombStatusMax = 10;
  DefaultsArray[2].defBombStatusMax = 18;
  DefaultsArray[3].defBombStatusMax = 26;
  DefaultsArray[4].defBombStatusMax = 34;
  DefaultsArray[5].defBombStatusMax = 42;
  DefaultsArray[6].defBombStatusMax = 50;
  DefaultsArray[7].defBombStatusMax = 58;
  DefaultsArray[8].defBombStatusMax = 66;
  DefaultsArray[0].defSacPointsMax = 0;
  DefaultsArray[1].defSacPointsMax = 50;
  DefaultsArray[2].defSacPointsMax = 60;
  DefaultsArray[3].defSacPointsMax = 70;
  DefaultsArray[4].defSacPointsMax = 80;
  DefaultsArray[5].defSacPointsMax = 90;
  DefaultsArray[6].defSacPointsMax = 100;
  DefaultsArray[7].defSacPointsMax = 100;
  DefaultsArray[8].defSacPointsMax = 100;
  core.bgmPlaying = false;
  core.bombReset = false;
  core.brawler_emergency = false;
  core.canCrusaderNuke = false;
  core.canHindenburg = false;
  core.canHWBoss = false;
  core.canSENTMeteors = false;
  core.canSENTShark = false;
  core.canSENTStars = false;
  core.canSephNuke = false;
  core.canTornado = false;
  core.crusader = false;
  core.doFailsafe = false;
  core.isWave = false;
  core.monitorOn = false;
  core.monitorColor = true;
  core.sacrificedByClient = false;
  core.sephiroth = false;
  core.shouldStopMusic = false;
  core.tornado = false;
  core.tacobell = false;
  core.tickingClientHealth = false;
  core.tickMusic = false;
  core.tickOffset = false;
  core.TornadoWarningIssued = false;
  core.cachedPath = "null";
  core.songName = "null";
  core.BGMINDEX = 1;
  core.FailedCount = 0;
  core.INCOMINGDISPLAYED = 0;
  core.camSel = 0;
  core.CodeEntry = 0;
  core.curWave = 0;
  core.failsafeCount = -1;
  core.lastAdmin = 0;
  core.refireTime = 0;
  core.sacPoints = 0;
  core.sacPointsMax = 60;
  core.SNDCHAN = 6;
  core.ticksMusic = 0;
  core.VIPBGM = -1;
  core.VIPIndex = 0;
  core.waveFlags = 0;
  core.HWNMin = 210.0;
  core.HWNMax = 380.0;
  AssLogger(1, "Setting up bosses...");
  HWBoss[0].index = 0;
  HWBoss[0].fireCount = 2;
  HWBoss[0].fireString = "OnUser1 hhh_maker:ForceSpawn::0.0:1";
  HWBoss[1].index = 2;
  HWBoss[1].fireString = "OnUser1 hhh_maker2:ForceSpawn:0.0:1";
  HWBoss[2].index = 3;
  HWBoss[2].fireCount = 1;
  HWBoss[2].fireString = "OnUser1 monoculus_maker:ForceSpawn:0.0:1";
  HWBoss[3].index = 4;
  HWBoss[3].fireCount = 3;
  HWBoss[3].fireString = "OnUser1 hhh_maker2:ForceSpawn:0.0:1";
  HWBoss[4].index = 7;
  HWBoss[4].fireString = "OnUser1 SkeleSpawner:Enable:0.0:1";
  HWBoss[5].index = 8; 
  HWBoss[5].fireString = "OnUser1 SkeleSpawner:Disable:20.0:1";
  HWBoss[6].index = 5; //Does this access HWBoss[4]?
  HWBoss[6].fireCount=2;//Does this disable skelespawner after enabling it?...
  HWBoss[7].index = 8;
  HWBoss[7].fireString = "OnUser1 merasmus_maker:ForceSpawn::0.0:1";
  HWBoss[7].fireCount = 3;
  HWBoss[8].index = 11;
  HWBoss[8].fireCount = 2;
  HWBoss[8].fireString = "OnUser1 hhh_maker2:ForceSpawn:0.0:1";
  HWBoss[9].index = 12;
  HWBoss[9].fireString = "OnUser1 monoculus_maker:ForceSpawn:0.0:1";
  HWBoss[10].index = 0;
  HWBoss[10].fireCount = 2;
  HWBoss[10].fireString = "OnUser1 merasmus_maker:ForceSpawn::0.0:1";
  HWBoss[11].index = 2;
  HWBoss[11].fireString = "OnUser1 monoculus_maker:ForceSpawn:0.0:1";
  HWBoss[11].fireCount = 1;
  SephBoss[0].index = 0;
  SephBoss[0].fireCount = 0;
  SephBoss[0].shouldNuke = true;
  SephBoss[1].fireString = "OnUser1 SephMeteor:ForceSpawn::0.0:1";
  SephBoss[1].ChatMessage = "{blue}Sephiroth: Say goodbye!";
  SephBoss[1].index = 2;
  SephBoss[1].fireCount = 1;
  SephBoss[2].fireString = "OnUser1 SephNuke:ForceSpawn::0.0:1";
  SephBoss[2].index = 3;
  SephBoss[2].fireCount = 1;
  SephBoss[2].sound = SFXArray[8];
  SephBoss[3].fireString = "OnUser1 SephRocketSpammer:FireMultiple:50:0.0:1";
  SephBoss[3].index = 4;
  SephBoss[3].fireCount = 4;
  SephBoss[4].index = 3;
  SephBoss[4].fireCount = 3;
  SephBoss[4].fireString = "OnUser1 SephRocketSpammer:FireMultiple:10:3.0:1";
  SephBoss[5].index = 9;
  SephBoss[5].fireCount = 2;
  SephBoss[5].fireString = "OnUser1 SephRocketSpammer:FireMultiple:10:5.0:1";
  SephBoss[6].index = 9;
  SephBoss[6].fireCount = 2;
  SephBoss[6].fireString = "OnUser1 SkeleSpawner:Enable::0.0:1";
  SephBoss[7].index = 3;
  SephBoss[7].fireCount = 3;
  SephBoss[7].fireString = "OnUser1 SkeleSpawner:Disable::20.0:1";
  SephBoss[8].index = 4;
  SephBoss[8].fireCount = 1;
  SephBoss[9].index = 11;
  SephBoss[9].fireCount = 2;
  SephBoss[9].fireString = "OnUser1 SephRocketSpammer:FireOnce::0.0:1";
  SephBoss[10].index = 12;
  SephBoss[10].fireCount = 1;
  SephBoss[10].fireString = "OnUser1 SephRocketSpammer:FireOnce::5.0:1";
  SephBoss[11].index = 3;
  SephBoss[11].fireCount = 4;
  AssLogger(1, "Hooking game events...");
  HookEvent("player_death", EventDeath);
  HookEvent("player_spawn", EventSpawn);
  HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre);
  HookEvent("mvm_wave_complete", EventWaveComplete);
  HookEvent("mvm_wave_failed", EventWaveFailed);
  HookEvent("mvm_bomb_alarm_triggered", EventWarning);
  HookEventEx("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
  AssLogger(1, "Core data setup complete!");
}
//Messages to be printed when the fail safe has been triggered.
char failsafe[][256] = {
  "{orange}Phoenix♥ {white}: FAILSAFE HAS BEEN TRIGGERED. ROBOT EXTERMINATION IN PROGRESS. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Nice try. You think this is funny? How about THIS instead? [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: (╯°□°）╯︵ ¡¡¡pƎ⅄O˥ԀƎp Ǝq O┴ ┴∩Oq∀ SI SS∀ S,ɹOSSƎℲOɹԀ [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Flips a coin and... HEADS! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Pwofessow's b-butt is a-about to be depwoyed!!! JUST KIDDING - GET FUCKED. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: We aren't so different, you and I. Oh wait, yes we are. You're a pile of scrap and I'm actually useful! :> [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: *BZZT* Sorry, time's up! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: It's only me and you, who is gonna save you now? [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Nope. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Sometimes I even amaze myself. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Some disassembly required. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Oops, I did it again! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Not on my watch! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Sometimes you scare me! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: You know, I never really thought about it. [Failsafe Activated]"
};
//Silence cvar changes to minimize chat spam.
public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast) {
  event.BroadcastDisabled = true;
  return Plugin_Handled;
}

//Idle advertisements in chat
char AdvMessage[][256] = {
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}We have a Discord server: {forestgreen}https://discord.com/invite/SkHaeMH",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}Remember to buy your upgrades using {forestgreen}!buy",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}You may invoke {forestgreen}!sounds {white}to configure what sounds you hear from the plugin, or {forestgreen}!stats{white} to see your stats.",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}Advanced users may quick buy upgrades using {forestgreen}!qbuy",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}You may invoke {forestgreen}!sacpoints {white}to spend {forestgreen}sacrifice points{white} for many special abilities, including disabling the tornado!",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}TIP: As a {red}DEFENDER{white}, pushing your team's {forestgreen}payload {white}is crucial to wrecking havoc on the robots!",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}Remember, if someone is being abusive, you may always invoke {forestgreen}!calladmin{white}.",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}You may always invoke {forestgreen}!return{white} to be returned to spawn.",
  ""
};
//Registry of all playable classes, used for stats module
char ClassDefinitions[][32] = {
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
//Random death messages
char DeathMessage[][64] = {
  "YEETED OUT INTO ORBIT",
  "SENT TO SPACE VIA TORNADO",
  "LAUNCHED ACROSS THE SKY",
  "SWALLOWED BY A STORM THAT WAS APPROACHING",
  "REDUCED TO DEBRIS",
  "FARTED INTO THE SKY",
  ""
};
//Scripted entities, used for spawning in extra entities mid wave.
char FB_SENT[][64] = {
  "FB.SentMeteor01",
  "FB.SentMeteor02",
  "FB.SentMeteor03",
  "FB.SentMeteor04",
  "FB.SentMeteor05",
  "FB.SentNuke01",
  "FB.SentNuke02",
  "FB.SentNuke03",
  "FB.SentNuke04",
  "FB.SentNuke05",
  "FB.SentStar01",
  "FB.SentStar02",
  "FB.SentStar03",
  "FB.SentStar04",
  "FB.SentStar05",
  ""
};
//Sound preference menu
char sndPrefs[][128] = {
  "Sounds are currently DISABLED.",
  "Sounds are currently MUSIC ONLY.",
  "Sounds are currently SOUND EFFECTS ONLY.",
  "Sounds are currently ALL ON.",
  "Somehow your sound preference was stored as non-existent 5... Please configure your sounds."
};
//Taco bell's default BGM indexes
int tacoBellBGMIndex[] = {
  1,
  17,
  6,
  7,
  8,
  12,
  13,
  14,
  15
};
//RT camera system
char SelectedCamera[][32] = {
  "CAM.Front",
  "CAM.Mid",
  "CAM.MidTwo",
  "CAM.Rear",
  "CAM.Kissone"
};
//Easter eggs
char SpecEnt[][24] = {
  "Spec.Goobbue",
  "Spec.Waffle",
  "Spec.Burrito",
  "Spec.Shroom",
  "Spec.BlueBall",
  "Spec*"
};
//Strike targets for lightning
char StrikeAt[][40] = {
  "OnUser1:LightningHurt00:Enable::0.0:1",
  "OnUser1:LightningHurt01:Enable::0.0:1",
  "OnUser1:LightningHurt02:Enable::0.0:1",
  "OnUser1:LightningHurt03:Enable::0.0:1",
  "OnUser1:LightningHurt04:Enable::0.0:1",
  "OnUser1:LightningHurt05:Enable::0.0:1",
  "OnUser1:LightningHurt06:Enable::0.0:1",
  "OnUser1:LightningHurt07:Enable::0.0:1",
  "OnUser1:LightningHurt08:Enable::0.0:1",
  "OnUser1:LightningHurt09:Enable::0.0:1",
  "OnUser1:LightningHurt0A:Enable::0.0:1",
  "OnUser1:LightningHurt0B:Enable::0.0:1",
  "OnUser1:LightningHurt0C:Enable::0.0:1",
  "OnUser1:LightningHurt0D:Enable::0.0:1",
  "OnUser1:LightningHurt0E:Enable::0.0:1",
  "OnUser1:LightningHurt0F:Enable::0.0:1"
};
//test code
char TBGM0[16] = "test/bgm0.mp3";
char TBGM1[16] = "test/bgm1.mp3";
char TBGM2[16] = "test/bgm2.mp3";
char TBGM3[16] = "test/bgm3.mp3";
char TBGM4[16] = "test/bgm4.mp3";
char TBGM5[16] = "test/bgm5.mp3";
char TBGM6[16] = "test/bgm6.mp3";
//Check if the client is valid
stock bool IsValidClient(int client) {
  return (0 < client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client));
}
//Register our commands.
void RegisterAllCommands(){
  AssLogger(1, "Registering commands...");
  RegServerCmd("fb_operator", Command_Operator, "Serverside only. Does nothing when executed as client.");
  RegAdminCmd("sm_music", Command_Music, ADMFLAG_RESERVATION, "Set music to be played for the next wave");
  RegConsoleCmd("sm_bombstatus", Command_FBBombStatus, "Check bomb status");
  RegConsoleCmd("sm_song", Command_GetCurrentSong, "Get current song name");
  RegConsoleCmd("sm_stats", Command_MyStats, "Print current statistics");
  RegConsoleCmd("sm_return", Command_Return, "Return to Spawn");
  RegConsoleCmd("sm_sacpoints", Command_SacrificePointShop, "Fartsy's Annihilation Supply Shop");
  RegConsoleCmd("sm_discord", Command_Discord, "Join our Discord server!");
  RegConsoleCmd("sm_sounds", Command_Sounds, "Toggle sounds on or off via menu");
}
//Connect to database
public void OnConfigsExecuted() {
  if (!FB_Database) Database.Connect(Database_OnConnect, "ass");
}
//Format database if needed
public void Database_OnConnect(Database db, char[] error, any data) {
  if (!db) {
    AssLogger(3, error);
    return;
  }
  char buffer[64];
  db.Driver.GetIdentifier(buffer, sizeof(buffer));
  if (!StrEqual(buffer, "mysql", false)) {
    delete db;
    AssLogger(3, "Could not connect to the database: expected mysql database.");
    return;
  }
  FB_Database = db;
  FB_Database.Query(Database_FastQuery, "CREATE TABLE IF NOT EXISTS ass_activity(name TEXT, steamid INT UNSIGNED, date DATE, seconds INT UNSIGNED DEFAULT '0', class TEXT DEFAULT 'na', health TEXT DEFAULT '-1', maxHealth INT UNSIGNED DEFAULT '0', damagedealt INT UNSIGNED DEFAULT '0', damagedealtsession INT UNSIGNED DEFAULT '0', kills INT UNSIGNED DEFAULT '0', killssession INT UNSIGNED DEFAULT '0', deaths INT UNSIGNED DEFAULT '0', deathssession INT UNSIGNED DEFAULT '0', bombsreset INT UNSIGNED DEFAULT '0', bombsresetsession INT UNSIGNED DEFAULT '0', sacrifices INT UNSIGNED DEFAULT '0', sacrificessession INT UNSIGNED DEFAULT '0', lastkilledname TEXT DEFAULT 'na', lastweaponused TEXT DEFAULT 'na', killedbyname TEXT DEFAULT 'na', killedbyweapon TEXT DEFAULT 'na', soundprefs INT UNSIGNED DEFAULT '3', PRIMARY KEY (steamid));");
  if (GetClientCount(true) > 0){
    for (int i = 0; i <= MaxClients; i++){
      if (!IsValidClient(i)) continue;
      char query[256];
      Format(query, sizeof(query), "SELECT soundprefs FROM ass_activity WHERE steamid = '%i';", GetSteamAccountID(i));
      FB_Database.Query(SQL_SNDPrefs, query, i);
    }
  }
}
//Database Fastquery Manager
public void Database_FastQuery(Database db, DBResultSet results,
  const char[] error, any data) {
  if (!results) LogError("Failed to query database: %s", error);
}
public void Database_MergeDataError(Database db, any data, int numQueries,
  const char[] error, int failIndex, any[] queryData) {
  LogError("Failed to query database (transaction): %s", error);
}
//Calculate time spent on server in seconds
int GetClientMapTime(int client) {
  float clientTime = GetClientTime(client), gameTime = GetGameTime();
  if (clientTime > gameTime) {
    return RoundToZero(gameTime);
  }
  return RoundToZero(clientTime);
}
//Find an entity by its target name
int FindEntityByTargetname(char[] targetname, char[] classname)
{
  char namebuf[32];
  int index = -1;
  namebuf[0] = '\0';
 
  while(strcmp(namebuf, targetname) != 0 && (index = FindEntityByClassname(index, classname)) != -1){
    GetEntPropString(index, Prop_Data, "m_iName", namebuf, sizeof(namebuf));
    PrintToServer("Found %s, index %i", namebuf, index);
  }
  return(index);
}

//Get a client's health
stock int TF2_GetPlayerMaxHealth(int client) {
  return GetEntProp(GetPlayerResourceEntity(), Prop_Send, "m_iMaxHealth", _, client);
}

enum struct BGM {
  char realPath[64];
  char songName[64];
  int refireTime;
  int ticksOffset;
  int SNDLVL;
}
BGM BGMArray[32];

void RegisterAndPrecacheAllFiles(){
  AssLogger(0, "Loading EVERYTHING to RAM...");
  Handle confBGM = OpenFile("addons/sourcemod/configs/FartsysAss/Files/music.ini", "rt", false);
  char bufferBGM[256];
  int bgmIndex;
  int bgmNameIndex = -1;
  int bgmRefire;
  int bgmOffset;
  int bgmVol;
  if(confBGM == INVALID_HANDLE) return;
  while (ReadFileLine(confBGM, bufferBGM, sizeof(bufferBGM))){
    TrimString(bufferBGM);
    if (!StrContains(bufferBGM, "Path:")){
      bgmIndex++;
      ReplaceString(bufferBGM, sizeof(bufferBGM), "Path:", "", true);
      Format(BGMArray[bgmIndex].realPath, 64, bufferBGM);
    }
    else if (!StrContains(bufferBGM, "Title:")){
      bgmNameIndex++;
      ReplaceString(bufferBGM, sizeof(bufferBGM), "Title:", "", true);
      Format(BGMArray[bgmNameIndex].songName, 128, bufferBGM);
    }
    else if (!StrContains(bufferBGM, "RefireTime:")){
      bgmRefire++;
      ReplaceString(bufferBGM, sizeof(bufferBGM), "RefireTime:", "", true);
      BGMArray[bgmRefire].refireTime = StringToInt(bufferBGM);
    }
    else if (!StrContains(bufferBGM, "OffsetTicks:")){
      bgmOffset++;
      ReplaceString(bufferBGM, sizeof(bufferBGM), "OffsetTicks:", "", true);
      BGMArray[bgmOffset].ticksOffset = StringToInt(bufferBGM);
    }
    else if (!StrContains(bufferBGM, "Volume:")){
      bgmVol++;
      ReplaceString(bufferBGM, sizeof(bufferBGM), "Volume:", "", true);
      BGMArray[bgmVol].SNDLVL = StringToInt(bufferBGM);
    }
    if (IsEndOfFile(confBGM)) break;
  }
  PrintToServer("Precaching BGMs...");
  if(confBGM != INVALID_HANDLE){
		CloseHandle(confBGM);
	}
  for (int i = 1; i < sizeof(BGMArray); i++){ //We start at index 1 because index 0 is used for restoring default bgm in the VIP music menu...
   if(!StrEqual(BGMArray[i].realPath, "")){ 
    Format(LoggerDbg, sizeof(LoggerDbg), "Precaching BGM: %s (%s), Duration %i ticks, Start Loop Point %i ticks, Volume %i   @ %i", BGMArray[i].songName, BGMArray[i].realPath, BGMArray[i].refireTime, BGMArray[i].ticksOffset, BGMArray[i].SNDLVL, i);
    AssLogger(0, LoggerDbg);
    PrecacheSound(BGMArray[i].realPath, true);
   }
  }
  for (int i = 0; i < sizeof(SFXArray); i++){
    Format(LoggerDbg, sizeof(LoggerDbg), "Precaching SFX: %s in position %i", SFXArray[i], i);
    AssLogger(0, LoggerDbg);
    PrecacheSound(SFXArray[i], true);
  }
  Format(LoggerInfo, sizeof(LoggerInfo), "Done! BGM Count: %i, SFX Count: %i, Total: %i files loaded to RAM.", sizeof(BGMArray) - 1, sizeof(SFXArray), (sizeof(BGMArray) + sizeof(SFXArray)) - 1);
  AssLogger(1, LoggerInfo);
  //Todo: These files are not part of the base pakfile, they are slated for install in a future update, when that update is ready, these files will eventually become one with the map.
  PrecacheSound(TBGM0, true);
  PrecacheSound(TBGM2, true);
  PrecacheSound(TBGM3, true);
  PrecacheSound(TBGM4, true);
  PrecacheSound(TBGM5, true);
  PrecacheSound(TBGM6, true);
  
}

//Used to keep StopSound from stopping the music we're trying to play - now with support for loop offsets!
public Action SyncMusic(Handle timer) {
  core.cachedPath = BGMArray[core.BGMINDEX].realPath;
  core.tickOffset = (BGMArray[core.BGMINDEX].ticksOffset > 0 ? true : false);
  Format(LoggerInfo, sizeof(LoggerInfo), "We are on wave %i, now playing: %s (from %s) for %i ticks. It will start looping at %i ticks.", core.curWave, core.songName, BGMArray[core.BGMINDEX].realPath, core.refireTime, BGMArray[core.BGMINDEX].ticksOffset);
  AssLogger(1, LoggerInfo);
  return Plugin_Stop;
}
//Crusader attack script
char CrusaderBrrr[][] = {
  "OnUser1 FB.BOOM:StopShake::3.0:1",
  "OnUser1 FB.CRUSADER:Enable::25.20:1",
  "OnUser1 CrusaderTrain:StartForward::25.20:1",
  "OnUser1 CrusaderLaserBase*:StartForward::25.20:1",
  "OnUser1 CrusaderTrain:SetSpeed:0.9:38.0:1",
  "OnUser1 CrusaderTrain:SetSpeed:0.7:38.60:1",
  "OnUser1 CrusaderTrain:SetSpeed:0.5:39.20:1",
  "OnUser1 CrusaderTrain:SetSpeed:0.3:40.40:1",
  "OnUser1 CrusaderTrain:SetSpeed:0.1:41.40:1",
  "OnUser1 CrusaderTrain:Stop::42.60:1",
  "OnUser1 FB.CrusaderLaserKill01:Disable::42.60:1",
  "OnUser1 FB.LaserCore:TurnOn::45.80:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:0.35:45.80:1",
  "OnUser1 FB.ShakeCore:StartShake::45.80:1",
  "OnUser1 CrusaderSprite:Color:255 128 128:45.80:1",
  "OnUser1 FB.ShakeCore:StopShake::48.80:1",
  "OnUser1 FB.LaserInnerMost:TurnOn::49.20:1",
  "OnUser1 FB.ShakeInner:StartShake::49.20:1",
  "OnUser1 CrusaderSprite:Color:255 230 230:49.20:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:0.35:50.20:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:0.45:50.60:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:0.55:51.0:1",
  "OnUser1 FB.ShakeInner:StopShake::52.10:1",
  "OnUser1 FB.ShakeInner:StartShake::52.20:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:0.45:54.0:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:0.4:54.40:1",
  "OnUser1 FB.ShakeInner:StopShake::55.0:1",
  "OnUser1 FB.ShakeInner:StartShake::55.10:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:0.75:57.20:1",
  "OnUser1 FB.CrusaderSideLaser:TurnOn::57.20:1",
  "OnUser1 FB.ShakeInner:StopShake::58.0:1",
  "OnUser1 FB.ShakeInner:StartShake::58.10:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:1:58.50:1",
  "OnUser1 CrusaderLaserBase*:SetSpeed:0.75:60.80:1",
  "OnUser1 CrusaderLaserBase:SetSpeed:0.65:61.10:1",
  "OnUser1 CrusaderLaserBase:SetSpeed:0.55:61.40:1",
  "OnUser1 FB.LaserCore:TurnOff::61.40:1",
  "OnUser1 FB.LaserInnerMost:TurnOff::61.40:1",
  "OnUser1 CrusaderSprite:Color:0 0 0:61.40:1",
  "OnUser1 CrusaderLaserBase:SetSpeed:0.45:61.70:1",
  "OnUser1 CrusaderLaserBase:SetSpeed:0.3:62.0:1",
  "OnUser1 CrusaderLaserBase:SetSpeed:0.15:62.30:1",
  "OnUser1 FB.CrusaderSideLaser:TurnOff::62.30:1",
  "OnUser1 CrusaderLaserBase*:Stop::62.70:1",
  "OnUser1 FB.Laser*:TurnOn::65.20:1",
  "OnUser1 CrusaderLaserBase*:StartForward::65.20:1",
  "OnUser1 CrusaderLaserBase:SetSpeed:1:65.20:1",
  "OnUser1 FB.ShakeBOOM:StartShake::65.20:1",
  "OnUser1 FB.Fade:Fade::65.20:1",
  "OnUser1 HurtAll:AddOutput:damagetype 1024:65.10:1",
  "OnUser1 HurtAll:AddOutput:damage 2000000:65.10:1",
  "OnUser1 HurtAll:Enable::65.20:1",
  "OnUser1 FB.CrusaderSideLaser:TurnOn::65.20:1",
  "OnUser1 CrusaderSprite:Color:255 230 255:65.20:1",
  "OnUser1 FB.Laser*:TurnOff::70.0:1",
  "OnUser1 CrusaderTrain:StartForward::70.0:1",
  "OnUser1 CrusaderLaserBase*:Stop::70.0:1",
  "OnUser1 HurtAll:Disable::70.0:1",
  "OnUser1 FB.CrusaderSideLaser:TurnOff::70.0:1",
  "OnUser1 CrusaderSprite:Color:0 0 0:70.0:1",
  "OnUser1 FB.ShakeBOOM:StopShake::70.20:1",
  "OnUser1 CrusaderTrain:Stop::80.0:1",
  "OnUser1 FB.CRUSADER:Disable::80.0:1"
};

char lightning[][] = {
  "OnUser1 lightning:TurnOn::0.0:1",
  "OnUser1 value:TurnOff::0.0:1",
  "OnUser1 weather:Skin:4:0.0:1",
  "OnUser1 LightningLaser:TurnOn::0.0:1",
  "OnUser1 lightning:TurnOff::0.1:1",
  "OnUser1 weather:Skin:3:0.1:1",
  "OnUser1 LightningLaser:TurnOff::0.1:1",
  "OnUser1 lightning:TurnOn::0.17:1",
  "OnUser1 weather:Skin:4:0.17:1",
  "OnUser1 LightningLaser:TurnOn::0.17:1",
  "OnUser1 lightning:TurnOff::0.25:1",
  "OnUser1 LightningLaser:TurnOff::0.25:1",
  "OnUser1 weather:Skin:3:0.25:1"
};

char TornadoLogic[][] = {
  "OnUser1 TornadoKill:Enable::0.0:1",
  "OnUser1 tornadobutton:Lock::0.0:1",
  "OnUser1 tornadof1:start::20.0:1",
  "OnUser1 shaketriggerf1:Enable::20.0:1",
  "OnUser1 tornadowindf1:PlaySound::20.0:1",
  "OnUser1 tornadof1wind:Enable::21.50:1",
  "OnUser1 tornadof1:stop::0.0:1",
  "OnUser1 TornadoKill:Disable::0.0:1",
  "OnUser1 tornadof1wind:Disable::0.0:1",
  "OnUser1 tornadowindf1:StopSound::0.0:1",
  "OnUser1 shaketriggerf1:Disable::0.0:1",
  "OnUser1 tornadobutton:Unlock::30.0:1",
  "OnUser1 FB.FakeTankTank01:Kill::0.0:1",
  "OnUser1 FB.FakeTankPhys01:Kill::0.0:1"
};
char WaveSetup[][] = {
  "OnUser1 bombpath_right_arrows:Disable::0.1:1", //Disable right arrows
  "OnUser1 bombpath_left_arrows:Disable::0.1:1", //Disable left arrows
  "OnUser1 Classic_Mode_Intel1:Enable::0.0:1", //Activate Intel 1
  "OnUser1 Classic_Mode_Intel2:Enable::0.0:1", //Activate Intel 2
  "OnUser1 CommonSpells:Enable::0.0:1", // Activate common spells
  "OnUser1 rain:Alpha:200:0.0:1", //Activate rain
  "OnUser1 OldSpawn:Enable::0.0:1", //Activate Old Spawn
  "OnUser1 NewSpawn:Disable::0.0:1", //De-activate New Spawn
  "OnUser1 rain:Alpha:200::0.0:1", // activate rain
  "OnUser1 Classic_Mode_Intel1:Enable::0.0:1", //enable intel 1
  "OnUser1 Classic_Mode_Intel2:Enable::0.0:1", //enable intel 2
  "OnUser1 Classic_Mode_Intel3:Enable::0.0:1",
  "OnUser1 Classic_Mode_Intel4:Enable::0.0:1",
  "OnUser1 Classic_Mode_Intel5:Enable::0.0:1",
  "OnUser1 Classic_Mode_Intel6:Enable::0.0:1"
};
int BEM = 0;
//Brawler Emergency Mode Rewrite
void Emerge(int stage){
  switch(stage){
    case 0:{
      BEM = 0;
      core.brawler_emergency = true;
      EmitSoundToAll(SFXArray[55]);
      CreateTimer(1.0, TimedOperator, 6969);
      core.sacPoints = 0;
      ServerCommand("sm_addcash @red 2000000");
      ServerCommand("sm_god @red 1");
      return;
    }
    case 1:{
      ServerCommand("sm_freeze @blue; sm_smash @blue; sm_evilrocket @blue");
      sudo(2);
      CreateTimer(4.0, TimedOperator, 6969);
      return;
    }
    case 2:{
      EmitSoundToAll(SFXArray[6]);
      CreateTimer(7.0, TimedOperator, 6969);
      return;
    }
    case 3:{
      ServerCommand("fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40;fb_operator 40");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 4:{
      ServerCommand("fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 42");
      sudo(1006);
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 5:{
      bombState[0].state = 8;
      bombState[0].stateMax = 10;
      sudo(15);
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 6:{
      bombState[0].state = 16;
      bombState[0].stateMax = 18;
      ServerCommand("fb_operator 15;fb_operator 15");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 7:{
      bombState[0].state = 24;
      bombState[0].stateMax = 26;
      ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 8:{
      bombState[0].state = 32;
      bombState[0].stateMax = 34;
      ServerCommand("fb_operator 15;fb_operator15;fb_operator 15;fb_operator 15");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 9:{
      bombState[0].state = 40;
      bombState[0].stateMax = 42;
      ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 10:{
      bombState[0].state = 48;
      bombState[0].stateMax = 50;
      ServerCommand("fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15");
      ServerCommand("fb_operator 30");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 11:{
      bombState[0].state = 5,
      ServerCommand("fb_operator 31");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 12:{
      ServerCommand("fb_operator 32");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 13:{
      ServerCommand("fb_operator 33");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 14:{
      ServerCommand("fb_operator 34");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 15:{
      ServerCommand("fb_operator 35");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 16:{
      ServerCommand("fb_operator 36");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 17:{
      sudo(37);
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 18:{
      ServerCommand("sm_freeze @blue -1; sm_smash @blue");
      CreateTimer(3.0, TimedOperator, 6969);
      return;
    }
    case 19:{
      ServerCommand("fb_operator 40; fb_operator 42; fb_operator 30; fb_operator 32; fb_operator 34; fb_operator 32; fb_operator 31; fb_operator 42;fb_operator 42;fb_operator 42;fb_operator 31;fb_operator 32;fb_operator 32;fb_operator 31;fb_operator 32;fb_operator 32");
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 20:{
      bombState[0].state = 48;
      bombState[0].stateMax = 50;
      ServerCommand("fb_operator 15;fb_operator15;fb_operator 15;fb_operator 15;fb_operator 15;fb_operator 15");
      for (int i = 0; i < 12; i++) {
        sudo(GetRandomInt(30, 37));
        sudo(GetRandomInt(40, 44));
        sudo(1003);
      }
      CreateTimer(1.0, TimedOperator, 6969);
      return;
    }
    case 21:{
      ExitEmergencyMode();
      return;
    }
  }
}

//Exit emergency mode!
public void ExitEmergencyMode() {
  CPrintToChatAll(!core.isWave ? "{darkgreen}[CORE] Exiting emergency mode with CODE -1/WAVE_END (the wave has ended). %i actions executed." : "{darkgreen}[CORE] Exiting emergency mode with CODE 0/SUCCESS. %i actions executed.", BEM+1); //BEM+1 because BEM actually executes on 0.
  core.brawler_emergency = false;
  core.sacPoints = 0;
  ServerCommand("sm_god @red 0");
  BEM = 0;
  return;
}

public bool IsStringNumeric(const char[] str)
{
    int len = strlen(str);
    
    for (int i=0; i < len; i++)
    {
        if (!IsCharNumeric(str[i]))
        {
            return false;
        }
    }
    
    return true;
}