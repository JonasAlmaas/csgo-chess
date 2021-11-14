/*
    Global constants
*/
::IS_DEBUGGING <- true;


/*
    Global includes
*/
::SCRIPTS_MANIFEST_UTILITIES <- [
    "utils/console",
    "utils/custom_entities",
    "utils/eventlistener",
    "utils/player",
    "utils/utils",
]

::SCRIPTS_MANIFEST_CHESS <- [
    "chess/board"
    "chess/main"
    "chess/pieces"
]

::include_scripts <- function() {

    local include_manifest = function(manifest) {
        foreach(script in manifest){
            DoIncludeScript(BASE_FOLDER + script + MODULE_EXT, null);
        }
    }
    include_manifest(SCRIPTS_MANIFEST_UTILITIES)
    include_manifest(SCRIPTS_MANIFEST_CHESS)
}
include_scripts();


/*
    Global variables
*/
::player1 <- null;
::player2 <- null;

::game <- null;

::initialized <- false;

::update <- function () {

    calculate_tickrate();

    if (!initialized) {

        game = new_game()

        initialized = true;
    }

    if (player1 == null || player2 == null) {
        reset_player_references();
    }

    update_player_traces();

    game.update();

    dispatch_events();
}

::reset_session <- function () {

    utils_remove_decals();

    game.reset();

    if (player1) { player1.teleport(player1.spawn_pos); }
    if (player2) { player2.teleport(player2.spawn_pos); }
}

::reset_player_references <- function () {

    player1 = null;
    player2 = null;

    local target = null;
    while ((target = Entities.FindByClassname(target, "*player*")) != null) {
        if (target.GetClassname() == "player") {
            if (player1 == null) {
                player1 = new_player(target);
            }
            else {
                player2 = new_player(target);
            }
        }
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
