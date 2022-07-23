bool g_bDiscoFog = false;
Handle g_DiscoFog_Timer_Repeat = INVALID_HANDLE;

public void Chaos_DiscoFog_START(){
	DiscoFog();
	g_bDiscoFog = true;
	g_DiscoFog_Timer_Repeat = CreateTimer(1.0, Timer_NewFogColor, _,TIMER_REPEAT);
}

public Action Chaos_DiscoFog_RESET(bool HasTimerEnded){
	StopTimer(g_DiscoFog_Timer_Repeat);
	g_bDiscoFog = false;
	DiscoFog(true);
	// Fog_OFF();
}

public Action Timer_NewFogColor(Handle timer){
	if(g_bDiscoFog){
		char color[32];
		FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
		DispatchKeyValue(g_iFog, "fogcolor", color);
	}else{
		StopTimer(g_DiscoFog_Timer_Repeat);
	}
}
