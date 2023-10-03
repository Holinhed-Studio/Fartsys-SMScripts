/*********************************
* Summoner's Chaos Helper Plugin *
*								 *
* Performs background tasks for  *
* FireHostRedux.com 's Summoner  *
* Chaos TF2 Server.              *
**********************************/

//Simple script setup
#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

//Give plugin info
public Plugin:myinfo =
{
	name		=	"Summoner's Chaos [Extended]",
	author		=	"Dovahkiin-Warrior",
	description	=	"Helper plugin for lol_summonerschaos",
	version		=	"1.0.0",
	url			=	"https://forums.firehostredux.com"
};

//Initiate the core, register required commands & Precache and Allocate files
public OnPluginStart()
{	
	PrintToServer("*******WARNING: PLEASE MAKE SURE YOU USE THE MAP THIS PLUGIN IS DESIGNED FOR. YOU HAVE BEEN WARNED."),
	RegAdminCmd("bg_started", Command_BloodGodStarted, ADMFLAG_ROOT, "The Blood God has AWOKEN");
	RegAdminCmd("bg_pre00", Command_BloodGodPRE00, ADMFLAG_ROOT, "Display Pre0x00");
	RegAdminCmd("bg_pre01", Command_BloodGodPRE01, ADMFLAG_ROOT, "Display Pre0x01");
	RegAdminCmd("bg_pre02", Command_BloodGodPRE02, ADMFLAG_ROOT, "Display Pre0x02");
	RegAdminCmd("bg_pre03", Command_BloodGodPRE03, ADMFLAG_ROOT, "Display Pre0x03");
	RegAdminCmd("bg_pre04", Command_BloodGodPRE04, ADMFLAG_ROOT, "Display Pre0x04");
	RegAdminCmd("bg_pre05", Command_BloodGodPRE05, ADMFLAG_ROOT, "Display Pre0x05");
	RegAdminCmd("bg_pre06", Command_BloodGodPRE06, ADMFLAG_ROOT, "Display Pre0x06");
	RegAdminCmd("bg_pre07", Command_BloodGodPRE07, ADMFLAG_ROOT, "Display Pre0x07");
	RegAdminCmd("bg_pre08", Command_BloodGodPRE08, ADMFLAG_ROOT, "Display Pre0x08");
	RegAdminCmd("bg_pre09", Command_BloodGodPRE09, ADMFLAG_ROOT, "Display Pre0x09");
	RegAdminCmd("bg_pre0A", Command_BloodGodPRE0A, ADMFLAG_ROOT, "Display Pre0x0A");
	RegAdminCmd("bg_pre0B", Command_BloodGodPRE0B, ADMFLAG_ROOT, "Display Pre0x0B");
	RegAdminCmd("bg_pre0C", Command_BloodGodPRE0C, ADMFLAG_ROOT, "Display Pre0x0C");
	RegAdminCmd("bg_pre0D", Command_BloodGodPRE0D, ADMFLAG_ROOT, "Display Pre0x0D");
	RegAdminCmd("bg_pre0E", Command_BloodGodPRE0E, ADMFLAG_ROOT, "Display Pre0x0E");
	RegAdminCmd("bg_pre0F", Command_BloodGodPRE0F, ADMFLAG_ROOT, "Display Pre0x0F");
	RegAdminCmd("bg_intr00", Command_BloodGodINTR00, ADMFLAG_ROOT, "Display Intr0x00");
	RegAdminCmd("bg_intr01", Command_BloodGodINTR01, ADMFLAG_ROOT, "Display Intr0x01");
	RegAdminCmd("bg_intr02", Command_BloodGodINTR02, ADMFLAG_ROOT, "Display Intr0x02");
	RegAdminCmd("bg_intr03", Command_BloodGodINTR03, ADMFLAG_ROOT, "Display Intr0x03");
	RegAdminCmd("bg_intr04", Command_BloodGodINTR04, ADMFLAG_ROOT, "Display Intr0x04");
	RegAdminCmd("bg_intr05", Command_BloodGodINTR05, ADMFLAG_ROOT, "Display Intr0x05");
	RegAdminCmd("bg_intr06", Command_BloodGodINTR06, ADMFLAG_ROOT, "Display Intr0x06");
	RegAdminCmd("bg_intr07", Command_BloodGodINTR07, ADMFLAG_ROOT, "Display Intr0x07");
	RegAdminCmd("bg_intr08", Command_BloodGodINTR08, ADMFLAG_ROOT, "Display Intr0x08");
	RegAdminCmd("bg_intr09", Command_BloodGodINTR09, ADMFLAG_ROOT, "Display Intr0x09");
	RegAdminCmd("bg_intr0A", Command_BloodGodINTR0A, ADMFLAG_ROOT, "Display Intr0x0A");
	RegAdminCmd("bg_intr0B", Command_BloodGodINTR0B, ADMFLAG_ROOT, "Display Intr0x0B");
	RegAdminCmd("bg_intr0C", Command_BloodGodINTR0C, ADMFLAG_ROOT, "Display Intr0x0C");
	RegAdminCmd("bg_intr0D", Command_BloodGodINTR0D, ADMFLAG_ROOT, "Display Intr0x0D");
	RegAdminCmd("bg_intr0E", Command_BloodGodINTR0E, ADMFLAG_ROOT, "Display Intr0x0E");
	RegAdminCmd("bg_intr0F", Command_BloodGodINTR0F, ADMFLAG_ROOT, "Display Intr0x0F");
	RegAdminCmd("bg_intr10", Command_BloodGodINTR10, ADMFLAG_ROOT, "Display Intr0x10");
	RegAdminCmd("bg_intr11", Command_BloodGodINTR11, ADMFLAG_ROOT, "Display Intr0x11");
	RegAdminCmd("bg_intr12", Command_BloodGodINTR12, ADMFLAG_ROOT, "Display Intr0x12");
	RegAdminCmd("bg_intr13", Command_BloodGodINTR13, ADMFLAG_ROOT, "Display Intr0x13");
	RegAdminCmd("bg_intr14", Command_BloodGodINTR14, ADMFLAG_ROOT, "Display Intr0x14");
	RegAdminCmd("bg_intr15", Command_BloodGodINTR15, ADMFLAG_ROOT, "Display Intr0x15");
	RegAdminCmd("bg_intr16", Command_BloodGodINTR16, ADMFLAG_ROOT, "Display Intr0x16");
	RegAdminCmd("bg_intr17", Command_BloodGodINTR17, ADMFLAG_ROOT, "Display Intr0x17");
	RegAdminCmd("bg_post00", Command_BloodGodPOST00, ADMFLAG_ROOT, "Display Post0x00");
	RegAdminCmd("bg_post01", Command_BloodGodPOST01, ADMFLAG_ROOT, "Display Post0x01");
	RegAdminCmd("bg_post02", Command_BloodGodPOST02, ADMFLAG_ROOT, "Display Post0x02");
	RegAdminCmd("bg_post03", Command_BloodGodPOST03, ADMFLAG_ROOT, "Display Post0x03");
	RegAdminCmd("bg_post04", Command_BloodGodPOST04, ADMFLAG_ROOT, "Display Post0x04");
	RegAdminCmd("bg_post05", Command_BloodGodPOST05, ADMFLAG_ROOT, "Display Post0x05");
	RegAdminCmd("bg_post06", Command_BloodGodPOST06, ADMFLAG_ROOT, "Display Post0x06");
	RegAdminCmd("bg_post07", Command_BloodGodPOST07, ADMFLAG_ROOT, "Display Post0x07");
	RegAdminCmd("bg_post08", Command_BloodGodPOST08, ADMFLAG_ROOT, "Display Post0x08");
	RegAdminCmd("bg_post09", Command_BloodGodPOST09, ADMFLAG_ROOT, "Display Post0x09");
	RegAdminCmd("bg_post0A", Command_BloodGodPOST0A, ADMFLAG_ROOT, "Display Post0x0A");
	RegAdminCmd("bg_post0B", Command_BloodGodPOST0B, ADMFLAG_ROOT, "Display Post0x0B");
	RegAdminCmd("bg_post0C", Command_BloodGodPOST0C, ADMFLAG_ROOT, "Display Post0x0C");
	RegAdminCmd("bg_post0D", Command_BloodGodPOST0D, ADMFLAG_ROOT, "Display Post0x0D");
	RegAdminCmd("bg_post0E", Command_BloodGodPOST0E, ADMFLAG_ROOT, "Display Post0x0E");
	RegAdminCmd("bg_post0F", Command_BloodGodPOST0F, ADMFLAG_ROOT, "Display Post0x0F");
	RegAdminCmd("bg_post10", Command_BloodGodPOST10, ADMFLAG_ROOT, "Display Post0x10");
	RegAdminCmd("bg_lasergod", Command_BloodGodLASERGOD, ADMFLAG_ROOT, "The Laser God is ANGRY!");
	RegAdminCmd("bg_meteors", Command_BloodGodMETEORS, ADMFLAG_ROOT, "Meteors are falling from the sky!");
	RegAdminCmd("bg_mixedbag", Command_BloodGodMIXEDBAG, ADMFLAG_ROOT, "It's a mixed bag!");
	RegAdminCmd("bg_storm", Command_BloodGodSTORM, ADMFLAG_ROOT, "Zeus' wrath shall be heard by all!");
}

