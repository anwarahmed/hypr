-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- MIGRATED FROM bindings.conf ------------------------------------------------
--
-- The old bindings.conf had 22 app bindings that were an unmodified copy of
-- Omarchy's own stock list. They are now Omarchy defaults with identical keys
-- and identical resulting commands, so they are NOT repeated here -- keeping
-- them would only freeze them against future Omarchy improvements.
-- Dropped as redundant:
--
--   SUPER+RETURN Terminal              SUPER+SHIFT+A ChatGPT
--   SUPER+SHIFT+RETURN Browser         SUPER+SHIFT+ALT+A Grok
--   SUPER+SHIFT+F File manager         SUPER+SHIFT+C Calendar
--   SUPER+ALT+SHIFT+F File mgr (cwd)   SUPER+SHIFT+E Email
--   SUPER+SHIFT+B Browser              SUPER+SHIFT+Y YouTube
--   SUPER+SHIFT+ALT+B Browser private  SUPER+SHIFT+CTRL+G Google Messages
--   SUPER+SHIFT+M Music                SUPER+SHIFT+P Google Photos
--   SUPER+SHIFT+ALT+M Music TUI        SUPER+SHIFT+X X
--   SUPER+SHIFT+N Editor               SUPER+SHIFT+ALT+X X Post
--   SUPER+SHIFT+D Docker               SUPER+SHIFT+SLASH Passwords
--   SUPER+SHIFT+G Signal               SUPER+SHIFT+O Obsidian
--
-- What remains below is the genuinely personal configuration -- everything
-- that lived in the old file's "##### CUSTOM BINDINGS #####" section.

-- APPS -----------------------------------------------------------------------
-- These three were the "Replaced bindings" group: stock lines the old config
-- commented out and re-added in a modified form. All three are pinned here.
--
-- Note that Omarchy's versions of these live behind
-- o.preinstalled_bindings_enabled(), so they would also disappear entirely if
-- the preinstalled apps were ever removed. Pinning them keeps them working.

-- Tmux. Omarchy's SUPER+ALT+RETURN runs `tmux attach || tmux new -s Work`,
-- which creates a session NAMED "Work". This uses an unnamed default session
-- instead, as the old config did.
hl.unbind("SUPER + ALT + RETURN")
o.bind("SUPER + ALT + RETURN", "Tmux", [[omarchy-launch-terminal bash -c "tmux attach || tmux new"]])

-- Typora. Omarchy binds SUPER+SHIFT+W to Omawrite (its own writing app), so
-- that has to be unbound first. Drop these two lines to get Omawrite back.
hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "Typora", { launch = "typora --enable-wayland-ime" })

-- WhatsApp. This currently resolves to exactly the same command as Omarchy's
-- default, so it is pinned only to keep the "Replaced bindings" set intact and
-- independent of the preinstalled-bindings flag above.
hl.unbind("SUPER + SHIFT + ALT + G")
o.bind("SUPER + SHIFT + ALT + G", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })

-- WINDOW MANAGEMENT ----------------------------------------------------------

-- Close window on SUPER+Q instead of Omarchy's SUPER+W.
-- SUPER+W is freed entirely -- nothing is bound to it after this.
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- Workspace switching moves to CTRL+LEFT/RIGHT (unbound in stock Omarchy),
-- which frees up SUPER+TAB for window cycling below.
o.bind("CTRL + RIGHT", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("CTRL + LEFT", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

-- SUPER+TAB cycles windows rather than workspaces.
-- Stock Omarchy: SUPER+TAB = next workspace, SUPER+SHIFT+TAB = previous.
-- Two bindings share each key on purpose -- Hyprland runs both, so the window
-- is raised as well as focused. This mirrors how Omarchy wires its own
-- ALT+TAB, which is then repurposed for groups below.
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
o.bind("SUPER + TAB", "Cycle to next window", hl.dsp.window.cycle_next())
o.bind("SUPER + SHIFT + TAB", "Cycle to prev window", hl.dsp.window.cycle_next({ next = false }))
o.bind("SUPER + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
o.bind("SUPER + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())

-- ALT+TAB navigates within a window group instead of cycling all windows
-- (that job now belongs to SUPER+TAB above).
-- Stock Omarchy: ALT+TAB = cycle windows; groups live on SUPER+ALT+TAB, which
-- is left alone and still works.
hl.unbind("ALT + TAB")
hl.unbind("ALT + SHIFT + TAB")
o.bind("ALT + TAB", "Next window in group", hl.dsp.group.next())
o.bind("ALT + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())

-- REFERENCE EXAMPLES ---------------------------------------------------------

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
