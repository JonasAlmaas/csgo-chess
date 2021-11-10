
::NewPropDynamic <- function () {
    local handle = Entities.CreateByClassname("prop_dynamic")

    local table = {
        handle = handle,
        is_disabled = false,

        function enable() {
            is_disabled = false;
            EntFireByHandle(handle, "Enable", "", 0.0, null, null)
        }

        function disable() {
            is_disabled = true;
            EntFireByHandle(handle, "Disable", "", 0.0, null, null)
        }

        function setColor(color_array) {
            EntFireByHandle(handle, "Color", Util_get_string_from_color(color_array), 0.0, null, null);
        }

        function setModel(path) {
            handle.SetModel(path);
        }
    }

    custom_entities.prop_dynamic.append(table)

    return table;
}
