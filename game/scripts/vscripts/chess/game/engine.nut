
::engine <- {
    
    function get_valid_moves(in_simple_piece, in_simple_pieces) {
        local moves = [];

        for (local rank = 0; rank < 8; rank++) {
            for (local file = 0; file < 8; file++) {
                local move_to_cell = Vector(rank, file);

                if (in_simple_piece.can_move(move_to_cell, in_simple_pieces)) {
                    moves.append(move_to_cell);
                }
            }
        }
        
        return moves;
    }

    function get_world_pos_from_cell(in_board_pos, in_cell) {
        local half_cell = BOARD_SCALE * 0.5;
        local offset = math.vec_mul(in_cell, BOARD_SCALE);
        return in_board_pos + Vector(offset.x, -offset.y) + Vector(half_cell, -half_cell);
    }

    function get_piece_world_pos(in_piece, in_board_pos) {
        if (in_piece.target_cell) {
            if (!in_piece.next_cell) {
                in_piece.next_cell = get_next_cell(in_piece.cell, in_piece.target_cell);
                in_piece.time_last_cell = Time();
                if (!in_piece.next_cell) {
                    in_piece.target_cell = null;
                }
            }

            if (in_piece.next_cell) {
                local cell_pos = get_world_pos_from_cell(in_board_pos, in_piece.cell)
                local next_cell_pos = get_world_pos_from_cell(in_board_pos, in_piece.next_cell);

                local percent = (Time() - in_piece.time_last_cell) / in_piece.time_per_cell;
                if (percent >= 1) {
                    in_piece.cell = math.vec_clone(in_piece.next_cell);
                    in_piece.next_cell = null;
                }

                return math.vec_lerp(cell_pos, next_cell_pos, percent);
            }
        }

        return get_world_pos_from_cell(in_board_pos, in_piece.cell);
    }

    // TODO: Should avoid other pieces
    function get_next_cell(in_cell, in_target_cell) {
        if (math.vec_equal(in_cell, in_target_cell)) {
            return null;
        }

        local offset = in_cell - in_target_cell;
        local abs_offset = math.vec_abs(offset);

        if (abs_offset.x > abs_offset.y) {
            if (offset.x < 0) { return in_cell + Vector(1); }
            else { return in_cell + Vector(-1); }
        }
        else {
            if (offset.y < 0) { return in_cell + Vector(0, 1); }
            else { return in_cell + Vector(0, -1); }
        }
    }

    function is_blocked_straight(in_cell, in_move_to_cell, in_simple_pieces) {
        // Up
        for (local rank = (in_cell.x + 1); rank < 8; rank++) {
            if (in_simple_pieces.get_from_cell(Vector(rank, in_cell.y))) {
                if ((in_move_to_cell.x > rank) && (in_move_to_cell.y == in_cell.y)) { return true; }
            }
        }
        // Down
        for (local rank = (in_cell.x - 1); rank >= 0; rank--) {
            if (in_simple_pieces.get_from_cell(Vector(rank, in_cell.y))) {
                if ((in_move_to_cell.x < rank) && (in_move_to_cell.y == in_cell.y)) { return true; }
            }
        }
        // Right
        for (local file = (in_cell.y + 1); file < 8; file++) {
            if (in_simple_pieces.get_from_cell(Vector(in_cell.x, file))) {
                if ((in_move_to_cell.x == in_cell.x) && (in_move_to_cell.y > file)) { return true; }
            }
        }
        // Left
        for (local file = (in_cell.y - 1); file >= 0; file--) {
            if (in_simple_pieces.get_from_cell(Vector(in_cell.x, file))) {
                if ((in_move_to_cell.x == in_cell.x) && (in_move_to_cell.y < file)) { return true; }
            }
        }

        return false;
    }

    function is_blocked_diagonally(in_cell, in_move_to_cell, in_simple_pieces) {
        local offset_x = math.abs(in_cell.x - in_move_to_cell.x);
        local offset_y = math.abs(in_cell.y - in_move_to_cell.y);
        if (offset_x != offset_y) { return false; }

        for (local i = 1; i < 8; i++) {
            // Up right
            local rank = in_cell.x + i;
            local file = in_cell.y + i;
            if (in_simple_pieces.get_from_cell(Vector(rank, file))) {
                if ((in_move_to_cell.x > rank) && (in_move_to_cell.y > file)) { return true; }
            }

            // Up left
            rank = in_cell.x + i;
            file = in_cell.y - i;
            if (in_simple_pieces.get_from_cell(Vector(rank, file))) {
                if ((in_move_to_cell.x > rank) && (in_move_to_cell.y < file)) { return true; }
            }

            // Down right
            rank = in_cell.x - i;
            file = in_cell.y + i;
            if (in_simple_pieces.get_from_cell(Vector(rank, file))) {
                if ((in_move_to_cell.x < rank) && (in_move_to_cell.y > file)) { return true; }
            }

            // Down left
            rank = in_cell.x - i;
            file = in_cell.y - i;
            if (in_simple_pieces.get_from_cell(Vector(rank, file))) {
                if ((in_move_to_cell.x < rank) && (in_move_to_cell.y < file)) { return true; }
            }
        }

        return false;
    }

    function is_check_mate(in_simple_pieces) {
        return false;
    }
}
