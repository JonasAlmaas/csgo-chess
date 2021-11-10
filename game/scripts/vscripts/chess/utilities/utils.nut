::Util_headfeet_dist <- 64.062561;

::Util_head_to_feet<-function(pos){
    return Vector(pos.x, pos.y, pos.z-Util_headfeet_dist+1);
}
::Util_exec_delayed<-function(method, time){
    EntFire(SCRIPT_NAME,"RunScriptCode", method, time);
}
::setTimeout <- function(callback, milliseconds){
    ::callback <- callback;
    Util_exec_delayed("callback()", milliseconds*0.001)
}
::Util_trigger<-function(entname){
    EntFire(entname, "trigger", "");
}
::Util_enable<-function(entname){
    EntFire(entname, "enable", "");
    EntFire(entname, "SetEnabled", "");
}
::Util_disable<-function(entname){
    EntFire(entname, "disable", "");
    EntFire(entname, "SetDisabled", "");
}
::Util_lock<-function(entname){
    EntFire(entname, "lock", "");
}
::Util_unlock<-function(entname){
    EntFire(entname, "unlock", "");
}
::Util_pressIn<-function(entname){
    EntFire(entname, "PressIn", "");
}
::Util_pressOut<-function(entname){
    EntFire(entname, "PressOut", "");
}
::Util_get_mapname <- function () {
    local mapName = GetMapName();
    local slashIndex = mapName.find("/");
    while(slashIndex){
        mapName = mapName.slice(slashIndex + 1, mapName.len())
        slashIndex = mapName.find("/");
    }
    return mapName;
}
::Util_list_contains <- function(ref, list){
    if(list.len() <= 0) return false
    foreach (tempRef in list){
        if(tempRef == ref) return true
    }
    return false
}
::Util_list_contains_player<-function(ref, list){
    if(list.len() <= 0) return false;
    foreach (tempRef in list){
        if(tempRef != null){
            if(Util_compare_players(tempRef, ref)) return true;
        }
    }
    return false;
}
::Util_compare_players<-function(ply1, ply2){
    return ("" + ply1) == ("" + ply2);
}
::Util_set_team<-function(ply,teamid){
	EntFireByHandle(ply,"AddOutput","teamnumber " + teamid, 0, ply, ply);
}
::Util_weapon_is_ct<-function(wep){
    
    local wepName = wep.GetName();
    wepName = Util_substring(wepName, 4, wepName.len())
    
    if(wepName == "m4a1-s") return true;
    if(wepName == "m4a4") return true;
    if(wepName == "famas") return true;
    if(wepName == "aug") return true;
    if(wepName == "scar-20") return true;

    if(wepName == "mag7") return true;
    if(wepName == "m249") return true;
    if(wepName == "mp9") return true;

    if(wepName == "p2000") return true;
    if(wepName == "usp-s") return true;
    if(wepName == "fiveseven") return true;

    return false;
}
::Util_get_hitgroup<-function(id){
    switch(id){
        case 1:
        return "HEAD";
        case 2:
        return "UPPER_TORSO";
        case 3:
        return "LOWER_TORSO";
        case 4:
        return "LEFT_ARM";
        case 5:
        return "RIGHT_ARM";
        case 6:
        return "LEFT_LEG";
        case 7:
        return "RIGHT_LEG";
        default:
        return "UNKNOWN";
    }
}
/*
    String Manipulation
*/
::Util_includes <- function(text, chars){
    return text.find(chars) != null;
}
::Util_split <- function(text, chars){
    local space_index = text.find(chars);
    local charsLength = chars.len()
    local returnList = [];
    while(space_index != null){
        returnList.append(Util_substring(text, 0, space_index));
        text = Util_substring(text, space_index + charsLength, text.len());
        space_index = text.find(chars);
    }
    returnList.append(text)
    return returnList;
}
::Util_substring<-function(string, start_index, end_index){
    return string.slice(start_index, end_index);
}
::Util_replace <- function(text, chars, newChars){
    local tempList = Util_split(text, chars);
    local returnString = "";
    local first = true;
    foreach(s in tempList){
        if(first){
            first = false;
            returnString = s;
        } else {
            returnString = returnString + newChars + s;
        }
    }
    return returnString;
}
::Util_typecast<-function(id){
    local returnInteger = 0;
    local index = 0;
    while (index < id.len()){
        returnInteger = returnInteger * 10;
        local nextChar = Util_substring(id, index, index + 1)
        switch(nextChar){
            case "1": returnInteger += 1; break;
            case "2": returnInteger += 2; break;
            case "3": returnInteger += 3; break;
            case "4": returnInteger += 4; break;
            case "5": returnInteger += 5; break;
            case "6": returnInteger += 6; break;
            case "7": returnInteger += 7; break;
            case "8": returnInteger += 8; break;
            case "9": returnInteger += 9; break;
        }
        index += 1;
    }
    return returnInteger;
}
::Util_format_time_string<-function(time){

    local tempMins = 0;
    local tempTime = floor(time*10)/10.0;
   
    while(tempTime >= 60){
        tempMins = tempMins + 1;
        tempTime = tempTime - 60;
    }
    if(tempTime < 10 && tempMins > 0){
        tempTime = "0" + (floor((tempTime)*10)/10.0);
    } else {
        tempTime = "" + (floor((tempTime)*10)/10.0);
    }
    if(tempTime.find(".") == null){
        tempTime = tempTime + ".0";
    }
    if(tempMins > 0){
        tempTime = tempMins + "." + tempTime;
    }  
    return tempTime;
}
::Util_correct_number_ending<-function(number){
    if(number%10 >= 1 || (number%100 > 10 && number%100 < 20)){
        if(number%10 >= 2 || (number%100 > 10 && number%100 < 20)){
            if(number%10 >= 3 || (number%100 > 10 && number%100 < 20)){
                if(number%10 > 3 || (number%100 > 10 && number%100 < 20)){
                    return number + "th";
                } else {
                    return number + "rd";
                }
            } else {
                return number + "nd";
            }
        } else {
            return number + "st";
        }
    } else {
        return number + "th";
    }
}
::Util_valve_weapon_slot<-function(weapon_name){
    if(weapon_name == "knife"){
        return "knife"
    }
    switch(weapon_name){
        case "glock":
        return "pistol";
        case "elite":
        return "pistol";
        case "deagle":
        return "pistol";
        case "hkp2000":
        return "pistol";
        case "p250":
        return "pistol";
        case "fiveseven":
        return "pistol";
        case "tec9":
        return "pistol";
    }
    return "primary";
}
::Util_get_median <- function(list){
    list = Util_quick_sort(list);
    local length = list.len();
    local median;
    if(length % 2 == 0){
        local middleIndex = length / 2;
        median = (list[middleIndex] + list[middleIndex - 1])/2.0;
    } else {
        local middleIndex = floor(length / 2.0); 
        median = list[middleIndex];
    }
    return median;
}
::Util_quick_sort <- function(list){
    list.sort()
    return list;
}
::Util_fisher_shuffle <- function(list){
    local i = 0, j = 0;
    local n = list.len();
    local temp = null;
    while(i < n){
        j = RandomInt(0,(n-1));
        temp = list[i]
        list[i] = list[j]
        list[j] = temp
        i += 1;
    }
    return list;
}
::Util_print_array <- function(list){
    local index = 0;
    foreach(element in list){
        console.log(index + ":" + element)
        index += 1;
    }
}
::Util_init_array <- function (length){
    local index = 0;
    local list = [];
    while(index < length){
        list.append(null);
        index += 1;
    }
    return list;
}
/* Designed for nice inputs, use rest to generalize TODO */
::Util_pick_uniform <- function (list, amount) {
    local n = list.len();
    if(n <= amount) return list;

    local diff = n / amount; // not generalized
    local newList = [];
    local currentIndex = 0;
    local currentAmount = 0;
    while(currentAmount < amount){
        newList.append(list[currentIndex]);
        currentIndex += diff
        currentAmount += 1;
    }
    return newList;

}
::Util_decimal_digits <- function(val, digits) {
    local multiplier = 10.0*digits;
    return floor(val*multiplier + 0.5)/multiplier
}

