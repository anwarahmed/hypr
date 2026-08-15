-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- ADDED (not an Omarchy default). Migrated from the old autostart.conf, which
-- had: exec-once = sunsetr
--
-- sunsetr is the blue-light filter, used here instead of Omarchy's hyprsunset.
-- o.launch_on_start wraps the command in uwsm-app and runs it from Hyprland's
-- "hyprland.start" event, so it only fires at compositor startup -- a plain
-- `hyprctl reload` will NOT launch it. To start it in an already-running
-- session, run: uwsm-app -- sunsetr
--
-- NOTE: a sunsetr.service systemd unit also ships with the package and is
-- currently disabled. Leave it disabled -- enabling it alongside this line
-- would start two instances fighting over the same gamma. The same applies to
-- hyprsunset.service.
o.launch_on_start("sunsetr")
