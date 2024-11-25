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

    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)

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

  -- project management
  -- TODO: failed to change cwd, nvim restore cwd after a project is selected from Telescope projects
  {
    "ahmedkhalf/project.nvim",
    opts = {
      -- Methods of detecting the root directory. **"lsp"** uses the native neovim lsp, while **"pattern"** uses vim-rooter like glob pattern matching.
      -- Here order matters: if one is not detected, the other is used as fallback.
      detection_methods = { "lsp", "pattern" },

      -- All the patterns used to detect root dir, when **"pattern"** is in detection_methods
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

      -- Table of lsp clients to ignore by name
      -- eg: { "efm", ... }
      ignore_lsp = {},

      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},

      -- Show hidden files in telescope
      show_hidden = false,

      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      silent_chdir = true,

      -- What scope to change the directory, valid options are
      -- * global (default)
      -- * tab
      -- * win
      scope_chdir = "global",

      -- Path where project.nvim will store the project history for use in
      -- telescope
      datapath = vim.fn.stdpath("data"),
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },
}