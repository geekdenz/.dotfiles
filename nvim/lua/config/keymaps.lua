-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

vim.keymap.set("n", "s-tab", ":N<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "tab", ":n<CR>", { desc = "Next Tab" })

vim.keymap.set("n", "<leader>az", function()
  require("avante.api")
end, { desc = "Avante Zen Mode" })

-- lua/config/keymaps.lua
vim.keymap.set({ "n", "v" }, "<S-F6>", function()
  vim.lsp.buf.rename()
end, { desc = "Rename Symbol" })

-- Keep Space Space free to match IdeaVim and avoid accidental file finding.
pcall(vim.keymap.del, "n", "<leader><space>")
pcall(vim.keymap.del, "i", "<leader><space>")
pcall(vim.keymap.del, "v", "<leader><space>")

-- Save / quit aliases from ideavimrc.
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save All Files" })
map("n", ",s", "<cmd>w<cr>", { desc = "Save File" })
map("n", ",S", "<cmd>w<cr>", { desc = "Save File" })
map("i", ",s", "<esc><cmd>w<cr>", { desc = "Save File" })
map("i", ",S", "<esc><cmd>w<cr>", { desc = "Save File" })
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit All Without Saving" })
map("n", ",quit", "<cmd>q<cr>", { desc = "Quit" })

-- File / find aliases. LazyVim keeps <leader>ff, <leader>fF, <leader>fr,
-- <leader>,, <leader>fb, <leader>/, <leader>sg, and <leader>sG by default.
map("n", "<leader>sa", function()
  Snacks.picker.commands()
end, { desc = "Actions" })
map("n", ",f", "/", { desc = "Search" })

-- Buffer / tab aliases from ideavimrc.
map("n", ",bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", ",bp", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
map("n", "<leader>ba", function()
  Snacks.bufdelete.all({ force = true })
end, { desc = "Delete All Buffers" })
map("n", ",bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", ",bdd", function()
  Snacks.bufdelete({ force = true })
end, { desc = "Delete Buffer Without Saving" })
map("n", ",bda", function()
  Snacks.bufdelete.all({ force = true })
end, { desc = "Delete All Buffers" })
map("n", "<C-w>t", "<cmd>tabnew<cr>", { desc = "New Tab" })

-- Window / insert-mode helpers.
map("i", "<C-l>", " => ", { desc = "Insert Arrow" })

-- LSP aliases from ideavimrc.
map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
map("n", "gh", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>r", vim.lsp.buf.code_action, { desc = "Refactor" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Run/debug aliases that mirror the IdeaVim names when the optional plugins exist.
map("n", "<leader>rr", function()
  local ok, neotest = pcall(require, "neotest")
  if ok then
    neotest.run.run()
  else
    vim.cmd("make")
  end
end, { desc = "Run" })
map("n", "<leader>rd", function()
  local ok, dap = pcall(require, "dap")
  if ok then
    dap.continue()
  else
    vim.notify("nvim-dap is not available", vim.log.levels.WARN)
  end
end, { desc = "Debug" })
map("n", "<leader>rs", function()
  local ok, neotest = pcall(require, "neotest")
  if ok then
    neotest.run.stop()
    return
  end

  local dap
  ok, dap = pcall(require, "dap")
  if ok then
    dap.terminate()
  else
    vim.notify("No test or debug runner is available", vim.log.levels.WARN)
  end
end, { desc = "Stop" })

-- Selection / config aliases.
map("n", "<leader>A", "ggVG", { desc = "Select All" })
map("n", ",a", "ggVG", { desc = "Select All" })
map("n", "<leader>vi", function()
  vim.cmd.edit(vim.fn.fnameescape(vim.fn.stdpath("config") .. "/init.lua"))
end, { desc = "Edit Neovim Config" })
map("n", "<leader>vR", "<cmd>source $MYVIMRC<cr>", { desc = "Reload Neovim Config" })
map("n", ",vim", function()
  vim.cmd.edit(vim.fn.fnameescape(vim.fn.stdpath("config") .. "/init.lua"))
end, { desc = "Edit Neovim Config" })
map("n", ",rel", "<cmd>source $MYVIMRC<cr>", { desc = "Reload Neovim Config" })

-- Custom helpers from ideavimrc.
map("n", "<F4>", "<cmd>!ctags<cr><cmd>set tags=tags<cr>", { desc = "Generate Tags" })
map("i", ",e", "<esc>/[]})\"']<cr><esc><cmd>nohlsearch<cr>a", { desc = "Jump After Closing Character" })
map("n", ",e", "/[]})\"']<cr><esc><cmd>nohlsearch<cr>a", { desc = "Jump After Closing Character" })
map(
  "v",
  ",h",
  [[:s/\:\([a-zA-Z_]\+\)\s\+=>/\=printf("%s:", submatch(1))/g<cr><esc><cmd>let @/ = ""<cr>]],
  { desc = "Convert Ruby Hash Syntax" }
)
map("n", ",ac", "<cmd>split app/controllers/application_controller.rb<cr>", { desc = "Open Application Controller" })
map("n", ",p", '<cmd>set paste<cr>o<esc>"*]p<cmd>set nopaste<cr>', { desc = "Paste From System Clipboard" })
map("n", ",rr", "<esc><cmd>wq<cr>", { desc = "Save and Quit" })
