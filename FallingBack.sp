#include <sourcemod>
#include <sdktools>
#pragma newdecls required
#pragma semicolon 1
bool canHWBoss = false;
bool canTornado = false;
bool canSENTMeteors = false;
bool canSENTNukes = false;
bool canSENTStars = false;
bool isWave = false;
bool tornado = false;
bool bgmlock1 = true;
bool bgmlock2 = true;
bool bgmlock3 = true;
bool bgmlock4 = true;
bool bgmlock5 = true;
bool bgmlock6 = true;
bool bgmlock7 = true;
bool bgmlock8 = true;
char BELL[32] = "fartsy/misc/bell.wav";
char CLOCKTICK[32] = "fartsy/misc/clock_tick.wav";
char COUNTDOWN[32] = "fartsy/misc/countdown.wav";
char STRONGMAN[32] = "fartsy/misc/strongman_bell.wav";
char BGM1[64] = "fartsy/ffxiv/bgm/locus.mp3";
char BGM2[64] = "fartsy/ffxiv/bgm/metal.mp3";
char BGM3[64] = "fartsy/ffxiv/bgm/exponentialentropy.mp3";
char BGM4[64] = "fartsy/ffxiv/bgm/tornfromtheheavens.mp3";
char BGM5[64] = "fartsy/ffxiv/bgm/metalbrutejusticemode.mp3";
char BGM6[64] = "fartsy/ffxiv/bgm/grandmadestruction.mp3";
char BGM7[64] = "fartsy/ffxiv/bgm/revengetwofold.mp3";
char BGM8[64] = "fartsy/ffxiv/bgm/undertheweight.mp3";
int SNDCHAN = 6;
char BGM1Title[64] = "FFXIV - Locus";
char BGM2Title[64] = "FFXIV - Metal";
char BGM3Title[64] = "FFXIV - Exponential Entropy";
char BGM4Title[64] = "FFXIV - Torn From the Heavens";
char BGM5Title[64] = "FFXIV - Metal: Brute Justice Mode";
char BGM6Title[64] = "FFXIV - Grandma (Destruction)";
char BGM7Title[64] = "FFXIV - Revenge Twofold";
char BGM8Title[64] = "FFXIV - Under the Weight";
char DEFAULTBGM1[64] = "fartsy/ffxiv/bgm/TheSilentRegardOfStars.mp3";
char DEFAULTBGM2[64] = "fartsy/ffxiv/bgm/KnowledgeNeverSleeps.mp3";
char DEFAULTBGM1Title[64] = "FFXIV - The Silent Regard of Stars";
char DEFAULTBGM2Title[64] = "FFXIV - Knowledge Never Sleeps";
char curSong[64] = "null";
char FALLSND01[32] = "vo/l4d2/billfall02.mp3";
char FALLSND02[32] = "vo/l4d2/coachfall02.mp3";
char FALLSND03[32] = "vo/l4d2/ellisfall01.mp3";
char FALLSND04[32] = "vo/l4d2/francisfall02.mp3";
char FALLSND05[32] = "vo/l4d2/louisfall01.mp3";
char FALLSND06[32] = "vo/l4d2/louisfall03.mp3";
char FALLSND07[32] = "vo/l4d2/nickfall01.mp3";
char FALLSND08[32] = "vo/l4d2/zoeyfall01.mp3";
char FALLSND09[32] = "vo/ddd/woahhh.mp3";
char FALLSND0A[32] = "vo/jigglypuff/jigglypuff.mp3";
char FALLSND0B[32] = "vo/kirby/eeeahhhh.mp3";
char FALLSND0C[32] = "vo/luigi/ohohohohoo.mp3";
char FALLSND0D[32] = "vo/mario/wahahahaha.mp3";
char FALLSND0E[32] = "vo/pika/pikapika.mp3";
char FALLSND0F[32] = "vo/wario/wheee.mp3";
char FALLSND10[32] = "vo/mario/wowww.mp3";
char GLOBALTHUNDER01[32] = "fartsy/weather/thunder1.wav";
char GLOBALTHUNDER02[32] = "fartsy/weather/thunder2.wav";
char GLOBALTHUNDER03[32] = "fartsy/weather/thunder3.wav";
char GLOBALTHUNDER04[32] = "fartsy/weather/thunder4.wav";
char GLOBALTHUNDER05[32] = "fartsy/weather/thunder5.wav";
char GLOBALTHUNDER06[32] = "fartsy/weather/thunder6.wav";
char GLOBALTHUNDER07[32] = "fartsy/weather/thunder7.wav";
char GLOBALTHUNDER08[32] = "fartsy/weather/thunder8.wav";
char TRIGGERSCORE[32] = "fartsy/misc/triggerscore.wav";
int BGMSNDLVL = 90;
int DEFBGMSNDLVL = 40;
int bombStatus = 0;
int bombStatusMax = 0;
int bombsPushed = 0;
int bombCache = 0;
int sacPoints = 0;
int sacPointsMax = 60;
int explodeType = 0;
float HWNMin = 210.0;
float HWNMax = 380.0;
public Plugin myinfo =
{
	name = "Dovah's Ass - Framework",
	author = "Fartsy#0001",
	description = "Framework for Dovah's Ass",
	version = "2.4.0",
	url = "https://forums.firehostredux.com"
};

