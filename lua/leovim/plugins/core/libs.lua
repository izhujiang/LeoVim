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

  -- get_logger and use it in other place
  -- local logger = require("structlog").get_logger("leovim_log")
  -- logger:info("A log message") -- will not log whose log_level < warn
  -- logger:warn("A log message with keyword arguments", { warning = "something happened" })
  {
    "Tastyep/structlog.nvim",
    config = function()
      local status_ok, log = pcall(require, "structlog")
      if not status_ok then
        return nil
      end

      -- TODO: it's better to set log level with global option
      local log_level = log.level.WARN
      local log_path = string.format("%s/%s.log", vim.fn.stdpath('cache'), "leovim")
      log.configure({
        leovim_log = {
          pipelines = {
            {
              level = log_level,
              processors = {
                log.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 2 }),
                log.processors.Timestamper "%H:%M:%S",
              },
              formatter = log.formatters.FormatColorizer(
                "%s [%-5s] %s: %-30s",
                { "timestamp", "level", "logger_name", "msg" },
                { level = log.formatters.FormatColorizer.color_level() }
              ),
              sink = log.sinks.Console(false), -- async=false
            },
            {
              level = log_level,
              processors = {
                log.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = 2 }),
                log.processors.Timestamper "%F %H:%M:%S",
              },
              formatter = log.formatters.Format(
                "%s [%-5s] %s: %-30s",
                { "timestamp", "level", "logger_name", "msg" }
              ),
              sink = log.sinks.File(log_path),
            },
          },
        },
      })
    end
  },
}
