bool tickOffset = false;
int ticksOffset[] = {
  0, // 0
  0, // 1
  0, // 2
  0, // 3
  429, // 4
  226, // 5
  11, // 6
  1078, // 7
  0, // 8
  0, // 9
  0, // 10
  0, // 11
  0, // 12
  0, // 13
  0, //14
  2753, // 15
  749, // 16
  0,
  0
};
//Silence cvar changes to minimize chat spam.
public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast) {
  event.BroadcastDisabled = true;
  return Plugin_Handled;
}
bool bombReady = false;
char dbgStr[256];
bool defaultCanHWBoss[] = {
  false,
  false,
  true,
  true,
  true,
  true,
  true,
  true,
  true //wave 8
};
bool defaultCanTornado[] = {
  false,
  false,
  true,
  true,
  true,
  true,
  true,
  true,
  true
};
char bombNames[][128] = {
  "", // 0 (This should NEVER be possible under any circumstance)
  "{red}FREEDOM BOMB{white}", // 1
  "{red}ELON BUST{white}", // 2
  "{red}BATH SALTS{white}",
  "{red}FALLING STAR{white}",
  "{red}MAJOR KONG{white}",
  "{red}SHARK{white}",
  "{red}FAT MAN{white}",
  "{red}HYDROGEN{white}"
};

int SNDLVL[] = {
  75, // 0
  75, // 1
  75, // 2
  75, // 3
  75, // 4
  75, // 5
  75, // 6
  75, // 7
  75, // 8
  75, // 9
  75, // 10
  75, // 11
  75, // 12
  75, // 13
  75, // 14
  75, // 15
  75, // 16
  75, // 17
  75 // 18
};
char MusicArray[][64] = {
  "fartsy/music/ffxiv/TheSilentRegardOfStars.wav", // 0
  "fartsy/music/ffxiv/KnowledgeNeverSleeps.wav", // 1
  "fartsy/music/ffxiv/FromMud.wav", // 2
  "fartsy/music/ffxiv/AndLoveYouShallFind.wav", // 3
  "fartsy/music/ffxiv/locus.wav", // 4
  "fartsy/music/ffxiv/metal.wav", // 5
  "fartsy/music/ffxiv/exponentialentropy.wav", // 6
  "fartsy/music/ffxiv/fromtheheavens_loop1.wav", // 7
  "fartsy/music/ffxiv/fromtheheavens_loop2.wav", // 8
  "fartsy/music/ffxiv/fromtheheavens_loop3.wav", // 9
  "fartsy/music/ffxiv/fromtheheavens_loop4.wav", // 10
  "fartsy/music/ffxiv/metalbrutejusticemode.wav", // 11
  "fartsy/music/ffxiv/penitus.wav", // 12
  "fartsy/music/ffxiv/revengetwofold.wav", // 13
  "fartsy/music/ffxiv/landslide.wav", // 14
  "fartsy/music/brawler/onewingedangel.wav", // 15
  "fartsy/music/brawler/xbc2/battle.wav", // 16
  "fartsy/music/brawler/xbc/youwillknowournames.mp3", // 17
  "fartsy/music/demetori/unowen.mp3" // 18
};

char TitleArray[][64] = {
  "Restore Defaults", // 0
  "FFXIV - The Silent Regard of Stars", // 1
  "FFXIV - Knowledge Never Sleeps", // 2
  "FFXIV - From Mud", // 3
  "FFXIV - And Love You Shall Find", // 4
  "FFXIV - Locus", // 5
  "FFXIV - Metal", // 6
  "FFXIV - Exponential Entropy", // 7
  "FFXIV - From the Heavens (P1)", // 8
  "FFXIV - From the Heavens (P2)", // 9
  "FFXIV - From the Heavens (P3)", // 10
  "FFXIV - From the Heavens (P4)", // 11
  "FFXIV - Metal: Brute Justice Mode", // 12
  "FFXIV - Penitus", // 13
  "FFXIV - Revenge Twofold", // 14
  "FFXIV - Landslide", // 15
  "FF Advent Children - One Winged Angel", // 16
  "Xenoblade Chronicles 2 - Battle!!", // 17
  "Xenoblade Chronicles - You Will Know Our Names", // 18
  "Demetori - U.N. Owen Was Her?" // 19
};

