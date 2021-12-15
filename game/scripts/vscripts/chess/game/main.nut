
/*
    info Teleport Destination
*/

::teleport_target_game_white <- null;
::teleport_target_game_black <- null;
teleport_target_game_white = Entities.FindByName(teleport_target_game_white, "teleport_target_game_white");
teleport_target_game_black = Entities.FindByName(teleport_target_game_black, "teleport_target_game_black")


::new_game <- function () {
    
    local half_board_size = BOARD_SCALE * 4;
    local text_pos = BOARD_POS + Vector(half_board_size, -half_board_size, 1152);

    local game = {
        cursors = [],
        
        board = null,
        pieces = null,
        highlighter = null,
        pawn_promotion_handler = null,
        ingame_menu = null,

        game_over = false,

        turn = null,
        active_piece = null,
        piece_moveing = false,
        valid_moves = null,

        hit_white = Vector(),
        hit_black = Vector(),

        initialized = false,

        function reset() {
            foreach (cursor in cursors) {
                cursor.disable();
            }

            board.reset();
            pieces.reset();
            highlighter.reset();
            pawn_promotion_handler.reset();
            ingame_menu.reset();
        }

        function soft_reset() {
            reset();
            init();
        }

        function init() {
            board = new_board();
            pieces = new_pieces();
            highlighter = new_highlighter();
            pawn_promotion_handler = new_pawn_promotion_handler();
            ingame_menu = new_ingame_menu();

            game_over = false;
        
            turn = TEAM.WHITE;
            active_piece = null;
            piece_moveing = false;
            valid_moves = [];

            initialized = false;
        }

        function update() {
            
            if (!initialized) {

                // Create cursors for both players
                foreach (path in CURSOR_MODEL) {
                    cursors.append(new_cursor(path));
                }
                
                ingame_menu.show();
                initialized = true;
            }

            update_player_hits();
            update_cursors();

            // Ingame menu
            if (ingame_menu.on_click_restart(player_white, player_black, PLAYER_WHITE_EVENTS.ATTACK, PLAYER_BLACK_EVENTS.ATTACK)) { soft_reset(); }
            if (ingame_menu.on_click_home(player_white, player_black, PLAYER_WHITE_EVENTS.ATTACK, PLAYER_BLACK_EVENTS.ATTACK)) { HOT_RELOAD(); }

            if (pawn_promotion_handler.is_open) {
                if (turn == TEAM.WHITE) {
                    pawn_promotion_handler.update(player_white, player_select());
                }
                else {
                    pawn_promotion_handler.update(player_black, player_select());
                }
            }
            else if (!game_over) {
                if (IS_DEBUGGING_SINGLE_PLAYER) {
                    play(hit_white);
                }
                else {
                    if (turn == TEAM.WHITE) { play(hit_white); }
                    else { play(hit_black); }
                }
            }

            pieces.update_pos();
        }

        function update_player_hits() {
            hit_white = board.get_intersection(player_white.get_eyes(), player_white.get_forward());
            hit_black = board.get_intersection(player_black.get_eyes(), player_black.get_forward());
        }

        function update_cursors() {
            local hald_board_size = BOARD_SCALE * 4;
            local board_center = BOARD_POS + Vector(hald_board_size, -hald_board_size);
            
            if ((math.abs(board_center.x - hit_white.x) < 8192) && (math.abs(board_center.y - hit_white.y) < 8192)) {
                cursors[0].show();

                if ((math.abs(board_center.x - hit_white.x) < BOARD_SCALE * 6)) {
                    cursors[0].teleport(hit_white + Vector(0, 0, GROUND_OFFSET * 2), Vector());
                }
                else {
                    local eyes = player_white.get_eyes();
                    local forward = player_white.get_forward();
                    local pos = ingame_menu.btn_restart_white.pos;
                    local ang = ingame_menu.btn_restart_white.ang;
                    cursors[0].teleport(tilted_plane_intersection(eyes, forward, pos, ang.z) + Vector(0, 0, GROUND_OFFSET * 2), ang);
                }
            }
            else {
                cursors[0].hide();
            }

            if ((math.abs(board_center.x - hit_black.x) < 8192) && (math.abs(board_center.y - hit_black.y) < 8192)) {
                cursors[1].show();

                if ((math.abs(board_center.x - hit_black.x) < BOARD_SCALE * 6)) {
                    cursors[1].teleport(hit_black + Vector(0, 0, GROUND_OFFSET * 1.95), Vector());
                }
                else {
                    local eyes = player_black.get_eyes();
                    local forward = player_black.get_forward();
                    local pos = ingame_menu.btn_restart_black.pos;
                    local ang = ingame_menu.btn_restart_black.ang;
                    cursors[1].teleport(tilted_plane_intersection(eyes, forward, pos, -ang.z) + Vector(0, 0, GROUND_OFFSET * 2), ang);
                }
            }
            else {
                cursors[1].hide();
            }
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
                if (is_inside_board && new_piece && (new_piece.team == turn) && player_select()) {
                    select_piece(new_piece);
                }
            }
        }

        function flip_turn() {
            if (turn == TEAM.WHITE) { turn = TEAM.BLACK; }
            else { turn = TEAM.WHITE; }
        }

        function try_move(in_cell) {
            if (utils.list_vec_contains(in_cell, valid_moves)) {
                active_piece.move_to(in_cell);
                piece_moveing = true;
                valid_moves = [];
                highlighter.disable_valid_moves();
                highlighter.update_selected_piece();
                highlighter.update_last_move(active_piece.cell, in_cell);

                local player = "White";
                if (turn == TEAM.BLACK) { player = "Black"; }

                console.chat("\n| " + player + " : " + console.color.green + cell_to_text(active_piece.cell) + console.color.white + " -> " + console.color.green + cell_to_text(in_cell));
                // TODO: Look at the color for this one, I kinda like dark blue. Atm the map is way to bright for it
                // console.chat("\n| " + player + " : " + console.color.dark_blue + cell_to_text(active_piece.cell) + console.color.white + " -> " + console.color.dark_blue + cell_to_text(in_cell));
            }
        }

        function done_moveing() {
            // Check if a piece should be captured by this move
            local captured_piece = pieces.get_from_cell(active_piece.cell, turn);
            if (captured_piece) {
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
                                en_passant_piece.capture();
                            }
                        }
                    }
                }

                // Check for "Pawn Promotion"
                if (active_piece.cell.x == 7 || active_piece.cell.x == 0) {
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

                local player = "White";
                if (turn == TEAM.BLACK) { player = "Black"; }

                console.chat("\n| Check mate :" + console.color.green + " " + player + " team wins");

                if (IS_DEBUGGING) {
                    if (turn == TEAM.WHITE) { console.log("Check mate! White team wins!"); }
                    else { console.log("Check mate! Black team wins!"); }
                }
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

            return (ply1_select || ply2_select);
        }

        function select_piece(in_piece) {
            valid_moves = engine.get_valid_moves(new_simple_piece_from_piece(in_piece), new_simple_pieces_from_pieces(pieces));

            highlighter.update_selected_piece(in_piece.cell);

            if (valid_moves.len() > 0) {
                active_piece = in_piece;
                highlighter.update_valid_moves(valid_moves, active_piece.type, new_simple_pieces_from_pieces(pieces));
            }
            else {
                active_piece = null;
                highlighter.disable_valid_moves();
            }    
        }

        function deselect() {
            active_piece = null;
            valid_moves = [];
            highlighter.disable_valid_moves();
            highlighter.update_selected_piece();
        }
    }

    game.init();

    return game;
}
