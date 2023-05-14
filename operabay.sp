#include <sourcemod>
#include <sdktools>
#pragma newdecls required;
bool isStorm = false;
static char PLUGIN_VERSION[8] = "1.0.0";
static char GLOBALTHUNDER01[32] = "fartsy/weather/thunder1.wav";
static char GLOBALTHUNDER02[32] = "fartsy/weather/thunder2.wav";
static char GLOBALTHUNDER03[32] = "fartsy/weather/thunder3.wav";
static char GLOBALTHUNDER04[32] = "fartsy/weather/thunder4.wav";
static char GLOBALTHUNDER05[32] = "fartsy/weather/thunder5.wav";
static char GLOBALTHUNDER06[32] = "fartsy/weather/thunder6.wav";
static char GLOBALTHUNDER07[32] = "fartsy/weather/thunder7.wav";
static char GLOBALTHUNDER08[32] = "fartsy/weather/thunder8.wav";
static int SFXSNDLVL = 75;
static int SNDCHAN = 6;
public Plugin myinfo = {
    name = "Operabay's Test Plugin",
    author = "Fartsy#8998",
    description = "Test weather system",
    version = PLUGIN_VERSION,
    url = "https://forums.firehostredux.com"
};

public void OnPluginStart(){
    PrecacheSound(GLOBALTHUNDER01, true);
    PrecacheSound(GLOBALTHUNDER02, true);
    PrecacheSound(GLOBALTHUNDER03, true);
    PrecacheSound(GLOBALTHUNDER04, true);
    PrecacheSound(GLOBALTHUNDER05, true);
    PrecacheSound(GLOBALTHUNDER06, true);
    PrecacheSound(GLOBALTHUNDER07, true);
    PrecacheSound(GLOBALTHUNDER08, true);
    RegAdminCmd("sm_weather", Command_Weather, ADMFLAG_ROOT, "Change map weather conditions");
}

public void OnMapStart(){
    FireEntityInput("OB.Rain", "Alpha", "0", 0.0);
}
public Action Command_Weather(int client, int args){
    ShowWeatherMenu(client);
}

public void ShowWeatherMenu(int client) {
  Menu menu = new Menu(MenuHandlerWeather, MENU_ACTIONS_DEFAULT);
  char buffer[100];
  menu.SetTitle("Operabay Weather Menu");
  menu.AddItem(buffer, "Partly Cloudy");
  menu.AddItem(buffer, "Mostly Cloudy");
  menu.AddItem(buffer, "Rainy");
  menu.AddItem(buffer, "Stormy");
  menu.AddItem(buffer, "Night");
  menu.Display(client, 20);
  menu.ExitButton = true;
}

public int MenuHandlerWeather(Menu menu, MenuAction action, int p1, int p2) {
  if (action == MenuAction_Select) {
    int steamID = GetSteamAccountID(p1);
    if (!steamID) {
      return;
    } else {
      switch(p2){
        case 0:{
            PrintToChat(p1, "You selected Partly Cloudy.");
            ChangeWeather(0);
        }
        case 1:{
            PrintToChat(p1, "You selected Mostly Cloudy");
            ChangeWeather(1);
        }
        case 2:{
            PrintToChat(p1, "You selected Rainy");
            ChangeWeather(2);
            
        }
        case 3:{
            PrintToChat(p1, "You selected Stormy");
            ChangeWeather(3);
        }
        case 4:{
            PrintToChat(p1, "You selected Night.");
            ChangeWeather(4);
        }
      }
    }
  } else if (action == MenuAction_End) {
    CloseHandle(menu);
  }
}

public void ChangeWeather(int type){
    switch(type){
        case 0:{
            isStorm = false;
            FireEntityInput("OB.Daylight", "TurnOn", "", 0.0);
            FireEntityInput("OB.WeatherSystem", "Skin", "0", 0.0);
            FireEntityInput("OB.Rain", "Alpha", "0", 0.0);
        }
        case 1:{
            isStorm = false;
            FireEntityInput("OB.Daylight", "TurnOn", "", 0.0);
            FireEntityInput("OB.WeatherSystem", "Skin", "1", 0.0);
            FireEntityInput("OB.Rain", "Alpha", "0", 0.0);
        }
        case 2:{
            isStorm = false;
            FireEntityInput("OB.Daylight", "TurnOff", "", 0.0);
            FireEntityInput("OB.WeatherSystem", "Skin", "2", 0.0);
            FireEntityInput("OB.Rain", "Alpha", "100", 0.0);
        }
        case 3:{
            isStorm = true;
            CreateTimer(1.0, RefireStorm);
            FireEntityInput("OB.Daylight", "TurnOff", "", 0.0);
            FireEntityInput("OB.WeatherSystem", "Skin", "3", 0.0);
            FireEntityInput("OB.Rain", "Alpha", "200", 0.0);
        }
        case 4:{
            isStorm = false;
            FireEntityInput("OB.Daylight", "TurnOff", "", 0.0);
        }
    }
    return;
}

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

public Action DeleteEdict(Handle timer, any entity) {
  if (IsValidEdict(entity)) RemoveEdict(entity);
  return Plugin_Stop;
}

