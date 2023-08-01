---@type LeoVimConfig
local M = {}

M.lazy_version = ">=9.1.0"

---@class LeoVimConfig
local defaults = {
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  ---@type string|fun()
  colorscheme = function()
    require("tokyonight").load()
  end,
  -- load the default settings
  defaults = {
    options = true, -- leovim.config.options
    keymaps = true, -- leovim.config.keymaps
    autocmds = true, -- leovim.config.autocmds
    -- leovim.config.options can't be configured here since that's loaded before leovim setup
    -- if you want to disable loading options, add `package.loaded["leovim.config.options"] = true` to the top of your init.lua
  },
  -- icons used by other plugins
  icons = {
    dap = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
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
      -- Error = " ",
      -- Warn = " ",
      -- Hint = " ",
      -- Info = " ",
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
}

---@type LeoVimConfig
local options

-- setup: check lazy.nvim, load "options, keymaps, and autocmds" and set colorscheme
---@param opts? LeoVimConfig
function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})
  if not M.has() then
    require("lazy.core.util").error(
      "**leovim** needs **lazy.nvim** version "
      .. M.lazy_version
      .. " to work properly.\n"
      .. "Please upgrade **lazy.nvim**",
      { title = "leovim" }
    )
    error("Exiting")
  end

  require("leovim.config.options")
  require("leovim.config.keymaps")
  require("leovim.config.autocmds")

  -- if vim.fn.argc(-1) == 0 then
  -- M.load("options")
  -- -- 	autocmds and keymaps can wait to load
  -- vim.api.nvim_create_autocmd("User", {
  -- 	group = vim.api.nvim_create_augroup("leovim", { clear = true }),
  -- 	pattern = "VeryLazy",
  -- 	callback = function()
  -- 		M.load("autocmds")
  -- 		M.load("keymaps")
  -- 	end,
  -- })
  -- else
  -- load them now so they affect the opened buffers
  -- M.load("keymaps")
  -- M.load("autocmds")
  -- end

  require("lazy.core.util").try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      require("lazy.core.util").error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
end

---@param range? string
function M.has(range)
  local Semver = require("lazy.manage.semver")
  return Semver.range(range or M.lazy_version):matches(require("lazy.core.config").version or "0.0.0")
end

-- ---@param name "autocmds" | "options" | "keymaps"
-- function M.load(name)
-- 	local Util = require("lazy.core.util")
-- 	local function _load(mod)
-- 		Util.try(function()
-- 			require(mod)
-- 		end, {
-- 			msg = "Failed loading " .. mod,
-- 			on_error = function(msg)
-- 				local info = require("lazy.core.cache").find(mod)
-- 				if info == nil or (type(info) == "table" and #info == 0) then
-- 					return
-- 				end
-- 				Util.error(msg)
-- 			end,
-- 		})
-- 	end
-- load options (mandatory), keymaps and autocmds (optional).
-- if M.defaults[name] or name == "options" then
-- _load("leovim.config." .. name)
-- end
-- 	_load("config." .. name)
-- 	if vim.bo.filetype == "lazy" then
-- 		-- HACK: leovim may have overwritten options of the Lazy ui, so reset this here
-- 		vim.cmd([[do VimResized]])
-- 	end
-- 	local pattern = "leovim" .. name:sub(1, 1):upper() .. name:sub(2)
-- 	vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
-- end

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
