
::engine <- {
    
    function get_valid_moves(in_simple_piece, in_simple_pieces, log) {
        local valid_moves = [];

        foreach (move in in_simple_piece.get_all_moves(in_simple_pieces, log)) {
            if (!engine.move_is_self_check(in_simple_piece.team, in_simple_piece.cell, move, in_simple_pieces, log)) {
                valid_moves.append(move);
            }
        }

        return valid_moves;
    }

    function move_is_self_check(team, old_cell, new_cell, in_simple_pieces, log) {
        local simple_pieces = new_simple_pieces_from_pieces(in_simple_pieces);

        local piece_moved = simple_pieces.get_from_cell(old_cell);
        local moved_to_piece = simple_pieces.get_from_cell(new_cell);
        if (moved_to_piece) {
            moved_to_piece.capture();
        }

        piece_moved.move_to(new_cell);

        if (is_in_check(team, simple_pieces, log)) { return true; }

        return false;
    }

    function is_in_check(in_team, in_simple_pieces, log) {
        local king = get_king_from_team(in_team, in_simple_pieces);

        if (king) {
            foreach (piece in in_simple_pieces.pieces) {
                if (!piece.captured && piece.team != in_team) {
                    local moves = piece.get_all_moves(in_simple_pieces, log);
                    if (moves.len() > 0) {
                        foreach (move in moves) {
                            if (math.vec_equal(move, king.cell)) { return true; }
                        }
                    }
                }
            }
        }

        return false;
    }

    function is_in_checkmate(in_team, in_simple_pieces, log) {
        foreach (piece in in_simple_pieces.pieces) {
            if (!piece.captured && (piece.team == in_team)) {
                if (engine.get_valid_moves(new_simple_piece_from_piece(piece), in_simple_pieces, log).len() > 0) {
                    return false;
                }
            }
        }

        return true;
    }

    function get_king_from_team(team, in_simple_pieces) {
        foreach (piece in in_simple_pieces.pieces) {
            if ((piece.team == team) && (piece.type == PIECE_TYPE.KING)) {
                return piece;
            }
        }
        return null;
    }

    function is_stalemate_no_more_moves(team, in_simple_pieces, log) {
        foreach (piece in in_simple_pieces.pieces) {
            if (!piece. captured&& piece.team == team) {
                if (get_valid_moves(new_simple_piece_from_piece(piece), in_simple_pieces, log).len() > 0) {
                    return false;
                }
            }
        }
        return true;
    }

    function is_stalemate_threefold_repetition(team, log) {
        local moves_made = log.moves.len();

        local repeating_white = false;
        local repeating_black = false;

        if (moves_made > 6) {
            local w_move1 = log.get_move(moves_made-1, TEAM.WHITE);
            local w_move2 = log.get_move(moves_made-3, TEAM.WHITE);
            local w_move3 = log.get_move(moves_made-5, TEAM.WHITE);
            local b_move1 = null;
            local b_move2 = null;
            local b_move3 = null;

            if (log.moves[moves_made-1].len() == 1) {
                b_move1 = log.get_move(moves_made-2, TEAM.BLACK);
                b_move2 = log.get_move(moves_made-4, TEAM.BLACK);
                b_move3 = log.get_move(moves_made-6, TEAM.BLACK);
            }
            else {
                b_move1 = log.get_move(moves_made-1, TEAM.BLACK);
                b_move2 = log.get_move(moves_made-3, TEAM.BLACK);
                b_move3 = log.get_move(moves_made-5, TEAM.BLACK);
            }

            // Check if white is repeating
            if (math.vec_equal(w_move1.to, w_move2.to)) {
                if (math.vec_equal(w_move2.to, w_move3.to)) {
                    if (math.vec_equal(w_move1.from, w_move2.from)) {
                        if (math.vec_equal(w_move2.from, w_move3.from)) {
                            repeating_white = true;
                        }
                    }
                }
            }

            // Check if black is repeating
            if (math.vec_equal(b_move1.to, b_move2.to)) {
                if (math.vec_equal(b_move2.to, b_move3.to)) {
                    if (math.vec_equal(b_move1.from, b_move2.from)) {
                        if (math.vec_equal(b_move2.from, b_move3.from)) {
                            repeating_black = true;
                        }
                    }
                }
            }
        }

        return (repeating_white && repeating_black);
    }

    function get_world_pos_from_cell(in_cell) {
        local half_cell = BOARD_SCALE * 0.5;
        local offset = math.vec_mul(in_cell, BOARD_SCALE);
        return BOARD_POS + Vector(offset.x, -offset.y) + Vector(half_cell, -half_cell);
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
                if (is_cell_on_board(move)) {
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
                if (is_cell_on_board(move)) {
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
                if (is_cell_on_board(move)) {
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
                if (is_cell_on_board(move)) {
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
            
            if (blocked_up && blocked_down && blocked_left && blocked_right) {
                break;
            }
        }
        
        return moves;
    }

    function get_diagonal_moves(cell, team, in_simple_pieces) {
        local moves = [];

        local blocked_up_right = false;
        local blocked_up_left = false;
        local blocked_down_right = false;
        local blocked_down_left = false;

        local loops = 0;
        while (loops < 8) {
            loops++;
            if (!blocked_up_right) {
                local move = Vector(cell.x + loops, cell.y + loops);
                if (is_cell_on_board(move)) {
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (move_to_piece) {
                        if (move_to_piece.team != team) {
                            moves.append(move);
                        }
                        blocked_up_right = true;
                    }
                    else {
                        moves.append(move);
                    }
                }
                else {
                    blocked_up_right = true;
                }
            }

            if (!blocked_up_left) {
                local move = Vector(cell.x + loops, cell.y - loops);
                if (is_cell_on_board(move)) {
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (move_to_piece) {
                        if (move_to_piece.team != team) {
                            moves.append(move);
                        }
                        blocked_up_left = true;
                    }
                    else {
                        moves.append(move);
                    }
                }
                else {
                    blocked_up_left = true;
                }
            }

            if (!blocked_down_right) {
                local move = Vector(cell.x - loops, cell.y + loops);
                if (is_cell_on_board(move)) {
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (move_to_piece) {
                        if (move_to_piece.team != team) {
                            moves.append(move);
                        }
                        blocked_down_right = true;
                    }
                    else {
                        moves.append(move);
                    }
                }
                else {
                    blocked_down_right = true;
                }
            }

            if (!blocked_down_left) {
                local move = Vector(cell.x - loops, cell.y - loops);
                if (is_cell_on_board(move)) {
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (move_to_piece) {
                        if (move_to_piece.team != team) {
                            moves.append(move);
                        }
                        blocked_down_left = true;
                    }
                    else {
                        moves.append(move);
                    }
                }
                else {
                    blocked_down_left = true;
                }
            }
            
            if (blocked_up_right && blocked_up_left && blocked_down_right && blocked_down_left) {
                break;
            }
        }

        return moves;
    }

    function is_cell_on_board(cell) {
        return (((cell.x >= 0) && (cell.x < 8)) && ((cell.y >= 0) && (cell.y < 8)));
    }
}
