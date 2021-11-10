/*
    Global constants
*/
::MODULE_EXT <- ".nut";
::IS_DEBUGGING <- true;

::ALPHABET <- {
    UPPER = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"],
    LOWER = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
}

/*
    Global includes
*/
::SCRIPTS_MANIFEST_UTILITIES <- [
    "utilities/console",
    "utilities/custom_entities"
    "utilities/dynamic_text",
    "utilities/eventlistener",
    "utilities/player",
    "utilities/utils",
]

::SCRIPTS_MANIFEST_CHESS <- [
    "chess/main",
    "chess/board/main",
    "chess/board/renderer",
    "chess/pieces/base",
    "chess/pieces/pawn",
    "chess/pieces/knight",
    "chess/pieces/rook",
    "chess/pieces/bishop",
    "chess/pieces/queen",
    "chess/pieces/king",
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

::chess <- null;

::Initialized <- false;

//Reset current session to default state
::reset_session <- function() {

    remove_decals();

    chess.reset()

    if (player1 != null) {
        player1.weakTeleport(player1.spawn_pos)
    }
    
    if (player2 != null) {
        player2.weakTeleport(player2.spawn_pos)
    }
}


// Called every tick by the server
::update <- function() {

    calculate_tickrate();
    if (!Initialized)
    {
        chess = NewChess();

        Initialized = true;
    }
    else if (player1 == null || player2 == null) {
        reset_player_references()
    }

    // First
    update_player_traces()

    chess.update()

    // Last
    DispatchEvents()
}

::reset_player_references <- function() {

    player1 = null;
    player2 = null;

    local target = null;
    while((target = Entities.FindByClassname(target, "*player*")) != null) {
        if (target.GetClassname() == "player") {
            if (player1 == null) {
                player1 = NewPlayer(target);
            }
            else {
                player2 = NewPlayer(target);
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


/*
    Helper functions
*/
::remove_decals <- function(){
    console.run("r_cleardecals");
}
