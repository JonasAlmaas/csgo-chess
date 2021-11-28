
::engine <- {
    
    function get_valid_moves(in_simple_piece, in_simple_pieces) {
        // return in_simple_piece.get_all_moves(in_simple_pieces);

        local valid_moves = [];

        foreach (move in in_simple_piece.get_all_moves(in_simple_pieces)) {
            if (!engine.move_is_self_check(in_simple_piece.team, in_simple_piece.cell, move, in_simple_pieces)) {
                valid_moves.append(move);
            }
        }

        return valid_moves;
    }

    function move_is_self_check(team, old_cell, new_cell, in_simple_pieces) {
        local simple_pieces = new_simple_pieces_from_pieces(in_simple_pieces);

        local piece_moved = simple_pieces.get_from_cell(old_cell);
        local moved_to_piece = simple_pieces.get_from_cell(new_cell);
        if (moved_to_piece) {
            moved_to_piece.capture();
        }

        piece_moved.move_to(new_cell);

        if (is_in_check(team, simple_pieces)) { return true; }

        return false;
    }

    function is_in_check(team, in_simple_pieces) {
        local king = get_king_from_team(team, in_simple_pieces);

        if (king) {
            foreach (piece in in_simple_pieces.pieces) {
                if (piece.active) {
                    if (piece.team != team) {
                        local moves = piece.get_all_moves(in_simple_pieces);
                        if (moves.len() > 0) {
                            foreach (move in moves) {
                                if (math.vec_equal(move, king.cell)) { return true; }
                            }
                        }
                    }
                }
            }
        }

        return false;
    }

    function get_king_from_team(team, in_simple_pieces) {
        foreach (piece in in_simple_pieces.pieces) {
            if ((piece.team == team) && (piece.type == PIECE_TYPE.KING)) {
                return piece;
            }
        }
        return null;
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
    // Should be in the piece
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

    function get_straight_moves(cell, team, in_simple_pieces) {
        local moves = [];

        local blocked_up = false;
        local blocked_down = false;
        local blocked_left = false;
        local blocked_right = false;

        local loops = 0;
        while (loops < 8) {
            loops++;
            if (!blocked_up) {
                local move = Vector(cell.x + loops, cell.y);
                if ((move.x >= 0) && (move.x < 8)) {
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (move_to_piece) {
                        if (move_to_piece.team != team) {
                            moves.append(move);
                        }
                        blocked_up = true;
                    }
                    else {
                        moves.append(move);
                    }
                }
                else {
                    blocked_up = true;
                }
            }

            if (!blocked_down) {
                local move = Vector(cell.x - loops, cell.y);
                if ((move.x >= 0) && (move.x < 8)) {
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (move_to_piece) {
                        if (move_to_piece.team != team) {
                            moves.append(move);
                        }
                        blocked_down = true;
                    }
                    else {
                        moves.append(move);
                    }
                }
                else {
                    blocked_down = true;
                }
            }

            if (!blocked_left) {
                local move = Vector(cell.x, cell.y - loops);
                if ((move.y >= 0) && (move.y < 8)) {
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (move_to_piece) {
                        if (move_to_piece.team != team) {
                            moves.append(move);
                        }
                        blocked_left = true;
                    }
                    else {
                        moves.append(move);
                    }
                }
                else {
                    blocked_left = true;
                }
            }

            if (!blocked_right) {
                local move = Vector(cell.x, cell.y + loops);
                if ((move.y >= 0) && (move.y < 8)) {
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (move_to_piece) {
                        if (move_to_piece.team != team) {
                            moves.append(move);
                        }
                        blocked_right = true;
                    }
                    else {
                        moves.append(move);
                    }
                }
                else {
                    blocked_right = true;
                }
            }
        }
        
        return moves;
    }

    /*
    function is_blocked_straight(in_cell, in_move_to_cell, in_simple_pieces) {

        if ((in_move_to_cell.x > in_cell.x) && (in_move_to_cell.y == in_cell.y)) {
            // Up
            for (local rank = (in_cell.x + 1); rank < 8; rank++) {
                if (in_simple_pieces.get_from_cell(Vector(rank, in_cell.y))) {
                    if ((in_move_to_cell.x > rank) && (in_move_to_cell.y == in_cell.y)) { return true; }
                }
            }
        }
        else if ((in_move_to_cell.x < in_cell.x) && (in_move_to_cell.y == in_cell.y)){
            // Down
            for (local rank = (in_cell.x - 1); rank >= 0; rank--) {
                if (in_simple_pieces.get_from_cell(Vector(rank, in_cell.y))) {
                    if ((in_move_to_cell.x < rank) && (in_move_to_cell.y == in_cell.y)) { return true; }
                }
            }
        }
        else if ((in_move_to_cell.x == in_cell.x) && (in_move_to_cell.y > in_cell.y)) {
            // Right
            for (local file = (in_cell.y + 1); file < 8; file++) {
                if (in_simple_pieces.get_from_cell(Vector(in_cell.x, file))) {
                    if ((in_move_to_cell.x == in_cell.x) && (in_move_to_cell.y > file)) { return true; }
                }
            }
        }
        else if ((in_move_to_cell.x == in_cell.x) && (in_move_to_cell.y < in_cell.y)) {
            // Left
            for (local file = (in_cell.y - 1); file >= 0; file--) {
                if (in_simple_pieces.get_from_cell(Vector(in_cell.x, file))) {
                    if ((in_move_to_cell.x == in_cell.x) && (in_move_to_cell.y < file)) { return true; }
                }
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
    */

    function is_check_mate(in_simple_pieces) {
        return false;
    }
}
