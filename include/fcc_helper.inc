//Helper for Fartsy's Clockwork Chaos
bool BLC = false; //Blu captured intermediate point, set by OnOwnerChangedToTeam3
bool REC = false; //Red captured intermediate point, set by OnOwnerChangeToTeam2
bool isMatch = false; //Is it a match?
bool RECEDE = false; //PL receding
bool PLM; //Payload is moving
char LoggerDbg[512];
char LoggerInfo[256];
char PLT[16] = "N/A"; //Team that is currently pushing the payload
int PLB = 0; //Payload blu progress
int PLL = 0; //Payload location. 0 = neutral, 1 = red, 2 = blu
int PLR = 0; //Payload red progress
int PLRL = 20; //Payload real location, 40 = red base, 20 = neutral, 0 = blu base
Handle RecedeTimer = INVALID_HANDLE; //Recede timer, restart it by killing it and starting a new one.
//PL Hud
enum struct CCHUD {
    char RED[128];
    char BLU[128];
    char IDLE[128];
    char NEUTRAL[128];
}
CCHUD CCH[42];

//Reference lookup for payload position
int PLPOS[] = {
    100,
    95,
    90,
    85,
    80,
    75,
    70,
    65,
    60,
    55,
    50,
    45,
    40,
    35,
    30,
    25,
    20,
    15,
    10,
    5,
    0,
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    55,
    60,
    65,
    70,
    75,
    80,
    85,
    90,
    95,
    100,
    100
};

//Register and precache all sounds
void RegisterAndPrecacheAllFiles(){
  LogMessage("[ERROR] RegisterAndPRecacheAllFiles is not implemented!");
}

//Register all commands
void RegisterAllCommands(){
  FccLogger(1, "Registering commands...");
  RegServerCmd("fcc_operator", Command_Operator, "Serverside only. Does nothing when executed as client.");
}

