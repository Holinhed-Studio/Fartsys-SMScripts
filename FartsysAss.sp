/*                         WELCOME TO FARTSY'S ASS ROTTENBURG.
*
*   A FEW THINGS TO KNOW: ONE.... THIS IS INTENDED TO BE USED WITH UBERUPGRADES.
*   TWO..... THE MUSIC USED WITH THIS MOD MAY OR MAY NOT BE COPYRIGHTED. WE HAVE NO INTENTION ON INFRINGEMENT.
*   THREE..... THIS MOD IS INTENDED FOR USE ON THE FIREHOSTREDUX SERVERS ONLY. SUPPORT IS LIMITED.
*   FOUR..... THIS WAS A NIGHTMARE TO FIGURE OUT AND BUG FIX. I HOPE IT WAS WORTH IT.
*   FIVE..... PLEASE HAVE FUN AND ENJOY YOURSELF!
*   SIX..... THE DURATION OF MUSIC TIMERS SHOULD BE SET DEPENDING WHAT SONG IS USED. SET THIS USING THE FLOATS BGM<X>Dur BELOW.
*   SEVEN..... TIPS AND TRICKS MAY BE ADDED TO THE TIMER, SEE PerformAdverts(Handle timer);
*
*                                       GL HF!!!
*/
#include <sourcemod>
#include <sdktools>
#include <clientprefs>
#pragma newdecls required
#pragma semicolon 1
bool bombProgression = false;
bool canHWBoss = false;
bool canSENTMeteors = false;
bool canSENTNukes = false;
bool canSENTShark = false;
bool canSENTStars = false;
bool canTornado = false;
bool crusader = false;
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
bool onslaughter = false;
bool TornadoWarningIssued = false;
static char BELL[32] = "fartsy/misc/bell.wav";
static char BGM1[32] = "fartsy/ffxiv/bgm/locus.mp3";
static char BGM2[32] = "fartsy/ffxiv/bgm/metal.mp3";
static char BGM3[64] = "fartsy/ffxiv/bgm/exponentialentropy.mp3";
static char BGM4[64] = "fartsy/ffxiv/bgm/tornfromtheheavens.mp3";
static char BGM5[64] = "fartsy/ffxiv/bgm/metalbrutejusticemode.mp3";
static char BGM6[64] = "fartsy/ffxiv/bgm/penitus.mp3";
static char BGM7[64] = "fartsy/ffxiv/bgm/revengetwofold.mp3";
static char BGM8[64] = "fartsy/ffxiv/bgm/undertheweight.mp3";
static char BGM1Title[32] = "FFXIV - Locus";
static char BGM2Title[32] = "FFXIV - Metal";
static char BGM3Title[32] = "FFXIV - Exponential Entropy";
static char BGM4Title[32] = "FFXIV - Torn From the Heavens";
static char BGM5Title[64] = "FFXIV - Metal: Brute Justice Mode";
static char BGM6Title[32] = "FFXIV - Penitus";
static char BGM7Title[32] = "FFXIV - Revenge Twofold";
static char BGM8Title[32] = "FFXIV - Under the Weight";
static float BGM1Dur = 229.25;
static float BGM2Dur = 153.95;
static float BGM3Dur = 166.85;
static float BGM4Dur = 122.25;
static float BGM5Dur = 131.75;
static float BGM6Dur = 427.35;
static float BGM7Dur = 133.25;
static float BGM8Dur = 313.85;
static char BMB1SND[32] = "fartsy/misc/murica.mp3";
static char BMB2SND[32] = "fartsy/bl2/grenade_detonate.mp3";
static char BMB3SND[32] = "fartsy/gbombs5/t_12.mp3";
static char BMB4SND[32] = "fartsy/misc/majorkong.mp3";
static char BOOM[32] = "fartsy/vo/spongebob/boom.mp3";
static char CLOCKTICK[32] = "fartsy/misc/clock_tick.wav";
static char COUNTDOWN[32] = "fartsy/misc/countdown.wav";
static char CRUSADERATTACK[32] = "fartsy/fallingback/attack.mp3";
char curSong[64] = "null";
char songName[64] = "null";
static char DEFAULTBGM1[64] = "fartsy/ffxiv/bgm/TheSilentRegardOfStars.mp3";
static char DEFAULTBGM2[64] = "fartsy/ffxiv/bgm/KnowledgeNeverSleeps.mp3";
static float DefBGM1Dur = 137.75;
static float DefBGM2Dur = 235.5;
static char DEFAULTBGM1Title[64] = "FFXIV - The Silent Regard of Stars";
static char DEFAULTBGM2Title[64] = "FFXIV - Knowledge Never Sleeps";
static char EXPLOSIVEPARADISE[64] = "fartsy/misc/explosiveparadise.mp3";
static char FALLSND01[32] = "vo/l4d2/billfall02.mp3";
static char FALLSND02[32] = "vo/l4d2/coachfall02.mp3";
static char FALLSND03[32] = "vo/l4d2/ellisfall01.mp3";
static char FALLSND04[32] = "vo/l4d2/francisfall02.mp3";
static char FALLSND05[32] = "vo/l4d2/louisfall01.mp3";
static char FALLSND06[32] = "vo/l4d2/louisfall03.mp3";
static char FALLSND07[32] = "vo/l4d2/nickfall01.mp3";
static char FALLSND08[32] = "vo/l4d2/zoeyfall01.mp3";
static char FALLSND09[32] = "vo/ddd/woahhh.mp3";
static char FALLSND0A[32] = "vo/jigglypuff/jigglypuff.mp3";
static char FALLSND0B[32] = "vo/kirby/eeeahhhh.mp3";
static char FALLSND0C[32] = "vo/luigi/ohohohohoo.mp3";
static char FALLSND0D[32] = "vo/mario/wahahahaha.mp3";
static char FALLSND0E[32] = "vo/pika/pikapika.mp3";
static char FALLSND0F[32] = "vo/wario/wheee.mp3";
static char FALLSND10[32] = "vo/mario/wowww.mp3";
static char GLOBALTHUNDER01[32] = "fartsy/weather/thunder1.wav";
static char GLOBALTHUNDER02[32] = "fartsy/weather/thunder2.wav";
static char GLOBALTHUNDER03[32] = "fartsy/weather/thunder3.wav";
static char GLOBALTHUNDER04[32] = "fartsy/weather/thunder4.wav";
static char GLOBALTHUNDER05[32] = "fartsy/weather/thunder5.wav";
static char GLOBALTHUNDER06[32] = "fartsy/weather/thunder6.wav";
static char GLOBALTHUNDER07[32] = "fartsy/weather/thunder7.wav";
static char GLOBALTHUNDER08[32] = "fartsy/weather/thunder8.wav";
static char HINDENBURGBOOM[64] = "fartsy/gbombs5/tsar_detonate.mp3";
static char HINDENCRASH[32] = "fartsy/vo/jeffy/hinden.wav";
static char INCOMING[64] = "fartsy/vo/ddo/koboldincoming.mp3";
static char OnslaughterLaserSND[32] = "fartsy/misc/antimatter.mp3";
static char OnslaughterFlamePreATK[32] = "weapons/flame_thrower_start.wav"; //CHECK WITH BRAWLER IF THIS IS NEEDED IN THE PAK....
static char OnslaughterFlamePostATK[32] = "weapons/flame_thrower_end.wav"; // LIKEWISE WITH THIS ONE.	
static char RETURNSND[32] = "fartsy/ffxiv/return.mp3";
static char RETURNSUCCESS[32] = "fartsy/ffxiv/returnsuccess.mp3";
static char SHARKSND01[32] = "fartsy/memes/babyshark/baby.mp3";
static char SHARKSND02[64] = "fartsy/memes/babyshark/baby02.mp3";
static char SHARKSND03[64] = "fartsy/memes/babyshark/doot01.mp3";
static char SHARKSND04[64] = "fartsy/memes/babyshark/doot02.mp3";
static char SHARKSND05[64] = "fartsy/memes/babyshark/doot03.mp3";
static char SHARKSND06[64] = "fartsy/memes/babyshark/doot04.mp3";
static char SHARKSND07[64] = "fartsy/memes/babyshark/shark.mp3";
static char SHARKSND08[64] = "fartsy/memes/babyshark/shark02.mp3";
static char SPEC01[32] = "fartsy/vo/fartsy/goobbue.mp3";
static char SPEC02[32] = "fartsy/misc/shroom.mp3";
static char SPEC03[64] = "fartsy/vo/inurat/nuclearwaffle.mp3";
static char STRONGMAN[32] = "fartsy/misc/strongman_bell.wav";
static char TRIGGERSCORE[32] = "fartsy/misc/triggerscore.wav";
static char WTFBOOM[32] = "fartsy/misc/wtfboom.mp3";
static float HWNMin = 210.0;
static float HWNMax = 380.0;
static float Return[3] = {-3730.0, 67.0, -252.0};
static int BGMSNDLVL = 100;
int INCOMINGDISPLAYED = 0;
int clientID = 0;
int CodeEntry = 0;
static int DEFBGMSNDLVL = 50;
int bombStatus = 0;
int bombStatusMax = 0;
int explodeType = 0;
int lastAdmin = 0;
int sacPoints = 0;
int sacPointsMax = 60;
static int SNDCHAN = 6;
int soundPreference[MAXPLAYERS + 1];
Handle cookieSNDPref;
Handle cvarSNDDefault = INVALID_HANDLE;

