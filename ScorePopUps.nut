global function ScoringInit
global function AddStyleEvent


var StyleEventSlot1 = null
var StyleEventSlot2 = null
var StyleEventSlot3 = null
var StyleEventSlot4 = null
var StyleEventSlot5 = null

void function ScoringInit()
{
	entity player = GetLocalClientPlayer()
	AddLocalPlayerDidDamageCallback(OnDamage)
	AddCallback_OnPlayerKilled(KillEvent)
	StyleRuiSetup()
	thread UpdateRankUI()
	TimeSinceLast = Time()
}

	//Khalmee's stuff
	/*
	//This was an attempt to make a background for the meter, but after realizing how big it is i dropped the idea. Experiment with that as you will.
	var cringe = RuiTopology_CreatePlane( <1600,300,0>, <300, 0, 0>, <0, 400, 0>, false ) //(origin, stretchX, stretchY, ?)
	var moreCringe = RuiCreate( $"ui/basic_image.rpak", cringe, RUI_DRAW_HUD, -1 )
    RuiSetFloat3(moreCringe, "basicImageColor", <0,0,0>)
    RuiSetFloat(moreCringe, "basicImageAlpha", 0.5)
	*/
	//end
	
	/*
	Mauer's TO DO:
	-Resolve color conflicts 
	-Add EJECT kill popup, EJECTN'T!/SKEET SHOOTER!
	-Add REVENGE kill popup, REVENGE!
	-Add Kills while going fast / big airtime (with measures!) DRIVE-BY [velocity] KMPH! / ALLEY-OOP [airtime] S!
	-Noscopes
	-colateralls
	*/
	
array < string > SlotStrings = ["", "", "", "", ""]
array < vector > SlotCols = [<0.5, 0.5, 0.5>, <0.5, 0.5, 0.5>, <0.5, 0.5, 0.5>, <0.5, 0.5, 0.5>, <0.5, 0.5, 0.5>]

int StyleStreak = 0
int HeadshotStreak = 0
int Multikill = 0
int AiMultikill = 0
bool Slot1Full = false
int PlayerStreak = 0
#if CLIENT
float TimeSinceLast = 0
float TimeNow = 0
float StyleEventAlpha = 1.0
float StylePosX1 = 0.8
float StylePosY1 = 0.2
vector StylePos1 = < 0.8, 0.2, 0>
vector StylePos2 = <0.92, 0.23, 0>
float hDistance = 0.0
float mDistance = 0.0


array < vector > Rareity = [<0.5, 0.5, 0.5>, <0.9, 0.9, 0.9>, <0.7, 0.5, 0.0>, <1.0, 0.50, 0.0>]



