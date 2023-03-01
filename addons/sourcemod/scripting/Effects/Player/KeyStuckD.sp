#pragma semicolon 1

public void Chaos_KeyStuckD(EffectData effect){
	effect.Title = "Help my D key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_DisableStrafe");
	effect.IncompatibleWith("Chaos_KeyStuckA");
}

public void Chaos_KeyStuckD_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	fVel[1] = 400.0;
}

public bool Chaos_KeyStuckD_Conditions(bool EffectRunRandomly){
	if(EffectRunRandomly){
		return CanRunKeyStuckEffect();
	}
	return true;
}