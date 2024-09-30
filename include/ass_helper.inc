//ASS_HELPER - Contains the config loaders and all the plugin core data entries as well as some stocks required for base functionality.
//Log debug info
enum {
  LOGLVL_DEBUG = 0,
  LOGLVL_INFO = 1,
  LOGLVL_WARN = 2,
  LOGLVL_ERROR = 3
};
void AssLogger(int logLevel, const char[] logData, any...) {
  char buffer[256];
  VFormat(buffer, sizeof(buffer), logData, 3);
  switch (logLevel) {
    case LOGLVL_DEBUG: {
      LogMessage("[DEBUG]: %s", buffer);
    }
    case LOGLVL_INFO: {
      LogMessage("[INFO]: %s", buffer);
    }
    case LOGLVL_WARN: {
      LogMessage("[WARN]: %s", buffer);
    }
    case LOGLVL_ERROR: {
      LogMessage("[ERROR]: %s", buffer);
    }
  }
}
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
  bool tickBGMOffset;
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
  void Reset(){
    this.canCrusaderNuke = false;
    this.canHindenburg = false;
    this.canHWBoss = false;
    this.canSephNuke = false;
    this.isWave = false;
    this.sephiroth = false;
    this.waveFlags = 0;
  }
}
COREDATA core;
bool tickOnslaughter;

Database FB_Database;
int attemptSpawn = 0;
bool isGoobbue = false;
bool CircleAOEenabled[] = {
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true
};
float CircleAOEpos[][3] = {
  {2370.0, -1670.0, -645.0},
  {1050.0, -1790.0, -535.0},
  {1150.0, -1520.0, -535.0},
  {1830.0, -1550.0, -600.0},
  {1925.0, -1875.0, -580.0},
  {1485.0, -1460.0, -585.0},
  {1630.0, -1680.0, -590.0},
  {1370.0, -1360.0, -570.0},
  {1350.0, -1690.0, -570.0},
  {2270.0, -900.0, -400.0},
  {1920.0, -490.0, -400.0},
  {1825.0, -650.0, -400.0},
  {980.0, -560.0, -400.0},
  {650.0, -880.0, -400.0},
  {1690.0, -870.0, -500.0},
  {1400.0, -870.0, -500.0},
  {1050.0, -980.0, -500.0},
  {1500.0, -480.0, -480.0},
  {800.0, -1100.0, -480.0},
  {520.0, -1400.0, -470.0},
  {550.0, -1730.0, -500.0},
  {1030.0, -1740.0, -530.0}
};
//Grouped AOEs
float g1AOEpos[][3] = {

};
float g2AOEpos[][3] = {

};
float g3AOEpos[][3] = {

};
float g4AOEpos[][3] = {

};
float g5AOEpos[][3] = {

};

//Return position
float Return[3] = {
  -3730.0,
  67.0,
  -252.0
};
/*
enum struct DPSCOUNTER {
  int damage;
  float emnity(){
    PrintToServer("Attempting emnity using %i / %i, result %f", this.damage, dmgTotal, ((this.damage * 1.0) /(dmgTotal * 1.0)* 100.0));
    return ((this.damage * 1.0) / (dmgTotal * 1.0) * 100.0);
  }
  float dps(){
    return this.damage / (GetGameTime() - waveStartTime);
  }
}
DPSCOUNTER dps[MAXPLAYERS+1];
DPSCOUNTER bossdps[MAXPLAYERS+1];
*/
public int iDmgHealingTotal;
enum struct EMNITYMANAGER {
  int iBossDamage;
  int iDamage;
  int iHealing;
  int InitHealingValue;
  int getClientEmnity() {
    //PrintToConsoleAll ("Getting emnity returned Damage %i + Healing %i / %i Total, or %i Emnity ", this.iDamage, this.iHealing, iDmgHealingTotal, RoundToFloor(((this.iDamage * 1.0 + this.iHealing * 1.0) / ((iDmgHealingTotal == 0) ? 1 : iDmgHealingTotal) * 100)));
    return RoundToFloor((((this.iDamage + this.iHealing) * 1.0) / (iDmgHealingTotal * 1.0)) * 100.0);
  }
  bool IsAboveEmnityThreshold(int value) {
    if (RoundToFloor(((this.iDamage + this.iHealing) * 1.0) / (iDmgHealingTotal * 1.0)) > value) return true;
    return false;
  }
  void Reset() {
    this.iBossDamage = 0;
    this.iDamage = 0;
    this.iHealing = 0;
  }
}
EMNITYMANAGER EmnityManager[MAXPLAYERS+1];

