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