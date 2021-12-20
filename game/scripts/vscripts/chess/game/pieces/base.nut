
/*
    BASE PIECE
*/
::new_base_piece <- function (in_team, in_cell) {

    local COLOR_WHITE = [200,200,200];
    local COLOR_BLACK = [45,45,45];
    local COLOR_ERROR = [255,0,255];

    local piece = {
        captured = false,
        captureing_piece_dir = null,
        captureing_piece_size = null,
        captureing_piece_distance_from_target = null,
        
        team = in_team,
        type = PIECE_TYPE.NONE,
        prop = new_prop_dynamic(),
        angle = Vector(),

        times_moved = 0,

        cell = in_cell,
        spawn_cell = math.vec_clone(in_cell),
        reference_cell = null,
        target_cell = null,
        sorted_move_cells = [],

        speed = 500.0,
        time_last_cell = 0.0,

        function enable() { prop.enable(); }
        function disable() { prop.disable(); }
        
        function teleport(pos, in_angle=null) { prop.teleport(pos, in_angle); }

        function set_color(color) { prop.set_color(color); }
        function set_model(path) { prop.set_model(path); }
        function set_scale(scale) { prop.set_scale(scale); }
        function set_type(in_type) { type = in_type; }

        function get_type() { return type; }

        function move_to(in_move_to_cell) {
            times_moved++;
            target_cell = math.vec_clone(in_move_to_cell);
            reference_cell = math.vec_clone(cell);
            
            sorted_move_cells = get_sorted_move_cells();
            time_last_cell = Time();
        }

        function get_sorted_move_cells() {
            
            local dist_x = math.abs(cell.x - target_cell.x) * 1.0; 
            local dist_y = math.abs(cell.y - target_cell.y) * 1.0;
            
            local dir_x = (cell.x - target_cell.x) / dist_x; 
            local dir_y = (cell.y - target_cell.y) / dist_y;

            local temp_list = [];
            temp_list.append(cell);
            temp_list.append(target_cell);

            while (dist_x > 0 || dist_y > 0) {
                
                if (dist_x > 0 && dist_y > 0) { temp_list.insert(1, cell - Vector(dir_x * dist_x, dir_y * dist_y)); } 
                else if (dist_x == 0) { temp_list.insert(1, cell - Vector(0, dir_y * dist_y)); }
                else if (dist_y == 0) { temp_list.insert(1, cell - Vector(dir_x * dist_x, 0)); }

                if (dist_x > 0) { dist_x -= 1.0; }
                if (dist_y > 0) { dist_y -= 1.0; }
            }
            
            return temp_list;
        }

        function capture() {
            captured = true;
        }

        function get_world_pos(piece_list) {

            if (target_cell) {
                local cell_pos = engine.get_world_pos_from_cell(cell)
                local next_cell_pos = engine.get_world_pos_from_cell(target_cell);

                local calculated_speed = pow((next_cell_pos - cell_pos).Length() / speed, 0.5);

                local percent = (Time() - time_last_cell) / calculated_speed;
                if (percent >= 1) {
                    percent = 1;
                    cell = math.vec_clone(target_cell);
                    target_cell = null;
                } else {
                    percent = math.interpolate_smooth(percent);
                }

                local pos = engine.get_world_pos_from_cell(math.get_bezier_point(sorted_move_cells, percent));

                if (target_cell) {
                    foreach (piece in piece_list) {
                        if (!piece.captured && math.vec_equal(target_cell, piece.cell)) {
                            local offset = target_cell - reference_cell;
                            offset.y = -offset.y;
                            piece.captureing_piece_dir = math.vec_normalize_XY(math.vec_vec_div_safe(offset, math.vec_abs(offset)));
                            piece.captureing_piece_size = prop.ref.GetBoundingMaxs().x * BOARD_SCALE;
                            piece.captureing_piece_distance_from_target = (engine.get_world_pos_from_cell(target_cell) - pos).Length();
                            break;
                        }
                    }
                }

                return pos;
            }
            else if (captureing_piece_dir != null) {
                local combined_size = captureing_piece_size + (prop.ref.GetBoundingMaxs().x * BOARD_SCALE);
                if (captureing_piece_distance_from_target <= combined_size) {
                    local percent = 1 - (captureing_piece_distance_from_target / combined_size);
                    local offset = math.vec_mul(captureing_piece_dir, combined_size * percent);
                    return engine.get_world_pos_from_cell(cell) + offset;
                }
            }

            return engine.get_world_pos_from_cell(cell);
        }

        function get_captured_world_pos() {
            if (team == TEAM.WHITE) {
                return engine.get_world_pos_from_cell(Vector(spawn_cell.y, spawn_cell.x - 3));
            }
            else {
                return engine.get_world_pos_from_cell(Vector(spawn_cell.y, spawn_cell.x + 3));
            }
        }
    }

    piece.set_scale(BOARD_SCALE);

    if (piece.team == TEAM.WHITE) {
        piece.set_color(COLOR_WHITE);
        piece.angle = Vector(0,90);
    }
    else if (piece.team == TEAM.BLACK) {
        piece.set_color(COLOR_BLACK);
        piece.angle = Vector(0,270);
    }
    else { piece.set_color(COLOR_ERROR); }

    return piece;
}