public void OnPluginStart()
{
	PrecacheSound(BELL, true),
	PrecacheSound(BGM1, true),
	PrecacheSound(BGM2, true),
	PrecacheSound(BGM3, true),
	PrecacheSound(BGM4, true),
	PrecacheSound(BGM5, true),
	PrecacheSound(BGM6, true),
	PrecacheSound(BGM7, true),
	PrecacheSound(BGM8, true),
	PrecacheSound(CLOCKTICK, true),
	PrecacheSound(COUNTDOWN, true),
	PrecacheSound(DEFAULTBGM1, true),
	PrecacheSound(DEFAULTBGM2, true),
	PrecacheSound(FALLSND01, true),
	PrecacheSound(FALLSND02, true),
	PrecacheSound(FALLSND03, true),
	PrecacheSound(FALLSND04, true),
	PrecacheSound(FALLSND05, true),
	PrecacheSound(FALLSND06, true),
	PrecacheSound(FALLSND07, true),
	PrecacheSound(FALLSND08, true),
	PrecacheSound(FALLSND09, true),
	PrecacheSound(FALLSND0A, true),
	PrecacheSound(FALLSND0B, true),
	PrecacheSound(FALLSND0C, true),
	PrecacheSound(FALLSND0D, true),
	PrecacheSound(FALLSND0E, true),
	PrecacheSound(FALLSND0F, true),
	PrecacheSound(FALLSND10, true),
	PrecacheSound(GLOBALTHUNDER01, true),
	PrecacheSound(GLOBALTHUNDER02, true),
	PrecacheSound(GLOBALTHUNDER03, true),
	PrecacheSound(GLOBALTHUNDER04, true),
	PrecacheSound(GLOBALTHUNDER05, true),
	PrecacheSound(GLOBALTHUNDER06, true),
	PrecacheSound(GLOBALTHUNDER07, true),
	PrecacheSound(GLOBALTHUNDER08, true),
	PrecacheSound(STRONGMAN, true),
	PrecacheSound(TRIGGERSCORE, true),
	RegServerCmd("fb_forcevictory", Command_ForceVictory, "FORCE victory - DO NOT TOUCH, WILL LIKELY MESS STUFF UP."),
	RegServerCmd("fb_trainincoming", Command_TrainIncoming, "A train is incoming!"),
	RegServerCmd("fb_atomicbmbrain", Command_AtomBmbRain, "Atom bombs are now raining from the sky!"),
	RegServerCmd("fb_ohnoes", Command_OhNoes, "Oh noes, prepare your anus!"),
	RegServerCmd("fb_meteorincoming", Command_MeteorIncoming, "Meteor incoming!"),
	RegServerCmd("fb_meteorshower", Command_MeteorShower, "Meteor Shower incoming!"),
	RegServerCmd("fb_prepareyourself", Command_DovahsAss, "You have chosen Dovah's Ass, prepare yourself..."),
	RegServerCmd("fb_wave1", Command_WaveOne, "Wave one started."),
	RegServerCmd("fb_wave2", Command_WaveTwo, "Wave two started."),
	RegServerCmd("fb_wave3", Command_WaveThree, "Wave three started."),
	RegServerCmd("fb_wave4", Command_WaveFour, "Wave four started."),
	RegServerCmd("fb_wave5", Command_WaveFive, "Wave five started."),
	RegServerCmd("fb_wave6", Command_WaveSix, "Wave six started."),
	RegServerCmd("fb_wave7", Command_WaveSeven, "Wave seven started."),
	RegServerCmd("fb_hydrogenup", Command_HydrogenUp, "Hydrogen available."),
	RegServerCmd("fb_wave8", Command_WaveEight, "Wave eight started."),
	RegServerCmd("fb_burgup", Command_WaveSevenBurgUp, "Wave seven - burg up!"),
	RegServerCmd("fb_foundgoob", Command_FoundGoob, "ALL HAIL GOOBBUE!"),
	RegServerCmd("fb_foundwaffle", Command_FoundWaffle, "Why do they call it the waffle of mass destruction if it does nothing!?"),
	RegServerCmd("fb_foundburrito", Command_FoundBurrito, "Forbidden Burrito. Yum."),
	RegServerCmd("fb_foundshroom", Command_FoundShroom, "What does this even do!?"),
	RegServerCmd("fb_foundball", Command_FoundBall, "Incoming blue ball..."),
	RegServerCmd("fb_tsplus1", Command_TSPlus1, "Tornado sacrifice -- plus one!"),
	RegServerCmd("fb_dpsacplus1", Command_DPSacPlus1, "Death pit sacrifice -- plus one!"),
	RegServerCmd("fb_ksacplus1", Command_KissoneSacPlus1, "KissoneTM sacrifice -- plus one!"),
	RegServerCmd("fb_tankdest", Command_TankDestPlus1, "Tank destroyed! Plus one!");
	RegServerCmd("fb_bresplus5", Command_BombResPlus5, "Bomb reset -- plus five!"),
	RegServerCmd("fb_sbathsalts", Command_BathSaltsSacMinus10, "Bath salts, minus ten!"),
	RegServerCmd("fb_sfatman", Command_FatManSacMinus20, "Fat man, minus twenty!"),
	RegServerCmd("fb_sgoobbue", Command_GoobbueSacMinus30, "Goobbue, minus thirty!"),
	RegServerCmd("fb_skirb", Command_BlueBallSacMinus30, "Blue ball, minus thirty!"),
	RegServerCmd("fb_sgboom", Command_GBoomSacMinus40, "Explosive paradise, minus fourty!"),
	RegServerCmd("fb_assgas", Command_AssGasMinus40, "Ass gas, minus fourty!"),
	RegServerCmd("fb_skirbward", Command_KirbyWardSacMinus50, "KIRBY HAS BANISHED TORNADOES!"),
	RegServerCmd("fb_snfo", Command_NFOSacMinus60, "Atomic bomb rain, minus sixty!"),
	RegServerCmd("fb_smeteors", Command_MeteorsSacMinus70, "Meteors, minus seventy!"),
	RegServerCmd("fb_sdovah", Command_DovahSacMinus100, "Professor Fartsalot, minus one hundred!"),
	RegServerCmd("fb_prevwave", Command_JumpToPrevWave, "Jump to previous wave."),
	RegServerCmd("fb_nextwave", Command_JumpToNextWave, "Jump to next wave."),
	RegServerCmd("dovahsass_finished", Command_DovahsAssFinished, "DovahsAss has been completed!"),
	RegServerCmd("fb_tacobell", Command_TacoBell, "Just why?"),
	RegServerCmd("tacobell_wave01", Command_TBWave01,"Taco Bell - Wave One"),
	RegServerCmd("tacobell_wave02", Command_TBWave02,"Taco Bell - Wave Two"),
	RegServerCmd("tacobell_wave03", Command_TBWave03,"Taco Bell - Wave Three"),
	RegServerCmd("tacobell_wave04", Command_TBWave04,"Taco Bell - Wave Four"),
	RegServerCmd("tacobell_wave05", Command_TBWave05,"Taco Bell - Wave Five"),
	RegServerCmd("tacobell_wave06", Command_TBWave06,"Taco Bell - Wave Six"),
	RegServerCmd("tacobell_wave07", Command_TBWave07,"Taco Bell - Wave Seven"),
	RegServerCmd("tacobell_wave08", Command_TBWave08,"Taco Bell - Wave Eight"),
	RegServerCmd("tacobell_wave09", Command_TBWave09,"Taco Bell - Wave Nine"),
	RegServerCmd("tacobell_wave10", Command_TBWave10,"Taco Bell - Wave Ten"),
	RegServerCmd("tacobell_wave11", Command_TBWave11,"Taco Bell - Wave Eleven"),
	RegServerCmd("tacobell_wave12", Command_TBWave12,"Taco Bell - Wave Twelve"),
	RegServerCmd("tacobell_wave13", Command_TBWave13,"Taco Bell - Wave Thirteen"),
	RegServerCmd("tacobell_wave14", Command_TBWave14,"Taco Bell - Wave Fourteen"),
	RegServerCmd("tacobell_wave15", Command_TBWave15,"Taco Bell - Wave Fifteen"),
	RegServerCmd("tacobell_wave16", Command_TBWave16,"Taco Bell - Wave Sixteen"),
	RegServerCmd("tacobell_wave17", Command_TBWave17,"Taco Bell - Wave Seventeen"),
	RegServerCmd("tacobell_wave18", Command_TBWave18,"Taco Bell - Wave Eighteen"),
	RegServerCmd("tacobell_wave19", Command_TBWave19,"Taco Bell - Wave Nineteen"),
	RegServerCmd("tacobell_wave20", Command_TBWave20,"Taco Bell - Wave Twenty"),
	RegServerCmd("tacobell_wave21", Command_TBWave21,"Taco Bell - Wave Twenty-One"),
	RegServerCmd("tacobell_finished", Command_TacoBellFinished, "TacoBell has been completed!"),
	RegConsoleCmd("sm_bombstatus", Command_FBBombStatus, "Check bomb status"),
	RegConsoleCmd("sm_sacstatus", Command_FBSacStatus, "Check sacrifice points status"),
	RegServerCmd("fb_forcetornado", Command_ForceTornado, "Force Tornado"),
	RegServerCmd("fb_deploy", Command_Deploy, "Deploy an active bomb - do not touch, will break something."),
	RegConsoleCmd("sm_song", Command_GetCurrentSong, "Get current song name"),
	HookEvent("player_death", EventDeath),
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre),
	HookEvent("mvm_wave_complete", EventWaveComplete),
	HookEvent("mvm_wave_failed", EventWaveFailed),
	HookEvent("mvm_bomb_alarm_triggered", EventWarning),
	HookEvent("mvm_bomb_reset_by_player", EventReset);
}

//Now that command definitions are done, lets make some things happen.
public void OnMapStart()
{
	FireEntityInput("BombStatus", "disable", "", 0.0),
	SelectBGM();
}

