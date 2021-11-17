
::GROUND_OFFSET <- 0.1;

::new_game <- function() {

    local SCALE = 128;

    local target = null;
    target = Entities.FindByName(target, "target_board");
    local board_pos = target.GetOrigin();

    local half_board_size = SCALE * 4;
    local pos = board_pos + Vector(half_board_size, -half_board_size, 848);
    
    local waiting_text = [];
    waiting_text.append(new_dynamic_text("Waiting for players: [1/2]", SCALE * 0.35, "kanit_semibold", [40,40,40], "center_center", pos, Vector(0, 180)));
    waiting_text.append(new_dynamic_text("Waiting for players: [1/2]", SCALE * 0.35, "kanit_semibold", [40,40,40], "center_center", pos, Vector(0, 0)));

    local game = {
        waiting_text = waiting_text,

        board = new_board(board_pos, SCALE),
        pieces = new_pieces(SCALE),

        turn = TEAM.WHITE,

        active_piece = null,

        hovered_cell = null,
        hovered_cell_exact = null,

        initialized = false,

        function reset() {
            if (waiting_text) {
                foreach (text in waiting_text) {
                    text.kill();
                }
            }

            board.reset();
            pieces.reset();
        }
        function update() {
            if (!initialized) {
                foreach (text in waiting_text) {
                    text.kill();
                }
                initialized = true;
            }

            if (turn == TEAM.WHITE) { play(player1); }
            else { play(player2); }

            pieces.update_pos(board.pos);
        }
        function play(player) {
            local hit = board.get_intersection(player.get_eyes(), player.get_forward());
            
            if (board.is_inside(hit)) {
                local cell = board.get_cell_from_pos(hit);

                highlight_cell(board.pos, board.scale, cell, COLOR.HOVERED_CELL);

                if (!active_piece) {
                    local piece = pieces.get_from_cell(cell);
                    if (piece) {
                        if ((turn == TEAM.WHITE && PLAYER_1_EVENTS.BULLET_FIERED) || (turn == TEAM.BLACK && PLAYER_2_EVENTS.BULLET_FIERED)) {
                            if (piece.team == turn) {
                                active_piece = piece;
                            }
                        }
                    }
                }
                else {
                    if ((turn == TEAM.WHITE && PLAYER_1_EVENTS.BULLET_FIERED) || (turn == TEAM.BLACK && PLAYER_2_EVENTS.BULLET_FIERED)) {
                        local valid_move = false;
                        
                        local piece = pieces.get_from_cell(cell);
                        if (piece) { valid_move = (turn != piece.team); }
                        else { valid_move = true; }

                        if (valid_move) {
                            active_piece.target_cell = cell;
                            active_piece = null;

                            if (turn == TEAM.WHITE) { turn = TEAM.BLACK; }
                            else {turn = TEAM.WHITE; }
                        }
                    }
                }
            }
        }
    }

    return game;
}
