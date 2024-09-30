// Fartsy's Boss Handler v1.0.0
enum struct BOSSHANDLER {
    int bossID;
    bool bTargetInRange[MAXPLAYERS+1];
    bool bDoTankBuster;
    bool isAlive;
    bool shouldTick;
    bool shouldTickBGM;
    bool tickBuster;
    float fAng[3];
    float fPos[3];
    int bustTarget;
    int iBossEnt;
    int iBossEntHealth;
    int iBossEntMaxHealth;
    int iBossEntTarget;
    int iBossPhase;
    int iBossPhaseTmp;
    void EmitSpawnSound(int boss){
        switch(boss){
            //Onslaughter
            case 0:{
                //Onslaughter has no spawn sound for now.... maybe when brute justice happens c:
            }
            //Sephiroth (wip)
            case 1:{

            }
            //Metallizer (wip) To Do: Only change to Inferno if we're in boss attack range. Use a trigger_multiple for this. To Do, delay this by like 1 second so the DJMM sound can play properly.
            case 2:{
                sudo(1001);
                AudioManager.Stop();
                AudioManager.indexBGM = 20;
                CustomSoundEmitter(SFXArray[106].realPath, 65, false, 0, 1.0, 100); //DJMM SFX
                CreateTimer(1.5, DelayedMetalFace);
            }
        }
    }
    //For tracking model and skipping player ready check if boss is alive
    void Tick(){
        if (this.shouldTickBGM) (this.TickBGM());
        if(this.isAlive && !core.isWave){
            PrintToChatAll("PLACEHOLDER -- FORCE PLAYERS TO BE READY IF NOT IN WAVE.");
        }
        if(this.tickBuster) this.TickBuster();
        switch(this.bossID){
            case 0:{

            }
            case 1:{

            }
            case 2:{
                this.iBossEnt = FindEntityByTargetname("FB.MetalBase", "base_boss");
                this.iBossEntHealth = GetEntProp(this.iBossEnt, Prop_Data, "m_iHealth");
                this.iBossEntMaxHealth = GetEntProp(this.iBossEnt, Prop_Data, "m_iMaxHealth");
                this.iBossEntTarget = FindEntityByTargetname("FB.MetalFace.Train", "func_tracktrain");
                GetEntPropVector(this.iBossEntTarget, Prop_Send, "m_vecOrigin", this.fPos);
                GetEntPropVector(this.iBossEntTarget, Prop_Data, "m_angRotation", this.fAng);
                float vel[3];
                float newPos[3];
                vel[0] = 0.0;
                vel[1] = 0.0;
                vel[2] = 0.0;
                newPos[0] = this.fPos[0];
                newPos[1] = this.fPos[1];
                newPos[2] = this.fPos[2] - 50.0;
                TeleportEntity(this.iBossEnt, newPos, this.fAng, vel);
                //Also need to set entity angles to its target... we can use this.bustTarget for the index of the client to get the angles...
                //Do phase changes
                switch(RoundToFloor((this.iBossEntHealth * 1.0/this.iBossEntMaxHealth * 1.0) * 10.0)){
                    case 10:{
                        this.iBossPhase = 1;
                    }
                    case 7:{
                        this.iBossPhase = 2;
                    }
                    case 4:{
                        this.iBossPhase = 3;
                    }
                    case 1:{
                        this.iBossPhase = 4;
                    }
                }
                if(this.iBossPhase != this.iBossPhaseTmp){
                    PrintToChatAll("PHASE CHANGED, %i to %i", this.iBossPhaseTmp, this.iBossPhase);
                    this.iBossPhaseTmp = this.iBossPhase;
                    if(this.iBossPhase > 1){
                        FastFire2("mfTelefect", "Start", "", 0.0, false);
                        FastFire2("FB.MetalFace.ReturnSND", "PlaySound", "", 0.0, false);
                        FastFire2("FB.MetalFace.Train", "TeleportToPathTrack", "MFTHOME", 0.25, false);
                        FastFire2("FB.MetalFace.Invuln", "Enable", "", 3.0, false);
                    }
                    //Phase changing, these only ever happen once per phase.
                    switch(this.iBossPhase){
                        case 0:{
                            PrintToChatAll("Phase 0 happened, boss must must be dead /shrug");
                        }
                        case 1:{
                            //PrintToChatAll("Recognized 0 -> 1, the boss must have just spawned!");
                        }
                        case 2:{
                            //PrintToChatAll("Recognized 1 -> 2, things are heating up!");
                            AudioManager.ChangeBGM(22);
                            FastFire2("FB.MetalFace.Train", "TeleportToPathTrack", "MFT1x0", 3.00, false);
                        }
                        case 3:{
                            //PrintToChatAll("Recognized 2 -> 3, oh boi");
                            AudioManager.ChangeBGM(24);
                            FastFire2("FB.MetalFace.Train", "TeleportToPathTrack", "MFT2x0", 3.00, false);
                        }
                        case 4:{
                            //PrintToChatAll("Recognized 3 -> 4, OHSHITOHFUCKOHNO");
                            AudioManager.ChangeBGM(26);
                            FastFire2("FB.MetalFace.Train", "TeleportToPathTrack", "MFT3x0", 3.00, false);
                            FastFire2("FB.MetalFace.GigaBuster", "ForceSpawn", "", 10.0, false);
                        }
                    }
                }
            }
        }
    }
    //For tracking bgm and updating bgm based on player emnity
    void TickBGM(){
        if (this.shouldTickBGM){
            int iBGM0;
            int iBGM1;
            switch(this.iBossPhase){
                case 1:{
                    iBGM0 = 20;
                    iBGM1 = 21;
                }
                case 2:{
                    iBGM0 = 22;
                    iBGM1 = 23;
                }
                case 3:{
                    iBGM0 = 24;
                    iBGM1 = 25;
                }
                case 4:{
                    iBGM0 = 26;
                    iBGM1 = 27;
                }
            }
            for (int i = 0; i < MaxClients; i++){
                if (EmnityManager[i].IsAboveEmnityThreshold(SuggestEmnityThreshold())) {
                    CSEClient(i, BGMArray[iBGM1].realPath, BGMArray[iBGM1].SNDLVL, true, 1, 1.0, 100);
                    CSEClient(i, BGMArray[iBGM0].realPath, BGMArray[iBGM0].SNDLVL, true, 1, 0.05, 100);
                }
                else {
                    CSEClient(i, BGMArray[iBGM1].realPath, BGMArray[iBGM1].SNDLVL, true, 1, 0.05, 100);
                    CSEClient(i, BGMArray[iBGM0].realPath, BGMArray[iBGM0].SNDLVL, true, 1, 1.0, 100);
                }
            }
            AudioManager.indexBGM = iBGM0;
        }
    }
    //Tank buster thing
    void TickBuster(){
        float cPos[3]; //Client's Position
        float pPos[3]; //Ground Particle Target Position
        float sPos[3]; //Sign/Arrow's Target Position
        float rPos[3];
        float fVelocity[3]; //Velocity for teleporting entities, used for angles as well so we don't need two vectors.
        int iAirParticle = FindEntityByTargetname("FB.TankBuster.AirParticle", "func_brush");
        int iBuster = FindEntityByTargetname("FB.TankBuster", "trigger_hurt");
        int iExploParticle = FindEntityByTargetname("FB.TankBuster.ExplodeParticle", "info_particle_system");
        int iParticle = FindEntityByTargetname("FB.TankBuster.GroundParticle", "info_particle_system");
        int iSign = FindEntityByTargetname("FB.TankBuster.Sign", "func_rotating");
        int iSpin = FindEntityByTargetname("FB.TankBuster.Spinner", "func_rotating");
        GetClientAbsOrigin(this.bustTarget, cPos);
        rPos[0] = cPos[0];
        rPos[1] = cPos[1];
        rPos[2] = cPos[2] + 50.0;
        pPos[0] = cPos[0];
        pPos[1] = cPos[1];
        pPos[2] = cPos[2] + 25.0;
        sPos[0] = cPos[0];
        sPos[1] = cPos[1];
        sPos[2] = cPos[2] + 150.0;
        TeleportEntity(iAirParticle, rPos, fVelocity, fVelocity);
        TeleportEntity(iParticle, pPos, fVelocity, fVelocity);
        TeleportEntity(iExploParticle, pPos, fVelocity, fVelocity);
        TeleportEntity(iBuster, cPos, fVelocity, fVelocity);
        TeleportEntity(iSign, sPos, fVelocity, fVelocity); 
        TeleportEntity(iSpin, pPos, fVelocity, fVelocity);
    }
    //Tick client post
    void TickForClient(int client){
        float cPos[3];
        GetClientAbsOrigin(client, cPos);
        if(GetVectorDistance(cPos, this.fPos) < 500 && client == GetEmnityMax() && this.bDoTankBuster){
            char sDamage[32];
            this.bustTarget = client;
            this.bDoTankBuster = false;
            int iHealth = GetClientHealth(this.bustTarget);
            Format(sDamage, sizeof(sDamage), "damage %i", RoundToFloor(iHealth * 0.65));
            FastFire2("FB.TankBuster", "AddOutput", sDamage, 0.0, false);
            FastFire2("FB.TankBusterSND", "PlaySound", "", 1.25, false);
            FastFire2("FB.TankBuster.GroundParticle", "Start", "", 0.0, false);
            FastFire2("FB.TankBuster.ExplodeSND", "PlaySound", "", 5.50, false);
            FastFire2("FB.TankBuster.ExplodeParticle", "Start", "", 5.75, false);
            FastFire2("FB.TankBuster.ExplodeParticle", "Stop", "", 9.0, false);
            FastFire2("FB.TankBuster", "Enable", "", 5.75, false);
            FastFire2("FB.TankBuster", "Disable", "", 6.0, false);
            CreateTimer(1.0, StartTickBuster);
            PrintToServer("Dropping a tank buster on %N, they have %i HP, the tank buster will do %s.", this.bustTarget, iHealth, sDamage);
            CreateTimer(7.0, ResetTickBuster);
        }
    }
    //Boss was slain
    void TriggerDeath(){
        this.shouldTick = false;
        this.tickBuster = false;
        this.iBossPhase = 0;
        switch(this.bossID){
            //Onslaughter lost
            case 0: {

            }
            //Sephiroth lost
            case 1:{

            }
            //Metal Face lost
            case 2:{
                FastFire2("FB.MetalFace.Train", "TeleportToPathTrack", "MFTHOME", 0.0, false);
            }
        }
    }
    //Boss reached bomb hatch
    void TriggerVictory(){
        this.shouldTick = false;
        this.tickBuster = false;
        float bossOrigin[3];
        float targetOrigin[3];
        int targetEnt = FindEntityByTargetname("capturezone_blue", "func_capturezone");
        GetEntPropVector(targetEnt, Prop_Send, "m_vecOrigin", targetOrigin);
        switch(this.bossID){
            //Onslaughter Won
            case 0:{
                int bossEnt = FindEntityByTargetname("FB.MetalBase", "base_boss");
                if(bossEnt == -1) return;
                GetEntPropVector(bossEnt, Prop_Send, "m_vecOrigin", bossOrigin);
                if (GetVectorDistance(bossOrigin, targetOrigin) < 2200){
                    //Do something here because Onslaughter is at the pit, victory for boss.
                }
            }
            //Sephiroth Won
            case 1:{

            }
            //Metallizer Won
            case 2:{
                int bossEnt = FindEntityByTargetname("FB.MetalBase", "base_boss");
                if(bossEnt == -1) return;
                GetEntPropVector(bossEnt, Prop_Send, "m_vecOrigin", bossOrigin);
                if (GetVectorDistance(bossOrigin, targetOrigin) < 2200){
                    //Do something here because Metal Face is at the pit, victory for boss.
                }
            }
        }
    }
    //Spawn the boi
    void TriggerSpawn(int boss){
        this.bossID = boss;
        this.shouldTick = true;
        switch(boss){
            case 0:{

            }
            case 1:{

            }
            case 2:{
                this.EmitSpawnSound(2);
                FastFire2("FB.MetalFace.Train", "TeleportToPathTrack", "MFT0x0", 1.0, false);
                FastFire2("FB.MetalFace.SpawnParticle", "Start", "", 1.0, false);
                FastFire2("FB.MetalFace.Train", "SetSpeedReal", "1024", 1.0, false);
                //switch(GetClientCount(true))
                FastFire2("FB.MetalBase", "AddOutput", "health 320000", 0.0, false);
            }
        }
    }
}
BOSSHANDLER BossHandler;