//Setup core map data
void SetupCoreData(){
  FccLogger(1, "Setting up core data...");
  CCH[0].BLU = "hud/cconflict/cc_bluFF"; // Blu payload at their spawn being pushed by blu
  CCH[1].BLU = "hud/cconflict/cc_bluFE";
  CCH[2].BLU = "hud/cconflict/cc_bluFD";
  CCH[3].BLU = "hud/cconflict/cc_bluFC";
  CCH[4].BLU = "hud/cconflict/cc_bluFB";
  CCH[5].BLU = "hud/cconflict/cc_bluFA";
  CCH[6].BLU = "hud/cconflict/cc_bluF9";
  CCH[7].BLU = "hud/cconflict/cc_bluF8";
  CCH[8].BLU = "hud/cconflict/cc_bluF7";
  CCH[9].BLU = "hud/cconflict/cc_bluF6";
  CCH[10].BLU = "hud/cconflict/cc_bluF5";
  CCH[11].BLU = "hud/cconflict/cc_bluF4";
  CCH[12].BLU = "hud/cconflict/cc_bluF3";
  CCH[13].BLU = "hud/cconflict/cc_bluF2";
  CCH[14].BLU = "hud/cconflict/cc_bluF1";
  CCH[15].BLU = "hud/cconflict/cc_bluF0";
  CCH[16].BLU = "hud/cconflict/cc_bluEF";
  CCH[17].BLU = "hud/cconflict/cc_bluEE";
  CCH[18].BLU = "hud/cconflict/cc_bluED";
  CCH[19].BLU = "hud/cconflict/cc_bluEC";
  CCH[20].BLU = "hud/cconflict/cc_blu00";
  CCH[21].BLU = "hud/cconflict/cc_blu01";
  CCH[22].BLU = "hud/cconflict/cc_blu02";
  CCH[23].BLU = "hud/cconflict/cc_blu03";
  CCH[24].BLU = "hud/cconflict/cc_blu04";
  CCH[25].BLU = "hud/cconflict/cc_blu05";
  CCH[26].BLU = "hud/cconflict/cc_blu06";
  CCH[27].BLU = "hud/cconflict/cc_blu07";
  CCH[28].BLU = "hud/cconflict/cc_blu08";
  CCH[29].BLU = "hud/cconflict/cc_blu09";
  CCH[30].BLU = "hud/cconflict/cc_blu0A";
  CCH[31].BLU = "hud/cconflict/cc_blu0C";
  CCH[32].BLU = "hud/cconflict/cc_blu0D";
  CCH[33].BLU = "hud/cconflict/cc_blu0E";
  CCH[34].BLU = "hud/cconflict/cc_blu0F";
  CCH[35].BLU = "hud/cconflict/cc_blu10";
  CCH[36].BLU = "hud/cconflict/cc_blu11";
  CCH[37].BLU = "hud/cconflict/cc_blu12";
  CCH[38].BLU = "hud/cconflict/cc_blu13";
  CCH[39].BLU = "hud/cconflict/cc_blu14";
  CCH[40].BLU = "hud/cconflict/cc_blu15";
  CCH[0].RED = "hud/cconflict/cc_red2A"; // Red payload at Blu spawn
  CCH[1].RED = "hud/cconflict/cc_red29";
  CCH[2].RED = "hud/cconflict/cc_red28";
  CCH[3].RED = "hud/cconflict/cc_red27";
  CCH[4].RED = "hud/cconflict/cc_red26";
  CCH[5].RED = "hud/cconflict/cc_red25";
  CCH[6].RED = "hud/cconflict/cc_red24";
  CCH[7].RED = "hud/cconflict/cc_red23";
  CCH[8].RED = "hud/cconflict/cc_red22";
  CCH[9].RED = "hud/cconflict/cc_red21";
  CCH[10].RED = "hud/cconflict/cc_red1F";
  CCH[11].RED = "hud/cconflict/cc_red1E";
  CCH[12].RED = "hud/cconflict/cc_red1D";
  CCH[13].RED = "hud/cconflict/cc_red1C";
  CCH[14].RED = "hud/cconflict/cc_red1B";
  CCH[15].RED = "hud/cconflict/cc_red1A";
  CCH[16].RED = "hud/cconflict/cc_red19";
  CCH[17].RED = "hud/cconflict/cc_red18";
  CCH[18].RED = "hud/cconflict/cc_red17";
  CCH[19].RED = "hud/cconflict/cc_red16";
  CCH[20].RED = "hud/cconflict/cc_red15";
  CCH[21].RED = "hud/cconflict/cc_redEC";
  CCH[22].RED = "hud/cconflict/cc_redED";
  CCH[23].RED = "hud/cconflict/cc_redEE";
  CCH[24].RED = "hud/cconflict/cc_redEF";
  CCH[25].RED = "hud/cconflict/cc_redF0";
  CCH[26].RED = "hud/cconflict/cc_redF1";
  CCH[27].RED = "hud/cconflict/cc_redF2";
  CCH[28].RED = "hud/cconflict/cc_redF3";
  CCH[29].RED = "hud/cconflict/cc_redF4";
  CCH[30].RED = "hud/cconflict/cc_redF5";
  CCH[31].RED = "hud/cconflict/cc_redF6";
  CCH[32].RED = "hud/cconflict/cc_redF7";
  CCH[33].RED = "hud/cconflict/cc_redF8";
  CCH[34].RED = "hud/cconflict/cc_redF9";
  CCH[35].RED = "hud/cconflict/cc_redFA";
  CCH[36].RED = "hud/cconflict/cc_redFB";
  CCH[37].RED = "hud/cconflict/cc_redFC";
  CCH[38].RED = "hud/cconflict/cc_redFD";
  CCH[39].RED = "hud/cconflict/cc_redFE";
  CCH[40].RED = "hud/cconflict/cc_redFF";
  CCH[0].NEUTRAL = "hud/cconflict/cc_neutralFF"; // Receding payload at their spawn
  CCH[1].NEUTRAL = "hud/cconflict/cc_neutralFE";
  CCH[2].NEUTRAL = "hud/cconflict/cc_neutralFD";
  CCH[3].NEUTRAL = "hud/cconflict/cc_neutralFC";
  CCH[4].NEUTRAL = "hud/cconflict/cc_neutralFB";
  CCH[5].NEUTRAL = "hud/cconflict/cc_neutralFA";
  CCH[6].NEUTRAL = "hud/cconflict/cc_neutralF9";
  CCH[7].NEUTRAL = "hud/cconflict/cc_neutralF8";
  CCH[8].NEUTRAL = "hud/cconflict/cc_neutralF7";
  CCH[9].NEUTRAL = "hud/cconflict/cc_neutralF6";
  CCH[10].NEUTRAL = "hud/cconflict/cc_neutralF5";
  CCH[11].NEUTRAL = "hud/cconflict/cc_neutralF4";
  CCH[12].NEUTRAL = "hud/cconflict/cc_neutralF3";
  CCH[13].NEUTRAL = "hud/cconflict/cc_neutralF2";
  CCH[14].NEUTRAL = "hud/cconflict/cc_neutralF1";
  CCH[15].NEUTRAL = "hud/cconflict/cc_neutralF0";
  CCH[16].NEUTRAL = "hud/cconflict/cc_neutralEF";
  CCH[17].NEUTRAL = "hud/cconflict/cc_neutralEE";
  CCH[18].NEUTRAL = "hud/cconflict/cc_neutralED";
  CCH[19].NEUTRAL = "hud/cconflict/cc_neutralEC";
  CCH[20].NEUTRAL = "hud/cconflict/cc_neutral00";
  CCH[21].NEUTRAL = "hud/cconflict/cc_neutral01";
  CCH[22].NEUTRAL = "hud/cconflict/cc_neutral02";
  CCH[23].NEUTRAL = "hud/cconflict/cc_neutral03";
  CCH[24].NEUTRAL = "hud/cconflict/cc_neutral04";
  CCH[25].NEUTRAL = "hud/cconflict/cc_neutral05";
  CCH[26].NEUTRAL = "hud/cconflict/cc_neutral06";
  CCH[27].NEUTRAL = "hud/cconflict/cc_neutral07";
  CCH[28].NEUTRAL = "hud/cconflict/cc_neutral08";
  CCH[29].NEUTRAL = "hud/cconflict/cc_neutral09";
  CCH[30].NEUTRAL = "hud/cconflict/cc_neutral0A";
  CCH[31].NEUTRAL = "hud/cconflict/cc_neutral0C";
  CCH[32].NEUTRAL = "hud/cconflict/cc_neutral0D";
  CCH[33].NEUTRAL = "hud/cconflict/cc_neutral0E";
  CCH[34].NEUTRAL = "hud/cconflict/cc_neutral0F";
  CCH[35].NEUTRAL = "hud/cconflict/cc_neutral10";
  CCH[36].NEUTRAL = "hud/cconflict/cc_neutral11";
  CCH[37].NEUTRAL = "hud/cconflict/cc_neutral12";
  CCH[38].NEUTRAL = "hud/cconflict/cc_neutral13";
  CCH[39].NEUTRAL = "hud/cconflict/cc_neutral14";
  CCH[40].NEUTRAL = "hud/cconflict/cc_neutral15";
  CCH[0].IDLE = "hud/cconflict/cc_idleFF";
  CCH[1].IDLE = "hud/cconflict/cc_idleFE";
  CCH[2].IDLE = "hud/cconflict/cc_idleFD";
  CCH[3].IDLE = "hud/cconflict/cc_idleFC";
  CCH[4].IDLE = "hud/cconflict/cc_idleFB";
  CCH[5].IDLE = "hud/cconflict/cc_idleFA";
  CCH[6].IDLE = "hud/cconflict/cc_idleF9";
  CCH[7].IDLE = "hud/cconflict/cc_idleF8";
  CCH[8].IDLE = "hud/cconflict/cc_idleF7";
  CCH[9].IDLE = "hud/cconflict/cc_idleF6";
  CCH[10].IDLE = "hud/cconflict/cc_idleF5";
  CCH[11].IDLE = "hud/cconflict/cc_idleF4";
  CCH[12].IDLE = "hud/cconflict/cc_idleF3";
  CCH[13].IDLE = "hud/cconflict/cc_idleF2";
  CCH[14].IDLE = "hud/cconflict/cc_idleF1";
  CCH[15].IDLE = "hud/cconflict/cc_idleF0";
  CCH[16].IDLE = "hud/cconflict/cc_idleEF";
  CCH[17].IDLE = "hud/cconflict/cc_idleEE";
  CCH[18].IDLE = "hud/cconflict/cc_idleED";
  CCH[19].IDLE = "hud/cconflict/cc_idleEC";
  CCH[20].IDLE = "hud/cconflict/cc_idle00";
  CCH[21].IDLE = "hud/cconflict/cc_idle01";
  CCH[22].IDLE = "hud/cconflict/cc_idle02";
  CCH[23].IDLE = "hud/cconflict/cc_idle03";
  CCH[24].IDLE = "hud/cconflict/cc_idle04";
  CCH[25].IDLE = "hud/cconflict/cc_idle05";
  CCH[26].IDLE = "hud/cconflict/cc_idle06";
  CCH[27].IDLE = "hud/cconflict/cc_idle07";
  CCH[28].IDLE = "hud/cconflict/cc_idle08";
  CCH[29].IDLE = "hud/cconflict/cc_idle09";
  CCH[30].IDLE = "hud/cconflict/cc_idle0A";
  CCH[31].IDLE = "hud/cconflict/cc_idle0C";
  CCH[32].IDLE = "hud/cconflict/cc_idle0D";
  CCH[33].IDLE = "hud/cconflict/cc_idle0E";
  CCH[34].IDLE = "hud/cconflict/cc_idle0F";
  CCH[35].IDLE = "hud/cconflict/cc_idle10";
  CCH[36].IDLE = "hud/cconflict/cc_idle11";
  CCH[37].IDLE = "hud/cconflict/cc_idle12";
  CCH[38].IDLE = "hud/cconflict/cc_idle13";
  CCH[39].IDLE = "hud/cconflict/cc_idle14";
  CCH[40].IDLE = "hud/cconflict/cc_idle15";
}

//Check if the client is valid
stock bool IsValidClient(int client) {
  return (0 < client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client));
}

// Show overlay to all clients with lifetime | 0.0 = no auto remove
stock void ShowOverlayAll(char[] path)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i) || IsClientSourceTV(i) || IsClientReplay(i))
			continue;
		ClientCommand(i, "r_screenoverlay \"%s.vtf\"", path);
	}
}