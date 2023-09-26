return {
  -- the colorscheme should be available when starting Neovim
  -- tokyonight, A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins.
  {
    "folke/tokyonight.nvim",
    -- NOTE: enable it when wanted
    enabled = false,
    -- lazy = true,
    event = "VeryLazy",
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = { style = "moon" },
    config = function()
      -- load and set colorscheme
      -- vim.cmd([[colorscheme tokyonight]])
    end,
  },
  -- Everforest is a green based color scheme; it's designed to be warm and soft in order to protect developers' eyes.
  {
    "sainnhe/everforest",
    -- "sainnhe/sonokai",
    -- lazy = true,
    event = "VeryLazy",
    priority = 1000, -- make sure to load this before all the other start plugins

    -- dependencies = {
    --   { "nvim-lualine/lualine.nvim" },
    -- },

    config = function()
      vim.g.everforest_background = "soft"
      vim.g.everforest_better_performance = 1

      -- vim.cmd([[colorscheme everforest]])
      -- local status_ok, _ = pcall(vim.cmd.colorscheme, "everforest")
      -- if not status_ok then
      --   return
      -- end

      -- require("lualine").setup({
      --   options = {
      --     theme = "everforest",
      --   },
      -- })
    end,
  },

  -- catppuccin, Soothing pastel theme for (Neo)vim
  -- usage:
  -- :colorscheme catppuccin " or catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- NOTE: enable it when wanted
    enabled = false,
    event = "VeryLazy",
    opts = {
      integrations = {
        alpha = true,
        cmp = true,
        dap = {
          enabled = true,
          enable_ui = true, -- enable nvim-dap-ui
        },
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = false,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
          inlay_hints = {
            background = true,
          },
        },
        navic = { enabled = true },
        neotest = true,
        nvimtree = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = {
          enabled = true,
          -- style = "nvchad"
        },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}