
::COLOR <- {
    POSSIBLE_MOVES = [0,255,0],
    HOVERED_CELL = [113,169,222],
}

::highlight_cell <- function(board_pos, scale, cell_pos, color=[255,0,255], lines=20) {
    lines += 1;

    local offset = math.vec_mul(cell_pos, scale);
    local c1 = board_pos + Vector(offset.x, -offset.y, GROUND_OFFSET);
    local c2 = c1 + Vector(0, -scale);
    local c3 = c1 + Vector(scale, -scale);
    local c4 = c1 + Vector(scale);

    local step_size = (scale * 2) / lines;
    local offset_pos = c1 + Vector(-scale);

    for (local i = 1; i < lines; i++) {
        local p1 = offset_pos + Vector(i * step_size);
        local p2 = p1 + Vector(1,-1);

        local hit = math.intersection_2D(p1, p2, c2, c3) + Vector(0,0,c1.z);

        if (p1.x < c1.x) { p1 = math.intersection_2D(p1, p2, c1, c2); }
        if (hit.x > c3.x) { hit = math.intersection_2D(p1, p2, c3, c4); }
        
        p1.z = c1.z;
        hit.z = c1.z;

        debug_draw.line(p1, hit, color, false);
    }

    debug_draw.square_outline(c1, c2, c3, c4, color, false);
}
