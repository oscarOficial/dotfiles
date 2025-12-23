--------------------------------------------------
-- YAZI - File Manager
--------------------------------------------------

return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>e",
      "<cmd>Yazi<cr>",
      desc = "Open Yazi",
    },
    {
      "<leader>E",
      "<cmd>Yazi cwd<cr>",
      desc = "Open Yazi in current directory",
    },
  },
  opts = function()
    local os_utils = require("utils.os")

    return {
      -- Open yazi instead of file
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
      -- Detect yazi and ya paths based on OS
      yazi_executable = os_utils.find_yazi(),
      ya_executable = os_utils.find_ya(),
      -- Disable yazi navigation keymaps to use global ones
      use_ya_for_events_reading = true,
      use_yazi_client_id_flag = true,
    }
  end,
}
