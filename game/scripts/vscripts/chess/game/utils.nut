
enum TEAM {
    WHITE,
    BLACK,
}

enum PIECE_TYPE {
    NONE,
    PAWN,
    ROOK,
    KNIGHT,
    BISHOP,
    QUEEN,
    KING,
}

::LAST_MOVED_PIECE_WHITE <- null;
::LAST_MOVED_PIECE_BLACK <- null;

::BOARD_SCALE <- 128;
::GROUND_OFFSET <- 0.1;

::COLOR <- {
    VALID_MOVE = [0,255,0],
    HOVERED_CELL = [113,169,222],
}

/*
    MODEL PATHS
*/

::PIECE_MODEL <- {
    PAWN = "models/chess/pieces/pawn.mdl",
    ROOK = "models/chess/pieces/rook.mdl",
    KNIGHT = "models/chess/pieces/knight.mdl",
    BISHOP = "models/chess/pieces/bishop.mdl",
    QUEEN = "models/chess/pieces/queen.mdl",
    KING = "models/chess/pieces/king.mdl",
}

::CURSOR_MODEL <- {
    BLACK = "models/chess/ui/cursor_black.mdl",
    WHITE = "models/chess/ui/cursor_white.mdl",
}

/*
    FUNCTIONS
*/

::precache_chess <- function() {
    // Pieces
    foreach (path in PIECE_MODEL) {
        self.PrecacheModel(path);
    }

    // Cursors
    foreach (path in CURSOR_MODEL) {
        self.PrecacheModel(path);
    }

    self.PrecacheModel("models/chess/ui/cell_outliune.mdl");
}

::new_cursor <- function (model_path) {
    local cursor = new_prop_dynamic();
    cursor.set_scale(BOARD_SCALE);
    cursor.set_model(model_path);
    cursor.disable_shadows();
    return cursor;
}

::debug_highlight_cell <- function(in_board_pos, in_cell, in_color=[255,0,255], in_lines=20) {
    in_lines += 1;

    local offset = math.vec_mul(in_cell, BOARD_SCALE);
    local c1 = in_board_pos + Vector(offset.x, -offset.y, GROUND_OFFSET);
    local c2 = c1 + Vector(0, -BOARD_SCALE);
    local c3 = c1 + Vector(BOARD_SCALE, -BOARD_SCALE);
    local c4 = c1 + Vector(BOARD_SCALE);

    local step_size = (BOARD_SCALE * 2) / in_lines;
    local offset_pos = c1 + Vector(-BOARD_SCALE);

    for (local i = 1; i < in_lines; i++) {
        local p1 = offset_pos + Vector(i * step_size);
        local p2 = p1 + Vector(1,-1);

        local hit = math.intersection_2D(p1, p2, c2, c3) + Vector(0,0,c1.z);

        if (p1.x < c1.x) { p1 = math.intersection_2D(p1, p2, c1, c2); }
        if (hit.x > c3.x) { hit = math.intersection_2D(p1, p2, c3, c4); }
        
        p1.z = c1.z;
        hit.z = c1.z;

        debug_draw.line(p1, hit, in_color, false);
    }

    debug_draw.square_outline(c1, c2, c3, c4, in_color, false);
}
