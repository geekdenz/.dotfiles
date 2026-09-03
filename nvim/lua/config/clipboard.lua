local M = {}

local function copy(selection)
  return function(lines)
    local cmd = { "wl-copy", "--type", "text/plain;charset=utf-8" }
    if selection == "*" then
      table.insert(cmd, "--primary")
    end
    vim.fn.system(cmd, lines)
  end
end

local function paste(selection)
  return function()
    local cmd = { "wl-paste", "--no-newline" }
    if selection == "*" then
      table.insert(cmd, "--primary")
    end

    local lines = vim.fn.systemlist(cmd)
    return vim.v.shell_error == 0 and lines or {}
  end
end

local function apply()
  -- LazyVim clears this option temporarily, then restores its saved value on
  -- VeryLazy.  Applying after that event keeps clipboard integration enabled
  -- in HerdR panes as well as ordinary local terminals.
  vim.opt.clipboard = "unnamedplus"

  -- `wl-copy` is a HerdR-aware wrapper in ~/.local/bin: in a HerdR pane it
  -- emits OSC 52 to the viewing client; elsewhere it calls the real Wayland
  -- helper.  Reads always use the current Wayland clipboard.
  vim.g.clipboard = {
    name = "Wayland with HerdR bridge",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste("+"), ["*"] = paste("*") },
    cache_enabled = 0,
  }
end

function M.setup()
  if vim.g.did_very_lazy then
    apply()
    return
  end

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("UserClipboard", { clear = true }),
    pattern = "VeryLazy",
    once = true,
    callback = apply,
  })
end

return M
