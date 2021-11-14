::MODULE_EXT <- ".nut";
::BASE_FOLDER <- "chess/";

::custom_entities <- {
    prop_dynamic = [],
}

::HOT_RELOAD <- function () {

    reset_session();

    ScriptPrintMessageChatAll(" Reloading scripts...")
    DoIncludeScript(BASE_FOLDER + "main" + MODULE_EXT, null);
    ScriptPrintMessageChatAll(" ...successful")
    printl("--------------")
    printl("----RELOAD----")
    printl("--------------")
}
DoIncludeScript(BASE_FOLDER + "main" + MODULE_EXT, null);

function Precache() {

}
