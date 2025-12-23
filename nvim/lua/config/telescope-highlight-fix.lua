--------------------------------------------------
-- TELESCOPE HIGHLIGHT FIX
-- Fuerza el resaltado de matches en el preview de grep
--------------------------------------------------

local M = {}

function M.setup()
  -- Asegurar que hlsearch esté habilitado globalmente
  vim.opt.hlsearch = true

  -- Hook para cuando se carga el preview
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopePreviewerLoaded',
    callback = function(event)
      local bufnr = event.buf

      -- Aplicar los highlight groups en el buffer del preview
      vim.api.nvim_set_hl(0, 'Search', {
        fg = '#000000',
        bg = '#DCA561',
        bold = true,
      })
    end,
  })

  -- Asegurar hlsearch antes de abrir Telescope
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopeFindPre',
    callback = function()
      vim.opt.hlsearch = true
    end,
  })
end

return M
