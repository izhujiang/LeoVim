local M = {
  lazy_version = ">=9.1.0",
}

local options = {}

-- load "options, keymaps, and autocmds" and schedule colorscheme
function M.load(opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {})

  -- disable syntax highlight, use nvim-treesitter to highlight instead
  -- vim.cmd("syntax off")

  require("leovim.config.options")
  require("leovim.config.keymaps")
  require("leovim.config.autocmds")
  require("leovim.config.lsp")
end

setmetatable(M, {
  __index = function(_, key)
    return options[key]
  end,
})

return M
