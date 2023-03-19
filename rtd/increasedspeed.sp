
/*
This script is a part of RTD2 plugin and is not meant to work by itself.
If you were to edit anything here, you'd have to recompile rtd2.sp instead of this one.

*** HOW TO ADD A PERK ***
A quick note: This tutorial may not be kept up to date; for an updated one, go to the plugin's thread.

1. Set up:
	a) Have <perkname>.sp in scripting/rtd.
	b) Add it to the includes in scripting/rtd/#perks.sp.
	c) Add a new section with a correct ID (highest one +1) to the config/rtd2_perks.cfg and set its settings.

2. Edit scripting/rtd/#manager.sp
	a) In a function named ManagePerk() add a new case to the switch() with your perk's ID.
	b) In the added case specify a function which is going to execute from <perkname>.sp with parameters:
		1) @client			- the client the perk should be applied to/removed from
		2) @fSpecialPref	- the optional "special" value in config/rtd2_perks.cfg
		2) @enable			- to specify whether the perk should be applied/removed
	c) OPTIONAL: You can specify a function in your perk which should run at OnMapStart() in the Forward_OnMapStart() function.
		You will need it if you'd want to, for example, precache a sound or loop through existing clients.
	d) OPTIONAL: You can specify a function in your perk which should run at OnPlayerRunCmd() in the Forward_OnPlayerRunCmd() function.
		You can use it if you'd need something to run each frame or on a certain button press.
		NOTE: The forwarded client is guaranteed to be valid BUT NOT GUARANTEED IF THEY ARE ALIVE.

3. Script your perk:
	a) Create a public function in <perkname>.sp with parameters @client, @iPref, @bool:apply as an example below
	   - This is the only function used to transfer info between the core and the include
	   - You don't need to include any includes that are in the rtd2.sp
	b) NOTE: If you need to transfer the iPref to a different function, set it globally but remember to use an unique name
	c) Name it AS SAME AS you named the function in the added case in the switch() in #manager.sp
	d) From there, script the functionality like there's no tomorrow
	e) You are free to use IsValidClient(). It returns false when:
		- An incorrect client index is specified
		- Client is not in game
		- Client is fake (bot)
		- Client is Coaching

4. Compile rtd2.sp and you're good to go!

*/

#define ATTRIB_SPEED 107 //the player speed attribute

float g_fBaseSpeed[MAXPLAYERS+1] = {0.0, ...};

void IncreasedSpeed_Perk(int client, const char[] sPref, bool apply){

	if(apply)
		IncreasedSpeed_ApplyPerk(client, StringToFloat(sPref));
	
	else
		IncreasedSpeed_RemovePerk(client);

}

void IncreasedSpeed_ApplyPerk(int client, float fValue){

	switch(TF2_GetPlayerClass(client)){
	
		case TFClass_Scout:		{g_fBaseSpeed[client] = 400.0;}
		case TFClass_Soldier:	{g_fBaseSpeed[client] = 240.0;}
		case TFClass_DemoMan:	{g_fBaseSpeed[client] = 280.0;}
		case TFClass_Heavy:		{g_fBaseSpeed[client] = 230.0;}
		case TFClass_Medic:		{g_fBaseSpeed[client] = 320.0;}
		default:				{g_fBaseSpeed[client] = 300.0;}
	
	}

	TF2Attrib_SetByDefIndex(client, ATTRIB_SPEED, fValue);
	SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", g_fBaseSpeed[client]*fValue);

}

void IncreasedSpeed_RemovePerk(int client){

	TF2Attrib_RemoveByDefIndex(client, ATTRIB_SPEED);
	SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", g_fBaseSpeed[client]);

}