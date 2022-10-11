#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <tf2_stocks>
#include <tf2attributes>
#include <tf2items>
#include <tf2itemsinfo>

#pragma semicolon 1
#pragma newdecls required

#define UU_VERSION "0.9.6-fartsy-psy"

#define RED 0
#define BLUE 1

#define NB_B_WEAPONS 1
#define NB_SLOTS_UED 5

#define MAX_ATTRIBUTES 3000
#define MAX_ATTRIBUTES_ITEM 65

#define _NUMBER_DEFINELISTS 630
#define _NUMBER_DEFINELISTS_CAT 9

#define WCNAMELISTSIZE 700

#define _NB_SP_TWEAKS 60
#define MAXLEVEL_D 500
char tempStartMoney[16];
Handle up_menus[MAXPLAYERS + 1];
Handle menuBuy;
Handle BuyNWmenu;

int BuyNWmenu_enabled;

Handle cvar_TimerMoneyGive_BlueTeam;
float TimerMoneyGive_BlueTeam;
Handle cvar_TimerMoneyGive_RedTeam;
float TimerMoneyGive_RedTeam;
Handle cvar_MoneyBonusKill;
int MoneyBonusKill;
//Handle cvar_MoneyForTeamRatioRed
Handle cvar_AutoMoneyForTeamRatio;
float MoneyForTeamRatio[2];
float MoneyTotalFlow[2];

Handle Timers_[4];
Handle cvarStartMoney = INVALID_HANDLE;

int clientLevels[MAXPLAYERS + 1];
char clientBaseName[MAXPLAYERS + 1][255];
int moneyLevels[MAXLEVEL_D + 1];

int given_upgrd_list_nb[_NUMBER_DEFINELISTS];
int given_upgrd_list[_NUMBER_DEFINELISTS][_NUMBER_DEFINELISTS_CAT][64];
char given_upgrd_classnames[_NUMBER_DEFINELISTS][_NUMBER_DEFINELISTS_CAT][64];
int given_upgrd_classnames_tweak_idx[_NUMBER_DEFINELISTS];
int given_upgrd_classnames_tweak_nb[_NUMBER_DEFINELISTS];

char wcnamelist[WCNAMELISTSIZE][64];
int wcname_l_idx[WCNAMELISTSIZE];
int current_w_list_id[MAXPLAYERS + 1];
int current_w_c_list_id[MAXPLAYERS + 1];

int current_class[MAXPLAYERS + 1];


char current_slot_name[5][32];
int current_slot_used[MAXPLAYERS + 1];
int currentupgrades_idx[MAXPLAYERS + 1][5][MAX_ATTRIBUTES_ITEM];
float currentupgrades_val[MAXPLAYERS + 1][5][MAX_ATTRIBUTES_ITEM];
int currentupgrades_number[MAXPLAYERS + 1][5];

int currentitem_level[MAXPLAYERS + 1][5];
int currentitem_idx[MAXPLAYERS + 1][5];
int currentitem_ent_idx[MAXPLAYERS + 1][5];
int currentitem_catidx[MAXPLAYERS + 1][5];

char currentitem_classname[MAXPLAYERS + 1][5][64];

int upgrades_ref_to_idx[MAXPLAYERS + 1][5][MAX_ATTRIBUTES];
int currentupgrades_idx_mvm_chkp[MAXPLAYERS + 1][5][MAX_ATTRIBUTES_ITEM];
float currentupgrades_val_mvm_chkp[MAXPLAYERS + 1][5][MAX_ATTRIBUTES_ITEM];
int currentupgrades_number_mvm_chkp[MAXPLAYERS + 1][5];

int _u_id;
int client_spent_money[MAXPLAYERS + 1][5];
int client_new_weapon_ent_id[MAXPLAYERS + 1];
int client_spent_money_mvm_chkp[MAXPLAYERS + 1][5];
int client_last_up_slot[MAXPLAYERS + 1];
int client_last_up_idx[MAXPLAYERS + 1];
int client_iCash[MAXPLAYERS + 1];


int client_respawn_handled[MAXPLAYERS + 1];
int client_respawn_checkpoint[MAXPLAYERS + 1];

int client_no_d_name[MAXPLAYERS + 1] = 1;
int client_no_d_team_upgrade[MAXPLAYERS + 1];
int client_no_d_menubuy_respawn[MAXPLAYERS + 1];

Handle _upg_names;
Handle _weaponlist_names;
Handle _spetweaks_names;

char upgradesNames[MAX_ATTRIBUTES][64];
char upgradesWorkNames[MAX_ATTRIBUTES][96];
int upgrades_to_a_id[MAX_ATTRIBUTES];
int upgrades_costs[MAX_ATTRIBUTES];
float upgrades_ratio[MAX_ATTRIBUTES];
float upgrades_i_val[MAX_ATTRIBUTES];
float upgrades_m_val[MAX_ATTRIBUTES];
float upgrades_costs_inc_ratio[MAX_ATTRIBUTES];
char upgrades_tweaks[_NB_SP_TWEAKS][64];
int upgrades_tweaks_nb_att[_NB_SP_TWEAKS];
int upgrades_tweaks_att_idx[_NB_SP_TWEAKS][10];
float upgrades_tweaks_att_ratio[_NB_SP_TWEAKS][10];

int newweaponidx[128];
char newweaponcn[64][64];
char newweaponmenudesc[64][64];

float CurrencyOwned[MAXPLAYERS + 1];
float RealStartMoney = 0.0;

float CurrencySaved[MAXPLAYERS + 1];
float StartMoneySaved;

stock bool IsMvM(bool forceRecalc = false){
	static bool found = false;
	static bool ismvm = false;
	if (forceRecalc)
	{
		found = false;
		ismvm = false;
	}
	if (!found)
	{
		int i = FindEntityByClassname(-1, "tf_logic_mann_vs_machine");
		if (i > MaxClients && IsValidEntity(i)) ismvm = true;
		found = true;
	}
	return ismvm;
}

public Action Timer_WaitForTF2II(Handle timer){
	int i = 0;
	if (TF2II_IsValidAttribID(1))
	{
		for (i = 1; i < 3000; i++)
		{
			if (TF2II_IsValidAttribID(i))
			{
				TF2II_GetAttributeNameByID( i, upgradesWorkNames[i], 128 );
			//	PrintToServer("%s\n", upgradesWorkNames[i]);
			}
			else
			{
			//	PrintToServer("unvalid attrib %d\n", i);
			}
		}
		for (i = 0; i < MAX_ATTRIBUTES; i++)
		{
			upgrades_ratio[i] = 0.0;
			upgrades_i_val[i] = 0.0;
			upgrades_costs[i] = 0;
			upgrades_costs_inc_ratio[i] = 0.25;
			upgrades_m_val[i] = 0.0;
		}
		for (i = 1; i < _NUMBER_DEFINELISTS; i++)
		{
			given_upgrd_classnames_tweak_idx[i] = -1;
			given_upgrd_list_nb[i] = 0;
		}
		LoadConfigFiles();
		KillTimer(timer);
	}
	return Plugin_Continue;
}

void UberShopDefineUpgradeTabs(){
	int i = 0;
	while (i < MAXPLAYERS + 1)
	{
		client_respawn_handled[i] = 0;
		client_respawn_checkpoint[i] = 0;
		clientLevels[i] = 0;
		up_menus[i] = INVALID_HANDLE;
		int j = 0;
		while (j < NB_SLOTS_UED)
		{
			currentupgrades_number[i][j] = 0;
			currentitem_level[i][j] = 0;
			currentitem_idx[i][j] = 9999;
			client_spent_money[i][j] = 0;
			int k = 0;
			while (k < MAX_ATTRIBUTES)
			{
				upgrades_ref_to_idx[i][j][k] = 9999;
				k++;
			}
			j++;
		}
		i++;

	}

	current_slot_name[0] = "Primary Weapon";
	current_slot_name[1] = "Secondary Weapon";
	current_slot_name[2] = "Melee Weapon";
	current_slot_name[3] = "Special Weapon";
	current_slot_name[4] = "Body";
	upgradesNames[0] = "";
	CreateTimer(0.2, Timer_WaitForTF2II, _, TIMER_FLAG_NO_MAPCHANGE);
}

public void TF2_OnConditionAdded(int client, TFCond condition)
{
	if(TF2_GetPlayerClass(client) == TFClass_Pyro && condition == TFCond_OnFire)
	{
		TF2_RemoveCondition(client, TFCond_OnFire);
	}
}
public int TF2Items_OnGiveNamedItem_Post(int client, char[] classname, int itemDefinitionIndex, int itemLevel, int itemQuality, int entityIndex)
{
	if (!IsFakeClient(client) && IsValidClient(client) && !TF2_IsPlayerInCondition(client, TFCond_Disguised))
	{
		if (itemLevel == 242)
		{
			int slot = 3;
			current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
			currentitem_ent_idx[client][slot] = entityIndex;
			if (!currentupgrades_number[client][slot])
			{
				currentitem_idx[client][slot] = 9999;
			}
			DefineAttributesTab(client, itemDefinitionIndex, slot);
			GetEntityClassname(entityIndex, currentitem_classname[client][slot], 64);
			currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);

			GiveNewUpgradedWeapon_(client, slot);
			//PrintToChatAll("OGiveItem slot %d: [%s] #%d CAT[%d] qual%d", slot, classname, itemDefinitionIndex, currentitem_catidx[client][slot], itemLevel)
		}
		else
		{
			int slot = view_as<int>(TF2II_GetItemSlot(itemDefinitionIndex));
			current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
			if (TF2_GetPlayerClass(client) == TFClass_Soldier || TF2_GetPlayerClass(client) == TFClass_Pyro || TF2_GetPlayerClass(client) == TFClass_Heavy)
			{
				if (!strcmp(classname, "tf_weapon_shotgun"))
				{
					if (itemDefinitionIndex == 199
					|| itemDefinitionIndex == 1153
					|| itemDefinitionIndex == 15003
					|| itemDefinitionIndex == 15016
					|| itemDefinitionIndex == 15044
					|| itemDefinitionIndex == 15047
					|| itemDefinitionIndex == 15085
					|| itemDefinitionIndex == 15109
					|| itemDefinitionIndex == 15132
					|| itemDefinitionIndex == 15133
					|| itemDefinitionIndex == 15152)
					{
						slot = 1;
					}
				}
			}
			if (TF2_GetPlayerClass(client) == TFClass_DemoMan)
			{
				if (!strcmp(classname, "tf_weapon_parachute"))
				{
					slot = 0;
				}
			}
			//PrintToChatAll("OGiveItem slot %d: [%s] #%d CAT[%d] qual%d", slot, classname, itemDefinitionIndex, currentitem_catidx[client][slot], itemLevel)
			currentitem_catidx[client][4] = view_as<int>(TF2_GetPlayerClass(client)) - 1;
			if (slot < 3)
			{
				GetEntityClassname(entityIndex, currentitem_classname[client][slot], 64);
				currentitem_ent_idx[client][slot] = entityIndex;
				current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
				//currentitem_idx[client][slot] = itemDefinitionIndex
				DefineAttributesTab(client, itemDefinitionIndex, slot);
				//if (current_class[client] == )
				if (current_class[client] == view_as<int>(TFClass_DemoMan))
				{
					if (!strcmp(classname, "tf_wearable"))
					{
						if (itemDefinitionIndex == 405
						|| itemDefinitionIndex == 608)
						{
							currentitem_catidx[client][slot] = GetUpgrade_CatList("tf_wear_alishoes");
						}
					}
					else
					{
						currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);
					}

				}
				else if (current_class[client] == view_as<int>(TFClass_Medic))
				{
					if (!strcmp(classname, "tf_weapon_medigun"))
					{
						if (itemDefinitionIndex == 998)
						{
							currentitem_catidx[client][slot] = GetUpgrade_CatList("vaccinator");
						}
						else
						{
							currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);
						}
					}
					else
					{
						currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);
					}
				}
				else if (current_class[client] == view_as<int>(TFClass_Pyro))
				{
					if (!strcmp(classname, "tf_weapon_flamethrower") && itemDefinitionIndex == 594)
					{
						currentitem_catidx[client][slot] = GetUpgrade_CatList("tf_weapon_phlog");
					}
					else
					{
						currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);
					}
				}
				else if (current_class[client] == view_as<int>(TFClass_Engineer))
				{
					if (!strcmp(classname, "tf_weapon_shotgun"))
					{
						currentitem_catidx[client][0] = GetUpgrade_CatList("tf_weapon_shotgun_primary");
					}
					else if (!strcmp(classname, "tf_weapon_shotgun_primary"))
					{
						if (itemDefinitionIndex == 527)
						currentitem_catidx[client][0] = GetUpgrade_CatList("tf_weapon_shotgun_primary_widow");
					}
					else if (!strcmp(classname, "saxxy"))
					{
						currentitem_catidx[client][2] = GetUpgrade_CatList("tf_weapon_wrench");
					}
					else
					{
						currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);
					}
				}
				else if (current_class[client] == view_as<int>(TFClass_Scout))
				{
					if (!strcmp(classname, "tf_weapon_scattergun"))
					{
						if (itemDefinitionIndex == 13
						|| itemDefinitionIndex == 200
						|| itemDefinitionIndex == 669
						|| itemDefinitionIndex == 799
						|| itemDefinitionIndex == 808
						|| itemDefinitionIndex == 880
						|| itemDefinitionIndex == 888
						|| itemDefinitionIndex == 897
						|| itemDefinitionIndex == 906
						|| itemDefinitionIndex == 915
						|| itemDefinitionIndex == 964
						|| itemDefinitionIndex == 973)
						{
							currentitem_catidx[client][slot] = GetUpgrade_CatList("tf_weapon_scattergun_");
						}
						else
						{
							currentitem_catidx[client][slot] = GetUpgrade_CatList("tf_weapon_scattergun");
						}
					}
					else if (!strcmp(classname, "saxxy"))
					{
						currentitem_catidx[client][2] = GetUpgrade_CatList("tf_weapon_bat");
					}
					else
					{
						currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);
					}
				}
				else if (current_class[client] == view_as<int>(TFClass_Spy))
				{
					if (!strcmp(classname, "saxxy"))
					{
						currentitem_catidx[client][2] = GetUpgrade_CatList("tf_weapon_knife");
					}
					else if (!strcmp(classname, "tf_weapon_revolver"))
					{
						currentitem_catidx[client][slot] = GetUpgrade_CatList("tf_weapon_revolver");
					}
					else
					{
						currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);
					}
				}
				else
				{
					currentitem_catidx[client][slot] = GetUpgrade_CatList(classname);
				}
				GiveNewUpgradedWeapon_(client, slot);
			}
			if (current_class[client] == view_as<int>(TFClass_Spy))
			{
				if (!strcmp(classname, "tf_weapon_pda_spy"))
				{
					currentitem_classname[client][1] = "tf_weapon_pda_spy";
					currentitem_ent_idx[client][1] = GetPlayerWeaponSlot(client, 1);
					current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
					DefineAttributesTab(client, 735, 1);
					currentitem_catidx[client][1] = GetUpgrade_CatList("tf_weapon_pda_spy");
					GiveNewUpgradedWeapon_(client, 1);
				}
			}
			//PrintToChatAll("OGiveItem slot %d: [%s] #%d CAT[%d] qual%d", slot, classname, itemDefinitionIndex, currentitem_catidx[client][slot], itemLevel)
		}
	}
}

