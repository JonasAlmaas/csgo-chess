
::new_prop_dynamic <- function () {

    foreach (prop in custom_entities.prop_dynamic) {
        if (prop.is_disabled) {
            prop.enable();
            return prop;
        }
    }

    local prop = {
        ref = Entities.CreateByClassname("prop_dynamic"),
        is_disabled = false,

        function enable() {
            is_disabled = false;
            show();
        }
        function disable() {
            is_disabled = true;
            hide();
        }
        function show() {
            EntFireByHandle(ref, "Enable", "", 0.0, null, null);
        }
        function hide() {
            EntFireByHandle(ref, "Disable", "", 0.0, null, null);
        }
        function teleport(pos=null, ang=null) {
            if (pos) { ref.SetOrigin(pos); }
            if (ang) { ref.SetAngles(ang.x, ang.y, ang.z); }
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

    custom_entities.prop_dynamic.append(prop);

    return prop;
}
