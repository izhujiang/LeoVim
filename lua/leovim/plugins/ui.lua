-- extensions of vim.ui
-- .. notify
-- .. input
-- .. select
-- .. winbar
-- .. statusline
-- .. tagpage(bufferline)
-- .. messages
-- .. cmdline
-- .. popupmenu
return {
  {
    -- Better `vim.notify()`
    -- A fancy, configurable, notification manager for NeoVim
    "rcarriga/nvim-notify",
    event = { "VeryLazy" },
    init = require("leovim.builtin.nvim-notify").init,
    opts = require("leovim.builtin.nvim-notify").opts or {},
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  {
    -- Statusline, A blazing fast and easy to configure neovim statusline plugin
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = require("leovim.builtin.lualine").init,
    opts = require("leovim.builtin.lualine").opts or {},
  },
  {
    -- nvim-navic, A simple statusline/winbar component that uses LSP to show your current code context.
    -- usage: call the functions:
    --  is_available(bufnr)
    --  get_location(opts, bufnr)
    "SmiteshP/nvim-navic",
    opts = {
      lsp = {
        auto_attach = true,
      },
      -- highlight = false,
      depth_limit = 5,
      -- lazy_update_context = true,
      icons = require("leovim.builtin.icons").kinds,
    },
    init = function()
      vim.g.navic_silence = true
      vim.opt.showtabline = 2
    end,
  },

  -- tabpages (bufferline.nvim, scope.nvim)
  {
    -- A snazzy buffer line for Neovim

    -- How to enable only buffers per tabpage?
    -- This behaviour is not native in neovim there is no internal concept of localised buffers to tabs as that is not how tabs were designed to work.
    -- They were designed to show an arbitrary layout of windows per tab.
    -- However, Combine "bufferline.nvim" with "scope.nvim" to achieve this kind of behaviour.
    -- Although a better long-term solution for users who want this functionality is to ask for real native support for this upstream.
    "akinsho/bufferline.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = require("leovim.builtin.bufferline").keys or {},
    opts = require("leovim.builtin.bufferline").opts or {},
  },

  {
    -- revolutionizes tab management by introducing scoped buffers.
    "tiagovla/scope.nvim",
    event = { "VeryLazy" },
    opts = {},
    -- init = function()
    -- Session Support
    -- vim.opt.sessionoptions = { -- required
    --     "buffers",
    --     "tabpages",
    --     "globals",
    -- }
    -- end,
  },
}