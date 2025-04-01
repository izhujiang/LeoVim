local M = {}

function M.has_plugin(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(ok, string.format("error: %s not installed or failed to load", module_name))
  return module
end

-- TODO: combine lsp root and git root
-- rules for root hierarchy:
--    lsp workspace folders
--    lsp root_dir
--    root pattern of filename of the current buffer
--    root pattern of cwd
--
-- root_dir = function()
--     return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
--   end,

function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.uv.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.uv.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.uv.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.uv.cwd()
  end
  ---@cast root string
  return root
end

return M