stock int SuggestEmnityThreshold(){
    switch(GetClientCount(true)){
        case 1:{
            return 75;
        }
        case 2:{
            return 60;
        }
        case 3:{
            return 50;
        }
        case 4:{
            return 35;
        }
        case 5:{
            return 25;
        }
        case 6:{
            return 20;
        }
        case 7:{
            return 15;
        }
        case 8,9,10:{
            return 10;
        }
    }
    return -1;
}
//Used for emitting boss sounds
public Action QueueBossSound(Handle timer, int sound){
    AssLogger(LOGLVL_DEBUG, "QueueBossSound played %i", sound);
    switch(sound){
        case 2:{ 
        }
        case 10:{
            CustomSoundEmitter(SFXArray[71].realPath, 65, false, 0, 1.0, 100); //Interrupting
            CreateTimer(3.1, QueueBossSound, GetRandomInt(16,22));
        }
        case 11:{
            CustomSoundEmitter(SFXArray[69].realPath, 65, false, 0, 1.0, 100); //FunnyLooking
            CreateTimer(3.0, QueueBossSound, GetRandomInt(18, 21));
        }
        case 12:{
            CustomSoundEmitter(SFXArray[75].realPath, 65, false, 0, 1.0, 100); //Racket
            CreateTimer(3.2, QueueBossSound, GetRandomInt(16, 22));
        }
        case 13:{
            CustomSoundEmitter(SFXArray[78].realPath, 65, false, 0, 1.0, 100); //WhatDoing
        }
        case 14:{
            CustomSoundEmitter(SFXArray[79].realPath, 65, false, 0, 1.0, 100); //WhateverDoing
            CreateTimer(4.3, QueueBossSound, GetRandomInt(16,17));
        }
        case 15:{
            CustomSoundEmitter(SFXArray[72].realPath, 65, false, 0, 1.0, 100); //Join In
            CreateTimer(3.2, QueueBossSound, 16);
        }
        //pt 2
        case 16:{
            CustomSoundEmitter(SFXArray[70].realPath, 65, false, 0, 1.0, 100); //Good show
        }
        case 17:{
            CustomSoundEmitter(SFXArray[67].realPath, 65, false, 0, 1.0, 100); //Carryon
        }
        case 18:{
            CustomSoundEmitter(SFXArray[66].realPath, 65, false, 0, 1.0, 100); //Carnage
        }
        case 19:{
            CustomSoundEmitter(SFXArray[73].realPath, 65, false, 0, 1.0, 100); //Lets Start
        }
        case 20:{
            CustomSoundEmitter(SFXArray[74].realPath, 65, false, 0, 1.0, 100); //Make Way
        }
        //Attack sounds, but also shared with spawn sounds
        case 21:{
            CustomSoundEmitter(SFXArray[76].realPath, 65, false, 0, 1.0, 100); //SliceYou
        }
        case 22:{
            CustomSoundEmitter(SFXArray[77].realPath, 65, false, 0, 1.0, 100); //Stroll
        }
        //Attack sounds, used for random grunts
        case 23:{
            CustomSoundEmitter(SFXArray[80].realPath, 65, false, 0, 1.0, 100); //gah
        }
        case 24:{
            CustomSoundEmitter(SFXArray[81].realPath, 65, false, 0, 1.0, 100); //guh
        }
        case 25:{
            CustomSoundEmitter(SFXArray[82].realPath, 65, false, 0, 1.0, 100); //hah
        }
        //Defeats
        case 26:{
            CustomSoundEmitter(SFXArray[83].realPath, 65, false, 0, 1.0, 100); //BadSide
        }
        case 27:{
            CustomSoundEmitter(SFXArray[84].realPath, 65, false, 0, 1.0, 100); //NotFair
        }
        case 28:{
            CustomSoundEmitter(SFXArray[85].realPath, 65, false, 0, 1.0, 100); //Nothing
        }
        case 29:{
            CustomSoundEmitter(SFXArray[86].realPath, 65, false, 0, 1.0, 100); //Scream
        }
        case 30:{
            CustomSoundEmitter(SFXArray[87].realPath, 65, false, 0, 1.0, 100); //ToGo
        }
        //Special attack sounds like phase changes
        case 31:{
            CustomSoundEmitter(SFXArray[88].realPath, 65, false, 0, 1.0, 100); //Clever
        }
        case 32:{
            CustomSoundEmitter(SFXArray[89].realPath, 65, false, 0, 1.0, 100); //Cmon
        }
        case 33:{
            CustomSoundEmitter(SFXArray[90].realPath, 65, false, 0, 1.0, 100); //Die
        }
        case 34:{
            CustomSoundEmitter(SFXArray[91].realPath, 65, false, 0, 1.0, 100); //GetOff
        }
        case 35:{
            CustomSoundEmitter(SFXArray[92].realPath, 65, false, 0, 1.0, 100); //HearYouScream
        }
        case 36:{
            CustomSoundEmitter(SFXArray[93].realPath, 65, false, 0, 1.0, 100); //IsntOver
        }
        case 37:{
            CustomSoundEmitter(SFXArray[94].realPath, 65, false, 0, 1.0, 100); //Like
        }
        case 38:{
            CustomSoundEmitter(SFXArray[95].realPath, 65, false, 0, 1.0, 100); //Little
        }
        case 39:{
            CustomSoundEmitter(SFXArray[96].realPath, 65, false, 0, 1.0, 100); //Pay
        }
        case 40:{
            CustomSoundEmitter(SFXArray[97].realPath, 65, false, 0, 1.0, 100); //Pointers
        }
        case 41:{
            CustomSoundEmitter(SFXArray[98].realPath, 65, false, 0, 1.0, 100); //Seat
        }
        case 42:{
            CustomSoundEmitter(SFXArray[99].realPath, 65, false, 0, 1.0, 100); //Size
        }
        case 43:{
            CustomSoundEmitter(SFXArray[100].realPath, 65, false, 0, 1.0, 100); //There
        }
        case 44:{
            CustomSoundEmitter(SFXArray[101].realPath, 65, false, 0, 1.0, 100); //TimeToDie
        }
        case 45:{
            CustomSoundEmitter(SFXArray[102].realPath, 65, false, 0, 1.0, 100); //Way
        }
        //Ultimates
        case 46:{
            CustomSoundEmitter(SFXArray[103].realPath, 65, false, 0, 1.0, 100); //FinalWords
        }
        case 47:{
            CustomSoundEmitter(SFXArray[104].realPath, 65, false, 0, 1.0, 100); //PartingGift
        }
        case 48:{
            CustomSoundEmitter(SFXArray[105].realPath, 65, false, 0, 1.0, 100); //WatchAndLearn
        }
    }
    return Plugin_Stop;
}
//Teleport all entities to the client every frame
public Action StartTickBuster(Handle timer){
    BossHandler.tickBuster = true;
    return Plugin_Stop;
}
//Used for stopping tank busters from ticking
public Action ResetTickBuster(Handle time){
    BossHandler.tickBuster = false;
    float fAirPart[3] = {
        -1437.270019,
        -3906.739990,
        -1334.989990
    };
    float fVelocity[3];
    int iAirParticle = FindEntityByTargetname("FB.TankBuster.AirParticle", "func_brush");
    int iBuster = FindEntityByTargetname("FB.TankBuster", "trigger_hurt");
    int iExploParticle = FindEntityByTargetname("FB.TankBuster.ExplodeParticle", "info_particle_system");
    int iParticle = FindEntityByTargetname("FB.TankBuster.GroundParticle", "info_particle_system");
    int iSign = FindEntityByTargetname("FB.TankBuster.Sign", "func_rotating");
    int iSpin = FindEntityByTargetname("FB.TankBuster.Spinner", "func_rotating");
    TeleportEntity(iAirParticle, fAirPart, fVelocity, fVelocity);
    TeleportEntity(iParticle, fAirPart, fVelocity, fVelocity);
    TeleportEntity(iExploParticle, fAirPart, fVelocity, fVelocity);
    TeleportEntity(iBuster, fAirPart, fVelocity, fVelocity);
    TeleportEntity(iSign, fAirPart, fVelocity, fVelocity); 
    TeleportEntity(iSpin, fAirPart, fVelocity, fVelocity);
    return Plugin_Stop;
}

//Spawn metal face
public Action DelayedMetalFace(Handle timer){
    AudioManager.indexBGM = 20;
    AudioManager.stopBGM = true;
    CustomSoundEmitter(SFXArray[68].realPath, 65, false, 0, 1.0, 100); //Evil Laugh
    CreateTimer(3.2, QueueBossSound, GetRandomInt(10,14));
    sudo(1000);
    BossHandler.shouldTickBGM = true;
    return Plugin_Stop;
}