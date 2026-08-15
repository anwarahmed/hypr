# Hyprland

My Hyprland setup for Omarchy Linux

https://hypr.land/

Copy the contents of this repository to `~/.config/hypr`.
The following files can be ignored:

- `README.md`
- `.git`
- `.gitignore`

Configuration is in Lua. Hyprland loads `hyprland.lua`, which pulls in
Omarchy's defaults and then the per-area overrides in `monitors.lua`,
`input.lua`, `bindings.lua`, `looknfeel.lua` and `autostart.lua`.

`hyprsunset.conf` and `xdph.conf` stay as `.conf` -- they are read by other
processes, not by Hyprland.

## Multiple machines

`main` is shared across machines. Anything machine-specific is selected at
load time rather than branched, so there is only one branch to maintain.

Display scaling is keyed on the hardware in `monitors.lua`; machines that
aren't listed there fall back to Omarchy's stock values. To add one:

```sh
cat /sys/class/dmi/id/product_version   # the key to add to `machines`
```

## Branches

> [!WARNING]
> **`hypr-thinkpad` is stale -- do not use it.** It is kept for history only.

It diverged in May 2026 and was never merged. Everything unique to it is now
obsolete: Omarchy handles the lid switch itself, ships Activity/btop on
`SUPER+CTRL+T`, and its live-wallpaper toggle pointed at a script that no
longer exists. Its `repeat_delay = 600` predates the change to 300. Its one
still-relevant idea, the ThinkPad's Typora/WhatsApp key layout, has been
carried into `bindings.lua` on `main`.

## Additional Installations

Install the following additional packages:

```sh
yay -S sunsetr # https://github.com/psi4j/sunsetr
```
