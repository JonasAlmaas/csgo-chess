
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

::new_base_piece <- function (in_team, in_pos, in_scale) {

    local COLOR_WHITE = [200,200,200];
    local COLOR_BLACK = [25,25,25];
    local COLOR_ERROR = [255, 0, 0];

    local piece = {
        team = in_team,
        type = PICES_TYPE.NONE,
        pos = in_pos,
        prop = new_prop_dynamic(),
        scale = in_scale,

        function get_world_pos(board_pos) {
            local half_cell = scale * 0.5;
            return board_pos + math.vec_mul(pos, scale) + Vector(half_cell, half_cell);
        }
    }

    piece.prop.set_scale("modelscale", piece.scale);

    if (team == PIECE_TEAM.WHITE) { piece.prop.set_color(COLOR_WHITE); }
    else if (team == PIECE_TEAM.BLACK) { piece.prop.set_color(COLOR_BLACK); }
    else { piece.prop.set_color(COLOR_ERROR); }

    return piece;
}

::new_pawn <- function (team, pos, scale) {
    local piece = new_base_piece(team, pos, scale);
    piece.type = PICES_TYPE.PAWN;
    piece.prop.set_model("models/chess/pieces/pawn.mdl");
    return piece;
}

::new_rook <- function (team, pos, scale) {
    local piece = new_base_piece(team, pos);
    piece.type = PICES_TYPE.ROOK;
    piece.prop.set_model("models/chess/pieces/rook.mdl");
    return piece;
}

::new_knight <- function (team, pos, scale) {
    local piece = new_base_piece(team, pos);
    piece.type = PICES_TYPE.KNIGHT;
    piece.prop.set_model("models/chess/pieces/knight.mdl");
    return piece;
}

::new_bishop <- function (team, pos, scale) {
    local piece = new_base_piece(team, pos);
    piece.type = PICES_TYPE.BISHOP;
    piece.prop.set_model("models/chess/pieces/bishop.mdl");
    return piece;
}

::new_queen <- function (team, pos, scale) {
    local piece = new_base_piece(team, pos);
    piece.type = PICES_TYPE.QUEEN;
    piece.prop.set_model("models/chess/pieces/queen.mdl");
    return piece;
}

::new_king <- function (team, pos, scale) {
    local piece = new_base_piece(team, pos);
    piece.type = PICES_TYPE.KING;
    piece.prop.set_model("models/chess/pieces/king.mdl");
    return piece;
}
