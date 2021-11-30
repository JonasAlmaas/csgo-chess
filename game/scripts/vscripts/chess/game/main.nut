
::new_game <- function () {

    if (IS_DEBUGGING) { console.log("Create: Game"); }
    
    local target = null;
    target = Entities.FindByName(target, "target_board");
    local board_pos = target.GetOrigin();

    local half_board_size = BOARD_SCALE * 4;
    local text_pos = board_pos + Vector(half_board_size, -half_board_size, 1152)

    local waiting_text = [];
    waiting_text.append(new_dynamic_text("Waiting for players: [1/2]", BOARD_SCALE * 0.35, "kanit_semibold", [20,20,20], "center_center", text_pos, Vector(0, 180)));
    waiting_text.append(new_dynamic_text("Waiting for players: [1/2]", BOARD_SCALE * 0.35, "kanit_semibold", [20,20,20], "center_center", text_pos, Vector(0, 0)));

    local game = {
        // Entities
        waiting_text = waiting_text,
        cursors = [],
        
        board = new_board(board_pos),
        pieces = new_pieces(),
        highlighter = new_highlighter(board_pos),

        turn = TEAM.WHITE,
        active_piece = null,
        piece_moveing = false,
        valid_moves = [],

        hit_ply1 = Vector(),
        hit_ply2 = Vector(),

        initialized = false,

        function reset() {
            if (IS_DEBUGGING) { console.log("Reset: Game"); }

            foreach (text in waiting_text) {
                text.kill();
            }

            foreach (cursor in cursors) {
                cursor.disable();
            }

            board.reset();
            pieces.reset();
            highlighter.reset();
        }

        function update() {
            
            if (!initialized) {
                foreach (text in waiting_text) {
                    text.kill();
                }

                // Create cursors for both players
                foreach (path in CURSOR_MODEL) {
                    cursors.append(new_cursor(path));
                }

                pieces.show();
                initialized = true;
            }

            // Get player hits
            hit_ply1 = board.get_intersection(player1.get_eyes(), player1.get_forward());
            hit_ply2 = board.get_intersection(player2.get_eyes(), player2.get_forward());

            // Place cursors for both players
            cursors[0].teleport(hit_ply1 + Vector(0, 0, GROUND_OFFSET));
            cursors[1].teleport(hit_ply2 + Vector(0, 0, GROUND_OFFSET));

            if (IS_DEBUGGING) {
                debug_draw.box(hit_ply1, Vector(-2,-2,-2), Vector(2,2,2), [255,0,255,255]);
                debug_draw.box(hit_ply2, Vector(-2,-2,-2), Vector(2,2,2), [255,0,255,255]);
            }
            
            if (IS_DEBUGGING) {
                foreach (move in valid_moves) {
                    debug_highlight_cell(board.pos, move, COLOR.VALID_MOVE);
                }
            }
            
            // TODO: DEBUG_SINGLE_PLAYER
            play(hit_ply1);
            // if (turn == PLAYER_1_TEAM) { play(hit_ply1); }
            // else { play(hit_ply2); }

            pieces.update_pos(board.pos);
        }

        function play(hit) {
            if (board.is_inside(hit)) {
                local cell = board.get_cell_from_pos(hit);

                // Highlight the hovered cell
                highlighter.update_hoverd_cell(cell);

                if (IS_DEBUGGING) {
                    debug_highlight_cell(board.pos, cell, COLOR.HOVERED_CELL);
                }

                local new_piece = pieces.get_from_cell(cell);

                if (active_piece) {
                    if (!active_piece.target_cell) {
                        if (piece_moveing) {
                            done_moveing();
                        }
                        else if (player_select()) {
                            if (new_piece && (new_piece.team == turn)) {
                                if (IS_DEBUGGING) { console.log("Selected pice of same team"); }
                                select_piece(new_piece);
                            }
                            else {
                                try_move(cell);
                            }
                        }
                    }
                }
                else {
                    if (new_piece && (new_piece.team == turn) && player_select()) {
                        select_piece(new_piece);
                    }
                }
            }
            else {
                highlighter.update_hoverd_cell(null);
            }
        }

        function flip_turn() {
            if (turn == TEAM.WHITE) {
                turn = TEAM.BLACK;
                if (IS_DEBUGGING) { console.log("Turn: Black"); }
            }
            else {
                turn = TEAM.WHITE;
                if (IS_DEBUGGING) { console.log("Turn: White"); }
            }
        }

        function try_move(in_cell) {
            if (utils.list_vec_contains(in_cell, valid_moves)) {
                if (IS_DEBUGGING) { console.log("Valid move"); }
                active_piece.move_to(in_cell);
                piece_moveing = true;
                valid_moves = [];
                highlighter.update_valid_moves(valid_moves);
            }
        }

        function done_moveing() {
            // Check if a piece should be captured by this move
            local captured_piece = pieces.get_from_cell(active_piece.cell, turn);
            if (captured_piece) {
                if (IS_DEBUGGING) { console.log("A piece was captured"); }
                captured_piece.capture();
            }

            // Log move
            if (turn == TEAM.WHITE) { LAST_MOVED_PIECE_WHITE = active_piece; }
            else if (turn == TEAM.BLACK) { LAST_MOVED_PIECE_BLACK = active_piece; }

            if (active_piece.type == PIECE_TYPE.PAWN) {
                // Check for "En Passant"
                local en_passant_cell = null;
                if (active_piece.cell.x == 2) { en_passant_cell = active_piece.cell + Vector(1); }
                else if (active_piece.cell.x == 5) { en_passant_cell = active_piece.cell - Vector(1); }

                if (en_passant_cell) {
                    local en_passant_piece = pieces.get_from_cell(en_passant_cell);
                    if (en_passant_piece) {
                        if (en_passant_piece.times_moved == 1) {
                            local should_capture_white = (turn == TEAM.BLACK) && math.vec_equal(en_passant_piece.cell, LAST_MOVED_PIECE_WHITE.cell)
                            local should_capture_black = (turn == TEAM.WHITE) && math.vec_equal(en_passant_piece.cell, LAST_MOVED_PIECE_BLACK.cell)
                            if (should_capture_white || should_capture_black) {
                                console.log("En Passant!");
                                en_passant_piece.capture();
                            }
                        }
                    }
                }

                // TODO: Check for "Pawn Promotion"
            }

            // Check for "Castling"
            else if (active_piece.type == PIECE_TYPE.KING) {
                if (active_piece.times_moved == 1) {
                    local castling_rook_cell = null;
                    local castling_rook_target = null;
                    if (active_piece.cell.y == 2) {
                        castling_rook_cell = active_piece.cell - Vector(0, 2);
                        castling_rook_target = active_piece.cell + Vector(0, 1);
                    }
                    else if (active_piece.cell.y == 6) {
                        castling_rook_cell = active_piece.cell + Vector(0, 1);
                        castling_rook_target = active_piece.cell - Vector(0, 1);
                    }
                    
                    if (castling_rook_cell) {
                        local castling_rook_piece = pieces.get_from_cell(castling_rook_cell);
                        if (castling_rook_piece) {
                            if (castling_rook_piece.times_moved == 0) {
                                console.log("Castling!");
                                active_piece = castling_rook_piece;
                                active_piece.move_to(castling_rook_target);
                                return;
                            }
                        }
                    }
                }
            }

            piece_moveing = false;
            active_piece = null;

            if (engine.is_check_mate(turn, new_simple_pieces_from_pieces(pieces))) {
                if (IS_DEBUGGING) {
                    if (turn == TEAM.WHITE) { console.log("Check mate! White team winns!"); }
                    else { console.log("Check mate! Black team winns!"); }
                }
            }
            else {
                flip_turn();
            }
        }

        function player_select() {
            // TODO: DEBUG_SINGLE_PLAYER
            return PLAYER_1_EVENTS.ATTACK;

            local ply1_select = (turn == PLAYER_1_TEAM && PLAYER_1_EVENTS.ATTACK);
            local ply2_select = (turn != PLAYER_1_TEAM && PLAYER_2_EVENTS.ATTACK);

            if (ply1_select || ply2_select) {
                if (IS_DEBUGGING) {
                    if (ply1_select) { console.log("Player 1: Select"); }
                    else { console.log("Player 2: Select"); }
                }

                return true;
            }

            return false;
        }

        function select_piece(in_piece) {
            valid_moves = engine.get_valid_moves(new_simple_piece_from_piece(in_piece), new_simple_pieces_from_pieces(pieces));

            if (valid_moves.len() > 0) {
                if (IS_DEBUGGING) { console.log("Selected a new piece"); }

                highlighter.update_valid_moves(valid_moves);

                active_piece = in_piece;
            }
            else {
                if (IS_DEBUGGING) { console.log("No valid moves"); }
                active_piece = null;
            }
        }
    }

    return game;
}
