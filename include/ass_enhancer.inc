//Fartsy's Scene Enhancer v1.0.0 (Inspired by Mrbt0907/Weather2Remastered)

bool Enhancer_IsWave;
//All background music
enum struct BGM {
  char realPath[64];
  char songName[64];
  int refireTime;
  int ticksOffset;
  int SNDLVL;
}
BGM BGMArray[32];

//All sound effects
enum struct SFXARRAY {
  char realPath[64];
  int SNDLVL;
}
SFXARRAY SFXArray[127];

//Light Entities
bool g_PowerOutage;
enum struct MAPLIGHTING {
  bool hasCustomPattern;
  bool isBroken;
  char arcs[32];
  char beam[32];
  char buzz[32];
  char explosion[35];
  char light[32];
  char status[32];
  char stun[32];
  char zap[32];
  void Explode(){
    if(this.isBroken) return;
    this.isBroken = true;
    FastFire2(this.arcs, "StartSpark", "", 0.0, false);
    FastFire2(this.arcs, "StartSpark", "", 0.1, false);
    FastFire2(this.beam, "LightOff", "", 0.0, false);
    FastFire2(this.buzz, "PlaySound", "", 0.0, false);
    FastFire2(this.explosion, "Explode", "", 0.0, false);
    FastFire2(this.light, "TurnOff", "", 0.0, false);
    FastFire2(this.status, "Color", "255 0 0", 0.0, false);
    FastFire2(this.stun, "Enable", "", 0.0, false);
    FastFire2(this.zap, "Enable", "", 0.0, false);
  }
  void Repair(){
    this.isBroken = false;
    FastFire2(this.arcs, "StopSpark", "", 0.0, false);
    FastFire2(this.buzz, "StopSound", "", 0.25, false);
    FastFire2(this.status, "Color", "0 255 0", 0.0, false);
    FastFire2(this.stun, "Disable", "", 0.0, false);
    FastFire2(this.zap, "Disable", "", 0.0, false);
    if(!g_PowerOutage) {
      FastFire2(this.light, "SetPattern", "", 0.0, false);
      FastFire2(this.light, "TurnOff", "", 0.0, false);
      FastFire2(this.light, "TurnOn", "", 0.1, false);
      FastFire2(this.light, "SetPattern", "", 0.1, false);
      FastFire2(this.beam, "LightOff", "", 0.1, false);
      FastFire2(this.beam, "LightOn", "", 0.2, false);
    }
  }
  void RestorePower(){
    if(!this.isBroken || strcmp(this.light, "MapLighting.StreetLamp0C.light") == 0){
      FastFire2(this.light, "TurnOn", "", 0.0, false);
      FastFire2(this.beam, "LightOn", "", 0.0, false);
      FastFire2(this.beam, "LightOn", "", 1.0, false);
      FastFire2(this.beam, "LightOn", "", 3.0, false);
      FastFire2(this.light, "SetPattern", "", 0.0, false);
      this.hasCustomPattern = false;
    }
  }
}
MAPLIGHTING MapLighting[15];

