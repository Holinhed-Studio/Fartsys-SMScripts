#include <sourcemod>
#include <sdktools>
#pragma newdecls required
#pragma semicolon 1
bool iswave = false;
bool bgmlock1 = true;
bool bgmlock2 = true;
bool bgmlock3 = true;
bool bgmlock4 = true;
bool bgmlock5 = true;
bool bgmlock6 = true;
bool bgmlock7 = true;
bool bgmlock8 = true;
int bombStatus = 0;
int bombStatusMax = 0;
int bombsPushed = 0;
int bombCache = 0;

public Plugin myinfo =
{
	name = "Dovah's Ass - Framework",
	author = "Fartsy#0001",
	description = "Framework for Dovah's Ass",
	version = "1.2.6",
	url = "https://forums.firehostredux.com"
};

public void OnPluginStart()
{
	//RegServerCmd("fb_gotowave4", Command_JumpToWave4, "Jump to wave 4 - DO NOT TOUCH, WILL LIKELY MESS STUFF UP."), //REPLACED BY fb_nextwave and fb_previouswave
	//RegServerCmd("fb_gotowave6", Command_JumpToWave6, "Jump to wave 6 - DO NOT TOUCH, WILL LIKELY MESS STUFF UP."),
	RegServerCmd("fb_forcevictory", Command_ForceVictory, "FORCE victory - DO NOT TOUCH, WILL LIKELY MESS STUFF UP."),
	RegServerCmd("fb_trainincoming", Command_TrainIncoming, "A train is incoming!"),
	RegServerCmd("fb_atomicbmbrain", Command_AtomBmbRain, "Atom bombs are now raining from the sky!"),
	RegServerCmd("fb_ohnoes", Command_OhNoes, "Oh noes, prepare your anus!"),
	RegServerCmd("fb_meteorincoming", Command_MeteorIncoming, "Meteor incoming!"),
	RegServerCmd("fb_meteorshower", Command_MeteorShower, "Meteor Shower incoming!"),
	RegServerCmd("fb_prepareyourself", Command_DovahsAss, "You have chosen Dovah's Ass, prepare yourself..."),
	RegServerCmd("fb_wave1", Command_WaveOne, "Wave one started."),
	RegServerCmd("fb_wave1_bmbavail", Command_WaveOneBombUp, "Wave one - bomb available."),
	RegServerCmd("fb_wave2", Command_WaveTwo, "Wave two started."),
	RegServerCmd("fb_wave2_bmbavail", Command_WaveTwoBombUp, "Wave two - bomb available."),
	RegServerCmd("fb_wave3", Command_WaveThree, "Wave three started."),
	RegServerCmd("fb_wave3_bmbavail", Command_WaveThreeBombUp, "Wave three - bomb available."),
	RegServerCmd("fb_wave4", Command_WaveFour, "Wave four started."),
	RegServerCmd("fb_wave4_bmbavail", Command_WaveFourBombUp, "Wave four - bomb available."),
	RegServerCmd("fb_wave5", Command_WaveFive, "Wave five started."),
	RegServerCmd("fb_wave5_bmbavail", Command_WaveFiveBombUp, "Wave five - bomb available."),
	RegServerCmd("fb_wave6", Command_WaveSix, "Wave six started."),
	RegServerCmd("fb_wave6_bmbavail", Command_WaveSixBombUp, "Wave six - bomb available."),
	RegServerCmd("fb_wave7", Command_WaveSeven, "Wave seven started."),
	RegServerCmd("fb_wave7_bmbavail", Command_WaveSevenBombUp, "Fat Man - bomb available."),
	RegServerCmd("fb_hydrogenup", Command_HydrogenUp, "Hydrogen available."),
	RegServerCmd("fb_wave8", Command_WaveEight, "Wave eight started."),
	RegServerCmd("fb_burgup", Command_WaveSevenBurgUp, "Wave seven - burg up!"),
	RegServerCmd("fb_foundgoob", Command_FoundGoob, "ALL HAIL GOOBBUE!"),
	RegServerCmd("fb_foundwaffle", Command_FoundWaffle, "Why do they call it the waffle of mass destruction if it does nothing!?"),
	RegServerCmd("fb_foundburrito", Command_FoundBurrito, "Forbidden Burrito. Yum."),
	RegServerCmd("fb_foundshroom", Command_FoundShroom, "What does this even do!?"),
	RegServerCmd("fb_foundball", Command_FoundBall, "Incoming blue ball..."),
	RegServerCmd("fb_tsplus1", Command_TSPlus1, "Tornado sacrifice -- plus one!"),
	RegServerCmd("fb_dpsacplus1", Command_DPSacPlus1, "Death pit sacrofice -- plus one!"),
	RegServerCmd("fb_ksacplus1", Command_KissoneSacPlus1, "KissoneTM sacrifice -- plus one!"),
	RegServerCmd("fb_bresplus5", Command_BombResPlus5, "Bomb reset -- plus five!"),
	RegServerCmd("fb_sbathsalts", Command_BathSaltsSacMinus10, "Bath salts, minus ten!"),
	RegServerCmd("fb_sfatman", Command_FatManSacMinus20, "Fat man, minus twenty!"),
	RegServerCmd("fb_sgoobbue", Command_GoobbueSacMinus30, "Goobbue, minus thirty!"),
	RegServerCmd("fb_skirb", Command_BlueBallSacMinus30, "Blue ball, minus thirty!"),
	RegServerCmd("fb_sgboom", Command_GBoomSacMinus40, "Explosive paradise, minus fourty!"),
	RegServerCmd("fb_assgas", Command_AssGasMinus40, "Ass gas, minus fourty!"),
	RegServerCmd("fb_skirbward", Command_KirbyWardSacMinus50, "KIRBY HAS BANISHED TORNADOES!"),
	RegServerCmd("fb_snfo", Command_NFOSacMinus60, "Atomic bomb rain, minus sixty!"),
	RegServerCmd("fb_smeteors", Command_MeteorsSacMinus70, "Meteors, minus seventy!"),
	RegServerCmd("fb_sdovah", Command_DovahSacMinus100, "Professor Fartsalot, minus one hundred!"),
	RegServerCmd("fb_prevwave", Command_JumpToPrevWave, "Jump to previous wave."),
	RegServerCmd("fb_nextwave", Command_JumpToNextWave, "Jump to next wave."),
	RegServerCmd("fb_bombpushplus5", Command_BombPushPlusFive, "Bomb pushed - plus five!"),
	RegServerCmd("dovahsass_finished", Command_DovahsAssFinished, "DovahsAss has been completed!"),
	RegServerCmd("fb_tacobell", Command_TacoBell, "Just why?"),
	RegServerCmd("tacobell_wave01", Command_TBWave01,"Taco Bell - Wave One"),
	RegServerCmd("tacobell_wave02", Command_TBWave02,"Taco Bell - Wave Two"),
	RegServerCmd("tacobell_wave03", Command_TBWave03,"Taco Bell - Wave Three"),
	RegServerCmd("tacobell_wave04", Command_TBWave04,"Taco Bell - Wave Four"),
	RegServerCmd("tacobell_wave05", Command_TBWave05,"Taco Bell - Wave Five"),
	RegServerCmd("tacobell_wave06", Command_TBWave06,"Taco Bell - Wave Six"),
	RegServerCmd("tacobell_wave07", Command_TBWave07,"Taco Bell - Wave Seven"),
	RegServerCmd("tacobell_wave08", Command_TBWave08,"Taco Bell - Wave Eight"),
	RegServerCmd("tacobell_wave09", Command_TBWave09,"Taco Bell - Wave Nine"),
	RegServerCmd("tacobell_wave10", Command_TBWave10,"Taco Bell - Wave Ten"),
	RegServerCmd("tacobell_wave11", Command_TBWave11,"Taco Bell - Wave Eleven"),
	RegServerCmd("tacobell_wave12", Command_TBWave12,"Taco Bell - Wave Twelve"),
	RegServerCmd("tacobell_wave13", Command_TBWave13,"Taco Bell - Wave Thirteen"),
	RegServerCmd("tacobell_wave14", Command_TBWave14,"Taco Bell - Wave Fourteen"),
	RegServerCmd("tacobell_wave15", Command_TBWave15,"Taco Bell - Wave Fifteen"),
	RegServerCmd("tacobell_wave16", Command_TBWave16,"Taco Bell - Wave Sixteen"),
	RegServerCmd("tacobell_wave17", Command_TBWave17,"Taco Bell - Wave Seventeen"),
	RegServerCmd("tacobell_wave18", Command_TBWave18,"Taco Bell - Wave Eighteen"),
	RegServerCmd("tacobell_wave19", Command_TBWave19,"Taco Bell - Wave Nineteen"),
	RegServerCmd("tacobell_wave20", Command_TBWave20,"Taco Bell - Wave Twenty"),
	RegServerCmd("tacobell_wave21", Command_TBWave21,"Taco Bell - Wave Twenty-One"),
	RegServerCmd("tacobell_finished", Command_TacoBellFinished, "TacoBell has been completed!"),
	RegServerCmd("fb_fire", Command_FBFire, "Operator for Professor's Ass."),
	RegServerCmd("fb_wavefinished", Command_FBWaveComplete, "Wave finished."),
	RegConsoleCmd("sm_bombstatus", Command_FBBombStatus, "Check bomb status"),
	HookEvent("player_death", EventDeath),
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre),
	HookEvent("mvm_bomb_alarm_triggered", EventWarning),
	HookEvent("mvm_bomb_reset_by_player", EventReset);
}

