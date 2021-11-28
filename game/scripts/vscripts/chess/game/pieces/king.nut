
::new_king <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.KING);
    piece.set_model(PIECE_MODEL.KING);

    piece.get_all_moves <- function (in_simple_pieces) {
        local moves = [];
        return moves;
    }
    
    /*
    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {

        return false;
        
        local move_to_piece = in_simple_pieces.get_from_cell(in_move_to_cell);
        if (move_to_piece) {
            // Can't captue pieces from the same team
            if (move_to_piece.team == team) { return false; }
        }
        
        // Can move one move in any direction
        if ((math.abs(cell.x - in_move_to_cell.x) <= 1) && (math.abs(cell.y - in_move_to_cell.y) <= 1)) { return true; }

        // Can't castle when in check
        // if (engine.is_in_check(team, in_simple_pieces)) {
        if (true) {

            // Castleing has to happen on the kings first move
            if (times_moved == 0) {

                // Can't castle through other pieces
                if (engine.is_blocked_straight(cell, in_move_to_cell, in_simple_pieces)) { return false; }

                local castleing_piece = null;
                if (in_move_to_cell.y < cell.y) {
                    // Moveing left
                    // Can't castle through a check
                    if (engine.move_is_self_check(team, cell, Vector(cell.x, cell.y - 1), in_simple_pieces)) { return false; }

                    local rook_cell = Vector(in_move_to_cell.x, in_move_to_cell.y - 2);

                    // Special check for going left
                    if (engine.is_blocked_straight(in_move_to_cell, rook_cell, in_simple_pieces)) { return false; }

                    castleing_piece = in_simple_pieces.get_from_cell(rook_cell);
                }
                else {
                    // Moveing right
                    // Can't castle through a check
                    if (engine.move_is_self_check(team, cell, Vector(cell.x, cell.y + 1), in_simple_pieces)) { return false; }
                    castleing_piece = in_simple_pieces.get_from_cell(Vector(in_move_to_cell.x, in_move_to_cell.y + 1));
                }

                // See if there is actualy a piece there
                if (castleing_piece) {
                    // A rook can not be moved before castleing
                    if (castleing_piece.times_moved == 0) { return true; }
                }
            }
        }

        return false;
    }
    */

    return piece;
}
