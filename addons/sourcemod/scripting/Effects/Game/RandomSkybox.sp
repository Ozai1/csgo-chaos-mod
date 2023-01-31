#pragma semicolon 1

public void Chaos_RandomSkybox(effect_data effect){
	effect.Title = "Random Skybox";
	effect.HasNoDuration = true;
	effect.AddAlias("Visual");
}

public void Chaos_RandomSkybox_START(){
	int randomSkyboxIndex = GetRandomInt(0, sizeof(g_sSkyboxes)-1);
	DispatchKeyValue(0, "skyname", g_sSkyboxes[randomSkyboxIndex]);
}

public bool Chaos_RandomSkybox_Conditions(bool EffectRunRandomly){
	if(StrEqual(mapName, "de_dust2") && EffectRunRandomly){
		return false;
	}
	return true;
}