//Now that command definitions are done, lets make some things happen.
public void OnMapStart()
{
	ServerCommand("fb_fire SNDSCPE_* disable"),
	ServerCommand("fb_fire BombStatus disable"),
	SelectBGM();
}

//Custom definitions
public Action SelectBGM()
{
	int BGM = GetRandomInt(1, 2);
	ServerCommand("fb_fire Music.* StopSound");
	if (BGM == 1){
		ServerCommand("fb_fire Music.TheSilentRegardOfStars PlaySound");
		PrintToServer("Creating timer for The Silent Regard of Stars. Enjoy the music!");
		CreateTimer(137.75, RefireBGM);
	}
	else if (BGM == 2){
		ServerCommand("fb_fire Music.KnowledgeNeverSleeps PlaySound");
		PrintToServer("Creating timer for Knowledge Never Sleeps. Enjoy the music!");
		CreateTimer(235.5, RefireBGM);
	}
}

//Timers

//BGM (Defaults)
public Action RefireBGM(Handle timer)
{
	if (!iswave){
		SelectBGM();
	}
	return Plugin_Stop;
}

//BGM (Locus)
public Action RefireLocus(Handle timer)
{
	if (!bgmlock1){
		ServerCommand("fb_fire Music.Locus StopSound; fb_fire Music.Locus PlaySound");
		CreateTimer(229.25, RefireLocus);
	}
	return Plugin_Stop;
}

//BGM (Metal)
public Action RefireMetal(Handle timer)
{
	if (!bgmlock2){
		ServerCommand("fb_fire Music.Metal StopSound; fb_fire Music.Metal PlaySound");
		CreateTimer(153.95, RefireMetal);
	}
	return Plugin_Stop;
}

//BGM (Exponential Entropy)
public Action RefireEntropy(Handle timer)
{
	if (!bgmlock3){
		ServerCommand("fb_fire Music.ExponentialEntropy StopSound; fb_fire Music.ExponentialEntropy PlaySound");
		CreateTimer(166.85, RefireEntropy);
	}
	return Plugin_Stop;
}

//BGM (Torn From the Heavens)
public Action RefireTorn(Handle timer)
{
	if (!bgmlock4){
		ServerCommand("fb_fire Music.TornFromTheHeavens StopSound; fb_fire Music.TornFromTheHeavens PlaySound");
		CreateTimer(122.25, RefireTorn);
	}
	return Plugin_Stop;
}

