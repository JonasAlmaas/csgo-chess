/*
    SUPPOTRTED FONTS:
    kanit_semibold
*/

/*
    SUPPOTRTED ALIGNMENTS:
    top_left, bottom_left, center_left, top_center, bottom_center, center_center, top_right, bottom_right, center_right
*/

supported_chars <- {
    upper = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"],
    lower = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"],
    number = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
    char = ["&", "'", "*", "@", "\\", "(", ")", "$", "^", ":", ",", "=", "!", ">", "#", "<", "-", "%", ".", "+", "?", "\"", ";", "/", "[", "]", "{", "}", "~", "_", "|"],
    char_name = [ "ampersand", "apostrophe", "asterisk", "at", "backslash", "bracket_left", "bracket_right", "bullet", "circumflex", "colon", "comma", "equal", "exclamation",
                  "greater", "hashtag", "less", "minus", "percent", "period", "pluss", "question", "quote", "semicolon", "slash", "square_bracket_left", "square_bracket_right",
                  "squiggly_bracket_left", "squiggly_bracket_right", "tilde", "underscore", "vertical_bar" ]
}

char_size_factor <- {
    template = {
        upper = {
            A = 1, B = 1, C = 1, D = 1, E = 1, F = 1, G = 1, H = 1, I = 1, J = 1, K = 1, L = 1, M = 1, N = 1,
            O = 1, P = 1, Q = 1, R = 1, S = 1, T = 1, U = 1, V = 1, W =  1, X = 1, Y = 1, Z = 1
        },
        lower = {
            a = 1, b = 1, c = 1, d = 1, e = 1, f = 1, g = 1, h = 1, i = 1, j = 1, k = 1, l = 1, m = 1, n = 1, o = 1,
            p = 1, q = 1, r = 1, s = 1, t = 1, u = 1, v = 1, w = 1, x = 1, y = 1, z = 1
        },
        number = 1,
        char = {
            ampersand = 1, apostrophe = 1, asterisk = 1, at = 1, backslash = 1, bracket_left = 1, bracket_right = 1, bullet = 1, circumflex = 1, colon = 1,
            comma = 1, equal = 1, exclamation = 1, greater = 1, hashtag = 1, less = 1, minus = 1, percent = 1, period = 1, pluss = 1, question = 1,
            quote = 1, semicolon = 1, slash = 1, square_bracket_left = 1, square_bracket_right = 1, squiggly_bracket_left = 1, squiggly_bracket_right = 1,
            tilde = 1, underscore = 1, vertical_bar = 1
        }
    },
    kanit_semibold = {
        upper = {
            A = 0.95, B = 0.85, C = 0.85, D = 0.9, E = 0.8, F = 0.775, G = 0.95, H = 0.875, I = 0.35, J = 0.65, K = 0.85, L = 0.75, M = 1, N = 0.875,
            O = 0.95, P = 0.85, Q = 1, R = 0.9, S = 0.8, T = 0.9, U = 1, V = 0.95, W = 1.2, X = 0.95, Y = 0.95, Z = 0.85
        },
        lower = {
            a = 0.7, b = 0.8, c = 0.7, d = 0.8, e = 0.75, f = 0.55, g = 0.75, h = 0.8, i = 0.4, j = 0.45, k = 0.8, l = 0.5, m = 1.15, n = 0.75, o = 0.8,
            p = 0.85, q = 0.85, r = 0.55, s = 0.65, t = 0.525, u = 0.75, v = 0.7, w = 1, x = 0.8, y = 0.85, z = 0.7
        },
        number = 0.825,
        char = {
            ampersand = 0.9, apostrophe = 0.3, asterisk = 0.6, at = 1, backslash = 0.35, bracket_left = 0.3, bracket_right = 0.3, bullet = 0.6, circumflex = 0.65, colon = 0.35,
            comma = 0.35, equal = 0.65, exclamation = 0.35, greater = 0.8, hashtag = 1, less = 0.8, minus = 0.55, percent = 1, period = 0.35, pluss = 0.75, question = 0.75,
            quote = 0.6, semicolon = 0.35, slash = 0.35, square_bracket_left = 0.45, square_bracket_right = 0.45, squiggly_bracket_left = 0.45, squiggly_bracket_right = 0.45,
            tilde = 0.8, underscore = 0.7, vertical_bar = 0.35
        }
    },
}

::precache_text_models <- function(allocated_fonts) {
    foreach (font in allocated_fonts) {
        foreach (letter in supported_chars["upper"]) {
            self.PrecacheModel("models/text/" + font + "/upper/" + letter + ".mdl");
        }
        foreach (letter in supported_chars["lower"]) {
            self.PrecacheModel("models/text/" + font + "/lower/" + letter + ".mdl");
        }
        foreach (char in supported_chars["number"]) {
            self.PrecacheModel("models/text/" + font + "/char/num" + char + ".mdl");
        }
        foreach (char in supported_chars["char_name"]) {
            self.PrecacheModel("models/text/" + font + "/char/" + char + ".mdl");
        }
    }
}

