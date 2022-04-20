// base grab code taken from http://forums.alliedmods.net/showthread.php?t=157075 and https://forums.alliedmods.net/showthread.php?p=1946774

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <morecolors>

#define DRAGONBORN "shout/dragonborn.wav"      // grab
#define FUSRODAH "shout/fusrodah.wav"        // throw

#define THROW_FORCE 10000.0
#define GRAB_DISTANCE 250.0

#define PLUGIN_NAME "Dovah Shout!"
#define PLUGIN_AUTHOR   "DovahkiinYT / TheXeon"
#define PLUGIN_VERSION  "2.0.2"
#define PLUGIN_DESCRIP  "Allows Dovah to Grab Stuff"
#define PLUGIN_CONTACT  "http://steamcommunity.com/groups/FireHostv2"

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIP,
	version = PLUGIN_VERSION,
	url = PLUGIN_CONTACT
}

int g_grabbed[MAXPLAYERS+10];              // track client's grabbed object
float gDistance[MAXPLAYERS+10];        // track distance of grabbed object

//////////////////////////////////////////////////////////////////////
/////////////                    Setup                   /////////////
//////////////////////////////////////////////////////////////////////

public void OnPluginStart()
{	
	CreateConVar("tf_dovahgrab_version", PLUGIN_VERSION, PLUGIN_NAME, FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_SPONLY);
	
	PrecacheSound(FUSRODAH, true);
	PrecacheSound(DRAGONBORN, true);
	
	AddFileToDownloadsTable("sound/shout/fusrodah.wav");
	AddFileToDownloadsTable("sound/shout/dragonborn.wav");
	
	RegConsoleCmd("sm_SetTarget", Command_Dragonborn, "Attempt to be the Dragonborn");
	RegConsoleCmd("sm_FusRoDah", Command_FusRoDah, "The Dragonborn's Words");
	RegConsoleCmd("sm_Disarm", Command_Disarm, "Disarm the pursuing");
	
	HookEvent("player_death", OnPlayerSpawn);
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("player_team", OnPlayerSpawn);
	//Some code was here, but it was marked as unnecessary and removed.
}


stock bool:IsTargetInSightRange(client, target, Float:angle=90.0, Float:distance=0.0, bool:heightcheck=true, bool:negativeangle=false)
{
	if(angle > 360.0 || angle < 0.0)
		ThrowError("Angle Max : 360 & Min : 0. %d isn't proper angle.", angle);
	if(!IsValidClient(client))
		ThrowError("Client is not Alive.");
	if(!IsValidClient(target))
		ThrowError("Target is not Alive.");
		
	decl Float:clientpos[3], Float:targetpos[3], Float:anglevector[3], Float:targetvector[3], Float:resultangle, Float:resultdistance;
	
	GetClientEyeAngles(client, anglevector);
	anglevector[0] = anglevector[2] = 0.0;
	GetAngleVectors(anglevector, anglevector, NULL_VECTOR, NULL_VECTOR);
	NormalizeVector(anglevector, anglevector);
	if(negativeangle)
		NegateVector(anglevector);

	GetClientAbsOrigin(client, clientpos);
	GetClientAbsOrigin(target, targetpos);
	if(heightcheck && distance > 0)
		resultdistance = GetVectorDistance(clientpos, targetpos);
	clientpos[2] = targetpos[2] = 0.0;
	MakeVectorFromPoints(clientpos, targetpos, targetvector);
	NormalizeVector(targetvector, targetvector);
	
	resultangle = RadToDeg(ArcCosine(GetVectorDotProduct(targetvector, anglevector)));
	
	if(resultangle <= angle/2)	
	{
		if(distance > 0)
		{
			if(!heightcheck)
				resultdistance = GetVectorDistance(clientpos, targetpos);
			if(distance >= resultdistance)
				return true;
			else
				return false;
		}
		else
			return true;
	}
	else
		return false;
}
public void OnMapStart()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		g_grabbed[client] = INVALID_ENT_REFERENCE;
		PrecacheSound(FUSRODAH, true);
		PrecacheSound(DRAGONBORN, true);
		AddFileToDownloadsTable("sound/shout/fusrodah.wav");
		AddFileToDownloadsTable("sound/shout/dragonborn.wav");
	}
}

public void OnClientPutInServer(int client)
{
	g_grabbed[client] = INVALID_ENT_REFERENCE;
}

//////////////////////////////////////////////////////////////////////
/////////////                  Commands                  /////////////
//////////////////////////////////////////////////////////////////////