/*
    PAWN
*/
::new_pawn <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.PAWN);
    piece.set_model(PIECE_MODEL.PAWN);

    piece.get_all_moves <- function (in_simple_pieces, log) {
        local moves = [];

        // Pawns can only move one direction
        local step = 1;
        if (team == TEAM.BLACK) { step = -1; }

        local move1 = Vector(cell.x + step, cell.y);

        if (!engine.is_cell_on_board(move1)) {
            return moves;
        }

        local move1_piece = in_simple_pieces.get_from_cell(move1);
        if (!move1_piece) {
            // Can only move forward if there isn't a piece there
            moves.append(move1);

            // Can move forward two times it it is the first move for the pawn
            if (times_moved == 0) {
                local move2 = Vector(move1.x + step, move1.y);
                local move2_piece = in_simple_pieces.get_from_cell(move2);
                if (!move2_piece) {
                    moves.append(move2);
                }
            }
        }

        // Can capture diagonally
        local capture_moves = [Vector(cell.x + step, cell.y + 1), Vector(cell.x + step, cell.y - 1)];
        foreach (move in capture_moves) {
            local capture_piece = in_simple_pieces.get_from_cell(move);
            if (capture_piece) {
                if (capture_piece.team != team) {
                    moves.append(move);
                }
            }
            else {
                // Check for "En Passant"
                if (((team == TEAM.WHITE) && (move.x == 5)) || ((team == TEAM.BLACK) && (move.x == 2))) {
                    local en_passant_cell = Vector(move.x - step, move.y);
                    local en_passant_piece = in_simple_pieces.get_from_cell(en_passant_cell);
                    if (en_passant_piece) {
                        if (en_passant_piece.times_moved == 1) {
                            if (en_passant_piece.type = PIECE_TYPE.PAWN) {
                                if (en_passant_piece.team == TEAM.WHITE) {
                                    if (math.vec_equal(en_passant_piece.cell, log.get_last_move(TEAM.WHITE).to)) {
                                        moves.append(move);
                                    }
                                }
                                else {
                                    if (math.vec_equal(en_passant_piece.cell, log.get_last_move(TEAM.BLACK).to)) {
                                        moves.append(move);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return moves;
    }
    
    return piece;
}

/*
    ROOK
*/
::new_rook <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.ROOK);
    piece.set_model(PIECE_MODEL.ROOK);

    piece.get_all_moves <- function (in_simple_pieces, log) {
        return engine.get_straight_moves(cell, team, in_simple_pieces);
    }

    return piece;
}

/*
    KNIGHT
*/
::new_knight <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.KNIGHT);
    piece.set_model(PIECE_MODEL.KNIGHT);

    piece.get_all_moves <- function (in_simple_pieces, log) {
        local moves = [];

        local possible_moves = [];
        possible_moves.append(Vector(cell.x + 2, cell.y - 1))   // 0: Up left
        possible_moves.append(Vector(cell.x + 2, cell.y + 1))   // 1: Up Right
        possible_moves.append(Vector(cell.x + 1, cell.y + 2))   // 2: Right up
        possible_moves.append(Vector(cell.x - 1, cell.y + 2))   // 3: Right down
        possible_moves.append(Vector(cell.x - 2, cell.y + 1))   // 4: Down right
        possible_moves.append(Vector(cell.x - 2, cell.y - 1))   // 5: Down left
        possible_moves.append(Vector(cell.x - 1, cell.y - 2))   // 5: Left down
        possible_moves.append(Vector(cell.x + 1, cell.y - 2))   // 5: Left up

        foreach (move in possible_moves) {
            if (engine.is_cell_on_board(move)) {
                local move_to_piece = in_simple_pieces.get_from_cell(move);
                if (move_to_piece) {
                    if (move_to_piece.team != team) {
                        moves.append(move);
                    }
                }
                else {
                    moves.append(move);
                }
            }
        }

        return moves;
    }

    return piece;
}

/*
    BISHOP
*/
::new_bishop <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.BISHOP);
    piece.set_model(PIECE_MODEL.BISHOP);
    
    piece.get_all_moves <- function (in_simple_pieces, log) {
        return engine.get_diagonal_moves(cell, team, in_simple_pieces);
    }

    return piece;
}

/*
    QUEEN
*/
::new_queen <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.QUEEN);
    piece.set_model(PIECE_MODEL.QUEEN);

    piece.get_all_moves <- function (in_simple_pieces, log) {
        local straight_moves = engine.get_straight_moves(cell, team, in_simple_pieces);
        local diagonal_moves = engine.get_diagonal_moves(cell, team, in_simple_pieces);
        return utils.list_merge(straight_moves, diagonal_moves);
    }

    return piece;
}