void function KillEvent( ObituaryCallbackParams KillEventPerams ){
	entity player = GetLocalClientPlayer()
		if(KillEventPerams.victim == GetLocalClientPlayer()){ 
		SlotStrings[0] = ("")	//
		SlotStrings[1] = ("")	//
		SlotStrings[2] = ("")	//
		SlotStrings[3] = ("")	//
		SlotStrings[4] = ("")	// Clear pop-ups in case of death, but still allow for "postmortal"
	}
	if(KillEventPerams.attacker == GetLocalClientPlayer()){
		hDistance = Distance(player.EyePosition(), KillEventPerams.victim.GetOrigin())
		mDistance = hDistance * 0.07616/3
		TimeSinceLast = Time()
		StyleStreak++
	//if(KillEventPerams.attacker == GetLocalClientPlayer()){	//Check damageSourceId
		//AddStyleEvent("Kill ID: " + KillEventPerams.damageSourceId, Rareity[1])}
		if(KillEventPerams.victim == GetLocalClientPlayer()){
			AddStyleEvent("", Rareity[2]) //Suicides
		}
		if(KillEventPerams.victim.IsTitan() && KillEventPerams.victimIsOwnedTitan){
			AddStyleEvent( "titan kill", Rareity[1] ) // Titan kill (duh)
			if (KillEventPerams.damageSourceId == 185){
				AddStyleEvent( "Scrapped", Rareity[2] ) //Titan execution
			}
		}
		if(KillEventPerams.victim.IsPlayer() && !KillEventPerams.victimIsOwnedTitan){
			Multikill++
			
			switch(Multikill){
				case 1:

					AddStyleEvent("Pilot Kill", Rareity[1] ) // Pilot kills
					break
				case 2:
					AddStyleEvent( "double down", Rareity[1] ) // Double kill
					break
				case 3:
					AddStyleEvent( "triple threat", Rareity[2] ) // Triple kill
					break
				case 4:
					AddStyleEvent( "quad kill", Rareity[2] ) // Quad kill
					break
			}
			 if (Multikill > 4){
				AddStyleEvent( "carnage ×" + Multikill, Rareity[3] ) // Multikills 
			}
			switch(StyleStreak){
				case 3:
					AddStyleEvent( "killing spree", Rareity[1] ) //Killstreaks 3, 5 and 10
					break
				case 5:
					AddStyleEvent( "rampage", Rareity[2] )	
					break
				case 10:
					AddStyleEvent( "unstoppable", Rareity[3] )				
					break
			}
			if (mDistance >= 33.00 && KillEventPerams.damageSourceId != 107 && KillEventPerams.damageSourceId != 85){
				AddStyleEvent( "longshot " + format("%.2f", mDistance) + " m", Rareity[2] ) //longshots without nades, smokes etc
			}
			if (mDistance <= 3.00 && KillEventPerams.damageSourceId != 151 && KillEventPerams.damageSourceId != 140 && KillEventPerams.damageSourceId != 186 && KillEventPerams.damageSourceId != 185){
				AddStyleEvent( "point blank", Rareity[2] ) //point blank without melees etc
			}
			switch(KillEventPerams.damageSourceId){
				case 110: case 75: case 237: case 40: case 57: case 81:
					AddStyleEvent( "crispy", Rareity[0] )	// Scorch stuff + Firestar
					break										
				case 126: case 135: case 119:				
					AddStyleEvent( "obliterated", Rareity[1] )	// Cold war, EPG, Charge rifle
					break
				case 140:
					AddStyleEvent( "nosebreaker", Rareity[1] ) // Pilot melee
					break
				case 186:
					AddStyleEvent( "finisher", Rareity[2] ) //Pilot execution
					break
				case 45:
					AddStyleEvent( "railed", Rareity[1] ) // Railgun
					break
				case 111:
					AddStyleEvent( "surgical", Rareity[2]) //Pulse blade
					break
				case 85:
					AddStyleEvent( "smoker", Rareity[1]) //Electric smoke nades
					break
				case 107:
					AddStyleEvent( "fragger", Rareity[1]) //Grenades
					break
				case 151:
					AddStyleEvent( "by the sword", Rareity[1] ) //Ronin melee
					break
				case 44:
					AddStyleEvent( "nuke", Rareity[2] )//Nuclear eject
					break
				}
			if(KillEventPerams.victim.IsTitan() && !player.IsTitan()){
				AddStyleEvent( "Bunkerbuster", Rareity[3] ) //Titan kill as pilot
			}
			if(!IsAlive(GetLocalClientPlayer())){
				AddStyleEvent( "postmortal", Rareity[3] ) //kills when player is dead
				}
		}
	}	
}

void function OnDamage(entity player, entity victim, vector Pos, int damageType){
	
	if(damageType & DF_KILLSHOT){

		SlotStrings[0] = ("")
		SlotStrings[1] = ("")
		SlotStrings[2] = ("")
		SlotStrings[3] = ("")
		SlotStrings[4] = ("")
		if(!victim.IsPlayer() && AiMultikill < 1 ){
				AiMultikill++
				AddStyleEvent( "kill", Rareity[0])			// Ai kills
		}
		else if(!victim.IsPlayer()){
				AiMultikill++
				AddStyleEvent( "kill ×" + AiMultikill, Rareity[0]) // Ai kills	
			if(AiMultikill > 3){
				AddStyleEvent( "Farmer", Rareity[2]) // Ai kills
				
				
				AiMultikill = 0
			}
		}
		if(damageType & DF_HEADSHOT){
			AddStyleEvent( "Headshot", Rareity[1]) // headshots
		}
		if(damageType & DF_CRITICAL){
			AddStyleEvent( "Critical", Rareity[1]) // crits on titans
		}
	}

}



void function AddStyleEvent( string name, vector rarity ){
	if (Slot1Full == false){
		SlotStrings[4] = (name + "!")
		SlotCols[4] = rarity
		Slot1Full = true
		StyleEventAlpha = 1.0

		TimeSinceLast = Time()
		if(SlotStrings[3] == ("")){
				SlotStrings[3] = SlotStrings[4]
				SlotCols[3] = SlotCols[4]
				SlotStrings[4] = ("")
				Slot1Full = false
			}
		if(SlotStrings[2] == ("")){
				SlotStrings[2] = SlotStrings[3]
				SlotCols[2] = SlotCols[3]
				SlotStrings[3] = ("")
			}
		if(SlotStrings[1] == ("")){
				SlotStrings[1] = SlotStrings[2]
				SlotCols[1] = SlotCols[2]
				SlotStrings[2] = ("")
			}
		if(SlotStrings[0] == ("")){
				SlotStrings[0] = SlotStrings[1]
				SlotCols[0] = SlotCols[1]
				SlotStrings[1] = ("")
			}
	}
		SlotCols[0] = rarity
		TimeSinceLast = Time()
		StyleEventAlpha = 1.0

	}

  

