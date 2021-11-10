
::NewRook <- function (team, pos) {

    local model = NewPropDynamic();
    model.setModel("models/chess/pieces/rook.mdl");
    if (team == "white") {
        model.setColor([230, 230, 230]);
    } else {
        model.setColor([40, 40, 40]);
    }

    local piece = {
        type = "rook",
        team = team,
        model = model,
        pos = pos,

        function kill() {
            model.disable();
        }
        function teleport(pos=null, ang=null) {
            if(pos) {
                model.handle.SetOrigin(pos);
            }
            if(ang) {
                model.handle.SetAngles(ang.x, ang.y, ang.z);
            }
        }
        function setSize(size) {
            model.handle.__KeyValueFromFloat("modelscale", size)
        }
        function getPos() {
            return model.handle.GetOrigin();
        }
        function getAng() {
            return model.handle.GetAngles();
        }
    }
    
    return piece;
}
