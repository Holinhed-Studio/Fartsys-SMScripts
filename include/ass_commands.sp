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