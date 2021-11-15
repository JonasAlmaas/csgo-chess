
::convertion <- {
    function list_to_string(list) {
        local str = "";
        foreach (element in list) { str += element; }
        return str;
    }
    function vec_to_string(v){
        return "Vector("+ v.x + ", " + v.y + ", " + v.z + ")";
    }
}
