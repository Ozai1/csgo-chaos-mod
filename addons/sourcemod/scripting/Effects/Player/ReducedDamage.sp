#pragma semicolon 1

bool ReducedDamage = false;

public void Chaos_ReducedDamage(EffectData effect){
	effect.Title = "Half Shot Damage"; 
	effect.Duration = 30;
	effect.AddAlias("HalfDamage");
	effect.AddAlias("ReduceDamage");
	effect.IncompatibleWith("Chaos_VampireHeal");
}

public void Chaos_ReducedDamage_START(){
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_OnTakeDamage, Chaos_ReducedDamage_Hook_OnTakeDamage);
	}
	ReducedDamage = true;
}

public void Chaos_ReducedDamage_RESET(int ResetType){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_OnTakeDamage, Chaos_ReducedDamage_Hook_OnTakeDamage);
	}
	ReducedDamage = false;
}

public Action Chaos_ReducedDamage_Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype){
	if(ReducedDamage){
		if(ValidAndAlive(victim) && ValidAndAlive(inflictor)){
			if(GetClientTeam(victim) != GetClientTeam(inflictor)){
				damage = damage / 2.0;
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}