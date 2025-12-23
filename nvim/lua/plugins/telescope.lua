--------------------------------------------------
-- TELESCOPE ENHANCED - Fuzzy finder con extensiones
--------------------------------------------------

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",  -- FZF nativo para mejor rendimiento
    "nvim-telescope/telescope-ui-select.nvim",   -- Usar Telescope para vim.ui.select
    "debugloop/telescope-undo.nvim",             -- Navegación del historial de deshacer
  },

  keys = {
    -- Búsquedas básicas
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
    { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },

    -- Búsqueda por regexp (usa ripgrep directamente)
    {
      "<leader>fR",
      function()
        require('telescope.builtin').live_grep({
          additional_args = function()
            return { "--pcre2" }  -- Habilitar regex PCRE2
          end,
          prompt_title = "Live Grep (REGEX)"
        })
      end,
      desc = "Live grep with REGEX"
    },

    -- Búsqueda del texto bajo el cursor
    {
      "<leader>fw",
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = "Grep word under cursor"
    },

    -- Búsqueda en archivos ocultos
    {
      "<leader>fF",
      function()
        require('telescope.builtin').find_files({
          prompt_title = 'Find Files (including hidden)',
          hidden = true,
          no_ignore = true,
          follow = true,
          file_ignore_patterns = {
            "node_modules/",
            ".git/",
          }
        })
      end,
      desc = "Find files + hidden files"
    },

    -- Búsqueda en config de Neovim
    {
      "<leader>fc",
      function()
        require('telescope.builtin').find_files({
          cwd = vim.fn.stdpath('config'),
          prompt_title = 'Config NVIM'
        })
      end,
      desc = "Find files in Neovim config"
    },

    -- Live grep con filtro de patrones
    { "<leader>fG", desc = "Live grep with file filter" },

    -- Historial de comandos
    { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command history" },

    -- Historial de búsqueda
    { "<leader>f/", "<cmd>Telescope search_history<cr>", desc = "Search history" },

    -- Símbolos del documento
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },

    -- Diagnósticos
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },

    -- Git
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },

    -- Historial de deshacer
    { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo history" },

    -- Resume última búsqueda
    { "<leader>f.", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
  },

  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- Función personalizada para abrir múltiples archivos seleccionados
    local function multi_select_open(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local multi_selection = picker:get_multi_selection()

      if #multi_selection > 1 then
        -- Si hay múltiples archivos seleccionados, abrirlos todos
        actions.close(prompt_bufnr)
        for _, entry in ipairs(multi_selection) do
          vim.cmd(string.format("edit %s", entry.path or entry.filename))
        end
      else
        -- Si no hay selección múltiple, comportamiento normal
        actions.select_default(prompt_bufnr)
      end
    end

    -- Variable para mantener los patrones de archivo persistentes
    local file_patterns = {}

    -- Función personalizada para live grep con patrones
    local function live_grep_with_patterns()
      require('telescope.builtin').live_grep({
        additional_args = function()
          local args = {
            "--hidden",
            "-g", "!.env.*",
            "-g", "!node_modules/**",
            "-g", "!vendor/**",
          }

          -- Agregar patrones de archivo si existen
          for _, pattern in ipairs(file_patterns) do
            table.insert(args, "-g")
            table.insert(args, pattern)
          end

          return args
        end,
        prompt_title = string.format("Live Grep %s(Ctrl+G: add filter | Ctrl+Z: reset)",
          #file_patterns > 0 and "[" .. table.concat(file_patterns, ", ") .. "] " or ""),
        attach_mappings = function(prompt_bufnr, map)
          -- Ctrl+G: Agregar patrón de archivo
          map('i', '<C-g>', function()
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local current_query = current_picker:_get_prompt()

            vim.ui.input({
              prompt = 'File pattern (e.g., *.php, app/**/*.php): ',
              default = ''
            }, function(pattern)
              if pattern and pattern ~= '' then
                table.insert(file_patterns, pattern)
                actions.close(prompt_bufnr)

                -- Reabrir con el mismo query y los nuevos filtros
                vim.schedule(function()
                  require('telescope.builtin').live_grep({
                    default_text = current_query,
                    additional_args = function()
                      local args = {
                        "--hidden",
                        "-g", "!.env.*",
                        "-g", "!node_modules/**",
                        "-g", "!vendor/**",
                      }
                      for _, p in ipairs(file_patterns) do
                        table.insert(args, "-g")
                        table.insert(args, p)
                      end
                      return args
                    end,
                    prompt_title = string.format("Live Grep [%s] (Ctrl+G: add | Ctrl+Z: reset)",
                      table.concat(file_patterns, ", ")),
                    attach_mappings = function(pb, m)
                      m('i', '<C-g>', function()
                        actions.close(pb)
                        vim.schedule(function()
                          live_grep_with_patterns()
                        end)
                      end)
                      m('i', '<C-z>', function()
                        file_patterns = {}
                        actions.close(pb)
                        vim.schedule(function()
                          live_grep_with_patterns()
                        end)
                      end)
                      return true
                    end,
                  })
                end)
              end
            end)
          end)

          -- Ctrl+Z: Resetear patrones
          map('i', '<C-z>', function()
            file_patterns = {}
            actions.close(prompt_bufnr)
            vim.schedule(function()
              live_grep_with_patterns()
            end)
          end)

          return true
        end,
      })
    end

    vim.keymap.set('n', '<leader>fG', live_grep_with_patterns, { desc = 'Live grep with file filter' })

    -- Configuración de Telescope
    telescope.setup({
      defaults = {
        -- Apariencia
        prompt_prefix = "🔍 ",
        selection_caret = "➜ ",
        path_display = { "truncate" },

        -- Configuración del previewer
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },

        -- Habilitar resaltado en preview
        preview = {
          treesitter = true,
          highlight_limit = 100000,
        },

        -- Configurar grep previewer con highlight
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,

        -- Sorting
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },

        -- Mappings
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = multi_select_open,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = multi_select_open,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,
          },
        },

        -- File ignore patterns
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "vendor/",
          "%.jpg",
          "%.jpeg",
          "%.png",
          "%.svg",
          "%.otf",
          "%.ttf",
        },
      },

      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          sort_mru = true,
          ignore_current_buffer = true,
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        marks = {
          theme = "dropdown",
          previewer = false,
        },
        live_grep = {
          -- Configuración para resaltar matches en preview
          preview = {
            highlight_limit = 100000, -- Aumentar límite de resaltado
          },
          -- Habilitar highlight en preview para grep
          grep_previewer = require('telescope.config').values.grep_previewer,
        },
        grep_string = {
          preview = {
            highlight_limit = 100000,
          },
          grep_previewer = require('telescope.config').values.grep_previewer,
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {}
        },
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    })

    -- Cargar extensiones
    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
    telescope.load_extension('undo')
  end,
}
