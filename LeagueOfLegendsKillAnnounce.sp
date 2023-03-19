/*
 *
 * File Name : LeagueOfLegendsKillAnnounce.sp
 * File Version : 2.8.5
 * File Updated date : 08-10-2013
 *
 * =============================================================================
 * League Of Legends Kill Announce Plugin
 * Copyright (C)2010-2012 Chamamyungsu All rights reserved.
 * =============================================================================
 * 
 * 이 프로그램은 자유 소프트웨어입니다: 당신은 이것을 자유 소프트웨어 재단이
 * 발표한 GNU 일반 공중 사용허가서의 제3 버전이나 (선택에 따라) 그 이후 버전
 * 의 조항 아래 재배포하거나 수정할 수 있습니다.
 * 
 * 이 프로그램은 유용하게 쓰이리라는 희망 아래 배포되지만, 특정한 목적에 대한
 * 프로그램의 적합성이나 상업성 여부에 대한 보증을 포함한 어떠한 형태의 보증
 * 도 하지 않습니다. 세부 사항은 GNU 일반 공중 사용허가서를 참조하십시오.
 * 
 * 당신은 이 프로그램과 함께 GNU 일반 공중 사용허가서를 받았을 것입니다.
 * 만약 그렇지 않다면, < http://www.gnu.org/licences/ >를 보십시오.
 * 
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Edited by DovahkiWarrior. https://forums.firehostredux.net
 */


#define PLUGIN_VERSION "2.8.5"
public Plugin:myinfo =
{
	name = "League Of Legends Kill Announce Plugin",
	author = "Chamamyungsu",
	description = "Made for Server, Thanks to RIOT Games, Javalia",
	version = PLUGIN_VERSION,
	url = "http://cafe.naver.com/sourcemulti"
};

#include <sourcemod>
#include <sdktools>
#include "stocklib"

#pragma semicolon 1

#define LKA_FirstBlood		(1 << 0)	// First Blood
#define LKA_ShutDown		(1 << 1)	// Shut down
#define LKA_Multikill				(1 << 2)	// multikill
#define LKA_KillingSpree		(1 << 3)	// Killing Spree
#define LKA_ACE					(1 << 4)	// ACE
#define LKA_Slain				(1 << 5)	// Slain
#define LKA_Executed			(1 << 6)	// Executed

#define Type_allAlert				0
#define Type_chatMessage	1
#define Type_centerHUD			2
#define Type_playSound			3

/**
 * variable : reserveState / Description
 * 
 * First Element : Attacker Index
 * Second Element : client (Victim) Index
 * Third Element : State Index ; 1-Executed 2-First blood 3-Shut down 4-multikill 5-Killing Spree 6-ACE, 7-Slain
 * Fourth Element : Kill Count
 */
new reserveState[MAXPLAYERS+1][4];
 
new bool:roundFirstblood = false;
new Killcount[MAXPLAYERS+1];
new consecutivelyKill[MAXPLAYERS+1];
new Float:consecutivelyKill_Timer[MAXPLAYERS+1];
new Float:announceTimer = 0.0;
new aceCheck[4] = 0;

new String:gamename[64];

new allAlert_Off[MAXPLAYERS+1];
new chatMessage_Off[MAXPLAYERS+1];
new centerHUD_Off[MAXPLAYERS+1];
new playSound_Off[MAXPLAYERS+1];
new Float:volumeValue[MAXPLAYERS+1] = 1.0;

new String:path[MAXPLAYERS+1];
new loadCheck[MAXPLAYERS+1];

new Handle:announceTimer_handle = INVALID_HANDLE;

new Handle:g_consecutivelyKillcontinuetime = INVALID_HANDLE;
new Handle:g_announceCooltime = INVALID_HANDLE;
new Handle:g_killingspree = INVALID_HANDLE;
new Handle:g_rampage = INVALID_HANDLE;
new Handle:g_unstoppable = INVALID_HANDLE;
new Handle:g_dominating = INVALID_HANDLE;
new Handle:g_god_like = INVALID_HANDLE;
new Handle:g_legendary = INVALID_HANDLE;
new Handle:g_slainOn = INVALID_HANDLE;
new Handle:g_oldslainOn = INVALID_HANDLE;
new Handle:g_aceOn= INVALID_HANDLE;
new Handle:g_serverJoinsoundOn = INVALID_HANDLE;
new Handle:g_executedOn= INVALID_HANDLE;
new Handle:g_legendaryRepeat = INVALID_HANDLE;
new Handle:g_pentakillRepeat = INVALID_HANDLE;
new Handle:g_MeleeWeaponList = INVALID_HANDLE;

#include "LOL/LOLsound"

