--------------------------------------------------
-- NEO-TREE - File explorer (DESHABILITADO - usando Yazi)
--------------------------------------------------

return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle=true<cr>", desc = "Toggle Neo-tree" },
  },
  opts = {
    window = {
      position = "right",
      mappings = {
        ["<space>"] = "none",
      },
    },
  },
}
