

::NewBoardRenderer <- function (cell_size, board_pos) {

    local CELL_SIZE = cell_size;
    local BOARD_SIZE = CELL_SIZE * 8;
    local HALF_BOARD_SIZE = (CELL_SIZE * 8) / 2;
    local HALF_CELL_SIZE = CELL_SIZE / 2;

    local dynamic_text_list = [];

    // Create letters and numbers
    local pos_white_left = board_pos + Vector(HALF_BOARD_SIZE, -HALF_BOARD_SIZE);
    local pos_black_left = board_pos + Vector(-HALF_BOARD_SIZE, HALF_BOARD_SIZE);

    for (local i = 0; i < 8; i++) {
        local pos_white_team_letter = pos_white_left + Vector(0, CELL_SIZE * i) + Vector(HALF_CELL_SIZE, HALF_CELL_SIZE, 1);
        local pos_black_team_letter = pos_black_left + Vector(0, -(CELL_SIZE * i)) + Vector(-HALF_CELL_SIZE, -HALF_CELL_SIZE, 1);
        local pos_white_team_number = pos_white_left + Vector(-(CELL_SIZE * i), 0) + Vector(-HALF_CELL_SIZE, -HALF_CELL_SIZE, 1);
        local pos_black_team_number = pos_black_left + Vector(CELL_SIZE * i, 0) + Vector(HALF_CELL_SIZE, HALF_CELL_SIZE, 1);
        dynamic_text_list.append(new_dynamic_text(ALPHABET.UPPER[i], HALF_CELL_SIZE, "kanit_semibold", [25, 25, 25], "center_center", pos_white_team_letter, Vector(270, 0, 0)));
        dynamic_text_list.append(new_dynamic_text(ALPHABET.UPPER[7-i], HALF_CELL_SIZE, "kanit_semibold", [25, 25, 25], "center_center", pos_black_team_letter, Vector(270, 180, 0)));
        dynamic_text_list.append(new_dynamic_text("" + (i + 1), HALF_CELL_SIZE, "kanit_semibold", [25, 25, 25], "center_center", pos_white_team_number, Vector(270, 0, 0)));
        dynamic_text_list.append(new_dynamic_text("" + (8 - i), HALF_CELL_SIZE, "kanit_semibold", [25, 25, 25], "center_center", pos_black_team_number, Vector(270, 180, 0)));
    }

    local table = {

        CELL_SIZE = CELL_SIZE,
        BOARD_SIZE = BOARD_SIZE,
        HALF_BOARD_SIZE = HALF_BOARD_SIZE,

        board_pos = board_pos,

        dynamic_text_list = dynamic_text_list,

        function reset() {
            foreach (element in dynamic_text_list) {
                element.kill();
            }
        }

        function draw() {
            // dev_draw_board();
        }

        function dev_draw_board() {
            // Draw outlineing square
            local c1 = board_pos + Vector(-HALF_BOARD_SIZE, -HALF_BOARD_SIZE);
            local c2 = board_pos + Vector(HALF_BOARD_SIZE, -HALF_BOARD_SIZE);
            local c3 = board_pos + Vector(HALF_BOARD_SIZE, HALF_BOARD_SIZE);
            local c4 = board_pos + Vector(-HALF_BOARD_SIZE, HALF_BOARD_SIZE);
            Util_draw_square(c1, c2, c3, c4, [255, 0, 0])

            // Draw the grid
            for (local vertical = 1; vertical < 8; vertical++) {
                local p1 = board_pos + Vector(CELL_SIZE * vertical) - Vector(HALF_BOARD_SIZE, HALF_BOARD_SIZE);
                local p2 = board_pos + Vector(CELL_SIZE * vertical, CELL_SIZE * 8) - Vector(HALF_BOARD_SIZE, HALF_BOARD_SIZE);
                Util_draw_line(p1, p2, [0,0,255]);
            }
            for (local horizontal = 1; horizontal < 8; horizontal++) {
                local p1 = board_pos + Vector(0, CELL_SIZE * horizontal) - Vector(HALF_BOARD_SIZE, HALF_BOARD_SIZE);
                local p2 = board_pos + Vector(CELL_SIZE * 8, CELL_SIZE * horizontal) - Vector(HALF_BOARD_SIZE, HALF_BOARD_SIZE);
                Util_draw_line(p1, p2, [0,255,0]);
            }
        }
    }

    return table;
}
