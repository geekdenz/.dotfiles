-- :MarkdownPreview hands its URL to the browser and lets Chromium choose the
-- window. Chromium picks the one focused last, and a PWA window (Outlook,
-- Teams) cannot hold tabs, so the preview opens in a new window whenever one of
-- those was in front. browser-tab focuses a tabbed window first.
return {
  {
    "iamcco/markdown-preview.nvim",
    optional = true,
    init = function()
      local opener = vim.fn.expand("~/.local/bin/browser-tab")
      if vim.fn.executable(opener) == 1 then
        vim.g.mkdp_browser = opener
      end
    end,
  },
}
