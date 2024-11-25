return {
  -- library (async, job) used by other plugins
  {
    "nvim-lua/plenary.nvim",
  },
  -- icons
  {
    "nvim-tree/nvim-web-devicons",
  },
  -- -- UI Component Library for Neovim
  -- {
  --   "MunifTanjim/nui.nvim",
  --    enbaled = false,
  -- },
  -- TODO: init log (ref: lunarvim core/log.lua)
  {
    "Tastyep/structlog.nvim",
    config = function()
      local status_ok, structlog = pcall(require, "structlog")
      if not status_ok then
        return nil
      end

      local log_level = "WARN"
      local log_path = string.format("%s/%s.log", vim.fn.stdpath('cache'), "leovim")
      structlog.configure {
        leovim = {
          pipelines = {
            {
              level = log_level,
              processors = {
                structlog.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 2 }),
                structlog.processors.Timestamper "%H:%M:%S",
              },
              formatter = structlog.formatters.FormatColorizer(
                "%s [%-5s] %s: %-30s",
                { "timestamp", "level", "logger_name", "msg" },
                { level = structlog.formatters.FormatColorizer.color_level() }
              ),
              sink = structlog.sinks.Console(false), -- async=false
            },
            {
              level = log_level,
              processors = {
                structlog.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = 2 }),
                structlog.processors.Timestamper "%F %H:%M:%S",
              },
              formatter = structlog.formatters.Format(
                "%s [%-5s] %s: %-30s",
                { "timestamp", "level", "logger_name", "msg" }
              ),
              sink = structlog.sinks.File(log_path),
            },
          },
        },
      }

      -- get_logger and use it in other place
      -- local logger = structlog.get_logger("leovim")
      -- logger:info("A log message")
      -- logger:warn("A log message with keyword arguments", { warning = "something happened" })
    end
  },
}
