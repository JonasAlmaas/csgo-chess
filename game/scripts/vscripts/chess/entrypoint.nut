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
    // This line is way better than the bellow, but I don't have the whole alphabet in here atm.
    // precache_text_models(["kanit_semibold"]);

    precache_chess_pieces();

    // Not great! I'll fix this at a later date
    self.PrecacheModel("models/text/kanit_semibold/char/num0.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num1.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num2.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num3.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num4.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num5.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num6.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num7.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num8.mdl")
    self.PrecacheModel("models/text/kanit_semibold/char/num9.mdl")
    self.PrecacheModel("models/text/kanit_semibold/upper/A.mdl")
    self.PrecacheModel("models/text/kanit_semibold/upper/B.mdl")
    self.PrecacheModel("models/text/kanit_semibold/upper/C.mdl")
    self.PrecacheModel("models/text/kanit_semibold/upper/D.mdl")
    self.PrecacheModel("models/text/kanit_semibold/upper/E.mdl")
    self.PrecacheModel("models/text/kanit_semibold/upper/F.mdl")
    self.PrecacheModel("models/text/kanit_semibold/upper/G.mdl")
    self.PrecacheModel("models/text/kanit_semibold/upper/H.mdl")
}
