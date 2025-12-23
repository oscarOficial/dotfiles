--------------------------------------------------
-- HARPOON - Navegación rápida entre archivos
-- Marca archivos importantes y salta entre ellos rápidamente
--------------------------------------------------

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  keys = {
    -- Agregar archivo actual a harpoon
    {
      "<leader>ha",
      function()
        require("harpoon"):list():add()
        vim.notify("Archivo agregado a Harpoon", vim.log.levels.INFO)
      end,
      desc = "Harpoon: Add file"
    },

    -- Show harpoon menu
    {
      "<leader>hh",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon: Toggle menu"
    },

    -- Navegación rápida con números
    {
      "<leader>1",
      function() require("harpoon"):list():select(1) end,
      desc = "Harpoon: File 1"
    },
    {
      "<leader>2",
      function() require("harpoon"):list():select(2) end,
      desc = "Harpoon: File 2"
    },
    {
      "<leader>3",
      function() require("harpoon"):list():select(3) end,
      desc = "Harpoon: File 3"
    },
    {
      "<leader>4",
      function() require("harpoon"):list():select(4) end,
      desc = "Harpoon: File 4"
    },
    {
      "<leader>5",
      function() require("harpoon"):list():select(5) end,
      desc = "Harpoon: File 5"
    },

    -- Navegación con Ctrl+hjkl (alternativa)
    {
      "<C-h>",
      function() require("harpoon"):list():prev() end,
      desc = "Harpoon: Previous file"
    },
    {
      "<C-l>",
      function() require("harpoon"):list():next() end,
      desc = "Harpoon: Next file"
    },

    -- Usar Telescope para ver archivos de harpoon
    {
      "<leader>fH",
      function()
        local harpoon = require("harpoon")
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
          end

          require("telescope.pickers").new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          }):find()
        end

        toggle_telescope(harpoon:list())
      end,
      desc = "Harpoon: Telescope"
    },
  },

  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.loop.cwd()  -- Archivos por proyecto
        end,
      },
    })

    -- Integración con Telescope
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open harpoon window with Telescope" })
  end,
}
