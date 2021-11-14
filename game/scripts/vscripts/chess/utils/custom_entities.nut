
::new_prop_dynamic <- function () {
    
    local entity = Entities.CreateByClassname("prop_dynamic");

    local prop = {
        ref = entity,
        is_disabled = false,

        function enable() {
            is_disabled = false;
            EntFireByHandle(handle, "Enable", "", 0.0, null, null);
        }
        function disabled() {
            is_disabled = true;
            EntFireByHandle(handle, "Disable", "", 0.0, null, null);
        }
        function set_color(color) {
            EntFireByHandle(ref, "Color", utils_list_to_string(color), 0.0, null, null);
        }
        function set_model(path) {
            ref.SetModel(path);
        }
    }
}