//BGM (Brute Justice Mode)
public Action RefireBJMode(Handle timer)
{
	if (!bgmlock5){
		ServerCommand("fb_fire Music.MetalBruteJusticeMode StopSound; fb_fire Music.MetalBruteJusticeMode PlaySound");
		CreateTimer(131.75, RefireBJMode);
	}
	return Plugin_Stop;
}

//BGM (Grandma Destruction)
public Action RefireGrandma(Handle timer)
{
	if (!bgmlock6){
		ServerCommand("fb_fire Music.GrandmaDestruction StopSound; fb_fire Music.GrandmaDestruction PlaySound");
		CreateTimer(323.95, RefireGrandma);
	}
	return Plugin_Stop;
}

//BGM (Revenge Twofold)
public Action RefireRevenge2F(Handle timer){
	if (!bgmlock7){
		ServerCommand("fb_fire Music.RevengeTwofold StopSound; fb_fire Music.RevengeTwofold PlaySound");
		CreateTimer(133.25, RefireRevenge2F);
	}
	return Plugin_Stop;
}

//BGM (Under The Weight)
public Action RefireUnderTW(Handle timer){
	if (!bgmlock8){
		ServerCommand("fb_fire Music.UnderTheWeight StopSound; fb_fire Music.UnderTheWeight PlaySound");
		CreateTimer(313.85, RefireUnderTW);
	}
	return Plugin_Stop;
}

//BombStatus (Add points to Bomb Status occasionally)
public Action BombStatusTimer(Handle timer){
	if (iswave && (bombStatus < bombStatusMax)){
		bombStatus++;
		//ServerCommand("fb_fire BombStatus SetValue %i", bombStatus); //TODO: Delet me. I am no longer needed.
		float f = GetRandomFloat(10.0, 45.0);
		PrintToServer("[DEBUG] Creating a %f timer to give bomb status an update. Current target is %i", f, bombStatus);
		CreateTimer(f, BombStatusTimer);	
		switch (bombStatus){ //new bombstatus parser
			case 8:{
				bombStatusMax = 8;
				bombCache = 0;
				ServerCommand("fb_fire Bombs.* Disable; fb_fire BombExplo* Disable; fb_fire Delivery Unlock; fb_fire BombExploSmall Enable; fb_fire Bombs.FreedomBomb Enable");
				EmitSoundToAll("dovahki/misc/triggerscore.wav");
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000FREEDOM BOMB \x0700AA55is now available for deployment!");
			}
			case 16:{
				bombStatusMax = 16;
				bombCache = 0;
				ServerCommand("fb_fire Bombs.* Disable; fb_fire BombExplo* Disable; fb_fire Delivery Unlock; fb_fire BombExploMedium Enable; fb_fire Bombs.ElonBust Enable");
				EmitSoundToAll("dovahki/misc/triggerscore.wav");
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000ELON BUST \x0700AA55is now available for deployment!");
			}
			case 24:{
				bombStatusMax = 24;
				bombCache = 0;
				ServerCommand("fb_fire Bombs.* Disable; fb_fire BombExplo* Disable; fb_fire Delivery Unlock; fb_fire BombExploMedium Enable; fb_fire Bombs.BathSalts Enable");
				EmitSoundToAll("dovahki/misc/triggerscore.wav");
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000BATH SALTS \x0700AA55are now available for deployment!");
			}
			case 32:{
				bombStatusMax = 32;
				bombCache = 0;
				ServerCommand("fb_fire Bombs.* Disable; fb_fire BombExplo* Disable; fb_fire Delivery Unlock; fb_fire BombExploMedium Enable; fb_fire Bombs.FallingStar Enable; fb_fire BombExploFallingStar Enable");
				EmitSoundToAll("dovahki/misc/triggerscore.wav");
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FFFF00FALLING STAR\x0700AA55 is now available for deployment!");
			}
			case 40:{
				bombStatusMax = 40;
				bombCache = 0;
				ServerCommand("fb_fire Bombs.* Disable; fb_fire BombExplo* Disable; fb_fire BombExploMedium Enable; fb_fire Delivery Unlock; fb_fire Bombs.MajorKong Enable; fb_fire BombExploMajorKong Enable");
				EmitSoundToAll("dovahki/misc/triggerscore.wav");
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000MAJOR KONG \x0700AA55is now available for deployment!");
			}
			case 48:{
				bombStatusMax = 48;
				bombCache = 0;
				ServerCommand("fb_fire Bombs.* Disable; fb_fire BombExplo* Disable; fb_fire BombExploLarge Enable; fb_fire Delivery Unlock; fb_fire Bombs.SharkTorpedo Enable; fb_fire BombExploShark Enable");
				EmitSoundToAll("dovahki/misc/triggerscore.wav");
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000SHARK \x0700AA55is now available for deployment!");
			}
			case 56:{
				bombStatusMax = 56;
				bombCache = 0;
				ServerCommand("fb_fire Bombs.* Disable; fb_fire BombExplo* Disable; fb_fire Bombs.FatMan Enable; fb_fire Delivery Unlock; fb_fire BombExploFatMan Enable");
				EmitSoundToAll("dovahki/misc/triggerscore.wav");
				PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000FAT MAN \x0700AA55is now available for deployment!");
			}
		}
	}
	return Plugin_Stop;
}
//Command action definitions
public Action Command_FBWaveComplete(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	iswave = false;
	SelectBGM();
	PrintToChatAll("\x0700FF00[CORE] \x07FFFFFFYou've defeated the wave!");
}

