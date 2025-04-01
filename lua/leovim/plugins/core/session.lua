return {
  -- Simple session management for Neovim
  -- automatically saves the active session under ~/.local/state/nvim/sessions on exit
  -- usage:
  -- :SessionLoadLast, :SessionLoadCurrent, :SessionStop, :SessionStart, :SessionSave
  -- Alternate: rmagatti/auto-session
  "folke/persistence.nvim",
  event = "VeryLazy",
  opts = {
    -- dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    pre_save = nil, -- a function to call before saving the session
  },

  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)

    -- load the session for the current directory
    vim.api.nvim_create_user_command("SessionLoad", function()
      persistence.load()
    end, {})
    -- restore(load) session
    vim.api.nvim_create_user_command("SessionLoadLast", function()
      persistence.load({ last = true })
    end, {})
    -- select a session to load
    vim.api.nvim_create_user_command("SessionSelect", function()
      persistence.select()
    end, {})
    -- save current session
    vim.api.nvim_create_user_command("SessionSave", function()
      persistence.save()
    end, {})

    -- start Persistence => session will be saved on exit
    vim.api.nvim_create_user_command("SessionStart", function()
      persistence.start()
    end, {})
    -- stop Persistence => session won't be saved on exit
    vim.api.nvim_create_user_command("SessionStop", function()
      persistence.stop()
    end, {})
  end,
}