//math and vector manipulation
::Util_toMeters<-function(units){
    return units*19.05/1000;
}
::Util_abs<-function(val){
    return sqrt(val*val);
}
::Util_round<-function(val){
    return floor( val + 0.5 );
}
::Util_hover_velocity <- 2.5;

::Util_length<-function(vec){
    return vec.Length();
}
::Util_get_positive_yaw <- function(a){
    while(a < 0){ a += 360; }
    return a % 360;
}
::Util_is_equal_angle <- function(a, b){
    return Util_get_positive_yaw(a) == Util_get_positive_yaw(b);
}
::Util_pitch_distance <- function(a, b){
    return Util_abs(b - a);
}
::Util_yaw_distance <- function(a, b){
    local dist = Util_get_positive_yaw(b - a)
    return dist > 180 ? Util_abs(dist-360) : dist;
}
::Util_euler_distance <- function(v1, v2){
    return Util_length(Vector(Util_pitch_distance(v1.x, v2.x), Util_yaw_distance(v1.y, v2.y), 0))
}
::Util_XY_dist<-function(vec1,vec2){
    local relX = vec1.x - vec2.x;
    local relY = vec1.y - vec2.y;
    local relZ = 0;
    local tempVec = Vector(relX,relY,relZ); 
    return tempVec.Length();
}
::Util_XYZ_dist<-function(vec1,vec2){
    return (vec1 - vec2).Length();
}
/* projection of v onto u */
::Util_projection<-function(u, v){
    return Util_vec_mul(u, v.Dot(u) / u.Dot(u));
}
::Util_relative_vec<-function(vec1,vec2){
    return vec1 - vec2;
}
::Util_vec_clone<-function(vec){
    return Vector(vec.x, vec.y, vec.z)
}
::Util_vec_add_z<-function(vec,scalar){
    return Vector(vec.x,vec.y,(vec.z + scalar));
}
//Rotate 90 degrees
::Util_XY_orthogonal<-function(vec){
    return Vector(vec.y,vec.x*(-1),0);
}
//Normalize sphere from cylinder
::Util_XY_normalize<-function(vec){
    local norm = vec.Length2D();
    return Vector(vec.x/norm,vec.y/norm,vec.z/norm);
}
//Normalize sphere from sphere
::Util_XYZ_normalize<-function(vec){
    local norm = vec.Length();
    return Vector(vec.x/norm,vec.y/norm,vec.z/norm);
}
//Scalar division
::Util_vec_div<-function(vec,div){
    return Vector(vec.x/div,vec.y/div,vec.z/div);
}
//Scalar multiplication
::Util_vec_mul<-function(vec,mul){
    return Vector(vec.x*mul,vec.y*mul,vec.z*mul);
}
::Util_vec_add<-function(vec1,vec2){
    local relX = vec1.x + vec2.x;
    local relY = vec1.y + vec2.y;
    local relZ = vec1.z + vec2.z;
    return Vector(relX,relY,relZ);
}
::Util_vec_sub<-function(vec1,vec2){
    local relX = vec1.x - vec2.x;
    local relY = vec1.y - vec2.y;
    local relZ = vec1.z - vec2.z;
    return Vector(relX,relY,relZ);
}
::Util_sphere_to_cartesian<-function(vec){
    
    local theta = vec.y;
    local phi = vec.x + 90;

    theta = theta*(PI/180);
    phi = phi*(PI/180);

    local temp_x = sin(phi)*cos(theta);
    local temp_y = sin(phi)*sin(theta);
    local temp_z = cos(phi);

    return Vector(temp_x, temp_y, temp_z);
}
::Util_cartesian_to_sphere<-function(vec){
    return Util_angles_to_look(Vector(0,0,0), vec);
}
::Util_angles_to_look<- function(orig_pos, look_pos){

    local relX = look_pos.x - orig_pos.x;
    local relY = look_pos.y - orig_pos.y;
    local relZ = look_pos.z - orig_pos.z; // -25 is chest

    local theta = acos(relZ/sqrt(pow(relX,2) + pow(relY,2) + pow(relZ,2)))*(180/PI)-90;
    local phi = atan2(relY,relX)*(180/PI);

    return Vector(theta,phi,0);
}
::Util_vec_rotate <- function(vec, theta){
    theta = theta*(PI/180);
    local newX = vec.x*cos(theta) - vec.y*sin(theta)
    local newY = vec.x*sin(theta) + vec.y*cos(theta)
    return Vector(newX, newY, vec.z)
}
::Util_vec_rotate_pitch <- function(vec, angX){
    local theta = angX*(PI/180);
    local newX = vec.x*cos(theta) + vec.z*sin(theta)
    local newZ = vec.z*cos(theta) - vec.x*sin(theta)
    return Vector(newX, vec.y, newZ)
}
::Util_vec_rotate_yaw <- function(vec, angY){
    local theta = angY*(PI/180);
    local newX = vec.x*cos(theta) - vec.y*sin(theta)
    local newY = vec.x*sin(theta) + vec.y*cos(theta)
    return Vector(newX, newY, vec.z)
}
::Util_vec_rotate_roll <- function(vec, angZ){
    local theta = angZ*(PI/180);
    local newY = vec.y*cos(theta) - vec.z*sin(theta)
    local newZ = vec.z*cos(theta) + vec.y*sin(theta)
    return Vector(vec.x, newY, newZ)
}

