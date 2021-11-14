
::new_game <- function() {

    local target = null;
    target = Entities.FindByName(target, "target_board");
    local board_pos = target.GetOrigin();

    local game = {
        board = new_board(board_pos, 128),
        pieces = [],

        function update() {
            board.debug_draw();
        }

        function reset() {
            board.reset();
        }
    }

    return game;
}