stock int GetEmnityMax() {
  int result = 0;
  int score = -1;
  int tempscore = 0;
  for(int i = 0; i < MaxClients; ++i) {
    if(!IsValidClient(i)) { //replace IsValidClient(i) with whatever you need to validate your clients
      continue;
    }
    tempscore = EmnityManager[i].getClientEmnity();
    if(score == - 1 || tempscore > score) {
      result = i;
      score = tempscore;
    }
  }
  return result;
}

public int GetHealerOfClient(int client){
  for (int i = 1; i <= MaxClients; ++i){
    if(!IsValidClient(i) || GetClientTeam(i) == 3) continue;
    if (TF2_GetPlayerClass(i) == TFClass_Medic){
      int medigun = GetPlayerWeaponSlot(i, TFWeaponSlot_Secondary);
      if (!IsValidEdict(medigun) || !IsValidEntity(medigun)){
        PrintToServer("medigun returned null");
        return -1;
      }
      char s[32];
      GetEdictClassname(medigun, s, sizeof(s));
      if (!strcmp(s, "tf_weapon_medigun", false)) {
        if (GetEntProp(medigun, Prop_Send, "m_bHealing") && core.isWave){
          if(GetEntPropEnt(medigun, Prop_Send, "m_hHealingTarget") == client) return i;
        }
      }
    }
  }
  return -1;
}

public Action UpdateMedicHealing(Handle timer){
  int CurHealVal[MAXPLAYERS+1];
  for (int i = 1; i <= MaxClients; ++i){
    if(!IsValidClient(i) || GetClientTeam(i) == 3) continue;
    if (TF2_GetPlayerClass(i) == TFClass_Medic){
      int medigun = GetPlayerWeaponSlot(i, TFWeaponSlot_Secondary);
      if (!IsValidEdict(medigun) || !IsValidEntity(medigun)){
        PrintToServer("medigun returned null");
        return Plugin_Stop;
      }
      CurHealVal[i] = GetEntProp(i, Prop_Send, "m_iHealPoints");
      char s[32];
      GetEdictClassname(medigun, s, sizeof(s));
      if (!strcmp(s, "tf_weapon_medigun", false)) {
        if (GetEntProp(medigun, Prop_Send, "m_bHealing") && core.isWave){
          int hOffset = (CurHealVal[i] - EmnityManager[i].InitHealingValue);
          PrintToServer("%N is healing %N with %i HP since last check", i, GetEntPropEnt(medigun, Prop_Send, "m_hHealingTarget"), hOffset);
          EmnityManager[i].iHealing += hOffset;
          iDmgHealingTotal += hOffset;
        }
      }
      EmnityManager[i].InitHealingValue = CurHealVal[i];
    }
  }
  CreateTimer(1.0, UpdateMedicHealing);
  return Plugin_Stop;
}

public void UpdateAllHealers() {
  for (int i = 1; i <= MaxClients; ++i){
    if(!IsValidClient(i) || GetClientTeam(i) == 3) continue;
    if (TF2_GetPlayerClass(i) == TFClass_Medic){
      EmnityManager[i].InitHealingValue = ((TF2_GetPlayerClass(i) == TFClass_Medic)) ? GetEntProp(i, Prop_Send, "m_iHealPoints") : 0;
    }
  }
}

Handle cvarSNDDefault = INVALID_HANDLE;
int soundPreference[MAXPLAYERS + 1];

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
    AssLogger(LOGLVL_DEBUG, "Exploding a %s - isRealExplosion: %d canHinden: %d, canStars: %d, canShark: %d, isNuclear: %d, shouldFreezeBots: %d, explEnt: %s, explShake: %s, explSnd: %s, identifier: %s, explDly: %f, explShakeDly: %f, fadeDly: %f, NukeStart: %f, sacVal: %i...", this.name, realExplosion, this.canHindenburg, this.canSENTStars, this.canSENTShark, this.isNuclear, this.shouldFreezeBots, this.explEnt, this.explShake, this.explSnd, this.identifier, this.explDly, this.explShakeDly, this.FadeDly, this.NukeStart, this.sacVal);
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
      FastFire2("LargeExplosionSND", "PlaySound", "", this.NukeStart, false);
      FastFire2("NukeAll", "Enable", "", this.NukeStart, false);
      FastFire2("HurtAll", "AddOutput", "damagetype 262144", this.NukeStart, false);
      FastFire2("HurtAll", "AddOutput", "damage 2000000", this.NukeStart, false);
      FastFire2("HurtAll", "Enable", "", this.NukeStart+0.1, false);
      FastFire2("FB.Fade", "Fade", "", this.FadeDly, false);
      FastFire2("NukeAll", "Disable", "", 3.0, false);
      FastFire2("HurtAll", "Disable", "", 3.0, false);
      if(this.state == 64){
        CreateTimer(15.0, SpecTimer);
        ResetBombState();
      }
      if(this.canHindenburg){
        core.canHindenburg = true;
        FastFire2("DeliveryBurg", "Unlock", "", 0.0, false);
        CPrintToChatAll("The {red}HINDENBURG {forestgreen}is now ready for flight!");
      }
    }
    FastFire2(this.explEnt, "Explode", "", this.explDly, false);
    CustomSoundEmitter(this.explSnd, 65, false, 0, 1.0, 100);
    FastFire2(this.explShake, "StartShake", "", this.explShakeDly, false);
    if(realExplosion){
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] %s {forestgreen}successfully deployed! {white}({limegreen}+%i pts{white})", this.name, this.sacVal);
      core.sacPoints += this.sacVal;
      CreateTimer(3.0, BombStatusAddTimer);
      CustomSoundEmitter(SFXArray[6].realPath, 65, false, 0, 1.0, 100);
      FastFire2("RareSpells", "Enable", "", 0.0, false);
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
      CreateTimer(1.0, NukeTimer, 2);
      CreateTimer(7.0, TimedOperator, 11);
      core.canSephNuke = true;
    }
    if (!StrEqual(this.ChatMessage, "")) CPrintToChatAll(this.ChatMessage);
    for (int i = 0; i < this.fireCount; i++) FastFire2(this.fireString[this.index+i], "", "", 0.0, true);
  }
}
CUSTOMBOSS SephBoss[12];
CUSTOMBOSS HWBoss[12];
//CUSTOMBOSS Onslaughter[10];
//Used for any time we need to fo a LOT of things in quick succession... Or when we want to do something at random.
enum struct BULKFIRE {
  char fireStr[256];
}
BULKFIRE crusaderAtk[64];

