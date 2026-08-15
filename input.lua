-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- ACTIVE OVERRIDES -----------------------------------------------------------
-- Migrated from the old input.conf.
--
-- Only settings that actually DIFFER from Omarchy's defaults are set here, so
-- package updates can keep improving everything else. These input.conf values
-- were dropped because they already match the Omarchy default exactly:
--
--   kb_layout = us          -- default derives "us" from XKBLAYOUT in
--                              /etc/vconsole.conf
--   repeat_rate = 40        -- same as default
--   numlock_by_default      -- default is already true
--   touchpad scroll_factor  -- default is already 0.4
--   the two scroll_touchpad windowrules for terminals -- now Omarchy defaults
--
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    -- CHANGED: "compose:caps,shift:both_capslock_cancel" (default) ->
    -- "compose:ralt". Puts the Compose key on Right Alt instead of Caps Lock.
    --
    -- NOTE: this replaces the whole option string, so Omarchy's
    -- shift:both_capslock_cancel (both Shift keys together cancel Caps Lock)
    -- is intentionally given up. To keep it as well, use:
    --   kb_options = "compose:ralt,shift:both_capslock_cancel"
    kb_options = "compose:ralt",

    -- CHANGED: 250 (default) -> 300. Slightly longer hold before a held key
    -- starts repeating. This is the value from PRs #35 and #37.
    repeat_delay = 300,

    -- CHANGED: unset (default, i.e. false) -> true. Natural (inverted)
    -- scrolling for mice. The touchpad has its own setting below.
    natural_scroll = true,

    touchpad = {
      -- CHANGED: false (default) -> true. Natural (inverted) touchpad
      -- scrolling, matching the mouse setting above.
      natural_scroll = true,
    },
  },

  gestures = {
    -- CHANGED: 300 (default) -> 100. Distance in px a swipe must travel to
    -- complete a workspace change; lower means a shorter flick switches
    -- workspaces.
    workspace_swipe_distance = 100,
  },
})

-- ADDED (not an Omarchy default): four-finger horizontal swipe changes
-- workspaces. Omarchy ships no gesture bindings at all, and its scaffolding
-- suggests three fingers -- this uses four, as in the old input.conf.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- REFERENCE EXAMPLES ---------------------------------------------------------
-- Everything below is commented-out Omarchy scaffolding, kept for reference.

-- Keyboard layout and options.
-- hl.config({
--   input = {
--     -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
--     kb_layout = "us,dk,eu",
--     kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",
--
--     -- Use a specific keyboard variant if needed (e.g. intl for international keyboards).
--     kb_variant = "intl",
--
--     -- Increase sensitivity for mouse/trackpad (default: 0).
--     sensitivity = 0.35,
--
--     -- Turn off mouse acceleration (default: adaptive).
--     accel_profile = "flat",
--
--     touchpad = {
--       -- Use two-finger clicks for right-click instead of lower-right corner.
--       clickfinger_behavior = true,
--
--       -- Control the speed of your scrolling.
--       scroll_factor = 0.4,
--
--       -- Enable the touchpad while typing.
--       disable_while_typing = false,
--
--       -- Left-click-and-drag with three fingers.
--       drag_3fg = 1,
--     },
--   },
-- })

-- App-specific touchpad scroll speeds (both are Omarchy defaults already).
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
