
::new_board <- function () {
    
    local board = {

        text = new_board_text(BOARD_POS + Vector(0, 0, GROUND_OFFSET)),

        function reset() {
            text.reset();
        }
        function get_relatvive_pos(p) {
            local rel_x = math.max(p.x, BOARD_POS.x) - math.min(p.x, BOARD_POS.x);
            local rel_y = math.max(p.y, BOARD_POS.y) - math.min(p.y, BOARD_POS.y);
            return Vector(rel_x, rel_y);
        }
        function get_cell_exact_from_pos(p) {
            return math.vec_div(get_relatvive_pos(p) ,BOARD_SCALE);
        }
        function get_cell_from_pos(p) {
            return math.vec_clamp(math.vec_floor(get_cell_exact_from_pos(p)), 0, 7);
        }
        function get_intersection(eyes, forward) {
            return math.floor_plane_intersection(eyes, eyes + forward, BOARD_POS);
        }
        function is_inside(hit) {
            local board_size = BOARD_SCALE * 8;
            return math.vec_inside_2d(hit, BOARD_POS, Vector(board_size, -board_size))
        }
    }

    return board;
}
