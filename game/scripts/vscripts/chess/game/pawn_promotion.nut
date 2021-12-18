
::new_pawn_promotion_handler <- function () {
    
    local handler = {
        scale = 0.75,

        active_piece = null,
        is_open = false,

        half_cell = BOARD_SCALE * 0.5,

        ui_pos = Vector(),

        background_prop = null,
        rook_prop = null,
        knight_prop = null,
        bishop_prop = null,
        queen_prop = null,

        function reset() {
            is_open = false;

            if (background_prop)
                background_prop.disable();
            if (rook_prop)
                rook_prop.disable();
            if (knight_prop)
                knight_prop.disable();
            if (bishop_prop)
                bishop_prop.disable();
            if (queen_prop)
                queen_prop.disable();
        }

        function update(player, player_select) {

            local p = math.plane_intersection(player.get_eyes(), player.get_forward(), ui_pos, Vector(0,180));
            local rel_horizontal = math.abs(ui_pos.y - p.y);
            local rel_vertical = p.z - ui_pos.z;

            if (rel_horizontal <= half_cell) {
                local index = floor(rel_vertical / BOARD_SCALE);

                rook_prop.set_scale(BOARD_SCALE * scale);
                knight_prop.set_scale(BOARD_SCALE * scale);
                bishop_prop.set_scale(BOARD_SCALE * scale);
                queen_prop.set_scale(BOARD_SCALE * scale);

                switch (index) {
                    case 1:
                    {
                        rook_prop.set_scale(BOARD_SCALE);
                        if (player_select) {
                            local temp_piece = new_rook(3, Vector(0,0));
                            temp_piece.disable();

                            active_piece.set_type(PIECE_TYPE.ROOK);
                            active_piece.set_model(PIECE_MODEL.ROOK);
                            active_piece.get_all_moves <- temp_piece.get_all_moves;

                            close();
                        }
                        break;
                    }
                    case 2:
                    {
                        knight_prop.set_scale(BOARD_SCALE);
                        if (player_select) {
                            local temp_piece = new_knight(3, Vector(0,0));
                            temp_piece.disable();

                            active_piece.set_type(PIECE_TYPE.KNIGHT);
                            active_piece.set_model(PIECE_MODEL.KNIGHT);
                            active_piece.get_all_moves <- temp_piece.get_all_moves;

                            close();
                        }
                        break;
                    }
                    case 3:
                    {
                        bishop_prop.set_scale(BOARD_SCALE);
                        if (player_select) {
                            local temp_piece = new_bishop(3, Vector(0,0));
                            temp_piece.disable();

                            active_piece.set_type(PIECE_TYPE.BISHOP);
                            active_piece.set_model(PIECE_MODEL.BISHOP);
                            active_piece.get_all_moves <- temp_piece.get_all_moves;

                            close();
                        }
                        break;
                    }
                    case 4:
                    {
                        queen_prop.set_scale(BOARD_SCALE);
                        if (player_select) {
                            local temp_piece = new_queen(3, Vector(0,0));
                            temp_piece.disable();

                            active_piece.set_type(PIECE_TYPE.QUEEN);
                            active_piece.set_model(PIECE_MODEL.QUEEN);
                            active_piece.get_all_moves <- temp_piece.get_all_moves;

                            close();
                        }
                        break;
                    }
                }
            }
        }

        function open(piece) {
            active_piece = piece;
            is_open = true;

            local offset = math.vec_mul(active_piece.cell, BOARD_SCALE) + Vector(half_cell, half_cell);
            ui_pos = BOARD_POS + Vector(offset.x, -offset.y);
            local pos = null;
            local ang = null;

            if (active_piece.cell.x == 0) {
                ang = Vector(270,180);
                ui_pos += Vector(-half_cell);
                pos = ui_pos + Vector(0.75,0,half_cell);
            }
            else {
                ang = Vector(270);
                ui_pos += Vector(half_cell);
                pos = ui_pos + Vector(-0.75,0,half_cell);
            }

            if (!background_prop) {
                background_prop = new_prop_dynamic();
                background_prop.set_color(COLOR.PAWN_PROMOTION_UI_BACKGROUND);
                background_prop.disable_shadows();
                background_prop.set_scale(BOARD_SCALE);
                background_prop.set_model(PAWN_PROMOTION_MODEL.BACKGROUND);
            }
            if (!rook_prop) {
                rook_prop = new_prop_dynamic();
                rook_prop.set_color(COLOR.PAWN_PROMOTION_UI);
                rook_prop.disable_shadows();
                rook_prop.set_scale(BOARD_SCALE * scale);
                rook_prop.set_model(PAWN_PROMOTION_MODEL.ROOK);
            }
            if (!knight_prop) {
                knight_prop = new_prop_dynamic();
                knight_prop.set_color(COLOR.PAWN_PROMOTION_UI);
                knight_prop.disable_shadows();
                knight_prop.set_scale(BOARD_SCALE * scale);
                knight_prop.set_model(PAWN_PROMOTION_MODEL.KNIGHT);
            }
            if (!bishop_prop) {
                bishop_prop = new_prop_dynamic();
                bishop_prop.set_color(COLOR.PAWN_PROMOTION_UI);
                bishop_prop.disable_shadows();
                bishop_prop.set_scale(BOARD_SCALE * scale);
                bishop_prop.set_model(PAWN_PROMOTION_MODEL.BISHOP);
            }
            if (!queen_prop) {
                queen_prop = new_prop_dynamic();
                queen_prop.set_color(COLOR.PAWN_PROMOTION_UI);
                queen_prop.disable_shadows();
                queen_prop.set_scale(BOARD_SCALE * scale);
                queen_prop.set_model(PAWN_PROMOTION_MODEL.QUEEN);
            }

            background_prop.show();
            rook_prop.show();
            knight_prop.show();
            bishop_prop.show();
            queen_prop.show();

            background_prop.teleport(ui_pos, ang);
            rook_prop.teleport(pos + Vector(0,0,BOARD_SCALE), ang);
            knight_prop.teleport(pos + Vector(0,0,BOARD_SCALE * 2), ang);
            bishop_prop.teleport(pos + Vector(0,0,BOARD_SCALE * 3), ang);
            queen_prop.teleport(pos + Vector(0,0,BOARD_SCALE * 4), ang);
        }

        function close() {
            is_open = false;

            background_prop.hide();
            rook_prop.hide();
            knight_prop.hide();
            bishop_prop.hide();
            queen_prop.hide();
        }
    }

    return handler;
}
