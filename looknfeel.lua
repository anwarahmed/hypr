-- Change the default Omarchy look'n'feel.

-- ACTIVE OVERRIDES -----------------------------------------------------------
-- None. Every setting in this file is Omarchy's default.
--
-- DROPPED: decoration { rounding = 16 }, which gave windows rounded corners.
-- It came from the old looknfeel.conf, where it was the only non-empty
-- setting, and was carried through the Lua migration unchanged. Removed in
-- favour of Omarchy's default rounding = 0, i.e. square corners -- keeping it
-- pinned would only freeze this repo against future Omarchy changes.
--
-- The conf's general{}, animations{}, layout{} and scrolling{} blocks were
-- already empty, so gaps, borders, animations and layout were never
-- overridden here either.

-- REFERENCE EXAMPLES ---------------------------------------------------------
-- Everything below is commented-out Omarchy scaffolding, kept for reference.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })
