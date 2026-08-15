-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- CONTRACT -- READ BEFORE RESTRUCTURING THIS FILE -----------------------------
-- Omarchy does not just execute this file, it PARSES AND REWRITES it with sed:
--
--   omarchy-hyprland-monitor-scaling   (SUPER+SLASH / SUPER+ALT+SLASH)
--     requires `^local omarchy_monitor_scale = ` and `^local omarchy_gdk_scale = `
--     at column 0, and rewrites those lines in place to change scaling.
--   omarchy-hyprland-monitor-clamshell (runs at every startup, and on lid events)
--     reads the catch-all hl.monitor rule's `scale`, and resolves a bare
--     identifier there by finding its `local <name> = <literal>` line.
--
-- So both `local` lines below must stay at column 0 with a LONE LITERAL value
-- (no expressions, no table lookups -- `machine.monitor_scale` and even
-- `1080 / 720` are explicitly unresolvable), and the hl.monitor rule must refer
-- to `omarchy_monitor_scale` by bare name.
--
-- Breaking this is silent and only shows up after a real logout: `hyprctl
-- reload` is pure Lua and looks fine, while clamshell fails to parse the scale
-- at startup and falls back to 2, making everything enormous.

-- PER-MACHINE SCALING ---------------------------------------------------------
-- The literals are THIS machine's values, because the sed-based tools above run
-- here and must read something valid. Other machines are corrected in the `if`
-- below, which those tools never see.
--
-- GDK_SCALE 2 (Omarchy stock) doubles the size of GTK apps, which suits a HiDPI
-- panel but is far too large here; 1 lets GTK scale with the monitor instead of
-- on top of it. Stock scale "auto" picks an integer scale, which rounds this
-- display up to 2x and oversizes everything, so 1.25 is pinned explicitly.
-- The @type annotations matter: the fallback below assigns Omarchy's stock
-- "auto" to the scale, and without them the Lua LSP narrows these to `number`
-- from the literals here and flags that assignment. `hl.monitor` itself accepts
-- `string|number` for scale. Annotations sit ABOVE the declarations so the
-- column-0 `local` lines stay exactly where the sed tools expect them.
---@type integer
local omarchy_gdk_scale = 1
---@type number|string
local omarchy_monitor_scale = 1.25

-- Machines that want something other than the ThinkPad values above. Add a
-- branch per machine; the key comes from:
--   cat /sys/class/dmi/id/product_version
-- Prefer product_version ("ThinkPad L14 Gen 1") over product_name
-- ("20U2S20B00") -- readable, and matches any unit of the same model.
local function product_version()
  local file = io.open("/sys/class/dmi/id/product_version", "r")
  if not file then
    return ""
  end

  local value = file:read("l") or ""
  file:close()
  return value
end

if product_version() ~= "ThinkPad L14 Gen 1" then
  -- Everything else falls back to Omarchy's stock values.
  omarchy_gdk_scale = 2
  omarchy_monitor_scale = "auto"
end

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- An empty output means "every monitor", so this applies to whatever is
-- connected. `scale` must stay a bare identifier here -- see CONTRACT above.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
