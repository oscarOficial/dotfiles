--------------------------------------------------
-- RENDER-MARKDOWN - Renderizado de markdown
--------------------------------------------------

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  keys = {
    { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Preview" },
  },
  opts = {
    preset = "glow",
    win_options = {
      conceallevel = "2",
      concealcursor = "nc",
    },
  },
}
