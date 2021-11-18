
::GROUND_OFFSET <- 0.1;

enum TEAM {
    WHITE,
    BLACK,
}

::new_game <- function() {

    local SCALE = 128;

    local target = null;
    target = Entities.FindByName(target, "target_board");
    local board_pos = target.GetOrigin();

    local half_board_size = SCALE * 4;
    local pos = board_pos + Vector(half_board_size, -half_board_size, 1152);
    
    local waiting_text = [];
    waiting_text.append(new_dynamic_text("Waiting for players: [1/2]", SCALE * 0.35, "kanit_semibold", [20,20,20], "center_center", pos, Vector(0, 180)));
    waiting_text.append(new_dynamic_text("Waiting for players: [1/2]", SCALE * 0.35, "kanit_semibold", [20,20,20], "center_center", pos, Vector(0, 0)));

    local game = {
        waiting_text = waiting_text,

        board = new_board(board_pos, SCALE),
        pieces = new_pieces(SCALE),

        turn = TEAM.WHITE,

        active_piece = null,

        hovered_cell = null,
        hovered_cell_exact = null,

        hit_ply1 = Vector(),
        hit_ply2 = Vector(),

        initialized = false,

        function reset() {
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

            hit_ply1 = board.get_intersection(player1.get_eyes(), player1.get_forward());
            hit_ply2 = board.get_intersection(player2.get_eyes(), player2.get_forward());
            debug_draw.box(hit_ply1, Vector(-2,-2,-2), Vector(2,2,2), [255,0,255,255]);
            debug_draw.box(hit_ply2, Vector(-2,-2,-2), Vector(2,2,2), [255,0,255,255]);
            
            if (turn == PLAYER_1_TEAM) { play(hit_ply1); }
            else { play(hit_ply2); }

            pieces.update_pos(board.pos);
        }
        function play(hit) {            
            if (board.is_inside(hit)) {
                local cell = board.get_cell_from_pos(hit);

                highlight_cell(board.pos, board.scale, cell, COLOR.HOVERED_CELL);

                if (!active_piece) {
                    local piece = pieces.get_from_cell(cell);
                    if (piece) {
                        if ((turn == PLAYER_1_TEAM && PLAYER_1_EVENTS.ATTACK) || (turn != PLAYER_1_TEAM && PLAYER_2_EVENTS.ATTACK)) {
                            if (piece.team == turn) {
                                active_piece = piece;
                            }
                        }
                    }
                }
                else {
                    if ((turn == PLAYER_1_TEAM && PLAYER_1_EVENTS.ATTACK) || (turn != PLAYER_1_TEAM && PLAYER_2_EVENTS.ATTACK)) {
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
