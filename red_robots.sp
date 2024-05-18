#include <sdktools>
#include <betherobot>
#pragma newdecls required

public Plugin myinfo =
{
    name        = "[TF2] Bots fixed",
    author      = "Fartsy",
    description = "Changes bots appearence into Mann Vs Machine Robots",
    version     = "2.0.0",
    url         = "https://wiki.firehostredux.com",
};

public void OnPluginStart(){
	HookEvent("player_spawn", apply_robot);
	HookEvent("post_inventory_application", apply_robot, EventHookMode_Post);
}

public Action BecomeRobot(Handle timer, any bot)
{
	if(IsClientInGame(bot))
	{
		if(IsFakeClient(bot)) BeTheRobot_SetRobot(bot, true);
	}
	return Plugin_Stop;
}

public Action apply_robot(Handle event, const char[] name, bool dontBroadcast)
{
	int bot = GetClientOfUserId(GetEventInt(event, "userid"));
	if (GetClientTeam(bot) == 3 || GetClientTeam(bot) == 0) return Plugin_Stop;
	if(IsFakeClient(bot)){
		BeTheRobot_SetRobot(bot, true);
		CreateTimer(0.00, BecomeRobot, bot);
		CreateTimer(0.01, BecomeRobot, bot);
		CreateTimer(0.05, BecomeRobot, bot);
		CreateTimer(0.25, BecomeRobot, bot);
		CreateTimer(0.50, BecomeRobot, bot);
		CreateTimer(0.75, BecomeRobot, bot);
		CreateTimer(1.00, BecomeRobot, bot);
		PrintToServer("Setting %N to bot, team was %i", bot, GetClientTeam(bot));
	}
	return Plugin_Stop;
}

#include <tf2_stocks> //here
/*public Action:BecomeRobot(Handle:timer, any:bot)
{
    if(IsClientInGame(bot))
    {
        if(IsFakeClient(bot) && TF2_GetClientTeam(bot) == TFTeam_Red)
        {
            BeTheRobot_SetRobot(bot, true);
        }
    }
    
    return Plugin_Handled;
}*/