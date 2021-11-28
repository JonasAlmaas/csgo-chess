
::new_bishop <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.BISHOP);
    piece.set_model(PIECE_MODEL.BISHOP);
    
    piece.get_all_moves <- function (in_simple_pieces) {
        local moves = [];
        return moves;
    }

    /*
    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {

        return false;
        
        local move_to_piece = in_simple_pieces.get_from_cell(in_move_to_cell);
        if (move_to_piece) {
            // Can't capture pices on your team
            if (move_to_piece.team == team) { return false; }
        }

        // Can't move if it is getting blocked
        if (engine.is_blocked_diagonally(cell, in_move_to_cell, in_simple_pieces)) { return false; }
        
        // Can move diagonally
        local offset_x = math.abs(cell.x - in_move_to_cell.x);
        local offset_y = math.abs(cell.y - in_move_to_cell.y);
        if (offset_x == offset_y) { return true; }

        return false;
    }
    */

    return piece;
}
