--------------------------------------------------
-- BREADCRUMBS.NVIM - Visual breadcrumbs bar
-- DESHABILITADO: usando lualine winbar con nvim-navic en su lugar
--------------------------------------------------

return {
  "LunarVim/breadcrumbs.nvim",
  enabled = false,
  dependencies = {
    "SmiteshP/nvim-navic",
  },
  config = function()
    require("breadcrumbs").setup()
  end,
}
