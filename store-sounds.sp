#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <smjansson>
#include <store>
#include <morecolors_store>
#include <soundlib>

#define MAX_SOUNDS 512

enum Sound
{
	String:SoundName[STORE_MAX_NAME_LENGTH],
	String:SoundPath[PLATFORM_MAX_PATH],
	Float:SoundVolume,
	String:SoundText[192],
	Float:SoundLength
}

new g_sounds[MAX_SOUNDS][Sound];
new g_soundCount;

new Handle:g_soundsNameIndex;

new g_lastSound = 0;
new Float:g_lastSoundPlayedTime = 0.0;

new Handle:g_hGlobalWaitTimeCvar = INVALID_HANDLE;
new Float:g_waitTime = 2.0;

public Plugin:myinfo =
{
	name        = "[Store] Sounds",
	author      = "alongub",
	description = "Sounds component for [Store]",
	version     = "1.0.3",
	url         = "https://github.com/alongubkin/store-sounds"
};

/**
 * Plugin is loading.
 */
public OnPluginStart()
{
    LoadTranslations("store.phrases");
    LoadTranslations("store-sounds.phrases");

    Store_RegisterItemType("sound", OnSoundUse, OnSoundAttributesLoad);

    g_hGlobalWaitTimeCvar = CreateConVar("store_sounds_global_wait_time", "3.0", "Minimum time in seconds between each sound.");
    HookConVarChange(g_hGlobalWaitTimeCvar, Action_OnSettingsChange);

    AutoExecConfig(true, "store-sounds");

    g_waitTime = GetConVarFloat(g_hGlobalWaitTimeCvar);
}

/** 
 * Called when a new API library is loaded.
 */
public OnLibraryAdded(const String:name[])
{
	if (StrEqual(name, "store-inventory"))
	{
		Store_RegisterItemType("sound", OnSoundUse, OnSoundAttributesLoad);
	}	
}

/**
 * Map is starting.
 */
public OnMapStart()
{
	g_lastSoundPlayedTime = 0.0;
	g_lastSound = 0;

	for (new item = 0; item < g_soundCount; item++)
	{
		decl String:fullSoundPath[PLATFORM_MAX_PATH];
		Format(fullSoundPath, sizeof(fullSoundPath), "sound/%s", g_sounds[item][SoundPath]);

		if (strcmp(fullSoundPath, "") != 0 && (FileExists(fullSoundPath) || FileExists(fullSoundPath, true)))
		{
		    PrecacheSound(g_sounds[item][SoundPath]);
		    AddFileToDownloadsTable(fullSoundPath);
		}
	}
}

public Action_OnSettingsChange(Handle:cvar, const String:oldvalue[], const String:newvalue[])
{
	if (cvar == g_hGlobalWaitTimeCvar)
	{
		g_waitTime = StringToFloat(newvalue);
	}
}

public Store_OnReloadItems() 
{
	if (g_soundsNameIndex != INVALID_HANDLE)
		CloseHandle(g_soundsNameIndex);
		
	g_soundsNameIndex = CreateTrie();
	g_soundCount = 0;
}

public OnSoundAttributesLoad(const String:itemName[], const String:attrs[])
{
	strcopy(g_sounds[g_soundCount][SoundName], STORE_MAX_NAME_LENGTH, itemName);
		
	SetTrieValue(g_soundsNameIndex, g_sounds[g_soundCount][SoundName], g_soundCount);
	
	new Handle:json = json_load(attrs);
	json_object_get_string(json, "path", g_sounds[g_soundCount][SoundPath], PLATFORM_MAX_PATH);

	new Handle:textElement = json_object_get(json, "text");
	if (textElement != INVALID_HANDLE && json_is_string(textElement)) 
	{
		json_string_value(textElement, g_sounds[g_soundCount][SoundText], 192);
		CloseHandle(textElement);
	}

	g_sounds[g_soundCount][SoundVolume] = json_object_get_float(json, "volume");
	if (g_sounds[g_soundCount][SoundVolume] == 0.0)
		g_sounds[g_soundCount][SoundVolume] = 1.0;

	decl String:fullSoundPath[PLATFORM_MAX_PATH];
	Format(fullSoundPath, sizeof(fullSoundPath), "sound/%s", g_sounds[g_soundCount][SoundPath]);
	
	if (strcmp(fullSoundPath, "") != 0 && (FileExists(fullSoundPath) || FileExists(fullSoundPath, true)))
	{
	    PrecacheSound(g_sounds[g_soundCount][SoundPath]);
	    AddFileToDownloadsTable(fullSoundPath);
	}

	new Handle:soundFile = OpenSoundFile(g_sounds[g_soundCount][SoundPath]);
	
	if (soundFile != INVALID_HANDLE) 
	{
		g_sounds[g_soundCount][SoundLength] = GetSoundLengthFloat(soundFile);
		CloseHandle(soundFile); 
	}

	CloseHandle(json);
	g_soundCount++;
}

public Store_ItemUseAction:OnSoundUse(client, itemId, bool:equipped)
{
	if (!IsClientInGame(client))
	{
		return Store_DoNothing;
	}

	if (g_lastSoundPlayedTime != 0.0 && g_lastSound != 0 && GetGameTime() < g_lastSoundPlayedTime + g_sounds[g_lastSound][SoundLength] + g_waitTime)
	{
		PrintToChat(client, "%s%t", STORE_PREFIX, "Wait until sound finishes");
		return Store_DoNothing;
	}

	decl String:itemName[STORE_MAX_NAME_LENGTH];
	Store_GetItemName(itemId, itemName, sizeof(itemName));

	new sound = -1;
	if (!GetTrieValue(g_soundsNameIndex, itemName, sound))
	{
		PrintToChat(client, "%s%t", STORE_PREFIX, "No item attributes");
		return Store_DoNothing;
	}

	decl String:playerName[32];
	GetClientName(client, String:playerName, sizeof(playerName));

	if (StrEqual(g_sounds[sound][SoundText], ""))
	{
		decl String:soundDisplayName[STORE_MAX_DISPLAY_NAME_LENGTH];
		Store_GetItemDisplayName(itemId, soundDisplayName, sizeof(soundDisplayName));

		MoreColors_CPrintToChatAllEx(client, "%t", "Player has played a sound", playerName, soundDisplayName);
	}
	else
	{
		MoreColors_CPrintToChatAllEx(client, "{teamcolor}%s{default} %s!", playerName, g_sounds[sound][SoundText]);
	}

	EmitSoundToAll(g_sounds[sound][SoundPath], SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, g_sounds[sound][SoundVolume]);

	g_lastSound = sound;
	g_lastSoundPlayedTime = GetGameTime();

	return Store_DeleteItem;
}