//Fartsy's FastFire2
int ff2Ref;

//Inject entity IO logic
public void OnMapStart() {
  InjectFastFire2();
}

void InjectFastFire2(){
  int ff2 = FindEntityByTargetname("FastFire2", "info_target");
  AssLogger(LOGLVL_INFO, "Injecting FastFire2!");
  if (!IsValidEntity(ff2)){
    ff2 = CreateEntityByName("info_target");
    if (!IsValidEdict(ff2)) SetFailState("Could not inject FastFire2, aborting!!!");
    DispatchSpawn(ff2);
    DispatchKeyValue(ff2, "targetname", "FastFire2");
    ActivateEntity(ff2);
    AssLogger(LOGLVL_INFO, "Injected info_target FastFire2 to map!")
  }
  ff2Ref = EntIndexToEntRef(ff2);
  OnFastFire2Ready();
}

//Execute inputs - EXPERT MODE
public void FastFire2(const char[] target, const char[] input, const char[] param, const float delay, bool isLegacy) {
  int ff2 = EntRefToEntIndex(ff2Ref);
  char FireStr[128];
  FormatEx(FireStr, sizeof(FireStr), (isLegacy ? target : "OnUser1 %s,%s,%s,%f,1"), target, input, param, delay);
  SetVariantString(FireStr);
  AcceptEntityInput(ff2, "AddOutput");
  AcceptEntityInput(ff2, "FireUser1");
}