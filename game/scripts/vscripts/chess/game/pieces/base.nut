
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

        times_moved = 0,

        cell = in_cell,
        target_cell = null,
        next_cell = null,

        time_per_cell = 0.15,
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

        function move_to(in_move_to_cell) {
            times_moved++;
            target_cell = in_move_to_cell;
        }
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
    piece.set_model(PIECE_MODEL.PAWN);

    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {
        local step = 1;
        if (team == TEAM.BLACK) { step = -1; }

        local move_to_piece = in_simple_pieces.get_from_cell(in_move_to_cell);
        if (move_to_piece) {
            // Can't capture a king
            if (move_to_piece.type == PIECE_TYPE.KING) { return false; }

            // Diagonal capture
            if (move_to_piece.team != team) {
                if (in_move_to_cell.x == (cell.x + step)) {
                    if ((in_move_to_cell.y == (cell.y + step)) || (in_move_to_cell.y == (cell.y - step))) {
                        return true;
                    }
                }
            }
        }
        else {
            // Move directly forward
            if (in_move_to_cell.y == cell.y) {
                if (in_move_to_cell.x == (cell.x + step)) { return true;}                                   // One
                if ((times_moved == 0) && (in_move_to_cell.x == (cell.x + (step * 2)))) { return true; }    // Two
            }
        }

        return false;
    }

    return piece;
}

::new_rook <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.ROOK);
    piece.set_model(PIECE_MODEL.ROOK);
    
    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {
        local move_to_piece = in_simple_pieces.get_from_cell(in_move_to_cell);
        if (move_to_piece) {
            // Can't capture pices on your team
            if (move_to_piece.team == team) { return false; }
        }

        // Can't move if it is getting blocked
        if (engine.is_blocked_straight(cell, in_move_to_cell, in_simple_pieces)) { return false; }

        // Can move in straight lines
        if (in_move_to_cell.x == cell.x) { return true; }
        else if (in_move_to_cell.y == cell.y) { return true; }

        return false;
    }

    return piece;
}

::new_knight <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.KNIGHT);
    piece.set_model(PIECE_MODEL.KNIGHT);

    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {
        return false;
    }

    return piece;
}

::new_bishop <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.BISHOP);
    piece.set_model(PIECE_MODEL.BISHOP);

    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {
        local move_to_piece = in_simple_pieces.get_from_cell(in_move_to_cell);
        if (move_to_piece) {
            // Can't capture pices on your team
            if (move_to_piece.team == team) { return false; }
        }

        // Can't move if it is getting blocked
        if (engine.is_blocked_diagonally(cell, in_move_to_cell, in_simple_pieces)) { return false; }
        
        // Can move diagonally
        local offset_x = math.abs(cell.x - in_move_to_cell.x);
        local offset_y = math.abs(cell.y - in_move_to_cell.y);
        if (offset_x == offset_y) { return true; }

        return false;
    }

    return piece;
}

::new_queen <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.QUEEN);
    piece.set_model(PIECE_MODEL.QUEEN);

    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {
        local move_to_piece = in_simple_pieces.get_from_cell(in_move_to_cell);
        if (move_to_piece) {
            // Can't capture pices on your team
            if (move_to_piece.team == team) { return false; }
        }

        // Can't move if it is getting blocked
        if (engine.is_blocked_straight(cell, in_move_to_cell, in_simple_pieces)) { return false; }
        if (engine.is_blocked_diagonally(cell, in_move_to_cell, in_simple_pieces)) { return false; }

        // Can move straight
        if (in_move_to_cell.x == cell.x) { return true; }
        else if (in_move_to_cell.y == cell.y) { return true; }

        // Can move diagonally
        local offset_x = math.abs(cell.x - in_move_to_cell.x);
        local offset_y = math.abs(cell.y - in_move_to_cell.y);
        if (offset_x == offset_y) { return true; }

        return false;
    }

    return piece;
}

::new_king <- function (in_team, in_cell) {
    local piece = new_base_piece(in_team, in_cell);

    piece.set_type(PIECE_TYPE.KING);
    piece.set_model(PIECE_MODEL.KING);
    
    piece.can_move <- function (in_move_to_cell, in_simple_pieces) {
        return false;
    }

    return piece;
}
