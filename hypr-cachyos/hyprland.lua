-- CachyOS Hyprland configuration.
-- Documentation: https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

-- Keep physical display layouts out of the shared config. Each known host gets
-- its own module; unknown hosts use automatic preferred modes and placement.
local hostname_file = io.open("/etc/hostname", "r")
local hostname = hostname_file and hostname_file:read("*l") or ""
if hostname_file then
  hostname_file:close()
end
hostname = hostname:match("^[^.]+") or hostname

local monitor_config = {
  example-host = "hosts.example-host",
}

if monitor_config[hostname] then
  require(monitor_config[hostname])
else
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
end

---------------------
---- APPLICATIONS ----
---------------------

-- A fresh GUI process cannot inherit an already-running XWayland backend;
-- WezTerm will therefore honor this host's native-Wayland setting every time.
local terminal = "wezterm start --always-new-process"
local browser = "chromium --new-window"
local file_manager = "dolphin"
local menu = "wofi --show drun"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  -- UWSM keeps launched applications in the graphical session's systemd
  -- scopes. The service start gives privileged apps an authentication agent.
  hl.exec_cmd("systemctl --user start hyprpolkitagent.service")
  hl.exec_cmd(
    "uwsm app -- waybar --config ~/.config/hypr/waybar/config.jsonc --style ~/.config/hypr/waybar/style.css"
  )
  hl.exec_cmd("uwsm app -- mako")
  hl.exec_cmd("uwsm app -- nm-applet --indicator")
  hl.exec_cmd("uwsm app -- swaybg -i /usr/share/wallpapers/cachyos-wallpapers/Abstract.png -m fill")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col = {
      active_border = { colors = { "rgba(7aa2f7ee)", "rgba(bb9af7ee)" }, angle = 45 },
      inactive_border = "rgba(565f89aa)",
    },
    resize_on_border = true,
    layout = "dwindle",
  },
  decoration = {
    rounding = 8,
    active_opacity = 1.0,
    inactive_opacity = 0.96,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee1a1b26,
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
    },
  },
  animations = {
    enabled = true,
  },
  dwindle = {
    preserve_split = true,
  },
  cursor = {
    -- Software cursors avoid cursor-plane glitches on NVIDIA systems.
    no_hardware_cursors = 1,
  },
  misc = {
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
  },
})

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = false,
    },
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

---------------------
---- KEYBINDINGS ----
---------------------

local main_mod = "SUPER"

-- Match Omarchy's portable desktop shortcuts while using the applications
-- installed by the CachyOS profile. Omarchy-specific menus and services are
-- intentionally not reproduced here.
hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal), { description = "Terminal" })
hl.bind(main_mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(browser), { description = "Browser" })
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(menu), { description = "Application menu" })
hl.bind(main_mod .. " + ALT + SPACE", hl.dsp.exec_cmd(menu), { description = "Application menu" })
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.exec_cmd(file_manager), { description = "File manager" })

hl.bind(main_mod .. " + W", hl.dsp.window.close(), { description = "Close window" })
hl.bind(main_mod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(main_mod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle window split" })
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind(
  main_mod .. " + F",
  hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
  { description = "Full screen" }
)
hl.bind(
  main_mod .. " + ALT + F",
  hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
  { description = "Full width" }
)
hl.bind(main_mod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock system" })
hl.bind(
  main_mod .. " + SHIFT + SPACE",
  hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"),
  { description = "Toggle top bar" }
)

-- Keep these non-conflicting CachyOS aliases for convenience.
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager), { description = "File manager" })
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(menu), { description = "Application menu" })
hl.bind(main_mod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.exit()'"), { description = "Exit Hyprland" })
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"), { description = "Screenshot" })
hl.bind(
  main_mod .. " + CTRL + Print",
  hl.dsp.exec_cmd("~/.config/hypr/scripts/capture-text"),
  { description = "Extract text from screenshot" }
)

local directions = {
  left = "l",
  right = "r",
  up = "u",
  down = "d",
}

for key, direction in pairs(directions) do
  hl.bind(
    main_mod .. " + " .. key,
    hl.dsp.focus({ direction = direction }),
    { description = "Move focus " .. key }
  )
  hl.bind(
    main_mod .. " + SHIFT + " .. key,
    hl.dsp.window.swap({ direction = direction }),
    { description = "Swap window " .. key }
  )
end

hl.bind(main_mod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(main_mod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(main_mod .. " + CTRL + TAB", hl.dsp.focus({ workspace = "previous" }), { description = "Former workspace" })

for i = 1, 10 do
  local key = i % 10
  hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------
---- WINDOW RULES ----
--------------------

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})
