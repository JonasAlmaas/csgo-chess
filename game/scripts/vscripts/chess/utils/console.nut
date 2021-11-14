::console <- {
    function log(str) {
        printl( "[Script] " + Time() + " : " + str)
    }
    function chat(str) {
        ScriptPrintMessageChatAll("" + str)
    }
    function run(str) {
        SendToConsole(str);
        SendToConsoleServer(str);
    }
}
