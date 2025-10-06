local M = {
  root_pattern = ".git",
}

function M.has_plugin(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(ok, string.format("error: %s not installed or failed to load", module_name))
  return module
end

-- rules for root hierarchy:
--    lsp workspace folders
--    lsp root_dir
--    root pattern of filename of the current buffer
--    root pattern of cwd
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.uv.fs_realpath(path) or nil

  -- lsp root
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      ---@type vim.lsp.Client
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.uv.fs_realpath(p)
        if r and path:find(r, 1, true) then
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

  -- lsp root not available, find upward or cwd
  if not root then
    path = path and vim.fs.dirname(path) or vim.uv.cwd()
    ---@type string?
    root = vim.fs.find(M.root_pattern, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.uv.cwd()
  end
  ---@cast root string
  return root
end

function M.neovim_news()
  local news_file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1]
  if not news_file then
    vim.notify("Could not find news.txt", vim.log.levels.ERROR)
    return
  end

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Read the file into the buffer
  local lines = {}
  for line in io.lines(news_file) do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set buffer options
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  -- Calculate window dimensions (90% of editor size)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Set window options
  vim.wo[win].spell = false
  vim.wo[win].wrap = false
  vim.wo[win].signcolumn = "yes"
  vim.wo[win].statuscolumn = " "
  vim.wo[win].conceallevel = 3

  -- Set up keybinding to close the window
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
end

return M
