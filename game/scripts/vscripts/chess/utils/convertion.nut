
::utils_list_to_string <- function (list) {
    local str = "";
    foreach (element in list) { str += element; }
    return str;
}
::util_vec_to_string <- function(v){
    return "Vector("+ v.x + ", " + v.y + ", " + v.z + ")"
}