public void Event_PlayerChangeClass(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsValidClient(client))
	{
		current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
		ResetClientUpgrades(client);
		TF2Attrib_RemoveAll(client);
		RespawnEffect(client);
		CurrencyOwned[client] = RealStartMoney;
		//PrintToChat(client, "client changeclass");
		if (!client_respawn_handled[client])
		{
			CreateTimer(0.1, ClChangeClassTimer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
		FakeClientCommand(client,"menuselect 0");
		ChangeClassEffect(client);
	}
}

public void Event_PlayerreSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!client_respawn_handled[client])
	{
		client_respawn_handled[client] = 1;
		//PrintToChat(client, "TEAM #%d", team)

		if (client_respawn_checkpoint[client])
		{
			//PrintToChatAll("cash readjust")
			CreateTimer(0.2, mvm_CheckPointAdjustCash, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			CreateTimer(0.2, WeaponReGiveUpgrades, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	FakeClientCommand(client,"menuselect 0");
	RespawnEffect(client);
}
public Action Timer_GetConVars(Handle timer)//Reload con_vars into vars
{
	int entityP = FindEntityByClassname(-1, "func_upgradestation");
	if (entityP > -1)
	{
			AcceptEntityInput(entityP, "Kill");
	//		PrintToServer("kill sent to funcupstat")
	}
	else
	{
	//	PrintToServer("no funcupstat found")
	}

	MoneyBonusKill = GetConVarInt(cvar_MoneyBonusKill);
	TimerMoneyGive_BlueTeam = GetConVarFloat(cvar_TimerMoneyGive_BlueTeam);
	TimerMoneyGive_RedTeam = GetConVarFloat(cvar_TimerMoneyGive_RedTeam);
	return Plugin_Continue;
}

public Action Timer_GiveSomeMoney(Handle timer)//GIVE MONEY EVRY 5s
{
	float iCashtmp;
	//float HighestMoney;
	//float StartMoneyCVAR = StringToFloat(tempStartMoney);
	for (int client_id = 1; client_id < MAXPLAYERS + 1; client_id++)
	{
		if (IsValidClient(client_id) && (GetClientTeam(client_id) > 1))
		{
			iCashtmp = CurrencyOwned[client_id];
			//iCashtmp = 0
			iCashtmp += float(client_spent_money[client_id][0] +client_spent_money[client_id][1] +client_spent_money[client_id][2] +client_spent_money[client_id][3]);
			if (GetClientTeam(client_id) == 3)
			{
				MoneyTotalFlow[BLUE] += iCashtmp;
			}
			else
			{
				MoneyTotalFlow[RED] += iCashtmp;
			}
			//if(HighestMoney <= iCashtmp)
			//{
			//	HighestMoney = iCashtmp;
				//RealStartMoney = iCashtmp;
			//}
		}
	}

	if (MoneyTotalFlow[RED])
	{
		MoneyForTeamRatio[RED] = MoneyTotalFlow[BLUE] / MoneyTotalFlow[RED];
	}
	if (MoneyTotalFlow[BLUE])
	{
		MoneyForTeamRatio[BLUE] = MoneyTotalFlow[RED] / MoneyTotalFlow[BLUE];
	}
	if (MoneyForTeamRatio[RED] > 3.0)
	{
		MoneyForTeamRatio[RED] = 3.0;
	}
	if (MoneyForTeamRatio[BLUE] > 3.0)
	{
		MoneyForTeamRatio[BLUE] = 3.0;
	}
	MoneyForTeamRatio[BLUE] *= MoneyForTeamRatio[BLUE];
	MoneyForTeamRatio[RED] *= MoneyForTeamRatio[RED];
	for (int client_id = 1; client_id < MAXPLAYERS + 1; client_id++)
	{
		if (IsValidClient(client_id))
		{
			iCashtmp = CurrencyOwned[client_id];
			if (GetClientTeam(client_id) == 3)//BLUE TEAM
			{
				if (GetConVarInt(cvar_AutoMoneyForTeamRatio))
				{
					CurrencyOwned[client_id] += (TimerMoneyGive_BlueTeam * MoneyForTeamRatio[BLUE]);
				}
				else
				{
					CurrencyOwned[client_id] += TimerMoneyGive_BlueTeam;
				}
			}
			else if (GetClientTeam(client_id) == 2)//RED TEAM
			{
				if (GetConVarInt(cvar_AutoMoneyForTeamRatio))
				{
					CurrencyOwned[client_id] += (TimerMoneyGive_RedTeam * MoneyForTeamRatio[RED]);
				}
				else
				{
					CurrencyOwned[client_id] += TimerMoneyGive_RedTeam;
				}
			}
		}
	}
	TimerMoneyGive_BlueTeam = GetConVarFloat(cvar_TimerMoneyGive_BlueTeam);
	TimerMoneyGive_RedTeam = GetConVarFloat(cvar_TimerMoneyGive_RedTeam);
	return Plugin_Continue;
}

public Action Timer_Resetupgrades(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (IsValidClient(client))
	{
		SetEntProp(client, Prop_Send, "m_nCurrency", RealStartMoney);
		for (int slot = 0; slot < NB_SLOTS_UED; slot++)
		{
			client_spent_money[client][slot] = 0;
			client_spent_money_mvm_chkp[client][slot] = 0;
		}
		ResetClientUpgrades(client);
		if (!client_respawn_handled[client])
		{
			CreateTimer(0.2, ClChangeClassTimer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	return Plugin_Continue;
}


public Action ClChangeClassTimer(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);

	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		client_respawn_checkpoint[client] = 0;
	}
	return Plugin_Continue;
}

public Action WeaponReGiveUpgrades(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);

	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		client_respawn_handled[client] = 1;
		for (int slot = 0; slot < NB_SLOTS_UED; slot++)
		{
			//PrintToChat(client, "money spent on slot  %d -- %d$", slot, client_spent_money[client][slot]);
			if (client_spent_money[client][slot] > 0)
			{
				if (slot == 3 && client_new_weapon_ent_id[client])
				{
					GiveNewWeapon(client, 3);
				}
				GiveNewUpgradedWeapon_(client, slot);
			//	PrintToChat(client, "player's upgrad!!");
			}
		}
	}
	client_respawn_handled[client] = 0;
	return Plugin_Continue;
}

public void OnClientDisconnect(int client)
{
	PrintToServer("%N (%i) left", client, client);
}

public void OnClientPutInServer(int client)
{
	char clname[255];
	GetClientName(client, clname, sizeof(clname));
	clientBaseName[client] = clname;
	//PrintToChatAll("putinserver #%d", client);
	PrintToServer("putinserver #%d", client);
	clientLevels[client] = 0;
	client_no_d_team_upgrade[client] = 1;
	client_no_d_name[client] = 1;
	ResetClientUpgrades(client);
	current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
	if (!client_respawn_handled[client])
	{
		CreateTimer(0.2, ClChangeClassTimer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	PrintToServer("realstartmoney = %f", RealStartMoney);
	CurrencyOwned[client] = RealStartMoney;
}
public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)//Every single server tick.  GetTickInterval() for the seconds per tick.
{
	if ((buttons & IN_SCORE) && (buttons & IN_RELOAD))
	{
		Menu_BuyUpgrade(client, 0);
	}
	if(CurrencyOwned[client] >= 300000000000.0)
	{
		CurrencyOwned[client] = 300000000000.0;
	}
	if(CurrencyOwned[client] < 0.0)
	{
		CurrencyOwned[client] = 0.0;
	}
	if (IsValidClient(client))
	{
		TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.0);
		SetEntProp(client, Prop_Send, "m_nCurrency", RoundFloat(CurrencyOwned[client]));
	}
	return Plugin_Continue;
}
public Action Event_PlayerCollectMoney(Handle event, const char[] name, bool dontBroadcast)
{
	int money = GetEventInt(event, "currency");
	RealStartMoney += money;
	for (int i = 1; i <= MaxClients; i++) 
	{ 
		if (IsClientInGame(i) && IsValidClient(i)) 
		{
			CurrencyOwned[i] += money;
		} 
	}
	SetEventInt(event, "currency", 0);
}
public Action TF2_CalcIsAttackCritical(int client, int weapon, char[] weaponname, bool &result) // Called whenever you shoot. 
{
	return Plugin_Handled;
}
public void Event_Playerhurt(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	float damage = GetEventFloat(event, "damageamount");

	if(IsValidClient(attacker) && attacker != client)
	{
		PrintToConsole(attacker, "%0.f post-damage dealt", damage);
	}
}

public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	FakeClientCommand(client, "menuselect 0");
	int attack = GetClientOfUserId(GetEventInt(event, "attacker"));
	if(!IsMvM())
	{
		float BotMoneyKill = 100.0+((SquareRoot(MoneyBonusKill + Pow(RealStartMoney, 0.9))) * 0.5) * 3.0;
		float PlayerMoneyKill = 100.0+((SquareRoot(MoneyBonusKill + Pow(RealStartMoney, 0.95))) * 0.7) * 3.0;
		
		if (IsValidClient(attack) && IsValidClient(client) && attack != client)
		{
			for (int i = 1; i <= MaxClients; i++) 
			{ 
				if (IsClientInGame(i) && IsValidClient(i)) 
				{
					CurrencyOwned[i] += PlayerMoneyKill;
					PrintToChat(i, "+%.0f$",  PlayerMoneyKill);
				} 
			}  
			RealStartMoney += PlayerMoneyKill;
		}
		if(!IsValidClient(client) && attack != client)
		{
			for (int i = 1; i <= MaxClients; i++) 
			{ 
				if (IsClientInGame(i) && IsValidClient(i)) 
				{
					CurrencyOwned[i] += BotMoneyKill;
					PrintToChat(i, "+%.0f$", BotMoneyKill);
				} 
			}  
			RealStartMoney += BotMoneyKill;
		}
	}
	return Plugin_Continue;
}
public void Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	MoneyForTeamRatio[RED] = 0.9;
	MoneyForTeamRatio[BLUE] = 0.9;
}

public void Event_teamplay_round_win(Handle event, const char[] name, bool dontBroadcast)
{
	int slot, i;
	int team = GetEventInt(event, "team");
	if (IsMvM() && team == 3)
	{
		//PrintToChatAll("bot TEAM wins!")
		for (int client_id = 1; client_id < MAXPLAYERS + 1; client_id++)
		{
			if (IsValidClient(client_id))
			{

				client_respawn_checkpoint[client_id] = 1;
				client_spent_money[client_id] = client_spent_money_mvm_chkp[client_id];
				for (slot = 0; slot < 5; slot++)
				{
					for (i = 0; i < currentupgrades_number[client_id][slot]; i++)
					{
						upgrades_ref_to_idx[client_id][slot][currentupgrades_idx[client_id][slot][i]] = 9999;
					}
					currentupgrades_idx[client_id][slot] = currentupgrades_idx_mvm_chkp[client_id][slot];
					currentupgrades_val[client_id][slot] = currentupgrades_val_mvm_chkp[client_id][slot];
					currentupgrades_number[client_id][slot] = currentupgrades_number_mvm_chkp[client_id][slot];
					for (i = 0; i < currentupgrades_number[client_id][slot]; i++)
					{
						upgrades_ref_to_idx[client_id][slot][currentupgrades_idx[client_id][slot][i]] = i;
					}
				}
			}
		}
	}
	else
	{
		//PrintToChatAll("hmuan TEAM wins!")
	}
}

public void Event_mvm_wave_begin(Handle event, const char[] name, bool dontBroadcast)
{
	int client_id, slot;
	PrintToServer("mvm wave begin");
	for (client_id = 0; client_id < MAXPLAYERS + 1; client_id++)
	{
		if (IsValidClient(client_id))
		{
			client_spent_money_mvm_chkp[client_id] = client_spent_money[client_id];
			CurrencySaved[client_id] = CurrencyOwned[client_id];
			StartMoneySaved = RealStartMoney;
			for (slot = 0; slot < 5; slot++)
			{
				currentupgrades_number_mvm_chkp[client_id][slot] = currentupgrades_number[client_id][slot];
				currentupgrades_idx_mvm_chkp[client_id][slot] = currentupgrades_idx[client_id][slot];
				currentupgrades_val_mvm_chkp[client_id][slot] = currentupgrades_val[client_id][slot];
			}
			//PrintToChat(client_id, "Current checkpoint money: %d", client_spent_money_mvm_chkp[client_id])
		}
	}
}

public void Event_mvm_wave_complete(Handle event, const char[] name, bool dontBroadcast)
{
	int client_id, slot;

	//PrintToChatAll("EVENT MVM WAVE COMPLETE")
	for (client_id = 1; client_id < MAXPLAYERS + 1; client_id++)
	{
		if (IsValidClient(client_id))
		{

			client_spent_money_mvm_chkp[client_id] = client_spent_money[client_id];
			for (slot = 0; slot < 5; slot++)
			{
				currentupgrades_number_mvm_chkp[client_id][slot] = currentupgrades_number[client_id][slot];
				currentupgrades_idx_mvm_chkp[client_id][slot] = currentupgrades_idx[client_id][slot];
				currentupgrades_val_mvm_chkp[client_id][slot] = currentupgrades_val[client_id][slot];
			}
			//PrintToChat(client_id, "Current checkpoint money: %d", client_spent_money_mvm_chkp[client_id])
		}
	}
}
public void Event_mvm_wave_failed(Handle event, const char[] name, bool dontBroadcast)
{
	for (int client = 0; client < MAXPLAYERS + 1; client++)
	{
		if (IsValidClient(client))
		{
			if (!client_respawn_handled[client])
			{
				CreateTimer(0.2, ClChangeClassTimer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
		}	
	}
	int slot,i;
	for (int client_id = 0; client_id < MAXPLAYERS + 1; client_id++)
	{
		if (IsValidClient(client_id))
		{
			TF2Attrib_RemoveAll(client_id);
			CurrencyOwned[client_id] = CurrencySaved[client_id];
			RealStartMoney = StartMoneySaved;
			client_respawn_checkpoint[client_id] = 1;
			client_spent_money[client_id] = client_spent_money_mvm_chkp[client_id];
			for (slot = 0; slot < 5; slot++)
			{
				for (i = 0; i < currentupgrades_number[client_id][slot]; i++)
				{
					upgrades_ref_to_idx[client_id][slot][currentupgrades_idx[client_id][slot][i]] = 20000;
				}			
				currentupgrades_idx[client_id][slot] = currentupgrades_idx_mvm_chkp[client_id][slot];
				currentupgrades_val[client_id][slot] = currentupgrades_val_mvm_chkp[client_id][slot];
				currentupgrades_number[client_id][slot] = currentupgrades_number_mvm_chkp[client_id][slot];
				for (i = 0; i < currentupgrades_number[client_id][slot]; i++)
				{
					upgrades_ref_to_idx[client_id][slot][currentupgrades_idx[client_id][slot][i]] = i;
				}
				int weaponinSlot = GetPlayerWeaponSlot(client_id,slot);
				if(IsValidEntity(weaponinSlot))
				{
					TF2Attrib_RemoveAll(weaponinSlot);
					GiveNewUpgradedWeapon_(client_id, slot);
					TF2Attrib_ClearCache(weaponinSlot);
					//PrintToServer("Slot #%i was refreshed for client #%i",slot,client_id);
				}
			}
			TF2Attrib_ClearCache(client_id);
		}
	}
	PrintToServer("MvM Mission Failed");
}
public void Event_ResetStats(Handle event, const char[] name, bool dontBroadcast)
{
	for (int client = 0; client < MAXPLAYERS + 1; client++)
	{
		if (IsValidClient(client))
		{
			int primary = (GetPlayerWeaponSlot(client,0));
			int secondary = (GetPlayerWeaponSlot(client,1));
			int melee = (GetPlayerWeaponSlot(client,2));
			TF2Attrib_RemoveAll(client);
			TF2Attrib_RemoveAll(primary);
			TF2Attrib_RemoveAll(secondary);
			TF2Attrib_RemoveAll(melee);
			current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
			ResetClientUpgrades(client);
			if (!client_respawn_handled[client])
			{
				CreateTimer(0.05, ClChangeClassTimer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
			FakeClientCommandEx(client, "menuselect 0");
			Menu_BuyUpgrade(client, 0);
			CurrencyOwned[client] = StringToFloat(tempStartMoney);
			//RealStartMoney = 1400.0;
		}
	}
}
public Action mvm_CheckPointAdjustCash(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	//PrintToChatAll("ckpoint adjust")

	if (IsValidClient(client) && client_respawn_checkpoint[client])
	{
		int iCash = GetEntProp(client, Prop_Send, "m_nCurrency", iCash);
		SetEntProp(client, Prop_Send, "m_nCurrency", iCash - (client_spent_money_mvm_chkp[client][0] + client_spent_money_mvm_chkp[client][1] + client_spent_money_mvm_chkp[client][2] + client_spent_money_mvm_chkp[client][3]) );
		client_respawn_checkpoint[client] = 0;
		CreateTimer(0.1, WeaponReGiveUpgrades, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	return Plugin_Continue;
}


public void Event_PlayerChangeTeam(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int disconnected = view_as<bool>(GetEventInt(event, "disconnect"));

	if(disconnected)
	{
		return;
	}

	if (IsValidClient(client))
	{
		//current_class[client] = TF2_GetPlayerClass(client)
		//PrintToChat(client, "client changeteam");
		if (!client_respawn_handled[client])
		{
			CreateTimer(0.2, ClChangeClassTimer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
		ChangeClassEffect(client);
	}
}

public Action jointeam_callback(int client, const char[] command, int argc) //protection from spectators
{
	char arg[16];
	arg[0] = '\0';
	PrintToServer("jointeam callback #%d", client);
	GetCmdArg(1, arg, sizeof(arg));
	ResetClientUpgrades(client);
	for(int yeah = 0; yeah < 5; yeah++)
	{
		if(IsValidClient(client))
		{
			int Weapon = GetPlayerWeaponSlot(client,yeah);
			if(IsValidEntity(Weapon))
			{
				TF2Attrib_RemoveAll(Weapon);
			}
		}
	}
	if(IsValidClient(client))
	{
		TF2Attrib_RemoveAll(client);
	}
	//current_class[client] = TF2_GetPlayerClass(client)
	//PrintToChat(client, "client changeteam");
	if (!client_respawn_handled[client])
	{
		CreateTimer(0.2, ClChangeClassTimer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	if (!IsMvM())
	{
		PrintToServer("give to client %.0f startmoney",RealStartMoney);
		//iCashtmp = GetEntProp(client, Prop_Send, "m_nCurrency", iCashtmp);
		SetEntProp(client, Prop_Send, "m_nCurrency",RealStartMoney);
	}		
	FakeClientCommand(client, "menuselect 0");
	return Plugin_Continue;
}

//!uusteamup -> toggle shows team upgrades in chat for a client
public Action Toggl_DispTeamUpgrades(int client, int args)
{
	char arg1[32];
	int arg;

	client_no_d_team_upgrade[client] = 0;
	if (GetCmdArg(1, arg1, sizeof(arg1)))
	{
		arg = StringToInt(arg1);
		if (arg == 0)
		{
			client_no_d_team_upgrade[client] = 1;
		}
	}
	return Plugin_Handled;
}
public Action Toggl_NameLevel(int client, int args)
{
	char arg1[32];
	int arg;

	client_no_d_name[client] = 0;
	if (GetCmdArg(1, arg1, sizeof(arg1)))
	{
		arg = StringToInt(arg1);
		if (arg == 0)
		{
			client_no_d_name[client] = 1;
		}
		else if(arg == 5)
		{
			client_no_d_team_upgrade[client] = 5;
		}
	}
	return Plugin_Handled;
}
//!uurspwn -> toggle shows buymenu when a client respawn
public Action Toggl_DispMenuRespawn(int client, int args)
{
	char arg1[32];
	int arg;

	client_no_d_menubuy_respawn[client] = 0;
	if (GetCmdArg(1, arg1, sizeof(arg1)))
	{
		arg = StringToInt(arg1);
		if (arg == 0)
		{
			client_no_d_menubuy_respawn[client] = 1;
		}
	}
	return Plugin_Handled;
}

public Action ReloadCfgFiles(int client, int args)
{
	LoadConfigFiles();

	for (int cl = 0; cl < MAXPLAYERS + 1; cl++)
	{
		if (IsValidClient(cl))
		{
			ResetClientUpgrades(cl);
			current_class[cl] = view_as<int>(TF2_GetPlayerClass(client));
			//PrintToChat(cl, "client changeclass");
			if (!client_respawn_handled[cl])
			{
				CreateTimer(0.2, ClChangeClassTimer, GetClientUserId(cl), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	return Plugin_Handled;
}


//admin cmd: enable/disable menu "buy an additional weapon"
public Action EnableBuyNewWeapon(int client, int args)
{
	char arg1[32];
	int arg;

	BuyNWmenu_enabled = 0;
	if (GetCmdArg(1, arg1, sizeof(arg1)))
	{
		arg = StringToInt(arg1);
		if (arg == 1)
		{
			BuyNWmenu_enabled = 1;
		}
	}
	return Plugin_Handled;
}
public Action Menu_QuickBuyUpgrade(int client, int args)
{
	char arg1[32];
	int arg1_ = -1;
	char arg2[32];
	int arg2_ = -1;
	char arg3[32];
	int arg3_ = -1;
	char arg4[32];
	int arg4_ = 0;
	bool flag = false;
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		if (GetCmdArg(1, arg1, sizeof(arg1)))
		{
			arg2_ = -1;
			arg3_ = -1;
			if(!strcmp("1", arg1))
			{
				arg1_ = 4;
			}
			if(!strcmp("2", arg1))
			{
				arg1_ = 0;
			}
			if(!strcmp("3", arg1))
			{
				arg1_ = 1;
			}
			if(!strcmp("4", arg1))
			{
				arg1_ = 2;
			}
			if (arg1_ > -1 && arg1_ < 5 && GetCmdArg(2, arg2, sizeof(arg2)))
			{
				int w_id = currentitem_catidx[client][arg1_];
				arg2_ = StringToInt(arg2)-1;
				if (GetCmdArg(3, arg3, sizeof(arg3)))
				{
					arg3_ = StringToInt(arg3)-1;
					arg4_ = 1;
					if (GetCmdArg(4, arg4, sizeof(arg4)))
					{
						arg4_ = StringToInt(arg4);
						if (arg4_ >= 100000)
						{
							arg4_ = 100000;
						}
						if (arg4_ < 1)
						{
							arg4_ = 1;
						}
					}
					
					
					if (arg2_ > -1 && arg2_ < given_upgrd_list_nb[w_id] && given_upgrd_list[w_id][arg2_][arg3_])
					{
						int upgrade_choice = given_upgrd_list[w_id][arg2_][arg3_];
						int inum = upgrades_ref_to_idx[client][arg1_][upgrade_choice];
						if (inum == 9999)
						{
							inum = currentupgrades_number[client][arg1_];
							currentupgrades_number[client][arg1_]++;
							upgrades_ref_to_idx[client][arg1_][upgrade_choice] = inum;
							currentupgrades_idx[client][arg1_][inum] = upgrade_choice;
							currentupgrades_val[client][arg1_][inum] = upgrades_i_val[upgrade_choice];
						}
						int idx_currentupgrades_val = RoundToNearest((currentupgrades_val[client][arg1_][inum] - upgrades_i_val[upgrade_choice])/ upgrades_ratio[upgrade_choice]);
						float upgrades_val = currentupgrades_val[client][arg1_][inum];
						int up_cost = upgrades_costs[upgrade_choice];
						up_cost /= 2;
						if (arg1_ == 1)
						{
							up_cost = RoundFloat((up_cost * 1.0) * 0.9);
						}
						if (inum != 9999 && upgrades_ratio[upgrade_choice])
						{
							int t_up_cost = 0, idx = 0;
							for (idx = 0; idx < arg4_; idx++)
							{
								if (t_up_cost < 0)
								{
									t_up_cost *= -1;
									if (t_up_cost < (upgrades_costs[upgrade_choice] / 2))
									{
										t_up_cost = upgrades_costs[upgrade_choice] / 2;
									}
								}
								if (CurrencyOwned[client] < (t_up_cost + up_cost + RoundFloat(up_cost * (idx_currentupgrades_val * upgrades_costs_inc_ratio[upgrade_choice]))))
								{
									break;
								}
								if(upgrades_ratio[upgrade_choice] > 0.0 && upgrades_val < upgrades_m_val[upgrade_choice])
								{
									t_up_cost += up_cost + RoundFloat(up_cost * (idx_currentupgrades_val * upgrades_costs_inc_ratio[upgrade_choice]));
									idx_currentupgrades_val++;
									upgrades_val += upgrades_ratio[upgrade_choice];
								}
								if(upgrades_ratio[upgrade_choice] < 0.0 && upgrades_val > upgrades_m_val[upgrade_choice])
								{
									t_up_cost += up_cost + RoundFloat(up_cost * (idx_currentupgrades_val * upgrades_costs_inc_ratio[upgrade_choice]));
									idx_currentupgrades_val++;
									upgrades_val += upgrades_ratio[upgrade_choice];
								}
							}
												
							if ((upgrades_ratio[upgrade_choice] > 0.0 && upgrades_val > upgrades_m_val[upgrade_choice])
							|| (upgrades_ratio[upgrade_choice] < 0.0 && upgrades_val < upgrades_m_val[upgrade_choice]))
							{
								PrintToChat(client, "Maximum value reached for this upgrade.");
								flag = true;
								currentupgrades_val[client][arg1_][inum] = upgrades_val;
								CurrencyOwned[client] -= t_up_cost;
								check_apply_maxvalue(client, arg1_, inum, upgrade_choice);
								client_spent_money[client][arg1_] += t_up_cost;
								int totalmoney = 0;
							
								for (int s = 0; s < 5; s++)
								{
									totalmoney += client_spent_money[client][s];
								}
								GiveNewUpgradedWeapon_(client, arg1_);
							}
							else
							{
								flag = true;
								CurrencyOwned[client] -= t_up_cost;
								currentupgrades_val[client][arg1_][inum] = upgrades_val;
								check_apply_maxvalue(client, arg1_, inum, upgrade_choice);
								client_spent_money[client][arg1_] += t_up_cost;
								int totalmoney = 0;
							
								for (int s = 0; s < 5; s++)
								{
									totalmoney += client_spent_money[client][s];
								}
								GiveNewUpgradedWeapon_(client, arg1_);
								PrintToChat(client, "You have successfully upgraded %i times!", idx);
							}
						}
					}
				}
			}
		}
		if (!flag)
		{
			ReplyToCommand(client, "Usage: /qbuy [Slot buy #] [Category #] [Upgrade #] [# to buy]");
			ReplyToCommand(client, "Example : /qbuy 1 1 1 100 = buy health 100 times");
		}
	}
	else
	{
		ReplyToCommand(client, "You cannot quick-buy while dead.");
	}
	return Plugin_Handled;
}
int GetWeaponsCatKVSize(Handle kv)
{
	int siz = 0;
	do
	{
		if (!KvGotoFirstSubKey(kv, false))
		{
			// Current key is a regular key, or an empty section.
			if (KvGetDataType(kv, NULL_STRING) != KvData_None)
			{
				siz++;
			}
		}
	}
	while (KvGotoNextKey(kv, false));
	return siz;
}

void BrowseWeaponsCatKV(Handle kv)
{
	int u_id = 0;
	int t_idx = 0;
	SetTrieValue(_weaponlist_names, "body_scout" , t_idx++, false);
	SetTrieValue(_weaponlist_names, "body_sniper" , t_idx++, false);
	SetTrieValue(_weaponlist_names, "body_soldier" , t_idx++, false);
	SetTrieValue(_weaponlist_names, "body_demoman" , t_idx++, false);
	SetTrieValue(_weaponlist_names, "body_medic" , t_idx++, false);
	SetTrieValue(_weaponlist_names, "body_heavy" , t_idx++, false);
	SetTrieValue(_weaponlist_names, "body_pyro" , t_idx++, false);
	SetTrieValue(_weaponlist_names, "body_spy" , t_idx++, false);
	SetTrieValue(_weaponlist_names, "body_engie" , t_idx++, false);
	char Buf[64];
	do
	{
		if (KvGotoFirstSubKey(kv, false))
		{
			BrowseWeaponsCatKV(kv);
			KvGoBack(kv);
		}
		else
		{
			if (KvGetDataType(kv, NULL_STRING) != KvData_None)
			{
				KvGetSectionName(kv, Buf, sizeof(Buf));
				wcnamelist[u_id] = Buf;
				KvGetString(kv, "", Buf, 64);
				if (SetTrieValue(_weaponlist_names, Buf, t_idx, false))
				{
					t_idx++;
				}
				GetTrieValue(_weaponlist_names, Buf, wcname_l_idx[u_id]);
				//PrintToServer("weapon list %d: %s - %s(%d)", u_id,wcnamelist[u_id], Buf, wcname_l_idx[u_id])
				u_id++;
				//PrintToServer("%s linked : %s->%d",  wcnamelist[u_id], Buf,wcname_l_idx[u_id])
				//PrintToServer("value:%s", Buf)
			}
		}
	}
	while (KvGotoNextKey(kv, false));
}

int BrowseAttributesKV(Handle kv)
{
	char Buf[64];
	do
	{
		if (KvGotoFirstSubKey(kv, false))
		{
			//PrintToServer("\nAttribute #%d", _u_id)
			BrowseAttributesKV(kv);
			KvGoBack(kv);
		}
		else
		{
			// Current key is a regular key, or an empty section.
			if (KvGetDataType(kv, NULL_STRING) != KvData_None)
			{
				KvGetSectionName(kv, Buf, sizeof(Buf));
				if (!strcmp(Buf,"ref"))
				{
					KvGetString(kv, "", Buf, 64);
					upgradesNames[_u_id] = Buf;
					SetTrieValue(_upg_names, Buf, _u_id, true);
				//	PrintToServer("ref:%s --uid:%d", Buf, _u_id)
				}
				if (!strcmp(Buf,"name"))
				{
					KvGetString(kv, "", Buf, 64);
					if (strcmp(Buf,""))
					{
						//PrintToServer("Name:%s-", Buf)
						for (int i_ = 1; i_ < MAX_ATTRIBUTES; i_++)
						{
							if (!strcmp(upgradesWorkNames[i_], Buf))
							{
								upgrades_to_a_id[_u_id] = i_;
							//	PrintToServer("up_ref/id[%d]:%s/%d", _u_id, Buf, upgrades_to_a_id[_u_id])
								break;
							}
						}
					}
				}
				if (!strcmp(Buf,"cost"))
				{
					KvGetString(kv, "", Buf, 64);
					upgrades_costs[_u_id] = StringToInt(Buf);
					//PrintToServer("cost:%d", upgrades_costs[_u_id])
				}
				if (!strcmp(Buf,"increase_ratio"))
				{
					KvGetString(kv, "", Buf, 64);
					upgrades_costs_inc_ratio[_u_id] = StringToFloat(Buf);
					//PrintToServer("increase rate:%f", upgrades_costs_inc_ratio[_u_id])
				}
				if (!strcmp(Buf,"value"))
				{
					KvGetString(kv, "", Buf, 64);
					upgrades_ratio[_u_id] = StringToFloat(Buf);
					//PrintToServer("val:%f", upgrades_ratio[_u_id])
				}
				if (!strcmp(Buf,"init"))
				{
					KvGetString(kv, "", Buf, 64);
					upgrades_i_val[_u_id] = StringToFloat(Buf);
					//PrintToServer("init:%f", upgrades_i_val[_u_id])
				}
				if (!strcmp(Buf,"max"))
				{
					KvGetString(kv, "", Buf, 64);
					upgrades_m_val[_u_id] = StringToFloat(Buf);
					//PrintToServer("max:%f", upgrades_m_val[_u_id])
					_u_id++;
				}

			}
		}
	}
	while (KvGotoNextKey(kv, false));
	return _u_id;
}


void BrowseAttListKV(Handle kv, int &w_id = -1, int &w_sub_id = -1, int w_sub_att_idx = -1, int level = 0)
{
	char Buf[64];
	do
	{
		KvGetSectionName(kv, Buf, sizeof(Buf));
		if (level == 1)
		{
			if (!GetTrieValue(_weaponlist_names, Buf, w_id))
			{
				PrintToServer("[uu_lists] Malformated uu_lists | uu_weapon.txt file?: %s was not found", Buf);
			}
			w_sub_id = -1;
			given_upgrd_classnames_tweak_nb[w_id] = 0;
		}
		if (level == 2)
		{
			KvGetSectionName(kv, Buf, sizeof(Buf));
			if (!strcmp(Buf, "special_tweaks_listid"))
			{

				KvGetString(kv, "", Buf, 64);
				//PrintToServer("  ->Sublist/#%s -- #%d", Buf, w_id)
				given_upgrd_classnames_tweak_idx[w_id] = StringToInt(Buf);
			}
			else
			{
				w_sub_id++;
			//	PrintToServer("section #%s", Buf)
				given_upgrd_classnames[w_id][w_sub_id] = Buf;
				given_upgrd_list_nb[w_id]++;
				w_sub_att_idx = 0;
			}
		}
		if (KvGotoFirstSubKey(kv, false))
		{
			KvGetSectionName(kv, Buf, sizeof(Buf));
			BrowseAttListKV(kv, w_id, w_sub_id, w_sub_att_idx, level + 1);
			KvGoBack(kv);
		}
		else
		{
			if (KvGetDataType(kv, NULL_STRING) != KvData_None)
			{
				int attr_id;
				KvGetSectionName(kv, Buf, sizeof(Buf));
			//	PrintToServer("section:%s", Buf)
				if (strcmp(Buf, "special_tweaks_listid"))
				{
					KvGetString(kv, "", Buf, 64);
					if (w_sub_id == given_upgrd_classnames_tweak_idx[w_id])
					{
						given_upgrd_classnames_tweak_nb[w_id]++;
						if (!GetTrieValue(_spetweaks_names, Buf, attr_id))
						{
							PrintToServer("[uu_lists] Malformated uu_lists | uu_specialtweaks.txt file?: %s was not found", Buf);
						}
					}
					else
					{
						if (!GetTrieValue(_upg_names, Buf, attr_id))
						{
							PrintToServer("[uu_lists] Malformated uu_lists | uu_attributes.txt file?: %s was not found", Buf);
						}
					}
			//		PrintToServer("             **list%d sublist%d %d :%s(%d)", w_sub_att_idx, w_id, w_sub_id, Buf, attr_id)
					given_upgrd_list[w_id][w_sub_id][w_sub_att_idx] = attr_id;
					w_sub_att_idx++;
				}
			}
		}
	}
	while (KvGotoNextKey(kv, false));
}


int BrowseSpeTweaksKV(Handle kv, int &u_id = -1, int att_id = -1, int level = 0)
{
	char Buf[64];
	int attr_ref;
	do
	{
		if (level == 2)
		{
			KvGetSectionName(kv, Buf, sizeof(Buf));
			u_id++;
			SetTrieValue(_spetweaks_names, Buf, u_id);
			upgrades_tweaks[u_id] = Buf;
			upgrades_tweaks_nb_att[u_id] = 0;
			att_id = 0;
		}
		if (level == 3)
		{
			KvGetSectionName(kv, Buf, sizeof(Buf));
			if (!GetTrieValue(_upg_names, Buf, attr_ref))
			{
				PrintToServer("[spetw_lists] Malformated uu_specialtweaks | uu_attribute.txt file?: %s was not found", Buf);
			}
		//	PrintToServer("Adding Special tweak [%s] attribute %s(%d)", upgrades_tweaks[u_id], Buf, attr_ref)
			upgrades_tweaks_att_idx[u_id][att_id] = attr_ref;
			KvGetString(kv, "", Buf, 64);
			upgrades_tweaks_att_ratio[u_id][att_id] = StringToFloat(Buf);
		//	PrintToServer("               ratio => %f)", upgrades_tweaks_att_ratio[u_id][att_id])
			upgrades_tweaks_nb_att[u_id]++;
			att_id++;
		}
		if (KvGotoFirstSubKey(kv, false))
		{
			BrowseSpeTweaksKV(kv, u_id, att_id, level + 1);
			KvGoBack(kv);
		}
	}
	while (KvGotoNextKey(kv, false));
	return u_id;
}

bool LoadConfigFiles()
{
	_upg_names = CreateTrie();
	_weaponlist_names = CreateTrie();
	_spetweaks_names = CreateTrie();

	Handle kv = CreateKeyValues("uu_weapons");
	kv = CreateKeyValues("weapons");
	FileToKeyValues(kv, "addons/sourcemod/configs/uu_weapons.txt");
	if (!KvGotoFirstSubKey(kv))
	{
		return false;
	}
	int siz = GetWeaponsCatKVSize(kv);
	PrintToServer("[UberUpgrades] %d weapons loaded", siz);
	KvRewind(kv);
	BrowseWeaponsCatKV(kv);
	CloseHandle(kv);


	kv = CreateKeyValues("attribs");
	FileToKeyValues(kv, "addons/sourcemod/configs/uu_attributes.txt");
	_u_id = 0;
	PrintToServer("browsin uu attribs (kvh:%d)", kv);
	BrowseAttributesKV(kv);
	PrintToServer("[UberUpgrades] %d attributes loaded", _u_id);
	CloseHandle(kv);



	int static_uid = -1;
	kv = CreateKeyValues("special_tweaks");
	FileToKeyValues(kv, "addons/sourcemod/configs/uu_specialtweaks.txt");
	BrowseSpeTweaksKV(kv, static_uid);
	PrintToServer("[UberUpgrades] %d special tweaks loaded", static_uid);
	CloseHandle(kv);

	static_uid = -1;
	kv = CreateKeyValues("lists");
	FileToKeyValues(kv, "addons/sourcemod/configs/uu_lists.txt");
	BrowseAttListKV(kv, static_uid);
	PrintToServer("[UberUpgrades] %d lists loaded", static_uid);
	CloseHandle(kv);

	//TODO -> buyweapons.cfg
	newweaponidx[0] = 13;
	newweaponcn[0] = "tf_weapon_scattergun";
	newweaponmenudesc[0] = "Scattergun";

	CreateBuyNewWeaponMenu();
	return true;
}
stock bool IsValidClient(int client)
{
	return (0 < client <= MaxClients && IsClientInGame(client));
}
stock bool TF2_IsPlayerCritBuffed(int client)
{
	return (TF2_IsPlayerInCondition(client, TFCond_Kritzkrieged) || TF2_IsPlayerInCondition(client, TFCond_HalloweenCritCandy) || TF2_IsPlayerInCondition(client, TFCond 34)
	|| TF2_IsPlayerInCondition(client, TFCond 35) || TF2_IsPlayerInCondition(client, TFCond_CritOnFirstBlood) || TF2_IsPlayerInCondition(client, TFCond_CritOnWin)
	|| TF2_IsPlayerInCondition(client, TFCond_CritOnFlagCapture) || TF2_IsPlayerInCondition(client, TFCond_CritOnKill) || TF2_IsPlayerInCondition(client, TFCond_CritMmmph));
}

//Initialize New Weapon menu
void CreateBuyNewWeaponMenu()
{
	BuyNWmenu = CreateMenu(MenuHandler_BuyNewWeapon);

	SetMenuTitle(BuyNWmenu, "***Choose additional weapon for 200$:");

	for (int i=0; i < NB_B_WEAPONS; i++)
	{
		AddMenuItem(BuyNWmenu, "tweak", newweaponmenudesc[i]);
	}
	SetMenuExitButton(BuyNWmenu, true);
	SetMenuExitBackButton(BuyNWmenu, true);
}

//Initialize menus , CVARs, con cmds and timers handlers on plugin load
void UberShopinitMenusHandlers()
{
	LoadTranslations("tf2items_uu.phrases.txt");
	LoadTranslations("common.phrases.txt");
	BuyNWmenu_enabled = true;

	CreateConVar("uberupgrades_version", UU_VERSION, "The Plugin Version. Don't change.", FCVAR_NOTIFY|FCVAR_DONTRECORD|FCVAR_SPONLY|FCVAR_REPLICATED);
	cvar_MoneyBonusKill = CreateConVar("sm_uu_moneybonuskill", "100", "Sets the money bonus a client gets for killing: default 100");
	cvar_AutoMoneyForTeamRatio = CreateConVar("sm_uu_automoneyforteam_ratio", "1", "If set to 1, the plugin will manage money balancing");
	cvar_TimerMoneyGive_BlueTeam = CreateConVar("sm_uu_timermoneygive_blueteam", "100.0", "Sets the money blue team get every timermoney event: default 100.0");
	cvar_TimerMoneyGive_RedTeam = CreateConVar("sm_uu_timermoneygive_redteam", "100.0", "Sets the money blue team get every timermoney event: default 80.0");
	MoneyBonusKill = GetConVarInt(cvar_MoneyBonusKill);
	MoneyForTeamRatio[RED]  =  0.9;
	MoneyForTeamRatio[BLUE]  = 0.9;
	TimerMoneyGive_BlueTeam = GetConVarFloat(cvar_TimerMoneyGive_BlueTeam);
	TimerMoneyGive_RedTeam = GetConVarFloat(cvar_TimerMoneyGive_RedTeam);

	RegAdminCmd("sm_us_enable_buy_new_weapon", EnableBuyNewWeapon, ADMFLAG_GENERIC);
	RegAdminCmd("sm_setcash", Command_SetCash, ADMFLAG_GENERIC, "Sets cash of selected target/targets.");
	RegAdminCmd("sm_addcash", Command_AddCash, ADMFLAG_GENERIC, "Adds cash of selected target/targets.");
	RegAdminCmd("sm_removecash", Command_RemoveCash, ADMFLAG_GENERIC, "Removes cash of selected target/targets.");
	RegAdminCmd("sm_reload_cfg", ReloadCfgFiles, ADMFLAG_GENERIC);//
	RegConsoleCmd("sm_uudteamup", Toggl_DispTeamUpgrades);
	RegConsoleCmd("sm_uurspwn", Toggl_DispMenuRespawn);
	RegConsoleCmd("sm_uunoname", Toggl_NameLevel);
	//Please don't change this, it's for cross compat binds.
	RegConsoleCmd("sm_buy", Menu_BuyUpgrade);
	RegConsoleCmd("buy", Menu_BuyUpgrade);
	RegConsoleCmd("qbuy", Menu_QuickBuyUpgrade);
	RegConsoleCmd("sm_qbuy", Menu_QuickBuyUpgrade);
	RegConsoleCmd("sm_upgrade", Menu_BuyUpgrade);
	HookEvent("post_inventory_application", Event_PlayerreSpawn);
	HookEvent("player_spawn", Event_PlayerreSpawn);
	HookEvent("teamplay_round_start", Event_RoundStart);
	HookEventEx("player_hurt", Event_Playerhurt, EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("player_changeclass", Event_PlayerChangeClass);
	HookEvent("player_class", Event_PlayerChangeClass);
	HookEvent("player_team", Event_PlayerChangeTeam);
	//MVM
	HookEvent("mvm_pickup_currency", Event_PlayerCollectMoney, EventHookMode_Pre);
	HookEvent("mvm_wave_complete", Event_mvm_wave_complete);
	HookEvent("mvm_begin_wave", Event_mvm_wave_begin);
	HookEvent("mvm_wave_complete", Event_mvm_wave_complete);
	HookEvent("teamplay_round_win", Event_teamplay_round_win);
	AddCommandListener(jointeam_callback, "jointeam");

	Timers_[0] = CreateTimer(20.0, Timer_GetConVars, _, TIMER_REPEAT);
	Timers_[1] = CreateTimer(5.0, Timer_GiveSomeMoney, _, TIMER_REPEAT);
	Timers_[2] = CreateTimer(0.333, Timer_GiveHealth, _, TIMER_REPEAT);
	Timers_[3] = CreateTimer(1.0, Timer_PrintMoneyHud, _, TIMER_REPEAT);

	moneyLevels[0] = 125;
	for (int level = 1; level < MAXLEVEL_D; level++)
	{
		moneyLevels[level] = (125 + ((level + 1) * 50)) + moneyLevels[level - 1];
	}
}

//Initialize menus , CVARs, con cmds and timers handlers on plugin load
void UberShopUnhooks()
{
	UnhookEvent("post_inventory_application", Event_PlayerreSpawn);
	UnhookEvent("player_spawn", Event_PlayerreSpawn);
	UnhookEvent("teamplay_round_start", Event_RoundStart);

	UnhookEvent("player_changeclass", Event_PlayerChangeClass);
	UnhookEvent("player_class", Event_PlayerChangeClass);
	UnhookEvent("player_team", Event_PlayerChangeTeam);

	UnhookEvent("mvm_begin_wave", Event_mvm_wave_begin);

	UnhookEvent("mvm_wave_complete", Event_mvm_wave_complete);
	UnhookEvent("teamplay_round_win", Event_teamplay_round_win);

	KillTimer(Timers_[0]);
	KillTimer(Timers_[1]);
	KillTimer(Timers_[2]);
	KillTimer(Timers_[3]);
}

int GetUpgrade_CatList(const char[] WCName)
{
	int i, wis, w_id;

	wis = 0;// wcname_idx_start[cl_class]
	//PrintToChatAll("Class: %d; WCname:%s", cl_class, WCName);
	for (i = wis, w_id = -1; i < WCNAMELISTSIZE; i++)
	{
		if (!strcmp(wcnamelist[i], WCName, false))
		{
			w_id = wcname_l_idx[i];
			//PrintToChatAll("wid found; %d", w_id)
			return w_id;
		}
	}
	if (w_id < -1)
	{
		PrintToServer("UberUpgrade error: #%s# was not a valid weapon classname..", WCName);
	}
	return w_id;
}

public Action Command_MyMoney(int client, int args){
	PrintToChat(client, "You have %f", CurrencyOwned[client]); // todo, test this
}
public void OnPluginStart()
{
	RegConsoleCmd("sm_mymoney", Command_MyMoney, "Show my money");
	UberShopinitMenusHandlers();
	cvarStartMoney = CreateConVar("fb_startmoney", "50000", "Starting money for FartsysAss UbUps. Default = 50000, Taco Bell = 200000, can be anything though.");
	UberShopDefineUpgradeTabs();
	SetConVarFloat(FindConVar("sv_maxvelocity"), 10000000.0, true, false); //Up the cap for the speed of projectiles
	//SetConVarInt(FindConVar("tf_weapon_criticals"), 0, true, false); //Disables random crits
	GetConVarString(cvarStartMoney, tempStartMoney, sizeof(tempStartMoney));
	RealStartMoney = StringToFloat(tempStartMoney);
	PrintToServer("Start Money is %f", RealStartMoney);
	for (int client = 0; client < MAXPLAYERS + 1; client++)
	{
		if (IsValidClient(client))
		{
			client_no_d_team_upgrade[client] = 1;
			ResetClientUpgrades(client);
			current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
			//PrintToChat(client, "client changeclass");
			if (!client_respawn_handled[client])
			{
				CreateTimer(0.2, ClChangeClassTimer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
			CurrencyOwned[client] = RealStartMoney;
		}
	}
}

public void OnPluginEnd()
{
	PrintToServer("Unloading plugin");
	UberShopUnhooks();
	PrintToServer("Plugin unloaded");
}

public Action Timer_PrintMoneyHud(Handle timer)
{
	for (int i = 1; i < MAXPLAYERS + 1; i++)
	{
		if (IsValidClient(i))
		{
			char Buffer[12];
			Format(Buffer, sizeof(Buffer), "%d$", client_iCash[i]);
			SetHudTextParams(0.9, 0.8, 1.0, 255,0,0,255);
			ShowHudText(i, -1, Buffer);
		}
	}
	return Plugin_Continue;
}

/*player_spawn
Scout, Soldier, Pyro, DemoMan, Heavy, Medic, Sniper:
[code]0 - Primary 1 - Secondary 2 - Melee[/code]
Engineer:
[code]0 - Primary 1 - Secondary 2 - Melee 3 - Construction PDA 4 - Destruction PDA 5 - Building[/code]
Spy:
[code]0 - Secondary 1 - Sapper 2 - Melee 3 - Disguise Kit 4 - Invisibility Watch[/code]
*/
public Action Command_SetCash(int client, int args)
{
	if(args != 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setcash \"target\" \"amount\"");
		return Plugin_Handled;
	}

	char strTarget[MAX_TARGET_LENGTH];
	char strCash[128];
	float GivenCash;
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS];
	int target_count;
	bool tn_is_ml;
	GetCmdArg(1, strTarget, sizeof(strTarget));
	if((target_count = ProcessTargetString(strTarget, client, target_list, MAXPLAYERS, COMMAND_FILTER_NO_BOTS, target_name, sizeof(target_name), tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	GetCmdArg(2, strCash, sizeof(strCash));
	GivenCash = StringToFloat(strCash);

	for(int i = 0; i < target_count; i++)
	{
		CurrencyOwned[target_list[i]] = GivenCash;
	}
	return Plugin_Handled;
}
public Action Command_AddCash(int client, int args)
{
	if(args != 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_addcash \"target\" \"amount\"");
		return Plugin_Handled;
	}
	char strTarget[MAX_TARGET_LENGTH];
	char strCash[128];
	float GivenCash;
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS];
	int target_count;
	bool tn_is_ml;
	GetCmdArg(1, strTarget, sizeof(strTarget));
	if((target_count = ProcessTargetString(strTarget, client, target_list, MAXPLAYERS, COMMAND_FILTER_NO_BOTS, target_name, sizeof(target_name), tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	GetCmdArg(2, strCash, sizeof(strCash));
	GivenCash = StringToFloat(strCash);
	for(int i = 0; i < target_count; i++)
	{
		CurrencyOwned[target_list[i]] += GivenCash;
	}
	return Plugin_Handled;
}
public Action Command_RemoveCash(int client, int args)
{
	if(args != 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_removecash \"target\" \"amount\"");
		return Plugin_Handled;
	}
	
	char strTarget[MAX_TARGET_LENGTH];
	char strCash[128];
	float GivenCash;
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS];
	int target_count;
	bool tn_is_ml;
	GetCmdArg(1, strTarget, sizeof(strTarget));
	if((target_count = ProcessTargetString(strTarget, client, target_list, MAXPLAYERS, COMMAND_FILTER_NO_BOTS, target_name, sizeof(target_name), tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	GetCmdArg(2, strCash, sizeof(strCash));
	GivenCash = StringToFloat(strCash);

	for(int i = 0; i < target_count; i++)
	{
		CurrencyOwned[target_list[i]] -= GivenCash;
	}
	return Plugin_Handled;
}
bool GiveNewWeapon(int client, int slot)
{
	Handle newItem = TF2Items_CreateItem(OVERRIDE_ALL);
	int Flags = 0;

	int itemDefinitionIndex = currentitem_idx[client][slot];
	TF2Items_SetItemIndex(newItem, itemDefinitionIndex);
	currentitem_level[client][slot] = 242;

	TF2Items_SetLevel(newItem, 242);

	Flags |= PRESERVE_ATTRIBUTES;

	TF2Items_SetFlags(newItem, Flags);

	TF2Items_SetClassname(newItem, currentitem_classname[client][slot]);

	slot = 6;
	int weaponIndextorem_ = GetPlayerWeaponSlot(client, slot);
	int weaponIndextorem = weaponIndextorem_;


	int entity = TF2Items_GiveNamedItem(client, newItem);
	if (IsValidEntity(entity))
	{
		TF2Attrib_SetByDefIndex(entity,825 ,1.0);
		while ((weaponIndextorem = GetPlayerWeaponSlot(client, slot)) != -1)
		{
			RemovePlayerItem(client, weaponIndextorem);
			RemoveEdict(weaponIndextorem);
		}
		client_new_weapon_ent_id[client] = entity;
		EquipPlayerWeapon(client, entity);
		return true;
	}
	return false;
}

void GiveNewUpgradedWeapon_(int client, int slot)
{
	TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.001);
	int a, iNumAttributes;
	int iEnt;
	iNumAttributes = currentupgrades_number[client][slot];
	if(currentitem_ent_idx[client][0] == 1101)
	{
		iEnt = currentitem_ent_idx[client][0];
	}
	if (slot == 4 && IsValidEntity(client))
	{
		iEnt = client;
	}
	else if (currentitem_level[client][slot] != 242)
	{
		iEnt = currentitem_ent_idx[client][slot];
	}
	else
	{
		slot = 3;
		iEnt = client_new_weapon_ent_id[client];
	}
	if (IsValidEntity(iEnt))
	{
		//PrintToChatAll("trytoremov slot %d", slot);
		if( iNumAttributes > 0 )
		{
			for( a = 0; a < 42 && a < iNumAttributes ; a++ )
			{
				int uuid = upgrades_to_a_id[currentupgrades_idx[client][slot][a]];
				if (strcmp(upgradesWorkNames[uuid], ""))
				{
					TF2Attrib_SetByName(iEnt, upgradesWorkNames[uuid], currentupgrades_val[client][slot][a]);
				}
			}
		}
		TF2Attrib_ClearCache(iEnt);
	}
}

bool is_client_got_req(int param1, int upgrade_choice, int slot, int inum)
{
	int iCash = GetEntProp(param1, Prop_Send, "m_nCurrency", iCash);
	int up_cost = upgrades_costs[upgrade_choice];
	int max_ups = currentupgrades_number[param1][slot];
	up_cost /= 2;
	client_iCash[param1] = iCash;
	if (slot == 1)
	{
		up_cost = RoundFloat((up_cost * 1.0) * 0.75); //-25% cost reduction on secondary weapons.
	}
	if (inum != 9999 && upgrades_ratio[upgrade_choice])
	{
		up_cost += RoundFloat(up_cost * ((currentupgrades_val[param1][slot][inum] - upgrades_i_val[upgrade_choice]) / upgrades_ratio[upgrade_choice]) * upgrades_costs_inc_ratio[upgrade_choice]);
		if (up_cost < 0.0)
		{
			up_cost *= -1;
			if (up_cost < (upgrades_costs[upgrade_choice] / 2))
			{
				up_cost = upgrades_costs[upgrade_choice] / 2;
			}
		}
	}
	if (CurrencyOwned[param1] < up_cost)
	{
		char buffer[128];
		Format(buffer, sizeof(buffer), "%T", "You have not enough money!!", param1);
		PrintToChat(param1, buffer);
		return false;
	}
	else
	{
		if (inum != 9999)
		{
			if (currentupgrades_val[param1][slot][inum] == upgrades_m_val[upgrade_choice])
			{
				PrintToChat(param1, "You already have reached the maximum upgrade for this category.");
				return false;
			}
		}
		else
		{
			if (max_ups >= MAX_ATTRIBUTES_ITEM)
			{
				PrintToChat(param1, "You have reached the maximum number of upgrade category for this item.");
				return false;
			}
		}

		CurrencyOwned[param1] -= up_cost;
		client_spent_money[param1][slot] += up_cost;
		int totalmoney = 0;
		for (int s = 0; s < 5; s++)
		{
			totalmoney += client_spent_money[param1][s];
		}
		int ctr_m = clientLevels[param1];

		while (ctr_m < MAXLEVEL_D && totalmoney > moneyLevels[ctr_m])
		{
			ctr_m++;
		}
		if (ctr_m != clientLevels[param1])
		{
			clientLevels[param1] = ctr_m;
			char clname[255];
			char strsn[12];
			if (ctr_m == MAXLEVEL_D)
			{
				strsn = "[_Over9000]";
			}
			else
			{
				Format(strsn, sizeof(strsn), "[Lvl %d]", ctr_m + 1);
			}
			Format(clname, sizeof(clname), "%s%s", strsn, clientBaseName[param1]);
			if(client_no_d_name[param1] == 1)
			{
				SetClientInfo(param1, "name", clname);
			}
		}
		return true;
	}
}

void check_apply_maxvalue(int param1, int slot, int inum, int upgrade_choice)
{
	if ((upgrades_ratio[upgrade_choice] > 0.0 && currentupgrades_val[param1][slot][inum] > upgrades_m_val[upgrade_choice]) || (upgrades_ratio[upgrade_choice] < 0.0 && currentupgrades_val[param1][slot][inum] < upgrades_m_val[upgrade_choice]))
	{
		currentupgrades_val[param1][slot][inum] = upgrades_m_val[upgrade_choice];
	}
}

void UpgradeItem(int param1, int upgrade_choice, int inum, float ratio)
{
	int slot = current_slot_used[param1];
	//PrintToChat(param1, "Entering #upprimary");


	if (inum == 9999)
	{
		inum = currentupgrades_number[param1][slot];
		upgrades_ref_to_idx[param1][slot][upgrade_choice] = inum;
		currentupgrades_idx[param1][slot][inum] = upgrade_choice;
		currentupgrades_val[param1][slot][inum] = upgrades_i_val[upgrade_choice];
		currentupgrades_number[param1][slot] = currentupgrades_number[param1][slot] + 1;
		//PrintToChat(param1, "#upprimary Adding New Upgrade uslot(%d) [%s]", inum, upgradesNames[upgrade_choice]);
		currentupgrades_val[param1][slot][inum] += (upgrades_ratio[upgrade_choice] * ratio);
	}
	else
	{
	//	PrintToChat(param1, "#upprimary existin attr: %d", inum)
	//	PrintToChat(param1, "#upprimary ++ Existing Upgrade(%d) %d[%s]", inum, currentupgrades_idx[param1][slot][inum], upgradesNames[upgrade_choice]);
		currentupgrades_val[param1][slot][inum] += (upgrades_ratio[upgrade_choice] * ratio);
		check_apply_maxvalue(param1, slot, inum, upgrade_choice);
	}
		//PrintToChat(param1, "#upprimary Entering givenew to slot %d", slot);
	client_last_up_idx[param1] = upgrade_choice;
	client_last_up_slot[param1] = slot;
	//PrintToChat(param1, "exit ...#upprimary");
}

void ResetClientUpgrade_slot(int client, int slot)
{
	int i;
	int iNumAttributes = currentupgrades_number[client][slot];

	//PrintToChat(client, "#resetupgrade monweyspend-> %d", client_spent_money[client][slot]);
	if (client_spent_money[client][slot])
	{
		CurrencyOwned[client] += client_spent_money[client][slot];
	}
	currentitem_level[client][slot] = 0;
	client_spent_money[client][slot] = 0;
	client_spent_money_mvm_chkp[client][slot] = 0;
	currentupgrades_number[client][slot] = 0;
//	PrintToChat(client, "enter ...#resetupgradeslot %d, resetting values for %d attributes", slot, iNumAttributes);

	for (i = 0; i < iNumAttributes; i++)
	{
		upgrades_ref_to_idx[client][slot][currentupgrades_idx[client][slot][i]] = 9999;
	}

	if (slot != 4 && currentitem_idx[client][slot])
	{
		currentitem_idx[client][slot] = 9999;
		GiveNewUpgradedWeapon_(client, slot);
	}
	if (slot == 3 && client_new_weapon_ent_id[client])
	{
		currentitem_idx[client][3] = 9999;
		currentitem_ent_idx[client][3] = -1;
		GiveNewUpgradedWeapon_(client, slot);
		client_new_weapon_ent_id[client] = 0;
	}
	if (slot == 4)
	{
		GiveNewUpgradedWeapon_(client, slot);
	}
	int totalmoney = 0;
	for (int s = 0; s < 5; s++)
	{
		totalmoney += client_spent_money[client][s];
	}
	int ctr_m = clientLevels[client];

	while (ctr_m && totalmoney < moneyLevels[ctr_m])
	{
		ctr_m--;
	}
	if (ctr_m != clientLevels[client])
	{
		clientLevels[client] = ctr_m;
		char strsn[12];
		char clname[255];
		if (ctr_m == MAXLEVEL_D)
		{
			strsn = "[_Over9000]";
		}
		else
		{
			Format(strsn, sizeof(strsn), "[Lvl %d]", ctr_m + 1);
		}
		Format(clname, sizeof(clname), "%s%s", strsn, clientBaseName[client]);
		if(client_no_d_name[client] == 1)
		{
			SetClientInfo(client, "name", clname);
		}
	}
}

void ResetClientUpgrades(int client)
{
	int slot;

	client_respawn_handled[client] = 0;
	for (slot = 0; slot < NB_SLOTS_UED; slot++)
	{
		ResetClientUpgrade_slot(client, slot);
		//PrintToChatAll("reste all upgrade slot %d", slot)
	}
}


void DefineAttributesTab(int client, int itemidx, int slot)
{
	//PrintToChat(client, "Entering Def attr tab, ent id: %d", itemidx);
	//PrintToChat(client, "  #dattrtab item carried: %d - item_buff: %d", itemidx, currentitem_idx[client][slot]);
	if (currentitem_idx[client][slot] == 9999)
	{
		int a, a2, i, a_i;

		currentitem_idx[client][slot] = itemidx;
		int inumAttr = TF2II_GetItemNumAttributes( itemidx );
		for( a = 0, a2 = 0; a < inumAttr && a < 42; a++ )
		{
			char Buf[64];
			a_i = TF2II_GetItemAttributeID( itemidx, a);
			TF2II_GetAttribName( a_i, Buf, 64);
			if (GetTrieValue(_upg_names, Buf, i))
			{
				currentupgrades_idx[client][slot][a2] = i;

				upgrades_ref_to_idx[client][slot][i] = a2;
				currentupgrades_val[client][slot][a2] = TF2II_GetItemAttributeValue( itemidx, a );
				//PrintToChat(client, "init-attribute-[%s]%d [%d ; %f]",
				a2++;
			}
		}
		currentupgrades_number[client][slot] = a2;
	}
	else
	{
		if (itemidx > 0 && itemidx != currentitem_idx[client][slot])
		{
			ResetClientUpgrade_slot(client, slot);
			int a, a2, i, a_i;

			currentitem_idx[client][slot] = itemidx;
			int inumAttr = TF2II_GetItemNumAttributes( itemidx );
			for( a = 0, a2 = 0; a < inumAttr && a < 42; a++ )
			{
				char Buf[64];
				a_i = TF2II_GetItemAttributeID( itemidx, a);
				TF2II_GetAttribName( a_i, Buf, 64);
				if (GetTrieValue(_upg_names, Buf, i))
				{
					currentupgrades_idx[client][slot][a2] = i;

					upgrades_ref_to_idx[client][slot][i] = a2;
					currentupgrades_val[client][slot][a2] = TF2II_GetItemAttributeValue( itemidx, a );
					//PrintToChat(client, "init-attribute-%d [%d ; %f]", itemidx, i, currentupgrades_val[client][slot][a]);
					a2++;
				}
			}
			currentupgrades_number[client][slot] = a2;
		}
	}
	//PrintToChat(client, "..finish #dattrtab ");
}


void Menu_TweakUpgrades(int param1)
{
	Handle menu = CreateMenu(MenuHandler_AttributesTweak);
	int s;

	SetMenuTitle(menu, "Remove downgrades or Display Upgrades");
	for (s = 0; s < 5; s++)
	{
		char fstr[100];
		Format(fstr, sizeof(fstr), "%d$ of upgrades | Modify or Remove my %s attributes", client_spent_money[param1][s], current_slot_name[s]);
		AddMenuItem(menu, "tweak", fstr);
	}
	SetMenuExitBackButton(menu, true);
	if (IsValidClient(param1) && IsPlayerAlive(param1))
	{
		DisplayMenu(menu, param1, MENU_TIME_FOREVER);
	}
}

void Menu_TweakUpgrades_slot(int param1, int arg, int page)
{
	if (arg > -1 && arg < 5 && IsValidClient(param1) && IsPlayerAlive(param1))
	{
		Handle menu = CreateMenu(MenuHandler_AttributesTweak_action);
		int i, s;
			
		s = arg;
		current_slot_used[param1] = s;
		SetMenuTitle(menu, "%.0f$ ***%s - Choose attribute:", CurrencyOwned[param1], current_slot_name[s]);
		char buf[128];
		char fstr[255];
		for (i = 0; i < currentupgrades_number[param1][s]; i++)
		{
			int u = currentupgrades_idx[param1][s][i];
			Format(buf, sizeof(buf), "%T", upgradesNames[u], param1);
			if (upgrades_costs[u] < -0.0001)
			{
				int nb_time_upgraded = RoundFloat((upgrades_i_val[u] - currentupgrades_val[param1][s][i]) / upgrades_ratio[u]);
				int up_cost = upgrades_costs[u] * nb_time_upgraded * 3;
				Format(fstr, sizeof(fstr), "[%s] :\n\t\t%10.2f\n%d", buf, currentupgrades_val[param1][s][i], up_cost);
			}
			else
			{
				Format(fstr, sizeof(fstr), "[%s] :\n\t\t%10.2f", buf, currentupgrades_val[param1][s][i]);
			}
			AddMenuItem(menu, "yep", fstr);
		}
		if (IsValidClient(param1) && IsPlayerAlive(param1))
		{
			DisplayMenu(menu, param1, MENU_TIME_FOREVER);
		}
		DisplayMenuAtItem(menu, param1, page, MENU_TIME_FOREVER);
	}
}

void remove_attribute(int client, int inum)
{
	int slot = current_slot_used[client];
	currentupgrades_val[client][slot][inum] = upgrades_i_val[currentupgrades_idx[client][slot][inum]];
	GiveNewUpgradedWeapon_(client, slot);
}



//menubuy 3- choose the upgrade
public void Menu_SpecialUpgradeChoice(int client, int cat_choice, char TitleStr[100], int selectidx)
{
	//PrintToChat(client, "Entering menu_upchose");
	int i, j;

	Handle menu = CreateMenu(MenuHandler_SpecialUpgradeChoice);
	SetMenuPagination(menu, 2);
	//PrintToChat(client, "Entering menu_upchose [%d] wid%d", cat_choice, current_w_list_id[client]);
	if (cat_choice != -1)
	{
		char desc_str[512];
		int w_id = current_w_list_id[client];
		int tmp_up_idx;
		int tmp_spe_up_idx;
		int tmp_ref_idx;
		float tmp_val;
		float tmp_ratio;
		int slot;
		char plus_sign[1];
		char buft[64];

		current_w_c_list_id[client] = cat_choice;
		slot = current_slot_used[client];
		for (i = 0; i < given_upgrd_classnames_tweak_nb[w_id]; i++)
		{
			tmp_spe_up_idx = given_upgrd_list[w_id][cat_choice][i];
			Format(buft, sizeof(buft), "%T",  upgrades_tweaks[tmp_spe_up_idx], client);
			//PrintToChat(client, "--->special ID", tmp_spe_up_idx);
			desc_str = buft;
			for (j = 0; j < upgrades_tweaks_nb_att[tmp_spe_up_idx]; j++)
			{
				tmp_up_idx = upgrades_tweaks_att_idx[tmp_spe_up_idx][j];
				tmp_ref_idx = upgrades_ref_to_idx[client][slot][tmp_up_idx];
				if (tmp_ref_idx != 9999)
				{
					tmp_val = currentupgrades_val[client][slot][tmp_ref_idx] - upgrades_i_val[tmp_up_idx];
				}
				else
				{
					tmp_val = 0.0;
				}
				tmp_ratio = upgrades_ratio[tmp_up_idx];
				if (tmp_ratio > 0.0)
				{
					plus_sign = "+";
				}
				else
				{
					tmp_ratio *= -1.0;
					plus_sign = "-";
				}
				char buf[64];
				Format(buf, sizeof(buf), "%T", upgradesNames[tmp_up_idx], client);
				if (tmp_ratio < 0.99)
				{
					tmp_ratio *= upgrades_tweaks_att_ratio[tmp_spe_up_idx][j];
					Format(desc_str, sizeof(desc_str), "%s\n%\t-%s\n\t\t\t%s%i%%\t(%i%%)", desc_str, buf, plus_sign, RoundFloat(tmp_ratio * 100), RoundFloat(tmp_val * 100));
				}
				else
				{
					tmp_ratio *= upgrades_tweaks_att_ratio[tmp_spe_up_idx][j];
					Format(desc_str, sizeof(desc_str), "%s\n\t-%s\n\t\t\t%s%3i\t(%i)", desc_str, buf, plus_sign, RoundFloat(tmp_ratio), RoundFloat(tmp_val));
				}
			}
			AddMenuItem(menu, "upgrade", desc_str);
		}
	}
	SetMenuTitle(menu, TitleStr);
	SetMenuExitButton(menu, true);
	DisplayMenuAtItem(menu, client, selectidx, MENU_TIME_FOREVER);
}



public int MenuHandler_SpecialUpgradeChoice(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		client_respawn_handled[param1] = 0;
		char fstr[100];
		int got_req = 1;
		int slot = current_slot_used[param1];
		int w_id = current_w_list_id[param1];
		int cat_id = current_w_c_list_id[param1];
		int spTweak = given_upgrd_list[w_id][cat_id][param2];
		for (int i = 0; i < upgrades_tweaks_nb_att[spTweak]; i++)
		{
			int upgrade_choice = upgrades_tweaks_att_idx[spTweak][i];
			int inum = upgrades_ref_to_idx[param1][slot][upgrade_choice];
			if (inum != 9999)
				{
					if (currentupgrades_val[param1][slot][inum] == upgrades_m_val[upgrade_choice])
					{
						PrintToChat(param1, "You already have reached the maximum upgrade for this tweak.");
						got_req = 0;
					}
				}
				else
				{
					if (currentupgrades_number[param1][slot] + upgrades_tweaks_nb_att[spTweak] >= MAX_ATTRIBUTES_ITEM)
					{
						PrintToChat(param1, "You have not enough upgrade category slots for this tweak.");
						got_req = 0;
					}
				}


		}
		if (got_req)
		{
			char clname[255];
			GetClientName(param1, clname, sizeof(clname));
			for (int i = 1; i < MAXPLAYERS + 1; i++)
			{
				if (IsValidClient(i) && !client_no_d_team_upgrade[i])
				{
					PrintToChat(i,"%s : [%s tweak] - %s!",
					clname, upgrades_tweaks[spTweak], current_slot_name[slot]);
				}
			}
			for (int i = 0; i < upgrades_tweaks_nb_att[spTweak]; i++)
			{
				int upgrade_choice = upgrades_tweaks_att_idx[spTweak][i];
				UpgradeItem(param1, upgrade_choice, upgrades_ref_to_idx[param1][slot][upgrade_choice], upgrades_tweaks_att_ratio[spTweak][i]);
			}
			GiveNewUpgradedWeapon_(param1, slot);
			char buf[32];
			Format(buf, sizeof(buf), "%T", current_slot_name[slot], param1);
			Format(fstr, sizeof(fstr), "%.0f$ [%s] - %s", CurrencyOwned[param1], buf, given_upgrd_classnames[w_id][cat_id]);
			Menu_SpecialUpgradeChoice(param1, cat_id, fstr, GetMenuSelectionPosition());
		}
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	return 0;
}


public int MenuHandler_AttributesTweak_action(Handle menu, MenuAction action, int param1, int param2)
{
	if (IsValidClient(param1) && IsPlayerAlive(param1) && !client_respawn_checkpoint[param1])
	{
		int s = current_slot_used[param1];
		if (s >= 0 && s < 4 && param2 < MAX_ATTRIBUTES_ITEM)
		{
			if (param2 >= 0)
			{
				int u = currentupgrades_idx[param1][s][param2];
				if (u != 20000)
				{
					if (upgrades_costs[u] < -0.0001)
					{
						int nb_time_upgraded = RoundFloat((upgrades_i_val[u] - currentupgrades_val[param1][s][param2]) / upgrades_ratio[u]);
						int up_cost = upgrades_costs[u] * nb_time_upgraded * 3;
						if (CurrencyOwned[param1] >= up_cost)
						{
							remove_attribute(param1, param2);
							CurrencyOwned[param1] -= up_cost;
							client_spent_money[param1][s] += up_cost;
						}
						else
						{
							char buffer[128];
							Format(buffer, sizeof(buffer), "%T", "You have not enough money!!", param1);
							PrintToChat(param1, buffer);
						}
					}
					else
					{
						PrintToChat(param1,"Attribute is Unremovable");
					}
					Menu_TweakUpgrades_slot(param1, s, GetMenuSelectionPosition());
				}
			}
		}
	}
	return 0;
}



//menubuy 1-chose the item attribute to tweak
public int MenuHandler_AttributesTweak(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		if (IsValidClient(param1) && IsPlayerAlive(param1) && !client_respawn_checkpoint[param1])
		{
			Menu_TweakUpgrades_slot(param1, param2, 0);
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (IsValidClient(param1) && param2 == MenuCancel_ExitBack)
		{
			OpenBuyMenu(param1);
		}
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	return 0;
}


void Menu_BuyNewWeapon(int param1)
{
	if (IsValidClient(param1) && IsPlayerAlive(param1))
	{
		DisplayMenu(BuyNWmenu, param1, MENU_TIME_FOREVER);
	}
}



//menubuy 2- choose the category of upgrades
void Menu_ChooseCategory(int client, char TitleStr[64])
{
//	PrintToChat(client, "Entering menu_chscat");
	int i;
	int w_id;

	Handle menu = CreateMenu(MenuHandler_Choosecat);
	int slot = current_slot_used[client];
	if (slot != 4)
	{
		w_id = currentitem_catidx[client][slot];
	}
	else
	{
		w_id = current_class[client] - 1;
	}
	if (w_id >= 0)
	{
		current_w_list_id[client] = w_id;
		char buf[64];
		for (i = 0; i < given_upgrd_list_nb[w_id]; i++)
		{
			Format(buf, sizeof(buf), "%T", given_upgrd_classnames[w_id][i], client);
			AddMenuItem(menu, "upgrade", buf);
		}
	}
	SetMenuTitle(menu, TitleStr);
	SetMenuExitButton(menu, true);
	SetMenuExitBackButton(menu, true);
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
	}
}

//menubuy 3- choose the upgrade
public Action Menu_UpgradeChoice(int client, int cat_choice, char TitleStr[100])
{
	int i;

	Handle menu = CreateMenu(MenuHandler_UpgradeChoice);
	if (cat_choice != -1)
	{
		int w_id = current_w_list_id[client];

		char desc_str[255];
		int tmp_up_idx;
		int tmp_ref_idx;
		int up_cost;
		float tmp_val;
		float tmp_ratio;
		int slot;
		char plus_sign[1];
		current_w_c_list_id[client] = cat_choice;
		slot = current_slot_used[client];
		for (i = 0; (tmp_up_idx = given_upgrd_list[w_id][cat_choice][i]); i++)
		{
			up_cost = upgrades_costs[tmp_up_idx] / 2;
			if (slot == 1)
			{
				up_cost = RoundFloat((up_cost * 1.0) * 0.75); // -25% cost reduction on secondaries
			}
			tmp_ref_idx = upgrades_ref_to_idx[client][slot][tmp_up_idx];
			if (tmp_ref_idx != 9999)
			{
			//	PrintToChat(client, "menuexisting att:%d", tmp_ref_idx)
				tmp_val = currentupgrades_val[client][slot][tmp_ref_idx] - upgrades_i_val[tmp_up_idx];
			}
			else
			{
				tmp_val = 0.0;
			}
			tmp_ratio = upgrades_ratio[tmp_up_idx];
			if (tmp_val && tmp_ratio)
			{
				up_cost += RoundFloat(up_cost * (tmp_val / tmp_ratio) * upgrades_costs_inc_ratio[tmp_up_idx]);
				if (up_cost < 0.0)
				{
					up_cost *= -1;
					if (up_cost < (upgrades_costs[tmp_up_idx] / 2))
					{
						up_cost = upgrades_costs[tmp_up_idx] / 2;
					}
				}
			}
			if (tmp_ratio > 0.0)
			{
				plus_sign = "+";
			}
			else
			{
				tmp_ratio *= -1.0;
				plus_sign = "-";
			}
			char buf[64];
			Format(buf, sizeof(buf), "%T", upgradesNames[tmp_up_idx], client);
			if (tmp_ratio < 0.99)
			{
				Format(desc_str, sizeof(desc_str), "%5d$ -%s\n\t\t\t%s%i%%\t(%i%%)", up_cost, buf, plus_sign, RoundFloat(tmp_ratio * 100), RoundFloat(tmp_val * 100));
			}
			else
			{
				Format(desc_str, sizeof(desc_str), "%5d$ -%s\n\t\t\t%s%3i\t(%i)", up_cost, buf, plus_sign, RoundFloat(tmp_ratio), RoundFloat(tmp_val));
			}

			AddMenuItem(menu, "upgrade", desc_str);
		}
	}
	SetMenuTitle(menu, TitleStr);
	SetMenuExitButton(menu, true);

	DisplayMenu(menu, client, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//menubuy 1-chose the item category of upgrade
public Action Menu_BuyUpgrade(int client, int args)
{
	if (IsValidClient(client) && IsPlayerAlive(client) && !client_respawn_checkpoint[client])
	{
		OpenBuyMenu(client);
	}
	return Plugin_Handled;
}

void OpenBuyMenu(int client)
{
	char buffer[64];
	menuBuy = CreateMenu(MenuHandler_BuyUpgrade);
	SetMenuTitle(menuBuy, "Uber Upgrades - /buy or +reload & +showscores");
	AddMenuItem(menuBuy, "upgrade_player", "Body upgrades");

	AddMenuItem(menuBuy, "upgrade_primary", "Primary weapon upgrades");

	AddMenuItem(menuBuy, "upgrade_secondary", "Secondary weapon upgrades");

	AddMenuItem(menuBuy, "upgrade_melee", "Melee weapon upgrades");

	//Format(buffer, sizeof(buffer), "%T", "Display Upgrades/Remove downgrades", client);
	AddMenuItem(menuBuy, "upgrade_dispcurrups", "Remove downgrades & Display Upgrades");
	if (!BuyNWmenu_enabled)
	{
		Format(buffer, sizeof(buffer), "%T", "Buy another weapon", client);
		AddMenuItem(menuBuy, "upgrade_buyoneweap", buffer);
		if (currentitem_level[client][3] == 242)
		{
			Format(buffer, sizeof(buffer), "%T", "Upgrade bought weapon", client);
			AddMenuItem(menuBuy, "upgrade_buyoneweap", buffer);
		}
	}
	SetMenuExitButton(menuBuy, true);
	DisplayMenu(menuBuy, client, MENU_TIME_FOREVER);
}


//menubuy 3-Handler
public int MenuHandler_BuyNewWeapon(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		int iCash = GetEntProp(param1, Prop_Send, "m_nCurrency", iCash);
		if (iCash > 200)
		{
			if (currentitem_idx[param1][3])
			{
				PrintToChat(param1, "You already have");
			}
			ResetClientUpgrade_slot(param1, 3);
			currentitem_idx[param1][3] = newweaponidx[param2];
			currentitem_classname[param1][3] = newweaponcn[param2];
			SetEntProp(param1, Prop_Send, "m_nCurrency", iCash - 200);
			client_spent_money[param1][3] = 200;
			//PrintToChat(param1, "You will have it next spawn.")
			GiveNewWeapon(param1, 3);
		}
		else
		{
			char buffer[64];
			Format(buffer, sizeof(buffer), "%T", "You have not enough money!!", param1);
			PrintToChat(param1, buffer);
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (IsValidClient(param1) && param2 == MenuCancel_ExitBack)
		{
			OpenBuyMenu(param1);
		}
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	return 0;
}


public int MenuHandler_AccessDenied(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		PrintToChat(param1, "This feature is donators/VIPs only");
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	return 0;
}

//menubuy 3-Handler
public int MenuHandler_UpgradeChoice(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		client_respawn_handled[param1] = 0;
		int slot = current_slot_used[param1];
		int w_id = current_w_list_id[param1];
		int cat_id = current_w_c_list_id[param1];
		int upgrade_choice = given_upgrd_list[w_id][cat_id][param2];
		int inum = upgrades_ref_to_idx[param1][slot][upgrade_choice];

		if (is_client_got_req(param1, upgrade_choice, slot, inum))
		{
			UpgradeItem(param1, upgrade_choice, inum, 1.0);
			GiveNewUpgradedWeapon_(param1, slot);
		}
		char fstr2[100];
		char fstr[40];
		char fstr3[20];
		if (slot != 4)
		{
			Format(fstr, sizeof(fstr), "%t", given_upgrd_classnames[w_id][cat_id], param1);
			Format(fstr3, sizeof(fstr3), "%T", current_slot_name[slot], param1);
			Format(fstr2, sizeof(fstr2), "%.0f$ [%s] - %s", CurrencyOwned[param1], fstr3, fstr);
		}
		else
		{
			Format(fstr, sizeof(fstr), "%t", given_upgrd_classnames[current_class[param1] - 1][cat_id], param1);
			Format(fstr3, sizeof(fstr3), "%T", "Body upgrade", param1);
			Format(fstr2, sizeof(fstr2), "%.0f$ [%s] - %s", CurrencyOwned[param1], fstr3, fstr);
		}
		SetMenuTitle(menu, fstr2);
		char desc_str[255];
		int tmp_up_idx;
		int tmp_ref_idx;
		int up_cost;
		float tmp_val;
		float tmp_ratio;
		char plus_sign[1];

		tmp_up_idx = given_upgrd_list[w_id][cat_id][param2];
		up_cost = upgrades_costs[tmp_up_idx] / 2;
		if (slot == 1)
		{
			up_cost = RoundFloat((up_cost * 1.0) * 0.75); // -25% cost reduction on secondaries
		}
		tmp_ref_idx = upgrades_ref_to_idx[param1][slot][tmp_up_idx];
		if (tmp_ref_idx != 9999)
		{
			tmp_val = currentupgrades_val[param1][slot][tmp_ref_idx] - upgrades_i_val[tmp_up_idx];
		}
		else
		{
			tmp_val = 0.0;
		}
		tmp_ratio = upgrades_ratio[tmp_up_idx];
		if (tmp_val && tmp_ratio)
		{
			up_cost += RoundFloat(up_cost * (tmp_val / tmp_ratio) * upgrades_costs_inc_ratio[tmp_up_idx]);
			if (up_cost < 0.0)
			{
				up_cost *= -1;
				if (up_cost < (upgrades_costs[tmp_up_idx] / 2))
				{
					up_cost = upgrades_costs[tmp_up_idx] / 2;
				}
			}
		}
		if (tmp_ratio > 0.0)
		{
			plus_sign = "+";
		}
		else
		{
			tmp_ratio *= -1.0;
			plus_sign = "-";
		}
		char buf[64];
		Format(buf, sizeof(buf), "%T", upgradesNames[tmp_up_idx], param1);
		if (tmp_ratio < 0.99)
		{
			Format(desc_str, sizeof(desc_str), "%5d$ -%s\n\t\t\t%s%i%%\t(%i%%)", up_cost, buf, plus_sign, RoundFloat(tmp_ratio * 100), RoundFloat(tmp_val * 100));
		}
		else
		{
			Format(desc_str, sizeof(desc_str), "%5d$ -%s\n\t\t\t%s%3i\t(%i)", up_cost, buf, plus_sign, RoundFloat(tmp_ratio), RoundFloat(tmp_val));
		}


		InsertMenuItem(menu, param2, "upgrade", desc_str);
		RemoveMenuItem(menu, param2 + 1);
		DisplayMenuAtItem(menu, param1, GetMenuSelectionPosition(), MENU_TIME_FOREVER);

	}
	return 0;
}


//menubuy 2- Handler
public int MenuHandler_BodyUpgrades(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char fstr2[100];
		char fstr[40];
		char fstr3[20];

		Format(fstr, sizeof(fstr), "%T", given_upgrd_classnames[current_class[param1] - 1][param2], param1);
		Format(fstr3, sizeof(fstr3), "%T", "Body upgrade", param1);
		Format(fstr2, sizeof(fstr2), "%.0f$ [%s] - %s", CurrencyOwned[param1], fstr3, fstr);

		Menu_UpgradeChoice(param1, param2, fstr2);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	return 0;
}

public int MenuHandler_Choosecat(Handle menu, MenuAction action, int param1, int param2)
{
//	PrintToChatAll("exitbutton  %d", param2)
	if (action == MenuAction_Select)
	{
		char fstr2[100];
		char fstr[40];
		char fstr3[20];
		int slot = current_slot_used[param1];
		int cat_id = currentitem_catidx[param1][slot];
		if (slot != 4)
		{
			Format(fstr, sizeof(fstr), "%T", given_upgrd_classnames[cat_id][param2], param1);
			Format(fstr3, sizeof(fstr3), "%T", current_slot_name[slot], param1);
			Format(fstr2, sizeof(fstr2), "%.0f$ [%s] - %s", CurrencyOwned[param1],fstr3,fstr);
			Menu_UpgradeChoice(param1, param2, fstr2);
			if (param2 == given_upgrd_classnames_tweak_idx[cat_id])
			{
				Menu_SpecialUpgradeChoice(param1, param2, fstr2,0);
			}
			else
			{
				Menu_UpgradeChoice(param1, param2, fstr2);
			}
		}
		else
		{
			Format(fstr, sizeof(fstr), "%T", given_upgrd_classnames[cat_id][param2], param1);
			Format(fstr3, sizeof(fstr3), "%T", "Body upgrade", param1);
			Format(fstr2, sizeof(fstr2), "%.0f$ [%s] - %s", CurrencyOwned[param1], fstr3, fstr);
			if (param2 == given_upgrd_classnames_tweak_idx[cat_id])
			{
				Menu_SpecialUpgradeChoice(param1, param2, fstr2,0);
			}
			else
			{
				Menu_UpgradeChoice(param1, param2, fstr2);
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (IsValidClient(param1) && param2 == MenuCancel_ExitBack)
		{
			OpenBuyMenu(param1);
		}
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	return 0;
}


public int MenuHandler_BuyUpgrade(Handle menu, MenuAction action, int param1, int param2)
{
	/* If an option was selected, tell the client about the item. */
	if (action == MenuAction_Select)
	{
		if (param2 == 0)
		{
			char fstr[30];
			char fstr2[64];
			current_slot_used[param1] = 4;
			client_iCash[param1] = GetEntProp(param1, Prop_Send, "m_nCurrency", client_iCash[param1]);
			Format(fstr, sizeof(fstr), "%T", "Body upgrade", param1);
			Format(fstr2, sizeof(fstr2), "%.0f$ [ - %s - ]", CurrencyOwned[param1], fstr);
			Menu_ChooseCategory(param1, fstr2);
		}
		else if (param2 == 4)
		{
			Menu_TweakUpgrades(param1);
		}
		else if (param2 == 5)
		{
			Menu_BuyNewWeapon(param1);
		}
		else if (param2 == 6)
		{
			char fstr[30];
			char fstr2[64];
			current_slot_used[param1] = 3;

			Format(fstr, sizeof(fstr), "%T", "Body upgrade", param1);
			client_iCash[param1] = GetEntProp(param1, Prop_Send, "m_nCurrency", client_iCash[param1]);
			Format(fstr2, sizeof(fstr2), "%.0f$ [ - Upgrade %s - ]", CurrencyOwned[param1], fstr);
			Menu_ChooseCategory(param1, fstr2);
		}
		else
		{
			char fstr[30];
			char fstr2[64];
			param2 -= 1;
			current_slot_used[param1] = param2;
			Format(fstr, sizeof(fstr), "%T", current_slot_name[param2], param1);
			client_iCash[param1] = GetEntProp(param1, Prop_Send, "m_nCurrency", client_iCash[param1]);
			Format(fstr2, sizeof(fstr2), "%.0f$ [ - Upgrade %s - ]", CurrencyOwned[param1], fstr);
			Menu_ChooseCategory(param1, fstr2);

		}
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	return 0;
}

stock int TF2_GetPlayerMaxHealth(int client)
{
	return GetEntProp(GetPlayerResourceEntity(), Prop_Send, "m_iMaxHealth", _, client);
}
public Action Timer_GiveHealth(Handle timer)//give health every 0.333 seconds
{
	for(int i = 0; i < MAXPLAYERS + 1; i++)
	{
		if (IsValidClient(i))
		{
			Address RegenActive = TF2Attrib_GetByName(i, "disguise on backstab");
			if(RegenActive != Address_Null)
			{
				float RegenPerSecond = TF2Attrib_GetValue(RegenActive);
				float RegenPerTick = RegenPerSecond/3;
				int clientHealth = GetClientHealth(i);
				int clientMaxHealth = TF2_GetPlayerMaxHealth(i);
				if(clientHealth < clientMaxHealth)
				{
					if(float(clientHealth) + RegenPerTick < clientMaxHealth)
					{
						SetEntityHealth(i, clientHealth+RoundToNearest(RegenPerTick));
					}
					else
					{
						SetEntityHealth(i, clientMaxHealth);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
public void OnClientPostAdminCheck(int client)
{
	if(IsValidClient(client))
	{
		CurrencyOwned[client] = RealStartMoney;
	}
} 
void RespawnEffect(int client)
{
	current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
	TF2Attrib_SetByName(client,"afterburn immunity", 1.0);//fix afterburn
	TF2Attrib_SetByName(client,"weapon burn time increased", 15.0);//fix afterburn
	if(current_class[client] == view_as<int>(TFClass_Pyro))
	{
		TF2Attrib_SetByName(client,"airblast_pushback_no_stun", 1.0);//Make airblast less annoying...
	}
}
void ChangeClassEffect(int client)
{
	current_class[client] = view_as<int>(TF2_GetPlayerClass(client));
	TF2_RemoveAllWeapons(client);
	if(IsPlayerAlive(client))
	{
		TF2_RespawnPlayer(client);
	}
	TF2Attrib_RemoveAll(client);
}