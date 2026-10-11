-- Hardware profile for saturn: three Samsung LS24D300G panels driven by an
-- NVIDIA Quadro P1000 on nouveau.

local monitor_scale = 1

-- All three panels report the same EDID description and serial, so they can
-- only be told apart by their DisplayPort connector. Positions are in scaled
-- (logical) pixels so a later scale change does not leave pointer dead zones.
local logical_width = math.floor(1920 / monitor_scale)

for index, output in ipairs({ "DP-3", "DP-2", "DP-1" }) do
  hl.monitor({
    output = output,
    mode = "1920x1080@60",
    position = ((index - 1) * logical_width) .. "x0",
    scale = monitor_scale,
  })
end

-- The built-in panel would otherwise get the shared catch-all's automatic
-- scale, which picks 1.5 for this 14" 1080p screen and makes 100% browser zoom
-- look oversized.
hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = monitor_scale,
})

-- Avoid cursor-plane flicker on this GPU by drawing the pointer as part of the
-- compositor scene.
hl.config({
  cursor = {
    no_hardware_cursors = 1,
  },
})
