return {
  -- A plugin for profiling Vim and Neovim startup time.
  -- usage
  -- :StartupTime
  -- Press K on events to get additional information.
  -- Press gf on sourcing events to load the corresponding file in a new split.
  -- :help startuptime-configuration for details on customization options.
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Simple session management for Neovim
  -- automatically saves the active session under ~/.local/state/nvim/sessions on exit
  -- usage:
  -- :LoadLastSession, :LoadCurrentSession, :StopSession, :StartSession, :SaveSession
  {
    "folke/persistence.nvim",
    enabled = false,
    event = "VimEnter",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil, -- a function to call before saving the session
    },

    config = function()
      local persistence = require("persistence")
      persistence.setup()

      vim.api.nvim_create_user_command("LoadLastSession", function()
        persistence.load({ last = true })
      end, {})
      -- restore the session for the current directory
      vim.api.nvim_create_user_command("LoadCurrentSession", function()
        persistence.load()
      end, {})
      -- stop Persistence => session won't be saved on exit
      vim.api.nvim_create_user_command("StopSession", function()
        persistence.stop()
      end, {})
      -- start Persistence => session will be saved on exit
      vim.api.nvim_create_user_command("StartSession", function()
        persistence.start()
      end, {})
      -- save current session
      vim.api.nvim_create_user_command("SaveSession", function()
        persistence.save()
      end, {})
    end,
  },

  -- library (async, job) used by other plugins
  {
    "nvim-lua/plenary.nvim",
    -- event = "VeryLazy"
  },

  -- icons
  {
    "nvim-tree/nvim-web-devicons",
    -- event = "VeryLazy",
  },
}