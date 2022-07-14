//hook

public Action Chaos_KnifeFight_Hook_WeaponSwitch(int client, int weapon){
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(g_bKnifeFight > 0){
		if(StrContains(WeaponName, "knife") == -1 &&
			StrContains(WeaponName, "c4") == -1){
				FakeClientCommand(client, "use weapon_knife");
				return Plugin_Handled;
		}else{
			return Plugin_Continue;
		}
	}
	return Plugin_Continue;

}


public void Chaos_KnifeFight_START(){
	g_bKnifeFight++;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			FakeClientCommand(i, "use weapon_knife");
		}
	}
}

public Action Chaos_KnifeFight_RESET(bool EndChaos){
	if(g_bKnifeFight > 0) g_bKnifeFight--;
	if(EndChaos){ 
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i) && !HasMenuOpen(i)) ClientCommand(i, "slot1");
	}
}


public bool Chaos_KnifeFight_HasNoDuration(){
	return false;
}

public bool Chaos_KnifeFight_Conditions(){
	return true;
}