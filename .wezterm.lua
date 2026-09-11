local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Native Wayland keeps text sharp on this host's 4K displays at fractional
-- scale (XWayland renders at 1x and gets upscaled, which shows up as visible
-- pixelation). The matching hostname lives in the ignored .env, not here, so
-- other hosts retain their existing backend choice.
local function local_env_value(key)
	local env_file = io.open(wezterm.home_dir .. "/.dotfiles/.env", "r")
	if not env_file then
		return ""
	end
	local value = ""
	for line in env_file:lines() do
		local candidate = line:match("^" .. key .. "=(.*)$")
		if candidate then
			value = candidate:gsub('^"(.*)"$', "%1")
			break
		end
	end
	env_file:close()
	return value
end

local is_local_workstation = wezterm.hostname() == local_env_value("CACHYOS_HARDWARE_HOSTNAME")

config.enable_wayland = is_local_workstation

-- General
-- config.font = wezterm.font_with_fallback({
-- "JetBrainsMono Nerd Font Mono",
-- "JetBrainsMonoNL Nerd Font Propo",
-- "Cascadia Mono",
-- })
-- ~19.25% smaller than the 19pt default (15% then another 5%), only on
-- this workstation (eris).
config.font_size = is_local_workstation and 15.34 or 19
config.line_height = 1
config.color_scheme = "tokyonight_night"

config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
}

config.window_decorations = "RESIZE"
-- config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

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

-- Herdr enables terminal mouse reporting for its UI, which normally sends
-- middle-clicks to Herdr instead of using WezTerm's primary-selection paste.
-- Override only that button while mouse reporting is active; Herdr still
-- receives left/right clicks, drags, and wheel events.
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Middle" } },
		mods = "NONE",
		mouse_reporting = true,
		action = wezterm.action.PasteFrom("PrimarySelection"),
	},
	{
		event = { Drag = { streak = 1, button = "Middle" } },
		mods = "NONE",
		mouse_reporting = true,
		action = wezterm.action.Nop,
	},
	{
		event = { Up = { streak = 1, button = "Middle" } },
		mods = "NONE",
		mouse_reporting = true,
		action = wezterm.action.Nop,
	},
}

return config