public Plugin myinfo =
{
	name = "Fartsy's Ass - Framework",
	author = "Fartsy#8998",
	description = "Framework for Fartsy's Ass (MvM Mods)",
	version = "3.8.0",
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
	PrecacheSound(BMB1SND, true),
	PrecacheSound(BMB2SND, true),
	PrecacheSound(BMB3SND, true),
	PrecacheSound(BMB4SND, true),
	PrecacheSound(BOOM, true),
    PrecacheSound(CLOCKTICK, true),
    PrecacheSound(COUNTDOWN, true),
    PrecacheSound(CRUSADERATTACK, true),
    PrecacheSound(DEFAULTBGM1, true),
    PrecacheSound(DEFAULTBGM2, true),
	PrecacheSound(EXPLOSIVEPARADISE, true),
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
	PrecacheSound(HINDENBURGBOOM, true),
	PrecacheSound(HINDENCRASH, true),
	PrecacheSound(INCOMING, true),
	PrecacheSound(OnslaughterLaserSND, true),
	PrecacheSound(OnslaughterFlamePreATK, true),
	PrecacheSound(OnslaughterFlamePostATK, true),
	PrecacheSound(RETURNSND, true),
	PrecacheSound(RETURNSUCCESS, true),
    PrecacheSound(SHARKSND01, true),
    PrecacheSound(SHARKSND02, true),
    PrecacheSound(SHARKSND03, true),
    PrecacheSound(SHARKSND04, true),
    PrecacheSound(SHARKSND05, true),
    PrecacheSound(SHARKSND06, true),
    PrecacheSound(SHARKSND07, true),
    PrecacheSound(SHARKSND08, true),
	PrecacheSound(SPEC01, true),
	PrecacheSound(SPEC02, true),
	PrecacheSound(SPEC03, true),
    PrecacheSound(STRONGMAN, true),
    PrecacheSound(TRIGGERSCORE, true),
    PrecacheSound(WTFBOOM, true),
	PrecacheSound("mvm/ambient_mp3/mvm_siren.mp3", true),
    PrecacheSound("fartsy/fallingback/bgm.mp3", true),
    RegServerCmd("fb_operator", Command_Operator, "Serverside only. Does nothing when executed as client."),
    RegServerCmd("tacobell_wave01", Command_TBWave01,"Taco Bell - Wave One"),
    RegServerCmd("tacobell_finished", Command_TacoBellFinished, "TacoBell has been completed!"),
    RegConsoleCmd("sm_bombstatus", Command_FBBombStatus, "Check bomb status"),
    RegConsoleCmd("sm_sacstatus", Command_FBSacStatus, "Check sacrifice points status"),
    RegConsoleCmd("sm_song", Command_GetCurrentSong, "Get current song name"),
	RegConsoleCmd("sm_return", Command_Return, "Return to Spawn"),
	RegConsoleCmd("sm_discord", Command_Discord, "Join our Discord server!"),
	RegConsoleCmd("sm_sounds", Command_Sounds, "Toggle sounds on or off via menu"),
    HookEvent("player_death", EventDeath),
    HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre),
    HookEvent("mvm_wave_complete", EventWaveComplete),
    HookEvent("mvm_wave_failed", EventWaveFailed),
    HookEvent("mvm_bomb_alarm_triggered", EventWarning),
    HookEvent("mvm_bomb_reset_by_player", EventReset);
    PrintToChatAll("Plugin Loaded.");
    LoadTranslations("plugin.FartsysAss");
    cvarSNDDefault = CreateConVar("sm_fartsysass_sound", "3", "Default sound for new users, 3 = Everything, 2 = Sounds Only, 1 = Music Only, 0 = Nothing");
    cookieSNDPref = RegClientCookie("Sound Pref", "Sound settings", CookieAccess_Private);
    SetCookieMenuItem(FartsysSNDSelected, 0, "Fartsys Ass Sound Preferences");
}
//Clientprefs built in menu
public void FartsysSNDSelected(int client, CookieMenuAction action, any info, char[] buffer, int maxlen) 
{
	if (action == CookieMenuAction_SelectOption)
	{
		ShowFartsyMenu(client);
	}
}
// When a new client joins we reset sound preferences
public void OnClientPutInServer(int client)
{
	if(!IsFakeClient(client))
	{
		soundPreference[client] = GetConVarInt(cvarSNDDefault);
		if (AreClientCookiesCached(client))
		{
			getClientCookiesFor(client);
		}
	}
	else
	{
		soundPreference[client] = 0;
	}
}

public void getClientCookiesFor(int client){
	char buffer[5];
	GetClientCookie(client, cookieSNDPref, buffer, 5);
	if(!StrEqual(buffer, ""))
	{
		soundPreference[client] = StringToInt(buffer);
	}
}

public void ShowFartsyMenu(int client)
{
    Menu menu = new Menu(MenuHandlerFartsy, MENU_ACTIONS_DEFAULT);
    char buffer[100];
    menu.SetTitle("FartsysAss Sound Menu");
    menu.AddItem(buffer, "Disable ALL");
    menu.AddItem(buffer, "Music Only");
    menu.AddItem(buffer, "Sound Effects Only");
    menu.AddItem(buffer, "Enable ALL");
    menu.Display(client, 20);
    menu.ExitButton = true;
}

//Create menu
public Action Command_Sounds(int client, int args)
{
	ShowFartsyMenu(client);
	return Plugin_Handled;
}

