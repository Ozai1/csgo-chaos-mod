
Handle TPos = INVALID_HANDLE;
Handle CTPos = INVALID_HANDLE;
Handle tIndex = INVALID_HANDLE;
Handle ctIndex = INVALID_HANDLE;

public void Chaos_TeammateSwap_INIT(){
	if(TPos == INVALID_HANDLE) TPos = CreateArray(3);
	if(CTPos == INVALID_HANDLE) CTPos = CreateArray(3);
	if(tIndex == INVALID_HANDLE) tIndex = CreateArray(1);
	if(ctIndex == INVALID_HANDLE) ctIndex = CreateArray(1);
}

public void Chaos_TeammateSwap_START(){
	if(TPos == INVALID_HANDLE){
		Chaos_TeammateSwap_INIT();
	}
	ClearArray(TPos);
	ClearArray(CTPos);
	ClearArray(tIndex);
	ClearArray(ctIndex);

	
	float vec[3];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, vec);
			if(GetClientTeam(i) == CS_TEAM_T) 	PushArrayArray(TPos, vec);
			if(GetClientTeam(i) == CS_TEAM_CT) 	PushArrayArray(CTPos, vec);
		}
	}

	for(int i = MaxClients; i >= 0; i--){
		if(ValidAndAlive(i)){
			if(GetClientTeam(i) == CS_TEAM_T) 	PushArrayCell(tIndex, i);
			if(GetClientTeam(i) == CS_TEAM_CT) 	PushArrayCell(ctIndex, i);
		}
	}

	for(int i = 0; i < GetArraySize(ctIndex); i++){
		GetArrayArray(CTPos, i, vec);
		TeleportEntity(GetArrayCell(ctIndex, i), vec, NULL_VECTOR, NULL_VECTOR);
	}

	for(int i = 0; i < GetArraySize(tIndex); i++){
		GetArrayArray(TPos, i, vec);
		TeleportEntity(GetArrayCell(tIndex, i), vec, NULL_VECTOR, NULL_VECTOR);
	}
}

// public Action Chaos_TeammateSwap_RESET(bool EndChaos){

// }

// public Action Chaos_TeammateSwap_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_TeammateSwap_HasNoDuration(){
	return true;
}

public bool Chaos_TeammateSwap_Conditions(){
	return true;
}