/*
    KING
*/
::new_king <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.KING);
    piece.set_model(PIECE_MODEL.KING);

    piece.get_all_moves <- function (in_simple_pieces, log) {
        local moves = [];

        local possible_moves = [];
        possible_moves.append(Vector(cell.x + 1, cell.y - 1));  // 0: Up left
        possible_moves.append(Vector(cell.x + 1, cell.y));      // 1: Up
        possible_moves.append(Vector(cell.x + 1, cell.y + 1));  // 2: Up Right
        possible_moves.append(Vector(cell.x, cell.y + 1));      // 3: Right
        possible_moves.append(Vector(cell.x - 1, cell.y + 1));  // 4: Down Right
        possible_moves.append(Vector(cell.x - 1, cell.y));      // 5: Down
        possible_moves.append(Vector(cell.x - 1, cell.y - 1));  // 6: Down Left
        possible_moves.append(Vector(cell.x, cell.y - 1));      // 7: Left

        foreach (move in possible_moves) {
            if (engine.is_cell_on_board(move)) {
                local move_to_piece = in_simple_pieces.get_from_cell(move);
                if (move_to_piece) {
                    if (move_to_piece.team != team) {
                        moves.append(move);
                    }
                }
                else {
                    moves.append(move);
                }
            }
        }

        local in_check = (team == TEAM.WHITE && in_simple_pieces.white_in_check) || (team == TEAM.BLACK && in_simple_pieces.black_in_check);

        // Castling
        if (times_moved == 0 && !in_check) {
            // Right
            if (utils.list_vec_contains(possible_moves[3], moves)) {
                if (!engine.move_is_self_check(team, cell, Vector(cell.x, cell.y + 1), in_simple_pieces, log)) {
                    local move = Vector(cell.x, cell.y + 2);
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (!move_to_piece) {
                        local rook_cell = Vector(cell.x, cell.y + 3);
                        local rook_piece = in_simple_pieces.get_from_cell(rook_cell);
                        if (rook_piece) {
                            if (rook_piece.times_moved == 0) {
                                moves.append(move);
                            }
                        }
                    }
                }
            }
            // Left
            if (utils.list_vec_contains(possible_moves[7], moves)) {
                if (!engine.move_is_self_check(team, cell, Vector(cell.x, cell.y - 1), in_simple_pieces, log)) {
                    local move = Vector(cell.x, cell.y - 2);
                    local move_to_piece = in_simple_pieces.get_from_cell(move);
                    if (!move_to_piece) {
                        // Moveing left is a bit strange
                        local space_cell = Vector(cell.x, cell.y - 3);
                        local space_piece = in_simple_pieces.get_from_cell(space_cell);
                        if (!space_piece) {
                            local rook_cell = Vector(cell.x, cell.y - 4);
                            local rook_piece = in_simple_pieces.get_from_cell(rook_cell);
                            if (rook_piece) {
                                if (rook_piece.times_moved == 0) {
                                    moves.append(move);
                                }
                            }
                        }
                    }
                }
            }
        }

        return moves;
    }

    return piece;
}
