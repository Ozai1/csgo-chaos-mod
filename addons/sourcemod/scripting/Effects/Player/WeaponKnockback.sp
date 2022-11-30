bool WeaponKnockback = false;

public void Chaos_WeaponKnockback(effect_data effect){
	effect.Title = "Weapon Knockback";
	effect.Duration = 30;
	effect.AddAlias("Push");
}

public void Chaos_WeaponKnockback_START(){
	WeaponKnockback = true;
}

public void Chaos_WeaponKnockback_RESET(){
	WeaponKnockback = false;
}

public void Chaos_WeaponKnockback_INIT(){
	HookEvent("weapon_fire", Chaos_WeaponKnockback_Event_OnWeaponFire);
}

public void  Chaos_WeaponKnockback_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(WeaponKnockback){
		DoKnockback(client, 250.0);
	}
}