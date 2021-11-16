
::utils <- {
    function remove_decals() {
        console.run("r_cleardecals");
    }
    function list_contains(ref, list) {
        if (list.len() <= 0) return false;
        foreach (tempRef in list) {
            if (tempRef == ref) return true;
        }
        return false;
    }
}
