
/*
    Info Targets
*/

local target_center_zone_white = null;
local target_center_zone_black = null;
local target_count_down_white = null;
local target_count_down_black = null;
local target_fall_off = null;

target_center_zone_white = Entities.FindByName(target_center_zone_white, "target_lobby_center_zone_white");
target_center_zone_black = Entities.FindByName(target_center_zone_black, "target_lobby_center_zone_black");
target_count_down_white = Entities.FindByName(target_count_down_white, "target_lobby_count_down_white");
target_count_down_black = Entities.FindByName(target_count_down_black, "target_lobby_count_down_black");
target_fall_off = Entities.FindByName(target_fall_off, "target_lobby_fall_off");

::lobby_center_zone_white_pos <- target_center_zone_white.GetOrigin();
::lobby_center_zone_black_pos <- target_center_zone_black.GetOrigin();
::lobby_count_down_white_pos <- target_count_down_white.GetOrigin();
::lobby_count_down_black_pos <- target_count_down_black.GetOrigin();
::lobby_fall_off_pos <- target_fall_off.GetOrigin();

/*
    info Teleport Destination
*/

::teleport_target_lobby_white <- null;
::teleport_target_lobby_black <- null;
teleport_target_lobby_white = Entities.FindByName(teleport_target_lobby_white, "teleport_target_lobby_white");
teleport_target_lobby_black = Entities.FindByName(teleport_target_lobby_black, "teleport_target_lobby_black")


::new_lobby <- function () {

    local lobby = {
        waiting = true,

        // Square zone
        zone_radius = 320,

        font_size = 100,
        text_color_white = [40,40,40],
        text_color_black = [190,190,190],
        count_down_time = 6.0,

        count_down_text_1 = null,
        count_down_text_2 = null,

        temp_player_white = null,
        temp_player_black = null,

        time_count_down_start = null,

        function reset() {
            waiting = true;
            time_count_down_start = null;

            if (count_down_text_1) { count_down_text_1.kill(); }
            if (count_down_text_2) { count_down_text_2.kill(); }
        }

        function update() {

            // Check if players are within zones
            temp_player_white = null;
            temp_player_black = null;

            local player = null;
            while ((player = Entities.FindByClassname(player, "*player*")) != null) {
                if (player.GetClassname() == "player") {
                    local pos = player.GetOrigin();

                    local offset_white = math.vec_abs(lobby_center_zone_white_pos - pos);
                    local offset_black = math.vec_abs(lobby_center_zone_black_pos - pos);

                    if (offset_white.x <= zone_radius && offset_white.y <= zone_radius) { temp_player_white = player; }
                    if (offset_black.x <= zone_radius && offset_black.y <= zone_radius) { temp_player_black = player; }
                }
            }

            if (count_down_text_1) { count_down_text_1.kill(); }
            if (count_down_text_2) { count_down_text_2.kill(); }

            if (temp_player_white && temp_player_black) {
                local time_left = floor(count_down_time - (Time() - time_count_down_start));

                count_down_text_1 = new_dynamic_text("" + time_left, font_size, "kanit_semibold", text_color_white, "center_center", lobby_count_down_white_pos, Vector(0,0));
                count_down_text_2 = new_dynamic_text("" + time_left, font_size, "kanit_semibold", text_color_black, "center_center", lobby_count_down_black_pos, Vector(0,180));

                if (time_left <= 0) {
                    // Create players
                    player_white = new_player(temp_player_white);
                    player_black = new_player(temp_player_black);

                    // +attack listener
                    EntFireByHandle(game_ui_ply_white, "Activate", "", 0.0, player_white.ref, null);
                    EntFireByHandle(game_ui_ply_black, "Activate", "", 0.0, player_black.ref, null);

                    // Enable overview radar
                    EntFireByHandle(radar_overlay, "StartOverlays", "", 0.0, null, null);

                    // Give the players names
                    EntFireByHandle(player_white.ref, "AddOutput", "targetname ply1", 0.0, null, null);
                    EntFireByHandle(player_black.ref, "AddOutput", "targetname ply2", 0.0, null, null);

                    // Bind trace targets
                    EntFire("tr_lmm_ply_white", "SetMeasureTarget", "ply1", 0.01, null);
                    EntFire("tr_lmm_ply_black", "SetMeasureTarget", "ply2", 0.01, null);

                    // Teleport players to the map
                    player_white.teleport(teleport_target_game_white.GetOrigin(), teleport_target_game_white.GetAngles());
                    player_black.teleport(teleport_target_game_black.GetOrigin(), teleport_target_game_black.GetAngles());

                    waiting = false;
                }
            }
            else if (IS_DEBUGGING_SINGLE_PLAYER && temp_player_white) {
                //  This is hacked tougether just to make it run
                player_white = new_player(temp_player_white);
                player_black = new_player(temp_player_white);

                EntFireByHandle(game_ui_ply_white, "Activate", "", 0.0, player_white.ref, null);

                EntFireByHandle(radar_overlay, "StartOverlays", "", 0.0, null, null);

                EntFireByHandle(player_white.ref, "AddOutput", "targetname ply1", 0.0, null, null);
                EntFire("tr_lmm_ply_white", "SetMeasureTarget", "ply1", 0.01, null);

                player_white.teleport(teleport_target_game_white.GetOrigin(), teleport_target_game_white.GetAngles());

                waiting = false;
            }
            else {
                time_count_down_start = Time();
            }
        }
    }

    return lobby;
}

::lobby_fall_off <- function () {
    activator.SetOrigin(lobby_fall_off_pos);
}
