# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Anwar's personal Hyprland configuration for [Omarchy](https://omarchy.org/) Linux, shared across several machines.

**This repo is checked out directly at `~/.config/hypr`.** There is no build and no deploy step — editing a file here changes the live desktop, and Hyprland auto-reloads on save. Treat every edit as immediately live.

The `omarchy` skill is required reading for changes here; it covers the wider system (bar, themes, hooks, terminals) beyond Hyprland itself.

## Validate every change

Hyprland Lua errors do not always surface visibly, so never finish a change without this loop:

```sh
luac -p *.lua                 # syntax only, catches nothing semantic
hyprctl reload
hyprctl configerrors          # MUST be empty
```

`hyprctl reload` returning `ok` is not sufficient — a config that loads can still have silently applied nothing. Confirm the actual effect:

```sh
hyprctl getoption decoration:rounding        # check one setting
hyprctl getoption input:kb_options
hyprctl monitors                             # scale, mode, position
omarchy menu keybindings --print             # readable key -> description list
hyprctl binds -j                             # full detail; dispatcher shows as __lua
```

`hyprctl binds` reports Lua dispatchers opaquely as `__lua` with an arg index, so it proves *which key is bound to what description*, not the command behind it. Use it to detect duplicate or missing binds; read the source for the command.

The four remaining `.conf` files are **not** read by Hyprland and `hyprctl` neither applies nor validates them:

| File | Read by | Apply with |
|---|---|---|
| `hyprsunset.conf` | hyprsunset | `omarchy restart hyprsunset` |
| `xdph.conf` | xdg-desktop-portal-hyprland | next login |
| `hypridle.conf`, `hyprlock.conf` | hypridle / hyprlock | their own processes |

## Architecture

Omarchy migrated Hyprland config from `.conf` to Lua. **Hyprland loads `hyprland.lua`; a `hyprland.conf` sitting next to it is dead weight and will be silently ignored.** This repo completed that migration — do not reintroduce `.conf` files for Hyprland settings.

`hyprland.lua` is the entry point and sets the load order:

1. `dofile(.../default/hypr/bootstrap.lua)` — sets `package.path` to search `~/.local/state`, then `~/.config`, then `$OMARCHY_PATH` (default `/usr/share/omarchy`), and clears cached modules so reloads pick up edits.
2. `require("default.hypr.omarchy")` — all Omarchy defaults.
3. `require("hypr.monitors" | "hypr.input" | "hypr.bindings" | "hypr.looknfeel" | "hypr.autostart")` — the user files in this repo, loaded **after** defaults so they override.
4. `require("default.hypr.toggles")` — runtime toggle flags.

### Reference material (read-only)

**Never edit anything under `/usr/share/omarchy/` — it is package-owned and `omarchy update` overwrites it.** Reading it is the fastest way to answer almost any question here:

| Path | What it gives you |
|---|---|
| `/usr/share/omarchy/default/hypr/*.lua` | The actual defaults being overridden. Check here before adding anything. |
| `/usr/share/omarchy/default/hypr/helpers.lua` | Definition of the whole `o.*` helper API |
| `/usr/share/omarchy/config/hypr/*.lua` | Pristine user-file templates — **diff a file here against its template to see exactly what is customized** |
| `/usr/share/hypr/stubs/hl.meta.lua` | Authoritative `hl.*` API and every valid config key. `.luarc.json` points the Lua LSP at it. |
| `/usr/bin/omarchy-launch-*` | What a binding actually runs |

### API

`hl.*` is Hyprland's own Lua API; `o.*` is Omarchy's helper layer on top.

```lua
hl.config({ input = { repeat_delay = 300, touchpad = { natural_scroll = true } } })
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.25 })
hl.env("GDK_SCALE", "1")
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.unbind("SUPER + W")

o.bind(keys, description, dispatcher, options)
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.launch_on_start("sunsetr")
```

`hl.config` sets individual keywords, so a partial table merges — setting `input.touchpad.natural_scroll` alone leaves the sibling defaults intact.

`o.bind`'s dispatcher accepts a plain string (run as a shell command), an `hl.dsp.*` dispatcher for window-manager actions (`hl.dsp.window.close()`, `hl.dsp.focus({ workspace = "e+1" })`, `hl.dsp.group.next()`), or a table shorthand: `{ launch = }` wraps in `uwsm-app`, `{ omarchy = }` calls `omarchy-launch-*`, `{ webapp = }`, `{ tui = }`, and `focus = true` switches to the launch-or-focus variant.

Window rule syntax changes often between Hyprland versions — check the wiki before writing one, and prefer `o.window()`.

## Conventions and decisions

These are deliberate. Follow them or state why not.