//FastFire2 System Setup
int ff2Ref;
void InjectFastFire2(){
  int ff2 = FindEntityByTargetname("FastFire2", "info_target");
  AssLogger(LOGLVL_INFO, "Injecting FastFire2!");
  if (!IsValidEntity(ff2)){
    ff2 = CreateEntityByName("info_target");
    if (!IsValidEdict(ff2)) SetFailState("Could not inject FastFire2, aborting!!!");
    DispatchSpawn(ff2);
    DispatchKeyValue(ff2, "targetname", "FastFire2");
    ActivateEntity(ff2);
    AssLogger(LOGLVL_INFO, "Injected info_target FastFire2 to map!")
  }
  ff2Ref = EntIndexToEntRef(ff2);
  OnFastFire2Ready();
}
//Execute inputs - EXPERT MODE
public void FastFire2(const char[] target, const char[] input, const char[] param, const float delay, bool isLegacy) {
  int ff2 = EntRefToEntIndex(ff2Ref);
  char FireStr[128];
  FormatEx(FireStr, sizeof(FireStr), (isLegacy ? target : "OnUser1 %s,%s,%s,%f,1"), target, input, param, delay);
  SetVariantString(FireStr);
  AcceptEntityInput(ff2, "AddOutput");
  AcceptEntityInput(ff2, "FireUser1");
}

