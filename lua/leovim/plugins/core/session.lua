return {
  -- Simple session management for Neovim
  -- automatically saves the active session under ~/.local/state/nvim/sessions on exit
  -- usage:
  -- :SessionLoadLast, :SessionLoadCurrent, :SessionStop, :SessionStart, :SessionSave
  "folke/persistence.nvim",
  -- enabled = false,
  event = "BufReadPre",
  opts = {
    -- dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    pre_save = nil, -- a function to call before saving the session
  },

  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)

    vim.api.nvim_create_user_command("SessionLoadLast", function()
      persistence.load({ last = true })
    end, {})
    -- restore the session for the current directory
    vim.api.nvim_create_user_command("SessionLoadCurrent", function()
      persistence.load()
    end, {})
    -- stop Persistence => session won't be saved on exit
    vim.api.nvim_create_user_command("SessionStop", function()
      persistence.stop()
    end, {})
    -- start Persistence => session will be saved on exit
    vim.api.nvim_create_user_command("SessionStart", function()
      persistence.start()
    end, {})
    -- save current session
    vim.api.nvim_create_user_command("SessionSave", function()
      persistence.save()
    end, {})
  end,
}