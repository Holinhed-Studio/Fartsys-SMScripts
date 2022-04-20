#pragma semicolon 1

#include <sourcemod>
#include <store>
#include <scp>
#include <smjansson>
#include <colors>
#include <morecolors_store>

enum NameColor
{
	String:NameColorName[STORE_MAX_NAME_LENGTH],
	String:NameColorText[64]
}

new g_namecolors[1024][NameColor];
new g_namecolorCount = 0;

new g_clientNameColors[MAXPLAYERS+1] = { -1, ... };

new Handle:g_namecolorsNameIndex = INVALID_HANDLE;
new bool:g_databaseInitialized = false;

public Plugin:myinfo =
{
	name        = "[Store] Name Colors",
	author      = "Panduh",
	description = "Name Colors component for [Store]",
	version     = "1.1",
	url         = "http://forums.alliedmodders.com/"
};

/**
 * Plugin is loading.
 */
public OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("store.phrases");

	Store_RegisterItemType("namecolor", OnEquip, LoadItem);
}

/** 
 * Called when a new API library is loaded.
 */
public OnLibraryAdded(const String:name[])
{
	if (StrEqual(name, "store-inventory"))
	{
		Store_RegisterItemType("namecolor", OnEquip, LoadItem);
	}	
}

public Store_OnDatabaseInitialized()
{
	g_databaseInitialized = true;
}

/**
 * Called once a client is authorized and fully in-game, and 
 * after all post-connection authorizations have been performed.  
 *
 * This callback is gauranteed to occur on all clients, and always 
 * after each OnClientPutInServer() call.
 *
 * @param client		Client index.
 * @noreturn
 */
public OnClientPostAdminCheck(client)
{
	g_clientNameColors[client] = -1;
	if (!g_databaseInitialized)
		return;
		
	Store_GetEquippedItemsByType(Store_GetClientAccountID(client), "namecolor", Store_GetClientLoadout(client), OnGetPlayerNameColor, GetClientSerial(client));
}

public Store_OnClientLoadoutChanged(client)
{
	g_clientNameColors[client] = -1;
	Store_GetEquippedItemsByType(Store_GetClientAccountID(client), "namecolor", Store_GetClientLoadout(client), OnGetPlayerNameColor, GetClientSerial(client));
}

public Store_OnReloadItems() 
{
	if (g_namecolorsNameIndex != INVALID_HANDLE)
		CloseHandle(g_namecolorsNameIndex);
		
	g_namecolorsNameIndex = CreateTrie();
	g_namecolorCount = 0;
}

public OnGetPlayerNameColor(titles[], count, any:serial)
{
	new client = GetClientFromSerial(serial);
	
	if (client == 0)
		return;
		
	for (new index = 0; index < count; index++)
	{
		decl String:itemName[STORE_MAX_NAME_LENGTH];
		Store_GetItemName(titles[index], itemName, sizeof(itemName));
		
		new namecolor = -1;
		if (!GetTrieValue(g_namecolorsNameIndex, itemName, namecolor))
		{
			PrintToChat(client, "%s%t", STORE_PREFIX, "No item attributes");
			continue;
		}
		
		g_clientNameColors[client] = namecolor;
		break;
	}
}

public LoadItem(const String:itemName[], const String:attrs[])
{
	strcopy(g_namecolors[g_namecolorCount][NameColorName], STORE_MAX_NAME_LENGTH, itemName);
		
	SetTrieValue(g_namecolorsNameIndex, g_namecolors[g_namecolorCount][NameColorName], g_namecolorCount);
	
	new Handle:json = json_load(attrs);	
	
	if (IsSource2009())
	{
		json_object_get_string(json, "color", g_namecolors[g_namecolorCount][NameColorText], 64);
		MoreColors_CReplaceColorCodes(g_namecolors[g_namecolorCount][NameColorText]);
	}
	else
	{
		json_object_get_string(json, "text", g_namecolors[g_namecolorCount][NameColorText], 64);
		CFormat(g_namecolors[g_namecolorCount][NameColorText], 64);
	}

	CloseHandle(json);

	g_namecolorCount++;
}

public Store_ItemUseAction:OnEquip(client, itemId, bool:equipped)
{
	new String:name[32];
	Store_GetItemName(itemId, name, sizeof(name));

	if (equipped)
	{
		g_clientNameColors[client] = -1;
		
		decl String:displayName[STORE_MAX_DISPLAY_NAME_LENGTH];
		Store_GetItemDisplayName(itemId, displayName, sizeof(displayName));
		
		PrintToChat(client, "%s%t", STORE_PREFIX, "Unequipped item", displayName);

		return Store_UnequipItem;
	}
	else
	{
		new namecolor = -1;
		if (!GetTrieValue(g_namecolorsNameIndex, name, namecolor))
		{
			PrintToChat(client, "%s%t", STORE_PREFIX, "No item attributes");
			return Store_DoNothing;
		}
		
		g_clientNameColors[client] = namecolor;
		
		decl String:displayName[STORE_MAX_DISPLAY_NAME_LENGTH];
		Store_GetItemDisplayName(itemId, displayName, sizeof(displayName));
		
		PrintToChat(client, "%s%t", STORE_PREFIX, "Equipped item", displayName);

		return Store_EquipItem;
	}
}

public Action:OnChatMessage(&author, Handle:recipients, String:name[], String:message[])
{
	if (g_clientNameColors[author] != -1)
	{
		if(strlen(g_namecolors[g_clientNameColors[author]][NameColorText]) == 6)
		{
			Format(name, MAXLENGTH_NAME, "\x07%s%s", g_namecolors[g_clientNameColors[author]][NameColorText], name);
			return Plugin_Changed;
		}
		else if(strlen(g_namecolors[g_clientNameColors[author]][NameColorText]) == 8)
		{
			Format(name, MAXLENGTH_NAME, "\x08%s%s", g_namecolors[g_clientNameColors[author]][NameColorText], name);
			return Plugin_Changed;
		}		
	}
	
	return Plugin_Continue;
}

stock bool:IsSource2009()
{
	return (SOURCE_SDK_CSS <= GuessSDKVersion() < SOURCE_SDK_LEFT4DEAD);
}