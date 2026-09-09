-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Physical display layouts are per-machine and live in
-- hypr/hosts/<hostname>.lua, loaded from hyprland.lua. Keep this file for
-- settings that suit every machine, so installing these dotfiles on one host
-- never rewrites another host's layout.

local omarchy_gdk_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Anything not claimed by a host profile still comes up usable.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
