
::new_prop_dynamic <- function () {
    
    local entity = Entities.CreateByClassname("prop_dynamic");

    local prop = {
        ref = entity,
        is_disabled = false,

        function enable() {
            is_disabled = false;
            EntFireByHandle(ref, "Enable", "", 0.0, null, null);
        }
        function disable() {
            is_disabled = true;
            EntFireByHandle(ref, "Disable", "", 0.0, null, null);
        }
        function set_color(color) {
            EntFireByHandle(ref, "Color", convertion.list_to_string(color), 0.0, null, null);
        }
        function set_model(path) {
            ref.SetModel(path);
        }
        function set_scale(scale) {
            ref.__KeyValueFromFloat("modelscale", scale);
        }
    }

    return prop;
}
