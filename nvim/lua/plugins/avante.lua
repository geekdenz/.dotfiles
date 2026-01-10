return {
  "yetone/avante.nvim",
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!

  ---@type avante.Config
  opts = {
    -- this file can contain specific instructions for your project
    instructions_file = "avante.md",

    -- use Ollama as main provider
    provider = "ollama",
    providers = {
      ollama = {
        endpoint = "http://127.0.0.1:11434", -- adjust if your Ollama listens elsewhere
        model = "mistral:7b-instruct",
        timeout = 30000, -- Timeout in milliseconds
        -- options = {
        --   temperature = 0,
        --   num_ctx = 20480,
        -- },
        -- you usually don't need is_env_set any more
        -- if you *really* want it, use this form instead:
        -- is_env_set = function()
        --   return require("avante.providers.ollama").check_endpoint_alive()
        -- end,
      },
    },
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-mini/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
}