//Configure all variables
void SetupCoreData(){
  AssLogger(LOGLVL_INFO, "Setting up core data...");
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
  //This is not in the config files yet...
  WeatherManager.defFogStartDist = "300";
  WeatherManager.defFogEndDist = "3000";
  WeatherManager.defFogDensity = 0.55;
  WeatherManager.fogChangeRate = 0.001;
  WeatherManager.hasTornado = false;
  MapLighting[0].arcs = "MapLighting.StreetLamp00.arcs";
  MapLighting[1].arcs = "MapLighting.StreetLamp01.arcs";
  MapLighting[2].arcs = "MapLighting.StreetLamp02.arcs";
  MapLighting[3].arcs = "MapLighting.StreetLamp03.arcs";
  MapLighting[4].arcs = "MapLighting.StreetLamp04.arcs";
  MapLighting[5].arcs = "MapLighting.StreetLamp05.arcs";
  MapLighting[6].arcs = "MapLighting.StreetLamp06.arcs";
  MapLighting[7].arcs = "MapLighting.StreetLamp07.arcs";
  MapLighting[8].arcs = "MapLighting.StreetLamp08.arcs";
  MapLighting[9].arcs = "MapLighting.StreetLamp09.arcs";
  MapLighting[10].arcs = "MapLighting.StreetLamp0A.arcs";
  MapLighting[11].arcs = "MapLighting.StreetLamp0B.arcs";
  MapLighting[12].arcs = "MapLighting.StreetLamp0C.arcs";
  MapLighting[0].beam = "MapLighting.StreetLamp00.beam";
  MapLighting[1].beam = "MapLighting.StreetLamp01.beam";
  MapLighting[2].beam = "MapLighting.StreetLamp02.beam";
  MapLighting[3].beam = "MapLighting.StreetLamp03.beam";
  MapLighting[4].beam = "MapLighting.StreetLamp04.beam";
  MapLighting[5].beam = "MapLighting.StreetLamp05.beam";
  MapLighting[6].beam = "MapLighting.StreetLamp06.beam";
  MapLighting[7].beam = "MapLighting.StreetLamp07.beam";
  MapLighting[8].beam = "MapLighting.StreetLamp08.beam";
  MapLighting[9].beam = "MapLighting.StreetLamp09.beam";
  MapLighting[10].beam = "MapLighting.StreetLamp0A.beam";
  MapLighting[11].beam = "MapLighting.StreetLamp0B.beam";
  MapLighting[12].beam = "MapLighting.StreetLamp0C.beam";
  MapLighting[0].buzz = "MapLighting.StreetLamp00.buzz";
  MapLighting[1].buzz = "MapLighting.StreetLamp01.buzz";
  MapLighting[2].buzz = "MapLighting.StreetLamp02.buzz";
  MapLighting[3].buzz = "MapLighting.StreetLamp03.buzz";
  MapLighting[4].buzz = "MapLighting.StreetLamp04.buzz";
  MapLighting[5].buzz = "MapLighting.StreetLamp05.buzz";
  MapLighting[6].buzz = "MapLighting.StreetLamp06.buzz";
  MapLighting[7].buzz = "MapLighting.StreetLamp07.buzz";
  MapLighting[8].buzz = "MapLighting.StreetLamp08.buzz";
  MapLighting[9].buzz = "MapLighting.StreetLamp09.buzz";
  MapLighting[10].buzz = "MapLighting.StreetLamp0A.buzz";
  MapLighting[11].buzz = "MapLighting.StreetLamp0B.buzz";
  MapLighting[12].buzz = "MapLighting.StreetLamp0C.buzz";
  MapLighting[0].explosion = "MapLighting.StreetLamp00.explosion";
  MapLighting[1].explosion = "MapLighting.StreetLamp01.explosion";
  MapLighting[2].explosion = "MapLighting.StreetLamp02.explosion";
  MapLighting[3].explosion = "MapLighting.StreetLamp03.explosion";
  MapLighting[4].explosion = "MapLighting.StreetLamp04.explosion";
  MapLighting[5].explosion = "MapLighting.StreetLamp05.explosion";
  MapLighting[6].explosion = "MapLighting.StreetLamp06.explosion";
  MapLighting[7].explosion = "MapLighting.StreetLamp07.explosion";
  MapLighting[8].explosion = "MapLighting.StreetLamp08.explosion";
  MapLighting[9].explosion = "MapLighting.StreetLamp09.explosion";
  MapLighting[10].explosion = "MapLighting.StreetLamp0A.explosion";
  MapLighting[11].explosion = "MapLighting.StreetLamp0B.explosion";
  MapLighting[12].explosion = "MapLighting.StreetLamp0C.explosion";
  MapLighting[0].light = "MapLighting.StreetLamp00.light";
  MapLighting[1].light = "MapLighting.StreetLamp01.light";
  MapLighting[2].light = "MapLighting.StreetLamp02.light";
  MapLighting[3].light = "MapLighting.StreetLamp03.light";
  MapLighting[4].light = "MapLighting.StreetLamp04.light";
  MapLighting[5].light = "MapLighting.StreetLamp05.light";
  MapLighting[6].light = "MapLighting.StreetLamp06.light";
  MapLighting[7].light = "MapLighting.StreetLamp07.light";
  MapLighting[8].light = "MapLighting.StreetLamp08.light";
  MapLighting[9].light = "MapLighting.StreetLamp09.light";
  MapLighting[10].light = "MapLighting.StreetLamp0A.light";
  MapLighting[11].light = "MapLighting.StreetLamp0B.light";
  MapLighting[12].light = "MapLighting.StreetLamp0C.light";
  MapLighting[0].status = "MapLighting.StreetLamp00.status";
  MapLighting[1].status = "MapLighting.StreetLamp01.status";
  MapLighting[2].status = "MapLighting.StreetLamp02.status";
  MapLighting[3].status = "MapLighting.StreetLamp03.status";
  MapLighting[4].status = "MapLighting.StreetLamp04.status";
  MapLighting[5].status = "MapLighting.StreetLamp05.status";
  MapLighting[6].status = "MapLighting.StreetLamp06.status";
  MapLighting[7].status = "MapLighting.StreetLamp07.status";
  MapLighting[8].status = "MapLighting.StreetLamp08.status";
  MapLighting[9].status = "MapLighting.StreetLamp09.status";
  MapLighting[10].status = "MapLighting.StreetLamp0A.status";
  MapLighting[11].status = "MapLighting.StreetLamp0B.status";
  MapLighting[12].status = "MapLighting.StreetLamp0C.status";
  MapLighting[0].stun = "MapLighting.StreetLamp00.stun";
  MapLighting[1].stun = "MapLighting.StreetLamp01.stun";
  MapLighting[2].stun = "MapLighting.StreetLamp02.stun";
  MapLighting[3].stun = "MapLighting.StreetLamp03.stun";
  MapLighting[4].stun = "MapLighting.StreetLamp04.stun";
  MapLighting[5].stun = "MapLighting.StreetLamp05.stun";
  MapLighting[6].stun = "MapLighting.StreetLamp06.stun";
  MapLighting[7].stun = "MapLighting.StreetLamp07.stun";
  MapLighting[8].stun = "MapLighting.StreetLamp08.stun";
  MapLighting[9].stun = "MapLighting.StreetLamp09.stun";
  MapLighting[10].stun = "MapLighting.StreetLamp0A.stun";
  MapLighting[11].stun = "MapLighting.StreetLamp0B.stun";
  MapLighting[12].stun = "MapLighting.StreetLamp0C.stun";
  MapLighting[0].zap = "MapLighting.StreetLamp00.zap";
  MapLighting[1].zap = "MapLighting.StreetLamp01.zap";
  MapLighting[2].zap = "MapLighting.StreetLamp02.zap";
  MapLighting[3].zap = "MapLighting.StreetLamp03.zap";
  MapLighting[4].zap = "MapLighting.StreetLamp04.zap";
  MapLighting[5].zap = "MapLighting.StreetLamp05.zap";
  MapLighting[6].zap = "MapLighting.StreetLamp06.zap";
  MapLighting[7].zap = "MapLighting.StreetLamp07.zap";
  MapLighting[8].zap = "MapLighting.StreetLamp08.zap";
  MapLighting[9].zap = "MapLighting.StreetLamp09.zap";
  MapLighting[10].zap = "MapLighting.StreetLamp0A.zap";
  MapLighting[11].zap = "MapLighting.StreetLamp0B.zap";
  MapLighting[12].zap = "MapLighting.StreetLamp0C.zap";
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
  bombState[1].explSnd = SFXArray[1].realPath;
  bombState[2].explSnd = SFXArray[2].realPath;
  bombState[3].explSnd = SFXArray[2].realPath;
  bombState[4].explSnd = SFXArray[2].realPath;
  bombState[5].explSnd = SFXArray[4].realPath;
  bombState[6].explSnd = SFXArray[3].realPath;
  bombState[7].explSnd = SFXArray[35].realPath;
  bombState[8].explSnd = SFXArray[35].realPath;
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
  AudioManager.bgmPlaying = false;
  core.bombReset = false;
  core.brawler_emergency = false;
  core.canCrusaderNuke = false;
  core.canHindenburg = false;
  core.canHWBoss = false;
  core.canSENTMeteors = false;
  core.canSENTShark = false;
  core.canSENTStars = false;
  core.canSephNuke = false;
  core.crusader = false;
  core.doFailsafe = false;
  core.isWave = false;
  core.monitorOn = false;
  core.monitorColor = true;
  core.sacrificedByClient = false;
  core.sephiroth = false;
  AudioManager.stopBGM = false;
  core.tacobell = false;
  core.tickingClientHealth = false;
  AudioManager.shouldTick = false;
  AudioManager.tickBGMOffset = false;
  WeatherManager.TornadoWarning = false;
  AudioManager.cachedPath = "null";
  AudioManager.songName = "null";
  AudioManager.indexBGM = 1;
  core.FailedCount = 0;
  core.INCOMINGDISPLAYED = 0;
  core.camSel = 0;
  core.CodeEntry = 0;
  core.curWave = 0;
  core.failsafeCount = 0;
  core.lastAdmin = 0;
  AudioManager.refireBGM = 0;
  core.sacPoints = 0;
  core.sacPointsMax = 60;
  AudioManager.chanBGM = 6;
  AudioManager.ticksBGM = 0;
  AudioManager.VIPBGM = -1;
  core.VIPIndex = 0;
  core.waveFlags = 0;
  core.HWNMin = 210.0;
  core.HWNMax = 380.0;
  AssLogger(1, "Setting up bosses...");
  HWBoss[0].index = 0;
  HWBoss[0].fireCount = 2;
  HWBoss[0].fireString = "OnUser1 hhh_maker,ForceSpawn,,0.0,1";
  HWBoss[1].index = 2;
  HWBoss[1].fireString = "OnUser1 hhh_maker2,ForceSpawn,,0.0,1";
  HWBoss[2].index = 3;
  HWBoss[2].fireCount = 1;
  HWBoss[2].fireString = "OnUser1 monoculus_maker,ForceSpawn,,0.0,1";
  HWBoss[3].index = 4;
  HWBoss[3].fireCount = 3;
  HWBoss[3].fireString = "OnUser1 hhh_maker2,ForceSpawn,,0.0,1";
  HWBoss[4].index = 7;
  HWBoss[4].fireString = "OnUser1 SkeleSpawner,Enable,,0.0,1";
  HWBoss[5].index = 8; 
  HWBoss[5].fireString = "OnUser1 SkeleSpawner,Disable,,20.0,1";
  HWBoss[6].index = 5; //Does this access HWBoss[4]?
  HWBoss[6].fireCount=2;//Does this disable skelespawner after enabling it?...
  HWBoss[7].index = 8;
  HWBoss[7].fireString = "OnUser1 merasmus_maker,ForceSpawn,,0.0,1";
  HWBoss[7].fireCount = 3;
  HWBoss[8].index = 11;
  HWBoss[8].fireCount = 2;
  HWBoss[8].fireString = "OnUser1 hhh_maker2,ForceSpawn,,0.0,1";
  HWBoss[9].index = 12;
  HWBoss[9].fireString = "OnUser1 monoculus_maker,ForceSpawn,,0.0,1";
  HWBoss[10].index = 0;
  HWBoss[10].fireCount = 2;
  HWBoss[10].fireString = "OnUser1 merasmus_maker,ForceSpawn,,0.0,1";
  HWBoss[11].index = 2;
  HWBoss[11].fireString = "OnUser1 monoculus_maker,ForceSpawn,,0.0,1";
  HWBoss[11].fireCount = 1;
  SephBoss[0].index = 0;
  SephBoss[0].fireCount = 0;
  SephBoss[0].shouldNuke = true;
  SephBoss[1].fireString = "OnUser1 SephMeteor,ForceSpawn,,0.0,1";
  SephBoss[1].ChatMessage = "{blue}Sephiroth: Say goodbye!";
  SephBoss[1].index = 2;
  SephBoss[1].fireCount = 1;
  SephBoss[2].fireString = "OnUser1 SephNuke,ForceSpawn,,0.0,1";
  SephBoss[2].index = 3;
  SephBoss[2].fireCount = 1;
  SephBoss[2].sound = SFXArray[8].realPath;
  SephBoss[3].fireString = "OnUser1 SephRocketSpammer,FireMultiple,50,0.0,1";
  SephBoss[3].index = 4;
  SephBoss[3].fireCount = 4;
  SephBoss[4].index = 3;
  SephBoss[4].fireCount = 3;
  SephBoss[4].fireString = "OnUser1 SephRocketSpammer,FireMultiple,10,3.0,1";
  SephBoss[5].index = 9;
  SephBoss[5].fireCount = 2;
  SephBoss[5].fireString = "OnUser1 SephRocketSpammer,FireMultiple,10,5.0,1";
  SephBoss[6].index = 9;
  SephBoss[6].fireCount = 2;
  SephBoss[6].fireString = "OnUser1 SkeleSpawner,Enable,,0.0,1";
  SephBoss[7].index = 3;
  SephBoss[7].fireCount = 3;
  SephBoss[7].fireString = "OnUser1 SkeleSpawner,Disable,,20.0,1";
  SephBoss[8].index = 4;
  SephBoss[8].fireCount = 1;
  SephBoss[9].index = 11;
  SephBoss[9].fireCount = 2;
  SephBoss[9].fireString = "OnUser1 SephRocketSpammer,FireOnce,,0.0,1";
  SephBoss[10].index = 12;
  SephBoss[10].fireCount = 1;
  SephBoss[10].fireString = "OnUser1 SephRocketSpammer,FireOnce,,5.0,1";
  SephBoss[11].index = 3;
  SephBoss[11].fireCount = 4;
  AssLogger(1, "[BULKFIRE] Setting up Crusader...");
  Handle confCoreData = OpenFile("addons/sourcemod/configs/FartsysAss/BulkFire/crusader.ini", "rt", false);
  char bufCoreData[256];
  int crusaderIndex = -1;
  if(confCoreData == INVALID_HANDLE) return;
  while (ReadFileLine(confCoreData, bufCoreData, sizeof(bufCoreData))){
    TrimString(bufCoreData);
    if (!StrContains(bufCoreData, "OnUser1")){
      crusaderIndex++;
      Format(crusaderAtk[crusaderIndex].fireStr, 256, bufCoreData);
    }
    if (IsEndOfFile(confCoreData)) break;
  }
  AssLogger(1, "[BULKFIRE] Setting up Lightning Flashes...");
  confCoreData = OpenFile("addons/sourcemod/configs/FartsysAss/BulkFire/lightning_flash.ini", "rt", false);
  int lightningFlashIndex = -1;
  if(confCoreData == INVALID_HANDLE) return;
  while (ReadFileLine(confCoreData, bufCoreData, sizeof(bufCoreData))){
    TrimString(bufCoreData);
    if (!StrContains(bufCoreData, "OnUser1")){
      lightningFlashIndex++;
      Format(lightningFlash[lightningFlashIndex].fireStr, 256, bufCoreData);
    }
    if (IsEndOfFile(confCoreData)) break;
  }
  AssLogger(1, "[BULKFIRE] Setting up Lightning Strikes...");
  confCoreData = OpenFile("addons/sourcemod/configs/FartsysAss/BulkFire/lightning_strike.ini", "rt", false);
  int lightningStrikeIndex = -1;
  if(confCoreData == INVALID_HANDLE) return;
  while (ReadFileLine(confCoreData, bufCoreData, sizeof(bufCoreData))){
    TrimString(bufCoreData);
    if (!StrContains(bufCoreData, "OnUser1")){
      lightningStrikeIndex++;
      Format(lightningStrike[lightningStrikeIndex].fireStr, 256, bufCoreData);
    }
    if (IsEndOfFile(confCoreData)) break;
  }
  AssLogger(1, "[CORE] Setting up Wave Defaults...");
  confCoreData = OpenFile("addons/sourcemod/configs/FartsysAss/Core/WaveDefaults.ini", "rt", false);
  int defIndexHW, defIndexTornado, defIndexBGM, defIndexBS, defIndexBSM, defIndexSPM; // Start at 0 because we don't have a wave 0
  if(confCoreData == INVALID_HANDLE) return;
  while (ReadFileLine(confCoreData, bufCoreData, sizeof(bufCoreData))){
    TrimString(bufCoreData);
    if (!StrContains(bufCoreData, "Wave.defCanHWBoss:")){
      defIndexHW++;
      DefaultsArray[defIndexHW].defCanHWBoss = CharToBool(bufCoreData);
    }
    else if(!StrContains(bufCoreData, "Wave.defCanTornado:")){
      defIndexTornado++;
      DefaultsArray[defIndexTornado].defCanTornado = CharToBool(bufCoreData);
    }
    else if(!StrContains(bufCoreData, "Wave.defBGMIndex:")){
      defIndexBGM++;
      ReplaceString(bufCoreData, sizeof(bufCoreData), "Wave.defBGMIndex:", "", true);
      DefaultsArray[defIndexBGM].defBGMIndex = StringToInt(bufCoreData);
    }
    else if(!StrContains(bufCoreData, "Wave.defBombStatus:")){
      defIndexBS++;
      ReplaceString(bufCoreData, sizeof(bufCoreData), "Wave.defBombStatus:", "", true);
      DefaultsArray[defIndexBS].defBombStatus = StringToInt(bufCoreData);
    }
    else if(!StrContains(bufCoreData, "Wave.defBombStatusMax:")){
      defIndexBSM++;
      ReplaceString(bufCoreData, sizeof(bufCoreData), "Wave.defBombStatusMax:", "", true);
      DefaultsArray[defIndexBSM].defBombStatusMax = StringToInt(bufCoreData);
    }
    else if(!StrContains(bufCoreData, "Wave.defSacPointsMax:")){
      defIndexSPM++;
      ReplaceString(bufCoreData, sizeof(bufCoreData), "Wave.defSacPointsMax:", "", true);
      DefaultsArray[defIndexSPM].defSacPointsMax = StringToInt(bufCoreData);
    }
  }
  CloseHandle(confCoreData);
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
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}We have a Discord server: {forestgreen}https://discord.com/invite/ZfUUQWxCmw",
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
    //PrintToServer("Found %s, index %i", namebuf, index);
  }
  return(index);
}

