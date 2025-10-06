local function register_plugins(opts)
  opts.user_plugins = opts.user_plugins or "user.plugins"

  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
    end
  end
  vim.opt.rtp:prepend(lazypath)

  local lazy_opts = require("leovim.config.plugins.nvim-lazy").opts or {}
  lazy_opts = vim.tbl_deep_extend("force", lazy_opts, {
    spec = {
      { import = "leovim.plugins" },
      { import = opts.user_plugins },
    },

    -- local plugin projects
    -- dev = {
    --   path = "~/projects",
    --   patterns = {}, -- For example {"folke"}
    --   fallback = false, -- Fallback to git when local plugin doesn't exist
    -- },
  })

  require("lazy").setup(lazy_opts)
end

if vim.version().major == 0 and vim.version().minor < 11 then
  vim.notify("neovim-0.11 or newer is required", vim.log.levels.WARN)
end
if not jit then
  vim.notify("luaJIT is required", vim.log.levels.WARN)
end

-- nvim entry point

-- load core nvim config
require("leovim.config").load()

local only_neovim = false

if only_neovim then
  vim.cmd.colorscheme("habamax")
else
  register_plugins({ user_plugins = "user.plugins" })
end

-- lazy.nvim does NOT use Neovim's builtin plugin manager 'packages' and even
-- disables plugin loading completely (vim.go.loadplugins = false).
-- It takes over the complete startup sequence for more flexibility and better performance.

-- In practice, this means that step 11 of Neovim Initialization is done by Lazy:
--    -- All the plugins' init() functions are executed
--    -- All plugins with lazy=false are loaded. This includes sourcing /plugin
--    and /ftdetect files. (/after will not be sourced yet)
--    -- All files from /plugin and /ftdetect directories in your rtp are
--    sourced (excluding /after)
--    -- All /after/plugin files are sourced (this includes /after from plugins)
--
-- Files from runtime directories are always sourced in alphabetical order.
-- https://lazy.folke.io/usage#%EF%B8%8F-startup-sequence

-- Optimize performance
-- https://lazy.folke.io/usage/profiling