public void StrikeLightning(){
    FireEntityInput("lightning", "TurnOn", "", 0.0),
      FireEntityInput("OB.WeatherSystem", "Skin", "4", 0.0),
      FireEntityInput("OB.Daylight", "TurnOff", "", 0.0),
      FireEntityInput("LightningLaser", "TurnOn", "", 0.0),
      FireEntityInput("lightning" , "TurnOff", "", 0.1),
      FireEntityInput("OB.WeatherSystem", "Skin", "3", 0.1),
      FireEntityInput("LightningLaser", "TurnOff", "", 0.1),
      FireEntityInput("lightning", "TurnOn", "", 0.17),
      FireEntityInput("OB.WeatherSystem", "Skin", "4", 0.17),
      FireEntityInput("LightningLaser", "TurnOn", "", 0.17),
      FireEntityInput("lightning", "TurnOff", "", 0.25),
      FireEntityInput("OB.WeatherSystem", "Skin", "3", 0.25),
      FireEntityInput("LightningLaser", "TurnOff", "", 0.25);
}
//Timers
public Action RefireStorm(Handle timer) {
  if (isStorm) {
    float f = GetRandomFloat(7.0, 17.0);
    CreateTimer(f, RefireStorm);
    StrikeLightning();
    int Thunder = GetRandomInt(1, 16);
    switch (Thunder) {
    case 1: {
      CustomSoundEmitter(GLOBALTHUNDER01, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt00", "Enable", "", 0.0),
        FireEntityInput("LightningHurt00", "Disable", "", 0.07);
    }
    case 2: {
      CustomSoundEmitter(GLOBALTHUNDER02, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt01", "Enable", "", 0.0),
        FireEntityInput("LightningHurt01", "Disable", "", 0.07);
    }
    case 3: {
      CustomSoundEmitter(GLOBALTHUNDER03, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt02", "Enable", "", 0.0),
        FireEntityInput("LightningHurt02", "Disable", "", 0.07);
    }
    case 4: {
      CustomSoundEmitter(GLOBALTHUNDER04, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt03", "Enable", "", 0.0),
        FireEntityInput("LightningHurt03", "Disable", "", 0.07);
    }
    case 5: {
      CustomSoundEmitter(GLOBALTHUNDER05, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt04", "Enable", "", 0.0),
        FireEntityInput("LightningHurt04", "Disable", "", 0.07);
    }
    case 6: {
      CustomSoundEmitter(GLOBALTHUNDER06, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt05", "Enable", "", 0.0),
        FireEntityInput("LightningHurt05", "Disable", "", 0.07);
    }
    case 7: {
      CustomSoundEmitter(GLOBALTHUNDER07, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt06", "Enable", "", 0.0),
        FireEntityInput("LightningHurt06", "Disable", "", 0.07);
    }
    case 8: {
      CustomSoundEmitter(GLOBALTHUNDER08, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt07", "Enable", "", 0.0),
        FireEntityInput("LightningHurt07", "Disable", "", 0.07);
    }
    case 9: {
      CustomSoundEmitter(GLOBALTHUNDER01, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt08", "Enable", "", 0.0),
        FireEntityInput("LightningHurt08", "Disable", "", 0.07);
    }
    case 10: {
      CustomSoundEmitter(GLOBALTHUNDER02, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt09", "Enable", "", 0.0),
        FireEntityInput("LightningHurt09", "Disable", "", 0.07);
    }
    case 11: {
      CustomSoundEmitter(GLOBALTHUNDER03, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt0A", "Enable", "", 0.0),
        FireEntityInput("LightningHurt0A", "Disable", "", 0.07);
    }
    case 12: {
      CustomSoundEmitter(GLOBALTHUNDER04, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt0B", "Enable", "", 0.0),
        FireEntityInput("LightningHurt0B", "Disable", "", 0.07);
    }
    case 13: {
      CustomSoundEmitter(GLOBALTHUNDER05, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt0C", "Enable", "", 0.0),
        FireEntityInput("LightningHurt0C", "Disable", "", 0.07);
    }
    case 14: {
      CustomSoundEmitter(GLOBALTHUNDER06, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt0D", "Enable", "", 0.0),
        FireEntityInput("LightningHurt0D", "Disable", "", 0.07);
    }
    case 15: {
      CustomSoundEmitter(GLOBALTHUNDER07, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt0E", "Enable", "", 0.0),
        FireEntityInput("LightningHurt0E", "Disable", "", 0.07);
    }
    case 16: {
      CustomSoundEmitter(GLOBALTHUNDER08, SFXSNDLVL, false, 0, 1.0, 100);
      FireEntityInput("LightningHurt0F", "Enable", "", 0.0),
        FireEntityInput("LightningHurt0F", "Disable", "", 0.07);
    }
    }
  }
  return Plugin_Stop;
}

public Action CustomSoundEmitter(char[] sndName, int SNDLVL, bool isBGM, int flags, float vol, int pitch) {
  for (int i = 1; i <= MaxClients; i++) {
    if (IsClientInGame(i) && !IsFakeClient(i)){
      EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, flags, vol, pitch, _, _, _, _, _);
    }
  }
  return Plugin_Handled;
}