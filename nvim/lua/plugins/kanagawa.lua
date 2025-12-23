--------------------------------------------------
-- KANAGAWA - Colorscheme
--------------------------------------------------

return {
  "rebelot/kanagawa.nvim",
  lazy = false,    -- Cargar inmediatamente al inicio
  priority = 1000, -- Asegurar que se carga antes que otros plugins
  config = function()
    require('kanagawa').setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none"
            }
          }
        }
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Resaltado mejorado para Telescope
          TelescopeMatching = { fg = "#000000", bg = "#DCA561", bold = true }, -- Amarillo/dorado con texto negro
          TelescopeSelection = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

          -- Resaltado de búsqueda (usado en preview de Telescope y búsquedas normales)
          Search = { fg = "#000000", bg = "#DCA561", bold = true },
          IncSearch = { fg = "#000000", bg = "#FFE066", bold = true },
          Substitute = { fg = "#000000", bg = "#E82424", bold = true },
        }
      end,
    })

    vim.cmd("colorscheme kanagawa")
  end,
}