public Action SelectBGM()
{
	StopCurSong();
	int BGM = GetRandomInt(1, 2);
	switch(BGM){
		case 1:{
			EmitSoundToAll(DEFAULTBGM1, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
			curSong = DEFAULTBGM1;
			PrintToServer("Creating timer for The Silent Regard of Stars. Enjoy the music!");
			CreateTimer(137.75, RefireBGM);
		}
		case 2:{
			EmitSoundToAll(DEFAULTBGM2, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
			curSong = DEFAULTBGM2;
			PrintToServer("Creating timer for Knowledge Never Sleeps. Enjoy the music!");
			CreateTimer(235.5, RefireBGMAlt);
		}
	}
}

public Action StopCurSong(){
	for(int i=1;i<=MaxClients;i++)
    {
        StopSound(i, SNDCHAN, curSong);
    }
	return Plugin_Handled;
}

//Timers

//BGM (Defaults)
public Action RefireBGM(Handle timer)
{
	if (!isWave){
		SelectBGM();
		return Plugin_Stop;
	}
	return Plugin_Stop;
}
//BGM Default2
public Action RefireBGMAlt(Handle timer)
{
	if (!isWave){
		SelectBGM();
		return Plugin_Stop;
	}
	return Plugin_Stop;
}

//BGM (Locus)
public Action RefireLocus(Handle timer)
{
	if (!bgmlock1){
		StopCurSong();
		EmitSoundToAll(BGM1, _, SNDCHAN, DEFBGMSNDLVL, _, _, _, _, _, _, _, _);
		curSong = BGM1;
		CreateTimer(229.25, RefireLocus);
	}
	return Plugin_Stop;
}

//BGM (Metal)
public Action RefireMetal(Handle timer)
{
	if (!bgmlock2){
		StopCurSong();
		EmitSoundToAll(BGM2, _, SNDCHAN, DEFBGMSNDLVL, _, _, _, _, _, _, _, _);
		curSong = BGM2;
		CreateTimer(153.95, RefireMetal);
	}
	return Plugin_Stop;
}

//BGM (Exponential Entropy)
public Action RefireEntropy(Handle timer)
{
	if (!bgmlock3){
		StopCurSong();
		EmitSoundToAll(BGM3, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
		curSong = BGM3;
		CreateTimer(166.85, RefireEntropy);
	}
	return Plugin_Stop;
}

//BGM (Torn From the Heavens)
public Action RefireTorn(Handle timer)
{
	if (!bgmlock4){
		StopCurSong();
		EmitSoundToAll(BGM4, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
		curSong = BGM4;
		CreateTimer(122.25, RefireTorn);
	}
	return Plugin_Stop;
}

//BGM (Brute Justice Mode)
public Action RefireBJMode(Handle timer)
{
	if (!bgmlock5){
		StopCurSong();
		EmitSoundToAll(BGM5, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
		curSong = BGM5;
		CreateTimer(131.75, RefireBJMode);
	}
	return Plugin_Stop;
}

//BGM (Grandma Destruction)
public Action RefireGrandma(Handle timer)
{
	if (!bgmlock6){
		StopCurSong();
		EmitSoundToAll(BGM6, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
		curSong = BGM6;
		CreateTimer(323.95, RefireGrandma);
	}
	return Plugin_Stop;
}

//BGM (Revenge Twofold)
public Action RefireRevenge2F(Handle timer){
	if (!bgmlock7){
		StopCurSong();
		EmitSoundToAll(BGM7, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
		curSong = BGM7;
		CreateTimer(133.25, RefireRevenge2F);
	}
	return Plugin_Stop;
}

//BGM (Under The Weight)
public Action RefireUnderTW(Handle timer){
	if (!bgmlock8){
		StopCurSong();
		EmitSoundToAll(BGM8, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
		curSong = BGM8;
		CreateTimer(313.85, RefireUnderTW);
	}
	return Plugin_Stop;
}

//Storm
public Action RefireStorm(Handle timer){
	if (isWave){
		float f = GetRandomFloat(7.0, 17.0);
		CreateTimer(f, RefireStorm);
		StrikeLightning();
		int Thunder = GetRandomInt(1, 16);
		switch (Thunder){
			case 1:{
				EmitSoundToAll(GLOBALTHUNDER01);
				FireEntityInput("LightningHurt00", "Enable", "", 0.0),
				FireEntityInput("LightningHurt00",  "Disable", "", 0.07);
			}
			case 2:{
				EmitSoundToAll(GLOBALTHUNDER02);
				FireEntityInput("LightningHurt01", "Enable", "", 0.0),
				FireEntityInput("LightningHurt01",  "Disable", "", 0.07);
			}
			case 3:{
				EmitSoundToAll(GLOBALTHUNDER03);
				FireEntityInput("LightningHurt02", "Enable", "", 0.0),
				FireEntityInput("LightningHurt02",  "Disable", "", 0.07);
			}
			case 4:{
				EmitSoundToAll(GLOBALTHUNDER04);
				FireEntityInput("LightningHurt03", "Enable", "", 0.0),
				FireEntityInput("LightningHurt03",  "Disable", "", 0.07);
			}
			case 5:{
				EmitSoundToAll(GLOBALTHUNDER05);
				FireEntityInput("LightningHurt04", "Enable", "", 0.0),
				FireEntityInput("LightningHurt04",  "Disable", "", 0.07);
			}
			case 6:{
				EmitSoundToAll(GLOBALTHUNDER06);
				FireEntityInput("LightningHurt05", "Enable", "", 0.0),
				FireEntityInput("LightningHurt05",  "Disable", "", 0.07);
			}
			case 7:{
				EmitSoundToAll(GLOBALTHUNDER07);
				FireEntityInput("LightningHurt06", "Enable", "", 0.0),
				FireEntityInput("LightningHurt06",  "Disable", "", 0.07);
			}
			case 8:{
				EmitSoundToAll(GLOBALTHUNDER08);
				FireEntityInput("LightningHurt07", "Enable", "", 0.0),
				FireEntityInput("LightningHurt07",  "Disable", "", 0.07);
			}
			case 9:{
				EmitSoundToAll(GLOBALTHUNDER01);
				FireEntityInput("LightningHurt08", "Enable", "", 0.0),
				FireEntityInput("LightningHurt08",  "Disable", "", 0.07);
			}
			case 10:{
				EmitSoundToAll(GLOBALTHUNDER02);
				FireEntityInput("LightningHurt09", "Enable", "", 0.0),
				FireEntityInput("LightningHurt09",  "Disable", "", 0.07);
			}
			case 11:{
				EmitSoundToAll(GLOBALTHUNDER03);
				FireEntityInput("LightningHurt0A", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0A",  "Disable", "", 0.07);
			}
			case 12:{
				EmitSoundToAll(GLOBALTHUNDER04);
				FireEntityInput("LightningHurt0B", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0B",  "Disable", "", 0.07);
			}
			case 13:{
				EmitSoundToAll(GLOBALTHUNDER05);
				FireEntityInput("LightningHurt0C", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0C",  "Disable", "", 0.07);
			}
			case 14:{
				EmitSoundToAll(GLOBALTHUNDER06);
				FireEntityInput("LightningHurt0D", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0D",  "Disable", "", 0.07);
			}
			case 15:{
				EmitSoundToAll(GLOBALTHUNDER07);
				FireEntityInput("LightningHurt0E", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0E",  "Disable", "", 0.07);
			}
			case 16:{
				EmitSoundToAll(GLOBALTHUNDER08);
				FireEntityInput("LightningHurt0F", "Enable", "", 0.0),
				FireEntityInput("LightningHurt0F",  "Disable", "", 0.07);
			}
		}
	}
}

//Strike Lightning
public Action StrikeLightning(){
		FireEntityInput("lightning", "TurnOn", "", 0.0),
		FireEntityInput("weather", "Skin", "4", 0.0),
		FireEntityInput("value", "TurnOff", "", 0.0),
		FireEntityInput("LightningLaser", "TurnOn", "", 0.0),
		FireEntityInput("lightning", "TurnOff", "", 0.1),
		FireEntityInput("weather", "Skin", "3", 0.1),
		FireEntityInput("LightningLaser", "TurnOff", "", 0.1),
		FireEntityInput("lightning", "TurnOn", "", 0.17),
		FireEntityInput("weather", "Skin", "4", 0.17),
		FireEntityInput("LightningLaser", "TurnOn", "", 0.17),
		FireEntityInput("lightning", "TurnOff", "", 0.25),
		FireEntityInput("weather", "Skin", "3", 0.25),
		FireEntityInput("LightningLaser", "TurnOff", "", 0.25);
}

//Allow Tornadoes to Spawn
public Action ActivateTornadoTimer(){
	if (isWave && canTornado){
		float f = GetRandomFloat(210.0, 500.0);
		CreateTimer(f, SpawnTornado);
	}
	return Plugin_Stop;
}

//Spawn the tornado.
public Action SpawnTornado(Handle timer){
	if (isWave && canTornado && !tornado){
		FireEntityInput("TornadoKill", "Enable", "", 0.0),
		FireEntityInput("tornadobutton", "Lock", "", 0.0),
		FireEntityInput("tornadof1", "start", "", 20.0),
		FireEntityInput("shaketriggerf1", "Enable", "", 20.0),
		FireEntityInput("tornadowindf1", "PlaySound", "", 20.0),
		FireEntityInput("tornadof1wind", "Enable", "", 21.50);
		tornado = true;
		float f = GetRandomFloat(60.0, 120.0);
		CreateTimer(f, DespawnTornado);
	}
	return Plugin_Stop;
}

//After a predetermined time, despawn the tornado.
public Action DespawnTornado(Handle timer){
	KillTornado();
	ActivateTornadoTimer();
}

//Despawns the tornado.
public Action KillTornado(){
	if (tornado){
		FireEntityInput("tornadof1", "stop", "", 0.0),
		FireEntityInput("TornadoKill", "Disable", "", 0.0),
		FireEntityInput("tornadof1wind", "Disable", "", 0.0),
		FireEntityInput("tornadowindf1", "StopSound", "", 0.0),
		FireEntityInput("shaketriggerf1", "Disable", "", 0.0),
		FireEntityInput("tornadobutton", "Unlock", "", 20.0);
		tornado = false;
	}
	return Plugin_Stop;
}

//FB UnlockTimer (Unlocks FC Code Entry
public Action UnlockTimer (Handle timer){
	if(isWave){
		FireEntityInput("FB.KP*", "Unlock", "", 0.0);
		EmitSoundToAll(BELL);
	}
	return Plugin_Stop;
}

//SpecTimer
public Action SpecTimer(Handle timer){
	int i = GetRandomInt(1, 6);
	switch (i){
		case 1:{
			FireEntityInput("Spec.*", "Disable", "", 0.0),
			FireEntityInput("Spec.Goobbue", "Enable", "", 0.1),
			PrintToChatAll("\x070000AA Legend tells of a Goobbue sproutling somewhere nearby...");
		}
		case 2:{
			FireEntityInput("Spec.*", "Disable", "", 0.0),
			FireEntityInput("Spec.Waffle", "Enable", "", 0.1),
			PrintToChatAll("\x0700A0A0Don't eat THESE...");
		}
		case 3:{
			FireEntityInput("Spec.*", "Disable", "", 0.0),
			FireEntityInput("Spec.Burrito", "Enable", "", 0.1),
			PrintToChatAll("\x07A00000What's worse than Taco Bell?");
		}
		case 4:{
			FireEntityInput("Spec.*", "Disable", "", 0.0),
			FireEntityInput("Spec.Shroom", "Enable", "", 0.1),
			PrintToChatAll("\x07DD0000M\x07FFFFFFA\x07DD0000R\x07FFFFFFI\x07DD0000O\x07FFFFFF time!");
		}
		case 5:{
			FireEntityInput("Spec.*", "Disable", "", 0.0),
			FireEntityInput("Spec.BlueBall", "Enable", "", 0.1),
			PrintToChatAll("A \x070000AABlue Ball \x07FFFFFFlurks from afar...");
		}
		case 6:{
			FireEntityInput("Spec.*", "Enable", "", 0.0),
			PrintToChatAll("\x07AA00AAIs it a miracle? Is it  chaos? WHO KNOWWWWWWS");
		}
	}
	float spDelay = GetRandomFloat(10.0, 30.0);
	CreateTimer(spDelay, SpecTimer);
	return Plugin_Stop;
}

//SENTMeteor (Scripted Entity Meteors)
public Action SENTMeteorTimer(Handle timer){
	if(canSENTMeteors){
		int i = GetRandomInt(1, 8);
		switch(i){
			case 1:{
				FireEntityInput("FB.SentMeteor01", "ForceSpawn", "", 0.0);
			}
			case 2:{
				FireEntityInput("FB.SentMeteor02", "ForceSpawn", "", 0.0);
			}
			case 3:{
				FireEntityInput("FB.SentMeteor03", "ForceSpawn", "", 0.0);
			}
			case 4:{
				FireEntityInput("FB.SentMeteor04", "ForceSpawn", "", 0.0);
			}
			case 5:{
				FireEntityInput("FB.SentMeteor05", "ForceSpawn", "", 0.0);
			}
			case 6:{
				FireEntityInput("FB.SentMeteor06", "ForceSpawn", "", 0.0);
			}
			case 7:{
				FireEntityInput("FB.SentMeteor07", "ForceSpawn", "", 0.0);
			}
			case 8:{
				FireEntityInput("FB.SentMeteor08", "ForceSpawn", "", 0.0);
			}
		}
	}
	return Plugin_Stop;
}

public Action DisableSENTMeteors(Handle timer){
	canSENTMeteors = false;
	return Plugin_Stop;
}

//SENTNukes (Scripted Entity Nukes)
public Action SENTNukeTimer(Handle timer){
	if(canSENTNukes){
		FireEntityInput("FB.DropNuke", "PlaySound", "", 0.0);
		int i = GetRandomInt(1, 8);
		switch(i){
			case 1:{
				FireEntityInput("FB.SentNuke01", "ForceSpawn", "", 0.0);
			}
			case 2:{
				FireEntityInput("FB.SentNuke02", "ForceSpawn", "", 0.0);
			}
			case 3:{
				FireEntityInput("FB.SentNuke03", "ForceSpawn", "", 0.0);
			}
			case 4:{
				FireEntityInput("FB.SentNuke04", "ForceSpawn", "", 0.0);
			}
			case 5:{
				FireEntityInput("FB.SentNuke05", "ForceSpawn", "", 0.0);
			}
			case 6:{
				FireEntityInput("FB.SentNuke06", "ForceSpawn", "", 0.0);
			}
			case 7:{
				FireEntityInput("FB.SentNuke07", "ForceSpawn", "", 0.0);
			}
			case 8:{
				FireEntityInput("FB.SentNuke08", "ForceSpawn", "", 0.0);
			}
		}
		float f = GetRandomFloat(1.5, 3.0);
		CreateTimer(f, SENTNukeTimer);
	}
	return Plugin_Stop;
}

public Action DisableSENTNukes(Handle timer){
	canSENTNukes = false;
	return Plugin_Stop;
}

//SENTStars (Scripted Entity Stars)
public Action SENTStarTimer(Handle timer){
	if(canSENTStars){
		int i = GetRandomInt(1, 8);
		switch(i){
			case 1:{
				FireEntityInput("FB.SentStar01", "ForceSpawn", "", 0.0);
			}
			case 2:{
				FireEntityInput("FB.SentStar02", "ForceSpawn", "", 0.0);
			}
			case 3:{
				FireEntityInput("FB.SentStar03", "ForceSpawn", "", 0.0);
			}
			case 4:{
				FireEntityInput("FB.SentStar04", "ForceSpawn", "", 0.0);
			}
			case 5:{
				FireEntityInput("FB.SentStar05", "ForceSpawn", "", 0.0);
			}
			case 6:{
				FireEntityInput("FB.SentStar06", "ForceSpawn", "", 0.0);
			}
			case 7:{
				FireEntityInput("FB.SentStar07", "ForceSpawn", "", 0.0);
			}
			case 8:{
				FireEntityInput("FB.SentStar08", "ForceSpawn", "", 0.0);
			}
		}
		float f = GetRandomFloat(0.75, 1.5);
		CreateTimer(f, SENTStarTimer);
	}
}
public Action SENTStarDisable(Handle timer){
	canSENTStars = false;
	return Plugin_Handled;
}

//TankHornSND because why not when code entry fails???
public Action FBCodeFailTankHornSND(Handle timer){
	EmitSoundToAll("mvm/mvm_tank_horn.wav");
	return Plugin_Stop;
}

//Halloween Bosses
public Action HWBosses(Handle timer){
	if(isWave && canHWBoss){
		int i = GetRandomInt(1, 10);
		switch(i){
			case 1:{
				FireEntityInput("hhh_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 2:{
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 3:{
				
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0),
				FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
				FireEntityInput("SkeleSpawner", "Disable", "", 10.0);
			}
			case 4:{
				FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
				FireEntityInput("SkeleSpawner", "Disable", "", 10.0);
			}
			case 5:{
				FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 6:{
				FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 7:{
				FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0);
			}
			case 8:{
				FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
				FireEntityInput("SkeleSpawner", "Disable", "", 30.0);
			}
			case 9:{
				FireEntityInput("SkeleSpawner", "Enable", "", 0.0),
				FireEntityInput("SkeleSpawner", "Disable", "", 60.0),
				FireEntityInput("merasmus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0),
				FireEntityInput("hhh_maker2", "ForceSpawn", "", 0.0);
			}
			case 10:{
				FireEntityInput("monoculus_maker", "ForceSpawn", "", 0.0);
			}
		}
		canHWBoss = false;
		CreateTimer(60.0, HWBossesRefire);
	}
	return Plugin_Stop;
}

public Action HWBossesRefire(Handle timer){
	if (isWave){
		float hwn = GetRandomFloat(HWNMin, HWNMax);
		CreateTimer(hwn, HWBosses);
	}
	return Plugin_Stop;
}
//SacPoints (Add points to Sacrifice Points occasionally)
public Action SacrificePointsTimer(Handle timer){
	if (isWave && (sacPoints < sacPointsMax)){
		sacPoints++;
		float f = GetRandomFloat(5.0, 30.0);
		CreateTimer(f, SacrificePointsTimer);
	}
	return Plugin_Stop;
}
//BombStatus (Add points to Bomb Status occasionally)
public Action BombStatusAddTimer(Handle timer){
	if (isWave && (bombStatus < bombStatusMax)){
		bombStatus++;
		float f = GetRandomFloat(10.0, 45.0);
		PrintToServer("[DEBUG] Creating a %f timer to give bomb status an update. Current target is %i", f, bombStatus);
		CreateTimer(f, BombStatusAddTimer);
		//Loop back from the start with Freedom Bomb. This time, enable special stuff.
		if (bombsPushed >= 7){
			bombsPushed = 0;
			bombCache = 0;
			bombStatus = 0;
			explodeType = 0;
			CreateTimer(3.0, BombStatusAddTimer);
			float spDelay = GetRandomFloat(10.0, 30.0);
			CreateTimer(spDelay, SpecTimer);
		}
	}
	return Plugin_Stop;
}

//Track bombStatus and update entities every 0.1 seconds
public Action BombStatusUpdater(Handle timer){
	if (isWave){
		CreateTimer(0.1, BombStatusUpdater);
		switch (bombStatus){
			case 8:{
				bombStatusMax = 8;
				bombCache = 0;
				explodeType = 1;
				FireEntityInput("Bombs.*", "Disable", "", 0.0),
				FireEntityInput("BombExplo*", "Disable", "", 0.0),
				FireEntityInput("Delivery", "Unlock", "", 0.0),
				FireEntityInput("Bombs.FreedomBomb", "Enable", "", 0.0),
				EmitSoundToAll(TRIGGERSCORE),
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000FREEDOM BOMB \x0700AA55is now available for deployment!");
			}
			case 16:{
				bombStatusMax = 16;
				bombCache = 0;
				explodeType = 2;
				FireEntityInput("Bombs.*", "Disable", "", 0.0),
				FireEntityInput("BombExplo*", "Disable", "", 0.0),
				FireEntityInput("Bombs.ElonBust", "Enable", "", 0.0),
				FireEntityInput("Delivery", "Unlock", "", 0.0),
				EmitSoundToAll(TRIGGERSCORE),
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000ELON BUST \x0700AA55is now available for deployment!");
			}
			case 24:{
				bombStatusMax = 24;
				bombCache = 0;
				explodeType = 2;
				FireEntityInput("Bombs.*", "Disable", "", 0.0),
				FireEntityInput("BombExplo*", "Disable", "", 0.0),
				FireEntityInput("Bombs.BathSalts", "Enable", "", 0.0),
				FireEntityInput("Delivery", "Unlock", "", 0.0),
				EmitSoundToAll(TRIGGERSCORE),
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000BATH SALTS \x0700AA55are now available for deployment!");
			}
			case 32:{
				bombStatusMax = 32;
				bombCache = 0;
				explodeType = 3;
				FireEntityInput("Bombs.*", "Disable", "", 0.0),
				FireEntityInput("BombExplo*", "Disable", "", 0.0),
				FireEntityInput("Bombs.FallingStar", "Enable", "", 0.0),
				FireEntityInput("Delivery", "Unlock", "", 0.0),
				EmitSoundToAll(TRIGGERSCORE),
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FFFF00FALLING STAR\x0700AA55 is now available for deployment!");
			}
			case 40:{
				bombStatusMax = 40;
				bombCache = 0;
				explodeType = 4;
				FireEntityInput("Bombs.*", "Disable", "", 0.0),
				FireEntityInput("BombExplo*", "Disable", "", 0.0),
				FireEntityInput("Bombs.MajorKong", "Enable", "", 0.0),
				FireEntityInput("Delivery", "Unlock", "", 0.0),
				EmitSoundToAll(TRIGGERSCORE),
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000MAJOR KONG \x0700AA55is now available for deployment!");
			}
			case 48:{
				bombStatusMax = 48;
				bombCache = 0;
				explodeType = 5;
				FireEntityInput("Bombs.*", "Disable", "", 0.0),
				FireEntityInput("BombExplo*", "Disable", "", 0.0),
				FireEntityInput("Bombs.SharkTorpedo", "Enable", "", 0.0),
				FireEntityInput("BombExploShark", "Enable", "", 0.0),
				FireEntityInput("Delivery", "Unlock", "", 0.0),
				EmitSoundToAll(TRIGGERSCORE),
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000SHARK \x0700AA55is now available for deployment!");
			}
			case 56:{
				bombStatusMax = 56;
				bombCache = 0;
				explodeType = 6;
				FireEntityInput("Bombs.*", "Disable", "", 0.0),
				FireEntityInput("BombExplo*", "Disable", "", 0.0),
				FireEntityInput("Bombs.FatMan", "Enable", "", 0.0),
				FireEntityInput("Delivery", "Unlock", "", 0.0),
				EmitSoundToAll(TRIGGERSCORE),
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000FAT MAN \x0700AA55is now available for deployment!");
			}
		}
	}
	return Plugin_Stop;
}

//Track SacPoints and update entities every 0.1 seconds
public Action SacrificePointsUpdater(Handle timer){
	if (isWave){
		CreateTimer(0.1, SacrificePointsUpdater);
		if (sacPoints > sacPointsMax){
			sacPoints = sacPointsMax;
		}
		switch (sacPoints){
			case 0,1,2,3,4,5,6,7,8,9:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
			}
			case 10,11,12,13,14,15,16,17,18,19:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0);
			}
			case 20,21,22,23,24,25,26,27,28,29:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0);
			}
			case 30,31,32,33,34,35,36,37,383,39:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0 255 0", 0.0);
			}
			case 40,41,42,43,44,45,46,47,48,49:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Color", "0 255 0", 0.0);
			}
			case 50,51,52,53,54,55,56,57,58,59:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Color", "0 255 0", 0.0);
			}
			case 60,61,62,63,64,65,66,67,68,69:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Color", "0 255 0", 0.0);
			}
			case 70,71,72,73,74,75,76,77,78,79:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Color", "0 255 0", 0.0);
			}
			case 100:{
				FireEntityInput("BTN.Sacrificial*", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial0*", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial0*", "Color", "0 255 0", 0.0);
			}
		}
	}
	return Plugin_Stop;
}

//RobotLaunchTimer (Randomly fling robots)
public Action RobotLaunchTimer(Handle timer){
	if (isWave){
		FireEntityInput("FB.RobotLauncher", "Enable", "", 0.0),
		FireEntityInput("FB.RobotLauncher", "Disable", "", 7.5);
		float f = GetRandomFloat(5.0, 30.0);
		CreateTimer(f, RobotLaunchTimer);
	}
	return Plugin_Stop;
}

//Command action definitions
//Get current song
public Action Command_GetCurrentSong(int client, int args){
	if(StrEqual(curSong, BGM1))
	{
		PrintToChat(client, "The current song is: %s", BGM1Title);
	}
	else if(StrEqual(curSong, BGM2)){
		PrintToChat(client, "The current song is: %s", BGM2Title);
	}
	else if(StrEqual(curSong, BGM3)){
		PrintToChat(client, "The current song is: %s", BGM3Title);
	}
	else if(StrEqual(curSong, BGM4)){
		PrintToChat(client, "The current song is: %s", BGM4Title);
	}
	else if(StrEqual(curSong, BGM5)){
		PrintToChat(client, "The current song is: %s", BGM5Title);
	}
	else if(StrEqual(curSong, BGM6)){
		PrintToChat(client, "The current song is: %s", BGM6Title);
	}
	else if(StrEqual(curSong, BGM7)){
		PrintToChat(client, "The current song is: %s", BGM7Title);
	}
	else if(StrEqual(curSong, BGM8)){
		PrintToChat(client, "The current song is: %s", BGM8Title);
	}
	else if(StrEqual(curSong, DEFAULTBGM1)){
		PrintToChat(client, "The current song is: %s", DEFAULTBGM1Title);
	}
	else if(StrEqual(curSong, DEFAULTBGM2)){
		PrintToChat(client, "The current song is: %s", DEFAULTBGM2Title);
	}
	return Plugin_Handled;
}

//Deploy a bomb for RED
public Action Command_Deploy(int args){
	if(explodeType == 0){
		PrintToServer("Tried to detonate with a bomb size of zero!");
	}
	//Small Explosion
	else if (explodeType == 1){
		FireEntityInput("Murica", "PlaySound", "", 0.0),
		FireEntityInput("SmallExplosion", "Explode", "", 0.0),
		FireEntityInput("SmallExploShake", "StartShake", "", 0.0),
		BombPushed(5),
		EmitSoundToAll(COUNTDOWN);
	}
	//Medium Explosion
	else if (explodeType == 2){
		FireEntityInput("MedExplosionSND", "PlaySound", "", 0.0),
		FireEntityInput("MediumExplosion", "Explode", "", 0.0),
		FireEntityInput("MedExploShake", "StartShake", "", 0.0),
		BombPushed(5);
		EmitSoundToAll(COUNTDOWN);
	}
	//Falling Star
	else if (explodeType == 3){
		FireEntityInput("MedExplosionSND", "PlaySound", "", 0.0),
		FireEntityInput("MediumExplosion", "Explode", "", 0.0),
		FireEntityInput("MedExploShake", "StartShake", "", 0.0),
		BombPushed(10),
		EmitSoundToAll(COUNTDOWN);
		CreateTimer(1.0, SENTStarTimer);
		CreateTimer(60.0, SENTStarDisable);
	}
	//Major Kong
	else if (explodeType == 4){
		FireEntityInput("MajorKongSND", "PlaySound", "", 0.0),
		FireEntityInput("FB.Fade", "Fade", "", 1.7),
		FireEntityInput("LargeExplosion", "Explode", "", 1.7),
		FireEntityInput("LargeExplosionSound", "PlaySound", "", 1.7),
		FireEntityInput("LargeExploShake", "StartShake", "", 1.7),
		FireEntityInput("NukeAll", "Enable", "", 1.7),
		FireEntityInput("NukeAll", "Disable", "", 3.0),
		BombPushed(25),
		EmitSoundToAll(COUNTDOWN);
	}
	//large (shark)
	else if (explodeType == 5){
		FireEntityInput("LargeExploSound", "PlaySound", "", 0.0),
		FireEntityInput("LargeExplosion", "Explode", "", 0.0),
		FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
		BombPushed(15),
		EmitSoundToAll(COUNTDOWN);
	}
	//FatMan
	else if (explodeType == 6){
		FireEntityInput("HindenburgBoom", "PlaySound", "", 0.0),
		FireEntityInput("LargeExplosion", "Explode", "", 0.0),
		FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
		FireEntityInput("", "PlaySound", "", 0.0),
		FireEntityInput("NukeAll", "Enable", "", 0.0),
		FireEntityInput("FB.Fade", "Fade", "", 0.0),
		FireEntityInput("NukeAll", "Disable", "", 3.0),
		BombPushed(25),
		EmitSoundToAll(COUNTDOWN);
	}
}

public Action BombPushed(int arg1){
	switch (arg1){
		case 5:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Small Bomb successfully pushed! (\x0700FF00+5 pts\x07FFFFFF)");
			sacPoints+=5,
			bombStatusMax+=8,
			bombStatus+=2,
			bombsPushed++,
			bombCache = 1,
			CreateTimer(3.0, BombStatusAddTimer);
		}
		case 10:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Average Bomb successfully pushed! (\x0700FF00+10 pts\x07FFFFFF)");
			sacPoints+=10,
			bombStatusMax+=8,
			bombStatus+=2,
			bombsPushed++,
			bombCache = 1,
			CreateTimer(3.0, BombStatusAddTimer);
		}
		case 15:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Heavy Bomb successfully pushed! (\x0700FF00+15 pts\x07FFFFFF)");
			sacPoints+=15,
			bombStatusMax+=8,
			bombStatus+=4,
			bombsPushed++,
			bombCache = 1,
			CreateTimer(3.0, BombStatusAddTimer);
		}
		case 25:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07AA NUCLEAR WARHEAD\x07FFFFFF successfully pushed! (\x0700FF00+25 pts\x07FFFFFF)");
			sacPoints+=25,
			bombStatusMax+=8,
			bombStatus+=4,
			bombsPushed++,
			bombCache = 1,
			CreateTimer(3.0, BombStatusAddTimer);
		}
	}
	return Plugin_Handled;
}

//Force Tornado
public Action Command_ForceTornado(int args){
	if(isWave && canTornado && !tornado){
		CreateTimer(0.1, SpawnTornado);
		PrintCenterTextAll("OH NOES... PREPARE YOUR ANUS!");
	}
	else{
		PrintToServer("Error spawning manual tornado... Perhaps we are not in a wave, tornadoes are banished, or a tornado has already spawned???");
	}
	return Plugin_Handled;
}

//Determine which bomb has been recently pushed and tell the client if a bomb is ready or not.
public Action Command_FBBombStatus(int client, int args){
	PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55The bomb status is currently %i", bombStatus);
	//No bombs have yet been deployed nor have they been unlocked.
	if (bombStatus <= 7){
		PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Bombs are \x07FF0000NOT READY\x07FFFFFF!");
	}
	//Only execute if Freedom Bomb is available.
	else if (bombStatus >= 8 && bombStatus < 16){
		//If no bombs are pushed and next bomb IS ready.
		if (bombsPushed == 0 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000FREEDOM BOMB \x0700AA55is available for deployment!");
		}
		//If the wave forces us to have a bomb pushed and 0 queue
		else if(bombsPushed == 1 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55The wave has just begun or has been reset. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and next bomb is NOT ready.
		else if(bombsPushed == 1 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Please wait for the next bomb.");
		}
		return Plugin_Continue;
	}
	//Only execute if Elon Bust is available.
	else if(bombStatus >= 16 && bombStatus < 24){
		//If we've pushed the Freedom Bomb and next bomb IS ready.
		if (bombsPushed == 1 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Your team's \x07FF0000ELON BUST \x0700AA55is available for deployment!");
		}
		//If the wave forces us to have 2 bombs pushed and 0 queue
		else if(bombsPushed == 2 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55The wave has just begun or has been reset. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and the Elon Bust and next bomb is NOT ready.
		else if(bombsPushed == 2 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFELON BUST \x0700AA55. Please wait for the next bomb.");
		}
		return Plugin_Continue;
	}
	//Only execute if Bath Salts are available.
	else if(bombStatus >= 24 && bombStatus < 32){
		//If we've pushed the Freedom Bomb and the Elon Bust and the next bomb IS ready.
		if (bombsPushed == 2 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFELON BUST \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If the wave forces us to have 3 bombs pushed and 0 queue
		else if(bombsPushed == 3 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55The wave has just begun or has been reset. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts and the next bomb is NOT ready.
		else if (bombsPushed == 3 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Please wait for the next bomb.");
		}
		return Plugin_Continue;
	}
	//Only execute if Falling Star is available.
	else if (bombStatus >= 32 && bombStatus < 40){
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts, and the next bomb IS ready.
		if (bombsPushed == 3 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Your team's \x07FF0000FALLING STAR \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS NOT ready.
		else if (bombsPushed == 4 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFALLING STAR \x0700AA55. Please wait for the next bomb.");
		}
		return Plugin_Continue;
	}
	//Only execute if Major Kong is available.
	else if (bombStatus >= 40 && bombStatus < 48){
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS ready.
		if (bombsPushed == 4 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFFALLING STAR \x0700AA55. Your team's \x07FF0000MAJOR KONG \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, and Major Kong and the next bomb is NOT ready.
		else if (bombsPushed == 5 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFMAJOR KONG \x0700AA55. Please wait for the next bomb.");
		}
	}
	//Only execute if Shark is available.
	else if (bombStatus >= 48 && bombStatus < 56){
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, and Major Kong and the next bomb IS ready.
		if (bombsPushed == 5 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFMAJOR KONG \x0700AA55. Your team's \x07FF0000SHARK \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, Major Kong, and Shark and the next bomb IS NOT ready.
		else if (bombsPushed == 6 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFSHARK \x0700AA55. Please wait for the next bomb.");
		}
	}
	//Only execute if Fat Man is available.
	else if (bombStatus >= 56 && bombStatus < 64){
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, Major Kong, and Shark and the next bomb IS ready.
		if (bombsPushed == 6 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFSHARK \x0700AA55. Your team's \x07FF0000FAT MAN \x0700AA55is available for deployment!");
		}
		else if (bombsPushed == 7 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFAT MAN \x0700AA55. Bombs are automatically reset to preserve the replayable aspect of this game mode.");
		}
	}
	//Only execute if I add another bomb or system for this...
	else if (bombStatus >= 64 && bombStatus < 72){
		PrintToChatAll("wowie you exceeded the legal value of this script!");
	}
	return Plugin_Handled;
}

//Tell the client the current sacrifice points earned.
public Action Command_FBSacStatus(int client, int args){
	PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55The sacrificial points counter is currently at %i of %i maximum for this wave.", sacPoints, sacPointsMax);
}

//Force a victory, used by some entities in the map for quickly creating mass amounts of chaos.
public Action Command_ForceVictory(int args)
{
	int flags = GetCommandFlags("tf_mvm_force_victory");
	SetCommandFlags("tf_mvm_force_victory", flags & ~FCVAR_CHEAT);
	ServerCommand("tf_mvm_force_victory 1");
	FakeClientCommand(0, ""); //Not sure why, but this has to be here. Otherwise the specified commands simply refuse to work...
	SetCommandFlags("tf_mvm_force_victory", flags|FCVAR_CHEAT);
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF VICTORY HAS BEEN FORCED! THE SERVER WILL RESTART IN 10 SECONDS.");
	CreateTimer(10.0, Timer_RestartServer);
}

public Action Command_TrainIncoming(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07AA7000KISSONE'S TRAIN\x07FFFFFF is \x07AA0000INCOMING\x07FFFFFF. Look out!");
}

public Action Command_AtomBmbRain(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, it's begun to rain \x07AA0000ATOM BOMBS\x07FFFFFF! TAKE COVER!");
}

public Action Command_OhNoes(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFOh noes, prepare your anus! A \x07AA0000TORNADO WARNING\x07FFFFFF has been issued! TAKE COVER NOW!!!");
}

public Action Command_MeteorIncoming(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, a \x07AA0000METEOR\x07FFFFFF has been spotted coming towards Dovah's Ass!!!");
}

public Action Command_MeteorShower(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, a \x07AA0000METEOR SHOWER\x07FFFFFF has been reported from Dovah's Ass!!!");
}

public Action Command_DovahsAss(int args)
{
	PrintToChatAll("\x070000AA[\x07AAAA00INFO\x070000AA] \x07AA0000DOVAH'S ASS\x07FFFFFF v0x13. Prepare yourself for the unpredictable... [\x0700FF00by TTV/ProfessorFartsalot\x07FFFFFF]");
}
//Wave One
public Action Command_WaveOne(int args)
{
	bgmlock1 = false;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	canHWBoss = true;
	canTornado = true;
	isWave = true;
	bombStatus = 0;
	bombsPushed = 0;
	bombStatusMax = 8;
	sacPointsMax = 90;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 1: Locus");
	StopCurSong();
	EmitSoundToAll(BGM1, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
	curSong = BGM1;
	CreateTimer(229.25, RefireLocus);
	CreateTimer(1.0, BombStatusAddTimer);
	CreateTimer(0.1, BombStatusUpdater);
	CreateTimer(1.0, RobotLaunchTimer);
	CreateTimer(1.0, SacrificePointsTimer);
	CreateTimer(1.0, SacrificePointsUpdater);
	CreateTimer(1.0, RefireStorm);
	ActivateTornadoTimer();
	float hwn = GetRandomFloat(HWNMin, HWNMax);
	CreateTimer(hwn, HWBosses);
}
//Wave Two
public Action Command_WaveTwo(int args)
{
	bgmlock1 = true;
	bgmlock2 = false;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	canHWBoss = true;
	canTornado = true;
	isWave = true;
	bombStatus = 4;
	bombsPushed = 0;
	bombStatusMax = 16;
	sacPointsMax = 90;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 2: Metal");
	StopCurSong();
	EmitSoundToAll(BGM2, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
	curSong = BGM2;
	CreateTimer(153.95, RefireMetal);
	CreateTimer(1.0, BombStatusAddTimer);
	CreateTimer(0.1, BombStatusUpdater);
	CreateTimer(1.0, RobotLaunchTimer);
	CreateTimer(1.0, SacrificePointsTimer);
	CreateTimer(1.0, SacrificePointsUpdater);
	CreateTimer(1.0, RefireStorm);
	ActivateTornadoTimer();
	float hwn = GetRandomFloat(HWNMin, HWNMax);
	CreateTimer(hwn, HWBosses);
}
//Wave Three
public Action Command_WaveThree(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = false;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	canHWBoss = true;
	canTornado = true;
	HWNMax = 360.0;
	isWave = true;
	bombStatus = 7;
	bombsPushed = 0;
	bombStatusMax = 24;
	sacPointsMax = 90;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 3: Exponential Entropy");
	StopCurSong();
	EmitSoundToAll(BGM3, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
	curSong = BGM3;
	CreateTimer(166.85, RefireEntropy);
	CreateTimer(1.0, BombStatusAddTimer);
	CreateTimer(0.1, BombStatusUpdater);
	CreateTimer(1.0, RobotLaunchTimer);
	CreateTimer(1.0, SacrificePointsTimer);
	CreateTimer(1.0, SacrificePointsUpdater);
	CreateTimer(1.0, RefireStorm);
	ActivateTornadoTimer();
	float f = GetRandomFloat(60.0, 180.0);
	CreateTimer(f, UnlockTimer);
	float hwn = GetRandomFloat(HWNMin, HWNMax);
	CreateTimer(hwn, HWBosses);
}
//Wave Four
public Action Command_WaveFour(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = false;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	canHWBoss = true;
	canTornado = true;
	HWNMax = 360.0;
	isWave = true;
	bombStatus = 12;
	bombsPushed = 1;
	bombStatusMax = 32;
	sacPointsMax = 90;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 4: Torn From The Heavens");
	StopCurSong();
	EmitSoundToAll(BGM4, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
	curSong = BGM4;
	CreateTimer(122.25, RefireTorn);
	CreateTimer(1.0, BombStatusAddTimer);
	CreateTimer(0.1, BombStatusUpdater);
	CreateTimer(1.0, RobotLaunchTimer);
	CreateTimer(1.0, SacrificePointsTimer);
	CreateTimer(1.0, SacrificePointsUpdater);
	CreateTimer(1.0, RefireStorm);
	ActivateTornadoTimer();
	float hwn = GetRandomFloat(HWNMin, HWNMax);
	CreateTimer(hwn, HWBosses);
}
//Wave Five
public Action Command_WaveFive(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = false;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	canHWBoss = true;
	canTornado = true;
	HWNMax = 260.0;
	HWNMin = 140.0;
	isWave = true;
	bombStatus = 14;
	bombsPushed = 1;
	bombStatusMax = 40;
	sacPointsMax = 100;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 5: Metal - Brute Justice Mode");
	StopCurSong();
	EmitSoundToAll(BGM5, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
	curSong = BGM5;
	CreateTimer(131.75, RefireBJMode);
	CreateTimer(1.0, BombStatusAddTimer);
	CreateTimer(0.1, BombStatusUpdater);
	CreateTimer(1.0, RobotLaunchTimer);
	CreateTimer(1.0, SacrificePointsTimer);
	CreateTimer(1.0, SacrificePointsUpdater);
	CreateTimer(1.0, RefireStorm);
	ActivateTornadoTimer();
	float f = GetRandomFloat(60.0, 180.0);
	CreateTimer(f, UnlockTimer);
	float hwn = GetRandomFloat(HWNMin, HWNMax);
	CreateTimer(hwn, HWBosses);
}
//Wave Six
public Action Command_WaveSix(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = false;
	bgmlock7 = true;
	bgmlock8 = true;
	canHWBoss = true;
	canTornado = true;
	HWNMax = 260.0;
	HWNMin = 140.0;
	isWave = true;
	bombStatus = 20;
	bombsPushed = 2;
	bombStatusMax = 48;
	sacPointsMax = 100;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 6: Grandma Destruction");
	StopCurSong();
	EmitSoundToAll(BGM6, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
	curSong = BGM6;
	CreateTimer(323.95, RefireGrandma);
	CreateTimer(1.0, BombStatusAddTimer);
	CreateTimer(0.1, BombStatusUpdater);
	CreateTimer(1.0, RobotLaunchTimer);
	CreateTimer(1.0, SacrificePointsTimer);
	CreateTimer(1.0, SacrificePointsUpdater);
	CreateTimer(1.0, RefireStorm);
	ActivateTornadoTimer();
	float hwn = GetRandomFloat(HWNMin, HWNMax);
	CreateTimer(hwn, HWBosses);
}
//Wave Seven
public Action Command_WaveSeven(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = false;
	bgmlock8 = true;
	canHWBoss = true;
	canTornado = true;
	HWNMax = 240.0;
	HWNMin = 120.0;
	isWave = true;
	bombStatus = 28;
	bombsPushed = 3;
	bombStatusMax = 56;
	sacPointsMax = 100;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 7: Revenge Twofold");
	StopCurSong();
	EmitSoundToAll(BGM7, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
	curSong = BGM7;
	CreateTimer(133.25, RefireRevenge2F);
	CreateTimer(1.0, BombStatusAddTimer);
	CreateTimer(0.1, BombStatusUpdater);
	CreateTimer(1.0, RobotLaunchTimer);
	CreateTimer(1.0, SacrificePointsTimer);
	CreateTimer(1.0, SacrificePointsUpdater);
	CreateTimer(1.0, RefireStorm);
	ActivateTornadoTimer();
	float hwn = GetRandomFloat(HWNMin, HWNMax);
	CreateTimer(hwn, HWBosses);
}
//Deprecated Functions that should be either reassigned or removed.
public Action Command_HydrogenUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000HYDROGEN \x0700AA55is now available for deployment!");
}

public Action Command_WaveSevenBurgUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has delivered Hydrogen! The \x07FF0000HINDENBURG \x0700AA55is now ready for flight!");
}
//Wave Eight
public Action Command_WaveEight(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = false;
	canHWBoss = true;
	canTornado = true;
	HWNMax = 240.0;
	HWNMin = 120.0;
	isWave = true;
	bombStatus = 30;
	bombsPushed = 3;
	bombStatusMax = 64;
	sacPointsMax = 100;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 8: Under The Weight");
	StopCurSong();
	EmitSoundToAll(BGM8, _, SNDCHAN, BGMSNDLVL, _, _, _, _, _, _, _, _);
	curSong = BGM8;
	CreateTimer(313.85, RefireUnderTW);
	CreateTimer(1.0, BombStatusAddTimer);
	CreateTimer(0.1, BombStatusUpdater);
	CreateTimer(1.0, RobotLaunchTimer);
	CreateTimer(1.0, SacrificePointsTimer);
	CreateTimer(1.0, SacrificePointsUpdater);
	CreateTimer(1.0, RefireStorm);
	ActivateTornadoTimer();
	float hwn = GetRandomFloat(HWNMin, HWNMax);
	CreateTimer(hwn, HWBosses);
}
//Specials
public Action Command_FoundGoob(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55ALL HAIL \x07FF00FFGOOBBUE\x0700AA55!");
}

public Action Command_FoundWaffle(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Oh no, someone has found and (probably) consumed a \x07FF0000WAFFLE OF MASS DESTRUCTION\x07FFFFFF!");
}

public Action Command_FoundBurrito(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Why would you even eat \x07FF0000The Forbidden Burrito\x07FFFFFF?");
}

public Action Command_FoundShroom(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Welp, someone is playing \x0700FF00Mario\x07FFFFFF...");
}

public Action Command_FoundBall(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55What on earth IS that? It appears to be a... \x075050FFBLUE BALL\x07FFFFFF!");
}
//Sacrifice Points Notifications
public Action Command_TSPlus1(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Sacrificed a client into orbit. (\x0700FF00+1 pt\x07FFFFFF)");
	sacPoints++;
}

public Action Command_DPSacPlus1(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Sent a client to their doom. (\x0700FF00+1 pt\x07FFFFFF)");
	sacPoints++;
}

public Action Command_KissoneSacPlus1(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Dunked a client into liquid death. (\x0700FF00+1 pt\x07FFFFFF)");
	sacPoints++;
}

public Action Command_TankDestPlus1(int args){
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF A tank has been destroyed. (\x0700FF00+1 pt\x07FFFFFF)");
	sacPoints++;
}
public Action Command_BombResPlus5(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Bomb has been reset. (\x0700FF00+5 pts\x07FFFFFF)");
	sacPoints+=5;
}

public Action Command_BathSaltsSacMinus10(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF INSTANT BATH SALT DETONATION! (\x07FF0000-10 pts\x07FFFFFF)");
	sacPoints = (sacPoints - 10);
}

public Action Command_FatManSacMinus20(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF INSTANT FAT MAN DETONATION! (\x07FF0000-20 pts\x07FFFFFF)");
	sacPoints = (sacPoints - 20);
}

public Action Command_GoobbueSacMinus30(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF GOOBBUE COMING IN FROM ORBIT! (\x07FF0000-30 pts\x07FFFFFF)");
	sacPoints = (sacPoints - 30);
}

public Action Command_BlueBallSacMinus30(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF BLUE KIRBY FALLING OUT OF THE SKY! (\x07FF0000-30 pts\x07FFFFFF)");
	sacPoints = (sacPoints - 30);
}

public Action Command_GBoomSacMinus40(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF We're spending most our lives living in an EXPLOSIVE PARADISE! (\x07FF0000-40 pts\x07FFFFFF)");
	sacPoints = (sacPoints - 40);
}

public Action Command_AssGasMinus40(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF NO NO NO, STOP THE SHARTS!!!! (\x07FF0000-40 pts\x07FFFFFF)");
	sacPoints = (sacPoints - 40);
}

public Action Command_KirbyWardSacMinus50(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF A PINK KIRBY HAS BANISHED TORNADOES FOR THIS WAVE! (\x07FF0000-50 pts\x07FFFFFF)");
	KillTornado();
	canTornado = false;
	sacPoints = (sacPoints - 50);
}

public Action Command_NFOSacMinus60(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF TOTAL ATOMIC ANNIHILATION. (\x07FF0000-60 pts\x07FFFFFF)");
	sacPoints = (sacPoints - 60);
	canSENTNukes = true;
	CreateTimer(1.0, SENTNukeTimer);
	CreateTimer(30.0, DisableSENTNukes);
}

public Action Command_MeteorsSacMinus70(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF COSMIC DEVASTATION IMMINENT. (\x07FF0000-70 pts\x07FFFFFF)");
	sacPoints = (sacPoints - 70);
	canSENTMeteors = true;
	CreateTimer(1.0, SENTMeteorTimer);
	CreateTimer(30.0, DisableSENTMeteors);
}

public Action Command_DovahSacMinus100(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF NOW PRESENTING... PROFESSOR FARTSALOT OF THE HINDENBURG! (\x07FF0000-100 points\x07FFFFFF)");
	sacPoints = (sacPoints - 100);
}

public Action Command_DovahsAssFinished(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF YOU HAVE SUCCESSFULLY COMPLETED DOVAH'S ASS ! THE SERVER WILL RESTART IN 10 SECONDS.");
	CreateTimer(10.0, Timer_RestartServer);
}

//Taco Bell edition commands and features
public Action Command_TacoBell(int args)
{
	PrintToChatAll("\x070000AA[\x07AAAA00INFO\x070000AA] \x07FFFFFFYou have chosen \x07AA0000DOVAH'S ASS - TACO BELL EDITION\x07FFFFFF. Why... Why would you DO THIS?! Do you not realize what you've just done?????");
}

public Action Command_TBWave01(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 01: Battle On The Big Bridge");
}

public Action Command_TBWave02(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 02: Locus");
}

public Action Command_TBWave03(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 03: Metal");
}

public Action Command_TBWave04(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 04: Torn From The Heavens");
}

public Action Command_TBWave05(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 05: Exponential Entropy");
}

public Action Command_TBWave06(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 06: Grandma Destruction");
}

public Action Command_TBWave07(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 07: Rise");
}

public Action Command_TBWave08(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 08: Metal - Brute Justice Mode");
}

public Action Command_TBWave09(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 09: Locus");
}

public Action Command_TBWave10(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 10: Exponential Entropy");
}

public Action Command_TBWave11(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 11: Revenge Twofold");
}

public Action Command_TBWave12(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 12: Metal");
}

public Action Command_TBWave13(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 13: Grandma Destruction");
}

public Action Command_TBWave14(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 14: Under The Weight");
}

public Action Command_TBWave15(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 15: Metal - Brute Justice Mode");
}

public Action Command_TBWave16(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 16: Exponential Entropy");
}

public Action Command_TBWave17(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 17: Locus");
}

public Action Command_TBWave18(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 18: Torn From The Heavens");
}

public Action Command_TBWave19(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 19: Metal");
}

public Action Command_TBWave20(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 20: Grandma Destruction");
}

public Action Command_TBWave21(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 21: Battle on the Big Bridge");
}

public Action Command_TacoBellFinished(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF YOU HAVE SUCCESSFULLY COMPLETED DOVAH'S ASS - TACO BELL EDITION! THE SERVER WILL RESTART IN 10 SECONDS.");
	CreateTimer(10.0, Timer_RestartServer);
}

//Check who died by what and announce it to chat.
public Action EventDeath(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast)
{
    int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
    int attacker = GetClientOfUserId(Spawn_Event.GetInt("attacker"));
    char weapon[32];
    Spawn_Event.GetString("weapon", weapon, sizeof(weapon));
    if (0 < client <= MaxClients && IsClientInGame(client))
    {
		int damagebits = Spawn_Event.GetInt("damagebits");
		if ((damagebits & (1 << 0)) && !attacker) //DMG_CRUSH
    	{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was crushed by a \x07AA0000FALLING ROCK FROM OUTER SPACE\x07FFFFFF!", client);
        }

		if ((damagebits & (1 << 3)) && !attacker) //DMG_BURN
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was \x07AA0000MELTED\x07FFFFFF.", client);
		}
		
		if ((damagebits & (1 << 4)) && !attacker) //DMG_VEHICLE (DMG_FREEZE)
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was flattened out by a \x07AA0000TRAIN\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 5)) && !attacker) //DMG_FALL
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was \x07AA0000YEETED OUT INTO ORBIT\x07FFFFFF!", client);
			int i = GetRandomInt(1, 16);
			switch (i){
				case 1:{
					EmitSoundToAll(FALLSND01);
				}
				case 2:{
					EmitSoundToAll(FALLSND02);
				}
				case 3:{
					EmitSoundToAll(FALLSND03);
				}
				case 4:{
					EmitSoundToAll(FALLSND04);
				}
				case 5:{
					EmitSoundToAll(FALLSND05);
				}
				case 6:{
					EmitSoundToAll(FALLSND06);
				}
				case 7:{
					EmitSoundToAll(FALLSND07);
				}
				case 8:{
					EmitSoundToAll(FALLSND08);
				}
				case 9:{
					EmitSoundToAll(FALLSND09);
				}
				case 10:{
					EmitSoundToAll(FALLSND0A);
				}
				case 11:{
					EmitSoundToAll(FALLSND0B),
					FireEntityInput("FB.BlueKirbTemplate", "ForceSpawn", "", 0.0),
					Command_FoundBall(0);
				}
				case 12:{
					EmitSoundToAll(FALLSND0C);
				}
				case 13:{
					EmitSoundToAll(FALLSND0D);
				}
				case 14:{
					EmitSoundToAll(FALLSND0E);
				}
				case 15:{
					EmitSoundToAll(FALLSND0F);
				}
				case 16:{
					EmitSoundToAll(FALLSND10);
				}
			}
		}

		if ((damagebits & (1 << 6)) && !attacker) //DMG_BLAST
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N went \x07AA0000 KABOOM\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 7)) && !attacker) //DMG_CLUB
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N is \x07AA0000CRASHING THE HINDENBURG\x07FFFFFF!!!", client);
		}

		if ((damagebits & (1 << 8)) && !attacker) //DMG_SHOCK
		{
			PrintToChatAll("\x070000AA[\x07AA0000EXTERMINATUS\x070000AA]\x07FFFFFF Client %N has humliated themselves with an \x07AA0000incorrect \x07FFFFFFkey entry!", client);
			int i = GetRandomInt(1, 16);
			switch(i){
				case 1,3,10:{
					FireEntityInput("BG.Meteorites1", "ForceSpawn", "", 0.0),
					Command_MeteorIncoming(0),
					FireEntityInput("bg.meteorite1", "StartForward", "", 0.1);
				}
				case 2,5,16:{
					CreateTimer(0.5, FBCodeFailTankHornSND);
					FireEntityInput("FB.TankTrain", "TeleportToPathTrack", "Tank01", 0.0),
					FireEntityInput("FB.TankTrain", "StartForward", "", 0.25),
					FireEntityInput("FB.TankTrain", "SetSpeed", "1", 0.35),
					FireEntityInput("FB.Tank", "Enable", "", 1.0);
				}
				case 4,8,14:{
					EmitSoundToAll("ambient/alarms/train_horn_distant1.wav"),
					FireEntityInput("TrainSND", "PlaySound", "", 0.0),
					FireEntityInput("TrainDamage", "Enable", "", 0.0),
					FireEntityInput("Train01", "Enable", "", 0.0),
					Command_TrainIncoming(0),
					FireEntityInput("TrainTrain", "TeleportToPathTrack", "TrainTrack01", 0.0),
					FireEntityInput("TrainTrain", "StartForward", "", 0.1);
				}
				case 6,9:{
					canTornado = true,
					CreateTimer(1.0, SpawnTornado);
				}
				case 7,13:{
					Command_MeteorShower(0),
					canSENTMeteors = true,
					CreateTimer(1.0, SENTMeteorTimer),
					CreateTimer(30.0, DisableSENTMeteors);
				}
				case 11:{
					FireEntityInput("FB.Slice", "Enable", "", 0.0),
					EmitSoundToAll("ambient/sawblade_impact1.wav"),
					FireEntityInput("FB.Slice", "Disable", "", 1.0);
				}
				case 12,15:{
					Command_AtomBmbRain(0),
					canSENTNukes = true,
					CreateTimer(1.0, SENTNukeTimer),
					CreateTimer(30.0, DisableSENTNukes);
				}
			}
		}

		if ((damagebits & (1 << 9)) && !attacker) //DMG_SONIC
		{
			PrintToChatAll("\x070000AA[\x07AA0000EXTERMINATUS\x070000AA]\x07FFFFFF Client %N has sacrificed themselves with a \x0700AA00correct \x07FFFFFFkey entry! Prepare your anus!", client);
		}

		if ((damagebits & (1 << 10)) && !attacker) //DMG_ENERGYBEAM
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N has been vaporized by a \x07AA0000HIGH ENERGY PHOTON BEAM\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 14)) && !attacker) //DMG_DROWN
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N \x07AA0000DROWNED\x07FFFFFF.", client);
		}

		if ((damagebits & (1 << 15)) && !attacker) //DMG_PARALYZE
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N has been crushed by a \x070000AAMYSTERIOUS BLUE BALL\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 16)) && !attacker) //DMG_NERVEGAS
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N has been \x07AA0000SLICED TO RIBBONS\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 17)) && !attacker) //DMG_POISON
		{
			ServerCommand("sm_psay %d \x07FF0000[\x0700FF00ADMIN\x07FF0000] \x07AAAAAAPlease don't sit IDLE in the FC Tavern. Repeated offenses may result in a kick.");
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was killed for standing in the Tavern instead of helping their team!", client);
		}

		if ((damagebits & (1 << 18)) && !attacker) //DMG_RADIATION
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was blown away by a \x07AA0000NUCLEAR EXPLOSION\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 19)) && !attacker) //DMG_DROWNRECOVER
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N experienced \x07AA0000TACO BELL\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 20)) && !attacker) //DMG_ACID
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N has been crushed by a \x0700AA00FALLING GOOBBUE FROM OUTER SPACE\x07FFFFFF!", client);
		}
	}
    return Plugin_Handled;
}

