/*
    Constants
*/
::ALPHABET <- {
    UPPER = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"],
    LOWER = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
}

/*
    MISC
*/
::utils_remove_decals <- function () {
    console.run("r_cleardecals");
}

/*
    Convertion
*/
::utils_list_to_string <- function (list) {
    local str = "";
    foreach (element in list) { str += element; }
    return str;
}
::util_vec_to_string <- function(v){
    return "Vector("+ v.x + ", " + v.y + ", " + v.z + ")"
}

/*
    Math
*/
::util_vec_mul <- function (vec, factor) {
    return Vector(vec.x * factor, vec.y * factor, vec.z * factor);
}

/*
    Draw
*/
::util_draw_line <- function(p1, p2, RGB=[255,255,255], noDepthTest=true) {
    local draw_time = 1/TICKRATE;
    DebugDrawLine(p1, p2, RGB[0], RGB[1], RGB[2], noDepthTest, draw_time);
}
::util_draw_square <- function(p1, p2, p3, p4, RGB=[255,255,255], noDepthTest=true){
    util_draw_line(p1, p2, RGB, noDepthTest);
    util_draw_line(p2, p3, RGB, noDepthTest);
    util_draw_line(p3, p4, RGB, noDepthTest);
    util_draw_line(p1, p4, RGB, noDepthTest);
}
::util_draw_box <- function(p1, min=Vector(-0.5,-0.5,-0.5), max=Vector(0.5,0.5,0.5), RGB=[255, 0, 0, 255], draw_time=null){
    if (!draw_time) draw_time = 1 / TICKRATE;
    DebugDrawBox(p1, min, max, RGB[0], RGB[1], RGB[2], RGB[3], draw_time)
}
::util_draw_box_angles <- function(p1, min=Vector(-0.5,-0.5,-0.5), max=Vector(0.5,0.5,0.5), angles=Vector(0, 0, 0), RGB=[255, 0, 0, 255], draw_time=null){
    if (!draw_time) draw_time = 1 / TICKRATE;
    DebugDrawBoxAngles(p1, min, max, angles, RGB[0], RGB[1], RGB[2], RGB[3], draw_time)
}
