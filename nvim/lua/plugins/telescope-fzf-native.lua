--------------------------------------------------
-- TELESCOPE FZF NATIVE
-- Compilador nativo de FZF para mejor rendimiento
--------------------------------------------------

return {
  "nvim-telescope/telescope-fzf-native.nvim",
  build = "make",
  cond = function()
    return vim.fn.executable('make') == 1
  end,
}