//  This selects or disables the sounds
public int MenuHandlerFartsy(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		PrintToChatAll("%i", param2);
		soundPreference[param1] = param2;
		char buffer[5];
		IntToString(soundPreference[param1], buffer, 5);
		SetClientCookie(param1, cookieSNDPref, buffer);
		PrintToChatAll("Set client cookie to %i and %s", param1, buffer);
		Command_Sounds(param1, 0);
	} 
	else if(action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

//Now that command definitions are done, lets make some things happen.
public void OnMapStart()
{
    FireEntityInput("rain", "Alpha", "0", 0.0);
    SelectAdmin();
    CreateTimer(1.0, SelectAdminTimer);
}
//Select background music
public Action SelectBGM()
{
	StopCurSong();
	int BGM = GetRandomInt(1, 2);
	switch(BGM){
		case 1:{
			CustomSoundEmitter(DEFAULTBGM1, DEFBGMSNDLVL);
			curSong = DEFAULTBGM1;
			songName = DEFAULTBGM1Title;
			CreateTimer(DefBGM1Dur, RefireDefBGM1);
			PrintToServer("Creating timer for The Silent Regard of Stars. Enjoy the music!");
		}
		case 2:{
			CustomSoundEmitter(DEFAULTBGM2, DEFBGMSNDLVL);
			curSong = DEFAULTBGM2;
			songName = DEFAULTBGM2Title;
			PrintToServer("Creating timer for Knowledge Never Sleeps. Enjoy the music!");
			CreateTimer(DefBGM2Dur, RefireDefBGM2);
		}
	}
}

//Stop current song
public Action StopCurSong(){
    if (StrEqual(curSong, "null")) return Plugin_Handled;
    for(int i=1;i<=MaxClients;i++)
    {
        StopSound(i, SNDCHAN, curSong);
    }
    return Plugin_Handled;
}

//Feature admin timer
public Action SelectAdminTimer(Handle timer){
	if (isWave){
		return Plugin_Stop;
	}
	else{
		SelectAdmin();
		float f = GetRandomFloat(40.0, 120.0);
		CreateTimer(f, SelectAdminTimer);
		return Plugin_Handled;
	}
}

//Feature an admin
public Action SelectAdmin(){
	FireEntityInput("Admins*", "Disable", "", 0.0);
	int i = GetRandomInt(1, 9);
	switch (i){
		case 1:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.Brawler", "Enable", "", 0.05);
				lastAdmin = 1;
			}
		}
		case 2:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.Comical", "Enable", "", 0.05);
				lastAdmin = 2;
			}
		}
		case 3:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.Holinhed", "Enable", "", 0.05);
				lastAdmin = 3;
			}
		}
		case 4:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.JoeyGhost", "Enable", "", 0.05);
				lastAdmin = 4;
			}
		}
		case 5:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.KaiserCrazed", "Enable", "", 0.05);
				lastAdmin = 5;
			}
		}
		case 6:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.KissoneKinoma", "Enable", "", 0.05);
				lastAdmin = 6;
			}
		}
		case 7:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.LixianPrime", "Enable", "", 0.05);
				lastAdmin = 7;
			}
		}
		case 8:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.ProfessorFartsalot", "Enable", "", 0.05);
				lastAdmin = 8;
			}
		}
		case 9:{
			if (i == lastAdmin)
			{
				SelectAdmin();
			}
			else{
				FireEntityInput("Admins.Ribbons", "Enable", "", 0.05);
				lastAdmin = 9;
			}
		}
	}
	return Plugin_Handled;
}
//Timers
//Adverts for tips/tricks
public Action PerformAdverts(Handle timer){
	if (!isWave){
		CreateTimer (180.0, PerformAdverts);
		int i = GetRandomInt(1, 7);
		switch (i){
			case 1:{
				PrintToChatAll("\x07800080[\x0780AAAACORE\x07800080]\x07FFFFFF We have a Discord server: \x0700AA00https://discord.com/invite/SkHaeMH");
			}
			case 2:{
				PrintToChatAll("\x07800080[\x0780AAAACORE\x07800080]\x07FFFFFF Remember to buy your upgrades using \x0700AA00!buy");
			}
			case 3:{
				PrintToChatAll("\x07800080[\x0780AAAACORE\x07800080]\x07FFFFFF If this is your first time here, please run console command \x0700AA00snd_restart \x07FFFFFFfor safety. Otherwise, you might \x07FF0000crash\x07FFFFFF!");
			}
			case 4:{
				PrintToChatAll("\x07800080[\x0780AAAACORE\x07800080]\x07FFFFFF Advanced users may quick buy upgrades using \x0700AA00!qbuy");
			}
			case 5:{
				PrintToChatAll("\x07800080[\x0780AAAACORE\x07800080]\x07FFFFFF Don't forget to buy \x0700AA00protection upgrades\x07FFFFFF and \x0700AA00ammo regen\x07FFFFFF (if applicable)!");
			}
            case 6:{
                PrintToChatAll("\x07800080[\x0780AAAACORE\x07800080]\x07FFFFFF TIP: As a \x07AA0000DEFENDER\x07FFFFFF, pushing your team's \x0700AA00payload\x07FFFFFF is crucial to wrecking havoc on the robots!");
            }
            case 7:{
                PrintToChatAll("\x07800080[\x0780AAAACORE\x07800080]\x07FFFFFF Remember, if someone is being abusive, you may always invoke \x0700AA00!calladmin\x07FFFFFF.");
            }
		}
	}
	return Plugin_Stop;
}
//Adverts for wave information
public Action PerformWaveAdverts(Handle timer){
	if (isWave){
		CreateTimer(2.5, PerformWaveAdverts);
		for(int i=1;i<=MaxClients;i++)
    	{
			switch (bombStatus){
				case 8,16,24,32,40,48,56,64:{
					if(TornadoWarningIssued && IsClientInGame(i)){
						if(bombProgression){
							PrintHintText(i, "Bomb Status: MOVING (%i/%i) || Sacrifice Points: %i/%i \nCurrent song: %s \n\nA TORNADO WARNING HAS BEEN ISSUED...", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
							StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
						}
						else{
							PrintHintText(i, "Bomb Status: READY (%i/%i) || Sacrifice Points: %i/%i \nCurrent song: %s \n\nA TORNADO WARNING HAS BEEN ISSUED...", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
							StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
						}
					}
					else if(bombProgression && IsClientInGame(i)){
						PrintHintText(i, "Bomb Status: MOVING (%i/%i) || Sacrifice Points: %i/%i \nCurrent song: %s", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
						StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
					}
					else if(IsClientInGame(i)){
						PrintHintText(i, "Bomb Status: READY (%i/%i) || Sacrifice Points: %i/%i \nCurrent song: %s", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
						StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
					}
				}
				case 0,1,2,3,4,5,6,7,9,10,11,12,13,14,15,17,18,19,20,21,22,23,25,26,27,28,29,30,31,33,34,35,36,37,38,39,41,42,43,44,45,46,47,49,50,51,52,53,54,55,57,58,59,60,61,62,63:{
					if(TornadoWarningIssued && IsClientInGame(i)){
						PrintHintText(i, "Bomb Status: %i/%i || Sacrifice Points: %i/%i \nCurrent song: %s \n\nA TORNADO WARNING HAS BEEN ISSUED...", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
						StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");	
					}
					else if(IsClientInGame(i)){
						PrintHintText(i, "Bomb Status: %i/%i || Sacrifice Points: %i/%i \nCurrent song: %s", bombStatus, bombStatusMax, sacPoints, sacPointsMax, songName);
						StopSound(i, SNDCHAN_STATIC, "UI/hint.wav");
					}
				}
			}
    	}
	}
	return Plugin_Stop;
}
//Background Music System
public Action RefireDefBGM1(Handle timer)
{
	if (!isWave){
        SelectBGM();
        PrintToServer("RefireBGM1!");
        return Plugin_Stop;
	}
	return Plugin_Stop;
}

public Action RefireDefBGM2(Handle timer)
{
	if (!isWave){
        SelectBGM();
        PrintToServer("RefireBGM2!");
        return Plugin_Stop;
	}
	return Plugin_Stop;
}

public Action RefireBGM1(Handle timer)
{
	if (!bgmlock1){
		StopCurSong();
		CustomSoundEmitter(BGM1, BGMSNDLVL);
		curSong = BGM1;
		songName = BGM1Title;
		CreateTimer(BGM1Dur, RefireBGM1);
	}
	return Plugin_Stop;
}

public Action RefireBGM2(Handle timer)
{
	if (!bgmlock2){
		StopCurSong();
		CustomSoundEmitter(BGM2, BGMSNDLVL);
		curSong = BGM2;
		songName = BGM2Title;
		CreateTimer(BGM2Dur, RefireBGM2);
	}
	return Plugin_Stop;
}

public Action RefireBGM3(Handle timer)
{
	if (!bgmlock3 && !crusader){
		StopCurSong();
		CustomSoundEmitter(BGM3, BGMSNDLVL);
		curSong = BGM3;
		songName = BGM3Title;
		CreateTimer(BGM3Dur, RefireBGM3);
	}
	return Plugin_Stop;
}

public Action RefireBGM4(Handle timer)
{
	if (!bgmlock4){
		StopCurSong();
		CustomSoundEmitter(BGM4, BGMSNDLVL);
		curSong = BGM4;
		songName = BGM4Title;
		CreateTimer(BGM4Dur, RefireBGM4);
	}
	return Plugin_Stop;
}

public Action RefireBGM5(Handle timer)
{
	if (!bgmlock5 && !crusader){
		StopCurSong();
		CustomSoundEmitter(BGM5, BGMSNDLVL);
		curSong = BGM5;
		songName = BGM5Title;
		CreateTimer(BGM5Dur, RefireBGM5);
	}
	return Plugin_Stop;
}

public Action RefireBGM6(Handle timer)
{
	if (!bgmlock6){
		StopCurSong();
		CustomSoundEmitter(BGM6, BGMSNDLVL);
		curSong = BGM6;
		songName = BGM6Title;
		CreateTimer(BGM6Dur, RefireBGM6);
	}
	return Plugin_Stop;
}

public Action RefireBGM7(Handle timer){
	if (!bgmlock7){
		StopCurSong();
		CustomSoundEmitter(BGM7, BGMSNDLVL);
		curSong = BGM7;
		songName = BGM7Title;
		CreateTimer(BGM7Dur, RefireBGM7);
	}
	return Plugin_Stop;
}

public Action RefireBGM8(Handle timer){
	if (!bgmlock8){
		StopCurSong();
		CustomSoundEmitter(BGM8, BGMSNDLVL);
		curSong = BGM8;
		songName = BGM8Title;
		CreateTimer(BGM8Dur, RefireBGM8);
	}
	return Plugin_Stop;
}

//Wrote our own sound processor, this should make handling sounds easier.
public Action CustomSoundEmitter(char[] sndName, int SNDLVL){
	for (int i = 1; i <= MaxClients; i++)
	{
		//If it's music
		if(IsClientInGame(i) && !IsFakeClient(i) && (soundPreference[i] == 1 || soundPreference[i] == 3) && (StrContains(sndName, "BGM"))){
			EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, _, _, _, _, _, _, _, _);
		}
		//If it's sound effects
		else if(IsClientInGame(i) && !IsFakeClient(i) && (soundPreference[i] == 2 || soundPreference[i] == 3) && (!StrContains(sndName, "BGM"))){
			EmitSoundToClient(i, sndName, _, SNDCHAN, SNDLVL, _, _, _, _, _, _, _, _);
		}
	}
	return Plugin_Handled;
}
//Brute Justice Timer
public Action OnslaughterATK(Handle timer){
	if (!onslaughter){
		return Plugin_Stop;
	}
	else{
		float f = GetRandomFloat(5.0, 7.0);
		CreateTimer(f, OnslaughterATK);
		FireEntityInput("BruteJusticeDefaultATK", "FireMultiple", "3", 5.0);
		int i = GetRandomInt(1,10);
		switch(i){
			case 1,6:{
				FireEntityInput("BruteJusticeLaserParticle", "Start", "", 0.0);
				EmitSoundToAll(OnslaughterLaserSND);
				FireEntityInput("BruteJusticeLaser", "TurnOn", "", 1.40);
				FireEntityInput("BruteJusticeLaserHurtAOE", "Enable", "", 1.40);
				FireEntityInput("BruteJusticeLaserParticle", "Stop", "", 3.00);
				FireEntityInput("BruteJusticeLaser", "TurnOff", "", 3.25);
				FireEntityInput("BruteJusticeLaserHurtAOE", "Disable", "", 3.25);
			}
			case 2,8:{
				FireEntityInput("BruteJustice", "FireUser1", "", 0.0);
			}
			case 3,7:{
				FireEntityInput("BruteJusticeFlameParticle", "Start", "", 0.0);
				FireEntityInput("BruteJusticeFlamethrowerHurtAOE", "Enable", "", 0.0);
				EmitSoundToAll(OnslaughterFlamePreATK);
				FireEntityInput("SND.BruteJusticeFlameATK", "PlaySound", "", 1.25);
				FireEntityInput("BruteJusticeFlamethrowerHurtAOE", "Disable", "", 5.0);
				FireEntityInput("BruteJusticeFlameParticle", "Stop", "", 5.0);
				FireEntityInput("SND.BruteJusticeFlameATK", "FadeOut", ".25", 5.0);
				CreateTimer(5.0, OnslaughterFlamePostATKSND);
				FireEntityInput("SND.BruteJusticeFlameATK", "StopSound", "", 5.10);
			}
			case 4:{
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 0.0);
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 3.0);
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "10", 5.0);
			}
			case 5:{
				FireEntityInput("BruteJusticeGrenadeSpammer", "FireMultiple", "50", 0.0);
			}
			case 9:{
				FireEntityInput("BruteJusticeRocketSpammer", "FireOnce", "", 0.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireOnce", "", 5.00);
			}
			case 10:{
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 0.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 3.00);
				FireEntityInput("BruteJusticeRocketSpammer", "FireMultiple", "10", 5.00);
			}
		}
	}
	return Plugin_Stop;
}

//Onslaughter Post FlameATK
public Action OnslaughterFlamePostATKSND(Handle timer){
	EmitSoundToAll(OnslaughterFlamePostATK);
	return Plugin_Stop;
}

//Shark Timer
public Action SharkTimer(Handle timer){
	if (canSENTShark){
		FireEntityInput("SentSharkTorpedo", "ForceSpawn", "", 0.0);
		float f = GetRandomFloat(2.0, 5.0);
		CreateTimer(f, SharkTimer);
		int i = GetRandomInt(1, 8);
		switch(i){
			case 1:{
				EmitSoundToAll(SHARKSND01);
			}
			case 2:{
				EmitSoundToAll(SHARKSND02);
			}
			case 3:{
				EmitSoundToAll(SHARKSND03);
			}
			case 4:{
				EmitSoundToAll(SHARKSND04);
			}
			case 5:{
				EmitSoundToAll(SHARKSND05);
			}
			case 6:{
				EmitSoundToAll(SHARKSND06);
			}
			case 7:{
				EmitSoundToAll(SHARKSND07);
			}
			case 8:{
				EmitSoundToAll(SHARKSND08);
			}
		}
		return Plugin_Handled;
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
		float x = f - 30.0;
		CreateTimer (x, TornadoWarning);
		CreateTimer(f, SpawnTornado);
	}
	return Plugin_Stop;
}
//Tornado Warning in Effect!
public Action TornadoWarning(Handle timer){
	if(isWave && canTornado){
		EmitSoundToAll("mvm/ambient_mp3/mvm_siren.mp3"),
		TornadoWarningIssued = true;
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
	TornadoWarningIssued = false;
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
		FireEntityInput("tornadobutton", "Unlock", "", 30.0);
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
	if(isWave){
		int i = GetRandomInt(1, 6);
		switch (i){
			case 1:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.Goobbue", "Enable", "", 0.1),
				PrintToChatAll("\x070000AA Legend tells of a Goobbue sproutling somewhere nearby...");
			}
			case 2:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.Waffle", "Enable", "", 0.1),
				PrintToChatAll("\x0700A0A0Don't eat THESE...");
			}
			case 3:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.Burrito", "Enable", "", 0.1),
				PrintToChatAll("\x07A00000What's worse than Taco Bell?");
			}
			case 4:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.Shroom", "Enable", "", 0.1),
				PrintToChatAll("\x07DD0000M\x07FFFFFFA\x07DD0000R\x07FFFFFFI\x07DD0000O\x07FFFFFF time!");
			}
			case 5:{
				FireEntityInput("Spec*", "Disable", "", 0.0),
				FireEntityInput("Spec.BlueBall", "Enable", "", 0.1),
				PrintToChatAll("A \x070000AA Blue Ball \x07FFFFFF lurks from afar...");
			}
			case 6:{
				FireEntityInput("Spec*", "Enable", "", 0.0),
				PrintToChatAll("\x07AA00AAIs it a miracle? Is it  chaos? WHO KNOWWWWWWS");
			}
		}
		float spDelay = GetRandomFloat(10.0, 30.0);
		CreateTimer(spDelay, SpecTimer);
	}
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
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55A \x07FF0000TORNADO WARNING \x0700AA55has been issued! Take cover \x07AA0000NOW\x07FFFFFF.");
	return Plugin_Stop;
}

//CRUSADERATTACKTimer for Crusader
public Action CRUSADERATTACKTimer(Handle timer){
	EmitSoundToAll(CRUSADERATTACK);
	return Plugin_Handled;
}

