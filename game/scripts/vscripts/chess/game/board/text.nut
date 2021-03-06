
::new_board_text <- function (in_pos, scale) {
    
    local text_size = scale * 0.5;
    local text_color = [200,200,200];

    local text_list = [];

    local board_size = scale * 8;
    local half_scale = scale * 0.5;

    for (local i = 0; i < 8; i++) {
        local pos1 = in_pos + Vector(i * scale) + Vector(half_scale, half_scale);
        text_list.append(new_dynamic_text("" + (i + 1), text_size, "kanit_semibold", text_color, "center_center", pos1, Vector(270, 180)));

        local pos2 = in_pos + Vector(0, -(i * scale)) + Vector(-half_scale, -half_scale);
        text_list.append(new_dynamic_text(constants.alphabet.upper[i], text_size, "kanit_semibold", text_color, "center_center", pos2, Vector(270, 180)));

        local pos3 = in_pos + Vector((7 - i) * scale, -board_size) + Vector(half_scale, -half_scale);
        text_list.append(new_dynamic_text("" + (8 - i), text_size, "kanit_semibold", text_color, "center_center", pos3, Vector(270, 0)));
        
        local pos4 = in_pos + Vector(board_size, -((7 - i) * scale)) + Vector(half_scale, -half_scale);
        text_list.append(new_dynamic_text(constants.alphabet.upper[7-i], text_size, "kanit_semibold", text_color, "center_center", pos4, Vector(270, 0)));
    }
    
    local table = {
        list = text_list,

        function reset() {
            foreach (text in list) {
                text.kill();
            }
        }
    }

    return table;
}