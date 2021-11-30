
::new_highlighter <- function (in_board_pos) {
    if (IS_DEBUGGING) { console.log("Create: Highlighter"); }

    local manager = {
        hover_cell_color = [255, 255, 0],
        valid_move_color = [255, 255, 0],

        board_pos = in_board_pos,
        half_cell = BOARD_SCALE * 0.5,

        hoverd_cell_prop = null,
        valid_moves_props = [],

        function reset() {
            if (IS_DEBUGGING) { console.log("Reset: Highlighter"); }
            
            disable_valid_moves();
            disable_cell_highlighter();
        }

        function disable_valid_moves() {
            printl(valid_moves_props.len())
            foreach (prop in valid_moves_props) {
                prop.disable();
            }
            valid_moves_props = [];
        }

        function disable_cell_highlighter() {
            if (hoverd_cell_prop) {
                hoverd_cell_prop.disable();
            }
        }

        function update_valid_moves(valid_moves) {
            disable_valid_moves();

            foreach (move in valid_moves) {
                local prop = new_prop_dynamic_glow();
                prop.set_model("models/chess/ui/cell_outliune.mdl");
                prop.set_color(COLOR.VALID_MOVE);
                prop.set_glow_color(COLOR.VALID_MOVE);
                prop.set_glow_distance(100000);
                prop.disable_shadows();

                local offset = math.vec_mul(move, BOARD_SCALE) + Vector(half_cell, half_cell);
                local pos = board_pos + Vector(offset.x, -offset.y, GROUND_OFFSET);
                prop.teleport(pos);

                valid_moves_props.append(prop);
            }

            printl(valid_moves_props.len())
        }

        function update_hoverd_cell(in_cell) {
            if (in_cell) {
                if (!hoverd_cell_prop) {
                    hoverd_cell_prop = new_prop_dynamic_glow();
                    hoverd_cell_prop.set_model("models/chess/ui/cell_outliune.mdl");
                    hoverd_cell_prop.set_color(COLOR.HOVERED_CELL);
                    hoverd_cell_prop.set_glow_color(COLOR.HOVERED_CELL);
                    hoverd_cell_prop.set_glow_distance(100000);
                    hoverd_cell_prop.disable_shadows();
                }
                else {
                    if (hoverd_cell_prop.is_disabled) {
                        hoverd_cell_prop.enable();
                    }
                    local offset = math.vec_mul(in_cell, BOARD_SCALE) + Vector(half_cell, half_cell);
                    local pos = board_pos + Vector(offset.x, -offset.y, GROUND_OFFSET * 1.5);
                    hoverd_cell_prop.teleport(pos);
                }
            }
            else {
                disable_cell_highlighter();
            }
        }
    }
    
    return manager;
}
