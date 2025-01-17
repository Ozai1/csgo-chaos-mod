#pragma semicolon 1

public void Chaos_RespawnTheDead_Randomly(EffectData effect) {
	effect.Title = "Resurrect dead players in random locations";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
	effect.AddFlag("respawn");
	effect.BlockInCoopStrike = true;
}

public void Chaos_RespawnTheDead_Randomly_START() {
	LoopValidPlayers(i) {
		if(!IsPlayerAlive(i)) {
			CS_RespawnPlayer(i);
			DoRandomTeleport(i);
		}
	}
}

public bool Chaos_RespawnTheDead_Randomly_Conditions(bool EffectRunRandomly) {
	if(GetRoundTime() <= 30 && EffectRunRandomly) return false;
	return true;
}