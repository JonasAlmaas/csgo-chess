
::new_base_piece <- function (in_team, in_cell) {

    if (IS_DEBUGGING) {
        local color = "White";
        if (in_team == TEAM.BLACK) { color = "Black"; }
        console.log("Create: Piece [" + color + ", (" + in_cell.x + ", " + in_cell.y + ")]");
    }

    local COLOR_WHITE = [200,200,200];
    local COLOR_BLACK = [45,45,45];
    local COLOR_ERROR = [255,0,255];

    local piece = {
        active = true,
        
        team = in_team,
        type = PIECE_TYPE.NONE,
        prop = new_prop_dynamic(),
        angle = Vector(),

        times_moved = 0,

        cell = in_cell,
        target_cell = null,
        next_cell = null,

        time_per_cell = 0.15,
        time_last_cell = 0.0,

        function enable() { prop.enable(); }
        function disable() { prop.disable(); }
        
        function show() { prop.show(); }
        function hide() { prop.hide(); }

        function teleport(pos) { prop.teleport(pos, angle); }

        function set_color(color) { prop.set_color(color); }
        function set_model(path) { prop.set_model(path); }
        function set_scale(scale) { prop.set_scale(scale); }
        function set_type(in_type) { type = in_type; }

        function get_type() { return type; }

        function move_to(in_move_to_cell) {
            times_moved++;
            target_cell = in_move_to_cell;
        }
    }

    piece.set_scale(BOARD_SCALE);

    if (piece.team == TEAM.WHITE) {
        piece.set_color(COLOR_WHITE);
        piece.angle = Vector(0,90,0);
    }
    else if (piece.team == TEAM.BLACK) {
        piece.set_color(COLOR_BLACK);
        piece.angle = Vector(0,270,0);
    }
    else { piece.set_color(COLOR_ERROR); }

    return piece;
}