//Get a client's health
stock int TF2_GetPlayerMaxHealth(int client) {
  return GetEntProp(GetPlayerResourceEntity(), Prop_Send, "m_iMaxHealth", _, client);
}

void RegisterAndPrecacheAllFiles(){
  AssLogger(0, "Loading EVERYTHING to RAM...");
  Handle confBGM = OpenFile("addons/sourcemod/configs/FartsysAss/Files/music.ini", "rt", false);
  Handle confSFX = OpenFile("addons/sourcemod/configs/FartsysAss/Files/sfx.ini", "rt", false);
  char bufferBGM[256];
  char bufferSFX[128];
  int bgmIndex;
  int bgmNameIndex = -1;
  int bgmRefire;
  int bgmOffset;
  int bgmVol;
  int sfxIndex = -1;
  if(confBGM == INVALID_HANDLE) return;
  if(confSFX == INVALID_HANDLE) return;
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
  while (ReadFileLine(confSFX, bufferSFX, sizeof(bufferSFX))){
    TrimString(bufferSFX);
    if (!StrContains(bufferSFX, "Path:")){
      sfxIndex++;
      ReplaceString(bufferSFX, sizeof(bufferSFX), "Path:", "", true);
      Format(SFXArray[sfxIndex].realPath, 128, bufferSFX);
    }
    if (IsEndOfFile(confSFX)) break;
  }
  if(confSFX != INVALID_HANDLE){
		CloseHandle(confSFX);
	}
  for (int i = 1; i < sizeof(BGMArray); i++){ //We start at index 1 because index 0 is used for restoring default bgm in the VIP music menu...
   if(!StrEqual(BGMArray[i].realPath, "")){ 
    AssLogger(LOGLVL_DEBUG, "Precaching BGM: %s (%s), Duration %i ticks, Start Loop Point %i ticks, Volume %i   @ %i", BGMArray[i].songName, BGMArray[i].realPath, BGMArray[i].refireTime, BGMArray[i].ticksOffset, BGMArray[i].SNDLVL, i);
    PrecacheSound(BGMArray[i].realPath, true);
   }
  }
  for (int i = 0; i < sizeof(SFXArray); i++){
    if(!StrEqual(SFXArray[i].realPath, "")){
    AssLogger(LOGLVL_DEBUG, "Precaching SFX: %s in position %i", SFXArray[i].realPath, i);
    PrecacheSound(SFXArray[i].realPath, true);
    }
  }
  AssLogger(LOGLVL_INFO, "Done! BGM Count: %i, SFX Count: %i, Total: %i files loaded to RAM.", bgmIndex, sfxIndex, bgmIndex + sfxIndex);
  //Todo: These files are not part of the base pakfile, they are slated for install in a future update, when that update is ready, these files will eventually become one with the map.
  PrecacheSound(TBGM0, true);
  PrecacheSound(TBGM2, true);
  PrecacheSound(TBGM3, true);
  PrecacheSound(TBGM4, true);
  PrecacheSound(TBGM5, true);
  PrecacheSound(TBGM6, true);
}

