--------------------------------------------------
-- INC-RENAME
-- Rename incremental con preview en tiempo real
--------------------------------------------------

return {
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  config = function()
    require("inc_rename").setup({
      input_buffer_type = "dressing",  -- usa dressing.nvim si está instalado
      post_hook = nil,
    })
  end,
}
