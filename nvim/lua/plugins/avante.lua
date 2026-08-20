return {
  "yetone/avante.nvim",
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
    },
  },
}
