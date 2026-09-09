-- Load the hardware profile for the machine this config is running on.
--
-- Display layouts, GPU workarounds and anything else tied to physical
-- hardware belong in hosts/<hostname>.lua rather than in the shared files, so
-- that applying these dotfiles on one machine can never overwrite another
-- machine's setup. Profiles are resolved under the live Hyprland config
-- directory, which lets each distro tree keep its own hosts/ directory while
-- sharing this loader.
--
-- A machine without a profile keeps whatever the shared config sets up, which
-- for monitors means Hyprland's automatic placement.
--
-- Set HYPR_HOST to load a profile under a different name than /etc/hostname.

local function config_home()
  local xdg = os.getenv("XDG_CONFIG_HOME")
  if xdg and xdg ~= "" then
    return xdg
  end

  return (os.getenv("HOME") or "") .. "/.config"
end

local function short_hostname()
  local name = os.getenv("HYPR_HOST")

  if not name or name == "" then
    local hostname_file = io.open("/etc/hostname", "r")
    if hostname_file then
      name = hostname_file:read("*l")
      hostname_file:close()
    end
  end

  -- Drop any domain suffix so "saturn.local" still matches "saturn".
  return (name or ""):match("^[%w_-]+") or ""
end

local host = short_hostname()
if host == "" then
  return
end

local profile = config_home() .. "/hypr/hosts/" .. host .. ".lua"

local profile_file = io.open(profile, "r")
if not profile_file then
  return
end
profile_file:close()

dofile(profile)
