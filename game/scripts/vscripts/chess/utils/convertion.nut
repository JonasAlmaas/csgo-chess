
::convertion <- {
    function list_to_string(list) {
        local str = "";
        foreach (index, element in list) {
            str += element;
            if (index != list.len()-1) { str += " "; }
        }
        return str;
    }
    function vec_to_string(v){
        return "Vector("+ v.x + ", " + v.y + ", " + v.z + ")";
    }
}