public Action:Command_BloodGodStarted(client, args)
{
	PrintToChatAll("\x07880000 OOF, WHO SUMMONED THE BLOOD GOD??!!");
}

public Action:Command_BloodGodPRE00(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre00: Tvangeste - Birth of the Hero");
}

public Action:Command_BloodGodPRE01(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre01: Skillet - Hero");
}

public Action:Command_BloodGodPRE02(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre02: Crimson Glory - Queen of the Masquerade");
}

public Action:Command_BloodGodPRE03(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre03: Apostasy - Sulphurinjection");
}

public Action:Command_BloodGodPRE04(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre04: RichaadEB, LittleVMills - Devil Trigger (FULL VERSION)");
}

public Action:Command_BloodGodPRE05(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre05: Powerwolf - Sanctified with Dynamite");
}

public Action:Command_BloodGodPRE06(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre06: Powerwolf - Stossgebet");
}

public Action:Command_BloodGodPRE07(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre07: Wind Rose - Diggy Diggy Hole");
}

public Action:Command_BloodGodPRE08(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre08: Powerwolf - Incense and Iron");
}

public Action:Command_BloodGodPRE09(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre09: Skillet - Whispers in the Dark");
}

public Action:Command_BloodGodPRE0A(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre0A: Undercode - Freedom");
}

