return {
  "yetone/avante.nvim",
  config = function(_, opts)
    require("avante").setup(opts)
    require("config.herdr_avante").setup()
  end,
  opts = {
    provider = "codex",
    mode = "agentic",

    acp_providers = {
      codex = {
        command = "codex-acp",
        args = {},

        -- Force ChatGPT/browser authentication
        auth_method = "chat-gpt",

        env = {
          NODE_NO_WARNINGS = "1",
          HOME = os.getenv("HOME"),
          PATH = os.getenv("PATH"),
        },
      },
      cursor = {
        command = vim.fn.expand("~/.local/bin/agent"),
        args = { "acp" },
        auth_method = "cursor_login",

        env = {
          HOME = os.getenv("HOME"),
          PATH = os.getenv("PATH"),
        },
      },
    },
  },
}
