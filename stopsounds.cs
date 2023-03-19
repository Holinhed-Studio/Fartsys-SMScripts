#include <sourcemod>
#include <sdktools>
#include <freak_fortress_2>
#include <tf2attributes>

#pragma tabsize 0

bool Locked1[MAXPLAYERS+1];
bool Locked2[MAXPLAYERS+1];
bool Locked3[MAXPLAYERS+1];
bool CanWindDown[MAXPLAYERS+1];
bool ChangeAngles[MAXPLAYERS+1];

bool stopsound=false;

//Stock sounds
#define SOUND_GUNFIRE	"combat_arms/new_fire_fix.wav"
#define SOUND_GUNSPIN	"mvm/giant_heavy/giant_heavy_gunspin.wav"
#define SOUND_STOCKWINDUP	"weapons/minigun_wind_up.wav"
#define SOUND_WINDDOWN	"combat_arms/rollingdown.wav"

//Custom sounds
#define SOUND_GUNFIRE_1	"combat_arms/new_fire_fix.wav"
#define SOUND_GUNSPIN_1	"mvm/giant_heavy/giant_heavy_gunspin.wav"
#define SOUND_WINDUP	"combat_arms/fix_rollingup_v4.wav"
#define SOUND_WINDDOWN_1 "combat_arms/rollingdown.wav"

public OnPluginStart()
{
	RegAdminCmd("sm_stopsounds", Command_StopSounds, ADMFLAG_CHEATS, "Stop a sound!");
	//HookUserMessage(GetUserMessageId("PlayerTauntSoundLoopStart"), HookTauntMessage, true);
	//AddNormalSoundHook(HookSound);
}

public OnMapStart()
{
	PrecacheSound(SOUND_GUNFIRE_1);
	PrecacheSound(SOUND_GUNSPIN_1);
	PrecacheSound(SOUND_STOCKWINDUP);
	PrecacheSound(SOUND_WINDDOWN_1);
	PrecacheSound(SOUND_WINDUP);
	PrecacheSound(SOUND_WINDDOWN);
	PrecacheSound(SOUND_GUNFIRE);
	PrecacheSound(SOUND_GUNSPIN);
}

public Action:Command_StopSounds(client, args)
{
	stopsound=!stopsound;
	ReplyToCommand(client, "Toggled!");
	int value=1;
	if(stopsound)
	{
		int index=1;
		while ((index = FindEntityByClassname(index, "tf_weapon_minigun")) != -1)
		{
			TF2Attrib_SetByName(index, "minigun no spin sounds", view_as<float>(value));
		}
	}
	return Plugin_Handled;
}

/*
public Action HookTauntMessage(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	int byte = msg.ReadByte(); //The client index sending the sound
	char string[PLATFORM_MAX_PATH]; //The sound
	msg.ReadString(string, PLATFORM_MAX_PATH);
	
	if(stopsound)
	{
		PrintToServer("%i %s", byte, string);
		
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
*/

public Action TF2_CalcIsAttackCritical(int client, int weapon, char[] weaponname, bool& result)
{
	if(!stopsound)
	{
		return Plugin_Continue;
	}
	if(GetPlayerWeaponSlot(client, 2) == weapon)
		return Plugin_Continue;
	
	ChangeAngles[client]=true;
	return Plugin_Continue;
}

