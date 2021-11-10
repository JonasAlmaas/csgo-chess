/*
    Eventlistening
*/

EVENT_PLAYER_HURT <- 1;
EVENT_BULLET_IMPACT <- 2;
EVENT_PLAYER_SAY <- 3;
EVENT_SERVER_CVAR <- 4;

event_template<-{};
event_template[EVENT_PLAYER_HURT]<-["player_hurt",["userid","attacker","health","armor","weapon","dmg_health","dmg_armor","hitgroup"]];
event_template[EVENT_BULLET_IMPACT]<-["bullet_impact",["userid","vector"]];
event_template[EVENT_PLAYER_SAY]<-["player_say",["userid","text"]];
event_template[EVENT_SERVER_CVAR]<-["server_cvar",["cvarname","cvarvalue"]];

::PLAYER_1_EVENTS <- {
    BULLET_FIERED = false,
}
::PLAYER_2_EVENTS <- {
    BULLET_FIERED = false,
}

::DispatchEvents <- function() {
    PLAYER_1_EVENTS.BULLET_FIERED = false;
    PLAYER_2_EVENTS.BULLET_FIERED = false;
}

/*
    Player trace
*/
::trace_orig_ply1 <- null;
::trace_orig_ply2 <- null;
function update_player_traces() {
    
    // Player 1
    if (player1 != null) {
        if (trace_orig_ply1 != null) {
            player1.forwardVector = trace_orig_ply1.GetForwardVector();
        }
        else if (trace_orig_ply1 == null && EntityGroup) {
            trace_orig_ply1 = EntityGroup[0];
            EntFireByHandle(player1.ref, "AddOutput", "targetname ply1", 0.0, null, null);
            EntFire("tr_lmm_ply1", "SetMeasureTarget", "ply1", 0.01, null);
        }
    }
    
    // Player 2
    if (player2 != null) {
        if (trace_orig_ply2 != null) {
            player2.forwardVector = trace_orig_ply2.GetForwardVector();
        }
        else if (trace_orig_ply2 == null && EntityGroup) {
            trace_orig_ply2 = EntityGroup[1];
            EntFireByHandle(player2.ref, "AddOutput", "targetname ply2", 0.0, null, null);
            EntFire("tr_lmm_ply2", "SetMeasureTarget", "ply2", 0.01, null);
        }
    }
}

/*
    Player attack
*/
EVENT_LAST_BULLET_TIME <- Time();
::OnGameEvent_bullet_impact <- function(userid, pos) {
    if(EVENT_LAST_BULLET_TIME != Time()){
        PLAYER_1_EVENTS.BULLET_FIERED = true;
        PLAYER_2_EVENTS.BULLET_FIERED = true;
        
        EVENT_LAST_BULLET_TIME = Time();
    }
}

::OnGameEvent_player_hurt <- function(userid, attacker, health, armor, weapon, dmg_health, dmg_armor, hitgroup) {}

::OnGameEvent_player_say <- function(userid, text) {
    console.chat(userid + " : " + text);
}

::OnGameEvent_server_cvar <- function(name, value) {
    console.chat(name + " : " + value);
}

::OnEventFired <- function(EVENT_ID) {
    local name="OnGameEvent_" + event_template[EVENT_ID][0];
    local order=event_template[EVENT_ID][1];
    local args={};
    local vector=Vector(0,0,0);
    local writedx=false;
    local writedy=false;
    local writedz=false;
    foreach (key,arg in this.event_data){
        local shouldwrite=true;
        if (key=="x" || key=="pos_x" || key=="start_x" || key=="ang_x"){ vector.x=arg; writedx=true; shouldwrite=false; }
        if (key=="y" || key=="pos_y" || key=="start_y" || key=="ang_y"){ vector.y=arg; writedy=true; shouldwrite=false; }
        if (key=="z" || key=="pos_z" || key=="start_z" || key=="ang_z"){ vector.z=arg; writedz=true; shouldwrite=false; }
        if (writedx && writedy && writedz){ foreach (index,k in order){ if (k=="vector"){ args[index+1]<-vector; writedx=false; writedy=false; writedz=false; break; }}}
        if (shouldwrite){ foreach (index,k in order){ if (k==key){ args[index+1]<-arg; break; }}}
    }
    switch (args.len()){
        case 0:getroottable()[name]();break;
        case 1:getroottable()[name](args[1]);break;
        case 2:getroottable()[name](args[1],args[2]);break;
        case 3:getroottable()[name](args[1],args[2],args[3]);break;
        case 4:getroottable()[name](args[1],args[2],args[3],args[4]);break;
        case 5:getroottable()[name](args[1],args[2],args[3],args[4],args[5]);break;
        case 6:getroottable()[name](args[1],args[2],args[3],args[4],args[5],args[6]);break;
        case 7:getroottable()[name](args[1],args[2],args[3],args[4],args[5],args[6],args[7]);break;
        case 8:getroottable()[name](args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);break;
        case 9:getroottable()[name](args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);break;
        case 10:getroottable()[name](args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]);break;
    }
}