// Rotate vector pitch, yaw, roll
::Util_vec_rotate_3d <- function(vec, ang){
    vec = Util_vec_rotate_roll(vec, ang.z)
    vec = Util_vec_rotate_pitch(vec, ang.x)
    vec = Util_vec_rotate_yaw(vec, ang.y)
    return vec
}
/* Find bezier point from sorted control polygon */
::Util_get_bezier_point <- function(sorted_points, percent){
    return Util_get_bezier_point_recursive(sorted_points, percent);
}
::Util_get_bezier_point_recursive <- function(sorted_points, percent){
    if(sorted_points.len() == 0) return null;
    if(sorted_points.len() == 1) return sorted_points[0];

    local new_control_polygon = [];
    local last_p = null;
    foreach(p in sorted_points){
        if(last_p != null) new_control_polygon.append(Util_lerp(last_p,p,percent))
        last_p = p;
    }
    return Util_get_bezier_point_recursive(new_control_polygon, percent);
}

/* Find intersection of the lines defined by two points and two cartesian angles */
::Util_2D_intersection_angles <- function(p1,a1,p3,a2){
    
    local p2 = p1 + a1;
    local p4 = p3 + a2;

    return Util_2D_intersection(p1,p2,p3,p4);

}
/* Intersection of the line between p1 and p2, and the line between p3 and p4 */
::Util_2D_intersection <- function(p1,p2,p3,p4){
    
    local d = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)
    local x = ((p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) / d
    local y = ((p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) / d

    return Vector(x,y);
}
/* Only planes orthogonal to floor */
::Util_plane_intersection <- function(pSource, aSource, pTarget, aTarget, offset=0.0){

    local pXY = Util_2D_intersection_angles(Vector(pSource.x, pSource.y),
                                            Vector(aSource.x, aSource.y),
                                            Vector(pTarget.x, pTarget.y),
                                            Util_sphere_to_cartesian(Vector(0, aTarget.y + 90)));
    pXY += Util_vec_mul(Util_sphere_to_cartesian(Vector(0, aTarget.y + 90)), offset);

    local pZ = Util_2D_intersection_angles( Vector(pSource.z, pSource.y),
                                            Vector(aSource.z, aSource.y),
                                            Vector(pXY.z, pXY.y),
                                            Vector(90,0));

    return Vector(pXY.x, pXY.y, pZ.x);
}
/* Only planes on the floor, no rotation */
::Util_floor_plane_intersection <- function(pSource, aSource, pTarget){

    local pX = Util_2D_intersection(
        Vector(pSource.x, pSource.z),
        Vector(pSource.x + aSource.x, pSource.z + aSource.z),
        Vector(pTarget.x, pTarget.z),
        Vector(pTarget.x + 1, pTarget.z)
    )

    local pY = Util_2D_intersection(
        Vector(pSource.y, pSource.z),
        Vector(pSource.y + aSource.y, pSource.z + aSource.z),
        Vector(pTarget.y, pTarget.z),
        Vector(pTarget.y + 1, pTarget.z)
    )

    return Vector(pX.x, pY.x, pTarget.z);
}

::FINAL_LERP_LINEAR <- 1
::FINAL_LERP_COS <- 2
::FINAL_LERP_SIN <- 3
::FINAL_LERP_SMOOTH <- 4
::FINAL_LERP_SMOOTHER <- 5

::FINAL_LERPTYPE_VECTOR <- 1
::FINAL_LERPTYPE_COLOR <- 2
::FINAL_LERPTYPE_SCALAR <- 3

::Util_percent_cos <- function(percent) { return 1 - cos(percent * PI * 0.5); }
::Util_percent_sin <- function(percent) { return sin(percent * PI * 0.5); }
::Util_percent_smooth <- function(percent) { return percent*percent * (3 - 2*percent); }
::Util_percent_smoother <- function(percent) { return percent*percent*percent * (percent * (6*percent - 15) + 10); }

::Util_fancy_lerp<-function(orig,dest,percent,type,returntype){
    
    switch(type){
        case FINAL_LERP_LINEAR:
        break;
        case FINAL_LERP_COS:
        percent = Util_percent_cos(percent);
        break;
        case FINAL_LERP_SIN:
        percent = Util_percent_sin(percent)
        break;
        case FINAL_LERP_SMOOTH:
        percent = Util_percent_smooth(percent)
        break;
        case FINAL_LERP_SMOOTHER:
        percent = Util_percent_smoother(percent)
        break;
    }
    switch(returntype){
        case FINAL_LERPTYPE_SCALAR:
        return orig + (dest - orig)*percent
        
        case FINAL_LERPTYPE_VECTOR:
        return Util_vec_add(orig,(Util_vec_mul(Util_relative_vec(dest, orig),percent)));
       
        case FINAL_LERPTYPE_COLOR:
        local orig_pos = Vector(orig[0], orig[1], orig[2])
        local dest_pos = Vector(dest[0], dest[1], dest[2])
        local color_vec = orig_pos + Util_vec_mul(Util_relative_vec(dest_pos, orig_pos), percent);
        return [floor(color_vec.x + 0.5), floor(color_vec.y + 0.5), floor(color_vec.z + 0.5)]
    }
}
::Util_lerp<-function(orig_pos,dest_pos,percent){
    return Util_vec_add(orig_pos,(Util_vec_mul(Util_relative_vec(dest_pos, orig_pos),percent)));
}
::Util_scalar_lerp<-function(orig,dest,percent){
    return orig + (dest - orig)*percent
}
::Util_move_towards<-function(current, target, speed=15){
    local minDistanceDelta = 0.01;
    local distDelta = Util_XYZ_dist(current, target)
    if(distDelta < minDistanceDelta){
        return current;
    }
    distDelta *= (speed/1000.0);
    local rel_vec = Util_XYZ_normalize(Util_relative_vec(target, current))
    return current + Util_vec_mul(rel_vec, distDelta);
}
::Util_move_towards_ang<-function(current, target){
    local minDistanceDelta = 0.01;
    local distDelta = Util_XYZ_dist(current, target)
    if(distDelta < minDistanceDelta){
        return current;
    }
    distDelta /= 64.0;
    local cy = current.y;
    local ty = target.y;
    local tweaked = false;
    if(cy - ty > 0){
        while(cy - ty > 180){
            ty += 355; tweaked = true;
        } 
    } else {
        while(cy - ty < -180){
            ty -= 355; tweaked = true;
        } 
    }
    local rel_vec = Util_XYZ_normalize(Util_relative_vec(target, current));
    if(tweaked){
        return current + Util_vec_mul(rel_vec, distDelta) - Vector(0,ty - target.y,0);
    } else {
        return current + Util_vec_mul(rel_vec, distDelta);
    }
}
//statistics
::Util_zscore <- function(mean, std, x){
    return (x - mean)*1.0/std
}
::Util_prob_less_than <- function(mean, std, x) {
    return Util_z_table_less_than(Util_zscore(mean, std, x));
}
::Util_prob_more_than <- function(mean, std, x) {
    return 1 - Util_prob_less_than(mean, std, x)
}
::Util_prob_between <- function(mean, std, x, y) {
    if(y > x){
        return Util_prob_less_than(mean, std, y) - Util_prob_less_than(mean, std, x);
    } else {
        return Util_prob_less_than(mean, std, x) - Util_prob_less_than(mean, std, y);
    }
}
::Util_z_table_less_than <- function(zscore){
    if(zscore < 0){
        return 1 - Util_z_table_negative(zscore);
    } else {
        return Util_z_table_negative(zscore)
    }
}
::Util_z_score_table <- [0.5, 0.46017, 0.42074, 0.38209, 0.34458, 0.30854, 0.27425, 0.24196, 0.21186, 0.18406, 0.15866, 0.13567, 0.11507, 0.09680, 0.08076, 0.06681, 0.05480, 0.04457, 0.03593, 0.02872, 0.02275, 0.01786, 0.01390, 0.01072, 0.00820, 0.00621, 0.00466, 0.00347, 0.00256, 0.00187, 0.00135, 0.00097, 0.00069, 0.00048, 0.00034, 0.00023, 0.00016, 0.00011, 0.00007, 0.00005, 0.00003]
::Util_z_table_negative <- function(zscore){
    zscore = floor(Util_abs(zscore)*10 + 0.5);
    if(zscore < 0) return 0.99999;
    if(zscore > 40) return 0.00001;
    return Util_z_score_table[zscore];
}

//DRAW UTILS
::UTIL_DRAW_GAP <- 0.05

::COLOR_WHITE <- 1;
::COLOR_BLACK <- 2;
::COLOR_RED <- 3;
::COLOR_GREEN <- 4;
::COLOR_DARK <- 5;
::COLOR_YELLOW <- 6;
::COLOR_BLUE <- 7
::COLOR_GREEN_DARK <- 8

::Util_getRGB<-function(color){
    switch(color){
        case COLOR_RED:
        return [245, 73, 77];
        case COLOR_BLACK:
        return [0, 0, 0];
        case COLOR_WHITE:
        return [255, 255, 255];
        case COLOR_GREEN:
        return [0, 255, 0];
        case COLOR_GREEN_DARK:
        return [0, 200, 0];
        case COLOR_DARK:
        return [23, 29, 31];
        case COLOR_YELLOW:
        return [245, 245, 0];
        case COLOR_BLUE:
        return [120, 120, 200];
        default:
        return [255, 255, 255];
    }
}
::Util_get_string_from_color<-function(color){
    return "" + color[0] + " " + color[1] + " " + color[2]
}
::Util_draw_z_square<-function(pos, color, size){

    local pos1 = Vector(pos.x + size,pos.y + size,pos.z);
    local pos2 = Vector(pos.x + size,pos.y - size,pos.z);
    local pos3 = Vector(pos.x - size,pos.y - size,pos.z);
    local pos4 = Vector(pos.x - size,pos.y + size,pos.z);

    local RGB = Util_getRGB(color);

    Util_draw_square(pos1,pos2,pos3,pos4,RGB);

    pos1 = Util_vec_add_z(pos1,UTIL_DRAW_GAP);
    pos2 = Util_vec_add_z(pos2,UTIL_DRAW_GAP);
    pos3 = Util_vec_add_z(pos3,UTIL_DRAW_GAP);
    pos4 = Util_vec_add_z(pos4,UTIL_DRAW_GAP);

    Util_draw_square(pos1,pos2,pos3,pos4,RGB);

    pos1 = Util_vec_add_z(pos1,UTIL_DRAW_GAP);
    pos2 = Util_vec_add_z(pos2,UTIL_DRAW_GAP);
    pos3 = Util_vec_add_z(pos3,UTIL_DRAW_GAP);
    pos4 = Util_vec_add_z(pos4,UTIL_DRAW_GAP);

    Util_draw_square(pos1,pos2,pos3,pos4,RGB);

}
::Util_draw_square<-function(pos1,pos2,pos3,pos4,RGB){
    Util_draw_line(pos1,pos2,RGB);
    Util_draw_line(pos2,pos3,RGB);
    Util_draw_line(pos3,pos4,RGB);
    Util_draw_line(pos1,pos4,RGB);
}
::Util_draw_line<-function(pos1,pos2,RGB=[255, 255, 255]){
    local drawTime = 1/TICKRATE;
    local red = RGB[0];
    local green = RGB[1];
    local blue = RGB[2];
    DebugDrawLine(pos1, pos2, red, green, blue, true, drawTime);
}
::Util_draw_box<-function(pos1,min=Vector(-0.5,-0.5,-0.5),max=Vector(0.5,0.5,0.5), RGB=[255, 0, 0, 255], drawTime=null){
    if (!drawTime) drawTime = 1/TICKRATE
    local red = RGB[0]
    local green = RGB[1]
    local blue = RGB[2]
    local alpha = RGB[3]
    DebugDrawBox(pos1, min, max, red, green, blue, alpha, drawTime)
}
::Util_draw_box_angles<-function(pos1,min=Vector(-0.5,-0.5,-0.5),max=Vector(0.5,0.5,0.5), angles=Vector(0, 0, 0), RGB=[255, 0, 0, 255], drawTime=null){
    if (!drawTime) drawTime = 1/TICKRATE
    local red = RGB[0]
    local green = RGB[1]
    local blue = RGB[2]
    local alpha = RGB[3]
    DebugDrawBoxAngles(pos1, min, max, angles, red, green, blue, alpha, drawTime)
}
::Util_vec_to_string<-function(v){
    return "Vector("+ v.x + "," + v.y + "," + v.z + ")"
}
class TraceInfo 
{
	constructor(h,d,o,dir)
	{
		Hit = h;
		Dist = d;
        Dir = dir;
        Orig = o;
        AngDir = Util_angles_to_look(Vector(0,0,0), Dir);
	}
    Hit = null;
    Dist = null;
    Dir = null;
    Orig = null;
    AngDir = null;
}
function TraceDirSimple(orig, dir)
{
	return TraceInfo(null,null,orig,dir);
}