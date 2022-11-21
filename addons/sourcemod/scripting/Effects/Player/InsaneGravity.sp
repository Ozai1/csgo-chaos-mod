public void Chaos_InsaneGravity(effect_data effect){
	effect.Title = "Insane Gravity";
	effect.Duration = 30;
}
//TODO: Re-apply effect when player respawns

public void Chaos_InsaneGravity_START(){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 15.0);
	}
}

public Action Chaos_InsaneGravity_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 1.0);
	}
}