//Silence cvar changes to minimize chat spam.
public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast)
{
	event.BroadcastDisabled = true;
}
//When we win
public Action EventWaveComplete(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	canHWBoss = false;
	canTornado = false;
	isWave = false;
	bombStatusMax = 7;
	bombStatus = 5;
	bombsPushed = 0;
	SelectBGM();
	PrintToChatAll("\x0700FF00[CORE] \x07FFFFFFYou've defeated the wave!");
	FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0),
	FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
}

//Announce when we are in danger.
public Action EventWarning(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA]\x07AA0000 WARNING\x07FFFFFF: \x07AA0000DOVAH'S ASS IS ABOUT TO BE DEPLOYED!!!");
}

//When we fail
public Action EventWaveFailed(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast){
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	canHWBoss = false;
	canTornado = false;
	isWave = false;
	bombStatusMax = 7;
	bombStatus = 5;
	bombsPushed = 0;
	SelectBGM();
	PrintToChatAll("\x0700FF00[CORE] \x07FFFFFFWave set/reset success!");
	FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0),
	FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
}
//Announce the bomb has been reset by client %N.
public Action EventReset(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast)
{
	int client = Spawn_Event.GetInt("player");
	if (0 < client <= MaxClients && IsClientInGame(client))
    {
		PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Client \x0700AA00%N\x07FFFFFF has reset the ass!", client);
	}
	return Plugin_Handled;
}

