
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

        waiting_text = waiting_text,
        
        board = new_board(board_pos),
        pieces = new_pieces(),

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

            board.reset();
            pieces.reset();
        }

        function update() {

            if (!initialized) {
                foreach (text in waiting_text) {
                    text.kill();
                }
                pieces.show();
                initialized = true;
            }

            // Get player hits
            hit_ply1 = board.get_intersection(player1.get_eyes(), player1.get_forward());
            hit_ply2 = board.get_intersection(player2.get_eyes(), player2.get_forward());

            // Place cursor for both players
            // Use a prop as a cursor!

            if (IS_DEBUGGING) {
                debug_draw.box(hit_ply1, Vector(-2,-2,-2), Vector(2,2,2), [255,0,255,255]);
                debug_draw.box(hit_ply2, Vector(-2,-2,-2), Vector(2,2,2), [255,0,255,255]);
            }
            
            if (turn == PLAYER_1_TEAM) { play(hit_ply1); }
            else { play(hit_ply2); }

            pieces.update_pos(board.pos);
        }

        function play(hit) {
            if (board.is_inside(hit)) {
                local cell = board.get_cell_from_pos(hit);

                // TODO: Display the valid moves somehow. Has to how on both clients.

                if (IS_DEBUGGING) {
                    // Highlight the hovered cell
                    debug_highlight_cell(board.pos, cell, COLOR.HOVERED_CELL);

                    // Highlight all valid moves
                    foreach (move in valid_moves) {
                        debug_highlight_cell(board.pos, move, COLOR.VALID_MOVE);
                    }
                }

                local new_piece = pieces.get_from_cell(cell);

                if (active_piece) {
                    if (!active_piece.target_cell) {
                        if (piece_moveing) {
                            piece_moveing = false;
                            active_piece = null;
                            flip_turn();
                        }
                        else if (player_select()) {
                            if (new_piece && (new_piece.team == turn)) {
                                if (IS_DEBUGGING) { console.log("Selected pice of same team"); }
                                select_piece(new_piece);
                            }
                            else {
                                if (utils.list_vec_contains(cell, valid_moves)) {
                                    if (IS_DEBUGGING) { console.log("Valid move"); }
                                    active_piece.target_cell = cell;
                                    piece_moveing = true;
                                    valid_moves = [];
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

        function player_select() {
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
            if (IS_DEBUGGING) { console.log("Selected new piece"); }
            active_piece = in_piece;
            valid_moves = engine.get_valid_moves(active_piece, board);
        }
    }

    return game;
}
