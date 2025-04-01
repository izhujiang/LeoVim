return {
  -- How to enable only buffers per tabpage?
  -- This behaviour is not native in neovim there is no internal concept of localised buffers to tabs as that is not how tabs were designed to work.
  -- They were designed to show an arbitrary layout of windows per tab.

  -- However, Combine "bufferline.nvim" with "scope.nvim" to achieve this kind of behaviour.
  -- Although a better long-term solution for users who want this functionality is to ask for real native support for this upstream.
  {
    -- A snazzy buffer line for Neovim
    "akinsho/bufferline.nvim",
    -- enabled = false,
    event = { "VeryLazy" },
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
      },
    },
    -- keys = {
    --   -- different from next buffer ]b when mode = "tabs",
    --   -- use gt/gT to switch tabs
    --   { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next bufferline" },
    --   { "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", desc = "Nrevious bufferline" },
    --   { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump buffer" },
    --   { "<leader>bd", "<cmd>BufferLinePickClose<cr>", desc = "Close buffer" },
    --   { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close left" },
    --   { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close right" },
    --   { "<leader>bs", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
    --   { "<leader>bS", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language" },
    --   { "<leader>bP", "<Cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
    -- },
    opts = function()
      return {
        options = {
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          -- style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.default,
          themable = true, -- allows highlight groups to be overridden i.e. sets highlights as default
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or " ")
              s = s .. n .. sym
            end
            return s
          end,

          show_buffer_close_icons = false,
          show_close_icon = false,
          show_tab_indicators = true,
          separator_style = "thin", --"slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          sort_by = "id",

          hover = { enabled = false },
          always_show_bufferline = true, -- cause vim.o.showtabline = 2
          offsets = {
            {
              filetype = "NvimTree", -- or "neo-tree" dependent on which file explorer is used
              text = "Explorer",
              highlight = "Directory",
              text_align = "left",
              -- separator = true,
              -- padding = 5,
            },
            {
              filetype = "neo-tree",
              text = "Explorer",
              highlight = "Directory",
              text_align = "left",
              -- separator = true,
            },
            {
              filetype = "undotree",
              text = "Undotree",
              highlight = "PanelHeading",
            },
            {
              filetype = "DiffviewFiles",
              text = "Diff View",
              highlight = "PanelHeading",
            },
            {
              filetype = "lazy",
              text = "Lazy",
              highlight = "PanelHeading",
            },
          },
        },

        -- when colors_name changed, theme should change too.
        highlights = (vim.g.colors_name or ""):find("catppuccin") and require(
          "catppuccin.groups.integrations.bufferline"
        ).get() or {
          buffer_selected = {
            bold = true,
            italic = true,
          },
        },
      }
    end,
  },

  {
    -- revolutionizes tab management by introducing scoped buffers.
    "tiagovla/scope.nvim",
    event = { "VeryLazy" },
    config = true,
    -- init = function()
    -- vim.opt.sessionoptions = { -- required
    --     "buffers",
    --     "tabpages",
    --     "globals",
    -- }
    -- end,
  },
}