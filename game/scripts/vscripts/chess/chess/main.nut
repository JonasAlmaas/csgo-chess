
::new_game <- function() {

    local SCALE = 128;

    local target = null;
    target = Entities.FindByName(target, "target_board");
    local board_pos = target.GetOrigin();

    local game = {
        board = new_board(board_pos, SCALE),
        pieces = new_pieces(SCALE),

        function update() {
            board.draw_debug();

            foreach (piece in pieces) {
                local pos = piece.get_world_pos(board.pos);
                debug_draw.box(pos, Vector(-2,-2,-2), Vector(2,2,2));
                // piece.update_position();
            }
        }

        function reset() {
            board.reset();

            foreach (piece in pieces) {
                piece.disable();
            }
        }
    }

    return game;
}
