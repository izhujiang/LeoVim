return {
  -- the colorscheme should be available when starting Neovim
  -- tokyonight, A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins.
  -- {
  -- 	"folke/tokyonight.nvim",
  -- 	lazy = false,  -- make sure we load this during startup if it is your main colorscheme
  -- 	priority = 1000, -- make sure to load this before all the other start plugins
  -- 	opts = { style = "moon" },
  -- 	config = function()
  -- 		-- load and set colorscheme
  -- 		vim.cmd([[colorscheme tokyonight]])
  -- 	end,
  -- },
  {
    -- Everforest is a green based color scheme; it's designed to be warm and soft in order to protect developers' eyes.
    "sainnhe/everforest",
    -- "sainnhe/sonokai",
    -- name = "sonokai",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins

    dependencies = {
      { "nvim-lualine/lualine.nvim" },
    },

    config = function()
      local name = "everforest"
      vim.g.everforest_background = "soft"
      vim.g.everforest_better_performance = 1

      local status_ok, _ = pcall(vim.cmd.colorscheme, name)
      if not status_ok then
        return
      end

      if name == "everforest" then
        require("lualine").setup({
          options = {
            theme = "everforest",
          },
        })
      end
    end,
  },

  -- catppuccin, Soothing pastel theme for (Neo)vim
  -- usage:
  -- :colorscheme catppuccin " or catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
  -- TODO: config for integrations with other plugins
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        -- lsp_trouble = true,
        lsp_trouble = false,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true },
        neotest = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
}
