--------------------------------------------------
-- LUALINE - Statusline
--------------------------------------------------

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic",
  },
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      icons_enabled = true,
      disabled_filetypes = {
        statusline = {},
        winbar = { 'dashboard', 'lazy', 'alpha', 'neo-tree', 'NvimTree' },
      },
    },

    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = { 'diagnostics' },
      -- lado derecho: mostrar LSP activos con estado de indexación
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return 'No LSP'
            end

            local status_parts = {}
            local has_progress = false

            -- Revisar si hay mensajes de progreso activos
            for _, client in ipairs(clients) do
              if client.name == 'intelephense' then
                -- Verificar el estado interno del servidor
                local messages = vim.lsp.util.get_progress_messages()
                for _, msg in pairs(messages) do
                  if msg.name == 'intelephense' and msg.done == false then
                    has_progress = true
                    break
                  end
                end
              end
            end

            -- Construir la lista de LSP con indicadores
            for _, client in ipairs(clients) do
              local name = client.name
              if name == 'intelephense' then
                if has_progress then
                  name = name .. ' ⏳ indexing...'
                else
                  name = name .. ' ✓'
                end
              end
              table.insert(status_parts, name)
            end

            return table.concat(status_parts, ', ')
          end,
          icon = '',
        }
      },
      lualine_y = {
        -- Show detailed LSP progress messages
        {
          function()
            local messages = vim.lsp.util.get_progress_messages()
            local lsp_msg = ''
            for _, msg in pairs(messages) do
              if msg.name and msg.title then
                local percentage = msg.percentage or 0
                if percentage > 0 then
                  lsp_msg = msg.name .. ': ' .. msg.title .. ' ' .. percentage .. '%'
                else
                  lsp_msg = msg.name .. ': ' .. msg.title
                end
                break -- Solo mostrar el primer mensaje activo
              end
            end
            return lsp_msg
          end,
          icon = '⏳',
        }
      },
      lualine_z = { 'location', 'progress' },
    },

    inactive_sections = {
      lualine_c = {},
      lualine_x = {},
    },

    -- Winbar con breadcrumbs usando navic
    -- Siempre muestra algo para evitar saltos visuales
    winbar = {
      lualine_b = {
        {
          'filename',
          path = 0, -- solo nombre del archivo
          file_status = true,
          symbols = {
            modified = ' [+]',
            readonly = ' [-]',
          },
        }
      },
      lualine_c = {
        {
          'navic',
          color_correction = 'dynamic',
          navic_opts = {
            highlight = true,
            separator = ' > ',
            depth_limit = 0,
            depth_limit_indicator = '..',
          },
        }
      },
    },

    inactive_winbar = {
      lualine_b = {
        {
          'filename',
          path = 0, -- solo nombre del archivo
          file_status = false,
        }
      },
      lualine_c = {},
    },
  },
}
