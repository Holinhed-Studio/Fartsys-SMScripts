/*                         WELCOME TO FARTSY'S ASS ROTTENBURG.
 *
 *   A FEW THINGS TO KNOW: ONE.... THIS IS INTENDED TO BE USED WITH UBERUPGRADES.
 *   TWO..... THE MUSIC USED WITH THIS MOD MAY OR MAY NOT BE COPYRIGHTED. WE HAVE NO INTENTION ON INFRINGEMENT. THIS PROJECT IS PURELY NON PROFIT AND JUST FOR FUN. SHOULD COPYRIGHT HOLDERS WISH THIS PROJECT BE TAKEN DOWN, I (Fartsy) SHALL OBLIGE WITHOUT HESITATION.
 *   THREE..... THIS MOD IS INTENDED FOR USE ON THE FIREHOSTREDUX SERVERS ONLY. SUPPORT IS LIMITED.
 *   FOUR..... THIS WAS A NIGHTMARE TO FIGURE OUT AND BUG FIX. I HOPE IT WAS WORTH IT.
 *   FIVE..... PLEASE HAVE FUN AND ENJOY YOURSELF!
 *   SIX..... THE DURATION OF MUSIC TIMERS SHOULD BE SET DEPENDING WHAT SONG IS USED. SET THIS USING THE CONFIG FILES. SONG DUR IN SECONDS / 0.0151515151515 = REFIRE TIME.
 *   SEVEN..... TIPS AND TRICKS MAY BE ADDED TO THE TIMER, SEE PerformAdverts(Handle timer);
 *
 *                                       GL HF!!!
 */

#include <sourcemod>
#include <sdktools>
#include <clientprefs>
#include <morecolors>
#include <regex>
#include <tf2_stocks>
#include <fartsy/fastfire2>
#include <fartsy/ass_enhancer>
#include <fartsy/ass_helper>
#include <fartsy/ass_bosshandler>
#include <fartsy/ass_commands>
#include <fartsy/ass_events>
#include <fartsy/ass_sudo>

#pragma newdecls required
#pragma semicolon 1

public Database Get_Ass_Database(){
  return Ass_Database;
}

public Plugin myinfo = {
  name = "Fartsy's Ass - Framework",
  author = "Fartsy",
  description = "Framework for Fartsy's Ass (MvM Mods)",
  version = PLUGIN_VERSION,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart() {
  AssLogger(LOGLVL_INFO, "####### STARTUP SEQUENCE INITIATED... PREPARE FOR THE END TIMES #######");
  RegisterAndPrecacheAllFiles();
  RegisterAllCommands();
  SetupCoreData();
  UpdateAllHealers();
  CreateTimer(1.0, UpdateMedicHealing);
  CPrintToChatAll("{darkred}Plugin Reloaded. If you do not hear music, please do !sounds and configure your preferences.");
  cvarSNDDefault = CreateConVar("sm_fartsysass_sound", "3", "Default sound for new users, 3 = Everything, 2 = Sounds Only, 1 = Music Only, 0 = Nothing");
  SetCookieMenuItem(FartsysSNDSelected, 0, "Fartsys Ass Sound Preferences");
  AssLogger(LOGLVL_INFO, "####### STARTUP COMPLETE (v%s) #######", PLUGIN_VERSION);
}

//Begin executing IO when ready
public void OnFastFire2Ready(){
  AudioManager.Reset();
  WeatherManager.Reset();
  for (int i = 0; i < sizeof(MapLighting); i++) MapLighting[i].Repair();
  CreateTimer(1.0, SelectAdminTimer);
  sudo(1002);
}

//Process ticks and requests in real time
public void OnGameFrame() {
  float pos[3];
  float ang[3];
  float vel[3];
  float newPos[3];
  vel[0] = 0.0;
  vel[1] = 0.0;
  vel[2] = 0.0;
  if(tickOnslaughter){
    int BossEnt = FindEntityByTargetname("FB.BruteJusticeTrain", "func_tracktrain");
    int BossTP = FindEntityByTargetname("FB.OnslaughterBase", "base_boss");
    GetEntPropVector(BossEnt, Prop_Send, "m_vecOrigin", pos);
    GetEntPropVector(BossEnt, Prop_Data, "m_angRotation", ang);
    newPos[0] = pos[0];
    newPos[1] = pos[1];
    newPos[2] = pos[2] + 0.0;
    //PrintToChatAll("%f %f %f %f %f %f", pos[0], pos[1], pos[2], ang[0], ang[1], ang[2]);
    TeleportEntity(BossTP, newPos, ang, vel);
  }
  if (Enhancer_IsWave != core.isWave) Enhancer_IsWave = core.isWave;
  if(WeatherManager.TornadoWarning) WeatherManager.TickSiren();
  if (AudioManager.shouldTick) AudioManager.TickBGM();
  if (BossHandler.shouldTick) BossHandler.Tick();
  WeatherManager.TickFogDensity();
}