
::new_pawn <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.PAWN);
    piece.set_model(PIECE_MODEL.PAWN);
    
    piece.get_all_moves <- function (in_simple_pieces) {
        local moves = [];
        return moves;
    }
    
    /*
    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {
        
        local step = 1;
        if (team == TEAM.BLACK) { step = -1; }

        local move_to_piece = in_simple_pieces.get_from_cell(in_move_to_cell);
        if (move_to_piece) {
            // Can't capture a king
            if (move_to_piece.type == PIECE_TYPE.KING) { return false; }

            // Diagonal capture
            if (move_to_piece.team != team) {
                if (in_move_to_cell.x == (cell.x + step)) {
                    if ((in_move_to_cell.y == (cell.y + step)) || (in_move_to_cell.y == (cell.y - step))) {
                        return true;
                    }
                }
            }
        }
        else {
            // En Passant
            if (((team == TEAM.BLACK) && (cell.x == 3)) || ((team == TEAM.WHITE) && (cell.x == 4))) {
                local EnPassant_piece = null;
                if (math.vec_equal(Vector((cell.x + step), (cell.y - step)), in_move_to_cell)) {
                    EnPassant_piece = in_simple_pieces.get_from_cell(Vector(in_move_to_cell.x - step, in_move_to_cell.y));
                }
                else if (math.vec_equal(Vector((cell.x + step), (cell.y + step)), in_move_to_cell)) {
                    EnPassant_piece = in_simple_pieces.get_from_cell(Vector(in_move_to_cell.x - step, in_move_to_cell.y));
                }

                if (EnPassant_piece) {
                    if ((EnPassant_piece.type == PIECE_TYPE.PAWN) && (EnPassant_piece.team =! team) && (EnPassant_piece.times_moved == 1)) {
                        if (team == TEAM.WHITE) {
                            if (LAST_MOVED_PIECE_BLACK) {
                                if (math.vec_equal(EnPassant_piece.cell, LAST_MOVED_PIECE_BLACK.cell)) { return true; }
                            }
                        }
                        else if (team == TEAM.BLACK) {
                            if (LAST_MOVED_PIECE_WHITE)  {
                                if (math.vec_equal(EnPassant_piece.cell, LAST_MOVED_PIECE_WHITE.cell)) { return true; }
                            }
                        }
                    }
                }
            }

            // Move directly forward
            if (in_move_to_cell.y == cell.y) {
                // One
                if (in_move_to_cell.x == (cell.x + step)) { return true;}
                // Two
                if ((times_moved == 0) && (in_move_to_cell.x == (cell.x + (step * 2)))) {
                    if (!in_simple_pieces.get_from_cell(Vector((cell.x + step), cell.y))) {
                        return true;
                    }
                }
            }
        }

        return false;
    }
    */

    return piece;
}