int RefireArray[] = {
  9190, // 0
  15690, // 1
  9190, // 2
  10490, // 3
  15270, // 4
  10250, // 5
  11110, // 6
  4250, // 7
  5492, // 8
  3947, // 9
  2508, // 10
  8702, // 11
  28476, // 12
  8805, // 13
  14160, // 14
  20592, // 15
  8120, // 16
  8475, // 17
  19240 // 18
};

char SFXArray[][64] = {
  "fartsy/misc/bell.wav", // 0
  "fartsy/misc/murica.mp3", // 1
  "fartsy/bl2/grenade_detonate.mp3", // 2
  "fartsy/gbombs5/t_12.mp3", // 3
  "fartsy/misc/majorkong.mp3", // 4
  "fartsy/vo/spongebob/boom.mp3", // 5
  "fartsy/misc/countdown.wav", // 6
  "fartsy/misc/fartsyscrusader_attack.mp3", // 7
  "items/cart_warning_single.wav", // 8 (DROPNUKE)
  "fartsy/ffxiv/bossfatejoin.mp3", // 9 (EVENTSTART)
  "fartsy/misc/explosiveparadise.mp3", // 10 (EXPLOSIVEPARADISE)
  "fartsy/vo/l4d2/billfall02.mp3", // 11 (FALLSND01-10)
  "fartsy/vo/l4d2/coachfall02.mp3",// 12
  "fartsy/vo/l4d2/ellisfall01.mp3", // 13
  "fartsy/vo/l4d2/francisfall02.mp3", // 14
  "fartsy/vo/l4d2/louisfall01.mp3", // 15
  "fartsy/vo/l4d2/louisfall03.mp3", // 16
  "fartsy/vo/l4d2/nickfall01.mp3", // 17
  "fartsy/vo/l4d2/zoeyfall01.mp3", // 18
  "fartsy/vo/ddd/woahhh.mp3", // 19
  "fartsy/vo/jigglypuff/jigglypuff.mp3", // 20
  "fartsy/vo/kirby/eeeahhhh.mp3", // 21
  "fartsy/vo/luigi/ohohohohoo.mp3", // 22
  "fartsy/vo/mario/wahahahaha.mp3", // 23
  "fartsy/vo/pika/pikapika.mp3", // 24
  "fartsy/vo/wario/wheee.mp3", // 25
  "fartsy/vo/mario/wowww.mp3", // 26
  "fartsy/weather/thunder1.wav", // 27 (GlobalThunder01-08)
  "fartsy/weather/thunder2.wav", // 28
  "fartsy/weather/thunder3.wav", // 29
  "fartsy/weather/thunder4.wav", // 30
  "fartsy/weather/thunder5.wav", // 31
  "fartsy/weather/thunder6.wav", // 32
  "fartsy/weather/thunder7.wav", // 33
  "fartsy/weather/thunder8.wav", // 34
  "fartsy/gbombs5/tsar_detonate.mp3", // 35 (HINDENBURGBOOM)
  "fartsy/vo/jeffy/hinden.wav", // 36 (HINDENCRASH)
  "fartsy/vo/ddo/koboldincoming.wav", // 37 (INCOMING)
  "fartsy/misc/antimatter.mp3", // 38 (OnslaughterLaserSND)
  "weapons/flame_thrower_start.wav", // 39 OnslaughterFlamePreATK
  "weapons/flame_thrower_end.wav", // 40 OnslaughterFlamePostATK
  "fartsy/ffxiv/return.mp3", // 41 RETURNSND
  "fartsy/ffxiv/returnsuccess.mp3", // 42 RETURNSUCCESS
  "fartsy/memes/babyshark/baby.mp3", // 43 SHARKSND01-08
  "fartsy/memes/babyshark/baby02.mp3", // 44
  "fartsy/memes/babyshark/doot01.mp3", // 45
  "fartsy/memes/babyshark/doot02.mp3", // 46
  "fartsy/memes/babyshark/doot03.mp3", // 47
  "fartsy/memes/babyshark/doot04.mp3", // 48
  "fartsy/memes/babyshark/shark.mp3", // 49
  "fartsy/memes/babyshark/shark02.mp3", // 50
  "fartsy/vo/fartsy/goobbue.mp3", // 51 SPEC01
  "fartsy/misc/shroom.mp3", // 52 SPEC02
  "fartsy/vo/inurat/nuclearwaffle.mp3", // 53 SPEC03
  "fartsy/misc/strongman_bell.wav", // 54 STRONGMAN
  "amongus/emergency.mp3", // 55 SUS
  "fartsy/misc/triggerscore.wav", // 56 TRIGGERSCORE
  "fartsy/ffxivvictoryedit.mp3", // 57 VICTORY
  "fartsy/vo/sephiroth/memory.mp3", // 58 VO_SEPHMEMORY
  "fartsy/misc/wtfboom.mp3", // 59 WTFBOOM
  "mvm/ambient_mp3/mvm_siren.mp3", // 60
  "fartsy/memes/priceisright_fail.wav", // 61
  "fartsy/eee/the_horn.wav", // 62
  "fartsy/misc/fartsyscrusader_bgm_locus.mp3", // 63
  "ambient/sawblade_impact1.wav", // 64
  "vo/sandwicheat09.mp3" // 65
};