::new_dynamic_text <- function (message, char_size, font, color, align, pos, ang) {

    // Get all the char info for each char
    local char_info_list = [];
    for (local i = 0; i < message.len(); i++) {
        local char = message.slice(i, i+1);
        local offset_distance_step = 0;
        local sub_folder = "";

        if (char == " ") {
            offset_distance_step = char_size / 2;
        }
        else if (utils.list_contains(char, supported_chars["upper"])) {
            offset_distance_step = (char_size * char_size_factor[font]["upper"][char]) / 2;
            sub_folder = "/upper/";
        }
        else if (utils.list_contains(char, supported_chars["lower"])) {
            offset_distance_step = (char_size * char_size_factor[font]["lower"][char]) / 2;
            sub_folder = "/lower/";
        }
        else if (utils.list_contains(char, supported_chars["number"])) {
            offset_distance_step = (char_size * char_size_factor[font]["number"]) / 2;
            sub_folder = "/char/num";
        }
        else if (utils.list_contains(char, supported_chars["char"])) {
            local index = 0;
            local char_found = false;
            while (!char_found && index <= supported_chars["char"].len()) {
                if (char == supported_chars["char"][index]) { char_found = true; }
                else { index++; }
            }
            char = supported_chars["char_name"][index];
            offset_distance_step = (char_size * char_size_factor[font]["char"][char]) / 2;
            sub_folder = "/char/";
        }
        else {
            printl("ERROR: CHARACTER " + char +  " IS NOT SUPPORTED");
            continue;
        }

        char_info_list.append({char = char, offset_distance_step = offset_distance_step, sub_folder = sub_folder});
    }

    // Calculate the width of the text surface
    local width = 0
    foreach (char_info in char_info_list) {
        local char = char_info["char"];
        if (char == " ") {
            width += char_info["offset_distance_step"];
        } else {
            if (utils.list_contains(char, supported_chars["upper"])) width += char_size * char_size_factor[font]["upper"][char];
            else if (utils.list_contains(char, supported_chars["lower"])) width += char_size * char_size_factor[font]["lower"][char];
            else if (utils.list_contains(char, supported_chars["number"])) width += char_size * char_size_factor[font]["number"];
            else if (utils.list_contains(char, supported_chars["char_name"])) width += char_size * char_size_factor[font]["char"][char];
        }
    }

    // Calculate the alignment offset for the desired alignment option
    local alignment_offset = Vector(0, 0)
    if (align == "top_left") { alignment_offset = Vector(0, -char_size) }
    else if (align == "center_left") { alignment_offset = Vector(0, -(char_size / 2)); }
    else if (align == "top_center") { alignment_offset = Vector(-(width / 2), -char_size); }
    else if (align == "bottom_center") { alignment_offset = Vector(-(width / 2), 0); }
    else if (align == "center_center") { alignment_offset = Vector(-(width / 2), -(char_size / 2)); }
    else if (align == "top_right") { alignment_offset = Vector(-width, -char_size); }
    else if (align == "bottom_right") { alignment_offset = Vector(-width, 0); }
    else if (align == "center_right") { alignment_offset = Vector(-width, -(char_size / 2)); }

    local text_table = {
        prop_list = [],
        char_info_list = char_info_list,

        alignment_offset = alignment_offset,
        font = font,
        color = color,

        char_size = char_size,
        width = width,

        function create(pos, ang) {
            local offset_distance = math.vec_clone(alignment_offset);

            foreach (char_info in char_info_list) {
                if (char_info["char"] != " ") {
                    local prop = new_prop_dynamic();
                    prop.ref.__KeyValueFromInt("disableshadowdepth", 1);

                    offset_distance.x += char_info["offset_distance_step"];
                    local offset = math.vec_rotate_3d(Vector(0, offset_distance.x, offset_distance.y), ang);
                    prop.teleport(pos + offset, Vector(ang.x, ang.y, ang.z));
                    prop.set_model("models/text/" + font + char_info["sub_folder"] + char_info["char"] + ".mdl");
                    prop.set_scale(char_size);
                    prop.set_color(color);

                    prop_list.append(prop);
                }
                offset_distance.x += char_info["offset_distance_step"];
            }
        }

        function set_color(color_array) {
            color = color_array;

            foreach (prop in prop_list) {            
                EntFireByHandle(prop.ref, "Color", convertion.list_to_string(color), 0.0, null, null);
            }
        }

        function kill() {
            foreach (prop in prop_list) {
                prop.is_disabled = true;
                EntFireByHandle(prop.ref, "Disable", "", 0.0, null, null);
            }
            prop_list = [];
        }

        function teleport(pos, ang) {
            kill();
            create(pos, ang);
        }
    }
    text_table.create(pos, ang);
    return text_table;
}
