
int SNDLVL[] = {
  95, // 0 - BGMSNDLVL
  50, // 1 - DEFBGMSNDLVL
  75, // 2 - SFXSNDLVL
  0
};

char MusicArray[][64] = {
  "fartsy/music/ffxiv/TheSilentRegardOfStars.mp3", // 0
  "fartsy/music/ffxiv/KnowledgeNeverSleeps.mp3", // 1
  "fartsy/music/ffxiv/frommud.mp3", // 2
  "fartsy/music/ffxiv/locus.wav", // 3
  "fartsy/music/ffxiv/metal.wav", // 4
  "fartsy/music/ffxiv/exponentialentropy.wav", // 5
  "fartsy/music/ffxiv/tornfromtheheavens.mp3", // 6
  "fartsy/music/ffxiv/metalbrutejusticemode.wav", // 7
  "fartsy/music/ffxiv/penitus.wav", // 8
  "fartsy/music/ffxiv/revengetwofold.wav", // 9
  "fartsy/music/ffxiv/landslide.wav", // 10
  "fartsy/music/brawler/xbc2/battle.wav", // 11
  "fartsy/music/brawler/onewingedintro.mp3", // 12
  "fartsy/music/brawler/onewingedangel.mp3", // 13
  "fartsy/music/brawler/xbc/youwillknowournames.mp3", // 14
  "fartsy/music/ffxiv/TornColossusPhase1.mp3", // 15
  "fartsy/music/ffxiv/TornColossusPhase2.mp3", // 16
  "fartsy/music/demetori/unowen.mp3", // 17
  ""
};

char TitleArray[][64] = {
  "FFXIV - The Silent Regard of Stars", // 0
  "FFXIV - Knowledge Never Sleeps", // 1
  "FFXIV - From Mud", // 2
  "FFXIV - Locus", // 3
  "FFXIV - Metal", // 4
  "FFXIV - Exponential Entropy", // 5
  "FFXIV - Torn From the Heavens", // 6
  "FFXIV - Metal: Brute Justice Mode", // 7
  "FFXIV - Penitus", // 8
  "FFXIV - Revenge Twofold", // 9
  "FFXIV - Landslide", // 10
  "Xenoblade Chronicles 2 - Battle!!", // 11
  "FF Advent Children - One Winged Angel", // 12
  "Xenoblade Chronicles - You Will Know Our Names", // 13
  "FFXIV - Torn From The Heavens Dark Colossus (Phase 1)", // 14
  "FFXIV - Torn From The Heavens Dark Colossus (Phase 2)", // 15
  "Demetori - U.N. Owen Was Her?", // 16
  ""
};

int RefireArray[] = {
  9170, // 0
  15686, // 1
  9180, // 2
  15270, // 3
  10250, // 4
  11110, // 5
  8137, // 6
  8770, // 7
  28476, // 8
  8870, // 9
  14333, // 10
  8120, // 11
  8587, // 12
  20720, // 13
  9986, // 14
  5286, // 15
  17873, // 16
  0
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
  ""
};

bool bgmPlaying = false;
bool bombProgression = false;
bool bombReset = false;
bool brawler_emergency = false;
bool canCrusaderNuke = false;
bool canHindenburg = false;
bool canHWBoss = false;
bool canSENTMeteors = false;
bool canSENTNukes = false;
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
bool isADPCM = false;
bool TornadoWarningIssued = false;

int BGMINDEX = 0;
int FailedCount = 0;
int INCOMINGDISPLAYED = 0;
int camSel = 0;
int CodeEntry = 0;
int bombStatus = 0;
int bombStatusMax = 0;
int curWave = 0;
int explodeType = 0;
int lastAdmin = 0;
int loopingFlags = 0;
int refireTime = 0;
int sacPoints = 0;
int sacPointsMax = 60;
int SNDCHAN = 6;
int soundPreference[MAXPLAYERS + 1];
int ticksMusic = 0;
int VIPBGM = -1;
int VIPIndex = 0;
int waveFlags = 0;

char curSong[64], prevSong[64] = "null";
char s[128] = "null";
char songName[64] = "null";
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
  return (0 < client <= MaxClients && IsClientInGame(client));
}

void PrecacheAllFiles(){
  for (int i = 0; i < (sizeof(MusicArray) - 1); i++){
    PrintToServer("[CORE] Precaching music: %s in position %i", MusicArray[i], i);
    PrecacheSound(MusicArray[i], true);
  }
  for (int i = 0; i < (sizeof(SFXArray) - 1); i++){
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