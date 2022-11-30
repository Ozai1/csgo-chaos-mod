public void Chaos_Saturation(effect_data effect){
	effect.Title = "Saturation";
	effect.Duration = 30;
}

bool saturationMaterials = true;

public void Chaos_Saturation_OnMapStart(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/saturation.raw");
	if(!FileExists("materials/Chaos/ColorCorrection/saturation.raw")) saturationMaterials = false;
}

public void Chaos_Saturation_START(){
	CREATE_CC("saturation");
}

public Action Chaos_Saturation_RESET(bool HasTimerEnded){
	CLEAR_CC("saturation.raw");
}

public bool Chaos_Saturation_Conditions(){
	return saturationMaterials;
}