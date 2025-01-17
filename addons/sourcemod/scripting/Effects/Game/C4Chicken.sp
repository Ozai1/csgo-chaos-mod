#pragma semicolon 1

bool g_bC4Chicken = false;
bool g_bVisibleChicken = true;
int	 g_iC4ChickenEnt = -1;

int	 GetC4ChickenEntity() {
	 return g_iC4ChickenEnt;
}

public void Chaos_C4Chicken(EffectData effect) {
	effect.Title = "C4 Chicken";
	effect.HasNoDuration = true;
	effect.BlockInCoopStrike = true;

	HookEvent("bomb_planted", Chaos_C4Chicken_Event_BombPlanted);
	HookEvent("round_start", Chaos_C4Chicken_Event_RoundStart);
}

public void Chaos_C4Chicken_Event_RoundStart(Event event, char[] name, bool dontBroadcast) {
	g_bC4Chicken = false;
}

public void Chaos_C4Chicken_START() {
	g_bC4Chicken = true;
	CreateTimer(1.0, Timer_DelayC4Chicken);
}

public void Chaos_C4Chicken_RESET(int ResetType) {
	if(IsValidEntity(g_iC4ChickenEnt) && g_iC4ChickenEnt > 0) {
		SetEntProp(g_iC4ChickenEnt, Prop_Data, "m_takedamage", 2);
	}

	g_bC4Chicken = false;
	g_iC4ChickenEnt = -1;
}

public bool Chaos_C4Chicken_Conditions(bool EffectRunRandomly) {
	if(g_iC4ChickenEnt != -1) return false;
	if(IsHostageMap()) return false;
	if(!GameModeUsesC4()) return false;
	return true;
}

public void C4Chicken() {
	if(!g_bC4Chicken) return;

	int c4 = -1;
	c4 = FindEntityByClassname(c4, "planted_c4");
	if(c4 != -1) {

		int chicken = CreateEntityByName("chicken");
		if(chicken != -1) {
			float pos[3];
			GetEntPropVector(c4, Prop_Data, "m_vecOrigin", pos);

			TeleportEntity(chicken, pos, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(chicken);
			SetEntProp(chicken, Prop_Data, "m_takedamage", 0);
			SetEntProp(chicken, Prop_Send, "m_fEffects", 0);

			// pos[2] -= 15.0;
			float origin[3] = {0.0, 0.0, 0.0};
			pos[2] += 15.0;
			TeleportEntity(c4, pos, origin, NULL_VECTOR);
			SetVariantString("!activator");
			AcceptEntityInput(c4, "SetParent", chicken, c4, 0);
			g_iC4ChickenEnt = chicken;
			if(g_bVisibleChicken) {
				// pos[2] += 15.0;
				TeleportEntity(chicken, NULL_VECTOR, NULL_VECTOR, NULL_VECTOR);
			} else {
				SetEntityRenderMode(chicken, RENDER_NONE);
			}
		}
	}
}

public void Chaos_C4Chicken_Event_BombPlanted(Handle event, char[] name, bool dontBroadcast) {
	CreateTimer(1.0, Timer_DelayC4Chicken);
}

public Action Timer_DelayC4Chicken(Handle timer) {
	C4Chicken();
	return Plugin_Stop;
}