//Weather Manager
BULKFIRE lightningStrike[16];
BULKFIRE lightningFlash[13];
enum struct WEATHERMANAGER {
  bool canTornado;
  bool hasTornado;
  bool powerSurging;
  bool sirenExplode;
  bool sirenExploded;
  bool tickWeather;
  bool TornadoTimerActive;
  bool TornadoWarning;
  char defFogStartDist[5];
  char defFogEndDist[5];
  char defRainDensity;
  char rainDensity;
  float fogDensity;
  float defFogDensity;
  float fogTarget;
  float fogChangeRate;
  float sirenPitch;
  float sirenPitchRate;
  float sirenPitchTarget;
  int intensity;
  int mIntensity;
  void Activate(){
    this.Reset();
    sudo(1001); //Stop any BGM
    FastFire2("Weather.Sky", "Enable", "", 0.0, false);
    this.tickWeather = true;
    this.PerformRandomWeather(); //Start weather system
  }
  void doLightning(){
    sudo(1003);
    FastFire2(lightningStrike[GetRandomInt(0, sizeof(lightningStrike)-1)].fireStr, "", "", 0.0, true);
    FastFire2("Weather.LightningHurt*", "Disable", "", 0.07, false);
    CustomSoundEmitter(SFXArray[GetRandomInt(27, 34)].realPath, 65, false, 0, 1.0, 100);
    //Affect lights
    int i = GetRandomInt(this.intensity, 15);
    AssLogger(LOGLVL_DEBUG, "Doing light interactions with %i", i);
    switch(i){
      case 2,3,5:{
        int index = GetRandomInt(0, 12);
        float f = GetRandomFloat(0.5, 3.0);
        FastFire2(MapLighting[index].light, "TurnOff", "", 0.0, false);
        FastFire2(MapLighting[index].beam, "LightOff", "", 0.0, false);
        FastFire2(MapLighting[index].light, "TurnOn", "", f, false);
        FastFire2(MapLighting[index].beam, "LightOn", "", f, false);
      }
      case 11,15:{
        g_PowerOutage = true;
        if(!this.hasTornado) CreateTimer(GetRandomFloat(5.0, 30.0), RestorePower, GetRandomInt(0, 3));
        FastFire2("MapLighting.*", "LightOff", "", 0.0, false);
        FastFire2("MapLighting.*", "TurnOff", "", 0.0, false);
        FastFire2("MapLighting.*", "LightOff", "", 1.0, false);
        FastFire2("MapLighting.*", "LightOff", "", 2.0, false);
        FastFire2("MapLighting.*", "LightOff", "", 3.0, false);
        FastFire2("MapLighting.*", "LightOff", "", 4.0, false);
        FastFire2("MapLighting.*", "LightOff", "", 5.0, false);
      }
    }
  }
  void Dissipate(){
    this.sirenPitchTarget = 0.0;
    this.sirenPitchRate = 0.25;
    this.fogTarget = this.defFogDensity;
    g_PowerOutage = false;
    this.hasTornado = false;
    if(Enhancer_IsWave){
      this.mIntensity = 5;
      this.intensity = 7; 
    } else {
      this.mIntensity = 0;
      this.intensity = 0;
    }
    if (this.sirenExploded) {
      this.sirenPitch = 0.0;
      this.sirenExploded = false;
    }
    this.TornadoWarning = false;
    CreateTimer(GetRandomFloat(45.0, 135.0), ResetTornado);
    for (int i = 0; i < sizeof(MapLighting); i++) if (!MapLighting[i].isBroken) FastFire2(MapLighting[i].light, "TurnOn", "", 0.0, false);
    FastFire2("Weather.FogOutdoor", "SetStartDistLerp", this.defFogStartDist, 0.0, false);
    FastFire2("Weather.FogOutdoor", "SetEndDistLerp", this.defFogEndDist, 0.0, false);
    FastFire2("Weather.FogOutdoor", "StartFogTransition", "", 0.0, false);
    FastFire2("tornadof1", "Stop", "", 0.0, false);
    FastFire2("TornadoKill", "Disable", "", 0.0, false);
    FastFire2("tornadof1wind", "Disable", "", 0.0, false);
    FastFire2("tornadowindf1", "StopSound", "", 0.0, false);
    FastFire2("shaketriggerf1", "Disable", "", 0.0, false);
    FastFire2("tornadobutton", "Unlock", "", 30.0, false);
    FastFire2("FB.FakeTankTank01", "Kill", "", 0.0, false);
    FastFire2("FB.FakeTankPhys01", "Kill", "", 0.0, false);
    FastFire2("Weather.EASScreen", "Disable", "", 0.0, false);
    FastFire2("Weather.Siren.ExplodeParticle", "Stop", "", 0.0, false);
    FastFire2("Weather.Siren", "StopSound", "", 5.0, false);
  }
  void FormTornado(){
    this.hasTornado = true;
    this.mIntensity = 15;
    this.intensity = 15;
    CreateTimer(1.5, TornadoShaker);
    FastFire2("TornadoKill", "Enable", "", 0.0, false);
    FastFire2("tornadobutton", "Lock", "", 0.0, false);
    FastFire2("tornadof1", "Start", "", 20.0, false);
    FastFire2("shaketriggerf1", "Enable", "", 20.0, false);
    FastFire2("tornadowindf1", "PlaySound", "", 20.0, false);
    FastFire2("tornadof1wind", "Enable", "", 21.50, false);
    float f = GetRandomFloat(60.0, 120.0);
    CreateTimer(f, TimedOperator, 42);
  }
  void IssueTornadoWarning(){
    this.TornadoWarning = true;
    this.sirenPitchTarget = 100.0;
    this.sirenPitchRate = 0.1;
    FastFire2("Weather.EASScreen", "Enable", "", 0.0, false);
    FastFire2("Weather.EAS", "PlaySound", "", 0.0, false);
    CreateTimer(GetRandomFloat(1.0, 3.0), ModulateSiren);
  }
  void PerformRandomWeather(){
    if (!this.tickWeather) return;
    AssLogger(LOGLVL_DEBUG, "[Fartsy's Enhancer] Storm Intensity @ %f% (%i)", (this.intensity / 15.0), this.intensity);
    this.doLightning();
    float flStormMin;
    float flStormMax;
    switch(GetRandomInt(this.mIntensity, this.intensity)){
      case 0:{
        this.SetFogStartQueued("500");
        this.SetFogEndQueued("3000");
        this.StartFogTransition();
        flStormMin = 15.0;
        flStormMax = 35.0;
        this.fogTarget = 0.55;
        FastFire2("rain", "Alpha", "15", 0.0, false);
        CustomSoundEmitter(SFXArray[108].realPath, 65, false, 1, 0.1, 100); //Rain, no wind, reduced volume
      }
      case 1:{
        this.SetFogStartQueued("500");
        this.SetFogEndQueued("2700");
        this.StartFogTransition();
        flStormMin = 12.0;
        flStormMax = 32.0;
        this.fogTarget = 0.60;
        FastFire2("rain", "Alpha", "30", 0.0, false);
        CustomSoundEmitter(SFXArray[108].realPath, 65, false, 1, 0.1, 100); //Rain, no wind, reduced volume
      }
      case 2:{
        this.SetFogStartQueued("500");
        this.SetFogEndQueued("2500");
        this.StartFogTransition();
        this.mIntensity = 1;
        flStormMin = 12.0;
        flStormMax = 30.0;
        FastFire2("rain", "Alpha", "50", 0.0, false);
        CustomSoundEmitter(SFXArray[108].realPath, 65, false, 1, 0.1, 100); //Rain, no wind, increased volume
      }
      case 3:{
        this.SetFogStartQueued("500");
        this.SetFogEndQueued("2500");
        this.StartFogTransition();
        flStormMin = 10.0;
        flStormMax = 28.5;
        this.fogTarget = 0.70;
        FastFire2("rain", "Alpha", "65", 0.0, false);
        CustomSoundEmitter(SFXArray[108].realPath, 65, false, 1, 0.1, 100); //Rain, no wind, increased volume
      }
      case 4:{
        flStormMin = 9.0;
        flStormMax = 26.5;
        FastFire2("rain", "Alpha", "75", 0.0, false);
        CustomSoundEmitter(SFXArray[108].realPath, 65, false, 1, 1.0, 100); //Rain, no wind, increased volume
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.1, 100); //Rain, wind, decreased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.01, 100); //Extra wind
      }
      case 5:{
        this.SetFogStartQueued("500");
        this.SetFogEndQueued("2100");
        this.StartFogTransition();
        this.mIntensity = 3;
        flStormMin = 7.0;
        flStormMax = 25.0;
        this.fogTarget = 0.75;
        FastFire2("rain", "Alpha", "95", 0.0, false);
        CustomSoundEmitter(SFXArray[108].realPath, 65, false, 1, 0.1, 100); //Rain, no wind, decreased volume
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.15, 100); //Rain, wind
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.05, 100); //Extra wind
      }
      case 6:{
        this.mIntensity = 4;
        flStormMin = 7.0;
        flStormMax = 23.5;
        FastFire2("rain", "Alpha", "125", 0.0, false);
        CustomSoundEmitter(SFXArray[108].realPath, 65, false, 1, 0.05, 100); //Rain, no wind, decreased volume
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.21, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.125, 100); //Extra wind
      }
      case 7:{
        this.SetFogStartQueued("500");
        this.SetFogEndQueued("2000");
        this.StartFogTransition();
        flStormMin = 6.0;
        flStormMax = 21.0;
        this.fogTarget = 0.80;
        FastFire2("rain", "Alpha", "155", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 0);
        CustomSoundEmitter(SFXArray[108].realPath, 65, false, 1, 0.05, 100); //Rain, no wind, decreased volume
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.26, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.25, 100); //Extra wind
      }
      case 8:{
        this.mIntensity = 6;
        this.SetFogStartQueued("470");
        this.SetFogEndQueued("2000");
        this.StartFogTransition();
        flStormMin = 5.0;
        flStormMax = 20.0;
        this.fogTarget = 0.875;
        FastFire2("rain", "Alpha", "175", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 1);
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.37, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.35, 100); //Extra wind
      }
      case 9:{
        this.SetFogStartQueued("425");
        this.SetFogEndQueued("1500");
        this.StartFogTransition();
        this.mIntensity = 7;
        flStormMin = 5.0;
        flStormMax = 19.0;
        FastFire2("rain", "Alpha", "200", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 2);
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.41, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.42, 100); //Extra wind
      }
      case 10:{
        this.SetFogStartQueued("375");
        this.SetFogEndQueued("1500");
        this.StartFogTransition();
        flStormMin = 5.0;
        flStormMax = 18.0;
        this.fogTarget = 0.925;
        FastFire2("rain", "Alpha", "215", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 3);
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.45, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.56, 100); //Extra wind
      }
      case 11:{
        this.mIntensity = 9;
        flStormMin = 5.0;
        flStormMax = 17.0;
        FastFire2("rain", "Alpha", "235", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 4);
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.63, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.69, 100); //Extra wind
      }
      case 12:{
        this.mIntensity = 10;
        flStormMin = 5.0;
        flStormMax = 15.0;
        this.fogTarget = 1.0;
        this.SetFogStartQueued("225");
        this.SetFogEndQueued("700");
        this.StartFogTransition();
        FastFire2("rain", "Alpha", "255", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 5);
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.72, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.76, 100); //Extra wind
        if (!this.TornadoTimerActive) sudo(1004);
      }
      case 13:{
        this.SetFogStartQueued("200");
        this.SetFogEndQueued("700");
        this.StartFogTransition();
        this.mIntensity = 12;
        flStormMin = 5.0;
        flStormMax = 14.0;
        this.fogTarget = 1.0;
        FastFire2("rain", "Alpha", "255", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 6);
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.85, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.83, 100); //Extra wind
        if (!this.TornadoTimerActive) sudo(1004);
      }
      case 14:{
        this.mIntensity = 13;
        this.SetFogStartQueued("100");
        this.SetFogEndQueued("700");
        this.StartFogTransition();
        flStormMin = 5.0;
        flStormMax = 13.0;
        this.fogTarget = 1.0;
        FastFire2("rain", "Alpha", "255", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 7);
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 0.9, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 0.92, 100); //Extra wind
        if (!this.TornadoTimerActive) sudo(1004);
      }
      case 15:{
        this.mIntensity = 14;
        this.SetFogStartQueued("50");
        this.SetFogEndQueued("500");
        this.StartFogTransition();
        flStormMin = 5.0;
        flStormMax = 12.0;
        this.fogTarget = 1.0;
        FastFire2("rain", "Alpha", "255", 0.0, false);
        CreateTimer(GetRandomFloat(0.1, 1.25), GetRandomWind, 7);
        CustomSoundEmitter(SFXArray[107].realPath, 65, false, 1, 1.0, 100); //Rain, wind, increased volume
        CustomSoundEmitter(SFXArray[109].realPath, 65, false, 1, 1.0, 100); //Extra wind
        if (!this.TornadoTimerActive) sudo(1004);
      }
      default:{
      }
    }
    CreateTimer(GetRandomFloat(flStormMin, flStormMax), GetRandomWeather);
  }
  void Reset(){
    AssLogger(LOGLVL_DEBUG, "[Fartsy's Enhancer] WeatherManager has been reset!");
    this.fogDensity = 0.50;
    this.Dissipate();
    this.tickWeather = false;
    FastFire2("rain", "Alpha", "0", 0.0, false);
  }
  void SetFogStartQueued(const char[] fsq){
    FastFire2("Weather.FogOutdoor", "SetStartDistLerpTo", fsq, 0.0, false);
  }
  void SetFogEndQueued(const char[] feq){
    FastFire2("Weather.FogOutdoor", "SetEndDistLerpTo", feq, 0.0, false);
  }
  void StartFogTransition(){
    FastFire2("Weather.FogOutdoor", "StartFogTransition", "", 0.0, false);
  }
  void TickFogDensity(){
    if(this.fogDensity != this.fogTarget){
      char targetDensity[24];
      this.fogDensity = (this.fogDensity < this.fogTarget) ? FloatMin(this.fogDensity+=this.fogChangeRate, this.fogTarget) : FloatMax(this.fogDensity-=this.fogChangeRate, this.fogTarget);
      FloatToString(this.fogDensity, targetDensity, sizeof(targetDensity));
      FastFire2("Weather.FogOutdoor", "SetMaxDensity", targetDensity, 0.0, false);
    }
  }
  void TickSiren(){
    if(this.TornadoWarning){
      if(!this.sirenExploded && (this.sirenPitch > 165.0)){
        FastFire2("Weather.Siren", "Pitch", "50", 0.0, false);
        FastFire2("Weather.Siren", "Pitch", "40", 0.1, false);
        FastFire2("Weather.Siren", "Pitch", "30", 0.2, false);
        FastFire2("Weather.Siren", "Pitch", "20", 0.3, false);
        FastFire2("Weather.Siren", "Pitch", "10", 0.4, false);
        FastFire2("Weather.Siren", "Pitch", "0", 0.5, false);
        FastFire2("Weather.Siren.ExplodeParticle", "Start", "", 0.0, false);
        FastFire2("Weather.Siren.ExplodeSND", "PlaySound", "", 0.0, false);
        FastFire2("Weather.Siren", "StopSound", "", 5.0, false);
        FastFire2("Weather.Siren.ExplodeParticle", "Stop", "", 5.0, false);
        FastFire2("Weather.Siren.ExplodeParticle", "Start", "", 5.1, false);
        this.sirenExploded = true;
      }
      if(this.sirenPitch != this.sirenPitchTarget && !this.sirenExploded){
        char targetPitch[24];
        this.sirenPitch = (this.sirenPitch < this.sirenPitchTarget) ? FloatMin(this.sirenPitch+=this.sirenPitchRate, this.sirenPitchTarget) : FloatMax(this.sirenPitch-=this.sirenPitchRate, this.sirenPitchTarget);
        FloatToString(this.sirenPitch, targetPitch, sizeof(targetPitch));
        FastFire2("Weather.Siren", "Pitch", targetPitch, 0.0, false);
        PrintToServer("SirenPitch = %s", targetPitch);
      }
    }
  }
}
WEATHERMANAGER WeatherManager;