void function UpdateRankUI(){
	while(true){
		TimeNow = Time()
		//Khalmee's
		//Functions adding speed and air time bonuses encased in an IF containing various edge cases.
		//For now I'm turning Air time gain off, since it has problems with match intro and dropping titans, besides that it works fine but I'm not satisfied.
		if(!IsLobby() && !IsWatchingReplay() && GetLocalClientPlayer() != null && IsAlive(GetLocalClientPlayer())){
			AddStyleFromSpeed()
			//AddStyleFromAirTime()
		}
		//end
		//Refresh the Rui of the style meter
		RuiSetFloat2(StyleEventSlot1, "msgPos", StylePos1 + < -0.24, 0.27, 0>)
		RuiSetFloat(StyleEventSlot1, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot1, "msgColor", SlotCols[0])
		RuiSetString(StyleEventSlot1, "msgText", SlotStrings[0])

		RuiSetFloat2(StyleEventSlot2, "msgPos", StylePos1 + < -0.24, 0.30, 0>)
		RuiSetFloat(StyleEventSlot2, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot2, "msgColor", SlotCols[1])
		RuiSetString(StyleEventSlot2, "msgText", SlotStrings[1])
	
		RuiSetFloat2(StyleEventSlot3, "msgPos", StylePos1 + < -0.24, 0.32, 0>)
		RuiSetFloat(StyleEventSlot3, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot3, "msgColor", SlotCols[2])
		RuiSetString(StyleEventSlot3, "msgText", SlotStrings[2])
	
		RuiSetFloat2(StyleEventSlot4, "msgPos", StylePos1 + < -0.24, 0.34, 0>)
		RuiSetFloat(StyleEventSlot4, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot4, "msgColor", SlotCols[3])
		RuiSetString(StyleEventSlot4, "msgText", SlotStrings[3])
		
		RuiSetFloat2(StyleEventSlot5, "msgPos", StylePos1 + < -0.24, 0.36, 0>)
		RuiSetFloat(StyleEventSlot5, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot5, "msgColor", SlotCols[4])
		RuiSetString(StyleEventSlot5, "msgText", SlotStrings[4])
		
		if((TimeNow - TimeSinceLast) > 4){
			Multikill = 0
			AiMultikill = 0
		}
		if(((TimeNow - TimeSinceLast) > 1.4)){
			StyleEventAlpha = StyleEventAlpha - 0.02

			if((TimeNow - TimeSinceLast) > 1.8){
				SlotStrings[0] = ""
				SlotStrings[1] = ""
				SlotStrings[2] = ""
				SlotStrings[3] = ""
				SlotStrings[4] = ""
			}
		}
		WaitFrame()
		if(!IsLobby()){ // Reset on death
			if(!IsAlive(GetLocalClientPlayer()))
			{
			StyleStreak = 0
			Multikill = 0
			AiMultikill = 0
			}
		}
	}
	RuiDestroy(StyleEventSlot1)
	RuiDestroy(StyleEventSlot2)
	RuiDestroy(StyleEventSlot3)
	RuiDestroy(StyleEventSlot4)
	RuiDestroy(StyleEventSlot5)
}


