/*
    Eventlistening
*/

enum EVENT_TYPE {
    IMPACT,
    PLAYER_SAY,
    PLAYER_SPAWN,
    TEAM_CHANGE,
}

event_template <- {};
event_template[EVENT_TYPE.IMPACT] <- ["bullet_impact", ["userid","vector"]];
event_template[EVENT_TYPE.PLAYER_SAY] <- ["player_say", ["userid","text"]];
event_template[EVENT_TYPE.PLAYER_SPAWN] <- ["player_spawn", ["userid","teamnum"]];
event_template[EVENT_TYPE.TEAM_CHANGE] <- ["team_change", ["userid", "team", "oldteam", "disconnect", "autoteam", "silent", "isbot"]];

::PLAYER_WHITE_EVENTS <- {
    ATTACK = false,
}
::PLAYER_BLACK_EVENTS <- {
    ATTACK = false,
}

::dispatch_events <- function() {
    PLAYER_WHITE_EVENTS.ATTACK = false;
    PLAYER_BLACK_EVENTS.ATTACK = false;
}

/*
    Player trace
*/
function update_player_traces() {
    if (player_white != null && trace_orig_ply_white != null) {
        player_white.forward_vector = trace_orig_ply_white.GetForwardVector();
    }

    if (player_black != null && trace_orig_ply_black != null) {
        player_black.forward_vector = trace_orig_ply_black.GetForwardVector();
    }
}

::OnGameEvent_player_attack <- function (player_number) {
    if (player_number == 1) { PLAYER_WHITE_EVENTS.ATTACK = true; }
    else if (player_number == 2) { PLAYER_BLACK_EVENTS.ATTACK = true; }
}

::OnGameEvent_team_change <- function (userid, team, oldteam, disconnect, autoteam, silent, isbot) {
    if (disconnect) {
        reset_session();
    }
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
