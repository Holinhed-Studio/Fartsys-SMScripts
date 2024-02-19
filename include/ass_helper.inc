bool tickOffset = false;
char failsafe[][256] = {
  "{orange}Phoenix♥ {white}: FAILSAFE HAS BEEN TRIGGERED. ROBOT EXTERMINATION IN PROGRESS. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Nice try. You think this is funny? How about THIS instead? [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: (╯°□°）╯︵ ¡¡¡pƎ⅄O˥ԀƎp Ǝq O┴ ┴∩Oq∀ SI SS∀ S,ɹOSSƎℲOɹԀ [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Flips a coin and... HEADS! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Pwofessow's b-butt is a-about to be depwoyed!!! JUST KIDDING - GET FUCKED. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: We aren't so different, you and I. Oh wait, yes we are. You're a pile of scrap and I'm actually useful! :> [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: *BZZT* Sorry, time's up! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: It's only me and you, who is gonna save you now? [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Nope. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Sometimes I even amaze myself. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Some disassembly required. [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Oops, I did it again! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Not on my watch! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: Sometimes you scare me! [Failsafe Activated]",
  "{orange}Phoenix♥ {white}: You know, I never really thought about it. [Failsafe Activated]"
};
//Silence cvar changes to minimize chat spam.
public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast) {
  event.BroadcastDisabled = true;
  return Plugin_Handled;
}
bool bombReady = false;
char dbgStr[256];

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
  "[30] Robot Trap (Wave Fail-safe)", //2 (30) 
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