//Ghosties
enum struct GHOSTHANDLER {
  bool placeholder;
  void SpawnRandom(){
    switch(GetRandomInt(0,3)){
      case 0:{
        FastFire2("gTrain", "TeleportToPathTrack", "gPath00_0", 0.0, false);
      }
      case 1:{
        FastFire2("gTrain", "TeleportToPathTrack", "gPath01_0", 0.0, false);
      }
      case 2:{
        FastFire2("gTrain", "TeleportToPathTrack", "gPath02_0", 0.0, false);
      }
      case 3:{
        FastFire2("gTrain", "TeleportToPathTrack", "gPath03_0", 0.0, false);
      }
    }
  }
}
GHOSTHANDLER GhostHandler;

//Timers
public Action GetRandomWeather(Handle timer){
  if(WeatherManager.tickWeather){
    switch(GetRandomInt (0, 10)){
      case 0,4,8:{
        if(WeatherManager.intensity > 9) GhostHandler.SpawnRandom();
        if (WeatherManager.intensity > 0 && (WeatherManager.intensity-1 > WeatherManager.mIntensity)) WeatherManager.intensity--;
      }
      case 1,2,3,5,6,7,9,10:{
        if (WeatherManager.intensity < 15) WeatherManager.intensity++;
      }
    }
    WeatherManager.PerformRandomWeather();
  }
  return Plugin_Stop;
}
public Action GetRandomWind(Handle timer, int intensity){
  switch(intensity){
    case 0:{
      CustomSoundEmitter(SFXArray[GetRandomInt(113, 114)].realPath, 65, true, 1, 0.125, 100);
    }
    case 1:{
      CustomSoundEmitter(SFXArray[GetRandomInt(113, 114)].realPath, 65, true, 1, 0.20, 100);
    }
    case 2:{
      CustomSoundEmitter(SFXArray[GetRandomInt(113, 114)].realPath, 65, true, 1, 0.30, 100);
    }
    case 3:{
      CustomSoundEmitter(SFXArray[GetRandomInt(113, 115)].realPath, 65, true, 1, 0.45, 100);
    }
    case 4:{
      CustomSoundEmitter(SFXArray[GetRandomInt(113, 115)].realPath, 65, true, 1, 0.55, 100);
    }
    case 5:{
      CustomSoundEmitter(SFXArray[GetRandomInt(113, 115)].realPath, 65, true, 1, 0.65, 100);
    }
    case 6:{
      CustomSoundEmitter(SFXArray[GetRandomInt(113, 116)].realPath, 65, true, 1, 0.80, 100);
    }
    case 7:{
      CustomSoundEmitter(SFXArray[GetRandomInt(113, 116)].realPath, 65, true, 1, 1.0, 100);
    }
  }
  return Plugin_Stop;
}
public Action ModulateSiren(Handle timer){
  if(WeatherManager.TornadoWarning && !WeatherManager.sirenExplode){
    WeatherManager.sirenPitchTarget = WeatherManager.powerSurging ? GetRandomFloat(95.0, 210.0) : GetRandomFloat(85.0, 125.0);
    WeatherManager.sirenPitchRate = WeatherManager.powerSurging ? GetRandomFloat(0.0525, 0.20) : GetRandomFloat(0.01, 0.125);
    CreateTimer(GetRandomFloat(1.0, 3.0), ModulateSiren);
  }
  return Plugin_Stop;
}