//Used by various entities to jump us to the previous wave.
public Action Command_JumpToPrevWave(int args)
{
	int ent = FindEntityByClassname(-1, "tf_objective_resource");
	if(ent == -1)
	{
		LogMessage("tf_objective_resource not found");
		return;
	}

	int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
	int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
	int prev_wave = current_wave - 1;
	if(prev_wave >= max_wave)
    {
		PrintToChatAll("\x07AA0000[ERROR] \x07FFFFFFHOW THE HELL DID WE GET HERE?!");
		return;
	}

	if(prev_wave < 1)
	{
		PrintToChatAll("\x07AA0000[ERROR] \x07FFFFFFWE CAN'T JUMP TO WAVE 0, WHY WOULD YOU TRY THAT??");
		return;
	}
	JumpToWave(prev_wave);
}

//Used by various entities to jump us to the next wave.
public Action Command_JumpToNextWave(int args)
{
	int ent = FindEntityByClassname(-1, "tf_objective_resource");
	if(ent == -1)
	{
		LogMessage("tf_objective_resource not found");
		return;
	}

	int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
	int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
	int next_wave = current_wave + 1;
	if(next_wave > max_wave)
    {
		ServerCommand("fb_forcevictory");
		return;
	}
	JumpToWave(next_wave);
}

