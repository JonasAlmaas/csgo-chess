
::util_vec_mul <- function (vec, factor) {
    return Vector(vec.x * factor, vec.y * factor, vec.z * factor);
}
::util_sphere_to_cartesian <- function(vec){
    
    local theta = vec.y;
    local phi = vec.x + 90;

    theta = theta*(PI/180);
    phi = phi*(PI/180);

    local temp_x = sin(phi)*cos(theta);
    local temp_y = sin(phi)*sin(theta);
    local temp_z = cos(phi);

    return Vector(temp_x, temp_y, temp_z);
}
/* Find intersection of the lines defined by two points and two cartesian angles */
::util_2D_intersection_angles <- function(p1,a1,p3,a2){
 
    local p2 = p1 + a1;
    local p4 = p3 + a2;

    return util_2D_intersection(p1,p2,p3,p4);

}
/* Intersection of the line between p1 and p2, and the line between p3 and p4 */
::util_2D_intersection <- function(p1,p2,p3,p4){
    
    local d = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)
    local x = ((p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) / d
    local y = ((p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) / d

    return Vector(x,y);
}
/* Only planes orthogonal to floor */
::util_plane_intersection <- function(pSource, aSource, pTarget, aTarget, offset=0.0){

    local pXY = util_2D_intersection_angles(Vector(pSource.x, pSource.y),
                                            Vector(aSource.x, aSource.y),
                                            Vector(pTarget.x, pTarget.y),
                                            util_sphere_to_cartesian(Vector(0, aTarget.y + 90)));
    pXY += util_vec_mul(util_sphere_to_cartesian(Vector(0, aTarget.y + 90)), offset);

    local pZ = util_2D_intersection_angles( Vector(pSource.z, pSource.y),
                                            Vector(aSource.z, aSource.y),
                                            Vector(pXY.z, pXY.y),
                                            Vector(90,0));

    return Vector(pXY.x, pXY.y, pZ.x);
}
/* Only planes on the floor, no rotation */
::util_floor_plane_intersection <- function(pSource, aSource, pTarget){

    local pX = util_2D_intersection(
        Vector(pSource.x, pSource.z),
        Vector(pSource.x + aSource.x, pSource.z + aSource.z),
        Vector(pTarget.x, pTarget.z),
        Vector(pTarget.x + 1, pTarget.z)
    )

    local pY = util_2D_intersection(
        Vector(pSource.y, pSource.z),
        Vector(pSource.y + aSource.y, pSource.z + aSource.z),
        Vector(pTarget.y, pTarget.z),
        Vector(pTarget.y + 1, pTarget.z)
    )

    return Vector(pX.x, pY.x, pTarget.z);
}
