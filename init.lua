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

  -- When import specs, override them by simply adding a spec for the same plugin to your local specs,
  --    -- opts, dependencies, cmd, event, ft and keys are always merged with the parent spec.
  --    -- any other property will override the property from the parent spec.
  require("lazy").setup({
    -- update & upgrade (add, replace and delele) plugins, ref https: //www.lazyvim.org/news
    spec = {
      { import = "leovim.plugins.core" },
      { import = "leovim.plugins.dev" },
      { import = "leovim.plugins.extra" },
      -- { import = "leovim.plugins.langs" },

      -- import any extras modules here
      { import = opts.user_plugins },
    },
    defaults = {
      -- set this to `true` to have all your plugins lazy-loaded by default.
      lazy = true,
      -- the latest stable version for plugins that support semver
      version = "*",
    },
    install = {
      -- install missing plugins on startup.
      missing = true,
      -- colorscheme that will be used when installing plugins.
      colorscheme = { "habamax" },
    },
    ui = {
      border = "single",
    },
    -- dev = {
    -- 	-- directory where you store your local plugin projects
    -- 	path = "~/projects",
    -- 	---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    -- 	patterns = {}, -- For example {"folke"}
    -- 	fallback = false, -- Fallback to git when local plugin doesn't exist
    -- },
    checker = {
      enabled = false,
      frequency = 604800, -- check for updates every week 60*60*24*7
    }, -- automatically check for plugin updates
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end

-- enable lsp's debug mode
vim.lsp.set_log_level(vim.log.levels.ERROR)
-- Profiling Neovim Startup
if vim.env.PROF then
  -- path of plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end

if not vim.fn.has("nvim-0.10") then
  vim.notify("nvim-0.10 or newer is required", vim.log.levels.WARN)
end
if not jit then
  vim.notify("luaJIT is required", vim.log.levels.WARN)
end

-- nvim entry point

-- setup core nvim config
require("leovim.config").setup()

local only_neovim = false

if only_neovim then
  vim.cmd.colorscheme("habamax")
else
  register_plugins({ user_plugins = "user.plugins" })
  vim.cmd.colorscheme("everforest")
  -- vim.cmd.colorscheme("catppuccin")
end
-- TODO: it's better to colorscheme asynchronously, not here
-- must colorscheme after bufferline.nvim is loaded

-- lazy.nvim does NOT use Neovim's builtin plugin manager 'packages' and even
-- disables plugin loading completely (vim.go.loadplugins = false). It takes
-- over the complete startup sequence for more flexibility and better
-- performance.
--
-- In practice this means that step 10 of Neovim Initialization is done by Lazy:
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