#include <sdktools>
#include <sourcemod>
#pragma newdecls required
static char PLG_VER[8] = "1.0.0";

public Plugin myinfo = {
    author = "Fartsy#8998",
    description = "Don't worry about it...",
    version = PLG_VER,
    url = "https://forums.firehostredux.com"
};

public void OnPluginStart(){
    RegServerCmd("fb_operator", Command_Operator, "Server-side only. Does nothing when excecuted as client.");
}

public Action Command_Operator(int x){
    switch (x){
        case 0:{
            PrintToChatAll("RED WON.");
        }
        case 1:{
            PrintToChatAll("BLUE WON.");
        }
        case 2:{
            PlayStartupSound();
            PrintToChatAll("ROUND START.");
        }
    }
}

void PlayStartupSound(){
    int i = GetRandomInt(1, 3);
    switch(i){
        case 1:{
            EmitSoundToAll("ambient/thunder2.wav");
        }
        case 2:{
            EmitSoundToAll("ambient/thunder3.wav");
        }
        case 3:{
            EmitSoundToAll("ambient/thunder4.wav");
        }
    }
}