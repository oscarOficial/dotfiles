--------------------------------------------------
-- INIT.LUA - Configuración principal de Neovim
--------------------------------------------------

-- Establecer leader key ANTES de cargar lazy.nvim
vim.g.mapleader = ' '
vim.g.maplocalleader = " "

-- Habilitar el loader para mejor rendimiento
vim.loader.enable()

--------------------------------------------------
-- 1. Cargar opciones básicas
--------------------------------------------------
require("config.options")

--------------------------------------------------
-- 1.5. Cargar detección de tipos de archivo
--------------------------------------------------
require("config.filetypes")

--------------------------------------------------
-- 2. Cargar keymaps generales
--------------------------------------------------
require("config.keymaps")

--------------------------------------------------
-- 2.5. Cargar configuración de highlights
--------------------------------------------------
require("config.highlights")
require("config.telescope-highlight-fix").setup()

--------------------------------------------------
-- 3. Configurar e instalar plugins con lazy.nvim
-- Los plugins se cargan automáticamente desde lua/plugins/
--------------------------------------------------
require("config.lazy")

--------------------------------------------------
-- 4. El colorscheme se aplica automáticamente
--    desde lua/plugins/kanagawa.lua
--------------------------------------------------
