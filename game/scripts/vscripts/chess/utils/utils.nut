
::utils <- {
    function remove_decals() {
        console.run("r_cleardecals");
    }
    function list_contains(in_ref, in_list) {
        if (in_list.len() <= 0) return false;
        foreach (tempRef in in_list) {
            if (tempRef == in_ref) return true;
        }
        return false;
    }
    function list_vec_contains(in_v, in_list) {
        if (in_list.len() <= 0) return false;
        foreach (v in in_list) {
            if (math.vec_equal(v, in_v)) return true;
        }
        return false;
    }
}
