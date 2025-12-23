--------------------------------------------------
-- NVIM-CMP - Autocompletado
--------------------------------------------------

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Fuentes de completion
    "hrsh7th/cmp-nvim-lsp",  -- LSP
    "hrsh7th/cmp-buffer",    -- Buffer
    "hrsh7th/cmp-path",      -- Paths
    "saadparwaiz1/cmp_luasnip", -- Snippets

    -- Motor de snippets
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets", -- Snippets predefinidos
      },
    },
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    -- Cargar snippets amigables (incluye snippets para PHP, Laravel, etc.)
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        -- Navegar por las opciones
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll en la documentación
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Completar
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),

        -- Navegar por snippets
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),

      sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- LSP (lo más importante)
        { name = 'luasnip' },  -- Snippets
        { name = 'path' },     -- Rutas de archivos
      }, {
        { name = 'buffer' },   -- Texto del buffer actual (menor prioridad)
      }),

      -- Formato de visualización
      formatting = {
        format = function(entry, vim_item)
          -- Show which source each suggestion comes from
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
      },

      -- Configuración de ventana
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })
  end,
}
