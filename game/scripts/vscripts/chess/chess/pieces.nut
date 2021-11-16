
enum PIECE_TYPE {
    NONE,
    PAWN,
    ROOK,
    KNIGHT,
    BISHOP,
    QUEEN,
    KING,
}

enum PIECE_TEAM {
    WHITE,
    BLACK,
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
    
    local pieces = [];

    for (local t = 0; t < 2; t++) {
        local team = PIECE_TEAM.WHITE;
        if (t == 1) { team = PIECE_TEAM.BLACK; }

        // Create Pawns
        for (local i = 0; i < 8; i++) {
            local cell = Vector(1, i);
            if (team == PIECE_TEAM.BLACK) { cell = Vector(6, i); }
            pieces.append(new_pawn(team, cell, in_scale));
        }

    }

    // Create Rooks
    pieces.append(new_rook(PIECE_TEAM.WHITE, Vector(0,0), in_scale));
    pieces.append(new_rook(PIECE_TEAM.WHITE, Vector(0,7), in_scale));
    pieces.append(new_rook(PIECE_TEAM.BLACK, Vector(7,7), in_scale));
    pieces.append(new_rook(PIECE_TEAM.BLACK, Vector(7,0), in_scale));

    // Create Knights
    pieces.append(new_knight(PIECE_TEAM.WHITE, Vector(0,1), in_scale));
    pieces.append(new_knight(PIECE_TEAM.WHITE, Vector(0,6), in_scale));
    pieces.append(new_knight(PIECE_TEAM.BLACK, Vector(7,6), in_scale));
    pieces.append(new_knight(PIECE_TEAM.BLACK, Vector(7,1), in_scale));

    // Create Bishops
    pieces.append(new_bishop(PIECE_TEAM.WHITE, Vector(0,2), in_scale));
    pieces.append(new_bishop(PIECE_TEAM.WHITE, Vector(0,5), in_scale));
    pieces.append(new_bishop(PIECE_TEAM.BLACK, Vector(7,5), in_scale));
    pieces.append(new_bishop(PIECE_TEAM.BLACK, Vector(7,2), in_scale));

    // Create Queens
    pieces.append(new_queen(PIECE_TEAM.WHITE, Vector(0,3), in_scale));
    pieces.append(new_queen(PIECE_TEAM.BLACK, Vector(7,3), in_scale));

    // Create Kings
    pieces.append(new_king(PIECE_TEAM.WHITE, Vector(0,4), in_scale));
    pieces.append(new_king(PIECE_TEAM.BLACK, Vector(7,4), in_scale));

    return pieces;
}

::new_base_piece <- function (in_team, in_cell, in_scale) {

    local COLOR_WHITE = [200,200,200];
    local COLOR_BLACK = [45,45,45];
    local COLOR_ERROR = [255,0,255];

    local piece = {
        team = in_team,
        type = PIECE_TYPE.NONE,
        cell = in_cell,
        prop = new_prop_dynamic(),
        scale = in_scale,
        angle = Vector(),

        function disable() {
            prop.disable(); 
        }
        function teleport(pos) {
            prop.teleport(pos, angle);
        }
        function get_world_pos(board_pos) {
            local half_cell = scale * 0.5;
            local offset = math.vec_mul(cell, scale)
            return board_pos + Vector(offset.x, -offset.y) + Vector(half_cell, -half_cell);
        }
    }

    piece.prop.set_scale(piece.scale);

    if (piece.team == PIECE_TEAM.WHITE) {
        piece.prop.set_color(COLOR_WHITE);
        piece.angle = Vector(0,90,0);
    }
    else if (piece.team == PIECE_TEAM.BLACK) {
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