public Action Command_FBBombStatus(int client, int args){
	PrintToChat(client, "\x0700FF00[CORE] \x07FFFFFFThe bomb status is currently %i", bombStatus);
	//No bombs have yet been deployed nor have they been unlocked.
	if (bombStatus <= 7){
		PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Bombs are \x07FF0000NOT AVAILABLE\x07FFFFFF!");
	}
	//Only execute if Freedom Bomb is available.
	else if (bombStatus >= 8 && bombStatus < 16){
		//If no bombs are pushed and next bomb IS ready.
		if (bombsPushed == 0 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000FREEDOM BOMB \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb and next bomb is NOT ready.
		else if(bombsPushed == 1 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Please wait for the next bomb.");
		}
		return Plugin_Continue;
	}
	//Only execute if Elon Bust is available.
	else if(bombStatus >= 16 && bombStatus < 24){
		//If no bombs are pushed and next bomb IS ready. Should probably not be possible?
		//if (bombsPushed == 0 && bombCache == 0){
		//	PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000ELON BUST \x0700AA55is available for deployment! This shouldn't even have been //possible!");
		//}
		//If we've pushed the Freedom Bomb and next bomb is NOT ready. Should not be possible.
		//else if (bombsPushed == 1 && bombCache == 1){
		//	PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Please wait for the next bomb. 8 > 16 ???");
		//}

		//If we've pushed the Freedom Bomb and next bomb IS ready.
		else if (bombsPushed == 1 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Your team's \x07FF0000ELON BUST \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb and the Elon Bust and next bomb is NOT ready.
		else if(bombsPushed == 2 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FF0000ELON BUST \x0700AA55. Please wait for the next bomb.");
		}
		return Plugin_Continue;
	}
	//Only execute if Bath Salts are available.
	else if(bombStatus >= 24 && bombStatus < 32){
		//If no bombs are pushed and next bomb IS ready. Should probably not be possible?
		if (bombsPushed == 0 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb and the next bomb is NOT ready. This should not be possible?
		else if(bombsPushed == 1 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FF0000FREEDOM BOMB \x0700AA55. Please wait for the next bomb. But wait shouldnt this have been pushed?");
		}
		//If we've pushed the Freedom Bomb and the next bomb is ready. This also probably should not be possible right?
		else if (bombsPushed == 1 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Your team's \x07FF0000ELON BUST \x0700AA55are available for deployment! Probably not possible though!");
		}
		//If we've pushed the Freedom Bomb and Elon Bust and the next bomb is NOT ready. Should not be possible either.
		else if(bombsPushed == 2 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FF0000ELON BUST \x0700AA55. Please wait for the next bomb. How is 16 equal to 24?");
		}
		
		//If we've pushed the Freedom Bomb and the Elon Bust and the next bomb IS ready.
		else if (bombsPushed == 2 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFELON BUST \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts and the next bomb is NOT ready.
		else if (bombsPushed == 3 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Please wait for the next bomb.");
		}
		return Plugin_Continue;
	}
	else if (bombStatus >= 32 && bombStatus < 40){
		//If no bombs are pushed and next bomb IS ready. Should probably not be possible?
		if (bombsPushed == 0 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb and the next bomb is NOT ready. This should not be possible?
		else if(bombsPushed == 1 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FF0000FREEDOM BOMB \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and the Elon Bust and the next bomb IS ready.
		else if (bombsPushed == 1 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Your team's \x07FF0000ELON BUST \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb and Elon Bust and the next bomb is NOT ready. Should not be possible either.
		else if(bombsPushed == 2 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FF0000ELON BUST \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and Elon Bust and the next bomb IS ready. Should not be possible either.
		else if(bombsPushed == 2 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FF0000ELON BUST \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts and the next bomb is NOT ready.
		else if (bombsPushed == 3 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts, and the next bomb IS ready.
		else if (bombsPushed == 3 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Your team's \x07FF0000Falling Star \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS NOT ready.
		else if (bombsPushed == 4 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFALLING STAR \x0700AA55. Please wait for the next bomb.");
		}
		return Plugin_Continue;
	}
	else if (bombStatus >= 40 && bombStatus < 48){
		//If no bombs are pushed and next bomb IS ready. Should probably not be possible?
		if (bombsPushed == 0 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb and the next bomb is NOT ready. This should not be possible?
		else if(bombsPushed == 1 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FF0000FREEDOM BOMB \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and the next bomb is ready. This also probably should not be possible right?
		else if (bombsPushed == 1 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb and Elon Bust and the next bomb is NOT ready. Should not be possible either.
		else if(bombsPushed == 2 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FF0000ELON BUST \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and the Elon Bust and the next bomb IS ready.
		else if (bombsPushed == 2 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFELON BUST \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts and the next bomb is NOT ready.
		else if (bombsPushed == 3 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts, and the next bomb IS ready.
		else if (bombsPushed == 3 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Your team's \x07FF0000FALLING STAR \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS NOT ready.
		else if (bombsPushed == 4 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFALLING STAR \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS ready.
		else if (bombsPushed == 4 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFFALLING STAR \x0700AA55. Your team's \x07FF0000MAJOR KONG \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, and Major Kong and the next bomb is NOT ready.
		else if (bombsPushed == 5 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFMAJOR KONG \x0700AA55. Please wait for the next bomb.");
		}
	}
	else if (bombStatus >= 48 && bombStatus < 56){
		//If no bombs are pushed and next bomb IS ready. Should probably not be possible?
		if (bombsPushed == 0 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb and the next bomb is NOT ready. This should not be possible?
		else if(bombsPushed == 1 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FF0000FREEDOM BOMB \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and the next bomb is ready. This also probably should not be possible right?
		else if (bombsPushed == 1 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb and Elon Bust and the next bomb is NOT ready. Should not be possible either.
		else if(bombsPushed == 2 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FF0000ELON BUST \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and the Elon Bust and the next bomb IS ready.
		else if (bombsPushed == 2 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFELON BUST \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts and the next bomb is NOT ready.
		else if (bombsPushed == 3 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts, and the next bomb IS ready.
		else if (bombsPushed == 3 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Your team's \x07FF0000FALLING STAR \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS NOT ready.
		else if (bombsPushed == 4 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFALLING STAR \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS ready.
		else if (bombsPushed == 4 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFFALLING STAR \x0700AA55. Your team's \x07FF0000MAJOR KONG \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, and Major Kong and the next bomb is NOT ready.
		else if (bombsPushed == 5 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFMAJOR KONG \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, and Major Kong and the next bomb IS ready.
		else if (bombsPushed == 5 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFMAJOR KONG \x0700AA55. Your team's \x07FF0000SHARK \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, Major Kong, and Shark and the next bomb IS NOT ready.
		else if (bombsPushed == 6 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFSHARK \x0700AA55. Please wait for the next bomb.");
		}
	}
	else if (bombStatus >= 56 && bombStatus < 64){
		//If no bombs are pushed and next bomb IS ready. Should probably not be possible?
		if (bombsPushed == 0 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has not deployed any bombs, however: Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb and the next bomb is NOT ready. This should not be possible?
		else if(bombsPushed == 1 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FF0000FREEDOM BOMB \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and the next bomb is ready. This also probably should not be possible right?
		else if (bombsPushed == 1 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFREEDOM BOMB \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb and Elon Bust and the next bomb is NOT ready. Should not be possible either.
		else if(bombsPushed == 2 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FF0000ELON BUST \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb and the Elon Bust and the next bomb IS ready.
		else if (bombsPushed == 2 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFELON BUST \x0700AA55. Your team's \x07FF0000BATH SALTS \x0700AA55are available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts and the next bomb is NOT ready.
		else if (bombsPushed == 3 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, and Bath Salts, and the next bomb IS ready.
		else if (bombsPushed == 3 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFBATH SALTS \x0700AA55. Your team's \x07FF0000FALLING STAR \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS NOT ready.
		else if (bombsPushed == 4 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFFALLING STAR \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, and Falling Star and the next bomb IS ready.
		else if (bombsPushed == 4 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFFALLING STAR \x0700AA55. Your team's \x07FF0000MAJOR KONG \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, and Major Kong and the next bomb is NOT ready.
		else if (bombsPushed == 5 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFMAJOR KONG \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, and Major Kong and the next bomb IS ready.
		else if (bombsPushed == 5 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFMAJOR KONG \x0700AA55. Your team's \x07FF0000SHARK \x0700AA55is available for deployment!");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, Major Kong, and Shark and the next bomb IS NOT ready.
		else if (bombsPushed == 6 && bombCache == 1){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed a \x07FFFFFFSHARK \x0700AA55. Please wait for the next bomb.");
		}
		//If we've pushed the Freedom Bomb, Elon Bust, Bath Salts, Falling Star, Major Kong, and Shark and the next bomb IS ready.
		else if (bombsPushed == 6 && bombCache == 0){
			PrintToChat(client, "\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team recently deployed \x07FFFFFFSHARK \x0700AA55. Your team's \x07FF0000FAT MAN \x0700AA55is available for deployment!");
		}
	}
	else if (bombStatus >= 64 && bombStatus < 72){
		PrintToChatAll("wowie you did it you hit 72!");
	}
	return Plugin_Handled;
}

public Action Command_ForceVictory(int args)
{
	int flags = GetCommandFlags("tf_mvm_force_victory");
	SetCommandFlags("tf_mvm_force_victory", flags & ~FCVAR_CHEAT);
	ServerCommand("tf_mvm_force_victory 1");
	FakeClientCommand(0, ""); //Not sure why, but this has to be here. Otherwise the specified commands simply refuse to work...
	SetCommandFlags("tf_mvm_force_victory", flags|FCVAR_CHEAT);
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF VICTORY HAS BEEN FORCED! THE SERVER WILL RESTART IN 10 SECONDS.");
	CreateTimer(10.0, Timer_RestartServer);
}

public Action Command_TrainIncoming(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07AA7000KISSONE'S TRAIN\x07FFFFFF is \x07AA0000INCOMING\x07FFFFFF. Look out!");
}

public Action Command_AtomBmbRain(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, it's begun to rain \x07AA0000ATOM BOMBS\x07FFFFFF! TAKE COVER!");
}

public Action Command_OhNoes(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFOh noes, prepare your anus! A \x07AA0000TORNADO WARNING\x07FFFFFF has been issued! TAKE COVER NOW!!!");
}

public Action Command_MeteorIncoming(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, a \x07AA0000METEOR\x07FFFFFF has been spotted coming towards Dovah's Ass!!!");
}

public Action Command_MeteorShower(int args)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA] \x07FFFFFFUh oh, a \x07AA0000METEOR SHOWER\x07FFFFFF has been reported from Dovah's Ass!!!");
}

public Action Command_DovahsAss(int args)
{
	PrintToChatAll("\x070000AA[\x07AAAA00INFO\x070000AA] \x07FFFFFFYou have chosen \x07AA0000DOVAH'S ASS\x07FFFFFF. Prepare yourself for the unpredictable...");
}

public Action Command_WaveOne(int args)
{
	bgmlock1 = false;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	iswave = true;
	bombStatusMax = 8;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 1: Locus");
	ServerCommand("fb_fire Music.* StopSound");
	ServerCommand("fb_fire Music.Locus PlaySound");
	CreateTimer(229.25, RefireLocus);
	CreateTimer(1.0, BombStatusTimer);
}

public Action Command_WaveOneBombUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00LEGACY\x070000AA] \x0700AA55Your team's \x07FF0000FREEDOM BOMB \x0700AA55is now available for deployment!");
}

public Action Command_WaveTwo(int args)
{
	bgmlock1 = true;
	bgmlock2 = false;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	iswave = true;
	bombStatusMax = 16;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 2: Metal");
	ServerCommand("fb_fire Music.* StopSound");
	ServerCommand("fb_fire Music.Metal PlaySound");
	CreateTimer(153.95, RefireMetal);
	CreateTimer(1.0, BombStatusTimer);
}

public Action Command_WaveTwoBombUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00LEGACY\x070000AA] \x0700AA55Your team's \x07FF0000ELON BUST \x0700AA55is now available for deployment!");
}

public Action Command_WaveThree(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = false;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	iswave = true;
	bombStatusMax = 24;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 3: Exponential Entropy");
	ServerCommand("fb_fire Music.* StopSound");
	ServerCommand("fb_fire Music.ExponentialEntropy PlaySound");
	CreateTimer(166.85, RefireEntropy);
	CreateTimer(1.0, BombStatusTimer);
}

public Action Command_WaveThreeBombUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00LEGACY\x070000AA] \x0700AA55Your team's \x07FF0000BATH SALTS \x0700AA55are now available for deployment!");
}

public Action Command_WaveFour(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = false;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	iswave = true;
	bombStatusMax = 32;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 4: Torn From The Heavens");
	ServerCommand("fb_fire Music.* StopSound");
	ServerCommand("fb_fire Music.TornFromTheHeavens PlaySound");
	CreateTimer(122.25, RefireTorn);
	CreateTimer(1.0, BombStatusTimer);
}

public Action Command_WaveFourBombUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00LEGACY\x070000AA] \x0700AA55Your team's \x07FFFF00FALLING STAR\x0700AA55 is now available for deployment!");
}

public Action Command_WaveFive(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = false;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = true;
	iswave = true;
	bombStatusMax = 40;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 5: Metal - Brute Justice Mode");
	ServerCommand("fb_fire Music.* StopSound");
	ServerCommand("fb_fire Music.MetalBruteJusticeMode PlaySound");
	CreateTimer(131.75, RefireBJMode);
	CreateTimer(1.0, BombStatusTimer);
}

public Action Command_WaveFiveBombUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00LEGACY\x070000AA] \x0700AA55Your team's \x07FF0000MAJOR KONG \x0700AA55is now available for deployment!");
}

public Action Command_WaveSix(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = false;
	bgmlock7 = true;
	bgmlock8 = true;
	iswave = true;
	bombStatusMax = 48;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 6: Grandma Destruction");
	ServerCommand("fb_fire Music.* StopSound");
	ServerCommand("fb_fire Music.GrandmaDestruction PlaySound");
	CreateTimer(323.95, RefireGrandma);
	CreateTimer(1.0, BombStatusTimer);
}

public Action Command_WaveSixBombUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00LEGACY\x070000AA] \x0700AA55Your team's \x07FF0000SHARK \x0700AA55is now available for deployment!");
}

public Action Command_WaveSeven(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = false;
	bgmlock8 = true;
	iswave = true;
	bombStatusMax = 56;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 7: Revenge Twofold");
	ServerCommand("fb_fire Music.* StopSound");
	ServerCommand("fb_fire Music.RevengeTwofold PlaySound");
	CreateTimer(133.25, RefireRevenge2F);
	CreateTimer(1.0, BombStatusTimer);
}

public Action Command_WaveSevenBombUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00LEGACY\x070000AA] \x0700AA55Your team's \x07FF0000FAT MAN \x0700AA55is now available for deployment!");
}

public Action Command_HydrogenUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team's \x07FF0000HYDROGEN \x0700AA55is now available for deployment!");
}

public Action Command_WaveSevenBurgUp(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Your team has delivered Hydrogen! The \x07FF0000HINDENBURG \x0700AA55is now ready for flight!");
}

public Action Command_WaveEight(int args)
{
	bgmlock1 = true;
	bgmlock2 = true;
	bgmlock3 = true;
	bgmlock4 = true;
	bgmlock5 = true;
	bgmlock6 = true;
	bgmlock7 = true;
	bgmlock8 = false;
	iswave = true;
	bombStatusMax = 64;
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 8: Under The Weight");
	ServerCommand("fb_fire Music.* StopSound");
	ServerCommand("fb_fire Music.UnderTheWeight PlaySound");
	CreateTimer(313.85, RefireUnderTW);
	CreateTimer(1.0, BombStatusTimer);
}

public Action Command_FoundGoob(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55ALL HAIL \x07FF00FFGOOBBUE\x0700AA55!");
}

public Action Command_FoundWaffle(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Oh no, someone has found and (probably) consumed a \x07FF0000WAFFLE OF MASS DESTRUCTION\x07FFFFFF!");
}

public Action Command_FoundBurrito(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Why would you even eat \x07FF0000The Forbidden Burrito\x07FFFFFF?");
}

public Action Command_FoundShroom(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55Welp, someone is playing \x0700FF00Mario\x07FFFFFF...");
}

public Action Command_FoundBall(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x0700AA55What on earth IS that? It appears to be a... \x075050FFBLUE BALL\x07FFFFFF!");
}

public Action Command_TSPlus1(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Sacrificed a client into orbit. (\x0700FF00+1 pt\x07FFFFFF)");
}

public Action Command_DPSacPlus1(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Sent a client to their doom. (\x0700FF00+1 pt\x07FFFFFF)");
}

public Action Command_KissoneSacPlus1(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Dunked a client into liquid death. (\x0700FF00+1 pt\x07FFFFFF)");
}

public Action Command_BombResPlus5(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Bomb has been reset. (\x0700FF00+5 pts\x07FFFFFF)");
}

public Action Command_BathSaltsSacMinus10(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF INSTANT BATH SALT DETONATION! (\x07FF0000-10 pts\x07FFFFFF)");
}

public Action Command_FatManSacMinus20(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF INSTANT FAT MAN DETONATION! (\x07FF0000-20 pts\x07FFFFFF)");
}

public Action Command_GoobbueSacMinus30(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF GOOBBUE COMING IN FROM ORBIT! (\x07FF0000-30 pts\x07FFFFFF)");
}

public Action Command_BlueBallSacMinus30(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF BLUE KIRBY FALLING OUT OF THE SKY! (\x07FF0000-30 pts\x07FFFFFF)");
}

public Action Command_GBoomSacMinus40(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF We're spending most our lives living in an EXPLOSIVE PARADISE! (\x07FF0000-40 pts\x07FFFFFF)");
}

public Action Command_AssGasMinus40(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF NO NO NO, STOP THE SHARTS!!!! (\x07FF0000-40 pts\x07FFFFFF)");
}

public Action Command_KirbyWardSacMinus50(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF A PINK KIRBY HAS BANISHED TORNADOES FOR THIS WAVE! (\x07FF0000-50 pts\x07FFFFFF)");
}

public Action Command_NFOSacMinus60(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF TOTAL ATOMIC ANNIHILATION. (\x07FF0000-60 pts\x07FFFFFF)");
}

public Action Command_MeteorsSacMinus70(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF COSMIC DEVASTATION IMMINENT. (\x07FF0000-70 pts\x07FFFFFF)");
}

public Action Command_DovahSacMinus100(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF NOW PRESENTING... PROFESSOR FARTSALOT OF THE HINDENBURG! (\x07FF0000-100 points\x07FFFFFF)");
}

public Action Command_BombPushPlusFive(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Bomb successfully pushed! (\x0700FF00+5 pts\x07FFFFFF)");
	bombStatusMax = (bombStatusMax + 8);
	bombsPushed++;
	bombCache = 1;
	CreateTimer(3.0, BombStatusTimer);
}

public Action Command_DovahsAssFinished(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF YOU HAVE SUCCESSFULLY COMPLETED DOVAH'S ASS ! THE SERVER WILL RESTART IN 10 SECONDS.");
	CreateTimer(10.0, Timer_RestartServer);
}

//Taco Bell edition commands and features
public Action Command_TacoBell(int args)
{
	PrintToChatAll("\x070000AA[\x07AAAA00INFO\x070000AA] \x07FFFFFFYou have chosen \x07AA0000DOVAH'S ASS - TACO BELL EDITION\x07FFFFFF. Why... Why would you DO THIS?! Do you not realize what you've just done?????");
}

public Action Command_TBWave01(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 01: Battle On The Big Bridge");
}

public Action Command_TBWave02(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 02: Locus");
}

public Action Command_TBWave03(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 03: Metal");
}

public Action Command_TBWave04(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 04: Torn From The Heavens");
}

public Action Command_TBWave05(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 05: Exponential Entropy");
}

public Action Command_TBWave06(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 06: Grandma Destruction");
}

public Action Command_TBWave07(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 07: Rise");
}

public Action Command_TBWave08(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 08: Metal - Brute Justice Mode");
}

public Action Command_TBWave09(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 09: Locus");
}

public Action Command_TBWave10(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 10: Exponential Entropy");
}

public Action Command_TBWave11(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 11: Revenge Twofold");
}

public Action Command_TBWave12(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 12: Metal");
}

public Action Command_TBWave13(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 13: Grandma Destruction");
}

public Action Command_TBWave14(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 14: Under The Weight");
}

public Action Command_TBWave15(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 15: Metal - Brute Justice Mode");
}

public Action Command_TBWave16(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 16: Exponential Entropy");
}

public Action Command_TBWave17(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 17: Locus");
}

public Action Command_TBWave18(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 18: Torn From The Heavens");
}

public Action Command_TBWave19(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 19: Metal");
}

public Action Command_TBWave20(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 20: Grandma Destruction");
}

public Action Command_TBWave21(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA] \x07FFFFFFWave 21: Battle on the Big Bridge");
}

public Action Command_TacoBellFinished(int args)
{
	PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF YOU HAVE SUCCESSFULLY COMPLETED DOVAH'S ASS - TACO BELL EDITION! THE SERVER WILL RESTART IN 10 SECONDS.");
	CreateTimer(10.0, Timer_RestartServer);
}

//Check who died by what and announce it to chat.
public Action EventDeath(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast)
{
    int client = GetClientOfUserId(Spawn_Event.GetInt("userid"));
    int attacker = GetClientOfUserId(Spawn_Event.GetInt("attacker"));
    char weapon[32];
    Spawn_Event.GetString("weapon", weapon, sizeof(weapon));
    if (0 < client <= MaxClients && IsClientInGame(client))
    {
		int damagebits = Spawn_Event.GetInt("damagebits");
		if ((damagebits & (1 << 0)) && !attacker) //DMG_CRUSH
    	{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was crushed by a \x07AA0000FALLING ROCK FROM OUTER SPACE\x07FFFFFF!", client);
        }

		if ((damagebits & (1 << 3)) && !attacker) //DMG_BURN
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was \x07AA0000MELTED\x07FFFFFF.", client);
		}
		
		if ((damagebits & (1 << 4)) && !attacker) //DMG_VEHICLE (DMG_FREEZE)
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was flattened out by a \x07AA0000TRAIN\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 5)) && !attacker) //DMG_FALL
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was \x07AA0000YEETED OUT INTO ORBIT\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 6)) && !attacker) //DMG_BLAST
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N went \x07AA0000 KABOOM\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 7)) && !attacker) //DMG_CLUB
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N is \x07AA0000CRASHING THE HINDENBURG\x07FFFFFF!!!", client);
		}

		if ((damagebits & (1 << 8)) && !attacker) //DMG_SHOCK
		{
			PrintToChatAll("\x070000AA[\x07AA0000EXTERMINATUS\x070000AA]\x07FFFFFF Client %N has humliated themselves with an \x07AA0000incorrect \x07FFFFFFkey entry!", client);
		}

		if ((damagebits & (1 << 9)) && !attacker) //DMG_SONIC
		{
			PrintToChatAll("\x070000AA[\x07AA0000EXTERMINATUS\x070000AA]\x07FFFFFF Client %N has sacrificed themselves with a \x0700AA00correct \x07FFFFFFkey entry! Prepare your anus!", client);
		}

		if ((damagebits & (1 << 10)) && !attacker) //DMG_ENERGYBEAM
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N has been vaporized by a \x07AA0000HIGH ENERGY PHOTON BEAM\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 14)) && !attacker) //DMG_DROWN
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N \x07AA0000DROWNED\x07FFFFFF.", client);
		}

		if ((damagebits & (1 << 15)) && !attacker) //DMG_PARALYZE
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N has been crushed by a \x070000AAMYSTERIOUS BLUE BALL\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 16)) && !attacker) //DMG_NERVEGAS
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N has been \x07AA0000SLICED TO RIBBONS\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 17)) && !attacker) //DMG_POISON
		{
			ServerCommand("sm_psay %d \x07FF0000[\x0700FF00ADMIN\x07FF0000] \x07AAAAAAPlease don't sit IDLE in the FC Tavern. Repeated offenses may result in a kick.");
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was killed for standing in the Tavern instead of helping their team!", client);
		}

		if ((damagebits & (1 << 18)) && !attacker) //DMG_RADIATION
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N was blown away by a \x07AA0000NUCLEAR EXPLOSION\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 19)) && !attacker) //DMG_DROWNRECOVER
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N experienced \x07AA0000TACO BELL\x07FFFFFF!", client);
		}

		if ((damagebits & (1 << 20)) && !attacker) //DMG_ACID
		{
			PrintToChatAll("\x070000AA[\x07AA0000CORE\x070000AA]\x07FFFFFF Client %N has been crushed by a \x0700AA00FALLING GOOBBUE FROM OUTER SPACE\x07FFFFFF!", client);
		}
	}
    return Plugin_Handled;
}

