#pragma semicolon 1

bool SpeedShooter = false;

//TODO:, if someone has speed once this ends, they still have speed
// > try saving their old speed but itll still be fucky
public void Chaos_SpeedShooter(EffectData effect){
	effect.Title = "Speed Shooter";
	effect.Duration = 30;
	effect.AddFlag("movement");
}

public void Chaos_SpeedShooter_START(){
	SpeedShooter = true;
}

public void Chaos_SpeedShooter_RESET(int ResetType){
	SpeedShooter = false;
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
		}
	}
}

public void Chaos_SpeedShooter_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if(SpeedShooter && buttons & IN_ATTACK){
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 5.0);
	}else if(SpeedShooter){
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}