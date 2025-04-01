-- the colorscheme should be available when starting Neovim
return {
  {
    "ellisonleao/gruvbox.nvim",
    enabled = false,
    lazy = false,
    priority = 2000,
    config = true,
  },
  -- tokyonight, A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins.
  {
    "folke/tokyonight.nvim",
    enabled = false,
    -- lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = { style = "moon" },
  },
  -- Everforest is a green based color scheme; it's designed to be warm and soft in order to protect developers' eyes.
  {
    -- Everforest is a green based color scheme; it's designed to be warm and soft in order to protect developers' eyes.
    "sainnhe/everforest",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins

    init = function()
      -- config everforest init function, before ":colorscheme everforest"
      vim.g.everforest_background = "soft"
      vim.g.everforest_enable_italic = 1
      -- vim.g.everforest_disable_italic_comment = 1
      -- vim.g.everforest_transparent_background = 2
      -- vim.g.everforest_dim_inactive_windows = 1
      vim.g.everforest_show_eob = 0
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_line_highlight = 1
      -- vim.g.everforest_diagnostic_virtual_text = 'colored'
      -- vim.g.everforest_disable_terminal_colors = 1
      -- vim.g.everforest_lightline_disable_bold = 1
      vim.g.everforest_better_performance = 1
    end,
  },

  -- catppuccin, Soothing pastel theme for (Neo)vim
  -- usage:
  -- :colorscheme catppuccin " or catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    version = false, -- latest development version
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      default_integrations = true,
      integrations = {
        blink_cmp = true,
        illuminate = true,
        lsp_trouble = true,
        mason = true,
        navic = { enabled = true },
        neotest = true,
        nvimtree = true,
        noice = false,
        notify = true,
        which_key = true,
      },
    },
  },
}