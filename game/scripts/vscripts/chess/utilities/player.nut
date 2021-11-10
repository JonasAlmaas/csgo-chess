
::NewPlayer <- function (ref) {

    local player_table = {
        
        ref = ref,
        spawn_pos = ref.GetOrigin(),
        
        forwardVector = Vector(0,0,0)

        function weakTeleport(pos=null, ang=null, vel=null) {
            if(pos) {
                ref.SetOrigin(pos);
            }
            if(ang) {
                ref.SetAngles(ang.x, ang.y, ang.z);
            }
            if(vel) {
                ref.SetVelocity(vel);
            }
        }
        function getPos() {
            return ref.GetOrigin();
        }
        function getEyes() {
            return ref.EyePosition() + Vector(0, 0, 0.065);
        }
        function getAng() {
            return ref.GetAngles();
        }
        function getVel() {
            return ref.GetVelocity();
        }
        function getForwardVector() {
            return forwardVector;
        }
    }

    return player_table;
}
