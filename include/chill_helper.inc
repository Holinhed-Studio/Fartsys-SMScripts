enum struct MENUARRAY {
  char alias[64];
  char hintText[256];
  char title[64];
  char url[64];
  char item[256];
  int size;
}
MENUARRAY DiscordMenu[8];
MENUARRAY RulesMenu[16];
//MENUARRAY VotesMenu[16];

int menuData = -1;
void RegisterAllMenus() {
  Handle confMenuDiscord = OpenFile("addons/sourcemod/configs/ChillSkiesMenus/discord.ini", "rt", false);
  Handle confMenuRules = OpenFile("addons/sourcemod/configs/ChillSkiesMenus/rules.ini", "rt", false);
  Handle confMenuVotes = OpenFile("addons/sourcemod/configs/ChillSkiesMenus/votes.ini", "rt", false);
  if (confMenuDiscord == INVALID_HANDLE || confMenuRules == INVALID_HANDLE || confMenuVotes == INVALID_HANDLE) return;
  char buffer[256];
  int x = -1;
  int y = -1;
  int z = -1;
  LogMessage("Reading configs - discord.ini");
  while (ReadFileLine(confMenuDiscord, buffer, sizeof(buffer))) {
    TrimString(buffer);
    if (!StrContains(buffer, "Title:")) {
      ReplaceString(buffer, sizeof(buffer), "Title:", "", true);
      Format(DiscordMenu[0].title, 64, buffer);
    }
    if (!StrContains(buffer, "Item:")) {
      x++;
      ReplaceString(buffer, sizeof(buffer), "Item:", "", true);
      Format(DiscordMenu[x].item, 64, buffer);
    }
    if (!StrContains(buffer, "Alias:")) {
      ReplaceString(buffer, sizeof(buffer), "Alias:", "", true);
      Format(DiscordMenu[0].alias, 64, buffer);
    }
    if (!StrContains(buffer, "URL:")) {
      ReplaceString(buffer, sizeof(buffer), "URL:", "", true);
      Format(DiscordMenu[0].url, 64, buffer);
    }
    DiscordMenu[0].size = x + 1;
    if (IsEndOfFile(confMenuDiscord)) break;
  }
  CloseHandle(confMenuDiscord);
  LogMessage("Reading configs - rules.ini");
  while (ReadFileLine(confMenuRules, buffer, sizeof(buffer))) {
    TrimString(buffer);
    if (!StrContains(buffer, "Title:")) {
      ReplaceString(buffer, sizeof(buffer), "Title:", "", true);
      Format(RulesMenu[0].title, 64, buffer);
    }
    if (!StrContains(buffer, "HintText:")) {
      y++;
      ReplaceString(buffer, sizeof(buffer), "HintText:", "", true);
      Format(RulesMenu[y].hintText, 256, buffer);
      PrintToServer("Setting RulesMenu[%i].hintText to %s", y, buffer);
    }
    if (!StrContains(buffer, "Rule:")) {
      z++;
      ReplaceString(buffer, sizeof(buffer), "Rule:", "", true);
      Format(RulesMenu[z].item, 256, buffer);
      PrintToServer("Setting RulesMenu[%i].item to %s", z, buffer);
    }
    RulesMenu[0].size = z + 1;
    if (IsEndOfFile(confMenuRules)) break;
  }
  CloseHandle(confMenuRules);
}

//Check if the client is valid
stock bool IsValidClient(int client) {
  return (0 < client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client));
}