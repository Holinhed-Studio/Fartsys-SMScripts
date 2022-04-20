// File Name : LOLSound.inc
// File Version : 1.3
// File Updated date : 08-10-2013

/*
 *게렛의 택티컬 건모드2의 TGM2sound.inc을 참고(배껴서..)만든 include 파일
 */
#if defined _LOLsound_included
#endinput
#endif
#define _LOLsound_included

//소리파일의 경로와 소리 관련 상수에 대한 정의는 이곳에 온다

#define TOTALSOUND 53

//인수로 받는 소리
#define SOUNDFIRSTBLOOD 0
#define SOUNDALLYSLAIN1 1
#define SOUNDALLYSLAIN2 2
#define SOUNDENEMYSLAIN1 3
#define SOUNDENEMYSLAIN2 4
#define SOUNDENEMYSLAIN3 5
#define SOUNDYOUSLAIN1 6
#define SOUNDYOUSLAIN2 7
#define SOUNDEXECUTED 8
#define SOUNDYOUVESLAIN1 9
#define SOUNDYOUVESLAIN2 10
#define SOUNDYOUVESLAIN3 11
#define SOUNDACE1 12
#define SOUNDACE2 13
#define SOUNDENEMYDOUBLEKILL1 14
#define SOUNDENEMYDOUBLEKILL2 15
#define SOUNDDOUBLEKILL1 16
#define SOUNDDOUBLEKILL2 17
#define SOUNDDOUBLEKILL3 18
#define SOUNDENEMYTRIPLEKILL1 19
#define SOUNDENEMYTRIPLEKILL2 20
#define SOUNDTRIPLEKILL1 21
#define SOUNDTRIPLEKILL2 22
#define SOUNDENEMYQUADRAKILL 23
#define SOUNDQUADRAKILL1 24
#define SOUNDQUADRAKILL2 25
#define SOUNDENEMYPENTAKILL1 26
#define SOUNDENEMYPENTAKILL2 27
#define SOUNDPENTAKILL1 28
#define SOUNDPENTAKILL2 29
#define SOUNDSHUTDOWN 30
#define SOUNDENEMYKILLINGSPREE1 31
#define SOUNDENEMYKILLINGSPREE2 32
#define SOUNDKILLINGSPREE1 33
#define SOUNDKILLINGSPREE2 34
#define SOUNDENEMYRAMPAGE 35
#define SOUNDRAMPAGE1 36
#define SOUNDRAMPAGE2 37
#define SOUNDENEMYUNSTOPPABLE1 38
#define SOUNDENEMYUNSTOPPABLE2 39
#define SOUNDUNSTOPPABLE 40
#define SOUNDENEMYDOMINATING 41
#define SOUNDDOMINATING 42
#define SOUNDENEMYGODLIKE1 43
#define SOUNDENEMYGODLIKE2 44
#define SOUNDGODLIKE1 45
#define SOUNDGODLIKE2 46
#define SOUNDENEMYLEGENDARY1 47
#define SOUNDENEMYLEGENDARY2 48
#define SOUNDLEGENDARY1 49
#define SOUNDLEGENDARY2 50
#define SOUNDLEGENDARY3 51
#define SOUNDSERVERJOIN 52

new String:sounddata[TOTALSOUND][128] =
{
	{"LOLannounce_v3/female1_OnFirstBlood_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillHeroHero.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillHeroHero_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillHeroHero_2.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillHeroHero_5.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillHeroHero_7.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillHeroYouE.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillHeroYouE_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillTurretHe_4.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillYouHeroY.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillYouHeroY_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionKillYouHeroY_2.mp3"},
	{"LOLannounce_v3/female1_OnAce_1.mp3"},
	{"LOLannounce_v3/female1_OnAce_2.mp3"},
	{"LOLannounce_v3/female1_OnChampionDoubleKillEn.mp3"},
	{"LOLannounce_v3/female1_OnChampionDoubleKillEn_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionDoubleKillYo.mp3"},
	{"LOLannounce_v3/female1_OnChampionDoubleKillYo_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionDoubleKillYo_2.mp3"},
	{"LOLannounce_v3/female1_OnChampionTripleKillEn.mp3"},
	{"LOLannounce_v3/female1_OnChampionTripleKillEn_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionTripleKillYo.mp3"},
	{"LOLannounce_v3/female1_OnChampionTripleKillYo_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionQuadraKillEn.mp3"},
	{"LOLannounce_v3/female1_OnChampionQuadraKillYo.mp3"},
	{"LOLannounce_v3/female1_OnChampionQuadraKillYo_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionPentaKillEne.mp3"},
	{"LOLannounce_v3/female1_OnChampionPentaKillEne_1.mp3"},
	{"LOLannounce_v3/female1_OnChampionPentaKillYou.mp3"},
	{"LOLannounce_v3/female1_OnChampionPentaKillYou_1.mp3"},
	{"LOLannounce_v3/female1_OnKilledUnitOnKillingS.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet1Enem.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet1Enem_1.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet1Your.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet1Your_1.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet2Enem.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet2Your.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet2Your_1.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet3Enem.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet3Enem_1.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet3Your.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet4Enem.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet4Your.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet5Enem.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet5Enem_1.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet5Your.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet5Your_1.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet6Enem.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet6Enem_1.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet6Your.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet6Your_1.mp3"},
	{"LOLannounce_v3/female1_OnKillingSpreeSet6Your_2.mp3"},
	{"LOLannounce_v3/ServerJoinSound.mp3"}
};

//함수들
stock prepatch_and_download_sounds()
{
	new String:prepatch_gamename[64];
	GetGameFolderName(prepatch_gamename, sizeof(prepatch_gamename));
	//소리 프리패치, 쓰이는 모든 소리를 프리패치하고 다운한다.
	for(new i = 0; i < TOTALSOUND; i++){
		
		new String:downtemp[256];
		if(StrEqual(prepatch_gamename, "csgo"))
		{
			Format(downtemp, sizeof(downtemp), "music/%s", sounddata[i]);
			PrecacheSound(sounddata[i], true);
			Format(downtemp, sizeof(downtemp), "sound/music/%s", sounddata[i]);
		}
		else
		{
			PrecacheSound(sounddata[i], true);
			Format(downtemp, sizeof(downtemp), "sound/%s", sounddata[i]);
		}
		AddFileToDownloadsTable(downtemp);
	}
}

stock playsoundfromclient(client, sound){

	EmitSoundToClient(client, sounddata[sound], SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, _, volumeValue[client]);
	
}