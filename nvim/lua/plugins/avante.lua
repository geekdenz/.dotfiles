return {
  "yetone/avante.nvim",
  -- LazyVim's extra runs `make`, which compiles the Rust libraries from source
  -- and outlasts lazy.nvim's 2-minute process timeout. build.sh downloads the
  -- prebuilt release instead, matching what the extra already does on Windows.
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "bash ./build.sh",
  -- Avante's command parser; LazyVim's extra does not declare it yet, and
  -- without luarocks lazy.nvim cannot pull it in from avante's rockspec.
  dependencies = {
    { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
  },
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
