-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- PER-MACHINE SCALING ---------------------------------------------------------
-- This repo is shared across several Omarchy machines, so scaling is chosen at
-- load time from the hardware rather than hardcoded. Anything not listed in
-- `machines` below falls back to Omarchy's stock values, so a new machine needs
-- no change here until it actually wants something different.
--
-- To find the key for a machine, run:
--   cat /sys/class/dmi/id/product_version
-- On ThinkPads that gives the friendly model name ("ThinkPad L14 Gen 1");
-- product_name would give the less readable "20U2S20B00" instead.

local function product_version()
  local file = io.open("/sys/class/dmi/id/product_version", "r")
  if not file then
    return ""
  end

  local value = file:read("l") or ""
  file:close()
  return value
end

-- Omarchy's stock defaults, used by any machine not listed below.
local defaults = { gdk_scale = 2, monitor_scale = "auto" }

local machines = {
  -- GDK_SCALE 2 doubles the size of GTK apps, which suits a HiDPI panel but is
  -- far too large on this one; 1 lets GTK scale with the monitor instead of on
  -- top of it. "auto" picks an integer scale, which rounds this display up to
  -- 2x and oversizes everything, so the fractional 1.25 is pinned explicitly.
  ["ThinkPad L14 Gen 1"] = { gdk_scale = 1, monitor_scale = 1.25 },
}

local machine = machines[product_version()] or defaults

hl.env("GDK_SCALE", tostring(machine.gdk_scale))

-- An empty output means "every monitor", so this applies to whatever is
-- connected. Add a specific hl.monitor() below to override a named display.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = machine.monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
