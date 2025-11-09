-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Helper: modify the number under the cursor by a factor
local function modify_number(factor)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- Find the number under or near cursor
  local s, e, num_str = line:find("[-]?%d+%.?%d*", col + 1)
  if not s then
    s, e, num_str = line:find("[-]?%d+%.?%d*")
  end
  if not s then
    print("No number under cursor")
    return
  end

  local num = tonumber(num_str)
  if not num then
    print("Invalid number")
    return
  end

  local new_num = num * factor
  local new_line = line:sub(1, s - 1) .. tostring(new_num) .. line:sub(e + 1)
  vim.api.nvim_set_current_line(new_line)
end

--- -- Halve
--- vim.keymap.set("n", "<leader>hh", function()
---   modify_number(0.5)
--- end, { desc = "Halve number under cursor" })
---
--- -- Double
--- vim.keymap.set("n", "<leader>hd", function()
---   modify_number(2)
--- end, { desc = "Double number under cursor" })

-- Multiply by a typed number after <leader>h
-- vim.keymap.set("n", "<leader>h", function()
--   local num = vim.fn.getcharstr() -- waits for a single key
--   local factor = tonumber(num)
--   if factor then
--     modify_number(factor)
--   else
--     print("Press <leader>hh to halve or <leader>hd to double.")
--   end
-- end, { desc = "Multiply number under cursor by typed number" })

local function setup_number_keymaps()
  vim.keymap.set("n", "<leader>hh", function()
    modify_number(0.5)
  end, { desc = "Halve number" })
  vim.keymap.set("n", "<leader>hd", function()
    modify_number(2)
  end, { desc = "Double number" })
  vim.keymap.set("n", "<leader>h", function()
    local num = vim.fn.getcharstr()
    local factor = tonumber(num)
    if factor then
      modify_number(factor)
    else
      print("Press <leader>hh to halve or <leader>hd to double.")
    end
  end, { desc = "Multiply number" })
end

-- return {
--   {
--     "LazyVim/LazyVim",
--     config = function(_, opts)
--       setup_number_keymaps()
--       return opts
--     end,
--   },
-- }
-- return {
--   "mycustom",
--
-- }