//Crusader Incoming Timer for Crusader
public Action CRUSADERINCOMING(Handle timer){
	if(!crusader || INCOMINGDISPLAYED>17){
		INCOMINGDISPLAYED = 0;
		return Plugin_Stop;
	}
	else{
		INCOMINGDISPLAYED++;
		FireEntityInput("FB.INCOMING", "Display", "", 0.0);
		CreateTimer(1.75, CRUSADERINCOMING);
	}
	return Plugin_Stop;
}
//WTFBOOMTimer for Crusader
public Action WTFBOOMTimer(Handle timer){
	EmitSoundToAll(WTFBOOM);
	return Plugin_Handled;
}
//Hindenburg timer
public Action HINDENBURGBOOMTimer(Handle timer){
	EmitSoundToAll(HINDENBURGBOOM);
	return Plugin_Stop;
}
//INCOMING TIMER
public Action INCOMINGTimer(Handle timer){
	EmitSoundToAll(INCOMING);
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
	}
	return Plugin_Stop;
}

//Track bombStatus and update entities every 0.1 seconds
public Action BombStatusUpdater(Handle timer){
	if (isWave){
		CreateTimer(0.1, BombStatusUpdater);
		if (bombStatus<bombStatusMax){
			switch (bombStatus){
				case 8:{
					bombStatusMax = 8;
					explodeType = 1;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					FireEntityInput("Bombs.FreedomBomb", "Enable", "", 0.0),
					EmitSoundToAll(TRIGGERSCORE),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000FREEDOM BOMB \x0700AA55is now available for deployment!");
				}
				case 16:{
					bombStatusMax = 16;
					explodeType = 2;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.ElonBust", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					EmitSoundToAll(TRIGGERSCORE),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000ELON BUST \x0700AA55is now available for deployment!");
				}
				case 24:{
					bombStatusMax = 24;
					explodeType = 3;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.BathSalts", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					EmitSoundToAll(TRIGGERSCORE),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000BATH SALTS \x0700AA55are now available for deployment!");
				}
				case 32:{
					bombStatusMax = 32;
					explodeType = 4;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.FallingStar", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					EmitSoundToAll(TRIGGERSCORE),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FFFF00FALLING STAR\x0700AA55 is now available for deployment!");
				}
				case 40:{
					bombStatusMax = 40;
					explodeType = 5;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.MajorKong", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					EmitSoundToAll(TRIGGERSCORE),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000MAJOR KONG \x0700AA55is now available for deployment!");
				}
				case 48:{
					bombStatusMax = 48;
					explodeType = 6;
					canSENTShark = true;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.SharkTorpedo", "Enable", "", 0.0),
					FireEntityInput("BombExploShark", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					EmitSoundToAll(TRIGGERSCORE),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x0700FFFFSHARK \x0700AA55is now available for deployment!");
				}
				case 56:{
					bombStatusMax = 56;
					explodeType = 7;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.FatMan", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					EmitSoundToAll(TRIGGERSCORE),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000FAT MAN \x0700AA55is now available for deployment!");
				}
				case 64:{
					bombStatusMax = 64;
					explodeType = 8;
					canSENTShark = false;
					FireEntityInput("Bombs*", "Disable", "", 0.0),
					FireEntityInput("BombExplo*", "Disable", "", 0.0),
					FireEntityInput("Bombs.Hydrogen", "Enable", "", 0.0),
					FireEntityInput("Delivery", "Unlock", "", 0.0),
					EmitSoundToAll(TRIGGERSCORE),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000HYDROGEN \x0700AA55is now available for deployment!");
				}
			}
		}
		else if (bombStatus>bombStatusMax)
		{
			bombStatus = bombStatusMax-4;
		}
		return Plugin_Continue;
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
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Color", "0", 0.0);
			}
			case 20,21,22,23,24,25,26,27,28,29:{
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Color", "0", 0.0);
			}
			case 30,31,32,33,34,35,36,37,38,39:{
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Color", "0", 0.0);
			}
			case 40,41,42,43,44,45,46,47,48,49:{
				FireEntityInput("BTN.Sacrificial01", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial01", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial02", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial03", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial04", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial05", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Color", "0", 0.0);
			}
			case 50,51,52,53,54,55,56,57,58,59:{
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
				FireEntityInput("BTN.Sacrificial06", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial06", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Color", "0", 0.0);
			}
			case 60,61,62,63,64,65,66,67,68,69:{
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
				FireEntityInput("BTN.Sacrificial07", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial07", "Color", "0", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Color", "0", 0.0);
			}
			case 70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99:{
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
				FireEntityInput("BTN.Sacrificial07", "Color", "0 255 0", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Lock", "", 0.0),
				FireEntityInput("BTN.Sacrificial10", "Color", "0", 0.0);
			}
			case 100:{
				FireEntityInput("BTN.Sacrificial*", "Unlock", "", 0.0),
				FireEntityInput("BTN.Sacrificial*", "Color", "0 255 0", 0.0);
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
	PrintToChat(client, "The current song is: %s", songName);
	return Plugin_Handled;
}

//Tell the client the current sacrifice points earned.
public Action Command_FBSacStatus(int client, int args){
	PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55The sacrificial points counter is currently at %i of %i maximum for this wave.", sacPoints, sacPointsMax);
}

//Determine which bomb has been recently pushed and tell the client if a bomb is ready or not.
public Action Command_FBBombStatus(int client, int args){
	PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55The bomb status is currently %i, with a max of %i", bombStatus, bombStatusMax);
	switch(bombStatus){
		case 0,1,2,3,4,5,6,7:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Bombs are \x07FF0000NOT READY\x07FFFFFF!");
		}
		case 8:{
			if(bombProgression){
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team is currently pushing a \x07FF0000FREEDOM BOMB \x0700AA55!");
			}
			else{
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000FREEDOM BOMB \x0700AA55is available for deployment!");
			}
		}
		case 9,10,11,12,13,14,15:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Please wait for the next bomb.");
		}
		case 16:{
			if(bombProgression){
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team is currently pushing an \x07FF0000ELON BUST \x0700AA55!");
			}
			else{ 
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Your team's \x07FF0000ELON BUST \x0700AA55is available for deployment!");
			}
		}
		case 17,18,19,20,21,22,23:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFELON BUST \x0700AA55. Please wait for the next bomb.");
		}
		case 24:{
			if(bombProgression){
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team is currently pushing \x07FF0000BATH SALTS \x0700AA55!");
			}
			else{
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFELON BUST \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
			}
		}
		case 25,26,27,28,29,30,31:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Please wait for the next bomb.");
		}
		case 32:{
			if(bombProgression){
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team is currently pushing a \x07FF0000FALLING STAR \x0700AA55!");
			}
			else{
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Your team's \x07FF0000FALLING STAR \x0700AA55is available for deployment!");
			}
		}
		case 33,34,35,36,37,38,39:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFALLING STAR \x0700AA55. Please wait for the next bomb.");
		}
		case 40:{
			if(bombProgression){
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team is currently pushing a \x07FF0000MAJOR KONG \x0700AA55!");
			}
			else{
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFFALLING STAR \x0700AA55. Your team's \x07FF0000MAJOR KONG \x0700AA55is available for deployment!");
			}
		}
		case 41,42,43,44,45,46,47:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFMAJOR KONG \x0700AA55. Please wait for the next bomb.");
		}
		case 48:{
			if(bombProgression){
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team is currently pushing a \x07FF0000SHARK \x0700AA55!");
			}
			else{
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFMAJOR KONG \x0700AA55. Your team's \x07FF0000SHARK \x0700AA55is available for deployment!");
			}
		}
		case 49,50,51,52,53,54,55:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFSHARK \x0700AA55. Please wait for the next bomb.");
		}
		case 56:{
			if(bombProgression){
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team is currently pushing a \x07FF0000FAT MAN \x0700AA55!");
			}
			else{
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFSHARK \x0700AA55. Your team's \x07FF0000FAT MAN \x0700AA55is available for deployment!");
			}
		}
		case 57,58,59,60,61,62,63:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFAT MAN \x0700AA55. Please wait for the next bomb.");
		}
		case 64:{
			if(bombProgression){
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team is delivering \x07FFFF00HYDROGEN \x0700AA55!");
			}
			else{
				PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FF0000 FAT MAN \x0700AA55. Your team's \x07FFFF00HYDROGEN \x0700AA55is available for deployment!");
			}
		}
		case 65,66,67,68,69,70,71:{
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFHYDROGEN\x0700AA55. Bombs are automatically reset to preserve the replayable aspect of this game mode.");
		}
		case 72:{
			PrintToChatAll("Something exceeded a maximum value!!! Apparently the bomb status is %i, with a maximum status of %i.", bombStatus, bombStatusMax);
		}
	}
	return Plugin_Handled;
}
//Return the client to spawn
public Action Command_Return(int client, int args){
	if (!IsPlayerAlive(client)){
		ReplyToCommand(client, "\x07AA0000[Core] You must be alive to use this command...");
		return Plugin_Handled;
	}
	else{
		clientID = client;
		char name[128];
		GetClientName(client, name, sizeof(name));
		PrintToChatAll("\x0700AAAA[\x0700FF00CORE\x0700AAAA]\x07FFFFFF Client \x07FF0000%s \x07FFFFFFbegan casting \x07AA00AA/return\x07FFFFFF.", name);
		EmitSoundToAll(RETURNSND);
		CreateTimer(5.0, ReturnClient);
	}
	return Plugin_Handled;
}

public Action ReturnClient(Handle timer){
	TeleportEntity(clientID, Return, NULL_VECTOR, NULL_VECTOR);
	EmitSoundToClient(clientID, RETURNSUCCESS);
}

//Join us on Discord!
public Action Command_Discord(int client, int args){
	PrintToChat(client, "\x0700AAAA[\x0700FF00CORE\x0700AAAA]\x07FFFFFF Our Discord server URL is \x07AA00AAhttps://discord.com/invite/SkHaeMH\x07FFFFFF."),
	ShowMOTDPanel(client, "FireHostRedux Discord", "https://discord.com/invite/SkHaeMH", MOTDPANEL_TYPE_URL);
}
//Deprecated
public Action Command_TBWave01(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 01: Battle On The Big Bridge");
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
					FireEntityInput("FB.BlueKirbTemplate", "ForceSpawn", "", 0.0);
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
						PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, a \x07AA0000METEOR\x07FFFFFF has been spotted coming towards Dovah's Ass!!!"),
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
					PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07AA7000KISSONE'S TRAIN\x07FFFFFF is \x07AA0000INCOMING\x07FFFFFF. Look out!"),
					FireEntityInput("TrainTrain", "TeleportToPathTrack", "TrainTrack01", 0.0),
					FireEntityInput("TrainTrain", "StartForward", "", 0.1);
				}
				case 6,9:{
					canTornado = true,
					CreateTimer(1.0, SpawnTornado);
				}
				case 7,13:{
					PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, a \x07AA0000METEOR SHOWER\x07FFFFFF has been reported from Dovah's Ass!!!");
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
					PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, it's begun to rain \x07AA0000ATOM BOMBS\x07FFFFFF! TAKE COVER!"),
					canSENTNukes = true,
					CreateTimer(1.0, SENTNukeTimer),
					CreateTimer(30.0, DisableSENTNukes);
				}
			}
		}

