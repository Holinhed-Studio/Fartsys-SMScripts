#include <sdktools>
#include <sourcemod>
#pragma newdecls required

bool aimAtPlayers = false;
static char PLUGIN_VERSION[8] = "1.0.0";

public Plugin myinfo = {
  name = "Fartsy's Ass - Framework",
  author = "Fartsy#8998",
  description = "Framework for Fartsy's Ass (MvM Mods)",
  version = PLUGIN_VERSION,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart() {
  RegServerCmd("fb_test", Command_Test, "");
  RegServerCmd("fb_stoptest", Command_StopTest, "");
}

public Action Command_Test(int args) {
    aimAtPlayers = true;
}

public Action Command_StopTest(int args){
    aimAtPlayers = false;
}

public Action GetClosestEnemy(int entity) {
  int x = -1;
  float flDistMin = -1.0;
  float flDist;
  float position[3];
  float yPos[3];
  GetEntPropVector(entity, Prop_Send, "m_vecOrigin", position);
  for (int y = 1; y <= MaxClients; y++)
    if (IsClientInGame(y) && IsPlayerAlive(y) && GetClientTeam(y) == 2) {
      GetClientAbsOrigin(y, yPos);
      flDist = GetVectorDistance(position, yPos);
      if (flDist < 0.0)
        flDist *= -1.0;

      if (flDistMin == -1.0 || flDist < flDistMin) {
        flDistMin = flDist;
        x = y;
      }
    }
  return x;
}

public void OnGameFrame(){
    if(!aimAtPlayers){
        return;
    } else {
        tickClosest();
    }
}
//Target player
//I wonder what this could do... What would happen if I played around with this function to rewrite it for a very specific purpose...
public Action tickClosest() {
  float angles[3];
  float clientEyes[3];
  float targetEyes[3];
  float resultant[3];
  int Ent = FindEntityByClassname(-1, "func_tracktrain"); //Get index of the entity.
  if (Ent == -1) {
    PrintToChatAll("Ent not found");
    return Plugin_Handled;
  } else {
    char targetname[128];
    GetEntPropString(Ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
    if (StrEqual(targetname, "base")) {
      GetEntPropVector(Ent, Prop_Send, "m_vecOrigin", targetEyes);
      int x = GetClosestEnemy(Ent);
      if(x == -1){
        return Plugin_Handled;
      }
      else{
      //PrintToChatAll("Client %N is closest. They are #%i.", x, x);
        GetClientEyePosition(x, clientEyes);
        MakeVectorFromPoints(targetEyes, clientEyes, resultant);
        GetVectorAngles(resultant, angles);
        if (angles[0] >= 270) {
            angles[0] -= 270;
            angles[0] = (90 - angles[0]);
        } else {
            if (angles[0] <= 90) {
            angles[0] *= -1;
            }
        }
        TeleportEntity(Ent, NULL_VECTOR, angles, NULL_VECTOR);
      }
    }
  }
  return Plugin_Handled;
}