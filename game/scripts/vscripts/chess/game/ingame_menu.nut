
::new_ingame_menu <- function () {

    local board_size = BOARD_SCALE * 8;
    local half_board_size = board_size * 0.5;
    local center_offset = BOARD_SCALE * 0.75;

    local btn_restart_white_pos = BOARD_POS + Vector(board_size + BOARD_SCALE * 2,  -half_board_size, 256) + Vector(0, -center_offset);
    local btn_restart_black_pos = BOARD_POS + Vector(            -BOARD_SCALE * 2,  -half_board_size, 256) + Vector(0,  center_offset);
    local btn_home_white_pos =    BOARD_POS + Vector(board_size + BOARD_SCALE * 2,  -half_board_size, 256) + Vector(0,  center_offset);
    local btn_home_black_pos =    BOARD_POS + Vector(            -BOARD_SCALE * 2,  -half_board_size, 256) + Vector(0, -center_offset);

    local btn_restart_white_ang = Vector(0, 270,  90 + math.vec_angle_from_pos(btn_restart_white_pos, teleport_target_game_white.GetOrigin() + Vector(0,0,48)).x);
    local btn_restart_black_ang = Vector(0,  90,  90 + math.vec_angle_from_pos(btn_restart_black_pos, teleport_target_game_black.GetOrigin() + Vector(0,0,48)).x);
    local btn_home_white_ang    = Vector(0,  90, -90 - math.vec_angle_from_pos(btn_home_white_pos,    teleport_target_game_white.GetOrigin() + Vector(0,0,48)).x);
    local btn_home_black_ang    = Vector(0, 270, -90 - math.vec_angle_from_pos(btn_home_black_pos,    teleport_target_game_black.GetOrigin() + Vector(0,0,48)).x);

    local menu = {

        btn_restart_white = new_ingame_menu_btn(btn_restart_white_pos, btn_restart_white_ang, MENU_MODEL.RESTART),
        btn_restart_black = new_ingame_menu_btn(btn_restart_black_pos, btn_restart_black_ang, MENU_MODEL.RESTART),
        btn_home_white = new_ingame_menu_btn(btn_home_white_pos, btn_home_white_ang, MENU_MODEL.HOME),
        btn_home_black = new_ingame_menu_btn(btn_home_black_pos, btn_home_black_ang, MENU_MODEL.HOME),

        function reset() {
            btn_restart_white.reset();
            btn_restart_black.reset();
            btn_home_white.reset();
            btn_home_black.reset();
        }

        function show() {
            btn_restart_white.show();
            btn_restart_black.show();
            btn_home_white.show();
            btn_home_black.show();
        }

        function hide() {
            btn_restart_white.hide();
            btn_restart_black.hide();
            btn_home_white.hide();
            btn_home_black.hide();
        }

        function on_click_restart(player_white, player_black, select_white, select_black) {
            local hit_white = btn_restart_white.hit(player_white);
            local hit_black = btn_restart_black.hit(player_black);

            if (hit_white) { btn_restart_white.set_scale(BOARD_SCALE * 1.5); }
            else           { btn_restart_white.set_scale(BOARD_SCALE); }
            
            if (hit_black) { btn_restart_black.set_scale(BOARD_SCALE * 1.5); }
            else           { btn_restart_black.set_scale(BOARD_SCALE); }

            return (hit_white && select_white) || (hit_black && select_black);
        }

        function on_click_home(player_white, player_black, select_white, select_black) {
            local hit_white = btn_home_white.hit(player_white);
            local hit_black = btn_home_black.hit(player_black);

            if (hit_white) { btn_home_white.set_scale(BOARD_SCALE * 1.5); }
            else           { btn_home_white.set_scale(BOARD_SCALE); }
            
            if (hit_black) { btn_home_black.set_scale(BOARD_SCALE * 1.5); }
            else           { btn_home_black.set_scale(BOARD_SCALE); }

            return (hit_white && select_white) || (hit_black && select_black);
        }
    }

    menu.hide();

    return menu;
}

::new_ingame_menu_btn <- function (in_pos, in_ang, model) {
    
    local btn = {
        pos = in_pos,
        ang = in_ang,
        prop = new_prop_dynamic(),

        function reset() { prop.disable(); }
        
        function show() { prop.show(); }
        function hide() { prop.hide(); }

        function set_scale(scale) { prop.set_scale(scale); }

        function hit(player) {

            local eyes = player.get_eyes();
            local forward = player.get_forward();

            local hit = tilted_plane_intersection(eyes, forward, pos, ang.z);

            local relY = math.vec_abs(pos - Vector(pos.x, hit.y, pos.z)).y;
            local relZ = math.vec_abs(pos - Vector(hit.x, pos.y, hit.z)).Length();

            return (relY < BOARD_SCALE * 0.5 && relZ < BOARD_SCALE * 0.5);
        }
    }

    btn.prop.teleport(btn.pos, btn.ang)
    btn.prop.set_scale(BOARD_SCALE);
    btn.prop.disable_shadows();
    btn.prop.set_model(model);

    return btn;
}
