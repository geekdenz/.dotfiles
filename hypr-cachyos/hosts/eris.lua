-- Hardware profile for eris: two Samsung U28E590 4K panels.
-- Match the panels by EDID description/serial so swapping GPU ports does not
-- silently reverse their physical placement again. At 1.5x, each 3840-wide
-- panel occupies 2560 logical pixels.

hl.monitor({
  output = "desc:Samsung Electric Company U28E590 H4ZN301831",
  mode = "3840x2160@60",
  position = "0x0",
  scale = 1.5,
})

hl.monitor({
  output = "desc:Samsung Electric Company U28E590 HNMR201431",
  mode = "3840x2160@60",
  position = "2560x0",
  scale = 1.5,
})
