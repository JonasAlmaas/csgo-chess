

::NewBoard <- function () {

    local CELL_SIZE = 128;
    local BOARD_SIZE = CELL_SIZE * 8;
    local HALF_BOARD_SIZE = (CELL_SIZE * 8) / 2;
    local HALF_CELL_SIZE = CELL_SIZE / 2;

    // Get board pos
    local target = null;
    target = Entities.FindByName(target, "target_board");
    local board_pos = target.GetOrigin();

    local table = {
        CELL_SIZE = CELL_SIZE,

        renderer = NewBoardRenderer(CELL_SIZE, board_pos),

        pieces = NewPieces(CELL_SIZE, board_pos),

        board_pos = board_pos,

        hit_ply1 = Vector(0, 0, 0),
        hit_ply2 = Vector(0, 0, 0),

        function reset() {

            renderer.reset();

            foreach (piece in pieces) {
                piece.kill();
            }
        }

        function update() {

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

            // Do this last every time
            renderer.draw();

            // Dev
            if (player1 != null) {
                Util_draw_box(hit_ply1, Vector(-2, -2, -2), Vector(2, 2, 2));
            }
            if (player2 != null) {
                Util_draw_box(hit_ply2, Vector(-2, -2, -2), Vector(2, 2, 2));
            }
        }
    }

    return table;
}
