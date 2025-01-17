#pragma semicolon 1

bool OneBulletOneGun = false;

public void Chaos_OneBulletOneGun(EffectData effect){
	effect.Title = "One Bullet One Gun";
	effect.Duration = 30;
	effect.AddFlag("ammo");

	OneBulletOneGun = false;
	HookEvent("weapon_fire", 		Chaos_OneBulletOneGun_Event_OnWeaponFire);
}

char g_OBOG_WeaponName[32];
public void Chaos_OneBulletOneGun_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	event.GetString("weapon", g_OBOG_WeaponName, sizeof(g_OBOG_WeaponName));
	int client = GetClientOfUserId(event.GetInt("userid"));

	if(OneBulletOneGun){
		if(StrContains(g_OBOG_WeaponName, "weapon_knife") == -1){
			CreateTimer(0.1, Timer_GiveRandomWeapon_OneShotOneGun, client);
		}
	}
}

Action Timer_GiveRandomWeapon_OneShotOneGun(Handle timer, int client){
	// GiveAndSwitchWeapon(client, g_sWeapons[GetRandomInt(0, sizeof(g_sWeapons) - 1)]);
	GiveAndSwitchWeapon(client, g_sWeapons[GetURandomInt() % sizeof(g_sWeapons)]);
	return Plugin_Continue;
}


public void Chaos_OneBulletOneGun_START(){
	OneBulletOneGun = true;
}

public void Chaos_OneBulletOneGun_RESET(int ResetType){
	OneBulletOneGun = false;
}