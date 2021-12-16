
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

::BOARD_POS <- utils.get_entity_from_name("target_board").GetOrigin();
::BOARD_SCALE <- 128;
::GROUND_OFFSET <- 0.15;

::COLOR <- {
    VALID_MOVE = [65, 145, 111],
    LAST_MOVE = [255, 198, 66],
    HOVERED = [0, 200, 111],
    SELECTED = [255, 227, 66],
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

::HIGHLIGHT_MODEL <- {
    CELL_OUTLINE = "models/chess/ui/cell_outliune.mdl",
    CAPTURE_MOVE = "models/chess/ui/capture_move.mdl",
    VALID_MOVE = "models/chess/ui/valid_move.mdl",
}

::PAWN_PROMOTION_MODEL <- {
    BACKGROUND = "models/chess/ui/pawn_promotion_background.mdl",
    ROOK = "models/chess/ui/pawn_promotion_rook.mdl",
    KNIGHT = "models/chess/ui/pawn_promotion_knight.mdl",
    BISHOP = "models/chess/ui/pawn_promotion_bishop.mdl",
    QUEEN = "models/chess/ui/pawn_promotion_queen.mdl",
}

::MENU_MODEL <- {
    HOME = "models/chess/ui/menu_home.mdl",
    RESTART = "models/chess/ui/menu_restart.mdl",
}

/*
    Info Targets
*/

local target_game_fall_off_white = null;
local target_game_fall_off_black = null;
target_game_fall_off_white = Entities.FindByName(target_game_fall_off_white, "target_game_fall_off_white");
target_game_fall_off_black = Entities.FindByName(target_game_fall_off_black, "target_game_fall_off_black");
::game_fall_off_white_pos <- target_game_fall_off_white.GetOrigin();
::game_fall_off_black_pos <- target_game_fall_off_black.GetOrigin();

/*
    FUNCTIONS
*/

::precache_manifest <- function (manifest) {
    foreach (path in manifest) {
        self.PrecacheModel(path);
    }
}

::precache_chess <- function() {
    precache_manifest(PIECE_MODEL);             // Pieces
    precache_manifest(CURSOR_MODEL);            // Cursors
    precache_manifest(HIGHLIGHT_MODEL);         // Highlight
    precache_manifest(PAWN_PROMOTION_MODEL);    // Pawn Promotion
    precache_manifest(MENU_MODEL);              // Menu
}

::new_cursor <- function (model_path) {
    local cursor = new_prop_dynamic();
    cursor.set_scale(BOARD_SCALE);
    cursor.set_model(model_path);
    cursor.disable_shadows();
    return cursor;
}

::game_fall_off_white <- function () {
    activator.SetOrigin(game_fall_off_white_pos);
}

::game_fall_off_black <- function () {
    activator.SetOrigin(game_fall_off_black_pos);
}

/*
    This is here because I already have a plane intersection method inside math.
    Both are kinda scuffed, so untill I make a good one it will just stay here.
*/
::tilted_plane_intersection <- function (eyes, forward, pos, ang) {

    local offsetXZ = math.vec_rotate_3D(Vector(0,1,0), Vector(0,0,ang));
    
    local pXZ = Vector();
    local pXY = Vector();

    {
        local p1 = Vector(eyes.x, eyes.z);
        local p2 = p1 + Vector(forward.x, forward.z);
        local p3 = Vector(pos.x, pos.z);
        local p4 = p3 + Vector(offsetXZ.y, offsetXZ.z);
        pXZ = math.intersection_2D(p1, p2, p3, p4);
    }

    {
        local p1 = Vector(eyes.x, eyes.y);
        local p2 = p1 + Vector(forward.x, forward.y);
        local p3 = Vector(pXZ.x, pos.y);
        local p4 = p3 + Vector(0,1);
        pXY = math.intersection_2D(p1, p2, p3, p4);
    }

    return Vector(pXZ.x, pXY.y, pXZ.y);
}

::cell_to_text <- function (cell) {
    return "" + constants.alphabet.upper[cell.y] + (cell.x + 1);
}
