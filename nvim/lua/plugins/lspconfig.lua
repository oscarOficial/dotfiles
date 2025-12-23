--------------------------------------------------
-- LSP CONFIGURATION
-- Configuración de Language Server Protocol
--------------------------------------------------

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason-lspconfig.nvim",
    "b0o/schemastore.nvim",
    "SmiteshP/nvim-navic",
  },
  config = function()
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local navic = require('nvim-navic')

    -- Capabilities para autocompletado
    local capabilities = cmp_nvim_lsp.default_capabilities()

    --------------------------------------------------
    -- DESACTIVAR LSP NO DESEADOS EXPLÍCITAMENTE
    --------------------------------------------------
    -- Prevenir que laravel_ls se active automáticamente
    vim.lsp.config('laravel_ls', { enabled = false })

    --------------------------------------------------
    -- CONFIGURACIÓN DE INTELEPHENSE (PHP)
    -- Usando la versión de Mason que funciona mejor
    --------------------------------------------------
    vim.lsp.config('intelephense', {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/intelephense-wrapper', '--stdio' },
      filetypes = { 'php', 'blade', 'html.twig' },
      root_markers = { 'composer.json', '.git', 'artisan' },
      capabilities = capabilities,
      settings = {
        intelephense = {
          files = {
            maxSize = 5000000,
            associations = { '*.php', '*.blade.php', '*.twig' },
            exclude = {
              '**/.git/**',
              '**/node_modules/**',
              '**/vendor/**/{Tests,tests}/**',
            },
          },
          stubs = {
            'apache', 'bcmath', 'bz2', 'calendar', 'Core', 'ctype',
            'curl', 'date', 'dom', 'fileinfo', 'filter', 'gd', 'hash',
            'iconv', 'json', 'libxml', 'mbstring', 'mysqli', 'openssl',
            'pcre', 'PDO', 'pdo_mysql', 'Phar', 'readline', 'Reflection',
            'session', 'SimpleXML', 'soap', 'sockets', 'SPL', 'standard',
            'tokenizer', 'xml', 'xmlreader', 'xmlwriter', 'zip', 'zlib',
            'laravel',
          },
          environment = {
            includePaths = { 'vendor' },
          },
        },
      },
    })

    --------------------------------------------------
    -- CONFIGURACIÓN DE LUA_LS (Lua)
    --------------------------------------------------
    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.git' },
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    --------------------------------------------------
    -- CONFIGURACIÓN DE TWIGGY (Twig)
    -- La configuración principal está en .twiggy.json del proyecto
    --------------------------------------------------
    vim.lsp.config('twiggy_language_server', {
      cmd = { 'twiggy-language-server', '--stdio' },
      filetypes = { 'html.twig' },
      root_markers = { '.twiggy.json', 'composer.json', '.git' },
      capabilities = capabilities,
      settings = {
        twiggy = {
          framework = "symfony",
        },
      },
    })

    --------------------------------------------------
    -- CONFIGURACIÓN DE JSONLS (JSON)
    --------------------------------------------------
    vim.lsp.config('jsonls', {
      cmd = { 'vscode-json-language-server', '--stdio' },
      filetypes = { 'json', 'jsonc' },
      root_markers = { '.git', 'package.json' },
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    --------------------------------------------------
    -- CONFIGURACIÓN DE TS_LS (TypeScript/JavaScript)
    --------------------------------------------------
    vim.lsp.config('ts_ls', {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
      root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
      },
    })

    --------------------------------------------------
    -- ACTIVAR LOS SERVIDORES LSP
    --------------------------------------------------
    vim.lsp.enable('intelephense')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('twiggy_language_server')
    vim.lsp.enable('jsonls')
    vim.lsp.enable('ts_ls')

    --------------------------------------------------
    -- DESACTIVAR SEMANTIC TOKENS (previene errores)
    --------------------------------------------------
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })

    --------------------------------------------------
    -- KEYMAPS PARA LSP
    --------------------------------------------------
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Attach navic si el servidor lo soporta
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, ev.buf)
        end

        -- Navegación
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

        -- Documentación
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

        -- Refactoring
        vim.keymap.set('n', '<leader>rn', function()
          return ':IncRename ' .. vim.fn.expand('<cword>')
        end, { buffer = ev.buf, silent = true, expr = true })
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

        -- Formateo
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- Diagnósticos
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
      end,
    })

    --------------------------------------------------
    -- CONFIGURACIÓN DE DIAGNÓSTICOS
    --------------------------------------------------
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
      },
    })

    -- Símbolos para diagnósticos
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
}
