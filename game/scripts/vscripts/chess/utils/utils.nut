
::utils <- {
    function remove_decals() {
        console.run("r_cleardecals");
    }
    function list_merge(l1, l2) {
        foreach (element in l2) {
            l1.append(element);
        }
        return l1;
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
    function get_entity_from_name(name) {
        local target = null;
        target = Entities.FindByName(target, name);
        return target;
    }
}
