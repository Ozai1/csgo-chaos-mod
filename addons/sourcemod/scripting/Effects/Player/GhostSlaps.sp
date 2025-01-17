#pragma semicolon 1

Handle Chaos_RandomSlap_Timer = INVALID_HANDLE;

public void Chaos_GhostSlaps(EffectData effect) {
	effect.Title = "Ghost Slaps";
	effect.Duration = 30;
	effect.BlockInCoopStrike = true;
}

public void Chaos_GhostSlaps_START() {
	Chaos_RandomSlap_Timer = CreateTimer(6.0, Timer_RandomSlap, _, TIMER_REPEAT);
	LoopValidPlayers(client) {
		SDKHook(client, SDKHook_OnTakeDamage, GhostSlaps_OnTakeDamage);
	}
}

public void Chaos_GhostSlaps_RESET(int ResetType) {
	StopTimer(Chaos_RandomSlap_Timer);
	if(ResetType & RESET_EXPIRED) {
		LoopValidPlayers(client) {
			SDKUnhook(client, SDKHook_OnTakeDamage, GhostSlaps_OnTakeDamage);
		}
	}
}

Action Timer_RandomSlap(Handle timer) {
	// play sound? or do ghost slaps make no noise at all? { o.o }
	float vec[3];
	LoopAlivePlayers(client) {
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vec);
		float x = (GetRandomInt(0, 100) < 50) ? GetRandomFloat(-600.0, -300.0) : GetRandomFloat(300.0, 600.0);
		float y = (GetRandomInt(0, 100) < 50) ? GetRandomFloat(-600.0, -300.0) : GetRandomFloat(300.0, 600.0);
		float z = GetRandomFloat(300.0, 600.0);
		vec[0] = vec[0] + x;
		vec[1] = vec[1] + y;
		vec[2] = vec[2] + z;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec);
		CPrintToChat(client, "What was that?");
	}
	return Plugin_Continue;
}

public Action GhostSlaps_OnTakeDamage(int client, int &attacker, int &inflictor, float &damage, int &damagetype) {
	if(Chaos_RandomSlap_Timer == INVALID_HANDLE) return Plugin_Continue;
	if(damagetype & DMG_FALL) return Plugin_Handled;
	return Plugin_Continue;
}