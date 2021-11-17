
::new_coord_text <- function (in_board_pos, in_scale) {

    local text_size = in_scale * 0.65;

    local text_list = [];
    local text_color = [40,40,40];

    local board_size = in_scale * 8;
    local half_scale = in_scale * 0.5;

    for (local i = 0; i < 8; i++) {
        local pos1 = in_board_pos + Vector(i * in_scale) + Vector(half_scale, half_scale);
        text_list.append(new_dynamic_text(""+i, text_size, "kanit_semibold", text_color, "center_center", pos1, Vector(270, 180)));

        local pos2 = in_board_pos + Vector(0, -(i * in_scale)) + Vector(-half_scale, -half_scale);
        text_list.append(new_dynamic_text(constants.alphabet.upper[i], text_size, "kanit_semibold", text_color, "center_center", pos2, Vector(270, 180)));

        local pos3 = in_board_pos + Vector((7 - i) * in_scale, -board_size) + Vector(half_scale, -half_scale);
        text_list.append(new_dynamic_text(""+ (7 - i), text_size, "kanit_semibold", text_color, "center_center", pos3, Vector(270, 0)));
        
        local pos4 = in_board_pos + Vector(board_size, -((7 - i) * in_scale)) + Vector(half_scale, -half_scale);
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
