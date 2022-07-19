Handle g_LSD_Timer_Repeat = INVALID_HANDLE;
bool g_LSD = false;
int g_Previous_LSD = -1;

public void Chaos_LSD_START(){
	g_LSD = true;
	g_Previous_LSD = 1;
	CREATE_CC("env_1");

	g_LSD_Timer_Repeat = CreateTimer(5.0, Timer_SpawnNewLSD);
}

public Action Chaos_LSD_RESET(bool HasTimerEnded){
		StopTimer(g_LSD_Timer_Repeat);
		CLEAR_CC("env_1.raw");
		CLEAR_CC("env_2.raw");
		CLEAR_CC("env_3.raw");
		CLEAR_CC("env_4.raw");
		CLEAR_CC("env_5.raw");
		g_LSD = false;
		g_Previous_LSD = -1;
}


public bool Chaos_LSD_HasNoDuration(){
	return false;
}

public bool Chaos_LSD_Conditions(){
	return true;
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