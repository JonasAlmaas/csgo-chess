
::engine <- {
    
    function get_valid_moves(piece, board) {
        local moves = [];

        for (local row = 0; row < 8; row++) {
            for (local col = 0; col < 8; col++) {
                moves.append(Vector(row, col))
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
}