public Action Command_Dragonborn(int client, int target)
{
	char player_authid[32];
	GetClientAuthId(client, AuthId_Steam2, player_authid, sizeof(player_authid));
	if IsTargetInSightRange(client, target) *then
	{
		SDKHook(target, SDKHook_PreThink, OnPreThink);
		GrabObject(target);
		int grabbed = EntRefToEntIndex(g_grabbed[client]);
		if(grabbed != INVALID_ENT_REFERENCE)
		{
			CPrintToChat(client, "{orange}Arngeir: {green}You now have an entity in your sights! Now, type !FusRoDah to use the power of the Voice.");
			EmitSoundToClient(client, DRAGONBORN);
			EmitSoundToClient(client, DRAGONBORN);
			return Plugin_Handled;
		}
		else
		{
			CPrintToChat(client, "{orange}Arngeir: {red}My dear Dragonborn, you have done something wrong! Were you not aimed at a valid target?");
			return Plugin_Handled;
		}
	}
	else
	{
		CPrintToChat(client, "{orange}Arngeir: {red}You don't understand the power of the Voice.");
		return Plugin_Handled;
	}
}
	
	
public Action Command_FusRoDah(int client, int args)
{
	if (!IsValidClient(client)) 
	{
		return Plugin_Handled;
	}	
	char player_authid[32];
	GetClientAuthId(client, AuthId_Steam2, player_authid, sizeof(player_authid));
	if (!StrEqual(player_authid, "STEAM_0:1:69132908", false))
	{
		CPrintToChat(client, "{orange}Arngeir: {red}Only the true Dragonborn can speak these words!");
		return Plugin_Handled;
	}
	if(IsValidClient(client))
	{
		int grabbed = EntRefToEntIndex(g_grabbed[client]);
		if(grabbed != INVALID_ENT_REFERENCE)
		{
			ThrowObject(client, grabbed, true);
			EmitSoundToAll(FUSRODAH);
			CPrintToChatAll("{fullred}Dovahkiin: {aqua}FUS RO DAH!!!!");
		}
		else
		{
			CPrintToChat(client, "{orange}Arngeir: {red}I'm sorry Dragonborn, but you must first prepare this shout. Aim at something, and then try !SetTarget.");
			return Plugin_Handled;
		}
	}
	return Plugin_Handled;
}
public Action Command_Disarm(int client, int args)
{
	if (!IsValidClient(client))
	{
		return Plugin_Handled;
	}
	char player_authid[32];
	GetClientAuthId(client, AuthId_Steam2, player_authid, sizeof(player_authid));
	if (!StrEqual(player_authid, "STEAM_0:1:69132908", false))
	{
		CPrintToChat(client, "{orange}Arngeir: {red}I'm sorry, but only the true Dragonborn may release an entity.");
		return Plugin_Handled;
	}
	if(IsValidClient(client))
	{
		int grabbed = EntRefToEntIndex(g_grabbed[client]);
		if(grabbed != INVALID_ENT_REFERENCE)
		{
			ThrowObject(client, grabbed, false);
			CPrintToChat(client, "{orange}Arngeir: {green}You have stopped pursuing your target! Use !SetTarget to choose a new target.");
			return Plugin_Handled;
		}	
	}
	return Plugin_Handled;
}
void GrabObject(int client)
{
	int grabbed = TraceToObject(client);		// -1 for no collision, 0 for world

	if (grabbed > 0)
	{
		if(grabbed > MaxClients)
		{
			char classname[13];
			GetEntityClassname(grabbed, classname, 13);

			if(StrEqual(classname, "prop_physics"))
			{
				int grabber = GetEntPropEnt(grabbed, Prop_Data, "m_hPhysicsAttacker");
				if(grabber > 0 && grabber <= MaxClients && IsClientInGame(grabber))
				{
					return;															// another client is grabbing this object
				}
				SetEntPropEnt(grabbed, Prop_Data, "m_hPhysicsAttacker", client);
				AcceptEntityInput(grabbed, "EnableMotion");
			}
		
			SetEntityMoveType(grabbed, MOVETYPE_VPHYSICS);
		}
		else
		{
			
			SetEntityMoveType(grabbed, MOVETYPE_WALK);

			PrintHintText(client,"Compelling %N",grabbed);
			PrintHintText(grabbed,"%N is about to FUS RO DAH you!",client);
		}

		if(GetClientButtons(client) & IN_ATTACK2)				// Store and maintain distance
		{
			float VecPos_grabbed[3], VecPos_client[3];
			GetEntPropVector(grabbed, Prop_Send, "m_vecOrigin", VecPos_grabbed);
			GetClientEyePosition(client, VecPos_client);
			gDistance[client] = GetVectorDistance(VecPos_grabbed, VecPos_client);
		}
		else
		{
			gDistance[client] = GRAB_DISTANCE;				// Use prefab distance
		}

		float fVelocity[3] =  { 0.0, 0.0, 0.0 };

		TeleportEntity(grabbed, NULL_VECTOR, NULL_VECTOR, fVelocity);

		g_grabbed[client] = EntIndexToEntRef(grabbed);

		
	}
}

