return {
  opts = function()
    local status_ok, log = pcall(require, "structlog")
    if not status_ok then
      return nil
    end
    local log_level = log.level.WARN
    local log_path = string.format("%s/%s.log", vim.fn.stdpath("cache"), "leovim")
    return {
      -- builtin log
      leovim_log = {
        pipelines = {
          {
            level = log_level,
            processors = {
              log.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 2 }),
              log.processors.Timestamper("%H:%M:%S"),
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
              log.processors.Timestamper("%F %H:%M:%S"),
            },
            formatter = log.formatters.Format("%s [%-5s] %s: %-30s", { "timestamp", "level", "logger_name", "msg" }),
            sink = log.sinks.File(log_path),
          },
        },
      },
    }
  end,
}
