
::new_player <- function (in_ref) {

    local player = {
        id = null,
        ref = in_ref,
        spawn_pos = in_ref.GetOrigin(),
        forward_vector = Vector(),

        function get_pos() { return ref.GetOrigin(); }
        function get_ang() { return ref.GetAngles(); }
        function get_vel() { return ref.GetVelocity(); }
        function get_eyes() { return ref.EyePosition() + Vector(0, 0, 0.065); }
        function get_forward() { return forward_vector; }

        function teleport(pos=null, ang=null, vel=null) {
            if (pos) { ref.SetOrigin(pos); }
            if (ang) { ref.SetAngles(ang.x, ang.y, ang.z); }
            if (vel) { ref.SetVelocity(vel); }
        }

        function set_fov(fov) {
            point_viewcontrol.__KeyValueFromFloat("fov", fov);
            EntFireByHandle(point_viewcontrol, "enable", "", 0.0, ref, null);
            EntFireByHandle(point_viewcontrol, "AddOutput", "spawnflags 0", 0.0, null, null);
            EntFireByHandle(point_viewcontrol, "disable", "", 0.0, null, null);
            EntFireByHandle(point_viewcontrol, "AddOutput", "spawnflags 136", 0.0, null, null);
        }
    }

    return player;
}
