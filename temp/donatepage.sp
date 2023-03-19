#pragma semicolon 1
#include <sourcemod>

#define CHOICE1 "#choice1"
#define CHOICE2 "#choice2"
#define CHOICE3 "#choice3"

/**
* Public plugin information.
*/
public Plugin myinfo =
{
		name = "Nova.tf Server Functions",
		author = "Sir TonyBear",
		description = "Allows public to use mandatory server commands",
		version = "1.0.2",
		url = "http://nova.tf/"
};

public void OnPluginStart()
{
	LoadTranslations("serverinfo.phrases");
	RegConsoleCmd("sm_forums", Command_ViewForums, "Load the forums page");
	RegConsoleCmd("sm_donate", Command_DonateMenu, "Open Donate Dialog");
	RegConsoleCmd("sm_group", Command_ViewGroup, "View our Steam Group");
	RegConsoleCmd("sm_info", Command_ServerInfo, "View servers information");
}

public int MenuHandler1(Menu menu, MenuAction action, int client, int param2)
{
	switch(action)
	{
		case MenuAction_Start:
		{
		}
		
		case MenuAction_Display:
		{
			char buffer[255];
			Format(buffer, sizeof(buffer), "%T", "Server Info", client);
			
			Panel panel = view_as<Panel>(param2);
			panel.SetTitle(buffer);
			PrintToServer("Client %d was sent menu with panel %x", param2);
		}
		
		case MenuAction_Select:
		{
			char info[32];
			menu.GetItem(param2, info, sizeof(info));
			if (StrEqual(info, CHOICE1))
			{
				FakeClientCommand(client, "sm_forums");
			}
			if (StrEqual(info, CHOICE2))
			{
				FakeClientCommand(client, "sm_donate");
			}
			if (StrEqual(info, CHOICE3))
			{
				FakeClientCommand(client, "sm_group");
			}

			else
			{
				PrintToServer("Something went wrong.", param2);
			}
		}
		case MenuAction_Cancel:
		{
			PrintToServer("Client %d's menu was cancelled for reason %d", param2);
		}
			
		case MenuAction_End:
		{
			delete menu;
		}
			
		case MenuAction_DrawItem:
		{
			int style;
			char info[32];
			menu.GetItem(param2, info, sizeof(info), style);
			
			if (StrEqual(info, CHOICE1))
			{
				return style;
			}
			else
			{
				return style;
			}
		}	
		case MenuAction_DisplayItem:
		{
			int style;
			char info[32];
			menu.GetItem(param2, info, sizeof(info), style);
		}
	}
	return 0;
}

public Action Command_ServerInfo(int client, int args)
{
	Menu menu = new Menu(MenuHandler1, MENU_ACTIONS_ALL);
	menu.SetTitle("%T", "Menu Title", LANG_SERVER);
	menu.AddItem(CHOICE1, "View Forums");
	menu.AddItem(CHOICE2, "Donate Items");
	menu.AddItem(CHOICE3, "View Steam Group");
	menu.ExitButton = true;
	menu.Display(client, 20);
	
	return Plugin_Handled;
}

public Action Command_ViewForums(int client, int args)
{
	ShowMOTDPanel(client, "Nova.tf - Forums", "http://nova.tf/", MOTDPANEL_TYPE_URL);
	return Plugin_Handled;
}

public Action Command_DonateMenu(int client, int args)
{
	ShowMOTDPanel(client, "Nova.tf - Donate", "http://nova.tf/app.php/donation", MOTDPANEL_TYPE_URL);
	return Plugin_Handled;
}

public Action Command_ViewGroup(int client, int args)
{
	ShowMOTDPanel(client, "Nova.tf - Steam Group", "https://steamcommunity.com/groups/Nova_TF", MOTDPANEL_TYPE_URL);
}