public Action ResetTornado(Handle timer){
  WeatherManager.canTornado = true;
  WeatherManager.TornadoTimerActive = false;
  return Plugin_Stop;
}

public Action RestorePower(Handle timer, int surge){
  g_PowerOutage = false;
  WeatherManager.powerSurging = ((surge == 1) ? true : false);
  if (surge == 1){
    CreateTimer(1.0, SurgePower);
  }
  for (int i = 0; i < sizeof(MapLighting); i++) MapLighting[i].RestorePower();
  FastFire2("MapLighting.Indoor*", "TurnOn", "", 0.0, false);
  FastFire2("MapLighting.Indoor*", "LightOn", "", 0.0, false);
  return Plugin_Stop;
}

char LightingPatterns[][25] = {
  /////Allistor/////
  "sduehrjkihwerte",
  "ihqopeiruhiqwer",
  "sadnpiudghsfiod",
  "kjahbfihkabweoi",
  "djfohoaeiufgawt",
  "ewrtyvghbvfczfr",
  "aesrergtafdcgvz",
  "aeradyjdghnyjxc",
  "oihaecpnefijanle",
  "oaihbewrpoijnae",
  //////Jeffy///////
  "gewsaadgfhgtfsr",
  "kuyijyterytdfsadfvgzs",
  "bvcxfgtertyaetr",
  "gyukkjtyasde",
  "bxcvmvbnhkgfj",
  "ewrhrtmhgjf",
  "bfgmghntjy",
  "afsdgdsfayrwte",
  "hfgjgfdiyet",
  "fsdbvxfgkytestry"
};

