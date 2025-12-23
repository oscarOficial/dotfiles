--------------------------------------------------
-- BUFFER AND MARKS NAVIGATION
-- Enhanced configuration for working with buffers and marks
--------------------------------------------------

return {
  -- Plugin to visualize and manage marks
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      -- Characters for default marks
      default_mappings = true,

      -- Which marks to show
      builtin_marks = { ".", "<", ">", "^" },

      -- Update signs when switching buffers
      cyclic = true,

      -- Force write modified buffers
      force_write_shada = false,

      -- Marks refresh
      refresh_interval = 250,

      -- Mark colors
      sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },

      -- Excluded filetypes
      excluded_filetypes = {},

      -- Custom mappings (in addition to defaults)
      mappings = {
        -- Set mark (mx, where x is the letter)
        set = "m",

        -- Delete mark on current line
        delete_line = "dm-",

        -- Delete all marks in buffer
        delete_buf = "dm<space>",

        -- Next mark
        next = "m]",

        -- Previous mark
        prev = "m[",

        -- Mark preview
        preview = "m:",

        -- Next mark of same group (a-z)
        next_bookmark = "m}",
        prev_bookmark = "m{",

        -- List all marks
        -- annotate = "m<CR>",
      }
    }
  },

  -- Additional configuration with keymaps
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    config = function()
      --------------------------------------------------
      -- KEYMAPS FOR BUFFER NAVIGATION
      --------------------------------------------------

      -- Navigate between buffers
      vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer', silent = true })
      vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer', silent = true })

      -- Alternative with Alt
      vim.keymap.set('n', '<M-l>', ':bnext<CR>', { desc = 'Next buffer', silent = true })
      vim.keymap.set('n', '<M-h>', ':bprevious<CR>', { desc = 'Previous buffer', silent = true })

      -- Close current buffer
      vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
      vim.keymap.set('n', '<leader>bD', ':bdelete!<CR>', { desc = 'Delete buffer (force)' })

      -- Close all buffers except current
      vim.keymap.set('n', '<leader>bo', ':%bd|e#|bd#<CR>', { desc = 'Delete other buffers' })

      -- Go to last buffer
      vim.keymap.set('n', '<leader>bl', '<C-^>', { desc = 'Last buffer' })

      -- List buffers with Telescope
      vim.keymap.set('n', '<leader>bb', ':Telescope buffers<CR>', { desc = 'List buffers' })

      --------------------------------------------------
      -- KEYMAPS FOR GLOBAL MARKS (A-Z)
      --------------------------------------------------

      -- Global marks (uppercase) persist between files
      -- Examples:
      -- mA - Mark position A in current file
      -- 'A - Go to mark A (jumps between files)

      -- List all marks
      vim.keymap.set('n', '<leader>ml', ':Telescope marks<CR>', { desc = 'List all marks' })

      -- Show current buffer marks
      vim.keymap.set('n', '<leader>mb', ':marks<CR>', { desc = 'Show buffer marks' })

      -- Delete all marks (a-z) from current buffer
      vim.keymap.set('n', '<leader>md', ':delmarks a-z<CR>', { desc = 'Delete all buffer marks' })

      -- Delete all global marks (A-Z)
      vim.keymap.set('n', '<leader>mD', ':delmarks A-Z<CR>', { desc = 'Delete all global marks' })

      --------------------------------------------------
      -- KEYMAPS FOR JUMPLIST (JUMP HISTORY)
      --------------------------------------------------

      -- Navigate through jump history
      vim.keymap.set('n', '<C-o>', '<C-o>zz', { desc = 'Jump to older position' })
      vim.keymap.set('n', '<C-i>', '<C-i>zz', { desc = 'Jump to newer position' })

      -- View jumplist with Telescope
      vim.keymap.set('n', '<leader>jl', ':Telescope jumplist<CR>', { desc = 'Show jumplist' })

      --------------------------------------------------
      -- USEFUL DEFAULT MARKS
      --------------------------------------------------
      -- `.  - Last edit
      -- `"  - Last position before exit
      -- `[  - Start of last change/yank
      -- `]  - End of last change/yank
      -- `<  - Start of last visual selection
      -- `>  - End of last visual selection

      -- Shortcuts for automatic marks
      vim.keymap.set('n', '<leader>m.', '`.', { desc = 'Go to last edit' })
      vim.keymap.set('n', '<leader>m"', '`"', { desc = 'Go to last position before exit' })
      vim.keymap.set('n', '<leader>m[', '`[', { desc = 'Go to start of last change' })
      vim.keymap.set('n', '<leader>m]', '`]', { desc = 'Go to end of last change' })

      --------------------------------------------------
      -- CREATE FUNCTION FOR QUICK MARKS
      --------------------------------------------------
      -- Function to mark important project files
      local function quick_mark_project_files()
        local os_utils = require("utils.os")
        local shell_config = os_utils.get_shell_config()

        local marks = {
          { key = 'C', file = vim.fn.stdpath('config') .. '/init.lua', desc = 'Config Neovim' },
          { key = 'S', file = shell_config, desc = 'Shell config' },
        }

        -- Add .bashrc only if it exists (Linux/macOS)
        if not os_utils.is_windows() and vim.fn.filereadable(vim.fn.expand('~/.bashrc')) == 1 then
          table.insert(marks, { key = 'B', file = '~/.bashrc', desc = 'Bash config' })
        end

        -- Add .zshrc only if it exists (Linux/macOS)
        if not os_utils.is_windows() and vim.fn.filereadable(vim.fn.expand('~/.zshrc')) == 1 then
          table.insert(marks, { key = 'Z', file = '~/.zshrc', desc = 'Zsh config' })
        end

        for _, mark in ipairs(marks) do
          vim.keymap.set('n', '<leader>m' .. mark.key, function()
            vim.cmd('edit ' .. mark.file)
            vim.cmd('normal! m' .. mark.key)
            vim.notify('Marked ' .. mark.desc .. ' as ' .. mark.key, vim.log.levels.INFO)
          end, { desc = mark.desc })
        end
      end

      quick_mark_project_files()

      --------------------------------------------------
      -- FUNCIÓN PARA MOSTRAR INFORMACIÓN DE BUFFERS
      --------------------------------------------------
      vim.keymap.set('n', '<leader>bi', function()
        local buffers = vim.api.nvim_list_bufs()
        local loaded = 0
        local modified = 0

        for _, buf in ipairs(buffers) do
          if vim.api.nvim_buf_is_loaded(buf) then
            loaded = loaded + 1
            if vim.api.nvim_buf_get_option(buf, 'modified') then
              modified = modified + 1
            end
          end
        end

        vim.notify(
          string.format('Buffers: %d loaded, %d modified', loaded, modified),
          vim.log.levels.INFO
        )
      end, { desc = 'Buffer info' })
    end,
  },
}