int tacoBellBGMIndex[] = {
  1,
  17,
  6,
  7,
  8,
  12,
  13,
  14,
  15
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
bool doFailsafe = false;
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
int BGMINDEX = 1;
int FailedCount = 0;
int INCOMINGDISPLAYED = 0;
int camSel = 0;
int CodeEntry = 0;
int bombStatus = 0;
int bombStatusMax = 0;
int curWave = 0;
int failsafeCount = -1;
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
char realPath[64], cachedPath[64], songName[64] = "null";
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

//Get a client's health
stock int TF2_GetPlayerMaxHealth(int client) {
  return GetEntProp(GetPlayerResourceEntity(), Prop_Send, "m_iMaxHealth", _, client);
}

enum struct BGM {
  char realPath[64];
  char songName[64];
  int refireTime;
  int ticksOffset;
  int SNDLVL;
}
BGM BGMArray[20];

void RegisterAndPrecacheAllFiles(){
  BGMArray[0].realPath = "ui/system_message_alert.wav";
  BGMArray[1].realPath = "fartsy/music/ffxiv/TheSilentRegardOfStars.wav";
  BGMArray[2].realPath = "fartsy/music/ffxiv/KnowledgeNeverSleeps.wav";
  BGMArray[3].realPath = "fartsy/music/ffxiv/FromMud.wav";
  BGMArray[4].realPath = "fartsy/music/ffxiv/AndLoveYouShallFind.wav";
  BGMArray[5].realPath = "fartsy/music/ffxiv/locus.wav";
  BGMArray[6].realPath = "fartsy/music/ffxiv/metal.wav";
  BGMArray[7].realPath = "fartsy/music/ffxiv/exponentialentropy.wav";
  BGMArray[8].realPath = "fartsy/music/ffxiv/fromtheheavens_loop1.wav";
  BGMArray[9].realPath = "fartsy/music/ffxiv/fromtheheavens_loop2.wav";
  BGMArray[10].realPath = "fartsy/music/ffxiv/fromtheheavens_loop3.wav";
  BGMArray[11].realPath = "fartsy/music/ffxiv/fromtheheavens_loop4.wav";
  BGMArray[12].realPath = "fartsy/music/ffxiv/metalbrutejusticemode.wav";
  BGMArray[13].realPath = "fartsy/music/ffxiv/penitus.wav";
  BGMArray[14].realPath = "fartsy/music/ffxiv/revengetwofold.wav";
  BGMArray[15].realPath = "fartsy/music/ffxiv/landslide.wav";
  BGMArray[16].realPath = "fartsy/music/brawler/onewingedangel.wav";
  BGMArray[17].realPath = "fartsy/music/brawler/xbc2/battle.wav";
  BGMArray[18].realPath = "fartsy/music/brawler/xbc/youwillknowournames.mp3";
  BGMArray[19].realPath = "fartsy/music/demetori/unowen.mp3";
  BGMArray[0].songName = "Restore Defaults";
  BGMArray[1].songName = "FFXIV - The Silent Regard of Stars";
  BGMArray[2].songName = "FFXIV - Knowledge Never Sleeps";
  BGMArray[3].songName = "FFXIV - From Mud";
  BGMArray[4].songName = "FFXIV - And Love You Shall Find";
  BGMArray[5].songName = "FFXIV - Locus";
  BGMArray[6].songName = "FFXIV - Metal";
  BGMArray[7].songName = "FFXIV - Exponential Entropy";
  BGMArray[8].songName = "FFXIV - From the Heavens (P1)";
  BGMArray[9].songName = "FFXIV - From the Heavens (P2)";
  BGMArray[10].songName = "FFXIV - From the Heavens (P3)";
  BGMArray[11].songName = "FFXIV - From the Heavens (P4)";
  BGMArray[12].songName = "FFXIV - Metal: Brute Justice Mode";
  BGMArray[13].songName = "FFXIV - Penitus";
  BGMArray[14].songName = "FFXIV - Revenge Twofold";
  BGMArray[15].songName = "FFXIV - Landslide";
  BGMArray[16].songName = "FF Advent Children - One Winged Angel";
  BGMArray[17].songName = "Xenoblade Chronicles 2 - Battle!!";
  BGMArray[18].songName = "Xenoblade Chronicles - You Will Know Our Names";
  BGMArray[19].songName = "Demetori - U.N. Owen Was Her?";
  BGMArray[0].SNDLVL = 0;
  BGMArray[1].SNDLVL = 75;
  BGMArray[2].SNDLVL = 75;
  BGMArray[3].SNDLVL = 75;
  BGMArray[4].SNDLVL = 75;
  BGMArray[5].SNDLVL = 75;
  BGMArray[6].SNDLVL = 75;
  BGMArray[7].SNDLVL = 75;
  BGMArray[8].SNDLVL = 75;
  BGMArray[9].SNDLVL = 75;
  BGMArray[10].SNDLVL = 75;
  BGMArray[11].SNDLVL = 75;
  BGMArray[12].SNDLVL = 75;
  BGMArray[13].SNDLVL = 75;
  BGMArray[14].SNDLVL = 75;
  BGMArray[15].SNDLVL = 75;
  BGMArray[16].SNDLVL = 75;
  BGMArray[17].SNDLVL = 75;
  BGMArray[18].SNDLVL = 75;
  BGMArray[19].SNDLVL = 75;
  BGMArray[0].refireTime = 0;
  BGMArray[1].refireTime = 9190;
  BGMArray[2].refireTime = 15690;
  BGMArray[3].refireTime = 9190;
  BGMArray[4].refireTime = 10490;
  BGMArray[5].refireTime = 15270;
  BGMArray[6].refireTime = 10250;
  BGMArray[7].refireTime = 11110;
  BGMArray[8].refireTime = 4250;
  BGMArray[9].refireTime = 5492;
  BGMArray[10].refireTime = 3947;
  BGMArray[11].refireTime = 2508;
  BGMArray[12].refireTime = 8702;
  BGMArray[13].refireTime = 28476;
  BGMArray[14].refireTime = 8805;
  BGMArray[15].refireTime = 14160;
  BGMArray[16].refireTime = 20592;
  BGMArray[17].refireTime = 8120;
  BGMArray[18].refireTime = 8475;
  BGMArray[19].refireTime = 19240;
  BGMArray[0].ticksOffset = 0;
  BGMArray[1].ticksOffset = 0;
  BGMArray[2].ticksOffset = 0;
  BGMArray[3].ticksOffset = 0;
  BGMArray[4].ticksOffset = 0;
  BGMArray[5].ticksOffset = 429;
  BGMArray[6].ticksOffset = 226;
  BGMArray[7].ticksOffset = 11;
  BGMArray[8].ticksOffset = 1078;
  BGMArray[9].ticksOffset = 0;
  BGMArray[10].ticksOffset = 0;
  BGMArray[11].ticksOffset = 0;
  BGMArray[12].ticksOffset = 0;
  BGMArray[13].ticksOffset = 0;
  BGMArray[14].ticksOffset = 0;
  BGMArray[15].ticksOffset = 0;
  BGMArray[16].ticksOffset = 2753;
  BGMArray[17].ticksOffset = 749;
  BGMArray[18].ticksOffset = 0;
  BGMArray[19].ticksOffset = 0;
  for (int i = 0; i < sizeof(BGMArray); i++){
    PrintToServer("[CORE] Precaching %s (%s), Duration %i ticks, Start Loop Point %i ticks, Volume %i   @ %i", BGMArray[i].songName, BGMArray[i].realPath, BGMArray[i].refireTime, BGMArray[i].ticksOffset, BGMArray[i].SNDLVL, i);
    PrecacheSound(BGMArray[i].realPath, true);
  }
  for (int i = 0; i < sizeof(SFXArray); i++){
    PrintToServer("[CORE] Precaching SFX: %s in position %i", SFXArray[i], i);
    PrecacheSound(SFXArray[i], true);
  }
}

//Used to keep StopSound from stopping the music we're trying to play - now with support for loop offsets!
public Action SyncMusic(Handle timer) {
  cachedPath = realPath;
  tickOffset = (BGMArray[BGMINDEX].ticksOffset > 0 ? true : false);
  return Plugin_Stop;
}

enum struct DEFAULTS {
  bool defCanHWBoss;
  bool defCanTornado;
  int defBGMIndex;
  int defBombStatus;
  int defBombStatusMax;
  int defSacPointsMax;
}
DEFAULTS DefaultsArray[9];

void SetupDefaults(){
  DefaultsArray[0].defCanHWBoss = false;
  DefaultsArray[1].defCanHWBoss = false;
  DefaultsArray[2].defCanHWBoss = false;
  DefaultsArray[3].defCanHWBoss = true;
  DefaultsArray[4].defCanHWBoss = true;
  DefaultsArray[5].defCanHWBoss = true;
  DefaultsArray[6].defCanHWBoss = true;
  DefaultsArray[7].defCanHWBoss = true;
  DefaultsArray[8].defCanHWBoss = true;
  DefaultsArray[0].defCanTornado = false;
  DefaultsArray[1].defCanTornado = false;
  DefaultsArray[2].defCanTornado = false;
  DefaultsArray[3].defCanTornado = true;
  DefaultsArray[4].defCanTornado = true;
  DefaultsArray[5].defCanTornado = true;
  DefaultsArray[6].defCanTornado = true;
  DefaultsArray[7].defCanTornado = true;
  DefaultsArray[8].defCanTornado = true;
  DefaultsArray[0].defBGMIndex = 1;
  DefaultsArray[1].defBGMIndex = 5;
  DefaultsArray[2].defBGMIndex = 6;
  DefaultsArray[3].defBGMIndex = 7;
  DefaultsArray[4].defBGMIndex = 8;
  DefaultsArray[5].defBGMIndex = 12;
  DefaultsArray[6].defBGMIndex = 13;
  DefaultsArray[7].defBGMIndex = 14;
  DefaultsArray[8].defBGMIndex = 15;
  DefaultsArray[0].defBombStatus = 0;
  DefaultsArray[1].defBombStatus = 4;
  DefaultsArray[2].defBombStatus = 7;
  DefaultsArray[3].defBombStatus = 8;
  DefaultsArray[4].defBombStatus = 12;
  DefaultsArray[5].defBombStatus = 14;
  DefaultsArray[6].defBombStatus = 20;
  DefaultsArray[7].defBombStatus = 28;
  DefaultsArray[8].defBombStatus = 30;
  DefaultsArray[0].defBombStatusMax = 0;
  DefaultsArray[1].defBombStatusMax = 10;
  DefaultsArray[2].defBombStatusMax = 18;
  DefaultsArray[3].defBombStatusMax = 26;
  DefaultsArray[4].defBombStatusMax = 34;
  DefaultsArray[5].defBombStatusMax = 42;
  DefaultsArray[6].defBombStatusMax = 50;
  DefaultsArray[7].defBombStatusMax = 58;
  DefaultsArray[8].defBombStatusMax = 66;
  DefaultsArray[0].defSacPointsMax = 0;
  DefaultsArray[1].defSacPointsMax = 50;
  DefaultsArray[2].defSacPointsMax = 60;
  DefaultsArray[3].defSacPointsMax = 70;
  DefaultsArray[4].defSacPointsMax = 80;
  DefaultsArray[5].defSacPointsMax = 90;
  DefaultsArray[6].defSacPointsMax = 100;
  DefaultsArray[7].defSacPointsMax = 100;
  DefaultsArray[8].defSacPointsMax = 100;
}