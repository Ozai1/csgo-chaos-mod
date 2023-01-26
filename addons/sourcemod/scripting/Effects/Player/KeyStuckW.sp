bool WKeyStuck = false;

public void Chaos_KeyStuckW(effect_data effect){
	effect.Title = "Help my W key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_DisableForwardBack");
	effect.IncompatibleWith("Chaos_KeyStuckS");
}

public void Chaos_KeyStuckW_START(){
	WKeyStuck = true;
}

public void Chaos_KeyStuckW_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(WKeyStuck) fVel[0] = 400.0;
}

public void Chaos_KeyStuckW_RESET(bool HasTimerEnded){
	WKeyStuck = false;
}

public bool Chaos_KeyStuckW_Conditions(){
	return true;
}