local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_wayland = false

-- General
-- config.font = wezterm.font_with_fallback({
-- "JetBrainsMono Nerd Font Mono",
-- "JetBrainsMonoNL Nerd Font Propo",
-- "Cascadia Mono",
-- })
config.font_size = 19
config.line_height = 1
config.color_scheme = "tokyonight_night"

config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
}

config.window_decorations = "RESIZE"
-- config.enable_tab_bar = false

-- Same default as Windows Terminal: ZSH Ubuntu
-- config.default_prog = { "wsl.exe", "-e", "zsh" }
config.default_cwd = wezterm.home_dir
config.default_domain = "local"

local vs_root = "C:\\Program Files\\Microsoft Visual Studio\\18\\Community"
local vs_dev_cmd = vs_root .. "\\Common7\\Tools\\VsDevCmd.bat"
local vs_dev_ps1 = vs_root .. "\\Common7\\Tools\\Launch-VsDevShell.ps1"
local userprofile = wezterm.home_dir
local msys_home = "C:\\msys64\\home\\" .. (os.getenv("USERNAME") or "")

-- Launch menu mirrors Windows Terminal profiles (visible ones)
-- Open with: Ctrl+Shift+L
config.launch_menu = {
	{ label = "ZSH Linux", args = { "/bin/zsh" } },
	{
		label = "ZSH Ubuntu",
		args = { "wsl.exe", "-e", "zsh" },
		cwd = userprofile,
	},
	{
		label = "Ubuntu",
		args = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" },
	},
	{
		label = "Bash Ubuntu",
		args = { "C:\\Windows\\System32\\bash.exe" },
	},
	{
		label = "Windows PowerShell",
		args = { "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" },
	},
	{
		label = "Command Prompt",
		args = { "C:\\Windows\\System32\\cmd.exe" },
	},
	{
		label = "Git Bash",
		args = { "C:\\Program Files\\Git\\bin\\bash.exe", "-i", "-l" },
		cwd = userprofile,
	},
	{
		label = "ZSH",
		args = { "C:\\msys64\\usr\\bin\\zsh.exe" },
		cwd = userprofile,
	},
	{
		label = "ZSH User",
		args = { "C:\\cygwin64\\bin\\zsh.exe" },
		cwd = userprofile,
	},
	{
		label = "MINGW64 / MSYS2",
		args = {
			"C:\\msys64\\msys2_shell.cmd",
			"-defterm",
			"-here",
			"-no-start",
			"-mingw64",
		},
		cwd = msys_home,
	},
	{
		label = "MINGW32 / MSYS2",
		args = {
			"C:\\msys64\\msys2_shell.cmd",
			"-defterm",
			"-here",
			"-no-start",
			"-mingw32",
		},
		cwd = msys_home,
	},
	{
		label = "MSYS / MSYS2",
		args = {
			"C:\\msys64\\msys2_shell.cmd",
			"-defterm",
			"-here",
			"-no-start",
			"-msys",
		},
		cwd = msys_home,
	},
	{
		label = "MinGW-Compile",
		args = {
			"C:\\msys64\\msys2_shell.cmd",
			"-defterm",
			"-here",
			"-no-start",
			"-ucrt64",
		},
		cwd = userprofile,
	},
	{
		label = "Developer Command Prompt for VS 18",
		args = {
			"C:\\Windows\\System32\\cmd.exe",
			"/k",
			vs_dev_cmd,
		},
	},
	{
		label = "Developer PowerShell for VS 18",
		args = {
			"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
			"-NoExit",
			"-File",
			vs_dev_ps1,
		},
	},
	{
		-- Opens an elevated PowerShell window (UAC). WezTerm cannot host an elevated
		-- shell in-tab without a helper like gsudo.
		label = "Windows PowerShell Admin",
		args = {
			"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
			"-Command",
			"Start-Process powershell -Verb RunAs",
		},
	},
}

-- config.enable_tab_bar = false

-- Key window_decoration

config.keys = {
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "t",
		-- Triggers via Alt + Shift + T
		mods = "ALT|SHIFT",
		-- Spawns the tab in the current working directory environment
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{ key = "l", mods = "ALT|SHIFT", action = wezterm.action.ShowLauncher },
}

return config
