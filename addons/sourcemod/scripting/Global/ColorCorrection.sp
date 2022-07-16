void DownloadRawFiles(){
	AddFileToDownloadsTable("/materials/Chaos/ColorCorrection/env_1.raw");
	AddFileToDownloadsTable("/materials/Chaos/ColorCorrection/env_2.raw");
	AddFileToDownloadsTable("/materials/Chaos/ColorCorrection/env_3.raw");
	AddFileToDownloadsTable("/materials/Chaos/ColorCorrection/env_4.raw");
	AddFileToDownloadsTable("/materials/Chaos/ColorCorrection/env_5.raw");

	AddFileToDownloadsTable("/materials/Chaos/ColorCorrection/saturation.raw");
	AddFileToDownloadsTable("/materials/Chaos/ColorCorrection/blackandwhite.raw");
}

void CLEAR_CC(char[] file = ""){
	char ent_filename[PLATFORM_MAX_PATH];

	char classname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		if(!StrEqual(classname, "color_correction")) continue;
		if(file[0]){
			GetEntPropString(ent, Prop_Data, "m_lookupFilename", ent_filename, sizeof(ent_filename));
			if(StrContains(ent_filename, file, false) != -1){
				AcceptEntityInput(ent, "Disable");
				//potentially delete the entity, but they get removed after a round end anyway
			}
		}else{
			RemoveEntity(ent);
		}
	}
}

void CREATE_CC(char[] filename, char[] targetname = ""){
	char path[PLATFORM_MAX_PATH];
	FormatEx(path, sizeof(path), "materials/Chaos/ColorCorrection/%s.raw", filename);
	int ent = CreateEntityByName("color_correction");
	if(ent != -1){
		DispatchKeyValue(ent, "StartDisabled", "1");
		DispatchKeyValue(ent, "maxweight", "1.0");
		DispatchKeyValue(ent, "maxfalloff", "-1.0");
		DispatchKeyValue(ent, "minfalloff", "-1.0");
		DispatchKeyValue(ent, "fadeInDuration", "3.0");
		DispatchKeyValue(ent, "fadeOutDuration", "3.0");
		DispatchKeyValue(ent, "filename", path);
		if(targetname[0]) DispatchKeyValue(ent, "targetname", targetname);
		DispatchSpawn(ent);
		ActivateEntity(ent);
		AcceptEntityInput(ent, "Enable");
	}
}
