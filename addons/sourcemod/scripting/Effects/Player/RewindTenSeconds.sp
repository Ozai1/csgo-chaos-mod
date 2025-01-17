#pragma semicolon 1

bool g_bRewind_logging_enabled = true;
bool g_Rewinding = false;
int g_RewindTime = 0;


#define g_RollbackFrames 640 //64tick by 10 seconds; 128tick servers will replay in 5 seconds

float g_RollbackPositions[MAXPLAYERS+1][g_RollbackFrames][3];
float g_RollbackAngles[MAXPLAYERS+1][g_RollbackFrames][3];

public void Chaos_RewindTenSeconds(EffectData effect){
	effect.Title = "Rewind 10 Seconds";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.AddFlag("movement");
	effect.RunForwardWhileInactive("OnGameFrame");
	effect.BlockInCoopStrike = true;

	HookEvent("round_start", Chaos_RewindTenSeconds_Event_RoundStart);
}

public void Chaos_RewindTenSeconds_Event_RoundStart(Event event, char[] name, bool dontBroadcast){
	g_bRewind_logging_enabled = true;
}

public void Chaos_RewindTenSeconds_OnGameFrame(){
	Rollback_Log();
}


public void Chaos_RewindTenSeconds_START(int ResetType){
	g_bRewind_logging_enabled = false;
	g_Rewinding = true;
	g_RewindTime = 0;

	int seconds = 5;
	
	float tickrate = 1.0 / GetTickInterval();
	char announceMsg[128];
	if (RoundToZero(tickrate) == 128.0){
		seconds = 5;
	}else if(RoundToZero(tickrate) == 64.0){
		seconds = 10;
	}

	if(TranslationPhraseExists("Chaos_RewindTenSeconds_Custom") && IsTranslatedForLanguage("Chaos_RewindTenSeconds_Custom", LANG_SERVER)){
			FormatEx(announceMsg, sizeof(announceMsg), "%T", "Chaos_RewindTenSeconds_Custom", LANG_SERVER, seconds);
	}else{
		FormatEx(announceMsg, sizeof(announceMsg), "Rewind %i Seconds", seconds);
	}

	AnnounceChaos(announceMsg, -1.0);
}


public void Chaos_RewindTenSeconds_RESET(int ResetType){
	g_bRewind_logging_enabled = true;
	g_Rewinding = true;
	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}

public bool Chaos_RewindTenSeconds_Conditions(bool EffectRunRandomly){
	if(GetRoundTime() <= 20 && EffectRunRandomly) return false;
	return true;
}


// float rollback_location[3];
public void Rollback_Log(){
	if(g_bRewind_logging_enabled){
		LoopAlivePlayers(client){
			int count = g_RollbackFrames - 1;
			while(count >= 1){
				g_RollbackPositions[client][count] = g_RollbackPositions[client][count - 1];
				g_RollbackAngles[client][count] = g_RollbackAngles[client][count - 1];
				count--;
			}
			GetClientAbsOrigin(client, g_RollbackPositions[client][0]);
			GetClientEyeAngles(client, g_RollbackAngles[client][0]);
		}
	}else if(g_Rewinding){
		if(g_RewindTime <= (g_RollbackFrames - 1)){
			LoopAlivePlayers(i){
				float loc[3];
				float angles[3];
				loc = g_RollbackPositions[i][g_RewindTime];
				angles =  g_RollbackAngles[i][g_RewindTime];
				
				if(loc[0] != 0.0 || loc[1] != 0.0 || loc[2] != 0.0){
					if(angles[0] != 0.0 || angles[1] != 0.0 || angles[2] != 0.0){
						SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.0);
						TeleportEntity(i, loc, angles, NULL_VECTOR);
					}
				}
			}
		}

		if(g_RewindTime < (g_RollbackFrames - 1)){
			g_RewindTime++;
		}else{
			g_bRewind_logging_enabled = true;
			g_Rewinding = false;
			Chaos_RewindTenSeconds_RESET(true);
		}
	}
}


