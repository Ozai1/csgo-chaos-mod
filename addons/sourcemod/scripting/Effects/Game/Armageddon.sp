#pragma semicolon 1

/*
	- Raining Explosive barrels
	- Raining Molotovs
	- Green/Blue ish Color Correction
	- Earthquake effect (minimal, but run it every 2-4 seconds)


*/
// wasteland2.raw
// wasteland.raw

bool armageddonMaterials = true;
bool Armageddon = false;
ArrayList ArmageddonEnts;

public void Chaos_Armageddon(EffectData effect){
	effect.Title = "Armageddon";
	effect.Duration = 25;
	effect.IncompatibleWith("Chaos_Thunderstorm");
	effect.IncompatibleWith("Chaos_OilDrums");
	effect.AddFlag("fog");
	
	ArmageddonEnts = new ArrayList();
}

public void Chaos_Armageddon_OnMapStart(){
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/wasteland.raw");
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/wasteland2.raw");
	if(!FileExists("materials/ChaosMod/ColorCorrection/wasteland.raw")) armageddonMaterials = false;
	if(!FileExists("materials/ChaosMod/ColorCorrection/wasteland2.raw")) armageddonMaterials = false;
}


public void Chaos_Armageddon_START(){
	Armageddon = true;
	EnableOilDrums();
	EnableThunderstorm();
	
	CREATE_CC("wasteland");
	ArmageddonEnts.Push(EntIndexToEntRef(SPAWN_WEATHER(RAIN, "Armageddon")));
	ArmageddonEnts.Push(EntIndexToEntRef(SPAWN_WEATHER(SNOWFALL, "Armageddon")));
	ArmageddonEnts.Push(EntIndexToEntRef(SPAWN_WEATHER(SNOW, "Armageddon")));
	ArmageddonEnts.Push(EntIndexToEntRef(SPAWN_WEATHER(ASH, "Armageddon")));

	ArmageddonFog();

	CreateTimer(0.1, Timer_FlashWastelandCC, _,TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(5.0, Timer_FlashWastelandCC, _,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	DispatchKeyValue(0, "skyname", "sky_csgo_cloudy01"); // changing the skybot to rain (unrelated to rain entity)
	CreateTimer(0.1, Timer_LightningStrike);
	CreateTimer(3.0, Timer_SpawnDrums, 15, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(4.0, Timer_SpawnArmageddonMolotovs, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.0, Timer_ArmageddonEarthquake);
	CreateTimer(5.0, Timer_ArmageddonEarthquake, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	
	LoopAlivePlayers(i){
		SetEntityHealth(i, 100);
	}
	
}

Action Timer_ArmageddonEarthquake(Handle timer){
	if(!Armageddon) return Plugin_Stop;
	LoopAlivePlayers(i){
		ScreenShake(i, GetRandomFloat(10.0, 25.0), 3.0);
	}
	return Plugin_Continue;
}


public void Chaos_Armageddon_RESET(int ResetType){
	Armageddon = false;
	DisableThunderstorm();
	DisableOilDrums();
	
	CLEAR_CC("wasteland.raw");
	CLEAR_CC("wasteland2.raw");
	
	ArmageddonFog(true);
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			GivePlayerItem(i, "weapon_healthshot");
		}
	}

	RemoveEntitiesInArray(ArmageddonEnts);
}


Action Timer_FlashWastelandCC(Handle timer, bool SecondFlash = false){
	if(!Armageddon) return Plugin_Stop;
	if(SecondFlash){
		CREATE_CC("wasteland2", "ArmageddonFlash", 0.0, 1.0);
	}else{
		int randomDistant = GetRandomInt(1, 3);

		LoopValidPlayers(i){
			if(randomDistant == 1){
				ClientCommand(i, "playgamesound \"%s\"", THUNDERDISTANT_1);
			}else if(randomDistant == 2){
				ClientCommand(i, "playgamesound \"%s\"", THUNDERDISTANT_2);
			}else if(randomDistant == 3){
				ClientCommand(i, "playgamesound \"%s\"", THUNDERDISTANT_3);
			}
		}
		CREATE_CC("wasteland2", "ArmageddonFlash", 0.0, 0.0);
	}
	CreateTimer(0.1, Timer_DisableWastelandFlash);
	
	if(SecondFlash){
		return Plugin_Stop;
	}else{
		CreateTimer(0.2, Timer_FlashWastelandCC, true);
	}
	return Plugin_Continue;
}

Action Timer_DisableWastelandFlash(Handle timer){
	CLEAR_CC("wasteland2.raw");
	return Plugin_Stop;
}

Action Timer_SpawnArmageddonMolotovs(Handle timer){
	if(!Armageddon) return Plugin_Stop;

	ShuffleMapSpawns();
	
	float pos[3];
	LoopAllMapSpawns(pos, index){
		pos[2] += 100.0;
		int ent = CreateEntityByName("molotov_projectile");
		TeleportEntity(ent, pos, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(ent);
		AcceptEntityInput(ent, "InitializeSpawnFromWorld"); 
		if(index > 15) break;
	}

	return Plugin_Continue;
}

public bool Chaos_Armageddon_Conditions(bool EffectRunRandomly){
	// 25% chance of running
	if((GetURandomInt() % 100) > 75 && EffectRunRandomly) return false;
	
	if(!ValidMapPoints()) return false;
	
	// also checks for oildrum models
	return armageddonMaterials && Chaos_OilDrums_Conditions(false);
}