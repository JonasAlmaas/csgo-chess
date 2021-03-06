::MODULE_EXT <- ".nut";
::BASE_FOLDER <- "chess/";

::custom_entities <- {
    prop_dynamic = [],
    prop_dynamic_glow = [],
}

::HOT_RELOAD <- function () {

    reset_session();

    printl("Reloading scripts...");
    DoIncludeScript(BASE_FOLDER + "main" + MODULE_EXT, null);
    printl(" ...successful");
}
DoIncludeScript(BASE_FOLDER + "main" + MODULE_EXT, null);

function Precache() {
    precache_text_models(["kanit_semibold"]);
    precache_chess();
}
