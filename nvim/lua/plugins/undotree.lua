return {
  "jiaoshijie/undotree",
  opts = {
    -- your options
  },
  keys = { -- load the plugin only when using it's keybinding:
    { "<leader>su", "<cmd>lua require('undotree').toggle()<cr>" },
  },
}
