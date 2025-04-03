return {
  {
    -- library (async, job) used by other plugins
    "nvim-lua/plenary.nvim",
  },
  {
    -- A library for asynchronous IO in Neovim
    "nvim-neotest/nvim-nio",
  },
  {
    -- Provides Nerd Font icons (glyphs)
    "nvim-tree/nvim-web-devicons",
  },
  { "MunifTanjim/nui.nvim" },
  {
    -- icon provider.
    "echasnovski/mini.icons",
  },
  {
    -- Structured Logging library
    -- usage:
    --  local logger = require("structlog").get_logger("leovim_log")
    --  logger:info("A log message") -- will not log whose log_level < warn
    --  logger:warn("A log message with keyword arguments", { warning = "something happened" })
    "Tastyep/structlog.nvim",
    opts = require("leovim.builtin.structlog").opts or {},
    config = function(_, opts)
      local status_ok, log = pcall(require, "structlog")
      if not status_ok then
        return nil
      end
      log.configure(opts)
    end,
  },
}