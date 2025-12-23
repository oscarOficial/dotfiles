-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.cursorcolumn = false
vim.opt.termguicolors = true
vim.opt.shiftwidth = 2  -- Amount to indent with << and >>
vim.opt.tabstop = 2     -- How many spaces are shown per Tab
vim.opt.softtabstop = 2 -- How many spaces are applied when pressing Tab

vim.opt.signcolumn = 'yes'
vim.opt.winborder = 'rounded'
vim.opt.scrolloff = 20
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.cmdheight = 0  -- Ocultar cmdline cuando no se usa

-- Case insensitive unless /C or a capital letter is on search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Search settings
vim.opt.incsearch = true    -- Incremental search
vim.opt.hlsearch = true     -- Highlight search results (necesario para Telescope preview)
vim.opt.signcolumn = 'yes'

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = '»',
    },
  },
})
