-- Hardware profile for saturn: three Samsung LS24D300G panels driven by an
-- NVIDIA Quadro P1000 on nouveau.

local monitor_scale = 1.25

-- All three panels report the same EDID description and serial, so they can
-- only be told apart by their DisplayPort connector. Positions are in scaled
-- (logical) pixels: hardcoding the native 1920 offset leaves dead zones
-- between the screens that the pointer cannot cross.
local logical_width = math.floor(1920 / monitor_scale)

for index, output in ipairs({ "DP-3", "DP-2", "DP-1" }) do
  hl.monitor({
    output = output,
    mode = "1920x1080@60",
    position = ((index - 1) * logical_width) .. "x0",
    scale = monitor_scale,
  })
end

-- Avoid cursor-plane flicker on this GPU by drawing the pointer as part of the
-- compositor scene.
hl.config({
  cursor = {
    no_hardware_cursors = 1,
  },
})
