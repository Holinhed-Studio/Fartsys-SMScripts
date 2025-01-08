public char PLUGIN_VERSION[8] = "8.0.0";
void sudo(int task) {
  AssLogger(LOGLVL_DEBUG, "Calling sudo with %i", task);
  switch (task) {
    //When the map is complete
    case 0: {
      CPrintToChatAll(core.tacobell ? "WOWIE YOU DID IT! The server will restart in 30 seconds, prepare to do it again! LULW" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}YOU HAVE SUCCESSFULLY COMPLETED PROF'S ASS ! THE SERVER WILL RESTART IN 10 SECONDS.");
      CreateTimer(10.0, TimedOperator, 100);
    }
    //Prepare yourself!
    case 1: {
      core.tacobell = false;
      ServerCommand("fb_startmoney 50000");
      CPrintToChatAll("{darkviolet}[{yellow}INFO{darkviolet}] {red}PROFESSOR'S ASS {white}v0x20 (Core-v%s). Prepare yourself for the unpredictable... [{limegreen}by TTV/ProfessorFartsalot{white}]", PLUGIN_VERSION);
      FastFire2("rain", "Alpha", "0", 0.0, false);
    }
    //Wave init
    case 2: {
      core.curWave = GetCurWave();
      PerformWaveSetup();
      float hwn = GetRandomFloat(core.HWNMin, core.HWNMax);
      CreateTimer(hwn, HWBosses);
      AudioManager.ChangeBGM(core.tacobell ? tacoBellBGMIndex[core.curWave] : DefaultsArray[core.curWave].defBGMIndex);
      return;
    }
  //Force Tornado
  case 3: {
    if (core.isWave && WeatherManager.canTornado && !WeatherManager.hasTornado) {
      CreateTimer(0.1, TimedOperator, 41);
      PrintCenterTextAll("OH NOES... PREPARE YOUR ANUS!");
    } else PrintToServer("Error spawning manual tornado... Perhaps we are not in a wave, tornadoes are banished, or a tornado has already spawned???");
    return;
  }
  //Signal that previous boss should spawn.
  case 4: {
    core.waveFlags--;
  }
  //Signal that a boss should spawn
  case 5: {
    if (core.waveFlags < 0) core.waveFlags = 0;
    switch (core.waveFlags) {
    case 0: {
      PrintToChatAll("Caught unhandled exception: core.waveFlags 0 but operator 5 was invoked.");
      return;
    }
    case 1: {
      FastFire2("FB.OnslaughterBase", "SetModelScale", "0.19", 0.0, false);
      FastFire2("FB.BruteJusticeTrain", "TeleportToPathTrack", "tank_path_a_10", 0.0, false);
      FastFire2("FB.BruteJustice", "Enable", "", 3.0, false);
      FastFire2("FB.BruteJusticeTrain", "StartForward", "", 3.0, false);
      FastFire2("FB.BruteJusticeParticles", "Start", "", 3.0, false);
      CreateTimer(5.0, OnslaughterATK);
      FastFire2("tank_boss", "AddOutput", "rendermode 10", 3.0, false);
      FastFire2("tank_boss", "AddOutput", "rendermode 10", 7.0, false);
      CreateTimer(10.0, BossHPTimer);
    }
    case 2: {
      FastFire2("FB.Sephiroth", "Enable", "", 0.0, false);
      FastFire2("SephMeteor", "SetParent", "FB.Sephiroth", 0.0, false);
      FastFire2("SephTrain", "SetSpeedReal", "12", 0.0, false);
      FastFire2("SephTrain", "TeleportToPathTrack", "Seph01", 0.0, false);
      FastFire2("SephTrain", "StartForward", "", 0.1, false);
      FastFire2("SephTrain", "SetSpeedReal", "12", 20.5, false);
      FastFire2("FB.SephParticles", "Start", "", 3.0, false);
      FastFire2("tank_boss", "AddOutput", "rendermode 10", 3.0, false);
      FastFire2("tank_boss", "AddOutput", "rendermode 10", 7.0, false);
      FastFire2("FB.BruteJusticeDMGRelay", "Kill", "", 0.0, false);
      switch (GetClientCount(true)) {
      case 1: {
        FastFire2("SephTrain", "SetSpeedReal", "40", 23.0, false);
        FastFire2("tank_boss", "SetHealth", "409600", 1.0, false);
        FastFire2("FB.SephDMGRelay", "SetHealth", "32768000", 1.0, false);
      }
      case 2: {
        FastFire2("SephTrain", "SetSpeedReal", "35", 23.0, false);
        FastFire2("tank_boss", "SetHealth", "614400", 1.0, false);
        FastFire2("FB.SephDMGRelay", "SetHealth", "32768000", 1.0, false);
      }
      case 3: {
        FastFire2("SephTrain", "SetSpeedReal", "35", 23.0, false);
        FastFire2("tank_boss", "SetHealth", "614400", 1.0, false);
        FastFire2("FB.SephDMGRelay", "SetHealth", "131072000", 1.0, false);
      }
      case 4: {
        FastFire2("SephTrain", "SetSpeedReal", "30", 23.0, false);
        FastFire2("tank_boss", "SetHealth", "819200", 1.0, false);
        FastFire2("FB.SephDMGRelay", "SetHealth", "262144000", 1.0, false);
      }
      case 5, 6, 7, 8, 9, 10: {
        FastFire2("SephTrain", "SetSpeedReal", "25", 23.0, false);
        FastFire2("tank_boss", "SetHealth", "819200", 1.0, false);
        FastFire2("FB.SephDMGRelay", "SetHealth", "655360000", 1.0, false);
      }
      }
      CreateTimer(30.0, BossHPTimer);
    }
    }
  }
  //Signal that next boss should spawn
  case 6: {
    core.waveFlags++;
  }
  //Signal to fastforward boss spawn.
  case 7: {
    core.waveFlags = 2;
    if (core.curWave == 8 && !core.tacobell) {
      sudo(1001);
      CreateTimer(0.0, TimedOperator, 8);
    }
  }
  //When a tornado intersects a tank.
  case 8: {
    FastFire2("FB.FakeTankSpawner", "ForceSpawn", "", 0.1, false);
  }
  //Client was Sacrificed.
  case 10: {
    core.sacrificedByClient = true;
  }
  //Damage relay took damage
  case 11: {
    FastFire2("TankRelayDMG", "Enable", "", 0.0, false);
    FastFire2("TankRelayDMG", "Disable", "", 0.5, false);
  }
  //dmg relay was killed
  case 12: {
    FastFire2("tank_boss", "SetHealth", "1", 0.0, false);
    FastFire2("TankRelayDMG", "Enable", "", 0.1, false);
    FastFire2("TankRelayDMG", "Enable", "", 0.5, false);
    FastFire2("TankRelayDMG", "Enable", "", 1.0, false);
    FastFire2("TankRelayDMG", "Disable", "", 60.0, false);
  }
  //Tank Destroyed (+1), includes disabling onslaughter.
  case 13: {
    switch (core.waveFlags) {
    case 0: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A tank has been destroyed. ({limegreen}+1 pt{white})");
      core.sacPoints++;
    }
    case 1: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}ONSLAUGHTER {white}has been destroyed. ({limegreen}+25 pts{white})");
      FastFire2("TankRelayDMG", "Enable", "", 1.0, false);
      FastFire2("TankRelayDMG", "Disable", "", 60.0, false);
      FastFire2("FB.BruteJustice", "Disable", "", 0.0, false);
      FastFire2("FB.BruteJusticeTrain", "Stop", "", 0.0, false);
      FastFire2("FB.BruteJusticeParticles", "Stop", "", 0.0, false);
      FastFire2("FB.BruteJusticeDMGRelay", "Break", "", 0.0, false);
      FastFire2("FB.BruteJusticeTrain", "TeleportToPathTrack", "tank_path_a_10", 0.5, false);
      core.waveFlags = 0;
      core.sacPoints += 25;
    }
    case 2: {
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {red}SEPHIROTH {white}has been destroyed. ({limegreen}+100 pts{white})");
      FastFire2("TankRelayDMG", "Enable", "", 1.0, false);
      FastFire2("TankRelayDMG", "Disable", "", 60.0, false);
      FastFire2("FB.Sephiroth", "Disable", "", 0.0, false);
      FastFire2("SephTrain", "TeleportToPathTrack", "Seph01", 0.0, false);
      FastFire2("SephTrain", "Stop", "", 0.0, false);
      core.canSephNuke = false;
      core.sacPoints += 100;
      core.waveFlags = 0;
      WeatherManager.canTornado = false;
    }
    }
    return;
  }
  //Bomb Reset (+5)
  case 14: {
    core.bombReset = true;
    core.sacPoints += 5;
  }
  //Bomb Deployed
  case 15: {
    FastFire2("FB.PayloadWarning", "Disable", "", 0.0, false);
    if (!core.isWave) return;
    if (bombState[0].state == 69) {
      bombState[7].explode(false);
      bombState[0].stateMax = 64;
      CreateTimer(5.0, TimedOperator, 99);
    }
    bombState[bombState[0].getCurBomb()].explode(true);
    bombState[0].stateMax += 10;
    if (bombState[0].state >= bombState[0].stateMax) return;
    else bombState[0].state += 2;
    return;
  }
  //Tank deployed its bomb
  case 16: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A tank has deployed its bomb! ({limegreen}+1 pt{white})");
  }
  //Shark Enable & notify bomb push began
  case 20: {
    bombState[0].isMoving = true;
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Bomb push in progress.");
    FastFire2("FB.PayloadWarning", "Enable", "", 0.0, false);
    CreateTimer(3.0, SharkTimer);
  }
  //Shark Disable
  case 21: {
    bombState[0].isMoving = false;
    core.canSENTShark = false;
  }
  //HINDENBOOM ACTIVATION
  case 28: {
    EmitSoundToAll(SFXArray[5].realPath);
    FastFire2("HindenTrain", "StartForward", "", 0.0, false);
    FastFire2("DeliveryBurg", "Lock", "", 0.0, false);
    FastFire2("Boom", "Enable", "", 0.0, false);
    FastFire2("Bombs.TheHindenburg", "Enable", "", 0.0, false);
    FastFire2("Boom", "Disable", "", 1.0, false);
  }
  //HINDENBOOM!!!
  case 29: {
    CPrintToChatAll("{darkviolet}[{red}CORE{darkviolet}] {white}OH GOD, THEY'RE {red}CRASHING THE HINDENBURG{white}!!!");
    EmitSoundToAll(SFXArray[36].realPath);
    CreateTimer(4.0, TimedOperator, 21);
    CreateTimer(7.0, TimedOperator, 37);
    FastFire2("LargeExplosion", "Explode", "", 7.0, false);
    FastFire2("LargeExploShake", "StartShake", "", 7.0, false);
    FastFire2("NukeAll", "Enable", "", 7.0, false);
    FastFire2("FB.Fade", "Fade", "", 7.0, false);
    FastFire2("NukeAll", "Disable", "", 9.0, false);
    FastFire2("Bombs.TheHindenburg", "Disable", "", 7.0, false);
    FastFire2("HindenTrain", "TeleportToPathTrack", "Hinden01", 7.0, false);
    FastFire2("HindenTrain", "Stop", "", 7.0, false);
    CreateTimer(8.0, TimedOperator, 99);
    bombState[0].state = 4;
    bombState[0].stateMax = 8;
  }
  //Bath Salts spend
  case 30: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}INSTANT BATH SALT DETONATION! BOTS ARE FROZEN FOR 10 SECONDS! ({red}-10 pts{white})");
    ServerCommand("sm_freeze @blue 10");
    core.sacPoints -= 10;
    bombState[3].explode(false);
  }
  //Goob/Kirb spend
  case 31: {
    int i = GetRandomInt(1, 2);
    if (i == 1) CreateTimer(1.5, TimedOperator, 21);
    FastFire2(i == 1 ? "FB.GiantGoobTemplate" : "FB.BlueKirbTemplate", "ForceSpawn", "", 0.0, false);
    CPrintToChatAll(i == 1 ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}GOOBBUE COMING IN FROM ORBIT! ({red}-20 pts{white})" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}BLUE KIRBY FALLING OUT OF THE SKY! ({red}-20 pts{white})");
    CustomSoundEmitter(i == 1 ? SFXArray[51].realPath : SFXArray[21].realPath, 65, false, 0, 1.0, 100);
    core.sacPoints -= 20;
  }
  //35K ubup cash spend
  case 32: {
    if (!core.doFailsafe) {
      core.doFailsafe = true;
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave fail-safe activated! ({red}-30 pts{white})");
      core.sacPoints -= 30;
    } else return;
  }
  //Explosive paradise spend
  case 33: {
    CustomSoundEmitter(SFXArray[10].realPath, 65, false, 0, 1.0, 100);
    FastFire2("FB.FadeBLCK", "Fade", "", 0.0, false);
    ServerCommand("sm_evilrocket @blue");
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}We're spending most our lives living in an EXPLOSIVE PARADISE! Robots will be launched into orbit, too! ({red}-40 pts{white})");
    //Add this to explosion array?
    FastFire2("NukeAll", "Enable", "", 11.50, false);
    FastFire2("HUGEExplosion", "Explode", "", 11.50, false);
    FastFire2("FB.Fade", "Fade", "", 11.50, false);
    FastFire2("FB.ShakeBOOM", "StartShake", "", 11.50, false);
    FastFire2("NukeAll", "Disable", "", 12.30, false);
    core.sacPoints -= 40;
  }
  //Banish Tornadoes
  case 34: {
    if (WeatherManager.canTornado && !WeatherManager.hasTornado) core.sacPoints -= 50;
    CPrintToChatAll(WeatherManager.canTornado && !WeatherManager.hasTornado ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}A PINK KIRBY HAS BANISHED TORNADOES FOR THIS WAVE! ({red}-50 pts{white})" : !WeatherManager.canTornado ? "{red}TTV/professorfartsalot {white}: Please do not, the tornado button. Thanks. ({red} -0 pts{white})" : "{red}TTV/professorfartsalot {white}:  You fool. It is much too late for you. ({red} -0 pts{white})");
    WeatherManager.canTornado = !WeatherManager.hasTornado ? false : true;
    WeatherManager.Dissipate();
  }
  //Ass Gas spend
  case 35: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}ANYTHING BUT THE ASS GAS!!!! ({red}-60 pts{white})");
    core.sacPoints -= 60;
    FastFire2("HurtAll", "AddOutput", "damagetype 524288", 0.0, false);
    FastFire2("FB.ShakeBOOM", "StartShake", "", 0.1, false);
    FastFire2("HurtAll", "AddOutput", "damage 400", 0.0, false);
    FastFire2("HurtAll", "Enable", "", 0.1, false);
    FastFire2("HurtAll", "Disable", "", 4.1, false); //Add a sound to this in the future. Maybe gas sound from gbombs? Maybe custom fart sounds? hmm....
    FastFire2("FB.ShakeBOOM", "StopShake", "", 4.1, false);
  }
  //Nuclear fallout spend
  case 36: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}INSTANT FAT MAN DETONATION! ({red}-70 pts{white})");
    core.sacPoints -= 70;
    bombState[7].explode(false);
  }
  //Meteor shower spend
  case 37: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}COSMIC DEVASTATION IMMINENT. ({red}-80 pts{white})");
    core.sacPoints -= 80;
    core.canSENTMeteors = true;
    CreateTimer(1.0, SENTMeteorTimer);
    CreateTimer(30.0, TimedOperator, 12);
  }
  //300K UbUp Cash
  case 38: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}150K UbUp Cash Granted to {red}RED{white}! ({red}-90 pts{white})");
    core.sacPoints -= 90;
    ServerCommand("sm_addcash @red 300000");
  }
  //Fartsy of the Seventh Taco Bell
  case 39: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}NOW PRESENTING... PROFESSOR FARTSALOT OF THE SEVENTH TACO BELL! ({red}-100 points{white})");
    core.sacPoints -= 100;
    bombState[0].stateMax = 69;
    bombState[0].state = 69;
    FastFire2("Delivery", "Unlock", "", 0.0, false);
    FastFire2("BombExplo*", "Disable", "", 0.0, false);
    FastFire2("Bombs*", "Disable", "", 0.0, false);
    FastFire2("Bombs.Professor", "Enable", "", 3.0, false);
  }
  //Found blue ball
  case 40: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}What on earth IS that? It appears to be a... \x075050FFBLUE BALL{white}!");
    CustomSoundEmitter(SFXArray[21].realPath, 65, false, 0, 1.0, 100);
    FastFire2("FB.BlueKirbTemplate", "ForceSpawn", "", 4.0, false);
    CreateTimer(4.0, TimedOperator, 21);
  }
  //Found burrito
  case 41: {
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Why would you even eat {red}The Forbidden Burrito{white}?");
    CustomSoundEmitter("vo/sandwicheat09.mp3", 65, false, 0, 1.0, 100);
    FastFire2("HurtAll", "AddOutput", "damagetype 8", 0.0, false);
    FastFire2("HurtAll", "AddOutput", "damage 2000", 0.0, false);
    FastFire2("HurtAll", "Enable", "", 4.0, false);
    FastFire2("HurtAll", "Disable", "", 8.0, false);
  }
  //Found goobbue
  case 42: {
    isGoobbue = true;
    CustomSoundEmitter(SFXArray[51].realPath, 65, false, 0, 1.0, 100);
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}ALL HAIL \x07FF00FFGOOBBUE{forestgreen}!");
    CreateTimer(4.0, TimedOperator, 21);
    FastFire2("FB.GiantGoobTemplate","ForceSpawn", "", 4.0, false);
  }
  //Found Mario
  case 43: {
    CustomSoundEmitter(SFXArray[52].realPath, 65, false, 0, 1.0, 100);
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Welp, someone is playing \x0700FF00Mario{white}...");
  }
  //Found Waffle
  case 44: {
    CustomSoundEmitter(SFXArray[53].realPath, 65, false, 0, 1.0, 100);
    CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {forestgreen}Oh no, someone has found and (probably) consumed a {red}WAFFLE OF MASS DESTRUCTION{white}!");
    //Yup, another one for the explosion array
    FastFire2("HurtAll", "AddOutput", "damagetype 262144", 10.0, false);
    FastFire2("HurtAll", "AddOutput", "damage 2000000", 0.0, false);
    FastFire2("ShakeBOOM", "StartShake", "", 10.3, false);
    FastFire2("HUGEExplosion", "Explode", "", 10.3, false);
    FastFire2("FB.Fade", "Fade", "", 10.3, false);
    FastFire2("HurtAll", "Enable", "", 10.3, false);
    FastFire2("HurtAll", "Disable", "", 12.3, false);
  }
  //Medium Explosion (defined again, but we aren't using a bomb this time)
  case 51: {
    CustomSoundEmitter(SFXArray[3].realPath, 65, false, 0, 1.0, 100);
  }
  //Probably for the hindenburg... EDIT: NOPE. THIS IS FOR KIRB LANDING ON THE GROUND
  case 52: {
    EmitSoundToAll(SFXArray[35].realPath);
    FastFire2("FB.BOOM", "StartShake", "", 0.0, false);
    FastFire2("BlueBall*", "Kill", "", 0.0, false);
    FastFire2("HUGEExplosion", "Explode", "", 0.0, false);
    FastFire2("BlueKirb", "Kill", "", 0.0, false);
    FastFire2("HurtAll", "AddOutput", "damagetype 32768", 0.0, false);
    FastFire2("HurtAll", "AddOutput", "damage 777777.777", 0.0, false);
    FastFire2("HurtAll", "Enable", "", 0.1, false);
    FastFire2("HurtAll", "Disable", "", 2.1, false);
    isGoobbue = false;
  }
  //Giant Goobbue
  case 53: {
    EmitSoundToAll(SFXArray[35].realPath);
    FastFire2("FB.BOOM", "StartShake", "", 0.0, false);
    FastFire2("GiantGoob*", "Kill", "", 0.0, false);
    FastFire2("HUGEExplosion", "Explode", "", 0.0, false);
    FastFire2("HurtAll", "AddOutput", "damagetype 1048576", 0.0, false);
    FastFire2("HurtAll", "AddOutput", "damage 777777.777", 0.0, false);
    FastFire2("HurtAll", "Enable", "", 0.1, false);
    FastFire2("HurtAll", "Disable", "", 2.1, false);
  }
  //Prev wave
  case 98: {
    int prev_wave = GetCurWave() - 1;
    if (prev_wave < 1) return;
    JumpToWave(prev_wave);
  }
  //Next wave
  case 99: {
    int ent = FindEntityByClassname(-1, "tf_objective_resource");
    if (ent == -1) {
      LogMessage("tf_objective_resource not found");
      return;
    }
    int max_wave = GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nMannVsMachineMaxWaveCount"));
    int next_wave = GetCurWave() + 1;
    if (next_wave > max_wave) {
      int flags = GetCommandFlags("tf_mvm_force_victory");
      SetCommandFlags("tf_mvm_force_victory", flags & ~FCVAR_CHEAT);
      ServerCommand("tf_mvm_force_victory 1");
      FakeClientCommand(0, ""); //Not sure why, but this has to be here. Otherwise the specified commands simply refuse to work...
      SetCommandFlags("tf_mvm_force_victory", flags | FCVAR_CHEAT);
      CPrintToChatAll("{darkviolet}[{forestgreen}CORE{darkviolet}] {white}VICTORY HAS BEEN FORCED! THE SERVER WILL RESTART IN 10 SECONDS.");
      CreateTimer(10.0, TimedOperator, 100);
      return;
    }
    JumpToWave(next_wave);
  }
  //Code Entry from FC Keypad
  case 100: {
    if (core.CodeEntry == 17) {
      FastFire2("FB.BOOM", "StartShake", "", 0.0, false);
      CustomSoundEmitter(SFXArray[3].realPath, 65, false, 0, 1.0, 100);
      FastFire2("FB.CodeCorrectKill", "Enable", "", 0.0, false);
      FastFire2("FB.KP*", "Lock", "", 0.0, false);
      FastFire2("FB.CodeCorrectKill", "Disable", "", 1.0, false);
    } else {
      core.CodeEntry = 0;
      FastFire2("FB.CodeFailedKill", "Enable", "", 0.0, false);
      FastFire2("FB.CodeFailedKill", "Disable", "", 1.0, false);
      CustomSoundEmitter("fartsy/memes/priceisright_fail.wav", 65, false, 0, 1.0, 100);
    }
  }
  case 101: {
    core.CodeEntry++;
  }
  case 102: {
    core.CodeEntry += 2;
  }
  case 103: {
    core.CodeEntry += 3;
  }
  case 104: {
    core.CodeEntry += 4;
  }
  case 105: {
    core.CodeEntry += 5;
  }
  case 106: {
    core.CodeEntry += 6;
  }
  case 107: {
    core.CodeEntry += 7;
  }
  case 108: {
    core.CodeEntry += 8;
  }
  case 109: {
    core.CodeEntry += 9;
  }
  //Lighting Repairs
  case 110: {
    MapLighting[0].Repair();
  }
  case 111: {
    MapLighting[1].Repair();
  }
  case 112:{
    MapLighting[2].Repair();
  }
  case 113:{
    MapLighting[3].Repair();
  }
  case 114:{
    MapLighting[4].Repair();
  }
  case 115:{
    MapLighting[5].Repair();
  }
  case 116:{
    MapLighting[6].Repair();
  }
  case 117:{
    MapLighting[7].Repair();
  }
  case 118:{
    MapLighting[8].Repair();
  }
  case 119:{
    MapLighting[9].Repair();
  }
  case 120:{
    MapLighting[10].Repair();
  }
  case 121:{
    MapLighting[11].Repair();
  }
  //Spoopy
  case 130:{
    FastFire2("gTrain", "StartForward", "", 0.0, false);
    FastFire2("gTelefect", "Start", "", 0.0, false);
    FastFire2("gTelefect", "Stop", "", 3.0, false);
    FastFire2("gTrainSndHaunt", "PlaySound", "", GetRandomFloat(3.0, 7.0), false);
  }
  //Despawn ghosty boi in like 3 seconds
  case 131:{
    FastFire2("gTelefect", "Start", "", 3.0, false);
    FastFire2("gTelefect", "Stop", "", 6.0, false);
    FastFire2("gTrain", "TeleportToPathTrack", "gPathHome", 3.0, false);
  }
  //Determine what boss just deployed.
  case 132:{
  //    if(MetalFaceDidIt){
      //Force phase 4 metal face here
  //    }
    switch(BossHandler.bossID){
      // brute justice
      case 0:{
        FastFire2("bots_win", "roundwin", "", 0.0, false);
      }
    }
  }
  //Metal Face reached spawn point
  case 133:{
    CustomSoundEmitter(SFXArray[3].realPath, 45, false, 0, 1.0, 100);
    FastFire2("FB.MetalFace.Train", "Stop", "", 0.0, false);
    FastFire2("FB.MetalFace.Train", "SetSpeedReal", "50", 3.0, false);
    FastFire2("FB.MetalFace.SpawnShake", "StartShake", "", 0.0, false);
    FastFire2("FB.MetalFace.SpawnParticle", "Stop", "", 0.0, false);
  }
  //Tank deployed its bomb
  case 134:{
    BossHandler.TriggerVictory();
    FastFire2("boss_deploy_relay", "Trigger", "", 5.0, false);
  }
  //Spawn metal face
  case 135:{
    BossHandler.TriggerSpawn(2);
  }
  //Metal Face dead
  case 136:{
    if(BossHandler.iBossPhase != 4){
      BossHandler.iBossPhase = 4;
    }
  }
  //Onslaughter dead
  case 137:{
    tickOnslaughter = false;
    FastFire2("OnslaughterTank", "SetHealth", "1", 0.0, false);
    FastFire2("TankRelayDMG", "Enable", "", 0.0, false);
    FastFire2("TankRelayDMG", "Disable", "", 10.0, false);
  }
  //Sephiroth dead (future code)
  case 138:{

  }
  //Wipe mechanic down (MetalFace)
  case 139:{
    BossHandler.shouldTick = false;
    FastFire2("FB.MetalFace", "Kill", "", 0.0, false);
    FastFire2("FB.MetalFace.Train", "Kill", "", 0.0, false);
    FastFire2("FB.MetalFace.SpawnParticle", "Kill", "", 0.0, false);
    FastFire2("FB.MetalFace.SummonRockets", "Kill", "", 0.0, false);
    FastFire2("FB.MetalFace.GigaBusterSNDTimer", "Kill", "", 0.0, false);
    FastFire2("FB.MetalFace.GigaBuster.Explosion", "Kill", "", 0.0, false);
    FastFire2("FB.MetalFace.GigaBusterMDL", "Kill", "", 0.0, false);
    FastFire2("FB.MetalFace.GigaBusterSND", "Kill", "", 0.0, false);
    BossHandler.TriggerDeath();
  }
  //Debug, somethingsomething aoe blah blah blah
  case 200: {
    CreateTimer(0.1, TimedOperator, 201);
  }
  //Debug, somethingsomething siren explosion thingy
  case 201:{
    WeatherManager.sirenPitch = 300.0;
  }
  case 203:{
    BossHandler.bDoTankBuster = true;
  }
  case 205:{
    PrintToChatAll("%N has the max emnity.", GetEmnityMax());
  }
  //Taco Bell Edition
  case 210: {
    core.tacobell = true;
    ServerCommand("fb_startmoney 200000");
    CPrintToChatAll("{darkviolet}[{orange}INFO{darkviolet}] {white}You have chosen {red}DOVAH'S ASS - TACO BELL EDITION{white}. Warning: All upgrade progress will be lost if you fail the wave. DO NOT FAIL US.");
  }
  //Reset Map
  case 300: {
    tickOnslaughter = false;
    AudioManager.Reset();
    BossHandler.shouldTick = false;
    core.Reset();
    for (int i = 0; i < sizeof(EmnityManager); i++) EmnityManager[i].Reset();
    for (int i = 0; i < sizeof(MapLighting); i++) MapLighting[i].Repair();
    WeatherManager.Reset();
    bombState[0].isReady = false;
    bombState[0].stateMax = 7;
    bombState[0].state = 5;
    iDmgHealingTotal = 0;
    CreateTimer(1.0, PerformAdverts);
    CreateTimer(40.0, SelectAdminTimer);
    FastFire2("Barricade_Rebuild_Relay", "Trigger", "", 0.0, false);
    FastFire2("FB.KP*", "Lock", "", 0.0, false);
    FastFire2("OldSpawn", "Disable", "", 0.0, false);
    FastFire2("NewSpawn", "Enable", "", 0.0, false);
    FastFire2("CommonSpells", "Disable", "", 0.0, false);
    FastFire2("RareSpells", "Disable","",  0.0, false);
    FastFire2("dovahsassprefer", "Disable", "", 0.0, false);
    FastFire2("bombpath_left_arrows", "Disable", "", 0.0, false);
    FastFire2("bombpath_right_arrows", "Disable", "", 0.0, false);
    sudo(1000);
    sudo(1002);
    sudo(1007);
  }
  //TEMP FUNCTIONS
  case 301: {
    EmitSoundToAll(BGMArray[5].realPath, _, AudioManager.chanBGM, BGMArray[5].SNDLVL, SND_CHANGEVOL, 0.05, _, _, _, _, _, _);
  }
  //TEMP FUNCTIONS
  case 302: {
    EmitSoundToAll(BGMArray[5].realPath, _, AudioManager.chanBGM, BGMArray[5].SNDLVL, SND_CHANGEVOL, 1.0, _, _, _, _, _, _);
  }
  case 304: {
    EmitSoundToAll(BGMArray[6].realPath, _, AudioManager.chanBGM, BGMArray[6].SNDLVL, SND_CHANGEVOL, 0.05, _, _, _, _, _, _);
  }
  case 305: {
    EmitSoundToAll(BGMArray[6].realPath, _, AudioManager.chanBGM, BGMArray[6].SNDLVL, SND_CHANGEVOL, 1.0, _, _, _, _, _, _);
  }
  //LOOP SYSTEM
  case 500: {
    AudioManager.indexBGM = 9;
    AudioManager.stopBGM = true;
  }
  case 501: {
    AudioManager.indexBGM = 10;
    AudioManager.stopBGM = true;
  }
  case 502: {
    PrintToChatAll("Got 502 but not implemented in popfile, please report this to fartsy!");
    PrintToConsoleAll("[CORE] Phase Change started... phase 4!");
    AudioManager.indexBGM = 11;
    AudioManager.stopBGM = true;
  }
  // FINAL Music system rewrite (again) AGAINNNNNNNNNNNN.... and again!
  case 1000: {
    AudioManager.ChangeBGM(AudioManager.indexBGM);
  }
  //Stop current song
  case 1001: {
    if (StrEqual(BGMArray[AudioManager.indexBGM].realPath, "null")) return;
    for (int i = 1; i <= MaxClients; i++) {
      StopSound(i, AudioManager.chanBGM, BGMArray[AudioManager.indexBGM].realPath);
    }
    return;
  }
  //Feature an admin
  case 1002: {
    char index[2];
    int i = GetRandomInt(1, 10);
    if (i == core.lastAdmin) i = GetRandomInt(1, 10);
    IntToString(i, index, sizeof(index));
    FastFire2("AdminPicker", "SetTextureIndex", index, 0.0, false);
    core.lastAdmin = i;
    return;
  }
  //Flash Lightning
  case 1003: {
    for (int i = 0; i < sizeof(lightningFlash); i++) FastFire2(lightningFlash[i].fireStr, "", "", 0.0, true);
  }
  //Activate Tornado Timer
  case 1004: {
    if (!core.isWave || !WeatherManager.canTornado || WeatherManager.hasTornado) return;
    WeatherManager.TornadoTimerActive = true;
    float f = (core.curWave == 4 ? GetRandomFloat(30.0, 60.0) : GetRandomFloat(90.0, 210.0));
    CreateTimer(f - 20.0, TimedOperator, 40);
    CreateTimer((f + GetRandomFloat(5.0, 25.0)), TimedOperator, 41);
  }
  //Despawn the tornado
  case 1005: {
    if (GetRandomInt(0, 9) != 9){
      CPrintToChatAll("{red}TTV/professorfartsalot{white}: Nope :>");
      return;
    }
    WeatherManager.Dissipate();
    return;
  }
  //Crusader
  case 1006: {
    AudioManager.shouldTick = false;
    sudo(1001);
    core.crusader = true;
    CreateTimer(1.75, CRUSADERINCOMING);
    CreateTimer(25.20, TimedOperator, 9);
    CreateTimer(25.20, TimedOperator, 78);
    CreateTimer(42.60, TimedOperator, 10);
    CreateTimer(63.20, TimedOperator, 80);
    PrintToServer("Starting Crusader via plugin!");
    EmitSoundToAll("fartsy/misc/fartsyscrusader_bgm_locus.mp3");
    CreateTimer(80.0, TimedOperator, 79);
    for (int i = 0; i < sizeof(crusaderAtk); i++) FastFire2(crusaderAtk[i].fireStr, "", "", 0.0, true);
  }
  //Choose bomb path
  case 1007: {
    FastFire2("Nest_*", "Disable", "", 0.0, false);
    FastFire2("bombpath_right_prefer_flankers", "Disable", "", 0.0, false);
    FastFire2("bombpath_left_prefer_flankers", "Disable", "", 0.0, false);
    FastFire2("bombpath_left_navavoid", "Disable", "", 0.0, false);
    FastFire2("bombpath_right_navavoid", "Disable", "", 0.0, false);
    FastFire2("bombpath_right_arrows", "Disable", "", 0.0, false);
    FastFire2("bombpath_left_arrows", "Disable", "", 0.0, false);
    switch (GetRandomInt(1, 3)) {
    case 1: {
      FastFire2("Nest_R*", "Enable", "", 0.25, false);
      FastFire2("bombpath_right_prefer_flankers", "Enable", "", 0.25, false);
      FastFire2("bombpath_right_navavoid", "Enable", "", 0.25, false);
      FastFire2("bombpath_right_arrows", "Enable", "", 0.25, false);
    }
    case 2: {
      FastFire2("Nest_L*", "Enable", "", 0.25, false);
      FastFire2("bombpath_left_prefer_flankers", "Enable", "", 0.25, false);
      FastFire2("bombpath_left_navavoid", "Enable", "", 0.25, false);
      FastFire2("bombpath_left_arrows", "Enable", "", 0.25, false);
    }
    case 3: {
      FastFire2("dovahsassprefer", "Enable", "",  0.25, false);
      FastFire2("Nest_EN*", "Enable","",  0.25, false);
      FastFire2("bombpath_right_prefer_flankers", "Enable", "", 0.25, false);
      FastFire2("bombpath_right_navavoid", "Enable", "", 0.25, false);
      FastFire2("bombpath_right_arrows", "Enable", "", 0.25, false);
    }
    }
  }
  //Monitor power up/down!
  case 1008: {
    core.monitorOn = (!core.monitorOn ? true : false);
    FastFire2("FB.MonitorSprite", "Color", !core.monitorColor && core.monitorOn ? "0 0 255" : core.monitorOn ? "0 255 0" : "255 0 0", 0.0, false);
    FastFire2(!core.monitorColor && core.monitorOn ? "FB.MonitorBW" : core.monitorOn ? "FB.Monitor" : "FB.Monitor*", core.monitorOn ? "Enable" : "Disable", "", 0.0, false);
    FastFire2(!core.monitorColor && core.monitorOn ? "FB.Monitor" : core.monitorOn ? "FB.MonitorBW" : "FB.MonitorBlank", core.monitorOn ? "Disable" : "Enable", "", 0.0, false);
    FastFire2("FB.MonitorBlank", core.monitorOn ? "Disable" : "Enable", "", 0.2, false);
  }
  //Cycle monitor forward
  case 1009: {
    core.camSel++;
    if (core.camSel >= 5) core.camSel = 0;
    FastFire2("FB.Monitor", "SetCamera", SelectedCamera[core.camSel], 0.0, false);
    FastFire2("FB.MonitorBW", "SetCamera", SelectedCamera[core.camSel], 0.0, false);
  }
  //Cycle monitor back
  case 1010: {
    core.camSel--;
    if (core.camSel <= -1) core.camSel = 4;
    FastFire2("FB.Monitor", "SetCamera", SelectedCamera[core.camSel], 0.0, false);
    FastFire2("FB.MonitorBW", "SetCamera", SelectedCamera[core.camSel], 0.0, false);
  }
  //Toggle black and white mode.
  case 1011: {
    if (!core.monitorOn) return;
    core.monitorColor = (!core.monitorColor ? true : false);
    FastFire2("FB.MonitorSprite", "Color", core.monitorColor ? "0 255 0" : "0 0 255", 0.0, false);
    FastFire2(core.monitorColor ? "FB.MonitorBW" : "FB.Monitor", "Disable", "", 0.0, false);
    FastFire2(core.monitorColor ? "FB.Monitor" : "FB.MonitorBW", "Enable", "", 0.0, false);
  }
  case 6942: {
    core.sacPoints = 2147483647;
  }
  //Do not EVER EVER execute this unless it's an emergency...
  case 6969: {
    CPrintToChatAll(!core.isWave ? "{darkred} [CORE] ERROR, attempted to invoke function without an active wave." : core.brawler_emergency ? "{darkred}[CORE] Failed to enter emergency mode, it is already active." : "{darkred}[CORE] EMERGENCY MODE ACTIVATED...");
    if (!core.isWave || core.brawler_emergency) return;
    Emerge(0);
  }
  //DEBUG
  case 7500:{
    FastFire2("LargeExplosion", "Explode", "", 0.5, false);
  }
  case 8000: {
    SephBoss[GetRandomInt(0, 6)].attack();
  }
  case 9000: {
    CreateTimer(10.0, BossHPTimer);
  }
  case 9001: {
    PrintToServer("BGM State is %b", AudioManager.bgmPlaying);
  }
  case 9010: {
    CustomSoundEmitter(TBGM6, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM4, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM5, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM3, 65, true, 1, 0.05, 100);
  }
  case 9011: {
    CustomSoundEmitter(TBGM6, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM4, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM5, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM3, 65, true, 1, 0.05, 100);
  }
  case 9012: {
    CustomSoundEmitter(TBGM6, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM4, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM5, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM3, 65, true, 1, 0.05, 100);
  }
  case 9013: {
    CustomSoundEmitter(TBGM6, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM4, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM5, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM3, 65, true, 1, 1.0, 100);
  }
  case 9014: {
    CustomSoundEmitter(TBGM6, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM4, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM5, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM3, 65, true, 1, 1.0, 100);
  }
  case 9015: {
    CustomSoundEmitter(TBGM6, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM4, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM5, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM3, 65, true, 1, 1.0, 100);
  }
  case 9016: {
    CustomSoundEmitter(TBGM6, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM4, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM5, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM3, 65, true, 1, 1.0, 100);
  }
  //Play Instrumental
  case 9020: {
    CustomSoundEmitter(TBGM0, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM1, 65, true, 1, 0.05, 100);
  }
  //Play Both
  case 9021: {
    CustomSoundEmitter(TBGM0, 65, true, 1, 1.0, 100);
    CustomSoundEmitter(TBGM1, 65, true, 1, 1.0, 100);
  }
  //Play vocal only
  case 9022: {
    CustomSoundEmitter(TBGM0, 65, true, 1, 0.05, 100);
    CustomSoundEmitter(TBGM1, 65, true, 1, 1.0, 100);
  }
  //Test
  case 10000:{
    int ent = FindEntityByClassname(-1, "tf_objective_resource");
    if (ent != -1){
      PrintToChatAll("%i / 3", GetEntData(ent, FindSendPropInfo("CTFObjectiveResource", "m_nFlagCarrierUpgradeLevel")));
    }
  }
  case 20000:{
    BossHandler.EmitSpawnSound(2);
  }
  }
  return;
}