public OnPluginStart()
{
	CreateConVar("sm_LOLannounce_version", PLUGIN_VERSION, "Made By Chamamyungsu", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

	g_consecutivelyKillcontinuetime = CreateConVar("LOLannounce_ConsecutivelyKillContinueTime", "5", "set the Kill Continue Time (seconds)");
	g_announceCooltime = CreateConVar("LOLannounce_Announce_Cooltime", "2", "set the announce cooltime (seconds)");
	g_killingspree = CreateConVar("LOLannounce_Killingspree", "4", "Kills streak required to trigger sound");
	g_rampage = CreateConVar("LOLannounce_Rampage", "5", "Kills streak required to trigger sound");
	g_unstoppable = CreateConVar("LOLannounce_Unstoppable", "7", "Kills streak required to trigger sound");
	g_dominating = CreateConVar("LOLannounce_Dominating", "10", "Kills streak required to trigger sound");
	g_god_like = CreateConVar("LOLannounce_God_Like", "14", "Kills streak required to trigger sound");
	g_legendary = CreateConVar("LOLannounce_Legendary", "19", "Kills streak required to trigger sound");
	g_slainOn = CreateConVar("LOLannounce_Slainonoff", "1", "Turn on slain event 1 = on, 0 = off");
	g_oldslainOn = CreateConVar("LOLannounce_OldSlainonoff", "0", "(if slain event turn on) Turn on Old slain event 1 = on, 0 = off");
	g_aceOn = CreateConVar("LOLannounce_Aceonoff", "1", "Turn on ace event 1 = on, 0 = off");
	g_legendaryRepeat = CreateConVar("LOLannounce_Legendaryrepeat", "3", "if player has over legendary is when the kill 3 times repeat legendary sound and message (0 = off)");
	g_pentakillRepeat = CreateConVar("LOLannounce_Pentakillrepeat", "1", " Turn on when player has over pentakill is repeat pentakill sound and message 1 = on, 0 = off");
	g_executedOn = CreateConVar("LOLannounce_Executedonoff", "1", " Turn on executed event 1 = on, 0 = off");
	g_serverJoinsoundOn = CreateConVar("LOLannounce_JoinSoundonoff", "1", " Turn on Server join sound 1 = on, 0 = off");
	g_MeleeWeaponList = CreateConVar("LOLannounce_SlayMeleeWeaponList",
						"tf_weapon_sword;tf_weapon_wrench;tf_weapon_robot_arm;tf_weapon_fists;tf_weapon_bonesaw;tf_weapon_fireaxe;tf_weapon_bat;tf_weapon_bat_wood;tf_weapon_bat_fish;tf_weapon_club;tf_weapon_shovel;tf_weapon_knife;tf_weapon_stickbomb;tf_weapon_katana;tf_weapon_knife;weapon_knife",
						"MeleeWeaponList... ;");
	AutoExecConfig();
	
	GetGameFolderName(gamename, sizeof(gamename));
	
	BuildPath(Path_SM, path, MAXPLAYERS+1, "data/LOLAnnounceSettings_v2.txt");
	
	RegConsoleCmd("sm_lolsettings", Command_Announcemenu, "Open the LOLAnnounce Setting Menu");
	HookEvent("player_spawn", EventSpawn);
	HookEvent("player_death", EventDeath);
	
	if(StrEqual(gamename, "tf")){
		HookEvent("teamplay_round_start", roundstart_event);
	}
	else if(StrEqual(gamename, "dod")){
		HookEvent("dod_round_start", roundstart_event);
	}
	else if(StrEqual(gamename, "cstrike") || StrEqual(gamename, "csgo")){
		HookEvent("round_start", roundstart_event);
	}

	LoadTranslations("LeagueOfLegendsKillAnnounce.phrases");
	announceTimer_handle = CreateTimer(0.1, announce_timer, _, TIMER_REPEAT);
	announceTimer = 0.0;
}

public Action:Command_Announcemenu(client, args)
{
	settingMenu(client);
	return Plugin_Handled;
}

settingMenu(client)
{
	new Handle:settingmenu = CreateMenu(Menu_Settings);

	SetMenuTitle(settingmenu, "--=LOL Announce Settings=--");
	
	decl String:buffer[256];
	if(allAlert_Off[client] == 1)
	{
		Format(buffer, sizeof(buffer), "%t", "enabled!", "LOLannounce");
		AddMenuItem(settingmenu, " ", buffer);
		Format(buffer, sizeof(buffer), "%t%t", "Chat", "Settings");
		AddMenuItem(settingmenu, " ", buffer, ITEMDRAW_DISABLED);
		Format(buffer, sizeof(buffer), "%t%t", "Centerhud", "Settings");
		AddMenuItem(settingmenu, " ", buffer, ITEMDRAW_DISABLED);
		Format(buffer, sizeof(buffer), "%t%t", "Playsound", "Settings");
		AddMenuItem(settingmenu, " ", buffer, ITEMDRAW_DISABLED);
	}
	else
	{
		Format(buffer, sizeof(buffer), "%t", "disabled!", "LOLannounce");
		AddMenuItem(settingmenu, " ", buffer);
		Format(buffer, sizeof(buffer), "%t%t", "Chat", "Settings");
		AddMenuItem(settingmenu, " ", buffer);
		Format(buffer, sizeof(buffer), "%t%t", "Centerhud", "Settings");
		AddMenuItem(settingmenu, " ", buffer);
		Format(buffer, sizeof(buffer), "%t%t", "Playsound", "Settings");
		AddMenuItem(settingmenu, " ", buffer);
	}

	SetMenuExitButton(settingmenu, true);
	DisplayMenu(settingmenu, client, 20);
}

public Menu_Settings(Handle:menu, MenuAction:action, client, Select)
{
	if(action == MenuAction_Select)
	{
		if(Select == Type_allAlert)
		{
			if(allAlert_Off[client] == 0){
				allAlert_Off[client] = 1;
			}
			else{
				allAlert_Off[client] = 0;
			}

			settingMenu(client);
		}
		else
			settingMenu_Detail(client, Select);
	}

	if(action == MenuAction_End)
		CloseHandle(menu);
}

settingMenu_Detail(client, select)
{
	new Handle:settingmenu = CreateMenu(Menu_settingsDetail);

	new String:titleUnitTemp[4][32]={"N/A", "Chat Message","CenterHUD","Sound"};
	new String:nameFormat[64];

	Format(nameFormat, sizeof(nameFormat), "--=LOL Announce %s Settings=--", titleUnitTemp[select]);
	SetMenuTitle(settingmenu, nameFormat);
	
	decl String:buffer[128], String:selectStr[8];
	IntToString(select, selectStr, sizeof(selectStr));
	new String:inputUnitTemp[7][16]={"Firstblood", "Shutdown","Multikill","Killingspree","Ace","Slain","Executed"};

	for(new i=0; i<=6; i++)
	{
		if(IsStateisOff(client, select, 1<<i)){ // Line 54 ~ 60 //
			Format(buffer, sizeof(buffer), "%t", "enabled!", inputUnitTemp[i]);
		}
		else{
			Format(buffer, sizeof(buffer), "%t", "disabled!", inputUnitTemp[i]);
		}

		AddMenuItem(settingmenu, selectStr, buffer);
	}

	if(select == Type_playSound)
	{
		Format(buffer, sizeof(buffer), "%t", "VolumeSetMenu", client);
		AddMenuItem(settingmenu, selectStr, buffer);
	}
	
	SetMenuExitButton(settingmenu, true);
	SetMenuExitBackButton(settingmenu, true);

	DisplayMenu(settingmenu, client, 20);
}

public IsStateisOff(client, type, input)
{
	if(type == Type_chatMessage)
	{
		if(chatMessage_Off[client] & input){
			return true;
		}
	}
	else if(type == Type_centerHUD)
	{
		if(centerHUD_Off[client] & input){
			return true;
		}
	}
	else
	{
		if(playSound_Off[client] & input){
			return true;
		}
	}

	return false;
}

public Menu_settingsDetail(Handle:menu, MenuAction:action, client, select)
{
	if(action == MenuAction_Select)
	{
		new String:typeTemp[8];
		GetMenuItem(menu, select, typeTemp, sizeof(typeTemp));
		new type = StringToInt(typeTemp);

		if(select <= 6)
		{
			for(new i=0; i<=6; i++)
			{
				if(select == i){
					changeState(client, type, 1<<i);
				}
			}
			settingMenu_Detail(client, type);
		}
		else{
			VolumeMenu(client);
		}
	}

	if(action == MenuAction_Cancel)
	{
		if(select == MenuCancel_ExitBack){
			settingMenu(client);
		}
	}

	if(action == MenuAction_End){
		CloseHandle(menu);
	}
}

public changeState(client, type, input)
{
	if(type == Type_chatMessage)
	{
		if(IsStateisOff(client, type, input)){
			chatMessage_Off[client] -= input;
		}
		else{
			chatMessage_Off[client] += input;
		}
	}
	else if(type == Type_centerHUD)
	{
		if(IsStateisOff(client, type, input)){
			centerHUD_Off[client] -= input;
		}
		else{
			centerHUD_Off[client] += input;
		}
	}
	else
	{
		if(IsStateisOff(client, type, input)){
			playSound_Off[client] -= input;
		}
		else{
			playSound_Off[client] += input;
		}
	}
}

VolumeMenu(client)
{
	new Handle:settingmenu = CreateMenu(Menu_VolumeSettings);
	SetMenuTitle(settingmenu, "--=LOL Announce Volume Settings=--");
	
	decl String:buffer[256];

	Format(buffer, sizeof(buffer), "%t", "YourVolumeValue", RoundToNearest(volumeValue[client]*100));
	AddMenuItem(settingmenu, " ", buffer, ITEMDRAW_DISABLED);

	Format(buffer, sizeof(buffer), "%t", "VolumeUp", client);
	if(volumeValue[client] >= 1.0){
		AddMenuItem(settingmenu, " ", buffer, ITEMDRAW_DISABLED);
	}
	else{
		AddMenuItem(settingmenu, " ", buffer);
	}

	Format(buffer, sizeof(buffer), "%t", "VolumeDown", client);
	if(volumeValue[client] <= 0.0){
		AddMenuItem(settingmenu, " ", buffer, ITEMDRAW_DISABLED);
	}
	else{
		AddMenuItem(settingmenu, " ", buffer);
	}
	
	SetMenuExitButton(settingmenu, true);
	SetMenuExitBackButton(settingmenu, true);
	DisplayMenu(settingmenu, client, 20);
}

public Menu_VolumeSettings(Handle:menu, MenuAction:action, client, Select)
{
	if(action == MenuAction_Select)
	{
		if(Select == 1){
			volumeValue[client] += 0.1;
		}
		if(Select == 2){
			volumeValue[client] -= 0.1;
		}

		VolumeMenu(client);
	}

	if(action == MenuAction_Cancel)
	{
		if(Select == MenuCancel_ExitBack){
			settingMenu(client);
		}
	}

	if(action == MenuAction_End){
		CloseHandle(menu);
	}
}

public OnMapStart()
{
	AutoExecConfig();
	prepatch_and_download_sounds();
	announceTimer = 0.0;
}

public EventSpawn(Handle:Spawn_Event, const String:Spawn_Name[], bool:Spawn_Broadcast)
{
	new client = GetClientOfUserId(GetEventInt(Spawn_Event, "userid"));
	aceCheck[GetClientTeam(client)] = 0;
}

public Action:roundstart_event(Handle:Event, const String:Name[], bool:Broadcast)
{
	roundFirstblood = false;
	aceCheck[TEAM_RED] = 0;
	aceCheck[TEAM_BLUE] = 0;
	for(new i=0; i<=MAXPLAYERS*2; i++)
	{
		if(reserveState[i][2] != 0)
		{
			reserveState[i][0] = 0;
			reserveState[i][1] = 0;
			reserveState[i][2] = 0;
			reserveState[i][3] = 0;
		}
		else{
			break;
		}
	}
}

public OnClientPutInServer(client)
{
	if(!IsFakeClient(client) && isClientConnectedIngame(client))
	{
		Killcount[client] = 0;
		consecutivelyKill[client] = 0;
		consecutivelyKill_Timer[client] = 0.0;
		allAlert_Off[client] = 0;
		chatMessage_Off[client] = 0;
		centerHUD_Off[client] = 0;
		playSound_Off[client] = 0;
		volumeValue[client] = 1.0;

		for(new i=1; i<=MAXPLAYERS; i++)
		{
			if(reserveState[i][2] > 0)
			{
				if(reserveState[i][0] == client || reserveState[i][1] == client){
					reserveState[i][2] = 0;
				}
			}
			else{
				break;
			}
		}
		
		if(GetConVarInt(g_serverJoinsoundOn) == 1){
			playsoundfromclient(client, SOUNDSERVERJOIN);
		}
		
		CreateTimer(2.0, Load, client);
	}
}

public OnClientDisconnect(client)
{
	if(loadCheck[client] == 1){
		Save(client);
	}
}

public Save(client)
{
	if(client > 0 && IsClientInGame(client))
	{
		new String:SteamID[32];
		GetClientAuthString(client, SteamID, 32);

		decl Handle:Vault;

		Vault = CreateKeyValues("Vault");

		if(FileExists(path)){
			FileToKeyValues(Vault, path);
		}

		if(allAlert_Off[client] == 1)
		{	
			KvJumpToKey(Vault, "allAlert_Off", true);
			KvSetNum(Vault, SteamID, allAlert_Off[client]);
			KvRewind(Vault);
		}
		else
		{
			KvJumpToKey(Vault, "allAlert_Off", false);
			KvDeleteKey(Vault, SteamID);
			KvRewind(Vault);
		}

		if(chatMessage_Off[client] >= 1)
		{	
			KvJumpToKey(Vault, "chatMessage_Off", true);
			KvSetNum(Vault, SteamID, chatMessage_Off[client]);
			KvRewind(Vault);
		}
		else
		{
			KvJumpToKey(Vault, "chatMessage_Off", false);
			KvDeleteKey(Vault, SteamID);
			KvRewind(Vault);
		}
		
		if(centerHUD_Off[client] >= 1)
		{
			KvJumpToKey(Vault, "centerHUD_Off", true);
			KvSetNum(Vault, SteamID, centerHUD_Off[client]);
			KvRewind(Vault);
		}
		else
		{
			KvJumpToKey(Vault, "centerHUD_Off", false);
			KvDeleteKey(Vault, SteamID);
			KvRewind(Vault);
		}
		
		if(playSound_Off[client] >= 1)
		{
			KvJumpToKey(Vault, "playSound_Off", true);
			KvSetNum(Vault, SteamID, playSound_Off[client]);
			KvRewind(Vault);
		}
		else
		{
			KvJumpToKey(Vault, "playSound_Off", false);
			KvDeleteKey(Vault, SteamID);
			KvRewind(Vault);
		}
		
		if(volumeValue[client] != 1.0)
		{
			KvJumpToKey(Vault, "Volumevalue", true);
			KvSetFloat(Vault, SteamID, volumeValue[client]);
			KvRewind(Vault);
		}
		else
		{
			KvJumpToKey(Vault, "Volumevalue", false);
			KvDeleteKey(Vault, SteamID);
			KvRewind(Vault);
		}

		KvRewind(Vault);
		
		loadCheck[client] = 0;
		
		KeyValuesToFile(Vault, path);
		CloseHandle(Vault);
	}
}

public Action:Load(Handle:Timer, any:client)
{
	if(client > 0 && client <= MaxClients)
	{
		new String:SteamID[32];
		GetClientAuthString(client, SteamID, 32);

		decl Handle:Vault;
	
		Vault = CreateKeyValues("Vault");

		FileToKeyValues(Vault, path);

		KvJumpToKey(Vault, "allAlert_Off", false);
		allAlert_Off[client] = KvGetNum(Vault, SteamID);
		KvRewind(Vault);

		KvJumpToKey(Vault, "chatMessage_Off", false);
		chatMessage_Off[client] = KvGetNum(Vault, SteamID);
		KvRewind(Vault);
		
		KvJumpToKey(Vault, "centerHUD_Off", false);
		centerHUD_Off[client] = KvGetNum(Vault, SteamID);
		KvRewind(Vault);
		
		KvJumpToKey(Vault, "playSound_Off", false);
		playSound_Off[client] = KvGetNum(Vault, SteamID);
		KvRewind(Vault);
		
		KvJumpToKey(Vault, "Volumevalue", false);
		volumeValue[client] = KvGetFloat(Vault, SteamID, 1.0);
		KvRewind(Vault);

		loadCheck[client] = 1;

		KvRewind(Vault);
		CloseHandle(Vault);
	}
}

public Action:EventDeath(Handle:Spawn_Event, const String:Spawn_Name[], bool:Spawn_Broadcast)
{
	new client = GetClientOfUserId(GetEventInt(Spawn_Event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(Spawn_Event, "attacker"));

	new String:weapon[32];
	GetEventString(Spawn_Event, "weapon", weapon, sizeof(weapon));

	if(!(client == 0) && !(attacker == 0))
	{
		//Event Check
		if(client == attacker)
		{
			if(GetConVarInt(g_executedOn) == 1){
				announce_reserve(attacker, client, 1, 0);
			}
		}
		else 
		{
			new Float:now = GetEngineTime();

			if(consecutivelyKill_Timer[attacker] <= now){
				consecutivelyKill[attacker] = 0;
			}
			consecutivelyKill_Timer[attacker] = GetEngineTime() + GetConVarInt(g_consecutivelyKillcontinuetime);
			consecutivelyKill[attacker] += 1;
			Killcount[attacker] += 1;

			if(roundFirstblood == false && attacker > 0 && client != attacker)
			{
				roundFirstblood = true;
				announce_reserve(attacker, client, 2, 0);

				if(Killcount[client] >= GetConVarInt(g_killingspree)){
					announce_reserve(attacker, client, 3, consecutivelyKill[attacker]);
				}
			}
			else if(Killcount[client] >= GetConVarInt(g_killingspree)){
				announce_reserve(attacker, client, 3, consecutivelyKill[attacker]);
			}
			else if(consecutivelyKill[attacker] >= 2){
				announce_reserve(attacker, client, 4, consecutivelyKill[attacker]);
			}
			else if(GetConVarInt(g_slainOn) == 1 && isplayerKillingSpree(attacker) == 0)
			{
				if(GetConVarInt(g_oldslainOn) == 1){
					announce_reserve(attacker, client, 7, consecutivelyKill[attacker]);
				}
				else if(IsSlainWeapon(weapon)){
					announce_reserve(attacker, client, 7, consecutivelyKill[attacker]);
				}
			}

			if(isplayerKillingSpree(attacker) == 1)
			{
				if(Killcount[attacker] > GetConVarInt(g_legendary) && GetConVarInt(g_legendaryRepeat) > 0)
				{
					if((Killcount[attacker]-GetConVarInt(g_legendary))%GetConVarInt(g_legendaryRepeat) == 0){
						announce_reserve(attacker, client, 5, Killcount[attacker]);
					}
				}
				else{
					announce_reserve(attacker, client, 5, Killcount[attacker]);
				}
			}
		}
		acecheckevent(attacker, client);

		if(announceTimer == 0.0){
			announceTimer = GetEngineTime();
		}
		Killcount[client] = 0;
	}
	else if(!(client == 0) && (attacker == 0))
	{
		if(GetConVarInt(g_executedOn) == 1){
			announce_reserve(attacker, client, 1, 0);
		}
	}
}

isplayerKillingSpree(attacker)
{
	if(Killcount[attacker] == GetConVarInt(g_killingspree) || Killcount[attacker] == GetConVarInt(g_rampage) || Killcount[attacker] == GetConVarInt(g_unstoppable) || Killcount[attacker] == GetConVarInt(g_dominating) || Killcount[attacker] == GetConVarInt(g_god_like) || Killcount[attacker] >= GetConVarInt(g_legendary)){
		return 1;
	}
	else{
		return 0;
	}
}

acecheckevent(attacker, client)
{
	if(GetConVarInt(g_aceOn) == 1)
	{
		if(aceCheck[GetClientTeam(client)] == 0)
		{
			new bool:clientTeamisAce=true;
			for(new i=1; i<=MaxClients; i++)
			{
				if(isClientConnectedIngameAlive(i) && GetClientTeam(client) == GetClientTeam(i) && client != i)
				{
					clientTeamisAce = false;
					break;
				}
			}
			if(clientTeamisAce == true)
			{
				aceCheck[GetClientTeam(client)] = 1;
				announce_reserve(attacker, client, 6, 0);
				return 1;
			}
		}
	}
	return 0;
}

public Action:announce_timer(Handle:timer)
{
	new Float:now = GetEngineTime();

	if(announceTimer <= now)
	{
		if(reserveState[0][2] > 0)
		{
			for(new i=1; i<=MaxClients; i++)
			{
				if(isClientConnectedIngame(reserveState[0][0]) && isClientConnectedIngame(reserveState[0][1]))
				{
					if(isClientConnectedIngame(i) && allAlert_Off[i] == 0)
					{
						decl String:attackername[64], String:clientname[64];
						GetClientName(reserveState[0][0], attackername, 64);
						if(reserveState[0][1] > 0){
							GetClientName(reserveState[0][1], clientname, 64);
						}

						new teamtemp = GetClientTeam(reserveState[0][0]);

						///// Execute Event /////
						if(reserveState[0][2] == 1)
						{
							if(!(playSound_Off[i] & LKA_Executed)){
								playsoundfromclient(i, SOUNDEXECUTED);
							}

							if(!(centerHUD_Off[i] & LKA_Executed)){
								PrintCenterText(i, "%t", "{1} has executed!", attackername);
							}
						}

						///// First Blood Event /////
						else if(reserveState[0][2] == 2)
						{
							if(!(playSound_Off[i] & LKA_FirstBlood)){
								playsoundfromclient(i, SOUNDFIRSTBLOOD);
							}

							if(!(chatMessage_Off[i] & LKA_FirstBlood)){
								PrintToChat(i, "\x05%t", "{1} has drawn first blood!", attackername);
							}

							if(!(centerHUD_Off[i] & LKA_FirstBlood)){
								PrintCenterText(i, "%t", "centerfirstblood", i);
							}
						}

						///// Shut Down Event /////
						else if(reserveState[0][2] == 3)
						{
							if(!(playSound_Off[i] & LKA_ShutDown)){
								playsoundfromclient(i, SOUNDSHUTDOWN);
							}

							if(!(chatMessage_Off[i] & LKA_ShutDown))
							{
								if(reserveState[0][3] == 1 || (reserveState[0][3] > 5 && GetConVarInt(g_pentakillRepeat) == 0)){
									PrintToChat(i, "\x05%t", "{1} has ended {2}'s killing spree", attackername, clientname);
								}
								if(reserveState[0][3] == 2){
									PrintToChat(i, "\x05%t", "{1} has ended {2}'s killing spree for a double kill!", attackername, clientname);
								}
								if(reserveState[0][3] == 3){
									PrintToChat(i, "\x05%t", "{1} has ended {2}'s killing spree for a triple kill!", attackername, clientname);
								}
								if(reserveState[0][3] == 4){
									PrintToChat(i, "\x05%t", "{1} has ended {2}'s killing spree for a quadra kill!", attackername, clientname);
								}
								if((reserveState[0][3] >= 5 && GetConVarInt(g_pentakillRepeat) == 1) || (reserveState[0][3] == 5 && GetConVarInt(g_pentakillRepeat) == 0)){
									PrintToChat(i, "\x05%t", "{1} has ended {2}'s killing spree for a penta kill!", attackername, clientname);
								}
							}

							if(!(centerHUD_Off[i] & LKA_ShutDown)){
								PrintCenterText(i, "%t", "centershutdown", i);
							}
						}

						///// Multi Kill Event /////
						else if(reserveState[0][2] == 4)
						{
							if(reserveState[0][3] == 2)
							{
								if(!(chatMessage_Off[i] & LKA_Multikill)){
									PrintToChat(i, "\x05%t", "{1} has slain {2} for a double kill!", attackername, clientname);
								}

								if(!(centerHUD_Off[i] & LKA_Multikill)){
									PrintCenterText(i, "%t", "centerdoublekill", i);
								}

								if(!(playSound_Off[i] & LKA_Multikill))
								{
									if(teamtemp == GetClientTeam(i)){
										playsoundfromclient(i, GetRandomInt(16, 18));
									}
									else{
										playsoundfromclient(i, GetRandomInt(14, 15));
									}
								}
							}
							else if(reserveState[0][3] == 3)
							{
								if(!(chatMessage_Off[i] & LKA_Multikill))
									PrintToChat(i, "\x05%t", "{1} has slain {2} for a triple kill!", attackername, clientname);
								if(!(centerHUD_Off[i] & LKA_Multikill))
									PrintCenterText(i, "%t", "centertriplekill", i);
								if(!(playSound_Off[i] & LKA_Multikill))
								{
									if(teamtemp == GetClientTeam(i))
										playsoundfromclient(i, GetRandomInt(21, 22));
									else
										playsoundfromclient(i, GetRandomInt(19, 20));
								}
							}
							else if(reserveState[0][3] == 4)
							{
								if(!(chatMessage_Off[i] & LKA_Multikill))
									PrintToChat(i, "\x05%t", "{1} has slain {2} for a quadra kill!", attackername, clientname);
								if(!(centerHUD_Off[i] & LKA_Multikill))
									PrintCenterText(i, "%t", "centerquadrakill", i);
								if(!(playSound_Off[i] & LKA_Multikill))
								{
									if(teamtemp == GetClientTeam(i))
										playsoundfromclient(i, GetRandomInt(24, 25));
									else
										playsoundfromclient(i, SOUNDENEMYQUADRAKILL);
								}
							}
							else if((reserveState[0][3] >= 5 && GetConVarInt(g_pentakillRepeat) == 1) || (reserveState[0][3] == 5 && GetConVarInt(g_pentakillRepeat) == 0))
							{
								if(!(chatMessage_Off[i] & LKA_Multikill))
									PrintToChat(i, "\x05%t", "{1} has slain {2} for a penta kill!", attackername, clientname);
								if(!(centerHUD_Off[i] & LKA_Multikill))
									PrintCenterText(i, "%t", "centerpentakill", i);
								if(!(playSound_Off[i] & LKA_Multikill))
								{
									if(teamtemp == GetClientTeam(i))
										playsoundfromclient(i, GetRandomInt(28, 29));
									else
										playsoundfromclient(i, GetRandomInt(26, 27));
								}
							}
						}

						///// Killing Spree Event //////
						else if(reserveState[0][2] == 5)
						{
							if(reserveState[0][3] == GetConVarInt(g_killingspree))
							{
								if(!(chatMessage_Off[i] & LKA_KillingSpree)){
									PrintToChat(i, "\x05%t", "{1} is on a killing spree!", attackername);
								}
								
								if(!(centerHUD_Off[i] & LKA_KillingSpree)){
									PrintCenterText(i, "%t", "{1} is on a killing spree!", attackername);
								}
								
								if(!(playSound_Off[i] & LKA_KillingSpree))
								{
									if(teamtemp == GetClientTeam(i)){
										playsoundfromclient(i, GetRandomInt(33, 34));
									}
									else{
										playsoundfromclient(i, GetRandomInt(31, 32));
									}
								}
							}
							else if(reserveState[0][3] == GetConVarInt(g_rampage))
							{
								if(!(chatMessage_Off[i] & LKA_KillingSpree)){
									PrintToChat(i, "\x05%t", "{1} is on a rampage!", attackername);
								}
								
								if(!(centerHUD_Off[i] & LKA_KillingSpree)){
									PrintCenterText(i, "%t", "{1} is on a rampage!", attackername);
								}
								
								if(!(playSound_Off[i] & LKA_KillingSpree))
								{
									if(teamtemp == GetClientTeam(i)){
										playsoundfromclient(i, GetRandomInt(36, 37));
									}
									else{
										playsoundfromclient(i, SOUNDENEMYRAMPAGE);
									}
								}
							}
							else if(reserveState[0][3] == GetConVarInt(g_unstoppable))
							{
								if(!(chatMessage_Off[i] & LKA_KillingSpree)){
									PrintToChat(i, "\x05%t", "{1} is unstoppable!", attackername);
								}
								
								if(!(centerHUD_Off[i] & LKA_KillingSpree)){
									PrintCenterText(i, "%t", "{1} is unstoppable!", attackername);
								}
								
								if(!(playSound_Off[i] & LKA_KillingSpree))
								{
									if(teamtemp == GetClientTeam(i)){
										playsoundfromclient(i, SOUNDUNSTOPPABLE);
									}
									else{
										playsoundfromclient(i, GetRandomInt(38, 39));
									}
								}
							}
							else if(reserveState[0][3] == GetConVarInt(g_dominating))
							{
								if(!(chatMessage_Off[i] & LKA_KillingSpree)){
									PrintToChat(i, "\x05%t", "{1} is dominating!", attackername);
								}
								
								if(!(centerHUD_Off[i] & LKA_KillingSpree)){
									PrintCenterText(i, "%t", "{1} is dominating!", attackername);
								}
								
								if(!(playSound_Off[i] & LKA_KillingSpree))
								{
									if(teamtemp == GetClientTeam(i)){
										playsoundfromclient(i, SOUNDDOMINATING);
									}
									else{
										playsoundfromclient(i, SOUNDENEMYDOMINATING);
									}
								}
							}
							else if(reserveState[0][3] == GetConVarInt(g_god_like))
							{
								if(!(chatMessage_Off[i] & LKA_KillingSpree)){
									PrintToChat(i, "\x05%t", "{1} is god like!", attackername);
								}
								
								if(!(centerHUD_Off[i] & LKA_KillingSpree)){
									PrintCenterText(i, "%t", "{1} is god like!", attackername);
								}
								
								if(!(playSound_Off[i] & LKA_KillingSpree))
								{
									if(teamtemp == GetClientTeam(i)){
										playsoundfromclient(i, GetRandomInt(45, 46));
									}
									else{
										playsoundfromclient(i, GetRandomInt(43, 44));
									}
								}
							}
							else if(reserveState[0][3] == GetConVarInt(g_legendary))
							{
								if(!(chatMessage_Off[i] & LKA_KillingSpree)){
									PrintToChat(i, "\x05%t", "{1} is legendary!", attackername);
								}
								
								if(!(centerHUD_Off[i] & LKA_KillingSpree)){
									PrintCenterText(i, "%t", "{1} is legendary!", attackername);
								}
								
								if(!(playSound_Off[i] & LKA_KillingSpree))
								{
									if(teamtemp == GetClientTeam(i)){
										playsoundfromclient(i, GetRandomInt(49, 51));
									}
									else{
										playsoundfromclient(i, GetRandomInt(47, 48));
									}
								}
							}
						}

						///// ACE Event /////
						else if(reserveState[0][2] == 6)
						{
							if(!(playSound_Off[i] & LKA_ACE)){
								playsoundfromclient(i, GetRandomInt(12, 13));
							}
							
							if(!(centerHUD_Off[i] & LKA_ACE)){
								PrintCenterText(i, "%t", "ACE!", i);
							}
							
							if(!(chatMessage_Off[i] & LKA_ACE))
							{
								if(GetClientTeam(reserveState[0][1]) == GetClientTeam(i)){
									PrintToChat(i, "\x05%t", "ENEMY ACE!", i);
								}
								else{
									PrintToChat(i, "\x05%t", "ALLY ACE!", i);
								}
							}
						}

						///// Slain Event /////
						else if(reserveState[0][2] == 7)
						{
							if(acecheckevent(reserveState[0][0], reserveState[0][1]) == 0)
							{
								if(!(centerHUD_Off[i] & LKA_Slain)){
									PrintCenterText(i, "%t", "{1} has slain {2}!", attackername, clientname);
								}
								else if(!(chatMessage_Off[i] & LKA_Slain)){
									PrintToChat(i, "%t", "{1} has slain {2}!", attackername, clientname);
								}
								
								if(teamtemp == GetClientTeam(i))
								{
									if(!(playSound_Off[i] & LKA_Slain))
									{
										if(i == reserveState[0][0]){
											playsoundfromclient(i, GetRandomInt(9, 11));
										}
										else{
											playsoundfromclient(i, GetRandomInt(3, 5));
										}
									}
								}
								else
								{
									if(!(playSound_Off[i] & LKA_Slain))
									{
										if(i == reserveState[0][1]){
											playsoundfromclient(i, GetRandomInt(6, 7));
										}
										else{
											playsoundfromclient(i, GetRandomInt(1, 2));
										}
									}
								}
							}
						}
					}
				}
			}

			for(new i=1; i<=MAXPLAYERS; i++)
			{
				if(reserveState[i][2] > 0)
				{
					for(new ii=0; ii<=3; ii++){
						reserveState[i-1][ii] = reserveState[i][ii];
					}
				}
				else
				{
					for(new ii=0; ii<=3; ii++){
						reserveState[i-1][ii] = 0;
					}
					break;
				}
			}

			announceTimer = GetEngineTime() + GetConVarInt(g_announceCooltime);
		}
	}
}

public announce_reserve(attacker, client, num, kscount)
{
	for(new i=0; i<=MAXPLAYERS; i++)
	{
		if(reserveState[i][0] == attacker && reserveState[i][2] == 4 && num == 4)
		{
			if(reserveState[i][3] < kscount)
			{
				reserveState[i][1] = client;
				reserveState[i][3] = kscount;
				break;
			}
		}
		else if(reserveState[i][2] == 0)
		{
			reserveState[i][0] = attacker;
			reserveState[i][1] = client;
			reserveState[i][2] = num;
			reserveState[i][3] = kscount;
			break;
		}
	}
}

bool:IsSlainWeapon(const String:weaponname[])
{
	decl String:convarstring[256];
	GetConVarString(g_MeleeWeaponList, convarstring, 256);
	
	if(StrContains(convarstring, weaponname, false) != -1){
		return true;
	}
	return false;
}

public OnMapEnd()
{
	if(announceTimer_handle != INVALID_HANDLE)
		announceTimer_handle = INVALID_HANDLE;
}