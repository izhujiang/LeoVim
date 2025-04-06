return {
  {
    -- the colorscheme should be available when starting Neovim
    "ellisonleao/gruvbox.nvim",
    enabled = vim.g.colorscheme == "gruvbox",
    lazy = false,
    priority = 2000,
    opts = require("leovim.builtin.colorscheme").gruvbox and require("leovim.builtin.colorscheme").gruvbox.opts or {},
    config = function()
      vim.cmd.colorscheme(vim.g.colorscheme)
    end,
  },
  {
    -- tokyonight, A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins.
    "folke/tokyonight.nvim",
    enabled = vim.g.colorscheme == "tokyonight",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = require("leovim.builtin.colorscheme").tokyonight and require("leovim.builtin.colorscheme").tokyonight.opts
      or {},
    config = function()
      vim.cmd.colorscheme(vim.g.colorscheme)
    end,
  },
  {
    -- Everforest is a green based color scheme; it's designed to be warm and soft in order to protect developers' eyes.
    "sainnhe/everforest",
    enabled = vim.g.colorscheme == "everforest",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = require("leovim.builtin.colorscheme").everforest and require("leovim.builtin.colorscheme").everforest.opts
      or {},
    init = require("leovim.builtin.colorscheme").everforest and require("leovim.builtin.colorscheme").everforest.init,
    config = function()
      vim.cmd.colorscheme(vim.g.colorscheme)
    end,
  },
  {
    -- catppuccin, Soothing pastel theme for (Neo)vim
    -- usage:
    -- :colorscheme catppuccin " or catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    "catppuccin/nvim",
    enabled = vim.g.colorscheme == "catppuccin",
    name = "catppuccin",
    lazy = false,
    version = false, -- latest development version
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = require("leovim.builtin.colorscheme").catppuccin and require("leovim.builtin.colorscheme").catppuccin.opts
      or {},
    config = function()
      vim.cmd.colorscheme(vim.g.colorscheme)
    end,
  },
}