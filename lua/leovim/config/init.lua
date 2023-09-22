---@type LeoVimConfig
local M = {}

M.lazy_version = ">=9.1.0"

---@class LeoVimConfig
local defaults = {
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  ---@type string|fun()
  colorscheme = function()
    require("everforest").load()
    -- require("tokyonight").load()
  end,
  -- icons used by other plugins
  icons = {
    dap = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      -- Breakpoint = " ",
      Breakpoint = " ",
      BreakpointCondition = " ",
      BreakpointRejected = { " ", "DiagnosticError" },
      LogPoint = ".>",
    },
    diagnostics = {
      Error = { name = "DiagnosticSignError", symbol = "" },
      Warn = { name = "DiagnosticSignWarn", symbol = "" },
      Hint = { name = "DiagnosticSignHint", symbol = "" },
      Info = { name = "DiagnosticSignInfo", symbol = "" },
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
    },
    kinds = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = "󰊕 ",
      Interface = "󰌗 ",
      Key = "󰌋 ",
      Keyword = " ",
      Method = "m ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = " ",
      Object = " ",
      Operator = "󰆕 ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = "󰎠 ",
      Variable = " ",
    },
    misc = {
      Robot = "󰚩 ",
      Squirrel = " ",
      Tag = " ",
      Watch = " ",
      Smiley = " ",
      Package = " ",
      CircuitBoard = " ",
    },
  },
  non_essential_filetypes = {
    "help",
    "qf",
    "neo-tree",
    "spectre_panel",
    "fugitive",
    "toggleterm",
    "Trouble",
    "neotest-output-panel",
    "neotest-summary",
  }
}

---@type LeoVimConfig
local options

-- setup: check lazy.nvim, load "options, keymaps, and autocmds" and schedule colorscheme
---@param opts? LeoVimConfig
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  require("leovim.config.options")
  require("leovim.config.keymaps")
  require("leovim.config.autocmds")

  -- TODO:speedup loading plugings before colorscheme
  -- vim.schedule(function()
  --   if type(opts.colorscheme) == "function" then
  --     opts.colorscheme()
  --   else
  --     vim.cmd.colorscheme(opts.colorscheme)
  --   end
  -- end)
end

---@param range? string
function M.has(range)
  local Semver = require("lazy.manage.semver")
  return Semver.range(range or M.lazy_version):matches(require("lazy.core.config").version or "0.0.0")
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