public Action:Command_BloodGodPRE0B(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre0B: Alestorm - Wolves of the Sea");
}

public Action:Command_BloodGodPRE0C(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre0C: Disturbed - The Game");
}

public Action:Command_BloodGodPRE0D(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre0D: Avenged Sevenfold - Doing Time");
}

public Action:Command_BloodGodPRE0E(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre0E: Alestorm - 1741: The Battle of Cartagena");
}

public Action:Command_BloodGodPRE0F(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008800Pre0F: KISS - Rock n Roll All Night");
}

public Action:Command_BloodGodINTR00(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr00: DMC5 - Nero");
}

public Action:Command_BloodGodINTR01(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr01: Tyler2shots");
}

public Action:Command_BloodGodINTR02(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr02: JoeyGhost");
}

public Action:Command_BloodGodINTR03(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr03: JoeyGhost");
}

public Action:Command_BloodGodINTR04(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr04: DMC5 - Nero");
}

public Action:Command_BloodGodINTR05(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr05: Shrek");
}

public Action:Command_BloodGodINTR06(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr06: DMC5 - Nero");
}

public Action:Command_BloodGodINTR07(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr07: Wind Rose");
}

public Action:Command_BloodGodINTR08(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr08: DDO - Kobold Foreman Wee Yip Yip");
}

