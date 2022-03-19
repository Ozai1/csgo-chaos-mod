Handle g_LSD_Timer = INVALID_HANDLE;
Handle g_LSD_Timer_Repeat = INVALID_HANDLE;
bool g_LSD = false;
int g_Previous_LSD = -1;
Action Chaos_LSD(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_LSD_Timer);
		StopTimer(g_LSD_Timer_Repeat);
		CLEAR_CC("env_1.raw");
		CLEAR_CC("env_2.raw");
		CLEAR_CC("env_3.raw");
		CLEAR_CC("env_4.raw");
		CLEAR_CC("env_5.raw");
		g_LSD = false;
		g_Previous_LSD = -1;
	}
	if(NotDecidingChaos("Chaos_LSD")) return;
	if(CurrentlyActive(g_LSD_Timer)) return;

	g_LSD = true;
	g_Previous_LSD = 1;
	CREATE_CC("env_1");

	g_LSD_Timer_Repeat = CreateTimer(5.0, Timer_SpawnNewLSD);

	float duration = GetChaosTime("Chaos_LSD", 30.0);
	if(duration > 0) g_LSD_Timer = CreateTimer(duration, Chaos_LSD, true);
	
	AnnounceChaos("LSD", duration);
}

public Action Timer_SpawnNewLSD(Handle Timer){
	g_LSD_Timer_Repeat = INVALID_HANDLE;

	CLEAR_CC("env_1.raw");
	CLEAR_CC("env_2.raw");
	CLEAR_CC("env_3.raw");
	CLEAR_CC("env_4.raw");
	CLEAR_CC("env_5.raw");
	
	if(g_LSD){
		int test = g_Previous_LSD;
		while(test == g_Previous_LSD) test = GetRandomInt(1,5);

		if(test == 1) CREATE_CC("env_1");
		if(test == 2) CREATE_CC("env_2");
		if(test == 3) CREATE_CC("env_3");
		if(test == 4) CREATE_CC("env_4");
		if(test == 5) CREATE_CC("env_5");
		g_LSD_Timer_Repeat = CreateTimer(5.0, Timer_SpawnNewLSD);
	}
}


Handle g_BlackWhite_Timer = INVALID_HANDLE;
Action Chaos_BlackWhite(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_BlackWhite_Timer);
		CLEAR_CC("blackandwhite.raw");
	}
	if(NotDecidingChaos("Chaos_BlackWhite.Blackandwhite")) return;
	if(CurrentlyActive(g_BlackWhite_Timer)) return;

	CREATE_CC("blackandwhite");
	float duration = GetChaosTime("Chaos_BlackWhite", 15.0);
	if(duration > 0) g_BlackWhite_Timer = CreateTimer(duration, Chaos_BlackWhite, true);
	
	AnnounceChaos("Black & White", duration);
}

Handle g_Saturation_Timer = INVALID_HANDLE;
Action Chaos_Saturation(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_Saturation_Timer);
		CLEAR_CC("saturation.raw");
	}
	if(NotDecidingChaos("Chaos_Saturation")) return;
	if(CurrentlyActive(g_Saturation_Timer)) return;

	CREATE_CC("saturation");

	float duration = GetChaosTime("Chaos_BlackWhite", 15.0);
	if(duration > 0) g_Saturation_Timer = CreateTimer(duration, Chaos_Saturation, true);
	
	AnnounceChaos("Saturation", duration);
}

void Chaos_RevealEnemyLocation(){
	if(ClearChaos()){

	}
	if(NotDecidingChaos("Chaos_RevealEnemyLocation")) return;
	ConVar radar = FindConVar("mp_radar_showall");

	if(radar.IntValue == 0){
		cvar("mp_radar_showall", "1");
		CreateTimer(0.2, Chaos_EnemyRadar, true); //use already made timer;
	}

	AnnounceChaos("Reveal Enemies Location", -1.0);
}

Handle g_HealthRegen_Timer = INVALID_HANDLE;
bool g_HealthRegen = false;
Action Chaos_HealthRegen(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_HealthRegen_Timer);
		g_HealthRegen = false;
	}
	if(NotDecidingChaos("Chaos_HealthRegen")) return;
	if(CurrentlyActive(g_HealthRegen_Timer)) return;

	g_HealthRegen = true;
	CreateTimer(1.0, Timer_GiveHealthRegen);

	float duration = GetChaosTime("Chaos_HealthRegen", 20.0);
	if(duration > 0) g_HealthRegen_Timer = CreateTimer(duration, Chaos_HealthRegen, true);
	
	AnnounceChaos("Health Regen", duration);
}

public Action Timer_GiveHealthRegen(Handle timer){
	if(g_HealthRegen){
		int currenthealth = -1;
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				currenthealth = GetClientHealth(i);
				SetEntityHealth(i, currenthealth + 10);
			}
		}
		CreateTimer(1.0, Timer_GiveHealthRegen);
	}
}