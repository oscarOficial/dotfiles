--------------------------------------------------
-- CONFIGURACIÓN ESPECÍFICA PARA ARCHIVOS JSON
--------------------------------------------------

-- Asegurar que se use el filetype correcto
vim.bo.filetype = 'json'

-- Configuración de indentación para JSON
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

-- Habilitar folding basado en sintaxis
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldenable = true
vim.wo.foldlevel = 99  -- Todos los folds abiertos por defecto

-- Ocultar comillas en campos JSON para mejor legibilidad (opcional)
vim.opt_local.conceallevel = 0

-- Formateo automático al guardar (opcional, descomenta si lo necesitas)
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   buffer = 0,
--   callback = function()
--     vim.lsp.buf.format({ async = false })
--   end,
-- })
