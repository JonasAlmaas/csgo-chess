
::new_game <- function () {

    if (IS_DEBUGGING) { console.log("Create: Game"); }
    
    local target = null;
    target = Entities.FindByName(target, "target_board");
    local board_pos = target.GetOrigin();

    local half_board_size = BOARD_SCALE * 4;
    local text_pos = board_pos + Vector(half_board_size, -half_board_size, 1152)

    local game = {
        // Entities
        cursors = [],
        
        board = new_board(board_pos),
        pieces = new_pieces(),
        highlighter = new_highlighter(board_pos),
        pawn_promotion_handler = new_pawn_promotion_handler(board_pos),

        game_over = false,

        turn = TEAM.WHITE,
        active_piece = null,
        piece_moveing = false,
        valid_moves = [],

        hit_white = Vector(),
        hit_black = Vector(),

        initialized = false,

        function reset() {
            if (IS_DEBUGGING) { console.log("Reset: Game"); }

            foreach (cursor in cursors) {
                cursor.disable();
            }

            board.reset();
            pieces.reset();
            highlighter.reset();
            pawn_promotion_handler.reset();
        }

        // TODO: Implement this
        function soft_reset() {
            if (IS_DEBUGGING) { console.log("Soft Reset: Game"); }

            board.reset();
            board = new_board(board_pos);

            pieces.reset();
            pieces = new_pieces();
            // TODO: Is this needed?
            pieces.show();

            highlighter.reset();
            highlighter = new_highlighter(board_pos);

            pawn_promotion_handler.reset();
            pawn_promotion_handler = new_pawn_promotion_handler(board_pos);

            game_over = false;

            turn = TEAM.WHITE;
            active_piece = null;
            piece_moveing = false;
            valid_moves = [];
        }

        function update() {
            
            if (!initialized) {

                // Create cursors for both players
                foreach (path in CURSOR_MODEL) {
                    cursors.append(new_cursor(path));
                }

                pieces.show();
                initialized = true;
            }

            // Get player hits
            hit_white = board.get_intersection(player_white.get_eyes(), player_white.get_forward());
            hit_black = board.get_intersection(player_black.get_eyes(), player_black.get_forward());

            // Place cursors for both players
            local hald_board_size = BOARD_SCALE * 4;
            local board_center = board.pos + Vector(hald_board_size, -hald_board_size);
            
            if ((math.abs(board_center.x - hit_white.x) < 4096) && (math.abs(board_center.y - hit_white.y) < 4096)) {
                cursors[0].teleport(hit_white + Vector(0, 0, GROUND_OFFSET * 2));
            }
            if ((math.abs(board_center.x - hit_black.x) < 4096) && (math.abs(board_center.y - hit_black.y) < 4096)) {
                cursors[1].teleport(hit_black + Vector(0, 0, GROUND_OFFSET * 2));
            }

            if (IS_DEBUGGING) {
                debug_draw.box(hit_white, Vector(-2,-2,-2), Vector(2,2,2), [255,0,255,255]);
                debug_draw.box(hit_black, Vector(-2,-2,-2), Vector(2,2,2), [255,0,255,255]);

                foreach (move in valid_moves) {
                    debug_highlight_cell(board.pos, move, COLOR.VALID_MOVE);
                }
            }

            if (pawn_promotion_handler.waiting) {
                if (turn == TEAM.WHITE) { pawn_promotion_handler.update(player_white, player_select()); }
                else { pawn_promotion_handler.update(player_black, player_select()); }
            }
            else if (!game_over) {
                if (IS_DEBUGGING_SINGLE_PLAYER) { play(hit_white); }
                else {
                    if (turn == TEAM.WHITE) { play(hit_white); }
                    else { play(hit_black); }
                }
            }

            pieces.update_pos(board.pos);
        }

        function play(hit) {
            local is_inside_board = board.is_inside(hit);
            local cell = board.get_cell_from_pos(hit);
            local new_piece = pieces.get_from_cell(cell);

            if (active_piece) {
                if (!active_piece.target_cell) {
                    if (piece_moveing) {
                        done_moveing();
                    }
                    else if (is_inside_board) {
                        if (player_select()) {
                            if (new_piece && math.vec_equal(new_piece.cell, active_piece.cell)) {
                                deselect();
                            }
                            else if (new_piece && (new_piece.team == turn)) {
                                if (IS_DEBUGGING) { console.log("Selected pice of same team"); }
                                select_piece(new_piece);
                            }
                            else {
                                try_move(cell);
                            }
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
                highlighter.disable_valid_moves();
                highlighter.update_selected_piece();
                highlighter.update_last_move(active_piece.cell, in_cell);
            }
        }

        function deselect() {
            active_piece = null;
            valid_moves = [];
            highlighter.disable_valid_moves();
            highlighter.update_selected_piece();
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
                                if (IS_DEBUGGING) { console.log("En Passant!"); }
                                en_passant_piece.capture();
                            }
                        }
                    }
                }

                // Check for "Pawn Promotion"
                if (active_piece.cell.x == 7 || active_piece.cell.x == 0) {
                    if (IS_DEBUGGING) { console.log("Pawn Promotion"); }
                    pawn_promotion_handler.open(active_piece);
                    return;
                }
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
                                if (IS_DEBUGGING) { console.log("Castling!"); }
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
                game_over = true;

                // TODO: Make something happen when you win!
                if (turn == TEAM.WHITE) { console.log("Check mate! White team wins!"); }
                else { console.log("Check mate! Black team wins!"); }

                // if (IS_DEBUGGING) {
                //     if (turn == TEAM.WHITE) { console.log("Check mate! White team wins!"); }
                //     else { console.log("Check mate! Black team wins!"); }
                // }
            }
            else {
                flip_turn();
            }
        }

        function player_select() {
            if (IS_DEBUGGING_SINGLE_PLAYER) {
                return PLAYER_WHITE_EVENTS.ATTACK;
            }

            local ply1_select = (turn == TEAM.WHITE && PLAYER_WHITE_EVENTS.ATTACK);
            local ply2_select = (turn != TEAM.WHITE && PLAYER_BLACK_EVENTS.ATTACK);

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

            highlighter.update_selected_piece(in_piece.cell);

            if (valid_moves.len() > 0) {
                if (IS_DEBUGGING) { console.log("Selected a new piece"); }
                active_piece = in_piece;
                highlighter.update_valid_moves(valid_moves, active_piece.type, new_simple_pieces_from_pieces(pieces));
            }
            else {
                if (IS_DEBUGGING) { console.log("No valid moves"); }
                active_piece = null;
                highlighter.disable_valid_moves();
            }
            
        }
    }

    return game;
}
