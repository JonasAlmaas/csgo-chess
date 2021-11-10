
::NewBoard <- function () {

    local cell_size = 128;

    local target = null;
    target = Entities.FindByName(target, "target_board");

    local board_pos = target.GetOrigin();

    local table = {
        CELL_SIZE = cell_size,
        BOARD_SIZE = cell_size * 8,
        HALF_BOARD_SIZE = (cell_size * 8) / 2,

        board_pos = board_pos,

        hit_ply1 = Vector(0, 0, 0),
        hit_ply2 = Vector(0, 0, 0),

        counter = null,
        counter_value = 0,

        function reset() {
            counter.kill()
        }

        function update() {
            if (counter != null) counter.kill()
            counter = new_dynamic_text("" + counter_value, 64, "kanit_semibold", [30, 30, 30], "center_center", board_pos + Vector(0, 0, 128), Vector(0, 0, 0));
            counter_value++;

            if (player1 != null) {
                local eye_ply1 = player1.getEyes();
                local forward_ply1 = player1.getForwardVector();

                hit_ply1 = Util_floor_plane_intersection(eye_ply1, forward_ply1, board_pos);
            }

            if (player2 != null) {
                local eye_ply2 = player2.getEyes();
                local forward_ply2 = player2.getForwardVector();

                hit_ply2 = Util_floor_plane_intersection(eye_ply2, forward_ply2, board_pos);            
            }
        }

        function draw() {
            dev_draw_board();

            if (player1 != null) {
                Util_draw_box(hit_ply1, Vector(-1, -1, -1), Vector(1, 1, 1));
            }
            if (player2 != null) {
                Util_draw_box(hit_ply2, Vector(-1, -1, -1), Vector(1, 1, 1));
            }
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
