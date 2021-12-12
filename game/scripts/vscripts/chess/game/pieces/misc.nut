
::new_simple_piece_from_piece <- function (in_piece) {

    local piece = {
        active = in_piece.active,
        team = in_piece.team,
        type = in_piece.type,
        cell = math.vec_clone(in_piece.cell),
        times_moved = in_piece.times_moved,
        get_all_moves = in_piece.get_all_moves,

        function move_to(in_move_to_cell) {
            times_moved++;
            cell = math.vec_clone(in_move_to_cell);
        }

        capture = in_piece.capture,
    }
    
    return piece;
}

::new_simple_pieces_from_pieces <- function (in_pieces) {

    local list = [];

    foreach (piece in in_pieces.pieces) {
        list.append(new_simple_piece_from_piece(piece));
    }

    local table = {
        pieces = list,
        get_from_cell = in_pieces.get_from_cell,
    }

    return table;
}

::new_pieces <- function () {

    local list = [];

    // Create Pawns
    for (local t = 0; t < 2; t++) {
        local team = TEAM.WHITE;
        if (t == 1) { team = TEAM.BLACK; }

        for (local file = 0; file < 8; file++) {
            local cell = Vector(1, file);
            if (team == TEAM.BLACK) { cell = Vector(6, file); }
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
                local pos = null;
                local angle = null;
                if (piece.active) {
                    pos = piece.get_world_pos(in_board_pos);
                    angle = piece.angle;
                }
                else {
                    pos = piece.get_captured_world_pos(in_board_pos);
                    if (piece.team == TEAM.WHITE) { angle = Vector(); }
                    else { angle = Vector(0,180); }
                }
                piece.teleport(pos, angle);
            }
        }
        function get_from_cell(in_cell, in_team_to_ignore=null) {
            foreach(piece in pieces) {
                if (piece.active) {
                    if ((piece.cell.x == in_cell.x) && (piece.cell.y == in_cell.y)) {
                        if (in_team_to_ignore != null) {
                            if (piece.team != in_team_to_ignore) { return piece; }
                        }
                        else {
                            return piece;
                        }
                    };
                }
            }
            return null;
        }
    }

    return table;
}