//Timed commands
public Action TimedOperator(Handle timer, int job) {
    switch (job) {
    case 0: {
      CPrintToChatAll(AudioManager.VIPBGM >= 0 ? "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave %i: {forestgreen}%s{white} (requested by VIP {forestgreen}%N{white})" : "{darkviolet}[{forestgreen}CORE{darkviolet}] {white}Wave %i: {forestgreen}%s", core.curWave, AudioManager.songName, core.VIPIndex);
    }
    //Boss script
    case 2: {
      ServerCommand("fb_operator 1001"); //Stop all bgm.
      CreateTimer(0.0, TimedOperator, 3);
    }
    //Boss script pt 2
    case 3: {
      AudioManager.indexBGM = 16;
      AudioManager.songName = BGMArray[AudioManager.indexBGM].songName;
      CustomSoundEmitter(BGMArray[AudioManager.indexBGM].realPath, BGMArray[AudioManager.indexBGM].SNDLVL, true, 0, 1.0, 100);
      FastFire2("FB.FadeTotalBLCK", "Fade", "", 0.0, false);
      FastFire2("FB.FadeTotalBLCK", "Fade", "", 3.0, false);
      FastFire2("FB.FadeTotalBLCK", "Fade", "", 7.0, false);
      FastFire2("FB.FadeTotalBLCK", "Fade", "", 12.0, false);
      FastFire2("SephMeteor", "ForceSpawn", "", 19.6, false);
      CreateTimer(23.0, TimedOperator, 4);
    }
    //Boss script pt 3
    case 4: {
      CustomSoundEmitter(SFXArray[9].realPath, 65, false, 0, 1.0, 100);
      CreateTimer(4.1, TimedOperator, 5);
    }
    //Boss script pt 4
    case 5: {
      CustomSoundEmitter(SFXArray[58].realPath, 65, false, 0, 1.0, 100);
      FastFire2("SephNuke", "ForceSpawn", "", 3.0, false);
      CreateTimer(3.2, TimedOperator, 6);
    }
    //Boss script pt 5
    case 6: {
      CustomSoundEmitter(SFXArray[35].realPath, 65, false, 0, 1.0, 100);
      FastFire2("FB.Fade", "Fade", "", 0.0, false);
      CreateTimer(1.0, SephATK);
      CreateTimer(1.7, TimedOperator, 7);
    }
    //DO THE THING ALREADY
    case 7: {
      core.sephiroth = true;
      AudioManager.ticksBGM = 0;
      AudioManager.refireBGM = BGMArray[16].refireTime;
    }
    //Signal boss to actually spawn after delay.
    case 8: {
      CustomSoundEmitter(SFXArray[57].realPath, 65, false, 0, 1.0, 100);
      CPrintToChatAll("{darkgreen}[CORE] You did it!!! {darkred}Or... did you...?");
      FastFire2("FB.FadeBLCK", "Fade", "", 0.0, false);
      CreateTimer(4.8, TimedOperator, 2);
    }
    //Crusader Nuke activation
    case 9: {
      core.canCrusaderNuke = true;
      CreateTimer(1.0, NukeTimer, 1);
    }
    //Crusader Nuke Deactivation
    case 10: {
      core.canCrusaderNuke = false;
      return Plugin_Stop;
    }
    //Seph Nuke Deactivation
    case 11: {
      core.canSephNuke = false;
      return Plugin_Stop;
    }
    //SENTMeteor Timeout
    case 12: {
      core.canSENTMeteors = false;
      return Plugin_Stop;
    }
    //SENTStars Timeout
    case 14: {
      core.canSENTStars = false;
      return Plugin_Stop;
    }
    //Incoming
    case 21: {
      CustomSoundEmitter(SFXArray[37].realPath, 65, false, 0, 1.0, 100);
      return Plugin_Stop;
    }
    case 37: {
      EmitSoundToAll(SFXArray[35].realPath);
      return Plugin_Stop;
    }
    //Severe storm coming!!!
    case 40: {
      if (core.isWave && WeatherManager.canTornado && !WeatherManager.sirenExploded) WeatherManager.IssueTornadoWarning();
      return Plugin_Stop;
    }
    // start tornado
    case 41: {
      if (!core.isWave || !WeatherManager.canTornado || WeatherManager.hasTornado) return Plugin_Stop;
      WeatherManager.FormTornado();
      return Plugin_Stop;
    }
    case 42: {
      WeatherManager.TornadoWarning = false;
      WeatherManager.Dissipate();
      sudo(1004);
    }
    case 60: {
      CustomSoundEmitter(SFXArray[40].realPath, 65, false, 0, 1.0, 100);
      return Plugin_Stop;
    }
    case 70: {
      if (core.isWave) {
        FastFire2("FB.KP*", "Unlock", "", 0.0, false);
        CustomSoundEmitter(SFXArray[0].realPath, 65, false, 0, 1.0, 100);
      }
      return Plugin_Stop;
    }
    case 71: {
      CustomSoundEmitter("fartsy/eee/the_horn.wav", 65, false, 0, 1.0, 100);
      return Plugin_Stop;
    }
    case 78: {
      EmitSoundToAll(SFXArray[7].realPath);
      return Plugin_Handled;
    }
    case 79: {
      core.crusader = false;
      core.curWave = GetCurWave();
      if (core.isWave && (core.curWave == 3 || core.curWave == 5)) {
        sudo(99);
      }
      return Plugin_Stop;
    }
    case 80: {
      EmitSoundToAll(SFXArray[59].realPath);
      return Plugin_Stop;
    }
    case 99: {
      if (core.isWave) sudo(99);
      return Plugin_Stop;
    }
    case 100: {
      ServerCommand("_restart");
    }
    case 200:{
      for (int i = 0; i < sizeof(CircleAOEenabled); i++){
        CircleAOEenabled[i] = true;
      }
    }
    case 201:{
    int i = GetRandomInt(0, sizeof(CircleAOEpos)-1);
    if (!CircleAOEenabled[i]){
      if (attemptSpawn >= sizeof(CircleAOEpos)) return Plugin_Stop;
      attemptSpawn++;
      ServerCommand("fb_operator 200");
      return Plugin_Stop;
    }
    attemptSpawn = 0;
    DispatchCircleAOE(CircleAOEpos[i]);
    PrintToChatAll("AOE %i CircleAOEen[i] = %i attempt %i sizeof %i", i, CircleAOEenabled[i], attemptSpawn, sizeof(CircleAOEpos));
    CircleAOEenabled[i] = false;
    CreateTimer(3.0, TimedOperator, 200);
    return Plugin_Stop;
    }
    case 6969: {
      if (!core.isWave){
        ExitEmergencyMode();
        return Plugin_Stop;
      }
      BEM++;
      Emerge(BEM);
      return Plugin_Stop;
    }
    }
    return Plugin_Stop;
}