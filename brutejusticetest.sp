#include <sdktools>

#include <sourcemod>

#pragma newdecls required
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
}
public Action Command_Test(int args) {
  char arg1[16];
  GetCmdArg(1, arg1, sizeof(arg1));
  int x = StringToInt(arg1);
  LookAtTarget(x);
}
/*
//I wonder what this could do... What would happen if I played around with this function to rewrite it for a very specific purpose...
public Action LookAtTarget1(any client) {
  float angles[3];
  float clientEyes[3];
  float targetEyes[3];
  float resultant[3];
  GetClientEyePosition(client, clientEyes);
  int Ent = FindEntityByClassname(-1, "prop_dynamic"); //Get index of Sephiroth Tank
  if (Ent == -1) {
    PrintToChatAll("Ent not found");
    return Plugin_Handled;
  } else {
    char targetname[128];
    GetEntPropString(Ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
    if (StrEqual(targetname, "test")) {
      GetEntPropVector(Ent, Prop_Send, "m_vecOrigin", targetEyes);
    }
  }
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
  angles[1] -= 180;
  TeleportEntity(Ent, NULL_VECTOR, angles, NULL_VECTOR);
  return Plugin_Handled;
}*/

public Action GetClosestEnemy(any entity) {
  int iClosest = -1;
  float flMinDistance = -1.0;
  float flDistance;
  float position[3];
  float vecOtherOrigin[3];
  GetEntPropVector(entity, Prop_Send, "m_vecOrigin", position);
  for (int iOther = 1; iOther <= MaxClients; iOther++)
    if (IsClientInGame(iOther) && IsPlayerAlive(iOther)) {
      GetClientAbsOrigin(iOther, vecOtherOrigin);
      flDistance = GetVectorDistance(position, vecOtherOrigin);
      if (flDistance < 0.0)
        flDistance *= -1.0;

      if (flMinDistance == -1.0 || flDistance < flMinDistance) {
        flMinDistance = flDistance;
        iClosest = iOther;
      }
    }
  return iClosest;
}

public void OnGameFrame(){
    LookAtTarget(0);
}
//Target player
//I wonder what this could do... What would happen if I played around with this function to rewrite it for a very specific purpose...
public Action LookAtTarget(any client) {
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
        return Plugin_Handled;
      }
    }
  }
}