//Crusader chain command omg this took forever to figure out!
		if ((damagebits & (1 << 9)) && !attacker) //DMG_SONIC
		{
			PrintToChatAll("\x070000AA[\x07AA0000EXTERMINATUS\x070000AA]\x07FFFFFF Client %N has sacrificed themselves with a \x0700AA00correct \x07FFFFFFkey entry! Prepare your anus!", client);
			StopCurSong(),
			crusader = true,
			CreateTimer(25.20, CRUSADERATTACKTimer),
			CreateTimer(63.20, WTFBOOMTimer),
			PrintToServer("Starting Crusader via plugin!"),
			EmitSoundToAll("fartsy/fallingback/bgm.mp3"),
			CreateTimer(1.75, CRUSADERINCOMING),
			FireEntityInput("FB.BOOM", "StopShake", "", 3.0),
			FireEntityInput("FB.CRUSADER", "Enable", "", 25.20),
			FireEntityInput("CrusaderTrain", "StartForward", "", 25.20),
			FireEntityInput("CrusaderLaserBase*", "StartForward", "", 25.20),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.9", 38.0),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.7", 38.60),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.5", 39.20),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.3", 40.40),
			FireEntityInput("CrusaderTrain", "SetSpeed", "0.1", 41.40),
			FireEntityInput("CrusaderTrain", "Stop", "", 42.60),
			FireEntityInput("FB.CrusaderLaserKill01", "Disable", "", 42.60),
			FireEntityInput("FB.CrusaderNukeTimer", "Disable", "", 42.60),
			FireEntityInput("FB.LaserCore", "TurnOn", "", 45.80),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.35", 45.80),
			FireEntityInput("FB.ShakeCore", "StartShake", "", 45.80),
			FireEntityInput("CrusaderSprite", "Color", "255 128 128", 45.80),
			FireEntityInput("FB.ShakeCore", "StopShake", "", 48.80),
			FireEntityInput("FB.LaserInnerMost", "TurnOn", "", 49.20),
			FireEntityInput("FB.ShakeInner", "StartShake", "", 49.20),
			FireEntityInput("CrusaderSprite", "Color", "255 230 230", 49.20),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.35", 50.20),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.45", 50.60),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.55", 51.0),
			FireEntityInput("FB.ShakeInner", "StopShake", "", 52.10),
			FireEntityInput("FB.ShakeInner", "StartShake", "", 52.20),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.45", 54.0),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.4", 54.40),
			FireEntityInput("FB.ShakeInner", "StopShake", "", 55.0),
			FireEntityInput("FB.ShakeInner", "StartShake", "", 55.10),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.75", 57.20),
			FireEntityInput("FB.CrusaderSideLaser", "TurnOn", "", 57.20),
			FireEntityInput("FB.ShakeInner", "StopShake", "", 58.0),
			FireEntityInput("FB.ShakeInner", "StartShake", "", 58.10),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "1", 58.50),
			FireEntityInput("CrusaderLaserBase*", "SetSpeed", "0.75", 60.80),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.65", 61.10),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.55", 61.40),
			FireEntityInput("FB.LaserCore", "TurnOff", "", 61.40),
			FireEntityInput("FB.LaserInnerMost", "TurnOff", "", 61.40),
			FireEntityInput("CrusaderSprite", "Color", "0 0 0", 61.40),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.45", 61.70),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.3", 62.0),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "0.15", 62.30),
			FireEntityInput("FB.CrusaderSideLaser", "TurnOff", "", 62.30),
			FireEntityInput("CrusaderLaserBase*", "Stop", "", 62.70),
			FireEntityInput("FB.Laser*", "TurnOn", "", 65.20),
			FireEntityInput("CrusaderLaserBase*", "StartForward", "", 65.20),
			FireEntityInput("CrusaderLaserBase", "SetSpeed", "1", 65.20),
			FireEntityInput("FB.ShakeBOOM", "StartShake", "", 65.20),
			FireEntityInput("FB.Fade", "Fade", "", 65.20),
			FireEntityInput("FB.CrusaderLaserKill02", "Enabled", "", 65.20),
			FireEntityInput("FB.CrusaderSideLaser", "TurnOn", "", 65.20),
			FireEntityInput("CrusaderSprite", "Color", "255 230 255", 65.20),
			FireEntityInput("FB.Laser*", "TurnOff", "", 70.0),
			FireEntityInput("CrusaderTrain", "StartForward", "", 70.0),
			FireEntityInput("CrusaderLaserBase*", "Stop", "", 70.0),
			FireEntityInput("FB.LaserKill02", "Disable", "", 70.0),
			FireEntityInput("FB.CrusaderSideLaser", "TurnOff", "", 70.0),
			FireEntityInput("CrusaderSprite", "Color", "0 0 0", 70.0),
			FireEntityInput("FB.ShakeBOOM", "StopShake", "", 70.20),
			FireEntityInput("CrusaderTrain", "Stop", "", 80.0),
			FireEntityInput("FB.CRUSADER", "Disable", "", 80.0);
			crusader = false;
			CreateTimer(80.0, NextWaveTimer); //Jump to next wave
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
    explodeType = 0;
    SelectBGM();
    CreateTimer(1.0, PerformAdverts);
    PrintToChatAll("\x0700FF00[CORE] \x07FFFFFFYou've defeated the wave!");
    FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0),
    FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
    FireEntityInput("Barricade_Rebuild_Relay", "Trigger", "", 0.0);
    FireEntityInput("OldSpawn", "Disable", "", 0.0);
    FireEntityInput("NewSpawn", "Enable", "", 0.0);
    FireEntityInput("dovahsassprefer", "Disable", "", 0.0);
    FireEntityInput("bombpath_left_arrows", "Disable", "", 0.0);
    FireEntityInput("bombpath_right_arrows", "Disable", "", 0.0);
    FireEntityInput("rain", "Alpha", "0", 0.0);
    ChooseBombPath();
    SelectAdmin();
    CreateTimer(40.0, SelectAdminTimer);
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
    explodeType = 0;
    SelectBGM();
    CreateTimer(1.0, PerformAdverts);
    FireEntityInput("rain", "Alpha", "0", 0.0);
    PrintToChatAll("\x0700FF00[CORE] \x07FFFFFFWave \x07FF0000failed\x07FFFFFF successfully!");
    FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0),
    FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
    FireEntityInput("BTN.Sacrificial*", "Disable", "", 0.0),
    FireEntityInput("BTN.Sacrificial*", "Color", "0", 0.0);
    FireEntityInput("Barricade_Rebuild_Relay", "Trigger", "", 0.0);
    FireEntityInput("OldSpawn", "Disable", "", 0.0);
    FireEntityInput("NewSpawn", "Enable", "", 0.0);
    FireEntityInput("dovahsassprefer", "Disable", "", 0.0);
    FireEntityInput("bombpath_left_arrows", "Disable", "", 0.0);
    FireEntityInput("bombpath_right_arrows", "Disable", "", 0.0);
    FireEntityInput("rain", "Alpha", "0", 0.0);
    ChooseBombPath();
    SelectAdmin();
    CreateTimer(40.0, SelectAdminTimer);
}
//Announce the bomb has been reset by client %N.
public Action EventReset(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast)
{
	char clientName[64];
	int client = Spawn_Event.GetInt("player");
	if (client <= MaxClients && IsClientInGame(client))
    {
		GetClientName(client, clientName, sizeof(client));
		PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Client \x0700AA00%s\x07FFFFFF has reset the ass!", clientName);
	}
	return Plugin_Handled;
}

