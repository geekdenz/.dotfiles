return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    indent = {
      enable = true,
      disable = { "c", "cpp" }, -- Disables treesitter indent for C/C++
    },
  },
}
