
::debug_highlight_cell <- function(in_board_pos, in_cell_pos, in_color=[255,0,255], in_lines=20) {
    in_lines += 1;

    local offset = math.vec_mul(in_cell_pos, BOARD_SCALE);
    local c1 = in_board_pos + Vector(offset.x, -offset.y, GROUND_OFFSET);
    local c2 = c1 + Vector(0, -BOARD_SCALE);
    local c3 = c1 + Vector(BOARD_SCALE, -BOARD_SCALE);
    local c4 = c1 + Vector(BOARD_SCALE);

    local step_size = (BOARD_SCALE * 2) / in_lines;
    local offset_pos = c1 + Vector(-BOARD_SCALE);

    for (local i = 1; i < in_lines; i++) {
        local p1 = offset_pos + Vector(i * step_size);
        local p2 = p1 + Vector(1,-1);

        local hit = math.intersection_2D(p1, p2, c2, c3) + Vector(0,0,c1.z);

        if (p1.x < c1.x) { p1 = math.intersection_2D(p1, p2, c1, c2); }
        if (hit.x > c3.x) { hit = math.intersection_2D(p1, p2, c3, c4); }
        
        p1.z = c1.z;
        hit.z = c1.z;

        debug_draw.line(p1, hit, in_color, false);
    }

    debug_draw.square_outline(c1, c2, c3, c4, in_color, false);
}
