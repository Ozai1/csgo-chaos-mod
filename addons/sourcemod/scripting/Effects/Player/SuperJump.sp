public void Chaos_SuperJump_START(){
	cvar("sv_jump_impulse", "590");
}

public Action Chaos_SuperJump_RESET(bool HasTimerEnded){
	ResetCvar("sv_jump_impulse", "301", "590");
}