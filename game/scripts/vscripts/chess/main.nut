/*
    Global constants
*/
::IS_DEBUGGING <- false;
::IS_DEBUGGING_SINGLE_PLAYER <- true;

/*
    Global includes
*/

::SCRIPTS_MANIFEST_MISC <- [
    "lobby"
]

::SCRIPTS_MANIFEST_UTILITIES <- [
    "utils/console",
    "utils/constants",
    "utils/convertion",
    "utils/custom_entities",
    "utils/debug_draw",
    "utils/dynamic_text",
    "utils/eventlistener",
    "utils/math",
    "utils/player",
    "utils/utils",
]

::SCRIPTS_MANIFEST_GAME <- [
    "game/board/main",
    "game/board/text",
    "game/pieces/base",
    "game/pieces/misc",
    "game/highlighter",
    "game/ingame_menu",
    "game/engine",
    "game/main",
    "game/pawn_promotion",
    "game/utils",
]

::include_scripts <- function() {

    local include_manifest = function(manifest) {
        foreach(script in manifest){
            DoIncludeScript(BASE_FOLDER + script + MODULE_EXT, null);
        }
    }
    include_manifest(SCRIPTS_MANIFEST_MISC)
    include_manifest(SCRIPTS_MANIFEST_UTILITIES)
    include_manifest(SCRIPTS_MANIFEST_GAME)
}
include_scripts();

/*
    Entiry group
*/

// ::a <- EntityGroup[0];
// ::b <- EntityGroup[1];
// ::game_ui_ply_white <- EntityGroup[2];
// ::game_ui_ply_black <- EntityGroup[3];
// ::e <- EntityGroup[4];

/*
    Global variables
*/
::player_white <- null;
::player_black <- null;

::lobby <- null;
::game <- null;

::initialized <- false;

::update <- function () {

    calculate_tickrate();

    if (!initialized) {
        
        trace_orig_ply_white = ENTITY_GROUP[0];
        trace_orig_ply_black = ENTITY_GROUP[1];

        lobby = new_lobby();
        game = new_game();

        initialized = true;
    }

    update_player_traces();

    if (lobby.waiting) { lobby.update(); }
    else { game.update(); }

    dispatch_events();
}

::reset_session <- function () {
    
    utils.remove_decals();

    lobby.reset();
    game.reset();

    player_white.teleport(teleport_target_lobby_white.GetOrigin(), teleport_target_lobby_white.GetAngles());
    player_black.teleport(teleport_target_lobby_black.GetOrigin(), teleport_target_lobby_black.GetAngles());

    // To prevent everything for crashing
    if (!IS_DEBUGGING_SINGLE_PLAYER) {
        EntFireByHandle(ENTITY_GROUP[2], "Deactivate", "", 0.0, null, null);
        EntFireByHandle(ENTITY_GROUP[3], "Deactivate", "", 0.0, null, null);
    }
}

/*
    TICKRATE
*/
::TICKS <- 0;
::TICKRATE <- -1;
::TICKTIME <- -1;
::calculate_tickrate <- function() {

    if(TICKRATE == -1) {
        TICKS += 1;
        if(TICKTIME == -1) {
            TICKTIME = Time();
        }
        if(Time() - TICKTIME > 1) {
            if(TICKS > 96) {
                TICKRATE = 128;
            } else {
                TICKRATE = 64;
            }
        }
    }
}
