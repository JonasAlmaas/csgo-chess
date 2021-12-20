
::new_pawn_promotion_handler <- function () {
    
    local handler = {
        model_scale = 0.75,


        active_piece = null,
        is_open = false,

        is_animating_open = false,
        is_animating_close = false,

        animation_start_time = 0.0,
        animation_time = 0.25,

        half_cell = BOARD_SCALE * 0.5,

        background_pos = Vector(),
        button_pos = Vector(),

        background_prop = null,
        rook_prop = null,
        knight_prop = null,
        bishop_prop = null,
        queen_prop = null,

        function reset() {
            is_open = false;
            is_animating_open = false;
            is_animating_close = false;

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
            
            if (is_animating_open || is_animating_close) {
                local time = Time();

                local percent = (time - animation_start_time) / animation_time;

                if (is_animating_open) {
                    if (percent >= 1) {
                        is_animating_open = false;
                    }
                }
                else {
                    percent = 1 - percent;
                    if (percent <= 0) {
                        background_prop.hide();
                        rook_prop.hide();
                        knight_prop.hide();
                        bishop_prop.hide();
                        queen_prop.hide();

                        is_open = false;
                        is_animating_close = false;
                    }
                }

                rook_prop.teleport(button_pos + Vector(0,0,BOARD_SCALE * percent));
                knight_prop.teleport(button_pos + Vector(0,0,(BOARD_SCALE * percent) *  2));
                bishop_prop.teleport(button_pos + Vector(0,0,(BOARD_SCALE * percent) * 3));
                queen_prop.teleport(button_pos + Vector(0,0,(BOARD_SCALE * percent) * 4));

                local scale = (BOARD_SCALE * model_scale) * percent
                background_prop.set_scale(BOARD_SCALE * percent);
                rook_prop.set_scale(scale);
                knight_prop.set_scale(scale);
                bishop_prop.set_scale(scale);
                queen_prop.set_scale(scale);

                return;
            }

            local p = math.plane_intersection(player.get_eyes(), player.get_forward(), background_pos, Vector(0,180));
            local rel_horizontal = math.abs(background_pos.y - p.y);
            local rel_vertical = p.z - background_pos.z;

            if (rel_horizontal <= half_cell) {
                local index = floor(rel_vertical / BOARD_SCALE);

                local scale = (BOARD_SCALE * model_scale)
                rook_prop.set_scale(scale);
                knight_prop.set_scale(scale);
                bishop_prop.set_scale(scale);
                queen_prop.set_scale(scale);

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
            
            is_animating_open = true;
            animation_start_time = Time();

            local offset = math.vec_mul(active_piece.cell, BOARD_SCALE) + Vector(half_cell, half_cell);
            background_pos = BOARD_POS + Vector(offset.x, -offset.y);
            local ang = Vector();

            if (active_piece.cell.x == 0) {
                ang = Vector(270, 180);
                background_pos += Vector(-half_cell);
                button_pos = background_pos + Vector(0.75,0,half_cell);
            }
            else {
                ang = Vector(270);
                background_pos += Vector(half_cell);
                button_pos = background_pos + Vector(-0.75,0,half_cell);
            }

            if (!background_prop) {
                background_prop = new_prop_dynamic();
                background_prop.set_color(COLOR.PAWN_PROMOTION_BACKGROUND);
                background_prop.disable_shadows();
                background_prop.set_scale(1);
                background_prop.set_model(PAWN_PROMOTION_MODEL.BACKGROUND);
            }
            if (!rook_prop) {
                rook_prop = new_prop_dynamic();
                rook_prop.set_color(COLOR.PAWN_PROMOTION_UI);
                rook_prop.disable_shadows();
                rook_prop.set_scale(1);
                rook_prop.set_model(PIECE_ICON_MODELS.WHITE.ROOK);
            }
            if (!knight_prop) {
                knight_prop = new_prop_dynamic();
                knight_prop.set_color(COLOR.PAWN_PROMOTION_UI);
                knight_prop.disable_shadows();
                knight_prop.set_scale(1);
                knight_prop.set_model(PIECE_ICON_MODELS.WHITE.KNIGHT);
            }
            if (!bishop_prop) {
                bishop_prop = new_prop_dynamic();
                bishop_prop.set_color(COLOR.PAWN_PROMOTION_UI);
                bishop_prop.disable_shadows();
                bishop_prop.set_scale(1);
                bishop_prop.set_model(PIECE_ICON_MODELS.WHITE.BISHOP);
            }
            if (!queen_prop) {
                queen_prop = new_prop_dynamic();
                queen_prop.set_color(COLOR.PAWN_PROMOTION_UI);
                queen_prop.disable_shadows();
                queen_prop.set_scale(1);
                queen_prop.set_model(PIECE_ICON_MODELS.WHITE.QUEEN);
            }

            background_prop.show();
            rook_prop.show();
            knight_prop.show();
            bishop_prop.show();
            queen_prop.show();

            rook_prop.teleport(null, ang);
            knight_prop.teleport(null, ang);
            bishop_prop.teleport(null, ang);
            queen_prop.teleport(null, ang);

            background_prop.teleport(background_pos, ang);
        }

        function close() {
            is_animating_close = true;
            animation_start_time = Time();
        }
    }

    return handler;
}
