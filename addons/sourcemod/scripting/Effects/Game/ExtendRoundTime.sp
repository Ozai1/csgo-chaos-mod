#pragma semicolon 1

public void Chaos_ExtendRoundTime(EffectData effect){
	effect.Title = "Extend Round Time";
	effect.HasNoDuration = true;	
}

public void Chaos_ExtendRoundTime_START(){
	if(IsCoopStrike()){
	    GameRules_SetProp("m_iRoundTime", GameRules_GetProp("m_iRoundTime", 4, 0) + 300, 4, 0, true);
	}else{
	    GameRules_SetProp("m_iRoundTime", GameRules_GetProp("m_iRoundTime", 4, 0) + 60, 4, 0, true);
	}
}