void ThrowObject(int client, int grabbed, bool fusrodah)
{
	if(fusrodah)
	{
		float vecView[3], vecFwd[3], vecPos[3], vecVel[3];

		GetClientEyeAngles(client, vecView);
		GetAngleVectors(vecView, vecFwd, NULL_VECTOR, NULL_VECTOR);
		GetClientEyePosition(client, vecPos);

		vecPos[0]+=vecFwd[0]*THROW_FORCE;
		vecPos[1]+=vecFwd[1]*THROW_FORCE;
		vecPos[2]+=vecFwd[2]*THROW_FORCE;

		GetEntPropVector(grabbed, Prop_Send, "m_vecOrigin", vecFwd);

		SubtractVectors(vecPos, vecFwd, vecVel);
		ScaleVector(vecVel, 10.0);

		TeleportEntity(grabbed, NULL_VECTOR, NULL_VECTOR, vecVel);
	}

	

	g_grabbed[client] = INVALID_ENT_REFERENCE;

	if(grabbed > MaxClients)
	{
		char classname[13];
		GetEntityClassname(grabbed, classname, 13);
		if(StrEqual(classname, "prop_physics"))
		{
			SetEntPropEnt(grabbed, Prop_Data, "m_hPhysicsAttacker", 0);
		}
	}
}

//////////////////////////////////////////////////////////////////////
/////////////                  Prethink                  /////////////
//////////////////////////////////////////////////////////////////////

public void OnPreThink(int client)
{
	int grabbed = EntRefToEntIndex(g_grabbed[client]);
	if (grabbed != INVALID_ENT_REFERENCE)
	{
		float vecView[3], vecFwd[3], vecPos[3], vecVel[3];

		GetClientEyeAngles(client, vecView);
		GetAngleVectors(vecView, vecFwd, NULL_VECTOR, NULL_VECTOR);
		GetClientEyePosition(client, vecPos);

		vecPos[0]+=vecFwd[0]*gDistance[client];
		vecPos[1]+=vecFwd[1]*gDistance[client];
		vecPos[2]+=vecFwd[2]*gDistance[client];

		GetEntPropVector(grabbed, Prop_Send, "m_vecOrigin", vecFwd);

		SubtractVectors(vecPos, vecFwd, vecVel);
		ScaleVector(vecVel, 10.0);

		TeleportEntity(grabbed, NULL_VECTOR, NULL_VECTOR, vecVel);
	}
}

//////////////////////////////////////////////////////////////////////
/////////////                    Events                  /////////////
//////////////////////////////////////////////////////////////////////

public void OnPlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(IsValidClient(client))
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(EntRefToEntIndex(g_grabbed[i]) == client)
			{
				g_grabbed[i] = INVALID_ENT_REFERENCE;				// Clear grabs on them
			}
		}
	}

	return;
}

//////////////////////////////////////////////////////////////////////
/////////////                    Trace                   /////////////
//////////////////////////////////////////////////////////////////////

public int TraceToObject(int client)
{
	float vecClientEyePos[3], vecClientEyeAng[3];
	GetClientEyePosition(client, vecClientEyePos);
	GetClientEyeAngles(client, vecClientEyeAng);

	TR_TraceRayFilter(vecClientEyePos, vecClientEyeAng, MASK_PLAYERSOLID, RayType_Infinite, TraceRayGrab, client);

	return TR_GetEntityIndex(INVALID_HANDLE);
}

public bool TraceRayGrab(int entityhit, int mask, any self)
{
	if(entityhit > 0 && entityhit <= MaxClients)
	{
		if(IsPlayerAlive(entityhit) && entityhit != self)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{		
		char classname[13];
		if(GetEntityClassname(entityhit, classname, 13) && (StrEqual(classname, "prop_physics") || StrEqual(classname, "tf_ammo_pack") || StrContains(classname, "tf_projectile") || StrContains(classname, "prop_") || StrContains(classname, "func_tracktrain") || StrEqual(classname, "prop_physics_override")))
		{
			return true;
		}
	}

	return false;
}

public bool IsValidClient (int target)
{
	if(target > 4096) target = EntRefToEntIndex(target);
	if(target < 1 || target > MaxClients) return false;
	if(!IsClientInGame(target)) return false;
	if(IsFakeClient(target)) return false;
	if(GetEntProp(target, Prop_Send, "m_bIsCoaching")) return false;
	return true;
}