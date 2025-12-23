--------------------------------------------------
-- VIM-SLEUTH - Detectar automáticamente indentación
--------------------------------------------------

return {
  "tpope/vim-sleuth",
  event = { "BufReadPre", "BufNewFile" },
}
