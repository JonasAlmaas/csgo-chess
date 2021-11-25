
::PIECE_PATH <- {
    PAWN = "models/chess/pieces/pawn.mdl",
    ROOK = "models/chess/pieces/rook.mdl",
    KNIGHT = "models/chess/pieces/knight.mdl",
    BISHOP = "models/chess/pieces/bishop.mdl",
    QUEEN = "models/chess/pieces/queen.mdl",
    KING = "models/chess/pieces/king.mdl",
}

::precache_chess_pieces <- function() {
    foreach (path in PIECE_PATH) {
        self.PrecacheModel(path);
    }
}

::new_pieces <- function () {

    if (IS_DEBUGGING) { console.log("Create: Pieces"); }

    local list = [];

    for (local t = 0; t < 2; t++) {
        local team = TEAM.WHITE;
        if (t == 1) { team = TEAM.BLACK; }

        // Create Pawns
        for (local i = 0; i < 8; i++) {
            local cell = Vector(1, i);
            if (team == TEAM.BLACK) { cell = Vector(6, i); }
            list.append(new_pawn(team, cell));
        }

    }

    // Create Rooks
    list.append(new_rook(TEAM.WHITE, Vector(0,0)));
    list.append(new_rook(TEAM.WHITE, Vector(0,7)));
    list.append(new_rook(TEAM.BLACK, Vector(7,7)));
    list.append(new_rook(TEAM.BLACK, Vector(7,0)));

    // Create Knights
    list.append(new_knight(TEAM.WHITE, Vector(0,1)));
    list.append(new_knight(TEAM.WHITE, Vector(0,6)));
    list.append(new_knight(TEAM.BLACK, Vector(7,6)));
    list.append(new_knight(TEAM.BLACK, Vector(7,1)));

    // Create Bishops
    list.append(new_bishop(TEAM.WHITE, Vector(0,2)));
    list.append(new_bishop(TEAM.WHITE, Vector(0,5)));
    list.append(new_bishop(TEAM.BLACK, Vector(7,5)));
    list.append(new_bishop(TEAM.BLACK, Vector(7,2)));

    // Create Queens
    list.append(new_queen(TEAM.WHITE, Vector(0,3)));
    list.append(new_queen(TEAM.BLACK, Vector(7,3)));

    // Create Kings
    list.append(new_king(TEAM.WHITE, Vector(0,4)));
    list.append(new_king(TEAM.BLACK, Vector(7,4)));

    foreach (piece in list) {
        piece.hide();
    }

    local table = {
        pieces = list,

        function reset() {
            if (IS_DEBUGGING) { console.log("Reset: Pieces"); }

            foreach (piece in pieces) {
                piece.disable();
            }
        }
        function show() {
            foreach (piece in pieces) {
                piece.show();
            }
        }
        function update_pos(in_board_pos) {
            foreach (piece in pieces) {
                local pos = engine.get_piece_world_pos(piece, in_board_pos);
                piece.teleport(pos);
            }
        }
        function get_from_cell(in_cell) {
            foreach(piece in pieces) {
                if ((piece.cell.x == in_cell.x) && (piece.cell.y == in_cell.y)) {
                    return piece;
                };
            }
        }
    }

    return table;
}

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
        team = in_team,
        type = PIECE_TYPE.NONE,
        prop = new_prop_dynamic(),
        angle = Vector(),

        cell = in_cell,
        target_cell = null,
        next_cell = null,

        time_per_cell = 0.25,
        time_last_cell = 0.0,

        function enable() { prop.enable(); }
        function disable() { prop.disable(); }
        
        function show() { prop.show(); }
        function hide() { prop.hide(); }

        function teleport(pos) { prop.teleport(pos, angle); }

        function set_color(color) { prop.set_color(color); }
        function set_model(path) { prop.set_model(path); }
        function set_scale(scale) { prop.set_scale(scale); }
        function set_type(in_type) { type = in_type; }

        function get_type() { return type; }
    }

    piece.set_scale(BOARD_SCALE);

    if (piece.team == TEAM.WHITE) {
        piece.set_color(COLOR_WHITE);
        piece.angle = Vector(0,90,0);
    }
    else if (piece.team == TEAM.BLACK) {
        piece.set_color(COLOR_BLACK);
        piece.angle = Vector(0,270,0);
    }
    else { piece.set_color(COLOR_ERROR); }

    return piece;
}

::new_pawn <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);
    piece.set_type(PIECE_TYPE.PAWN);
    piece.set_model(PIECE_PATH.PAWN);
    return piece;
}

::new_rook <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);
    piece.set_type(PIECE_TYPE.ROOK);
    piece.set_model(PIECE_PATH.ROOK);
    return piece;
}

::new_knight <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);
    piece.set_type(PIECE_TYPE.KNIGHT);
    piece.set_model(PIECE_PATH.KNIGHT);
    return piece;
}

::new_bishop <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);
    piece.set_type(PIECE_TYPE.BISHOP);
    piece.set_model(PIECE_PATH.BISHOP);
    return piece;
}

::new_queen <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);
    piece.set_type(PIECE_TYPE.QUEEN);
    piece.set_model(PIECE_PATH.QUEEN);
    return piece;
}

::new_king <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);
    piece.set_type(PIECE_TYPE.KING);
    piece.set_model(PIECE_PATH.KING);
    return piece;
}
