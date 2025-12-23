--------------------------------------------------
-- HIGHLIGHTS - Configuración de colores personalizados
--------------------------------------------------

-- Función para aplicar highlights personalizados
local function setup_highlights()
  -- Resaltado para matches en Telescope (amarillo brillante con fondo)
  vim.api.nvim_set_hl(0, 'TelescopeMatching', {
    fg = '#000000',    -- Texto negro
    bg = '#DCA561',    -- Fondo amarillo/dorado
    bold = true,       -- Negrita
  })

  -- Resaltado alternativo más brillante (puedes probar este también)
  -- vim.api.nvim_set_hl(0, 'TelescopeMatching', {
  --   fg = '#1F1F28',  -- Texto oscuro
  --   bg = '#FFE066',  -- Amarillo más brillante
  --   bold = true,
  -- })

  -- Resaltado para el item seleccionado en Telescope
  vim.api.nvim_set_hl(0, 'TelescopeSelection', {
    bg = '#2A2A37',
    fg = '#DCD7BA',
    bold = true,
  })

  -- Resaltado para números de línea en resultados
  vim.api.nvim_set_hl(0, 'TelescopeResultsLineNr', {
    fg = '#7E9CD8',  -- Azul suave
  })

  -- Resaltado para la ruta del archivo
  vim.api.nvim_set_hl(0, 'TelescopeResultsIdentifier', {
    fg = '#7AA89F',  -- Verde agua
  })

  -- RESALTADO EN EL PREVIEW
  -- Telescope usa highlight groups estándar de Vim en el preview

  -- Resaltado de búsqueda normal (usado en preview)
  vim.api.nvim_set_hl(0, 'Search', {
    fg = '#000000',
    bg = '#DCA561',
    bold = true,
  })

  -- Resaltado de búsqueda incremental (usado durante búsqueda activa)
  vim.api.nvim_set_hl(0, 'IncSearch', {
    fg = '#000000',
    bg = '#FFE066',  -- Amarillo más brillante para distinguir
    bold = true,
  })

  -- Resaltado de sustitución (usado en :s/)
  vim.api.nvim_set_hl(0, 'Substitute', {
    fg = '#000000',
    bg = '#E82424',  -- Rojo para distinguir de búsqueda
    bold = true,
  })
end

-- Aplicar highlights al inicio
setup_highlights()

-- Re-aplicar highlights cuando cambie el colorscheme
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = setup_highlights,
  desc = 'Re-aplicar highlights personalizados después de cambiar colorscheme',
})

return {
  setup = setup_highlights
}
