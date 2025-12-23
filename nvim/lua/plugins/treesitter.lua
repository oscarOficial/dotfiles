--------------------------------------------------
-- TREESITTER - Syntax highlighting mejorado
--------------------------------------------------

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  config = function()
    require('nvim-treesitter.configs').setup({
      -- Lenguajes a instalar automáticamente
      ensure_installed = {
        'php',
        'phpdoc',
        'html',
        'css',
        'javascript',
        'typescript',
        'vue',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'json',
        'yaml',
        'sql',
        'bash',
        'markdown',
        'markdown_inline',
        'twig', -- Support for Twig templates
      },

      -- Instalar parsers automáticamente cuando abres un archivo
      auto_install = true,

      -- Syntax highlighting
      highlight = {
        enable = true,
        -- Algunos archivos grandes pueden ser lentos con treesitter
        -- Desactiva treesitter para archivos muy grandes
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },

      -- Indentación basada en treesitter
      indent = {
        enable = true,
      },

      -- Selección incremental
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          scope_incremental = '<S-CR>',
          node_decremental = '<BS>',
        },
      },
    })

    -- Configurar parser para html.twig
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.twig = {
      filetype = "html.twig",
    }

    -- Plegado (folding) basado en treesitter
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldenable = false -- Desactivado por defecto, actívalo con 'zo'
  end,
}
