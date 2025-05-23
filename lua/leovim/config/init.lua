---@type LeoVimConfig
local M = {
  lazy_version = ">=9.1.0",
}

---@type LeoVimConfig
local options

-- setup: load "options, keymaps, and autocmds" and schedule colorscheme
---@param opts? LeoVimConfig
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {})

  require("leovim.config.options")
  require("leovim.config.keymaps")
  require("leovim.config.autocmds")
  require("leovim.config.lsp")
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast options LeoVimConfig
    return options[key]
  end,
})

return M