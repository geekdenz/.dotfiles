vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator ~= "y" then
      return
    end

    require("vim.ui.clipboard.osc52").copy("+")(
      vim.v.event.regcontents,
      vim.v.event.regtype
    )
  end,
})
