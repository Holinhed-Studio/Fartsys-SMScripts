#include <sdktools>
#include <sourcemod>
#pragma newdecls required
bool isTankAlive = false;
bool tankDeploy = false;
char charHP[16];
static char COUNTDOWN[32] = "fartsy/misc/countdown.wav";
static char PLG_VER[8] = "1.0.2";

public Plugin myinfo = {
    author = "Fartsy#8998",
    description = "Don't worry about it...",
    version = PLG_VER,
    url = "https://forums.firehostredux.com"
};

public void OnPluginStart(){
    PrecacheSound(COUNTDOWN, true);
    RegServerCmd("fb_operator", Command_Operator, "Server-side only. Does nothing when excecuted as client.");
}

//Operator, handle all map requests
public Action Command_Operator(int args){
  char arg1[16];
  GetCmdArg(1, arg1, sizeof(arg1));
  int x = StringToInt(arg1);
    switch (x){
        //Red Win
        case 0:{
            PrintToChatAll("RED WON.");
            FireEntityInput("WinRed", "RoundWin", "", 0.0);
        }
        //Blu Win
        case 1:{
            PrintToChatAll("BLUE WON.");
        }
        //Round Start
        case 2:{
            PlayStartupSound();
            UnlockSetupGates();
            PrintToChatAll("ROUND START.");
        }
        //PL1 Deployed, spawn tank
        case 3:{
            FireEntityInput("PL1.Const", "Break", "", 0.0);
            FireEntityInput("PL1.CaptureArea", "Disable", "", 0.0);
            FireEntityInput("PL.RoundTimer", "AddTeamTime", "3 300", 0.0);
            FireEntityInput("PL1.CaptureArea", "CaptureCurrentCP", "", 0.0);
            FireEntityInput("PL1.CP", "SetOwner", "3", 0.0);
            FireEntityInput("PL1.Track16", "Kill", "", 0.0);
            FireEntityInput("PL.WatcherA", "SetTrainCanRecede", "0", 0.0);
            FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track17", 0.1);
            FireEntityInput("PL1.TrackTrain", "Stop", "", 0.1);
            FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL2.CP", 1.0);
            FireEntityInput("PL1.TankMaker", "ForceSpawn", "", 5.0);
            CreateTimer(1.0, TimedOperator, 0);
        }
        //PL2 (Tank) started push
        case 4:{
            isTankAlive = true;
            FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "69", 0.0);
            FireEntityInput("PL.WatcherA", "SetSpeedForwardModifier", "0.5", 0.0);
            CreateTimer(7.0, TankPingTimer);
        }
        //PL2 (Tank) Killed
        case 5:{
            if(tankDeploy){
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
        case 6:{
            if(isTankAlive){
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
        case 7:{
            isTankAlive = false;
            PrintToChatAll("TankDeployed!");
            FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
            FireEntityInput("PL1.CaptureArea", "Disable", "", 0.0);
            FireEntityInput("PL.RoundTimer", "AddTeamTime", "3 300", 0.0);
            FireEntityInput("PL2.CP", "SetOwner", "3", 0.0);
            FireEntityInput("PL1.CaptureArea", "CaptureCurrentCP", "3", 0.0);
            FireEntityInput("PL.WatcherA", "SetSpeedForwardModifier", "1", 0.0);
            FireEntityInput("PL1.TrackTrain", "AddOutput", "height 10", 0.0);
            FireEntityInput("PL1.TrackTrain", "TeleportToPathTrack", "PL1.Track41", 0.0);
            FireEntityInput("PL.WatcherA", "SetNumTrainCappers", "0", 0.0);
            FireEntityInput("PL1.CaptureArea", "SetControlPoint", "PL3.CP", 1.0);
            FireEntityInput("TankBossA", "Kill", "", 10.0);
            FireEntityInput("PL1.CaptureArea", "Enable", "", 10.0);
            FireEntityInput("PL3.PayloadSpawner", "ForceSpawn", "", 10.0);
        }
        //PL3 Spawned
        case 8:{
            FireEntityInput("PL3.Const", "TurnOn", "", 0.1);
        }
        //PL3 arrived at cannon
        case 9:{
            FireEntityInput("PL1.CaptureArea", "Disable", "", 0.0);
            FireEntityInput("PL.CannonLift", "Open", "", 0.0);
            FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
            FireEntityInput("PL1.CannonLift", "SetSpeed", "0.0", 0.10);
            FireEntityInput("PL1.CannonLift", "Close", "", 3.10);
            FireEntityInput("PL1.TrackTrain", "StartForward", "", 3.20);
            FireEntityInput("PL.WatcherA", "SetCanRecede", "0", 0.0);
        }
        //PL3 cannon loaded, aim and fire!
        case 10:{
            FireEntityInput("PL1.TrackTrain", "Stop", "", 0.0);
            FireEntityInput("PL3.Payload", "Kill", "", 0.0);
            FireEntityInput("PL.SentCart", "ForceSpawn", "", 0.0);
            FireEntityInput("PL.CannonLift", "SetSpeed", "40", 0.0);
            FireEntityInput("PL.CannonLift", "Open", "", 0.1);
            FireEntityInput("PL.CannonPitch", "SetPosition", "0.85", 5.0);
            FireEntityInput("PL.CannonYaw", "SetPosition", "0.85", 5.0);
            FireEntityInput("PL.CannonSND", "PlaySound", "", 10.0);
            FireEntityInput("PL.CannonFodder", "Enable", "", 10.0);
            FireEntityInput("PL.SentCartPhys", "SetDamageFilter", "NuBooliMe", 10.5);
            FireEntityInput("PL.CannonFodder", "Disable", "", 11.0);
            FireEntityInput("PL.CannonShake", "StartShake", "", 11.0);
            FireEntityInput("PL.CannonPitch", "SetPosition", "0.0", 20.0);
            FireEntityInput("PL.CannonYaw", "SetPosition", "0.0", 20.0);
        }
    }
    return Plugin_Handled;
}
//Timed operator, handle specific requests
public Action TimedOperator(Handle timer, int opCode){
    switch(opCode){
        case 0:{
            EmitSoundToAll(COUNTDOWN);
        }
        case 1:{
            int newHP = GetRandomInt(30000, 50000);
            IntToString(newHP, charHP, sizeof charHP);
            FireEntityInput("PL1.TankMaker", "ForceSpawn", "", 0.0);
            FireEntityInput("TankBossA", "SetHealth", charHP, 0.0);
        }
        case 2:{
            PrintToChatAll("ToggleAltPath!");
            FireEntityInput("PL1.Track40", "EnableAlternatePath", "", 0.0);
            FireEntityInput("PL1.Track40", "DisableAlternatePath", "", 10.0);
        }
    }
}
//Play a startup sound
void PlayStartupSound(){
    int i = GetRandomInt(1, 3);
    switch(i){
        case 1:{
            EmitSoundToAll("ambient/thunder2.wav");
        }
        case 2:{
            EmitSoundToAll("ambient/thunder3.wav");
        }
        case 3:{
            EmitSoundToAll("ambient/thunder4.wav");
        }
    }
}
//Unlock setup gates
void UnlockSetupGates(){
    PrintToChatAll("FIRE ENTITY INPUT SHOULD BE USED HERE.");
}
//Tank Checker
public Action TankPingTimer(Handle timer){
    int tank = FindEntityByClassname(-1, "tank_boss"); //check if tank is alive
    if (tank == -1) {
        isTankAlive = false;
        PrintToChatAll("Tank ded");
        return Plugin_Stop;
    } else {
        isTankAlive = true;
        int tankHP = GetEntProp(tank, Prop_Data, "m_iHealth");
        int tankMaxHP = GetEntProp(tank, Prop_Data, "m_iMaxHealth");
        if(tankHP > 500000){
            PrintToChatAll("BLUE TANK IS DEPLOYING ITS BOMB.");
            return Plugin_Stop;
        } else {
            PrintToChatAll("{blue}Blue Tank's HP: %i (%i)", tankHP, tankMaxHP);
            CreateTimer(1.0, TankPingTimer);        
        }
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
