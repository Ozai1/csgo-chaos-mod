#pragma semicolon 1

public void Chaos_LightsOff(EffectData effect){
	effect.Title = "Who turned the lights off?";
	effect.Duration = 30;
}

public void Chaos_LightsOff_START(){
	LightsOff();
}

public void Chaos_LightsOff_RESET(int ResetType){
	LightsOff(true);
}