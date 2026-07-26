local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_wayland = false

-- General
config.font_size = 19
config.line_height = 1
config.color_scheme = "tokyonight_night"

config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
}

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

-- Key window_decoration

config.keys = {
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

return config
