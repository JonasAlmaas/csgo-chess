
::new_rook <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.ROOK);
    piece.set_model(PIECE_MODEL.ROOK);

    piece.get_all_moves <- function (in_simple_pieces) {
        return engine.get_straight_moves(cell, team, in_simple_pieces);
    }
    
    /*
    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {

        local move_to_piece = in_simple_pieces.get_from_cell(in_move_to_cell);
        if (move_to_piece) {
            // Can't capture pieces with the same color
            if (team == move_to_piece.team) { return false; }
        }

        // Can't move if it is getting blocked
        if (engine.is_blocked_straight(cell, in_move_to_cell, in_simple_pieces)) { return false; }

        return true;
    }
    */

    return piece;
}