public Action:Command_BloodGodINTR09(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr09: Sandy Cheeks");
}

public Action:Command_BloodGodINTR0A(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr0A: JoeyGhost");
}

public Action:Command_BloodGodINTR0B(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr0B: DovahkiWarrior");
}

public Action:Command_BloodGodINTR0C(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr0C: Patrick Star");
}

public Action:Command_BloodGodINTR0D(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr0D: Ancestral Spartan");
}

public Action:Command_BloodGodINTR0E(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr0E: Spongebob Squarepants");
}

public Action:Command_BloodGodINTR0F(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr0F: DMC5 - Nero");
}

public Action:Command_BloodGodINTR10(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr10: DMC5 - Nero");
}

public Action:Command_BloodGodINTR11(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr11: Wyvernspur");
}

public Action:Command_BloodGodINTR12(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr12: Wyvernspur");
}

public Action:Command_BloodGodINTR13(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr13: Bethesda - Skyrim Trailer");
}

public Action:Command_BloodGodINTR14(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr14: DovahkiWarrior / Ahricups");
}

public Action:Command_BloodGodINTR15(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr15: DovahkiWarrior");
}

public Action:Command_BloodGodINTR16(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr16: Deathwatch - Froggy Cruelty");
}

public Action:Command_BloodGodINTR17(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07000088Intr17: DMC5 - Nero");
}

public Action:Command_BloodGodPOST00(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post00: Tvangeste - Birth of the Hero");
}

public Action:Command_BloodGodPOST01(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post01: Skillet - Hero");
}

public Action:Command_BloodGodPOST02(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post02: Crimson Glory - Queen of the Masquerade");
}

public Action:Command_BloodGodPOST03(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post03: Apostasy - Sulphurinjection");
}

public Action:Command_BloodGodPOST04(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post04: RichaadEB, LittleVMills - Devil Trigger (FULL VERSION)");
}

public Action:Command_BloodGodPOST05(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post05: Powerwolf - Sanctified with Dynamite");
}

public Action:Command_BloodGodPOST06(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post06: Powerwolf - Stossgebet");
}

public Action:Command_BloodGodPOST07(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post07: Wind Rose - Diggy Diggy Hole");
}

public Action:Command_BloodGodPOST08(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post08: Powerwolf - Incense and Iron");
}

public Action:Command_BloodGodPOST09(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post09: Skillet - Whispers in the Dark");
}

public Action:Command_BloodGodPOST0A(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post0A: Skillet - Hero");
}

public Action:Command_BloodGodPOST0B(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post0B: Alestorm - Captain Morgan's Revenge");
}

public Action:Command_BloodGodPOST0C(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post0C: Disturbed - The Game");
}

public Action:Command_BloodGodPOST0D(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post0D: Children of Bodom - Angels Don't Kill");
}

public Action:Command_BloodGodPOST0E(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post0E: Powerwolf - Raise Your Fist, Evangelist");
}

public Action:Command_BloodGodPOST0F(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880088Post0F: KISS - Rock and Roll All Night");
}

public Action:Command_BloodGodPOST10(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07880000Uh oh, it looks like MEME CHAN is here! RUUUUUUUUUUNNNNNNNNNNNNNNN!!!");
}

public Action:Command_BloodGodLASERGOD(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008888*** I'MMA FIRIN' MA LAZ0R!!! ***");
}
	
public Action:Command_BloodGodMETEORS(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008888*** METEORS ARE RAINING FROM THE SKY ***");
}

public Action:Command_BloodGodMIXEDBAG(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008888*** IT'S A MIXED BAG! ***");
}

public Action:Command_BloodGodSTORM(client, args)
{
	PrintToChatAll("\x07000088[\x07880088Chaos Engine\x07000088] \x07008888*** ZEUS' WRATH SHALL BE HEARD BY ALL!!! ***");
}