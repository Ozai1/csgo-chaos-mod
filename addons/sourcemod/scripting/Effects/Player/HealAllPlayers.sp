public void Chaos_HealAllPlayers(effect_data effect){
	effect.HasNoDuration = true;
}

public void Chaos_HealAllPlayers_START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, 100);
	}
}