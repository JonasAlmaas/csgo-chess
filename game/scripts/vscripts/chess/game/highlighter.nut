
::new_highlighter <- function () {

    local manager = {
        half_cell = BOARD_SCALE * 0.5,

        selected_piece_prop = null,
        hoverd_cell_prop = null,
        last_move_from_prop = null,
        last_move_to_prop = null,
        valid_moves_props = [],

        // check stuff
        in_check_highlighter = false,
        in_check_highlighter_prop = null,
        in_check_highlighter_time = 0.0,
        in_check_highlighter_duration = 0.5,

        function reset() {
            disable_selected_piece();
            disable_hovered_cell();
            disable_last_move();
            disable_valid_moves();

            if (in_check_highlighter_prop) {
                in_check_highlighter_prop.disable();
            }
        }
        function update() {
            if (in_check_highlighter_prop) {
                if (Time() - in_check_highlighter_time >= in_check_highlighter_duration) {
                    in_check_highlighter_prop.hide();
                    in_check_highlighter_prop = false;
                }
            }
        }
        function disable_selected_piece() {
            if (selected_piece_prop) {
                selected_piece_prop.disable();
                selected_piece_prop = null;
            }
        }
        function disable_hovered_cell() {
            if (hoverd_cell_prop) {
                hoverd_cell_prop.disable();
                hoverd_cell_prop = null;
            }
        }
        function disable_last_move() {
            if (last_move_from_prop) {
                last_move_from_prop.disable();
                last_move_from_prop = null;
            }
            if (last_move_to_prop) {
                last_move_to_prop.disable();
                last_move_to_prop = null;
            }
        }
        function disable_valid_moves() {
            foreach (prop in valid_moves_props) {
                prop.disable();
            }
            valid_moves_props = [];
        }
        function hide_hovered_cell() {
            if (hoverd_cell_prop) {
                hoverd_cell_prop.hide();
            }
        }
        function update_selected_piece(cell=null) {
            if (!selected_piece_prop && cell) {
                selected_piece_prop = new_prop_dynamic();
                selected_piece_prop.set_color(COLOR.SELECTED);
                selected_piece_prop.disable_shadows();
                selected_piece_prop.set_scale(BOARD_SCALE);
                selected_piece_prop.set_model(HIGHLIGHT_MODEL.CELL_OUTLINE);
            }
            
            if (cell) {
                selected_piece_prop.show();
                local offset = math.vec_mul(cell, BOARD_SCALE) + Vector(half_cell, half_cell);
                local pos = BOARD_POS + Vector(offset.x, -offset.y, GROUND_OFFSET * 1.25);
                selected_piece_prop.teleport(pos);
            }
            else {
                selected_piece_prop.hide();
            }
        }
        function update_hovered_cell(cell) {
            if (!hoverd_cell_prop) {
                hoverd_cell_prop = new_prop_dynamic();
                hoverd_cell_prop.set_color(COLOR.HOVERED);
                hoverd_cell_prop.disable_shadows();
                hoverd_cell_prop.set_scale(BOARD_SCALE);
                hoverd_cell_prop.set_model(HIGHLIGHT_MODEL.CELL_OUTLINE);
            }
            hoverd_cell_prop.show();
            local offset = math.vec_mul(cell, BOARD_SCALE) + Vector(half_cell, half_cell);
            local pos = BOARD_POS + Vector(offset.x, -offset.y, GROUND_OFFSET * 1.275);
            hoverd_cell_prop.teleport(pos);
        }
        function update_last_move(from_cell, to_cell) {
            if (!last_move_from_prop) {
                last_move_from_prop = new_prop_dynamic();
                last_move_from_prop.set_color(COLOR.LAST_MOVE);
                last_move_from_prop.disable_shadows();
                last_move_from_prop.set_scale(BOARD_SCALE);
                last_move_from_prop.set_model(HIGHLIGHT_MODEL.CELL_OUTLINE);
            }

            if (!last_move_to_prop) {
                last_move_to_prop = new_prop_dynamic();
                last_move_to_prop.set_color(COLOR.LAST_MOVE);
                last_move_to_prop.disable_shadows();
                last_move_to_prop.set_scale(BOARD_SCALE);
                last_move_to_prop.set_model(HIGHLIGHT_MODEL.CELL_OUTLINE);
            }

            local from_offset = math.vec_mul(from_cell, BOARD_SCALE) + Vector(half_cell, half_cell);
            local from_pos = BOARD_POS + Vector(from_offset.x, -from_offset.y, GROUND_OFFSET * 1.25);

            local to_offset = math.vec_mul(to_cell, BOARD_SCALE) + Vector(half_cell, half_cell);
            local to_pos = BOARD_POS + Vector(to_offset.x, -to_offset.y, GROUND_OFFSET * 1.25);

            last_move_to_prop.teleport(to_pos);
            last_move_from_prop.teleport(from_pos);
        }
        function update_valid_moves(valid_moves, active_piece_type, simple_pieces) {
            disable_valid_moves();

            foreach (move in valid_moves) {
                local prop = new_prop_dynamic();
                prop.set_color(COLOR.VALID_MOVE);
                prop.disable_shadows();
                prop.set_scale(BOARD_SCALE);

                local offset = math.vec_mul(move, BOARD_SCALE) + Vector(half_cell, half_cell);
                local pos = BOARD_POS + Vector(offset.x, -offset.y, GROUND_OFFSET);
                prop.teleport(pos);

                if (simple_pieces.get_from_cell(move)) {
                    prop.set_model(HIGHLIGHT_MODEL.CAPTURE_MOVE);
                }
                else {
                    prop.set_model(HIGHLIGHT_MODEL.VALID_MOVE);
                }

                valid_moves_props.append(prop);
            }
        }
        function in_check_king(cell) {
            in_check_highlighter = true;
            in_check_highlighter_time = Time();

            if (in_check_highlighter_prop) {
                in_check_highlighter_prop.show();
            }
            else {
                in_check_highlighter_prop = new_prop_dynamic();
                in_check_highlighter_prop.set_color(COLOR.IN_CHECK);
                in_check_highlighter_prop.disable_shadows();
                in_check_highlighter_prop.set_scale(BOARD_SCALE);
                in_check_highlighter_prop.set_model(HIGHLIGHT_MODEL.CELL_OUTLINE);
            }

            local offset = math.vec_mul(cell, BOARD_SCALE) + Vector(half_cell, half_cell);
            local pos = BOARD_POS + Vector(offset.x, -offset.y, GROUND_OFFSET * 1.35);
            in_check_highlighter_prop.teleport(pos);
        }
    }
    
    return manager;
}