//Used to keep StopSound from stopping the music we're trying to play - now with support for loop offsets!
public Action SyncMusic(Handle timer, int index) {
  AudioManager.cachedPath = BGMArray[index].realPath;
  AudioManager.tickBGMOffset = (BGMArray[index].ticksOffset > 0 ? true : false);
  AssLogger(LOGLVL_INFO, "We are on wave %i, now playing: %s (from %s) for %i ticks. It will start looping at %i ticks.", core.curWave, AudioManager.songName, BGMArray[index].realPath, AudioManager.refireBGM, BGMArray[index].ticksOffset);
  return Plugin_Stop;
}

//Wave Setup
char WaveSetup[][] = {
  "OnUser1 bombpath_right_arrows,Disable,,0.1,1", //Disable right arrows
  "OnUser1 bombpath_left_arrows,Disable,,0.1,1", //Disable left arrows
  "OnUser1 Classic_Mode_Intel1,Enable,,0.0,1", //Activate Intel 1
  "OnUser1 Classic_Mode_Intel2,Enable,,0.0,1", //Activate Intel 2
  "OnUser1 CommonSpells,Enable,,0.0,1", // Activate common spells
  "OnUser1 OldSpawn,Enable,,0.0,1", //Activate Old Spawn
  "OnUser1 NewSpawn,Disable,,0.0,1", //De-activate New Spawn
  "OnUser1 Classic_Mode_Intel1,Enable,,0.0,1", //enable intel 1
  "OnUser1 Classic_Mode_Intel2,Enable,,0.0,1", //enable intel 2
  "OnUser1 Classic_Mode_Intel3,Enable,,0.0,1",
  "OnUser1 Classic_Mode_Intel4,Enable,,0.0,1",
  "OnUser1 Classic_Mode_Intel5,Enable,,0.0,1",
  "OnUser1 Classic_Mode_Intel6,Enable,,0.0,1"
};
int BEM = 0;

//Brawler Emergency Mode Rewrite
void Emerge(int stage){
  switch(stage){
    case 0:{
      BEM = 0;
      core.brawler_emergency = true;
      EmitSoundToAll(SFXArray[55].realPath);
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
      EmitSoundToAll(SFXArray[6].realPath);
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

//Converts chars to bool by checking if it's a bool statement
public bool CharToBool(const char[] str){
  return (StrContains(str, "true") > 0 ? true : false);
}

//Wave failsafe system - To be implemented better by making an enum struct and doing failSafe[x].execute(); in FartsysAss.sp
void PerformWaveFailsafe(int x){
  switch(x){
    case 0:{
      ServerCommand("sm_freeze @blue; wait 180; sm_smash @blue;sm_evilrocket @blue");
    }
    case 1:{
      ServerCommand("sm_smite @blue");
    }
  }
}
stock float FloatMin(float a, float b) {
  return a <= b ? a : b;
}
stock float FloatMax(float a, float b) { 
  return a >= b ? a : b;
}