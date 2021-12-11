
/*
    Info Targets
*/

local count_down_target_1 = null;
local count_down_target_2 = null;
local fall_off_target = null;
count_down_target_1 = Entities.FindByName(count_down_target_1, "target_lobby_count_down1");
count_down_target_2 = Entities.FindByName(count_down_target_2, "target_lobby_count_down2");
fall_off_target = Entities.FindByName(count_down_target_2, "target_lobby_fall_off");
::lobby_count_down_1_pos <- count_down_target_1.GetOrigin();
::lobby_count_down_2_pos <- count_down_target_2.GetOrigin();
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

        font_size = 200,
        text_color = [190,190,190],
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

                count_down_text_1 = new_dynamic_text("" + time_left, font_size, "kanit_semibold", text_color, "center_center", lobby_count_down_1_pos, Vector(0,270));
                count_down_text_2 = new_dynamic_text("" + time_left, font_size, "kanit_semibold", text_color, "center_center", lobby_count_down_2_pos, Vector(0,90));

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
            else {
                time_count_down_start = Time();

                if (count_down_text_1 != null) { count_down_text_1.kill(); }
                if (count_down_text_2 != null) { count_down_text_2.kill(); }
            }
        }
    }

    return lobby;
}

::lobby_fall_off <- function () {
    activator.SetOrigin(lobby_fall_off_pos);
    activator.SetHealth(100);
}

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