//Silence cvar changes to minimize chat spam.
public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast)
{
	event.BroadcastDisabled = true;
}

//Announce when we are in danger.
public Action EventWarning(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast)
{
	PrintToChatAll("\x070000AA[\x07AA0000WARN\x070000AA]\x07AA0000 WARNING\x07FFFFFF: \x07AA0000DOVAH'S ASS IS ABOUT TO BE DEPLOYED!!!");
}

//Announce the bomb has been reset by client %N.
public Action EventReset(Event Spawn_Event, const char[] Spawn_Name, bool Spawn_Broadcast)
{
	int client = Spawn_Event.GetInt("player");
	if (0 < client <= MaxClients && IsClientInGame(client))
    {
		PrintToChatAll("\x070000AA[\x0700AA00CORE\x070000AA]\x07FFFFFF Client \x0700AA00%N\x07FFFFFF has reset the ass!", client);
	}
	return Plugin_Handled;
}

//Used by various entities to jump us to the previous wave.
public Action Command_JumpToPrevWave(int args)
{
	int ent = FindEntityByClassname(-1, "tf_objective_resource");
	if(ent == -1)
	{
		LogMessage("tf_objective_resource not found");
		return;
	}

	int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
	int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
	int prev_wave = current_wave - 1;
	if(prev_wave >= max_wave)
    {
		PrintToChatAll("\x07AA0000[ERROR] \x07FFFFFFHOW THE HELL DID WE GET HERE?!");
		return;
	}

	if(prev_wave < 1)
	{
		PrintToChatAll("\x07AA0000[ERROR] \x07FFFFFFWE CAN'T JUMP TO WAVE 0, WHY WOULD YOU TRY THAT??");
		return;
	}
	JumpToWave(prev_wave);
}

