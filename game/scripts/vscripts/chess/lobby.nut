
/*
    Info Targets
*/

local count_down_target_white = null;
local count_down_target_black = null;
local fall_off_target = null;
count_down_target_white = Entities.FindByName(count_down_target_white, "target_lobby_count_down_white");
count_down_target_black = Entities.FindByName(count_down_target_black, "target_lobby_count_down_black");
fall_off_target = Entities.FindByName(fall_off_target, "target_lobby_fall_off");
::lobby_count_down_white_pos <- count_down_target_white.GetOrigin();
::lobby_count_down_black_pos <- count_down_target_black.GetOrigin();
::lobby_fall_off_pos <- fall_off_target.GetOrigin();

/*
    info Teleport Destination
*/

::teleport_target_white <- null;
::teleport_target_black <- null;
teleport_target_white = Entities.FindByName(teleport_target_white, "teleport_target_white");
teleport_target_black = Entities.FindByName(teleport_target_black, "teleport_target_black")


::new_lobby <- function () {

    local lobby = {
        waiting = true,

        font_size = 100,
        text_color_white = [40,40,40],
        text_color_black = [190,190,190],
        count_down_time = 6.0,

        count_down_text_1 = null,
        count_down_text_2 = null,

        players_in_white = [],
        players_in_black = [],

        time_count_down_start = null,

        function reset() {
            waiting = true;
            time_count_down_start = null;

            if (count_down_text_1 != null) { count_down_text_1.kill(); }
            if (count_down_text_2 != null) { count_down_text_2.kill(); }
        }

        function update() {
            if (players_in_white.len() > 0 && players_in_black.len() > 0) {

                local time_left = floor(count_down_time - (Time() - time_count_down_start));

                if (count_down_text_1 != null) { count_down_text_1.kill(); }
                if (count_down_text_2 != null) { count_down_text_2.kill(); }

                count_down_text_1 = new_dynamic_text("" + time_left, font_size, "kanit_semibold", text_color_white, "center_center", lobby_count_down_white_pos, Vector(0,270));
                count_down_text_2 = new_dynamic_text("" + time_left, font_size, "kanit_semibold", text_color_black, "center_center", lobby_count_down_black_pos, Vector(0,90));

                if (time_left <= 0) {
                    // Create players
                    local target = null;
                    while ((target = Entities.FindByClassname(target, "*player*")) != null) {
                        if (target.GetClassname() == "player") {
                            local pos = target.GetOrigin();

                            if (math.vec_equal(pos, players_in_white[0].GetOrigin())) {
                                player_white = new_player(target);
                            }
                            else if (math.vec_equal(pos, players_in_black[0].GetOrigin())) {
                                player_black = new_player(target);
                            }
                        }
                    }

                    // +attack listener
                    EntFireByHandle(ENTITY_GROUP[2], "Activate", "", 0.0, player_white.ref, null);
                    EntFireByHandle(ENTITY_GROUP[3], "Activate", "", 0.0, player_black.ref, null);

                    // Bind trace targets
                    EntFireByHandle(player_white.ref, "AddOutput", "targetname ply1", 0.0, null, null);
                    EntFire("tr_lmm_ply1", "SetMeasureTarget", "ply1", 0.01, null);

                    EntFireByHandle(player_black.ref, "AddOutput", "targetname ply2", 0.0, null, null);
                    EntFire("tr_lmm_ply2", "SetMeasureTarget", "ply2", 0.01, null);

                    // Teleport players to the map
                    player_white.teleport(teleport_target_white.GetOrigin(), teleport_target_white.GetAngles());
                    player_black.teleport(teleport_target_black.GetOrigin(), teleport_target_black.GetAngles());

                    waiting = false;
                }
            }
            else if (IS_DEBUGGING_SINGLE_PLAYER && players_in_white.len() > 0) {
                local target = null;
                while ((target = Entities.FindByClassname(target, "*player*")) != null) {
                    if (target.GetClassname() == "player") {
                        local pos = target.GetOrigin();

                        if (math.vec_equal(pos, players_in_white[0].GetOrigin())) {
                            player_white = new_player(target);
                            player_black = new_player(target);
                            break;
                        }
                    }
                }

                EntFireByHandle(ENTITY_GROUP[2], "Activate", "", 0.0, player_white.ref, null);

                EntFireByHandle(player_white.ref, "AddOutput", "targetname ply1", 0.0, null, null);
                EntFire("tr_lmm_ply1", "SetMeasureTarget", "ply1", 0.01, null);

                player_white.teleport(teleport_target_white.GetOrigin(), teleport_target_white.GetAngles());

                waiting = false;
            }
            else {
                time_count_down_start = Time();

                if (count_down_text_1 != null) { count_down_text_1.kill(); }
                if (count_down_text_2 != null) { count_down_text_2.kill(); }
            }
        }
    }

    return lobby;
}

::lobby_enter_zone_white <- function () {
    lobby.players_in_black = remove_player_from_team(activator, lobby.players_in_black);

    if (!utils.list_contains(activator, lobby.players_in_white)) {
        lobby.players_in_white.append(activator);
    }
}

::lobby_exit_zone_white <- function () {
    lobby.players_in_white = remove_player_from_team(activator, lobby.players_in_white);
}

::lobby_enter_zone_black <- function () {
    lobby.players_in_white = remove_player_from_team(activator, lobby.players_in_white);

    if (!utils.list_contains(activator, lobby.players_in_black)) {
        lobby.players_in_black.append(activator);
    }
}

::lobby_exit_zone_black <- function () {
    lobby.players_in_black = remove_player_from_team(activator, lobby.players_in_black);
}

::remove_player_from_team <- function (player, team) {
    local new_team = [];

    foreach (p in team) {
        if (p != player)
            new_team.append(player);
    }

    return new_team;
}

::lobby_fall_off <- function () {
    activator.SetOrigin(lobby_fall_off_pos);
}





/*
::lobby_enter_zone <- function (team) {
    if (team == TEAM.WHITE) {
        if (!utils.list_contains(activator, lobby.players_in_white)) {
            lobby.players_in_white.append(activator);
        }
    }
    else if (team == TEAM.BLACK) {
        if (!utils.list_contains(activator, lobby.players_in_black)) {
            lobby.players_in_black.append(activator);
        }
    }
}

::lobby_exit_zone <- function (team) {
    if (team == TEAM.WHITE) {
        local new_players_in_white = [];

        foreach (player in lobby.players_in_white) {
            if (player != activator) { new_players_in_white.append(activator); }
        }

        lobby.players_in_white = new_players_in_white;
    }
    else if (team == TEAM.BLACK) {
        local new_players_in_black = [];
        
        foreach (player in lobby.players_in_black) {
            if (player != activator) { new_players_in_black.append(activator); }
        }

        lobby.players_in_black = new_players_in_black;
    }
}
*/
