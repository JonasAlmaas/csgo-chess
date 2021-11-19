
enum PIECE_TYPE {
    NONE,
    PAWN,
    ROOK,
    KNIGHT,
    BISHOP,
    QUEEN,
    KING,
}

::PIECE_PATH <- {
    PAWN = "models/chess/pieces/pawn.mdl",
    ROOK = "models/chess/pieces/rook.mdl",
    KNIGHT = "models/chess/pieces/knight.mdl",
    BISHOP = "models/chess/pieces/bishop.mdl",
    QUEEN = "models/chess/pieces/queen.mdl",
    KING = "models/chess/pieces/king.mdl",
}

::precache_chess_pieces <- function() {
    self.PrecacheModel(PIECE_PATH.PAWN);
    self.PrecacheModel(PIECE_PATH.ROOK);
    self.PrecacheModel(PIECE_PATH.KNIGHT);
    self.PrecacheModel(PIECE_PATH.BISHOP);
    self.PrecacheModel(PIECE_PATH.QUEEN);
    self.PrecacheModel(PIECE_PATH.KING);
}

::new_pieces <- function (in_scale) {
    
    local list = [];

    for (local t = 0; t < 2; t++) {
        local team = TEAM.WHITE;
        if (t == 1) { team = TEAM.BLACK; }

        // Create Pawns
        for (local i = 0; i < 8; i++) {
            local cell = Vector(1, i);
            if (team == TEAM.BLACK) { cell = Vector(6, i); }
            list.append(new_pawn(team, cell, in_scale));
        }

    }

    // Create Rooks
    list.append(new_rook(TEAM.WHITE, Vector(0,0), in_scale));
    list.append(new_rook(TEAM.WHITE, Vector(0,7), in_scale));
    list.append(new_rook(TEAM.BLACK, Vector(7,7), in_scale));
    list.append(new_rook(TEAM.BLACK, Vector(7,0), in_scale));

    // Create Knights
    list.append(new_knight(TEAM.WHITE, Vector(0,1), in_scale));
    list.append(new_knight(TEAM.WHITE, Vector(0,6), in_scale));
    list.append(new_knight(TEAM.BLACK, Vector(7,6), in_scale));
    list.append(new_knight(TEAM.BLACK, Vector(7,1), in_scale));

    // Create Bishops
    list.append(new_bishop(TEAM.WHITE, Vector(0,2), in_scale));
    list.append(new_bishop(TEAM.WHITE, Vector(0,5), in_scale));
    list.append(new_bishop(TEAM.BLACK, Vector(7,5), in_scale));
    list.append(new_bishop(TEAM.BLACK, Vector(7,2), in_scale));

    // Create Queens
    list.append(new_queen(TEAM.WHITE, Vector(0,3), in_scale));
    list.append(new_queen(TEAM.BLACK, Vector(7,3), in_scale));

    // Create Kings
    list.append(new_king(TEAM.WHITE, Vector(0,4), in_scale));
    list.append(new_king(TEAM.BLACK, Vector(7,4), in_scale));

    foreach (piece in list) {
        piece.hide();
    }

    local table = {
        pieces = list,

        function reset() {
            foreach (piece in pieces) {
                piece.disable();
            }
        }
        function show() {
            foreach (piece in pieces) {
                piece.show();
            } 
        }
        function update_pos(board_pos) {
            foreach (piece in pieces) {
                local pos = piece.get_world_pos(board_pos);
                piece.teleport(pos);
            }
        }
        function get_from_cell(cell) {
            foreach(piece in pieces) {
                if ((piece.cell.x == cell.x) && (piece.cell.y == cell.y)) {
                    return piece;
                };
            }
        }
    }

    return table;
}

::new_base_piece <- function (in_team, in_cell, in_scale) {

    local COLOR_WHITE = [200,200,200];
    local COLOR_BLACK = [45,45,45];
    local COLOR_ERROR = [255,0,255];

    local piece = {
        team = in_team,
        type = PIECE_TYPE.NONE,
        prop = new_prop_dynamic(),
        scale = in_scale,
        angle = Vector(),

        cell = in_cell,
        target_cell = null,
        next_cell = null,

        time_per_cell = 0.25,
        time_last_cell = 0.0,

        function disable() {
            prop.disable(); 
        }
        function teleport(pos) {
            prop.teleport(pos, angle);
        }
        function show() {
            prop.show();
        }
        function hide() {
            prop.hide();
        }
        function get_world_pos_from_cell(in_board_pos, in_cell) {
            local half_cell = scale * 0.5;
            local offset = math.vec_mul(in_cell, scale);
            return in_board_pos + Vector(offset.x, -offset.y) + Vector(half_cell, -half_cell);
        }
        function get_world_pos(in_board_pos) {
            if (target_cell) {
                if (!next_cell) {
                    next_cell = get_next_cell();
                    time_last_cell = Time();
                    if (!next_cell) {
                        target_cell = null;
                    }
                }
            }

            if (!target_cell) {
                return get_world_pos_from_cell(in_board_pos, cell);
            }

            local cell_pos = get_world_pos_from_cell(in_board_pos, cell);
            local next_cell_pos = get_world_pos_from_cell(in_board_pos, next_cell);

            local percent = (Time() - time_last_cell) / time_per_cell;

            if (percent >= 1) {
                cell = math.vec_clone(next_cell);
                next_cell = null;
            }
            
            return math.vec_lerp(cell_pos, next_cell_pos, percent);

            return get_world_pos_from_cell(in_board_pos, cell);
        }
        // TODO: Should avoid other pieces
        function get_next_cell() {
            if (math.vec_equal(cell, target_cell)) {
                return null;
            }

            local offset = cell - target_cell;
            local abs_offset = math.vec_abs(offset);

            if (abs_offset.x > abs_offset.y) {
                if (offset.x < 0) { return cell + Vector(1); }
                else { return cell + Vector(-1); }
            }
            else {
                if (offset.y < 0) { return cell + Vector(0, 1); }
                else { return cell + Vector(0, -1); }
            }
        }
    }

    piece.prop.set_scale(piece.scale);

    if (piece.team == TEAM.WHITE) {
        piece.prop.set_color(COLOR_WHITE);
        piece.angle = Vector(0,90,0);
    }
    else if (piece.team == TEAM.BLACK) {
        piece.prop.set_color(COLOR_BLACK);
        piece.angle = Vector(0,270,0);
    }
    else { piece.prop.set_color(COLOR_ERROR); }

    return piece;
}

::new_pawn <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell, scale);
    piece.type = PIECE_TYPE.PAWN;
    piece.prop.set_model(PIECE_PATH.PAWN);
    return piece;
}

::new_rook <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell, scale);
    piece.type = PIECE_TYPE.ROOK;
    piece.prop.set_model(PIECE_PATH.ROOK);
    return piece;
}

::new_knight <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell, scale);
    piece.type = PIECE_TYPE.KNIGHT;
    piece.prop.set_model(PIECE_PATH.KNIGHT);
    return piece;
}

::new_bishop <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell, scale);
    piece.type = PIECE_TYPE.BISHOP;
    piece.prop.set_model(PIECE_PATH.BISHOP);
    return piece;
}

::new_queen <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell, scale);
    piece.type = PIECE_TYPE.QUEEN;
    piece.prop.set_model(PIECE_PATH.QUEEN);
    return piece;
}

::new_king <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell, scale);
    piece.type = PIECE_TYPE.KING;
    piece.prop.set_model(PIECE_PATH.KING);
    return piece;
}
