
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

        // Make pawns
        for (local i = 0; i < 8; i++) {
            local cell = Vector(1, i);
            if (t == 1) { cell = Vector(6, i); }
            pieces.append(new_pawn(team, cell, in_scale));
        }
    }
    return pieces;
}

::new_base_piece <- function (in_team, in_cell, in_scale) {

    local COLOR_WHITE = [200,200,200];
    local COLOR_BLACK = [25,25,25];
    local COLOR_ERROR = [255, 0, 0];

    local piece = {
        team = in_team,
        type = PIECE_TYPE.NONE,
        cell = in_cell,
        prop = new_prop_dynamic(),
        scale = in_scale,

        function disable() {
            prop.disable();
        }

        function get_world_pos(board_pos) {
            local half_cell = scale * 0.5;
            local offset = math.vec_mul(cell, scale)
            return board_pos + Vector(offset.x, -offset.y) + Vector(half_cell, -half_cell);
        }
    }

    piece.prop.set_scale(piece.scale);

    if (piece.team == PIECE_TEAM.WHITE) { piece.prop.set_color(COLOR_WHITE); }
    else if (piece.team == PIECE_TEAM.BLACK) { piece.prop.set_color(COLOR_BLACK); }
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
    local piece = new_base_piece(team, cell);
    piece.type = PIECE_TYPE.ROOK;
    piece.prop.set_model(PIECE_PATH.ROOK);
    return piece;
}

::new_knight <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell);
    piece.type = PIECE_TYPE.KNIGHT;
    piece.prop.set_model(PIECE_PATH.KNIGHT);
    return piece;
}

::new_bishop <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell);
    piece.type = PIECE_TYPE.BISHOP;
    piece.prop.set_model(PIECE_PATH.BISHOP);
    return piece;
}

::new_queen <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell);
    piece.type = PIECE_TYPE.QUEEN;
    piece.prop.set_model(PIECE_PATH.QUEEN);
    return piece;
}

::new_king <- function (team, cell, scale) {
    local piece = new_base_piece(team, cell);
    piece.type = PIECE_TYPE.KING;
    piece.prop.set_model(PIECE_PATH.KING);
    return piece;
}
