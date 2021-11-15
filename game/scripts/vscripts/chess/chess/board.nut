
::new_board <- function (in_pos, in_scale) {

    local board = {
        pos = in_pos,
        scale = in_scale,

        delay = 5,
        last_time = 0,
        highlisted_cell = Vector(),

        function reset() {
            // Well, reset!
        }

        function debug_draw() {
            local size = scale * 8;

            local time = Time();
            if (time - last_time > delay) {
                last_time = time;
                highlisted_cell = Vector(RandomInt(0, 7), RandomInt(0, 7));
            }
            highlight_cell(pos, scale, highlisted_cell);

            // for (local row = 0; row < 9; row++) {
            //     local p1 = pos + Vector(row * scale);
            //     local p2 = p1 + Vector(0, -size);
            //     util_draw_line(p1, p2, [255,0,0]);
            // }

            // for (local col = 0; col < 9; col++) {
            //     local p1 = pos + Vector(0, -(col * scale));
            //     local p2 = p1 + Vector(size);
            //     util_draw_line(p1, p2, [0,0,255]);
            // }
        }
    }

    return board;
}