//Waves
public Action GetWave(int args){
	int ent = FindEntityByClassname(-1, "tf_objective_resource");
	if(ent == -1){
		LogMessage("tf_objective_resource not found");
		return;
	}

	int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
	switch (current_wave){
		case 1:{
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
			bombStatusMax = 10;
			sacPointsMax = 90;
			songName = BGM1Title;
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 1: \x0700AA00%s", BGM1Title);
			StopCurSong();
			CreateTimer(2.5, PerformWaveAdverts);
			CustomSoundEmitter(BGM1, BGMSNDLVL);
			curSong = BGM1;
			CreateTimer(BGM1Dur, RefireBGM1);
			CreateTimer(1.0, BombStatusAddTimer);
			CreateTimer(0.1, BombStatusUpdater);
			CreateTimer(1.0, RobotLaunchTimer);
			CreateTimer(1.0, SacrificePointsTimer);
			CreateTimer(1.0, SacrificePointsUpdater);
			CreateTimer(1.0, RefireStorm);
			FireEntityInput("rain", "Alpha", "200", 0.0);
			FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0);
			FireEntityInput("OldSpawn", "Enable", "", 0.0);
			FireEntityInput("NewSpawn", "Disable", "", 0.0);
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1);
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1);
			SelectAdmin();
			ChooseBombPath();
			ActivateTornadoTimer();
			float hwn = GetRandomFloat(HWNMin, HWNMax);
			CreateTimer(hwn, HWBosses);
		}
		case 2:{
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
			bombStatusMax = 18;
			sacPointsMax = 90;
			songName = BGM2Title;
			CreateTimer(2.5, PerformWaveAdverts);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 2: \x0700AA00%s", BGM2Title);
			StopCurSong();
			CustomSoundEmitter(BGM2, BGMSNDLVL);
			curSong = BGM2;
			CreateTimer(BGM2Dur, RefireBGM2);
			CreateTimer(1.0, BombStatusAddTimer);
			CreateTimer(0.1, BombStatusUpdater);
			CreateTimer(1.0, RobotLaunchTimer);
			CreateTimer(1.0, SacrificePointsTimer);
			CreateTimer(1.0, SacrificePointsUpdater);
			CreateTimer(1.0, RefireStorm);
			FireEntityInput("rain", "Alpha", "200", 0.0);
			FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
			FireEntityInput("OldSpawn", "Enable", "", 0.0);
			FireEntityInput("NewSpawn", "Disable", "", 0.0);
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1);
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1);
			SelectAdmin();
			ChooseBombPath();
			ActivateTornadoTimer();
			float hwn = GetRandomFloat(HWNMin, HWNMax);
			CreateTimer(hwn, HWBosses);
		}
		case 3:{
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
			bombStatusMax = 26;
			sacPointsMax = 90;
			songName = BGM3Title;
			CreateTimer(2.5, PerformWaveAdverts);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 3: \x0700AA00%s", BGM3Title);
			StopCurSong();
			CustomSoundEmitter(BGM3, BGMSNDLVL);
			curSong = BGM3;
			CreateTimer(BGM3Dur, RefireBGM3);
			CreateTimer(1.0, BombStatusAddTimer);
			CreateTimer(0.1, BombStatusUpdater);
			CreateTimer(1.0, RobotLaunchTimer);
			CreateTimer(1.0, SacrificePointsTimer);
			CreateTimer(1.0, SacrificePointsUpdater);
			CreateTimer(1.0, RefireStorm);
			FireEntityInput("rain", "Alpha", "200", 0.0);
			FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
			FireEntityInput("OldSpawn", "Enable", "", 0.0);
			FireEntityInput("NewSpawn", "Disable", "", 0.0);
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1);
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1);
			SelectAdmin();
			ChooseBombPath();
			ActivateTornadoTimer();
			float f = GetRandomFloat(60.0, 180.0);
			CreateTimer(f, UnlockTimer);
			float hwn = GetRandomFloat(HWNMin, HWNMax);
			CreateTimer(hwn, HWBosses);
		}
		case 4:{
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
			bombStatusMax = 34;
			sacPointsMax = 90;
			songName = BGM4Title;
			CreateTimer(2.5, PerformWaveAdverts);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 4: \x0700AA00%s", BGM4Title);
			StopCurSong();
			CustomSoundEmitter(BGM4, BGMSNDLVL);
			curSong = BGM4;
			CreateTimer(BGM4Dur, RefireBGM4);
			CreateTimer(1.0, BombStatusAddTimer);
			CreateTimer(0.1, BombStatusUpdater);
			CreateTimer(1.0, RobotLaunchTimer);
			CreateTimer(1.0, SacrificePointsTimer);
			CreateTimer(1.0, SacrificePointsUpdater);
			CreateTimer(1.0, RefireStorm);
			FireEntityInput("rain", "Alpha", "200", 0.0);
			FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
			FireEntityInput("OldSpawn", "Enable", "", 0.0);
			FireEntityInput("NewSpawn", "Disable", "", 0.0);
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1);
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1);
			SelectAdmin();
			ChooseBombPath();
			ActivateTornadoTimer();
			float hwn = GetRandomFloat(HWNMin, HWNMax);
			CreateTimer(hwn, HWBosses);
		}
		case 5:{
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
			bombStatusMax = 42;
			sacPointsMax = 100;
			songName = BGM5Title;
			CreateTimer(2.5, PerformWaveAdverts);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 5: \x0700AA00%s", BGM5Title);
			StopCurSong();
			CustomSoundEmitter(BGM5, BGMSNDLVL);
			curSong = BGM5;
			CreateTimer(BGM5Dur, RefireBGM5);
			CreateTimer(1.0, BombStatusAddTimer);
			CreateTimer(0.1, BombStatusUpdater);
			CreateTimer(1.0, RobotLaunchTimer);
			CreateTimer(1.0, SacrificePointsTimer);
			CreateTimer(1.0, SacrificePointsUpdater);
			CreateTimer(1.0, RefireStorm);
			FireEntityInput("rain", "Alpha", "200", 0.0);
			FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
			FireEntityInput("OldSpawn", "Enable", "", 0.0);
			FireEntityInput("NewSpawn", "Disable", "", 0.0);
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1);
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1);
			FireEntityInput("w5_engie_hints", "Trigger", "", 3.0);
			onslaughter = true;
			FireEntityInput("FB.BruteJustice", "Enable", "", 3.0);
			FireEntityInput("FB.BruteJusticeTrain", "StartForward", "", 3.0);
			CreateTimer(5.0, OnslaughterATK);
			FireEntityInput("FB.BruteJusticeParticles", "Start", "", 3.0);
			FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 3.0);
			FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 4.0);
			FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 5.0);
			FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 6.0);
			FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 7.0);
			FireEntityInput("tank_boss", "AddOutput", "rendermode 10", 8.0);
			SelectAdmin();
			ChooseBombPath();
			ActivateTornadoTimer();
			float f = GetRandomFloat(60.0, 180.0);
			CreateTimer(f, UnlockTimer);
			float hwn = GetRandomFloat(HWNMin, HWNMax);
			CreateTimer(hwn, HWBosses);
		}
		case 6:{
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
			bombStatusMax = 50;
			sacPointsMax = 100;
			songName = BGM6Title;
			CreateTimer(2.5, PerformWaveAdverts);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 6: \x0700AA00%s", BGM6Title);
			StopCurSong();
			CustomSoundEmitter(BGM6, BGMSNDLVL);
			curSong = BGM6;
			CreateTimer(BGM6Dur, RefireBGM6);
			CreateTimer(1.0, BombStatusAddTimer);
			CreateTimer(0.1, BombStatusUpdater);
			CreateTimer(1.0, RobotLaunchTimer);
			CreateTimer(1.0, SacrificePointsTimer);
			CreateTimer(1.0, SacrificePointsUpdater);
			CreateTimer(1.0, RefireStorm);
			FireEntityInput("rain", "Alpha", "200", 0.0);
			FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
			FireEntityInput("OldSpawn", "Enable", "", 0.0);
			FireEntityInput("NewSpawn", "Disable", "", 0.0);
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1);
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1);
			SelectAdmin();
			ChooseBombPath();
			ActivateTornadoTimer();
			float hwn = GetRandomFloat(HWNMin, HWNMax);
			CreateTimer(hwn, HWBosses);
		}
		case 7:{
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
			bombStatusMax = 58;
			sacPointsMax = 100;
			songName = BGM7Title;
			CreateTimer(2.5, PerformWaveAdverts);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 7: \x0700AA00%s", BGM7Title);
			StopCurSong();
			CustomSoundEmitter(BGM7, BGMSNDLVL);
			curSong = BGM7;
			CreateTimer(BGM7Dur, RefireBGM7);
			CreateTimer(1.0, BombStatusAddTimer);
			CreateTimer(0.1, BombStatusUpdater);
			CreateTimer(1.0, RobotLaunchTimer);
			CreateTimer(1.0, SacrificePointsTimer);
			CreateTimer(1.0, SacrificePointsUpdater);
			CreateTimer(1.0, RefireStorm);
			FireEntityInput("rain", "Alpha", "200", 0.0);
			FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
			FireEntityInput("OldSpawn", "Enable", "", 0.0);
			FireEntityInput("NewSpawn", "Disable", "", 0.0);
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1);
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1);
			FireEntityInput("w5_engie_hints", "Trigger", "", 3.0);
			SelectAdmin();
			ChooseBombPath();
			ActivateTornadoTimer();
			float hwn = GetRandomFloat(HWNMin, HWNMax);
			CreateTimer(hwn, HWBosses);
		}
		case 8:{
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
			bombStatusMax = 66;
			sacPointsMax = 100;
			songName = BGM8Title;
			CreateTimer(2.5, PerformWaveAdverts);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 8: \x0700AA00%s", BGM8Title);
			StopCurSong();
			CustomSoundEmitter(BGM8, BGMSNDLVL);
			curSong = BGM8;
			CreateTimer(BGM8Dur, RefireBGM8);
			CreateTimer(1.0, BombStatusAddTimer);
			CreateTimer(0.1, BombStatusUpdater);
			CreateTimer(1.0, RobotLaunchTimer);
			CreateTimer(1.0, SacrificePointsTimer);
			CreateTimer(1.0, SacrificePointsUpdater);
			CreateTimer(1.0, RefireStorm);
			FireEntityInput("rain", "Alpha", "200", 0.0);
			FireEntityInput("Classic_Mode_Intel1", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel2", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel3", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel4", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel5", "Enable", "", 0.0);
			FireEntityInput("Classic_Mode_Intel6", "Enable", "", 0.0);
			FireEntityInput("OldSpawn", "Enable", "", 0.0);
			FireEntityInput("NewSpawn", "Disable", "", 0.0);
			FireEntityInput("bombpath_right_arrows", "Disable", "", 0.1);
			FireEntityInput("bombpath_left_arrows", "Disable", "", 0.1);
			SelectAdmin();
			ChooseBombPath();
			ActivateTornadoTimer();
			float hwn = GetRandomFloat(HWNMin, HWNMax);
			CreateTimer(hwn, HWBosses);
		}
	}
	return;
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
//NextWaveTimer
public Action NextWaveTimer(Handle timer){
	if (isWave){
		ServerCommand("fb_operator 99");
	}
	else{
		return Plugin_Stop;
	}
	return Plugin_Stop;
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
	//PrintToChatAll("\x0700FF00[CORE] \x07FFFFFF Firing entity %s with input %s , a parameter override of %s , and delay of %f ...", strTargetname, strInput, strParameter, flDelay);
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

//Choose Bomb Path
public Action ChooseBombPath(){
	FireEntityInput("Nest_EN060", "Disable", "", 0.0),
	FireEntityInput("Nest_EN050", "Disable", "", 0.0),
	FireEntityInput("Nest_EN040", "Disable", "", 0.0),
	FireEntityInput("Nest_EN030", "Disable", "", 0.0),
	FireEntityInput("Nest_EN020", "Disable", "", 0.0),
	FireEntityInput("Nest_EN010", "Disable", "", 0.0),
	FireEntityInput("Nest_L050", "Disable", "", 0.0),
	FireEntityInput("Nest_L040", "Disable", "", 0.0),
	FireEntityInput("Nest_L030", "Disable", "", 0.0),
	FireEntityInput("Nest_L020", "Disable", "", 0.0),
	FireEntityInput("Nest_L010", "Disable", "", 0.0),
	FireEntityInput("Nest_R040", "Disable", "", 0.0),
	FireEntityInput("Nest_R030", "Disable", "", 0.0),
	FireEntityInput("Nest_R020", "Disable", "", 0.0),
	FireEntityInput("Nest_R010", "Disable", "", 0.0),
	FireEntityInput("bombpath_right_prefer_flankers", "Disable", "", 0.0),
	FireEntityInput("bombpath_left_prefer_flankers", "Disable", "", 0.0),
	FireEntityInput("bombpath_left_navavoid", "Disable", "", 0.0),
	FireEntityInput("bombpath_right_navavoid", "Disable", "", 0.0),
	FireEntityInput("bombpath_right_arrows", "Disable", "", 0.0),
	FireEntityInput("bombpath_left_arrows", "Disable", "", 0.0);
	int i = GetRandomInt(1, 3);
	switch(i){
		case 1:{
			FireEntityInput("Nest_R040", "Enable", "", 0.25),
			FireEntityInput("Nest_R030", "Enable", "", 0.25),
			FireEntityInput("Nest_R020", "Enable", "", 0.25),
			FireEntityInput("Nest_R010", "Enable", "", 0.25),
			FireEntityInput("bombpath_right_prefer_flankers", "Enable", "", 0.25),
			FireEntityInput("bombpath_right_navavoid", "Enable", "", 0.25),
			FireEntityInput("bombpath_right_arrows", "Enable", "", 0.25);
		}
		case 2:{
			FireEntityInput("Nest_L050", "Enable", "", 0.25),
			FireEntityInput("Nest_L040", "Enable", "", 0.25),
			FireEntityInput("Nest_L030", "Enable", "", 0.25),
			FireEntityInput("Nest_L020", "Enable", "", 0.25),
			FireEntityInput("Nest_L010", "Enable", "", 0.25),
			FireEntityInput("bombpath_left_prefer_flankers", "Enable", "", 0.25),
			FireEntityInput("bombpath_left_navavoid", "Enable", "", 0.25),
			FireEntityInput("bombpath_left_arrows", "Enable", "", 0.25);
		}
		case 3:{
			FireEntityInput("dovahsassprefer", "Enable", "", 0.25),
			FireEntityInput("Nest_R040", "Enable", "", 0.25),
			FireEntityInput("Nest_R030", "Enable", "", 0.25),
			FireEntityInput("Nest_R020", "Enable", "", 0.25),
			FireEntityInput("Nest_R010", "Enable", "", 0.25),
			FireEntityInput("bombpath_right_prefer_flankers", "Enable", "", 0.25),
			FireEntityInput("bombpath_right_navavoid", "Enable", "", 0.25),
			FireEntityInput("bombpath_right_arrows", "Enable", "", 0.25);
		}
	}
}

public Action Command_Operator(int args){
	char arg1[16];
	GetCmdArg(1, arg1, sizeof(arg1));
	int i = StringToInt(arg1);
//	PrintToChatAll("Calling on fb_operator because arg1 was %i, and was stored in memory position %i", i, arg1);
	switch (i){
		//When the map is complete
		case 0:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF YOU HAVE SUCCESSFULLY COMPLETED DOVAH'S ASS ! THE SERVER WILL RESTART IN 10 SECONDS.");
			CreateTimer(10.0, Timer_RestartServer);
		}
		//Get current wave
		case 1:{
			GetWave(0);
		}
		//Prepare yourself!
		case 2:{
            PrintToChatAll("\x070000AA[\x07AAAA00INFO\x070000AA] \x07AA0000DOVAH'S ASS\x07FFFFFF v0x14. Prepare yourself for the unpredictable... [\x0700FF00by TTV/ProfessorFartsalot\x07FFFFFF]");
            FireEntityInput("rain", "Alpha", "0", 0.0);
		}
		//Force Tornado
		case 3:{
			if(isWave && canTornado && !tornado){
				CreateTimer(0.1, SpawnTornado);
				PrintCenterTextAll("OH NOES... PREPARE YOUR ANUS!");
			}
			else{
				PrintToServer("Error spawning manual tornado... Perhaps we are not in a wave, tornadoes are banished, or a tornado has already spawned???");
			}
			return Plugin_Handled;
		}
		//Tornado Sacrifice (+1)
		case 10:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Sacrificed a client into orbit. (\x0700FF00+1 pt\x07FFFFFF)");
			sacPoints++;
			if(bombStatus >= bombStatusMax){
				return Plugin_Handled;
			}
			else{
				bombStatus++;
			}
		}
		//Death pit sacrifice (+1)
		case 11:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Sent a client to their doom. (\x0700FF00+1 pt\x07FFFFFF)");
			sacPoints++;
		}
		//KissoneTM pit sacrifice (+1)
		case 12:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Dunked a client into liquid death. (\x0700FF00+1 pt\x07FFFFFF)");
			sacPoints++;
		}
		//Tank Destroyed (+1), includes hacky method of disabling onslaughter attack system. Just as it was in the original map.
		case 13:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF A tank has been destroyed. (\x0700FF00+1 pt\x07FFFFFF)");
			sacPoints++;
			onslaughter = false;
		}
		//Bomb Reset (+5)
		case 14:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Bomb has been reset. (\x0700FF00+5 pts\x07FFFFFF)");
			sacPoints+=5;
		}
		//Bomb Deployed
		case 15:{
			switch (explodeType){
				//Invalid
				case 0:{
					PrintToServer("Tried to detonate with a bomb size of zero!");
				}
				//Small Explosion
				case 1:{
					EmitSoundToAll(BMB1SND),
					FireEntityInput("SmallExplosion", "Explode", "", 0.0),
					FireEntityInput("SmallExploShake", "StartShake", "", 0.0),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Small Bomb successfully pushed! (\x0700FF00+2 pts\x07FFFFFF)");
					sacPoints+=2,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					EmitSoundToAll(COUNTDOWN);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=2;
					}
				}
				//Medium Explosion
				case 2,3:{
					EmitSoundToAll(BMB2SND),
					FireEntityInput("MediumExplosion", "Explode", "", 0.0),
					FireEntityInput("MedExploShake", "StartShake", "", 0.0),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Medium Bomb successfully pushed! (\x0700FF00+5 pts\x07FFFFFF)");
					sacPoints+=5,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					EmitSoundToAll(COUNTDOWN);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=2;
					}
				}
				//Falling Star
				case 4:{
					canSENTStars = true,
					EmitSoundToAll(BMB2SND),
					FireEntityInput("MediumExplosion", "Explode", "", 0.0),
					FireEntityInput("MedExploShake", "StartShake", "", 0.0),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Average Bomb successfully pushed! (\x0700FF00+10 pts\x07FFFFFF)");
					sacPoints+=10,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					EmitSoundToAll(COUNTDOWN),
					CreateTimer(1.0, SENTStarTimer),
					CreateTimer(60.0, SENTStarDisable);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=2;
					}
				}
				//Major Kong
				case 5:{
					EmitSoundToAll(BMB4SND),
					FireEntityInput("FB.Fade", "Fade", "", 1.7),
					FireEntityInput("LargeExplosion", "Explode", "", 1.7),
					FireEntityInput("LargeExplosionSound", "PlaySound", "", 1.7),
					FireEntityInput("LargeExploShake", "StartShake", "", 1.7),
					FireEntityInput("NukeAll", "Enable", "", 1.7),
					FireEntityInput("NukeAll", "Disable", "", 3.0),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07AA0000 NUCLEAR WARHEAD\x07FFFFFF successfully pushed! (\x0700FF00+25 pts\x07FFFFFF)");
					sacPoints+=25,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					EmitSoundToAll(COUNTDOWN);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=4;
					}
				}
				//Large (shark)
				case 6:{
					EmitSoundToAll(BMB3SND),
					FireEntityInput("LargeExplosion", "Explode", "", 0.0),
					FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Heavy Bomb successfully pushed! (\x0700FF00+15 pts\x07FFFFFF)");
					sacPoints+=15,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					EmitSoundToAll(COUNTDOWN);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=4;
					}
				}
				//FatMan
				case 7:{
					EmitSoundToAll(HINDENBURGBOOM);
					FireEntityInput("LargeExplosion", "Explode", "", 0.0),
					FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
					FireEntityInput("NukeAll", "Enable", "", 0.0),
					FireEntityInput("FB.Fade", "Fade", "", 0.0),
					FireEntityInput("NukeAll", "Disable", "", 3.0),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07AA0000 NUCLEAR WARHEAD\x07FFFFFF successfully pushed! (\x0700FF00+25 pts\x07FFFFFF)");
					sacPoints+=25,
					bombStatusMax+=10,
					CreateTimer(3.0, BombStatusAddTimer);
					CreateTimer(15.0, SpecTimer);
					EmitSoundToAll(COUNTDOWN);
					if(bombStatus>=bombStatusMax){
						return Plugin_Handled;
					}
					else{
						bombStatus+=4;
					}
				}
				//Hydrogen
				case 8:{
					EmitSoundToAll(HINDENBURGBOOM);
					FireEntityInput("LargeExplosion", "Explode", "", 0.0),
					FireEntityInput("LargeExploShake", "StartShake", "", 0.0),
					FireEntityInput("LargeExplosionSND", "PlaySound", "", 0.0),
					FireEntityInput("NukeAll", "Enable", "", 0.0),
					FireEntityInput("FB.Fade", "Fade", "", 0.0),
					FireEntityInput("NukeAll", "Disable", "", 3.0),
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07AA0000 HINDENBURG\x07FFFFFF successfully fueled! (\x0700FF00+30 pts\x07FFFFFF)");
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has delivered Hydrogen! The \x07FF0000HINDENBURG \x0700AA55is now ready for flight!");
					FireEntityInput("DeliveryBurg", "Unlock", "", 0.0);
					bombStatus = 0;
					explodeType = 0;
					CreateTimer(3.0, BombStatusAddTimer);
					EmitSoundToAll(COUNTDOWN);
				}
				//Fartsy of the Seventh Taco Bell
				case 69:{
					FireEntityInput("NukeAll", "Enable", "", 0.0),
					EmitSoundToAll(HINDENBURGBOOM);
					FireEntityInput("FB.Fade", "Fade", "", 0.0),
					FireEntityInput("NukeAll", "Disable", "", 2.0),
					bombStatusMax=64;
					CreateTimer(5.0, NextWaveTimer);
				}
			}
			return Plugin_Handled;
		}
		//Tank deployed its bomb
		case 16:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF A tank has deployed its bomb! (\x0700FF00+1 pt\x07FFFFFF)");
			onslaughter = false;
		}
		//Shark Enable & notify bomb push began
		case 20:{
			bombProgression = true;
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0755AA55Bomb push in progress.");
			CreateTimer(3.0, SharkTimer);
		}
		//Shark Disable
		case 21:{
			bombProgression = false;
			canSENTShark = false;
		}
		//HINDENBOOM ACTIVATION
		case 28:{
			EmitSoundToAll(BOOM);
			FireEntityInput("HindenTrain", "StartForward", "", 0.0);
			FireEntityInput("DeliveryBurg", "Lock", "", 0.0);
			FireEntityInput("Boom", "Enable", "", 0.0);
			FireEntityInput("Bombs.TheHindenburg", "Enable", "", 0.0);
			FireEntityInput("Boom", "Disable", "", 1.0);
		}
		//HINDENBOOM!!!
		case 29:{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF OH GOD, THEY'RE \x07AA0000CRASHING THE HINDENBURG\x07FFFFFF!!!");
			EmitSoundToAll(HINDENCRASH);
			CreateTimer(4.0, INCOMINGTimer);
			CreateTimer(7.0, HINDENBURGBOOMTimer);
			FireEntityInput("LargeExplosion", "Explode", "", 7.0);
			FireEntityInput("LargeExploShake", "StartShake", "", 7.0);
			FireEntityInput("NukeAll", "Enable", "", 7.0);
			FireEntityInput("FB.Fade", "Fade", "", 7.0);
			FireEntityInput("NukeAll", "Disable", "", 9.0);
			FireEntityInput("Bombs.TheHindenburg", "Disable", "", 7.0);
			FireEntityInput("HindenTrain", "TeleportToPathTrack", "Hinden01", 7.0);
			FireEntityInput("HindenTrain", "Stop", "", 7.0);
			CreateTimer(9.0, NextWaveTimer);
			bombStatus = 4;
			bombStatusMax = 8;
			explodeType = 0;
		}
		//Bath Salts spend
		case 30:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF INSTANT BATH SALT DETONATION! BOTS ARE FROZEN FOR 10 SECONDS! (\x07FF0000-10 pts\x07FFFFFF)");
			ServerCommand("sm_freeze @blue 10");
			sacPoints = (sacPoints - 10);
			FireEntityInput("BTN.Sacrificial*", "Color", "0 0 0", 0.0),
			FireEntityInput("BTN.Sacrificial01", "Lock", "", 0.0),
			FireEntityInput("MedExploShake", "StartShake", "", 0.10),
			FireEntityInput("MedExplosionSND", "PlaySound", "", 0.10),
			FireEntityInput("MediumExplosion", "Explode", "", 0.10);
		}
		//Fat man spend
		case 31:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF INSTANT FAT MAN DETONATION! (\x07FF0000-20 pts\x07FFFFFF)");
			sacPoints = (sacPoints - 20);
			FireEntityInput("BTN.Sacrificial*", "Color", "0 0 0", 0.0);
			FireEntityInput("BTN.Sacrificial02", "Lock", "", 0.0);
			FireEntityInput("LargeExplosion", "Explode", "", 0.0);
			FireEntityInput("LargeExploShake", "StartShake", "", 0.0);
			FireEntityInput("NukeAll", "Enable", "", 0.0);
			EmitSoundToAll(HINDENBURGBOOM);
			FireEntityInput("FB.Fade", "Fade", "", 0.0);
			FireEntityInput("NukeAll", "Disable", "", 2.0);
		}
		//Goob/Kirb spend
		case 32:{
			int x = GetRandomInt(1, 2);
			switch (x){
				case 1:{
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF GOOBBUE COMING IN FROM ORBIT! (\x07FF0000-30 pts\x07FFFFFF)");
					sacPoints = (sacPoints - 30);
					EmitSoundToAll(SPEC01);
					CreateTimer(1.5, INCOMINGTimer);
					FireEntityInput("FB.GiantGoobTemplate", "ForceSpawn", "", 3.0);
				}
				case 2:{
					PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF BLUE KIRBY FALLING OUT OF THE SKY! (\x07FF0000-30 pts\x07FFFFFF)");
					sacPoints = (sacPoints - 30);
					FireEntityInput("FB.BlueKirbTemplate", "ForceSpawn", "", 0.0);
					EmitSoundToAll(FALLSND0B);
				}
			}
		}
		//Explosive paradise spend
		case 33:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF We're spending most our lives living in an EXPLOSIVE PARADISE! Robots will be launched into orbit, too! (\x07FF0000-40 pts\x07FFFFFF)");
			EmitSoundToAll(EXPLOSIVEPARADISE);
			FireEntityInput("FB.FadeBLCK", "Fade", "", 0.0);
			ServerCommand("sm_evilrocket @blue");
			FireEntityInput("NukeAll", "Enable", "", 11.50);
			FireEntityInput("HUGEExplosion", "Explode", "", 11.50);
			FireEntityInput("FB.Fade", "Fade", "", 11.50);
			FireEntityInput("FB.ShakeBOOM", "StartShake", "", 11.50);
			FireEntityInput("NukeAll", "Disable", "", 12.30);
			sacPoints = (sacPoints - 40);
		}
		//Ass Gas spend
		case 34:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF NO NO NO, STOP THE SHARTS!!!! (\x07FF0000-40 pts\x07FFFFFF)");
			sacPoints = (sacPoints - 40);
		}
		//Banish tornadoes for the wave
		case 35:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF A PINK KIRBY HAS BANISHED TORNADOES FOR THIS WAVE! (\x07FF0000-50 pts\x07FFFFFF)");
			KillTornado();
			canTornado = false;
			sacPoints = (sacPoints - 50);
		}
		//Nuclear fallout spend
		case 36:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF TOTAL ATOMIC ANNIHILATION. (\x07FF0000-60 pts\x07FFFFFF)");
			sacPoints = (sacPoints - 60);
			canSENTNukes = true;
			CreateTimer(1.0, SENTNukeTimer);
			CreateTimer(45.0, DisableSENTNukes);
		}
		//Meteor shower spend
		case 37:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF COSMIC DEVASTATION IMMINENT. (\x07FF0000-70 pts\x07FFFFFF)");
			sacPoints = (sacPoints - 70);
			canSENTMeteors = true;
			CreateTimer(1.0, SENTMeteorTimer);
			CreateTimer(30.0, DisableSENTMeteors);
		}
		//Fartsy of the Seventh Taco Bell
		case 38:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF NOW PRESENTING... PROFESSOR FARTSALOT OF THE SEVENTH TACO BELL! (\x07FF0000-100 points\x07FFFFFF)");
			sacPoints = (sacPoints - 100);
			explodeType = 69;
			FireEntityInput("Delivery", "Unlock", "", 0.0),
			FireEntityInput("BombExplo*", "Disable", "", 0.0),
			FireEntityInput("Bombs*", "Disable", "", 0.0),
			FireEntityInput("Bombs.Professor", "Enable", "", 3.0);
		}
		//Found blue ball
		case 40:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55What on earth IS that? It appears to be a... \x075050FFBLUE BALL\x07FFFFFF!");
			EmitSoundToAll(FALLSND0B);
			FireEntityInput("FB.BlueKirbTemplate", "ForceSpawn", "", 4.0);
			CreateTimer(4.0, INCOMINGTimer);
		}
		//Found burrito
		case 41:{
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Why would you even eat \x07FF0000The Forbidden Burrito\x07FFFFFF?");
			EmitSoundToAll("vo/sandwicheat09.mp3");// May not need cached?
		}
		//Found goobbue
		case 42:{
			EmitSoundToAll(SPEC01);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55ALL HAIL \x07FF00FFGOOBBUE\x0700AA55!");
			CreateTimer(4.0, INCOMINGTimer);
			FireEntityInput("FB.GiantGoobTemplate", "ForceSpawn", "", 4.0);
		}
		//Found Mario
		case 43:{
			EmitSoundToAll(SPEC02);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Welp, someone is playing \x0700FF00Mario\x07FFFFFF...");
		}
		//Found Waffle
		case 44:{
			EmitSoundToAll(SPEC03);
			PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Oh no, someone has found and (probably) consumed a \x07FF0000WAFFLE OF MASS DESTRUCTION\x07FFFFFF!");
		}
		//Workaround to Emit sounds using map entities without requiring ambient_generic
		//Medium Explosion
		case 51:{
			EmitSoundToAll(BMB3SND);
		}
		case 52:{
			EmitSoundToAll(HINDENBURGBOOM);
		}
		//Prev wave
		case 98:{
			int ent = FindEntityByClassname(-1, "tf_objective_resource");
			if(ent == -1)
			{
				LogMessage("tf_objective_resource not found");
				return Plugin_Handled;
			}

			int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
			int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
			int prev_wave = current_wave - 1;
			if(prev_wave >= max_wave)
			{
				PrintToChatAll("\x07AA0000[ERROR] \x07FFFFFFHOW THE HELL DID WE GET HERE?!");
				return Plugin_Handled;
			}

			if(prev_wave < 1)
			{
				PrintToChatAll("\x07AA0000[ERROR] \x07FFFFFFWE CAN'T JUMP TO WAVE 0, WHY WOULD YOU TRY THAT??");
				return Plugin_Handled;
			}
			JumpToWave(prev_wave);
		}
		//Next wave
		case 99:{
			int ent = FindEntityByClassname(-1, "tf_objective_resource");
			if(ent == -1)
			{
				LogMessage("tf_objective_resource not found");
				return Plugin_Handled;
			}

			int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
			int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
			int next_wave = current_wave + 1;
			if(next_wave > max_wave)
			{
				int flags = GetCommandFlags("tf_mvm_force_victory");
				SetCommandFlags("tf_mvm_force_victory", flags & ~FCVAR_CHEAT);
				ServerCommand("tf_mvm_force_victory 1");
				FakeClientCommand(0, ""); //Not sure why, but this has to be here. Otherwise the specified commands simply refuse to work...
				SetCommandFlags("tf_mvm_force_victory", flags|FCVAR_CHEAT);
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF VICTORY HAS BEEN FORCED! THE SERVER WILL RESTART IN 10 SECONDS.");
				CreateTimer(10.0, Timer_RestartServer);
				return Plugin_Handled;
			}
			JumpToWave(next_wave);
		}
		//Code Entry from FC Keypad
		case 100:{
			if (CodeEntry == 17){
				FireEntityInput("FB.BOOM", "StartShake", "", 0.0),
				EmitSoundToAll(BMB3SND),
				FireEntityInput("FB.CodeCorrectKill", "Enable", "", 0.0),
				FireEntityInput("FB.KP*", "Lock", "", 0.0),
				FireEntityInput("FB.CodeCorrectKill", "Disable", "", 1.0);
			}
			else{
				CodeEntry = 0;
				FireEntityInput("FB.CodeFailedKill", "Enable", "", 0.0),
				FireEntityInput("FB.CodeFailedKill", "Disable", "", 1.0),
				EmitSoundToAll("mvm/mvm_player_died.wav"); // probably also doesnt need cached?
			}
		}
		case 101:{
			CodeEntry++;
		}
		case 102:{
			CodeEntry+=2;
		}
		case 103:{
			CodeEntry+=3;
		}
		case 104:{
			CodeEntry+=4;
		}
		case 105:{
			CodeEntry+=5;
		}
		case 106:{
			CodeEntry+=6;
		}
		case 107:{
			CodeEntry+=7;
		}
		case 108:{
			CodeEntry+=8;
		}
		case 109:{
			CodeEntry+=9;
		}
		//Taco Bell Edition
		case 210:{
			PrintToChatAll("\x070000AA[\x07AAAA00INFO\x070000AA] \x07FFFFFFYou have chosen \x07AA0000DOVAH'S ASS - TACO BELL EDITION\x07FFFFFF. Why... Why would you DO THIS?! Do you not realize what you've just done?????");
		}
		//Taco Bell GetWave
		case 211:{
			//GetTacoBellWave(0);
			PrintToChatAll("WARNING, THIS IS NOT IMPLEMENTED YET. PLEASE DO NOT PLAY TACO BELL EDITION AT THIS POINT IN TIME.");
		}
		//Taco Bell Victory
		case 255:{
			PrintToChatAll("WOWIE YOU DID IT! The server will restart in 30 seconds, prepare to do it again! LULW");
			CreateTimer(30.0, Timer_RestartServer);
		}
	}
	return Plugin_Handled;
}