//Jump to the wave.
public Action JumpToWave(int wave_number)
{
	int flags = GetCommandFlags("tf_mvm_jump_to_wave");
	SetCommandFlags("tf_mvm_jump_to_wave", flags & ~FCVAR_CHEAT);
	ServerCommand("tf_mvm_jump_to_wave %d", wave_number);
	FakeClientCommand(0, "");
	SetCommandFlags("tf_mvm_jump_to_wave", flags|FCVAR_CHEAT);
}

//Timer to restart the server.
public Action Timer_RestartServer(Handle timer)
{
	ServerCommand("_restart");
}

//Create a temp entity and fire an input
public Action FireEntityInput(char[] strTargetname, char[] strInput, char[] strParameter, float flDelay)
{
	char strBuffer[255];
	Format(strBuffer, sizeof(strBuffer), "OnUser1 %s:%s:%s:%f:1", strTargetname, strInput, strParameter, flDelay);
	PrintToChatAll("\x0700FF00[CORE] \x07FFFFFF Firing entity %s with input %s , a parameter override of %s , and delay of %f ...", strTargetname, strInput, strParameter, flDelay);
	int entity = CreateEntityByName("info_target");
	if(IsValidEdict(entity))
	{
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
public Action DeleteEdict(Handle timer, any entity)
{
	if(IsValidEdict(entity)) RemoveEdict(entity);
	return Plugin_Stop;
}