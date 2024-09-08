#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
static char PLUGIN_VERSION[8] = "1.0.0 ";

public Plugin myinfo = {
  name = "Fartsy's Entity Data",
  author = "Fartsy",
  description = "Fuck around and find out",
  version = PLUGIN_VERSION,
  url = "https://forums.firehostredux.com"
};

public void OnPluginStart(){
    HookEntityOutput("trigger_multiple", "OnStartTouch", MyOutput);
}

public Action MyOutput(const String:output[], caller, activator, Float:delay){
    PrintToChatAll("Hello, %N triggered me!", IsValidClient(activator) ? activator : "Something else...");
    return Plugin_Stop;
}

bool IsValidClient(client, bool nobots = true)
{ 
    if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
    {
        return false; 
    }
    return IsClientInGame(client); 
}  