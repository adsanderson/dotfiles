local gdk_scale = 1
local monitor_scale = 1.25

hl.env("GDK_SCALE", tostring(gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = monitor_scale })
