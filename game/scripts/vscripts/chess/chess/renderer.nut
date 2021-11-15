
::highlight_cell <- function(board_pos, scale, cell_pos, color=[255,0,255], lines=20) {
    lines += 1;

    local half_scale = scale * 0.5;
    local offset = util_vec_mul(cell_pos, scale);

    local p1 = board_pos + Vector(offset.x, -offset.y, 0.1);
    local p2 = p1 + Vector(0, -scale);
    local p3 = p1 + Vector(scale, -scale);
    local p4 = p1 + Vector(scale);

    local step = (scale * 2) / lines;
    local start_pos = p1 + Vector(-scale);

    for (local i = 1; i < lines; i++) {
        local start = start_pos + Vector(i * step);
        local target = start + Vector(1, -1)
        local hit = util_2D_intersection(start, target, p2, p3) + Vector(0,0,p1.z);

        if (start.x < p1.x) {
            start = util_2D_intersection(start, target, p1, p2) + Vector(0,0,p1.z);
        }

        if (hit.x > p3.x) {
            hit = util_2D_intersection(start, target, p3, p4) + Vector(0,0,p1.z);
        }
        
        util_draw_line(start, hit, color, false);
    }
    util_draw_square(p1, p2, p3, p4, color, false);
}
