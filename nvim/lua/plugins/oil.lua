--------------------------------------------------
-- OIL - File explorer como buffer
--------------------------------------------------

return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "<leader>O", "<cmd>Oil --float<cr>", desc = "Open parent directory" },
  },
  opts = {
    keymaps = {
      ['q'] = 'actions.close'
    },
    float = {
      max_width = 0,
      max_height = 0.4,
      border = "rounded",
    },
  },
}
