local M = {}

function M.has_plugin(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(ok, string.format("error: %s not installed or failed to load", module_name))
  return module
end

function M.root_path()
  -- return project root path
  return "TODO: project root"
end

return M