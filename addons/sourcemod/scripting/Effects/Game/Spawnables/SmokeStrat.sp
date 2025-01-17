#pragma semicolon 1

public void Chaos_SmokeStrat(EffectData effect) {
	effect.Title = "Smoke Strat";
	effect.HasNoDuration = true;
}

public void Chaos_SmokeStrat_START() {
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++) {
		if(GetRandomInt(0, 100) <= 25) {
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			if(IsCoopStrike() && DistanceToClosestPlayer(vec) > MAX_COOP_SPAWNDIST) continue;
			CreateParticle("explosion_smokegrenade_fallback", vec);
		}
	}
	LoopValidPlayers(i) {
		ClientCommand(i, "playgamesound \"weapons/smokegrenade/smoke_emit.wav\"");
	}
}

public bool Chaos_SmokeStrat_Conditions(bool EffectRunRandomly) {
	if(!ValidMapPoints()) return false;
	return true;
}