char AdvMessage[][256] = {
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}We have a Discord server: {forestgreen}https://discord.com/invite/SkHaeMH",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}Remember to buy your upgrades using {forestgreen}!buy",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}You may invoke {forestgreen}!sounds {white}to configure what sounds you hear from the plugin, or {forestgreen}!stats{white} to see your stats.",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}Advanced users may quick buy upgrades using {forestgreen}!qbuy",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}You may invoke {forestgreen}!sacpoints {white}to spend {forestgreen}sacrifice points{white} for many special abilities, including disabling the tornado!",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}TIP: As a {red}DEFENDER{white}, pushing your team's {forestgreen}payload {white}is crucial to wrecking havoc on the robots!",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}Remember, if someone is being abusive, you may always invoke {forestgreen}!calladmin{white}.",
  "{darkviolet}[{aqua}CORE{darkviolet}] {white}You may always invoke {forestgreen}!return{white} to be returned to spawn.",
  ""
};

char ASS[][64] = {
  "[10] Kissone Bath Salts", //0 (10)
  "[20] Summon Goobbue or Kirby", //1 (20)
  "[30] 35,000 UbUp Cash", //2 (30) 
  "[40] Explosives Paradise", //3 (40)
  "[50] Banish Tornadoes", //4 (50)
  "[60] Ass Gas", //5 (60) 
  "[70] Instant Fat Man", //6 (70)
  "[80] Meteorites", //7 (80)
  "[90) 300,000 UbUp Cash",//8 (90)
  "[100] Professor Fartsalot" //9 (100)
};
char ClassDefinitions[][32] = {
  "scout",
  "sniper",
  "soldier",
  "demoman",
  "medic",
  "heavy",
  "pyro",
  "spy",
  "engineer",
  ""
};

char DeathMessage[][64] = {
  "YEETED OUT INTO ORBIT",
  "SENT TO SPACE VIA TORNADO",
  "LAUNCHED ACROSS THE SKY",
  "SWALLOWED BY A STORM THAT WAS APPROACHING",
  "REDUCED TO DEBRIS",
  "FARTED INTO THE SKY",
  ""
};

char FB_SENT[][64] = {
  "FB.SentMeteor01",
  "FB.SentMeteor02",
  "FB.SentMeteor03",
  "FB.SentMeteor04",
  "FB.SentMeteor05",
  "FB.SentNuke01",
  "FB.SentNuke02",
  "FB.SentNuke03",
  "FB.SentNuke04",
  "FB.SentNuke05",
  "FB.SentStar01",
  "FB.SentStar02",
  "FB.SentStar03",
  "FB.SentStar04",
  "FB.SentStar05",
  ""
};

char sndPrefs[][128] = {
  "Sounds are currently DISABLED.",
  "Sounds are currently MUSIC ONLY.",
  "Sounds are currently SOUND EFFECTS ONLY.",
  "Sounds are currently ALL ON.",
  "Somehow your sound preference was stored as non-existent 5... Please configure your sounds."
};