**Only override what actually differs from Omarchy's defaults.** Settings that merely restate a default are deleted, not kept — pinning them freezes this repo against future Omarchy improvements. When dropping something for this reason, list it in a comment so a later reader can see it was considered, not forgotten. This is why `input.lua` overrides only five values plus one gesture, and `bindings.lua` carries twelve binds — the pre-migration `bindings.conf` had 39 lines, 22 of which had become verbatim Omarchy defaults.

**Verify "same as default" against the real command, not the key.** Two bindings on the same key can still differ. Read the launcher script (`cat /usr/bin/omarchy-launch-foo`) before concluding a binding is redundant. Real example: Omarchy's Tmux binding runs `tmux attach || tmux new -s Work`, creating a session *named* `Work`; this repo deliberately uses an unnamed session, so it must stay pinned.

**Always `hl.unbind()` before rebinding a key Omarchy already uses,** and say in a comment what the key used to do so it can be restored.

**Comment every override with what changed and why,** including the stock value it replaces. Files here are read months apart; `-- CHANGED: 250 (default) -> 300` answers the question the diff cannot.

**Machine differences are resolved at load time, not by branching.** `monitors.lua` keys off `/sys/class/dmi/id/product_version` so one branch serves every machine — but it must do so within the parsing contract below. Use `product_version` (`ThinkPad L14 Gen 1`) over `product_name` (`20U2S20B00`) — readable, and matches any unit of the model.

## Gotchas

**`monitors.lua` is parsed and rewritten by shell scripts — it is not free-form Lua.** This is the single easiest way to break this repo, and it fails *silently*.

- `omarchy-hyprland-monitor-scaling` (`SUPER+SLASH`) gates on `grep -q '^local omarchy_monitor_scale = '` and then `sed -i` rewrites that line and `^local omarchy_gdk_scale = `. Both must sit at **column 0** with a lone literal.
- `omarchy-hyprland-monitor-clamshell` runs at **every startup** and on lid events. It reads the catch-all `hl.monitor` rule's `scale`, and resolves a bare identifier there by finding its `local <name> = <literal>` line. Anything it cannot evaluate — a table lookup like `machine.monitor_scale`, or even `1080 / 720` — fails validation and it falls back to scale **2**.

So keep the shipped shape: two column-0 `local` lines holding literals, and `scale = omarchy_monitor_scale` as a bare identifier. Put per-machine logic *after* those lines, reassigning the variables; the scripts only ever read the first match. The literals must be **this** machine's values, since the scripts run here.

**A config that reloads correctly can still be broken at startup.** `hyprctl reload` is pure Lua and never runs the shell scripts above, so it happily showed `scale: 1.25` while a real login produced `scale: 2` and a giant desktop. To test the startup path without logging out, run the script directly:

```sh
omarchy-hyprland-monitor-clamshell && hyprctl monitors | grep scale
```

**`o.launch_on_start` only fires at compositor startup.** It registers an `hl.on("hyprland.start", ...)` handler, so `hyprctl reload` will *not* run it. To test one in a running session, run the wrapped command directly: `uwsm-app -- sunsetr`.

**Most app bindings are gated behind `o.preinstalled_bindings_enabled()`.** It returns false once `~/.local/state/omarchy/preinstalls-removed` exists, which would remove ~20 default bindings at once. Anything that must survive that belongs pinned in `bindings.lua`.

**Check for competing service units before adding an autostart.** `sunsetr` autostarts from `autostart.lua`, and a `sunsetr.service` systemd unit also ships (disabled). Enabling both runs two instances fighting over the same gamma. Same for `hyprsunset.service`.

**Read whole files, including comments.** The pre-migration `.conf` files kept real configuration inside a `##### CUSTOM BINDINGS #####` section far below a wall of commented scaffolding, with superseded lines commented out directly above their replacements. A filtered view of a config file is not the config file.

## Git

Both `main` and `hypr-thinkpad` are protected by rulesets that block direct pushes, deletions, and non-fast-forwards. **All changes go through a PR** (0 approvals required, so they can be self-merged). Branch names in this repo are descriptive and kebab-case: `update-repeat-delay-300`, `migrate-conf-to-lua`.

**`hypr-thinkpad` is stale — never branch from it or copy from it.** It diverged in May 2026, was never merged, and still uses the dead `.conf` format. Everything unique to it is obsolete: Omarchy now handles the lid switch itself, ships Activity/btop on `SUPER+CTRL+T`, and its live-wallpaper toggle points at a script that no longer exists. Its only surviving idea, the Typora/WhatsApp key layout, already lives in `bindings.lua`.

Since the checkout *is* the live config, a merge can fail on untracked files if `.lua` files were written into `~/.config/hypr` out of band. `rm -f ~/.config/hypr/*.lua` before pulling clears it — the tracked copies are authoritative.

## Recovery

```sh
omarchy refresh hyprland                 # reset Lua config to defaults (backs up first)
omarchy refresh config hypr/input.lua    # reset one file; path is relative to ~/.config/
```

Both are destructive to local changes — confirm with the user before running either.