public Action OnPlayerRunCmd(int iClient, int& iButtons, int& iImpulse, float[3] fVel, float[3] fAng, int& iWeapon) 
{
	if(!stopsound)
	{
		return Plugin_Continue;
	}
	if (IsValidClient(iClient)) 
	{
		int weapon = GetPlayerWeaponSlot(iClient, 0);
		char classname[64];
		GetEntityClassname(weapon, classname, sizeof(classname));
		if(IsValidEntity(weapon) && StrEqual(classname, "tf_weapon_minigun", false))
		{
			int iWeaponState = GetEntProp(weapon, Prop_Send, "m_iWeaponState");
			if (iWeaponState == 1 && !Locked1[iClient])
			{
				new Float:position[3];
				GetEntPropVector(iClient, Prop_Data, "m_vecOrigin", position);
				EmitSoundToAll(SOUND_WINDUP, iClient, _, _, _, _, _, iClient, position);
				PrintToChatAll("WeaponState = Windup");
				Locked1[iClient] = true;
				Locked2[iClient] = false;
				Locked3[iClient] = false;
				CanWindDown[iClient] = true;
				
				StopSound(iClient, SNDCHAN_AUTO, SOUND_STOCKWINDUP),
				StopSound(iClient, SNDCHAN_AUTO, SOUND_GUNSPIN);
				StopSound(iClient, SNDCHAN_AUTO, SOUND_GUNFIRE);			
			}
			else if (iWeaponState == 2 && !Locked2[iClient])
			{
				EmitSoundToAll(SOUND_GUNFIRE, iClient);
				PrintToChatAll("WeaponState = Firing");
				
				Locked2[iClient] = true;
				Locked1[iClient] = true;
				Locked3[iClient] = false;
				CanWindDown[iClient] = true;
				
				StopSound(iClient, SNDCHAN_AUTO, SOUND_GUNSPIN);
				StopSound(iClient, SNDCHAN_AUTO, SOUND_STOCKWINDUP);
				for(int i=0; i<7; i++)
				{
					for(int s=1; s<MaxClients; s++)
					{
						StopSound(iClient, s, "weapons\\minigun_shoot.wav");
					}
					if(GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon")!=0)
					{
						StopSound(GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon"), i, "weapons\\minigun_shoot.wav");
					}
				}
			}
			else if (iWeaponState == 3 && !Locked3[iClient])
			{
				EmitSoundToAll(SOUND_GUNSPIN, iClient);
				PrintToChatAll("WeaponState = Spun Up");
				
				Locked3[iClient] = true;
				Locked1[iClient] = true;
				Locked2[iClient] = false;
				CanWindDown[iClient] = true;
				
				StopSound(iClient, SNDCHAN_AUTO, SOUND_GUNFIRE);
				StopSound(iClient, SNDCHAN_AUTO, SOUND_STOCKWINDUP);
			}
			else if (iWeaponState == 0)
			{
				if (CanWindDown[iClient])
				{
					PrintToChatAll("WeaponState = WindDown");
					EmitSoundToAll(SOUND_WINDDOWN, iClient);
					CanWindDown[iClient] = false;
				}
				
				StopSound(iClient, SNDCHAN_AUTO, SOUND_GUNSPIN);
				StopSound(iClient, SNDCHAN_AUTO, SOUND_GUNFIRE);
				
				Locked1[iClient] = false;
				Locked2[iClient] = false;
				Locked3[iClient] = false;
			}
		}
		if(ChangeAngles[iClient])
        {
            float fShake[3];
            int currtime=GetTime();
            if(currtime>>1&1)
            {
                fShake[0] = GetRandomFloat(0.0, -7.0);
            }
            else
            {
                fShake[0] = 0.0
            }
            fShake[2] = 0.0;
            //float fNewAngles[3];
            //GetClientEyeAngles(client, fNewAngles);
            fAng[0]+=fShake[0];
            fAng[1]+=fShake[1];
            //fNewAngles[2]+=fShake[2];
            SetEntPropVector(iClient, Prop_Send, "m_vecPunchAngle", fShake);
            TeleportEntity(iClient, NULL_VECTOR, fAng, NULL_VECTOR);
            ChangeAngles[iClient]=false;
            return Plugin_Changed;
        }
		if(ChangeAngles[iClient])
        {
            float fShake[3];
        //  int currtime=GetTime();
            //if(currtime>>1&1)
            //{
            fShake[0] =-5.0
            //}
            //else
            //{
            //  fShake[0] = 0.0
            //}
            fShake[2] = 0.0;
            //float fNewAngles[3];
            //GetClientEyeAngles(client, fNewAngles);
            fAng[0]+=fShake[0];
            fAng[1]+=fShake[1];
            //fNewAngles[2]+=fShake[2];
            SetEntPropVector(iClient, Prop_Send, "m_vecPunchAngle", fShake);
            TeleportEntity(iClient, NULL_VECTOR, fAng, NULL_VECTOR);
            ChangeAngles[iClient]=false;
            return Plugin_Changed;
        }
	}
	return Plugin_Continue;
}

bool IsValidClient(client)
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	return IsClientInGame(client);
}


/*
#if SOURCEMOD_V_MAJOR==1 && SOURCEMOD_V_MINOR<=7
public Action:HookSound(clients[64], &numClients, String:sound[PLATFORM_MAX_PATH], &client, &channel, &Float:volume, &level, &pitch, &flags)
#else
public Action:HookSound(clients[64], &numClients, String:sound[PLATFORM_MAX_PATH], &client, &channel, &Float:volume, &level, &pitch, &flags, String:soundEntry[PLATFORM_MAX_PATH], &seed)
#endif
{
	if(stopsound)
	{
		PrintToChatAll("Sound: %s", sound);
		EmitSound(clients, numClients, "vo/engineer_ThanksForTheHeal02.mp3", client, channel, level, flags, volume, pitch);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}
*/