//Used by various entities to jump us to the next wave.
public Action Command_JumpToNextWave(int args)
{
	int ent = FindEntityByClassname(-1, "tf_objective_resource");
	if(ent == -1)
	{
		LogMessage("tf_objective_resource not found");
		return;
	}

	int current_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineWaveCount"));
	int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
	int next_wave = current_wave + 1;
	if(next_wave > max_wave)
    {
		ServerCommand("fb_forcevictory");
		return;
	}
	JumpToWave(next_wave);
}

//Jump to the wave.
public Action JumpToWave(int wave_number)
{
	int flags = GetCommandFlags("tf_mvm_jump_to_wave");
	SetCommandFlags("tf_mvm_jump_to_wave", flags & ~FCVAR_CHEAT);
	ServerCommand("tf_mvm_jump_to_wave %d", wave_number);
	FakeClientCommand(0, "");
	SetCommandFlags("tf_mvm_jump_to_wave", flags|FCVAR_CHEAT);
}

//Timer to restart the server.
public Action Timer_RestartServer(Handle timer)
{
	ServerCommand("_restart");
}

//Handle FB Operator Requests via entfire
public Action Command_FBFire(int args)
{
	char arg1[128], arg2[128], arg3[32], arg4[8];
	float flDelay;
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	GetCmdArg(3, arg3, sizeof(arg3));
	GetCmdArg(4, arg4, sizeof(arg4));
	flDelay = StringToFloat(arg4);
	FireEntityInput(arg1, arg2, arg3, flDelay);
	return Plugin_Handled;
}

//Create a temp entity and fire an input
public Action FireEntityInput(char[] strTargetname, char[] strInput, char[] strParameter, float flDelay)
{
	char strBuffer[255];
	Format(strBuffer, sizeof(strBuffer), "OnUser1 %s:%s:%s:%f:1", strTargetname, strInput, strParameter, flDelay);
	PrintToChatAll("\x0700FF00[CORE] \x07FFFFFF Firing entity %s with input %s , a parameter override of %s , and delay of %f ...", strTargetname, strInput, strParameter, flDelay);
	int entity = CreateEntityByName("info_target");
	if(IsValidEdict(entity))
	{
		DispatchSpawn(entity);
		ActivateEntity(entity);
		SetVariantString(strBuffer);
		AcceptEntityInput(entity, "AddOutput");
		AcceptEntityInput(entity, "FireUser1");
		CreateTimer(0.0, DeleteEdict, entity);
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

//Remove edict allocated by temp entity
public Action DeleteEdict(Handle timer, any entity)
{
	if(IsValidEdict(entity)) RemoveEdict(entity);
	return Plugin_Stop;
}