int defaultBGMIndex[] = {
  0,
  4,
  5,
  6,
  7,
  11,
  12,
  13,
  14
};
int defaultBombStatus[] = {
  0, // 0 - should not be possible
  0,
  4,
  7,
  12,
  14,
  20,
  28,
  30 //wave 8
};
int defaultBombStatusMax[] = {
  0, // 0 - should not be possible
  10,
  18,
  26,
  34,
  42,
  50,
  58,
  66 //wave 8
};
int defaultSacPointsMax[] = {
  0,
  50,
  60,
  70,
  80,
  90,
  100,
  100,
  100 //wave 8
};
int tacoBellBGMIndex[] = {
  0,
  16,
  5,
  6,
  7,
  11,
  12,
  13,
  14
};
char SelectedCamera[][32] = {
  "CAM.Front",
  "CAM.Mid",
  "CAM.MidTwo",
  "CAM.Rear",
  "CAM.Kissone"
};
char SpecEnt[][24] = {
  "Spec.Goobbue",
  "Spec.Waffle",
  "Spec.Burrito",
  "Spec.Shroom",
  "Spec.BlueBall",
  "Spec*"
};
char StrikeAt[][32] = {
  "LightningHurt00",
  "LightningHurt01",
  "LightningHurt02",
  "LightningHurt03",
  "LightningHurt04",
  "LightningHurt05",
  "LightningHurt06",
  "LightningHurt07",
  "LightningHurt08",
  "LightningHurt09",
  "LightningHurt0A",
  "LightningHurt0B",
  "LightningHurt0C",
  "LightningHurt0D",
  "LightningHurt0E",
  "LightningHurt0F"
};
bool bgmPlaying = false;
bool bombProgression = false;
bool bombReset = false;
bool brawler_emergency = false;
bool canCrusaderNuke = false;
bool canHindenburg = false;
bool canHWBoss = false;
bool canSENTMeteors = false;
bool canSENTShark = false;
bool canSENTStars = false;
bool canSephNuke = false;
bool canTornado = false;
bool crusader = false;
bool isWave = false;
bool monitorOn = false;
bool monitorColor = true;
bool sacrificedByClient = false;
bool sephiroth = false;
bool shouldStopMusic = true;
bool tornado = false;
bool tacobell = false;
bool tickingClientHealth = false;
bool tickMusic = false;
bool TornadoWarningIssued = false;
Database FB_Database;
int BGMINDEX = 0;
int FailedCount = 0;
int INCOMINGDISPLAYED = 0;
int camSel = 0;
int CodeEntry = 0;
int bombStatus = 0;
int bombStatusMax = 0;
int curWave = 0;
int lastAdmin = 0;
int refireTime = 0;
int sacPoints = 0;
int sacPointsMax = 60;
int SNDCHAN = 6;
int soundPreference[MAXPLAYERS + 1];
int ticksMusic = 0;
int VIPBGM = -1;
int VIPIndex = 0;
int waveFlags = 0;
char curSong[64], prevSong[64], songName[64] = "null";
char TBGM0[16] = "test/bgm0.mp3";
char TBGM1[16] = "test/bgm1.mp3";
char TBGM2[16] = "test/bgm2.mp3";
char TBGM3[16] = "test/bgm3.mp3";
char TBGM4[16] = "test/bgm4.mp3";
char TBGM5[16] = "test/bgm5.mp3";
char TBGM6[16] = "test/bgm6.mp3";
float HWNMin = 210.0;
float HWNMax = 380.0;
float Return[3] = {
  -3730.0,
  67.0,
  -252.0
};

stock bool IsValidClient(int client) {
  return (0 < client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client));
}

void PrecacheAllFiles(){
  for (int i = 0; i < sizeof(MusicArray); i++){
    PrintToServer("[CORE] Precaching music: %s in position %i", MusicArray[i], i);
    PrecacheSound(MusicArray[i], true);
  }
  for (int i = 0; i < sizeof(SFXArray); i++){
    PrintToServer("[CORE] Precaching SFX: %s in position %i", SFXArray[i], i);
    PrecacheSound(SFXArray[i], true);
  }
}

