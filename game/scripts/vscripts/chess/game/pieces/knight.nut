
::new_knight <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.KNIGHT);
    piece.set_model(PIECE_MODEL.KNIGHT);

    piece.get_all_moves <- function (in_simple_pieces) {
        local moves = [];
        return moves;
    }

    /*
    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {
        return false;
    }
    */

    return piece;
}
