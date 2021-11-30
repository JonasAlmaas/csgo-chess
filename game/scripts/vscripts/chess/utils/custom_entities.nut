
::new_prop_dynamic <- function () {

    foreach (prop in custom_entities.prop_dynamic) {
        if (prop.is_disabled) {
            prop.reset();
            return prop;
        }
    }

    local prop = {
        ref = Entities.CreateByClassname("prop_dynamic"),
        is_disabled = false,

        function reset() {
            enable();
            set_scale(1);
            set_color([255,255,255]);
        }
        function enable() {
            is_disabled = false;
            show();
        }
        function disable() {
            is_disabled = true;
            hide();
        }
        function teleport(pos=null, ang=null) {
            if (pos) { ref.SetOrigin(pos); }
            if (ang) { ref.SetAngles(ang.x, ang.y, ang.z); }
        }

        function show() { EntFireByHandle(ref, "Enable", "", 0.0, null, null); }
        function hide() { EntFireByHandle(ref, "Disable", "", 0.0, null, null); }
        
        function enable_shadows() { ref.__KeyValueFromInt("disableshadowdepth", 0); }
        function disable_shadows() { ref.__KeyValueFromInt("disableshadowdepth", 1); }

        function set_color(color) { EntFireByHandle(ref, "Color", convertion.list_to_string(color), 0.0, null, null); }
        function set_model(path) { ref.SetModel(path); }
        function set_scale(scale) { ref.__KeyValueFromFloat("modelscale", scale); }
    }

    custom_entities.prop_dynamic.append(prop);

    return prop;
}

::new_prop_dynamic_glow <- function () {

    foreach (prop in custom_entities.prop_dynamic_glow) {
        if (prop.is_disabled) {
            prop.reset();
            return prop;
        }
    }

    local prop = {
        ref = Entities.CreateByClassname("prop_dynamic_glow"),
        is_disabled = false,

        function reset() {
            enable();
            set_scale(1);
            set_color([255,255,255]);
            set_glow_color([255,255,255]);
        }
        function enable() {
            is_disabled = false;
            enable_glow();
            show();
        }
        function disable() {
            is_disabled = true;
            disable_glow();
            hide();
        }

        function teleport(pos=null, ang=null) {
            if (pos) { ref.SetOrigin(pos); }
            if (ang) { ref.SetAngles(ang.x, ang.y, ang.z); }
        }

        function show() { EntFireByHandle(ref, "Enable", "", 0.0, null, null); }
        function hide() { EntFireByHandle(ref, "Disable", "", 0.0, null, null); }

        function enable_shadows() { ref.__KeyValueFromInt("disableshadowdepth", 0); }
        function disable_shadows() { ref.__KeyValueFromInt("disableshadowdepth", 1); }
        function enable_glow() { EntFireByHandle(ref, "SetGlowEnabled", "", 0.0, null, null); }
        function disable_glow() { EntFireByHandle(ref, "SetGlowDisabled", "", 0.0, null, null); }

        function set_color(color) { EntFireByHandle(ref, "Color", convertion.list_to_string(color), 0.0, null, null); }
        function set_glow_color(color) { EntFireByHandle(ref, "SetGlowColor", convertion.list_to_string(color), 0.0, null, null); }
        function set_glow_distance(distance) { ref.__KeyValueFromInt("glowdist", distance); }
        function set_model(path) { ref.SetModel(path); }
        function set_scale(scale) { ref.__KeyValueFromFloat("modelscale", scale); }
    }

    prop.enable_glow();
    
    // prop.ref.__KeyValueFromInt("glowstyle", 2);

    custom_entities.prop_dynamic_glow.append(prop);

    return prop;
}