void function StyleRuiSetup(){ // Puting these here to make me seam more orgainsed than I am :)
	StyleEventSlot1 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot2 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot3 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot4 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot5 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)




	//Slot 1
	RuiSetInt(StyleEventSlot1, "maxLines", 1)
	RuiSetInt(StyleEventSlot1, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot1, "msgPos", <StylePosX1, StylePosY1 + 1, 0>)
	RuiSetFloat(StyleEventSlot1, "msgFontSize", 37.0)
	RuiSetFloat(StyleEventSlot1, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot1, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot1, "msgColor", SlotCols[0])
	RuiSetString(StyleEventSlot1, "msgText", SlotStrings[0])
	//Slot 2
	RuiSetInt(StyleEventSlot2, "maxLines", 1)
	RuiSetInt(StyleEventSlot2, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot2, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot2, "msgFontSize", 30.0)
	RuiSetFloat(StyleEventSlot2, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot2, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot2, "msgColor", SlotCols[1])
	RuiSetString(StyleEventSlot2, "msgText", SlotStrings[1])
	//Slot 3	
	RuiSetInt(StyleEventSlot3, "maxLines", 1)
	RuiSetInt(StyleEventSlot3, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot3, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot3, "msgFontSize", 30.0)
	RuiSetFloat(StyleEventSlot3, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot3, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot3, "msgColor", SlotCols[2])
	RuiSetString(StyleEventSlot3, "msgText", SlotStrings[2])
	//Slot 4	
	RuiSetInt(StyleEventSlot4, "maxLines", 1)
	RuiSetInt(StyleEventSlot4, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot4, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot4, "msgFontSize", 30.0)
	RuiSetFloat(StyleEventSlot4, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot4, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot4, "msgColor", SlotCols[3])
	RuiSetString(StyleEventSlot4, "msgText", SlotStrings[3])
	//Slot 5
	RuiSetInt(StyleEventSlot5, "maxLines", 1)
	RuiSetInt(StyleEventSlot5, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot5, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot5, "msgFontSize", 30.0)
	RuiSetFloat(StyleEventSlot5, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot5, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot5, "msgColor", SlotCols[4])
	RuiSetString(StyleEventSlot5, "msgText", SlotStrings[4])
}


//Khalmee's stuff
/*
Goals:
-Speed calculation:
Every 2-3 seconds get the average speed by adding up the samples and dividing them by their amount, add that as points
Every 3 continuous cycles add movement bonus
(Some aspects came out differently, but DONE)
-Air time calculation:
If not touching the ground for 3+ seconds, give points
(Has issues, look in main loop)
-Points for AI kills
Requires modifying LocalPlayerDidDamageCallback, check if victim is not player and if you're not in replay
(TODO)
*/
array < float > SpeedBuffer //Where speed samples are stored
float LastSpeedMeasurement = 0 //Last point in time when speed was measured
float LastTimeTouchingGround = 10 
float TimeToBeat = 3 //Next Air Time bonus
int movementChain = 0 //Number of consecutive speed bonuses

float function GetSpeed(entity ent){ //returns horizontal speed of an entity
	vector vel = ent.GetVelocity()
	return sqrt(vel.x * vel.x + vel.y * vel.y) * (0.274176/3) //the const is for measurement in kph
}

void function AddStyleFromSpeed(){ //Adds style points based on speed 
	entity p = GetLocalClientPlayer()
	float cumsum = 0 //Cumulative sum, what else did you think it means?
	float avgSpeed = 0
	SpeedBuffer.append(GetSpeed(p)) //Add current speed to the buffer
	if(Time() - LastSpeedMeasurement > 5){ //Every N seconds, check the average and apply bonuses (adjust the time)
		foreach(SpeedSample in SpeedBuffer){ //sum up speed
			cumsum += SpeedSample
		}
		avgSpeed = cumsum/SpeedBuffer.len() //and get the average

		//These values should be tweaked, speed:
		//36, 48, 60, 72
		if(!p.IsTitan()){
		if(avgSpeed < 36){
			movementChain = 0
		}
		else if(avgSpeed < 48){
			AddStyleEvent( "speed", Rareity[1])
			movementChain++
		}
		else if(avgSpeed < 60){
			
			AddStyleEvent( "speed lv.2", Rareity[1])
			movementChain++
		}
		else if(avgSpeed < 72){
			
		AddStyleEvent( "speed lv.3", Rareity[1])
			movementChain++
		}
		else{
			AddStyleEvent( "speed demon", Rareity[1])
			movementChain++
		}

		//Same here, movement:
		switch(movementChain){
			case 3:		
				AddStyleEvent( "movement", Rareity[1])
				break
			case 6:	
				AddStyleEvent( "parkour", Rareity[1])
				break
			default:
				if(movementChain % 3 == 0 && movementChain >= 9)
				AddStyleEvent( "movement god", Rareity[1])
				break
		}}

		SpeedBuffer.clear() //eat up the buffer
		LastSpeedMeasurement = Time()
	}
}

void function AddStyleFromAirTime(){ //Air time bonus
	entity p = GetLocalClientPlayer()
	if(!p.IsOnGround() && !IsSpectating()){ //there should be some sort of check to see if player is in control
		if(Time() - LastTimeTouchingGround > TimeToBeat){
			AddStyleEvent( "alley-oop", Rareity[1])
			TimeToBeat += 3
		}
	}
	else
	{
		TimeToBeat = 3
		LastTimeTouchingGround = Time()
	}
}
//end

#endif