public Action SurgePower(Handle timer){
  if (WeatherManager.powerSurging){
    int target = GetRandomInt(0, 12);
    if (MapLighting[target].isBroken) target = GetRandomInt(0, 12);
    if(!MapLighting[target].isBroken){
      if (GetRandomInt(0, 7) == 5) MapLighting[target].Explode();
      FastFire2(MapLighting[target].light, "SetPattern", LightingPatterns[GetRandomInt(0, 19)], 0.0, false);
      FastFire2(MapLighting[target].light, "TurnOn", "", 0.0, false);
      FastFire2(MapLighting[target].beam, "LightOn", "", 0.0, false);
      CreateTimer(GetRandomFloat(7.5, 15.0), RestorePower, 0);
      CreateTimer(GetRandomFloat(0.1, 3.0), SurgePower);
      CreateTimer(GetRandomFloat(1.5, 2.0), SurgePowerFX);
    }
  }
  return Plugin_Stop;
}

public Action SurgePowerFX(Handle timer){
  for (int i = 0; i < sizeof(MapLighting); i++){
    if(WeatherManager.powerSurging && !MapLighting[i].isBroken){
      FastFire2(MapLighting[i].light, "SetPattern", LightingPatterns[GetRandomInt(0, 19)], 0.0, false);
      FastFire2(MapLighting[i].beam, "LightOff", "", 0.0, false);
      FastFire2(MapLighting[i].beam, "LightOn", "", GetRandomFloat(0.1, 0.35), false);
      FastFire2(MapLighting[i].beam, "LightOff", "", GetRandomFloat(0.4, 0.75), false);
      FastFire2(MapLighting[i].beam, "LightOn", "", GetRandomFloat(1.0, 1.35), false);
    }
  }
  return Plugin_Stop;
}
public Action TornadoShaker(Handle timer){
  if(WeatherManager.hasTornado){
    FastFire2("tornadoshake_f1", "StartShake", "", 0.0, false);
    CreateTimer(1.5, TornadoShaker);
  }
  return Plugin_Stop;
}
//Music system rewrite for the 6th time. I will never make a change. My code will never mend. Still everything's the same and it all just fades to math.
enum struct AUDIOMANAGER {
  bool bgmPlaying;
  bool shouldTick;
  bool stopBGM;
  bool tickBGMOffset;
  char cachedPath[128];
  char songName[128];
  int indexBGM;
  int refireBGM;
  int chanBGM;
  int ticksBGM;
  int VIPBGM;
  void ChangeBGM(int bgm){
    this.indexBGM = (this.VIPBGM >= 0 ? this.VIPBGM : bgm);
    this.ticksBGM = -2;
    this.refireBGM = 2;
    this.shouldTick = true;
    this.tickBGMOffset = BGMArray[this.indexBGM].ticksOffset > 0 ? true : false;
    this.stopBGM = (!StrEqual(this.cachedPath, BGMArray[this.indexBGM].realPath) ? true : false);
    this.bgmPlaying = true;
    if (this.indexBGM >= 20) for (int i = 0; i < MaxClients; i++) for (int s = 19; s < bgm; s++) StopSound(i, this.chanBGM, BGMArray[s].realPath); //Very quick, very dirty, very suboptimal, but gets the job done... This stops all boss music.
  }
  void Reset() {
    this.stopBGM = true;
    this.indexBGM = GetRandomInt(1, 4);
    this.ticksBGM = -2;
    this.refireBGM = 2;
    for (int i = 0; i < MaxClients; i++) for (int s = this.indexBGM; s < sizeof(BGMArray); s++) StopSound(i, this.chanBGM, BGMArray[s].realPath); //Very quick, very dirty, very suboptimal, but gets the job done... This stops all boss music.
    AssLogger(LOGLVL_DEBUG, "AudioManager has been reset!");
  }
  void Stop() {
    this.stopBGM = true;
    this.ticksBGM = -2;
    this.refireBGM = 2;
    this.shouldTick = false;
  }
  void TickBGM() {
    this.ticksBGM++;
    if (this.ticksBGM >= this.refireBGM) {
      if (this.stopBGM){
        for (int i = 0; i < MaxClients; ++i) {
          StopSound(i, this.chanBGM, this.cachedPath);
          this.stopBGM = false;
        }
      }
      strcopy(this.songName, sizeof(this.songName), BGMArray[this.indexBGM].songName);
      this.refireBGM = BGMArray[this.indexBGM].refireTime;
      this.ticksBGM = (this.tickBGMOffset ? BGMArray[this.indexBGM].ticksOffset : 0);
      CustomSoundEmitter(BGMArray[this.indexBGM].realPath, BGMArray[this.indexBGM].SNDLVL, true, 1, 1.0, 100);
      CreateTimer(1.0, SyncMusic, this.indexBGM);
    }
  }
}
AUDIOMANAGER AudioManager;