void RegisterAllCommands(){
  RegServerCmd("fb_operator", Command_Operator, "Serverside only. Does nothing when executed as client.");
  RegAdminCmd("sm_music", Command_Music, ADMFLAG_RESERVATION, "Set music to be played for the next wave");
  RegConsoleCmd("sm_bombstatus", Command_FBBombStatus, "Check bomb status");
  RegConsoleCmd("sm_song", Command_GetCurrentSong, "Get current song name");
  RegConsoleCmd("sm_stats", Command_MyStats, "Print current statistics");
  RegConsoleCmd("sm_return", Command_Return, "Return to Spawn");
  RegConsoleCmd("sm_sacpoints", Command_SacrificePointShop, "Fartsy's Annihilation Supply Shop");
  RegConsoleCmd("sm_discord", Command_Discord, "Join our Discord server!");
  RegConsoleCmd("sm_sounds", Command_Sounds, "Toggle sounds on or off via menu");
}
public void OnConfigsExecuted() {
  if (!FB_Database) {
    Database.Connect(Database_OnConnect, "ass");
  }
}
//DB setup
public void Database_OnConnect(Database db,
  const char[] error, any data) {
  if (!db) {
    LogError("Could not connect to the database: %s", error);
    return;
  }
  char buffer[64];
  db.Driver.GetIdentifier(buffer, sizeof(buffer));
  if (!StrEqual(buffer, "mysql", false)) {
    delete db;
    LogError("Could not connect to the database: expected mysql database.");
    return;
  }
  FB_Database = db;
  FB_Database.Query(Database_FastQuery, "CREATE TABLE IF NOT EXISTS ass_activity(name TEXT, steamid INT UNSIGNED, date DATE, seconds INT UNSIGNED DEFAULT '0', class TEXT DEFAULT 'na', health TEXT DEFAULT '-1', maxHealth INT UNSIGNED DEFAULT '0', damagedealt INT UNSIGNED DEFAULT '0', damagedealtsession INT UNSIGNED DEFAULT '0', kills INT UNSIGNED DEFAULT '0', killssession INT UNSIGNED DEFAULT '0', deaths INT UNSIGNED DEFAULT '0', deathssession INT UNSIGNED DEFAULT '0', bombsreset INT UNSIGNED DEFAULT '0', bombsresetsession INT UNSIGNED DEFAULT '0', sacrifices INT UNSIGNED DEFAULT '0', sacrificessession INT UNSIGNED DEFAULT '0', lastkilledname TEXT DEFAULT 'na', lastweaponused TEXT DEFAULT 'na', killedbyname TEXT DEFAULT 'na', killedbyweapon TEXT DEFAULT 'na', soundprefs INT UNSIGNED DEFAULT '3', PRIMARY KEY (steamid));");
}

//Database Fastquery Manager
public void Database_FastQuery(Database db, DBResultSet results,
  const char[] error, any data) {
  if (!results) {
    LogError("Failed to query database: %s", error);
  }
}
public void Database_MergeDataError(Database db, any data, int numQueries,
  const char[] error, int failIndex, any[] queryData) {
  LogError("Failed to query database (transaction): %s", error);
}

//Calculate time spent on server in seconds
int GetClientMapTime(int client) {
  float clientTime = GetClientTime(client), gameTime = GetGameTime();
  if (clientTime > gameTime) {
    return RoundToZero(gameTime);
  }
  return RoundToZero(clientTime);
}

//Find an entity by its target name
int FindEntityByTargetname(char[] targetname, char[] classname)
{
  char namebuf[32];
  int index = -1;
  namebuf[0] = '\0';
 
  while(strcmp(namebuf, targetname) != 0 && (index = FindEntityByClassname(index, classname)) != -1){
    GetEntPropString(index, Prop_Data, "m_iName", namebuf, sizeof(namebuf));
    PrintToServer("Found %s, index %i", namebuf, index);
  }
  return(index);
}

//Used to keep StopSound from stopping the music we're trying to play - now with support for loop offsets!
public Action SyncMusic(Handle timer) {
  prevSong = curSong;
  tickOffset = (BGMINDEX == 4 ? true : BGMINDEX == 5 ? true : BGMINDEX == 6 ? true : BGMINDEX == 7 ? true : BGMINDEX == 15 ? true : BGMINDEX == 16 ? true : false);
  return Plugin_Stop;
}

//Get a client's health
stock int TF2_GetPlayerMaxHealth(int client) {
  return GetEntProp(GetPlayerResourceEntity(), Prop_Send, "m_iMaxHealth", _, client);
}