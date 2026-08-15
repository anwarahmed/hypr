-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- CHANGED from Omarchy defaults (stock values kept in the trailing comments).
--
-- GDK_SCALE 2 (stock) doubles the size of GTK apps, which is right for a HiDPI
-- panel but far too large here. Setting it to 1 lets GTK apps scale with the
-- monitor scale below instead of on top of it.
--
-- scale "auto" (stock) picks an integer scale, which rounds this display up to
-- 2x and makes everything oversized. 1.25 is the fractional scale that actually
-- suits eDP-1, so it is pinned explicitly.
local omarchy_gdk_scale = 1 -- 2
local omarchy_monitor_scale = 1.25 -- "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- An empty output means "every monitor", so this applies to whatever is
-- connected. Add a specific hl.monitor() below to override a named display.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
