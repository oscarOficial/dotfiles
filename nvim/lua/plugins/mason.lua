--------------------------------------------------
-- MASON - Gestor de LSP servers, linters y formatters
--------------------------------------------------

return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        },
        border = "rounded",
      },
    },
  },

  -- Mason + LSPConfig integration
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "intelephense", -- PHP Language Server
        "lua_ls",       -- Lua
        "ts_ls",        -- TypeScript/JavaScript
        "jsonls",       -- JSON
      },
      automatic_installation = true,
    },
  },

  -- Instalar herramientas adicionales automáticamente
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "phpcs",        -- PHP Code Sniffer (linter)
        "php-cs-fixer", -- PHP formatter
      },
    },
  },
}
