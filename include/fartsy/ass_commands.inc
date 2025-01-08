#include <sourcemod>
public Action Command_AOE(int client, int args){
 float pos[3];
 pos[0] = GetCmdArgFloat(1);
 pos[1] = GetCmdArgFloat(2);
 pos[2] = GetCmdArgFloat(3);
 PrintToChat(client, "pos %f %f %f", pos[0], pos[1], pos[2]);
 DispatchCircleAOE(pos);
 return Plugin_Handled;
}

public Action Command_SetFogDensity(int client, int args){
  tickOnslaughter = true;
  char arg1[5];
  GetCmdArg(1, arg1, sizeof(arg1));
  WeatherManager.fogTarget = StringToFloat(arg1);
  PrintToChatAll("Changing fog density to %s", arg1);
  return Plugin_Handled;
}
public Action Command_SetFogSEU(int client, int args){
  char arg01[5];
  char arg02[5];
  char arg03[5];
  GetCmdArg(1, arg01, sizeof(arg01));
  GetCmdArg(2, arg02, sizeof(arg02));
  GetCmdArg(3, arg03, sizeof(arg03));
  WeatherManager.SetFogStartQueued(arg01);
  WeatherManager.SetFogEndQueued(arg02);
  if (StringToInt(arg03) == 1) WeatherManager.StartFogTransition();
  PrintToChatAll("Received fog start: %s, fog end: %s, begin transition: %s", arg01, arg02, arg03);
  return Plugin_Handled;
}

//Get client's stats via command
public Action Command_MyStats(int client, int args) {
  int steamID = GetSteamAccountID(client);
  if (!Get_Ass_Database() || !steamID || steamID <= 10000) return Plugin_Stop;
  char queryID[256];
  Format(queryID, sizeof(queryID), "SELECT * from ass_activity WHERE steamid = %i;", steamID);
  Get_Ass_Database().Query(MyStats, queryID, client);
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
    if(WeatherManager.TornadoWarning && item == 5){
      CPrintToChatAll("{darkred}[Fartsy's Operator] {limegreen}-> {red}%N {darkred}I'm sorry, it is too late for that.. You are doomed...", client);
    }
    else sudo(ass[item].purchase);
    AssLogger(LOGLVL_INFO, "%N opted for %s via the A.S.S.", client, ass[item].name);
  } else if (action == MenuAction_End) CloseHandle(menu);
  return 0;
}
//Command action definitions
//Get current song
public Action Command_GetCurrentSong(int client, int args) {
  char buffer[16];
  char tbuffer[16];
  int sPos = RoundToFloor(AudioManager.ticksBGM / 66.6666666666);
  int tPos = RoundToFloor(AudioManager.refireBGM / 66.6666666666);
  Format(buffer, 16, "%02d:%02d", sPos / 60, sPos % 60);
  Format(tbuffer, 16, "%02d:%02d", tPos / 60, tPos % 60);
  CPrintToChat(client, "The current song is: {limegreen}%s {orange}(%s / %s)", AudioManager.songName, buffer, tbuffer);
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
  CustomSoundEmitter(SFXArray[41].realPath, 65, false, 0, 1.0, 100);
  CreateTimer(5.0, ReturnClient, client);
  return Plugin_Handled;
}

//Return the client to spawn
public Action ReturnClient(Handle timer, int clientID) {
  TeleportEntity(clientID, Return, NULL_VECTOR, NULL_VECTOR);
  CSEClient(clientID, SFXArray[42].realPath, 65, false, 0, 1.0, 100);
  return Plugin_Handled;
}

//Join us on Discord!
public Action Command_Discord(int client, int args) {
  CPrintToChat(client, "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Our Discord server URL is {darkviolet}https://discord.com/invite/ZfUUQWxCmw{white}.");
  ShowMOTDPanel(client, "FireHostRedux Discord", "https://discord.com/invite/ZfUUQWxCmw", MOTDPANEL_TYPE_URL);
  return Plugin_Handled;
}

//Operator, core of the entire map
public Action Command_Operator(int args) {
  char arg1[16];
  GetCmdArg(1, arg1, sizeof(arg1));
  sudo(StringToInt(arg1));
  return Plugin_Continue;
}