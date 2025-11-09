-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "s-tab", ":N<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "tab", ":n<CR>", { desc = "Next Tab" })

vim.keymap.set("n", "<leader>az", function()
  require("avante.api")
end, { desc = "Avante Zen Mode" })
