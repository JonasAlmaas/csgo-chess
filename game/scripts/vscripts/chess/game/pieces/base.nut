
/*
    BASE PIECE
*/
::new_base_piece <- function (in_team, in_cell) {

    if (IS_DEBUGGING) {
        local color = "White";
        if (in_team == TEAM.BLACK) { color = "Black"; }
        console.log("Create: Piece [" + color + ", (" + in_cell.x + ", " + in_cell.y + ")]");
    }

    local COLOR_WHITE = [200,200,200];
    local COLOR_BLACK = [45,45,45];
    local COLOR_ERROR = [255,0,255];

    local piece = {
        active = true,
        
        team = in_team,
        type = PIECE_TYPE.NONE,
        prop = new_prop_dynamic(),
        angle = Vector(),

        times_moved = 0,

        cell = in_cell,
        spawn_cell = math.vec_clone(in_cell),
        referece_cell = null,
        target_cell = null,
        next_cell = null,

        time_per_cell = 0.2,
        time_last_cell = 0.0,

        function enable() { prop.enable(); }
        function disable() { prop.disable(); }
        
        function show() { prop.show(); }
        function hide() { prop.hide(); }

        function teleport(pos, in_angle=null) { prop.teleport(pos, in_angle); }

        function set_color(color) { prop.set_color(color); }
        function set_model(path) { prop.set_model(path); }
        function set_scale(scale) { prop.set_scale(scale); }
        function set_type(in_type) { type = in_type; }

        function get_type() { return type; }

        function move_to(in_move_to_cell) {
            times_moved++;
            referece_cell = math.vec_clone(cell);
            target_cell = in_move_to_cell;
        }

        function capture() {
            active = false;
        }

        function get_world_pos(in_board_pos) {
            if (target_cell) {
                if (!next_cell) {
                    get_next_cell();
                }

                if (next_cell) {
                    local cell_pos = engine.get_world_pos_from_cell(in_board_pos, cell)
                    local next_cell_pos = engine.get_world_pos_from_cell(in_board_pos, next_cell);

                    local calculated_time_per_cell = ((cell_pos - next_cell_pos).Length() / BOARD_SCALE) * time_per_cell

                    local percent = (Time() - time_last_cell) / calculated_time_per_cell;
                    if (percent >= 1) {
                        cell = math.vec_clone(next_cell);
                        next_cell = null;
                    }

                    return math.vec_lerp(cell_pos, next_cell_pos, percent);
                }
            }

            return engine.get_world_pos_from_cell(in_board_pos, cell);
        }

        function get_captured_world_pos(in_board_pos) {
            if (team == TEAM.WHITE) {
                return engine.get_world_pos_from_cell(in_board_pos, Vector(spawn_cell.y, spawn_cell.x - 3));
            }
            else {
                return engine.get_world_pos_from_cell(in_board_pos, Vector(spawn_cell.y, spawn_cell.x + 3));
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

    piece.get_all_moves <- function (in_simple_pieces) {
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
                                    if (math.vec_equal(en_passant_piece.cell, LAST_MOVED_PIECE_WHITE.cell)) {
                                        moves.append(move);
                                    }
                                }
                                else {
                                    if (math.vec_equal(en_passant_piece.cell, LAST_MOVED_PIECE_BLACK.cell)) {
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

    piece.get_next_cell <- function () {
        if (math.vec_equal(cell, target_cell)) {
            target_cell = null;
            return;
        }

        local offset = cell - target_cell;
        local abs_offset = math.vec_abs(offset);

        if (abs_offset.x == abs_offset.y) { next_cell = cell - Vector(offset.x / abs_offset.x, offset.y / abs_offset.y); }
        else { next_cell = cell - Vector(offset.x / abs_offset.x); }

        time_last_cell = Time();
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

    piece.get_all_moves <- function (in_simple_pieces) {
        return engine.get_straight_moves(cell, team, in_simple_pieces);
    }

    piece.get_next_cell <- function () {
        if (math.vec_equal(cell, target_cell)) {
            target_cell = null;
            return;
        }
    
        local offset = cell - target_cell;
        local abs_offset = math.vec_abs(offset);

        if (offset.x == 0) { next_cell = cell - Vector(0, offset.y / abs_offset.y); }
        else if (offset.y == 0) { next_cell = cell - Vector(offset.x / abs_offset.x); }

        time_last_cell = Time();
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

    piece.get_all_moves <- function (in_simple_pieces) {
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

    piece.get_next_cell <- function () {
        if (math.vec_equal(cell, target_cell)) {
            target_cell = null;
            return;
        }

        local total_offset = referece_cell - target_cell;
        local abs_total_offset = math.vec_abs(total_offset);
        local offset = cell - target_cell;
        local abs_offset = math.vec_abs(offset);

        if (((abs_total_offset.x > abs_total_offset.y) && (abs_offset.x > 0)) || abs_offset.y == 0) { next_cell = cell - Vector(offset.x / abs_offset.x); }
        else { next_cell = cell - Vector(0, offset.y / abs_offset.y); }

        time_last_cell = Time();
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
    
    piece.get_all_moves <- function (in_simple_pieces) {
        return engine.get_diagonal_moves(cell, team, in_simple_pieces);
    }

    piece.get_next_cell <- function () {
        if (math.vec_equal(cell, target_cell)) {
            target_cell = null;
            return;
        }

        local offset = cell - target_cell;
        local abs_offset = math.vec_abs(offset);

        next_cell = Vector(cell.x - (offset.x / abs_offset.x), cell.y - (offset.y / abs_offset.x));
    
        time_last_cell = Time();
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

    piece.get_all_moves <- function (in_simple_pieces) {
        local straight_moves = engine.get_straight_moves(cell, team, in_simple_pieces);
        local diagonal_moves = engine.get_diagonal_moves(cell, team, in_simple_pieces);
        return utils.list_merge(straight_moves, diagonal_moves);
    }

    piece.get_next_cell <- function () {
        if (math.vec_equal(cell, target_cell)) {
            target_cell = null;
            return;
        }
    
        local offset = cell - target_cell;
        local abs_offset = math.vec_abs(offset);

        if (offset.x == 0) {
            next_cell = cell - Vector(0, offset.y / abs_offset.y);
        }
        else if (offset.y == 0) {
            next_cell = cell - Vector(offset.x / abs_offset.x);
        }
        else {
            next_cell = Vector(cell.x - (offset.x / abs_offset.x), cell.y - (offset.y / abs_offset.x));
        }

        time_last_cell = Time();
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

    piece.get_all_moves <- function (in_simple_pieces) {
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

        // Castling
        if (times_moved == 0) {
            // TODO:
            // Cant castle when in check
            // Cant castle threw a check

            // Right
            if (utils.list_vec_contains(possible_moves[3], moves)) {
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
            // Left
            if (utils.list_vec_contains(possible_moves[7], moves)) {
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

        return moves;
    }

    piece.get_next_cell <- function () {
        if (math.vec_equal(cell, target_cell)) {
            target_cell = null;
            return;
        }

        local offset = cell - target_cell;
        local abs_offset = math.vec_abs(offset);

        if (offset.x == 0) {
            next_cell = cell - Vector(0, offset.y / abs_offset.y);
        }
        else if (offset.y == 0) {
            next_cell = cell - Vector(offset.x / abs_offset.x);
        }
        else {
            next_cell = Vector(cell.x - (offset.x / abs_offset.x), cell.y - (offset.y / abs_offset.x));
        }
        
        time_last_cell = Time();
    }

    return piece;
}
