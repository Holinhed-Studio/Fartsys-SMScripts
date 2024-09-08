#include <chill_helper>
#include <morecolors>
#include <sourcemod>

#pragma newdecls required
#pragma semicolon 1

static char PLUGIN_VERSION[8] = "1.0.0";

public Plugin myinfo = {
  name = "Chill Skies - Menus",
  author = "Fartsy",
  description = "Menu plugin for Chill Skies",
  version = PLUGIN_VERSION,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart() {
  RegisterAllMenus();
  RegConsoleCmd("sm_discord", Command_ShowDiscordMenu, "Show the chill skies discord thing");
  RegConsoleCmd("sm_rules", Command_ShowRulesMenu, "Show the chill skies rules thing");
  RegConsoleCmd("sm_votes", Command_ShowVotesMenu, "Show the chill skies votes thing");
}

//Send client Discord menu
public Action Command_ShowDiscordMenu(int client, int args) {
  if (IsValidClient(client)) {
    Menu menu = new Menu(MenuHandlerDiscord, MENU_ACTIONS_DEFAULT);
    char buffer[100];
    menu.SetTitle(DiscordMenu[0].title);
    for (int i = 0; i < DiscordMenu[0].size; i++) menu.AddItem(buffer, DiscordMenu[i].item);
    menu.ExitButton = true;
    menu.Display(client, 20);
  }
  return Plugin_Handled;
}

public int MenuHandlerDiscord(Menu menu, MenuAction action, int client, int choice) {
  if (action == MenuAction_Select) {
    //DiscordMenu[choice].select();
    switch (choice) {
    case 0: {
      ShowMOTDPanel(client, DiscordMenu[0].alias, DiscordMenu[0].url, MOTDPANEL_TYPE_URL);
      CPrintToChat(client, "Our Discord server invite is {violet}%s", DiscordMenu[0].url);
    }
    }
  } else if (action == MenuAction_End) CloseHandle(menu);
  return 0;
}

//Send client rules menu
public Action Command_ShowRulesMenu(int client, int args) {
  if (IsValidClient(client)) {
    Menu menu = new Menu(MenuHandlerRules, MENU_ACTIONS_DEFAULT);
    char buffer[100];
    menu.SetTitle(RulesMenu[0].title);
    for (int i = 0; i < RulesMenu[0].size; i++) menu.AddItem(buffer, RulesMenu[i].item);
    menu.ExitButton = true;
    menu.Display(client, 20);
  }
  return Plugin_Handled;
}

public int MenuHandlerRules(Menu menu, MenuAction action, int client, int choice) {
  if (action == MenuAction_Select) {
    PrintHintText(client, RulesMenu[choice].hintText);
    Command_ShowRulesMenu(client, 0);
  } else if (action == MenuAction_End) CloseHandle(menu);
  return 0;
}

//Send clients votes menu
public Action Command_ShowVotesMenu(int client, int args) {
  if (IsValidClient(client)) {
    Menu menu = new Menu(MenuHandlerVotes, MENU_ACTIONS_DEFAULT);
    char buffer[100];
    menu.SetTitle("Chill Skies Votes"); //VotesMenu[0].title
    menu.AddItem(buffer, "Toggle AllTalk");
    menu.AddItem(buffer, "Toggle RTD");
    //menu.AddItem(buffer, "Example Vote");
    menu.ExitButton = true;
    menu.Display(client, 20);
  }
  return Plugin_Handled;
}

public int MenuHandlerVotes(Menu menu, MenuAction action, int client, int choice) {
  if (action == MenuAction_Select) {
    menuData = choice;
    PrintToChatAll("%i", menuData);
    ShowVoteMenu(client);
  }
  return 0;
}
public void ShowVoteMenu(int client) {
  switch (menuData) {
  case 0: {
    if (!IsVoteInProgress()) {
      Menu menu = new Menu(MenuHandlerVoting);
      menu.SetTitle("Enable AllTalk?");
      menu.AddItem("yes", "Yes");
      menu.AddItem("no", "No");
      menu.ExitButton = false;
      menu.DisplayVoteToAll(20);
      PrintToChatAll("[Chill Skies] AllTalk vote has started! Vote now!");
    }
  }
  case 1: {
    if (!IsVoteInProgress()) {
      Menu menu = new Menu(MenuHandlerVoting);
      menu.SetTitle("Enable RTD?");
      menu.AddItem("yes", "Yes");
      menu.AddItem("no", "No");
      menu.ExitButton = false;
      menu.DisplayVoteToAll(20);
      PrintToChatAll("[Chill Skies] RTD vote has started! Vote now!");
    }
  }
  /* To add a new menu, add a new case and copy the template above. */
  /*
  case 2:{
    if (!IsVoteInProgress()){
      Menu menu = new Menu(MenuHandlerVoting);
      menu.SetTitle("Example Vote?");
      menu.AddItem("yes", "Yes");
      menu.AddItem("no", "No");
      menu.ExitButton = false;
      menu.DisplayVoteToAll(20);
      PrintToChatAll("[Chill Skies] Example vote has started! Vote now!");
    }
    
  }
  */
  }
}

public int MenuHandlerVoting(Menu menu, MenuAction action, int result, int choice) {
  if (action == MenuAction_End) delete menu;
  if (action == MenuAction_VoteStart) {
    CPrintToChatAll("{red} Voting. %N chose %i", result, choice);
  }
  else if (action == MenuAction_VoteEnd) {
    switch (menuData) {
    case 0: {
      if (result == 0) {
        PrintToChatAll("[Chill Skies] AllTalk vote has ended! AllTalk will turn on!");
        ServerCommand("sv_alltalk 1");
      }
      if (result == 1) {
        PrintToChatAll("[Chill Skies] AllTalk vote has ended! AllTalk will turn off!");
        ServerCommand("sv_alltalk 0");
      }
    }
    case 1: {
      if (result == 0) {
        PrintToChatAll("[Chill Skies] RTD vote has ended! RTD will be enabled!");
        ServerCommand("sm_cvar sm_rtd2_enabled 1");
      }
      if (result == 1) {
        PrintToChatAll("[Chill Skies] RTD vote has ended! RTD will be disabled!");
        ServerCommand("sm_cvar sm_rtd2_enabled 0");
      }
    }
    /* When adding new votes, make sure to increment case #. */
    /*
     case 2:{
        if(result == 0){
          PrintToChatAll("[Chill Skies] This is an example vote. The result was yes.");
          ServerCommand("sm_thingToDoWhenYES");
        }
        if(result == 1){
          PrintToChatAll("[Chill Skies] This is an example vote. The result was no.");
          ServerCommand("sm_thingToDoWhenNO");
        }
      }
    */
    }
  }
  return 0;
}