effect_data 	Chaos_EffectData_Buffer;
char 			Chaos_EventName_Buffer[64];

public void HookMainEvents(){
	HookEvent("round_start", 	Event_RoundStart);
	HookEvent("round_end", 		Event_RoundEnd);	
	HookEvent("bomb_planted", 	Event_BombPlanted);
	HookEvent("server_cvar", 	Event_Cvar, EventHookMode_Pre);
	HookEvent("player_spawn", 	Event_PlayerSpawn);
}

public Action Event_PlayerSpawn(Event event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;

	int client = GetClientOfUserId(event.GetInt("userid"));

	LoopAllEffects(Chaos_EffectData_Buffer, index){
		// if(Chaos_EffectData_Buffer.Timer == INVALID_HANDLE) continue; //effect is running

		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnPlayerSpawn", Chaos_EffectData_Buffer.FunctionName);
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(client); 
			Call_PushCell(Chaos_EffectData_Buffer.Timer != INVALID_HANDLE); 
			Call_Finish();
		}
	}
	return Plugin_Continue;
}


public Action Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	g_bCanSpawnChickens = false;
	if(!ValidBombSpawns()){
		CreateTimer(1.0, Timer_SaveBombPosition);
	}
	return Plugin_Continue;
}

public Action Timer_SaveBombPosition(Handle timer){
	SaveBombPosition();
}


public void OnEntityCreated(int ent, const char[] classname){
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnEntityCreated", Chaos_EffectData_Buffer.FunctionName);
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(ent); 
			Call_PushString(classname);
			Call_Finish();
		}
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnPlayerRunCmd", Chaos_EffectData_Buffer.FunctionName);
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(client); 
			Call_PushCellRef(buttons);
			Call_PushCell(iImpulse);
			Call_PushArrayEx(fVel, 3, SM_PARAM_COPYBACK);
			Call_PushArrayEx(fAngles, 3, SM_PARAM_COPYBACK);
			Call_PushCell(iWeapon);
			Call_PushCell(iSubType);
			Call_PushCell(iCmdNum);
			Call_PushCell(iTickCount);
			Call_PushCellRef(iSeed);
			Call_PushArrayEx(mouse, 2, SM_PARAM_COPYBACK);
			Call_Finish();
		}
	}

	return Plugin_Changed;
}

public Action Event_RoundStart(Event event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;

	SetRandomSeed(GetTime());

	// Log("---ROUND STARTED---");

	g_bCanSpawnEffect = true;
	
	CheckHostageMap();
	ResetHud();
	ResetChaos();
	CLEAR_CC();

	g_iTotalRoundsThisMap++;

	g_iTotalEffectsRanThisRound = 0;

	CreateTimer(5.0, Timer_CreateHostage);
		
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	
	if (GameRules_GetProp("m_bWarmupPeriod") != 1){
		float freezeTime = float(FindConVar("mp_freezetime").IntValue);
		g_NewEffect_Timer = CreateTimer(freezeTime, ChooseEffect, _, TIMER_FLAG_NO_MAPCHANGE);
	}

	g_iChaosRoundTime = 0;
	CreateTimer(1.0, Timer_UpdateRoundTime);
	return Plugin_Continue;
}

public Action Timer_UpdateRoundTime(Handle timer){
	if(g_iChaosRoundTime < -50){
		return;
	}
	g_iChaosRoundTime++;	
	CreateTimer(1.0, Timer_UpdateRoundTime);
}
public Action Event_RoundEnd(Event event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	g_iChaosRoundTime = -100;
	
	ClearFog();
	
	// Log("--ROUND ENDED--");
	ResetChaos();
	g_bCanSpawnEffect = false;

	Clear_Overlay_Que();

	return Plugin_Continue;
}

void ResetChaos(){
	HUD_ROUNDEND();
	Clear_Overlay_Que();
	StopTimer(g_NewEffect_Timer);
	CreateTimer(0.1, ResetRoundChaos);
}

public void OnGameFrame(){
	if (!g_cvChaosEnabled.BoolValue) return;
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnGameFrame", Chaos_EffectData_Buffer.FunctionName);
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish();
		}
	}
}


public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast){
	if (!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	return Plugin_Handled;
}