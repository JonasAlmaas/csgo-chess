
::util_draw_line <- function(p1, p2, RGB=[255,255,255], noDepthTest=true) {
    DebugDrawLine(p1, p2, RGB[0], RGB[1], RGB[2], noDepthTest, 0);
}
::util_draw_square <- function(p1, p2, p3, p4, RGB=[255,255,255], noDepthTest=true){
    util_draw_line(p1, p2, RGB, noDepthTest);
    util_draw_line(p2, p3, RGB, noDepthTest);
    util_draw_line(p3, p4, RGB, noDepthTest);
    util_draw_line(p1, p4, RGB, noDepthTest);
}
::util_draw_box <- function(p, min=Vector(-0.5,-0.5,-0.5), max=Vector(0.5,0.5,0.5), RGB=[255, 0, 0, 255], draw_time=null){
    if (!draw_time) draw_time = 0;
    DebugDrawBox(p, min, max, RGB[0], RGB[1], RGB[2], RGB[3], draw_time)
}
::util_draw_box_angles <- function(p, min=Vector(-0.5,-0.5,-0.5), max=Vector(0.5,0.5,0.5), angles=Vector(0, 0, 0), RGB=[255, 0, 0, 255], draw_time=null){
    if (!draw_time) draw_time = 0;
    DebugDrawBoxAngles(p, min, max, angles, RGB[0], RGB[1], RGB[2], RGB[3], draw_time)
}
