::MODULE_EXT <- ".nut";
::BASE_FOLDER <- "chess/";

::PLAYER_1_ID <- null;
::PLAYER_1_TEAM <- null;

::custom_entities <- {
    prop_dynamic = [],
}

::HOT_RELOAD <- function () {

    reset_session();

    ScriptPrintMessageChatAll(" Reloading scripts...");
    DoIncludeScript(BASE_FOLDER + "main" + MODULE_EXT, null);
    ScriptPrintMessageChatAll(" ...successful");
    printl("--------------");
    printl("----RELOAD----");
    printl("--------------");
}
DoIncludeScript(BASE_FOLDER + "main" + MODULE_EXT, null);

function Precache() {
    precache_text_models(["kanit_semibold"]);
    precache_chess_pieces();
}
