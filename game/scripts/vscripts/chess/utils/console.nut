
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
    function color_test() {
        chat("\n| " + color.white + "white");
        chat("\n| " + color.dark_red + "dark_red");
        chat("\n| " + color.purple + "purple");
        chat("\n| " + color.green + "green");
        chat("\n| " + color.light_green + "light_green");
        chat("\n| " + color.lime_green + "lime_green");
        chat("\n| " + color.red + "red");
        chat("\n| " + color.grey + "grey");
        chat("\n| " + color.yellow + "yellow");
        chat("\n| " + color.light_blue + "light_blue");
        chat("\n| " + color.dark_blue + "dark_blue");
        chat("\n| " + color.light_blue2 + "light_blue2");
        chat("\n| " + color.pink + "pink");
        chat("\n| " + color.light_red + "light_red");
        chat("\n| " + color.orange + "orange");
    }
    color = {
        invisible = "\x00"
        white = "\x01"
        dark_red = "\x02"
        purple = "\x03"
        green = "\x04"
        light_green = "\x05"
        lime_green = "\x06"
        red = "\x07"
        grey = "\x08"
        yellow = "\x09"
        light_blue = "\x0a"
        blue = "\x0b"
        dark_blue = "\x0c"
        light_blue2 = "\x0d"
        pink = "\x0e"
        light_red = "\x0f"
        orange = "\x10"
    }
}
