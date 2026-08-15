> [!CAUTION]
> # STALE BRANCH -- DO NOT USE
>
> This branch diverged in May 2026 and was never merged. **Use `main`.**
>
> Do not copy this branch to `~/.config/hypr`. It still uses the old
> `.conf` format, which Hyprland no longer reads -- Omarchy moved to Lua,
> so these files would be silently ignored and none of the settings here
> would apply.
>
> Everything unique to this branch is obsolete:
>
> | Here | Status |
> | --- | --- |
> | Lid-switch monitor disable | Omarchy handles the lid switch itself |
> | Activity (btop) on `SUPER+SHIFT+T` | Omarchy ships it on `SUPER+CTRL+T` |
> | Live-wallpaper toggle on `SUPER+CTRL+L` | Points at a script that no longer exists |
> | `repeat_delay = 600` | Superseded by 300 |
> | Dual-monitor `eDP-1 @ 3440x360` | Superseded by per-machine scaling in `monitors.lua` |
>
> Its one still-relevant idea -- the ThinkPad Typora/WhatsApp key layout
> (Typora on `SUPER+SHIFT+ALT+W`, WhatsApp on `SUPER+SHIFT+W`) -- has been
> carried into `bindings.lua` on `main`.
>
> Kept for history only.

# Hyprland

My Hyprland setup for Omarchy Linux

https://hypr.land/

Copy the contents of this repository to `~/.config/hypr`.
The following files can be ignored:

- `README.md`
- `.git`
- `.gitignore`

## Additional Installations

Install the following additional packages:

```sh
yay -S sunsetr # https://github.com/psi4j/sunsetr
```
