
::math <- {
    function abs(val) {
        return sqrt(val * val);
    }
    function min(v1, v2) {
        if (v1 < v2) { return v1}
        return v2;
    }
    function max(v1, v2) {
        if (v1 > v2) { return v1}
        return v2;
    }
    function clamp(val, min, max) {
        if (val <= min) { return min; }
        if (val >= max) { return max; }
        return val;
    }
    function lerp(v1, v2, percent) {
        return v1 + (v2 - v1) * percent;
    }
    function vec_abs(v) {
        return Vector(abs(v.x), abs(v.y), abs(v.z));
    }
    function vec_equal(v1, v2) {
        return (v1.x == v2.x && v1.y == v2.y && v1.z == v2.z);
    }
    function vec_clamp(v, min, max) {
        return Vector(clamp(v.x, min, max), clamp(v.y, min, max), clamp(v.z, min, max));
    }
    function vec_mul(vec, factor) {
        return Vector(vec.x * factor, vec.y * factor, vec.z * factor);
    }
    function vec_div(vec, divisor) {
        return Vector(vec.x / divisor, vec.y / divisor, vec.z / divisor);
    }
    function vec_clone(v) {
        return Vector(v.x, v.y, v.z);
    }
    function vec_floor(v) {
        return Vector(floor(v.x), floor(v.y), floor(v.z));
    }
    function vec_lerp(v1, v2, percent) {
        return v1 + vec_mul(vec_relative(v2, v1), percent);
    }
    function vec_relative(v1, v2) {
        return v1 - v2;
    }
    function vec_rotate(vec, theta) {
        theta = theta*(PI/180);
        local newX = vec.x*cos(theta) - vec.y*sin(theta);
        local newY = vec.x*sin(theta) + vec.y*cos(theta);
        return Vector(newX, newY, vec.z);
    }
    function vec_rotate_pitch(vec, angX) {
        local theta = angX*(PI/180);
        local newX = vec.x*cos(theta) + vec.z*sin(theta);
        local newZ = vec.z*cos(theta) - vec.x*sin(theta);
        return Vector(newX, vec.y, newZ);
    }
    function vec_rotate_yaw(vec, angY) {
        local theta = angY*(PI/180);
        local newX = vec.x*cos(theta) - vec.y*sin(theta)
        local newY = vec.x*sin(theta) + vec.y*cos(theta)
        return Vector(newX, newY, vec.z)
    }
    function vec_rotate_roll(vec, angZ) {
        local theta = angZ*(PI/180);
        local newY = vec.y*cos(theta) - vec.z*sin(theta);
        local newZ = vec.z*cos(theta) + vec.y*sin(theta);
        return Vector(vec.x, newY, newZ);
    }
    // Rotate vector pitch, yaw, roll
    function vec_rotate_3d(vec, ang){
        vec = vec_rotate_roll(vec, ang.z)
        vec = vec_rotate_pitch(vec, ang.x)
        vec = vec_rotate_yaw(vec, ang.y)
        return vec
    }

    function sphere_to_cartesian(vec) {
        local theta = vec.y;
        local phi = vec.x + 90;

        theta = theta*(PI/180);
        phi = phi*(PI/180);

        local temp_x = sin(phi)*cos(theta);
        local temp_y = sin(phi)*sin(theta);
        local temp_z = cos(phi);

        return Vector(temp_x, temp_y, temp_z);
    }
    /* Intersection of the line between p1 and p2, and the line between p3 and p4 */
    function intersection_2D(p1,p2,p3,p4) {
        
        local d = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)
        local x = ((p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) / d
        local y = ((p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) / d

        return Vector(x,y);
    }
    /* Find intersection of the lines defined by two points and two cartesian angles */
    function intersection_angles_2D(p1,a1,p3,a2) {
    
        local p2 = p1 + a1;
        local p4 = p3 + a2;

        return intersection_2D(p1,p2,p3,p4);

    }
    /* Only planes orthogonal to floor */
    function plane_intersection(pSource, aSource, pTarget, aTarget) {

        local pXY = intersection_angles_2D(Vector(pSource.x, pSource.y),
                                            Vector(aSource.x, aSource.y),
                                            Vector(pTarget.x, pTarget.y),
                                            sphere_to_cartesian(Vector(0, aTarget.y + 90)));

        local pZ = intersection_angles_2D( Vector(pSource.z, pSource.y),
                                            Vector(aSource.z, aSource.y),
                                            Vector(pXY.z, pXY.y),
                                            Vector(90,0));

        return Vector(pXY.x, pXY.y, pZ.x);
    }
    /* Only planes on the floor, no rotation */
    function floor_plane_intersection(pSource, aSource, pTarget) {

        local pX = intersection_2D(
            Vector(pSource.x, pSource.z),
            Vector(aSource.x, aSource.z),
            Vector(pTarget.x, pTarget.z),
            Vector(pTarget.x + 1, pTarget.z)
        )

        local pY = intersection_2D(
            Vector(pSource.y, pSource.z),
            Vector(aSource.y, aSource.z),
            Vector(pTarget.y, pTarget.z),
            Vector(pTarget.y + 1, pTarget.z)
        )

        return Vector(pX.x, pY.x, pTarget.z);
    }
    /*
        p1 is the point you want to check if is inside
        p2 is the corner of the square you are checking within
        size is how large the area is
    */
    function vec_inside_2d(p1, p2, size) {
        local c1 = p2;
        local c2 = c1 + size;

        local within_x = (p1.x >= min(c1.x, c2.x) && p1.x <= max(c1.x, c2.x));
        local within_y = (p1.y >= min(c1.y, c2.y) && p1.y <= max(c1.y, c2.y));

        return (within_x && within_y);
    }
    function vec_inside_3d(p1, p2, size) {
        local c1 = p2;
        local c2 = c1 + size;

        local within_x = (p1.x >= min(c1.x, c2.x) && p1.x <= max(c1.x, c2.x));
        local within_y = (p1.y >= min(c1.y, c2.y) && p1.y <= max(c1.y, c2.y));
        local within_z = (p1.z >= min(c1.z, c2.z) && p1.z <= max(c1.z, c2.z));

        return (within_x && within_y && within_z);
    }
}
